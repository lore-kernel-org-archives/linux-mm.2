Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2432606A325
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 05:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=gtc+5H4v
Received: by kanga.kvack.org (Postfix)
	id 5825C6B05C2; Thu, 19 Nov 2026 00:35:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 533B86B05C3; Thu, 19 Nov 2026 00:35:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 387D46B05C4; Thu, 19 Nov 2026 00:35:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 006496B05C2
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 00:35:49 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 73B1A4091E
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:35:49 +0000 (UTC)
X-FDA: 85450756818.18.5B13CF8
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id CC5C340006
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:35:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=gtc+5H4v;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf07.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795066548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZuZZE/Cj353sLaHKMo9GpZj59G0w2nJ8ZNrbV6CJF+E=;
	b=fWdqPXgBOJMASi01Egf0ToUUG+B0LvIbxPBzI9APrI9Sd94nCgRM91eMeAgq4wMJw1fx/k
	Re/w17+Y2+xl7xWPMg3cHcqCCXyo6sSv3/dVqPqqMuhS44SptVfDMb2PzJmmBTnffLkdJ6
	O0kQ2roB0d87e5nKZDbApb+lngF1Khg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=gtc+5H4v;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf07.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795066548;
	b=q2GsxyHaGKxUA0IWCefj1zj7lNVkkG1CqHh8ZoPI5bkUkJWu+/ACgdHgnZRo5HqiP1CBWs
	KDpzTU8xyR3qUijzEEuBwen0ileH06xuR0h2ogbKCI2E6jfv63aw/tYSwBL3jI9qO7Ml1v
	vnhxjzUHwFgeGlP4fO571ZMobtIins0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZuZZE/Cj353sLaHKMo9GpZj59G0w2nJ8ZNrbV6CJF+E=; b=gtc+5H4vdXyFU3qU5Duvifa7ky
	InKyXCzbLFZPDermXy3rctqSOxXlVD1xhaqgaam3o7dXL+dT1Zn4X6wKOoEgKwIMl/q3ii/4OE4Pj
	dD0/qIcPCOwrOsHurPjU5DuVLdgKUQVnbNOsgBDux7NNSuius0piP8K/4MVBRsbOy+Wj68w4MoEQV
	/yC6Yd5GetCjVDa4xZMHsOHzcxle7zKJPDj+ugtM3NXeqkNIslDkyVkcFfX10ZJT9o8fsAdX+iu3R
	qGfKSoWF06eIb33qIg9Z83bTojP/bNXJ1y/jnaz3znGe2T3I1Qni4iZwIQSmr5aLyhvr6uLH/rVHu
	EMPOBZ5w==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTuoE-0000000Aufu-0eli;
	Thu, 19 Nov 2026 05:35:46 +0000
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
Subject: [PATCH v2 10/12] docs: ioctl-number: update FS entries
Date: Wed, 18 Nov 2026 21:35:11 -0800
Message-ID: <20261119053514.255348-11-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261119053514.255348-1-rdunlap@infradead.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: g9ooamtjwfm5nx4ru4ghygggr566y484
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CC5C340006
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1795066547-890757
X-HE-Meta: U2FsdGVkX19dF6Lzs2KPmiCvx9e/tumv+pDDKhHvoMUYa9UR8lgrEYmElc79igcB2ptSh/nvHIdwDmU8XrSexINuTAtT8/9wpyjYM8VwiRIwMox+1uaKYA8qD+9dd+kHNg4v+CxSJDyuwv1glSZHiWkbbfnJsd1rmLYcJGvqG/EBubWyw9EUKjOMdyI0gk8TazOGoFq2wyZLzC0tJrhMv4zN1imYkxncx65QylhX0DT7+Ttdu4qHMnxrx57S/oyzsZbCn0zV9dLPIjC7MLEG4RPykjel0sbcdkL8BD7VEIS50huPdq6An/ngl1b7ff/niIV36PZFk1rc0/lA3G+RON5Rg9t6sM2aHzxxAWtx38k4o7DrGPXoVGnm0GGsZGptoqx/iDlbnXZ1kTBa37XqH08gL9mh5cc40YeaLyzvVPzZpYXr97V4RdkR/olHu3FxzouWyOIlUFiawtZJLcxw/hC+QhiDOTlo0Dyhj9TqehEUQjSNPXYT+nRbv5u2OC7kNZk+uegdbm+6P8SipTqy3IGs5JVuYyeHW16xkbvhaDjnRlXgP2dNwRkcP1vwZlhs7Bm3hHxDQjbwz0hoa9fAcg5rYymwj85dfPtZTiEQYU4PZs40sA46CNp9WC6kKW5LVuCEDVY1nKwDEGRRKNmoFD0+Vlbh0khkKap3AtugGi4a1Ch3lZ4eH2iBxrIkiug6g+1Ypd+S6BD5g2Z5OwiMrCwv1hSxoso1FiUN6XAAzXhDQuE2VYbUYj6ZoDifl/aorjTOVWoFQB/3Aey2VXFAN/Fh8Mx3DMp85vdNO5NgExAGzOin4zE4rK9hIRXNPzd28dyYE+jvAi3O6Hdgs1Jh2LIJyPu4iHAaPZUq2Apnbjvt9CKSbRA3UfN0adpWNA+RU0HPitoUZEPlSI6MBvaZ3xI9X9SGkl6Dm5lZZP5+n/U4cJ548yp9uCRkg5fGtz0R4Lsd/jTle289eFuEAVT
 0GfoJyUA
 zNuaFsjzKFlHa2C3xVHD8e2oE8JuOT1uY7CZffSIgXqaxMTP+SbvzHA4jnn45n8SXR1Saa8eG6pyiazK9O2sPrdtFXYV13+LCQ1iZRzFDdRgpzt30/Nefk6AHoVOBf4zI1uIjnlADi87r/WavrxHxeqCCKwrhNrX+kPKhkWs9xzxXIlpuu2IcNWyramS1NFDCuSGT1X8crc6WdSt8iSnBhXdpUFo04RTO+VHoDRTcG7iBLQRRCwPAt5VqrTz2zg4DgBLdo8PuzZ8WoKaAOesS8oL26JgJnnYnLuuPD+ewAHNEufGcFMaH/JuT2RrmUzXaiqHudJREBmeiEK8dG6EavKwLt+3pXqHfRrsjZyAGWUXWzrle1/e2lpURKGrMpdNUy1qA8B5rQNo3/Y9GxGe9j53qOeqgaSMM/qQPgh3cfMUEKTruLwicG6XTWhBc1EoReD8Gev/vm5Ng3V2D+DfICP8ZJNECTYKjvJ+bu+yeUQm4QfHuhuhcZMOhu3kNY9wJykemD5e+xW/6/11FlBVYbnHy2bTvER7S+i7mQ8mCOb9rksIYgRWDrXfk0wXUoP0sGdo8OLhUuEEFGtIyQLA9JJcrmAdHErysDPvJRa8V0h+FH4Qinn3It4pGdh9MU6u24wxjBTmbF/vcr3NGhOSs4M3ufJwZTcPwey9dpKiGy2QML+H+18+6Xw8Myn5+DLaHBEcSfzgcAg39tTTQFeZuYm/HkESBGayXhhD1iihdRg9CWbw5GB1lfRXDUXrGO82QGsXlSPP6C3T904FqmKXy2QWubLO2HgMh8BFlK9C4GxJxoneoegFXicXSyWrENpuXdPr7HYgoWnv0Ey7AZf9EHLq8pQAI6Edbzji4qGuj/NoMDFPZ9IZHqpNdHSJMpSOE2T52ljCP1UCyuUTPYZmevvNGU/t+wV6akEu+fthaFuaXB/AAQAf1tvEkTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update the list of files where filesystem ioctls are defined and update
