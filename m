Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90988CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 13:33:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0355E6B008C; Thu, 21 May 2026 09:33:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F29706B0092; Thu, 21 May 2026 09:33:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF0576B0093; Thu, 21 May 2026 09:33:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CBBB66B008C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:33:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9292E1C04EB
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:33:29 +0000 (UTC)
X-FDA: 84791518938.29.0E82401
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id DC2084000C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:33:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ENRvP//N";
	spf=pass (imf12.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779370408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JMvTXrLi2fecyuCzobJPBmjEJITlU0vYIW862WydbuI=;
	b=CzBXZop7jEKvIan8v4Hk5wkUWXE1Z03iCOHJbvBqO99n/TSGSSKnn4EsAAEAv/1gk2brwP
	z54SXK0lFX3DFqDGmIofwfmcBfrn4POb/0NyQE+TQE4sNSDLjFMrNbsVRaSXmR3qAxLphl
	Es01S1AyfHszRJ96270Jhyiaasqj+yo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ENRvP//N";
	spf=pass (imf12.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779370408; a=rsa-sha256;
	cv=none;
	b=aQ3iO+uYbdmjLqc9e0YiqLDH9d6iOrck1TVvgvd8aMmVJ1TCwWgy/UvbRhWaUxkofNsgty
	zioZqShM6g08TWIRjesB+rJojKk8LhfmIsyC+b9lkcIPnOL7fm/ZE9HMZp8Yw86qrGnK/P
	JqHx+S1XtqV+KvqVyaizTutCRC1sGyw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8231B445D2;
	Thu, 21 May 2026 13:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FA81F00A3B;
	Thu, 21 May 2026 13:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779370406;
	bh=JMvTXrLi2fecyuCzobJPBmjEJITlU0vYIW862WydbuI=;
	h=From:To:Cc:Subject:Date;
	b=ENRvP//NxlPse9MxCJOFh1AogZslAel87SB2mSCIhsf3jItcOS+woGIBwiFJXxxJO
	 /vrcLfGb5f9Zgybo+8/jwPpcfxzDdtk9qobrtYv1Jx7qF2CaHOv9To+pMFVf+CxBaj
	 Txk/IJPdMMNkgGbRiVQjeh8OyeTtBQ2jV3/sTZSlJcvRZB5VWyLoc9rDPU3aPLI4HL
	 h0jOm1f2w6p8YOUlM5pSaTCh9uIPDhngu0K2kHqivFsRg/751UQV/kKlDAKhtjc0hL
	 ruCH8xG0ElU6V7TuBi+cEWySHRlk4t3CmGbCJy8V2gQGUgE/wtg5mB81jG8Jj8LiQq
	 dMkB09LzsXQtw==
From: Kees Cook <kees@kernel.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Corey Minyard <corey@minyard.net>,
	Gabriel Somlo <somlo@cmu.edu>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Bart Van Assche <bvanassche@acm.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hansg@kernel.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Jason Baron <jbaron@akamai.com>,
	Jim Cromie <jim.cromie@gmail.com>,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Benjamin Berg <benjamin.berg@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"David E. Box" <david.e.box@linux.intel.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Vinod Koul <vkoul@kernel.org>,
	Frank Li <Frank.Li@kernel.org>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	John Johansen <john.johansen@canonical.com>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Georgia Garcia <georgia.garcia@canonical.com>,
	kvm@vger.kernel.org,
	dmaengine@vger.kernel.org,
	linux-modules@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	apparmor@lists.ubuntu.com,
	linux-security-module@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-acpi@vger.kernel.org,
	openipmi-developer@lists.sourceforge.net,
	qemu-devel@nongnu.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-serial@vger.kernel.org,
	linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH 00/11] Convert moduleparams to seq_buf
Date: Thu, 21 May 2026 06:33:13 -0700
Message-Id: <20260521133315.work.845-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8383; i=kees@kernel.org; h=from:subject:message-id; bh=iRiRSOifqAhDEW+rM5ucutf2vqbqOCl0n39wA2pC2nE=; b=owGbwMvMwCVmps19z/KJym7G02pJDFn8nPP5NjJqfrXdrfdzgRzzhL0cEUvVFLTFyz0Emuo2S cuk+1zsKGVhEONikBVTZAmyc49z8XjbHu4+VxFmDisTyBAGLk4BmMjpjYwMW1sezs9aJ6S4pvfM 9cD7+tJ32F5enlDXEpZXkNZ/g4mVnZFh3zrv5UmSl4OP8839kFvnc/3g3qNPdE9ob/yzv04h4/U XTgA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DC2084000C
X-Stat-Signature: fo7rqp774pmhdhiwsczyrpoi3c7iypzz
X-HE-Tag: 1779370407-27061
X-HE-Meta: U2FsdGVkX1+SMVDG/5XkgxB9pzJ28TEA7HIid0eTPywjRaHsQb7icXIRHOdWFk4vek6Co2rAd609j0ol5f9+iDYsPQfLD+d+Cv2VWS6U3KP9aze3+vhAHQVVDFwVz3mV4HHPze8Jrt//S54KfSEwsxjiLuDbEcG6yWmRCbOs3/k3g6lzWsW60dfYWDSzLifcBn14rJgXuiaYrvg0f7PcxrHl/MKjMLNrliVUul55u/PTYBMCoPCAMqiehPsXt/q7n9VXMOwINXUd/xB5dtmKfmQj660JbCJch6Tuhmk/gmdtKcQveyltZFQcZfLVf6mA9j0AwfeNZu9hcETyZNrp6TC0np1v+/q0qanvHJvAYS1zOrXYR7X+ox2kLMuOQ9f59U6HsHQG3EypZtoMdrv+ock7o++/5iNBdSG/FD2bD7+Lp/F2PHxGNYf2M1CcRIfzdGjkwNXZZv6aqJxPI2sHHh1qliHHwABoIJjt8ieBIkIBIllFBpk7dk+p+HtmCfSPMgrqNd61DtSlBHmO/3pinRzR3965Y/Su+MSdo3oQxuOAo2YocJBlQerkJbKCLiqBnDRSmGayo1p7XxZZsnrShYa8KXlA4CiB0/vd2a3iU/EDAfmw+KJbTGnXHEewwBfGTbdQUMMTqP++n3cBdfOv8yDIddbn6zTAdst0tu8UCib/kycT71qItO/7K4lzW4UHjMErZPuSKMsqmzbdAt2LoU7BOZgzAr/fTW+Tp9VJlXr7vKlmZ+1E/z7SX4mFEdm45ijDkgNZI4Q+sL7SZFwPJrMMsPUw8IJhiLijj/5c4YkgxkVtKFznNkgJfXabfmYz7Gb+SC/NTtwlWvdz7kNqS7COUn+yldIIUzqvWavigZ44ims4nAc0fI9+Mgfu0rbJrfj5lnUKhdvYGW931ztktw2MvkDieUasxkxhA0Ix853NuKxzrk8q8k7OEHZ7q043JHJZlkwGF2EQbAbwxcZ
 uSsr2006
 rlrrhn8hO4oRqKbQVQp33UEKj5IFiAihcZwoPFs+33nvoPRCpgdrrO3o0X/x935901bGYGQYpcZcNO/XUcqNUD+3qZnfdYnZi5InAzYZnlF9Zlzi15KNTwDDyBOqkRXDY4XPQAi//Tudc6Yjnigio7A9qpTGTvpdtQ0tPkOEdjFTbHpc+/Bj6nZwUFAcqrgWRG0r8C6G26KuYKNXfcIKxVr1yXDH7N/ePrqADCHDrmQvbI++TsCRgpfyczhcjlV510etcaeS1YjN+AWARSojNuAzXxxDgZFNwGphNErf9c8OqfHJ2KSz7PJnHvHaIZFSjCy0KKkNyGhy8tnQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I tried to trim the CC list here, but it's still pretty huge...

We've had a long-standing issue with "write to a string pointer" callbacks
that don't bounds check the destination (and for which the bounds is
also not part of the callback prototype, even if it is "known" to be
PAGE_SIZE, which sysfs_emit() depends on). Both moduleparams and sysfs
use this pattern. As a first step, and to test the migration method,
migrate moduleparams first.

