Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFB59CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:21:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20BB56B00AC; Wed, 20 May 2026 18:21:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E2ED6B00AE; Wed, 20 May 2026 18:21:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D1766B00AF; Wed, 20 May 2026 18:21:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ECF626B00AC
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:21:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AEC334043B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:21:51 +0000 (UTC)
X-FDA: 84789221622.16.8AD7FB9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 69985A0004
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:21:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ac3P9kZA;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yTMC7Vi3qz2eQrpu1XXxCoOuK0TKvwPfinMf53HH2Ps=;
	b=kpMvXRCsEYX9uGwmOlntjNVPjWEyXYPqOMsyF1fks2Crd84ajzttT/2I3JrcPXOo0rx6qu
	zu+nYIIw2J0h5n6Rp5dn3n16ay4GWXL8nG1FyCbdNowr8Z7s9w7IZZXYbXVYhK9R/3+j73
	ED7WwIb7Oimlzdrfz3Rz9QVp2oPXU0U=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ac3P9kZA;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315709; a=rsa-sha256;
	cv=none;
	b=42WKvmkwpAvW7F51s+NT4OVFJ39+VcawK4gNtKaoy7zmPwSXRgP/RFxNPR687doAWeb5Gb
	sVOLHSQ5qiXoteKWoyB3RupiV89nS0Ln5oIF6GbyU92MsEHyeQel/96ZvOpQ/ZbVrG16Cn
	LPdhIRGnrEgfBSqKY9AOMqBOypvBgeg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yTMC7Vi3qz2eQrpu1XXxCoOuK0TKvwPfinMf53HH2Ps=;
	b=ac3P9kZAYdPg3T8iCDdcDF0fIK6mXidCldOgbU+siL0zIjn1AnlBYySweUMgZ/4Fw/1Moy
	b9ke52rKwPxVIWP0qgNHyEss54S3t8EizjDWw1DzeUb1ReA3JmKzcBGvoR8sMQxebUEIaU
	j7R5XbP9HdjlARpZGDeTZMaM8JZDygk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-XVw_AMpOPg6pJGxbOGIKOg-1; Wed, 20 May 2026 18:21:47 -0400
X-MC-Unique: XVw_AMpOPg6pJGxbOGIKOg-1
X-Mimecast-MFC-AGG-ID: XVw_AMpOPg6pJGxbOGIKOg_1779315706
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48fd2b502e2so46572675e9.2
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:21:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315706; x=1779920506;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yTMC7Vi3qz2eQrpu1XXxCoOuK0TKvwPfinMf53HH2Ps=;
        b=Dp3WwsEpmvia9Q8iuSys4GsfsCj5pj3DhgYr91KNyVPRwjeLQ+X8ZFQYWqQuZFnxHt
         cwOwj5xCxz6fBx8eqAUOjMdLqZh3mCt6Q1ESHAo2XQ8OxNglTwEbYeDM2vJQJkWa+aOP
         wLZIx2s1KCEDBGvXdveB2wojtVXQdjxKQswbhnuxbK6coZJe1V2/pYpMSetfQUUZ3oDL
         WHroa4x5iNN3A+0BtK+jIfSKipM6dhdx6wIbZERil545AWwcCODYAtzU6SMQfmDg5D4L
         ZxOuz+d0/YAxtw4gDK+/N4na0FnDysIr9SM+DKDkw16hAIPQdT23ZEAGmcVGICJs7C8m
         w1dg==
X-Forwarded-Encrypted: i=1; AFNElJ+kzbmNxOIY0IDcxLpBatylPjkSHCwO5AGe9XmwwvinGJQDR9YuiesZOzhcOhcW9nGSnzsZX8Pq9w==@kvack.org
X-Gm-Message-State: AOJu0YzU6otjSRIx/VLrrwgS5UCbHvunktg65BGZh9KTlaZytdyn9KPv
	XhzBwGVNxrlzszw4Ra25BFLGzFJdNyEIR55gF2HyJDMkqa6j8ESFMakdF34lU9IoY3Z7NYtOF5z
	pSQBcc4B/8lrAKdaDi65WZypGwOOW5HuC2Eg/E4795Q7Av4wMfznI
X-Gm-Gg: Acq92OHfLQ4YRJMG8s9LfsElAT2XNVHyHYgOGhIkj3SLprG6vZbSa8BiZG508RaZYhm
	UqB8vzcwALg/jLC5Ypi58APqH2BHmS26GU4SweaUgdP1wuEgvV/yMyfu230UzlD5sGEcBRerzvX
	G9wevj80r244V2UAKm7zrelkIMszUHnFx5Qi5j3qdWOT3k9Yr39ITIsGy7xSgf+oZ9+glvVQLxh
	/+n03wacD3qF92SB8cggJWHCl+mkfjLe0Q7corJmKzF8I6ZE6ZXHRH6eeUfLo9SOJD7TV4oJLF+
	QeYmrCViU48Z1U8aaAxlTy0/lMujme/FWjzjDx3qtM/nFKi4yW+QJWZih/fIXaukqx3SQcNl8hl
	KblgiuHuy5zKXzX8Eo2cg0uBNzbkvAeJIHwHb4frRxjAeLF156GWllQ==
