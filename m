Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA82BFF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 21:48:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D50A6B00A8; Sun, 26 Apr 2026 17:48:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AD366B00AA; Sun, 26 Apr 2026 17:48:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C30D6B00AB; Sun, 26 Apr 2026 17:48:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EF03C6B00A8
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:48:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9837414057C
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:05 +0000 (UTC)
X-FDA: 84702045330.30.DD06EE7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 775A6180004
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YCfr5suO;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777240083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lya+idGqxu4DlV/pLONwdjLPocorK4fxVlb4E+6fg/I=;
	b=epYe/Bxy8iEUF7qVtmk0q3oUqp5xTjze7Sk9b45PGUy0HFfbWYeNNLPa/7V+OGO0Ns1a8Z
	4NSvqOFELkb4PAX80Sy1CfqYQwgi3CmU//H+QdR4ipsXGxfOEf4DqWhTOKGPpY3VYxwbvr
	aW0mvVGm6myzjAGNCDiYe0Ih2Jj6/NU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777240083; a=rsa-sha256;
	cv=none;
	b=pI9PWfXUwKOIYtrIxrIaftEsLFzF6AUAPjWlRvrPsD+UmgkUUxm/wQtbERFAcpzlvmZ2XN
	FNQ/2uZnL4zJpVLausy698/Y4Ejl9rY7aN5bZAoFv+uE9Z6fOVzvYl0zUMHy7TU1KYzZMu
	Z6Qv/cccMQOiZ6nOIXmVyO4JEAGUdfA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YCfr5suO;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777240082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lya+idGqxu4DlV/pLONwdjLPocorK4fxVlb4E+6fg/I=;
	b=YCfr5suOEKP7qfopaJIw10JGnMAPzUp40TQk3hKE8HSvSjSPR7uk0ulo19R3AxqDOMtMj4
	GE34EJ6MWLJt4RGhNu4TayF+h6aFEx4wDtrWN4nZaA2Idb/zSxdzPiuAa9DwpVA0Dlx9Ww
	t+B3nZXqMh4UllMhkl/QGKt5fStF50k=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-D4EX7giHPiWPYkZ5tejAWQ-1; Sun, 26 Apr 2026 17:48:01 -0400
X-MC-Unique: D4EX7giHPiWPYkZ5tejAWQ-1
X-Mimecast-MFC-AGG-ID: D4EX7giHPiWPYkZ5tejAWQ_1777240080
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43d1dea12aaso15807f8f.1
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:48:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777240080; x=1777844880;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lya+idGqxu4DlV/pLONwdjLPocorK4fxVlb4E+6fg/I=;
        b=pZj99LHgm01FhYw/jrnSgrjZD1ig6sc8xNyU8F6KgchltRJy0+fMzI5z5FB5n+yy7H
         hgvvK+WsIUxB7oQsEJEDZY9dZBnQx1I+OEZ0xG+UJBDWSjjDFOw7xewM+ttkJy44/xhA
         iXgD/WG0qT1XO0lqalexKgae51lqyCwMW1AbDk9fWq0DldxLaNQrsd5hrXa1m1GrsQ1M
         rUiCbVhd8GbV4zkdKYp27ZPGUr/WIqL6bRUEOT3oXznvBKMZ2+nQoCz8J06HpA55MmL0
         f5JnEUYLCtjq27bz+PCKtpuaPfiKE8g4WTlW9Meos/pWJDXoqVDgRIZkH75amsIG1JLr
         s0aw==
X-Forwarded-Encrypted: i=1; AFNElJ/6jgNy2exEZZE6Xe5eK7CaiNtqECQoDXGXS2hAAt9XTpKbmkKQ1ajJhcExx8rXXAQZSEmVm9oj2w==@kvack.org
X-Gm-Message-State: AOJu0Yya/ibiuBYnfvVZMTG9iLLr2ewhzFu0u22/Q93xDSVmz2DC71m8
	6q3Td81QigiUBLN+cXxWhKm5a8xTtzPs13Tvu5SE8ZBMiPqly9BEUCGOXdAfyZXgaw8UQqL9Y/K
	TcaO6/OtfuAWFmTpt/huAFQLYKT7fb7Ux7SCwG6sgI68FM5O/65qo
