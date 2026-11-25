Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26CF2606A696
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 06:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Eu3Xj08W
Received: by kanga.kvack.org (Postfix)
	id 403CB6B08FC; Wed, 25 Nov 2026 01:13:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B52A6B08FD; Wed, 25 Nov 2026 01:13:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27CEB6B08FE; Wed, 25 Nov 2026 01:13:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DDCEC6B08FC
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 01:13:52 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 276B3140BC9
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:13:52 +0000 (UTC)
X-FDA: 85472625504.15.30FC893
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id 55743180006
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:13:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Eu3Xj08W;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf16.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795587230;
	b=E2UcKh0/E6ZbQVQak2VYHmUpJwFlW+oMGANZHyA4bgoRQyD19tOeARZuFZCSzganR0hjWH
	JSlla0F1F4Ki4sreeO3o8ZKGxXZPYAIGW3mGykQ59KjIQSYhJpbyA5nHK8pdY7us5754fn
	fYJvXeSbUAd6eguK5dF48mMsbwkzU8E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795587230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z4IewevnDUR+3Yga8umWQJFbQaMK6YhJ+IYMzmfvhho=;
	b=RQucrNniIDK1+LSw4R2F35rtk2Udb8OD+60s7RPkfQ3qqXbiZqMVdNQ3DFwClPtTkuH+kb
	NYPppzmZMUFb2ixXaw7RMed57YdborDi4bk9G5E3s9ESq3zeU8cuPiS7/oJ+aYS5H/TvKL
	/BtvSLIp55p2A5dZWLJiYABmW3QBoXQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Eu3Xj08W;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf16.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Z4IewevnDUR+3Yga8umWQJFbQaMK6YhJ+IYMzmfvhho=; b=Eu3Xj08W3NJugRAeAckfLLB7fP
	nWb2k/gRos5t782SZ8XOZ03pXXlaHouCGrgvKjtcuJ4S0EO1YL+gg3XlmFEkwgMOjvRt/NqQcEQmk
	pM6rqd0iD7C6aQo5piQb85EOxe6mnzcb1cTfastxEm3miz2l40RVZ0EWbOow/EM1P6l8WGtpymXDs
	lH8ot30ghbW9dh3KshpcJwOcl5WTdzFR+pzMpwniEwWD2+5fhenpAkoIfJh1SlSH3NAJcjDgFu1xI
	pInFJMLrApWbVUHkDO9yAOXHCHiwHy+toq2qGLgACisBmGlm/1UCCcxJ3fDDE7dAfemvx0nRgchMx
	dhT33leQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xW6GH-00000008Wvh-3rUv;
	Wed, 25 Nov 2026 06:13:45 +0000
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
Subject: [PATCH v3 01/12] docs: ioctl-number: update MM entries
Date: Tue, 24 Nov 2026 22:13:28 -0800
Message-ID: <20261125061340.3402300-2-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125061340.3402300-1-rdunlap@infradead.org>
References: <20261125061340.3402300-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7quwhtg8bpec8h4jnpkkoytahjtkbypx
X-Rspamd-Queue-Id: 55743180006
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795587230-100845
X-HE-Meta: U2FsdGVkX19fysn6ZZv6eUy0FqLZ/8C4Ae7yU48BJ4f8gpNz3s45g5ubn+E9jH0wzit9wROZa9CztUOaNbarhbtVJKXdDGVroh4pAbJesEICtdIAhYEYZGGg+z15BbPiS3wLANY0+hOyGwcC7A1gsurTrbT9k7M/D9DAsVeF0IYhwb7MaiZlyfJtGsxVygGM2eqT6LqvhgejPkkeaVHPh4qLlozj1LDeUDeUlnqeVWhSkYrdUYRky/iR6c/fs2YHmtotpSN7fCjvhKIdRo1wyHlk8elxZGO6HfP+PzsnESclbFyzWVKrOl6pslzdMUNz12iXtnfJuvMCgysOKezrsEOptEIN6OGRkfH6ipcEHjHrM1XOSa5sCmRckRid23vE9J9XhrUAn1r4kL7yXQblVzg8xzLdjy+XXMSQnAfEDnBywFX3axjIOrRscm3urqmk+5w2bH7XjhH8T55FyFFmRVq0lcn8oGSq1YFpGocQZscphh7femwFqNyeMDp4opEtyswaP2YSZUba5IXDgoph/hCpHFkDbeUnTValJSASruvM9tABo3ETNrVInfVOPdBDY+Xe+lHdUxhhCONyJgeuO0xI3F0DG/Vr7gQrm2SYq85J8g5AyzEFP8wbhnPTo8D3Ul0C7P6UsyW764wq0eIZrf4sCQyP9UAhvcVaFz2pAA1qo8VIxYfJ5UO3zn7PEo/BgDETYuK1CmAmYtObcTG79i4Nh7ZnL36o88Z+onbrDb/M2ldFv/RXxZ39LukmnkCM2HrFQ5Gtec+TVKpXFhZuxznGlX7sMkHELWfBkErG7+0xdIV0+zQcpQ6+aP8LlqATIXpUFLAkjX+43mUGsDwf+kmWUIAX7NRyV6JhwddqFDA0ymmjUsdxtqpaHF02pQPBcgDGek/34ccABjuPLtb6Gg6KIygfA2HeWoHKC6GcZk5/5x1GFUJXKJnF83Q6/HarF2uLN2pj/3i1buABP8q
 o4zLzS0X
 Ir8CJOyuWTQ4eyj4pg5DmGMQYPl+caH+I1u2DTBLedc+EdntdP/uDpfBJB9WajUqYFcwH+jOgK3UN1SWN6xCjYm4WH3a3lYjvVsDkBwgLSqAM+ZG33bp0SyUTtVzXcpa/hqBFy/ur/8dVEHmLQrYL4RyZWP2QxaFZQv4H8kLli3sUNEHxyj0OQnHKZir2Uqrl17ig1/BiFNgJ3+Rp5OcN2nRm/MDoCc4hHjP9FLC87+3jjVulzYVj66NyttuPF/pzu6RbHeQaBVeyt6KHIh7sriDrAxMDcruFWgVz7hVbqM+S302esyfOPicaot2s+v/nb1kM4XOvBEJZczQoDGF9mQZ8lQdU9Osrk8f+ttUm+Icim6QPeXAMrH0naILzwKudIK717/LjBT0qIl0AQ/EvQYUx3xa/luzhUlmqhGUgn1qzwS6l9TmhCUIfcNGYtj1lx6a5itRXz6zyaI0v5aTmhclbUIP7fEnQi97AHCR7SQkoIsYM5FqfXGzut6HhXTnyHPhg58eZtpKWqtmej6gzcGBzJQOWoc2vHQ9tvwkcmzarDvC/pFAYvTzpP96ULrE4EXolCAF4jLN4npBSTsiQpFycr/QzwR30ib4lEosDUWni7eaafLU86LnPkTtxuXyBnMEaqa0UJfec7/K8bxSyWU12+y/DpOAEGGpz/fesLi0sOxVH7gW6TatdRqxmZYMn2fTTb3AnHHQ+HQ5phcuLJBizwZOEpzBxeajGsYYLX3mAVzk93sVtFc7FZMST+WC+ucXXVYn74F7iXsbD0SNBStzDst3HhoJDJhp1BRv7ZZn00hNBojeLdjiKuefxfgVWTcpt2HsAzNlW1jCEyB3HHJImIC9zTonyZGgg6NZX4So4xO/RoAaWJQ0nL5/AmpAJ1hz+3yLWoNzf9sKXdMy2kpBJ6IIIrZBLYGO0zPReIrfbpmV3p9KgNFVUK79F3ZvWqYc0WmIfQdAtAi9dGZ8zbxgfFFYs
 WrcER/DN
 nF0y/fp8pEXbAgco9fW/a8a0P3ldzAm5krAdpu82TeUhVxj3h8q0C5D8fFrZdZi9Dk0LneCdObF775Fk+cISKrkBjrztb3e3YB6U+7NaRYNFrqFlXk3PWHScuWDDSfHQ
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
v3: rebase

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

--- linux-next-20261123.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261123/Documentation/userspace-api/ioctl/ioctl-number.rst
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

