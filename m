Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45604F4181C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 17:33:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E36C6B0088; Mon,  9 Mar 2026 13:32:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 191926B0089; Mon,  9 Mar 2026 13:32:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 069726B008A; Mon,  9 Mar 2026 13:32:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E624A6B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:32:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A45657FCA
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 17:32:58 +0000 (UTC)
X-FDA: 84527220036.17.40EFA04
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5B0E1100016
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 17:32:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=W5Yk1vh2;
	spf=pass (imf05.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773077576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mL+d40KjyhuL+4bMpXUsYaQzeUUDZaEOQ6AdzLVzNPg=;
	b=fr3QguQvodpHS5+n52xi31BLS16ndEfBqglGgPnGfZcEROB7RZACx9vEjgCA+qxiLEKH4z
	ckzAKwBzF0ebCOAb6v9uFVJs1/C3Ps/hAA4Su9hhNxzyJ1ShNvIpyuDPb7dk9SGMYT0s7z
	Up3JNFRkA2WqdTPwbv/aa4d/wv/dFr8=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=W5Yk1vh2;
	spf=pass (imf05.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773077576; a=rsa-sha256;
	cv=pass;
	b=iQzbmz3BosPf6jjAg0pzA6ZKJcXFI38Evx4PGOyDQnb2gu6lnUaWFVncNV1/ALKPHOWR6S
	rwNuphRAQRykdDJofY6BZPlfHRlZbIDkqHHHnkP3mhi4GxRSqm02UCWyK8PvF8HrJxm/Fa
	6Fl1RTajGBBjJmz+d3e5DQssqgGQL74=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5a1362c9a3cso4119811e87.2
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 10:32:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773077574; cv=none;
        d=google.com; s=arc-20240605;
        b=fqoaA7cu/wZtanPOuycTvR8cTT9sYnAYxHeZ1kiEn9WP6NyroiFBIbmXesMK+Ms3Kv
         URkyJyNNIL3iIEszy0eH8KFqCfi1YHy5mICxKzpd+zUpHmkLtIh8KAIG6R0OIkcWz9z9
         IlbDrVtR/VZu44jCBovdNi0b/YrRYT7HkA3/D/8HTYxmbXyL51JOUHW+pnp7E67NZ5fC
         p4aEL7le9E3hou8s33uO2KTjf7fj6wd1ynKywAweIg5ibowgGJIkEyipHBZwUzjCsqJc
         bCU077dHe+V7wS4OXIsNeq6GkhCyAEu94nfWzm+CytlQTnJ8ZJKPuBkn/K2LwE7joeBj
         TCAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mL+d40KjyhuL+4bMpXUsYaQzeUUDZaEOQ6AdzLVzNPg=;
        fh=g2I+FOUwL3B9dHMvih+K/MpoNXMR+D0t3ZOn3+kVcCg=;
        b=hkV2WnafVRrl6iu4FEjaIBgkmsg4DdNbHcBJyNagWSeDUmxx04j2aQpe4nYB4gA4mm
         xeZHBPfcChw/iLTJZltL2CPrJrFkTmmAv3KC9IZM5R/61qxG22aDSG66BYu0FIx7lTC8
         eehtwfCff4TkBgmHKO5VVP3FJTR3NB0SB4i7oNhoxQz54UmvhphoMMp6A2ZNrqad7HEZ
         ZVz0ZCSoeP03Fya2CA034jhjSWeLx8avRFh+yLAx5q/ZrKfkw0ELEWPDMWkE782ruTMi
         i3i9wdGFkPTHdYE1Do2rk6DI35Xx0+2cTFTdUZ2DglgdY4nSzyIW6oVS704twWAsT/E0
         o7XA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773077574; x=1773682374; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mL+d40KjyhuL+4bMpXUsYaQzeUUDZaEOQ6AdzLVzNPg=;
        b=W5Yk1vh2siJJfJZhs8yk0wTX6xKSb6VWODiRUHsNurlXAbVSuB/ogZWfRcfDaOzrxx
         Ana4xVIhEYtjgMEivuBQvrfwDubdrbpnN778GEkHvQEisxbvq0qaJKXob/RuUmbx1lAM
         Akfg4VJJ7QnnuVf49lMLjcCDN72fNiSRCi6Q1P+a7rsWoqjnmR9U3Kuzq6XSuV2d3O5W
         IsCw1PitlCrTA9a0pmqdSOuZrt5H+1JTeQH5pE7mYNC/dziazGXqHyV7/P0YPRf3ukZL
         2OE8ShyqpMHOMltjrUbNvdLW5ZCUSh/1LpOgQ+Pewqh9fz8lnNUcoT02JvYubXYVntsk
         jx/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773077574; x=1773682374;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mL+d40KjyhuL+4bMpXUsYaQzeUUDZaEOQ6AdzLVzNPg=;
        b=oeDKzv4/2F+efH2BZ+P1R3v8c40EnSpsaE8ZpkrH+2WBy9nyRf5HOfLhWErpMBqa1K
         9Q/BKiLt9A+W+zI0JsE330g4ls8VIhb57CZvvZaJFFsZI0LVk+m3CUTUeicT5zLN9Upj
         xzV+oQ0NnfS8XsWFiQhw51HVAHuFiXaF90wF54wTkhzBV9D65OpQvhNJQM6rx4LMwSUp
         iqWhPbSZPRq7jMDQM8sgcsRwBmYUn815EguLUNbZ3WrYRXTAh5Fs3zeWkR4fIC/qmwWC
         zFd/T5zOsnGnq3hVADgSG+RjE9/1m2BzVrmRnnHIzkBW5M+UozTMQq94kM4iRJXPDApk
         AxLw==
X-Forwarded-Encrypted: i=1; AJvYcCWQWHxthSutxmmhrtrCZWTTW/GdAYW/T9CAFgpNBFfV69H4BnUc+LpLKiHPfSMizW0zg76AMrIiOw==@kvack.org
X-Gm-Message-State: AOJu0YxOdm53IvnIjNV9xB/3uATlj74oMRcr05lvudYt8vI4EudLAlGP
	E5Re+za3zoz18jfZMhUmtM7DeAXMNthg7liVyKWkKfDOT4gU60n0FzZFfBbASCsU9XkNLPvia8l
	paYvzMK03/TiH6pOVS4j271pNvVm+lI2lPWdQO9HL
X-Gm-Gg: ATEYQzzMvRECd9kJmHsnPZXntbutN5CVtsDxOJPzfMotdDJTULh56KYd8EeMzAWxEtY
	BbXJmtQRyElyGo2k8lYxiAekM6Kyk6h2VcgeKu1OBD4DDScHu4JR42NxMh/IsRu1IpXj9/BvMvs
	XQedLYIgA3lczVaQI27HvzaLZCF6S7dbrKEMYyT9IfM3ikMZbg50w/nWX1FL0PQxnkEKdlJ3spu
	G/q3Cx/tdogSiXUfvFofvHSioHkXkS2VBiDA6P0gC8466lJymt5DVxqdndXqk8ej5dzT6ysCplR
	0B9D9Xkc
X-Received: by 2002:a2e:9e89:0:b0:389:fc6b:943f with SMTP id
 38308e7fff4ca-38a40b72dbbmr31791631fa.11.1773077573745; Mon, 09 Mar 2026
 10:32:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-11-dmatlack@google.com>
 <20260226170030.5a938c74@shazbot.org> <aaDqhjdLyf1qSTSh@google.com>
 <20260227084658.3767d801@shazbot.org> <CALzav=fHy23RAzhgkdaL+JA5T2tL9FT6aPgRfXUh7i9zvYCGPA@mail.gmail.com>
 <20260227105720.522ca97f@shazbot.org>
In-Reply-To: <20260227105720.522ca97f@shazbot.org>
From: David Matlack <dmatlack@google.com>
Date: Mon, 9 Mar 2026 10:32:25 -0700
X-Gm-Features: AaiRm51UQkPGi_THgF8Q61sl9tHSSk61beTImuWL9a-lckj5dJAcnYvj7LG9bmc
Message-ID: <CALzav=fjRPa_ZbXu7iFXyemcf_8Kq_dZTWT6c-A0bc6czF_Rdw@mail.gmail.com>
Subject: Re: [PATCH v2 10/22] vfio/pci: Skip reset of preserved device after
 Live Update
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5B0E1100016
X-Stat-Signature: x7stetn34cre33rcatr8n44bggqtiznz
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773077576-955494
X-HE-Meta: U2FsdGVkX199wm6cHssptYla59a1ufC7FbNEAqoExhjuNmyPpycYkG43mD7ouMskaHcKp+eiJEHi6GES6GZArRPWXE5M+LEe466/9F/3j/oFJEs9/AyxtzG3i3gmza0ZqwyTuA82lcnP1CVDMSWL+u7egg8sSsgYedufUxtjBP/rBwkgSAMk9+2KQCjDWj9BIIqZe8id48b50qvrYaKiHATf7lmSSjKp87EokqORJ/oRzBXEQ0CG7qfe3Uo9Utfrz7KSDJbANFLG5l0UcoBB+iaqnarOclxxg4ft7hBBc7nrx0nLl7aq2A0E7co8NhiGEcS/lj+/T3LU6VgJNP7rRul4LbQ08om3sDwO+FXyL9vHxIdAzXU/1u62zq998244iX8/YhDLenCp5I46dXK2G8OINldqk1sGWFF6/3ndOLiwSVqnDB8ppb6q2QMRwySC8dQPQ0F1/AvOfWRGhxAqLdQ52WKab7SOT4ExWTQw2Wi73aVlyuWVkowCYuSc8x7b2MmGZB0et8coqFCD/CWBQf1H12rf6RChFYqStC/Kxhrhc3uHLrsB6JWs9DjbKOQFAYs9QDtgbrKHCvMdfJ0VbSb3dJqH4NVtgk6Ha7PkXUYi3Yr6nTdQNgmDlp+kW5x5jtZquplKHLVfidG16rgNUujTFgvnlBfc1ygyhQrD3fUjk8woyQ1FVaTM3DhSlRyVtAg4q4mw8zxC2oVNwAPZfjV2Da/ZtA1GlmbbblOnhgK3S7QrYPaEeZzsIMY9RxRtI3eaFH0+pcKRCLV6U2s5BavHKThB4RMBR4a0cBRscxDmotsHycP+TD+AoX7qahdrm5B8gADyqzAAxoUXFSrFsf+9WaTJSdEW2TiDyFpF3Ff6pHE2HpTyS4rakUhaKCjI9W97u/tGNq2abwhDW4zWCgaH7C3H2T0668OCnCkoqQONPFKwuGvaYJQ/VoKAQ6shWgY/EZK6l6iVAJU+CAX
 W0Y8dUoB
 3jl1gNPAnlZIbEFnXolLI1KKdeqSzgHHBQDIaAnCzclDchHFtBTXUCngFpfJcW8wA7UPD6ilFyy2xK/7CztTuIPjB7qFSde6G4ElBh5yedZ/UAWsi9fgSeFLQMCqp6wghsoLv0NhTr858IItQn2vTEZYWL4HX8nIrGzxE41H3BFZstIR/vjoIrM3mF2xJZ6aQpubPlMq7rmxg7Xf2B/NwpCOBDGCFecEFrpbbggf6Z5knNu/qskJdGWNIbwtI2KZLxu+XE4Q04ZZtSjGL/IEyd6OfWddjwFtwDoiWl9lywoI8c14daVih61OBd52pqtK7FxIj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 9:57=E2=80=AFAM Alex Williamson <alex@shazbot.org> =
wrote:
>
> On Fri, 27 Feb 2026 09:07:48 -0800
> David Matlack <dmatlack@google.com> wrote:
>
> > On Fri, Feb 27, 2026 at 7:47=E2=80=AFAM Alex Williamson <alex@shazbot.o=
rg> wrote:
> > >
> > > On Fri, 27 Feb 2026 00:51:18 +0000
> > > David Matlack <dmatlack@google.com> wrote:
> > >
> > > > On 2026-02-26 05:00 PM, Alex Williamson wrote:
> > > > > On Thu, 29 Jan 2026 21:24:57 +0000
> > > > > David Matlack <dmatlack@google.com> wrote:
> > > > > >
> > > > > > - vdev->reset_works =3D !ret;
> > > > > >   pci_save_state(pdev);
> > > > > >   vdev->pci_saved_state =3D pci_store_saved_state(pdev);
> > > > >
> > > > > Isn't this a problem too?  In the first kernel we store the initi=
al,
> > > > > post reset state of the device, now we're storing some arbitrary =
state.
> > > > > This is the state we're restore when the device is closed.
> > > >
> > > > The previous kernel resets the device and restores it back to its
> > > > post reset state in vfio_pci_liveupdate_freeze() before handing off
> > > > control to the next kernel. So my intention here is that VFIO will
> > > > receive the device in that state, allowing it to call
> > > > pci_store_saved_state() here to capture the post reset state of the
> > > > device again.
> > > >
> > > > Eventually we want to drop the reset in vfio_pci_liveupdate_freeze(=
) and
> > > > preserve vdev->pci_saved_state across the Live Update. But I was ho=
ping
> > > > to add that in a follow up series to avoid this one getting too lon=
g.
> > >
> > > I appreciate reviewing this in smaller chunks, but how does userspace
> > > know whether the kernel contains a stub implementation of liveupdate =
or
> > > behaves according to the end goal?
> >
> > Would a new VFIO_DEVICE_INFO_CAP be a good way to communicate this
> > information to userspace?
>
> Sorry if I don't have the whole model in my head yet, but is exposing
> the restriction to the vfio user of the device sufficient to manage the
> liveupdate orchestration?  For example, a VFIO_DEVICE_INFO_CAP pushes
> the knowledge to QEMU... what does QEMU do with that knowledge?  Who
> imposes the policy decision to decide what support is sufficient?

Hm.. good questions. I don't think we want userspace inspecting bits
exposed by the kernel and trying to infer exactly what's being
preserved and whether it's "good enough" to use. And such a UAPI would
become tech debt once we finish development, I suspect.

A better approach would be to hide this support from userspace until
we decide it is ready for production use-cases.

To enable development and testing, we can add an opt-in mechanism,
such as CONFIG_EXPERIMENTAL or a kernel parameter. For example, adding
something like this to vfio_pci_liveupdate_preserve():

if (!IS_ENABLED(CONFIG_EXPERIMENTAL)) {
        pr_warn("vfio-pci file preservation requires
CONFIG_EXPERIMENTAL to enable!\n");
        return -EOPNOTSUPP;
}

Once we feel the support is ready, we can just submit a patch to
delete those lines, and there will be no left-over UAPI.

