Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7BF2E937EA
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 15:46:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBC986B0089; Sun, 12 Apr 2026 11:46:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1F2E6B008A; Sun, 12 Apr 2026 11:46:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE6E06B0092; Sun, 12 Apr 2026 11:46:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A7A896B0089
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 11:46:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 34188BCD36
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 15:46:27 +0000 (UTC)
X-FDA: 84650330814.28.C57702D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 79781C0003
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 15:46:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rf37rqrV;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776008785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=thUZaRyQXI7atQ6gcPPI9hGFwXZuqBf7dyO4MI2Y2Ok=;
	b=Q06sduiDN10nDivwz3obCQ1gid1gej3eRpFRPvg8qpHWcI3sc5UqJD/6J8mDk+mecow+c4
	QbhC2bBBLs5tXRIv6jhbaITPL45r5zrHJUnGNDxc8vswv5A6D8kmTfx5oGeToShTE0w0JN
	TO4+neJQ0a7rdoE2JEGa4YVMT7Vve38=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rf37rqrV;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776008785; a=rsa-sha256;
	cv=none;
	b=sLnv1oNbDrA3jlwkKbMTcsOGYC7mBgPjplNUxYvFPEdfL2ZrkaUrhjVy/lt7OyhlpgtXo9
	UYhIeaa9CyXuXcMez2nQUy2KAUhOml/thU5f1reng/oXnSWeDZIu0ETYjsq7ULD3IBWPUN
	a/SgbhZB59RHAUy4wYIiy3iCKV39bSY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E3B5409D9;
	Sun, 12 Apr 2026 15:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCB1C19424;
	Sun, 12 Apr 2026 15:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776008784;
	bh=EYf/goX7OAlC3Is00z3Y2oPAAJuYGpf93xqgl5zb4ek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rf37rqrVAQDAdJo3ODh7JW01Nf6pXWbxXI1tcxEiUKY4aM3RN0bMmHi/WxwtkJ1Lx
	 aAJR07MypV0dkJeR0XupRWDFvRCVwoHL+8ne+CLA5N4BLxpkbxexNpShT5YeY1zW1K
	 oFswF7TYXswTug0K1osQEm6JkfUHJJg1bLQ1qBAhS8dBL722dVi0yrXiEYbgy9x3ge
	 kzvyK/JXqLfvPvj4fvjXKa7xqozpP3Rr5tmjIk3gCM3w5I6v1nRbcRsyyfT+1rS9XN
	 xT7zRwWS72Qeob/q4iVOHel74ty6xUX6SlZq+EA/FG60GEHhsYpsnh9sT55ylq7gAp
	 /fn05Bviij8VQ==
Date: Sun, 12 Apr 2026 18:46:17 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Peter Xu <peterx@redhat.com>
Cc: David CARLIER <devnexen@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v4] mm/userfaultfd: detect VMA replacement after copy
 retry in mfill_copy_folio_retry()
Message-ID: <adu-ScPEF5saZekk@kernel.org>
References: <20260331134158.622084-1-devnexen@gmail.com>
 <20260331200148.cc0c95deaf070579a68af041@linux-foundation.org>
 <aczOCqrCx7Xd5HIF@kernel.org>
 <CA+XhMqzdQLZD4YWzyZfTwd_+sDnLqj24APqBRgum97_=8EcM2Q@mail.gmail.com>
 <ac3paYh6sPHr3EJd@kernel.org>
 <ac5yKatsMxNp4G2g@x1.local>
 <adeOIvNXFLTCXMcv@kernel.org>
 <adkWv9xdsyLMn9qd@x1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adkWv9xdsyLMn9qd@x1.local>
