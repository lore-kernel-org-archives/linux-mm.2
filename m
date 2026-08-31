Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 947DBC61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 17:54:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E676F6B0092; Mon, 31 Aug 2026 13:54:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E17A36B0095; Mon, 31 Aug 2026 13:54:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D067D6B0096; Mon, 31 Aug 2026 13:54:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A93626B0092
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:54:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4354C1A01E3
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 17:54:41 +0000 (UTC)
X-FDA: 85162314762.19.B3E456C
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7C0A8A0003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 17:54:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iN495hic;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788198879;
	b=yDVJdvzDYM0wAmlpBcpJ3cWX/5LasmvdqAfL7NEdf+LSHFSzbCfkXYGGTlYPOsUsffBg8o
	42QCoVQrMioJjBF1BX7yARXXymWgE8IAcdbh2pXAgIQK863UaYtz5YDM/f+4HmGzDoGkmV
	8HQDlcczE8CQFSnjEbinPEGBIvOtzeU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iN495hic;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788198879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EqIx8ijt4hM95Y+cetezXZICQTZpN4/GGo2SvJmbUF4=;
	b=AKi2wnVfTldeHo5SWpbvfF6kYmWlRBLxuGO3O5V8ku0JoiG62oRdgcFqMABXc9sVH0As6F
	SYoph8TIUJgIJQVaJD0fe2HjWYyjokqQy/EdzdLymKpRqyX6GN/ZdjPh5dW1y+WxL3G/je
	RlRB7ZU5B0ublUPlmyMANulto26R4pU=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-38a0c7e841fso59585a91.2
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788198878; x=1788803678; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EqIx8ijt4hM95Y+cetezXZICQTZpN4/GGo2SvJmbUF4=;
        b=iN495hicGcFqXhpocm3J7k9MAhuYbPWkkMJ/qPGNscA3ijjS8gAX1kFfzg2MR1dQkr
         sQENt8gVQoxwRunYM9PGEMs6XZiGZMd6UZKk1W8pwXNmfxeDZAkOfCVsvd2d4rylEcmf
         qsXfGod3d1A72wwmog59SNwz+L6s/xKYPogftrZCxjTgSGTQl9USBaiP9gFXfDJOLcMc
         6N/SdlQDswhuFgxaYpw79AJBN+f97AP7iSA+rABD50pWec8bWo8jPWDcK+h4zvPavXOh
         yHPXnFqw86DBN5K3RkCpXtEXnBvJDgwqJ6rjg2h0pzyZqls5ULYw86NcGDzW2CNURIrm
         +3lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788198878; x=1788803678;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EqIx8ijt4hM95Y+cetezXZICQTZpN4/GGo2SvJmbUF4=;
        b=VM3Ms3uvaoZy5LTEcQA4nG2DM44/0CDDerB6Zb60SUcrV4gvfe5doMu+LQM+7TBvi4
         zK+tgPoLSy4d8yXT5Hj2OV4ZF+9wMafaUku8+KnDBbgKy+ulC9nZQi69TYtMMEmTXvBD
         rvi3aOG8MeG5n+dL2R/xN6F/q13mV8oUQUt86cmLFck3oEgpp69jdnGrz/PQHOhmml/h
         LViGOJ78L9xBfyqb94KqZ+WGXDk7ijZ9xHiBD2yyJSTgBTFR0ET+KbOHSC3qAuKsLMKc
         K5SR9biiIFZ58XA1NOhC4FS6hru1cc3wSYroiWdUpsrvIkmke0wEfihMm7SgxbIka0ue
         8tag==
X-Gm-Message-State: AFuF++ku/itcSttiQ/zGR54E4MHVRTZM+Fizj9G0PMAQGDfRJA7qSCUX
	fmjcBgldAZQ9XwmxuibDEFHK9SzYS1i9JMjVKghhPPOtZ+xGwLoc+byr
