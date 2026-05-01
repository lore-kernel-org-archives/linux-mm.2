Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6738CCCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 14:31:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D13DC6B008C; Fri,  1 May 2026 10:30:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC4136B0092; Fri,  1 May 2026 10:30:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB2916B0093; Fri,  1 May 2026 10:30:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A59A26B008C
	for <linux-mm@kvack.org>; Fri,  1 May 2026 10:30:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0491F1C0967
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:26:00 +0000 (UTC)
X-FDA: 84719075322.19.5607A04
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id E175A140002
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:25:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=baylibre-com.20251104.gappssmtp.com header.s=20251104 header.b=yt2qL8ue;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of aarsenovic@baylibre.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=aarsenovic@baylibre.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777645559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DYv/GlnIowzYK/Y+vOhHbB/BH7X8bAFCbDKncVCH2Ls=;
	b=J3bImO5t/0U2KCGVLzNAVkuMX11+5aE3oUnlSGefr/NeKId96+8bozKxzfQ4eX81e3gSbr
	HkGowUUB/b+Es+bkERdDUFrMHNKu2kzND5ztVMpln49SqxdX+ZWYA8WW72IDCHrXq7AfCn
	HxOl2TKNqyoPITdYVdapBqu/WTyKAq8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777645559; a=rsa-sha256;
	cv=none;
	b=xRl/8qNuG7I1K9g9VdUFPNfTL7a8iy31DiZ3UfmIg4jP2fz1zXsYFdSEUs2hlM5draUvl/
	qHpASFQQ95ciz+xIWp3XTmVojS5HAUWDR2nliqK3iGU1RZ/Oe1nf6+n0FImLF2ZKfuFOxX
	NrDbjlUKvdfuwqZVEauFZIProt9ABXM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=baylibre-com.20251104.gappssmtp.com header.s=20251104 header.b=yt2qL8ue;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of aarsenovic@baylibre.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=aarsenovic@baylibre.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4852b81c73aso13898785e9.3
        for <linux-mm@kvack.org>; Fri, 01 May 2026 07:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20251104.gappssmtp.com; s=20251104; t=1777645557; x=1778250357; darn=kvack.org;
        h=mime-version:message-id:date:user-agent:references:organization
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DYv/GlnIowzYK/Y+vOhHbB/BH7X8bAFCbDKncVCH2Ls=;
        b=yt2qL8uefinyqFUtx1mC5ZryG3EgctfX8zn7FaTgaFaNe9GmVwERNPLM/GnIpIayyx
         RC5IdMz7c2x5l6xFD8TYRt7DUKEjKslvyL36vGM3l0EUJgdqhkntPvzta0waur93AkMx
         2nhIHPnAMQ4RRjwtOT5mQNVomxsC9qcF9G+UULUl0r5uAlzFibev3twN3hRrxHaJ9ZTJ
         9Y3huuxGbwXBH+vMyDf68B4JKDAzSX9Kk7cApqsrgZedQmXPAZKgOVDV5Xr3tYbANLa5
         f7BY2W1yZzJCyiRDWZ7Lljr459PKvcdGr3G0l/uPOQwEISBVKI0ik1tXDRySn4OCJpUi
         Vsvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777645557; x=1778250357;
        h=mime-version:message-id:date:user-agent:references:organization
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DYv/GlnIowzYK/Y+vOhHbB/BH7X8bAFCbDKncVCH2Ls=;
        b=A9P7B0190KUDJYjZ0Q35J6H0Qn2uzkjKpdF59amxGADHnlYh0Ta4W+2n+NIBJnmUxR
         2PJqk1GfTnWyDOCKrS3RD4J+Vvlm0daspC1eyTGYxqasJ+n/PNy+FTFT+V7QXzMktZ1w
         IDKgOy30SB5oAwIrYydpCo+vZcRc6+JRkAQ0uukEc8KSw4sJGJUMmL21y9CrIiX40tzu
         YZc+3+LCvKmGc6025ie4VqaGXJ4Uc2u+JJO9cOCejl3kDecb+aAqw+mC9eE1mx+3q5eL
         bKYAFEKRchl11JoLd1bKq2SaqgV9koWKjqz7aNWH/MzPrAxSQq7pX3xgRU5+fgoEEEit
         tL0g==
X-Forwarded-Encrypted: i=1; AFNElJ9qFnbBOvpEMO2YcoJ5qot9S8gaSmfZHaJcKgqqlHuQeejrSao5SC3s1U5vBkRZTKnEys1Ubb0/VA==@kvack.org
X-Gm-Message-State: AOJu0Yxtqhe/DU+RFVh4xWR+3lr7XBx7bXK3AZGHI9NYIWvjv96h09KY
	9UKVykhEILCwaKMusUlUd1IJCT2hLgYTEqmZ1iR7yEhXtHKNIcAWFVLdxwB6scfvFRU=
