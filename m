Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AFE1C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 23:08:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 268786B007B; Mon, 20 Jul 2026 19:08:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 218916B008A; Mon, 20 Jul 2026 19:08:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E33D6B008C; Mon, 20 Jul 2026 19:08:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CBC146B007B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:08:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4DBED1A0332
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 23:08:18 +0000 (UTC)
X-FDA: 85010695476.28.DC2CC0F
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5F94F180005
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 23:08:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fDWAOExN;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784588896;
	b=IGVaeCNWIaVhf1pXydKI5LgAxUO8B2BqKIYUYMyreYapYJ834k06IJoJVuYx/7U0SXttef
	MyZCd0Cy7VF8mV4iOKayn4rDCDs+Y6Xn00K1Slw65stQlI8jqPHMxo2C7gazYTHyNZF6yo
	+AZIjwWKdqT6MSdXJ0GV9XsIdMoIULc=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fDWAOExN;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784588896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mSz2hdMIpgZEgySIqZijvekD49+PJVVZ/pNOTGmHIyg=;
	b=mnbZ4LcWVhFBnzXuVL+A9lismVyb5vc+5A3DwQfywePGjXoKcsrv/vSd5TgD0qwm6zzMvm
	6xjqRTjwIyz4+FgxkyRtoduaE++jDy+agp6qh/GNEFm2SmpaX0uTzLmdG40XDx0OHDnw8r
	U7JbMfNeeDIfNUltPCjcVR8hP9waqAg=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-385ea3ce80dso10771850a91.2
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 16:08:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784588895; cv=none;
        d=google.com; s=arc-20260327;
        b=sqINPsKyMTjMfb8R7Sje3OX1l/Nr+UDDokf5hHlf/7ayZ7vfK7Z8AtPP8/WNZiOzyn
         y4PiJUCYLL5caUYAgR3L17zim36AXabywfO8Vr2Wz+wYOUaXzbnoWYrD7EXTtfkGqAgg
         glhfo6heSdBrQ0Vg/DHRuH2jPxazpgTUxOQpuQ9B7ReZZKrlPr1ivmlH4h1WNRl1Nzzp
         /ys17H3a332JstXqhNNnAvV1d1tvAnpgCRH7P3zMwN6R+viXNnr67EFQsq1wpwHgQsVS
         Gkc3zuGZm2LhrixThry50WbagsTG/JfmEIqkRRSdgAzywQ6diP2c14wdkgJPU1etdwia
         4x/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mSz2hdMIpgZEgySIqZijvekD49+PJVVZ/pNOTGmHIyg=;
        fh=AoyYnkIBqiuuSm8GlMdCwMHUVTWm5MDHFXyi2FRuXgY=;
        b=Frff+UFEhtUWE+IB8LGJNvDOphU0iZCGPmUXLm04BT+ZHRDAStk1iPQho/EBqkj20q
         j7wfo7dpRP6j/I5H581EpDssnqngkyXy0kyZa9RmNlOUTcKXuaO7ikrHU1yJJ4ExLUBk
         OEjAaKy5rQ0goKN+eEvc7YX7nFSoU2JUAn8XDUv5jupTM7z9RqnL8zxwUkTDm8cX6KFg
         jNwD4IndY2G4nG2oBzZZaL0tqgSlMDLrujoBiuxVN+kCnk/qG6zT1ShacnrqCrLA2woK
         N5Hx1u5kzh6GqqI64VJwtXHAMIuMR68p1OfImKrUlER9DOLUskb0AJ8ZBFJoe3tlGqFL
         K+qw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784588895; x=1785193695; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mSz2hdMIpgZEgySIqZijvekD49+PJVVZ/pNOTGmHIyg=;
        b=fDWAOExNF9PrTBBYmFuQeaB7ZEncOPcYeLCGvge6P2wExrs06jh1ku4QQxV4kEJcLR
         5y+hbLPol+2bQop3BZAgV2PvkU93HO7rLke3o1pnqNtPA2o2TFyACXwHBKP7D51U2NFx
         8uWtHfWrPda01nIdEAExtHWN2HuT88vNBnh9yYFQHE4T9III/ddeELGbFvTQrSiokHqx
         2HFct5U6d56VWadZ497faMBol/LwHfFvHUOFm9tsgSfYsEO1fls5d5V+EjH8s8tGEoqc
         CbXv+xy/smFkNyfDsxVnXWesvwK6BSpJ0LNRrW5l/HpkPLLhljP6n4VsRcpoRGAWogQt
         N7mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784588895; x=1785193695;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mSz2hdMIpgZEgySIqZijvekD49+PJVVZ/pNOTGmHIyg=;
        b=TE89XTHIq306JiQ/N6fG4CVig29cMZYUACkbIHGGgaXnsINSRfHxw1ps68p0EsHFZS
         8WjMRdOO7rAKZKrIMbdAI97oHMnwxOR70yaBKGzQri5pglBCaTWN1g1R0Ywxb6Ka90Du
         EWAfm6AeH7Kdo+jBG/sqOyL3I1BLQkSNdftZmYEKW7iMwW+ZCuFPizibtoWC39VfzAx6
         I72x4O6Ws/5JMP7mGmhCZGQ5NmdmAVl4/slApDO25C3pF+3i+TJFVuELhrO1Vm3FKTql
         8rAvZsrB9+J6ijdBvv7Idd588ZtGHcgWBY9DgyY6UGHplqGuMnCwGnTYeQBeBs45NaFo
         d5Jw==
