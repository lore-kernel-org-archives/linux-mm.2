Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 977A8CD5BC9
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 01:11:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58B276B0005; Mon, 25 May 2026 21:11:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EDBB6B008A; Mon, 25 May 2026 21:11:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 404026B008C; Mon, 25 May 2026 21:11:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2DE896B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 21:11:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 556DCC111C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 01:11:00 +0000 (UTC)
X-FDA: 84807791880.09.4C22F1D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id A1C79180004
	for <linux-mm@kvack.org>; Tue, 26 May 2026 01:10:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Enn6fEbc;
	spf=pass (imf06.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779757858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8KtudcOxSvos7Bvf3DlHhV6S99t3w2rpbU5P7FcY4Jw=;
	b=wipQpsN3md7+jTKVgPboJwc1DKvdtKpDzPC241mhnfzmvvKm81xJ8c72D49XnsLSXdyeyd
	fkVmQVbnU/MbZe7YIaVoN+ARQbPzui4VaexBRs3jABPCI0dNuHjmSb6R0UhmNhZMtbEPg0
	EvhKLnhaee7DHww5JNnvkg6jttgpNFU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Enn6fEbc;
	spf=pass (imf06.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779757858; a=rsa-sha256;
	cv=none;
	b=ftbowIQ2Bnm7sd7GMhrXuP+HqiUhTLPnQKCcxxYl+5pGxVXRqWqANUuilKXueSWZ9bCvlb
	hmagA9/DDKJwXqe8thihKI9tI+kuLPJe1HlOi949MBFXW5qeB9o4BPWCHZvztxHg7jQ+eG
	SJKzlfFldnRQ0WHAMdWH1zQ/NnsGh1k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C6E860018;
	Tue, 26 May 2026 01:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 419911F000E9;
	Tue, 26 May 2026 01:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779757857;
	bh=8KtudcOxSvos7Bvf3DlHhV6S99t3w2rpbU5P7FcY4Jw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Enn6fEbcSDYSLXXU9tuWmlYyKtLN+m2e8UwpPc1rsxAkE97pNhQWlXAlduixrrUvG
	 3ZC+aOj9ajbuiWwQCPTKTYKGniF3t9Ave/L2cdwzGXNAGPNpdD9OuUTjXfbFF9lTKv
	 g37n63c+EP4zjliQGNiT3PRs6vQCBQ8ZR4SHrEgM3L4SPqOwqqUZEU7SVdV/gs8lgw
	 bE9hlCwY1arV6U2meLFVbJfTJ2d4rnP/iSWG0X+KiBKesXuisLqvA+kO4I24PKTDaz
	 eGSh4pdemHuXq0YDzI24c5MWF/tl6dUHgpSvJwhk7riCVLSAQiN73YrX/1JQFmbdhN
	 9FrMkNaCjY2GA==
Date: Tue, 26 May 2026 01:10:55 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahTzHyHBL8t0iNBR@google.com>
References: <adhPZxtbZxgU-37v@google.com>
 <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag_OVwPF49LSZ7rz@google.com>
 <20260522141115.GA8258@macsyma-wired.lan>
 <ahCNmWbcd_2lAJyk@google.com>
 <20260522224108.GA18663@macsyma-wired.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260522224108.GA18663@macsyma-wired.lan>
X-Stat-Signature: rynj3u9a5xzs1dm3xjer3razgq7igq9o
X-Rspamd-Queue-Id: A1C79180004
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779757858-732739
X-HE-Meta: U2FsdGVkX1+asn25S0JuXE/BGJBkKHdxfMSx1t2l+eR/B3KvDLccLIX49nMvESoCX14YufmwOANN2N1ulJ244Hb28FnMC5PUTRmM3moK4kgD+cJKj6AoWmSpJe7He9EbXqFtd11dsd09nOZLmmeEYICSSQPX1dbK6XlRfSRvnfsXmSShd65WRUEaYDh8sZWQUe5WGwUASPxRRKSjFx15c3+m8NDi0DFO5lfKkWmp2F5m7U+1WHcTNm4rA/cqJpmZxShf5rfkCIpFr+OR00ugrUyWOl2pqqRPm6ePhmBiEDb3iDql5Si9IYPfVyBpFM2f8KzV/49VPpPsrwoz2YostwmrkIoXRm0WLhaTTXq22G2csrEkjUffAHZs40D4r2rbKIrPfa6crT/g+rQpKpsCiF4jcDcu8RJzqF6otX0N56n3A+4wpN6Y8yok+P4N8zhqovFNdl2O65vU8jzd/p16xla63H8c+RIhYhYgYmRZfJu1JQTuEpBoHhBUD9Qj0h41EM1wq5y0gtdzHtf53nnWIiA0WuhDS4L/u4cT/Tavkj/HBSy4YEGWIg6JYqb1h+wjChHGBAtRx3rree0AtgibxdS+Q3e3CEZjDwwrGg1HRFUP81IaEKlYlf+X03qwLQrFQpCmyS4oG3Tq3jYDPGjufvNlJWngVgaASWVSNZxAz/XcqAoDBy3mR1MCL44UrH5E4tgdwTzzXtGT6jPKJl64j6KTw+UHitF3ra3pLGL2icNK0/SF6i89RFG4hffBoyzQ5cJnkFYQKpyzcK/82EtL5KUmgfXacsnyopPKy/7il6xfpjrztr4pIAYCYVlJg81KhCWuji/4MTxGEMFXZC2NjfJyvuWHKyv+V0C5I/ZzetqZfZgd2BcRGPjvYWjTEdE3YZ5y7upTkl4k3HxyVDWaj2A/TZR+j6jI24WzH6C7rT/bfK48LMDRU0j0PSJrqzfkEKST/NbkpIkst/KHRYb
 5cvoBjK3
 ISl7ZyL4b0XlKHZltg1siZmqPBneDD8ncES3+PtEsQxbhJSz8Lac+dwXNjcAvQd+JtvOkCjPRYZsjDvBRvyb5O3wit3JsxPYiE/hEAvpYwP/7KOaY3dnVdquw3azBfO8vjhLaYNG07z0gOqHs1FCWLxIWHIYIqUguLGyi8fswEfIyHn9yrIxfZbCTXpYjuZou7tKQf17CbubkbbdXNiX/fCFgVWh/bbPlU6iKl8jFZ+tDYa/pL+3NN1yy9iyLSLS9uygjyaYLdx4k4WVsrBs1k518xwiBQWTjHmOCcMGrsgYUS/JHue638T/MaLGF9Ukh62PFSfuN0XUp9PkZUYeIfz7CQclMNQOQ/XUnNsxIFDe++UI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/22, Theodore Tso wrote:
> On Fri, May 22, 2026 at 05:08:41PM +0000, Jaegeuk Kim wrote:
> > 
> > Thank you for the explanation. It seems I made a wrong assumption on the
> > usage of "user." prefix where each filesystem can support in different
> > ways.
> 
> The "user." prefix is used by all userspace applications that wish to
> store extended attributes.  For example, user.mime_type,
> user.xdg.origin_url, user.charset, user.appache_handler, etc
> 
> For more information, see:
> 
>     https://www.freedesktop.org/wiki/CommonExtendedAttribute
>     https://wiki.archlinux.org/title/Extended_attributes
> 
> I certainly assumed this was common knowledge across all file system
> maintainers, but this was apparently not true in your case.  I don't
> know how this could be the case given that f2fs implements extended
> attributes, and I would have thought you would have known that when
> testing that feature.
> 
> > I shared some motivation when replying to Darrick's feedback [1], but yes,
> > it was not enough for all heads-up. The problem started that some speicific
> > application needs as many high-order pages as possible mostly for reads. So,
> > I thought we can turn on large folio on the specific files per hints. One way
> > for the hints was using immutable bit, but it turned out it's very hard to
> > manage disabling the bit whenever deleting the files. Along with limited
> > ioctl() and requiring inode eviction to manage large folio activation, I had
> > to implement this path.
> > 
> > [1] https://lore.kernel.org/lkml/aeA5C8byIpXWla7f@google.com/
> 
> Actually, you still haven't explained your use case, at least, not
> well enough for me to understand what you are trying to do.
> 
> So an application wants a particular file to use as many high-order
> pages as possible.  Why?  What sort of guarantees do you need to
> provide?  What happens if they can't be provided?  What happens if a
> possibly malicious, or at least gready, application uses this
> interface to grab a lot of high-order pages?
> 
> >From your patch:
> 
> 1. setxattr(file, "user.fadvise", &value, sizeof(unsigned int), 0)
>  -> register the inode number for large folio
> 2. chmod(0400, file)
>  -> make Read-Only
> 3. open()
>  -> f2fs_iget() with large folio
> 4. open(WRITE), mkwrite on mmap, chmod(WRITE)
>  -> return error
> 5. iput() and open()
>  -> goto #3
> 6. unlink
>  -> deregister the inode number
> 
> Why should making the file read-only matter?  And when you say
> "derigster the inode number", why should this be related to deleting
> the inode?
> 
> This is an interface which seems to be very specific to your use case.
> What if those requirements change over time?  What if you want pull in
> a file without making it be read-only?  And what if you want to
> release the large-order pages without deleting the file?

Let me try to write more details, helped with Gemini.

Background
----------
The primary use case is accelerating AI model loading, which demands
exceptionally high sequential read speeds. In our benchmarks on embedded
systems:
 - Using high-order page allocations allows the system to saturate the
   Universal Flash Storage (UFS) bandwidth, reaching 4 GB/s even at
   medium-to-low CPU frequencies.
 - In contrast, standard small folios cap performance at 2 GB/s.

The performance doubling stems directly from reducing CPU cycle overhead during
memory allocation.

Problem Statement
-----------------
High-order pages become heavily fragmented and scarce shortly after device boot.
We cannot afford to deplete these limited resources on default filesystem
operations using large folios. Instead, we need a mechanism to strictly
prioritize and reserve high-order allocations for specific, critical
payloads—specifically, large AI model files.

Design Principles
-----------------
 - Best-Effort Allocation: The system guarantees no fixed number of
 high-order pages. Allocation falls back gracefully from Order-10 down to
 Order-0 based on current memory availability.

 - Standard Page Cache Lifecycle: No custom or rigid memory management is
 introduced. These folios remain fully under the control of the Memory
 Management (MM) subsystem and can be reclaimed via the Least Recently
 Used (LRU) mechanism at any time.

 - Read-Only Optimization: To minimize code complexity (e.g., handling
 writeback, compression, and concurrency), this high-order allocation mechanism
 is strictly restricted to read-only files. The vast majority of performance
 gains are derived from read operations.

Questions
---------
Q: Why does an application require a specific file to utilize as many high-order
pages as possible?
A: It significantly boosts sequential read bandwidth in resource-constrained
 embedded systems by reducing the CPU overhead associated with page allocation
 during high-throughput I/O.

Q: What sort of guarantees does this mechanism need to provide?
A: No hard guarantees are provided. The filesystem provides a best-effort
 mechanism to attempt high-order page allocations for flagged inodes while the
 filesystem is mounted.

Q: What is the fallback behavior if high-order pages cannot be allocated?
A: The system treats the configuration as a performance hint. If high-order
 pages are unavailable, it seamlessly falls back to standard small folios.
 Functional behavior remains entirely unchanged.

Q: Why is restricting the implementation to read-only files necessary?
A: Limiting the scope to read-only files bypasses the architectural complexities
 of managing writes, dirtying pages, and compression in large folios, while
 still capturing the core performance benefits of high-speed sequential reads.

Q: What mitigations prevent a malicious or greedy application from abusing this
 interface to monopolize high-order pages?
A: The interface acts purely as a hint to the allocation path. Because it falls
 back to small folios when memory is tight, it poses no greater systemic risk
 than existing large-folio implementations used by other filesystems. Standard
 MM eviction and LRU paths remain fully active.

Q: Why is deregistering the inode number linked to inode deletion?
A: We need the high-order allocation hint to persist even if the inode is
 temporarily evicted from the VFS cache. To achieve this, we maintain a tracking
 list of hinted inode numbers. When a file is permanently deleted, its hint
 becomes obsolete, requiring us to deregister it from the list to prevent memory
 leaks or identifier reuse conflicts.

Q: How can an application release these large-order pages without deleting the
 file?
A: Pages allocated via this mechanism receive no special status in the page
 cache. They are managed by standard LRU logic and can be explicitly released by
 the user at any time using existing system calls, such as
 posix_fadvise(..., POSIX_FADV_DONTNEED).

Q: This interface seems highly tailored to a specific use case. What happens if
 these requirements evolve over time?
A: Massive AI model loading is a long-term architectural paradigm. Providing a
 targeted VFS/filesystem hint to optimize read bandwidth for specific large
 datasets is a highly practical, repeatable pattern that addresses a systemic
 bottleneck in embedded AI deployments.

> 
> 						- Ted

