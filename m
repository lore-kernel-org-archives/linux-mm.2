Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04AE4C88E7F
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 19:23:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1431B6B0088; Wed, 16 Sep 2026 15:23:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CBEB6B008C; Wed, 16 Sep 2026 15:23:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAE416B0092; Wed, 16 Sep 2026 15:23:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BA3DC6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:23:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3E23C0115
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:23:34 +0000 (UTC)
X-FDA: 85220599548.07.0F4D626
Received: from mail-ej2-f23.google.com (mail-ej2-f23.google.com [74.125.228.151])
	by imf08.hostedemail.com (Postfix) with ESMTP id EC095160003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:23:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FgKmKP6C;
	spf=pass (imf08.hostedemail.com: domain of dmatlack@google.com designates 74.125.228.151 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789586612;
	b=Oe2hTj2AVnjyTi3m9tv93O15VgczvQYMWOEdS/WYtRgsank7M3WwJSvjC89pdA7JerMjlL
	2p4C/MaPguUJvo9kOdK2zqRTsGOlMA+isZifmNxCKws9rWZ1OxWh8PNqwBSCyE6ra73EKz
	OKeD5tN1BHjYKIAlDALtuVw4ArtTJLU=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FgKmKP6C;
	spf=pass (imf08.hostedemail.com: domain of dmatlack@google.com designates 74.125.228.151 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789586612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1KLYZ+iH6BwF1ulRTppUoaxI/s8uMQmLIUDs0MP8toU=;
	b=JdRmSjVRc+ny7Ken0/8DNj7ORDMu7EW4bcWX90qlmUjG/VfYWv/nZ+xltHc+xC6UXDa13J
	I/tszIGHRzzgOLuoO3wx7Et1ZxhiusqOlO6n93uR7RValmIqcnItVMXl8oTWLb21n4CqF8
	OCQgidhcEqVTGHemunuaB8PpZaiwHjA=
Received: by mail-ej2-f23.google.com with SMTP id a640c23a62f3a-c25ef7a3ce9so15350166b.3
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:23:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789586611; cv=none;
        d=google.com; s=arc-20260327;
        b=OdtBWNjoyup97c9s3wwvVRpluqhVscjUKBpD8OmSqa/wTXePcJELvKdCD1MFezc7j0
         v37ajZsnbZdablVC7HGUaM6Rk7FNEYDa2b/ViGcwx6cgS8cFRcpfKQbCd7j7mJVvONSD
         UbCB6VhGSxwNQ92kpAw91lDikOiGPTyHq5mB0MN1ziM8HLWs0Y8XWe0Uad8wAdytcsb+
         Jy8dg0zUc9Q72pJ2GSKhjYh6s2wcYFwqt0hDhlP0WH6TIMd8jmWTJixTsvs/MpKxFsjX
         Uyj+c/aaVV6YGGigo2/TnzOD75gv8WJisKx2Frus/KG/rC7KUxpOWhdDYRGQIe09lSSY
         GwPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1KLYZ+iH6BwF1ulRTppUoaxI/s8uMQmLIUDs0MP8toU=;
        fh=24xRlcWXCUI2msJBvZPwt/Bsy96C+gE9zOnC5nracGI=;
        b=CQAa6sqhD87X6FQIZbElOGvCjtTybkc0o7UtVvy0oJsrp6RV/wFCtNgJt7H575yFW4
         fNOURmzRdqPQ/2FIrg4LKbBOGXaATiPRw3jIfPSfNNzG7R95mJPMl/yqnE61ELz0M6Ai
         zom8VVOBLxYUBiQjAq5XgL88m1Uyv/bax/KKNbdK04P8I3gs/IxJe6pPmJezpMf28FBX
         HwV50U/uYi+29cZd/iRcQ9eC/0v4EQS+9qwGesDrldqlx5I/JHJa1n/lGQciK5+6keij
         rfhLoyB7OZA9QQEDsDGQgXsYQN2g0FkuimsgL5okqZKKhga1hQxDLHk0tk4XSf/0oIzP
         teBw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789586611; x=1790191411; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1KLYZ+iH6BwF1ulRTppUoaxI/s8uMQmLIUDs0MP8toU=;
        b=FgKmKP6CazUe3M7vzXiFKh6+IaJpUgp9ejoz7DhEh95Bvit47GPUrCI/Hm9k5G5Io7
         gVrea1xF4wFixHCsHL4kIKCQsBIK5wZkc6YQJ87zHdQPSW61f8wPpVM7jKF/94xUo8fi
         UfkdqoQU7SeSWv6oteO2K7jKF+DFAnn8SA5RynFnd6wMJVh5D4kFQVDIAjWIWQTgjlR3
         4JI9ZgQRCgyQNKNWNarvFdU8TL9B+dOgforQgcXyqLUCZN5TukeGUpj5V7Y+oGq9Q2/c
         WDIKN3W9aCK4ADCYTmrKiHdPrhAyr9Jg27cXcxy681ElrtXO144O9PKOH6qOdF9SuuiJ
         vFtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789586611; x=1790191411;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1KLYZ+iH6BwF1ulRTppUoaxI/s8uMQmLIUDs0MP8toU=;
        b=OcQKT+ys4RrXWsHMWdFi2Ly3Q+Ot1zjZV46NfIGMaaQiFFCNnDNIfqA+mWVXJE6xOh
         SggtEqx76u1cqjFBK+IxXwfbqGhpThHj8nWZrRC/Mt3MSkDfM/2Jwk7xyI4IPDVeDw/m
         KIlcey3uXVKN9630DMK2Icvfv5LPg4DBKLnvbzkWvNzfS3MHnc6DovjTELVk77iLnka+
         ju+IFIX/4HNTiKGNKk21jSV7XuvgXEcwnwY/yZjOwHatsclixSYg+oUzb2u/jTg2P5lb
         RxsJrT8jD7Hfgr7cfK63MIfFQoJp+RdG7WeRA1G3I+KhectbYtiO1R4pWiWB4AteL2fQ
         viiw==
X-Forwarded-Encrypted: i=1; AKwUvBxY6MDbxIERP1r/QpoT0VMoSIX3qaOV7gIXoWrQavBNsjQSteDkgmvRf5myRUSRZOGEmxGSxpvJSA==@kvack.org
X-Gm-Message-State: AFuF++lyVYvGA+60IX1FrRBqGNBQGvVqK/uvxrKzz/EmC44GclcZUc8H
	bcAfoxoHgSgkEtQtAEQQxSh9/vAfp0G/L0RDtPPac42PNCXs12BHzXIcj+RpO/CVHugZ34ro8qP
	GUxqGNyHeoVN1eZTC/xiqrRKF8qawzlxxQEXuPzCQ
X-Gm-Gg: AYBFou0rZtsh9r9cZax3SwED01rCEr+hyMlXxVca97eGGwLy9BT162hpkeQNZ+kFFb8
	UzUEpnlEcx3RxUfagNlTI6WfyPWfOjjus3J+MWrEgP7DiQcvNM111N3y44rZSE9nu8MZq35rylA
	Lzo17Z5xoo6YAclBodefZHvUIeWxVaHYsOXzPGR3V2IUh8HUk13f35JzH1ZjJmCC7Pb2U1NGey5
	pWIWQUMhpquORf4eHcmbpFZOHvUnGpfwZJ/t75ybk3eHPPN+UH5cwAssue9kMMeXTfCPpg+FfEP
	sBCJcb3Tzi3QirgOQEtLvTjY52iqzj1rFRApqYZjFTYbzU3nHbSeAy/5bihEufUvIiRxZ9FN4mp
	r+Hgkp3HXr6E=
X-Received: by 2002:a17:907:3cd4:b0:c29:3711:626f with SMTP id
 a640c23a62f3a-c29e52c97cemr277311666b.24.1789586610730; Wed, 16 Sep 2026
 12:23:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260728221007.2098560-1-dmatlack@google.com> <20260728221007.2098560-4-dmatlack@google.com>
 <e099cbaf-3185-4c39-ae36-7f0e074ebff7@linux.dev> <CALzav=eX0gVrbWCnYGwfqPHUkoVxqdr2nw3Tx6Aqze0XOcuwzA@mail.gmail.com>
 <2vxzcxud6ol3.fsf@kernel.org> <CALzav=eBXsaZKNv1SNtuT9F6aX_2TS3u5kUtko5WMv2NWt3e+A@mail.gmail.com>
 <2vxz5x056n1b.fsf@kernel.org>
In-Reply-To: <2vxz5x056n1b.fsf@kernel.org>
From: David Matlack <dmatlack@google.com>
Date: Wed, 16 Sep 2026 12:23:03 -0700
X-Gm-Features: AcwNN1XBA5tWfpFye7fMRURIMgABlK_FSM1i3xHnxeEQBrBN_oHQDGfs58Y6KSU
Message-ID: <CALzav=e3_m_53PHTpMbwj0kFwVQdjx=MU8iHKwGcSa13V0R5cg@mail.gmail.com>
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EC095160003
X-Stat-Signature: qg9jacrrbx5jm5weewr6ra731yuguu5a
X-HE-Tag: 1789586612-961841
X-HE-Meta: U2FsdGVkX1+/xbF/4TJ9SL27a52TwaYW3ZAUO4a6wHKQYj4F27BD38NInnM0c6yb/+4j6C6zmk+iIkkrLLq8hoaeF4nXC1d8TN4o+M199DEpTPQkYsQfK5iPkYzcO+M5dKH6SOsn6ltLFDWyTj6n1wmr5vtbVfu+FklzvCTaw2e+oANE24eWdTLjn1U3vx7MAXM3bTC3SOIMx0enrreZph57hWy8KCXvS3ZLS4WPBowoiVn3nnPed5B4CyavoLZc1a9nA1EDMBpOBLRs/14OgnQvTfzx5AuVr1/kJ21dEaT3z/xU1FqCZMr0Hfv/e0MbPlGslyIEsAyYei6565or3qcDHzrE4Y6ESvQkRPcjuHkq6Mkag4FRrqezn76DCagrxpPOBwgnDbTWOQUjapz6Zj6aaxVyRF0w8+xft/X5rGpLkgl5N/blBu8st2rjs/KrkuuJTMjXYd3kLNZen80kLTBhw6xAXJOCbFADdPaDOur34PExWPJ7a1xEsYVfVNLXBgBgd8PorhIxB3PGQLHWtkgZ2jBJt80vCXGxSAY4McbfhSnuBMXzBZkoHdzP5lpFPCRWSV9mosRfq2jf3k4hGMRt9eKrpKq8UCq3fzqqfuyddPoz0ry49+oUyB61J5qSXFyQ7+g6bqW6Se8PonD3gAnjvWxU8PpAhxWDnGeK1X5BcBUqkiTb+Pp4V0QcfKCE9MOqQNR7IalEfe0Ba4TTQUyoJsYnoM1CxXf4lx4LArjOu4yFyBRDSQunm1Jk0yEImjKEixlcBFHozl2VxWD5E5ai6XUpkMzKFlBOfMBSDzGtk8udHCPYFPQCFcHNgBVG7/qiflnkANxE0Wj+UKMypLroOBY7DrSDk3m4sMr+8M+kDA9bg7FJQYiYJ67hqPsfb3aGN7xummFUk10x59FKWQeVwIaiFEVIr2tCHloR+fbEUsG4CnlRZEc8msOfBzuHw3TAs9e19JbsUuRhbpo
 fVBzMxvj
 VyEswNfKiE0UPVu4azgZ1n71R/AUI3QIg/vDCarPE7Lv4WlF1wZjVesANKnebOeomImNhtX2rO5MKYbNe6ociN/OiwJaG/BhvTDe1tJEVwvZPO4csXcYuJr/swdUd9DDplw9AsdEmeV6vdWLgqiWxnv9CM4GgIZNdUe1yDtmZ4VM6Vqxq/ogEiKa+whS3kFuT6SryQlke602CZrHy31eiHE3Eg7PEwl0dIq5wDMTIAtWTdajylonOWzBL9nf6HvER5yvC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 11:58=E2=80=AFAM Pratyush Yadav <pratyush@kernel.or=
g> wrote:
>
> On Wed, Sep 16 2026, David Matlack wrote:
>
> > On Wed, Sep 16, 2026 at 11:25=E2=80=AFAM Pratyush Yadav <pratyush@kerne=
l.org> wrote:
> >>
> >> On Wed, Sep 16 2026, David Matlack wrote:
> >>
> >> > On Tue, Sep 15, 2026 at 8:31=E2=80=AFPM Zhu Yanjun <yanjun.zhu@linux=
.dev> wrote:
> >> >> =E5=9C=A8 2026/7/28 15:09, David Matlack =E5=86=99=E9=81=93:
> >> >
> >> >> > CONFIG_64BIT is now required to enable CONFIG_PCI_LIVEUPDATE so t=
hat the
> >> >> > domain and bdf can be guaranteed to fit in an unsigned long and b=
e used
> >> >> > as the xarray key.
> >> >
> >> >> > diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> >> >> > index 3781e2b5f095..8af20f558086 100644
> >> >> > --- a/drivers/pci/Kconfig
> >> >> > +++ b/drivers/pci/Kconfig
> >> >> > @@ -273,7 +273,7 @@ config VGA_ARB_MAX_GPUS
> >> >> >
> >> >> >   config PCI_LIVEUPDATE
> >> >> >       bool "PCI Live Update Support"
> >> >> > -     depends on PCI && LIVEUPDATE
> >> >> > +     depends on PCI && LIVEUPDATE && 64BIT
> >> >>
> >> >> One question about adding 64BIT to the dependency:
> >> >>
> >> >> As I understand it, enabling CONFIG_64BIT essentially means that we=
 are
> >> >> building a 64-bit kernel, and a 32-bit architecture cannot normally
> >> >> enable CONFIG_64BIT.
> >> >>
> >> >> If that is the case, would depends on 64BIT be necessary here? Or i=
s PCI
> >> >> Live Update already inherently restricted to 64-bit architectures b=
y the
> >> >> existing LIVEUPDATE/architecture configuration, so that this depend=
ency
> >> >> would be redundant?
> >> >>
> >> >> If this problem has already discussed, I am very sorry about this.
> >> >
> >> > The necessity is that the PCI core needs to store more than 32-bits =
in
> >> > the unsigned long xarray key (see the snippet above). The dependency
> >> > on CONFIG_64BIT ensures that unsigned long is big enough. We could
> >> > probably remove the dependency but I would rather wait until someone
> >> > with a 32-bit build has a real use-case for using PCI_LIVEUPDATE
> >> > before putting any effort into it.
> >>
> >> KHO or live update themselves don't support 32-bit platforms and there
> >> are no plans to do so either. So I don't think you even need to have a
> >> dependency on 64BIT in PCI_LIVEUPDATE. Only 64 bit architectures defin=
e
> >> ARCH_SUPPORTS_KEXEC_HANDOVER, so PCI_LIVEUPDATE and others indirectly
> >> inherit the dependency.
> >>
> >> If you'd like to be extra safe, then probably you should add a
> >> dependency to 64BIT in KEXEC_HANDOVER directly. Though I think that ca=
n
> >> be a separate patch independent from this series.
> >
> > It should be in both places then. PCI_LIVEUPDATE explicitly requires
> > 64BIT for its own use of unsigned long, so it should have an explicit
> > dependency. If KEXEC_HANDOVER requires 64-bit for its own specific
> > purposes, then it should have an explicit Kconfig dependency as well.
> > That way if and when someone wants to add 32-bit support we know
> > exactly which configs need to add support.
>
> Well, I don't think we are ever adding 32-bit support. Most 32-bit
> support in the kernel is being deprecated or removed, so I really don't
> think it makes much sense to extend KHO/live update to 32-bit
> architectures.
>
> But anyway, if you'd like to explicitly mark PCI as needing 64-bit, that
> sounds fine too in the very very unlikely event we do add 32-bit
> support.

Agree we will probably never add support for 32-bit to KEXEC_HANDOVER
and PCI_LIVEUPDATE. But I do prefer explicitly documenting the
dependency. It costs nothing and makes the 64-bit requirement crystal
clear, just in case someone tries to do something crazy :)

