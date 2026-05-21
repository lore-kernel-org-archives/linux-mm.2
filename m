Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D761ACD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:09:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 156626B0093; Thu, 21 May 2026 10:09:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12DC66B0095; Thu, 21 May 2026 10:09:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 043B56B0096; Thu, 21 May 2026 10:09:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E84FA6B0093
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:09:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C6E61C14C8
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:09:27 +0000 (UTC)
X-FDA: 84791609574.16.7BDC569
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 695D3180009
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:09:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hLDDw+CE;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779372565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E82Z22wc78DWFtKs22Dwf10Uc2AV6EGoZcG/joqub6E=;
	b=S4OLOuJGF3qh9BliWq4btMB1sxrO8smy7HJlq8L7txyDIQ6zoCl3917Mn5OKaYZkNb9Kwr
	4J3G++A9AHEOCLQhMIvNlfRZuzbi6LuZz5h77i4+E46jBMShi0JtH9mfImtDGAgy05aabV
	K4M5Nv63+MuzscTpZ9GI18QZaOjO4sY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hLDDw+CE;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779372565; a=rsa-sha256;
	cv=none;
	b=K57zAVVsQqIFQSHpm1lURHQDTkEkX0FdUA8x1A8VX9dF64lnxgCYO0hm7U3PkHB8nVsi2t
	PCKgAHnJZjGewf//mA4HbcvL7NFn6oGyKBELcU+GW9BKD4UQtgmhY+EjDSLgDQyzY9hV1Z
	TSArRKB0ASys3LIGa+zb99dAhokny8E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779372564;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E82Z22wc78DWFtKs22Dwf10Uc2AV6EGoZcG/joqub6E=;
	b=hLDDw+CEsLZaLbT3UpK3+UR8IXL8gG/Mb3CdOeYy86iDg5PXaQLPRVoyLGFMNl0TrUG6oo
	yE/RYPrAf2nu7sFlyMsW6FwS3vJRFkpbxfWCvs7gL/jOo0t91UrCCEIoASKymTvvCFOFD1
	X2O7mS88dQAltv/glD7WUjSc7ddbEoU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-410-vzXiYDs2MLWj3Qe_ottFSA-1; Thu, 21 May 2026 10:09:19 -0400
X-MC-Unique: vzXiYDs2MLWj3Qe_ottFSA-1
X-Mimecast-MFC-AGG-ID: vzXiYDs2MLWj3Qe_ottFSA_1779372558
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-48fd2b502e2so53026975e9.2
        for <linux-mm@kvack.org>; Thu, 21 May 2026 07:09:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779372558; x=1779977358;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E82Z22wc78DWFtKs22Dwf10Uc2AV6EGoZcG/joqub6E=;
        b=Ltzo9M3ItSgmqGTdxIKOe2nQ1CftYUXUaNQij1gmzhkLY81PhvQ+NxDtRI2pZA0sEV
         9NXSawFU+dKonun96TVFfiihl1YleYRDeO1sEUG/HHQFnTPTXJyol2DJzVVmT/jvo6G6
         E3Z2/4wvhN7u3AkwULPeRzbTcDkL9sIugUof0kOnVrnn5lyZPrgjrarWLQDiq3Bbdrfs
         S35mjN8hDjx5Z7awfJ8Dq2cW56xe7gdPNxJ/jmClmOSsEOE8FKGj6cbIvUiG+nwYVEkL
         PFonCgSfRRmkfSjKlJ+MNDB8mJV4MM+rEDZoxJhlj0R4q1rk9iZnqdWcS1WCpmAu5DRs
         VZJQ==
X-Forwarded-Encrypted: i=1; AFNElJ/bnWwimztJXeLcZxdzjY75vxyHgKbkNc0OrH15dOUDoIBPlF50RdWXrWOXwi6R/jiATX3tgdCuJA==@kvack.org
X-Gm-Message-State: AOJu0YwbcrAP+Ye+ExZtp+fmn/XrC2Ekwmy4rKxZlFFzqwqVnaFQXnts
	yJWVDUSh3rL63uDQ0dG3VUU3RZjm+0bZ5NhufKoBVJFpQ+8qpfIPTtglWv7Ceu5Hu7cdAHg9338
	K+SHGfIBlVvuihFauBL8pQXL45R5QUoouRW5w9+wMxAelaUTpKRMW
