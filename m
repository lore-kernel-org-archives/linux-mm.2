Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 127F5CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:21:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7F258E0088; Mon,  1 Sep 2025 11:11:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2FD48E0084; Mon,  1 Sep 2025 11:11:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1E3B8E0088; Mon,  1 Sep 2025 11:11:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9ABB38E0084
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:11:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5227A5BC6E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:11:12 +0000 (UTC)
X-FDA: 83841019584.06.68D25A8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9706D4000E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:11:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="c4R/HSUG";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739470; a=rsa-sha256;
	cv=none;
	b=D7fvIY+yPznL0yPJKkBZbbmqhMZlQybqPmV+u00fp17ACTetIOjRkriXZQL6iEaIZQcP4r
	DvRBL+K23kmk94ASmrIN24l4AIyi+5rszMTK23DDQIqJRTVDNKQEm/frXmLHJTOFdavjVi
	9s7AFwbcjGymL3r0rqK7/BeQVoJDg/g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="c4R/HSUG";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XXIrQPK2KTSHTm5n0r+eAcK1OeXNu/U6cGKCJgmF5aw=;
	b=ejVRqejNpCUFB8xBjOe5fj7PtX8EqIhw3XnV77+dnjfagdG6Bqc80+utPz5jHNr7hNS0CW
	faT5OLp1ZbE2o19sQ7tGOOs+YgJx6YJ3p28nh/SUsxOY8a5NbPyl55+10Je6TnpgM2UqJl
	c5+HkCtyC+H/m0cZy5r5n4KhiFNc3E8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XXIrQPK2KTSHTm5n0r+eAcK1OeXNu/U6cGKCJgmF5aw=;
	b=c4R/HSUGSvBTEtAstycVjSPvmqUhu9nOYFCuV5q2fVcYkg/h5/nflj64mspIXY0y5iL3Ke
	C/FJzvSJYa7S7NRJdp53BthVC0icGQ9WFCvdyJaeZK7kJMdIQvuK7xpfEkzEd4my6P2fmY
	2Ioa8p8tmWhYuZvkFXJdrCZxrbd+vjU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-80-VJeTZUpaN-Gpu0-I1j8nww-1; Mon,
 01 Sep 2025 11:11:05 -0400
