Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F07E8CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:07:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 628916B00C0; Tue, 12 May 2026 17:07:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F9A06B00C2; Tue, 12 May 2026 17:07:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50F9D6B00C3; Tue, 12 May 2026 17:07:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F9D26B00C0
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:07:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 02DCA1C0499
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:07:13 +0000 (UTC)
X-FDA: 84760003188.15.00D3A8C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id AC8C140006
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:07:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JLdmbgyw;
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778620031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nFn1v/uAu4PP6s5g6sRwXKMfyXh1YJ87r2wzrnOTcOk=;
	b=mMDQHOf7W50fZ/AYxRS180UyGVhBYMGRIjPm2qAmODUXHeQtVacAkmux7gInseOOA8chI0
	9NUuZiisAGZGTf8Jgo1Hg+cB5t3Ad+QaWlrG1qHju5kYquKtUWi8cJBAjsllNWdj6Pp+zN
	1a2VHGC2ZFjXKnn7CHC6D9f1swNGFdo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778620031; a=rsa-sha256;
	cv=none;
	b=OaKHtZSzSKEvZPlqHNoxuMPFKv6rGqlYt78OmRktautlZGGPggidt01H9/VCWzJsd2DwTS
	ymsweGa3ljQwhqkbWqqpCHweWAmRhSSlEqcOZFMxt7GiDhErw1Q6Wrs4KCEo8j/QvC/uMW
	0HaxIdf6qxuZdgo1hE3BLjdFBUDWXdc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JLdmbgyw;
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778620031;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nFn1v/uAu4PP6s5g6sRwXKMfyXh1YJ87r2wzrnOTcOk=;
	b=JLdmbgywMVoU3HWP6rZmjerfQQf7sTiO+2HNE935+h9YVkMR8+IFLeJpYmIBr6xcUl6tOl
	GnfGWpnyWlWAMPjL36oVxe7X6napGdYkDmNmHjoU31Q00FurgQugPPZUBM7IO/Shty1knI
	xvq/Zs3xWqsyGEjgwrO2a99thnPmZ+0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-qH1wtq9ZMyyxavneEa-klg-1; Tue, 12 May 2026 17:07:06 -0400
X-MC-Unique: qH1wtq9ZMyyxavneEa-klg-1
X-Mimecast-MFC-AGG-ID: qH1wtq9ZMyyxavneEa-klg_1778620026
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48d0889c1ecso38184585e9.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:07:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778620025; x=1779224825;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nFn1v/uAu4PP6s5g6sRwXKMfyXh1YJ87r2wzrnOTcOk=;
        b=kjDBq0YFfIAg7JNOUYiPfn4zxYqujnYBJD7C4NqiWpTkZIfoZ0927HYtbV9LZPVJCn
         BT0FudUXRzWi0Lqv/d/sCOiWzDc1jN8q2+0OIFxe4gsm/8V1D7Sp7NS2+5HEKtpnwNRD
         nDCmd4smRhgPn9QYBA3he5xL+6v95Y7LyzrI/6uYmANLnS9ZWryfE1bM68PN/gmMmc0d
         h+U9PRMlQdw79we/KmuKir7hxB3vIjIzKhUPbKs0Stao0v3JzcH+PTUrfLWtVMrr39GH
         46GP1mji9gUz8ijd6H70ZTnJO0lNl8CoGFIOi5oAq0xMc30Jj0DkYVx0DA3k7LIgfYbG
         pK+A==
X-Forwarded-Encrypted: i=1; AFNElJ87lwHHkNgYKSYQrD9DwKyOakYMidy77thHQ9eYZk/742prSyqhdXhmr3tQm9AKgHc9Ot32enYxmw==@kvack.org
X-Gm-Message-State: AOJu0YyaLQWXhnBwCV7B10065ctxWmOlkwRwov5OgYMAI9CW/Iw3fGEN
	kow8aqRB3NDGRW/sqX11kG9Pld7s6wKrkH6vhT5cebxYwc2rJ+DSMgmUbtjOlSO2y7+6b5X+4J2
	nauZ+6PjuYe+R4YJwVzU6BTS4/Ra/CNr8m0TQ7lfvzg1WANriJoVV
