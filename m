Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D800606A6B6
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 06:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=IeiPRYZt
Received: by kanga.kvack.org (Postfix)
	id DC7D66B090A; Wed, 25 Nov 2026 01:14:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D521F6B090C; Wed, 25 Nov 2026 01:14:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA40E6B090D; Wed, 25 Nov 2026 01:14:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8764C6B090A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 01:14:04 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7204B1A0D5E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:14:03 +0000 (UTC)
X-FDA: 85472625966.22.DBF8A04
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf12.hostedemail.com (Postfix) with ESMTP id C8E8240007
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:14:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=IeiPRYZt;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf12.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795587241;
	b=sfUTdxwlIL0p9e8f6pytCEQfzWRwhE0iPWhxzZCKxngO5/fRECOt5FVaxOkCc6Vaq6o7W9
	wkk62m/dn7Rgs7FqTrJ8/E460rU4V/1r2t+sAsLP5BEcLB9+B/bDc87FMX3h7TpHRn2nsT
	70ieuh0TdtHnSO4u5+tQFZMKTgR6Ifg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795587241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=06jVMrLk7qKByXSJceJFM6yQsWAtTpo701vzTDV88jU=;
	b=EdlzOdt6Qm1MbrnwpOCVbLvCKCzt/yj7bUX9RBvkOfCg9Pg61XySUJtPBtShtsfHHxKu6M
	tTxJGr93opczW3hGYVylYzAj2Z3nWUQAyyb6eUKjAJxDnWCTfWBXcP8PVX9The1yJsLNN+
	q4BhYfw4AA4gjZCozdfkK+JRzkfnbXk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=IeiPRYZt;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf12.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=06jVMrLk7qKByXSJceJFM6yQsWAtTpo701vzTDV88jU=; b=IeiPRYZtxYbX40yu0v323yHaXs
	AJHX1Z6Q47hdFjGEA8Ki6TdcGmk0/SZMQ09uIP+EnODqg8op8fXbobW5M6IEeJbjdiWmHVTp4qj13
	rkavqdm05SYOgh73RvXhcG6+xzMjRb9jwVbRMLWzm7Hl7+NQD1Vh4TWPvbkm6LoM2S/d5VGIoNZxz
	sBJN2zqpqERtocRg6dv607diLzKOPwoRb65k/FoH3QaczzgsFCpWbI6pedBgixQfBaX3gOrzWqqZP
	bHKOgxzseBAs3F9PPNuAe/9VMYbx1tHGrWRCAYJRGGkYdZ95isPVDSMhmOlkEpx1sfY0HYnHfjd/t
	4dv79e1A==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xW6GW-00000008Wvh-1Ipo;
	Wed, 25 Nov 2026 06:14:00 +0000
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
Subject: [PATCH v3 07/12] docs: ioctl-number: update MTD entries
Date: Tue, 24 Nov 2026 22:13:34 -0800
Message-ID: <20261125061340.3402300-8-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125061340.3402300-1-rdunlap@infradead.org>
References: <20261125061340.3402300-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: uiiwf1515gem7xmtsthipbd6ry3pcpjr
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C8E8240007
X-Rspam-User:
X-HE-Tag: 1795587241-463590
X-HE-Meta: U2FsdGVkX1/wUDzOKsYMbRznB5TdKwOjyFQvwihKp9E9mwWQGLKYGofIuH7GW2R6nmFCmXe5ykQcBkETvsL5s5yGJP7ZzNbGg0H/yKunnz5FVjfNcoN2vt8M6P6rkRhrA2+GP8aWla6OJr5cCg0SziDm+se+vF5zPmOBrysUjWOCM3h/Rl7r/hll7bAq3lfiuYw1Nd8C/yLKAmqLt2y52c8mtOCnF+c0lDhHwaiHjpIR/UH/I/SRs/Vsucd+4ourpxYi270dxZfS74yDokawl4xywm1G8kk82PXrHZeYivqhZkejcnFFqOkq/tzwO49GjX3dlv9+RwVpR4NeExRb6GsxC8vyVyMjwUk/s3uCqhD4L7cNmFlj4wOhvC21HTH6fn8hhEZWuCJOXfTAL65uuD6lHVlPPLEJxcaQ439v+KCBg8NR1KJnUfpQKZldvfwSDrGIUyMCJkcepwPJ9EWOQf+LtBsfynMzF0Bl1Mj8+GEMVxTRF8oGpATPBkF1IEoy3hf2vQkqXjjCuk7enbwPpIJHvRL9b62q+TP997gG9f3yMKoaArzSU0uTTaDQK0NKwkeOF26ZnJq8dYcwBIUnAlww87t5x3odLO6gi1t45hE9ljzU7oV4k89tIfnPT4KQsUd4pKHoAPr5LuRs+pALrU9Bg8Dxzr6g/X+R0M7XYYZnQ/+bI8fC/egN3v5LoJUTxjlk8JPLnpcf9z8LoQhs+dOeFVvU4jIsRYFW+xEqvZdy/pIFQcOTS/CTtj5jNJ0sVhCUDmBIWgriwMGOLS5YNVVNnxKbRon3Nid0i2GjkQ3gHMTFb1NsKny7FzyNfbmrQf2Iu7IH6h69mMZAL5wWrVN6Re6kgh9YWphwNG6m7tyqi6EVGS4LRHOZsHca9eJ/TtDZ8YCbOSGMEeMplI+X4Hcq12MFTHNEorI0DuWygP8z3/RuX1ZoPVvSVuA2X4dn8AmXwr/G6gK3qqt+YlP
 48QSsr9b
 cp6Am8K+kUsuORY6n4MVBsSwsghqrs49kmuw0Wg0+PoGnt4opjRADRTDUsNo0OCXQk9HoXG7IwdxFTtU3RQ/RJU8x4F3RtWNsVB6GtA1PeLziXLac0woTImxTBAYrWfle32TDY+hvvO3zFr1t8zePEnAMxQ83qntugJa5PbDoxILQ1XIriWWp6aWWcnPUmow/HK33xAcgU40SH60WNCnrm4QkeBNDbKgx4OO67KE8i3E6/wmnuzlFZhwRcWeUn1Fnws7lVsRhHzD6vrlrq+5Vxwpfn6jx3ebXWfWcjTmFxdj9rxxakA16bFIVbiHZFsK7ydSwH3teYRMYnZRi6dt/A3pA4D3zexanjxsyiuT0+bM4f2snOOK7Ca/x8StHXhwTn0D/co+S8XcRnzAZBf2T9WZWkIxzD+GYDnsYyRNeSdLyoc2acqu2YDUeZed54L1bCMyxMVCAiK2/hkYFgScMYsjkNOEu9tQvvLYLvw/FVeBvlCju6/Fjevl/Aa0liHsW6fFuwrPdEHI9euHD4rPuEFWn2n4JzmOPG+WwBgNs/oXSyUANbt1vm7Yfg4pTFZ/8McT/FNSO65YTo+TEB+Ya07RkWbH/eNoaiR+KSQ6mS1lDXLLketikUu3DaNX+9zuiI+cfswWzAk0zHPqKoPUo53eD3A8HmmkDkfZ92mYey3FwM1VmxZsmx2hqETfkXP9yzfuMd9ceyPnkE5T2lhIby+hyZhuVM3mRnCj12rXJo+NJD04m8J66G6FdNZh0gQZ+IHJp77sIedmIx2FyuPxP8f8spd8AgWziygTRL9fmZl3ORRQmnbLsuERe/Y2xF1hrE61BCL5E9FKvh5oU39vQKyrg/ShIlBl0traigmwIuACSoJI3ItsRfnopRLhPn1mxXh2BwB0O3M36V1jRUZ/Wu8VvEQ==
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
Acked-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
v2: address sashiko review comments (missing update of 'O' range
    for mtd/ubi-user.h)
