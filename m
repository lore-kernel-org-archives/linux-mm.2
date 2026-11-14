Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C712C607358F
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=XCZBpL7V
Received: by kanga.kvack.org (Postfix)
	id 6FBD26B05CA; Sat, 14 Nov 2026 15:27:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6857C6B05CC; Sat, 14 Nov 2026 15:27:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48A086B05D1; Sat, 14 Nov 2026 15:27:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 122046B05CA
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:27:30 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A3F68C01D2
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:27:29 +0000 (UTC)
X-FDA: 85434859818.27.F9CC280
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf19.hostedemail.com (Postfix) with ESMTP id 196871A0005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:27:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=XCZBpL7V;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf19.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794688048;
	b=KatD6eutZMerzG/N6j9Q2w3sUqxs9YA2nGROJOFgRw+RPbf/nMtkKf4A6g2g5yKkkP/RBo
	qaLIEkLPls//1QQdruJYxNwn63tslsnLbQDJoQ7hvzDMwa2++LAe/WrNHr9NbqQK7AzF85
	KT3wSbGp1DiDSnWoO0P09BRx+LJOuvM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794688048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jGGqw6W/drKiecJ+Lyj16xBmzUWedlPig11Pki+N5bA=;
	b=E2A0DJIZLkA2JuLHB94HI2Fta4maNptsGcnDdd88EaeQ/4fArJVOJKlbwd3v4ugzW2IcUn
	HvWdJdU483ClOYbT7+A3s2/s+cwKvVz4irIyQmbQinPoyBRhfTtiGN2H3ZvGrvRKBR+SOn
	vp9dcBVidVZD8srHdrtimjuCRrReirs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=XCZBpL7V;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf19.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jGGqw6W/drKiecJ+Lyj16xBmzUWedlPig11Pki+N5bA=; b=XCZBpL7VGmdyvVoeJFnEGKriNE
	t1A8WSTzQh5HeLMdnkuJ2bpJSF6Vrub/DuMvj6yxG4LnWbl+ISMHg+/D4FxopaKlY/fSNK/WhSvO/
	lll58TlNJzPttWytRN0Bl+uHrF9pfpbMWqOQNADSvretD1//gtR/PmSZWrhUEnqj4Q7yAWmjJrXsx
	1fX9ZlGNeNpG8aB4mh18hDONPws6txhcp4WeZ2zRz2c4KgUJsZ7W0nFgPrxupilzQz+QmHi5+iuuU
	fxUFTzvNUB9Mj4LHt52UXMY4pHQbLIec7qUpnRcR1v0MMGsHJBaokJJaYnol2XnyyIQCS91Lqc8c6
	iM992RwQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xSKL3-0000000Giga-2rtb;
	Sat, 14 Nov 2026 20:27:06 +0000
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
	linux-atm-general@lists.sourceforge.net,
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
	linux-rpi-kernel@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
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
Subject: [PATCH 05/12] docs: ioctl-number: update video/fbdev entries
Date: Sat, 14 Nov 2026 12:26:43 -0800
Message-ID: <20261114202653.3113381-6-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261114202653.3113381-1-rdunlap@infradead.org>
References: <20261114202653.3113381-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 196871A0005
X-Rspamd-Server: rspam12
X-Stat-Signature: feeh4ici1jw33w45z98m71fm63k19x37
X-Rspam-User:
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794688047-514781
X-HE-Meta: U2FsdGVkX18QqlDL9Ah3NpeE0d/ERmilNpxqaVpuNuzvqKAeX0sHYnFbuBhrbqrWqXONoNTW+BE7clq9Vfp1Y7DVgn1der4///jLVgoffs1jILLo6S97f4llHSiBOMYNigQmDdVlOjBwSgOWpSefI20MJTvGR6S1gTBdJ+MLch/Qw5MGFn37tQ40WkFKoym//kPuSPuivrVAUvXQp44+yBxIhq/AlLnzndzTiGdym6AzrLkl+ejgfPVk6Zpagp2GYGGPW3egxZrGCB4AuasqKPPUSySFmfawa0pIjbspG2588/GhY4TzAa94+bDikkxYNmyBxbFANm6IrCpBaLoN4GHsvhjgV16pH84+paZKtXD+/qMljLvwSDmRKR/2YCvvatakagjsS4w3VB2Jo6Di+EY1X/LQRmX5w+w3ZjIUK357r0VOpCQYp2jZ1TR02HmWC5ERvXodngGb0DuoVPcu2VSEAfS7ZOypVnTKAT9M4qwVbvCV+NsP4tNDUjZOpaPgfAdYAY4XUFfIwKr58bwdykxNkm6+ECEilYKdFt6tWOI+1w2i1Ka3h3FPM02s4jL9bjXfTgRL6NMHL66pFpzHN66urxehgIEVacTUcY6ogWliMf61ntI+J4+4N0wM2bxdSNwbf4C5ijJuaWWRCNXAQSSpA3Tvewa3k0+S1x3rop40FQYoVKWm1Iotb2gcTFPJ9ATs7yYv/zuaIsF67Hv0uhpxG37QOespmHNbcNhOiqR4TqjckRcU+tQSkvieEnHpu8tCDXdCrLAYS+3Oa1UaDRkH5CVZYBjvh9QZINIj3G/MiLDyKHy6CqczRSZcKmB6f/0dyrbUctFeHtL4WuGEZUOMa/tor4Ry3baEgUnqsm2MhXQEzko/mAGAxfTvumSbCDbNv3zVrKtom0EX8qfdRTozUDHjVxkYQwclQlT9Wkgn0w/+W9kzpM6lQ4PjSvlSD0hGZIcNtiDtwlT0J4O
 a1oh63ti
 t+XuBPl/OMWu6gAPDdhe23wMd9gec7Juv37ep5Wdp59tVp2V+8Y0Tw+jLOEuSczSK1ZoTxHz9X9IdIen8uWAmAsHYjDnbNTNW4PxDmRbbJUxI2cH+VTrn03JMP0dkwOXiGH7gdDZGgC8J+Ys9o4LrIRqjJFFi2nObf3Hcx4qPcKuZ+7xc+ERaB3p7/KbMY40wk8fCjAQ/AaSFGElhhGPr4zvqZPfYnOClf2psTIyvC+9u4c7r1iC3MHrB3QkpwQwO1CO/XaPQMYD3mkre9/Sacmq5l9Qb+QnlLWeOMfey6z5GM/lkMy/+Fg3XWUC5g9slYtV/WaV3p0PYleI5LRrv/f4gn+WN/OI2gW5X9eLos8aNyXqqAWVsD/3Po33F7CoJz4NdtTNYyCc9vL94024OX6mkh+wsL1dARSrrE8ifNLkq2gMy0DpPC9l+AO6ua4qlm7HBcS3oWKVuoBfHUxzleNdpSYcBJYLIQGCC15ebhd2S8qUpNhLP/APNm63XBJpQljC4355a2/xSH4EFOMlHYPKSQ/nNQh5+8sFPtzloKzVVTsJJ4GvYW4/obxOHb6rqL2MGRoEw78BcnhHtPGQzAsqFJ6NrAh+0bNo7cQs/PEfKY1Uh6XhLIX5MmRSxQ1rBbr6d5DjcDjvPquv3noqaaGacRT3LBd6g0w3Ug9Nzj/K7IT2idT2OE7cHuVIHgLO3+cZ3v814H/4x3gW7F2SfmKP8e/fc5JHnoTz+LRkkOLXMr29KCjABmDZJD8tPjwTFW9tuglwrtmik79QH7muWIChhwqb+tcsLGLxITnALB1yd6Xn6df4IK6QCtxQrmITFVhCud8Tzg4qt85NJLCbsPCF9uKtCSDc7DwwNqNDfh4Biln44IXioYZ+vdP9kdBWkglrHRQx1fUKNjK59J1HtdPexnKNIjxLzBwHWwZnMoczOfiUBkCHaUN8UWqtQE4UD/pKQRBtT7WyMkGsQ7AJ0N3UWKCUY
 daq6zTE5
 z4d/0Epb3dBYhoqW3hX95TRkEMbX6DbY3KQocJqlVcfDgjL0t2uNYxawQIPhhv1qYFXI3GoJpRWEOktL2FKcssLkTEs5mWC4
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

