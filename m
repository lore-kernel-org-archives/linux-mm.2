Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D0B7CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D8CA8E0016; Wed, 27 Aug 2025 18:07:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 888288E0001; Wed, 27 Aug 2025 18:07:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7513B8E0016; Wed, 27 Aug 2025 18:07:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 619D28E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:07:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2A8E7BBDDB
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:07:44 +0000 (UTC)
X-FDA: 83823925248.05.5649593
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 576891A0009
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:07:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=exu8+pBG;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jRdNfj9ZJOGMCBURzHWfgI671U+1iCcASfBCX64ogeI=;
	b=Xov5Jeyd47xzJP3IqgvQYtV31uuLcUqoCYqqk8gP+28tBdgE+Pgv//omYSoz5idPwRTqL0
	FrP0b0TpbVirgMBEMEH8nOasA2PkCpUHfvoRapkEC70eoPIMdS//uXLbw5xZqDXlB6b5dl
	h85fHNsegfmbJDvdFgVxsrNjx8clYu4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=exu8+pBG;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332462; a=rsa-sha256;
	cv=none;
	b=UJ+qlBCp0jZ/3I5AK1YLCI94dy8unLKOtHLfvyXZnfONOEYWnYibOom5UbA8Th9MlDP3LT
	y/QpV95UQ9A0CJZK7qOygKF0e9PSyvq11PxjMO+zeTzmkIRgGU9NXSGT3g9flzfM4clyKk
	JfFgtXOkC3GmapKb2HhHD8QCLvgH34o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jRdNfj9ZJOGMCBURzHWfgI671U+1iCcASfBCX64ogeI=;
	b=exu8+pBGwmwIeb2lGv4MNF/v4WBx+K1DMFTITGBc7cQpWyPsmyiNc0NhHuY59W3cZ7VbPk
	j1BZDQ9essfep3gc92xd8F58gaV6tqBf+oKdVBLEKyslPYcUgEMyq0igDiScYOhWPZoTvW
	ATpAn+RmiCFMO4dftEWMCPtZiTWJdTE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-552-hUo1S-tsOY-l5AExsMPNLg-1; Wed,
 27 Aug 2025 18:07:39 -0400
