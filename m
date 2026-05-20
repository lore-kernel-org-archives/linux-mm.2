Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94E0CCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:23:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D36D6B00CC; Wed, 20 May 2026 18:23:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AB726B00CD; Wed, 20 May 2026 18:23:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F03F26B00CE; Wed, 20 May 2026 18:23:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0B6D6B00CC
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:23:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B2C271C01A0
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:23:38 +0000 (UTC)
X-FDA: 84789226116.10.599072E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7AEE910000F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:23:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TmRcakAB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RfirkbM5TmZ61fE0cxqW40X8dDTC2oX5xU5kp1FvlUs=;
	b=jSvMMMFMi6QKBuZNQV8W6JVEL5s6Az61Ucw0XuZwrybMnC8VFbDdrZpOZiCfAaB1j87lfI
	PbtOUklbRmt6PmpvHeFteZomugJfBYS1r0Nq8v875IhpMUYVGwYpk5LbHI+F7kShOXWOAi
	YNnZKdUJXDkFgltlPB2/mxtQ9TasUSE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315816; a=rsa-sha256;
	cv=none;
	b=Xm7uy6r64+OEzjbUQn5mPKkWahebedRXlsv6+JJilepQxJ+JkIr6Pv9eMA3lVUgRMrdfoz
	23Ui5ol6k3h2hFq4xrFdUV6yTTIBubUpQTWtACir/E4dG0S+5QCqi4lZIGRopyNC6Q/9NQ
	PO+Uf0cMwckWfthAboB9q33D/cW1ZSQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TmRcakAB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RfirkbM5TmZ61fE0cxqW40X8dDTC2oX5xU5kp1FvlUs=;
	b=TmRcakAB4PHoHPG1fxKOEDtmjPwp/e8HnjMPrOuX8tlA8XEvjGtApDskZHd19DZ9gG6wS2
	BzJ60VhLpzxBOOw/T23Etk4RrXgNVbgRwNlowgjUAajK0/NlchrXoE562SiaWNSn8+gr3F
	5FKpGnKiNkc5HqqyKrKst3hOuZvVa98=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-46-u5VguVXXPm6aiVgMLUbh3A-1; Wed, 20 May 2026 18:23:34 -0400
X-MC-Unique: u5VguVXXPm6aiVgMLUbh3A-1
X-Mimecast-MFC-AGG-ID: u5VguVXXPm6aiVgMLUbh3A_1779315814
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48feb0298d7so42271675e9.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:23:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315813; x=1779920613;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RfirkbM5TmZ61fE0cxqW40X8dDTC2oX5xU5kp1FvlUs=;
        b=aVGwrPRb9y59Qs4k157cDlLq9b49IfRB709cWoKaiRhSYNwdjX7MH2r9zsqessgfiD
         d/yk/M+nZCUK9PMgMUg4ParPVh8ZkCOOKfTGEKv7dyiMU6RYxyia8AGns01AVh7WPkRL
         4a9CZqXMNlmHhMJ5gkCv8raWPgIWHIzbnqFd+Jowol+tXF41Weet21Caw0sTR+mWwRi/
         Lg0pQOj+tU5Hr71VZ60/3MhuMQ//f9BKYW+pz18RS+OAakqrmJxVqZRNFCdK5/cY92IW
         S6cPW1jenHKe5zb9wgaVfeIzv15f50nGsmAU/4P6RMa+SppnqfXmkYU1wrNiSRAsdMCy
         fh/g==
X-Forwarded-Encrypted: i=1; AFNElJ/TQg+O3/3VpvvF2Xagf9HatDDLSK70yPp/rUfPRh0hRh73Db6UUcXs3NgPtnUwJhlmjWhHgoDhXQ==@kvack.org
X-Gm-Message-State: AOJu0YyzhyKQu79LowzV6QLuTA5zBZDuM++K6YoAC+X1SX/cwOhFkIIr
	nPeDgXWbH3nbWxhuWFaHhvFjOpYW59YfiwXnFAsS/zOel7Ao1N0k8lcQcd23XrCoL2J0Ww5gKzQ
	c1Tv+Nxr7XRdVJ1meJSjZvj5UHqMOcUuGTJBbDy+JsBa4P1j5tS+M
