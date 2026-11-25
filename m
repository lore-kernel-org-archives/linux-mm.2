Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD28B606A323
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 06:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=SqbDuDIo
Received: by kanga.kvack.org (Postfix)
	id 42C386B0911; Wed, 25 Nov 2026 01:14:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 404726B0912; Wed, 25 Nov 2026 01:14:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F2786B0913; Wed, 25 Nov 2026 01:14:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E47176B0911
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 01:14:12 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 372BA120D5B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:14:12 +0000 (UTC)
X-FDA: 85472626344.07.83E3487
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id 95D30160007
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:14:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=SqbDuDIo;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf08.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795587250;
	b=60zDgd1vAWTnmhd7pVhLmhG05Z3t9dBXk3JCfPPW/zC9v83zKbBpPFwGqe96U6TJrt+IYC
	W9HYqBqtaIi6cwURKoozWr5qCESJLNoPjxIxKQE7xMfcTuRE9aaJB0Sk0byHdT86x9Woac
	SnNonH6fSP4owqVQKNWds/+4EYKs0gM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795587250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mK0QR/k2eawBNLkbZvYP+HhTb9RDx4V5SHTUcbCD1c4=;
	b=rn/uxCkK8xcyg6xBhTV+VIy1FTkEztcSDa9lPtKmLi6MMq+xWvA5wJ7DbeGlu3TphkFI2x
	gxShTXdXbN+qvpZnkhV4PSTi+ETp6pAjNnbsUYsZ2SgeYdgpwO9K+L/GP6PNQYIbNK1Q5y
	Zr+r3dIIMwjBse4Mxu5Zb4Pb5dmfT5Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=SqbDuDIo;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf08.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mK0QR/k2eawBNLkbZvYP+HhTb9RDx4V5SHTUcbCD1c4=; b=SqbDuDIodYP6BDMFiCPB+z0v5h
	Wf8OZ/z8+c64yrSOhWNYDki4bIj7nXUsz0/8hjRSflwjz17ZYrEwSWjYzz/FGm8XelFoyiwOANJe8
	k9V0ao/jXKEygg8Txc8vT8ZKnlaLLvZ8vi7Cu9bbOZADPxyYGOcB9SJPKWm3FABmaSxupujCzYpar
	RBFc3L+WNPt1ER6m4syoikCMKUu0vn82kUcotGc2QkZv43q0PhftY1c8ITZR5APlT6gbbqTm2+OkK
	RKn8HXpo/mWc0Fg2xo1JmtQTlTkFbNi72t51jkUayyle/iQXCpf/WxZwuJxyQ9w65npgSUR+5MDR8
	JXWofKRw==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xW6Gf-00000008Wvh-0IvX;
	Wed, 25 Nov 2026 06:14:09 +0000
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
Subject: [PATCH v3 11/12] docs: ioctl-number: update platform entries
Date: Tue, 24 Nov 2026 22:13:38 -0800
Message-ID: <20261125061340.3402300-12-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125061340.3402300-1-rdunlap@infradead.org>
References: <20261125061340.3402300-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 95D30160007
X-Stat-Signature: e4tms4b61cgmxahmka87d3reuz78iajj
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1795587250-133481
X-HE-Meta: U2FsdGVkX18DNPnLRF6MShcxMnsgM3nJwzqdi/vKZAA3IL0CiDLEMvrbMCqTYHe/swvfXtFAxIj5YGD576I6v6tvGFyF+YKX1cGjtaSFLm3S/OLPSgWhsB9s8dwhYtZtRDvNqY4LDIVRG19uF62fG70SmcV67XbSwI2pl/CeYiV5GGD37/E35rqX1qFTT3NdJm91wjRQv1WVUTHSbfYclrJ9lOmB/eSniPWwUK12wOG4mUrQvNk6kQSz6Ss6CUDesLe+hcmTGGfr4v9p5y37nwttGZrBajAKrnhizagN1yFSnSF2xMWinxk3F4vkhlQfRrWzC7eoQXKHQHV0JvQASRh5RLF1tXREp5lZMoUqnK/E6fqffS9265ibWUP8XizgPAnJU42v11Aes4fx8zCa5BwWuu9FLbwbqtjQq/KvBUia5WyDPfmegtTilqV7dbcwlC+sO+zTl6XjXCNC3boa2Kg71/af7shyFBAuEOCALmDfIj2e9+bVhv+fNR8p0WFNHYRTSaE49DuTELsX8WfUnC4U8fGlJvEnJs7N11IzSFltiEB4FMHEyHdmmvoj6uBVecE5KWmext0pWNe5T1xSp0EtgLjDVM0bxfRhS8jyObYdiey5XbMtwp2p1gw585bOD9NDLWR6klugpr9Ruq+iRgZ4Dtprey9TMjnUlB3njnQYopwWyUY/DPUhA5Nhhr2Vzlz2eqhLRiwDRtJsuxu6SPYNjcN3uoKFhDsLKcVjyBZHYOMs4Sktomw+7pz11UDb4u/SCF6F8T2bAIY2SonWpPsXJ1acynP4pa3KhKV8/lRZ9G50U/14gBpx6+dSH+Hs6pm8Kbkl2k2RkxKReEaf2Wa6SduopMToT6os9202UweY7nj/zl9b7I6YEK0D+xTEi3u1CBXl7FEwC4sf/neI8AdNwJKN5OQPkvEqP7FkD2xNiMHoyZP36BOTjOq3Z4VlDcQI4wLWHDs+LX6CptG
 SeK5OMAr
 tYPqWjUaQjtmET62wdjTUJQ4D4A5yoaKUelXlo8AhwYXL0/E/ajKE0P4XqgOrzpvhnuVroYAAEvZQ+U4I7F5DF8nywoiCE4DNR7I7WnQQwFNwDamuO0McT6qFPXSNz6OmjY8nTzoqz4QVMc71wPk/KZIdMbE4KhODLgX4nifeQoDXDtFrBDR/MP0rgSRyzUcK7LRudhsawLPu3gqo3ifleLVo8uyvW4qUeO0oR0IYlk7SxSKC+UM/LNC9lXodOwYvU3h4B3KMD8RWmYPvYSvnEQuAngHbcDu5zpXBs/T7X7bmnZ/K85GevEkpOYftD1puRzb9IZDpMzdCZXz2MBop4VzukNFoOnSNAtcAIigQvYtCEfw2PM2PbN1yCQ948Zj3DGz7o7/j512uUIUrs3ZnB0psZCqkYpZGV9jcz7i1dzLnKCOpPiopk1/6SQTUD+J9Vxg3MSZoPoN2GluNVxbdXSXHQlarBh+X0XgaWy4+Hr1kBwPmtx24NzmqF8RIxdRXiVNB0WeNPtcpDnr7BLkaCtmLc/dbOPU9oJG8oFmDMOhy4qiFOu0cY1SukPLwTESz0fBx4k0w9jBpMBWIgCKmU8U3gnPy/XqpB5FU8yP+hsDqVQoXze0lH+X6Duq8dXNhXnCfOyWrOFyKIvMgcKQU8vH64A8TvRVx6A2CvSs8wgKZEitlnmIZvIXLPykMY7Jb4RH/9tsKurconyGnNdlx5/S4D/HHqg8BW9N9AsAFP4RNfAI283fbf5JNm4GxMlI+szr+GAyw2xLD9WdHbLPznoMwI/Qt4rMD7vVvvu/vUF3gD3/MLE6ZeuwB/+KPsmDcfZdJeyrW4OxePnayxbP+tOVDTlLLQGiePrxXSYKv34/qi8W44kO/7Qq3/6FKbbyxxXHy5n2t+OKreg3C/qay3QtFB6Rk7VtAJ8npp8kp6l6muGOiNmGHmovLLym2pbTIBaw+zz8GceC8FdrACrNIX3E4PUCO
 JD6MaWJX
 Wd1C+mZ1aD9mJm2wZRut5bb2yApwDIXGOr9Acrfuz4ckwcy7WivCvQ==
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
Acked-by: Tzung-Bi Shih <tzungbi@kernel.org> # cros_ec
---
v2: no change
v3: rebase

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

--- linux-next-20261123.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261123/Documentation/userspace-api/ioctl/ioctl-number.rst
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

