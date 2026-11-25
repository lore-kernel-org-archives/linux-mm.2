Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FBA4606F395
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 06:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=sbfW4h2/
Received: by kanga.kvack.org (Postfix)
	id ABB156B0902; Wed, 25 Nov 2026 01:13:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6B8F6B0905; Wed, 25 Nov 2026 01:13:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E5866B0906; Wed, 25 Nov 2026 01:13:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DD136B0902
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 01:13:59 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7AEC61C3EF6
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:13:58 +0000 (UTC)
X-FDA: 85472625756.26.DF4A22C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id 534AEC0005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:13:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="sbfW4h2/";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf28.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795587237;
	b=gE1N57Ia2wX8K4RAQTbecFs+m2ODSSuSWaHJBccd+Rvo1Dv3nQ6uadgZpYwiLVI6Vdl1fA
	FSuCN0uyjOUdxCGyRpRsgStZqnKALbj9gZ8qzunqZZ1uKGHniR/u2qyTWYhR8J1TBxpAqb
	pdxHZKDIT71bPWC3aNtfv/5LD9mhfAo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795587237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RebRu2g/z31wGx+2OCPyrPhThAdN2yCx9u1zbQ7clX4=;
	b=3Kupkar4LWLHA0NPNpe8oIFs/77E8/Tg/Hu8zdUPlm0GpFwVX7aOlA23e7SNv7a63eehXm
	bAg3QbQmJHyCJ8OyeIqPdVRyvAecCtPVx42VpVBxYXgovslaqWci7cPeibpExvUZ2hUieh
	pyIOu9AiJnQPEUOxFUiV9hqBys9mvO4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="sbfW4h2/";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf28.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=RebRu2g/z31wGx+2OCPyrPhThAdN2yCx9u1zbQ7clX4=; b=sbfW4h2/B6I9JDHOZSZ9flrwqH
	bhgZPywMW/8HTQaTMbMZKWKRmF/u4H8iCdmE2NXlrIG4l3MwtdK3OE1zXboVyKtO4xeMZ0w0La58S
	NUE75yCeRbWpCVAQjyZpaIf80DbRSUhaAoWrrqLcAWR8iu4WOHNah3s4A4nj0JBDNqnhlSL3vIUzn
	zDTTHK+2eUQZNijcwbCFLcBgvYFCfQ6LtgapA4kghONZMaWOka0RBTX02MgSmk/fuJzJpuoxgBYne
	nZ/aqBW5VeYLOcer0h7Ymqf3LabTYXxS5PH5V6a/fF6uEcyOJXuoXqnamYCYTvhmMUeoOMSzKcIBX
	rGjDwO8A==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xW6GQ-00000008Wvh-0lyd;
	Wed, 25 Nov 2026 06:13:54 +0000
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
Subject: [PATCH v3 04/12] docs: ioctl-number: update networking entries
Date: Tue, 24 Nov 2026 22:13:31 -0800
Message-ID: <20261125061340.3402300-5-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125061340.3402300-1-rdunlap@infradead.org>
References: <20261125061340.3402300-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: u8i356j4nddiuz78syr9w41b4xuxmebm
X-Rspamd-Queue-Id: 534AEC0005
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795587236-898637
X-HE-Meta: U2FsdGVkX1+1gwkPEZldENLNVKNL9W3mtLroSvY+kj1B3SEZ9bNKIIFmZ0Pih6iK/KZweI6U3sfwupdznYSKXreppVrR+fJ2Ye/ZvsZzo/PohWZ/qEv8zi7SMP44i4IpWXxpALvldZnGvRHM/JMxNPPdkI2emDURNus+k259jZTL4fD8qaFJXJjQrXX22VY+YyIcm+vzMx2LzN0cLnCvnVZe8CfWgHrleBbIx/pBI10xlLUGpK2EkU0f5xsOwDnjMT6CfkuPmidtAT8FkpE7ZTsX0KQOeXkGVZDmtgIcFdQd3mBTMM1PdvkS/pmgstfIzIQWqCGWHUU3H0yCmAK57KcilmBc37VJTEpEKTL1gs+xIigmtxTK5TMcZCyBcCI74+0C+Ui31zzzbq5ooyj0iNXvyXqjeKqOhfjJ7Gmnd0+cia065NpSQzzhdkwfuR0/g5yIYBVWDFDNLr0lUqCEopnzrxJci0hBadd1ukp5OTwA3IXUfwaW32ZRPObvd4SKCeqapAb625peBgCHuqFTuWJImNLzVBYuPCn4tE0yVeZ0q7UJxOfz+VaQae5Lb6gi8xgSiKfHLNkVYnJX1vIv+cze/pBx99ryOYBAZUs88JHeUqQtbj8i14BTYa5PfsPjGMP7tiO2kUM9dKSi18flInMHeYozck0AJiL8v5HBkg1FPAu/qrxHiSKQgSjZj4iCwtyi5PGRfLgxSS/jT3+OvBMGezRfNfdWXozzR7A8hzHq5x8HrnIJ7nQcSzs6R63swfHAKlHv2QP2gkQjbO1+da2tibFejjSEIDWx8qp/vppI19swV6PQ670mLcV0i1L/fiSrirwXLX2L0bIcDNfThnTyURFvSCF3kQBB9vz5m7zYZlifutayB/OQFMU+h69krggM0CVs3HmcrSrsU6mzu8mlmC/tNaZiT2LTMkYe8s8yLjyKtinEUMZan6sSzxI9zs18ZeyNXnrCaKhlxdF
 mvoPHxAh
 CNXBnUO2bvdDTg2wFVHwgE5ixkem75dlI/QZ3CS0+dSg8l6Etly2LD5zbgPCE+/wT1r+DkaiIN9PqtjDn0SyrxO++DHA9sniSRP/sEaYndk/XzZwec6yMjncaGRoPyJNvmJMUSLYns/TSJLC8nnHgcho27sP3QsIKS4sKHacnbbOP0kHbVsCVKeOfewvTXAMBIGw3j8SK+16rOVFvymNlISiJQYEWIqD1NbkroN4/BTL9mlEO/Kw9b07FOcDhHuu1SsroZunUjxtX0OmQZxlIx+Fudyc35OzBCklghcLQWTv9oXjQz18LaBxJquFybKfeKFd7OSPx70T674rfrojOeXmUBiAAMM5sk+U3uc44GPmOQBeTh8WiVxxF6lHnjknQPmGt1Z+mvkFszFuIUgg6x9SPPbd6gABMor+2OB2/1gDOXgyYEKVrgz/uK3+Hog35L0oMbAc6ewGKK9PQt7AMvybk2WCBcCRq9rJo8fqhjnDesyak8atMxUQaHvL8I6b3/IpA2mfduKMUkmrX8cDG+AtvBh3AEh/eWlPuLeD0uEhFDJA+I1Y3/ep3VzQFbqnuqR7jmgVWtEo/taYlwUhYQrpdNtEgDFfBY3nmZe+OpVP15oUUu8hHN/5nxW10n0kSPn+AUZ7/mGdH3pfkBI2orCIuOw/kSbqv02FhikIuN7pnfmukh/ZJnPDQrrSuDiF/sKK/oGY4x5RQ3Qa6h+dc/oLbYyM4D1FohD89HBl91lWlYuiQCCKhkG+edRs2+6LfUdj74yjmWeXQ/sh9OzKxfqW+ILJ7/yt8hN1DLydloWP5eJnep7zwWdq5aH+eToxABbrn2Kky15M0+oa0wPbUGRF5980YqpPpqMGHty4KIyQV8iPY9eIpdT6fFm8Y2FpvhJP9kYvTNljNreSPAW0QAlW+ZIv1HkE+OawoQTRjZM2d7XbTXUHuZZuk/q9W99ltDpE3I7jm8verVY6X4VPK/RCGLClB
 HKdmwXPY
 kVyL9xQP/lm/ANqpNmQabC6BIaKUseakazsqN91JUbNpi5EeZiicSK6IC0576NgLbsJiOUoPZgc9DPln1ogDeLX9oXbl4MGRvCFH8dzZiif//8v4pXRaUefKgwTlYZ6F+qsBon4JnAYyEFocjx2W5v7u0aCS667ViNsIL/1dUlui+vQaxCdARK48dB5HDi4MmbU63eL9AC3cMSKsOdO9axBcNi1WRF/rNREAuQhdAx+WWFebhU9NqbubfoNJdVW1ogGoUmeObCXtPO/po8/t8fsN0a1uT6eODZpChYBtkJNqU9DTfiNqrXsN382O0utL
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
v2: address sashiko comments (duplicat bnep.h entry; missing its
    "conflict" marker);
    drop moderated mailing lists
