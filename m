Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51DA9606A6CA
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 05:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=1ewdIJtp
Received: by kanga.kvack.org (Postfix)
	id 75E866B05BB; Thu, 19 Nov 2026 00:35:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 707B86B05BC; Thu, 19 Nov 2026 00:35:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A8ED6B05BD; Thu, 19 Nov 2026 00:35:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 038056B05BB
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 00:35:35 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 54529140924
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:35:35 +0000 (UTC)
X-FDA: 85450756230.22.0EE7330
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9B8CD100002
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:35:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=1ewdIJtp;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf14.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795066533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KnCXAHrWe2wY5lWuzljr4glUKOPYIIFp8Ge0ioQH9ro=;
	b=z5OVzLGUhA/nFoRyvfeUrT93SgTsoOmsHvXBCsBuZco8L+KgQ5UzqUh2oaDSVgkf8zAM+q
	Rf59Kaa2DWa/LeGpTds7jTL9P3zFQnYc/gaDLOQhar3myFSxq2eDpQOusewg/RdpEbuBKj
	TTF+Q8l/spaa02dZR5tOWgmf9YWgtuY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=1ewdIJtp;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf14.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795066533;
	b=VonYyaapAnAAPZ4MSbtBoyKSEIEKwQmAVTWrvQOq51gxNflUgEpHmSiK4G478H70ltDiPy
	NHNBaEvuIdApRUhGarzIvEXD8Aob6FST3UU4Im7guJVb4mVWdaKJDUoHQ0zBTJ74DumApQ
	l7/BD1u0dC8PfBBKy7gBaEoz37NadAg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=KnCXAHrWe2wY5lWuzljr4glUKOPYIIFp8Ge0ioQH9ro=; b=1ewdIJtppV5OT7nLC87OlE9OFS
	nRYcNA5S2/7EKOYmIAu8hJxDvNPBweRtOBiy7E2krNpgtXTKhf/UDddUo+tUh4GODXpPjZtw7gRFO
	aDy0kTzJ6YHMD3nvuCsvxaGL75wFuEZreCsQK+fjeyYxeGgQZbjRhJNlSatxLhjmRIPFPbpLslvs3
	IB/ZtDwLesoBGltcFYZ0PrBEbsHHmqT954ccEw/XqJiwfMKHa75oZ23tD7U+euzRtFveHeNEDOn//
	tkfu2uECuuwx9FZJw8002oFZmNsaUE3PEAVkHKFzt4UnhbO4ZPaiKKMRcapP1tTKFImoxvaCEy9yd
	9SAiLErg==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTunz-0000000Aufu-3Ln7;
	Thu, 19 Nov 2026 05:35:32 +0000
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
Subject: [PATCH v2 05/12] docs: ioctl-number: update video/fbdev entries
Date: Wed, 18 Nov 2026 21:35:06 -0800
Message-ID: <20261119053514.255348-6-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261119053514.255348-1-rdunlap@infradead.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9B8CD100002
X-Stat-Signature: k8e18zefgnyjnojm4u387u6sd4scs7do
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795066533-702426
X-HE-Meta: U2FsdGVkX19NAOQhCwYC3eVPwAWMB7LtLvlC6aHXqwE1ylr+r7hhFswaXi+g6deqlF2Z1jUkfbOxvMNSvBorarIsw7gsa2KZnnCqBexrx2MQy8PQ44YM57JZ+9n+lJgWjvh/INmbt3uXtiwvHi9UCc6VOcEXxMETTZbQbHmZQA2DIWXjhoOJH89gxSIS2GgL2yCfbNp0imkGjIB+tt1WI6onola8RrMhzeOon95ixzCJcyKiJZsqWLuun8W+bajey5eLnfysulNe1qiSb4iQCbIKWeyxOeYwZhooLQuRc1uEb7fuKgi367gaYnx1G0xtiPCkM9IMyesN892Wpj/4hOP76qD2d97KfmaRiZPT3QGgU6PqBG5WDLMxnPuOz+injTzITag0viXqot8tUQivWMKgrGEaSPjSFyYe1pLV6E1vQbPn6S7jHrREpzacuCNX7AhC8Kzp9iH+ABQRI2s/OGPNCqyQFf4xlIQp7q3WAc+zLwlXcN1eo1Jfoq7vxwJphw913y+MOuwR2E1dNr8wpB2Z89uPx5zC+SUeIEt1Lzgy86sesA+/ZPC3sklj+cevRQ9i8rE01S6ZMi2ie5BayHf6RgLLU9Q7RJwy8ByRtn4iP1UYmTzAOkxCQfkmEcnbbbaaq4mCa7fYob/5t1Dn7oiCc5Q+F/8F2u7GKghizO021p2gBGH+aJnRDZm9Cuo5dU4l0rbLFU6iyyTT1viYQ9ylBn3AjrUPpyjS8mZ2+3c9zTlS8iU5l7pZJqOrfT+a9Shneb3fKCKUi5NNH/aQDXk/CN+x2Bd3wJoxkDhlLUyGWI5f1cjN0gKolRn332Fyf7Q8UI1xI4iktzNaRChOurcWRMbQwwFxtQOF1wz2y2a6jkC2JIPrpoIG9gCRd8fslvksxWSUPl9m5b5WF72V07vsGoPYx3EuTTBxtvyROvQWFHemuF1n+hjpXZOZyr8MISxYW1HYAKEu5sSeuJq
 panr1ehA
 MPEXhUF9r6pz+BpfhRxU1lvz+HuslaO0JoBskwxK/5XzSGXmCGE9lYef/M0OjpFt96oVSJBkXFUT61bGYuEEo6PEITbTe4FGx9NkBCO9xrDa3+D8WgKCPjUfMuYZ3hBUBHFxUw+vQnLNy0MtM7UosMvSoRL49x3ilvv9vFRPfNpklPrg6pF7C7RTE+v/ilvVRn2i8IsddEbsSHtbIRHKneb177hMwJXJro8Nob3bdGuDYO7Eb7tNi+BGYXiESWIf9Bq5O/lrAutMKuUVfeM/dt0uL09L5NKNk8dyL7p7pVNJWsxITnJac86N56LHMNQAO6ndxbmXDbCh5D8N2TM1u6TiWVAEuMob5sMfN7XtA8ISQaqkNSox6OWf2iEssQLPBz+qEUnfr4ueIWtYxQM1HdUoo+Poj3uqo4kg9MbWYTLjqVDQnudCT+zx1HB2gv3LhQ+Mx3f5pU6wTNVMkmrJhxNLdWtUCPEzBC3MUzIh9nShFT3IFXi7L114uP2LUE95oob8tuQzpaAcb58EZbeEtSyrfe/jlaO/oykOHmWdS0ypU6tlpalIl5UNxrgwK5Q3c7iL676MY09scasd5gEU9YIxAac8CmwPcdmAr/dqTJ08slSRxOMEUn/1uyODeScBbSqTb9ofsO906SZIW8JdbVWf0Pq0bybltc5ZnrCDNJo5zoWORNJral27wyg+4pHZgjNHkXL3xdj1WWHIgGcKMda/I0WXTEYx2osAS0mS9kllb+GZW+u1XshQ5URaLxz5cwn1NlpzJM5Vck5heyGcektXU+I+7EtcWc3qq9jNkZ+dIa8UxKrJv25JDSh7fBJS4zWAPquEt8oI21hcZFok3ziIzTYgsYyp6ApzjhMJapnbFSfaMz1NOu4C9tlvPr6rHJ2BGow8MtPdTcVCOB+z7Ok77u8mjeDy2ElPP
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

--- linux-next-20261116.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261116/Documentation/userspace-api/ioctl/ioctl-number.rst
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

