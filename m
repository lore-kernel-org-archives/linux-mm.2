Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 515D6CAC582
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 02:45:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADF698E001A; Tue,  9 Sep 2025 22:45:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB76F8E0016; Tue,  9 Sep 2025 22:45:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CD4D8E001A; Tue,  9 Sep 2025 22:45:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C2B08E0016
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:45:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5342411AC92
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:45:37 +0000 (UTC)
X-FDA: 83871799914.16.F1D61BA
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf06.hostedemail.com (Postfix) with ESMTP id 635FD180007
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:45:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="GdbJF9C/";
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757472335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ynOs6k0nDqBEUqYqBnSm01F3FVZyuHDqWUtbeZyhsAI=;
	b=ahArGE+Kc9Mo2c3MGwcl6BYvmc2nk5SXanRQMdBkp2S9lS5lYmbPLQzOUksvycXssqtToU
	ox3AVKpH3mcUT/bMbb1QPqEFQArQh3P6q7evyxbJ1JNp62YLDusiV8hb9p+7ED3s1uz7n7
	9QrSwPf5nuGj0azXW9FRw0WU79GALGI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="GdbJF9C/";
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757472335; a=rsa-sha256;
	cv=none;
	b=ex56du0e30TZ4SIQbBWiE71o4f9FICOcTEfA+jmz/C25eaaVDjoizlcCxHdj5de5giih1Y
	hAPfPJYhNHdEdHt4NA+NFIm1B002awohyJDSdLekrFVl5Ia6XAQdOkKe0noRS8p5b7z0Dp
	zut6VOUivlc/YoJi1d1jy2VCl39/SrM=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-32da4f36572so1102881a91.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 19:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757472334; x=1758077134; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ynOs6k0nDqBEUqYqBnSm01F3FVZyuHDqWUtbeZyhsAI=;
        b=GdbJF9C/iysvkIKiiUU1Xh38jcimVZVSUnM5g55ioJVcCQQlvnVgNSkYlwojFXlJiW
         /Cuk7QTxT8hQn1C+Es2dZTI49l+gBFWcMEBSHDJhiGi2+hMePgTTeSFdi65fxqDUB0La
         aDva5c08TD37qq1htdTab0s/KlWhTpU/sa73JoIn4qsSzdZWZF4PD/RYGqH5ewUdsir3
         cLwLzNspaUYzToBjvKM8kWZWHPiasDN6kQ/MlAeQ51ul4EPdi4wHs0R6AQulKGoR/nWl
         aLzMKpEbmNd/aSOlVnzu4FJ6woxz5l6BNl0WEvfliUAUsCQBx3rM63ybopPGCsC0j4P2
         APUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757472334; x=1758077134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ynOs6k0nDqBEUqYqBnSm01F3FVZyuHDqWUtbeZyhsAI=;
        b=nngg2i3/dNjML/YwpM907rkRhv3FETc8t/huaB8DPq47uzfCPb7NHlf6xei/FZXsD8
         g83yqkALCMDIGeU+lgVd1tNpXebsSbVqJlvbotUpO0n3l2XoX2NC0cYJOtJWxmmQ/bVL
         KI05x1agB+6iRNRK0FlVstVMLD9PVLoceSC6UgVf3VneayrB/c/G+0aOXD7fhaYReOhv
         bQPNroBlhpHU6aBu8WvT/zw3EVQ/K3TrXsc0vTed8jUnHLwik5NPoWWUxYTcyV2AidGM
         yOyGlNtXN4QfRD3Y3eNb57jO9Gf2H2AhbzicjYSlJ9zzrdQIgencwzw9TkUggVYVI9jd
         /Dog==
X-Forwarded-Encrypted: i=1; AJvYcCXB0sbjsdj6ZVAGUXFGTGABqwITRMThR8B9Dx/xzB4vWHJ0KOqj3JVtmrCpsfxNbDyB0UfcUGt8iw==@kvack.org
X-Gm-Message-State: AOJu0YyaLe3uQHZfGoxNywNaug51rIUAJphdPHhcOIlg367GbDtuPDms
	U0vTfD+oqywLoM/p7v3+PETcYdTtKgftFUK466UmfflX0SX3WKUHmtBA
