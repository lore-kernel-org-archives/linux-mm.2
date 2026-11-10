Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DBB8606A33C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 13:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Bo+daxnJ
Received: by kanga.kvack.org (Postfix)
	id 603BA6B05B8; Tue, 10 Nov 2026 08:59:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DD536B05B9; Tue, 10 Nov 2026 08:59:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5174F6B05BA; Tue, 10 Nov 2026 08:59:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A1F76B05B8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:59:02 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B5AB31408CF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:59:01 +0000 (UTC)
X-FDA: 85419365682.13.F70208F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id E06E840009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:58:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Bo+daxnJ;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794319140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=McJ7EzdjpZoZ9QnIZAXd1sj3iExgLNGvctdfccvpYpM=;
	b=oni6pZRm4xoXGbVBRmoIckhK3I2DczFEL0BUtc3BRcVchp5hd1pMG394JmF87C3YgfzLYa
	p34ztPLQ8AMexzwbuVxTKknn+g+knfoaMdc5Hz8oJ/rKS4YzeI5pmiMSmFxT7tPRHjfipt
	W/794Af7IX2BsOm8C9yoVATbpn017q4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Bo+daxnJ;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794319140;
	b=sBDwyeLsAfUm7zLK7xeiilFy6dJQ5xdRvir0ijV4ubWiWxSmEMRzPl56tBE/Ck0yusZ/zN
	zryhL0siui0M8IBiw0w+McvVoxvPKB/YVSgv0OpZgNsW/H2rbb9WsWFnvtYC+mOHj6EvUK
	A23WcDezzAgy3fvfSXT4G6sK1vnItMs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE22B143D;
	Tue, 10 Nov 2026 05:58:55 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 664113F632;
	Tue, 10 Nov 2026 05:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794319138; bh=Stqf/UeMkAaff9pue0Ee0wx6NrZ9dhCynge/n1sKPss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bo+daxnJU7wVO39qjldL1mCt8K2l43nW8A4EEFDG2BDw2X9yQ4sVkQEEnUQJeGIth
	 seQjpsPN0+sL7sV49A5Wzf5Cf5Eiyuca3I6uLoZrElWR2oFoxcmnHu64gcmo+CFsRO
	 nXgKaFX1Y2fv6Z4E5kUG1KcyVND612FsKVUjed0k=
Date: Tue, 10 Nov 2026 13:58:53 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Rik van Riel <riel@surriel.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yuan-Hao Hsu <aa9736195201@gmail.com>
Subject: Re: [PATCH v3 5/6] mm: gup: introduce gup_unshared_pages()
Message-ID: <avMjHS81ani_PtQ6@e129823.arm.com>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
 <20261109-refactor_gup_fast-v3-5-2aaef02df0e1@arm.com>
 <7627c0d90188b581e7740bf8d17c8dd07b460f89.camel@surriel.com>
 <avLqwIWHa5CAbHO2@e129823.arm.com>
 <aa227fea-d22b-4c0f-bd11-bf9ec36b0767@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa227fea-d22b-4c0f-bd11-bf9ec36b0767@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E06E840009
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: qgb5yk69pwyrbmmgtau7s7xet4619n9d
X-HE-Tag: 1794319139-650447
X-HE-Meta: U2FsdGVkX1801v38ryDvsVsuaOJOOOHumn4nGo3XssaBI0HHWAWBM6WPDCnnBZmaWdrKcrh9mjgDziMW0kncf74IkrbIyEgxGRcD+j8PLP+9kbV7R5/rmeShnT+BnjoVeZaKRPtx1PoHFY9Ozwooe9pAny6YIICa89BP+9CLjel/fQfvhAlQzgvxh5reN5x37SXEXKylLYYFmcd47muTg/ny0mgrJpu5KyZ59SE31Nl3GSYZFmbVqnOsC05ygRed8pNOKj9VPyNI5ZpcNnGi5KzuzVNNdmxjpW+mQryiKw6P0gO+/U9XNtssdAgUFGcvX2wtbcxNHh4NwOyotAzSv9aaRZ+IJexyhPFrhtgjRTLgXdkYx9n8g0FvBvu8/Ru7XSZKPAVsTSMVTT68Tknrb3m8Dw6LUw2bORc5Pplgo6eTjl01FDzU4VrsYtykg40ncteup7WtqAkKZknhHojWHo07NO0B/HXdFCmynobZrdwYFPAu2P2bRma7Oa0BhvjFwLJDYrAxhFpSWy9Ogrg6QOYQgyOqeBcYo0f4UBkalyPry64arA69em9POuVKgPNdX1uR88HPPofwgQonfNG47xU/4/UhebQhsXrq444Bv8nluZ3qfLxezobaKSTtKLaZTkbRm6NdHjEpo/qZ1chZzrsfJRWAyLifmD490ObZpRTjniq5sycF1eQbEHu4ayHmuTMsJTK9PPcOLWIvGrSMNwWDaUuAohpd4jPdYlLq1DfP0nTjyiWdfLCMBRCMHsTMxV4UstraWAKRBLNl+cUw05tEYcGgKzk1ijqCp2N5UYiCUH+botO2HB/hEaB1UzOTKajJDoeJzMDv9JbKRhJQtBMKuQOzW3G7W9YfzDkhgujmYJQiTSvFIkzdd1JdHkq2/yXExFpXHO1FxAmvdWEe5ssvWS3nS6RwiS1x76m+SLDLtYhXqzDptFw3X+71XMr3l4g5fsQ3ExwJVEreFEw
 EWREZyjx
 IVPvVONFUpyHt2MW4DX+vNgAe/D1ahHtS89g1EHQboWK9TK3v1EgzsZdW3QHe7fAdhz2Jl3QIBM1xcFu3rqVEJqYyzcL1mS2lZaIZ6ZMVCXLJYqLZ8kHhXzrMAgirQGG6AutYln1NC7WysEvbkv10tm4HOpET0J4TgP8EZGjMB6KVaNLtLLJeFuNmy3PNQ4JhWKRBOOCTHefqsx7xnoABY81DWynMg2bgyKxXWzFklkHMoB1g7nmp6yFfSF3bbOceFpDAgIb3lSD2r/L1QWdDkUUDn1Ltg7CPhrYZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 02:04:43PM +0100, David Hildenbrand (Arm) wrote:
> On 11/10/26 10:58, Yeoreum Yun wrote:
> > Hi Rik,
> > 
> >> On Mon, 2026-11-09 at 12:32 +0000, Yeoreum Yun wrote:
> >>> This is preparatory patch to make gup_fast_pte_range() batchable.
> >>>
> >>> Introduce gup_unshared_pages() to count consecutive pages within a
> >>> folio
> >>> that do not require unsharing, and use it to implement
> >>> gup_must_unshare().
> >>>
> >> Could gup_exclusive_pages() be a better name?
> > 
> > Yes. This seems much better for me. I'll change it in next-spin.
> 
> Not quite the right semantics. For pagecache folios we simply don't need
> unsharing in MAP_SHARED VMAs. That does not imply that these are exclusive.
> 
> So it's all about "number of pages that don't need unsharing".
> 
> Any idea for a fitting name ? :)

Might gup_pages_without_unshared()..? otherwise I couldn't image 
better name than origin...

-- 
Sincerely,
Yeoreum Yun

