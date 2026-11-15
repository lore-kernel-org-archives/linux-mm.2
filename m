Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 511EC606A333
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ETF5Z0WA
Received: by kanga.kvack.org (Postfix)
	id 37A516B05B4; Sun, 15 Nov 2026 15:28:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32A1E6B05B5; Sun, 15 Nov 2026 15:28:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 219E66B05B6; Sun, 15 Nov 2026 15:28:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DEF526B05B4
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:28:07 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5D770A8146
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:28:07 +0000 (UTC)
X-FDA: 85438490214.04.1485166
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id A99FDC0004
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:28:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ETF5Z0WA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774485;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iL9gs0hHi938yh2WI7Rig0yplwSjqvzkRGjQ5uPboKU=;
	b=trEXl9eKE+UwvSvDxTDJ+uO76XipILyYI/fOYVRnv8VZeWu9yVaO4QfeHrfQcpWynz1PRX
	1NmD5KXa4MihlYxEiJNV08l2zJ14Ux74zzBanpjUZeZX5QpvvaEkCcEnXIhRS/xJxL4vA7
	/4PYmaeCyu04D9CVX+xKA3UBZkOOIBI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774485;
	b=UYn+IzpSzoTp3YdkKo19YCXegIj7WQmnCSscAF/fX6G9yTUHcu4ix1TsFbQl8ptcRcgi+m
	fzCGrF8a8bJzQhASfiLWFK+UbMOVh4gj0TMlcLPSEUih9DKyr40WUVgFfTZXqDoAAvao+/
	IVcZoFzlIB3i7CKT7mrrXv8L2Ae5vuY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ETF5Z0WA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 034B441AB6;
	Sun, 15 Nov 2026 20:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DCB1F000C4;
	Sun, 15 Nov 2026 20:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774484;
	bh=iL9gs0hHi938yh2WI7Rig0yplwSjqvzkRGjQ5uPboKU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ETF5Z0WAqh95BGpkVJKfpqGcs9JI8RAoRt4nI+73Jvpwec+3LLtpvx5oLIOpOfGsT
	 GOEPDW9rPmVNyvWKj75N4qe/uuqYO9Ct+c+rkqTJy8JuSRXz8Cd8ame+5r1JLvG/3A
	 reDElin5T7+X5Y7q3072wbnRv3MkRD1vWKJ66eWwdYKSqePxhpqdkT13QWNUnnpmGY
	 uWWkItczjTLp6aObld3Ovht8ffOQ/ZvRuyPp7S9k0+Fw6T0VXIdNJKdR58ItUCYtae
	 UkRrFmwjS4VMsil7spiRSB/64XxcHyS+/KBT36lH7fuE9R+NdOThy0hIAK8YBBEQQ1
	 KRVyv4dQidmtA==
Message-ID: <sashiko-outbox-215810@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 10/12] docs: ioctl-number: update FS entries
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
 Brost" <matthew.brost@intel.com>, =?utf-8?b?VGhvbWFzIEhlbGxzdHLDtm0=?= <thomas.hellstrom@linux.intel.com>, intel-xe@lists.freedesktop.org
In-Reply-To: <20261114202653.3113381-11-rdunlap@infradead.org>
References: <20261114202653.3113381-1-rdunlap@infradead.org>
 <20261114202653.3113381-11-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 20:27:54 +0000
