Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34865606FAE0
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=wKQjtRiF
Received: by kanga.kvack.org (Postfix)
	id 1557E6B05C7; Sat, 14 Nov 2026 15:27:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DEAE6B05C5; Sat, 14 Nov 2026 15:27:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E25F16B05C9; Sat, 14 Nov 2026 15:27:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 968186B05C5
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:27:19 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 16C90120407
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:27:19 +0000 (UTC)
X-FDA: 85434859398.23.4CEA565
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id 39AA840007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:27:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=wKQjtRiF;
	spf=pass (imf07.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794688036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=agUQr/AxBpqR/yoTMSgCDqpX2NxV6QO4XNqgDEsecWM=;
	b=HQ7866PQAzkjjfV8f1JvCBeyM3EXc2D7ofY0NHQd36nVAtkS51+J7mR9BuYYXjhK+6fF/+
	4dHcYSClSHchuwvyXoqv8AdqHMfQ4wHV6qsozxKDTZwCW3Hre1qo8gUT+gNw3FhBS4bcKj
	kU8l9pvG+Gn8l/Q6vRbIcRJaO8lHw3Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=wKQjtRiF;
	spf=pass (imf07.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794688036;
	b=48mSjYO47qngr4ePQHa1m8Ek4vhuEclwI5KY6kYXYB138t8zjPiRnxu6kVUIHDg0umX6t2
	CmWhiah+nkEPzb6zD3Xe6Impe9jRuuVcILPghd6ExUZOQNwcXmMZXfrezCOJCJvtrjw0q0
	YYfwOceWxeRLRf9ROS35PvGZPyLbbA8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=agUQr/AxBpqR/yoTMSgCDqpX2NxV6QO4XNqgDEsecWM=; b=wKQjtRiFnFlUm+odGRkSre2RML
	kUbFmePzfrRwfhs83dMhMRZrv/ciIAAPcjOtKw/5hdld85CdWM4AxdrdTgsD880DWDNdXmFuFIErS
	0IMkezq8UeG9DkfgVsC5G5kkBgJvDEZz7G+EHy0RW0Lzv7Qd/nCZaf6v+cXrkPJkx3GLNPvuSwDBa
	7XAdBzY1kcvZjJJtEBYz7HmZpeD7KWVbRyAC3J6vng0QRm/e0NV7tKqBDqVCSfsHg211Qio6A8wik
	gKq8tpH8joqM/xI+N5OezTWpFykZVnxctwGt4ZFbDae9ou4ACwTgcy//9967ywPfn/XG6456ddH+F
	mi0BZo+A==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xSKKv-0000000Giga-2gx2;
	Sat, 14 Nov 2026 20:26:57 +0000
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
Subject: [PATCH 01/12] docs: ioctl-number: update MM entries
Date: Sat, 14 Nov 2026 12:26:39 -0800
Message-ID: <20261114202653.3113381-2-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261114202653.3113381-1-rdunlap@infradead.org>
References: <20261114202653.3113381-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ippmi1ib1jdmy8wujd9h5o9uzema5wm3
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 39AA840007
X-HE-Tag: 1794688036-546655
X-HE-Meta: U2FsdGVkX18yIaYXvhLmkrBG1GSSrZSM3PYaJZxWr2o2uMsAZ7ZtdmEl27tyYejK+RWfbEV+BpbKNB6juhBK9mL6XzomFbglSj6l/abSoiOOwIx9VM4pYj3zWV75cBnWgSxmXYCoXEdQsSYckCrzRvA1IwoY3W553XdBxyMPRsT2/sErMBh9+Zvp54Z5+3QMf49DuMIGKHr+fl/JWxEBDbYcObhAfApY6w9AAAk12nc/LDWUd7vcOMr5C5IDC9zhOv9Ak0/IYaDvlwEMHnFH2kw38xD/0hBAmX0FuBOUewGBVlbJGcu2u1uBmM5vESUD2aoY+n4xcQ/VQ4CiMG04mcf5itDfSEzc715IG4GDqa7YvG1DPVH83p2RBEgWJv6sFayo+ucDj9SjsExQ7i0Bdb175HzbTs/u1PhEZ457y2dm8qvR3bvtP/9eVlUQs0jhwc21Y2YfbfD7cIf1cu9bMhXNGax5b0IIo9guAr16k5Rse2Ub7GFy+/QlYC+1I1K6ZK4e0Lk69pLDgrokNyyMqbzFhCVwDcasunayvLjWyK/STppvN2FTDWVmPBJyaocFJ9h8J2aahWtRIKzBQhOhXGS6FtDtxzwhUG0y3G6Yc5hFlnoxoudFayMxfaB9pLvZRlYvuDbBanOCWWDA5HM4cP7II35S+xenVEv800ybkEzWNR44VG/lIlC37PEA33qbw6Alq96ILAD+x97I010JxHm2PS2DScDpHRdkgo67MBE2U/t34Oimt8t2gnbMEBZP0hBbY+S+4CdPyiagj4ItSiofU9spd0mjeeItLxShRlqqP5tFH9k8e9Z+b2P9TGBH9USwpQqxaUK1ZhC+jhCXHumVuFW5QYougp2ar/H6U9gx4/s8kXmg1bEfv3wpD84l2uh5ldLXHsMQisUMe4uKefZtdcGPuqq5mtrEjW+g8NBGzBf9IU818oUxAHj+Gy8meFbIXRl5V9DZyLIssOv
 c/zJ/HCf
 syAl61vbmo99CZ/DHXK38hHaPyldem961IzrNGt6MFYzHFUh3q8iHKg6ZFeHgShu+OWWbw0mtoFWPaea9Flfd4d7PSJAX0crQmp4lxsM5E33goYk7194h+Ojra7QcmbEJdoPr7oDIf/YOxB2mhMbqRwHNdIDQKG+4UNM1AGa1tj0b5CXcRmOux1EnbbsbZgDgn4fFZ8sqjHIMCRp2vUjSnDOmjAjFQmzt6iTiSvqTbMRqpCid7JJPD/xrTrTs87zSccydffqTj7TxpkszPUYxYGXkLmnCJVuViVHglRrj1qSw6BMuthLstWT9BqJVblC0/0QeaCSlC56w3RIWXCeEYwR6IRMm2g2QXWc3DL5Q6Br3hGWTGpkZg7w5xuQ0f4lpGY/Z8VyNUYnljOEZKE/aPG8vyGCMogztQeX3ZnasLiFGSR4baCUAQ85Vy++4brI0TSIKTZemBbND/w4AZG0cuOQfhSfSMOZxoJYuuE01YS29pCD5p2/d5A5pcNVS5Hnlrx8H6XvolL7OR8NeXNVVVfbYOT61gll2sXJbyvLAXrvr4+4jY4eq+s0MWrh4xW5EYhGd7eZIef9j2PquX+RNXyZ25Oup+rwnFblvgZG0TLthZRcKe0ODmxAmtcWA0IWuC+4Ht8w0Z0ZCR66DLVy5xGxZlIJzshkrp5HRzdgp1lkbWzBKc3xlgkL7/QNOR7q7NOUVshgHlfS+l/AvkH4x59Gxtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add ioctl number entries for test_hmm_uapi and gup_test.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
[Since having multiple maintainers trying to merge these would
cause some conflicts, it would be more manageable for Jon to
take all of these through the docs-next tree.]

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: linux-mm@kvack.org

 Documentation/userspace-api/ioctl/ioctl-number.rst |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-next-20261111.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261111/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -147,6 +147,8 @@ Code  Seq#    Include File
 'G'   00-0F  xen/gntalloc.h, xen/gntdev.h                              conflict!
 'H'   00-7F  linux/hiddev.h                                            conflict!
 'H'   00-0F  linux/hidraw.h                                            conflict!
+'H'   00-0F  lib/test_hmm_uapi.h                                       conflict!
+                                                                       <mailto:linux-mm@kvack.org>
 'H'   01     linux/mei.h                                               conflict!
 'H'   02     linux/mei.h                                               conflict!
 'H'   03     linux/mei.h                                               conflict!
@@ -252,6 +254,8 @@ Code  Seq#    Include File
 'f'   81-8F  linux/fsverity.h
 'g'   00-0F  linux/usb/gadgetfs.h
 'g'   20-2F  linux/usb/g_printer.h
+'g'   01-0F  mm/gup_test.h                                             conflict!
+                                                                       <mailto:linux-mm@kvack.org>
 'h'   00-7F                                                            conflict! Charon filesystem
                                                                        <mailto:zapman@interlan.net>
 'h'   00-1F  linux/hpet.h                                              conflict!

