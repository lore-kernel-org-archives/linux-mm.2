Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8641CA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 14:10:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B59916B009B; Mon, 12 Oct 2026 10:10:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0A416B009D; Mon, 12 Oct 2026 10:10:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A21A26B009E; Mon, 12 Oct 2026 10:10:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 816466B009B
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:10:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0E81D140E7D
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:10:24 +0000 (UTC)
X-FDA: 85314159168.20.3BDBBF2
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3AC8C14000B
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:10:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oGplknZa;
	spf=pass (imf26.hostedemail.com: domain of klarasmodin@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791814222;
	b=5v6OEoxpC3Uo499ClKlYsclH8bJOiIt0pE79ZxpCbqm/yTIFzjoWwvZgoH0jWH6G3uMp8Z
	uPqfF5+iC0U/7QyXbups5oildMKAMd64wlf+4Jz2T76lJBQp+RrXXCTwewLC3KcQztSOnr
	KOW/p8Q1T1NFSmAtn5pfsUfi5cJ7WXY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oGplknZa;
	spf=pass (imf26.hostedemail.com: domain of klarasmodin@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791814222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2eI8B9IRSkr08wGu9ziy/drqG3G2v7BSelh/3Qqv4WQ=;
	b=794Gvi7nBBOqP3xg84Shvnb8tG7krEojnG9rm/RHqKQpXHdfHRK9IRx+jYoK4TPNhI6fFT
	picxAhznATq65A9W5PltEuqEjsU6ULjJ51EunMXS/SI3rEy08+ArbaigYvQUZYoGK/hMyI
	lT2c68GkdFo6N6Z93rR6R1WloWJAvfI=
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5bcb3726952so264965e87.3
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791814220; x=1792419020; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2eI8B9IRSkr08wGu9ziy/drqG3G2v7BSelh/3Qqv4WQ=;
        b=oGplknZaRj9hjDQEyS14AdQq7HaRUe8jhQrFIfebLWNFOZVN2e87+ZRf+duIsvulFn
         jmnsmQQ26knBF3GpJ9JaPZr1gc848FiIr7rsv1LIU5D8VuasK8obsrUSJDuHFfIxyUPU
         0qmCu3jLVASYsJ4E3e2Z9VWpModqXfH+JD8953z0QarzbpIb62wEseFC7D9SXJkJdswJ
         9pQO17deMYqluO7YC4ODBw+IhjFynPwkJ8Qx1VbVHgirTKLBAjz/kSN8CCz+IFqOfQN3
         h9cvv/ZaBEfchETuKMqazgsAULo7IsRfQiiPeMOVz0Gn7PDhriF0mYz2ocsYctnKB6M5
         v37g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791814220; x=1792419020;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2eI8B9IRSkr08wGu9ziy/drqG3G2v7BSelh/3Qqv4WQ=;
        b=aRm+gpJW1ydc/Xs6aSYAIC3nsh4f528+3XnuGzlt5bUDzr5k1UcVNrmeiEqjM0kJe9
         w6dRnwgBXvmsr8rkJ2Yg8NEVR+/UAMCnyZfbRSt0hZkN4kWu3BaGWOfl4Pv4SEqgQ/UG
         eDhgF+eaOEyd0e0nNgk/v7KoYzllF0AD611CFCqQOWaITlCp65OMNMyldteMjLNGXZzD
         W+VFQUP+TGlziy/VISPMhyFJdkhVRnXsbXd4HNdDtw75j/qUaWglyBRcDDjxRtgTmDiH
         H8S1i28/Rs7ws/6qvEnScwEd19T4L2djClEwMXcYLhgOXd/yPMAl2Ue/ZcQSSiNsirEV
         b3yA==
X-Forwarded-Encrypted: i=1; AKwUvBwOKyMdFWZosFkdn4sTyHPWk7fkdzpAvdscoplck5qCmeVytqWS3yQNFENd1s+Rfwx/Y5O5JRtwyg==@kvack.org
X-Gm-Message-State: AFq9FYIVcLMU2q6+V47V0mNCm/+p2S5aqVQIiCjeW3Tg3mL1BxYf1w+a
	EUi1B8/Qn93wlvDpTZ3w186BYIUjNAoXv2BxY4ZWfTjg2kwFxnXeNtUM
X-Gm-Gg: AYBFou1LipUuTETvEtHoBVEYQbF0QQiAC1PeXvfse/7Wyscpyy9GPdYYyie2t+R+F4d
	C5aqM7s7ysml8VXX9WzBrSMd1Dw12F3T3nIHTUrNplBF486K6O+UsNesH/Wlszrk4eXBvncE19b
	bQTzcLBgkka4TllNDkZhmeoesgtlaOIkbX3unhet03ZcfJj8m1xfZJhSDRI/s6UsCeWvMgGiBdQ
	RvhZY3oloV774IJkSYWrXAUGlojEHDMBrLWe50HGnYwx0ye5whHuGG2tipr0a4kxHpmCJFs0Zsc
	+Gflrg1gQpn773+dmaUpYTY1uzxIWyr163D7XGxkQ+KLLOraOBkWsws+IosdFBVmo7ny125WzXg
	4Kvy8z5Wiaipg4y1COm1taVWQ/bCLstPO5vMcr5xZG5hg4bcoelbbLY4SL6g3L/zEdVc66Ra7o5
	KJalndYwkLNXflh2yKD7zVNB7GzVxzrAenvhrzzsh9IR1eDAFIOUQkTcAJl0kLheYJ3QRZdHbCD
	JPCsnl0kZ1mOGogSdOD3rE=
X-Received: by 2002:a05:6512:3d24:b0:5b6:1a7c:59cb with SMTP id 2adb3069b0e04-5bcde6d3d68mr3270336e87.37.1791814220153;
        Mon, 12 Oct 2026 07:10:20 -0700 (PDT)
Received: from localhost (soda.int.kasm.eu. [2001:678:a5c:1202:7b92:9ac1:b9ef:5287])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bcdde90fecsm2861974e87.24.2026.10.12.07.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 07:10:18 -0700 (PDT)
Date: Mon, 12 Oct 2026 16:10:16 +0200
From: Klara Modin <klarasmodin@gmail.com>
To: Baoquan He <baoquan.he@linux.dev>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org, 
	akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, hannes@cmpxchg.org, 
	nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, yosry@kernel.org, 
	shikemeng@huaweicloud.com, chengming.zhou@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Subject: Re: [PATCH v4 00/14] mm, swap: extendable swap devices (xswap phase
 I)
Message-ID: <aszb4OgUUCh5JHle@soda.int.kasm.eu>
References: <20261003003136.750633-1-hebaoquan@kylinos.cn>
 <asZt7-8mcxqc1a02@soda.int.kasm.eu>
 <asylV5YyyaHs8rP3@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asylV5YyyaHs8rP3@fedora>
X-Stat-Signature: 8q1ywsu51hk7e3pr8s8nooywk3gh94u6
X-Rspamd-Queue-Id: 3AC8C14000B
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791814222-151710
X-HE-Meta: U2FsdGVkX18kQS5Y7Hh7OLeG/Fep1KfislDWkaAOj9PujISRYBEfCa/6bxJwwkAcQNI7FCx0UTj0mh3mBqdHa0M+HFoH8dsfBVKtvlv05H8L7DN4OKfaubjtOTqVMPjiw1qJVb3BhblGi8zJWOX+LPnP2x+n/Z2W4HSCUY8WSHgZh5nv9dNLFq88RLc2/XP9lJovDSGVJhi4Yny5fUV0TNEiHggY1VYHjz3GMFvOm7a9KOxMI+c0LP5bJbTcZI+XiK576xp6Z2DV7imYU28mysISlKaVIpkVjD20a6R9iqksXrELTT6F6NhCcIlXX/dkDqSjtiZGdStnIYrCx5zuOC9rgWP5NQB0xicCEQYz/2nDAwfaL5JSnQgFPw3M1ix6QvbtiySL1vON6qpMKoLTuhPaLVAF0eiiF1TfdNbRN13PCCWqxt1IvcnZrkwZ0IeWkL+zPIMi5DPV382elAsiSD95rzTcBRSiT0stivnjZGSqJqByEGvJshVdgklVcCrHugMGiJJrTsQmUDwutT8CjhrPvmbVkbtqn9IYUvXhhRaGhcXnGs5n7L6xMOki8XW5QQNXHhi7sCeDIZgg0wPHzjQrn2N73MifsiyS43JV8peJ5Ve31QZdZK72irLffgwDDsksNjYndCd9POh7rxoeU5dRDAUJSjnIJx6383DGoLFsm+8LjNbxXhDzgkW2PcbA6keRKKdD15SVBi4O2Pd46uNk2ZBZ7EWx+0toOmzjMwM8fHWtGpcujj+flXrEmRC3kqtShjjTPeJ+U7/bAbEEyyvg+E2lWPPjX4m8leFLeu7HxPMqHC1+g1IXAQoSa+SfLOQyE/M8xbroUZ1KwjkF9Jo9ti5reJHuXgv62BZ5KdplMtJEh5W+maFjn5Cq0KFzEMUSG8KvsRREiBWQ+6TT/2vewv6XDO5KRexwsP8VsdaOumPPhb3Z04nVUzBdKK0rzzebSIZIUCF0Nzb4fd1
 53+WJR0/
 Zymm0DKMlibV4mYEX44YqEZQT1sJUG/xrzlwmU7zhsWskKlVkWD/xTdN/K9K5zdJm4eop0+NFxfz/3Gavzu0HPASb/GMZyI31XwQcE912g1j0oeJMpfj5EbzL1mzH7GRQs6Y3Q43dKVtSNmWOpMfZauz9XsdjeWOaF8veWtNetZqT1eKbzCK6uBS7EoY296SqUaAsnJ6cS71BUcDQ6EHGOmLRCsyF9othOZa8FmLeIsXXY4xQFWEYTk63eZ7vuDueKMBZFU22QnnggiW6u3y/1dC1JRD4o8O1G27y+Kiiwug+/udykfLAYJ8xjql2d/V8M7RC0e1kWoiDF+JDX5f1WAcd7yu3s8b5ny/Cbw7SrGQP74Tr3fE+iSzBo8wArK1psHfKOyC76qYNQqKCmG/uTDSNwge3qsc/cRhkm7iRuDCI30bbkn/dfkb1KOIzVymiT8opxW+IGa9XDDhqeNHbnZBLNGh6J1/GkqNOFewoBqrEtEOTwZxD8QdyIaSqY3uCdZ3DahYxvce1SJKQKDUWDOATBOuUEnGRv/PtFVpYTBRTife9uQaDAF3zJxQjdnTsScA5yoRjYIVwQ+7ZZCcBnN1qw8ScaYfWuAE4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Baoquan,

On 2026-10-12 17:16:22 +0800, Baoquan He wrote:
> Hi Klara,
> 
> On 10/07/26 at 06:28pm, Klara Modin wrote:
> > On 2026-10-03 08:31:22 +0800, Baoquan He wrote:
> ...snip...
> > > The only argument create takes is a priority. The size comes from
> > > xswap.max= at boot, so there is one place to ask for a size and one to
> > > ask for a priority, and a priority can be given per device while a size
> > > cannot:
> > > 
> > >   # echo > /sys/kernel/mm/xswap/create          default priority
> > >   # echo 100 > /sys/kernel/mm/xswap/create      priority 100
> > > 
> > 
> > > The default is the highest priority, SWAP_FLAG_PRIO_MASK. An xswap
> > > device is then the first one tried, ahead of any ordinary swap device.
> > > Setting a lower priority is allowed.
> > 
> > Nice, this is now a good default which the user should not have to
> > change.
> 
> Thanks a lot for careful reviewing, and sorry for late reply.
> 
> > 
> > > 
> > > The device does not move once it exists, so the address space cannot be
> > > changed from this interface either. xswap.max= at boot and this together
> > > are the whole configuration.
> ...snip...
> > > Open items
> > > ----------
> > > 
> > > - xswap_create() sets si->pages to the whole address space (twice RAM by
> > >   default) and _enable_swap_info() adds it to nr_swap_pages and
> > >   total_swap_pages, which is what __vm_enough_memory() uses for
> > >   overcommit. That raises the commit limit by 2xRAM for a device whose
> > >   real capacity is bounded by the zswap pool and by how well the workload
> > >   compresses. The question is which semantics overcommit should follow:
> > >   worst-case backing, or the address space.
> > > 
> > > - destroy takes a bare swap type. The type is an internal index that
> > >   alloc_swap_info() recycles as soon as SWP_USED clears, so a value read
> > >   earlier can name a different device by the time it is written. The
> > >   swapoff ABI uses a path for this reason. It wants a generation or
> > >   another stable handle.
> > > 
> > > - The new interfaces (/sys/kernel/mm/xswap/create and destroy, xswap.max=,
> > >   the new type string in /proc/swaps) are not documented yet.
> > 
> > To me it feels a bit weird to have the interface split between a kernel
> > parameter and sysfs, meaning I have to configure this in two places now.
> > As far as I gather, there's also nothing that needs the limit to be
> > fixed at boot since it is applied at creation. If we want to expose this
> > limit to users (as xswap does) it would be nice to have a 'max'
> > shorthand for tha largest possible value, i.e. SWAPFILE_CLUSTER *
> > UNIT_MAX (or whatever it might be in the future). That would I guess in
> > practice give the same behaviour as vm.overcommit_memory=1 which might
> > or might not be desirable.
> 
> Thanks for the comment.
> 
> Here xswap.max= is a global boot parameter, while not a per-device or
> runtie knob. It sets the space space (si->max) of the xswap device
> at boot and can't change at runtime. So on the two places: the size is
> a global setting, fixed at boot; the priority is per device, it is in
> the create interface. They are different things.
> 
> The default is 2xRAM. From our earlier discussion, this is the largest
> size we think is sensible, and in practice I don't think it is not
> reachable in reality. If a system has swapped out 70% of its memory, and
> even more at 100%, it is already doubtful that it can still function
> normally. So 2xRAM is an upper bound, not a target.

I'm just not sure this is the case. An application could have a
relatively small working set but a much larger amount of cold memory it
rarely touches. In my GCC 17 example, I saw even greater ratios later in
the build process. This is from your previous xswap version where I got
around the 2x RAM limit by using multiple xswap devices:

MemTotal:        3966828 kB
SwapCached:          868 kB
SwapTotal:      80232412 kB
SwapFree:       69467760 kB
Zswap:            792048 kB
Zswapped:        6342024 kB
AnonPages:       2072820 kB
AnonHugePages:      4096 kB

This is almost 160 % of RAM in zswap and is getting close to the limit
in practice.

In addition, if I read your writeback series correctly, if data from
xswap is written back to a block device, the space of the written back
data cannot be reused in the xswap device (please correct me if I am
wrong). For low memory systems, I frequently set aside a lot more swap
than they have memory. If I do not grow the xswap address space size, I
could risk it getting full if enough of the block-based swap is used.

Looking at the example again, about 10 GiB of swap is reported as used,
but some of that is being reported twice (once through xswap and once
through the backing device) due to being written back (which I still
think is not so great). In this case, the system has 16 GiB of
block-based swap, meaning that the default limit would leave the xswap
device full if even half of it is used through writeback. If I would
only have a single default-sized xswap device in this example I would
likely have hit this in practice.

> 
> On the max short name: it would set the address space to the largest value
> the format allows. As you said, that is close to vm.overcommit_memory=1,
> and it is not a real capacity, so we may not want it as the default.
> 
> We keep xswap.max= only for special needs. Otherwise we may not need to
> change it.
> 
> Chris suggested a CONFIG option for the size. While CONFIG is not friendly
> to distros, you must rebuild the kernel to change it.

For my use case I would probably prefer a CONFIG option if that is the
only way. I typically build all my kernels on the same machine and send
the image either directly or for netboot. Setting the kernel command
line can be very different depending on the system (Different EFI
bootloaders, U-Boot and all its vendor versions).

> 
> By the way, I remember you mentioned you ever did a test making swapped
> out pages about 110% of system RAM, could you share your testing steps
> or scripts so that I can give it a shot on my testing system? If it's
> not convenient, then never mind.

It's nothing fancy. I just build the Gentoo package for the GCC 17
pre-release on my RISC-V BPI-F3. As I understand, the pre-release
sources will also enables some extra debugging and correctness checks
which will make the build slower and maybe also use more memory. Note
that I do not see the same memory usage on other arches which is I
believe due to the implementation of the RISC-V autovectorisation (GCC
14 saw a large jump and that was the release which added it). I do add
configure options --with-matchpd-partitions=20 and
--with-insnemit-partitions=50 since especially insn-recog.cc tends to be
huge and the default partition of 10 it will still be quite large.

My datapoints are from just dumping some fields of /proc/meminfo every
ten seconds.

> 
> Thanks
> Baoquan

Regards,
Klara Modin

