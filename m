Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5877606A680
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 06:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Mgdlg0/0
Received: by kanga.kvack.org (Postfix)
	id EB1346B090E; Wed, 25 Nov 2026 01:14:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E16666B0910; Wed, 25 Nov 2026 01:14:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D041A6B0911; Wed, 25 Nov 2026 01:14:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0096B090E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 01:14:09 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2609D140DAE
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:14:08 +0000 (UTC)
X-FDA: 85472626176.12.08E0DB2
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id 87D3AC0005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:14:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="Mgdlg0/0";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf28.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795587246;
	b=rsFRFIUo29liYpHCHmPRI92Xpb3+ZQYYlBGIeLABNf31zBuf++yjuSWOzRBnHwv9DJpZxO
	ts0/76TTq0YIrVZ/c0lZBRORv4T7xEsHaaAyvEJkp5a3e9VPbHGK/6ZvFnvEPqGH8jxsfD
	g4ZC1LnMSJTnL2436ek/zQILdy/2DR4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795587246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RjBc4ifTPecXL/WS/5jRX16xGScyR8p+iOgEL82NW6g=;
	b=REgLGVxZsc+cFzfmFJ5BXL9Sgrp3MOzd9yflIDFEgtIn4/iu/6BY23yNyuBiJWzRztVdvw
	1YYARGcTF/f15t94MBbZSWIFoXWMIEDgiS+y/o4cU5D8vh7XReKL0b4IhYhaYvb5mi+rlF
	e3Llq3hVhP4f2gpdGh9PmcXQWgjZH2o=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="Mgdlg0/0";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf28.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:
	To:From:Sender:Reply-To:Content-ID:Content-Description;
	bh=RjBc4ifTPecXL/WS/5jRX16xGScyR8p+iOgEL82NW6g=; b=Mgdlg0/0XSQjJ+dbSaAYTFfsa4
	jIjxnNXFhICrq6W7ftIa+TIE86KDOEjUDyK2cEZS4G5oUvv6wT2NqOP421irvhcz4PbRlcas6Oek4
	l04G9EUR+6lOX3Jayr2U2sSBtCCNHkP1n+3PQPaQGwEw/1rIYipgOcNZEx2aqEtpYURknBByGxkqD
	+1irAhRtvZoVNuopSWs9s3oNUPF38vJ8gXUOZgeu0Hwk54++nUWGcP/VByRYvqRpKYywd7T2TW8EJ
	T+jvEdVi23iEjnzjxZQuYh8vKJZCfbXTwMyr25vKCuGSvKrKMlUn5BVbe0GYKO/Qn7nuahYqNPikU
	wbdGOsKA==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xW6Gb-00000008Wvh-0C4P;
	Wed, 25 Nov 2026 06:14:05 +0000
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
Subject: [PATCH v3 09/12] docs: ioctl-number: update virtualization entries
Date: Tue, 24 Nov 2026 22:13:36 -0800
Message-ID: <20261125061340.3402300-10-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125061340.3402300-1-rdunlap@infradead.org>
References: <20261125061340.3402300-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 87D3AC0005
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: rqkasoyqooscgkyys1pnsp3ps4t3xs7q
X-HE-Tag: 1795587246-895021
X-HE-Meta: U2FsdGVkX18szNjrlkxGGrHZBtDE1z7/MtLu2dHCZFq+AsL7VYQUQ2r6Ct9gHnFhuVZRc2nfqXnXiIE7DC2X7kal/4HEb3OynHhrnAhUfFWsSYoL4tq+qKCWFH+HL5puQeEbZN5BTlNxt9xCde+agt7EIOZWcFCMmLexgTjyaZHi3o6NPR1bf6U2y0kLGQ4A32Fg1LkHcYIgXM8RKUsf8y45S8x5uJoFvr7GkKnzsShaXQsARBFA2nTzq5PWG5OiC3613447ytBaW8Ej2jUuUVeNhj4KwcVS29SVPmF5OGgZiSOYCnLeHpSYhlgLoqoiyAi6vksAaxKgj9TGbZVSFyG2M79WqXIJDkjRI/IPtMUZieZncHc1pI5olacbyHVc7CC9003cu0N9bHx02q/9FsNDPFsMMOUVEs5Ed+y3qQGJCXyXgG9JCTjiQTrVe5nqYgfHLWTkgEF4iNbEYH7AVI1s7Q2O0p6+T2sGYVldTfp4hvXzhzGFzL/yLqDAkmNhSrGEFQd7CjxsjBgPTF0rn1r162sPrhpdCxOiAutL5DYBBEF6KWaWjrkL/zKlhp0igi9H/+PUOvHRCri1GG1rbVSYnrPwiKaxffUaBn6U44s4MF7Q/fpY7yi1QmK7ABWQqyAWz9k5CARpJqDquAcSoxefU7gTyxYwElys0BG4BRYaykY//9WuW46QOiUtJWh+IabSgKtQPnZArIOgtFjRRrqbThPRpb32yHkt0ydjGHdULxvj833m+LozD6fGfvU02h0VN02xXqooXvy+SLmdsqzAtFzoIjQtudbTWt1bqodeQ2Qo0r47kS6XBvk0iXJ3EB06IHavGYX8P8DzyMI0hZuLtpjaO+SSfscpJlgmUGgjDGCHdse+0Zqs+yEAtKDJCehsg6eqMzCNi3ximifBu7+TMEDiGawXpDnYpEI9GElRRTzUiFre4wgZkbJ+HZvyYEsDY0kwA2N+/o3XCjE
 2xyWnEh/
 VVTaucGrewAgHaLEnp2g0rMkuQ5irEwHEeCNQ3NlqU+FFHXgYMvcDBG38isoc9RqUURTSjSHHqkDNqxABdGLINLgO4rhseTVIa289+LtDlRXrIYcBPXmOfnVlK/8M4hlo2QGJbDTJwJp6a3WnjPFxWdXLPpvwdmO8KTI7kNJrCLwn1OB6zguo8CjVNCpGaj6m+ckp7Ndd6z+F7q4stYQxsCaYl56kGBS0u9+BuoQ/SZiYKAyeGg6uZ2UojmHU7elsnlNumfyUwKvao7lpLZuJ/zVii1edVTrXxo+vsI7P/afuUax9QB2+4sIGosKD2K+1GmQ1V1LCbD3xZH1DRvqOtP/t5+taSma9ulXMEzMofrh0N94SM0LYe8ppUz9ZAeT3nFZxV/f+1EXN165+Iw1MhUxj8+be/OT0eybvUfIqaLBz1x+w4HIWlpthR4sIhfbyOEe/Qc7pxvniKrlpxT77lapqiSkDMN+iZ41Ok935Dvr9F6eBsglpFmnWBBPgWhFifh/y6LtdyH/VukoumhnHWP7cAmXzO09CkMmYzOBiTbrn9vQr85mL3XPbD6gQzKfZhHAIuWCJ+eobmkJ7Z7Q+ndDw9c4udsisWcV1mB/GXrN6uY009nN5jcGlq1R42EDeUPzz24JXxJ1Gi4sQczsm72EqQQOo2jmYiZXEW0BX+mO02HUcsb3l6eFiroCL/61LtrQaliiM2B8GMcnVaZIM5wdcoO0AqijxjBCu6lBIlYR+jgqqQwPYJrKk7UgYRkv1KDeASmo6MNPpt2c+HJq4maNpNYNArBnQlE1WvxoHakTL5vAwoh18aUhSfIK2uPgz5LE09w/8Ze8J7EY8EEB9VqGDH0RRK4AquimeKOHVwhMyFPh7NL+OZOEBKRBmrro4jDPSamzpuT0Pqx2rL8YyyU7VHFPJp+PFfhgFyrHWKcRchE+r36wpw0h6YcFIOQA8zFdvXZETrlK0aYL3Bv+cfCqPDMaI
 EjFclSJO
 jhKMksjyGERCwAXgB2NOn44HrBn/Uen/d0q20wmE+Ogpogaoxa2MqJlOZbt25KGWgipy7q5nxHFapYafpNj+11jXnXH/e0RboRLeSQ5dhiRR6VkwVbAxfAzI75uws85Mz/v2AhOJLDMmhY+rCQwLfw==
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
v3: rebase

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

--- linux-next-20261123.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261123/Documentation/userspace-api/ioctl/ioctl-number.rst
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

