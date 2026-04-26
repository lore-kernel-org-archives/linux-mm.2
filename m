Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7245FF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 21:48:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A74F6B00C0; Sun, 26 Apr 2026 17:48:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 583936B00C2; Sun, 26 Apr 2026 17:48:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 445E86B00C3; Sun, 26 Apr 2026 17:48:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2C8F16B00C0
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:48:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ECAE51405B9
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:41 +0000 (UTC)
X-FDA: 84702046842.13.3408336
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id A83111C0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="LLKhO/74";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777240119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ym5bn+CWMcoek2qBVqBOry4vxURkIsMQd8yhmA+BaCk=;
	b=wMoGw5gSt09MzdB5EF9SroKCOCZaq/WUdNASrI6BQZhN5pp9b+ZF5h/fnHZ1VUkeUf8leD
	XbpJiQ9okT6Pv85btbzrQuFZIpgCZzPmoEXwNVMP9zZato2tqb+lZXjf8Mfz0Q3U5YX9CT
	Xqt33PvmUinX12ln7AN+Y9uDEA3z4IA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777240119; a=rsa-sha256;
	cv=none;
	b=06h0ogIHL9Eo0AHsJVwfDV5QK1MCPtgBOqCFx0hQTKHY6/kQm8tljhaXZ0323N2e3P8dE/
	qKHXJHerBqbBhc1uRR9Mt5pp6a6IZjgN3IgHWYAlrsQMQpXfCesCWGCiHk7/uma4bLg3Hi
	gJwAX45Vw0MtwJdmbwbkhhLLuO5Ucfo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="LLKhO/74";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777240119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ym5bn+CWMcoek2qBVqBOry4vxURkIsMQd8yhmA+BaCk=;
	b=LLKhO/74o7jPDiLRI4pUlkAp8ImF9MEeho5nrcDaSsegDnkHWrxbci++NN/0AEJ3KNJzuY
	7OWnGgvePQgJlw8BC/LOhJztUUt16ZQkD1TRAVru9Lw8Bn/FHb45vqxnFQqcFPsAqemnEG
	arrV3B6ZKX7wHIB+JTDrSsQFlSbO+pI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-77-hHuMVGwSNtqNACq7Hu61eg-1; Sun, 26 Apr 2026 17:48:37 -0400
X-MC-Unique: hHuMVGwSNtqNACq7Hu61eg-1
X-Mimecast-MFC-AGG-ID: hHuMVGwSNtqNACq7Hu61eg_1777240117
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-488ba2f4094so57573485e9.1
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:48:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777240116; x=1777844916;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ym5bn+CWMcoek2qBVqBOry4vxURkIsMQd8yhmA+BaCk=;
        b=kEFtOclYRikAlDsxoJVfH53iCha27c9x+bG1hPT1Q7HJ5Dk8txtGv9/Bgi/c1nx3h3
         1a7VK784nsjtp99t7k8Wun5h2z617akJwp1MO8HuncqRKozlZPpnaMBG6f7xZHGpkNZW
         pvBN4vskLiEzQYy/Cpf9Y8gm1vdc/N2ME9zXNWwBQ6cuI+FwoaYXFuN0nLq8+8iP7WSw
         rH1C7jVMqnX+CJqcHIbAHJ7nyvhoEXUbLKQEN/nYLU35ctEAVRWoiORrzqwNp+BFp2f8
         ZkElk/NKhWaRex6z0m6fempJpM6wDs/OXWEQ/o6yy87a6ainv6FshPLXRO7Lcmus1lQm
         62Qw==
X-Forwarded-Encrypted: i=1; AFNElJ8O1Vz9gY+31GfVKJyN2oyEzzNBZt7RdOmMjrSSG/XQlLaeCZi7CvyezhXnvvDits9MNBevZMYEyg==@kvack.org
X-Gm-Message-State: AOJu0YzUAK0vh5po7lqMdlhfI2HXblS54Ou58xWqYOZ7RVM5Mdky260F
	s54dGfjQXFn4dUh0Yt9FXi6GEfzAVBgQf7LzHA8gnEzky63APeQqHOUWXyij3wclGDjmU5OlJj9
	67pr5QRCzqzvQSKPfho+0FRNqN+ZlDrnBqfVl2R241scSwGhT3o+p
