Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D56BCD98E2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 09:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 890136B00C8; Thu, 18 Jun 2026 05:29:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8409F6B00CC; Thu, 18 Jun 2026 05:29:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 708AB6B00CD; Thu, 18 Jun 2026 05:29:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8E5D6B00C8
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 05:29:35 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E8FF5140614
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:21:41 +0000 (UTC)
X-FDA: 84892490802.26.735C742
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf11.hostedemail.com (Postfix) with ESMTP id 90CE24000A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:21:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=kYQys+nb;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781774500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=sVRX8cTCVrBcWN6MBvdM8+S6tRfy0PKW4NWctKlaZS4=;
	b=dm7UJKCe27s7DWEfr6nDti1MjR7LkZertB+VNWIRxTj3H4dUc0Fk1nAu5qGnzcj1DYJeHH
	oq6xZ5TriSxNmUK/oOXXcCeJ5TWodktRqBweMG+uRjRRn1jzGZMNNBx0hiZobzZHAzUl9E
	Hu6ne8xUnn+42ejq9hvXbOHJM76gXog=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=kYQys+nb;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781774500;
	b=D/vmfHpbqFFMeaPpIomWAZ0uGT3lpQLS/JuFwfv1qPe0ztmAduv7gm8XZFcW3HFQRUNArD
	G2gfI4GFytKrZvJc/J6IKxamF8mg6h9wylwY3pfRbbi77ClyBz97PliYSujssQJfi8ZytY
	1dI1E8/uGlexK/UrNKkSgJGS79dZ+Gs=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781774494; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=sVRX8cTCVrBcWN6MBvdM8+S6tRfy0PKW4NWctKlaZS4=;
	b=kYQys+nb5qzF1dq4yc+6ZNQ2TwFHcVPcGv9pikifn8S97pNg//Fgf5sZ8LiHHrOsDPUeLY+DEpHjNeQbkR6FlsIDTB5egYFfBr6bJoabiojYZ9I9qbsehWhbl6MwKbHYiH72QwGePmAsivH203pxM8q2UjW38DbrIwQLLkP57Ks=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R901e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=tianruidong@linux.alibaba.com;NM=1;PH=DS;RN=28;SR=0;TI=SMTPD_---0X56USnR_1781774487;