X-Gm-Gg: Acq92OFbpYGrw7CkJ/nSE02VFROC9iS1yb79udld9X7B8rhguguhBLqv/oMZLF2WOFB
	si6nOlT644uq7aWj+ifImcpd75v4xEt8havitTlCed/McwZXFien0/XIxrJ53/TpUZxY6hzZc2f
	X8+ENBMlRVZX/PzBe5Z9Th7KViTJPsNwe4LgNA+74kYq8GVr/IAjL8Uodteop3a9VTfo9zHNoUG
	lnWwczBJw4qFLkwrLk5JX229O2CHMRBiyrRev3nH7n6UTuJVQDs7CQHGEaH9JOSIrQ7IW0EwQhj
	u7CVItIxAnk4r2STc7oisgCVSbVCSMkmAOV4uS4mkdXtt7aehg5lSm80kxuHP5d83vkd0zYDBAZ
	lpu6QCoO4M76HuYz0sps2Q0kRnEHy8xDFn9p+FOcX
X-Received: by 2002:a05:600c:3b20:b0:487:2439:b7c8 with SMTP id 5b1f17b1804b1-48fc9a029d4mr6486035e9.1.1778620025321;
        Tue, 12 May 2026 14:07:05 -0700 (PDT)
X-Received: by 2002:a05:600c:3b20:b0:487:2439:b7c8 with SMTP id 5b1f17b1804b1-48fc9a029d4mr6485625e9.1.1778620024852;
        Tue, 12 May 2026 14:07:04 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e8f42a845sm24872145e9.20.2026.05.12.14.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:07:03 -0700 (PDT)
Date: Tue, 12 May 2026 17:06:59 -0400
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
Subject: [PATCH v7 21/31] mm: page_alloc: clear PG_zeroed on buddy merge if
 not both zero
Message-ID: <f6573c9680357fe749cb578a4ecb1bd70ff50e32.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Mwke1zzU8EqgBiUBq0Pi7u2FU1zJPq5xdVoasNrNDLQ_1778620026
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AC8C140006
X-Stat-Signature: w7jf11huf87gfs6ynnsj5qynh47p1wcx
X-Rspam-User: 
X-HE-Tag: 1778620031-466236
X-HE-Meta: U2FsdGVkX19G/gPHYfbddx4vnB1B7yaiWq3nYPt30jS/5bVaZX7V8vGisTI6K7UMoVvmo9iB3Ug4a9t7lYYUVv0UsIgbLrGHV1yq8vnDqq8JrPYYLuKVcSL7WAs5N8hF6HrsZscZeeDaxvMQo15Mmh7bNNJ/2T7rLvySdS5wqcDk5FmcbUB9bEtb22C3PgE+P3xbKvh1/n25SY1mDtTNN0toonWeI4V/tGIeF19ytRGLzPLpOVm1IjdcIhvkgoOcIoTbtlq6ZwfytZ4K5lIiFXipFm+3Qjdjn3i3f5dbjWMcGvju0gjSDtlt7k1BG8OaqT5raN+0mX8coHL4jy/8+hjg85MaFxNgbaK+ga/X+/wHBtofKCQhBoqsdLNwzXaEYcBIttOvqtfcd0V2Kfd8ATeBRTvWysAcKES0zM4+obpw2TGkbU8qlmE67CN/42Z1/CvJ1AjBMkx5AITwaWGH9olp5966zavpHO9th8+sbtMqNiUx1XuOuY7NM62AAgqSygJANTj7Ti5yTmoJuqlOnmLWtv72aUsSkg1Sv1Eve3uzO82k49+5Yz0xQiTI/vPcGngxbd9Qb2hMlvGFEH0fXseATEDY0SCmH+QH6F3AR9hod9SCAjKU2qCh6Rbgw2WkQVrgSqiPaG4rDpXj6Rtk6jBmrC1aMeoikKZ4jDErN++HiC1nJfPALqvUK+sEtht5YYZKrzE44XqrprAyCcmCM9TDkIhu4yPtvEhJp+TDr7/Hf8FpHxCZSghP43y9jf+2EQhxvosgy/1chKeiNQrGE1yn3Sm9GASnPyvAJEkWkK7qS0x6kiWB2w3ZmBQw/W+kzGCrbJbRwAQveXNVrtOPEvVzoZdWVYqCDn6jAHulvOm3YV4rNXfmHIy/WiSo2t3Lhw56XcfTOkaa9nq54s9hhlfVmTLUtIntb5OZVmXnA1qlR1DpagMw/PQX8PWDlZC13i+L3hot3uAPOCz/TfU
 c1Fi2325
 et4ejQrMR1NxeTJAt5rbkQZJlZPWY0GOcwJSQpa6zfUrTMEl7q7Qb1IXGG/88mI7e8EhYommGYRmpeMNpM9K9uXWgweo+BkKep//mGqh33z2Dgm5w3+oxsxhSW/AiGsYVhiYvqvZoM2o/gP4fdPUAQ+afXY4xscW1QGy6pAj2P1oFhbU9oxdKPOsPYA7/XJZE4GEydXAf5HCQtzYOZcgl7YfWCDnhCj8qsxeoYFMyWz20ltLvvc2R2+tMttwFl2sjs2gYMHALuVVoNaX5MJnY5iI7jWgnzOXti4ZHTFQHWyhwawc+YWiC5Qgo/O/GY/VV8t/HXjsJ+cewk7yKfdvlqDpu37jiBur3gUEBL22EWn+uelgV+TphgtLHBgyqs+H/wspjjF7cUQ17abcjzZJ7khgdC/inj49Ue0M/SuFOqN9umUNOe7HBdfQSMOuaAxnKR4rNlfu0daprd5L1bAo6grWHpe1Z9LuzuKsYkEcdzHL1aFuuJtBazE5Tjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When two buddy pages merge in __free_one_page(), preserve
