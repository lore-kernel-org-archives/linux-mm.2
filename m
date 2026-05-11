Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87D3ACD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:25:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC3536B008A; Mon, 11 May 2026 04:25:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9AF16B008C; Mon, 11 May 2026 04:25:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB12A6B0092; Mon, 11 May 2026 04:25:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A6AE66B008A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:25:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6A2768D6C6
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:25:21 +0000 (UTC)
X-FDA: 84754454442.23.BB6325A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id A0C7E160003
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:25:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RITApxZ2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778487919; a=rsa-sha256;
	cv=none;
	b=ofZmlLP8+RkD0n/4w9Rxm8mz124F986VuD/8XXM3xyy4OmtZAQdMWyDY/1SuMm2VqxYnA+
	PC43pMFwo3dDkHkdTEU4nOJLITle5FRTBPq9UWKJzT0lkq9gBlReAHcRZgMIPyCUkVY+0K
	Bg4ZS7+kpSFo+8MKcYq4j0pf/t3mr6E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RITApxZ2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778487919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EBufWyyy6P55DugCi7OyorQ+W3Eupp72xaMkOEJA39k=;
	b=ECct/Jspy8yfhjtiRVxCbrTW9p4gyCr4aBW32UXxT/rCjLaBXO/eybRUErnV38m50sbHsD
	O+EZUcmMi1/wDxooMhxaY2+hCrluhaQ3WJA8+trQmxVGMRbRIa2qY8EPpn1i0uRNenYVKV
	QBo4bLpPdkkpZqna10Cw80bjh7N1Dy8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B2E3D40B56;
	Mon, 11 May 2026 08:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B477C2BCB0;
	Mon, 11 May 2026 08:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778487918;
	bh=kZjuknJM9Bh3GaMJvk4tQSd2Zw2bmhiR+3ExpTU4yQQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RITApxZ2l/xhtczLejOGUSd1hbI7T05edXZfB7OGviYnHxtN/LwlBnlPlLAowmI4H
	 PsZz2+SaBqauLi6jGIAMk5FuEdN8xsdoef2zPNgCwZ64mPyLeEX/mCxKU8ONxL67qG
	 /0+fOq0VrHERuATufi9HUOIvd/VbLC9YfGsfEUM99Qdi+kjIGL009pvbnKH05midKX
	 zHnhxhiIBYy/Zty5elTF5ryaBXUXlWdGjIg41DxP3NOM47Y9TlUZU/8jTGioE1iRRG
	 y6/rJB+3vrFxf4LBC8o/JE4/oIcOAobjKNWpCajgbLjbDTHuCSM+b2ccxVXxuyPlYY
	 8DyFzM4kVQmcw==
Date: Mon, 11 May 2026 11:25:07 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
	Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 35/54] selftests/mm: hugepage_dio: add setup of
 HugeTLB pages
Message-ID: <agGSYxlShNEbcTbW@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-36-rppt@kernel.org>
 <ae5882a8-7cf9-46cb-a1ac-d04f501e2e62@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae5882a8-7cf9-46cb-a1ac-d04f501e2e62@arm.com>
