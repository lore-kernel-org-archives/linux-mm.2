Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23547F4BB89
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 20:35:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BB836B0005; Tue, 24 Feb 2026 15:35:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 568F06B0089; Tue, 24 Feb 2026 15:35:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4750A6B008A; Tue, 24 Feb 2026 15:35:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2FB316B0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:35:30 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C19BC5840F
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 20:35:29 +0000 (UTC)
X-FDA: 84480505578.16.5161237
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1AEE0C000D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 20:35:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cJHGIB8u;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771965328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oMfNQs9XWcxJdxso94OJvmzfCntG37MG7B+TlbOTdos=;
	b=VxUTTkQy1BIzqBmR9oXpb2eIB8WovNGKI0CApvtbVPSdRSXB+hcIa+Q/IW7HD3dkdK8JPa
	nlIiZEUMcWaCIrjZW0lo0wvAv2CFaZsdPt8mmTqTkaiYVc6unYAeLysp7PJ71EgoplEz+T
	a6F5jw2XPF7kYxs48SMJRBKcnMbn+A0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771965328; a=rsa-sha256;
	cv=none;
	b=HYF1w/6C863yNU/iFswEoHLwVUbJCsG538TTaIoQsa5P+IU7BWI0AOQA+wDLxNvVGE66G8
	6aVKTs40obwfeSIH00190fzb89lANtfDgDXaUEf8yMzCrd2/q5lovuAntLV9UK0pM0Otfg
	e6C8TbVCzr4Joo/rKP740trelWIiVt8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cJHGIB8u;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oMfNQs9XWcxJdxso94OJvmzfCntG37MG7B+TlbOTdos=; b=cJHGIB8upWwZodb+b1Ps+0MMA3
	FEYWN/wdYtcBYdCs2D8uboo55qvmAbhENbKh8kx0mEawol2oA8u2AyV9cHCxUwPfbOs970gYSzFpB
	QN7VXLQT7J/bAs9wM/l8eu1s6AV6vOdWwNVZRr/IJm+zdcdXFDXXKsyRpHt+/G5uSOhU0+lTFci7I
	LdYEjTf/KHHLrBY7bIsDkrIK95+rbilLrOI3a2aG96FWHnLT7I7Ze79tqMLEBcNlGVNG9D4cOzr8k
	B6j65TFv5N4xNTFwbZu8KVKafA2OkPIucPRSywM0LsA4gBfmCn6p+ebeLCzIT5axxiwINfhOeI3Jr
	YZeuXwIQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vuz7j-0000000HSDx-1jXK;
	Tue, 24 Feb 2026 20:35:15 +0000
Date: Tue, 24 Feb 2026 20:35:15 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Usama Arif <usama.arif@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org,
	riel@surriel.com, Shakeel Butt <shakeel.butt@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>, Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Vlastimil Babka <vbabka@suse.cz>, Lance Yang <lance.yang@linux.dev>,
	Frank van der Linden <fvdl@google.com>
Subject: Re: [LSF/MM/BPF TOPIC] Beyond 2MB: Why Terabyte-Scale Machines Need
 1GB Transparent Huge Pages
Message-ID: <aZ4Lg51BVmGE5MLn@casper.infradead.org>
References: <540c5c13-9cfb-44ea-b18f-8e4abff30a01@linux.dev>
 <aZ318PoxdAZjqnLX@cmpxchg.org>
 <42CCC4AB-EE32-4279-BB50-EE72756B5137@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42CCC4AB-EE32-4279-BB50-EE72756B5137@nvidia.com>