v3: rebase

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
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org

 Documentation/userspace-api/ioctl/ioctl-number.rst |   22 +++++++----
 1 file changed, 14 insertions(+), 8 deletions(-)

--- linux-next-20261123.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261123/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -130,8 +130,9 @@ Code  Seq#    Include File
 'A'   10-53  sound/core/pcm_compat.c                                   conflict!
 'B'   00-1F  linux/cciss_ioctl.h                                       conflict!
 'B'   00-0F  include/linux/pmu.h                                       conflict!
-'B'   C0-FF  advanced bbus                                             <mailto:maassen@uni-freiburg.de>
+'B'   C0-FF  advanced bbus                                             conflict! <mailto:maassen@uni-freiburg.de>
 'B'   00-0F  xen/xenbus_dev.h                                          conflict!
+'B'   C8-D4  net/bluetooth/bnep/bnep.h                                 conflict! <mailto:linux-bluetooth@vger.kernel.org>
 'C'   all    linux/soundcard.h                                         conflict!
 'C'   00-68  sound/compress_offload.h                                  conflict!
 'C'   01-2F  linux/capi.h                                              conflict!
@@ -172,10 +173,9 @@ Code  Seq#    Include File
 'H'   FC     sound/pci/asihpi/hpios.h                                  conflict!
 'H'   00-0F  uapi/misc/habanalabs.h                                    conflict!
 'H'   A0     uapi/linux/usb/cdc-wdm.h
