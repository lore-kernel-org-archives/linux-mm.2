Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F455CCD1AB
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 12:59:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02F308E0025; Tue, 21 Oct 2025 08:59:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F21688E002F; Tue, 21 Oct 2025 08:59:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3B718E0025; Tue, 21 Oct 2025 08:59:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A1188E002F
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:59:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 56D1758FD9
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:59:51 +0000 (UTC)
X-FDA: 84022128582.07.A3FC531
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 23C66C0009
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:59:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="L8E5Ey5/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761051589; a=rsa-sha256;
	cv=none;
	b=yzkz9nmEmQtmbG+rVs6FExVCLgWjQNDnNIdbSnUPlTU6IeKn8BrKzbP9oRiwyme2OQ9d+K
	SXhKkZ8Sn6watCU/OkidkWn/imtsv+xhf0T29PE4/cfOp/ebTN9DO6io9+/vFoyG3fAy3F
	2RqQNTDnH32eJ4Ryj+xgkVIxAt/ppz0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="L8E5Ey5/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761051589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sUyqikpnRIZJJ7+CBYLr21ot5Ik6tImIDaS0WggNCzg=;
	b=AnPwHRonmvGciTW12dzOgLTsDBUJqIyTsroFcqaqyFNytd3nlCx7lM7yLfJ7PzQaDk6iZD
	Zt5ZvpQotW1jQ+nx0TjT8MbG6Bs5hj33vCr00eXWZOUIb/RifPoJt1mExkLTJXxrc8jNxW
	1st2Z1O1hNFx/iHhsej+N40keas+Lkw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761051588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sUyqikpnRIZJJ7+CBYLr21ot5Ik6tImIDaS0WggNCzg=;
	b=L8E5Ey5/IbOLpLi+Xco8mKfedcmTLgEjBLb/Bhsrfx8v9IpExu8896wemDS/VsEcYUosmG
	EIAl6y/8QfB+EIaS3Net9eHmLnCBr8I77wS9H1s+4OXov+LApPCzMwWsNRTRrWOV18d185
	KN5c11mnhS8AeUZTpZgnE09MF+nnQz0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-8VANqDr-OCyvodFIqBGEIA-1; Tue, 21 Oct 2025 08:59:47 -0400
X-MC-Unique: 8VANqDr-OCyvodFIqBGEIA-1
X-Mimecast-MFC-AGG-ID: 8VANqDr-OCyvodFIqBGEIA_1761051586
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-471144baa7eso23776885e9.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:59:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761051583; x=1761656383;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sUyqikpnRIZJJ7+CBYLr21ot5Ik6tImIDaS0WggNCzg=;
        b=C4cD4Mf9K4BDx6pMUzEx0vmqTd8s2weZtHi8awH3q85Px3D+i1kjjXXdnYNIl4Zivo
         UBXgToG4n1/vwqHN2kd4Y5DH2DkLPB1kjt54lpVH+MXeNPzSQgoPnhbY1+kP3vwp7JbS
         KNOe3FeRQh1+F4f/1X7SHoOlHPoyeBvEqGVWRNiclIqbDCa02SYIga5zM2rem2Z57dZ/
         VkajiMSQDPFDckkGMhbGqShlEhOdGklNKdvTF/qj7oFXfIIFfuM0VXNEm11coWsJCxM2
         5gWHRR20YxYURSe/8FBkCf+uv5vltQIglg2Jn2KRt6vwe2CUUPOUtH8g1ZJNnrl8wjr3
         uP6Q==
X-Gm-Message-State: AOJu0YzW8BWiV2DMOi5vg/9IS5iVRyLJxdjNAtUcV2syNKwdvmSpBfrO
	qf0yFfE1sQVigK5lST0Ua1e9lTPNFc2AspTXtxO8/9JzhNMHbWX4jl8aww8teXnPKem6DQdX5oL
	468bpnF4YbJ/lcABz31wENN8CR1jGjpD7bmZMAHez0l8ylB3WkmI7
