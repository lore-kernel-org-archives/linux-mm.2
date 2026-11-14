Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1086606A331
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=XDIhocjh
Received: by kanga.kvack.org (Postfix)
	id 267336B05CC; Sat, 14 Nov 2026 15:27:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F2CE6B05D1; Sat, 14 Nov 2026 15:27:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03ED76B05D4; Sat, 14 Nov 2026 15:27:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF05B6B05CC
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:27:30 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 452C1A7FB9
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:27:30 +0000 (UTC)
X-FDA: 85434859860.24.E579D28
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id AE677120009
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:27:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=XDIhocjh;
	spf=pass (imf29.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794688048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/GQ2kS4zUGO1VrRdCGc0i8jbBEMqqC1y2L0YsldwfFs=;
	b=2vJyWKIkMO/6z+HeHC9EmuUEMJhwy8Ddhb1Ve55NyfXHhv55RMjBcF94t6sW9z+LwmkhHq
	MyPc0NkjDn3ZXvXICFmjjXWJFPEvtKIqvmb9q5K0Yc4LFQ/ZJYQa+Ir1K2g/RXA0G07feP
	TOyKzN8rHTo1Tum7jpfgsPtaRvY800o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=XDIhocjh;
	spf=pass (imf29.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794688048;
	b=A06fW4+tU+5Ls5Ls1EVlBjCs8OwLCttjDHPKi61n80l5py+7T0wevP58k/DkOrRzF+QlZ4
	w71WQgTDKHQpJMBX1p87ijC4xmprz0Zu26hjyLfdCRuDsbJq4zmhGbH6YXyUNtaJBH56JG
	13rn19ajSB6iuQVYfTXyaUsGfP6nqiI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:
	To:From:Sender:Reply-To:Content-ID:Content-Description;
	bh=/GQ2kS4zUGO1VrRdCGc0i8jbBEMqqC1y2L0YsldwfFs=; b=XDIhocjhPJkOxDtRKRtKBhtH4K
	d5+pqDbw+uhdymgukoin8yZ+SIycM+3Zy0tlygo/Ahh9V2dUz8am7v5F+s+OiHgrg8Z6MoFGWEnEj
	F4En8Ab/mKUEIWPb+cNtmXyElhpAnx+TnO9Im2Eow2i+nqiNosKxRAi1SQbReU5LZrPynT4dcY8Lk
	Thib/6BgIqJzI+6K/y8KD4ybDW6vSBxsArbMvKkNi/HLSIt3390x02r1bfV35x51xAJlxCNHKoU7C
	Jcj7OJXmK4/hTJJRDAEHa7wka2ef1B/GfVa9DURHrADxvENRQDnmIT2OgPVAh7qGGcJ3nZksJ2bDP
	bS0oBuOg==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xSKLM-0000000Giga-33TB;
	Sat, 14 Nov 2026 20:27:26 +0000
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
Subject: [PATCH 12/12] docs: ioctl-number: update DRM entries
Date: Sat, 14 Nov 2026 12:26:50 -0800
Message-ID: <20261114202653.3113381-13-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261114202653.3113381-1-rdunlap@infradead.org>
References: <20261114202653.3113381-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: snunwba8eemqcr9g1e4nhfcthuknkq84
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: AE677120009
X-HE-Tag: 1794688048-889371
X-HE-Meta: U2FsdGVkX1/6z/OjLQXeBBzvn1lVBjzBmPnqo9ZPtnVu4ttjJD8/DgKpq+k1+Uv2b2Mj0A+IIVtX7TiLF+fcGX/jRSJX60qPiuV9SF69lG5+A3CjWFgrRUbkJSj8i6U8m6x/akrdloP0PDCADRZmRZLddohPieCTV5HOvfcIsXXNE8apoU1vx5aBwYAw/AJkXp7xf3zeHnGikItlGmmDOvissor0aaO4u0wCZxLa4PNPra+685atk7qNplQ3A4CNERC4bh/Ypnu8YYVA7lKM4kfoOLXBw413BP14JE8LO3SpQVXK1pcpQrs43sTOdq4DGIxYKNAtGjJ/bV4XOJTQaXRpKcsng05Xu2nwW1aXKQSHnqraIWXnaV4tjfVZ9lx2Xwvnt/nwk+41IDUi2HXE1429LGVzxsZbShHypyhU4uBk3XGRQhUCThM0Libuw/+1jcIDFcgw/IEKbyXoWKiOQBha51JaMEFD7If+d8P64htqWSh6AfmnWCkuF+3otYIyrN2w7KiHb0/qjA/o4xDWW+JhCMME+484VU1E48+nhl/1i19rCNLklWeeT9q4woutgY9nAIsMX4DSZpfjVi4QiDQ737/uLfm4hsDJvHIWpmYDsImEASRlBrtwBj429dhnu4ElNuzhjMOlSs+/rKQwwWyiaMkYfFZ4CmauhJC499lC5RQuFjpfhrZKbC3W6v/rWD/0NJTg3YQrI0RkNVbxu3jlNBIm/yXMKQKFY2HRUDpvYyv7jqaZ5ypH5ukd2aAl7DkgJktq6PFPKFDjjlsMfLt5fsHNto8ESK0u1kj9MT3AFEoNR1eG0m4rLMFL4+nooqbhnMQKfXrwuJfcH6FSECPjFLzoozgBIujt5uF/UT9r9NYANC8njRdKgnK+7ecxK9rAL/t6NfQJajmgvEcVyAJtnu2UPgcJ55vfEtQa2+W9F5SAxDZInYqaI5BBy5HkFU4GSewCv8e0dRbuBiB
 S5ns9/jH
 2H2ZKO7SjDLZmwLuA9qbRGy0mqph6qD084EVZ4WLDzkXAk3tiMGPk0m9A8NT3kBKbryuiEAVF242JmNKYwIvSSaCLq1Pv0JM0N9UhwQtn+9AWzbnbsMd3mKLkpGGSSwnvEiQ0iMgy7mwOUzW92jr6mC/2GHf7xnsVh0pVmEzuIw+nJOkZ2nv2qfYnSrM8Bd/uVvDK+YDXltzkby6FkqwNbVc/k8ZZnIoqs46NOIzzH40937iE7bT5VbZ2tdV58pyHJa8yIhd/mNS+oCXlscl/WYeLvajzlPR6gCB+qnoKykJ7qrt/ipjCBiy/qSk4/fO/KG2OR/If6AfIdONoAK/vBtiP/lVn6E+bO4jL8Px9TgXLeKf/3LXaAwIar9Z7Q8W4koQDC0vJiUNfn5Rq9GCAnHNcoGoTscUPCDAfdixgYEZqPQo3FWlw7+kIBP0WcKexm2ARw8kwkDyPHg3I0DUTS/GkoPRxfjHAheD2RiuG3ezUJOIfFeIvigDEA6XlTnz7rlYpd3BoJkdqA+dAH/erxwNguiIS7S5ElWwHmye+mUgFzyebMkG9Lg3ri6Xu9+JWbcSduZ+IjWp/jDVmdu4Ierv2D6RSSDaabSiI7P/2E+t8RMjl7p6VpT6jkWd2UpqwqTblc+RYsEWstezRw3R29uTa10I3eV9eERtRYZBhNgTBQrYVEJD7b73LsQZX6/ig0tW5Tf62pVMVw4hir5FqZ+DDR0hfM4b5zy9AUxpcdXySZFiAdWoQefMAHAGVxHWuuDPop4eEhfJPU5vZzbTnhHBz46eW/CrCYsAOL1O2p/Sm3NmYfS9cjSAyBgQ4dx9QDVrp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update the list of files where DRM ioctls are defined.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
[Since having multiple maintainers trying to merge these would
cause some conflicts, it would be more manageable for Jon to
take all of these through the docs-next tree.]

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
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

 Documentation/userspace-api/ioctl/ioctl-number.rst |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- linux-next-20261113.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261113/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -98,6 +98,7 @@ Code  Seq#    Include File
 0x1b  all                                                              InfiniBand Subsystem
                                                                        <http://infiniband.sourceforge.net/>
 0x20  all    drivers/cdrom/cm206.h
+0x20  00-01  drivers/gpu/drm/amd/amdgpu/amdgpu_umr.h
 0x22  all    scsi/sg.h
 0x3E  00-0F  linux/counter.h                                           <mailto:linux-iio@vger.kernel.org>
 '!'   00-1F  uapi/linux/seccomp.h
@@ -269,7 +270,7 @@ Code  Seq#    Include File
 'c'   08     drivers/scsi/ch.c                                         conflict!
 'c'   80-9F  arch/s390/include/asm/chsc.h                              conflict!
 'c'   A0-AF  arch/x86/include/asm/msr.h conflict!
-'d'   00-FF  linux/char/drm/drm.h                                      conflict!
+'d'   00-FF  drm/drm.h                                                 conflict!
 'd'   02-40  pcmcia/ds.h                                               conflict!
 'd'   F0-FF  linux/digi1.h
 'e'   all    linux/digi1.h                                             conflict!
@@ -293,6 +294,8 @@ Code  Seq#    Include File
                                                                        <mailto:zapman@interlan.net>
 'h'   00-1F  linux/hpet.h                                              conflict!
 'h'   80-8F  fs/hfsplus/ioctl.c
+'i'   00-02  drm/i915_drm.h
+'i'   00-04  drm/xe_drm.h
 'i'   00-3F  linux/i2o-dev.h                                           conflict!
 'i'   0B-1F  linux/ipmi.h                                              conflict!
 'i'   80-8F  linux/i8k.h

