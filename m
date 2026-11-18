Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0A83606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 23:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=jMmSgLdG
Received: by kanga.kvack.org (Postfix)
	id BB3616B05B4; Wed, 18 Nov 2026 18:18:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3D676B0642; Wed, 18 Nov 2026 18:18:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DE556B0643; Wed, 18 Nov 2026 18:18:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 724456B05B4
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:18:07 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 03D23C08E2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:18:06 +0000 (UTC)
X-FDA: 85449805014.23.300633F
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf06.hostedemail.com (Postfix) with ESMTP id 00BE0180002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:18:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=jMmSgLdG;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of dmatlack@google.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795043885;
	b=Lpmio/r8TbTSRJbtIZRHVGl3RJgA8LTtvKACt2/c78Z+yXdESEcR+ml3DaC5H3NmWxu7qJ
	+Cm96O+YbguL4Ov4oZlBROiNnypmoKSSgM5KzHYHAIhkPeb84bMrejlLxwYl1EAGOdAVdI
	ODzSMkaJ0/5q+1UEcz+qPmCN7QQf6xk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795043885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JPC1RAeyqbYuGOqMmGUi58uvgG+tJSEuOdphvL+a1Uw=;
	b=k0kxozlVxiKbKEcK9TpEGjWad2E53dh6o1ek652r52mqXIToJDxyCbTmQOGfKo2JYv6pKD
	mpwSUD5osRmU2JrtnnY4mtd3HPE/2Tj4uRLEfFkHrI6uSeBGxjRJs6350JlfXOzfN4wCKd
	s7EFWPnYZIbanY1fZLLWy53r7RiyZ+M=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=jMmSgLdG;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of dmatlack@google.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c40e30c26a4so78788866b.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:18:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795043883; cv=none;
        d=google.com; s=arc-20260327;
        b=a0MqKk/OlMd8n8KKnZyrOfUeNXrbY3xrMmHy6BwVQIIcqHOFvGbj00Wm6P2Ygygruq
         K7SwYMQuT5jgdmI+oPMECpCFMsRD9Ok5vz2q1hulh/tenGfPiGbnRKBOf7HTwaDnb5eP
         skdjO398pBBKzqRQMIwcEwccf2YcWmYUmTYTQn2zL71yQARFuuuCAJyqPHauknWaSvfM
         fu7+NCfCNwSEAbEr6BWpXbwqHwQUjyJxIlLymr4WDWk2gZwPmKuFAun0N0a1Me67X5KQ
         kuLTaJC3DzdnYUMwPTs1PpYiZ4ZwW6pI8Q3zN68HTrMAom/JTogHgUGUhfVK5sCCyobE
         jLTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JPC1RAeyqbYuGOqMmGUi58uvgG+tJSEuOdphvL+a1Uw=;
        fh=Sd0x/0IX1Ayaehcjlv7OqnAK2r9DuxPBVl8WqGGLvkU=;
        b=hMT/y5MCDfNibKru6KvL9/HqFVe47+MiOExMiIaq285AfM18ppjk+w9eK+OuPHjs3g
         y2oA2jyRuzs9RySyM6bq8rrHPrUblsQRsVWv1CouJNEF13JZaShHR5WBYChSaE3jXAkz
         2FP6TVoxf6Hxj6PmPlbVwXXmBmJfZw1jA7OZDTTTZJ2GH2UU+N+TXxUzGNeIu0R+Dlge
         rwAGTCgbIbv/0N9rC3guxD+117JGPrmtomtFreTi6YzLvt2Znzu3HTTqSH0w9feOChfR
         201g85D7dH05lfs1vSWsGCFwD1/o+PxUbYJakEjEMkmJSmKuTU0/ygKDOn88NIboO61n
         bv2Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795043883; x=1795648683; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JPC1RAeyqbYuGOqMmGUi58uvgG+tJSEuOdphvL+a1Uw=;
        b=jMmSgLdGJTx6RJZ2r/JsqpeyQhx4EWNvnNqaVi7Q79O6qtyyNcgm0lpJdfCdRTUH7X
         H5l3Ln6eFLN3/IsqfntAiGF6G4RGeOkhyscUjzJ9bZbF34/SNAvyaoKrTmath0NCdkkD
         szJmw50zClzQbWRJy+0InOyc+HAqn2f32IM1zxZPSDWn+LmAJ7HdqP9GP4sF0RRwSMS9
         bmcZlgk3qwlqvd7McUQXxfxDNz4bAZ9M83/z0vZ7PGgYdOM+H3Q91tvJ9UGLHFX6XZlQ
         iAHpItOkHF+34B6EaVy8eiNX3x31MGDR5Juve27+/6GLdq7TvjOQuxGLLnkJpweMUCIX
         +w1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795043883; x=1795648683;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JPC1RAeyqbYuGOqMmGUi58uvgG+tJSEuOdphvL+a1Uw=;
        b=ie+po/feAVZwDQv/mXe1jof25Dtany+8b1CLPOUPdRhIPWJQJQafNef/Yp47Ru5+A0
         o05MSUvECpj5XAJJjuKxMQkqOhMfy5aYudTCypHSo/w+mnlAse+Ci2qYvFFwt41d3V3k
         R/lkcTubs3wIJIDZgC32dU3BSkp0HZKVNnjAL0LuXFmMUd7P1qbQmZifdXeUCi3L+7oo
         eCWhFYbZuELlXaBGqQFRtkh+9akGi2upBYONUB8vGerLLLDS3tWAlfCEpMcPj8MsBsX+
         b+HeOT571upH3lTL9IlcvbFMhdPDUxOpGJBtUecupC8UHoIs2JExM5MMWovKz/8PvJuN
         egYg==