X-Gm-Gg: ASbGncsqdIO/bOS2pCKLxu4ll1usDffGaoJdaUHTrFAf6lai6TU+wTIbGXTdhybetFs
	G66zSePbe7YXCantMhzCAfb7meYCg6xhhB0ySCjorbeYZXTRIuGNTsVVBA2g6YBIIsujEbn7g07
	wtCrWZ2pO33AD+sLLRojukQM1UrC16mOin4DRHngYSMNBOnEv817KB0rS+EBcGZ+j9l7IZYukcs
	ujLiGXlxH4AEyIZzqg/C9o3MioIBsiM84CPT2NfYx43nOVSi83gkpgK5isYFZ4KYzsInnWFLLHv
	4rz85NxWO3oTrGPe9BygfZ3Pysz8KkTvgWJb0PU8vORzfxJIdAPMV6lR21ITDrw45Mc0nH/Zxz1
	/NefZ713XjQeO8/N75ohBTcbpfFxopkxi+62HZ5w7THW/72ACevYhXF0w415TBwUBbLC/+G0JJL
	5d3Ywz4iPRD6obxA==
X-Google-Smtp-Source: AGHT+IG9wjHHm9F1qs6Hj5CY79GIA8nP9/1uv27gdyTOHKSsWrRfFyC/XUADgHH+wq4e30aKmqCKiw==
X-Received: by 2002:a17:90b:3f8c:b0:32b:be68:bb30 with SMTP id 98e67ed59e1d1-32d440d2749mr18927508a91.37.1757472334133;
        Tue, 09 Sep 2025 19:45:34 -0700 (PDT)
