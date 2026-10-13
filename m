Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64DDCCC6B08
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 14:26:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07B966B0088; Tue, 13 Oct 2026 10:26:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02CAF6B008A; Tue, 13 Oct 2026 10:26:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5E2B6B008C; Tue, 13 Oct 2026 10:26:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD1EC6B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:26:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 46BFF16063B
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 14:26:49 +0000 (UTC)
X-FDA: 85317829338.12.F4728F5
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5FE9840005
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 14:26:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AMYmjwjS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of klarasmodin@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791901607;
	b=4AOu54oO4TRtVovcR0Dnx1qkKb2PKbNEHXufvTSVKvQ1Eijr4j1rOE8jRhXdse6A6YAJcj
	2/2YT1QQP9HHn8L8T3CVj4lxPKb5Jzv81bAJ6xK32lN2qcwlH1SD6OqsRHZU/eFp7fq4RR
	xYJF16ZHGKoGnWZNhfMzAEA5qeeH+zY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AMYmjwjS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of klarasmodin@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791901607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GqHJmOrsAscfSwnG9+HOxEdimM/Cq2SN07Uf0WC6x0w=;
	b=ZA6bqfeQhYnfw1EWjrYx6VVPH5XZGe82Xxdn9wLzkriKcxx7NUUvmvi5kY3fwS4vZDlplm
	yPP+OZXIz7uvNxz/MeKB8n3l8GR/nTOKYZas1VlcyklbGoBGNjeTrWb1xxpZd6AwYUPfUS
	W6cKnep9k9rxmQ16q5uUImyxrRPBFF0=
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5ba357a1929so2663194e87.0
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 07:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791901605; x=1792506405; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GqHJmOrsAscfSwnG9+HOxEdimM/Cq2SN07Uf0WC6x0w=;
        b=AMYmjwjSWWdfK11Eo7yS6EaRCuTykDy8e8YMJ8DNrwJCBTNOj1I13tlTuu59C7CMaK
         oo3oo1inVR4/W5yQQhQ6s9aKEHlQ+UxxnXZgGfpLW1VvyYgQbWem1J/yGps6RHbNmYl/
         dvzfxKI5IHc1O4hX0mkG28RxzX+eMearpv3WsoQs1JQarvT4vNV9LlchUFY7N04AIHr6
         aYfeF6aJlWkSA5ytgu6jZXLDXSOAkCOiFjy7YwmOJhuTvjmpdGJPyzOrRFApS+xZkGFd
         kdBXBX1T0vB9wz8cUtjs1ZfdtX8ZzcuFqUVplVKJrYTaJVfJDR00ODD1iC2k1GtmUOFO
         F2bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791901605; x=1792506405;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GqHJmOrsAscfSwnG9+HOxEdimM/Cq2SN07Uf0WC6x0w=;
        b=p0tDMQ+hb62BtNjCuxP24D9S3WZRuIqSGhREsrSZJkdHgiu/ivwtX9xe3okVgpBpd4
         2vYbIecSYTxY93cXXGJm7PVD1t4ybXYJ6x06iAjBq/C+o4YDUkYn5lWm25gw91NZJsj8
         L5Tz0sxJnYduQeJljCBg3zEI0BdM6Gpi1L5mgL1Ztsx0OVITwReuxAkglasYrlQyHBDS
         4vxaNUpf5sYeDmKkqCS1eTIcABAhZsED43fQX5KxgVE0iwEtpj+hM/W3oLhtELcO5bkR
         9+oVX9WR3E1/UWghi3v8F39+ijGUFuNI32csPIaJvX5w8uMuipehMKKZ1nZ+w+ZQVMld
         z1cg==
X-Forwarded-Encrypted: i=1; AKwUvBzHhzOXMi0ZRywsmXtkH3FIITmGDS2yPekaPVLgKar7YifrClR7rO3L5o6ugt59rP1F0Eysiads+g==@kvack.org
X-Gm-Message-State: AFq9FYKiZoziZh6gPu+cTZuZWFdRkHtC4MgDdbcszfz8DZJ/kcJMWqzR
	WjvGGtWQP8VHMkOhvUQhdwgaPqXP2cxiopYpAj+foejKSBDcPVMS+KOG