X-Received: by 2002:a05:600c:492f:b0:48f:dfe3:dae3 with SMTP id 5b1f17b1804b1-490360af200mr1567155e9.17.1779315706127;
        Wed, 20 May 2026 15:21:46 -0700 (PDT)
X-Received: by 2002:a05:600c:492f:b0:48f:dfe3:dae3 with SMTP id 5b1f17b1804b1-490360af200mr1566725e9.17.1779315705516;
        Wed, 20 May 2026 15:21:45 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49033d8e24bsm20846035e9.10.2026.05.20.15.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:21:44 -0700 (PDT)
Date: Wed, 20 May 2026 18:21:38 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Greg Ungerer <gerg@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, linux-alpha@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org, linux-s390@vger.kernel.org
Subject: [PATCH v8 14/37] mm: remove arch vma_alloc_zeroed_movable_folio
 overrides
Message-ID: <9c2ac9d2fc159822b9fd6cb1304bf222324d70a3.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QOUkl5aBAGdAPDWI8dINVxG9AhIMchi3FClQDrbV-_I_1779315706
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: hkd5bxsgm4dbxiprkei44s3rojnfd54b
X-Rspamd-Queue-Id: 69985A0004
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779315709-807545
X-HE-Meta: U2FsdGVkX1+JFTivP/78gVbn+fY5dnlXqofQ8Us8jq4IM0qfmvvPO+7SRIht+f1OwGk2jlMuFx0g7kZY9X5ag6vgGnwGwE+mEOV+L+W8G4lnoxikIUX2iX51eF9Dvpba4nxWOYlP4cUwEHXTNXe7Dt015ACtRq7IOKIxzSPjjIpu0aTmoIEMeTgldZYk2dLtxDCOenQQcXdxGKL58uWTWBv8YDcrpiREbnmfwWFgpczB5VL5zavMcQTXVhwoXL/ajfUwNMCn2hNvPoDzEKsJsHeo8Jt9LanCYgflMUaa5zAL7O3fgludHmkuXbc7oCSDtNKsZXZGZscz4J/5iykA9PNB1GSJvSDmDWsJPJjx+NVFCqodv+Qi2V/V5s8slSvrTLKw2uNRYJ3krioS9Rj+LIMWzPFwWGbfm/EfTkMxe0YLn+UUnkSqQjyRtkFTmuW3CNJJMVJc+89+ywF3KimdGPrOgQryxqBOMdhxEisuyv9W+vsysqtEkYSxLkK84bx3eEh4MqsU62JwMCdGayoCc/886Kw/6Sw2op7OokCqu0nDyFS3LJM5wQv1BvIGOvHsj50g4I725w91vGXZC7SSnEoePNz/t4d90o7iL7Sl98/UjDjXXFcpuP6sTJZWZ5gj5aVwg8TQfIgggv/tA+5/ZnUa09Pj8JHX6nsF8TNzzszN0P79NnbgvVB6xR2blDw6acQuRK+t737ZWKUyh8v17RULHnvBDEgRr7o2dr8pMZX2RjqDlqTo7LX0LHrxeS9xCg4gEQB24kRZIU0Rl2/GMmdZgHo5JM9VasEVArw/M9ftvh5wbP6BLBm6QzFVGe+t2l7S8e/5E4CPwXd+HtZXqJd+PcMhPeYLex5gIDsHVTPXoy722xDrhi3YSGitW4VQxx9DfVrb3j/O1+DzT6JWyW6+DK13jS70frSFcITvQHml1b6tK1SYq0F/Q/xZe9fNxl9ugv2n/7lQ8kow7m8
 yxGXET2Q
 Hlwk43fI3Phyi8wOtX8maMySJ6F3mC6qnuhYYHJjoqLwZbOI5D+/XxxpWBNh+ihRyin1OngCkhNpvwl/CSdkBOD0VzDRoNSZv1k/mDj5ZOROwlzROB+hDo9WLj7gjQUuMFdnMGP/ruAafM+RWY7lEz3gy6ViFqwAXM9YmwHXjKDfahbrfQ7d0urjRUWE7qheZEMwOM6kBY/6BLZCtM0+wYUHXVrOK5vopU6qyVgVI0MsyXJLbJTzAKg0vubwylu4E0yly5yBL3l9dzhK4SrqojW6uyVFaB2NKMF0gICz6WsdlQa8r7lEVUK/qhjqXMI1FwZGV7+ib2BJXWyuuMpaEJrQR2/rfjnmdL7WV5alBo6W2JzAPhg+DFATCIvTzBwjE0whXkD9tGAGz0wzgkvvluAqeaV1qWRiCISqB+8OHgClpX1YDpbvMcRgoaQkxukToicLBG5QjjsZO7UPP/DStqC31VDuRZppg7G+su4a+Cb34owh3j+sXkz80pahlH5Y0efBeMrdv3XtWKYrkHEH3+4vJXRTJYQoY3vaxDckQEjOMs/QV2SHcj5QzuCkouuOvsrZdwcz7/Gq325IyIrF/k59Y6sN2VvYStNdE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that the generic vma_alloc_zeroed_movable_folio() uses
