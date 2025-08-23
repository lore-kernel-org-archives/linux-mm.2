Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92B2CCA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 23 Aug 2025 09:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 926D86B00BD; Sat, 23 Aug 2025 05:35:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D7636B00BE; Sat, 23 Aug 2025 05:35:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C5DF6B00C0; Sat, 23 Aug 2025 05:35:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A3CE6B00BD
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 05:35:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E3068118545
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 09:35:13 +0000 (UTC)
X-FDA: 83807513706.30.C3B486E
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf16.hostedemail.com (Postfix) with ESMTP id E8A90180005
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 09:35:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CxhthEcg;
	spf=pass (imf16.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755941712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A92qUKVVscD1iUAIIcRKA9oYRSCgvP30+tdPO7B2xVE=;
	b=VUpLLKABgIiF7SL4l3T5VDFsFe1mpmTjpKqz6agW7IAHO+gH7gfR+VFR6jshRNg0+BkPcZ
	WDgC4MdQg70hQvprbdyqczTBjMcWnALpZ9WuSi4F26bEk6NZk0iH6ylfIrTlSIDqa8IbWT
	Q7l2POr4ARM6vqun51HZBWzz96jfXe0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CxhthEcg;
	spf=pass (imf16.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755941712; a=rsa-sha256;
	cv=none;
	b=8SejMVPFYFXcnCmvNW5f9qo68ivn9K2p6J5pHbqCYXP5dI4pxRXmshuK36AsH+HPfugCMY
	Z7/J/XZSQ0WGHv5pGDl422HAkcjr76VIzsMg1VAF5Uak5Wecy8Yx2Ug03zVidZQiRemOIr
	C4NIL3jfcWKkE2RllRDJ0/7Mr7Zh0Lw=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-55f359b40cbso626712e87.0
        for <linux-mm@kvack.org>; Sat, 23 Aug 2025 02:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755941710; x=1756546510; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=A92qUKVVscD1iUAIIcRKA9oYRSCgvP30+tdPO7B2xVE=;
        b=CxhthEcgKYjEpV25M1Nj8Aa3dOt3UmOfXU2zw6XkFu45ZdBbA6iNMcrsQ+ej+a7irl
         7CnVrbLZiaBcC6TRqxE2Egr0mQXcTkAIvsaCfK0C6cwun8nbEW3KKY09/slkxLpK3Fk/
         xC4p8ZE1xTys+V1932bAnf/Q79B2BMxzpKfqtbcxGkj4kejZFOTgxsjRk10/YW3qsjVO
         YtBm5BuVr1zHeaPfUQfIAIuQ7YahuptjlAWadjM3qab4hp4J+htBTtz/ZUWbcxs52aUi
         MJVOAroIFKAX4yBxxqNwkclS78Ot/YHbuRQfTtmUxLXnGhZg6Y2L/sLFc1/rh9MUBeE2
         QDGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755941710; x=1756546510;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A92qUKVVscD1iUAIIcRKA9oYRSCgvP30+tdPO7B2xVE=;
        b=nT4qUX04a8TDkkFQ0GlPeWWe2wxagkkirqzBHCn0APFuMl0xCwMcpMVBETKe88FabA
         /tT4UiXQUWzGWu6LlhL2mDrPfIpvtcs1bkGuewiE+UmCtiimLobwxx/fl+a0vHWXcsy+
         ykLwWMrifwTuA07pmU7zaT4M/xeVe+epdC3ptgCxcyCTv07TxWUWNahUfGKS9gEIttc7
         cZYUSx3emtfOJyfKkN7tig4e7HbE3e8uTZZ1JDlTr+8+HAHlmdk2HI163IK9+dECJA0q
         yExADO2DNI1Ygghd0Aw1mkIHe59cFfRGMeFc12itOwXi4uHhGZd6My2KmFr6Q9uGk8j+
         w1Vg==
X-Forwarded-Encrypted: i=1; AJvYcCXnkE7bHHAt9oruXLEy2ElWTaPV6AQK0OdGioHbk383ui+ulhHs2gUq75WgCgnqPaWfpuWbzpae0Q==@kvack.org
X-Gm-Message-State: AOJu0YwNKmT+9HokVZMVbCYIxvEzV054v0NY4UlXSiRZcG+DiJmBpcpO
	WKo5QWJ8IEt4TuB5qECaJ7SxvblTbThb6vyII845nrUb+MduRpJA7Sfb
X-Gm-Gg: ASbGncugEaAjvpNLATPu19Db5yTRsJNJkxG08Ovjl+waRd02VXMNNuYUDvtVz2C4/kJ
	DHyl0Dqlrk/kVlYT2WmRw5pemFqUOqj54yB9dSm5K9p5hapI5BZ8n6aToqhXhByeJH5E5ZgfP6U
	VYU0qfji+A1V9DXNa2HjBuKtYjxrGJkSbI1oN9ULStHv5YkbGHZ3LcZ7uemuC/l2v0ZLIIgKkWW
	eHNVSKbF/qPoDFiFB3LRFgKg/lau+8LJ4C++OlOMQacJ7TRhO3dOTUuGNAWWTbZ0ZPAw2mgxoKR
	nid0SbhDnAVOAEi4VkzHiEr25y9F41JmvN0Qndl+M38AlkUm/rXIEgfZ06OpGIWu
X-Google-Smtp-Source: AGHT+IEKI+WFby0u8zrSUkWE+Z6THT2SoEAd6rk+RgsOklByaudVol34fQCDN7e3412nflAMA9MT2g==
X-Received: by 2002:a05:6512:4048:20b0:55f:34e8:b1b8 with SMTP id 2adb3069b0e04-55f34e8ca2fmr503948e87.55.1755941709652;
        Sat, 23 Aug 2025 02:35:09 -0700 (PDT)
Received: from pc636 ([2001:9b1:d5a0:a500::800])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55f35c9a0bbsm402584e87.121.2025.08.23.02.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Aug 2025 02:35:09 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Sat, 23 Aug 2025 11:35:07 +0200
To: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	Alexander Potapenko <glider@google.com>, kasan-dev@googlegroups.com
Subject: Re: [PATCH 0/8] __vmalloc() and no-block support
Message-ID: <aKmLS0sLG5-ILTGR@pc636>
References: <20250807075810.358714-1-urezki@gmail.com>
 <aJSHbFviIiB2oN5G@elver.google.com>
 <aJW520nQ78NrhXWX@pc636>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJW520nQ78NrhXWX@pc636>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E8A90180005
X-Stat-Signature: f9jnagrueork11o5qg5a4qdzrrkwh1w5
X-Rspam-User: 
X-HE-Tag: 1755941711-442424
X-HE-Meta: U2FsdGVkX1/QzteQRVxkP6zTGA8q9+V5ZMjMxY8WsaCuN49UjigLngqMnyfRSLqUD8TgppXzt/jY6dRJkTH2Ic0vOBWkgNp2RPXNvmzXkoT2D7GS0/oyn+E3jPAbrjywkFi+hoDw2c+0WzUP8jusMjVmIjgAGredjOrIDf9devqraDdvkOeoVmJeSdYVVSN3SOQAvUC+HgnUSmNGrdj6qV6D4rZ1rdlaP4Z+STgesKCRWV0aOKfhvu9U3x+sp8MKVlAYXQ6bxwwqA/EtNDlL3ArmnVOfmsl/B6++PqsIp2AvhlKmgW3BRzJvGcGUWlA8g1PflEDjTq7LWu3Bva33r7KsaV6GNiN0KHw2emffXxsOmd0iGxU3N1iTfbcYzM3f5AB2We2a+6KL6ZAPs6hkjjm3JgRcEUuptbkom0DdvGi/TJlE4/RpGfscYHJnMZj0RC4b++IWtyETrzOfgJJu/xAEA5D/MVMPltO6syo9JJW2E4jVdKrpjMCwOoWKSr14fLiqlc5ivC1hqrsPBDLUUII7Bbl/cTmr7MGqhc16qJrjK/HqCmNSSvHppt5qQ2eeMEXBe5tsp7F17fOC3hZQgNerENe8Cop+MqdQqtThRmW/idFI9S0VzrMXsTody8O/TTtvU20KAO20ru1nLQc0d/w2qKdBjFW6vkwkUEZmZhxKUnhXCDufF8bSS0E6Udsmt5YFvYCOkRiCw6xNoZNou/PcXO1tfcwVXFvkzcKbmNF7hn0x9ZZy8Vhpy8qVFxE0h3ZGh7CD9dQ44cskj9/7fwLI6AHWkemU2IywKD69ou3e5Xr5b/28jDFTdTWFmqeitR5KIOuiyxYdzJiOQka8ryQiwAp7p2bkq7J40W4j6DE6y55b0KUN5JBhACEf3sBWIqZDohEj0mBeATuv7ycLff9j0j1YpNK8fYpUny+K7eUrNYd4OSOnwzrAWi2a1utz0VXn0jYlXvlCX/XJ9CJ
 /g6Qw4WY
 8NtEsvglgfZE/JmwVYSv4+mx/VMbYNawoUr07FD+3tvJhNMTShmpjz8f39no4jnpbcKFx4O1sMpHQzd9rDvt9U4smpMP6qpcutYWP4c2fHizVA57UtmW/rmAb9dq8MeTjxmhAU6LmtKMUe0SLawba5bW8NwhBXSFo8Atw4jd1t8USEr6OolVM6mDix/logRXoELmINA9XJ5t4ReO/EujiYaZaIeIoIZyj/gMOKz8oYY/zNm7/QRdUWNlVasSJ3Np9CFiOmxMH+swdt2gb8nQTQbFkRQENtCXa4KT1BjfURkDdezwpukI1fLYVQsLZHmg4q5LAzdNYUs4nvyGYvg5UQhsu0GnZtvGlxJGI+lqIRSf1TJpoGbTI0SUVE1WTpna8W98l7bjrrGS1G6SyIJoudHvcrpAFQek0YiqU/u0JGQMTmoKhJfol0M3RJayprZHyD+O+fzYI3zg98PxNTag2LrdtzV60uJbJlqwJyQLpxcGncmztOsuMu9WEeLg62VBwO2YxrF2mW6r0sIj8rlwlaOpiUIfxR78qQff5xzHft/Hw53S/s1AEPw1Ktw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Alexander!

I am working on making vmalloc to support extra non-blocking flags.
Currently i see one more place that i need to address:

kmsan_vmap_pages_range_noflush() function which uses hard-coded GFP_KERNEL
flags for allocation of two arrays for its internal use only.

I have a question to you, can we just get rid of those two allocations?
It is the easiest way, if possible. Otherwise i can add "gfp_t gfp_mask"
extra parameter and pass there a corresponding gfp_mask flag. See below:

<snip>
diff --git a/include/linux/kmsan.h b/include/linux/kmsan.h
index 2b1432cc16d5..e4b34e7a3b11 100644
--- a/include/linux/kmsan.h
+++ b/include/linux/kmsan.h
@@ -133,6 +133,7 @@ void kmsan_kfree_large(const void *ptr);
  * @prot:      page protection flags used for vmap.
  * @pages:     array of pages.
  * @page_shift:        page_shift passed to vmap_range_noflush().
+ * @gfp_mask:  gfp_mask to use internally.
  *
  * KMSAN maps shadow and origin pages of @pages into contiguous ranges in
  * vmalloc metadata address range. Returns 0 on success, callers must check
@@ -142,7 +143,8 @@ int __must_check kmsan_vmap_pages_range_noflush(unsigned long start,
                                                unsigned long end,
                                                pgprot_t prot,
                                                struct page **pages,
-                                               unsigned int page_shift);
+                                               unsigned int page_shift,
+                                               gfp_t gfp_mask);

 /**
  * kmsan_vunmap_kernel_range_noflush() - Notify KMSAN about a vunmap.
@@ -348,7 +350,7 @@ static inline void kmsan_kfree_large(const void *ptr)

 static inline int __must_check kmsan_vmap_pages_range_noflush(
        unsigned long start, unsigned long end, pgprot_t prot,
-       struct page **pages, unsigned int page_shift)
+       struct page **pages, unsigned int page_shift, gfp_t gfp_mask)
 {
        return 0;
 }
diff --git a/mm/internal.h b/mm/internal.h
index 45b725c3dc03..6a13b8ee1e6c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1359,7 +1359,7 @@ size_t splice_folio_into_pipe(struct pipe_inode_info *pipe,
 #ifdef CONFIG_MMU
 void __init vmalloc_init(void);
 int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
-                pgprot_t prot, struct page **pages, unsigned int page_shift);
+               pgprot_t prot, struct page **pages, unsigned int page_shift, gfp_t gfp_mask);
 unsigned int get_vm_area_page_order(struct vm_struct *vm);
 #else
 static inline void vmalloc_init(void)
@@ -1368,7 +1368,7 @@ static inline void vmalloc_init(void)

 static inline
 int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
-                pgprot_t prot, struct page **pages, unsigned int page_shift)
+               pgprot_t prot, struct page **pages, unsigned int page_shift, gfp_t gfp_mask)
 {
        return -EINVAL;
 }
diff --git a/mm/kmsan/init.c b/mm/kmsan/init.c
index b14ce3417e65..5b74d6dbf0b8 100644
--- a/mm/kmsan/init.c
+++ b/mm/kmsan/init.c
@@ -233,5 +233,6 @@ void __init kmsan_init_runtime(void)
        kmsan_memblock_discard();
        pr_info("Starting KernelMemorySanitizer\n");
        pr_info("ATTENTION: KMSAN is a debugging tool! Do not use it on production machines!\n");
-       kmsan_enabled = true;
+       /* kmsan_enabled = true; */
+       kmsan_enabled = false;
 }
diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
index 54f3c3c962f0..3cd733663100 100644
--- a/mm/kmsan/shadow.c
+++ b/mm/kmsan/shadow.c
@@ -215,7 +215,7 @@ void kmsan_free_page(struct page *page, unsigned int order)

 int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
                                   pgprot_t prot, struct page **pages,
-                                  unsigned int page_shift)
+                                  unsigned int page_shift, gfp_t gfp_mask)
 {
        unsigned long shadow_start, origin_start, shadow_end, origin_end;
        struct page **s_pages, **o_pages;
@@ -230,8 +230,8 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
                return 0;

        nr = (end - start) / PAGE_SIZE;
-       s_pages = kcalloc(nr, sizeof(*s_pages), GFP_KERNEL);
-       o_pages = kcalloc(nr, sizeof(*o_pages), GFP_KERNEL);
+       s_pages = kcalloc(nr, sizeof(*s_pages), gfp_mask);
+       o_pages = kcalloc(nr, sizeof(*o_pages), gfp_mask);
        if (!s_pages || !o_pages) {
                err = -ENOMEM;
                goto ret;
diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index cd69caf6aa8d..4f5937090590 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -194,7 +194,7 @@ static int __pcpu_map_pages(unsigned long addr, struct page **pages,
                            int nr_pages)
 {
        return vmap_pages_range_noflush(addr, addr + (nr_pages << PAGE_SHIFT),
-                                       PAGE_KERNEL, pages, PAGE_SHIFT);
+                       PAGE_KERNEL, pages, PAGE_SHIFT, GFP_KERNEL);
 }

 /**
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ee197f5b8cf0..9be01dcca690 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -671,16 +671,28 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 }

 int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
-               pgprot_t prot, struct page **pages, unsigned int page_shift)
+               pgprot_t prot, struct page **pages, unsigned int page_shift,
+               gfp_t gfp_mask)
 {
        int ret = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
-                                                page_shift);
+                                               page_shift, gfp_mask);

        if (ret)
                return ret;
        return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
 }

+static int __vmap_pages_range(unsigned long addr, unsigned long end,
+               pgprot_t prot, struct page **pages, unsigned int page_shift,
+               gfp_t gfp_mask)
+{
+       int err;
+
+       err = vmap_pages_range_noflush(addr, end, prot, pages, page_shift, gfp_mask);
+       flush_cache_vmap(addr, end);
+       return err;
+}
+
 /**
  * vmap_pages_range - map pages to a kernel virtual address
  * @addr: start of the VM area to map
@@ -696,11 +708,7 @@ int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 int vmap_pages_range(unsigned long addr, unsigned long end,
                pgprot_t prot, struct page **pages, unsigned int page_shift)
 {
-       int err;
-
-       err = vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
-       flush_cache_vmap(addr, end);
-       return err;
+       return __vmap_pages_range(addr, end, prot, pages, page_shift, GFP_KERNEL);
 }

 static int check_sparse_vm_area(struct vm_struct *area, unsigned long start,
@@ -3804,8 +3812,8 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
                flags = memalloc_noio_save();

        do {
-               ret = vmap_pages_range(addr, addr + size, prot, area->pages,
-                       page_shift);
+               ret = __vmap_pages_range(addr, addr + size, prot, area->pages,
+                               page_shift, gfp_mask);
                if (nofail && (ret < 0))
                        schedule_timeout_uninterruptible(1);
        } while (nofail && (ret < 0));
<snip>

Thanks!

--
Uladzislau Rezki

