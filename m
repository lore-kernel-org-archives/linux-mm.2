Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E557B606A330
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 14:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=pYQpPFUG
Received: by kanga.kvack.org (Postfix)
	id 145726B05BB; Mon, 16 Nov 2026 09:26:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11D516B05BC; Mon, 16 Nov 2026 09:26:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00C3A6B05BD; Mon, 16 Nov 2026 09:26:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD13D6B05BB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:26:28 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 38B16140911
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:26:28 +0000 (UTC)
X-FDA: 85441207656.13.F45E17A
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by imf25.hostedemail.com (Postfix) with ESMTP id 793E2A000C
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:26:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=pYQpPFUG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3jxL7agYKCP4ykgtpimuumrk.iusrot03-ssq1giq.uxm@flex--seanjc.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3jxL7agYKCP4ykgtpimuumrk.iusrot03-ssq1giq.uxm@flex--seanjc.bounces.google.com
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=pYQpPFUG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3jxL7agYKCP4ykgtpimuumrk.iusrot03-ssq1giq.uxm@flex--seanjc.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3jxL7agYKCP4ykgtpimuumrk.iusrot03-ssq1giq.uxm@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794839185;
	b=nS5smCOuRyA6Jb6MXSQ7GnarNNCwaa2OvQ6PkEQqUqW9urD/eoTMGMeyJTpAxZB7neZ2uB
	1Iz0wgosRwgPL5Ut0ig2mW1gZ3Scuhtwno04mhY4jASMp0o6O6k/VlSccqZTPnKO110Tnu
	708ASNmp0g0r3aW14Q14WbuIBzQuyig=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794839185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Julx96UTlwUpy/yEEb6XKUMDaihQ6nHqBxqUTRWWoDs=;
	b=YfKTXF7G7lmhtb5LZ8vEJftADYByLO6CmGsqLRyK7APml2ai2GhoI34WRk815mftr3oa0H
	/6VeGaP4oko6e1xOOqvkD0SKbJpnzfgDYlvEfPg7mR40/B+6KBg7nuoVINsPUqSJ045oNr
	SxsBEWLtYJaYQyIbPlvydTp8Scxlq2k=
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8b8cef34b43so4609540b3a.2
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:26:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794839184; x=1795443984; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Julx96UTlwUpy/yEEb6XKUMDaihQ6nHqBxqUTRWWoDs=;
        b=pYQpPFUGk5tM0pUSaz5I5JptTdOSLj+dcQh1JjlOj+Bd+nqvXu0LSj4zUucgbemoR1
         WT0doTL6Qf2lvWANE77EHTlepCBom45Na+n19UTjLHcYf5mytLe1oiOG36flbU+9sOk6
         ucJtmnptJUND4cTGz63yhZwcH9DjT8nz03oPkcB35nV8Yiocs0AdcdSlM8FFbLjy8sKS
         2iznIq/OcfmbLeVZmq38BnwlwOjIhGPZmlCYkcI7W7EwC5BS+olPAsZqWgBL+bSydFeP
         obSPJhg6HfEP5QOMa2OwmvQNkTIAe8BGRfK3ru7PnhrFTmyLmtLbcHkSDur0bWjFPcUN
         FCFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794839184; x=1795443984;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Julx96UTlwUpy/yEEb6XKUMDaihQ6nHqBxqUTRWWoDs=;
        b=UqWzIybSxu9XBwtYO1HrKKeELjrHol8JUwafRD+bNAk1mDWxDy5A6zwIorN4ostvnf
         uDBkfXFT4QID8n0BfHlfwNJ0WYSbJdknGnRCB5dMKRg+RhwUwpH53aQvi8Mr7AlP4KG4
         vAY8SfsN2aLmbX1ffnR0i631CWCpga6ZalX1OpcROZruACHmpAaOEwlUpTlHE2QI6d0g
         Y7S3aZC9lucgis1rIjixyNqa3sejOv2XXmxgnUfOg1GkI4i33mqU9ChhJ8wWYQwkFyOU
         qNnHOqhnLM2ICY4/xeB/EWDrGxY4kJyOtMmP7T6ZptUgmFlLAL1AfbC389jmXrMn3JiB
         DKPA==
X-Forwarded-Encrypted: i=1; AL+hErG85SmctFV9VVl9Eq1w/99wca00UBitEB9MSjM+XJOJloJhgN/C4dsFHD0mP/HSPDaEv1BKSOef3Q==@kvack.org
X-Gm-Message-State: APuU4Z80rPX/PjeIosWfriDCM3f0McIFxB3/GE5jnXTomU3Qt+CfMZeB
	yDrcEtAP1B+UZSk3WrvV0zND6Ge6Rm+oYazoiFfEoLMve/po2kalXOvoxcAYn/02kIObU+hLiQ9
	ViK5EyQ==
