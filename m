Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62E29606A323
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 06:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=t0N3QvZj
Received: by kanga.kvack.org (Postfix)
	id EB30F6B0910; Wed, 25 Nov 2026 01:14:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8B986B0911; Wed, 25 Nov 2026 01:14:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C901E6B0912; Wed, 25 Nov 2026 01:14:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E6996B0910
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 01:14:11 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 09A3D120D5A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:14:11 +0000 (UTC)
X-FDA: 85472626302.21.EC0EABC
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf31.hostedemail.com (Postfix) with ESMTP id 85E5220003
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:14:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=t0N3QvZj;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf31.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795587248;
	b=i2W53gB9ZLbR95CRvW7lnrc1kpXe/kVrNy4jeSR1sfjC0CK2DfGUv9EbtkOUuz1KVhvVeH
	SbS5koY2sZEhxUtQp9ppFMNXlbx6pNZEp/J2/5jvT7VxKBAVqvQuRIdGHB1lVsosK1HzWL
	tPxoiI2Ize6iloovmag1JfG/DD/QUeI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795587248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HbuCV21suICAifmMr+QiJxglk35NFZTKGTKkvkyuZyo=;
	b=xsKDKgY7Dr7EXbtjO7Gj8Qm9HCDPQOCUgTlZdmT1c+2VjP/MpxppE2vxaA5k/KBjrAyaxk
	jq6TiT4emAIAdyrUvnAdZmziHTNi+VOP8X15DPGvZMwjwssb7QklvXDiqjGe79xTtMSERD
	qAk4KUAA8wtHoVj7X6MrrqtBHKQABmg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=t0N3QvZj;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf31.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HbuCV21suICAifmMr+QiJxglk35NFZTKGTKkvkyuZyo=; b=t0N3QvZj67sXAElPcQDRfFEeFC
	Ry87q/HKHnd9AflpeJ6sdyDtMOspDD6dk2kaKcGI09Doxg/kOyBkkDwuQF/GwL+aUcraRQSMAI4gq
	vaqJWlOuO16ACJ+hVxBTQvxMm6w7klhtRvz5Yuyb/9as7/epd7p8KXoZozPJ9vin16Qwnte6KAQDZ
	B28OGP5xhj8FWN6iqYyBJVLmdncGI4T/+eayqDgNpmb6Hw4RS8zBiBjrlpxInv3X7OrcCLrJYK19C
	NoN6ftlIGZXNkThIXdUqXsPtWw01Bnj1QiVeCmRzeFE66JRwhcWdPaXrSAfBriLmxjvU5NlxFqa4l
	D51u5MqA==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xW6Gd-00000008Wvh-05Wr;
	Wed, 25 Nov 2026 06:14:07 +0000
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
Subject: [PATCH v3 10/12] docs: ioctl-number: update FS entries
Date: Tue, 24 Nov 2026 22:13:37 -0800
Message-ID: <20261125061340.3402300-11-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125061340.3402300-1-rdunlap@infradead.org>
References: <20261125061340.3402300-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 85E5220003
X-Stat-Signature: 6tqfwiasyp6fhw11wtf5g1oop9k9zrnp
X-Rspam-User:
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795587248-275841
X-HE-Meta: U2FsdGVkX1+MeFfK8gWx9p2D7vHDtMgh534pTqh950jvMRvMTfc3OrJwVSLqrvI6k/5rgBbGVAcDGfqfw7hpj2TaD0VNQcjyjMFnS8QKdNQddAKKfVYtrIuLcyOlAuy+Dq8CJChkgHMuexf/0o4RqladnNLHhAu7YOVafwgBvGLRLJn95jm4FBkQ3eDm4hfigQECzXEYa0rZBqDnQpc6yZod9sf7tkTcl/f8YHvWLBar9lzAZBdVykQcUS1BX4qRbpoKzxkte2BH9SW0iYHWED5uP0Qrs+mZCEffYtA2k7uOWKP8XPqX+fpceLi5hHagn47Vug/taThCTciwQYr7VA6xjMhLh7UJnGtLOZ7KrYMS2/VyAsnA0Eut01aRDDR408Vax5iBoBT9Lev67quGjg0i5ygQE1f7mGr0YD0CtQXzyPYqQEvVkbW8tAHHICfx6551yqcs9b/bI57Ct8uJ6vmc3XcMl5JzHcG/440dr8Z4JXdcpC+YOyn/7ABaBRQbkkcQVAZ30WaUohZ45rArMFjrLIFhwKneygd/5ByX/7tagcs5uhxTd2poYp7/xbEf4YU8aMU0kpaKCNzLDga+ah1f2Oq1dJ/YKWtzOUh2+mN/ItoWXKjhcWc4LO71sMjIPvT8saWPYkok4q1tS8GYYJqm/mGHnU12/k8o8AA+FbjrAKZd/Umz4DoYYlfktQQVkLWuXLBd494HYujOUncClY3Gg9bA8fO5/DBbnKUij7JzmBR1qnTEBNyy5WsVPOpn2xdT3YYPHByq3Pkon/6EuHNm5Asu/ft5ZwDzZ0xPvLXQn0DkulTsAzgSDbP4vLMAi6vWhJvlfOox0JDQlY0OOuGAO7WF9gy/LsyEwvK0q1zNH890cj3Jn1/i0diKvhW/IHKs5XdTSUaQCUJ59J//Cr2jZ57eqTYFXBs6Tz16nufPgEcHQLs8z9PC2rC7T3czSdRpoLi3IWDdJt+IO3R
 jZJiWTkS
 i/e8XmFwj2hgYzKm3b3ILJ/99o1BLn/jZHeCefdTgFqwuL5JHW2sBBDDfK3UhCpBwlmZ0copVVe1JL/kPUcA3nuwhlN9dwd/3rpTFGDnAPrEeZkqs2++F/iNC1SDFTjgSj8d0GNTrLSfCr5/+ZVAzzx2eooNFuJ38lbL5/fEPdNd1jTJTHVpjhdAsiI4HCBJ1/ajqAf4WpH47AsN7uY862+IzOuJ0pOXh999yO+rYMUeEaITb0CDvKWapvy3GiMNa9WPHaiQqEB2UmB2Hx7eT+8zxCT5UWMIIBRJMtAp86MA5OKQG7oiXiiCAl99j/piXs7verkQ8DOmB95A/VvXFm3mDaRXhnec6Lpt0+a6A72s7zLSpTraMVL50Ro5ZW1jL95IH8zQzpVPvKJEZQ/NxaWCzYbMmVx61BrWpZ9J+n2tzNdU11r+h8lO/zGI1KCGVR5SjuLLuNrb/d8k/C8ZipXSFjyR1Vp+QZSjbguPwhxF9GwEyD0erQ2HKAp1N60XD99Jwum2Sg+C/B1wOfiFIwJ8V/peKva2jA8zu97we+CnqJDnS25rRMUCaWnk4a6XtbD/EPzw2ruupWc9jg9HthYtEEgFskJCwkrQHIu+2N5inKEzlkbrT95UpTZdOw439JOTo87ykF+40oj7Joj0mp6beyfjcnS98rY2WnsSHGX20Mtah6rWMje8sAV4K1qd+t3V8plnzOYcjjhzjUYJOSe1zIwSNzD2jzuw7bYLU4Ztcun+CMx+39OsUInQtXs84Yk2AWBFfcgU+bN7ZrW6d6bGiCD3FknBkKGxvPa+ZjwKuNXsWs7i8XVkdel2KsyKB3JHMjSfL3ctNeM7AilC7yjbpDaT9/FXarSGkERqvqtOHar5JLO8mzi9DuXKlCf7uDqowfqnuIG2nXBDqhuknPRA4lCTHRyJ/g4uUFeyUvw3s41dnxbEIPTvU7RDY9n7GLRaSNWkjj3WFkvzJQ93NS13N0Q9D
 /vfeJLIN
 hWImUF5QvD11cjlfz3FCxmp+WuYbApT6oiy0eQm8Dg3LQcU4bnQE2nIDoqGGlEDDtrW+h4agfAOTcmzRTG0szuqSzzG0dNarsgefr9GX+j2CFa+SvXzZKZrbnzDmwWZJn6uqeTk1bYRUE3NefrUs7MhgB582mNL0HdS+FdGIlBCxAfnYhsQYh1IeCJCz4QlaJi3AhU49GhoSEv6min1F2Z3ZIQyYy61TQ/4kwRcoExKzE/yuwYELhTfZMf3Hw40SW2EYdFIeStKGSr6wxaxUEFfEIlpCIQzmku5Jz/4QK9S84BUmnD6kyJMZmBWPzQE+pm5vb7VOTgdEy87xTu6W0J2n0W0LvBXx
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
v3: rebase

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

--- linux-next-20261123.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261123/Documentation/userspace-api/ioctl/ioctl-number.rst
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

