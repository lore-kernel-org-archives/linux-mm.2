Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FCB3CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:36:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F27246B00AC; Mon,  8 Jun 2026 04:36:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED7F76B00AE; Mon,  8 Jun 2026 04:36:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9FC46B00AF; Mon,  8 Jun 2026 04:36:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C54186B00AC
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:36:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 89E11164C5B
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:36:57 +0000 (UTC)
X-FDA: 84856090074.12.8A6A052
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2D7A0A0011
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:36:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a5XgJ9qH;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AR0svr1Wd/OcNae1i4toNU59Y7b0yC0WCO1bghbpkVI=;
	b=nI4OUv1Zd7F1z3Lb4GXJIhi4t4wa/HHA957fQMirO0q/HD0AGZj3bmX47RYOHuB1We8JIO
	BA5A7RAXkMrBPfP60MOjFSm2E38psPY6addX8e1vfeV6tgWpT4MWpnrNynYUWWRa9vidHT
	RO5x59MrDiAFA1RvSuZTp2QnBJgtNEE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a5XgJ9qH;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907815;
	b=VlVTw5hGSj1vImIMyekJtDsi9T/lojC1dBjEZhEEDIrMY+Wn/6uLYKG5DRs6CZrf+sjyGK
	lPrrIDWbNmpbt+zG/vzZqZUVuTww5kVmC2tn2d4pRh7kWNjD6nTM4DR4rrrUQx56A0JW5T
	7BKOzC5AhMLsO59hNgEbdgOL6DneTRo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780907814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AR0svr1Wd/OcNae1i4toNU59Y7b0yC0WCO1bghbpkVI=;
	b=a5XgJ9qHRgSa0JsnuFUdkvGnihmRxKH9cff+hlIKchAz0eE7rHe6FxjCHjCzkcmOz3cuTt
	5pHJRJrK/MSl1unZX8ogwBrqq0Es0PK2Cn2MegVY7t0xjBoGf6AoEJvzxnYEqK7ExaJ0UP
	4jFpnF6RDfVTMC0Tipbf4oBGE74I5yA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-159-_cSDqzb3PMSmafJ9pP4HtQ-1; Mon, 08 Jun 2026 04:36:53 -0400
X-MC-Unique: _cSDqzb3PMSmafJ9pP4HtQ-1
X-Mimecast-MFC-AGG-ID: _cSDqzb3PMSmafJ9pP4HtQ_1780907812
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-490b37e1ebfso19580045e9.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:36:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907812; x=1781512612;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AR0svr1Wd/OcNae1i4toNU59Y7b0yC0WCO1bghbpkVI=;
        b=eDgASCGnhA2spZefUnM2c3++xsY8TYoESHzKeGwHvt0jHF1OxYg30rZ0Yl/WR0LXX9
         TjB4DZ1PjsnQCzyQoNFz7ywbb2sPvq1i/jA3ZciiFsI9OkNEOkjXrA7ZEUNQuuCnP9dM
         hv3RVqa3Us7wPkfqFtDnKyC2biRdDo0wC02esOfp1SPHFE/nZfC0XanGVLAxH9eP2PGt
         1nUFISVWm0ZdvnkR2w8MDhf4ab9U7LGyk1Z856n1oerooM8gYYYUnsVkzGr6rjLvFije
         2J8sOK5I9cDlx5Uits0c0KOdFQnE8CS2XENy5Y8I7/2w0rVOQOZemDJQLUAf1C0PAoSt
         50TA==
X-Forwarded-Encrypted: i=1; AFNElJ8Iw77/Fs7sCtGeVknB2VZhLUxsyYI1sDgvD3S6eLhNwNDP7/aiA5aiDrjhQS/2jh4IENHo3Uvzqg==@kvack.org
X-Gm-Message-State: AOJu0YyiJKC+237ERAYQ3WTmxA3wHZ4oVSN1lyqeQ9kIkumsVuZHbrf9
	ND/tM7Pqzoj8iIwvUql3GsrCTB0Ac1R3G728i4UqSYhK4QW2UuyltqhT1vmrzQmGo1Ok94WxoDC
	kYJaCI2jNQRc3XHUgoOhAGYLJEkwikMkVNrXkX+k4FG/0YBCVLgtR
