Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9738B606E322
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 05:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=yNhn0nNT
Received: by kanga.kvack.org (Postfix)
	id 312756B05B8; Thu, 19 Nov 2026 00:35:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C93C6B05B9; Thu, 19 Nov 2026 00:35:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 164116B05BA; Thu, 19 Nov 2026 00:35:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C87866B05B8
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 00:35:30 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3ECAF8096E
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:35:30 +0000 (UTC)
X-FDA: 85450756020.29.12A6227
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id 900CD40004
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:35:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=yNhn0nNT;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf07.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795066528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q4RqbTqrf5mX8cN4Vzs7NN9E5++HncNdO08vef8Myn4=;
	b=1Ni/K3Q3wY1z5+j+MEPa4Es1saxaTq1w02kwXk57pnEl2GHdVu5/epSe75mBRsWgaTveIN
	fC0ONit2Zqjv/K4K13kwMa0IEKjfsm4hpZYic7+og4BhydES98WT7yxGfVNW9vuZL1WYDY
	Eurmq5PuJv9tknjL7OfHA+WNlEQabKI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=yNhn0nNT;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf07.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795066528;
	b=JSoMSMZWZY0QxzE7RfY8osSdwbjpr9oVqeeAgShkkUpyZdjF++4qPqFPPKzNVa4RiuY5g3
	nkknmhn11Pz68FFtAAc2gXeaVJlx5boB6lx1xDAQWR6XSzzH1xpBJEcLDpO2IHXqeBl0Bl
	NDpQ7c9BenHl4Rxf9UHjiHkSNgSyeN0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=q4RqbTqrf5mX8cN4Vzs7NN9E5++HncNdO08vef8Myn4=; b=yNhn0nNT2kTjtdSzkIYIw4Y8vY
	Wu8IMpwciBKK0mPRjwLp0J6lXnYl2QXRdoyGs7gEPlDNW7iR10NcDhumI86BcLgOaUX+PjrRV6xVb
	8O58AE44qe860hoCGVid1vxjbYwpFG8l3RgpeRSDp5V4FTWtIrn7i+RinM2E7YjnLj4oqL80Wyf0/
	/sgURq6tm/V4dsX6PlSh5f+qiQ7p9owDapXPkXxMVpSKTRzF2uGto4W4329bl1/byaHPJpz05ixrd
	rcTtDdUsLaE/rONtAbOdlQSsjIoUrn1vdxur07cp/kvKJ+Wiq6GsRe5yp8eOJPJ3NCMaXF4hxg+uw
	Z+U7uU6g==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTunv-0000000Aufu-0Tiz;
	Thu, 19 Nov 2026 05:35:27 +0000
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
Subject: [PATCH v2 03/12] docs: ioctl-number: update block entries
Date: Wed, 18 Nov 2026 21:35:04 -0800
Message-ID: <20261119053514.255348-4-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261119053514.255348-1-rdunlap@infradead.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 900CD40004
X-Stat-Signature: bebsfd4ukspi3aibn7gdiotypmnfnpit
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795066528-838925
X-HE-Meta: U2FsdGVkX1+SuMoR6yxmd4OakeDbq8C0YMEOvJXIU1sX7RTxBj909lRpZpPKabuggkbESValpE2XGSdBjaJk2BUOBks1vrK9gW0c/iaZdOBKKDd4RKip8XW04olHjzPchYA0pciloMiit6mzdMrhRk4lmKxlFfKD+zOVg0OLtFS8Ih9/XUz5xHU9zmyAnqcQn5j0f0nzSHGA2VCkNbMGfaoPMFx7sFfZgdot/s9BFrRA+5UUthnrLoBlpneKIvYMzDPZcnlv/dqrGZ9lDVmiwKHsJNqEeFBRkQPxdBzSEYwh3lnWWXaPFiOK5ei9im6cRfqpldZ2qnCVQcWqTttj51UwOVBOYtd6askr5eMEnjcBDVjYDPmKr7eKAaZuKpDMmzc/9bmy0rJVhgW5lc2i0i6Oap493s0gcpGA2pHXorHk2jVMubrrWTVX2pwxFmhnuiWDZhc4FB8+4M18rHEUpwreL54KfDwsRbR9rpGtQInr7xPxDfbKVn7M2ItXyqi6ePpqAvK4swpRW9FZeLKDbtie0t5WWRSxcqNn8iya/Q4JSZlrnAe6PPeQF5R0W6E0Y61cbREBII/M5a3UfTLznmw3+6jttMTOjiiG+W5q8afMZ6efmkNSyullH2gMjslixOJyNmKuV3TGyl12mKKSzskN1Deq51LpXH83HRtwI10An5xajgBSIZWxcqI8Kr0+ZuH90FwuGw/g0LaOiUNCoY65+b3f4mr/Ja7UQchpW5+L5LVxIP7MauqzeUTb4Alsu4EnHJmx/L5RcQKHHD6Be9d9avR7brFtvNMfQk+NtqbcsFLBABq7Ll3HDZeJ8Nm1BerUYp030wfih78fRQv3TIE//Vy5weGIgfPWk7PEDotY53sL5ZV0boo1dwC8m0x2JE7DghB9UgAW777ZFTDYZkQe7Tf5JLGbAwFJTqQrZXIRwB75peVqUU1s5/IdZrB5FIoZKyiJ7rdKCM1+Llw
 7tmeDIui
 4HBYu7mwGffW/3Gd7X5shkHgq/SEG40zusZ/M1OsNpG+YI2oHGvK5BFhz71pg4hjxz0RWba1lKYvpHGEDRcFrfXuoyo8Cmy1ME1WW9IMds0s2B6PRnNHqxBqINIpbY+Yx5WU2/8ZTRKkxHVULypmEHu4FomIDvI4EeSAqgKUdwDFcveeP/AfJ7FIe571j59UvNGbI8EreCAOm5a/jDS40GDOyi+UEmeHxynPsP/rGRp7wW1Ki+8r3cW4I5P5npRjMdMWOLcEsSu5GyA3gOkcC/iqIqeNCFneXRs7JgYbkCyc2NN+GjOdJYY58zWUnkumjbE7qlKI649kskviwyejFX7LRJzo9Bxwl4Xcesc4QnE/47y1r0SSoW5AsbyK/xrOygRgdHrGkn4QKAdcdV5eCfs8SO1r4pd4pwrFF+ywTxawyUkYwdziyCz9j5uN4Nr7x1dG9f0GROQ9hnYLHiFv6MrPsr8aPvfTDMbA+xqz0YDofACEyfFXJc0MRRPT+c9LxnYPJbUtvHj7o7k+AnhEo5IR+wUOakmZUrVNC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update the list of files where block ioctls are defined.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
v2: no change

[Since having multiple maintainers trying to merge these would
cause some conflicts, it would be more manageable for Jon to
take all of these through the docs-next tree.]

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org

 Documentation/userspace-api/ioctl/ioctl-number.rst |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-next-20261116.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261116/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -78,6 +78,7 @@ Code  Seq#    Include File
 0x00  00-1F  linux/fb.h                                                conflict!
 0x00  00-1F  linux/wavefront.h                                         conflict!
 0x02  all    linux/fd.h
+             drivers/block/floppy.c
 0x03  all    linux/hdreg.h
 0x04  D2-DC  linux/umsdos_fs.h                                         Dead since 2.6.11, but don't reuse these.
 0x06  all    linux/lp.h
@@ -90,6 +91,9 @@ Code  Seq#    Include File
              linux/blkpg.h
              linux/blkzoned.h
              linux/blk-crypto.h
+             linux/blkdev.h
+             linux/blktrace_api.h
+             block/ioctl.c
 0x15  all    linux/fs.h                                                FS_IOC_* ioctls
 0x1b  all                                                              InfiniBand Subsystem
                                                                        <http://infiniband.sourceforge.net/>

