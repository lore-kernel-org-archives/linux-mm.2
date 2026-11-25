Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F6C060A3812
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 06:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=kERMxCdT
Received: by kanga.kvack.org (Postfix)
	id 5635A6B08FE; Wed, 25 Nov 2026 01:13:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49ED96B0902; Wed, 25 Nov 2026 01:13:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3402C6B0904; Wed, 25 Nov 2026 01:13:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C86D06B08FE
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 01:13:56 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 49796C058C
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:13:55 +0000 (UTC)
X-FDA: 85472625630.26.06D8AF5
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id A743080005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:13:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=kERMxCdT;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf30.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795587233;
	b=LVTGDU2RD5Et3n1udszpgnarC2kT/bjYsgLGe1d5t4cdFf1A3ryn+62NdAiwgWaJLzsbFD
	bslDXotjOZ0OjaPUfkXy06QZOGDumgLDPRSpPPUFgJLim1CtN4zXeOoFo9NPgLJs1++wSy
	JIU2aadOjDVaCZOVqQZgTkR2wSj/jYg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795587233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+8jdBu194DlNkmnb+wfnHItWGdgLROhV9S+C/TWCEcI=;
	b=CWZgwb0kbm+N07T7TDGG+P4dYUrX1mJt21N31/t9/5MkJKqxEpIyQTM4hLluHYUFqtz848
	0X7TTjz5u7XQ0RB84g9zeJjPFCExLbj1eu5VMLnYn5DV/iDNxdNvhvtfcg61nJojOoUWmP
	+P6A4acHjmFidKLdosNDJBgGDavd6qY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=kERMxCdT;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf30.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+8jdBu194DlNkmnb+wfnHItWGdgLROhV9S+C/TWCEcI=; b=kERMxCdTufChzabW0IvD+rbqtc
	Nbdyx0vQdDuiaGCqqp2x8hTqoQruD5AvGRVDUOhXslaBMSpsjs+OIRKnehcOMkFyl/fjtquOErF7C
	tuduPzcZz6sblc6U8dX6rlj5CqhR9GcgPAh2/sZLjyCnlbRjOx4d8uBUVRsMFKo/0ZHgUYYPao+kX
	0bISrlhzLamhNb2d9WCuQp6oM9WeQ7A7BLvhyNMN65o+7N9xyRnTc5brz8cM1qPYET2QnoDqld7Qb
	q/0mpcfNxo9vTs+1OtQjAoRWL8Wb+X12mSUPs7nwgX0Yzh7fOgBG1R2ZgiPBCM0x36EJ4EQP7b6tO
	AlnKLPWQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xW6GO-00000008Wvh-0r3L;
	Wed, 25 Nov 2026 06:13:52 +0000
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
Subject: [PATCH v3 03/12] docs: ioctl-number: update block entries
Date: Tue, 24 Nov 2026 22:13:30 -0800
Message-ID: <20261125061340.3402300-4-rdunlap@infradead.org>
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
X-Stat-Signature: 5btyrj34wqfk69tsmttra9ybjk4ppidt
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A743080005
X-Rspam-User:
X-HE-Tag: 1795587233-460942
X-HE-Meta: U2FsdGVkX1/D4oE9blEKBHSA1VGh+t6dQmXFsK5VgKVHugRe2sWKANaonVe6sm4zZOFL6cBIeya6R/j2ZmxCe+31wWcjCZiSyjfS08wdH8x7g6ehv0mowUISNUK9xCNfqm5Cx5F91kRwKI2oJenIvD/TdTR3n7iK1JzuQKUi1ZrF+9MswFexf+STsC+l3AYynSl+KhgTjaw86KYDgED82c2gWk8/2vy4r9SIxAlw+8YWB2GXnoLaOLzlT2gan2QgHD9OKj6TcYU/CdRWqaEqvhtuc/m/aof5NShHfzq7IPlLmFKsrMCifnuvprkMNm48h0EShYKOXUlxNr9S5ozpnpC00Ea60RcyKjd4cf72zlG/AihGvcYQlz/EsztR8veDjq/xGI0thtDNoIcOlkH5E/VXVzeJyzAn2DkmSEPTfKVtmaKHOOHGjcspWV2ryzk2JtPgl5HsIJmrQc8oZNJ2zaSrrFXNbx5CqIE3IfhdOPmwxFdV8siJWfdzyLIIIyqbRTZASSQjCtVxeUMtTAT+P7vWItTTyh+6OFPjaGeLbHNOO1/tvrmt4sxC2M/pfbYR2CkkNlZ1mjvIWRm9S9rEd4Uq72LNnJF0s7916wM98dsj8ulos+ph+SsNjFWlGT4VVHkFAFsm9rGOocuW6OlAOCIS2gu3z4qQnZXfknH9Jk6zrSaBeFp5GXrc5padZT91ixniIV4dHZOIT530Jz4Wcd0jwS2QwAWHmt9dMBKbmblJ1exOwj/2Ktz1MIq3j8W3c1mleacf1XKTqB2KuB4XLg0cDCu6hMFQXa8XdVhSA7StxDK4Cz7XAtiukznTo8uRyg2ByI25VKs3fKlJBsG75Qgb19gc+Hs4ZutDTXDjWSNVJNzOtOgght/WkYAaXrz0gYrlBEjLuCl2IqM5eyJfUZ2Zli2xmLH1SC7ISus44emA/ef1DAQbcJe/XVsfqT7s/Md97tFtebfcOPhpemf
 rBRkxtnN
 8lo7x2awfxi8PWP2cev941c3RNOo4WlZ7eT5woICKax+tUUFjQ5KE0Y6KJIsyt81Q8/uyYNLQgzfOctJHYeY9ZWBihIOT0C0x1W3DWpfY9kKynFiI46BUUU1B5Ss2ag5jVR3B3VV0GNclpcksqt3M0Jm84qVGmB8R6DGskr2Qm6GjVdLFpxqaJy8vaVCIEYV6P6LGlE2SVtnZEYURQmJ42JqPGxsPg2k25QV4qg8n2w+F6DkJFg18GxtQ8RRbWjiXXkjlFziA+5Dp5elzcdfGRzVmty0uYiHr0g3XIC4OJRHUw8aJksB6QVRSR72ZnpxgEGxlmMfY40c2/RWnEZFwqE5WapIifCOmWal4DMH2xlRF5R9d3tqS3TvU2YfSOii2+B9ITwfbUeECMion46DYCT2EKl3uxmPU9nOWx2OvBlTA2Kj4WSRWv1Jh4d3LCNkWdIIp8NrkOdpGTQyKh+8x1kCfUGKJpvmpPv2UN80wywH3/e+IFoi8SFqP+6BgWslGo2Q08tIwftg0iYThzP13owCHhFj9QAfaknUQmkbBH/TCJjwz4Xu3IPgroPWjeFueqJx2XwI0X67tDC0NSqFITkKm9Ucak3Y0RrxMwc627vQWiHgbDAsdDrm1lDc7w5yZUzV+KPaVl22dFjqD7a1Ui2OIeq9ypC8n4D45fIGs16XelTxu3ci/e2vCj2OPP8VFjarQlxCT0UIOzgt44Xpa20qX8rDQMGCW1QwioJe1kpSc8j1yJ1diiivmccwI8N+9zJqZuoM/9VVNMqZaiGNCRVv3pFIrU3quLBu1beyTrvjM2obpaLkr2NoofgdTDhEzvXB7YMH4CYOE3WvicZSKZ0Gsar0dHhQFqcEN6kYrAoIBWP197Rfqv4e3wDR4excFvIG2X6M3RWe2Fq0mprUQnsd/wqSlCB3iIR5hExYXBHWq+kc=
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
v3: rebase

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

--- linux-next-20261123.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261123/Documentation/userspace-api/ioctl/ioctl-number.rst
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

