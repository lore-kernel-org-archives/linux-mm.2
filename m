Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ED73CCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 13:40:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09E116B0088; Wed, 29 Apr 2026 09:40:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04EBB6B00A1; Wed, 29 Apr 2026 09:40:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA7376B00A2; Wed, 29 Apr 2026 09:40:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB4DC6B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:40:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 994B840277
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:40:12 +0000 (UTC)
X-FDA: 84711702264.05.6ACEBE9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id E06B41C000F
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:40:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UfJW+gSG;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777470011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nr360FbUv9sUz0ZpaDZVBTbPpIZGiTIqAhWXONpjB3w=;
	b=cJHzIxfZpafnbv654hF+fQNHKibvahrz7MtEZbiyaYAjl43myp+3+4HNArgTGxsLjk+F6A
	ZSkutvaXqlvlXNRDHwnXx8hjuYiUaMW07R6bdk7ITiQ9Yv6Fdqptzima7/r3RSvx3sT0Dp
	u0ldI7N5aIctHF0cppe4ixd/AxfdB+g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777470011; a=rsa-sha256;
	cv=none;
	b=p/jFzNvCeWhpzFiW2l1wbw3qvGEtQz6O73TCoDvXja+XSiNND0eLTqASN4C4+DHlAmzSaX
	CLwz2hDJXvJs6916Wj9lwibQRjZtvWDfTNwi1bzLPuhUAT5TatbANvnG/umtjiI6moLyA9
	9+vqByLiFRttoSVK8LUqUJK3zP1I8dw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UfJW+gSG;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 114514083B;
	Wed, 29 Apr 2026 13:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B36C2BCC6;
	Wed, 29 Apr 2026 13:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777470009;
	bh=UueBsq01JA9/z9WSGSLkvtLjqf9jJ9B97O+wRu3Lxo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UfJW+gSG2hHNWNoTkzTSCO1P9P/dSOfWxc9kBCsK5009yDv+2I/0Io+9QKuv+++ak
	 TCAHvLyL4sgUOYy5HVRKo19JHKkGN4spdRILrK5F32AOsLHzYMfVOtROTqycfzBLYw
	 10WAJ9JsR+XIfA7Etr63hAEoZddPOVXUhlw5l0M4itFuSuurWnFNKqRHEVrI0fGfdH
	 /mXxwmUqtQDAF7asLJAHhI/8RJQfy34ei80E41so/aYblUWqu5l52ZCBXwtNMk2PkC
	 qVe1/4nvLoVcHYSugIiYGapj0Q++uzzYQ582cjSmLHTGzvAqP50GorSirPnfctbrz4
	 +tSkIo0+KIcDQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 11/12] kho: return virtual address of mem_map
Date: Wed, 29 Apr 2026 15:39:13 +0200
Message-ID: <20260429133928.850721-12-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
In-Reply-To: <20260429133928.850721-1-pratyush@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E06B41C000F
X-Rspam-User: 
X-Stat-Signature: 7yugq1zcdjy8y3jy8brrgdbue66ye87t
X-HE-Tag: 1777470010-552756
X-HE-Meta: U2FsdGVkX1+/yGBG9zuaJFl9GbZvCMeZ7C39R1VZYFyEfacUZK08CtzN6LJPd1Im4Z5axJHMQjiM5siXoilEu0plyc5lRRPwf1qz13JWbiBB4PdSbKWH6SrLqLHOuXG6fawCjTLxLde8SNiwhfqOXqWN5RL+rE5cF2jFZqzj7/LXZjNsZmfXohm49jJOv+iLDzHbAJkgmNxOPaCrlyngd2jAMR8dNaR+qSSdAu1KMenDzukfVuixabymLKYo6XkOSigomv7jmm0wF95bkxXhXz98yPPIsZJw/Ebosct4RRbZLNtDLlaHNQlBYn5Q4BlsA2E/vDTBoB6/WWyra+rnc9ls9nup2lZFjoOUMcVicEu7gYwqfZ7oBYc6x/3oYj+wOVHkkiFjIA9ziONRaaq4cAwDrvKLEf79BcKcP3L3jRxiarnTHngH8Bv5mv5sfkqrzq0WBU3LDhhlb+FNU4aVS4H4pWuioVYJA4/Vt0IC9p2TvZlfVMzkv+ZWElwfd1RAYa+tB2p0RoRPcfzZ2LWU+ph6091hdrw9XmJGdidx9fIfa/2j39F9ExCFt3v9ZG7zUQM9acQLjfHqlypAZoHg4syGa6vdLILxgBJLeHsbtvAKhzojV7lU4nM67VdYaRXk/of+IGiAbktYkYdC/fESYhoWwEzPEDndL8mbDNEtnCdT0rHucQXwOkiRVzifd6ghmZ0X1qCRsEBIDupgQ7wRaPcdHrbuZ04X0bALtPR9CK4ToO8gPFe4Ai1I+PXSMZl97OTqmF+b10RONUqwizUn9okoeQqi87avZ1euZ4JGNljPPMMbEGlpqEhEpwNbshvxHq1mkYoXDH6o1GDSmYcGUzI45q+nfG7peZ7o+f4Mo2bpwi0LZtv3LntoU2eYmn4DK73yYKQBkxb5YZ9mCkP8eA1SdKLU9Ud5QkJzpYqSQ1qCGlEWKANXN4Z5YOKQDt2ykSW2YRva7ZJrq3a/0xt
 Aj2Ogetk
 S8HQJA8yitfmKdKQ7w+r6JlqLtKYcoa4n45EVP0xygxQTcCv+507Fg8E+CrGBhgwYoQ9G2tg5Kl0N+ZNCDWoTsvc18DxLZJHy/VJ69rlzfkxhUfpbEB781iBAvA2Izc3p94xG9/DYPwDu+Yk+HbhuwOJhLPBuCzdAH3lEfrS9rk2hrji7lXKrVRlq0wBo8JBUtGMDfkd1F4IWr3HJ5m2hnmtfQm8ORMVkgL2e89gm0YZ1vdONVdq5NYOcfVrWH6SyPmk0MOjbr7TLsf0AvtHMDW+Wuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

