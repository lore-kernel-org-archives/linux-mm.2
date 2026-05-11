Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 535BCCD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:30:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC39A6B00E7; Mon, 11 May 2026 12:30:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B73E56B00EB; Mon, 11 May 2026 12:30:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB14C6B00EE; Mon, 11 May 2026 12:30:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9C8AA6B00E7
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:30:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 658358B33A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:30:30 +0000 (UTC)
X-FDA: 84755677020.07.4B33015
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 90C8B2001A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:30:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sBN9ChgE;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tKzB3n2pZ3f6uHbbaVkoKRbJGh4urMLgKHF9vhSQNpE=;
	b=Pp/df7opOxpEDgeL4KsCEy+3Lowj2b7YySxkZVSBrfXoTLx3mBCZp14cVKCVWkD1Ccrt1K
	A3sD5LJFSAlDc11vG5dgu7RPMr0DxVvEqBlS4AYfYx4uHTNpX5X8fE5kM6OCHfkSM3rHZu
	cXmpwddGbHs7rgz6C9zFDRd9zRtpbOI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sBN9ChgE;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517028; a=rsa-sha256;
	cv=none;
	b=W4HhiP2foTZrfYmCVhQS6eq97HYE/U4S1WHx7nRm+z/QYcHhDQkXCc3sdfeDcORkhyYMim
	6v7HCK29ZcsyS2HkAATswQONVXIPLwv1JyjcFNIOOGP6+NSo9xWNx6AkleMrX87s3q380b
	LqUgyGdL/2EtM4QBEH/5pcchmsbRP0k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 09C5C6012B;
	Mon, 11 May 2026 16:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40EFC2BCF6;
	Mon, 11 May 2026 16:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517027;
	bh=tKzB3n2pZ3f6uHbbaVkoKRbJGh4urMLgKHF9vhSQNpE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sBN9ChgECFXikL4CiwRCWlR+GJQL9QQffkEc6rcM5TI8MIdev0o/ha7GkDQoUNO0C
	 7hrjkfgjgLDjnRjR9lD58KA08S+zZILNxCrcnf6mDwbUS6K0y82V0Mky/At29fZVRn
	 X7npXMta/u3/4WDSou8l3DVig/us8BkUUO2XfsIMrPPNBEr636fRU4fLjkOENF+8Td
	 ir1t7eccTSYDnlVKrhGtFGRlD5GXfxWHOTMSVrSBiPKieTFyQ6+hYa5ImXMoJVrk5c
	 9xbVg/0sYsxMwoipVjZzBEKJTI8DUIE8wbd8QjtWWWcC7n0Jbkk9OVU8rZcTTF7zed
	 kF7HW9Mmzu9Mg==
Date: Mon, 11 May 2026 17:30:23 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: fujunjie <fujunjie1@qq.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] mm/mremap: unmap full fixed target for multi-VMA moves
Message-ID: <agICeiIEshWf-1xa@lucifer>
References: <tencent_863C8A01F3C81EBA238F375B16065CBACF08@qq.com>
 <agHmO4i4YUhs3cSG@lucifer>
 <CAG48ez1sLtSKVQLHbLO5usBgMgjyOGhbX29pKEfku4Ht05HffA@mail.gmail.com>
 <agH1ZSdX_7QF8P_I@lucifer>
 <CAG48ez17evhhcoDKF6AoPqzYZwGuFCkVAsc-0bBzevf0LHYNxA@mail.gmail.com>
 <agH7ONBSX7XLzS6q@lucifer>
 <CAG48ez0y3N9uEOzvr4N85Js4XN1fh4JiUFjW=PQB2UZ_5t1R4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez0y3N9uEOzvr4N85Js4XN1fh4JiUFjW=PQB2UZ_5t1R4A@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 90C8B2001A
