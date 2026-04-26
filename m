Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF6ADFF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 21:47:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 249FC6B0096; Sun, 26 Apr 2026 17:47:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 222236B009D; Sun, 26 Apr 2026 17:47:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EA3A6B009E; Sun, 26 Apr 2026 17:47:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F3E2F6B0096
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:47:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B28461B8B60
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:47:45 +0000 (UTC)
X-FDA: 84702044490.29.7BE2302
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 755FFA0003
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:47:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Llcte4yr;
	spf=pass (imf15.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777240063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xFat/tQU1LWbkfRr9XYlFioABzGDJGEMsD6O36sEfN8=;
	b=FUX2MxMCMsoGgW6Yz3CqK9Pn8fQO26P1dPuPoGqJEdqPcDrL+ig85oUlnUkz9v1UcylH7c
	43dR30exSCBO+Qo/3z2qW3Ngvw4tYEEQfmTOScTqMoBbmowkzhaM//1bd4YLcamnoIX+i5
	LQNszix/EdXA1uFHExvJinWEogI2j4M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777240063; a=rsa-sha256;
	cv=none;
	b=6/ZFOX2oynAR7gY4i92Q1vTUwUK/d3EQ1Eraj6khVy2pBFxW2Kvxphdgf026iW1qtMC+Of
	UJSS02qYNdv5OKfDdM+4+2R7tIlqEoC/o7GiyWuP25yAPARBNzMGU8uYOIVRLReP8JcNdq
	4xH+ZAhYwN6ntHQmM0CkElFQVvo7B0E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Llcte4yr;
	spf=pass (imf15.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777240062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xFat/tQU1LWbkfRr9XYlFioABzGDJGEMsD6O36sEfN8=;
	b=Llcte4yrHhUETUmPSla/1q4JOzSZROtoKsQoeD5g/X4W3SzBbvRMlqdpAdYzizYaeNEx0k
	dWWmsSFuXsMWDrG0eSLzZIOmQMaF7U2yrHt2mE9cHHse4ldxZk7dVE2vICG7A2HN3Gak4M
	JJf3munJIJZrf4DryCD5zxkSHOeYNsE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-373-wWM8ByW7NA2iWmtTI6VIMg-1; Sun, 26 Apr 2026 17:47:41 -0400
X-MC-Unique: wWM8ByW7NA2iWmtTI6VIMg-1
X-Mimecast-MFC-AGG-ID: wWM8ByW7NA2iWmtTI6VIMg_1777240060
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-440d0c4401aso6888394f8f.0
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:47:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777240060; x=1777844860;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xFat/tQU1LWbkfRr9XYlFioABzGDJGEMsD6O36sEfN8=;
        b=n7hjGO4/BDGQeyaFarNZbSLScuK97DsQnfub+/kvaHVzyhHwkSIL1TXYEnVqJIeJh5
         OIHmVsVPxE+RSgbL/fBwugaXkldCzuyvuu0hEnNEokoHf2bEdKlbS9tuy/dArWlOOEZU
         VLQrm1CVsIdmmCk+XUOjCAcQhJev/JcC6whtkzom2h7p2NXEw/aiHZZDzG6qD2DVCG14
         x1zwe9t8toGlU7DZhTdlWaw5x4Sk2Ndded6JZTna0x9o4VTytXWDNV0kqoUQL1+S/4j7
         ix7AYM4VntK9Ve5jWRYvbXug9oF/UJeipVXHtn4s0PxK718BqbrjrTnmOQFuZQo8WU5y
         1e6A==
X-Forwarded-Encrypted: i=1; AFNElJ/yPpquQklkvCSzlS1WnLHqaghINiFPcztLMidYpVDzhyIlkEI5RdEyHEEcye4iOmBUAxyj6wlFXw==@kvack.org
X-Gm-Message-State: AOJu0YyDra9aap05uv7KrAvaqlaEi7JZENcLCbXDa9VFxlsIMtILc1Hu
	jnOvgNhH/fRxHqkBofoL3qQqVhmZ9Vgd5NDkvnPYZ2znQWr1I9PznnjoQSL6ucdlg/O8kYzs9db
	Mfc+OYDnkB8xDNI6DojNlNrbu3xBOMZFWyplHcouid0KCGEWduQSl
X-Gm-Gg: AeBDievtr/VOBZahdVyrBcJEXozHePLHtNzz7ZJjfHhilItDmfZT8abTRYr/FazWFsR
	MLp0hC2I133uiKs465r1euXju4tuoAB9MOlQKwP4h3YXvKvHcbrFgWVgBZVk2hBX1y9MAKTw224
	vWFGLYq2VZDEKJH+kufUBMfEcSwAubYYuUKL0j17HIYrnvePenFiJRtoKcROkH1PVsG1XDIBn3R
	CzPsPkaowRS+EOokFsVnFxYIoJa+JrsfzSh/8gLjNOW+xX+5OGbN/PoSJAzenyvF+PRRN1ic7qc
	eH3+4RNjbY7ErXgTlqSulwhJvdLBWPKE6wvuPQygm9Ojy7Y9yX1mwlN2zVwl3ZIXfOkWalGQXka
	fufFlBawtrk+h3YInWh4mNWccDbyj6NGdpf/5GF7kQsiDI28XKfgvM951
X-Received: by 2002:a05:6000:2309:b0:43f:e211:6e6 with SMTP id ffacd0b85a97d-43fe3db9b6fmr62507619f8f.1.1777240060009;
        Sun, 26 Apr 2026 14:47:40 -0700 (PDT)
X-Received: by 2002:a05:6000:2309:b0:43f:e211:6e6 with SMTP id ffacd0b85a97d-43fe3db9b6fmr62507584f8f.1.1777240059595;
        Sun, 26 Apr 2026 14:47:39 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-47-179.inter.net.il. [80.230.47.179])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-444eebec868sm795291f8f.31.2026.04.26.14.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 14:47:39 -0700 (PDT)
Date: Sun, 26 Apr 2026 17:47:36 -0400
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
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>
Subject: [PATCH RFC v4 02/22] mm: add vma_alloc_folio_user_addr
Message-ID: <0652fa7c0ed9be9794f44cc1f10ad19ed5f3990a.1777223007.git.mst@redhat.com>
References: <cover.1777223007.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1777223007.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xtBlkkJBNtof_qFhTWT20KeoI96SYyRHdnX9FpKVTos_1777240060
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 755FFA0003
X-Rspam-User: 
X-Stat-Signature: moprw3pp7oe9ykq7j13krbgain4zg7dk
X-HE-Tag: 1777240063-495624
X-HE-Meta: U2FsdGVkX19/pewchXjn9hG1YPVTOHgAO6FkXdBPpvItTOTSSg2MTi0ZcqtTGWwCSd+q0R1dLNqJMvA7/n8CVr3eCVEwcXkFJ2b4BTy63CdRj3lmJECGlDRySSUFB/BQghsWAjNxCKtFEZ1O9xNtWhMP47Mihg/AMGQToHUcHQyuwfQiONw08myV/bZfGosHRuaNBe+AWGvfZ8+zJf9+Vqx9lu2EkFfCzYZ9mKsY2AWVySbHxq1g9b5bYa7NQ6hnEF/plWeBFL4ZQCVq+bdP/ZrBoMKM4aA3UScdS9SieK7+InNeDE8gPzWRAq01/v2IqmP/PrW1qm0ikLjvYeqC7PpnGYzjcr6qrOxpmf27iVHHRFsJlu0iaxeqaJxmD5SyMftOtIWao2iM7GwbUjY4xRh7k0XM0QwOZ0Dky7A4+9rV42VQirZZsqzRlfhTtZAS9GNxaynHPM/5W3WJwa+mZcgbjtGm+gdqssqJpNYvf7ezUb3hhaxoxjj7tNQrZbeHBMMNDLpXnW6bvpH/q2u44x2MljX4OaXf0s7kBcfAeUA+2ppVLy8mVQt+491nGdmGwpSOc8CiRH4d7VpBRwS8Y7PbmmEhC8cHdrbEl63SLnrx45F5jGZnhsETVsCzjF3MilqkqBKHyafkHD1zM5w0c0tyy19B+Voj/eFPQUO1Ue2Ahoykcm38pyPShxja1IdzDjdc6k1pFZM0S5GjldOhgkjkgbJ1Sc9zkGEs++9Pqgt4eCrcVOEOIxrUYA+Gj8j6OwEHYIxJ4fXg9CQI02hpVzpiwo5fA+93KVnbw6VsYdIO5xAdSIrL75e6QDm8NPoCgA2TpFxJtSLgdt4McOa2wCIqBGlwZ8e9s2JMu8J6nSpoFduT7eDDHfX994zp8e3/j8BnuKxsIQ4jkvJybMlfhwW/n6wXwYh71GhFDP4m+DVe3lhcVQhSNsRd+xbY9MuMtJqlQJPmiye64jyPX7P
 VcVrl0sr
 XtPyFamt1OWOkpTgpdeZgLcHb+K/Vg9KUMk9OGUEhbYCghjJsZMDK4uiXuydcD3LQLwnmbWag1qNmghu5vjgtm+HG1/pSIoFZwNBAcuSVjQ/66Xn7bczyVf1wmCetdsEJwqkikn6oTGlu+YbtTGj1Mw8xiBj2PaGDl63TXgBtt42eLOTEF0sTaSkKujvyvcpj7hjMnmUocTMoVo43JNsNrW4G5o906iwAQxgfrb2xVgC3bbl3sRXhVDMv/u7rvx1koOh3Laoj1GHOF2lNlB5ipdnDw2CtYJ6Il+d+X2ONtGwey5P639k8451x4VhWEEvYmWMsV0s3c1qJlEsQSt4bMEg4AcIOK4uznsl9SEQ6TKTLzYYm/8CGcfrF0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add vma_alloc_folio_user_addr() which will be used in follow-up patches. It takes a separate user_addr
parameter for the cache-friendly zeroing hint, independent of the
addr used for NUMA policy lookup.

The NUMA interleave index is computed from
(addr - vma->vm_start) >> (PAGE_SHIFT + order), so addr must be
folio-aligned for correct NUMA placement.  But the zeroing hint
wants the exact fault address for cache locality.

vma_alloc_folio() becomes a thin wrapper that passes addr for both.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/gfp.h |  4 ++++
 mm/page_alloc.c     | 17 +++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 7ccbda35b9ad..7069b810f171 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -320,6 +320,9 @@ static inline struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask,
 
 struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
 		struct vm_area_struct *vma, unsigned long addr);