X-Forwarded-Encrypted: i=1; AL+hErHHaMTXH4dzorVvxnFC5CH/EYgv1nMF/T8koMUgEfl2xKw9aynkKJ52yff3zEa6izsjJJQT0ZGPnw==@kvack.org
X-Gm-Message-State: APuU4Z+2eBe8lTCYpNNdLOV0CkvbG5Ep7R6MkEPIyFSEnWZiUfyr2GIy
	uzRaeFHqnjy5FqiJMSWUWtSOSLNCMl4vomo/Sxo2witZwtV+nnzHzZIUNdtdBA54NUvHRE6skPR
	8TOpBWXoCbUmy8MtCxh4lAp8arK+ksbStYZRCOvjW
X-Gm-Gg: AYBFou3Vd+wuJhicP7k4lQF3dcFqmh0BOPeouTknIUr1t9mFHQVXUj1549aZ4pdaAMo
	ALhvyY9tZg/XUc0cSwSXQ/GGLXdx8FAg/IzQgLLrkhgk3p+BA1DXPGD8BcZ/KDHYGdYsK2VcdZB
	O6A3nsVFzMtw0xJfYR9/c8vDVodoJls4+eLMts+wrp13l/DBi+ksFv+WiIrtsElZLrJcA3H1loc
	ZazFCdiScoOhgDw3CdxIkQQp19Dx4cSEiMn331Jd4Kuidm1SE6eBuo66XGo6p5NuUR5vjthVUph
	WoTo4kqFXNNOkB9lcqTAfVN2HOthQDNGGzDLGA2rH5W1tk2ZEPKC+1kv0UQhe4clvAahAYTtWiD
	WJv+SkaHLqYvkvGsQ6OEM4eQvvrZUYCmFL/WHiQ==
X-Received: by 2002:a17:906:f58f:b0:c51:2e3:f426 with SMTP id
 a640c23a62f3a-c512b79e2demr9058066b.18.1795043883126; Wed, 18 Nov 2026
 15:18:03 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261013162529.1928093-1-dmatlack@google.com> <autxCZPJ9yiE2ucq@google.com>
 <aut0H65XKAHUqPR9@google.com> <CALzav=dp8HvdK=9cAkGfbsJAeckyU3_y7rCRM22R7+AmTTtxMQ@mail.gmail.com>
