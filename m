Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1530109023F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 15:16:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD7356B0500; Thu, 19 Mar 2026 11:16:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAE426B0502; Thu, 19 Mar 2026 11:16:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9DC06B0503; Thu, 19 Mar 2026 11:16:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B609F6B0500
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:16:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 79C1C1B84B2
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:16:41 +0000 (UTC)
X-FDA: 84563164602.25.4AB0584
Received: from mail-qv1-f65.google.com (mail-qv1-f65.google.com [209.85.219.65])
	by imf25.hostedemail.com (Postfix) with ESMTP id 48D5AA0013
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:16:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ndufresne-ca.20230601.gappssmtp.com header.s=20230601 header.b=wKKBNBzb;
	spf=pass (imf25.hostedemail.com: domain of nicolas@ndufresne.ca designates 209.85.219.65 as permitted sender) smtp.mailfrom=nicolas@ndufresne.ca;
	dmarc=pass (policy=none) header.from=ndufresne.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773933398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w2jQTThKw1uTdLfhLRHlUZdTdDhLT36uUBu7iIxlFvk=;
	b=bvQDS2FSnbSIHtIe9LsqOrDuWlg+wQqCysbq++4b+GjPZ7f1f4/5xxpdEH7v0I22jwixf/
	zU4i9pR0sqpsGP+0oYfV/1eXX2R8XJVi1P+U+N8mqViEoRV9dSZgE7m3yaiKmwWH7yjb5g
	jhnOqyMxVMYvLuR9fw7mNz4vmvbPDpw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773933398; a=rsa-sha256;
	cv=none;
	b=p25mZ66v/EeWol3cTOmMMaK3T94qCHjM3myDhF1hlFqRwZYhXQrUYbgDGwczrTZo03DLWr
	/p6Uq2GmOGNtyy9xMwpM4SlDmUYvC2dzpuYtP751qUBN74Vhna2q1y2ps9pInqVwqtM884
	dG6lloLqNwutQdJU+H+O5yn5EXoG3p4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ndufresne-ca.20230601.gappssmtp.com header.s=20230601 header.b=wKKBNBzb;
	spf=pass (imf25.hostedemail.com: domain of nicolas@ndufresne.ca designates 209.85.219.65 as permitted sender) smtp.mailfrom=nicolas@ndufresne.ca;
	dmarc=pass (policy=none) header.from=ndufresne.ca
Received: by mail-qv1-f65.google.com with SMTP id 6a1803df08f44-899ee491af3so12005776d6.1
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20230601.gappssmtp.com; s=20230601; t=1773933397; x=1774538197; darn=kvack.org;
        h=mime-version:user-agent:autocrypt:references:in-reply-to:date:cc:to
         :from:subject:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=w2jQTThKw1uTdLfhLRHlUZdTdDhLT36uUBu7iIxlFvk=;
        b=wKKBNBzbGWPERhthRrL5PItsFANnkOIpqhECp+ikxsFkyx/FIfjif2uuIhDS4PNKDH
         MJ7PPiuxwxJDqJPu3Wrtxqagjm3hjF6iUsaQnD7WCCFDzibkm9B1kabldX5epbz2zVkO
         yofdC34uBnEi0swfaFMTt3ZGPL1wnXdK/SIyCvuT5ChOkd2Z8ObxM3bt3YWv/uDdB/NF
         pYxUk6N+EArFnf3T04HdDM19CXlTPd78PeLpqdp8RauHGX6AcvN7XTxj+8fz46WR5rCU
         ByS8+XdsRPp+B70jsG7hWugRiZZf+2C/Fug22fQOY+rVsisUt2Z+9DN28x/AtgXbHKXO
         8B2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773933397; x=1774538197;
        h=mime-version:user-agent:autocrypt:references:in-reply-to:date:cc:to
         :from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w2jQTThKw1uTdLfhLRHlUZdTdDhLT36uUBu7iIxlFvk=;
        b=WqKblbXcS4ijGYsjSQfygSWWi0BzlvweRhNZn5ty1OnQ0RkV65F8nO7WHfCPgxsLqN
         +gcn9Lsq9MVuuV5k+ZTXRK659CPKM+bkd9Iyx2RRNFukKNcg+ztgf8fT2vfVoZMqfYkN
         YNiruLHRwFUHQViicGRNCmk1pFe6acQmblbw/7siXi+bMlTp1oFsQUfB2nDJY9d4XUwF
         dAf2kK5VWwZP2GZmLzoRYAlkp6kcUjbgEhEcjL1EHUJIKw+aSfmtKWsVlf2CmfQxNBAg
         wKOc18g8fbkJE2ssOkVaewAnSXD2Mapwvb3FeMsYqxDHp5NgP9ypHWR+XVQIzLu9UZPz
         salQ==
