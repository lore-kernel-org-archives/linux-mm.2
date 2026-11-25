Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8011D606A335
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 16:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.a=rsa-sha256 header.s=20201203 header.b=gYew8w2z
Received: by kanga.kvack.org (Postfix)
	id 958446B0A83; Wed, 25 Nov 2026 11:45:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9093C6B0A85; Wed, 25 Nov 2026 11:45:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F7FA6B0A86; Wed, 25 Nov 2026 11:45:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 53A4F6B0A83
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:45:39 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D5FEB80EEF
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:45:38 +0000 (UTC)
X-FDA: 85474217556.01.2AE8F35
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf01.hostedemail.com (Postfix) with ESMTP id 17C3E4000F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:45:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=gYew8w2z;
	spf=pass (imf01.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795625137;
	b=ncpM+IgaL0h/MOztj9JON5ym+Abg6X0FlQZLOc8bLIznHqRZgCYZ2WmFmz9BGKdNdrqqat
	997Mm135yp956KVSagLuMbdfomER+iZbps+2LMk/ZZnxT5E7n7Aj6HE8b4sRmurd4zaN25
	vlNy1/92Gzn1c0qQl8cUzcYJHnRF/ig=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795625137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=11zt4OupvieQqDw22Q2ubqyLm0TwPHTf9uDp8UQ/aNg=;
	b=UFHzJ6cQE3duNXONWnPJsjkbly71cn7/9PlP3SyKNm/sQrZgDvUlrN0kRuVyNL/XyJZ6F6
	zccZWLekjCe9Jwr0mYurZ77mHo1RC2J+o1JW8mM8zTIeFeNXdgr3uZNEAgxNMvzGstwT02
	kxNLJkUlcmecALOBw20sC2ou7aj+JWI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=gYew8w2z;
	spf=pass (imf01.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 164CF410D0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1795625135; bh=11zt4OupvieQqDw22Q2ubqyLm0TwPHTf9uDp8UQ/aNg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=gYew8w2zbH6+bi/mBbqli+h0aBDamw00BioPDCMMC4Es4g+qCaaIw8gBYOLhfGAsU
	 9mfNHzR2Wjt3eb5ezNkPplfVvqDZB4yLXc7H/uIjYl6k/R0SNrt0O4pqewchTPc4H+
	 DoPRzU4+fJgJOU7hPx03jLkV4HVaXJMTTjxyrWRVyiE+GFkUio915W5ZUB0L5VMnbm
	 Z5AtjEERksNhEMgjG3ZSm0ynjzhzYrKmQP0JaqQq4T6DitPDhHE0cz5cUJ9ItE/n9j
	 Ip9FDRPDTnpXpMfA3rcqvq+BtjVyvtC+AdbQzNra/9WErFSqw5foLA7PdpN6n18WG/
	 9pepodyHhS3sA==
Received: from localhost (unknown [205.220.129.44])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 164CF410D0;
	Wed, 25 Nov 2026 16:45:34 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Shuah Khan
 <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org, David Hildenbrand
 <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Jason
 Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 linux-mm@kvack.org, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai
 <tiwai@suse.com>, linux-sound@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, linux-block@vger.kernel.org, Marcel Holtmann
 <marcel@holtmann.org>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
 linux-bluetooth@vger.kernel.org, Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>, Jason Wang <jasowangio@gmail.com>,
 David Heidelberg <david@ixit.cz>, oe-linux-nfc@lists.linux.dev, Chas
 Williams <3chas3@gmail.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, Helge Deller
 <deller@gmx.de>, linux-fbdev@vger.kernel.org,
 dri-devel@lists.freedesktop.org, MPT-FusionLinux.pdl@broadcom.com, "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K.
 Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org, Miquel Raynal
 <miquel.raynal@bootlin.com>, Richard Weinberger <richard@nod.at>, Vignesh
 Raghavendra <vigneshr@ti.com>, Zhihao Cheng <chengzhihao1@huawei.com>,
 linux-mtd@lists.infradead.org, Neill Kapron <nkapron@google.com>, Andrey
 Konovalov <andreyknvl@gmail.com>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, Juergen Gross
 <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>,
 xen-devel@lists.xenproject.org, Hans de Goede <hansg@kernel.org>, Arnd
 Bergmann <arnd@arndb.de>, "Michael S. Tsirkin" <mst@redhat.com>, Eugenio
 =?utf-8?Q?P=C3=A9rez?= <eperezma@redhat.com>, Sean Christopherson
 <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
 linux-ext4@vger.kernel.org, Mike Marshall <hubcap@omnibond.com>,
 devel@lists.orangefs.org, Paulo Alcantara <pc@manguebit.org>, Namjae Jeon
 <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org, Jaegeuk Kim
 <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
 linux-f2fs-devel@lists.sourceforge.net, Florian Fainelli
 <florian.fainelli@broadcom.com>, Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Tzung-Bi Shih
 <tzungbi@kernel.org>, Benson Leung <bleung@chromium.org>, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Alex Deucher
 <alexander.deucher@amd.com>, Christian =?utf-8?Q?K=C3=B6nig?=
 <christian.koenig@amd.com>,
 amd-gfx@lists.freedesktop.org, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi
 <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
 intel-gfx@lists.freedesktop.org, Matthew Brost <matthew.brost@intel.com>,
 Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 intel-xe@lists.freedesktop.org
Subject: Re: [PATCH v3 00/12] docs: ioctl-number: update entries
In-Reply-To: <20261125061340.3402300-1-rdunlap@infradead.org>
References: <20261125061340.3402300-1-rdunlap@infradead.org>
Date: Wed, 25 Nov 2026 09:45:27 -0700
Message-ID: <875wxkx3ko.fsf@trenco.lwn.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 17C3E4000F
X-Rspam-User:
X-Stat-Signature: kpub4m5x15tz38a9jeb9bpb7xfiwq7fc
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795625136-542401
X-HE-Meta: U2FsdGVkX1+TS+CRb/TGmhDkBQwKMYCq/ZHBpYPuLlVtYf11J7BOShhu94KSFB5kbUX5M9x4Eyxu7OsEDrlvWnI6lgLFv9m6QB1G89PNxEFnKcjk+WXEYQ0y1PN6PUZAbFCw7n00A/gytHBvte+XTpRpuKSCz1yrwIfgZgPKFmNVlTa8YEuerz10yirys9a5UPRvtbShTpndsLyPb6+yM0SUChRysuWhemixNBfNsjYQgWmBgDeMGsZl2wCELPDmRYgtlrCvcj0adJ2r/PtySBhgv10utilYd62rebNXd4+wMUf3HcgU+0Rpy21CfcD2ZhGepecZHSITNTZkv67PfDCPUQgdKrb5+5u7lHI2QpCLyFXSEDhqlhtPOVXR9MJrN2fCGtBs1cPHsKR3U3mLskuMxQroRunIgR8hnWOCHklFqX/EVFcdIHXOzZiGJ1r+pVZSWCqFP+MVAovNbj8pccSpHukcmuebJ60pIGbjMoR/GUMsbMDw2igqQ1r27PWrF2otkGV6Xr/bBdCVIL5v0Y8if1W8uzl1pfUnP7DpmixjJ65ZlWORXIer8v0KSlKhHF9hQRS1qJcH1G8o5Ez8YcfOhMxfFCxS7KAXzfq6J/GG/+1+zNe7Kdk/bNgQr+9IXCw+pbS6156wyKwDmXSzIB1j1Qtv5qpeZ2xVZWtxi+JtBB1TBvFxn+D0WnHzx6b7JPc0sBu7EhZGp7W4LOhffDIl4PXL9AtB5eAsA1aduRdY1cfu7CK3hjsVzkZbENYYviawR0hU6YUkiP2yIvXutUkdFOYGKe0Xx8gSstMM0YlLElUW0fBz0mKU2glWKmWob4pUAgPdo4YV+o1ZjCpsGQNnsU/SkHgP1u+3iIEjQtUjgXBVkf3E/XEu7FMZpP5GaKVhHQf/3nXjiMsLzRjiUrRmSpovL78ziVz738S3+iPQODqC1Q6PIoKQ+rXEFSPSqzS+hR+QLFM3m3eq62U
 gc0SFuow
 nKYXS8N6LdSlGEy6LbhJY6ND6pAr+9p877JddDaXD0R1ppfcrlxYgrl35zgXX74lQ5FpFSk6IT+bvq2P/7pEF2+cqVZUwPp/On2vlZSHfEhQgOdIKJzwJIh6odWAMaWjCyJs2bKlnm09zCgOW22wZnzHKMo0RyQEMmK/k2gWaMdC8euwcU292k7ac8juTHteK+DxQALUve8fufxVSAYbPsJ9d7fTYyiTzZJJKmaiIrXjKAr3SxkmlNmmesw7dHfcxGkqFEFU5MSZ6W+Di/M6iKRPZ16Aj8uAYPdKiq3jiyWYOCRZwzmRCc9l4NOCkeiVSbFoySG2CY7QJ5EBZGC/SOvUfKqq57rBg5imd6+JphrrokGOUHqzpiicMv4HINHRw0lj/IONHY84kE+FEUYO33rJGwumawAzsvzM3m63Pg8o0VBvjr3UKEUx82j1fchwZsVyLyTR/ZLnZnCXD811Ce/m6068DicQCW8do1jJLxwNZ+YWweHZdsBcwHCTFypRertsNAhmJUbmVYnjyhUiD+srh1q1BB3yZfXrJ+hEjXStep5gQvKBg/6bUOmUGRbRtgKWYX6sKFIUgUtva08QGT/huwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Randy Dunlap <rdunlap@infradead.org> writes:

> Update file names that define ioctls and update the range of
> ioctl function numbers that are used where they have changed.
>
> [Since having multiple maintainers trying to merge these would
> cause some conflicts, it would be more manageable for Jon to
> take all of these through the docs-next tree.]
>
>  [PATCH 01/12 v2] docs: ioctl-number: update MM entries
>  [PATCH 02/12 v2] docs: ioctl-number: update sound entries
>  [PATCH 03/12 v2] docs: ioctl-number: update block entries
>  [PATCH 04/12 v2] docs: ioctl-number: update networking entries
>  [PATCH 05/12 v2] docs: ioctl-number: update video/fbdev entries
>  [PATCH 06/12 v2] docs: ioctl-number: update SCSI entries
>  [PATCH 07/12 v2] docs: ioctl-number: update MTD entries
>  [PATCH 08/12 v2] docs: ioctl-number: update USB entries
>  [PATCH 09/12 v2] docs: ioctl-number: update virtualization entries
>  [PATCH 10/12 v2] docs: ioctl-number: update FS entries
>  [PATCH 11/12 v2] docs: ioctl-number: update platform entries
>  [PATCH 12/12 v2] docs: ioctl-number: update DRM entries
>
>  Documentation/userspace-api/ioctl/ioctl-number.rst |   91 ++++++++---
>  1 file changed, 72 insertions(+), 19 deletions(-)

I've applied the series, thanks.

jon

