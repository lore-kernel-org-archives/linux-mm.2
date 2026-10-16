Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17B04CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 06:17:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 189ED6B009B; Fri, 16 Oct 2026 02:17:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1611C6B009D; Fri, 16 Oct 2026 02:17:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 076496B009E; Fri, 16 Oct 2026 02:16:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D42AA6B009B
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:16:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C606FA02E1
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:16:58 +0000 (UTC)
X-FDA: 85327481316.30.4124559
Received: from mail-pz2-f9.google.com (mail-pz2-f9.google.com [74.125.228.9])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0782F140009
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:16:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e08H150P;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.9 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792131417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s7Fb6KtcWAXnUfcecLaSQ1H6J8YKvEJFUWN8A6hcpOc=;
	b=xfdQSjvicSPldAl1rWdqkvd467fiFOFGSuTVrmfTjtEExh+4VzlfM+6B206AADTvybd4ws
	HA+6OYlURBe9b85dDikqgFhW4vZyo3C4tyWHB+yMdlVi3wT2Dwt8ZIMV9TzYA6BXl8+Un+
	EbrH/h8mQrkonSXwx3pn2ht+nyKbiiw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e08H150P;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.9 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792131417;
	b=1ZX77gzVInm+t3OarQszYauTsA/5g1De/0xfsMbScNyAtdjGTSViKmepNA9Cu8Cb+r6yIV
	GRlrwGE6u6bEH+UdhgvOy+8iG7tmyxlu4IMamKsw/hP99HNb4+jVNWbqZHyWrwNYaJywuI
	Sx7KoY8++7IWEj0uydkINLZ9LJTk7aY=
Received: by mail-pz2-f9.google.com with SMTP id 41be03b00d2f7-cc1631a57d2so1161806a12.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792131416; x=1792736216; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s7Fb6KtcWAXnUfcecLaSQ1H6J8YKvEJFUWN8A6hcpOc=;
        b=e08H150PA/XLbQHnJeHwLpUyfiSwWpq9Xt8QvumNWhBh3yFKKKu/+7jhswa/enAuSj
         n0iBdbRsw7ZXDvyNq72GDmL79WRFDcba2HRF3Oc73cnBPyj22CP8VR49VEJPdvW81YUU
         sUpXGmWGOyVCxbxE/YhHiYy+gK5fZk6Mkd3SlEz9WQ38bhIIKRalB6SBmX2bIAhTC3pG
         1N98XTMkf5s032k+GeMhKkSV2jvOaC8MeeruCfNOhyWwOsOv9n4wg2iqP7yKrZhgP6HI
         DbrbRF++ZUnzFE8+tpaHwP2cfo9Z/ENX9tsUVoG8hBY6VTfhxJfjFVlQXOBGq84lJazy
         f5qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792131416; x=1792736216;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=s7Fb6KtcWAXnUfcecLaSQ1H6J8YKvEJFUWN8A6hcpOc=;
        b=lHzw8DnJB/YCOHDqman2jeiMhNB1vgb+HgbLuaOnBmEmgih+SCy/7Xj/TRDWuNzPq6
         AFB7kUlO8bLRh0q1CIO2fMiqGCBQY8T2H/n85l0WeeaXQxpaaGxlf4SghZkGn223t4Um
         Q0FE7Eb/Endwm1pLApftm51p6mFGe6jI6cdPuFjPLwSMqhqm2AOlAmn0aSn96yqJVS2G
         IJQjyZipD7E0grhjG2LpaLMBwaKObQEfr7bgnBICZrE1BIOgmaUT4E4bVLbd2unuuKzK
         4f3VPUlkSnHctIAZrkCnn3GpH3lFwrkSki/0Pp1Xhopfg9MAIyO9rk81PuJel7s2ShLQ
         gN4A==
X-Forwarded-Encrypted: i=1; AKwUvBydVTSzQx3hnU95Lq+bkSGP1jne3n1WEuxOk+P9IqSoIxbbU/0omBEg+gwM5OdwnLcgXYQfrqOf6g==@kvack.org
X-Gm-Message-State: AFq9FYL8QOR3bH5t+m/4piACPB2wJoBEj8rMpEKJIWLvuaCBmOUAg190
	46edGiz7PmbYXBINAbS/oUlddp5WuVLX7bqnPw6aK2NWcQ0jxCgM4X27
