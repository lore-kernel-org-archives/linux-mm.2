Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BA5BCCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 16:34:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 048478E0006; Fri,  7 Nov 2025 11:34:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F13B38E0002; Fri,  7 Nov 2025 11:34:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E02BF8E0006; Fri,  7 Nov 2025 11:34:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CB96C8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 11:34:36 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 86AF812CCA7
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:34:36 +0000 (UTC)
X-FDA: 84084359352.23.EA42013
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id 97F1A180005
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:34:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VG0rGfSq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762533274; a=rsa-sha256;
	cv=none;
	b=cLnrT2KHqdCuY9cWCE1UGWQ1z6ciCHP5cSI0jNNmp5rO1Tfgdi+NStTFSb8vfDBaEZUVFg
	FRLFmlraIfo1A+mi3TDh7HOxN4lQEaGRx+LPR8MD0UgRGVHooho0ggc15Gk6N8dWDVK2YY
	qeA44hWUCgK0y43BN48vjG1D441eDDQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VG0rGfSq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762533274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JqLak/jfCX9SGb1FCs6K/y+jVBV6jjnaDsVxIe2L6n0=;
	b=Y8T0E2D+FAwiYL5EycFhe8cSQ6b16OdUBggJhtS4q8xGnU+g9Ee+AEX6jnnlhtSEaaw7Lg
	/uwqziCTkgFJL3Sci6EfHUboMTlnXMGdz/jAstBuw9RsJVWnjY9qyahHgMAB7zc7N4EMFE
	OsQoLYn/S5yOj+Zq9li8T/Kp0YR/uDE=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7aa2170adf9so846575b3a.0
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 08:34:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762533273; x=1763138073; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JqLak/jfCX9SGb1FCs6K/y+jVBV6jjnaDsVxIe2L6n0=;
        b=VG0rGfSqnoLrrlpctv4SD5MTxQ2lqHOR06jNPvmN2G89XT+GNaMSiI3SNfC5i56lyI
         vCfpy7kfMGJCzqQkB0qB2jfEqfYnR8fr4M7maJv/tTL+JpZbkXJbDR4+CyBo5afimjJ0
         hYadNeJWKdtwU9Y4WZMF7j17VcMlLSZiAXz6qaXGoqw82eYosFoOaESWR6vrm7RvEE9l
         6DbgjMUQog6Zv6wO8k/xk4Y1XmTier4BwGsQIX4KhsTLa1x/eWStB8DhKzezaU7TdBwT
         F7hKQSWTxLkgLLFGXl2B7zb7ZDEmpQqCNmdh01zjsp47r+Qp6j+W7HH2aHTrG3OVYXUe
         fOIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762533273; x=1763138073;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JqLak/jfCX9SGb1FCs6K/y+jVBV6jjnaDsVxIe2L6n0=;
        b=HY3wnWrkZwO59WP0bMxsyirEWfFnakrSaEVLc7/Z1lJFvqe5NvOi3FRUZe54vA/uqV
         LnVXAHPCGJF2296pT66Y0MIp50j23YPJEyv0CDxwNpsKU6Po+MTVFnUvraCOKtObpyIB
         ADJBZAVtK1o9g68Dgp6K05YMNClYvYsJFdpSmQoKh6NNMTliqBQzzjLr2mMyYDp6DkiJ
         74E4Ecsh5+Oz3VFn7QTEV7QEtXvtTiEsCrO4J3uOhN0qdzicKbtLYCHw9Oa3ttJ/q0Jz
         m1AG1y+zhizeFWWqidzW0gCP3dv6wDWGLHBRwUl2WpKilWIsUdpr4cmxShjXSpZAMtBr
         ULPA==
X-Forwarded-Encrypted: i=1; AJvYcCUj/zQJ1DU7yhx00ySgdpEXVzMWQkeNWNkoLWDMi06Mw0fokez93LyYVQvG5u6FWNNF/JeEiOFQRw==@kvack.org
X-Gm-Message-State: AOJu0Yyj3DkJTSQzBMvfJ4spTRgpDL48mqxnvHb1kOB8MzTObeoiHlPG
	xPGAcGIpAbr1UcXQFgleZMJF1BffGCfmys7lkLCRwVdsANa2BmjSW2fa
