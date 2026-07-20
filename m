Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5A86C44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 22:44:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9B156B0093; Mon, 20 Jul 2026 18:44:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C592A6B0095; Mon, 20 Jul 2026 18:44:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B671E6B0096; Mon, 20 Jul 2026 18:44:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 82E176B0093
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:44:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0A51212031D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:44:37 +0000 (UTC)
X-FDA: 85010635794.29.CB95BDD
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 24168180003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:44:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="gz/hD4Xb";
	spf=pass (imf06.hostedemail.com: domain of sagis@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=sagis@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784587475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GHR4CbJ8loVD9XIgadhowB6w5bW/rYJvdw1lbbqKWNI=;
	b=4ZkSR1lwkPDY2y0wFNq8i6aQ6xK3j2AJfia9/m5EL32TrGt5/HBVbDZTkWBihg0OgnmARh
	BuMfnfq4qTTut8BafuMNWM3fxtDGfdJ4gzl3J/1FomgYhpNQcjj4w/lpgtdl+1IHM9Jyho
	IGiwO1hb4dVJmq8D2rTUBUmpWF6O1f4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784587475;
	b=I00YmVnneCuP+BJX0GHrHSyrHI+WVXfWmDgagtulS5E1C6uwfCb1UKfXdmKTUOZQRaYk5W
	efrl5gPiFbndEc9fiB3bqy24sSJcuolEXZrN09OTctiWlUNElXfAkkN6NLBMC+UFGhS92Y
	Z0xw0sZxvbsQCFjcakGPrfuN9SGGCJU=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="gz/hD4Xb";
	spf=pass (imf06.hostedemail.com: domain of sagis@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=sagis@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c10ed63c0so1053821cf.1
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:44:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784587474; cv=none;
        d=google.com; s=arc-20260327;
        b=IhFc08ll3H8x4VvLPEQrXgidFB+Wm9rFG7+L8mAV1YCUqTiPfzdgg+XY6KsD0rJkLM
         2AJB8zuOKMCFdbm3X5hySUCX18Ukwf77io4FcdQwW3fmaWIcHa7FQu7qpEDYzFHu8X2J
         T5noivsGTgFBEFtw4KoXLM5UmE8kvpFkwociuEFP+juZPbmKt8kJwZ+bh5Sb4U5d4bS4
         QtCzQjEIxyiV5dKo9L9uyhZ26JLM8tCZqHeR9JddjrjtMoWQA3Vywy2ejYVK2clE3L7e
         kDYxTVcqCxW6MLgObyvTQSdclgCYSiQcIBhkgj71aHzyP/WGd40w9OFztfFPWQHGNd3W
         u/4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GHR4CbJ8loVD9XIgadhowB6w5bW/rYJvdw1lbbqKWNI=;
        fh=A1OPsMpTf5PNX0BmoNWthwePBXrxGUC1+iS2ZvXNwrM=;
        b=UA84O3P59/0/4WZQwvJ1Ix4oNqvwWoB0eloQ5kPPro67CYULvOrJT3wCFEa8Z22MY1
         a+zEuW7faeHyiut85UxN/i4tl8lynbFHQXBwQmuTawNukvsv8+7T2sqnRXpNgzVnH9OF
         rFR8sLyVdbdLGqnJwPiXROzf8qsn6CMLVceTw3bHs5zg5f3y14bCOQmkboRLiMiYxF0j
         kFbd2kTVYkgeltMwUnV1/9mVwSQqO5uN+zh5evMKkUwPS0r33C6h1S8lnkg+ijgpBYKd
         H1wZahmN0vbSzjbnQ2xOVhw5ts7a3XRcTQ3jnJV4MU+qPJJin/lSF5m3Eo/6xY46bd3D
         h+oQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784587474; x=1785192274; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GHR4CbJ8loVD9XIgadhowB6w5bW/rYJvdw1lbbqKWNI=;
        b=gz/hD4XbhOybSmvd203r8ep5cftw14tt+CgyImzPU0h1TwbSfHeXa3X0GEwFa0BP3Q
         AzRG1HMGqMkKkOo3xoMaAypm4lotW8vXhMFyBGG3LpviIHZszyIoUb7he49dTnboisbx
         gIRNcfjP5YIvCy+eVDM9GJW21Tjk4dOUVeg13Fs2iibQb1lzFyO8Q217psPFuB5wVAfM
         bSc2idjJ0ggfH9CXW2oNNZG0xEpuV1koUQBx9sB/d77dK3ZurFbtIAqycct1JllY8d6B
         5uOOLMpIj3Bn0E22EIozgFGA4NKddVvnbfETxsSC4w/bIH4kHBPAP8GmE0TDJNyFCo2s
         fJ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784587474; x=1785192274;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GHR4CbJ8loVD9XIgadhowB6w5bW/rYJvdw1lbbqKWNI=;
        b=N03BQOMCIitc5du7+MkoOaD3Zl597S4Or+pNhY/BroEhnncXDvBOsrBxY1zW4qGeXs
         tc0kSa2sEwclASdMWGONS8TS8d25iJmGUf7mcG0HIdm9dntBt+wi4qCbqDR+LPcPOFIx
         Ggiv2dD8mCVlwYPRjKxg/MMHdxS7xaRORvHTQpYvp3hh+R34IKu4YQCgTFZ940Xqa1t2
         GIlSXjk74xGCcRjIVbvJID1anUgi6QsgLCrWRhc1AuDFvWOoy2ohsFIApYa5iMxEIHEh
         uIysilpxS5b4D8zjtAELuv55yY3WzmFLbCCAMfNkBArZZoTwf8+I34nwiQvdhJjx2H+y
         OfTA==
X-Forwarded-Encrypted: i=1; AHgh+RpMuavzikzfrhzTGhVlnZdcgUTHWPv68I5k2/H+V6RvA82iGojcM7geqgE8THLcZ2XycDF7967bGQ==@kvack.org
X-Gm-Message-State: AOJu0YwT8Rj368qJxWGo6nBl/Ne4F2aN5ZT7yH8vN3dtXNqxaTcdYQGc
	8vrOl1VT73vTu5kiFgitNKXN0yqBcTtLYMP8ASOtjKNKlHulApVOnZaEC1zv8ikr6tHahgF7lGS
	vsxbz3WE4GIcV5YmRlCdjbpmoHhYlVcdYyhNntptH
X-Gm-Gg: AfdE7cneRh+8X4E4YkJogmk4FFjQrskP9m18Th29Yj5dY0YxdTjFoc/gr2483LFe/Y7
	eVB0pOg5fjzDMlxm9rzteWOBLT6DwJKBOG5hEC1whNKNl6BTbPX0++jNQbUA6+qVr/hbLrnFvfO
	4MgXAia/9Mw/K5rKObroFIviLR0L3i33Xsa4iFrnXcHJE13HV+GhmBodi7PA/Sk1XRE1AbYA6Kc
	IQaKhjpqQHAOwHO2kpHCeOc6SR/C59btpEXM2AZbHZGNo4LB4d0+CZuLhqezobHmd3wQPwLUu8V
	xg+klaQMkaRJAilE+K4=
X-Received: by 2002:a05:622a:134c:b0:510:f9b:fb5f with SMTP id
 d75a77b69052e-52601ff8d4amr6884401cf.16.1784587473744; Mon, 20 Jul 2026
 15:44:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAAhR5DGpL6_ViMwQ0nKzTgOoziE_oq8JofpO-VtHBXK37uO-FA@mail.gmail.com>
 <aljw6vDaeEdhzZdy@google.com>
In-Reply-To: <aljw6vDaeEdhzZdy@google.com>
From: Sagi Shahar <sagis@google.com>
Date: Mon, 20 Jul 2026 17:44:22 -0500
X-Gm-Features: AUfX_myYvC4BfYam-0hvA_2hmsHjyNwwCFWWIdoxNvvrsMfeD0EQ_AZrXlkgCvo
Message-ID: <CAAhR5DHNdoB7+8beLHHFOT90UrHWF3FTwMs44AwQH+-R+u=w6g@mail.gmail.com>
Subject: Re: Preserving TDX module during kexec with live update
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Graf <graf@amazon.com>, "Andersen, Tycho" <Tycho.Andersen@amd.com>, 
	Anthony Yznaga <anthony.yznaga@oracle.com>, Baolu Lu <baolu.lu@linux.intel.com>, 
	David Hildenbrand <david@kernel.org>, David Matlack <dmatlack@google.com>, 
	"Heyne, Maximillian" <mheyne@amazon.de>, James Gowans <jgowans@amazon.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Mike Rapoport <rppt@kernel.org>, Pankaj Gupta <pankaj.gupta.linux@gmail.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Praveen Kumar <kpraveen.lkml@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vishal Annapurve <vannapurve@google.com>, 
	"Woodhouse, David" <dwmw@amazon.co.uk>, Luca Boccassi <luca.boccassi@gmail.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Jork Loeser <jloeser@linux.microsoft.com>, 
	Chenghao Duan <duanchenghao@kylinos.cn>, Zhu Yanjun <yanjun.zhu@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>, linux-mm@kvack.org, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 24168180003
X-Stat-Signature: w6u1xocr8k81efgcf5f4q1goud7m47s7
X-HE-Tag: 1784587474-692729
X-HE-Meta: U2FsdGVkX1+MxAwAQuGk815Sw5cFpurgdpyUQfLFhjikOAdJNxM67bfc9Nh+KkU4+Xw/X0Vekcb1eOlyZ69PT2fwsgSiLBFReJCBTpB9OQhl+OUqgmM3h6uEnHqtV4URddhUQpfyjgE6KJRGvi890/U7kEPxFevafkfrllF47WXsCyZt97uPP5pU/gZ2f6vXREctuRPkOjjdpCsgOCjThFqhA14DTsfYzO4tXFPzfvFuY+gzl9tQD6kuDUIgkE1iq2XbxJl09Q8AWTmEuE+pErXKD/dXNV9EiJhRCOfKPjWCx8K7DdMNi+QUZ5xYinf96GfpjY06hJlDJ8pgV7fjtWWwmaS1nTtyU8eSj2h69OjPr60zgFkUuqywEJlUQD0C+T/dLADzlIE5prXkR3jXSEhnl3KWqhXYbBla++jogIkSbbpNFR1tnqMmkrJ89VvyatZJWCV04JHmA23uysDSoHHDdW/L4L3+MBdPlwgW9F+4V5Vtn3qEi4T86b4GLMvhNG3orH8/fLZCfSz6pLbsAL7LHc0BorZBMMKxjoxKh9IFPVCxMWchDlY711u7opmj/arSZUK3T0G/CZmiXswe8gXZbIRYn8HownIkiEWsrStZJ4iUboenLWCky+hImlhdVcE+kDHwsDfWpDqLkGm5cVj9TJY4/TlUovSqQcrAWxqG8A3qSxUrUgwBFPVQ/OGkD1KV5qYXy/hFI6GiY2nKynueiL88oDGdKYEfj00L8tL35XUt9G1Yb9liRWdmY5phQgjjpsaxa0/zogfy8ZeVQy5Fegfo1KYzyMf85+sJbp057EdfeMb2S9NnP+MgdFSqtwiMnS7kiZQrYe8r7jCCr3y+ltRTUuGtjvuZduVt8dgu2LRXEDRLS+o455QNBAtmr8GIuQdX6meiCIDC9HnWQscaOcLp4BmbBzNUSlzb35jZfrn5IiYLkkoU5azYjviWYtTonT+ppxNBbyn+Q3s
 8vTsOWMl
 9FFhVKHetiQc51mlPrIvn1DPy6b2fhj26Te3jH2BeHMN+btpmbJKGcGuoMWkuLHwluiQKKVfLEcDs5o1HhgFrJu7RglUpmKS3EO3BsYPLLd0+OMcn+yT9TXUeNyqfdWWXwFHpOG2cQXssanBydd0hCDUXFryGViwBIpFuJK+erFDdK+vphww7TiAx64v45Ow5qCnlk85GIC8mDsRKApOeAVu8OTC4Radpster9mtHvlW8FNLMKI6p2VUqmd365OzrNVcPwndm2SdvVzPbrysqEWp3fd7GUUe3RrHrEubIQW0riEe+TAukdJ6woqwfvPyQmojynXHlV6R/9uqkI9zrHGBYrF9G79wWmv620bHDqLyxW5s6B9lQaKQKYz/GEC4VdKpfXtNY8eKRz2xfEkUNYF6+LKNdouHJjKTg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 9:55=E2=80=AFAM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> On 07-15 18:28, Sagi Shahar wrote:
> > Hi,
> >
> > I started looking into preserving the TDX module across live updates
> > and I'm not sure what the best approach is. I tried looking into using
> > flb as David M suggested but I don't think this approach works for the
> > TDX module.
> >
> > Right now the way that TDX supports kexec is by disabling the TDX
> > module on kexec and then reinitilizing it on the next boot [1]. This
> > approach clears the TDX module state so any TDX VM from the source
> > kernel won't be able to resume running on the destination kernel.
> >
> > In order to support live update while keeping the VMs alive we need to
> > skip the TDH_SYS_DISABLE call and instead preserve pages used by the
> > TDX module such as the TDMR pages from the source kernel.
>
> Agreed.
>
> >
> > From what I understand, using flb will tie the TDX module save/restore
> > to the lifecycle of the VMs depending on it. This means the module
> > will be restored too late during kernel boot, after the VMs are
> > restored using the live update IOCTLs.
>
> That is not correct. FLBs specifically can be restored very early in
> boot. We do that for HugeTLB preservation, for example.
>
> liveupdate_flb_get_incoming() does not require userspace to resume or
> restore VMs. You can call it super early in boot to see if there is FLB
> data present and, if so, change the way the module is initialized during
> boot.
>
Thanks Pasha, I also got a few pointers from Samiullah and think I
should be able to make it work. I'm going to be on vacation for the
next couple of weeks so I'm going to miss the next meeting but
hopefully I can start working on it once I'm back.
> >
> > I'm thinking we should preserve the TDX module during the shutdown
> > stage of the source kernel. Perhaps we can preserve the pages used by
> > the TDX module as we allocate them on the source kernel and pass
> > pointers and additional metadata during KHO. Then on the destination
> > we need to pipe this information to where the TDX module gets
> > initialized during the KVM module initialization.
>
> Please don't invent another state machine; instead, use the existing
> one.
>
> Pasha
>
> >
> > I haven't found a device that acts in a similar way so I'm not sure
> > how complicated this will be or if there's a better approach.
> >
> > I would love to hear your thoughts and if you have any pointers on
> > where this code can be implemented.
> >
> > Thanks,
> > Sagi
> >
> > [1] https://lore.kernel.org/all/20260323-fuller_tdx_kexec_support-v2-0-=
87a36409e051@intel.com/

