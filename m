Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4157DCD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:04:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8AFC6B010C; Mon, 11 May 2026 05:04:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A625F6B010E; Mon, 11 May 2026 05:04:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 978A06B010F; Mon, 11 May 2026 05:04:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 86F326B010C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:04:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4DC7640676
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:04:41 +0000 (UTC)
X-FDA: 84754553562.24.8D332D6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1474780003
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:04:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JWRpB6Y1;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MpBn8Jg+yemSfT/rKcYB8AJ8VmedmgkSc9fIviOsi3s=;
	b=fEzGPiWi/jrNjsjdgLhf4yHicn1N3qlMke2dRfgCAS+J5bzvkcqfNzWailSfJpqOgj8G5C
	nVZ8HVj5E/ix+XX+HruIbNIYQU9/y+UIoVcqoX8NdtAb+YsrXWAIcZYiQVArx15XZ0a2Hy
	5h28yUuOWXwFrEC/7xJkzS5Av6FCzMM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490279; a=rsa-sha256;
	cv=none;
	b=npjNM7o4i3Sm/QD/5lXf440LhNHfhrJhXHIH8lRMb8OjLdCjtHmv1VQYWZyx4x1ii5xFOX
	aEmg8CCcgExRL+ox8IMmyRlvDC73J0tyZxJNbgQJB4Cv4H/sjst2L5yhdLS6Ys2Z1yQMMZ
	yD1JleSMeHIhVWVFyNqMDiwX8kpQxj0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JWRpB6Y1;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MpBn8Jg+yemSfT/rKcYB8AJ8VmedmgkSc9fIviOsi3s=;
	b=JWRpB6Y1iNJZBs1DU9803CdrSxmOolpU45qCeCG1mix08n8lggM7/XqY8AsldGCiRZB1tB
	AaE3lQiCGl420ro/r9PlyW9QA5NNy6dlIA4/yzvwBid66gACttuTXHLrkQIAady/2k1KZ2
	JJ3v8XBarISE0JDfy8SJCTzlh5NtyBc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-7SRpu6vGP5eW4st0fKFLGw-1; Mon, 11 May 2026 05:04:37 -0400
X-MC-Unique: 7SRpu6vGP5eW4st0fKFLGw-1
X-Mimecast-MFC-AGG-ID: 7SRpu6vGP5eW4st0fKFLGw_1778490276
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48e60b55de2so35359075e9.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:04:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490276; x=1779095076;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MpBn8Jg+yemSfT/rKcYB8AJ8VmedmgkSc9fIviOsi3s=;
        b=onbxyOeGQ/JhZLKcRLQ1rPqwDqEKiuRj8uqCaSFC5f74sRIN/AkJYjgfEKAjg9GrKz
         oV9mIoqH8RBVRECtLsZIduHsmHo17UKAhCehRHKCtBMzHJtZ0NwfzWPCPk0kvN+c2Ulj
         AGgOS4KJMn9Q2QW66ABPI7U+9PRKLP1yuDzdtJXXdWrWi+yJPVS0UwmbHECBB4xiLEVo
         Nfw8VmLjEuvFqchywWYXYCBMnOZIlG1isELDHup+hcjcIdr4YNIqBPMyxJd2HOlIJgDp
         HVzkROi6yk76wAb1O1tgCJklVVXUCqYpUFkRdfsSdQuM/SNmP1HCRsX7SEro7JmpA2tv
         45Qg==
X-Forwarded-Encrypted: i=1; AFNElJ8nPjkdAbTbAsj9LNljeSFBTF4y1yV5xszqJCIx2HkxNCLz3aq26IwuPx1A6uD6b5Vo8qtGuBNKmA==@kvack.org
X-Gm-Message-State: AOJu0Yya66D3fMHj1Ugk5+PGZHMCYcgu0vUKQ49L7aRp7fUi7h6cIFk0
	o8QaCceABrpw5OHXgqOS1ACjMpA7i1253DTvFS8VumXm8zLHaOILfSew5H2DahGgbXH0Jeniq85
	XaEEuJvBmWs0whdiTufN+xX8qfIOYoHmE5WsH+SfZs3xXpVTA8ji6
X-Gm-Gg: Acq92OHa2Ole/vwcpcPkjbQ8HIn/XlOw3gtwFmITRgGUfSb0oRckAduY4FISTosiWn5
	QrHjj+ncuWoZ4p/WXLpol5S2IqE7B9qfZkakA/dxKUM1ARi6vGHtWUBMJ9eNpelv41mQof5fxDX
	s64f8XfVxptG6XntP1x66nlowdyLhcYbAM9UAik9fHbjBBZjT+n4+4RixyU+W4quTKBE1/or1vK
	SF//ejY/I92vJSDwvVMEn/F0X1tHqkrCpP4s0J/gQHwONENA+8mbdcnQ7aQGgM6rpUvKFfNoE5a
	2E1mnXZ8ovQcpFJn7TZZlqjfrsorgsqVCoc2OD2lD8fI5uBKe2WKny9V0/PuDZKbpJG5tzUNZxw
	+vlUMoz5hVbi6OqzihRqG6gT45y7JNlF1yKMosrO6
X-Received: by 2002:a05:600c:3b0f:b0:487:1fb4:7e1 with SMTP id 5b1f17b1804b1-48e51f4cdd8mr372760755e9.22.1778490275688;
        Mon, 11 May 2026 02:04:35 -0700 (PDT)