There are currently 3 callers of kho_get_mem_map_phys(). Two of them,
kho_mem_retrieve() and kho_extend_scratch() need the virtual address.
The third, kho_populate() doesn't care. Make things simpler by
directly returning the virtual address. Rename kho_get_mem_map_phys() to
kho_get_mem_map() to accurately reflect what it returns.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index c2b843a5fb28..2e13b80d1c7d 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -625,10 +625,11 @@ static int __init kho_preserved_memory_reserve(unsigned long key, void *data)
 	return 0;
 }
 
-/* Returns physical address of the preserved memory map from FDT */
-static phys_addr_t __init kho_get_mem_map_phys(const void *fdt)
+/* Returns virtual address of the preserved memory map from FDT */
+static __init void *kho_get_mem_map(const void *fdt)
 {
 	const void *mem_ptr;
+	phys_addr_t mem_map_phys;
 	int len;
 
 	mem_ptr = fdt_getprop(fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, &len);
@@ -637,7 +638,11 @@ static phys_addr_t __init kho_get_mem_map_phys(const void *fdt)
 		return 0;
 	}
 
-	return get_unaligned((const u64 *)mem_ptr);
+	mem_map_phys = get_unaligned((const u64 *)mem_ptr);
+	if (!mem_map_phys)
+		return NULL;
+
+	return phys_to_virt(mem_map_phys);
 }
 
 /*
@@ -932,15 +937,15 @@ void __init kho_extend_scratch(void)
 		.key = kho_ext_mark_scratch,
 	};
 	struct kho_radix_tree radix;
-	phys_addr_t prev_end = 0, mem_map_phys;
+	phys_addr_t prev_end = 0;
 	int err = 0;
 
 	if (!is_kho_boot())
 		return;
 
 	/* Make sure the KHO radix tree is initialized. */
-	mem_map_phys = kho_get_mem_map_phys(kho_get_fdt());
-	err = kho_radix_init_tree(&kho_in.radix_tree, phys_to_virt(mem_map_phys));
+	err = kho_radix_init_tree(&kho_in.radix_tree,
+				  kho_get_mem_map(kho_get_fdt()));
 	if (err)
 		goto print;
 
@@ -1587,11 +1592,9 @@ static int __init kho_mem_retrieve(const void *fdt)
 	const struct kho_radix_walk_cb cb = {
 		.key = kho_preserved_memory_reserve,
 	};
-	phys_addr_t mem_map_phys;
 	int err;
 
-	mem_map_phys = kho_get_mem_map_phys(fdt);
-	err = kho_radix_init_tree(&kho_in.radix_tree, phys_to_virt(mem_map_phys));
+	err = kho_radix_init_tree(&kho_in.radix_tree, kho_get_mem_map(fdt));
 	if (err)
 		return err;
 
@@ -1816,8 +1819,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 {
 	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
 	struct kho_scratch *scratch = NULL;
-	phys_addr_t mem_map_phys;
-	void *fdt = NULL;
+	void *fdt = NULL, *mem_map;
 	bool populated = false;
 	int err;
 
@@ -1840,8 +1842,8 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 		goto unmap_fdt;
 	}
 
-	mem_map_phys = kho_get_mem_map_phys(fdt);
-	if (!mem_map_phys)
+	mem_map = kho_get_mem_map(fdt);
+	if (!mem_map)
 		goto unmap_fdt;
 
 	scratch = early_memremap(scratch_phys, scratch_len);
-- 
2.54.0.545.g6539524ca2-goog


