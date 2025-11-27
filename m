Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E32F7D111A8
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 23:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DD0D6B0008; Thu, 27 Nov 2025 18:24:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18DC16B000C; Thu, 27 Nov 2025 18:24:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07CF16B0029; Thu, 27 Nov 2025 18:24:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E7DFA6B0008
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 18:24:27 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 718A3C02E9
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 23:24:27 +0000 (UTC)
X-FDA: 84157968174.17.1DC7679
Received: from mail-il1-f194.google.com (mail-il1-f194.google.com [209.85.166.194])
	by imf06.hostedemail.com (Postfix) with ESMTP id 95A50180012
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 23:24:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZdTxVQCm;
	spf=pass (imf06.hostedemail.com: domain of arraybolt3@gmail.com designates 209.85.166.194 as permitted sender) smtp.mailfrom=arraybolt3@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764285865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2KPEDOCb5mXuCIR0Wc+ytoxgYgWn7CfbT1FbFeR5YO4=;
	b=JT/L4R6kg9eXbMIelKvLSvN1IfZ9L0XbuhI7JgNpvHTdjOY2t6Q4y5j0Cl5DGJ4B4rp3eF
	8Y82LI2wDUMvK5IAzjOuQ3LnQ4ZBDmwkf30ZtYTzX90qktILAtUyEDB/xF04JQMhOit7jA
	wQhFiLlV4/bce0tKM0RWSC81nTNwj+0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764285865; a=rsa-sha256;
	cv=none;
	b=0nS0o3Vj1LEYeLfWnVJyPRG5wvuSGrIIMnK8qISKddZPtBmj+FP1h2W6adyexbEVqnz2WB
	i2FQzpgyFdtmd227OYa+TSMlLrddxlmFtFRSANUr7hjh0ZFrMs1obgcTjdmSWOZyEkuDXX
	T8I8wjadAZrygQihrrPJICbkxLOJoE0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZdTxVQCm;
	spf=pass (imf06.hostedemail.com: domain of arraybolt3@gmail.com designates 209.85.166.194 as permitted sender) smtp.mailfrom=arraybolt3@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-il1-f194.google.com with SMTP id e9e14a558f8ab-4337e0add00so416765ab.2
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 15:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764285864; x=1764890664; darn=kvack.org;
        h=mime-version:references:in-reply-to:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2KPEDOCb5mXuCIR0Wc+ytoxgYgWn7CfbT1FbFeR5YO4=;
        b=ZdTxVQCm8DMXmerl+WE8NtTo3/9grCOYZZ+grueF5PDkoPisHxaDAQPXw0kNHfGxcl
         RWJrU109eYB4Sc/jGVTo4DplZi6CtEalUdO6IDLlx4Jzq49XAZJvMJrEwO1YUuw77PHa
         N09DXOlPDy1MUZQfPdBrOxROSQ5Snw6y2GPZA6Ack4ygiG0NGFny7eTtJjdTGoICJPQT
         Xu9YSAy/TI1R/dkddlDc5CYbjz402G9LkXOV/v4QqmWtE8GHy5RLpV4Hfx3DKZKareLe
         xQZQbdbIdMSTeCkLEVmhcWHKG6rjbWlbVvZigBnGFlkqfD1W2ZcGE58DgLnAaPL/Nwyx
         zITQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764285864; x=1764890664;
        h=mime-version:references:in-reply-to:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2KPEDOCb5mXuCIR0Wc+ytoxgYgWn7CfbT1FbFeR5YO4=;
        b=VvLYmYwOKh3Mg52MfsqFd5pSQaEzFkJ2wMuSAQkONm37rgc3iEbEkZannZueAEUhmB
         MA+T/o9jYE4LRtM+UY8UJp7Du+nXY0Kd6sp63S7zUiLSrnthQd+KhL5YjYnhQm1QGqpN
         70inhfFZzyeHJgsuwaTQyrnNREhDAHLMNCSGPfiBQC4PHPzVw7kmolBTx5pGqto8aeMK
         P0MhLSkLqgUXbNENS0YnCUryGhiEEfyBbrBVhW6wcEcg5/8IUfewnVbDmYDi0RLCXsBL
         5RfSYQ9sM9gzcJwQg9z7xJF7B9OEvB8qo4+HbrEqdtFXd3M7lC4b4wD1OBB/JhiOEvfo
         dgkA==
