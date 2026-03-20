Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF22410987AB
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 16:35:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A881F6B00BE; Fri, 20 Mar 2026 12:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A11766B00C5; Fri, 20 Mar 2026 12:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 861B26B00BE; Fri, 20 Mar 2026 12:35:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 700196B00BE
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:35:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3C3CAB7A26
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:35:15 +0000 (UTC)
X-FDA: 84566991390.27.4CF193A
Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2A12BC000B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:35:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=Hv3tI7JR;
	spf=pass (imf22.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774024513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZOAuFTk2fYZ7Opzh+m6bCHOI9jrLB+RqVBg8xOebPgo=;
	b=IxQOaA/EggShyhLLHBwk6HO2gAv8eFZ0Ve//uVwtubLIUR7nL7G82vsViPRiU+j63jC0so
	LV6BNE8YyC3fLFznmkpkZRmS1Nfpm8YWLVKbpU+myxiDoUm4G+F0dq/0dLvmjRDm2vR7V8
	ZQi8Bt2Ag5UH5/h0cSsMvkYEWlBYEus=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774024513; a=rsa-sha256;
	cv=pass;
	b=qzWsNdQ8UKsgg6LFF79RDUuUqeA974oRefEdMpUSkEzyq7/un1c/KYBuwLMsLeLEYG9kbj
	6K5STOyI2OlhZpfIPQuawC8h8Q6TfFoLnqUyfgFa8X4lF9h/YP0qBgf3j1OPIjRjI+vxXI
	xVMzag7k+g+WHm293wrY27A8lbkY+vs=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=Hv3tI7JR;
	spf=pass (imf22.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Seal: i=1; a=rsa-sha256; t=1774024502; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=ib8kwpn8dNp5OZHqnnzAbKJMATnVcFDJQg/zVJjEF1X/W6cFlqFAqO1K1iCTAYWKYS0T/lL1cbcdd7df3OTiTXx9aA8VY39fW7R9JEZneHJRIy6Y9/EGvCO5UXuILJ+MQ4fKLiv982Uz1hIXBvLH31q7bDV0jFGgCSXLuqdIJ90=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774024502; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=ZOAuFTk2fYZ7Opzh+m6bCHOI9jrLB+RqVBg8xOebPgo=; 
	b=jsnsQuHIDz3A0KEJON+y3CqSj39VA3pUL/1HvoeZwBvxeYvqUpQ2qw7u1xvYa7xZ7YjqHj+c41eqZEoaym4OSK4IsyMX9ZjMufI0AxRyqiw9vzBcySSfGECwXx8/BJXI/6ALhSDxoob7fzu8Pvs/aqhJS/d3v8/XgHeZa1E0hgg=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774024502;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=ZOAuFTk2fYZ7Opzh+m6bCHOI9jrLB+RqVBg8xOebPgo=;
	b=Hv3tI7JRMvRtELu3gZiddNNmKoqDZ6PrKjuxj5ABQajrVO4wSE6xhrnmoyYdTpmO
	1j8ztNQo67K8kOPwH8LK3veR1tF6bzuetMg/2tSNsUj/9iwoZFMrYaHUH2Uhlf9Ki/D
	UTAzpBVNaBt1x/3LQd2dvkFiHrIKB4+OgO3VdU9k=
Received: by mx.zoho.eu with SMTPS id 1774024499391760.4421752723017;
	Fri, 20 Mar 2026 17:34:59 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/damon/sysfs: check contexts->nr in repeat_call_fn
Date: Fri, 20 Mar 2026 16:34:56 +0000
Message-Id: <20260320163456.177750-3-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260320163456.177750-1-objecting@objecting.org>
References: <20260320163456.177750-1-objecting@objecting.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2A12BC000B
X-Stat-Signature: oxxyusg449fctr95c4a85dnp1duogz3i
X-Rspam-User: 
X-HE-Tag: 1774024512-499662
X-HE-Meta: U2FsdGVkX188t2L9cH1fmt70NV2Sq/vHnoRZ6ZXeLqKpTnS3u1DrjaKD8k8gKcd4+EuiHDDCZblAmIQ8XmfzRuMcRLDTR4U5xBnu+JTL6ZhaB1g99IlcmxuGsq1j5Q262JlysU/MaXXSW2giEewuaKJIN0tDWvPpA1lRCXpiTAC2zNngWYBvQjn9hNjO6hi+MBS8qbL9IDiVkVLGu6jXHTqmtYbFc/mx0wtkma/gpbobr9lg0I5a5k6pzFjEExulpK3d1ax4j7LOeSHtsbgEjbSlFU5NFKLihkr7xQ4N6q4PYaRrSFOS9+KQ8apf10GcTJo39nRnMbqL05Kq2li7VUkLKOhg0bXIZem4f0/JmCneRdCetFl55YKFuVZcOxFmWEvvzXbbKHS77NpgJLwmaa/G/xzP6XbXL4b7G0OEXxs2SPaaZnIzE3Y6hdRgH0aZL98Dg8xzzXharaPSchQAp//Xz/ULjmXUuQoc1HwfuDKR6MMhk0BPGmi9J/2YswbXOpR3w8eDrcXakO9qHi5xox0gPC2IAl8T1E3T25PiCCFIKW9iyFz2HgiMMvN/Y6quNMfsN4FQUBb3p07g0HWtJOZu8x+S6chziFkflxGrVRs76dkFsfZkW9kJP3A/vRE8S21G3U1BfioqA7H5cgdUgXdUZd4njkvIO7ZkPxTQzrRzU/N0p5ysXDBFMVhUzaWpDIf2LVHcweIRa9EXhCIyNssFKRcpzC87A5SUw8iXrXoAemtJ15znCbJvSUyj4FrZWDOJT6BMKnhl58i4mGXa3RzaRaZt+k2ST+nBTC3O1bSpifk4UY64Xi/rVlEUuWHCqQJlxeE9nsNJbe+yy/yc7QPwyDqoNsGP/BmY6Vmr7QiR+OvB9bINqevqwn3cUYXThkGnEOQOregkeUdfOgpiaIJRxfXjc9mflCcG4bdyRQoijQOsge89ADo/F3Oa5DbxVHJVY+aMVY4wZkxtcUo
 epXfjYNe
 zAZaKaAyH7auFE8BSBQstSpP67Xe5OzxLAgGqzRTVtDPcmYCwTaSWyRQmmq4615RhC3YKBPe3V1nW2lYfsQSlCetouG+fSly/KnqWsi8nqnaeOUU4GSptm8GnpnJRDRS6COK4ffQ5J7crEPJb+k9k9JaVQyxfok9a4uBYZNhUucIQzraQJbvhQzqmPHvBiso6rV7olCbqfhq2dkazkPHDh9OQE1IP92BqzJhri8tRaJuI2f9O8vX5gkpjKZ/r1nDZ00TlpHEKREcpdVCgwsibKz7g+IWkqb9hSUW91c9SdozrZ0Ol5XrxN2vf36x5C6WP4Kr3m7NfsqduT+ClpxdbMIhNB5liADfFI3pCfnjgnfrV10tf11VnepnJlsE9cYAOHat9ZLcPgCP0PcUMTaGL2Iv8OkPuqqrGYesQWVZmWpshnOo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_repeat_call_fn() calls damon_sysfs_upd_tuned_intervals(),
damon_sysfs_upd_schemes_stats(), and
damon_sysfs_upd_schemes_effective_quotas() without checking
contexts->nr.  If nr_contexts is set to 0 via sysfs while DAMON is
running, these functions dereference contexts_arr[0] and cause a NULL
pointer dereference.  Add the missing check.

Fixes: d809a7c64ba8 ("mm/damon/sysfs: implement refresh_ms file internal work")
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index ddc30586c0e6..6a44a2f3d8fc 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1620,9 +1620,12 @@ static int damon_sysfs_repeat_call_fn(void *data)
 
 	if (!mutex_trylock(&damon_sysfs_lock))
 		return 0;
+	if (sysfs_kdamond->contexts->nr != 1)
+		goto out;
 	damon_sysfs_upd_tuned_intervals(sysfs_kdamond);
 	damon_sysfs_upd_schemes_stats(sysfs_kdamond);
 	damon_sysfs_upd_schemes_effective_quotas(sysfs_kdamond);
+out:
 	mutex_unlock(&damon_sysfs_lock);
 	return 0;
 }
-- 
2.34.1


