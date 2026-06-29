Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 919E7C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 07:31:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A6536B0005; Mon, 29 Jun 2026 03:31:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57D8C6B0088; Mon, 29 Jun 2026 03:31:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 446DF6B008A; Mon, 29 Jun 2026 03:31:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 13D5D6B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:31:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7EA0C12059B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:31:35 +0000 (UTC)
X-FDA: 84932130150.27.49234E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id DB886C000A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:31:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RPpyMNwD;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782718293;
	b=y9BRibPgU4IH7Jn7KrOANrE2pan8/qtIXrFM7GH3nbLTWD5BeFsVxNTvYpJmHKkmngu/1Q
	pTl95wocizrvqt9VFtw0kZ2CylJ0Hd6V5kMb2DchqZ7L+IDZ1viPEI/SOGPoLvz4YfTDsQ
	4kP2+Wb2BawaL632kR6Uj80GEBHEYZE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782718293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gfFSSbFa1kkiEFju+F2cWFK+kFerBLm7T/klRFOuIwg=;
	b=3k0+CB3w+P6+nVru+glPqw5jZDLRq7pZAMMIEPHWoVS3t3bFUa4RWexTjI8u4u+GkjxruL
	yNHHG86++r+K77bOQzk3w+1ht3LLqW3eOi5F3boNje5jJGgSUgWphnRS58LtOFUB/49T/t
	RZn7VYIurqFAwosx67TJmShc16goa1Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RPpyMNwD;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 09654419CF;
	Mon, 29 Jun 2026 07:31:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA2251F000E9;
	Mon, 29 Jun 2026 07:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782718291;
	bh=gfFSSbFa1kkiEFju+F2cWFK+kFerBLm7T/klRFOuIwg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RPpyMNwDxysjUcOYZ4W+pforECuPsD7hMwvFilq+ds9qaGhx1Igu2VE42OfdXIsQy
	 ZzDXfSX/hk1IUtpf3E4WAW09xj/bDch7THnUpa5oUa7aSX4lOq/6SciAFiGOr/XquU
	 6boEJD3X4bCxX3SK0foOnvI7rwfvikUW2jM+0kaKSgzAhOIe7tFcIRm/6ZbSSMJWCK
	 /UAIzIs/z1ArHGGH/37tj0FGbmOpGGvAyjoqqnDhMvD2rhqx70PENKtqRq8lAMzzy6
	 l2SfLXFGOu/Ckq3xO2wVbcbhxGlrUEzrG2kFJjPXivhlkiEnP/3AYhWk+MrFk6gZYv
	 AYwoZpNALHhWg==
Message-ID: <b50be148-f7e4-4c11-9893-54d4278b2e32@kernel.org>
Date: Mon, 29 Jun 2026 09:31:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: WARNING in usb_free_urb
Content-Language: en-US
To: Michal Pecio <michal.pecio@gmail.com>
Cc: sanan.hasanou@gmail.com, vbabka@suse.cz, akpm@linux-foundation.org,
 cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 harry.yoo@oracle.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzkaller@googlegroups.com, contact@pgazz.com,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 Mauro Carvalho Chehab <mchehab@kernel.org>, linux-media@vger.kernel.org,
 Dinghao Liu <dinghao.liu@zju.edu.cn>
References: <6a3eeead.7fb353d3.354599.b0b0@mx.google.com>
 <85cf5045-b52b-4aaa-a038-ca1b856b55f9@kernel.org>
 <20260629092033.4a83e91b.michal.pecio@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260629092033.4a83e91b.michal.pecio@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DB886C000A
X-Stat-Signature: y74rucfchpdkfdq1wiotpp1uq1muwq75
X-HE-Tag: 1782718292-563651
X-HE-Meta: U2FsdGVkX19UhSoI6eZJ6NIVz4MWBdoFAFsyP8BH7LuEdodh7NNFY2AfrFZn5x5Nk6VfKs6EmswI4cXS7mAwtDtKRfV0W6q2gK+1ikFZYGp1KZ8dRQ/DkskKtVuQoLb4z4av7qWHeJTegfCtS51OppH5KHYtXco29vRu+bgLyBlHm2NQ+HXo7CLB4TBK2PUlJEeZ68u02faytjXxu9p8EC3OYVGOcmFnJqciJlnJIYbMkrUo7sCJWodt9aLbvYl6DMTOl0eDnk54n3f4ayidQI2L8K9P5bferW01t7pEwYDTTw0OZqzTA6DxXdxLVIyK8iaYET7inZemqejeTqp4u6aGnNYFGufh+ErDXU5ZqZwiadainExOhVMZ0jE43tj4Mwb6hgN0cWP2GdUCrJ0yYiV6Z2diswN3FCY/JC4unVc+7QRPW2/BM/2fQma90qyTXUNd33LAyGJPJqBx8l1Nc6cAwvfiN5BVViX5J/q7bDUCRSlnhZE6Rg7nraUjrGqvTIfdEe0h5VXEApQnAB+nJ2nENAQs1kkZYSDc0HrsAaP0ILXCY9szOdaZmk1VWz8Y5TpzBIkbzSZfgBLjsfGxp/Y51WfwtGv5LTYSPq0HvzG9Kg/MGPbiBlvWO3urIynk1+vgepMijRN/c/NTQkEiKKMx1sFj83J6xJBF9FWStWEWMN8YqPmfWh59btrX4oMsjvSdOJWo1kj47mcuWspRrEY0e3uGIBMMxQCacaMTbjusehbvaBAuEIOnBFGKnlITiKCn3Jm9+h8DEXuLYoVgJr2sSDxoGrahBx/+RiBUPcdXbaOlWglFJeG0eACQUNghSwi/wQaqLQC0ZKF6elHKbIHot5MjYha0/hsTLIJhsVIZPtSDUf/E88fxcPiB6VsSdVg/7tvDZSIC2JPZUlav1o1LDL6jRgrgcpJbTLwJAZNfeRPVyGZoqFJr+rKVCdS+yJXO9+kvRRZRnGv/1s1
 Giarf0wT
 +MwjF4NBtHJ8DABYYFRYs9LXvFvt0lonQA+eHdGKjHQxhuXf2yuAd/O16D39UuOgQ68CW0HW0dpaALWIyfwJdbZ3YWVRCf2AnNxTSvUYADhwxeWfclXVf+8rzOq+L20yOWe0xDK0B4Z5y54X97Js/7eH+xMM399kqCzmQvOlkt+AgSYr5qKDJ7SH27peXFYSM4wwEaXFYSgJpbS8R4NeUyYqKJlkJPLbezRGRgNSh0FXrBkba0Bs94cJ4i96UrFe27yYq/Nzob3rv2hfE/7TmCAz9PlTyJPyBeDTToHMdNO8AOfvLkmXZ2v8vRkXp6pgigyQsx1YAZkGvgex2cZK6PBU7wjeoW79VxPgNyKBVT08qIHG8zUF4sYAW1NmO3c82ZnLydwmtSZgMAeTuEF5ot/vHqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 09:20, Michal Pecio wrote:
