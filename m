Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93B88CAC5A5
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 09:05:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB8DA8E0092; Fri, 19 Sep 2025 05:05:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8E988E0008; Fri, 19 Sep 2025 05:05:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCBD48E0092; Fri, 19 Sep 2025 05:05:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C92B08E0008
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 05:05:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 87E041405C9
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 09:05:19 +0000 (UTC)
X-FDA: 83905415958.22.DB997A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id D825740005
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 09:05:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eEQfYBVF;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758272718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RUf71cFi2PY0swI8S/8sWN8fly908J0k+DY/C6jj570=;
	b=wBW8hGcnR1ZOD6wrk7o00wnoh6Cryv+UMpVx38eHUGL3CT725ueDLdplwi/Z3o08i55cC3
	xiAXN45Qj38LT4bQ+kJIHLAmbyaTtwsgldeLxAAUykUM067UD3V4EpTkPxYn5TXL+h+KdH
	MJJlxUam38+f6qFfSNl4PL6yFLgSOaU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eEQfYBVF;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758272718; a=rsa-sha256;
	cv=none;
	b=PPT6NoI/yPvqzP0ehbfjtezavWifanwzqXmICihni4aHUdXKe2zULyjbXH2ggMOTVDSIS+
	tf/Ah7f9iZ9xCh4jyPVGzxgV974K/oYvsPK3IORtAg2rAjexhKHHTiwZeW8niVOynIjBR+
	cBME/EmZH/sixrZYl2g6ci3tE2mf1y0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D770449F4;
	Fri, 19 Sep 2025 09:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31ED8C4CEF0;
	Fri, 19 Sep 2025 09:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758272716;
	bh=zJ0SjfgXXTUUnk4huOKfaCwNac4EUk7FP0wHBE8bpMY=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=eEQfYBVFHz8m3XUwc47GQ8nRASXr13i6epRajw7PQnSfSQkAevDpXLmGSN0jbAuK/
	 1IKCyy8Soxwtnn9LSoy97u5JXEiq5bL1JvvzgqoEE8lpvMcAdk8LS8bNdaDLELEzA5
	 sd09AODeRewtQ4s5iljD9BaafvExaTJjoIXjIvPTRTjzyGPvLbRwKgLBBHzPuxUr3W
	 8TFy2c1e+sIgARhqlJfzfKH2/x2SSLpfzMaYNyuTVr6kwJp7AbYaAPcfbGVPTpSiHQ
	 Ti+p2P4f4MeID2Rr5tcNVKLIrOArhcXZsmasCTLVwkos6RaxTvdu6kUjeM57eZmC6/
	 IzTj7GQ71WQVw==
Date: Fri, 19 Sep 2025 12:05:06 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
	Muchun Song <muchun.song@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>
