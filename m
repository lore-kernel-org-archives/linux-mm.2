Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A628C87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 12:43:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1CAE8E000B; Thu, 31 Jul 2025 08:43:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCDD68E0001; Thu, 31 Jul 2025 08:43:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABC408E000B; Thu, 31 Jul 2025 08:43:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9CA278E0001
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:43:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3DD6C56EB4
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:43:17 +0000 (UTC)
X-FDA: 83724525234.19.0D219A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 61C9940005
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:43:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jYXv9noQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753965795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PegHQYmK9Iace/71/vW+nJx5NlAZ7qJdtPNjz/juIbE=;
	b=t+VHFUKP0yJ6Uw9X7EJf2rbOnqiZ3p+fOJnVbMSsSqzv893vqbP/zmM/M4whPGuxRK0YKy
	pLk1FkiClz5i65L340ZXNvsjm3JPWsTMBIYRUJUPSGpbO2dNP6z066RPW9b46Qj/LbOY3n
	LinU0UWwKJoU030dRI6d7qbbqa2AcuU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753965795; a=rsa-sha256;
	cv=none;
	b=ALVMQxVpeTAksKPdFs0bImyaEvRHcJTHUT8+QX8b11pvTgNQHLr3itHRcoJRPWJ230NiJ9
	UOBUzZleMza6U9c0/I2EOk/KqTGLuRrX8k1/2VmsI9InsYf4L0LXXRA3x7eN9ZmKE6c/xV
	MIlWIaxULYTNoLiDBfhqZqeylA6XxNs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jYXv9noQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0099E455E1;
	Thu, 31 Jul 2025 12:43:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EFF0C4CEEF;
	Thu, 31 Jul 2025 12:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753965793;
	bh=zU2lnmtPNsHWFjSPCrOp+d77nUlXESCQQ12CQixJ6qE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jYXv9noQcjCmMhA8KDvWywR1fZrHi/CMT51irphf61VBDXHRi+V8zjzLoQusQTkeS
	 dPINnmi3l7gq7BcjXDYO+IJQgzGHebvtaoQ7B712rhIQv2t0GGO0AdK74rwJUnW4vb
	 pdfLOtcyxoahC6H1UhPinDDweDa+a6K4A+XbXYW4Dgp2OE/mG3hhx4ZFgUQg3DMPJF
	 Zhk14vDtw/uw9jFaKsQnxnrEWYLHj4BWO/Y+M1h5C4wQyfRFHKbqMThqQGLGGu9HXN
	 sOtv8jYHlyIwI2sESh4pfyaRB5oDERbaEZVPf7tCW7Wg/sGd6nY1nrdmSIfCs6u2xk
	 ECnM3A7bQmPQA==
Date: Thu, 31 Jul 2025 08:43:11 -0400
From: Sasha Levin <sashal@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, peterx@redhat.com,
	aarcange@redhat.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/userfaultfd: fix missing PTE unmap for non-migration
 entries
Message-ID: <aItk34ca4Mp6KLUB@lappy>
References: <20250630031958.1225651-1-sashal@kernel.org>
 <20250630175746.e52af129fd2d88deecc25169@linux-foundation.org>
 <a4d8b292-154a-4d14-90e4-6c822acf1cfb@redhat.com>
 <aG06QBVeBJgluSqP@lappy>
 <CAJuCfpH5NQBJMqs9U2VjyA_f6Fho2VAcQq=ORw-iW8qhVCDSuA@mail.gmail.com>
 <aG0_-79QiMEk3N-R@lappy>
 <CAJuCfpF3K49Z8uevF6M9FZX-tFgJDCkCi54iL=xwDuQB2RMqoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpF3K49Z8uevF6M9FZX-tFgJDCkCi54iL=xwDuQB2RMqoA@mail.gmail.com>