X-Stat-Signature: mpmrgskttiiatj594y8ei3rs83opmug9
X-Rspam-User: 
X-Rspamd-Queue-Id: A0C7E160003
X-Rspamd-Server: rspam07
X-HE-Tag: 1778487919-251886
X-HE-Meta: U2FsdGVkX18EfiVNgnoAUHg9w+TGdBjOALUnvG0DmMscqX2aFttQVbLDsAYO8SzFNt4rJnZotY5T9Fbk9tAY4YC5DFBFhYv8FNCJMAaXOjC4HTaNXO68n6GszR31gcDF2irES73ghCsL8ZJpfuQBC6vcdSkboCp7sjag7undQKZt8772M2NWz/F5KFLiUmi1gGX7Bap6a9eUPT3mdhzkah6R9JW4GeNVPAAJ1qqpBJ52w3Ynt0AEq7bM4IUNF6O08Fm1ZS2yqGwM0EpNRhJ7PWg41bLjbX4IfFrrwAdkzjPJ1IZQ3I7WE3+OAtp7YGP9vPF6bk11TjRSuk1Tjsm1tW+mZDj7i49VlOnbzNpMdq+S7n08GLZKwClJ/80VkOV3j1lV6YU4+ea+Yr3axNoTXOd416o2wYr3nTu76RLMJF/lRiKsu66KKw3Gh5/H9PEdAbzaw910lhm5+1tx3mzPZ/3xQ7+ULSg7eEblXXJT1acHdSHNbo9zQMSi00EKq+33RHMvc7ZgXuFFHm1oek7nPSse+gPYcNeR2YlJtoYpx2z6vQCcEfvFLTYqJsoIaDkVX6xz8gBQqy8DtC+JZt2akr130f7VDlFGqy0Gh1jwGrFUIQ9aaS0Kgn83hEyKLFCR5gNvMDU7scWYmz5SHIPad0o60oYObT9Nt5d0ysWq54xchOTBZO/yE2CzwXaqAr92ikKr+CUQyKtQJL6cncV0ZdZfBkV0ywnW/J2EvcWpUTdASPHtfRAAJTI6QxSqMsKsEM/1bARsXWd4aQwUiurUd0RhyW9uetrVy+WLSUts30VNqfsDrexEDUgRlueSdlTgyPL42B5KZrRZXW2bHxsJt8auL6S5fJWqnLj67cX+60TwAUMj66UjAwIGn+NOFcnOIamnx6BsLnVG0MASfVv0kTzrp9Uh2cNEyrWwa1Q2brhIfSjzA/cpu0efBDW/LJPzjmvIBFYvxcu05sj9NHc
 qPCJhfP6
 mQQ2cybXUlHnVTM0fGxU8cqd3WPMB+iA8KhA8PPUeCmuuiyim9+4pVOo773XXiSfKwcjqlakNlInSoJLQIvtr8SwbUvkqizBOM0CFNcMnptlHi2swEOFQWI3iw9HvxFoqZjNRl8rBC4ZZOi+s4AlCMLmzjBb+agT5A479OOX7OGavFvRHX57i/AlnKbvhy2uXgWVaaW+OxqUUHklkEHtpmyTQ8uxLpL5RQZHRS0tgISunlgF6LSnkKq1NouCnPp18/J9ETfpXPWMGcn1utj5ATZctCIB1A2+Oko3ODB4Gee11EHsY2//qd0ZhqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sarthak,

On Mon, May 04, 2026 at 05:50:06PM +0530, Sarthak Sharma wrote:
> On 4/29/26 2:12 AM, Mike Rapoport wrote:
> > @@ -141,8 +135,8 @@ int main(void)
> >  
> >  	ksft_print_header();
> >  
> > -	/* Check if huge pages are free */
> > -	if (!hugetlb_free_default_pages())
> > +	/* request a huge page */
> > +	if (!hugetlb_setup_default(1))
> >  		ksft_exit_skip("No free hugepage, exiting\n");
> 
> Before applying the patch, I get the following output:
> 
> TAP version 13
> 1..4
> # No. Free pages before allocation : 112
> # No. Free pages after munmap : 112
> ok 1 free huge pages from 0-12288
> # No. Free pages before allocation : 112
> # No. Free pages after munmap : 112
> ok 2 free huge pages from 0-10240
> # No. Free pages before allocation : 112
> # No. Free pages after munmap : 112
> ok 3 free huge pages from 2048-12288
> # No. Free pages before allocation : 112
> # No. Free pages after munmap : 112
> ok 4 free huge pages from 2048-14336
> # Totals: pass:4 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
> After applying the patch, I get this:
> 
> TAP version 13
> # [INFO] detected hugetlb page size: 2048 KiB
> # [INFO] detected hugetlb page size: 32768 KiB
> # [INFO] detected hugetlb page size: 64 KiB
> # [INFO] detected hugetlb page size: 1048576 KiB
> 1..0 # SKIP No free hugepage, exiting
> 
> even when I have 112 free and 128 total hugepages of size 2MB (default
> for my system).
> 
> Could it be because hugetlb_setup_default(1) here is trying to set the
> default hugetlb pool size to exactly 1, and then checking whether there
> is exactly 1 free hugepage, instead of simply checking whether at least
> 1 free hugepage is available?

I'm going to update hugetlb_setup_default() to check if there are enough
free huge pages and add more if necessary and I will add
hugetlb_setup_default_exact() for tests that require exact number of huge
pages.
 
> >  
> >  	fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
> 

-- 
Sincerely yours,
Mike.

