Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA4B6606A6BA
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 06:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=yWU/tPwY
Received: by kanga.kvack.org (Postfix)
	id ED9F86B0908; Wed, 25 Nov 2026 01:14:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8A856B090A; Wed, 25 Nov 2026 01:14:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D51EA6B090B; Wed, 25 Nov 2026 01:14:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9DFF6B0908
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 01:14:01 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 25D22140DA0
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:14:01 +0000 (UTC)
X-FDA: 85472625882.03.ABB73DD
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id 97DFE120006
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:13:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="yWU/tPwY";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf29.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795587239;
	b=jA+EqfoUWUTvDGw7WQP9DbWkG13znPaJ9hsWYSsITClOd1IC3LGG5oMdibx2O5XwY8u1dr
	+3YZBio+5FuYBjD+vDoKs5EbESlrmcEt+/CO3eb8IQ90HoIWzbxuty6V822cXhvNuyp5+z
	VFP6AelufB+ZSGPcWLbaPi1aSSU5MsU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795587239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KSyfkTIM3oBW4szNqhNzxJzYdeXlrWQwTUs3E0agQZA=;
	b=2eVHc49EQf1eTiDC5eDlu67iPyeFxgphpr7i58Sk0fvmaCtkkKNZJqX8EiIqC2DOKLXsry
	nMmCZzhGY8wqB7J1jyQVn7Ro+DMiFVFcwdLN6seRQ/TPgNMYOknohQD2L/R+l6agT0bwOs
	0Ju8aSF9WEV4lfkX+MPUzM1TbxBvSE0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="yWU/tPwY";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf29.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=KSyfkTIM3oBW4szNqhNzxJzYdeXlrWQwTUs3E0agQZA=; b=yWU/tPwYuhIm5oxlF+9IIOB21x
	XZ1/SuGnvm8fxYUV82u/rwcd+e0JZTVBDbmeo2EFN8RRcskRB0J8b/0GVtFClKCZvHJDDfHB5vJoP
	mioMKbeXUW1pWyqV3vu4b3sl59Hg3eAdFCLVCKFOWEIQeOJQKtNmm6uSDYGYFEcNmOhI8Ogqlp0Qw
	UCmXP5Nzvez1UEntRjVk5QkwqQuJFewkiU0ivn2GKJXjq6y17OjRmrQ+fzQ6uD4QJpFz4jELL8vwP
	QcJ6uaOqREsHDGyS5bWv5k7pNbopX8lNMRWxb+uY/dTboKIQkxA+w2SxUTYfDiL4XcfSJeGrkPkWU
	S6PSujXA==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xW6GU-00000008Wvh-0Sz8;
	Wed, 25 Nov 2026 06:13:58 +0000
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
Subject: [PATCH v3 06/12] docs: ioctl-number: update SCSI entries
Date: Tue, 24 Nov 2026 22:13:33 -0800
Message-ID: <20261125061340.3402300-7-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125061340.3402300-1-rdunlap@infradead.org>
References: <20261125061340.3402300-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gexcdast566x5uxxt3im39hxxs1ei4ef
X-Rspam-User:
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 97DFE120006
X-Rspamd-Server: rspam03
X-HE-Tag: 1795587239-599214
X-HE-Meta: U2FsdGVkX1+iuLHwQu99jhX50m5T+7aJZ6l+ZljubcX0Gunj3Vs1vr/dzmGvIwH15utTOVrlkWoj0DRhQWr1t7fADdbq/cD6MSSv3Pm+wSyyhBl4xlBwmCI8L9xuKXdMVDiNLxxieYX890uz5PFV/m0JO4BJF4nmHSvRJw+X4BAWeDbQFVhUidk7xMps2o6hD7fPAm5giuD5/y27EBcCG7qxplma8D5fDVhe7gGQv4eCP48a03Gp1etfCdoiGtjuEB/u+y14bJqD7eD+G7CdpfRNugVyaBAC7KMGUfKZB1siPMQnhCV8UOSlXwr1HLopN6IvEUsSL7RtBCuczKmLHEA7NJNCef52fUnX9iDGFyapKKDtFNh325pdlWdkxT+PVSwDqsnI6dDNi2MBjVSsH5IDlw/taLseak08RtP7WdCN5FCwh+zc+rjAAohBnDebRwJ0FSEIQhvHK2sTT8bTQ/xmTN4vMKQzJMB748Hf0aohdbfl/3Q+oIsmWCbICFpqwLYAm3VaLjGQ4DodFDa7KnOWEE2wOb24jTzTRi0edP1IJCtX2I/ydfjYnIw+t5irQi8p2yMi+shE42Qn+xGG9F397ihIGNbJ+hrbhH75U+t9eEXXsEuwgH4yMR/406BAHe8TJZ7LSFbFL7CNLMaRN5cVKPHrtkSeYCYC9n457uvqmQx95PDpD5V9Wp+HgsXAk5RJ++U+MFTSkJ4LVA8c+BO7RgwKq30XdKdLwtXPTFMCkBPViAiKd1hA+eu7ELPjTj3O1YGsyL9WtN4dJ9JI0MnEUxBbRdz4eu6d0tBqdOpbbwgwQiAeWL9n1FlyNDISmFlonh/MUjr//L8FQknINVkMrZMKmVHePdlr9w8Oa9A/qbgSDxHAp6ska0AKuX1YV0hAJfu5O3bBDpDiv7s9xSkYFE54BMPyXeTsIIimQ7o58C2GkN/aoVe0HGeWoh967umWqnlmau8VKJP6hcI
 2xMNLas4
 AJSx5wJ2ukjgnOOGmE6rHoRmGfZtTObKw1NqZcSkLrGiZfA4XzeDKzdo7JmSdgVo4YT9egyncvvGryWgkGv0Kx5wz8r68qdvRmkuuwsgPP6odlkq1dhMdbGWAShlv7WtA1cbIGTPeD9n2jrexuMTx5Pp3BKI68kRRGGxYi0r2r9hSKo9e5zEghwL3ntVDli0pvC6TulV7wzjASf4avqhgGvAHibAofi89rDCd4FwDn8jSRqcQe9HyQYmaTqixEm98OgkieYESC8BvtyovK70Obr1KwQL0WJd9BzuC1aKH2c/0DXmvAkCBbiBTArKTVu2TmiYMlyRTtkgVSCPjPt9ZyK8oSuG8m30rAElMa6wUcOZR42soWrnc7+Lk/cH9Z6aKkb/09HQHD3bGmajCQ0V9WLJZBHqsZaWuIzqlUQEM+jP2MnfkJKGY+X4/664OlGW0wiarwuttTNGacPo36TRw5XkNE97BN5bDXiIk+Z+GYy2ETVTOM17yLQwN9OjdhyZdhYsSgToTOTzAv8JIXLd+v5j/chuVn9kHAClLCmbOkmm51DmlSkgP/ud+y0pG8kYfgEwSKHk7tXM4M4umKAJhxUlFgLJC4NddT6iVWs85rlW3TLJc29QovtC0iz/z8956LgutEXy6elOiNj+wIQwOzWyWyWoCew173syfEA3bPeh55+M02ikGKmOpvIHtlnUsMfiH42RI0e6ONswtWD1+3CzmYwWQaBPe9IXfMGBtPAOF0klE4C/QibKPyI6P3BIcQlMegh3Jt/9XLfenenCzX+D2aZB/cU4QbSSCKkZqt9n0+1UDgDR2AsxquV/I0dCpxXqNuAIcdWfnicQzZ05UmbUZPw1hBZzGG4a4InHPQc3jK55ggSJvTxX5B5/Oz9EOBXHtYXUUBJAi4qOpNnt2Noeb4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update the list of files where SCSI ioctls are defined and update the
