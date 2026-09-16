Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01C05C88E7F
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 18:31:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 047CB6B0092; Wed, 16 Sep 2026 14:31:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3ACD6B0093; Wed, 16 Sep 2026 14:31:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E28C36B0095; Wed, 16 Sep 2026 14:31:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2C706B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:31:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EB7DA14080C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 18:31:48 +0000 (UTC)
X-FDA: 85220469096.19.D21E3C0
Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	by imf01.hostedemail.com (Postfix) with ESMTP id 06BD74000C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 18:31:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dvG8jVh+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of dmatlack@google.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dvG8jVh+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of dmatlack@google.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789583507;
	b=7tdXcdAgjwFRIrZdNF+/KsUHPWzFmEfzVokQdX7bVDP8A7jIMpzMJ992pYCff0AoUHEcnq
	SjbMfB38mzPke1JLtlPBKbgNFkS0yECEkK42r2FmB4s0dcfY4um2vVWQTx3XXRXr1hkFMp
	jTbdcGuwVUUFkuEQRVnG4v7Tyj02IcI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789583507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c2N3q/7Juy2glVDKTIb/78eRKEUlwWWYByVLZXDb0dM=;
	b=4dHmQ3BWSjTSGSJi69IkeVaXIzp8ba6Yts1hKHSHaabmqQ9aJ+0P5HQ7zVH1BcVU0zdDWZ
	OX22gslSZlZZawfMrAgBtSR91U+BPfoxrcqjeKkFHcVujzLlzCDOlkKvl2Zxaek+VYGADn
	wnrvmD7L3+5E0BYHo7gE8m1V0+fRUhI=
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f6c7a4aso8049366b.0
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:31:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789583505; cv=none;
        d=google.com; s=arc-20260327;
        b=ejRhSd3q2+4UmCNy0NTrBdcJGVY3PtyBpVL1qAFKr/mLH97uJGgpSmLS9lNDcUzxwa
         WIl2m/GvICIKXAdKswkngMojFojXKAk+C2XCU3GMyytHB91RxnZ3DcE3rfWOBr00cXPW
         Jh9dBnLvCXlpI/4Et4xGVED1kGnddww0ZAgj5445SmgyO6T67IrJchjzBaMY0EJD8uDf
         SNOc48sXp5rEgMPOc41EEYpiics7up35ygFvJK9PNgxMwjNYgswBYW8O8jEnUDeDhtdh
         BNziAf9jU7sgrx+xYmyqMf/kzRFzHFUMkLxIpsHqoQ7bs06afXulRtEZVW4ySqqle5c8
         7u+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=c2N3q/7Juy2glVDKTIb/78eRKEUlwWWYByVLZXDb0dM=;
        fh=cYzPXTXZ1w2kwCG8rOo7mO2aY523QW72qPtCPMaxMFs=;
        b=aJ51HWDZUzQPuVsT5cf374RZlENzXk68SH9T57xYiy46CFpJkDtRGoIGuE6fplGPme
         wjslyjrGJxLWI1PcMMrg+T6+j8NzZj4w6eJDP6105cIiBIGOp3vdwXD8l7p/5va7hm5v
         8FwK/CEjw6t+ZfSTUCQSbau0Jamrj2gId+IgSRprjuk7y0CkHZOkottTIb228oVAYKjc
         N4KqsacPGvLJCscIRLC2oy3D9VkWKLTgbfBPZBbVuZq6QRXIjzwdw4lZ9HE/GVVLs1bQ
         SJ3IVBc6W/uqOt9YuSy1i0yK/bPZucucN4ahXJ1FkxLfQ55zY8orxmYL1hLsGLwQameN
         fp7A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789583505; x=1790188305; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=c2N3q/7Juy2glVDKTIb/78eRKEUlwWWYByVLZXDb0dM=;
        b=dvG8jVh+3hovsDdQMMmsc0PGuLsjjRMC2AHpafaLTjZ5NIkLUKKvH77yZ+8ayOziCp
         qeHN9AS4CfpHIcennL2ZQ+Xo4Fbuqh5OMZCj43XPhg5dLnvcHHPhapmPepU7SsqBb5hc
         quZQNpombZ20eMpKwVIz0SP2FTbwDhX2hF6T7tfgMBxXsWF6IZYT8OLKbYqSmWjkBrQl
         oDgcQwBSgzNSlTCfyW7waMg6mDYqMeY+V2LXqoGrTu7lJ2jcY7LF5GwLXrs2vnhRdHil
         ZFa6TF0TavZyxC+qdnyNdofnm80Dvnr09epJFYgvAmEyA72Y1iO8n5ytfTtymkK3B5Im
         UbTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789583505; x=1790188305;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c2N3q/7Juy2glVDKTIb/78eRKEUlwWWYByVLZXDb0dM=;
        b=KyW8gPzoNIG0H4AxFHG5212nuP0HWx2sMSgHqZ+SZ4u1IMYO0cC4eghzf7mrEWiVma
         +jyNNBH08KxI9GjcmSeqPm7jAJ0DYa6hVXe7z+zZu9UsVqD9WrgPQyKpO3LNvYePRFAL
         NMxhH1LYJvO1OlKjF2YpyVGVwZQgodkZPNMiVW0RJ277MEWIIN6ZMMhgjmDmP52Z1VjD
         qdFLqMovSIGWP6+uho/SUj3fxPyAWe0RPFRmZH+QI5ovLtnR/tcvo+QHljkrkzLqwnIh
         gWqItGW1vsCe8qvcsjfkuodKJ9bunfTSjTfrBoFexUbN5yRwOXs61Xuqyo1AirXGG9q/
         r80g==
