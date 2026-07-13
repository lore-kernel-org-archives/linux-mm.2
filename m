Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63E8CC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D08836B0143; Mon, 13 Jul 2026 12:37:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB94D6B0144; Mon, 13 Jul 2026 12:37:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B32A46B0145; Mon, 13 Jul 2026 12:37:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 70BF06B0143
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:37:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EA4BD168BC7
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:08:19 +0000 (UTC)
X-FDA: 84983933118.21.20B9848
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1BD3E1C000C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:08:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eTt5PD3q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YMo3CArHIMSc5mQm9D+dmTD7MKJgdtYxb1IXd5HlBzI=;
	b=mklEpug6NquloRjm+Z0Z4cK/2+vfCWi47J8JSQM/8N4Z5UaXUljferCAdFQ+ev0g8BVrYD
	2plU7GS3thOR4H3jTsPiZwwFSvEIk+9/fKh8D256klGec9CqA7J1oILeBxK1sKXa9wYImu
	dmE88VsBaL1RbdPE8GaRPSMxpLtRWX8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eTt5PD3q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951698;
	b=2GBsD0AQsfX3cqmd3PzcSSccDIXMVWAqzDVzgtJmltswuhUknsuGJ7AqApC1JiUfX8rLou
	tlYxDLADnOT6c47tQndSfhKXmz4DL0vw8x4jSbFT5GtuR+gCreZZx52qr0PxnGfFqUHZS2
	c+z7MqUq2PWYj1U3RrYIGpD9fvIWo4g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 29EA4411AC;
	Mon, 13 Jul 2026 14:08:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14C41F000E9;
	Mon, 13 Jul 2026 14:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783951697;
	bh=YMo3CArHIMSc5mQm9D+dmTD7MKJgdtYxb1IXd5HlBzI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eTt5PD3qX+gV8oN2bQfrKTUXG12fxCb2g8CCJ0RIs1IiAXdScPRGHEVzNqCUF0EfF
	 vn9AtTcQJyeVFLHiyS7TT/pFwdLkp/l21H6gQj6rLcUlQa8Cl7GfkO28ct04G4EOe1
	 pWvqtGdg5v6MOlhNaycZkX+TOrDab5/XHcuj96jTgwxHB3+oCLbNVMbENuWyb5AiCr
	 SNdjyF9uxlFht1HGGXwbyNWFZNOk2a1iHA8wqQ5rWSxKfIqPAmhCrbvrmmPeFd+3zV
	 cH1u3llfUenlu/FzNNlHHXUElF83E+C+K4Gl2pAlKRdjvZRDtq+WYe7cqMnKCuJg/U
	 +PbBMsRZLGZTw==
Message-ID: <3420eb9b-2523-4a6e-bc49-d6fcbe5cfda0@kernel.org>
Date: Mon, 13 Jul 2026 16:08:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/34] mm: optimize unnecessary loads due to
 ptep_get() and friends out
To: Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-arch@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 x86@kernel.org, linux-mm@kvack.org, kasan-dev@googlegroups.com,
 linux-csky@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
 linux-openrisc@vger.kernel.org
