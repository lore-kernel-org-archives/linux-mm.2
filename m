Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3CA9606B9B2
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q1i+y9XT
Received: by kanga.kvack.org (Postfix)
	id ECA306B00EF; Fri, 20 Nov 2026 13:19:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA1986B05B1; Fri, 20 Nov 2026 13:19:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB6B46B0602; Fri, 20 Nov 2026 13:19:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B26616B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:19:46 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4F4EDC0140
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:19:46 +0000 (UTC)
X-FDA: 85456310772.13.9EB9A06
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id A55F81A0005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:19:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q1i+y9XT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795198784;
	b=osdAXQdJkdZtzElItdeEkrDeSFG1V5utLTRAwYUutNRH6+v+7KvtU5husSwuLgyreyh9Du
	StD01JU2niXm6tbUrpRtAqxBW3yPuR2OqygZ/VaPCFVfzkQl6EfksSCsr79tl0JhBxKQiu
	HODmZKW346kGuEmnbppr8HyGosEHS9I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UdEz5ChOTQTbNYz1UmBbzo8Aoq31zV2Ta5sIBGLsEk0=;
	b=PbEAoCA/bCJVrrHheILYijZq+uFnwDrLOlBUE+5lILj1OqFE73U037vjm7ux99x9EyZv31
	HGzyf/0x2FKjJYyr95z2Z8350lm6y2oartTGwiEGtabuSgSxiBSVKHg9UYgkkrL+/TH052
	+S+tUgavMhrfmc4XizvtvIyClPN+PPU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q1i+y9XT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 00A8F630EC;
	Fri, 20 Nov 2026 18:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3EC1F000D1;
	Fri, 20 Nov 2026 18:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198783;
	bh=UdEz5ChOTQTbNYz1UmBbzo8Aoq31zV2Ta5sIBGLsEk0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Q1i+y9XTqJL2olSUgLoFDypoCvg10dPK5cwSnIoE7BSJb6HnLroUCyRPfKJr6C/TW
	 XBmxmu1CiF2gbfxVkPHtAfWMolUBjqehnf1sIoJkZzVO3Bb0r0PWFo9aF4OyWj7bN3
	 YCg/uu0sB9JwxlhCTNuaVQrVjbj1prwuzOzWuH0/OOGXdrwu1Ga0eEgv9ApxocCjxJ
	 Ci5nqhmcr+l9Xp7BS7QTxTihG1UewuIzNwTJNCVfppD5b5b+vC89J/V+ogTWGSoo+j
	 LT0a+FlogR7KRuQJUz8LfqDCuJ2xaB5LPL/0ViD97BmEbcUVaRYcl4wsLd+41IXKLS
	 fM3mOWgVdsI4A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Mike Rapoport
 <rppt@kernel.org>,  robin.murphy@arm.com,  maz@kernel.org,
  will@kernel.org,  David Matlack <dmatlack@google.com>,  Alexander Graf
 <graf@amazon.com>,  seanjc@google.com,  jgg@nvidia.com,
  loganodell@google.com,  arnd@arndb.de,  dwmw2@infradead.org,
  baolu.lu@linux.intel.com,  Bjorn Helgaas <bhelgaas@google.com>,
  oupton@kernel.org,  alex@shazbot.org,  gle.com@google.com,
  pbonzini@redhat.com,  Andrew Morton <akpm@linux-foundation.org>,
  kevin.tian@intel.com,  joro@8bytes.org,  kvmarm@lists.linux.dev,
  linux-pci@vger.kernel.org,  Pratyush Yadav <pratyush@kernel.org>,
  kexec@lists.infradead.org,  kvm@vger.kernel.org,  iommu@lists.linux.dev,
  linux-arm-kernel@lists.infradead.org,  skhawaja@google.com,
  sagis@google.com,  linux-arch@vger.kernel.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 03/19] kho, memfd_luo: Reference struct kho_vmalloc
 via serialized pointer
