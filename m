Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9329109C033
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 16:21:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CEF26B008C; Wed, 25 Mar 2026 12:21:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A6566B0093; Wed, 25 Mar 2026 12:21:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BCAA6B0095; Wed, 25 Mar 2026 12:21:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B4BD6B008C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:21:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DCF941B72AD
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:21:07 +0000 (UTC)
X-FDA: 84585099774.27.C6D514C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id EE304C0017
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:21:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DCx2cd6z;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774455666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=30sEGPYmo4wjL7Oo7ljbsi2DNSmoaKkA5yEONMUty08=;
	b=MGtlsPZLs24E+6+WRgrJMLUd8EoVtagY16mMwXcX+fgr93fCkHaoqsN4cKKBmi2a1YYwTr
	WXxweVwnOVAaV3jekkaZsKvzJNDXQndDaDMgwVzt8muG/eNGlez27mxi4vusEaDMH9N2kj
	L8QaJcF9nYYzG7bF5cGvgfJZ3jquDBM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774455666; a=rsa-sha256;
	cv=none;
	b=1sBEmcnEInJHsacxZo4zmulRbLZXm+gVn65a/y1ikVpT51IyUeSrrY7a7BNQ3XcVIUyw/h
	dobspx9esF3Zp5yETFy3gmpPx5m0ZGp7ifafXw5Jv2WDqxHd3ipey8qrxMaab8KrNt7Bji
	vVBsU2K61rxihzhQ+v9PkvRxU4T0tx8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DCx2cd6z;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CDAD1438E8;
	Wed, 25 Mar 2026 16:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44374C4CEF7;
	Wed, 25 Mar 2026 16:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774455664;
	bh=Mp1C8uMxxYv3PANUHWINKbqxycLFn539lBbC90jp5lM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DCx2cd6zdjs5WTU0Ci34/oFQ5wXmmkfSsnBz8cMDfEve+sYMCeXPhZU1jOQ/lqQ6J
	 K4fkBqOO0AYOHqX8kdOutVBupk+dZ4inVj6O/4xS800zVfx9V5aJBWzRMhP4QeyEj7
	 dFL7a0cGWZMFi7C3k11k5mMb804D14ZLSuN5c4fUUJiZDNW6RSxOstKalegopwBm1F
	 QPS9KU6uR+nSOcUitxRacDeRokQQd62w8D1jSPIPoEV6V4iHwbFPoCuFPZr0PWaKrZ
	 rzICz3Ro0D4xW72Cz4CSSfywCrOmJ1StSpNEjTTlf9N+GbSJT6ISjmIxo9uRhYdXMM
	 4GvoqkIw17B0g==
Date: Wed, 25 Mar 2026 16:20:52 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Tony Luck <tony.luck@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>, 
	Babu Moger <babu.moger@amd.com>, Damien Le Moal <dlemoal@kernel.org>, 
	Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, 
	ntfs3@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/6] mm: add vma_desc_test_all() and use it
Message-ID: <ef1e4362-4922-4857-8211-fca47031b63e@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
 <568c8f8d6a84ff64014f997517cba7a629f7eed6.1772704455.git.ljs@kernel.org>
 <20260324161212.4b0a6f4fd5eb57ff2ffa7ea5@linux-foundation.org>
 <24163ac9-bb0d-402c-a028-d1af7f56caa1@lucifer.local>
 <20260325073054.490f2e9658cbd75312732fbd@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325073054.490f2e9658cbd75312732fbd@linux-foundation.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: 3dpyz6xqc3sdnxu4fxicjak8n9pf3ai3
