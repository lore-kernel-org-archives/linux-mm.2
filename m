Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B4AACD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:53:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DDEE6B00A3; Mon, 11 May 2026 04:53:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B6476B00A4; Mon, 11 May 2026 04:53:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE6DB6B00A5; Mon, 11 May 2026 04:53:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD0BC6B00A3
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:53:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B8A416058D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:53:41 +0000 (UTC)
X-FDA: 84754525842.10.62739DB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 67AA8C0003
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:53:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LA30yb2M;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+4kzhpMcne9QL/iUfytpcOnuwyhDfw3DKjMmXnNjefM=;
	b=PrNXbOijZLpKPswRGKkpQhTTY95yYq9/vdEx9gnkLh0+J0UlGJsGfATm7ACm78CuQCNoKA
	hAwAC3S8GdLj0aKcT/pxgTF/RfkXDpiTy/h1YOQEbFJbIJ5wtRyK6Maa/jwa+8d3J0pcIR
	dMj3VCplgO04J3xXHd1R2kgyUidAqbI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489619; a=rsa-sha256;
	cv=none;
	b=e7rKnsAOAa+iqOIlOobA+jBNHRQOVb/w7BkLuCd9LzRJ4WJtv6+oz+0IQMf9Rjysj6/EZb
	w8PnXxaIRhlDsDTOt0EjOZP6vr63nx7nM2g0HU+7v92+KLqaJ89kQ/Kx3fKxsfpTEJYbkc
	qcnlzFv9hayH3hrYxjFUpo84hVYPZdQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LA30yb2M;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778489618;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+4kzhpMcne9QL/iUfytpcOnuwyhDfw3DKjMmXnNjefM=;
	b=LA30yb2MtqVbz/wCQLdHbkjZpWVWzoSKvP2mKXFWCScPUQCa0fI6saSMhY0h2qz8yG9w8G
	Ejl+1F/O547eZtdoDrLuWaRiWl/H+VLu3JeUw4z9dPUJASDifQuuxxyufYRjFFb4rquQjE
	hHX0r4oSduZwWa4m8CVlljfcKKHxI0k=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-68e58fWaP_OlyW1PUSlymQ-1; Mon, 11 May 2026 04:53:37 -0400
X-MC-Unique: 68e58fWaP_OlyW1PUSlymQ-1
X-Mimecast-MFC-AGG-ID: 68e58fWaP_OlyW1PUSlymQ_1778489616
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-488dcaf2f2fso31771315e9.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 01:53:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778489616; x=1779094416;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+4kzhpMcne9QL/iUfytpcOnuwyhDfw3DKjMmXnNjefM=;
        b=jfvifTFWpoFMyI88tHGlz0ood+rkWzFd13/sdg+Btzj4qI7/ITiqcO/+uHI2W/pZ3u
         8Zu8k9pA+hcjLexZmpXOldYBrBFGTOuArKXyDdNSB+q8MYYVXiHBcejgyVsEPV0C6nRE
         EsUcnJX/1Jfvr17p4TkOlp5ZDyuv1MwYjgzqsBF3MfjBKYxGnuxJ+3M6uzFmEyAm1fmL
         ANrh75nmf1K3Whq2v14WxM4mwoqkcE0nvaEBYkENKq30mxg4PM9xwfPPcipCor5Cg3Ax
         ijbhVsQtKeh7xky30aB1o9mP7Ow0KO9kJsX1dfnyGSQkAoAB+yu1CF48lRAjAuwLe6QI
         v8Gg==
X-Forwarded-Encrypted: i=1; AFNElJ8eMAFPbH0+TfiL6Dagkpd6ZsxAktjxe7/d6zPiyQ8wHw+PfThV6N88B7JbEa3QiokZxbrmMudRRw==@kvack.org
X-Gm-Message-State: AOJu0YyqAoE+Gw5bEsjAaWe9DG9Aq76Q/MOOm7QCwmHXuoWHrnZvowqy
	1aQS2XFEd/t+sJE++XDyG/+bh8/tl7cvNXDbh4f0p6y85uBaM+PzOmWsCtuvVmTdTgAJLgIRvjH
	M5XnLEcCBtOmsCXNx7Q1Y+zLM2lL/i31cKAE0XqTAvHisHy1ee5YQ
X-Gm-Gg: Acq92OEB5Ek2uItFsqxGjj867N2DwS2Pk+CcFISFkrhip9jXEGiSngmidKEX07vHwKi
	jyekSqxk2zYL+xwb6kcTopwM8mFyW3PGdn0TF54HAohEi7W0ykwy/vIITFs+G6ZrQjq5nwYMFtJ
	xKAwKfHQU43WtKGcedd7XkbrqSebQHKRFNZFJ5O5XuVvLIuBMUN/h65vM+cRHmXzkNrJuDbBiQN
	VO07EqO0jkpdFrCWFmEBeLirHvjHMnLvB5L/q767ZaeM8eFavHFY7nILlJCn1fLC5qkiQFwI1yZ
	k4Bnnc4F5sU3QG6M0eN7EL+CeAKXxy4dWoUpwX6cxsctTWGl0IKsu+EeAT49/e3SH2NEs9vxvaV
	K8l11bm6EEesvKjpzQ8+5MP3MGrwxrsl5hZqSxiC9
