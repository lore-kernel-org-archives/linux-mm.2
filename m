Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C65E6CAC589
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:57:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C1846B00AE; Tue,  9 Sep 2025 05:57:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 298C58E0019; Tue,  9 Sep 2025 05:57:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AEE88E0017; Tue,  9 Sep 2025 05:57:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07A196B00AE
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:57:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A7A3986518
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:57:10 +0000 (UTC)
X-FDA: 83869258620.02.00FC6CD
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	by imf20.hostedemail.com (Postfix) with ESMTP id 75A201C0016
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:57:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757411829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=vUdk+zhgmPM3iyY1jwLFKXfR4Zw8zzJ2yl4hRNH0lhU=;
	b=TmkfhEjVp6TCjHW4vNeTsa+GgqawVBvoOVbCY5x/8wCVMMNNqkNGTXTzgV2Ec0a16wd000
	g1Xq7fRem6wyXVRXPiUNG2pgH4IcvB0ZAjmolJt/BwhMZgg7wKGzYchMfl+BqUp+uWNdcI
	+vFNtJGT3gWQIR7ViTf/TieVP4JNHws=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757411829; a=rsa-sha256;
	cv=none;
	b=Us2L9cG06SxJk5/wvigiY2BomT3hTfCpKml/h1qUW7OD6HHsHUtyIFHqmdDx9xOESYU/ex
	PFL93MqzvyEUBJnKM+34oGdWxxMLMBnvFVsMcmUUBJBlQoSs2xa0Ol9zfa05EOvehCSKe4
	gDfaijEBWFxexU0HXJSw0j/ViXpolUM=
Received: from ubt.. (unknown [210.73.43.101])
	by APP-01 (Coremail) with SMTP id qwCowADHHqHO+b9oWh7qAQ--.61766S2;
	Tue, 09 Sep 2025 17:56:32 +0800 (CST)
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
Subject: [PATCH V10 0/5] riscv: mm: Add soft-dirty and uffd-wp support
Date: Tue,  9 Sep 2025 17:56:06 +0800
Message-Id: <20250909095611.803898-1-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowADHHqHO+b9oWh7qAQ--.61766S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWw4xJr1ruF1fZFW7ury8Xwb_yoW5Kw1UpF
	s8K343tr45tryIgws3Ww1j9a1jqan5Gw1rC345J34rA3ya9F1jvrnY9w48GF1DJF4UWryS
	qrWakryq934qyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9vb7Iv0xC_KF4lb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I
	8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
	64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVW8JVWxJw
	Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkI
	wI1lc7CjxVAaw2AFwI0_GFv_Wrylc2xSY4AK67AK6r4fMxAIw28IcxkI7VAKI48JMxC20s
	026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_
	JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14
	v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xva
	j40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JV
	W8JrUvcSsGvfC2KfnxnUUI43ZEXa7IUngzVUUUUUU==
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiCQ8AB2i-pw8OnwABsu
X-Stat-Signature: 98k95ymd8i7xbj8mtu9untq8m5w6473c
X-Rspam-User: 
X-Rspamd-Queue-Id: 75A201C0016
X-Rspamd-Server: rspam04
X-HE-Tag: 1757411828-896767
X-HE-Meta: U2FsdGVkX19x63joO/o/2cx3grgTIvxbEuzmMzq8H29vnemv3esxewyvTEedSSHbeCB06C5t6gNxQ/7QxHEAfK2+vynygASR1/71UUf7c6v7CBrUBq5q9s2gusNoKR6Y6YUxAcMVz5fHGR0CW319ptmO8ijYKkVBsvk4eVtRLEcjRsi/ppk2marZRDPihnukDHqX4Jg0/tDJAyRxOBQJDSBBy/94l8oSO2e0CWx18Jd3bAb2xUZ5ADOIpG631390riUgAyz6XidB1fiurjuFRNhA4hvW09D1R5utrS6P7tV8ujV9v7aVAn+AjU03tIO9xaSFjyuwkJOu1M6472bX6qNGuxxXxrDHbqvVafz3iwmOVDfa6lQjndKeVz+WQUzqodPcJMjEXx3SmoUksZGyR+al0Hxsenqiw9QthY2uaSbot/r2wkJNJDA4blPLXoqweStg0etX0VtZybsAGtTowETJzkZYEVPbkiR91Sn435yx7wIdIrM3I9NHReC9G6Ttb9FRq5ln6IbwFwv9ptYNOiI00iDWcu4r9JRwoXY83IRf8C2LWamxO2kSXeIBm2G0mCN+XzmM//09/75Gu/Jh8ptcib43d68/VXjUBzd8/ISvxG5oHIlpNtUgpbUo3kzV7CBl0nsrumVSqpTIg+uOz+ApjslkqliLquWqTTjez3CMzvkSi+CzhlPZruHW7wdfkf72FelkawCw/HdOpAe7D120pl9AufPYW4JkBJR63QdqIEy/G98hDnnQU1DCwZAGrPJZ5bidC65p1n/dK3HtWIdLhF2T4rbnlnIhK+AHu2kgCkmauuBzickxswO1dcK8MeKxDeVOWjEa8z2hwXjvS6LN0u44YDTLf8nYsiGtVP/XFrLohyZVS8OLhoyZwMpgj0KflYnpgbYZzakhcFecymQjmdZ2oiCY3LkKEpuNwrzmCPXSWDoegCUiGjQUSLtMUr2WiV3ta5Z2hnOlR3o
 kUKJ2mX0
 ybIRO3yJZxluWgSu8vRgZX9ah1WEPy0duQZFop3aL5sFOm1+2vMBCxsR7FIWogUXyjsGJqjLUamrPIXS2GfSXCGUYrzmDn5JJlozvaTGf21ORzhAW5RXQcLAU1ESj7lKATbWpgy/Ga2WrvLdCCtgaA0mhaVxRV8F/QZuxZusUHV0B2ZMbCiHuJ08PhXETFH4EBRh9kxvzMJEqY9XxAbYGSYkMA1QODLs+yPU28ryZIpZKbR/5n0LFVPUbbaEN8g3HCEizgZ/e/fK3wL+inOSvrZK/Wc0M3Ie0XwxiIB/F3iVFkAM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset adds support for Svrsw60t59b [1] extension which is ratified now,
