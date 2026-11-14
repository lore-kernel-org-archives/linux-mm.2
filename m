Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC397606BB25
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Lll2v1Vg
Received: by kanga.kvack.org (Postfix)
	id C2C736B05C0; Sat, 14 Nov 2026 15:27:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B66D26B05BF; Sat, 14 Nov 2026 15:27:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 943C56B05C3; Sat, 14 Nov 2026 15:27:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 689226B05BD
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:27:18 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F33351C3C24
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:27:17 +0000 (UTC)
X-FDA: 85434859314.02.3A24C3F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3DA39100003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:27:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Lll2v1Vg;
	spf=pass (imf14.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794688036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UbmwYeTyCihJtSZLk63m5z0KzwYndJc2EHWvOsqTpUQ=;
	b=p/7h/SChgU4sLHtSgnI0QV3NHJaGlpswOQH4lxB/el7k12eii+PvJZ71+al1nILlt282I1
	fhBOticyavWjnfcb4DkSJMdeMmfdU4LLSD1g+xAY0AeKVnOq3t5dC+Jyg9MUKjkdp7IptH
	9np/ng4Q8CYGwIbJf0ognYpMdpmip0U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Lll2v1Vg;
	spf=pass (imf14.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794688036;
	b=vj9u5VP0dMw/E/GzNfIHDNVKOsaYBRET+NyNATA/0h6dHNDM5L3JhW3704HqWob4tcvVfb
	JnlFYCZmZGEb7Qz3dSqSzjGC95fjjtGXg4Q2stvY6v4n1G3+/tSNrYYnELet/5lfseBzek
	JJV/QTU52Z3PbvdIVyFz7BTPevPOQnw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UbmwYeTyCihJtSZLk63m5z0KzwYndJc2EHWvOsqTpUQ=; b=Lll2v1VgC79o9Fes4dZZhe3ORz
	eQHFmQRElgxX7Tu5xzcxGP7/vNljf6PLPh1EGxc/AD1I1X8ZJkppNH+AEHU4jWnwMHvl76MKTqxAe
	4Qx4bH6DOxyuGnY5YdMV60Zlx/2jxO0zYkhVepX+QjJlFsdoJAUJ+O95ooMLpf2v/rafUyQ4xvkw0
	2m2y1pzWNSqMy3qbRMh+piW4ibEYb+oOZ8v8I89rbtlIu0m0BzjRqOwZgtrgVOL1xgijv3cXZBC7n
	ulw+z870ZwWh2TdeqbPrdaU+Awa1q6BXk1KMWx05apBlmz3vQxFE88Tm+lbWarCp06UGnphrts7qk
	IMgkh3xA==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xSKKx-0000000Giga-2h5V;
	Sat, 14 Nov 2026 20:26:59 +0000
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
Subject: [PATCH 02/12] docs: ioctl-number: update sound entries
Date: Sat, 14 Nov 2026 12:26:40 -0800
Message-ID: <20261114202653.3113381-3-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261114202653.3113381-1-rdunlap@infradead.org>
References: <20261114202653.3113381-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: byc51myhyjqq49jgo9kozhznrkfma3at
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3DA39100003
X-HE-Tag: 1794688036-123726
X-HE-Meta: U2FsdGVkX19xvdKzQpEwcRtOeGkmPFzTewiUSC3aeQBVd9NhMcKvWfNrdCgZwShItA1fNwXu1HWr//Zl54SwS7PqQzPR3Hs8OQNJtXyNKlMVSqqbJk4+RLxZmqLVFCX6/7fVAuVb+smN8Lz8qz5KMuQTnIb4NX+V/qeADCHg7DafgMNODkD2Z8aBRpUrMSLjTpTipILkWEFIda/PG6YSETuK80lg9T6JYs0LZXqSGNGLw9A7K+UdLpsjQqy88p8A7I8AF8p4nbryvkjEWRCt4d6QLbRHTupQdZOrHztNFvN9yAXQIYWNw8k9jYN54kmrpcJOG4BrN5ua1htQSQfGKXfB2zR+DAJvjN1Snbdx2bUw6zFTTUkjDD9+ILUTRwMbvuvEFYPBjIkxfwHE16jB83RqO/0MdPN9LH2Nem5+/0i09806jpOTzlvJZdlJ00LieO6KITKLoCcn2mK5zjXc8s6mKa638G8MkSuJy8hQArWO/L+JaiFxaj/YRHFqOC1vYFkm1NQ/asmWjgUN7p6+c8bW0pHWruQuB/HQRMDC8eqrSqTFmm5bF8jVBKPRrxRg5YU96FvmwpQwsfJUu/DiyxL/pXepfgi1JLDQAinRr1q2xuSsDJgpkOrqwY/73tzbPrDsJ3X4NeH6wDBmF4BKMnKf0+8/7+xWXzPCIEYXVbTW1SBBJb17Qcwg0kKRnqguV5YWDw9IWcCZwA201VUGh0OrX8MEEUnV6g35KGV0lFrHySWYVkqhpOya9sftzRjpbMnc53g+id+I5Hb+D8hwmw+czyEhCpZXGQLxQXT0wNCtlyUxv+6Lok/OvZLvy6XSQl89Vr7aPfRuyO+R0HupdbooQhllh3EKMFZr4Ol7p9h2y2aV74CJhGRonaMvs2kasNUaeEVM8Vk8rl+yCYtAdJlFIcEGEiEJugd54ZW+xAJ3SirVusD71/96vX9khSILVJt6Iby7WkiHBTdgL4S
 nkuiN9wk
 qnm9fv7ez0BZrZYfREZuP3xFV4z43c6bchKwCON6yqP9IPE85e+BYLZBOq9v94gWtFdc/DmwVT6ahI902FM0ByB20Qkwivxr3d/lDcImTJE5M+dBSHZwFVW42SIY6cLrQDbL/HiuvEZWMog066OteHx3yqF6dRm/aYqktB4LQvh+5MRqHInbb7hs8mSRBBXjmkP9KH6933zKNfcqWvcGswWIh04sshtdm8Eka0BI3att1dzArsJjbEE3XU2N/7FmgR1K24PyZ1HRdKAZwBK19ej+F1mmTlgQhp0e9JgNUxWD5NLa/Q73nl6SGYK9nIFhTgRObZG71delIQ6UouI/eP9MMxH6bASJ1LcbUA8NNExpGUctfU7XORpy1Y5ey8SjGmogjkOk9tXzdc7UEig0ZY6mSrmoPbICp5pIKaELpHH1tv4aMik0OKbLwkIweWRSWDXXXfLOCdDcM2il6rrGSR1Ece0DyIcqQzxiABFdQM9fLQ+5guOaIc8LfvRxaJLhXsX7S+b+GITrXOQWi2ihja/70AHy7nhjXhK3tDnPdjjc/kQtRX1C3L57vz+eZwdTMCsnxJQ2EnyxncW7Mf1B9wi1J7l0F7210IsaO
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
---
[Since having multiple maintainers trying to merge these would
cause some conflicts, it would be more manageable for Jon to
take all of these through the docs-next tree.]

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: linux-sound@vger.kernel.org

 Documentation/userspace-api/ioctl/ioctl-number.rst |   12 +++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- linux-next-20261111.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261111/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -122,11 +122,14 @@ Code  Seq#    Include File
 'A'   00-0F  linux/agpgart.h,                                          conflict!
              drivers/char/agp/compat_ioctl.h
 'A'   00-7F  sound/asound.h                                            conflict!
+'A'   20     sound/pcm.h                                               conflict!
+'A'   20-53  sound/core/pcm_compat.c	                               conflict!
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
@@ -160,7 +164,9 @@ Code  Seq#    Include File
 'H'   10-1F  sound/hda_hwdep.h                                         conflict!
 'H'   40-4F  sound/hdspm.h                                             conflict!
 'H'   40-4F  sound/hdsp.h                                              conflict!
+'H'   60-63  sound/scarlett2.h
 'H'   90     sound/usb/usx2y/usb_stream.h
+'H'   FC     sound/pci/asihpi/hpios.h                                  conflict!
 'H'   00-0F  uapi/misc/habanalabs.h                                    conflict!
 'H'   A0     uapi/linux/usb/cdc-wdm.h
 'H'   C0-F0  net/bluetooth/hci.h                                       conflict!
@@ -168,7 +174,7 @@ Code  Seq#    Include File
 'H'   C0-DF  net/bluetooth/cmtp/cmtp.h                                 conflict!
 'H'   C0-DF  net/bluetooth/bnep/bnep.h                                 conflict!
 'H'   F1     linux/hid-roccat.h                                        <mailto:erazor_de@users.sourceforge.net>
-'H'   F8-FA  sound/firewire.h
+'H'   F8-FE  sound/firewire.h                                          conflict!
 'I'   all    linux/isdn.h                                              conflict!
 'I'   00-0F  drivers/isdn/divert/isdn_divert.h                         conflict!
 'I'   40-4F  linux/mISDNif.h                                           conflict!
@@ -204,6 +210,8 @@ Code  Seq#    Include File
 'S'   80-81  scsi/scsi_ioctl.h                                         conflict!
 'S'   82-FF  scsi/scsi.h                                               conflict!
 'S'   00-7F  sound/asequencer.h                                        conflict!
+'S'   21-23  sound/core/seq/seq_compat.c                               conflict!
+'S'   60-67  sound/fcp.h                                               conflict!
 'T'   all    linux/soundcard.h                                         conflict!
 'T'   00-AF  sound/asound.h                                            conflict!
 'T'   all    arch/x86/include/asm/ioctls.h                             conflict!
@@ -219,7 +227,7 @@ Code  Seq#    Include File
 'V'   C0     media/si4713.h                                            conflict!
 'W'   00-1F  linux/watchdog.h                                          conflict!
 'W'   00-1F  linux/wanrouter.h                                         conflict! (pre 3.9)
-'W'   00-3F  sound/asound.h                                            conflict!
+'W'   00-41  sound/asound.h                                            conflict!
 'W'   40-5F  drivers/pci/switch/switchtec.c
 'W'   60-61  linux/watch_queue.h
 'X'   all    fs/xfs/xfs_fs.h,                                          conflict!