Subject: Re: [PATCH v2 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <aM0cwg1GcXUY31wj@kernel.org>
References: <aGfsaIIzHWfjcNFd@x1.local>
 <e7vr62s73dftijeveyg6lfgivctijz4qcar3teswjbuv6gog3k@4sbpuj35nbbh>
 <930d8830-3d5d-496d-80d8-b716ea6446bb@amazon.com>
 <jxekhkhbn7uk23oe24svxrs3vfuhseae57sqagndqgh2e7h33o@kfkygmrvjb5n>
 <aMp-kW3OLqtZs8sh@kernel.org>
 <du5pzxmfk6lile3ykpaloylwz4eni6disj2oe25eq6ipzqemiw@ybcouflfnlev>
 <aMvEu9m7fJLnj862@kernel.org>
 <4czztpp7emy7gnigoa7aap2expmlnrpvhugko7q4ycfj2ikuck@v6aq7tzr6yeq>
 <aMxJ3inEs_RRyqen@kernel.org>
 <2rkvuudmsf5tv66wya4f7m5niwnodu42owzmro5jzyc4fcep5n@lre7hir4qjli>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2rkvuudmsf5tv66wya4f7m5niwnodu42owzmro5jzyc4fcep5n@lre7hir4qjli>
X-Rspamd-Queue-Id: D825740005
X-Rspamd-Server: rspam05
X-Stat-Signature: bmeo5wije7k8km5qmhsb6ihixjm67xh7
X-Rspam-User: 
X-HE-Tag: 1758272717-549706
X-HE-Meta: U2FsdGVkX19TCDH/eCsS/y24ZakANmEi6RU69OYPNwAJkPOPsBukH6gRFrXoiFshdLjGQBloZgdynjfl8hg/MTot2vF2rIecmtZrWcLyp9IwYvuAkPsvd2WdNeE6E+3thGF58k2v4tkGs8DqJHLRWiObxDmXGOCAjtEVSdmybzeYfZgF6S53VlXkaVeEVTvGnly4tNuEOs1ZV58pZm9D8wZte3PJJOEoYTSK8DH19omJgBjHQJzSO9yeIEB7IPexyFPKaIE3sVFdJM8McVjs3GjPFM3gBF5j4P3sDXjjpw2RJS5RO8dB+Ruagk7FK2CHT1bykt2vqWeR2oB0WjSLA3JMrN+Vf9CZw7n3FxXlejtTc83qj04h1I3hKYp0MIv0NmGK8k7Vh2fElytQm4AA7HQbkRGpW8LwFK3t21hhxnqxsvaB7P/9Oalbrtp2llhmEWjtkqFEbhSouZW4IAT7TMdpAGrqmpjoZnhtDtWyxLmlP5+gy5WCghmteCiOVoAzo5lylascMhXZqsDNyqc6dWcI/HlKoi8/DqnTRFzLctmdFZmC9kcPJCYcWErw04CQqvnP9VnZJrC8inJ7r3p/j0Lzfca4/msxWuleivbUrEcsd7CwB6DZuFZD/p31L2iVu0wAe54ThhY0A6/IRumE6OAAE2sAB0NlWoKxY50sBpjuj2L0Lk3+Q6OVOY/jUszp2O35/EC4oemYg8n2/f5P4T1LEYipO8IGE62BxLowus/vla1kIz8ck554eZorgza2Kln8r+vrnemw9zZcYLhxmia/r8iPTH2+2eDtTK6vS0CPlAZeQpsvaH9R+MUjeXfLgs3GPdd+fawZ0d8Gg+bZ+9e4uSndPfH8SucQx284AyWpMMhU3IVOBq/WsWnBwVnooUn8upbPPxyq5vDf408a9JMWFw9VX4r9qtS+W+Wg/uRiX7TE+oS7fm2duIliHbV46G3VvXK/H/BXNuFV5hP
 eMSB2DAs
 Z/TjuVTUTp0Q7PWzJ3uxPHWQO1eFySfPn/1iozwsAMHaRyHYHWdJbS/HhqWuTdPdxegYeB16ANaPluhoHTR6ZJDHk/agjKX0bR+EaDhPlGbRg2tKz6MPWj9TdBEhQb7IAnQh2oTyfMfnfvL7s3CfIQjmn5rmfB8LXTS8ctUd6NFBw4EIUI7jnWQdODtQQM/2eXBx+7gXyJ4XAdMW67XojNClc1Dh7ApSZfgjqrGarU5gKwpeZ1LvJGLwvVFRn95NcuRlYXdy1YpL2EG1yClKuZ3tJVrug1Df6dmR6tlB/Ax0jUr1cC1708md3/MUMKuDjMBHhTS+h4kM4mb0uDiSuIIrr1qB2K8j5NBOiO9nRLAlT8umCu00oathfb/b1NEmAiAAJ46oEGlSkbj4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 02:32:31PM -0400, Liam R. Howlett wrote:
> * Mike Rapoport <rppt@kernel.org> [250918 14:05]:
> 
> ...
> 
> >  
> > > I am under the impression that we don't need to return the folio, but
> > > may need to do work on it.  That is, we can give the mm side what it
> > > needs to call the related memory type functions to service the request.
> > > 
> > > For example, one could pass in the inode, pgoff, and memory type and the
> > > mm code could then call the fault handler for that memory type?
> > 
> > How calling the fault handler differs conceptually from calling
> > uffd_get_folio?
> > If you take a look at UFFD_CONTINUE for shmem, this is pretty much what's
> > happening. uffd side finds inode and pgoff and calls to a shmem_get_folio()
> > that's very much similar to shmem->fault().
> 
> I believe the location of the code that handles the folio.  One would
> decouple the folio processing from the mm while the other would decouple
> which processing of the folio is done within the mm.
> 
> Does that make sense?

No :)

In short, uffd_get_folio() is a special case of ->fault().

tl;dr version is that the whole processing is page fault handling with a
brief excursion to userspace. For VMAs registered with uffd, page faults
are intercepted by uffd and delivered as events to userpsace. There are
several ways for userspace to resolve a page fault, in this case we are
talking about UFFD_CONTINUE. Its semantics is similar to a minor fault - if
the faulted folio is already in the page cache of the address space backing
the VMA, it is mapped into the page table. If the folio is not in the page
cache uffd returns -EFAULT.

So the processing of the folio that uffd_get_folio() is exactly what
->fault() would do for a folio found in the page cache of inode backing the
VMA. And unlike ->fault(), uffd_get_folio() should not allocate a new folio
if its not in the page cache.

-- 
Sincerely yours,
Mike.