X-Gm-Gg: ASbGncvaj+gFZdRb8737kQojNV0RAXFPDrtGFKi/IVZ8fVb/Ch7GSPtx575/6B1rVDw
	eNC5prgmEyS26uiYr2ImQttUcyeGap16oRZgihL6JxkmQ4+tPA/8xaT+MW3zrFzZV1KQUUWVJmg
	DCuHWkOxo3a3+LZ3mfyVcxkDtMPxwHwh4Rax6U5J+n8Q9zEFmWSCADtvxmptYfKzrP7jpt/pVUV
	NIPjrCvJfrqYEz/2dan5nvSY4bhea9Ui5JvoMcjgHc8I0GcO1fvzRq/0n6mOgkLU9AlOysVfQbF
	T0IO0uJbA6Ccm5DdxFKvMzU9cff2VlBL3AoIFmDrGonKYvB/x7bxS5hCEtmbzweCc7bD82reABv
	cjuYsdyb1hH4on0PYPfdxt8w9WgRKYyZhqJ50Ie5cZ9d1wyHVi55LFkJo8xn2
X-Received: by 2002:a05:6000:26d1:b0:3ec:db0a:464c with SMTP id ffacd0b85a97d-42704dc94a0mr12883699f8f.44.1761051583507;
        Tue, 21 Oct 2025 05:59:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGQe5sfmvBNGfARqbQvLIETNCNFniX0I3Wgmf7ZO8nqCKClSavcBGyNI7STnbkUGhrMC20EJA==
X-Received: by 2002:a05:6000:26d1:b0:3ec:db0a:464c with SMTP id ffacd0b85a97d-42704dc94a0mr12883652f8f.44.1761051583045;
        Tue, 21 Oct 2025 05:59:43 -0700 (PDT)
Received: from localhost (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-427ea5b3acfsm20082945f8f.14.2025.10.21.05.59.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 05:59:42 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v1 05/23] mm/balloon_compaction: centralize adjust_managed_page_count() handling
Date: Tue, 21 Oct 2025 14:59:10 +0200
Message-ID: <20251021125929.377194-6-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021125929.377194-1-david@redhat.com>
References: <20251021125929.377194-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Wpnle9qApzOkjX1D_hDmY-CdsZzfKtoNA-FqxyeGXxo_1761051586
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 23C66C0009
X-Stat-Signature: xoy3x5ktfou56ak3wykx389q4qsm4dbt
X-HE-Tag: 1761051588-217418
X-HE-Meta: U2FsdGVkX1+KWIXClEesOK/znNhGVvZSCsotNWbPE1ik5Qfiwo+bgmVZ1Dle7nG0N+BHDeSzFhBrDhmm7jVvv1v7MYsK69ZgHQors8FLGZcQjOt3vc/EjWYuiQjdMUEYAzCpWaqm6cc7h1eFwfBveizpemRi4G13Cz2Kzcgt713qKl1Te/yJc8vVOWhLEE0fqtM3PWWNqhEU8z98KFJrDx+Gy6soA3/b3flkSkw4O6rb9mOrlgTOtmpkE9cIV2rHrLFBJh8PZS2SIYddsHtdFiF9xAea9U8klTrLUFaBPXBe0IYgoSPRn73KOJclDAM30SfIJ2gDBIRXE9hdMoILLQpB41JHi7s+QbwOG20cUu/USnPJ1ZHexY9QeC7vr57l9j4wE5iPo5KCwusaq+hT1wisl3RYxtHpaoHSzwiALyXrEDI4DdfoONtXFe5uvHvMzcMXZElUZz3fykInus8GJC/Rfstj9p01YTUFIfSyxuOle5t/D1PTeUIKatc6MT8WSiNAEeUFIlfjsXkInoBpjqqRxoRkyg0AAiFh8mOV/SnD5bSwnRlk3tu2BH0FZsh417dzsMsdxxXMXr+AV7WNRByzswwQV9h/5gzq0IeRv1AMDhdm6Em1QyNn97/JZ8E4G8nRqTjrlDXE4m1f5p6csUraMyXHj+QVaurFk8lXOgeRBDmW8oVdUvB81QPpzauK+V0bTYGQZijQ4dOWCFpy4czuup8eWYX2EdofqJDVw7nj4T9jGKUkIShVHLhij3Orkq03rt3yZLuUcu0eF2fyFomFMU3BopAgHJ9kZSw2CugDeSLlLED9Wk+y19ysVzGD8iXNUfDVRFUThrIi1x7PWzpIbvikrQ8s80kUdpRmAJaKvb640izq5fZDEyBSXRGJkz67f8cX5pSMQY6+EeahfzdzEwSXUNMtJS6NxqlQN8orGfyVevFVYNkuOpC7iI33gyyGo5LzNIceKdCCkro
 11AHSkVz
 kTzCxlD1u/bfBQhBFwdO0vBCNzO5dG64eDT2B9ixtjTc7YXbyGunrGcnV/cqUD1oHmaelDsrjWUem9hVnAc4B/dlBx6LAxMGkbZ8QCIlFCTPEnDD1P3GmOhRkA1r+Ybs4oPLIgGShMl74SXq20XSFo40awqrI5OR709JsiPSeVA89/2SAkLg/BT64f9/fTCj5lEaMS4KGjblUMx3R+uHXOskSy2BHFY9XasNWYNpTorgaGNIwK+g2+sR2tIW3t5hCcS+OoLhX7ctXVpBdEeN3eZ6U4h082Po5Wemr5huLyLnNAd0TNv3ihkIi2DWC1ygvRSDoQwpT9HaChYfoSXTP8ebbG98dQ6cDV6ACfQt0sCLMpWRblaQ6aousHZ6kO/t/f5fKoF6O6JPPBTqK3W7U2Tet7U9uJsU0JtfNhebH12Z2Ix3zaqUOoPiYYElOZpvSVjBVfBlNBlIaMzYIv6QTdamXINN5I0GBi9iPi2thYvpDk293j6wZG42026XO47LS89vXiMZPH3D51du9uFsGpAkSr0kzAmVfo/rkaTSp6c7yib3T2NcEOoBFfpbe1NiOROIIqV6VJj1DKoIDXJdu1/LNDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's centralize it, by allowing for the driver to enable this handling