X-Stat-Signature: oh8kzdt94kkmx4xrrtofjib7oxj36j9k
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A99FDC0004
X-HE-Tag: 1794774485-127772
X-HE-Meta: U2FsdGVkX193v8vVdwliUzwz72aeSu5BR28g2pCp/0GA99wQPRDYUuox4UHKR4zKogXw8LzhWNKf4Ga7gh2A9HCmvJjO5Fej5iPxkPcGIlJX4rhnt37pW8u3r8wxaCzFuj3hREA/z/YMs+o0kcsZVEgyBo78vpoKIBsS8WPKe8iTLwHsKDDL9i6aQFX7N+ekzifN1trMzH0Qmt6oPOF9F+31YkKabo/60FRQuTr6bYeco8dL0kyZZK5f81/44xXaPNud8r1+oy/wiRQ2xCwo1FM2zACh9odP2SA606D7WuQNlZtSUblTUKG/8N1LP2WwBI28DsU+lrjxOYt7wPOhebdy4supYbWF+IUDYEcJe2UjxkZ/LIh5a1a2ZjwP+4DEpOR66MQKlfXcsqUZA0/AdySid9dR5TkYfFHfqH3yYlhaEJATC0nTitGAY18fzuF3yVIROKm0bwM3i3erq8BaJky/XuOUziZ65Ib55fiuVlrMzr2+HxTJ4dK2OQDeIwVAr+KNRaaNc9Z1IQ8yqfxDJa/NRPLarekvHb4Wxw6APu04XiFt2WM/A2y+y65FImka5sp6fAKKnrxtSAiF0y2w/5xOi+b0icFFtlU04L19yqXWkP/WIJub6tabMbmav4yHnUysGZzp46aqaFoXF9hCsNh0qz9tlK3pQjPFdmYIsBr5vY535PEW3Zr93H/+BC4Bra+avfDIPEp6FpCeXKC0qikbAS9kv6PF/KUtKmiB/L1Jy0q5nlhca2Z9UcY58HxQxdBVdB4zhho79oglxtbe6eeFMM/BqdnPNNV87GPjz2ouYOYyXO/rL6EWHqzv5O2MSwE+9rybzI8PdVV6EUwa2YcdU8b1vBGeA5JQjl3qeYrUKqC2lxa20iB6wiqseKmIEpcjYCFkU20wLL2/pYtUa+24TcpIINt8HC4kb5Ahk1ARjpXCZMAfpxSKGoE+Mg+4DlF5OsEnssuCqK+cdPo
 gdF4RpnX
 tqg109xccaQVFo+RyPT19GqY8+dQmgPDomFz7UNA7dar604lW5dutQ4opZhcQ1Tks9w88lY3FpSoDKxZVAOiWreuRgGTWo5p9T8dwXj8Z3EnwXV9qL4RJlkQmQQxjD/qbuTef0W5BrpFykhkoY0B37CrAtRghQRK5XMZzCVqVb5r4gX35r4+7E64oqyjUy7Z/JUMy9MusbRqc3mbKazC8XuQLJxRLZOWCxd9yxpWK/IyeyQ/NHgLAPo7yscpCPqw68kjd5YFcncJpizok9ek15Di7Y7WvjW6r6iutQlcRvJEOrPqkM7gHlCHUrkX2iYaAgbcKdtXvkEMnRKnUTOuDWsC3WHMWHcAII6HovuezL2AgB/4uSR6wlc294kEavS5EuZuYw7SwPhmiua0AOFo3uNkhcdtiEcaMyif6sc1BBY3vYXlT4TDcxBYEPIRe0tacdW5gAAmVnB9F43vz3DIGzG8pX4vEtWLX3nHvrPrZVg8gvqhokUno200ftvHKJpK+BShVMwWY+lqX1Ggq+0boKr9CZHs4g3csJgW2IorwQJzFx4akkKvH+VsQ98Qqj087UcitL38/tVco3ST+Cn44jPjWU3/5ox4/JkyRbx+fqReTg9diA2MpH8a4nnL396JTRVfdq2jlkq0lcBL+JPY1sr3UL99oujH06cI0/OARC73svLzewShtegLKltecB4X+qZd1
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
- [Low] docs: ioctl-number: ext4 00-2F ioctl range points to
  fs/ext4/ext4.h instead of uapi/linux/ext4.h
--

commit 9072a8199d2be085dc5ab2567392180faf810c6d
Author: Randy Dunlap <rdunlap@infradead.org>

docs: ioctl-number: update FS entries

This commit updates the header file paths and sequence number ranges for
filesystem ioctls in Documentation/userspace-api/ioctl/ioctl-number.rst.

> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documen=
tation/userspace-api/ioctl/ioctl-number.rst
> index 87e547be9e2ac..abc89b6288ba3 100644
> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst

[ ... ]

> @@ -275,7 +276,7 @@ Code  Seq#    Include File                           =
                  Comments
>  'f'   00-1F  linux/ext2_fs.h                                           c=
onflict!
>  'f'   00-1F  linux/ext3_fs.h                                           c=
onflict!
>  'f'   00-0F  fs/jfs/jfs_dinode.h                                       c=
onflict!
> -'f'   00-0F  fs/ext4/ext4.h                                            c=
onflict!
> +'f'   00-2F  fs/ext4/ext4.h                                            c=
onflict!

[Severity: Low]
Should this entry point to uapi/linux/ext4.h (or both headers) instead of
only fs/ext4/ext4.h?

Commit 519fe1bae7e2 ("ext4: Add a uapi header for ext4 userspace APIs")
moved the EXT4_IOC_* definitions spanning 0x03 through 0x2E into
include/uapi/linux/ext4.h, leaving only the compat EXT4_IOC32_* definitions
(0x03 through 0x08) in fs/ext4/ext4.h.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114202653.3113=
381-1-rdunlap@infradead.org?part=3D10

