Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B2D060A260E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 05:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eze1Mzwt
Received: by kanga.kvack.org (Postfix)
	id B8F396B00EF; Fri, 20 Nov 2026 00:36:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3EAA6B05B0; Fri, 20 Nov 2026 00:36:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2E336B05B2; Fri, 20 Nov 2026 00:36:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 755256B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:36:11 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8797C0D1A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:36:10 +0000 (UTC)
X-FDA: 85454386500.23.F8A7914
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 330231C0004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:36:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eze1Mzwt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795152969;
	b=0x3mYoyjZ+zm3v73IGt6zOCo98rvDU4pip7hVCxlGQP7ExIHBGprIqMWPzW2x/4qJVDEhO
	FDoOE4JkIY1HHvEgOHIQi+tLMlOoDXHYrPE2vj1TeoXfHjMkq33eCTqxUhJVVIKNfBKgMf
	P6wEj9EuP5O5jgT/CH+bJ1MoD6u5p20=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795152969;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tqyp9zPjjrIezYjpSAwpdJah8XiLFf3uLh8Q8IRH3Y0=;
	b=UVLf4MsM905DLcK/nMpUJ19fuQubaMau06hTgg4l7AZATYZ1VCHED277tpRy5+wRTpqfLM
	sEOjgy5ZEnyskyBxtCe8nAcgGtF1U6q/hlf4FxRnTv+4oPN5VgqFkXTzNYJGH68+rqDP4m
	bmdWlt77AzizGsMZ4yB/Fj3+o42tlL8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eze1Mzwt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EA1844139C;
	Fri, 20 Nov 2026 05:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9EBB1F000CF;
	Fri, 20 Nov 2026 05:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795152967;
	bh=tqyp9zPjjrIezYjpSAwpdJah8XiLFf3uLh8Q8IRH3Y0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eze1Mzwt1W+/jjpdnS4Mc6QQGi7FHo4IRG4Jao3lIte7M/tv9sgiqFgzFJgqdn1Wg
	 CMDoNFUjH0MKHAMwCYD/g6xavaGlisejHwL4hdvtHm5aASz1Z2O5amwKoGDupAO3Pg
	 IdEqIV9EyTe5Ck5P8UoEA4oJnX0znhaLzxBfrxFlP36lsgUFxdOFykApvtM9pKUMjo
	 L3EoiQUfJrOlHG4kOs2MsDsE1XDy8gKBjGRm/AASTcV2+72O/kvXJKm4/bXo2bihfP
	 31CDZ1VR4ONh2hBQe6FEep0/vD70MLSZVOEiI8zDuP09QLwQKmpmLnM8q+MaS+9kRg
	 X1V0IXqJoOkqQ==
