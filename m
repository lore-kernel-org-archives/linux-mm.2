Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA8B9606D916
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 05:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=CrVDzmrc
Received: by kanga.kvack.org (Postfix)
	id 115546B05B7; Thu, 19 Nov 2026 00:35:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09F0C6B05B8; Thu, 19 Nov 2026 00:35:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA9DA6B05B9; Thu, 19 Nov 2026 00:35:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B039D6B05B7
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 00:35:29 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07A33120957
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:35:29 +0000 (UTC)
X-FDA: 85450755978.19.79DAA49
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf12.hostedemail.com (Postfix) with ESMTP id BEF6E40007
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:35:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=CrVDzmrc;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf12.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795066527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wxf1C03XM0J3zRYLBJ6bAuRpCxjKZ85wIDqTXFJZY0U=;
	b=XYzAau3pFcyKcwSZq3Og1SvP1TDS59C8XXc04uqu4/BrVFRbwnv31zWpQME6bJ+ipBzVgU
	n0QZ3SARnZ6SSixL12CXBlSG8lOypHvse5/TKNfQXY3lGW6Mqu+mvSzUxxTTxyFIMudcr+
	0vzs+aUrLfyAx8wvBwF5VAqcgiCgk0s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=CrVDzmrc;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf12.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795066527;
	b=KkB+xCVm7ggXyB1Ws/ADHn6I7bQ8KnGMfO1EvdvWYMmYzL8OXFNkD+XW3JSZUV7wfYxVgY
	DUNe0ML78RZDj+pJH9RZOWrXTIxVlpRGevyQptk/4e4+bNmnoP0lDYqOcTADfvMGxWwyGm
	YXOsLVheLzawQvRpFVAzRaRjk4yMzAs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Wxf1C03XM0J3zRYLBJ6bAuRpCxjKZ85wIDqTXFJZY0U=; b=CrVDzmrc3oIthRH1y3T/xDyXPx
	cVrzHc8Q5zx9vBvBKySfZpSp9nn6Ctv4spyKdLZ2gMql4p4lGywVFn4Wxv0urKoLYE2Us8NFQbg/E
	SujAsyVlT9ZQaUAWuZ4Y5/PYoP053/q4PLQfGDqnfJt8K/Qo/9TEt1lbXZ4Egas/dHptyNhLgoYTF
	wuP3r+hQInGzK5spo+RZUspvYd5bw0PEETZbVVIV6tTzJx88fApDgP6f1LXwPqMwhToEckWSwFXKs
	1BcxQ0o6Vx/Qelp2qicLQ22b1mh0dYnsD+nVH3ZPFTcBV3vA7o28QrM93KssD+4D+Q51xT+SBXnFA
	FTl/MrJQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTuns-0000000Aufu-3YX5;
	Thu, 19 Nov 2026 05:35:24 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	linux-mm@kvack.org,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	linux-sound@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	linux-bluetooth@vger.kernel.org,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Jason Wang <jasowangio@gmail.com>,
	David Heidelberg <david@ixit.cz>,
	oe-linux-nfc@lists.linux.dev,
	Chas Williams <3chas3@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	Helge Deller <deller@gmx.de>,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	MPT-FusionLinux.pdl@broadcom.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	linux-mtd@lists.infradead.org,
	Neill Kapron <nkapron@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	xen-devel@lists.xenproject.org,
	Hans de Goede <hansg@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org,
	Mike Marshall <hubcap@omnibond.com>,
	devel@lists.orangefs.org,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Benson Leung <bleung@chromium.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	amd-gfx@lists.freedesktop.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	intel-gfx@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	intel-xe@lists.freedesktop.org,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>