X-Forwarded-Encrypted: i=1; AHgh+RpQRxZVCVIvfjD/MPlXcc8e0RzDdxowlJGtvivCqZSkhqKM1NM6D3zuhqfgWPiqF4PA+oKRiAH2JA==@kvack.org
X-Gm-Message-State: AOJu0Yxc5NUK/X5MjgS0b4GzoLz6IhlDV83dN/CdCJWL22TrwBDTOfbm
	hNvvVktIGdiUVaGA6QC244CayP/zoMLn3oqxGMEG7bHtjoBqVZ4Lar2vxO0IyYoOmZyEtarrPYL
	+6vTdD+FRaY2bfWva5VlPBGziP73AFTiWFun9Cuvk
X-Gm-Gg: AR+sD126mx8cFsmv4d2aie45w+Le9Ps0ck5PCo0tSc0Vo+2X/IhoiJmwR+EPrSRVc8f
	tMPuzqXvUNVlzQ99muQS8VAQkF9iF0Mi/02l6kxQBpJZCDGHrI2OAxbLuis2U0ET6SNMUkqK69q
	i3icSC7fOsGN7RkU3RtEnZo7sK+klfa1m4BpAGNK29Hh1ZZbv1uLPwYREcW/FD24/77I00z/oVX
	tfYR9WzawW8YPJCJkSltwGTJGyb7LUgD+lZzy1zCFolyj/Imxnn0wO20UIH9A==
X-Received: by 2002:a17:90b:2703:b0:37f:9cdf:f0ab with SMTP id
 98e67ed59e1d1-38e4b53898fmr16254011a91.26.1784588894581; Mon, 20 Jul 2026
 16:08:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260710212616.1351130-1-dmatlack@google.com> <20260710212616.1351130-4-dmatlack@google.com>
 <178432481253.189683.3297727348836286619.b4-review@b4> <CALzav=e1Gcu-9TD7F--41cYqKBrStKOE4VqQ4K3PKdNuYnNmcQ@mail.gmail.com>
 <178458744511.332171.13770778781241262180.b4-reply@b4>
