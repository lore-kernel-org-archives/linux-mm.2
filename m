Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22C8CC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 01:13:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1C3B6B0092; Tue,  7 Jul 2026 21:13:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCC196B0093; Tue,  7 Jul 2026 21:13:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE1A26B0095; Tue,  7 Jul 2026 21:13:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A44846B0092
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:13:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 211A21C81BF
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:13:49 +0000 (UTC)
X-FDA: 84963837378.19.F0BE85B
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4EB71A0004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:13:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rV94xKHO;
	spf=pass (imf25.hostedemail.com: domain of thehajime@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783473227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JCiHdm5WORGJykvyk9QwONa9C2e3Uk4DwaO5rlXDywo=;
	b=nCiggisitHOwOgZAunRr9dPhLmsRRsoMOqqeKLxctiEdbbwUlVZG2zNtgWgQYbEuyAcAPt
	15nzX41HVvnCyY6YltMhF0cb8L5uJ++b6wmiO7NPUmfrHbHn5N8iQoCYlNWvqhuwySuinM
	8qr159Ukjix9scuXlswVawEBOk0Tf9E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rV94xKHO;
	spf=pass (imf25.hostedemail.com: domain of thehajime@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783473227;
	b=kdAteK4nAhm8dKYS3OckcvMcsj57lPivoXQTu1mgHk81vDQDqc26tTMKskGW4un6+OOwTw
	NSM1fSVuaA12Xf1jaEnBxwuPLmPabc1cHh6twW5hpcT4G1LbSpnUFAK5q2E/9GxDVw077D
	wZaLQBOo4mt+gSPKICTWXyf9YvqNpN8=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-847917c3678so782758b3a.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 18:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783473226; x=1784078026; darn=kvack.org;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=JCiHdm5WORGJykvyk9QwONa9C2e3Uk4DwaO5rlXDywo=;
        b=rV94xKHOk1OQC5qKKLXam3OUJ8JkeEzo0I4GuPi6HmLikoN+0Y7lxWoGrp5kNHwvGM
         aqXie5/ICuPr3lAb59sjrJUHcDpPAY/xlu4bpInYt2AZBIjhRXsaxylmwBudqcExJXKn
         ufd0ydRfCJwXZE3GkoLfW1/k9a+VBSMP5DCqx8ZHc+ohkUWENeA3NTSUHc79mOrliEaR
         laU00QgJh1JqXXRR5FU/BPkOBuZxrHo6SJActss/HohgGKMHnOROz1/eDE524NKYT8f5
         RsqQjhyQRYAwnVq7bZUvByfTfG87vOotKVHYyTdxSbPWXvQgSV22cB8O2TNZ5G9OyJZZ
         JKng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783473226; x=1784078026;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=JCiHdm5WORGJykvyk9QwONa9C2e3Uk4DwaO5rlXDywo=;
        b=kR5MzVkTvNh0Ah4+y6dD61zm1dyRImkrfbiE4R8AH/paQkXwhTGAygXpr3LY+/re4+
         rp1P8b7Li6c7WKGKwSjWeYW/DGQ891h5wfDnY32zMXScHrbgaWMoLWM7bYK6lK7hlUVD
         UHv0BgwVnKkANutVJDnDLx0914V5wetn+J9Rjb+eaJF1iKPY7jaPulJ67Tkiubkktv6C
         Ki8ohmWMMSPqPmcvM3IEhB8Q/WI1mOOd695jbduvapBelU9KaNtsxySqmecBuyIU2zJX
         8GmPlJApYXjxtHOxDVVZZSq4gf74DyBHKd+Gn0qdT681mc7qd0UYIu86uhIaoxx/5Fa2
         9Zlw==
X-Forwarded-Encrypted: i=1; AHgh+Rr4Ae4L3reK/RZnAhK6MNr6ritjt7X+8Cpq798hEnC+K2YJCNWJeDzJHukcL7Jv+nM/DzrQHyskjw==@kvack.org
X-Gm-Message-State: AOJu0Yw1W44WCKK89BC9/vIQ0lJWNgs5zIf9VEat68dWQPte5g2/d/LX
	bDXdtmEuVVtM2l/NR7CotNw/ypSFj3CVN5ShWVZFwRVtdJA+WqTdVZFL
X-Gm-Gg: AfdE7cm84C/bvhcq9vZJ4c8y0B9gsUdAWofMKiOd/sSQZBmR9Smc+nqDaueqDa4hrw2
	CAnEzOv4dDtVska6ZMb2H2c7caNmoKaMKV2w0Smw35t4CvLLhK2hFyYIv9/FhrVF0+YN+41ewzn
	GBi5guXNX2bYbncWtHE63bOMov0QwbacohJHI8BQO0mADwtpkhl4khaOBu5+IjlDKMo2jScG27M
	tyYspT9/059alyVQkRBffXFU/QtNG6ffMsbey7cv9OdNHsdY6XC4SWZjDXnIrArBwy2KoZ0DifU
	DRxqIUX7jOCMzcnvLbzAG8fmYvT5MleAozFc5h0ODn06Wy1kbkviD/MdU+C9UpdgEy5FvX8aJ28
	SUMZ2KTxdsUlDNCxbuhfeEQPlSy2uJjZ5cjl8urVkq6GjniWEP6V7PDlJrnlPu3vahktkWcKG3K
	RwiQXHCKpOdKpysl7p2HMwh0A9mhD6QWFl5UDniBXe9xH2/VVXG5ysUD7RC9q2c8LCIHk6LJTsH
	RqfPvlrob1mrI1J
X-Received: by 2002:a05:6a00:99f:b0:842:50fd:4c13 with SMTP id d2e1a72fcca58-84842ed15abmr497445b3a.4.1783473226084;
        Tue, 07 Jul 2026 18:13:46 -0700 (PDT)
Received: from jupiter.local.gmail.com ([240a:61:5255:2f60:a40a:bf83:e8bc:50ff])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6db29d1sm6247787b3a.53.2026.07.07.18.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 18:13:45 -0700 (PDT)
Date: Wed, 08 Jul 2026 10:13:42 +0900
Message-ID: <m1a4s29tbt.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	linux-mm@kvack.org,
	geert@linux-m68k.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: nommu: fix the error path when vma_iter_prealloc() fails
In-Reply-To: <20260707173910.928c74a7e4dc8a1fdfddae3d@linux-foundation.org>
References: <20260707235137.498738-1-thehajime@gmail.com>
	<20260707173910.928c74a7e4dc8a1fdfddae3d@linux-foundation.org>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/26.3 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4EB71A0004
X-Stat-Signature: 9mwzhdjmc5omstordsna3thhzgauwtc1
X-HE-Tag: 1783473227-389292
X-HE-Meta: U2FsdGVkX1/hLfeygZrsQZ82ifNZ47PQWDC8+6oRpp11yG6SWbAz2mRrF/0omP1ywi+jGVHGCQZMGLf87bC23Vkey/ezGmVEKJTdYrjMw8BnwO4/6IVOya3gOl2sMySwvopKbnNesPDqCjvFpFFA079qjALwSE+1H2JZlTAxxHIbZHHZVNKIsy63vAU51JwLWZOrUDGjBIwmhkhB3Fn5r9GNadVUB8R8pFXXfE8REpuuEhmPK310y2PPd0BP/+0RYZUQ7oCloGhittkI9BX6YU6x7wV/DSaVpihdA3VpLmHB4HolmxePpRarD6EfT1o1OBE+y27yQNnpgPxROQioWXtiQZ1yn4hoHdqD4X95UrxTN7/7OngUPphCJD7rD3k1QqlIKnInPJNpHBgjBTD7YbgApYxk5P2piav6EvUZZhO/KkGsuXlXpio/YL1oWX7IpjW0VAgvkHT+uEbeB3BsIcrvVhnQHUSBYi0DgEB9MApj1WUU0xEayHQauC5AOQ1xHMKMfHNDmf69r7/12CBAWR1HmC0HpObodAoaJ2i8hiji0RQAdPc8htjFcGr00y8KFZKPiAIPDcoeiV9Jtivri6XAU3JRwFLi6yBT+mDpnj9NB0MKNOihASzsjWAaAU3hO1UxYibJZfUDu1CdxFWf/tXIrGNgVm+/r9+q/mZoe2eEfE7QjR71V4GpPupndvnUhkjIB1caghe4xrW6L5+wUx7bKUk0zEA3+38SdCklrabJob+nqiGt8kLKko1SA2Jb+tpnSzrCftxemUQvjklhuJ2PXfHhnWfTGTA0pE1R/AMRcd+J/dxWcfQJO+HYWxxjECyS0FEtBVJRXg+MHR452ujUSaReNReOYg55CkSpDpBi6/527buMpAwEofFbavtfM7mZ0PgaPqhYbZUUzwfOO51SAPFlJV00E0OMKG93ebaUhChp22Gv+bKTGiSRSCexU1Vyl8eWEJchkb+W6TB
 QRrgD/H9
 nHQLJyOguKkoZ9h8lqksIzcOzy61MPbMgdMMRZcO12JA59+YQa9+jdTe0sjzmd3u0kR06F6idL06HD7kAboiMu7YuHcNGtitfp33K9a7LsV/Jdo6d0YkVvPCjIs7kBRHTNiDIP+nEjuuj7NJAvyUMXBh4xunSQQRwXTbLS3Otj2uA5EXHI9/i+p5lAVxq5VemmpsiP7Z4VpPM7V3wdb513d2a9eNdBf5qoCp7HqIbvskngHO/YxyyRoPzglYcr2o3Z9sZgE+f6bHWQeTQsGPg6nj5vg5e9kkPyD+Ya7v/BYy2lIe626jSJk60OcaWhIsarRkeY+YGzTVuUIEBwUtQJqE/9H8PQW8T/nnFhRvkYHKjcE/1ZPhQAcyJmfgFAPLEaguEFHNSjVoc1rfJQiBYQ69iWiW2BxuIuxu/o7Yv3Tn0r8bgdbk/TedwVEDuJN6XPmdq7dl23adG5mvgXssY9XFYZZqk3v7PePrl2E3zl8yf2cFdLNPiHiyO0jBAawQTvj1bv3N7eoSfm9s7bc/RyBUCUJQi/nf4WfiGar5EGENe3EZEzuROhMrQPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, 08 Jul 2026 09:39:10 +0900,
Andrew Morton wrote:

> > Those issues are discovered by Sashiko, linked below.
> 
> Thanks.  Now I'm wondering if you regret opening this can of worms ;)
> 
> 	https://sashiko.dev/#/patchset/20260707235137.498738-1-thehajime@gmail.com

indeed, this is why I wished to do it locally to avoid this noise (but
failed/struggled to prepare the local sashiko due to lack of
subscription for me..).

I'm sorry for the noise but this is what I wanted to know so, no problem
for me.

> afaict, all these issues pertain to failures from vma_iter_prealloc().

yes, will look into detail and get you back with another spin.

-- Hajime

