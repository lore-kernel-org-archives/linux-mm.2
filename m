Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 351A61088E67
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 03:09:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E3B66B03B8; Wed, 18 Mar 2026 23:09:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76DB26B03BA; Wed, 18 Mar 2026 23:09:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6350A6B03BB; Wed, 18 Mar 2026 23:09:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F80F6B03B8
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:09:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E08DE13A7B5
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:09:26 +0000 (UTC)
X-FDA: 84561331932.19.5E17636
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 798A9120013
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:09:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NwIljfUc;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773889765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bZybTTbg8AAvyS6cqk7gUlRWFfSkSvTu+/1JIIo5e2U=;
	b=8QyFFIKMils+l3YFVGxtCW0F2tJTSVSQa+n6wGffd2ZRkY8Ik74rtP3a8/nBF8SjvLYuL/
	vv/BiLnbnh5KwVxZIl555yWRKdHcW951am3jWJgHnfgcsoMwQIntaRAkUaYlbT59pvcAwv
	l3aKTzkDpb/dl+5x96B38R1Rg1xPNnM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773889765; a=rsa-sha256;
	cv=none;
	b=sC3B6vrvfeJaSeBE4gzrgqz5Nm6I9Y9glhYmAbvj5nOZGRWae/aaaghf6+5dSnoupy7LbJ
	yJccnz0bwAr0jbJdYBYwNFebNqm3HTSSDKnBiCdw8TvqnYOWZJrie5Y60JyCiYTk/o3MMf
	X0mCUhg2wZk4violw0Zfl7TYc64vd3Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NwIljfUc;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773889761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bZybTTbg8AAvyS6cqk7gUlRWFfSkSvTu+/1JIIo5e2U=;
	b=NwIljfUcwu6sWUozpAHmhTLmjRPC8kVCnJYqYcu/eAoNJQz5EuDf8KNK0ijl9aGEmcGs38
	6v5lDGQAqcd0lyC0J2RAmaKqHkieu6iLqAjUYtJt5stIfbKbB5gn3XxnR5VcmvTW5OYhWW
	jBcAYtFOlHSH1aJB3NrPSqfoesEQJvo=
From: Lance Yang <lance.yang@linux.dev>
To: ljs@kernel.org
Cc: syzbot+de14f7701c22477db718@syzkaller.appspotmail.com,
	Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	syzkaller-bugs@googlegroups.com,
	ziy@nvidia.com,
	rppt@kernel.org,
	harry.yoo@oracle.com
