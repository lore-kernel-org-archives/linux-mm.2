Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E2A6CAC598
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 10:14:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B42368E0012; Mon, 15 Sep 2025 06:14:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C48B8E0015; Mon, 15 Sep 2025 06:14:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7173D8E0016; Mon, 15 Sep 2025 06:14:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4395D8E0014
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:14:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0101959739
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:14:32 +0000 (UTC)
X-FDA: 83891075226.30.67F50E1
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	by imf18.hostedemail.com (Postfix) with ESMTP id B8C891C0011
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:14:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.84 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757931271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=JfTx8v2Uqc52i0ZdLm+fQw2HsEcoVUd8ICTR1aWHLKU=;
	b=bBx8RFuQee9V9eXdjJw/F/YIEnRcDgRSLxK2zwiFsSAYGbz2l43ia/1cZ1LEfDSI1Atvq6
	EIkMYJXLoOxXS8eKayiTooU9YfE93r2CR4D/HpwOYyYKh05KtqZ47fZs6c/eULdxYJYLdF
	mykgZBTxlz6eJfFW+i8tPA0MB4LKMtU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.84 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757931271; a=rsa-sha256;
	cv=none;
	b=jz1XUeWR3XR4hfQIUqftcY6MrJo5UUrQBhZHPT24/VjnIQRYuWsWdG3SdlT+A5qJmakwKs
	9cUxmF7p1wOftYVixBNZ8bAPx5PVXFKpTwCTh7JSNar4VWw97O8wj7j69f+xKlgw0Y29lk
	8/cBC9fQ3/qYl5Etsr8x+dFrAcXOUnM=
Received: from ubt.. (unknown [210.73.43.101])
	by APP-05 (Coremail) with SMTP id zQCowAD3lxHf5sdoHWn3Ag--.53429S2;
	Mon, 15 Sep 2025 18:13:51 +0800 (CST)
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
Subject: [PATCH V12 0/5] riscv: mm: Add soft-dirty and uffd-wp support
Date: Mon, 15 Sep 2025 18:13:38 +0800
Message-Id: <20250915101343.1449546-1-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAD3lxHf5sdoHWn3Ag--.53429S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWw4xGry5XrWktFykurW3KFg_yoWrtrWxpF
	4UG343tr4rtFyxKws3Xw1j9a1Yqan5t345Gw15J34rA3y7K3WjvrnY9a1rGF1DJF4UWryS
	qrZIkr9093yqyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9qb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4
	A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
	w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r4j6F4UMc
	vjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xK
	xwCY1x0262kKe7AKxVW8ZVWrXwCY02Avz4vE14v_Gw1l42xK82IYc2Ij64vIr41l4I8I3I
	0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWU
	GVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI
	0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0
	rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r
	4UJbIYCTnIWIevJa73UjIFyTuYvjxU958nDUUUU
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiDAgGB2jHtULAJQAAs4
X-Rspamd-Queue-Id: B8C891C0011
X-Stat-Signature: webiobfg8mkh1bfdj4s6p4synezowhzk
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757931269-764551
X-HE-Meta: U2FsdGVkX195tNxExrOLhq86oA9pxgXvSxO220/80Hub12Ukhj08SsrMMSxYWmbT8W01vV2A938lQOXYNoiFz5LfhBcztVvZTZH4LMi81YIyiliIFgh+eV1KegWyGe1IduaKfCoW6tSFclTGTQjdGcYCBao6fKPI9OhLwYYpjSba9onVgHkeYN6n0gq4usJFK0ntjdJ7ICXEAjdVe7iBPUZPf2tkVdafO1xC+Hm9Fwz003vOdu19HNzrJWmKJsvXXt4+QgdBACqmn7cFDDO+RdG2tE+d6H1ApRhVApRcODwfY1gUtpR4M4ZY5bfOGmwE9TcNOjNuQFtJCdghkyI8zaDwWrdMZ/ZnjPRPO9xF11ZW9uMj9O99aYvdxXfNLZT19pCMk21oCbCsekNAXY8sRVhHiIQ/14YkWF7ixTgsNNjnVDU0igb5OGJ9nKKBbymBgII7bCbXJVKnqp1ujahh3V8FKppmaedC2LYEhuPLLqfzD1RtzYuUd+2bKHBp6cuh9RnGfMCV4vRRHZg3qnGqD5zMlbDniNmnhqOrAz9UJxNYhvpBk/lddpSqHLxajchmACJ+b3YMh+AF24Zav1hsEYZHiTq60ce38uogf2jWYB7kAl5PkoJgFXvpZrghv4yKRKrO3O7zE+zJATcd1rX+GMK5tz33gqFI/aEji9yS+DUgj9/od6KKAZ3T3xIwSTqaKP455flDHA0jvZcKlhsRkUr2cBPxC2yPPknnPQW13M607QARazlBFEg6s+XeYNsT9XeQkdeDv+n41wXZoz9aDPWQEoaqBEd0Wk5NJM4658kTX4k0i7jKgaoSiZefM8ZsSRHxLuPsh3b+McWKc5k+GET68dH3dbmXkLtaJvSD3/VO5b/mD5pWA21XaF6YTS+XlVER2cziSsn3mZAJBpIfV0BhmQy6G1/AxGV7Old7I9GpzZ1JGFM/r0G40pKAJWaMKp0qK341zDif9v/gQuC
 MBUuXFBR
 wL1Tw4tjOzoehCA7JQjieHmRzYyUp3BVCL51glMb9PGIwvByjumAavoSNQPQJirQx3D1CZjRXYZRliwAfvE7jutoCKbJmuSX7++UMWpExvFXskbbu3pjro6N/inZnmcBVghCUQnaU6XWK7QqG0oPii2kUg9zsi812epsJHnyecM5vZdvfvqCtZXUmlLo36nDqlQlnPXjlC4RIfWDdMSLK2vY73y9ME5LufyuOUfh+VyO/9Eoa+ty2SQwH0hI8L6hIOdwqcENFrryGi9oesh8veKQTK1KJyK4kFuEf1140GLeDWRQ=
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

