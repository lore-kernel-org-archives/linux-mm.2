Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A5C2CCD1AB
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 13:00:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CBA58E0035; Tue, 21 Oct 2025 09:00:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07CCD8E002F; Tue, 21 Oct 2025 09:00:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E868E8E0035; Tue, 21 Oct 2025 09:00:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D3A4C8E002F
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:00:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A742B11A259
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:00:02 +0000 (UTC)
X-FDA: 84022129044.06.5D3B767
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 75061180006
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:00:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J7Hodhbe;
	spf=pass (imf06.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761051600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sGRFD+OUXBdzIHwpdd8L6KTTXumWjBTMpIxo57Gp8oE=;
	b=F7OHCd3HRgLUIgQTStxEjxR/xmnopP2F+pCsAWhNAcay8sKCudH18Dr76ZDnn0zuWsYZ5H
	da/r0ryNdYWIJi/d1xStVbo32GkOUMqoINeVVpGC25QNwXKzZifg1fOVIwSfuj9cLpjsud
	3CCNJ+RjhJmS5/y0C+oRQqtKjZbliEM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J7Hodhbe;
	spf=pass (imf06.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761051600; a=rsa-sha256;
	cv=none;
	b=i4pnaOg0phVq3ags1vmu0jEIMoawh5S6py0rbtdIipZiNWY++Q7aCZ2gI8nwE8LsxwBLd3
	1X+bMT7biAR0pzQoep7tHFCvVGpng5hYFXm9vz+EFKkjUcrERVGxEbHvSr8xCOW8X/YXSS
	4adJi+E6yK1cVzb/BRajDroF0KCj1ws=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761051599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sGRFD+OUXBdzIHwpdd8L6KTTXumWjBTMpIxo57Gp8oE=;
	b=J7Hodhbe4IK8DgGpRcoQWR/tQubDSYX2Obt9t6b3IRk+mpjYt2U1iRRL0JQHQR1j7Qh93Q
	+hiCnHgpTuBXirIpqu7Ha45sgfCz2MwbPbiLyod/k7bEk7ZI8iJU8vrmsiv/nbBBgu4cJV
	+7TGqEMI6V9O2RrbbE0mVTfxk5mRG98=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-391-WN6wzAQ_Nh2Nj6dvToAA3A-1; Tue, 21 Oct 2025 08:59:58 -0400
X-MC-Unique: WN6wzAQ_Nh2Nj6dvToAA3A-1
X-Mimecast-MFC-AGG-ID: WN6wzAQ_Nh2Nj6dvToAA3A_1761051597
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-426ec5e9278so6557350f8f.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:59:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761051597; x=1761656397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sGRFD+OUXBdzIHwpdd8L6KTTXumWjBTMpIxo57Gp8oE=;
        b=KZ/OjBccLuaZhIX4+94mN0HcFsrj8dPNYBWW40Ox0OX+qg0OWMc+a3+rYMttbnkwKG
         8qAX5q+NzmuKJInANXmfMi86a6WsfAD7Y8qgS90c8UzR1X6w59nHWHqeZpioxgDbdfiR
         FsclFTjWae3NWvfoEHOZjFjB6BTStsAdXlsXiJkk92QsrN41UsybW8Fn76E5zDRjRwio
         k0ptMpmo0727ZdMkgsmWsv8KlgQj3fmU3VTZn+txm14ZjAWh0Obkgr9CHTCo9nuZ4rnD
         9yXja2BMCldnt3wJss79JhL0jyiI+0HhYvkvxyT2451iL9q1fUdvikZmgKMuRFBjBvGf
         Oqyg==
X-Gm-Message-State: AOJu0YykqRg9XUf54k31y0BmPuLjwgPG06hBtjGM9udiCFWmy3jIPaOt
	MZnjhUVmo6tp5WaWTt+xvQfItgmIM0idr+ay1AXXq3x9nUg8sGihPQUWCRKw3GykLJiS3Mvf/+U
	rzCiE/iApfPhhFT6NnyyHvEAgl+ZLs6HddLjCzqKEnKnyPnJRJ6gh
X-Gm-Gg: ASbGncvISYKq+ApbRuXCjYtEDOFlnC4RQCJS+jzYdv04qklinUJKSYrdRzPkVReDbeA
	pkQCgG3i1Hx7zfN4g9/Bh5ZjonuLI2Ac6vxA1iesZ2nHTo03ll1ZOWaLue7Wp7n1S0Qf2rIFFd0
	SYcRWDWffvki5h6ew6TvNeYNVS4V5GzqQkYRE+p+erMSGAqG/lhBs1RK0V9GZOqUilVTe1aE7fM
	P1YP+5VOz/Ssd+Jj8fRZb7Dy/XVpq8SilTD3dAV+CXiVGc7QHe9vxh49C/ZCLkeyQ+/pAbXcNlX
	1Uzcflw1XjZ/RdFe8e8XH07nAMxiQp+FyI0rBtDvK5nuAMSyhIlwdPNs3G32wXf/B/MZgNo3i/S
	H4vTzfruihFsmts4j4R84+FR6vmottp0BqR+uWkjEpf/+/5qLdBO99KP2jKE+
X-Received: by 2002:a05:6000:2284:b0:400:7e60:7ee0 with SMTP id ffacd0b85a97d-42704c8848cmr11160749f8f.0.1761051597321;
        Tue, 21 Oct 2025 05:59:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF1yccRPZwAQwYfj1DMBRFBsRJJ5k0BROkzwajkMvCNAUgq3lYo09LUN84ZfbVlOv9dAfW2Ig==
X-Received: by 2002:a05:6000:2284:b0:400:7e60:7ee0 with SMTP id ffacd0b85a97d-42704c8848cmr11160739f8f.0.1761051596931;
        Tue, 21 Oct 2025 05:59:56 -0700 (PDT)
Received: from localhost (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-427f00b9f9dsm20357223f8f.39.2025.10.21.05.59.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 05:59:56 -0700 (PDT)
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
Subject: [PATCH v1 11/23] drivers/virtio/virtio_balloon: stop using balloon_page_push/pop()
Date: Tue, 21 Oct 2025 14:59:16 +0200
Message-ID: <20251021125929.377194-12-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021125929.377194-1-david@redhat.com>
References: <20251021125929.377194-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: N_A2772wtb8UZPgeJ2Qvwb94zQR-Lb-SKhiSsm-tKAc_1761051597
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 75061180006
X-Stat-Signature: 8epgdeh1pdfbnsbpy5prsrexhwxcsb9x
X-Rspam-User: 
X-HE-Tag: 1761051600-316417
X-HE-Meta: U2FsdGVkX1+au4n7kdRCwwxBW97bY0Bwl0nzTqbSnkdC96sTGe4NJPSUTAJfpukNd7M8m5P4S+CtDZKgPbAwOdhJ91cPo1GXWFBa7XROc6saX1rbLsNSkBsHARgktL4F6fMp8C/mG90WaFzYExgSwGvWXJmh1dn0xi/ir5B74foRdlUpyjsgeeImKj10hQcdlU2w1twhhNKIqVrFn5JHRSHQ2c7sANeF2r3xfWtRiBraSFPFRx00Wlhk9m3voN4btUhSs+ZmolpZxToRtbKBeL4FxANei8WiuWI90ZOp6uoKSdvxgitsogWcydGusfIY7eeSXUPpgI59GKNc1zgeW+xvXhjXBnDPUUiZQVNaTVFD5Ryj0I05sAWBpWeKGeP6xTG7jElSJHPLC9wcXoC/DLd0MXxknLpUUPQ0COnJ4UE+janL3tfkhgGxVlhB4lFhQZm7b7Y0Xe8xJySk5eIwXR5nxj6G9nkGOPbPuaAHDfxj9eXtczKTDz3rM5bAVkxRW4AHr3r2H6p6LRe9mUbxMTQZrhaR/SIDjHqA3ZvCpBY/sY3ZpR/ll4a+ddYY8q2dCrClALMP80JN5YRkJnaPmiCFp/ZDJNuAEL2X1oX6blEndVLIzpK4f/bse39olQSKfey4xieOSwwvHvLooJFk0D2DBPCxvPqa9TjkgB31kmomWzzjiZbLh6rcjGIfYt+UH2/Kdiqkr1qN2c2g/aSNX81sJwtTvjjxt4UxqneGiTmhC4RBv+OYbdc9YQ6fQWVX951HqlY906MlVS8fCW2QXpt3MknGLO7hgVX7BCUwgzKKpDXxE5PKEU3V9jSTi0MXIL9Ocl84x0zf6oUBJJ91muYpPKv7BduWUr1v2H6QjyvDe1jFNayOkMFPdln+EXybpy04IRRavZ6IW8mNyCVfKohYZvN37jDy/MGpkGfIXf9cz4vNL5OaepE5mtG6cwgruqEcBR9hgxxC3aSXazS
 Ukw7UpT/
 ZKh0iWPFnvgGvGWuiYDbPYw2wgSx2gb36+ShhsAi1n+f7X1R7RB7tglvJ8aSf8f2uQ6kAhvZq1KBNqSggfEHlDaiAiNZn9Q/a2gP+fKrhkuAAHvPejl/h9QxBlEEbMfT2iLqKN5bgR9nWN82jHHTw1JWxBmVBPPFuiBc7mRI0cnYfed5d8p3ASd4FiXqQwWhdu5FXhpE6IsO8c5O/8Uidwg2WnTpQk/ApVg97gYR5dTDYvl9trDnyrSnOlbdTKjgzmZ4E1usvCIe5NNeaGeZ3si/OayojfhjytjSp6SffsZPfgzCSSGkiDZQiZw87RdEiQtCf5A8oVp02Ol8uv1TScW0qRRKDPM/KVBpAeg61vSrqn2R61QjkRYWpJbAoIQQr+z4w/MVkJFAuf77l3s8RvDz+i7owbP0X+HBajh2flzN5Wm44GgQXYiFfg0+l6xL9XZ/9Y1SPxpUvmRs7AIaCDwM21nWBUG81SbjXbAJVXU81xhPB3Py2H9qjH848xmHSc/aKc4aZ8RJhmeuuwW8mEmvCR3KH+nM2uQEYHtYkraMqWJVGin/htpaX/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's stop using these function so we can remove them. They look like
belonging to the balloon API for managing the device balloon list when
really they are just simple helpers only used by virtio-balloon.

Let's just inline them and switch to a proper
list_for_each_entry_safe().

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/virtio/virtio_balloon.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index f7d6a4a6e54f5..4b22de6a5f845 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -242,8 +242,8 @@ static void set_page_pfns(struct virtio_balloon *vb,
 static unsigned int fill_balloon(struct virtio_balloon *vb, size_t num)
 {
 	unsigned int num_allocated_pages;
+	struct page *page, *next;
 	unsigned int num_pfns;
-	struct page *page;
 	LIST_HEAD(pages);
 
 	/* We can only do one array worth at a time. */
@@ -262,14 +262,15 @@ static unsigned int fill_balloon(struct virtio_balloon *vb, size_t num)
 			break;
 		}
 
-		balloon_page_push(&pages, page);
+		list_add(&page->lru, &pages);
 	}
 
 	mutex_lock(&vb->balloon_lock);
 
 	vb->num_pfns = 0;
 
-	while ((page = balloon_page_pop(&pages))) {
+	list_for_each_entry_safe(page, next, &pages, lru) {
+		list_del(&page->lru);
 		balloon_page_enqueue(&vb->vb_dev_info, page);
 
 		set_page_pfns(vb, vb->pfns + vb->num_pfns, page);
@@ -474,15 +475,19 @@ static inline s64 towards_target(struct virtio_balloon *vb)
 static unsigned long return_free_pages_to_mm(struct virtio_balloon *vb,
 					     unsigned long num_to_return)
 {
-	struct page *page;
-	unsigned long num_returned;
+	unsigned long num_returned = 0;
+	struct page *page, *next;
+
+	if (unlikely(!num_to_return))
+		return 0;
 
 	spin_lock_irq(&vb->free_page_list_lock);
-	for (num_returned = 0; num_returned < num_to_return; num_returned++) {
-		page = balloon_page_pop(&vb->free_page_list);
-		if (!page)
-			break;
+
+	list_for_each_entry_safe(page, next, &vb->free_page_list, lru) {
+		list_del(&page->lru);
 		__free_pages(page, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
+		if (++num_returned == num_to_return)
+			break;
 	}
 	vb->num_free_page_blocks -= num_returned;
 	spin_unlock_irq(&vb->free_page_list_lock);
@@ -717,7 +722,7 @@ static int get_free_page_and_send(struct virtio_balloon *vb)
 		}
 		virtqueue_kick(vq);
 		spin_lock_irq(&vb->free_page_list_lock);
-		balloon_page_push(&vb->free_page_list, page);
+		list_add(&page->lru, &vb->free_page_list);
 		vb->num_free_page_blocks++;
 		spin_unlock_irq(&vb->free_page_list_lock);
 	} else {
-- 
2.51.0


