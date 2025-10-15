Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11459CCD192
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 14:18:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B7FC8E003B; Wed, 15 Oct 2025 10:18:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6687C8E000A; Wed, 15 Oct 2025 10:18:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 557F78E003B; Wed, 15 Oct 2025 10:18:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D7438E000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 10:18:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C5E584EC8
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:18:08 +0000 (UTC)
X-FDA: 84000553056.29.C670CE1
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf09.hostedemail.com (Postfix) with ESMTP id 01BB2140012
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:18:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gsW870iS;
	spf=pass (imf09.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760537886; a=rsa-sha256;
	cv=none;
	b=F7KWxqCPvV1T5tVLtx6dKE0ku4raDp8Pa4MOx6ZqGtoEKRJ5vGuU7Rx8nMYw+ZBd2YWD5c
	5MUHf9HY6qhcrKy5Twr0TA5YDo2C2s5ET4tMEf9QOBQTA16SzI/njFh9f0ofEOgiXjbVkH
	bg1SzY2qVCQKK0WxcvXreOZsJJqRBgs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gsW870iS;
	spf=pass (imf09.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760537886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lnem9WQoa9CrDKPFqRiLEj1JeBs2tMhwu9umKx+yfco=;
	b=arYC6NHbYtT8waAc6S24RA2hCl/Olzx9IWuFNRGUeswS4ULmG+kWKn8B8JGv+QsV1CgfiT
	n8Ivooxpc0PPSW/S/XzxAMF4E3JkQ50Hzrwh5IPhUJsnC5W1V24wVft1yXxgsMQgc3ZDvo
	ZXwBqK3z/BHugtgUE+MIoGRM9kWs3QM=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-27d4d6b7ab5so89188855ad.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760537885; x=1761142685; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lnem9WQoa9CrDKPFqRiLEj1JeBs2tMhwu9umKx+yfco=;
        b=gsW870iSLMj7OMx9UROzvY3aIEp3ChDPWTHoYjKExEJil7SZ9ZBouTf90Ovzx4L2iR
         raDBq33S/5ajVFnpQJCw13E/nzkKqdZ6adCfXk4TP0RaPhc24FWIKXG6BdIw7mnEIIMG
         uIPbY5c9XoRAiUdR3aiU7lhVe44hpg3FW2dYAzQgS/iFfzrd9lwevvS1FL9XMoiwbsim
         wAb0kN8oaLdSkmX+XObMM5VedXlQZAaYBaSRIXRASsGr+aZtELFa+XDNK9bONz6vI6pO
         Ix675GunOhuSsQAVDyUnvZaLO3ZBuDToba6wWsSyFQATYPw02XANvtGMtBPVLY9PKbLT
         TsEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760537885; x=1761142685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lnem9WQoa9CrDKPFqRiLEj1JeBs2tMhwu9umKx+yfco=;
        b=Wf4rbmfHyN2GhCoxfUslauHCAZRQAEqy82NUjlexspr8Ms6m6muZRgMyFz0f5StUDn
         oVKvZ6TGiwFFffGq0trc32yH1vq64YJGDiKu65fnteT4TIDBcqPArNp2w50OUOxCsDtJ
         u+yoBC7vuJL1EfNqJqRz2nHHhMmb7dsnI0lFcffbYHWR9ja1GfWuP22JIMlv1jJTQpIP
         FTK5bkwOd8V67KiOD/vnKe03O+MkQTSTEagO9XkQaRHMgvv24mPc3reIiyL1/G1kE8Ri
         oqihFc2mTK3UMUX87mALs0tZXxaRKvJXx3efdA33yzAPnpFyyKFw8hm5kGvbpXL3Cq3+
         NUPg==
X-Forwarded-Encrypted: i=1; AJvYcCVmhpPgUz6hIjvSFqO0NNVvMs6Nv14QEOi5Wa0UsyYU4XoYQXzrZ8IozRJYuRqxvS+aWn+pEmF5Zg==@kvack.org
X-Gm-Message-State: AOJu0YwvCBeqJBkRPnbSr+S1nmh3PhDlZe+S0+rHSEJ6HpCZVNQUv+ZX
	SQLK3YwhYYm7M7jfOwGprDgktsP8cW0lZLIjyASHmY2C3sZzMK8MNvRALprl9B5p
X-Gm-Gg: ASbGncvZm3NrtdB0VvBJFauJWKRiD0AhT075zFy54yWZdad1ysugMvphv97C3+CZabD
	KDrdDeBVGYenVNJ/fU+oRXMh+Wb0R3+P/ph//A3oSR5WMtexMPXlaHXps/D5ZbvcHQpWtW3yk3/
	XY2vnc5Mozj9+RK9WfI3U7QBebjXKhcK+5Q23VxgW0z//qMciJ+62OXEvx+ATpyTPJMpcY85rlh
	OaF9Kg2p2Ho0tqdIXdRAxOFEEHyvmzCKV7H/79HbYG5uKwjrUcWqnaFK2YljRkIXMacW5lkaUlN
	O0E0FdBAIfboWbT0Ccf2xzfn+UlfpSuarWWCm5vIm+Y46UnNV96Ignz0Xm/K80LP9Wx22chWxS1
	Wh+XXRsrxJ2FMhknYFSiZK8ZEEFtm4reTIs8/rPseQDq9bpabGSfaK8j60r+Dg2OIEVJBq1aFES
	pe07Ch5Q==
X-Google-Smtp-Source: AGHT+IH94/LKl7eMp9XLhTF4MNSw5y/puAoaithR0MMgu0BDg3idBsTz0DwsyFW6zRb6V4pYAII+Og==
X-Received: by 2002:a17:902:e54f:b0:28d:18d3:46bc with SMTP id d9443c01a7336-2902723d619mr412289645ad.19.1760537884479;
        Wed, 15 Oct 2025 07:18:04 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1b80:80c6:cd21:3ff9:2bca:36d1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f32d6fsm199561445ad.96.2025.10.15.07.17.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Oct 2025 07:18:03 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev,
	rdunlap@infradead.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v10 mm-new 4/9] mm: thp: decouple THP allocation between swap and page fault paths
Date: Wed, 15 Oct 2025 22:17:11 +0800
Message-Id: <20251015141716.887-5-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20251015141716.887-1-laoar.shao@gmail.com>
References: <20251015141716.887-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: dcdasnsi44dopyzsf3649un6fwjac3qt
X-Rspamd-Queue-Id: 01BB2140012
X-Rspamd-Server: rspam09
X-HE-Tag: 1760537885-508190
X-HE-Meta: U2FsdGVkX1+B/cl4pKojZlUCFyK+m31KuBX+5Mr72n0Ze/LTqncL0szlz4JMSXieOBcWcFO4tQBTR9eXr+BdZsFNHzgbpK/8s8v5c35m2xx4AmZfuhvhZ6J+gnvYCFwkt7oXMVidFgbf6RxC73DohwqtjrpUnSAfLeAEjQ/1tFwrO6wjbMGnEe+E3Ou0VN3NCQA1iCFxeJBW8tzsn0Z61K4R9fJB5sLEl7Sz5okqjbX8fLme/VJFS7Ld0O+biudN9uv82IYoqw5SPiZbp27rJQgb3SF5WuixPpQmycBxJs0qlQ9qO+TmQBe/F+m8AksXQFHGh0P1R+qrb9yLWHIHU2NzY/pxI1llMohhFqhlmMdRPgSqrQ3tdCXosPEMck/xe0SLDP5ifzH/xoH5I90r8E0gHbxIcld+0pY3QyO5mLEafNJhTcXRGWCncfXMNO5BcskEArnsaRU6eAJFmskI0JiN/CXs3SoIUkQp22hePY9ywbgA6d/gyJVu9inbLPomXYXYJxAfM8ot+3n+oFvWRVaMkNfib3LgBK1OPs0L/RU/H6bCoyEFhe4q0PuI3ZzpfMbwRSdftCXFZXpMjt6w+dlmiK7BbhOe2U1BmHJNPbRh25jl5YSMekmY48OVCtqR3Q15tqGn5CGJ08u0xp3DBw+/WtI97/CJzL2F6EKi0Ym/uxTCIl6RXj/y1G/sWFPMLCho3vg0Dfdh3gliWF3Z7fCDjlpJbRaLXEAwYfgJ9TtI1Hds5iu3obTmvgogSlULmatEU25or0BxH5P3pEXt29PNI+aU8WcB/ldAsSxHbgsg4xTjcpKuT3bZig1UppWW5yaR04ZQ/liZeDB5xcS99hMY17P5stvNuhYcVw7nQQKA1NEstDkRgcw3rAzW060CAYRIv+kUliMRPk/GSjKJYsGPyVouaTKLlteBewllL6cZqF93/qDVkm8/M49J5u4wfTZBJy69mUrjYvVj8vB
 G1DqQBFY
 GD7w3aIHg9YBXwdjclMdc+IxS+Cl1vyoGqx5pCOTBsOwsFbchf1BYjrx1poXUgoE30PAHU7r0RsX2PobUn7P+LrKX30s5Tv40z7GmO4zcTD9ol+7IACPzZIHf/+0XQ3CvkJj0qEjHidINKBl0IAbVnFmnfNxpB8bYxupQzBPn+j1Du3MOV5ZlmtXZsROZ5DTmla7w+tO2aFVDxIJl+13P4uu76pgYxhQUwcp2Ac98ABt4AKDD0fazn+Ef1TMg2+cTFdn2lMGULrkZrYII3pryqXkMw5ue2ioLKS3kReM7SGIEyHVdqTPPS9L2ZXewe1OIuSenhkmwxWs7ItB7Vez9stEO4ExnuARxDcGJWYEdsjCcDFBbrXgRAHOSGCs6tKwK1ehSSgDhtxBp2AuMDVPsX+R3FH4HSv3EZjd7xmrZI+sa+nyncGvvwHhoLq/siximOvKdfogAv8jWSqbuCcJL09g0EbhOUduiSbQmSw06qogU7xbUIyhsYL8YULGTrHNvSJP/4yMmnB1VntUltEt4DfYLxdUdvHsiUqO/eOwhbe+IRzbp437BClygi75QUF7yJniEg6xNMJMYcHLBEsfx0IRZKUisSEgWf4w5zjsBdYNJch7T4puuyIXtVA==
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
index 5ecc95f35453..9e4088ae0a32 100644
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
index 1ac476fe6dc5..08372dfcb41a 100644
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
index cd04e4894725..58ea0f93f79e 100644
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


