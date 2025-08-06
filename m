Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C0B7C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 21:29:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 860E56B0089; Wed,  6 Aug 2025 17:29:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 812466B0096; Wed,  6 Aug 2025 17:29:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 700A56B0098; Wed,  6 Aug 2025 17:29:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 612DA6B0089
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 17:29:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B67B71DD07C
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:29:05 +0000 (UTC)
X-FDA: 83747623050.03.CC16C36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1F39C100005
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:29:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ArNiiRcR;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754515744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WyxKAaXntoAb2HXjfYxKCDYsCySitgFRzHva0xyANqs=;
	b=VtQaYWFz3JQIA7GToalWFwuQFhFIutbNkXHfuU/9e3GA84jOmP/nECJbjOAbmsTn5WIyuc
	3ec5rvl0ClkptptqSa4fL2PYJtAtm+4ISHHbJEz6+HVELE3bpAJQIG9SeUuGOL4/Nkdn4R
	hZKi6gJWFCb8KHEiefmtT8v3evnSKfI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754515744; a=rsa-sha256;
	cv=none;
	b=t+VJJlmDMYSjjt6ZOSWjJT5jrMlb5XmBIBw5JMTwwfyJkEGt8IrcvuzXUVfmibmKuSxciZ
	VDQQqw9CWAQukglCVXHDqDkXU94zgdoh9VuBi79QJ3LZ1RAWLY3P3uspl+vQya/DnXlh+g
	s0AsCds3I6oi2PfcQMXeLQZoSdngD/c=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ArNiiRcR;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B7F2643F4B;
	Wed,  6 Aug 2025 21:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C7E9C4CEE7;
	Wed,  6 Aug 2025 21:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754515742;
	bh=Fq/MOI2IKGG/4kPRJlehFii6lGQAeZnINeDyXd2WKs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ArNiiRcRKorpVO7z+DunHSF3hxUwxK1EDgvBb0KT5vuGoa2JxHw4Hiaw1jIzkcn/o
	 l6F0dgqDxDXC2uQcXCFC5MnqwdeR0xzuzO3rfzI7SkQ8sGhRG2wfo5Z+wHuMMbeM1J
	 zimEjSX1KoMR5gu8jqbdNa2KZ9HmhDXHDusk5BiYoRJR728drUcex1rGiViuqjqo4J
	 E5it6p4zZSmW86oUo7idBi9RYF8w3U1h1o0tZHAWPRS2VNCTPiZ3Ay1iAnJ1X/VTj3
	 sJ8XQMWzQqOQ3JNlpQlSI5Ef7XrlYwRmV9P53J6AtenIBJlpMCv3a0a4IeM9rbT2B+
	 0DV5Mmst4abnw==
