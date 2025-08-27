Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CC61CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:10:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFC406B0005; Wed, 27 Aug 2025 18:10:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDA796B00AB; Wed, 27 Aug 2025 18:10:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE99E6B00AC; Wed, 27 Aug 2025 18:10:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF3C16B0005
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:10:35 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 649F6119541
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:10:35 +0000 (UTC)
X-FDA: 83823932430.11.7517437
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id AC16640008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:10:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YcpE9LNV;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KMi10d6QgZutAbGzL3nSBlY7ky4aRhvMewcb8M9EfzA=;
	b=MXOSG595lLvNVP7bbA7UaHxqnRUBWKPzfLfH/Av3VZy3H04i6dzW24oXkA5Po8EgcUDazv
	NRNEdFKDkxP+3GjGjHx34SzZTLjwSrmX/6PcPPkiXIM/w9Ga8uGVyzPS3vvmE56xTrloco
	aWABKCnzg3jFnFewas4/xyVGA723lp4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332633; a=rsa-sha256;
	cv=none;
	b=nUHhgjvGvmWYRcMNbUa6Ja/FWwryeWO2lAVBWschBoBU/XbaLzXJmpBtiamMZcRKYdOwhG
	MV1g3KaHrDgpOnsEKlAQ4KobMnQqq0y5SZsqChLDWz7S+db82f7g3cFPS5ctOTlJdMX9fk
	wv5KZAZyiXnVyai6kBDqrWh4ClNqIBQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YcpE9LNV;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KMi10d6QgZutAbGzL3nSBlY7ky4aRhvMewcb8M9EfzA=;
	b=YcpE9LNVWGzsK3hAM6dSvjjl7XVgCdr4GQxEpMplRiHX1B4WliaXzsW+4aLsNWk8sOvRok
	7gJtd+zzpvOgwacuIcy8LjkTxIrfPI0CHuU1m75sfJtwWFB+czoiHrI+D4+SY5sSpYSb6R
	Rqy46nUO1gbS/yudP6afalie1lGWkzs=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-126-Kk9fYkzwMM6MQxKq-D-h2g-1; Wed,
 27 Aug 2025 18:10:29 -0400
X-MC-Unique: Kk9fYkzwMM6MQxKq-D-h2g-1
X-Mimecast-MFC-AGG-ID: Kk9fYkzwMM6MQxKq-D-h2g_1756332624
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0FA831956087;
	Wed, 27 Aug 2025 22:10:24 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DC4FD30001A1;
	Wed, 27 Aug 2025 22:10:07 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
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
Subject: [PATCH v1 29/36] scsi: scsi_lib: drop nth_page() usage within SG entry
Date: Thu, 28 Aug 2025 00:01:33 +0200
Message-ID: <20250827220141.262669-30-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AC16640008
X-Stat-Signature: 6zzheo1f3rsn88mhs37woy6higt9y6g9
X-HE-Tag: 1756332633-238549
X-HE-Meta: U2FsdGVkX1/mbnmodJpps1lLc2EivUSnItTkS1qYRHoEi1y9keKq1ViEyy32kB6DQ0bPtBp+Yy2h6EAWPqV/YMWOvhWhdw2g/h0ITS68JeGWI2rICr+STz8apbKIECD7IuN3zSBm7Y1f/DF+w4RsGq3zmfdJN4v21i6587LDkXjXt7wdLtjQSyRPTWBO/4NeR27DPAhhhxxWVc44RozzERI1a0QG00cg6clcWpASECJ6AeKEpcnfhQFa9IoKAEV6f+/FC9Qtx95Pq0mblz/OxDpct1VJ1ERuX4Mg5TOYjjBDkdHngFERZccnOo4exaMa7iTX7uuHJJDU08RQZAqdgV0SshTn5gTGtmk/QhSVGChV4tqXbhrZ/McXONMKlqYukRJH+ceDsyk3c2S3YQAXobsySaU+MVELB5aOWH202CHwFBSHm2TVh+wdeiIM+ORuCW+mADQiy9DetZLgTi3CF/umDkyiMXrUX6Z5FpsC9jEMj/p4BuDOAK1HvOEP1vx7GBHy6x0yLKwt20W9+EsAjhO9n0Yt1Vm2CGO27t64OJu0D2Fcvs2gUKc9+h7aoPFPRzA539FVnfxmFZLhUfIdy0n7mGjjLBGiENCn+CQYRa8tvE18YtrksqsYh8faJfob9/jEG2KvU3GDtZ24fMklOf4QXKZftaCUNvyWp0UOJR+U6ecgFxKndDKgHxzoHfTWcuD2jAVc8wdHf+aLmHLsHW/UfdjriBGOQfR+EGenErgWIJYaVom96Ns2p8h0HNA2uLH/ATupHj3S7jOeTFHeBCA1QIx1c8aXkoOkJlA9tkr0DKrP00DHLAJqqV252Fi5+2ptnHv4MhoFF7338F/jDj/zvp7RfmxIYOkkquDkadIcnwiR4bkOS6VMRnChJ4w+NJpLo4blSLqEjbge8lRB1R2R2YSdq74GOOP1J8ngXwg3N/0vMO00spvQSBvtrOpQCz+O/ntspbinHMiV1Fs
 91RYWUS0
 3puexsIzAc1F2ja0XVs6UetegjYumUPikHYs51BvoeHLerfk3D7MdcvpwgPRsw+DmO/oECCeoDgiQamYnqKl4KWhbhuoQDyTDaA+p1UMcPs7ePSn/wsvHp8HiEBLO9PjwDSvi6sEKSW531Mrkrc00arSVLnjzv04DTGS00E38JsUVyauSRxwCOPWkk/ecFQT2bU+w7/YCMo+ZjlScIXWXKzdKKzso7FS5fgUv2xeubVpo3LLpjWahepGMUdlTxzll3rKJPVd5S5AxbhJbf+S7cwdMia9q8E8e+EhK0xES8Qgt7Jd0K+DzqpgVc2V4GfNy8XGwbOgnIOuxcLI95tYt58msZdkjTBqlKQmHU3OdSiNR9j//h7EDPrt/WLtTW8COODYwTw8ZQ654FEi4Me646fqvTGNoB5kzDLZwsyDaF83GBTyBwDM0J55N3eW90ZXElmnV3EPZmjS0a/toa+bmeiED1HEfQUN1Gmc4NSXy8Shs3k0=
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
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/scsi/scsi_lib.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0c65ecfedfbd6..d7e42293b8645 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3148,8 +3148,7 @@ void *scsi_kmap_atomic_sg(struct scatterlist *sgl, int sg_count,
 	/* Offset starting from the beginning of first page in this sg-entry */
 	*offset = *offset - len_complete + sg->offset;
 
-	/* Assumption: contiguous pages can be accessed as "page + i" */
-	page = nth_page(sg_page(sg), (*offset >> PAGE_SHIFT));
+	page = sg_page(sg) + (*offset >> PAGE_SHIFT);
 	*offset &= ~PAGE_MASK;
 
 	/* Bytes in this sg-entry from *offset to the end of the page */
-- 
2.50.1


