Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93002CA0FF7
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:09:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D474F6B008A; Wed, 27 Aug 2025 18:09:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF85B6B008C; Wed, 27 Aug 2025 18:09:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC05C6B0093; Wed, 27 Aug 2025 18:09:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A85DE6B008A
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:09:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 60C6B5BACA
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:09:10 +0000 (UTC)
X-FDA: 83823928860.23.4665B53
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 721E31C0005
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:09:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WPJny6Ly;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fRSpRx9RRStIQ38BNC0jYyDlyXN9Nb6MMvlgPC7q7iI=;
	b=qC7b5vJ+Aje9Wqq3FxxXycK3mQFKfXYXhMVJBdh0Fa8S8zfNrVUGkGGIWJCF2tyjxLRfMu
	UpBscz3sp/SN9lmx8iwhiQrRqc+f5Z1RCxy2/AeJcA7yYZlo0hVvv1qfIqghPlmoodZyxy
	lai/jKa53c2uF8pfIFeyTcAXGZ/dcwE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WPJny6Ly;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332548; a=rsa-sha256;
	cv=none;
	b=vuO5MAGQRWoxDHq1nIPuu2ek0+TUvu4Nl//fmr6hl1MwHXNgS1M5DjI4+12ChqlTOmHK3v
	g84+e7Oz3ZllP1PFyIYLaRCiV93PCU7Qf6QRlWpZKwaEaE/WFjYyzvOzM6FoW9cC4AaUr8
	yF2c3Q+HDFh3uRDaALFU13jaMEu6zzI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fRSpRx9RRStIQ38BNC0jYyDlyXN9Nb6MMvlgPC7q7iI=;
	b=WPJny6Lyy4t759C9TOIFqT74mgtlAq/+9iLHB61E7Zlfgaz6UUCwJD6Ltm1yIZLgVdSBFS
	qPeapNxqAcc0zIu+aDuC1MXTmGcEPO5f9ixiLxI0aTeGNyaw96ibZA4Zy1Mpvch+wevKLX
	ACQgUctDwyi5ycTaf85tyGaAtrdqVPw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-125-8rLG3SX1N-GJeE1zdspl2w-1; Wed,
 27 Aug 2025 18:09:03 -0400
X-MC-Unique: 8rLG3SX1N-GJeE1zdspl2w-1
X-Mimecast-MFC-AGG-ID: 8rLG3SX1N-GJeE1zdspl2w_1756332538
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F35E7195608A;
	Wed, 27 Aug 2025 22:08:57 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A36C230001A1;
	Wed, 27 Aug 2025 22:08:41 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>,
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
Subject: [PATCH v1 24/36] ata: libata-eh: drop nth_page() usage within SG entry
Date: Thu, 28 Aug 2025 00:01:28 +0200
Message-ID: <20250827220141.262669-25-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 721E31C0005
X-Stat-Signature: yabj319dx1yhhp878d491c7jo3s5xp9w
X-Rspam-User: 
X-HE-Tag: 1756332548-577354
X-HE-Meta: U2FsdGVkX1/u2z2nYDX+nh0C9KKDCwXKj7kV5XodIAhJQcJ8wiuF3U01Lst2Acxa4S8DC/PvNPcnaDXnURSgi/4h51iGAx8PVGbjmRW5Lg6tmaNTKmPajM9pFJO9AFrS6TeVeHNaV3kQgVy/wZM0VAKXNOtehu64iqPMU9HSekpKEy3xdktdatI7Qw2Ddc4i5CP/a5zZel0hqeNFruB+KsVmVqoNV8D5dVTPO1wB7q7eAVDSEYAXcCaT2nYzxVMJW+MiJ0rBc6bWxsXmZnJH2E59ZlpVNencFlIf6qZfbaGZK1JE38IrGq487jpcipd5bA3DN9dy1mLScJ+U23bwQiQfWrvNqyCHeMPtX5Dr0lsL/d5T/oV3g5XiBODOANeYAz4xrZY5z2X2TOdEL6ARoIVjKf0wu7iL7umBNA4WViUZbRjWEKyttKxoWJcWvBczmt9xZ4HYbrkvP6Xi2QzuaT4I6NfHls/xM31Gz3HxncetR0Q7XDDu43sGpBbhAZKNyJWoSzIaElFYtMUndIAUqpsgnHDkJNiPjUYyRHQNEOmdfq/rQVn0o3YlRvUMr2GdkAV4fvJL3lnsAghoDgBPzwldCChj4jhvppmmisY/O/uoDsTq1Maa8Lsh7jYerrK+yaLvo7W6Cr2A2ntB71/bwG2if0lMCHwFINSOIEGGq4aRwweuEqPQ+VqashXk1wu16BorAf/WOiiKHTkL9nemH+0rWSXJh8zjZfyoaj3myldWxWDvhugInu0bPZ38s1jebungEv7/9jt58WgB9/JDmVB8vuGVhnN9gtrwNqy6Rr/QrKv+qqZlahlIJX5eQin+iJFvFxRLRjBhT1duqegw/QtCjuBcGT5VfztQYqzFQ5obfIOfWBT8eFZlYnMHct74E19GE+vnBNhm1rOeOke+O/lpJHqgxntVSEptyqRFpS1wSpKNP25SN0BfGnEY0dfjzKiNXoTCGgWl2IAhIMA
 bzKiypK7
 e2hX4S1ZmQGgoCFcnNn6/p0lGA54HqdCIbvv1Z9xNgTN2wX4mposg+hmHqKvXgu1ZJekyDCH4fuwtG0FW8O8rrlF4inMZ68LrTbnGPKtqGstFbLja0Ofk7v5syzdvn8KmCHrZdiaFXP/Zvdy2xXFaDhVBH4zN6iiTsRE3nzDy58XQrRYvIP602QB66DRdXw31+eiaXjBJey2xeBgu0KrcyIFoVm9zdihe1lnHAzn20ZSF2OQ/PhdgAWoo66+M9ODou1F7KlMgiW5hRGLfh44ygv7gMP3WchGsiCOrKL3oqRjHSfdQmh3iHkVkxk1RFtp6es4oAsItchINTTYWSo3IYzaZPtA0d8WnlfDKNUTbGnMewyWP7JEgeEcWqkV/s0+j5ICEn419cys3/98Sb4Fl961/0HnPWrMjGknWNj4hBJtOuPQifuw1a+n37GJwGLPJBM2IFoQCpftd6NE++JxJhCCagQjavDw2IMAlAYk23uvQXoo9K08Rhc4cMEcFLoFz67jukCRNAb0tMVg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Cc: Damien Le Moal <dlemoal@kernel.org>
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


