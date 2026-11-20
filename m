Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A227B606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 01:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=aFaUkE9N
Received: by kanga.kvack.org (Postfix)
	id 114746B072F; Thu, 19 Nov 2026 20:07:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EC2D6B0730; Thu, 19 Nov 2026 20:07:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1C8F6B0731; Thu, 19 Nov 2026 20:07:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C16756B072F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:07:26 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EAA53A8A0F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:25 +0000 (UTC)
X-FDA: 85453709250.21.68ADA06
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by imf19.hostedemail.com (Postfix) with ESMTP id 34D151A000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=aFaUkE9N;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3Sp3_agYKCOEOULccRJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--lrizzo.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3Sp3_agYKCOEOULccRJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--lrizzo.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795136844;
	b=vFrX9QSP4KYKDE9hFAWkQLleTICk24ajDNOd/6/dbd0+57+wsoyn0rxoldy5WxNoq86NR/
	M+J65UaXBbP7C0tNLbvGt0mDdbPQWoU4k0Rq11RzobVmuU4DQgiP/s+e9BCTt5ip2juDbq
	E2I+fUA8lheWGNfaqd5EId8irSHeIp0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795136844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dRkr2BvKaK0JNp+xEr+CP1uqN9jcKW992wqEJ/xsaHY=;
	b=lMxEiWLODndp2Xl4dAPIQbi5ciIkInPRN2iPYi+7Y2ifOjSBwVZwlJ6fIOcwNfrkA3BbNT
	1arJn3L+B91lRageAkagPJEPVG3aIm5ZF5kwAbwEIm2teI5inCkAj6Y11TTlk5hoXSc8eN
	xPYUmyR3u0TUcZCH7Wo7ne5olh3wqZk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=aFaUkE9N;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3Sp3_agYKCOEOULccRJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--lrizzo.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3Sp3_agYKCOEOULccRJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--lrizzo.bounces.google.com
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c50c9af44d6so28684666b.1
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795136843; x=1795741643; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dRkr2BvKaK0JNp+xEr+CP1uqN9jcKW992wqEJ/xsaHY=;
        b=aFaUkE9N/SIkJsIrYZ1JcDfAE8E7zH3f8rWc1RC//OK1Zz5H8mP1eUZ6vy0/mUWixF
         VzUj2jqdM0+XsDfN+zPjkBm3SFc96gBfiGih+GV70KfAHM/V87LsPr4A68KpSaRI7BpC
         5gVSsIAyqfwtenLpBdlr4p8Ge2+vWjqyChA264HmVhvbdhz+9t5YGkn5PzJQyS9JnUnl
         Bfde033Kpzh9FhUu/YSO3PiQaswSEXppOY8fJVYV3yh4AeCS+sMWgKBuycA7uWIPiABG
         KT2ub+3oCfODY7uY6eNsk00NMW0+YyUg8ADmIFNYJyRVZ9NOre0mmZp5YAxyT9FOcwhT
         lyzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795136843; x=1795741643;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dRkr2BvKaK0JNp+xEr+CP1uqN9jcKW992wqEJ/xsaHY=;
        b=209V73htEndilN+oG16u2xpVlGIq0uaE6mJeg/3NZL6R/sTKnsi0nKJBBDUAOyjMR/
         DlhcGj9/AeZ0iNVF/UHscbxoK6JFb78O9VLnx5ingqbRfAei3yWJ5cHA2tVHDln5wtPB
         qM2bChYRDkrT1CrJMFiPGKIOPlp5/4eGIcm+XgAVZ3qeO6b6k36s1LgRyez4F8ie/YmO
         BHGIwi6FtRB6aHOyp8VJlooeQvVkcUIYnqfUvOP4wPpGFwfh2QNIjIN259+8h+d3p8eT
         tuxyATG/aS5wTSR0M0fmAiDBk6umE2hash5mHjsHJ+mj+1/v6vAyZZbq/hYETVDFGgZh
         KBBQ==
