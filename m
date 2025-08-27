Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C66F1CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:04:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A4466B0095; Wed, 27 Aug 2025 18:04:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17C446B0096; Wed, 27 Aug 2025 18:04:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 092126B0098; Wed, 27 Aug 2025 18:04:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC0436B0095
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:04:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C26B1DE950
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:04:29 +0000 (UTC)
X-FDA: 83823917058.29.94D9279
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id D559114001F
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:04:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UnMe9JRW;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L6FCsZfzSN7fAFSGFsxI24ix2lgnSyrxfbvzUHWhoBg=;
	b=QHK9EofgZ4XraMroWr9snrWzoYUDWhvoVDZf30xMBv+xJ6pMeoRUJPsU8aVlYhlW/LgtPB
	gSChwnxDTpuJEUQWFqRMO76/qDw3T4b28qXhPBwZFEUQosrbQC/rt0+R1vOsPeaFnuqQbg
	HihRoVwxxZo3rubVy/VEJe9wg7+T5/s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UnMe9JRW;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332267; a=rsa-sha256;
	cv=none;
	b=JQjXymUkG9pFWkQVsFrpIm7TFAOuCqmSWNTrIFpHAuEReqHVUUJoNMH3KkSrRcNZnOxblK
	YtE7PdgiwNo6K8fP9S7XQsWed7/MhGVzklLXt7/wsydq7HjYmSeb85456cdBkQnSnzsmdE
	5yfz/MzEdqSglDc3K1NOULy4e60BsyI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332267;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L6FCsZfzSN7fAFSGFsxI24ix2lgnSyrxfbvzUHWhoBg=;
	b=UnMe9JRWlzOTDNrwJv3bo6U4o0cWGoRiUWj8p1Wi3xJ5HQcRaFiEUvHuH4TrteWOyGqPeG
	pdRX0AissJu9TdHkKqNu6/mLQDAJbLBRZOEju+LEQA7e34YpaaZVirdB8la8YuDMTzw/dS
	xB0zqL35lOOluBjqxKGu5yFnVoWmWqE=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-687-DyeoCm-sNhqCtBzBrbRJIA-1; Wed,
 27 Aug 2025 18:04:25 -0400
X-MC-Unique: DyeoCm-sNhqCtBzBrbRJIA-1
X-Mimecast-MFC-AGG-ID: DyeoCm-sNhqCtBzBrbRJIA_1756332260
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 15140195609F;
	Wed, 27 Aug 2025 22:04:20 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A03B330001A1;
	Wed, 27 Aug 2025 22:04:03 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	SeongJae Park <sj@kernel.org>,
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
Subject: [PATCH v1 07/36] mm/memremap: reject unreasonable folio/compound page sizes in memremap_pages()
Date: Thu, 28 Aug 2025 00:01:11 +0200
Message-ID: <20250827220141.262669-8-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Stat-Signature: 8bytr81zeqjk7js4hykwu1rz5tyhtmsc
X-Rspam-User: 
X-Rspamd-Queue-Id: D559114001F
X-Rspamd-Server: rspam01
X-HE-Tag: 1756332267-876789
X-HE-Meta: U2FsdGVkX1/NLfQb5qaqZZnE4jU0bmuItF0xOECKxjZvN+IpHm3oY2v0V6I7mHc+C51EAAsfuZemZ6LIIKeGWjGqB4d35aTKj1MQzMIRN5zIWVe/+9/f9//Evrn4Iq4Mu5LeUmnU6J4z07UscbHwWUmo+i97KFGuQyfsOX321np2MlPe3G1Uesw0PycAxGRAcwExBG7yKbq+UIg7LFn9vBVw5tyAl44xoEN7E9z8pZTnJIo06hheAW430Gp2NIUrJkUUuclv/F8GzdymIGXafJ3Kjs7gpO7VZ6GZin2COWavLAkZBT5mCJqFlEOdDz5YWECeGZBxtqdgDWdn1JDF/M8Hp43xocmC+0dQwQ77wCmIexGmbX6TK+9oYOadE7aLxXoAGcr5oAwdLxnbHPqudCNiDmC5YO4VMDkYD4WhYOuRHetXA497xU2F2c1oD2GRCEwk/zrJsnr0frap3zo7aWi6GxLgGflWi+EW4CPLIDcbOGiS9/dt0q4hqQJvPnBjnvaWeV5lo/ABcR5Lm4JQiLwJJs9w9cAvuSQZAJIDasS4VbTPzBfp8fBsaf7NN4Wa9+e97Bg2NopVfkXl56dSKXEGyK7Q32oSQ97O8bOcOLuhKk2qQRNqwPRY7fIQotf4i1RKKYkcF6HPDkvGXThDPdLYt9Ksno8uln+Dbs+aESidu8Cfhe07BGzaI0m/lkdIMvoB0Tru+GLnCn5g347orjrNskYEz/jUHR2T8E9sjKrx2D9VZyCCuEIw8ra6dvv80r2538df11Nox8AYVYUSnHDjrAyiWTu9jyP3lPMWxJRLbNSJrmMcy2ZUGTVMLWI3DflLlYf1NAdgCfq5o4ZHwI4cyVzP+Nu+O1YJ8Vtx7MFRVVihiT0Ea0SHxD8a6yP7p/64almgmLS4uQg6GArXYXQWneAzI+lxQF9RUIOs1jlVNV8dh2anJ1vNQBINtWeXR20ZjbbuzFc6LGm4d++
 gKsw2ZsJ
 oHPd5VEvlAZfHsJG6th2BLFohIqcxufxg+Wze0Rbb9dL3yuuYg79tX4C2cvWmlcS0UPqyPgVPL5HRu6E1bIZ6MkYChTcSnYLpJYoUBwLCgwA8xfU58uyAxAF9BpUPE/hHPF8AqvB+ZF+zYQW/f6Y1IuFLDybscxp+3otlF9JVsZkEUOTz20pgjGXFrXYPSImfNwq2ZHnP5AxKXp5mYBjDL88I7ho6ZOA2mNIciopabYefc5nvmyRzQzgCpD7fM7qU2A4U0qz5YiT0OozMvdlcv31z9Fhw0AjtFwvT9a2aoOTaIoLtN/N+BiL+ruOoONc8jjJ6jM2Kfwa+z74PbhjEaW++k/aH4aME7PWn/Ove+dN1uh8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's reject unreasonable folio sizes early, where we can still fail.
We'll add sanity checks to prepare_compound_head/prepare_compound_page
next.

Is there a way to configure a system such that unreasonable folio sizes
would be possible? It would already be rather questionable.

If so, we'd probably want to bail out earlier, where we can avoid a
WARN and just report a proper error message that indicates where
something went wrong such that we messed up.

Acked-by: SeongJae Park <sj@kernel.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/memremap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memremap.c b/mm/memremap.c
index b0ce0d8254bd8..a2d4bb88f64b6 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -275,6 +275,9 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid)
 
 	if (WARN_ONCE(!nr_range, "nr_range must be specified\n"))
 		return ERR_PTR(-EINVAL);
+	if (WARN_ONCE(pgmap->vmemmap_shift > MAX_FOLIO_ORDER,
+		      "requested folio size unsupported\n"))
+		return ERR_PTR(-EINVAL);
 
 	switch (pgmap->type) {
 	case MEMORY_DEVICE_PRIVATE:
-- 
2.50.1


