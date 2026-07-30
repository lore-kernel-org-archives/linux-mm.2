Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9BF0C55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 12:24:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2F9A6B0095; Thu, 30 Jul 2026 08:24:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C07A16B0096; Thu, 30 Jul 2026 08:24:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1DE36B0098; Thu, 30 Jul 2026 08:24:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A7E16B0095
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:24:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C75DC012E
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:24:04 +0000 (UTC)
X-FDA: 85045360008.02.C4B9FF6
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4665EC000E
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:24:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kXY1XD8x;
	spf=pass (imf28.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785414242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SH6mCGC7SVA7L7o4dC4xAqNxJgvdrWUhmXAualcScbA=;
	b=anCVG/3QD8WzPGUWcPKpCNCth9xc17HKg4KqBccBlLKPURgx4Ickj9MewfQ/MEEKE4satN
	DlfOpkBMvtz1+rP0YaJnpBpR8dZc8l8gRwnl0usnZvrOrrKD60C7cerseFise8iocTc1XH
	dUsWBpkjQhlw+dDmnkFpaHH2+UbgOpk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785414242;
	b=3gI9TZcfz1tzUFEdF3FNbCNCJ4TBlI4rPz+MftDdFtc4/qaVf+HDt2ami65Ks4FoS5ZfQZ
	HTKe9kzLyFAHu1m4waCjcbh5QqzlsU0uabksq1O2bIENzwjMr55djm7dVZaczihBpJRrDk
	/9fPW01ohHK3u8gcBjPnvaB3rBDtKX4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kXY1XD8x;
	spf=pass (imf28.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-384422b05b5so217168a91.2
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785414241; x=1786019041; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SH6mCGC7SVA7L7o4dC4xAqNxJgvdrWUhmXAualcScbA=;
        b=kXY1XD8xzEWtkVqV41qV1aW6+kXMwpYUSdhi7IqMfjQqa1n4sCC+94Icf8AiPzgF6T
         qtMfb2oDgjgEQATQmYu59JFkD96je36pmRNDWtDWDKExAp0ZL3tc733Gjm/Uqv+Qn+Hm
         +1nnYC6DCgWGhq10YgJXLa010vpy6P41AcUBFt5ubjX/+oMqWSeIS7v2TW6g25sqDpNh
         5x2O4lz0vnWLVilvN7MWhvMunDSorbjxSWwcruHetip+Q1zdf8Z5xDZDpFBsrhG4yfFL
         U/7UGJIqwFwTTufKjHBKqb28Qm9myu/DQcVRJX0zO84UIOqMb/A76HX7zao30iBBM/sd
         jq+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785414241; x=1786019041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SH6mCGC7SVA7L7o4dC4xAqNxJgvdrWUhmXAualcScbA=;
        b=bykSbOmjm/WVmr7YCIH+T3r1Byc61FSUUBYI8wB4ikobMZCt4XynVsQPbNGm/4kh6m
         ahEpaKLUVTr944cnpNDnhcke8M02BgV1ulPRs1Mr6b1qKM6LybsNwe/DM1xnYQEoveOX
         AM39EgPslL458QeFxWDehduzYDjy+ob84LvyGWgvrhSS2s7iHKtnqLVyZDY0tprWTkXU
         6aF8XxUptihRizhPQozz8cb9ia2PGwRjQkzP7wNJaYjsWwwSVPn7niYEqIuPv7S/bIIZ
         ghPOQhJLTppQ0OUmRFxrKgPBCP+/0g7eABl6+8NrcTOTgNmf5W51FubU0XZjKuRHVoxg
         pXPA==
X-Forwarded-Encrypted: i=1; AHgh+Rqqn1XDQ8SlGiletwk4apbS6FijykM+6tvJi6uwfUAmXc0TmltEfEFLeqcR+9311r373PahLgBnTg==@kvack.org
X-Gm-Message-State: AOJu0YxM0ijZGwPma1YoT76u/RF4wwKuDic3MkF2Lp19bf0ZTySSVnR0
	dD1ZfkwoD00VhExAVoUaq/rmT9AFiO0k5IAMNKDCHlCdyWrkGAMH9Mg2
X-Gm-Gg: AR+sD11+w/P9olRhwnAfgs4vN382aw10G+db1i2Y60tYCMR15m66pi7ckluVXh7xqTo
	+wcLYCUJPlO37sc8oYvyGtnv0zwZnnrOlpEqKEKYs+d/T1Td+d9aA4SZIVPQwM6ULVEvwkU0dPi
	8AKhRf9iPIRjHQdd3RZ2L3kFZe5eZb2lk3OoFazj0SxphuXXCu3EumwV82h2eXWcZDwMjFJqrtQ
	KXml4CfX24LzQbRbmR3qC9X9QTgXGnQJkHzMEsnsahpKPj8iUwfiG57gyhB8GNg1gUB7uCMloKt
	ApCMreIyejb3czA8q+OdGhlQL/FiCiiZ3kY/+kZ2CFYPY6pUVjX/dJqjozr6SUwA+XMGvDRm+MI
	YjAEl0XNO6L9XbWLsu0UDWlUng7dizSZaoMgHDYzZ1aNivbdETnAPVk+7gHAqQ0cTEb3FfZKMzw
	3HVLoxICCIqVSBXi8Z8AW3DWJjUsECH9EASa8FFXNbK8u4L2B+nrRoA7oYC/rzwcSuVxH4viI9v
	F41ysbb+BArw243bgLNT8pOVp7k34uyWl7zAPJsA9xlhnKauTHL
X-Received: by 2002:a17:90b:4fc3:b0:38d:90c1:2400 with SMTP id 98e67ed59e1d1-38f9bff9c78mr2879463a91.2.1785414240965;
        Thu, 30 Jul 2026 05:24:00 -0700 (PDT)
Received: from debian.lan ([155.117.85.23])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f9b72d243sm995698a91.10.2026.07.30.05.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 05:24:00 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	zhaonanzhe@xiaomi.com,
	baohua@kernel.org,
	hannes@cmpxchg.org,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com
Subject: [RFC PATCH v5 3/4] mm/vmscan: avoid pointless large folio splits without swap
Date: Thu, 30 Jul 2026 20:23:03 +0800
Message-ID: <20260730122304.2496440-4-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4665EC000E
X-Stat-Signature: xcqo43nzg4ftwp4fdcd1ghbux6ehqhqp
X-Rspam-User: 
X-HE-Tag: 1785414242-20837
X-HE-Meta: U2FsdGVkX1+1BhSWkf0QFPIpmFneC3WyAdLiPpD3qrxk/Ubq2eBmT+p2rYIFN0aTbVBGt8gJvJouI7gl2VpvwlT0ZudIoniwOeqQgPoQXbkk2QDRIZ5B/0Dv1cOGlx+VTdAKAJ2yy+Hks9SQnP1h/MaxXnZPyQaGULr/IalY513xHIvqKBCY3lx0EFj5sAThxDeyNLma880b+DzEzzyv09QLDe+somnvVbmATJWro6elHYIAFNCaIuQGU9EA1q8/qIYESSWanh6XkSFElagjA8LFHURG5fbSabMC08DGGjaqM4RbVmDB9iF78NqTyX9seCkSoVcE8TzyCyA/634mo8fK8U1kUdQdL3EThmBZHeBC7Pd2HjBYdmRG5TYUngUdaCzt8OmFWK1YweQMin+zV0/H0AZCMkzzcvpt4TVwpEuAzxB4p+14rRBTxgXP4e+3lh2Mc+vkpA5qyYzxw5il7r2nFfPOn0vAJowh5aGJR2IJ57I84V6d5E1X7XFYiOb3/YlPEqryEYUv/tWoUWDcd5IAGqmoRRST8YVB6pCHLJAY8h/QZizhjn9SVOzyz8kMNGrSmS/5rtc4k1D+t0EaAJ3NlaGJZLmPsg3EpKoZ+BhT+yZGVAaB/IuODZ4xuDy6ziLeVTBMT2ArOMRcMy5bGRKpuXptPiPP3aVsxIbrk4PgoQzauKIJkdDnE+9CFih4lmVMV1lfYVikjMU5JGZG8OINrv1gPx6vnxF1hjzxoRyb/GZPmFOBonvO8EH0mrCyDWPIAlOJ20xBtEitJ0LmFI1W1X8tDkYXkcUW7oPv0mM9eF8KZjeg1bvbagXONI2S9HLlLV0vw0+QApIaTjIZeOjN+xGOJ3XJdDKozB5yqyfLlf79CnMrG6fCch0nEnme+3tF/nFCTS93uFa3QLBsJ8oPZILIysA72HjmKK4PJfxUPZ1xffzGBplIKFrCwt1m33csrCJDm9ILUpCWlee
 GoULTaEQ
 tA8eYY+/USZz0BZRMwNn17+EqNvKshAL/aqNkYXxzveRTNhxOeGYSbbnodoGB4VEIrmblCEXVmpHieU+J4jRmAanKFuv90gZXjmrYVkeoUAXVLiPpNd+Upu7tWZwbpVUyGGaPbY2zcsnbUNfbQyLOfW3BlbKYsxTIwmQGy12cTCosPOPPoQ0pn2Px9bb1QWtdOARE+oIfGugadlS6+sz98kaC7eSAo4BKi9bNO7KzW32IGs2zozVUaKF9N9Sxy5vduiHfvRBr48DKtAuu/HNxjX77UQ6iDhIH7dggOQ9wO8ECYrkcmdpSlDL4jKpaOTFuz80I4qvrtjKr7qTT8+Ag2fxo4fd67LbAs04E0CQgkX63SwAPRDF3f00iukNSBMxbjiUVnC1iLyGRlJjCQS3EBLrRvoWjlXAqmowEHf8+jj89ewcnfQy5qy1RfxK/BQfETXKdkbr62/k0B3n8M3ayOzTA8BuUgg+ckzh9uqDbKIjmKiOzJ072Bk7wDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

When swap is disabled, exhausted, or unavailable due to memcg swap
limits, splitting a large anonymous folio cannot make swapout progress.
The fallback only destroys the large folio and inflates split statistics.

Use -E2BIG from folio_alloc_swap() as the explicit signal that splitting
the folio might allow swapout of smaller pieces. For other allocation
failures, keep the existing activation path and avoid the split.

This preserves the split fallback for fragmented or partially available
swap, while avoiding it when there is no backing space for any part of the
folio.

Reported-by: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 mm/vmscan.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 26df81e773ff..457049e130df 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1263,6 +1263,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		 */
 		if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
 				!folio_test_swapcache(folio)) {
+			int ret;
+
 			if (!(sc->gfp_mask & __GFP_IO))
 				goto keep_locked;
 			if (folio_maybe_dma_pinned(folio))
@@ -1281,11 +1283,14 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 				    split_folio_to_list(folio, folio_list))
 					goto activate_locked;
 			}
-			if (folio_alloc_swap(folio)) {
+			ret = folio_alloc_swap(folio);
+			if (ret) {
 				int __maybe_unused order = folio_order(folio);
 
 				if (!folio_test_large(folio))
 					goto activate_locked_split;
+				if (ret != -E2BIG)
+					goto activate_locked;
 				/* Fallback to swap normal pages */
 				if (split_folio_to_list(folio, folio_list))
 					goto activate_locked;
-- 
2.47.3


