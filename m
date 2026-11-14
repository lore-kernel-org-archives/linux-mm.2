Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 238BE606A331
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=0SLT31HE
Received: by kanga.kvack.org (Postfix)
	id E4E9F6B05CB; Sat, 14 Nov 2026 15:27:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D14306B05D3; Sat, 14 Nov 2026 15:27:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACA4C6B05CB; Sat, 14 Nov 2026 15:27:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 77CBF6B05D2
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:27:30 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0347FA016D
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:27:29 +0000 (UTC)
X-FDA: 85434859860.14.E9741FE
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf05.hostedemail.com (Postfix) with ESMTP id 79EDD100003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:27:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=0SLT31HE;
	spf=pass (imf05.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794688048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IAcU3Sk2yws/2FQEkwdk+Wb99ieP2EheaQ5FYz3DtYg=;
	b=JoGfx8aC+pWnjMILkGhuQXHxI2sEbtkac50pf66ro8TVRvqoauSRYo72EgHsZMx3GyxivH
	bLebqTY8Vi6IjPb1hh0yTsiAPfhdGA6wqreTbky7OuWR6k4QNbDHcB6nooY2IFbh3B8Y7U
	dbz6GD/C42tLyqtrintTghk/xgQH3Fw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794688048;
	b=tfPoBrl/d4vjuEGMiiMfY+8gmvXHMcfUKxQOqW0ldb7POMeXuC7pO2+9EOgeE/QSY5x2Fu
	m0SCfoj6wW8vAdRZPRktecUyPmmGBokki6ARJw6lgdyvi8+bWPAk6KGpw9yZ+zwW9nHkn3
	RsQK6Y2zJczO3JzS3gce0C3FXk1Wo/U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=0SLT31HE;
	spf=pass (imf05.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IAcU3Sk2yws/2FQEkwdk+Wb99ieP2EheaQ5FYz3DtYg=; b=0SLT31HEl/C5L3thm4eZAYTGl1
	vlh8R+20ZHGqyVfVT1rlNXrJZB4xDac5nm7FlDSWzo5MNbskLMrTSuUsJaDoyYT0tgz7LZVClFhJe
	ioVPGA0bAk+wzLHdY8eQMa4Er1cKPD8rtlZmshOM64usLihNKZ93hLW6po95F+Y9TRC/T6/QmGMWM
	zgalytxeR5Bfmbo8xj+2RWY0TTqTLP0B0/CuPxpFO9y2dCyMsDzMN90W6Jva2FCT2wtJ7mcpqkXI2
	WKOqg2TuPpaj5hfD0aYtIf+0t1WHRJDAVEh9YXAeUBmeO1H3iVmCeT0ft2y7oe+fAAm33X2dJVPQH
	aPc3iMYg==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xSKLJ-0000000Giga-11gA;
	Sat, 14 Nov 2026 20:27:22 +0000
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
Subject: [PATCH 11/12] docs: ioctl-number: update platform entries
Date: Sat, 14 Nov 2026 12:26:49 -0800
Message-ID: <20261114202653.3113381-12-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261114202653.3113381-1-rdunlap@infradead.org>
References: <20261114202653.3113381-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: dtf9uu88ta1zwh4m5nebji9j458wt7zm
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 79EDD100003
X-Rspam-User: 
X-HE-Tag: 1794688048-698960
X-HE-Meta: U2FsdGVkX19ax7DDgDMW6SJtL5Ep51Dek4xXqL/8K7NxgUkYA35u8XWPeDBN7lWG8H8B61hPqQg3OeEfWjo+p3Sc7ogqMnHy/W7ysDPKkv9mVZMOuOM69Y9xViqDNEXn3ZlcO06Z9FRp4ByWkwh06BOmJVfVlXnIlmtxLvv0j52b92NuoAQ7WNa8bYcQVESSd6Opvuovp3MUiTU6uwMAoLPKilxjDaI7eUnrxCfzp3VGQshOaA6GeH5x+cyPwSVmatHW2bkcJNod1fihAC8E5txFKs/snQsl8qaxE4pVXEhbGF6EPke9Q1gvD4Yy4Sf8ufs3hb6yMpysAK163dun/61xvdJwhE5Wgwf7rrztdaQ4z/B6rzEgvn1hHbEcqsp74EUKqvJFDTcav9HQmLNOF5nX3RuCrKnuuXLdpXBdp5xCTrmYs72POopMHV7x4GDYkuhFyEOD6SF/Ov3m/HcunR5EGRviDLybXziMKYxA4vryK3W+kGd1mQQqH7wuaetIiKIRFoQM7fHXgdpspiHos1cSkcToeVDPq0krIHDeBp/dg1pWU3IrbhMuZv2Btl8oBGOefZ2v10p7qqL7OqI2MUYyyQfgdxtCvlYAu+h5FGVXxoHTaNiUJFNvnX1g6KvzIlkcHvJpv6uO4aLklDVv1jZ1NBQVoTE8Io+X9GHtQtriz2181ibLOvfDXy903R1E67Eo8SX8+RXOMq6yLKqPFgPK1KMHOa8lIL86Y1KmbFWCEnyg4YhY0vHR0OOUhlT/ITzHthxST9AhMsGcPnz5I6Cgq25cGrgs5B3jxn4cn/8PgLKkuUcG3nLsotwv8TseEAkem+DOyQxR1LYdVfPEDYaS7rgo33yQhnc3iQGLseEfanjwus5btIXFnzssRo7T/Rb1nALi6+xAzY4KQN+hX5zv6XMzaUbpBG3QuT/oQWt/KSzLl2DEfx69acCi86dWeVGW26JtQ8NX/REb9KX
 0FVkvNz+
 Jlrb7w/+Vd8xIbnchFM1qg11XkwNh9VLyfVtfxqvXEUx9eFbVdvnpO/gwPOs0HL68ydaXBBAlbxGB0DiXwO8988o6WW/KznkQP2Ky0Lx4RKZQLCVJe2Khp0cisPgw5kzf1kSQpMUvw/FDBZRQLrI4E8kPQMFbjtItWqIJqrq/dpfkbNIhWFM5iShUtktbZRvO4m7CVXi/QQ4a3JMKWYaDce6xsdrznK8O6lqUXYqPbP1fIIiwuookAobWKVPwd9j7jGjAdGq3ek08uB+RpNFzAD6GwCX3FMTSjVClDgpXgw74Th49rpVVbXkKuBc90QX3T/cJyFpTazOUW6iQhVmJjz6mvu7a9XKrWLtF/EWf2yWQwLp+PRESbO/H68Tj1AsnmrHe+YPOQqcTgL2i8tiAzwqp1Xp1gfMJ1+qxzLYAAGOZ7f9RC6SSI2sNZoSXxKJszDp3q+GmFSBWST1GJCD+30yHdx98STEFeK1LDSnuPCE4Ax54ydvg/pa02rUG4nXbdoRRInerSav57rqwLbGqPTysqknJZjbECSKDsROHSPOPV4n+j6j+T5V3/wgh3Wauw8YS0HySxGkJ77v6exATi7IP1NxLA5toFUbvsvgB3FBoAo8KwgoSs+nfH466RGyHBe5McnZZ/iOA3XQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update the list of platform/ files where ioctls are defined and update
the ranges of function numbers that are used.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
[Since having multiple maintainers trying to merge these would
cause some conflicts, it would be more manageable for Jon to
take all of these through the docs-next tree.]

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Cc: linux-rpi-kernel@lists.infradead.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: Benson Leung <bleung@chromium.org>

 Documentation/userspace-api/ioctl/ioctl-number.rst |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20261113.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261113/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -436,6 +436,7 @@ Code  Seq#    Include File
 0xBA  00-0F  uapi/linux/liveupdate.h                                   Pasha Tatashin
                                                                        <mailto:pasha.tatashin@soleen.com>
 0xC0  00-0F  linux/usb/iowarrior.h
+0xC4  00-1F  platform/raspberrypi/vchiq-interface/vchiq_ioctl.h
 0xCA  00-0F  uapi/misc/cxl.h                                           Dead since 6.15
 0xCA  10-2F  uapi/misc/ocxl.h
 0xCA  80-BF  uapi/scsi/cxlflash_ioctl.h                                Dead since 6.15
@@ -448,7 +449,7 @@ Code  Seq#    Include File
 0xDD  00-3F                                                            ZFCP device driver see drivers/s390/scsi/
                                                                        <mailto:aherrman@de.ibm.com>
 0xE5  00-3F  linux/fuse.h
-0xEC  00-01  linux/platform_data/cros_ec_chardev.h                     ChromeOS EC driver
+0xEC  00-02  linux/platform_data/cros_ec_chardev.h                     ChromeOS EC driver
 0xEE  00-09  uapi/linux/pfrut.h                                        Platform Firmware Runtime Update and Telemetry
 0xEF  00-0F  uapi/linux/ntfs.h                                         NTFS
 0xF3  00-3F  drivers/usb/misc/sisusbvga/sisusb.h                       sisfb

