Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D644CA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 09:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B22C28E000B; Thu, 11 Sep 2025 05:56:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFB108E0001; Thu, 11 Sep 2025 05:56:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A10028E000B; Thu, 11 Sep 2025 05:56:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 82A068E0007
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 05:56:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2C0C8C0417
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:56:50 +0000 (UTC)
X-FDA: 83876515380.20.992B13D
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	by imf13.hostedemail.com (Postfix) with ESMTP id F32A220010
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:56:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757584608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=0hsFygpi1K7mdYBvrhmtuQHtUc/T2d6Gw+Rge/FFRwU=;
	b=pF4euxRIDuitaPHSk7d2zHrh6kVEbns5OxQdA7HlPWZRWAqb+mOj9H5FzKPV85iqE1uw+a
	CNFGjF7DJx+0Cbxb/AmNiMGl8LbsUm/7V2hVedv9TQNgDuur0MAXB6zEiLBLkQElLQ7Ix8
	tf6Rlvzj6vyby3j/zA8Uq9s7myDIlk4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757584608; a=rsa-sha256;
	cv=none;
	b=i4VV0KnsNB8d1bTNm7f6Sb3M2rPVMSvcYb/DAP5lj+dvuDFidk84GFS9Ipf4nvXk4QQS53
	zb2wuFlNk1tcH616AuR5E815ly3/Q99twDkkILspHSunIoCYcSMvIVJrfiao138QmeYTvJ
	p+qw9al+PRzdtEdVMSbT6nXXXBA7kJE=
Received: from ubt.. (unknown [210.73.43.101])
	by APP-03 (Coremail) with SMTP id rQCowACH2IK5nMJoo6pCAg--.44660S2;
	Thu, 11 Sep 2025 17:56:09 +0800 (CST)
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
To: linux-riscv@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Deepak Gupta <debug@rivosinc.com>,
	Ved Shanbhogue <ved@rivosinc.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Xu <peterx@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Chunyan Zhang <zhang.lyra@gmail.com>
Subject: [PATCH v11 0/5] riscv: mm: Add soft-dirty and uffd-wp support
Date: Thu, 11 Sep 2025 17:55:57 +0800
Message-Id: <20250911095602.1130290-1-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowACH2IK5nMJoo6pCAg--.44660S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWw4xGry5XF47Xry3Gw4kJFb_yoWrWFWkpF
	45G343tr4rtr1Igws3Jw1j9a1Fqan5tw1rCw15X34rA3y2gF1jyrnaka1rGF1DJF48WryS
	qrWakryq93yqyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9vb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I
	8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
	64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVW8JVWxJw
	Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkI
	wI1lc7CjxVAaw2AFwI0_GFv_Wrylc2xSY4AK67AK6r4fMxAIw28IcxkI7VAKI48JMxC20s
	026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_
	JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14
	v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xva
	j40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JV
	W8JrUvcSsGvfC2KfnxnUUI43ZEXa7IUYvXd7UUUUU==
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiDAYCB2jCjVc9NAAAs2
X-Rspamd-Queue-Id: F32A220010
X-Stat-Signature: 81rya3mws3pq71oghkmiydr1dq877cw6
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757584606-415052
X-HE-Meta: U2FsdGVkX18hSWoMOo5o3wq0GNNupoCEKIkI4T27SYTszolJAT8bSdcHY6moUA1WBmUpba0s5aMfOnFvsYz1f/0LFEF+x7V5BrPpRWF9bw2DvFzCfJRKZStYoRncjzuBZWl0/HvJUrk47i/BHjeW2BQOsbDQn2pmTEYosQ32RM+Sw0jLPekrv6DIpAIaveq8DxzVyYk50K4ky+ds+O3HQiu4A6Mfom7xmJwMRXN0M27jX+OLJqpqqbdPTnCfEsTwtY8kHG9cmQCIVLEtbCf6Ef8hLMiMeOn6HRl9cZdp3gUw9VHv6k9WWhILd2trXcJ49BJRhLcLWkxvhyOjeSRh7mMXGlN4sshj1NHiF8T+PbbeOwOLGMWR5u23kNZbnvGKfbSmwUoQyhexJf/awrASixcQl6GFa3bn3zxYT16ewGKfQtNSXwGgSsozWFg+MlQIjlHouoX4ewP7hDg+WGFxr99yjwm72WKbmK/Mi5vEC1IGI2N2vOBgDZkFSNtXYRKALBWEIJWbjG6cgc5rTzzNsnNcan7LDR9jCRQd9WX/hCMBwC4LP3//JV/nlLDnb90vkLE7YpSCweJgXePwPNRzeouZICpFGiWcHFp+UhYZ5dd1nmosiIq+t7tqcu7n9BZMiHhqcjSTxzDIKYVRY+h5rdfFFGJ2q+u2ojlYhjEVEsZGL2cd6eXGkgA9gLF/9TKJSorNzCQMUxX8eU3wm2PhECWtUy5yKDX9kovi0k7ImYEd7Q9MxCCLNsgk5iuQgstqZyPnD6V0Jj1Q3fwtR8wrGRjjYrA5GY71cc2T8i+dpdZDOL7eOW1GugTvhqd2lEYvoJmFOOJZ2bWynDCqMF6BlSXQr7dYMgWRuxAAqIIwT3Rg14pJY9zzHksgyLJoMMV/xBtIFggseA4OsNg+3lnqGegTOyYp3wOpSkWc/q6imHWFZ1zuX9aAkOXj+F5Av5vIaObgRLKkgu6boUPE85Q
 Alj+rGAl
 2XzqjLvYhxq+POIxVWaB7Q42FA+YmPjClS3FGaypTywcusTETlgdmzC6qo7wN9HznM6HHZTD+g/ZAgheuC8baIq7dG1sFL/rZpSus4jPZ+fWafDdaCi+3li1bue81vds9wH+iA3DOsmuKKeWiNqDDmOEl0JacH31l7amy5zzgrp90qMhxsdLTz+/C0EHzlKSrH8kv0GdzMTkf3YMjWQwWXP7EhTDa/FHo8gaRm/CbrsTeISduM2ca4r/VfsepHhLopf648WyANX8a+itfPyG7E1//jvmEOKnUrf3m6Fh3vbgVs8o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset adds support for Svrsw60t59b [1] extension which is ratified now,
