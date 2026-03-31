Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A8991061B2E
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 11:23:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8713A6B0095; Tue, 31 Mar 2026 07:23:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 849366B0096; Tue, 31 Mar 2026 07:23:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7385E6B0098; Tue, 31 Mar 2026 07:23:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5ECB46B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:23:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 17ED41A0C84
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:23:22 +0000 (UTC)
X-FDA: 84606122244.25.CDE698B
Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	by imf21.hostedemail.com (Postfix) with ESMTP id E26D41C0003
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:23:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=invisiblethingslab.com header.s=fm1 header.b=GxDKYTTl;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=bD26wddQ;
	spf=pass (imf21.hostedemail.com: domain of val@invisiblethingslab.com designates 202.12.124.150 as permitted sender) smtp.mailfrom=val@invisiblethingslab.com;
	dmarc=pass (policy=none) header.from=invisiblethingslab.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774956200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EcsUa8C2fgTQynsJHHMDaklxMetgPOWxao6hBDdfyVA=;
	b=ZV58cfJBxlueacV2uOhB2/t9FN0UUDf8Z2EqGkb/GE7MQOxlNYVUP3JDkdg6Dfsr4b7U3O
	U8Y1YvcW1JwQrXDrzrymkSb9EFthoFq35Ab4K6WxNfwobR/duGy/2IvZ1casZ/xbMwYQDh
	50LAvbigoSX8aLR5gEyfbhnu2Im6B/4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=invisiblethingslab.com header.s=fm1 header.b=GxDKYTTl;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=bD26wddQ;
	spf=pass (imf21.hostedemail.com: domain of val@invisiblethingslab.com designates 202.12.124.150 as permitted sender) smtp.mailfrom=val@invisiblethingslab.com;
	dmarc=pass (policy=none) header.from=invisiblethingslab.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774956200; a=rsa-sha256;
	cv=none;
	b=OB1uL7BH/iu+T7PR9CttQ91NezLBxEJ1wZlcfOHV6q9CloS2JWaSmEieSnn1o0zRe674ph
	AY0+4GCAzh1Romq8wWSHQIXS0EMCCZYh0/T5wmVP20rhMu6luk+4/qKzZsCDOGTeQoGvTO
	494dyKuTtP+6shph/PQEfK5jJLLE5mU=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id C661B1D000D9;
	Tue, 31 Mar 2026 07:23:18 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 31 Mar 2026 07:23:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	invisiblethingslab.com; h=cc:content-transfer-encoding
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1774956198; x=1775042598; bh=EcsUa8C2fg
	TQynsJHHMDaklxMetgPOWxao6hBDdfyVA=; b=GxDKYTTl1LNI9F+u4S4DgCLgOv
	Kcrq7mFbpjCVCKrG5K4gNU3h1M0R8W6EkrPExlvHBvibFlwJNcPgNenjazcYTIhz
	WrtBXTgBC2QXxI+F4YXrKafTVzThf70Qfj0OgSG69FLx+GuYtYbrgu6+FGaUL/iq
	Kvx6ybnYKL6PLW/6sWvGYS4EBKcqnSLB9Ri6Dz8oQRD4lyiribAXJFUhT35osPqF
	74n4Ef4q2d+B0cQEB+JmZHQqENMHLXmoDFpe1wd0BKlAP4afuf3oV1cqFbRIGsTH
	UItvChIYv+GYs3asFj5lxMsPsZysXuryiHVj/8EMt8MHQqD2X5cz0UpWm6tA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1774956198; x=1775042598; bh=E
	csUa8C2fgTQynsJHHMDaklxMetgPOWxao6hBDdfyVA=; b=bD26wddQtzO270IPw
	3ipfar8cmhKmQY+21H4AGg8ZLpn+Gpn1LiPuK+B8dzIVrTDTZrfg0ttp4OXuPnrN
	HDZEjKIdDj9LWXwosWx4hF0l9zbxGh81XBL2TaaY77sNHDOFuFxzyjbiNs4fT2EA
	smilVaa7TtIcoO6ONR/bNHeA+9SuXXle4ZZ467I1KbPw75g1W2YJnMpw65UCEouL
	QIxOWzteB49CdAYQUECZD8ROLaTkKrDqWTpMa2ytJDi1Xsv6SCEZEjntGhuiMjZS
	YvtvDxIP0t6CpHh+nF2V7fvPEWXJH4d1NxFVCO8Tlnvkw7ePqegcaaMuSf+HWMax
	wlfMA==