X-Forwarded-Encrypted: i=1; AJvYcCX1+dm9QqtIQ5ARmTz4L2yInUwrX7e6+revasVHVnJPF0BzAOsXlslMqt8YzaKETG/Mj3QO8ZWfJQ==@kvack.org
X-Gm-Message-State: AOJu0YyUqeiSul8CTlppSS3x6rqIhB6VwmrsfAXo1r05PFPd9NxTbQKX
	w0j94ikROIEhJuqSeCwvmqXKz7YcqyhQ9sno/Ua6Y9wrIryyI9XQx80Nifzi24vimLuc26VP8zi
	M4FwiaqQR8A==
X-Gm-Gg: ATEYQzzZu3mEdmpMlHSX0NF6bUOa5iYZdVVtHYUUb4dUdl4/Xe5gyUDNumpR9bgd+N6
	qdWDSS/BxTeFSCTChi0kw/oTBUjttLAVqXn3EQytBieUbUVzebPygk9CnCJx6AI8FndgHpO1Uh0
	MGnqUgMC72dBPRriGEcSBHJ40JLco+bdxLbQ0wogtKPr6ot48JDCCHVBgMQMcf/JQOMTbJynjgA
	pYBlsb01LjpXviByvt50YQQrTs6J6SusmOEMqoeDspqY+SBdnEMD0pdeyPuQpqAmt8MOtW2RzBh
	OuBc5VNMtykpn3dOWO0ku8nNZ5dCVaLJtp57sxo16qLRNUp9X52x15fFZ3NL0DBMRtd5BYoxyMl
	hlSZ4Kpp+dhjT/aNfCvjzqCS6ZaoUz7F9OsYH69YqLDrhiH/vy8TiYt/b7efFtgHyG9bAtIj+Qb
	dhkURseerkUhr5UDTV4pt84DDZ0ar9
X-Received: by 2002:a0c:f104:0:b0:899:ed40:464d with SMTP id 6a1803df08f44-89c6b590f5fmr104083706d6.29.1773933396898;
        Thu, 19 Mar 2026 08:16:36 -0700 (PDT)
Received: from ?IPv6:2606:6d00:11:b76d::5ac? ([2606:6d00:11:b76d::5ac])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89c6b90d2b4sm63135116d6.19.2026.03.19.08.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 08:16:35 -0700 (PDT)
Message-ID: <a95628d3b3d573f1d91a927eb6279c143c2a2c14.camel@ndufresne.ca>
Subject: Re: Linux 7.0-rc4: v4l2src0:src: page allocation failure -
 increased memory usage in 7.0?
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Marek =?ISO-8859-1?Q?Marczykowski-G=F3recki?=
	 <marmarek@invisiblethingslab.com>, Laurent Pinchart
	 <laurent.pinchart@ideasonboard.com>, Hans de Goede <hansg@kernel.org>
