Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1856CCD193
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 10:02:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DBFC8E0164; Sun, 26 Oct 2025 06:02:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 066018E0150; Sun, 26 Oct 2025 06:02:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6FBD8E0164; Sun, 26 Oct 2025 06:02:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD7A08E0150
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 06:02:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 85B36B8B3E
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 10:02:57 +0000 (UTC)
X-FDA: 84039826794.27.386F336
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf06.hostedemail.com (Postfix) with ESMTP id 95EA1180010
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 10:02:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KtjPy1XT;
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761472975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SChmisoCdyUpnp2jLZohE0/Y9AXNpvewUbNpv8hnnzw=;
	b=4lELkUzRXyAnmJ4niphfgNC3MSbHO/CrLmU8vCBLDgXtn1vxDc0jgo9hs1DQ9484ETeXJQ
	VJTLO7MlXfqfYqGaCpqsBN9EwZZFLo0ps1DYrcOO1hkcER0RWfa6enCdQm/xycKAq48osN
	uGE6BNV4fl4V9O+cccjn2Qnght+Aisg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KtjPy1XT;
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761472975; a=rsa-sha256;
	cv=none;
	b=SSl4QtvcMcoGlmC5Qn6QH8QS2fwGp+bUGn1mRfkGmsDzGCL2Ni9qoc9Q40sYkExs/PPz9R
	aZongGEaH7uWMCt4NWlONbrkRoGGguB8hlu3W54VL9EYTM1WE/Fvza4nYOjwKVsOwjFBgT
	dYp+obJ28ySdKJCViTLQEzrzWHpu3/s=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7a27c67cdc4so2660583b3a.3
        for <linux-mm@kvack.org>; Sun, 26 Oct 2025 03:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761472974; x=1762077774; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SChmisoCdyUpnp2jLZohE0/Y9AXNpvewUbNpv8hnnzw=;
        b=KtjPy1XTBGRC8lxXdVutwR2KtKWzOohBWfECrFJqestT623+YeRr3KA4QFj2tpTFBk
         +zmjtqbmkXjaUvsKNcBiLiMk/42FFyb4Nx0a1LSCUZWAvSJSmISW+FqKBZjNeEO0eddx
         mkhzc1V+mI18tRKR5A3nBrh5vY03OnhwbWFzUTgWLVME4BfUO8ewvdWoUIvO0o1ONVkQ
         4ATWV+gfd3SfQOoFYal6N8SWw9g2u6p1ufkEGWJ392G7S/MJhCZ/9SDJAa+WRe1dRV4B
         Cx0CchwugCbtOuVSuJAZw+cSWFsngD8+z45kKfiDocSCd68QLUFvRC+p/cxaookrlj2Q
         4IjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761472974; x=1762077774;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SChmisoCdyUpnp2jLZohE0/Y9AXNpvewUbNpv8hnnzw=;
        b=jukbTlIJ2AWaf7r6mYUen0khmEEM3T/cmfeddsfuf2oomuyJ3t/e9P4Ag4gB+XyePe
         VvocijktFqRT2FiqRG8R3JGw1f2yjXWbZtnQHDerpDk6ixB2VzfjmIYuiubHifbSKRXi
         vdO86T6fzzHaaeL7K8VQbXQ+CdsidcNE5vcghNfAq/6qS7/wVodPfl2mhlD+NF7lDJW8
         SzuomL6V3J2gdVKrgjoiZ0xK/rw5sLQj8n1/k6zC/VSIFajySgjRpkVBWr0CMuRfGR+V
         nR6bu4t8mXpTwH+hTIAivQ1z74HpfZot8/Nmo928noUf6bX8DHoYt0kBCglk5zjxzB+N
         Z24w==
X-Forwarded-Encrypted: i=1; AJvYcCXqAhuYlKmnEu242AJ3tv4TGxAnKB6RP8+tspUpsbf/6PG+nGjXHrgTVpf3qGX5M3wr6t2GCw72UQ==@kvack.org
X-Gm-Message-State: AOJu0YxT626pWHZpqwOJlEoS4MV9utLrGZZmfbz7ITBdMmcaR2CGhMjT
	9FYPOEjmnb9cwhkurIAfwueJkJM019nCzHO/KyIK3AcVX7zREPQchdCZ
