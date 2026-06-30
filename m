Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9464CC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 06:12:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C13E6B00AE; Tue, 30 Jun 2026 02:12:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 599246B00AF; Tue, 30 Jun 2026 02:12:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 487876B00B0; Tue, 30 Jun 2026 02:12:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 20EA26B00AE
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:12:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 825F78D3FE
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:12:18 +0000 (UTC)
X-FDA: 84935559156.02.5F5D87F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id CA92440012
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:12:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cUMHmYM9;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782799936;
	b=Lexy6HDHVt7iLKEJUp/7mdB8zzzmAJSfamn6nf4/YFTU8Ve3xIgls0ax5sPQvQrzLts+km
	WjeeVBWE2KxKystfiezpI31BH1ziJnVCE89I2QAX4B6zfyFxtEsPVI0eA+Ka6A8sj9DfLI
	LsZYunXKU+91DDeFR6kHeOC57qK1JC4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782799936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zz7xzpJii4mbLMgFvlEmSOOI69KPmvh9HUemXnItoYI=;
	b=yAHKvz7NisLp9ujaMLfPIFJPub12MuIYdgDN5hVEemMCX1wz+stYHJIMuqYyR0aAudL8Ht
	f4auvymWXoXT/ZysgmReX7H+klRrnQQXAcx6jF66nKXe9DIbZqDfFEgL+/OVRHjQc42wWp
	THC9g2WZzgmlLs8U0Z1jlRzJAmjt2lY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cUMHmYM9;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 36298600BB;
	Tue, 30 Jun 2026 06:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0241F000E9;
	Tue, 30 Jun 2026 06:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782799935;
	bh=zz7xzpJii4mbLMgFvlEmSOOI69KPmvh9HUemXnItoYI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cUMHmYM982w66NfN0Yd1pc4HsLmmFiu4drGcJqOcBxjBuPQw8xt4knvpD4dk2EpAp
	 yp2kitZvdgYmkYOsF35Jq73mayP2sIKDdKKEEIsnP2DCbXnpduVxcZMspnj4+hcDJI
	 d0W1+Zs0RdhGM/Bw7CvvAKTJROoKmNDYxO1GbOyy+phsUiz2Vcr05WMJTPtWMqXoeB
	 WIZKHMVxA1D1cg+SnxOPx0iatbUuLiu6YsSv6zcKOEUnUCuZBLKUtOdCo2W3/KXyRJ
	 I8IJK8eqDMb0ujnHvP1gesJw8wq5I3EPE1F5C2LKFu2HFu7wfVaQMBlDtAhNtqEMVZ
	 gCEl0TD+KtKiQ==
Message-ID: <c5c4208d-a6f0-413e-bad9-49be12f12d55@kernel.org>
Date: Tue, 30 Jun 2026 08:12:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
To: Suren Baghdasaryan <surenb@google.com>, Harry Yoo <harry@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Usama Arif <usama.arif@linux.dev>, Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Danielle Costantino <dcostantino@meta.com>, Kees Cook <kees@kernel.org>
References: <20260625230029.703750-1-shakeel.butt@linux.dev>
 <62453403-954c-4cf1-8924-6d38184b0810@kernel.org>
 <aj6re83IC84lkFL0@linux.dev>
 <09267187-6c85-438f-8791-4cce8d07892a@kernel.org>
 <akCJRTnmA2um3CIy@linux.dev> <akCSftF6mrsKsz1V@linux.dev>
 <e6ca6ac6-92c8-4db6-a82b-cbb92ceaa4ea@kernel.org>
 <68122038-e8e0-47ed-82f8-cb6a23e4658e@kernel.org>
 <CAJuCfpFanDcpqq5B7eNZbw2HnWOXD-xzcnrdbz-e2gnSM2EYHA@mail.gmail.com>
 <eac2ed38-432a-4d95-8968-2663540d73d7@kernel.org>
 <CAJuCfpF78_5CjLsbJLte+B4MzfaSiAmyeH57VLhgLtj8AXD2NA@mail.gmail.com>
 <62969830-4b1f-483d-8fa9-9ce487568570@kernel.org>
 <CAJuCfpH8ZjBMaOmso=9gZNz=DK2ja5yMS+04OjTGHh5Uc7r0GQ@mail.gmail.com>
 <CAJuCfpFX_sMrcTad-QGJsCV=fNyMWF=Bi6XmoHRqEAzMbWNfdg@mail.gmail.com>
 <39a79576-dcae-4b66-9478-c81dfe676699@kernel.org>
 <CAJuCfpGRC7NPxcODUsb3YS5nV=qG+-SbSYj1Fwm-QPqgKSVWAA@mail.gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <CAJuCfpGRC7NPxcODUsb3YS5nV=qG+-SbSYj1Fwm-QPqgKSVWAA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xiyoe76rry78rzjppcdrntp3cbeiku8k
