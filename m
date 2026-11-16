Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5899606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 18:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e9cNzfm7
Received: by kanga.kvack.org (Postfix)
	id 61BC86B05C3; Mon, 16 Nov 2026 13:31:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CC536B05C4; Mon, 16 Nov 2026 13:31:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 494A86B05C5; Mon, 16 Nov 2026 13:31:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 178AF6B05C3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:31:14 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 877451C2C45
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:31:13 +0000 (UTC)
X-FDA: 85441824426.30.5C4BC82
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id B43851C0004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:31:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e9cNzfm7;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794853871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7xoRignLZxBv7QZtu4zQ7je7wi7y0KfxNbKworbD0gM=;
	b=OcgFNGqycLozxe9zAUmfPbYtogFZrnwEvc8sGZ1o/8NBIYI2xzf5qkD76/HwKRAuWpfSFW
	PF2ZcZw/i52PDzqPWakHfSg69ue9E/1y76LJGjzg3Ty+rUY2do2dyTK67mq+8/aJDHwIbf
	AeKbEL5Y9W8kR7zof9gTUDySPeEb9ww=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e9cNzfm7;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794853871;
	b=XAtbRx4AqcxPZUtkX5r8I9jE/gd8iM6zDNoih28Y9ZI3i698WrSNlR9pdfbLOlvzp0qJr5
	StMnyPi/kpZE+uAkw3aA+UCE+r2IHc7PTq1H4HZqF6jsUXklG4h3fIXumq5mNzhDI+CD8l
	GhMe70QzxuE+qdDmW5s07zxaa74YObs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 05E2B41317;
	Mon, 16 Nov 2026 18:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A545C1F000CB;
	Mon, 16 Nov 2026 18:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794853870;
	bh=7xoRignLZxBv7QZtu4zQ7je7wi7y0KfxNbKworbD0gM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=e9cNzfm7zhA94WiFHHOPsFle10thDfdLkUmMZHm0yFawrl5DPpcEg1O35UAka9G/c
	 aKKrw85NUzwrzQe78De4iorqYXugYPLNk7xlIz7NJI1tefZJQZFcyYR4i4fdLTezrm
	 mVSzxHT7/ckQnScWVXhub2qk9DniOh088MdDj9o0xXss4EFes/z47EWF11w8vQiiwB
	 OOL90pqX6FLIgazANPHOiEh67IQRXCyuGTl1aPFmuJ/4JnFmC/fzPemYxi+4ijTB9l
	 StocQ0oESnZJAoYKsSIjUGI+uqK4viz0FefzYiHvnGuu/mEeJ7qxxjvXp+i7E6BlMb
	 9cZjBnFwg81Yw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 16 Nov 2026 19:29:30 +0100
Subject: [PATCH v2 09/15] mm/memfd: recheck the page cache before
 allocating a hugetlb folio
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-fixes_hugetlb-v2-9-4dd9e94ea9ac@kernel.org>
References: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
In-Reply-To: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
 Andy Whitcroft <apw@canonical.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Dave Airlie <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>, 
 Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1706; i=david@kernel.org;
 h=from:subject:message-id; bh=WyvaefU93I0GCeigHLBuumui8uriM1cUAYO1SQkwUYU=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLJ+e3fM93KM2H1A55fa1H8ikqfaN/8+qXdr8vsrj5IzJ
 Xa5pnGldJSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjARzrcM/33DbZt0pV7UTFkk
 76LybMJDm90rNi185/pUZb1hyIT4mM0M/2v5S2pn7Hh73UiB4cY+B1ttbgcdjZ39F3ZPvhe/6Mj
 ivywA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B43851C0004