through a new flag (bool for now) in the balloon device info.

Note that we now adjust the counter when adding/removing a page into the
balloon list: when removing a page to deflate it, it will now happen
before the driver communicated with hypervisor, not afterwards.

This shouldn't make a difference in practice.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/powerpc/platforms/pseries/cmm.c | 13 +------------
 drivers/virtio/virtio_balloon.c      | 19 ++-----------------
 include/linux/balloon_compaction.h   |  2 ++
 mm/balloon_compaction.c              | 17 +++++++++++++++++
 4 files changed, 22 insertions(+), 29 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/cmm.c b/arch/powerpc/platforms/pseries/cmm.c
index 07b21d2bc8a78..9ed71683ae402 100644
--- a/arch/powerpc/platforms/pseries/cmm.c
+++ b/arch/powerpc/platforms/pseries/cmm.c
@@ -165,7 +165,6 @@ static long cmm_alloc_pages(long nr)
 
 		balloon_page_enqueue(&b_dev_info, page);
 		atomic_long_inc(&loaned_pages);
-		adjust_managed_page_count(page, -1);
 		nr--;
 	}
 
@@ -190,7 +189,6 @@ static long cmm_free_pages(long nr)
 		if (!page)
 			break;
 		plpar_page_set_active(page);
-		adjust_managed_page_count(page, 1);
 		__free_page(page);
 		atomic_long_dec(&loaned_pages);
 		nr--;
@@ -515,16 +513,6 @@ static int cmm_migratepage(struct balloon_dev_info *b_dev_info,
 		return -EBUSY;
 	}
 
-	/*
-	 * When we migrate a page to a different zone, we have to fixup the
-	 * count of both involved zones as we adjusted the managed page count
-	 * when inflating.
-	 */
-	if (page_zone(page) != page_zone(newpage)) {
-		adjust_managed_page_count(page, 1);
-		adjust_managed_page_count(newpage, -1);
-	}
-
 	/*
 	 * activate/"deflate" the old page. We ignore any errors just like the
 	 * other callers.
@@ -551,6 +539,7 @@ static int cmm_init(void)
 		return -EOPNOTSUPP;
 
 	balloon_devinfo_init(&b_dev_info);
+	b_dev_info.adjust_managed_page_count = true;
 	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
 		b_dev_info.migratepage = cmm_migratepage;
 
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 8969271581bca..f7d6a4a6e54f5 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -274,9 +274,6 @@ static unsigned int fill_balloon(struct virtio_balloon *vb, size_t num)
 
 		set_page_pfns(vb, vb->pfns + vb->num_pfns, page);
 		vb->num_pages += VIRTIO_BALLOON_PAGES_PER_PAGE;
-		if (!virtio_has_feature(vb->vdev,
-					VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
-			adjust_managed_page_count(page, -1);
 		vb->num_pfns += VIRTIO_BALLOON_PAGES_PER_PAGE;
 	}
 
@@ -295,9 +292,6 @@ static void release_pages_balloon(struct virtio_balloon *vb,
 	struct page *page, *next;
 
 	list_for_each_entry_safe(page, next, pages, lru) {
-		if (!virtio_has_feature(vb->vdev,
-					VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
-			adjust_managed_page_count(page, 1);
 		list_del(&page->lru);
 		put_page(page); /* balloon reference */
 	}
