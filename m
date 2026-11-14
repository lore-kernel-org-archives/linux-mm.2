Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB013606D1E1
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=iXx/38zX
Received: by kanga.kvack.org (Postfix)
	id D6BA66B05BD; Sat, 14 Nov 2026 15:27:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CECA86B05C2; Sat, 14 Nov 2026 15:27:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A073C6B05C2; Sat, 14 Nov 2026 15:27:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69FD56B05BF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:27:18 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E9AAD80266
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:27:17 +0000 (UTC)
X-FDA: 85434859314.30.5A869B2
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf15.hostedemail.com (Postfix) with ESMTP id 27192A0005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:27:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="iXx/38zX";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf15.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794688036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o+U3kWErBkCSTRLgMgKm+90EEeoH5yL29FO/FtSBNs0=;
	b=jvBqpcL52TcHcRf2Sia+lCQrmPslugYZIa82tPabS0de0OctwqIKFjCS90k71y0roxnNpR
	m+VQBVAWW31kouwokFQQITwuiqYQseWKopNE5RAsYidKafgR7bfkE2ocpQWFA1/RcuHtuW
	kYv/46sZyLE+6xazRmNkIOmbzY2kjNo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="iXx/38zX";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf15.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794688036;
	b=gwKyLAlg6E2n1iqz4drEqmJMoMYBCp4TmvK2389UzTV1QcWbX59WUnQUVYOC9X+juX19du
	8sFQqyjRA/XG9aTnceHd7WQAmgyYG1D+LcWdh1lcPI8Br4qx0ltA2C0bk7zc9lbvVoyHYr
	XpaLZikfx1hHiDbJh9nUSLVJKf3nbNg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=o+U3kWErBkCSTRLgMgKm+90EEeoH5yL29FO/FtSBNs0=; b=iXx/38zXd8cg1pen5CP5P6uZUo
	wY26xN4eIACNe3VSjGGRZ+5kts2ntm/nb4UP/LSf+Y+DnX+LuBTdlRpxCeVwrl2VVi1HrxvDrCWM2
	AxlgJdBTIDiZ830SBUHp1O2RAJSNmYjoQa6PQt66wkDey10XUjavpo7CUYZ3CuDaDW4iXSmo1XJT5
	ktxRSDP9vCpP5Vz0x62H+k+pK1iRdjzL2FT7MhYxFn89V3CGB421/gqcC3IOaTl72MN6bGj+kNUjO
	E9vIoLZ6IwogEn/RA6NORrw8/7nwMUVsKblIPVDlPZ5IT0JGdDJsYOR915lSbgW00LYnSC6kfRliS
	GYoMJ4Rw==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xSKL1-0000000Giga-2f90;
	Sat, 14 Nov 2026 20:27:03 +0000
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
Subject: [PATCH 04/12] docs: ioctl-number: update networking entries
Date: Sat, 14 Nov 2026 12:26:42 -0800
Message-ID: <20261114202653.3113381-5-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261114202653.3113381-1-rdunlap@infradead.org>
References: <20261114202653.3113381-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 27192A0005
X-Stat-Signature: sjmk17nx8wjkhm5nt9c7f5bqts54zbw9
X-Rspam-User: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794688036-429725
X-HE-Meta: U2FsdGVkX18E4IrMn4NBpczCiFH2YrAK6S7/gITInCLurIqNSPPYf3uH6Y05NeWMVgkva283maf9ET15HLfPTdmDul8t7pzYsIWjTMdKqyKamCfHMaFOngaYalUl/6ZhqYgIP+pMeGvcu9USP2JKMyGtVXExdSkthXOjI3+affPaPoxLQmeA3rZGb0E6L4VYxkJo2gbGK5kR0nZtIjjnqwctrtxqJm+lDm+ldaslegrnN2TrzMsmsIpSFr+Ty/URyXB0WTyGEFxJAeaUciyjAL0EQu0ShI9U+onwiyTudSKmOVNb7SYT2X6dGvo3DCbcZcWM0vlE2Gxtbt4Jjs7smmvucV+tnrdGHdvWLXRdvlPA3iswhrr71O9aUMj9+cUgt/8Gk6w+BQiNEMcuVIkfPfvpz/VgK+HiYIgDaVdCd3k7H9oz9k7gkykxdyl5NkzniZXHaMtKSZ/CYSgYGQjDYDiq3AbNgmQd/yeYuAGxV2lTdaw080SWJkvZ2JQyCpZrAE8oIeOt5PV/xj6HFO70Y8TKXcUbhJaKEo4Y+xbsH2E3Ix01Elp46vglqCLREiUbFT/B7MfU5hKGd+1VLkKc/R6O5v8llfzsRbMFZu+qiyGioBy73+rabW1/OKTHxNr46qC+SJkyymNBoJh4eVVnsBaQaYaUt7UIKsbrGKCqioMY3NOjpOd4X/rUv0SgRMcjRiQ+ryd1nsbeskG7AUjrQ18P2VvRegiH8cwZ+Doof+sAEV8qXlUCRQ16NCD2SvUKPbKd18ElBQC0w9Zjn+M9inHwqJgB8fWmNB47DUO7K35QTosFk8+EXZwWglbEcVlXYANVu63/WhKNGK6+0Leh20kNI0z+DFT5xvrET0JRGy9astbpj3neQYffg+3bPSKI36NMZCbmbblSMUnMcXqPWc5gH8Y5lfQq+Mk6xOr8arhCqtEyxFQkTUZ1PtHHBh4AKqyfYtRw19Gr4w07r5Z
 /4uXwQfa
 xeHF9DhRFNuEudh8rEoMltwOHkIMpyi4xyqsTZfdI3CP6hpAZ9NICT9kDo0TOF+wxOrYwe9zaPqTbtnZ8tJwiKIda1k286ldtRgY8KDlKwUsg0oSYL2chec4b4t05cDa/zAwyTZFxbGNld1U0xQtKcRHzPHqiU8ITJZyvSdGUG8RlNRxj46p0Uim6TBsva8/bF+zob8LU5gxygkiw6r0Pd4eOZWEJBTjoTMk4l0ftrCpTbDjfx8a0QtC06XoGu8W2EBz7qamNSqeSjtauqirfAY5t98lqYSeAdwO8+6Sc0vTsVCbMgB8i0/d8ylC2rsymy1yz3v44KH97x5UcM7K1SNjykTB1LLzLHY1X5qtPDNOpWPjYtcbpmsIQAi9K//U4kXxjg3oxKCEVppTDFXvCZef7MiLiH8qIELFlax6PQCCVXz2Dw5mq/8R6km663P93D+5pWbDqEwyn7K7TefVlRi2wuHU0tRvJKp1sAE13Rg54dhhmDYtsi/qaOEmmAf2dE0DFKJccCGrT7jr+3p4tjXEE5zNx73hrucgzS1CTNMRMd/uqhuPuzNiUtvK++GtgQwrw5Zd5G9xqcHIeXvHzsr9RnfmFZyD8gUiUQjXC2mLIjJpsoD5bZ86huaQbAlmJBsHPXsjoqQl4kToZwxoFwzbY7RyHnlIQJCSKOFGaeeYFX2sdH8oWQW41zHA4yYczh0iHAkiPPye2I6N5TezrTTc4DzLrivJlmxvrTu0V2IT0jrRtY3WD1md/kOEx3jn+Xt3fgEYVquJeILOj6EIMdj003ECll6Oz9HySdXb3v6O3W/Q3A4iKvgVQIoDAyVNUL5XZp0WgjeDA3vXKKJPB+ZCGUHeH5wsh44GlNc/Wdkod7ErP7m+3r3uCOCA96mW66Tx19HRUL9zJVylH/tsIQbFtXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update the list of files where networking ioctls are defined and update
