Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 812E260727FD
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=URTxLvs8
Received: by kanga.kvack.org (Postfix)
	id 414A26B05C1; Sat, 14 Nov 2026 15:27:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39E296B05C4; Sat, 14 Nov 2026 15:27:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 268006B05C5; Sat, 14 Nov 2026 15:27:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D6F576B05C1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:27:18 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4DC73C0488
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:27:18 +0000 (UTC)
X-FDA: 85434859356.16.99D6AC6
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id 415D61C0006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:27:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=URTxLvs8;
	spf=pass (imf20.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794688036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jUoI6BfFH1sB0+FMEHOL0bU6KfXMRPa7Wq1sLElSuu8=;
	b=7vurI9UxhidRFPT108oS0RpfhwT411dPQcanBoS2QjJfMGZ2PdQhq2FGf9FElkh2NgYt/4
	2bIY4LZUG5koPqpLFaDlMmSssCitx29NcE2JaBOGWS02Owb7tnwUpxV7D7iJxVsV8TErBe
	YHG8fikmvfnBzBJDV30sHFqgROW781A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794688036;
	b=YATL5YRE1TvNVwioAFd9foEezNvdkSRx4/8uVQgLPaygZabVMT7ON9ytc6bJ1WkAqHysUM
	kdh07cs60pBAFEmsk6Dc3++/tvhyaT3vErqo+q0djb8C8Z4cIHF/n8pg6O7bN56aII6YsF
	G4Cim9IyAr9Li0e+HY7C7v7ogbe0O8g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=URTxLvs8;
	spf=pass (imf20.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=jUoI6BfFH1sB0+FMEHOL0bU6KfXMRPa7Wq1sLElSuu8=; b=URTxLvs8s42zIeIRrKz8C6wtsy
	abmbm9qXp3jOcsGAYH+pKr3RJ497JX3Sk6817p0QAhQG/rKzLG+v4FcRs4ORGLq+M0q7u3BfuXAdw
	l6tZH8HZo6NNAGvkcfu/jWfS2ccRSv08zndHkheLkJGJ9BZE41hQpKP614JLBybA8TfI50vC1kBVf
	fqdsu8BNwUYSTtYCoe2DMkVzVLNSqWikyGMVDouYC4NVgTb8URX0mOshBMLufByQAwDlKKmqNvYeU
	D931VlcKiTqNxXT4D0DqdghI9GaWOGO01Wj3VpY2SrnpJZHlsQymu/nwKbhgtvWTV+vGgjLLjTlnJ
	IlrwuQZw==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xSKKt-0000000Giga-2fmk;
	Sat, 14 Nov 2026 20:26:55 +0000
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
Subject: [PATCH 00/12] docs: ioctl-number: update entries
Date: Sat, 14 Nov 2026 12:26:38 -0800
Message-ID: <20261114202653.3113381-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 415D61C0006
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: yzh1ydhfa4zge4dbeqjrkpekfnztuw1g
X-Rspam-User: 
X-HE-Tag: 1794688036-850572
X-HE-Meta: U2FsdGVkX19AzJPHWH5xO4cY+el9VgQOOgmT8zEfli7zvhKBR3cGOjUxD5oKtH8RfccRFQ2sTnqGzoASUSqFKADs9so31ZNijHJbIXL3xN/DvQcbOEhycBrKMOzJL5414Tx1oX0zvM9yZvmKRvRM/NhBQ8cPU9LbwHk1q7XMc0oyKrjHMLuPG6aWvaY3SWbjIUdpuUSS4OzXtczwvW6JFd3QvPh5a2shOFkP2KjSjEoG1p9ivR8buVvp7POTDAvtp53iQFs1Ue5U90SOevfBwqWqtCWhr9V1BvhJCwPxjlDJAqHfW1s7yofgYNahT7Hit7lIlyXsq84paO6PH3KlUqvwmCYrS4RDFyxrCM/cbJfdxu5/IzY8AfPUEwdJ5hM1GMemlye5duUVwA5RCwXrZW9HeIDKQj44Y7spZDCXkYR1W5QIJ9qc9kc+dGuXRKMX1FxRtthX8HSy1GqdlRSKjNmheupiv2L7WJlafSRQ9/Ioib7xA1OpBZ8Lg6JLc+3qPM4+eegrdmLvdp+cfgFu/E+iqK4+cEAzZMEbjsciQP91EWJHW/LtNT07Q1HNzqaj3BYOEaKuGE1uNsgBqQvVE00IGCknz+iHUT3Pi/qk394SYK+nB7DldCOdHryg1Xn29H0voqNVnqUT26/Sd1DvleUbV9t4q105PtB6XuYgikcDFmSCSGJO77A1kicEqETrkwS4PGESZn7A5UWcVpiKo2mwLciI75vppeo89CaotAV1V7szbVg11zeYdILQejqgs1skU2bQr2oqAyiZ98N3EE2iDMPCziGJ2UmqU6HnFv8ZtA/qvRhflAEJSP4jAUAu2uJ27hp42SSI43uJCLUCVmdlYzcENngJVz+UEbdfcA0z0H03YYPovpqS8J2SIFKoHoemafimG6m48/PdBD+byTcsCs5ROrf6ANMBs0uFyMx7m0JGX8wn+jM/zQREN38OL58j+xbonEIhug6ABd2
 hnfUdRhz
 sGNMbE1iNg4XHmps1caxKLdKjcoEo8/9xyaFWhv1+0pyrF0YWe/6wv2/UiK+wXZNIlrahzrIZ2ACkWNtDIxhbO0JBhYi2nS5XpuLahiT66VpZvyUWP6X8vukM8VghF1bIGQ+wl/LZrwxOyJbttAjW5552/5yyfceVXtkG0G33+9/lwNjQVRpk0/ggv6LuSVp6RuqxoP1IXFAK22KdBlLTkLcaL+yFFrMOFVYPjBBKyM7Gm+g4vz9iDcdZuVtVjMvFjVc4ypajZR1dsg4qTga7LNV8yJCg4/qFqWWqvlKxJZIudzKEx+r1VDEik4pzGgT9J+fpQz1ygl4jq1ByIrEIZmfFZ+lA1HajRpQOickKx6Z/srnonmAPPkmFZ1nDbC+SyKMApbZgjXHMncX1p3VbALQ3I7oJMZ1H/wvS0wdiMPQcyQvzS1hL7KYpoMb3ytEyM9MA2jiywiwgWuUAFlHBdA2RojEFLI6fLN0LCbGBrV0+XbLP4UNAdFSj4p8gZlR9NYrJkHZe9Zj223jfesk0JGRqdLB27huHXPoQ18NQx/i5YBpxcaByWgheu9x+4OPWIQSPo/IV/qoTvF/CrwrK3Z19qIBgGuVCZlLSXsvQW8jFi+FZVSvwRzbd0r7ZwXQLum5YRBlvoKPR4itcW0ycy6yEs4PX0PySjYxx0XsYyPE2hUic8LuUBix/ioV22KkcK24qU3QD4pEJQZl7mgwz43+nWwxtvzdzjPB1kr/2b+ZEiKKHVZ0XocAUi1K2wXLymCZcGZk4dExrZm3vAd/oKyykRySsYKpV46jX/iNZB3Tf5HJooLRJAhJ54lnWa+lUvZIPgbexYMO3qkm1bsGddrCFUBEmlaAaNltErhEsHVqAIQrnzy5y6s7O2+r3sQyTZP9ggHGUWm5c7B3DUBiMQa2VcDKN4z3K0BOxeVcL305zcusrEr8Tlx6g2TaneoNKxe/eMCIAQYPGI6c0EJX5KVerMeQK
 7GvCX8OE
 oX1yWmIjMSFlx0ZvlbqpF9RluaFPxNIqyORZfqx1sug5nossZAGMAznhwaJDyt5OEMWj2HTIdhboksUPtIcJDLq32th6flm1vupOcub6UcS2sQBqtSc2Q3VVWhZ0xRwZaH7pU8Nzi1OHIfWy2Hq8qeLnbj1Ww9iJUlrM4NIU62XLYvy1e1CYzdpPhFLJBsHqiNcH0rId/EF5NakV1CyMIY8Rl/HVJ2fZB8wf8NrzkkYHa6vUfjpbIAiYyXGrpZYrQGIeBmQCSb5VJvgM2CPPQvUNzjelK3VuETCstovJ7QAVo0HKEWxMyfgBXYXZjktNeTMiOZxt6vfR1zfkanQ2eDpRSCZlHzl5cpWT5YqSUTG3S+KTHrn88ltPPGpHbwWP1/2cdnOsQwJSZzGpwWLD6vr/7ju5G4bLQPODWbbt+fozR1NPPIE+VfgT4Bv/Dge1mlh3I3R/lik=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update file names that define ioctls and update the range of
ioctl function numbers that are used where they have changed.

[Since having multiple maintainers trying to merge these would
cause some conflicts, it would be more manageable for Jon to
take all of these through the docs-next tree.]

 [PATCH 01/12] docs: ioctl-number: update MM entries
 [PATCH 02/12] docs: ioctl-number: update sound entries
 [PATCH 03/12] docs: ioctl-number: update block entries
 [PATCH 04/12] docs: ioctl-number: update networking entries
 [PATCH 05/12] docs: ioctl-number: update video/fbdev entries
 [PATCH 06/12] docs: ioctl-number: update SCSI entries
 [PATCH 07/12] docs: ioctl-number: update MTD entries
 [PATCH 08/12] docs: ioctl-number: update USB entries
 [PATCH 09/12] docs: ioctl-number: update virtualization entries
 [PATCH 10/12] docs: ioctl-number: update FS entries
 [PATCH 11/12] docs: ioctl-number: update platform entries
 [PATCH 12/12] docs: ioctl-number: update DRM entries

 Documentation/userspace-api/ioctl/ioctl-number.rst |   91 ++++++++---
 1 file changed, 72 insertions(+), 19 deletions(-)

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: linux-mm@kvack.org
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: linux-sound@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: linux-bluetooth@vger.kernel.org
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Jason Wang <jasowangio@gmail.com>
Cc: David Heidelberg <david@ixit.cz>
Cc: oe-linux-nfc@lists.linux.dev
Cc: Chas Williams <3chas3@gmail.com>
Cc: linux-atm-general@lists.sourceforge.net
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Cc: Helge Deller <deller@gmx.de>
Cc: linux-fbdev@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: MPT-FusionLinux.pdl@broadcom.com
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: linux-mtd@lists.infradead.org
Cc: Neill Kapron <nkapron@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: xen-devel@lists.xenproject.org
Cc: Hans de Goede <hansg@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Cc: virtualization@lists.linux.dev
Cc: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Cc: Mike Marshall <hubcap@omnibond.com>
Cc: devel@lists.orangefs.org
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Chao Yu <chao@kernel.org>
Cc: linux-f2fs-devel@lists.sourceforge.net
Cc: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Cc: linux-rpi-kernel@lists.infradead.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: amd-gfx@lists.freedesktop.org
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: intel-gfx@lists.freedesktop.org
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: intel-xe@lists.freedesktop.org