There are 2 "mechanical" treewide patches that are handled by Coccinelle:
- treewide: Convert struct kernel_param_ops initializers to DEFINE_KERNEL_PARAM_OPS
- treewide: Convert custom kernel_param_ops .get callbacks to seq_buf via cocci

The last treewide patch is manual, and may need to be broken up into
per-subsystem patches, though I'd prefer to avoid this, as it would
extend the migration from 1 relase to at least 2 releases. (1 to
release the migration infrastructure, then 1 release to collect all the
subsystem changes, and possibly 1 more release to remove the migration
infrastructure.)

Thoughts, questions?

-Kees

Kees Cook (10):
  panic: Replace panic_print_get() with generic helper
  moduleparam: Add DEFINE_KERNEL_PARAM_OPS macro family
  treewide: Convert struct kernel_param_ops initializers to
    DEFINE_KERNEL_PARAM_OPS
  moduleparam: Rename .get field to .get_str
  moduleparam: Add seq_buf-based .get callback alongside .get_str
  moduleparam: Route DEFINE_KERNEL_PARAM_OPS get pointer via _Generic
  params: Convert generic kernel_param_ops .get helpers to seq_buf
  treewide: Convert custom kernel_param_ops .get callbacks to seq_buf
    via cocci
  treewide: Manually convert custom kernel_param_ops .get callbacks
  moduleparam: Drop legacy kernel_param_ops .get_str field and dispatch
    logic