X-Gm-Gg: Acq92OGXuF6ko72h5nqkpQO7Ka7ghoxach77R+0iUvq1ef2QpY4LZVZNY9wWABeBTRo
	zDe4QlrqSRZMB/l3ixVoG3oVIFop9wNO6vm6v7ItQNjApquTPu9BfMSwyqOAQ0eirP8D71MDmbT
	uaLrQFD5zk6YmW975vxw/RRKrG+GfOflSXI67+bXt/aWhvaC/IYOA3TOaTFzSJskJWlR8+7hA03
	VHVzym0qZvUGcpIVD2FbyOQOHKa2kgo17Ol9MOYB4zZQa2b5wInP84hHnJO1NKl3kWddaMmaY/U
	ywF5OMFdMI+BJhMT+HRTj+3tE9TZCY0AJ1sxc4Rd5/HGU7cVFWH8r0wBWfDH02kR82yKDndPOut
	pY8lTTy4PLWZnUyFTG9O3IymBQQg5/QFpotSWX5VLh/k=
X-Received: by 2002:a05:600c:848d:b0:48e:635a:18d7 with SMTP id 5b1f17b1804b1-49035fbaad0mr3145025e9.0.1779315813458;
        Wed, 20 May 2026 15:23:33 -0700 (PDT)
X-Received: by 2002:a05:600c:848d:b0:48e:635a:18d7 with SMTP id 5b1f17b1804b1-49035fbaad0mr3144455e9.0.1779315812865;
        Wed, 20 May 2026 15:23:32 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49033d8e24bsm20927915e9.10.2026.05.20.15.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:23:32 -0700 (PDT)
Date: Wed, 20 May 2026 18:23:27 -0400
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
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Youngjun Park <youngjun.park@lge.com>
Subject: [PATCH v8 35/37] mm: add put_page_zeroed and folio_put_zeroed
Message-ID: <db4fe54453847ef5cd8ab45668edf5039c72881e.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: A5SEq9xuNWKWFDCbOHrQREdMGxqsQe-I0YRsBh2XqfY_1779315814
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 7AEE910000F
X-Rspamd-Server: rspam04
X-Stat-Signature: 8qzdacaw8r98t4mjas743d3eamo6w7oc
X-HE-Tag: 1779315816-492892
X-HE-Meta: U2FsdGVkX1/0guEcEU1n+VJtnBXMIkib+Ta8DLigiIhfUEZPgMZWHPzHcbFAk4dZ7t3PLimi3CKsSFlMC5jvv7FbSuKievnkrPqg7UNHZHAgwc68d1SmqwP8HmSzFaPD252jshgS1iejyN9gn1Y5osfdMeP95KJpshRT5jcZBKXat6ev3Jyq346O+QGvJKqYJ2hHHExYPBM7Ulb/hiz2MwccT/JgetZcT2BaYs+nS+mfC8n3FMTBcLbtosRvZYFpzsveNuK48sC7VdY49Q5ZTF9aFnRb5iUQqE6aet7SK6ZrRwtODx50bpjlKi0pwCbhVIdzSoV7FGbgonIl+MnRkLAUx7r8CuBGQ4LqRwse+5bzKlgz7iE/+2rpnSvVtvan0HYNmTyMdWRavDlP4jk2GcEEhX0yoeG+IK2YhpAgL2E0RDVO6utxWr6WEgNM1PV3aYdSgIVvilPcnKhwQkG2mTVGSBhzF0gzZl50YC6gw1nFSH7RigGIRPyUH3f2raz1qWNSzpKGJ+n0JCoQSXepn29n4rcB3qVeNQAKa4vMO6hB7KM39EvP1Okt+Q+3d2ulpRW9nxpBRFuVe4YNo8b6NTEdqHwrhZxhgPnkERbYnYLxHwAVLZRFM8NnxAlWWU2A5CGTNhEFIDhjiqmMwMh6zlmtYaWoI2dQibGbBRFE+Pf/qTj/FDTCJ/1gy7lGEoSoGLs4elLvNiIs5kP3VgA3+dsvoN/HqKIzGe+n8jO6bzodDRJpY2sBw/RXVuGUP4P8KXl17lBh7Psy9UrC7ZQ1C0z2p8MLiu9uPPyVXQOQSdnPhG5yObrl0n8dwaHGjontJ/c0D7r6qu/gX9vIqFWkHEAc5WlWFntpQj8oec+Nl5cuY0JdRcnQ+OjewkLajZIlK3oNAZcEt63FsmDnKZ8umRp9id1w/YIkrFenXkLu0PGrJ1kDNpLukPv8T7W/QY/MD2Rix233smCDQFFHrpm
 eTUHXvvG
 i/+/TYScaRzw2VqBHFGxGo0JudHyNkiOUA/awl0ogyS2++ugUKDF/fcqZZqq4wdFcp1YKEL7x1Me80ytAtVpsAT8IjAvdHY2bGRUx3mXIQdtBoyPPHZY3LAuyGQY5ImwkQuGQyEpcGVhJS767jWkj/Hoeki2XGO9GsU0hviqs3Hgoh533+nbE4dne+Q9gJg65huTeOl6M2beLQFc6GWaaaK8fvUJpuFemDyNnQy7csmZwy/5Nugp/yWh8HN/MABptRl307UAycWLKFSAoL4GYh5/3LxPWzfy3wU61Eh/6dIACXEWgBRlcmVmGv7+F0DAAqebceOYHXvHwAXcQAXspn8lmBfJh4QwuB3ak2FOr6ScbZKawbSDbJKSA5SG1igjfXBeGK4XmjXaPpvO5uGhwjLtzAc2M2EyhRhElW+Ghxe5ba9764x8sjq7e2WwDfsRGV0Fiaw9hBbg7ulJlY14YYB4GDMW/MOsPDFMN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add put_page_zeroed() / folio_put_zeroed() for callers that hold