Received: from localhost.localdomain ([101.82.183.17])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dbb314bcesm635831a91.12.2025.09.09.19.45.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 09 Sep 2025 19:45:33 -0700 (PDT)
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
	shakeel.butt@linux.dev
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v7 mm-new 03/10] mm: thp: decouple THP allocation between swap and page fault paths
Date: Wed, 10 Sep 2025 10:44:40 +0800
Message-Id: <20250910024447.64788-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250910024447.64788-1-laoar.shao@gmail.com>
References: <20250910024447.64788-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 635FD180007
X-Stat-Signature: efo87i4jhrom6xwsqjjx8x5n71zgucep
X-HE-Tag: 1757472335-722607
X-HE-Meta: U2FsdGVkX19wbzoJ4WlpHT3RYYGeBKjWnP6U5Kpi40mzteEHSWOnL4OG8WKfigFJVwXNkHDbeu1mEGS4TPPlMLQecA1G2ebmIcslOf35+DqjAgq2/TF6cPjOfW+BsSdTLPxpOAMw1XovISVgDuu7rCcnkxzpX39nli3w1qViEy2NJYHCqNAsPPWS9l2zFBDRfQgWqXtlfTfqbzaHC6W6kJ+gWMNcPNAMpENXSkKOBIXp+kwzOqwgq5T6gahvAK2L05IItXCVFgMqmoZ56UUt3IMoLRXCYpU8g23m5I/mSsxOcZpGv8AwhZGVo7biqTuAnC6u5LiES0/qR8Kq6wlZI/Ur1dxvKIkW/VNiXI0+Gr4nKhG4aV0cmy+UdR5oK/jLSrd+4Ol5jMwFy3W776eCWbDwH2KTLFsYlE026Y6PNzzcRk8HHLLFKLGhsnCzmeFAb+rKt01qdxLiFrIZd6vZ3OlGjBhWxSuxVzWUfz1Y+/wsDoNin7+yiQt0OCTNGpiHjGz5ANXgSGxB0XrNgZ9x1DaZ88s/A5YpCTvcehOQJH0xk6lDVH9mGIPVy6yBmeXEnna+6h3YFWhyXqj6qOsUqnYsdS5BhF1dR+k754/KLNOjPhdFzJaxpMUcVST6qTJEl0v5/7Rh80nIXiDC3VsC0DjtdzQGuPjLbxG5ghdW7Un+Vrk/TA7bZfF2KiOXRoLSSy9OZwsswMgkEWRCWc6P7fp4hffcc8XZLF0vHoPTzsCDxu7ytPwHSQMpFgQKJ8UikLM0AXMYtqdUlYjvTRUVapKh9AcwHrgpL2vwfRiujGYuXO7JxZxVvzFm5Z6mn3zIeogdlFmd7MzxlVbo9QIXHE4WymJ45BJ+ecm/GjexZfK9hNO7yuj6k8ayEmBEoj4MJs5Xbw8EVALkANIvpzlr+p5OUFcyRoEfOK9gZTlIJ7BaV/ZIm20YA9IrBhzKatH2NGjC1ckxLSTMa8Ef++b
 mrYVLziO
 0UvzFeEVrPovb+7lgKExd9bMdnd0yw8Pl1V1aXlvKKI32GDBdai8//CupbRs4kYlDRZVeotGpnUhGopsLlyY9ZY2/DCWj46jXDLWDYoNdWfp/Bz2imTXMUxPOfjaHuC7rTFFJpcGpPCBLS5JX6C0WsCyDmh0umNjuO2qjRViV580HzfVU1FmM61QBlSALeO9OoXwLF8P/hf0RlPlzO5qbwgfUHWoQ8F0UO6fDC0j3SimfztnMfY0wx64Fg4mKoR/aVNpa+Vy1vR4QzHii6PVEDWlhq6YHIOHmPz94pW2fOWYyP3liMuIaAC3SZtY8PPcXhilFxzRV7XLxwjWeSznEebEpUGmGekpA68JCVG62PxP/nmYamfgnSONGVAVz2m5LviXlr9OsthAoUjd/0l58AfCRg7uSXnfGlVLzbOXaB13jdOBxz3FS7y11BLzlTE9khYwiqadj+NHV7+saPYHZoTCYLz7ZBayp3ZHuC/9HFIbMKkd7BYTfjmtEIBapX/5+JnsulQPQooCUCJVVeghSu1VamblSqL184oDRxHXkHD9rKnKOwvCw55KEwIr55xLaef3a3zxqrtmEn1k=
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
Cc: Barry Song <21cnbao@gmail.com>
---
 include/linux/huge_mm.h | 3 ++-
 mm/huge_memory.c        | 2 +-
 mm/memory.c             | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index f72a5fd04e4f..b9742453806f 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -97,9 +97,10 @@ extern struct kobj_attribute thpsize_shmem_enabled_attr;
 
 enum tva_type {
 	TVA_SMAPS,		/* Exposing "THPeligible:" in smaps. */
-	TVA_PAGEFAULT,		/* Serving a page fault. */
+	TVA_PAGEFAULT,		/* Serving a non-swap page fault. */
 	TVA_KHUGEPAGED,		/* Khugepaged collapse. */
 	TVA_FORCED_COLLAPSE,	/* Forced collapse (e.g. MADV_COLLAPSE). */
+	TVA_SWAP,		/* Serving a swap */
 };
 
 #define thp_vma_allowable_order(vma, vm_flags, type, order) \
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 26cedfcd7418..523153d21a41 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -103,7 +103,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 unsigned long orders)
 {
 	const bool smaps = type == TVA_SMAPS;
-	const bool in_pf = type == TVA_PAGEFAULT;
+	const bool in_pf = (type == TVA_PAGEFAULT || type == TVA_SWAP);
 	const bool forced_collapse = type == TVA_FORCED_COLLAPSE;
 	unsigned long supported_orders;
 
diff --git a/mm/memory.c b/mm/memory.c
index d9de6c056179..d8819cac7930 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4515,7 +4515,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	 * Get a list of all the (large) orders below PMD_ORDER that are enabled
 	 * and suitable for swapping THP.
 	 */
-	orders = thp_vma_allowable_orders(vma, vma->vm_flags, TVA_PAGEFAULT,
+	orders = thp_vma_allowable_orders(vma, vma->vm_flags, TVA_SWAP,
 					  BIT(PMD_ORDER) - 1);
 	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
 	orders = thp_swap_suitable_orders(swp_offset(entry),
-- 
2.47.3