X-Forwarded-Encrypted: i=1; AJvYcCUk0iEe4pzaLZ4WJOUPvWsd8ShxTcfh8w8C0o8HwLScGMe1vp01a0lYRodrejtnw6A71vdVDg1ltA==@kvack.org
X-Gm-Message-State: AOJu0Yy9cPf+uDK0RbSWreizR8SUJs9mmNa4ewZHZ5OSX4kRkJ42M9Xr
	sY3ZYJg2xUYy/SJOx7zXIy0siJxpGlf0rYfKPgcI24Q5DJEBGjsuPCZW
X-Gm-Gg: ASbGncur3o6d71gWQ84CtavwaQQ5W2qTOejGjLh/1M7lrTc9Dk/l7L3dXZiWgarihnM
	if5kVn4MceOsoXh7T10aOuaJ1gYpZaNR5I7OLIGg+VrTLbGPf/tWmxobmCz/nsVkM2ZHKdo7PJE
	4TY/XpBOJVu+YBaVH4mfahGtyscyWb2+Wlh2Nudg7pP3TkrxDfZdGCarNu2FJ2eRlPDkz4r47Yw
	TUTGvjMkf43uYyDjAy1+ipM/q/WRXeslDn+3AQwzuv9cDsqgEEPxXSbAkCvQ9AXEVaNiR/gSiRi
	ex5uMedE3jdRQg7Ai36vlu2ajzOxHNLtqPIikC99XPpKMJ6bgaMH0RlHvNtph1+uzBipZGFQ5sf
	pKyElhvsuADSI4cBDL/5MoVeVhPCu/G0ABDT5ZdgsJkKCYFc4Sg7y/6fVi91cAnlFr3UTFT9b64
	SQP7Ciwzg=
X-Google-Smtp-Source: AGHT+IF1FZ7gp0CgtAprc3JnWiifAK4jaouDoqm3H9RkUcsuikGC8VoAWjBDdMdey7zD3t5eiOJ0Rg==
X-Received: by 2002:a05:6e02:188e:b0:433:2fe2:9d41 with SMTP id e9e14a558f8ab-435bc9beca3mr87373145ab.7.1764285864483;
        Thu, 27 Nov 2025 15:24:24 -0800 (PST)
Received: from kf-m2g5 ([2607:fb90:bf0b:8b65:e4a9:bd5:56d9:5426])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-436b33b704dsm14654055ab.22.2025.11.27.15.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 15:24:23 -0800 (PST)
Date: Thu, 27 Nov 2025 17:24:16 -0600
From: Aaron Rainbolt <arraybolt3@gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Milan Broz <gmazyland@gmail.com>, linux-mm@kvack.org,
 cryptsetup@lists.linux.dev, "dm-devel@lists.linux.dev"
 <dm-devel@lists.linux.dev>, linux-kernel@vger.kernel.org,
 adrelanos@whonix.org
Subject: Re: Hard system lock-ups when using encrypted swap and RAM is
 exhausted
Message-ID: <20251127172323.7913c99f@kf-m2g5>
In-Reply-To: <3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com>
References: <20251111231835.1232ad8f@kf-m2g5>
	<2b8b83fa-5cf5-4f97-b796-0c738ce3a548@gmail.com>
	<3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.41; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/r1E/HN.et+YE1IVFD_tEODW";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Rspam-User: 