X-Forwarded-Encrypted: i=1; AKwUvBy03+9YIrK4nfo1nEPZwsk1m8sNPc/VZswPkJENvvmBQDmJlgh/en6NiCvtSW6J3AZifLHHPn/C7g==@kvack.org
X-Gm-Message-State: AFuF++lTMdQzXdlXGDW+8yypybYBJmcJCfp0Fdj2L0qvywnywHggC4PL
	x2AUu2baGlMWfkuY9sRVURsoo9PMRfynmVJSVaJ2dDv5UR9uPgK0hLM48ZkmoRtBVkLI6BhKEy6
	PWlo7+V1NBQBpsVYwfQxs03VYXNrvHWj5Oz17rXoJ
X-Gm-Gg: AYBFou0sYEK0hlh0iyt86Y0VLkRKXSWRCWl971lTdjVWxi0iaTKX+raKtyMMA1spa3i
	xx+uoA4fZb3eRLahvxvU3qnrfvz0HlpX13b+SLzDNvh6COB5w69YKs2vIKnGoKJwoGGJYQyABPL
	3saENhio5ZhWysW3t9W9MFB4vgPnE6KQ4iqYXF/uob77IFlUS9DNwsADeHYtLoCHqIhkVbmr5wU
	gCUhKg1WSWdVDLwm/Cs91aUkCWK7QbK03ApH2HPthQ6NMIiwuoUMKDkqunCkFOCWygTeDRMPRao
	IwHScug/lxYo/Y7uNY7OxboIUY59EP9BzhpZs4JupyJjqTa1gKyAyo9Eb62upObNoPyTFDJlwlx
	fW6ac2mUvG+Y=
X-Received: by 2002:a17:907:7287:b0:c26:1649:47af with SMTP id
 a640c23a62f3a-c29e5308ae2mr282051266b.37.1789583504840; Wed, 16 Sep 2026
 11:31:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260728221007.2098560-1-dmatlack@google.com> <20260728221007.2098560-4-dmatlack@google.com>
 <e099cbaf-3185-4c39-ae36-7f0e074ebff7@linux.dev> <CALzav=eX0gVrbWCnYGwfqPHUkoVxqdr2nw3Tx6Aqze0XOcuwzA@mail.gmail.com>
 <2vxzcxud6ol3.fsf@kernel.org>
In-Reply-To: <2vxzcxud6ol3.fsf@kernel.org>
From: David Matlack <dmatlack@google.com>
Date: Wed, 16 Sep 2026 11:31:17 -0700
X-Gm-Features: AcwNN1Xd8nWTyJ5g1jf7rTHS0mmvfUGKUHwbATk6Q8e84nhTP92-8_DCKmvtasY
Message-ID: <CALzav=eBXsaZKNv1SNtuT9F6aX_2TS3u5kUtko5WMv2NWt3e+A@mail.gmail.com>
Subject: Re: [PATCH v8 03/12] PCI: liveupdate: Track incoming preserved PCI devices
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 06BD74000C
X-Stat-Signature: zzhuk7ggpkucnqfttk9gmbkyhaco18cm
X-Rspamd-Server: rspam01
X-HE-Tag: 1789583506-910773
X-HE-Meta: U2FsdGVkX1/FjIWF3h0j5fi7mTkXyuGH5I2QTJMxmGxT/kfBgSaJPFXiNWLv6UQ1igiQJx5KQonNjY01dSw4DC9dYWsBoEz/UVkg/jBUb1MWNv48JiuS+OF6GTzuidGZZ5kZ0dMsykz+WKzbz3eeuv8D8keuO9nlwTv7FS5tfXs+FlGlgbp5HV1QBCF/QVGQGrEZkyg9yem/tHj/bUEL1FFOoBL8v4hbFQDRoowR0GTpUF3nU9SDNwgmD0s1kd9N6UzF7nrt8vsk1d7EKMcmsMtiGLoEUbSdoQimcVq8+j89NVITxYX2izHTKQ5akwhlTllDNpcEUVKmATJfxbMb58VMLeADFduiqwlqOvlj8S3TEspqtNm2vfRXq7V3zRy/V9+XPoXrvVoVcjf69GqBD6vyHMam5/3Q7kX/jJZtSv/unild2ollp4JIbaBZqvVUDhU+gDMsr5LK7RhhJRRHLprmEojjHzldjvriTXBKXlkUmkBZm8hptWbX/FMQgp4rR7GZzpJszOIzPe3emffM8gmPI8xnMWrGV0Y+6FoYrNNRVTSkhLgpg1gIlEQx7nY2jWySMXHBXUiYggch4zLWlo23NP3rfMeDmBy5HuiBHyt39wrbt/A4ttafavBr9L3cCjl0rRMUF1OSJC7On2qCoYsbTZZEhjSs+5kkIpgL7bpP/KHNWAYIEnczXLXRNevWC0J6gHX1YW22j6qhiuKkjsutEW4gp3PRneI4jU3eMpgaAMStB78DCRO6LuwMJ98v4/gjwp26hp7hHIQ4z5Vhtg2q214Z5BFmUWfoSdZO1Kt+je/ccAyaYPZ7jKZB4nuIoQdjg0nZVRNuY+UG83zfofmyq1J77Iz8+I0nB/mzCc+Qs3x92Jq4kgLiUMIMlpIn1THp+JOJ85S5alXEja2TQG9vPavxdeHzF3AbCmgqbs7Fy3oGcgs4kTDHtok2zcpkiQ/5zhA52524BL36URl
 fpEU820t
 5p7M5dihQKXoKXqWMmayAdtA/zeyuwxXHantMuVjNeqQx+tgDeI60Ea2crwmiIHkobpnJyntyXalitJ0cnBTaJqkqKTVpzQ/8T5kNV0jdAUwCpyktC6R0KAxVx/sqPYlD6zTYUAQhiYJtdNT3tbl7P0uwHgshKZ8V5izIsReNKJa6RCLjzWlL91dOI8jacujB8MDeTLy/Giv6nv2Srn+7jsIf9rlho52g49Gskgdz4Gof0WWtf3SLt14AGwWgpC1I/M1t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 11:25=E2=80=AFAM Pratyush Yadav <pratyush@kernel.or=
