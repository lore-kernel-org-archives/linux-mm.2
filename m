Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD552C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 18:49:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E2AB6B008A; Mon, 29 Jun 2026 14:49:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 993396B0092; Mon, 29 Jun 2026 14:49:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AC586B0093; Mon, 29 Jun 2026 14:49:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D4DF6B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:49:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BE1EDC14E2
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:49:26 +0000 (UTC)
X-FDA: 84933838332.24.5442B1B
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf16.hostedemail.com (Postfix) with ESMTP id C2BCD180003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:49:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UX8yWkmY;
	spf=pass (imf16.hostedemail.com: domain of dmatlack@google.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782758964;
	b=aLNSdT3PapPwMlLtGYEQlZvtMyCkQhDY31Uds4hk8thlmzhiuTcxm/QptwEAX2w5fFV2wx
	aV8IpNaGdRPVu2iMfd8iuaUtancIhevParphpeTspBPWM6QmUTPHRDNO+TgGv/LNnj/y8E
	ED9EhQ23PHDd38zPqOLvGo7CWJc151k=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782758964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VpmUvFbjkT4TIDiuBxTmd8SHESx8y5cMZtvBxkjxfFU=;
	b=62+jXzw/x4jMwgnEInGyhLPl8qH48w0K1lJbFl1L6mAzlo+Q+g+Eacd2+IHGCwKEPCTeq7
	iyA83ZYqTKOdtIq2PRksks+Rab0sNQYGxbWxJNKvj8K3Tu88GEYzWfE1L6bWHERNceLqeG
	0qSwFGJ2HxmrTwh2i0k0q4/WBhjBtL0=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UX8yWkmY;
	spf=pass (imf16.hostedemail.com: domain of dmatlack@google.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-137335bc3caso7505788c88.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:49:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782758963; cv=none;
        d=google.com; s=arc-20260327;
        b=Uroj9DI6TsY81cWwD1qM21bYrVJ0/4d3VcbO7mdWmPA1VqCQ5wffwIzbmf5I38ouRF
         1G3EjB1WK/rVlDRnDcgfVJJGhkYwrjWBjlqY0IoN8T8w+IWdzuslIVEqtmjOd3Fgz7dv
         kpUS/BIa8DTZU3f2xgKG/lHQPuJqxD9YKB/KJLMGEDLw0/1GpQGGAQfr5mXZUI7Z2UxE
         GRWxBCtxhzQYY0KCjiDC29tHjfWDpj06l/aXqrAJk9mAKxyqfQ1Bfjc3w/dfQKKtgyqb
         fpXXnqWqiwcML3UBFKLW/ML7aKMiTy6yNNjciP+hO6L19pwMdWMQ+xuXldSwqV8qaXs5
         GCtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VpmUvFbjkT4TIDiuBxTmd8SHESx8y5cMZtvBxkjxfFU=;
        fh=RkhvXHZhY+TPXvTCmvqhweyeECL0Zr6hC1PgORh1Y8k=;
        b=nURB07ZEQJrwlL2qTGFsZIOLfx9rTMhPPp7cjsvWTRubvpZJzPcSi0ZxW1K/c+m0Ik
         i0dfaees+o2/0euCvk+Y4LXKfN0nkyg7LJN2WMU0rEuIA+dgqBB9iBZ1EjaUDQMZwxap
         NgoEoE4RA+mgO84kLRb3cxxFrD+v/5xvDNabMfBp1UV6gX4a+v3X/lzmbkmYucm+gt1w
         jcHuvFV01uLAtzRNdj67fR+vYOsjl6k5VlARjCIe/xok3J98FpGfrO0bF+u8qhch65TK
         8KMHHiOzy2h1+F09wrFLntEPUfv9+R8k/HFdozVaHoNzsMotW5Rdfwahu1L5E72l0vpl
         4vdg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782758963; x=1783363763; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VpmUvFbjkT4TIDiuBxTmd8SHESx8y5cMZtvBxkjxfFU=;
        b=UX8yWkmYQRLCb/4kuFXKv1yzWKA8nsVXJKq3JTXuNtnarPD1HWz5sfKYN0OyrlBSwf
         HHkn4nlm8eHDfMC/F+rgOZr2vb/M5gTKRdAsle2y9pW5WW5e6H1MgHNjng8u60jNnHVh
         1VtDWxDX3cBy/9+OrvjI1bNRgWNrMoh/WmwYjEZX06bmEHYyZU1WkDSbcpmsTRSs7uED
         jZW0iVAtk3JQ6x3m801PbmZe1ElBhGe2KQjtYsIBAHpaOn8aNoCKukomJ1CLTJzCreMe
         ltEB+LOO67FrX0TecNYN23ohINpQNyqiY0M+TxMrD0rUcBcxGLGCQsdppTMCMEvF4kN8
         RTtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782758963; x=1783363763;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VpmUvFbjkT4TIDiuBxTmd8SHESx8y5cMZtvBxkjxfFU=;
        b=DFsn8kXCrplpx/bQnfKOZCa8JTy2tUWFQIhVhgfJS18TSynwucRKlAnNd028dOv4RH
         OkDr7kNdHEihqozTwRcriJG3+TyVpDn4rpv/ipZwcCVHfcx5TadixbmZfyniQyy6QzXU
         DNDJkqJS3JBOMKzO8yXBZHqC14z8eemoPl6jp8iiiQHOJxExHOCHMzGyTcV9IE63gs+P
         lK+PAqW4DZEP2VA6gePOlv+NhecBvzXzo/KyijhWfqAWCSGXWP1q2fZ4HdrZKgV8UKoW
         486rNH9Zuv0chcZt/PekWxh0OIe/42dwhP4uq5NWf0meUEmUtGJsPbovYe5rsNcFIEKW
         Ivnw==
X-Forwarded-Encrypted: i=1; AFNElJ8OmaS/xXATA6ELWZIP6N4eYafJxocLPB3Uu5vYx4ti1VuEY7fc8+i8BSvofUDMYYljDU8aY47pvA==@kvack.org
X-Gm-Message-State: AOJu0YyxsJohS+OJfoLIamGiF+BNc6gOsJ2YkKonH5XnWVV5bslgrMBX
	LETNsVI0t1K4HSNUbOmccgwxYMi5usLbk7nWKjnffed4XeQAXB7EKSLZz/PjhSIQnB4v3y/z4J3
	CvT0IIXVFzVaPvYq4mHWv3g23r2ywTgq4Z721uCSu
X-Gm-Gg: AfdE7cl1Ft9WvbHfDaHinZt0WO5S8aYlPHhBSuz01kpTCelhs2ESPz7k2G39ZH6ocqG
	wLbyIwvXTgh8AP70rlWYvZV7ItZdxd1fz5xC2V3F8oyFcIhWfjHRZzK9II0HjFrTa0OAHU1JBFh
	P5/ibdpXZJT2UYtHoHj5zAvz88SMZ1r0HBpi46XdAM3jqRhcpHJEeWMYovUpKK830wf031P28+J
	3S+6UxHbiMarKQm933KrQc/7z7gcnfXrjCBFDVe8w2zGM+3feqpObq6HMypLRd5XqD6tS2HB1xI
	7lwVeas=
X-Received: by 2002:a05:7022:6620:b0:136:c443:80e5 with SMTP id
 a92af1059eb24-13b2a13e510mr391503c88.6.1782758962590; Mon, 29 Jun 2026
 11:49:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260522202410.3104264-1-dmatlack@google.com> <20260522202410.3104264-4-dmatlack@google.com>
 <178144432039.1257322.9644414453415904478.b4-review@b4> <ajBgj_aSuzMZG47e@google.com>
 <2vxzechulmcp.fsf@kernel.org>
In-Reply-To: <2vxzechulmcp.fsf@kernel.org>
From: David Matlack <dmatlack@google.com>
Date: Mon, 29 Jun 2026 11:48:55 -0700
X-Gm-Features: AVVi8CddGN9A_Ob4R4wlMhPsXSn8oI36PZ00eW8upPHQmIA_C2z2tuBHbPtHPrY
Message-ID: <CALzav=fN8m9+rso7RSLR35bozZpNKv6McOR3jv1-ngxApM1BCg@mail.gmail.com>
Subject: Re: [PATCH v6 03/12] PCI: liveupdate: Track incoming preserved PCI devices
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pranjal Shrivastava <praan@google.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5z5cb1yie6by9p54p9mockj9w4cxyco8
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C2BCD180003
X-HE-Tag: 1782758964-551930
X-HE-Meta: U2FsdGVkX1+Ojsk//6tJl0XOnvaS1aK8NijkGG5lNbzTVcxyN/kI4s4upx/0kw9FbiyZpyoBMV5NjwuIoBcQgkJC8aziqCLjwfH0ppsAO5EXfw5vuF0dvCIpRgPsZFpgBuKp1MvFIl8uy1GA+wY/ZKIC0cA886aeK/JwD0SyQV4sFmqNKqGK87iHYSfsDWITrl3FNwe6lUtWG/YCKEL3a+YehfE9OfaSVyZwRDv2YuUhjQRJS0l2W0qnSpnPKvkonlKTBjJxizuhJewOII+49tEn7E4WNnvLKvU6oson74b2IVhGHR/+RqMtQxOjlmQGOG8apOP1pQkVYTnpOY/nlhLS7LnRO1gzFDSIBtCqPlCB5SnrSnaPeU2ZN5KS/P64ZVzQ/+akEHeuQfmdKB5jMQouBR5tIdulTM5m4qvDry5NIRdw6EYN2IKNsFUnDIqgIjW4Rb+OgYi8JG/uZV6Tm+q9XReG+8RjP68v8lk+51FtX17nfWZ8S7UvfWJxQu9vzZEGMsC+N+xv8OR/UJJ1/M+SjgoSf1NZIyHcgK95eTjIpOhP0ejw4NKTEXTKX9iH4OkxMEH/a1Y13uPnru3BaWaG3yjxdDC0cXU2pJ9ywq/5XETK0CPemxQ9RgrzzTKz4dX3yTXp4d+JZ2W3dLg9vcKe9Afw4ieAzHUhXIUEc182VCTRYVFMViVhRUSwYrRXUiaZkocV86B36aGfCMm2kKAYOuniEr1qjnqkIT/r+Cj6bZ/oiJLpGgSYMFZzNo1EA/zI7pc3PFuogEqtWcvmb7ZZ2kG3qSoO6YxiQ4VHS6Cq9ir1wox/ePdWQ5RrKQrAY0tHX/f1KsJWAWYc0Chn3mjooHPwtkBBD3tS1iHCjS5tPt1XwUA+qDDCqEGom5QdGnn/Ar49vioQuuCIzd1T0YxzhQMYsYS+TNThYXU8fv5udGSRFrCBx5KTBreYiea8TFrzPLVGDDAU/+VBy16
 nSJEjK6j
 3mjDEfqd1Ep06Ey6mI3Nb4+9YxWKSQpdhrRWMFE+Co5gIgjAL2qBH/t30Wzm4qE8l9VlwITGPRo3w6GrbAJiRuAUiItykwRyrwgfCotZgxq1aVfWImzV+YmTxCU9fEnjnYq4cTdoHbetrhQC2gO7XVz4DvTWv2Vks8DcaKrEEo2vgI3imM9jehY0jtczzTFycbJuBiUKjiqu1NdvujgkAjVD2IWOowYu869uJAspoG/qDBFEhNjm/sPkozG/gP0+0a1Xz/O1ZeT2EcgI25PAkZ4FENwYRhqteU0ZN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 7:35=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> Hi David,
>
> On Mon, Jun 15 2026, David Matlack wrote:
>
> > On 2026-06-14 01:38 PM, Pasha Tatashin wrote:
> >> On Fri, 22 May 2026 20:24:01 +0000, David Matlack <dmatlack@google.com=
> wrote:
> [...]
> >> > +  }
> >> > +
> >> > +  pci_info(dev, "Device was preserved by previous kernel across Liv=
e Update\n");
> >> > +  dev->liveupdate.incoming =3D dev_ser;
> >> > +
> >> > +  /*
> >> > +   * Hold the ref on the incoming FLB until pci_liveupdate_finish()=
 so
> >> > +   * that dev->liveupdate.incoming does not get freed while it is i=
n use.
> >> > +   */
> >>
> >> How would that work? If finish is not called FLB stays around until th=
e
> >> next reboot.
> >
> > True... I think if the PCI core trusts drivers to call
> > pci_liveupdate_finish() then we don't need to hold onto the incoming
> > reference here.
>
> That was my point when I was arguing against refcounts on outgoing FLBs.
> This is very easy to abuse, especially when we are talking about device
> drivers. And this refcounting mechanism makes the FLB no longer
> file-lifecycle-bound, since now it is entirely up to drivers to decide
> the lifecycle of this data.

The PCI core holds a reference to the incoming FLB for as long as it
maintains a pointer to that FLB in struct pci_dev
(dev->liveupdate.incoming). The lifetime of that pointer is aligned
with the lifetime of the file as long as the driver calls
pci_liveupdate_finish() in its file finish() callback.

If there is a bug in the driver that causes it to not call
pci_liveupdate_finish() then the FLB will leak past the file yes. But
the alternative would be to leak a pointer to freed memory in
dev->liveupdate.incoming, which could lead to UAF.

Leaking the FLB seems safer than UAF, which is why I went for the
refcounting approach.

Another approach entirely would be to drop the
dev->liveupdate.incoming and do the xarray lookup everytime instead.

>
> I have been thinking about this a bit more in the last couple days, and
> I wonder if we are doing this right. Here's an idea I have been thinking
> of.
>
> We should make live update a first class citizen in PCI. Instead of
> patching in liveupdate via the liveupdate.incoming field, and letting
> drivers figure out when to use it, we should separate out probe and
> retrieve paths entirely.
>
> Probe and retrieve are fundamentally different operations. While they
> may share some common initialization logic for the _software_ state, how
> they interface with the hardware is completely different. I think mixing
> the two will result in driver code being more spaghetti by having
> liveupdate checks sprayed out all over.

We are only planning on supporting Live Update for VFIO drivers for
the forseeable future. The VFIO work during probe is almost entirely
software state setup. The only hardware logic we need to "if" out in
the vfio-pci driver's probe() is putting the device into a low-power
mode via the runtime power manager. So I don't think we will get any
benefit from this approach, and it would be a lot more intrusive to
both the PCI core driver framework, and VFIO itself, to support this.

> This series doesn't add support for any drivers, but looking at some of
> the code we have downstream, I see this problem. The liveupdate code is
> all over the place in the driver and it is very hard to wrap one's head
> around how the device is actually retrieved.

You can find the vfio-pci driver changes here:

  https://lore.kernel.org/kvm/20260511234802.2280368-1-vipinsh@google.com/

Let's keep the discussion focused on upstream VFIO drivers since that
is all we are planning to support right now due to LUO's requirement
of file-based preservation. The downstream driver changes we are
carrying is not reflective of what we want to support upstream.

> So I think PCI core should track preserved devices, and if the device is
> preserved, it should skip the probe and wait for retrieve. Retrieve does
> the full initialization of the device. This fits in with the LUO model
> as well. You can make retrieve a callback of struct pci_driver and do
> some wrappers to talk with LUO, so device drivers don't directly
> interface with LUO at all.
>
> We should do similar things on the shutdown path. Shutdown is a
> fundamentally different operation from freeze, and so we should separate
> them out as well.

This is speculative. In practice, we haven't needed to change VFIO's
shutdown() or probe() functions so far. The only change I anticipate
needing is skipping runtime power management "put" during probe() I
mentioned above.

If we actually made retrieve() a first-class callback and used that
instead of probe(), VFIO would internally just call its probe()
function because that would be the cleanest way to set up all the
software state it needs to manage the device.

> This solves the lifetime problem as well. When PCI core is initializing,
> it knows for sure that no retrievals are going to happen. That's because
> none of the drivers have registered yet. So it can safely access the FLB
> and initialize its state. After that, drivers can register themselves
> and start accepting retrieve() calls. Once the last driver goes away,
> the FLB is freed automatically.

It's not so simple. The PCI core does not really initialize itself.
Scanning devices gets triggered externally, e.g. by ACPI, device
trees, runtime hotplug events, etc., and that is when the PCI core
gets notified about a device. None of this is synchronized with "when
drivers have registered", which I assume you are referring to
registering with LUO.

>
> I am sorry for suggesting a big refactor at v6, but the early versions
> looked good to me at the time, and I only thought more deeply about this
> when trying to figure out how we can make the lifetimes cleaner.
>
> What do you think? Does this make sense?
>
> --
> Regards,
> Pratyush Yadav

