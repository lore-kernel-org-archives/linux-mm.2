Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FBE4CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:31:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBF5A8E008E; Mon,  1 Sep 2025 11:12:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B48E78E0084; Mon,  1 Sep 2025 11:12:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A38438E008E; Mon,  1 Sep 2025 11:12:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 89FDC8E0084
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:12:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5D17311A3BD
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:12:53 +0000 (UTC)
X-FDA: 83841023826.08.3E033AA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id B2B35C0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:12:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="OXPG/hx5";
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739571; a=rsa-sha256;
	cv=none;
	b=cvOv9cAr6KtMvxjYsgDN5D40JexTRtTX5vGHGOwCtDLrGaCzUJlYzuVHJS9PG3Z2IpnzUn
	t78PC2rONowOvsoxVF0VuC8H7gkiSXwoib2xb+QS0qzADWEq6SXd05isFB5caXZym80Ogk
	MSORYLh/uoQg4NN2isAfPG3wnfccwKI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="OXPG/hx5";
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JVCL+sDJBGR9bgMgmkBKkSxPQW+6L4IAi1OzfCPQ8Uc=;
	b=HZ9poWqXIfLFJnujghbk9Nt+e4+Jg8/toCXhQIzycN1Pnhn6J6yMKH7ZIiFpjS/nuW5ZiL
	EkKMAsIS4SeAhn2mDqOguSO/Ad6BzG5Kly4A0jlxD5hWrKnb9c3RiuyY10HlefW+JXmTl1
	MtOSTXnQaG+1hQgjjML7eneomARcjwM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JVCL+sDJBGR9bgMgmkBKkSxPQW+6L4IAi1OzfCPQ8Uc=;
	b=OXPG/hx5dUKCgYxHRb7SjR/sbTZX49LcfbY1c+nvLGBHqxo1lvu3jETgCIW9Nz/VrT6zH5
	rCq06mdpzpXUw/x7ZQn/jClCuiz2W9Aj8k3pydzEvQ0j+l9gjm/qarQeKTnVnkjIp0HWLh
	PN/+A7R6252laKbxXQF2sW/hk6xaKEs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-622-R8OgGqqjNtqx4P4_88Q7FA-1; Mon,
 01 Sep 2025 11:12:46 -0400
X-MC-Unique: R8OgGqqjNtqx4P4_88Q7FA-1
X-Mimecast-MFC-AGG-ID: R8OgGqqjNtqx4P4_88Q7FA_1756739562
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AC08F195608B;
	Mon,  1 Sep 2025 15:12:41 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D93CA1800447;
	Mon,  1 Sep 2025 15:12:24 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Doug Gilbert <dgilbert@interlog.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
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
Subject: [PATCH v2 31/37] scsi: sg: drop nth_page() usage within SG entry
Date: Mon,  1 Sep 2025 17:03:52 +0200
Message-ID: <20250901150359.867252-32-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B2B35C0006
X-Stat-Signature: b1gfegkssibfhwqb6unggygebnj6j5qg
X-Rspam-User: 
X-HE-Tag: 1756739571-848576
X-HE-Meta: U2FsdGVkX1/HqpEcC7guDTdmKt0GrF6alXt86wMnuoYWk4igXkIUVdPFzURlq4J5VrrL+DiZER1YBVgR0H9/iw1AXxMUOjTCk1BqenpPpoIYHgT8LfvOqVo2IEFAPhuM3qWIRkHMGCZFIOzCq/zeEGm0NipIDorepyuwSfIdGg+M2EJutFFMWs3akKde9fvKCtmKCiPjw27ZvH4Tcs3tChxjt9AO7qEgFLLse+TPT/GE0k1ohMGGhS2CfbxWNi5xIXZAc9wl2SnKAq/kmmVhyQAyx6vrnOBD5JYNObdkDqZuuUTuPMnGwk2XG9eJYPmDZGFziBBAzbBrbN757AtlvvFoFjHA/j9YcPRI3yWSI/gS5z3X6zAdRAwLDS/saYDHG2qHRm+cWeoccd5ON+pbMilfuwC9z5T7EWv2SJ4TTnTwp2nax8LKV4ZPqXtQDvHu3NWOkvetgylpQisRI8WJalnBYQR15H/wQEBxHww6NxkTWhycxmapq1DMe5+ZOgibOEynuP9/5E/ZUnij9o4+secvCRxr6T/tzEcDF1hjgmSLCjsJLTqevfAjV/0mPnCbDnycgmiFb8YGs+8Kg5u2XMqxuEteTDFrYf7oadVo0ZZdfZZdBmiOYu/JYLQwk1LdGo5wedeXuzWfpnefd6HoI+cJphzeAT48H6MjaVr+naNlqEYflj5ooMdkyz9/kovwOkYS/Lts6Lt+u/f1JbX6jxBPr0gjN5834AzIa+9xk/VFTS6uhgsSrBTlKEM6kWxwhDWj5z3/nW2oZ6VGbpCc4g4miG481llihL+6c5/XEPLVx1qFs08lCm23Iz+ItLDIhOrhxbYvaJ15EmyIwEKyy1VWsebzChlVbj+2fmwXutJ5gMlmkYm20Vvto0FksDF+Zt7s+Dyyx99k0QkiLdONpulaGXRSDZlcFXQ4kQotRAQ9oxIqingo3WVGfzhIuVMDXTdhikuoaYq5dlTbl9N
 6XFhPdXh
 gKQRldrRxHYd6hyNash8uU2QFLIWOSM+RssYmW/uTSUvWFTQ10XMxqKNHL2trryM8i6MqVgkCb9ms94WFbBo6mgUFZw9Ps6xJxC+mb93vJE6dAao=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/scsi/sg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 3c02a5f7b5f39..4c62c597c7be9 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1235,8 +1235,7 @@ sg_vma_fault(struct vm_fault *vmf)
 		len = vma->vm_end - sa;
 		len = (len < length) ? len : length;
 		if (offset < len) {
-			struct page *page = nth_page(rsv_schp->pages[k],
-						     offset >> PAGE_SHIFT);
+			struct page *page = rsv_schp->pages[k] + (offset >> PAGE_SHIFT);
 			get_page(page);	/* increment page count */
 			vmf->page = page;
 			return 0; /* success */
-- 
2.50.1


