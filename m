Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A82A606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 06:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=uxNcoI6M
Received: by kanga.kvack.org (Postfix)
	id A93EA6B0901; Wed, 25 Nov 2026 01:13:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6B586B0902; Wed, 25 Nov 2026 01:13:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E4E16B0903; Wed, 25 Nov 2026 01:13:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 589F66B0901
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 01:13:57 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 16C791C48AB
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:13:54 +0000 (UTC)
X-FDA: 85472625588.10.45A9D4C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3FE35120009
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:13:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=uxNcoI6M;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf29.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795587232;
	b=Sh62w8jvhumJc8eR19SJ0g+G45i3xU+gBXP/NPweYzfRfwWjeoG8ZR5MGnTS89Ap7qT8jp
	tRUUnhwPOG/NkzBLhF1+Q2Ni97K1CwzvlbKkbu2AViAsA6pugjxwvVc7XG4Yfd2EJM1YGo
	LpklIRTW1WiCP6qtjMSd2uERHpcnAHA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795587232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0IFuZctU63qMBL9OiRtsLzcTtZ36FSyouPZYbIBTZ/0=;
	b=rn+GBATav9j28b37zGJnDpw/2Iq4cSLfSAEybufXbPpNlOz0e8h5ulFWUROGaWjoPYbrnM
	BiK3Zuf7FwRox4VmDlehULH9BceYqo4tIA/TGLE/QkwR9kHMpPQTvg6mf55IzBudGd711U
	OtfNbbROM9E898SiaSBDXyv8Qifzcv4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=uxNcoI6M;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf29.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0IFuZctU63qMBL9OiRtsLzcTtZ36FSyouPZYbIBTZ/0=; b=uxNcoI6MCqU9rBuc73yaH8xo6l
	2yYcNWNIPorg4aZ/T4b0v7okTLhqaM1gWcRLUBSon4BdboKsNJ3K7r759+pkUSZHck2vKNkG0NL5P
	KK2hLSC1P/0fOHq2U82ODyoifmJ2meIS/F9hq784v96MjZrq/x5HbpCnZORyDxNPRs6I3+aHFtBbA
	+mPANcnHk7/FdiHsM8mTwntxXmnGzAZt20ctJJ2g5mfSgwZWfYfi0ycODdXAyOQBH+iJWdG273w/O
	FWhcVTysGuNxyBOS/1uOHo0BLy+uKnfozHIgQhst01er2hDOW9Sv+syOnQk8AqvSlDx8Rltwg3giu
	M7eTA0ZQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xW6GM-00000008Wvh-0W6g;
	Wed, 25 Nov 2026 06:13:50 +0000
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
Subject: [PATCH v3 02/12] docs: ioctl-number: update sound entries
Date: Tue, 24 Nov 2026 22:13:29 -0800
Message-ID: <20261125061340.3402300-3-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125061340.3402300-1-rdunlap@infradead.org>
References: <20261125061340.3402300-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9mk7yyqa4fog3fark8t1eyy1rzqf48qd
X-Rspamd-Queue-Id: 3FE35120009
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795587232-701525
X-HE-Meta: U2FsdGVkX1/rMXvdWkMEpbXl96iHjGu7POAmyuZBipQdZVI6fKQRl77LVRnLlH/AnAooKm0YGrQYSPV/pkfcwCpVU4t30uUGpfo15XgOxSYBay6QwaVeEk8PnvP3E5pOavhzpUEcF7myAsWSARXJZeEIIOSrUpsR2p3bzyvnmcap3hJ77xoceKBivvDC7YW8b5fJG5IZIHbGli0WIrF/P9dDNcAyUYiYf22VD1+4YPAQqGyKO6CdidrHiYAcY7gbnR9nPnuZduE0Up0s0ymkIIosnJAN9LfxXLK4BvU7SRUeLuIuycGpCngUQFi2Cj2CuoY1dncQM4JamJExPZE+MQnb15Y7X43pMhLNd4xBMVYcdvxe2o7C/B+BIIkWlgf8MK+JublVZZSwgR+Wbf8O/lwmrfY/cnYRUU0wb+ZTzAQ1XxOf+LKXNdyio1SFtVVEG9rtQY5ShVvVyiuTRD5Fsuw2ITA9AEVlU3tvtB2OJtcxKfAKj2TOZnBkgXBtOTdE0BDAL2q38erMaGvm74zKmiF2GTmXsM25R9I4ndGRpIDjQughUjiltLU6AYqgsh5oHwVD1vnZcKwts8JUoPlRA4mX+0ZuTQyDWd3uLId5bTP+K6zKB6+8cBm1oTamNbRK2A/b2Y56XbzhPH2JSw6iLgwHMiERskzA9tp7yDE7aP8wxrlXuVuBgZDMSBzGwR2QF3PI3VFOWpx2b0vGIFPMdiKfQvtHZM4BSEEwvQYcAgDX8TknjcSuOVz00i+94r92cgzJNFFnLAardsw7PzE2/thIwPqNFwnwDy4nkIsCYLIx9BJpRBu1QbpQfsAHPDgvnRqjP+VE3JJLExrunPp+D+85avxvwOprlITARjdTedUPrAKKt3FP47hIOzw87YO7ylv78KN3kgchCcghlTnLx5G0aO1vnrIMOZ6OdE/iqgRd8TShDuhNlgmf4qrx9acAzKlPMSLCysUEqTurdum
 2PWV8xGw
 QESY4z1UD7NA1jexjdSDDjxjkPdRtHIVUXs1W/xju6Z6YQMp/eHr6+ag6PcvLJG0fnPvpzfW0o5VsOnSaC8RE6cIsX286dwwL5889GHsiLg84tw0rCvNrFkliHP1E3aHs3D10PscxkUKkpGqAVAKMfDps5/TXFqJajsQNGOGWkfDtafdHGXdCZuyuS9nzSlG4kv/zGQe6YSQNYCzeFDTrY7nquMBaf5dxNnIU5txMeILbtBbXIem36dc5sEVfoApwh1+owlkeAv/sAVT1fjXlT9om0nKsqxIRcliWmdFqxiNIqrlcpWaZNJMp5Es8+3VoBzXUK7p/mfBlV7SkWp56FMeAs2BYy4kMzS+aj+2J9ariSXCVQaGK6DPY+U67ubtUGir3yGXf27rYrBxr1B5hiB4c+mGXcM3usSpXrZkoSQiivm+gTXGQYqHINs9xuO5bRt0exNb3c4P8vZlSzs1UQA8iWTD6jmE3LaGX3TOawSnJ9o3M4vFdTSkE+DaWGe7BqcYPgEiap5p5hZ7p1hBdmJPrDILheSk4ahJY5+0MyZqqMyb4p8aA/Dl7iAds+AVvKh6YBQcWDcJacHXf2D1avZjDJZGz3eBkW4K7Hv7P0PEvhyPU5STTR8pCO5w+D4PJa8k8KR0MLDfH/kP46dI5Hz4bo/jaFZ+7hdx9EdYVKXYEiwyBTo5fnCpgEMe3S+GsxqJjJc8eUF63Z/E64IR9DUihuYzG/phzhKkKoCRP3KDyLr5bVrx8oOu4lIkJCZPSvK92ORb8KprjAt7xzvPFtW2BLj3PTorlBdroob0O5WZ89VeUNp++L9GmP+2qamlch+kD
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
v3: update scarlett2 'S' range (sashiko)

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

--- linux-next-20261123.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261123/Documentation/userspace-api/ioctl/ioctl-number.rst
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
+'S'   60-64  sound/scarlett2.h                                         conflict!
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

