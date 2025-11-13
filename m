Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2704CD4F28
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 07:28:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02F568E000B; Thu, 13 Nov 2025 02:28:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF82F8E0008; Thu, 13 Nov 2025 02:28:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D981D8E000C; Thu, 13 Nov 2025 02:28:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B2BBB8E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:28:36 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 60FD81408D3
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:28:36 +0000 (UTC)
X-FDA: 84104756232.01.46082DE
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	by imf28.hostedemail.com (Postfix) with ESMTP id 38CB2C0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:28:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.84 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763018914; a=rsa-sha256;
	cv=none;
	b=GcaByseds5C2qZZvLNp4JNbPKZendMfJjOi75LhqOI0dZdXjvGDToP73vyr/3AgMOEdUFH
	w3Ath81Lx90QIIQmcwqTHq18blXuNNHY6xBW0OS6qzSWyhKULrQqOfmcZmbojlYn5aCMO7
	lOyYt72zxRTV17Y2XsBNwq454x19pcc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.84 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763018914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=Jq5gi6Es7y/gJH8S+62W9syU6/Rmp8modepqjiMosMk=;
	b=g/Tv2rj3QJog1xbn4jdAmCmeJ/UpfRaRftjiX5dNzEUXNCp/QzA8ZtsAswWz30mg/ch1eQ
	H+bzQ/EiIxyISJsqjuG2Zq0UI2RQc6sqhWvPqc3TVryHSGB9GADk3lYdpQGkznDvAqcorF
	2DvyTSn6QDTOrgwDwegypC7QVcym2pM=
Received: from ubt.. (unknown [210.73.43.101])
	by APP-05 (Coremail) with SMTP id zQCowABnbG2RiBVpVTOWAA--.33691S2;
	Thu, 13 Nov 2025 15:28:19 +0800 (CST)
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
To: Andrew Morton <akpm@linux-foundation.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-mm@kvack.org,
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
	linux-riscv@lists.infradead.org,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	devicetree@vger.kernel.org,
	Conor Dooley <conor@kernel.org>,
	Deepak Gupta <debug@rivosinc.com>,
	Ved Shanbhogue <ved@rivosinc.com>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org,
	Chunyan Zhang <zhang.lyra@gmail.com>
Subject: [PATCH V15 0/6] mm: Add soft-dirty and uffd-wp support for RISC-V
Date: Thu, 13 Nov 2025 15:28:00 +0800
Message-Id: <20251113072806.795029-1-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowABnbG2RiBVpVTOWAA--.33691S2
X-Coremail-Antispam: 1UD129KBjvJXoW3Wr18CrWDAF15CF43Zr4DXFb_yoW7tryUpF
	4UGry3tr4rtr1Iga93Xw109an0qan8tw15Gw1rX34rA3y2k3Wjvrna9a1rWF1DJr4UWryI
	qrWakr90934qyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9mb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwV
	C2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY
	04v7MxkF7I0En4kS14v26r4a6rW5MxkIecxEwVAFwVW8CwCF04k20xvY0x0EwIxGrwCFx2
	IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v2
	6r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67
	AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IY
	s7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr
	0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07ba4SwUUUUU=
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiDAYFB2kVaThzyQAAsf
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 38CB2C0003
X-Stat-Signature: ehskj5ida7jhko4a4osx5km8y4icox4s
X-HE-Tag: 1763018912-531335
X-HE-Meta: U2FsdGVkX19U9FhQuxu1fiPndXFS/2KQ4bg4uK389etIW6kTyQKbMfApObcriProbTJMe++httPrXxjoUhkrjDqOQvfFs9V5jJRH3hGekIiRH+ywdxVtVaSUUZXSpjY0cGa9wZvEeER/sm8kuwd6wgZD0yr/LVR/U1PRnGGrUnjscgHJ2PhltOKc01BLiJLqsYPGAn+ZSSHwN0v701cM7WVb0oLebcOeGYAIQ9hpVSXdgnvzSRkMLJoqPpThHFb423dFT4KT2gKawoMb3k3mBJ9TU1bXwyinZyn0qa6xMK7oil/PaHtdGbNXG9aNrG8r1RyDbOx4jE2zeCppkxCI5lGuhJf5OmoETSAkE/bnTKwg1GH0qQJDtfL7mq/lMJ1/6JcmQ1CS/Nyvf8KIvi20e/Mwas8DRhWx1+V/HqPDCT2IvrBMn/ERxd5jRmvJ9gMQTnPf6A/rd3iYBfbwNBF4Fi4NcoUxcsKHad0tPktt2Y2f7eQFGETTFLRGss4xCQOXBRtz3O519y27oMQ3o64UdwxJsQncjCW44r5ozhGB1EW61tdMCNOgzIdINrEVInCzQ9Bzhp1T5IuG23uQ0uUs01kTXLryiVNJyDtgyUl/WHaszbX9jg4FSjgt2euMmNg3rtCDTuoDS6ta2AzxPVIG9YyMad9godix/vJJotsPt15hsDvpLRYphP77Z5Bd/eE+M6XmI4oOnIOs23cbTU+tYezm/M7P9xPubv2NVyLXeiebepJ4NZBcXqsneXn7PqZ+4eVhWTEz/vkddN0QZW7vAL5w8vQ9Gdav+IbB8P+Si3lKikVQLijrtTu7mxDdBb8kz6vq18sVtIkDIN7NPyw6AjiAMxaBKCXueIQpnrRPegHhNy+gU8lwU12xqgFxJN5D4sFL/8aIvVMrmgFO3gzBG91rxCtgncYM0uS1czI5ICQ5fIe5+MMdiY62QeDZm3NXPuj4uCtJOYcOZXrZlwU
 fS8773iI
 nkFD0QpBHrqcsRAe8yU11nofmeBb43zHfuFxrBSMVCglBbdGYuiu9ssL8U5RXj0N7eqk7e5DeNMBhmAWd/SX+vvFFMk7vg8ZkCyxzJwmjdQqZEy15qeUSRyVVdM3AA8Y12Khrm3lW65JNfcfbc0QatgzI1EnZogONAm2MKzfV+IrqXuldnh3unEEAZ9MZuVVAOFhwchDGQgrJV+jbKDPjoL2PMF7RQ3BevqB19gAcm1+fnJMLHoifZ19KqaomwaBPynOvpGvNyvdwF4Zj+DRssP2ilenchBT2KNGJE/U+rgiP2PirH6LZ6PZfxQ==
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
Also patch1-2 are removing "ifdef CONFIG_MEM_SOFT_DIRTY"
"ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP" and
"ifdef CONFIG_PTE_MARKER_UFFD_WP" in favor of checks which if not overridden by
the architecture, no change in behavior is expected.