X-Rspamd-Queue-Id: CA92440012
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782799936-99129
X-HE-Meta: U2FsdGVkX195WiT0R32zu2S+6Cd/v6vafR/bK9mgSgnWI2AtohS7cP2lXfkowgXSbah1tClm7Igq7vYPOks5x7NArMUQWcrFovdTu8ImNTb8xKYV3LBqNVZeHYiMni3G/6INgf8on9O4skbSqabgxlDSdG/DQDyA39OxSyNdd158ZbRK2NIuv/qjY0jRGZ83MIfj0OedTqVNJmfqpB33r5f/tnW3oFCb5pQBFTHtq38zPTGORKU3gLZdog2aL7F/OJ2iLG93xYl5IEgahENZjes1JBhafcw7QlZygaoOhccnZbSH5aPIaFZo0qWDWIv7EKg628er/CdK6aeyq4esAyHm4fKmrazy4MbhpasMbXSRCld+7AIaf1s0Y/e3UhVd4XSCEVKTuXMxFFzLDCAgRDujcL9iqXmaj7ZwJXiwEru6EvipveJCuITziKt5cbFRc26QcPwc/URXvKgCoZECvzTBGkg3MY7WpOuHZIAbHWmQh9SqKqIb2ticNWMlvBDm7YFrmz8i7CgQMM9MYISj8rtnxmYQq0pZM/1fFowbqeumFmk0zBXtHiXJDcIePoDm2RA2aDzg6OdMFMz9TqPoSb0JDKwjqOK2lugphqGXYV0fEAWocrOmaWz6YhAzqNf6c/VqjxtnfPrXcpePubZq1dPFthOMMfMbR2k1SigNhIFY7/nCSq3KbR1w0xFwwFLB+21eJ4GWQ8pajQrcpUpkyRO82Fkgu4XYeu9RC5N0xnQmQLoHd6VsvJQAcVlmF6dvl2OzB0DpY3H7ndTqsC2BjTG9Xq3CSlqghBmUZSkUj3+/9wXgsujeCPCXzrVqLy9eci5dEtsPJlgzzFke68XqW4iIRznKzRQxK6glDoeUk3EGv+7T6YE6OLt/S4IIStqTxq7vHsLM8fUnF+vPW/UI6d5Vbf7zAT+eO3B0wMlGVcEABOnIbJ2nWD2JxXsq+AdeDn3UcTOoVVD8srGbFpn
 0X8TLhMS
 KmWT/QTbee6UdGbUEj0elim3WHU+FsL2m3bOcceYrqF0vxMv8/OEeKlI0ItC1f1FPyDGqYKmu/UbZAf4jsIynRgfiV8ZYKcSUDvr5tP4bGLi2WR4LwjDNRTjkQlo0VS+JWg04cu0VlBk+T9mOf1kKXcLkUMXFgjicRMHpKfJJUV6tubQhOUSv2mpSB3Qxdl8cBjXxRkTQUGuRA71Jkjufba1dM8j6tKuugMg5N2OVh6VnbWZmrDStnn/lPRzx2BJxsDnkuxR7Le3+szI9cmw7CFLGH3mMTpRwXxBT3Id2aesdbXNmEhPvcDvNOld1TGF4B2lM4uy7ixzj+AvbJygOO9kuq7SjY8zwwaJKPJmZT00ho6a8KB6BZ6aa0vzM7oSdtXxm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 07:29, Suren Baghdasaryan wrote:
> On Mon, Jun 29, 2026 at 9:42 PM Harry Yoo <harry@kernel.org> wrote:
>>
>>
>>
>> On 6/30/26 1:39 PM, Suren Baghdasaryan wrote:
>> > On Mon, Jun 29, 2026 at 9:38 PM Suren Baghdasaryan <surenb@google.com> wrote:
>> >>
>>
>> Ah, here I meant backporting either the kmalloc_flags()+KMALLOC_TYPE or
>> SLAB_BUCKETS approach.
>>
>> >> Yes, it's worth backporting, so we can merge Shakeel's change as is
>>
>> Right.
>>
>> >> and then once Vlastimil's patch is merged we can implement the new
>>
>> Vlastimil's patch has already landed mainline, by the way :)
> 
> Nice! I suggest posting Shakeel's patch CC'ing stable for backports
> and then following up with the fix using KMALLOC_TYPE. Vlastimil,
> WDYT?

Sounded like a plan, but then I realized I misunderstood the amount of the
wastage. E.g. on my system kmalloc-8k with 4 objects per slab would have
obj_ext size of 64, but now it's 16k? That's ridiculous. I think it will
even self-amplify to some extent? kmalloc-8 would have 512 objects per slab,
so its obj_ext is 8k. It will not recursively create an obj_ext for the
obj_ext, but other 8k allocation in the same kmalloc-8k slab could then
trigger it, right?

We could say it's for a debugging feature, but also it's running in
production fleets (and Android?), so probably not that easy to dismiss.
Sudden memory increase in a LTS due to this backport doesn't sound nice to me.

>>
>> >> KMALLOC_TYPE as a replacement.
>> >
>> > And Shakeel's patch is easily backportable.
>>
>> Yes, of course!
>>
>> --
>> Cheers,
>> Harry / Hyeonggon
>>


