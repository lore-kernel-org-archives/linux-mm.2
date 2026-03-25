Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE388FEC11B
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 11:02:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA0926B0005; Wed, 25 Mar 2026 07:02:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C51FF6B0089; Wed, 25 Mar 2026 07:02:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B674C6B008A; Wed, 25 Mar 2026 07:02:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A60456B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:02:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5607FE0C27
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:02:36 +0000 (UTC)
X-FDA: 84584297112.27.D9AF0F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id B19414000A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:02:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JKfbEpL+;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774436554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tHxS02jyuJdc7xck1OGm67X7JRYetEgUpHsHG3XgLZs=;
	b=SlKWl4lZdXZOv0Ah3vrLsatR+XeAgy4fFICvQu6Kkfrp7klWT+AgxX58tEmWM6iAjXh4FE
	ZHiAOZJ8x2YKeNXqBzpjTwmJUXDlL9fIV/9gFHK2pBi547oLgF1rO/V46cRFIgRzEMfie2
	Gf384otJecZ4F/Rmeql6iwMTUEypkqA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774436554; a=rsa-sha256;
	cv=none;
	b=Nm/8v8JtxTB/WcneUUTR+wmRktXWB6E5mPLS9p6i+BA9czcKZ1kXZulmclmnQT45ck7WlK
	P0BDgsOiFSSSWpCY2kBZlJ4+k0RQq11J/irIug496fq2A7mIFv45qkNWYwXzMFLEH9c7Ys
	oewbgqfN4k0UIrBYEOXeJ6SHblREaGc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JKfbEpL+;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 10F13600AC;
	Wed, 25 Mar 2026 11:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A3EC2BCB0;
	Wed, 25 Mar 2026 11:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774436553;
	bh=tHxS02jyuJdc7xck1OGm67X7JRYetEgUpHsHG3XgLZs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JKfbEpL+QwqITDp7zft06nKiR08zsFI8szKsw2URrZAwiwXqMmi0+tBx1TGvpubXE
	 l1nTkzHyAQbNEBGfQ4nGrX3sKCiFHLJaYrjm5zqZQQQEwtQa6RkpNjHFptlR4PAZ9U
	 IpJ5JeE+RAZ2E9J1YM6Elt355aSIZj/LzRVBQ1/n1qqoMs/OD0sRpg05BMFqsbhi1S
	 Shw3TorVIm0rtJXQ5yVWpZX5z65od1QSnOK7gT/YAbbvBwHnt++ki1xhQcLDAMvu/F
	 g11ayMJaLiBZ/F7XKSiKEpI8doQgK5UkRrJQpjVo/DBAKu4Y4jcyhpVjyAsHbayxPG
	 UmZoSLixBLjOg==
Date: Wed, 25 Mar 2026 11:02:21 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, 
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, 
	ntfs3@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/6] mm: add vma_desc_test_all() and use it
Message-ID: <887da31d-96d0-493f-a248-28ae82925c4d@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
 <568c8f8d6a84ff64014f997517cba7a629f7eed6.1772704455.git.ljs@kernel.org>
 <d0111a86-7fc9-4e2f-b652-9ecbb894ada5@kernel.org>
 <9203050e-eda6-49a1-97b6-a134da2da313@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9203050e-eda6-49a1-97b6-a134da2da313@kernel.org>
X-Rspamd-Queue-Id: B19414000A
X-Stat-Signature: o94tqxy7x5secy8njap4rb57mam7yfbc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774436554-907003
X-HE-Meta: U2FsdGVkX19Da1/WlGXwJk6wzbZbbhU5PYHKKhyMWxKLcoz0IJTrDwmB/vLocQAUngOq5d2GjE5UkOD1PbWU4xKFWTlLwWMgmNxk08gz5ZMYKQphGyDh+5tRGuMV+I3K08O3O3MHWZSsQLnr7194XU5Q8gZ8Du+oApBk2gVkSW04I/CdC59be093hUt0+rC+Wxmi8CldG6HahQEr0lsXYVbBhglrAdPpSgjCWRAsappYHr5wLiDDbQVHFLuyyKUhr3SGgNnqbkpDIZO6z3BvV3iQxwjsN9kX8wgZX43lkycxjAfbwT0RXsD6OCkfJmgBejotKSv1DulMb/voXq5N97AWrapuLdigL0QMJh0WCM5TuH2lFastKO8AyGvE7bWYNHd1W+vGPjAPw9bXkhmqsizZUip6lXfu3vjWxiCSjeQ9hN/VQxjSoR6pXFTSfUE/Y7+Ew784bYXE1WNxtScI9p3TWshIRWg6vRj3HhLek1sg4oaFaHtWeZ3b/wUIAUD/pUfn36Brxni+tBIj5C+7VrpVHHgULChZjLD3o29kP36fkLTDXuD2I5NXmYpv0yR0dMikp0fvgRjRhJgohub+33jA5mNboXO5CPohPhUAfNSogc5hiUZEf5EgOVNQ9gPcoQKz829BxdFiNT24DqgQkYUS9jwQQ+RD3VgTqr24XC0zrqatJIU4/UifNhZx9e+EqyQZNxsgCzlSRnuNhNBjGvfmbFhXnheQocgnLGGDCYNffOHd5w7mGRVAYLkpR0cZEQR9puTxIUNoXosK/aWxThnONzNABzVXEVCRMEru77WlJDlDWtXxsgn6EsHvCah/hXc/B06XEmmXllHpcEjg29OM0wrT7bQ1OCbE35KKQ5RRcdeW9bNe4PKDPCvMcNOL0Mx+BgyicArJayRtROLekfmvkXVf3qj8sQZOCowjrxpAlkOAWt1tn5IMv5cqAXF6xPI3tYA1M1+ePfF4rer
 5sHtkpSQ
 YGPRHR515dXYLqgKeYezOLV/ic4DFpBUfQBeEF8O3ZT6wCyYJ1l1s0VRkJZObAg9Lk+v1ag5et37mt8Tbbx2AeSaJVaRc6/xPicRjYztOtTATcSEEnkBehkQ5iSwPzsbPq4P+LHnfi09WLmRVb6Xp1zmCOovBibbXqobLbxYaTEhD4qVbBmgr16FsK12zirfXrli3PAIIx9oXelPOBRD35g3hTCxy2TlEdOVbEG63I2WBolDzUtkA37nvGUpg8hdsJ0ixoai4jytFQP7sS6ACFokHggFlianDiEUz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 09:58:53AM +0100, David Hildenbrand (Arm) wrote:
> On 3/25/26 08:31, Vlastimil Babka (SUSE) wrote:
> > On 3/5/26 11:50, Lorenzo Stoakes (Oracle) wrote:
> >> erofs and zonefs are using vma_desc_test_any() twice to check whether all
> >> of VMA_SHARED_BIT and VMA_MAYWRITE_BIT are set, this is silly, so add
> >> vma_desc_test_all() to test all flags and update erofs and zonefs to use
> >> it.
> >>
> >> While we're here, update the helper function comments to be more
> >> consistent.
> >>
> >> Also add the same to the VMA test headers.
> >>
> >> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> >
> > I thought I saw David review all of the series and so focused on other
> > stuff, didn't notice he skipped this one :)
>
> I think I skipped it because it looked too mechanical when scanning and
> I was like "ofc I trust Lorenzo on that one blindly". So I missed to reply.
>
> Tag provided now if it helps.

Thanks guys! Appreciated.

