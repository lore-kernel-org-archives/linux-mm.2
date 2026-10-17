Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10B4BCCF2C4
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 19:52:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B44D46B0088; Sat, 17 Oct 2026 15:52:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF4AF6B008A; Sat, 17 Oct 2026 15:52:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0AE86B008C; Sat, 17 Oct 2026 15:52:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A3566B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 15:52:49 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 79D63A7D85
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 19:52:48 +0000 (UTC)
X-FDA: 85333166016.05.93D59E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 97AAE1A0006
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 19:52:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aQXSkLOj;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792266766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VMtc0vXLRWczunwpL2LvoNH+JwWReughg0I7XEnUY2c=;
	b=566oLtuEcs00OnhIIZLjweJv4BIdR/2JPfNvrzJoOolEutcp0a8NAolq3VnwNaY8lGY3DN
	W+q2rSNdmgBO+DrYFHnOpxSVHDSukYkA2JMqwzETHEiPKSzz4E29GWjPbQ7j+HtOhPtR8/
	1G+tCiamY2Okm8HzzUfE30GnXx8luRo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aQXSkLOj;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792266766;
	b=U3ZMhl9Fv7B+NkE1mO9r+Sw+D1GK3poIx4ComEwSI8uZM58svu3s+pHy34T1n/1E6PYKEw
	a/R2GKccqwNy2DliLs1mwL7hIfj+HZivRZrn89lF0V5k7tV9V/W0Q6poD7SPXaXi+Lwq7i
	7JDlBuwhBPII1RSTVuA90hWu7fCesE0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EEC2842DD7;
	Sat, 17 Oct 2026 19:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D3A31F000C4;
	Sat, 17 Oct 2026 19:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792266764;
	bh=VMtc0vXLRWczunwpL2LvoNH+JwWReughg0I7XEnUY2c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=aQXSkLOjh9yKdtK3jSdADMm1RGMg+VUukebvPUolea0IF7YCKMeM1zU43gUFkhTq4
	 GnGfWKlts8PJHicUa1vvcqvgq78rg0pWMpbVnLwJeJV4qQEPag6IfPoZBE85L0YYZA
	 K2mozBlD2MPgf5YkHA7kCE3Qpmn67EJPkXxkc6Ns=
Date: Sat, 17 Oct 2026 12:52:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: Uladzislau Rezki <urezki@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/vmalloc: read vm_map_ram block regions from the
 requested offset
Message-Id: <20261017125244.b2d7134fa9697b2982cb8cec@linux-foundation.org>
In-Reply-To: <20261017154120.795844-1-nickolai@csail.mit.edu>
References: <20261017154120.795844-1-nickolai@csail.mit.edu>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5yhiu7cdxrjejbhyti3mpnsbdpw39bie
X-Rspamd-Queue-Id: 97AAE1A0006
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1792266766-162943
X-HE-Meta: U2FsdGVkX19o3YC4cEGtkLIMXAIiFFuL0LEFe/IftIwJ/Xl9RfndqKimfmK17pEVhsWkWbCZtXZ1cdFKSKn6ZHiYl8J0BphK1bSN3650hXFTUSRapCxWFSb6hsBbP6xevSkrf/8akorGDEh5tOK8Pp2XbjJ7kRBFfetFTjL3yaLYMim93fhkIm6Dbc3w1S21DSBI0xi6Fh28O5+erVljsxIWCti5pUJPEk3/Wc0oRt8oDlXXOrbFC925BZA29BPUWqE9tgdDAR+h35PBWjMrEE1gbEQEETny5HyGMCcAje1UnkPscKi75CBXnh9c/PCURudRc2rldED+Hi983+fzBKa3fr10vnYh/20isXWUBVKK6aeYswZvtlFpqX/SkGf+w6rwf4s19PBfMpofNM68xIXQoGiAxLPvd0oppmcyut35Ux9xCpThs1Msvd2tdAFW00wAT73DERpThe/ucxwbhN1OBSvL9qqVLeadht9pFVylXMBQCukwSqOoFJhBXbD3vCqLE6npuqV5zVs3pywXynFPPXBQFUzYncxmCqHj4d3vTohR65uDDM1Ib3lVHvdaJsTHmrnniWfvGHNBfyV5HUS9XVPUVrFq2mCEInoR8Qnzi0WiDn6QhhDDOMBIO3eZ+E64K56BR0oPSVfJkw6XJyGApg8tI6vYzxGO78jZdbWwdjmGhTreGWFTWrwYl5mmVG2KQ9ealPAE4WvKGu4JOq2j/8IEtI4TLdBPlSX8BY7kptFddH56oAFiKrFpPMYcZueRfbrvuqZcCzTD54sYcnYA1hkcWGPxRnLT5TMY8v7K9Cw8vQWqUSA0VOJm6vac9zCmxRKcgbV4VHUDhkWv6h6WKvV7FgV6/sTlV9YMflFuEZiZFuiMzLiPsLttjHjyMOMdgAatADV1dqJ9fT9lDXeEpvtpGJi658UAM/Ff+WApwsQO++BDtdoGYuLXMFNMmHJqbPS3XoKVuNNtuTx
 DTfL2PJ6
 PSjdFv0eHXDVU3Pyd3WjzZ2cM6ptqyCbFeF2PrrK/PbLAZ9z867kOy8UmBWN8rRcHXm9y51oYit/n6/C0zabPoONm2vZwNQclSKUCKrIJFLBNNz5K5Hi1A8xu289PMSMxFRKP+LyB815xgZtb6O15FmwCQx3U9DsHMP9JxTXC7jSyYEiAL6ieBH9jqIigpE5b9cyeVYjaDVB+RN7jp7SB2CfYGkdVG40XHBpTWLX3KIx3ukmDYTnmfyRyp2MZrFeAma7deZqHxysJOxmEv6eP99Q2ePuow/+8jaQmgyrQUv0Eq38=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 17 Oct 2026 11:41:20 -0400 Nickolai Zeldovich <nickolai@csail.mit.edu> wrote:

> Reading a vm_map_ram() mapping through /proc/kcore returns the wrong
> memory for every page except the first page of the first used region in
> its vmap block.  read_kcore_iter() calls vread_iter() one page at a
> time, so a root user reading a live system with drgn, crash or gdb gets
> that first page in place of every later page of the mapping, and in
> place of the zeroes of the unused pages after it.  This affects every
> vm_map_ram() mapping that fits in a vmap block (up to BITS_PER_LONG
> pages): erofs and f2fs decompression buffers, videobuf2 vmalloc/dma-sg
> buffers, udmabuf vmaps, fuse readdir pages.  Kernels since v6.3 are
> affected.
> 
> vmap_ram_vread_iter() walks the used regions of the block and, for each
> region, zero-fills up to its start and then copies from
> start + offset_in_page(addr).  A read starting in a later page of a
> region therefore copies the region's first page, and a read starting
> past the end of a region still copies from that region.
> 
> Skip regions that end at or before addr, and copy from addr itself,
> i.e. use addr - start as the offset into the region.
> 
> Tested on x86_64 by queueing a 29-page V4L2_MEMORY_USERPTR buffer on a
> vivid capture device, which videobuf2-vmalloc maps with vm_map_ram(),
> page i starting with "userptr page i", and reading every page of its
> vmap block through /proc/kcore.  Before, all 1024 pages of the block
> read as page 0.  After, pages 0..28 read back in order and the rest of
> the block carries no tag.  With a second buffer in the same block and a
> 100-page buffer outside the block path, reads at unaligned offsets,
> across page and region boundaries, into and within the unused part of
> the block, and of the whole block return the true contents.

Thanks.  The Sashiko review is annoyingly embargoed for 24hrs, but it
found a possibly-preexisting off-by-one which should also be fixed in
the context of this patch.

I'm working on some akpm review prompts (which incorporate Tejun's
prompts, Chris's prompts and some Sashiko things).  Its summary:



The fix looks good, but there's an off-by-one in the new size
calculation:

> +		size = (re - rs + 1) << PAGE_SHIFT;

for_each_set_bitrange() returns half-open ranges [rs, re), so re is the
first unset bit.  The size should be (re - rs) << PAGE_SHIFT.

This matters because vb_free() clears the used_map bits before
unmapping the pages.  A concurrent /proc/kcore read could therefore
copy the contents of a just-freed page instead of zero-filling it.

Please drop the +1. Otherwise, the change looks good to me.

