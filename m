Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57AA7CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 15:35:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D6B16B0010; Mon, 24 Nov 2025 10:35:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 986AC6B0023; Mon, 24 Nov 2025 10:35:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89C726B002E; Mon, 24 Nov 2025 10:35:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 78B026B0010
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:35:58 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B51D1A0438
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:35:56 +0000 (UTC)
X-FDA: 84145901112.01.9FABE26
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id E8F0C100016
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:35:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UmjEetKU;
	spf=pass (imf05.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763998554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=itb/xXAfkYWCmjKDgDZEeu7vA227PwFJfdjmUe6C3a8=;
	b=79nE1k/MqrrPRN60ca0+1GlMz3WF1I9+GWnw7b2H2yg111HBUnDDEyJxIohEnuE6GxIj70
	ZsOj/aC0B/hs5PWgImmiDH6C9ctpgW5fX39f+lv4U0w2GplUzs9wopcTTmsbqmVOqzj+wG
	WKf5k6iSbaG8TUv9+VzKP9ZNTQNFkHA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UmjEetKU;
	spf=pass (imf05.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763998555; a=rsa-sha256;
	cv=none;
	b=bI8l92BrpKt3oLKfNouP8rkjI6LNKr0/1IffqjGoLJBPRuL4DhzJudsBitnPPcunHVc+zz
	2sEJenLVvY3l9tN/gxvmeows4vgdVnefFEFeCsthNPKUD/z/OEyDIP6XjZiurW2jibh5PW
	Ykc9KVTLo0gwyhreM/HreNmVdXkcY1M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4EFB660168;
	Mon, 24 Nov 2025 15:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C384C4CEF1;
	Mon, 24 Nov 2025 15:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763998554;
	bh=7VZeXfp6ZIRCC08fnhWtDnsbWcV7AvyrY5shwTqTDd8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UmjEetKUsP8vTi2+W9Jpienz7MdX9ymF4BAXdAIA5wp7OWWquN8S4o6M25N3aBP3j
	 m16mRE5WLVsqyUxNOfcEDQJJv3+ljpL42Mv7HVj30PFQEjGmBIvoBphSk/QhY6/gp9
	 tGZeXkz8UrIatNiVl+kFUo3CejtmPvWFcGyzUzXKI07aVx/WWx5pM4GkEfIUbHoDPV
	 RmbYrnIQBRpy1LYlsd8wVSL3Gh6jVK/FGYJMm6aC43B57l486Pu0aWOH4MB4X+sGD2
	 Ff91CMw3oECCDzLPmFB6ZOEFQiZ8plV/7laYbywsn/2TEMD2BGZET3yxeSSCDFsOZK
	 tugDPAzLiRYRw==
Date: Mon, 24 Nov 2025 15:35:47 +0000
From: Will Deacon <will@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, jackmanb@google.com,
	hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, Qinxin Xia <xiaqinxin@huawei.com>
Subject: Re: [PATCH v2 3/4] drivers/iommu-debug-pagealloc: Track IOMMU pages
Message-ID: <aSR7U4pI_mYryFzh@willie-the-truck>
References: <20251106163953.1971067-1-smostafa@google.com>
 <20251106163953.1971067-4-smostafa@google.com>
 <aRW6Tf_G2ObR__vE@willie-the-truck>
 <aSRRizzS39jI3BjH@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aSRRizzS39jI3BjH@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E8F0C100016
X-Stat-Signature: 5f8ynknxt64zds6hf733oreifn87ttjs
X-Rspam-User: 
X-HE-Tag: 1763998554-830721
X-HE-Meta: U2FsdGVkX18kx+N8gF60FkjhjMqAv/BBsL8MXp+ygPc3FJ9FjjCN0KydyfqbEymEDNiBRfA+lpticRnmwfJHAWdVsy8yDFEcjhcdV2emf1aVkGhunkVydg4pxUKgr4XXrt45Ng7WrGsC9jjaVO5uzjHB/9yq9du8pNRrOOmvs4cnWAUEoP0UUMCQY0N4LMCvGgmqSuY6KYETFGWxcLJHHy3T6A/Fvg6b7xDSzoad/y/etx91M80PY6H3F6bETVPB1oml5YIFqP1aRqMjdc7UnWuYZv5lPegx0qJFCw9MdvGkSlk3Il3yKTIkrVnvO0AjKGeDHjoMwD5/0gDWrelMGmWlNBoMFR0muhVFgNYsZyRUKj7EL7JzCd1Y8cMkL8oW8ijlQN2EiJQtStayXITzMFDATpCmSuFzccqx7ydpbugfmjjGA/Dzejjs4NbxaztgZr+5OJ3jpkwsTLO774+4pC4Fi2YIsNzNt3Y3XPT403aNHp2HzVntCvraKuqwVoFlCYQOn9w0g4tiJz/xJfGZ2oCP3D/I3dXjogE9Qa4XAOC/2N9SyIVIaTqf6iBEIZUWgUeLaC39XeKqblMrcppdFg1uTr0bt8yJMtzQn/gO2wJeKRkBW2Z29PiJw41gPDv33avLIkokyNxJdGh3xr3v9YuoUb5DAavT7UDbLbn865aH8HOLUx3v7L8tSB5Zc//zrAlJW3J0JvcNcfQKjc3tDpwJWGo+UJBfmKTE+9WT25PF0dAzACobx5Q6lLIc7zR8FsA//PMPU4OKJboMQauuzI/PyUEZZfIp2sejTH40Ao99X5IGVQ3bYpwYEdbXzpgNBibTosbIwMecUPsAhiCs21q/NBJXjKUAO9tRxAahxoL9LtLK9+5fxSGG/P99fQ/vTvLP8WkGAC8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 12:37:31PM +0000, Mostafa Saleh wrote:
> On Thu, Nov 13, 2025 at 11:00:29AM +0000, Will Deacon wrote:
> > On Thu, Nov 06, 2025 at 04:39:52PM +0000, Mostafa Saleh wrote:
> > > Using the new calls, use an atomic refcount to track how many times
> > > a page is mapped in any of the IOMMUs.
> > > 
> > > For unmap we need to use iova_to_phys() to get the physical address
> > > of the pages.
> > > 
> > > We use the smallest supported page size as the granularity of tracking
> > > per domain.
> > > This is important as it possible to map pages and unmap them with
> > > larger sizes (as in map_sg()) cases.
> > > 
> > > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > > Tested-by: Qinxin Xia <xiaqinxin@huawei.com>
> > > ---
> > >  drivers/iommu/iommu-debug-pagealloc.c | 74 +++++++++++++++++++++++++++
> > >  1 file changed, 74 insertions(+)
> > > 
> > > diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
> > > index a6a2f844b09d..0e14104b971c 100644
> > > --- a/drivers/iommu/iommu-debug-pagealloc.c
> > > +++ b/drivers/iommu/iommu-debug-pagealloc.c
> > > @@ -27,16 +27,90 @@ struct page_ext_operations page_iommu_debug_ops = {
> > >  	.need = need_iommu_debug,
> > >  };
> > >  
> > > +static struct page_ext *get_iommu_page_ext(phys_addr_t phys)
> > > +{
> > > +	struct page *page = phys_to_page(phys);
> > > +	struct page_ext *page_ext = page_ext_get(page);
> > > +
> > > +	return page_ext;
> > > +}
> > > +
> > > +static struct iommu_debug_metadate *get_iommu_data(struct page_ext *page_ext)
> > > +{
> > > +	return page_ext_data(page_ext, &page_iommu_debug_ops);
> > > +}
> > > +
> > > +static void iommu_debug_inc_page(phys_addr_t phys)
> > > +{
> > > +	struct page_ext *page_ext = get_iommu_page_ext(phys);
> > > +	struct iommu_debug_metadate *d = get_iommu_data(page_ext);
> > > +
> > > +	WARN_ON(atomic_inc_return(&d->ref) <= 0);
> > 
> > Is it worth dumping some information about the page in addition to the
> > WARN_ON()? That way, you might be able to benefit from other debug
> > options (e.g. PAGE_OWNER) if they are enabled.
> 
> These WARN_ON are for overflows, which should never happen.
> I initially thought about using the refcount_t, but it didn’t seem
> suitable as refcount_add() expects that the refcount is already “1”
> indicating that an object was already created which doesn’t fit
> in the semantics of what this is. Similar for refcount_dec().
> 
> In the next patch there is a WARN_ON for the refcount check
> to capture the mis-behaving context, I will add a debug print with
> the leaked physical address in that case as this is the important one.

I was thinking specifically about calling dump_page_owner().

Will