X-Gm-Gg: AeBDiesa13sdIGUBBB3CFpm3qUYzNCC/NBIKsEZH/XsHdJYAorRmxnKApTOZSS+IxVN
	qN6tcJ+BxqWHsig7TYCNTwG3F09t7lLaJFc/iyobMYgRjr+YWf4L+oAkhu3UWJr3qKtlB0aeS/b
	p5phANOaFLyN15xalQ3+/IJ8283J63OyPLYd6rJT/LL8uwKHLUzwe8v3/tmcmtQq8lvW4JdwRox
	JnswoBzxC4+234D5ebtEnAXDQ2EuoYltQQ6rF38Miznt2biWxGf0MV3rKLWgO0WlkRBAhqZsFcN
	BYpcEejK9iz96+phHXALZTf11K071rEmohgGtvteFUryg84iiYZNIvkHcYtyHr1pJ/xyJyxXTDJ
	foC18x/HgHUgnNw0y1YZ3EDZMgAha/SV0kaJTYe91y0Qm8gJdRXwA51X6
X-Received: by 2002:a05:600c:c085:b0:488:c530:48a0 with SMTP id 5b1f17b1804b1-488fb784843mr454260185e9.24.1777240116470;
        Sun, 26 Apr 2026 14:48:36 -0700 (PDT)
X-Received: by 2002:a05:600c:c085:b0:488:c530:48a0 with SMTP id 5b1f17b1804b1-488fb784843mr454259925e9.24.1777240116042;
        Sun, 26 Apr 2026 14:48:36 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-47-179.inter.net.il. [80.230.47.179])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-489201cde98sm505689585e9.7.2026.04.26.14.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 14:48:35 -0700 (PDT)
Date: Sun, 26 Apr 2026 17:48:33 -0400
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
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC v4 20/22] mm: add free_frozen_pages_zeroed
Message-ID: <c7ea29cb7a8d88175f2c4f62130e7509ceb785e8.1777223007.git.mst@redhat.com>
References: <cover.1777223007.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1777223007.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: F0VXpSG8pwIOwQfodvx3tGM82Ehxn6l4q9qPIRVxUtw_1777240117
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: A83111C0005
X-Rspamd-Server: rspam04
X-Stat-Signature: 6ntnuixofmcabgkdyyzo9hihd6qqzwhu
X-HE-Tag: 1777240119-74388
X-HE-Meta: U2FsdGVkX1+GUy4kK90ThtyZFop2VvEmYD7uKPcUdKautviLkHrTKDreKGy21/U/7B2OaAM8GIgOB5cbKnM/dFzyYr3HBzdJHdikJ7QTddF1Ip7/+XsoVP22qs5Jm7GuIUH7e2p6UlKS2AkMpYMgy0BerZhJFWkF/9AdEzNZTtBr9gFuKSJhNuGDlwnlmm1AOHcuSnHFHApr1tRSRCWa5BB4gQCickSo3MfU7I4kUGYL45x4O6Y0Jra5gJydFCw2eWpRGizBSnXgMFTnQjVCUBHZpWV8Y6cyLztNNhfZJgGvZY8Zz82pwSpYyeDyEyUlstEYj7IQVbBroYEZJSV6mRD2dZQiTALIZC9KQbqVS9U9AwPdNo/FUhy1Jk6WYFEosMV9QfhVO0srQwq5cc6ThSnPsNBLYiQexW3lMxtPcFKORhMxpVW5H5FYWGQaxj0t8qLWUZ9xg9soqMCMeq+8qeL4ESEM7bUMuZTIOGRg8Brlb3lE8W0y1b+hqSMSSEp+y1qYZo5eAqmHq6PMl/G3yvX4Tp0ZhdHCGec2uF5vWBzozF0AE96xBwUy8eAkPmjo9DtaeCJ3l/f0uMsD0CsS/50Xq31IMs08eV43nprwjPH5DCZcCt/spSFkE/WrcsY8Bc0GxBqP7xcGi8Xr7Ge1d7b+Mb08vNtpdMumBVStpoP4E0oUChx69Wc604cUjyxGz+w11aZFPzB0YNIdDCOLqmD5961eUVGo75SHkedUESgpfa8ie+jOOMCwD9nZhJt/z/O6qI0Zuj3nNJ5amtlWOB3LQDM26C4iblfavfqk87v5vjlKbFc6/KghkEeMTUiDK4IK4CU5KFgVqd47Zh7s+bRcm5wrepJpyOhUWy+lLMHAo9FkP7JD11k4OfkOYLt+aq9nKGadd1JVGd5XHMbNRCdh3dWXBX8VCwTLsC44C8yI9BbCw3LfyByMcOGej8i7AahxCQtQt6t3p+6NBBV
 YR/p9qj2
 GSBkkZ2Bw+7Kj6NUQIoihk/dUCMuN2sYUAMZtGLmVSifIOl17Mdgb7IX7MLFpNUjykMFs+/llAEmgioZ49E8EncmLyBnpTa0EyrIgLaJSGEx/nev5Y79gwPDafZxObDlD6mKoPElqSNo7oNbX9jt1ZDlWYSsse/wxs73tQMnIcanI7RYuabd3w97p1mXFpKJS02kKIThSh26WEVruW3NFen0ruqcL42ZeuPq1a+bkVNkmwrQSORy2zZxPLI2HBrxun1s5Vu0x28M+2baOy1Dna+KzuphyR59oPaFcUMx35KrbmHGtIM4v1NX/9zEPLjsVaDIBXydeX6QOTDCavmLOCST1OF7F7sey/O2gtxacPjMLgp5vIRs38tVLzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add free_frozen_pages_zeroed(page, order) to free a frozen page
