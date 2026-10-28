Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB87C606A32D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 20:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fL8qtDFp
Received: by kanga.kvack.org (Postfix)
	id 508846B05C3; Wed, 28 Oct 2026 16:15:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B8566B05C4; Wed, 28 Oct 2026 16:15:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3588B6B05C5; Wed, 28 Oct 2026 16:15:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B6DC6B05C3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:15:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8BFF614015A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:15:25 +0000 (UTC)
X-FDA: 85373139810.04.24678C4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id CC52B100002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:15:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fL8qtDFp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793218523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KdmedUrWzEtTp05PuFK4Ncer2dR3r5JAfq1llDowfs8=;
	b=IRpaT4gaUSnDmyUbPK+gte1S980FCVafiFZYDY+V/ns3tUq0i+JjsrWHwnHsHdeUSxXguG
	Was/sWkSTwW88PegY3ihHrG0jHwYHK4UZg8fZy4YEKyqNt1HZxnc3+6SPHqtlsWr/M0RT6
	jX8k4+Iq4xOTr32+heQ8i1KO1UkQXg8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fL8qtDFp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793218523;
	b=g1VgOUfiaq0slr45TN0OvyENqbdGs7wRPHO1qs7nBw4QnAXXntm91yIIhF/WbUaOLlEntg
	r05ubHuLRqVKiGhi6tdqPYZpasIisZu/mpKrjJjh8jGp54B3Ez7Uvsbc7E4f39ZpuoYn68
	e3o2dl2Or2XjeDGF8h3VwNfuyFWqhr0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F367600C8;
	Wed, 28 Oct 2026 20:15:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97A11F01828;
	Wed, 28 Oct 2026 20:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793218523;
	bh=KdmedUrWzEtTp05PuFK4Ncer2dR3r5JAfq1llDowfs8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fL8qtDFpArubnAzzUrN4DekT5Rnq/qB54hxYZR/vjjwa1WD/AE9d+0DFjjWOc0Yjv
	 v6OUwG/iOgpMHGqwhajbqeKtjcqSFNMYY7VNWt3LW7LYbvie5aqirQRAoIemFr16ix
	 KC/9k04QQ1In0Cu/OdDoKMGqMPbCDYC5p3lZfVTCScE71iWcUWVtqidNwlvKHAy04w
	 XJH8x3R+LlLLGeSvevjLFpuD10/j/xygBGK2TmAFuKU2h6B1eRxX79XC9ves3y27TI
	 0OVJMNJLz+HAYuda8MSyLKVxgblQovSQKJM1A7eIHr09+9r24b1MofFAbcMLA9z0x/
	 bzyU2QiokJ99w==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 21:13:37 +0100
Subject: [PATCH 09/15] mm/memfd: recheck the page cache before allocating a
 hugetlb folio
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-fixes_hugetlb-v1-9-a0a033db180f@kernel.org>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
In-Reply-To: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1657; i=david@kernel.org;
 h=from:subject:message-id; bh=GKSzWPjp1+dBjhIazkgIibLYlmz/l1AboKBRT1V8Q84=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIehZftjfMpft56POuC0fX06JvccolPd9w/XWwrYto2w
 08qTJ+xo5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgIk4sTIyXG9qOqsdELzQtPXk
 80jRHRzp7RVCmfzekqpPd9gWVNy+z8hwZfaj97atsYxxeldDHop8zbkSIqSz+0vs/JQCDUWbGh1
 mAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CC52B100002
X-Stat-Signature: 7kw38557q41h1pk44mwz77b6fcttgmg1
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793218523-174901
X-HE-Meta: U2FsdGVkX1+Ps0Aj54XmwcC+2FwLBhSlBdPrkpbwZ8adv2Jo/TqQB7ohj+I95zbEly57AoSOI0rc2kGzFDjJxMSBn2U5nZwsUKx40/XgyCtk/GogwTSOvaE90M6qxkusRQDGZgRNa7mVYSKGdwIhHq8RMUBZNLE+e4WItmAWrJuH35KxEh4IpC4Bu57zHzaMF1kqMi2PTyEdDeRWW0boF3gqOhesKHijREzpb8gysSYnnjMZMtrE8cNQfa/Px4JNYAftitx4VlDYU93wzoo21gftizCirZiY26BCjwS21Osr3EHjF4h1R/jtZLkTfDH5+KlkOGhqqe18stS+bWK3Vpo6UuIXFh3Bs/E8RXjGuAU5l6CRkOcJFLBk0lzrViMmaxU3EA7pBDepCyPApddXr47XKnmkiNCeSAAlPTmifh7JKrz99wa5F9lMflZixv39MAbCywJ4glb8QjfyKJ6Y7Bthw3f6stzow6ElfxSgM4oHbJ0UO+xpI0PRuVqdpeNeAjyIRdE4YnNfBtNF/PW/gB7vZrhwV7pQk98ZRuQm0xkEhiH4NMNK6lUuPrAI5PZlLgbcRv81cy4aO8UK08R1V7HGa3lyHLDczmFXo8JKas/A5OqBnzNM/7baFONZqjAF+hy4ICDZ2S/eUxr66wXV4FUQ3FPTAkJlBYAgfthLVVBZyrEHHkr8oWDgQDhS2+Y2cnKChQ1iaWsAMMVtrDZnhb2tk075jdplI78KWRK/UojT6QO7cCk+6Tfz6xqam2b7ENT0Hgdamz2EEIB4SkHnwS7EDO6/4wY2FU4kWu2uOhc+Qn/80dL7f8i17oechdc1S2GYRuCWN+fk/GhN2FhHJTllH7LtlqnHFd8Jv0HkBbdft8LKoghf9zKPhGAzSCgt5owUHDWox0UmQs9KwCqhLux26uHbfHXPgozaqTvYhAERoJwKJ8slJrWXKUO7BsQ59FMQmqLF6HmHtMHaakA
 PCr0OsF+
 pRer6W+2CFvDLTFdrOv8z1Ny9YnGraJTu4fMA8utiq1pPuIzOi6yrj6tCdWDww+ELhh4Q3tUN3/u80UFUDfI7NXKZE7tHeSvF4tOgWhtBhD3CX7DCCW/eksF63hRX2ImQ3/w2gfltxig9KQ/O71Fkf4O6vOPnFRv6z4FhV7U+VgWJuwNa2lndxJMz6S6ujglLpccU9U0ELcMAkEpEzEqxmzdjdsxLmhDtJ2OIXP2EmCtMjFCqdK0p7q6Dng5zO1rJtwSSePoXktL6XTC7SPX1tj3nAaqztiHnlXKnUx3zMl1UofJ9MjuEB806OKMC5LGAKhgQ1j37a5RT/H8QpS6xfIMbkdqfG7YpcDAnPKA2rkenHoRn3DSwAomboSekxkCofCSq
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
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memfd.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/memfd.c b/mm/memfd.c
index 4650a69aa7a6..86842c077cdd 100644
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
2.43.0