Cc: linux@armlinux.org.uk, akpm@linux-foundation.org,
 ankur.a.arora@oracle.com, rppt@kernel.org, linmag7@gmail.com,
 chleroy@kernel.org, klarasmodin@gmail.com, chenhuacai@kernel.org,
 kernel@xen0n.name, kas@kernel.org, zhangtianyang@loongson.cn,
 wangyuli@aosc.io, tsbogend@alpha.franken.de, ljs@kernel.org, jgg@ziepe.ca,
 catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de,
 ryan.roberts@arm.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com,
 baolin.wang@linux.alibaba.com, tj@kernel.org, kevin.brodsky@arm.com,
 anup@brainfault.org, atish.patra@linux.dev, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
 hannes@cmpxchg.org, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, kasong@tencent.com, baohua@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
 dvyukov@google.com, vincenzo.frascino@arm.com, anshuman.khandual@arm.com,
 yang@os.amperecomputing.com, chaitanyas.prakash@arm.com, ardb@kernel.org,
 guoren@kernel.org, yang.li85200@gmail.com, viro@zeniv.linux.org.uk,
 dinguyen@kernel.org, schuster.simon@siemens-energy.com,
 wangruikang@iscas.ac.cn, junhui.liu@pigmoral.tech, muchun.song@linux.dev,
 vishal.moola@gmail.com, namcao@linutronix.de, pavel@kernel.org,
 djbw@kernel.org, yu-cheng.yu@intel.com, baolu.lu@linux.intel.com,
 Jonathan.Cameron@huawei.com, coxu@redhat.com, andreas@gaisler.com,
 liam@infradead.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 geert@linux-m68k.org, shorne@gmail.com, jonas@southpole.se,
 stefan.kristiansson@saunalahti.fi
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4epgfhp6mrsg5m6nnu8y19i6js65wdzh
X-Rspamd-Queue-Id: 1BD3E1C000C
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783951697-135029
X-HE-Meta: U2FsdGVkX1/JTaHTRMVLlTp/wPZyrkNN0p8lNA1A+bWgCFdC82+7WmHMnkOIeZmetIG9Oc2Yi1yA06EMlPqsWEVO/xEvCZZLAtFTxt5ueR9u/sNjeLmUn4eCYevkzgqV1BBDWgXrNRigZLr1gRp+j/ad6zvMpxTb+W/pQnhzyPeknUN0ctEKrCOuGSbY5Yd5N+sYFQJqeCszfp9g4SPPH9bya2lCfmOJ2TXD4EJ6fnljMNuF4ys5BiA8zY4QCftKxEcVxsGpjWrGZZbrRk4IFN57c2mrJ0k7jUqACwTJaulhlUTJQyse7Ma1QXb9xDKZ5T1la3yFEViNIc0wY9Zj2d/FZsMLngp+gjnRDR6MboEQ15hyTGrx8v9GO4EJ6ctVF+UI11191X9hIBhmSVIDUAsF8Z/L61SkPi7wJzEJx0cCd5vtJShOFtkHtABxOt3BCeaegBnDFIsaO+ivEMVZJeqb4s1bGk3yLbJXN46lcDkHc7BzxsYQeHXmScdrXDJ9q3/1T9hDX5FKmmIkuhLiOn4+Vi3ILxvROaFzJ8cktuovbBN5CYBk4Cckd9ePllyc+MGpCG+iNykKyks4YQCeWuW/Td//Op4xAviIaVfkJBUs8hTd8M5x9FZIVrAbKmI0261rIkXH8rgD/ob7O0vW+1BDNAjHlqczNAUcn5BpSPAX4E7qarIyfYpkTNvGywvOa8XYYb4JmHBwgHxowj0jKkuCs3i5WXsFIN95VHduRhiFlcCBYKn+qQyp+0U2t/Y66Mr6HpdvUz+AGY1MKDNbtDna0vm8pZc8cHk0BIDfqCnRaLNEwyBrni+sg8bIxwlCgTLGeT+zzjtxuQENX7dMby9h8D4fvahaT4ODYp1gqw1DOUtztpNMdijxRRLNtESoKFW0Q+7WDTJElCmJrTaLW0izspan/310QNFpNKbLlj6IyQfrix/k7WqndM7IXHROzP8z4T6wgWsUd2SKU2J
 ZstueEem
 Qfw5kwn9msVl7GWPx1E1qDDAZirL89735CDMgdN1RD9PXAND/p/MLl3j5Ez0+yPQKCFXK8jo13+HzSWri6VQhNS6HbaqYTpE1mHWpMIwuh8J6JAGGsXfpE2nF4KbGZMy7O/tZgz/x2rsUs81E6+eBKJ+jyZdLyMF4GWb8ojd7VP2uY69ZOYFy23en95KJRoyVvZ9e2Xryrs15+kUfGyO1g1cN0zgiFFvqUOTyazqdXmMK31SGMYi3dDe87vYbZ097yqUWWG1/OwSdIKqwwIH/DNQ/VKSnaIoLwGh7JafzeYDXDOl6bFrbCNwfZZNaALK1FFaNrk7Rs6CbrcvWbNOltTHsk7/+1eQraoB9ZRoU23d/MvzkpK3LbqMY1sBkpIsef2tO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> Future work
> ===========
>  - print_bad_page_map() and show_pte() still prints dummy values
>    instead of printing the same content for all generic compile-time
>    folded page tables. We might want to skip printing dummy values later.
> 
>  - We currently catch abuse of dummy values on the stack at compile-time by
>    relying on constant propagation by the compiler. Usama's work [3] on using
>    distinct types for sw vs. hw PTEs could help here as well."

Just adding here that this series was excessively build tested (both by me +
Yeoreum and the friendly build bots), and primarily tested on arm64 only so far
with differing page table level configurations.

There is the chance that there might still be some odd configs that reveal
set_pgd() etc places to rework: so the build bots better should chew some more
on this.

I want to do some more testing, especially on x86 (32bit), but did not get to it
yet.

-- 
Cheers,

David

