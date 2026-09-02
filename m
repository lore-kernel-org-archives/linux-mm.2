Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C49BC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 10:51:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABD546B008A; Wed,  2 Sep 2026 06:51:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A95926B008C; Wed,  2 Sep 2026 06:51:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95EDB6B0092; Wed,  2 Sep 2026 06:51:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7597A6B008A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:51:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F03321A0195
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:51:10 +0000 (UTC)
X-FDA: 85168505100.07.66C172E
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	by imf25.hostedemail.com (Postfix) with ESMTP id 439BAA0010
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:51:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=D34hovzQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3m_-XagoKCFYJ1CBB23CFH4CC492.0CA96BIL-AA8Jy08.CF4@flex--vdonnefort.bounces.google.com designates 209.85.128.70 as permitted sender) smtp.mailfrom=3m_-XagoKCFYJ1CBB23CFH4CC492.0CA96BIL-AA8Jy08.CF4@flex--vdonnefort.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788346269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tkcdapIGW4RxTiLPx+DO8uuzWqNmooyhO69bXNbCQ5o=;
	b=pAxSWMbz7n2x0+deZbzdGSX2Md4dMb8dd47RoTaJ9Q++WAGBNzGtZfwdN9CT1MNblu+QGS
	M49kk984QIRwFfpcMLmQMAt0hr4jfvTKMfu2mTefbsJNpBp6TXy6Hzp5raLMCFi+MUKXYN
	7hNkNbeFcEXfWhF3Q5oPmG+bzqgqleY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788346269;
	b=e15dDUaQCH2R8GhzefS2fxxevF0VID5qRQKTqolW7o8YYxVsx2gqM9nfD3yIZ5gbukOWjT
	heyBNLTbKgYbPv2WR8zc4JdN+HbXrHt8M2YbSzkYqhFLhHIB9lbTKe7tuFWLYhgPC8SUjt
	fV+hNBVD+OSOweTUjmVKsacAqpYs6Vw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=D34hovzQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3m_-XagoKCFYJ1CBB23CFH4CC492.0CA96BIL-AA8Jy08.CF4@flex--vdonnefort.bounces.google.com designates 209.85.128.70 as permitted sender) smtp.mailfrom=3m_-XagoKCFYJ1CBB23CFH4CC492.0CA96BIL-AA8Jy08.CF4@flex--vdonnefort.bounces.google.com
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49ccfbe060aso6225405e9.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 03:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788346268; x=1788951068; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tkcdapIGW4RxTiLPx+DO8uuzWqNmooyhO69bXNbCQ5o=;
        b=D34hovzQ0wDLIhmHFROELTI34aL6TaizDQqu3bStY39fCMi+2sSCx0AjEnVV4wgWHh
         WyqQb5tC5wXUhPeIP+j7N3cPl+0Rqyx6Mr5LlFadG08eSgmASYqSZpVZacrq5aRkqeDr
         FXcL7IHBCxAryZNdIfUb8hAj7dQe9lpzKGj2226M2gW12oRtcZtgUDwMXrkjQi7nlnuW
         eKayQYAfGaTBU3bLnnLPyYLvTRmNoNhIgJV/3ol3J8jjXWNBW6/jVgxKobp7Qr+Pk1wn
         W7VVjMtMImJ/Vi3DK2sXwWxlsDoFqo/NXApwACfS6/qh/ggX9NUpVNC6kzFy3AHTWiD/
         U7Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788346268; x=1788951068;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tkcdapIGW4RxTiLPx+DO8uuzWqNmooyhO69bXNbCQ5o=;
        b=o8paxd0tYOX9w1aZrv18em8iQqmc5ruRCBMyPmTXS5h5kcRHehwe2XDkZEgqCXk/tj
         yNZTgfrwuG5rDlgXveU8JXf33GRlRgy9uAo7o02M4dwaY03eiJ0zaL3CjKao5uu2ip5+
         8KurryM4LU0rl1zKQA8M7Fla+li2A1HXjEcXs7ru0hqLjBcrNi2G4264HCGoZh4IUAH0
         F4bs+F0giCtDdRQZLfpALnPZVCU+QCMHLYFNCYtOU+V9RF7I4av4eUYOcCbdl51GVEcu
         NqW82izMDvALxjvThAv7vLeFEWmw4LFKNle43LVWZBf84m+5SDeLf9ApEoTJSlyXlWqE
         N65Q==
X-Forwarded-Encrypted: i=1; AHgh+RrYrHem/AQpgR0VNsQvZ7yoZpGA1o+uO677qk148wmlCB9UEVYMitWj4NZ0pScOVC9++M6GY8VVzg==@kvack.org
X-Gm-Message-State: AFuF++mzEGYejQwJ5lJuqBv786SRbXFVzXu4sNm6A/VdxEioRoY9PMjM
	Td+X5wD6RWe5TwujY6Bq+Ez9POm9aYaaXXseFrf2IpfoRco/xvOanxftpBWBWfspKiLt3QTqPEz
	2WkyfnB+Iaoi5Co3hmTMwTA==
