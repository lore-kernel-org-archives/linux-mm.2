Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24D6E606A334
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=HHUJwHSk
Received: by kanga.kvack.org (Postfix)
	id F0F486B05B5; Mon, 26 Oct 2026 22:56:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBFDA6B05B6; Mon, 26 Oct 2026 22:56:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD5416B05B8; Mon, 26 Oct 2026 22:56:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9EAB76B05B5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:56:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 024661C42B3
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:56:45 +0000 (UTC)
X-FDA: 85366893612.18.129052C
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf21.hostedemail.com (Postfix) with ESMTP id 453C81C0007
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:56:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HHUJwHSk;
	spf=pass (imf21.hostedemail.com: domain of 36hLgag0KCO0ZTkXcadjVWaXcVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--kevinloughlin.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=36hLgag0KCO0ZTkXcadjVWaXcVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--kevinloughlin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793069804;
	b=fksxgvuyEQehKqrKXdovq4GGF+OAzn0EsdXlVY4pXiIawYYa+vnmg4/h7CNF89J9tBCMGg
	O6k8AvptPO/vbIiDrlWDaMv08BZrZi9JqsHL6Bzspgx8pG7f+aK+yt1h9a9vXB95sFVo/P
	q8wyE00uzmm17r623yPPq6LNdEeoF0s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HHUJwHSk;
	spf=pass (imf21.hostedemail.com: domain of 36hLgag0KCO0ZTkXcadjVWaXcVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--kevinloughlin.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=36hLgag0KCO0ZTkXcadjVWaXcVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--kevinloughlin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793069804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0uzqgwftXz/DV+yjf2QpwILGgyMTBZAoH8uvJ/r3lMk=;
	b=KbdjZs1FxSKbON659PUgb163sLVEGL7/ahQcWunMNSeEeB/92BbU29NDw74SParDArzXt5
	kY+yH50X7Qa03nGH45I08XZJzwskd1pmukN8GxHOFEWWHh7lp6azjo1b7FUul2x9oZEizb
	awrxAVgpZ0Ku7BPYobgA+wnJIwyS2RE=
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4c734afb8deso5325374b6e.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793069803; x=1793674603; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0uzqgwftXz/DV+yjf2QpwILGgyMTBZAoH8uvJ/r3lMk=;
        b=HHUJwHSk8R9IiFh4AsnKLMRaKrqReia9frL8tJAqkFiHOdQqxRCvUuN1QUc+4Gd+6D
         Lkb5L3YwMMJZUaryk3h1sGhSd7MjuV+dx5IqMngSg9Git71h7WgY6Mk+3gec8vWoqC9y
         bFzrxjEZ0HhWAN+Z3DagcLqmgA6/GJCBJjATz20i1evZEhiDQFgs6Xrq0lU46Ygu3/zC
         kNeRhJEiZthBiggWytZnU1PwLhMER3bgOnmb8XHDOewWr1BqtsCHsDdoL9AyogfvYWNB
         oMCkM5n7asdeWdOeC7EifGM6kPfglm71TSr9MEXpF8aIZAXUKcgFPQ8JNd+h3JBE/oqm
         yvsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069803; x=1793674603;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0uzqgwftXz/DV+yjf2QpwILGgyMTBZAoH8uvJ/r3lMk=;
        b=CELL+d0g2LispQq7GzKC2rdmCW5utH/2g+oFg5fax0P8i+UuewynWGVfONMvPGlv1W
         b1B/qbe3dlzhSlkv41XLPkB8PnQHpD7buzVAXD9rO2UBWwWEAn0mpI9dThUXjWep2XOn
         ir1wRs1yTGpI9bllgQC9UBI7l75Pqapv4mJR1PcV5SMdDs2FWjmn6ENhJxGBRqAFpbuo
         m96RxSq4L6lV4lOQ0pwqRX80hBKa/ri4CGA8W+bQAEvDo+Is9DfIxXbgiha7a4Ej0uzM
         fvyY51fzt0iGANUv89ADn2wuyDIpg7+MoURYI1ULn5rPrMgmv3QDOt49G+N9pYMNucS/
         F5Yw==
X-Forwarded-Encrypted: i=1; AKwUvBxxAbPMYy0EpChPribPBeSvVidlsjNeqg0X975kGeX1MR6T0QfBLB8h/a5yDOOfplaTzF0pWd/1xQ==@kvack.org
X-Gm-Message-State: AFq9FYL2DVC1RsMq7Y9nP3mNk0A0jrmCVuBsVUQd5kKlOTMdJCthwkcU
	wP7basJCT0QJn3FQ/8As3o8ozmZjKcPVt8/pRXDq7Hdbl/3kfQlg4rvl3W072GKURP0ZASEauLI
	md5l6koFvVvO/HK0FHG/ZQvy2dle5CEtQZg==
X-Received: from ioxz3.prod.google.com ([2002:a05:6602:17c3:b0:9c7:733a:80ab])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:448b:b0:4ea:14ab:142d with SMTP id 5614622812f47-55c002fc7b3mr5525425b6e.40.1793069802970;
 Mon, 26 Oct 2026 19:56:42 -0700 (PDT)
Date: Tue, 27 Oct 2026 02:56:05 +0000
In-Reply-To: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261027025616.1632690-3-kevinloughlin@google.com>
Subject: [PATCH 02/13] virtio_balloon: add reporting_vq DMA map ops
From: Kevin Loughlin <kevinloughlin@google.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, David Hildenbrand <david@kernel.org>, Jason Wang <jasowangio@gmail.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Alexander Duyck <alexanderduyck@fb.com>
Cc: virtualization@lists.linux.dev, linux-coco@lists.linux.dev, 
	linux-efi@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sidharth Telang <sidtelang@google.com>, Punit Salian <psalian@google.com>, 
	Peter Gonda <pgonda@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Jacky Li <jackyli@google.com>, Steve Rutherford <srutherford@google.com>, 
	David Skidmore <davidskidmore@google.com>, Kevin Loughlin <kevinloughlin@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: jzxpwqxrh9ojr7smreyfk6eepgk8wtgc
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 453C81C0007
X-Rspam-User: 
X-HE-Tag: 1793069804-470165
X-HE-Meta: U2FsdGVkX1/sGVZjBEcFOb+fnFjFsaDxyQumTsoQv0jp+3LqvVQ8nK2zzF3ADkfbET7tUnEASMskLb4wvIp3ivv4DXA1bQBKEOccNUwncLY+UNV9Hf5B/sTPqbWh80VjDwMG3b9I+c1z2ym7MqhrzdTYxOfV5/3A8qNeT0tQN6eWtbYADpxO1JZXW6xwGLMkj2ig5aZo7uiVltZr4k0Mm4yTdYdNjuJt6alFtQccvHqiJ77rqOPJoOnQL041sXigdnCire+j+b6F3TTDKVWLZjOJ6FgKablOV8mTmypqpBhNsIUdvQTXdTJuYjlxeNqg8oltKB4kuW5tuG5VVRkB+foh6smAvNJNTl3UTASlDEsv7lED+7TRAGfsO5y9UveEOkxaGNuMz5l7fhiy64NmGvqvFrpv7vwekj2CLenydwIi/Jwf4cj/20bjtirDvKjezpa6hI47BzA8JnYsvtBHKy62IaMFTMrjXTKYTE2HEXDO2FzQfnBh5Ma6J9x4p4oD3AHA0gv3OqHiF6eKMAsHnhtmtEq6WiunDJbRnO0a0EUxiuBDdRKxnEB+u/5NJLU1bo+WS5BnUV/DY74ZYztJmy/RwMmRn39Mm9bdUZb1MCyW4Wbf+8Hnh+yymZhsC7qLKuGU6H8izQotBrzQpZ79Ym8+mGximdkRhwnlX6BKa6ahMyynn2BucZ0213pVS4NidW20RqIqHJ4/Fur2NGVXWWbJFiZnfs1Jol4i9DonjyQgvLuZysxFtoYMjW+04ywxKzw2x10kh7tE8r/EGjYn40ljvyHUZraYSiPKWWasLYbyS93/DAEcH31TxzcqcWfUyWSzEiTvtzKMZfP2kdNXr9SF4plCojVhTuXq2vzBnc6CPumDy7ZmLsj/Turrd/b4vYCjpej3Mz3fZXeO9aZhK3WkTHimcxNsqz1s8E6ZbXGaJ2xky5bC3akU2XdBmH0ZyFgohoZDK2ISkhMtKFL
 hzt62p/c
 WnftT1VqutNFOXdxLYJE88N2OunNE4qqASHh8WlJTXCB0Uumij5N4rT7/8rZnU37VsSYo+seSlpMetYBP2Doo/cmhsNosefQvkM0NIN+7c+oTMHopDpWdnhWNP9jUtwsXxy4qOIiodIOXTk4eIVfeGu4cYilDiVwR1gDQA9oy8RPVF9Y4gkfbGglDu8WMg78lwae8nseo56CXerI+1Pbr9VuetqRL6hgiIxbsw9UwLIYmaUnzhvPgp57VxZra14BCIPpdz7t/eOfxpWOGoc0tPKlciOVwaE4MJ6hHhYB93wf7j3wJsaHC118y8xLMJhEsBhTK5suA+56WqTyMBZfN1olkjz93lBHIyBzlEURrUrDWLvxq9R0OTX6xwgc0QdlzNthnDKD9ovaABVJKsvrYlvAftgMruvb+EOJh2q9RWAOXB+5Er6JXJ6K5F0dhdIm+FtivWd2kwKp5jdLy2WmD+c9irrdCOz9cQSLSLf8prxFN3/p5MqQjb80I/8u/ka4vhI/6VgiQkJ8BMJetjBtHK9EhgK2HfjH2/QZXNk6PjVnChs+hQYVytqfs1TH0e8SJjZUFmXJU9fDOnuCGrIZbwGJaO+l4LKgi+5qvaeVaVi0oTjQyto+at/tOWSlnPFuFh0WZ94WKnwteEx59urdhnPUJ7qnKXWf0ZTe4Xm//l8iAIuzgskaPJXexds0jFDqhVtE8lf6arESpH14hrb91Ocu0cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In confidential computing guests where VIRTIO_F_ACCESS_PLATFORM is
negotiated, the standard DMA mapping layer rejects mapping unencrypted
or swiotlb-bounced scatterlists when reporting large free page blocks
through reporting_vq. However, the host VMM only inspects the guest
physical address and length of reported free page ranges in the
virtqueue descriptor table and never reads or writes the reported guest
memory payload.

When guest memory encryption is active (CC_ATTR_GUEST_MEM_ENCRYPT),
attach custom per-virtqueue mapping operations (balloon_reporting_map_ops)
to reporting_vq that translate scatterlist entries directly to guest
physical addresses without allocating swiotlb bounce buffers or
decrypting guest memory.

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 drivers/virtio/virtio_balloon.c | 56 ++++++++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index ab3e3d887e00..11f74848fdc4 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -19,6 +19,7 @@
 #include <linux/wait.h>
 #include <linux/mm.h>
 #include <linux/page_reporting.h>
+#include <linux/cc_platform.h>
 
 /*
  * Balloon device works in 4K page units.  So each page is pointed to by
@@ -580,6 +581,55 @@ static void update_balloon_size_func(struct work_struct *work)
 		finish_wakeup_event(vb);
 }
 
+static dma_addr_t balloon_reporting_map_page(union virtio_map map,
+					     struct page *page,
+					     unsigned long offset, size_t size,
+					     enum dma_data_direction dir,
+					     unsigned long attrs)
+{
+	/*
+	 * Free page reporting transfers physical address and size metadata
+	 * via vring descriptors; the device/host never accesses or transfers
+	 * data on the page itself. Return the true physical address without
+	 * DMA mapping / bounce buffering.
+	 */
+	return (dma_addr_t)page_to_phys(page) + offset;
+}
+
+static void balloon_reporting_unmap_page(union virtio_map map,
+					 dma_addr_t map_handle, size_t size,
+					 enum dma_data_direction dir,
+					 unsigned long attrs)
+{
+}
+
+static void balloon_reporting_sync_single(union virtio_map map,
+					  dma_addr_t map_handle, size_t size,
+					  enum dma_data_direction dir)
+{
+}
+
+static bool balloon_reporting_need_sync(union virtio_map map,
+					dma_addr_t map_handle)
+{
+	return false;
+}
+
+static int balloon_reporting_mapping_error(union virtio_map map,
+					   dma_addr_t map_handle)
+{
+	return 0;
+}
+
+static const struct virtio_map_ops balloon_reporting_map_ops = {
+	.map_page		= balloon_reporting_map_page,
+	.unmap_page		= balloon_reporting_unmap_page,
+	.sync_single_for_cpu	= balloon_reporting_sync_single,
+	.sync_single_for_device	= balloon_reporting_sync_single,
+	.need_sync		= balloon_reporting_need_sync,
+	.mapping_error		= balloon_reporting_mapping_error,
+};
+
 static int init_vqs(struct virtio_balloon *vb)
 {
 	struct virtqueue_info vqs_info[VIRTIO_BALLOON_VQ_MAX] = {};
@@ -641,8 +691,12 @@ static int init_vqs(struct virtio_balloon *vb)
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
 		vb->free_page_vq = vqs[VIRTIO_BALLOON_VQ_FREE_PAGE];
 
-	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
 		vb->reporting_vq = vqs[VIRTIO_BALLOON_VQ_REPORTING];
+		if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
+			virtqueue_set_map_ops(vb->reporting_vq,
+					      &balloon_reporting_map_ops);
+	}
 
 	return 0;
 }
-- 
2.56.0.307.g5fe7bd680c-goog