v3: rebase

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

 Documentation/userspace-api/ioctl/ioctl-number.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-next-20261123.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261123/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -193,8 +193,8 @@ Code  Seq#    Include File
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
@@ -203,7 +203,7 @@ Code  Seq#    Include File
 'N'   80-83  uapi/linux/ntsync.h and uapi/linux/nvme_ioctl.h           conflict!
 'N'   84-8F  uapi/linux/ntsync.h                                       NT synchronization primitives
                                                                        <mailto:wine-devel@winehq.org>
-'O'   00-06  mtd/ubi-user.h                                            UBI
+'O'   00-08  mtd/ubi-user.h                                            UBI
 'O'   1F-3F  linux/omapfb.h
 'P'   all    linux/soundcard.h                                         conflict!
 'P'   60-6F  sound/sscape_ioctl.h                                      conflict!
@@ -305,7 +305,7 @@ Code  Seq#    Include File
 'n'   E0-FF  linux/matroxfb.h                                          matroxfb
 'n'   F8-FA  video/sisfb.h                                             sisfb
 'o'   00-1F  fs/ocfs2/ocfs2_fs.h                                       OCFS2
-'o'   00-03  mtd/ubi-user.h                                            conflict! (OCFS2 and UBI overlaps)
+'o'   00-06  mtd/ubi-user.h                                            conflict! (OCFS2 and UBI overlap)
 'o'   40-41  mtd/ubi-user.h                                            UBI
 'o'   01-A1  `linux/dvb/*.h`                                           DVB
 'p'   00-0F  linux/phantom.h                                           conflict! (OpenHaptics needs this)

