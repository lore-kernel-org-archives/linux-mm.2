Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8ED6606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 03:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oFarsq5d
Received: by kanga.kvack.org (Postfix)
	id CE2126B05B3; Sun, 15 Nov 2026 22:17:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB8BE6B05B4; Sun, 15 Nov 2026 22:17:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF6606B05B5; Sun, 15 Nov 2026 22:17:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 94EDE6B05B3
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:17:17 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E895808A3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:17:17 +0000 (UTC)
X-FDA: 85439521314.20.ACAAFBA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7547C140006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:17:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oFarsq5d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794799035;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WBniCx6iTdMXGZKXHCATtRQqr8VOEAwfqWsRZ4fWJh8=;
	b=bT2AuFHuEwQpgWiZ13Vz9bqz+ONPbU73V9mP5+YXWoJscTQZsX5HtkFD+m0PqKD71zdQPK
	94GKOlJdw4W39s8f2RfpkAkgkbbZbLC0GlBybYq8pc/Z3GZAVC/W/ungY+jn6wNeWKz1qU
	t4EY+pj0cX6KKVhajQS2yTENUSnfviY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oFarsq5d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794799035;
	b=a1WtjdYKO+NjNr7BlSJ6Yo2hBsBK9OMpAfSUNSgVxsg+7qHgb6GTx3vAeTwf1NAzwR06Or
	ZfXympnYSkyEuATMP+OdeNB2Yd7C4zWhZnvK45Pyr3eQqD6V+5twdOkYsyzQgpmvuupfC4
	YbQF1BIo019EvWWAqlgguCUySe32HF0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C05354166D;
	Mon, 16 Nov 2026 03:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37FD01F000C4;
	Mon, 16 Nov 2026 03:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794799034;
	bh=WBniCx6iTdMXGZKXHCATtRQqr8VOEAwfqWsRZ4fWJh8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oFarsq5dLj00U6+i82cydfwhdOmkxWDp68WFYN8LRtZ9V9MD/Sv2asQ9XYRNJzMqE
	 /53URxjCWGdNfNmfqkL6pTNlg5bw+cDJK951xH1WO6RKdV9Ux+C9UMIk0kZTvYQ/n3
	 B4unSfY9eUP0PSPC1Y43CgrMqN+GBXqkjHiEIX+EEru9q+NZ91uDzMC1XlNHlVU4qG
	 caGzinn006wWaZ+qBtBAa1wylsKq2R8LqVYHPv4A4cGSJbOQk57eGEdmjELlwvzguO
	 FDTkE4FMeM19mCXArcwCaI2iupVjU2ymNzlP/Ys6rrdEQwhOGsFGBQ+D+Tv5n9o+El
	 mwYtdkR7S8U/Q==
Message-ID: <sashiko-outbox-216113@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] lib: xarray: free unused spare node in
 xas_create_range()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Morton" <akpm@linux-foundation.org>, =?utf-8?b?TWF0dGhldyBX?=
 =?utf-8?b?aWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>
Cc: linux-mm@kvack.org, "Shardul Bankar" <shardul.b@mpiricsoftware.com>,
 =?utf-8?b?RGF2aWQgSGlsZGVuYnJhbmQgKEFSTSk=?= <david@kernel.org>, "Dev Jain" <dev.jain@arm.com>, janak@mpiricsoftware.com, "Jinjiang
 Tu" <tujinjiang@huawei.com>
In-Reply-To: <2dfabfd9476542e39c7d5473a6597208.1@linux-foundation.org>
References: <2dfabfd9476542e39c7d5473a6597208.0@linux-foundation.org>
 <2dfabfd9476542e39c7d5473a6597208.1@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 03:17:13 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7547C140006
