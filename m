Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D867CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:41:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 748188E0013; Mon, 15 Sep 2025 09:40:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F8A08E0001; Mon, 15 Sep 2025 09:40:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 598B58E0013; Mon, 15 Sep 2025 09:40:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 410848E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:40:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 03DD413B2C1
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:40:51 +0000 (UTC)
X-FDA: 83891595144.02.C3F825D
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf21.hostedemail.com (Postfix) with ESMTP id 095441C000A
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:40:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S2xjEoHY;
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757943650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/izOwppE0n2NGxkx7H9WLO0rOAXG+swxzYlRgFxl2qA=;
	b=ez/SjAhzLs9DJO+D08jLrdZ+LTSioxCpj4esGXoZME8Y7nRInzc1GcnG0HFWbeCLmia0/V
	K3k4soBMoLgQ0DjNe/UWC42icBlQ1W0FUJg2KWmTm0cep8Iho90vHfL2bR3WGG1VGYw+xE
	UlV9Me+qW7MHynixNXvOVCChaEj9EaQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S2xjEoHY;
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757943650; a=rsa-sha256;
	cv=none;
	b=qCgu+xZUZeaqKf7bP1teyxUib9D2BuWmo8D32fbK96OVQThMK7Xli2fEysgSzDi/xY/oj8
	h16/+jAHWtwEKyN5hIxaqa9THMau7nfmiFSs1yl9Bf3nsmvvP1YFX7IQbZsc7fFaaEaRwo
	q09BdAxYbeeJwT1iBsjbkW3YHao6RrY=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-55f6bb0a364so5397307e87.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757943648; x=1758548448; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/izOwppE0n2NGxkx7H9WLO0rOAXG+swxzYlRgFxl2qA=;
        b=S2xjEoHY15oMWfO2K+zIfn9WyxdRL6+q5NkE6tenUYZPLa6avUnTg1KRiOxuhx4AKc
         G2t2BWeIgeuWdR2WBNPjuOidh4K8K6LA1LKGLj+WDmGj7oX4TNyGXsoZQk4l+Vxbc1ng
         2eIj59kT6WdN9vxmq6kdu/F5qqgOmkjh9VSJdZwB9mMhjVeAUeSPCRb7i8KAWL9wEIGV
         JDBNBmlqtyHzHvKNn+sLAogLasgDqYdT4q0Vcjuy3sY3i2hde9m1XIbhdyWWQvGJ1bM+
         aS/pG2Wzxaw6oCWo1J6HwQepPOllf+q/U6W1iXIhIccmYwr/7a4X0gCQAPTe7fJl0fK4
         Z/vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757943648; x=1758548448;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/izOwppE0n2NGxkx7H9WLO0rOAXG+swxzYlRgFxl2qA=;
        b=cTGSaMndiPAkagjGSVbjX5H4S3HTiIK4EOlaHia7sTAQ1TSY3tFe5UnE3Okxjhz9Ai
         kms1se/aKBJDeYeyU5Fhxjlzzvgs7G+14HNtMfAgNl0EwgdjnvNUc8I4RqeCcOyMGHVr
         ChVQeaHTDLBvQId8cFVMF7Nr2FKSOVzmehlbmTwDY/fe4AGquoSE4TxEV47d76oQQe9B
         TX1e2vFTxsYOMic+tB1KW7l9Lk695jBnc+YLksdNP+m9Ix3cc3vu+NNYdewgcF/trRSt
         8zmQTXyRll1x/cdOPv0Ic0EywfdH3LZKo+wplF88aWJCsiITFIExfsv79hlB9cM5rUT0
         PSbQ==
X-Gm-Message-State: AOJu0YxlssDReVFgmdrcpo1vvWfUiknRsQobEsX/JvG/ZHhQkyxhja7y
	UuoT9XMNAYZwlP5qVIRAE/ewYMuOvsXy7O0DHyMp6rr4/u6VRIT2E53eggVSsw==
X-Gm-Gg: ASbGnctH62IY1EiZM+x6rPLMhGfhfvQ3x50Iy73jMet9SBSQxIioIYWlXskqI7YnRCg
	jKLr4aV3ywlp38O6egP5MQyqm/HruVV2aIruBHuzRL4mLhiTZn/HH0XkRPWjnybnchA0SVd9bGU
	8m5Uhlu/wJbM1iRlf0wdi3bis7lPLbKIQr6t4Is9n3NBIL21X5LL7t+vraTZLCLIVjUJR62Wejp
	CRPnDbqoBYIn9iIbriHP+XWLgplXBYkfrQovwcZAZglrKJPqQ9vEBu0ejfZ96AZEbsZuUSYpmqx
	in5yweIt9EEI+bof29VPl8fLKCXeVL+JPOU1UYvbnElUT+NKkyR4ALmVw6t5XU6l1eDBbiTPblb
	E1E9D8xDCRLIox9Bw
