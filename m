Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAC6CEE36B4
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 17:57:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E8256B0088; Thu, 12 Feb 2026 12:57:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 196546B008A; Thu, 12 Feb 2026 12:57:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04DB46B008C; Thu, 12 Feb 2026 12:57:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E840E6B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:57:55 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8000D579D2
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:57:55 +0000 (UTC)
X-FDA: 84436562910.19.7D28F0D
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7040F20005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:57:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CTtgrtnp;
	spf=pass (imf13.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770919073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IYldN8nJ8BmowaE9ITlpD7cTPMulBlt1j14V9uSN+rI=;
	b=xRI2Dt3wt+M2II/eGjUVtSOYuXbUOPXf31pTIIfQMAfJ1KjVWAuDn8nuDVytWuVZCaiSfl
	ClpZIEORV3KL/WF0Yrskx9fAmgD6zt2J9EDe1nkLjAjHCJXWtfHqI2n4mPCslcX46hHw80
	cgCmskXCPDaX4XCOiJlT0y4urkIlH6c=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CTtgrtnp;
	spf=pass (imf13.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770919073; a=rsa-sha256;
	cv=pass;
	b=rmE7Q3dHjJeRepWXef2bMrAhtuTWEKDEcvtjyvNeH0AQyQCSuRX+Az1P+Oa48LOnpWkwIo
	cezC5LaSXH3Ix2tcnvljk/fvOoD8VAPHaK1IatLmQhl3Ev6vkwRJbbNXZ7On43kZXZF5ji
	Qu+JUKf07yh6CWIVixUs2cDc0FaHCRg=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-4359a16a400so129626f8f.1
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:57:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770919072; cv=none;
        d=google.com; s=arc-20240605;
        b=PFvSwdw0E9eWK0IRhHtjAelXwQO19nMU7mD0Uui9Ay1wGstov8ses4oJHNTjGEWQIA
         ZVvQiltz0IWx6XjRTP/SklxfgEm86i9WF3m2Kjcz9lAsRG/jxC/THfLqVSTUlIPiXkem
         t1TJuVcWWCcXg1iOIaEIu7bXGkWiOoyAe9chxTUSEIs0KfZRMm4D/u2lXdC6fPG7rm2H
         pjPvOLhDL32DUancObCliBsohtxy9ewh0mjXcVoyfiQ+oEBxluvSZmV3GcM0nchCseLG
         Y3gqp6UwqzIOYyJbpPM7pO2J7hfgt17n0ry5fhYtrEPFA5sTGCzSMhUHk/nf+MvWn47T
         Sf0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IYldN8nJ8BmowaE9ITlpD7cTPMulBlt1j14V9uSN+rI=;
        fh=Yhuj/Qh6GsRRj/uWS0DuglmbnLUBq2d2hsp/TMQgWTw=;
        b=hhyG1ZZG4nlTLYA7gnfqk9xIlD2Ozo1K33kv8LQ4cH6skpRY9kSDtP5qmnvmNVeYG7
         C2IhfQbLcQH0Jz9Rpulb48wG5sJaKEthiLNos6WPSOu06S2FwlKtqg57bYw9iWIst5FV
         cUmhW7vizSTlBPN/2hBBBtXFv9chIlbJ6hKlRRTmdTREUJKSHEZYm0iFfTmtDp3Jhysh
         nX1iQ8VBBPlmoE8lzVHtRpSD45M8ehyA5B0rBAOmAhfjhY7eyAjnDCKqBrZbJD8CSDk5
         xMYHm6YxVSOXWBFFG7i0LCNn4e+duoJuB6ekfjyE3wvGJwiM09OpiBy28yq5v6aIreB2
         o2TQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770919072; x=1771523872; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IYldN8nJ8BmowaE9ITlpD7cTPMulBlt1j14V9uSN+rI=;
        b=CTtgrtnpR9Jt3SA0rpEI49eEeG2eCg9g518KJXFstCvSS7DyMSREy3+e/lEuZgYC2T
         Xru9vJbDBeu6FCSvBxPLSptDLZENznWfBOmkNQUyrRh5f1IiyS97Oi9qL+EZ1FmNYcrk
         Cp2M2n6w2cxX0u37gOSlW16EDmQC2Og01ymT5J0ealgAHklBeEpV9JhE7RhIor5TIj/k
         l/yKNN8YveFj9iSISmeWjVCmQeLjn6Vl+MuIMRsHHVPdOhyvRApGMGTG1kcooGJI5m6A
         Wb9iIQNqMlvnnkLZj6fEbovR6jfjf82XCxZiYv8e4oGWgBfFlMcBNIHbGNgaFFiinMLw
         IL5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770919072; x=1771523872;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IYldN8nJ8BmowaE9ITlpD7cTPMulBlt1j14V9uSN+rI=;
        b=Mw94KkK9PxGdG7pyevUk9memDUz/UsXCx7APro7eXwv7KAkRHu7L5rllGsoAiFYsOl
         oxP6Cyo8tqE8PVE8pgfHlJr6t+zvhFXACFP5xC9aHkEmiJKENidKPPg3WS2VM9T/mca+
         nWZXzGb9/aikGBAnz6jY16v1vqw1tDbmJGvbDXtp5M5FMVUEY0lrhfRVAixh5Ukp6pd5
         fNXZGx7LfIFerLR6Ccpp1n5QghWWsyuXgcPn3Pkjgo+f/EbD7vo3tPogyBkpAWMj2orw
         obHJ1vTwubfeF+oDJT3fM3bUtLzhnHoE32kiZEq2EtRUzy/1CWygAvHi+EDUvxBEoHRR
         PnXA==
X-Forwarded-Encrypted: i=1; AJvYcCVmNxIuLjspt6iUmkOvvZ+YWEG4nN5SFbCO4SlloRhk+TpZ0HRxsM9N9xsuKf1Lh0MxMExUagBRHQ==@kvack.org
X-Gm-Message-State: AOJu0YxSHgpvwnwwOQu26yvKabr8zWlujsr1V1h97PyrCYUyUjrz9zBp
	FfBgKMFaDnLXQJRbh40mUgzEheYhaaPvEpok1MRrjw4vBklOoVb1wPQ7dUH0Nyai2cdiXBqWlYX
	YKd1MrSvnxz/UijcuV8SNBDgYE9hegV8=
X-Gm-Gg: AZuq6aJ0fDEQ/JeqX73FF+L9miMw68+bgINr4pPHG5GVMC0utbmJuPkZ56lgzjy5ILM
	SdhdJzsDaTXoDNwmzNZ1ADzxdkj/I5mBbue2Gl+TbrdMaAHhwUnMVL8LJpRFuXoLB+s28k5zEau
	8WwW+mkgzHK75Xlv5o6r/YZr6WGuqGTap/l3too8uiKy6nZeiksUuwkELnNcG3yNoWwIrZl/C55
	5c0wSkDCoz37GSFR4bF2kH7+aQWSS0vAhGCt30IYDjtRgRP8YGI/JgZOl5sqRV7ZV93/RW+d/v8
	5ZGm+TaEhCql4VUdvZYLrRhXr6c8idk8oKVvoCiO/p8SJObn1g==
X-Received: by 2002:a05:6000:1acb:b0:430:fa58:a03d with SMTP id
 ffacd0b85a97d-4378f171792mr6133718f8f.63.1770919071690; Thu, 12 Feb 2026
 09:57:51 -0800 (PST)
MIME-Version: 1.0
References: <20260126065242.1221862-1-youngjun.park@lge.com>
In-Reply-To: <20260126065242.1221862-1-youngjun.park@lge.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 12 Feb 2026 09:57:40 -0800
X-Gm-Features: AZwV_Qj8afqc0fwywStVAnuIAl3u22UxJ3GgjvwlQjimQSLzvC_WWxVKFk3xE_E
Message-ID: <CAKEwX=M5nH3=aqSLybCfLrtScpYKz+jRWt3JYG7im70DCoyjJg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/5] mm/swap, memcg: Introduce swap tiers for
 cgroup based swap control
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, gunho.lee@lge.com, taejoon.song@lge.com, 
	austin.kim@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7040F20005
X-Stat-Signature: jtxf3tghxt6i96qdzjtgdh59j1x1ewm8
X-Rspam-User: 
X-HE-Tag: 1770919073-125318
X-HE-Meta: U2FsdGVkX18p0NJ9qgYXG0l5tpf43wSXTqbjSw60bBLxDIFAJyzZRrp4y5lgmGFZaP2oaVmhHi4DxaEWMAwEzP5tkNBvcAYH3TxCqOIJPMA2X/c77+TGVVeQJFwNi4d0JNzoC8TrIb5zyMoEJB4PHyUwNi618RVguNnkPamKwZvr+Fa/vheO5OsD5w4fzQ7yGpmofIAtw3Lor9/4bacmAIOHxVLw2nkBeBujUzWkgUOPGfw2Fjr7S7tURrSOeJXw0z4XK9xAfj75LmjTVAWv5gk2vclRMMHHMQgknLThkokQJJAuhmA/AJvXr5lq8zqWOH+Wa1dsCcq+pbDDNzD/nwmc/uoZ2dCXhzWQOTSyiBFqIsa+j4azdE+s8HQAWo3hkCAqjuEbC3PtSVEsHDemMqR4UZUhw9PH3Krlp8TxYH+6u0iK1Wjfbpq7yENax8h+C8fWT9Zk0DoJmh4i6cQWOJvR5SirJpj3Ujl4RTOPlkyvyDTuXwzbYY4StFUX3b8MV5/O6I3TOcUqNr/slPnixb+IZyB8jkX8YnMtoEhLdjnGw1dE8tLcyahBLSYSC0Sr5bQqzrXpMjTY23rizvfMrwJpfdnYhIlOP+zruQsBoJrwPCCGjRe5ATS8PTZ/Q2TU+WN+4d5ltYpxRnN8On976NMOx9I9HkTlj809xO8rVjytdx3MITRGGCHGPD0ncyFf5Fd2lBpP4/HS8nyrro294rci4PlyrQyylNLRKcyc68OSW8hCRa6wrJ6my+x5ntHqixDdigJQhDhW0/JsDUlZn9RZ1sZUrN6RKEdfH+iiOXYe+SaVp04Kai7xzmybW0iD+DdFcwf3qWHUfThZSnVA8hIcnhlhEvkWlI+ghy0PQXkCJR6STv4gLq71AhurEu/uhMzPP1DrQi9xlwS3p7qVxTgQpKUXxKrUbh/nbz1IejOOtEoYS1+58lVZCDgHCbKn+Co5LuIpMgxXXS7/rIr
 hIK79yyU
 OMlVwV7dA0BKAllq8Fdj6E4xB/JPjmyWDZF5lZlJsVtVpShrTxWVmfcKN1DrsfEqhf9u2hssstgG6fjgose/4HCE+mTpo4nKk+fMRLxorMwXDvsLcEypft0FOyyXkSsLA+ym8wNhM88fYQRBiCS45+3uYQrbY5MTNNd4KIXTzOCLXLePL9SbilRU3G1NPOApX0HlCkMkqfmxtWTiluUuTbqitutAzw/rU/CvDFUKv3tfagUREzpTOKXlDX7oLTs7OKwBIZ3nRmSKjB40Y3ff1RxLWr/TUcy4AqkXXlwKpyfxWe654O4aqRbWVK6txINjyQp7VD5anQ5qfMzWYTh0D2IDXxYqdWcvtGZdedM4iSE8Z6mMmEDPuqqro2xW86p6XdkC1X8KVY7KlVpBQjkdMMhgTvucJblvdE0PCnC6oeWbstAr8z0Wk9F/rsv8aEhj06ycNcD5Ci9p6YfbuyH+9kwkXiVAZt/b9wwlPeE28Z6FS4Mi3z18CDTR67g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 25, 2026 at 10:53=E2=80=AFPM Youngjun Park <youngjun.park@lge.c=
om> wrote:
>
> This is the second version of the RFC for the "Swap Tiers" concept.
> Link to v1: https://lore.kernel.org/linux-mm/20251109124947.1101520-1-you=
ngjun.park@lge.com/
>
> This version incorporates feedback received during LPC 2025 and addresses
> comments from the previous review. We have also included experimental
> results based on usage scenarios intended for our internal platforms.
>
> Motivation & Concept recap
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> Current Linux swap allocation is global, limiting the ability to assign
> faster devices to specific cgroups. Our initial attempt at per-cgroup
> priorities proved over-engineered and caused LRU inversion.
>
> Following Chris Li's suggestion, we pivoted to "Swap Tiers." A tier is
> simply a user-named group of swap devices sharing the same priority range=
.
> This abstraction facilitates swap device selection based on speed, allowi=
ng
> users to configure specific tiers for cgroups.
>
> For more details, please refer to the LPC 2025 presentation
> https://lpc.events/event/19/contributions/2141/attachments/1857/3998/LPC2=
025Finalss.pdf
> or v1 patch.
>
> Changes in v2
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1. Respect cgroup hierarchy principle (LPC 2025 feedback)
> - The logic now strictly follows standard cgroup hierarchy principles.
>
> Previous: Children could select any tier using "+" regardless of the
> parent's configuration. "+" tier is referenced. (could not be silently di=
sappeared)
>
> Current: The explicit selection ("+") concept is removed. By
> default, all tiers are selected. Users now use "-" to exclude specific
> tiers. Excluded tier could disappeared silently.
> A child cgroup is always a subset of its parent. Even if a child
> re-enables a tier with "+" that was excluded by the parent, the effective
> tier list is limited to the parent's allowed subset.

This comment seems a bit clunky to me. The "+" is removed, as noted
above, but then why are we saying "even if a child re-enables a tier
with "+"" here? Am I missing something?

>
> Example:
> Global Tiers: SSD, HDD, NET
> Parent: SSD, NET (HDD excluded)
> Child: HDD, NET (SSD excluded)
> -> Effective Child Tier: NET (Intersection of Parent and Child)

But otherwise, I assume you mean to restrict child's allowed swap
tiers to be a subset of children and its ancestors? That seems more
straightforward to me than the last system :)

