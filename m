Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41655606A335
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ImwEBJaq
Received: by kanga.kvack.org (Postfix)
	id 241516B05B1; Sun, 15 Nov 2026 15:27:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A1616B05B2; Sun, 15 Nov 2026 15:27:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 045956B05B3; Sun, 15 Nov 2026 15:27:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C18596B05B1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:27:55 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 159831C41F0
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:27:55 +0000 (UTC)
X-FDA: 85438489710.16.37E9843
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6FC1A180003
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:27:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ImwEBJaq;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774473;
	b=MqLLFGAZXm1elQ8IJMKQ45cNYwkuZsfjtUvhbF4domobL028S9fpPV4ZOhZ3o0GbhFmip1
	IZAKBfPIsjk8+/cv8D/mldCNaojO9HNjDG6XRG3wPjbmfWF9WGcKiuj1tJk27MKbxy+PaG
	46eO/WpE0eGa2DHcQDmZjkOYvMsDolc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ImwEBJaq;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774473;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VdczhNN3rVTkdzSKO/1FEF2ObIEkmXp6tYC01E0w0n0=;
	b=GAPkvUzmbOL4v057ZX+i4nMbo6A91WqAaTkbdesss0jIb7rvoorUivib71N+/Bw42TiEnp
	/E0skQGSBQ/KRzfPAfJlcQW4mZyWq0FpAR94oB2ugK9JpfHiQ3Tx9G/SYyxkfWnNwMaJGl
	Zx+r/NfDsc9QY7dKQ/HozY+2YW/HcPE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B313C41AB6;
	Sun, 15 Nov 2026 20:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4081F000C6;
	Sun, 15 Nov 2026 20:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774472;
	bh=VdczhNN3rVTkdzSKO/1FEF2ObIEkmXp6tYC01E0w0n0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ImwEBJaq0nehyC/JF9/iqbjz5qT+awTRS1rhu59kzLmGMo98Mvzh4P4MxHjn3QEhd
	 LdruBaWqwycsIv9VzmTkygHkWfaHareFtghbZyuL728hNd+MhXMD1btY8h5c5JgNTA
	 F3f+HW+jOq2DAS+9cBjKYIqx/caWoQhZgT3lwtzPSlDGSljTPoOw4VoK3PwtvM2sy0
	 Jt/bs3s21iolxS8OtIFa1DXW89RWjNpR5VoGh40DxeLKfozQXUEhwhUhLyFiUHn9cQ
	 4Nc4NypjRd3VCQqb43rzmgdLn24tDFN2pZW14vSWhtim/Oa3QBHVPBQA7hCv0vA5Xk
	 RQuCq+oeh2NOw==
Message-ID: <sashiko-outbox-215807@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 07/12] docs: ioctl-number: update MTD entries
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
In-Reply-To: <20261114202653.3113381-8-rdunlap@infradead.org>
References: <20261114202653.3113381-1-rdunlap@infradead.org>
 <20261114202653.3113381-8-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 20:27:49 +0000