Subject: [PATCH v2 02/12] docs: ioctl-number: update sound entries
Date: Wed, 18 Nov 2026 21:35:03 -0800
Message-ID: <20261119053514.255348-3-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261119053514.255348-1-rdunlap@infradead.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ycq5yx9gqfgkkwy47kw9mb9ythazunce
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BEF6E40007
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795066526-273792
X-HE-Meta: U2FsdGVkX19X8aDLR9l4SoxMRj+7Zlixm8plvy4Drvpx8YkHW+ZQEWaq7lVTSSh5aN8atolnanW230VvEG2FBFJ8LXfN/TMk2ofRcdSKd23//E0vrW2yujyki8Dr2Mksc5O7YsLwgd1lUNsuNwhlanFTyoLZgJ8wBP/ycnt22kAmp9HHL/NgwLdkXTWx5o7CgaadvGT9sZXB9kJ1gq8u6OPAm/cVh47zoZVOt46MCSpccxRD8IbG+uu7a+zhYpSzxrAop+Fy7+fgJ8Wagyy03nrmFz/uP4PLRl5JrXKQZTosFMa50ikZy1dBAqMIpSr9VLWnGeGelgXi2ti3GGTB8VaSdO99iPGjQjR0fZgR+mqZvevIO8O8jmDipfWZcDguAcM1ikaPQh5h6tBat2r7I+6/aXmoIJy9314YBFJW1rLx7pzVoU3RrkbhC0+yBsJ5GJkcXIzl7Gm+F5ZjHaRRDGVplsUuymGp5qoGf+hVzn6k19sZcnf/iB0Qq10uW/snNrVdEflc+ijNeu4MsiePJhFxqfNvULpFY4UIuLEgZZRtWlfhRpeMEpMN/L1AFGJRl1VYolA14V/D3GZuor7llsWeJNhGH4Tx7kwQAGeb7F7xZhj7avpuy8mpByPCRF8VX5QVZ8vprdO8xcZxMh1KYmTu0UYMbzORW/BNR9fFSXUeU2WaRVltPBqSDewmX3acidP/st++dmLKQJXAvuXLfwdposHOmgceWHh4O7nz3dDk85TxKFzopyQg0UfmSNZDTwk5zi3ihkkRzLPhrVE5IGhTW6niXCjOD2RrVDG/SQoppdjgCPj8K38EzdDn9JFtHzSyLH6PUDZ487qFLXIf672L2ppEG7NyaS0kStdQrltYNTKm40yT+uX1DBho0/Atx6GsuHOyqZdumXzABCTIgDKSDcyNV7XUNfMjFixgba2qKhuoc5Lto77xl8mqUzVRle64REY0MM8nBniFnUs
 fmZ+ZjfP
 sLKd6LPIJyakaH6lIMr2e1jUMnnF8HggS/UEtoWxEAmZW9wRqhaxSsrWv5FaicXBBvADFaNK6ZdTaNqiQ+COx7c0kWckXrl81fVp/QftDITeMr+47MQAqJhLTVFf+6r8tE79LC1H6kEeVmNBOvWLh+0JGdnCAA0JEp+/ebJNwadnPlDCedKtZrjmu3+ui5YixROSEGxdWRYkUaAYEQfU6ftE8RJIhMm2iTVz7ewGRo2XAXYagZrVJh+LtJOBwnyA4x+2RbQOeqt1C2RcAnaFnK7m0s+3zld4NsAaL7rscuU3Ag38eKR/5UV+zgdpSzC1MeIAiA0p3yuLuqKFJiQX6mcWhh78szNMPwHcRD7oO2PqFnitiCFsqn3EJBqTJUNBcUvUQVpGg4cBFM0/hTC+25ZyNkqVotR9kPERw7zUAAeYqVvlRw+GxzwoUMfSCVCUaoCaEW2lEL4HT7UPzoJ6ZI9IrHSxhPZ4O3Qo9Hp0Y+EsnRCSsOI7ICU2mMzxB2gTYYzYjosbMT0ITgNmXCxPNK8aBrrYyzpljgGitK46c0WfdYVhxW1zL3jBtdp4bQexVCGTzRwVDPrD39xtRM6+MhGtcET4BnjzTlpcT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update the list of files where sound ioctls are defined and update
the ranges of function numbers that are used.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
v2: add Rev-by: from Takashi Sakamoto;
    address several review comments from sashiko

[Since having multiple maintainers trying to merge these would
cause some conflicts, it would be more manageable for Jon to
take all of these through the docs-next tree.]

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: linux-sound@vger.kernel.org

 Documentation/userspace-api/ioctl/ioctl-number.rst |   14 ++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- linux-next-20261116.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261116/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -122,11 +122,14 @@ Code  Seq#    Include File
 'A'   00-0F  linux/agpgart.h,                                          conflict!
              drivers/char/agp/compat_ioctl.h
 'A'   00-7F  sound/asound.h                                            conflict!