X-ME-Sender: <xms:pq7LaYbWTgmmp6kgmkYgE-X6Ogs44xkJKyCNFbPgFbrVh_f02ug0aA>
    <xme:pq7Lacsqw6bAyDjA8LEksJ1YBDAqA4A6sDWondKd0H4qkU3oyULOrhZPpX13dD0Ao
    yTu6l3925xEtlgp0Gv3_YKrj4ybXsg1Cupw1UEOvmdmQ5BaSw>
X-ME-Received: <xmr:pq7LaaNpJT3EiGNei-ycp77s-x-rpZGXdFewRYALvzuXbiK5SqVlIqyMLjk9adeQiQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddtjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegrihhl
    ohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpe
    fkffggfgfuvfhfhfgjtgfgsehtkeertddtvdejnecuhfhrohhmpeggrghlucfrrggtkhgv
    thhtuceovhgrlhesihhnvhhishhisghlvghthhhinhhgshhlrggsrdgtohhmqeenucggtf
    frrghtthgvrhhnpeeigfffgfduvefgueeljefgfedugeeivdelkeetieeifefgveettefh
    hfejleegfeenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehvrghlsehinhhvihhs
    ihgslhgvthhhihhnghhslhgrsgdrtghomhdpnhgspghrtghpthhtohepiedpmhhouggvpe
    hsmhhtphhouhhtpdhrtghpthhtohepthgvugguhidrrghsthhivgesvhgrthgvshdrthgv
    tghhpdhrtghpthhtohepuggvmhhiohgsvghnohhurhesghhmrghilhdrtghomhdprhgtph
    htthhopeigvghnqdguvghvvghlsehlihhsthhsrdigvghnphhrohhjvggtthdrohhrghdp
    rhgtphhtthhopegurhhiqdguvghvvghlsehlihhsthhsrdhfrhgvvgguvghskhhtohhprd
    horhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthht
    oheprghrihgrughnvgesrghrihgrughnvgdrshhprggtvg
X-ME-Proxy: <xmx:pq7LaT6LSvG_5p75fUx-R-PjzGyJuXhAK3aQPJdl5uQ7kK6Xu_gLdA>
    <xmx:pq7LaQR0B-XiB0n4hGmvO5Cuw-AkgNdjgOaTp7g8furXZpdRMPWVuQ>
    <xmx:pq7LaQAC5qBSdtGk0KPTSBkXMFOqi2Vda7mDAZlf7o76rHUHMEeVfw>
    <xmx:pq7LaQG2_uoBLonEXgv0s4UO3v-yweveB3CsFHrClOnBcLKs2bSMHw>
    <xmx:pq7LadqsRxsg0-wb_n4gPdR28Kx_8H5d6lgrj1ykbaG3lR-yuELmZ3wH>
Feedback-ID: i001e48d0:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 31 Mar 2026 07:23:16 -0400 (EDT)
Message-ID: <36d831f6-f21a-4c0d-b442-e526d8c946b9@invisiblethingslab.com>
Date: Tue, 31 Mar 2026 08:23:14 -0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Why memory lending is needed for GPU acceleration
To: Teddy Astie <teddy.astie@vates.tech>,
 Demi Marie Obenour <demiobenour@gmail.com>,
 Xen developer discussion <xen-devel@lists.xenproject.org>,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 Ariadne Conill <ariadne@ariadne.space>
References: <84462c4b-7813-4ad1-aeb2-862ae4f3a627@gmail.com>
 <c38387fe-beef-4f50-b928-74f96b881b7a@gmail.com>
 <0bbf0349-1006-485f-a2db-6c8b795b4242@invisiblethingslab.com>
 <1de15ce0-9f7e-4253-80a7-ecd94caa4325@vates.tech>