This patchset applies on top of v6.17-rc6.

[1] https://github.com/riscv-non-isa/riscv-iommu/pull/543

V12:
- Rename the macro API to pgtable_supports_soft_dirty/uffd_wp();
- Add changes for setting VM_SOFTDIRTY flags conditionally;
- Drop changes to show_smap_vma_flags();
- Drop CONFIG_MEM_SOFT_DIRTY compile condition of clear_soft_dirty() and clear_soft_dirty_pmd();
- Fix typos;
- Add uffd_supports_wp_marker() and drop some ifdef CONFIG_PTE_MARKER_UFFD_WP.

V11: https://lore.kernel.org/all/20250911095602.1130290-1-zhangchunyan@iscas.ac.cn/
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
  mm: softdirty: Add pgtable_supports_soft_dirty()
  mm: userfaultfd: Add pgtable_supports_uffd_wp()
  riscv: Add RISC-V Svrsw60t59b extension support
  riscv: mm: Add soft-dirty page tracking support
  riscv: mm: Add userfaultfd write-protect support

 arch/riscv/Kconfig                    |  16 +++
 arch/riscv/include/asm/hwcap.h        |   1 +
 arch/riscv/include/asm/pgtable-bits.h |  37 +++++++
 arch/riscv/include/asm/pgtable.h      | 143 +++++++++++++++++++++++++-
 arch/riscv/kernel/cpufeature.c        |   1 +
 fs/proc/task_mmu.c                    |  15 ++-
 fs/userfaultfd.c                      |  22 ++--
 include/asm-generic/pgtable_uffd.h    |  17 +++
 include/linux/mm.h                    |   3 +
 include/linux/mm_inline.h             |  10 +-
 include/linux/pgtable.h               |  12 +++
 include/linux/userfaultfd_k.h         |  27 +++--
 mm/debug_vm_pgtable.c                 |  10 +-
 mm/huge_memory.c                      |  13 +--
 mm/internal.h                         |   2 +-
 mm/memory.c                           |   6 +-
 mm/mmap.c                             |   6 +-
 mm/mremap.c                           |  13 +--
 mm/userfaultfd.c                      |  10 +-
 mm/vma.c                              |   6 +-
 mm/vma_exec.c                         |   5 +-
 21 files changed, 306 insertions(+), 69 deletions(-)

-- 
2.34.1


