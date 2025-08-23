Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2868BCA0EFA
	for <linux-mm@archiver.kernel.org>; Sat, 23 Aug 2025 09:00:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 024266B0010; Sat, 23 Aug 2025 05:00:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF0296B0011; Sat, 23 Aug 2025 05:00:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB7D38E0018; Sat, 23 Aug 2025 05:00:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C7E826B0010
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 05:00:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5AD6D83EE0
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 09:00:11 +0000 (UTC)
X-FDA: 83807425422.13.B7F6047
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf17.hostedemail.com (Postfix) with ESMTP id 91D684000D
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 09:00:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rOGkWtsU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755939609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A3yFDc62nC30c8ipPORCXl1/TYX9qFzVOp/OlRE3m6M=;
	b=Hy79MHFa1Gir3LsHfurw5mQ4T8dTv3mKcFiPsRzCmNQskmN0iI+tMPPkTaRduhLly4h1kB
	Fn8TYerfHJLh4R+fTQmo+q7/mAmvpCQdMaugA7qMV7Y/TOPTsvBlSrVAKfMDOauk3+SE9x
	CCFzoRTWKjQDNCv9fiozq/KTThlZA4w=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rOGkWtsU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755939609; a=rsa-sha256;
	cv=none;
	b=sy4YuX0c0F1d5BksVum5hHHG6hVVAgw6kP771UBiJnmsVC2dPX5KRkxpse6j/AgEiIX+Tl
	4wDChCEE0oGeOysUtEABHxhs/HKoS6tlcomsgJAmi8KEX9scsdneDWAGd/H9Pr7X20kp0w
	16MwN9Ar0GI67ZRsjPZrkPTSaAEqiII=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 6ABA25C0FCC;
	Sat, 23 Aug 2025 09:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35E6C113D0;
	Sat, 23 Aug 2025 08:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755939608;
	bh=aU4s6rL8qphUf3ASSPtkvFhSbnF7KQL/5p/AkB6ZkD0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rOGkWtsURQmqeVJWZZ8QU1TwZHK57H1RHXwc/i48rhECw+oAVRa4mF0zfqNM3aJ7b
	 K4ufsfNlCAWHsLgknGRRJAM8fAg49ifByU7aHcJpd60KD5n2ftLsVEjekOSHSO2hKf
	 TyNgVi/IP/sZ+Zv1HQC39pwpdaVXtYVat6Ea2uqdZXF6QBRAllDzvBMajMv+E6mXfL
	 wV6BxOvsD2NYhNSk4hF0URYans98VMn0JY+kTDajsHLCy41MHKhsR0ynwpYDfvi23F
	 uDIHwC7s5hdPOSqfKNvqn2djgrkhoLcYMLwZ0RX2xL3FelT1nsv2lD+CEaDl2f3oOX
	 wFjm0sW7YW4bQ==
Date: Sat, 23 Aug 2025 11:59:50 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	linux-kernel@vger.kernel.org,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH RFC 10/35] mm/hugetlb: cleanup
 hugetlb_folio_init_tail_vmemmap()
Message-ID: <aKmDBobyvEX7ZUWL@kernel.org>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-11-david@redhat.com>
 <9156d191-9ec4-4422-bae9-2e8ce66f9d5e@redhat.com>
 <7077e09f-6ce9-43ba-8f87-47a290680141@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7077e09f-6ce9-43ba-8f87-47a290680141@redhat.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 91D684000D
