Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4B20CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 10:40:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29424940008; Fri,  5 Sep 2025 06:40:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 244A1940007; Fri,  5 Sep 2025 06:40:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 180D0940008; Fri,  5 Sep 2025 06:40:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 05BA7940007
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 06:40:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B2EEE1DF132
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:40:34 +0000 (UTC)
X-FDA: 83854852788.28.C0AE0AA
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8851A40031
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:37:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757068655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=CIxi/r8hk9RTOiEb1wyaoiQN3FohbuoT/n9fvIoH0zI=;
	b=y0Q18WIAedUyLR0yUDdWrEtOjEYVSfRcm4cmoRFMNzc8wlZosXnmzjhPuLX+bw9ygDXNXB
	ld/3hpRZveIU5kbXeZNAxsisqf5dJ33xsgAkXhucThJ+caSn572bVfet3nxObP9PEo+SA7
	c09PjPvGB1Ys2aMirDFDzLrMkTTlElw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757068655; a=rsa-sha256;
	cv=none;
	b=giUBc1oAud/DC84zdmCYVc8lNBHFFj/GHB+ESJ1004+cHz4pZmi59Fndf4uRrdSGdc+NiT
	E3T06YoKzfY4HPBQ3oFzt/PbLEWAdwfK+7p6IUaMgDMUnD7c6LgP4m7qa7OAzs/KKGwClW
	v7/OTh8lC1gXSQPJkk5wm0NpS8+0RYA=
Received: from ubt.. (unknown [210.73.43.101])
	by APP-01 (Coremail) with SMTP id qwCowABnwaNMvbpoocLNAA--.50311S2;
	Fri, 05 Sep 2025 18:37:01 +0800 (CST)
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
To: linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Morton <akpm@linux-foundation.org>,
	Deepak Gupta <debug@rivosinc.com>,
	Ved Shanbhogue <ved@rivosinc.com>,
	Peter Xu <peterx@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Jan Kara <jack@suse.cz>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@redhat.com>,
	Chunyan Zhang <zhang.lyra@gmail.com>
Subject: [PATCH v9 0/5] riscv: mm: Add soft-dirty and uffd-wp support
Date: Fri,  5 Sep 2025 18:36:46 +0800
Message-Id: <20250905103651.489197-1-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowABnwaNMvbpoocLNAA--.50311S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWw47ZF48Kr17Jr1rJryxKrg_yoW5Wr18pF
	s8K343KryrJFyIyrs3C34jkF1Fqa1kW34rGa43J3s5J3yagF1jvrn5C3W8KF18JF48uFWS
	9ry5uryru3yqy3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvlb7Iv0xC_KF4lb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4
	A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
	w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r4j6F4UMc
	vjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xK
	xwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJV
	W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
	1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
	IIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
	x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvj
	DU0xZFpf9x07j9gAwUUUUU=
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiCRAQB2i6ooVpxgAAsU
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8851A40031
X-Stat-Signature: fhdn1hd44je6n3ukxfshbjuz8rqwwga7
X-Rspam-User: 
X-HE-Tag: 1757068654-670199
X-HE-Meta: U2FsdGVkX18glJ062q9DwhsaVZLtSGtrZwaDcbhRQzHvGrI8s6O9Wi2k6Ey7viJwqCE828gWMYwAXxBVcCAFFCPGl75dhIjkkQp2yxMVxL0fA7GZ1chQcVH0glMXTryNe8lYVM997ROzAhu0Zyl2zAVtJMQyHwisqZyDxgVpjb9HTK8Sg6jae+uKC+xA+D+CVGtWvb+Yk9LmGfgwM7ewg/vA065MS39WZagd984oaMfNHZYo+i+v5q/iqCpkpYqQbhKjNxgr76Jtrhy4UKHrdKRb08fRjD7c1sem4eKnJu89qeEhDuFMX4FNM+5TLbNgiDJEcZ5wpJTROtgsi9C8UHsq8CYvKpGsXLSnLzsZOGFt9X3WT1eSRceTzWCkjocJdeHVHxhpP+1rS7oOQ/1gBu6OnljeJtBJYToqAjMDc8uXGfFgRmiULX/BwHHAphqaULAbVFClMFhIhJLfmKA8QMmRGAMW1McOeLLd6IoJVXRqmtpx9v2dsJbA0wfE4cX5Md6a+ZI76MuU1Gkuam8WP1Te3f2QrfugaUb6LIkB5XjX/3iNxPzFLQQj73KRBcNIyIlkRgfMvCzlxDi/WrleocR1cDEpYvs4aUNHkGiSQQCexzNn4BcnLT0hk91LD8Oia43pI1pS9ADk+5P1yzzR1dmkFEyNfiJUySnl8wXcWVv3JYfwMCzXBYIEItsVbDM7a3cW4L6OkEFGIvdGhzCKwrMbTG68TF6ZNjuMBJuKo812UQyluyFjWSeNCgxAV9wP0sY75uIOyOedMPLM819VDaHLK5Ky82IIrDYFOfzRvoC1xUYf/6pg9sqLf8fNmtERHLIF/HuNaTw8iWSS636tiux92/oeUeyBj8egT/MoWXEdkwhHyy8qlaq6F8nYAVh8TMtHRKieACquDBbZZDDBrzGnrQSv56UyXAr/sMupSuOwC4/oxvQDUvjrIFQTizeQweXnygcPcOyhUWCUq8m
 K7OIUzdn
 uW4mxKqIQa9oC1O4/p+uEy5L9XqN8cHZa6MRBdrTp7wgk0PwnAXriL6w7wRmpei3mxsb0f9XeKb37LzFg9TpY0feVuealIbsC49cMIdb56kXNHdh+ED1+DlbW+pK/9b4nqSeG/15Kx/JFRTAaSLD+5UcEVYbKAuemFbNyR82YgTlM6WJ7RkOXtQLG7dciZUx2eJDv/jDmp47EOvgKtbeELFXxNi+NkXGRv36OI9nZN524fXyVjJTu5WQ7dPZxzxIh+TNF5C2JqQDsOwqxqg0E87G8UDjKvYYQRbDxFxFZOHZnZ2k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset adds support for Svrsw60t59b [1] extension which is ratified now,