X-Forwarded-Encrypted: i=1; AL+hErHt1SNgvGyFdsa3/CLF00R1A27ngjYO9uRtvz4gD7kyHyhVvm498oqAT2+bCEq083MH1mKc5YZqbw==@kvack.org
X-Gm-Message-State: APuU4Z/loPqixLcshZAUx38JkknSBj8a4Im9HAWYb6/n+9RKIIUvf+TR
	kmcbZmFli00xu7QH/HadeywbZs5P0mS79VQlVtxMFXEitDvsUggM26Ah+ETv5VXVuOpbIePQvE4
	aLOLzjA==
X-Received: from ejcfw45.prod.google.com ([2002:a17:907:502d:b0:c50:519f:c790])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:370b:b0:c51:34ae:dd7
 with SMTP id a640c23a62f3a-c5134ae12d8mr166377466b.17.1795136842505; Thu, 19
 Nov 2026 17:07:22 -0800 (PST)
Date: Fri, 20 Nov 2026 01:06:50 +0000
In-Reply-To: <20261120010655.467825-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261109182533.3594984-1-lrizzo@google.com> <20261120010655.467825-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261120010655.467825-21-lrizzo@google.com>
Subject: [RFC PATCH v3 20/25] arm64/mm, mm: Support decrypted PISA pages in Realms
From: Luigi Rizzo <lrizzo@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@kernel.org>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Jens Axboe <axboe@kernel.dk>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Luigi Rizzo <rizzo.unipi@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Simon Horman <horms@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Willem de Bruijn <willemb@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Joshua Washington <joshwash@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>, Dragos Tatulea <dtatulea@nvidia.com>, 
	Naman Gulati <namangulati@google.com>, Pranjal Shrivastava <praan@google.com>, 
	Mostafa Saleh <smostafa@google.com>, Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User:
X-Stat-Signature: 3xk5nyx9wu5qsfsx3j45q9mx1qa7x4da
X-Rspamd-Queue-Id: 34D151A000A
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795136844-633338
X-HE-Meta: U2FsdGVkX18FfIDg9bNIACfTogeM+PB/xrusP9UCNWY9oFMUggHuT7kKYv5qGoRhAs7WvcdR+xW1Nh4mlXioJ82TxurwABgKl9aL2DWc8fdGM13sl8R9sqHZSa12EV7uY2QXjuKI9HPWBk3tw3kJbw8yulxVPiWyrnnPtLa+y9YLIlVXB9pyDeT/eX0BxbkQcfTLbS3KBJnyl3PGWhKkGkcT5lMxU5WDRSHs1PwLPkghYnPFL0NkS4HvJgHY6ZSDQgIl8vu0Nivt1oN20M79UqIDwxXqxOdaW3/J134Tu0tyh7OHadx5ONfGUBKHz4u10BkISMH5zlGFQ17yqHzH/TgJDgB1CmP5rPf530VvYMTbdb0YbZ0nGhqcKNM4wT7xTvMlCVNppnHll2t8/En6Bu+AtF7eRTuQ0xgF03scCbPwvQ04w336pIAr4zignR15d1TY5VH7rUTV6BU83Yn6Dd4wQ6ThjfBP+nOFEmojReVnqMVywzAZKkkApOUXY9ByZjnOggDEgNn2I2ajXwi3RQZunZUXQJ5Og6e7U6SwRSgRkXhmEpDESFJXTU+f/onxPeWb7AdDqt0PHrN/C5t7zlUj+jQNgOK6I+pG0P6t9uj/1NoFUr6KqXrMdHA+QctsC2ytVVmzOAbo9hKfYQxCwjnx4aWwh6H/7g/vGLAW8PX4YBY+WpYhWAmHqm/8zWArgLC1Kp5pG2imodyU9M9fU9TNnKg7hg0BrJZZ1768SJZJRbdPD1Smgg4c2JoOQUQaPHdlhSxnrGJr/elUxkgCWsycwba9ttS67GJHsM2k6l1SGuyEketWfjTiZK8HWo/VGKnnaan81ft6ZP9+KgYadrMohCeSDW1aytNxjwSlqYrfLn8CYSKYsgzOkMOyn408y42DPax0wOsaMrj0zvlizqkP1riJ+rcFxfgLW63O2V5lGlEZ9q0KB4WZ3B64jiGEGZRf3C0Tkwxc07RoGmw
 9t53HrXH
 RIVr1IfPgHqvK25TRFAezRx4ol/0dgg+9tK40xKSjo7N+0nzDzQxdD0Y36XxFkcpgPwuFefyYdadbPQjHf7YwrdfJ3E9QIpIdAmgQh/8Hrru/9c8RawVvSk6yuChmcpOLoEMIPWrkqQfJZiWjGwhSpIUrWvrYmJVBpTs4FDzWK6YAEZkqYnvE3IauB8h7g1UomiuNnZ1y8KVue8QEJ/7Cf6HimPi8Z23hAu1LTlDutq6OI0yde33RG4i1TlchZXxJYyuUeYdMxPaaZbrBDOM2m+ue5HemEtK+abhLQ/xkg8c+KMoS86Aghxvs3zxtkd6egY5VRG/M6964Qgg+/b1HURS2ZjjxsrYVF0v/R88VWSAed2qChYX7FvRd/MNFx6osu3IX7Jy+RhvBSyUVamEW223b97skJLfmkDhtPpDI3punJyhpMb/2n7YPKraVyyfPEvgEk3V9A5V/32rz546m/FK755WBGh+3xeCPND5v9btf2Q+p8/mKjuWmy1DVkCkRZjxMkFGcvur/jWTxbAVKOotn6AtfyEs8fEpNt1Y8AOm3gMEjMdZxVriSQvZ+qd7OEx2vtfqdXMjHXVa1tU4ysl7f23/MgBcqsIJO6Z4ShMIEcu+ZZ04QsY/YR3p+gMLpi00f6W9eSyADGGH1LuG7z7Ii5LNFfCAC2qyWPINxck6tS6V6Az41UoX6xl3kR2rR1Opqj89rtEkEfqkYeCy2Kx2dFHcnErI8rHskC/haBdr4cJw/OXNMtNtTNW7YLESh+l4z/ELrfUkTjZs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

