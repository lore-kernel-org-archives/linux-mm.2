Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7A696070263
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 06:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=02nQm4Xz
Received: by kanga.kvack.org (Postfix)
	id 38F5B6B0907; Wed, 25 Nov 2026 01:14:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3190E6B0908; Wed, 25 Nov 2026 01:14:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 207796B0909; Wed, 25 Nov 2026 01:14:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D43D46B0907
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 01:14:00 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 184AB1A0D44
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:13:59 +0000 (UTC)
X-FDA: 85472625798.13.E49B23F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7D72B2000B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:13:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=02nQm4Xz;
	spf=pass (imf03.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795587237;
	b=garJbYQ/JV72iSxkdD10LgT98CAGWbFryjzLm1tedgICUgscMFf5+OiOu+CkYsMPhCLPmy
	udYIcF03g/FGS4l7SlEXECFvMFW5uSmO8MsrZo70+vr8cSs4HYjlo0cxjlxlHoA7SmNlM/
	OMdvXVEppWKNE4ABt/gj4W8xRtLcy88=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795587237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FGdsEE2axqxE3BUmJt/PM8Oghp4gvSw8X/brdlry9Q8=;
	b=HpjoVoZvOanzGd8xsdPdht/vJ1AddRqzhRxMuddtsJM3hvwiEfaiNoms7t5exYl9lxnIxR
	7mbglLaKx5aFK96uafgxU8ZEH4O3diksP8KWH7h/Dy4fZBYStj0ea2nzOWCBWNVvA9vcTL
	YK55/vQ/pOZ47fUTWpmjfIDtH4AKayQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=02nQm4Xz;
	spf=pass (imf03.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FGdsEE2axqxE3BUmJt/PM8Oghp4gvSw8X/brdlry9Q8=; b=02nQm4Xz+NlL83OHWvBQDWOnX4
	deYOqw1GWMwSQG39VqTXMtfR7U4V21b0eRoU13uLwOfBj+WXf1zRpm+Z8nKC1W4T9oF5hE4ZjnHTo
	yKuOCiEEqF1t+UBdRygjpzHKzi00vG3HTUgjkKRwVztXz4aHcvWIlsDQhB1oJkpaoulX+y0A1YSlg
	SIPpZXub+VPe3ViUp2HtcbyqktD0bQMOGBPWX/yCO5KeVoP+v0LJezJBortu1gBbgRfa6y2G4WD0M
	fFibaILV5WDkHiO5Uua30BAvUlUo3/350BP1G/ebY6gNhP5VUcgGv7m2JfPY61HMLON7ajYUeGMRP
	QdN8mcFQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xW6GS-00000008Wvh-0dNd;
	Wed, 25 Nov 2026 06:13:56 +0000
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
	intel-xe@lists.freedesktop.org
Subject: [PATCH v3 05/12] docs: ioctl-number: update video/fbdev entries
Date: Tue, 24 Nov 2026 22:13:32 -0800
Message-ID: <20261125061340.3402300-6-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125061340.3402300-1-rdunlap@infradead.org>
References: <20261125061340.3402300-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: t681363pe3eezc1q3rpyqn41wubi5xep
X-Rspam-User:
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7D72B2000B
X-HE-Tag: 1795587237-448038
X-HE-Meta: U2FsdGVkX19D77BvIuDLJTmRn/ZvKgkAkqhI+u/HqZG7h/S1Wog5RwliyLgCHKBMuva6u6im7GvRQc8+I0h0Wr5ALHb8pAKNQg3JLUJVt3h263Ex1c8sVAHJPwPDnVyWaRZyCk9WxiRwwuodOX53XUPPZeRnilaSEZk/rV9WfnZXWteyPtwwpUSH2SpUsiU9bkGupn/gItTTH4g70ibxTNTUGNjPnPdJhQ5ZJswDAqEMzuZBImmSkQ2/vplGuQdatubSrWE+poJkfSjUNWTXdVfYCnxvuc6ZVz+w6hqXOVfxmsdijYtSPFikTXm83dDm2fyhLHLDfcDgRd+iBayqy08V7rrvjnEIXcauy7CSBnID16kLmUqK4Y+RwY+KnBe1gZMuo8yyh8kfXX0gnj/Yzw/UoogtJ4paShsOdJL48YzvrAVbuNdYvPO8oUZSaeC+WRLNNsJ6gW70mSGJZ28cVt8nUTplvav6gjsRLWC7YnYVqlzSzonR22i/982AIKLQN7XmJAz4CfVu6AOuV3gNnVYqNZ4r/FVyaJ3P4sOFyeE0uu80xL1YQJy4Q0jbmd9r+a46fW+0KRDq6euFQob1crvyvSCICF3YWU7oLkTF8gBShbFdk0vRCRC+aYyWyiFfJSynbGPhPTseXAIgz2mQIO0mmAORoNy0aCH/YdNAD2QmER2FnC6nJQyI3sM8SrNPOfHj4/d3UELjh6MwLy6v6s7aH75BQgWvIRfyH/SRSi+LvVp5mQp/As2pFYDhu9com8dotz6jHj410vqQepHmQXPIrzUChPfgzMAuEz69Y/Pv7t4BP6Chfed5zVRpiA4/pdEnzNvn8eVZLFBisUhSwRcfxKG3+EGpnNcTD+ifbeXmncnFjeKqmtFdE0G4st1SQrZ1kaUnF1H4l+u1LB3Xm09z19/WCgUhSfmB5TX3TQzvrQEieNNG4KIQ9pp8b8yCnGDuQErLt4qKIkU5D4D
 6UmUGTno
 AfBzUDHsi2eCZWE34jGbGu0zcqYdxh4giz9iJmVBMHIX8MclFSEj2yzo3IEErYh0fq48crl+V3bidA5GN2vnVPUo62168ai6o56KXrLnawiQ4GsB+WuJCeV+dIZ5GcDtvdgosXhOA0/bM3wApyzOVjIlIvyxKhnFOqgjppbCz8u2s4hLJEJ+tfldVKe20SLvHUCCXfLtWcF2fh9adpNQDEimudCofEz5jaIb1G/x+42swzQ8HdW2Mw4covopMmy+X9SCyb1kacq8eNfsvQCaRuKNUVVKp1FB4ibeDqE0qDjbEvbRqcHUbOVL+3p1CzUkycvkcpowrrLLXXHbbXzMAopDD683HAtilJvzldBgK/FCPeSyB7M53tNW8Z6MiKRqW5t2QCI/8eGxPeRNwRqhYyOa6/ph91M7jRdk6CXYaG9cnn5L2nag7WkdAprSB6BfVAwtoXisEyA8Xo5q9kib/z12CPht13C7M8J0mHG2TohW5LWk8DIfV04ti1rNSnYn5jOqM0/zbctvra2hZHqBgVBVI57T/5fnEWqGZWWmrqPOGKa8NI5vbHQX5ut0ezYxMExAA8QR3lBmarf8lzYVh57eUrCcrZxAhzB0RVbhJOqH4BYebujgYcxej3w67W4K9K2NDD8KJb0HrvE5bRe9v9Fow6EZwLbBEtERxORtd4roTI+kC/er7pPxdLJHJQQWbcXokNZDqyW6CfVLH5j0QGMC6d2nh4RP1xa0Ppbsyahv+R1s5HmGZi8Gf3nnYucT9gldzLMWiyZXkjHsGqbMgYke9fsr6INjqIhRXAWnV1J11f6mVMpPDphzSFUjMS1yjIxLjkRqK/oqFHlEB4TaglgSkzd4YdizOFy74TfQv4U/y4FREmiLQD3ALQ6AicqA3O2bJuj1wHn6g/jjxFy+WRzwSQYVjFpxZNDuBeq/5+BZ2MnWRYg/xvM15b+xvwW2Oz51/97rEdLrp8Sh8veiXIV6hZSEi
 0+aXyZij
 5erVDyHDFMYfJessm0e+TNG3wa1j49RIb6Ho4rt8GyYrxZcl3rz2Ale711bZ7tzyhghd+V7JYBWqJi1H5PasENxEdZnsNQtUzJObGYREOdAA3CFQGEvmC1CObrGcOyoNhxFawkibIlrkCWzEJ9plQCbOUX7B6IZWvsLPlcQxmStwama6CNCrP+Wpj7d3r/GRkoHw+1G6xGSwlBIdXrlMWMEEtEPxKbngkRJ7y1ahIFClC3C7uhyuW5TCDEYYaHr/mDfcCwUuI+IiQTy4dDAU/dTlfF94aWF1+Wezihpk41g91XWFFTHmv996pTD96VxAABD8b5kFD/Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update the list of files where video or fbdev ioctls are defined and
update the ranges of function numbers that are used.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
v2: no change
v3: rebase

[Since having multiple maintainers trying to merge these would
cause some conflicts, it would be more manageable for Jon to
take all of these through the docs-next tree.]

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: Helge Deller <deller@gmx.de>
Cc: linux-fbdev@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org

 Documentation/userspace-api/ioctl/ioctl-number.rst |   14 +++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- linux-next-20261123.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261123/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -148,9 +148,13 @@ Code  Seq#    Include File
 'F'   20     linux/ivtvfb.h                                            conflict!
 'F'   20     linux/matroxfb.h                                          conflict!
 'F'   20     drivers/video/aty/atyfb_base.c                            conflict!
+'F'   20     arch/powerpc/include/uapi/asm/ps3fb.h                     conflict!
+'F'   00-21  arch/m68k/include/asm/fbio.h                              conflict!
+'F'   00-21  arch/sparc/include/asm/fbio.h                             conflict!
 'F'   00-0F  video/da8xx-fb.h                                          conflict!
 'F'   80-8F  linux/arcfb.h                                             conflict!
 'F'   DD     video/sstfb.h                                             conflict!
+'G'   00-02  drivers/video/fbdev/pxa3xx-gcu.h                          conflict!
 'G'   00-3F  drivers/misc/sgi-gru/grulib.h                             conflict!
 'G'   00-0F  xen/gntalloc.h, xen/gntdev.h                              conflict!
 'H'   00-7F  linux/hiddev.h                                            conflict!
@@ -186,10 +190,13 @@ Code  Seq#    Include File
 'L'   10-1F  drivers/scsi/mpt3sas/mpt3sas_ctl.h                        conflict!
 'L'   E0-FF  linux/ppdd.h                                              encrypted disk device driver
                                                                        <http://linux01.gwdg.de/~alatham/ppdd.html>
+'L'   35-38  arch/m68k/include/asm/fbio.h
+'L'   35-38  arch/sparc/include/asm/fbio.h
 'M'   all    linux/soundcard.h                                         conflict!
 'M'   01-16  mtd/mtd-abi.h                                             conflict!
       and    drivers/mtd/mtdchar.c
 'M'   01-03  drivers/scsi/megaraid/megaraid_sas.h
+'M'   00-03  drivers/video/fbdev/mb862xx/mb862xxfb.h
 'M'   00-0F  drivers/video/fsl-diu-fb.h                                conflict!
 'N'   00-1F  drivers/usb/scanner.h
 'N'   40-7F  uapi/linux/nvme_ioctl.h
@@ -197,6 +204,7 @@ Code  Seq#    Include File
 'N'   84-8F  uapi/linux/ntsync.h                                       NT synchronization primitives
                                                                        <mailto:wine-devel@winehq.org>
 'O'   00-06  mtd/ubi-user.h                                            UBI
+'O'   1F-3F  linux/omapfb.h
 'P'   all    linux/soundcard.h                                         conflict!
 'P'   60-6F  sound/sscape_ioctl.h                                      conflict!
 'P'   00-0F  drivers/usb/class/usblp.c                                 conflict!
@@ -294,6 +302,7 @@ Code  Seq#    Include File
 'n'   00-7F  linux/ncp_fs.h and fs/ncpfs/ioctl.c
 'n'   80-8F  uapi/linux/nilfs2_api.h                                   NILFS2
 'n'   E0-FF  linux/matroxfb.h                                          matroxfb
+'n'   F8-FA  video/sisfb.h                                             sisfb
 'o'   00-1F  fs/ocfs2/ocfs2_fs.h                                       OCFS2
 'o'   00-03  mtd/ubi-user.h                                            conflict! (OCFS2 and UBI overlaps)
 'o'   40-41  mtd/ubi-user.h                                            UBI
@@ -310,6 +319,7 @@ Code  Seq#    Include File
 'q'   80-FF  linux/telephony.h                                         Internet PhoneJACK, Internet LineJACK
              linux/ixjuser.h                                           <http://web.archive.org/web/%2A/http://www.quicknet.net>
 'r'   00-1F  linux/msdos_fs.h and fs/fat/dir.c
+'r'   01-06  arch/powerpc/include/uapi/asm/ps3fb.h
 's'   all    linux/cdk.h                                               conflict!
 's'   07-09  arch/{alpha,mips,sh,xtensa}/include/uapi/asm/sockios.h    conflict!
 's'   64-65  arch/sh/include/uapi/asm/sockios.h                        conflict!
@@ -425,8 +435,8 @@ Code  Seq#    Include File
 0xEC  00-01  linux/platform_data/cros_ec_chardev.h                     ChromeOS EC driver
 0xEE  00-09  uapi/linux/pfrut.h                                        Platform Firmware Runtime Update and Telemetry
 0xEF  00-0F  uapi/linux/ntfs.h                                         NTFS
-0xF3  00-3F  drivers/usb/misc/sisusbvga/sisusb.h                       sisfb (in development)
-                                                                       <mailto:thomas@winischhofer.net>
+0xF3  00-3F  drivers/usb/misc/sisusbvga/sisusb.h                       sisfb
+0xF3  00-3F  video/sisfb.h                                             <mailto:thomas@winischhofer.net>
 0xF6  all                                                              LTTng Linux Trace Toolkit Next Generation
                                                                        <mailto:mathieu.desnoyers@efficios.com>
 0xF8  all    arch/x86/include/uapi/asm/amd_hsmp.h                      AMD HSMP EPYC system management interface driver

