Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFB04C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 15:52:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 207936B00A1; Fri, 16 Jan 2026 10:52:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DBF16B00A3; Fri, 16 Jan 2026 10:52:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 115FE6B00A4; Fri, 16 Jan 2026 10:52:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F27326B00A1
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:52:11 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8F0741401C1
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:52:11 +0000 (UTC)
X-FDA: 84338268462.26.65F9203
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9D1A380006
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:52:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pmc1Imf4;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768578729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DAXTH9K/9J54fVibpRzTXyiXBRatZjJKQ5vFQrc3G3M=;
	b=L8bgtaaEzFP7Id4vdREyCglbU3RPKB7o56pGgsxF+MKQOSDrZsvPUK4oftm2LI+ZD+6Hke
	7dVUtK0iY6/eJRfiwAxe5NgUxIt9+/H+xSzOur6yffRHG6tvVUorPcgK7hmIYSsSLbhD8p
	4Q5yl6XdIh9nAGHGmKUc5xMfRk342Dg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pmc1Imf4;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768578729; a=rsa-sha256;
	cv=none;
	b=WN0hAQOH0RzTslHdNNQNn418H4Rfu7ewLJKc83ejtIuxxmF51o9O56WGOFOWGeThqbyDP+
	ydBhj0tAhhczdlt/9H0fFL3Ni0jMIAZ2z5VN7HFUzzyODJYrZZcVco7BX+a93LehJHBUZ6
	Mnjm/WDTKqbHlwGwIXvfp+XTcVSn90E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DF619601B4;
	Fri, 16 Jan 2026 15:52:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B93C116C6;
	Fri, 16 Jan 2026 15:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768578728;
	bh=eCzWYaGZTUP+beL+9UPZ9ITMhEfxovlcFAIKTTrSvZ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pmc1Imf4gORlu96JpBp6zNbihTHFSqK7nquXUULOcnBi+H3oSuXZqDIf3EsJk4hyL
	 kOFpLoL6gUi4aHMp4VLnv2zAxpYUGZqYaimnHf/1erVDCd2GxmyRmfCjcvCa4EMuYZ
	 fcoEMRqn8xmDVuYcWKqfQH9qsCNd1BWS+4aG5Zd5n/znFnTdgFw9+VMngHWb29MwLT
	 pRTELNA2C6yRXJLZt82Rm7FWCueuRkuCRW9TffkR8Uj3AwjpH+a3edVMZStEvMraYt
	 PapD2N5KDNcl/9HFrDmQA2fVJPlxf6NATUNFQQUyGxgrGe4hD6tZdtUQDhQezOnHDj
	 169915KiQrTdw==
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfauth.phl.internal (Postfix) with ESMTP id 4D3BCF4006A;
	Fri, 16 Jan 2026 10:52:07 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Fri, 16 Jan 2026 10:52:07 -0500
X-ME-Sender: <xms:p15qaYZ6tvRD3Pfui3Ky--bjoitvSOcIGky0pUw3ZhwJyHzu3EPhtQ>
    <xme:p15qaeytjWmVMUj8Qe-ArKb7jDI_O8UMrP1KgCSTWQeYok4isam0hRYQxJqpVTNq8
    saAcxudwFMSKdv7DI1NYivLj5YqS0fbwsFXfUHhbgfMIcF2t-bugMMY>
