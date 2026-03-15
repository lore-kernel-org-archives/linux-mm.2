Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7C9C10854B4
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 00:37:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 137666B0088; Sat, 14 Mar 2026 20:37:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E5716B0089; Sat, 14 Mar 2026 20:37:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F26156B008A; Sat, 14 Mar 2026 20:37:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DDBD36B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 20:37:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7BE9F1B8B53
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 00:37:54 +0000 (UTC)
X-FDA: 84546434868.16.5AE85A5
Received: from master.debian.org (master.debian.org [82.195.75.110])
	by imf01.hostedemail.com (Postfix) with ESMTP id B40094000C
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 00:37:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.master header.b=w0XURBVL
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773535072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qQjj9J4spuAdNma8qjIGtf7fmYqmZXfhy3etCegZ9lc=;
	b=t9fJZg+1oWjosgyq4NK+oGFSF//TL73UJVInJ47WCx4ipMXT1ZTo+/+wlKgph042gZR0SH
	ZalzSmmYl6t++4QmRl6SU8y77xMfPqRDAlPJBxDTQk9xf4YrUPVq38DtnWHdb4cEnr6RCf
	5rdaYGL0njalavKyy/zbrKKSYxVfvZ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773535072; a=rsa-sha256;
	cv=none;
	b=hQ9iKCqp/hnFzHjVto0ZshzKdk2NUJ0JZP3CbjfVJSSOjWBHgIgZ1tiGznJ1YkQvHPOXfl
	9ynktYFrDAp2v9ywFMcm6cU5ILBBnwdOz+9lx/LpME+tTFBS3J2G/JsBgfjYCjegOf7qI+
	RrCGkXJA1Df6hRLJwJgdPN8gRX3SQnM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.master header.b=w0XURBVL;
	spf=none (imf01.hostedemail.com: domain of ukleinek@master.debian.org has no SPF policy when checking 82.195.75.110) smtp.mailfrom=ukleinek@master.debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.master; h=In-Reply-To:Content-Type:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description;
	bh=qQjj9J4spuAdNma8qjIGtf7fmYqmZXfhy3etCegZ9lc=; b=w0XURBVLisQDTW3k7nYhdk+cUW
	KJrCgjuI/P4Co6MmgK1YJO89VF7QQ76pE2StF+Px9uj7ShK9p65PLpBaytg72jzRXW8IEPHiZAo62
	QjOpwlOIfRCxSKrVQPpjTLL3Ro+p5wbpcDiTPwaoEMy8MGSiIN3c8hNm6cGw9CzMrGG9QpFF6eQ5+
	EGNfFu1O75imTtKqHMe+r3hR8zSqPx2usbsZrRfEQ+mX1jFhQSNlsL3f4w/68syfXZfVz6ebLwFbQ
	dAcgC1tJ7pQWnnKfzElJNOgnOI6s0Bs/veh5Mm+68ny3RxQHbwKyWSkF/0yG5BaXSAzT4zupjQGmg
	nlAydE4w==;
Received: from ukleinek by master.debian.org with local (Exim 4.96)
	(envelope-from <ukleinek@master.debian.org>)
	id 1w1ZU3-002ktt-13;
	Sun, 15 Mar 2026 00:37:31 +0000
Date: Sun, 15 Mar 2026 01:37:29 +0100
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <ukleinek@debian.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>, 
	Salvatore Bonaccorso <carnil@debian.org>, Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	regressions@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Hans de Goede <hansg@kernel.org>, 
	Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>, benh@debian.org
Subject: Re: BUG: kernel NULL pointer dereference, address: 0000000000000000
Message-ID: <abX53NWDsG8oW7H6@monoceros>
References: <6ba903ad-9897-42bb-8c2d-337385cc3746@molgen.mpg.de>
 <db387081-345f-423a-a0ff-e13f3bec2d51@molgen.mpg.de>
 <CADVatmM_mRnkDX=hpUjbyKkZnGynxJfRSujGxm2LaWWMEL_2ew@mail.gmail.com>
 <ef9223ee-0a4e-468c-bfd0-0cf190d262f1@molgen.mpg.de>
 <aVgjpWaIRkerdgCa@eldamar.lan>
 <49cdd663-bcbd-48b4-ac38-77ce94ef0c8d@molgen.mpg.de>
 <aVj-mz8vaw53TWtX@debian>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="uose2pk73ch6jhan"