Message-ID: <sashiko-outbox-224494@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 02/12] docs: ioctl-number: update sound entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Randy Dunlap" <rdunlap@infradead.org>
Cc: "Jonathan Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Jason
 Gunthorpe" <jgg@nvidia.com>, "Leon Romanovsky" <leonro@nvidia.com>, linux-mm@kvack.org, "Jaroslav
 Kysela" <perex@perex.cz>, "Takashi Iwai" <tiwai@suse.com>, linux-sound@vger.kernel.org, "Jens
 Axboe" <axboe@kernel.dk>, "Marcel Holtmann" <marcel@holtmann.org>, "Luiz
 Augusto von Dentz" <luiz.dentz@gmail.com>, "Willem de Bruijn" <willemdebruijn.kernel@gmail.com>, "Jason
 Wang" <jasowangio@gmail.com>, "David Heidelberg" <david@ixit.cz>, "Chas
 Williams" <3chas3@gmail.com>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo
 Abeni" <pabeni@redhat.com>, "Helge Deller" <deller@gmx.de>, dri-devel@lists.freedesktop.org, MPT-FusionLinux.pdl@broadcom.com, "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K.
 Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org, "Miquel Raynal" <miquel.raynal@bootlin.com>, "Richard
 Weinberger" <richard@nod.at>, "Vignesh Raghavendra" <vigneshr@ti.com>, "Zhihao
 Cheng" <chengzhihao1@huawei.com>, linux-mtd@lists.infradead.org, "Neill
 Kapron" <nkapron@google.com>, "Andrey Konovalov" <andreyknvl@gmail.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, "Juergen
 Gross" <jgross@suse.com>, "Stefano Stabellini" <sstabellini@kernel.org>, "Hans
 de Goede" <hansg@kernel.org>, "Arnd Bergmann" <arnd@arndb.de>, "Michael S.
 Tsirkin" <mst@redhat.com>, =?utf-8?b?RXVnZW5pbyBQw6lyZXo=?= <eperezma@redhat.com>, "Sean
 Christopherson" <seanjc@google.com>, "Paolo Bonzini" <pbonzini@redhat.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, "Jan
 Kara" <jack@suse.cz>, =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, linux-ext4@vger.kernel.org, "Mike
 Marshall" <hubcap@omnibond.com>, devel@lists.orangefs.org, "Paulo Alcantara" <pc@manguebit.org>, "Namjae
 Jeon" <linkinjeon@kernel.org>, "Jaegeuk Kim" <jaegeuk@kernel.org>, "Chao Yu" <chao@kernel.org>, "Florian
 Fainelli" <florian.fainelli@broadcom.com>, "Broadcom internal kernel review
 list" <bcm-kernel-feedback-list@broadcom.com>, "Tzung-Bi Shih" <tzungbi@kernel.org>, "Benson
 Leung" <bleung@chromium.org>, "David Airlie" <airlied@gmail.com>, "Simona
 Vetter" <simona@ffwll.ch>, "Alex Deucher" <alexander.deucher@amd.com>,
 =?utf-8?b?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, amd-gfx@lists.freedesktop.org, "Jani
 Nikula" <jani.nikula@linux.intel.com>, "Joonas Lahtinen" <joonas.lahtinen@linux.intel.com>, "Rodrigo
 Vivi" <rodrigo.vivi@intel.com>, "Tvrtko Ursulin" <tursulin@ursulin.net>, intel-gfx@lists.freedesktop.org, "Matthew
 Brost" <matthew.brost@intel.com>, =?utf-8?b?VGhvbWFzIEhlbGxzdHLDtm0=?= <thomas.hellstrom@linux.intel.com>, intel-xe@lists.freedesktop.org, "Takashi
 Sakamoto" <o-takashi@sakamocchi.jp>
