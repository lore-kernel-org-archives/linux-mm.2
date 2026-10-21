Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0643D606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 01:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=CMiVJXIy
Received: by kanga.kvack.org (Postfix)
	id 1684A6B059B; Tue, 20 Oct 2026 21:36:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 119456B059C; Tue, 20 Oct 2026 21:36:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 006A06B059D; Tue, 20 Oct 2026 21:36:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C91606B059B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 21:36:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5D5B21A044D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 01:36:27 +0000 (UTC)
X-FDA: 85344918414.12.AB6FAC0
Received: from mail-dy2-f7.google.com (mail-dy2-f7.google.com [74.125.229.7])
	by imf25.hostedemail.com (Postfix) with ESMTP id AE89BA0007
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 01:36:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CMiVJXIy;
	spf=pass (imf25.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.229.7 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792546585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Ax/MKBRp76FWn3h/ZPK32Hkl8AkiS00UsCUGIQD4n0E=;
	b=UJIAeRCFMBLY/kpwlWy1956aAeLe7WCmSBInvSn13N9BITbNOXHLO7whgUiVCnfOWy5UXJ
	QjjQcBEBvEv50gGnI7huPnvdPOZckNK+jfQV9wJIPfvQ3ksuNswd6cfeq4h3IoKP6sxufV
	QucYxQ5adNVyEn8z7u0tUKNpnCP6b64=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CMiVJXIy;
	spf=pass (imf25.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.229.7 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792546585;
	b=p6g9ejnovbUAovuiZEdx5kQmmacZqQ3wS6I9++19L2yYPOxz419kn/ciiRo9hHy92fCwIs
	kocutJPBgo9ov3hA8JAroHmZeqwoweJoIYZnEdvQ0MGdp3/3UE1gXKV5DQylXecAVTsOyT
	KAmBlMaVzw4VdmMdMW+/ZE49W1fOXUs=
Received: by mail-dy2-f7.google.com with SMTP id 5a478bee46e88-36758ba1f01so66808eec.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 18:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792546584; x=1793151384; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ax/MKBRp76FWn3h/ZPK32Hkl8AkiS00UsCUGIQD4n0E=;
        b=CMiVJXIywJ2a+WemwIgzlp4UKhxVdf6qigpH5t3rbOUahzQX53m90O6xdd/k0FHekF
         Wr4gG0lVpvdqMuRhDL6uAPwSgl0KhVYGvQASEEAwmfx+JpFZmRpkI8isdPOtyE8OnhI1
         WFnAoyB4vtw2p3f5wUCGSz6PFNaRWHkgeijlZ6399gzSbOh6TzKrQbZ3nw574g42bTIv
         d7l1w1M+PL/W0iRhF28iDOdsCOiAeUILTW5G9LKeYcgrzI0egBjdc2gqm1AMHiiq8YJy
         qzPeDGR0EoAeeZaVgLtwjnhgHdBRkuULm1vq4cfzrpSfOfOUQDlcO5xoVp+d7eMsG+VS
         JKKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792546584; x=1793151384;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ax/MKBRp76FWn3h/ZPK32Hkl8AkiS00UsCUGIQD4n0E=;
        b=EbvPRUYrstCamZjPzNi0L87yy2oNSZdMhuush58tgcOPQ5BnibEXT0hkFTaDkEhNk3
         16xO13WXs6rFDSoQRSvwnWMv56nNgsJtGV7vdV4u1v2W0VNcE/Ka1JdPm0ratHH3rfIu
         TgP+6TqIhM7BxQP8S/SP64Av13RtkSDNvxwFC8Wq0QmoqLv04qrKoc2KMx92YXYvMWY2
         V5b2gri+bj3ciDEwYHUnKUlBkOyD+PjV5kywf7gH1et6z+QhSgvlqxMPvJMaDTVP4xlp
         BaRjaWA3LhDLzLYk5VsVIuEZzXB35NhrKKTwo5/dt7se76nnKb3atgLevWhIpw+ElKa5
         v4XA==
X-Forwarded-Encrypted: i=1; AKwUvBzkAnLfDVEC9JcCrX0hgz3AbyY61IeMrnNmBNjy2bvF1hNFJh89E9Gwwp3WSZMOEqosPiDBuZt6qg==@kvack.org
X-Gm-Message-State: AFq9FYKKinB7I1d33S8xmalmyukLcONb5pJmFAQhSfwibcC/ZfIzYhhY
	FqJF6zt/b/J1iyPBTD9gohaT/h273bldJZMB9pxdMfUd0DDdDtTFawU6
X-Gm-Gg: AYBFou0orvnaK7A2juzI1KZMycCet7xvDb6yqjzgjg/8gtOBKfb1zdOZrI+OZ84vShx
	0t8SFyIBBjAzYi6G/ACWOYTNjXm0Pub/22kMMCIlL1W8UPd97lT0iG5xriGrZAV2mL7A3mAp7Ag
	0SczQ55gNfJWedbONFj6eDGab0hzhFdFSlZDzw5+MKquQW006p0tdefCPOPSAmy9r+Na2Ifivzv
	Dl6r8oDxzDQ/oDMZQ6+bTxxjHyUsYZr71Evz5yqmk+3atHFnFRqsLxkasAuZOluM6b5tpxFztJN
	Y5P1jtWwJbsaAZRHIZF/w799c2gugYbgEnM1vz4dPA/uv6GQNtbjrVGewsanys9dFErruPXwWVI
	mjJ++BPxW3Y0cHjfuyuOgTvvAELlPdkA1rJFGAEMIajPR/xIVdjNI158zXkd9u3Z+xDMRB/2D7E
	D/FPXfow2inTPZRwYTHjIf2oe3z4PgiWDbvQJsIi/L3b+PReb98sldRAZL/z9HH+k9AZVzrHRci
	m33BQPgEQWDEMTcdUgzmT25KYszOUVPFxEZ/34+c+tDsI4lI1TDw40F4PCA68FdZlkLP0QiJ72d
	Pe5W1/w=
X-Received: by 2002:a05:7023:a8b:b0:143:72b1:9004 with SMTP id a92af1059eb24-190a87a3b70mr819537c88.45.1792546584157;
        Tue, 20 Oct 2026 18:36:24 -0700 (PDT)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1903a275026sm2991870c88.5.2026.10.20.18.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 18:36:23 -0700 (PDT)
From: Hungyu Lin <dennylin0707@gmail.com>
To: willy@infradead.org,
	jack@suse.cz
Cc: akpm@linux-foundation.org,
	shr@devkernel.io,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Hungyu Lin <dennylin0707@gmail.com>
Subject: [PATCH] mm/page-writeback: avoid 32-bit overflow in dirty threshold shares
Date: Wed, 21 Oct 2026 01:30:46 +0000
Message-ID: <20261021013046.23997-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AE89BA0007
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: nifo1qnqbzzgktmrwdp7ftkn9i7ez86d
X-HE-Tag: 1792546585-324089
X-HE-Meta: U2FsdGVkX19m7au7TCGYw71Sccjk5QQf8qjKfLkGOgowvHl8GlHo3hJuxx7B3kUXzmxC32URoipDA6n9Mw6FQZKMwIBiS1kh3nG9wQkYKM/SEDGIMASpn/irT8dGAr5U9FqzMzNBrb5NPcid6hiRMb9OmGA8bQgnNNGBRMV3G6FjEE834ymhMc0s5FuY46YC5FF+H1a8piRv5gw0VqHLbZhNnZ161UOgYtmFIF5BlbL8aYigAbYp2BjI9dTRh0qC5uAMj+y0ORaJ21xpnAbAerqJHV9uxlbSbYcl/e6KZSF81imRvK7+mvUTkHcaRMYHKymnHxakLc6OCKtewgplcuLqVRShi/wpacgUU1TXpZlhRUBBKdw2Mtdk5v+kg5RriZ15/sdy0vR/RAhqfJlWRMUBg7nshBtZAFmmhyRl7+mok4M1djWiK6a5mOG9TeDlI3I5BKGANQS1SXJYQKl5KiMXeMVGHg4xtlymfwOFB49UzlflAB5LRVU3RFvHiNQH89/axSw7BZ2w1dEFJ/HLroy++A5VgP4udQRgUe6WhDf5SEa5rZwc7zKqMnmZmvSX1CmDiBHXOMeY9w9GaX9+Hxy1HI/Z5NKIZlntNdrAvE95ZBPc7KyNz0WPvnhPzmYFPnWlMHMUWGzD6wIZLTUcHAlSYqZeKVR7uupAGmeBp4aqD61sk8lZAycGF2W2yudxeywRfKU+l95YKK+M9eCf1rccz/S1IolGv2SYnWaeHXkGrGrdZLxmp+1malOUm9JTOKf0ZQ2Osp+MuiltntGVPm9qtZ3T1VHyC4YXU+BIvktX28V/Y6tlxhJbIuf3tLIKgoBPZdcmrD4BX0AMaGbtladbPk/VUt6fWXyvqNh/TYyXi/T58Fqt125lx+s2wacda/tq6eXcgcU6SDVCNt1VM4ibnUPeKGXaXseKFRXO9o4XcfNMvgiueepphKxmOEFOGSmORWCwJuewHBztF/X
 npDN8/Tb
 vjT7DdunmreeKGGi9n+Ld18Xx8qkioTWUhOJFJEEMPa4PhbhlMtDGcYbUerRAv4b+WerCYgYDihFIGBOpDiTZ5snU9xqlfsedrTQCcMRcLO5NiDfJX0NKb4mffbEGMQckjbhcbSPLXYMJSni3kmyPm0tEOt+510znQrbyDyWzwRxOqO8i733vkplE0pBg6Gm/WNDDWBMmg62prkM+wypp8plLsfJCx49CLJ3qTIWyWLkC8lWMo28EMTZLcIz9c/qVbc2HrrarDKAHG0dTpdI8fmms47PkjTKm5CVOW6r4afcQeiRW6nCggx4vs1wZcXu5v8veFe9l1Gk6fTTeA1G5MsXO2HrIjedjUjFROLVjKtdoefaaaAP1pq2y7fQsRdIc1JNKXcfHsxA5pkDElxZtZfhm8hui/dgtBCD1Sxh45w7V+aDx+OtBDLUTOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The ratios used by __wb_calc_thresh() are scaled to parts per million,
but the threshold and ratio operands are unsigned long. On 32-bit
kernels, their multiplication can wrap before the result is assigned
to u64.

For example, with a threshold of 25600 pages and the default maximum
ratio of 1000000, wb_max_thresh becomes 4125 pages instead of 25600.
The shared threshold and minimum share calculations can overflow in
the same way, producing incorrect per-writeback dirty limits.

Promote the threshold before each ratio multiplication and use
div_u64() to retain the existing division order and rounding.

Fixes: ae82291e9ca4 ("mm: use part per 1000000 for bdi ratios")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
 mm/page-writeback.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index eeab25d6ce36..451750df8b74 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -894,13 +894,14 @@ static unsigned long __wb_calc_thresh(struct dirty_throttle_control *dtc,
 	fprop_fraction_percpu(&dom->completions, dtc->wb_completions,
 			      &numerator, &denominator);
 
-	wb_thresh = (thresh * (100 * BDI_RATIO_SCALE - bdi_min_ratio)) / (100 * BDI_RATIO_SCALE);
+	wb_thresh = div_u64((u64)thresh * (100 * BDI_RATIO_SCALE - bdi_min_ratio),
+			    100 * BDI_RATIO_SCALE);
 	wb_thresh *= numerator;
 	wb_thresh = div64_ul(wb_thresh, denominator);
 
 	wb_min_max_ratio(wb, &wb_min_ratio, &wb_max_ratio);
 
-	wb_thresh += (thresh * wb_min_ratio) / (100 * BDI_RATIO_SCALE);
+	wb_thresh += div_u64((u64)thresh * wb_min_ratio, 100 * BDI_RATIO_SCALE);
 
 	/*
 	 * It's very possible that wb_thresh is close to 0 not because the
@@ -916,7 +917,7 @@ static unsigned long __wb_calc_thresh(struct dirty_throttle_control *dtc,
 			wb_thresh = max(wb_thresh, (thresh - dtc->dirty) / 8);
 	}
 
-	wb_max_thresh = thresh * wb_max_ratio / (100 * BDI_RATIO_SCALE);
+	wb_max_thresh = div_u64((u64)thresh * wb_max_ratio, 100 * BDI_RATIO_SCALE);
 	if (wb_thresh > wb_max_thresh)
 		wb_thresh = wb_max_thresh;
 
-- 
2.43.0