X-Gm-Gg: AYBFou1BmDd+T+kX4TYOYt22pGc20DY5akFys66yOp1oA0A9ofT7oKmicvvLdn2s6rz
	cMZmluE1mbu9LP1q0eorLlFEkPRz+Ytl2ePDiX1b/z6yc/d2wAtvekvDDmfRnDRRT/4mJBW6lJ4
	zoffFOe0I1sbNtq/wO4HbyVtnhvuRrY5SIV4CPHqwAKVDfqxv/2SpX9QejJZV33defjRB5iA7Dq
	oW3aVQPJx28zIabSzTMgxo8azfF2LGSdN+nzAFHfPtk1SrUbNxXYys7Q2t4afigYOTOKM0LyERm
	RkPczUw4Wl0Qcgn/xcweOF3dCgNVnzJSFnAyY2Bj00j6jrAa1esllquQb9Qf6Ge+WF0/uuFbFnU
	pKwBdT0Y6g9NxsNLmY+DeT3AjiUEGZTcvfyw9Xm5QWiyNaIedV2JY2uMQQ8Nq9C92ySStbNPqFi
	+yQw3LTZ73km/xllFMzsfJSQ3vAvB6q0BnHwy7Iu/rt9pa6yr5s02AVupaLBheSN05/Zf8MKJUu
	/UpEwuxL/sCH5XKx0wTNu1F
X-Received: by 2002:a17:90a:dfc8:b0:398:e1f4:bda1 with SMTP id 98e67ed59e1d1-398e1f4be7dmr13082589a91.21.1788198878072;
        Mon, 31 Aug 2026 10:54:38 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-398aa331ad1sm5260154a91.2.2026.08.31.10.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 10:54:36 -0700 (PDT)
Date: Tue, 1 Sep 2026 01:54:29 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] xswap: extendable swap device backed by zswap
Message-ID: <apVNB2FRTFMDtvGP@KASONG-MC4>
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7C0A8A0003
X-Stat-Signature: dmktx413xaxn4khh7mpkwocgtrkmtwqw
X-HE-Tag: 1788198879-414562
X-HE-Meta: U2FsdGVkX1+0jixBJl0iykjRlabp4c3HEbsEGiFtUI8lHondkHm2aufUBDXiPjYVy7M58/5LcnNdXv2CbMbw3sNwv5pwvxXLjIiGhEkvgo16hv4XhEXScxZlifz3DbVyfuzpamKIJi2MceJZJsI5S2yO8LZKRzbrbU0LPAAOF388qsCeGkN9eewpdM3Rb434GvnEbZ64QlcJtklP+kGSMyeQ8bwtQ/1vYBBlWQpQhGm5O7b7CZFKmWQKiap6rqOs8vg/hieR6SGPWmnSrspTdFID4DhXRQut35AO5ibPZHBbeiAkzqHTZ2rORUlzQeKgbCwYRuuuomNRn+QYrY8IShLmZJDzSAlr4RteS/AihnYnKE8mttdr26Rx85pVEB2USG6hi6PUiizYCjqIz8SI4WtnS7P49fw2ce0rxE395dQ88Mj1nnR1zxr4qNZ1wWlrmgrQ2j9zjsDxL3wvq1mz8oGVhi1oHrSd4l0j47asvXPYbfTxMUeyrXV9XjvEiJCNJPwCPAntvYCy42oPpD36cOqgEsMMNJMwCbAm/VgIF9iAvcqlS20ifRDBAPksAhT8W9x40SR59rCW11QKCVqr5DLpt+97FVHySrTFSZwyN+D16NbYaq0LOGBq1spuS+kVOcOP7aFcg+tJ72lmMwEZwX1zHld4rx+lhuG2B75sPQ07CtVDSOBtommIXi3g/UPqEnBY3MT+cUsx+ilDCdJLKh+39ShCFVR5RwEIbBIG2AsCwg5CzuO+Dr4BKAJ7unWeWmsDVPB24+QDtLzIuKVJdA/+FoSyDrtbHNbRNTXmAoFK9WU3jyTBw5pBUTyU4/KZtpdfIu2wvNHsbsdUpT4j+mz5o3PZ5vfEXJwbNJBwSNYjf4ykvKMQmRZOCo0p+QFm2W6ecrGhGEJ4LJQ4szj6UTgL/SOFsbmaVDQih4Uv7pf6lzldg0a4jpzHIKSUI9rnIbfISvVovC8yb9weluw
 K4VNC3ma
 hxYljTRq8FHK1yGasjBk10UzTRhEBeukg6Xx7xfDyzHjQHb1cXSo27jbyd+Di+iyHCY26cWEbDuUzLCpjgD2Dde4YDd2hwhTVpyr6RKYAg5rylLRUCO5tZmHJYOoq03GGsgLUo4lf/d3ip6CePayz6bX2d6WneuhORIHinICUa/gLMwI1u0X7cu6APzkxrNjFYNiqfLDg2pFQ9RQQKKe/D4LneAlmrDcjeYTwD2yDkjCH6GLhXTS0CkqVaMfyWDFJgHvdc8zrruI6JjK3/CDnc3UTlHVN+B06QylZfPdGc80RSFCKT6UEPov62CZGTwgxHqzEMJucak5IM7LqIiCAUj/BqaptkJHFj+zzNOcaGmIQZLQtt6PImzEytX2eYsLQjESklG9RnQqX2iePmI8uwK17AhTnfp1/43RAdn4WqXrtuEz4Y/0uz+1q7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 05:44:50PM +0800, Baoquan He wrote:
> xswap is an extendable swap device with no backing storage. Swapped-out
> pages live only in zswap, so the device wastes no disk space and its
> size is independent of any physical device.
> 
> xswap decouples PTE swap entries from physical backing storage. The
> cluster_info array is backed by a sparse vmalloc (VM_SPARSE) area that is
> grown and shrunk on demand:
> 
> - Grow: when cluster allocation runs out of free clusters and the device
>   is below its ceiling, more physical pages are mapped into the VM_SPARSE
>   area and their clusters are added to the free list.
> 
> - Shrink: when contiguous free clusters accumulate at the tail of the
>   mapped range (tracked in O(1) via nr_free_tail), they are unmapped and
>   the backing pages freed.  Shrink is deferred to a workqueue to avoid
>   lock recursion.
> 

Hi Baoquan,

I didn't check too many details on how the implementation in previous
RFC until now, After looking at it, using VM_SPARSE to setup the cluster
info area is a really smart idea, really good job!

I think many info are missing in the cover letter though so I wasn't
sure how this grow and shrink works from the description, after
checking the code, it looks much cleaner to me now, correct me
if I'm wrong:

Every xswap device will have a huge and fixed "hard limit"
(si->max and si->nr_clusters_max), and practically can be considered
large enough to hold any workload, and won't change once swapon
is done.

The actually data (si->cluster_info) of xswap device is completely
sparse and dynamic using VM_SPARSE, and so we don't need to change
any existing routine. It grow/alloc and shrink/free automatically by
the kernel, limited or driven by a "soft limit" (si->nr_clusters
and si->pages) which you can modify using the interface below.

Once concern is that the "hard limit" is now the total RAM size. Isn't
that actually a bit small? Will be better if that one is tunable too?
With a parameter, and before swap on, as the hard limit is hard to
adjust once swapon is done. Any thing limiting this?

And I think these details better be mentioned bit more too.

> A per-device ceiling (nr_clusters) bounds growth and is adjustable at
> runtime via debugfs.
> 
> Interface:
> 
>   /sys/kernel/mm/xswap/create           write "<percent> [<prio>]" to
>                                         create a device; percent is a
>                                         percent of RAM (0 for the default),
>                                         prio is an optional swap priority
>                                         (default DEF_SWAP_PRIO)

With what I have read so far, the mandatory percent limit here is kind of
strange, even with 0 as default. Why not make both args optional and just
let it grow without any limit by default? It looks more "fully dynamic"
that way.

>   /sys/kernel/mm/xswap/destroy          write a swap type to tear down
>                                         a device
>   /sys/kernel/debug/xswap/type<N>_cluster_limit
>                                         read/write the per-device
>                                         cluster ceiling

Having a lot of type<N>_cluster_limit in a seperate debug path
looks a bit odd to me too, and the _cluster_limit doesn't look
like a debug interface, we will be relying on debugfs for setting
the limit, also see below.