X-Gm-Gg: AYBFou05ncy4oisyhM+iezy4f18fd0m4tWcD+vaoiH/9VLJ0NRrkG4R8KkZxS2CCxp0
	XZcN8DAp8Yo4Gz8sWQNbarPPxqiVT2dD5ImzaxJlMt46VF76Ql//mMnqOaXQ0u0kSBw1/PQpKOL
	xlNf0T705215kB2uoeWybi66KTrHckJ3v60LPuPo9gsfY8suqcR4ilrt3DRBXf/a/Y2xxgwIhMZ
	t00JAYbjMiXae5ziFq9h/JfwLk9/IB16oA7WkmjD0EBx+nDcW0TDA5TRiW+fInMKMZxTyCxzQC5
	81e2/w0/rEohAZlYD5Fx98gS9PwmS4TkeVgd6rGxnD6r1BCcXbelAaEA4RSdBIGa4dgbcNl5IlU
	jQQn2jQ2Vv0xMK5W2vkAea8i1fzJokz6T2tUiGhYkZd+pVUC4KInLGdzOAxNGEl79aHOdMcuPv1
	RNg+UyYet4/fGnzfJn5LbeVLKmrPI9T2/e7u7oQurPHz+1+/AZBWYmvJAAhJoaZkmhj0jYiKa2a
	U29KXce61E=
X-Received: by 2002:a05:6a00:b8d:b0:89d:ec58:ce47 with SMTP id d2e1a72fcca58-89dec58cf9dmr5849396b3a.55.1792131415787;
        Thu, 15 Oct 2026 23:16:55 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f57b334e6sm586375b3a.42.2026.10.15.23.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 23:16:55 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: [RESEND PATCH v8 4/8] crash_core: replace for_each_mem_range() with for_each_mem_region()
Date: Fri, 16 Oct 2026 14:15:45 +0800
Message-ID: <20261016061549.4181390-5-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016061549.4181390-1-chenwandun1@gmail.com>
References: <20261016061549.4181390-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5gqam6ariixk59nep9bf9itwbocjbfaa
X-Rspam-User: 
X-Rspamd-Queue-Id: 0782F140009
X-Rspamd-Server: rspam08
X-HE-Tag: 1792131416-676888
X-HE-Meta: U2FsdGVkX18zJVxs0KZlWWFGH/EnQKNV4tRrtNL0Pe+FOvwikO8kGfSFXbMc0j80buIXjOMMhMhgKBCtv3smuEeUnzheGfzBjz2yvxpTJnH7gQyTraa7glhCRBlqH3uIPeIx1koZzsAIAzuXiCTeInB3aALSMuJ0dswFs3Y+s3G88gI/2R3UoXHbcSAIglMyBx3pliK/4W96AsdYb4roCphV7zj/DcNdBKpwJ5Vz7td+guVkxsjwO7ElDimfkM4d7VshA6e6hNm3C7R5SFHMfXo5Xw50J5RHoOcngVbYcrfX38n9zwkYpeT/Q/Q0MXdDTsi2xaPw8w0zL1Pt3rOv0ymdgSc06HVnkiBUQZmWDOs7tV7XDDHmHVmCFNgJlnBtyGC3366dSeE2lX3wK4k7XOzSgEZxuNzSbiq/Mp0Wry0YfaMpOepHxMPPTQFzbILHrQE6ly/lBSiWVGyBh+7g6KSod+yFvhKE1ldZ/SdaCvpeHC2cLCb5uwuiXTNK7NHeibsZr5FzNtIFn15rbZiOfnbBtGw32kIWJxutbl8GK/2Ft1zmvN2lYqMhP1xb7m4Og7IsspAC3GjMuG5gZegTzbUyJESTlO8s744rpe9hI8z+ELMuSJS1KM7p1m8MST1h/tPNNORo8aHOR83kepQC3TQnx2crlwVA2wdZlON0q7TvTPOfxo/jWt4wqfjMyCdya0y7QRpwSBXWTtkFc0C6LN/Xsw1CMbBk8so9nGuMJdr5N7YF7Rid24MMqFt1c4xS72Y+LecAoZ+kGo/5PCJGlpVxJTUa9/LYRXgMQKih/ZQU0Gi0cOfagHiRvBlP6wn2Se65jqmt6/w7Pil6gP1u9lq4a265ZACMoRi/N/x5G7+BEXnm+lj+roufSCwO0Ktwv/4s/sVxtROMoTzAngOXVBwjrZ4rzshAZ27Hx/otLhJuv2OyI+K7zzn0HVWJ7tvEilM2RH+TOFBf2rXCb4T
 FaVshfMp
 bobHS10XRvfz1jgLYIr/NiIGCcMQoWCub92wl3SNBgETfvv2hCC9gSunONQqvy1j3iXY2PNDKUtEGKMEtJtwZgRYkYF3nhKgOEC7pFPb6rGCJc0fMAlnbtkqetRoag0loonRphn7Y9zfJFm7EVk4FHPExJnL5yIrbehVIr6JmgKGVHFyoW+c74udum5DJDtfRESJEcgwO3jt7uYKiERervNTsBp+WFOIYI+k4rBxzAyooLa2BFpYY8PBHsSh79gj7Z/1tFbP64jQT5N+GQyT4BECtqlWrTF7L46dBv2E1m7WTlRjT6XzuEMmK3+zxyFPLZaF2AHvnu1+44v4sBq4NohIUeBAqeyuQAudmedDtB9bfkQ2v9gMJ906xc/KF+oZRWn6iD/ZH/siwpMjEkVh8rvKJ1bC6ZXaABe00MVNQ0HTcKr1UpjGR9YSouv16A5zQ//j7zmatNAcm8AJD7Jaw3L6R1cmvcVldfM/feehTijDx0zwYYBDsRTN4RXBytlwQcKFP9qVqrshthjmR3ncvxGm/l+qVU980lIbyr9D+T5ffdT5B58gX5QXhV1FNkrdcz/WCnSv2pyLeUF8N5k1rFZ9yyMzM3XLT0nhBDh5HMN6W10ZBFrmmiP2gYnKYEAiEGExX7yQdjHpzs7BLutEx9i/G/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