X-Stat-Signature: gjk5msnyd8n14idefo6dc8um1z5nnnfs
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 95A50180012
X-HE-Tag: 1764285865-258848
X-HE-Meta: U2FsdGVkX1+aIynJ/fISbJUYsaRNWde83F65mM0mDncVQjUi0jOIIP/gct88JBlfDVscE/jKYcQ0ey5ZXRUIcPrWck6r8adRICb54heEZ30XS2OoTDDvh1KwPjH2LQCbmBKELJiIhOu2pCbKRP+/+1c7bsH9tb5C4nwkDQacjzbtri7xRqi22KNNaX6c7evf+LrgJhLXXSboHYvOPP3WBiGkGLoQmKVPeqS/kfY0M88q0DdHVxqVkZDqh5ux3mnubpsyTYe8dx79oU7QASmuvuszU16ihVNrWf97lFPwalUHXLmRAzPEm9Av223krdscvBJ03Pz8KtT26aU8bOabidwMUhJbUY/4Xrjrmpj2UyKQWRsmWKm3J4oBufgrv+ORo506DTRLCJiap4i50ZctSVeeWrYDx0E4J9BfNRcfVEaY8oAHjnM0KQS8+MZ/12ILxrpCPuEAuD5t9asm/FRAluDHJ8bA8Sjjxl2AbgX4y0qxZkxuhjFB5YAcLhL1nsdGcBuEtOFvaIexkZYbafTtibMzL58M4h/3xbEVcJjI4U9qB6/Y0cGxsWkP2WRFhrFgrHHBeSRtl3j+X9TDwXY36huvj6zeMAGeDTrdOetUimWOCvGNz0FCqqLSfuiCv2Xn6KHE+m3EMEAWQ+mmNRQ4J9hG/kCMz9uAukdwcedcKxAuP0w+3whR+9hsRQu6lq1pLC5/0/V/tvf1MjuZBz8rVbgI8djbB9FCTloDGPTnVbiL604m51TGAKKiF5Lqrdjrz9YIWPw1sldTiH4SJL1djVq0sLw9x8tbNQxI2nrnbA58PffSyj1WrHHzfg9Xy8wS/0KKeAWg04+3a0htybFcPNf2z54FW9mqxNr/oyho34v3GF5zGZT2A3KldIGD+ZlQb3IKwG9A8nbBwtnfIX2agEfwZyFZKGtmspfGQdnGSNWENgwH6keDrjnBTuAbjIzF6TeYW4ghSJG7T8KgYOj
 tgGQuKtO
 M1K1CSjAsg82gLgUEbKzu1pthh/6lZ83TDqlxcBtJ5+icxu55ANo6jHxOHtbqaMxagRemwxNeG9Sa074zQgmLDwOy3nEbWyCNlT9oJC4i1kBacmrXJyWflywTBxheOuYQXoWgQdqohyQ/p7iv3o3nJ5flE7iqBFTNrrCvDFOEFAvgz5r0Hrqy/UZYfhgD3r01Ocd6bwpswGY+sonyVAR4qwJO2KBpkhtNSTE0XcfVvqKbKCtXMtxTZTn1sJ+TXaTeOEFTSSsJl4E7gLQHEWodfnNrepuot0M2jyWCVO794xnaTBZr6gIbmLFBxsAK+MafT41lDJKxY+hyTy/REmP0sdlZB3wMSZ4O5oSMhgq+IOlFStat1+hjQJdfhO9hHM2miaCohiRDHqvS40oRteHP3bpGBxEEAi6Tm/tnqueh/w/5j1dl+ILH43UyamTJTsaH4LblRRSpcoz+G1CYtGQKLkrG/V0DfB9+X33y7TsSnQyQdXSyi7NoiIqZeXaF/Z7Zl93627PGS0KajKChtFQEbhKCCUUbIKzQ76Nv+kpm3W3obrRo6Sxap2ca8YJXh4POVz3oHTikNUz+q/eTyvwMY7rvyJPxmDAhem8NJyMguR5nJ1wM2N2znCa+95tvi8K9Tk/w3cE1EU+woKNcASqpwlQzp6hEfVzKVQU4haDVpV0s1MSfF5AKw52QRA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--Sig_/r1E/HN.et+YE1IVFD_tEODW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Nov 2025 18:54:04 +0100 (CET)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> On Thu, 27 Nov 2025, Milan Broz wrote:
