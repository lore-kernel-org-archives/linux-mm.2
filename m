Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3814C109024C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 16:16:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D7486B0541; Thu, 19 Mar 2026 12:16:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E5826B0543; Thu, 19 Mar 2026 12:16:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E9A56B0541; Thu, 19 Mar 2026 12:16:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B71786B053E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:16:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 82BEE1DCD6
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:16:39 +0000 (UTC)
X-FDA: 84563315718.19.9D89520
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf17.hostedemail.com (Postfix) with ESMTP id 824AC40013
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:16:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=PZ1EAUfN;
	spf=pass (imf17.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773936997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kSzfJu51IfOy1UEq0KOHRM7ctnyUfpNOAlgbFOZRhU8=;
	b=RLHomD9OfHNtrFoFOZemPsvA+FMzrLnXndjgr0yz3Alv4hO4y/D1VT974CkQm6L8UFxUgC
	L9mbYTTDL+g1ojBT8uZSRRyDbRVpRc0a7VSSvBaoQ19BtT7I15SMnL0tSWdYGR/a4z4ZBK
	6obeYVsCK532c02po+dxfjtaLkqawsg=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=PZ1EAUfN;
	spf=pass (imf17.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773936997; a=rsa-sha256;
	cv=pass;
	b=VInvj4u9JDnzvkp5hHWDhf1W/YD/zWKaP9nsmu8NV+s+g3WRRXOJ/EhMdeaoKze4NzkkAV
	uF5G7PTECpqu0dOmjU1P05FRY5x0PdvK+Gzie9EUAChdyXMTTonx5Hd1zh7D5TkA6ZZkmI
	ncGJcxzXCECfkusMAF1Y33SoVJe5L+Y=
ARC-Seal: i=1; a=rsa-sha256; t=1773936984; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=YtQ+n5adLWRhRlwMN/ButLVqI0ZbmvaM4gIG/cxPAIns1uVOQeOzWKZXRGp8VlENj/JNDx2sseAgMMmdXvRH58iiFRtgcnNImUH+HWs9OYrkYw2/ocDaCLbtnD5siUZ0uTztyznh65ajAGVffP2ib7MQfb77yi9sW89teajhSJA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1773936984; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=kSzfJu51IfOy1UEq0KOHRM7ctnyUfpNOAlgbFOZRhU8=; 
	b=i4OEJ4irdtfNq67p49ZvD/NSOBuDo0sKHHeBAMzbko+Ov6MmRMddMlGwx2xy4hjXKG3xZV+lx9unCeP82ArIy6gq+XVyRXo4v6XbDuyf4CS9lLdT7BjSjVP77uHKRXLnvyr2ESoZOQyTuphUkGQVk1eHbu+b1SQJK6N9H3ylouM=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1773936984;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=kSzfJu51IfOy1UEq0KOHRM7ctnyUfpNOAlgbFOZRhU8=;
	b=PZ1EAUfNuAt4xkB14D2sffseN1vgACG0eDvUu8GwDycAxeSJFtCCc0+pnD7cg7ja
	bZcNE7w3uJM1eb8Rsv1Wy460xJ1nUE4XoPYPC9njngndvZKQuj7jcyuHDmgySU6z20+
	Aay50qDM0MVv/Vn+XKFpbCrLcHR/9FpHXkmwTiqs=
Received: by mx.zoho.eu with SMTPS id 177393698328213.931315546403994;
	Thu, 19 Mar 2026 17:16:23 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH 2/2] mm/damon/reclaim: fix min_age_region truncation from unsigned long to unsigned int
Date: Thu, 19 Mar 2026 16:16:20 +0000
Message-Id: <20260319161620.189392-3-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260319161620.189392-1-objecting@objecting.org>
References: <20260319161620.189392-1-objecting@objecting.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Queue-Id: 824AC40013
X-Rspamd-Server: rspam07
X-Stat-Signature: egmijh9tqt8jah7fzwjd8diu981tjx7i
X-Rspam-User: 
X-HE-Tag: 1773936997-488049
X-HE-Meta: U2FsdGVkX18UfBqoWL4mTUWguDZSFHS8crDqhY9KoS7zcnHsBPIewW+ogTl1N9+WNTfYop0bkEj1sDgeyLOOiEnh2bWehnsRgPEueKnOM85KKGtY6MglvpQPstofjME/3oAAJjtJH9gdZ+Y1lBhZaIc01c13whd+MW+Ord9IomB+Wwen/s5NL/yxAN7srFq0J0rnaDhnUbTfmCnQ7Ehjkk2V2nku4gBQ3J2O+lS4QC3cFZy3kkfNn+y0IWzQNpNwp7XcLOM8cHL3hVtVkh1QcHwFDHmZIkpVXJ2KbnzC4nd4HqlTAwvobLfbv+tMVq/8NlrwZCGXNm5q6x4NDYDSOT11xXMPvlUMEvJMWnV3ijDdkeLuNtCwQrzr3jTpzwVHVK5qsLaNBhW+Gpf77jaSy5OloFfSigVB6u4MRsOECLL9kwTLVxR/GpVdhejOmKtuz8EZmnAY6gaHP0dr9DkfcO/e9jaWY3OW17mkaJEgcgNU6NFi5a0ND0Ks2WnwDynRT8jfqtiTZkIn5clZeniL3FSGDzaNgRp6ZagGdiSVmyEMcTS9iiAz4Z6HuBX+k5e+fxFtg01M1/TJ2bpLboaqKLHbsxoEpYZS4+JU2dZ8m8PwU6E/bU+/PWwWRBVIouIULiA8qMEAT56Earr5WTQEF5RdkQC9kE7x1zAA774rtGz3gPTXAyunpiMPYhh6bnrTkPqlIon3FTcAT4vmraRHQyvZF9LFWVKimhqdHQUnp/SmZ65RKVYo7nLWRghigiLVTtxk2Smb6GUdDY5twG7txD/YNKDVYRTAUCLit6bM/Bg4hsGbPwntGZge9eilSvgBRIzarGHTjJhuWvWXECJRbfuUjrwqFX2g7Ed5BZURKcdUqCTz7QMsSCExRA5zRmJWM195RSgEnUCT4RQ3cTY6TebbcC4S9IUsqSbg7YCDvdA28rFcG3mBMK6AUFqudn1DBl7K+wawGMBB8OLAjlw
 99aF/7nj
 rXCRrbGwFXEf+kfpOXpTW/lT8T3br+ohLPa6qJRCJXIykhvlJYp0aIJWJiDGMoS64tI84YdV7xtPt8g1eZt134jT0vhewPmNrDmKTTF/xTInp3RAkDNphpunoHjMg1prvywg15R/FEL/nJzd8mtohGzUulZ/wHyPjSSRiMaPWZgVHIJCWoFBfJvAnFIsTUqukkqAkgFlyBOqkKeL2hRDxSiglqNTYfGBNrjgn2lUe+ChJwnxuT8JxvDZ+Gqb2LsOSVWP2uTffe4lHEu0m8zgcMJDQdgMVPzggD5FDh2PdrT2m+VahM/bEd8ZD052pc4Mhjyq0JeykSFmnAza/d4DrdCAti/84a4CCyEcu3SMsF8x8rKxtQz7KA5rcDGi4ZhmkPPhXdVYl+Zr1Ujk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

min_age / aggr_interval can exceed UINT_MAX with extreme but valid
module parameter values, silently truncating min_age_region and
lowering the cold-page age threshold below what the user intended.
Clamp the result to UINT_MAX to match the field's type.

Signed-off-by: Josh Law <objecting@objecting.org>
---
 mm/damon/reclaim.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 9b55df304e51..303c64a56073 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -170,8 +170,8 @@ static struct damos *damon_reclaim_new_scheme(void)
 		.min_nr_accesses = 0,
 		.max_nr_accesses = 0,
 		/* for min_age or more micro-seconds */
-		.min_age_region = min_age /
-			damon_reclaim_mon_attrs.aggr_interval,
+		.min_age_region = min_t(unsigned long, min_age /
+			damon_reclaim_mon_attrs.aggr_interval, UINT_MAX),
 		.max_age_region = UINT_MAX,
 	};
 
-- 
2.34.1