X-Gm-Gg: AeBDieuGyqYxQMyK6yGtOSKVv+ay/VBqqRA+VOQk9ti9yYbTh+z2KzZtLCvIvDBHKx5
	g5dSskqK1dqaOrDm7nMLMn2ga2hnz7Yi5TvZ8qyE0jjE8+Vg7iyCNlxrwjUJRjNUWUOQzi0ehkb
	ivmWG41GojGJ362yaNdqWNYVEnhMrZx0+5H9MoGtjm2kalLkJtg+Xoy7+mYWMAVdTVJLlbbJm3u
	9h/z92rFzf0n/dUfp1tpbF5n6RsSTcJxRqoeSfvKPSXD0zvLtCoAWaZkXMAI6/1CvTuziTY2CTy
	jgYomrcbRV6Nwd/pPixKA9PAnUhSWwRcmXGkaqm0sdAJd/eDKe6V2CuY57vvgds7Z9QsN1ukWgg
	UhheviU1NRx9sbS575Lth0iFYp3bZsL4yWQXg1PkiDYOKBBfX2vYqrwB6OxQYNX83iBnDa4eCbi
	YxY0uywesYDuAECbOO/m4fpzqNuaMi
X-Received: by 2002:a05:600c:1f83:b0:48a:674d:e756 with SMTP id 5b1f17b1804b1-48a84458f63mr116689945e9.20.1777645556755;
        Fri, 01 May 2026 07:25:56 -0700 (PDT)
Received: from bstg ([146.70.193.12])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a8eba8487sm51896485e9.11.2026.05.01.07.25.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 07:25:56 -0700 (PDT)
From: =?utf-8?Q?Arsen_Arsenovi=C4=87?= <aarsenovic@baylibre.com>
To: Alistair Popple <apopple@nvidia.com>
Cc: amd-gfx@lists.freedesktop.org,  linux-mm@kvack.org,
  cs-tech-ext@baylibre.com
Subject: Re: [BUG] Frequent hangs or WARNINGs when using heterogeneous
 memory with an AMD MI210 GPU
In-Reply-To: <afREaF6hcka_cxnY@nvdebian.thelocal>
Organization: BayLibre
References: <86ecjz2hhr.fsf@baylibre.com> <86tssu0w8p.fsf@baylibre.com>
	<afREaF6hcka_cxnY@nvdebian.thelocal>