X-Rspam-User: 
X-Stat-Signature: a6gnerz74i1im87f774gukxbhifocfrj
X-Rspamd-Queue-Id: 79781C0003
X-Rspamd-Server: rspam09
X-HE-Tag: 1776008785-704552
X-HE-Meta: U2FsdGVkX1/i2Mpq9WHmdPH9LivKyqFJ4pXTZkHa59P5Egd5MJcAa8zQAOOgx/QFT7EPKmnwv2p/e09L3d8sH6z3wQhRZNxUDtr7h739RRn+psyx+cl8aNY1/ZIVYndm6gkwfozBWkgSXgViaK9tDAvCWvvuUEnngS8Fj0hpo0rFgIuW79NXEP+e7Yv48V8vnxwJIL+WKEbw+y+l9+/cGwjCQGAP4wcdOe7FdKZkBrysYp674M65QPtmstbmYZC2crTZuYKfCVRgEfpmcFflxRxBZDBJrNKrB5oaLYGyXm3o6O0jNOpZfo7YrH+S4oad8oDqbpzo+2Ms5UHanrZSTWmQ790YHdISu39LXtEF61s75gGGwCPS5NcIS8npyMZm4J1RJu1+/zkKlXn/yw4FAjM8sijqE6S1ljWM9d8vAnbMT9da+kBs5ggOJ9lOk+ZCeQ4edPsJxhbP9h1Lb5eaW5/115xR7mEL/MH8MxEMCAD/f/nFpRQFK/K7LItdYA4zFu91KJTh4shNcjr5hawo/h/YCrov2RfG/TdPx4lD+2PehAhAuS9BDaQG7rB9QtRSPI876ObDPNkweCfLfHT+DuDgDAMRGmTX9PG7hXnwo74pQ72xOJi04t7TakrYxvNH4HkNKNy2lVK8/pxw9glORbvXrEAQ06S20vD/JBbR9yT+Lf2qokfWJhfxyxKGAHJzCOpLNdtiI2yTyQURhJedX0qEVbWsZc+PDzFedmaZ3l8MAiWP6dqufQyBNfqj8qYxyriE3mngcT+BKOjgu+uKlTxnjbYXovk63PvbvjvPHXCRkHZpVhIJLF/kDOmGKeNdcm3ubTLKHWWl/GNKyjfbKMCAYRs98ElRECO8vZ3fpyDkow89botbqCD6t0ZwA22cJYih0fS7kZeo1pr5jk0pp2LYlhAAYWGRWYu7DeDJ00mpS3No6nPZF6Slm9GXJwwLfZ45nZU/fkJH1DOcl/i
 bQ4catNQ
 fy66ClzkGG9gdppHMQp56aovfyuPyv8Ut+aIWPh6W1Oodfhbwt72BO2FWHrq8YMxE8GlaBpq+HGzkzWUEue5FcFEQPUPz8QJ2Tk2eurCx2SO+qlSkcmKDQ1h/4RsumvYvc5lQ6g5mi/f5r0X6bOH8qBet7wxARidmiFwr2zFR7AMHxuvHVX+66uL3gGDATY/cP1f59quFozBcwWmk2TpbvAKjCwNXu4Rl2nbQkDFAVOdD+eqDpTvpIrAm3+35h6UtQhRp6wfI7yKe0prFODLpTE81uskrCHnag2yj9TC45KCXemc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 11:26:55AM -0400, Peter Xu wrote:
> On Thu, Apr 09, 2026 at 02:31:46PM +0300, Mike Rapoport wrote:
> > On Thu, Apr 02, 2026 at 09:42:01AM -0400, Peter Xu wrote:
> > 
> > My point was that this is preexisting bug and that we don't need to rush
> > with the complete fix that will extensively compare VMA compatibility...
> 
> Yes, I fully agree it was pre-existing.  My guess is we only didn't reach a
> consensus yet on how to completely fix it, and whether we need an
> intermediate fix for "a VMA suddenly changed to hugetlb" only.

Such intermediate fix will keep bug backwards compatibility :)

> > > > This is still a footgun, but I don't see it as a big deal.
> > > 
> > > IIUC this is a real bug reported.  Actually, if my understanding is
> > > correct, we should be able to easily write a reproducer by registering the
> > > src addr of UFFDIO_COPY to userfaultfd too, then the ioctl(UFFDIO_COPY)
> > > thread will get blocked faulting in the src_addr.  During that, we can
> > > change the VMA layout in another thread to test whatever setup we want.
> > > 
> > > > Let's revisit it after -rc1 and please make sure to cc "MEMORY MAPPING"
> > > > folks for insights about how to better track VMA changes or their absence.
> > > 
> > > No strong feeling here if we want to slightly postpone this fix.  It looks
> > > like not easy to happen as it looks to be a bug present for a while, indeed.
> > > 
> > > It's just that if my understanding is correct, with above reproducer we can
> > > crash the kernel easily without a proper fix.
> >  
> > ... but we do need a more urgent fix for the case when a VMA suddenly
> > becomes hugetlb, because that could not happen before the refactoring.
> 
> Personally this is least of a concern to me. Hugetlbfs is so specially
> managed in userapps, so it is even less likely to trigger the same bug with
> VM_SOFTDIRTY changes or other ways.
 
I'm not sure I follow you here. How changes of VM_SOFTDIRTY can crash the
kernel in UFFDIO_COPY?

> Again, I'm open to any suggestion on replacing the vma snapshot logic as
> long as all possible issues got reported will be properly fixed, especially
> in the latest mainline. I don't worry much on backporting yet; if this bug
> existed for 10 years and nobody yet reported, to me we can always evaluate
> the effort to backport or skip.  However, a proper fix in mainline is IMHO
> more important.

Totally agree, a fix in mainline is much more important than backporting.
 
> Thanks,
> -- 
> Peter Xu
> 

-- 
Sincerely yours,
Mike.

