Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C3FEFEA814
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 07:08:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B2296B0005; Wed, 25 Mar 2026 03:08:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85BD26B0089; Wed, 25 Mar 2026 03:08:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 771C36B008A; Wed, 25 Mar 2026 03:08:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 653B06B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:08:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2092716077C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:08:37 +0000 (UTC)
X-FDA: 84583707474.13.A359BB7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8A1CE18000B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:08:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U+fi7yjA;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774422515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zampRoceqgBsThYjPx33YjovWL9STWRQLqywI/2s0FQ=;
	b=aScdzP2yCRhV9c6xaB0Bs3wdbQ/leQfnNzFli73bRthmNIpBFcgh+oRvu03jTAqiKT9YUU
	k5uKPr2B8yRiQqqTEo0XWVJMGw85v/wCX6NgoArL2aJz15thZpLJqXlLmZFuuG3l/a8sDx
	fHDE2bauCoZpXE6aNowCwAqX9hXBvFo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774422515; a=rsa-sha256;
	cv=none;
	b=yi8cf+MaXNWbYPtcPSMrPPQqZRxetR9p2hOSVWxcDppkEwJcOPBOkM7EmP9b1LVy/lr4rj
	uP1lr1tn3kYO+/23tZ/zXD9tCWa9ztY0hLPZ8eMdrkFeszgBOzxP8o57DIPAcG/x6KfNsC
	smpjL9uW5CVZmawjDU20JCareSxeOMk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U+fi7yjA;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 51CB341789;
	Wed, 25 Mar 2026 07:08:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C979DC2BC9E;
	Wed, 25 Mar 2026 07:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774422514;
	bh=wloUbny5iGf241ZcwoWfGI1G4epwXCE04slEJFNkwPc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U+fi7yjAY4ZcZaA8Wmq+9ofwJ01X6R5BUulVmOdBiUMiJNXdz/KWVyrUVBvzgPCdG
	 2iIJ4CGzZ7IBbErqBjmBCXGf1CFvx3+fKZ147WGar3VzjtyTzRvfbEBNSup+q0+J7b
	 aPb6Ft2C7ojmFs8B8ou4LrMK94BCHWXKBqtTOB/U0rh+I+z+hMFm7l2vh+tpqjhKHZ
	 E1o19EK9/Tp01KDDdBMfljviCTxMfaIATpKElMbeNcU09W7rcU882ncXoUehokpWFR
	 /05zR6R0eEOzCsZDKcOave4LUSm3OuHObd65uQKuOZ1OkoMCXMj2iTdIe1ov7xt5cF
	 KwF5Hpr6IdeEQ==
Date: Wed, 25 Mar 2026 07:08:22 +0000
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
Message-ID: <24163ac9-bb0d-402c-a028-d1af7f56caa1@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
 <568c8f8d6a84ff64014f997517cba7a629f7eed6.1772704455.git.ljs@kernel.org>
 <20260324161212.4b0a6f4fd5eb57ff2ffa7ea5@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324161212.4b0a6f4fd5eb57ff2ffa7ea5@linux-foundation.org>
X-Rspamd-Queue-Id: 8A1CE18000B
X-Stat-Signature: 4d6msromkwjx7ox4mrc59ze7tsm1rt4j
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774422515-202638
X-HE-Meta: U2FsdGVkX1+LjcD/q79oGYFlmohrtaCb4v7OAbPhzuLobeSfpX7AKbLLIMV/xPlNeLLL39Ru91+OZo+4PVKzaKyTLWDiXNJ7mEAqhpo0R92Z+SomyQAAfaKtUbhlY7+7SDjPu7AWr+KDNIBP4uxCDeHljFt/RLYBO5RkWoFBh8wr3IG3u0DFnhEA88ITmm9E0YUWwA39gEixvW9DjQGrUMI5n8Eukzj93c/Hp7QC4tHcENWxkW1+H8ZY3iJL4uZVyuKry5cpgpFQEZmwZHW0R3/GXnhm8EYELG+WgIi8KHZgyJw61Z7Thz5r1bhm9ncCAFNNwufLGbSan1NQE9A9wpKbgaUhs8XerUBwhEI1cwX/Q3L+1KPbI+SvgoRxzw7Idy50PFGFWZtkqkUClQu6Je21v8y2jfKStp7P+x6iGmuiCq1AMmW5RT63MBgEh7O0mU3Jz4JQ0214HV5JjITPiVqem06p35bN6UJVgliPXU/kSPDw4GyScl38kPnymUo7XKn5KF1wRGRPm/FmU6S0hEwE3hkGdadwHeNmFbah+4lcvLC3ECPFlCPzC3CUSnzOBgP0JSW2EK/6MPp9pYvshq9phvvS4wqq3WrUWuqfMNv1po4DeJAMlJFg7/Ub5krc1yjCaHRQhit9oU6dH1AU3ixa+6clzOmrAH2fkDetXabMTW11cHd4elc13KcuobIOPQ3ZzbbMadg70MWGrEL1tAJFz1w5b/++iitGHmhfb03jcq3tnF7rsARi+nxI/YmkvAiYLfN790icUpnf2uHhNw0PxlyTk2av0HEer79bqUR7b2GccD2Cc+WMP+SZ2JpxWc82xWmf/uDXQxoat3Fo3PZS+SeokDFDPCdi1X6hX4hsOjscOCBrhtborOXoeBn0ISV2PRyt5G7LWS1YK/JIBvkJIMRyl+G+cdrmxYaSikPz/6V9zoW09g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 04:12:12PM -0700, Andrew Morton wrote:
> On Thu,  5 Mar 2026 10:50:15 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>
> > erofs and zonefs are using vma_desc_test_any() twice to check whether all
> > of VMA_SHARED_BIT and VMA_MAYWRITE_BIT are set, this is silly, so add
> > vma_desc_test_all() to test all flags and update erofs and zonefs to use
> > it.
> >
> > While we're here, update the helper function comments to be more
> > consistent.
> >
> > Also add the same to the VMA test headers.
>
> fwiw, we have no review tags on this one.

Based on the discussion we had about this previously I was under the impression
if submitted by a maintainer that wasn't required?

I'll nag people, but I'm a bit surprised if this is why you haven't moved this
to mm-stable, given how trivially obviously correct this patch is.

Lorenzo

