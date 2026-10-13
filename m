Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15A15CC6B08
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 10:20:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AF6A6B009B; Tue, 13 Oct 2026 06:20:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0607E6B009D; Tue, 13 Oct 2026 06:20:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6B686B009E; Tue, 13 Oct 2026 06:20:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ADBB56B009B
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 06:20:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3A9CF120428
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:20:51 +0000 (UTC)
X-FDA: 85317209502.06.4A4742F
Received: from mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1AA7320005
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:20:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vveQ9Ws+;
	spf=pass (imf13.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791886849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bmW9JBSoICHa8nfZazsFb7QT2Teumw2IiHKzaqZwAXc=;
	b=FXG/KTxrPtdnMhCxIFIgZ/aoz2D955nnEFT4htRDzFiEaSpIv8utK1lYtY1PRkzfC9ByBb
	ph/UQVsl5mk1JJA2wcvituf5MwoWS5/h3+9IY0d4ei8uIx1h0BbDRBdkjdcP5QhgIFmBBi
	81EtHrc6zkihrzXo4W5YiHfhilpXPi0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791886849;
	b=3/T3j5DE5EjGPoZyWA/gRKcvsxbAxMjxLr4NAZzwSuC7d9ekdp7+v6oudALaVW92J4lnpn
	SXxU3IhRHwsdbHVr/+9I+rCs/cj0qKeibCgwIDxI6lqhk/oD0x16xoTw5rZ3cxLvJ/vQ+E
	h+9HrUOApWqTDyZR2+Pr4t9X/uDzYWg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vveQ9Ws+;
	spf=pass (imf13.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=AYrJ+leTQ8KpmWIlxYCwg5HqHj8C4UZFudPDXRb1/v8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791886847; v=1; x=1792491647;
 b=vveQ9Ws+AVCaoveaMaVOFwYzYq9XZNBq/EvfgBkpEm+1lzpiC4apTxzXXRDPoAjQlNOcS20r
 P0zLnSFVD+ukbUwRmAQ1OU4mj5H8x74cYqruFLl7ou1lh8Q2uV9q2STasn0jGnFOg6KgxdPAR2Q
 cnCAVLhTFIB2Yo4GUW1qO2GY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 51de388346c5e3ae;
	Tue, 13 Oct 2026 10:20:43 +0000
X-Mizu-Trace-ID: 51de388346c5e3ae
X-Migadu-Flow: FLOW_OUT
Date: Tue, 13 Oct 2026 18:20:39 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Klara Modin <klarasmodin@gmail.com>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	hannes@cmpxchg.org, nphamcs@gmail.com, baohua@kernel.org,
	youngjun.park@lge.com, yosry@kernel.org, shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev, david@kernel.org,
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Subject: Re: [PATCH v4 00/14] mm, swap: extendable swap devices (xswap phase
 I)
Message-ID: <as4F9wxsMwNsg5_R@fedora>
References: <20261003003136.750633-1-hebaoquan@kylinos.cn>
 <asZt7-8mcxqc1a02@soda.int.kasm.eu>
 <asylV5YyyaHs8rP3@fedora>
 <aszb4OgUUCh5JHle@soda.int.kasm.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aszb4OgUUCh5JHle@soda.int.kasm.eu>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1AA7320005
X-Stat-Signature: 1yqj49hcf5fd8egbotns7o7bbe6xjsqk
X-HE-Tag: 1791886848-669773
X-HE-Meta: U2FsdGVkX19dOv646KaLE9R18Fbi0O2zsP2l2d/vwXKLK3htjPf+AB2cJ2ZzaEi59WjypOJJJkZ8MJ8EQ12ZSv9DxiPmhJJqJ1NingztgoCBA2Az1a1pW/4y++YYWloSRsvFidGT5Z6yJieCMEH9DynOJKcCSY6jNvZKTKAo2Qf7Cc/m31OYkIwm/wKQjSeXI+F3tRy8PJ0+JEaaIOhgney+YhBhwaVzMd2EB6ewxkWmKnN2rLCBlpECFYYKgT2VLsTH8qyk0DkbXQeUboTpiaQZ85au59ZL2S+zbHZyRqVWf2b7FCLBRpEZaMTJx4aojWuLWgI2tUswekHsR3z0Fr9+/tlHnfTSwva0zC2DEJSckb8o8xSsA1PcWM+tYXZrB84GNlZH9VZiYY00oXu1BvThUGtAj58D3jAR6IUVskH/XtZjYroxmIN8fj1mqufITXnE+HzS36zTQSmRViHHP202WFIfu1zypE/+pVpv1ghjPaV3WiWrRHVHV4aE3+aZdX0cJBvZ3QF9ia4jYpR5mfVvtL2nNvTFvoqcQSCGmPJj3lyCmQY/RiMaaHrRWMUXY0mlXTjR8ia2cZt7dD16aP3kWSv7HwQCTZT/NxWlvkJdDlVyAGfRQ9iiIeAvn3tihT0o4uehkgudnMKRpdKF/o5gZ6c7HBwrqdQkt7luOru1HjRsv2YilN4G8Pu4q8RHVJIRx/49vqaF81VamIXnC03PweBZrmXoqKiOiCTg9vtfDx4IpgyP72IZl9ymHY9sF6/sG5QTUShRj1MhgMeJjtVfMUGafF2PXEwAyj3/DW9lanFXg9Sg1hEQw6bZJuNNXx1BSsYOqxrhb3MfJJuNnFxkQgmorl5+xQz6IikI6waoeMfAA2EEEQwotCNH/Aa28yu5pYxqsnl9T/4ZS2T20msfR7HcpV9itHzH0TrAXW2+M3KluRyS6UBeulRN9eqyCJ2fFN36DCTUIVmYW6S
 1XKczPpq
 JiADE7iN/HsAUOcYWkSQpUv99p0rKuWOPfq3dJnKpv7K8OQf28hzfH2pDOwA9M2FpL2Z5Ry79GG1LTrC9sQfWdYjM0O89NcuiC49B9OaPQKL+4hfBlucB2hTzPAD5ff/ox/KweqcUrFitnpyeO5nz6Q4T0V4pkPg9SrQTNmnAEe/w+y5++qrsM1Y86hPDgLD7bv68rwhcIqhOhtiHJH0z9/VLxviCD3tFqSlA0zfftvgiMYLxpSCGIzJchyMNf4+WCO4lM6cQv4MlNoFuSPWWOp91/g9cI14tdX6v2ISQOt+ON4UZF8HVoNTgOQEr0LTGwhOo3kKk6Lw1/yMl//5azswqvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/12/26 at 04:10pm, Klara Modin wrote:
> Hi Baoquan,
> 
> On 2026-10-12 17:16:22 +0800, Baoquan He wrote:
> > Hi Klara,
> > 
> > On 10/07/26 at 06:28pm, Klara Modin wrote:
> > > On 2026-10-03 08:31:22 +0800, Baoquan He wrote:
...snip... 
> > > > - destroy takes a bare swap type. The type is an internal index that
> > > >   alloc_swap_info() recycles as soon as SWP_USED clears, so a value read
> > > >   earlier can name a different device by the time it is written. The
> > > >   swapoff ABI uses a path for this reason. It wants a generation or
> > > >   another stable handle.
> > > > 
> > > > - The new interfaces (/sys/kernel/mm/xswap/create and destroy, xswap.max=,
> > > >   the new type string in /proc/swaps) are not documented yet.
> > > 
> > > To me it feels a bit weird to have the interface split between a kernel
> > > parameter and sysfs, meaning I have to configure this in two places now.
> > > As far as I gather, there's also nothing that needs the limit to be
> > > fixed at boot since it is applied at creation. If we want to expose this
> > > limit to users (as xswap does) it would be nice to have a 'max'
> > > shorthand for tha largest possible value, i.e. SWAPFILE_CLUSTER *
> > > UNIT_MAX (or whatever it might be in the future). That would I guess in
> > > practice give the same behaviour as vm.overcommit_memory=1 which might
> > > or might not be desirable.
> > 
> > Thanks for the comment.
> > 
> > Here xswap.max= is a global boot parameter, while not a per-device or
> > runtie knob. It sets the space space (si->max) of the xswap device
> > at boot and can't change at runtime. So on the two places: the size is
> > a global setting, fixed at boot; the priority is per device, it is in
> > the create interface. They are different things.
> > 
> > The default is 2xRAM. From our earlier discussion, this is the largest
> > size we think is sensible, and in practice I don't think it is not
> > reachable in reality. If a system has swapped out 70% of its memory, and
> > even more at 100%, it is already doubtful that it can still function
> > normally. So 2xRAM is an upper bound, not a target.
> 
> I'm just not sure this is the case. An application could have a
> relatively small working set but a much larger amount of cold memory it
> rarely touches. In my GCC 17 example, I saw even greater ratios later in
> the build process. This is from your previous xswap version where I got
> around the 2x RAM limit by using multiple xswap devices:
> 
> MemTotal:        3966828 kB
> SwapCached:          868 kB
> SwapTotal:      80232412 kB
> SwapFree:       69467760 kB
> Zswap:            792048 kB
> Zswapped:        6342024 kB
> AnonPages:       2072820 kB
> AnonHugePages:      4096 kB
> 
> This is almost 160 % of RAM in zswap and is getting close to the limit
> in practice.

OK, thanks a lot for the concrete testing data. It truly is reaching
almost 160% of RAM. However, it's a little different than David's Windows
VMs case. In that case, those VMs's memory could be touched and swapped in
in a distant future. While in your GCC build process, it's running and
costing memory, with 160% of RAM in zswap, it was probably close to
hanging? Wondering how long would it take to finish the build process,
and how long it would take to finish the build proces with e.g 20% RAM
swapped out.

> 
> In addition, if I read your writeback series correctly, if data from
> xswap is written back to a block device, the space of the written back
> data cannot be reused in the xswap device (please correct me if I am

Yes, you are right. xswap slot need record which backend slot stores its
data, so xswap slot can't be reused in this case.

> wrong). For low memory systems, I frequently set aside a lot more swap
> than they have memory. If I do not grow the xswap address space size, I
> could risk it getting full if enough of the block-based swap is used.

Got it. Even with normal swap devices, 50% full will trigger swap
reclaiming. 

/* Swap 50% full? Release swapcache more aggressively.. */
static inline bool vm_swap_full(void)
{       
        return atomic_long_read(&nr_swap_pages) * 2 < total_swap_pages;
}

> 
> Looking at the example again, about 10 GiB of swap is reported as used,
> but some of that is being reported twice (once through xswap and once
> through the backing device) due to being written back (which I still
> think is not so great). In this case, the system has 16 GiB of
> block-based swap, meaning that the default limit would leave the xswap
> device full if even half of it is used through writeback. If I would
> only have a single default-sized xswap device in this example I would
> likely have hit this in practice.

I see, so a larger swap space of xswap is expected in this case.

> 
> > 
> > On the max short name: it would set the address space to the largest value
> > the format allows. As you said, that is close to vm.overcommit_memory=1,
> > and it is not a real capacity, so we may not want it as the default.
> > 
> > We keep xswap.max= only for special needs. Otherwise we may not need to
> > change it.
> > 
> > Chris suggested a CONFIG option for the size. While CONFIG is not friendly
> > to distros, you must rebuild the kernel to change it.
> 
> For my use case I would probably prefer a CONFIG option if that is the
> only way. I typically build all my kernels on the same machine and send
> the image either directly or for netboot. Setting the kernel command
> line can be very different depending on the system (Different EFI
> bootloaders, U-Boot and all its vendor versions).

From the actual use case and concrete number you provided, the interface
can be adjusted like these:
1. 
CONFIG_XSWAP_DEFAULT_MAX_PCT=200 
default to 200, or default to the max value?

2. 
xswap.max= can override it. Or a xswap.max=max can be provided?

3.
The sysfs allow people to adjust the max size and priority:
echo  > /sys/kernel/mm/xswap/create
echo max=10G prio=100 > /sys/kernel/mm/xswap/create

Could you help comment if they are OK to you, or what is not needed
actually or not good?

> 
> > 
> > By the way, I remember you mentioned you ever did a test making swapped
> > out pages about 110% of system RAM, could you share your testing steps
> > or scripts so that I can give it a shot on my testing system? If it's
> > not convenient, then never mind.
> 
> It's nothing fancy. I just build the Gentoo package for the GCC 17
> pre-release on my RISC-V BPI-F3. As I understand, the pre-release
> sources will also enables some extra debugging and correctness checks
> which will make the build slower and maybe also use more memory. Note
> that I do not see the same memory usage on other arches which is I
> believe due to the implementation of the RISC-V autovectorisation (GCC
> 14 saw a large jump and that was the release which added it). I do add
> configure options --with-matchpd-partitions=20 and
> --with-insnemit-partitions=50 since especially insn-recog.cc tends to be
> huge and the default partition of 10 it will still be quite large.
> 
> My datapoints are from just dumping some fields of /proc/meminfo every
> ten seconds.

OK, seems it's not easy to copy from my side. Thank you again for your
detailed testing information and suggestion.

Thanks
Baoquan