g> wrote:
>
> On Wed, Sep 16 2026, David Matlack wrote:
>
> > On Tue, Sep 15, 2026 at 8:31=E2=80=AFPM Zhu Yanjun <yanjun.zhu@linux.de=
v> wrote:
> >> =E5=9C=A8 2026/7/28 15:09, David Matlack =E5=86=99=E9=81=93:
> >
> >> > CONFIG_64BIT is now required to enable CONFIG_PCI_LIVEUPDATE so that=
 the
> >> > domain and bdf can be guaranteed to fit in an unsigned long and be u=
sed
> >> > as the xarray key.
> >
> >> > diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> >> > index 3781e2b5f095..8af20f558086 100644
> >> > --- a/drivers/pci/Kconfig
> >> > +++ b/drivers/pci/Kconfig
> >> > @@ -273,7 +273,7 @@ config VGA_ARB_MAX_GPUS
> >> >
> >> >   config PCI_LIVEUPDATE
> >> >       bool "PCI Live Update Support"
> >> > -     depends on PCI && LIVEUPDATE
> >> > +     depends on PCI && LIVEUPDATE && 64BIT
> >>
> >> One question about adding 64BIT to the dependency:
> >>
> >> As I understand it, enabling CONFIG_64BIT essentially means that we ar=
e
> >> building a 64-bit kernel, and a 32-bit architecture cannot normally
> >> enable CONFIG_64BIT.
> >>
> >> If that is the case, would depends on 64BIT be necessary here? Or is P=
CI
> >> Live Update already inherently restricted to 64-bit architectures by t=
he
> >> existing LIVEUPDATE/architecture configuration, so that this dependenc=
y
> >> would be redundant?
> >>
> >> If this problem has already discussed, I am very sorry about this.
> >
> > The necessity is that the PCI core needs to store more than 32-bits in
> > the unsigned long xarray key (see the snippet above). The dependency
> > on CONFIG_64BIT ensures that unsigned long is big enough. We could
> > probably remove the dependency but I would rather wait until someone
> > with a 32-bit build has a real use-case for using PCI_LIVEUPDATE
> > before putting any effort into it.
>
> KHO or live update themselves don't support 32-bit platforms and there
> are no plans to do so either. So I don't think you even need to have a
> dependency on 64BIT in PCI_LIVEUPDATE. Only 64 bit architectures define
> ARCH_SUPPORTS_KEXEC_HANDOVER, so PCI_LIVEUPDATE and others indirectly
> inherit the dependency.
>
> If you'd like to be extra safe, then probably you should add a
> dependency to 64BIT in KEXEC_HANDOVER directly. Though I think that can
> be a separate patch independent from this series.

It should be in both places then. PCI_LIVEUPDATE explicitly requires
64BIT for its own use of unsigned long, so it should have an explicit
dependency. If KEXEC_HANDOVER requires 64-bit for its own specific
purposes, then it should have an explicit Kconfig dependency as well.
That way if and when someone wants to add 32-bit support we know
exactly which configs need to add support.