a reference to a page known to be zeroed.

If this drops the last reference, the zeroed hint is
propagated to the buddy allocator.  If someone else still holds a
reference, the hint is simply lost - this is best-effort.

This is useful for balloon drivers during deflation: the host
has already zeroed the pages, and the balloon is typically the
sole owner.  But if the page happens to be shared, silently
dropping the hint is safe and avoids the need for callers to
check the refcount.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/mm.h | 13 +++++++++++++
 mm/swap.c          | 20 ++++++++++++++++++--
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d1e768dcda13..86638ffaad01 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1913,6 +1913,7 @@ static inline struct folio *virt_to_folio(const void *x)
 }
 
 void __folio_put(struct folio *folio);
+void __folio_put_zeroed(struct folio *folio);
 
 void split_page(struct page *page, unsigned int order);
 void folio_copy(struct folio *dst, struct folio *src);
@@ -2090,6 +2091,18 @@ static inline void folio_put(struct folio *folio)
 		__folio_put(folio);
 }
 
+/* Caller must be sole owner to guarantee page is still zero */
+static inline void folio_put_zeroed(struct folio *folio)
+{
+	if (folio_put_testzero(folio))
+		__folio_put_zeroed(folio);
+}
+
+static inline void put_page_zeroed(struct page *page)
+{
+	folio_put_zeroed(page_folio(page));
+}
+
 /**
  * folio_put_refs - Reduce the reference count on a folio.
  * @folio: The folio.
diff --git a/mm/swap.c b/mm/swap.c
index 5cc44f0de987..ecec780172ad 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -94,13 +94,15 @@ static void page_cache_release(struct folio *folio)
 		lruvec_unlock_irqrestore(lruvec, flags);
 }
 
-void __folio_put(struct folio *folio)
+static void ___folio_put(struct folio *folio, bool zeroed)
 {
+	/* zeroed hint ignored for now, no current user */
 	if (unlikely(folio_is_zone_device(folio))) {
 		free_zone_device_folio(folio);
 		return;
 	}
 
+	/* zeroed hint ignored for now, no current user */
 	if (folio_test_hugetlb(folio)) {
 		free_huge_folio(folio);
 		return;
@@ -109,10 +111,24 @@ void __folio_put(struct folio *folio)
 	page_cache_release(folio);
 	folio_unqueue_deferred_split(folio);
 	mem_cgroup_uncharge(folio);
-	free_frozen_pages(&folio->page, folio_order(folio));
+	if (zeroed)
+		free_frozen_pages_zeroed(&folio->page, folio_order(folio));
+	else
+		free_frozen_pages(&folio->page, folio_order(folio));
+}
+
+void __folio_put(struct folio *folio)
+{
+	___folio_put(folio, false);
 }
 EXPORT_SYMBOL(__folio_put);
 
+void __folio_put_zeroed(struct folio *folio)
+{
+	___folio_put(folio, true);
+}
+EXPORT_SYMBOL(__folio_put_zeroed);
+
 typedef void (*move_fn_t)(struct lruvec *lruvec, struct folio *folio);
 
 static void lru_add(struct lruvec *lruvec, struct folio *folio)
-- 
MST


