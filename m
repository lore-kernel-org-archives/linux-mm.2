Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A566E606AA40
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 05:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=OpuUmN9M
Received: by kanga.kvack.org (Postfix)
	id B00886B05BD; Thu, 19 Nov 2026 00:35:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A62E56B05BE; Thu, 19 Nov 2026 00:35:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92AEB6B05BF; Thu, 19 Nov 2026 00:35:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 53BD16B05BD
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 00:35:42 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C08A5140926
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:35:41 +0000 (UTC)
X-FDA: 85450756482.20.CE88F72
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf17.hostedemail.com (Postfix) with ESMTP id 42EAA40006
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:35:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=OpuUmN9M;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf17.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795066540;
	b=rb0+DlXG5ZxU/qxXWeA8pqu6v4IzR+AWReheVhjrVw11npFyNy+CDOjE0O6GRtsJJuLUzS
	20GRKipDN2BlD2fjrxTd5aKsb3o1QPgEj/fnL+ClW3Ei7ZWqX202MsIIbnSSBSDLpatzbE
	vMirmxmLY21AUiad6ADRWC4axc2wtPs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795066540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1eLXwX2TTOtzzg4YJJJIqHeDrys/MbfPMcbT+8ekHvM=;
	b=vomh9xcV+Fln9CBdtbll9awbCaKAMmm8FVRqlG0lHLJf3CxhlyiygfdxOvN77i1WXPRR1I
	9QN/cCt8XF9mv2m9fsrmgqxhddZiil2sWlvy07EXmaXH6lN5uYdMstSFSOEqexJp9yDZL9
	MblgfFnbRtn56SbMtdtBNLM7BLn9WSk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=OpuUmN9M;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf17.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1eLXwX2TTOtzzg4YJJJIqHeDrys/MbfPMcbT+8ekHvM=; b=OpuUmN9M/PuTEsleB8z73KAhYB
	6+41wOrHRt5z6SatuQ64ymowhFaEXYc5L618pirSee1ENCa0OBYoiC00s6C1VMqIr+ebqH0QZMno1
	OZ1dl22Kk884kpQC0bIADoUUPVeGMKiBvv0ewb3uWjjz2dKfCx4Ywrr7W/Ra0GdpeF7VgSsL0PnRU
	lWwpd02qeDuiSFEUagbdUD/nj/hBqD/yTIfoE1lnakL9a4Gasf8APAWVp1B0IdzH4OMxGb4+An5dK
	SHXVIGxtRIzfh1HpmSOBBIqOTxTNMlh1HK28QW0VJ5zXvTpKPuKbkxuSRZhDSHI6diIAMcxtdltkl
	1jPBN0ug==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTuo6-0000000Aufu-3YNY;
	Thu, 19 Nov 2026 05:35:38 +0000
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
Subject: [PATCH v2 07/12] docs: ioctl-number: update MTD entries
Date: Wed, 18 Nov 2026 21:35:08 -0800
Message-ID: <20261119053514.255348-8-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261119053514.255348-1-rdunlap@infradead.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uje568ahfb6jwjrzh5k9yjtg13ct937i
X-Rspam-User:
X-Rspamd-Queue-Id: 42EAA40006
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795066540-182332
X-HE-Meta: U2FsdGVkX18wAXtJJpZnZJiznOCoCFz0tvvvLl0L7KdckkDAfSqYM8+qOF5TiIShO2HOtec9kOwjm+tNc5CtZL+bkcta2fRfMvbTVB7c3i/73KA4DRpITRYczRz1GtGDLthyuS5fjzJeS3wRuYaXeOF2ke3TZ2iLjqFL3CkGyxCiBANik1cLsVmWbwhqauZnhlXReneJkGulhVdd11cDmB2lhIjZ+1CwfMnjZNk8NByEiwofhN48TOg6aLFfzj7QnCV6nWSRt3gJi48G0kOwULoMViOlaoLaPNAvhpPVDQp+I2VMKZxw3blINp2jB2gjY0QEI+foLQt7o/YjqHPkocvD19DEb0Fsiz3nmy6aF0riOXB3roshE/hIbQCPwqzxNUCDicas+O/b3T/pKCLYG3FUNiqCZ9+6g1IXqtaF3FeEHL0S8xNp00DSMDiD/hpBQi6VYKmxDyh2eH5HJ/NYECtELiyAZ5f44w9hYBD1A0fA3EEla1dKnaxeaU+QoAVncgZ/LWlfdA3DQQHZETDSlncTzmNebeA1v9THWlSX+122P5b/ZTr+1qsn3pVjnOWp+UgwBOfCnqgfF5YA/hfxhrJ9R42MXUfu7jwC7T1m33fw9ehMAK+9zD5XH4AIvctU/xAiON2rQ8fXW4A42/gAbKGLjpmiXO9aHXGvMitCvH7CcuhnPtCmBR7dcMXqRcLXy7+Wlc4sqsWSXBJcL4CtwM6tyBWvlXvCN3Tob9bexghlbX3EoSiZPlUdX/wcVefDZcUG/sP81vkITsImQu9dvsDO7+wjh0QvG4ARvZnH2ie7FTchw9NBNQc3SA4Y4Ta/nploIpEJmckbIr9E5cR5HgeQRdisIpC1c91q20yluhq9GhL+tRXwtYixyAnD4iLUhShdCSCIcLROzH8vp7e1PIRMDB78xQHVel4oHwhms98TXTesj3NcKTVAhPPYvr9bMX+kSjlDuVqYYXn2mUQ
 wUBxKP2w
 Z3N3MKVtznL+Ujun1AEs7b36vOPN0RpNT5Dbq/GjttmL0vvD6bxltElT6iy1uvxly8SqUF+jnWf9f38hGD/p2PhQzx4927e7AtBYao9jwZfsoYNkxlMoWDUQseXQb+255AqMAnbTGHaMMCdk7kBXWuaAkfoYqnHlGhWPr0DSwCSjE332/gI1WedTlIMWFEveKA+jUt5k7buzAtcx0j8jec1unkjAyt6tW9MnqwAy7U3PJt/Edkv14aG7/XhqggzF1MYobjCvuUd0bFX6Xn8prQJ3EjsKjAl+HB/A5Dowk+8E3yhryYlNb5ulT/W5M7glce9iLi10zdiJ+YIKOzZEG3aCQtXojFLZcqmhQDibxCorvZFYtgEYJaIGo76DBWdH9+ke0VZFcuoJgoZM0t7dkQcn1h/ZiA0dL8dd44Yptx1PeVHMxJTs2xOL+bz5PEhbW6FlB81kEdAB+Z4sHNcxVCxzS0UgngBoolE6DoXn6MtNaFHT83W1DYM36JyuiodsYzJ+XzTTxgkh1bPIV7OqisaVGaHMEsGjRgk8TM/kCthQjtw14Pdj0QiJsb4F7VNvjCgs6GdSGwsL33oY6FSTHYCz3aU0fIo3MHPRUXOx9I/PtXmsdeZqazaKx2s2yqdOSDjrKEd9t3g1N5dOGAohtoBp9nYJb57vuN/zGVhKoyNKxmW/r4icHUkWkUg9ZfiROhc51yRBYFZqztFHuPzeVJgjjEsTTr9VGvFBXXbh/pha/eAwMr3RjIYZrUDOgNFQ87bfw+gHwSLfozUTGr97O+pFza5BIe4MsFgCW7saNC05whmKprQ6C7+/1IEbVBcO8SOGTnjMzW2UK4g0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update the list of files where MTD ioctls are defined and update