the ranges of function numbers that are used.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
[Since having multiple maintainers trying to merge these would
cause some conflicts, it would be more manageable for Jon to
take all of these through the docs-next tree.]

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: linux-bluetooth@vger.kernel.org
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Jason Wang <jasowangio@gmail.com>
Cc: David Heidelberg <david@ixit.cz>
Cc: oe-linux-nfc@lists.linux.dev
Cc: Chas Williams <3chas3@gmail.com>
Cc: linux-atm-general@lists.sourceforge.net
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org

 Documentation/userspace-api/ioctl/ioctl-number.rst |   19 +++++++----
 1 file changed, 13 insertions(+), 6 deletions(-)

--- linux-next-20261111.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261111/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -132,6 +132,7 @@ Code  Seq#    Include File
 'B'   00-0F  include/linux/pmu.h                                       conflict!
 'B'   C0-FF  advanced bbus                                             <mailto:maassen@uni-freiburg.de>
 'B'   00-0F  xen/xenbus_dev.h                                          conflict!
+'B'   C8-D4  net/bluetooth/bnep/bnep.h                                 <mailto:linux-bluetooth@vger.kernel.org>
 'C'   all    linux/soundcard.h                                         conflict!
 'C'   00-68  sound/compress_offload.h                                  conflict!
 'C'   01-2F  linux/capi.h                                              conflict!
