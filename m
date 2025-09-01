Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AF20CA1007
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:06:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BFAD8E0073; Mon,  1 Sep 2025 11:05:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 397E98E001F; Mon,  1 Sep 2025 11:05:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 287C18E0073; Mon,  1 Sep 2025 11:05:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 135C88E001F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:05:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8A07B1608F8
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:05:41 +0000 (UTC)
X-FDA: 83841005682.23.DFDBD37
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id CAB8B12000A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:05:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G1Oz4IV2;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vbF+Eclm8a76znTMytGJjLFZFrrqxTZ8tlcAavdISGA=;
	b=zhoUyOH4yfsWgYRWxmCJKIzjq8T/hyCA9tCWwCCNwU5PgEjiwn8rVMDeAC3Fs4FBvFdvKU
	QuTFjOZwwDkNv+mHAMarbID5T8DJ94Shuh5lQQ0XetRfiMjb/6Sb+p9xdWYE5BOgDk+Z8F
	cKC5JZb/RO6xA969L5Khc8i03/aT+Ng=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G1Oz4IV2;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739139; a=rsa-sha256;
	cv=none;
	b=uhCKC9byD0lhoqvTTXXPBmI9DXyaNFxn4N7X2w32VJCZSibfJs8osldrpumrxQYKv33F18
	6sc/M2dVn9g7pr+aPNysVHsFikbLZHXLgi+rcoay/OOe0yMKID3YJMHVFO/V6zJpfBEG6P
	cn2PRqWhLvIDpHhx2WIR5O9XUTOw3uI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vbF+Eclm8a76znTMytGJjLFZFrrqxTZ8tlcAavdISGA=;
	b=G1Oz4IV2g//uYOyUlJtCP/LWgWABRm734ollU88AoLxFqMekGHcUeypghipKeuuxl5HRgs
	Z+5Cck8Cm/oudFDmaEqDenmydBE+gfY1m3rzHtx4euTb2MXIFZjRdJCSdmt+ehU/8v+4LR
	m7eWGplSQzT+YmWTGG4dAc1V1r9li3k=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-444-EqzKMDgCOYua6LxcHPSp-g-1; Mon,
 01 Sep 2025 11:05:34 -0400
X-MC-Unique: EqzKMDgCOYua6LxcHPSp-g-1
X-Mimecast-MFC-AGG-ID: EqzKMDgCOYua6LxcHPSp-g_1756739129
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3EC86180035C;
	Mon,  1 Sep 2025 15:05:28 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3D05F18003FC;
	Mon,  1 Sep 2025 15:05:11 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
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
Subject: [PATCH v2 03/37] s390/Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
Date: Mon,  1 Sep 2025 17:03:24 +0200
Message-ID: <20250901150359.867252-4-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CAB8B12000A
X-Stat-Signature: c3k3hk6nmt7echmcbx31wo9aya5zju1x
X-Rspam-User: 
X-HE-Tag: 1756739139-875740
X-HE-Meta: U2FsdGVkX18PbAZKzrhDpvSZsg/7z+gAUfrzA1alDFVCs8fGWzJJjEXrBzKOtEScmR5PUEbEs0s6elB1pSPp0Vo7PIUTkXnXGo2CeyXCuEXH7Ca7jLUf9+D93KvIqt+ur0/4GQoZntDk+4gFvaUbxe8OnzUgfta1v1qna/Xoz4IpqqVUFWy3Wv8YaKFsdq/S7j5JLw8QdK+/TsvP8v6v2I2FLKjuZ1dQ+zJgj2tXiV+b8rT43c6XVw5/ftdcrVJLtpZcLOhWD6GarDmlYzXAdjsZ+rW28PfxweymJK8EzxaOyoa72y9h3BH600e0LsKixmiNA+/rKbzCeyhk9ZYACpm6tibOCnnk4xplRgVvYu77OZIEgqkum37YQS1DyqWPGtWB04ukmntoCvxvH4Ia3hlRqLhW6r3tXuQJ1avm23aQGUIF49j7dVs/+GwE/aZDBqnCzeU0hUI5Lx35p+YRc12jwYplGS2/E3SyEkkKZtWhKtQ04QGEO1Z1oBNA13l63VXAofFTmWwIljkK+lOqErvA4G/fpvc33uzSGZdgZEDbcMtgXUBsdLw3Rmpi03s5Us6QB0zxA48FV1JNS4vy3by4lABAvJM4KJHkxDSr+NB0JZWdDrNNBB785qF3Os5iB7OaNc4+iy35Ijy3GC2FiEg/lIkjzABu5tU1tSX740kjFKgBDsIJ+bd3x/jp4UZ2SJFnPrU87ebEGqv1s6Od59sZtTD2ShvZLA0wknJcdcCCcJIx7d/klUd4VElInTyEj/QMsD6ZwDJPMmGHatjKIHSvp0Ar4F55Ob8yBiydJjTn3FmSGsNlK884xcIIRxxr6iUE3Hj2+9yLcYb1zZX1/yxWoFb5RbBMEUH4gtVG5f5FHatMUNEx9DN/X3htaePOhC5FdV0l2S9YuRrmaYPOzoiCB/xMu0gEFQPpo5vCEYPdpHV1W3oa0n8yXQykhFe2DXMF6hpt/+C1lZOvfNW
 7fNxh2pq
 2NMJvXULgLJYGj6tTtdXj3QBF/bRDC99Gs+Yv7Dcz5ieSTQjYw0rbppkKlRG1g/c7zJzp2D6gi4yEBxoblinTHqZi9Yd+Ta1p8yi/awdQIGWcRE9HFXY6KTn/vJxutxok0pErHCwqmVsRDlMW2a/Cj46ay50SRvry+OUifap4c6Ao78PfPaqiBa4l6NUBQ0toVkbwj+IxFCa5NBw6mxW6FUUcN18PLp1UiqrFgz9FKagwOPh7sBZnqTyojm/6D3f/GFJ2i3ImvxAvscR4O68PUm4SZvNqJClWdz8iC6ro0DuxB8KG9goUVjza62mxlTol/0HpG7LGsi6G4qOvA9+FghkBYSlpZc7f1cgDgsYp3QCWFij+Hsst9I/1fYO+lgwl2BQ5KMGNHHNx+G5b0Gg6XDq9mvfeYSK80W4lBZaDHmVsaJEekiRySF12EPH2duroqCpo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now handled by the core automatically once SPARSEMEM_VMEMMAP_ENABLE
is selected.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index bf680c26a33cf..145ca23c2fff6 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -710,7 +710,6 @@ menu "Memory setup"
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	select SPARSEMEM_VMEMMAP_ENABLE
-	select SPARSEMEM_VMEMMAP
 
 config ARCH_SPARSEMEM_DEFAULT
 	def_bool y
-- 
2.50.1


