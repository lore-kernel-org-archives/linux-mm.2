Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49CB8CD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:37:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B57E46B0092; Mon,  8 Jun 2026 04:37:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B08346B0098; Mon,  8 Jun 2026 04:37:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CF7B6B00AE; Mon,  8 Jun 2026 04:37:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8706E6B0092
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:37:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 48E0593205
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:37:31 +0000 (UTC)
X-FDA: 84856091502.19.950ABDB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 04AD216000B
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:37:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C4mYpJ4h;
	spf=pass (imf08.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tltobG27QNK6CnGoNCrb5i/6pgzOGIIyEcQIJDK7QRA=;
	b=jyeW9B6oszLfwQ3LMrfq6k4u+MGhtwvEK8h09W91ew56DxH+dpNDdxjwluMZrV9llxszYx
	N7SN7/puhICr77T4zEjcRNbz/Eam1ErS4jS+jamSKzoSIoROII1FyvWZQ0t0Wk/uJl4fiL
	pnhOtoppPXcgJ0kpPimlffscnaKhn4Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C4mYpJ4h;
	spf=pass (imf08.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907849;
	b=uPAxrECU0cunYM2SqH0wN03flr+Wc6jXrDkfEJ856qRhwRMXEGBhBH0Qr7dLuZD/gBHjov
	AOd/vLD2e19dBUYtBWZioJDtkaWZrt4Cghilvc4v7CrH+tibnk3SkC3Pn063eSZFzk4oib
	3Ujr/kK8y2NwFHyelem/53rZHbcY0Pw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780907848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tltobG27QNK6CnGoNCrb5i/6pgzOGIIyEcQIJDK7QRA=;
	b=C4mYpJ4heQzCYvdeu/nEgxW+X1RzKSmckIqC2soB/fOjfu/8+oRTRNBtZ0IpwdetPkq6DM
	LfUNk7hy7WxU/I0I3V3ctAE0oqIuiGj2GnMH6KyDMyjmARoAbX6nhc57fJJBNyzFQy0yFN
	Kaj76xu8M4bYornHny05vuDyOXX82Lc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-494-GMYIRgJDNAmF_O-TI8_joA-1; Mon, 08 Jun 2026 04:37:27 -0400
X-MC-Unique: GMYIRgJDNAmF_O-TI8_joA-1
X-Mimecast-MFC-AGG-ID: GMYIRgJDNAmF_O-TI8_joA_1780907846
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-490b37e1f47so36107825e9.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:37:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907846; x=1781512646;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tltobG27QNK6CnGoNCrb5i/6pgzOGIIyEcQIJDK7QRA=;
        b=F4lyqo2LDLCw9pPwuHDhC1/buAWK1OQhXMIzy2AhvlvfFYOzxp2c3MWnt4AtHFSKpW
         PUOvuPJRJr3f9Xls9QSsbNFrEaj4GQvr+qKTMm0U0MJyH/cVKx785+3l/sbJz45C/4s6
         mv8pmUOpuLsQo0DQ4O4qCNcSZcUnhTuoYXUsTFzr4eBieEAYKLp2E5cguyI/wJwhVxGf
         2pxixOa4hl6x7qfeHuuq2gFvRbO25KQga7Bh3Fn8v3AuA1UfIJ6SRc9OqAgzfODRtdfP
         Hxt/wfTN0a1tsbVk4SRdXbhGuubSJSsF7peuGhUg7J1OfbD1SXUMsNT4UuCgVon93Wto
         B9ow==
X-Forwarded-Encrypted: i=1; AFNElJ+o7O0a2zX8qDW4kiYE5Gy8A9OFNUvXSTYGwI4aoYkvoaIiMfwNG/wNyzjiC0M5zefgGYgZAntLIw==@kvack.org
X-Gm-Message-State: AOJu0YzHVJubGUuDp2Dfy/gDSQhoiiNqIi3bxnZ1Cz3hTlWR85POnkwR
	+9nM2Czfg4yDQo+GMWHKOqKToRJDhwzepGiFZoznoNgSgtVv/3KbgUQjJ9N9ALgYmF+W0gL/ABK
	NOYjRH8EAkNuYfsjp/jeLlt71q//4Rn6fKbwtwAhyWIbM8N8Ta6JZ
X-Gm-Gg: Acq92OEw5WKl/rR5gBgjT8bq7kUiNRBB121/Cq+OAzzvj/v4hXVHUwEb5i+gDphTlRZ
	8qmvDn1GcxV5I1TiXjGCkdYaUC07ZIALFcaQt70eTac/4HrOYvcWoxkEAGAofvQI518tUp+iw8G
	F2E3njgupi+9SgoIJNKW7nKe7u33btrP5YEnJwbSNTNKBGL94oIIxGn3NO1aBNub2/W77hm0a/n
	AD3L/StK6cr2l8I2YhhB8AOT/mtvpMfgvheWLaC8911tsyBe6rb3Btu2UDHAWb1NSv5xDuBaHTY
	qwXC1mtlHt8Gvnf9EdQQYDOC+/9qbpY2MxreK8NC2EtMywxE3ovrphe8pMebfwFh0bzib9AxBzs
	J1OscsVF40S9UtnoEP5SkhRU=
X-Received: by 2002:a05:600c:4fc6:b0:48f:f7cc:f6f5 with SMTP id 5b1f17b1804b1-490c2614167mr244773255e9.31.1780907845692;
        Mon, 08 Jun 2026 01:37:25 -0700 (PDT)
X-Received: by 2002:a05:600c:4fc6:b0:48f:f7cc:f6f5 with SMTP id 5b1f17b1804b1-490c2614167mr244772255e9.31.1780907845077;
        Mon, 08 Jun 2026 01:37:25 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3e5a00sm375786835e9.15.2026.06.08.01.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:37:24 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:37:08 -0400
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
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v10 14/37] mm: remove arch vma_alloc_zeroed_movable_folio
 overrides
Message-ID: <c374d7a35a35eb4bd5ed85f87ff6885fae605fa9.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: l6R1ZlsME1VPpOjswqgHuLRYAtV1pRjBkS_Tr3QKrCE_1780907846
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 04AD216000B
X-Stat-Signature: tmd8c678cr6yti7uumi99bjajef94h57
X-Rspam-User: 
X-HE-Tag: 1780907848-541097
X-HE-Meta: U2FsdGVkX189STx0jiGxKC30xsnUN9y+7ykMy5wU+leY6XAIaFeMd+lb/hvhyYN7IDeFAmVzBFfRkR+ohlIeypDOEljDfiGNMA3hFAKifGocaJq0eh2Z3d+5PhRAX1Je+ZCbdsmr1lS6snMr70fafSDBytPNllu3kv1vQdtAHWYDWUbeYv5bkvMCJJwTEVQih+ItCX6G7ZI+QM0dzZT3endr5eCv8wWOvIB1P10ODvf3qcg6mLaCTZspGFSHA1BAeNjT4sjQXNgl3SPktbHLBW+gXpMJIy2wCGA22VrlO6M7f8NsdxDsYvYkwS0t4/fsQ7ePj/DETjWFDVpbjKTxO3bqBGh0x44Osd1xeIsR6UJlGR6reEe+t5PpN4P/NAqQvfqTFESsNSLBukOUkY15nXYjth1dqLteVeDpbxtjYpNBjBOZLSBK3lln2HPX6clwdTqErPCUxf7r6V+yxaeWDCMHjgatM7JR8vOg52w/PmH52Lcwp3DGzu78/d7SCchFFRMFZws1DFpwPeiaPETPMPfcUKiMdcafGBIqlohAxVZcUpmMABREBYAxxi6bMN3hwYaAPCYU21bOpFFK7GwlgULDnIzIhvmxJqblWvhlS3w5MX0pC2YsAc990RyMq40ho0h+xhi693R2ggTq1vNpcD4t3pvPB19s01H+g/1hC0PFHRgm3fTClSpfM3d9JyeBXwFVQKyjhtvz4vE1C5xjr/JFquTbJGq9M1zgORcTZ17uvIliTJNgdZQrTnUn3yzPCmahXYuxG4pBKE95t2XgN/dsI0nt+ALYfK2AN8WkRsEvv9cmY71Wm9L28QQuwlWKP96IUG9xxG6AvMV7W0+4Ay97K1UxeKT0HKGyGNWc25l03X7Ses/NVenhIAvGiNZAW7pBUBHT7tR4c0Lt3KAX7fi0FkIDj8EPJKi+MneGAzQRSFGFOXmLDgtLGD1LRvwjOsRwPtVJwaU+JWtjy9w
 O7d//f1Z
 3c7ICquv35womrl9/qcuAY1iXBlmbivBymOaZYXkaQt5QCEtFUKbV5rCLCMrDjY0fAoUYo/n85j+piHboVCO/UiL9qJjfAozhgTeYl4NUtFBWxU1wh2uZpd5MYWrcfFx4y/o1BFgcUV6ksAEKdAej0tQBT3IkTuNBEogp+Y/kU9o5494Hj3xBlfR6ahjKVlKyPwdPlCtmNSlWdO1HeeVmLP/E+/5CFRuloDXv0BVb32haAkMMTgtDxN966vAFYgvhsHVP12HolbHzEO1jI7xA9/Xvdd/gRpjztrdrI9pGJ8HdMpjXCQR+OSeQJjqdg+XAcFseadNCMv7fkAqCJBeHhueAtq3vUEmsyACv1E0ENP1rOcMyBjyExNSVi3yHE25A3lk4DpSjGQvqAPnZStqvw2ugz/91bSulOtGwXpyFjGA0HUrX1GuVthdcZdlO3m+NovvnMtxgSMWdkjtrvN9FaM1CSEHpwN22AtP/ZruVd30h9MrV1xwXrOKLFnTmHUK26yH9O3r1cIEL6HvvDmGMdO78mzkCjBZ1U7QO2qlMMfCNk+dOoC0GuyIz9lmOXqv0mlbOZOxT2ttKsO6GA0I3Xbu+OJYz1I6yhOCuAlzxKcI+JWQ=
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
index 8b0afaabbc6e..642718a50c27 100644
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


