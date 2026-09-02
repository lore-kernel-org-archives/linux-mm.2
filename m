Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 911A8C624D5
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 10:51:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E0606B008C; Wed,  2 Sep 2026 06:51:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3913C6B0092; Wed,  2 Sep 2026 06:51:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E2F86B0095; Wed,  2 Sep 2026 06:51:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E157D6B008C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:51:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7251AA01AF
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:51:12 +0000 (UTC)
X-FDA: 85168505184.08.31E6BFA
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	by imf07.hostedemail.com (Postfix) with ESMTP id B9A2340007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:51:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DQxdiI6O;
	spf=pass (imf07.hostedemail.com: domain of 3nf-XagoKCFgL3EDD45EHJ6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--vdonnefort.bounces.google.com designates 209.85.128.72 as permitted sender) smtp.mailfrom=3nf-XagoKCFgL3EDD45EHJ6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788346270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BmhXowTIOzHcHY7UkEdd72g+gSt6KBOTf5gqmJgT9x4=;
	b=tAv7MzsqkNYCjz0GM5p5oRPwgzNd7AIAOOTypwXOBcI9IMfAlRrze7LKrTwQVI+Crbu6gR
	NXxQUqwtsG1fwsIkWmQWYYcCuVKdfjEj0nGN+TPvTwmYpCwpQ7/0a8iSKDQLI8DYfRVLyq
	B3NWomSUAkkN3bUp63Ev84SxVfo14W0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788346270;
	b=h5vxynIk8U1jS9ZlGfCzmumuBxDItS7g4tS5Zbaa3LrfRYIYc7Ebz/OKXPQi5XWhSbSrIV
	1ctFwMKl/E9TJypxhAlHaV2bzUE9id1qKGQ44kP/IfBZaFerA53eW3pDZvryRNuXJJke2x
	S2ZR71RFPoGs2/lEjUcwAXNBaccC4mk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DQxdiI6O;
	spf=pass (imf07.hostedemail.com: domain of 3nf-XagoKCFgL3EDD45EHJ6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--vdonnefort.bounces.google.com designates 209.85.128.72 as permitted sender) smtp.mailfrom=3nf-XagoKCFgL3EDD45EHJ6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49953abe51fso5056975e9.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 03:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788346269; x=1788951069; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BmhXowTIOzHcHY7UkEdd72g+gSt6KBOTf5gqmJgT9x4=;
        b=DQxdiI6OX2mx25AOemL5brQgS0R7pPidQd3lwU46NZAMUGl/3TN+fnLzMQGSEexg0I
         mVycPd62crrbNm8oUHvLCK7DPm/JuNmhDy/cmXx3vwO/4K61HnYtlb8TO+1n9PzyGICW
         FsOLnb14QiL71N5bbOfFySk4u+CCuxXW2BC5nWlsGLfJtm7+I8J0j1gwH2HLTbbEyfTB
         LVP8hFtIaXFu7j9cB2NPzLFTNqwCPqhP/oGpA0IsZVa/th6Y6pPByvymSZRtLIf2KpTq
         kC9UrKnYzg/cu1xSNVXAB8kzy9r46mCR3+2tYel0/oMvrep5AKG5w31MVi/mNSDq+HkH
         hRug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788346269; x=1788951069;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BmhXowTIOzHcHY7UkEdd72g+gSt6KBOTf5gqmJgT9x4=;
        b=T/RlJ0iirOglkgHFNANsjd+x7qYaAMsEdUGfRU2QOHzJmk/f4da4I5iGEX65JAvUOG
         uprPq05wyrtxKGaGeij+EVAJqBi2TOvrNIGGnH9XKEMUd6SK2Fl/jI7Cn7lwS33iJLIE
         viW1MEup3STP7BhlOP69hrVrwygGJapWvyuGgTAWar1dAHUVhaFRdD8ah+92IaPLqWnO
         9TjOIoXg5wt7+GE7m+mVn91F8FPcRR8k16r3mHgbnHeqVy2z+H6uzzmzABYdt9rXApE/
         MeXJlavBxlLlEUMdolk4GCyVHG4UcA3hCgPwxXmuNZeXtXjd6O69PIZMVdBb9/L3bEV7
         6Zjg==