X-MC-Unique: VJeTZUpaN-Gpu0-I1j8nww-1
X-Mimecast-MFC-AGG-ID: VJeTZUpaN-Gpu0-I1j8nww_1756739460
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 389871955F27;
	Mon,  1 Sep 2025 15:11:00 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0AAD418003FC;
	Mon,  1 Sep 2025 15:10:44 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Niklas Cassel <cassel@kernel.org>,
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
Subject: [PATCH v2 25/37] ata: libata-sff: drop nth_page() usage within SG entry
Date: Mon,  1 Sep 2025 17:03:46 +0200
Message-ID: <20250901150359.867252-26-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 9706D4000E
X-Stat-Signature: p9xrdwoj96ff1cuke1op8bfwb7mwfmgj
X-HE-Tag: 1756739470-691956
X-HE-Meta: U2FsdGVkX1/ry47eS5pnGVSxD0p0DJ9cymhw3j+mmG+ha1lbsYKU2BNIV8wxEtoJL+uwXlPXYVHh8vIvKk+k5kCuSxwuQCbIrWXH5ZuuzJXgvhny4N+HBHM2+K6qfF8TyFSdycNfoXFW+2P7VdoX9VsbqPc5z1Bo0hcgJswSmsuf+MsuC3QgDlygyWf4I90aU54HaunaZv5BpVhahVz07NcaRCFinOlIk3yLDKMRf/i2KAI8eIJKQNq956tKBKNmrPAMegqVzZ2gEn1SOB4lt3i0SQEcRvQzLkU1ze2wSYJDRCts5feZZQgh+V7gTCgsSfiRJf3PZtVjjZ1RWwyG8jFrB2u63R7woAOc6GIVXg9WbLM59skDbLGYRxxa21c/I4f83o6SWpmpW8y8ofzvI6kL3iw96phfjrXrMqHy7pEG1Zl6riEhTSTyCjwSE9uF2SwLFncFHjHyC3Du2T0MPtAQmUQbmOZVgKG8dH+ypqPEP6PPqAJLimuYHpJkRZkUQ7dkFj03fjtFgOWSBAc33sEncYaCGu5kRdhndL+DHnkNzEXni5GiS5SNy3EsM7hCKym2rqtzJpelwZv0gebhWm4t+9kbFQuAT1jCxOHXUSm1A7IpaY7C9BcW/Qh1CDLZUoUCbjogPQQg+yWVT2uDsaZ9yhYOrixsvwz3P+CEM03JyKEsLbNtaqaM6IootCxte6cbEknbxBwdAXAyYDZy8vR6vP42aO2uTvHLUmnapq5/V7xuzGs3zCypY9K1VT86OFYY1XvFwydS7sKMkA4y07V6zd++33iJNamiwBLx0a5B1m6fS/tKbE4CsRlosc3RsPC9bIXCYt/EfAoV03WsFO5PCJLp1aTgCO3TCicfYOyPklBZ0YNozzKxCGPFvKfbaHv9d3nhfko6puyXz5r0owXJgv5C7Dz8Nh8rDkFAmawATnhiG6HrS03mYsKIxEBJRfYLx73kmSx26gF0+e/
 tsIiadOZ
 lL3j19hiLRPcLgeVEOkwjbSZ6zGwXsrD2OuMRQ+4BRmgy+0EV3GK/+p/nQL3ju5Uf32gheZlbnJfTF7dbWCVHxAUKdiI1wEcITi+5zwczPDPZezaLqZUkeXNKA1FD6wJSBamt67ANokvtwAtBjVu1Lf3DdF+eoZqhnixpR7md9KqpU03cINvm3FN7uPjr+fxfPXi5IRHzhzEB7BcKhv4UyFhtfr489ZKTEjMXaiSdlQSelLmUX37R4P9NQo1oHA1PGQXxqMSoId+JQlbTxcj+oj2LjRrGMDJR1DLRNZXdjCHvvlIzgzgDUsZyXg03DBPJMLIVChqmIk+3hNtyhO46kSxL9QGOz6dYlh/C5fltm2fNpuTBmD88YvWxOpJKlHVYW+xNz9/fUTumvMWg99ywYsOcd27W5xfUiv831otM3ES8fJA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Acked-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Niklas Cassel <cassel@kernel.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/ata/libata-sff.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 7fc407255eb46..1e2a2c33cdc80 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -614,7 +614,7 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 	offset = qc->cursg->offset + qc->cursg_ofs;
 
 	/* get the current page and offset */
-	page = nth_page(page, (offset >> PAGE_SHIFT));
+	page += offset >> PAGE_SHIFT;
 	offset %= PAGE_SIZE;
 
 	/* don't overrun current sg */
@@ -631,7 +631,7 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 		unsigned int split_len = PAGE_SIZE - offset;
 
 		ata_pio_xfer(qc, page, offset, split_len);
-		ata_pio_xfer(qc, nth_page(page, 1), 0, count - split_len);
+		ata_pio_xfer(qc, page + 1, 0, count - split_len);
 	} else {
 		ata_pio_xfer(qc, page, offset, count);
 	}
@@ -751,7 +751,7 @@ static int __atapi_pio_bytes(struct ata_queued_cmd *qc, unsigned int bytes)
 	offset = sg->offset + qc->cursg_ofs;
 
 	/* get the current page and offset */
-	page = nth_page(page, (offset >> PAGE_SHIFT));
+	page += offset >> PAGE_SHIFT;
 	offset %= PAGE_SIZE;
 
 	/* don't overrun current sg */
-- 
2.50.1


