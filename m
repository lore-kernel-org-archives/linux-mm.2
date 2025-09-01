Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B769CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:23:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04C7D8E008A; Mon,  1 Sep 2025 11:11:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3E248E0084; Mon,  1 Sep 2025 11:11:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB85A8E008A; Mon,  1 Sep 2025 11:11:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C25498E0084
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:11:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 92D031DEF7D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:11:44 +0000 (UTC)
X-FDA: 83841020928.20.83A18BE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id CD2CC40009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:11:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YFpSXaDQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739502; a=rsa-sha256;
	cv=none;
	b=sAIvfU+MVO3KdOSx3LeIY2T1JBHi/vipyk87RrzoGiUNbHEBGkd55w3m8G5bR1FrfwK4MR
	HOjb/PHt94mjqFo4bvQaR9GLqKFMgDYRaKAHFDKfKcHpnKHqSSr9AxcV4+sRZCOENfgjIM
	peh+AOMvYbgwgASOvuxb3KGcA/KWWJg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YFpSXaDQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p1jCKThuxMeVarNn2yntb5yTQBw7NhKRXi1yCoCreSs=;
	b=Fq0sRAV7JQH6Itq3lyy3Hxuu/0IjSXuGvYMOJ2n/qKKb9mJZcCGYRr270NPcUShnVrt7WB
	e/w/GhTNYF8cbSB0sqjfeOoCn9dsTxFjjV0pZtVNFCPsp0RkSxH9CvudUHkIDjGtnp20q7
	PMG+viNn9YT4xypwN1sQhpMwaC7S9Sw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739502;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p1jCKThuxMeVarNn2yntb5yTQBw7NhKRXi1yCoCreSs=;
	b=YFpSXaDQsFgcOVvGI60P8OtJ4o2CaibMwj4l6fB7eQDUJ9JwCZdX+SFTe8WJbamzMuLY1P
	r+2A5s9Mwj8Hr5jiZ04kUfe+q/FutMBpmlEWSNV1mlVNxSxZ9wzszOD/Isi7GzXuOimNIP
	rKRaAtmNXi5BMP3GCeKJgvkU3MeZlWk=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-687-20oygJbWN0mott4utV957w-1; Mon,
 01 Sep 2025 11:11:38 -0400
X-MC-Unique: 20oygJbWN0mott4utV957w-1
X-Mimecast-MFC-AGG-ID: 20oygJbWN0mott4utV957w_1756739493
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C115419560B8;
	Mon,  1 Sep 2025 15:11:32 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F28721800280;
	Mon,  1 Sep 2025 15:11:16 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
Subject: [PATCH v2 27/37] mspro_block: drop nth_page() usage within SG entry
Date: Mon,  1 Sep 2025 17:03:48 +0200
Message-ID: <20250901150359.867252-28-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Queue-Id: CD2CC40009
X-Stat-Signature: eo4146if87jygy7bu79xodfo57twmwd3
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756739502-988551
X-HE-Meta: U2FsdGVkX18Lc9lnPqR9xrWLcjEXBrClGc77T4YpGeiRgrcKGlRqmSVbTLe5bx+7tq5HJ4l01yKGnOoYpARaLXSMfqBim16dm0+KjSvKDdvIUAh3N36c6OvfRdY20LwAihH8VY7sNZPCngVMqXGDuHW5Eyx+prLB/bk+EMkrykMVr1iAA5ILPvIKTZ/0SjP3WsTVnDkLur2k9RRJtOvfaTLeNpJpQRI5Qa3oTqyxsfqM7NnEzXRooICbcdZLlPQZoT5DBsWE4kotNlZoXmBm6SbDJfkKshOzZsJDn81226+M5EzvNeUN7lbQhceO86a3NLU5qsqHQgZWbRsUBTY6MbbB/bps8YbeoK173oq+uV8qTXOTFSMJBxIaNfBZbuMU6jDvSxjxjUH+Rr2JxeFbQMPVJP8luQurubn8dM/tRKFs/AwtXnlPw89wbVAV1DBM/Yip3xfXcaNsYoDgFa3mDTGs/8yV7MwCiCfkrFHZyOOcb1c2j1IkuBb6ovCgULtpbmn0O6iqNmrNB/Cp1vYOYVG08Pg6DyV4wQT1aAPxiL/33l1M0tORBnHq9Zn79kS2xBlEl9n2vvYs/moM9w7XD22iJ6piJNXaNBvD2o3qIDp0h9+cr/BKiXFBAPV7LO/QBDQgomq1VmHw7PDyEZateHZra96GYXuxDVenmZSvZ0nZ/eyYyz5fp1HqLISKIi7J/Jj592/K8BsntjI85fdGxGrwLN8tRM86Mdmkg5Rl0EvAfvDcyWTx/qP+bF2/ah4yeqWtwCmstCwfqj3UOiB/1me2FhitVV5yDB0HQHx3XBf/zMbSqMqTQCoKss2OpwA5FeC5rvwYU2zkrCSfnYWzNxPXORfZkB0sQFE2TC0fDZ8ijme5t4wKknFTqME4gt/NQRQV8ew52kTlLIeN0hNP9Hcy/behobJKL+G5XeKnEOsPr8u2HuExEdAO3JT7+fkj4dWS/Lrz0ut16xaPV+Y
 aOzEPSTY
 nx1i0HXeZ8B4mr4kDieUNhbnPhyVGtVAhmHh3d9tugOA/Tr16kjZmZvqyWiW41HPH1HDRWmWPVc0VilAy3A/F6gwlFNkBnzOIvyf79W/fOLUV5DxAIiUSw68tBEo7rG07jnoWaHB3gGpWb2yz5TdxpjcnX69cGIYI1uFSst5n57W5tB60eOpWJnYDyxusZrWVzgxY7t9N0iPosMlKQi8/FyJxOOYTG/T2MHEncJfOxmJjLahTuiJNmawVVoWvmzo+6oHZ3jjgNiXjjUa1SPiJ467iG1HxUDFSp68iUyhA8cgMIF3FvmKpMRv7dfEJSbjPZYyGNNGgoY4wyHUjHmbqc4bx16VNABM7ywQLjFQJiZ/cslXMYzQKFrciFpjlXP7I8isDYjtrcw9FWqs+TITHCaKK3u8KED8EhhCd7HeDtLP5dCUbiMg2ZZgp/hbOekHm8GSibzEUMrJxcE8ccN4IhnSIM3dSzvuE/CbD2p0AjPVwaUPUD/aHcaPECBKvZTw0cxFL
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
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>
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