Pengpeng Hou (1):
  params: bound array element output to the caller's page buffer

 include/linux/dynamic_debug.h                 |   8 +-
 include/linux/moduleparam.h                   |  65 +++++++---
 security/apparmor/include/lib.h               |   3 +-
 mm/kfence/core.c                              |  15 ++-
 arch/powerpc/kvm/book3s_hv.c                  |   5 +-
 arch/s390/kernel/perf_cpum_sf.c               |  12 +-
 arch/um/drivers/vfio_kern.c                   |   9 +-
 arch/um/drivers/virtio_uml.c                  |  18 +--
 arch/x86/kernel/msr.c                         |  11 +-
 arch/x86/kvm/mmu/mmu.c                        |  28 ++--
 arch/x86/kvm/svm/avic.c                       |  14 +-
 arch/x86/kvm/vmx/vmx.c                        |  24 ++--
 arch/x86/platform/uv/uv_nmi.c                 |  24 ++--
 block/disk-events.c                           |   6 +-
 drivers/acpi/button.c                         |  19 ++-
 drivers/acpi/ec.c                             |  14 +-
 drivers/acpi/sysfs.c                          | 114 ++++++++--------
 drivers/block/loop.c                          |  12 +-
 drivers/block/null_blk/main.c                 |  12 +-
 drivers/block/rnbd/rnbd-srv.c                 |   6 +-
 drivers/block/ublk_drv.c                      |  12 +-
 drivers/char/ipmi/ipmi_msghandler.c           |  12 +-
 drivers/char/ipmi/ipmi_watchdog.c             |  50 +++----
 drivers/crypto/hisilicon/hpre/hpre_main.c     |  16 +--
 drivers/crypto/hisilicon/sec2/sec_main.c      |  23 +---
 drivers/crypto/hisilicon/zip/zip_crypto.c     |   5 +-
 drivers/crypto/hisilicon/zip/zip_main.c       |  21 +--
 drivers/dma/dmatest.c                         |  34 ++---
 drivers/edac/i10nm_base.c                     |   6 +-
 drivers/firmware/efi/efi-pstore.c             |   6 +-
 drivers/firmware/qcom/qcom_scm.c              |  18 +--
 drivers/firmware/qemu_fw_cfg.c                |  40 +++---
 drivers/gpu/drm/drm_panic.c                   |  13 +-
 drivers/gpu/drm/i915/i915_mitigations.c       |  31 ++---
 drivers/gpu/drm/imagination/pvr_fw_trace.c    |   6 +-
 drivers/hid/hid-cougar.c                      |   6 +-
 drivers/hid/hid-steam.c                       |   6 +-
 drivers/infiniband/hw/hfi1/driver.c           |  12 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c      |   6 +-
 drivers/infiniband/ulp/isert/ib_isert.c       |   6 +-
 drivers/infiniband/ulp/srp/ib_srp.c           |  12 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c         |   5 +-
 drivers/input/misc/ati_remote2.c              |  23 ++--
 drivers/input/mouse/psmouse-base.c            |  15 ++-
 drivers/md/md.c                               |   5 +-
 drivers/media/pci/tw686x/tw686x-core.c        |   6 +-
 drivers/media/usb/uvc/uvc_driver.c            |  14 +-
 drivers/misc/lis3lv02d/lis3lv02d.c            |   5 +-
 drivers/net/wireless/ath/wil6210/main.c       |  10 +-
 drivers/nvme/host/multipath.c                 |  17 +--
 drivers/nvme/host/pci.c                       |  18 +--
 drivers/nvme/target/rdma.c                    |   5 +-
 drivers/nvme/target/tcp.c                     |   5 +-
 drivers/pci/pcie/aspm.c                       |  17 ++-
 drivers/platform/x86/acerhdf.c                |   5 +-
 drivers/power/supply/bq27xxx_battery.c        |   6 +-
 drivers/power/supply/test_power.c             | 122 +++++++++---------
 drivers/scsi/fcoe/fcoe_transport.c            |  22 ++--
 drivers/scsi/sg.c                             |   6 +-
 drivers/target/target_core_user.c             |  25 ++--
 .../processor_thermal_soc_slider.c            |  24 ++--
 drivers/thermal/intel/intel_powerclamp.c      |  34 ++---
 drivers/tty/hvc/hvc_iucv.c                    |  24 ++--
 drivers/tty/sysrq.c                           |   6 +-
 drivers/ufs/core/ufs-fault-injection.c        |  12 +-
 drivers/ufs/core/ufs-mcq.c                    |  18 +--
 drivers/ufs/core/ufs-txeq.c                   |   5 +-
 drivers/ufs/core/ufshcd.c                     |  12 +-
 drivers/usb/core/quirks.c                     |   6 +-
 drivers/usb/gadget/legacy/serial.c            |   5 +-
 drivers/usb/storage/usb.c                     |  25 ++--
 drivers/vhost/scsi.c                          |  12 +-
 drivers/virt/nitro_enclaves/ne_misc_dev.c     |   6 +-
 drivers/virtio/virtio_mmio.c                  |  27 ++--
 fs/ceph/super.c                               |  10 +-
 fs/fuse/dir.c                                 |   5 +-
 fs/nfs/namespace.c                            |  12 +-
 fs/nfs/super.c                                |   6 +-
 fs/ocfs2/dlmfs/dlmfs.c                        |   5 +-
 fs/overlayfs/copy_up.c                        |   5 +-
 fs/ubifs/super.c                              |   6 +-
 kernel/locking/locktorture.c                  |  12 +-
 kernel/panic.c                                |  11 +-
 kernel/params.c                               | 122 +++++++++---------
 kernel/power/hibernate.c                      |   6 +-
 kernel/rcu/tree.c                             |  24 ++--
 kernel/sched/ext.c                            |  11 +-
 kernel/workqueue.c                            |  18 ++-
 lib/dynamic_debug.c                           |  16 ++-
 lib/test_dynamic_debug.c                      |  12 +-
 mm/damon/lru_sort.c                           |  33 +++--
 mm/damon/reclaim.c                            |  33 +++--
 mm/damon/stat.c                               |  16 +--
 mm/memory_hotplug.c                           |  30 +++--
 mm/page_reporting.c                           |  11 +-
 mm/shuffle.c                                  |   6 +-
 mm/zswap.c                                    |  14 +-
 net/batman-adv/bat_algo.c                     |   6 +-
 net/ceph/ceph_common.c                        |  10 +-
 net/ipv4/tcp_dctcp.c                          |   6 +-
 net/sunrpc/auth.c                             |  12 +-
 net/sunrpc/svc.c                              |   5 +-
 net/sunrpc/xprtsock.c                         |  18 +--
 samples/damon/mtier.c                         |   6 +-
 samples/damon/prcl.c                          |   6 +-
 samples/damon/wsse.c                          |   6 +-
 security/apparmor/lib.c                       |  27 ++--
 security/apparmor/lsm.c                       |  75 +++++------
 sound/hda/controllers/intel.c                 |   5 +-
 sound/usb/card.c                              |   7 +-
 110 files changed, 854 insertions(+), 1066 deletions(-)

-- 
2.34.1


