Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20C70C3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 18:40:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE3EB6B0088; Wed, 14 Oct 2026 14:40:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6E896B008C; Wed, 14 Oct 2026 14:40:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0FFD6B0096; Wed, 14 Oct 2026 14:40:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D43286B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:40:56 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B6502140778
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:40:54 +0000 (UTC)
X-FDA: 85322098428.28.CB52F44
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf05.hostedemail.com (Postfix) with ESMTP id E2EC1100002
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:40:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ISIkMWdy;
	spf=pass (imf05.hostedemail.com: domain of klarasmodin@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792003252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5XehtWRHe4CRZCUlTIf4w4Y3AhoUdGKPHSw8atLC5qs=;
	b=PBZ1z6P1iSttpi87ynHeigjY53VFa+/9Ib4Lyxt18DNz3O4//TOLwCiJuZ8d+G1Z7ago1J
	+/lPlbPO0UBAa8R14TBQ2LpdGcnI2aliE/I9vJxUOENjtNzuNwxwTNlx+7Mr2RD2Toeci0
	9y/aAfToDK351uCmveKX8dc6kDLJVQg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792003252;
	b=mTwP/v+1V20aMoFb21iGoMVGBZRr2SCeEcqxuK3lEorInMrMLBJv3U56QU64QPZRdl1SrY
	WIWc3Hlsen0XLrpmLTAnJRq19WIbDzOFcve4+tLOMVmpbLWAVsy5AxSXOOQ0nPleGx6Y+1
	gEpUvJ0Du+PdoIO8lA7A5LVn0JHJ8v8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ISIkMWdy;
	spf=pass (imf05.hostedemail.com: domain of klarasmodin@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5bcb2eceb3eso4080688e87.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792003251; x=1792608051; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5XehtWRHe4CRZCUlTIf4w4Y3AhoUdGKPHSw8atLC5qs=;
        b=ISIkMWdyCITkCTnW83Qk1z7BimyVjI+tc7n98wpipE1d0dKdsodOZNMM2ASjXa/qeo
         5iLD5nqv2n4UmQdu2XdZHxzxf5KEUghWdu/3ycVe1oTpnlWa/1AGQ7pI/J7o6DnOyr2g
         Gn+xwuA8Bdh24H17h3opK3qIeB3Az9o0nucrgKDVhjaVMAZjCUvuPVWv6Z4tRDOgaXoV
         zg3AZoesjlrGO9BDvfxjTFsNKlEPkVLgjG99pUYMNGyqOn/lFqqInRNOSjX3G/qQ8lWB
         1ndfnTM1bAkzNBymVKzi31pKlqlsWkr8hy8rrd/F+ZYFNGLLcSDoeHtnbYvpZBXy4A8K
         YqPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792003251; x=1792608051;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5XehtWRHe4CRZCUlTIf4w4Y3AhoUdGKPHSw8atLC5qs=;
        b=yJzDb/NHnjlJd5WKtRXccABzAUI281NpjXz0ZAuFtV++t1mCEXUpfSqZKcUOMlsZgf
         vM6suiKmO2+cOIKmQqkM9fc7oIs7GGfQr3vwLQUOnf8uPTlxI4mqgxzUwxink9TQuhzN
         JVJVyrEhl6403DdBCurEoy3TsoG0hZUsDFPLfK9IQX/qkGX3R/9kl1mVvc9gi857dYOW
         kbSPwkJLTRZkO2eGR9/wBQ/rqmTaNbga66oe2myvyzzCWKdB7DRV1ff/0O1iNXNSHPOc
         OsbDVEdPH5iYDgvbsAZtdWfM7SJlLXg2kbeiADe9dUpX5ZW71l9k41JAfHW8JYfQYkMp
         DSqg==
X-Forwarded-Encrypted: i=1; AKwUvBy213Ee+Ta2X+4SD74pN9CdUIQmM6XXMm6x1mR5w7ntWvFO1G7xFF935VmN/0dB0BcDZG+2cQSz4Q==@kvack.org
X-Gm-Message-State: AFq9FYLOQkwJw2oZMwtTpxPllIblPmSbPXPcsjKQnOBJdgJgdBRz8spM
	r0YZFD9zXzlhKcVniYxT4Slsy2gxWKOUuZk4e2TJnbYWfk24wGdytRRZ
X-Gm-Gg: AYBFou0fB5BOagtm4ju3CWI0WpUiES5KNYznRHayi9xL1IEBnVOGHjZrA3yIdWWgvV+
	5tGFIWNE3XNx999aElhvCPa6NeE6CricERXf063YYLHBt62TRE2s3zuUYZqrsAF1thJ+3Z4K2gY
	o2BouwZfTYuwoI8/RWypt0YgZpb33VeJ/nDUuQt1F58s3L7Xe3gGJYowFqsgZunOLlNJpLrA262
	R3krZz27/LI7KnFtiD+GNXF/g0w2oj7AzA2u17MEXJ2UOGdtngq4VHhQ5eJ3NPPwPpfnvvxxm1J
	35dKu8asdzd6sd/SAu84SJF0mMxSK2PAgSnPCVG/922TS/dhgLz+q1H9Tf7ne2vYf3mVFXuUn66
	OUnzyfz2ijzK9ReIphjFns2a4gSl6/eVlaMkJGe6BL4vL8qDu1AJVMN3z5fDb1sv4Sob6Ttd4si
	aNlthq3uoJENMxjdoZesCWlw1CxaYmMy93rZ+aW3cA/pSOzRMQs5/TFsgsrzWwvpa34kCwf6fhg
	BehrGkW/1Rh2Qeq2kglJDPDogG/
X-Received: by 2002:a05:6512:31d5:b0:5b8:c763:67f7 with SMTP id 2adb3069b0e04-5bcde6c0076mr6508273e87.24.1792003250860;
        Wed, 14 Oct 2026 11:40:50 -0700 (PDT)
Received: from localhost (parmesan.int.kasm.eu. [2001:678:a5c:1204:5508:6e19:c6a3:9875])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5be33feff92sm785393e87.0.2026.10.14.11.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 11:40:50 -0700 (PDT)
Date: Wed, 14 Oct 2026 20:40:49 +0200
From: Klara Modin <klarasmodin@gmail.com>
To: Baoquan He <baoquan.he@linux.dev>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org, 
	akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, hannes@cmpxchg.org, 
	nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, yosry@kernel.org, 
	shikemeng@huaweicloud.com, chengming.zhou@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Subject: Re: [PATCH v4 00/14] mm, swap: extendable swap devices (xswap phase
 I)
Message-ID: <as_MPhc4HcXdgUTe@parmesan.int.kasm.eu>
References: <20261003003136.750633-1-hebaoquan@kylinos.cn>
 <asZt7-8mcxqc1a02@soda.int.kasm.eu>
 <asylV5YyyaHs8rP3@fedora>
 <aszb4OgUUCh5JHle@soda.int.kasm.eu>
 <as4F9wxsMwNsg5_R@fedora>
 <as4gb7BdnFffV4SI@parmesan.int.kasm.eu>
 <as-jZpQBQ9mMNqlH@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as-jZpQBQ9mMNqlH@fedora>
X-Rspamd-Queue-Id: E2EC1100002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: dq1nawoyzudx61syjyhyupj8ehbg93f7
X-HE-Tag: 1792003252-273508
X-HE-Meta: U2FsdGVkX1+5AzvEFkAgQWlv1/5ml8SEsFswiUNYO/fkeXXWmsKkNWL3zEGXrftmHAddjEXPZA3cexA+dhstUnge1/cnjAUjdAX+VnbgqQOIRJXuf9mZNJ4k0YoZjMz4sUWhDhFrJkfURrGk+gdnccPAt0kQY820N0aNg/COmKbTxeaUoNYu6AQrtE4o0Ln+ML0JSLzITf/SuZ7ids8sfnaXPU15wi5LDooni4pH2k3NHTkODWgLYfkGZx1jWsyVrgIlVFOBZu3BqKU0xy7nCtWZyKU9hLm8NOslMgxKtV9rH2unPlR0fCsd7dDiHnYY4LIyJsqaGsthaCRKboPQrOEO6tRJfn73Yd6KsmJ3rQgPS61VI0nlpPQlWz7xdSMXMGf+pyx01afG2xaoo+1sViRg8aYiEpUv8+JrZgiIVru1k7618OQ4e21L0nc2kY85aF3SdEqUo5V4sSGxXrGpS1Mmi6tB0z1aJ56HqEY7O5GYDujFnp0Nfl0nX/k4HmepFCykkleAU9NBVl704eXS6WFA/HocOEN/2jfkIDpXzPUGA+0Q1Ins0HHOrs1LH+jpO41PvXWmupNB2mA/fjPeapWyQz8NMQMiARGBhjvTkTfPiEVzAMGba7J5G258P9Ym7vQaIfaDywmqArWZ0bDsQEOTAyyAV6Aopfuzj1VUFmSp7iTmB/ehGj/WlAOU8EGyYEDrFzpKbnIWASl83icZ4Tg02FBFU5rx+TrlcvwVaJKAyWGufDl7YxzGkq2WxxylEfKdc4C4yzNurpRGrA/rwcjKr8RVu4ehtGysOcWKQJtfeUlJF6oZpmNinoMIbsyc9x+gR7rh+dW9OZLNfPWqBBFOIRHa8J3cH37rBklOUWfBeNWaSEZ7uvHLm3ldC55eedPD95GYr7Z8Z9Z8lFRUAnCU6tNw5cDjsc+FFGMYzzBwF5uy32CchrEPIRDDoouh8boGShWV5DOUN8s7yVa
 h78GWWSj
 iFslLOOq48bO8PBOFsYwbIoBADRp9PZRnlrl17Qx0nBN8ASfurN74E5WuUEsFrOMY37bjfDxmGzFEi3LVog0c2kxn1L9mQnwVzbuDOvKg+6djSZV5bvA+MvLTTVhaKP1L2ZY9nrl3hB2puijr6QPmMtQ/wDmhIyr+G0Yrqpqmu3WVdCMgxG8tRIxrZvF4HaozZWPVYzhGs93R/V4NoISBZ2G1Wh8R8CA6Cw8PcXQWrJf2ZhEgJy5B0O23Cb4qujAtf1bMdachYW/0sTsXx1atkDHzFPOp38SYRQrFrucUzwWbr03klpxjygGlnbiqv5TpdH4OBPZNvVljmMCd6TgKyQlKTKEvhucxx1ix/j+ZHUgFnytQNRtYyxgumVhYPjCQppWJ4lbWQYyEL3KCUsachgGJkBvHpVPDtbkF/lG2oPjL8bw/VVaPFF1nHiBwXbaKCDwnQnaP0BRyQ3/q//+aU0tVhLVc3abd+DQqaBgLeBVEg9N0Ug75pKC5+6/dVmNF8XYWJj1TOD30Iueh+41M7YW5erwM7xDpqtP0gNv1afNIIw/e3ms3GCkI6dK8SgXArtTBCPaEcfUppaDOdGiDeomiLKSdklvaGoRe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(Resending since gmail rejected my original message. Sorry if anyone
gets a duplicate)

On 2026-10-14 23:44:38 +0800, Baoquan He wrote:
> On 10/13/26 at 04:26pm, Klara Modin wrote:
> > Hi Baoquan,
> > 
> > On 2026-10-13 18:20:39 +0800, Baoquan He wrote:
> > > On 10/12/26 at 04:10pm, Klara Modin wrote:
> > > > Hi Baoquan,
> > > > 
> > > > On 2026-10-12 17:16:22 +0800, Baoquan He wrote:
> > ...
> > > > > 
> > > > > Thanks for the comment.
> > > > > 
> > > > > Here xswap.max= is a global boot parameter, while not a per-device or
> > > > > runtie knob. It sets the space space (si->max) of the xswap device
> > > > > at boot and can't change at runtime. So on the two places: the size is
> > > > > a global setting, fixed at boot; the priority is per device, it is in
> > > > > the create interface. They are different things.
> > > > > 
> > > > > The default is 2xRAM. From our earlier discussion, this is the largest
> > > > > size we think is sensible, and in practice I don't think it is not
> > > > > reachable in reality. If a system has swapped out 70% of its memory, and
> > > > > even more at 100%, it is already doubtful that it can still function
> > > > > normally. So 2xRAM is an upper bound, not a target.
> > > > 
> > > > I'm just not sure this is the case. An application could have a
> > > > relatively small working set but a much larger amount of cold memory it
> > > > rarely touches. In my GCC 17 example, I saw even greater ratios later in
> > > > the build process. This is from your previous xswap version where I got
> > > > around the 2x RAM limit by using multiple xswap devices:
> > > > 
> > > > MemTotal:        3966828 kB
> > > > SwapCached:          868 kB
> > > > SwapTotal:      80232412 kB
> > > > SwapFree:       69467760 kB
> > > > Zswap:            792048 kB
> > > > Zswapped:        6342024 kB
> > > > AnonPages:       2072820 kB
> > > > AnonHugePages:      4096 kB
> > > > 
> > > > This is almost 160 % of RAM in zswap and is getting close to the limit
> > > > in practice.
> > > 
> > > OK, thanks a lot for the concrete testing data. It truly is reaching
> > > almost 160% of RAM. However, it's a little different than David's Windows
> > > VMs case. In that case, those VMs's memory could be touched and swapped in
> > > in a distant future. While in your GCC build process, it's running and
> > > costing memory, with 160% of RAM in zswap, it was probably close to
> > > hanging? Wondering how long would it take to finish the build process,
> > > and how long it would take to finish the build proces with e.g 20% RAM
> > > swapped out.
> > 
> > Might be close to hanging, I don't know, but it's definitely under quite the
> > memory pressure (only two AnonHugePages, implying either very fragmented
> > or that they are split after allocation). Worth to note is that it hits
> > the zswap default limit of 20 percent of memory for the compressed pool.
> 
> I see. If so, it may not be a real use case, but only a corner case within
> an experimental environment. Because in that situation it's hard to say
> the system is still functioning normally.

Well, the build completed successfully and the system was at least
usable afterwards so I would still call it a real usecase.

> > > > In addition, if I read your writeback series correctly, if data from
> > > > xswap is written back to a block device, the space of the written back
> > > > data cannot be reused in the xswap device (please correct me if I am
> > > 
> > > Yes, you are right. xswap slot need record which backend slot stores its
> > > data, so xswap slot can't be reused in this case.
> > > 
> > > > wrong). For low memory systems, I frequently set aside a lot more swap
> > > > than they have memory. If I do not grow the xswap address space size, I
> > > > could risk it getting full if enough of the block-based swap is used.
> > > 
> > > Got it. Even with normal swap devices, 50% full will trigger swap
> > > reclaiming. 
> > > 
> > > /* Swap 50% full? Release swapcache more aggressively.. */
> > > static inline bool vm_swap_full(void)
> > > {
> > >         return atomic_long_read(&nr_swap_pages) * 2 < total_swap_pages;
> > > }
> > > 
> > > > 
> > > > Looking at the example again, about 10 GiB of swap is reported as used,
> > > > but some of that is being reported twice (once through xswap and once
> > > > through the backing device) due to being written back (which I still
> > > > think is not so great). In this case, the system has 16 GiB of
> > > > block-based swap, meaning that the default limit would leave the xswap
> > > > device full if even half of it is used through writeback. If I would
> > > > only have a single default-sized xswap device in this example I would
> > > > likely have hit this in practice.
> > > 
> > > I see, so a larger swap space of xswap is expected in this case.
> > 
> > Yes, due to the writeback still needing the slot in xswap I would never
> > want to have less xswap than block-based swap.
> > 
> > Ideally, I would like to not have to take the amount of block-based
> > swap into account when enabling xswap/vswap. A very high default limit
> > would be one way to solve it. Another option could be to automatically
> > create an xswap device with a size equal to the block-based swap device
> > (maybe a mount option?) on swapon, but this feels kind of like a hack to
> > me.
> 
> Chris ever suggested this way. With it people can set in /etc/fstab and
> make it take effect during boot. Not sure if people like it.

That's not exactly what I meant. What I think you're referring to here
is that xswap itself would be enabled by doing swapon on a specially
crafted swapfile header? What I suggested here was that when a regular
block device is swapon, it would also swapon an additional xswap device
with equal size to the block-based swap device.

My reasoning here was that this would alleviate the problem where xswap
would become full because it had written back all its data to the
block-based swap device.

> > > > > On the max short name: it would set the address space to the largest value
> > > > > the format allows. As you said, that is close to vm.overcommit_memory=1,
> > > > > and it is not a real capacity, so we may not want it as the default.
> > > > > 
> > > > > We keep xswap.max= only for special needs. Otherwise we may not need to
> > > > > change it.
> > > > > 
> > > > > Chris suggested a CONFIG option for the size. While CONFIG is not friendly
> > > > > to distros, you must rebuild the kernel to change it.
> > > > 
> > > > For my use case I would probably prefer a CONFIG option if that is the
> > > > only way. I typically build all my kernels on the same machine and send
> > > > the image either directly or for netboot. Setting the kernel command
> > > > line can be very different depending on the system (Different EFI
> > > > bootloaders, U-Boot and all its vendor versions).
> > > 
> > > From the actual use case and concrete number you provided, the interface
> > > can be adjusted like these:
> > > 1. 
> > > CONFIG_XSWAP_DEFAULT_MAX_PCT=200 
> > > default to 200, or default to the max value?
> > > 
> > > 2. 
> > > xswap.max= can override it. Or a xswap.max=max can be provided?
> > > 
> > > 3.
> > > The sysfs allow people to adjust the max size and priority:
> > > echo  > /sys/kernel/mm/xswap/create
> > > echo max=10G prio=100 > /sys/kernel/mm/xswap/create
> > > 
> > > Could you help comment if they are OK to you, or what is not needed
> > > actually or not good?
> > 
> > I do not mind having both a CONFIG option and a command line option for
> > the default where the latter overrides the first. I also do not mind
> > having the limit in sysfs since I need it to create the xswap device
> > anyway, but having all three together might be a bit extraneous.
> > 
> > However, if this is put in the sysfs it might be good to rethink how it
> > is structured. E.g. do we want to do so much string parsing when we
> > could instead have the limit and priority be separate files? I quite
> > like how NVME target handles this in configfs, where the user creates a
> > directory for the hosts, ports and subsystems and each config option is
> > a separate file inside. So for xswap, the user would mkdir
> > /sys/kernel/mm/xswap/typeN (or whatever) and have a structure inside
> > with something like:
> > typeN
> >  |- enabled # 0/1, which would actually destroy or create the device
> >  |- priority
> >  |- max_size_pct
> >  |- max_size_bytes # where writing to either would override the other
> > 
> > (and only accept changes when not enabled) but this might be more
> > complicated than we need. Even better would be for the defaults to work
> > for everybody since we wouldn't need the knobs, but then we would have
> > to agree on what those defaults should be.
> 
> Yes. I ask people around, they are all surprised and say how come 8PB
> is needed. And mobile phone people care about the swap amount, they only
> allow several GBs swapped out to zram with RAM of tens of GBs.

What drawbacks does having a 8 PiB address space for xswap actually
have (besides that with your current implementation it would essentially
mean vm.overcommit_memory=1)?

I tried to look in the other thread, and from what I could read, it will
result in more metadata, but only if that space is actually used?

8 PiB for me satisfies that I would not have to care about e.g. the
amount of block-based swap the system has.

> So how about these:
> 
> 1.
> CONFIG_XSWAP_DEFAULT_MAX=
> max; 8PB
> size; e.g 10TB
> 200%; percentenge of RAM
> defaults to 2xRAM
> 
> 2.
> xswap.max=
> can override CONFIG_XSWAP_DEFAULT_MAX=
> max; 8PB
> size; e.g 10TB
> 200%; percentenge of RAM
> 
> 3. 
> echo  > /sys/kernel/mm/xswap/create
> defaults to 2xRAM
> The sysfs allow people to adjust the priority:
> echo 100 > /sys/kernel/mm/xswap/create

In my case I would then set the config option to max so I would not have
to care about it.

Regards,
Klara Modin