This patchset has been tested with kselftest mm suite in which soft-dirty, 
madv_populate, test_unmerge_uffd_wp, and uffd-unit-tests run and pass,
and no regressions are observed in any of the other tests.

This patchset applies on the mm/mm-new branch commit ea53cb52f919
("mm/vmalloc: cleanup gfp flag use in new_vmap_block()")

[1] https://github.com/riscv-non-isa/riscv-iommu/pull/543

V15:
- Rebased on to the latest mm-new branch;
- Removed a redundant space;
- Added Conor's Acked-by.

V14: https://lore.kernel.org/all/20250918083731.1820327-1-zhangchunyan@iscas.ac.cn/
- Fix indent inssues in userfaultfd_k.h;
- Some descriptions and comments minor changes.

V13: https://lore.kernel.org/all/20250917033703.1695933-1-zhangchunyan@iscas.ac.cn/
- Rebase on mm-new branch;
- Fixed build errors;
- Add more exactly descriptions in commit message in patch 1-2;
- Replace '__always_inline' with 'inline' for uffd_supports_wp_marker();
- Add Svrsw60t59b description to the extensions dt-binding in patch 6.

V12: https://lore.kernel.org/all/20250915101343.1449546-1-zhangchunyan@iscas.ac.cn/
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

Chunyan Zhang (6):
  mm: softdirty: Add pgtable_supports_soft_dirty()
  mm: userfaultfd: Add pgtable_supports_uffd_wp()
  riscv: Add RISC-V Svrsw60t59b extension support
  riscv: mm: Add soft-dirty page tracking support
  riscv: mm: Add userfaultfd write-protect support
  dt-bindings: riscv: Add Svrsw60t59b extension description

 .../devicetree/bindings/riscv/extensions.yaml |   6 +
 arch/riscv/Kconfig                            |  16 ++
 arch/riscv/include/asm/hwcap.h                |   1 +
 arch/riscv/include/asm/pgtable-bits.h         |  37 +++++
 arch/riscv/include/asm/pgtable.h              | 143 +++++++++++++++++-
 arch/riscv/kernel/cpufeature.c                |   1 +
 fs/proc/task_mmu.c                            |  15 +-
 fs/userfaultfd.c                              |  22 +--
 include/asm-generic/pgtable_uffd.h            |  17 +++
 include/linux/mm.h                            |   3 +
 include/linux/mm_inline.h                     |   8 +-
 include/linux/pgtable.h                       |  12 ++
 include/linux/userfaultfd_k.h                 |  69 +++++----
 mm/debug_vm_pgtable.c                         |  10 +-
 mm/huge_memory.c                              |  13 +-
 mm/internal.h                                 |   2 +-
 mm/memory.c                                   |   6 +-
 mm/mmap.c                                     |   6 +-
 mm/mremap.c                                   |  13 +-
 mm/userfaultfd.c                              |  10 +-
 mm/vma.c                                      |   6 +-
 mm/vma_exec.c                                 |   5 +-
 22 files changed, 337 insertions(+), 84 deletions(-)

-- 
2.34.1