X-Stat-Signature: utgzkf3o9ogfbpwuj5npoywftqnsxznr
X-Rspamd-Queue-Id: 61C9940005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753965795-722580
X-HE-Meta: U2FsdGVkX1+Z4lmDV5ENB3rmc2fXA6X6shEZt0as34FUFm/gD8CfVwqhMM4INsha/TA6PIWePk5Xyube5ZBKTHWAi0irxI6K8WjXi5Fer2t+uKgd60upiKMp69W96crJNi2+kQe0wNRRWa0o4LZRR+64bvwCEk3u8ehWidMJvzk7CjHonrucK1m5cvcZ18mFIhfYOlGnoVcTTsyYqK7JN80DFiiRd6Cqbh6u82ZhjTUcDiMejavBP2FTVJ379RC7t3jYXDXpKRQZO1byccPg74qMBd501ePDGYDPEioaQV0urICyWn8fCgKmQXhaLW8FOul4Jkg6/NLK4u2Xb5Zf+ADCJCeWq2sBiFtKy90T2FaGIsQw26D7kKolfmqeSmrc4ClYytXewvAjvCAOTN+WKs/2HBq6aJj3tfdmuUzJQN3qphdL9Ius82ywbqtJ+f8afpx+UGa+iskgt/+bCGy6+7S1U4xr76EjoAKHnhAiS7FrALJQpSb0BKLinfldjiW9A5Toijqg574ERzoR7HfMGcZ6LAB7S8B47ZQA50+HkCCnsBZAMg02xQT0M0q/PHmI28acNeOhL1ATTla/IHQHQA4s0aB/lxzDyS7J+shax/XqK7rHyspp7HjBZCXSZlrc5qyTe5jYCIOdKgWFLICmwxTuSef1eXMWFt3lMB5tcKoTaKDvcAeAM5UBG9Ncgfbl/VsYutbyLdVnJete+YtYYndFEpYMFfG3nbwAXbZwpJISOqFk3IrgNhvyupi93/spUXQemcp0zFBVGlMJOaSfVhYq98D2M2otzwDy0AmRvysS0QIbL9LP0qqwPbUU9/d7RCO23ANfgLWCB6c8nWjfujR8iHMGvL4vYVC3nYdvAK0D2BLdFOhqhwW7VWPU+Pp8xDzbAwpkjAIbbwbGBYQHQVkpcgssUpH3z8BAJGS9fFS6xVQlxWZwgsFOJZynkguRdcF2ktuyKDREktQosj8
 YlEm1IH/
 T7CYw7NlBz2542BuI/i7YTtUcugq/LJkG2LyHyYeNalCjE9OW8b3FaBiWl+YWQVWs7qv+S/1W/sU0RYPNDEKVTqFDtnd9wKPJ0tMRdrPSV4eQnjDjwSxFfuQGjH0tcomdZUTLUH2NojMKeyVeh93Qv3ENzD8ICVpBu0A1w23BGA9W9yW3Ltu/LvBfjUO1HH+T2SfGq1DeqB5bGAVMGeNlRku4mElNST5zhZt469F7KGnBIlS9E7gd94sy9M0DRBaSqTOKR15HIKjQUZZkJCH8YCDVLX7kcxcNwcBz5GlgzopHtGTHQJXuxddk0AGs1vx00o743u5C/vtsTYLgCm24ZFR+32QepWONUEsncfx1+MINO67gHi/LdJfY+KrxCJ9XXtXOur/Zr3hUkJj+tWoqmJEtJbzFAyIL7q7t+uozORhnENPkkENCYhbq+csIHvxovNDmZhgpS1vWtuIcjuNNvFoEtMJkcmadkzhZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 08, 2025 at 09:34:48AM -0700, Suren Baghdasaryan wrote:
>On Tue, Jul 8, 2025 at 8:57 AM Sasha Levin <sashal@kernel.org> wrote:
>>
>> On Tue, Jul 08, 2025 at 08:39:47AM -0700, Suren Baghdasaryan wrote:
>> >On Tue, Jul 8, 2025 at 8:33 AM Sasha Levin <sashal@kernel.org> wrote:
>> >>
>> >> On Tue, Jul 08, 2025 at 05:10:44PM +0200, David Hildenbrand wrote:
>> >> >On 01.07.25 02:57, Andrew Morton wrote:
>> >> >>On Sun, 29 Jun 2025 23:19:58 -0400 Sasha Levin <sashal@kernel.org> wrote:
>> >> >>
>> >> >>>When handling non-swap entries in move_pages_pte(), the error handling
>> >> >>>for entries that are NOT migration entries fails to unmap the page table
>> >> >>>entries before jumping to the error handling label.
>> >> >>>
>> >> >>>This results in a kmap/kunmap imbalance which on CONFIG_HIGHPTE systems
>> >> >>>triggers a WARNING in kunmap_local_indexed() because the kmap stack is
>> >> >>>corrupted.
>> >> >>>
>> >> >>>Example call trace on ARM32 (CONFIG_HIGHPTE enabled):
>> >> >>>   WARNING: CPU: 1 PID: 633 at mm/highmem.c:622 kunmap_local_indexed+0x178/0x17c
>> >> >>>   Call trace:
>> >> >>>     kunmap_local_indexed from move_pages+0x964/0x19f4
>> >> >>>     move_pages from userfaultfd_ioctl+0x129c/0x2144
>> >> >>>     userfaultfd_ioctl from sys_ioctl+0x558/0xd24
>> >> >>>
>> >> >>>The issue was introduced with the UFFDIO_MOVE feature but became more
>> >> >>>frequent with the addition of guard pages (commit 7c53dfbdb024 ("mm: add
>> >> >>>PTE_MARKER_GUARD PTE marker")) which made the non-migration entry code
>> >> >>>path more commonly executed during userfaultfd operations.
>> >> >>>
>> >> >>>Fix this by ensuring PTEs are properly unmapped in all non-swap entry
>> >> >>>paths before jumping to the error handling label, not just for migration
>> >> >>>entries.
>> >> >>
>> >> >>I don't get it.
>> >> >>
>> >> >>>--- a/mm/userfaultfd.c
>> >> >>>+++ b/mm/userfaultfd.c
>> >> >>>@@ -1384,14 +1384,15 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
>> >> >>>             entry = pte_to_swp_entry(orig_src_pte);
>> >> >>>             if (non_swap_entry(entry)) {
>> >> >>>+                    pte_unmap(src_pte);
>> >> >>>+                    pte_unmap(dst_pte);
>> >> >>>+                    src_pte = dst_pte = NULL;
>> >> >>>                     if (is_migration_entry(entry)) {
>> >> >>>-                            pte_unmap(src_pte);
>> >> >>>-                            pte_unmap(dst_pte);
>> >> >>>-                            src_pte = dst_pte = NULL;
>> >> >>>                             migration_entry_wait(mm, src_pmd, src_addr);
>> >> >>>                             err = -EAGAIN;
>> >> >>>-                    } else
>> >> >>>+                    } else {
>> >> >>>                             err = -EFAULT;
>> >> >>>+                    }
>> >> >>>                     goto out;
>> >> >>
>> >> >>where we have
>> >> >>
>> >> >>out:
>> >> >>      ...
>> >> >>      if (dst_pte)
>> >> >>              pte_unmap(dst_pte);
>> >> >>      if (src_pte)
>> >> >>              pte_unmap(src_pte);
>> >> >
>> >> >AI slop?
>> >>
>> >> Nah, this one is sadly all me :(
>> >>
>> >> I was trying to resolve some of the issues found with linus-next on
>> >> LKFT, and misunderstood the code. Funny enough, I thought that the
>> >> change above "fixed" it by making the warnings go away, but clearly is
>> >> the wrong thing to do so I went back to the drawing table...
>> >>
>> >> If you're curious, here's the issue: https://qa-reports.linaro.org/lkft/sashal-linus-next/build/v6.13-rc7-43418-g558c6dd4d863/testrun/29030370/suite/log-parser-test/test/exception-warning-cpu-pid-at-mmhighmem-kunmap_local_indexed/details/
>> >
>> >Any way to symbolize that Call trace? I can't find build artefacts to
>> >extract vmlinux image...
>>
>> The build artifacts are at
>> https://storage.tuxsuite.com/public/linaro/lkft/builds/2zSrTao2x4P640QKIx18JUuFdc1/
>> but I couldn't get it to do the right thing. I'm guessing that I need
>> some magical arm32 toolchain bits that I don't carry:
>>
>> cat tr.txt | ./scripts/decode_stacktrace.sh vmlinux
>> <4>[   38.566145] ------------[ cut here ]------------
>> <4>[ 38.566392] WARNING: CPU: 1 PID: 637 at mm/highmem.c:622 kunmap_local_indexed+0x198/0x1a4
>> <4>[   38.569398] Modules linked in: nfnetlink ip_tables x_tables
>> <4>[   38.570481] CPU: 1 UID: 0 PID: 637 Comm: uffd-unit-tests Not tainted 6.16.0-rc4 #1 NONE
>> <4>[   38.570815] Hardware name: Generic DT based system
>> <4>[   38.571073] Call trace:
>> <4>[ 38.571239] unwind_backtrace from show_stack (arch/arm64/kernel/stacktrace.c:465)
>> <4>[ 38.571602] show_stack from dump_stack_lvl (lib/dump_stack.c:118 (discriminator 1))
>> <4>[ 38.571805] dump_stack_lvl from __warn (kernel/panic.c:791)
>> <4>[ 38.572002] __warn from warn_slowpath_fmt+0xa8/0x174
>> <4>[ 38.572290] warn_slowpath_fmt from kunmap_local_indexed+0x198/0x1a4
>> <4>[ 38.572520] kunmap_local_indexed from move_pages_pte+0xc40/0xf48
>> <4>[ 38.572970] move_pages_pte from move_pages+0x428/0x5bc
>> <4>[ 38.573189] move_pages from userfaultfd_ioctl+0x900/0x1ec0
>> <4>[ 38.573376] userfaultfd_ioctl from sys_ioctl+0xd24/0xd90
>> <4>[ 38.573581] sys_ioctl from ret_fast_syscall+0x0/0x5c
>> <4>[   38.573810] Exception stack(0xf9d69fa8 to 0xf9d69ff0)
>> <4>[   38.574546] 9fa0:                   00001000 00000005 00000005 c028aa05 b2d3ecd8 b2d3ecc8
>> <4>[   38.574919] 9fc0: 00001000 00000005 b2d3ece0 00000036 b2d3ed84 b2d3ed50 b2d3ed7c b2d3ed58
>> <4>[   38.575131] 9fe0: 00000036 b2d3ecb0 b6df1861 b6d5f736
>> <4>[   38.575511] ---[ end trace 0000000000000000 ]---
>
>Ah, I know what's going on. 6.13.rc7 which is used in this test does
>not have my fix 927e926d72d9 ("userfaultfd: fix PTE unmapping
>stack-allocated PTE copies") (see
>https://elixir.bootlin.com/linux/v6.13.7/source/mm/userfaultfd.c#L1284).
>It was backported into 6.13.rc8. So, it tries to unmap a copy of a
>mapped PTE, which will fail when CONFIG_HIGHPTE is enabled. So, it
>makes sense that it is failing on arm32.

Sorry, I've missed this.

The tree only identifies as 6.13-rc7 but in practice it's a much newer
version since it merges in PRs from the ML.

The issue was still reproducing even on v6.16 with 927e926d72d9.

I've sent out https://lore.kernel.org/all/aItjffoR7molh3QF@lappy/ which
fixed the issue for me.

-- 
Thanks,
Sasha

