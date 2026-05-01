Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F157CD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 18:25:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5E4E6B008A; Fri,  1 May 2026 14:25:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D35B36B008C; Fri,  1 May 2026 14:25:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C24D16B0092; Fri,  1 May 2026 14:25:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2AE46B008A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:25:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53145C0A75
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:25:57 +0000 (UTC)
X-FDA: 84719679954.26.6498394
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf24.hostedemail.com (Postfix) with ESMTP id 49884180006
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:25:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=blUK+VQB;
	spf=pass (imf24.hostedemail.com: domain of dmatlack@google.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777659955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ynp4A/JaH22lvkihT3nPFtsXKnzutYHpfXYULBKQQKo=;
	b=qS9EcxAInu7DB01R0ghm2DYXqUoam7h5bXa2wcJKhNnxpMqtQCPksJtDnitbfZR0CBHkJY
	bwMIYNXF9x2y2uvd4p5Xt8p0P6oBuDMvIhco8HIg3/9q+drlNyR7zXz7UfPj0P5cZVEsuV
	evCdNgWisLeTWZYbrUMR+NOjJBis0BA=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=blUK+VQB;
	spf=pass (imf24.hostedemail.com: domain of dmatlack@google.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777659955; a=rsa-sha256;
	cv=pass;
	b=o5SVwbC7Nrm8Z8tQGeZ3Uq0h4EQu16pfkLTOR8a4vcdiu3qBxY79C5Ch+tW6Sg7ggLqMhD
	x6ZuwvTtqRA0OrCx5r57a9j47ZNWK1wvAtLd4E4QUJ53LLoz+ry1gPwFK3MIrrgMrDiGFK
	xkz9hWbqhNi20fFKExz7jCFMluZ6Kxc=
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-12c726ef332so3485906c88.1
        for <linux-mm@kvack.org>; Fri, 01 May 2026 11:25:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777659954; cv=none;
        d=google.com; s=arc-20240605;
        b=EYE0cU9jfeJqejvvpcMw9UKGKubY7ez3o2rMPLF0WlRD3VFd+7ThB6KIVBXsCyibqZ
         02zPjy+ElpcbIDJC2DoGRZ0uWnBDWIELpNzamMC6zwlA5kU1InK90Ae2U7m/xr8Wn3MZ
         +T7k7IavlNHd656xNPowVOmfrEjVZKEA09TokGn9TvR6z6Xn+bMbb6bmRoJS6/FC3SvS
         md2VVS9lugpqBy3ImWoX5JypDwFRsjzNBcn7/6Elsot3d5XTRGEPTeI0Q3phNV4RNOD7
         +80jxckPWZtS59U9SR8o++b29sRPWtaVYO3gXwwUBLOEwO4Bs745BfnOBi6BWM6C6cb7
         txdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ynp4A/JaH22lvkihT3nPFtsXKnzutYHpfXYULBKQQKo=;
        fh=nC7L5qoufhlsiYIDNEqr10tNFRRJgzT0fvYUjiT5Ci4=;
        b=Qji9D+ZpGKaezUsE/SjJH7r5x+tc05Ya25MBKVmNOEFPGtGNa5fPNxAYfE+6vnWTth
         8CHVj21g2u2WbiJn3WBOmctSOIlptQ/5g/DIR7pjA0MorefyNJYzZ/tL5x2Z4ZQiFraz
         bat6JwCaMdYp2HOA0w105W/GOrgiHLeGeQZ4GwX3AHr1cv5h1BYf2Q81qz7llSvad+MD
         g6vHvGjnw2d7Revkiz6NU77bGMMiCfQIqi4UPiVSgI99IUKaNnAojecEVUqhrHNmgrd3
         HsfxeMPneL2Ln4b71MYx1nRv1MUfgF+qqJ7MW1s60UnPWx9Q4oMmVpnL8RFRp+Q2mBw4
         xtcg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777659954; x=1778264754; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ynp4A/JaH22lvkihT3nPFtsXKnzutYHpfXYULBKQQKo=;
        b=blUK+VQBWxpiLeSaGHmrkMe6TNfe6Cz/V7k+CmntK30+Qn4OLf7I5ZIckBhkimgEiv
         yUPfhNfzc5iTzsGi1mKQG2coD6QY5LoqX/qFizA7e7YV6f6aoEAzJ2iNhVWImPTMlGdq
         KVb0ctKi5qfe/THVcwOLP3igpPVRkopNaqoGBlSsw6JKHlU+velKpqJ3i79SZDimditT
         Zfd8zj06/Mf3cD7MVz+tnEUHu+9RFR/ZOqwVEshFbKZFdhcmNJg/A4THvbmlLv3rNOPg
         1baya4bUj28oXWkOWICQTBwh8K4hHAerss1Vq3jLjqQ8gt8jqbOwhiaqMPMscHhlMJnE
         wBCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777659954; x=1778264754;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ynp4A/JaH22lvkihT3nPFtsXKnzutYHpfXYULBKQQKo=;
        b=Fp7W+BcbhgN0rvKrUimvYe66GfvUIhcHToItTfHTKo/MT7cjRq+59VmV1IduDAtJaz
         4Usfq9xsXzYfG+hEWXGP7NdFFWY9vGYJcKPjtXf2Bb4v8KpECbTRZBAiHgVa//w3t+JF
         eCQ9vHJFUhi6XIFeBzjAhzMToaoM/hVni9RqnnC30vK2IHl59VAHqKvDPoWF2XPFniIk
         6Ga2G+tUXy4y4ULRPesSXkxNeAgnm9R6B9l2UGCP46fWUfNcTqIw3yKqJOn8gknxFob4
         1Bx8P2YvCc0n6RyDzLEQ69UvTuHsvV4+p95GDg0bFd2aLFBpLYoJEL10rjx1E8BJ4n/O
         eg2A==
X-Forwarded-Encrypted: i=1; AFNElJ+vsRTsF8GX/B9rNmqwAI+yt5FDnt6XpDrO7D+v+VcXGmpScROnEaxCT6QXJw+dNuApZBEmptMHEw==@kvack.org
X-Gm-Message-State: AOJu0YzRhhSpKCY1p0YGV24d2b9MUXbEo4yWELWhpzq/dkNWahztjrNM
	tvFSfZFRGbD4Gnp/+fJSbbSzuuab4abjPvVfYgFuLw12xfcbrsdm/UhsvZZ9XQ6mSkQAR/jPWrP
	9N59xSXEeNbBPFvZD9v9lSB3+WAZvSwI1fBV6xRUG
X-Gm-Gg: AeBDieunEAbKud8KovmVvCv0A9ZyQDNBGU6W8pIN4sEHlKBbDVGqQ4izTwZrMflxCWY
	rApFVozMofwQ+WnFp/poiAC5+EOLKVkqrLTZylatVo5LpQYLngiiUTbukPzywD0b/20zhZe/P5a
	OphiUXs+l8jijMSH5EnzrOE6VsAu6HV0IwfIhrCGAiKtzSYehIpNCFidUkECptJteRYfbMLiZl/
	P51b1nXMDqhGqj+G1nevakaVVUMvj35m3FJtcoGaZ0ZpMvcRRtmsYXp7HdxBj4dMu5S64U1IuJP
	6ApdFI+C/JuCrdRez1+jTxvCKELsqg==
X-Received: by 2002:a05:7022:ebcc:b0:12b:ec15:69d3 with SMTP id
 a92af1059eb24-12dfd7d88femr150449c88.19.1777659953185; Fri, 01 May 2026
 11:25:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260423212316.3431746-1-dmatlack@google.com> <20260423212316.3431746-3-dmatlack@google.com>
 <afDqs6oqWlhoVqMN@google.com> <afPGYp145FbrvURR@google.com> <afTgOXpUNWMapPAS@google.com>
In-Reply-To: <afTgOXpUNWMapPAS@google.com>
From: David Matlack <dmatlack@google.com>
Date: Fri, 1 May 2026 11:25:26 -0700
X-Gm-Features: AVHnY4LHOeLRxPaffc9oaSUdxPiYe323BsN3VXy59mO0tVvOtZ5BkXLT2WRxf9Q
Message-ID: <CALzav=cJLA3-gK=Ljfqf=YCPML60F=hM_teB67M_3PNCZE4T9w@mail.gmail.com>
Subject: Re: [PATCH v4 02/11] PCI: liveupdate: Track outgoing preserved PCI devices
To: Samiullah Khawaja <skhawaja@google.com>
Cc: iommu@lists.linux.dev, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Will Deacon <will@kernel.org>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 49884180006
X-Rspamd-Server: rspam06
X-Stat-Signature: 5hz647y49ndennujibmobs4jceokkjx8
X-HE-Tag: 1777659955-159381
X-HE-Meta: U2FsdGVkX1+Pb+HbRrbUemYoghJYA6eTvx3PlN78zUA0jwkS//DZlJikGe5ZUwmblZ3tvs0CubjzFminXMzGu7zErMwCl0U1eeUXtNP22P/tK4HJQ/HVumrzCifLUS2t6J9fwqxElRiJNm7fHzEaUKyuwVyg2RNqYvXwjv21CaffhS73NPEtf/zjx1VucwMjeWOHPiRGiZi5FAAj89QCXP4bKDl/C3UB/VANjeMdhQc5Di9b/piGU51aX1fB1WFXvbb2FY9e1YvIXbDJxSgGtznZ1qBOAsjx6+QfDrC1LyliguKroxE8buruZuS0MODeek6SrvN5ouKO+7XwhJwUm1BNMRGIq+tY88mmQdfhQMmwJnlt9keC/1l5/uUZijhxTk4gGKsWfyWS/rKCy/wWXlqhjYYjzwH8aiAFpAgfUFnF1ORBLj40jZpidiYVmdJVyYxrSqgvBRXQqq5kSkIB6Hcgea0wsjlYZ+89zu8NjRkJGptKgM1yDU/heyFfisHYRXVnlYWsqFXDVtympxEFWB0vQggDjrzQBFNA0Fv3kAhUqpFnPCD4h/mUVG5jDTWhzc+3nkAoRKsTf8+1zx24sTGAr2WGZZCGFCN/AbhZ0BPVFfOd2lpcO/dgKHAmgQJgdsDoj0MHH/jLs1AehbegNcvEr5YfTfQldG/OZfUDMdNQfGPInYGFUoZa8phjTo1SX4kTidzE0yGKwXYtWJiTdyQHFsk0TdT0GZtKSQU/Ilpf67WT5evW//hAJTyMQcPRTvcYOKO7M7OE7tCryo96yD0YVyRAbWdIi9DearvQZtEkuvvaLi3Mu4rSgmeLC/NtI4yQE1yXRVt/uhUWcHQwwJIIaDGyra9fm06F+ncKywwmQvhZUNaBMs0UAwtEBEIa1GPsnGqruUPaSpNNiI0LVMbR21rFq3jedIqFn6UWGaZuocSy4Br/UOUprRKwfBch0542J8UEiyWDW+eZPY9
 96uxCYtQ
 k71ll4klED/+hjtGeDHYyjH/nRQf2OA1zzfQo7cOtnhemZHRYTn/si9BRnXYWqE5OJruyUWTMBMsn/60of7pIy7GJxMeVk3j6kqtcFDpIAQ3ATEKy5N+bjvfciRme9BdVwMsSAaDePLyv8Lnz6RqXMw13Rim4fwb/nhBs5mWCXes2dN9OMYQouExycUZ+4PgajRdq2pm/ozV0JQBiGniCSfH3cknXrXQp411KokIhzqaV0Gx2httTmodhgGhwo3dYJYbM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 1, 2026 at 11:17=E2=80=AFAM Samiullah Khawaja <skhawaja@google.=
com> wrote:
>
> On Thu, Apr 30, 2026 at 09:15:14PM +0000, David Matlack wrote:
> >On 2026-04-28 05:24 PM, Samiullah Khawaja wrote:
> >> On Thu, Apr 23, 2026 at 09:23:06PM +0000, David Matlack wrote:
> >
> >> > +  for (i =3D 0; i < ser->max_nr_devices; i++) {
> >> > +          /*
> >> > +           * Start searching at index ser->nr_devices. This should =
result
> >> > +           * in a constant time search under expected conditions (d=
evices
> >> > +           * are not getting unpreserved).
> >> > +           */
> >> > +          int index =3D (ser->nr_devices + i) % ser->max_nr_devices=
;
> >> > +          struct pci_dev_ser *dev_ser =3D &ser->devices[index];
> >>
> >> nit: Maybe we can move this logic in a separate function as down the r=
oad
> >> when we expand this to add VFs and Hotpluggable devices, this might
> >> change significantly? It's good if it is self-contained.
> >
> >Did you mean to leave this comment on pci_flb_preserve() where it
> >decides how many devices to allocate room for?
>
> I was talking about this one, as I think depending on the scheme we take
> this might change significantly. Just a nit, you can ignore it.

It would depend on if userspace is doing a lot of unpreserving as
well... I'll see what I can do in v5.

> >
> >> > +static inline struct pci_dev_ser *pci_liveupdate_outgoing(struct pc=
i_dev *dev)
> >> > +{
> >> > +  return dev->liveupdate_outgoing;
> >> > +}
> >>
> >> Is this expected to be called under the outgoing lock?
> >
> >For now this API is only used during shutdown, at which point userspace
> >should have already been stopped so drivers should not be changing the
> >preservation status of an outgoing device. So I don't think this needs
> >to be under the outgoing lock, but it would be nice to have some more
> >explicit synchronization.
>
> Ok that makes sense. I have similar cases in my series, but maybe we can
> add kdoc regarding these stating in which context this is expected to be
> used?

Yes will do. I'll add some documentation and also restrict it to avoid
misuse (move to internal pci.h, return a bool instead of pointer, and
use READ_ONCE()).