X-MC-Unique: hUo1S-tsOY-l5AExsMPNLg-1
X-Mimecast-MFC-AGG-ID: hUo1S-tsOY-l5AExsMPNLg_1756332454
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DE2EB195608E;
	Wed, 27 Aug 2025 22:07:33 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E10A430001A1;
	Wed, 27 Aug 2025 22:07:17 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
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
Subject: [PATCH v1 19/36] io_uring/zcrx: remove nth_page() usage within folio
Date: Thu, 28 Aug 2025 00:01:23 +0200
Message-ID: <20250827220141.262669-20-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Queue-Id: 576891A0009
X-Rspam-User: 
X-Stat-Signature: ciek67c688co9kzcyodmc8g86xh6m41k
X-Rspamd-Server: rspam09
X-HE-Tag: 1756332462-597418
X-HE-Meta: U2FsdGVkX18XY1N8ihl4XJh/ZWMoXlF+scSaFMLInUQoN6jjATryGVRagG3pgWSwVGmEPBC0nFlcqXvgkvozOvs1JKgZpsRU2PHzD5jw0J7QHaI4lZmuGwEWrs5+Eiie7vv2GcYJCjdB4WfwLlFm25RCUMUqY1xmqTgyVUX5/lJ1+9XKAADdXAHHtrifsfreG5jESNGvohEKdV4QC9TYsfLbLKWHnliaYEOSKRCeA0jk/djtFkJ2L7TjEmjkv1mjHzOUIqjRlNqkmIFQB1QcMpRY2r4Zac5r1JQkHcllf7NJWyb1ueEZ5sayD3bQUXaNuupaCO7W+iLCc4BqIsj94vBqxyEt4WVaqnBBChABmpjvCvyGfRaMJakQ2g2NoJemEb3jnyi5FrCbQCbYecFJj2c27ezpz2IaVUeMjhrAvxJj0kh6Vuf72TMvMOtMfDjzLKcTMg6ihtZIo0q2YolJf5CPYMVmJrhZ3n6BIaWvOOEMWsGuq1/uUrp1/s+b60R6u9J1YVCKg4WG3Jzsk8+dDZ4D9bAuZJOoIE5q6Dfz8BZk1d5hbdAGQ0aAkvwdaVpJW7ORrUIe2sF/UTA6T2eNWbp4jv38YG5P7q6CZN+5HtgkrZk/IRiBR8s/EC9VzEYGZeDA9jqIJXcMtOBx5+RPmOYZDaSVIaFGs+kzfQEcA8wvJCQ7bkCJeAYrzES0VAo9mt5Hnh/sgfC+dikz1EFJHfl1stEeregu0vvxSy4sJXOwbVFNMCmcidAfmgCp5s65KmIpOc1rMupScaOl7lLExWicNCfUv8HidU4pHISoQGp8OI1YzZjPisGBS2ldcDNqwHjHz+ieX0SefGzKqkrHGUxu6ilzvYtBmIDaRXFpFMWXxP6NeCctA/P5mUhmynuGWntG2nlLvADiUtcfoInjyOywUt+4t7IupjIYK9vdb99JHDTZIY0+YoWyDeCpTaOHUHeE1dVSQHmB9wMuYzr
 BI8i4kV+
 ua3gMalPpCk/eBZj/FUFzXdpCoOy1RVcCDSeepf0Q+aRiU+zClOdIeCx/UaDWdaqtmOmKuu9nxxrKLudchNAT2HCbJoTlhRdx3Z00K8nB79GbptWYORh1HNeHJlMaUeeKfiQ7IdGMFeF1b2OJOWqQwjfPXCt4AsgQW+e6bVrbR2O6QgyvQOP/t6zu/0Fdn06DN3jG/vMTPuxRruuk23VK1N6kI7lEYVE4gLrmu8aeRJhCmXowfzoe4zH9LXuvFV7U4RfS0cLRZ37p4JwPtTJklEoD9Oc1tkA9ypWvqHOkYYTkBOSHkHo7Sy7XUVKuwMTLFfEXcH0f6LgOxgp4udVEsebWpb3CNUZcPTjH0CDLwZQqApkiY+Dk6zg1TmuFItKPg90GxhWn4i9hywt7X7A0WzYDQXzr+XvZ37k1iO6UGj4ReEKD5ZsRhpMTJt2vwVqi3CpqeQOZrt8pky16KK35te9N+IPl7nBOFh0l
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Within a folio/compound page, nth_page() is no longer required.
Given that we call folio_test_partial_kmap()+kmap_local_page(), the code
would already be problematic if the pages would span multiple folios.

So let's just assume that all src pages belong to a single
folio/compound page and can be iterated ordinarily. The dst page is
currently always a single page, so we're not actually iterating
anything.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 io_uring/zcrx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index e5ff49f3425e0..18c12f4b56b6c 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -975,9 +975,9 @@ static ssize_t io_copy_page(struct io_copy_cache *cc, struct page *src_page,
 
 		if (folio_test_partial_kmap(page_folio(dst_page)) ||
 		    folio_test_partial_kmap(page_folio(src_page))) {
-			dst_page = nth_page(dst_page, dst_offset / PAGE_SIZE);
+			dst_page += dst_offset / PAGE_SIZE;
 			dst_offset = offset_in_page(dst_offset);
-			src_page = nth_page(src_page, src_offset / PAGE_SIZE);
+			src_page += src_offset / PAGE_SIZE;
 			src_offset = offset_in_page(src_offset);
 			n = min(PAGE_SIZE - src_offset, PAGE_SIZE - dst_offset);
 			n = min(n, len);
-- 
2.50.1