@@ -173,7 +174,7 @@ Code  Seq#    Include File
 'H'   FC     sound/pci/asihpi/hpios.h                                  conflict!
 'H'   00-0F  uapi/misc/habanalabs.h                                    conflict!
 'H'   A0     uapi/linux/usb/cdc-wdm.h
-'H'   C0-F0  net/bluetooth/hci.h                                       conflict!
+'H'   C0-F0  net/bluetooth/hci_sock.h                                  conflict!
 'H'   C0-DF  net/bluetooth/hidp/hidp.h                                 conflict!
 'H'   C0-DF  net/bluetooth/cmtp/cmtp.h                                 conflict!
 'H'   C0-DF  net/bluetooth/bnep/bnep.h                                 conflict!
@@ -219,11 +220,12 @@ Code  Seq#    Include File
 'T'   all    linux/soundcard.h                                         conflict!
 'T'   00-AF  sound/asound.h                                            conflict!
 'T'   all    arch/x86/include/asm/ioctls.h                             conflict!
-'T'   C0-DF  linux/if_tun.h                                            conflict!
+'T'   C0-E3  linux/if_tun.h                                            conflict!
 'U'   all    sound/asound.h                                            conflict!
 'U'   00-CF  linux/uinput.h                                            conflict!
 'U'   00-EF  linux/usbdevice_fs.h
 'U'   C0-CF  drivers/bluetooth/hci_uart.h
+'U'   00     net/nfc/nci_core.h                                        conflict!
 'V'   all    linux/vt.h                                                conflict!
 'V'   all    linux/videodev2.h                                         conflict!
 'V'   C0     linux/ivtvfb.h                                            conflict!
@@ -242,8 +244,8 @@ Code  Seq#    Include File
 'Z'   14-15  drivers/message/fusion/mptctl.h
 '['   00-3F  linux/usb/tmc.h                                           USB Test and Measurement Devices
                                                                        <mailto:gregkh@linuxfoundation.org>
-'a'   all    linux/atm*.h, linux/sonet.h                               ATM on linux
-                                                                       <http://lrcwww.epfl.ch/>
+'a'   all    linux/atm*.h, linux/sonet.h, linux/atmbr2684.h            ATM on linux
+             linux/atmdev.h, net/atm/ioctl.c                           <http://lrcwww.epfl.ch/>
 'b'   00-FF                                                            conflict! bit3 vme host bridge
                                                                        <mailto:natalia@nikhefk.nikhef.nl>
 'b'   00-0F  linux/dma-buf.h                                           conflict!
@@ -264,6 +266,7 @@ Code  Seq#    Include File
 'f'   00-0F  fs/ocfs2/ocfs2_fs.h                                       conflict!
 'f'   13-27  linux/fscrypt.h
 'f'   81-8F  linux/fsverity.h
+'f'   7b-7c  arch/{alpha,mips,sh,xtensa}/include/uapi/asm/sockios.h
 'g'   00-0F  linux/usb/gadgetfs.h
 'g'   20-2F  linux/usb/g_printer.h
 'g'   01-0F  mm/gup_test.h                                             conflict!
@@ -308,8 +311,11 @@ Code  Seq#    Include File
 'q'   80-FF  linux/telephony.h                                         Internet PhoneJACK, Internet LineJACK
              linux/ixjuser.h                                           <http://web.archive.org/web/%2A/http://www.quicknet.net>
 'r'   00-1F  linux/msdos_fs.h and fs/fat/dir.c
-'s'   all    linux/cdk.h
+'s'   all    linux/cdk.h                                               conflict!
+'s'   07-09  arch/{alpha,mips,sh,xtensa}/include/uapi/asm/sockios.h    conflict!
+'s'   64-65  arch/sh/include/uapi/asm/sockios.h                        conflict!
 't'   00-7F  linux/ppp-ioctl.h
+'t'   46-4D  drivers/net/ppp/ppp_generic.c
 't'   80-8F  linux/isdn_ppp.h
 't'   90-91  linux/toshiba.h                                           toshiba and toshiba_acpi SMM
 'u'   00-1F  linux/smb_fs.h                                            gone
@@ -334,7 +340,8 @@ Code  Seq#    Include File
 '|'   80-9F  samples/                                                  Any sample and example drivers
 0x80  00-1F  linux/fb.h
 0x81  00-1F  linux/vduse.h
-0x89  00-06  arch/x86/include/asm/sockios.h
+0x89  00-07  asm-generic/sockios.h
+0x89  06-07  linux/sockios.h
 0x89  0B-DF  linux/sockios.h
 0x89  E0-EF  linux/sockios.h                                           SIOCPROTOPRIVATE range
 0x89  F0-FF  linux/sockios.h                                           SIOCDEVPRIVATE range

