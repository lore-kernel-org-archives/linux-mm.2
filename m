Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 153D7607359C
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=H33MnnDW
Received: by kanga.kvack.org (Postfix)
	id 3044A6B05C4; Sat, 14 Nov 2026 15:27:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23F916B05C9; Sat, 14 Nov 2026 15:27:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 067896B05C4; Sat, 14 Nov 2026 15:27:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BBA876B05C4
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:27:19 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4B0F51603B7
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:27:19 +0000 (UTC)
X-FDA: 85434859398.06.7A5794A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf23.hostedemail.com (Postfix) with ESMTP id B5DC5140003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:27:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=H33MnnDW;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf23.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794688037;
	b=QFd2zuKC9yTcGKne9fQAET4ck0/IAfmCkdbw1HDRMTPWcdKqbxjHPwIg9ycmEFVxwy53Uy
	FvZfEVtrr/xgGExAX1C5I+pnRz0WQUf0cUN1IQPUw2vJkKrym2Ug5lFGs8nMWX4Gy5UqOi
	hGJ5L3upGTZMcVjb1tTePKh1sYO0PtQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794688037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dXRUulmDFymHlze42FTqtgwTlIfAdsqSdsLkUtEuSrA=;
	b=50Q7oTxdTUZjJptDiZrJjtooKnngkkEZ1It8Of2Ju960/Snzf+gDvJFq7+t22SAKCveg6P
	zwvlUaGdsDdTSTRDpFm/AiMLQGSdV8NcKAAkHLDJVFd640OvIpJgjTkPYzmaMNxDfR+bZI
	TqV2H3NHzcmu9Z/Tj/sd0hr0kGSV5cc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=H33MnnDW;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf23.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dXRUulmDFymHlze42FTqtgwTlIfAdsqSdsLkUtEuSrA=; b=H33MnnDWGDvznoU5l0eojH93CW
	wywuikhQo4LJqBby3lwxFuroUHTA3EqRBkZ1uTCGFP37NmiwDGP8y65uLS86Fb+Ol5/iw0BzHvDxX
	YtMUHfnkPnz6GU6IW459yunXVHD2cVgP05nr5+u6+Rr34JhdKSAPuV+f2/mu7/KeX692uvBHPXfWq
	LRSi94vpJq3i8eUqsBs4R0+NP4bykNV0KDf1skevc8j8v5cxunUFUQX4b2ORErwtzJtjjd0N/AwjM
	6PyltPOeI6WdSWeQR9OgfJv+ZUv4fwHTcQQ/CesB+TiUbSlBgCKr/oMQbOjISVf2zkKIjGFHL94sT
	PdVWFi3w==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xSKL9-0000000Giga-0JSK;
	Sat, 14 Nov 2026 20:27:11 +0000
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
Subject: [PATCH 07/12] docs: ioctl-number: update MTD entries
Date: Sat, 14 Nov 2026 12:26:45 -0800
Message-ID: <20261114202653.3113381-8-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261114202653.3113381-1-rdunlap@infradead.org>
References: <20261114202653.3113381-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B5DC5140003
X-Rspamd-Server: rspam12
X-Stat-Signature: m6pwf3asgq57wnr6zgupsqgtg5ashoc7
X-Rspam-User:
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794688037-510274
X-HE-Meta: U2FsdGVkX18SMU0pB3JXZb8/Ot8wtu1Cbtj++ImohwYWR0QIidj/9O4Cc03z1qJ1QM4U1REVNDsSGYH7oP1saTybyOJJPj+ZvWxXS3iYFYJB3UKyMkrphHIFqrNE9uN/zeuhecl7VXInXmLJqC7+lxPqswV+Z73PB2LUGiDpdN+xwWnlzzq6Nzuy7vjdY0yUTNqgirBWtRYpDEN07GAJNynl8QASMQnD/tfwo37xNSjg7Ccs9RU3vVKqPessvoDzYBaHF989c3My53ByuhqyX4xTxHuqoWpeBvLhulLcyXpdROBnxYHGzytZC5ayO7tCj/SOeM6nRC23bP40oMyygGTvVQ/wW1XKLoBhaR7N1cYFkiPnLFC7RmocNkZtBndnvcmqsSBCYZUEQYZCOVs1Eoo9nKARAI6U+SbYlCdildOVNmxOT4qHAgxUtIrhllaXNaC8kb5DQFZU/EhQLuyWXSm4ttPAtnzwE1YlxyKERzVn0Cf1R9eBzxXW+Lh9FuKpB6urmWKd50HFmn/2TSh/lEqphIUYT4F+uofF02vqKacdhTHaClxGg9UGbfRfzx+1fhkca33ScQmuRZVxQxu/Xyr56DO8XyJE74JXsGtG767bWopZlOjhuuWHEtboI17dmZgWBteH6ur5300lKnLoIr/nysVQEM4cpHFf882gorsxBPOphdtBpdmkbrKnAveaky/8oINHxx/BHjBikhMWBh7Ft8fTP/DKR2ysYfOnpANgTsF9ncPTDKxkzF36oPuglABAKnHE9uTcmCKtpPdBqH9TEWdAynYOYD2FgrBBXto9PoZuPDAUzn7FF+YvKlT5rDjZWRpq+ikUIbFnaU6pHu+4nM86dIx3beVxkEE6EL1aGdkSxYYxHGAS3EaWM0Rop8AS4JUAOALyqRJrzVIMgDOf/W97nkF2xQ9UwlMS9twSBcrWnlXiC0stIS613EynJ0ywDVqR5k3OJ7HJK17
 t0J5LpXO
 3MZK+ogbSepXi8tceB/W293woUItaf8zt1uCMdt+ZudSU6Gb04feDocz8d9RlNzx3weZHGYIocMGd23BAPDN8UT/Xy513Ek1dj2eA83WzcOj8h7ygLfWJrW4uM7gLxxQmaMsOXj95dH9eoelddRuMRi+xz/w6iLn4JxG1eYjcFHyDmO6XM4zrYpF9scT2svqAQYoIDlNdMMbpCVx4NRB2WV/c7nFbM4JiRwZDeF3yoxS1zgAaPzf7p/+xv5A1WqU50Mi8ZzJiv7Z1CCa02cdbP800cprVyBOSehjrnr0Q8Q7Lzen2n6Gv0FXmoENcNe+e2h8sy8Tj5eJl9T0HIt+QzrUGTdDt9Hk+cqCZWXpkPTdKmqbmloMNCNRRP5ONU0nSM/nqckze2Q9R4JWRlV+OkwIL5+Y6mXFI/2LkUIqPIuT2vP25WVnBncCMJlxZpndS30wL7Yku/CmvsORu9WAYffbfTqPH6XB+gfuA1AZJkppXO75d8zEr2nJ45XnQtCS0xDpKDUYN9zJPhydmhB0umh+oEFePpQj2pXqekekQCK4cqmNBNrpxnX4OQ59Mz7Lcg1k6bOtR3N1KcvLbLHjl1ecQO/wZrQxW+3KeuVw7/y0GKhPPtm9p1m7x0AoMI0ufIQzPrLRFX/RKKd9U20ng1GuQM/zTyJZj7LAzlFWneBRqsxTOvNUfsflQS8/fRPBd6HVNyhQiKLrGFnu4TUF+5rN3ZjLf5udkKk3TgCYZNRsXP7rKJa6QT71ciVE/lUjT5/JiY5hzcM/TZjM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update the list of files where MTD ioctls are defined and update