X-Gm-Gg: Acq92OES2V/+kJcgNK0GaUp9ehxhgpsFBjTBTskn3iPIlKiEmxsdVnlBvR3zD252EPo
	6CKbR0kRwHe/HPAns2C1FWATwL63iyhzW4zHOxkUuBI6pfOlXNFC0pda7rb+WL5nnnxyAQF4yqM
	EMp0kNgCgE2p7jvLZotVerVujCbyr5o9yRnHDtVCxj4aMKkRLorF6bfmVS7zngfebYck5NRA1y/
	TMMuTZuYhPeeZ43es9kjiMIyzwjo5eP4EaUWDW9tFbX+3jfP3ZIFOiHXEizo6BfeR8XBMm6MOrY
	Jb4opjGLuMet87FVaWAVqn2TwDNqG96SEUaJfnkwiUnhRXF4rzfCPbGxndvxxZ7jWg7nXDTtJ2q
	wkgIobh+aV7AwXDGwzt401GogM2OZnL2teiD2JE04mKkD2giaNP2o6g==
X-Received: by 2002:a05:600c:4e92:b0:490:3b84:c106 with SMTP id 5b1f17b1804b1-4903b84c8ffmr34029845e9.26.1779372557729;
        Thu, 21 May 2026 07:09:17 -0700 (PDT)
X-Received: by 2002:a05:600c:4e92:b0:490:3b84:c106 with SMTP id 5b1f17b1804b1-4903b84c8ffmr34029025e9.26.1779372557076;
        Thu, 21 May 2026 07:09:17 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4903ad2ee77sm25394465e9.0.2026.05.21.07.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 07:09:16 -0700 (PDT)
Date: Thu, 21 May 2026 10:09:11 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
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
Subject: Re: [PATCH v8 00/37] mm/virtio: skip redundant zeroing of
 host-zeroed pages
Message-ID: <20260521100313-mutt-send-email-mst@kernel.org>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3nn3ZJ4poJbPPoyuZ8oTZJZqkC4Pg2nQ7cqH5_l2fWc_1779372558
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 695D3180009
X-Stat-Signature: m7fsqzyyae4e9nizf7ftizxzqdbmua8b
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779372565-957106
X-HE-Meta: U2FsdGVkX1/ZL381r3WWqjvho7VjEbJsgp4ydzQahws/3YmsHtxVZyv9/84tJTYg0wqgvUOX/HmcMZn4k2gw7PpzL6U250nFCx+jFGTDKCEBf+YhZEH+8St8NvdYVpMT3hZEyV0NBt0GnhjJIOMjDjkNwxxFSVokVKXyOhB3dkgzDzxlNjU4Wj97X7tnnR4Ztrx+hBoEM/Dq2yGbDqMKLS4jzei1orxeAHnlv+T25cDnbHKqVNPo1sYBedI8NFM73D6rc60e0CQOfpRKVmEqFavKb2FXoWt/0YlKWK0CsoGsMeWDv+A4x2ITP4wbQiTFoUmXcPXnHrOufvdNgSkCugZltJvdncWjxgGFum38R3CzG/fI+LzY2X9BsUJBd+XhcDtx0LZr6s3Td7U2rkCCleWdZiWbOwFHeUd82zbaTMlQr8Q6AvUHqf4/1eJbPTYkjbEFSSb8PNlsHTsjxdohZZ59j895oh9q6sQfd7zYvlFsQDYhUe2H5LdAVY4HQQqr5u/yR0s3g8m5+5IKh4Eq24uJg0HbOgIGxSfRf3vGCTcX7wuZUG+9/1fty0elPupLxW9bDrm98geqVYA13aS1QFYf5V36uGFL1hQ0lDxnM0U3g7HoMy33NXvEl9N8+GtXbLABKGCJ23JhsUYpKm92YqdAVjZ+r7JA/7v/ty3d+PxjnPgxD8ka6LnfxZHIQhQTgAxPFa/l+Bqe4W8JcktKE8nXFBrksESSxW+1FbUOylaAuw5dedukP6cuIn5BwkTFKgiZjZ8d7VKgjFcCbYr4AlsG7vobXGRk13PCkb/qTOQY02ym482HL6X/T4blql2vzs6YwRidzI6NsMMpSwOHjgBME6Q6C5m0NFC3Cm8NB21lZgiH6NvB5+BDw97hrcBa76edAS0hph+pgC6v0YkNk2iommPTqiDoo+KXjegCnwigt/wrP2EL1nAWpZk7sGc6sjCOC2x5OLcjk+dc3h3
 xr5SHdNL
 F5jF3+p2spTk9sTWbCqnNk9yRspyBfi0gpQNvRBh7WWe952KpFVPOMbUYuqxx1oGVaenhx8R+W4IOjgBJqGUh82tuSjM8Vk3+FAN4DEZrtGuKGRJ9IPOjk9vfZj0IOApv6eJ8XdB7dQsCEDRZ/K0Ls7gbw+ftXE4OO/45vgCKq+27s58xKsXlzB2GMpYkWPzIy1uq8XGz8ILN/bjgi0KG9W0gMOWvOjEelFvzes01SxM6Ogbog3jsUkyhM9hYNt75ojQkg18KgQFbyOhQWxI0LkevA8BPMLekX6Od27rXoHoGv28eFIkG6DyNt4O24lV+KGINZX0TaOgs8Uu+bBRU39lCaDWoYYfo+62o6dTGZuezia4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 06:20:13PM -0400, Michael S. Tsirkin wrote:
> When a guest reports free pages to the hypervisor via virtio-balloon's
> free page reporting, the host typically zeros those pages when reclaiming
> their backing memory (e.g., via MADV_DONTNEED on anonymous mappings).
> When the guest later reallocates those pages, the kernel zeros them
> again, redundantly.

FYI Sashiko reported a couple of issues. Mostly false positives but
I tweaked commit log to make it clearer. But also a couple of
real issues. So far I have this diff on top:

--->

Changes from v8 to v9 candidate (code only):

1. mm/mempolicy.c (patch 1: mm: mempolicy: fix interleave index calculation)
   Combine vm_pgoff and VMA offset into a single expression before
   shifting, fixing carry loss for file-backed VMAs with unaligned
   vm_pgoff.

2. mm/memory-failure.c (patch 2: mm: memory-failure: serialize TestSetPageHWPoison with zone->lock)
   Wrap ClearPageHWPoison in retry path with zone->lock too.

3. mm/huge_memory.c (patch 19: mm: use __GFP_ZERO in vma_alloc_anon_folio_pmd)
   Fix stale comment: "folio_zero_user writes" -> "page zeroing".

4. mm/page_reporting.c (patch 4: mm: page_reporting: allow driver to set batch capacity)
   Drop rounddown_pow_of_two: compiler cannot optimize division
   by runtime variable anyway, and rounding halves batch size for
   non-power-of-2 capacity values.

Commit log improvements (no code change):
- Patch 1: rewritten to explain new single-expression formula (fixes patch 1)
- Patch 2: mention ClearPageHWPoison in retry path (fixes patch 2)
- Patch 4: drop "rounded down to a power of 2" (fixes patch 4)
- Patch 10: "stub" wording simplified (fixes patch 10)
- Patch 22: note PG_zeroed hint loss is harmless (fixes patch 22)
- Patch 23: add PowerPC note (fixes patch 23)
- Patch 28: explain DEVICE_INIT_ON_INFLATE is a follow-up (fixes patch 28)
- Patch 29: explain flush over-reporting is by design (fixes patch 29)
- Patch 33: note __SetPageZeroed is safe on frozen pages (fixes patch 33)
- Patch 36: note __SetPageZeroed is safe on balloon-owned pages (fixes patch 36)

---

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9845c920c29c..4978d34532ea 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1358,7 +1358,7 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 
 	/*
 	 * The memory barrier inside __folio_mark_uptodate makes sure that
-	 * folio_zero_user writes become visible before the set_pmd_at()
+	 * page zeroing becomes visible before the set_pmd_at()
 	 * write.
 	 */
 	__folio_mark_uptodate(folio);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index a6b61172dd13..d106f2c135c7 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2426,7 +2426,9 @@ int memory_failure(unsigned long pfn, int flags)
 			} else {
 				/* We lost the race, try again */
 				if (retry) {
+					spin_lock_irqsave(&zone->lock, mf_flags);
 					ClearPageHWPoison(p);
+					spin_unlock_irqrestore(&zone->lock, mf_flags);
 					retry = false;
 					goto try_again;
 				}
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index ea3043e0075b..f573ff32e94d 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2048,9 +2048,9 @@ struct mempolicy *get_vma_policy(struct vm_area_struct *vma,
 		pol = get_task_policy(current);
 	if (pol->mode == MPOL_INTERLEAVE ||
 	    pol->mode == MPOL_WEIGHTED_INTERLEAVE) {
-		*ilx += vma->vm_pgoff >> order;
-		*ilx += (addr >> (PAGE_SHIFT + order)) -
-			(vma->vm_start >> (PAGE_SHIFT + order));
+		*ilx += (vma->vm_pgoff +
+			(addr >> PAGE_SHIFT) -
+			(vma->vm_start >> PAGE_SHIFT)) >> order;
 	}
 	return pol;
 }
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index 8b278a494ea5..3f584f538c68 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -443,9 +443,6 @@ int page_reporting_register(struct page_reporting_dev_info *prdev)
 	if (!prdev->capacity || prdev->capacity > PAGE_REPORTING_CAPACITY)
 		prdev->capacity = PAGE_REPORTING_CAPACITY;
 
-	/* Power of 2 so division by capacity in the budget calc is cheap */
-	prdev->capacity = rounddown_pow_of_two(prdev->capacity);
-
 	/* initialize state and work structures */
 	atomic_set(&prdev->state, PAGE_REPORTING_IDLE);
 	INIT_DELAYED_WORK(&prdev->work, &page_reporting_process);


