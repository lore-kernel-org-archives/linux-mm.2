Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FC2D60A3812
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PPf2jNEG
Received: by kanga.kvack.org (Postfix)
	id 6271A6B062B; Wed, 21 Oct 2026 02:07:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B1C06B062C; Wed, 21 Oct 2026 02:07:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A03B6B062D; Wed, 21 Oct 2026 02:07:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 22DB96B062B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:07:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 198EC8044D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:07:19 +0000 (UTC)
X-FDA: 85345600998.29.5C515FB
Received: from mail-dl2-f7.google.com (mail-dl2-f7.google.com [74.125.229.135])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5DE7BA0003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:07:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PPf2jNEG;
	spf=pass (imf15.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.229.135 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792562837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fKaDERhzPbkXN7Gq1dg6sjNw7qQA/V1PTTySjHjN2d4=;
	b=5hQgS/B0+BpliZM/xYsl0fi/7qh8nCEXDdvez5tp71I355wPANMvfH98eyJRi6U0ZeOFdu
	kAl+1pVc2BS8nqwAzNL6Ub7cnL+P7lPxnK2Im1Emyzg1h5kvbMnIDOW8bLXDGdzxPFey3E
	X/9FyJxkhiuD9zBO1pPFTWq4PUVetCM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792562837;
	b=lfy9EgKMutR1A3+VXrkiLFJATSDQNo777tJLTxWchpCuP8SaAPSoO2v1uxYOfuIV0snohI
	0NOmWJjImf+tjUfBFh8+fSEqQ/aQWVjWMm6/UJfNiDPA9VeQoggNJzHsylrMP27riR09bI
	KTxa5hnm9O7eQ7KVTpTHzQ2Dce1P0rs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PPf2jNEG;
	spf=pass (imf15.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.229.135 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl2-f7.google.com with SMTP id a92af1059eb24-13985f8229aso340836c88.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792562836; x=1793167636; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fKaDERhzPbkXN7Gq1dg6sjNw7qQA/V1PTTySjHjN2d4=;
        b=PPf2jNEG3q9RawsUk1Va0aggEVv8D1pAuQxMLbZgAuRXg7dY9MAjU4YyQ044RzR8eu
         xQpf/4oOs1oR9kpKmwaQF+kQY9Azxb4GoAXS3PYKmwP5PWaQd8YeSSNugRuSwfyw9mph
         H7EiOScXY7hbT7i4ff5+1575sWhEp+0VZc9i6DWyVMOuyyaseKhzO0fiZHM9BItnLfbm
         fOCmglWMa9gVaFoLj3ROvq1FTPbPMS2vldJrqKh04OvjLcNFV0UCrzWgkKMU/MJAVLih
         TLvPNQXTke3USekblYoULnk1hVexNGHMjCIlfkn/y08baKYtAmIGqNwtVOhnau9JF8H0
         YUXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792562836; x=1793167636;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fKaDERhzPbkXN7Gq1dg6sjNw7qQA/V1PTTySjHjN2d4=;
        b=Eks+hgMD15ll9AuKot+QUqAkecGJEjGE9RMm1lhxW1spDY1sIe4+PAgpwZQGr/evHb
         LJ+aYQtFFq0GWSebmgep0lCR3WSAvP/zlCLVTtsQuXnxlN0Aq4uWPIH8uby/ZJ6B4lGH
         Vjafiwl1qRf4PRTde8i27fy09lAc6WGCdRTaCiSXhEYTUVrmADIxJeeb2lfHK1V4F2s/
         OsqSFAB6ITuERCvi4Mt+rrThYajp6Fozv2+2AInzLHBszcZFCHNLBBKlQf79XctAIpxc
         4f1roPjp/0OjezG+A3N1ubB09EVMgN0yJZatQSJVM4S06pr/J/cGlDVsWuQRhCKW1Mem
         IVGg==
X-Forwarded-Encrypted: i=1; AKwUvBwR7RT7QGnZRDfAjStJfO6f0c8k6fgtj7g+F56otR65IAG4DgVOw/7cpzk4J7BWct1IUScZ7G6r5g==@kvack.org
X-Gm-Message-State: AFq9FYLgLQI9kmoXVFtVtJ9uPPA/qDG0dzNkukKpU3D0VhDY6l2dVZwT
	pX87htnA3qIIy/1zlPRReTQDUDc9T8+599J+ENXHHM7SCOcs5F8u+P3v
X-Gm-Gg: AYBFou1MUKMWBsZ6LveDtl5FPuDYF8aZrJP/Zcv6vodS97pxDl2//O+8Ef7vLddpUqa
	pZ36MnLafUhwUg65xR2r/RBXBl/sd6zYXRkBpfUjWSscmeDi9KPPOAFUdLZNAJGzsM0Vm6LfAGX
	W31biOvTJfp8pRyd5QXs+5SwRCdsdWDpQmW2HDhWxKddkay6tFAfsPLHzzubJwyz31jsmPmU5me
	pbDNsiCQLqy39pZZDxMnrgvPzdFRMEC6jtklkITzynFktvsEodoHrnOOgg+EStqixZd98xZJs6n
	4eReUN64Uv01o8EshIL0JvUY0De2wZEa8Dpd2TS1Z6F9bY9+E3U2CAxmTao4JYGfx2GZLaZ39wV
	vgHsH0aARTtml6VmNSFbJeQIo6yZZu6oH2qM0Xjc4oIblAwY3TeUet1ikQjA0p8G/CuGcS9VVZN
	7A72nWt2vAWX1mAzwuEFDWf5JPaD27m4RK4GehyUQ5vxhfgNR2Tr57bk+p7r9SIRJ/uRLDa/ocL
	Ux3UfwLxwe3TbQZUynV0236t5/vv3livvYmB1Pv/PwiMXskLMRsj+KdsiqlsM/Gd0NXfSwgJ0LZ
	/V4w43c=
X-Received: by 2002:a05:701b:2608:b0:144:c127:dd1b with SMTP id a92af1059eb24-190a7f02797mr1363525c88.39.1792562835846;
        Tue, 20 Oct 2026 23:07:15 -0700 (PDT)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-19035c0c9a6sm3504720c88.3.2026.10.20.23.07.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:07:15 -0700 (PDT)
From: Hungyu Lin <dennylin0707@gmail.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org,
	jack@suse.cz,
	shr@devkernel.io,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Hungyu Lin <dennylin0707@gmail.com>
Subject: [PATCH v2] mm/page-writeback: avoid 32-bit overflow in dirty threshold shares
Date: Wed, 21 Oct 2026 06:06:54 +0000
Message-ID: <20261021060654.27855-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5DE7BA0003
X-Stat-Signature: y35tjfsm18jr6af4xrapamhq8fykthrw
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792562837-85632
X-HE-Meta: U2FsdGVkX1+8orsL/XCk4I2l4Rb4sXcH3RNGNh6jkULqsrPdHChbhX1JC+BcUmW0C/J1x091nzoBU8ltxZ25yLnDqmbUQaIDDikAiPcEol9nI7VnZgNQU4uXfmvXgNtcV5uuIZx8ZdJ+4N/c62K5eJIWW/uBwHy2wJ15YRjs50glnp5YlqCW6JFKIYW1Z1K2Y8AxQsiWg9H0S/kF5vKCwDZoZFhpp6Y8B0YqwRABzJktmYS3KAAoD+nP54/I8akevw/5qA8DRNTWdvQZyyJwUplFZ6PEze1bSb6zvCsTxiqCogdaWyhf7NCqY/jar7DsyrJd4p3dMtkm1CbaZKpmE0GA8orRiUktR/YtIIwjHPyZjSd2yCxjn3YtjqErLaEODCdI5OaATNP6U9Drj6jRkb5Tun6L5mgrTOoPc4bUti8bz0OAA1hCRXe0wI/0o/fuSi/vsWCwVWYf/KUb91TKLP/dlY7JxX6o4JDix1j7WbkEc9rLdgVVpTk1uDl/D7QfzsxKgfnWmGdzd3r4TPzM3SXZ6SbP0lN9uHbsfRUdwCOxGqp/96FGpHnIc1KLw8BMJYxoTNpvZNnt/GA510/pjCWV18LSW2M9XWZVoT2vWTSeYmtw09exwX1dZbHvJ4XQW14325uQqSHR49DCmq00c/YZzsb4Wpey09mG9lrHqFJexo/xhAjd9iRs7VtiGmsOSqLr/BwmhU09ujIHGkH0o7cjayJbvR8d0/rub76VLvR/ufCw9GaQewBbjK22eiqQn0ou6blYrJ5YPTEuM4cZMSSb30Ph76hTgwCffNJRnjk1j6V9SPthgMRpOpaCDktEbZp0IFgi+6n4twuQEqmppoIWKl+kqfMWn5uA0XtqMvQ4xW/5ssKAdAXFU7n3CcrCIom/3Mk6oFWHUXahK8XSAGx+wf1A+VZHNsuQjtLt6fk8v3P5NJNPs/n+NWD4LrjahqaQoWYvEuLasXh3uRQ
 We0gvse8
 yRtMUFa16+oRP+zeCfZe95WqhRp+S7uJHG3nThEIfeVtQzqBoDb9rfWqbJKsUgDJQf/cMClqHxA7CvGZTQuuOlEzq5CjRhf3WOj5GX5KL0R0UcQwA690KqgA5ndm0E8RJ53fen5Io247aD7Xjn/JoPKbm6YR6o799Fx9rrzgbwIJznYwxu6dk6ejyKQtrYvIl7Y0iUwrC7w+n1rkZkWwIMxJ6QoYMH7L6lUNJaiGRDVPvlUh41Zj1iQTtK09sgxXxTUVWEgpmagh5UDZiLIq45CQu5hAveR9Hrpz7blnb0OjDziKSeVLUiMhATwNU5Lmwlu3w0hmIq6Tpp5kfz52w9viLPrC5tfBl8mB8p0DLsB5EjCiwFLn80Yb0WLuWhOkkHEnEpZBZIICzAFbhssZh94zw1nTTUAm/J1xdpo7EWq6Y5CPydMDeHPohfg==
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

Use a u64 threshold for the three ratio multiplications and div_u64()
to retain the existing division order and rounding.

Fixes: ae82291e9ca4 ("mm: use part per 1000000 for bdi ratios")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
Changes in v2:
- Use a u64 threshold variable instead of repeated casts, as suggested by
  Andrew Morton.

 mm/page-writeback.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index eeab25d6ce36..1d6aab8781a5 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -883,6 +883,7 @@ static unsigned long __wb_calc_thresh(struct dirty_throttle_control *dtc,
 {
 	struct wb_domain *dom = dtc_dom(dtc);
 	struct bdi_writeback *wb = dtc->wb;
+	u64 threshold = thresh;
 	u64 wb_thresh;
 	u64 wb_max_thresh;
 	unsigned long numerator, denominator;
@@ -894,13 +895,14 @@ static unsigned long __wb_calc_thresh(struct dirty_throttle_control *dtc,
 	fprop_fraction_percpu(&dom->completions, dtc->wb_completions,
 			      &numerator, &denominator);
 
-	wb_thresh = (thresh * (100 * BDI_RATIO_SCALE - bdi_min_ratio)) / (100 * BDI_RATIO_SCALE);
+	wb_thresh = div_u64(threshold * (100 * BDI_RATIO_SCALE - bdi_min_ratio),
+			    100 * BDI_RATIO_SCALE);
 	wb_thresh *= numerator;
 	wb_thresh = div64_ul(wb_thresh, denominator);
 
 	wb_min_max_ratio(wb, &wb_min_ratio, &wb_max_ratio);
 
-	wb_thresh += (thresh * wb_min_ratio) / (100 * BDI_RATIO_SCALE);
+	wb_thresh += div_u64(threshold * wb_min_ratio, 100 * BDI_RATIO_SCALE);
 
 	/*
 	 * It's very possible that wb_thresh is close to 0 not because the
@@ -916,7 +918,7 @@ static unsigned long __wb_calc_thresh(struct dirty_throttle_control *dtc,
 			wb_thresh = max(wb_thresh, (thresh - dtc->dirty) / 8);
 	}
 
-	wb_max_thresh = thresh * wb_max_ratio / (100 * BDI_RATIO_SCALE);
+	wb_max_thresh = div_u64(threshold * wb_max_ratio, 100 * BDI_RATIO_SCALE);
 	if (wb_thresh > wb_max_thresh)
 		wb_thresh = wb_max_thresh;
 
-- 
2.43.0