X-Gm-Gg: ASbGncvpRWoK+h1WxAPkHpZ5WUzMYuy3l4/VWlPVTWwVtQQV3fsypyjM8bvmdR1su1S
	8tqY41eQg6hp4EeRhgt81f+GKRVLJlcsnVzZSifLx+OCBfXnx6M82MlePe43s8P+QRnjYMLfyhZ
	SDCMsZ5BK47ZKs1T6NHoa0OtTulUVkvqnMlVobI7kxgkXui0sBMxwhDvl6T/BYkYBb6ZRmaGhmJ
	393wKrMnxdkEXc2Ql2/Rod4qtXvhNa+10kbRUlkirbHTBbzp0DcJA2vGugHgzjCoKKwoUzL7YbT
	iE5g8+qv8K55jPVWMja8A4vWD/Lw0euMgfecxeGkFqbTIan0Ry2J3El6zVVcVWDWbWS0cwGmqXp
	cDdM32B7fJQRicZMwwWcar/RTUYLzMpVl1UKC0bKkiEVSbPQ1Rgx6rmuxxNXDAyP48ytIx7nHeD
	0DxXNLXkpD0xt4JFtdpBodikZJawJ2E6lngQythTlECtYU8A==
X-Google-Smtp-Source: AGHT+IGASxBx06uCW6XVBswtwF80CA2QVkXW2h08zVRq2gdvMSBGMYG7U2JWmDZ1EeBq1W47b1EDrQ==
X-Received: by 2002:a05:6a20:6a07:b0:342:a7cd:9221 with SMTP id adf61e73a8af0-342a7cd95d9mr1256138637.20.1761472974316;
        Sun, 26 Oct 2025 03:02:54 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1a84:d:452e:d344:ffb:662b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7d1fdesm4824966a91.5.2025.10.26.03.02.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 26 Oct 2025 03:02:53 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: martin.lau@linux.dev,
	eddyz87@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jolsa@kernel.org,
	ziy@nvidia.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev,
	rdunlap@infradead.org,
	clm@meta.com,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v12 mm-new 04/10] mm: thp: decouple THP allocation between swap and page fault paths
Date: Sun, 26 Oct 2025 18:01:53 +0800
Message-Id: <20251026100159.6103-5-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20251026100159.6103-1-laoar.shao@gmail.com>
References: <20251026100159.6103-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fhk5m5sui6deh7jy3xiyqxtxn1atznxu
X-Rspamd-Queue-Id: 95EA1180010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761472975-738981
X-HE-Meta: U2FsdGVkX1/oLWNDpiI6cSDrOY0aEEAI1Q+gMZ5AEwzNnw0PVVh0v0j1lgotxPaxwEkOyD8fqhUY7oOnM2JYTBjCBkZh4XKE/yhXNf/iHBGad37fQLYkwYUzcqgEMDa5MxXf7aSsE/D1cOroS6WSmgatTf+RoZwDRDlaFqyY5c/jdMzizVMHzDn87spvSNAgaCk2hfmMYDwMbzcDIIIEUWtiQXShe+QMSrwa7iULTwR5Vc3rYfY2bvs4pm2Z6Bzm/VflUi6XVED3gzaGMUih8tTpMDX4r2f+51oI4RtvL0afT/1ZUbxPMrbYcIBcSbwtu8Yk4wa7y06YgHHeKlnSno8hBX9F/gQuRBjDChpE2Sl+miuZzJlKdZVDnEloWs6n6ckDweHrwIdMgcWoRNLExAF6HErN7Hy6/9F1wHKHAPUkslYVeKw+Mlap4UDTP0C2WNgREAU+YgRve/QHyaCjNFmMAhPHYHXUBTvz3M0HrazSj9EHepdg7jhNcFw2F7pDbMOSwOI3T2Gj2oUfdms/GoUCyIcO0QvVzLPUtoNXhq77XT8JkIRQdpnzNPzVLoHUZGivkU2rw03gI8QKdYmQkQMGohLE6XOm+n9kjKCKNQ56jLffslYyuRa2ZowIvbNdRRDvQSitXpMe87CC3QW2/M3XbLtQpt0fHv74FftOA8mknxe9X2T3ZyVgOTQ0lS5qADRmtJv0RVTzDTzyWVONVpxYrEclhCSgfkgMnW9IpHiPp8I+Nu7jvGnUVeC57jcCcK9TRkiOk7a9IKB3DCP6y+/Bfr78VVmXS9ZJiJZ2dJG3qRInYer5vboQPQOhc6rxB1x+iOb5TATQT7RHavjxD2OGs/7D3hlcug5VPoUfQwwRDSNklyvPbobEwurQvyHLe0vVKTLnF7j6zjNyZVlvFYDsYnlk0Tepi/BQfeHZdDPVobhDrj7HHr/UV1Yae4jYJzedozIH7qkU4VjMC2b
 IWuJvpeG
 dwc/I2q5AGhSzB9NSBBu2TaG67dyRRTr0pX7wjrrJw94ZoSRi3EIJm8l++PKyIqLPUGlEez+xtm8Lck+Lwa/hwdnsfyv1VLyfQ/dzshTTgDcjB2XeGqjmdn/rwHgydytr0kE3d+3HB9jvEBo1PD4caA/egFS3fCPT6YYo09dmqTlSHzmgqxvCrtEb7c6xPxuo5XffudPOKYZ3LZsZwmVjmEflfcTBN98xwrck+Y4pBBwVUCSoJaUcZAXNkSCQOHhmbC5/vEP8ZiNH9ch/ed+eusQcqyahARHy6S+trXq2n7jrAnJRGFi+0WkYoN/mFchUNfmu6WBKb9zo7I2r0EG6PwQKAV8Vs0Ue1RSjr17UOn10BsaMSBm3Lg9fcLEAcdVZT+2COpFjV49w0aOqCPCXq4eq8N5xoyoEFVl5ppSpO4UkhpnlaR+WhJmrs58AyvB2HknLT3AUVHSQQNEofP/XrRZE7OOm+A50YLz2wjmJUvcpSdGslt4Yg2SDrCcVMAbgpOW0oKPf/GaJE0aoxNhkLHq2uQFCzNhh5hjYBXU5zYNiVszxi4IJIBUsevtA/VAkJAxzwMGBz3Oaw6vAJuXqMOcxYXkY4yT6OCdZIjW7fRIekxLVi4T1M3wxRg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The new BPF capability enables finer-grained THP policy decisions by