In-Reply-To: <20261110050202.529473-4-tarunsahu@google.com> (Tarun Sahu's
	message of "Tue, 10 Nov 2026 05:01:46 +0000")
References: <20261110050202.529473-1-tarunsahu@google.com>
	<20261110050202.529473-4-tarunsahu@google.com>
Date: Fri, 20 Nov 2026 18:19:35 +0000
Message-ID: <2vxz4idb1i2w.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A55F81A0005
X-Rspam-User:
X-Stat-Signature: fnrasowg9ydii4x3wthph59joesthrza
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795198784-744973
X-HE-Meta: U2FsdGVkX197z4BxNh2hWyaGjrzGXF8UvWg3AxpKorGyRQ1LjpRGVZA4U80eBnbhS1ZE6NiSVwBqw6o9I0czHce0yw3lObvc5ktFxvUvqwzMZwLF9YLlpy3TAxbceuSf8wjMZmcX8y5wqg2p241UE09VqSQdYh47SCetIso1+KWSEvRXCMYykQ5u2Nm21NadbzNzBxB2jgXiZFd01EUuUAxLIYcp+UXkP+Ssdam1ptFBVHklrpqYRo81VTmMvwQuZbX2aN1m6ZpQpr5nEjGYgfcKqejtgyXrsbzfz3Ftb8i0pcSamMm6izHcrr+Qa6XRZXb3+cymofYURCnOiEfeiW+Li4SLOY1dKhhez+JcRi6KdxhoSeQOQHj1lxwoyQRaTcxxHduVirNWBq/wem6vtenFobeHNK73l64wv/751aL76zaGCKftP33DZFZYrx6ootn8NB+2VKb7tjyQj+kOFHxYbNHFphls2obrIX2wmX7ji4YCcZwAooKIACL+gDApr8VdmypCFrVvP4rt3hVVFGRR7/IKDR94hB8kIpUHUvz1JgK/7ymdQbK9zKbKdf1mjKG9vnpMSDDS1mR5xubvwkqxBai8YZ+JFWwxBM1xpdBemnDV6Py4FeaVBWoG2DSqZfT0ufIvJH+cG3ZJhUAe9/6WnytS+qZk7rbaQk9JL8mE04Y/pzLB01/b9CYrlkn4qB0Uzws9C2G2AGMHRJo1tsj2WD7G70NvdlMHYAvZ5IUiTIzG0r7aVz3hRCrO2LFbWqRlul6fH+/ebPoc4ve/6knVtqgVCcTWgZwP/rgOKruBqCPD/zqIuUxDiRy1d+QlDbGIg8QwCLpdbuxgz4cQXqNkAbXBoFEZjD/1/Z5aTsfLYpMG825peNSgZz50r0NVm/lQ5TNyOqCOg/S2grBDNenE/I11npGk2ppm2njSBP+ExRvnUgynv1vWyYX3nyfKWwLbDzVDOs9Q7s0JcJt
 D6Jk4dd7
 tnzaD9I3sW3XHEoQhEtnMhmXfGJhlXSDhaPqdWT0vTTWK8i+jmbqL/xfRn4E8jmk6yJIzzLlxWrjV45iWTVzpn3ZvY0elVveyTJ2DbibvVIKJ7DYSQAME6hkM1BDWiZnGebSlpnfCzF7Y76wGZxxhblSBsAl5f0gp7Sbx5n/bK3Y2fAKa/WYtH96r/shQYrMyOqXt0tMZ7JK+EkanuSFdD34VU9qKMtm8eDmIE8+zYysbKuu9/XcCRv+QpTravThBX4kmYCbc01s694kEc3qNoFGjvNoXIZC7qcdsUcn19tMyZqUUfJ8n9oBZ0kq+OL5s3XWma8+Wo5Pl/dG6ZZ0n7MuCrDAOD7AANkE2DPsuzQwCZ8WPXiFyg9zF5aT+x5HBKpO4DheOhfL+brM4+kAVwWglqveTAjYfvcCRkDICkYEqtnzCuCGN0auX3NvCCLTEBT4TVlWcUWqumOoooFU34Ftug7vrdc8LY4GwfW+z6EtP8BPCDgO6MxQQqhXXlOHljyJRHWFefqmypPx8psGkmNSnmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10 2026, Tarun Sahu wrote:

> Subsystems preserving vmalloc allocations currently embed struct
> kho_vmalloc directly by value in their serialized structures or device
> tree properties. For example, struct memfd_luo_ser embeds struct
> kho_vmalloc folios, and test_kho writes the structure directly into the
> folios_info FDT property.
>
> Embedding struct kho_vmalloc directly couples the containing layout's
> field offsets and size to struct kho_vmalloc. Any modification to struct
> kho_vmalloc shifts subsequent fields in the containing structure and
> breaks the handover ABI across kexec.
>
> Convert callers to hold a DECLARE_KHOSER_PTR pointer to struct
> kho_vmalloc instead of embedding it by value. In memfd_luo, allocate the
> main structure and struct kho_vmalloc in the same preserved folio, placing
> struct kho_vmalloc in the remaining 8-byte-aligned space, and bump the
> compatibility string to memfd-v3. In test_kho, place struct kho_vmalloc
> in the remaining space of the FDT folio, store the serialized pointer in
> the folios_info property, and bump the compatibility string to
> kho-test-v2.
>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> ---
>  include/linux/kho/abi/kexec_handover.h |  6 +++
>  include/linux/kho/abi/memfd.h          |  8 ++--
>  lib/test_kho.c                         | 29 ++++++++----
>  mm/memfd_luo.c                         | 63 ++++++++++++++++----------
>  4 files changed, 68 insertions(+), 38 deletions(-)
>
[...]
> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index 6b68220275eb..4471cced57db 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -85,9 +85,8 @@
>  #include "internal.h"
>  
>  static int memfd_luo_preserve_folios(struct file *file,
> -				     struct kho_vmalloc *kho_vmalloc,
> -				     struct memfd_luo_folio_ser **out_folios_ser,
> -				     u64 *nr_foliosp)
> +				     struct memfd_luo_ser *ser,
> +				     struct memfd_luo_folio_ser **out_folios_ser)
>  {
>  	struct inode *inode = file_inode(file);
>  	struct memfd_luo_folio_ser *folios_ser;
> @@ -104,7 +103,8 @@ static int memfd_luo_preserve_folios(struct file *file,
>  	 * are not set.
>  	 */
>  	if (!size) {
> -		*nr_foliosp = 0;
> +		ser->folios.phys = 0;

I don't think it is a good idea to access this directly.

Please take this patch instead:
https://lore.kernel.org/kexec/20261116134013.1636689-2-pratyush@kernel.org/

> +		ser->nr_folios = 0;
>  		*out_folios_ser = NULL;
>  		return 0;
>  	}
> @@ -200,12 +200,12 @@ static int memfd_luo_preserve_folios(struct file *file,
>  		pfolio->index = folio->index;
>  	}
>  
> -	err = kho_preserve_vmalloc(folios_ser, kho_vmalloc);
> +	err = kho_preserve_vmalloc(folios_ser, KHOSER_LOAD_PTR(ser->folios));
>  	if (err)
>  		goto err_unpreserve;
>  
>  	kvfree(folios);
> -	*nr_foliosp = nr_folios;
> +	ser->nr_folios = nr_folios;
>  	*out_folios_ser = folios_ser;
>  
>  	/*
> @@ -254,37 +254,43 @@ static void memfd_luo_unpreserve_folios(struct kho_vmalloc *kho_vmalloc,
>  	vfree(folios_ser);
>  }
>  
> +static size_t memfd_luo_ser_size(void)
> +{
> +	return sizeof(struct memfd_luo_ser) + sizeof(struct kho_vmalloc);
> +}
> +
> +static struct memfd_luo_ser *memfd_luo_ser_init(void *mem)
> +{
> +	struct kho_vmalloc *kho_vmalloc = mem + sizeof(struct memfd_luo_ser);
> +	struct memfd_luo_ser *ser = mem;
> +
> +	KHOSER_STORE_PTR(ser->folios, kho_vmalloc);
> +	return ser;
> +}
> +

Hmm, I am not a huge fan of this. This makes doing such allocations
quite annoying, and I reckon we will be seeing a fair bit of them in
many places.

The key observation here is that most file handlers need to allocate a
bunch of preserved memory, but they usually can free it all at once. So
we can get away with a very simple allocator that hands out memory
linearly.

I have sketched out some code for this, take a look at the patch below.
Note that it is only compile tested.

Perhaps give it a try and see if it does the job better.

>  static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
>  {
>  	struct inode *inode = file_inode(args->file);
>  	struct memfd_luo_folio_ser *folios_ser;
>  	struct memfd_luo_ser *ser;
> -	u64 nr_folios, inode_size;
>  	int err = 0, seals;
> +	u64 inode_size;
>  
>  	inode_lock(inode);
>  	shmem_freeze(inode, true);
>  
> -	/* Allocate the main serialization structure in preserved memory */
> -	ser = kho_alloc_preserve(sizeof(*ser));
> -	if (IS_ERR(ser)) {
> -		err = PTR_ERR(ser);
> -		goto err_unlock;
> -	}
> -
>  	seals = memfd_get_seals(args->file);
>  	if (seals < 0) {
>  		err = seals;
> -		goto err_free_ser;
> +		goto err_unlock;
>  	}
>  
>  	/* Make sure the file only has the seals supported by this version. */
>  	if (seals & ~MEMFD_LUO_ALL_SEALS) {
>  		err = -EOPNOTSUPP;
> -		goto err_free_ser;
> +		goto err_unlock;
>  	}
>  
> -	ser->pos = args->file->f_pos;
>  	inode_size = i_size_read(inode);
>  
>  	/*
> @@ -293,18 +299,26 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
>  	 */
>  	if (DIV_ROUND_UP_ULL(inode_size, PAGE_SIZE) > UINT_MAX) {
>  		err = -EFBIG;
> -		goto err_free_ser;
> +		goto err_unlock;
> +	}
> +
> +	/* Allocate the main serialization structure in preserved memory */
> +	ser = kho_alloc_preserve(memfd_luo_ser_size());
> +	if (IS_ERR(ser)) {
> +		err = PTR_ERR(ser);
> +		goto err_unlock;
>  	}
> +	ser = memfd_luo_ser_init(ser);
>  
> +	ser->pos = args->file->f_pos;
>  	ser->size = inode_size;
>  	ser->seals = seals;
> +	ser->flags = 0;

Nit: Looks like a stray change. Flags should be initialized to 0 anyway,
right?

>  
> -	err = memfd_luo_preserve_folios(args->file, &ser->folios,
> -					&folios_ser, &nr_folios);
> +	err = memfd_luo_preserve_folios(args->file, ser, &folios_ser);
>  	if (err)
>  		goto err_free_ser;
>  
> -	ser->nr_folios = nr_folios;
>  	inode_unlock(inode);
>  
>  	args->private_data = folios_ser;
[...]

--- 8< ---

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index ef2b188c8ed0..f17b46a4dbf6 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -13,6 +13,21 @@ struct kho_vmalloc;
 struct folio;
 struct page;
 
+/**
+ * struct kho_arena - Allocator handing out pieces of one preserved buffer.
+ * @buf:  Start of the preserved buffer.
+ * @size: Size of the buffer in bytes.
+ * @used: Offset in the buffer where the last allocation ended.
+ *
+ * This is runtime state only. It is not preserved and the next kernel does not
+ * need it to free the buffer.
+ */
+struct kho_arena {
+	void *buf;
+	size_t size;
+	size_t used;
+};
+
 #ifdef CONFIG_KEXEC_HANDOVER
 bool kho_is_enabled(void);
 bool is_kho_boot(void);
@@ -26,6 +41,9 @@ void kho_unpreserve_vmalloc(struct kho_vmalloc *preservation);
 void *kho_alloc_preserve(size_t size);
 void kho_unpreserve_free(void *mem);
 void kho_restore_free(void *mem);
+int kho_arena_init(struct kho_arena *arena, size_t size);
+void *kho_arena_alloc(struct kho_arena *arena, size_t size);
+void kho_arena_destroy(struct kho_arena *arena);
 struct folio *kho_restore_folio(phys_addr_t phys);
 struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages);
 void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
@@ -89,6 +107,18 @@ static inline void *kho_alloc_preserve(size_t size)
 static inline void kho_unpreserve_free(void *mem) { }
 static inline void kho_restore_free(void *mem) { }
 
+static inline int kho_arena_init(struct kho_arena *arena, size_t size)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void *kho_arena_alloc(struct kho_arena *arena, size_t size)
+{
+	return NULL;
+}
+
+static inline void kho_arena_destroy(struct kho_arena *arena) { }
+
 static inline struct folio *kho_restore_folio(phys_addr_t phys)
 {
 	return NULL;
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 38e65d210cb9..c2788027d717 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1659,6 +1659,78 @@ void kho_restore_free(void *mem)
 }
 EXPORT_SYMBOL_GPL(kho_restore_free);
 
+/* Enough for any serialized data structure. */
+#define KHO_ARENA_ALIGN		sizeof(u64)
+
+/**
+ * kho_arena_init - Initialize a preserved buffer backing an arena.
+ * @arena: The arena to initialize.
+ * @size:  The size of buffer to allocate.
+ *
+ * kho_alloc_preserve() rounds every allocation up to use a full folio. A caller
+ * that needs many small objects wastes most of a folio on each. An arena takes
+ * one buffer from kho_alloc_preserve() and hands out pieces of it one after
+ * another.
+ *
+ * Allocations can not be freed one by one. The whole buffer is freed at once,
+ * with kho_arena_destroy(). or with kho_restore_free() in the incoming kernel.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int kho_arena_init(struct kho_arena *arena, size_t size)
+{
+	void *buf;
+
+	buf = kho_alloc_preserve(size);
+	if (IS_ERR(buf))
+		return PTR_ERR(buf);
+
+	arena->buf = buf;
+	arena->size = PAGE_SIZE << get_order(size);
+	arena->used = 0;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kho_arena_init);
+
+/**
+ * kho_arena_alloc - Allocate preserved memory from an arena.
+ * @arena: The arena to allocate from.
+ * @size:  The number of bytes to allocate.
+ *
+ * Hands out the next @size bytes of the arena's buffer. The memory is zeroed,
+ * aligned to 8 bytes, and already preserved.
+ *
+ * Return: A pointer to the allocated memory, or NULL if @size is 0 or the
+ * arena does not have @size bytes left.
+ */
+void *kho_arena_alloc(struct kho_arena *arena, size_t size)
+{
+	size_t start = ALIGN(arena->used, KHO_ARENA_ALIGN);
+
+	if (!size || size > arena->size - start)
+		return NULL;
+
+	arena->used = start + size;
+
+	return arena->buf + start;
+}
+EXPORT_SYMBOL_GPL(kho_arena_alloc);
+
+/**
+ * kho_arena_destroy - Unpreserve and free the buffer backing an arena.
+ * @arena: The arena to destroy.
+ *
+ * Frees all the memory allocated from the arena. Must only be called in the
+ * outgoing kernel.
+ */
+void kho_arena_destroy(struct kho_arena *arena)
+{
+	kho_unpreserve_free(arena->buf);
+	*arena = (struct kho_arena){};
+}
+EXPORT_SYMBOL_GPL(kho_arena_destroy);
+
 /**
  * is_kho_boot - check if current kernel was booted via KHO-enabled
  * kexec

-- 
Regards,
Pratyush Yadav