X-Stat-Signature: 5zz1ba6runbskrqoz3wqc5szougw66og
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6FC1A180003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794774473-546092
X-HE-Meta: U2FsdGVkX1+47xm0Tv+BvoCbPT8OmH2qZNwj8a8rZ6X4vO4/8ApNFCv/XsuiEtNYgVpsrkqpWL9VIO2Ke5YjgXjDZXIRanJ4JjiIy5PryXGZgmKwPHK0jGHadRytOT6PycViLuLtd12A2MHF6FcUwdHWsTyw5MiiekxRKFH7Y7lzKZ6LjCoAtHXgBEYLfAur01cW4EGD9lwTA3BW1PidwfszB8HVidfBjaDxgvYvWifhwD8a2YXjpCNIRzT0uJ/6JETFevoA063SkhQzu0Eb40z0irN7xh66nHy1EnCWtt+iKI59XxiHA9kOkiPKJIRLgMykO/efs7U0opDNoo/W30ioYKL/dXuiP+3CyC6Ii7Qp0W0Xs7zH726uF5LcbA9UJezzPjdZnaW3u+UMsMdsQDS8V08L4LOtPsH0WiueRorTAM/oiZO4QhtD67NcZQONa6u3fdvah+p8apFXWoWvlzisIKaPTq9aQ1Hn8bTAvr/HrBkSR7gYj5tOhRGEmhUVLs3enruyKnKI7iRM4tqV9jJJl7QaAzUY30vV1O8LG6K5xHOmr67lGzOIOFDxZWiHxgaOO5axV75zujicmgoDqAv7wemqJovIfrcIFHQrdX4l+jtbe70wBQNdVHgxokm69iiid8eh706fmsPV2GQbJ/6bXNayfJB2aXr5WUVELTjsPCcBlaA6uyXQPCCDfEo4Td86Ufe07Jxc2q+9Wla3EXWFmEc4rQpOKlhtlElANbUPbWKe5vKxJs9DSK2SJl12r0pIiBYGprpWfeBpcnnZ3HPscmlHynuPnrVVr2vssjFoHTzWDjb4XbCAY+cWRakPLqrW3xjCsUBzGvluMxYzHGThOVsy+lRKOaORRSle50HnBBCX8m1dctjmfx6yU5bEJ+Rmb/75JufC0fD3pUlMqDLW2CkH+88Yhq8gk4uP+mAsKEkpGrrP6+GmqfrXJ9SOEVDXrX0PxGOFRC0xghH
 sOWYEJje
 9F1gjP/+ajQFUXOxd+rglgY2qvzYL0mOL/3INDS7ApN+V172qjahLoLjedicQq/fCHKbj/v9szMh15NokK/MaaNBU3QRpMssmjbcXDnnnUCCfzU0rfl6lrc15tF3uSgT8xwmRSxgSmxNazmzc6Uny89R/wxd2rGW8zOMM0eK4tx7gzcIzAUkWYa2VYQhjeCgs4k+XaOqIQq5nFlO5cQLMoN8H2Hp1LGPNkJoZfMuvIu040mz1nO4rDcNstX3sE4lGJCAKniU6LYXs5IeQsZrer/xe+p9VSo7GcPd9P+GFDoU/HuNnU9TOUD+USlnUs9oGjH5cARCiVqgpD/jcDnKN04EvLARVdeVdwCP6edYwSsMOzLubsCTrY2h/xiLZAwf8xhgZ8RAGRlpKhuEBwaVmnh9HnbZsVRFcFgTpeAD4T3Z1zZleovCQotbb1tI4YM54oV08vVFflE9F1etVOo2CpToq2kdoA/HqLS4rcnB8Qn8grrN024dyAVkAtX9Ujn09SZV5pbERBQ+Un6VJGDIEYz1LRXZ8pVTT7dfM91jirStiQPHTin752m+Fm25iBnVUoqSIt6rnjkAUe4cm0Q0uP1kzvIoKRhWgabWepMfujwyi/634nzEHy5A4i3fqvivJJ6xE3FtPlokxzj3poanYp4ZikvjFe00jZ7UMDlBWQh6MwdQFbinvexbeAXTIoZmFfzwb
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
- [Low] docs: ioctl-number: missing update of 'O' range for
  mtd/ubi-user.h to 00-08
--

commit ccf1b77b46484d55fbc7ee02d93a71ebab16f010
Author: Randy Dunlap <rdunlap@infradead.org>

docs: ioctl-number: update MTD entries

This commit updates the sequence number ranges and file entries for MTD
and UBI ioctls in Documentation/userspace-api/ioctl/ioctl-number.rst.

> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documen=
tation/userspace-api/ioctl/ioctl-number.rst
> index d47f817335666..1ff4fd4bf9b5c 100644
> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst

[ ... ]

> @@ -306,7 +306,7 @@ Code  Seq#    Include File                           =
                  Comments
>  'n'   E0-FF  linux/matroxfb.h                                          m=
atroxfb
>  'n'   F8-FA  video/sisfb.h                                             s=
isfb
>  'o'   00-1F  fs/ocfs2/ocfs2_fs.h                                       O=
CFS2
> -'o'   00-03  mtd/ubi-user.h                                            c=
onflict! (OCFS2 and UBI overlaps)
> +'o'   00-06  mtd/ubi-user.h                                            c=
onflict! (OCFS2 and UBI overlap)

[Severity: Low]
Should the 'O' entry for mtd/ubi-user.h also be updated from 00-06 to
00-08?  include/uapi/mtd/ubi-user.h defines UBI_VOL_IOC_MAGIC ('O')
ioctls up to 8 (UBI_IOCVOLCRBLK at 7 and UBI_IOCVOLRMBLK at 8).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114202653.3113=
381-1-rdunlap@infradead.org?part=3D7

