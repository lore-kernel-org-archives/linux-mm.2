Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F128CFD376
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 02:03:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4D576B0010; Sun, 30 Nov 2025 21:03:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C251A6B0011; Sun, 30 Nov 2025 21:03:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B618F6B0012; Sun, 30 Nov 2025 21:03:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A57946B0010
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 21:03:40 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 58C878B08B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 02:03:40 +0000 (UTC)
X-FDA: 84169255800.04.B7D15B1
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0B7C01C0010
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 02:03:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of wozizhi@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=wozizhi@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764554618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=djN32x86ONJ7k07v0KYBxtotR0Wmr5S3RpQ8vF9IShY=;
	b=Y1hkOM2EWjo2NJm9QHZ12R5prirYnJNhdxffEEXtTcdUTVTy60erTr4P8FHoxcvLyW8aCX
	fdCzXSmwTJbnG5SWja6Qd/cIs9xkal4lubjPqHKJGBGxWu2R8daqYNSCZ2nyZpiBpa71m9
	2yR2lCxHYo1yHH2er9fjO+x3bFsidDw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764554618; a=rsa-sha256;
	cv=none;
	b=v8xa5p+jrJQheJiZdEiUFCupKeJ3vqMPcmuRgZNyQkFAzpO6VC1AEwKA0yOCr9uoTQVmhY
	glhsE+Y6RO28KdkgxPdqPp9hfYrkRSztYajTs8vNEVeOgK41e7t3gSJSVOnxIL+MfUkaa3
	Aym/iM7OZdac8YFs+cWZ3WX60ojnw2Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of wozizhi@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=wozizhi@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dKRxb14qZzKHM0J
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 10:02:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id D1C8C1A0F86
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 10:03:28 +0800 (CST)
Received: from [10.174.176.88] (unknown [10.174.176.88])
	by APP2 (Coremail) with SMTP id Syh0CgAnCFJu9yxpwNe4AA--.50055S3;
	Mon, 01 Dec 2025 10:03:28 +0800 (CST)
Message-ID: <60238f31-d896-466b-b53f-604846738fa2@huaweicloud.com>
Date: Mon, 1 Dec 2025 10:03:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
 sleep in RCU context
To: Al Viro <viro@zeniv.linux.org.uk>, Zizhi Wo <wozizhi@huaweicloud.com>
Cc: torvalds@linux-foundation.org, jack@suse.com, brauner@kernel.org,
 hch@lst.de, akpm@linux-foundation.org, linux@armlinux.org.uk,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 yangerkun@huawei.com, wangkefeng.wang@huawei.com, pangliyuan1@huawei.com,
 xieyuanbin1@huawei.com
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <20251126185545.GC3538@ZenIV>
 <c375dd22-8b46-404b-b0c2-815dbd4c5ec8@huaweicloud.com>
 <20251129033728.GH3538@ZenIV>
