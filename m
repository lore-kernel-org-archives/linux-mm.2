Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AE00606A326
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 05:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=DGrnyfoW
Received: by kanga.kvack.org (Postfix)
	id C67496B05C4; Thu, 19 Nov 2026 00:35:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC3536B05C5; Thu, 19 Nov 2026 00:35:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3E9A6B05C6; Thu, 19 Nov 2026 00:35:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F8196B05C4
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 00:35:52 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D6442A8722
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:35:51 +0000 (UTC)
X-FDA: 85450756902.03.F0B2454
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5473BC0003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:35:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=DGrnyfoW;
	spf=pass (imf10.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795066550;
	b=yaUORI+1RaY4+Pn3HMOD6E7sCX9rUvJsCoTjmPcI+YYdKoYuSuq+q9zmP/3O1qJw1z05Go
	O8c4bweRIVpPrJHHgjnNHYDgvQKngNbtg/poRvL3fK4lf6zT77XuALLlrYRQG+2qRVcqnj
	4j/zH/WY9XYDodD/e1ZSnNj0mrfZN4k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=DGrnyfoW;
	spf=pass (imf10.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795066550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iUfRRM/uSWL5Pu2WYkuG9ZMjaMjQfW5Ts9TmnI1Vtsg=;
	b=68Gn7OjBg/ZijDe1m0F3HdCqTPqzM2Fi8+vg+x5pO7mlkfMDRFf7PEHCNnKTlfunxcKpQv
	Djc0/syuZnZ3n+fvHD91E/pCxDtz8poprG6bT8ew/VWKZGcydkBr+58JsPLc0AAyvswS44
	6F5czy5yE+xMwgPg0Qvr+lnNtiXqug8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=iUfRRM/uSWL5Pu2WYkuG9ZMjaMjQfW5Ts9TmnI1Vtsg=; b=DGrnyfoWAgDY4gTArjK85mpfLP
	YUa39SWVXYFn/eK72WXlCXA9uuRyagIyIF1woWS4EdttvevIcGfjAAhDfNPyAIOfoJJ+XfJxm4mGT
	bVkFVA7u20Klegz+Ue9YMX8fmqu38qLzw2l6Mvo1BQyhyJJNtM+c9MxognTzcG7V8vEGldl3RnhKr
	KabGWOjeEC+yc7jJcccxprvCsyDQXoRtyIJIBftIP+C4EOe7n7gE7b/kw0/j0BAuO6DMIZSJhfRCO
	H9dGPqwbToDijcg/PKpXyVcYExVa/obX176QmbjEtCpmdJ0iCHZ5xvENNH0DXE2DbvWCAV55csStZ
	hDSDSL3g==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTuoG-0000000Aufu-2x6D;
	Thu, 19 Nov 2026 05:35:48 +0000
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
Subject: [PATCH v2 11/12] docs: ioctl-number: update platform entries
Date: Wed, 18 Nov 2026 21:35:12 -0800
Message-ID: <20261119053514.255348-12-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261119053514.255348-1-rdunlap@infradead.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5473BC0003
X-Stat-Signature: tkihrbhuemqf9az76qc43u5i7ywe836i
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1795066550-459629
X-HE-Meta: U2FsdGVkX1/JiAkfbNNlkVsqpmr0mcPOH9PEfvAEweZWKsIwYbKB19tlBAsOm21yi5VWxVUcYfqhlurPXJTmkoIK8JZuJSTSniIMVhtUnZ9G37LDG+g/JAP+5cpwMGHuo+C2pq8OJb7MkjmlRUIbLWnRisqPpoFEXtgLObOhPS+IeCdCa8NhYCqm+mAkB0KulsDzku26HGtzI+/LrKRS1rc/952rvsMRZvLB0BjCJHs30gyrepb2gD0KAlhb4PImatbukT4fOoOhpIV5qxY9LM34we76A9747pLhCg5kgOidjzKD/BtrxCh5SsHFEhlUUtdcdxvCLq33JzLec9W1YCYP4IenfFlgVEvM0r1hVMjolOAYcvYsHo4MhqPE+6Uys4Ev8YIAwu+C4vPwiSqvz7vujsImutFBisd6N+mGX/Vzoe/ImwJiM5w4ojJpKkTqsJ9SI66Fy7Rp3yPZkWgjx6thrvoTXkUHUYn9LRP/6ZMK2OJy3Eend+BAJcRsNe+YU3AZiQe4rjr2QyV8eBc6XAnFfUfydMzc/WhvmU2sqJozxOMfGClwKrgNNVyl2UddN6ZTNJJkK0j9snUHhl4qtf+xjdwig4tyr4mN7qcHbVN0PKrThtv9eBKTgfM9FevTEhEOgDWJQcDoMkelP4+U1BFYr1SIH8IPVI8RxvF7Iff6C74HTWDQBiDVyESMvAZbakEhPCK9rbGpf5NObpP1YJj/K7UUQR1UO9cKC5j4ITPoMtZYT8bLf/SGh6jQLmdy8/Kcx0YE1oh3FUVXBrvVwcIUvyqPI4QkCx7nVU4KeAS/RU+MhXSkLESgMbJMw5Ge2S370VdTQ0N++w5MFCxL3EgAkN/FATfMi6Ydd/uNCzCdcfZVXI6Fn8lqhFLz36PqXB0PQQIk4GjO3OM6rEtCFQkBgsaF4w+9xF/fcAK/hr+YrxXdl0AhlZxpH1ho43/wnpNGM4aFmC8vnQ02Jdn
 dBTSyrkp
 tw8kZvHTRDwxQQXHj1lQ0EOWGL1aYov3h02Cwfaq56ovOy1EV1o39nmZZKhgQn/8Q/40F41ZNgeDF0+hxb1D8Erl4vCYMw5SH5Qa/UevD4uQtFCpkhDzNgi/YcAnHED0vXcTET+5QGDpZs5fCMdh7YydgxziZEidu9+MUwrB5+CnuGOW3tMrCGitiqQdRfIVIXFKmWUyfLLk+NtH/vRvw6J2OX/CWtAW+li1bK8ZtqsAzR+ZiHlnEQbftcTF5ohoh9wGGhBdx7tnNViAYqUoaDQTKFmdStaDgzPrQiBPfDyJ1xCVhgNxJ4aJOAR0zjcZDCoC0pz84JL0DxOQnpVrPHJ0tFHfafVEpWl8r2Jc3if0UlNCMck3QViZa6AtSuwnekgcQE1WR1sRlHAIpJkaDLOq/K01dz3jnLfY0Xz9K0htlb8ZBRCzKgYL4i43Zdyt1daCpHDRYnTCniFxtLXQEcww754J4v2vPyY776N3QudZa6Mu29N11PzwxkV94ZBn/+jWaZF1PI/9nVfkjuHdwDom9RZVbFTOokGhdqkbiyAP0qli3gInrxgrXoMX/uMgkJ1V3EiCaP5Djv+Da/RBVpz6yj0MfBDeBItW8Y7js+BG/cS/fTqPhgF9faNMwif6pu3hFu9R84veHSuE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update the list of platform/ files where ioctls are defined and update
the ranges of function numbers that are used.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
v2: no change

[Since having multiple maintainers trying to merge these would
cause some conflicts, it would be more manageable for Jon to
take all of these through the docs-next tree.]

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: Benson Leung <bleung@chromium.org>

 Documentation/userspace-api/ioctl/ioctl-number.rst |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20261116.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261116/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -434,6 +434,7 @@ Code  Seq#    Include File
 0xBA  00-0F  uapi/linux/liveupdate.h                                   Pasha Tatashin
                                                                        <mailto:pasha.tatashin@soleen.com>
 0xC0  00-0F  linux/usb/iowarrior.h
+0xC4  00-1F  platform/raspberrypi/vchiq-interface/vchiq_ioctl.h
 0xCA  00-0F  uapi/misc/cxl.h                                           Dead since 6.15
 0xCA  10-2F  uapi/misc/ocxl.h
 0xCA  80-BF  uapi/scsi/cxlflash_ioctl.h                                Dead since 6.15
@@ -446,7 +447,7 @@ Code  Seq#    Include File
 0xDD  00-3F                                                            ZFCP device driver see drivers/s390/scsi/
                                                                        <mailto:aherrman@de.ibm.com>
 0xE5  00-3F  linux/fuse.h
-0xEC  00-01  linux/platform_data/cros_ec_chardev.h                     ChromeOS EC driver
+0xEC  00-02  linux/platform_data/cros_ec_chardev.h                     ChromeOS EC driver
 0xEE  00-09  uapi/linux/pfrut.h                                        Platform Firmware Runtime Update and Telemetry
 0xEF  00-0F  uapi/linux/ntfs.h                                         NTFS
 0xF3  00-3F  drivers/usb/misc/sisusbvga/sisusb.h                       sisfb

