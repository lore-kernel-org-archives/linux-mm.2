Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E5F3CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:33:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 705998E008F; Mon,  1 Sep 2025 11:13:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B63C8E0084; Mon,  1 Sep 2025 11:13:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57DF28E008F; Mon,  1 Sep 2025 11:13:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3D5BA8E0084
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:13:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 08F4E14076C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:13:12 +0000 (UTC)
X-FDA: 83841024624.22.E1EE073
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 416D21A000C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:13:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ijYPpBCo;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K7jUgCzLPy6D8wIKPj616StOUbYwsKVjaRrDFqVFeZE=;
	b=MpEM9el+YowqmZ6GsymjT6bFUuRRn4KCOiGJVXHOLcEpnuo0zetHKe+OVEs6LxRah4XE+x
	MRIueOC5Xc8FvvDEdNj8qnke/dZiFfS9e6YXrcHZaIAklqpDLg2Z25zYSpO7rvGmSf0TtN
	jMr+pjCye40VcRk7wVGPl56pAiQy4JE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739590; a=rsa-sha256;
	cv=none;
	b=KmxIX7H0XmU8WTKuVcxnz6BwfenROofH7Z1y/0XtI/Zh3jPl814DW8rvJmTAzyCmwjQW1Z
	gD1YpQFDDGIhb2LQpWbvvmLjKfjXzBsOEuHDcNrBAstsmXwKzBz8N/CQX1XJ6TppegI3si
	Bex5ojYRKA4rEqk7TYzPf/AEu04OO+0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ijYPpBCo;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K7jUgCzLPy6D8wIKPj616StOUbYwsKVjaRrDFqVFeZE=;
	b=ijYPpBCo5NZOBwLgN33mDTABvz3kdQ2e5IHuoBYPr2NLXrjaSvlDjcJDNRPGfthmYouSqm
	QlrPeFYYeS8tkwtGhtkpv8ROcG9Y+ydmNkVMMEdhLSxNDSsToEs7BtBiS6Ls9Jk/pBxOhs
	2BnH5yi9Pou0d3nN+3WNhDsenXtxsUU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-436-_lGL3iH5PteCAFK281ZRWQ-1; Mon,
 01 Sep 2025 11:13:05 -0400
