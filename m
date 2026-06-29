Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D8DAC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 07:40:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B8F56B008A; Mon, 29 Jun 2026 03:40:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 169FD6B0092; Mon, 29 Jun 2026 03:40:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05A876B0096; Mon, 29 Jun 2026 03:40:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D0ECE6B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:40:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 501D7A05F0
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:40:39 +0000 (UTC)
X-FDA: 84932152998.06.4241050
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8BBEDC0004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:40:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JmHQL8lE;
	spf=pass (imf22.hostedemail.com: domain of hverkuil+cisco@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=hverkuil+cisco@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782718837;
	b=KIL6el1ApEeSAwwlaBuD4jdgKIe5SnzwaIMc25dhcXodLX0iYoX08TC7guQpvEIZuIdEF7
	y+YkvfIadBtrw+ln3DYc/osfTLIFB48dRGUbyPvb4/otp/ll0CdIePNEDnz26EemRukqsg
	jrJCfmtiOBJ9nCaKasgPf4Sb+LysBV8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782718837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WgIRlcejZoj2vu7HrtjrPtuhxXds25sfbR6cc/Z3oZM=;
	b=ioi+Ee3FumUevv+ay0woPP1xeO40xzpJUX8U7MA10BRB8HHFCVn5drmfypffTKvy0l88lq
	ylwhTn7vdvn/wnYqu3IPrDOPyuDWqQ9D30I/jKSwdx3pGwDrptfLmfSrcV5TxHoZutOfmU
	HlfYEoH4T97muLvkYFePx5mAUxTegKg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JmHQL8lE;
	spf=pass (imf22.hostedemail.com: domain of hverkuil+cisco@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=hverkuil+cisco@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B0A2B42DEA;
	Mon, 29 Jun 2026 07:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7FD1F000E9;
	Mon, 29 Jun 2026 07:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782718836;
	bh=WgIRlcejZoj2vu7HrtjrPtuhxXds25sfbR6cc/Z3oZM=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=JmHQL8lE9+PyPwTcD5p+IiQj7vBq5CdTbQo2NSAJonNiW8tzZXju3VE3viSbOi/Xe
	 JYmVavc4AmKQJvVtMNuC2TV+UU1uVsyR07xu/sjuauulxWjhnPjfmhHMHLqyJIC29e
	 7lGap7OLcO0L4xXy9+7E9Le12gWMZesIHTPtdiSsL2MY6OcWRAht+0B8Rh+ypIKUBt
	 qpNyNbyKN5DFkB84ieGPYkldqWilITr3giSQsKXs6lhHTMw8vMdlNU9Jqh17IffV0E
	 G/VeVpPc/LFlr4kpGRj8TuQ1Cwj+S7Sv8MELoIcnMrGn0+7vzkWtMF8/SN/MqsUpw8
	 3XABLFRBgmBxA==
Message-ID: <91381a8b-d562-4363-ac52-470c1ca53d80@kernel.org>
Date: Mon, 29 Jun 2026 09:40:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: Re: WARNING in usb_free_urb
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Michal Pecio <michal.pecio@gmail.com>
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
 <b50be148-f7e4-4c11-9893-54d4278b2e32@kernel.org>
Content-Language: en-US, nl
In-Reply-To: <b50be148-f7e4-4c11-9893-54d4278b2e32@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: newjzbmy39zpn7j4wziz3ys59xpikfjf
X-Rspam-User: 
X-Rspamd-Queue-Id: 8BBEDC0004
X-Rspamd-Server: rspam02
X-HE-Tag: 1782718837-14917
X-HE-Meta: U2FsdGVkX18lbSEF7rvSkp7yAIP5qhxQeCvWOLUYOO2e1dPyf3IpLWTFNrnAxahajQil8D/TBFNwHRpUSxw+IJRvQHQ1oz55LiY9hXvA+9oXnbC8lOZOIAC2yWzLeqlIURML/Lb3zdrOPY/Hp2KnFO+YkwVVcmQuheb8zIF1QHvKcoI1gYqAJaWZhnYWbiUQV6CRVU1HPOk6APAQSLRegJYtThcrr4ejMJwaSBBZu+ugCaI8+76Dq/F0n8xf2MqqLIVCDu4CoS3GV9U5MXWpdjHOQhdbGi7KrHjjfoNPkLH0pM3HHAq1U8SnOs1F1UVpyqarKdBh3GAe0HYOh9twDwCbcTlw/fxRviiphaXxGnpeatGtPyxRg9nRoa9x2m/L+W2XHY/7JlbAgL8gnMaO3iulJ3wFSA3WUCJtWpIH9O0y2shBhtZHNeNJHgt2FC6+eTHw5UGYyoDvLxrC3wy/Ju+KPtj9FJARhVg9xHXqjfhKhIclFmPpnJ72fwdeU4YB8buxBZwsajbHrMt/qQItyNWAvW9pdbpUlnlDcFve/tS1t1ozhyvzsj3xXMCXSoIvD6qCOh7/+dUdwSbCBrrskdaoEf6jOqDqFRsGSmpVB7f4ENZfrE+vbu6Mi5UaKpw2m5nm8uBM8UrpLXI5Tm/u7cNNME5+4gNmfSIACwV9a4h4e57ZiFOpX9WU7uhyjJBrh1wFL6CdroRC9pWc97iTVhl2MgQm4PHjsF7QM3UyMNcG16tR9SM9jmTA3PY+apDj4s53atSZVdtOvh85sOQZmWxhfvik+3KK5tAEVw81kRgaUVAjuZIRXQd0Efaouzdr4CwkKAEENh8FFsoxG944H7F7gGYBcBle86202uLG8tXANC1UXTApnvUU7zqHYH+v25d0miSQ8xgWWnJGG2t+LtHrkCvLL/5V06p4PTo8RKpfz80bpJ4UBHKBGtMhGlzg16pn0V+2GDhl9Ccjt2W
 vtXhjz09
 0d7CXygwU/4WHDQy8tHLDW5mJrY1uNErAx++/UqqR1pF9S6nCq1pO0tqqojt7/1B7+m7Vi4GhJTcB9udZaInVufj8e4gX256Yp8tYe2Av3RFIrEl473Rx59yL/5XAADvmCRC+sW9ILNZXKIJ/GoTotzrNmmsyT44EHNd4nGNM1YJotxOB1f0ymzu7AqydvpWXj9Dsh9JAN4iCf61H/aWtzeRQ+0HPV9vFp/PPY9UmJW1oHxgoae446eIUTprAhSACJMpf60R+jFzNJJ3TBOOlqly95HMSDfqJOhwlGdqXQUQVBqNLiBa+TvD1Gzfg9D8gwp1cTKvzhsgkgsb4MW62OkWZZ7gbPw37LX6Pwe/2c9ZN/JQMyLUASzC7kvDq+1gmk6QV4nUGjY7VKLI+QfiSyRLuLtCLgxq7yoH6+4ruKA1mkWPkTHDjYoCxQ2COz3jtSucDYtMZrvS+1HntbUhiKdJ7ZqlcW5jdmE0P3QhXjE9N/wN41Z7TnQouIGeCSDL+ftZ2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are a lot of lifetime issues in em28xx.

This patch series should fix them:

https://patchwork.linuxtv.org/project/linux-media/list/?series=26968

If you can, then please test with this series and see if this issue
still appears.

Regards,

	Hans

On 29/06/2026 09:31, Vlastimil Babka (SUSE) wrote:
> On 6/29/26 09:20, Michal Pecio wrote:
>> On Mon, 29 Jun 2026 08:27:48 +0200, Vlastimil Babka (SUSE) wrote:
>>> On 6/26/26 23:27, sanan.hasanou@gmail.com wrote:
>>>> Good day, dear maintainers,
>>>>
>>>> We found a bug using a modified version of syzkaller.  
>>>
>>> Subject says "usb_free_urb" but you only CC'd slab maintainers, where slab
>>> slab is most likely a victim here of e.g. double kfree() or a kfree() of
>>> otherwise broken pointer.
>>>
>>> Ccing USB and EM28XX maintainers. But they can feel free to ignore this per
>>> the next point.
>>>
>>>> Kernel Branch: 7.0-rc1  
>>>
>>> Why use such a version for fuzzing? rc1 will have many bugs that are
>>> already fixed in 7.0 final. And it's not even latest, 7.1 was
>>> released 2 weeks ago too.
>>
>> To be fair, em28xx had no changes since 2024 until 7.1-rc1, so the bug
>> must be present in various stable releases and likely in mainline too.
> 
> OK I didn't check that, but in general my comment stands.
> 
>>>> WARNING: mm/slub.c:6352 at free_large_kmalloc+0xb3/0x160 mm/slub.c:6352, CPU#1: kworker/1:4/12317  
>>>
>>> A kfree() was attempted on a pointer that's neither from a slab page nor a
>>> large kmalloc page. Might be double free or corrupted.
>>>
>>>> Call Trace:
>>>>  <TASK>
>>>>  kfree+0xae/0x630 mm/slub.c:6437
>>>>  urb_destroy drivers/usb/core/urb.c:25 [inline]  
>>>
>>> static void urb_destroy(struct kref *kref)
>>> {
>>>         struct urb *urb = to_urb(kref);
>>>
>>>         if (urb->transfer_flags & URB_FREE_BUFFER)
>>>                 kfree(urb->transfer_buffer);  <--- this one
>>>
>>>         kfree(urb);
>>> }
>>>
>>>>  kref_put include/linux/kref.h:65 [inline]
>>>>  usb_free_urb+0xd1/0x120 drivers/usb/core/urb.c:96  
>>>
>>> USB layer itself is likely also not the root cause.
>>>
>>>>  em28xx_uninit_usb_xfer+0x165/0x310 drivers/media/usb/em28xx/em28xx-core.c:833
>>>>  em28xx_alloc_urbs+0xf2a/0x1130 drivers/media/usb/em28xx/em28xx-core.c:-1
>>>>  em28xx_dvb_init+0x2b0/0x4a20 drivers/media/usb/em28xx/em28xx-dvb.c:-1
>>>>  em28xx_init_extension+0x121/0x1d0 drivers/media/usb/em28xx/em28xx-core.c:1117  
>>>
>>> So it might be this driver doing something wrong?
>>
>> Yes, it is. 
> 
> Cool :)
> 
>>         /* allocate urbs and transfer buffers */
>>         for (i = 0; i < usb_bufs->num_bufs; i++) {
>>                 urb = usb_alloc_urb(usb_bufs->num_packets, GFP_KERNEL);
>>                 if (!urb) {
>>                         em28xx_uninit_usb_xfer(dev, mode);
>>                         return -ENOMEM;
>>                 }
>>                 usb_bufs->urb[i] = urb;
>>
>>                 usb_bufs->buf[i] = kzalloc(sb_size, GFP_KERNEL);
>>                 if (!usb_bufs->buf[i]) {
>>                         for (i--; i >= 0; i--)
>>                                 kfree(usb_bufs->buf[i]);
>>
>>                         em28xx_uninit_usb_xfer(dev, mode);
>>                         return -ENOMEM;
>>                 }
>>
>>                 urb->transfer_flags = URB_FREE_BUFFER;
>>
>> If buf[i] allocation fails, all previous buffers are freed and then all
>> previous URBs are destroyed. But they already have the URB_FREE_BUFFER
>> flag set, which causes a double free as shown above.
>>
>> The free(buf[i]) loop should simply be removed. It was mistakenly added
>> by d571b592c6206, then a26efd1961a18 recognized the double free but
>> attempted to fix it only by changing the order of freeing. Sent from
>> .edu domain, so probably an automatic static analyzer fix...
>>
>> Regards,
>> Michal
> 
> 