X-Received: from wmph35.prod.google.com ([2002:a05:600c:49a3:b0:499:b2be:d4b])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c4a6:b0:498:952:e276 with SMTP id 5b1f17b1804b1-49ce581142cmr69791455e9.8.1788346267736;
 Wed, 02 Sep 2026 03:51:07 -0700 (PDT)
Date: Wed,  2 Sep 2026 11:47:03 +0100
In-Reply-To: <20260902104712.2399797-1-vdonnefort@google.com>
Mime-Version: 1.0
References: <20260902104712.2399797-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.970.g62bdec98f9-goog
Message-ID: <20260902104712.2399797-2-vdonnefort@google.com>
Subject: [PATCH v9 01/10] memblock: Introduce MEMBLOCK_LLMAP
From: Vincent Donnefort <vdonnefort@google.com>
To: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org, 
	akpm@linux-foundation.org, sudeep.holla@kernel.org, jenswi@kernel.org, 
	robh@kernel.org
Cc: mark.rutland@arm.com, sumit.garg@kernel.org, ardb@kernel.org, 
	thierry.reding@kernel.org, david@kernel.org, danielmentz@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 439BAA0010
X-Stat-Signature: jw1ztoo1uc48xd5rdgi7oahda71niubx
X-Rspam-User: 
X-HE-Tag: 1788346269-301880
X-HE-Meta: U2FsdGVkX1+hM45JMgsyzNrbvfRcw1ZPXy1a2c3T11Qx53pZ1I+DijWgU3Non4LtlQV9ue+3WppFKZNndhEphBcU0VLkZ17//QvqxohoyrO12XIHGhhvT9pVzWztA9JH/jNHZi+C/ygfYcGscFswaG8J2zWJ9ITSh9Xo/pNhVUDYpvfOxpLbyX+DZXKDBfM/urbVpx0/GkI07o3kR48UIk8Y1ReStzz+gy3FJctCLQT9VwFTTPe0ExExn3UXnPDChFwYpZzg5vrUIPYwnlEVhINbip35PPjr7TH+ED2N8H8PcjDWhQMowqpYQtYKvVRt9Jz+LdaUaskpFRe37JVBlWbmxM41QmebkQicG6koiiSUG2nO7a8hRjNsbUN2gT8A7SYcaq6c7KjBNkmYQWNiOsPgPsVRVS5oE66wCuuqgbhTouJKL7lAniuDhRV5JcoHXBDV7v2DdnYt92zhxDaprStydpGIfJua2EeNLlDx4SkJfosaEkdpb4Njg/eJ7ViXmyB3CYKC5JNFMr1K0Yn+XNBv6ysMmYN0NS9kIB6l1tFob9MTnbjqihmtIpW0kQrLxRvR9Qz0litHq2DNK2uH7NTAiLpwj2pDvxoWgpRC9hcnGBqDmgiV2SrcyswbCQZQomvN92ZVhwykDQp1++MhytxVZOKuIVreT8P97RCvGH2p1+5ac4+LoxxR2VgtOtRlcvr31Y5+jJtcobr45K6PmVr8a5ck1KtGdgwpDsW5oCNuxcPp9wv4jMnYops5Clrbm1jpHH4f48abzGsK+7mzUkpUoeJGU3NuUABh47+WEhR8ioGddmW8VnZ//4P+e4S9Cf06m4A8r6FlnCxwpPX6Ac9IPpAouoQct3i4IU6Frw85meUJNZg1ffT6+XwfDwDYvZW7+qKy1Lc0TmQaonkRhz2k7KQABlUCyIuh1G8PxgKpSfyoUKZEez6LG9EHCJozxbOUtHpBaBqEIZ6QtOe
 s/QuV5bt
 m4PuwvCdd1QV+XlcbY/su2E3OGw3+U4nN2ymBZSTDCW1/UBBKu5TB0724VgX4O8JVukr/uQhTNKuj501S10YT0qqJIEkeI9w/JtJhiKDurLvxiNwFMGLxbbkT0GJwwnZ3rTM7DmeNg2gIbX2p4iEJN1PCYyziheWHbEiw8QCzTaRUyAcNn7VR9LB4HxRE/uP8ml1Fl4Gogm6W030hzEjdwFOA8ztyseyR7WNU+23ZFBO4+y+cgx+iVq44BPugucEJQAWk1/+xwMtZ+NYPiTFXbrxcsIl2+ig+gVzLG6wcFry1TD0m1IzhnSHt+jEw2FfwgaL45RpVmLEXZ81wc+cyv0MBf+BGvzS6bz7F/tjY9f06WXeGgyoHiZf4sVv9Zxn1/vGu05XVc4TcVfI1/ydo/wFj4U+yqaXvWYLK0BQFVov+uE0T4rQGOSuEU+LdKaBbQxozWcmKLOJDHZgd/XT/q23etMx62uYIlLOidmmKGwYBXpUBinJRuuCVsjNZ8eAQ+MFevkSQ2JSZdjIil9KgLpev+hnY+nXhTIvy8gT6wPiBVJ7C8umCPOY7OXaVPS1xbiTaRnp/JbAOI6Dn6BXPweGPjPrCShn2sN0SoWdxrmwdyu3PAXupZSweR80MUHlJfK50gPklUn2YvPC4H02AWP7In+3PMpn9Wirh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Keeping last-level mappings is interesting on some architectures as it