+'A'   20-24  sound/pcm.h                                               conflict!
+'A'   10-53  sound/core/pcm_compat.c                                   conflict!
 'B'   00-1F  linux/cciss_ioctl.h                                       conflict!
 'B'   00-0F  include/linux/pmu.h                                       conflict!
 'B'   C0-FF  advanced bbus                                             <mailto:maassen@uni-freiburg.de>
 'B'   00-0F  xen/xenbus_dev.h                                          conflict!
 'C'   all    linux/soundcard.h                                         conflict!
+'C'   00-68  sound/compress_offload.h                                  conflict!
 'C'   01-2F  linux/capi.h                                              conflict!
 'C'   F0-FF  drivers/net/wan/cosa.h                                    conflict!
 'D'   all    arch/s390/include/asm/dasd.h
@@ -152,6 +155,7 @@ Code  Seq#    Include File
 'H'   01     linux/mei.h                                               conflict!
 'H'   02     linux/mei.h                                               conflict!
 'H'   03     linux/mei.h                                               conflict!
+'H'   03     sound/core/hwdep_compat.c                                 conflict!
 'H'   00-0F  sound/asound.h                                            conflict!
 'H'   20-40  sound/asound_fm.h                                         conflict!
 'H'   80-8F  sound/sfnt_info.h                                         conflict!
@@ -161,6 +165,7 @@ Code  Seq#    Include File
 'H'   40-4F  sound/hdspm.h                                             conflict!
 'H'   40-4F  sound/hdsp.h                                              conflict!
 'H'   90     sound/usb/usx2y/usb_stream.h
+'H'   FC     sound/pci/asihpi/hpios.h                                  conflict!
 'H'   00-0F  uapi/misc/habanalabs.h                                    conflict!
 'H'   A0     uapi/linux/usb/cdc-wdm.h
 'H'   C0-F0  net/bluetooth/hci.h                                       conflict!
@@ -168,7 +173,7 @@ Code  Seq#    Include File
 'H'   C0-DF  net/bluetooth/cmtp/cmtp.h                                 conflict!
 'H'   C0-DF  net/bluetooth/bnep/bnep.h                                 conflict!
 'H'   F1     linux/hid-roccat.h                                        <mailto:erazor_de@users.sourceforge.net>
-'H'   F8-FA  sound/firewire.h
+'H'   F8-FE  sound/firewire.h                                          conflict!
 'I'   all    linux/isdn.h                                              conflict!
 'I'   00-0F  drivers/isdn/divert/isdn_divert.h                         conflict!
 'I'   40-4F  linux/mISDNif.h                                           conflict!
@@ -204,6 +209,9 @@ Code  Seq#    Include File
 'S'   80-81  scsi/scsi_ioctl.h                                         conflict!
 'S'   82-FF  scsi/scsi.h                                               conflict!
 'S'   00-7F  sound/asequencer.h                                        conflict!
+'S'   20-52  sound/core/seq/seq_compat.c                               conflict!
+'S'   60-63  sound/scarlett2.h                                         conflict!
+'S'   60-67  sound/fcp.h                                               conflict!
 'T'   all    linux/soundcard.h                                         conflict!
 'T'   00-AF  sound/asound.h                                            conflict!
 'T'   all    arch/x86/include/asm/ioctls.h                             conflict!
@@ -219,8 +227,8 @@ Code  Seq#    Include File
 'V'   C0     media/si4713.h                                            conflict!
 'W'   00-1F  linux/watchdog.h                                          conflict!
 'W'   00-1F  linux/wanrouter.h                                         conflict! (pre 3.9)
-'W'   00-3F  sound/asound.h                                            conflict!
-'W'   40-5F  drivers/pci/switch/switchtec.c
+'W'   00-41  sound/asound.h                                            conflict!
+'W'   40-5F  drivers/pci/switch/switchtec.c                            conflict!
 'W'   60-61  linux/watch_queue.h
 'X'   all    fs/xfs/xfs_fs.h,                                          conflict!
              fs/xfs/linux-2.6/xfs_ioctl32.h,

