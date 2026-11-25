Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20EDC606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 06:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=OQ10UQlo
Received: by kanga.kvack.org (Postfix)
	id 2A6326B0912; Wed, 25 Nov 2026 01:14:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27C9E6B0913; Wed, 25 Nov 2026 01:14:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 144426B0914; Wed, 25 Nov 2026 01:14:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C56DA6B0912
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 01:14:14 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4CDDF40E27
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:14:14 +0000 (UTC)
X-FDA: 85472626428.12.3C3F2F9
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9CA9AC0003
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:14:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=OQ10UQlo;
	spf=pass (imf22.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795587252;
	b=Iy0dr0PdHzBZUOu6qeNbXrS275fME1dqZs8XZy3+m+H5dh1pd5rffPYRsngIeAQsZ8m9Pf
	1FScJVdhs1cv3kBapD9dCfP+SP28atlp9xCfWx8IeADKqsnUzrfiRraiWF+7rYi+zh6+gX
	xMQa4/OBuNApXTuUcG6dTHrWDvIRCE4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795587252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nH1JDKUpxZKr2E7xywv7sSC/lG5A4nxPxWDHndTmH+U=;
	b=DLAXADoy2fG5oxnph9lv3sqLaJm1giuebT3rwZqWtXc5EkxkSFSzOuVhV3Umul4lz3AGnI
	bK8tD1JO7fl6PJPtmr7b16l91p7KLxa60wRkEjDuwJinPzwUp7XRBxY1tX6b1w9IpcrqIt
	QDA42/RbbOuepO+HYpm2Txz0vGj2Yg4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=OQ10UQlo;
	spf=pass (imf22.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:
	To:From:Sender:Reply-To:Content-ID:Content-Description;
	bh=nH1JDKUpxZKr2E7xywv7sSC/lG5A4nxPxWDHndTmH+U=; b=OQ10UQlojOOElMejsET63HIbzZ
	3DHzvbtYIGqi3qtZVmlnOiTGbSwjJaXCrsDgpHInm2eUGr8Xc79IeDQYDrtJVitNB0FwJZCPO4B8q
	+iOBeVWlbGzBejGX44u6FBx6jMlOzwnzs0/RPybD92JWe+ZEhd2F0VZXPfoSXXKlqmHkpJj3BYeff
	PI7xG81lPzaQFyumhKdnS4tNxkr8IW9Cdx3c7fbkK4m5X/Zh5Rgxrc0VYPw9ZDhRuFltHqM60uFWP
	hZDBs8jxgJq594XvPuA6d95qyJlYfVavjeq76w/EreE8GdBtyeqVTX0Sp6D1XhKyU0S94iu4liry5
	Ut1LqIcw==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xW6Gh-00000008Wvh-0GYM;
	Wed, 25 Nov 2026 06:14:11 +0000
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
Subject: [PATCH v3 12/12] docs: ioctl-number: update DRM entries
Date: Tue, 24 Nov 2026 22:13:39 -0800
Message-ID: <20261125061340.3402300-13-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125061340.3402300-1-rdunlap@infradead.org>
References: <20261125061340.3402300-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x6jf7a59tdo347bmu3gxupcd4r4g6b5s
X-Rspam-User:
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9CA9AC0003
X-HE-Tag: 1795587252-107696
X-HE-Meta: U2FsdGVkX1/o50Q82F2Jm1GnRYQUm1g7XLDoMk6cb0dOxMfRhkOUcxUDR5fN6Y+f1ysR3bg+SK2cCrxUKxQ68RzFVhXt5WoOR5QeH6iz7f9u8a+WG8EhICq9fopsAaFE8UbhwkZ2xdPb7KoAWjaIFFSGMygsMTnn73Och+NMuqOcMgGBkMZrPwUZV/KBTl2nrgGAbb98GU/JYTqU60wbZXXExZUn5FnkA8uXif+V+69xmp1P+yHRSIwDVd4kCQ6q6T7W0MtAXGNJWHkwV9eLg1JZO0f/vsP/HVIQkdP0fjQk8q2OEJZnZPw7Dbp1ZpWIKWFeUBtnDxOW2/xjFN4aLRNe8CgYU6+HBtxwaI3h6TnEjzZMRbLZ3uLajLy9ossnSOp2M0BpqKyGNOMLq9GRqXWVOqVrOuDeEm7F3rUr2vyZ8LdhuBuTEfpfztCRd30sjByVROz9XmmuarbLXSMqD19uTZeePAoRyEufCpmGvctHIpEVTs+/98EUNs7s2lICKyNERc/1Nwgkbm2aqcLff5kVx0TX0YKhPNe+9/iwiD6R2lBKAWQ9zMv+F2VtJxmonSxqvU+qfsDqbS2yM7KZYAp7xVVbKFxpN4LUe/Zz0koTtiz4lJOa7WoUAGQ0R2gMmOTxNITyapv9v0YWylDq4YRvsgOdIaGb+R00zKtMDkHghPOA8SwygjO/B1J/uXpK/vCwUUY0BBz5l/GNMdXCu0/phRPAsv2U2EjUmj+56DuJv6+oAH+pju9db5oTv1v3oM5SYM6DKJaAl9Vx+BQPZqf1I7MaoifSWfSIY9DcF7sIpEr0eQ6n562EwAetO3JfWTBdwBD3FdS3YnBgnYV6OMEcdYO1vHYHcDOtou0Z9sk/R45VNZ69nIqrtOvlWwT5pkQfLCRJ2E011pApTL8IhdLM1cQD8CeRpqJ+MeY2ogqcwZK4fJBYeqR1b+8jQMMJdoNt0nOPXB5pv+hYLAf
 Swx13P+M
 HBGX6DZhkbKiGFsVRUxKDWoswoAFeEDdiB6LSzvpBRT57bUB88+0ge0hXMl1bS0j9ZSePc0i972KKzW4m9pY09A6oWkv/t50WyOHuVXIBaXaD4MVOXxOPOzhw288CH0tD5eG5ng7cSxt8NN5MpZhmcM8Zn/ARrjv//6flUFygmplKa7mVhohTg1QLoN149s3pNkUO/Wzb36ixrFQO/Wxcn4DnQrN7ilVGGTlSUHFVa1NXK9dZmtjeqKDO74rLahKYJdPXnbHVUf8lc4gXikh0y49U2mT8vKE6VxIvvOyo4KdDknJNG7BSegp0VqlbPJ0JBQog2W+Yzvpg0G/yRbfg5LxABB2JRGrfNfFA9yjgnvFjLJsaMmX2XIb40L13BZkR7GBN9+7dVJSLGJfvMRBuAx3q8e3HEd8bkaEToxbLglhd7YmC9DEA952swk+/dB7o78tCbiPTLsUqF+PNW9gaBu8jG5s51UOqtu5R0LpUGAMRtr0c41jSd7PJdU783Z9omZWMFtn2Tp/CcosaUKibYeGPkrQCjgvch4wswvjznkFC95bP0TBxISweTJ1ZZkMG+MGsdU5ZXib08pWL8gg84ucj1gxV4ol5pRP5hxMssyuavM0icDCtOWDS0mCKo+u/BzGowNga5Z2gIF/t5wPI/kw/HC0wqoKubZJUqtqlMaMjfrGeibDTUf+t9Bwas5XKkes5kFMRkXl7O1tR6L1VssrLGd0N8vhQb52ErbJv74qsD4aa2LNuSqTkFSVP+SfBz7GYW9Ov8W1dHRxyy6VnBR7jz686IZImHMRGsBoFXoSy3eCdkH5xgUlDoD5xxai3RpGz/Ygioz+aI+PR5c1b4cdanjDym5lkn2letMWo04QeESlaalAA2JRqdSYHocJ+H5y3in1WhSc0JMGMzqlNWEygoWXVeTTiyhRC07F9fMWq3gldImjQ+oH50YLJvQX8rKSlSyWak0SEefeDF614pd48IPYm
 JRy6EXht
 NXkzme2j/4H9San/C7e4QKbrUuu+UFm7YNJaMaBWPluOM90+0M4TZGHgxHRrtUuzP3AeqqSZ+yyPwFmI8Xj3Syun7lsftMV5BBoeTumHjFF0VDtbfeUPu/8jwDW5Dqqmq11o+I9sc4ECevkOd66IQt6hzQKjVcNMuWROLPp9Ii00OOYl/mQr3jxBijLJ2jRA9DRGaHqu/6Ft7OMiiIOWXbI7GQc21OnRaKhaINywVV0=
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
v2: no change
v3: rebase

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

--- linux-next-20261123.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261123/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -98,6 +98,7 @@ Code  Seq#    Include File
 0x1b  all                                                              InfiniBand Subsystem
                                                                        <http://infiniband.sourceforge.net/>
 0x20  all    drivers/cdrom/cm206.h
+0x20  00-01  drivers/gpu/drm/amd/amdgpu/amdgpu_umr.h
 0x22  all    scsi/sg.h
 0x3E  00-0F  linux/counter.h                                           <mailto:linux-iio@vger.kernel.org>
 '!'   00-1F  uapi/linux/seccomp.h
@@ -268,7 +269,7 @@ Code  Seq#    Include File
 'c'   08     drivers/scsi/ch.c                                         conflict!
 'c'   80-9F  arch/s390/include/asm/chsc.h                              conflict!
 'c'   A0-AF  arch/x86/include/asm/msr.h conflict!
-'d'   00-FF  linux/char/drm/drm.h                                      conflict!
+'d'   00-FF  drm/drm.h                                                 conflict!
 'd'   02-40  pcmcia/ds.h                                               conflict!
 'd'   F0-FF  linux/digi1.h
 'e'   all    linux/digi1.h                                             conflict!
@@ -292,6 +293,8 @@ Code  Seq#    Include File
                                                                        <mailto:zapman@interlan.net>
 'h'   00-1F  linux/hpet.h                                              conflict!
 'h'   80-8F  fs/hfsplus/ioctl.c
+'i'   00-02  drm/i915_drm.h
+'i'   00-04  drm/xe_drm.h
 'i'   00-3F  linux/i2o-dev.h                                           conflict!
 'i'   0B-1F  linux/ipmi.h                                              conflict!
 'i'   80-8F  linux/i8k.h

