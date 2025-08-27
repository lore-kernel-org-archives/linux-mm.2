Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F8A2CA0FF7
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:11:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E35C8E0019; Wed, 27 Aug 2025 18:11:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BA7D8E0001; Wed, 27 Aug 2025 18:11:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D1128E0019; Wed, 27 Aug 2025 18:11:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4BF138E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:11:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13D3CC0894
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:11:09 +0000 (UTC)
X-FDA: 83823933858.04.82CC62F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 60A811C000B
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:11:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MrlsuVIS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uIthYg0x+2djveHghlw2Jb9wmVGYKVQz7R4ULrPQfiU=;
	b=nq1VeTXBtfK8ZU7xhJZTOuOlp6X2SkI7VRqzwxKKUNu/2TVs+RLIAKkgm+4gFApAq5pgAm
	SinyuaJBZ9Dvk02Rgsad9Hhb7ZSSQofVJ36vUp/QnBKg6vjymBqqfvHaV6vNxKWGmMv+Zk
	A+KJeMc4oswKhTMbK+DTMQUNnf1iP6E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MrlsuVIS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332667; a=rsa-sha256;
	cv=none;
	b=YV54aSPUbJVyLpKCDPTxcdGBqfZgXkMNcqHpqC5CB+oPVqjNtutVWgWyNOxypPkw72IF3X
	68u8CuLM4O3BpRwqKuhYAerICCJbU8Izb83DtWZwg9M6dYTUbCASHSKkL3q6mhNedjSmNu
	9SK8fH52gLfYK7W1W6gYQEQvl2Nm6po=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uIthYg0x+2djveHghlw2Jb9wmVGYKVQz7R4ULrPQfiU=;
	b=MrlsuVISi2aPutnaNaV4eFNC0qPNYCB/E66YlHQ4uAMTLskobUZC48EcW4ZTkbnPl21Qrd
	myVugYhqOSz0Q/NSTmT9lhfKp/ICAT9bPy2rwGZXHmgMEUm3d1aDJA/8Zz1ZolynDSoP2V
	eO83bQyvjMAnR5zx0vbxRwqPbymf1Mg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-116-ssFK63pfMnq5S88UlMY_DQ-1; Wed,
 27 Aug 2025 18:11:04 -0400
X-MC-Unique: ssFK63pfMnq5S88UlMY_DQ-1
X-Mimecast-MFC-AGG-ID: ssFK63pfMnq5S88UlMY_DQ_1756332659
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C780E180035B;
	Wed, 27 Aug 2025 22:10:58 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 10AB430001A1;
	Wed, 27 Aug 2025 22:10:40 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
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
Subject: [PATCH v1 31/36] vfio/pci: drop nth_page() usage within SG entry
Date: Thu, 28 Aug 2025 00:01:35 +0200
Message-ID: <20250827220141.262669-32-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 60A811C000B
X-Stat-Signature: rihamc7mwgp5qscmsqwpznei14ohgphr
X-Rspam-User: 
X-HE-Tag: 1756332667-710682
X-HE-Meta: U2FsdGVkX1+yNWp0C7uomnW3znGNiE/3O8mbDvyfxtHGOm9S8p60U7CuGxIEfgy0JDIVUCc33M2U1UyMK3KBKTDHiB9YPCWXI5SsEiBQmSna5rZ5Nvc792w+657ILjn0q0EfZqFQDxYUJ9WLjF5T2YpYQSHXZdGBlB3GX2WK16EoTxdJ7M/dqDXpgiVwkWHPr/ket1ldlO12SP1Hd31FAbP6xIpH5PCIi7x3z/uQj/R3CHg6XnZNp9U6bcUwVhd5NgT4kJO5eqSfZsvTlRqO4vxxgF6tSoBhHun4bhdjSawEoN5A3WH7qKnwS0PEMCtPW1Xx4+su5daqhyiWY8x6DWKBvse2pX9LGp+RKpDXTJYGbxz8J/7NjX/ygZIxZS/xcVGX2UpDIdq9UIKWG/1v7rTo1Lm/HcA00ZEglMVL9hg6WQ38BQNX/7opRZ+Ay8goPmeyL5+iXAxMz2Ji4qiOwPBKxgchTR88qxpeFINpS6NSoXFHbdJ1ymN6GcRj2+ry+uFNg0sDFxOGOAGW40pUBmBW8hgt7B7mirICgvJ1XklKrxQzyxhKxgf5TLVKlALRfNgeSiUgdc6830Axgdkaf+lsFwShGiVwMZzjr/Y3PSjqxRWxMJ4Rvn4cc+m04+uNlrUqCOqOrvte1MdQrVeKaP7otPP+wKg8Cd2zUn5P0BrKRm5luij9MtdhJxRpfNLSkVXwdt33oUGbDqWVv0+1qnjaU7XeZHNTqWzyN9chfJ54yxFSCQ+GoBJKVMm4Ua+m1rJ3m4oqF3Kiv5/LNB79Xx8i+5nxsb512ZBqpBY3PuMyJzVgBuz8mEwJoED+1BuiU4ZcLcsG8H3wfk+lapn75AyL+DKawaV5/Ja8H3CwE3sKu20aaFkiRNHR+KAxbYyQHpKYE6sNt5eAKSBdf2WrK0lAqNJFNPnYpZ7XhqKubrVYUdtze0ACLhjl0xicbE82cFG7Se3oniijdXgc+BH
 JuMdEyca
 UZmboiFzZxmpxnMbeJweoP0ceQ1TVLQOum/q2pzxFDvf/8JJS2kcIzVBTv6qlDoqtdrVstYlLeQqw5gffIWjnukVLkV3JIvO7OtPwlbqYkVtT1O6lhkAwP9hAuZWW18pE6DqT+X9P1UGv+4dnxqjZnZc2LnDXX9ldvVhZYIEvgqjySCFVFRbpM+ILEkv2nLaDwQCX0ORRmip3gaSkXqjQ0R77jQRyKIRNUPXGUvlmdr35s6Zd6DNGB1ok3MvuIQqXTyT/+qNR7GC+oO3bQH8HEEJxIUVENYtem6f5aad57OEHfMpRn8lWLnrrtNs2u4pxewX5YFS4EkrJ1ve9hZNePSpVJ11Gh/Vp3oIKDZG8ujPDrbK2acL1MFCzPGhiIVBxvOPPQOUzSykEzgDtRQuLwiMH9NKYRVWOhR0GkpR4qs/0KllAiamLf7iih3Dek+XNuUEK+Hjgx5y9Y+M2eniQgpVZbb1pmlYVA8Lxk0LWCU7GlugOrbIDv7KLglLl1qNugFQ+01SwqVmqe/9IgAJIIt1QcTj5FFu6kmN76mHfaXcWFY2RF9G2dUMMcK/qNxRvYjDHukG7Ku49Nhtghp7CwFbfPOmNARFKo8Z0cNWgj8q9dfN/PVqIKbFLN/bslRPoiM5aLoW1LxrC7HU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Cc: Brett Creeley <brett.creeley@amd.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Yishai Hadas <yishaih@nvidia.com>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
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


