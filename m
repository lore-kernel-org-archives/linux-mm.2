Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8256ACA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 03:37:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8BB68E0005; Tue, 16 Sep 2025 23:37:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D63C98E0001; Tue, 16 Sep 2025 23:37:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA0348E0005; Tue, 16 Sep 2025 23:37:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B9EC58E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 23:37:37 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4E5AA86481
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:37:37 +0000 (UTC)
X-FDA: 83897332554.25.1145A45
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	by imf06.hostedemail.com (Postfix) with ESMTP id EBC32180004
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:37:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758080255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=KPlE/vsugxggjRotq0Uk5XiaQXBrOcjLHImguP+bP3g=;
	b=uY+8tFP6QqW7B3TT7qaOwDx/CJVh/IprLCgaViSL0G6GOT24NstOGdRIDHus6vZ7dXUrid
	meiQ23LC0sblFGpBrTkVukCJMY6Dx8n6UWsFMG3u8HbNIr9uzVMAaD2zgjyLFVCi37Wlyy
	cpeTejwBLSOea+ID1JKhyx63Q+4Keuo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758080255; a=rsa-sha256;
	cv=none;
	b=Is6b137AHWZJTrZswIzP8jE13AEU9iwBchYrvYpgJiIvGSPQRJeK7AAlyw4APpuCN43JX8
	SeBtj6kRyGCSRpeFVP5r2HV396h/GWn89JXWTeAERPOyQAMb6SlOzWcRm7/TgQlI11MJno
	QYrOFm7pTuWtnfAKFXi6DjP3KCazmic=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn;
	dmarc=none
Received: from ubt.. (unknown [210.73.43.101])
	by APP-03 (Coremail) with SMTP id rQCowABnsXvsLMpojtxAAw--.607S2;
	Wed, 17 Sep 2025 11:37:17 +0800 (CST)
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
To: linux-riscv@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Conor Dooley <conor@kernel.org>,
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
Subject: [PATCH V13 0/6] riscv: mm: Add soft-dirty and uffd-wp support
Date: Wed, 17 Sep 2025 11:36:57 +0800
Message-Id: <20250917033703.1695933-1-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABnsXvsLMpojtxAAw--.607S2
X-Coremail-Antispam: 1UD129KBjvJXoW3Wr18CrW3AF1rtw1rZFWDurg_yoW7AFy5pF
	4UGry3tr4rtF1Ig393Jw109a1Yqan5t343Gw1rX34rA3y2k3Wjvrna9a1rGF1DJr48WryS
	qryYkr9I934qyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9vb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I
	8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
	64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8Jw
	Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkI
	wI1lc7CjxVAaw2AFwI0_GFv_Wrylc2xSY4AK67AK6r48MxAIw28IcxkI7VAKI48JMxC20s
	026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_
	JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14
	v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xva
	j40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JV
	W8JrUvcSsGvfC2KfnxnUUI43ZEXa7IUYS2MUUUUUU==
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiBwkIB2jJ8O30wgAAsL
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EBC32180004
X-Stat-Signature: f139qogrz3o8hcxp1x64dha45fuqgwdk
X-Rspam-User: 
X-HE-Tag: 1758080253-798809
X-HE-Meta: U2FsdGVkX194HQEUkHwLlnCE+RbejPAJyPebiWnyTMS+JuGaN0O91yx/p9J61bS1QKGBrfPs5S/ON9K5O+SV9QaHqFHib7spVy3A+GfkoJlOPSaE12RYuwLI5loY10/5ZKD/ep+9FOX2Z4bfJmAovtKFHYEtMFUHI7u2RtWoTnFGqLtoV+5R548REIdfip8xo2I1SluWQipjIM+m5ofFix3zDROEdBrfuDS9tc6S24fjshDyuPSst47i/PZwsI7Gx1c2n3IjnYlcY5nEbjXUdjulS0+Pp8mNpDNanr+krpOtE57SDBgUDudfAnLFgm+1mzZ3y5o+qq7O+qEJ3ysSSiTL4QYiD0GuMiMxSeOGJGIdn/f15Ux7gOFmRJ2UklnHfRFAK7KufdtsP4IWTRrXj0/aKUj5KiDR9zDn77JgyGxXTc7xCiXbX1hcrt4uAubnOXIn7lQ4ehgQGAhiGsYVk5qCCL53fgvFPycNMc/pV4ONhe9AkTER4mdRCF3P5vKFyjTwV48R7eFEK+1QYKsCdlBHBPq0LPuAHSqg/j9W9c811QARX9thcTlvqjk0BFKC2mLPn9g7lc5DgPNch4qUd0Oko4bunwX9PpwjXGKFVR4y0385hUcnGb3APrrowLwUxfTk7ntIE0eC72aKHaVYb+IX1Z4L+QoUZsqDKJ0OniMjepbjNk51f74UKO/dzpPevryq9tmEHZPw7rsJHYUvj6IQF9uv9J5OX2oTIpZuUVWhwaf/WXW6C114i625qntSdrLIg2zC15I0AEpo734ahFJib0XUYDBHI3NjnS1XjNmY3EOGExwni1SuD9DPj0DpwUjax/LSNvJwIPpMhkaCkmz8iVBE3OPYMGbYJVMqHq7YQ/u7G4rT4HpiOa1CkX4w6OtZlHduiW7/gFShRm/6EMneSQTLWZvYXu3WW1i8/TJmAHLtd1p1Du9hoyHZqezsXui6AJWnJFgXg+scGE+
 klb2xqBB
 XJlkqkxJSyjFOypJNBDuF9KoIotiFEd1nEO5VU+SpG4wsV3BLfv1vgxKBEque8SPWmzBmwFJreC5cL+rPSkJKtC/ME34f7v7tJTwTD2C2S20rEUqYlUe7nPguLsKDyvTOwmc+GfkUZMqXMkClKtQoYnEZ2L6IxVDGgrpN6QY6b/K7UtPm6to2shebdc1gFjXvZuGlIz/iSLnKjGqPq6Way6YFjcVLYLZ5OHg8leVsHDrczuay0YHCyGEQxgJg2Nj18B1NwQcZEUq45lpXHx8fRxrMY67kA72K0BB7DcVlbhKl1As=
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

This patchset applies on top of the lastest mm-new branch.

[1] https://github.com/riscv-non-isa/riscv-iommu/pull/543

V13:
- Rebase on mm-new branch;
- Fixed build errors;
- Add more exactly descriptions in commit message in patch 1-2;
- Replace '__always_inline' with 'inline' for uffd_supports_wp_markeruffd_supports_wp_marker();
- Add description to the extensions dt-binding in patch 6.

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
 include/linux/mm_inline.h                     |  12 +-
 include/linux/pgtable.h                       |  12 ++
 include/linux/userfaultfd_k.h                 | 114 ++++++++------
 mm/debug_vm_pgtable.c                         |  10 +-
 mm/huge_memory.c                              |  13 +-
 mm/internal.h                                 |   2 +-
 mm/memory.c                                   |   6 +-
 mm/mmap.c                                     |   6 +-
 mm/mremap.c                                   |  13 +-
 mm/userfaultfd.c                              |  10 +-
 mm/vma.c                                      |   6 +-
 mm/vma_exec.c                                 |   5 +-
 22 files changed, 365 insertions(+), 105 deletions(-)

-- 
2.34.1


