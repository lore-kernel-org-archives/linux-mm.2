Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39236CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 16:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60FA96B0137; Wed, 27 May 2026 12:20:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E73F6B0138; Wed, 27 May 2026 12:20:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D5B86B0139; Wed, 27 May 2026 12:20:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F8266B0137
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:20:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EBB491A069E
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:20:58 +0000 (UTC)
X-FDA: 84813713796.10.7EA6021
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf20.hostedemail.com (Postfix) with ESMTP id DDBD61C0008
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:20:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pl2zC1ru;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of jannh@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779898857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BRiRpdixJFrcmqSfsDGBuoh5lIec3C8LN8yr92Ku6F8=;
	b=5hTEzOT7xlBv/NSfzPMOuZgtgg44zhFdK0oSKDDyEqevt8MprmX6EXyPNgBqgxDvB2/kin
	Zx69Q2gqe4JqdQKpk5i4LzKoxhx29sb/V9zL0Q4Zdr3f1kO+CkgMNng/BISk6ReETztDbA
	FUlK6+hJCZHqZseqTvax1qnxJereaKg=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pl2zC1ru;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of jannh@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779898857; a=rsa-sha256;
	cv=pass;
	b=n27QjFkpI/GlM5j6IaXrhyrsocG/47tPu11CnxGFwsRGGvRA+RPlxgqVooljjhdVy2kFMZ
	0C5KQjUm2x6IKFiM5YfWkZq8ZvlunEhF45cUMevLXbEUde/F8nRt4G5VCMI/WlkUFCAJdW
	xu5n0uFTbCUI+FvHMJ8z1axQIxLa0Eo=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-671f1a0d0c5so80a12.0
        for <linux-mm@kvack.org>; Wed, 27 May 2026 09:20:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779898855; cv=none;
        d=google.com; s=arc-20240605;
        b=H5aePxAwGmVQnNCf4vIp6dCPk1mKQrpq1Nfw0Hq3228X2LAJaa0QWSQiAd/Uoc2+e3
         Fq8/J8NIH3hX+AsHDz/+phnUWfu8O6PNJefg83w7mQUz4S7OtGbKhWnDdxgbArQRTaPR
         e/nU4iNBSviNih/p7gQwJIhdkLWhL8lVzpCQbbiPIA9p4NHdKQLvhsVjp/Qo2ip1Twp1
         wWkqFnXvP6+ayn1rWIRZsTqvUY4cDYu2IIPQqNEDLItMb2LD0rUriQOGO9iSYP7ZuvQP
         to4skabKf2Lnq+cvYnZjWFyFWJXI4ZYXbsE2iT+v7v2bQCLUA4KLxu1H9pcuMhvGtCwu
         XCWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BRiRpdixJFrcmqSfsDGBuoh5lIec3C8LN8yr92Ku6F8=;
        fh=LAem3e4maZeZXbSz1JfpkLWjlv9T5x/OWr+dUVlH4GU=;
        b=g1x2fmoyCMVGGZt3/kBG/GUiz331lmEZnjbA4lW3qMtEUm+WJAnAG79buKUqTBAnXa
         NBuTGtVLobd6uAXCffOnSGKkbyF1jpWmM2FzFcPz5xqJciONg41bfTB9PPvkcoE+h6vZ
         E/tcxSQZx7KO2Z/LG6xseFruU++R1xWtBTun4Cl0aZNrB0fUt6W+U/fFl6T9AwRlWSqG
         NpJ52ihjweLvkOxcIydZVQ2fKCTLzgZ2r2tgl+3rw+NuK2XskcZoRD+RLLi8MDGuNV24
         w3t+ynWLx2R21MbXECDTKYtwSdza0tdgSewcx6GSV6bDSH1pZZkqBFngMOGDEHK2FB9v
         kvdw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779898855; x=1780503655; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BRiRpdixJFrcmqSfsDGBuoh5lIec3C8LN8yr92Ku6F8=;
        b=pl2zC1ruqL+mfOfIBc4fWIKu6diaA9DS3NgpaGTi3+MixyZZpiNLq+36fS/uyQy7d8
         t+bjss/nJSjYHuOvldAJHOa5AJmEov3UH1YGg97WcK2+AS3NF+gc552hhJRGszAGBxg4
         vJauJFN7n6t65zCz+2jj/O1WJJJfvTixVMJWs3yVovLiJWAXAvyGx/uDEYZmhV2JoJGZ
         GmU+zrg0ZVd68cXCxFNF1N///CV2u/W2+NMRtEyJcoYEGSDD7MjtgMS2ngxjqNszXo8v
         AhE/xLAFQOUPbhECRTXeuwjfh+JRHW8JjEUvg53TbJ7o1QvlzmsUd4TYGm3ItmpFByrj
         66qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779898855; x=1780503655;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BRiRpdixJFrcmqSfsDGBuoh5lIec3C8LN8yr92Ku6F8=;
        b=FS3SDzquUDPCmgSBxJDn+eKcw6GzecGj359d5Oe7dfrOlRCgjpt2BjDIusiFkb6RWD
         PiKfSubPtm3jUAl4czQLiB1ISD313+YL2StiwQT5yvNspg663TwL1N+jhwNmb4zVDHmd
         fU8PM7QxiPnh1kwXXBZfi952aL0HT2tRhStkAgwc9rSPCo9Tpjga9xS2IwNqFoHxLmm1
         /6wR7/iwbXd5z/vQiRYWHOj8sLsCHJ3A6duaXkO9ZEJAb1r/+CaCDAlPXG+aIrtpms6y
         owWUHvpxrGWNeAxxJ1Y5TeHeHdeUKAomBCNz3E1zmAF2BZS/fCywEp2LLuO+EUtRzh8S
         JFxQ==
