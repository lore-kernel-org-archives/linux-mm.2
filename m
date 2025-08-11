Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0951CA0EC1
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 11:27:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B004B8E0044; Mon, 11 Aug 2025 07:27:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A62E66B0174; Mon, 11 Aug 2025 07:27:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92B318E0044; Mon, 11 Aug 2025 07:27:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C9116B0173
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:27:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3EEB414010D
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:27:08 +0000 (UTC)
X-FDA: 83764250136.02.71DDB17
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0C6F040003
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:27:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BYnqfPTN;
	spf=pass (imf04.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754911626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dH19/uKoiHEMTv0r8rJb8O7lP73Me8TJFFXM58SZ7zM=;
	b=miLAMBVn6CHx0VlndjFgMeZ284pUQUDDKvBR31LPW6yGGZNEnRmtYFEIns6IlxZVYZv1pW
	oTPgGc+AGUDYR2vkWcuJBu7pxZZuQ/B/pnQV2/BptyCew4PLQfIt1KNcC77Twfy6OrWX2m
	CUyhdXW6dEH7ufpFAS5d+IB3FzXeuog=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BYnqfPTN;
	spf=pass (imf04.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754911626; a=rsa-sha256;
	cv=none;
	b=sxLKDtXktRgVhDeNttSr0hXQFenu6wAxDnUSBdIkqoOW5jach073av5oeiIvOidav3nRuJ
	emgbnpXv/VWh5OBTvq9cg/0c8Q1/tVN1EMelR+uKOatG0nGetto1gC3PR+xXPqMSH6eQCf
	g1lHdMo6/m4Bp8XKhSRVX0cEGKP/i1Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754911625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dH19/uKoiHEMTv0r8rJb8O7lP73Me8TJFFXM58SZ7zM=;
	b=BYnqfPTN51kj9BxlD5BWsa/T+EPe2W8VlztA4ZGzQrIC1t0265HzoVMdcbWNMHKmQGuTLO
	cZUMDYwLQvveti3peNZnAQSpeDxDkdZGvmXQWT02YmkPkQf/DjztInidBdqfkdpwPVZiPv
	NxNvf6ZirjRFaUdEWfQyg9jNVnBGx6Q=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-546-DZVzUs47OlqAfXVnwg4YkQ-1; Mon, 11 Aug 2025 07:27:04 -0400
X-MC-Unique: DZVzUs47OlqAfXVnwg4YkQ-1
X-Mimecast-MFC-AGG-ID: DZVzUs47OlqAfXVnwg4YkQ_1754911623
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b836f17b50so2491704f8f.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:27:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754911623; x=1755516423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dH19/uKoiHEMTv0r8rJb8O7lP73Me8TJFFXM58SZ7zM=;
        b=N/ZsoEKR5QIV6S4MAmj8pCCy4d1kjiU800Ou0iMFAI7ZG/vtlmGShoI4u2j12QprlZ
         +1/ay8MGTGoNjkvOTvzo5/5E9y+Tu1s6EtcKKCzjSiKlUoKSnGD2XXhmcrhzlcE1W3S+
         JTT1DNprdDl4cX2uUg1Bcec3JS79Aw38diQTdXOEdRbu3bIj1VxbjIMJWf4S8Pkcpvpi
         gWeN1bSCRDA8octsNWYbz2/M2FQt9g0dSDu95ELEiWpcIqomAvT3qiW+t+hnrZRcqVNG
         50+ko5hJEHt0O99VgGJLrz75qS2nVy88XczFjPaH7Bhek+bGriOqkli6tw6hBRTL0gA1
         BGCw==
X-Gm-Message-State: AOJu0YyjY8MIPVC++qTtcZcUyl9pn2a4oZc+yIEwvMsCF4Nfw8VAiOB6
	ICRAOgjz35uVJ5wi3Mnm3w/ituBYzq+m5CZuHMz1cPjw2mSJZIFAzkVHl2ZFSFqQdW4ymt0pZxK
	KtntvLJOdjzbTmNaptNpeAkNn3nb09ed0E14a3LGx2m/unp/Ja+kK
X-Gm-Gg: ASbGncujvpeWM4gjCY3vhGlKCEwdIj9P82N/IuMj8PtdAmStsfpC9IKwCKq1zCH/a1z
	m97Wu+kpksgxuecbNnAMxM+NEoYuLkLPWaBKHpdcF+pUQEXAYrAwoblHVpP944gs6yYmxdUl3QK
	HCk70vFIAIIX6S4r5xawJeYmjaf7hGtKFFb4JCJUIVBOD4q/jpNCJ00ZiaWz/CL5dII772GSIV/
	eIO5tG57Wz3xZc/rjRxUt4RV5HAHhMubaEXZLFL40goVQbGFxnF5B7jI1D0QqKu6AkftabRJtlR
	FsvZtsKGNilSt2C8LUQ1xEwIe8TyNotVN4Z/l4IAx63ZEcbWMdneA2qhbIAR+xf7fZzPVakjICy
	w6TwiJtBh/ECDKmiN6TsZjBWJ
X-Received: by 2002:a5d:5d0a:0:b0:3a5:2653:7308 with SMTP id ffacd0b85a97d-3b900b5742bmr9602303f8f.57.1754911622752;
        Mon, 11 Aug 2025 04:27:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGGXEgHnsOD9ZoHC3rozcCl2T1/SKhNFUvb83wEfWy/U4w8SmZE0De8ROcIUkzkJT6XleOZhA==
X-Received: by 2002:a5d:5d0a:0:b0:3a5:2653:7308 with SMTP id ffacd0b85a97d-3b900b5742bmr9602254f8f.57.1754911622182;
        Mon, 11 Aug 2025 04:27:02 -0700 (PDT)
Received: from localhost (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-459e5862be7sm264659195e9.15.2025.08.11.04.27.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 04:27:01 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	xen-devel@lists.xenproject.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Hugh Dickins <hughd@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lance Yang <lance.yang@linux.dev>,
	David Vrabel <david.vrabel@citrix.com>,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH v3 11/11] mm: rename vm_ops->find_special_page() to vm_ops->find_normal_page()
Date: Mon, 11 Aug 2025 13:26:31 +0200
Message-ID: <20250811112631.759341-12-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811112631.759341-1-david@redhat.com>
References: <20250811112631.759341-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Gr64Pwm1tmFVb8cuPuXjiSEWUaPhUpgwnL4VB2Gmr3s_1754911623
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C6F040003
X-Rspamd-Server: rspam06
X-Stat-Signature: zmq5aqfea4x1nwkopb138m6aashh46za
X-HE-Tag: 1754911625-671142
X-HE-Meta: U2FsdGVkX19hI4R+bg3WonEw4M2E+AzC+bmPEqKCa3PixGP7qUNLBZjFr3/McNKw2rUcLirBWkwgwtkwEU4hK0VtDAwuGuv9jUakPPvXRIkYiY1AixUWxfsshN04NKuM6dj9CVGd9M6ZVVJPakfOlXQMyh0sNDfYsJOlO4ThOXqmENRaIH/iMEcYVQQ52Ei8rd95q99rEQKSLMz6x3VHC6iLKzi2hPr+v4N87ZDfhxP0jygjxd+clQVWf0HDrIiT6NyEjVDKocjsF8gLXSZFUgoyCpYzDxCWEtUqf1wYivEse5KXHFQypu1hQLN785P659DexWjfFh1vup81om4qIBpT2D7+AnVaclLvf/LEkxVQAXqyzJ8kPwquOWJn5TP6QSrgvSFfVzvXtORq4IfuqQX2ACZ90nhrYn1CWMMV2w/IOHzjsSqPB72IFBYltPhdTfiacZOgXafZBR9uVrqjg4kyL0kQJrXrgG3FJyrV0UX/pLdKZhvK3VwS2FntHAIG90EvVg5r6BjBXWmaRjAldrbyi4fGIzoBJGdVyRCudhHv2T5ivGH9B9M1jNauX4cFDXx75toAIf8yNFDbkTnsYTlAQRpKE3+F4xD7S6Qrleu5EdmL7hHe7zJxwR8CSKRBsFAKWndB6jxRiSFBuNKIL/74DlikS8MxHSPQ6kL9M2RxsK3SycVbi5pruyV+dav9ElLcfqsOPjY0Ro9g0g8NoepCeXSCIqt65JPI3dMtb9I+CdJihQIm2m1IArh6KpuKtq80TxDbQ35bNbwjgQXu+ITSA9i70sGAPzphWwIVgejIUfTLrCiwpwyJmq2mABJh45U8f96AC+K7+YHgp4bZC8alMOkMF1i2bz2/1n8BVI2BxKZsX8jSotWXZ6fBzBkmfcErGtNl+v4uig7C3EgiTdDFmr3WRdiy0tT+jMavV7+jIEk6z+/4FAO8WlfOWt0H2+33tFQ70WrazfK2KkP
 04ooxD20
 /dUE2xlnSR5rGyIGE/SpbHJ4zWMccKXelvLTuOd3Gh98W7Np13kPG099fgybXmkgGzZK/xoy+SpwVg3Imnt8Sl+4eRgCgr1tjMX9TWLjoJ9UaV+zMJ1F8xA9UFQ5qPPS03Q6cMQb3t+ihH3jSG6h2mCCNmojUmHaA+ZBSgFWDTbPBQjGz0/HJ6la2ilGqy8XPhCMVZkXqpj9zAJ9piLj1pEMVNDy4SQCByV3SqljI0JUvcwfA8z1o36y/X5VlXp2ShIIlD+OTx0Fqor5qPZPvEifAbkYpLG4aMzZADhNt5h3XL0dv7jsaVdoO3kXq6te6z790Xsf2tmYYLBRaR+6XBeq/0QxACwZbXiAZQ80jf8Dtajv4gCxQiBpOaH41A+s9m4brAgRZo2CHgbW3+OhQpx8zu6j5KF7MHXN5rpqJKuofqBmar8QOtrhSVRhEmbBW5PyX+miH86KzEGhXb1wNHs3poqhYVNaOBI8+q1GoVZmhrQ+pSd1LJVkzETcF1BoKP6GiShxSYNRTSlCJnVyWvzui64pYlexloa6L9H7n9bJoHYqK4o8JH4cQhiirLF8nSeukkbUv3bXIvJKJiTmerZt4JtFTJ6iply3P2NvKQggNwXNt+DmL1HpRAPl9SWfQwzuTL10CVkWlxsszqT5o9opX2wlHTmHKShHnTtJGyby6FBrfjwPf3bksmh2SeJ2QT68E
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

... and hide it behind a kconfig option. There is really no need for
any !xen code to perform this check.

The naming is a bit off: we want to find the "normal" page when a PTE
was marked "special". So it's really not "finding a special" page.

Improve the documentation, and add a comment in the code where XEN ends
up performing the pte_mkspecial() through a hypercall. More details can
be found in commit 923b2919e2c3 ("xen/gntdev: mark userspace PTEs as
special on x86 PV guests").

Cc: David Vrabel <david.vrabel@citrix.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/xen/Kconfig              |  1 +
 drivers/xen/gntdev.c             |  5 +++--
 include/linux/mm.h               | 18 +++++++++++++-----
 mm/Kconfig                       |  2 ++
 mm/memory.c                      | 12 ++++++++++--
 tools/testing/vma/vma_internal.h | 18 +++++++++++++-----
 6 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 24f485827e039..f9a35ed266ecf 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -138,6 +138,7 @@ config XEN_GNTDEV
 	depends on XEN
 	default m
 	select MMU_NOTIFIER
+	select FIND_NORMAL_PAGE
 	help
 	  Allows userspace processes to use grants.
 
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 1f21607656182..26f13b37c78e6 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -321,6 +321,7 @@ static int find_grant_ptes(pte_t *pte, unsigned long addr, void *data)
 	BUG_ON(pgnr >= map->count);
 	pte_maddr = arbitrary_virt_to_machine(pte).maddr;
 
+	/* Note: this will perform a pte_mkspecial() through the hypercall. */
 	gnttab_set_map_op(&map->map_ops[pgnr], pte_maddr, flags,
 			  map->grants[pgnr].ref,
 			  map->grants[pgnr].domid);
@@ -528,7 +529,7 @@ static void gntdev_vma_close(struct vm_area_struct *vma)
 	gntdev_put_map(priv, map);
 }
 
-static struct page *gntdev_vma_find_special_page(struct vm_area_struct *vma,
+static struct page *gntdev_vma_find_normal_page(struct vm_area_struct *vma,
 						 unsigned long addr)
 {
 	struct gntdev_grant_map *map = vma->vm_private_data;
@@ -539,7 +540,7 @@ static struct page *gntdev_vma_find_special_page(struct vm_area_struct *vma,
 static const struct vm_operations_struct gntdev_vmops = {
 	.open = gntdev_vma_open,
 	.close = gntdev_vma_close,
-	.find_special_page = gntdev_vma_find_special_page,
+	.find_normal_page = gntdev_vma_find_normal_page,
 };
 
 /* ------------------------------------------------------------------ */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8ca7d2fa71343..3868ca1a25f9c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -657,13 +657,21 @@ struct vm_operations_struct {
 	struct mempolicy *(*get_policy)(struct vm_area_struct *vma,
 					unsigned long addr, pgoff_t *ilx);
 #endif
+#ifdef CONFIG_FIND_NORMAL_PAGE
 	/*
-	 * Called by vm_normal_page() for special PTEs to find the
-	 * page for @addr.  This is useful if the default behavior
-	 * (using pte_page()) would not find the correct page.
+	 * Called by vm_normal_page() for special PTEs in @vma at @addr. This
+	 * allows for returning a "normal" page from vm_normal_page() even
+	 * though the PTE indicates that the "struct page" either does not exist
+	 * or should not be touched: "special".
+	 *
+	 * Do not add new users: this really only works when a "normal" page
+	 * was mapped, but then the PTE got changed to something weird (+
+	 * marked special) that would not make pte_pfn() identify the originally
+	 * inserted page.
 	 */
-	struct page *(*find_special_page)(struct vm_area_struct *vma,
-					  unsigned long addr);
+	struct page *(*find_normal_page)(struct vm_area_struct *vma,
+					 unsigned long addr);
+#endif /* CONFIG_FIND_NORMAL_PAGE */
 };
 
 #ifdef CONFIG_NUMA_BALANCING
diff --git a/mm/Kconfig b/mm/Kconfig
index e443fe8cd6cf2..59a04d0b2e272 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1381,6 +1381,8 @@ config PT_RECLAIM
 
 	  Note: now only empty user PTE page table pages will be reclaimed.
 
+config FIND_NORMAL_PAGE
+	def_bool n
 
 source "mm/damon/Kconfig"
 
diff --git a/mm/memory.c b/mm/memory.c
index 6f806bf3cc994..002c28795d8b7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -639,6 +639,12 @@ static void print_bad_page_map(struct vm_area_struct *vma,
  * trivial. Secondly, an architecture may not have a spare page table
  * entry bit, which requires a more complicated scheme, described below.
  *
+ * With CONFIG_FIND_NORMAL_PAGE, we might have the "special" bit set on
+ * page table entries that actually map "normal" pages: however, that page
+ * cannot be looked up through the PFN stored in the page table entry, but
+ * instead will be looked up through vm_ops->find_normal_page(). So far, this
+ * only applies to PTEs.
+ *
  * A raw VM_PFNMAP mapping (ie. one that is not COWed) is always considered a
  * special mapping (even if there are underlying and valid "struct pages").
  * COWed pages of a VM_PFNMAP are always normal.
@@ -679,8 +685,10 @@ static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
 {
 	if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
 		if (unlikely(special)) {
-			if (vma->vm_ops && vma->vm_ops->find_special_page)
-				return vma->vm_ops->find_special_page(vma, addr);
+#ifdef CONFIG_FIND_NORMAL_PAGE
+			if (vma->vm_ops && vma->vm_ops->find_normal_page)
+				return vma->vm_ops->find_normal_page(vma, addr);
+#endif /* CONFIG_FIND_NORMAL_PAGE */
 			if (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
 				return NULL;
 			if (is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 3639aa8dd2b06..cb1c2a8afe265 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -467,13 +467,21 @@ struct vm_operations_struct {
 	struct mempolicy *(*get_policy)(struct vm_area_struct *vma,
 					unsigned long addr, pgoff_t *ilx);
 #endif
+#ifdef CONFIG_FIND_NORMAL_PAGE
 	/*
-	 * Called by vm_normal_page() for special PTEs to find the
-	 * page for @addr.  This is useful if the default behavior
-	 * (using pte_page()) would not find the correct page.
+	 * Called by vm_normal_page() for special PTEs in @vma at @addr. This
+	 * allows for returning a "normal" page from vm_normal_page() even
+	 * though the PTE indicates that the "struct page" either does not exist
+	 * or should not be touched: "special".
+	 *
+	 * Do not add new users: this really only works when a "normal" page
+	 * was mapped, but then the PTE got changed to something weird (+
+	 * marked special) that would not make pte_pfn() identify the originally
+	 * inserted page.
 	 */
-	struct page *(*find_special_page)(struct vm_area_struct *vma,
-					  unsigned long addr);
+	struct page *(*find_normal_page)(struct vm_area_struct *vma,
+					 unsigned long addr);
+#endif /* CONFIG_FIND_NORMAL_PAGE */
 };
 
 struct vm_unmapped_area_info {
-- 
2.50.1