the ranges of function numbers that are used.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
v2: address sashiko review comment (ext4 00-2F range referred to
    the wrong file name)

[Since having multiple maintainers trying to merge these would
cause some conflicts, it would be more manageable for Jon to
take all of these through the docs-next tree.]

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Cc: Mike Marshall <hubcap@omnibond.com>
Cc: devel@lists.orangefs.org
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Chao Yu <chao@kernel.org>
Cc: linux-f2fs-devel@lists.sourceforge.net

 Documentation/userspace-api/ioctl/ioctl-number.rst |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- linux-next-20261116.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261116/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -185,6 +185,7 @@ Code  Seq#    Include File
 'I'   all    linux/isdn.h                                              conflict!
 'I'   00-0F  drivers/isdn/divert/isdn_divert.h                         conflict!
 'I'   40-4F  linux/mISDNif.h                                           conflict!
+'I'   00     linux/inotify.h
 'K'   all    linux/kd.h
 'L'   00-1F  linux/loop.h                                              conflict!
 'L'   10-21  drivers/scsi/mpt3sas/mpt3sas_ctl.h                        conflict!
@@ -274,7 +275,7 @@ Code  Seq#    Include File
 'f'   00-1F  linux/ext2_fs.h                                           conflict!
 'f'   00-1F  linux/ext3_fs.h                                           conflict!
 'f'   00-0F  fs/jfs/jfs_dinode.h                                       conflict!
