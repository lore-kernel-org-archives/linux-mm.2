Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DA5CCFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 12:25:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AF926B0011; Fri, 28 Nov 2025 07:25:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7868A6B0012; Fri, 28 Nov 2025 07:25:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69D5F6B002F; Fri, 28 Nov 2025 07:25:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 594FC6B0011
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:25:11 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DAE75140589
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:25:10 +0000 (UTC)
X-FDA: 84159935580.05.70B7BA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id DF8191A000E
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:25:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EFYuo7O6;
	spf=pass (imf19.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764332709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kUOzF3SR4AYKkptzzIkO1KpHc4LaMt9hjccp5my63I4=;
	b=fBzg6ss3r6n+CxSye0F0N7O+sdetGhZbNBDdtUUG8qMl9nrkqzbBXTsF1RLgg478rsHiuM
	YlDg8qStxfIt/rxKgkLTSzq20MxqZk78r/eRqsOQkm1yM6PMpLRW8jhbyrJy5r0P0pi/4d
	XvJgFf2hnUGH++zS8v8mRq5qGhpz60k=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EFYuo7O6;
	spf=pass (imf19.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764332709; a=rsa-sha256;
	cv=none;
	b=us0tx09YF6eLteQExl48ltEBhWPefD4wdTLw7/N0f6RGgDIAWN5MpyWljCMb0eEvhvyNTf
	twdfn1Tog3DhdlxvnoD22CnxIL0ejHvUHygh+OfM8AHheS+Na22N1p33oFiWYsJBnORHCn
	+ECeLG0RVdqUxhJxV3aiFxhB7pOdRjw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D144640467;
	Fri, 28 Nov 2025 12:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA2FC4CEF1;
	Fri, 28 Nov 2025 12:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764332707;
	bh=w//MMNaJ76/6XmuFlJvBo5HIxOMDYwo1z3nrqJzcqPw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EFYuo7O6PCmDiLmkZeeh6nVMNHkwYIYbsLmfcKYnkYNKUATjFpjfTZFq3Q+28KE7g
	 ylt9vg//gd1+4k8VyYXowAEW5KYWTyqqH8fDxCjY7xCdp0JYC8lbiAvqFTPDSDuzVd
	 ZZNkKSnMf7l6FLFaN4UTLygN0pK+cATxNDnYUILy8odb1QsWZhW9MIh21tT3yRxRKR
	 pKfcxYFqWNwThsn7KLBSaNRF1fHII9S2TmQ2dqm3qTKUm2S1BIPmkAq6tPt30ayMfV
	 tVfq4PWAJPQDJP9s/Mj6hQm3sivZGux0EL/3BnsxPBqKy22MZCFiBrON583IqSyDV9
	 Ng7LVaqtx5vZQ==
Date: Fri, 28 Nov 2025 12:25:01 +0000
From: Will Deacon <will@kernel.org>
To: Zizhi Wo <wozizhi@huaweicloud.com>
Cc: jack@suse.com, brauner@kernel.org, hch@lst.de,
	akpm@linux-foundation.org, linux@armlinux.org.uk,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
	yangerkun@huawei.com, wangkefeng.wang@huawei.com,
	pangliyuan1@huawei.com, xieyuanbin1@huawei.com
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
 sleep in RCU context
Message-ID: <aSmUnZZATTn3JD7m@willie-the-truck>
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <aShLKpTBr9akSuUG@willie-the-truck>
 <9ff0d134-2c64-4204-bbac-9fdf0867ac46@huaweicloud.com>
 <39d99c56-3c2f-46bd-933f-2aef69d169f3@huaweicloud.com>
 <61757d05-ffce-476d-9b07-88332e5db1b9@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <61757d05-ffce-476d-9b07-88332e5db1b9@huaweicloud.com>
X-Rspamd-Queue-Id: DF8191A000E
X-Rspamd-Server: rspam02
X-Stat-Signature: gxyu864nyf9ccywdo9ft6ca4g5k77w35
X-Rspam-User: 
X-HE-Tag: 1764332708-678585
X-HE-Meta: U2FsdGVkX19L5OxPRGjmXQXWXEVu40soO3n/pfUFvDHaHuQbVplq106PpBV/zM96iElkWrR/+FaB5dHbUDw46smj7Q1mCI7nBroVLbc8WFapLzrzDgv72VseX2iOfOfjqz87oluITjfI6Os4HtF0SmbBSEsPfUOLrk6JPrgtty1DvtzHN5mif2KGTwIniuSSDxzmKzESuxIoGhZKNcuk+4APya7Wbd01FhfGMQFCyzW2lbss9KPp/dGfqsJzECK9ZuRFegHLUnjcVVAiiSUc1ydk5kdHZheZbxflDJHEw9EluSBWzMDkOijd1dBKqu8zmQfh5wuhh+QaGTnPGlX5O6ZydicOkL43S+PH9fjDxxAgiUSXpdn9XsEGrzwQFZUxSnFY7MCo2NeHATf2kBa6v+mfXVixEPEArtu2CLbrLsT/tChgCWc2qbHxUwM6dWNuFKEr9Vfw/L/1+jbw1C+xSGnFiRum+TUwLDuWG5UD5JL0Od/4fskQSg1Om4W+P3cWCEPjZw4O02wN92jUENi37NMBuFELHoL+2ThbMzHsIWLSnlTYEWAWBAeJnMAhFWnaX8uLT8A5Wzd/yFiGPZqars/e6tLpVelutSg+19xLn0OPZFGfou2PZNb/QaxbnyEeT9ekOf3+g21FZczvT2NeF9ZmL74Uh0U/SQbjyZEWz9FdIWr5Cu/i//kbywjt+QXY2N/E89CXkSXzhuzVchTVa/VpNF0AougZWQ1qlmmcCF3rZfrayrFVueY1b7JoGrnUpAuf806wjs0x49KXeRTkvZSrWL4uPIgYKey6sRcDTXIryfQKg1RPJx+yEURm2vha4HDxebWdVQnRBq7R1LrA2S69pwr7i8Wh6HAUaWNqP5yuleawH3+ekEPizfQIdV+bZkeGPp0ccQx4xHLenr+mb3cCfd2u+FXZgxbkqP8KE59h+wEa8ncBxP9nqHuCxJNQEjaqq+bkjGtRFdk7Hic
 gT4ZK3ZF
 JQyErFZhK9ZqPknO+GV3nckk5Nn+QfqJ4gWoxAqLCDBB+yFdiPFBpuAA6ZNmGj9Or5Yv+GvU6ZW935ZybnmUrtNagik//5Umye/WzdcV2iU5OaF4mYkMwjKyyMT3xawGU7KNL4Wuw3vpXINq6/PZ3vtQAWEa1Ul6jXPWCPtYnDgNYev94g5aG8Z3yKkLdY4/9sasxi9ZbTG0vMqJb1ZJ7wENjrABaa1Ql+TOlUgGaY7l3G+ftZKJsBXEYQArVAyKB5+rS8MBkOU3TUDkfymu372vG0ev4ZTCdgu4/kE/ZQ4Dsxr55N4xppbzZJ/M765xtQMT4T/bF/UrkvmE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 09:39:45AM +0800, Zizhi Wo wrote:
> 在 2025/11/28 9:18, Zizhi Wo 写道:
> > 在 2025/11/28 9:17, Zizhi Wo 写道:
> > > 在 2025/11/27 20:59, Will Deacon 写道:
> > > > On Wed, Nov 26, 2025 at 05:05:05PM +0800, Zizhi Wo wrote:
> > > > > We're running into the following issue on an ARM32 platform
> > > > > with the linux
> > > > > 5.10 kernel:
> > > > > 
> > > > > [<c0300b78>] (__dabt_svc) from [<c0529cb8>]
> > > > > (link_path_walk.part.7+0x108/0x45c)
> > > > > [<c0529cb8>] (link_path_walk.part.7) from [<c052a948>]
> > > > > (path_openat+0xc4/0x10ec)
> > > > > [<c052a948>] (path_openat) from [<c052cf90>] (do_filp_open+0x9c/0x114)
> > > > > [<c052cf90>] (do_filp_open) from [<c0511e4c>]
> > > > > (do_sys_openat2+0x418/0x528)
> > > > > [<c0511e4c>] (do_sys_openat2) from [<c0513d98>] (do_sys_open+0x88/0xe4)
> > > > > [<c0513d98>] (do_sys_open) from [<c03000c0>]
> > > > > (ret_fast_syscall+0x0/0x58)
> > > > > ...
> > > > > [<c0315e34>] (unwind_backtrace) from [<c030f2b0>]
> > > > > (show_stack+0x20/0x24)
> > > > > [<c030f2b0>] (show_stack) from [<c14239f4>] (dump_stack+0xd8/0xf8)
> > > > > [<c14239f4>] (dump_stack) from [<c038d188>]
> > > > > (___might_sleep+0x19c/0x1e4)
> > > > > [<c038d188>] (___might_sleep) from [<c031b6fc>]
> > > > > (do_page_fault+0x2f8/0x51c)
> > > > > [<c031b6fc>] (do_page_fault) from [<c031bb44>]
> > > > > (do_DataAbort+0x90/0x118)
> > > > > [<c031bb44>] (do_DataAbort) from [<c0300b78>] (__dabt_svc+0x58/0x80)
> > > > > ...
> > > > > 
> > > > > During the execution of
> > > > > hash_name()->load_unaligned_zeropad(), a potential
> > > > > memory access beyond the PAGE boundary may occur. For example, when the
> > > > > filename length is near the PAGE_SIZE boundary. This
> > > > > triggers a page fault,
> > > > > which leads to a call to
> > > > > do_page_fault()->mmap_read_trylock(). If we can't
> > > > > acquire the lock, we have to fall back to the
> > > > > mmap_read_lock() path, which
> > > > > calls might_sleep(). This breaks RCU semantics because path
> > > > > lookup occurs
> > > > > under an RCU read-side critical section. In linux-mainline, arm/arm64
> > > > > do_page_fault() still has this problem:
> > > > > 
> > > > > lock_mm_and_find_vma->get_mmap_lock_carefully->mmap_read_lock_killable.
> > > > > 
> > > > > And before commit bfcfaa77bdf0 ("vfs: use 'unsigned long' accesses for
> > > > > dcache name comparison and hashing"), hash_name accessed the
> > > > > name byte by
> > > > > byte.
> > > > > 
> > > > > To prevent load_unaligned_zeropad() from accessing beyond
> > > > > the valid memory
> > > > > region, we would need to intercept such cases beforehand? But doing so
> > > > > would require replicating the internal logic of
> > > > > load_unaligned_zeropad(),
> > > > > including handling endianness and constructing the correct
> > > > > value manually.
> > > > > Given that load_unaligned_zeropad() is used in many places across the
> > > > > kernel, we currently haven't found a good solution to
> > > > > address this cleanly.
> > > > > 
> > > > > What would be the recommended way to handle this situation? Would
> > > > > appreciate any feedback and guidance from the community. Thanks!
> > > > 
> > > > Does it help if you bodge the translation fault handler along the lines
> > > > of the untested diff below?
> 
> I tried it out and it works — thank you for the solution you provided.

Thanks for giving it a spin.

> At the same time, since I’m a beginner in this area, I’d like to ask a
> question.
> 
> The comment above do_translation_fault() says:
> “We enter here because the first level page table doesn't contain a
> valid entry for the address.”
> 
> However, after modifying the code, it seems that when encountering
> FSR_FS_INVALID_PAGE, the kernel no longer creates a page table entry,
> but instead directly jumps to bad_area.

FSR_FS_INVALID_PAGE indicates a last level translation fault (that's the
"page" part) so it's only applicable in the case where the other levels
of page-table have been populated already.

I wondered about checking !is_vmalloc_addr() too, but I couldn't
convince myself that load_unaligned_zeropad() is only ever used with the
linear map.

> I'd like to ask — could this change potentially cause any other side
> effects?

There's always the possibility but I personally think it's more
self-contained than the other patches doing the rounds. For example, I
don't make any changes to the permission fault handling path.

Will

