Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 270D7CD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:23:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DE656B00DA; Fri, 29 May 2026 11:23:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B5B26B00DC; Fri, 29 May 2026 11:23:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A48C6B00DD; Fri, 29 May 2026 11:23:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 657336B00DA
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:23:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 384431C0520
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:23:27 +0000 (UTC)
X-FDA: 84820826454.12.7EBC90C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id EC3A540013
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:23:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dK1aQaXX;
	spf=pass (imf07.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068205; a=rsa-sha256;
	cv=none;
	b=Bd7hUQ9z06GY6tvERCtpHiYjuJezEx+13Lb2Kvm4fDudUcb9rT6arFfTsk4Q1VVCRXiWg3
	0L40E1HILU2Ejwk/8cdvByu1biMwRlnpR912nYFXc+cqFsbBP4dK/1FhLyZHMk6dA7h70m
	qtO8mvMXVhfgSPLmW1GQNLqD72i+w14=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dK1aQaXX;
	spf=pass (imf07.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yTMC7Vi3qz2eQrpu1XXxCoOuK0TKvwPfinMf53HH2Ps=;
	b=tcHys4bRWak9leo4o9NEdmByzRJTsaRWx2PCAFgD29jeiAS1NS+ZnxvhcFwLdMNvaxPfLw
	fVbJWpGbNUicXHTGx7nOx2SooYHZxzl4Wobyjh3UgNHFfEDg0DzfylYHqgmjOaoiWXRe5I
	j4+XTDjUp5Lbl6WYID7w6WvvVAI+jM0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068204;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yTMC7Vi3qz2eQrpu1XXxCoOuK0TKvwPfinMf53HH2Ps=;
	b=dK1aQaXXY0JHN4RWNfdQ7XY4BkKGITOeYoyRCWADUc9ezTd7k69HCpRBziJ2yQutO8zFKb
	tnYq9L+hrAU3tbOEl6KlaHlku4L7uP41oAkZ/7lQdM0mDoiQdHO7a1nGc+50+KQaO3/lGe
	9JTjgVfOS6zLKKaB7htJRbukbu9eJiA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-XlTLF5q2MKCmHAk_mMpvRQ-1; Fri, 29 May 2026 11:23:22 -0400
X-MC-Unique: XlTLF5q2MKCmHAk_mMpvRQ-1
X-Mimecast-MFC-AGG-ID: XlTLF5q2MKCmHAk_mMpvRQ_1780068201
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49050c44bcdso81717235e9.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:23:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068201; x=1780673001;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yTMC7Vi3qz2eQrpu1XXxCoOuK0TKvwPfinMf53HH2Ps=;
        b=YjqsxoB8iGQZerGuNwOOfWNZoHFEaYYx+WBspSjMBCPHDArbeUIkwNwSFdKDVZFwVV
         qtih//8OVTzgyBfMAYqiuAEMCqTneUBamUgbUsDTADXu9LV0v4HWE6jwmDNPSmWQFgbZ
         N1ZpUwF1s+FOmeIqwTc+P9ieNwbao95YbhZysZwscKZe4t/GdB40qrpB8wnEV/yMhCCv
         lYaS/dBiv2pd9hEXQ+xdChyGs/Z9NmEJ121sLU7oLXHfYi46DVxx6gilm7TLBZaXnX6m
         b5g+XFrRHSvMPexz5MPpHF8+SoAjvzIwaMfh5RsyEsl/ZLmwbxb+9tGI2MsiP9KOP1G6
         tY7w==
X-Forwarded-Encrypted: i=1; AFNElJ+iDEDtvVw7bXFJSbD+CJn+0npFpcQUul6F0FZTqz4oJtwylrzuQM5YGggvAtzw5w48XHUIsU3W1g==@kvack.org
X-Gm-Message-State: AOJu0Yx40yo8m4e6qBTJqgnH/2ctmRsJX4Wb1L0zYrRpYf2ZNPOgpveB
	TlHB5ypC9nMahADMVWl/wH04SDlKnhYxBfUQCHUDwAK5YpSMD9ZNDaMm/bSEwrhxbt3ajx/q//H
	Ko8hg4NV9be1W/rpZZB/V10EDBoxEY0RaeNyFozakE2Y6hCx2hiJG
X-Gm-Gg: Acq92OEwDatraKhSHANRPJ8D/kUYWJCf8WObl6GiSdZAua7pUvmuMFYva4XBIwhJ+Ij
	wTI0wWSUrgXdpfTndNGjn0mfQaGfD467ESOEG+hzJDBubpp0/LSIHMC7439I/bqLkZ653tKxTyY
	OAIFZBpDc+ML4PT5FEr1RIi6vIlL66u/IgAZhRJsZGLwyjKfSToJu3bKtqFGiNAqM1fN5gakbPC
	8AIFgul/BUz0PJhHxKnn3LFTE4RcEPbS9ZOzIQUGeuCkCF7Isr+cJrXiEGRraY7NjlgoHz9Ermr
	k4zpsnQg8BB7/mvNuUcmO+07joy14wGaXUQZ5Rty2NKlYASSNEYkE/znJ16PnWEVI8MNtIxh9XQ
	VvKuamgcLEARUhmseqhbQVEAiqRWFkiHTVs+GNE0VC7LHXUEUyOh20w==
X-Received: by 2002:a05:600c:4fc4:b0:490:6889:202 with SMTP id 5b1f17b1804b1-490a29639e6mr547295e9.29.1780068200697;
        Fri, 29 May 2026 08:23:20 -0700 (PDT)
X-Received: by 2002:a05:600c:4fc4:b0:490:6889:202 with SMTP id 5b1f17b1804b1-490a29639e6mr546645e9.29.1780068200009;
        Fri, 29 May 2026 08:23:20 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909d6f35f8sm40956085e9.13.2026.05.29.08.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:23:19 -0700 (PDT)
Date: Fri, 29 May 2026 11:23:13 -0400
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
Subject: [PATCH v9 14/37] mm: remove arch vma_alloc_zeroed_movable_folio
 overrides
Message-ID: <17905f527ee63479bd406efc228acf481a54b2d0.1780067977.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ArrPowxyKjCyTisYRyFc3mUoHxvXoKdNggyxFjV3M58_1780068201
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EC3A540013
X-Stat-Signature: psqpr669zb775uk3yy8grsaytshqzsja
X-HE-Tag: 1780068204-501831
X-HE-Meta: U2FsdGVkX191+LJYj5b9XIopuz7NxU32TtTOP1BLjOcOv4rQDYhU6HD/T002RjP1uD8fWpq9SJQpb3/ttuC7nQLm6E0ERiLJ1G0ueyLQmFkK1T7ZtxiYuuiCbmh7EzUUxlTyLw6tRX3jCx/ZlayKS2Vl2ShH2d+zo12Qi54zGLToGol8Y/5znFN8FyCcFSi6ZbsTTie1/4PuuhydRB00L3rLTEXZuuBwCKe3Put5ByKFKeRjpfzOnVO7UCrf8lyka+VUAWq+2bI40WITxGmR/vOIiQKitX7uMBJTmMokGlBzTp3CgZ1Jp0jqWiii+811xGmDXowVD4iyzo/KSjVKgjj6NRcNpEBvcOdpasyOloKVdO1rqDAuhZtFG6nMSHjiBD3xgROH2ljNM31f6WiVMXfAVdi/XXnDAuAfnj2qWvJHRLhzT+ZBabTcmzaQP+KNVMDRYmxZb3gHm+U5nFue8Z5b2H3wduT/9yWLc9Qs4nuXc06EmHEAOaFAp8/pgrb8LuOzqdUDr6upwuH3R6b8woTOwv5wtM6251/cuhb5gQYG/mRWuw2zbhlSF4S3chjA3McxNNS/me+Dc/o5XOXD0CtmEDEPUSn4ZJW2oszHdlQVj/SsPC0q7yDSTVMh3Z0dP/C61uAPHFCGBOgYxzZolJ/bfoxQJsS0SQNakPBzykFRlINRepi08ms9d1UO7xsWbdNWO6n/H8BEOcIAs1I7uD5PCddm8nylvnvmx10JsngMiP+C7mCrRzgfi8Tkwe1BExJ8VfQLwMkFXhmwH/aR5tDrXNyOWop8sC/eJIPTZCXEfBvyFd8UB93L1SHxKdolhodAk+Qi9EK8fRy+2JBqQn7By9YxKLXK08mxz2p0e7wFn2rGg7bOpeXqn01nH1RovSJLiuixL3yo9hNGzIYvCNrnYC50gVruwnDsPaSc1kYQ4OKJePFGpPEEbXzaC8lUSJOlXd3kjaIvRR6Dc+p
 3N074VPc
 aV2R/Wim8Ex61MTOKAVt/WzYFmOdDb6Ao1derVQpEGzJmV9cql50r1ulCfUa3JV0yBflXaX8REr+RwTAX1dHyXWf3oKpm4OkJ+qdmFkOirokPW4D+rXMoWbC5ZTrntgyf68kOLsAF1WNRoJNghYkhpRtyxmKskb2xvp5/y9h0R1CMOdX3HvpGtYcugAwv15/WQ5whtbhYO8vRCnhP45X6lQMQj8Xepr+iCdd0QHfpb3BdKTZ2xlxzzE+HtAMO4VM7mJj85aqCurnahyWpCHs/QD8bsDTGYfVwBgF7Q0fiDe4WvyFRt+QgKvfoTQWFene+OKsiYCUd0pCp6kM+AbMkNo1pPueOW2lRMohC675H7jVyyfrr51lr5VatHZcyRXOllF3fwwoMVD7NezfTsYFSZh0L92CBVJAI6NoroG/a34wocG9eInnbHN4Z5wPpTTN2jnBnpwIbgKtsyi3X2JR2kLMQBxDWKFbxoYBdNsutvAELRpOI4Izx6Z3NXh8KX4F3I+8PBuq4Luw38mZtO/EJ7C3OeidLof3Z6BU5dVnntbvQih3ls9k0FOuXXBUPjKqSoC7w8UPAiDr3n1+9YnnzoCKCADECpSlSq7KX
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


