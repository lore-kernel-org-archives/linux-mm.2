Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8213ACA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 17:47:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B29DE6B0029; Wed, 27 Aug 2025 13:47:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADA3C6B002A; Wed, 27 Aug 2025 13:47:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A18AB6B002B; Wed, 27 Aug 2025 13:47:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 867B76B0029
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:47:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 570171DE7C3
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 17:47:21 +0000 (UTC)
X-FDA: 83823269082.11.825B7A3
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6CABC1C0013
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 17:47:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jeMmBzT4;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756316839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ghKfMv5DKOHTE1nvgoIuZHQcli20D7t7I3sG72L8nws=;
	b=iepscVW89mmKxJE2DknbvhZ4ptAo8nBrC37WbVM6NrMnG4ZYmtxr4dpsUeQ9JV+vWSM3e/
	EXBSLFdUd/UdReEJt5jxr4mCQFErdkI4lNvk68z6ODgXcdiBoiCjtJa06C2IOdw5ydyAZY
	7DGnIymk7mk6qcIu6viLIIjJF7xSico=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jeMmBzT4;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756316839; a=rsa-sha256;
	cv=none;
	b=y7ffEpxG9KRUFa6JSl7jsbuap2csr0t+d780Pxu+ZuhL726pUq/ChhuQt8VlGAMGO9lvHr
	Cmoc5VPaSgsWIe5C6YC0zjqcuS1l0u8ZR1tCx7LXzwtB46bE9m0RjiyoCCuslUWwykV7BS
	+GaqExkXae367HqtyXhoVCcT0RNm+zs=
Date: Wed, 27 Aug 2025 10:47:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756316837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ghKfMv5DKOHTE1nvgoIuZHQcli20D7t7I3sG72L8nws=;
	b=jeMmBzT4+Wigtv96A79lYlDKdFkNn8Afum0r3lTu22SX+mmpmfCSZQ3p+4K/Gk9QNxBZj5
	atO/rI/jHoIUCdhPlv4hc3UY3iWvfzuY9VoDN/Qs9JeuSirjMDUBZyhCCBEjmgwfBEdaIK
	EYN0n+T9r58pjyI8koEcmycY8pTrEbs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Boris Burkov <boris@bur.io>, akpm@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-btrfs@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, kernel-team@fb.com, wqu@suse.com, 
	willy@infradead.org, mhocko@kernel.org, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, hannes@cmpxchg.org