Subject: Re: [syzbot] [mm?] general protection fault in zap_huge_pmd
Date: Thu, 19 Mar 2026 11:09:14 +0800
Message-Id: <20260319030914.12034-1-lance.yang@linux.dev>
In-Reply-To: <6b3d7ad7-49e1-407a-903d-3103704160d8@lucifer.local>
References: <6b3d7ad7-49e1-407a-903d-3103704160d8@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 798A9120013
X-Stat-Signature: i6cuj5uesomwi886oidar1kdidyqd4tu
X-HE-Tag: 1773889763-297946
X-HE-Meta: U2FsdGVkX18VpvY/UzXhra73XU/wVYDpnJ2MUQLG5PkTHal/LZ20+0KeE9uOEmZ/sbGIREvVbpVCALPpSqyJzVkCIuqDwX/ByBH01ZYlLcnCizUCxhqJUAnysNKH9o3D10QBIr3DsOnQFc2Ful6SXez95LGWWfzky2gs4BzrgPBf/DTv7cnTcivhdEuH0xzVH1/IImu1UIwPvELG0vyDow4i24cHXBEYN20KvmY7juWeXor2n7kt3fkBN85nBJZS5RXkrwKvh9LmQlsxyR6mGUcM4b1fgzLUZkufkMCz5vWCKYj8JNDlv7NLuQ72VzAudyrnomaWhFq7oG/EEjpykqgUm44nQeHay7kUctYpt39vSiV6urR2iXaxnKipRUk4X7+bM/VGe7Bsn/+ZlDs6uMhMzyhHYqkmfKWk2s7cO2W0sqjMtR4CbWlpDxYMKNQGVMyOsizXuoH8qrCfdmXzxfTK43T3xMMU1dXIqHgHEcN1UrY2NGHjiCNW4o1/GgjsPHwnmHek2sZsFvmr7xbnfE+H3Bq9H4sfJ8XeiLSuWW4Kwsq/VM+0u+eotWzQmRIZXAxic3dAlwphlAfQcWupdLdzuy/EXSGmboQL3r6xtmoNydrKuguxxAHSsNROSX96DkCFL52s9A7BKjGSrInxUxfomvT+qp8d/I0RsmEbgN+BFEty70vTdxyGPXu3uZEPDe7eBXegvIB4UpZNOYrxKZv0dMwEgDW/IeL9aNyFog7pYRF8Vrm9KsmrPzWPnmSwxJexGpM6PPbUaomoFgJTNRwCLaJyt4h8E55bQCac7VdNRJtKygMhjZ2qF+qffM8SFTXtWjkwM+7XO4xpJronl6wpfJzir1YFhcr9noqNJjfPovu+u6FKlxZmg3OjZLXfZXMD54rehkWqisXU3Z9bcy9CD88tvRHi9VNZXaCBakevUFAZBChWSqyBm+VVBkY1xEtzPTZOouJIXwV8mfs
 EUrYUFx/
 OPjE0Ldoe4lfXp0B5qX3vJRKuPD5rHpYIS5nvoMaMwI9jp3epmRzm+3PVlG4SeAa7/+F0m1BNKgftnJSrSyVUO/WSk54rmhE8Mv3AwYsbfyc63juEz+OUPZSjackXz0foD8HPebYGs/J6o4A3TJ7Nn/U3piBovb7Kqy0v0ZPk+oiT3NAGELKnK1nxqt1BP8316yDSwTnTAo7cz6S/nYDNNSTKP2Eh2wOUjzhlrUd7qUErMny2N8yEqY/JeO2nrLfUOpQr3q3c4nM7u3vChtZufx9qzZY2dcFMViE29iJdd9HE3SMpVI6dsVxq+5o1st06maHuI6yLwMJ7HKW7srqsfisaAc9Ck5h6drDwoqMPfDUUjkweb8M3tsPylpm7sFy1fPbsxW4aQN1/aq+gxEQ1AjyVWu4BltfGJLuSGCOGcitA0AyJyQZuMjYLIiAFxqSLj8WKaFfqkNXRQCtk2Y/6LdANejmAIGQovwyQgXCCUWQVu4qt6KwKMpXwppo36qt82qG1YlQ0RhnDtmXUN5hPEpl+R2ww41edOLI43G505pz9tvZyAQ8yiefoaDgf26k8HuINGF8u5kU1IxMR9vQ+ddpCXCIwaqIxjECkN+FOXszJ3O52za6lW5UwEjRBk8aH9yckAZBwTUz2jqDKBM+p3dpm9IYPcqMs2lnxMdODrfrHhYNwb/mLR0OA6tbmL8zbirVHHCKjelxpm9nrM/9DHbj4xMx0MpV4j1z/fl/YZAtwk/wRtZ8ThwvfOOk2dNKBsYwhScUZx/v0J6H/tsO9nCwW7IYlU7NQU8SnY8IukTMOIxVVdhcEikk1tLiTrEUu9tF2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Mar 18, 2026 at 05:26:32PM +0000, Lorenzo Stoakes (Oracle) wrote:
>+cc Mike for uffd, Harry for fix that also resolves this, see below
>
>On Wed, Mar 18, 2026 at 08:03:22AM -0700, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    b84a0ebe421c Add linux-next specific files for 20260313
>
>For some reason I have to git pull --tags to get this... commit hash locally?
>Strange.
>
>> git tree:       linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=119ddd52580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=e7280ad1f68b2dce
>> dashboard link: https://syzkaller.appspot.com/bug?extid=de14f7701c22477db718
>> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=173b44da580000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1537b8da580000
>
>@SYZKALLER guys:
>
>Note: the repro is incorrectly labelling;
>
>  //  ioctl$UFFDIO_CONTINUE arguments: [
>  //    fd: fd_uffd (resource)
>  //    cmd: const = 0xc020aa08 (4 bytes)
>
>as UFFDIO_CONTINUE (0x7), it's actually UFFDIO_POISION (0x8) as you can see
>from least-significant byte.

#define _UFFDIO_CONTINUE		(0x07)
#define _UFFDIO_POISON			(0x08)

Ouch. I spent quite some time trying to figure out how UFFDIO_CONTINUE
could possibly install PTE markers and push the loop past the VMA
boundary - turns out it can't, because it was UFFDIO_POISON all along.

