Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D0F760A6F47
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 05:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=a7dJOzVX
Received: by kanga.kvack.org (Postfix)
	id A6B2A6B05BC; Thu, 19 Nov 2026 00:35:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EDAF6B05BD; Thu, 19 Nov 2026 00:35:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B65E6B05BE; Thu, 19 Nov 2026 00:35:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41FB56B05BC
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 00:35:40 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A3877140924
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:35:39 +0000 (UTC)
X-FDA: 85450756398.20.ECBD6B7
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2B543C0003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:35:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=a7dJOzVX;
	spf=pass (imf28.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795066538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bp3l8rwDPkSKznuZqcxjKl6885TgLTXi4yzkCNzGJRw=;
	b=iqtwppASnCyU4sX/xEMyG/aTlOQPTzoyYj76reUDHM71G4Sqywb1QggaEYfT3axXpg+YpS
	pzLjjRm+Z+7W4bPufui4BcLdXXhWdYggm3ECojx5CbR9jJyORgRzTFUnOEdVCPKFcQ88cT
	XD2/ESxG1Eyrt8SIFrYeHbVOEJQi5jE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=a7dJOzVX;
	spf=pass (imf28.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795066538;
	b=BgtWu55+JnIr4YH5Cha7dElqC7ZS4gq+VNrAiOfAPWNKDl/os3oE25X427JsvzB9IO1OcS
	m8eDk/8ObrJm2VmLPaIgQdGaODXld5crCTj1i4H6m59aI8aSRFfiDoIgTS0Ns4KrPRALm5
	BcxkUBn90VkEqHC3Ig59F3zbuqvGCSQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bp3l8rwDPkSKznuZqcxjKl6885TgLTXi4yzkCNzGJRw=; b=a7dJOzVXczfXW7dP1pQdgOXabl
	T0lzpIGAB3rM4BqjplgBseKhONkiLo8FqjUjC/QeLtOEv1Fip7Bbg9rFvcPURlwylnMWRY0CpS/gv
	JU5wUuCHK07Kd2uJzstOabVXyZt4lVxplH4grO2i0Fov9cE3snJQwplhvj1bAgYxpZKn2uuMCEksG
	AEqoJVO3SCDTJYqtI6pdlYiu87NTCrn27queuBQpVaWEEtDQ4/KBC2+LoOVscqpeK5jjkQNZ/gjnG
	dEOzIUzdnAi7f6M0OtHuWf8AhTPay2QWRe5zwdUlHnod8LdvXypaW4Mj5RRhyQEFTu5DHgX1YAaIh
	vpjrd9Bw==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTuo2-0000000Aufu-2Ea3;
	Thu, 19 Nov 2026 05:35:36 +0000
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
Subject: [PATCH v2 06/12] docs: ioctl-number: update SCSI entries
Date: Wed, 18 Nov 2026 21:35:07 -0800
Message-ID: <20261119053514.255348-7-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261119053514.255348-1-rdunlap@infradead.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ops4c8hqphwtef73ir5ucjbj9cd8sqk5
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2B543C0003
X-HE-Tag: 1795066538-880617
X-HE-Meta: U2FsdGVkX1/8uB460g9ZIFydC8M0vpVOhCmQW81GXb4SWDjUFttdjX/elDz5haKusYYaBArZNmwRf/K2llLbRseVyB+fsONHUETbJTcI3nk8Jh6suCx59+xmNPHrnRunhu13hUBn9RXj7WPuI13t/sm1q4budELLGhSFuNFTF3NfD/xGT1KdLxH7fwh/JaOHOE/sVbbSw+vF8sS0BErzODOqzMc1fvhhpyixeTU7uqJCHTFjGrpUxT7oJzhsota+227qVUCREDaevyb2eE91KbMax5w6tzDbjPmktdvnW8IXsZBNDDJy8fG1PXLQYxXsCd1n6wk6wirICd8IY3rckU98mU/5FKgaXUXo8zyH/iVY+eMCMdHaj7WTGzyjuJEZYCUhjvq9lKfoqVc4OKFfg2oqj+a75fNw8fZ6A+NHyVI6e21shiMKp76Sm4fWpNvIovc1ABM2Q7AjkB78HAcpjO1wZQ280Kzm6TngQHljQfWyX+fuHHIJhlMIIGfKvHbV2Dgc28JQWEZVuQuwEOYDorX1EJycZt3Hqj6bDvf3RSNfRVxL/CjgAQP8ZS0OwgpvOKzLTRt7wTTvex3px+y3S9x+RMq7xglhtgar5Rd+vpxGtThe9VY6201EJMiAkuyKDX0OeUBaftdv+GZGV/KiLhwrg8yiuu+Lrm1RcZdfSkgVNvrlSIQeh5qvn4KAXnJoLjcqgrzWyIOPOZ34hiZCZIvXJCRc4MgaugzUYWGD7XodoS3Za4N5h0GW9ToVixgo0qBHqs42i5h3CbCbHHwyneKtKI1BX+qKjRpBKhYJQneYO7oIXhgUE8CPluv+bwP0xZUWfTdr4rZEvCiK+ailmt+kSGijCeHoQ0s/hSbElK+oATIBH7oRBlEg6Yfqp2tFIeG5kkrkg/dC8sSCc2wY3/lM1a+VYxUXV3xtCdThk7bHPenHxtKOyjsnRLIDfSnBAVgV8K6UvHIx5LAY6dT
 UFhackHG
 NLnkxZg4yPeDiW9k/Gpv8vk0E4Hfyd1JCIxvXmJw4lbttaes3STtP8EfpHpOsojuXO3GaGiOVKSlCtL4edCWA1huM/EG8uxhUN49SfS++DTYD8NCkyjYibr7NZiD0ZUwL+dbspXEOAEZGBvWkyDM/AqwJm3E1pGSsvfRxZa1xRvKoND3f8uedtwhgVUO4Gyvh0CtOFwMQtkJ0+WB7dQiB81KVJ36UP3VPLPaLuMCdKVP7D2pec6rI1NIhdiue25CN8jJ3KJFBoFXP74mzDUEsQknc639JOsouLpyoQSr3MTfZo6CiSyGQGLvsOO+zeRThUMFbcXtpMifjQ9fodczquDS0Qxqxyu1BYMYSkH/CFmbVYE0kPm+I4xyHyl7M8z8sRC5+Kk1ENdjsVL+aagpFqMFoLk2WPIk4+3JtROiwNOWYOGW0dKKYOKElp+kY+smaggPbhNp4owJZhvKs7dyMcnJPb20pp0RbIW0y4sYwlDiPu3agEsoSW53ZuZZzMOUH/v177pzY4WgqP4cXXv6AAo9dFlsU77k5jp+NrO9ffvoutNcVWKZ+gQviK2bCJ3hwdGKHUon1+g2Xdhowa2WYjAybCLcQow4yR+CnszFaFmq6bbcIEUwmT4NZVOUainYo2kKUfj+CRLL7Z7kCZihd8+gAxLDUUbqeNJqWQBnY+jfkqNY=
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
v2: no change

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

--- linux-next-20261116.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261116/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -187,7 +187,7 @@ Code  Seq#    Include File
 'I'   40-4F  linux/mISDNif.h                                           conflict!
 'K'   all    linux/kd.h
 'L'   00-1F  linux/loop.h                                              conflict!
-'L'   10-1F  drivers/scsi/mpt3sas/mpt3sas_ctl.h                        conflict!
+'L'   10-21  drivers/scsi/mpt3sas/mpt3sas_ctl.h                        conflict!
 'L'   E0-FF  linux/ppdd.h                                              encrypted disk device driver
                                                                        <http://linux01.gwdg.de/~alatham/ppdd.html>
 'L'   35-38  arch/m68k/include/asm/fbio.h
@@ -259,6 +259,7 @@ Code  Seq#    Include File
 'c'   00-7F  linux/comstats.h                                          conflict!
 'c'   00-7F  linux/coda.h                                              conflict!
 'c'   00-1F  linux/chio.h                                              conflict!
+'c'   08     drivers/scsi/ch.c                                         conflict!
 'c'   80-9F  arch/s390/include/asm/chsc.h                              conflict!
 'c'   A0-AF  arch/x86/include/asm/msr.h conflict!
 'd'   00-FF  linux/char/drm/drm.h                                      conflict!