Cc: linux-media@vger.kernel.org, linux-mm@kvack.org
Date: Thu, 19 Mar 2026 11:16:34 -0400
In-Reply-To: <abtAylIlW3I8s1T-@mail-itl>
References: <abtAylIlW3I8s1T-@mail-itl>
Autocrypt: addr=nicolas@ndufresne.ca; prefer-encrypt=mutual;
 keydata=mDMEaCN2ixYJKwYBBAHaRw8BAQdAM0EHepTful3JOIzcPv6ekHOenE1u0vDG1gdHFrChD
 /e0J05pY29sYXMgRHVmcmVzbmUgPG5pY29sYXNAbmR1ZnJlc25lLmNhPoicBBMWCgBEAhsDBQsJCA
 cCAiICBhUKCQgLAgQWAgMBAh4HAheABQkJZfd1FiEE7w1SgRXEw8IaBG8S2UGUUSlgcvQFAmibrjo
 CGQEACgkQ2UGUUSlgcvQlQwD/RjpU1SZYcKG6pnfnQ8ivgtTkGDRUJ8gP3fK7+XUjRNIA/iXfhXMN
 abIWxO2oCXKf3TdD7aQ4070KO6zSxIcxgNQFtDFOaWNvbGFzIER1ZnJlc25lIDxuaWNvbGFzLmR1Z
 nJlc25lQGNvbGxhYm9yYS5jb20+iJkEExYKAEECGwMFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4
 AWIQTvDVKBFcTDwhoEbxLZQZRRKWBy9AUCaCyyxgUJCWX3dQAKCRDZQZRRKWBy9ARJAP96pFmLffZ
 smBUpkyVBfFAf+zq6BJt769R0al3kHvUKdgD9G7KAHuioxD2v6SX7idpIazjzx8b8rfzwTWyOQWHC
 AAS0LU5pY29sYXMgRHVmcmVzbmUgPG5pY29sYXMuZHVmcmVzbmVAZ21haWwuY29tPoiZBBMWCgBBF
 iEE7w1SgRXEw8IaBG8S2UGUUSlgcvQFAmibrGYCGwMFCQll93UFCwkIBwICIgIGFQoJCAsCBBYCAw
 ECHgcCF4AACgkQ2UGUUSlgcvRObgD/YnQjfi4+L8f4fI7p1pPMTwRTcaRdy6aqkKEmKsCArzQBAK8
 bRLv9QjuqsE6oQZra/RB4widZPvphs78H0P6NmpIJ
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-HFUCsXEeUhtZsg9l+P4Y"
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 48D5AA0013
X-Stat-Signature: w7q5rzcwzygj9q8cy5mwcothkma9afp3
X-HE-Tag: 1773933398-647465
X-HE-Meta: U2FsdGVkX1+cg4oA1AZ+W9VVqanIbZOy5bpRr97Hnublu2umPB4MpU0z3McuQc2zaO24Rg+0IIw3oFnNkiMzFV1HuRgC31tqa/BRDjnYCgWfT4SG1eA9WlOtWRVOpPtosPpXA5Y8+Ckyc3yRQLTp6lo3/eDTYjYwIdEuFAZyqPQwO5KTbiGLD2b1yjnJdfxTT1OcWUa/hc86KAyZawePe6VCT3e3JGMTQBNz7KKopYgMPxS0MW+rDtiVQYFmahRh1CRnZUJz5mJ02CDY258obWqotNC8G5J4j8e5LdXCTDWjU3ebnMvKbVU3S/yj2ODDTkvr6W/stPWq/awdEEGuXIR19Wi2t+mWue0xEvoG6pOcOJCgpd8Q3m9uwaZTfhPQVTUtsWvklD+wD1nex/EZu13TQsXfTO20T3UjKgRO0HfmpLs/f39JrsBAPeqG0JvTM59GTpEi0+HqmmZBf80Jf6uP4RvTyCI6NBIdscZzxxsosgTKqBeFLd6/fIISche4V0g0Y7PwoTKNUjcW4FfY9KipM90EfFIm+mir1msa6mQMPGT6WAaY/7HR/DQZCyHcBIT4IoCsEWKZBefhkCxIe9B4NIhjcedIPU8sUPpwLyzhIUOYBMVZeNHde2M5WYJsDg4kwXGpCO85b5B9Nn13HenoKvKlzn0aS6CJZ7ktamVqkhlLIlR0iZ+NljsV2Xoiibut+Ul6e/xyJm/+DtPLTn0BeuUhhv4xWmS5V9DG8KzwJ3BB2siwd0zNw1PS6NmF80FOA9pwYr1RcT/byP9A5myiWyvyXy6ybW8dn4aYWr88TpHxkPad53Oy0maf57ppFBm3gmT7oXlu2hrlzdSYuINi/sSzPAypFPB9Sw0NXzKsSQMwnBneaS3NPuq0zF1gAXwFf3TZ8WutmcOqgcX0Nq1m3lYVvvIN+eyo+bQGSricIigVN/GWiins7VXXYubndKJrBQNbrasowu0AodI
 r42AWr2v
 mZaG9En5xHk2II95lcRxKM9fmZO9h11gGtUrDm6yJh3yXlkMn3IOnbbCtJKNCSnoku5/K5Jm7bcxqORdOxCwkFe2x1XK8iXUt0XVkEgIkM+KgW08zZlO2jFXxspfUabNgnrOOBL6nEv7c9bqb6mBUTMbjdkS+LF0P9FIc3gkXBZLlcZwOjAI9Ldkx/1RYnXje06YBIcFjhu5eM88qzfDKvI/d2LkPVDO28+xgGNb2hg7DaIhfVTJLcAGh6d3su/aVMj8Ccw1LQ+4RdyqR4eLfijn46Q9dmT5EuebqfYw72xgTG4Djg4UWS2o/W7Z5+/VZx+HFODku5wDGOwcXEknQhqGjkhxH06BKslrS+OPdVCzLZF4TpRSzaeHlKzDxk7CoNuZgw7nX4CrTn3E2kHCibky8NOi0ypgBHUenImkoJgTnMJpaMeEIA2NRN1iA1f0yrmtePeHADn1Ahx035LUZaS95RKKfrG8zp3XGdvq8el1hZyJPRWBYqDDQ1j6tBfewHzOhkRnsRxVgQNu9HHCd4kU0zPmYGu5KJ5YuBj5Zc6Rtou5KQ3rruLHQ8bH3nqJepSOV9h1kBH482UdRJKFKkgPrNyEF9k86N/qSRbmWKj1yiJJZ/PsceW0mcXeN30JNI5dKSFSBhRU7vR5boG7H3drtQpDtClhKs+XN5C3azSUHJbM+Ase4LU3GyJMfnzjKpc3fSHpEUnw0w3rY6ll4/aDbbHlOsaRD/V/PfInQp/spypA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-HFUCsXEeUhtZsg9l+P4Y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Le jeudi 19 mars 2026 =C3=A0 01:18 +0100, Marek Marczykowski-G=C3=B3recki a=
 =C3=A9crit=C2=A0:
