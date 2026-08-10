Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C5A7C5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 09:43:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C8436B008A; Mon, 10 Aug 2026 05:43:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09FD86B0095; Mon, 10 Aug 2026 05:43:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1F036B0096; Mon, 10 Aug 2026 05:43:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D27176B008A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 05:43:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 329D51A0464
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:43:12 +0000 (UTC)
X-FDA: 85084871424.20.79A71A5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 976C6C000B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:43:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X5ogNfyd;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786354990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e8BIKK72EEk4vSL3MS2OzVc4EJiHSyxg4H3wiEsIixo=;
	b=P9V8woXNK5ijIMBKVvxgwSHi5n74iwtPiXAeE3jdEnUWciwjI7NinVb0DOxEq8Mjyz+l6M
	DTeFVFiRttzcaG9XrobEZ+TI6UN5+BEaKR4MoeQrVkm0uF4cxQHacAE/LVmTLuGZVCmcPs
	My09ziGxeGtEqmoS3QmT+qDqYc+l7QU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786354990;
	b=JZn7AwJtrJ3ShrekBFVVpklLb6F+RvCbHpMMIPgJz0QsbimkR8SVYmt0g7w6jGo0mStzKJ
	oG7IRDr9eqceDnKrIIH/2oG5ymGymFb1sm4lhV9N2GYCGTOOPoMpf2ltY/eZSAUd1p2hHf
	qLVD4F36mNJcy68girZBvAnVW4JSm5k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X5ogNfyd;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2BFAF60052;
	Mon, 10 Aug 2026 09:43:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD961F000E9;
	Mon, 10 Aug 2026 09:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786354989;
	bh=e8BIKK72EEk4vSL3MS2OzVc4EJiHSyxg4H3wiEsIixo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X5ogNfydnasoQr309886Ja2GO43RLBsS4PLRGVyttiCWNVDzlnuKnK9IQX1ibfqW2
	 r7f5decVshZ+9sjleIIazcUeWZjhxp2Na2uolb3dbUCPXH4ZEonsn90iy6mV7sqFjS
	 /pRjIpoHU9mumz5A4CQo9h423jYS4g26xtEUzEkP1OEcehl4whuMKSWdC5GFWOZ+ED
	 oP4oWpZhjEeiuxhLE0KWPNVVpw1EBhnB8a1/q74iZ+EwrGCWEf6czVYOm2yBskl/Iz
	 YQ4Jvxie7g8QgbtF04zkLqzlHYLf8icFlUGkxbHRKgUQa1xC0cee0UzX70Np/e9JUH
	 qcdR5LkZQpvnA==
Date: Mon, 10 Aug 2026 10:42:50 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, 
	dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, david@kernel.org, 
	shakeel.butt@linux.dev, vbabka@kernel.org, jannh@google.com, aliceryhl@google.com, 
	arve@android.com, cmllamas@google.com, christian@brauner.io, tkjos@android.com, 
	dsahern@kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 1/5] mm: Make per-VMA locks available universally
Message-ID: <anmcwYilggkd_-B5@lucifer>
References: <20260806200548.3124802-1-surenb@google.com>
 <20260806200548.3124802-2-surenb@google.com>
 <anaCkrk55EQoE2aS@casper.infradead.org>
 <anmQIeQIGkZdCKVU@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anmQIeQIGkZdCKVU@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 976C6C000B