X-Gm-Gg: AeBDieszd4UZy1CGhhSk+kiH5dFDawW+npgnkKkh+8UsZywZ6n6HhGCZ/L44lORetKy
	0Q2qvAHwIyQVguWJsga/NkpxqcEGE/khqo3bLtwtlDUgOgQg9JBq0owYkxEcfvXNxZ+Zy+MZw1J
	wTLOpELgOU9nHAym0cSsiGsMo/E/kzZ+KWo5IhVNQzcsdcN6mkA5N07jXyAv+rYdpwgc2hujuLg
	g9STkCJalgugUSwoPsVWf+2G0odeS+9ZWgTQd4jQlGN9AcSotC1ifnwHMw1S2lZU915B8C+JDkZ
	XeTSoXy8vUf+klTzyvTFFbe0qYc8//Z67xgIZ/j8qgJ62vgJ4OjgL5G0eI3L1UCCExShRY/ZESf
	2A97f0vHa8bcvb5BbsNIEXRD2rU9Bec7N/m95YvzKiWcfSj+4ZOWG6maC
X-Received: by 2002:a05:6000:420a:b0:43d:773d:78ff with SMTP id ffacd0b85a97d-43fe3e0b61bmr62764567f8f.27.1777240079818;
        Sun, 26 Apr 2026 14:47:59 -0700 (PDT)
X-Received: by 2002:a05:6000:420a:b0:43d:773d:78ff with SMTP id ffacd0b85a97d-43fe3e0b61bmr62764530f8f.27.1777240079334;
        Sun, 26 Apr 2026 14:47:59 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-47-179.inter.net.il. [80.230.47.179])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e46898sm81019233f8f.27.2026.04.26.14.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 14:47:58 -0700 (PDT)