+struct folio *vma_alloc_folio_user_addr_noprof(gfp_t gfp, int order,
+		struct vm_area_struct *vma, unsigned long addr,
+		unsigned long user_addr);
 #ifdef CONFIG_NUMA
 struct page *alloc_pages_noprof(gfp_t gfp, unsigned int order);
 struct folio *folio_alloc_noprof(gfp_t gfp, unsigned int order);
@@ -345,6 +348,7 @@ static inline struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int orde
 #define folio_alloc(...)			alloc_hooks(folio_alloc_noprof(__VA_ARGS__))
 #define folio_alloc_mpol(...)			alloc_hooks(folio_alloc_mpol_noprof(__VA_ARGS__))
 #define vma_alloc_folio(...)			alloc_hooks(vma_alloc_folio_noprof(__VA_ARGS__))
+#define vma_alloc_folio_user_addr(...)		alloc_hooks(vma_alloc_folio_user_addr_noprof(__VA_ARGS__))
 
 #define alloc_page(gfp_mask) alloc_pages(gfp_mask, 0)
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0e6ec7310087..6d31a5c99e93 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5298,8 +5298,9 @@ struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_
 EXPORT_SYMBOL(__folio_alloc_noprof);
 
 #ifdef CONFIG_NUMA
-struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
-		struct vm_area_struct *vma, unsigned long addr)
+struct folio *vma_alloc_folio_user_addr_noprof(gfp_t gfp, int order,
+		struct vm_area_struct *vma, unsigned long addr,
+		unsigned long user_addr)
 {
 	struct mempolicy *pol;
 	pgoff_t ilx;
@@ -5314,8 +5315,9 @@ struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
 	return folio;
 }
 #else
-struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
-		struct vm_area_struct *vma, unsigned long addr)
+struct folio *vma_alloc_folio_user_addr_noprof(gfp_t gfp, int order,
+		struct vm_area_struct *vma, unsigned long addr,
+		unsigned long user_addr)
 {
 	if (vma->vm_flags & VM_DROPPABLE)
 		gfp |= __GFP_NOWARN;
@@ -5323,6 +5325,13 @@ struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
 	return folio_alloc_noprof(gfp, order);
 }
 #endif
+EXPORT_SYMBOL(vma_alloc_folio_user_addr_noprof);
+
+struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
+		struct vm_area_struct *vma, unsigned long addr)
+{
+	return vma_alloc_folio_user_addr_noprof(gfp, order, vma, addr, addr);
+}
 EXPORT_SYMBOL(vma_alloc_folio_noprof);
 
 /*
-- 
MST