-'f'   00-0F  fs/ext4/ext4.h                                            conflict!
+'f'   00-2F  fs/ext4/ext4.h, uapi/linux/ext4.h                         conflict!
 'f'   00-0F  linux/fs.h                                                conflict!
 'f'   00-0F  fs/ocfs2/ocfs2_fs.h                                       conflict!
 'f'   13-27  linux/fscrypt.h
@@ -299,6 +300,7 @@ Code  Seq#    Include File
 'k'   00-0F  linux/spi/spidev.h                                        conflict!
 'k'   00-05  video/kyro.h                                              conflict!
 'k'   10-17  linux/hsi/hsi_char.h                                      HSI character device
+'k'   01-0F  fs/orangefs/protocol.h                                    <mailto:devel@lists.orangefs.org>
 'l'   00-3F  linux/tcfs_fs.h                                           transparent cryptographic file system
                                                                        <http://web.archive.org/web/%2A/http://mikonos.dia.unisa.it/tcfs>
 'l'   40-7F  linux/udf_fs_i.h                                          in development:
@@ -372,7 +374,7 @@ Code  Seq#    Include File
 0x92  00-0F  drivers/usb/mon/mon_bin.c
 0x93  60-7F  linux/auto_fs.h
 0x94  all    fs/btrfs/ioctl.h                                          Btrfs filesystem
-             and linux/fs.h                                            some lifted to vfs/generic
+0x94  all    linux/fs.h                                                some lifted from Btrfs to vfs/generic
 0x97  00-7F  fs/ceph/ioctl.h                                           Ceph file system
 0x99  00-0F                                                            537-Addinboard driver
                                                                        <mailto:buk@buks.ipn.de>
@@ -440,7 +442,7 @@ Code  Seq#    Include File
 0xCC  00-0F  drivers/misc/ibmvmc.h                                     pseries VMC driver
 0xCD  01     linux/reiserfs_fs.h                                       Dead since 6.13
 0xCE  01-02  uapi/linux/cxl_mem.h                                      Compute Express Link Memory Devices
-0xCF  02     fs/smb/client/cifs_ioctl.h
+0xCF  01-0F  fs/smb/client/cifs_ioctl.h                                <mailto:linux-cifs@vger.kernel.org>
 0xDD  00-3F                                                            ZFCP device driver see drivers/s390/scsi/
                                                                        <mailto:aherrman@de.ibm.com>
 0xE5  00-3F  linux/fuse.h
@@ -449,6 +451,7 @@ Code  Seq#    Include File
 0xEF  00-0F  uapi/linux/ntfs.h                                         NTFS
 0xF3  00-3F  drivers/usb/misc/sisusbvga/sisusb.h                       sisfb
 0xF3  00-3F  video/sisfb.h                                             <mailto:thomas@winischhofer.net>
+0xF5  01-1F  uapi/linux/f2fs.h                                         <mailto:linux-f2fs-devel@lists.sourceforge.net>
 0xF6  all                                                              LTTng Linux Trace Toolkit Next Generation
                                                                        <mailto:mathieu.desnoyers@efficios.com>
 0xF8  all    arch/x86/include/uapi/asm/amd_hsmp.h                      AMD HSMP EPYC system management interface driver