ranges of function numbers that are used.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
---
v2: no change
v3: rebase

[Since having multiple maintainers trying to merge these would
cause some conflicts, it would be more manageable for Jon to
take all of these through the docs-next tree.]

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: MPT-FusionLinux.pdl@broadcom.com
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org

 Documentation/userspace-api/ioctl/ioctl-number.rst |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20261123.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261123/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -187,7 +187,7 @@ Code  Seq#    Include File
 'I'   40-4F  linux/mISDNif.h                                           conflict!
 'K'   all    linux/kd.h
 'L'   00-1F  linux/loop.h                                              conflict!
-'L'   10-1F  drivers/scsi/mpt3sas/mpt3sas_ctl.h                        conflict!
+'L'   10-21  drivers/scsi/mpt3sas/mpt3sas_ctl.h                        conflict!
 'L'   E0-FF  linux/ppdd.h                                              encrypted disk device driver
                                                                        <http://linux01.gwdg.de/~alatham/ppdd.html>
 'L'   35-38  arch/m68k/include/asm/fbio.h
@@ -259,6 +259,7 @@ Code  Seq#    Include File
 'c'   00-7F  linux/comstats.h                                          conflict!
 'c'   00-7F  linux/coda.h                                              conflict!
 'c'   00-1F  linux/chio.h                                              conflict!
+'c'   08     drivers/scsi/ch.c                                         conflict!
 'c'   80-9F  arch/s390/include/asm/chsc.h                              conflict!
 'c'   A0-AF  arch/x86/include/asm/msr.h conflict!
 'd'   00-FF  linux/char/drm/drm.h                                      conflict!