From: Zizhi Wo <wozizhi@huaweicloud.com>
In-Reply-To: <20251129033728.GH3538@ZenIV>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgAnCFJu9yxpwNe4AA--.50055S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uFykXr4fZr1rGry7Zr1xAFb_yoW8trWUpF
	15Wr17Krs5Gr1xC3Z7Xa129FyrC3s7Jr4rGw1a9asavw1Ygr43WF4YyF43uF129rZYya10
	vr4FyFyDZanYyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvE14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
	evJa73UjIFyTuYvjfUOv38UUUUU
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0B7C01C0010
X-Stat-Signature: 1uydqmo5bqqzezcasyyuyj83yrj166c6
X-Rspam-User: 
X-HE-Tag: 1764554613-649788
X-HE-Meta: U2FsdGVkX188ew0PUbj8W+8iqi0PQG92sj7IJmbjCRSpHoaFclxpn2mSvrpXPNz+M9JsuAswZiaB+U1raVPFDxUa489wpXqnLWZdZTifvAEEynVPa/DTSrpGqKND1oDW+w6ZsanCY0iotjEs+pwTbwPpmOe3iAKnw62R8OYvH3PFZgQNBYjcKKuv0KhTyi9fuhJ62plP4/fRdsp5IKWLtRq6og3MLiIr+TPf5Cj+QREwJAHBUMRSK2mgfhvYiK74UQZeirff+U6NvUWHi3ssVagm2v6LU3xs0hCj1fwQsHO3lAHVC/6xidLFfd6ogjdPPJIR7HbuD3z7mCK1Nd+jbQOqPmukqS+bXp9M39FR95iufz2ganZyGUf0FNTZA9nbAqZhc3s7W+SEAxFtBsF72ZTuHludxr5pZ4mU+jRlj80XBwxVTOJXg2yUqdzQuIo1Xb0V1F8/ETF2tVPJmOmeykkhJIWGectOHxMh6/zKf0SNJ7ulmLaMH6R+m0D0Y1JIulffeNB0myiMuMoRGCrdWFWZ1PIZO6f+qeQV5ICBxqxMRx2+XVsGtRtLUUFyZz1wk5aMFmi4BfDK87KVwOfnI+TGhJW6hvoIXImWmLbf33pW/80z33n9f7cAv/vCePpr2QRmnepnIUCIg+wTHvYxArP+QeCRtXoeOCbNJw+yMFYFtFkyb1RQnrmBUv7Vn1KLDdK4EJLYr7W7gwgdeOofAT2RuIwKM+KqsUDC6UxjLGv80be8GAOvBagTdYKKEvuZvc45ayoXloXIBXKgKZugC15uMmEdKmJX0hdBao6LM0KqWP85L/nd2PCTcQW/zPffZnWmRMTSSdc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/11/29 11:37, Al Viro 写道:
> On Thu, Nov 27, 2025 at 10:24:19AM +0800, Zizhi Wo wrote:
> 
>> Why does x86 have special handling in do_kern_addr_fault(), including
>> logic for vmalloc faults? For example, on CONFIG_X86_32, it still takes
>> the vmalloc_fault path. As noted in the x86 comments, "We can fault-in
>> kernel-space virtual memory on-demand"...
>>
>> But on arm64, I don’t see similar logic — is there a specific reason
>> for this difference? Maybe x86's vmalloc area is mapped lazily, while
>> ARM maps it fully during early boot?
> 
> x86 MMU uses the same register for kernel and userland top-level page
> tables; arm64 MMU has separate page tables for those - TTBR0 and TTBR1
> point to the table to be used for translation, depending upon the bit
> 55 of virtual address.
> 
> vmalloc works with page table of init_mm (see pgd_offset_k() uses in
> there).  On arm64 that's it - TTBR1 is set to that and it stays that way,
> so access to vmalloc'ed area will do the right thing.
> 
> On 32bit x86 you need to propagate the change into top-level page tables
> of every thread.  That's what arch_sync_kernel_mappings() is for; look for
> the calls in mm/vmalloc.c and see the discussion of race in the comment in
> front of x86 vmalloc_fault().  Nothing of that sort is needed of arm64,
> since all threads are using the same page table for kernel part of the
> address space.
> 
> The reason why 64bit x86 doesn't need to bother is different - there we
> fill all relevant top-level page table slots in preallocate_vmalloc_pages()
> before any additional threads could be created.  The pointers in those
> slots are not going to change and they will be propagated to all subsequent
> threads by pgd_alloc(), so the page tables actually modified by vmalloc()
> are shared by all threads.

Thank you very much for your answer. This well explains my confusion!

Thanks,
Zizhi Wo

> 
> AFAICS, 32bit arm is similar to 32bit x86 in that respect; propagation
> is lazier, though - there arch_sync_kernel_mappings() bumps a counter
> in init_mm and context switches use that to check if propagation needs
> to be done.  No idea how well does that work on vfree() side of things -
> hadn't looked into that rabbit hole...
> 