X-Forwarded-Encrypted: i=1; AFNElJ9M6c9z/Gg40gLIK8RWJtYo8WLkvMYTMiVDECetLedo7dDKiV0ejRcV9mGbAETOJ34w6l7eajJ5nQ==@kvack.org
X-Gm-Message-State: AOJu0YwUFPiv0kqVoUfBpITboHV9Cnjm/Wppe40ApH4tTHXV8KJk1HdA
	xTs9JvjB2RR7vxIMlPxxSnUMHobWihRjgD2EBBW75+J5fnoRzavKwdYCVkqDQ7Zn7ZzzKk2NWwM
	RUVb13Tt+hF5dn1UXA7GOtf9je8I3GEyqHRt9oT56
X-Gm-Gg: Acq92OEZNjoH8Zm7lPEoSP4K9R+HpfeDxVSxKlDNbsnIg8qB05hgc/1ke9pmrdixG8F
	x80cVC4FZBiPtiEuwdQg5Sq3wet3H4V01AXLv8QK/cZ67wzS00Bj+/JNWQ15b/xR7XREBY947rw
	ktwweF+Y0hO2Rlp3XVpYyjHuaLgh/zyKpdNzUSX98Td5K57BjjUin9HEwaRQN+YQTfF4aueP5hP
	5e3K54OmAAwMPtKK0eoa+qLBfxGOki2W575ZSaL26ADLHhgENZfiWriBikxzn7NOdbXMB2m/nLu
	uNpNQ5A/ZWtlftAX9eO3HBMADhFP9OvGUrAiRzzHq/VZfAw=
X-Received: by 2002:a05:6402:a218:10b0:670:9e9f:1a5e with SMTP id
 4fb4d7f45d1cf-688fd0d59f2mr196269a12.2.1779898854707; Wed, 27 May 2026
 09:20:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260527035607.14919-1-xueyuan.chen21@gmail.com>
 <20260527035607.14919-2-xueyuan.chen21@gmail.com> <4e0696ee-895c-486d-aacc-71146f0e9047@intel.com>