also soft dirty and userfaultfd write protect tracking for RISC-V.

The patches 1 and 2 add macros to detect if the soft-dirty / uffd_wp PTE bits
are available, in other words, the Svrsw60t59b extension is supported for the
RISC-V device on which the kernel is running.

This patchset has been tested with kselftest mm suite in which soft-dirty, 
madv_populate, test_unmerge_uffd_wp, and uffd-unit-tests run and pass,
and no regressions are observed in any of the other tests.

This patchset applies on top of v6.17-rc4.

V10:
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

[1] https://github.com/riscv-non-isa/riscv-iommu/pull/543

Chunyan Zhang (5):
  mm: softdirty: Add pte_soft_dirty_available()
  mm: uffd_wp: Add pte_uffd_wp_available()
  riscv: Add RISC-V Svrsw60t59b extension support
  riscv: mm: Add soft-dirty page tracking support
  riscv: mm: Add uffd write-protect support

 arch/riscv/Kconfig                    |  16 +++
 arch/riscv/include/asm/hwcap.h        |   1 +
 arch/riscv/include/asm/pgtable-bits.h |  37 +++++++
 arch/riscv/include/asm/pgtable.h      | 140 +++++++++++++++++++++++++-
 arch/riscv/kernel/cpufeature.c        |   1 +
 fs/proc/task_mmu.c                    |  17 +++-
 fs/userfaultfd.c                      |  25 +++--
 include/asm-generic/pgtable_uffd.h    |  12 +++
 include/linux/mm_inline.h             |   7 ++
 include/linux/pgtable.h               |  10 ++
 include/linux/userfaultfd_k.h         |  44 +++++---
 mm/debug_vm_pgtable.c                 |   9 +-
 mm/huge_memory.c                      |  10 +-
 mm/internal.h                         |   2 +-
 mm/memory.c                           |   6 +-
 mm/mremap.c                           |  10 +-
 mm/userfaultfd.c                      |   6 +-
 17 files changed, 306 insertions(+), 47 deletions(-)

-- 
2.34.1


