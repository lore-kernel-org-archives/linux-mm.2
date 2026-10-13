Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46A56CC6B08
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 14:29:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4297A6B008C; Tue, 13 Oct 2026 10:29:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D9516B0092; Tue, 13 Oct 2026 10:29:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F0BF6B0095; Tue, 13 Oct 2026 10:29:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 16D526B008C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:29:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A2C2DC0C29
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 14:29:16 +0000 (UTC)
X-FDA: 85317835512.27.BDFA61A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id DAD724000A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 14:29:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LUxB4Wpy;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791901755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7qKNMiH2w4gu5NE5Ep8GYbNYJWZz1S3YluBpBbHkntE=;
	b=f8Gu2Fgz7IOM/TuuiAqwK61UtxUUCJEnjftSc0knpqsfoCsVk5AylQawnh3x/mNVyxHPtG
	UczKx/uWtCENbTnz2GGn7iEPkZWV5p08Ykf4FY7BD5PmVnxRr7yLgFhFtVSPUapPEpS6XP
	/wE9koFEhi5vPZC4MVvEZdkhsTHr0Dw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LUxB4Wpy;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791901755;
	b=mb8yXCBpIuFPRQZJE91j2B3/Sx5UFg4UsZon4vmWXetkPthRIH1XPlHCay0HWRnHRDZmFb
	2wAPdVN6a29IDAPRyk0/vPUtMjGoe5NkIHRhSjbGBurxXISXXAQsfUc9R+IlBQCkk1Vvf7
	Bi/YBwabck53C2Z1BNZlpgCZhbTylEA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C5DDD42E34;
	Tue, 13 Oct 2026 14:29:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32AE91F000FF;
	Tue, 13 Oct 2026 14:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791901753;
	bh=7qKNMiH2w4gu5NE5Ep8GYbNYJWZz1S3YluBpBbHkntE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LUxB4Wpy4M0NA/auUkF3ugzHwzl9yI2Akd18tG6e7Wd+FVpo90FHoQkUmsjoQ/CZ2
	 47peU4JJ7n84TwVTZASc2hIZ/h6OQcE2VP1/G6MGlMPX7WOM5E4NhtGonekT2SkXTa
	 Qku9hWMU1SUQBG3UKn33NnZ6lMWsvhSV/SkGi++l/LCHLkmqGAev1nHip9ImhXkScT
	 ZnyBGlx5fLgOuTbOwAVTpLlpHSqlKtNv2DtqwnTw7PidO8LFLEJi4xvLhGK7AxH68x
	 9BI98yhjX34QdpVDlC012GsUwaPtRA2Y+Kp3PdC0Tm3amFXF+Q55wdEwtRGUVBNjSE
	 IPmaM1qdncb3Q==
Date: Tue, 13 Oct 2026 15:29:11 +0100
From: Harry Yoo <harry@kernel.org>
To: Imre Kaloz <kaloz@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/slab: sample slab_state once in kmem_cache_destroy()
Message-ID: <as4q2WlR7mLhMBpG@thinkstation>
References: <20260930195110.13296-1-kaloz@kernel.org>
 <ar5pESlkEMqNsgxv@thinkstation>
 <aef97b97-0bd7-d720-7f59-8c0078747370@kernel.org>
 <as4QhUscRVtBzYpm@thinkstation>
 <481e9a16-cd30-d463-14ee-b5602bcd5a21@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481e9a16-cd30-d463-14ee-b5602bcd5a21@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DAD724000A
