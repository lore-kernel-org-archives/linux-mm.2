Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7741FCD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 08:50:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B135B6B0005; Mon, 18 May 2026 04:50:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEB416B0088; Mon, 18 May 2026 04:50:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D9806B008C; Mon, 18 May 2026 04:50:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 84FA76B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 04:50:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 25345C2AD0
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:50:09 +0000 (UTC)
X-FDA: 84779918538.23.DF9811D
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 02D96C0002
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:50:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fdU9nc97;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779094207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QIExxa2gtCgMJh0cTlkHMJMi23odo6hrsowfpi04xjs=;
	b=Gp/I7mSGe5ZoMe8juenFJHOKwtLFASYT6te/gTnRFoEscKqQvBs5XMFi1WpPZH015e00Jp
	LiKEL1GP0NuUxF120kfeda1Togtow1dMYmfQWwxUUAMncya7I1idhvPIdznxFqpLgnxulR
	FdEt2b8OCOzTLgAFuTXUepnNEag+3ic=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779094207; a=rsa-sha256;
	cv=none;
	b=YhmCAzbeRoa09knRG/tmAhYbe2Y1NG1yg9JH6XUbOLPh4gsvzgi2MA97wTZcwVXdUMw7Qp
	cQBeYgYgitmOxa8eOuhsZt1Y20H51wO/zsaUf3MhQy13vWgqyTYIfYj21J9ZwHXbbY2seA
	g7nn+OvlKy9PcsrEGfCIm+V13bIrWvM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fdU9nc97;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779094202; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=QIExxa2gtCgMJh0cTlkHMJMi23odo6hrsowfpi04xjs=;
	b=fdU9nc977/x+nr6jQ28nZDcBNGivcozQ2OtpdOYAy3G7Dy2sXmcyU5iAvwm3/7CzTVAMUAxnD4Iky7cacXJDVt7h+JtvJ7sfT+vLDD0MILeCmxZ4HyJfUpKXnld1s4jE1jDkQB0IudYrsaUxcs7pGKqwPuFzRxbphMBdLmop0Rg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=tianruidong@linux.alibaba.com;NM=1;PH=DS;RN=28;SR=0;TI=SMTPD_---0X36F6ip_1779094198;
