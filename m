Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66750606A325
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 05:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=oPKecQNT
Received: by kanga.kvack.org (Postfix)
	id 6E2D06B05C1; Thu, 19 Nov 2026 00:35:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 692DD6B05C2; Thu, 19 Nov 2026 00:35:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55BC56B05C3; Thu, 19 Nov 2026 00:35:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 143536B05C1
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 00:35:48 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 74ECCA0983
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:35:47 +0000 (UTC)
X-FDA: 85450756734.11.43B2C07
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf18.hostedemail.com (Postfix) with ESMTP id D56ED1C0004
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:35:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=oPKecQNT;
	spf=pass (imf18.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795066545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ELh5lc2aPOWRUhM5D4IHCHtXzMf4oMgv7S6UUVSFuJE=;
	b=ZYX3uUFb+B9iSJXOgoRw4XJKrQHrOc81eChUkbZTsglO7xUh7+0y+izW9PXfZKYAholx7l
	o8iria/y07Lg/8/LkXUHfaeZcEjyzFSZkqFgaqoJ4cGQo/gfZTHW+l3G5+C/iedFX5JlFE
	S8UKVYbgd6idyI0LSOfpbs51WvGWO/c=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=oPKecQNT;
	spf=pass (imf18.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795066545;
	b=5aMBDK1GmNe8uOogVPFnq81LGxQeGaKZisEC4CdnSKHdMu0wLQTRT5E9Yt4Qbo32Z9jOk7
	6/VENjT4yA02eLKwZHqgEx3M+jLxBqajbBEuCN1x++P1vM9LCFsnBuTm3L5F69pf+Nlmti
	+qybmgVhhzKdrc07vbnjMXJy2BiSNf8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:
	To:From:Sender:Reply-To:Content-ID:Content-Description;
	bh=ELh5lc2aPOWRUhM5D4IHCHtXzMf4oMgv7S6UUVSFuJE=; b=oPKecQNTYubY0Dp8vcR5jIBDM2
	3Go3aVyKAU8FdmIpJi0naXVl32KClQXNvqJdTYxwmyxklmJW1MrA7JPp/pE6mBxz2VslXr2LvZSl+
	AsGoZqPUrizrPpY6noR/PEqIyZBoLu8l8FRiHTaAyMwQOskhrXcfXawpj9H2ly2y9+K2mcen5J5Di
	Ll7sBPow7Tfn5dKijG8+yV7rRHysHc8oY+2/SqopSy+k/yed8FxbJcCx/nEhEQ43n7Bgb2Nd7MSgh
	h1tzWKOF5S/oRaOnw2K7+kpqzYEXYQ9BLusF1w+9yCNworNuHqSQVRF0wWahdtCddIrUJPapoQNHk
	wSYPaUjg==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTuoB-0000000Aufu-26GP;
	Thu, 19 Nov 2026 05:35:43 +0000
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
Subject: [PATCH v2 09/12] docs: ioctl-number: update virtualization entries
Date: Wed, 18 Nov 2026 21:35:10 -0800
Message-ID: <20261119053514.255348-10-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261119053514.255348-1-rdunlap@infradead.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xca5yehff77usw6ribyf5jb4cje1apef
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D56ED1C0004
X-HE-Tag: 1795066545-124721
X-HE-Meta: U2FsdGVkX191XTNMrREHUPWJ5lIiDy6wtG90u9QjsgDqdgpafAR+l0XJOiLWNc9iTOSBeF8NEPxFD4wsEkU3Az94s+l2//ev9HH8BGS671bDbX3xdJZFmroLu6MYVlliXCdFreoZKLpAm+jWSGSz4cF6cnlwhr4V3tQVduCKnOHILkMnhcJBst+8RTX3jqH/oIKTxbxIp+b4cZJO5U8aQrRhbzfErDayEuAZ442wyMWIGDMeEYioUO5bE9jbC8QAWSf3Y/AAkTq22BBubHm7UT2kZXpRJlj8MvJHCX/GjRXz12s1bJoIECJOJ3p9MVyiV7cnLh3kHMiOoY3HkZE73Vg87RsYTZ/68jfdIr6NJlvAsopTEOfKWr2/zjXCT/qmg1/KzgPRzGRJQpJWrMVGtlP8AuhsE89k9/CyMBVgF4n2KVdU87jLuxN45xy2sOR55CHBIoqRv46nHA4jsnitjZzfEphdJ1HEliJ9b6ckLk7PDkdRvogr4thlCxYKAKF4IOofkiIuvLZDZVzOmifldl4Ymg41PN6OYRHSa/ny46acZlyE77NspXzQxQn0UEd1SkfgajmngDb9M3fp5STK3NnOtZnySSHzXeS0p9URivfhRishpzU2+KTZ0Gjaq2mJUIqergUPBRsq9mmq853i9kogbZdKV7CUvMoWLa2yF1DyNDsTJC7WhcMTUeemIVro58aKS+1qeiNk9sQijtRPRFS8lv3YRs+e1eNwwnmJFbjFDZcqoHW7E+ZEEr1C8/oLRepyFLV1I6uZ5LYfzksEsjoYU3LQoi3+0nb+8auPV4iAqz39PvXNKjp/ervr8pAV4gmU3YexoRUQPkV3BFKG3DDU7pGABVV+wZ3I8+gYuT5K+FOqTkebTZpKNJKP2oYbPLOLzAjKk0gXYVtKNbXJQOdLQ7AkRPiY0orJS4/mTx69CEz55j9r9RDlXyimAeE3sS2gUnCNe27a/txCPc+
 Bg65YcTS
 VCXeUDspLwlJy+tnFV468ow4TenzWOGcbFJia5HpvaS/5Hl5RqjAC/y1BLbQ/GHGtKTF9MVHoX4C04kg3MO/oibi7FNAhbmud/mMrDYyQ5wtMW2hw73JBrGB1POdfM/Ma5U+cGMcyv863vzezSGmTYWQRe3cJbQuYlvoSSAnDRDOhHzbaZlve+Ik/k3YtCYZy4FI17gY//D5JgZ3Te3jSfqhej8H4OvxvFSDDb0A8k0UQaTrm7Ye2PXPQtQSwHGP/xDQ2SpK5RG6CDGwKhi1QA2ZC9d1MVBir4lB2If4JUI9PjklLGtylQ+KIyV2MNiTVZ8LBQYfD057D6SG9blxap93aJHxWUg75p6lZn7T8nwzjXWvVKrSE61gWMZxY/j4CZx9grURp6UDs4PJX8FK8sWHJ1jDByDSQ5MVuUHnw4sybTVUcr+JFySulb8yhaKkGyRZ0mM8TyuQV1BGPjxy234Y/sXjgZtrJC5oyIK4/b15IilnTcOVtoh9eD1+wuIP2CGnswJaflRhIzdQyzx1sS9dVBsNUJrZwmTBueqoDw8NoLbjZ1pWP9JObeNRtbS0GIaBXgBXvf+bc6baq7wcNVxQErr5SbEasjfd6Hva+JQiH+ICPdAgKgkAtAEIOSqCPEdpUARRTxYllOMG8aTM48B8bit3oyKnsU+BHT/+qC6ZQSDanVLcTupmXraFaULvHt5UGpB9p3jsUmUCMVi/pfODmKfRhXF0UcEW6uYqkvV63spY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update the list of files where virtualization ioctls are defined.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
v2: drop 0xAE, C6, arch/x86/kvm/x86.c (covered by line above;
    Sean Christopherson)

[Since having multiple maintainers trying to merge these would
cause some conflicts, it would be more manageable for Jon to
take all of these through the docs-next tree.]

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: xen-devel@lists.xenproject.org
Cc: Hans de Goede <hansg@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowangio@gmail.com>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Cc: virtualization@lists.linux.dev

 Documentation/userspace-api/ioctl/ioctl-number.rst |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-next-20261116.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261116/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -198,6 +198,7 @@ Code  Seq#    Include File
 'M'   01-03  drivers/scsi/megaraid/megaraid_sas.h
 'M'   00-03  drivers/video/fbdev/mb862xx/mb862xxfb.h
 'M'   00-0F  drivers/video/fsl-diu-fb.h                                conflict!
+'M'   01-03  xen/interface/xen-mca.h                                   conflict!
 'N'   00-1F  drivers/usb/scanner.h
 'N'   40-7F  uapi/linux/nvme_ioctl.h
 'N'   80-83  uapi/linux/ntsync.h and uapi/linux/nvme_ioctl.h           conflict!
@@ -238,6 +239,7 @@ Code  Seq#    Include File
 'U'   64     drivers/usb/misc/usbtest.c                                conflict!
 'V'   all    linux/vt.h                                                conflict!
 'V'   all    linux/videodev2.h                                         conflict!
+'V'   00-1F  linux/vboxguest.h                                         conflict!
 'V'   C0     linux/ivtvfb.h                                            conflict!
 'V'   C0     linux/ivtv.h                                              conflict!
 'V'   C0     media/si4713.h                                            conflict!
@@ -356,6 +358,7 @@ Code  Seq#    Include File
 '|'   80-9F  samples/                                                  Any sample and example drivers
 0x80  00-1F  linux/fb.h
 0x81  00-1F  linux/vduse.h
+             drivers/vdpa/vdpa_user/vduse_dev.c
 0x89  00-07  asm-generic/sockios.h
 0x89  06-07  linux/sockios.h
 0x89  0B-DF  linux/sockios.h
@@ -399,6 +402,8 @@ Code  Seq#    Include File
                                                                        <mailto:kvm@vger.kernel.org>
 0xAE  20-3F  linux/nitro_enclaves.h                                    Nitro Enclaves
 0xAF  00-1F  linux/fsl_hypervisor.h                                    Freescale hypervisor
+0xAF  00-8F  linux/vhost.h                                             conflict!
+0xAF  31-32  drivers/vhost/test.h                                      conflict!
 0xB0  all                                                              RATIO devices in development:
                                                                        <mailto:vgo@ratio.de>
 0xB1  00-1F                                                            PPPoX