Received: from localhost(mailfrom:tianruidong@linux.alibaba.com fp:SMTPD_---0X56USnR_1781774487 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Jun 2026 17:21:32 +0800
From: Ruidong Tian <tianruidong@linux.alibaba.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	rafael@kernel.org,
	tony.luck@intel.com,
	guohanjun@huawei.com,
	mchehab@kernel.org,
	xueshuai@linux.alibaba.com,
	tongtiangen@huawei.com,
	james.morse@arm.com,
	robin.murphy@arm.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	christophe.leroy@csgroup.eu,
	aneesh.kumar@kernel.org,
	naveen.n.rao@linux.ibm.com,
	tglx@linutronix.de,
	mingo@redhat.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	tianruidong@linux.alibaba.com
Subject: [PATCH v15 0/8] arm64: add ARCH_HAS_COPY_MC support
Date: Thu, 18 Jun 2026 17:21:14 +0800
Message-ID: <20260618092124.3901230-1-tianruidong@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 90CE24000A
X-Rspam-User: 
X-Stat-Signature: 6o1tr6csctzbzdsyxyfmcn8a9a9133s9
X-Rspamd-Server: rspam09
X-HE-Tag: 1781774498-793335
X-HE-Meta: U2FsdGVkX19yqKyhRhSoTLEyzkrAoqHz/zTru1+xTP8sPToowhvuCmOdvlgIYpwF+VTkjbODuqbbRYEaYB4HffwoO/r3P5+c/kMHIEeywzAJkm4Gubf49/2co8d7jr0YPzZ8nvS4SeuEVPYrGPJyY9+VzHLzo12n3ckKp9vwhprtEf7qFgYE9RurtKY2ae60OIFEFuoVDpCFo9JRDzP6S6p0bZbMGj19hC/d9plc24ONeBZWwxmja0CiUA/E520I+FSouURxfWhwvYkd56mgO2rWV8s4t+DupKbGBrlidyfMopKQpjrAh7XCkuCIE5KNxsEUWKRZbwKjbff53hS+RJRjWvah2kLUm9DSgw69vyEoX1Ca9qF5flswp/m+39X40jPFHMJ5o7oGbuk68/yCkhmOQ1Jukp59mf/IlXr5vR0+g3jKqeWGOI7/2Ns0bo9ZJQgwShsGtcxo1QjOE7fjZCaRwqyNl3xikAD7KFZgqKXW/AG+BNaH4E25MdqlYtXj8Hsv0WZoEpgDYjE45R/9pONhRPVu5mCHMUp3QOZz2jdxtkEYWhN3eW2QwpN4euqXMgU6bsQgpwi4lzPuQgW4PR1+L/dR43bL9CHURaCx/mfqPnKRn9cMHlw/+vG+N4t3U4TQSUBqKgbPcDCchTpSM6mYCuhohX/7yuicOSvTJMwT0WKahJ2AiujWKwW9azvDMPqpaoqXXWuNryQeYTphJIhQWSLTdaP5OL/kyR3KAOhzugHqweO/EjjOXhP+Kvdo6/9deGti4/60SVrydLihQmTlIzTOj988Ky5PfA03nYf5O8CARJCR+hi/gDDf1s6gRrorn2aq4eHILTzp9/CnifhUHxLxBKsEqiOnoC30f8tWUsE+pxQkKDtfe7w9MsHR2qe1Wor+SjpZ7xNe0kUGodzfVheVrYVdnVOkbiYEecOtqX3khN1isag+EjJXcm9pHIsZ971apcTmZB9HxPi
 LpQ70Jzd
 rVza6nY70CgNFPJtvBQszDIEZtFbppntvmVH7oPwMaqcRgaeRTtbEFKpzA+vdTHXDBXwHNWy249l+XQlLsBe2VmdMtGr375BCdpdU04Ghq+m0Tguiiq6Kd+alXWs2izDAbd1IvQHwsd2QM18smvq82wZrBn8xhcwLh2Gj5XAw0bPHwYQ5mmmLD3lzNbIMJaUXIfopwU2n5LkQRyGsNRkMvUU7zdb861358eOK7R40Tdt0nQEH0W17SxgJeD4zv2Y9OxdceSQ1sZAgQvtwN9ta1m46FGGQN1BX6eizSBeOut6OB/2/cw1x9VmNoEXcnZ3F8QmWHePHsP0apuu10WRiCqQ0lzVy9LJIhVp+HbcL3mkM/A8O9W55D7xRaUfZ2BWDgi09Pl/U+ZU6MFowqRAJ2IC8M/ooiKJWn8etDu45MncCCOTfnm38GxFaH6sjiz67FhiCnhuBC35fdBLhZvBG48gq35ICHIurMoyZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series continues Tong Tiangen's work on arm64 ARCH_HAS_COPY_MC
support. We encounter the same problem, and from a forward-looking
perspective, large-memory ARM machines will suffer more from this class
of issues, which motivates us to push this feature upstream.

Problem
=========
With the increase of memory capacity and density, the probability of memory
error also increases. The increasing size and density of server RAM in data
centers and clouds have shown increased uncorrectable memory errors.

Currently, more and more scenarios that can tolerate memory errors, such as
COW[1,2,8,9], KSM copy[3], coredump copy[4], khugepaged[5,6], uaccess copy[7],
page migration[10,11], etc.

Solution
=========

This patchset introduces a new processing framework on ARM64, which enables
ARM64 to support error recovery in the above scenarios, and more scenarios
can be expanded based on this in the future.

In arm64, memory error handling in do_sea(), which is divided into two cases:
 1. If the user state consumed the memory errors, the solution is to kill
    the user process and isolate the error page.
 2. If the kernel state consumed the memory errors, the solution is to
    panic.

For case 2, Undifferentiated panic may not be the optimal choice, as it can
be handled better. In some scenarios, we can avoid panic, such as uaccess,
if the uaccess fails due to memory error, only the user process will be
affected, returning an error to the caller and isolating the user page with
hardware memory errors is a better choice.

[1]  commit d302c2398ba2 ("mm, hwpoison: when copy-on-write hits poison, take page offline")
[2]  commit 1cb9dc4b475c ("mm: hwpoison: support recovery from HugePage copy-on-write faults")
[3]  commit 6b970599e807 ("mm: hwpoison: support recovery from ksm_might_need_to_copy()")
[4]  commit 245f09226893 ("mm: hwpoison: coredump: support recovery from dump_user_range()")
[5]  commit 98c76c9f1ef7 ("mm/khugepaged: recover from poisoned anonymous memory")
[6]  commit 12904d953364 ("mm/khugepaged: recover from poisoned file-backed memory")
[7]  commit 278b917f8cb9 ("x86/mce: Add _ASM_EXTABLE_CPY for copy user access")
[8]  commit 658be46520ce ("mm: support poison recovery from copy_present_page()")
[9]  commit aa549f923f5e ("mm: support poison recovery from do_cow_fault()")
[10] commit f00b295b9b61 ("fs: hugetlbfs: support poisoned recover from hugetlbfs_migrate_folio()")
[11] commit 060913999d7a ("mm: migrate: support poisoned recover from migrate folio")

------------------
Test result:

Tested on Kunpeng 920.

1. copy_page(), copy_mc_page() basic function test pass, and the disassembly
   contents remains the same before and after refactor.

2. copy_to/from_user() access kernel NULL pointer raise translation fault
   and dump error message then die(), test pass.

3. Test following scenarios: copy_from_user(), get_user(), COW.

   Before patched: trigger a hardware memory error then panic.
   After  patched: trigger a hardware memory error without panic.

   Testing step:
   step1. start an user-process.
   step2. poison(einj) the user-process's page.
   step3: user-process access the poison page in kernel mode, then trigger SEA.
   step4: the kernel will not panic, only the user process is killed, the poison
          page is isolated. (before patched, the kernel will panic in do_sea())

   The above tests can also be reproduced using ras-tools with extra patch[1], 
   which provides einj-based injection and validation for all MC-safe recovery paths.

   MM subsystem (hwpoison recovery via copy_mc_[user_]highpage / copy_mc_to_kernel):

     einj_mem_uc cow_anon            # wp_page_copy
     einj_mem_uc cow_anon_pinned     # copy_present_page (DMA-pinned)
     einj_mem_uc cow_hugetlb         # hugetlb CoW
     einj_mem_uc cow_private_filemap # do_cow_fault
     einj_mem_uc khugepaged_anon     # MADV_COLLAPSE anon
     einj_mem_uc khugepaged_file     # MADV_COLLAPSE file
     einj_mem_uc move_pages_numa     # migrate_folio
     einj_mem_uc migrate_pages_numa  # migrate_pages cross-node
     einj_mem_uc mbind_move          # mbind MPOL_MF_MOVE
     einj_mem_uc migrate_hugetlb     # hugetlbfs_migrate_folio
     einj_mem_uc coredump            # dump_page_copy -> copy_mc_to_kernel

   uaccess (copy_from_user direction):

     einj_mem_uc pwrite_uc           # pwrite(2)
     einj_mem_uc writev_uc           # writev(2)
     einj_mem_uc send_uc             # send(2) AF_UNIX
     einj_mem_uc sendmsg_uc          # sendmsg(2)
     einj_mem_uc setsockopt_uc       # setsockopt(2)
     einj_mem_uc netlink_send_uc     # AF_NETLINK sendto(2)
     einj_mem_uc msgsnd_uc           # SysV msgsnd(2)
     einj_mem_uc mq_send_uc          # POSIX mq_send(3)
     einj_mem_uc semop_uc            # semop(2)
     einj_mem_uc process_vm_writev_uc # process_vm_writev(2)

   Repo: https://git.kernel.org/pub/scm/linux/kernel/git/aegl/ras-tools.git
   [1] https://lore.kernel.org/all/20260617015211.3962419-1-tianruidong@linux.alibaba.com/

------------------

Benefits
=========
According to Huawei's statistics from their storage products, memory errors
triggered in kernel-mode by COW and page cache read (uaccess) scenarios
account for more than 50%. With this patchset deployed, all kernel panics
caused by COW and page cache memory errors are eliminated. 
Alibaba Cloud has also observed memory errors occurring in uaccess contexts.

Since V14:
1. Added additional recoverable scenarios (copy_present_page, do_cow_fault,
   hugetlbfs_migrate_folio, migrate_folio) to the description, as reminded
   by Kefeng Wang.
2. Renamed EX_TYPE_KACCESS_ERR_ZERO_MEM_ERR to EX_TYPE_KACCESS_SEA.
3. Applied review comments from Xueshuai Liu.

Since V13:
1. Changed MC-safe functions to return an error rather than kill the user
   process. When a user program invokes a syscall and the kernel encounters
   a memory error during uaccess, killing the process is unexpected; the
   syscall should return an error.
2. Added FEAT_MOPS support for the copy_page_mc paths.
3. Refactored copy_page() and memcpy() on top of the shared memcpy_template,
   reducing duplicated assembly code.

Since v12:
Thanks to the suggestions of Jonathan, Mark, and Mauro, the following modifications
are made:
1. Rebase to latest kernel version.
2. Patch1, add Jonathan's and Mauro's review-by.
3. Patch2, modified do_apei_claim_sea() according to Mark's and Jonathan's suggestions,
   and optimized the commit message according to Mark's suggestions(Added description of
   the impact on regular copy_to_user()).
