Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6AE1CD98F6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 15:15:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2851B6B00A0; Thu, 18 Jun 2026 11:15:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20E166B00A1; Thu, 18 Jun 2026 11:15:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B0536B00A2; Thu, 18 Jun 2026 11:15:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D00D76B00A0
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:15:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 528BD1C0D05
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:15:38 +0000 (UTC)
X-FDA: 84893382756.25.CD724F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id A934F8001F
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:15:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ta8XHsh4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781795736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vlWdmraLtKsn8tRuLUEVLShK1HHadraHOlLBzHm4x14=;
	b=m2mOXkA4wJbuI3W/MnI1J45A51nb7Qd/N/UVvIXgQe32fhV1GAYvolhBhj5795YXyO43+f
	x0ZWtRRBLfXoVRywJObw96fajfhGSdf2hfkOOGJo+jHm6Oy2Ycr4PwDJBfTD5id0p6QAuP
	JN6e/y+NWn8elO9v+aMjGB49se8clO8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ta8XHsh4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781795736;
	b=pkJv/iSDXjuCzktg0MH+53qq76H/FgirIcWV1fg52ZrznU8h8jUxGZ5MLl0NTAEDCT9SjR
	D8Pjc0hW1pLzkVdDn7IDLUW9fg1wsd8m88eUtqxjynxUyXLpladY+QTF12tSPP/zvHvL9B
	9aI21otxWMXyCveNLR3ild6sa8glgNg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7C1F860121;
	Thu, 18 Jun 2026 15:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28CB1F00AC4;
	Thu, 18 Jun 2026 15:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781795736;
	bh=vlWdmraLtKsn8tRuLUEVLShK1HHadraHOlLBzHm4x14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ta8XHsh4ZHuRNEUZdt7JrNFh779wrIFav3dd9IOrXmxRqhFeYwK7mKPUIZaXY1flJ
	 A0laymTf5Hiw97z6zFeoG4R9QLk2wPIAPDa7Ytz/QL12x4I00yd3KznkPCN8zdJz65
	 /MZyYiBS2Fldzm+hXAoxrys1gYPxB9m5pzNv+Tr7jamLe9xmfHC2jQiV045x3QobUS
	 QSgCmR0e4e/1Hp/vrnsoREByWnroZOnsqz+hx/ZWe7D2jy/oL3OrpjcP5KtZPPbCli
	 IRtWYLnfARRFSbihQbTjNosP5/+hd+QebnSvKhg/vnvaM1+iEVZYkAc0e10XlrdgI8
	 0UNzA3Z43B6zg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 07/11] mm/damon/sysfs-schemes: kobject_del() scheme action destination dirs
Date: Thu, 18 Jun 2026 08:15:11 -0700
Message-ID: <20260618151517.5366-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260618151517.5366-1-sj@kernel.org>
References: <20260618151517.5366-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A934F8001F
X-Stat-Signature: cqqq4gyifefctf98h95z9tomgahwatbq
X-Rspam-User: 
X-HE-Tag: 1781795736-695954
X-HE-Meta: U2FsdGVkX19HN0wefGBHrs50vYnkZfxkZ+U67B4U/T82hqj51sqPVO9KCq/xT5k6wTS/AxKuMJC0QzFeNPWMUz4Uxe9/HSJXtAl+gTOQOVYAknl+VMIo6bD1cpVkT2MC+tVsUdYRVWmiTPzJdJZ/UqwtcBxcwca0zdwZyuNW13nXznd9GVexMQ/FLjrYndDuroin/7DBlA8tG5JtswqeGB0D000rcha8XM96bbF9cxLc2Bvhpok3FXgT1obmF4P5ne4gN7imyjjw8nubFr7XBG++MGcIywsl8fEC+0VE0rx350/C3qy9d4rbRFz/XTE2iXXe/n42XhNzlE+yu7TkcO1LTc1sgAG8sdcqKktApJWQJFDChPxHENWahcdgTEUKTaEtmIYdgWnr+EYP5XRijRMSLvGkqTvUnPPB+Qlb6wQgt4DmPjVxIOckSva5VlQ5dUTFOWIY6C7fxz3+MytRJXmpdRbSfjnLZApBUd5DNYuVQVp8MIjsaOP7ODZpzM+Pr3OuEizX085LftcMBsq17jtVYHjYaPInP5AC/6UE0stywX88lgfAaa1TsKaR3yjiADMlmMTkuKAiOLRhSzdzBgb6nibW2pnu/J059m4V4mrz4Q9ZatdvFO15fPOaf7u+QE0wIdXNIH88h3IKotUpE54wBRycchREqSGISy/6mDZ0nRW6aRahWUiF/35lMCLx6NXTmJ8n+wttODrpTBXMeRKbCPHt4VHhnySjUfKpP5Bgy7/UgUqkkQ/Ut9tGRGC8upV3c0QrVfkMidllDefjtJ79U7jr+pCYNXWppyPSaPorxcF/LivAEY8Y/oRLGTXFVx/7zA4+lwLWrZYiz5RqISZl7ypx7xdH4osOByHBoe93GiX4j7IPoYZlmtYLnTsHoz4kJVvE4O8I9V6UYyIeAxSUBSNW0BbB91F0dKhApW+sTQRGFOr2CG0ZUXDvCaIJ5W1f87gNBrBZpgIPw9q
 ArVG5+Zv
 Mmj25jjYA8z1FLglXje+l5/txUZ4eIwRNGIgI4OnJ3A9wEgtW4FtaKbW2xuRSMnNGCNeBi2lt4lFKOAGDJZd44QoUP5WXZYtHFZSj5I5wjcdQe9ilD2qvMh6yGdg+GijAjQz/THzbYh4PMzd1y1mDZ+u2542VE2mDJ3BlqC1MWpBox5v2wEabv9kacblrSvvg2pv/cEaP91nJL/3S/gkKVzX3nKbs6x+0P7RWF/x96ghCfaeySgHkKtKWRBT+koVFse4euGQVOkLYquxiej6nzpHjhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for scheme action destination directories by adding
kobject_del() calls.

Fixes: 2cd0bf85a203 ("mm/damon/sysfs-schemes: implement DAMOS action destinations directory")
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 306c1d3d357c4..0d4e9b053e381 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2145,8 +2145,10 @@ static void damos_sysfs_dests_rm_dirs(
 	struct damos_sysfs_dest **dests_arr = dests->dests_arr;
 	int i;
 
-	for (i = 0; i < dests->nr; i++)
+	for (i = 0; i < dests->nr; i++) {
+		kobject_del(&dests_arr[i]->kobj);
 		kobject_put(&dests_arr[i]->kobj);
+	}
 	dests->nr = 0;
 	kfree(dests_arr);
 	dests->dests_arr = NULL;
-- 
2.47.3