> Hello,
>=20
> When testing 7.0-rc4 (and also got it with 7.0-rc1), I got page
> allocation failure in uvcvideo when using v4l2 camera in a VM. The setup
> is rather memory constrained - it's a HVM with just 300MB of memory
> running on Xen, with PCI passthrough of USB controllers (to which an USB
> camera is connected). But the very same setup works just fine with older
> kernel (last known good is 6.19.5, built with the same config).
>=20
> I'm not exactly sure if uvcvideo is really to blame here, or is it just
> a victim of something else using more memory. Any advice how to check
> for that?

I've seen the same backtrace this morning but on 6.19.7-200.fc43.x86_64 and
through Pipewire instead of GStreamer. I think that rules out the userspace=
. To
me it seems quite likely a UVC regression that got backported).

Nicolas

>=20
> The specific error is:
>=20
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.040844] systemd-journald[251]: Under memor=
y pressure, flushing
> caches.
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193589] v4l2src0:src: page allocation fail=
ure: order:5,
> mode:0xcc4(GFP_KERNEL|GFP_DMA32), nodemask=3D(null),cpuset=3D/,mems_allow=
ed=3D0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193645] CPU: 0 UID: 1000 PID: 1305 Comm: v=
4l2src0:src Not tainted
> 7.0.0-0.rc4.1.qubes.1001.fc41.x86_64 #1 PREEMPT(full)=20
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193648] Hardware name: Xen HVM domU, BIOS =
4.19.4 03/17/2026
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193649] Call Trace:
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193652]=C2=A0 <TASK>
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193656]=C2=A0 dump_stack_lvl+0x5d/0x80
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193661]=C2=A0 warn_alloc+0x162/0x190
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193665]=C2=A0 ? __alloc_pages_direct_compa=
ct+0x1bc/0x220
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193669]=C2=A0 __alloc_pages_slowpath.const=
prop.0+0x4ea/0xb30
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193672]=C2=A0 ? kernfs_activate+0x4c/0x60
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193676]=C2=A0 __alloc_frozen_pages_noprof+=
0x2ff/0x340
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193679]=C2=A0 __alloc_pages_noprof+0xe/0x2=
0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193682]=C2=A0 __dma_direct_alloc_pages.isr=
a.0+0x183/0x310
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193688]=C2=A0 dma_direct_alloc_pages+0x3f/=
0x190
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193693]=C2=A0 dma_alloc_noncontiguous+0xdd=
/0x290
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193698]=C2=A0 ? usb_create_ep_devs+0xab/0x=
100
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193701]=C2=A0 usb_alloc_noncoherent+0x45/0=
xa0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193709]=C2=A0 uvc_alloc_urb_buffers.part.0=
+0x93/0x130 [uvcvideo]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193722]=C2=A0 uvc_video_start_transfer+0x1=
9d/0x4e0 [uvcvideo]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193735]=C2=A0 uvc_video_start_streaming+0x=
ab/0x100 [uvcvideo]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193744]=C2=A0 uvc_start_streaming_video+0x=
ec/0x110 [uvcvideo]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193752]=C2=A0 vb2_start_streaming+0x63/0x1=
30 [videobuf2_common]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193761]=C2=A0 vb2_core_streamon+0x98/0xf0 =
[videobuf2_common]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193767]=C2=A0 ? vb2_ioctl_streamon+0x15/0x=
60 [videobuf2_v4l2]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193773]=C2=A0 __video_do_ioctl+0x419/0x540=
 [videodev]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193799]=C2=A0 video_usercopy+0x23b/0x630 [=
videodev]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193819]=C2=A0 ? __pfx___video_do_ioctl+0x1=
0/0x10 [videodev]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193836]=C2=A0 v4l2_ioctl+0x6b/0xa0 [videod=
ev]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193851]=C2=A0 __x64_sys_ioctl+0x96/0xe0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193855]=C2=A0 do_syscall_64+0x120/0x6c0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193859]=C2=A0 ? do_read_fault+0xf5/0x220
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193863]=C2=A0 ? do_fault+0x148/0x270
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193865]=C2=A0 ? __handle_mm_fault+0x470/0x=
6c0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193868]=C2=A0 ? count_memcg_events+0xeb/0x=
1b0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193871]=C2=A0 ? handle_mm_fault+0x220/0x34=
0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193873]=C2=A0 ? do_user_addr_fault+0x1e5/0=
x7f0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193876]=C2=A0 ? arch_exit_to_user_mode_pre=
pare.isra.0+0x9f/0xe0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193880]=C2=A0 entry_SYSCALL_64_after_hwfra=
me+0x76/0x7e
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193883] RIP: 0033:0x738e787000ed
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193886] Code: 04 25 28 00 00 00 48 89 45 c=
8 31 c0 48 8d 45 10 c7 45
> b0 10 00 00 00 48 89 45 b8 48 8d 45 d0 48 89 45 c0 b8 10 00 00 00 0f 05 <=
89>
> c2 3d 00 f0 ff ff 77 1a 48 8b 45 c8 64 48 2b 04 25 28 00 00 00
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193888] RSP: 002b:0000738e730e6a00 EFLAGS:=
 00000246 ORIG_RAX:
> 0000000000000010
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193890] RAX: ffffffffffffffda RBX: 0000738=
e64008850 RCX:
> 0000738e787000ed
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193892] RDX: 000059d3df721cf0 RSI: 0000000=
040045612 RDI:
> 0000000000000010
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193893] RBP: 0000738e730e6a50 R08: 0000738=
e6400ae40 R09:
> 0000000000000000
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193894] R10: 0000738e6400ae30 R11: 0000000=
000000246 R12:
> 0000000000000000
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193895] R13: 0000738e640012d0 R14: 0000738=
e64008850 R15:
> 0000000000000002
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193897]=C2=A0 </TASK>
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.193907] Mem-Info:
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.194897] active_anon:362 inactive_anon:3172=
 isolated_anon:0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.194897]=C2=A0 active_file:2498 inactive_fi=
le:11687 isolated_file:1
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.194897]=C2=A0 unevictable:0 dirty:0 writeb=
ack:4
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.194897]=C2=A0 slab_reclaimable:3707 slab_u=
nreclaimable:10022
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.194897]=C2=A0 mapped:4710 shmem:9 pagetabl=
es:1021
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.194897]=C2=A0 sec_pagetables:0 bounce:0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.194897]=C2=A0 kernel_misc_reclaimable:0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.194897]=C2=A0 free:3452 free_pcp:1 free_cm=
a:0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.195008] Node 0 active_anon:1448kB inactive=
_anon:12688kB
> active_file:9992kB inactive_file:46748kB unevictable:0kB isolated(anon):0=
kB
> isolated(file):4kB mapped:18840kB dirty:0kB writeback:16kB shmem:36kB
> shmem_thp:0kB shmem_pmdmapped:0kB anon_thp:0kB kernel_stack:2416kB
> pagetables:4084kB sec_pagetables:0kB all_unreclaimable? no Balloon:16384k=
B
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.195097] Node 0 DMA free:2828kB boost:0kB m=
in:132kB low:164kB
> high:196kB reserved_highatomic:0KB free_highatomic:0KB active_anon:224kB
> inactive_anon:940kB active_file:1360kB inactive_file:2408kB unevictable:0=
kB
> writepending:0kB zspages:0kB present:15992kB managed:15360kB mlocked:0kB
> bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.195186] lowmem_reserve[]: 0 195 195 195 19=
5
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196280] Node 0 DMA32 free:14880kB boost:38=
56kB min:5572kB
> low:6000kB high:6428kB reserved_highatomic:0KB free_highatomic:0KB
> active_anon:1224kB inactive_anon:11728kB active_file:8632kB
> inactive_file:40024kB unevictable:0kB writepending:16kB zspages:0kB
> present:274348kB managed:200080kB mlocked:0kB bounce:0kB free_pcp:316kB
> local_pcp:236kB free_cma:0kB
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196372] lowmem_reserve[]: 0 0 0 0 0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196388] Node 0 DMA: 193*4kB (UM) 213*8kB (=
UM) 22*16kB (UM) 0*32kB
> 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =3D 2828kB
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196433] Node 0 DMA32: 1631*4kB (UME) 764*8=
kB (UME) 138*16kB (UME)
> 8*32kB (UM) 3*64kB (M) 1*128kB (M) 0*256kB 0*512kB 0*1024kB 0*2048kB 0*40=
96kB
> =3D 15420kB
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196487] Node 0 hugepages_total=3D0 hugepag=
es_free=3D0 hugepages_surp=3D0
> hugepages_size=3D2048kB
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196514] 14914 total pagecache pages
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196527] 2073 pages in swap cache
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196539] Free swap=C2=A0 =3D 961672kB
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196551] Total swap =3D 1048572kB
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196563] 72585 pages RAM
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196572] 0 pages HighMem/MovableOnly
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196584] 18725 pages reserved
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196596] 0 pages cma reserved
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196608] 0 pages hwpoisoned
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196620] Memory cgroup min protection 0kB -=
- low protection 0kB
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196627] ------------[ cut here ]----------=
--
>=20
> Additionally, this failure isn't handled gracefully, it's followed with:
>=20
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196672] UBSAN: shift-out-of-bounds in /bui=
lddir/build/BUILD/kernel-
> latest-7.0-build/kernel-latest-7.0/linux-7.0-rc4/mm/page_alloc.c:1403:22
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196710] shift exponent 52 is too large for=
 32-bit type 'int'
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196730] CPU: 1 UID: 1000 PID: 1305 Comm: v=
4l2src0:src Not tainted
> 7.0.0-0.rc4.1.qubes.1001.fc41.x86_64 #1 PREEMPT(full)=20
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196733] Hardware name: Xen HVM domU, BIOS =
4.19.4 03/17/2026
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196734] Call Trace:
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196737]=C2=A0 <TASK>
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196739]=C2=A0 dump_stack_lvl+0x5d/0x80
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196744]=C2=A0 ubsan_epilogue+0x5/0x2b
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196746]=C2=A0 __ubsan_handle_shift_out_of_=
bounds.cold+0x61/0xe6
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196749]=C2=A0 __free_pages_ok.cold+0x13/0x=
a8
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196753]=C2=A0 dma_free_noncontiguous+0xbf/=
0xe0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196756]=C2=A0 ? usb_free_noncoherent+0x3a/=
0x60
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196761]=C2=A0 uvc_free_urb_buffers+0x38/0x=
90 [uvcvideo]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196773]=C2=A0 uvc_alloc_urb_buffers.part.0=
+0xe6/0x130 [uvcvideo]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196781]=C2=A0 uvc_video_start_transfer+0x1=
9d/0x4e0 [uvcvideo]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196789]=C2=A0 uvc_video_start_streaming+0x=
ab/0x100 [uvcvideo]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196797]=C2=A0 uvc_start_streaming_video+0x=
ec/0x110 [uvcvideo]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196806]=C2=A0 vb2_start_streaming+0x63/0x1=
30 [videobuf2_common]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196813]=C2=A0 vb2_core_streamon+0x98/0xf0 =
[videobuf2_common]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196819]=C2=A0 ? vb2_ioctl_streamon+0x15/0x=
60 [videobuf2_v4l2]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196824]=C2=A0 __video_do_ioctl+0x419/0x540=
 [videodev]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196847]=C2=A0 video_usercopy+0x23b/0x630 [=
videodev]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196863]=C2=A0 ? __pfx___video_do_ioctl+0x1=
0/0x10 [videodev]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196880]=C2=A0 v4l2_ioctl+0x6b/0xa0 [videod=
ev]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196895]=C2=A0 __x64_sys_ioctl+0x96/0xe0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196898]=C2=A0 do_syscall_64+0x120/0x6c0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196902]=C2=A0 ? do_read_fault+0xf5/0x220
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196906]=C2=A0 ? do_fault+0x148/0x270
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196908]=C2=A0 ? __handle_mm_fault+0x470/0x=
6c0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196911]=C2=A0 ? count_memcg_events+0xeb/0x=
1b0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196914]=C2=A0 ? handle_mm_fault+0x220/0x34=
0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196916]=C2=A0 ? do_user_addr_fault+0x1e5/0=
x7f0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196920]=C2=A0 ? arch_exit_to_user_mode_pre=
pare.isra.0+0x9f/0xe0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196924]=C2=A0 entry_SYSCALL_64_after_hwfra=
me+0x76/0x7e
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196926] RIP: 0033:0x738e787000ed
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196929] Code: 04 25 28 00 00 00 48 89 45 c=
8 31 c0 48 8d 45 10 c7 45
> b0 10 00 00 00 48 89 45 b8 48 8d 45 d0 48 89 45 c0 b8 10 00 00 00 0f 05 <=
89>
> c2 3d 00 f0 ff ff 77 1a 48 8b 45 c8 64 48 2b 04 25 28 00 00 00
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196930] RSP: 002b:0000738e730e6a00 EFLAGS:=
 00000246 ORIG_RAX:
> 0000000000000010
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196933] RAX: ffffffffffffffda RBX: 0000738=
e64008850 RCX:
> 0000738e787000ed
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196934] RDX: 000059d3df721cf0 RSI: 0000000=
040045612 RDI:
> 0000000000000010
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196935] RBP: 0000738e730e6a50 R08: 0000738=
e6400ae40 R09:
> 0000000000000000
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196936] R10: 0000738e6400ae30 R11: 0000000=
000000246 R12:
> 0000000000000000
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196937] R13: 0000738e640012d0 R14: 0000738=
e64008850 R15:
> 0000000000000002
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196939]=C2=A0 </TASK>
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.196940] ---[ end trace ]---
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.197835] BUG: Bad page state in process v4l=
2src0:src=C2=A0 pfn:009a0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198028] page: refcount:0 mapcount:0 mappin=
g:0000000000000000
> index:0x2a pfn:0x9a0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198054] flags: 0x7ffffc0000000(node=3D0|zo=
ne=3D0|lastcpupid=3D0x1fffff)
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198074] page_type: f0(buddy)
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198088] raw: 0007ffffc0000000 fffffac1c002=
6a08 fffffac1c0025e08
> 0000000000000000
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198111] raw: 000000000000002a 000000000000=
0002 00000000f0000000
> 0000000000000000
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198133] page dumped because: nonzero mapco=
unt
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198149] Modules linked in: nft_reject_ipv6=
 nf_reject_ipv6