X-Gm-Gg: AYBFou3/Ztmc8edGqUBrJpmMZwY7BybmOqNrpAYTS88xHM+ExYGjFaDIafTYwmzmn7j
	2RTBnQE9LiYS2nnyLqN4IPpqMXqp31n4n0Db2ppvNDCJAobLlci7/m8rVbLSR/TyBAJSgvcMTY1
	MfS2sh9XFc1L9ITX8ca6QwasHVqrirUZbCloYK7Sw8Q2nJk2ccv6MxkJNy5qSQQAdZ2fldT9Um0
	ul1hHYDFR+6enxsWiHyzIuNHqIeci0neqtNOe2cqQYu3rFhzkzpl6wmEINyh8dC0iQ6svI83uAI
	pd4sz2V3iejcbORj44Zeyy1PtLQtRzHU/bAT7dnoYVC/ccsPRr8Dh7xbKdf8aLr/W8ynjPvBIMb
	EatH7Q4T5kbvxQ+RWv5unDl0//JTsrbxvMdXRPaD9dXRAIG1YFnwIKzH3a9LfxVkzYrsQwieRw2
	tN+WgitQS+6dNUi+t2rAavtuYH9jA93LObBTKs0LaPK1OfYcU2mYjJjC22zxMmZCD7gMscb7sUr
	36JmUEvYRFLFYKzWA==
X-Received: by 2002:a05:6512:6889:20b0:5bc:e45b:becd with SMTP id 2adb3069b0e04-5bce45bbfc5mr2303297e87.14.1791901605226;
        Tue, 13 Oct 2026 07:26:45 -0700 (PDT)
Received: from localhost (parmesan.int.kasm.eu. [2001:678:a5c:1204:5508:6e19:c6a3:9875])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bcdde912a7sm3574410e87.18.2026.10.13.07.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 07:26:44 -0700 (PDT)
Date: Tue, 13 Oct 2026 16:26:42 +0200
From: Klara Modin <klarasmodin@gmail.com>
To: Baoquan He <baoquan.he@linux.dev>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org, 
	akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, hannes@cmpxchg.org, 
	nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, yosry@kernel.org, 
	shikemeng@huaweicloud.com, chengming.zhou@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Subject: Re: [PATCH v4 00/14] mm, swap: extendable swap devices (xswap phase
 I)
Message-ID: <as4gb7BdnFffV4SI@parmesan.int.kasm.eu>
References: <20261003003136.750633-1-hebaoquan@kylinos.cn>
 <asZt7-8mcxqc1a02@soda.int.kasm.eu>
 <asylV5YyyaHs8rP3@fedora>
 <aszb4OgUUCh5JHle@soda.int.kasm.eu>
 <as4F9wxsMwNsg5_R@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as4F9wxsMwNsg5_R@fedora>
X-Stat-Signature: cu6bpkx1qe8sdpud5dqmkp6xsbp84bc9
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5FE9840005
X-HE-Tag: 1791901607-754480
X-HE-Meta: U2FsdGVkX1/VW9NlWEqWVanPvhZ/wrIIjTpGjicpFESUZXpDRWjRRwMVAN5QGlCsjl2e9ZR54U+F1FntlNUPm6stnZjJ7gqUh+cpxgt8zjKKKXnOKzkJfJ45UDATjuwSVAEse8ZClso6LjZSXB8VoNDiM339k6rwsAeBN1G9i067ho2/jMzSqab/XKop9/9tjG4wj5fqPBcqlkwcm4tIPCWlR/Z2g/k5A/nqTHel8Fj/URSX6i0hwahGispCDMKl74RlWu0Mw9aHCmRTjpw5qOTkR3N5+2+V796WxBzX43MKjMRFYdW6w0Ibsguqg8PBs4irqJWFcCASIlaeiuF/ikTeCdfySMGqPV+QiCCXNOrLrZbf1Z+PwmkvnnrA5nx3X9nl0zGHpfUXLIMdlfslC2ef+Tf5p9lXM22ynQ4Dds+3sM7CXlKMyNjaS39Os41p/JmBW/+InGIPMQKBinFArc9X+O0PU1CWLLCA6IewhpZL9SHICSB/h2VnG5I2CXrrWVzjBkyrvzaVKy1+ivqcrC2NOiLZSHrMwMqvKBYz8rKdvioADfnpQzqCJ/ATakaKsevvT0JKzbb2rY2sfWmdfzzpTkFSisZE3JMDyhxjyQv2LRspdmsKrp6l7gV7hCiZipzvQ9le6bjoCSwY7cujMcsjwT8HfUIvAEqjNChTN11ntePmCHzbWfBT6pk2osR1J8cg1Q0GlBms/Q74nXGKtCu80qi4MqF6IzV53U4zD9EOhneNmvPWAL6TVt3drOKZM2OVkph5XdjK5+nfGadecRK/vPZjV5ojPpy2ecoP2ijTBpSDexabww0L4EPD96l0iVsY5IGvPXovQUXRgZnV6asm2eGX+ubDkBpoQb67jWjpC8QgvvVz46hq7brsa4erwUAjNpwC35/Coy56gjpFX7Cc8lL4Vi2XZ3WT4JUuW/fNhyBhSEPwsKH9nFJgx23KIOHcX+y+6ZSYZqh5Nr5
 bCmVjIpM
 xQ3vCIMGbpfAPpBOrH/6fHDmwl9crYI2epnrTfMouno+VDouRw5RnONW/1BBnT++c6jbeC5FFmVPjypPJaROO1ek4Hp2CfTIHI1gs7Nb+a95ndXWC8yILiLUSpiqoXbc56deAQjmL0JPjkjg4WyyUNHYJJduk/IYaba3cN0lNdpKkzzry7cyB5oDFX/zSPnKkwA0IUJDF+5JJTYoRz7fzmF7pOaqFDRkls6sJ5zPvln2b19ZShKc7Vjgw5o6je0Rgrdt/AICx7roWktik7NA9MKAQk+p5TEKtftCQBm6fImTbK6LGjrBE+IfuHO5zZWcF8trVKKNelFP+3LifFe/8UC46Ut/11d+9hewyP0QvtfW44RHNEvMKOyNBtYYUcZKTVge8EfbT1qoKoDt46n7VvBigJC8w5z73yKE8oiv4BX3Va2eW55kayFvYW+cI4buDRhi2s0hZKard7fWLe2emNHutQJ/0qlxYuAJuo3oPtSVx5v3DDD7J/gbX2WFjMJybS9dbwzy+wRuiMMoetKTYeUI7wIiVPO/03fIPhUGZV0bNIgVt7SU6Hb8r07HonrFeziceMi6ocGazDwA69E0SuZrOdGVQo99Yq5pI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Baoquan,

