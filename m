Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9930C83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 19:20:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64FA36B0089; Wed, 30 Jul 2025 15:20:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 626B46B008A; Wed, 30 Jul 2025 15:20:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53CCC6B0092; Wed, 30 Jul 2025 15:20:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 420536B0089
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 15:20:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C62BBB7284
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 19:20:11 +0000 (UTC)
X-FDA: 83721896622.10.858C57C
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf24.hostedemail.com (Postfix) with ESMTP id 07015180006
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 19:20:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=u1NeCS6i;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=AUo0vRob
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753903210; a=rsa-sha256;
	cv=none;
	b=VEuxENeFeGMtHCy0i4L2CjF8afRpFcQaOHkxiZ5KxqE84XO57MedTmHHOMhwsUKBTFD4/s
	U6LQ53oqzSLeuO+pvrE3xsKvKuvyiX5IwUXee4ZubuExMyFj6XiGwJXADMnHcUQ/O97+9L
	keyPPW8GqMtEsQztxqD4dEU1Fqhk/8o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=u1NeCS6i;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=AUo0vRob;
	dmarc=none;
	spf=none (imf24.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753903210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hCMaEFvhO0WO86sv36Htm4+PajgStiRpxUBpMzicUeU=;
	b=oVYtkjRRZqwIyVK+gI2WO44Zxi2AplU9Gv6pEh8RA0qGSggHdtZ+NIGADYgI1n+Hmt6Fuw
	tR50uir/dtR21gzjQYEFTXX4v0jgVpGj+M77akBEdBF+Z2pFC/Dq94FjB1PaCKTjSvW4c4
	DJSksQaFVGw2IGSMLFQbqb+fc4DiuX8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1753903208; x=1754508008;
	d=konsulko.se; s=rsa1;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=hCMaEFvhO0WO86sv36Htm4+PajgStiRpxUBpMzicUeU=;
	b=u1NeCS6i9ZC7Vw68cR7le1L4PZO64SDoXxBsBrPCcRESmootg5/qzDovGB4ptf27wBodVLBeeYKMH
	 CN8GllTKDqzfSSRfbd501WHbp6fgzb9+lJ5juqRx9C6gU+sLZf+QH0+CGdTvi6QkjEGP2LkKzHZrKW
	 YqmK+zNUOOtYvq8MHgT+M5VQoaTgxXeCTIIILv1/8u427De2RIiRA3lOEl1jZRaDAa7Dzf3+MC9QOu
	 jXtSRz5cnqVtaToxCr51B40J3sO+lS2I2KO7qb/QhvYOgrU0a/ZQEc8iJCcXhDR9s+2sTEqy0IbhIY
	 6Y3Te6JXisqGmuzJxB4UUunUnL4M6KA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1753903208; x=1754508008;
	d=konsulko.se; s=ed1;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=hCMaEFvhO0WO86sv36Htm4+PajgStiRpxUBpMzicUeU=;
	b=AUo0vRobeyu1GoyEBS6uOMNPMgBJ96ZHhc6cKa0OZ4CZUadWTfL/ZdYl10hcBcZssLmW7CDBps7hP
	 /NMum2qCw==
X-HalOne-ID: 337d0429-6d7a-11f0-9a04-c9fa7b04d629
Received: from slottsdator.home (host-90-238-19-233.mobileonline.telia.com [90.238.19.233])
	by mailrelay1.pub.mailoutpod3-cph3.one.com (Halon) with ESMTPSA
	id 337d0429-6d7a-11f0-9a04-c9fa7b04d629;
	Wed, 30 Jul 2025 19:20:08 +0000 (UTC)
From: Vitaly Wool <vitaly.wool@konsulko.se>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	rust-for-linux@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	bpf@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Vitaly Wool <vitaly.wool@konsulko.se>
Subject: [PATCH v14 1/4] :mm/vmalloc: allow to set node and align in vrealloc
Date: Wed, 30 Jul 2025 21:20:02 +0200
Message-Id: <20250730192002.355169-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250730191921.352591-1-vitaly.wool@konsulko.se>
References: <20250730191921.352591-1-vitaly.wool@konsulko.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 07015180006
X-Stat-Signature: ores5fosa8srzyzk1he1j8t875ucn7qi
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753903209-640080
X-HE-Meta: U2FsdGVkX1/ExGeDlRXLsmKPtKA1Gqf6wax1NRukJJjsHD8xLremR0rv0IHj7+Zp7s1ZRzte+/K3PkksD+6VG6C/fYfkOPXfAoIC75rq39+dAW3vxtdzxzQ46NgLl3JdMxE+oQmsoj2ldKDRew7MOxPYJuRRm+yUHsDCiZN5bzc9NWdbaBlp+nvHJfervveRl/7sW+Qxx3LK5Ajrkjnaj2TKq5vGPF2U19ZSXbBZm+0cFD+XPgYB1VJYLBdGRxkXG7jdZoNJewfBXzQ1nuzt1XZHiAYH1qsdK9uQcy4C41V78JkjjefaPYr1jlzstSL6Ds0+zy+e0MaCXJVG2O3Sntbgjdiu2ZKvvvAh4fgWYLScDIy2pL2StGNDkaLaI+KLPaCJzTyRhK6EjRs2C9LjOOrhbLgkkDM31y46lEgnaJBeirpt2estpDeOaR2JnT3cxcZm5wcgs3wVA1momYeDD6TIt6tyShffEO+p/YgtjlTlTmT4er9CieGTgwETFsSt2PQgMsvdvJtMmmWV2QIoX5yGM7PU5DHLQ+Wk1yShiBNUAvcfyGaueEYrw8hHke47FOOyR6k8aX8gY4ZYiw7ognkkHHc6nCkCen5YfFF11llgzBujTNWUpBTU7ab5TwyVTPa2k3WssYYDa4sZIqJ1LBsmbTzM/4lPWmGynz651wTwGlSknbwbrkB3BZTtRokevHOwn5DXONxwZwPOGxVeuSWztmOJUARVvJweAGq15U1UuRXQqgBkYrCzJbjK1CK1ZEjsgd8MWFrP/gonxaAVBGUVqUnsJ72acMgbXFSchfZOeCYP93A7i1N/vkW2NYgdqrBm/RqnPYXb+eNyr5zGUVNMuNYk6YZkmtLFKuAARhU1ToWHde0LPDbRzQWLE4wbKcGekorxq9fdSQuT908vwcrHzZnXilxg28k1K1hp+6GClXfBht/ebIrToDQ5PStFyKuf1dIbhA/5azn4VLH
 u+/cONYK
 NIpDYYKeLfmkNRItHESGNtw5Zt4ZcjhoMPbBQZAo72QwiPZBnsqKJQTBFevj66UuztOQiE5F3NWpZ+ionbCXnBRrmwCCSx6qWHYp20HCj2UEL1Y0MQHDadkXZ1G2V8UrSp7whzY1q3Ej8W1IuBiZBNAs7qMr8WwSNJbJEG4Ztn7VQ5n1KgZJtGoKVcK8Iu3U3KwIqNb+GKlcQaac=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reimplement vrealloc() to be able to set node and alignment should
a user need to do so. Rename the function to vrealloc_node_align()
to better match what it actually does now and introduce macros for
vrealloc() and friends for backward compatibility.

With that change we also provide the ability for the Rust part of
the kernel to set node and alignment in its allocations.

Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/vmalloc.h | 12 +++++++++---
 mm/nommu.c              |  3 ++-
 mm/vmalloc.c            | 29 ++++++++++++++++++++++++-----
 3 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index fdc9aeb74a44..68791f7cb3ba 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -197,9 +197,15 @@ extern void *__vcalloc_noprof(size_t n, size_t size, gfp_t flags) __alloc_size(1
 extern void *vcalloc_noprof(size_t n, size_t size) __alloc_size(1, 2);
 #define vcalloc(...)		alloc_hooks(vcalloc_noprof(__VA_ARGS__))
 
-void * __must_check vrealloc_noprof(const void *p, size_t size, gfp_t flags)
-		__realloc_size(2);
-#define vrealloc(...)		alloc_hooks(vrealloc_noprof(__VA_ARGS__))
+void *__must_check vrealloc_node_align_noprof(const void *p, size_t size,
+		unsigned long align, gfp_t flags, int nid) __realloc_size(2);
+#define vrealloc_node_noprof(_p, _s, _f, _nid)	\
+	vrealloc_node_align_noprof(_p, _s, 1, _f, _nid)
+#define vrealloc_noprof(_p, _s, _f)		\
+	vrealloc_node_align_noprof(_p, _s, 1, _f, NUMA_NO_NODE)
+#define vrealloc_node_align(...)		alloc_hooks(vrealloc_node_align_noprof(__VA_ARGS__))
+#define vrealloc_node(...)			alloc_hooks(vrealloc_node_noprof(__VA_ARGS__))
+#define vrealloc(...)				alloc_hooks(vrealloc_noprof(__VA_ARGS__))
 
 extern void vfree(const void *addr);
 extern void vfree_atomic(const void *addr);
diff --git a/mm/nommu.c b/mm/nommu.c
index 07504d666d6a..3bb62b779ef4 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -119,7 +119,8 @@ void *__vmalloc_noprof(unsigned long size, gfp_t gfp_mask)
 }
 EXPORT_SYMBOL(__vmalloc_noprof);
 
-void *vrealloc_noprof(const void *p, size_t size, gfp_t flags)
+void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align,
+				 gfp_t flags, int node)
 {
 	return krealloc_noprof(p, size, (flags | __GFP_COMP) & ~__GFP_HIGHMEM);
 }
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6dbcdceecae1..e299b51bd922 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4089,19 +4089,29 @@ void *vzalloc_node_noprof(unsigned long size, int node)
 EXPORT_SYMBOL(vzalloc_node_noprof);
 
 /**
- * vrealloc - reallocate virtually contiguous memory; contents remain unchanged
+ * vrealloc_node_align_noprof - reallocate virtually contiguous memory; contents
+ * remain unchanged
  * @p: object to reallocate memory for
  * @size: the size to reallocate
+ * @align: requested alignment
  * @flags: the flags for the page level allocator
+ * @nid: node number of the target node
+ *
+ * If @p is %NULL, vrealloc_XXX() behaves exactly like vmalloc_XXX(). If @size
+ * is 0 and @p is not a %NULL pointer, the object pointed to is freed.
  *
- * If @p is %NULL, vrealloc() behaves exactly like vmalloc(). If @size is 0 and
- * @p is not a %NULL pointer, the object pointed to is freed.
+ * If the caller wants the new memory to be on specific node *only*,
+ * __GFP_THISNODE flag should be set, otherwise the function will try to avoid
+ * reallocation and possibly disregard the specified @nid.
  *
  * If __GFP_ZERO logic is requested, callers must ensure that, starting with the
  * initial memory allocation, every subsequent call to this API for the same
  * memory allocation is flagged with __GFP_ZERO. Otherwise, it is possible that
  * __GFP_ZERO is not fully honored by this API.
  *
+ * Requesting an alignment that is bigger than the alignment of the existing
+ * allocation will fail.
+ *
  * In any case, the contents of the object pointed to are preserved up to the
  * lesser of the new and old sizes.
  *
@@ -4111,7 +4121,8 @@ EXPORT_SYMBOL(vzalloc_node_noprof);
  * Return: pointer to the allocated memory; %NULL if @size is zero or in case of
  *         failure
  */