In-Reply-To: <20261119053514.255348-3-rdunlap@infradead.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
 <20261119053514.255348-3-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 05:36:04 +0000
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 330231C0004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: oomnbxbhhxonndhik6aa4n4p3pyxiyh4
X-Rspam-User:
X-HE-Tag: 1795152969-142463
X-HE-Meta: U2FsdGVkX1+TNPr1rN60P9HU9GZDR4Z6j9Sl9BUkMKaNZAn+j/qs45X+NjPQajjNcE2q/NizdfnASuU7fNNoVA8u4CFip9HxKbNd5ry37NuNCZEinXqLXIdqIzSNazygEL46vJ+0p5msevvNMHJUslKuwL4IWWy4H1yy77s7W9Rd52NahN4SMY1zESGOU/Mr1s2cb1xpHH/KyLRHU8BHx7dethUzGQ+RKtbGKHqmzH908BD32bAl8W5cAYEyZwzjuZnmUu18QeRfm++ztS3HkT+ESYkMK/6dWPFkDQD9KP9XGHsIESV4GSWW+3g1CIH7S2op6WKzlhXgt9fhcGhsVjb1l5PJh6NdV15prajx1knORo8SR6eeagnJgOgvW/ruOpU0ISJhHPZ59+rWG5xbcW4F+6hWE+sMODCzmQxhseXCTL4pr3SVlKzatfoMdx7A+BOYQWIrXlElde5dMBNRBKxBKNEZCRLAmTDFMZBgMUEbiiLuOC7awta6+UZt6KuSq6/CKLFZCENwqfpX/b21JaqUX3FgGoMuZkRCPo3Jq7EltrbVns0bHM9vfypslIZybg0GaOCo+fwzNv9Z1nN50i5hcy9+tyHgd8i6SJ2Cp/tKpT14qenQ5yCONPXHWIFyLg+pkKfBxLGmtyk+l7TaNtM2FRR0tzogDQZrMvqYz3Keghj/0B9d8v/8py+ck7pj8L5dxXKB2Qo+4pTrxWDzZtgKKm2UNdt8kjgNRgJsJNATDt5V97jKKPygXrYfWBG4oSCxs5phD5rGF+IT1OJ/1pGoCA8Yg4mgmF/6mBtyWgNlVTl9AwExv6Q7Pe9yXoHS9vIFB+sor6PhirQmHofFNtdrtoE8R3S27b63MMUP4QGGszA6Agq1iQQjtGF3CfkuuHX09rB4hlpKrwmFXTNKph3X4tit6OoQKLoTVZ+n6Q5j+eenoxSC4oCSNMpe2xvXoIkwBksoDa+Ie/0YYqP
 ScZwdCtt
 fS1SBMwaiWZR5MIiLMhBpq6QHk67bMOHBaJQG/XK0LYYB5xhIbxqvtAqRsXcrGS39T/mK3DuU+PAqiZfcXq3Qeww2KUr+a7VaI+dajqWEDRKu8CFNv8ZTw3kUlt4o6V6Ictt7oFKVqNTiWxpWoPXPN88M6DbmRKopbeMeQRJ2jMuc+oNeTQv+3ZoZDMrYTfKkBSD7AaOMNx6kuArAaDcGdU313+/adp5BTS2t5Ew/lEhqLF3YXO6yg93w12+FUOquDRvcaLZYCJxQb0Pnha5VuOJr5BHLdfRKm0YjuZ9UO7sntQQyrmuzkvlXyntS51BaQUW4oC8uGrQHjVeNcxeQvgxvyYvxrgVk4BTUzZId4nhJ2Rrf1rK9Cn2RDN5ze+bmJJa7K41uM2lGPMMCCbid3oiDqwi+CR5YjOFlWp/3cTAPZFWnP2h35n201+InhTfff8huo7XbMpgUjQtrQPUxtSoMKioFx0A4fIJ2VI2lJhw09gAPLmPntaaGLA1Nja0sNHQyk1THD51PhGphkcBN5yFs2UK/BMcCiZ18qzpl3tA+dC4WGZMsmXYlVRy3qlcoaAHz9rP5pjdHXVULh4a86EP0umvEPK8obmuTDwf19PNYGKPun86sXTrSupDtSFSH0C2AGaXp9s8m63/lep6BICFEe0qgX6yfUEgeoXIt1TgCJMhjqM8XVyE1E0xX5D6iXb/FIbiMtGdbGhESvIEOa+YsS3DIP3fbjbRbI1Vc20AQV+jL1bc5xNwz2Ix3+z1fdAw4YxS8sber1oOGvQjlgnSWnc4zoQdIVLUdJSIORFaLvd4/1ND0Ixa/+CYl1lgd56Y0h+pDW3pJKQ1MSlpPAbjvyABnryhy3rUeAkv+ABceEw4Cv1kHye9DsIHntoYMjtdpLHtzz2qMgro0OgY1bcPB4LwseIACO2+JwtCKRzB4XSo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] docs: ioctl-number: incomplete sequence range for
  sound/scarlett2.h
--

commit 93a4f635ed001735e939a3dc4a2526e8af9e9bd0
Author: Randy Dunlap <rdunlap@infradead.org>

docs: ioctl-number: update sound entries

This commit updates the ioctl-number documentation table with additional
sound subsystem files and sequence number ranges.

> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documen=
tation/userspace-api/ioctl/ioctl-number.rst
> index e1d56d5cccd14..f29d2c17ca7b9 100644
> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst

[ ... ]

> @@ -204,6 +209,9 @@ Code  Seq#    Include File                           =
                  Comments
>  'S'   80-81  scsi/scsi_ioctl.h                                         c=
onflict!
>  'S'   82-FF  scsi/scsi.h                                               c=
onflict!
>  'S'   00-7F  sound/asequencer.h                                        c=
onflict!
> +'S'   20-52  sound/core/seq/seq_compat.c                               c=
onflict!
> +'S'   60-63  sound/scarlett2.h                                         c=
onflict!

[Severity: Low]
Should the sequence range for sound/scarlett2.h be 60-64?
include/uapi/sound/scarlett2.h also defines
SCARLETT2_IOCTL_GET_ERASE_PROGRESS with sequence number 0x64:

include/uapi/sound/scarlett2.h:
#define SCARLETT2_IOCTL_GET_ERASE_PROGRESS \
	_IOR('S', 0x64, struct scarlett2_flash_segment_erase_progress)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119053514.2553=
48-1-rdunlap@infradead.org?part=3D2

