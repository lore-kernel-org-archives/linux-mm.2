Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FFEA606A338
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 16:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kEfQiloE
Received: by kanga.kvack.org (Postfix)
	id 7786C6B05B1; Mon, 16 Nov 2026 11:46:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 728D56B05B2; Mon, 16 Nov 2026 11:46:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F1666B05B4; Mon, 16 Nov 2026 11:46:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DA856B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:46:08 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DFDA740178
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:46:07 +0000 (UTC)
X-FDA: 85441559574.22.B5D0572
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf27.hostedemail.com (Postfix) with ESMTP id D3B3840010
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:46:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=kEfQiloE;
	spf=pass (imf27.hostedemail.com: domain of dmatlack@google.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794847566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uRx112H2Vi/wC2nTJxgIojxoar70KiA3HIwHfFiZZ3M=;
	b=5W5PgMm7GZQrG7C5GDjGpSu0MgnNengaIAIIQK4q9e8/PQt5uk6IbuQtSyl/Ztfh80zWLO
	Qz+ori4IPedDOSXqb7m+bX3q25lOpaXC7ZBaXw4vv58nYGCG7h2ZUrSXV8LVauZe1ImwaP
	Y11clYVW5lW3YIg394IFDsZ3L9AfID8=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=kEfQiloE;
	spf=pass (imf27.hostedemail.com: domain of dmatlack@google.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794847566;
	b=zxmU3OgrLLWKt/uYMHHubNn5HofeJYQ1Wq6GD7yk4hEqavqbLNBwmeH7vXsW6NkONqdVGn
	grC7jVg20PEhvpWyAg0BsMdIwODsy5lbaF4CO5kFEXRO/MUuEV0z2I1GGj8sKJWPKpFLgV
	RF3n7teR4xhPLu+lVFJDN+bEIMTPt/0=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c5075fa7ed0so615065566b.2
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:46:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794847564; cv=none;
        d=google.com; s=arc-20260327;
        b=BsLy/Zp61HA4cRYNh0AgbwXHSp5nU+0118gTXT0zx9CAP2F5BSTpog6rdKsISpC3AF
         kshw8SPK7GO6OverECULnpAPkVs+4DL8cwdU07aFe/Oklv8xL0mLEqvLogso2O7DfHFi
         /8wkVLeqqWY+R9qemil5mOS87Z7Uf5pCYKrNj1xuuTjteTW5a5cuHJKI+PjhrKPvCiVh
         EAXRc6tMor8oDM0ROwi04BjB/G3JOjHjXVL+R6kT61YZr6d+dDRQ/ONVuaxTIfSlQIXY
         oriR5GuONkM40GKM2JzsPR+QwiSMDGpCn6T6Ze20CCcBf92nNOLKsjbwaB+pOZ3bCqMf
         v7Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uRx112H2Vi/wC2nTJxgIojxoar70KiA3HIwHfFiZZ3M=;
        fh=vOIYwaxF6it0F7JZVp4GsU5JfqUj1DRslRZ9b5yjoPw=;
        b=GzCw528nZHOuNtmGeb8nVOYp0OadAr0xBF6KTxTmFtMWaFCEM4P07b7E0qHVhKZmDC
         5641dHtsE0wkNZ2rnWyBHmdNsIFLnSJvNchKFm/foEVJX9mT/rp7jqjinzJpsD6T4ddG
         v9pqRxGs2oSbRLNE1tEILQstDBfXm+xJqNznfaNiU3lxo/fSYSmpkPf/202vKE6J9Gtw
         hfTih3keGA9MrSPsrhjEBNE0jJmNRb1t6iwmUxAHpQDMufoUDCEtcqxrctZ6P2FnSxUI
         IJNMpUG/7+sxSeqjL4fMFiumt602LCrmvKacqeSUGj/8R6WqaJsyzxhtY7QW/jMQKzrq
         g0nA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794847564; x=1795452364; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uRx112H2Vi/wC2nTJxgIojxoar70KiA3HIwHfFiZZ3M=;
        b=kEfQiloEBSj011xTcVo3POUF0WhQ9Qp2aCu2+PVkgnefMKDUaQ/0PQF8Dxgauhwbp9
         5VMjm8m9gLkdrtXAv8FwDSr/YmDSInhzSTFkiEG/BelFxIm7Zoowj5nO391Us0tzmHK6
         sIeoMMRa9Vn827PyBOJX1hBauqquprxeaC76Lfs9D752ir4/j/kzJKM0IUJ2q9YjGojB
         ICm9JAwiPtH3oOVnC0FxhAWlnwbdUMkIXEVgAIZF65Gptjei7khEbQDucAi5qNpEtt3V
         yRNcPCxsSUzDqLexibCkj+Gb3ZHaiGjLoo8x3mDJPZubbMiDbQOqGZnJZoTSy7LQ6d+M
         RyIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794847564; x=1795452364;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uRx112H2Vi/wC2nTJxgIojxoar70KiA3HIwHfFiZZ3M=;
        b=QLSwGlPCdqaHa/juu0P7OxEAxmKWgcTASaNNGTxuHlgZpCGnLTNXSpSk2XAGM2v7Q2
         z77T8enHG+ErbFiajy5KdfeXK2ljkL2IoMeLy/VfWzXPNgoqAEsg8sVoxWgKmhjRe2Ck
         vPfmfHZpZdLGtT2ZEjQqW9RIhb75EmqsZU2KBDlVRCa3lHOZfIQ2fk5xf0lhmL335XGx
         wzvyfz6uOFGBEI5UmmG0HpJ3RDGuRulPBP1E1hs5g4B92dAilexN+YSH7F7s/f+vy5GY
         XKyuTdFgepZ3C9O0eQVTfOcLbENTYr2PGQN1O1w8mAxjB2L3SBkLqi3C6PXeJj2cjrHe
         6laA==
X-Forwarded-Encrypted: i=1; AL+hErE+ImoRlZ2a4vqNDGAaNvGQPrMUWziUJbhVT55PdmyF1eQzRgJNzmKQxwPsMicOFmyU3CiKwghPMA==@kvack.org
X-Gm-Message-State: APuU4Z/+B8Vu0aRol1E5chN5Y0WFpmkBw+duFzcbYD+bJ5PbfOgJEhNg
	RKj82VQOEf2Pbp7e2APE951jt6SMTY1oMTeNSO/iNbvhcs/nuYpgjzMkSxAxk7bEdRyBOteqzrM
	EF6vbGpbNUGG2XI67QqwkBx7IfCCxFuv30eo4TPr6
X-Gm-Gg: AYBFou1P021mQWrqURi/UFpQ8sMgtVWDxl8heN/X8GOhGYbVuLt4kLV5wG6p8iVk56l
	gEoxvDImDaqMRrgBz7mn0IfDztoxf0zO8bI6IAE8ARVX+bsKE9uWJiUmYCXGYn5FwiXQ49Ed4Vu
	+4vxIdYCGaAlrCjhgt2o79+09EAh5Cplb0Ni5iQ31EfWDE2098iB0JvCOYxDPHLqXgyHnALMdVw
	0fD+Crqai0HmtrYmitr2scfhQPyBan4sHn5MsSSKAtfudMqckN0Cb1jO9H62LYhTQiPDufRtker
	erD7DT7NloHd2OFCWVdBWdnrMz04F0aXOQhppn+EayK3ULnw7vKT1vOCnvJLSERp+4IDXbN3tIV
	rmEu9H+OTrpG5hxqMpCq5CKaBuxfiXS4WZz7ZbQ==
X-Received: by 2002:a17:906:c14e:b0:c34:83c0:b92b with SMTP id
 a640c23a62f3a-c509631747amr801733166b.23.1794847563720; Mon, 16 Nov 2026
 08:46:03 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261013162529.1928093-1-dmatlack@google.com> <autxCZPJ9yiE2ucq@google.com>
 <aut0H65XKAHUqPR9@google.com>
In-Reply-To: <aut0H65XKAHUqPR9@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 16 Nov 2026 08:45:36 -0800
X-Gm-Features: AclHuK91dkLFtARHO_doZgjfYRJFT_5pDlpQ_hxt-2ez4dAgAMEfCzexcKbTDgA
Message-ID: <CALzav=dp8HvdK=9cAkGfbsJAeckyU3_y7rCRM22R7+AmTTtxMQ@mail.gmail.com>
Subject: Re: [PATCH v10 00/13] PCI: liveupdate: PCI core support for Live Update
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D3B3840010
X-Rspam-User: 
X-Stat-Signature: kpjoac5row6zxc7woygkdmxai3prt1i9
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794847565-64471
X-HE-Meta: U2FsdGVkX1/PjgcnsXcZI6TutXFzBQG28NRSH2oQRWURV4d3d3Fl7OF7tAEnv14M3Cnq7rqPfAbPNogDjBmb8Pv05IupWdYhyXM5dU3YF40C5ktAO7cHeVZaqxKNZWP3Z8F0Qt1krT5oxoeGG+2JV7gCsFXNSfA6W+lp/RXEc9hl1SonVCuqwIn6v+pO8bENvV/owYXmYoTCXFCdVeT0ko0sEXhIe3hWcC96HCz+Qp7icsLLRRh7ZlMUGJjaSg15hsPNha+SquAPCQ/6A6mbO9t5hV97izG/eqILX2xcyGkEGVLMEDsMhA7VSE+RZC/STx3PmMnLNNHbhAdbX++AUa/UkWZd3Pdt4LHL6VVU4wDYquvlJ+DdbZjtEZbOB3lSXIV0Nsn76r27tERy4ImKPyX3IyQca3h9uzS1wpYEa3gGD5T5QKzEBE6LJyvKpL6TaPFlMhW3xtbnxsaSKhkkmuPHethDRi3JruALpAV+ble3iADicrVxg++UljkJQ1ynQbCagU7WnjR6ImiM8OMHXJWjgkGjwQKguDdB/RbaOQUSto7FnCOAB4L8Mih348fpoh/O2s0j/GjWfmNOGDpsJiwcwgDwryET6JcUL9OcF8zNEv0sIkdTNr0pmDJqV+N/XK+QgzAZd2/pWOwdwOwZoprL6uqPM/7Nmo+xe0vPlRL+YYtDhhMxVY6jwgf+T2IwkYIp/Ak5IoYKpNU3nGBnVpxbJRWhMOPF9hGIHoCQ5SkNQ3ATPXlUela6auZr+Lv3mn2+4PaSa7ShNKFctFt59tqUcVq26uGHtG/W03lvknXswqiWTCi/+cUlnpuX4pIE+MvismsIcQOGMqVPVd3MvcbymJ2BqYoArhUTlhzb5m0bKD4c/SAo1gP3KqH6ELcdUxA597q5whYcB+INVj5o7Ys0ZOx6bGbvJ/zRnf/ZRIe4WhiY2pJA+umNzbwmmyTpjIbxM8jT/OdNsOrskIJ
 c3fWR3cj
 ci4+t4KCfobFHQI+CiFRrSjIS1VBPAp8KU94q4N8PZJRMTq6E/foVx0xE3Gxgka1Gx7a2HKoFv8Np0tZ6218RGGX1THz5bN734hqElLOQb6edJnV08yWI/KKjpPWZ0yXBSIS88Aus/ND9pgMXcOa/inHi/Y5TIc11wWUshnX/m/QGCOFknQRUVLxIsAfQJAYKdT4A1FBzaRd/vgAAneYf33NGjEIqOLSnpp0bxgyRcVsx49ICDA7/NgjDolzRV7JdHM4XDQiz/AL4BvOmNut6EndSNNgFCRf/g80Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 4, 2026 at 10:06=E2=80=AFAM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2026-11-04 01:00 PM, Pasha Tatashin wrote:
> > On 10-13 16:25, David Matlack wrote:
> > > v10:
> > >  - Save and restore the ACS Egress Control Vector along with the ACS
> > >    Control register, sizing the save buffer from the HwInit Egress
> > >    Control Vector Size field (Alex) and drop Bjorn's R-b tag
> > >  - Make CONFIG_PCI_LIVEUPDATE depend on 64BIT from the first patch
> > >    rather than adding the dependency later in the series (Pratyush,
> > >    Mike)
> > >  - Reword kernel-doc comments to read better in the HTML docs and
> > >    spell out "reference count" (Mike)
> > >  - Replace the version number at the start of struct pci_ser with
> > >    required_flags and optional_flags, and record the size of struct
> > >    pci_dev_ser, so that the PCI FLB ABI can be extended (LPC BoF)
> >
> > Hi Bjorn,
> >
> > I am planning to target this series for the 7.5 merge window through th=
e
> > liveupdate tree, as we previously agreed. However, there are still 6
> > patches that lack an Acked-by from you. I believe you might have
> > reviewed some of them before, but the tags were lost during subsequent
> > refactoring. Could you please take another look at the following to mak=
e
> > sure everything is in order for us to merge the series:
> >
> > PCI: liveupdate: Set up FLB handler for the PCI core
> > PCI: liveupdate: Track incoming preserved PCI devices
> > PCI: liveupdate: Document driver binding responsibilities
> > PCI: liveupdate: Auto-preserve upstream bridges across Live Update
> > PCI: Save and restore the ACS Control register and Egress Control Vecto=
r
> > PCI: liveupdate: Adopt ACS controls in incoming preserved devices
>
> Thanks Pasha. One more for Bjorn's list:
>
>   [06/13] PCI: liveupdate: Preserve bus numbers during Live Update
>           https://lore.kernel.org/linux-pci/20261013162529.1928093-7-dmat=
lack@google.com/
>
> Bjorn's Reviewed-by on it was dropped in v9 when it changed materially
> (albeit based on his feedback).
>
> Alex, could you also take a look at the two ACS patches? 08 includes the
> Egress Control Vector save/restore you asked for in v9.
>
>   [08/13] PCI: Save and restore the ACS Control register and Egress Contr=
ol Vector
>           https://lore.kernel.org/linux-pci/20261013162529.1928093-9-dmat=
lack@google.com/
>   [09/13] PCI: liveupdate: Adopt ACS controls in incoming preserved devic=
es
>           https://lore.kernel.org/linux-pci/20261013162529.1928093-10-dma=
tlack@google.com/

Bjorn and Alex, these 2 patches still need your R-b or A-b tags, and
then this series will be all ready for 7.5.