In-Reply-To: <178458744511.332171.13770778781241262180.b4-reply@b4>
From: David Matlack <dmatlack@google.com>
Date: Mon, 20 Jul 2026 16:07:47 -0700
X-Gm-Features: AUfX_mw2b0MAZqdoOYi7muREPJHZr01uIkETTrQ-nKl4vTsYC1YtP48BRUt3g1Y
Message-ID: <CALzav=fjTOnyg2++GFFe5B17rHqNCWW=afjsD0A=EEjycPW7Sg@mail.gmail.com>
Subject: Re: [PATCH v7 03/12] PCI: liveupdate: Track incoming preserved PCI devices
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5F94F180005
X-Stat-Signature: 5nwaytp77zu3ifb75tdnk1p3da6z4pd5
X-Rspam-User: 
X-HE-Tag: 1784588896-828122
X-HE-Meta: U2FsdGVkX1/tIkQqQAhq1a1ODdh02tJSDHIDd7ntWIRpW0aqnoI1DKdZWvwMTROzjTc1z5BJmpqK7l4chdLWXeJRthgpajMr9bnWscfzRTdAEaqdb7SLukLqwhWsPc1O6VtWLI+WCm40z5Q3/+wrwUmA+uhEQ6AsozETaa9qAyRjYGvY1TfZ5BNY8LCISefVJHy/Tlv5KCp2ODSuB8UBEmkTJ65h39UBL90Wdn/RiR6r1zWzuyt2NnDj2ejltn6aqGvnVM5/9O6PgSfuskKS8lqZRMNzSJHQel3cmiVGwrXbLZAx+m+3NxoLyNuQxZ8Y0j8poe5cN+q6Rua+VIX6UCrKwPf9wv7+QNSzN/arPSdUijQ7P62Ri/kO+C583xMGts2jaWA3DyjXh/FNE0VALsAIsiruSclp5lRFDnfL0Obpn6vgYb5qJQGsAOsuRi9P40avO3X3K2sHhMZZI0Ixdd33VXPrhC+Vdvb6X8qgAjYLo7FrbTwaMuQ2WVdQR3u2wtYCvBqo10Fi8DBeN4b7uOb8pYwOH1BZY5I8DhcxbhMN49MfSSJl451L5DYiRgeRd+o5a8Jq4JNzmnhzsKtPgBN6C/1AnWO4I59X7KtkU514fGi2zKejYqVVTJnYbVL4YpxaguXOOl3A77o3ozbb+mCVkqTaQT2KDkrlkK6dVJ34d1dXa6ARidyPnbAqhg6222vHLUkmUTHBZx7smJWFaKr4jvy9EqJgHxSsnejcqd2BH4W1t+Vum8BpZx29I4Tmfs7+6qoeg97yMXiekH6gCPOl8j9kxdjaFCGjd+baCwJQnWpTpd+WESRHzBB6z+HMAMaeFj9UJqcQfb+4cydBaYeRgsPrJtzFGx9CxudIiwP0J/m3Zm6L9Zm9p7JsgbteTH26dZcGg2/i5gu9kcoXeL4VRQuJG0e1E6lKM8dfTSwzLECyR8fJyAphXY1QUPPxLN+6KUoq0GM1UJ9mRyG
 0NrF1L3d
 NVwMAIvRJP0kQRfvLXrQx0kGQCdOmUOZz0ueoaRjIVrBFblPiCqcDA/1XaykMiS7SdfHWQKI0lGCua4hID7BGYwVzqnuKvbflFzxnNMGSaBWznOpikdcvqg9OF57EO2udl2ATMPrCeG4p8Z2b+vFy9z2XdDXndFySzvHoiFoaxWnGyEzCI3yrOY5bnf82K2uVsssg54BSGKs3WZZNBkfk1xkGTYLZWHjqktbAh1H6Fd0LUonTTTqQ0HIWECH4YduND4hFCa4osDZUm054f5LoQOwYKAnvWhTARy+j1NMewIF1NJ+cAzWIVfldA76t8R5w3sXD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 3:44=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> On 2026-07-20 14:54:51-07:00, David Matlack wrote:
> > On Fri, Jul 17, 2026 at 2:47=E2=80=AFPM Pasha Tatashin
> > <pasha.tatashin@soleen.com> wrote:
> >
> > > On Fri, 10 Jul 2026 21:26:06 +0000, David Matlack <dmatlack@google.co=
m> wrote:
> > >
> > > I am confused by this. Each preserved PCI device must have an associa=
ted
> > > FD preserved with it via LUO. I.e., vfiofd would need to be preserved=
. If
> > > the vfiofd was not reclaimed, and finish is not possible, that vfiofd
> > > would still be owned by LUO, and therefore PCI FLB refcount would sta=
y
> > > positive.
> > >
> > > However, if finish is possible, and this is the last vfiofd that is
> > > finished, FLB will be freed as soon as the reference count reaches ze=
ro,
> > > which I would think is the expected behavior.
> > >
> > > What is the point of holding a reference here, instead of only for th=
e
> > > duration of FLB access, i.e. to make sure we are accessing a valid da=
ta?
> >
> > The duration of the access is from here until pci_liveupdate_finish()
> > because that it when the pointer (dev->liveupdate.incoming) is
> > cleared. So that is why the PCI core holds the reference from here
> > until pci_liveupdate_finish().
> >
> > We could avoid this by deleteing dev->liveupdate.incoming and,
> > instead, fetching the incoming FLB and doing the xarray lookup every
> > atime the PCI core needs to access the device's incoming ser struct,
> > but that would be inefficient.
>
> Thanks for the explanation. As I understand, the most straightforward
> way to avoid holding the permanent reference is indeed to delete
> dev->liveupdate.incoming entirely and perform an xarray lookup on every
> access, like this:
>
> bool pci_liveupdate_is_incoming(struct pci_dev *dev)
> {
>         ...
>         incoming =3D pci_liveupdate_flb_get_incoming();
>         ...
>         dev_ser =3D xa_load(&incoming->xa, key);
>         ...
>         pci_liveupdate_flb_put_incoming();
>         return dev_ser && dev_ser->refcount > 0;
> }
>
> However, as you note, this is inefficient because it affects every
> single device and adds lookup overhead to every access (not sure about
> the actual cost though, xarray access is pretty fast!).
>
> We can, however, still avoid tinkering with the lifecycle of the FLB,
> and instead treat dev->liveupdate.incoming as a "hint" that we validate
> on access with a fast, liveness check:

Can you tell me more about your concern about FLB lifetime?

The lifetime of the FLB will not be affected by this reference unless
there is a bug in the driver where it fails to call
pci_liveupdate_finish() during it's file handler finish callback.

>
> 1. At Setup: In pci_liveupdate_setup_device(), we do the xarray lookup
> once, cache the pointer in dev->liveupdate.incoming, and immediately
> call pci_liveupdate_flb_put_incoming(). We do not hold a permanent
> reference.
>
> 2. On Access: When an accessor runs, instead of doing a full xarray
> lookup, it just validates the cached pointer's liveness by temporarily
> securing the FLB:
>
> static struct pci_flb_incoming *pci_liveupdate_get_incoming(struct pci_de=
v *dev)
> {
>         struct pci_flb_incoming *incoming;
>
>         incoming =3D pci_liveupdate_flb_get_incoming();
>         if (!incoming)
>                 return NULL;
>
>         if (dev->liveupdate.incoming)
>                 return incoming;
>
>         pci_liveupdate_flb_put_incoming();
>         return NULL;
> }
>
> * If get_incoming() returns NULL (the FLB has already finished/freed),
>   the hint is invalid and the device is no longer incoming.

This avoids the xarray lookup but still requires taking the incoming
FLB mutex twice (once for get and once for put) on every access. And
if there's no incoming PCI FLB, the LUO will iterate over all incoming
FLBs under the mutex to find it.

>
> * If it returns a valid pointer, the FLB is guaranteed to be alive, so
>   we can immediately use the cached dev->liveupdate.incoming pointer
>   without xarray lookups. The accessor then puts the transient
>   reference when done.
>
> 3. In Finish/Cleanup: We can simply clear dev->liveupdate.incoming,
> and decrement ser->nr_devices.
>

