Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55611606A6B9
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 06:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=lMU7sc05
Received: by kanga.kvack.org (Postfix)
	id 8BF3E6B090C; Wed, 25 Nov 2026 01:14:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 870626B090E; Wed, 25 Nov 2026 01:14:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E9446B090F; Wed, 25 Nov 2026 01:14:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B5CE6B090C
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 01:14:07 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A0681120D5A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:14:06 +0000 (UTC)
X-FDA: 85472626092.21.6E5EB98
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id D1A3040009
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:14:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=lMU7sc05;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf27.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795587244;
	b=1DtTif//NC97T2pC7rQhUG5kbRsnszw0lRDKjfrioQ6Py0b03+jeu9iXWbQT1ZDELAcaW4
	szzeAoOsjCtEQrGdlLNJg7oAF73ZXmqUfCOoN6mrQckDFhxfciN+vU/U++XvVvJGIZ+iDR
	EIyjMnKjGMBd3eTyFI7VlsVgDGtSYBs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795587244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I36+luioMxphcj4OMMZSrZawKV9cLl7mvSqlHqLLmOs=;
	b=DAHQ0UpmxYqwzVlwvRUcQUVHqLlXV7uboeZreeIVwxRM3NtJ6H1rVHtM4e3y1TL3DE3yiK
	YW5WQ5ZWQSfYiq6wnIy5t1AEshfJez7ylPSp2ONBRj0Q9Zo7cKbRxzc2zltnQVOdcLaPVK
	Vx2lklTZD38RcOGlkeblombxqCf2jWY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=lMU7sc05;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf27.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=I36+luioMxphcj4OMMZSrZawKV9cLl7mvSqlHqLLmOs=; b=lMU7sc05PHTHTDpjgfQ4+tOxDL
	sjZvBvUSy+dTfDP8/Bwrjfk8D1jgsOUxBmCQw6J4Hp+fAZ1yTetgxo3BJiWnJWAvq88CIdPoSU4nJ
	24WuW9+Yh6B+xJIljJSUDfQ0fXNcjlFoGyEP86g1zJKlyFb2NjyMVQRoe+4SF9IpUcY8JljvSRGuL
	dcdVm+/NgDHvBePy2O4XyBQKSsDAi7I5l5vLW+xi6Zkcr2KT9NylBd9OHM26JOld+auO0wuRafqZO
	trpQ7Oc+xMGeGta39wcjkZzgQZ1ju5bxXp/r1uVZane+SOnSLYYJkbPlBgmXAiU/nQWBXPfOEnP0q
	6iidIJ5w==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xW6GY-00000008Wvh-1Dwn;
	Wed, 25 Nov 2026 06:14:02 +0000
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
Subject: [PATCH v3 08/12] docs: ioctl-number: update USB entries
Date: Tue, 24 Nov 2026 22:13:35 -0800
Message-ID: <20261125061340.3402300-9-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125061340.3402300-1-rdunlap@infradead.org>
References: <20261125061340.3402300-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yp7uar97iqwurw7qq31cpf7c895ein8a
X-Rspamd-Queue-Id: D1A3040009
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795587244-780560
X-HE-Meta: U2FsdGVkX1/DFGdCevPhF8StbdgBUzVe4FS93Z9zx/YNqLI1+GKKZnFb+GgmotkIJibe/nLjOwOcstdoTpBnE83wHEwsY9S64/L8oNQuDYHtF5LDxSGiRAzDjZESfUfJDYr7CcYDBvb8a21mcutr5eG3KYjFQlCcrYjcB0jvItyZgc74vSynWWb+KMrOtGxHpvM0+IdrZcxuikS6pjmCUyFOa5fR+VfS3F6qBgaZVFtanv73u3ZBy/f8MiJFjxOYclbib0+MaXOhVd42sLolQbunt9KGh/l8CWjwuHt74KuT0WHMR4BWlwg3lMARZm3IAyfWouGw5J9xi8xSQToNBa9+wg+hs/XyLr+yzXGYKnOYvbq83xij1wrtvf9md9YSkCus6PfSs6i6pMyX1YtztavqevvUquL1nOmHFdKeGcap+SpmYyA8iSt1auQKqVjYust1CteKGr/N/5hIoj3R1Khll7s8lq9D5qBEsC/L52DUY5mGWsZPyP1IinidMn3ZPVTGC0kbET8h74dAYGhBxRRaLKzHgi1tdD03Q5U38RDDU5IRlC58y3Rii946975YAUQfyYn4qP4P8FanQ8vOhmftlN5nakZA7UnoRgSmhHXMm0LFQ0rVTsJ1M/6wXrgX2i5qW8XyA8QGvFRm/xzfUNpCXGg6RK415nwNZz0X+B306rtfAcdV2rs7yubRKwSiNoUYMpEZOQoDMd8A5J9x0jg9gRXNJEkmsww7VeP4cW13nrX3Uj9ZIZKg4JtWLGk9AtqPLK+mInhcWKz11Pw1hFSLTEMvICNdofOO7dlp5t1VOOluucjPrEJOKSKKxw3tKaQZu1LmLslepO1nFQLQHOzYVgyQGZYpAEQEcDH2Njg4dTaOKuLkyFgB24QLKlQwzG5i15waGdp6ox1+UI80tyXivhZR9jXodN0ZKU1f0ePngvHlKrsGfJhLoE17zCI/l/YDGQyJf8kZucxie89
 87qpf+Yt
 PfAxHaIgZRQAaNyWSGaAPk1dDFM3lDlYG9CAm5+dCQ3buxiYg00VtkKbEUHJzgfvDoSvZKHSWvOfIvj75nwVsjwyHY46N7jd1Ac3UrZFqSL6Dh6UlGoXilu3OfZ+Ll9tsTYRHW7deWPsGxEy+sBl5g24C3M1aArZctJmYbjl98BdpFoVg8VAqVfo1DgWsrc9vKKsaHGqDtuKUZhcStncQmhXoiwd5xTue0jzUjh3sgL5KT8bNmxCcOOIyiUqlI5sOi3PqG0SHMSuC6hnG7ec2+2TpMYOUV6/UaIE7q4UgqhOgX9ieEaSxUNVx4leMXZLFDFPGRdFdeubtMQgvlrJ/EyFMQkLBdeNLlG+RIQK3XZ30/07Y9bGYAuB68jHr3LbXKQiVQdwProU7Je91kqZgDwCeB5XkjnTk+t7/CaF2feVSNhtM3QFSSCJUM/HgzYiuP0dKb6R6C8e+0NLk6JRslo2AE/t7VYJsou/ZCfz25eKICEoBzPJCIJz/wyQdwgQehBwhYaQyW0CNVTeHKgHWijU7IvallS5YKy+uj6NhncoSpIP+DJwWLsjFj8mXG3JX1Fe/SJ563sLn+lDbg/bjMbNnmLso+UCOwK+hu5oEr8LNBgR5GhZOozpkSuQxZrSB3aLC/g2HzLqL6CLId48fxOAX22VtOHmXn35v7gbP6Ska/rw8P+U5hWLGExRRRNZvIUAWk+Y/1zhyn1ustEBZCofWzNuUg2vRt12VEfghTnw6PuDyPLoqJfOlZxoc/ii7ShXrldTLq3JTOI7VqeRg4QfY2GfX0Sblr8DqeE9QNO2VAntSxG9VHGE9UdBwPbBGE4mgt6JFm7GEBro/hLio8MSAh2XrAA8slmDJjftipUKEK2jdM8+EOjwGQAtnaJ/V+KwzDA9E39Oxausni8/t8gdUIUvFt9nKekRlnoNXpRdpD3WvmwIYGtrUTs6uCNXEqbyu1W/CGd/80U76vL7vym9/Ndd+
 BEJYMWWQ
 L3oeZ72afL4qqohdH8KGWySh5hqxqNeTHOkQgQflsg2axdaXS2EtxuzWMg2mOWBz6y+aCgsDb/yzZOr79pIhGvBScfGTHSML
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update the list of files where USB ioctls are defined.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
v2: no change
v3: rebase

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

--- linux-next-20261123.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261123/Documentation/userspace-api/ioctl/ioctl-number.rst
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