> nft_reject_ipv4 nf_reject_ipv4 nft_reject nft_ct nft_masq nft_chain_nat n=
f_nat
> nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables uvcvideo ath3k btusb
> btmtk uvc videobuf2_vmalloc btrtl videobuf2_memops videobuf2_v4l2 cdc_mbi=
m
> btbcm cdc_ncm videobuf2_common btintel cdc_ether usbnet videodev bluetoot=
h mii
> cdc_wdm mc rfkill cdc_acm joydev intel_rapl_msr intel_rapl_common
> ghash_clmulni_intel xhci_pci xhci_hcd ehci_pci ehci_hcd pcspkr i2c_piix4
> ata_generic pata_acpi i2c_smbus serio_raw xen_scsiback target_core_mod
> xen_netback xen_privcmd xen_gntdev xen_gntalloc xen_blkback xen_evtchn i2=
c_dev
> fuse loop nfnetlink overlay xen_blkfront
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198472] CPU: 1 UID: 1000 PID: 1305 Comm: v=
4l2src0:src Not tainted
> 7.0.0-0.rc4.1.qubes.1001.fc41.x86_64 #1 PREEMPT(full)=20
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198475] Hardware name: Xen HVM domU, BIOS =
4.19.4 03/17/2026
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198477] Call Trace:
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198479]=C2=A0 <TASK>
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198480]=C2=A0 dump_stack_lvl+0x5d/0x80
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198485]=C2=A0 bad_page.cold+0x7a/0x91
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198488]=C2=A0 __free_pages_ok+0x481/0x680
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198491]=C2=A0 dma_free_noncontiguous+0xbf/=
0xe0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198494]=C2=A0 ? usb_free_noncoherent+0x3a/=
0x60
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198497]=C2=A0 uvc_free_urb_buffers+0x38/0x=
90 [uvcvideo]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198507]=C2=A0 uvc_alloc_urb_buffers.part.0=
+0xe6/0x130 [uvcvideo]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198515]=C2=A0 uvc_video_start_transfer+0x1=
9d/0x4e0 [uvcvideo]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198523]=C2=A0 uvc_video_start_streaming+0x=
ab/0x100 [uvcvideo]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198531]=C2=A0 uvc_start_streaming_video+0x=
ec/0x110 [uvcvideo]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198539]=C2=A0 vb2_start_streaming+0x63/0x1=
30 [videobuf2_common]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198546]=C2=A0 vb2_core_streamon+0x98/0xf0 =
[videobuf2_common]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198551]=C2=A0 ? vb2_ioctl_streamon+0x15/0x=
60 [videobuf2_v4l2]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198555]=C2=A0 __video_do_ioctl+0x419/0x540=
 [videodev]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198574]=C2=A0 video_usercopy+0x23b/0x630 [=
videodev]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198590]=C2=A0 ? __pfx___video_do_ioctl+0x1=
0/0x10 [videodev]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198607]=C2=A0 v4l2_ioctl+0x6b/0xa0 [videod=
ev]
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198622]=C2=A0 __x64_sys_ioctl+0x96/0xe0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198625]=C2=A0 do_syscall_64+0x120/0x6c0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198629]=C2=A0 ? do_read_fault+0xf5/0x220
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198632]=C2=A0 ? do_fault+0x148/0x270
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198635]=C2=A0 ? __handle_mm_fault+0x470/0x=
6c0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198637]=C2=A0 ? count_memcg_events+0xeb/0x=
1b0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198640]=C2=A0 ? handle_mm_fault+0x220/0x34=
0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198642]=C2=A0 ? do_user_addr_fault+0x1e5/0=
x7f0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198645]=C2=A0 ? arch_exit_to_user_mode_pre=
pare.isra.0+0x9f/0xe0
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198648]=C2=A0 entry_SYSCALL_64_after_hwfra=
me+0x76/0x7e
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198651] RIP: 0033:0x738e787000ed
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198653] Code: 04 25 28 00 00 00 48 89 45 c=
8 31 c0 48 8d 45 10 c7 45
> b0 10 00 00 00 48 89 45 b8 48 8d 45 d0 48 89 45 c0 b8 10 00 00 00 0f 05 <=
89>
> c2 3d 00 f0 ff ff 77 1a 48 8b 45 c8 64 48 2b 04 25 28 00 00 00
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198654] RSP: 002b:0000738e730e6a00 EFLAGS:=
 00000246 ORIG_RAX:
> 0000000000000010
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198656] RAX: ffffffffffffffda RBX: 0000738=
e64008850 RCX:
> 0000738e787000ed
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198657] RDX: 000059d3df721cf0 RSI: 0000000=
040045612 RDI:
> 0000000000000010
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198658] RBP: 0000738e730e6a50 R08: 0000738=
e6400ae40 R09:
> 0000000000000000
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198659] R10: 0000738e6400ae30 R11: 0000000=
000000246 R12:
> 0000000000000000
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198660] R13: 0000738e640012d0 R14: 0000738=
e64008850 R15:
> 0000000000000002
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198662]=C2=A0 </TASK>
> =C2=A0=C2=A0=C2=A0 [=C2=A0 739.198663] Disabling lock debugging due to ke=
rnel taint
>=20
> And eventually kernel panic:
>=20
> =C2=A0=C2=A0=C2=A0 [=C2=A0 740.464422] BUG: unable to handle page fault f=
or address:
> fffffac1c0800000
> =C2=A0=C2=A0=C2=A0 [=C2=A0 740.464454] #PF: supervisor read access in ker=
nel mode
> =C2=A0=C2=A0=C2=A0 [=C2=A0 740.464471] #PF: error_code(0x0000) - not-pres=
ent page
> =C2=A0=C2=A0=C2=A0 [=C2=A0 740.464488] PGD 11be0067 P4D 11be0067 PUD 1148=
f067 PMD 0=20
>=20
> Full console log is at:
> https://gist.github.com/marmarek/5d839f419b1d56e71a48e74ae66f0e7a

--=-HFUCsXEeUhtZsg9l+P4Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTvDVKBFcTDwhoEbxLZQZRRKWBy9AUCabwTUgAKCRDZQZRRKWBy
9JvaAPwNrk8UL2YIOTVSho1vd7sSZyPPfRuNRyAD82pcLPnNDAEA8NnL7zYN+wj3
6g1aTtXVVkbSXkhXXpdzl81rlmp41Qc=
=o/T2
-----END PGP SIGNATURE-----

--=-HFUCsXEeUhtZsg9l+P4Y--

