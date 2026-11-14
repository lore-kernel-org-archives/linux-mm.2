Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4027607358F
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=K+RxW3IU
Received: by kanga.kvack.org (Postfix)
	id 9BAB16B05C6; Sat, 14 Nov 2026 15:27:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 833506B05C7; Sat, 14 Nov 2026 15:27:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 684706B05C6; Sat, 14 Nov 2026 15:27:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1EB246B05C3
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:27:19 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 99E8BA7FCE
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:27:18 +0000 (UTC)
X-FDA: 85434859356.07.ACB0CFC
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf31.hostedemail.com (Postfix) with ESMTP id 09F2F20005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:27:16 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=K+RxW3IU;
	spf=pass (imf31.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794688037;
	b=Q37jMItFyLxc469W2kKVxVBIAysz+WzadBHN68zF0pnTtiFLiLQGI+EG8l4JITdaNm4Ts1
	AUN/qok5o79LbL2mIbHEUAAVDB2ecTudXNrpwTbGTo/KqWGIgLadmKBYJsEuMGkanzjZBk
	c9rn9y1M7NMlJ7eCQQUzuDsAjlRV2UU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=K+RxW3IU;
	spf=pass (imf31.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794688037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g4Lr1iIWwCQDLrfv4xinJtkANuRZUZ3Hye3ay62BdDM=;
	b=d6U5OTYs89OnTkPy6/awQb6jkXqY98kH1dQG1pDGHYJ5/jBZZXCmbFrLyb7rftoNDpaO2G
	Ll2pKIejN0/zCMEMC5cHst8E336hWhV3BiVYgeedvhhq5HeoTmFd9bumI1uBleuv4DOyRm
	UQWcKZK7atBaRks0eSpSjuG1ayIpjmw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:
	To:From:Sender:Reply-To:Content-ID:Content-Description;
	bh=g4Lr1iIWwCQDLrfv4xinJtkANuRZUZ3Hye3ay62BdDM=; b=K+RxW3IUjPLut10UJdZN3BFbmh
	pNxgVj59+6O/xkEPsB1hqiX0K6qZJW5/M8/WqEV1J7uMnx4KuEIEFt0PDhNvNcwHr2uGYrrUYIwcE
	gtcxC7ZIsLuo69Ei00wEPYqF7uh+iWtquvhO3gwZQqnj+BOkE3qYRmomz1FB4DYyLM5e+4m7yTRmn
	VucLIkmDKfNlqGfpBae0bAvW/bzkfaOJqgckrrJ4zF1mbFGvbDxX3S9VlDpAP5qmgkUnrmxxb4L0D
	9Zo2mI2kpwS22kcR/S14ACNaGrbtHanSEoj1F3pzRF7XLKfrnQnw7bMTvvwNNW+4Bb7gQaOVbRqc7
	vcfk00zQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xSKLD-0000000Giga-0Wfi;
	Sat, 14 Nov 2026 20:27:15 +0000
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
Subject: [PATCH 09/12] docs: ioctl-number: update virtualization entries
Date: Sat, 14 Nov 2026 12:26:47 -0800
Message-ID: <20261114202653.3113381-10-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261114202653.3113381-1-rdunlap@infradead.org>
References: <20261114202653.3113381-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: aits9897b9sopmxr9s6qunxmmxxc38d4
X-Rspamd-Queue-Id: 09F2F20005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794688036-766649
X-HE-Meta: U2FsdGVkX19BA3AEiV7zhsuFg3FSCQvEWuW3W6s9aEnZ1BaEiSFXwJeweTs/Fr1wLHU8dsaEIEgb79yKUefZukVLe+BqLwTimxzuzW9SV702XQ3torhGCkYxK3R3z/ttiKzdu61HMatPfFXgtWhZeozzi3BJCcwmxNY8EXlVXHxEjtOxlla41BNvYBuSy0icsORBXZNaR4BrIb5Oaar+1M0lbetOpsaFNHIqnur9mabxVgSrjQkYgbWu8ySkIg3j6p/7JbF4CwvW2EUCCO3GZGfrITo530LbWHyFaqBDeEPKKJghUJGiWAV6XJs/cDT2IMkssao1yJWWB1nswZfWACsPhMwDbYgDArLBk8wrsMQo/MYekI2qdpLsnUlyAmg9mnRK3cbi2nfpuAzMQwf1rh7aC6od5l5RPVdgO8QeyUw0+/gSyiU8oFrsYVB9n7HRHRfRupKu94M6+0l4xvO+utJLiAHldzDBNVv+Xd4p1mmkXQI+ZSbR9jdRAmTVf/Y5Mbuhpvk8OZ2ZTUmyrVdH+2ki/Mj0EWXDCNXEV/iPtaQDVznXZRaXLe0gPAGsWRhZBC/GdEa64FsvwsVihQMY+09CBs/UuTWcSAI0A1jrjou4sf7tnNkp033xzEN/w3FvKLi9vPGbHT7fSVv0SDSEIoNLzOYxAS6Dpmg5tJqQpL/xubg9V5wJufNrIcryWb8qZNC1V1k4klI68R3O0BE/L74tpqIhMJCx+UwzLvQatbcgTUCVPRT3bFRK3iG7YSufN74lGwYxsv6VYuKIhvBqXVIA95fIgLwe56YLApF+/4Ynn9/vDmIbPbjxlnTMJQQ9AuOhv3NkVt1mcbgKLzFrC63SEYn/iMvwgrAnw7ZlKhzUlg5VE8+3FKdJOIggqAwcpq/p3jXZR3bHuuSmeUfCcKRFzZXwbCk6T3hqEmtYhPBwihbPS/McEs8Le0Ey5TjpLZwVc4mNbuMIe3JXaeN
 7u5XAaDd
 A2tcAJDDwvEGlmRlmDGFmGVQ+W3I9sJUr2///oj44Fjh+f7HQz9kiP1CBAzfCl1KsTKLsZpx5eT1T52p/Jgjz+jKrIofZR9jH8pdtzIFqB2V77Z3lqik4LFzblBQ0G+YYnf1l8wzRmBeE7dI7OXz+XJTf4uGTtKuzEaCfbrvISzxsnOKLQnRfIcNKY7lkR6Y2Ir0fe9U7wzGdXZw6lXj1COxdwN4vLDDziPhnpJiwXqFwI7GaCJS6HuHvtya+7Ub7hTbGFuIQYhST66UgSCaEaLZShFCJRlAVLIaTprScZr2Mzd9ePGfu2oRHj63yHqdToDZPh0EBZVu5ILvWHRj7qJHUaaZj8QfVG4A6vp5b9+4JQMATkWWmeLKgZx3y6XEIf0vst5LqyldkqAYGBdf3gzTH41ZBMUz85AZN/jqEzzKLoB24WntD9swt2lkJmoBkcwIh3B67Lc7WrXLoKPSQYIB/AJgi7IUB0vl6+bEdJuGuUwwUC5ZorGDSRSt0B1fh7CmziT0n4KTnEbAlu0hB1ZK6LGKjvIpVyRemOMBSvCbUt25TpsqzCIhxVzmtpR/P9cFsXzILsWxIsE0+ddXoSBnltG6NF1xRNL1AbxRyjR8Ndxz6YgOfC4j2BgwWy6spFbIZaaNhpN14WZclhGMaRs03tsDlxM5nka4KWJz2CnluFEdQ73RCf4MdRRANAs/EK+yWFp0BJnJNwBJKy3L/dRN/WIJmyi8clNZuP8tHTwmiWtU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update the list of files where virtualization ioctls are defined.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
[Since having multiple maintainers trying to merge these would
cause some conflicts, it would be more manageable for Jon to
take all of these through the docs-next tree.]

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: xen-devel@lists.xenproject.org
Cc: Hans de Goede <hansg@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowangio@gmail.com>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Cc: virtualization@lists.linux.dev

 Documentation/userspace-api/ioctl/ioctl-number.rst |    6 ++++++
 1 file changed, 6 insertions(+)

--- linux-next-20261113.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261113/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -200,6 +200,7 @@ Code  Seq#    Include File
 'M'   01-03  drivers/scsi/megaraid/megaraid_sas.h
 'M'   00-03  drivers/video/fbdev/mb862xx/mb862xxfb.h
 'M'   00-0F  drivers/video/fsl-diu-fb.h                                conflict!
+'M'   01-03  xen/interface/xen-mca.h                                   conflict!
 'N'   00-1F  drivers/usb/scanner.h
 'N'   40-7F  uapi/linux/nvme_ioctl.h
 'N'   80-83  uapi/linux/ntsync.h and uapi/linux/nvme_ioctl.h           conflict!
@@ -239,6 +240,7 @@ Code  Seq#    Include File
 'U'   64     drivers/usb/misc/usbtest.c                                conflict!
 'V'   all    linux/vt.h                                                conflict!
 'V'   all    linux/videodev2.h                                         conflict!
+'V'   00-1F  linux/vboxguest.h                                         conflict!
 'V'   C0     linux/ivtvfb.h                                            conflict!
 'V'   C0     linux/ivtv.h                                              conflict!
 'V'   C0     media/si4713.h                                            conflict!
@@ -357,6 +359,7 @@ Code  Seq#    Include File
 '|'   80-9F  samples/                                                  Any sample and example drivers
 0x80  00-1F  linux/fb.h
 0x81  00-1F  linux/vduse.h
+             drivers/vdpa/vdpa_user/vduse_dev.c
 0x89  00-07  asm-generic/sockios.h
 0x89  06-07  linux/sockios.h
 0x89  0B-DF  linux/sockios.h
@@ -398,8 +401,11 @@ Code  Seq#    Include File
                                                                        <mailto:kvm@vger.kernel.org>
 0xAE  40-FF  linux/kvm.h                                               Kernel-based Virtual Machine
                                                                        <mailto:kvm@vger.kernel.org>
+0xAE  C6     arch/x86/kvm/x86.c                                        X86 KVM
 0xAE  20-3F  linux/nitro_enclaves.h                                    Nitro Enclaves
 0xAF  00-1F  linux/fsl_hypervisor.h                                    Freescale hypervisor
+0xAF  00-8F  linux/vhost.h                                             conflict!
+0xAF  31-32  drivers/vhost/test.h                                      conflict!
 0xB0  all                                                              RATIO devices in development:
                                                                        <mailto:vgo@ratio.de>
 0xB1  00-1F                                                            PPPoX

