Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B8B5C98308
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 06:29:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FF8C6B00A5; Wed, 23 Sep 2026 02:29:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 788C16B00A6; Wed, 23 Sep 2026 02:29:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 677686B00A7; Wed, 23 Sep 2026 02:29:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3979F6B00A5
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:29:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 37CA21406B8
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:29:35 +0000 (UTC)
X-FDA: 85244050710.27.C14EDCA
Received: from mail-pj2-f33.google.com (mail-pj2-f33.google.com [74.125.227.161])
	by imf21.hostedemail.com (Postfix) with ESMTP id 685B21C0005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:29:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VXuSkm5e;
	spf=pass (imf21.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.161 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790144973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dEaCg+SoOuqpLOGmqy1zgShmdKDFtyrROF+HoSyjUpM=;
	b=4oyYdZtFPli+fIHJ/igzu/35gYbAaPc799t21WnQOW4FMGhQV1FZDvWx6X3L+fo/bZ1rer
	sXet4wvukIG8OAcM177wRyBh5owQR6ICt8TgevRx3YrVOpv6LoWR5Ye51dQmh18RFEluEg
	ZjsoHKsP/mtdkUEdnSkgmVkm122+Ty8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VXuSkm5e;
	spf=pass (imf21.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.161 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790144973;
	b=Caw21SPYOGShKFsgPx2Rr6jMP0AII1GjRf5fwgpBuVFc7lmNt2DiOwAc6TwQXv0p6HwLev
	Jm1g60rWZfQY/q1C7uAedSMP4RU5vHIgM4Lg+s2ubtqAaOWJwqRwQmjmR85ypI9qA2bplb
	uM5Q4utcDWK/4rdSJBCCyyX17loI/zo=
Received: by mail-pj2-f33.google.com with SMTP id d9443c01a7336-2d747ed1368so3508705ad.1
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790144972; x=1790749772; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dEaCg+SoOuqpLOGmqy1zgShmdKDFtyrROF+HoSyjUpM=;
        b=VXuSkm5e0yJiqUS1ttNfGz9OBkSc/TAIEedokZsER/uQhCFDEiItsIziWzZYqTU5HS
         F7cinNML50fNOFwv6OjMsIOFbBpTfizjnz+47Zae4URmdQejwTNr8l6Jb91aztr1eR6x
         HTivurhFkcHxsOJ3707KZ2TTHpO+Hu563f1vTy+bdKcLh3b3Es+mNe2IK5xQPjP3Nlnv
         N9gKzanh8b3umYRSV/Sywc6zE4YYUz3GTJxZL3ficVJUNNmjt5skMqWgX+inMcMwC4Tf
         GtXkWyW0qzv0U+mmHznF/OnJ+iq6IV0kPTlfxYrc9usEWYz2qPD9CtAnP0+Sp1XZGrOC
         57Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790144972; x=1790749772;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dEaCg+SoOuqpLOGmqy1zgShmdKDFtyrROF+HoSyjUpM=;
        b=Af7/QZNge1Kl2ZaeqJDxDdR2Z8nXoAX1DRqCT10E1zZdHlBINJD/rSXQ5+pmMpU82u
         5F/SWcKp4dlDbYmHukq7P0nVDFy0lg8HG01APakYY7f2GWmD3NZFt0qd5XPzG7pl2JyR
         3Q2EtoxmTDRMe0zyisB3rht9bBjD3JaIID4sbmKsUB5hZSUT2Y3OwFw50jueWIiZqtko
         XnLuIakB6CMlV3WpiMAyLqNrLJhxz5X2Tl0WhV6nM3YsbP9Z6qKgd83l2Ws4Av5mJlc3
         sH3oI9o/k/7SP8PhVpbC3lem4dhyv/hQYMBZrrE7gxEm3Og2anfd2qSarfI/2FUH/ztp
         ZkZA==
X-Forwarded-Encrypted: i=1; AKwUvBwkj5xb2pz+O0Sp6amIjnLgphs/YAAEUzvlmRnQLqI//AJuqS7whR8QrzQqZqcQa97jylPzM29eVg==@kvack.org
X-Gm-Message-State: AFuF++mGavDO+YAS/lYW+7basDmwhmzw+PaAw+muk+DWUn9aoFYVkHX4
	bbICVWrfFvAerCMhRS8bIrQuYc7AgyxyHjRKOWyDS4eG/L+pjC8bSRe5
X-Gm-Gg: AYBFou2fvW14sslRjwOfDOTQfVUX5k9upZhVPM7HJPcClRRYKYJYsz3lHQP5T+QVS/G
	ISH9QuLhEq/9PMyeiV6Kvnt8S8W7oIzFc8/2Tls6ewRhXxTRXXwNMqmpqPuED7Wp2Hypls5CHMJ
	nRIH/Erie1PKPwCzZsoAIpm1OiGRmI9M9f+ofxfCfJrdQIUIfMTyzZusyGmCsdshoaEhEftoqMd
	EFL/fizvEuUME75Octom2lYQZQuEm+MfpI1hyK1g3Yw4vv8lhJcHc+edGGMQoHYBMik8dKGaVt+
	MSgdLToeEF5tUErqxsPjh3MGIw5B0MoP/mDbrTvTx54NQsWUNJxwqrc76VCrX9ar8tXmyZyBiZL
	pXvswQrzJrr10ejdyXvf3ib3RD9W8oBFgqa69adq1EFZCXuvWrS6ymtaxlX1cFMJQ4n++bir/nM
	fHvZSt5cfLHo9MHuNJwPJ+vV7kD33v1f0HGYxN1+fAmdOMZZ7YMem8ddBAd0qMf4tUqEPDDq7Hh
	L3Y4KJHF69XHSiGx0AJtw==
X-Received: by 2002:a17:902:db0b:b0:2dd:c100:b2c2 with SMTP id d9443c01a7336-2df69e01d0cmr15666125ad.45.1790144972237;
        Tue, 22 Sep 2026 23:29:32 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a516bfdsm5620465ad.5.2026.09.22.23.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 23:29:31 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
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
	ryan.roberts@arm.com
Subject: [PATCH v9 09/10] mm/vmalloc: map contiguous pages in batches for vmap() if possible
Date: Wed, 23 Sep 2026 14:28:31 +0800
Message-Id: <20260923062832.479455-10-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260923062832.479455-1-jiangwen6@xiaomi.com>
References: <20260923062832.479455-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hm9fiispoh9uecbyq3gb9w8up835bp4u
X-Rspamd-Queue-Id: 685B21C0005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790144973-838246
X-HE-Meta: U2FsdGVkX1+u3ADD8ojz++N9851y0kXg/8LNLtZahvcCEwrXv47McLYdhoOyj9j9NUAU0qSlLKEs/+rDhHQAtQ3suR0gZub+lbAZOGgqhb8/8bit+8WfsrJlwfrcRfX4iL95EjUwElGaD5Wojj24kn3QwBJYnRj6oN+92hqJHEYUSqYVioOwFI8Hq3KsAUfh7IDkBUqrYPsxX234aLIviI06s0LNSGnNfONaW3ADtLdpvyujvQW5SL3tN0aPFYwAgnO81SMt5OqTw2vSo5pTYCddQcDzrIuICSTUf3o81YRtmaMglomTVnsLS3JLnR0e1aX5KJZjHOXSANDy07eD+cfSXisLLCJB1/3s8GBr5tQpOWzKqMFlzlj0rVUAxA/L/DpQbM8lplnPqH71pFzj+c9tTqbG9wYOkW5pDQj++RrkTqLeKsOndeX13vrfw0uctGahAlKX/JkYQSW2pCQ6bvsAzApCO3OBP1e7fuIDc/RVQ5wtt6Vhd8cRrc99ziaEZQExAsjq0DYe1Agok5Z+M6aF7T1qLKVXnba+BL3s5E27M9ZUL5+dn6OeypClrP5IP2cbbIZc9r1fD0scVPBmCoRpjnmwZL+Izm+FXuH6bClO/3TNaDi/qhoOFFo3QFnQ9R8aj96gutyLyWdnAQ3mO8vU9I0j1+2rFWxTcF1/3uOZ/vjbJveevgWE1NejVfWE5513JZ5nW3x9T2t7UGgCEh5p9i0RgmfGoXIPdnzyf7zk4U45tMRNGDOYcIkLG3mv/pK2RzsCzAiEDtb6OnEgDNcaXJINEPkDXwf4P015hd/d7EoKQokRSW5Lukmnnfvy2zPveGnCRaO3U8bbMe18XQIrlJ7n66DvzL93GSvLC3g7ADjzszH/8uWsHB9Dd/S5CemhsFGJwgbXwK+uRPvP3vwimtosV9wjes35mTYuZnOcqr14SLgS6j1EHpZzFZ2vPqAk60wJqNktVi66C+f
 hQr993eq
 9voGLo0Pm95zPX/mOlxugt9FlPOc7mn5RuZQckrSGZ/2plV0auLi7mt50yk4YakKaU27POC4J2/kNUaACz5hr4CSik/WpdBRY88BFxCEvYDN69GyJZppK6RjjvjeXQ8nlEMG+oCuTnLMTnzOpfJQbElz7HfRPh/PlqbpQRunhNKhBCiCDxFTtffmNtUly9jtF/CBodJwLp4DrZbWLa6WbVT8I08POqpb1Dni0yVT3IvOfdckWjVMnjuBzgnY0s0Ht/tF9eUCP4K/hgQ5HBdsOervLjJAUZYKk4zACbRCmiEbMWV5KzaSUYn1SjWOgSz8K1kOWGMWwYBaKGD0Zv0WFNxndnzdZScQwc5MHdP7gzQ+XTXrVA/zMuCz+cOiza/nhRv78yU21RaO1lC4I2JOg77zoQ3LdrPTwmQKrtMsT5jUVPxhKu7uKdFkLJX/heuzj92m313K4O47FgwRFQNcHafHjN5euDG3NDOY2eDQvFK8ml/YAqoh1yptPNGzDy0Um+5lCDoNm9mpUyBY0OW3DLWM/DP+y7sHNdomSZvhzPEQ86014B0zeLmFDdA9IaiCAyiLZf7g5uCgS7c88IMTIhZx4Gw==
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
index a43965016eb4d..37cddb7f45a4f 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3576,6 +3576,85 @@ static inline unsigned int vm_shift(pgprot_t prot, unsigned long size)
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
@@ -3619,8 +3698,7 @@ void *vmap(struct page **pages, unsigned int count,
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


