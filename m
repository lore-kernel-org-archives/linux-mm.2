Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B808AFF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 21:48:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C0786B00B0; Sun, 26 Apr 2026 17:48:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 270206B00B2; Sun, 26 Apr 2026 17:48:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15FF16B00B3; Sun, 26 Apr 2026 17:48:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 057EC6B00B0
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:48:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C7CB81A066C
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:18 +0000 (UTC)
X-FDA: 84702045876.01.9EEBDB7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 90D374000B
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TgPxFQY1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777240096; a=rsa-sha256;
	cv=none;
	b=4uew7gscwVeJhw88gt0Ui4sCSh3U3arYMNnV6O+prmRmi90UaPzJZ5Cm2R95g3NvbUQtF8
	rWXUsV9aWqhYcYhBHNdpakhhce+A+HvKBnc18eeqhXSgFgLykCij/N0yJNdNVsFjae+HLL
	WX0U98u0pU2OJPwKtDUOVvaGSbsrTgc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TgPxFQY1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777240096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KxxPeFo8b5YQQgq6okT6k4ODeRwXIuGSW0SUh4EUnR0=;
	b=Abq1Y7PIZ0F2jO+QZgcfv4FIapoIua5X3DuCVGgEjvaKjjGr0avycsU3PR9FkRfXw8TyEp
	taGpbLDJLYuxfQhgXXYMQ2mqjQBz3XmqpYyc+TymxvnTSe+yOEMZThJZSQhKOVlbuZyHCE
	ZMHyASF20y1ukOJzbiWVGwSFdoPEbfM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777240096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KxxPeFo8b5YQQgq6okT6k4ODeRwXIuGSW0SUh4EUnR0=;
	b=TgPxFQY1VvQDzV5yyrlydLtRzB0pW9KQSYCoi3c5I3q9+mjOTnqUGV7Sbo290w9wNb7En0
	wOvmRbdDw3eyQISgm7xbK020jiC8xXzTWp8XLzJQHSviJU0d9pPwYaHrmI7BIw4MBer5Ot
	kMWo/hjB8cpOBkH+uh0qztTA1ro2xWc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682--K7rbeBSPPWL3c-nryLc8w-1; Sun, 26 Apr 2026 17:48:14 -0400
X-MC-Unique: -K7rbeBSPPWL3c-nryLc8w-1
X-Mimecast-MFC-AGG-ID: -K7rbeBSPPWL3c-nryLc8w_1777240094
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4837b6f6b93so102942295e9.3
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:48:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777240093; x=1777844893;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KxxPeFo8b5YQQgq6okT6k4ODeRwXIuGSW0SUh4EUnR0=;
        b=cv3o+Nx3h3yZZjcSRmaN5Lzwn7Y0OAdoD1SWTcJCGSyLFwJNOY3Asg3d4d+6jYJPJv
         SaYnBPRONs+QZOGkFWXFHe+oNuCAwzNz9tiowQtENmMIAk0vP8fp7+2EhCp5x2McOt+f
         Uem+8df+WMPHyb9oet4FyMDxdLDBgOIJqQpwX8/CUrAFUtJl5+QsIpp9zgrHHmm2MQKO
         lWSAt/OdOYChE8kIMvwBbYLIoRC3uS7qR45y4KwSK73jbdYGuUwiAmyeLZIjZPi2MUgm
         V/4yFw9lWuKeYXACOLEAueMa1bNBwAAB1Z4l+C9aqTLCxcxm4Dz7lCLAs/pjHsg0JseX
         SyZw==
X-Forwarded-Encrypted: i=1; AFNElJ9SVJVUvrR0lOl+miG2vEaWsN6dcD/8MTAmGCsO7Ui3GmVlhI+E9GHOwFybQ2o+9WLNiH0yt5S02w==@kvack.org
X-Gm-Message-State: AOJu0YzYS3mocPilh6Tw5GbesdD2lc94HFVKC5yMadSXp0afKiLHerBb
	JHGB34NbA5vQse5qAhyyUkJFKmsMe1HT1NxFKvS+flKa2xkX0olJb7rrCfJa1bihYk3tMCcDdjb
	QBMF4jDShyOz/mIS6yQyUIhPE7OaIYriGZ+LVTzA/qpxKpPXAvYgC
X-Gm-Gg: AeBDievmbet6kbk75fs3J+v5L7DvhKZF7c1TJDttFJ43UFiFm2bjPJ725YJ+tlKLLLu
	oNow3OS2qSAML8PjtuTL8Kh+anQ/HwX90mOhi98cpMNrrx+gUTL3fmQrh/Hnsv5n2s9Btdqnra+
	+kASeWLUb/sXFKttxReL5/O1OVymWlVUvS522nrdm/ZIjszSsepI5fmtW+Wicmt9YqD6OhxOSbL
	ohMb0DoFrGPvJIZz4P7Ka09Emd+1p7fkSdeGiPRB9ogrZkyG/KZj8+GtWFJoZ46kpT52UM0Ljtt
	XkJ7NQxCQPU6qWBpbargUOKlBTrFd6sFFKK+uzkzVSJypQWabvHCZuOz/Ar4c9G7VgzQlA3ZtGs
	03k/ssCHifDfPp456tvNopRgcvsD+7TBPOqXNudGrH4pEpru87+X44whV