Content-Disposition: inline
In-Reply-To: <aVj-mz8vaw53TWtX@debian>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B40094000C
X-Stat-Signature: oubw5ozax7sbh8578oaqqp89pq3k8aa4
X-Rspam-User: 
X-HE-Tag: 1773535072-93430
X-HE-Meta: U2FsdGVkX191pZBanAatjEefTbE/XjkN/Zw0Kgrfx31h9hadU8bsIzmL+W9DULApwGDR23xpTHnA1bi3CrE3LH6UgmGMMFIFV2OyIWDRWxWxQSJsymv7/5VMq5ntyhMGzVV3l7kVEMZeKGoKltUT1siZgbQd7ohWIQf0ivcNIYU0Tiruuq0EM1FMzoHRrbkjBs2gL4Tu4WFoyGkDpiAjoVDU2tTUQOz2+aYZ/IAv6ZAqG96Ag+yiJ7PczZVeAGKvrazhoCBG2ESXj0yA00NP0wQL/l//NE/9bDDkIeR66G1lZMTopY1s72WBxy3ACh6JySVcihwHOiziVqtYCOXpHCjVGJg96+1d7l7DbPE5eLbhkOfg+gX70jm1YzFQnoeLupjEXK26y5CT98RJmkLn7SZa5s8L1tOSeli5a0QGdWU4JcjACDG2se5ubC07SmpqCGxw4PduTIzNw3bg/8cKAKFzfnRe0UHzbxYsi2Id5jdw9R/wNYBAo46Su4tvx+BouvzUaGxrpCQaN4gdD45xgN1NK+DMZ7kQ6FjNokFjH/n4T2vUWNsb2ZEHwEtgCJbMiRGq6wfaDDaQowAadfcN0oqDe/gccOuV3tAkOOqf89uMd+xYj0DmR9ehcXl/EzE/dd4hz2NLz1xZSxH0mk7eaqtP8Qf9GY57Qx6+rrrJa2WvrOZlGEQh65ZxaJCbHg/wWQtw/cE/u8bY5jZmi1YSvw+gnOJlSWBwyehPzSVLQxu5Q4xaGEt7M61kNDFwEJW8YVOT0UM2Ra05BZpog5i6yw58gySi9OlZdufDbnKF1gEXKwaAvFjTtIS3pFGzCkj0c2UC/3V8f6XPvMsBRaCnpY0GqitHjoiOMkoILt4eun3Y5WjTOG7+/75pJX67V5ox+cWNj0p4ABxCd+xQZ5HomhWyffJPNxnHfgQ6HsniipXrsEQ5xzTiEb3AiZ8aA4hOFR6AYuQdd7Cmv0pT3hR
 +4JV3yal
 eRikySdZ6J9GbG0wVk2eA7+Y43MgMV36Uee7fh9eGN9HQUh0ocJMiiK4Lk4Jf1/pQKzCWYedcPGE+Q7widfwpfLVrzSqNMDar4wTbx74m5+0m99xqFNyE7FIVOAChC6t47nE2qJdnwLBCARFMOytzTqko/GuOvt6ZgJiwcry31e8smGJjnJl7QWpKzP9xPwZSEqi4u9mHoqlr/TnHI+1WJ/dnVt00/YbeZRbUarVj4COahJYSZRKzdBhxR4w3+VEi8fKUB9FmuZd6S4aHZ29ADG8/lwIYTpOx7JES/9hZph1vHUTFf2orMe5wzfGZ1DDI0ZxcZFRTt3gjOCyJizYJLHX1OrFipYWHexn2hFtSOn1kEX+Qe+jQuOFY4tQav0HEHOAV29lIF6bHKEGoUK1ITmgjC/9PraZa3Z7VDHH6f1HseFiNl1RviPPgHDM1AL3kUTSrU9l169/HOGXVLKNy90vHIj+o9TgYRkSOfiar8E0TWXvDDU+fHSr9nZGbZKQNcNWX0LfTtoo9kHTzmgDVv4R6R1RRlz6V8Z5KFD1Yhh81ievnu+jm3dTaEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--uose2pk73ch6jhan
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: BUG: kernel NULL pointer dereference, address: 0000000000000000
MIME-Version: 1.0