In-Reply-To: <4e0696ee-895c-486d-aacc-71146f0e9047@intel.com>
From: Jann Horn <jannh@google.com>
Date: Wed, 27 May 2026 18:20:18 +0200
X-Gm-Features: AVHnY4LJMjA4I-4MPpoRWm5AfgyrLNpqa8PcyRvaif8KE5wTh-FmbgALVAeR1iw
Message-ID: <CAG48ez2qj+QkLZvvi+6S78_v4Zk2eZBnBx6TozwgG4payOqPLg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] mm: make persistent huge zero folio read-only
To: Dave Hansen <dave.hansen@intel.com>
Cc: Xueyuan chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	david@kernel.org, ljs@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	lance.yang@linux.dev, yang@os.amperecomputing.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: s7ssnu65skeihiy439k71m85jrkjnc9g
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DDBD61C0008
X-HE-Tag: 1779898856-840200
X-HE-Meta: U2FsdGVkX19YwCkn4TtfMVJnqXYZLobL5Ntw8AdrxDuccR9J7aFc5uTVCFgApFssWSmK7Eopf14j3dn4yeqcyiXyfhfrv/GqH983lbFLfDKAstS9c/55N5+TKvxrMnEHsMptu+DbgmL+S2250xHwk6MoIbdxgmYMEQI5KHS/nXZQCYMBiGpnSxegaJqP7JfadYyLEpzWpBmRPKnHX1aJ0CwvbyFtAqJfTYaXLT+m2vkYre+i0+qU6/zL0P4RUY14wGB1ZriRLne/DpLgYX3I0yN42/f2yHsgP5Ks4XbMgfjDliBDvvF1IOWsQW+kjfjXXKg6I8FhVPdCI1J3NNGj+lt/+THX+NQ2+XdZ8S3Dqvgl0Gbwk3hng0HHwPYMY20z4jY1N2N0m9DtCnNiLGFGvK1iQ3cNC03Qm1tu/Svs+gX1So+stL3jOg0fFhH2/RmDEqMuqy/MgUhfDPmfAoBY0rh1JZZUY+Ne8fG6R4+38iC+fWJhRzWMRAQA/1698d40lCHTRUGybbwzxfr+1AwfcT1oc7Bod5m5FeP91qjxImkZ6aNN+kXy1dDnWmN+d7ACorjhbKMaDq4K3CVeYerNobXnBGe/ehVBpN6srGmBHBcdAYcm51xSZO0h3Siayq3XH+kGyJEUAURNdoKftTCzsHfaSchMfpCJjUQrDD/kZCQuLE0kiGWr1/30w8DJyILJy9H87/MzGSFM1bojZ3EHmd1EA2kjnCQ9PBmNmsaJ30U9QZQUSTAhUeoZ11UK3NLmksBsEvnVPQXQs1mGykk476ZVtawHHeI2/ModGhjYB2etEX+n8yTLGNtqj2DhiLxyXgeIPHt54jNIWbWT87b67qA6raKqSAjX3OhLbpaEScGeuyEvLcSQo/kabC3nOdd2BvcokT+aSK7OH3Mb/QdAva9Ff89bW/3CynAbX1IODvb4W5Ggb+hQp50RxwRXghnCth7ttCDsl7SCJ4lxtBj
 owzObysg
 SZ9vput86Afm34dQMjufDn6nvnwByTIp3cwljgWsVDVf5KkzWA+pjE/mGtcuTva4d1U+eSjm16z1Y6gNb8jNJtr1a/LO8iEI7vNSu6P0NB3jhJ7cxyWM0APNyjOclDx4TMEV3kbk8HkTD3u3e9f7b6aNEkJlGAHLrB1Rrnjuq5ajfaBnwYbxgn2K2qZa88BBlGW7v5kr0nTD+kkECMOjXj1W4IMauQqLPTvu6Cx8A0rA1TqjugCjueeYepkVCmF6PkPEVuR0Ac41iA1X9ObLddiYFlCc2x6UkaxKbeJdmbl66pFdIKSvUm63Nt63RD78EBNIOP2Ox1J/nUjHpF0TN/fo5BA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 5:55=E2=80=AFPM Dave Hansen <dave.hansen@intel.com>=
 wrote:
> On 5/26/26 20:56, Xueyuan chen wrote:
> > +config READONLY_HUGE_ZERO_FOLIO
> > +     bool "Map the huge zero folio read-only in the direct map"
> > +     depends on PERSISTENT_HUGE_ZERO_FOLIO
> > +     depends on ARCH_HAS_READONLY_HUGE_ZERO_FOLIO
> > +     help
> > +       The persistent huge zero folio is shared globally, and nothing
> > +       should ever change its contents after initialization.
> > +
> > +       When supported, mark the folio read-only in the direct map so s=
uch
> > +       writes trigger a fault instead of silently corrupting the zero =
contents.
> > +
> > +       If the permission change is not supported, the kernel keeps usi=
ng
> > +       the writable persistent huge zero folio.
>
> I vote for no Kconfig options here. Why? This adds "security" with
> _basically_ no extra runtime cost. The runtime cost is, what, usually
> one kernel TLB invalidation during boot?

Plus potentially a bit more TLB pressure from losing a huge PUD in the
linear map, IDK how much we care about that.