also soft dirty and userfaultfd write protect tracking for RISC-V.

This patchset has been tested with kselftest mm suite in which soft-dirty, 
madv_populate, test_unmerge_uffd_wp, and uffd-unit-tests run and pass,
and no regressions are observed in any of the other tests.

This patchset applies on top of v6.17-rc4.

V9:
- Add pte_soft_dirty/uffd_wp_available() API to allow dynamically checking
  if the PTE bit is available for the platform on which the kernel is running.

V8: (https://lore.kernel.org/all/20250619065232.1786470-1-zhangchunyan@iscas.ac.cn/)
- Rebase on v6.16-rc1;
- Add dependencies to MMU && 64BIT for RISCV_ISA_SVRSW60T59B;
- Use 'Svrsw60t59b' instead of 'SVRSW60T59B' in Kconfig help paragraph;
- Add Alex's Reviewed-by tag in patch 1.

V7: (https://lore.kernel.org/all/20250409095320.224100-1-zhangchunyan@iscas.ac.cn/)
- Add Svrsw60t59b [1] extension support;
- Have soft-dirty and uffd-wp depending on the Svrsw60t59b extension to
  avoid crashes for the hardware which don't have this extension.

V6:
- Changes to use bits 59-60 which are supported by extension Svrsw60t59b
  for soft dirty and userfaultfd write protect tracking.

V5:
- Fixed typos and corrected some words in Kconfig and commit message;
- Removed pte_wrprotect() from pte_swp_mkuffd_wp(), this is a copy-paste
  error;
- Added Alex's Reviewed-by tag in patch 2.

V4:
- Added bit(4) descriptions into "Format of swap PTE".

V3:
- Fixed the issue reported by kernel test irobot <lkp@intel.com>.

V1 -> V2:
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
 fs/proc/task_mmu.c                    |  12 ++-
 fs/userfaultfd.c                      |  25 +++--
 include/asm-generic/pgtable_uffd.h    |  12 +++
 include/linux/mm_inline.h             |   6 +-
 include/linux/pgtable.h               |  10 ++
 include/linux/userfaultfd_k.h         |  44 +++++---
 mm/debug_vm_pgtable.c                 |   9 +-
 mm/huge_memory.c                      |  13 +--
 mm/internal.h                         |   2 +-
 mm/memory.c                           |   6 +-
 mm/mremap.c                           |  13 +--
 mm/userfaultfd.c                      |  12 +--
 17 files changed, 302 insertions(+), 57 deletions(-)

-- 
2.34.1