X-Stat-Signature: t4af1tzraz6wxomn1dkiyyqxq7saepc8
X-Rspam-User: 
X-HE-Tag: 1755939609-322452
X-HE-Meta: U2FsdGVkX19dAycj74kVMBT3KABzdOrXh2t4nmrAGdWb6j82IxnBIwVrqk6lJy9O5y1+8EOMkzhR+i1oG/jKnXhiNWSDIg5NQmWK7CbZ/bvGaHcI7NfvivJt23+km8sv69oh1INC0uiEVi9LCAWx6lYtmnEBTHXS0N1RODgCCyIHfmpNnt6xs3hNzegyqmF+Q7tKetRYYicxTveOpcF5VIq5dDgV3PeBNkFg3mb6ez0OtviRugfliX89oEkPCV3dv4bTfzd1vsbIzqbF49LiINIBphIHoPzfCiFt8QfDvxmG2XfjBbgTWHfw2mzvctAk3x+4sceVE5/fEpwLYfHRhNEw0gilaheTm6wj1tSeFU13Oui6shpyBxjyIBwXt5JAVLK2mSNoewc8bH3Hmz17G2lW8zc22EZ+6Y9bgzKATuuS4o4ww2zvr8SFqMNUeAnPIgLn3g4y0IrxK481rsWJuU/KmHhprk/7y/bTdby1UR/pxPjd8x7zTeEwYhhVh+6UujApG75zjCV6SrkjGcnW45QNxzQw+ZyQJnpgrXQfATs0t5ftPNBGHWEuRPj6nn54MZMsIBotKfRSdCt8ImI7VZZ4KM6kKs56EGFheswmBpHy2Eb2i4c+tGfLsWPinPgZZnkvDNzcOsNRO34jdEt242JszyOKPr1ep6201ipO4pQW8sAmpD7kXyUmwlGMBT/ud0C5BAG5pzAN4ZNsw0sKjp2TCASlFG/Zi+gjCdKQGqwpQMtD8rlRrCcTitHEUF3HKc8XRWddkcK3148x2hXhsb4zzg5vOclbWu50GH/3QAa8jd1lKKkZIm7PxgV2oyIgtFU/bWDpF0NOPXBiZ9i4o+vznEAKNrnbOm8PuOAl9Bx12M128ESzAAG6z+iQR4ZKsQHmR4tK0mLjAzWMCvVJQ6wpceZEQwtZHqIuoLUmv7IdOExoT7EUB0tywHHRes7WWpJLqlf4T6EJTso4fqH
 xWkuk+c6
 G8NRbg8h4nTJvvo9OwMLmbO2w2l3KoTn4FgLr8cfjN1Z86bgDXLzEcNbKAJbA74i4omNaspufXPes8jwrWAMGy+DJEWtu8rJFWRX/spLXN2G4vBbAB54uFlAZ8+ooyTCWQmWmOGWqLEg5N11xaVoCY0hlJflRrvR5+ijMdVIGAVzDTRNd1hVIbk+LeQUFG79MhnGdbnMOfo7FFuu5wS2nq0T+iTMbw5CEfM5M1E57O/fYednyrJMUZVwINqzU6CZWLiZePNG2aXHRsYyYHmu/jnjFoRvt3ab2v8bmx6vLyb4k3u+aUVvhyd+vYg2kh763ieHaUjj86MH1FJGDzIxg0cl7DWTDX3xH5GRbdBINptgl144=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 08:24:31AM +0200, David Hildenbrand wrote:
> On 22.08.25 06:09, Mika Penttilä wrote:
> > 
> > On 8/21/25 23:06, David Hildenbrand wrote:
> > 
> > > All pages were already initialized and set to PageReserved() with a
> > > refcount of 1 by MM init code.
> > 
> > Just to be sure, how is this working with MEMBLOCK_RSRV_NOINIT, where MM is supposed not to
> > initialize struct pages?
> 
> Excellent point, I did not know about that one.
> 
> Spotting that we don't do the same for the head page made me assume that
> it's just a misuse of __init_single_page().
> 
> But the nasty thing is that we use memblock_reserved_mark_noinit() to only
> mark the tail pages ...

And even nastier thing is that when CONFIG_DEFERRED_STRUCT_PAGE_INIT is
disabled struct pages are initialized regardless of
memblock_reserved_mark_noinit().

I think this patch should go in before your updates:

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 753f99b4c718..1c51788339a5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3230,6 +3230,22 @@ int __alloc_bootmem_huge_page(struct hstate *h, int nid)
 	return 1;
 }
 
+/*
+ * Tail pages in a huge folio allocated from memblock are marked as 'noinit',
+ * which means that when CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled their
+ * struct page won't be initialized
+ */
+#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
+static void __init hugetlb_init_tail_page(struct page *page, unsigned long pfn,
+					enum zone_type zone, int nid)
+{
+	__init_single_page(page, pfn, zone, nid);
+}
+#else
+static inline void hugetlb_init_tail_page(struct page *page, unsigned long pfn,
+					enum zone_type zone, int nid) {}
+#endif
+
 /* Initialize [start_page:end_page_number] tail struct pages of a hugepage */
 static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
 					unsigned long start_page_number,
@@ -3244,7 +3260,7 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
 	for (pfn = head_pfn + start_page_number; pfn < end_pfn; pfn++) {
 		struct page *page = pfn_to_page(pfn);
 
-		__init_single_page(page, pfn, zone, nid);
+		hugetlb_init_tail_page(page, pfn, zone, nid);
 		prep_compound_tail((struct page *)folio, pfn - head_pfn);
 		ret = page_ref_freeze(page, 1);
 		VM_BUG_ON(!ret);
 
> Let me revert back to __init_single_page() and add a big fat comment why
> this is required.
> 
> Thanks!

-- 
Sincerely yours,
Mike.

