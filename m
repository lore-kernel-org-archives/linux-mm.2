Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75C40C982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 05:30:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CAD26B00A6; Thu, 17 Sep 2026 01:30:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A2F76B00A7; Thu, 17 Sep 2026 01:30:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B8CF6B00A9; Thu, 17 Sep 2026 01:30:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 47C3D6B00A6
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:30:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C0AAD16022C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:30:47 +0000 (UTC)
X-FDA: 85222129734.11.2FB1124
Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id EBD73A0007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:30:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lr6CzNYb;
	spf=pass (imf25.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.228.41 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789623045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yJbFWtXzdjoxqLLRP1e19uuFJMa1NhU30c4WN8jSX0Q=;
	b=PZipQG/XgW4oyHfVVXS0SOrJJEBD1wy/bfjUyP8UIIyf2IWCrz5l6IbwX1PkAuwkQVVAl0
	8ZSoWSY0iN1K+wwS83Oy94YKKCrOivHJk/J0St5+or8Sh7JVTsiKsmZd55YVem3mzvXSuY
	bKplEkKSAfNq7LsMaobCQz1xylsh3kc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lr6CzNYb;
	spf=pass (imf25.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.228.41 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789623045;
	b=JCehJl2kbKIKBL7Fw5kScJHEtpoLrItZ080YDeT3OCCRn9Sg62+dKzZPC/Pt4mRP04uW4R
	CjKODzaevH/RSmBiXSuQjrMCCGFVgEAHBA3uDkMAmDRHhJAVamj+2e5sbioJgGXaslBd4B
	QiMi3rn8shD3rFipoGFlf6D5E2agYPI=
Received: by mail-pz2-f41.google.com with SMTP id 41be03b00d2f7-cc50d1b048eso324419a12.1
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789623045; x=1790227845; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yJbFWtXzdjoxqLLRP1e19uuFJMa1NhU30c4WN8jSX0Q=;
        b=Lr6CzNYb9MP3zJsPt3WZCeMUNwy1OAdUwj3DIkQIubbdUrGghNErF0r9pAH3skQI02
         9u/7NgjNQjqUlKdSCXjdm1BnzklBUJZvqqt9NLeP4KExA1EoQJaqgoipb8+tpGvfJfQ2
         EbO9+V+yz/gHPDVRKKO6vr7Sm5P6jyxGj5PAYYmNrEMT78djlvfubEbqFtPQP3GPIn+7
         xVi/L2PnImT+Aux60JUvLMVLUpq/AFGDYaoIAv4uIlWxJVmYfIaEy4uFUw0S3D/xTUzM
         TI4IjDes/iivXFolyEu5A8JvgM+EitU1OhCP4AZTnHa1/M1NBDOk6Hwuoiy8Jw0XLuW4
         WaTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789623045; x=1790227845;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yJbFWtXzdjoxqLLRP1e19uuFJMa1NhU30c4WN8jSX0Q=;
        b=CyhYNNcLCd6lto5u3lfDKk8VMoLjnXpjH+JQBK5u+pwfht9WZqm7G2Ya/kQq8G22nm
         QvH9WhaizPfM/N4t+8mrBMOJRIMLkFqrZFmZdioUW5PXx2ziQ56ibCAS3Asq+2Bt6PF+
         5gCALBwiMDZtAPiG2Zez4Zt8QI2aA+MdY8hSreguX//UEM/lnPDc2Ao0LwOvnDSz3Kw+
         gVgY1m0Ly7puxpTuk/1OWrNo+4Ob3i9PAUWSjV4RfFiCfw9eHV42kkA9mNno4EY1tI2E
         9PICjz1ZdEI2ckrbla0WupSwu+O1bC6D2kG8jtvmcNo7vvOcxo/HpGjiDuUtZSFi0wsK
         rHNg==
X-Forwarded-Encrypted: i=1; AKwUvByOHm06HBkb3N/BAQZ4Zw819nq/hMKhOWUS4v5mD42T3fkdCg5VYHd0/LDxZbxZzOj+SAKS9LfS4w==@kvack.org
X-Gm-Message-State: AFuF++laDvBtRm8avHvcH0eZ2BGHTkJWm+ZMtUoFHVmDJi8aQQU6dMEd
	M8xXZdTETGhe4fEH0eTfH1srQJWS+3VlffQ2002uXF0VTiPRGsMi32nwnj744A==
X-Gm-Gg: AYBFou2lrbwrBqpQUVJIvXBHlHF/eNU0CbacJE4FqSCKetK5BbFcQ6BnytfOfDLTPWQ
	gFHfabsf17VAuK88QwptV0Flpy/IFoBOD/2Xae6SE1bLzq7OAIFsTwx++x+3JNHEq0AJ8kByqaz
	py1fcX92bgnLN5lyfGwnq5oxMQ404cp5PP3Iys+b/SuXgD4ZJErwxHOoz+cTwg4mCZ5ggB3Bpa8
	OQXZX4RpyV4WZycumW/sYpmnu9yctcPvt1HyuMbx/Yr90blCJVQI95S7weTRN9gUIFm/5/ncp/7
	1KaFGjOuzWKv9/IKsg2MFEWuhUWXEDz8riofwtYmMvy1TOLThrUV+IPs0e7my/ilIBWDm5idL7a
	zSGHrVvVnHHSUuvXPmqp0rY48R22gQCti0VGQZQY70klo0xEYtKugd6ex2WBwMIhk+vcyPHAwC7
	kAOu0xKFvnn6cMUy52Y05RiVpEGPeuC66Jewr/yJWlL4RCKLxMlw18XQpL0qOhi87Hn3eEnYDcV
	E45ZLZqKLRpIQQmRoHURb5Qdss=
X-Received: by 2002:a17:90b:4d07:b0:38e:2517:5d1f with SMTP id 98e67ed59e1d1-39e1e2ee113mr11267726a91.9.1789623044645;
        Wed, 16 Sep 2026 22:30:44 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e3abada87sm1955836a91.14.2026.09.16.22.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 22:30:44 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	linux-mm@kvack.org,
	urezki@gmail.com,
	will@kernel.org
Cc: Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	baohua@kernel.org,
	chleroy@kernel.org,
	david@kernel.org,
	dev.jain@arm.com,
	jiangwen6@xiaomi.com,
	leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v8 09/10] mm/vmalloc: map contiguous pages in batches for vmap() if possible
Date: Thu, 17 Sep 2026 13:29:32 +0800
Message-Id: <20260917052933.188679-10-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
References: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 7734zs83re3sp1rkrjbhzmdwyhjb1ho3
X-Rspamd-Queue-Id: EBD73A0007
X-Rspamd-Server: rspam07
X-HE-Tag: 1789623045-387294
X-HE-Meta: U2FsdGVkX1+DNAYuBYQnGpamLqI5D07ieytQQsoDUM96uvsYy+3FVpRRexb9xN1BEuTuWVm/4DSJpS1MT9T3JPcuuor4Ce+7i1LQwDouy1tkOFv+W+yfnBIr7nDBFjiX0qBNbsAA3wKA6Jlz+EBSI81ImpNc9AhaOFBV+2e7SRme4TUmW0quxWkKCJAUtmhslZM33pPOnwXZUAXwpI88psuwR3QwljOCVdjlT7nnDV2V7sColKizDyNY8pwytS8rDLaYqwkiM0cc5UdQ+cUbIuQlNKPFbGw0r+iUdLlG0qNqk7x72nk0I3wniItGdd9DyVpmNmNFIcjCcVXu09KYYBjA5fV2HcrzPeIBuS0ma6ARIegaNv/vJChcRS1plh5sDaitHB+JUlGDkHF26Tacf0IGp4U6KRh0EaFJsF9h38gWyVCxuLc6+EQ9bl5pe2uawY4aV12qLtjh8yK6jAVkfIKqds94P/2Glg2ggNqzMDf9H68c4/j46u9+5p8OWE8/dFV5O7g17nGmbmDI8ZZOc8BcHC6eXMPUkVdWWrSGzmdxk3nchWdaGkISdsHYF/8oZXh4JeOS7yC03HXld6rKaz6bWU/qAkeHTqVFkeRYURPP+eNpP7gOQ/mugHviqQamnW3Op/TsJTePPERApFFh5/8TB5DoszJENHbcgaMmCQP8PWLCnFoFTKJAKpB3oxHJn1laTARLL2kLAbgYkgk/Qnl2GPyGK8QFPOPErWsZVy52SfILW/2qGTZMNmauijxBnjCspkgvQPIjvT6m/1GcCbKeZptxnsz3Q6uUPazHWggeNh1S0nMmVWvHXtCtRU7YKPH1IPEXhXE82Dcx5AUJ0F0+NT9Hn5cOB2aH7qW8WHjkLn//roQ3SPhqUYG4GVpEPT09EFk1HdjZ30RrIujBW227M4PR3FeNnwuNwMDSsKU6ssacYpW0UA80RChkRytQqEXsJa0cecWUKnrt9q3
 A4hQQhxa
 UFI9k5nB9+4Ssnq3LVt/BxqBLxtmDjx9k1k3YQqq6UnbpdXRYAg43ZpfZb2tx57nhxsycxiDTEBV7/d70tVfoheb+2zOaq8l0Ky8Z4W43HpP7dMHzQ22QhG8xtOQR96Gme7mv9yTXUUukfnZcw6VW5sCiXcEVN9T42BKLbThMDxWZwNaGeAC6mGRrZN2vkSiQXRJgHkFpVnb6xGhKeon6qYsTUi57UxN7NuiV1Cs7vDHeslPh2a0gk7VQNkmFJWMPhfv0r1kKe4c4Lql8OrTo/eHAfNmbSiZ6Uo0TTYoA0hVmGCrBPAbiqSOaWgvufJEQgkKRpAEijdEwIC3d0K2rBnV2gr7m/uO31ZqdQ2w5H5EkwAiC9futHNREcobvDsU5H5sVvoplAoryR0oyJzwN7Yl/hLG59Dm+Exf9ulFRlzgZ1vSJZjX/xKVx3u2dEFYypuwiQOvOeJY+O2Kuj9zeK/JYTNFl6m26vYhucAmkd116W52cfEZDpTNmJ9OCEbxkh1McdefvIv2Ag7s5LZ+dYKpNYg6nitAng0GttlmkhudxW5408bS04y/8lFgFsKqTNPCyxZG8Z06xIIvFTbNrPbK2l71pIkBr0d3BJq8cQhTl0v+r7UI6NsfOJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

In many cases, the pages passed to vmap() may include high-order
pages. For example, the systemheap often allocates pages in descending
order: order 8, then 4, then 0. Currently, vmap() iterates over every
page individually—even pages inside a high-order block are handled
one by one.

This patch detects physically contiguous pages (regardless of whether
they are compound or non-compound) by scanning with
num_pages_contiguous(), and maps them as a single contiguous block
whenever possible. The mapping order is determined by taking the
minimum of the contiguous page count and the pfn alignment, allowing
graceful degradation when pfn alignment is less than the contiguous
range.

Pages with the same page_shift are coalesced and mapped via
vmap_pages_range_noflush_walk() to avoid page table rewalk.

As users typically allocate memory in descending orders (e.g.
8 → 4 → 0), once an order-0 page is encountered, we stop scanning
for contiguous pages since subsequent pages are likely order-0 as well.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
---
 mm/vmalloc.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 80 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ed868afd8194d..bce2d2c09f546 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3540,6 +3540,85 @@ static inline unsigned int vm_shift(pgprot_t prot, unsigned long size)
 	return arch_vmap_pte_supported_shift(size);
 }
 