X-Received: from pffm4-n2.prod.google.com ([2002:a05:6a00:c304:20b0:8a0:70d8:a2ef])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4fc3:b0:89f:b166:bde6
 with SMTP id d2e1a72fcca58-8beb8cc8ad6mr9720424b3a.54.1794839183449; Mon, 16
 Nov 2026 06:26:23 -0800 (PST)
Date: Mon, 16 Nov 2026 06:26:22 -0800
In-Reply-To: <20261114202653.3113381-10-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261114202653.3113381-1-rdunlap@infradead.org> <20261114202653.3113381-10-rdunlap@infradead.org>
Message-ID: <avsSjioXqbCOn834@seanjc-mac.roam.internal>
Subject: Re: [PATCH 09/12] docs: ioctl-number: update virtualization entries
From: Sean Christopherson <seanjc@google.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>, linux-mm@kvack.org, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, linux-sound@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, 
	Marcel Holtmann <marcel@holtmann.org>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
	linux-bluetooth@vger.kernel.org, 
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>, Jason Wang <jasowangio@gmail.com>, 
	David Heidelberg <david@ixit.cz>, oe-linux-nfc@lists.linux.dev, 
	Chas Williams <3chas3@gmail.com>, linux-atm-general@lists.sourceforge.net, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, 
	Helge Deller <deller@gmx.de>, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, MPT-FusionLinux.pdl@broadcom.com, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Richard Weinberger <richard@nod.at>, 
	Vignesh Raghavendra <vigneshr@ti.com>, Zhihao Cheng <chengzhihao1@huawei.com>, linux-mtd@lists.infradead.org, 
	Neill Kapron <nkapron@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, 
	Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, xen-devel@lists.xenproject.org, 
	Hans de Goede <hansg@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Michael S. Tsirkin" <mst@redhat.com>, 
	"Eugenio =?utf-8?B?UMOpcmV6?=" <eperezma@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
	Mike Marshall <hubcap@omnibond.com>, devel@lists.orangefs.org, 
	Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, 
	linux-f2fs-devel@lists.sourceforge.net, 
	Florian Fainelli <florian.fainelli@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
	linux-rpi-kernel@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	Tzung-Bi Shih <tzungbi@kernel.org>, Benson Leung <bleung@chromium.org>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alex Deucher <alexander.deucher@amd.com>, 
	"Christian =?utf-8?B?S8O2bmln?=" <christian.koenig@amd.com>, amd-gfx@lists.freedesktop.org, 
	Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, intel-gfx@lists.freedesktop.org, 
	Matthew Brost <matthew.brost@intel.com>, 
	"Thomas =?utf-8?Q?Hellstr=C3=B6m?=" <thomas.hellstrom@linux.intel.com>, intel-xe@lists.freedesktop.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ya5szen94y1k4b4mrenu1y3457g11bmr
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Queue-Id: 793E2A000C
X-Rspamd-Server: rspam07
X-HE-Tag: 1794839185-112703
X-HE-Meta: U2FsdGVkX18tNVF5llms2NkyLqdC63F3SSzdEwN7Bmt17CD+tHoW5JUT62AChM1cgeIbIxruA39DAbXnGT/PU3HJCVCT1IP0uIOViMNwxXSQh1JC2xb6GXa4gVT3EhekSFUngN9uf5Pv+BMIeWxckiMS3+AeRdRHczQlGkqk5OzEq7KI5VyXqnHYB7Ds8mlGo4ooT3KD1rB1UoGEQYu7wvYZ2zACTIzLg39afVNVkj5AKxdi9/8JaxJvUM6PsvhSaUP+76hk2AQGPFkSaN84ledg8FvOx7b1ZC+06Kr8ZsIFLWwaAw6sgw95g/bIUmR7sqnCMlrYzH5LKyoHbpLProqlwZcBqNj2mBjQw5vvo/LpjWw6Js0Q1io6n9nL8w0OAOhXP0inwj14WH8rZ+W9xMTTwyRXHIXexlcmoFkEL54avmvF/oe+31KCZowPVlUTkbwnMgj/YIKLdSKwo+azz11brz+fDlKpGLEkn2xZ3Wih/4ZkE/+ABT7/ucdOE94BEeO5Dxs/GfOQBNA8c0hiVanBC6bnSfNgSrTkDAA9HxOaXdyKOcTuiqnk+NoW2a3G9dhwAM9+RtOeMlDd91mNMc4bHRrnjm7Or0qbczgARxKckmQv+pFwIsqcqMdv1LiV92DaQGLwXhWS8shjyH4zfgfna/27bdfblQEpG93DvrnFE/r2+0hUhr0S02kn51YPoxYMReh1pJjcw4rOcfkuXWYfn819ILIytNf8L9hGV36F4Hnt2rIc/sTG9jDVRrEInkmN599Rrz5YJoPUfXX21QJj70/zFISTp6kDjV4Zmd3l9zoeETgjfvt60J08OiD16dHABo8y/NwEgvESt0kDrtBiUZAjhta1xoTdxFX/Iy3JxDFRTkm9aDlH/AwqnJol7MWzAn53AQ/E2gmBGwilslJaBoxtXXgHpeNsovOi2FmHT/lmqZed0ARzdhkw4F1RmLfdgCVrybHerQVZWVq
 AY+lkena
 gOiHSV7CglIcF2wN4BVTJkT1agwPW8h3HFeNhvg6fthjVKY4dt5iFw7s02CqKMA+OFh1m0ZNUyqYlpudZkgQdaemXQCRhf1LbO7faWSvsdE/pwE+7U+bHzKplKvQkrSIbUHgcIHVGvYw/G6BJAH3sU5KP2yae0T7Q12YSBEPNE0tVaf172qx834KxsakAvnQR+FaBvDOg+d81zRL1C+SOMulv8AFpuU3SO9poHPxZvMjk2BG/Qle7o1Er8iEOpTRAP2Aoj2Ou4xgb9B3S+F/rz4UgaE7R35es2c07JEFQ+qNwf6mjRqZTSAdXVu/esk8VtKZ4yBIX57BpwPUW+RWIw494RsqYsFhboc0KTPj7l1pPjWRfRclG0lKMR00IBQwb8IDQy5qI93XZfgoU5D6ggtsTly/4wPRmH0bR0CeUfjVbgugOgb8SWNxwcFLb6VPsuw8KA8vm0xZZyyCIP7MO9bRmqYEo04IBUl1Au3Xeb2zNUpOpSfjHyBvbm4p6edkG+bM1GWnEuP5ZfNG3c/Vq8YyROwDzOtcSib83chLcgqg6qaELbksb2ufw1Z1UICP+0dvVxushTfkiUcZ7K/mNJylSFP//ijCpKYf/iiPnHaEcZu1OKO6XA1wRSu1CnsWl89Sl8SJUnPXip3DwRiDeV1F+ny85n0yYpcZoLgqd88g0P2zeZARorpLfSIclirx5VIY6MPQRwXV/VXgvuq+EmloGVG2r/7p4NhLImEpaTH3mpqwR0D0kLX5DSMNo3fJ+9oKqx/kq6JXFtGq4M2MB8MDgek5Nxsq/PudzaTyOE0+TTxZ51YJT9LUcrqdprPLTriNZC4MZ0BiXexYmWnqKnT8HJ2Vx71Gue5cT3wPG84NoCyqjkFp5OS8Ktp2G6MLXjZo4qmwhUzdHM2lLCHg0TLZKQdsogzCYAIHnJYkFhHk4/Z7HzdYQos3LPtUCDBh8tMysvSvSw5WpnbMh8qjEflUIxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026, Randy Dunlap wrote:
> Update the list of files where virtualization ioctls are defined.
>=20
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> [Since having multiple maintainers trying to merge these would
> cause some conflicts, it would be more manageable for Jon to
> take all of these through the docs-next tree.]
>=20
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: linux-doc@vger.kernel.org
> Cc: Juergen Gross <jgross@suse.com>
> Cc: Stefano Stabellini <sstabellini@kernel.org>
> Cc: xen-devel@lists.xenproject.org
> Cc: Hans de Goede <hansg@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowangio@gmail.com>
> Cc: Eugenio P=C3=A9rez <eperezma@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: kvm@vger.kernel.org
> Cc: virtualization@lists.linux.dev
>=20
>  Documentation/userspace-api/ioctl/ioctl-number.rst |    6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> --- linux-next-20261113.orig/Documentation/userspace-api/ioctl/ioctl-numb=
er.rst
> +++ linux-next-20261113/Documentation/userspace-api/ioctl/ioctl-number.rs=
t
> @@ -200,6 +200,7 @@ Code  Seq#    Include File
>  'M'   01-03  drivers/scsi/megaraid/megaraid_sas.h
>  'M'   00-03  drivers/video/fbdev/mb862xx/mb862xxfb.h
>  'M'   00-0F  drivers/video/fsl-diu-fb.h                                c=
onflict!
> +'M'   01-03  xen/interface/xen-mca.h                                   c=
onflict!
>  'N'   00-1F  drivers/usb/scanner.h
>  'N'   40-7F  uapi/linux/nvme_ioctl.h
>  'N'   80-83  uapi/linux/ntsync.h and uapi/linux/nvme_ioctl.h           c=
onflict!
> @@ -239,6 +240,7 @@ Code  Seq#    Include File
>  'U'   64     drivers/usb/misc/usbtest.c                                c=
onflict!
>  'V'   all    linux/vt.h                                                c=
onflict!
>  'V'   all    linux/videodev2.h                                         c=
onflict!
> +'V'   00-1F  linux/vboxguest.h                                         c=
onflict!
>  'V'   C0     linux/ivtvfb.h                                            c=
onflict!
>  'V'   C0     linux/ivtv.h                                              c=
onflict!
>  'V'   C0     media/si4713.h                                            c=
onflict!
> @@ -357,6 +359,7 @@ Code  Seq#    Include File
>  '|'   80-9F  samples/                                                  A=
ny sample and example drivers
>  0x80  00-1F  linux/fb.h
>  0x81  00-1F  linux/vduse.h
> +             drivers/vdpa/vdpa_user/vduse_dev.c
>  0x89  00-07  asm-generic/sockios.h
>  0x89  06-07  linux/sockios.h
>  0x89  0B-DF  linux/sockios.h
> @@ -398,8 +401,11 @@ Code  Seq#    Include File
>                                                                         <=
mailto:kvm@vger.kernel.org>
>  0xAE  40-FF  linux/kvm.h                                               K=
ernel-based Virtual Machine
>                                                                         <=
mailto:kvm@vger.kernel.org>
> +0xAE  C6     arch/x86/kvm/x86.c                                        X=
86 KVM