An arm64 Realm (ARM CCA guest) only reports CC_ATTR_MEM_ENCRYPT, so PISA
did not treat it as a CoCo guest and refused to initialize there.

Treat a Realm as a CoCo guest: PISA pages are decrypted (shared with the
host) when they are allocated, as on SEV-SNP and TDX.

A decrypted page is mapped with PROT_NS_SHARED, the top IPA bit, set in
the address field of its PTEs. PISA maps such pages into user space with
ordinary PTEs (page cache, migrated user pages, zerocopy receive), and
for those pte_pfn() must be the PFN of the page, or vm_normal_page() and
GUP see a PFN that has no struct page.

Make __pte_to_phys() strip the bit when what is left is a decrypted PISA
page. The check is behind pisa_decrypt_key, so outside CoCo guests it
costs one static branch, and every other shared mapping (ioremap() of
emulated MMIO, swiotlb, DMA mmap) keeps the address it has today.

pisa_decrypt_key and the lookup are exported because pte_pfn() is used
by modules.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 arch/arm64/include/asm/pgtable.h | 28 ++++++++++++++++++++++++++--
 mm/pisa-meta.c                   |  9 +++++++++
 mm/pisa-node.c                   |  9 +++++++--
 3 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index a474c9fb485ad..86c60b8f43ae0 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -108,7 +108,7 @@ static inline void arch_leave_lazy_mmu_mode(void)
 			  TLBF_NOBROADCAST | TLBF_NONOTIFY | TLBF_NOWALKCACHE)
 
 #ifdef CONFIG_ARM64_PA_BITS_52
-static inline phys_addr_t __pte_to_phys(pte_t pte)
+static inline phys_addr_t __pte_to_phys_raw(pte_t pte)
 {
 	pte_val(pte) &= ~PTE_MAYBE_SHARED;
 	return (pte_val(pte) & PTE_ADDR_LOW) |
@@ -119,7 +119,7 @@ static inline pteval_t __phys_to_pte_val(phys_addr_t phys)
 	return (phys | (phys >> PTE_ADDR_HIGH_SHIFT)) & PHYS_TO_PTE_ADDR_MASK;
 }
 #else
