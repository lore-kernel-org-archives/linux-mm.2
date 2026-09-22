Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B826C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 03:12:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBA506B00A1; Mon, 21 Sep 2026 23:12:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E92456B00A2; Mon, 21 Sep 2026 23:12:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCE5F6B00A4; Mon, 21 Sep 2026 23:12:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B50FF6B00A1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 23:12:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B244140361
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 03:12:32 +0000 (UTC)
X-FDA: 85239925344.20.FBBF348
Received: from mta1.migadu.com (out-109.mta1.migadu.com [95.215.58.109])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6FDE31C0003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 03:12:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wmIBmFzp;
	spf=pass (imf20.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.109 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790046750;
	b=q8h8VL6C7yvTOPMMj+pHE3gN7Rs7vxRmGk1qy9dsWnkIKXQMQ83VqnJ0a13R42krU6wTuM
	RkQYOUWDQ28McQQttp1oVIP3s0A/Q8B1sNe+UpgsC2tLNuz5RfM5FR3wUTZSiSZctP/hol
	Q/KBvU/4l6BXsOdAIIXeKC7FM/qD3PA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wmIBmFzp;
	spf=pass (imf20.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.109 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790046750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j/gntjmBhg2JfCkM8G/GZWAqQLGfZErpEcldCr4S8TE=;
	b=lnEc+ER7HOuj76uZ9PMwCMGBO3Ynq739cz4Sr307yfZK/52EL7W0/Lp+4evQCNx/GDXEQI
	atLTSk145hUBAB7iPRMKwIAxY7JVx8oVosZJjOM52ifDJUpIrClFmmpGR/PqFUFBw0NIV7
	RDIhV77+UtPjfTA6oUNqsL6CWlKskN4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=fqInk17I5hhfQnP03ChwBojmoHSswahGqJt0SWkJHZA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790046749; v=1; x=1790651549;
 b=wmIBmFzp4aAduj/p/5j8yrxY768Gd8IoN7sD7OXVY6Th1tueNdRyJyeQyQoWCs5AzlEiz6ih
 mh4TAUb7EaecFtgnUHfTj6QMPoa4j9txRRqoHYqEmwVbbaYv2AWqQaGR/D/frnpS3s3HXO199kw
 XkhZ5SvSfYGUq86479uPSYSQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 82d2f06f988945bb;
	Tue, 22 Sep 2026 03:12:29 +0000
X-Mizu-Trace-ID: 82d2f06f988945bb
X-Migadu-Flow: FLOW_OUT
Message-ID: <f151fb61-6e9d-4f42-8a3e-89cf5f4fcaea@linux.dev>
Date: Tue, 22 Sep 2026 11:13:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [USB] WARNING: mm/page_alloc.c:5345 at
 __alloc_frozen_pages_noprof+0x39a/0x3d0, CPU#41: swapper/0/1
To: Luiz Capitulino <luizcap@redhat.com>
Cc: akpm@linux-foundation.org, mathias.nyman@intel.com,
 linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, linux-mm@kvack.org
References: <8b77688e-3219-4133-af0f-395e342acb25@redhat.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <8b77688e-3219-4133-af0f-395e342acb25@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6FDE31C0003
X-Stat-Signature: inpto6i4ij1n5qizamiy55iqcm7nzk8t
X-HE-Tag: 1790046750-176479
X-HE-Meta: U2FsdGVkX19NU9j26ZYNjvwZRD6J0G3OC3GWLjhFswKPhCf/e4BEk5cdm1Svn0gYFU1n6G/+zIfBhJOAi482HnhM5r6TLnC5PEDCnxOvXJbo5XoS9ddeEWeon/t1C4OhRusRQr5VeiisstQRlNvJ0yLdVout43FbjtGRT6xYJlMKZztfdDVxZqlgxx1wASCs5HVNtSwBrpUVIKBX3zrlork6qqmVB3XG+y9QYzHtAis0hCexhVsUQsiNI3Y8as7hiCWPo8adzzzdNx4rUgJHQ1DJHzm0KXa/TTZDNZRm85OmYfJd0d2KxViN+UazAZ2i3L019z0+fra58I7JzUE5lQF+35nDJBRh2/6/eyRdR+3h1BURKxWj2S/2w0bPY6f4b3NngHLg9Fbcx/z0AmtJ3GbrtwOes0S2NZfnUdsMwjlLD7OEftod40J1zvd1OGqsRJcZO8NKTltWotiFKThCwnqhj7GXuiX/94HQh0i5ySzFj8HAOoDMCCAs7vCdbmvBYyqE3BWzI7lWMa8RPfX4+WjhwqUD54bG8TPgwPr1OZcMuOmsNv4ht/QbikLqJuuMhmFX3pLl1isCPUfjucLwDJ+sHUliCBOWj9cD3p33MQ/GPF+/TLTukJgkEgkqkT8xb+Sjs4oOMNnG8vN82xiP0NyDTCovHzQ5mrcSCMrbnkDOVnB9tr6d7DGUs3x8smS2OdAofPy7vtbsrgvmkwafPf0Bfqj9c/GGD0MVqps2GVm7E8SPlIhqHcCEVVOr1N5OrwFmfh4iP6IJqTAyetPOqGxzgrZ+G3MaxDsm8pYA+FzLe5Tn4flJTcb43isWbRJJTDzEPUqYhGtsaPzfBkQOGvdCfiE5Wu+haPmTBvrN0KitWd1ZCs+Ly1XiQOdRx13+58lMAsOtQSIH9usHod4pORSHzQrHVJZEi162Bn9IMv4wFeiCLMlzaOs1KeBxPm+1CQiUFCKWxfr1q7ntLvj
 A7fXZu7s
 eMOS8689CX4Wgda9CL9DS0rKZzYCENdBuLP8FEvdbniSbcjG/1/USsIuNm2v18erAeWi2pJ0m0t418MAPVGfpR1ldpVXEnznf6eMPhAzNKAiUPqmTSH3go244UoUGXx4xlA65USeTxgjiE6KHRAQgDeOWHOt5qeHqhDvXAfWoNy6rFDWUWxMsZujolGWmuuMz18BdEU4ntAGCAqTiqMcQ2ijr19g5dJZvtqxiPXntOB9zQKpYfRRC+nQJ9E7+vxlw6GWbqE4GJL62kaRlRTOieTvxTLRNQVDQXXGWEEDgVzhKDFZJAUoRXU8K4NyoHeg4QJJUhrSwBbXHtaAqVtq7f1ZBg6fq0/dt9dCiBmfCIkRx/0RHsr9i7Mvz8ABmoN5SL3CUIo6X8F47/PRzpSw6htiGx6kIz7YLSlgzn2vnofgtDUM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Luiz

On 2026/9/22 10:28, Luiz Capitulino wrote:
> Hello,
> 
> When booting the latest Andrew Morton's mm-new tree[1] commit 498ee28e5ec4
> ("mm/swap, PM: hibernate: atomically replace hibernation pin") on a KVM guest,
> I'm getting the following MM warning being triggered:
> 
> """
> [    1.667197] [      T1] WARNING: mm/page_alloc.c:5345 at __alloc_frozen_pages_noprof+0x39a/0x3d0, CPU#41: swapper/0/1
> [    1.691217] [      T1] CPU: 41 UID: 0 PID: 1 Comm: swapper/0 Tainted: G        W           7.3.0-rc1+ #12 PREEMPT(full)
> [    1.692073] [      T1] Tainted: [W]=WARN
> [    1.692378] [      T1] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS edk2-20260812-8.fc44 08/12/2026
> [    1.693158] [      T1] RIP: 0010:__alloc_frozen_pages_noprof+0x39a/0x3d0
> [    1.693685] [      T1] Code: e2 04 e8 49 85 ff ff 45 31 c9 e9 14 fe ff ff 0f 0b e9 e7 fe ff ff 80 3d 6d 3a f2 05 00 0f 85 2b fe ff ff c6 05 60 3a f2 05 01 <0f> 0b e9 1d fe ff ff 48 89 5c 24 40 48 89 6c 24 48 4c 89 64 24 50
> [    1.695238] [      T1] RSP: 0000:ff46f50b801538d8 EFLAGS: 00010246
> [    1.695723] [      T1] RAX: 0000000000000000 RBX: 0000000000000cc0 RCX: 0000000000000000
> [    1.696356] [      T1] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000cc0
> [    1.696981] [      T1] RBP: 0000000000000034 R08: 0000000000000000 R09: 0000000000000cc0
> [    1.697605] [      T1] R10: 0000000000000034 R11: 0000000000000100 R12: 0000000000000034
> [    1.698231] [      T1] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [    1.698872] [      T1] FS:  0000000000000000(0000) GS:ff2b932745209000(0000) knlGS:0000000000000000
> [    1.699592] [      T1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    1.700119] [      T1] CR2: 0000000000000000 CR3: 00000006ede4a001 CR4: 0000000000773ef0
> [    1.700745] [      T1] PKRU: 55555554
> [    1.701023] [      T1] Call Trace:
> [    1.701283] [      T1]  <TASK>
> [    1.701512] [      T1]  alloc_pages_node_noprof+0x4c/0xc0
> [    1.701919] [      T1]  __dma_direct_alloc_pages.isra.0+0x164/0x1f0
> [    1.702402] [      T1]  dma_direct_alloc+0x19f/0x2b0
> [    1.702767] [      T1]  dma_alloc_attrs+0x8d/0x200
> [    1.703133] [      T1]  xhci_alloc_interrupter+0xc9/0x190
> [    1.703543] [      T1]  xhci_mem_init+0x283/0x340
> [    1.703902] [      T1]  ? __pfx_xhci_pci_quirks+0x10/0x10
> [    1.704317] [      T1]  xhci_gen_setup+0x35e/0x4f0
> [    1.704684] [      T1]  xhci_pci_setup+0x52/0x1c0
> [    1.705038] [      T1]  usb_add_hcd.cold+0x241/0x5d8
> [    1.705413] [      T1]  usb_hcd_pci_probe+0x188/0x480
> [    1.705803] [      T1]  xhci_pci_common_probe+0x6b/0x2f0
> [    1.706218] [      T1]  local_pci_probe+0x4a/0x90
> [    1.706582] [      T1]  ? cpu_hotplug_disable+0x15/0x30
> [    1.706986] [      T1]  pci_call_probe+0x55/0x150
> [    1.707357] [      T1]  pci_device_probe+0xae/0x150
> [    1.707734] [      T1]  ? kernfs_create_link+0x61/0xb0
> [    1.708139] [      T1]  ? sysfs_do_create_link_sd+0x81/0xf0
> [    1.708562] [      T1]  call_driver_probe+0x23/0x100
> [    1.708949] [      T1]  ? driver_sysfs_add+0x55/0xc0
> [    1.709334] [      T1]  really_probe+0xd7/0x2d0
> [    1.709681] [      T1]  ? _raw_spin_unlock_irq+0xe/0x30
> [    1.710098] [      T1]  __driver_probe_device+0x9c/0x1b0
> [    1.710503] [      T1]  driver_probe_device+0x1f/0x80
> [    1.710892] [      T1]  ? __pfx___driver_attach+0x10/0x10
> [    1.711323] [      T1]  __driver_attach+0x10a/0x210
> [    1.711706] [      T1]  ? __pfx___driver_attach+0x10/0x10
> [    1.712125] [      T1]  bus_for_each_dev+0x86/0xf0
> [    1.712488] [      T1]  bus_add_driver+0x13e/0x230
> [    1.712858] [      T1]  ? __pfx_xhci_pci_init+0x10/0x10
> [    1.713273] [      T1]  ? __pfx_xhci_pci_init+0x10/0x10
> [    1.713681] [      T1]  driver_register+0x75/0xe0
> [    1.714049] [      T1]  do_one_initcall+0x7a/0x1c0
> [    1.714429] [      T1]  do_initcalls+0xe1/0x100
> [    1.714780] [      T1]  kernel_init_freeable+0x152/0x1c0
> [    1.715199] [      T1]  ? __pfx_kernel_init+0x10/0x10
> [    1.715592] [      T1]  kernel_init+0x1f/0x140
> [    1.715928] [      T1]  ret_from_fork+0x19e/0x270
> [    1.716296] [      T1]  ? __pfx_kernel_init+0x10/0x10
> [    1.716680] [      T1]  ? __pfx_kernel_init+0x10/0x10
> [    1.717071] [      T1]  ret_from_fork_asm+0x1a/0x30
> [    1.717438] [      T1]  </TASK>
> [    1.717663] [      T1] ---[ end trace 0000000000000000 ]---
> """
> 
> This does not happen with latest Linus tree 40288c9206c1 ("Merge tag
> 'drm-fixes-2026-09-19' of https://gitlab.freedesktop.org/drm/kernel").
> 
> What I could determine is:
> 
> - In xhci_alloc_interrupter() max_segs=0, which leds to seg=0
> 
> - This eventually leads to passing size=0 to get_order() in
>   __dma_direct_alloc_pages() (call sequenece below). Passing size=0 to
>   get_order() is undefined and returns order=52 on my guest, whch leads
>   to the warning since 52 > MAX_PAGE_ORDER
> 
>     xhci_alloc_erst()
>       dma_alloc_coherent()
>         dma_alloc_attrs()
>           dma_direct_alloc()
>             __dma_direct_alloc_pages()
>             get_order()
>             alloc_pages_node()
> 
> [1] git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm origin/mm-new
> 

Thanks for the report. From my understanding, it is already
fixed in mainline by 045b5bef916d ("usb: xhci: Fix HCS_ERST_MAX conversion").

Thanks
Best Regards
Hao



