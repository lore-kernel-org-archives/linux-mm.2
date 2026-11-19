Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8084260A6F62
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 05:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=tZNGbQMb
Received: by kanga.kvack.org (Postfix)
	id 6E26E6B05B4; Thu, 19 Nov 2026 00:35:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66C556B05B7; Thu, 19 Nov 2026 00:35:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5336C6B05B8; Thu, 19 Nov 2026 00:35:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 13B4E6B05B4
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 00:35:29 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8596640925
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:35:28 +0000 (UTC)
X-FDA: 85450755936.14.1F4E8AF
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf25.hostedemail.com (Postfix) with ESMTP id 62329A0008
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:35:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=tZNGbQMb;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf25.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795066527;
	b=I/QkCHtuP6vcAKpZ3skhQaFGbctE3PAslqNxmAhEdYhkYqNT7m9TWVKK+NYpNVP/dfqZmi
	9T3+ubRaWnPSMv/0eXgiAtrmSllfZ2pu2wL4RsJfSXm7rZzoLNRvDcOrapV8LbfAESF22c
	8KheRwuHays6Wpri4IDPwsurPfCtctQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795066527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z46ZwabXBcpTEJRysA4syBAZyQggGPY6SIVcMl/gSzA=;
	b=NeNNewqW/PuUiOSFiG8iFxL2v7jRWxgnYisuMFP6QrlL1+uTmEh2PkZsfsuDlTsW4c18Vt
	ccCAxJPagebqGnPwtESLXWs6h4oYBfeSgBf0jQZA4GOKtGbApJ4dglYFLX4L/r1lhFVEKn
	dH2p5yKSx1I4fNAkP4jixseFnd7z3SE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=tZNGbQMb;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf25.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=z46ZwabXBcpTEJRysA4syBAZyQggGPY6SIVcMl/gSzA=; b=tZNGbQMbkEBB3qnsfmrI0ak97e
	GXxh5zYLcHrA7zzJrOQPdhV8uybDVtFAWYTrP+dt/z9kZiD41YJ2wTmXVlB8OYrmzf5wEwT37Km6a
	bsmU2r2a+szwKja0pzLZGHDqbW+LwePYyxWY28VlKJW4IkKj5u6oq7VCuB7i2yoEQ6coDe9GcyFby
	gmUkrTGRPw16swI5ikzHGUIbD/DQdgrEEfISwS/y2TJ9bAeOWAGvRZM46laKYkr4+h5q8QUSFOd1e
	FNUYp/NsoT++jUBOGEPDm/c59sWmUx3tgkmaRELHsSyXx62CAagtXJ2Elyvg7quNk77tut/ToOd3p
	hQQjF0qQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTunq-0000000Aufu-1tOB;
	Thu, 19 Nov 2026 05:35:22 +0000
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
Subject: [PATCH v2 01/12] docs: ioctl-number: update MM entries
Date: Wed, 18 Nov 2026 21:35:02 -0800
Message-ID: <20261119053514.255348-2-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261119053514.255348-1-rdunlap@infradead.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam07
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 62329A0008
X-Stat-Signature: 345zh5rjg7re7amio1nb4r949hkwr54o
X-HE-Tag: 1795066526-722735
X-HE-Meta: U2FsdGVkX1+VoUQG77kYRq108uWhDAZc19TTuIHXPl+hseAaiFeSKB3nzC33IoCO11lwKjfII0PJ5+qi3ejAX6QsByyHpAw9T/fVr2hKFzoSeuWQb2a2CWOnLIjHUR30y1+bBQFrNHm9F/FLkeftDHXp/XgcIS5CTjJPA8a80CaA3WZWvQ/9vou342GW0722zt4r7iLIyMReGpMK9f/mZwgOzFimbQ1QAiy4Cg6kBulOGYWjB2RaLnZlXZKhtigWQ/2DaHMae4FeJtFIgrqDXFzaBVwn9Y0acNHQ8GmrjATqywaVcMk4SDn+SQw1htHXqiM45OixUP8oBJX12DGcdCYx/DJTjN+nzexIWEQMj0cQNmRykDC/W31X2IQNS/hgJ5J5GekMxyZoGOp+P1+rfsCRkJX9D8//+1p/YY3R67qWdUxLqXi5JDxRFcGZhJrlmGAUO+gpgkfpIf+QMPgbmRNUGgrfIjCFoo8ZTCcBq2o7gAEd9mhf0MArENX79ZUI3Jeix7fox2IMbgRNrgw1fLf0CEYKDspgXq6vq3b36uIET+7NeAkjDHyh72KodWGXgpyYDEcaACjHExVvWEJsWXVG2COd10vdNANS9kYLPCahYWSFOKO62JWRrTonJXzoLjMmZufgMVIihz5GijMxQw0B6qIyXNBM/0GGVb69rrsRfYCbFi4+ew13ZP+gHCLxRv/lJ7jb6HvpOhh0occGtifC3sTjYs4d46T7m7ZINFqzI3D5sfsxZsgr29cID5Rtgd+d45/kG8kaLQlpIZRlnSJMdBGtCAYclS+fQJcp4fPwNmNSUBU15B0T4dVHIFD5HVuUSn+WFiXB02k9x6HiJGVfhCYm9LyOFmt+DM7gBABz4e61egOqZvgOZ+kKudYXAjN3XEW2pzkVF7V/I9HCLvMakVsdpqB31QcAy9PK3Z5h5A6SC+8AeCX77+Fm71bjTYLX9/AHYKt/WYxFzI5
 6E/mpAvh
 0N30XJsETyKc7hbkyekfrJBfbZUk6bjKcaBpMtgdlNbAmGAvhLjX02tzdpGCpoCZSfYTy2BWmwxk7lkEdGwj8V9qbocsDgS/S79mUkXrzT13hSAoMl5/eCItsWfef95AWxUevITlVebJ1vu5kN7tGMZDWn+1Tmu3wLfrpH+5YHgwTlt2e2rGMJnMoGJbvqCM8JaiC1yNj+aMCZp5Mr0gVmfIIFxW0Caub1n9scybNQ79ctw4em6aryQn5ptQP1ujEWJ8C5WWi4f9kH8uwDmRRybMYtkX+E7GJNFDDTZBwC+s+2eVOQeWV2DUnWCUXktV6UYdoAwxzmAGtYiUVBl1AV5RIwuMG2Bauu0dXeJilIaDqLHpT6uBYZLmu6tZsRZuvdzaOxwlsQet/7TMwEQ0/PevDp730FNXR3dYe6fuXyUdSjzVwvpsG23e83s1hqhywa0jnsH2dRd60CsmllyvQKfH8r1/kHnDd2ua3IhJ32XQfBTXmcEVAeqh4Q10HiDagpvpt37speBnHASRQLMGNpZJxpzk/GNIBmq8qzGVSoIR+lZ19G3TG/YCw+nF2D+NwfLLJm+I4PHuXqj55Mb3Aj5f6ppIOM/hBrpYsYlLB2mcAu6fwFsEBNhOKV482CL8EzkndZL23iZBvr19h79OZTtcpLz0+VwEYN5lAQF8/D82vAfwVkW+sJwpES+3DpAdWUsAYDR+FmBjybFNuD1tfkxmql6Zlf4IEnZvFYNB+PjhjYyUOFjE7J/hQNNcD6gVtZB3nsYZ40xPIRA53Un96F4zfJc83XM5KSr6q8gk5wpscS0GKajJZpgJ5bg7Vnw/H5sISYMxt17r/o3rlVsp+bjp9C8FqTdMgcxFu0G0yJRWxzK0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add ioctl number entries for test_hmm_uapi and gup_test.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
