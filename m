Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A940C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 10:31:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A1906B0088; Fri, 28 Aug 2026 06:31:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 552B16B0092; Fri, 28 Aug 2026 06:31:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 469076B0095; Fri, 28 Aug 2026 06:31:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 275F06B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:31:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A6F01402D4
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:31:57 +0000 (UTC)
X-FDA: 85150312674.25.3DE6653
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id E3BB316000D
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:31:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P989eIXz;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787913115;
	b=byRNPdOiFVQqmZoYPNvJXapRO/9regtVuvyQ9l3e7gr1j+xouFX0v6Wq+2oE5QhFmULujE
	eTLVACJJUI4nKLVN7O6r3wWRwN3blpwrHX/vARupmokvOmjnhHmdZLwJj4i7JZkhGMIf23
	ci1e6kiA4E5zFo29dUPHFHC5FjWWTiQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P989eIXz;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787913115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VLmy+23wSUMzFyOWBFEJkdW6wQyehsnhIV8JJJbWhJA=;
	b=O69O0epI4dnatHYZvzehGfHPyuzGkwuIFL5ZSqUwqDJOQtZJ1+dC+QqwGXNY4A8iT6C/cq
	GbgM7P+3h9GachK0rTUOahedgZasJoyWBtbukQF8qm76K4rTwVZsTrsCk9gZIPhEP9Rg1y
	PJh67sQfZco0ydxhQzg+AYajjeNePkE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E6C96020A;
	Fri, 28 Aug 2026 10:31:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B03E1F000E9;
	Fri, 28 Aug 2026 10:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787913115;
	bh=VLmy+23wSUMzFyOWBFEJkdW6wQyehsnhIV8JJJbWhJA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P989eIXze+S82yL2CVHsL74+giO6o33ilLH9BPNZn0niAdRKaHqMhWO7/NSTDr6H9
	 Eew7wwFmGkmovJVq+UmD64uLpJoJDCxE7UbFoBXxEeCbcJk/H4Mm3PN19Txi9312Ew
	 +lE0dy0ry+lkzp2WJKe39CpBwaPy3dql9U7K2CNbU9iBq4bXJNwVoltY8BROi7R5qb
	 Hc4O59X2WWHfTaw+95o/hy8Ie8Bc8UFT9aeLV1gL5ELMOEKoekGQ+5wUUhCqiafGx+
	 iuqeChfF+32+ZTbGrv2DG7FhlXkz8EQZa/ueGq0p+zzPy7Ak+KtnGLtJ4DKSGVrx2m
	 y8sH74ZBQiJgA==
Date: Fri, 28 Aug 2026 11:31:47 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
Message-ID: <apFhDA4e1sBfDOeh@gremlin>
References: <20260828-fix_split-v3-0-374022586a4b@arm.com>
 <20260828-fix_split-v3-2-374022586a4b@arm.com>
 <apFMvo8pCzaGKope@gremlin>
 <apFgVvNMbdhYnu6p@e129823.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <apFgVvNMbdhYnu6p@e129823.arm.com>