X-Stat-Signature: 4cw7yfjbuy3wbpdcgwfdyspbhkythqwp
X-HE-Tag: 1786354990-722341
X-HE-Meta: U2FsdGVkX1/M7X2dxZM2Wi5UdBHYB6r4t3JxoZ2lpgUS7H8c7zcJRxarW6Tcb63aF6imzAmeSU3dBJ93DUE9A+53HrZVRFiGdFbnogqJXCnG7swZj2rwYByhMEJmXz2IKVIpIMErSSwGo7QIMzfoe/0hux3QDuQAQNXvkcgiwJKjlWzC8O6WqyCdg06XLOMNvgpS+SayARd9dTtQAsVrcNPvq/06GfSxOvGoaBbEsMayvHVSl676Ld2OUW65X5N/v3gpy05zs/z8bv4CiVgZVn0EXIpQodYEhG9QrG9lIrNfFw48mGqbHRLtfbmzi98qzVfXp+xaVo23alVGAict1OMCxNCBQ3hu8yWJDT41n5g/DMn40igDfWUIp62OBNX+DqnHSxy+mejcZjjS4FFKYtEEasyJmDVWh4Ps3ADSIRVx5H8SCianbWAB9XdTLZiFEl1Ib6ghKhUY9vAGOaR2eCxtI9mmiGeMmG6jNQZmxy0JUg4TRIlEbipIGbPxPCz3kMyr5GVroT0rdLV6LDjXIZaWegwRv61DoR28wUs6cJA003nAB3FIZ+mR9umSBOcxtoq947m/9xob+Ti3wY3HTiE8U9Kio9PDPTkn8+GVoPFY2B8lT+9L5GB/EBseT/4CDZ1Tzj81IT1Jsuc3M5+OOdZ6Luw0fG7XW4sxlV+jzyP3LeBYEbmpOC/PK5LoR4RDokvCggICvrjPTMKf+Caf7oImhOpITpMkJ5m+v9uTYQSvpixzfTnD8ezZ8DIeTMZfh+VvOWPCN1PHhRjvERFyyMrI7TjNhPPSiDplB1nt8PVJl/RvEjxr8ZFDnILKHl/T/LpZr+f3enTGHI83ZMQBHY53kk1pjxb3LIx7sJJRfIuYgTrhg0deoLAvoSE+mBgXWHHhNRjPxgusI/zuffukvCXamw7QxWWsi01HddfafBRYSHYt/EZCZNjMkY4x1FPcpFItRiSGaHjnjCVn4Qp
 MtXQDq8K
 g9+j4VI9wcB/8BdPt6AuqityFfjuVCpB1vSYDYHYwA5uLeJucHIUgedNZ4omNJKC9m8FRB7dod8y1gcbnDTNceo6PWb16k5hY0Zv10ZaQWioSccDeQx7mY6BdIP8kUmQMBZwtaK+6eG/P2owROp5cj7AbG9YiHdJl9sGnGYPagQ46aXh1unW298ZWlzsiiSUtq1HER3KLeBGD9KVbiHQD9YwiC1i4U0lpGAhVRRlU73Bce4757qljb7IZrm9yCMnJeABFEYoOSlLoerke8dAkL+2f1XQhStV2WTlfFDfHE4VVEwwZNCiTkf+11M6SmDyMhIWDLUlUxG+eWlU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 09:52:11AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Sat, Aug 08, 2026 at 02:12:50AM +0100, Matthew Wilcox wrote:
> > On Thu, Aug 06, 2026 at 01:05:44PM -0700, Suren Baghdasaryan wrote:
> > > +++ b/kernel/bpf/stackmap.c
> > > @@ -272,13 +272,8 @@ struct stack_map_vma_lock {
> > >  /*
> > >   * Acquire a stable read-side reference on the VMA covering @ip.
> > >   *
> > > - * With CONFIG_PER_VMA_LOCK=y this returns a VMA with its per-VMA read
> > > - * lock held and mmap_lock dropped, so the caller may sleep.
> > > - *
> > > - * With CONFIG_PER_VMA_LOCK=n it returns a VMA with mmap_lock still
> > > - * held; the caller must snapshot any fields it needs and pin vm_file
> > > - * with get_file() before stack_map_unlock_vma() drops mmap_lock, as
> > > - * the VMA may be split, merged, or freed after that.
> > > + * This returns a VMA with its per-VMA read lock held and mmap_lock
> > > + * dropped, so the caller may sleep.
> >
> > I don't know if BPF is compatible with !MMU or not, but the comment
> > is inconsistent with the code.  How about:
>
> <requisite nommu rant>
>
> I do think there are components that simply don't think to depend on CONFIG_MMU
> even though they do.
>
> In fact more than think - have run into exactly that before.
>
> It's another thing that speaks to nommu being a legacy barnacle that bashes us
> on the head fairly regularly for little to no gain (and nobody is testing it for
> tip kernel AFAICT).
>
> </requisite nommu rant>
>
> >
> >  * On NOMMU configurations, returns with the mmap_lock held.  If the MMU
> >  * is enabled, the per-VMA lock will be held instead.  The lock
> >  * should be released with stack_map_unlock_vma() which will release the
> >  * appropriate lock.  Once the lock is released, the VMA may be freed.
>
> I mean I suppose it's accurate but I don't love the idea of essentially implying
> nommu+bpf is a thing and also treating it as so important that it must be called
> out here.
>
> I'd rather it be inaccurate for nommu as are most comments in mm and mm-adjacent
> components, it's kinda implied in general. Those who care can look at the code.

Actually scratch that I'm wrong, firstly Suren's series explicitly does some
nommu-specific logic in the bpf code and secondly BPF already has nommu-specific
stuff in it.

It seems nommu bpf is (kinda) a supported path.

>
> >
> > >   * Returns NULL on failure, in which case no lock is held.
> > >   */

--
Cheers, Lorenzo