v2: no change

[Since having multiple maintainers trying to merge these would
cause some conflicts, it would be more manageable for Jon to
take all of these through the docs-next tree.]

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: linux-mm@kvack.org

 Documentation/userspace-api/ioctl/ioctl-number.rst |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-next-20261111.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261111/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -147,6 +147,8 @@ Code  Seq#    Include File
 'G'   00-0F  xen/gntalloc.h, xen/gntdev.h                              conflict!
 'H'   00-7F  linux/hiddev.h                                            conflict!
 'H'   00-0F  linux/hidraw.h                                            conflict!
+'H'   00-0F  lib/test_hmm_uapi.h                                       conflict!
+                                                                       <mailto:linux-mm@kvack.org>
 'H'   01     linux/mei.h                                               conflict!
 'H'   02     linux/mei.h                                               conflict!
 'H'   03     linux/mei.h                                               conflict!
@@ -252,6 +254,8 @@ Code  Seq#    Include File
 'f'   81-8F  linux/fsverity.h
 'g'   00-0F  linux/usb/gadgetfs.h
 'g'   20-2F  linux/usb/g_printer.h
+'g'   01-0F  mm/gup_test.h                                             conflict!
+                                                                       <mailto:linux-mm@kvack.org>
 'h'   00-7F                                                            conflict! Charon filesystem
                                                                        <mailto:zapman@interlan.net>
 'h'   00-1F  linux/hpet.h                                              conflict!