On Sat, Jan 03, 2026 at 11:33:47AM +0000, Sudip Mukherjee wrote:
> On Sat, Jan 03, 2026 at 12:01:19PM +0600, Paul Menzel wrote:
> > Dear Salvatore,
> >=20
> >=20
> > Thank you for the follow-up.
> >=20
> > Am 03.01.26 um 01:59 schrieb Salvatore Bonaccorso:
> >=20
> > > On Mon, Dec 01, 2025 at 05:05:59PM +0100, Paul Menzel wrote:
> >=20
> > > > Am 01.12.25 um 14:25 schrieb Sudip Mukherjee:
> > > > > On Thu, 27 Nov 2025 at 22:55, Paul Menzel wrote:
> > > >=20
> > > > > > Am 27.11.25 um 19:51 schrieb Paul Menzel:
> > > > > >=20
> > > > > > > Unfortunately, not reproducible, but starting with Linux 6.18=
-rc7, I got
> > > > > > > the oops below *once*:
>=20
> <snip>
>=20
> > >=20
> > > https://bugs.debian.org/1124075
> >=20
> > This is
> >=20
> > AMD AM5 ASUS ROG STRIX B650-A GAMING WIFI, BIOS 3067 12/10/2024
> >=20
> > > https://bugs.debian.org/1124463
> >=20
> > This is
> >=20
> > Dell Latitude E5470/0VHKV0, BIOS 1.34.3 11/20/2022
> >=20
> > > Does it make a difference to cold-boot or reboot into the system?
> >=20
> > I only did cold boots, and I am not able to reproduce it anymore, and w=
rote
> > it off to some hardware issue =E2=80=93 despite the system working fine=
 otherwise.
> >=20
> > I am adding the x86 folks, and regression lists.
>=20
> Thanks Salvatore for the Debian bug links.
>=20
> I had been trying to reproduce this but have not seen it on my machine so=
 far.
>=20
> But looking at the traces from the Debian bugs and the trace from Paul, m=
y best
> guess is that its happening because the low level driver, parport_pc in t=
hese
> cases, has not completed setting up the hardware.
>=20
> When 'lp' starts registering, parport driver will check if there is any p=
ort,
> if no ports are found then it will try to load the low level module.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/d=
rivers/parport/share.c?h=3Dv6.19-rc3#n198
>=20
> As mentioned in the comment request_module() is not trying to load a real=
 module
> and it depends on the alias. Also, mentioned in the Documentation.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/D=
ocumentation/admin-guide/parport.rst?h=3Dv6.19-rc3#n45
>=20
> I am not sure why the problem is seen now, but is it possible to test the
> below diff please and see if that fixes the issue.
>=20
> diff --git a/drivers/parport/share.c b/drivers/parport/share.c
> index 427abdf3c4c4a..8f45daf7b3825 100644
> --- a/drivers/parport/share.c
> +++ b/drivers/parport/share.c
> @@ -287,8 +287,16 @@ int __parport_register_driver(struct parport_driver =
*drv, struct module *owner,
>          */
>         ret =3D bus_for_each_dev(&parport_bus_type, NULL, NULL,
>                                port_detect);
> -       if (!ret)
> +
> +       /* Return if no port has been found. The driver has been
> +        * registered, so whenever a new port registers
> +        * attach_driver_chain() will be called which will then check
> +        * all registered drivers.
> +        */
> +       if (!ret) {
>                 get_lowlevel_driver();
> +               return 0;
> +       }
> =20
>         mutex_lock(&registration_lock);
>         if (drv->match_port)

There are several backtraces, I looked at two of them and both trap at
an address that corresponds to:

        /*
         * This has to be run as last thing since init_state may need other
         * pardevice fields. -arca
         */
->      port->ops->init_state(par_dev, par_dev->state);
        if (!test_and_set_bit(PARPORT_DEVPROC_REGISTERED, &port->devflags))=
 {
                port->proc_device =3D par_dev;
                parport_device_proc_register(par_dev);
        }


in parport_register_dev_model(). However the trapping machine code
doesn't match the kernel modules of the respective kernels, so that's a
bit strange and I'm unable to tell which of the pointer dereferences
there results in the NULL pointer exception.

Maybe this is also an instance of the hardware disappearing? At least
port->ops and pardev are non-NULL earlier in that function and all
static initialisations of a struct parport_operations have an
init_state() callback.

I didn't try to reproduce, but maybe adding a sleep before that call
makes it more reliable to trigger the problem.

Best regards
Uwe

--uose2pk73ch6jhan
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmm1/0cACgkQj4D7WH0S
/k7w7Qf/YDFqDdl1ikNbsRrCYn09s/ORe636Y1y6Zrxj3C3wh/iC1SzviEqGTHGR
np7DjJXGWkqgAu68RRUt4Cd2c6j+CrhS0QHQHvIals7OFvQk/m80+7iEd91cOUGo
BfSxvK+xYDXU85HQFpGy8Kd/Ag+gauala01DI7WbtyhzutJI4ecFfn4MKtnig+p4
1QGNDFljO7kcHjODlUrDX9lrL88WNzFOgyB1/jZhnPC2btGcrFhUwu+/smzwmfXg
p1fWF/Zzr+Fd837UntPMFpeypzrJMYTArxQ4l7SJ/Deai3GKA61pdn7boNwiMPeG
bKuuHuT5N9nH83fVvN/Sdw5hvXXdCg==
=wbgD
-----END PGP SIGNATURE-----

--uose2pk73ch6jhan--