4. Patch3, optimized the commit message according to Mauro's suggestions and add Jonathan's
   review-by.
5. Patch4, modified copy_mc_user_highpage() and Optimized the commit message according to
   Jonathan's suggestions(no functional changes).
6. Patch5, optimized the commit message according to Mauro's suggestions.
7. Patch4/5, FEAT_MOPS is added to the code logic. Currently, the fixup is not performed
   on the MOPS instruction. 
8. Remove patch6 in v12 according to Jonathan's suggestions.

Since v11:
1. Rebase to latest kernel version 6.9-rc1.
2. Add patch 5, Since the problem described in "Since V10 Besides 3" has
   been solved in a50026bdb867 ('iov_iter: get rid of 'copy_mc' flag').
3. Add the benefit of applying the patch set to our company to the description of patch0.

Since V10:
 Accroding Mark's suggestion:
 1. Merge V10's patch2 and patch3 to V11's patch2.
 2. Patch2(V11): use new fixup_type for ld* in copy_to_user(), fix fatal
    issues (NULL kernel pointeraccess) been fixup incorrectly.
 3. Patch2(V11): refactoring the logic of do_sea().
 4. Patch4(V11): Remove duplicate assembly logic and remove do_mte().

 Besides:
 1. Patch2(V11): remove st* insn's fixup, st* generally not trigger memory error.
 2. Split a part of the logic of patch2(V11) to patch5(V11), for detail,
    see patch5(V11)'s commit msg.
 3. Remove patch6(v10) “arm64: introduce copy_mc_to_kernel() implementation”.
    During modification, some problems that cannot be solved in a short
    period are found. The patch will be released after the problems are
    solved.
 4. Add test result in this patch.
 5. Modify patchset title, do not use machine check and remove "-next".