-void *vrealloc_noprof(const void *p, size_t size, gfp_t flags)
+void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align,
+				 gfp_t flags, int nid)
 {
 	struct vm_struct *vm = NULL;
 	size_t alloced_size = 0;
@@ -4135,6 +4146,12 @@ void *vrealloc_noprof(const void *p, size_t size, gfp_t flags)
 		if (WARN(alloced_size < old_size,
 			 "vrealloc() has mismatched area vs requested sizes (%p)\n", p))
 			return NULL;
+		if (WARN(!IS_ALIGNED((unsigned long)p, align),
+			 "will not reallocate with a bigger alignment (0x%lx)\n", align))
+			return NULL;
+		if (unlikely(flags & __GFP_THISNODE) && nid != NUMA_NO_NODE &&
+			     nid != page_to_nid(vmalloc_to_page(p)))
+			goto need_realloc;
 	}
 
 	/*
@@ -4165,8 +4182,10 @@ void *vrealloc_noprof(const void *p, size_t size, gfp_t flags)
 		return (void *)p;
 	}
 
+need_realloc:
 	/* TODO: Grow the vm_area, i.e. allocate and map additional pages. */
-	n = __vmalloc_noprof(size, flags);
+	n = __vmalloc_node_noprof(size, align, flags, nid, __builtin_return_address(0));
+
 	if (!n)
 		return NULL;
 
-- 
2.39.2