Content-Language: en-US
From: Val Packett <val@invisiblethingslab.com>
Autocrypt: addr=val@invisiblethingslab.com; keydata=
 xm8EaFTEiRMFK4EEACIDAwQ+qzawvLuE95iu+QkRqp8P9z6XvFopWtYOaEnYf/nE8KWCnsCD
 jz82tdbKBpmVOdR6ViLD9tzHvaZ1NqZ9mbrszMXq09VfefoCfZp8jnA2yCT8Y4ykmv6902Ne
 NnlkVwrNKFZhbCBQYWNrZXR0IDx2YWxAaW52aXNpYmxldGhpbmdzbGFiLmNvbT7CswQTEwkA
 OxYhBAFMrro+oMGIFPc7Uc87uZxqzalRBQJoVMSJAhsDBQsJCAcCAiICBhUKCQgLAgQWAgMB
 Ah4HAheAAAoJEM87uZxqzalRlIIBf0cujzfSLhvib9iY8LBh8Tirgypm+hJHoY563xhP0YRS
 pmqZ6goIuSGpEKcW5mV3egF/TLLAOjsfroWae4giImTVOJvLOsUycxAP4O5b1Qiy+cCGsHKA
 nCRzrvqnPkyf4OeRznMEaFTEiRIFK4EEACIDAwSffe3tlMmmg3eKVp7SJ+CNZLN0M5qzHSCV
 dBBkIVvEJo+8SDg4jrx/832rxpvMCz2+x7+OHaeBHKafhOWUccYBLKqV/3nBftxCkbzXDbfY
 d02BY9H4wBIn0Y3GnwoIXRgDAQkJwpgEGBMJACAWIQQBTK66PqDBiBT3O1HPO7mcas2pUQUC
 aFTEiQIbDAAKCRDPO7mcas2pUaptAX9f7yUJLGU4C6XjMJvXd8Sz6cGTyxkngPtUyFiNqtad
 /GXBi3vHKYNfSrdqJ8wmZ8MBgOqWaaa1wE4/3qZU8d4RNR8mF7O40WYK/wdf1ycq1uGad8PN
 UDOwAqdfvuF3w8QMPw==
In-Reply-To: <1de15ce0-9f7e-4253-80a7-ecd94caa4325@vates.tech>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E26D41C0003
X-Stat-Signature: 5ppg1hqtm4puezsizfmy1q5csjxy3txr
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774956199-64357
X-HE-Meta: U2FsdGVkX19TPDKhTmVW7kfGQCTSkl7MpR2wnyz67MeBsGa3BQ8S7Fl0UWRJvJq5DGnYLQmnifGlb5VyKelatvQWggfooMFJSnz8UcYTZghP4yIgadKlfIMeAhB8DHPcIo10w88Glo+arbn73HVNfQQNBXscXCugaGiFUmUdRbqpICFppG5GgwQLK6gA//PMYz2XhRSfDWZd2jR67oju3qI7JVQpB+2IzYqW6Fzasp605gSloPgz7/ruh4DACAc+mOB4vhs1/2dmfGLNPKhlueiQftXta2Qb7gnqr5l16VLay6YbfJ5AkwOOsXWsXwM8IUJoAjnaik20aMpeEGggPEGRs+kNhJC9cohuF7yAm/su5uD4HaFQgknkA/w0K3jbIsVjO0TjE7YmZ2mjHaiOI/6dAT4eYdzaf394YFlNmubB4FpS0WMNvdX+2I2b5E1drYjhKvqseay5vhvbIBm+hFKqBPbftF1rMKiX1zaIDXtebOak30g6XLBWYYxql2tIGSRnbenxrlIMY5I4j4ByRhFVdTN2OS4FGAND/53at8tZPE0f7XaZStnM/ZZiK+AtrWsjhNbXAUZnPzGlHdMxVnMYGceZlUtIak0rz7x/qBINkUaixLjq+S/z4LHSE6uz1Yr06/8wvkPDDB8qrftPx6ME62/62UO0qa1TpCIQqbjjtpfZ5yGc/1P4VpFw24XwhwB2kZiZUBpB3bETzm5fRAE8HuBvvfYIbX6CUJFGksP3jkYaABH/0fdDP9WMymLkZNJlO6t7YOse62oiLSoRCRuSYxKBu2DKVOxtcItXAoQlPesTA/0farj3lUe+LvCILlgA0SEECeTteHEZ7GZnGooXqhvjkflvDElxzfMtRzt1qa5Y2y85zhAzLEgc/Bw3f//o153UEvKkL5DnarMRn2eB35BBRfq/mc+swzaPeGj5jHX/YbEQFnpfLSilg0lWkM8v62Ssv5kgcUhbixj
 JLjKpgsn
 jnjqkJzdP0XyCPTFD/98eZd5/bK29XRaVt1/3RS51HMUdP5y9afMItRGmw0+Q5RaR3O8K1+uaNlyBzIrK9otT5ZYN3//zuLAsILZGcoxYX76PKaXv78SMqTGz8BXWQFt9OeWCkVxvE14jr3pC4sOsL9v7CkFYe3LMQntv1qs2rkFfQzgGa2FHTzXU0P36Q8OslDOZ32O/UXsLH/PM3wAMsdj6RpZQ+UOVsdVe2+2eos5aVPGOiXFK43KAvSVkacOwnvNxSlGe4Cqnho2gPj+RccLkphmv1nJvrDEXh/GCbYs9A4Eur0M14Zkc9DtnOHqx4qi6nDlYm/qEEpkZ/m3lzxljBHF1qI1kISR59WlXrZyeSFLjlI7t+xsYGOtgBEZbKNRzPxr2sNNLF0D5K48pkIw7v3z/yP5GSmfuWqifBPA5QfDif2GZtMvqJ+hFTLG1SY0A3bSXbAr2MU9B8KzBAQJcnOzzsZe71MWePqHlyIG6uH0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 3/31/26 6:42 AM, Teddy Astie wrote:
> Le 30/03/2026 à 22:13, Val Packett a écrit :
>> [..]
>>
>> we have no need to replicate what KVM does. That's far from the only
>> thing that can be done with a dmabuf.
>>
>> The import-export machinery on the other hand actually does pin the
>> buffers on the driver level, importers are not obligated to support
>> movable buffers (move_notify in dma_buf_attach_ops is entirely optional).
>>
> dma-buf is by concept non-movable if actively used (otherwise, it would
> break DMA). It's just a foreign buffer, and from device standpoint, just
> plain RAM that needs to be mapped.
>
>> Interestingly, there is already XEN_GNTDEV_DMABUF…
>>
>> Wait, do we even have any reason at all to suspect
>> that XEN_GNTDEV_DMABUF doesn't already satisfy all of our buffer-sharing
>> requirements?
>>
> XEN_GNTDEV_DMABUF has been designed for GPU use-cases, and more
> precisely for paravirtualizing a display. The only issue I would have
> with it is that grants are not scalable for GPU 3D use cases (with
> hundreds of MB to share).

At least for the Qubes side, we aren't aiming at running Crysis on a 
paravirtualized GPU just yet anyway :) First we just want desktop apps 
to run well.

Keep in mind that with virtgpu paravirtualization, actual buffer sharing 
between domains only happens for CPU access, which is mostly used for:

- initial resource uploads;
- the occasional readback (which is inherently slow and all graphics 
devs try not to *ever* do);
- special cases like screen capture.

Most CPU mappings of GPU driver managed buffers live for the duration of 
a single memcpy. Mapping size can get large for games indeed, but for 
desktop applications it's rather small.

On the rendering hot path the guest virtgpu driver just submits jobs 
that refer to abstract handles managed by virglrenderer on the host, and 
buffer sharing is *not* happening.

> But we can still keep the concept of a structured guest-owned memory
> that is shared with Dom0 (but for larger quantities), I have some ideas
> regarding improving that area in Xen.
>
> The only issue with changing the memory sharing model is that you would
> need to adjust the virtio-gpu aspect, but the rest can stay the same.
>
> The biggest concern regarding driver compatibility is more about :
> - can dma-buf be used as general buffers : probably yes (even with
> OpenGL/Vulkan); exception may be proprietary Nvidia drivers that lacks
> the feature; maybe very old hardware may struggle more with it
Current nvidia blob drivers do not lack the feature btw..
> - can guest UMD work without access to vram : yes (apparently), AMDGPU
> has a special case where VRAM is not visible (e.g too small PCI BAR),
> there is vram size vs "vram visible size" (which could be 0); you could
> fallback vram-guest-visible with ram mapped on device

UMDs work on a higher level, they work on buffers which are managed by 
the KMD.

In any paravirtualization situation (whether "native 
contexts"/vDRM which runs the full HW-specific UMD in the guest, or 
API-forwarding solutions like Venus) the only guest KMD is virtio-gpu! 
The guest kernel isn't really aware of what VRAM even is.

https://gitlab.freedesktop.org/mesa/mesa/-/blob/main/src/amd/common/virtio/amdgpu_virtio_bo.c

^ this 300-ish-line file is everything amdgpu ever does with buffer 
objects on the virtio backend.

All it can do is manage host handles, import guest dmabufs into virtgpu 
to get handles for them, export handles to get guest dmabufs, and map 
handles for guest CPU access via the VIRTGPU_MAP ioctl. There are no 
special details to any of this, it's all very straightforward.

It seems to me that implementing VIRTGPU_MAP in terms of dmabuf grants 
would be easy!..

I'll need to get to that point first though, right now I'm still working 
on making basic virtio itself work in our (x86) situation.

> - can it be defined in Vulkan terms (from driver) : You can have
> device_local memory without having it host-visible (i.e memory exists,
> but can't be added in the guest). You would probably just lose some
> zero-copy paths with VRAM. Though you still have RAM shared with GPU
> (GTT in AMDGPU) if that matters.

What did you mean by "added" in the guest?

We shouldn't ever have to touch this level at all, anyhow…
> Worth noting that if you're on integration graphics, you don't have VRAM
> and everything is RAM anyway.


Thanks,
~val