Since V9:
 1. Rebase to latest kernel version 6.8-rc2.
 2. Add patch 6/6 to support copy_mc_to_kernel().

Since V8:
 1. Rebase to latest kernel version and fix topo in some of the patches.
 2. According to the suggestion of Catalin, I attempted to modify the
    return value of function copy_mc_[user]_highpage() to bytes not copied.
    During the modification process, I found that it would be more
    reasonable to return -EFAULT when copy error occurs (referring to the
    newly added patch 4). 

    For ARM64, the implementation of copy_mc_[user]_highpage() needs to
    consider MTE. Considering the scenario where data copying is successful
    but the MTE tag copying fails, it is also not reasonable to return
    bytes not copied.
 3. Considering the recent addition of machine check safe support for
    multiple scenarios, modify commit message for patch 5 (patch 4 for V8).

Since V7:
 Currently, there are patches supporting recover from poison
 consumption for the cow scenario[1]. Therefore, Supporting cow
 scenario under the arm64 architecture only needs to modify the relevant
 code under the arch/.
 [1]https://lore.kernel.org/lkml/20221031201029.102123-1-tony.luck@intel.com/

Since V6:
 Resend patches that are not merged into the mainline in V6.

Since V5:
 1. Add patch2/3 to add uaccess assembly helpers.
 2. Optimize the implementation logic of arm64_do_kernel_sea() in patch8.
 3. Remove kernel access fixup in patch9.
 All suggestion are from Mark. 

Since V4:
 1. According Michael's suggestion, add patch5.
 2. According Mark's suggestiog, do some restructuring to arm64
 extable, then a new adaptation of machine check safe support is made based
 on this.
 3. According Mark's suggestion, support machine check safe in do_mte() in
 cow scene.
 4. In V4, two patches have been merged into -next, so V5 not send these
 two patches.