Received: from localhost(mailfrom:tianruidong@linux.alibaba.com fp:SMTPD_---0X36F6ip_1779094198 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 18 May 2026 16:50:00 +0800
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
Subject: [PATCH v14 0/8] arm64: add ARCH_HAS_COPY_MC support
Date: Mon, 18 May 2026 16:49:44 +0800
Message-ID: <20260518084956.2538442-1-tianruidong@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 02D96C0002
X-Rspamd-Server: rspam04
X-Stat-Signature: dqigd8wcm88ycurprsni5ikuwi478j9n
X-HE-Tag: 1779094205-152626
X-HE-Meta: U2FsdGVkX18CQETcKabde2NNvj3xALu/oTmOTACvFO8wqisYULY7BlR/191EYHzDOKoHXDyvGrjkAApmwl0H6ujhfm6yPxPZiCTiw52uS/oBeDaR5+RgFxYk0MDWQtS/keTU5J5Rmmf45dYcc3bddJXx6P6FRBDfr1MA0LSkADYt5ZA7fwEMTLBpSNqqqMvQMfgxOf1i++NK8cjy5Jmz/ycDhLyf6NJdZpynR8uc0RT71N0IXGE5EOYyFZG/QfgyindRGq22pBb2+kEgEBN7El0ZyFdeWXsF7SJU5wBzWZQ5nCVw59gnzGYXMDBuwAJf0RBhPHHkLdXrkU+lPB8I+R+qD+29dz3oApeQ119R7PoNZftGzsZeJvj/9PHq16GJS66tdN/LIdl4bDLyZwAlC4oxTj8TrmAOzUKk91t6BaBw59Jx36qTWPHpDH19yejpmV40JH0Urzepang8oESVNFNjMsptGF3k6iOT6/ybR4x/3H5nJ7RfPtLZGOf7YtOfswymiDtHcaX/FaD7lrt/9rnaO4BUAREd6hv3zXi9RhuPqIPKPZC2sas63SujKOvMhegKyXMMEVEQUy1cQnpd8NNTvUoEpNhJ9+vPn0ORzAcAFC7qhqTa202zBaFqiYV5OfWgDQRKy6WH/UZXc4LJHp3sAhL6F5GbsAK0f+CWvR8/FkDDOctd5YknvydqIzBfsDUa7gaeWgAOVBUWhH2nstY7j43oFYiZaCQC0A9XnVx8O15XA++9KdaeZ1p7mLp3q4K/NrQQzOygAU5CcJeSl2WdFWV+SPiSQZn999EW4UxUx9W5bMaAez4hLX38TswFbif19APTPVfWPPZ4lQ7LibaAgVAe+1xn1R0AyeQXpd1c4YCZOQQQu6z8o9jEuZaixS0ZdfbVdD7PnlYW8kSWDftcVadai6cizNwpAaWS3N9578Wcjj4RMrzTyQJh+6cgLjGaB48W/+7/9/ehxsK
 NxkNIFwo
 dD1lCXpOinIwTg9T8uMBmRnpXUGDe/POBCffKcbQzx/+I4BU1zSjYshqpOXA+sMfgjZoitLd7TkLJpLL0Nk83w/hf9cXAjaiUt1mtxeM9pGzONMqtmBk5WwQXzy9SEzntcOi55nlbJ2R4EZViFCX8JOk3SuZwYe+Cn66ZvCSmITBtFb8/3z/kR59pksL2d6ZUJOMeti0E/DOMl9Nr0cr0kWy0dyx4BQBYlzEeRiyiptYNq1B3/5elQX/4+UX5PCBO63wEoF/0WT4Z9KIESQRhNMDb034e4vgS9Ig0keTgoA8BNK00Z2bG1F3Pp80PPpjMFxadmFTibB6uUnf5EgF3HA4prtY1CLTGX3ArEoSRN2C8YPwRWyUtJ/Z8JgGukThmVPJpTz1vu8jEboMZgZMqohoDx5Yx+q+5iTJjAV1IsW1YODDEHm13fwE2wpSPA7Oex8KX64MF6/ypGcfeaPzw26Ho4lE3omd++amyT1YEJab4RS0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series continues Tong Tiangen's work on arm64 ARCH_HAS_COPY_MC
support. We encounter the same problem, and from a forward-looking
perspective, large-memory ARM machines such as Grace and Vera will suffer
more from this class of issues, which motivates us to push this feature
upstream.

Problem
=========
With the increase of memory capacity and density, the probability of memory
error also increases. The increasing size and density of server RAM in data
centers and clouds have shown increased uncorrectable memory errors.

Currently, more and more scenarios that can tolerate memory errors, such as
COW[1,2], KSM copy[3], coredump copy[4], khugepaged[5,6], uaccess copy[7],
etc.

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

[1] commit d302c2398ba2 ("mm, hwpoison: when copy-on-write hits poison, take page offline")
[2] commit 1cb9dc4b475c ("mm: hwpoison: support recovery from HugePage copy-on-write faults")
[3] commit 6b970599e807 ("mm: hwpoison: support recovery from ksm_might_need_to_copy()")
[4] commit 245f09226893 ("mm: hwpoison: coredump: support recovery from dump_user_range()")
[5] commit 98c76c9f1ef7 ("mm/khugepaged: recover from poisoned anonymous memory")
[6] commit 12904d953364 ("mm/khugepaged: recover from poisoned file-backed memory")
[7] commit 278b917f8cb9 ("x86/mce: Add _ASM_EXTABLE_CPY for copy user access")

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

   The above tests can also be reproduced using ras-tools, which provides
   einj-based injection and validation for uaccess and COW scenarios.
   Example usage:

     einj_mem_uc futex          # get_user
     einj_mem_uc copyin         # copy_to_user
     einj_mem_uc copy-on-write  # COW

   Link: https://git.kernel.org/pub/scm/linux/kernel/git/aegl/ras-tools.git

------------------

Benefits
=========
According to Huawei's statistics from their storage products, memory errors
triggered in kernel-mode by COW and page cache read (uaccess) scenarios
account for more than 50%. With this patchset deployed, all kernel panics
caused by COW and page cache memory errors are eliminated. 
Alibaba Cloud has also observed memory errors occurring in uaccess contexts.

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

Ruidong Tian (3):
  ACPI: APEI: GHES: use exception context to gate SIGBUS on poison
    consumption
  lib/test: memcpy_kunit: add copy_page() and copy_mc_page() tests
  lib/tests: memcpy_kunit: add memcpy_mc() and memcpy_mc_large() test

Tong Tiangen (5):
  uaccess: add generic fallback version of copy_mc_to_user()
  arm64: add support for ARCH_HAS_COPY_MC
  mm/hwpoison: return -EFAULT when copy fail in
    copy_mc_[user]_highpage()
  arm64: support copy_mc_[user]_highpage()
  arm64: introduce copy_mc_to_kernel() implementation

 arch/arm64/Kconfig                   |   1 +
 arch/arm64/include/asm/asm-extable.h |  22 ++-
 arch/arm64/include/asm/asm-uaccess.h |   4 +
 arch/arm64/include/asm/extable.h     |   1 +
 arch/arm64/include/asm/mte.h         |   9 +
 arch/arm64/include/asm/page.h        |  10 ++
 arch/arm64/include/asm/string.h      |   5 +
 arch/arm64/include/asm/uaccess.h     |  17 ++
 arch/arm64/kernel/acpi.c             |   2 +-
 arch/arm64/lib/Makefile              |   2 +
 arch/arm64/lib/copy_mc_page.S        |  44 +++++
 arch/arm64/lib/copy_page.S           |  62 +------
 arch/arm64/lib/copy_page_template.S  |  71 ++++++++
 arch/arm64/lib/copy_to_user.S        |  10 +-
 arch/arm64/lib/memcpy.S              | 253 ++-------------------------
 arch/arm64/lib/memcpy_mc.S           |  56 ++++++
 arch/arm64/lib/memcpy_template.S     | 249 ++++++++++++++++++++++++++
 arch/arm64/lib/mte.S                 |  29 +++
 arch/arm64/mm/copypage.c             |  75 ++++++++
 arch/arm64/mm/extable.c              |  21 +++
 arch/arm64/mm/fault.c                |  30 +++-
 arch/powerpc/include/asm/uaccess.h   |   1 +
 arch/x86/include/asm/uaccess.h       |   1 +
 drivers/acpi/apei/ghes.c             |  36 ++--
 include/acpi/ghes.h                  |   6 +-
 include/linux/highmem.h              |  16 +-
 include/linux/uaccess.h              |   8 +
 lib/tests/memcpy_kunit.c             | 178 ++++++++++++++++++-
 mm/kasan/shadow.c                    |  12 ++
 mm/khugepaged.c                      |   4 +-
 30 files changed, 904 insertions(+), 331 deletions(-)
 create mode 100644 arch/arm64/lib/copy_mc_page.S
 create mode 100644 arch/arm64/lib/copy_page_template.S
 create mode 100644 arch/arm64/lib/memcpy_mc.S
 create mode 100644 arch/arm64/lib/memcpy_template.S

-- 
2.39.3