X-Rspamd-Server: rspam09
X-Stat-Signature: uijbedkzrjzzjs17s4reje44cgupgzqk
X-Rspamd-Queue-Id: 1AEE0C000D
X-Rspam-User: 
X-HE-Tag: 1771965326-160078
X-HE-Meta: U2FsdGVkX1+UkHZbmByqcdPlTRJdjD6pv8dALsh5w2V/P5R/IPUf1a4YQ1FiuS44JSsdm4p6pMjpqxYiqlynJNzTpCnKOf2NVbL1+fI3grixMwSy99mrnrtN8AzEFSwQmqZQDYW45ioXfIldQvUbXOmYSL8MubHVMnq9KthSeP4zhfFTt1gnlKAeu7ZMVlrwv3WXGbBlAt8dtGCoMT2v7XmYbU9qYNa3UgQ0n/xHdCzWuT9NaK0eLkkhrAvEJcUwCtzfZfTxxkNz91ZIRkgLQ3TMNVB4i977OcGMB1wZ6JayxGW/bcyl+q/UHXuLbaUCzPuu90K/9KjWasQaMwWB8fhFXQnfx/zLyUhxgfnuFcSScY7RJh3A8fwupiLi8UBkWRX/xhnSk1XMeEZ0xcXlgnwctHuAD49x++BPUW45yel9zPeqM+iuASuKgsAYFoeQ72brwi3Lcj7Htt5Z6d2epZaLD58i+bNyi8VXy/YCm3d8vN6tFGez4xZ17xWr4YWamLLx5YvtwZZz2KFhXtmNkMSPMoi3GEPQTHZFqfazcvQTcIUeH18cNw27Y5qpWFJ/2rsWsxM582g4EnFfesLXIiRcRtbNTPdQ5SWmrH8Gaqt1ipcTz2hAkP3RQhkwMJwfwrcT0XIjkEZJd7u5lqBiJGV8wpIDXYjKCfLvj+Ki1Utji7qy9U4dFZ6qvaa64LXmTs2of47LBjb2ry91APg9BK87q4LZahLOhQchAGi98nA+DUI/s1EGKyhbNQ9+z6mzu+q2zzuXSHLL1yYr/F3G+RJt4xC7N9kuxiZivfbVFw8YQu4BvJbvCpGGi7h+48IRU6a3vtMk2AddFVABj9A4y+pjBV0kyXiLTUqx8KN3cd3bj69WKd6dSeWfzyXuSE4SBVZQfyiJH/zXoknT+AFx+djxi3TzsbVqsSUkBikcRazttaeofXCqqmGqpoK6mh8lzGeW5FgAkRXn1jT0kD5
 lie7H3rY
 qrCr4b4au+D6oXiQ9WPrCiZADT6wGPNtOGYswblQ5PYbcz3q1tAKwKyxjcLx6TGUkFZTSNzJJh8mvcNHByWoe9/T/Sfc0jNH0X9PmIPbvcFyIiR1UvdmbO+aJUW377/txOS1xJdFQD+rOceFtHo+5qg6kPMEcG4ho/iKGgRdFd/EXOJlbw+oNjxyW9uZipZ/IPuN6k+J1xFTWiB8QalkNFgF/Tw9nQI/S3IA0DnhAGcqc9n3LiE423MvXGZzQ2QARiNmF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 02:08:26PM -0500, Zi Yan wrote:
> On 24 Feb 2026, at 14:03, Johannes Weiner wrote:
> > On Thu, Feb 19, 2026 at 03:53:35PM +0000, Usama Arif wrote:
> >> Why 1G THP over hugetlbfs?
> >> ==========================
> >
> > I know this isn't your intention, but one interesting aspect of
> > supporting PUD mapped folios natively is that it could open the door
> > to simplifying hugetlb as well.
> >
> > We currently have all kinds of huge_vma checks scattered over the page
> > table code, and entirely parallel paths for unmapping etc. With native
> > PUD mappings, this could allow pushing the special casing out of the
> > virtual memory layer and into where we deal with the page objects.
> >
> > You might be able to take it as far as the only thing left of hugetlb
> > is the reservation pool. Such that a naive application does mmap() as
> > per usual, and it comes down to a separate allocation policy how the
> > backing pages are served (buddy, CMA, boot-time reservations, ...)
> >
> > Approaching it this way could help separate out the discussion on code
> > impact and tech debt of PUD mappings, from the allocation technique
> > question, which in itself is a fairly large topic.
> 
> I agree with this 100%. Adding 1GB folio support first, we then can think
> about what other THP features, e.g., split, migration, PMD/PTE mapping, are
> really needed and add them one by one. It is also going to be a good way
> of retiring hugetlb special code.

But this hasn't happened yet for PMD-sized hugetlb, and there's no need
to wait for PUD-sized THP to start this process.  I don't think that
introducing PUD-sized THP will actually motivate anyone to do this work.

I think we have four main things that hugetlb still offers:

 - Reserved pool (mentioned above) which we don't yet have a THP
   replacement for
 - shared page tables.  mshare() is the replacement here, and that
   project is moving along nicely.
 - Being able to allocate gigantic folios.  This is also progressing.
 - Guaranteeing that you don't get a fallback; you either get memory in
   the size you asked for, or you fail.

Every time this comes up, I offer the pagewalk code as an egregious
example of where we force every user to know "oh, hugetlb is special".
Getting rid of mm_walk_ops->hugetlb_entry() would be a great improvement.

People always look at the fault handler first and say "Ah, this is
an obvious hugetlb-is-special case I can get rid of", but honestly
it's not that painful to keep around and doesn't affect anyone else.
mm_walk_ops affects everybody who walks page tables.