Date: Sun, 26 Apr 2026 17:47:56 -0400
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
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>
Subject: [PATCH RFC v4 08/22] mm: use __GFP_ZERO in alloc_anon_folio
Message-ID: <28642fd392362fff6d84d7d16acf9653c43cbcb3.1777223007.git.mst@redhat.com>
References: <cover.1777223007.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1777223007.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: M6Q92q3TduXKV7a-dczbUpY6yv2R2lpAPAXILR-siK4_1777240080
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 775A6180004
X-Stat-Signature: 49hnjdwj1cdts1keyr5hrdftxafpn7k3
X-Rspam-User: 
X-HE-Tag: 1777240083-295203
X-HE-Meta: U2FsdGVkX18mvWfV4Dw04N7a3w7bNdtcR4y+38V1BUZxIDnEVwJyJ5ED9tgnz6gQNF9d1P1Vmb9GOH/KXiJkKW4fGjo6/uh8o7lbDMwt/K3c3FXSdwpBK5sWTRY1r5RInRUWR9l//pBpgoCSrvyy36CoymSFa4Spn8pMWcbIPqAbT3KGQ77NOy4msphUSgbA80r+dk3QNRjh9mjKX47LkJTo3SmxGHkg/wmVfIIDpoI/IE9whf54Z2Td02tdauyapDM6fVkTFtr63wSAb3T5/jXOXSAUOOuyxULo4BQoQlvPFgafKnu86rWif4q2CtRPpWCRRWLeANn7NZVH/k/ZV7ScLJA8xWuxECxQAaulPF9bLxXXeGJu8O0MRcaGwiSFbJACvgeHkt1Dt1czlL/PnhxMPJwlGpuvdBupLXAhp/iYWiYgJ6Qd1CnqrRuqntgGNbLyOi4FNHbLYzUxoKbO+cJKS86dJzbOueVXAT7LboeKzJJQFXoAtA8hmtbYdEt7xfHDGVsgcsDNdRBv9iu3tWlIzsqWINTUgEfv7mlbOoLqh52+XHQuRG2TKGGnlr44a/cZ+8SttrcQ4NEU/Ri7iM/6IbnkiCokkblUCBC47k5HH+wDb2In1Qe4rYzfJCrWkwGBJH9ZzOyUUBdqfcNxaffj+cZhxjFboiBx42bPmeG/JXHSPIQJOG+6u+EO2/tvQxsC94toHFX2B2SGM17srFCNoNpxksbfE1HWJbh0rNVot7RDthLpoRu7GpMSteBf450bagTgH68Ks8Lu8LmnO2209DHr/UbrL9WVCBTvgWCjMcKUqdEjPhq/bh5XM63papUmoFNNCuJiKlAi4Hb7tGzEfYl8xy35hDjgwtLiEyo8oxs55pIgIo+/13LWr8x1+yZvJkd2YHBNlHLuDt8o2RnM/Lb1GQg8OUi63/UvK6e/QEKcOQp0V7OfhedbrC3eNhyinoAFRc453y+RFCu
 xbkU9koF
 h+wyIjhPDgL7fqRAzBrOLJb1J96miKJY1HVZ/51YnERqOZOrzIimpL0hPJNe+fU80UJNrrqWbXCu8UizU0O5JK6k619Pyryfo4sWELy32/3tkXv+hbcjlla801Mu99APl4V8sv9s++ImNdXt3ZLdjIsl2B5wFWyQCDqfY6NccMC7KTSoW3s9QZMIjGyQXrQit0470WRSOwTUM9BllBMFE08pbWTgdmyuxQdw004pxcFCvTLpdoSEeUVxBo3t8zwCMfUpJlDyqGUs6F18CQVZBHz547Zdz/CFoeoYNEhkNuDjuYSImJkuWhM6k3tmVUbGPasJlexLbMLQEm7DjaS85F0uj4cgy+trSSiZsjFAjA2xAYK39GLifsnNznvzVdA704sS4jY4u0hZIIQdNKFDAnK0/aw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert alloc_anon_folio() to pass __GFP_ZERO instead of zeroing at the callsite.
Use vma_alloc_folio_user_addr() to pass the folio-aligned address
for NUMA policy and the raw vmf->address for cache-friendly zeroing.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/memory.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 07778814b4a8..83ec73791fae 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4662,7 +4662,8 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	gfp = vma_thp_gfp_mask(vma);
 	while (orders) {
 		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
-		folio = vma_alloc_folio(gfp, order, vma, addr);
+		folio = vma_alloc_folio_user_addr(gfp, order, vma, addr,
+					  vmf->address);
 		if (folio) {
 			if (!mem_cgroup_swapin_charge_folio(folio, vma->vm_mm,
 							    gfp, entry))
@@ -5176,10 +5177,11 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 		goto fallback;
 
 	/* Try allocating the highest of the remaining orders. */
-	gfp = vma_thp_gfp_mask(vma);
+	gfp = vma_thp_gfp_mask(vma) | __GFP_ZERO;
 	while (orders) {
 		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
-		folio = vma_alloc_folio(gfp, order, vma, addr);
+		folio = vma_alloc_folio_user_addr(gfp, order, vma, addr,
+					  vmf->address);
 		if (folio) {
 			if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
 				count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
@@ -5187,15 +5189,6 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 				goto next;
 			}
 			folio_throttle_swaprate(folio, gfp);
-			/*
-			 * When a folio is not zeroed during allocation
-			 * (__GFP_ZERO not used) or user folios require special
-			 * handling, folio_zero_user() is used to make sure
-			 * that the page corresponding to the faulting address
-			 * will be hot in the cache after zeroing.
-			 */
-			if (user_alloc_needs_zeroing())
-				folio_zero_user(folio, vmf->address);
 			return folio;
 		}
 next:
-- 
MST