X-Gm-Gg: Acq92OH+jZ7Lvqy5E8Rom+mwJPz7u5ShQ0hpL27MZVt/hzww/uWn61leS1gR2oYdrw5
	XKk7Xkxo9J0ysNJQyRnJBgveKu0wccj6sPHjBdTgxMnKQDkvDeKYyyQbn/wnHZvNs5Qq7NWdSA+
	yoV4pdHI9S3zN9XMt5RaeBmJvNmXBKeS9LEeeQbp94FABLXJgGjCMwZjls+94tAlhJuSVBu+H3Y
	hGSBD96B6BqJOWFnJa+TEj7SoQVfRaC9Depg0dBDFZkJ9ea/t1iHn/q4ncwBRHVCD88XjIz8cpy
	W4F4MkDhQaRqw9UbEqbTIUjCJWJlK1vXu2c5KOw0CmYw9dadGaCXQ015wnn9vGYnfVxy9YyRC1M
	zYRnc+uGyifgiHezPX8fXERA=
X-Received: by 2002:a05:600c:4ec7:b0:490:b8ee:d6a5 with SMTP id 5b1f17b1804b1-490c2589927mr241065845e9.6.1780907811948;
        Mon, 08 Jun 2026 01:36:51 -0700 (PDT)
X-Received: by 2002:a05:600c:4ec7:b0:490:b8ee:d6a5 with SMTP id 5b1f17b1804b1-490c2589927mr241064915e9.6.1780907811451;
        Mon, 08 Jun 2026 01:36:51 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc39e024sm500006545e9.4.2026.06.08.01.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:36:51 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:36:38 -0400
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
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v10 12/37] mm: use folio_zero_user for user pages in
 post_alloc_hook
Message-ID: <f92f6f06e5804b4ea7f68b8664b7e69953b50f4e.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DR2M8R6qNG5ZE0bbRBPimErepVtVFHs2ckkpmM7cBbc_1780907812
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2D7A0A0011
X-Stat-Signature: j5rmeoz5z1m5fwi1mebxf8phwcnqzexp
X-HE-Tag: 1780907815-547368
X-HE-Meta: U2FsdGVkX18l0iGDYzSX53HtaEOTqpPsVW85XSaKxqAblYn1gAjleqaTIjLzvRuHlrgLaNmJqj9HwLL5sVsS9OYIJKml/gNLNJG4z7tQRd2LUz6MjnUFfczyelc0mGsdQJi7b3TeYEYP44GQsFe0msgMztynj17DDFdvaBMEDH/rPgkWu1fJNcBpAMl0kPzqlL9BaYHgXOXLrfrEpuVQ5X/fqvQg514ONzM+9ioH0RW0stfbl/JzWm7Z6j/AnJ3mWaDdC+3lEmmytE4uxB/lLuqEhL0Mv5olG0Izj9AtGQpusyvoLBsS+B1CNyH7M8A6Gn/FjRN1O03EfNbsjbOEqG0u6GE0t8cSvWDcavrftcmFP5MiyZ8awQazJ3a9OhL8qkavumyfHOee5R4duV5lnnMaaq84c76SosUb2yRB/AwIsxtf4mciVkDK6pWblRjcBa8fXHbcvyD7uscEX+tR/GGAU0bGVuO8JXT6vWuXSXCcZLRKAgl8/K1HWmNWgoIwKEQQaVW5osJMVklOvqOye9P8DA81NbzA74tFDVIHTuoYikGf3MJ1Otc98bhuWVJpfKCJayxg/Kx+h8eOLkZNxy85NU/WYRDdsgAYY++/U1ZVMFlnLUbb67TDIm+sd+G2h67jA2BRrZ83dtzbCX2HjPinBor3yDQG/AfVeRLlDTat+9sc4AhoojHWB5dTOBKJPdYfh8j4qZAYdG45CgBNCPcPUhN0HeykMBGmeZJR3++lgH164SG4ZuguT4TAk/1aOPN6x1fgsEH4/FXO9CvVqF8CZmkb4OWJGg5atun4tQIIF4GaFut9sZ23IUX1A5ovBgo9Oeex8CcqOWtVD72DrQZE5gAXyR1QUrIluWKjv6ndy5K41JfKWVUmyF4J1L1MkXywn/BiJ2tW6QNgydQ6wrB5zhHW5CPwTb9sZ/UALBG9th+djbcakRGGBAqQ0k5+MjqIuU0iDBYY4rh0Bye
 W/Mrgbab
 UnmUgh1rLenzvzwmWGtaoP7k+EMRlcoReEd4wwG5nzMHFtTSl0P6GYGJ94rI1JQCtU8W5+LuXk21xA8yAHF9/rJyjsOlPDrvEMHBE++RG4Bd2UkapPzpj+KknB5v5Z1M7zBn4PU3rp4BIMD6dbd9Koq8peDgCs6bNOQvUMkw4O0Uhq+FBvyywB+rrh9Vu6QdGU1TcOIEPIWHwgks6A22ptc9gEvmHTPUlsjeJ9u/nrvfS2xIIw1LRvXs0ygafJvif2pORhRrnmlRVLUh6h12txW+TC6R0ZfCMIpStJRfpObIaBxhwRfibv/mkFJOd023TSd5kDfOaRKalAwv9VZL5Q507/pYLvTklnHih2lglPpFCgcalqL5QwQoGNn2ynRwnL1FgFxp3o+oga7x+445T755cS0oeUuFyhm1+4uFm02hiyh7cr6PN/LQiLrhj2ZesX5Hp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When post_alloc_hook() needs to zero a page for an explicit