X-Google-Smtp-Source: AGHT+IENNg57J50ZrYXCeFafqm5XRGYYIfDpp9Jex3+zwIfjPbel+BSgSSthUwdFCiApyxIO38UV3w==
X-Received: by 2002:a05:6512:141c:b0:572:7e6e:d31a with SMTP id 2adb3069b0e04-5727e6ed4e0mr2026472e87.26.1757943648235;
        Mon, 15 Sep 2025 06:40:48 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-573c8330e54sm1150719e87.63.2025.09.15.06.40.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 06:40:47 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v2 06/10] mm/vmalloc: Handle non-blocking GFP in __vmalloc_area_node()
Date: Mon, 15 Sep 2025 15:40:36 +0200
Message-ID: <20250915134041.151462-7-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250915134041.151462-1-urezki@gmail.com>
References: <20250915134041.151462-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 095441C000A
X-Stat-Signature: jsrs7d9txwtgg1q55fhgm7c4tdanoyw3
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757943649-472159
X-HE-Meta: U2FsdGVkX19oqnMVSjPshVyAh2EYisxgeTzjXEQJvCJQKuWiKGlyHWPB/9lJzHKB+MABl5Au4jezM3cBPH/+rbNqlOsH2AnapJzvg39P9o4q0Y4Er2nLiQYYM1DfxC/GQ24kVxHZUQCqZa4jFAx7/WHtgKobXk13Ku89DZt8svbmCSFw61eOCLpoLLL/K8G8nLJuugiTgjnai7DZGu/W/HnK0UUclUpxBZn45zumc5GBGXkD5vYrJsi/OQJneXvkQe3cOHN0zdOcDh5OX0VLp6kMtH8KXzgJOa8/GGYHej37Qp3LZJxqGgaEyKLX7EYUm+G84gNyy9vEs0p8XiZPLrQIG5C1ZflZXY3adI0loqDpQJ0UEEYULK1ftPVijO/i/xahYTusmLvukpNA90rtmEEIqLlcHeck52RUSn/Caad7X5cXYpH/lccFOHWGj0SRqvxhgbHqegXoBC6/syRQTThGjKFBMluXTmWlyhzsc9MbviNjcn+SfSVkjdiRge+yn5UWZZudEsExhhBfxBqMdAhWmMd8sdv0jsLXMUAiDaVClglY6/Tv3hp9GMz/9SXh5jvowOjrsCs7lXvQuVzM3odX0V64hOasf57caSoIKNw+6UCX2MISKs6MLkAVo64O05j+c2W0EkvZa/0TojUjjgrxbhS/sQcmGaxb7kbPvq7Dk2Keq2DWRP0RugzjuH551fkfOkDFxQqKy8jWn8yCMU6K1Gl4WnNYQT5OZU4HBvaTxanKjgFGildqPA0w4FSrRAvn9F245b1aa+Pf2aLsUQUGhz+CVunZqLODB8QPfyxdeWG6ji5YRqh/TcVpiWMlHyTK5lQOltxWK3dljj5SwEJc0Xt2uSe4605PKJCBTWxPv1ix2l77BpzNY6kn1+HBe+8qw3dlgIA7bRcgtQJzPOAW8hJYFYlO2ZdoaQitIwsI+mAtod08NBVjaKjCN55NjF+aNizRUoWgr4mw0y1
 LVjaBVcH
 zRHMVx7YVKZ8QqSDU74G3GjNgswsMRENKd6JSPbo3OzMVmfBrr/BcsURInc3ZMY1bon3jjuh/dy3+HELpvTDq2dveGQi9vafWLzRO1BAt6sLhQfqFG+cj2QePR5KFIr4kCeDfw3+JuMGuXYeTLHSJjZuMGQ95rvRcKnZE1Q9dQDyiVDiuyABJEEUiNWkvmaW8/6kpXrSKDSJ9ass2tlkY6q6Xw4NLl6gCYrkLVyrRi1gV7VvSSQIzbHP+zo5md6bOyRo1WvcMqKPcYHjpGjixs+GSGS68tXcawldJ3mI0heLpPpjQCbYExJdMbDGQwJq8gx89oOtQ2xZ7gj6Xfj3OotaonD+CgrddhVWl9ug+cv8mhgpCIK184wq64J7mRarfP1ud5K6C1ytT7qM26QaicV1VCNuSn1JrVg7pRE/Bxr8ZgpU2yAK4CwQb6DNfmy6FbcBvx8ASMqLuh6auJSsWLhwhlSKGg9JodEANlfxfDk215Iw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make __vmalloc_area_node() respect non-blocking GFP masks such
