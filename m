Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACE5BCA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:09:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA8A26B009F; Wed, 27 Aug 2025 18:09:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E58926B00A0; Wed, 27 Aug 2025 18:09:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6E8B6B00A1; Wed, 27 Aug 2025 18:09:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C73A46B009F
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:09:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6B8FB1DE90F
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:09:46 +0000 (UTC)
X-FDA: 83823930372.22.87E13BF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id AC77C40005
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:09:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LPYliZZb;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8SUmSf66LiCJvVJzeEx0UA2HTOESqflB/UZ9jC2+86E=;
	b=Li3W0oyhVdu1F2lXp0fo1Y46eKICJ1iA5RFQPP2/klTWj8cPZpxr9IzjeLOUcrzNSFBHU6
	hD4IXXG0SpvKbgx0wL8KJzTtF4aZINJFFx0yh9MVrCnM2Gy5khOLU89gydkpd9mhCJGyDo
	vspdDkZEjAfeahnL5GLAg9NSdLr+Z74=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LPYliZZb;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332584; a=rsa-sha256;
	cv=none;
	b=tjgPnxVJi0jVMdTP+8DXn1EmMNWkH8Pn4eG6mNhFd7323vVeIxVVOq5w8HyretKvRKusX/
	8fOu0qWc67cC4tRjyIED1NVD3Kmf87xz7ViwcHDiwf9O4OE8cpHf+8mlNlKj1sOQ1+M7Gi
	4Dt+0zd9K7MXAzz+buTFkFKJ6ZCaxpU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8SUmSf66LiCJvVJzeEx0UA2HTOESqflB/UZ9jC2+86E=;
	b=LPYliZZbUTgnMcT6BcQPZOh8wdM2V1QRhM34gleBGAW7ZsvLWpjqSI/pup+38NJZGlIpJ/
	Qe8i8M8Lm2hBplrWL221t6uL4DURzQaJwpUkVX1hYuWhQ5YSVmiGJHKeRZ+ZrgCC4ogfZC
	ADxSCbNlmeWmvaqwWbTpybylu5CVoh4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-638-wuVJZl_PPm-kz40j0XhWgA-1; Wed,
 27 Aug 2025 18:09:38 -0400
X-MC-Unique: wuVJZl_PPm-kz40j0XhWgA-1
X-Mimecast-MFC-AGG-ID: wuVJZl_PPm-kz40j0XhWgA_1756332573
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 006A91956095;
	Wed, 27 Aug 2025 22:09:33 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C1B9F30001A1;
	Wed, 27 Aug 2025 22:09:16 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Alex Dubov <oakad@yahoo.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v1 26/36] mspro_block: drop nth_page() usage within SG entry
Date: Thu, 28 Aug 2025 00:01:30 +0200
Message-ID: <20250827220141.262669-27-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Queue-Id: AC77C40005
X-Rspam-User: 
X-Stat-Signature: 8gxct3j3uhnh9b3uhw5e7c6fupbyfqsr
X-Rspamd-Server: rspam09
X-HE-Tag: 1756332584-558490
X-HE-Meta: U2FsdGVkX182KVRi+hUOmoJ3t0WcRDZz/JUqqxVAPfSUCb3OwWeifnCIl9x3OrwPvvP8Byy1kB4KW35IjxKfT3iAzp/bLT2neVRaFAFhLA6Ph92hbhZxbI8vsAcyJlLuGC3MgQ9k/VOyGHgomrLNb+tjl6x2rvkEwyN8DIaC226gdvve6LjepW8EHiTJQolva8juA+7SABBmMu9uLM+BBu97tk27LQvYYeBZigOSttTFiBhu1mUWNm3j4c9esiI21Mobfqz8gvLl0QCHfa6UDMcsPuYaYu2pL7NulUnqbSjZuvombtGKV8Gms/7DQQ66ZPZiFc3Tm/4LgwMtd6NTdKyZIuscsxo4srdpnyyJP1WYh+AJrucfpfENoDJKGRwz2bs93A0mV3n/9nYeSFNsBuBNCvqukNduB7YopCewK+ZMmHXeDXfW2GkhjZ4xfK9wXpmHCboLVQoZVTLy+6nFb87qIX+G814DRDFfZUbVVWhA9QR3O9Ytt9tYZVUv55QDQZDHE8eiuLMinvLt6hZNzzzG+ZfdRMpEXM4y0ES0VLVMeO6ktKfHsnfej48ibyAQ1K5b0nJLLITpveMbJiUF6TbjH2vH6ycbKDhDj+xp8otaCOe4fAjfNvZQFSMWJ8GXOjqDnV7vQbJMFnFixAu7eMdf7bZmsMwDWYGStv684bumVo4CxfKq3oqr4Kf4KdWfY1iYyOu+5IqmTS5fxCNagJ3pJYJl77no+O6FlReVup4UsCtLknLWJwRBA78kv34xF75JrMGP1xRudzFKFczTiTStJRRUJxmPyFk3zZSGkVhgXEmN7uaexr9fsTouzHP+YPcKjmCuqn0/AzfNHYCJ2pye3zRBVqVyeqoDtqIXfZ6hHJvE4YTCFTC/+rE6SYd4p/anfmbShU50MN+CGlO+ADCeisfXhaDYe0CnIGYYmP1dwiYRMNpFJlTdr7Rp1Vp5sRIAD1gD6YiLdomXnT+
 stjkWiYb
 jLWcUSg4fiUM0HQpx/x8SlnIf/BhKcNf3zvGcntlm1zkasrpF6razRxe2hVfSWHbVmgk1LsH351yX6GwQcWRqhyUr0tPHCIQ2I7R03S5mqDuKCoIutyQrZnQWHqynqrCHjWyIDa8uKIAPMzT+3R0hwi8DlQQE1UmD29dpPHGn7glthxO9d71j7ZHu4V4WG3wiVTtEfjDzxhTOakuK2s9HZ3RV7Geo7p3jcrdOJvbt7SPucJ6MhUW3BGjX/RrkR76lyqxjh5Lf3MtRrfuifGVauJa67kwlufN78Q+YIfkwoS0XwIb1mn+dLP99gEUmEy5oIh4rAGgvQZXtRcA/zLz1DngzSNFf9gAzNZDJ4/M6sEPn3ESOFy97Xdzbjgk0RJUmmb90w6F7B/zzsh+QwNHMOfgFv4jKQkib/ZuHC+wqb0apsX8NDwvDJmMHMhhj6yDzpRHKUfM+8d/aZ3Zipy5JQZadxOXCvTemgSRboyOq2NRv6lf7OO648VrtGQYzDtkqzlGCVrz+fIVwscWycQOwk7d3j/crcKdayt+f9xeV+PlBdIAp6fGkiNEy6EQIeRWpQ42m+UpeiQ7qCXduqkyDYx9uK7zGkVTxWcyp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/memstick/core/mspro_block.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index c9853d887d282..d3f160dc0da4c 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -560,8 +560,7 @@ static int h_mspro_block_transfer_data(struct memstick_dev *card,
 		t_offset += msb->current_page * msb->page_size;
 
 		sg_set_page(&t_sg,
-			    nth_page(sg_page(&(msb->req_sg[msb->current_seg])),
-				     t_offset >> PAGE_SHIFT),
+			    sg_page(&(msb->req_sg[msb->current_seg])) + (t_offset >> PAGE_SHIFT),
 			    msb->page_size, offset_in_page(t_offset));
 
 		memstick_init_req_sg(*mrq, msb->data_dir == READ
-- 
2.50.1


