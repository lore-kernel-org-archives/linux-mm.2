Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB20BCD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:54:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ECD66B00C0; Mon, 11 May 2026 04:54:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C5426B00C2; Mon, 11 May 2026 04:54:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B41D6B00C3; Mon, 11 May 2026 04:54:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 17C6C6B00C0
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:54:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DF10DA063D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:54:57 +0000 (UTC)
X-FDA: 84754529034.26.246B4CF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 97C524000D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:54:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M2es8Z0f;
	spf=pass (imf01.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+4kzhpMcne9QL/iUfytpcOnuwyhDfw3DKjMmXnNjefM=;
	b=SckaviHO1BwWk9+RgAMrKw2xBR9verlJ8275wFbOErG/KWgKIOU0yXRchbM/QyBg7YR71e
	6Z/y6D/3vqBnwrirHBhubOrfZCclMhqEOiqn2QRcX/TTuTSwA2P28WhQ7gZjG9jufLouOv
	BxjbR+9aM1M92i8vc5nO+pKFB7wXKzU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489695; a=rsa-sha256;
	cv=none;
	b=Ge2/BSxQEF6YNgQdq06IEdSKfcGromhlW9pp7LyatW6gS1ApCWS99sTP9DNTTttfecr6wl
	bAA9Bf7Wk4DZdwiO8WLNMgzSlp975pyagZlvTmnICPGkGPZEgp6EWfCDT5FIjHhTZto21F
	A/ZKDds2D34eVA2mYygEIl7yMMAsnU0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M2es8Z0f;
	spf=pass (imf01.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778489695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+4kzhpMcne9QL/iUfytpcOnuwyhDfw3DKjMmXnNjefM=;
	b=M2es8Z0fR81f9xl6NPaBs2Q70yl5V0+AF0gQpDBziSXf/vpy62fI5iYDsS+HhoU4WbNLjS
	PSKeMrVsXPIzLdeJ9vsVhbqk9clXKgDeYhOmslwysHM+qm/iDyjEMtq3OEs7GF2mQuhHEf
	OPUD0Jl2QnwSnWEsoh1fAY56L/XYjR4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-gR9P31XpNMGomOQtFz73fA-1; Mon, 11 May 2026 04:54:53 -0400
X-MC-Unique: gR9P31XpNMGomOQtFz73fA-1
X-Mimecast-MFC-AGG-ID: gR9P31XpNMGomOQtFz73fA_1778489693
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-48e51dc35a3so31812795e9.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 01:54:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778489692; x=1779094492;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+4kzhpMcne9QL/iUfytpcOnuwyhDfw3DKjMmXnNjefM=;
        b=pdlBTjXHcs85SghF2TpyN5xn7W7aRf21hkbqJfBcmWg8BFKM+a2MPuXOSsIcz2iqDF
         X8+7CwVjY2JR62/hhMf5Y+7ZbCL1OXYCZsSX4fCBgCqBsbDyIxhwpbE3fBGdVbms24gv
         M6E0CKg6dSBK4W6OisqtbP/cWxjAprlZT+VumCOZacY8xjy1gfufNfGnyyUrTq9IekpC
         qoFsfGAXfl5cKuX8mluSaSPpijPBleohKcG1b2MNKHkXeHHYkzN9v8YY4fJ1K7zRkDKe
         J2mwYG2Ax4DwO4tkYfviQ1EmeDGPfAI4ehbHcKBudDktgxP3A49R0tMilvScDK2fRkHj
         R6oQ==
X-Forwarded-Encrypted: i=1; AFNElJ/h60mzZdiQ8rxjmGWgBHPGfBK2o2hlaJfJkBLgnXWKl6IJDwavxORvk5ZqyKooL+YFF4jCMCB57w==@kvack.org
X-Gm-Message-State: AOJu0YwsNHCD5gAZPNqER6yRBPkVQMWedE2qtRZoWBX5Om/947jXW6Ul
	q0rkdCWEg4xu5SveKOVu+fjwQb65pyo/PIKe69W/YGqjMT9w/ReU8gCkcJoP0Tye5y5gyCoBHnX
	f5rXQ+5rtmAYWxXotf+H4DKq3lj0iCjo2Cn9MHfZliOOQ9byMVKhS
X-Gm-Gg: Acq92OHTDj9tjoPHwNh425RX3RMp+DyMV2vN6IH7gc1/WquTVyIiCAArka5Ws1atJ3c
	PI7lVsdH3Z1o14KSD5ClALJ3ZDjO+wcqxCuOjnuPKUvcZYAncVsUymP85wcbp2QoiWpEYJRv/6M
	C5JxGeao96VoJNuUw8lcitx7pyBGTHQdA2E9eS1lL2VCoo4uikwR025VJK2jMuINFTaY01H1iX1
	lpWr5408pEpuvXY9tljI7yhqdVFBgDuGXFwEW/SOZOgpjqIX6x3zRLQhusGmJZOSBOfPhe5/LhZ
	353nqZkZqj2q9QM3mpQqh6gBhTIUP/PK/4+FyndPjnaFsjTK9WSV4sOU+hj46GLfsAH4eVD+yQv
	2vbgt2ihY7uToPh+hvgDSYpHHPcLt5Et/Xq98O1U9
X-Received: by 2002:a05:600c:1da8:b0:48e:635a:18d7 with SMTP id 5b1f17b1804b1-48e635a1ba0mr253244185e9.0.1778489692300;
        Mon, 11 May 2026 01:54:52 -0700 (PDT)
X-Received: by 2002:a05:600c:1da8:b0:48e:635a:18d7 with SMTP id 5b1f17b1804b1-48e635a1ba0mr253242975e9.0.1778489691662;
        Mon, 11 May 2026 01:54:51 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-454919c13c9sm23822939f8f.27.2026.05.11.01.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 01:54:51 -0700 (PDT)
Date: Mon, 11 May 2026 04:54:44 -0400
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
Subject: [PATCH v6 15/30] mm: remove arch vma_alloc_zeroed_movable_folio
 overrides
Message-ID: <64e3432a5982607dc886f5943f556f54c0612e3e.1778487000.git.mst@redhat.com>
References: <cover.1778487000.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778487000.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qjj5FhslJA1gwuIrfzNmmC52mrnsvGPiYKj23CZAjTY_1778489693
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 97C524000D
X-Rspam-User: 
X-Stat-Signature: yg4u3dxw3dfpbiuwe1gqkie7knmkwz4x
X-HE-Tag: 1778489695-911288
X-HE-Meta: U2FsdGVkX19OYqAM6u9wy9FBVUflcLwQGe+3Ed396LXaG5Rmc5GslltXjzoiFN/SVgd3Oh5A0r2020y9gISONqiT2mbM2O7qt8vccMq6nS/6v5aBzwFJBaQKggCLAljlv1UBjsoataTfmELabZhoB6WNpt2gdoi6K35+b4m3KCxHDHJq9u2qCV1MIVuRr0IryXQlQRdxhvXkwK1VSPi6nv1EDlekvHrEsC7cewF4K8yRwmNZJbvI2BH01YD/C73Eg+P3acvhDQMJoBfc4VZNj4BqsJo9RZFinhtf8ej8CTWUYO5LVVuuD5X0HAvxZCBUPxzaMof5iLnGA/jsLjOqAsY9HI/AlPminTBG3IqK5/Hqm4Xtg7ztHLXeFzEVwhUpCZtg/rcCZJwMh6sOomY3vePYbaHw4ev1n8cPNvL+Ivtka+CTsTSq6NQOFHIZ8Nd9LH8Wd36pAmGa511aAdjZf1NdAg80hLTcslnYTAwb+jymxM61rCbX9ybJD5gnHDqlSWoLzCEBey3NCR0WOv5NeAhK2T4tjeqDR4ime1ZndDrDHcQQONYc4Uo7HyxQq5v26qxcYAo0J6zkvj6UrFgc0A01TbPcXSAg01GyGeUnpTwueDuXoRLyVXTkJ7OLgdJR/jGHlA/y/mWDYJpZJgkdCovTPsjvEn4adPgDlFt3tHQsxtEj8ERMNq3XUSP+ZHQLg009MyO5Jk7DekDgNL3Q48igaG0jh/7u0T5hiJdX8HzufZhlOihiDMN8B3X3n/mTT9HlqKY1lY2z2Lc2RI+TWD/Fz/Pf23grfSaf0Mm7Ao+h8EUEdPLK8jcaW4EJ41Q2iWfnkuMxJfbckywddXX6syZ2gRttS2FZJP0yfchUNyRIVZa9yEDD8nsVzhc5iigBE9wvAZ8+T4ObD+aMrBNZrIEIqq1DJPMLvtPalNTlps8AwXnnm1e19eqVFj3Z+d5c9v8HHj6Z1Yg9Vx47HSJ
 d8OLEFa/
 QUY3Vc7+LajopR4/uUt7KaQM2Fzd2sdP+XkIUL7WwkqSDeFsr6jo1iyARBqhNPXYGhH7irOJbjZ5zw1ACjYk0N+CGc2RAgRjEs24TvFUK6KQQ4aPZeJjasOg9PCX8E/0PjJwx/8vTfKudCSeknGx43C+Va8JNaM1i9BS3cUJZOTluB63tgApr6a/webhc+7TicN2mTvrozJjeb6uFc7+cRhCxbGx+iqlbwsAvHbp7Bfp1MZMA698deEbuPSWzPAitSW6rR0SiPWXWsZIFzLYvcf7ZqWCRac/VLeTUcM7BPUyWKU/Vcaq4MIZafQ6Js0s8ptMgIgG4AcfOKBVpN5v8pDRZm7B504IHpeWbgKdm9VS5HPL9qAswmce3QKEq0jnW+vPI3VJrrN1iNso5QvT9Sscb9VaXIL7SvgEunHldxw2rskiGBUTxyebo4wr9zb03fwC0bjr2hI6qYwSudGdDtw8dCuN00qKO8Pn1Iw4TMPDEjpvgDtAdqaHMEbU+9haDuPU+bjcmS5eYrAegTRRVZ2LcCA3lRztRVggO/MynhKQUvPk=
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


