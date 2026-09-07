Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29888C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 09:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2059F6B009D; Mon,  7 Sep 2026 05:11:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B63B6B009E; Mon,  7 Sep 2026 05:11:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CDB36B00A0; Mon,  7 Sep 2026 05:11:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D5CAD6B009D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 05:11:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 59589A4C92
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:11:04 +0000 (UTC)
X-FDA: 85186396848.17.3CF71EF
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6C7FB1C0006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:11:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sJ2gDzCZ;
	spf=pass (imf18.hostedemail.com: domain of christosskarlos.kernel@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=christosskarlos.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788772262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UZwlo/PrjG/2W937OF/VpXOZ3P+Hd3ZS4n/JefxcXek=;
	b=UwwNQ8cNZgFOrPxYWOi4JtNpwKfDCGtc9Yz1eispYg4sCi9OOPfVN7I8Ub8RiYS6zF/ywE
	qtb0cxYnG5o6lmZqYJQdGwXZ+akwY1PX7pP+vOpAhfDSekjNHacD58bCOC3QjOFLmtsJrU
	RbWzIO6cippBQFSHgKPhjPrriGdQ6JI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788772262;
	b=fH8Yiyc/PQvz85sNdEcOEIDc+4KpR7cBigmiwwSQ7bP1O+fsiO5Xi2wT2IHl7ZzLkWunK2
	0ZnGVG3v9v4qvxQCr5fm5l/k5jOUG/aY/8oVw3vD55hiclw/TSPX4Son59gtLLlBPtNtIg
	nYq28kH0cgzTsrJjxOw8yWWFjLfz5cA=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sJ2gDzCZ;
	spf=pass (imf18.hostedemail.com: domain of christosskarlos.kernel@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=christosskarlos.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51c08df8513so20279411cf.3
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 02:11:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788772261; cv=none;
        d=google.com; s=arc-20260327;
        b=kgGx1urOqiKN7bz84AgqKjMizw1yykPRyx+iodytD9aZa6D8XALiDM/vCMTXbQ8jXV
         XZpz/tvnQwXIgrFhCx0jUjgosKnjTn/kezlP3Ly2+ygMu/4r3K8ptT4XeWX6JZP0HpFl
         U/Mt5uXI4hAZFwazHRGG3bEig4MRC/85SSA/DTE8WJAreQPQExx7RJbj5jcKTME4BYhp
         5C2RH4umvFSk84W6MEWoZawp6UBnbnw6HdThkdAariWFl834tWld5Nj/ly4MxIybSfQa
         IMUezgqJuuOdi3XEu+qHIBLCn6NfH5RmRJ4JEOFPuHh/LSPyfdPhbU6wpJ2hNNs+k+t0
         xCLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UZwlo/PrjG/2W937OF/VpXOZ3P+Hd3ZS4n/JefxcXek=;
        fh=I594ESs5QYkzZ8zSKsnkO3Cu9owOEDaCIQHNLn8yVEc=;
        b=rXNGvbdu6myOFzVGv/cirLFxKOq9b4LJZ2aKiDNBXkTv+Z3UzRHMTgRPpm65XISqZ5
         +mSWhFRYH/SUXM2k5H9OJ+GtHssu7Mp68m/UX24rCT/24+uWJQ//BZ8H8lUU4YXX/QAO
         LNUb0UvB+PqCpYh+fishAodRRQAD/rY4Pz9CEQT+w0sxN3zAJXcAEBuoQPAu27XvpoOZ
         EVvDlnIg/sW+ac4pZj/egoLdvCas9nSWin58d0sDgknX1Lax/A0xg5Xqti2GW9yFgWqX
         PFtufFDgma0WSCSvWBwVQKGMI/grh6mJX0v4w70wt8cjOYxyK4ke6xExqh8mXpzqUIiB
         L4iw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788772261; x=1789377061; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UZwlo/PrjG/2W937OF/VpXOZ3P+Hd3ZS4n/JefxcXek=;
        b=sJ2gDzCZKFBD/9//uNJqOUV9juozR0f4Ci1qgna6R+j5n3kNxBT6en420m2wEYeRL1
         SXDUUt3pi6yY0tnnUR3kMEnEaJcpjz5lkujvDI2CzMINPGQnmEtLu8HEGnJb/DmNB4Rs
         8WY6RSMPUJxGKashfar7V5P3lHKXTWnSFuQ5yK4h/y18kwK0XE1O8hMloH9YOw5GewhN
         9vMnUrWQt9WuVbzXQsUCXIFykzqngvweLEVfG/2Q15SCJfFqy9Z9H24EQ3Hiy+pcO0qN
         hRorlgees3fyxPcIuOMYonaCeFTKVXAeg7JeyXQN9PypU+adyWorCiFTuOEggn4q+ZLs
         MCaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788772261; x=1789377061;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UZwlo/PrjG/2W937OF/VpXOZ3P+Hd3ZS4n/JefxcXek=;
        b=qLybjvoyxdC5osMDawkB6XmXFdOxyCNtzERqjrKdO6xtiDd9OIQrV45TqkQfFdblXh
         7le2yd65FPkord8U/Vo5nJwUrBJU6R8gOnfb6boJbm5/b3/8h/AYRGnXRPyDydl2B0mJ
         xMgZv+oPSI/mdB5LfMdfOsQed3DS/V0qpR5igaUVzzpfLqtOgY4lHH8kD0FPGTznE0FU
         5wPb39muOrPXcvNuoYDDDYwQ4zXpgLb7Q05NybTtjOysFtoEP8IkTNfmm9VRjno+jACT
         09qsqJd+M88rLcfc0C01v/pX5A2YarGdbkUDIg/LsEcRO2ToQTIi/f9oDNkpWLvEriVD
         WwiQ==
X-Forwarded-Encrypted: i=1; AKwUvBxqL/5NvcodzVQdbzMJt72KNTZS1MwMnpugmJOHGxs9suOuQETOSjcif26WH4ov/zTJi+yVaWjIdQ==@kvack.org
X-Gm-Message-State: AFuF++lWIhJA2A/vXg4sHdG+c/dj+jwPkT7gLgtsqfqlaXoPS/yACxTc
	kjRsIOhDvkhEysZT6DXVR+kt6civuf2XelxkbCQkAYrqJayNsTib6C/la6qwPdHFvqqr44DXoZ3
	u8UOA3j0VyctiWbOWjOfZWBuBoBAAjIY=
X-Gm-Gg: AYBFou3b32I0Rc8DMqHEpIsJG0zH+zUvJ3hwjabzDplOgQu8ICt1YlXjxCGOUMjj26+
	HjJJ6h+DUo6yPEeXpQ0QZXB//FCzagZWsJ9Pf0c4Wd6sbFeIoj4lSxb5ZOk+6mYIFHQjNF9HdVv
	plW4DOagabsBEu1TXDdgXaMxoneSHjFgpjqbQMD2YWjulpfu0Jo/2XBBwa6t4URcIDoBTYdjX6z
	fVMHakm4Ov2VCsKxvvcNhUQ5JGiXllfmOiGq0fNpa1qnx8asTIbapJ58KeDvWj8auTRnuiqEbvs
	OZdOtnfzMpUEqGeA1ySl6wP+dHoc8NU2uuTj35Zvj6TcFGaEIVZfcyq8obQKoWspHqRhlZIavlX
	F3A==
X-Received: by 2002:a05:622a:e113:10b0:530:6f9f:d4b9 with SMTP id
 d75a77b69052e-5306f9fe2fbmr77998031cf.20.1788772261584; Mon, 07 Sep 2026
 02:11:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260905183135.20993-1-christosskarlos.kernel@gmail.com>
 <60a8cf51-1493-4dbd-8779-8f007f6783a0@kernel.org> <CAEO-viHe6hZaJzS3mjKtA8sq=tnuQOp4a_u1D56tuFx69F3N2w@mail.gmail.com>
In-Reply-To: <CAEO-viHe6hZaJzS3mjKtA8sq=tnuQOp4a_u1D56tuFx69F3N2w@mail.gmail.com>
From: Christos Skarlos <christosskarlos.kernel@gmail.com>
Date: Mon, 7 Sep 2026 12:10:50 +0300
X-Gm-Features: AcwNN1VHz2Dx5JOhnvUzjOQL5MbqPSr2rrgIgq7g1Q4-0tJN6hN6Ipr9L7HFBoU
Message-ID: <CAEO-viEyRBBWGzs1kDv7tdzYwuS4b75jm6abU5WcLN5iUD+54g@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] mm: minor janitorial style cleanups
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev, 
	osalvador@suse.de, ljs@kernel.org, hannes@cmpxchg.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, jannh@google.com, 
	pfalcato@suse.de, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, mhocko@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: zcn5xn9jt4738xoqrbgm15n7m5i4y79q
X-Rspamd-Queue-Id: 6C7FB1C0006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788772262-545441
X-HE-Meta: U2FsdGVkX19Z7nEiZuQl7CCEVjoul1vXfH8LIX4tq+y4u4v4a012Doiy42T9pvJGkx7A+sRPPq/Xhc8UxDpUvc5oLEyU1bXgMscT9oQ6L2ZmUzirNbav6iiioYU9SwDGgqQRxgWAZRlkdS6txoTNgAnUhWI5cnR9tZxrA3P1WO8Y2ZwsrHZz1WjAxjeGsPEunvsmVK+2b50bFgfUWjt1NpCHYa4uOiUNlAYY+uiQ/Q1nuUS8Y3gLyMfjknURj2OfAurOd2R2rWNTM3Jop0k54ETdeKmgbSNyDh8fR/xjC7duJbrIMeHWcgJpLFsy5IerdHTqJCZEHeRicTdjjI1eD6U9RzqStKVrE7DUuVbptTw29hTg5++HlSZmRLZ7ET7wE/DONxee/0QmQn14UxPTSr37wHbv/wmsSP8RhqHAl+K5j2I2kt4/poTV/YmmwFW/H6/GGglin1DX0ku0KrJVXdyBZd4Zxptmv/CBH5agBRGYgFaV0GTcMNEFDKq7cCq92r8fmKIhbcxWuTcPcT+nM5y3s+pzI8GBZTFtS/MNFlJNeBD14onXVe2z+fXJWxLGUNLqIjYJFbWOo0+8N13n3oTLi56J58PiWQj0ViZylZ4S2wXxsluO0Ys2PLoPGD9h6F/VjZztUY6UHf/s1qmOQizd6QSaeF83rPO0Krau4OCQy5vFJa6vWXQaQLe+hrwFTu3W5eBNZAIOWTVq9WWPElKsJ0/kZMLKmV32O3oOPROHyUyDqTPdHI13Ntp//i1UnA6mQy1Dy2KS5J9jexluv8Ct1/EZ+xH4/nVy/gClQWSU9VTQt6jRDJx3tf5hqvAVkHpWKT2w/zNpcEqGFrP76QHUDHSk/4LCCOOBEVknuzUxrg7imAIPvH9ZYVlKt8OqM7gfCAsRFqfwJtsVl3b52p7uA2MtDY08twk+nlK6RVht344zrRxLU+OV0wrAJPiKRcAV7P4Nci6aZQVBETz
 dCduwo+c
 +GFXZQ3EKyyOfIK/mlP/RbF2n0fpDyDyrHVR2CUFxMtdoVwiYo92Y84Dqwb8yV72Dw2nQetWj3ex0qUrL7JeMrZ/ysHkBOGFjv6jIHfpemRe3JrvXyt/zHDdHGVZFdnUVINMkfEQY0oeGszp0ZeLv1hR24QUOnyzkLnVPcq0qlk+SWeASxqvwLn4CdobhM2jzGFKiPf9iR3qfbdcdsZTbFZWNntwdUOTngGam0hCctURzLV9b42/xLrmlUs1l/YxfeGT6CzuXGe9RqxVTVet3npMLUaG0E44pLYO/48MTPnf4A/lxF6nwflgYDJ8wQtxrJaURft1CLPA7wR17NCOSL03kOqKEAKxxjcEKHkrR4a70Uw8Ln2k0C93kwNl49KZErF9PYnwELfe16cs/jttO0mTQ8h/thOjS4bxRldhm89PFGUnnaomuBN7FiU+TP2A5sNjKR5sQJfPYctlS7mUHgqVDGwFIjL89VKuV0pr1xryLSeE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey Vlastimil ,
Understood. Thanks for taking the time to explain the proper scope of the
checkpathc.pl. I will drop this patch and keep the tool strictly for new co=
de
submissions moving forward.


=CE=A3=CF=84=CE=B9=CF=82 =CE=94=CE=B5=CF=85 7 =CE=A3=CE=B5=CF=80 2026 =CF=
=83=CF=84=CE=B9=CF=82 11:58=E2=80=AF=CF=80.=CE=BC., =CE=BF/=CE=B7 Christos =
Skarlos
<christosskarlos.kernel@gmail.com> =CE=AD=CE=B3=CF=81=CE=B1=CF=88=CE=B5:
>
> Hey Vlastimil ,
> Understood. Thanks for taking the time to explain the proper scope of the
> checkpathc.pl. I will drop this patch and keep the tool strictly for new =
code
> submissions moving forward.
>
> =CE=A3=CF=84=CE=B9=CF=82 =CE=94=CE=B5=CF=85 7 =CE=A3=CE=B5=CF=80 2026 =CF=
=83=CF=84=CE=B9=CF=82 10:44=E2=80=AF=CF=80.=CE=BC., =CE=BF/=CE=B7 Vlastimil=
 Babka (SUSE) <vbabka@kernel.org> =CE=AD=CE=B3=CF=81=CE=B1=CF=88=CE=B5:
>>
>> On 9/5/26 20:31, Christos Skarlos wrote:
>> > This patch series resolves various coding style issues flagged by
>> > checkpatch.pl across mmap.c , vmscan.c and hugetlb.c.
>>
>> Checkpatch is meant for avoiding the issues when submitting new patches,=
 not
>> to be run on the existing code to generate fixes just for the checkpatch
>> issues. NAK
>>
>> > Changes in v2:
>> > - Restored filename comment at the top of mmap.c.
>> > - Restore <asm/...> headers in mmap.c as they are architecture-specifi=
c.
>> > - Remove blank lines above VMA_ITERATORS and NODEMASK_ALLOC declaratio=
ns.
>> > - Fixed commit message typos.
>> >
>> >
>> > Thanks for the thorough review and guidance. As a newcomer every
>> > feedback and advice is really valuable to my workflow.
>> >
>> > (Note: Apologies for the stray huge_memory.c patch included in v1 by
>> > accident; this v2 series correctly focuses strictly on mmap, vmscan, a=
nd hugetlb.)
>> >
>> > No functional changes are introduced.
>> >
>> > Christos Skarlos (3):
>> >   mm/mmap: fix various coding style warnings
>> >   mm/vmscan: fix various coding style warnings and errors
>> >   mm/hugetlb: fix various coding style warnings.
>> >
>> >  mm/hugetlb.c | 16 ++++++++++------
>> >  mm/mmap.c    | 12 +++++++-----
>> >  mm/vmscan.c  | 11 ++++++-----
>> >  3 files changed, 23 insertions(+), 16 deletions(-)
>> >
>>

