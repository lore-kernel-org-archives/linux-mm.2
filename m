Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6384E60A5BC0
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 05:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=21KMvBVS
Received: by kanga.kvack.org (Postfix)
	id BEB3E6B05B9; Thu, 19 Nov 2026 00:35:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9C5D6B05BA; Thu, 19 Nov 2026 00:35:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EF1C6B05BB; Thu, 19 Nov 2026 00:35:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD4936B05B9
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 00:35:32 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 52D751A0948
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:35:32 +0000 (UTC)
X-FDA: 85450756104.29.0229276
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf04.hostedemail.com (Postfix) with ESMTP id B45A440003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:35:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=21KMvBVS;
	spf=pass (imf04.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795066530;
	b=nxrfGH5M8hrMRTyGJXY6XTJVxcU0rL6O7FTjj+fnvG4YHXSoP5642Ydx0Dx1b8EDlxwVgZ
	X2ONYIOCMQEM+S/VLRDeJfZw/8PixUZKJCnMffJyIBiWOUGxaI8X06EKWYb/pYq9CiyTxi
	Zch6Nr4rG2+bkXhNxAyrTv+zkxK275g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795066530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+gOx2QgB+hpP7MCoJC2GHmTIyqlHXmH+VrhxZ+vlPAo=;
	b=BHgHElHz4W0XntxvGqboSZ7TkXUvIwFAqW3UUqnzmzFVB8EtxJg+T0uJzHCdwj7Vz6+GNI
	x2H7KAeDrbUe8z8j8RmcwfBqthZFRKRtsbYsSBvWUZekrGPAvllqd79PPxoIWmWcdiKTjg
	5e5+qoRFaVL0Dd9eU4rQtF0U8sbEpKU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=21KMvBVS;
	spf=pass (imf04.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+gOx2QgB+hpP7MCoJC2GHmTIyqlHXmH+VrhxZ+vlPAo=; b=21KMvBVS9aAPeZb830CX75Ewxo
	Fjr6DfdpCfqdjhEX5skJdo7foilZqmV2B9PmG77H8NC5afT6ZjTxPHrXeGCKFebe0SAR4iRzIR5ep
	o5kM6r3SbXA5dL5yRVpL6k6KB0QegmzeFYVbEJ+ZILDYyZhVuaO4fOzdY6V+FRAUFBLcch3KwXwhl
	kUderx2xCE6O79W2uSLoOeV6OR7n86HJVEzR6RoX6RhgX89jZXUYDB061+3z0kRitcz8ftruckr9C
	VuJahUVOUstXhGaBInVbk0vEx4f4otphkMuv1jd4qOmf60SzgqsUuKNvK9wKViqHMaMiODIi4fbzG
	v8m772sA==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTunx-0000000Aufu-1gcz;
	Thu, 19 Nov 2026 05:35:29 +0000
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
Subject: [PATCH v2 04/12] docs: ioctl-number: update networking entries
Date: Wed, 18 Nov 2026 21:35:05 -0800
Message-ID: <20261119053514.255348-5-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261119053514.255348-1-rdunlap@infradead.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B45A440003
X-Rspam-User:
X-Stat-Signature: 75bhyyugkiiah9f3bwxy3d7338r3t5nb
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795066530-230689
X-HE-Meta: U2FsdGVkX1/Zld8g/ZEoa9xhjFQclHDNNgc42sgTMF3CBZcG0X0g69Gd8yySJlBFbNOxuTntfzWh8GaaYpP882Ksp+AfDpgj6wIuwYeqK7lwjftnxgoMfKIBB2UlgxEUUHsZz3Ge0ceYi73vY1Q6Srh5NOOobeKmtFTcCSjNaDnaEfJWJJNJpaN+LX2eHlQooia0LSsIGQzNiUZjmp+2924P4yeR/0gJgAav+Fh1V+/XFMy2HY85E4/MK6gVKXTLov/ruCFkzabISqYYx7UHr3k839YOmWT2NYVYkWkjCaRgFiA9a4rk7EU9MQ9CgHwOL0/x9HfKmO9+Lki5qVdSEGUhE2/ouWZht2drcmrBT353xkYPYQEzHqjKUeT2EytMlQrWucTsDhcBeWDNhZZy8miBTcFRuhfgIeSkmSsx5dxJPpMkm6DN/wmdK1n4YlDVN9R6hykk7QhNlvnidO6TZhAI+QK5HNDwuPcCwIEPRv+aCSHWBrYEOttNp41FHVujT1fuQMmFTxjyX0TW1f4S2rvsC0pM0EoiW752aRfEwDqPk5FSc0N3gWk0c0GzS4FrdiRUlb/ZIAVFVJwoQ2lwRcTlZ/yChUov/X36QSK/EOQMAkQe/1lV+iq6enAImNyCza9oOEzugTWe209tTeizRGTmisv7ZvgmKm5YDkHgiE+b/xGS8Br+6X0vwnZ00aelyVhuhx68STjHKxXKOjulAbHBFa/mSUze1N4Lc2nrZrUH1PwvWOOs3RoKIVz3pRlu9ijpqqevIQc4D2XJ1Bj1dDvv7UGsJ5kD3Cjf/IoMo37qKWIJNKT8MiHjp23Vj2na4mt6O6svR7u6Be/rcDLNG7x6I4VaWVFUNRp3z1RTzagj2wwgZfKBmT0x/WReH0zyJIwQbGXH3R19VWLjvcDpYWYymOa2ddeBOMo64vf6YqVsD1umjjM2WbSjEd8BaxpTCqZtUTBvpM7NPIt/X58
 lL95xk7Q
 pe6hDyWRLXOPue3ZSXBqyfZRYsmfrIKjyyUj/1jAYz6cCKrDBhkg1vjKsBMCuSQuSA6dPj0NMq1psAm+zt41li9WsbfQCyP1EeMeg92IgxD3xJ31HZtUrhEksDC65ylvy6A6O8wbD7JQRXlhIPu8aCNMbsiXYQ118qWEgToy9jjhmG4YPMcNxEXZH9JqTF3XaTB7KqFVT9Is1Sg3pl3tg3cbaiXTvRtbL+tQUomIP30s7qdnwwhQV40sZMaNYRr2OqxlP47ytRY4AX/Qns2s0ypsZX/XZ1+4MNHyVDlAJ3S43FppRPQU9TT9wrgFNzKV97VWAwE1IsWMmrwiWOsUrSBCyotGuFevyKCyEEsuxv1cXeF82Mm51/hmn93JiMQLaqHOdbnQHPH9sZ2RqiKNrAhqBM13zOS56McAGBWym8Cwiy/OhITqEmLb5YS+ApuUWYrVabHdo0DtKTkC8SreA09g9bS7w9HXC21QgG6aUt/pqJi3DUzVEQ6NrfkJT3kRC3nGV/J6dzUIC/RuXGn8mSRJ60noQyVDJoxZua7Zp9lgDcWHSOhd41d1ZRuzql/DxvKF70FVzTcqJGpRCn3d3aEbHqZuYkkGSVF/ZV4dO0/sGt1NyFwZD0Hf/LDv1jw1IYeKQqA8NkLA656t8Rk+A9jAZ04ajCviRcBnnpfTv8XkbfmXZq2SQ6nT7dX2oKYbRqQdxX0Vtvuu7DFxR/Ds6Of9rMREZ/RcEcPduzLMqn8Hmf530kMEN0rkQo/rYczJ7QlYe447l01qTPE73/+GzREYTgvZ6fPkgu+DZrwqtGvqksD1QBpaG099Yly2WD8hi0G/N+SZnDJGRpZNoScJhftwVwJpSqTMekiQKwAsb6VqcTOD+KJEWT1xT4o/Us+YxxV9hWM/pt0WZXjsbE2a7ILpZ7k+65POGbwWXNX9A57cceTkMTXweUaIPS1uJxRC0MRjYdKJ0MqH5UYkVRCvIQJktmzgc
 k/6l9YfJ
 RMH5uLO9dqDHv+0hAfcyjt9ZBq6HatK1ih6QztqIfxzTGKsuj+URhk8FVnO4rnuSHE5h6GY92PQ=
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

--- linux-next-20261116.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261116/Documentation/userspace-api/ioctl/ioctl-number.rst
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