+static inline int get_vmap_batch_order(struct page **pages,
+		pgprot_t prot, unsigned int nr_pages)
+{
+	unsigned long pfn;
+	unsigned int nr_contig;
+	int order;
+
+	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
+		return 0;
+
+	/* Limit nr_pages by pfn alignment */
+	pfn = page_to_pfn(*pages);
+	if (pfn > 0)
+		nr_pages = min_t(size_t, nr_pages, 1UL << __ffs(pfn));
+
+	nr_contig = num_pages_contiguous(pages, nr_pages);
+	if (nr_contig < 2)
+		return 0;
+
+	order = ilog2(nr_contig);
+
+	if (vm_shift(prot, PAGE_SIZE << order) == PAGE_SHIFT)
+		return 0;
+
+	return order;
+}
+
+static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
+		pgprot_t prot, struct page **pages)
+{
+	const unsigned int nr_pages = (end - addr) >> PAGE_SHIFT;
+	unsigned int prev_shift = 0, batch_idx = 0;
+	unsigned long batch_start = addr, batch_end = addr;
+	int err;
+
+	err = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
+					     PAGE_SHIFT, GFP_KERNEL);
+
+	if (err)
+		goto out;
+
+	for (unsigned int i = 0; i < nr_pages; ) {
+		unsigned int shift = PAGE_SHIFT +
+			get_vmap_batch_order(pages + i, prot, nr_pages - i);
+
+		if (!i)
+			prev_shift = shift;
+
+		if (shift != prev_shift) {
+			err = vmap_pages_range_noflush_walk(batch_start, batch_end,
+					prot, pages + batch_idx, prev_shift);
+			if (err)
+				goto out;
+			prev_shift = shift;
+			batch_start = batch_end;
+			batch_idx = i;
+		}
+
+		/*
+		 * Once we fail to batch pages, we expect to fail batching
+		 * for all remaining pages, so just give up.
+		 */
+		if (shift == PAGE_SHIFT)
+			break;
+
+		batch_end += 1UL << shift;
+		i += 1U << (shift - PAGE_SHIFT);
+	}
+
+	/* Remaining */
+	if (batch_start < end)
+		err = vmap_pages_range_noflush_walk(batch_start, end, prot,
+				pages + batch_idx, prev_shift);
+
+out:
+	flush_cache_vmap(addr, end);
+	return err;
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -3583,8 +3662,7 @@ void *vmap(struct page **pages, unsigned int count,
 		return NULL;
 
 	addr = (unsigned long)area->addr;
-	if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
-				pages, PAGE_SHIFT) < 0) {
+	if (vmap_pages_range_batched(addr, addr + size, pgprot_nx(prot), pages) < 0) {
 		vunmap(area->addr);
 		return NULL;
 	}
-- 
2.34.1


