Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27321EB362A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 18:15:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45AC06B0005; Mon,  2 Mar 2026 13:15:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 432F86B0088; Mon,  2 Mar 2026 13:15:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 315256B0089; Mon,  2 Mar 2026 13:15:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 206786B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 13:15:01 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C7636B7B27
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 18:15:00 +0000 (UTC)
X-FDA: 84501924360.22.10D5BB9
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	by imf07.hostedemail.com (Postfix) with ESMTP id DDAD94000A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 18:14:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DjAmpELc;
	spf=pass (imf07.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772475299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rZw46QiejIxPJc1G5DNZGnj4KsLWM6jIVrYLGkqOkHQ=;
	b=ERTieRPlioEy3y8Row2+w0E02AM8SayZXoGeUU1x099dVrMzuTN6ddsFp1as17q9IbhO7d
	Had7YIHg03kQcXxTFhXrTOQqF6NOb07hz8OMNkRBI7YEhI/CussjGvw/InEu58qOj1Moof
	wdnxWasjNEjQMCOeagAaYhX4rR1v0G0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772475299; a=rsa-sha256;
	cv=pass;
	b=fdYZVQ2GBwfY1UkDaPJFH1qpZUMTdJZoLzc+HYveoGRrUSMBWVjWKrwGfgtWMiikqm43er
	5dtrWkKtrDO3y7d07m/v8TY5x/kz5FUo7ImAqyTr8wtZ0Si+uGrEpVptHz1P/aKLOSqTjT
	LsxXNdJf8fWEVVD/rbVTAfYjMz4p2jY=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DjAmpELc;
	spf=pass (imf07.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-3870df2331aso12937171fa.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 10:14:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772475297; cv=none;
        d=google.com; s=arc-20240605;
        b=bBHM3n9TV2xo/F8Ly+XiIlHlchUJnvYQIDHblBEXol7BRmgYTu4O8hQInphdNVRIGh
         tonFst12waCcMjXkiu0swEiL+f7Uclx8CGnVGDgEiuk8aSClEauAAjTKTYgw0vmyK/l5
         DbvhHWLx1+o6GAWJ9MUYIzjkxUrKob5NP2ebplNMy94TO6xtRZUNpMbjfbHHUWHiFLps
         zd5OxVZQtrLLlZ5jhhgCePe3uROPlbszGfFoSRmi1hhK+/ZLIPxwkjESe8tdfwf2PE1B
         /jl7+z+uIfmOjSgnTFWJ5FfyLoQuJCEe3g+SLZ9ZbWMEEt3qtpIUbcqVhtKvvqI589yf
         R7zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rZw46QiejIxPJc1G5DNZGnj4KsLWM6jIVrYLGkqOkHQ=;
        fh=rHIgVF9bwm8/09FoH8KEMIA6N7PJd2jGjpAli2Hn6p4=;
        b=PoSRRFhVxYQ514IcN6IwKcJNeVVj43dgMuOdYe76yA0g6+sFSOHh4zMQ9OL/S4pTkD
         PFY1SWeDBAYFmlpjLqGEInLL5b8D9KnufbgjfPH199GY14eqkT5c2mLPEowoDzBnyxdG
         XhQeR7CTKK7Ms9ML8hzOe+BJRGFrFjCZJX+11Z3cx0YdOafFjFzulytH31WmoQ8dU1ol
         bIOM7HkmHjJKaVQUxFACF9aY7LLWhJCU6Bo94Aiu/YHJ64Hhi62WbCCN9t1I82raFKvn
         M18juHi8fkRXGGOcHI9GGAyy0YaAace4m/bVsSX6B4G7bFj0PTyKEPu2go+blAVhpSdF
         gBPQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772475297; x=1773080097; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rZw46QiejIxPJc1G5DNZGnj4KsLWM6jIVrYLGkqOkHQ=;
        b=DjAmpELcSly1SG0x4OaQ30zIx7hQvKU/XydKZDK/hc67/zfR/J9h+HdmzIc6/qgo3S
         X8Q7h+fr2CLdbFTbYOFyfzHLk3k7CHS+jy2CjycXXAe3plxywTL6Xh8627xJLr71DrxQ
         zZTtCSF0NRrvbARoYT4GaxLW618zUOnsxvND6sS9tw3nKShMSN8y6ONecwtEaMSICLwW
         VQy90AKEF35o2ZkRTS2W1tWgaUyskGftMWSLg3WzOEsPsCl8TpW3XV+uOoGomTpPtqVD
         kyrs+EOUAQgghvx2LEVONRqJ9BEWgHRnzQN1GlnRbvkai7wRl92oNhttDmB0qFlPuJcf
         9hlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772475297; x=1773080097;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rZw46QiejIxPJc1G5DNZGnj4KsLWM6jIVrYLGkqOkHQ=;
        b=AqW+tvn0+6FvRF1ac0W3OptKqEqeRSzYe4jaRhSP6zr30Ig+90hO6QTJTofMUBgJdM
         CnCkPf1QjJqHxjTCP/+bsVvS1RV2hdf7mSrSpLp0unIF6cBmU7C4Fm8ZjnfVMG2LwwSh
         viMjqTiz+so7483G0qRx3ZOntjB1uFWVtu9T8S0F+TqwHeMFtXdxB/B2cft48qKzI5E5
         psg/CmEONWhyCSwwlEkQqpW+DOG4QrQ+JwEzOiCfJKo7+UN09WSPg3CpOidGXfjj5IfJ
         6hcP/XBAGdi00xwtQYGoVkJ4szCspSQ+X/9xqRpK80e1NWZOJVHNerMvHwwF780pvfds
         Reig==
X-Forwarded-Encrypted: i=1; AJvYcCXsIBNtMEKFlZCFpoRd0YL6YvoGSawy/0NjyfEZkOuf1BWYtWd0GpEzvU1/n6lF7Ea/zMo8QIMRrQ==@kvack.org
X-Gm-Message-State: AOJu0YzOc5GyCwYQNz2VNZSQPI+RELnQnuL1SZrrdxquiGDZMk0Nd8DI
	/2eZlwgGiAM2kN2WsbkjQ3aw5HMnajaS+6pPP+qFEJr0zgNnf5949wiJY81hn58THwjMT3Zqwit
	NwYefHIw1O4c0E6ZyR3fBUJkpzgdC8YQD9hlNqJtG
X-Gm-Gg: ATEYQzzx664jJwEjB3uehTbUnEbqi5YMT7k2J/nTZVXnHBfKPBuYuSvsULDbkWAQ4+Q
	EV5pqUCccV3ktDROO8WEvze36jqC/uZc8Xl2ZraYOvS/HatcbfWJspnaceqwc2S+CmZVjPp/+Ew
	uad5l/vQLypoYNfZU7ScmlBeuWk2cOtkYc8oShYkI7QSrg1lcVa7kXk7Y0oKAm81P2jrVeiNUCv
	Ug8AFJZIR8CLzb0dKicMJUQEs8hzuPF4DIStT2qCIw0Apm9lyb/7hH4hzQcn4xxQILuZfUpYEXD
	7txRwrU=
X-Received: by 2002:a2e:8094:0:b0:389:ed12:9731 with SMTP id
 38308e7fff4ca-389f1e29849mr81213251fa.16.1772475296490; Mon, 02 Mar 2026
 10:14:56 -0800 (PST)
MIME-Version: 1.0
References: <20260129212510.967611-4-dmatlack@google.com> <20260225224746.GA3714478@bhelgaas>
 <aZ-Dqi782aafiE_-@google.com> <20260226144057.GA5933@nvidia.com>
 <20260227090449.2a23d06d@shazbot.org> <20260301192236.GQ5933@nvidia.com>
In-Reply-To: <20260301192236.GQ5933@nvidia.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 2 Mar 2026 10:14:29 -0800
X-Gm-Features: AaiRm53G4DyTBgh8HthgkNXd7A4lLjemXkfCrH3k_RfrPJCtk91UZa8WxDGHRMs
Message-ID: <CALzav=eJ63gitLatAerrjEc+o3VXcRor3XwA7_o2PmKYnMwCuA@mail.gmail.com>
Subject: Re: [PATCH v2 03/22] PCI: Inherit bus numbers from previous kernel
 during Live Update
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <helgaas@kernel.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, 
	Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, 
	kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
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
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DDAD94000A
X-Stat-Signature: upe8zfqru7qa3jhhzez79uhygsdhxpng
X-HE-Tag: 1772475298-251622
X-HE-Meta: U2FsdGVkX19cH8FOqA2biXEKLaCuqONiKxb8n6cIpLQUINv5WlTYYZ5PqcI/1/i/kdEL4EmueFU8MMT6RiQ78F73aALhfWg1Qw431JXREj/fCJ1Uh1sQI4iY6RM5MabOZoFBtyr6+ukjfYD9kJ6jYVM3EKXJ2h46DF2yrfZ+Vdf4xM/KevqqziDdPil+zf8zs0VUvFl+rzZmZrbYQSDqi75qfhJCJ3hHa61ZQsq1551YD83D3ivd2DB2+6LcF3cXf7pv/vAq0YrKiB4HXW7dBDOpvpw6PbCh7rvV99KebfaUuvM1gi4vP0pnyFwVrSERLpX7qROcNSvhMtQxH/9i4ux5KlRPq5qR2+WwYtxh5v2dYtTmSbwTfUYRSh+sqiwiKM1YE4GjkIrkrbqnUFah0iU30sxbVlQqy3N106SjPETurk7RIrvQc4D6RDHvNFvpl4/RqzwXvx8DqdXLd3sTBsPgNQZskksgQ+ZgTQYMNMEOhju76rZwQXKykmM7hGs9HInQoP4N6YsQbuqmN0J85MioOT4hgcyjb8f1TskovD1q7954c4mq09KGDCTvdgojGOqyD1t0VWPTFg+Lm7GwvNILZAVMlIUoQiYhAnk+xoB9kKO2XQrEi+u0ILFUak+2QsOg8jaOuiycomxpbArYmwM2aoACl1rOtG/dNiWuIzegG31s5d+ZEzOWSzXDO/r7uhRjUU2pq0Ed7eHtncH7RMakVTKEFflceReg1/EFHtG/gjKZTqPALXMGLibWLpDCJn5hXMFyLGx8XPn9N0FYTikRaDI7BrGTYWXqYlEIkNayaySBXYpv5ZizAdI/vzRXepqcBI+dVK1VMmO2czRqC9pQOPccJE1mM0MqqzQCJClbyU/98lcwdnPSfAtFgFgWjXb873cRishHQs6UEF/PYg4wu4MQfOxqsiuaXzan/8tTP3QBnm7lIRGZHymMHpMXoTQ89Bf84Ek=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 1, 2026 at 11:22=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Fri, Feb 27, 2026 at 09:04:49AM -0700, Alex Williamson wrote:
>
> > Not only fabric topology, but also routing.
>
> Yes
>
> > ACS overrides on the
> > command line would need to be enforced between the original and kexec
> > kernel such that IOMMU groups are deterministic.  Thanks,
>
> That's a good point, I think as a reasonable starting point we should
> require live update preserved devices to have singleton iommu_groups
> on both sides. That is easy to check and enforce, and it doesn't
> matter how the administrator makes that happen.

I can add that in the next version.

> You also can't change the ACS flags while traffic is flowing because
> that changes the fabric routing too. This should take care to enforce
> that restriction as well.

I'll look into this but will probably defer it to a future series. We
need several more pieces in place until we are ready to support
traffic to/from preserved devices during the Live Update.