X-Received: by 2002:a05:600c:6296:b0:488:c40b:c8a4 with SMTP id 5b1f17b1804b1-488fb73d764mr551942835e9.1.1777240093415;
        Sun, 26 Apr 2026 14:48:13 -0700 (PDT)
X-Received: by 2002:a05:600c:6296:b0:488:c40b:c8a4 with SMTP id 5b1f17b1804b1-488fb73d764mr551942475e9.1.1777240092952;
        Sun, 26 Apr 2026 14:48:12 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-47-179.inter.net.il. [80.230.47.179])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-489fec8f7cbsm454414365e9.11.2026.04.26.14.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 14:48:12 -0700 (PDT)
Date: Sun, 26 Apr 2026 17:48:09 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	virtualization@lists.linux.dev, Magnus Lindholm <linmag7@gmail.com>,
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
Subject: [PATCH RFC v4 12/22] mm: remove arch vma_alloc_zeroed_movable_folio
 overrides
Message-ID: <424f14373b3339c93cab7a080614b7e0dbe7596f.1777223007.git.mst@redhat.com>
References: <cover.1777223007.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1777223007.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5dirrL6drc30MAgwu0UdH5f3VvTm1XLD8z39yrNM9gA_1777240094
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: nbhieoj4j3kxuj6tnnqsdexruu1kkz37
X-Rspam-User: 
X-Rspamd-Queue-Id: 90D374000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1777240096-114509
X-HE-Meta: U2FsdGVkX1/IpkEDKoOqtGUpJgrcAtxNeI0Z5JbPSbFr7+Ak4eJpyu54mwgAqvPGaJoxoDRr0+JS7W2N26j8r7oZhp2S79Bm4gMjGRzqKhZLJGqmS9tqW7SUxXHRHf85TML/FaL6L7wjIRffIHgnUAGhFSNsKzqijDYw/kcQPKg394d67I33q6ORt/s56EJnqZIVhYEmBg5kOvMShwynikuOfSDLWSzy5MpboXOhmqAUxw0/ZiDFQM2C66c78furWmshUxgUvwFj0olSmAVw1BahwWaXNCUJXI9yHeAccT3BbrQlx1RNVCZXAyxMLfTuZvTQgTGBmmCRvsGAbRz9aSVYUSBGdRcSOtMzJUlRRgejN7T/sutYSNZDP+UR6cyXzGpglKVm60oydmmHBsptioyliFJSUP2xWX7rs0kzwLLcWHrdzuWbyaa+ttGd9BgtPLQO+mePSs3HSxUXflPRNYJmNbbLK9zxT1gbXQVR11st6AcrhxIctdFGsQB6IVYyqAo7hLeXs2y5g/+K7EyrvupzYQa5SamRtj7SuEBEXtLrGByHKtCnUlxKKXJ1ZzrXVjsN73C9G2/8Ds3rcYjARLmlnELrUKDPMwzyQqyj8iaIcCA/v/qMldjjpT8ni+JZkQaZ9cx3ozuYQCE7B7eNy+5OEkfXq9TthsTiADEaIJQdApOR05yaRWMFzs+cegEXjJTdEigv3bN+wbZoAcmyJVNQD2IUh4Agrrh8MVPMWv1SNT1wJn9AONTTHMljK/MgPLZtC3+PalrQAGdnETVBD88rOA12+Hgtx0gmDf2RRJdIQYWFuLVq4E8EVhcXpT8cVQXfUpBpQYu/Nvhe4uCGk1v1fGfeeKn7pO//7B+wzdUrBCoC1aE2e4JLbjTkBEc5po70n/pnmiNBlrBmH+IaYmWkHGSnsS+mc85As8P98yfiSecW37SCy2uxLFkL7iQYO9C4kwkeHufkcnSpxqH
 bXHW/MrA
 zoWqbLo7EO3BqAhM2jiKGAGCEPaeNEu1if7vGudJWW4HtD42vxVP3KejMGhxqRg8B+wfs4zp2SyLi7MG0MYM838ZZA3F06ks2lutKjLlihjiHszFcWQm7beHN0GSD3VbusSQPXQNtP3az28gjxJUUCipXXDSsWgonVoDFPTtP6Uzbq0TfBrHMS06nCJKfOith9BvPUCD2WVywGi3In4ma8+RRTn8JvyW1gFoXhzVRpYSTXIwDwfVP4+KV+j1deILXvihknEwjwSa8SKrxhtVBgfBzt2xxxjWbBq3EtysEIw4c+QRnw04u3e95sIwDHbp2AeHSxdhonyKsl/KKVnNf6XfoKYIPkA5ZgN1Syjzd6zvD72taSa3bhrPWD8aw/j+hMvRuWsHojBc5U9eG1AnjHXF8qLlLS/eR4kVRXh5ilqvmaXgG8GhVi35dw90F74AdJi8ZB9bPY1V11qO0K5DOGdmauorlEZSRQ3+Y
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
index f339258135f7..04020a19a5cf 100644
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