> 
> Since xswap has no backing, swapped-out pages are stored compressed in
> zswap: physical writeout is skipped, and zswap writeback is disabled when
> every swapfile in the system is an xswap device.  xswap requires zswap, so
> device creation is refused when zswap is unavailable.
> 
> Naming:
> ======
> I'm going with "xswap" (the "x" for extendable/extension) rather than "vswap".
> Chris suggested this name, and this aligns with the "VFS-like swap layers"
> direction Chris Li described in the first swap abstraction LPC talk
> (co-hosted with Yosry) the swap ops and the xswap extension interfaces in
> this series are moving toward exactly that. I don't have a strong preference
> between xswap and vswap, so if reviewers object to the name, please comment.
> 
> Note:
> =====
> This patchset only build the base. On top of this, the subsequent core code
> implementation of xswap writeback, rmap etc can be done more easily. E.g, we
> only need add one field in struct swap_cluster_info to let xs_table point to
> physical swap entry, or zswap entry etc. On top of this patchset, no need to
> stir core data structure too much or introduce extra data structure.
> 
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -57,6 +57,9 @@ struct swap_cluster_info {
>         u8 order;
>         atomic_long_t __rcu *table;     /* Swap table entries, see mm/swap_table.h */
>         unsigned int *extend_table;     /* For large swap count, protected by ci->lock */
> +#ifdef CONFIG_XSWAP
> +       unsigned long *xs_table;
> +#endif
> 
> Testing (taken on qemu kvm guest with 8G memory):
> =========
> 1. enable zswap and create/destroy xswap device
> ~# echo 0 > /sys/kernel/mm/xswap/create
> -bash: echo: write error: Operation not supported
> ~# echo 1 > /sys/module/zswap/parameters/enabled
> ~# echo 0 > /sys/kernel/mm/xswap/create

Recent proposal have mentioned mm/xswap, and mm/swap/tiers, while we
already have mm/swap and module/zswap. I think it's fine to use sysfs
to organize things but will it be good to have it in unified way to
put them all under mm/swap/? And will mkdir be prettier than
echo > create? For these part, just an idea, no strong opinion here.

> ~# swapon
> NAME   TYPE  SIZE USED PRIO
> xswap0 xswap 2.3G   0B   -1
> ~# echo 0 > /sys/kernel/mm/xswap/destroy
> ~# swapon
> 
> 2. create xswap device and tune the zswap size
> 
> ~# echo "50 10" > /sys/kernel/mm/xswap/create
> ~# echo 0 > /sys/kernel/mm/xswap/create
> ~# swapon
> NAME   TYPE  SIZE USED PRIO
> xswap0 xswap 3.9G   0B   10
> xswap1 xswap 2.3G   0B   -1
> 
> ~# cat /sys/kernel/debug/xswap/type0_cluster_limit
> 1990
> ~# cat /sys/kernel/debug/xswap/type1_cluster_limit

Can we just use size instead? Calculating the cluster number
seems not neccessary, only making it harder to use, if this
is suppose to be a formal interface and not debug only.

> 1194
> ~# echo 2048 > /sys/kernel/debug/xswap/type0_cluster_limit
> ~# echo 2048 > /sys/kernel/debug/xswap/type1_cluster_limit
> ~# swapon
> NAME   TYPE  SIZE USED PRIO
> xswap0 xswap   4G   0B   10
> xswap1 xswap   4G   0B   -1
> 
> 3. under heavy memory pressure tune swap size or destroy xswap device
> 
> ~# stress-ng --vm 1 --vm-bytes 8G --vm-keep --timeout 120s &
> 
> ~# echo 1024 > /sys/kernel/debug/xswap/type0_cluster_limit
> ~# swapon
> NAME   TYPE  SIZE USED PRIO
> xswap0 xswap   2G 2.6G   10
> xswap1 xswap   4G 182M   -1
> ~# echo 1024 > /sys/kernel/debug/xswap/type1_cluster_limit
> ~# swapon
> NAME   TYPE  SIZE   USED PRIO
> xswap0 xswap   2G   1.4G   10
> xswap1 xswap   2G 315.4M   -1
> 
> ~# echo 0 > /sys/kernel/mm/xswap/destroy
> ~# swapon
> NAME   TYPE  SIZE USED PRIO
> xswap1 xswap   2G 1.1G   -1
> 
> I tried create/destroy and grow/shrink xswap device under heavy
> memory pressure, all passed.

Do you have some performance reading on this? I remember you had
some in your previous RFC, better to at least keep a link, I spend
quite some time to find the previous zswap test result from you.
I noticed this series is different from what you sent before as it
only contains the foundation so there could be no performance gain
currently but still, might worth mentioning what this could achieve.

Another thing is, maybe we can defer the implementation of shrink
for easier understand and review? The memory consumption is totally
acceptable even without shrink.