while marking it as zeroed, so the next allocation can skip
redundant zeroing.

An FPI_ZEROED internal flag carries the hint through the free path.
PageZeroed is set after __free_pages_prepare() clears all flags,
so the hint survives on the free list.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/gfp.h |  1 +
 mm/internal.h       |  1 -
 mm/page_alloc.c     | 21 ++++++++++++++++++++-
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index e275cc80e19e..766b1c7f0731 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -394,6 +394,7 @@ __meminit void *alloc_pages_exact_nid_noprof(int nid, size_t size, gfp_t gfp_mas
 extern void __free_pages(struct page *page, unsigned int order);
 extern void free_pages_nolock(struct page *page, unsigned int order);
 extern void free_pages(unsigned long addr, unsigned int order);
+void free_frozen_pages_zeroed(struct page *page, unsigned int order);
 
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr), 0)
diff --git a/mm/internal.h b/mm/internal.h
index 0600d824ba03..60b983872d51 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -899,7 +899,6 @@ struct page *__alloc_frozen_pages_noprof(gfp_t, unsigned int order, int nid,
 #define __alloc_frozen_pages(...) \
 	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
 void free_frozen_pages(struct page *page, unsigned int order);
-void free_frozen_pages_zeroed(struct page *page, unsigned int order);
 void free_unref_folios(struct folio_batch *fbatch);
 
 #ifdef CONFIG_NUMA
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1169714406e7..981ddf3566b5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -90,6 +90,13 @@ typedef int __bitwise fpi_t;
 /* Free the page without taking locks. Rely on trylock only. */
 #define FPI_TRYLOCK		((__force fpi_t)BIT(2))
 
+/*
+ * The page contents are known to be zero (e.g., the host zeroed them
+ * during balloon deflate).  Set PageZeroed after free so the next
+ * allocation can skip redundant zeroing.
+ */
+#define FPI_ZEROED		((__force fpi_t)BIT(3))
+
 /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
 static DEFINE_MUTEX(pcp_batch_high_lock);
 #define MIN_PERCPU_PAGELIST_HIGH_FRACTION (8)
@@ -1624,8 +1631,11 @@ static void __free_pages_ok(struct page *page, unsigned int order,
 	unsigned long pfn = page_to_pfn(page);
 	struct zone *zone = page_zone(page);
 
-	if (__free_pages_prepare(page, order, fpi_flags))
+	if (__free_pages_prepare(page, order, fpi_flags)) {
+		if (fpi_flags & FPI_ZEROED)
+			__SetPageZeroed(page);
 		free_one_page(zone, page, pfn, order, fpi_flags);
+	}
 }
 
 void __meminit __free_pages_core(struct page *page, unsigned int order,
@@ -3032,6 +3042,9 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 	if (!__free_pages_prepare(page, order, fpi_flags))
 		return;
 
+	if (fpi_flags & FPI_ZEROED)
+		__SetPageZeroed(page);
+
 	/*
 	 * We only track unmovable, reclaimable and movable on pcp lists.
 	 * Place ISOLATE pages on the isolated list because they are being
@@ -3070,6 +3083,12 @@ void free_frozen_pages(struct page *page, unsigned int order)
 	__free_frozen_pages(page, order, FPI_NONE);
 }
 
+void free_frozen_pages_zeroed(struct page *page, unsigned int order)
+{
+	__free_frozen_pages(page, order, FPI_ZEROED);
+}
+EXPORT_SYMBOL(free_frozen_pages_zeroed);
+
 void free_frozen_pages_nolock(struct page *page, unsigned int order)
 {
 	__free_frozen_pages(page, order, FPI_TRYLOCK);
-- 
MST


