Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3077FF886B
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 17:17:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4680C6B008C; Mon, 27 Apr 2026 13:17:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43E646B0092; Mon, 27 Apr 2026 13:17:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 306806B0093; Mon, 27 Apr 2026 13:17:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B42B46B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:17:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 54C5F88E11
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:17:02 +0000 (UTC)
X-FDA: 84704991084.22.6B20131
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7E5CC80015
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:17:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U2+LLE02;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777310220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jhUiSYlSjWHWqHISdWgh0N8CQlPC2mYxEyllaCORLRs=;
	b=VyX9Vclrgu6wR/URfhXCzoR6LVGYNzwZVWZ7/7kXogzUZ7Le23llfctv4LwC+Ker3UqePV
	niJjkD2fBlLpowNOVkuUdXayjQIlZX9bFPvLgdWnJ5ZWD8w5PDl5MYKaTgxOGT7FX4x0nD
	l//ftpqD+rNxzcOmt84ObcBQmfyGQnY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777310220; a=rsa-sha256;
	cv=none;
	b=ggb28lBYOKlbS7H0NOnGYpYEyWAqfmx/Qh6jluko+V0XlW8nFqB/nx1Y3MYQZ1TrNnyq/s
	dOa85zPAnZncq/i/whOs6/M5I7jiDXv/mCRiNic+siwVDJ+imxQJvg/4izyXfkBpa7NI1Z
	gQf3aX+7v6jCfrMFyPT04AdwxwvsZWA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U2+LLE02;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0E7B742ACA;
	Mon, 27 Apr 2026 17:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87FE1C2BCB4;
	Mon, 27 Apr 2026 17:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777310218;
	bh=Gdo90UdOw5JDNcbBc6CTpgqBoS99tJWdzzhKt47HDkg=;
	h=From:To:Cc:Subject:Date:From;
	b=U2+LLE02v2RJdGrHn64GqYJdP4+hDdO9CRQcGon9U+fg19LBxhX5PBepS5h9HJCqe
	 szqGGe/Sn0Ja8ufrVfKBRayklpg7ZNqhD3AjlJFyhWTD2cy+E9nyVtxoXvU6RVePwS
	 nC/EKNFwPrGycTqEuaSwxvd9NLoS3iznsIjTk0KPgTVc+veLovfoR+uQQZvkXu6BEL
	 XY5HSP+s8CkmcaZnZCCWlv0qtPkuKqPRoos+3EvmYxD3lbF+eVbofOW/u0ribOc9N6
	 46gB4iCE7qS4DHXiu+LbPED9AO2rWWkmtG0xffEU92OaQJ+vWiy9PumgjbDE3AiKLE
	 isfjlgjrnrghg==
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
To: Yury Norov <ynorov@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Laight <david.laight.linux@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	linux-alpha@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-um@lists.infradead.org,
	dmaengine@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-fsi@lists.ozlabs.org,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	linux-wpan@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-staging@lists.linux.dev,
	linux-serial@vger.kernel.org,
	linux-usb@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	linux-fsdevel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	bpf@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-x25@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	linux-sound@vger.kernel.org,
	sound-open-firmware@alsa-project.org,
	linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-m68k@lists.linux-m68k.org,
	linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-sh@vger.kernel.org,
	linux-arch@vger.kernel.org
