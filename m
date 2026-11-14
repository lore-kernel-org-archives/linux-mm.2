Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A10DC60716B1
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=3pquZVZA
Received: by kanga.kvack.org (Postfix)
	id 08EEF6B05BF; Sat, 14 Nov 2026 15:27:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E73C36B05C3; Sat, 14 Nov 2026 15:27:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C29506B05C4; Sat, 14 Nov 2026 15:27:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 71FBC6B05C0
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:27:18 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 124394016A
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:27:18 +0000 (UTC)
X-FDA: 85434859356.07.69DCE59
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6B86A40008
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:27:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=3pquZVZA;
	spf=pass (imf01.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794688036;
	b=1qSmJAjVYXs/1X20BOz5SMznO82JELqnwQrCtgYra4S7Qjnf2Cgmz3Rcrk8nBCjP+Kma//
	uWvpbFV/GAsTymCL81t0UBYPYUjy9qNnxcKKGii3eyxEq+QwQ9cwWp4I/iUCwiRRcR72yI
	RyYriWLwY38XKyww2yYflXdVAT45o6w=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=3pquZVZA;
	spf=pass (imf01.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794688036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tmHKbAmxa6ArfnJ6gJ4VyhMIyEYWb9jJaJtmM71QRoI=;
	b=ZDqoqP9JseKJmUUVO9JitBDXBBi2gv7uno9rD/LmCOcvjn8JQk0yAGJV16tEpsY9FLBGwk
	W6IARUNiP7BIIPGUQ12MLzo8VJt0aCWpH269J1TpYJl5ZhDt6LRvADz77rQwwGthRTO9sh
	TcqPRt8EmDX5WcVLsZ4W0scdQZvwN9k=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tmHKbAmxa6ArfnJ6gJ4VyhMIyEYWb9jJaJtmM71QRoI=; b=3pquZVZA3xXfR1zKOlsLTgQewp
	6L3A4hmklS6cWuQPp4vAHrmMD+Mf6hZ0D8rnZbmBsOrP8+4UCu4Huopqs8MjmolIxvH4Nn8xsEwqi
	hYNi5bO70Ir/MQ7Q1kA6XJ/nZF9qVkFoKC+Kyv2GReF7FMI2bmVer0cXfw8GmQvuqFRC6m8s2g5ZC
	XNUgHj8PkYG8nycQu1Uf58e2s4r3bcySyAZvAnY/VuzD6osLqgalvwYRXAOieEaS92e/WwFha3ew1
	2tpccHBaYigDGYD7BtDdwpyQhE2Wgi6476i7/URJGlnfEVH7+SZnD/IwI2SjPPV1U53zeFF0YrPTl
	GfmH0flQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xSKLB-0000000Giga-0GrV;
	Sat, 14 Nov 2026 20:27:13 +0000
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
Subject: [PATCH 08/12] docs: ioctl-number: update USB entries
Date: Sat, 14 Nov 2026 12:26:46 -0800
Message-ID: <20261114202653.3113381-9-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261114202653.3113381-1-rdunlap@infradead.org>
References: <20261114202653.3113381-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bc8wwa5kkjn5e89gn9oiyeggxquisgxi
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6B86A40008
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794688036-990087
X-HE-Meta: U2FsdGVkX18vzruQuo19s6aO8g6ZbxmQbU+mT1kApcyLec98+oUHf+eRwQ44BqiqGz+Yj96xwGStwzKp8uj/1akg6ZWFyll0G0lj0EKHJXcVxJpP2TQwcHRjFy2aRPBR7OybJqna2t8t5vRhttNjgL30wV3YVUkBVlEN43PhiLnp35C+/hGhZ8RDQ38YXGtSMb4EcSn4eLc9oVeLZ7ZrKbDA/wNGs3/Hx2Ya2SdVArfvPdhg3gPdBe7ExMRfH8F90BWI6AZNh9KN9Hr/0XTTGTp3ANTliiKjtRpw7wez7sbMGbrsm19DWUIjeSy3hO5KeXgKnQHYfXM14SJODekXGKd7tDn5wo0kFlPpwpOThPCDxSHbb3LdPOtRitQvQMjWXw+/8CZU7EhmgZS3YbSkqyyDeeGehyHxbsCRjlR5JIvtUU8Y7s9LFUNNjkXEn7E9w1j8hn0NhsOJoyjvCvN0Cb18TLPwcgyi3e2/gAJRJNFmsogFfbcW+KJGKh3AF4w4zYYK8Ze/yzdF27ErJ8C1y0eF86MzWWfbuOqj8dZi9XxQfdnfm1YSbCrluDJJjaCmV14DhumEAEmAbViv3iWhqZoAFtVLeXE/Giw0QOlArOq/xG9kwEOy3RlYeW5s6/+qC/QZ69kC43MnkMPx/DDmqMj/dXeTPiMiIycy3DXY9Joiu3U0NhQInRAjl0HhDUIAC6PmUEFVjTJOsJeiXha2nHdP9Wtu2NGNmPnw9xs6Lbwysn2jGCzCAvU7i0gF1BC6WLRhDF2Q+vNosvOAOoUC3gFzubmGrStol2A8YBSvEd1o/10SaHc26PvX7GalqBVrp6zn9IWe1mCucZ8cUD5+1Vk4JvYtUBosOH0DkA4ClLW8y6Wwtn2TTQd5rIxZ7BvNqXNs2h6N/14kIfXSqhi117g652CvkceaQB+2QzbC7QVWIeVuX3Smlo9ir3NvnWFZUyE45kukIcUSY23ZmF0
 CWHGLcF4
 RAG7jUEybl23T2lzkcIS7XhvxUavuzd1h6CctCNa8Zt6uhj5o/hZGetLXsERuwt7D8rli2lLOF5TYGtQ0AQ17NyrgtB1K/lLZZNAyfY+Ew0wu2IAO1j9t1GlA+gz1Qwt0//9f2vsbPWjQn835f9b4AL9DyksUXC/MMB6iPQ7+EkGM8dWuI057b0sSrCcroDVJFSsLxiJdWySYSZlTnoz4uzqqPSs20MzkW1WKe1i+mLrM08yKp1Pi9aTSC58X9pC3zyHGfpnY1EOOG8jYxnd3H21zJmLPgxnaitXzwRPYfwSAqtUbPwv+jogt4+3DQUUj+/tcG6d4VIfQ7sv8fTZFNb3r84ZyHy9lDb9+6QKmmN/L7p/K3muo03O2S4nrbXDfQb7BOVrBDbdosN/wHR03GGhNZx8+UldWLWeLDSeZIgxL+np0Z+TFNz/bkDMkidijIRPgF6PVe35D24JjVmZimmU+cgK/bvRg0T1B1BzjIaobORCGcdpNLOQjYhWFwa1coL8/vpDJ8rtswVgFVJZymbfgbSJJdD3E3pVa51ig4yGm/eunSGOR7LemhZunVF7QDr9S6PbCIPL4k1PFS1STJ7ODEW2jPBt1NoDRxk1mbQdtlpPbseCme4n4mqayaoHuWZ6mucGzqWzFA2WiRmbA2YASIMNksCVZXmk6/w6MQbHFRSieaciQ5SEnAZORInNKUoW/EvC+c9zE6/nY42kZraLoQn1jZIkCkfAx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update the list of files where USB ioctls are defined.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
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

--- linux-next-20261111.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261111/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -234,6 +234,9 @@ Code  Seq#    Include File
 'U'   00-EF  linux/usbdevice_fs.h
 'U'   C0-CF  drivers/bluetooth/hci_uart.h
 'U'   00     net/nfc/nci_core.h                                        conflict!
+'U'   00-0F  linux/usb/raw_gadget.h                                    conflict!
+'U'   01     linux/usb/g_uvc.h                                         conflict!
+'U'   64     drivers/usb/misc/usbtest.c                                conflict!
 'V'   all    linux/vt.h                                                conflict!
 'V'   all    linux/videodev2.h                                         conflict!
 'V'   C0     linux/ivtvfb.h                                            conflict!
@@ -280,6 +283,9 @@ Code  Seq#    Include File
 'g'   20-2F  linux/usb/g_printer.h
 'g'   01-0F  mm/gup_test.h                                             conflict!
                                                                        <mailto:linux-mm@kvack.org>
+'g'   01-03  linux/usb/functionfs.h                                    conflict!
+      80-86
+'g'   41-42  linux/usb/g_hid.h
 'h'   00-7F                                                            conflict! Charon filesystem
                                                                        <mailto:zapman@interlan.net>
 'h'   00-1F  linux/hpet.h                                              conflict!

