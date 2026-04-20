Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67F8BF588C2
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 12:51:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAFD86B009D; Mon, 20 Apr 2026 08:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C733F6B009E; Mon, 20 Apr 2026 08:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A78856B009F; Mon, 20 Apr 2026 08:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 98A786B009D
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:50:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 59CC5140A5C
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:50:58 +0000 (UTC)
X-FDA: 84678918996.23.C115107
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1951240014
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:50:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QsbL+G2x;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776689456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qyYPevVtD446gJgwyEFeHqxZY1ZBEj3WK1MuiedCKFk=;
	b=09zo4AGSNoiqA1rur+pD/LHhUyJ+YstwufU3tm0qollS0dshwiZbiFIb5L5z2txYjY+hA9
	aiF48K4wGvAbQ1AH5AH4akABxeKmKB4juYQEXkpXxi/qzpkZm08oSKTSOQVwwnZfK4DWX2
	SbXOKinuI7EEMD/Fma+KuHZH4O5xXfA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QsbL+G2x;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776689456; a=rsa-sha256;
	cv=none;
	b=n0MbKjlkSROqJA4B+Zqe+Opts6ex17HcyYSQ4juLlgmX2k1FadEIYpdPd2/TiK/JUs6MKg
	lTXLXIjhySeHAJkBC3pZM8wQ6H1rtzv5rNhkiRiGnpkNx8FqbuqXeKIS/mZWNJuu7rraTq
	0IkJqd8F2b0HXnmrXY2vwY4IFZvNgcY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776689455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qyYPevVtD446gJgwyEFeHqxZY1ZBEj3WK1MuiedCKFk=;
	b=QsbL+G2x25KnVRX4smKmuXflKgYQtBnNMtn7U3qAxU+igyug/56ffF0kXThSfgDHkXPPsJ
	Ik6n+g6qR37kHd2xnPXudUvCaSysA95iKeixzICKBKLc+OkU1e3JU8DAFMkuqViyyIdR6G
	gWRKEu0i0TCqtU0FKSMdP402w5p57ZA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-265-7h7eDe0vMViC0Dt17yqs_g-1; Mon, 20 Apr 2026 08:50:54 -0400
X-MC-Unique: 7h7eDe0vMViC0Dt17yqs_g-1
X-Mimecast-MFC-AGG-ID: 7h7eDe0vMViC0Dt17yqs_g_1776689453
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-488cc31ea57so23571885e9.3
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 05:50:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776689453; x=1777294253;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qyYPevVtD446gJgwyEFeHqxZY1ZBEj3WK1MuiedCKFk=;
        b=eHPOXF5tDr9uJ6c6S/EqoEQRns6reV2T4mvUX3/wLTrNwuUxqFizYTucWF7e2Pq1dX
         gC59OcmPz7MIzDGgrGhCheBEsanPRJNYNuTy6lXeQWSuruOkGaM6AL9rAXKi4ztkQduP
         HVBw9pvk2C3S7QwwOVruSkqSoHxG1/gFMGhYjo+HpUgPRhAZKbfYwH04eW0zLVig0v2G
         8xcirESJwPcQmXhBHhafUfxKMa+uLnbFokfQwslSQeYyC8Au8Nr1HPr7CZ+EAp0oVzjK
         PgdnN44khZfUre/TUokPv9EsAcZg9sJto4cJw9HSWyzrvskkxG3e9XXy2MbSF8+ITDE+
         2c+g==
X-Forwarded-Encrypted: i=1; AFNElJ/La4ICWVXbyEq8iW8IfFQrSXFqIeNJqRUIwKLTR8lIoMnCWTQKzlqsEmXylWJnOp9yHe8vNPYCbA==@kvack.org
X-Gm-Message-State: AOJu0YwpiJ056gFb6eYerA1/CfSWHoxNXaWVJxFOm8UROb+aVxE6Pqqt
	7GT1qMk3d3tQQcacr8IfVM3g+Rel9voZVjt1x3/r1lmCTuVhue9M099zzyk0zod1rHqUNWKmTJ9
	EYaG03F7azQipt5MhihFIZnI1gY+0Z6T9nGOtXHJEmvnFyZDaP8CB
X-Gm-Gg: AeBDiesORxT70btlW7hBD69H1tOGnFCN8VhjUH5Ja6E9+Am9mpVYSzALF+PMaOxbrLv
	dmh6lTrlN7rFx9RGNEz9dt2FW4+kBBVEJHAOufTrLr3J2rod4kRjzFLooROc8Z7qsYkKKpWRWuw
	/whfJW65ky+uMcdBhD6I6akv/19WgrzOlN6fB3+40jZV93tbAsxTjVu9Tm6RrvFiFn/fPDTG8A6
	v4S+apbHTw6rgFphQzMIFzv9JYhTmvIQcLVOXGtqwjYd6Tjvf/fy+V3vv/m6sT6+u2WZ2gpQDSM
	IHyDlC36+vMmGcxtf31RiW+j5I2TB8c9J+BtwgEum6WAPgLtEQHHBBmq8J54OKy3EzWNU/Aioud
	6BC0pm+LOem9/I5igsBAEpyvucu/o2HCEEPgsAei/QiBVxqRgDocQJw==
