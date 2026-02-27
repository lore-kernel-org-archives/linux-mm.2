Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9180FFEFB6A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0466C6B008A; Fri, 27 Feb 2026 12:20:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3B976B008C; Fri, 27 Feb 2026 12:20:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E31AD6B0092; Fri, 27 Feb 2026 12:20:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CB1B86B008A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:20:02 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7C3D4BB93E
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:20:02 +0000 (UTC)
X-FDA: 84490899444.12.A63BC64
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7D62C1A0017
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:20:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GVidoMnj;
	spf=pass (imf19.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772212800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TlM+Kfuyp7z6KhXNl7/hdctuf7el0QWvoUeGk1mQs2Q=;
	b=NNzEgQKQgz4LmYIe+4zwKFeL9ntL1lxrEuN0/2NGIeHigIyNXO7aK2iT5BJgdbWw9V1EDU
	NEcMN3F6BelvBcN2jCRZfFuNxCUoxiwFCjCGPy4ezHHJuFu/FI3fZqJ2R2w/ukpLEZmjdK
	u0KSGyijULHftrDYhnNqnyJah/HJjU8=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GVidoMnj;
	spf=pass (imf19.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772212800; a=rsa-sha256;
	cv=pass;
	b=LPCkBehAavcYD4LYwVURPFM/glGL0MHlGASa4NFG81JXf4OPspSw1kQHqdKiIeMnRdSHqr
	1560Xd/lbxhklkiUbkNOBNxmR6xfqym2DSQTtjibfYjVGV2ZqTmTa967VLXCQwxozO0Kgo
	1ACFLATSR216GRoks/gUyFq2Z8hj42M=
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-3870778358aso1192771fa.1
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:20:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772212798; cv=none;
        d=google.com; s=arc-20240605;
        b=CkjWb/JfwnfjSkRRem907ROuYAZ3z3bmC+FxykukwnHafKz2IOddDwQVCVwL/ASQ0G
         uhLVUAXWzWnjOnpwHDE0NkSV/FabqjRWVN/sMsniR9w+qBo6xD4Bp5v/PTm6mCbO9Tp3
         dml5T2iUMw0lCssuyatR6CZZb7OgPXUNhNKh2pqG8vb+G3IAclHd/+Ixg2heZv2vJBNd
         q/3w+TYSjCazyC8ln/QtcVPbLwHv3qyvPZ0SzUINAOr6RLCL2ZuGqVUd4Ubmcfg+LBlL
         gttnKVRU66dUvIBZ/OvE19JQ4pC1CAKohahl9RwXfOKOWBXWblhuLkbyCk1C8Z5KTehQ
         2FFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TlM+Kfuyp7z6KhXNl7/hdctuf7el0QWvoUeGk1mQs2Q=;
        fh=TlgAmKYIBQLvJukCLfIe66yslLwJD3twqCdi1u/pCfo=;
        b=kFI+qk3Lm1BRyrZ182TjWV3BgHX6tMMHVJB9i64v8559kyluUsTaopMDJzaQzIgYd2
         otHRFRR8uBMbXBDN5Io61GEM1dLP68I+6XX+6UFDSiGJxRO38fFyplFEUNftlnik87Qw
         NJzmeRNLODv7DmDjJfJdvumzD4nx7eKmkwk9MuBeZTTZFPMOixQvB1fgNYeNePj4WpSc
         zFr3UL/tPlDxtYemWcauFheEvhjg3HRZgAvREageDZsHeHRwzLWmDEmzhKsidOHUdFeU
         LOFV5TPSM6REBge+dRNaktp57RKWuNbpWJlHeqvhCsUtHlWBgqXeLmU3r1tvz2Fh0X3x
         xhEw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772212798; x=1772817598; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TlM+Kfuyp7z6KhXNl7/hdctuf7el0QWvoUeGk1mQs2Q=;
        b=GVidoMnjJqo1rtDXh9I9Y+SuFaomSc1b2WJQM2Kq76DVkJ3uRNFkw8S5ViXnCIZD+e
         H3wy5G9YCWolXN3JDw8wr0kqTSLGFZEoAFo7Y3JJXKWjSh5uPzaCerkLAMGze8x9fBKP
         yaMzRJu4scjrPt98k+bQe0cFjs3XDB28kOnZl8rzKqwTME21ZYVb1CV3tJoXfXr09uOi
         CLOeC7eLUY1Luzd2grHXwV4SmothsdPYsMDmA2HmZr+FyRI3rYJDLXzwmhxbKukT8xEO
         0QklwJMqf/lqxo1J1JqfZXERxZ8LYNWHRXqUggggQJLLoDuw9ccmUbrEZ18y7ZAPA3OY
         qVvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772212798; x=1772817598;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TlM+Kfuyp7z6KhXNl7/hdctuf7el0QWvoUeGk1mQs2Q=;
        b=MyPJ5bbXpknvMAKMPgSDy6s02p3Mp5E5c5tRpHgmgpgu+B2P+rT/F5SxARGtKNFfPC
         F8JdouiwQfB6h5FOX/Jrz/pO3UH+JNkKQB1J+mLPJ2YJAl7mZ1q96v00O6/X6uPvQ5NB
         94BOzxy3n/YOzUknpUIJ91Rp60WMEt0bQqn0V0rsyTi/J/5rIRrGZhbV8W8HqJ4DeDUP
         tz2bdRazG2z+9GFgRDJKQxqv0THx3xII13fvBIPIA9IqibbeRllDEDUkpP1UzF3WjGE6
         fKDT0dGjI4XHJFRtIelppUkYHFXyF5KIo95kje9iwW7ZxwIy7mrqrC62pQlfeFT5GQCT
         tCPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXAHyeo0FmFYIVwITIegacyfOjobWjr/4cla8BjN5OTJU+1Twte3pHwc+zcy09rn1vWEraxpg91Kw==@kvack.org
X-Gm-Message-State: AOJu0YwSyvDinBxlQIMxhDu9NJGYlg0w8b4g3fm+tJEAWwKNGmwT+V7T
	ZvnNyQXPcw590KC1b0WtUGUbbjhhF1X15aSKnTRtphXHwfw3+HQCpr1b8m3An7/8xLhVNiVMEsp
	GCx31Dbji5d2frXgB2N2tX4C6K7edRs/ERuCvneoo
X-Gm-Gg: ATEYQzx2qet33XaDyTUwo5Aur0PmTvsnZ2L8EZ0s4SmiojsKLLpnnqx94zGBGcol64r
	foQnjqH1vRNAg2LWAC4Mnr8YNAbdGVEYygP8vI/mmrWPq2aa8yv1m1XRkBE1dDQy2QAwhLb6piI
	V0dqLzbzeX/LGVX4DOhnRshJpe6yLODcPS4IF+qIha57nS+WByBQotGSTkhAp8Aa7KDu3cM8svH
	IMHMo+3VNuWZF1P3GMMLQMXyqoBzi+enkIUU0r/rrj9HQL09c0pLG/Op9BqMtXlP582wpPCIpAe
	velPw4c=
X-Received: by 2002:a05:651c:f17:b0:385:d0b6:6c44 with SMTP id
 38308e7fff4ca-389ff14567amr23252321fa.18.1772212798094; Fri, 27 Feb 2026
 09:19:58 -0800 (PST)
MIME-Version: 1.0
References: <20260129212510.967611-3-dmatlack@google.com> <20260225224651.GA3711085@bhelgaas>
 <aZ-TrC8P0tLYhxXO@google.com> <20260227093233.45891424@shazbot.org>
In-Reply-To: <20260227093233.45891424@shazbot.org>
From: David Matlack <dmatlack@google.com>
Date: Fri, 27 Feb 2026 09:19:28 -0800
X-Gm-Features: AaiRm514TJvedInAnynD285P6RuOXX1FfRIbxiQr5Hc2znqJUuMLjDSPlZjM6yI
Message-ID: <CALzav=dxthSXYo13rOjY710uNbu=6UjzD-OJKm-Xt=wR7oc0mg@mail.gmail.com>
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
To: Alex Williamson <alex@shazbot.org>
Cc: Bjorn Helgaas <helgaas@kernel.org>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
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
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 68qynsex8e3euqeuk7991pgnxgjnsa7a
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D62C1A0017
X-HE-Tag: 1772212800-19884
X-HE-Meta: U2FsdGVkX19NKXAfLVIUe985CLwK4mLiA+8R3V1jDYd9MoErX64ptA1S7UGqHvO7kJsLyHEOIx4yphBASZPSMUQep7Ah6i3mMK2zpl+oL2OdXYy0Xnag+eWxeTeYaOm4vxEY6Rdi4ZfXcU8mYqW3GNVWoGnSiRQcFY5/S29711aQiwKCmRfk+Smryz7qPXIdSHJsGl1IyfexS5/REizKIq/mZKQiHb6yiVeEds5F7JvGSSAP8p6bnRcqZ90g0k3SmdiMtXziI3XcpOiVonuNz1jxOGF8wtYa8R0Hx2h/i1GzRMq12HpH6z0ebi05qk+hG69AWmDqdTaunXMlFw2TTT0PltAJc495/1sBoOy7TCN/RnmZVklk1JAbVM1EfhJTMQRpFy/5TSI1tF0gZhDHn7ypCIi8ZhcOMn/yAUK0Nk0KSfBTWktH33DVIEzZXNdYieZXEq1X8Dm/wtqVrKpDXoNF1gJLPJ846uDJd+D23UdS3EthGLZKY28ruv7vIHApWACE6VuryzgnqSynnUo6lM5EZDeTVq2OlrpmrdxUAqXeSc13eaQQ6B/uFgXfzhd4qN2Vj2N5juitLyr9L9C2DFL91qKHE8Ed2lcjqG++ml4xUCTz8fZ8PhLJWy/wl4w5m/mynpDDQZTMj3/88JOR+Uww01cSsLX23QTySqeZE13xNp5FuCR3SM/FLUDG0BjRb10TylkP99pYixwMNtJG8cjhJLvqOx9+fw1lQbDVZu6Uczm5ytLwCutCGPeOyX/PEbcFVlvTKD2x7BIs3CpaHgn/Q3NcUxzHoY55Jk/Zh3soCqsQCo/DUqL8u5iMttkxK2aoEfMi+xxfXy7s9erE7SvV4XinUw68yOAIA96WU1hCeoySB1VLSRxwSp+6fZUcWrCTU/NjVQm4KNuM1Tvv/7wZjSqnLWGRM2k4BtQXJTGEccTQ+U6VIWbViWVhis9VP8++mg0b1as=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 8:32=E2=80=AFAM Alex Williamson <alex@shazbot.org> =
wrote:
>
> On Thu, 26 Feb 2026 00:28:28 +0000
> David Matlack <dmatlack@google.com> wrote:
> > > > +static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
> > > > +{
> > > > + struct pci_dev *dev =3D NULL;
> > > > + int max_nr_devices =3D 0;
> > > > + struct pci_ser *ser;
> > > > + unsigned long size;
> > > > +
> > > > + for_each_pci_dev(dev)
> > > > +         max_nr_devices++;
> > >
> > > How is this protected against hotplug?
> >
> > Pranjal raised this as well. Here was my reply:
> >
> > .  Yes, it's possible to run out space to preserve devices if devices a=
re
> > .  hot-plugged and then preserved. But I think it's better to defer
> > .  handling such a use-case exists (unless you see an obvious simple
> > .  solution). So far I am not seeing preserving hot-plugged devices
> > .  across Live Update as a high priority use-case to support.
> >
> > I am going to add a comment here in the next revision to clarify that.
> > I will also add a comment clarifying why this code doesn't bother to
> > account for VFs created after this call (preserving VFs are explicitly
> > disallowed to be preserved in this patch since they require additional
> > support).
>
> TBH, without SR-IOV support and some examples of in-kernel PF
> preservation in support of vfio-pci VFs, it seems like this only
> supports a very niche use case.

The intent is to start by supporting a simple use-case and expand to
more complex scenarios over time, including preserving VFs. Full GPU
passthrough is common at cloud providers so even non-VF preservation
support is valuable.

> I expect the majority of vfio-pci
> devices are VFs and I don't think we want to present a solution where
> the requirement is to move the PF driver to userspace.

JasonG recommended the upstream support for VF preservation be limited
to cases where the PF is also bound to VFIO:

  https://lore.kernel.org/lkml/20251003120358.GL3195829@ziepe.ca/

Within Google we have a way to support in-kernel PF drivers but we are
trying to focus on simpler use-cases first upstream.

> It's not clear,
> for example, how we can have vfio-pci variant drivers relying on
> in-kernel channels to PF drivers to support migration in this model.

Agree this still needs to be fleshed out and designed. I think the
roadmap will be something like:

 1. Get non-VF preservation working end-to-end (device fully preserved
and doing DMA continuously during Live Update).
 2. Extend to support VF preservation where the PF is also bound to vfio-pc=
i.
 3. (Maybe) Extend to support in-kernel PF drivers.

This series is the first step of #1. I have line of sight to how #2
could work since it's all VFIO.