X-Forwarded-Encrypted: i=1; AHgh+RqLSifppd61agPeknJSqNCTCqRHB8/7v5ieji/aSzz2C93K8UcE4nya88COrH/8XlAxQSgf1WS6Eg==@kvack.org
X-Gm-Message-State: AFuF++nb1vLtk3ETdjjMjLuvbQoU+1mthlog47NS0VSPdBlSlQflYjYh
	6jnWfP60ZDvbVFjjbLb5x8UvNy60u0uYErlqsbtpMkMznBdowlbiPaRidvfcmg6jZDAFUdFv1+A
	rW+dbYKfiSHZ6xKQwLUc9cQ==
X-Received: from wmbgx10.prod.google.com ([2002:a05:600c:858a:b0:49b:96b9:9d0f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b18:b0:49c:d26a:cf70 with SMTP id 5b1f17b1804b1-49ce583adbemr59327195e9.15.1788346269076;
 Wed, 02 Sep 2026 03:51:09 -0700 (PDT)
Date: Wed,  2 Sep 2026 11:47:04 +0100
In-Reply-To: <20260902104712.2399797-1-vdonnefort@google.com>
Mime-Version: 1.0
References: <20260902104712.2399797-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.970.g62bdec98f9-goog
Message-ID: <20260902104712.2399797-3-vdonnefort@google.com>
Subject: [PATCH v9 02/10] of: reserved_mem: Introduce "ll-map" property
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
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B9A2340007
X-Stat-Signature: znae1tpe7cahkr3frosu5i58scgrze4n
X-HE-Tag: 1788346270-279018
X-HE-Meta: U2FsdGVkX19wzbpK7C8SEZVyqtk2TQzg/VeC+XEOeNxqdPh8a2SjCY7QlE9xRGm72WyBEqUm1NHV/FsNhgMAwDricwLirob4Jst0FSIiHaEJTXmnzqIYsTOwoxmUbShYjeHsFVe7Q6LKh5q/pYt1T4fmuUALUpeUTtjnmYNBVO9w7l5PL7PwtgyP9bwXS3zFeRVa6dQ3l0OAqmLETpyvqiHMTAyraPqtvWfFlG7hFPTUPdCi3MWxU1f4qP8G0m5cto+97q0uIpy5WDHbZVCf+SM1aao/ixp6XG/826/it3lECvq6O87/kWOFJyaYd3a7OQaQrVhlYA2sOwTfbxBDnd1kKwlBmAaKLuk4cDQX0SN1p1EiCvpG6S+5mV8ULjkVfmsfqh1tgQ1AlxsNNfPUZsweOBo9VRO3c1S14L1sjPew95FlByiSWG0CVfF0nuwIShvIge8btcLjRxV6AhPRgxp3l62gN5BM9likWwCTd4D+MkLokpjvCECqBj7vqArMym1+YVhxh5FAS37T3GJgquFLxfnz5BXnxus70fwlp9lFS8/bNTQFpluz1udKhZ/ZM7CgTbjn6v9UW3/IqhY1CkRLdUMP/5UiDxYn64vR3zuUhwwBuGzp4g7nio+mFGZ1YATk9LPudYEitPZsbFI9+TGRiO7n30mI/441U25CjZfNx7j7tI5AI2gvzNYwnoXuHmyxvS9KClfvEeX87w90tRLEsZ6UcngKB3mRfFC7HiqjeBOlZ2a0JnBE+sEVVlpesadfRPEboB8JqTt/v7dmnn+30jiQ8rwICbxJRGOo9/xRC5KcwNFuntGMVhJA2iDaN593TTr4NmTw8u6s9qA2QV2snRO2y70Lc324rkLsBqIVLlQdxw/q4F9O29B0ixU9gal13mhWl4wzrcF4+d0ZHQguW1o0qcyzClZ0t/gjq83fccYip/5na5H/R7xHdBDS2HyE6o4Mrl2k9GFggYL
 YGGuBokn
 hVZQGtKKp3joqkVALZ4EE6WI6FMEoR5f/UoyhRuI0B3X94u++TZ84ErhY4rhQtxsWM9NQELafoZv8i6JuD6SbQQQGM5TFjnTFuol/VnPHQ9dNKiD6b9Y7GxDJXQFFJoGHd7Sb0g+zvJc/JJdpBLsQmN7iIiilPeDjq3MW5pugEqcPEH+3C73OCba3QN8RTfQDT/SQqcDW8wy4GSk7V0Za2ZKXMqYGCKpIn4XaU124lmYTH6OYNcHm6PseG637pQiBBl0R0DbKXrZdTi2Rb1EP8i//idj4e3x2avw+yNdlUMKFL94QPGEx3wK170iwXyl7gG565oYcgqTRJsTCvFUZ632sPaw5fj5tEN2OmadfaS6Achz/YrxXue1x/UR3UpU+AkTwDOMBkOW+6Mfybiw22hQx71bUedemQjDq0XZG02ECiF1VdLVNIrAlOFlQNGAxfDgbcoevot1R/MbmsGCg9cVATmdRHhF0TKDcWikmQDSdc/1WYh04zmeumhgkO62VMYkluMPL2sSyGEBsP6Bq1Aq7rLCzk2f6jolkn7rdqHF8yG0Ql/ERNT0KXD+afc23d8jJ6ssC2lHeZs7KB9mZwiXTmmyHSfEiq20ChlGsHFDenHyHxIvx7+Vk89CEo9tHDq8FC1hsLVl0D7vNJq1uxrR8+IMIIxyHT7tN
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

Add an "ll-map" property for reserved-memory regions. When set, it
splits the underlying memblock and sets the MEMBLOCK_LLMAP flag.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 8c9d6395d6a3..9ff2d02cb149 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -32,9 +32,32 @@ static struct reserved_mem *reserved_mem __refdata = reserved_mem_array;
 static int total_reserved_mem_cnt = MAX_RESERVED_REGIONS;
 static int reserved_mem_count;
 
+enum of_rmem_flags {
+	OF_RMEM_NONE		= 0,
+	OF_RMEM_NOMAP		= BIT(0),
+	OF_RMEM_LLMAP		= BIT(1),
+};
+
+static int __init of_reserved_mem_flags(unsigned long node, enum of_rmem_flags *flags)
+{
+	*flags = OF_RMEM_NONE;
+
+	if (of_get_flat_dt_prop(node, "no-map", NULL))
+		*flags |= OF_RMEM_NOMAP;
+	if (of_get_flat_dt_prop(node, "ll-map", NULL))
+		*flags |= OF_RMEM_LLMAP;
+
+	if ((*flags & OF_RMEM_NOMAP) && (*flags & OF_RMEM_LLMAP)) {
+		pr_err("Reserved memory: no-map and ll-map are mutually exclusive\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int __init early_init_dt_alloc_reserved_memory_arch(phys_addr_t size,
-	phys_addr_t align, phys_addr_t start, phys_addr_t end, bool nomap,
-	phys_addr_t *res_base)
+	phys_addr_t align, phys_addr_t start, phys_addr_t end,
+	enum of_rmem_flags flags, phys_addr_t *res_base)
 {
 	phys_addr_t base;
 	int err = 0;
@@ -46,10 +69,21 @@ static int __init early_init_dt_alloc_reserved_memory_arch(phys_addr_t size,
 		return -ENOMEM;
 
 	*res_base = base;
-	if (nomap) {
-		err = memblock_mark_nomap(base, size);
-		if (err)
+	if (flags & OF_RMEM_LLMAP) {
+		err = memblock_mark_llmap(base, size);
+		if (err) {
 			memblock_phys_free(base, size);
+			return err;
+		}
+	}
+
+	if (flags & OF_RMEM_NOMAP) {
+		err = memblock_mark_nomap(base, size);
+		if (err) {
+			if (flags & OF_RMEM_LLMAP)
+				memblock_clear_llmap(base, size);
+			memblock_phys_free(base, size);
+		}
 	}
 
 	if (!err)
@@ -119,17 +153,29 @@ static int fdt_fixup_reserved_mem_node(unsigned long node,
 				       phys_addr_t base, phys_addr_t size);
 
 static int __init early_init_dt_reserve_memory(phys_addr_t base,
-					       phys_addr_t size, bool nomap)
+					       phys_addr_t size,
+					       enum of_rmem_flags flags)
 {
-	if (nomap) {
+	int err;
+
+	if (flags & OF_RMEM_LLMAP) {
+		err = memblock_mark_llmap(base, size);
+		if (err)
+			return err;
+	}
+
+	if (flags & OF_RMEM_NOMAP) {
 		/*
 		 * If the memory is already reserved (by another region), we
 		 * should not allow it to be marked nomap, but don't worry
 		 * if the region isn't memory as it won't be mapped.
 		 */
 		if (memblock_overlaps_region(&memblock.memory, base, size) &&
-		    memblock_is_region_reserved(base, size))
+		    memblock_is_region_reserved(base, size)) {
+			if (flags & OF_RMEM_LLMAP)
+				memblock_clear_llmap(base, size);
 			return -EBUSY;
+		}
 
 		return memblock_mark_nomap(base, size);
 	}
@@ -143,10 +189,10 @@ static int __init early_init_dt_reserve_memory(phys_addr_t base,
 static int __init __reserved_mem_reserve_reg(unsigned long node,
 					     const char *uname)
 {
+	enum of_rmem_flags flags;
 	phys_addr_t base, size;
-	int len, err;
 	const __be32 *prop;
-	bool nomap;
+	int len, err;
 	u64 b, s;
 
 	prop = of_flat_dt_get_addr_size_prop(node, "reg", &len);
@@ -157,7 +203,9 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
 		pr_warn("Reserved memory: node '%s' has %d <base size> entries, only the first is used\n",
 			uname, len);
 
-	nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;
+	err = of_reserved_mem_flags(node, &flags);
+	if (err)
+		return err;
 
 	err = fdt_validate_reserved_mem_node(node, NULL);
 	if (err && err != -ENODEV)
@@ -167,7 +215,7 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
 	base = b;
 	size = s;
 
-	if (size && early_init_dt_reserve_memory(base, size, nomap) == 0) {
+	if (size && early_init_dt_reserve_memory(base, size, flags) == 0) {
 		fdt_fixup_reserved_mem_node(node, base, size);
 		pr_debug("Reserved memory: reserved region for node '%s': base %pa, size %lu MiB\n",
 			 uname, &base, (unsigned long)(size / SZ_1M));
@@ -399,8 +447,8 @@ int __init fdt_scan_reserved_mem(void)
  *	reserved regions to keep the reserved memory contiguous if possible.
  */
 static int __init __reserved_mem_alloc_in_range(phys_addr_t size,
-	phys_addr_t align, phys_addr_t start, phys_addr_t end, bool nomap,
-	phys_addr_t *res_base)
+	phys_addr_t align, phys_addr_t start, phys_addr_t end,
+	enum of_rmem_flags flags, phys_addr_t *res_base)
 {
 	bool prev_bottom_up = memblock_bottom_up();
 	bool bottom_up = false, top_down = false;
@@ -435,7 +483,7 @@ static int __init __reserved_mem_alloc_in_range(phys_addr_t size,
 		memblock_set_bottom_up(bottom_up);
 
 	ret = early_init_dt_alloc_reserved_memory_arch(size, align,
-			start, end, nomap, res_base);
+			start, end, flags, res_base);
 
 	/* Restore old setting if needed */
 	if (bottom_up != top_down)
@@ -452,9 +500,9 @@ static int __init __reserved_mem_alloc_size(unsigned long node, const char *unam
 {
 	phys_addr_t start = 0, end = 0;
 	phys_addr_t base = 0, align = 0, size;
+	enum of_rmem_flags flags;
 	int i, len;
 	const __be32 *prop;
-	bool nomap;
 	int ret;
 
 	prop = of_get_flat_dt_prop(node, "size", &len);
@@ -477,7 +525,9 @@ static int __init __reserved_mem_alloc_size(unsigned long node, const char *unam
 		align = dt_mem_next_cell(dt_root_addr_cells, &prop);
 	}
 
-	nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;
+	ret = of_reserved_mem_flags(node, &flags);
+	if (ret)
+		return ret;
 
 	ret = fdt_validate_reserved_mem_node(node, &align);
 	if (ret && ret != -ENODEV)
@@ -495,7 +545,7 @@ static int __init __reserved_mem_alloc_size(unsigned long node, const char *unam
 
 			base = 0;
 			ret = __reserved_mem_alloc_in_range(size, align,
-					start, end, nomap, &base);
+					start, end, flags, &base);
 			if (ret == 0) {
 				pr_debug("allocated memory for '%s' node: base %pa, size %lu MiB\n",
 					uname, &base,
@@ -505,7 +555,7 @@ static int __init __reserved_mem_alloc_size(unsigned long node, const char *unam
 		}
 	} else {
 		ret = early_init_dt_alloc_reserved_memory_arch(size, align,
-							0, 0, nomap, &base);
+							0, 0, flags, &base);
 		if (ret == 0)
 			pr_debug("allocated memory for '%s' node: base %pa, size %lu MiB\n",
 				uname, &base, (unsigned long)(size / SZ_1M));
@@ -635,8 +685,8 @@ static int __init __reserved_mem_init_node(struct reserved_mem *rmem,
 static void __init fdt_init_reserved_mem_node(unsigned long node, const char *uname,
 					      phys_addr_t base, phys_addr_t size)
 {
+	enum of_rmem_flags flags;
 	int err = 0;
-	bool nomap;
 
 	struct reserved_mem *rmem = &reserved_mem[reserved_mem_count];
 
@@ -650,14 +700,19 @@ static void __init fdt_init_reserved_mem_node(unsigned long node, const char *un
 	rmem->base = base;
 	rmem->size = size;
 
-	nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;
+	err = of_reserved_mem_flags(node, &flags);
+	if (err)
+		return;
 
 	err = __reserved_mem_init_node(rmem, node);
 	if (err != 0 && err != -ENODEV) {
 		pr_info("node %s compatible matching fail\n", rmem->name);
 		rmem->name = NULL;
 
-		if (nomap)
+		if (flags & OF_RMEM_LLMAP)
+			memblock_clear_llmap(rmem->base, rmem->size);
+
+		if (flags & OF_RMEM_NOMAP)
 			memblock_clear_nomap(rmem->base, rmem->size);
 		else
 			memblock_phys_free(rmem->base, rmem->size);
@@ -667,9 +722,10 @@ static void __init fdt_init_reserved_mem_node(unsigned long node, const char *un
 		bool reusable =
 			(of_get_flat_dt_prop(node, "reusable", NULL)) != NULL;
 
-		pr_info("%pa..%pa (%lu KiB) %s %s %s\n",
+		pr_info("%pa..%pa (%lu KiB) %s %s %s %s\n",
 			&rmem->base, &end, (unsigned long)(rmem->size / SZ_1K),
-			nomap ? "nomap" : "map",
+			(flags & OF_RMEM_LLMAP) ? "last-level " : "",
+			(flags & OF_RMEM_NOMAP) ? "nomap" : "map",
 			reusable ? "reusable" : "non-reusable",
 			rmem->name ? rmem->name : "unknown");
 	}
-- 
2.55.0.970.g62bdec98f9-goog


