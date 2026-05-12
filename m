Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C10FCD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:06:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B78B86B00AB; Tue, 12 May 2026 17:06:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4FF56B00AC; Tue, 12 May 2026 17:06:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A64EE6B00AD; Tue, 12 May 2026 17:06:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9231E6B00AB
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:06:19 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 512371205E2
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:06:19 +0000 (UTC)
X-FDA: 84760000878.15.7E490DB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2131440005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:06:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NTj9HX+Y;
	spf=pass (imf12.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778619977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+4kzhpMcne9QL/iUfytpcOnuwyhDfw3DKjMmXnNjefM=;
	b=2cPnZ3VoHomAlFDRuZb/BCAYE4UzhR1gI86b0I37Cut6E6tnf0lIVzWeu2Y5B4/1HhZiGd
	DpD8Ovnxb3dc7pVyKP6h9CCEQ2xXPIHEh8mFHNEHNP+EE+nUTglyLaD0VjPVx3r+H3i86t
	nstgbMteHymQF0LFEQRWgqvmMYhufao=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778619977; a=rsa-sha256;
	cv=none;
	b=dk2zZ8cD10+34dkDq1d59tjvxXt6HrC+lBbbUBQpaXwIdv61v2YzFq1le17Kc4QdZlysnA
	V7A6VORbnd31kGhAOWl50XAukcsB0XiQHOGQg5arcFPNhwGxVYAeLvsSGzogDxBDyFAtVt
	nUw0DbXHLHdHMVjaurfS2POpmP2wSQM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NTj9HX+Y;
	spf=pass (imf12.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778619976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+4kzhpMcne9QL/iUfytpcOnuwyhDfw3DKjMmXnNjefM=;
	b=NTj9HX+YRpTKgWI0xySDldgUpWwk0yHXiMtQROW9m6gBoWKVxxYv9Ur0jGDKyKHUxwtOxo
	mzmDopR4SYnGCsEsPEGAyPLzpE7hWHGlvaElDA/jIoSCtg1o4wbujShIHeojRrIv7En83+
	FgMAX5WHFdsaJZ7iRvCoqK17eu54uz4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-39-qciep_frNIGyLaZ6U7hbjw-1; Tue, 12 May 2026 17:06:13 -0400
X-MC-Unique: qciep_frNIGyLaZ6U7hbjw-1
X-Mimecast-MFC-AGG-ID: qciep_frNIGyLaZ6U7hbjw_1778619972
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48e89faa62eso11468195e9.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:06:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778619972; x=1779224772;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+4kzhpMcne9QL/iUfytpcOnuwyhDfw3DKjMmXnNjefM=;
        b=YEx68nlL++uJ4to7SIFCU5i4lPQmqcBYWPo1j4EWDJCdwtyoaFt2rL2AADu6X5EsFg
         XsCsfaVWvcNYRxRk6ZhXNuFFD7JIHoN6u3uJ0zWldJSFMVCZmQHnWLiLjRI5YiKCoeRM
         NHXz6yI9Gz7dy17f/UuXXgQ3b/IOls8cWWOrJG9QkS44V7RHV+tfsYgNBuoOjV318NJf
         n03QDKFOF8pYEx6/qqhklzy+1UIJKgl7BMgj8HUdKtI5beF0C3P2RF6ud6dJLlgChEfY
         j8JiKh7Pqf4SSWP5k7iDCwcP1wiZ/90xJ+wDtaFAbGbIUA9JYkR6k+BIDmQe1TxKS0Bb
         vEag==
X-Forwarded-Encrypted: i=1; AFNElJ/1GIVZeKvH6cWNAliTxTBeVhWt/5kI0cbUVrhqX9ItG96FK0OOd93vsJgP0Hc+0JqZbux9ywNbew==@kvack.org
X-Gm-Message-State: AOJu0YwQJyh0KUSJh2jL/GzQeEGek4Y2hl4K8bzIrSt8geTrIXT6M2GW
	g3Pk3bOxY+oStiNi+gACJwYHJLf/HZo35h10qE3adN49HBkCpONzibQ6AqduYmfDcRftAk4Ee+L
	C/N1dKls7QH5IedKQ5EU0fC3Fo6LcIv7vF6qt+QJUN5Gj9knyYsjx
X-Gm-Gg: Acq92OFSJvJwnJLNXA09ztIDgw2etBrjHtJORBQX44pKpeAgTjsuWub41rxMEE4fpuR
	fy0hs04HUimL06dn5WXlCUkFRVD3rvHzg3hAS6MFvYjuF6q6R+any67hsX4wDvQvv+VZRo/jGFi
	gBWF7R6QrOiJkp8FTpE2Dj8rIlrcFJ3kDCYTwvpmLI3L7mFuOYIzjEHF7UHRivJv1v7vc/Ewl/X
	bTiUM4EB4AegGqzylgRVKUewlI4oDzfyS/igm1ClB03Tx6W+vyFqZ2knAVDrtnfsnAQ80kqJM3K
	oE6RhRwuKupYbczsMSRoQiftVzbS53zXO1Cz3P2xdYPY598QddQ2PbErwJp6IKgskGaMP4GTKLk
	CUMvLMPfGVgJe268qMujzzWtQQasisN0sxPezg1AA
X-Received: by 2002:a05:600c:3f1b:b0:48a:6fd4:d3d4 with SMTP id 5b1f17b1804b1-48fc9a50d32mr5863225e9.29.1778619971843;
        Tue, 12 May 2026 14:06:11 -0700 (PDT)
X-Received: by 2002:a05:600c:3f1b:b0:48a:6fd4:d3d4 with SMTP id 5b1f17b1804b1-48fc9a50d32mr5862425e9.29.1778619971141;
        Tue, 12 May 2026 14:06:11 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548ec6c221sm36066581f8f.13.2026.05.12.14.06.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:06:10 -0700 (PDT)
Date: Tue, 12 May 2026 17:06:04 -0400
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
Subject: [PATCH v7 11/31] mm: remove arch vma_alloc_zeroed_movable_folio
 overrides
Message-ID: <7d637bcac4bb5705388136a75f0fdfe2881e5f20.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jxB987_cotKBOjkmA86Yqt-42GGCB6ft-SGs-OGcxe4_1778619972
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2131440005
X-Rspam-User: 
X-Stat-Signature: 4oo1dyhod8kaugf34woso1mgaagtdeia
X-HE-Tag: 1778619976-650813
X-HE-Meta: U2FsdGVkX19bo7jZ1cABB7RgLqwG+84IWCwi/EdSX/M+ZGQroWE7RSDd0E0rC3T9vHh9utNE81nONjTyqKhzCBdJHkCspe0qSigNLlC5Kko3dAnEyYd9SgYQ/pVx7Me2/S7zCQTkayocjqE7gDURU/8C35DE7CU00+HzpOGKtsw3U2+noox0hSwgJ10cVNhcurI0/ZV6atsJjE6w0tV8ynrWqza2QN9/kOYXYX4adif9vmqaWTQcef2jSZ8UYfufTBo3KJpICXvdaaBOmqyELSRgZePzYpgdsEpKY36kj7H75i0kJ1kMy/d2klFbdKTIvoye2dBPyHu/PSCw80z9lmDfcIQGCL9sOCYfQ4dctUY/jxk7jh8MK8wdeUdSauKdKZKy5npUAfPET39DCRyaqywa3AqML4L1ULrddv9n8nZz01tvViLXEdH4+RRTb61fsH0EAMsAJ/JQfEq84ycbwl2X0Ub+SfNqk6G8g0YtUmFuvn/zOsU+ChQU49B3BY2KOJ2gR2b3mk5KnxcfvYPMLAxFWxcpWXCfsZc3/uEfnD8gl1oacrv1kqkS1xUUnmX1teusFCGSY5S0aMWYa1HEZ7YMWaqvi2cs7VVHp6GqJUvVGYw2AvIf7y/AndG/l9ucPa5HDAOrY1GZ+YcZy+MANj1y/6Z2+O90lEiWDgN3OiQZbm5TZZp9jkO/VFBaPD3XRGb8eOQy44DGaOCFReU2t22YQDqFtsZOonGnEMi42glUrPlTe5Tgqf9gOX07n/UXU6Y4En3ZtPHvGDeJdZBOWXTWwyPGLPgcCg691R6DbbZLX06KjkmU0Isa72gbHZH8fZ11eyLfwjGKoosWLkS3g0ZPLIuVEj+YnnG8/280FNqeWaYhPFhJJ+cWtnzWRBZw2B5eKlqkcc1dm5GenREHLz3uKcaNOdMk8KsFjdQdwVGziETpu87oULhQdwYwk32uqbwgNviH9PGY6T3XEZ2
 dQhXmkXB
 9lMo8jSMeEEWBkZcNeaTzNhq6Pbv47kLsftw6X4+Bv6YuYQlImh4ESduT2DixhLYm7BoCFksRvdK5ZzIiN/vNVqTPrUblKIetBSEhMVF0PQWnOsrOlCx1LKMBBbRbolBElPZlP6aYeDWAHLySMf4NKSV6gKqNa3UWEv8Aa5zjiJlZcNYcbl/ykrLjqrCHp98UxSMIa9K1erWeVjr9HkFBe6+xyT4TA7+ffby6PIciTVU0S/lNWglQW5UOdCo2JJ/kHkXJ/ejsCZFFkuPztIEUrz9IOaY8FV9JK2ZG0NIEGwtddFwSyVBV9DBpRhdCVxREUQ9RntN9Q7UlyNmupfo/75zS7MGEuSG8Z00dxawsYVCqIF/6CrPP1DAhBFLWIhuR2b5PJzks0kNcovEDXI9pbHrBm2+vSFUfqPzu4+uPj9I5m9qBf+ja16C9Tu1V43b5wQHHaoiJ+LybvRBp4EnKtq04Jutl96XPhj67P6YdfcPB6v6MdCOh+Yit9KzbD1BwowKWNWxEYCyg6k0UDH2COLeKcPjvQZFessJB+gihuIdLrHM=
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
---
 arch/alpha/include/asm/page.h   | 3 ---
 arch/m68k/include/asm/page_no.h | 3 ---
 arch/s390/include/asm/page.h    | 3 ---
 arch/x86/include/asm/page.h     | 3 ---
 4 files changed, 12 deletions(-)

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
-- 
MST