X-Stat-Signature: ar5eaw1u5tf6turtu3dod31rsfuyg13w
X-HE-Tag: 1778517028-586113
X-HE-Meta: U2FsdGVkX1+RS+7hh2HwCilzLvvttFQWYGH9vrWmuV+LOcLU0Pc7i946I0CaRITNihMRJYnnJRz6grH44QBslUWpgRLbRcI/YM4bI2xfA80BZEnThA+ccUW3M0gIL2rVj3Nsig2TBeBYVAJhnDXH+WaOznyChmvPwOIRHMeKIULfDOGnbcnmCdievMZlhjjnpicgzM5PbaqEuMzUM4GbMQemWWKGtnwWdLvYbJWfkLbUQWbwVPI2oPNjxVHezADCBS3g5tUS7ZtZj+A6nIEnCVa/gRoFNoD3WIbdUniQeTysL/nsgbaP/nVcWUK13m5rJd/06LiLtZCcg+uIQ2YkoJNaQy3dM3bocHNRH9GrJNwSbnP0KG+FgSRcQQQHeauM9auPvl8lMSdvSzBhC0m8hrAesCW4wdDM889apbALqCdar/MbJJjPZP1rXxXx5Krx83Ze5p3CGUOEZ5AyRAaKJwePQCtjUQkUkAPbxDE31+Mgbf4ncNvdDP8MF7hUpeVljCoMCW5HCj6RxOnBnfPj34eGs+p9VWWFUyVtmfrtYPyj1W4xkjUF8Xno5j7CaKWgyTjGljhruTrL1oIsPcO9Pb0DVARsacZPdNoZfcLpPTWRHe6oHJhNdJCuLY16ja5tfJ1HrQB++gC66U7wplcse+iQ/YwOSvBtedomBl2sTglUgFhXgTw7juU8lSQEr5biYVgw0HJO2LGD+VXCzkfLiP+lm9cco0CXYjtNr/Mc+L9ety3x+r/hbyO6/rmQlrDmpIc5s6M/PdPngzOiZS4OIj6xjCDTYAjHAC8PTtMZrmV8JD8/Hsgz0hf1w6ZB684D2VkmwJ7Rd/ldD4CWmtbbMulv/uIAmsm2w4dWo0AcCa2P8Ax9xen8X6ZfTqt/EOY4wDjMiyhTvuRevNup1lzQY/NQwtK/auGlrRNV6bmmGP7cg7ULFwSp4ePcX+opy8hE1sCJuN1/iChndbn1i6u
 wL4YLwhv
 hepKnUKh0GI4K7yL+XJOS+RLlHPfwo4JMUGbVSka/Y5qRgxvVqL7r91+a9855yqjrlbdXqAzVjHCzlukLdZ80rXY+Wvd/O69AKDP4xnLKTwXFZFpYIIHkXjK4PxBq4t0n8tJxb2dEEKo7uan+RPxVP3SrC9pmSfvcOWEVvKsm05M13bktBHI28Qj20WjdzrJ83l0U6LxSWbr5s068dZ5DZhsPiAmVzsXW2Fy6syYCoYNKHqQJJe91c7KGGxXe5IeTEbeeOWrZDMS8apF+uT7hI+QlwXJyeI67RvSFTgXodXzzlNM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 06:02:37PM +0200, Jann Horn wrote:
> On Mon, May 11, 2026 at 6:00 PM Lorenzo Stoakes <ljs@kernel.org> wrote:
> > On Mon, May 11, 2026 at 05:40:24PM +0200, Jann Horn wrote:
> > > On Mon, May 11, 2026 at 5:32 PM Lorenzo Stoakes <ljs@kernel.org> wrote:
> > > > On Mon, May 11, 2026 at 05:19:50PM +0200, Jann Horn wrote:
> > > > > On Mon, May 11, 2026 at 5:05 PM Lorenzo Stoakes <ljs@kernel.org> wrote:
> > > > > > Hmmm I think it's a bit debateable honestly. The ability to handle there being
> > > > > > gaps is a _new thing_, so there are no semantics to speak of. Prevoiusly
> > > > > > mremap() simply required that you only span across a single VMA.
> > > > >
> > > > > FWIW, I think mremap() on a source region with gaps is such a
> > > > > hazardous operation that nearly no userspace code should be doing it -
> > > > > gaps are areas in which any mmap() call without a fixed address could
> > > > > place unrelated mappings (unless stack VMAs are involved, which would
> > > > > also be a weird scenario), so to use it safely, you have to, among
> > > > > other things, make sure not to use libc malloc() at a time when that
> > > > > could place an allocation in the gap (which means you also can't use
> > > > > printf(), and so on, unless you have swapped out the memory
> > > > > allocator), and make sure that you have no other threads that could be
> > > > > doing that, and so on. There are rare circumstances under which it
> > > > > could be safe, but I think it is almost always better to have a
> > > > > PROT_NONE anonymous VMA or such as a placeholder.
> > > >
> > > > Well, we're holding the mmap write lock so none of that could happen
> > > > _during_ the operation right?
> > >
> > > Not during the operation, but right before the operation. So from the
> > > userspace perspective, you have to know that there are no concurrent
> > > threads that could be creating memory mappings at non-fixed addresses,
> > > and you have to know that no mappings can have been created in the
> > > memory range between when you checked that it's empty and when you
> > > make the syscall.
> >
> > That's a very good point :)
> >
> > But I guess applies to any operations that operate over a range of mappings
> > anyway (madvise() lets you also do this, though it'll give an error code
> > _at the end_ _after having done the operations_ if there are gaps).
> >
> > So madvise() can have the exact same thing happen right? which is... fun :)
> >
> > I actually wonder if we shouldn't just change this to disallow gaps. It'd
>
> That would be nice...

Yeah let's go with that then I think :)

>
> > simplify the code and we could even do the check upfront in one pass. It's
> > doubtful anybody is relying on the gaps behaviour for anything real.
>
> (I remember that in the past, there were concerns that MM operations
> with multiple passes are slow, but I guess mremap() is probably not
> such a hot operation that that's a concern here.)

Yeah not at all, it's rather an expensive operation and if it's on your hot path
then you did something wrong :)

Cheers, Lorenzo

