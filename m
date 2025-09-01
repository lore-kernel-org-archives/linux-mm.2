Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E23C4CA1007
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:15:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D60408E0076; Mon,  1 Sep 2025 11:07:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D37828E0079; Mon,  1 Sep 2025 11:07:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C61C38E0076; Mon,  1 Sep 2025 11:07:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC98E8E0076
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:07:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6F8E113B28D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:07:01 +0000 (UTC)
X-FDA: 83841009042.24.2C0837C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id B22438000F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:06:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I2A74K89;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VuRYozOj4jxmWMcjtZVJC7s6FW6AbDAZr6KxBuADLqo=;
	b=zGGapWyTG5eNVHP0YQfuXISsjc4SbuBuukXlLx19sopyuwY2t4xczw4qBK/tZuZx09gFaP
	d9Jk1FZnIBZBUiXqm4q/LioCckF1pZyD0Xx8FeWnaksoQMv0jKRvNrCFvbhB1aITvp/L0E
	l6E13RFngNmaBQLRLqoZSlsjnok5tiQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I2A74K89;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739219; a=rsa-sha256;
	cv=none;
	b=DDCB3JXZ7CnD4CfTBctIvnFxvRa6soQe8ljBNgHUDnhS/Np9KRyTBE/Xo92fjUoPgm9pxV
	a9KGHEi10EPqEZKhNmKMuyY9QsAfdMnASspI4s0JCd/l5tPNxBnjs6UPuZKMj71Xty61bs
	wCDFY+HK6yqvg8zdoNP5khIJEPL1yVQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VuRYozOj4jxmWMcjtZVJC7s6FW6AbDAZr6KxBuADLqo=;
	b=I2A74K89q8TKsRpZpKkqIYvLjtio8gPCyP84wTXdFgW8iSH8BavjNvlMfVq0jDrryEcAW8
	WzFSck66Xg98rhcxrm45VcCP8UMZ6t2fezp7jKmD6a3DuOxsFEEx6bs5ZpQzgt8Hp5OYvH
	1CEvo1HG5MIMXtYDZy9MvmZnWCMs+GM=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-307-0sc7uRoVMaCioWHY8YjrVg-1; Mon,
 01 Sep 2025 11:06:54 -0400
X-MC-Unique: 0sc7uRoVMaCioWHY8YjrVg-1
X-Mimecast-MFC-AGG-ID: 0sc7uRoVMaCioWHY8YjrVg_1756739207
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BE64D19560AE;
	Mon,  1 Sep 2025 15:06:46 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 69EDB1800447;
	Mon,  1 Sep 2025 15:06:33 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
	x86@kernel.org