On 2026-10-13 18:20:39 +0800, Baoquan He wrote:
> On 10/12/26 at 04:10pm, Klara Modin wrote:
> > Hi Baoquan,
> > 
> > On 2026-10-12 17:16:22 +0800, Baoquan He wrote:
...
> > > 
> > > Thanks for the comment.
> > > 
> > > Here xswap.max= is a global boot parameter, while not a per-device or
> > > runtie knob. It sets the space space (si->max) of the xswap device
> > > at boot and can't change at runtime. So on the two places: the size is
> > > a global setting, fixed at boot; the priority is per device, it is in
> > > the create interface. They are different things.
> > > 
> > > The default is 2xRAM. From our earlier discussion, this is the largest
> > > size we think is sensible, and in practice I don't think it is not
> > > reachable in reality. If a system has swapped out 70% of its memory, and
> > > even more at 100%, it is already doubtful that it can still function
> > > normally. So 2xRAM is an upper bound, not a target.
> > 
> > I'm just not sure this is the case. An application could have a
> > relatively small working set but a much larger amount of cold memory it
> > rarely touches. In my GCC 17 example, I saw even greater ratios later in
> > the build process. This is from your previous xswap version where I got
> > around the 2x RAM limit by using multiple xswap devices:
> > 
> > MemTotal:        3966828 kB
> > SwapCached:          868 kB
> > SwapTotal:      80232412 kB
> > SwapFree:       69467760 kB
> > Zswap:            792048 kB
> > Zswapped:        6342024 kB
> > AnonPages:       2072820 kB
> > AnonHugePages:      4096 kB
> > 
> > This is almost 160 % of RAM in zswap and is getting close to the limit
> > in practice.
> 
> OK, thanks a lot for the concrete testing data. It truly is reaching
> almost 160% of RAM. However, it's a little different than David's Windows
> VMs case. In that case, those VMs's memory could be touched and swapped in
> in a distant future. While in your GCC build process, it's running and
> costing memory, with 160% of RAM in zswap, it was probably close to
> hanging? Wondering how long would it take to finish the build process,
> and how long it would take to finish the build proces with e.g 20% RAM
> swapped out.

Might be close to hanging, I don't know, but it's definitely under quite the
memory pressure (only two AnonHugePages, implying either very fragmented
or that they are split after allocation). Worth to note is that it hits
the zswap default limit of 20 percent of memory for the compressed pool.

> 
> > 
> > In addition, if I read your writeback series correctly, if data from
> > xswap is written back to a block device, the space of the written back
> > data cannot be reused in the xswap device (please correct me if I am
> 
> Yes, you are right. xswap slot need record which backend slot stores its
> data, so xswap slot can't be reused in this case.
> 
> > wrong). For low memory systems, I frequently set aside a lot more swap
> > than they have memory. If I do not grow the xswap address space size, I
> > could risk it getting full if enough of the block-based swap is used.
> 
> Got it. Even with normal swap devices, 50% full will trigger swap
> reclaiming. 
> 
> /* Swap 50% full? Release swapcache more aggressively.. */
> static inline bool vm_swap_full(void)
> {       
>         return atomic_long_read(&nr_swap_pages) * 2 < total_swap_pages;
> }
> 
> > 
> > Looking at the example again, about 10 GiB of swap is reported as used,
> > but some of that is being reported twice (once through xswap and once
> > through the backing device) due to being written back (which I still
> > think is not so great). In this case, the system has 16 GiB of
> > block-based swap, meaning that the default limit would leave the xswap
> > device full if even half of it is used through writeback. If I would
> > only have a single default-sized xswap device in this example I would
> > likely have hit this in practice.
> 
> I see, so a larger swap space of xswap is expected in this case.