I'd rather omit this entry.  0xAE C6 is covered by the entry above, and the=
 horror
in arch/x86/kvm/x86.c is purely a 32-bit compatibility alias for an ioctl t=
hat is
defined in kvm.h (the structure payload defines an pointer instead of a __u=
64).

If it's a sticking point, e.g. this will trip automated tooling over and ov=
er, then
I vote to move the relevant definitions to uapi headers, e.g.

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kv=
m.h
index 00ce265391e1..e02ef7a39f7c 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -230,6 +230,18 @@ struct kvm_msr_filter {
 	struct kvm_msr_filter_range ranges[KVM_MSR_FILTER_MAX_RANGES];
 };

+struct kvm_msr_filter_range_compat {
+	__u32 flags;
+	__u32 nmsrs;
+	__u32 base;
+	__u32 bitmap;
+};
+
+struct kvm_msr_filter_compat {
+	__u32 flags;
+	struct kvm_msr_filter_range_compat ranges[KVM_MSR_FILTER_MAX_RANGES];
+};
+
 struct kvm_cpuid_entry {
 	__u32 function;
 	__u32 eax;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0771efaf94c8..ef9f92cba589 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4260,21 +4260,6 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 }

 #ifdef CONFIG_KVM_COMPAT
-/* for KVM_X86_SET_MSR_FILTER */
-struct kvm_msr_filter_range_compat {
-	__u32 flags;
-	__u32 nmsrs;
-	__u32 base;
-	__u32 bitmap;
-};
-
-struct kvm_msr_filter_compat {
-	__u32 flags;
-	struct kvm_msr_filter_range_compat ranges[KVM_MSR_FILTER_MAX_RANGES];
-};
-
-#define KVM_X86_SET_MSR_FILTER_COMPAT _IOW(KVMIO, 0xc6, struct kvm_msr_fil=
ter_compat)
-
 long kvm_arch_vm_compat_ioctl(struct file *filp, unsigned int ioctl,
 			      unsigned long arg)
 {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 8dff2fc1972e..54dbdabd0e9b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1477,6 +1477,7 @@ struct kvm_enc_region {

 /* Available with KVM_CAP_X86_MSR_FILTER */
 #define KVM_X86_SET_MSR_FILTER	_IOW(KVMIO,  0xc6, struct kvm_msr_filter)
+#define KVM_X86_SET_MSR_FILTER_COMPAT _IOW(KVMIO, 0xc6, struct kvm_msr_fil=
ter_compat)

 /* Available with KVM_CAP_DIRTY_LOG_RING */
 #define KVM_RESET_DIRTY_RINGS		_IO(KVMIO, 0xc7)

>  0xAE  20-3F  linux/nitro_enclaves.h                                    N=
itro Enclaves
>  0xAF  00-1F  linux/fsl_hypervisor.h                                    F=
reescale hypervisor
> +0xAF  00-8F  linux/vhost.h                                             c=
onflict!
> +0xAF  31-32  drivers/vhost/test.h                                      c=
onflict!
>  0xB0  all                                                              R=
ATIO devices in development:
>                                                                         <=
mailto:vgo@ratio.de>
>  0xB1  00-1F                                                            P=
PPoX