In-Reply-To: <CALzav=dp8HvdK=9cAkGfbsJAeckyU3_y7rCRM22R7+AmTTtxMQ@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 18 Nov 2026 15:17:35 -0800
X-Gm-Features: AclHuK_BmYZZLmsTICieOxQ9QtDw0U6EdYtEs__fOCufTHy2p7TcHAXRToh2pGA
Message-ID: <CALzav=cj3GuYU3wmW5GPSy8Rp+4xYjm3vonDBdi8TTyWSgxPCw@mail.gmail.com>
Subject: Re: [PATCH v10 00/13] PCI: liveupdate: PCI core support for Live Update
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 00BE0180002
X-Rspam-User:
X-Stat-Signature: 67apt9yirojy1h1uym6zapmur61xwkpa
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795043884-954070
X-HE-Meta: U2FsdGVkX1/7KzuT+Ju70HcAoTE3sQRCjY+vCfmrx89X3v5Ku6VasDAOL2KgK9QEQ2WyNCDAwwjwsfYbXS1ZNerwbOTsLkEQ7FxtpagXsMn+8MMwn98HB4qmVWTWy6aA/Y5jdQCuHWqSrT/9vBCH/hyIYlx0bO4R8lJZzNcWg5zFYj6K3WZyymID7FGLAtxF4FHhLhIyVrxF1y4Bf8mxFehuT5GszrrTMehKxj1ZQa7/oxFn615huPP7uGDzrjeyjYS8N5Oo4lFXqoejZHC14h1VWphNyjd3kMQt7mnnWsrSh+Wx3joi0NyCC1dQkL/W/3kwm86T6hJiH6JUFrvK/uKQ0W/PaIgAAECjyOO2eoUon+o2h4ISITCnMgAEGquqWFvIT47N5amkjckvj1KcUZajZIbdAwMKRs9QjiYt0+E1YQpjUQ7eYAv9R2pA+hI63R26rrodGcl/5PTYyt3/Owfqhxvt3Bh+zcKXCgCRdBKkMzNoxV43Qv4UBtNmTfQFG/swF7t5xnBtCBXdNqcsneRK4jC+ZuJbQFJ7KYjuOOMJUkY+kRokGnUMyHfweDWZu1irzStza5S1G4nYmjxMVyuoi7yOZQ2iIclARJkiSID+R4hOSg7+crpvU5HVsnJOjZsnJ+bDn4Hl0g+aWv6S3Ds8UmviNkHL2uSVRVXJyWr56mgtwVkeoEXBrEVJp3KTeq3dDm+ZBS/JH54dVac5Hr2skq9ENhDxtIkNcD99CEH9jyHSv89dUhV57O1E6sM21X0kAWtGX4zja6b3a5NiHH2aoe0qNz0//DLgtwkwMQCJQJ2xox05D8eyJt6QexOQgUca2YZ3UpmkyoS041I4KNPIBDpTrRbgyBRgzY7vwzgJxhTt5Xj0y91M/9OSpFBbpj7/wJe3h/+xsK0hlBf0IK7wMOE8Wn5SwN09U64J8hfroJvizF0ExylcCjK1+H21SjyIy17BdvZFppqSTfF
 mRFAnBKK
 u+CENub5nHvX+dwjheApk4Hizb8vMq/cSzkM4a4/b3f71dhwJXOSIR9qNPQungcCNk5Xxmlq0QPObueL6glhfDXG/xBy3oGUeKOuBVH0b66ng68WM2n6uInMi7qI6+LAxyWTktTH+BW7BYqY92HVfWf/nA/lvaYPmkmwMwsTUiImKeqRCiARWMqmBD0Lu0k0jAA1UAPYrdbmUuLHdpCFxc1QLgIOp6LchNwv11xxuA1kAqcEoaCHgAAh+60trH/goMyXiGTFS5ROMwK1RAnDfopKhz5RW+z3UVYwuBZZK68zFMdDznO6poa4zssscc/wdypLdgTtAOzGJaDzw9vyidUwTlgp/fQm1fX/5PqbhKVZnctMxo5foQcL89Ym3geu1tEplnX5dBbaV/N+x7Ym1WZP34+km+ezoY9MmnBoZwBPjtAT06Ozj4Bsylg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 8:45=E2=80=AFAM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Wed, Nov 4, 2026 at 10:06=E2=80=AFAM David Matlack <dmatlack@google.co=