Subject: [RFC PATCH v1 0/9] uaccess: Convert small fixed size copy_{to/from}_user() to scoped user access
Date: Mon, 27 Apr 2026 19:13:41 +0200
Message-ID: <cover.1777306795.git.chleroy@kernel.org>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7253; i=chleroy@kernel.org; h=from:subject:message-id; bh=Gdo90UdOw5JDNcbBc6CTpgqBoS99tJWdzzhKt47HDkg=; b=owGbwMvMwCV2d0KB2p7V54MZT6slMWS+nxkaMinl/6P42P3bc0Qj3v7nk1G4YbGg/rEse+BPv 7e7BNgWdJSyMIhxMciKKbIc/8+9a0bXl9T8qbv0YeawMoEMYeDiFICJRDExMmwV0vIK89sWnHjX Y4WN3O+gaTyvmP0m2koKTvi9YNORsocM/wPkn2xoM0q8N63lWvLNy/m/speGuG7LLGiQ1I6bVSB dxgQA
X-Developer-Key: i=chleroy@kernel.org; a=openpgp; fpr=10FFE6F8B390DE17ACC2632368A92FEB01B8DD78
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7E5CC80015
X-Stat-Signature: o336wf1oq3d78prqzafrpck63cxqkjbp
X-Rspam-User: 
X-HE-Tag: 1777310220-574018
X-HE-Meta: U2FsdGVkX1+dnzFHu6V6UAIHhqOQntuPMCfUHdDnkvSDMHuu24zaNwpvRx98wun45sen1QxzvRKKUeiPHR0/vi9tE4D0QjgqHZnQA1kJLLDQ/lkJGndWca6ovdNvBf6wX58FX1nUq4notvl+b7eVBirKStk7KBwmD4+mRl8U14hzNV4BDTpSJV5oXdyVt2cuz4yYjpjIaJy9htQdVXA6WESrOKOHsKay+BdpI0Fos7jZ1+UsTGU1jUSbwktRD5R83Dkh02iEIrN72l+/+LPL0I6in5qsB5uodXicZ+TU9X5owWhftc+qpfC7rthIHy+Cov0DgkFxxD5G9jBOdx0qhTFM9iid4lB9GNbPV3XzA8UdBAe+ds6MawKVIGupsNWZtzqCx2tqIkQCAv2MYIv7SyRS4/01nviaKmOpBOcPXI0UpHWUNucxMEDrgaJy4i6U/iCO9WWRnbBCNjO/YggaxzlD5h8e7lDrOnPAJpHp/p/hjn1lTkgglImuly+j2H6FvmIAVmBPCzaiQzgXBksZDSaBjsNYHhMg8rgAT46j9GAtbqnwPmiOzfpz8gR49F1HQZeEiL3m3BGh0jOfQ8arBrFt2g/lb7315EbgERTPW/wVvv+eeHkfnUjw15uwGkJZo6BldfZJ8qgha3473bWf2jnFD8KzEkTbUdzfrCQ7soMJYKL41UM0O88yvDN8FvRdCPqqh738Tc6HisAqiK0PG31d4jjZ5VF+iiaoQikIZLqpqveqg1/FDR5RkgSr5BcfAav5T6KiQIKLANYm9BAYvN/9Mv+iYp59SMoqIV75qCjy9IcxUVhWOWeDqgI4ZZX4dOcgR0S//Uq8XmG9zwcUKKzXlFrj9Qi2bMCITBT2RAS2UGukdyEosQSY2bWpkr4Is+buvg4t991zx4+GllfxGp3nv9QsX0UtJ76RTIJ82vzc0ylRZRjcKj0xVocfkIj3xQsQ7cFwulr1J9eeM6O
 kS4za18z
 i7x7Y0fPndVkiDLVirtNRwD5ypH934LMgmzuY0E8jGlyKWbIG0HyYy6R0uEbSjItksUxrzppxntGLDwUn+QFIPSOpvIDKhD1gRf+cs/GIoBsXWTwgIckUOy5wppLNxm+mCsoWFHXsUdJH3jqFwNtb6QCpHD+fKaH3T+hVp5AJYFh66jTYEJCqjUnoVvxVxBXZQj2V3fxBcGEOPtQ7JjN2uhUWVXCH/eJfs0MQ1UsE1kEetk++oHKsrTQsEBiSV2Zv+rfzxzZfzgXyVelE//WMDn+U9UVpDdl+OGrtg8cyvX/TJBAeT7fvNyYyOS5x7JIgMvvc91CbCj7DEw4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A lot of copy_from_user() and copy_to_user() perform copies of small