X-MC-Unique: _lGL3iH5PteCAFK281ZRWQ-1
X-Mimecast-MFC-AGG-ID: _lGL3iH5PteCAFK281ZRWQ_1756739580
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 995741800359;
	Mon,  1 Sep 2025 15:12:59 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3D39D180044F;
	Mon,  1 Sep 2025 15:12:42 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
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
Subject: [PATCH v2 32/37] vfio/pci: drop nth_page() usage within SG entry
Date: Mon,  1 Sep 2025 17:03:53 +0200
Message-ID: <20250901150359.867252-33-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 416D21A000C
X-Stat-Signature: hgfmhof5daert3r3gntuxogxhfbjuwzj
X-Rspam-User: 
X-HE-Tag: 1756739590-335224
X-HE-Meta: U2FsdGVkX18rV+XlBRkdmgoL2LYWQpyRvBUK+q+LM6pArZoe7icielFqttXYfwdsfaW+MdJeuIlFR0AUwYOVv1ZTMAk14gNl/GtwZIMgn90tPk6jKLh0ZqQjHNnh6d3BWZ2nLBkk5AdYAw/yHw46B0mac2toEBAf/Y/BFYHTXdTtZoV7/km/fWiWOb5tfNnrH/TL4o1bvYbulRtYKFb4i/B7WPzy09KvYwC6Yg4OxymDCclO192Kxy5am/TA9AD0tbY+T8bdonnfbJ7YtmYMk20uZcLn4Uwco1zhujocBBuKFCPGPW/IMgluIJOm9HdF/++ZYww8wAb30dslSs1n/jLodupVqCQS8iwYLrRoVpBRe7SxGlyKwrQaVgs8Oq8lW0Ijwg3Cj3kLfUxaRgfSUAR3ozEGI75vYFkLgF30TRpAbsdxedXawCJi4l8OBBJTxFac5MaUUCk+w3cgg06a6Ls9HNyz2Va9C/rDEclu9W/Z+3iDbWU6/7Rzuk1wrNTzoFe3Ln+jzHBIUXxitWaKJAeUjneznaVXnrSzcA7UJ+Cyq3maKfDoZ1Ukrkn4d6gSe3hvhMpUlORpHtv+Kioul3jG9FDEeQV+KTfpfCFhitqZHCUhAfMbMg5E0VBqNLM0Ist67OvyFaaWutVt0C7+14HixDkDdDsyk3rYnQLNuI9Yx800rrJhr8kncvvpnwlVt8YxHoGrpSVdziUlRdxJjKhhAicWPcXXSJwOIi1VMMK4rV/bxHk/l8AVg/jhYnq930CCKMs9qQPbFJ5CKQaB1LCxB7QnzUGODRnWWA3LI/k8AbXGMaLJdio7bNCC05hTpqPlpdmTug6fIW/ejfCrin+Y1wffa9hrMYI3HWuiD2+GlDFoMk2KAQ1f5bM6tPDFHoM0VHX2xAjWpb38CYvGh9EslJI9g83gpzk+7+1gAtC/JSxEqD9UwI4loZMiyqVHVj6A/Rnpz7Kv/Z0dfoh
 rYmn+fw7
 EkeD0xqYHuJpvM48h+nqPaINjoDYrZgr2QOK02DbOGeJJY7w+gng2HpA+Jj4O4dGuP/FvUbbtYkMd82h3bcm2eU6cY6lWNbtY5t4La0hiZoaXZicKxBMo9BUq1PrAF0qP36egOPD7Wy0jCkE3T7JF1KSiUz1BI58kDOpp0i0rzZlS7v1Ld3ir5JHQ4MXqmXth73yTWfCsxaLt5bqy9ZzKWJNHbqw+7+S0pszvm3/wwic+dapkje9oItfI+9p+IaVEDzEI0YZGB9ltHAua+HDMc6CU3cO/XjeR6LI0xjpcrKUcBSV/kkXIhKOMmBtRxUzwT9Elek5UNg5TvCt5py3Kkq+VIqF8A3WwJAkXPV2z8BIMfKi8Y6YaY6nfOPYzEqLI7ovoZpXw1Ajnycw6TE62LZGpGccuHMujxT7HFeHj4jESKximymgF+Q77FtMLOrQdIHsHJiZOuZWnIRQ7TPUNLWr44X2H5mel574iiDx+7fSyHtA3LxFv7KPpD51sgpwGGyiD9UuBsgQOCl46//ohIGomLt3slM7q6v4uPAWPLpclpcI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Yishai Hadas <yishaih@nvidia.com>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/vfio/pci/pds/lm.c         | 3 +--
 drivers/vfio/pci/virtio/migrate.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/pds/lm.c b/drivers/vfio/pci/pds/lm.c
index f2673d395236a..4d70c833fa32e 100644
--- a/drivers/vfio/pci/pds/lm.c
+++ b/drivers/vfio/pci/pds/lm.c
@@ -151,8 +151,7 @@ static struct page *pds_vfio_get_file_page(struct pds_vfio_lm_file *lm_file,
 			lm_file->last_offset_sg = sg;
 			lm_file->sg_last_entry += i;
 			lm_file->last_offset = cur_offset;
-			return nth_page(sg_page(sg),
-					(offset - cur_offset) / PAGE_SIZE);
+			return sg_page(sg) + (offset - cur_offset) / PAGE_SIZE;
 		}
 		cur_offset += sg->length;
 	}
diff --git a/drivers/vfio/pci/virtio/migrate.c b/drivers/vfio/pci/virtio/migrate.c
index ba92bb4e9af94..7dd0ac866461d 100644
--- a/drivers/vfio/pci/virtio/migrate.c
+++ b/drivers/vfio/pci/virtio/migrate.c
@@ -53,8 +53,7 @@ virtiovf_get_migration_page(struct virtiovf_data_buffer *buf,
 			buf->last_offset_sg = sg;
 			buf->sg_last_entry += i;
 			buf->last_offset = cur_offset;
-			return nth_page(sg_page(sg),
-					(offset - cur_offset) / PAGE_SIZE);
+			return sg_page(sg) + (offset - cur_offset) / PAGE_SIZE;
 		}
 		cur_offset += sg->length;
 	}
-- 
2.50.1