also add soft dirty and userfaultfd write protect tracking for RISC-V.

The patches 1 and 2 add macros to allow architectures to define their own checks
if the soft-dirty / uffd_wp PTE bits are available, in other words for RISC-V,
the Svrsw60t59b extension is supported on which device the kernel is running.

This patchset has been tested with kselftest mm suite in which soft-dirty, 
madv_populate, test_unmerge_uffd_wp, and uffd-unit-tests run and pass,
and no regressions are observed in any of the other tests.

This patchset applies on top of v6.17-rc4.

[1] https://github.com/riscv-non-isa/riscv-iommu/pull/543

V11:
- Rename the macro API to pgtable_*_supported() since we also have PMD support;
- Change the default implementations of two macros, make CONFIG_MEM_SOFT_DIRTY or
  CONFIG_HAVE_ARCH_USERFAULTFD_WP part of the macros;
- Correct the order of insertion of RISCV_ISA_EXT_SVRSW60T59B;
- Rephrase some comments.

V10: https://lore.kernel.org/all/20250909095611.803898-1-zhangchunyan@iscas.ac.cn/
- Fixed the issue reported by kernel test irobot <lkp@intel.com>.

V9: https://lore.kernel.org/all/20250905103651.489197-1-zhangchunyan@iscas.ac.cn/
- Add pte_soft_dirty/uffd_wp_available() API to allow dynamically checking
  if the PTE bit is available for the platform on which the kernel is running.

V8: https://lore.kernel.org/all/20250619065232.1786470-1-zhangchunyan@iscas.ac.cn/)
- Rebase on v6.16-rc1;
- Add dependencies to MMU && 64BIT for RISCV_ISA_SVRSW60T59B;
- Use 'Svrsw60t59b' instead of 'SVRSW60T59B' in Kconfig help paragraph;
- Add Alex's Reviewed-by tag in patch 1.

V7: https://lore.kernel.org/all/20250409095320.224100-1-zhangchunyan@iscas.ac.cn/
- Add Svrsw60t59b [1] extension support;
- Have soft-dirty and uffd-wp depending on the Svrsw60t59b extension to
  avoid crashes for the hardware which don't have this extension.

V6: https://lore.kernel.org/all/20250408084301.68186-1-zhangchunyan@iscas.ac.cn/
- Changes to use bits 59-60 which are supported by extension Svrsw60t59b
  for soft dirty and userfaultfd write protect tracking.

V5: https://lore.kernel.org/all/20241113095833.1805746-1-zhangchunyan@iscas.ac.cn/
- Fixed typos and corrected some words in Kconfig and commit message;
- Removed pte_wrprotect() from pte_swp_mkuffd_wp(), this is a copy-paste
  error;
- Added Alex's Reviewed-by tag in patch 2.

V4: https://lore.kernel.org/all/20240830011101.3189522-1-zhangchunyan@iscas.ac.cn/
- Added bit(4) descriptions into "Format of swap PTE".

V3: https://lore.kernel.org/all/20240805095243.44809-1-zhangchunyan@iscas.ac.cn/
- Fixed the issue reported by kernel test irobot <lkp@intel.com>.

V2: https://lore.kernel.org/all/20240731040444.3384790-1-zhangchunyan@iscas.ac.cn/
- Add uffd-wp supported;
- Make soft-dirty uffd-wp and devmap mutually exclusive which all use
  the same PTE bit;
- Add test results of CRIU in the cover-letter.

Chunyan Zhang (5):
  mm: softdirty: Add pgtable_soft_dirty_supported()
  mm: userfaultfd: Add pgtable_uffd_wp_supported()
  riscv: Add RISC-V Svrsw60t59b extension support
  riscv: mm: Add soft-dirty page tracking support
  riscv: mm: Add userfaultfd write-protect support

 arch/riscv/Kconfig                    |  16 +++
 arch/riscv/include/asm/hwcap.h        |   1 +
 arch/riscv/include/asm/pgtable-bits.h |  37 +++++++
 arch/riscv/include/asm/pgtable.h      | 143 +++++++++++++++++++++++++-
 arch/riscv/kernel/cpufeature.c        |   1 +
 fs/proc/task_mmu.c                    |  17 ++-
 fs/userfaultfd.c                      |  23 +++--
 include/asm-generic/pgtable_uffd.h    |  11 ++
 include/linux/mm_inline.h             |   7 ++
 include/linux/pgtable.h               |  12 +++
 include/linux/userfaultfd_k.h         |  44 +++++---
 mm/debug_vm_pgtable.c                 |  10 +-
 mm/huge_memory.c                      |  13 +--
 mm/internal.h                         |   2 +-
 mm/memory.c                           |   6 +-
 mm/mremap.c                           |  13 +--
 mm/userfaultfd.c                      |  10 +-
 17 files changed, 310 insertions(+), 56 deletions(-)

-- 
2.34.1