X-Rspam-User: 
X-Stat-Signature: 9q3gwzxs9ffsn1dp1ziyuoijynq8tzuo
X-Rspamd-Queue-Id: E3BB316000D
X-Rspamd-Server: rspam06
X-HE-Tag: 1787913115-486988
X-HE-Meta: U2FsdGVkX18kRGS2D9j55QtLXBOnn62NcZDy/WUgCn7zcIpBNbEXlJcw2yeiC1P4pV7+OtmU5riB+1g/o3fzEpqyopj2LvbXXm6d+y7eax/So32FWBW1I3kM5rTVb1CPXnb2nb468FoG0eIbR1xvLsBae8rOatVY7PncqL6u0If1j2OKeN+onGAu+VtMPmmTke56ePZSJczjGQAQJM0LiA1eEo15x/VERzqSqvmBZpL6ZluEDTyTBVQKGU3d5h/0Z+hidLB2CqjUYNvUdBSQDxT/T5wvGGMEljsCh9ghYBMUaCYCCWtoJ/FCgepwxz1QnNrjcKf/ombIcaFYIqRKXrNQ6BvBjbqehBF4I1ujA+v2nvr0Orn44cwRPglhiyMiqnP6uez7AHiscjcCkIGgGu5pU8h/VcNme4fO3n5geCjcV2FptvsAX2psg/1kTZA46talJaOhUqR5n0KOuE4m3vqvk3GWo+u1OWQnGTIBvGfq+yJVZTpCkrrmmykxA55ni++UTE1Kjke9ByOpxTzDRtXmNzEKmTvqGomGDKrJidKTMbC1LAX2geEBBU75zyEwBWPwDZ7reJk8m1qc4fTRrMmMFEq3AEvjN1TAjIFWIqGRIZF9IKwgaJqdscaebMw3BPce8zXqaV3oBWR7zwnqPIG98uXWvqAyClPXTnRGJrWNs7JyQCU2Q1yYOSSVBrC1m6WDn6a6UcbdPWq8UY1oDJn6SvRlDUbW6nMuJdF5A0ZVy/vyFUP4We4CcWH1W6e6OaE/J28729tG1tFFN4pVtf7oWxAJ9i+zr9bEE4PGPLdTTJPtBNx2kdloCdr7Y05k6WROsIirUJDU6BamAnXmzpwX5WtfOjg3T0NVMQqt1X4hBTOb3BGyopPesc/bu0wVBG7XWdbeBB0o1gKoHuoUpcBab2ZlXD+RQkY4tYRaWoY7D7KdtzNK1iHtE9d/fFC4dE1NDXwUvaZWT/zmLpc
 HRe4kYMx
 IdDPZbmkoHFvXNRZNziZK1IWm2GbWBvIkjMyPs4d5sUNQorrSzdLAycGCLGCPq1KJiFBz/iBuPgtd7KgUBfVvhyTB9CA4BUq00UnO4i74w/VjDpCbCpcH7dEwUnNyDD8HMYZO1QiUFKQJbVSmESxeqr/oxEKE+NNzv3OajRg32LSIm2EYsvdjbAjZboMd0+3eCobKUSTl0xzniW/S9+5LaSaLdTchXAm5l3vk1MmC08CFDfM/8uhgnOCC3Zxu00WKuc79DNwv45gUExsZaIJ3Iuzn5OjF174fx23r4Bs8kjR7QutwdRZp+KKPsno2/+VXRnvr92q0BCQk7XxTT2I031Q/bSRk5V9uf2ym
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 11:17:58AM +0100, Yeoreum Yun wrote:
> > On Fri, Aug 28, 2026 at 09:11:34AM +0100, Yeoreum Yun wrote:
> > > Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
> > > glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
> > > made by memalign().
> > >
> > > The underlying VMA may start at a different address from the aligned
> > > address returned by memalign(). Furthermore, a subsequent
> > > madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
> > > already set.
> > >
> > > This causes split_huge_page_test to fail because the check_huge_xxx()
> > > helpers incorrectly require the address returned by memalign() to
> > > match the VMA start address reported in /proc/self/smaps.
> >
> > Hmm, is the test correctly putting sentinels either side of the VMA? Any test
> > that doesn't risks flaking due to unwanted VMA merges.
>
> I believe that with this change, we don’t need to worry about unwanted
> VMA merges when checking for huge pages, since the test no longer relies
> on VMA sentinels but directly checks whether the mapping is huge or not.

We always need to worry about that though, anything that asserts stuff on a
VMA level must prevent unwanted merges first.

I guess I'm asking you in a roundabout way to go check and if there isn't
isolation like that (i.e. mapping PROT_NONE VMAs around the VMA you want)
then to go do that :)

I think glibc going off and mapping a bigger VMA is possibly a symptom
of this not being done.

>
> Also, this flaky failure was not caused by a VMA merge, but by a change
> in glibc’s behavior that sets HUGEPAGE for sufficiently large areas.

Yep your change is worthwhile reagrdless! :)

>
> Might for the *NO_HUGEPAGE* setup, there would be a chance to merge
> VMA area, But since it seraches the mapping directly, it's fine.

As above, generally we should put this protection in case, even if it's
unlikely for a VMA with VMA_NOHUGEPAGE_BIT set!

>
> >
> > >
> > > Fix this by using /proc/self/pagemap and /proc/kpageflags instead of
> > > /proc/self/smaps to detect huge pages.
> >
> > You should probably call out the fact you're doing some refactoring here
> > also!
>
> Okay. I'll spell out with some detail. Thanks!

Thnks!

>
> >
> > >
> > > Reported-by: David Hildenbrand (Arm) <david@kernel.org>
> >
> > Should always have a Closes: tag if Reported-by: ideally.
>
> Yes. but talked with personally nothing to close. So Reported-by tag
> only. Would it be better to remove?

Yeah or Suggested-by maybe? If he said it to you on-list then a Closes:
<lore link> works also!

--
Cheers, Lorenzo