fixed size pieces of data between kernel and userspace, and don't
care about partial copies.

copy_from_user() and copy_to_user() are big functions optimised for
copying large amount of data, with cache management, etc ... This is
often overkill for small copies that could just be inlined instead.

What makes things a bit more tricky is that those copy functions
are designed to handle partial copies in case of page fault. But among
the 6000 callers of those functions, only 2% really care about the
quantity of no-copied data that those functions return. All other ones
fails as soon as the returned value is not 0, returning -EACCESS.

So first step in this series is to introduce variants called
copy_from_user_partial() and copy_to_user_partial() which will be
called by the 2% users that care about the partial copy, then the
original copy_from_user() and copy_to_user() are changed to return
-EFAULT when the copy fails.

Then the second step is to implement copy of small fixed-size data
with scoped user access instead of calling the arch specific heavy
user copy functions.

Patch 5, can be split in different patches for each archicture or
subsystem, but let's get a first feedback and agree on the principle.

Christophe Leroy (CS GROUP) (9):
  uaccess: Split check_zeroed_user() out of usercopy.c
  uaccess: Convert INLINE_COPY_{TO/FROM}_USER to kconfig and reduce
    ifdefery
  x86/umip: Be stricter in fixup_umip_exception()
  uaccess: Introduce copy_{to/from}_user_partial()
  uaccess: Switch to copy_{to/from}_user_partial() when relevant
  uaccess: Change copy_{to/from}_user to return -EFAULT
  x86: Add unsafe_copy_from_user()
  arm64: Add unsafe_copy_from_user()
  uaccess: Convert small fixed size copy_{to/from}_user() to scoped user
    access

 arch/alpha/Kconfig                            |   1 +
 arch/alpha/kernel/osf_sys.c                   |   4 +-
 arch/alpha/kernel/termios.c                   |   2 +-
 arch/arc/include/asm/uaccess.h                |   3 -
 arch/arc/kernel/disasm.c                      |   2 +-
 arch/arm/include/asm/uaccess.h                |   2 -
 arch/arm64/include/asm/gcs.h                  |   2 +-
 arch/arm64/include/asm/uaccess.h              |  30 +++--
 arch/arm64/kernel/signal32.c                  |   2 +-
 arch/csky/Kconfig                             |   1 +
 arch/hexagon/include/asm/uaccess.h            |   3 -
 arch/loongarch/include/asm/uaccess.h          |   3 -
 arch/m68k/include/asm/uaccess.h               |   3 -
 arch/microblaze/include/asm/uaccess.h         |   2 -
 arch/mips/include/asm/uaccess.h               |   3 -
 arch/mips/kernel/rtlx.c                       |   8 +-
 arch/mips/kernel/vpe.c                        |   2 +-
 arch/nios2/include/asm/uaccess.h              |   2 -
 arch/openrisc/include/asm/uaccess.h           |   2 -
 arch/parisc/include/asm/uaccess.h             |   3 -
 arch/powerpc/Kconfig                          |   1 +
 arch/powerpc/kvm/book3s_64_mmu_hv.c           |   4 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c        |   4 +-
 arch/powerpc/kvm/book3s_hv.c                  |   2 +-
 arch/riscv/Kconfig                            |   1 +
 arch/riscv/kernel/signal.c                    |   2 +-
 arch/s390/include/asm/idals.h                 |   8 +-
 arch/s390/include/asm/uaccess.h               |   3 -
 arch/sh/include/asm/uaccess.h                 |   2 -
 arch/sparc/include/asm/uaccess_32.h           |   3 -
 arch/sparc/include/asm/uaccess_64.h           |   2 -
 arch/sparc/kernel/termios.c                   |   2 +-
 arch/um/include/asm/uaccess.h                 |   3 -
 arch/um/kernel/process.c                      |   2 +-
 arch/x86/Kconfig                              |   1 +
 arch/x86/include/asm/uaccess.h                |  29 ++++-
 arch/x86/kernel/umip.c                        |   2 +-
 arch/x86/lib/insn-eval.c                      |   2 +-
 arch/x86/um/signal.c                          |   2 +-
 arch/xtensa/include/asm/uaccess.h             |   2 -
 drivers/android/binder_alloc.c                |   2 +-
 drivers/comedi/comedi_fops.c                  |   4 +-
 drivers/dma/idxd/cdev.c                       |   2 +-
 drivers/firmware/efi/test/efi_test.c          |   2 +-
 drivers/fsi/fsi-scom.c                        |   2 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_debugfs.c |   2 +-
 drivers/gpu/drm/i915/gt/intel_sseu.c          |   4 +-
 drivers/gpu/drm/i915/i915_gem.c               |   4 +-
 drivers/hwtracing/intel_th/msu.c              |   2 +-
 drivers/misc/ibmvmc.c                         |   2 +-
 drivers/misc/vmw_vmci/vmci_host.c             |   2 +-
 drivers/most/most_cdev.c                      |   2 +-
 drivers/net/ieee802154/ca8210.c               |   4 +-
 drivers/net/wireless/ath/wil6210/debugfs.c    |   2 +-
 .../intel/iwlwifi/pcie/gen1_2/trans.c         |   2 +-
 drivers/net/wireless/ti/wlcore/debugfs.c      |   2 +-
 drivers/ps3/ps3-lpm.c                         |   2 +-
 drivers/s390/crypto/zcrypt_api.h              |   4 +-
 drivers/spi/spidev.c                          |   2 +-
 .../staging/media/atomisp/pci/atomisp_cmd.c   |   8 +-
 drivers/tty/tty_ioctl.c                       |  14 +--
 drivers/tty/vt/vc_screen.c                    |   4 +-
 drivers/usb/gadget/function/f_hid.c           |   4 +-
 drivers/usb/gadget/function/f_printer.c       |   2 +-
 drivers/vfio/vfio_iommu_type1.c               |   4 +-
 drivers/xen/xenbus/xenbus_dev_frontend.c      |   2 +-
 fs/namespace.c                                |   2 +-
 fs/ocfs2/dlmfs/dlmfs.c                        |   2 +-
 fs/proc/base.c                                |   4 +-
 include/asm-generic/uaccess.h                 |   2 -
 include/linux/bpfptr.h                        |   2 +-
 include/linux/sockptr.h                       |   4 +-
 include/linux/uaccess.h                       | 107 ++++++++++++++----
 ipc/msg.c                                     |   8 +-
 ipc/sem.c                                     |   8 +-
 ipc/shm.c                                     |  18 +--
 kernel/regset.c                               |   2 +-
 kernel/sys.c                                  |   4 +-
 lib/Kconfig                                   |   3 +
 lib/Makefile                                  |   4 +-
 lib/kfifo.c                                   |   8 +-
 lib/{usercopy.c => usercheck.c}               |  22 ----
 lib/usercopy.c                                |  66 -----------
 mm/kasan/kasan_test_c.c                       |   4 +-
 mm/memory.c                                   |   2 +-
 net/x25/af_x25.c                              |   2 +-
 rust/helpers/uaccess.c                        |   6 +-
 sound/pci/emu10k1/emufx.c                     |   4 +-
 sound/pci/rme9652/hdsp.c                      |   6 +-
 sound/soc/intel/avs/probes.c                  |   6 +-
 sound/soc/sof/compress.c                      |  12 +-
 sound/soc/sof/sof-client-probes.c             |   6 +-
 92 files changed, 269 insertions(+), 288 deletions(-)
 copy lib/{usercopy.c => usercheck.c} (73%)

-- 
2.49.0


