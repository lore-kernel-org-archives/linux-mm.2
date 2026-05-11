Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B34DDCD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:53:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2647E6B0099; Mon, 11 May 2026 04:53:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23C386B009B; Mon, 11 May 2026 04:53:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 151E16B009D; Mon, 11 May 2026 04:53:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 06F906B0099
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:53:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CC227C2371
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:53:25 +0000 (UTC)
X-FDA: 84754525170.01.3C8D937
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id A4F3FA0008
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:53:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QhjGNbLe;
	spf=pass (imf15.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zuBj5G8Fe8DfsQghniXtZy4OYrf8Ud9rSYDvYLkW/0M=;
	b=09e6M0WZBW2tEGZml7lQfRb3ErQcBlMYP+1dfPG4SnPstpc4tsXQkc4k9/6aNwoAITphrC
	4pB+PUDHDabAsrijhKfANm8gQZ6669tlbgevlS6clAYw8LJf4xmWfa6abQfGTedBd5uXMX
	yntoPBK4hz4a/lOmPCagJIPcda+1sbo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489603; a=rsa-sha256;
	cv=none;
	b=4UpofbDP8PpqwCzaHKbgsUDYUP9MLcuVUYkDoRlAvQJtmrdFfU+uZ30y6UjZMVTj+AnKRN
	ML3Tz70ki1Ope4TcczkQxIyOpcDsX3/ih3Ep0PA/SkYkeZzuOhRWVwVGuFDHfL8/v/HQf5
	4ACNiITqO3Dskk4WrdNmcrNxXatzXX4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QhjGNbLe;
	spf=pass (imf15.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778489603;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zuBj5G8Fe8DfsQghniXtZy4OYrf8Ud9rSYDvYLkW/0M=;
	b=QhjGNbLegGDcqP2Wmh0hav3l4C1JKpp7vsQ/DDddoow6paqaykL3JVoo8kfbiBi59qJnaa
	AclpgvF4VjRcBqbyqSasGnGjB3KywAKb3jsMe/cMLqDEfQMdDBcnfSSSW4JK1HRnYqEBXW
	7WJ5LQ+bu2302vsXLW6Mxm5uodaG7t8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-117-Dt4QU9foNAuNHvu-zn6TxQ-1; Mon, 11 May 2026 04:53:21 -0400
X-MC-Unique: Dt4QU9foNAuNHvu-zn6TxQ-1
X-Mimecast-MFC-AGG-ID: Dt4QU9foNAuNHvu-zn6TxQ_1778489600
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4518f777225so2678455f8f.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 01:53:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778489600; x=1779094400;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zuBj5G8Fe8DfsQghniXtZy4OYrf8Ud9rSYDvYLkW/0M=;
        b=C/DDmEKQMwxBuOyvEP3PXQb97Y/nch7ZhNZXFEEaOG5Eotqseqm6GQiiUwOdqWdm7z
         JyoZlFDOwP27bJ3U5i0mn02eFppEgkxwodgsVO3zNWahm1KhUTQImNBmQpHwDiEzfuDf
         IVXllhOn3iDrZ2ztEjvHx7rGQdi9+ema7o7qlTXZ2wYDsUF79hek8f6872qsmXUC0PgW
         xj5gNLl+80p8VTfN1gzIOUGXO8B651MqKF/n8TS5hfYi/8R5nSILYDiopyd7L8nYnlWv
         J+VJUl+urPBNqrOyOcDXp2HfdgnLft2ISUJ/NH9yTnJowxRkjdOTl0n10hu5LRZeAiLO
         M8ew==
X-Forwarded-Encrypted: i=1; AFNElJ+kMDHVXiidwM7ASgG+g1BueJgmXKszOSAHb6QBM4NzOl/cu81RtHlAPGbFVeLIfB/s9jvoRuzs1g==@kvack.org
X-Gm-Message-State: AOJu0YxbraKWMDZ7P12FT1H9yQO31uDLvQA+ClCago2dtvr0EgVWOYeU
	fyBMspAvJt2uR+pzg+ibCCZsRrSNFWyAa3y4AXAIO2cjK1JVUsmvd4XjXJSNYTfuPJm8mfcbeAo
	dBjqn8LkNwH79+sW8y2A7nvoDWLe5b5p+S4PrgGJatyZG6EHfUEDb
X-Gm-Gg: Acq92OGyyz8wPKt8XdztziRYQtxqjeIxHjDOfjprrNSVObw6zMVkZWgagaala3zCXS+
	lwv3VeJVIoWDaHq7+xLhstVs33oVCNVodQcz/2kpsUiNIhN50JKebf9zqCvrS/JsWGWKVgIqhiA
	GiL5knfNoiNeCyzrmv7UgjKiPdm8rrZPHDS5XWZgbcFgZB8SYNsEB2itbVJ+1pvSCdM4LkqM4Wa
	dRXU9TXW65FSeJw4cVRpoKCoTvJnfFkpgLdxD4qu5Xbg86u3blekf7LjpliFrhUo6y9LQ2mIdWw
	UiWm5zUzIscz1dW1xz3nHotXBe0h1xmT2LHnbTqMlRd/8eBx5W8rAg4td0CreELtZNF0NV3uEeJ
	nd3p25ZQoZiSMtlGl2FkTrI2geZnz/YxoYm5FMWq0DTllsYae3aE=
X-Received: by 2002:a05:600c:46d2:b0:485:364e:9328 with SMTP id 5b1f17b1804b1-48e51f32aebmr334680255e9.16.1778489599028;
        Mon, 11 May 2026 01:53:19 -0700 (PDT)
X-Received: by 2002:a05:600c:46d2:b0:485:364e:9328 with SMTP id 5b1f17b1804b1-48e51f32aebmr334679535e9.16.1778489598330;
        Mon, 11 May 2026 01:53:18 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e702e5516sm263733725e9.7.2026.05.11.01.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 01:53:17 -0700 (PDT)
Date: Mon, 11 May 2026 04:53:13 -0400
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
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v6 06/30] mm: use folio_zero_user for user pages in
 post_alloc_hook
Message-ID: <87e7ec6a9722ebe27a837a29781547d0d210147f.1778488966.git.mst@redhat.com>
References: <cover.1778488966.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778488966.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5ICPHcEbafXqFgU4QbTI3P3YXq6NC0ysYtS9frTwYEM_1778489600
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A4F3FA0008
X-Stat-Signature: mkot35k8ec97utky818irzrhbnxnkx7h
X-Rspam-User: 
X-HE-Tag: 1778489603-628158
X-HE-Meta: U2FsdGVkX1+g4dP2a//GHrtn3PJJOFRM4voYn+LCGtBtZUd6bTup/TKnhvkcP1bHEr5Yn+ZIOERncDDIyjOjyaVVOVHejb8TbLlvGr7BhXSxH3yNXsMn9N7dngJOID/TX1lnzIFtUCNRsdWbMlHiqE349Z+hNDdulvlkmw5h/pAA8+qwykeNTvYOUkHQEAeqxa0f60P5eD/o9xtIDXkE4gBjtL07kOL5wuTwJkRzkrh9KsWoLNVmmvBLvgzKu3te5BDOKWLIliCxxgeJR70XhQzAhqXYjYir0JgNzxHrxjcNS/jU7M8zPO2IQxL/5qam/D9f9LpWtL5n24tITXNYNH8Nqi0930nEgdhTIuuOGxcp3+Z0pLQua/KczVp93JzqEwXu/37NG+FedvAa58PBO34IZfMvQwFhCr3JHto5Gcmt8ylbAAEuhHu/Gc9SbaYM0PRSoe4u6YzUTJQRr88UGs5Ghiqml97db1C5KPrH3ri6XeINHQfb+hAXS2Je7om1YvWH31IwJaVzYLsIGWXfFtIxE4J97AN5d0WMcS3GN8FUChstPXowzvBYxlI9NzBt54g2xkjSwLzG47rTzi4ogaAUr851i7zNb7LlX1nkcWWd00v/WTCDGvG+oTvxetBqd0/UQKhO+qy4Fc5qU0qMbBcSOEi8KXEqJULseMK0eTJYi2N4W2L/921XvljHNcy/GxZdScQvofjdbiia4stAGXyPKm7kkyNSgo7AeIDQd2yYFV3ZAV6dDVdF5VpvAB4bE2AT8drovQcIDcx/smyvTWT90CE1TBEmZh1TSQd6rGy1RjzF+K1HargdrkQ5EIcWg6oTf8t2xhpOlvfyMc4Bph/MR39aUac49L/uVKAkDBiTboEsUel7Ofnqteprg0E7VQWqxfx+a+1udxktDxfTgNeD8BZrb5hzdQoWmHunoTkHgkbYfOWVYkGCOEE84z7UOnx4uXWt9lI8UcI12+A
 sRApc2zr
 QTVQEsA/f1P7SfhvRaFdJFApy2ZMSmj3wfC8PreF8cvRr0IVVS5bia/RQNDz16mgCkxK4LZ8BH2r7xPtr+mKpcMDcP0i42QD9GN98OtXMGMXmOP6OSiLeAIB5rRVwilrxeJ2kMOSG3ijJJmEe3Z1xvhM4Rb4GxFpKXaBA3p1kt1LkYbrHwm2k2+MhTIFMlg0eWswPWZ3vB9/F8YECtClu7ODvPnhu5AQEJtSGoPRpfUe7PWjBkTBSyZRdj3U8cmDyQSMrZRBCaus5MI+iFFCiPVNDiO62B7TLAwmvK4NKxtlsA0+51VPpHGsXdK1T3XaTj+jXTAqS/E+K0kwpqDG1qnlRJt0DfLhRr0J3R06xCUlCZtbqVW60WUpaKpAc+xBbwfyKzsUC0j46zM++xOtoqO1SyNRGPBUsm8I4IRc8v4nynYidV9ji6rHGc/GtTxekESUK
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
 mm/page_alloc.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f76d5271b5c6..842f5080d728 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1851,9 +1851,20 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 		for (i = 0; i != 1 << order; ++i)
 			page_kasan_tag_reset(page + i);
 	}
-	/* If memory is still not initialized, initialize it now. */
-	if (init)
-		kernel_init_pages(page, 1 << order);
+	/*
+	 * If memory is still not initialized, initialize it now.
+	 * When __GFP_ZERO was explicitly requested and user_addr is set,
+	 * use folio_zero_user() which zeros near the faulting address
+	 * last, keeping those cachelines hot.  For init_on_alloc, use
+	 * kernel_init_pages() to avoid unnecessary cache flush overhead
+	 * on architectures with virtually-indexed caches.
+	 */
+	if (init) {
+		if ((gfp_flags & __GFP_ZERO) && user_addr != USER_ADDR_NONE)
+			folio_zero_user(page_folio(page), user_addr);
+		else
+			kernel_init_pages(page, 1 << order);
+	}
 
 	set_page_owner(page, order, gfp_flags);
 	page_table_check_alloc(page, order);
-- 
MST


