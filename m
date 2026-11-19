Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B8F4606A325
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 05:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=pfPcCYsQ
Received: by kanga.kvack.org (Postfix)
	id 55B7C6B05C0; Thu, 19 Nov 2026 00:35:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BE146B05C1; Thu, 19 Nov 2026 00:35:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 311266B05C2; Thu, 19 Nov 2026 00:35:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E0A666B05C0
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 00:35:44 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6EC45160917
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:35:44 +0000 (UTC)
X-FDA: 85450756608.10.9B096A2
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id A532A40008
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:35:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pfPcCYsQ;
	spf=pass (imf27.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795066542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4HnqDLCNCiAOQ9sq1Q6ULWGj/wzn4gKYXx5Raw5Q7fU=;
	b=uqHd7sPuFbpHDDGYAq5o+Lg/dxksCY6baNm6G/gfOC2h3EvBFg7dSrcly2jr6KlM0hALPC
	yajJHXQlmZPxeTn6X0g6b2TR0zfEWki2cZI48/hvNz4q5k55Yx2g4pGuMtQZY9jUBa12GC
	Y0aX3jqCJiKAvdV1xO6E1oa4J3RgEDM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795066542;
	b=QvboVtWKTIwOjbYy386oA/tAufOlmWurX8r31REnTcHLxbZujEQGngsecaXrReyRMxNJ0o
	RJBhTzPOba95o5c7mG4Y593+1bZqZ+YULDbAKXtbGsUo7aJWsy5w9eqfEo6FIaSB4efQW+
	UYwIQQNHBjncYiY2CVm2S0vElFmWKyk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pfPcCYsQ;
	spf=pass (imf27.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4HnqDLCNCiAOQ9sq1Q6ULWGj/wzn4gKYXx5Raw5Q7fU=; b=pfPcCYsQEwWHQjf5W29Fay/2Uv
	UJCzM/N8GPrKSlfa0kFLlCQSAsxwysOlDXJuf47g1kmF+Z2a4A6aqLLaImJuq+Uw0Pr+eVVIL20WJ
	0+QsE2toVIUeuAewEy/xGnT7NZ6A5Ekqo5aDPryoX6bp/PFb3d+d1wjBI+Wlyl30Pa2FKn+cnqbDv
	4+km0I/8557GlM9yhg4WcFnQT9PDGri91LWN2jFxyHexdEYpPDz1TuclUwMaVWFLOsyTLkgl2Bs2+
	gZQ+OUl6AGwuouyQ5KZhilUoxyrUBrMlpuvuiGEbOw7LPa0k+AQixDX+f23ld5jyeNVdBvzyUTiy3
	LAKnDb0w==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTuo9-0000000Aufu-0VZ6;
	Thu, 19 Nov 2026 05:35:41 +0000
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
Subject: [PATCH v2 08/12] docs: ioctl-number: update USB entries
Date: Wed, 18 Nov 2026 21:35:09 -0800
Message-ID: <20261119053514.255348-9-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261119053514.255348-1-rdunlap@infradead.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 66xkoytkas63j1owmrcwpeoyhpdjr3nf
X-Rspam-User: 
X-Rspamd-Queue-Id: A532A40008
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795066542-221848
X-HE-Meta: U2FsdGVkX1/3rCeYl5eNwup4BF62Hw6/5i05emtcRVJtVDUCxmwWkCIa24ETbfjZKr/p0Qk7OVaGAIp0fZiHhQbuQle6C8hwwrcasJErvYrXjVAQvYDNGORqFywl139PtYFfO8djiUljIQIi60gocg1x5FQlIYrbSVJXUxEebBgJeAju4Dyl5UVrU1RRfDZOiDgth8yxFd7I1gLpWbxNcK0yFqFfGy5YLL40UE3zM+oAoN0pnKcpc/3LLfryP0g2o7fMeQpb7lyKWZrSVqlpjzXqfHsfjjCBDYaC8fu1JnYglcWEKwGEfII01FvhETYmbbcxWhRTNzhC0JJ4P98YAohuvvkzQH5WdpuL1G0NyPU1XkN0PQyjgA2Cjw+8s9BRfjkHnqKGbKxfRpvMZkSy+hdZXIP41CbvWKIb7I1DBgJX8tZ5VAwCNWt6XkhcHegZ7IlH94eeTyAEwmr6GJ202QdBlU56A1uIeTLMqnj8AsRWFpny2AblaO7+R0WGk4srSnj6xyg/HFrKnPQVU6Av14/wfJm/BJUff6NRRFoQLGFStqof+OaVJZwTJv+MAkiJq8jUE428DoJriZcuUWwHLOLBAeC2dXnIYQ8hLh2Syf+VbjbQJfvlx1LL2DlNlQjXmKaReOdWVqm1m938XUZBlm7fGsd/9GmgCFI6dWtw5Yyi6UHCXls8sn7kYqI1xI+Do+x2OAU/CVcNlxWyu+3f03o+LjNBL3reN+AipKqKwOaWk5btx+pEW53k1HrizQ1VgOvAvmI6RTlepOI8R576gXo2dmwlcNGfcvUewt67AmyFoby3YwOuZlid1URC06fQyGLAmMs3vWFej4lmyZmRhzrcSvXeEOeq4lzx0cJzhlXSStlyI9r2DRLNT9QfnnkwvB5BtUYo6xP3o38rzkzSap9HI0KZJPnq93HZIbkRU7ggJM6MKhAe6ED+UGoIFYddMRVeyqD4jO30AhK9d7E
 OpGmthDr
 weI73x0C7EngiTE3SpubZx1Urz/3YI46/7vHVJDyeRRLJRijAVkZ6gsOVsrhmraonRGxMAjNLXp2BAAM+j6Ra+0hHGp2SsHbTr2jLMbqvIRR/fBcSW6PUQ/lpcg28oOzdvO3Fl4ogXhP7Bj4IETulFBoGViuuI1jaVLNumnoFlYXpCaqHDWl/YCoOHjg8+uHCtPLG7mI9j9VUgRxO2u3DQvEP15gC5UPDgNI4S0psVNIdOq1O1aJ7of/f0+w6oF2lE+81o5ycKzHdA+SXup8lvbTd2gAkiXDltrmiPreFtQBQp/JCdV4hKEWID2MQwq3aUMgM/N3J66sMS3thOB+6Wt22Ii2mba1u9ivIN8MilgIZG0ukLQ9Dp9GXUGhn5XFVDDNxsYMhHixkTMNp4lLQRd7nys5j1oT5vJ5ks7BGZ8LzrrN7wS8o/zP+0uHK3G7nNPxG2b7g8iL/xnZj3O1QqrHaUyrotSbXcXj1FKFVy3eYrWQumZMTw5/f0SwrD1TRj7BXcSbA6blioZ5gj0HVlRYeIS1R7QgAqFbYI3wyM2KmXbzxXX12SSKQYa6X9dB4SbZ6o3VZPxpqrHjBzPGzCsDxG0a/2XLhemWmEwzWwCpO1itjrnfZrM+s6ZAbomYlC3QdrZbZh6aqQN29v56Kox/ndroi5RZxcvcZlSAVGc1qseg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update the list of files where USB ioctls are defined.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
v2: no change

[Since having multiple maintainers trying to merge these would
cause some conflicts, it would be more manageable for Jon to
take all of these through the docs-next tree.]

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: Neill Kapron <nkapron@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org

 Documentation/userspace-api/ioctl/ioctl-number.rst |    6 ++++++
 1 file changed, 6 insertions(+)

--- linux-next-20261116.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261116/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -233,6 +233,9 @@ Code  Seq#    Include File
 'U'   00-EF  linux/usbdevice_fs.h
 'U'   C0-CF  drivers/bluetooth/hci_uart.h
 'U'   00     net/nfc/nci_core.h                                        conflict!
+'U'   00-0F  linux/usb/raw_gadget.h                                    conflict!
+'U'   01     linux/usb/g_uvc.h                                         conflict!
+'U'   64     drivers/usb/misc/usbtest.c                                conflict!
 'V'   all    linux/vt.h                                                conflict!
 'V'   all    linux/videodev2.h                                         conflict!
 'V'   C0     linux/ivtvfb.h                                            conflict!
@@ -279,6 +282,9 @@ Code  Seq#    Include File
 'g'   20-2F  linux/usb/g_printer.h
 'g'   01-0F  mm/gup_test.h                                             conflict!
                                                                        <mailto:linux-mm@kvack.org>
+'g'   01-03  linux/usb/functionfs.h                                    conflict!
+      80-86
+'g'   41-42  linux/usb/g_hid.h
 'h'   00-7F                                                            conflict! Charon filesystem
                                                                        <mailto:zapman@interlan.net>
 'h'   00-1F  linux/hpet.h                                              conflict!