> On Mon, 29 Jun 2026 08:27:48 +0200, Vlastimil Babka (SUSE) wrote:
>> On 6/26/26 23:27, sanan.hasanou@gmail.com wrote:
>> > Good day, dear maintainers,
>> > 
>> > We found a bug using a modified version of syzkaller.  
>> 
>> Subject says "usb_free_urb" but you only CC'd slab maintainers, where slab
>> slab is most likely a victim here of e.g. double kfree() or a kfree() of
>> otherwise broken pointer.
>> 
>> Ccing USB and EM28XX maintainers. But they can feel free to ignore this per
>> the next point.
>> 
>> > Kernel Branch: 7.0-rc1  
>> 
>> Why use such a version for fuzzing? rc1 will have many bugs that are
>> already fixed in 7.0 final. And it's not even latest, 7.1 was
>> released 2 weeks ago too.
> 
> To be fair, em28xx had no changes since 2024 until 7.1-rc1, so the bug
> must be present in various stable releases and likely in mainline too.

OK I didn't check that, but in general my comment stands.

>> > WARNING: mm/slub.c:6352 at free_large_kmalloc+0xb3/0x160 mm/slub.c:6352, CPU#1: kworker/1:4/12317  
>> 
>> A kfree() was attempted on a pointer that's neither from a slab page nor a
>> large kmalloc page. Might be double free or corrupted.
>> 
>> > Call Trace:
>> >  <TASK>
>> >  kfree+0xae/0x630 mm/slub.c:6437
>> >  urb_destroy drivers/usb/core/urb.c:25 [inline]  
>> 
>> static void urb_destroy(struct kref *kref)
>> {
>>         struct urb *urb = to_urb(kref);
>> 
>>         if (urb->transfer_flags & URB_FREE_BUFFER)
>>                 kfree(urb->transfer_buffer);  <--- this one
>> 
>>         kfree(urb);
>> }
>> 
>> >  kref_put include/linux/kref.h:65 [inline]
>> >  usb_free_urb+0xd1/0x120 drivers/usb/core/urb.c:96  
>> 
>> USB layer itself is likely also not the root cause.
>> 
>> >  em28xx_uninit_usb_xfer+0x165/0x310 drivers/media/usb/em28xx/em28xx-core.c:833
>> >  em28xx_alloc_urbs+0xf2a/0x1130 drivers/media/usb/em28xx/em28xx-core.c:-1
>> >  em28xx_dvb_init+0x2b0/0x4a20 drivers/media/usb/em28xx/em28xx-dvb.c:-1
>> >  em28xx_init_extension+0x121/0x1d0 drivers/media/usb/em28xx/em28xx-core.c:1117  
>> 
>> So it might be this driver doing something wrong?
> 
> Yes, it is. 

Cool :)

>         /* allocate urbs and transfer buffers */
>         for (i = 0; i < usb_bufs->num_bufs; i++) {
>                 urb = usb_alloc_urb(usb_bufs->num_packets, GFP_KERNEL);
>                 if (!urb) {
>                         em28xx_uninit_usb_xfer(dev, mode);
>                         return -ENOMEM;
>                 }
>                 usb_bufs->urb[i] = urb;
> 
>                 usb_bufs->buf[i] = kzalloc(sb_size, GFP_KERNEL);
>                 if (!usb_bufs->buf[i]) {
>                         for (i--; i >= 0; i--)
>                                 kfree(usb_bufs->buf[i]);
> 
>                         em28xx_uninit_usb_xfer(dev, mode);
>                         return -ENOMEM;
>                 }
> 
>                 urb->transfer_flags = URB_FREE_BUFFER;
> 
> If buf[i] allocation fails, all previous buffers are freed and then all
> previous URBs are destroyed. But they already have the URB_FREE_BUFFER
> flag set, which causes a double free as shown above.
> 
> The free(buf[i]) loop should simply be removed. It was mistakenly added
> by d571b592c6206, then a26efd1961a18 recognized the double free but
> attempted to fix it only by changing the order of freeing. Sent from
> .edu domain, so probably an automatic static analyzer fix...
> 
> Regards,
> Michal