as GFP_ATOMIC and GFP_NOWAIT.

- Add memalloc_apply_gfp_scope()/memalloc_restore_scope()
  helpers to apply a proper scope.
- Apply memalloc_apply_gfp_scope()/memalloc_restore_scope()
  around vmap_pages_range() for page table setup.
- Set "nofail" to false if a non-blocking mask is used, as
  they are mutually exclusive.

This is particularly important for page table allocations that
internally use GFP_PGTABLE_KERNEL, which may sleep unless such
scope restrictions are applied. For example:

<snip>
__pte_alloc_kernel()
  pte_alloc_one_kernel(&init_mm);
    pagetable_alloc_noprof(GFP_PGTABLE_KERNEL & ~__GFP_HIGHMEM, 0);
<snip>

Note: in most cases, PTE entries are established only up to the
level required by current vmap space usage, meaning the page tables
are typically fully populated during the mapping process.

Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 include/linux/vmalloc.h |  2 ++
 mm/vmalloc.c            | 52 +++++++++++++++++++++++++++++++++--------
 2 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 97252078a3dc..dcbcbfa842ae 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -326,4 +326,6 @@ bool vmalloc_dump_obj(void *object);
 static inline bool vmalloc_dump_obj(void *object) { return false; }
 #endif
 
+unsigned int memalloc_apply_gfp_scope(gfp_t gfp_mask);
+void memalloc_restore_scope(unsigned int flags);
 #endif /* _LINUX_VMALLOC_H */
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index e61e62872372..5e01c6ac4aca 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3715,6 +3715,42 @@ static void defer_vm_area_cleanup(struct vm_struct *area)
 		schedule_work(&cleanup_vm_area);
 }
 
+/*
+ * Page tables allocations ignore external GFP. Enforces it by
+ * the memalloc scope API. It is used by vmalloc internals and
+ * KASAN shadow population only.
+ *
+ * GFP to scope mapping:
+ *
+ * non-blocking (no __GFP_DIRECT_RECLAIM) - memalloc_noreclaim_save()
+ * GFP_NOFS - memalloc_nofs_save()
+ * GFP_NOIO - memalloc_noio_save()
+ *
+ * Returns a flag cookie to pair with restore.
+ */
+unsigned int
+memalloc_apply_gfp_scope(gfp_t gfp_mask)
+{
+	unsigned int flags = 0;
+
+	if (!gfpflags_allow_blocking(gfp_mask))
+		flags = memalloc_noreclaim_save();
+	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
+		flags = memalloc_nofs_save();
+	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
+		flags = memalloc_noio_save();
+
+	/* 0 - no scope applied. */
+	return flags;
+}
+
+void
+memalloc_restore_scope(unsigned int flags)
+{
+	if (flags)
+		memalloc_flags_restore(flags);
+}
+
 static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 				 pgprot_t prot, unsigned int page_shift,
 				 int node)
@@ -3731,6 +3767,10 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 
 	array_size = (unsigned long)nr_small_pages * sizeof(struct page *);
 
+	/* __GFP_NOFAIL and "noblock" flags are mutually exclusive. */
+	if (!gfpflags_allow_blocking(gfp_mask))
+		nofail = false;
+
 	if (!(gfp_mask & (GFP_DMA | GFP_DMA32)))
 		gfp_mask |= __GFP_HIGHMEM;
 
@@ -3796,22 +3836,14 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	 * page tables allocations ignore external gfp mask, enforce it
 	 * by the scope API
 	 */
-	if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
-		flags = memalloc_nofs_save();
-	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
-		flags = memalloc_noio_save();
-
+	flags = memalloc_apply_gfp_scope(gfp_mask);
 	do {
 		ret = vmap_pages_range(addr, addr + size, prot, area->pages,
 			page_shift);
 		if (nofail && (ret < 0))
 			schedule_timeout_uninterruptible(1);
 	} while (nofail && (ret < 0));
-
-	if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
-		memalloc_nofs_restore(flags);
-	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
-		memalloc_noio_restore(flags);
+	memalloc_restore_scope(flags);
 
 	if (ret < 0) {
 		warn_alloc(gfp_mask, NULL,
-- 
2.47.3