the ranges of function numbers that are used.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
v2: address sashiko review comments (missing update of 'O' range
    for mtd/ubi-user.h)

[Since having multiple maintainers trying to merge these would
cause some conflicts, it would be more manageable for Jon to
take all of these through the docs-next tree.]

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: linux-mtd@lists.infradead.org

 Documentation/userspace-api/ioctl/ioctl-number.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-next-20261116.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261116/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -193,8 +193,8 @@ Code  Seq#    Include File
 'L'   35-38  arch/m68k/include/asm/fbio.h
 'L'   35-38  arch/sparc/include/asm/fbio.h
 'M'   all    linux/soundcard.h                                         conflict!
-'M'   01-16  mtd/mtd-abi.h                                             conflict!
-      and    drivers/mtd/mtdchar.c
+'M'   01-1A  mtd/mtd-abi.h                                             conflict!
+'M'   03-04  drivers/mtd/mtdchar.c
 'M'   01-03  drivers/scsi/megaraid/megaraid_sas.h
 'M'   00-03  drivers/video/fbdev/mb862xx/mb862xxfb.h
 'M'   00-0F  drivers/video/fsl-diu-fb.h                                conflict!
@@ -203,7 +203,7 @@ Code  Seq#    Include File
 'N'   80-83  uapi/linux/ntsync.h and uapi/linux/nvme_ioctl.h           conflict!
 'N'   84-8F  uapi/linux/ntsync.h                                       NT synchronization primitives
                                                                        <mailto:wine-devel@winehq.org>
-'O'   00-06  mtd/ubi-user.h                                            UBI
+'O'   00-08  mtd/ubi-user.h                                            UBI
 'O'   1F-3F  linux/omapfb.h
 'P'   all    linux/soundcard.h                                         conflict!
 'P'   60-6F  sound/sscape_ioctl.h                                      conflict!
@@ -305,7 +305,7 @@ Code  Seq#    Include File
 'n'   E0-FF  linux/matroxfb.h                                          matroxfb
 'n'   F8-FA  video/sisfb.h                                             sisfb
 'o'   00-1F  fs/ocfs2/ocfs2_fs.h                                       OCFS2
-'o'   00-03  mtd/ubi-user.h                                            conflict! (OCFS2 and UBI overlaps)
+'o'   00-06  mtd/ubi-user.h                                            conflict! (OCFS2 and UBI overlap)
 'o'   40-41  mtd/ubi-user.h                                            UBI
 'o'   01-A1  `linux/dvb/*.h`                                           DVB
 'p'   00-0F  linux/phantom.h                                           conflict! (OpenHaptics needs this)