X-Received: by 2002:a05:600c:c4a5:b0:489:96e8:1ef0 with SMTP id 5b1f17b1804b1-48996e8200amr30131545e9.30.1776689452999;
        Mon, 20 Apr 2026 05:50:52 -0700 (PDT)
X-Received: by 2002:a05:600c:c4a5:b0:489:96e8:1ef0 with SMTP id 5b1f17b1804b1-48996e8200amr30130895e9.30.1776689452402;
        Mon, 20 Apr 2026 05:50:52 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4890009e759sm216401175e9.6.2026.04.20.05.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 05:50:52 -0700 (PDT)
Date: Mon, 20 Apr 2026 08:50:49 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>
Subject: [PATCH RFC v2 11/18] mm: skip zeroing in
 vma_alloc_zeroed_movable_folio for pre-zeroed pages
Message-ID: <39c3c8e647fc4c8e3dcb5c9d12f2e29b5404e8f2.1776689093.git.mst@redhat.com>
References: <cover.1776689093.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776689093.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uih5ipcz80seYeI2WnRlT4vq7aLF0Pc-UoAzvZckUgU_1776689453
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 7z33dsdk5qb6tk5c7o94sxbwxbwqaway
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1951240014
X-HE-Tag: 1776689455-12458
X-HE-Meta: U2FsdGVkX19MZh+7Zpx6JA7SXpKNXaTGA27XqbHraq+YtjI0Qlu/d0Zu9SchP+InjqJ6LefdcvMJbcEtHFbxm7ttiKa/gkStW4uJvG7bqMBGgvN2V2dAXA2Hlg3TNIFLmngixBHh2MzNGc5HQN1F22g+k0QwGDdjb1Yy4A/gFtuG/jI4Re+K1N916i0FZFpF8NKYONHCwp7K7LqnLGB8PuHbnOUQ9rbvfGHbbcOQRLCg1p79HyHzUgXe4Tw0ogl0p476DJcmfaPotbja9tZ88gdrc6URSbgmMf95cVlbcmqH2nczT6T3PffZ2IHNV4tV5YKLXxgIM2X3EYQ1zSyA2WPAZuiiK4tyUpmdpwVEaifF7vwsssja3whKrT3ZWYsH6mEab7ioMqA98Q4JptH+wo9rL/NQ5FPjJwvPGDs3va4351RuE2XzLGgJF1OEWMjL8HXEWTqpnq7wtUV3h66m12g8x1KfwhS11wi5lwcLhuxK9FoyAWUm7CfuZIbHTD35bmxAYbWhbTUoVqfawTNPIRxHlFg819nvkfjawhEkLyAo9iuTEVgRJU4T2TCW5SYolYSRDCTMKZBjiGJDvQ7YFsxSVOVswoAxVbaA9ZNzihZF5WvTwJ74TCNZ5QXiHD7uV7ePvQOWak35FDvww/xcMzb/LdiL90sV9drZm9sdWjkHVCQwNUnBt/x5e3DpNyDPifXdReYJcsPJ/MjqFk2eWmDJbVi/AZ4U143oez2dBXolx8AjoJ3vOtKdnVUdiIKuMUrH9N1r652E57FaV9HWIqLynGq+b+jpbt1AH1G+v0XgbYo/+KlqXOd0yoVXiExq1qo6+iWo1gm2yvDdq3hX1KeFwXZ9qa2v+sl9uCXdbd6o+oFCRlI39apmuO/4t7/P/DNbvR9JXi61n8QVUMn1IzbxlRopyDumWQmRqp9dGFQoyAfzEVXQ4ZFQG1cgceybEq7AE44tWLHJ+2IjRFs
 P+94T0iL
 s4cnIguzIBPRTwfIMEYTtcBlAyQyIsM3SiDB1OCzAogJY+vmEneIFTLsR/K/HvEAKitGCOvqXhQ6jUuxdy5eJFaygtxuRxmSVk/5m3yDhWnoyTAkT31nkAMRnahvj1mnXmaP8UDx226VmYCB2sSxD15dav2BRsiyYFgzRZowelSjz/UH0nF2aqEM/fYrCQ4VmzGDVGMpLXHyaZI5h0fkQKrvmyrCNDRqZeggFH4d87NpgDBqmxzSHo4A2S9G9JyUSwXrsVIb9KFU4bWpVtNIy1wBCgTd5Bbz3JKPtJfDUuXkf+H0GIveuN7TxEx13GOQYkqsnhYShuDJ7xozYlEwEby8WMRIpMH/totPpTcfW/Qdk8mnblyGzw8tlSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use vma_alloc_folio_hints() and check PGHINT_ZEROED to skip
clear_user_highpage() when the page is already zeroed.

On x86, vma_alloc_zeroed_movable_folio is overridden by a macro
that uses __GFP_ZERO directly, so this change has no effect there.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 include/linux/highmem.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index af03db851a1d..8bb67772c1cb 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -321,9 +321,11 @@ struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
 				   unsigned long vaddr)
 {
 	struct folio *folio;
+	pghint_t hints;
 
-	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vaddr);
-	if (folio && user_alloc_needs_zeroing())
+	folio = vma_alloc_folio_hints(GFP_HIGHUSER_MOVABLE, 0, vma, vaddr,
+				      &hints);
+	if (folio && user_alloc_needs_zeroing() && !(hints & PGHINT_ZEROED))
 		clear_user_highpage(&folio->page, vaddr);
 
 	return folio;
-- 
MST