Subject: [PATCH v2 08/37] mm/hugetlb: check for unreasonable folio sizes when registering hstate
Date: Mon,  1 Sep 2025 17:03:29 +0200
Message-ID: <20250901150359.867252-9-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Queue-Id: B22438000F
X-Rspam-User: 
X-Stat-Signature: z7new59fsp74tr1juybd69eionrrcj3k
X-Rspamd-Server: rspam09
X-HE-Tag: 1756739219-880332
X-HE-Meta: U2FsdGVkX18N2oYEiPzoHqKJ8Iz9ySFt2NuUVUt+nloF4WxNTw9ySeKokj4idwQ3D6OXG2Td7vOzb4Zv85LQvFthry4sb6/KLp70yBBYUxpzhgNcsWLhfV3y3sHnJ/4Bk7/WvKoeKOZsvhxnAZmNCD0WH4f/Vpr25KyEEQIWAWJp57+FoOgYRMS7jFdx6SToDC1D7T/zpGtqtQf5+tRCRfA9DUkX5IM6yZxNLNLzLK61SarP/gwd2G0mQTwUFkHKyNCHyMM015Nw1jtixR3Dvn6YESl1T4DlTaPpRt232bhJaTGbja3X5Mjtu9Dm3pB7ilfjE0su9DuA7mELsl+c3PhCdYoVvf0KKJSvh266ioor5ihlMNVTxs9uFSkuP5ew303bLiNhrkS52Ge0FwTgCbf10VxWU940DwI11p1l+SFn9qIHXzFBjtBMfekEK4SicjO0e8m6eVUSIBWCe7aIrDJ5E6DnFRcFGwdfHMKZg6kyahSbf3eL4T6o5hBJDV1UvKuSpB9PjzREfycMYMAtIPVY1hsL9Zp7tp61FP5v7dpuZufeiH9rvZ99SaqBfxuXSfry5BnSC36TrVmdbdfclNLVu65rT1imFOQ+ZhBL621cHrEKO4jNUlTyGIzskbnT/dKIWlsC2Syi3IBtdAnnjPcKayPRyvRAYGuV4m9yNrBg4umZ5u+s/24E9V3ffjrHA+3ceMJKiryedSzlQWBPZhTk50D5URShGTYGYRq9kH+I6Vx8cge5zXC9PZLdI2c6cZyAKwmSveDOUUN2t3mJNYltLtRebl4FXqyLLHviksSBraFSANrCRBH2rUuSSaXBGFFfHfAqyYWvhOBgWCLc+fZBtRbzEDGTrhKrMdHkQkglk3lQtu87+SU7vSlSDT8HpcFSAxC2MUlbxxe5lyaA1Nde0+QsGv3oR62W8NldjUGIiTUpvkV3NDjlBMCgEvWbaiJSnfEIPa0vKzNmQrK
 VBOzam2K
 OXXN4L7KV7gG51yELZpiPg9JWTqYD4o9U/8BmAs8RF+L+fGDeMhGPXd+JXPnvb/99SYWSJYOvxLAUo/aFKi/sWl2FdHEnicGKWRUSL6P2fkSy/4kOjhAr6QnPs1Jdcf+3J9v22QwgbRUYpwVZMqR2lOSyopH+UPm56befzjrsi8XgZycYVT9JtCtUEv93ENu3tdF5/EH9kRlI6ViKfvcale2F/wramy+7mEUw/TZ4nlZC/Xz9SQJ0dZuG/UZFihwxX92otsnt19amXVu6kwBV1Q9UkR7WwCCJruOPO2+mUvYHqIdNhw1g0bn1LRUfhYZzNlxw25RBECuaY0XjrlLsIKEd01T2K+eBFV+9tuAoen2cXmfDPakKO+MLIk6FMCpdnn1j
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's check that no hstate that corresponds to an unreasonable folio size
is registered by an architecture. If we were to succeed registering, we
could later try allocating an unsupported gigantic folio size.

Further, let's add a BUILD_BUG_ON() for checking that HUGETLB_PAGE_ORDER
is sane at build time. As HUGETLB_PAGE_ORDER is dynamic on powerpc, we have
to use a BUILD_BUG_ON_INVALID() to make it compile.

No existing kernel configuration should be able to trigger this check:
either SPARSEMEM without SPARSEMEM_VMEMMAP cannot be configured or
gigantic folios will not exceed a memory section (the case on sparse).

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/hugetlb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 1e777cc51ad04..d3542e92a712e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4657,6 +4657,7 @@ static int __init hugetlb_init(void)
 
 	BUILD_BUG_ON(sizeof_field(struct page, private) * BITS_PER_BYTE <
 			__NR_HPAGEFLAGS);
+	BUILD_BUG_ON_INVALID(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
 
 	if (!hugepages_supported()) {
 		if (hugetlb_max_hstate || default_hstate_max_huge_pages)
@@ -4740,6 +4741,7 @@ void __init hugetlb_add_hstate(unsigned int order)
 	}
 	BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
 	BUG_ON(order < order_base_2(__NR_USED_SUBPAGE));
+	WARN_ON(order > MAX_FOLIO_ORDER);
 	h = &hstates[hugetlb_max_hstate++];
 	__mutex_init(&h->resize_lock, "resize mutex", &h->resize_key);
 	h->order = order;
-- 
2.50.1