allows mapping/unmapping pages from the kernel direct map without the
risk of splitting blocks which, under the break-before-make rule, may
trigger page-faults the kernel can't handle.

However, mapping the entire direct map at PTE-level is costly. So
instead, create a new memblock flag MEMBLOCK_LLMAP to enable the system
to decide which region must be covered by mappings up to the last-level.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index d62db9e776cf..d40a5ded188d 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -52,6 +52,7 @@ extern unsigned long long max_possible_pfn;
  * kernel that we know is good to use. It is the only memory that
  * allocations may happen from in this phase.
  * @MEMBLOCK_RSRV_HUGETLB: memory is reserved for hugetlb pages
+ * @MEMBLOCK_LLMAP: memory region to be mapped using last-level mapping
  */
 enum memblock_flags {
 	MEMBLOCK_NONE		= 0x0,	/* No special request */
@@ -63,6 +64,7 @@ enum memblock_flags {
 	MEMBLOCK_RSRV_KERN	= 0x20,	/* memory reserved for kernel use */
 	MEMBLOCK_KHO_SCRATCH	= 0x40,	/* scratch memory for kexec handover */
 	MEMBLOCK_RSRV_HUGETLB	= 0x80, /* memory reserved for hugetlb pages */
+	MEMBLOCK_LLMAP		= 0x100,/* last-level mapping */
 };
 
 /**
@@ -160,6 +162,8 @@ int memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t size);
 int memblock_reserved_mark_kern(phys_addr_t base, phys_addr_t size);
 int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size);
 int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size);
+int memblock_mark_llmap(phys_addr_t base, phys_addr_t size);
+int memblock_clear_llmap(phys_addr_t base, phys_addr_t size);
 
 void memblock_free(void *ptr, size_t size);
 void reset_all_zones_managed_pages(void);
@@ -306,6 +310,11 @@ static inline bool memblock_is_kho_scratch(struct memblock_region *m)
 	return m->flags & MEMBLOCK_KHO_SCRATCH;
 }
 
+static inline bool memblock_is_llmap(struct memblock_region *m)
+{
+	return m->flags & MEMBLOCK_LLMAP;
+}
+
 int memblock_search_pfn_nid(unsigned long pfn, unsigned long *start_pfn,
 			    unsigned long  *end_pfn);
 void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
diff --git a/mm/memblock.c b/mm/memblock.c
index 9ce86349a29f..1591b50503ed 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1119,6 +1119,16 @@ int __init_memblock memblock_mark_mirror(phys_addr_t base, phys_addr_t size)
  */
 int __init_memblock memblock_mark_nomap(phys_addr_t base, phys_addr_t size)
 {
+	struct memblock_region *r;
+
+	memblock_cap_size(base, &size);
+
+	for_each_mem_region(r) {
+		if (memblock_is_llmap(r) &&
+		    memblock_addrs_overlap(base, size, r->base, r->size))
+			return -EINVAL;
+	}
+
 	return memblock_setclr_flag(&memblock.memory, base, size, 1, MEMBLOCK_NOMAP);
 }
 
@@ -1204,6 +1214,45 @@ __init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
 				    MEMBLOCK_KHO_SCRATCH);
 }
 
+/**
+ * memblock_mark_llmap - Mark a memory region with flag MEMBLOCK_LLMAP.
+ * @base: the base phys addr of the region
+ * @size: the size of the region
+ *
+ * If supported by the architecture, such region is mapped at the last-level in
+ * the kernel direct map.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int __init_memblock memblock_mark_llmap(phys_addr_t base, phys_addr_t size)
+{
+	struct memblock_region *r;
+
+	memblock_cap_size(base, &size);
+
+	for_each_mem_region(r) {
+		if (memblock_is_nomap(r) &&
+		    memblock_addrs_overlap(base, size, r->base, r->size))
+			return -EINVAL;
+	}
+
+	return memblock_setclr_flag(&memblock.memory, base, size, 1,
+				    MEMBLOCK_LLMAP);
+}
+
+/**
+ * memblock_clear_llmap - Clear flag MEMBLOCK_LLMAP for a specified region.
+ * @base: the base phys addr of the region
+ * @size: the size of the region
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int __init_memblock memblock_clear_llmap(phys_addr_t base, phys_addr_t size)
+{
+	return memblock_setclr_flag(&memblock.memory, base, size, 0,
+				    MEMBLOCK_LLMAP);
+}
+
 static bool should_skip_region(struct memblock_type *type,
 			       struct memblock_region *m,
 			       int nid, int flags)
@@ -2886,6 +2935,7 @@ static const char * const flagname[] = {
 	[ilog2(MEMBLOCK_RSRV_NOINIT)] = "RSV_NIT",
 	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
 	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
+	[ilog2(MEMBLOCK_LLMAP)] = "LLMAP",
 };
 
 static int memblock_debug_show(struct seq_file *m, void *private)
-- 
2.55.0.970.g62bdec98f9-goog


