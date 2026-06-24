Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0EB2CDE001
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 15:17:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCD606B00AB; Wed, 24 Jun 2026 11:17:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA59B6B00B1; Wed, 24 Jun 2026 11:17:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A941E6B00BA; Wed, 24 Jun 2026 11:17:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 872AB6B00AB
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:17:09 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F396FC1AE7
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:17:08 +0000 (UTC)
X-FDA: 84915159336.24.0EEED70
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4F1E720009
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:17:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AR11iw+k;
	spf=pass (imf31.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782314227;
	b=NLE/m3bQATC6g828JLekmcqxWB9YQYIZYdJSGcJIX2AztDFwj0MqjVGB8h4qBw92j43M3M
	YrnpChSCSV58fpbN/X/kpMZXL4yA9uPHZP9j8SrInqc+xcMaprwf9ml8XtdvP80n4i1Sty
	ZD+kv+GbFCBHmjgoJvsTk1UtG/cs7hw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782314227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3pkskQ2++eDyNw2xnVvM9ZHICcQFK/ShGMe6urYxz4Y=;
	b=MjSit117GD4naqyKlIFHfmovOsjnY5dlgFvxE4EgQV2K5Uo1ETtz+9k9lL/i02RWK08hqn
	cv+lKPJrhiO2C84SsGs9fTHBPisB58eUEkN7OKm5Icg4b8W9MxcGQK1pFkZ0X69c/uCr84
	mRh3vqDYBLNu5wriCoKLpAqrX8FTaM8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AR11iw+k;
	spf=pass (imf31.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D189460018;
	Wed, 24 Jun 2026 15:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43EF61F000E9;
	Wed, 24 Jun 2026 15:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782314226;
	bh=3pkskQ2++eDyNw2xnVvM9ZHICcQFK/ShGMe6urYxz4Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=AR11iw+ko1EXT45M5uLTzAPEvSIeSa2yGRu91808JZKaUqpY4V/hmPR/siLDNhkWM
	 3ANzx8JIV652LAnnPJOdBJFp/okW2Ym4CyaG/H5AqxNFpS/k3yp4SEmMNK3D2PZByY
	 xnPAVKULx20atCcrnF5n4OSOuwDCpZD90KSZgwd/2BzN0p1KF87CHHyHc2D6fn8InM
	 19VbNQagtJ7FdIKq86FaXexq/l6msAVFf9R5++IN/U5bCcX/xf8Z/tbvqUmfZd60U9
	 w9NaIGmLCzVoSriIHaWhPlF2nTWjePGJeQdjDhJxGy+KhT6e8tz/jWZpVEiTGG5ZSx
	 FET55wtSnO7cQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Rik van Riel <riel@surriel.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Breno Leitao <leitao@debian.org>,
  nao.horiguchi@gmail.com,  linmiaohe@huawei.com,  david@kernel.org,
  lance.yang@linux.dev,  akpm@linux-foundation.org,  baoquan.he@linux.dev,
  rppt@kernel.org,  kexec@lists.infradead.org,  linux-mm@kvack.org,
  rneu@meta.com,  caggio@meta.com,  kas@kernel.org
Subject: Re: mm/hwpoison: persist poisoned PFN list across kexec via KHO [RFC]
In-Reply-To: <da460b26bef42152bf23d395f845503ad8eedc4d.camel@surriel.com> (Rik
	van Riel's message of "Wed, 24 Jun 2026 10:44:20 -0400")
References: <ajut_LDQGYCShApx@gmail.com> <2vxzse6ckqfg.fsf@kernel.org>
	<da460b26bef42152bf23d395f845503ad8eedc4d.camel@surriel.com>
Date: Wed, 24 Jun 2026 17:17:02 +0200
Message-ID: <2vxzjyroklxt.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: jujpc314e817wdszbnik9h4yitw5cgxx
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4F1E720009
X-HE-Tag: 1782314227-205119
X-HE-Meta: U2FsdGVkX1+LFzozXr7djobLk8C5HzEZrhsWO/QMBipHhmLNtsmIoRWdkP0vFa+FKfyBK4eKqoQgQHmftxWtDpk3uplSvjMY19R4TQv6LqfIA2qQ2F9D4NIzeNMdp8ENpfN4Xb8qhEsWFH/Df4whhAdD9T+tjIq5bmfwvbEzS0oPKdHNcxZhbL9iuDUw4C/IZFTcFtwjAX7iyVOtT9WHCC8s8YSNtkvjSjH7GpH+cYUNr9wuzqNJPM1zRVxENcF87YZVJwf0tZtg/NO4KpBoEQyD9M2pUQ7iDjW3RJC9heRtYf1yyRrec+xGpI01aV96Oo8g1MsVHURLwmcX9mjjSbRIhaLqR/gEo4N1sATfUv4LKA9qI4RxRqMYSdSMPMPPdfKO//92VfrJBlWNq6wFmoRkS1POB/sQ3YyaeqamrdByamJNmTDyo4gIkVUVdZ2wCeoaMq84ysjYgFPSdn4X5c96zCe+UXHjviOhIDYhbPfSjoqKUmND3J+s88lW8jai9Y37sRuTwLaOlF6XaF91dlIeVvr9C6E63Yo/SebqGAeLEhORmNKHF+VcRp/+MqKuiaqhrR8TSJCs0Upcn7kOeOadOYFpB0jXhGjk/I4hznuhzVG7t7tGeC5z3H9RWJB3+0HCmm+wAoVJodncJf+vnND+jrtzJGJJWOO5WJiA2s4u4S3rBLunlrYzT4fPtjWgjGD/cWqJoRRECrHdqBgE8Lff0q1R2D8Lbnd1mk+SS7QEacfHYxnyF6X7SXXIqp54+0+6zhAooD/eM++BZb6A2YjNKUNquYC9BGW8LZWqjHAc9JTfistAtxUz1VgRaN8TeLZJozyREtcCI5RSNb5LuN9YE9qGIsgc+oeCZWH2u45TwSmhJVqr/eIM1qNeY9gys+x9P370p3zoMdPYmTYZhOa4LbV4JMinPUeBUEE80igmAolbGB6wHtKq8BJwSQSzM30/ValOEZFc4yVkhbk
 6GlqNoM0
 RKRsK45YJKfuHwcvAInaM3NGqS3rztvN8aID7FW1JHxBAWq+r3fxUA/3PWgzyzYxO1uMcMONA6nlvxOh7SUppYijAVLU4K+zLWavRH6+hor1Fr92JMEcA23AqgBT4naXvVfjMEtJzCXnMQtPlSrTtd1pfzhjp3z+weBNMY1fq/eNCZA1rmFChmL5g2wUHe6u2sT8Grt03R77RjIKl0Ps4Rp24Oq/gKRjmRP4t6vD9qfW/ozbv7xBBwEwaLVJiq0HRnF/ZhRSbL9kfaQ+/YrFM+b4Jw+XzV8D10Njqo0ZtIB6u3oM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24 2026, Rik van Riel wrote:

> On Wed, 2026-06-24 at 15:40 +0200, Pratyush Yadav wrote:
>>=20
>> Also, what happens on cold reboot? If the HW does not remember bad
>> pages, won't the kernel be in the same position? How does it know the
>> bad pages on a cold boot?
>
> Some modern server hardware will simply unmap known
> bad pages from the physical page map, so they will
> not be exposed to the OS after a cold reboot.
>
> The hardware keeps a log of uncorrectable memory
> errors somewhere in memory, for example in the SEL.
>
>>=20
>>=20
>> >=20
>> > This PoC
>> > =3D=3D=3D=3D=3D=3D=3D=3D
>> >=20
>> > =C2=A0 * Makes hardware-poisoned pages survive a kexec, using KHO (Kex=
ec
>> > =C2=A0=C2=A0=C2=A0 HandOver) to carry the poison list between kernels.
>> >=20
>> > =C2=A0 * Producer: hooks num_poisoned_pages_inc()/_sub() - the single
>> > =C2=A0=C2=A0=C2=A0 chokepoint for every poison/unpoison event - and re=
cords each
>> > =C2=A0=C2=A0=C2=A0 poisoned PFN into a vmalloc array that KHO preserve=
s across the
>> > =C2=A0=C2=A0=C2=A0 kexec, described by a small versioned "hwpoison" su=
btree.
>>=20
>> More of an implementation detail, but with vmalloc array, what if you
>> have too many poisoned pages?
>> >=20
>
> If a very large amount of memory is broken, you
> should probably just repair the hardware.

"large" is relative. On a 2 TiB system, if you have 0.5% of pages
poisoned (I have no idea if that number is realistic), you have 10 GiB
of memory poisoned, or around 2.6 million pages. To store all their
PFNs, you need around 20 MiB of memory.

While not too large, it isn't trivial either.

I think static data structures like vmalloc are likely not the way to go
here especially when we have better things like KHO block or the KHO
radix tree.

Between those two, what is more efficient largely depends on how many
pages you'd typically see poisoned and what their locations tend to be.
That I think we can dive deeper into when we take a closer look at the
patches.

>
> Page poisoning is good for localized memory
> failures, but not for failures that extend across
> much of a memory chip.


--=20
Regards,
Pratyush Yadav