Yes, due to the writeback still needing the slot in xswap I would never
want to have less xswap than block-based swap.

Ideally, I would like to not have to take the amount of block-based
swap into account when enabling xswap/vswap. A very high default limit
would be one way to solve it. Another option could be to automatically
create an xswap device with a size equal to the block-based swap device
(maybe a mount option?) on swapon, but this feels kind of like a hack to
me.

> 
> > 
> > > 
> > > On the max short name: it would set the address space to the largest value
> > > the format allows. As you said, that is close to vm.overcommit_memory=1,
> > > and it is not a real capacity, so we may not want it as the default.
> > > 
> > > We keep xswap.max= only for special needs. Otherwise we may not need to
> > > change it.
> > > 
> > > Chris suggested a CONFIG option for the size. While CONFIG is not friendly
> > > to distros, you must rebuild the kernel to change it.
> > 
> > For my use case I would probably prefer a CONFIG option if that is the
> > only way. I typically build all my kernels on the same machine and send
> > the image either directly or for netboot. Setting the kernel command
> > line can be very different depending on the system (Different EFI
> > bootloaders, U-Boot and all its vendor versions).
> 
> From the actual use case and concrete number you provided, the interface
> can be adjusted like these:
> 1. 
> CONFIG_XSWAP_DEFAULT_MAX_PCT=200 
> default to 200, or default to the max value?
> 
> 2. 
> xswap.max= can override it. Or a xswap.max=max can be provided?
> 
> 3.
> The sysfs allow people to adjust the max size and priority:
> echo  > /sys/kernel/mm/xswap/create
> echo max=10G prio=100 > /sys/kernel/mm/xswap/create
> 
> Could you help comment if they are OK to you, or what is not needed
> actually or not good?

I do not mind having both a CONFIG option and a command line option for
the default where the latter overrides the first. I also do not mind
having the limit in sysfs since I need it to create the xswap device
anyway, but having all three together might be a bit extraneous.

However, if this is put in the sysfs it might be good to rethink how it
is structured. E.g. do we want to do so much string parsing when we
could instead have the limit and priority be separate files? I quite
like how NVME target handles this in configfs, where the user creates a
directory for the hosts, ports and subsystems and each config option is
a separate file inside. So for xswap, the user would mkdir
/sys/kernel/mm/xswap/typeN (or whatever) and have a structure inside
with something like:
typeN
 |- enabled # 0/1, which would actually destroy or create the device
 |- priority
 |- max_size_pct
 |- max_size_bytes # where writing to either would override the other

(and only accept changes when not enabled) but this might be more
complicated than we need. Even better would be for the defaults to work
for everybody since we wouldn't need the knobs, but then we would have
to agree on what those defaults should be.

> 
> > 
> > > 
> > > By the way, I remember you mentioned you ever did a test making swapped
> > > out pages about 110% of system RAM, could you share your testing steps
> > > or scripts so that I can give it a shot on my testing system? If it's
> > > not convenient, then never mind.
> > 
> > It's nothing fancy. I just build the Gentoo package for the GCC 17
> > pre-release on my RISC-V BPI-F3. As I understand, the pre-release
> > sources will also enables some extra debugging and correctness checks
> > which will make the build slower and maybe also use more memory. Note
> > that I do not see the same memory usage on other arches which is I
> > believe due to the implementation of the RISC-V autovectorisation (GCC
> > 14 saw a large jump and that was the release which added it). I do add
> > configure options --with-matchpd-partitions=20 and
> > --with-insnemit-partitions=50 since especially insn-recog.cc tends to be
> > huge and the default partition of 10 it will still be quite large.
> > 
> > My datapoints are from just dumping some fields of /proc/meminfo every
> > ten seconds.
> 
> OK, seems it's not easy to copy from my side. Thank you again for your
> detailed testing information and suggestion.

You might be able to do it in a VM, but without hardware acceleration it
is likely even slower than the ~18 hours it takes on my BPI-F3 to
complete. I use the Gentoo package since it's convenient, but for
testing purposes, building from the GCC sources directly would likely be
similar.

Another scenario which could potentially benefit from a lot of zswap (or
swap in general) would be when suspending processes (i.e. ^Z or kill
-SIGSTOP). Their memory would quickly go cold and therefore be swapped
out under memory pressure. I have used this sometimes on low memory
systems where I have started a build process with too many workers and
not wanted to restart it, but am not sure if there are other reasonable
use cases of this.

> 
> Thanks
> Baoquan
> 

Regards,
Klara Modin

