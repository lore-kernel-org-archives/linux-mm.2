Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B478AC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:11:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57BBA6B0185; Thu,  2 Jul 2026 21:11:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 552536B0187; Thu,  2 Jul 2026 21:11:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48F036B0188; Thu,  2 Jul 2026 21:11:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2125C6B0185
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:11:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AF2AC1A01F0
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:55:28 +0000 (UTC)
X-FDA: 84944437536.16.D1ACF9C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2ECFF4000B
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:55:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cJxHExrR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783011327;
	b=cs25Z+deWrndcGW10SO7ld94oi2eBTsu0lCrc0bJqhcdCUgxDViHsweraf4RcuTKnZoofS
	KHp/Hzr8vDDtJET4FoU3W/UmQV5EBhMG9u0io7eFbXUsxcdd+2TgZJmhsKZXiaaEh9JlrE
	bKcjIwiXzOJWDuRgrQMslPD9dFL/atc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783011327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j/PPcJVBFu3B9JSbXz7pt6mPU/DAMOYM8wrcrC1rScs=;
	b=yvAnWKbdiVNUNg+R1diQxlOjhFShYFQdMp3ohv/sO3q7zuNPTN5Qcex45X0XRGpKIDdi0k
	1lrxv9JJU/rmuPjR2tv6GMdSngtRrXbleRcF40+69FsFeZXfMfiTqkw+lq+ZtMdrcfbvBB
	UQevdC3n/ALrWLon5p96+NB6/q7okvY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cJxHExrR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A4730601F0;
	Thu,  2 Jul 2026 16:55:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906031F00A3A;
	Thu,  2 Jul 2026 16:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783011326;
	bh=j/PPcJVBFu3B9JSbXz7pt6mPU/DAMOYM8wrcrC1rScs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cJxHExrRfdCPy02rzL8s34i4tnK3DoynY8+HBa5+YHG5enxIgHa/2K9jy9YTQ1UMl
	 XgMuN8hpiXZtKlE+8JNvX3k5cUrGvwXZ55AHYugYE3PwZHuwWiwQQmJffm8HIOTfMd
	 UeVkcr8EBDibmJtWZ438QD8kVDL5NHJmA/S+nA2+PcYNkbwkwHuJRibMaMh0GR0FFj
	 3J4QNFEHbqvSfXvT8it8dhUnjsiT5gPmCL4eR29ITbSR6WM03gn/6m06+Acdewf3Zn
	 8xbmU5+tkVBS+WuAt5SFUcdI0hbJW5RwaGMVbBeHyd87P9zevgwgh02cjB3REGD39M
	 2dUCyW70ohyMw==
Date: Thu, 2 Jul 2026 17:55:13 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org, kasong@tencent.com, ziy@nvidia.com, 
	linux-mm@kvack.org, ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>, 
	willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, 
	shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, baohua@kernel.org, 
	dev.jain@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	"Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>, 
	lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, kernel-team@meta.com
Subject: Re: [PATCH 6/6] mm: rename ARCH_ENABLE_THP_MIGRATION to
 ARCH_SUPPORTS_PMD_SOFTLEAF
Message-ID: <akaXyc12ajUZqgiu@lucifer>
References: <20260630164143.1595669-1-usama.arif@linux.dev>
 <20260630164143.1595669-7-usama.arif@linux.dev>
 <e37df165-8de0-4924-ba19-0d43a6b7d36e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e37df165-8de0-4924-ba19-0d43a6b7d36e@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2ECFF4000B
