Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43506CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:07:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 491918E0015; Wed, 27 Aug 2025 18:07:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4417D8E0001; Wed, 27 Aug 2025 18:07:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 309B38E0015; Wed, 27 Aug 2025 18:07:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1FC5D8E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:07:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 077881608B9
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:07:28 +0000 (UTC)
X-FDA: 83823924618.05.D19859F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4003D2000C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:07:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="hLb/zMjv";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332447; a=rsa-sha256;
	cv=none;
	b=Y5i2P/AmJrur27LVisNScJz6HePXaoTAdqHuzwrQntAyDxCNK9d41Gin31NLfTFKGIZvcr
	O+xHEBUMnBz/eG7LCHytfA3msF0/xk4vpcADEhS2rmXE6X4JnR4XP5uwXOX3c7IIgjSv3D
	liAwbJrkaPjLDOMRmsaaCuc9sR4LwcU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="hLb/zMjv";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mae/7n3uM/9R//Wdj7TtDbDkO9ysL6apaiu1QaIksGk=;
	b=AMWAjPkkzTln4qylLWXf/faNn6IIboifV11zoXfBXiyg3d0htail5I7hVHgLW4WeLuoa3y
	mnUoRurJ7Egrjq5DjX3+0F0VGyJq/gF1wH43F1fyygwzN5TM+9yQIItBAWIAqspW6a+6i3
	DukncjgQcS2U7ub0eGVdm6p/yGa6Wt4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mae/7n3uM/9R//Wdj7TtDbDkO9ysL6apaiu1QaIksGk=;
	b=hLb/zMjv0MJzSTt0PSwQ6XA8kXQy7cScOomgSifATpwLak/92qZUYC3cw1uQkiMEMlahnj
	IiHmtJQaTKDb3eWXDB9HhdF9aIbYntzN232VWthrD2ajzBcd10vHNajqbUrWUnol3WSVEV
	U+1G1WTgQhv8yf6h4bmqLJ275t+KQ18=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-484-meNFbt-4OO6MS1lMNpb3mg-1; Wed,
 27 Aug 2025 18:07:22 -0400
X-MC-Unique: meNFbt-4OO6MS1lMNpb3mg-1
X-Mimecast-MFC-AGG-ID: meNFbt-4OO6MS1lMNpb3mg_1756332437
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4DB08180036F;
	Wed, 27 Aug 2025 22:07:17 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 530E930001A1;
	Wed, 27 Aug 2025 22:07:01 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
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
Subject: [PATCH v1 18/36] mm/gup: drop nth_page() usage within folio when recording subpages
Date: Thu, 28 Aug 2025 00:01:22 +0200
Message-ID: <20250827220141.262669-19-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Queue-Id: 4003D2000C
X-Stat-Signature: hh87g1wmxx5czgrmypnq891d1txys5qi
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756332447-911048
X-HE-Meta: U2FsdGVkX1+sH0ytu1jSdkdP/NPyBfb0W321vhOJOUNc8/2wjhpkAt0ChpAAbcMhVazFEzgSJxSReiEKgS9znXVlnulCDH/kDGQQ7+99nXYUEhA7Al9Qzv2+4h52VpLLpJXF1empW1GWNalDoN7s3i5nMQLsZMtAX0UzVu7OBajh4aUKJLW/BtXfCSyzUeKG4u6SApLtZnxDlvq06gWu2Yq1jSpMtAJh9dDYbx06j3QlcnLKgc6O3n7ltiX1WTAc3sM2TxoL6G/CZbdWjz62Mtudc3dd9X/AMqomSL9r5lUs9x7sRsDiK5vcJwTt1zlH7Y9Q2MFG/NUE1622UIzH1xomM4V6v0JOHAkDS1uICZQJoDlR+yrYp4lcofdP9UAAbHCW/zMYXro03dkn3hzsw1i4bnRQapHwgSEi3tU2QY6ncyBfhfFUkUxtxQBix1hNYLZdGe7IDmHGiYpGkSFPi/sQh06PKpNucD9x9twqTU8Y79oZmXC4d8CB4+eBQ02ila9XiXwzb7fhzrOXFl4TX7e/h5Txa6+RmoTrvKYCMBXOtngOGBswcQcp5fSuEVAQg6RnozniHqexn1khnnb6sCfC/VlBUFuyEbo66gI5KlWHo9+9hy1nur9/MnDtBmLJzIM3PjpJ7WmzCBvyGFAPSEXoS7DYzDWTvLfU/b/M4OctNdLCNEOt1ZA1qrlDlVCNKyMxINJyXJleKs8peN2X3gFhcD6GVQVKpjqZM+Skjvpa+rWG0KpDBPumpwu4FOt7zH+6EjjG/Vs9rQwBfYGm83kf6oUXxcScAtctrBice3WXovR0z6aMV5UF/6iljqyPA8WvUCTdscXMWQzN7tHfhbXc7kWqQxonBPsZJUwGnXBS9SqWmvu4Qn64AYLmTKCqTxjdTkfKsc09RnbPdXGuAAWolKtvJf/cVBOREUB4ih13mP+VCBPEUPxJd8LYfNW5FIZNup7tbak4dabLQZn
 SLWIhAAR
 senvh2N98rjt1zh6WjPoXWHkOSZWX8Z5tgl+HGyUhqu5XVMM+HtBw0YDwsD15yyV/4TVxYXeNV210ryT5LDGhsstaR8lbuotcL/ubQcBoI8ReB2ZZu2KllHIjSoj+MPm7cOBw962EiYM6M6BonUrGAEQr2t/ip+hvm3ysU5uGjHBPQWwCMkZbm56D+Ig4zuBXtSyJ4H+/bCT8DDmG+5wtcB08ZbqhEZdYigZqG5758ooBBtEKvl4/vqBPRQor1qLmqRx7elYUC78dBhuQ2iN3BaXzdwFtLRlW+RKOSJN+qtvx5bXhyCJ2VBjClil10REeSQ+in/zQ3XKcAnGh7f2hLpR+Swtt/8Mp49BcOQAhTzhSBwxGQ4d7X3lLbp1EXufsPyy6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nth_page() is no longer required when iterating over pages within a
single folio, so let's just drop it when recording subpages.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/gup.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index b2a78f0291273..89ca0813791ab 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -488,12 +488,11 @@ static int record_subpages(struct page *page, unsigned long sz,
 			   unsigned long addr, unsigned long end,
 			   struct page **pages)
 {
-	struct page *start_page;
 	int nr;
 
-	start_page = nth_page(page, (addr & (sz - 1)) >> PAGE_SHIFT);
+	page += (addr & (sz - 1)) >> PAGE_SHIFT;
 	for (nr = 0; addr != end; nr++, addr += PAGE_SIZE)
-		pages[nr] = nth_page(start_page, nr);
+		pages[nr] = page++;
 
 	return nr;
 }
@@ -1512,7 +1511,7 @@ static long __get_user_pages(struct mm_struct *mm,
 			}
 
 			for (j = 0; j < page_increm; j++) {
-				subpage = nth_page(page, j);
+				subpage = page + j;
 				pages[i + j] = subpage;
 				flush_anon_page(vma, subpage, start + j * PAGE_SIZE);
 				flush_dcache_page(subpage);
-- 
2.50.1