introducing separate handling for swap faults versus normal page faults.

As highlighted by Barry:

  We’ve observed that swapping in large folios can lead to more
  swap thrashing for some workloads- e.g. kernel build. Consequently,
  some workloads might prefer swapping in smaller folios than those
  allocated by alloc_anon_folio().

While prtcl() could potentially be extended to leverage this new policy,
doing so would require modifications to the uAPI.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Cc: Barry Song <21cnbao@gmail.com>
---
 include/linux/huge_mm.h | 3 ++-
 mm/huge_memory.c        | 2 +-
 mm/memory.c             | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 49050455f793..7867411b2a21 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -96,9 +96,10 @@ extern struct kobj_attribute thpsize_shmem_enabled_attr;
 
 enum tva_type {
 	TVA_SMAPS,		/* Exposing "THPeligible:" in smaps. */
-	TVA_PAGEFAULT,		/* Serving a page fault. */
+	TVA_PAGEFAULT,		/* Serving a non-swap page fault. */
 	TVA_KHUGEPAGED,		/* Khugepaged collapse. */
 	TVA_FORCED_COLLAPSE,	/* Forced collapse (e.g. MADV_COLLAPSE). */
+	TVA_SWAP_PAGEFAULT,	/* serving a swap page fault. */
 };
 
 #define thp_vma_allowable_order(vma, type, order) \
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index db9a2a24d58c..0bfbb672a559 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -102,7 +102,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 unsigned long orders)
 {
 	const bool smaps = type == TVA_SMAPS;
-	const bool in_pf = type == TVA_PAGEFAULT;
+	const bool in_pf = (type == TVA_PAGEFAULT || type == TVA_SWAP_PAGEFAULT);
 	const bool forced_collapse = type == TVA_FORCED_COLLAPSE;
 	unsigned long supported_orders;
 	vm_flags_t vm_flags = vma->vm_flags;
diff --git a/mm/memory.c b/mm/memory.c
index 7b52068372d8..c6a766b271ef 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4558,7 +4558,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	 * Get a list of all the (large) orders below PMD_ORDER that are enabled
 	 * and suitable for swapping THP.
 	 */
-	orders = thp_vma_allowable_orders(vma, TVA_PAGEFAULT,
+	orders = thp_vma_allowable_orders(vma, TVA_SWAP_PAGEFAULT,
 					  BIT(PMD_ORDER) - 1);
 	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
 	orders = thp_swap_suitable_orders(swp_offset(entry),
-- 
2.47.3


