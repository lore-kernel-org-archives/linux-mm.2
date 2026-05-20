Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76770CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 12:30:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3D536B0088; Wed, 20 May 2026 08:30:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEE0D6B008A; Wed, 20 May 2026 08:30:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DC576B008C; Wed, 20 May 2026 08:30:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E4956B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:30:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2C8F2402E9
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:30:13 +0000 (UTC)
X-FDA: 84787730706.22.DF4429E
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 045BE1C0011
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:30:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ffJ0I1UW;
	spf=pass (imf21.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779280211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RVDXLgZcWUdOJudfln+3132bH3PdmBQDTl58aH5R0jM=;
	b=JkyPKcTPa/MhO1Ogn0PfHXL9+R2vUI/jTcGGIbO9EjCyqhzzTqr13ThOfuydGixTXZQ2Ca
	2nih9pphfN8Ddaf0cCOgFCahA33FHF4/luki6BC54rs5wRtfLJV1f9yVw0Wcela/9n2xQd
	yQZn5Nw9o5OS2oz8/oy+PUszzdhK3nM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779280211; a=rsa-sha256;
	cv=pass;
	b=CkiAkrPRMP9672k/wp2RBE/Nm6W3DCtsNnYRJscjkzpVH10bcoCc38SRGIMsoFsCE4W1j5
	skQgtFVExJ8s+pw0T5e4WlDjsFbukWEFZlBYjRlhWkCUrTE/bjcNnuQF2BJX92ikh7oT23
	ysYuHNL6uWQPi+H9wqtEsPRJVzSZF60=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ffJ0I1UW;
	spf=pass (imf21.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-44dd5cb0f81so3928999f8f.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 05:30:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779280209; cv=none;
        d=google.com; s=arc-20240605;
        b=KzDsMqcDHVEtrJVxBj1WlaZiySbClUYBIL+p6wUtzs9q7y8pGjNipK4cfxnNF8JKhK
         t57bpepcI8ndbPuIoqx3mfBsrvxQEuuaDgcqfnAUzAlLCKC1LQ/dREg0+stQrho/Q4eJ
         9Jx7cQ9+vMX3DJKo+K44gWx7ag8Kqbk7VD2XiFDUoLBdKy3K11YC31cxVEuYDV/JSZCP
         DuJE1la1JTUYFptawoHkXoZPCdYLMgTJAoVOdrax8F5q7sZ1HmyNlWLOM3L2/db5+R4n
         3bjBPFVWnHF8UoGY0Vrn112wR3yrLqWPR01TAEQINgdJApKTdfp2/DzzMLWM2RW/QBlZ
         vqhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RVDXLgZcWUdOJudfln+3132bH3PdmBQDTl58aH5R0jM=;
        fh=uMBojdllnCMF+2NIvXB7LkBiy1Ge6BSS83H8F+mohh4=;
        b=f6l6Gz3tWTT4Hkjy+hdDh0OIpVVWJWTuzmq78NFW9ceY93L9RPs2J8QART/kEepU/W
         vPmVhvH+JWJ216CsP/3vmPtnzBB3RS/UEkn/tdWPSzDEntugc4JlqASabvpFH0Zpsx29
         rEgb6KWBFhTgVhgXOK8DGx+OLACI5+Bu65qu819M7xKX/cC9WwX2tZyWYhhq6ThFnX9P
         hQE7V7XImMgrE1PWnxR/+YEDrMkRaHHQXNPLlceVAT8CsjDdWfASe0eWFLgbQiP4sPui
         leGmFO1dlc5IiDTOkN9FYZCOt38cstV+Z6M3Qv5aNvdchPQbSUxemd/uXN0mqGbWgQlr
         3cAA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779280209; x=1779885009; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RVDXLgZcWUdOJudfln+3132bH3PdmBQDTl58aH5R0jM=;
        b=ffJ0I1UWnZPic++VNZK0Kruwb/Y6CltPbUxjTKVo9DbU9iG9lX53Hfe+clyPPCIGiI
         nU8Ajzm4N7oqdUuQ6fsMyIA8hRG+BlXQqlirTMWrOsyAGLbyExXKc73keQ6a6O9FZ2ei
         Jakpf4SMrwfzT+uJML4DIXxitmFdJI3JgetlMVvNhVjc1YzS9mgs8BvVPdDRJyjETokR
         ZkXO4fg1X4ntgwoNsKWVM74Y0Ltq7mi5cSHHWiBU4dLX7mzoH1EJCS5HAvksfKMDpter
         776ZLkt4U+xuXxMhrZ4BAxjxHV4Vnm0E0doKA3Adjgw1OjX7mlSC6cnZhxVDEdvQR59q
         5VdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779280209; x=1779885009;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RVDXLgZcWUdOJudfln+3132bH3PdmBQDTl58aH5R0jM=;
        b=FeecNCURBRtIjRGvIt2KP/xnk+NbzwwLTytUBJadgT3QU/2kyRQAAijH5CjZkXlErd
         bdLrIsKhup4jd33iMzIaWugEY/e/Rn2/kEYE2XgvHbM2L+DhhwMU8HNWixyx2PyBzbuw
         J4T6RdQ6F7zd1njmN+88423K0I6o+vPFV04u/tLsnwG1KPDqv9NbG7wp1erRJ8g10JAl
         UzvswGRq7Ys1vY0jN3knacq+SXwkAasUx51PeyS3UPvg8tohsvVVLps+dTAb9KiqHuLS
         PN+cSq9d3rvVwCbQrFfBMNc6mZcHiAL3gNym6rJ20Mo1j5q/QDnp8nCJfr+6OTVTNleq
         0PYA==
X-Gm-Message-State: AOJu0YzmOMUrnWfdWd5gi1JsT3+qlC+KDZjkKF0JYgsKygPYf11GwxPf
	eHhQdUmVIgIVGkZV9Fy16eVuF84yw4riRE3+wh0PwuaBFYPmxWX7yMvAnwCjsSln00OUBNetaC/
	KfTv1GW4ThaqT7npQabIZM4VzWD+Gk64=
X-Gm-Gg: Acq92OFpmn0cmCn9yhsW3tt9I8AMExtm0Q15Fq06+N6a7retm/iguzjcjNxfRS7aIas
	+ClxDpQ9kajJcO7RNiuyBQ1OZ3ULTENs8ltOwehdgGdSoCAveANASf1HHcEHC5zaE18pLmo7Kgg
	0xsljHCxDm2oXblDO1cfAe1Xa4cq4poFTIasuY8NWKQ11xrCJfqcCMg20hzHJvXHJSY3UrLLjbZ
	kvZUohkqj6xQoFHKi66l3mJEK5mbSs7UhhswyNeyLKVsDqyVj+2xufurk2TBBsMaGQMp7CT+OUd
	TXZgXt2JkOiXWMhb9D0=
X-Received: by 2002:a05:6000:1885:b0:45e:88f5:cd01 with SMTP id
 ffacd0b85a97d-45e88f5cf39mr11767823f8f.24.1779280209043; Wed, 20 May 2026
 05:30:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260514094108.2016201-1-jiangwen6@xiaomi.com> <20260519131738.11a78ba88e1be28ba5cb26eb@linux-foundation.org>
In-Reply-To: <20260519131738.11a78ba88e1be28ba5cb26eb@linux-foundation.org>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Wed, 20 May 2026 20:29:57 +0800
X-Gm-Features: AVHnY4JRofC4Z9W1Vip22g--k2HQT2-LeN--T0Ui5FZTEy2X-VIsk0rnAhQpIDg
Message-ID: <CAHKocdHVDhGAP=DXiYW5tF+3cjBR48=x6YFhCpFARjtt6fjstg@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, urezki@gmail.com, baohua@kernel.org, 
	Xueyuan.chen21@gmail.com, dev.jain@arm.com, rppt@kernel.org, david@kernel.org, 
	ryan.roberts@arm.com, anshuman.khandual@arm.com, ajd@linux.ibm.com, 
	linux-kernel@vger.kernel.org, Wen Jiang <jiangwen6@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 045BE1C0011
X-Stat-Signature: 4jnmkrksj6d4yrimk3r71wh1xhj5tw5m
X-Rspam-User: 
X-HE-Tag: 1779280210-343777
X-HE-Meta: U2FsdGVkX19e7JJYm89Bs7N9EhhDBwZ1zYHjTEoAV7zAAtT9ZFnFOhUm4kpin9ly+wOvY1zJuINCSm1RaWjUmKL32HuXjZ+3a1AVsG79B23Nbghm7NcbuWvdwqWlSC2dIF5ewbBZ2+s7yhryzpG1p9VcyyAlpxnENjRmyAnW61YpdHneOxIrW1d1fEPxTqBNVdW1BuaF/Ab+kBQ5N2fWvb/tt8+qKD/Xevr7/oNriwG+1bPXpEJZXbM4zWuQpDeBrAh+lfFXc1WSMFALZXEt/Z2B2BG9OjXkJPl86H3LiMkU0IqcNZkvbC0/jAHvplFbSQBAEzNsvp6nE8rjvY7q6kcopAnD8Sb7IWo7AVIm1lgd/IuT3I4gMhTdDqEd2AJR2NfIOptO+PbrmkzO43MXnqCItxzQXV95kiqcnHUOSABHum6CR6nugK95Gih0r6lyI+inVXB/11KJzkTctI6UK6Qk6rwzXLdZjr3N2pUBnu+AsLTk0V88wMoaPljszCtzau7l855MKRXUWa47VThX9ScNxwUI6K0pQxR0HBoxAP9iMMbU4mtba1MF7HsHqnKonFdvRlEPUimIVsKV08SGD8wZKfGkSBcOpZn0C10yLgX+IkCGUYvQs7Xal0pjnuNfm8+bxyHDiUKG/v7PYtk21UWLBqT2deKpOIYcjS/q4p4CtH8LNvvvyE3nX52igmtaqa2KM0oAnNsHbYykUbYyip8sTDeo9TCqrt7ju4thg8PC2Y8K96A5c5pt+deysvzAcWL0NrrTQBN9P3SYYSIb4Eu/meMHNDL6UeRPVlIB3bwch8gN5aXdD7oWAzsoLlb0unUfV5y+XKSu5H1BOIVVt4BGwJh9Wf2GPCkYJ6YUFBTefiQ+iXrNKazb+OYbu4d5B+Sf1WPAUP2ei0eESXFE7legB3I8KydOWVhXL2Sq7HJ1pOQ8d8b2YfDPC9O3qyZkc9uhK98myM0ccANatQS
 RFlEjXiC
 neDop81LbYye0R6sTDpDeuEGzbNNIIv8ATN9/tjFG4ztROHpjIRuQFq46hayNIn22BBuBfA58q3TY9waUWzXK8enfr0XhkM7vYTGlPpSD9FaqYyipMtJ+3hLjgbbmqmscTVC5Ti7ubbW8exwJds9DEXHDru9vRXQp6AePAxNlgi18qawJuR1I084bSZTj6eFNtzwReXxlWRsxitD2budzgCCVA3kLODOfNh7QjSGQd6MPq7LgXFQaNC/4M5ej1RYALWvYupUmwNOukOsCvIEoxfnDGrIoozhaiOmpFZSudoGapEP6hWmKs6FSoqy/vYAsJASQdr3pm0kVLwz4Qzs1oeYEw1Dra1m6ZdmfAPGbTbYYzpQ98x9lDEIn2ksxs+U2VBbQJqUObRChSDIuIYngJlz6iiynZO8aHttnWdMkp9fFoMErrNbsWbSza3zbQNE3AmUujoVdv5yZ34QzIHuqn0JDWnLRsC2Fy2i4NNdgPW2J21FEVf2FuJmpQEaqNlPPiE6ICNmJ8HYHMllQMbpK/jGRRxAkIvv4QjGfYWiMNVI7bxWYReY2Mesiv9fInnBG8zRR9JNTLxdXkO1Mv29qugrESt6okWLtp5ZLD5MRgIW8nfH/RQeonGMFYjbCfAcWjnHJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

I've reviewed all the Sashiko findings:

- Patch 2 (fls() truncation risk): Will fix. Replace fls() with
  __fls() to accept unsigned long directly.

- Patch 4 (nr overflow risk): Pre-existing type choice.

- Patch 4 (missing NULL check before page_to_phys): Will fix.
  Add defensive checks consistent with vmap_pages_pte_range().

- Patch 5 (flush_cache_vmap with empty range): Valid point. Will
  save the original start address and use it for the final flush.

- Patch 5 (virtual address alignment not checked): Addressed by
  Patch 6 in this series.

- Patch 6 (caller tracking loss and while(1) loop): Valid point.
  Will pass caller as a parameter and restructure per Uladzislau's
  suggestion to replace while(1) with explicit sequential attempts.

- Patch 7 (partial cache flush on early break): Same root cause as
  the Patch 5 flush issue.

Will resend V3 shortly.

Thanks,
Wen

On Wed, 20 May 2026 at 04:17, Andrew Morton <akpm@linux-foundation.org> wro=
te:
>
> On Thu, 14 May 2026 17:41:01 +0800 Wen Jiang <jiangwenxiaomi@gmail.com> w=
rote:
>
> > This patchset accelerates ioremap, vmalloc, and vmap when the memory
> > is physically fully or partially contiguous.
> >
> > ...
> >
> > On the RK3588 8-core ARM64 SoC, with tasks pinned to a little core and
> > the performance CPUfreq policy enabled, benchmark results:
> >
> > * ioremap(1 MB): 1.35=C3=97 faster (3407 ns -> 2526 ns)
> > * vmalloc(1 MB) mapping time (excluding allocation) with
> >   VM_ALLOW_HUGE_VMAP: 1.42=C3=97 faster (5.00 us -> 3.53us)
> > * vmap(100MB) with order-8 pages: 8.3=C3=97 faster (1235 us -> 149 us)
>
> Nice.
>
> AI review found a bunch of things to ask about:
>         https://sashiko.dev/#/patchset/20260514094108.2016201-1-jiangwen6=
@xiaomi.com
>
> It doesn't appear that you'll be getting any more review on this
> series, so please check the above questions and resend?
>