X-Received: by 2002:a05:600c:3b96:b0:48a:66a8:9981 with SMTP id 5b1f17b1804b1-48e51f55272mr385229895e9.27.1778489616189;
        Mon, 11 May 2026 01:53:36 -0700 (PDT)
X-Received: by 2002:a05:600c:3b96:b0:48a:66a8:9981 with SMTP id 5b1f17b1804b1-48e51f55272mr385228675e9.27.1778489615481;
        Mon, 11 May 2026 01:53:35 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e7041c4e8sm166061275e9.14.2026.05.11.01.53.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 01:53:34 -0700 (PDT)
Date: Mon, 11 May 2026 04:53:29 -0400
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
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: [PATCH v6 08/30] mm: remove arch vma_alloc_zeroed_movable_folio
 overrides
Message-ID: <24a1b25f4f1cf31fc5bc053e475958ed5e1bf8bd.1778488966.git.mst@redhat.com>
References: <cover.1778488966.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778488966.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: j2REfbQH-0xA-nDXpLosIf-LiUAlLBfORDH9VKT6GaY_1778489616
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 67AA8C0003
X-Rspam-User: 
X-Stat-Signature: xz16ax7zp7wzufu7j8hxp6b5istifu9q
X-HE-Tag: 1778489619-133346
X-HE-Meta: U2FsdGVkX185PzgSoHQGo3VsYRtaNNHJtIRkBM66yrTzsLGlEtOReqvhqpP8v+1Z7nHWPAiHhm2LVC4DS/ZBzU7+i+h5NqD4GFfAecQgX6K4pqJNEiJj4rOZUhm/QOFoBIS8aVsBCyrxG0DqRCJpO6lz5AWJbQ1pMt9CniIDoxkkrw+leye7ugZrFJMRilhtIcG03G16SYCwePPB6UuAIbjJppF0XtOHsMXXN8pYkPHan57t/I01uwpIhCXzrbQCP6n3UyN9td7DroNdNZ4eDSDVqAV74Y9PJvjWMxrUlmuRhI2cL57fkVRCuDv9S/ahy2JZHj06/ziiSZd+J9jXDzQpc0JP2Jfqee63wZ8DV84w3cS6Or/+lZQvBwV2fCyGQytYMp9rrPvVQmVsU9Au5w/1tszSvCkGT44wot+wFu2Gst4aLIiPbRUpScdtnj/Lb70+1kOjbFuOUal/Gydj7lX6V4USkgJYt3Ow9X8n/n2bbD40txaPoXCbQoY5NrX/0qzfuuOYK0YgXO+/Jumsyz/Cp/07OlWaZneZ4o/ZStUC3mLeIAD7+7nmIMY48WvlgXPuOiRSfSlK1P4yP5Q+gwHlRTKJpVC+bg7PGf58+TdF2hQOmlbrghfPhCkOW17on7zwfjN3HGT6Y7xaeaCiulq/HCGytLiJwE0aV2tDLQmRbuRkq1RmOJeftDiH47oDQ2HqmUQfFI9bczs0cVGkQ635zq97UySmjWJajVzCgKzHvcLktbV2XB17DVOu6Hom7bN+xzTkNuXT55rSkI6HjTHkbMXNsWKq5spcKewJWXgHR3JWlFV3eYjAt2rHHQa6kDfSujinDsb2PU6Jt0W5gaIIU2urewgs0JhnQI6wkP7N2wCdR8pMKdNQec4l/3Kd9Ly/KR/l+DZ3dLBxEP+JmpbsEvLxdY+c6yO7kE8zNKPeH8VakAAMziMhUCOUJ3f1td26XM8u8bAM1PnbLzz
 H8W/fDAU
 navG0SeXoZQ2atRg2yEOUzKqBMLcqk3T8rzb9wKuBWiXtOUEOH0tW+28l6g/pyp8L0jTlDQ+drW26Q3DImcP3cSY7X1KG71P4BjKvbkNa93Xryk0tRDXiX9OGkaZhLONnFLVwlw7L6phboovEsMUkw+99RghesB9kR8kylDNwh9aoT6v5YHjDtBx7L8/JGeF8CHW8eogS+msUKYVH2tyfVwR2wZMyKJaaMIbdW04QMfBNCGFB90ABDs4xnZHXuZghoQHj+IUwH/QluTEf/l3DiPt8IlrJR9rnHqlIyU+KPqDjUtr3FLovd8fFiUO0Ga08493gys773XqzAuUxgB/z/GBqKRyi5ryiZ0RjM3w7AJ38mIEhWcX0eCFvVIboGhvU/qjHBcXzg5DmsGlVuiqSJAaGAshsJBucswSeOdKiZyazm8lqdHjQPR4iHJZ0RS0XlUQ32WyemeqXKtcLXiulRN188LgSwjs6lE8Kf/dwZq2gve/VPBnZw+yHHYycxT8gyNltLGypZPxXQixbyi5dU2D4jDAFd9I7zVIrowu9dyYGJHQ=
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