@@ -839,17 +833,6 @@ static int virtballoon_migratepage(struct balloon_dev_info *vb_dev_info,
 	if (!mutex_trylock(&vb->balloon_lock))
 		return -EAGAIN;
 
-	/*
-	  * When we migrate a page to a different zone and adjusted the
-	  * managed page count when inflating, we have to fixup the count of
-	  * both involved zones.
-	  */
-	if (!virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM) &&
-	    page_zone(page) != page_zone(newpage)) {
-		adjust_managed_page_count(page, 1);
-		adjust_managed_page_count(newpage, -1);
-	}
-
 	/* balloon's page migration 1st step  -- inflate "newpage" */
 	vb->num_pfns = VIRTIO_BALLOON_PAGES_PER_PAGE;
 	set_page_pfns(vb, vb->pfns, newpage);
@@ -958,6 +941,8 @@ static int virtballoon_probe(struct virtio_device *vdev)
 	if (err)
 		goto out_free_vb;
 
+	if (!virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
+		vb->vb_dev_info.adjust_managed_page_count = true;
 #ifdef CONFIG_BALLOON_COMPACTION
 	vb->vb_dev_info.migratepage = virtballoon_migratepage;
 #endif
diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
index 7cfe48769239e..3109d3c43d306 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -56,6 +56,7 @@ struct balloon_dev_info {
 	struct list_head pages;		/* Pages enqueued & handled to Host */
 	int (*migratepage)(struct balloon_dev_info *, struct page *newpage,
 			struct page *page, enum migrate_mode mode);
+	bool adjust_managed_page_count;
 };
 
 extern struct page *balloon_page_alloc(void);
@@ -73,6 +74,7 @@ static inline void balloon_devinfo_init(struct balloon_dev_info *balloon)
 	spin_lock_init(&balloon->pages_lock);
 	INIT_LIST_HEAD(&balloon->pages);
 	balloon->migratepage = NULL;
+	balloon->adjust_managed_page_count = false;
 }
 
 #ifdef CONFIG_BALLOON_COMPACTION
diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index 5444c61bb9e76..fd9ec47cf4670 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -23,6 +23,8 @@ static void balloon_page_enqueue_one(struct balloon_dev_info *b_dev_info,
 	BUG_ON(!trylock_page(page));
 	balloon_page_insert(b_dev_info, page);
 	unlock_page(page);
+	if (b_dev_info->adjust_managed_page_count)
+		adjust_managed_page_count(page, -1);
 	__count_vm_event(BALLOON_INFLATE);
 	inc_node_page_state(page, NR_BALLOON_PAGES);
 }
@@ -95,6 +97,8 @@ size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
 			continue;
 
 		list_del(&page->lru);
+		if (b_dev_info->adjust_managed_page_count)
+			adjust_managed_page_count(page, 1);
 		balloon_page_finalize(page);
 		__count_vm_event(BALLOON_DEFLATE);
 		list_add(&page->lru, pages);
@@ -256,12 +260,25 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
 
 		balloon_page_insert(b_dev_info, newpage);
 		__count_vm_event(BALLOON_MIGRATE);
+
+		if (b_dev_info->adjust_managed_page_count &&
+		    page_zone(page) != page_zone(newpage)) {
+			/*
+			 * When we migrate a page to a different zone we
+			 * have to fixup the count of both involved zones.
+			 */
+			adjust_managed_page_count(page, 1);
+			adjust_managed_page_count(newpage, -1);
+		}
 		break;
 	case -ENOENT:
 		spin_lock_irqsave(&b_dev_info->pages_lock, flags);
 
 		/* Old page was deflated but new page not inflated. */
 		__count_vm_event(BALLOON_DEFLATE);
+
+		if (b_dev_info->adjust_managed_page_count)
+			adjust_managed_page_count(page, 1);
 		break;
 	default:
 		return rc;
-- 
2.51.0


