Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B97A5FD45FC
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 23:55:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2DFD6B0089; Wed, 25 Feb 2026 18:55:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEF1C6B008A; Wed, 25 Feb 2026 18:55:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFAA66B0092; Wed, 25 Feb 2026 18:55:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CBA356B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:55:02 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 79ABB140134
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:55:02 +0000 (UTC)
X-FDA: 84484637244.10.F7F8094
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8704140006
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:55:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gQuZFizt;
	spf=pass (imf17.hostedemail.com: domain of skhawaja@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772063700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/+d/kouLLf9iKHdyjkzWOU+gVjFz9R5tJbv1KqoUtQs=;
	b=yISMe1WRjx9wjI1roBhTPB6siyQ+zWs+BYzMHxYn7rSHMHvEcSiXssgIsX1UhpA5fwsNqL
	chmQufKjUbdfCYX9af4jud8AvOx3K6XkeGIAS92vA86JWjW9ZAueP9gCZcX8BrnpCyw+xC
	ZqGHQCgKIJTSMKOwFckOBYHfjlPdZFk=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gQuZFizt;
	spf=pass (imf17.hostedemail.com: domain of skhawaja@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772063700; a=rsa-sha256;
	cv=pass;
	b=mm+SPPiV1U20TBcmUe761KQ2BMC2I+4KkKyubU1iOMzy6F5OobJflxls9VF1kI1+F8XTNx
	4/BGLRLYNL/1prYDeT0gp0Dc8L5h+hwV1tBW1ddfVTLMXONgK4GMfR396qxdfiwprCFdnP
	NK9rTWUVhHaTTCzh/gAs2d7vowr782E=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5069a785ed2so125891cf.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:55:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772063699; cv=none;
        d=google.com; s=arc-20240605;
        b=PI9yBwGEc8jprOt8oC5aBg5IWq8MSkVnejeHe0WyLMzHnbElpXtRTxzAC5Kd5EO5t7
         bYRUkmUg2izNS2OiS3f7Rzp7YP8oUTm4rwAEItkTWRoAegL0QNzFCXOQLhBVDFGO0i1l
         G8Vu+pFcqsysOW87/ZkhxaOaG9P2XLIYqdm7pCzFgj7+kSLxVhNenPL6uC55Ywfkxd9S
         GhyTKXu85n7P2GZhzq0nnvc0Va/kSt2MaegSizg1SR2qGjvgudWZHBIYqFVGErtYLLEi
         CjmhlNfR2Rxlf0fRrzjkTPQ6OTlvNp6MxfI0S/U9kg0BEwYY4GEIepILQ6e7vJISOcka
         ou5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/+d/kouLLf9iKHdyjkzWOU+gVjFz9R5tJbv1KqoUtQs=;
        fh=IEFLtxIQdQLftT7lFi0yr2LSI8sp85/F9QDpPKxpoJA=;
        b=d1ELa1GBKhiOh7vdJTZQmUy2C7Zq/7xePOQfM+EOBpftTqhbVRoBZcyCLYZTPzJylH
         azUlhnHCKogbYZYgtzcz4JO+VUKJZ9pl/wtX/l1gZhBvw05jmkYAKP0zhWJPGwc0AQOW
         5fsglZmuCjieZsevib4gS3+yXPZxZJWUYXdqck5KF4wokffRoG0ScOn07866Nnfk7fDw
         dK+Xv78WbsUUoubrqzj8u46jsX8OouwKLgb18t9sxMdHSgMMfoGdVegm1V6I+5qUr8OK
         8oo0raZa0ZuoJ89S/KmLLBMmyUS2WwljhspEc3Mkz73oFPfAczDxarpr85mRK6tRORHR
         XLeA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772063699; x=1772668499; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/+d/kouLLf9iKHdyjkzWOU+gVjFz9R5tJbv1KqoUtQs=;
        b=gQuZFiztUvACMfUDuxDjv9YSzx1bzXllbPnSQOQN2K1oXqU07xG3QGVVWjgaXbbVHt
         XGLgZcxkdr0VFaPQuzr64/8Z+pfKXA7KuKeSm2m5IrLxFUnhXvqs41o4yBpLG7isFyex
         jq22DKT471szDOVS4n6g6SSH7O7bShT/knCWFzMgljwaEpTamTA2Qn2WRviLk2zHqnIz
         JJqhTLkVU0unFJkNbHUxrw31swW+eWwKO6uewfC+ExXFQGyJX82dANp2ZcBCaKGh/JsA
         a/t80XAThP7djn1+zOYyypv53YJbRzSf4ykEHgisgQ+Lc1GmKORa0TdhFw6+EesOYIe1
         BtoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772063699; x=1772668499;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/+d/kouLLf9iKHdyjkzWOU+gVjFz9R5tJbv1KqoUtQs=;
        b=kIJHTNJKG214nTzycRXQsD9xUVdecvWrj3adVd7Ht7GVU8ZEfS2lY6mBN+8gTCkmKO
         920IppHgIOGZe9WcDIo/Oq1rROf0M44JloP3vqGE3KuXI0CHqUGJeEuYCL/h1h5gnhKT
         O/zcQFXY3B9YgnMY8g4J2vFPARxRxD0VqzjWCANx8aXPGS938Tpbn9miQpLbsxbFlY1A
         nLFJoc3GOunyt9cChkD97+6iZuwQLJZDxys6XAkNYMPeyasDmDgWsL46/JZpCnHMjsYT
         OH6PCpcECm9r/Lv04hbkiZ4t7QrpCwjNQgmouA8cJrZRh5arh7bkRRlk/flhKHOmt8aj
         crvA==
X-Forwarded-Encrypted: i=1; AJvYcCUIllNeRWVBMWgj9yvFZY7tv5uBVgk8hXUmBehVB8HjAwrgMhQQP6spCp7dZVf5KXmBKjGahdl8oA==@kvack.org
X-Gm-Message-State: AOJu0Yz6gcwzQsUGhdQwPcwWpkb9XZbINK+FvirMEFVAVMKxGsq5Knsz
	Qk59aNxNg6zvKiWoo0pn2jSTCT2UM5Sy8qI/KQ2oT9lH/rH2u04Lxzvq0ODjczdNEfTpl+tH4h5
	9k/aqI9KxISbxlKAzkcLrlnZwcmjy/hYXn/KXHo8F
X-Gm-Gg: ATEYQzygLJrfUs24+Q5X3cAUWr9vk3y5rWXal40VoJykGQ8hwhnqPJkvbB2jsMRM1bT
	NDMaOKbJVnDlcZfPdPpShrjj14PiFRuwLTgVYB0c/NLYsFjXSsnyRSXuRcJzA8IvHf6qM4vU0U+
	UlC+fGvbBB2xx2d4f3sblJ9YKhpwQDOecv5ehRV07boIF0SJwvzWVibn9OgCuIDycyzKHT02fF2
	te0hz3V4raPz+q/ybL0WUhAulugDTRAFKSFh7hNE7FPN0DEbLnNgLB642znqukoJ4BlurEu5WRZ
	etx9SyvAmgAWeGGXLp8XIqThHWlGsBFaj8W42EkT0Q==
X-Received: by 2002:a05:622a:4c:b0:4ff:cb25:998b with SMTP id
 d75a77b69052e-507441e2d95mr4895751cf.12.1772063699005; Wed, 25 Feb 2026
 15:54:59 -0800 (PST)
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-5-dmatlack@google.com>
 <20260225143328.35be89f6@shazbot.org> <aZ-CnywNgMnr6f1k@google.com>
In-Reply-To: <aZ-CnywNgMnr6f1k@google.com>
From: Samiullah Khawaja <skhawaja@google.com>
Date: Wed, 25 Feb 2026 15:54:47 -0800
X-Gm-Features: AaiRm51g4hX409PKMap5bNDNnG0XAykqCRndojsQbHHI9mzip6hP9-Z2S9ohyZI
Message-ID: <CAAywjhR4Azqx8hXRap0eLUrwetYRiX8TALEM=b+1BorPc3eJdQ@mail.gmail.com>
Subject: Re: [PATCH v2 04/22] vfio/pci: Register a file handler with Live
 Update Orchestrator
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
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
	Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 8704140006
X-Stat-Signature: y9yx8cu541i556bx448ys4u8q93647pr
X-HE-Tag: 1772063700-136851
X-HE-Meta: U2FsdGVkX1854ld+KM1A3E+Xij0UW4kLb2e3Bi44Z/dgNSHy7+TmPxdVjaADw9UvCX7Qemy13lRUjU/N+S45uRcVzkWIJhkzcnO7yhC5c4qJh87jtoN+GjON3rCIO5H1hwc65qlyA982hKMsG2y6iQelN6ccwJ/D0vHQMy+A0x5IEk/ibYEUhwYbIHVwLvye60kNWFQV8DSVVZt3TmCfawuj6uFi7SGfbVDoK6Mha0qbTuAHbdDbK7xXsm7exGPXOYO6jH6grmjdACPvIshComvuo/G4LYTCQcUKU4Zprbpcc76/3qBBmHSAr4gLOK5RHc67eeBC8P6Y0gNNn5SWYDsq2fwDeWgfd8bw4BBHTM6xBXTdcIVX/vMf4P/SkISpj/rKc/mWWbmhK58WHd6QT3/OEqFidZUgaHVrzitLUnKG81CvIXx8mTwFCFhppJNh0UAOLe3FZq3csnP491L893/I9LEXiZREFxG9p6j9ihmOQeKPQ8e+Qj3gwHzBz6DH6+8JzW3mim3YhQw5k9ElQBDdOG1UIPIONI20Gq8mV8k/FhBiCJNxi5uDbsdYGV/5626UwBgI/Y/dXrNSOXmLfKjHpIsYN0Ex0VTn7ogMZ7woqfvnQVmfAAdW/T5i7KELs7sfHKY4K+aTpZQmjgblV5JlcH1dKfjWZBn6DRDKnUq3648B4wjP3pfd1G/ToIuyhDfkMwYgJuyXIYaUjJIeWP34EKhQhhnHB3dcMx/ytAmjHmV+Hyi6LkvrGlH4lE0fDt6eD4Y/Ou7BxTgzTYMW7Yilz0+xDL25eixgdx1pchV7wfVpbkWRwxgxXhMOyUwj+Hg7km3PXnm9iwiYYuv4G2eZy9jUQpDBOt4ajjvOOzWpLWtIN0iIo78J6rRnCGlGvXnV1gmAsP0za9S++xe1yb24FDt92tRUgPGKWx+cY5Ha88TIAMyRz5rYHZjzLBdb1F3vTBQRI8saFdVt3Uw
 69O5KInx
 jggeA7QRiO5r101+FT4LaeB13un0hFTsSlJZ9EA1hHxOroec93yjsLiW3JrcLQDDvCsb6//1asJZHS1ZXcTbFHclSeOurA6ZKhPfCzvZT5UCklMi5bepBP/TrdGtGLLH3jHDKvM2DnpsXVAfqDU5TcZWHE2J8oHMC+ejE6ot26UCoDW4edkxp/cPweu9Gm0yB0VNr0XEVxraUkbN7Pwq6/6VGBMK7eQ/smIbIw2nV7RlSBNzxI9hiPyJrjImJAHBjUQ1H2m13aLuIcq4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 3:15=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2026-02-25 02:33 PM, Alex Williamson wrote:
> > On Thu, 29 Jan 2026 21:24:51 +0000
> > David Matlack <dmatlack@google.com> wrote:
>
> > > +int __init vfio_pci_liveupdate_init(void)
> > > +{
> > > +   if (!liveupdate_enabled())
> > > +           return 0;
> > > +
> > > +   return liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
> > > +}
> >
> > liveupdate_register_file_handler() "pins" vfio-pci with a
> > try_module_get().  Since this is done in our module_init function and
> > unregister occurs in our module_exit function, rather than relative
> > to any actual device binding or usage, this means vfio-pci CANNOT be
> > unloaded.  That seems bad.  Thanks,
>
> Good point. So a better approach that would allow vfio-pci to be
> unloaded would be to register the file handler when the number of
> devices bound to vfio-pci goes from 0->1 and then unregister on 1->0.

Yeah maybe a kref that gets inc/dec in probe/remove. I have a similar
problem with iommufd preservation, but I think I can handle it based
on the number of iommufd open.

I am wondering whether this file handler registration kref stuff can
be moved into LUO by adding it to LUO file_handler and the modules
only call get/put?