X-Stat-Signature: tajje5e8zwmj9d18t443zeyecafz6d15
X-HE-Tag: 1791901754-918905
X-HE-Meta: U2FsdGVkX1+9N/6EuiYRFaCqXI7tXzUbVTejq0zQn1ENCLVkWcT9kGZp2cFwsY1m000NHz5QYWvF4JYD8KVLch5jzFS6rzqwU1PVMAnXRGnb/pWSKPCcifwcGrgqZYE292/qAztIRSJyA3yjI0KotOPIfS8Q50+1rZLVr6ntkVpAr4rxsO2TmyicfGMSX2oL0/fNDtyP94HNZytdNAH+lom1IyxfykoZoAK/n3l0au6RfsDHiVSix5iOAc1reSxOEN26IZRK6kNAM0hrEuoCRZYk7P7OLFI9g8+fr9z4BWHPMuK8B8uCPDG77MHXa9DeS5J3LpQPLEZ6pwM7UTNyXfjsyEeXp8FV1owzivCa41Egp6Nvq0gmdnIqEvIQjbhzJ8Tr9V4v6Z8VASaeEVwZORidczoY69d48DDXPeKg8jTeZVQBNyuboDkOAoIf8txK5fr7LMWTAvfao0q6l2dCMSONU5PWfLFZOcOQKH3pw7ClZtWmQjHMEfU4BbTakfsUQ04iD4pUIu5m6dXowR1/y8eralAWR0oTmHop6A4AOv5K//jjFZFie7KoocsuSlgdFNHzAeh8mLbZJ3GruZanCUw2dTy1ihhQ1JQHxBPvQl3gqWMOzpFxdeGooi10pBsf3pvy0WQeWGXDT6hd3LaSHLU7lXbopK66awffKz31lIbK6toCdNkUlL+ZWJCGPlu6L9AUNFFGc8oqNNUNqKSOKVE4xrvpcYWl4B12sqlgJIM39JWTCMCFsnNDaNu5IbGMBTtsrylznF/z8jQ+FphYoDgjwTQetDLMe3Vmt688gzkP9B/yifGusxKfFMiiypGsf564Ku7muxiuSAC7c0g5sR+QP3xT5AS1oi3w4wOTt8hHyjWErG9KFB4EUZM4UPRCCY9/HOL5GLUJQkqsR/98ptOajRN95b7PC4uChwnnnzfIGnFaQ5D5NhBdlP/5U8gpo4Ai3D/xE0Bkw4sUKSG
 nPqbDq53
 gMjTMODz+DgccH4B2UtwAXZ45kJV5qIiYwkv8gWTgA7g1LpGC6inEUNtt9SYso9DX6mvm7Q8MpVRAB0gSzLz/xfUIUOY9H8v15dLgkky/YLNNhxOhmgBDS81kvpwu3LXDeUxylEWfy79I+i8+JIEVTzTnO2LAMCFLgVQVGp1/IdpYGFO/scfVn7357u8TXFbxy2Hm8qg07XsaBHGIlp0oeae9t0+eYOCrSyzQLKwUn4KwPheHbj4YG0JinZrf6Mj0m4dTQOMTdusI9jlSiuC+9Gh5zHY82sKQJMut4ba4hFUOGMk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 02:51:30PM +0200, Imre Kaloz wrote:
> Hi Harry,

Hi Imre,

> On Tue, 13 Oct 2026, Harry Yoo wrote:
> 
> > Uh, apologies for the late reply.
> > Catching up after trip at LPC...
> 
> No worries, hope LPC was good!

Thanks. It was good.

> > On Thu, Oct 01, 2026 at 05:42:36PM +0200, Imre Kaloz wrote:
> 
> <snip>
> 
> > > There is a related older window: after list_del() and before that
> > > single read, slab_sysfs_init() could set FULL, skip this cache, and
> > > the single read would then call both unlink and release on an
> > > uninitialized kobject.
> > 
> > No, with this patch slab_sysfs_init() cannot set the state to FULL
> > because the slab_caches list and slab_state are protected by slab_mutex.
> > 
> > > I have not hit that, and this patch does not close it.
> > 
> > I think the patch does close two bugs.
> > 
> > One introduced by 4ec10268ed98 (reading slab_state twice),
> > another (reading slab_state outside slab_mutex) introduced by, hmm,
> > not sure which commit introduced it :) should be very old.
> 
> You're right, I got that one wrong. Sampling under slab_mutex in the
> same section as the list_del() means slab_late_init() either sees the
> cache on the list or we see slab_state < FULL, so the older window is
> closed too.
> 
> As for where the outside-mutex read came from, as far as I can tell it's
> 0495e337b703 ("mm/slab_common: Deleting kobject in kmem_cache_destroy()
> without holding slab_mutex/cpu_hotplug_lock"). Before that, the unlink
> and release and their slab_state checks ran in shutdown_cache() under
> slab_mutex.

0495e337b703 Probably yes. Not 100% sure.

It's quite messy, reading slab_state has been done inside, switched
to outside, and back to inside, and so on.

But should be fine as long as we can find the first commit that
affects -stable kernels (>= 5.10.y)

> SLAB_TYPESAFE_BY_RCU caches were already released from the
> workfn outside the mutex since 657dc2f97220.
> 
> Want me to send a v2 with a second Fixes: for 0495e337b703, or is it
> fine to add it when applying?

Could you please verify fixing which bugs resolves the issue on sparc64
described in the changelog? Reading it twice, or outside slab_mutex, or
both?

-- 
Cheers,
Harry / Hyeonggon