X-Gm-Gg: ASbGncupsIt1Jkgv8BNKDMhfDSFfIyFe4QAWhk3mCNwwShyvA/vIlkuCOp/mwKYd1UD
	PwhwY2u5ys/0XMGBIbF+dSL0XX86lYF29uyK6DeQBQ8TKsdoEW7hdutsBYqYXUL/o7BirmW5IMV
	DMUxi2hdhQQr/BEckFEuNiO5Lozx30TSw5eYW2C1popw5a7ZeQfIV/f34qVD9bRY9mDT07qUJY0
	Y6Lu13Tlpj56sxT6N4KIs5oZwE4OpDLeSd4yYfRgIGinumvt5iwLhNXMMLuz+7Cr/CwqfAi8J4y
	CoIwsn1UnhoCgwoaRHKjaumUDjomKux3J7IUH1Cs0M162T6wg3xGUPWL3ZoI194+ZzzFN/wLe/H
	b3MoHre2+iLZFE20af0EjRw3cKKtA14UegSCkNb+mU4on+lAmj9VUtnMGagZNc4OoxsnQ5HMLhP
	oJLVdIQ2/FQYxjoDo2SP8h1qiDLcvtYhg8oX+NJqYi+sE=
X-Google-Smtp-Source: AGHT+IFnwQ/WImm/C+/qPggS8zhJNo1gfsDpe/BSoNdEd3IY9EjFMukzBP1w3IzjMAKSy446Tz7DtQ==
X-Received: by 2002:a05:6a00:94c4:b0:7ab:2fd6:5d42 with SMTP id d2e1a72fcca58-7b0bd5ad1abmr4812086b3a.16.1762533273200;
        Fri, 07 Nov 2025 08:34:33 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0ccb5a517sm3354317b3a.57.2025.11.07.08.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 08:34:32 -0800 (PST)
Date: Fri, 7 Nov 2025 08:34:29 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Lance Yang <ioworker0@gmail.com>, Huacai Chen <chenhuacai@loongson.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	Huacai Chen <chenhuacai@kernel.org>, Jan Kara <jack@suse.cz>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Linux-Arch <linux-arch@vger.kernel.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH Resend] mm: Refine __{pgd,p4d,pud,pmd,pte}_alloc_one_*()
 about HIGHMEM
Message-ID: <aQ4flRonlCygowKA@fedora>
References: <20251107095922.3106390-1-chenhuacai@loongson.cn>
 <20251107114455.59111-1-ioworker0@gmail.com>
 <f0efca40-aa3b-41ba-a8e4-c9595c19778e@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0efca40-aa3b-41ba-a8e4-c9595c19778e@app.fastmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 97F1A180005
