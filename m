Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10F93CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 09:32:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C8BD8E001E; Fri, 12 Sep 2025 05:32:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A0238E0006; Fri, 12 Sep 2025 05:32:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B5E48E001E; Fri, 12 Sep 2025 05:32:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4BEE98E0006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:32:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0A87C1606EC
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:32:10 +0000 (UTC)
X-FDA: 83880082020.13.054087D
Received: from smtp-out3.simply.com (smtp-out3.simply.com [94.231.106.210])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0C0D140007
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:32:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b=K2KSDbGz;
	spf=pass (imf01.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757669528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MdbRNQz00X6py3J27RP8bnCKWb4q1OzSckJ7oG7jAxY=;
	b=GIez1UcjgM95Si4iAWNSn9SRBDR6a4OmxAsqmLkirb8ZZzS/ul69Zk6PcSxBPYcTeF4tKF
	ohTRXquz3svMByHnN/Gc95+Sw1YyJoAysEwqrETVrFMuQzwAe16H1Sp5hh9VkYMkOfU59R
	ELxXnw9pDpWHkjy/kwe/02vF1/Sqzj8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b=K2KSDbGz;
	spf=pass (imf01.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757669528; a=rsa-sha256;
	cv=none;
	b=suF/ZPufv7Gh/yEsrAx1xpaqQ+UtEtZQU7bzUfd1hLldTCnWNPC7t2D4VvBJ5EI/+cL1Rm
	WqWLq9RyEKM25VJLUXiFkSrLQBUxMiGe76ERMeX2b5HB9+6/aGIgxbyB5BnVySyGYPt/za
	YPxbndmQ/wYWuYl8BgYdqe9UbH4h3eI=
Received: from localhost (localhost [127.0.0.1])
	by smtp.simply.com (Simply.com) with ESMTP id 4cNTj20s27z1FXSX;
	Fri, 12 Sep 2025 11:32:06 +0200 (CEST)
Received: from [10.10.15.10] (h-98-128-223-123.NA.cust.bahnhof.se [98.128.223.123])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by smtp.simply.com (Simply.com) with ESMTPSA id 4cNTj10dkrz1DNGn;
	Fri, 12 Sep 2025 11:32:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gaisler.com;
	s=simplycom2; t=1757669526;
	bh=MdbRNQz00X6py3J27RP8bnCKWb4q1OzSckJ7oG7jAxY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=K2KSDbGzkvWBOxonsgdVaz4kyPUEDqqg6zdhMLv2aF3Nzko04CUw7JvSMaWWK04Lm
	 vNC1Cj2uBTKc8xdM9glCOdIXQssxtmJblCCyQc2Hi8GbcgeoJPlaNNtX0zy4fREEW3
	 r6UBaNcudI5k5SPw01Hru5aQU4tI1O1+rPvNEGW9haH4Jy2D6mmjs1dPo7LscCkHqG
	 0exPIQ+bH57TWaUThA+auuuCXOn4ogST+BxKsuMBMtASfRMsOGVWUUlnDa9TIfd9b/
	 3Pojb/BipKi+V2g4K0tvCJ/Ey32+ia3F6PZBK+f4oAwOhtLZwlnW83e9G2I0Ng81Ss
	 PBZ0wbaihaoyA==
Message-ID: <a393f6bd-ac30-4861-818c-ba0b558df4a4@gaisler.com>
Date: Fri, 12 Sep 2025 11:32:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
To: Arnd Bergmann <arnd@arndb.de>, ksummit@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
 linux-mm@kvack.org, imx@lists.linux.dev,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Richard Weinberger <richard@nod.at>, Lucas Stach <l.stach@pengutronix.de>,
 Linus Walleij <linus.walleij@linaro.org>,
 Geert Uytterhoeven <geert+renesas@glider.be>,
 Ankur Arora <ankur.a.arora@oracle.com>, David Hildenbrand
 <david@redhat.com>, Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 Ira Weiny <ira.weiny@intel.com>, Nishanth Menon <nm@ti.com>,
 =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
 Alexander Sverdlin <alexander.sverdlin@gmail.com>,
 "Chester A. Unal" <chester.a.unal@arinc9.com>,
 Sergio Paracuellos <sergio.paracuellos@gmail.com>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
 <5d2fec2b-8e59-417e-b9e6-12c6e27dd5f0@gaisler.com>
 <363853cd-7f10-4aa9-8850-47eee6d516b9@app.fastmail.com>
Content-Language: en-US
From: Andreas Larsson <andreas@gaisler.com>
In-Reply-To: <363853cd-7f10-4aa9-8850-47eee6d516b9@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0C0D140007
X-Stat-Signature: hjn3kd6btk1bqnu3au6x7pzobemh7us9
X-HE-Tag: 1757669527-554343
X-HE-Meta: U2FsdGVkX19yntznUAYCUVBadKYgJ0ClwJ0uH1Bb103HcIJsGbxUrqlopufLYEHRHzE3d1lD5dHJQMXWQIwiTYGOo01hyFnt3DD0O+BKdZRobhpzRqxg1mTyfQFIv+EiuwYbZMuLQVP6q4tT6Rcwx19BkCW6RKRkS8Wd0APBf9R44l4dZsA3qgEIKywrfu8SV50xShAxQJHmuqDLSKSfJbUitkM/OAyO7Tf3dUauMTas9RvDLw9VVnulmPi/cqoNhtbhJ+TNp8o4WmsrmnswAJSgJPiZ5zknoltDzjmtMVyJDbdUXXPl/ED4pTZMtPgHWXrPVzCYz9e552uIgl8sZL9fFG1GW86c4cqHokuckNK+v/047JxKxVWBAoT6uxFVyeVS6Ih+0m6WbtOKRqk5lzJsFQ0df/hNEpy3tFkrjJYTfbao2Ac8zwIMt2Rv+45P3eMyfKFc9CYe5adbH38ME+yzOMob74hFgwjZdrHicxzaj6J1Ur8PofbIxJv31LMBduPma0UeLdUkssgJW7hCPJYrAxlcp5IpI2QOeb86olLtGVLa9syNpW6hr0myUtSjHyAU+A4oiWT2wiFTfo9ZvDhsgq7naaXhvb5p4z2171TaEKktYhUzj2T1Si32xrYW80f0voOFp241/pMD3GjIqnHi96ogcQfAXn4yW3/4z30WL+bUyekK2ym2LEOzdVjUv5lgPyPG62XnQ//GVlXt0E+6i08IZ6xwniEMGSC4VDZWwO5MdrUIpRGckxHr1WS4q7qIwG+44BxtPPCdxQKuNhzW0tSJy6+wv0w8iS8vVjp+1ilw2F6i6zUOOP4ofrsvXgVnBto094FTPnrnVBr8qTbQ7PAOP0DEB5HEsAuqw53YfIbK41UwftcJv7hivfWzRZvI0PLEXKcF5kvtSc7O1/y0Y9f6MtSOgpUVFpa3nItKsaAKLKjv4PfB+wjpKw6kWebbQMNWaqwq5W6iuFK
 O1JLRAAQ
 pDCeI1VlsU+Ehy82GpWQcK+o/ukQKmpGIz2STUExcmZ898p3QV83/mxIgKDynYzfOtBy/c2qVV7hKtdQTtLyOZI2vGTcpquU5Go1sFkNFQxH1Z3qiS+H6eQtu6ogaeIpcd83jZGoj6QE6FZAr7XUyesDSrv+E9RAfFUKbYSB/ALMGvI+JydktIoAOsskt3DP/bMqe+a6RbfKS/HsCd6MCrV432JA1xokDTfOhvpnFJoNdTgXrN64LGsWmmPdASV8UWwjT5bUzqr8h30c9uAolLbyCKkGNlU5TAdxEDfSH2FrJ1O7LAoOFN+etl3Lr53lnbJGGE/SNYj0CYXKZ8rhoogNHIBX0YtderxQC5CWJkMtxK3wt2Zf3D86MSM35kGWbM6ci7pTO1GApyGDdfFrUD24vRMl+P80czjFQestzu/KytcgpSeNQDu9g4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-09-11 09:53, Arnd Bergmann wrote:
> On Thu, Sep 11, 2025, at 07:38, Andreas Larsson wrote:
>>
>> We have a upcoming SoC with support for up to 16 GiB of DRAM. When that is
>> used in LEON sparc32 configuration (using 36-bit physical addressing), a
>> removed CONFIG_HIGHMEM would be a considerable limitation, even after an
>> introduction of different CONFIG_VMSPLIT_* options for sparc32.
> 
> I agree that without highmem that chip is going to be unusable from Linux,
> but I wonder if there is a chance to actually use it even with highmem,
> for a combination of reasons:

I would definitely not call it unusable in LEON sparc32 mode with
HIGHMEM gone, but it would of course be seriously hampered memory wise
without HIGHMEM support compared to with HIGHMEM. In NOEL-V 64-bit
RISC-V mode it will of course not be affected by these matters.


> - sparc32 has 36-bit addressing in the MMU, but Linux apparently never
>   supported a 64-bit phys_addr_t here, which would be required.
>   This is probably the easiest part and I assume you already have patches
>   for it.
> 
> - As far as I can tell, the current lowmem area is 192MB, which would
>   be ok(-ish) on a 512MB maxed-out SPARCstation, but for anything bigger
>   you likely run out of lowmem long before being able to touch the
>   all highmem pages. This obviously depends a lot on the workload.
> 
> - If you come up with patches to extend lowmem to 2GB at the expense
>   of a lower TASK_SIZE, you're still  looking at a ration of 7:1 with
>   14GB of highmem on the maxed-out configuration, so many workloads
>   would still struggle to actually use that memory for page cache.

Yes, we already have patches for 36-bit addressing with 64-bit
phys_addr_t. Patches for CONFIG_VMSPLIT_* are under development.

Even with 192 MiB lowmem we have being using up to 4 GiB without running
into problems. Could you elaborate on why you think lowmem would run out
before 14 GiB highmem in a VMSPLIT_3G or VMSPLIT_2G configuration?

And even if 14 GiB highmem would be hard to get full usage out of, for a
board with 8 GiB memory (or a configuration limiting 16 GiB down to only
use 8 GiB or somewhere in between) the difference between getting to use
2 GiB and 8 GiB is quite hefty.

 
> - If we remove HIGHPTE (as discussed in this thread) but keep HIGHMEM,
>   you probably still lose on the 16GB configuration. On 4GB configurations,
>   HIGHPTE is not really a requirement, but for workloads with many
>   concurrent tasks using a lot of virtual address space, you would
>   likely want to /add/ HIGHPTE support on sparc32 first.

That is an interesting point. Regardless of workloads though, it still
would be a huge difference between having or not having HIGHMEM, with or
without HIGHPTE.


> When you say "used in LEON sparc32 configuration", does that mean
> you can also run Linux in some other confuration like an rv64
> kernel on a NOEL-V core on that chip?

Yes, boot strapping will select between sparc32 LEON and rv64 NOEL-V.


> Aside from the upcoming SoC and whatever happens to that, what is
> the largest LEON Linux memory configuration that you know is used
> in production today and still requires kernel updates beyond ~2029?

The maximum I know of for systems currently in production has the
capacity to have up to 2 GiB memory.


Cheers,
Andreas