From: SeongJae Park <sj@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: SeongJae Park <sj@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Takero Funaki <flintglass@gmail.com>
Subject: Re: [RFC PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page as-is
Date: Wed,  6 Aug 2025 14:28:59 -0700
Message-Id: <20250806212859.51259-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <055a8a69-731d-43b8-887e-54d8718877cb@redhat.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1F39C100005
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 34iuctxroxa5n7j8dg5iuwxs57zgyw1h
X-HE-Tag: 1754515743-766082
X-HE-Meta: U2FsdGVkX1/G0DPlTEAfb/fMNA1xkx1dVlxmp8BGm1LbIhHpjzOB1CwDbj1tHJQYNGtwKewjqcH0zlB/4z3ltvutbyzGYvPGHbMLbdz78HTTJYo7CtrN+pffoY1W9omJKv5pXlqlFgHeTCLghH1edfuNvHwKXiIJ56vhElhE5TpvCwU3kYBNTgK4flbr8kYtA6rzmYEZAUvAG6Jx+sfHyWHr9SfE2iE7E3d8eZHPvtrKEK/UtcNvUPnKu6D6E175lGX/LqhYoaRbcjYZldHBEsIS1KQwob0+3M4pNJBD28SQAlUSZDyv55THgJNtj7evvJZYkGznh3U3ywq2nEUGp/7Vu14WPrho76zyXSaNGj53hS1EWfbHZRrNnCIU9w9o1WKLJQUp9J+IS63h174HbNsHS4cYYDOdjH5RWZdW+ltIV4V2FfR9phtnhJLA5uRs5S2OzwDfevZo7gf7iRYFrE3rld8YDXxyuhxtlxUQ7dxGvCP+TAdEBbYJdRwh1DN78pnQMp70w7E3SvIfDihK3tggU++0VMsHgXGKVZzSkb8o0kFcLXGiaHIqsKgu03oe7k9owR2DvbTQh2C/AujaaVH8ITOW/K7OoJeA8F5EzwpTmPt0eOflYG0k7mAzAECO0OmzjjZaCUD563Xz70LwVfhlcsDH0JHyf+HJEzvwMTfR6qeJdN98O7I8z6HOxA0tE/9kjTNzo0tlksX4WkD41dqNb1H6aRfTgO93t5ASQSPw6HCvMXvoJAXzBgUW0E7CyyULw14gYKGuoHpsxciFoCqRnRSLWeXiSZcI1nOT4GazQhPT5xcZ+6s2S6C6qfnC+A5ACbd/iEsoYVMuhbQDsl+uVQ4vqITZbdpbm+eOlYbapV6fovtRAyj8z4tfXm2FLXXphGRgqRZtlTYrQjF1lw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 6 Aug 2025 22:14:39 +0200 David Hildenbrand <david@redhat.com> wrote:

> On 05.08.25 18:56, Nhat Pham wrote:
> > On Tue, Aug 5, 2025 at 3:47 AM David Hildenbrand <david@redhat.com> wrote:
> >>
> >> On 05.08.25 02:29, SeongJae Park wrote:
> >>> When zswap writeback is enabled and it fails compressing a given page,
> >>> the page is swapped out to the backing swap device.  This behavior
> >>> breaks the zswap's writeback LRU order, and hence users can experience
> >>> unexpected latency spikes.  If the page is compressed without failure,
> >>> but results in a size of PAGE_SIZE, the LRU order is kept, but the
> >>> decompression overhead for loading the page back on the later access is
> >>> unnecessary.
> >>>
> >>> Keep the LRU order and optimize unnecessary decompression overheads in
> >>> the cases, by storing the original content in zpool as-is.
> >>
> >> Does this have any effect on the movability of the given page? IOW, does
> >> page migration etc. still work when we store an ordinary page of an
> >> shmem/anon folio here?
> > 
> > Good question. This depends on the backend allocator of zswap, but the
> > only backend allocator remaining (zsmalloc) does implement page
> > migration.
> 
> Right, but migration of these pages works completely different than 
> folio migration.
> 
> But I think the part I was missing: we are still performing a copy to 
> another page, it's just that we don't perform any compression.
> 
> So I guess *breaking* movability of folios is not a concern.
> 
> But yeah, whether these "as is" pages are movable or not is a good 
> question as well -- in particular when zsmalloc supports page migration 
> and the "as is" pages would not.

Maybe I'm missing some of your points.  But there is no difference for "as is"
pages.

Before this patch, zswap asks zpool (backed by zsmalloc) to allocate memoy and
store the content of the page in the "compressed" form, if the content was able
to be compressed.  After that, the original page becomes same to any pages
that swapped out.

After this patch, if the content was unable to be compressed, the content is
saved "as is" _in_ the zpool, in a way same to those "compressible" case,
except the content is not changed.  After the saving is done, the original page
becomes same to any pages that swapped out.

Zsmalloc will support migration of pages that backing the internal contents,
regardless of whether those are compressed or saved "as is".  From perspectives
other than that of zsmalloc, hence, I think no difference is introduced by this
patch.

Again, I'm not sure if I'm really understanding your points.  If so, please let
me know.


Thanks,
SJ

[...]