X-Received: by 2002:a05:600c:3b0f:b0:487:1fb4:7e1 with SMTP id 5b1f17b1804b1-48e51f4cdd8mr372759815e9.22.1778490275037;
        Mon, 11 May 2026 02:04:35 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e80ca2666sm91683315e9.10.2026.05.11.02.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:04:34 -0700 (PDT)
Date: Mon, 11 May 2026 05:04:30 -0400
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
Subject: [PATCH resend v6 30/30] mm: balloon: use put_page_zeroed for zeroed
 balloon pages
Message-ID: <446baed638f945982fc205a5354611bd24b2672f.1778489843.git.mst@redhat.com>
References: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778489843.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: n2Z6f-PPs0JocTdNh-bnsY7rJz9X_wrUAzyqLg2ox-E_1778490276
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1474780003
X-Stat-Signature: wg1dgi8rf93nzhjsw8uhai3ry943dnzq
X-Rspam-User: 
X-HE-Tag: 1778490278-321319
X-HE-Meta: U2FsdGVkX1/dmtubbvirzLVUgg0aYbaaP4DI/JxsuiXqCg2G/GwQcVn/REn0Ux74UI+WZfkY0UKdcW7VpaqGIWFWpJs6CNETquQssdonPWkPCzvPSaHTy/49ccnvruJ6i7iIAkkE/QOj5m+hlxTEyZKDKKSDNlhK2dS4p8+LkiXjJG8kH/Z4PQTAayhaeSMvCcw/oJB/cmgLJcd2apQ904uISi1XjdsY66iZqmlm69XumhvE7QssOy2UNkOwHhxwGU/HMNRNO5iay9JGj+b1aaVzorwKGT0F3UKICvNMZok7RuqhxwW2Nj0FVTi39PrK65mrpU0B8zC2uE3Y9FnT9UHBu/tO8xOc9vlW63R5/9q+1/u1j5tyxmQj5GMrM5v9X2nZgaFuWGOp3aXqrs+rwh8hnpXBUeJCD2FSIYKG63tI/aSnuFvVebc1bjkIv9hXnz75+lPtgw/gf0f0eghnbnp4H8P9c77zt5HzE6zVGhX2TWcunb6OlVxgpLEvVeQRCho+hj9KOfDqx6kKt8/IDBs0pjM72VfjqpQgaCy+bxznx5k1y+R6Z+L0VYh+Wr2YIizQUS9eFIVWNcFZ5HiceMBy0sb0aNNVsMz+1FSStaf0IfMDk3I/TMApGx2MI4beBgClB8ELc6jvyTXl6CBPOB60pKFixR5Dx1xA2dxJwc5in82zC+qbMpZLwPETra6Inwj2gOQhi8frKP3sZ26zGMbf6llTUBQjrsGXPbvIzorgYNUUVIbwtzoJj+6F/97p3eheG22mgabjloaw8JHKELLp2HbxLZveDMNHJPlwkweSIxuFgyzawDzI1UMEaXBXeoTOXx4sAY3+cdBMksEVny+cvTRauj8zk4YBls0nNIxQSGxIonS4+YcTRlOuMCmSXGuiW86379VGiJx9hpjZyQi1Y8jiYksmr9gaHz5Lyius29uZYsHFt7fehH6itTbJBpOM1Q/AaDxMOQR9Y4S
 Rar9HozY
 Nz3A115HyHJ4S/RtfMFmhnrk3ByisSdchqZoJEz/yYdGXyfqYpnfXMlqE6uhG35DzxFLXr7CUBfQAayDQ1z+Z8EXaRXC+cq6Y7bqLGxJZfevmv0mSY2l363X1Lp6PODXlz3WoiIjEhgV5YHWn4ge2lgf6eFAGxL38DfQTWUxSlBXIFp11LkZgs/jfwdrzpWLbqSotNgBCZH9nwtPOnWuXY5KM5w0h2M9Of4FZ7uCYi3eL0i2z5fWGCNGiSPS/T4Vwz2o8x+JZjg9b4PhxdkzSMotdUEbTTu6kmYidrzW8+fa70gbmF1MjVGFxBTYu+cbQYQDCCXCHbZHUh8lo09d4fsYU9osm3LgExlTbN7S0Q/vYuUAPiGvVdSDCSG34/1hmllpWcqZ9MhTkiBGUHzlbWhKNOh2PU1ntA9R7ubo7M3ouitDbAFzCkPNAWXST9EgtbBeM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a balloon page marked PageZeroed is freed during migration,
use put_page_zeroed() to propagate the zeroed hint to the buddy
allocator. Previously the hint was silently lost via plain put_page().

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/balloon.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/balloon.c b/mm/balloon.c
index 96a8f1e20bc6..1bf7eb2642a9 100644
--- a/mm/balloon.c
+++ b/mm/balloon.c
@@ -324,7 +324,12 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
 	balloon_page_finalize(page);
 	spin_unlock_irqrestore(&balloon_pages_lock, flags);
 
-	put_page(page);
+	if (PageZeroed(page)) {
+		__ClearPageZeroed(page);
+		put_page_zeroed(page);
+	} else {
+		put_page(page);
+	}
 
 	return 0;
 }
-- 
MST


