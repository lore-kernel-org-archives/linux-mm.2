Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0BB1C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 14:49:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 402366B008C; Tue, 29 Jul 2025 10:49:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D9DA6B0093; Tue, 29 Jul 2025 10:49:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 316B56B0095; Tue, 29 Jul 2025 10:49:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1F6C96B008C
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 10:49:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D016C1A00E9
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 14:49:58 +0000 (UTC)
X-FDA: 83717586876.10.88350B4
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf15.hostedemail.com (Postfix) with ESMTP id A979FA000A
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 14:49:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=f0M8jh1E;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf15.hostedemail.com: domain of gregkh@linuxfoundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753800597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SVKTJmQyfHUB47s4869m+0Nps+tqQ4H1sD3IUQa2NaI=;
	b=8FR7wiLOv7Kop4n8cdz2xYxZuLeLXrUU3s599NV3wSVocUME+YBSgHzuzf3H8VnsriT78N
	hyh66vK6SGt+bHw1ieXGEXhm3I4VfRypfEqo3IJX9xER2aPnj0nPyp6xIJJjQksTqdaHFe
	Nh7HhP2SKbY3It0/ySt7TgB5W5t5zCo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753800597; a=rsa-sha256;
	cv=none;
	b=Em5CUa/VQ1odVU0Su4nokJSJgE/JyH5/MtATsfDodgdHbN40gm837K/1qFmH/izQRyFBKj
	jHsbMNSAYxK3gN42Nrj3cUlDmm+RqGNRCOi4udrkgH2TMZAWbprIefCsRiy/pDYRnnuGcc
	JZiNi069OyWeXb/IsO6I/sgpKb7R3Fs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=f0M8jh1E;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf15.hostedemail.com: domain of gregkh@linuxfoundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id E343BA544D8;
	Tue, 29 Jul 2025 14:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A41C4CEEF;
	Tue, 29 Jul 2025 14:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753800594;
	bh=8WHu65Du/5RAZ7vIpLgroUB1ihWHIGMcCMvNDR1D48w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f0M8jh1E567Dzc3VA74jPcIWNmhbrWXFrtgIR+481l4ITDFj3cWe2icTVpA176/Lk
	 UxRnG1qinStkhCVNNpHX89TXWi14XyKBQKvWfXD//W1GQONi1zFZYJTGsbu+LAxBz5
	 sYm3dQftOPHbWiU0MEKRivX361+bsOcsDozaG1vk=
Date: Tue, 29 Jul 2025 16:49:51 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Jakub Acs <acsjakub@amazon.de>
Cc: stable@vger.kernel.org, Liu Shixin <liushixin2@huawei.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	David Hildenbrand <david@redhat.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Mattew Wilcox <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nanyong Sun <sunnanyong@huawei.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 6.12.y] mm: khugepaged: fix call
 hpage_collapse_scan_file() for anonymous vma
Message-ID: <2025072932-scorer-manhood-b6fc@gregkh>
References: <20250729090347.17922-1-acsjakub@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729090347.17922-1-acsjakub@amazon.de>
X-Rspamd-Queue-Id: A979FA000A
X-Stat-Signature: qwfr8w738mw8ahsw4s14onhgzkf8wokn
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753800595-948427
X-HE-Meta: U2FsdGVkX1+iRuk6/JiJHcAyusI7Ekd/8vleioNigrbaqbp5jlb4VHObbDwJvgTyUyOWYqwWHca/1LDh8vGGNJqeg/HP5JadQpN+1UyhOuRZh4beudHrGH74+R3WGaLdVXuPFFVDU/KbK2e2HQYdpezr+Ylhgvexgkz35ljAAHM/fuoMFU3lIl9kplU46BKIUDR1gKcIpEtgajty25pYvhhwdf+6TONy4CpFJpK7Cnl3UIxtVRcapUD+oJqN+0Hzcu7rWXsnEJNU2bg2efp8zMDrVBWFt/F6dIWRNLT/QI5X4zI+sTSBWlAwuAKglr7vDsK51+nb9Ku2eVwwVZDLf6iSZZs5SdDX8QXtftkVDHWl1ZDCX3AHcq+Em9qa07RksVMAvkIW+Z22R9fr8Gf+RP7U8LGCFHwRkXD2rGtUqLTzhLF5K5Eqz0Eq/BOUpgANitGBYxzuFyvtvrpW9N3diXUeY3/Cv7qhbC2iuBKYt/xEyngAgjZ5yV/aild5xn7UEeS5xW2meOx6PyRzpWrA7aK/C8WcQnbZdqTH6pWh+IGGPj9VTyoaKjPWmnMKW/49D2G+BKGBYqeuLQAYPZmYDX3SlNAg5MJxhSagCWBcNKe7RHypTTqx2i3W73lNOzarkEnIhYVOM/ob1icZmsfiSS8GMPuOfCGtNJcpIaVYMozFZ843d9sx+ecTY4bV0tAD10tODi+YkKEo1rIuqgUIiZM7YvCej9SYgKtlu+rHB9SRTz2Fc64ylvDA9v9HGBb/1ovEgsIzUS02/zIo3PrqVCmUP41l0Q4iCCZhD5HqqNTRpkmYzZP54JmniCGxRvKz5Q5oaDohkMl9/vLW4Tk/GyawciMkLTNTKA/teZgQiVJ7Glozq8enAOoC2WWmvJYv4L5eM8pxltyALKbMM+w4IThKWhdeu48JCwi7oYYa2kg8qlwNpV9CzJeX1WVa3uRI69QbJxn+Jgcxobcowkd
 qakbl3jw
 U8dQZgeLRFJcjTjvtF1jymDOo7BTAdIpf1u236953+OvYmFO00YhAEHzuE+Rx1f9lLha+E0bjvSRH8671My86bvwrAMaMpB3fAvbeFpk3C2GVCIqs1Od9OniCvO/UmPMsTv2w/uFwdx2zS1TifIf9XtYbhSkzLfsL7Zns7gMGJqTWGGFaMMqdeawWkj+VGtJKIO6VHGyhVpNUyQzHTA+wQOuLyjQ92GkceW6kf8jYKFWXPhupODJWBr5QGM20xdEzHOk/kgXoRT8PXtZKZzIGBjiUcf3e3BgFEW4ZvYO3U2joZH13fV0RO6Ggivlar/XaeRk0Bw38ldl46w+vuJFcvVlmAIZu0tx7d2bPT8sKJkCKnbP9P1+KAkEMSrDpVWfkEox8AAryIYyGxXPbIe+ioxXymkmSmqy+ejY7NR1mgGOaV+qEcU3bqFao3SWMvZyMI1NGADbaSUZAneWMPY83o11xJgYCVuHF447/euBOLp2Lg9LP9cguJVzfsZZmxmbe4xzcaiQ7ssaUtdIsfE1fBXkq6OifhITl8IRgYFf07pv91WBjCrL4zh9b+AUlrHleejYXzrk6jZCY54lWYhEqXcCJ1QsfJzPZtICSv3VSX1Q1N1eZw6WSQPgZrj17frhNk58KFnFIwZ5JVH6AMy+30o4cIZPNg/uDgJ2mVYQyuUPc7qhbKkxQkE0jjknGcn7I+yTE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 09:03:47AM +0000, Jakub Acs wrote:
> From: Liu Shixin <liushixin2@huawei.com>
> 
> commit f1897f2f08b28ae59476d8b73374b08f856973af upstream.
> 
> syzkaller reported such a BUG_ON():
> 
>  ------------[ cut here ]------------
>  kernel BUG at mm/khugepaged.c:1835!
>  Internal error: Oops - BUG: 00000000f2000800 [#1] SMP
>  ...
>  CPU: 6 UID: 0 PID: 8009 Comm: syz.15.106 Kdump: loaded Tainted: G        W          6.13.0-rc6 #22
>  Tainted: [W]=WARN
>  Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
>  pstate: 00400005 (nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>  pc : collapse_file+0xa44/0x1400
>  lr : collapse_file+0x88/0x1400
>  sp : ffff80008afe3a60
>  ...
>  Call trace:
>   collapse_file+0xa44/0x1400 (P)
>   hpage_collapse_scan_file+0x278/0x400
>   madvise_collapse+0x1bc/0x678
>   madvise_vma_behavior+0x32c/0x448
>   madvise_walk_vmas.constprop.0+0xbc/0x140
>   do_madvise.part.0+0xdc/0x2c8
>   __arm64_sys_madvise+0x68/0x88
>   invoke_syscall+0x50/0x120
>   el0_svc_common.constprop.0+0xc8/0xf0
>   do_el0_svc+0x24/0x38
>   el0_svc+0x34/0x128
>   el0t_64_sync_handler+0xc8/0xd0
>   el0t_64_sync+0x190/0x198
> 
> This indicates that the pgoff is unaligned.  After analysis, I confirm the
> vma is mapped to /dev/zero.  Such a vma certainly has vm_file, but it is
> set to anonymous by mmap_zero().  So even if it's mmapped by 2m-unaligned,
> it can pass the check in thp_vma_allowable_order() as it is an
> anonymous-mmap, but then be collapsed as a file-mmap.
> 
> It seems the problem has existed for a long time, but actually, since we
> have khugepaged_max_ptes_none check before, we will skip collapse it as it
> is /dev/zero and so has no present page.  But commit d8ea7cc8547c limit
> the check for only khugepaged, so the BUG_ON() can be triggered by
> madvise_collapse().
> 
> Add vma_is_anonymous() check to make such vma be processed by
> hpage_collapse_scan_pmd().
> 
> Link: https://lkml.kernel.org/r/20250111034511.2223353-1-liushixin2@huawei.com
> Fixes: d8ea7cc8547c ("mm/khugepaged: add flag to predicate khugepaged-only behavior")
> Signed-off-by: Liu Shixin <liushixin2@huawei.com>
> Reviewed-by: Yang Shi <yang@os.amperecomputing.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Cc: Chengming Zhou <chengming.zhou@linux.dev>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Mattew Wilcox <willy@infradead.org>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Nanyong Sun <sunnanyong@huawei.com>
> Cc: Qi Zheng <zhengqi.arch@bytedance.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> [acsjakub: backport, clean apply]
> Cc: Jakub Acs <acsjakub@amazon.de>

You need to sign off on patches you forward on.  Please fix that up and
resend all of these.

thanks,

greg -h