the ranges of function numbers that are used.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
[Since having multiple maintainers trying to merge these would
cause some conflicts, it would be more manageable for Jon to
take all of these through the docs-next tree.]

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: linux-mtd@lists.infradead.org

 Documentation/userspace-api/ioctl/ioctl-number.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20261111.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261111/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -195,8 +195,8 @@ Code  Seq#    Include File
 'L'   35-38  arch/m68k/include/asm/fbio.h
 'L'   35-38  arch/sparc/include/asm/fbio.h
 'M'   all    linux/soundcard.h                                         conflict!
-'M'   01-16  mtd/mtd-abi.h                                             conflict!
-      and    drivers/mtd/mtdchar.c
+'M'   01-1A  mtd/mtd-abi.h                                             conflict!
+'M'   03-04  drivers/mtd/mtdchar.c
 'M'   01-03  drivers/scsi/megaraid/megaraid_sas.h
 'M'   00-03  drivers/video/fbdev/mb862xx/mb862xxfb.h
 'M'   00-0F  drivers/video/fsl-diu-fb.h                                conflict!
@@ -306,7 +306,7 @@ Code  Seq#    Include File
 'n'   E0-FF  linux/matroxfb.h                                          matroxfb
 'n'   F8-FA  video/sisfb.h                                             sisfb
 'o'   00-1F  fs/ocfs2/ocfs2_fs.h                                       OCFS2
-'o'   00-03  mtd/ubi-user.h                                            conflict! (OCFS2 and UBI overlaps)
+'o'   00-06  mtd/ubi-user.h                                            conflict! (OCFS2 and UBI overlap)
 'o'   40-41  mtd/ubi-user.h                                            UBI
 'o'   01-A1  `linux/dvb/*.h`                                           DVB
 'p'   00-0F  linux/phantom.h                                           conflict! (OpenHaptics needs this)