X-Stat-Signature: u1co5j5559dge8ezck766unrautadc7u
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794799035-75273
X-HE-Meta: U2FsdGVkX1/H2ZzrDVgYkczxaYkQsZ+D+nd1IkFLPvLiWQl9E1aKYztrNQfbSmFcnHD4c1Isyx7ecE03bvbca2/2Zba4iTIjl8ttkH2kcyBWFeOBbmFeJqeVgccHVMuz8NmGweLJtLnuyIBJYtgsbOZgKuypao7OTYXEdysMaC5bb+aR4B04Gh4vQjNpJ3lSjWctQ7rtVM9zAWFTas8OLp1rT36W3OOqXuOW+5dczw8CCbQ40xsuh+VNFDACi62S8n+/w3/ZfZf6QRakUu8IMqnuUU4zjvmlVTsb+NDAOMGneIT0sAAaGKGQyIDHHOD2YFBih5ONc2DOWelGVUf6PTpSi/GMzdUBjkWlTuxn9mTjDd9StdnrIYebg8ZRLNN/oKC04IN6xCUU89IwZTAReFbqvtzlUAQHreDjwfLpZqALtma4FcGlrp2f2M99jOCpYeA4g9l8B51NN9c/sr/9s9G3u8g9XNuAad6aMawXSshdvBlbbAdyDJqKxwFq6WrI88JEI8rhil5TAlemUJYGrg2mkuTiNgvUL+3to17g5PU/pG+pK1GFON8Pkavx5jgJdqRDjgGy64CiMsq+Fn7gA41+6RifuQdQ41/EpK2nCvKvyDcrL8adpMcaYwFNBbGeGzh0d4L0cxTlv23kPsrr/I+++xreictU5U9KtxTH29GweqIYjyyK15512HAYAfmnv5tQQVFw+tmEDmEUimOlTHetKv8X6xa76FWYrocAnSTjds0Iqy1fELepZk+vjN+40oGtcPU5bw0gleROSOLpMzVponAxIYirHx0Gz2gJQNW77TwAf3zTHF68bmkXqzj/SiGV26FhxGKHRFOchujLSSjWYF7BtsoTl1kk//0/Qjn1/ObtV4T1Kynf9cwRZaeJwTWgGcj/mRB948pIqMPXZ98duY9w7kD+Cy6WAT/cvI8jZNfPvlG6F9CQ8TVZeCZqXx/qn1CFKr6HlXlJE4h
 mSHlpwp3
 F60FqUtdFmB9Lr47JGuA5LnnU+s/FOdZG8GkGmJmH0WLJUmoZAs72/syiCBSlAeM+f6iSJuDsm8hDK43ZDc7Gaa9vSxLBWIkg7R5Byrke+bBz7S6DEZbhsw6pypsiRkVBoupXBcCSXOh1y0PmGqBLcLsST9c0UaCZ45m3IEvagqkureqPtVhtCQ2wdodont1ELWHUseAqrZ/NK6v3mQPUyoDWQPaPf4HbExghRBi/hHMtNfWANwRZ5drnNTmTn6P+h9noG2fgj5i44jsK8cyFBVQrN9jsH4lNYy/rY1BxbRYzGkSf6rrudgTHe0f+KngRpguhxc9ZQPTzfotchW9XMUGhTL4uXABp1IqkfmsUGkcSMuIQuq0H831h6f6D0H6dPbwwX5glhHnwbUXfI38gVGD2ffwo+Lstl29eQVLkzEihzZAKGtA0L+RwC1RJYTP44ROTGEfDvTxPUvvz6B23dBnlVeYqesgyqOcBASdSEBjLk+nYGeDsT4IPRWETFrj52Xd6ksvUbPUDZXKMP87tHPnlbD8eo+kLar154//ctXVBlV1BTTYE/nTl2Q5kWcvHxpw5jODm3rBDZIrEnW2NFQ2O76tlsolCu7caaXdax36BtbGlxLtNyxaKNCsCCdWt/ZK9PnIEy62QIPMwpyNcJzrtEdR79qsPpxAZ++8I/XhaieWYQloXnNSj9I9U5oH+dELBR3t1qSXjP1mnoxXq69V+d7a0y2LeTLDoFxTULM/GmLUaaGMBRMovsWcf6VQzd/UtsDdckOiu08CXGXnKgtGFOHced75hLYXBb4Qf0wNR6vZ6SfMNFJj3yoC14wwnFF4kDhfsocf0AkdX3w4cu57uX46zpMqm2t3hdGp9Sx1tt+obqYsysy5NoZLwiAGLc4xcixDE29Iv2TOC0lJz/QYjJ07MM+cqI9EcM1QClFWBC7V127gfe+K3t7c78SeCuM4CwzlulXAZgOJLBq3JMJH0w766
 mQAHIbl5
 YS/oBCDmXAk1vOdlAprhSZENx3iJrR0vDDn1FBCOmu1AkFSRsING6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] lib: xarray: inaccurate Fixes trailer in xas_create_range()
  commit
--

commit 844089b2ad8c28a781a9ee223d1c1eac3cd107f2
Author: Shardul Bankar <shardul.b@mpiricsoftware.com>

> lib: xarray: free unused spare node in xas_create_range()
>
> xas_create_range() is typically called in a retry loop that uses
> xas_nomem() to handle -ENOMEM errors.  xas_nomem() may allocate a spare
> xa_node and store it in xas->xa_alloc for use in the retry.
>
> If the lock is dropped after xas_nomem(), another thread can expand the
> xarray tree in the meantime.  On the next retry, xas_create_range() can
> then succeed without consuming the spare node stored in xas->xa_alloc.  If
> the function returns without freeing this spare node, it leaks.
>
> xas_create_range() calls xas_create() multiple times in a loop for
> different index ranges.  A spare node that isn't needed for one range
> iteration might be needed for the next, so we cannot free it after each
> xas_create() call.  We can only safely free it after xas_create_range()
> completes.
>
> Fix this by calling xas_destroy() at the end of xas_create_range() to free
> any unused spare node.  This makes the API safer by default and prevents
> callers from needing to remember cleanup.
>
> This fixes a memory leak in mm/khugepaged.c and potentially other callers
> that use xas_nomem() with xas_create_range().
>
> Link: https://lore.kernel.org/20251204142625.1763372-1-shardul.b@mpiricso=
ftware.com
> Link: https://syzkaller.appspot.com/bug?id=3Da274d65fc733448ed518ad15481e=
d575669dd98c
> Link: https://lore.kernel.org/all/20251201074540.3576327-1-shardul.b@mpir=
icsoftware.com/ ("v3")
> Fixes: cae106dd67b9 ("mm/khugepaged: refactor collapse_file control flow")
> Signed-off-by: Shardul Bankar <shardul.b@mpiricsoftware.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: David Hildenbrand (ARM) <david@kernel.org>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: <janak@mpiricsoftware.com>
> Cc: Jinjiang Tu <tujinjiang@huawei.com>

[Severity: Low]
Is the Fixes tag pointing to the right commit?

cae106dd67b9 ("mm/khugepaged: refactor collapse_file control flow") only mo=
ved
__SetPageLocked(hpage) before the xas_create_range() loop and changed the
!xas_nomem() failure target from out to rollback, where xas.xa_alloc is
already NULL.

xas_create_range() was introduced without xas_destroy() in 2264f5132fe4
("xarray: Add xas_create_range"), and the retry loop in collapse_file() that
breaks out on !xas_error(&xas) without freeing xas.xa_alloc dates back to
77da9389b9d5 ("mm: Convert collapse_shmem to XArray").

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/2dfabfd9476542e39c7=
d5473a6597208.0@linux-foundation.org?part=3D1