m> wrote:
> >
> > On 2026-11-04 01:00 PM, Pasha Tatashin wrote:
> > > On 10-13 16:25, David Matlack wrote:
> > > > v10:
> > > >  - Save and restore the ACS Egress Control Vector along with the AC=
S
> > > >    Control register, sizing the save buffer from the HwInit Egress
> > > >    Control Vector Size field (Alex) and drop Bjorn's R-b tag
> > > >  - Make CONFIG_PCI_LIVEUPDATE depend on 64BIT from the first patch
> > > >    rather than adding the dependency later in the series (Pratyush,
> > > >    Mike)
> > > >  - Reword kernel-doc comments to read better in the HTML docs and
> > > >    spell out "reference count" (Mike)
> > > >  - Replace the version number at the start of struct pci_ser with
> > > >    required_flags and optional_flags, and record the size of struct
> > > >    pci_dev_ser, so that the PCI FLB ABI can be extended (LPC BoF)
> > >
> > > Hi Bjorn,
> > >
> > > I am planning to target this series for the 7.5 merge window through =
the
> > > liveupdate tree, as we previously agreed. However, there are still 6
> > > patches that lack an Acked-by from you. I believe you might have
> > > reviewed some of them before, but the tags were lost during subsequen=
t
> > > refactoring. Could you please take another look at the following to m=
ake
> > > sure everything is in order for us to merge the series:
> > >
> > > PCI: liveupdate: Set up FLB handler for the PCI core
> > > PCI: liveupdate: Track incoming preserved PCI devices
> > > PCI: liveupdate: Document driver binding responsibilities
> > > PCI: liveupdate: Auto-preserve upstream bridges across Live Update
> > > PCI: Save and restore the ACS Control register and Egress Control Vec=
tor
> > > PCI: liveupdate: Adopt ACS controls in incoming preserved devices
> >
> > Thanks Pasha. One more for Bjorn's list:
> >
> >   [06/13] PCI: liveupdate: Preserve bus numbers during Live Update
> >           https://lore.kernel.org/linux-pci/20261013162529.1928093-7-dm=
atlack@google.com/
> >
> > Bjorn's Reviewed-by on it was dropped in v9 when it changed materially
> > (albeit based on his feedback).
> >
> > Alex, could you also take a look at the two ACS patches? 08 includes th=
e
> > Egress Control Vector save/restore you asked for in v9.
> >
> >   [08/13] PCI: Save and restore the ACS Control register and Egress Con=
trol Vector
> >           https://lore.kernel.org/linux-pci/20261013162529.1928093-9-dm=
atlack@google.com/
> >   [09/13] PCI: liveupdate: Adopt ACS controls in incoming preserved dev=
ices
> >           https://lore.kernel.org/linux-pci/20261013162529.1928093-10-d=
matlack@google.com/
>
> Bjorn and Alex, these 2 patches still need your R-b or A-b tags, and
> then this series will be all ready for 7.5.

Thanks for the reviews on v10, Alex. I've pushed v11 addressing your
feedback. Patch 09 on v11 is now the last commit that needs a tag.

  https://lore.kernel.org/linux-pci/20261118223704.3286085-10-dmatlack@goog=
le.com/

