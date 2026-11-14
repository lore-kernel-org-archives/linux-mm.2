Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A505606A898
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=0gISktcF
Received: by kanga.kvack.org (Postfix)
	id EA77C6B05C2; Sat, 14 Nov 2026 15:27:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D64826B05BF; Sat, 14 Nov 2026 15:27:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B17F96B05BD; Sat, 14 Nov 2026 15:27:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 76BAE6B05C1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:27:18 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 08ABCA030A
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:27:18 +0000 (UTC)
X-FDA: 85434859356.03.0E5056C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2630240004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:27:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=0gISktcF;
	spf=pass (imf12.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794688036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+R+vnOxGbR8669a/yApMPxumePGvUCvn6pAgbhYVxac=;
	b=ONDU8M+uryv+wX99AU6YFT58JiS1761h3O3OXsdxPu/ccAf7RiVMFwNugmkedF0kGT89sH
	jQYCuVgDCU6ZX5vGBuSTdNKFANc4Ckbb6bwtR1WIsErMi6aPmztePFNWnD1SVaJCYrW3R0
	8uXVw1aSLo7weFf1ANxb9qvSOAbe+LE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794688036;
	b=34ImFnc0DbfmHczAAy7pdq3CkcYVZH4Ir7OzmZUvT8EaYUpeUOT2PjkPeNKZgh2F8ryf3u
	8fVPtwhgZtv40ixER6ueXfmp4RJrv0B/6RpH3uhY/h3blgWx7TIuWq33bZwQn7TIe5JTtD
	ZBUHq8N73tmL4Woj70zWpn2tOd6WJkw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=0gISktcF;
	spf=pass (imf12.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+R+vnOxGbR8669a/yApMPxumePGvUCvn6pAgbhYVxac=; b=0gISktcFQZ2GDvifsGTgS59sfG
	kunWLZ6j4WJmZNWp5LEnszL22uc8vL2dWFu1RjmHgMxpq3+s81eoyyLyLRgh1JX2FCM+Ucnn9lnRu
	xq+ifod2xjGTYMtSqx/mjXvo6gYeG0OBVZ6us5wFR8NWjXbd6svl7TtSia805oWzbC0wdA5XmtRPu
	lz8VBaijPu8G+/iovTheAMz1DVmhcqpFoxT7ZD+ifolkPaCbDs4NZpe1KPhz7EbgIiGPKi0p7T/4P
	1yjmK74+koqPtH49egLTHRfkzHTFtjIwh9kMt2ZZP22JlvUwoK5invu82fEC7b4FzEmVSQtSLFnGI
	XhkCvv7Q==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xSKL6-0000000Giga-3ShA;
	Sat, 14 Nov 2026 20:27:08 +0000
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
Subject: [PATCH 06/12] docs: ioctl-number: update SCSI entries
Date: Sat, 14 Nov 2026 12:26:44 -0800
Message-ID: <20261114202653.3113381-7-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261114202653.3113381-1-rdunlap@infradead.org>
References: <20261114202653.3113381-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2630240004
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 5s56w1u66bimg8miniuwcjpqufb8cnhf
X-Rspam-User: 
X-HE-Tag: 1794688035-315415
X-HE-Meta: U2FsdGVkX1+tEZo9PA6u39c8EHge7DmS4wEEMcmz5wYKru2lJSgvXDODJxUutc2fSR9IhydULAkHJ9DvyIXzUfWatQCFv7KbF/gqduiNn2/L7u2vFQuP0Sq9XLh0hm4qkt6JubLm2klmLNqB7V3isfAsWTcWzisKenSFJH0l8YZcA353iAEkkdGHn75aaT3ZxBvYu9Ejdy/fMiWygn6CNawtvs++Zjdxpf5xqJHJcsfzNjr1Ub7CBr342asw6VchvbRAlgdmd9D2v76H1QlIEb+ifKWonDIJ+JoxxHlS1h+wkeBHmgrYjhw7WiBl7Msv6h/fP2D7tNc3sbXpNHSS5MfGKQVkN1UApWYtTvRwzN86tzs+u4PwtiO8nQrDy3mAjxw6ZJgbzCEdcF+zxa07mP6vrELwpRKGMdGMq+MM6jVqBTJDq+4fugqhbRiGCx8lr+HQKaQseD14AXiTmZtn0XkaHOUhRUZK60xke3Pi7iD9iFVLlS9HOLvDmP8xhT76yKt7FeCqpjqYZYjy+SeD2+Wr3ECSAO3fYz9ZDlNFKaN9FqtYpIMro0MSIyDYir8Z9bXbm+cqNVg2xnYPSWHuYFyu3lpPifvU1oeNdiglqaLhsb0C/OdwaV7Gr3nkd318Gdco+sM6JCBvVg7WMgG28LVL3x38c1Z24WDCYevyPyE0aTn3z8sIS7qX0MNC/TxDRRIi5FtKyX/ClgCz/iWIC9fPCnzi5ku0BuDfyZf9ioG/09kc0HTHaYEZGgpQo55TuwUXWMPbUh1V11cxSzxX3D8I8UlG2fNa3VoUb/oZenYWZJyE4et2PnggybdwbHSVm+E3/yCVDf64GDSkaSewJMG1xKNAGbfEhQHM5x0DdhHwYTa44Lqr3V5fm0wRl/0Q9O/6flq4VxlSXbS0L9fjrjakfCJxOxSF2aCNcxnVemJHHM2KjsjIQtzK1HNkNKAeXULDQstUB5AMZYLF3K6
 54SNE/RO
 S5sPde2SnCQ7lxIF7EwwxLxctoD5ZxEa2U/AoVoYu6U52mIctxgpJmnA9JEZG8yRhQeqLem2IC4rajh1uWLkdMuU4ivU6ERmuY5hyM4By5/8RYDoOIN2ZsU05trU2Hc4uonmohhdeYCLRY2QpL9yngzGu3FpEJRXoKZ8rnAu9l4Q2FZ2BMB93+dMsrU9hjJcuA1vOPPAuFclU8iAMH/N7kzSTWNgGP6qsVzKdPoNN1gRetaNjxvZFf4J+yhvIfHQzh62i3anobiZlWkjHg6sqfiUTekRQuSB8T0dHIiBpdxusT1xT3o/dWPT5P5Xm3rqmuLJCeI1+ohTTWIWJrT34gnqq/4xHj4y7OvyvFaZ2Qp2HFHL/i6XJ6Le57hpLWRVNmt4/1l7+jjquveMILd32L9SGRAVyLAPv/ajUb2n/2gmMZlMpttqIzBLdbCdOQEVnySA+qfnDjXsjfP1o1pAOjURUs640h8sIe83b8Bef9l/K6izT44SD0EXfJM8ly0fvqrDJlpcvEQSzQdqcmyjRIy4eCBKMy29367JSzijhLsoizIFdx6ekU1ymuAVsjuKPzzpyg+ALQD+M7OIr0VSmqdHUTu3c7QLWrMR+ntRyxZl5XkkXAu+g32JF5gwbv27sUhRMKOJDF5opI0YTkXt5TyWQK1LCo0+is2qDGKC5xLLqKJE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update the list of files where SCSI ioctls are defined and update the
ranges of function numbers that are used.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
[Since having multiple maintainers trying to merge these would
cause some conflicts, it would be more manageable for Jon to
take all of these through the docs-next tree.]

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: MPT-FusionLinux.pdl@broadcom.com
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org

 Documentation/userspace-api/ioctl/ioctl-number.rst |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20261111.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261111/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -189,7 +189,7 @@ Code  Seq#    Include File
 'I'   40-4F  linux/mISDNif.h                                           conflict!
 'K'   all    linux/kd.h
 'L'   00-1F  linux/loop.h                                              conflict!
-'L'   10-1F  drivers/scsi/mpt3sas/mpt3sas_ctl.h                        conflict!
+'L'   10-21  drivers/scsi/mpt3sas/mpt3sas_ctl.h                        conflict!
 'L'   E0-FF  linux/ppdd.h                                              encrypted disk device driver
                                                                        <http://linux01.gwdg.de/~alatham/ppdd.html>
 'L'   35-38  arch/m68k/include/asm/fbio.h
@@ -260,6 +260,7 @@ Code  Seq#    Include File
 'c'   00-7F  linux/comstats.h                                          conflict!
 'c'   00-7F  linux/coda.h                                              conflict!
 'c'   00-1F  linux/chio.h                                              conflict!
+'c'   08     drivers/scsi/ch.c                                         conflict!
 'c'   80-9F  arch/s390/include/asm/chsc.h                              conflict!
 'c'   A0-AF  arch/x86/include/asm/msr.h conflict!
 'd'   00-FF  linux/char/drm/drm.h                                      conflict!

