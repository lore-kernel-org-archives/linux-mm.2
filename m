Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADC46CC6B2D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 18:30:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D11A6B0099; Wed, 14 Oct 2026 14:30:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A8936B009B; Wed, 14 Oct 2026 14:30:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E5146B009D; Wed, 14 Oct 2026 14:30:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0A4B76B0099
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:30:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 919C0C0259
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:30:31 +0000 (UTC)
X-FDA: 85322072262.06.43B6E0B
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf06.hostedemail.com (Postfix) with ESMTP id B0BC0180014
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:30:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=E3z6B124;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792002629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4zyKedNJpmpuM86GYUmjidd6QzKLk815HOP8Xrauk7M=;
	b=lbGfC6DN/QgmdyasXL2iT/P4qBQBPFoAn53VKYyhE4i/uSYJYjpC3fJ3tUV14JQc+3SUm9
	SJ5VU0lmf31ML1yBXr2hbjiYqENEzkTsAXPpR5LQKjECDRruVm8d2ahWJK0C2n4L21ermg
	yLnCNqNE/2Y/sva5Zd5kQ1Ngq/lThx4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=E3z6B124;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792002629;
	b=WsP9SDgrL72fVSRHqwfuxvzO1xVly5OYnPqBsIpVF9zykYPrAcJtPKBPNVLRjszaovIEfT
	bqeRJZ37w6cqnuXPk/VtURsABf0aN1esoJSV8drLOccN/UBeYJo+BDr4NeeApB0sBUbB1J
	j5x3UvugV04iXeYVRnLfayFb1j3hIws=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-917866225aaso62815426d6.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792002629; x=1792607429; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4zyKedNJpmpuM86GYUmjidd6QzKLk815HOP8Xrauk7M=;
        b=E3z6B124ibiMunyhYOirgDJI7AhqpKqRq/LRoE1lwXCQgglwyIxkdO+oBF909l7SWG
         Lp54bm0bFupgFu4BCJ2yT3yNRNrd+5kWuFJeWa4g7ILQlWXrxi6dpRWrVbQNp3Olrpm8
         X7c1jlVppo1ccWlXeVJyZ0daJAfinDNNrYOx8FDBCBWWOBcsg7B1S/mDCAaaPCVE7nJ+
         xizZz9EOU4ga2XCm4IEd6VSlXtXfTp8ywnqtG3Okg6iLHiqu87Pxyo0ojZzJ+W5EGq5i
         Wx1s/d/29tr+ZpRvbCEC8glgb6VoQyw77CcT7Zf0Bx+sfTn/5tpPitj1pEsGynUABBe5
         luUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792002629; x=1792607429;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4zyKedNJpmpuM86GYUmjidd6QzKLk815HOP8Xrauk7M=;
        b=KkxgS5X72Fwz7KlyIoM8btxLXSkfM6gc08pA+w4iakCVeqipt4DVmLX5QciAXaN02c
         ddyufNSBug6grd7qXz+khhd2XCNbYLO/mdH8LQt5omEI+a/QqZELvlU/nujPf33J9vJr
         Jbga/FQz2bsfkBKvBppSpZlJin83GMyQZ9Auq7O2yWAnD4AcmDoEc/p+cmy8m4KbGCet
         Ua0cQk9oXWEV/8Le5cgW+pedkHC+pedTJbz2IRIXiY2MfTAFoomkiqeX+rv6pcWFGySr
         LQG7eHX36jHAUmN35t6rTj8r5juF83399hRsv++gc8Y+07hojah7w+v+zcSVN9oE7Eih
         pZwA==
X-Gm-Message-State: AFq9FYJAsyIMbmY8yOT5y9QKwVoIh8kfd5O98MUaAc0YbPmoijQGLKCR
	AmqewOFscc2VI37Tx3vhhoxEpVkA9ZBTB9j70rAffxxLBq0vWf/gRjb7g7aFYlhGMjWqWmLhn5T
	dpKSSPfM=
X-Gm-Gg: AYBFou0kpkyj/uqULeL9/q0NpdHDpLIFCOvgWzCdQGAkPtAOKo+UPXSYuToyARUrv/B
	T7Tt7PV9C6sRQCa38L2Sqj3Rw6hAnNV49wALTsr78YMVVdUO0fb0bGBaQKT2TMXyOTTea9qeWgi
	SHuLme0Iv8j0aNG3+JW5JXSnU4zV/rA1A7dFBeCqt6Y26wN8mDXsexu/eo2ZB/Pnbl8RIhN8gGH
	pNde733mK1bzJ+vHam0rQSCXfX4Ot3qwRLAhk87kqCZgiOny8E+VrN/W95L7QEJap/RtRrCu800
	K8JuciibNCov3/Y76/rnUCCgY6GNJfUcmhB0/NVzqG2dwyrUsPSKVImkEtHjZdPi/gOxqhbzfrp
	Q8UtaK+5LpKKjhA8EYQs8otjkRs9QDQ/wmHIB/yl0hWMwUuioJVnMHG8fSwSKffOSHBOV95a2xu
	pFwRbuhqAPDyMUvRdR9wFxpVqfLFmdqWKfLyySub4WK0Cjjit1Iy+8N4FOVWwmNn1t/aE8BzaX9
	CLNYqHEfzkSnLL90+UVOhg0J6cPuaJ43SdRZVofeLFznDxzRJvBI/sMmNMi