X-Stat-Signature: nu13tkrbm5a1swkaqjakcniuar7t1wu7
X-Rspam-User: 
X-HE-Tag: 1783011327-80169
X-HE-Meta: U2FsdGVkX1+vti6h/bhspL8Bp2eBD5/eQPQ5654OfYeOXqgCdhipYSCLJguIjL2pAF0Lo8pkgHkYfCTZbQHPAoEFseqKknn4WE2uMkGUw1T15FSWvPQjKqyGaVNx6RBwTyO00DOgy8Himzxu09CjdUmWggjQ1A/hp0ZcNLFqpBKFev1D0NgiiBul2H5OOuS1JDVohkQDWyxuFKy90xl4LH9I+t4PugMYPaPpTY25SYN0iY4BbyV4VcDBwshdX1O03elsBf6tyOpor521oQMEd44LXj5xjjpWOSWgKaOZOBL7lL4hhTswUxmb5HdIqJ/C7Z8UqtntjEfQ0M9O81zDYtxOEBEBXsQb4VOQL1mG7YRtDm0iqbdQSxtWHwjrUfwXSN4cQjoeZCApDb24ePKTb0qJ+kyQsSZFDwkmeD1FFHLqjmURZbmfn3MpfljdaJwSqKgWr6AoK3GGAQbI9V+EMfoRVz2ME5VFx4QJdjPZhDo3myaasOLoHNSobPlqRA1LRkDvLVwrpE3G+QYOtkxi8v7FecuW8mekU3FlmsVPzDwIXB09lJ03CJYzOZkykrIwMbGl6fFwJyylLCf2oOoBbc20eFcG5anlXAZJFlPSpq+5TE+B5CrMndUSK7/EJuLsc3I+/jleqY7enix35C2d1bHkI7JC/Gorl291iJHIHdyL+ZO6hfyix7UwOuq66XEVjfKt5p2P2/dRUzu/dkxv9vBzE537xvq00OxHqgvErkORF2t6exSWZTaLoMxQPQl4zp3UDC0kNF1kCWJ/d5XKuZEgnoBoQgygw8yha5p7IU9ZSos9f3422/vflwZnpNlgWq+FCtrskeX48M0mczlLO6YyH9gCWHYMbMFDV6+3O7Pa471KdE+Yjx7SnYtmUa9fNQekP79T7qcJ33SjMewMnM5PUUMrrQmK9r1s2d0PyvFSXOzPfmiRvvMJVzYgxRxIhEzaeZ3xGLISZwFK59m
 drFgh3EI
 AI0mGbd43JV35gXI/foXXme7imPoxQYpeb1YHSMhgl0AvO8HNYg9Y+b0QE/o1TYmrGGTCY/dF1SnMT/bMaeV3wOnCvt13h/eIgMFMOTOyHE9YdsY4dH0kOgUJeTrBT2J0YfGtJdlvwY991Jxy2clylnNDJO5oEdgmviQTP9jpGEO3cl+pdwP+NwacYS1dyZdtx/U78f3xj7DLLaa51P7p4C/axrRwQIXcHp2GtYZfxjZ6mRe1pwqlDdUyXXbfqKSvlsnCIjehzEVYwD4RaKZ2yFm75eeJnJ6zRJe+wQWfXBGN+B0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 10:03:21PM +0200, David Hildenbrand (Arm) wrote:
> On 6/30/26 18:34, Usama Arif wrote:
> > CONFIG_ARCH_ENABLE_THP_MIGRATION started life gating just PMD-level
> > migration entries, but has grown to gate the entire PMD-level softleaf
> > machinery: migration entries, device-private entries, and soon swap
> > entries.
>
> device-private really relies on migration support.
>
> See do_huge_pmd_device_private() where we migrate back to CPU memory.
>
> The whole concept is pased on migration. So that's why it currently makes sense.
>
> So "has grown to" is not quite accurate. It's a different story with swap
> entries (that can exist even without migration support).
>
>
> > Rename CONFIG_ARCH_ENABLE_THP_MIGRATION to CONFIG_ARCH_SUPPORTS_PMD
> > _SOFTLEAF to make this clear.  This is a pure rename: the set of
> > selecting architectures (x86, arm64, s390, riscv, loongarch, and
> > powerpc on PPC_BOOK3S_64) and the gating semantics are unchanged.
>
> Hm, that makes me wonder what it would take to make this all just be implicitly
> supported by CONFIG_TRANSPARENT_HUGEPAGE.
>
> Looks like someone would have the courage to touch stuff like arc, mips and
> sparc64 (+arm and x86, but that's less of a concern :) ).
>
> So yeah, renaming the config option makes sense. The config space is the wild west.
>
> We have
>
> 	PGTABLE_HAS_HUGE_LEAVES
>
> and stuff like
>
> 	HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> 	HAVE_ARCH_SOFT_DIRTY
> 	ARCH_HAS_GIGANTIC_PAGE
> 	ARCH_HAS_PTE_SPECIAL
>
> We do have a limited number of "SUPPORTS" (which is longer than HAS), but I
> would either use
>
>
> 	ARCH_HAS_PMD_SOFTLEAVES
>
> or
>
> 	HAVE_ARCH_PMD_SOFTLEAVES

Yeah it'd be GREAT to simplify all this!

>
>
> Apart from that LGTM.

Can I just say I love this patch in general though? Softleaf all the things :))

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