-static inline phys_addr_t __pte_to_phys(pte_t pte)
+static inline phys_addr_t __pte_to_phys_raw(pte_t pte)
 {
 	return pte_val(pte) & PTE_ADDR_LOW;
 }
@@ -130,6 +130,30 @@ static inline pteval_t __phys_to_pte_val(phys_addr_t phys)
 }
 #endif
 
+#if defined(CONFIG_PISA) && !defined(__DISABLE_EXPORTS)
+DECLARE_STATIC_KEY_FALSE(pisa_decrypt_key);
+bool __pisa_phys_decrypted(phys_addr_t phys);
+#endif
+
+static inline phys_addr_t __pte_to_phys(pte_t pte)
+{
+#if defined(CONFIG_PISA) && !defined(__DISABLE_EXPORTS)
+	/*
+	 * In a Realm, PISA maps its decrypted pages into user space with ordinary
+	 * PTEs. Those have PROT_NS_SHARED, the top IPA bit, set in their address
+	 * field, but pte_pfn() must be the PFN of the page: strip the bit when
+	 * what is left is a decrypted PISA page. Other shared mappings keep it.
+	 */
+	if (static_branch_unlikely(&pisa_decrypt_key) && (pte_val(pte) & PROT_NS_SHARED)) {
+		phys_addr_t phys = __pte_to_phys_raw(__pte(pte_val(pte) & ~PROT_NS_SHARED));
+
+		if (__pisa_phys_decrypted(phys))
+			return phys;
+	}
+#endif
+	return __pte_to_phys_raw(pte);
+}
+
 #define pte_pfn(pte)		(__pte_to_phys(pte) >> PAGE_SHIFT)
 #define pfn_pte(pfn,prot)	\
 	__pte(__phys_to_pte_val((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot))
diff --git a/mm/pisa-meta.c b/mm/pisa-meta.c
index 99c5bc42eed10..b608ef71152af 100644
--- a/mm/pisa-meta.c
+++ b/mm/pisa-meta.c
@@ -189,6 +189,15 @@ bool __is_pisa_direct(phys_addr_t phys, size_t size)
 	       (phys & (PISA_SIZE - 1)) + size <= PISA_SIZE;
 }
 
+#ifdef CONFIG_ARM64
+/* For __pte_to_phys(): true if @phys is in a decrypted PISA page. */
+bool __pisa_phys_decrypted(phys_addr_t phys)
+{
+	return pisa_pfn_flags(PHYS_PFN(phys)) & PISA_DECRYPTED;
+}
+EXPORT_SYMBOL(__pisa_phys_decrypted);
+#endif
+
 /*
  * Update @meta's position on @pa's lists under @pa->lock. When all blocks
  * become available (avail == bpp), either queues @meta to @pisa_free_list (and
diff --git a/mm/pisa-node.c b/mm/pisa-node.c
index 12fbb617c342b..aa4f8759ae5e8 100644
--- a/mm/pisa-node.c
+++ b/mm/pisa-node.c
@@ -36,11 +36,16 @@ unsigned int pisa_reservoir_max __read_mostly = 16;
 
 /* Enabled in CoCo guests by pisa_node_init(): new PISA pages are decrypted for DMA. */
 DEFINE_STATIC_KEY_FALSE(pisa_decrypt_key);
+EXPORT_SYMBOL(pisa_decrypt_key);
 
-/* A confidential guest: PISA pages are decrypted for DMA. A bare-metal SME host is not one. */
+/*
+ * A confidential guest: PISA pages are decrypted for DMA. A bare-metal SME host
+ * is not one. An arm64 Realm only reports CC_ATTR_MEM_ENCRYPT.
+ */
 static bool pisa_coco_guest(void)
 {
-	return cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT);
+	return cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT) ||
+	       (IS_ENABLED(CONFIG_ARM64) && cc_platform_has(CC_ATTR_MEM_ENCRYPT));
 }
 
 /* Memory encryption that PISA cannot handle: neither an SME host nor a guest it decrypts for. */
-- 
2.56.1.809.ga0b61035b5-goog


