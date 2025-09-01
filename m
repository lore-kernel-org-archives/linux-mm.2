Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 458A6CA1007
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:07:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 411FB8E0078; Mon,  1 Sep 2025 11:06:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E8D98E0076; Mon,  1 Sep 2025 11:06:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FE818E0078; Mon,  1 Sep 2025 11:06:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 181C08E0076
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:06:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC13813B2AC
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:06:44 +0000 (UTC)
X-FDA: 83841008328.10.5B883EA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 139CA2000E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:06:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DuuVaSIA;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dzO5XeQXA+92El5MTIOjMpy0CzhO3womFwma0oFqoHc=;
	b=DgRuatcZzbPsnvCqMh0J09Yn1qsxGO7O/IqWnPKYWuH0SVSM6+ZiV0cazYgPXOi2cDBYoJ
	ts2I/mlyGYbHyfyHv8XJtiF9qJOVLpc4S76w8oYpWuwKfkdJ4/tnEPUAYE7B5lsOyp+EPg
	kJpIIKXr9LByyOFEpKTK6zz2rtazyek=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DuuVaSIA;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739203; a=rsa-sha256;
	cv=none;
	b=fJZ1oB3svB/m7Kn8OPS/y0aNB39F/uxzrIAnO3w950FKgwC+HFNN36N6UAV1eNPWrsmYBg
	2oYijn4GFthmB9LbP0ABHvM0qCL/gMRnotZyVC5a5uKMWpgZ5Op26lSxDdxP6EX5ClCq+D
	A1aeDsNFtjNDajVYwmlrGN2qi9OthSk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dzO5XeQXA+92El5MTIOjMpy0CzhO3womFwma0oFqoHc=;
	b=DuuVaSIAhtfOJqapRCOS7jGjUBaEQVX2O5gVac8lExCHar23wMQ00yPtyQm31+htGV06ao
	ia0f0bNX73Oou7PnLNstU/LW2+IyX+ek3769FH5+qr6XZcYBlcfeaXdoiiA9Tn/DEoeTlP
	rN3KiKzcRdnXTsan58vz5W/n0pi1N1A=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-473-jaRusggRNe6QfB0GmQhKbw-1; Mon,
 01 Sep 2025 11:06:38 -0400
X-MC-Unique: jaRusggRNe6QfB0GmQhKbw-1
X-Mimecast-MFC-AGG-ID: jaRusggRNe6QfB0GmQhKbw_1756739193
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E34BB19560AA;
	Mon,  1 Sep 2025 15:06:32 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A8FF618003FC;
	Mon,  1 Sep 2025 15:06:17 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	SeongJae Park <sj@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: [PATCH v2 07/37] mm/memremap: reject unreasonable folio/compound page sizes in memremap_pages()
Date: Mon,  1 Sep 2025 17:03:28 +0200
Message-ID: <20250901150359.867252-8-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Queue-Id: 139CA2000E
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 9kuiqbrobupq5edph1z3z3z1djhbmsdj
X-HE-Tag: 1756739202-828710
X-HE-Meta: U2FsdGVkX18zNhG7Z4ZeavfbLm5HcLmi5ctBKcVpOO0Nf3mL+LPptulaQxtPcRH7ZwsaqgtP8z0JiT7tckwMGlN4m5Kxcm81l0MlbNNSEmPcOLDVgroTcPdpcd4HXKFQYHcwU7wffozfSlbtQ9+p4MJs5xCJvTBLP+IDEGsuMiAp5D5WKUaXjJ/Uaw6hoQZb5As15ki4g3rnWoiJcgdndhUq0GUd92KEO31Zq+mtfCKlTfTPYbEfI+G7KXYG9ef5HvX4VTrdsK4hDjtlaPuVqE3E92d8IcKqyqNs0eTOw5UdZkzVLz5uZv4Z1kInQouNzX/QjtNaXrNzEpgp9MZafgw9pmFuDQT56uXdk+0P43QecLgqwMw7st5Yc6czKfhTu3sjzXLflAENG78wBItjkLGnE04/NBcw5OKhp/IHcwXU7Clvcpp0yxurwhJTX/w7KdhxNTJO+V/SyzUEhLWJ+y0ooQjM7gJ/q5vp6w6VsfmxCd5kiyW3UyHKhHOeQrG90JP/Z5gWrT6om5iQUtj4fRtmAKyDM1n4Lm84UabLi8qCJCe0DtGJThDPZ6Dl286VVv7ERhLf/Ih5XecXEEOySFJXz5NLUg79DDTYbbkg93TBNWfwnJBH0H+Q2blw1eTglGehXNzRhKcXIv9CrnRiUwokgpgmDji6HBNd5vlSpB+yEfXXaoJiipGMFA7clFKg9TxvKO5YqgOemrRgqeyos5QfSoXxx4eXmGyI3g+klL4XAQ/vI2Df/np5+Rg+gtpM7icWY0PbWBmCGSeqy8dJCR2K5CLqZZqnS78giZZv1fNV+FqAsBfMp7Ga4NpgQ6t9QR/2FXC+ofXbGKbvuL9Ex+T/aBREoyvUGAxn4kgay1wBl7NMKs7gjxCp9mGx3jB+yFrpaBFoLhsC71fyZui2TBHD4NIdDIBXSX7zZ2xiKBuKWD8wZ6y8NFbmWfR1Jv2O7ocTnewIl41+VGPy1n0
 le3EuzNg
 C0FaCfUQp70eECs/Pt2PBrdP2cI44kut8L5ELXvzznFuULygrELWkKXOY1TghQWDo0zMr+amN0i4/w+sPW+Q7WhKeUDlFWIF9Xjjf8/+JTwsVQ7BrI7vm4U/1tT1MrfkdDKbuy2Q1XweTR8i0txtvvRdSmUoVpFps8dFh6OViOGTuoIhk7ppAP2QVx/8OVPY/GB6sseY0f9zgrlMhJf5K7MkLZchZE3TA1qI72OgVSYIDdThsnXtgI9qvEvT+icVj+AEf+z3Z233kp4Uaio54uaLDhOhyPJk+NjD9tm7oNrgP5B/JMl5nLh5xvNcMGEbhWtLdwaX+45rGFYfv20U4QaOsAURdHBcUzqgn5MDWgEblq5HaZwPFxQAFNyCt7z1TSl7MWidfENDBicMfB9ok54LhFJDvtO3fe99gHHvH59SxXss=
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
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
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