>=20
> > Hi,
> >=20
> > On 11/12/25 6:18 AM, Aaron Rainbolt wrote: =20
> > > Not sure if this is a memory management issue, a LUKS issue, or
> > > both, so I wrote both mailing lists. =20
> >=20
> > It is not a LUKS issue; cryptsetup/LUKS activates the encrypted
> > device, so it is only the kernel/dm-crypt handling IOs.
> >=20
> > Adding cc to dm-devel as this would be another combination
> > device-mapper and encrypted swap that could cause issues...
> >=20
> > However, could you please specify exactly your storage
> > configuration?
> >=20
> > From the subject, I expected you to have an encrypted swap, but it
> > is not clear if there are other encrypted devices.
> >=20
> > Please paste at least lsblk, lsblk -f output, and also luksDump
> > (or crypttab if it is not LUKS) for LUKS/dm-crypt configuration.
> >=20
> > Thanks,
> > Milan
> >=20
> >  =20
> > >=20
> > > I'm seeing an issue with both the latest mainline kernel
> > > (6.18-rc5) and Debian 13's 6.12 kernel package. When physical
> > > memory fills up, the entire system locks up hard, as if it hit
> > > rather severe thrashing, despite the fact that there appears to
> > > be disk cache that can still be evicted, and there is ample
> > > amounts of swap space remaining (gigabytes of it). This issue did
> > > not occur with the 6.1 kernel in Debian 12. I'm seeing this occur
> > > in very low-memory Debian VMs, with between 512 and 900 MB RAM,
> > > running under VirtualBox and KVM. (I suspect, but have not
> > > verified, that I'm seeing similar behavior under Xen as well.)
> > > These VMs generally use a swappiness of 1, though I have seen a
> > > lockup occur even with a swappiness of 60. The filesystem in use,
> > > in case it matters, is ext4.
> > >=20
> > > To reproduce on a system running Linux 6.18-rc5, with :
> > >=20
> > > * Follow the steps from
> > >    https://gitlab.com/cryptsetup/cryptsetup/-/wikis/FrequentlyAskedQu=
estions,
> > >    section "2.3 How do I set up encrypted swap?", but creating a
> > >    swapfile rather than a swap partition. =20
>=20
> Hi
>=20
> Encrypted swap file is not supposed to work. It uses the loop device
> that routes the requests to a filesystem and the filesystem needs to
> allocate memory to process requests.
>=20
> So, this is what happened to you - the machine runs out of memory, it=20
> needs to swap out some pages, dm-crypt encrypts the pages and
> generates write bios, the write bios are directed to the loop device,
> the loop device directs them to the filesystem, the filesystem
> attempts to allocate more memory =3D> deadlock.
>=20
> I got the deadlock with 6.18-rc4 when I used dm-crypt on a file and I=20
> didn't get the deadlock when I used dm-crypt on a SCSI block device.
> That is expected behavior.

Is it only expected behavior since some time after kernel 6.1, or has
it always been expected behavior and encrypted swapfiles simply worked
by accident with kernel 6.1? Is there any reasonable way to reserve
some memory for in-kernel filesystem code (at least for some
filesystems like ext4 in the event it's not feasible for all of them)
that will ensure it has enough memory to handle I/O operations even if
the system is completely out of memory from userspace's perspective?
I'd be happy to try to contribute a fix if possible.

With kernel 6.1, this was working reliably, and Kicksecure (a
security-focused Debian derivative with a relatively sizable userbase)
was using encrypted swapfiles by default. We never got any reports of
lockups like we're seeing now with kernel 6.12. Whether this was
intended to work or not before, it seemed to work very well, and this
seems like a regression from our standpoint.

--
Aaron

> Note that the in-kernel OOM killer sometimes doesn't kill the
> application and discards read-only program pages (which generates big
> I/O churn and general system slowdown) - if you are hitting this
> problem, I recommend installing userspace OOM killer, such as
> earlyoom.
>=20
> Mikulas
>=20


--Sig_/r1E/HN.et+YE1IVFD_tEODW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEudh48PFXwyPDa0wGpwkWDXPHkQkFAmko3aAACgkQpwkWDXPH
kQntQhAAxJBsISFb0MTNGHlS2xtdPK9zFeL3vVCaWdSpBfMH8BQFUZVbMYrBXEBQ
JMalBPkjor4pOFJiDNIKWrir/Er67jbtlsY/nFvK5g+AOQ0CaiPcLiokv6Jfx1oR
IFy8UNm82uoMamzv61zWwzv7BdEuVctYaGBpabJX876PqxrATeYLamEOE3Rx04h8
7uFSdc3Oz3WK99/G09lAHXibZCD053Lo++JtumG7dN3p0CQ1YGWYYR9ApssYIeZq
bFYjH2SIJf2V+4D8x5NUZAVVXfvv0QoyKk8WAyivo8jKP25wSbmOiUId8npo6JQM
fsTNO5NOba5K6TZPzjfxEsHOT54qlQs/OKu2tzC37u2DVNUWwlZHs4Iqav8NlIZY
ikYQcARj+6kvEJRgjhNaBxt40zEoT1uu5maBRLqHuM8alFmmr1IwJh+QuR5WRoXL
qXFoRZoywlCZuVwrFUh/g3N+yfZXDZ04OIWxPMqkNaPwIyNOn6JXpm/tG1B/95Nn
VU/2ZRadxceBuPrzbHnLnzSLD33wFpl8181IpRBMDTSHwCA5TMtvcJhuV6+aH12x
3O1/CZ7YqyOHEHS2moKcwves7XCBqCeION5+nJoDEIgkmjOKkZx9CEBmc8v7T17v
SXayP7eYNKLbBQfhV1pSJnt8j/n9zS7lfGTzZVN+cnWiNclF1Y4=
=yBJC
-----END PGP SIGNATURE-----

--Sig_/r1E/HN.et+YE1IVFD_tEODW--