X-Stat-Signature: rgeem77t9uiir7fsuz4qu1x3zq7ydmf9
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794853871-469522
X-HE-Meta: U2FsdGVkX1/LRomKvTs67GILDzdoZlv6yy3QhHbUd4471k/LhzRnLXu6p3RdktAV7V+YFrUhujB11s8Jc4s4SShZMl2CFhIyG49bCgifgeVxi/W4RuK5Bc6AzTX5eaOqnTjMqnVlr/2tdDsDRlIJUzpbYRcCqbLGf3hxs81acs86RCK43DAmTz1nOEzK0dqI+uhGtUH9wuMGNPG7REuwdUUd/FBsVbD55LGz9H4K9+gRGIhbpOGNhTzMuD+P3yXcbLu27tY0OKNZTkMJ+AATYy47DX+mjbX9roybgKJKV5lExWhpxf6jF/5Z4tQr+KNGGTvtiETiJcN6CpNOzqq+HsihJQcP1IweyRmQrHwBcI5iuXRsHQILZkWdkyiJqKkjb/RZbvW4lWxNprVxXtYAsfecpY4k1JO/TZjYXtSJPsVU3eEq+bs2uUVTUIMEUoZ7fPKiNBgOdW5r+zk8sEC/aN2gZoqUq6txx0lWQnVBARlCyCWRyO0yR1dBNgL0l6/wgW52exs7o6hvyL/uG25A29zp19Ss8Rm4ehhOpn38pgBc9VgecfjB0UimWltuywf1eipIgUumwfMervt/hWWcCbp3qRPR3sF6ASCR2vpyRj8JHAEekWDBYhsunTZPGfdrmg+4LWj8z1Vzks0bgTUmqWFqgwkHMSUTr+9FeMoA26b2ln/6qTD6QB0vh/CURqSVyDRjUMTc6oxTSdR0KOt4aY51CNfs67h5z83dI5P+A4xwvO112eoHMbqaGSvSIoX2S6k7ZryfDn9qVoqe9hYzoATZnTFUwbzf4TuY05NZWDbMSeOUzLH7ZesZlZlPA7rLSLx9BrFxL7aQIpRqsa/F3kHpY6twcVgxqqNiDeZBo69spL/C9T1p5P0SlAybfqlSrcMuS/qlFj+dWKv6WHUL/togTZi1ZAvapaOIf/kZZXLs8Sn2aTsUhvhRt2kzdvkhlbhsjAUvTgxuiyfgxtw
 DxgbqHVu
 o70IUNUUo5HbWj0EE980QjuFsAnLMDjtefy740QeRm4r/BJzPKfMuHRha/pDY4MhlYS4em7yLX7NwajrEFgy6vhhJKfc6r2D03Q8h64iCeN0esyWWkbfd0NrH6NrC7DWRJC6ic6xkFsGOWXXVTkrb6VmRKXGI5TH4s04xvmWN7QO6i23RvgprwSJT2lf0AQshWW9T1vKBwsUoqtcM0s0d8OJhyPiUterImcv/NiuKMrvw1A7rwSGWTZpBDSX6P5uzoKPDB3v+lt22aUhjhMn5wohHzxVRfzWFYgomdE5btqXYG8NuLTWrrcxyiPbtbl3xoxcvjB4NaFloFkOgTIYXtWhHc+V7kS5R448E0JTBmGoVMkTwI7YWp5tA/EP6sLCS4d7W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A concurrent fault or PIN request can populate the page cache
after memfd_pin_folios() misses it in the page cache but before
memfd_alloc_folio() takes the fault mutex. The latter still tries to
allocate another folio and can return -ENOMEM even though the requested
folio is already cached.

In particular, hugetlb_reserve_pages() finds the existing reservation-map
entry and reserves nothing. If no global reservations remain,
alloc_hugetlb_folio_reserve() fails even when the pool has free pages,
effectively failing memfd_pin_folios().

Recheck the page cache before reserving or allocating. If the folio is
present, drop the lookup reference and return -EEXIST so
memfd_pin_folios() retries its lookup.

This is probably not worth backporting to stable.

Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Reported-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memfd.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/memfd.c b/mm/memfd.c
index f03d12aa71f7a..276f4323b6bda 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -102,6 +102,15 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 			goto out_unlock;
 		}
 
+		/* Let the caller retry if we raced with population. */
+		folio = filemap_get_folio(memfd->f_mapping,
+					  idx << huge_page_order(h));
+		if (!IS_ERR(folio)) {
+			folio_put(folio);
+			err = -EEXIST;
+			goto out_unlock;
+		}
+
 		nr_resv = hugetlb_reserve_pages(inode, idx, idx + 1, NULL, EMPTY_VMA_FLAGS);
 		if (nr_resv < 0) {
 			err = nr_resv;

-- 
2.56.1