X-Stat-Signature: jskrgai4f9fzdr5xcdt6hf1k9bix9trm
X-HE-Tag: 1762533274-73622
X-HE-Meta: U2FsdGVkX19igeFpMD5TTOFR2NDzoU9UPIFsyUmXlermb7I0l+YIA63WbWhfo7+a6GT21bt5VoU0ohG/ZwsBXXgP92LDkgInTRjt6Tc1w32qOCWGKMV+XJujtLmBHXxoZkBnl2+lrc2ym5rXoyMuD0/5cMA15ELVwzky43mBSIgVy/CsJ6Eeq9mYCMP5VyDMqRhL5bkQ1BuwVA+qwh6YEoqgnv8kcyDxt1sc1KS8niBE9C7AjU93mq1EfFbZyS4KZ2m7jgYB8bE1QhxiaX1TRar9DA11h0irEBwIS5dCvJo9mVjKq0uCGVlnaJCZNMcECjtls3TzpXZ2BXybk23Zamtfs3biHx/R5lpHGF85vFI4C6dmtMarsRHqsc+CKR4sIj88NMKa4kELGgSLZzfHfT6Xq0XcMRRAyvV5D1eFF9T8iJGnTXzWldGJfs0Pdui5+4Gj37dD5JvNJm+i3NwDo9dhy08Kjb5oEpnnT4XagPSH8glZNfdDPGf4OKEUvw99f2nM7RYtMT58hRVlDZq+MkPXL8Pw4HqNgp8Gbd5BIpZzTs68iEkXN30EOPamYE/02UYsaaCrxl2gKwd4tDjlwy/5VO3OO5ZANvXeyPunIqVFG+Za2FMlhQEAjult5o5F+D7WLAZ/D2F1ksp4rKgNnME+ZvBQd+AMZpn806r+gw22a2ZV5PW6CA+ZquwkajzsJN0o69a8VA9srSjk/ToMHsvIJ/rl4CeE/ZNsH3GD30/T+lEWTuVj6j5P1wB99JHEazih8fS3UOrgmBFpa7GtQ36B90MP8qyobGfd4s1h4nJBVtSlXtDXGB9b+eUt/flndNUjKaOao0Z4rFUIm2ZqqCsZ5jq8z0RoqBGXtbDT3Y5CAP9awMG74HVNg2iYP06olqLkDY16RsriJ9ld/sGTEui5K65czNWBWzVpP5JoyS0Wo+RRfCmg3aAzGv5MmRIVorx0S1QFPyzAN9V8t/k
 gm7DePD5
 HP1OgO1vfiXM0wuNtd9z/U7VohWzEDLtiwjen78budwRWI0ev+/muw2gy+M0FdhKf75VB/vDT2noLTQTmKb5r0UeMrDdd9hHrwSKn8s4jrAv6ozNlRqEDGjf0HiZ2UiR0jSkMTW5gyfHudJMd1YoXKzSYu/eC7od7x7X+JJgk8vOlve/9V3gPTl+JBDdPnzQo+fLiK5eJeTowN7IMqRGkBrfVmnHnmRvAdvnsEb8GFS6SRgXUdoXfM0Gj1bnWmgDHh/6d3RwZ1LmG+O0fqQ8i2bz/yKndunBO4bvdHoMYIuUOl/+Xxbd+48GCfffu6zMDe9LLaAjx5Mhh70x448rB9usFXbIUTulV0EgEq3oHaxlpcbifNOSKuCU5HiRQr2spVE9fgZ+wVVzJN5tU+8IvGA6x26r5YBqzQMUFexRhNDXmN1l9utEEobL23tJdTNOL5JwoBN9fjUD7nWs1lapKZPZu1i2RZIjitwc1fALzZzZwosHbAbC1T6/PeOJCzSONcUdX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 01:50:06PM +0100, Arnd Bergmann wrote:
> On Fri, Nov 7, 2025, at 12:44, Lance Yang wrote:
> > From: Lance Yang <lance.yang@linux.dev>
> > On Fri,  7 Nov 2025 17:59:22 +0800, Huacai Chen wrote:
> >> 
> >>   */
> >>  static inline pte_t *__pte_alloc_one_kernel_noprof(struct mm_struct *mm)
> >>  {
> >> -	struct ptdesc *ptdesc = pagetable_alloc_noprof(GFP_PGTABLE_KERNEL &
> >> -			~__GFP_HIGHMEM, 0);
> >> +	struct ptdesc *ptdesc = pagetable_alloc_noprof(GFP_PGTABLE_KERNEL, 0);
> >
> > I looked into the history and it seems you are right. This defensive pattern
> > was likely introduced by Vishal Moola in commit c787ae5[1].
> 
> Right, so not even so long ago, so we need to make sure we agree
> on a direction and don't send opposite patches in the name of
> cleanups.

I took a look, this patch is the direction we want to go :).

> > After this cleanup, would it make sense to add a BUILD_BUG_ON() somewhere
> > to check that __GFP_HIGHMEM is not present in GFP_PGTABLE_KERNEL and
> > GFP_PGTABLE_USER? This would prevent any future regression ;)
> >
> > Just a thought ...

In this case, I don't think the extra check is necessary. This is a
remnant of defensively converting callers to the ptdesc api from
get_free_pages() variants (which masks off GFP_HIGHMEM internally).
I doubt we'll ever be changing those macros to support highmem.

> I think we can go either way here, but I'd tend towards not
> adding more checks but instead removing any mention of __GFP_HIGHMEM
> that we can show is either pointless or can be avoided, with
> the goal of having only a small number of actual highmem
> allocations remaining in places we do care about (normal
> page cache, zram, possibly huge pages).

+1

I'm not familiar with which architectures use highmem or not, so
theres likely more cases like this patch that are remnants of the
ptdesc conversion.

git grep "pagetable_alloc.*GFP_HIGHMEM" shows at least 5 references
inline that can definitely be removed. I'll go ahead and clean those up,
but I'll leave the rest to people more familiar with the architectures.