-'H'   C0-F0  net/bluetooth/hci.h                                       conflict!
+'H'   C0-F0  net/bluetooth/hci_sock.h                                  conflict!
 'H'   C0-DF  net/bluetooth/hidp/hidp.h                                 conflict!
 'H'   C0-DF  net/bluetooth/cmtp/cmtp.h                                 conflict!
-'H'   C0-DF  net/bluetooth/bnep/bnep.h                                 conflict!
 'H'   F1     linux/hid-roccat.h                                        <mailto:erazor_de@users.sourceforge.net>
 'H'   F8-FE  sound/firewire.h                                          conflict!
 'I'   all    linux/isdn.h                                              conflict!
@@ -219,11 +219,12 @@ Code  Seq#    Include File
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
@@ -242,8 +243,8 @@ Code  Seq#    Include File
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
@@ -264,6 +265,7 @@ Code  Seq#    Include File
 'f'   00-0F  fs/ocfs2/ocfs2_fs.h                                       conflict!
 'f'   13-27  linux/fscrypt.h
 'f'   81-8F  linux/fsverity.h
+'f'   7b-7c  arch/{alpha,mips,sh,xtensa}/include/uapi/asm/sockios.h
 'g'   00-0F  linux/usb/gadgetfs.h
 'g'   20-2F  linux/usb/g_printer.h
 'g'   01-0F  mm/gup_test.h                                             conflict!
@@ -308,8 +310,11 @@ Code  Seq#    Include File
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
@@ -334,7 +339,8 @@ Code  Seq#    Include File
 '|'   80-9F  samples/                                                  Any sample and example drivers
 0x80  00-1F  linux/fb.h
 0x81  00-1F  linux/vduse.h
-0x89  00-06  arch/x86/include/asm/sockios.h
+0x89  00-07  asm-generic/sockios.h
+0x89  06-07  linux/sockios.h
 0x89  0B-DF  linux/sockios.h
 0x89  E0-EF  linux/sockios.h                                           SIOCPROTOPRIVATE range
 0x89  F0-FF  linux/sockios.h                                           SIOCDEVPRIVATE range