Subject: Re: [PATCH v4 0/3] introduce kernel file mapped folios
Message-ID: <vo3wqueeianddd7kk2sbhv6bxwkbwhzqaem5v2obxotycqrmug@7rehz4g4igwn>
References: <cover.1755812945.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1755812945.git.boris@bur.io>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 8giurhohyri9yubdnfrxjajqqt9s6una
X-Rspam-User: 
X-Rspamd-Queue-Id: 6CABC1C0013
X-Rspamd-Server: rspam01
X-HE-Tag: 1756316839-687947
X-HE-Meta: U2FsdGVkX1/98s/tFIsNaVsaR/TUZq1vKoXA8KLCyZsrTKAHWNuJl9T0s8Px+uzJJwkwkoe382bgiGP32sTFmTsTiilJFHZ4+BmicEbhorRO2vfIbWKPAdBZUUG8w87Rm4r4s+ej8mpFsjckwjTjMrbL02YR8sCGN/aiI+HF4ScL27G9B9D5+tvGnvBKFi+6Z/mw6oppR0rqrH9ZPgiUUbFZKkZTMlFNtlon7DavWZ4zlnrtIwewlYgMMQSP58StXDI+L+2jpFDyDpHdnkdHlRHFBppVZb5xUv6miEWW6r+jXQnwqpmmhddY5HW9tO76NH0nXIdFwf0I/DIbz+IFzCnv9yc4NJkh2D3unHb2W5l6E9Figmu2o+7lEJKxkrc+81DyTYT3WftQ6KlK/xFkcgXLksL5ybgLFuuYrT0M5Sjrez3hT3kOx6uVnFF0aam4vFzXmWXLrnZFoEBUa9urxUvXE/qTDeux8+K67/8XeZYVhpj/g2dsQB0elJXVtcx1kh+UfpzwFVi0BMeoxsr43FWSrX96hQJnnWCGTKGJvzK5EF47IO0lTJGdsRmEFmazwowfPLbz8mwTsg7YObBGDFcS3wJe2dQX2v/inue5MkifDtH9MiodUhZ4zwM0P412HjXB1ibMA5MSs4Zh3ORATzNh/ZBc0rT1bNOs2KvXru59HPDRgv/rsnywPxnsHXH9rt8U3QnREwhz5uI7v1VIQvy/f1hdhLaYBGXGr5C7sLjFOpZopyJK9ouwQAUuuIgmWFYCNVdBRAxTxJ/EXne3Hzb47bCQtmCEEzQqMzyIc1ihsD4rKnGBP87gkidZ5g7GLvRjwaJTT5BDdhLEMWnZ72vb2El6W5JPKO6z4l/ezVPwMXuNkZhxfsmpFYNPtZgErzdR2fBV/sNIIcaUr2Nlp0Zp6VDF+jQWLzBNuUavR0TI/HKRDlFxhgpT9bx77OUsSAKl11R3nxiJ/7+EHIk
 E/XpN0kZ
 gtl8B9kT8QfGdAt37ZRujt33WJlY3e0vKwxn4ubPujJtMRPwM0dhqH/PNtKp4s2eldkBfdFUscvtk5rr5RowVxp8kUB1gH+NNYHF9RHIHRqiaOkQWxPVevgPnvtwqe+vBmyXNoC6QnuqMQIP3yexSf/Y5244ebVFctfWWIeMBKzL3zNhwbQS/YMGKMcI/mfCxi3Yh8HdnGSIlKmBCXgdRYa6GYHIQIyPZA1YtP44xLriNguBu3ER+DA98dcWtfUi4v+jrQfGTuXt5Q+te74KYL4zb1ELeN3UTaJIW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew, can you please pick this series up (replacing the "introduce
uncharged file mapped folios" series)? I think it is ready for wider
testing.

thanks,
Shakeel


On Thu, Aug 21, 2025 at 02:55:34PM -0700, Boris Burkov wrote:
> I would like to revisit Qu's proposal to not charge btrfs extent_buffer
> allocations to the user's cgroup.
> 
> https://lore.kernel.org/linux-mm/b5fef5372ae454a7b6da4f2f75c427aeab6a07d6.1727498749.git.wqu@suse.com/
> 
> I believe it is detrimental to account these global pages to the cgroup
> using them, basically at random. A bit more justification and explanation
> in the patches themselves.
> 
> ---
> Changelog:
> v4:
> - change the concept from "uncharged" to "kernel_file"
> - no longer violates the invariant that each mapped folio has a memcg
>   when CONFIG_MEMCG=y
> - no longer really tied to memcg conceptually, so simplify build/helpers
> v3:
> - use mod_node_page_state since we will never count cgroup stats
> - include Shakeel's patch that removes a WARNING triggered by this series
> v2:
> - switch from filemap_add_folio_nocharge() to AS_UNCHARGED on the
>   address_space.
> - fix an interrupt safety bug in the vmstat patch.
> - fix some foolish build errors for CONFIG_MEMCG=n
> 
> 
> 
> Boris Burkov (3):
>   mm/filemap: add AS_KERNEL_FILE
>   mm: add vmstat for kernel_file pages
>   btrfs: set AS_KERNEL_FILE on the btree_inode
> 
>  fs/btrfs/disk-io.c      |  1 +
>  include/linux/mmzone.h  |  1 +
>  include/linux/pagemap.h |  2 ++
>  mm/filemap.c            | 13 +++++++++++++
>  mm/vmstat.c             |  1 +
>  5 files changed, 18 insertions(+)
> 
> -- 
> 2.50.1
> 