PG_zeroed on the merged page only if both buddies have the
flag set.  Otherwise clear it.

The merged page would inherit PG_zeroed, and a later __GFP_ZERO
allocation would skip zeroing stale data in the non-zero half.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/page_alloc.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bd3b909cacdf..d70c9ba6b329 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -940,10 +940,14 @@ static inline void __free_one_page(struct page *page,
 	unsigned long buddy_pfn = 0;
 	unsigned long combined_pfn;
 	struct page *buddy;
+	bool buddy_zeroed;
+	bool page_zeroed;
 	bool to_tail;
 
 	VM_BUG_ON(!zone_is_initialized(zone));
-	VM_BUG_ON_PAGE(page->flags.f & PAGE_FLAGS_CHECK_AT_PREP, page);
+	/* PG_zeroed (aliased to PG_private) is valid on free-list pages */
+	VM_BUG_ON_PAGE(page->flags.f &
+		       (PAGE_FLAGS_CHECK_AT_PREP & ~__PG_ZEROED), page);
 
 	VM_BUG_ON(migratetype == -1);
 	VM_BUG_ON_PAGE(pfn & ((1 << order) - 1), page);
@@ -978,6 +982,8 @@ static inline void __free_one_page(struct page *page,
 				goto done_merging;
 		}
 
+		buddy_zeroed = PageZeroed(buddy);
+
 		/*
 		 * Our buddy is free or it is CONFIG_DEBUG_PAGEALLOC guard page,
 		 * merge with it and move up one order.
@@ -996,10 +1002,17 @@ static inline void __free_one_page(struct page *page,
 			change_pageblock_range(buddy, order, migratetype);
 		}
 
+		page_zeroed = PageZeroed(page);
+		__ClearPageZeroed(page);
+		__ClearPageZeroed(buddy);
+
 		combined_pfn = buddy_pfn & pfn;
 		page = page + (combined_pfn - pfn);
 		pfn = combined_pfn;
 		order++;
+
+		if (page_zeroed && buddy_zeroed)
+			__SetPageZeroed(page);
 	}
 
 done_merging:
-- 
MST