X-Rspamd-Queue-Id: EE304C0017
X-Rspam-User: 
X-HE-Tag: 1774455665-799069
X-HE-Meta: U2FsdGVkX19Gnbo8y2ef0PIg8rZrNYd0L+ul5+vIfUQNOyvtJksuA8+VYwFFNwUyGhSB+i96agXp7Y7FK7ROM8gm+cTiZAHk869skSGld8xDK9lndtWlDeLRNMTY+xv/EJZgq3ozMAMjqqLAn0UBnI9kF4eIU98QeqPokwb8xjobTgt9pWLCtnmxLnr+Sri7vV8ugxfnHVZf+H9LcJQJIMmQkWzxNmh/63cc/VYkD8utWPXzq6kHVsG+0IlbeGo2Mjlgf8pmiWJpAitrVck3Isxbl0ZMR4ZJQ6N8WgFD0DLAMxHa/H/jRBsEc3pqNaWCIfe1IPTy4MsckaLr+DKVXAFAg8cR32uO34yslfM4vV2OHihhMLGyMafEvr6LuQEp0/rMBNt4NrhcipVAOk98pHkTlWRB4zVqZ0+y0q1EwrNyyJK77zHFDlQNQ9GOG0FphVmOG6D2rEZZWfzfpHH1VOL8mDor07PDPSh/nVn1RBZIC0m9LSbnhFm2nuBTH92gfmQMTDejb5gcqfA4GT+CcqzHUidmQPRbpy7feEUx7eXg8pEYhe8d4zpqJUccNjYqK0xbh0WBI7fyyKrbnMtD4idBuesGNWsSk8F0vVdEEL8YGMYhuBeLKX+zKmC2uCr+PUZrTfgoViLWubC6s8P9VGQvKdw3wLcmWpfPBqDXKl3rD1CQUJPct1LT5PwGAguvEoU/EaJNq13GqZ3knx/0U0v32AjcluITbP6SKAQKV262YO5RRKZ9frBOUU4huTY351LO2tj3CJE2PM0dlWI13nXkKpTJMudAY2p5i4u0QR/DQI0CkN7KGeS2W1Phk/SN+sNq6PR5lat4NIsbP/GGNWRMPgsiNq+LFtlqXF6aOSjDwSFO6Uk3QagiKKzquOi6viJa+EXv0SHCjSCn+BuZL9qwnUvJgycwoJOe1ENV7sU5WjqgfnWvB+ppxjKCq9sXRYgcJfbwarybXCe49bp
 kYTz4Bjb
 861t0Nw4TUCmksflLsRAlwuSSbAwDeiNG+C5INpPolsn37PZi7GBLVDHZZywo3bhoL87+acWXkOuMn0RxINTu1mdiyelJ8uQRxNfxPGkAmhN/mQAMJvRdh9AlfB/hhirj4hWmpBXsSAmP8fJxgZHnjciy3ehSC/mzr0wGTZ85XZuFU/3QrhfLirqapqqVxTxK3TsUsa0TNane+lKaif1Usi7bD6pRkJvdZd3dyqrpILMMRZuEHlE2JRik/TXKDLgjVWwOz/tjA2cKjxQLoFnsP87WeZlOsRnanBnH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 07:30:54AM -0700, Andrew Morton wrote:
> On Wed, 25 Mar 2026 07:08:22 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>
> > On Tue, Mar 24, 2026 at 04:12:12PM -0700, Andrew Morton wrote:
> > > On Thu,  5 Mar 2026 10:50:15 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
> > >
> > > > erofs and zonefs are using vma_desc_test_any() twice to check whether all
> > > > of VMA_SHARED_BIT and VMA_MAYWRITE_BIT are set, this is silly, so add
> > > > vma_desc_test_all() to test all flags and update erofs and zonefs to use
> > > > it.
> > > >
> > > > While we're here, update the helper function comments to be more
> > > > consistent.
> > > >
> > > > Also add the same to the VMA test headers.
> > >
> > > fwiw, we have no review tags on this one.
> >
> > Based on the discussion we had about this previously I was under the impression
> > if submitted by a maintainer that wasn't required?
>
> Well, it's a gray area.  Obviously it's better if people's stuff is
> checked by co-maintainers or by others.

OK that contradicts the previous conversation we had where you had to
convince me that this was ok (which I ended up agreeing with), rather than
being a grey area.

We had quite a long conversation about maintainers are in a trusted role so
a co-maintainer would have called it out it was wrong and etc.

But sure it'd be nice to get review, obviously I agree with that.

>
> I'm not inclined to make a fuss about it though (hence "fwiw").  Quite
> a lot of unreviewed maintainer-authored material ends up going upstream
> and I don't think that's causing much harm.

I think you need to be a lot clearer in communicating these things while
the process remains undocumented.

In this case for instance, I took that to mean that you required review,
the 'fwiw' doesn't really make it clear that this was optional, especially
given this patch is so trivial.

>
> In a lot of cases this is pretty much unavoidable because the patch
> comes from a sole maintainer (SJ, Sergey, Ulad, Liam come to mind).
> But when the author has co-maintainers, perhaps those people could step
> up.

Right.

>
> > I'll nag people, but I'm a bit surprised if this is why you haven't moved this
> > to mm-stable, given how trivially obviously correct this patch is.
>
> https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/pc/devel-series
> shows my expected merging order.  It looks like this one will be in the
> next batch ->mm-stable.
>

I'll definietly need some decoding of that to understand where each batch
is?

To me it reads as a bunch of inscrutible #'s and file names...

Thanks, Lorenzo