__GFP_ZERO, the arch-specific macros on alpha, m68k, s390, and
x86 that did the same thing are redundant.  Remove them.

arm64 is not affected: it has a real function override that
handles MTE tag zeroing, not just __GFP_ZERO.

Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: Magnus Lindholm <linmag7@gmail.com>
Acked-by: Greg Ungerer <gerg@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Gregory Price <gourry@gourry.net>
---
 arch/alpha/include/asm/page.h   | 3 ---
 arch/m68k/include/asm/page_no.h | 3 ---
 arch/s390/include/asm/page.h    | 3 ---
 arch/x86/include/asm/page.h     | 3 ---
 include/linux/highmem.h         | 8 +++++---
 5 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/arch/alpha/include/asm/page.h b/arch/alpha/include/asm/page.h
index 59d01f9b77f6..4327029cd660 100644
--- a/arch/alpha/include/asm/page.h
+++ b/arch/alpha/include/asm/page.h
@@ -12,9 +12,6 @@
 
 extern void clear_page(void *page);
 
-#define vma_alloc_zeroed_movable_folio(vma, vaddr) \
-	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)
-
 extern void copy_page(void * _to, void * _from);
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
diff --git a/arch/m68k/include/asm/page_no.h b/arch/m68k/include/asm/page_no.h
index d2532bc407ef..f511b763a235 100644
--- a/arch/m68k/include/asm/page_no.h
+++ b/arch/m68k/include/asm/page_no.h
@@ -12,9 +12,6 @@ extern unsigned long memory_end;
 
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
-#define vma_alloc_zeroed_movable_folio(vma, vaddr) \
-	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)
-
 #define __pa(vaddr)		((unsigned long)(vaddr))
 #define __va(paddr)		((void *)((unsigned long)(paddr)))
 
diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
index 56da819a79e6..e995d2a413f9 100644
--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -67,9 +67,6 @@ static inline void copy_page(void *to, void *from)
 
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
-#define vma_alloc_zeroed_movable_folio(vma, vaddr) \
-	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)
-
 #ifdef CONFIG_STRICT_MM_TYPECHECKS
 #define STRICT_MM_TYPECHECKS
 #endif
diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 416dc88e35c1..92fa975b46f3 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -28,9 +28,6 @@ static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
 	copy_page(to, from);
 }
 
-#define vma_alloc_zeroed_movable_folio(vma, vaddr) \
-	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)
-
 #ifndef __pa
 #define __pa(x)		__phys_addr((unsigned long)(x))
 #endif
diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index ffa683f64f1d..7b5955bf9336 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -303,7 +303,6 @@ static inline void clear_user_highpages(struct page *page, unsigned long vaddr,
 #endif
 }
 
-#ifndef vma_alloc_zeroed_movable_folio
 /**
  * vma_alloc_zeroed_movable_folio - Allocate a zeroed page for a VMA.
  * @vma: The VMA the page is to be allocated for.
@@ -317,12 +316,15 @@ static inline void clear_user_highpages(struct page *page, unsigned long vaddr,
  * we are out of memory.
  */
 static inline
-struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
+struct folio *vma_alloc_zeroed_movable_folio_noprof(struct vm_area_struct *vma,
 				   unsigned long vaddr)
 {
-	return vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO,
+	return vma_alloc_folio_noprof(GFP_HIGHUSER_MOVABLE | __GFP_ZERO,
 			      0, vma, vaddr);
 }
+#ifndef vma_alloc_zeroed_movable_folio
+#define vma_alloc_zeroed_movable_folio(...) \
+	alloc_hooks(vma_alloc_zeroed_movable_folio_noprof(__VA_ARGS__))
 #endif
 
 static inline void clear_highpage(struct page *page)
-- 
MST