X-ME-Received: <xmr:p15qacUb1mXWq7b-vGdq7OksmrrxUdHq0FtAtTTvto5arJJ-9u1UYBBTAyip_w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduvdelfeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtrodttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdetfeelteefteekfefggfffteelvedulefgveduvdeljeejjedtfeegfedvkeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfeekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepuggrvh
    hiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhu
    nhgurghtihhonhdrohhrghdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:p15qaaYYJJyRdPZU62RC-HDsWBgPudLkz1GCFCcdQbE7rUjNt0kgmQ>
    <xmx:p15qafONNJxOPFbr6xfWLJDLqO2KJpF-wy3sY2b45eYc9DXuhEK9uw>
    <xmx:p15qaWvsUe49MsUTq7CRnHmOketxvTSDNOoWx-bLzP8hgRNABo9_lQ>
    <xmx:p15qad2VD5hVFV_XwQ2E2lmWnCEhB590c3re0hKwJg_iONlxlDvw0Q>
    <xmx:p15qacW3Z2CMVXDDByGjRzPdsGxPU--NWxnLfDw4Vj46pIrUoXr12QZS>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 16 Jan 2026 10:52:06 -0500 (EST)
Date: Fri, 16 Jan 2026 15:52:05 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>, 
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv3 10/15] mm/hugetlb: Remove fake head pages
Message-ID: <aWpTopypeRTOIVGR@thinkstation>
References: <20260115144604.822702-1-kas@kernel.org>
 <20260115144604.822702-11-kas@kernel.org>
 <30ae1623-63f9-4729-9c19-9b0a9a0ae9f1@kernel.org>
 <aWkhbWR-3fWjeTaE@thinkstation>
 <53980726-C7F0-4648-99E9-89E10645F2E7@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53980726-C7F0-4648-99E9-89E10645F2E7@linux.dev>
X-Stat-Signature: t8t6p9ntsdf8wxth6prds9dxedkwizjd
X-Rspamd-Queue-Id: 9D1A380006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768578729-291068
X-HE-Meta: U2FsdGVkX1+xA5ehs1RXMUJOAXrNXSVrLPJnwQzV1u96+sK728dJ+xstDRHCJwXHs1r2Zrd51sK8sW9C9rvGSvZOCTlBidtBMn+V27FKIUh023wha5336UMj+tUuisTG606Z55zHBwB5+JO14r8gESWhTOwpgCzYmGmOuzVA32OfbEgS0QsC1aWgIAUEzeAQ+kqsR3Qc1K1iJxL1WBvFOc9z53JPl43NxwJYW/HGe9F5LzVlJ9d4EZ8407j1UsszdFoPYjs2hxf7C49NguyfREA50E6S9cPLuhNoTAW0L7CMqOYEarZXEadLtlTHYlkdBNJeevwpot4e5035GcP+Ihmkez6/C70UQjXph3bzzDSFsqCtCvLZCUCHDInpZDTZFIsw7sjtxGSrTpN8D+ZlWcS/I2hQJf7TyG9vbLaFp7v8N2vY++Vnb24uPpPoIrXLVoFWddI7Jh6YNwObRYDATrBawI21pa8ZFS8q3sCaQQic4vPihFOp6Lks4mQws2Wes5lkLKRa7JiNetEuZQUuFtO6g5pQfI5noyrj379iKVNfNc9m+aSxNSkEXDMS8Qml9fS1OfeOzkahlWh6QPEp7HYVg8uurcSLqLl18pokisLCgVdmYZkeZlMHrTXiH5CXBGxmEbad/N6cfPMisEFsrltNroATraVIAFE+74WsI9mlTdQ3XSRdfqabGy/E+MlVki/PSLcG4bxHuavsAgSiAjLURX5BJTA4vdrWS3fb2Z9Msl7fMNG1PJCT+syrgJdjHx/VRadtIou//qT3Cdf+BbokDn5kmvwTQAvK5XbgC79+UVul7wp8VRftMWvFgNHttsMtknM5TfFuoqzFtA6+Wwize6uV03yOPxR6ENN1YOplhbrQcSYTEOEliR+2qIxZv/5P/MeoGwd1PcOXJFQBOKBLU3FBFa+loPBc/sAb+Uqu0xmvIHnMochST8ly1F9xxjrVHITq2lTs8ZQ8ui5
 6Fa79yVv
 DGxM7yTvSHmXpT3cbazt6yY4iwNhCfDwWXS2YGi18eCpaXl8pz+Hi/6wtbv5QO6Ch+NMkDR8aRX/hRu4sgHcSjCDA9RofFGUwsIvPeE7y6D7FjFUx37EQyoSY578KVFdoskzL7WCW1BUkszIHYqWDbf8x2c4Rv0l7nJg+EnuT7R9eLsReBCtc41M+3cncgFJI3qKbLLqLUKJDcpdyVc6UJHfgbhtycYPXp8EFDiJOauEpR7HybRX2fvOgcChatvFELr4LbG7t0j+LcSgekDIHvMse1wdMd+IHAbgZg9sPl3QRJmo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 10:38:02AM +0800, Muchun Song wrote:
> 
> 
> > On Jan 16, 2026, at 01:23, Kiryl Shutsemau <kas@kernel.org> wrote:
> > 
> > On Thu, Jan 15, 2026 at 05:49:43PM +0100, David Hildenbrand (Red Hat) wrote:
> >> On 1/15/26 15:45, Kiryl Shutsemau wrote:
> >>> HugeTLB Vmemmap Optimization (HVO) reduces memory usage by freeing most
> >>> vmemmap pages for huge pages and remapping the freed range to a single
> >>> page containing the struct page metadata.
> >>> 
> >>> With the new mask-based compound_info encoding (for power-of-2 struct
> >>> page sizes), all tail pages of the same order are now identical
> >>> regardless of which compound page they belong to. This means the tail
> >>> pages can be truly shared without fake heads.
> >>> 
> >>> Allocate a single page of initialized tail struct pages per NUMA node
> >>> per order in the vmemmap_tails[] array in pglist_data. All huge pages
> >>> of that order on the node share this tail page, mapped read-only into
> >>> their vmemmap. The head page remains unique per huge page.
> >>> 
> >>> This eliminates fake heads while maintaining the same memory savings,
> >>> and simplifies compound_head() by removing fake head detection.
> >>> 
> >>> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> >>> ---
> >>>  include/linux/mmzone.h | 16 ++++++++++++++-
> >>>  mm/hugetlb_vmemmap.c   | 44 ++++++++++++++++++++++++++++++++++++++++--
> >>>  mm/sparse-vmemmap.c    | 44 ++++++++++++++++++++++++++++++++++--------
> >>>  3 files changed, 93 insertions(+), 11 deletions(-)
> >>> 
> >>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> >>> index 322ed4c42cfc..2ee3eb610291 100644
> >>> --- a/include/linux/mmzone.h
> >>> +++ b/include/linux/mmzone.h
> >>> @@ -82,7 +82,11 @@
> >>>   * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with hugetlb, we expect
> >>>   * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
> >>>   */
> >>> -#define MAX_FOLIO_ORDER get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G)
> >>> +#ifdef CONFIG_64BIT
> >>> +#define MAX_FOLIO_ORDER (34 - PAGE_SHIFT)
> >>> +#else
> >>> +#define MAX_FOLIO_ORDER (30 - PAGE_SHIFT)
> >>> +#endif
> >> 
> >> Where do these magic values stem from, and how do they related to the
> >> comment above that clearly spells out 16G vs. 1G ?
> > 
> > This doesn't change the resulting value: 1UL << 34 is 16GiB, 1UL << 30
> > is 1G. Subtract PAGE_SHIFT to get the order.
> > 
> > The change allows the value to be used to define NR_VMEMMAP_TAILS which
> > is used specify size of vmemmap_tails array.
> 
> How about allocate ->vmemmap_tails array dynamically? If sizeof of struct
> page is not power of two, then we could optimize away this array. Besides,
> the original MAX_FOLIO_ORDER could work as well.

This is tricky.

We need vmemmap_tails array to be around early, in
hugetlb_vmemmap_init_early(). By the time, we don't have slab
functional yet.

I think getting the array compile-time is the best shot.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