User-Agent: mu4e 1.14.0; emacs 31.0.50
Date: Fri, 01 May 2026 16:25:53 +0200
Message-ID: <86340bp5ou.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
X-Rspam-User: 
X-Rspamd-Queue-Id: E175A140002
X-Rspamd-Server: rspam04
X-Stat-Signature: f3xfpb13ne9gz9ejfyszyf4cs3au1mwq
X-HE-Tag: 1777645558-250665
X-HE-Meta: U2FsdGVkX18dUuy0uoUHNWyn1lVVAaxGlUQh6U8a9wFUPKXIire6AGizXhM6zdx+Bc/0aiZ4IY3RIZPhv7hIxyJbshVR6hk3qr26jeT/B4RA5yldrNvCiGfNsnxodSkLWqbxe3NkhS/XZVtsKoJU4fCk06kiJJOX9A2edMZm9/MzqDD0Kx3LhL7T6PkXt/rKBkxYzTz+qINi7AzUhYUQgEr+oAWQ3ccLE5FWQtWNCcRYeAx9ZSZE7TxZPcDLCxRa033c90dnQGXf2WGrCnt05/X//puusZ+ZQHwnePHp3W45tNlwjeBgnCMEFevmY8DpiSJT74m1qmGkSV6UzAZtkWTx9Ft6x9bBOQuTue0GYE6fFjDk3Ax2peRowxCncjzSr9yF61vdKfd/PrDq3F5r0z7REgTnhugMrRkyG6nfpfPM3ywYLtxiaKuo/CCDBH0w8uuv3PavyX2cFCuNPJNkqYVZ8elw/NwFYkeZGmMNwom6XgNRmllYB7nNucfWYZ/pHF1+socvFwCvuLUD+3El0+OwKrX5BXKHMpi1n8qmyR2wNWkLNvpCamZEjE3w0Tn3HvyHrkWjxGa0O7qEpWniq2WalPmMJm9H6gic/Yeg3xZ6dFHxYJTyh4dtbMBvZHgGTfISuWtHwUpwVuN2sKyP8yOHHzyNmodc4845OU7KVdoJnQ5OkOl+/6+uAZnCpVL1y/sNpI4PUwz7YtM0Shpuoj2WQEG1BCfvgJ1C7maJ0naixRlJeFcfLUxRkWFVaVu8M2AN+lcijBE4wsS05oWA94lbSl+BhD8malQDQbqceluWwyxsVE86DkKvlsJb/mmgimd1pef+6yieM+xqNrqZazxKD08jUn6wHmVQvgokTL9rzJtCxTWvfsQT3RSLZiRx6xuW+J0OwoOG8mqspTu8eWwEawYbh3cqOJci50PlP46mFeKjHRSraFLoO7/vEqpu5uLDHWeN9eh+BMoNFOJ
 cU5DYrE4
 Z2SzsAFQLUZLMcgpXxkIGF/zDdWr5St0faF3yTjlgbBSq1rzj/rr782ySs3B+RDmmhLLM5XiaSgROlwMUpIVOdfin/xfu2JxKh85rurtOCONIuJfSvU47/QbENp48X0f9Y3WqAngkQXeKE4V9VBG3bY8S9bbKrrIQMqvYhDQbKGTCP9zvIC0eiPEtSc0uP3hbVvTFDqtlxyVIVK43cLDy/vquNHI/tP3KIS8svLkbdvM+Up8W0gxHhIZCTuuSu0wK6DNcXi/CnwJQSYz6W4jq97ig/3ZrzDPDKcV2KYRBj82GyYNnNmvoUB2EpWX5gjRgMtf3BRUAy4SbrlIelxgQdSjiVvMOZNovLr58do1QXaKj1SpKnIlMLp0Xsowdbo4VDndle5x1zbaTvPSe7PedC3IMRzao13MWNT991OJsI/1f5ctTQmtjLhgeOR9fGGW77OWiD+ShwGufv7oCFpeq9HYg9ekRdMElVTHo1SYBBXyRWSu3ES8lXe97qj0pOQdoFjo/LaKcuGZBYHhnz/A48V3mXs9RqskEbGtXuv800zZJASB1vXO5/JQO0X5xGWWkKSMKibhjvPRWwTaTxqROGd0SZPMTwcM0tpmrI1f1zcbbDMmAsSlRe5tuKGZAG28EQpH4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Alistair Popple <apopple@nvidia.com> writes:

> I don't know the AMD driver well enough to comment definitively but
> chances are this warning is spurious. I have been meaning to put
> togeather a fix for it.  The problem is that migrate_vma_setup()
> etc. allow for migration of anonymous folios, which is subtly
> different from only allowing migration of anonymous VMA's.
>
> Specifically migrate_vma checks for folio_test_anon() which returns
> true for private file-backed VMAs while the warning is based on
> vma_is_anonymous() which is false for such mappings. So it is possible
> for the driver to migrate a private filebacked mapping to GPU memory
> which will trigger this warning during teardown if the page wasn't
> migrated back.

Ah, if it is spurious, that is quite unfortunate.  We were hoping it's
the same issue as the one the rest of the email was describing (those
hangs, unkillable processes, and bad page states), since that means we
have a good reproducer for it.

FWIW, that sounds like a plausible explanation; the program is using
dynamic_cast, so typeinfo will need to be accessed.  The typeinfo is
mmap-ped from the executable, so it's file-backed.  I don't see any
reason for this page to be thrown out of the GPU later, so it stays
mapped until exit, and causes the warning.

The trigger for the latter is significantly harder to reproduce, and far
less self-contained.

So, I suppose we're left with a bug for which the reproducer "run more
than nproc of parallel AMDGPU&HMM-utilizing processes in a loop and
cross fingers".  :/

Thank you very much for fixing the WARN_ON!

Have a lovely day.
=2D-=20
Arsen Arsenovi=C4=87

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEKBAEWCgCyFiEE/uKz0RP8AKMWLWBhUsKUMB6ixJMFAmn0t/EbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyXxSAAAAAAC4AKGlzc3Vlci1mcHJAbm90YXRpb25z
Lm9wZW5wZ3AuZmlmdGhob3JzZW1hbi5uZXRGRUUyQjNEMTEzRkMwMEEzMTYyRDYw
NjE1MkMyOTQzMDFFQTJDNDkzGBxhYXJzZW5vdmljQGJheWxpYnJlLmNvbQAKCRBS
wpQwHqLEk5KiAP9PMMBwrhXRhH/toIRa9Gd89OXC/klbJT/ORaNbQLu4ZAD/fjQY
F8L55iUDPgzIF3dph1C7Td/BL6/SbmcILMaW4QY=
=+HE3
-----END PGP SIGNATURE-----
--=-=-=--