X-Received: by 2002:a05:620a:6489:b0:93e:9171:b82 with SMTP id af79cd13be357-93ebd208959mr2566072385a.36.1792002628519;
        Wed, 14 Oct 2026 11:30:28 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef508811esm556593085a.36.2026.10.14.11.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 11:30:28 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com
Subject: [PATCH v2 01/10] mm/madvise: name the shared LRU PMD callback
Date: Wed, 14 Oct 2026 14:30:15 -0400
Message-ID: <20261014183024.2075709-2-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014183024.2075709-1-gourry@gourry.net>
References: <20261014183024.2075709-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B0BC0180014
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: bni1sabxdf4rn8e41cbtn696k9uo5s6k
X-HE-Tag: 1792002629-980569
X-HE-Meta: U2FsdGVkX19Flcu4j/yTFLLTfxG/j1WrFJAV2mf4+K/UftjaDiyt7VHfCO2riRPknVsB50etVwHciwG9z+sFT/+VcnpNviqomyrRD0AgZptz5zg46/s+vRq5An2QeqqKc+6Q+xSJYpqhfAskEw6FUuf5AYSY/wy94M/r+IBlcjwAwDrgg504BkCD6zFkGjCzfMuCA8Py9Uj+TxXPXR0iyJ+I1hCky6p7j3HbXDWr4QAP4TF74qJKiLjyDSxL6EBQDf2IxtYGRvSuoTHaNPv2894R/gWlOovUbMpM6GLr8wldW0oVS6MGvcMLLqr132KlqaIGrUgndhT8ukhpIj1IQ1TnNua7MUjffS0DiIvHFQU5neZlTxygWQE+Q7ITGwFPGWOiaPNSpBXfxHqYeiUNCqeiRdDuHA+KiI1LP1UPqIv6wYQjydF3H5SaaHJHVwbwBRugC5d8iZeyXiehoU9aSw93Bv5UjGzPnSTVkHt+r9dmb93DKDJh4i28eVc4yVVX5JDWmf+ZpqvL6hOi1idSIRM2wTZjdbL08DpDxQR6DmU3HtaDKrzhaQG1yDDcv8DXTmpwyxNo3iPvH5YlguMnC6Bpu457NHvFQxrrQ46sHOuqU219KeyTlWQw+opgKTY5EZXLUUgpAwcb5B9830LIj1EOXGUDqKR/AqE+iNlzDgauV4DLKG14MmwbWn8JG4HBrfvkN5Rsgj/NQxy58tPOdlA791ElXPJSqdXcy9YqXmD27Rfp9uMSc4zoUcH097J4DEjCrHO140NsyykjOP/PXoDhxv+M6qqp26XwvsWfGMHEZSEJPpRXSnLBwSGhrFJtTePUK0F9w1vzypimQB9FdHrh8X/++0bc8Cq5WUvX+uIVOGhmdFRzWjhke6T6DxgVzdTfLcW9eghLDL9sn+zeASjEH7nV9xbdXcH+nUCtzTI9gjhqNWdJGoAzql3V8BD4KSD8UTlvtmoaCikX9yR
 lEobg1YP
 H2A/cLPu4YT6/Yysw9Vwg/fO8VrTbnT0drmg1rCkYIkOnvTpfDsAAY1J+AvziwechcXKapM49q76hal2TPjXLGbkg0cNHjnPq24YyLsehiAtXZnDxw3PYvM8tRIjt+4HnwcmskcRGsuXTWHcWY7cKN8F57ssxunmVR7wNp/8KBTw6KZKzefFvkt5ZJ837JKcJq3+8CIQQQ804gJ6iFgHcntBX/J1X0jsMSOy6EjHc2A1A/x1kUjS3uimey7CszReM04wlHo2YAn4UDWZMxT9geDL2Su3apBa6QqApchrKL60sB263852c+dTQcaHpqI2tUPQc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The MADV_COLD and MADV_PAGEOUT page-walk callback is named after its PTE
implementation even though it is registered as a PMD callback and serves
both LRU operations.

Rename it to madvise_lru_pmd_entry() before separating the PMD and PTE
paths.

No functional change intended.

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/madvise.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 75b409e97dbf..f15cac3faf61 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -360,9 +360,8 @@ static inline int madvise_folio_pte_batch(unsigned long addr, unsigned long end,
 				     FPB_MERGE_YOUNG_DIRTY);
 }
 
-static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
-				unsigned long addr, unsigned long end,
-				struct mm_walk *walk)
+static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
+		unsigned long end, struct mm_walk *walk)
 {
 	struct madvise_walk_private *private = walk->private;
 	struct mmu_gather *tlb = private->tlb;
@@ -578,7 +577,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 }
 
 static const struct mm_walk_ops cold_walk_ops = {
-	.pmd_entry = madvise_cold_or_pageout_pte_range,
+	.pmd_entry = madvise_lru_pmd_entry,
 	.walk_lock = PGWALK_RDLOCK,
 };
 
-- 
2.56.0