__GFP_ZERO allocation for a user page (user_addr is set), use folio_zero_user()
instead of kernel_init_pages().  This zeros near the faulting
address last, keeping those cachelines hot for the impending
user access.

folio_zero_user() is only used for explicit __GFP_ZERO, not for
init_on_alloc.  On architectures with virtually-indexed caches
(e.g., ARM), clear_user_highpage() performs per-line cache
operations; using it for init_on_alloc would add overhead that
kernel_init_pages() avoids (the page fault path flushes the
cache at PTE installation time regardless).

No functional change yet: current callers do not pass __GFP_ZERO
for user pages (they zero at the callsite instead).  Subsequent
patches will convert them.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/page_alloc.c | 35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4676fd49819e..d4fbf1861a8a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1861,9 +1861,38 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 		for (i = 0; i != 1 << order; ++i)
 			page_kasan_tag_reset(page + i);
 	}
-	/* If memory is still not initialized, initialize it now. */
-	if (init)
-		kernel_init_pages(page, 1 << order);
+	/*
+	 * On architectures with cache aliasing, pages zeroed via the
+	 * kernel direct map (e.g. init_on_free) must be re-zeroed
+	 * through a user-congruent mapping.  Host-zeroed pages
+	 * (zeroed flag) don't need this: physical RAM is clean.
+	 */
+	if (!init && (gfp_flags & __GFP_ZERO) &&
+	    user_addr != USER_ADDR_NONE &&
+	    user_alloc_needs_zeroing())
+		init = true;
+	/*
+	 * If memory is still not initialized, initialize it now.
+	 * When __GFP_ZERO was explicitly requested and user_addr is set,
+	 * use folio_zero_user() which zeros near the faulting address
+	 * last, keeping those cachelines hot.  For init_on_alloc, use
+	 * kernel_init_pages() to avoid unnecessary cache flush overhead
+	 * on architectures with virtually-indexed caches.
+	 */
+	if (init) {
+		if ((gfp_flags & __GFP_ZERO) && user_addr != USER_ADDR_NONE) {
+			/*
+			 * folio_zero_user relies on folio_nr_pages which
+			 * requires __GFP_COMP for order > 0.  All user folio
+			 * allocations set __GFP_COMP via __folio_alloc.
+			 * user_addr != USER_ADDR_NONE implies sleepable
+			 * context (user page fault).
+			 */
+			VM_WARN_ON_ONCE(order && !(gfp_flags & __GFP_COMP));
+			folio_zero_user(page_folio(page), user_addr);
+		} else
+			kernel_init_pages(page, 1 << order);
+	}
 
 	set_page_owner(page, order, gfp_flags);
 	page_table_check_alloc(page, order);
-- 
MST