--- linux-next-20261111.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261111/Documentation/userspace-api/ioctl/ioctl-number.rst
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
@@ -188,10 +192,13 @@ Code  Seq#    Include File
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
@@ -199,6 +206,7 @@ Code  Seq#    Include File
 'N'   84-8F  uapi/linux/ntsync.h                                       NT synchronization primitives
                                                                        <mailto:wine-devel@winehq.org>
 'O'   00-06  mtd/ubi-user.h                                            UBI
+'O'   1F-3F  linux/omapfb.h
 'P'   all    linux/soundcard.h                                         conflict!
 'P'   60-6F  sound/sscape_ioctl.h                                      conflict!
 'P'   00-0F  drivers/usb/class/usblp.c                                 conflict!
@@ -295,6 +303,7 @@ Code  Seq#    Include File
 'n'   00-7F  linux/ncp_fs.h and fs/ncpfs/ioctl.c
 'n'   80-8F  uapi/linux/nilfs2_api.h                                   NILFS2
 'n'   E0-FF  linux/matroxfb.h                                          matroxfb
+'n'   F8-FA  video/sisfb.h                                             sisfb
 'o'   00-1F  fs/ocfs2/ocfs2_fs.h                                       OCFS2
 'o'   00-03  mtd/ubi-user.h                                            conflict! (OCFS2 and UBI overlaps)
 'o'   40-41  mtd/ubi-user.h                                            UBI
@@ -311,6 +320,7 @@ Code  Seq#    Include File
 'q'   80-FF  linux/telephony.h                                         Internet PhoneJACK, Internet LineJACK
              linux/ixjuser.h                                           <http://web.archive.org/web/%2A/http://www.quicknet.net>
 'r'   00-1F  linux/msdos_fs.h and fs/fat/dir.c
+'r'   01-06  arch/powerpc/include/uapi/asm/ps3fb.h
 's'   all    linux/cdk.h                                               conflict!
 's'   07-09  arch/{alpha,mips,sh,xtensa}/include/uapi/asm/sockios.h    conflict!
 's'   64-65  arch/sh/include/uapi/asm/sockios.h                        conflict!
@@ -426,8 +436,8 @@ Code  Seq#    Include File
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

