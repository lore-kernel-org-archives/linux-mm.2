Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C6D2CC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 15:44:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DE5B6B0092; Wed, 14 Oct 2026 11:44:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B4616B0095; Wed, 14 Oct 2026 11:44:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F1DF6B0098; Wed, 14 Oct 2026 11:44:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC61B6B0092
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:44:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 75CE4404AE
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:44:53 +0000 (UTC)
X-FDA: 85321654866.25.9B9E024
Received: from mta1.migadu.com (out-246.mta1.migadu.com [95.215.58.246])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3A53A140005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:44:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fyHfYF9H;
	spf=pass (imf23.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.246 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791992691;
	b=Hg9La1PKTGddj08tzufLD57Zu1QsGBdcgpzvILnahr27IrViKZnvZKlic0g0VTKV0fJMq9
	Rj4m5hdYvkmgj3Td8YIDFXlnXnLxSU2eoe9Jk2pe55xYIWDVMZ7qqZ5FDh/6PuMxcGaPO3
	9y028rZ5HEE39ltuS9tpf1H5puOzoJo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fyHfYF9H;
	spf=pass (imf23.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.246 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791992691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v9lBQJMh5NIGXVn9Z6SI4ZsI1uQtCJtjkTBne1RB5L0=;
	b=P+0K6PoBYddlvofs1IRCiXs9UnUMkPBuPf3mg4Uabu0cc6OTNSEZq52ztE9PzkicpPdOE2
	R8/BmMrbu4m+aOtYGxWHJdFelI52SDbwaCbiq6f3+mnqcLmAQSgiQq+MZ9AGAjqxHhwAMf
	1pyv4qNiBn/3R1i8Hwj8Hum9CR6oHx8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IWz8TrA14wXCf8RgDJH9LfVZ/eamPEvc/gsSPc9D0Bo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791992686; v=1; x=1792597486;
 b=fyHfYF9HnChCb6/0k2VjEefs6pLGzzdYX3jaYS7wCIxRvKNz3VOSjXq5e6aCp6lTnLWuXDJp
 4WsKBn7S6wlen5GF+AcMNHubAMsH9lqQBtwMUdwZJMSqNOg3xJ+/ots1ipSenUeyfZqGcCaa4IP
 15hFAk7XGU91PIxss8lOo1xs=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id e2f26255d9a7fbec;
	Wed, 14 Oct 2026 15:44:46 +0000
X-Mizu-Trace-ID: e2f26255d9a7fbec
X-Migadu-Flow: FLOW_OUT
Date: Wed, 14 Oct 2026 23:44:38 +0800
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
Message-ID: <as-jZpQBQ9mMNqlH@fedora>
References: <20261003003136.750633-1-hebaoquan@kylinos.cn>
 <asZt7-8mcxqc1a02@soda.int.kasm.eu>
 <asylV5YyyaHs8rP3@fedora>
 <aszb4OgUUCh5JHle@soda.int.kasm.eu>
 <as4F9wxsMwNsg5_R@fedora>
 <as4gb7BdnFffV4SI@parmesan.int.kasm.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as4gb7BdnFffV4SI@parmesan.int.kasm.eu>
X-Stat-Signature: zsma9hecdompjhf7gg1gfay4duj5bgit
X-Rspamd-Queue-Id: 3A53A140005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791992691-132620
X-HE-Meta: U2FsdGVkX1+EJJzlXJY0gvo4dLecr/9BcnvBa4jEB/uScHA5YqYWggswwbBVafpUOQFPWDLAUybOTlCBiCjwEQ2OtJyx44LNByRshGfSURp8KOrvsyVqo0rc2XamFC/JtxrjiUKrmN4qyjemMSH6wYZwxgI+JrUu1nRl/f9n2bSWfgK/xO/msgS5ItBvC83inF1JF29ldFpa1D6velJHRSseKxDEufTsp9/AMuwM0lTu9zLIlXpYXlb49wiN8fbkCvRKWdRuv9skFdMOmvC0B4G+u1FBWYYp8p87FBOucYbfrPRA6RzY4srJx9B7eKzi6e/fufCHqEzC1rIzmAVOEBmAdkyqQRncCNLNLLYbMD+DlTE5N3c7XEjHbCIj7wbQLkvSnJThYl5ju+ske1igmBxDu7mvNRlVXF3DMI+D1uyV2FcvB3DwQFArR965hCFyMkwJnLsemnjB4b2ezXl9+rPB63lKZeGZarZexPhcGMZ4/SU0J88089qqlHcG0CwZAHBh2OLfQCKqUXBocFwWGH1avH/Q2Tjoc24LrM7AT6qIYDpNS92VsBU/MpDXS/vvE/ZYj9+tGsMt1b4kau7uAKWBt5tIDAp6RhRv+a35ysX7KY6TOs1m+ilzB0y0816aWpaV2BCuw+JX2sH5XV5XsoBlnG6XzVlG68pbC2yYaH1MekH8M/5KWiBCQMnMhTTTXC4WNn15uPVakk0d8wlBykSIidy2OZ6KQZP+15u07LQrWPEZlksq6EloCVNTrp0D3+wsE1u1xxbF2aUVXtgRiKoPw9FFzvDGHk4Haj5XiDfoghZ+33iFwJ01G5LFkE1Iu2kkeB/OJN3mC4oST9NhvI/JQmQuPnho/QDF9tE6NtjV+zlrN3t9+Ux84q3X4Mr9VGvmv+Y/xkE/LuSppxkIgnAQjpoxZ+x5NtlKqhtyWATUwhALAk0iISobqEcPflrJCGLSDOVFS2toJN7kQ2W
 uIizAqx0
 ZHwOgZUIRjT0d/igycOdnfxnLc96TLOn7DMZ6ENXT0XQl8GCqIGjJ3U7mPUvQ3WdP34BdTORpgH/Wc/e3jn61yhwOhHk8Kat9Rgi87c5ArqbFhfPY59UG+hpjDzAxQP86g0+9OX2Fh766xl3C3Pp/+WTGfonzpxlljeT96j553TzWfSgbPVhDDXg8ClblC+Zh2v4UEZRLR3zPmcLVhImh21mkd/vq5/Q8LrnDqmQAwscfwKfjVfgpSj4T+QrO+iHE2fg0rJ0CoeTREIthCl1xucECHRRN4JSwNMUo39NHwD4O19UwXXpJZmXJHk5eECKeUx5FCHWfgDDq6L0vkqrrdGrDDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/26 at 04:26pm, Klara Modin wrote:
> Hi Baoquan,
> 
> On 2026-10-13 18:20:39 +0800, Baoquan He wrote:
> > On 10/12/26 at 04:10pm, Klara Modin wrote:
> > > Hi Baoquan,
> > > 
> > > On 2026-10-12 17:16:22 +0800, Baoquan He wrote:
> ...
> > > > 
> > > > Thanks for the comment.
> > > > 
> > > > Here xswap.max= is a global boot parameter, while not a per-device or
> > > > runtie knob. It sets the space space (si->max) of the xswap device
> > > > at boot and can't change at runtime. So on the two places: the size is
> > > > a global setting, fixed at boot; the priority is per device, it is in
> > > > the create interface. They are different things.
> > > > 
> > > > The default is 2xRAM. From our earlier discussion, this is the largest
> > > > size we think is sensible, and in practice I don't think it is not
> > > > reachable in reality. If a system has swapped out 70% of its memory, and
> > > > even more at 100%, it is already doubtful that it can still function
> > > > normally. So 2xRAM is an upper bound, not a target.
> > > 
> > > I'm just not sure this is the case. An application could have a
> > > relatively small working set but a much larger amount of cold memory it
> > > rarely touches. In my GCC 17 example, I saw even greater ratios later in
> > > the build process. This is from your previous xswap version where I got
> > > around the 2x RAM limit by using multiple xswap devices:
> > > 
> > > MemTotal:        3966828 kB
> > > SwapCached:          868 kB
> > > SwapTotal:      80232412 kB
> > > SwapFree:       69467760 kB
> > > Zswap:            792048 kB
> > > Zswapped:        6342024 kB
> > > AnonPages:       2072820 kB
> > > AnonHugePages:      4096 kB
> > > 
> > > This is almost 160 % of RAM in zswap and is getting close to the limit
> > > in practice.
> > 
> > OK, thanks a lot for the concrete testing data. It truly is reaching
> > almost 160% of RAM. However, it's a little different than David's Windows
> > VMs case. In that case, those VMs's memory could be touched and swapped in
> > in a distant future. While in your GCC build process, it's running and
> > costing memory, with 160% of RAM in zswap, it was probably close to
> > hanging? Wondering how long would it take to finish the build process,
> > and how long it would take to finish the build proces with e.g 20% RAM
> > swapped out.
> 
> Might be close to hanging, I don't know, but it's definitely under quite the
> memory pressure (only two AnonHugePages, implying either very fragmented
> or that they are split after allocation). Worth to note is that it hits
> the zswap default limit of 20 percent of memory for the compressed pool.

I see. If so, it may not be a real use case, but only a corner case within
an experimental environment. Because in that situation it's hard to say
the system is still functioning normally.

> 
> > 
> > > 
> > > In addition, if I read your writeback series correctly, if data from
> > > xswap is written back to a block device, the space of the written back
> > > data cannot be reused in the xswap device (please correct me if I am
> > 
> > Yes, you are right. xswap slot need record which backend slot stores its
> > data, so xswap slot can't be reused in this case.
> > 
> > > wrong). For low memory systems, I frequently set aside a lot more swap
> > > than they have memory. If I do not grow the xswap address space size, I
> > > could risk it getting full if enough of the block-based swap is used.
> > 
> > Got it. Even with normal swap devices, 50% full will trigger swap
> > reclaiming. 
> > 
> > /* Swap 50% full? Release swapcache more aggressively.. */
> > static inline bool vm_swap_full(void)
> > {       
> >         return atomic_long_read(&nr_swap_pages) * 2 < total_swap_pages;
> > }
> > 
> > > 
> > > Looking at the example again, about 10 GiB of swap is reported as used,
> > > but some of that is being reported twice (once through xswap and once
> > > through the backing device) due to being written back (which I still
> > > think is not so great). In this case, the system has 16 GiB of
> > > block-based swap, meaning that the default limit would leave the xswap
> > > device full if even half of it is used through writeback. If I would
> > > only have a single default-sized xswap device in this example I would
> > > likely have hit this in practice.
> > 
> > I see, so a larger swap space of xswap is expected in this case.
> 
> Yes, due to the writeback still needing the slot in xswap I would never
> want to have less xswap than block-based swap.
> 
> Ideally, I would like to not have to take the amount of block-based
> swap into account when enabling xswap/vswap. A very high default limit
> would be one way to solve it. Another option could be to automatically
> create an xswap device with a size equal to the block-based swap device
> (maybe a mount option?) on swapon, but this feels kind of like a hack to
> me.

Chris ever suggested this way. With it people can set in /etc/fstab and
make it take effect during boot. Not sure if people like it.

> 
> > 
> > > 
> > > > 
> > > > On the max short name: it would set the address space to the largest value
> > > > the format allows. As you said, that is close to vm.overcommit_memory=1,
> > > > and it is not a real capacity, so we may not want it as the default.
> > > > 
> > > > We keep xswap.max= only for special needs. Otherwise we may not need to
> > > > change it.
> > > > 
> > > > Chris suggested a CONFIG option for the size. While CONFIG is not friendly
> > > > to distros, you must rebuild the kernel to change it.
> > > 
> > > For my use case I would probably prefer a CONFIG option if that is the
> > > only way. I typically build all my kernels on the same machine and send
> > > the image either directly or for netboot. Setting the kernel command
> > > line can be very different depending on the system (Different EFI
> > > bootloaders, U-Boot and all its vendor versions).
> > 
> > From the actual use case and concrete number you provided, the interface
> > can be adjusted like these:
> > 1. 
> > CONFIG_XSWAP_DEFAULT_MAX_PCT=200 
> > default to 200, or default to the max value?
> > 
> > 2. 
> > xswap.max= can override it. Or a xswap.max=max can be provided?
> > 
> > 3.
> > The sysfs allow people to adjust the max size and priority:
> > echo  > /sys/kernel/mm/xswap/create
> > echo max=10G prio=100 > /sys/kernel/mm/xswap/create
> > 
> > Could you help comment if they are OK to you, or what is not needed
> > actually or not good?
> 
> I do not mind having both a CONFIG option and a command line option for
> the default where the latter overrides the first. I also do not mind
> having the limit in sysfs since I need it to create the xswap device
> anyway, but having all three together might be a bit extraneous.
> 
> However, if this is put in the sysfs it might be good to rethink how it
> is structured. E.g. do we want to do so much string parsing when we
> could instead have the limit and priority be separate files? I quite
> like how NVME target handles this in configfs, where the user creates a
> directory for the hosts, ports and subsystems and each config option is
> a separate file inside. So for xswap, the user would mkdir
> /sys/kernel/mm/xswap/typeN (or whatever) and have a structure inside
> with something like:
> typeN
>  |- enabled # 0/1, which would actually destroy or create the device
>  |- priority
>  |- max_size_pct
>  |- max_size_bytes # where writing to either would override the other
> 
> (and only accept changes when not enabled) but this might be more
> complicated than we need. Even better would be for the defaults to work
> for everybody since we wouldn't need the knobs, but then we would have
> to agree on what those defaults should be.

Yes. I ask people around, they are all surprised and say how come 8PB
is needed. And mobile phone people care about the swap amount, they only
allow several GBs swapped out to zram with RAM of tens of GBs. 

So how about these:

1.
CONFIG_XSWAP_DEFAULT_MAX=
max; 8PB
size; e.g 10TB
200%; percentenge of RAM
defaults to 2xRAM

2.
xswap.max=
can override CONFIG_XSWAP_DEFAULT_MAX=
max; 8PB
size; e.g 10TB
200%; percentenge of RAM

3. 
echo  > /sys/kernel/mm/xswap/create
defaults to 2xRAM
The sysfs allow people to adjust the priority:
echo 100 > /sys/kernel/mm/xswap/create

> > 
> > > 
> > > > 
> > > > By the way, I remember you mentioned you ever did a test making swapped
> > > > out pages about 110% of system RAM, could you share your testing steps
> > > > or scripts so that I can give it a shot on my testing system? If it's
> > > > not convenient, then never mind.
> > > 
> > > It's nothing fancy. I just build the Gentoo package for the GCC 17
> > > pre-release on my RISC-V BPI-F3. As I understand, the pre-release
> > > sources will also enables some extra debugging and correctness checks
> > > which will make the build slower and maybe also use more memory. Note
> > > that I do not see the same memory usage on other arches which is I
> > > believe due to the implementation of the RISC-V autovectorisation (GCC
> > > 14 saw a large jump and that was the release which added it). I do add
> > > configure options --with-matchpd-partitions=20 and
> > > --with-insnemit-partitions=50 since especially insn-recog.cc tends to be
> > > huge and the default partition of 10 it will still be quite large.
> > > 
> > > My datapoints are from just dumping some fields of /proc/meminfo every
> > > ten seconds.
> > 
> > OK, seems it's not easy to copy from my side. Thank you again for your
> > detailed testing information and suggestion.
> 
> You might be able to do it in a VM, but without hardware acceleration it
> is likely even slower than the ~18 hours it takes on my BPI-F3 to
> complete. I use the Gentoo package since it's convenient, but for
> testing purposes, building from the GCC sources directly would likely be
> similar.
> 
> Another scenario which could potentially benefit from a lot of zswap (or
> swap in general) would be when suspending processes (i.e. ^Z or kill
> -SIGSTOP). Their memory would quickly go cold and therefore be swapped
> out under memory pressure. I have used this sometimes on low memory
> systems where I have started a build process with too many workers and
> not wanted to restart it, but am not sure if there are other reasonable
> use cases of this.

Got it, the build process seems not easy to copy, while the latter one
sounds doable, I can give it a shot sometime. Thanks a lot for providing
these valuable information and your patience.


Thanks
Baoquan

