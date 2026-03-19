Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B669109023F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 15:58:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D29AB6B0517; Thu, 19 Mar 2026 11:57:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDA666B0518; Thu, 19 Mar 2026 11:57:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF1A36B0519; Thu, 19 Mar 2026 11:57:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B12936B0517
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:57:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6EF55C09F4
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:57:59 +0000 (UTC)
X-FDA: 84563268678.27.2F93F64
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf20.hostedemail.com (Postfix) with ESMTP id 65C501C000E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:57:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=jziCpude;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	spf=pass (imf20.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773935877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VCdnk7LCAdQl2Oinq44p2WouG2Ln6vJSbhR4GoqiOIc=;
	b=C0y96JSZZYnCQC/t4xmatU+oMJc1qUCGuewk3xEH6KxAZnhKkamOaOYnNl0cl7cCLesOY6
	ciKtUKll+MS1on3EK2rGjdmFdiP9tnzMSnrORMf+guUGGkx8k86N8YqA8H4qNSnxJRiKrW
	I59K2hquNm1EBb/P0/s+TRGCwDFIV+Q=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773935877; a=rsa-sha256;
	cv=pass;
	b=qinv6gVW2LOA7lTFfw32Xv3M3/AeRcMnllW6sM8Vz3dOAFFfb/yLLwlVanyFp/k2rSyn8x
	McOvaiWpPI85D6pPw7z/cL3s0QUzojWwP+Z+yk7fqEzYdEYVTS42fVva+b14NlIdTc1Ct9
	0IUlq3uLf34ZtplZ3d9eNK84As5XtuE=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=jziCpude;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	spf=pass (imf20.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Seal: i=1; a=rsa-sha256; t=1773935866; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=cZWR/Rkxj1mC+DXgVZG57Be1vldOsmajFeB0+WgVBbAWDLVaEyJUWS0DssGHHobkV9JlaC9yQZMWmCEKGNcWNvSH8xbtdsIZ7kOi7oXEBQMtvJcKYTydh6nr25mQUNGwzAaw7+/uYT94NMGQO08X/kepJtyDARH+8uqjjPlHVKo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1773935866; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=VCdnk7LCAdQl2Oinq44p2WouG2Ln6vJSbhR4GoqiOIc=; 
	b=FpY9eFVneWtMNhwTt6wg/IjSOUw9LAVw7w2LP5frop0WtrtvhVW1APRu6QcLEZNZgFB60nQvfGy6qEG1M7ReqtYcbkupjKnT23hvijoWc8TdMK9eXx7a+rxiO7glkQYICGGFnaS5j31doVRRzGK2ctk/QgqwujH96ahDPH0YSU8=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1773935866;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=VCdnk7LCAdQl2Oinq44p2WouG2Ln6vJSbhR4GoqiOIc=;
	b=jziCpudeDNVDmPyr3561UEvWdaVDVwTSd95V9uGmdiN1TUKpqm+em7I5nGHSKs3g
	fF40Zk/ylVrPhxFQ6vJwZzd8A7iuGK/uT0TCMvDULjT98mBA39e8wG7ZfidoAJonY3d
	aDy0amaHOZSDFGU9bCZ+zWvyKBW3o8zILKvv1ORE=
Received: by mx.zoho.eu with SMTPS id 1773935865996405.19165630086957;
	Thu, 19 Mar 2026 16:57:45 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH 3/4] mm/damon/sysfs: check contexts->nr in update_schemes_tried_regions
Date: Thu, 19 Mar 2026 15:57:41 +0000
Message-Id: <20260319155742.186627-4-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260319155742.186627-1-objecting@objecting.org>
References: <20260319155742.186627-1-objecting@objecting.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Stat-Signature: a54n9htph31ty5pn7xqc5ytcb44smfgm
X-Rspamd-Queue-Id: 65C501C000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1773935877-132061
X-HE-Meta: U2FsdGVkX18Ei87XaO25jqR8KEv/Q0ylHXvJ6RuSd/qLXf7Rk5MeVBApMhoQGLq/RVFSgqWEGcIb6Xjnq74a1eeVOliEpAdY1z0I6wZ1PHGTDwpOg2sCcuqfAhaQE+odHFHeGbYGvQpwgQh4gdFNN3ntNOT1oouBbAn368iRiaV4ZUZTLsp+FjbwZqn7tefsudR5rhDnaXGbLXEO/fnCP7RBRRuNQx83BmUI1daHwvHmwyVgF72vR7SVgBb8YA6USWgA2Sd3/spiridlY4cDFJtzMHNkV9AV9Wx2ITrX0zBso50CZalwPZHqSwrYrMkzvz8TEDBdmavV5ZFwJijjpiK5sR8VN1cMmQHih9Y5DKuyO/OQTK0UNe3qsGqLJ8qj3L0nThAk5I22z7UPoyEmx+/+HWXcBPMwcIznj+BRODdGt2wJJa1QqVwUOOrmSjJVDP2rDTZzHj+KdQts7ElTFBLvTvaQSoQkaPCAatjncUdVcK/fUcp1ydUEWbok5r277buXJ6GeCH6N9tjiDqdSpW9w7AjVi1twEWF/n9fgQU9CWwU6wxYVqjhcd2FWogOS97Q8SIrTaJtWXqHzJgwlFAGRDSfEmOoHrPdGTaAhLodf7t4VNGcdDqjazc0fHh3H/UVRzg2Wic9YKOrg4CTLLiu795oqhiTZJGctalQWm7DWECsGs8QoXs35BzzYFdPZ7Tg0HWSKNzC2W9+EdvOMjSXpPN2/YzQ65V4e7XzmIRCep9pNEcHREq/W2sJBZ1k9PqquCJaQeV7gnRVBURVUXeH2IbL5TvQWlm+esGfoLhZp38RTJ1cnU+IvmOasz0TzoE4rcZ/bSzPtwgyEocJZXNnfWqkgDvMOnrqQh7zsk7+tLoEXtDxQ9jEPiTu+biUEKxqlqa7sVxMjyC6KDoNQYkVS65pI+8HB3pJwrNB/TLzI5pCL+fAzexTNoqqc+CnpgZ1PTGz9mknpJeGIpwq
 pN58n54F
 gyRwwc+JwLzgA9KMSHzL7K6HJwWQIiMcxX5aoutKn8afeUtia+tPlxewpQDuRhEFmPodED/o2AbKVWZaXr+vtMlyRvyQj5x57tt5Bv+/wtXZgtXbb9gi4R8GQ8LcoppOkx7rtES65Ld1MipwaaEl7l+DB3CVppibpoLATL8at9L6q5qlGZpsWRI1OGiyEw1BRM13Q/wrL77VoRjkn4Sfb0daEblOFRdEg3mJQOZps6ymCdkDs5wtCAU02lIxSyFFLGcIlT3uvHfPlxherB/exLPTkz+QnXZ1WfmGZvtk2pQxNKrBJFzL9fzHGzKm4yNExd3HsoI4zlKyp0urW4kyr7rRB6O9X0kGnFdtUtFuOzm342pItgoSj+bTpSvv/pFlnnXdiyw4KxusMRFFWKQ4kpRqUJ2ZG/iN7cmKQoMUIBmozxvU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_update_schemes_tried_regions() and its callback
damon_sysfs_schemes_tried_regions_upd_one() access contexts_arr[0]
without verifying nr_contexts >= 1. This can NULL deref if damon_ctx is
non-NULL (preserved after stop) but nr_contexts has been set to 0. Add
the missing check.

Signed-off-by: Josh Law <objecting@objecting.org>
---
 mm/damon/sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 36ad2e8956c9..ddcdc4e35b27 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1731,6 +1731,8 @@ static int damon_sysfs_update_schemes_tried_regions(
 
 	if (!ctx)
 		return -EINVAL;
+	if (sysfs_kdamond->contexts->nr != 1)
+		return -EINVAL;
 
 	damon_sysfs_schemes_clear_regions(
 			sysfs_kdamond->contexts->contexts_arr[0]->schemes);
-- 
2.34.1