for_each_mem_range() skips MEMBLOCK_NOMAP regions implicitly. Switch the
weak defaults to for_each_mem_region(), which exposes struct
memblock_region and per-region flags, and filter NOMAP regions explicitly
via the new crash_should_skip_region() helper. This prepares for a
subsequent patch to extend the skip filter.

No functional change.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
Acked-by: Baoquan He <baoquan.he@linux.dev>
---
 kernel/crash_core.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index 8a861a946e26..e161c8b65e00 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -283,25 +283,34 @@ static struct crash_mem *alloc_cmem(unsigned int nr_ranges)
 }
 
 #ifdef CONFIG_ARCH_KEEP_MEMBLOCK
+/* Exclude NOMAP regions from the vmcore. */
+static bool crash_should_skip_region(struct memblock_region *reg)
+{
+	return memblock_is_nomap(reg);
+}
+
 unsigned int __weak arch_get_system_nr_ranges(void)
 {
 	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* crashk_res + crashk_low_res, +CMA splits */
-	phys_addr_t start, end;
-	u64 i;
+	struct memblock_region *reg;
 
-	for_each_mem_range(i, &start, &end)
+	for_each_mem_region(reg) {
+		if (crash_should_skip_region(reg))
+			continue;
 		nr_ranges++;
+	}
 	return nr_ranges;
 }
 
 int __weak arch_crash_populate_cmem(struct crash_mem *cmem)
 {
-	phys_addr_t start, end;
-	u64 i;
+	struct memblock_region *reg;
 
-	for_each_mem_range(i, &start, &end) {
-		cmem->ranges[cmem->nr_ranges].start = start;
-		cmem->ranges[cmem->nr_ranges].end = end - 1;
+	for_each_mem_region(reg) {
+		if (crash_should_skip_region(reg))
+			continue;
+		cmem->ranges[cmem->nr_ranges].start = reg->base;
+		cmem->ranges[cmem->nr_ranges].end = reg->base + reg->size - 1;
 		cmem->nr_ranges++;
 	}
 	return 0;
-- 
2.43.0