Since V3:
 1. According to Robin's suggestion, direct modify user_ldst and
 user_ldp in asm-uaccess.h and modify mte.S.
 2. Add new macro USER_MC in asm-uaccess.h, used in copy_from_user.S
 and copy_to_user.S.
 3. According to Robin's suggestion, using micro in copy_page_mc.S to
 simplify code.
 4. According to KeFeng's suggestion, modify powerpc code in patch1.
 5. According to KeFeng's suggestion, modify mm/extable.c and some code
 optimization.

Since V2:
 1. According to Mark's suggestion, all uaccess can be recovered due to
    memory error.
 2. Scenario pagecache reading is also supported as part of uaccess
    (copy_to_user()) and duplication code problem is also solved. 
    Thanks for Robin's suggestion.
 3. According Mark's suggestion, update commit message of patch 2/5.
 4. According Borisllav's suggestion, update commit message of patch 1/5.

Since V1:
 1.Consistent with PPC/x86, Using CONFIG_ARCH_HAS_COPY_MC instead of
   ARM64_UCE_KERNEL_RECOVERY.
 2.Add two new scenes, cow and pagecache reading.
 3.Fix two small bug(the first two patch).

V1 in here:
https://lore.kernel.org/lkml/20220323033705.3966643-1-tongtiangen@huawei.com/

Ruidong Tian (5):
  ACPI: APEI: GHES: use exception context to gate SIGBUS on poison
    consumption
  arm64: extable: merge UACCESS_ERR_ZERO and KACCESS_ERR_ZERO into
    ACCESS_ERR_ZERO
  arm64: enable recover from synchronous external abort in kernel
    context
  lib/test: memcpy_kunit: add copy_page() and copy_mc_page() tests
  lib/tests: memcpy_kunit: add memcpy_mc() and memcpy_mc_large() test

Tong Tiangen (4):
  uaccess: add generic fallback version of copy_mc_to_user()
  mm/hwpoison: return -EFAULT when copy fail in
    copy_mc_[user]_highpage()
  arm64: support copy_mc_[user]_highpage()
  arm64: introduce copy_mc_to_kernel() implementation

 arch/arm64/Kconfig                   |   1 +
 arch/arm64/include/asm/asm-extable.h |  24 ++-
 arch/arm64/include/asm/asm-uaccess.h |   4 +
 arch/arm64/include/asm/extable.h     |   1 +
 arch/arm64/include/asm/mte.h         |   9 +
 arch/arm64/include/asm/page.h        |  12 ++
 arch/arm64/include/asm/string.h      |   5 +
 arch/arm64/include/asm/uaccess.h     |  17 ++
 arch/arm64/kernel/acpi.c             |   2 +-
 arch/arm64/lib/Makefile              |   2 +
 arch/arm64/lib/copy_mc_page.S        |  44 +++++
 arch/arm64/lib/copy_page.S           |  67 ++-----
 arch/arm64/lib/copy_page_template.S  |  70 ++++++++
 arch/arm64/lib/copy_to_user.S        |  10 +-
 arch/arm64/lib/memcpy.S              | 251 ++-------------------------
 arch/arm64/lib/memcpy_mc.S           |  56 ++++++
 arch/arm64/lib/memcpy_template.S     | 250 ++++++++++++++++++++++++++
 arch/arm64/lib/mte.S                 |  29 ++++
 arch/arm64/mm/copypage.c             |  80 +++++++++
 arch/arm64/mm/extable.c              |  35 +++-
 arch/arm64/mm/fault.c                |  30 +++-
 arch/powerpc/include/asm/uaccess.h   |   1 +
 arch/x86/include/asm/uaccess.h       |   1 +
 drivers/acpi/apei/ghes.c             |  36 ++--
 include/acpi/ghes.h                  |  15 +-
 include/linux/highmem.h              |  16 +-
 include/linux/uaccess.h              |   8 +
 lib/tests/memcpy_kunit.c             | 186 +++++++++++++++++++-
 mm/kasan/shadow.c                    |  12 ++
 mm/khugepaged.c                      |   4 +-
 30 files changed, 938 insertions(+), 340 deletions(-)
 create mode 100644 arch/arm64/lib/copy_mc_page.S
 create mode 100644 arch/arm64/lib/copy_page_template.S
 create mode 100644 arch/arm64/lib/memcpy_mc.S
 create mode 100644 arch/arm64/lib/memcpy_template.S

-- 
2.39.3


