Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34B6F6073597
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=BDu5SAtw
Received: by kanga.kvack.org (Postfix)
	id CEF666B05C3; Sat, 14 Nov 2026 15:27:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9F2B6B05C8; Sat, 14 Nov 2026 15:27:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B8FC6B05C3; Sat, 14 Nov 2026 15:27:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E1E56B05C5
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:27:19 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0C27A1A03ED
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:27:18 +0000 (UTC)
X-FDA: 85434859356.05.EA5CB01
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2810D1C0002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:27:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=BDu5SAtw;
	spf=pass (imf18.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794688036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DedKrhvyClXF9LtBnIx17a5S/VB8VLXfL0mdcjl2pPw=;
	b=ugL4m0YNF9mlTlSxFJ8NesukPLwf4u8lTCFbB9NVcqRK14mpRahECX/olMPysrJN6HDhkh
	gp0gRuiB0n44l/W9ygfJUyQBFnT7OqGo9J0TSphbvGg2ib8mzOjZ6hrkE3qmmUdVVErq5R
	4YxgRpw8bEb+geFUdPqhMdlmNH54XaY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794688036;
	b=CcNTp6D0VLoMpBjJG3dEkpnApXXEiLGiDRls3BmHCxR0AMc86qrs0MEErAEMumOh9nvpox
	MvgWnZR/6SvH0QAgMOmsLxzCYJsJQ3UM9kxEDnp75NQFXCKCQNxFJCzNS4I853icUGOjwV
	vjgZ8lPTqqSPaRFwFufVkvVCvjdzK+o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=BDu5SAtw;
	spf=pass (imf18.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=DedKrhvyClXF9LtBnIx17a5S/VB8VLXfL0mdcjl2pPw=; b=BDu5SAtwb3qtVN8B7fKoSynNCT
	d8mfgSQ79JqH2eiyIjrxvq1UNeZ3AEg9hUsOjkvb8i8bBea9eKyyvTCmdlHrsJ+6oOwmx93uD4PGr
	rDleVQXo2oD5ie/ZE9/xl1gNRVbx9MMw323qgK4s6+e1YMfIG3UQTx6fo7bqVuDfDWuz2M3kGdtPz
	a/oVIz440s54DJCpiJSupYODW8eABt40wMJ0VcdONwAKL2M7hxtFsIOiGmbDi0prIb0gCQSW2px3+
	zEufpgww751kDIjSiT8E+T7MpOX1MmtAdQkS2aaccKcmz8ud6HLXI1qT/x955lJ3WTj/MzF0UOGVi
	TzxUVRXQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xSKKz-0000000Giga-2aCy;
	Sat, 14 Nov 2026 20:27:01 +0000
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
Subject: [PATCH 03/12] docs: ioctl-number: update block entries
Date: Sat, 14 Nov 2026 12:26:41 -0800
Message-ID: <20261114202653.3113381-4-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261114202653.3113381-1-rdunlap@infradead.org>
References: <20261114202653.3113381-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4t1x6jy4rbmgzbxknxpqzbuc6qgfdaag
X-Rspamd-Queue-Id: 2810D1C0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794688035-670145
X-HE-Meta: U2FsdGVkX1+fGP2ZdPQocS4nEubvel+jVFCr0nh04HLZPveTYx5AEvb3yvvbTjBvPNG28i26ibet9whMeHkW9m3jvCZfrvRDJ+U22Jx+8Ow6B+oxRV+sPpgpgLeFwEADA24I0QaMv4vPIHh24WTFAepaJp6WKTZ4QVpW05DVAWl8C8jubL+nUIoRiMDEjCw7Wf1qvykHHzw14vrboeXwCdOj2jzCqvjjrVtgTDHuNmc5Fm88/kzWdeFQGbI5oAE3cezvjU1KG8QEIjpf72kRmEYaimZIcOLBhFq7dqX94Cb2va8zWqwf3RxnXtlxBUgEeiRIM6VNCZ2q2n8Lg5R29LyIwsmApIeL/uKw43Tlu9lCQ5ljfBJIK4Og6BcuQouVi8BeGUKZZ5l/FQBnIkB9AWBh8brQcE9S/Z6T5Dm/IGO1MA4A/O/BKTkj8XL+ep1zCDKrJgEnsBjYFXOAgbrVhltgcRm4trNLlWjN+4MqLUnCB7cexWReZZCNkrxJF0S8x63vQfaKylB2HSnsEnucb09eIjquJp8mTV/yRj9JwsmE6aFS5slqpV3S6IcRwB6JVbt3hj5pnn1MdAKznR4WXQZYnSv7AhUfsdRJZpLwEhefJ7SeVHv+ULghTwLW1tS+/XoHFS3LmoSmYxd78x2Sjh50SuQcuIK5H0g4NE4OjC4Cv/U6bmKtNqA8uYbhNr+3xfPoRSW6XCs9JQXjYIa4NkCsUPGiWxC25wy0xMXB7fC4ZDcO5Eb4iGt2+6b3Was8fQ2Eaxd0w9aZJ5zXJQk6kjyHshYJKiTCDxbBj8I2XoS4HzPmjpwDBSg+Sq05fH+sMOtFq9Ei6LQapF8EBjvv625yAUMT739W9nUps78+NPa/etEKAHTB9e17d4t79V5EhTfRtsfoLoeBPOMu69p2LtDIUUcXq4H8I9M7TDRgkGUmQrNkJCtzO8oxVK+a/w1WBwwiXZOZm09nI50GZdt
 koiK39t5
 5hZmYVEotgTE3UfBgi8omPrt6uXv2CVN1Yu5qnStuzYgZvhVpH4/BUoeJBDJXP2fmUX5o7pULOp4OrpJcS0iO832mbLNpXwRv5z+JnyZvSgFBRujriVTHNKq1vJ4mIydfANzq+FTPSL67qhvswqFmDFIM/4+q/q2VV7LCVWM+7cH+ArWtWkISdUW3CroF1sOt9k083t0HjNuU0ns47l6EUFXOotjonnh5ibch3jZ813zH0PWEVoZ7SFtoQIXZlOAP9uEzby6fdNfIcYbgYYdX7TgB4CnAKlEHNvOaLHgRVSYT2IBTbQT8nfYibIF+m+7+rfYtZ9CUgWMEhO5Nt0MYg+MViuMkXGDJqoqejEIEROYPgWHs0aBpSNPFi1mXh8Tn+tVYDcCMfjC0sW+v7iy/UuknJvKf/c410jTDmEuXEjWLMgrzLZjeWV/YrMVhtCeDWZfQXxbVl6dOfRwQpwKCPYX2JuPMbMOnoNg1UGWx7nlaLRovHMnD8w6hVwIQ0TjxR+8p8IV4R3LkGHfQVFw0IvMgAxz5ZJ471V+H
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

--- linux-next-20261111.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261111/Documentation/userspace-api/ioctl/ioctl-number.rst
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