>
>It's also stating things like mmap flags wrong e.g.:
>
>      /*flags=MAP_UNINITIALIZED|MAP_POPULATE|MAP_NORESERVE|MAP_NONBLOCK|MAP_HUGETLB|0x8c4b815a506002b2*/
>      0x8c4b815a5465c2b2ul,
>
>AT LEAST MAKE THE NUMBERS MATCH :) this doesn't help with debugging.
>
>AI hallucinations?
>
>It also never returns with an error if a syscall doesn't work which means the
>repro can run 'ok' but actually be failing on something, this really slows down repro'ing.
>
>Maybe hard, but be good to figure out maintainers based on the stuff the repro
>uses uffd -> uffd entry in MAINTAINERS :)
>
>OK rants done :) got it repro'ing locally now.
>
>>
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/09145161a8a9/disk-b84a0ebe.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/b64c254e474c/vmlinux-b84a0ebe.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/a7c33f5f7f45/bzImage-b84a0ebe.xz
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+de14f7701c22477db718@syzkaller.appspotmail.com
>>
>> Oops: general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] SMP KASAN PTI
>> KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
>> CPU: 1 UID: 0 PID: 5994 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full)
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
>> RIP: 0010:folio_test_anon include/linux/page-flags.h:718 [inline]
>
>static __always_inline bool folio_test_anon(const struct folio *folio)
>{
>	return ((unsigned long)folio->mapping & FOLIO_MAPPING_ANON) != 0; <-- NULL folio
>}
>
>
>> RIP: 0010:zap_huge_pmd+0x7b1/0x1030 mm/huge_memory.c:2463
>
>int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>		 pmd_t *pmd, unsigned long addr)
>{
>	...
>
>	if (!vma_is_dax(vma) && vma_is_special_huge(vma)) {
>		...
>	} else if (is_huge_zero_pmd(orig_pmd)) {
>		...
>	} else {
>		struct folio *folio = NULL;
>
>		...
>
>		if (pmd_present(orig_pmd)) {
>			...
>		} else if (pmd_is_valid_softleaf(orig_pmd)) {
>			...
>		}
>
>		if (folio_test_anon(folio)) { <-- if !pmd_present() && !pmd_is_valid_softleaf(orig_pmd)
>
>Yikes. We should probably put an } else { VM_WARN_ON_ONCE(1); } at least above
>this...
>
>
>
>
>> Code: 08 00 00 e8 11 e0 92 ff 48 c7 44 24 10 00 00 00 00 4c 8b 3c 24 4c 8d 75 18 4c 89 f0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 4c 89 f7 e8 f1 43 fc ff 49 8b 1e 48 89 de 48 83
>> RSP: 0018:ffffc90003bb7550 EFLAGS: 00010206
>> RAX: 0000000000000003 RBX: f000000000000000 RCX: dffffc0000000000
>> RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0000000000000003
>> RBP: 0000000000000000 R08: ffff88807cc9802f R09: 1ffff1100f993005
>> R10: dffffc0000000000 R11: ffffed100f993006 R12: ffff88807cc98028
>> R13: fffffffffffffa00 R14: 0000000000000018 R15: ffffc90003bb7ac0
>> FS:  0000000000000000(0000) GS:ffff888124ee0000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00002000000000c0 CR3: 000000000e94a000 CR4: 00000000003526f0
>> Call Trace:
>>  <TASK>
>>  zap_pmd_range mm/memory.c:1990 [inline]
>
>			else if (zap_huge_pmd(tlb, vma, pmd, addr)) { <-- here
>
>>  zap_pud_range mm/memory.c:2032 [inline]
>>  zap_p4d_range mm/memory.c:2053 [inline]
>>  __zap_vma_range+0xa82/0x4bd0 mm/memory.c:2093
>>  unmap_vmas+0x379/0x530 mm/memory.c:2162
>>  exit_mmap+0x280/0xa10 mm/mmap.c:1302
>>  __mmput+0x118/0x430 kernel/fork.c:1180
>>  exit_mm+0x18e/0x250 kernel/exit.c:581
>>  do_exit+0x8b9/0x2490 kernel/exit.c:962
>>  do_group_exit+0x21b/0x2d0 kernel/exit.c:1116
>>  __do_sys_exit_group kernel/exit.c:1127 [inline]
>>  __se_sys_exit_group kernel/exit.c:1125 [inline]
>>  __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1125
>>  x64_sys_call+0x221a/0x2240 arch/x86/include/generated/asm/syscalls_64.h:232
>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
>So this is on process teardown.
>
>Looking at the repro (+ trying to decode what it ACTUALLY does :) it looks like
>it's installing a PTE_MARKER_POISONED at a PMD level via hugetlb, because since
>commit 8a13897fb0da ("mm: userfaultfd: support UFFDIO_POISON for hugetlbfs")
>this is supported.
>
>Normally this would be handled by __unmap_hugepage_range():
>
>	if (unlikely(is_vm_hugetlb_page(vma))) {
>		...
>		__unmap_hugepage_range(tlb, vma, start, end, NULL, zap_flags);
>	} else {
>		...
>		next = zap_p4d_range(tlb, vma, pgd, addr, next, details);
>	}
>
>But for some reason the zap_p4d_range() path is being used.
>
>I got a the repro reliably working locally (not sure why syzkaller didn't
>bisect) so I have bisected it to commit 7d4d4de3ac3e ("userfaultfd: introduce
>mfill_get_vma() and mfill_put_vma()").
>
>And.. of course, after spending (wasting? :) a long time on this, it's already
>fixed...
>
>It seems it's fixed by https://lore.kernel.org/linux-mm/abehBY7QakYF9bK4@hyeyoo/
>
>Before mfill_atomic() would initialise some mfill_state helper struct like this:
>
>	struct mfill_state state = (struct mfill_state){
>		.ctx = ctx,
>		.dst_start = dst_start,
>		.src_start = src_start,
>		.flags = flags,
>
>		.src_addr = src_start,
>		.dst_addr = dst_start,
>	};
>
>BUT not initialise .len = len
>
>So length from then on is assumed to be 0.
>
>OK so the repro, again, generates TOTALLY incorrect labelling:
>
>  //  ioctl$UFFDIO_CONTINUE arguments: [
>  //    fd: fd_uffd (resource)
>  //    cmd: const = 0xc020aa08 (4 bytes)
>  //    arg: ptr[in, uffdio_continue] {
>  //      uffdio_continue {
>  //        range: uffdio_range {
>  //          start: VMA[0xc00000]
>  //          len: len = 0xc00000 (8 bytes)
>  //        }
>  //        mode: uffdio_continue_mode = 0x0 (8 bytes)
>  //        mapped: int64 = 0x0 (8 bytes)
>  //      }
>  //    }
>  //  ]
>  *(uint64_t*)0x200000000280 = 0x200000400000;
>  *(uint64_t*)0x200000000288 = 0xc00000;
>  *(uint64_t*)0x200000000290 = 0;
>  syscall(__NR_ioctl, /*fd=*/r[0], /*cmd=*/0xc020aa08,
>          /*arg=*/0x200000000280ul);
>
>In reality this is:
>
>  struct uffdio_poison poison = {
>      .range = {
>          .start = 0x200000400000,
>          .len   = 0xc00000,         /* 12MB */
>      },
>      .mode = 0,
>  };
>
>(!!!)
>
>Which in the kernel calls
>
>userfaultfd_ioctl()
>-> userfaultfd_poison()
>-> validate_range() -> validate_unaligned_range() <-- would ordinarily reject 0 len!!
>-> mfill_atomic_poison()
>-> mfill_atomic() [ hits bug]
>-> mfill_get_vma()
>-> uffd_mfill_lock(..., len=0!)
>
>static struct vm_area_struct *uffd_mfill_lock(struct mm_struct *dst_mm,
>					      unsigned long dst_start,
>					      unsigned long len)
>{
>	struct vm_area_struct *dst_vma;
>
>	dst_vma = uffd_lock_vma(dst_mm, dst_start);
>	if (IS_ERR(dst_vma) || validate_dst_vma(dst_vma, dst_start + len))
>		return dst_vma;
>}
>
>Here validate_dst_vma() succeeds trivially as len is 0
>
>BUT. The rest of mfill_atomic() uses len, not state.len.
>
>So this results in ONLY the validation check using the bogus len=0, and works
>with a 12MB size.
>
>Note that in the repro, we try to map a hugetlb VMA of (weirdly) 9.36 MB.
>
>Because we align the hugetlb and round it up from this to 10mb we get VMAs like:
>
>  0x1ffffffff000                          0x200000a00000                    0x200001001000
>  |---------|------------------------------|-----------------------|---------|
>  |1pg none |  2560 pages (10 MB) hugetlb  | 1535 pages (6MB) WRX  | 1pg none|
>  |---------|------------------------------|-----------------------|---------|
>            0x200000000000                                         0x200001000000
>
>Because of the len bug, we happily try to install poison markers into 2 MB of
>the 1535 page anon WRX region which is not hugetlb and then BOOM.
>
>So Harry's fix resolves this, but we should handle this case better in
>zap_huge_pmd(), I will send a patch for that.
>

Thanks for the thorough analysis Lorenzo!

