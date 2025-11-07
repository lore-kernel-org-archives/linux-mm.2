Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83AD5CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 16:51:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B2528E0005; Fri,  7 Nov 2025 11:51:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 689FE8E0002; Fri,  7 Nov 2025 11:51:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C6E58E0005; Fri,  7 Nov 2025 11:51:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4BB198E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 11:51:44 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0BD484BB47
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:51:44 +0000 (UTC)
X-FDA: 84084402528.06.81D7510
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf22.hostedemail.com (Postfix) with ESMTP id 356A1C000B
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:51:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VJjE1LIj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762534302; a=rsa-sha256;
	cv=none;
	b=trqISK1n4gciFxYePT+gFIarTj5zhSiohNss/ZBHtpEIFICNAmXRqg+yyo8QgoVU1J6sZ+
	HM096aQtCNJzCu298T1xy8u6ky9Mh1NGaH3DYyyVTuGrsKHAxTuVHlziZdyMKP2P/sg+7n
	wP8yRDzYHwQF7GPX8/aVNmpsUvZCnWY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VJjE1LIj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762534302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8AFkMVbver0dm/iOE6DY+637If9387AOkFxxxWHJIX0=;
	b=cXpNVmBy0Ak8O30b9/EgZIuZJPb6YE74H8oli2FZziXhWIzIpjG4v1yAiIkA9gQcpgx4p+
	egT4z80Pv6Vmy+Wv6xiUiUVHxA4rK70ZvJtRd8/l3tr3faW567GeTgeFOrK07mByCI7OWW
	KHnT/2VqHzc1yvIYxtiaTZzOYBhEGxA=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-77f67ba775aso1220926b3a.3
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 08:51:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762534301; x=1763139101; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8AFkMVbver0dm/iOE6DY+637If9387AOkFxxxWHJIX0=;
        b=VJjE1LIjiSa6fX1zWJExEMkDYakNu2r9dt7SG8EzXc7KsChmiuIwBHQHk0iaClZ+q6
         TzOzKdoSdKyoaJA0Wctd1jI5J2eTmUsgWoK19wbw5ZGBS54CNeaU4YWx3SuSQ/EJ9+RQ
         jJnCzIE0JhRebncBi+farMd31YocYTOzK0oJtDe6o6ZdjleTuEFNy8L4cJcZNDDT/tMt
         39MuvkAfWwokHCEV6KL2TTmBToWZsunosYjws8WSp/8MQxUwr+mcu+IntD34RWeOmkaA
         HMvbZIjOpC2eu1XtCDlnzpKH4BTcqkgv8GSogMAHHUKed3NrjXloyu2kM+RApwYI+75/
         tpnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762534301; x=1763139101;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8AFkMVbver0dm/iOE6DY+637If9387AOkFxxxWHJIX0=;
        b=CjPB6afonVkeogQeSFMeoiRsISX1JGVexAPUB9dsexkGXF0dGQLHkfA7brtbZiH3c9
         cgsqjy8g1F/quKOwa2XfpGLwvAHYTP3h9f2LBe+16/B0rRTQoObaeKRw+A1eBUgrwfHO
         0VMTVPPHXdCSkNsrI22Cwtidc8YeR51UK5u5TOumshV8BxhlZC1upyfuq6l5mUtaqqXX
         wVml3GamFDUlL3AzlyE+dGOsIJeS5plgql36KlCEKVktU+4tXlxlfWhjo8aXZAridloR
         XIJyAlLTITtbeKsfczOL36N9m8KJ7UesGV7r08lJboYL7axYONw3VJ0TYoO12jr+7Vg1
         YqKw==
X-Forwarded-Encrypted: i=1; AJvYcCXc/8tcnEwH5DZ3zMQtXnQF83/aQyn2KxPN4FIPxirxKPiAbXUIMV2P4EbOzOwIthyckPe4doc6TA==@kvack.org
X-Gm-Message-State: AOJu0YxAS1YfRPHDdPBkP/CW4vy4pLqiuFowKgyP+JIXzlulI7fnSkp9
	SFtzrguFhejgfPPVXyvxt8vTimNV+wO1M9Z5XcRqboH4tSeEzc9aWcxP
X-Gm-Gg: ASbGnctXnEFNFHai3RaJfJtJfvycaqakcBmF7XuHNZPF+owIxFqi72f09BnQBX632/J
	TEQHXqgLyWfoDHLP/lnJx26u9v1avvgvTEgyGHIbugldko1uLa0CW8FoUIQC6wM04nqI8eFItLe
	NQvM6snUXRjY3r3L64hw4fkjD8xmeqZ8kX/gasM9/d3Ux26k7XQXpbMnfhWj2OOTCIifeXP+Tcd
	fSVh30QUQ7jS1z8/PWKm9a6MORb6ULcWHL5KchXHjxtBIT338FlJlP19z7D/4FQbL+24nrBtBAZ
	u6Z46xgNlkF5topKJwD0921L6zXjp4+qPpJkJHS4CdMBViB5x1S1jQmQ24fzrnxR+cqLX4/KPR8
	yHmyH9uh1b0TFZHMPHpCQhIazNfb9GMxH/DK4Su0SOGy+Lif+bnyfevELLldrqMJKOFVEm3sjCH
	nXtPI9GGrER2d2Ujqr1d2Dw86afP9WWCE4OHOasq7XKis=
X-Google-Smtp-Source: AGHT+IEjgH81f9xZXDJ+ZCNw7+vkxCMp9mabCfJ6FR/hm1eQNTQUyGS8b/UpSimHVrrkBrWZ05u0Hg==
X-Received: by 2002:a17:90b:51c4:b0:340:c261:f9f0 with SMTP id 98e67ed59e1d1-3434c4eb054mr4745463a91.15.1762534300892;
        Fri, 07 Nov 2025 08:51:40 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34362f1f231sm936024a91.10.2025.11.07.08.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 08:51:40 -0800 (PST)
Date: Fri, 7 Nov 2025 08:51:38 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Huacai Chen <chenhuacai@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>, Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org, Linux-Arch <linux-arch@vger.kernel.org>,
	linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH Resend] mm: Refine __{pgd,p4d,pud,pmd,pte}_alloc_one_*()
 about HIGHMEM
Message-ID: <aQ4jmguL-dwKea-N@fedora>
References: <20251107095922.3106390-1-chenhuacai@loongson.cn>
 <0fbcde0d-4fed-4aa6-b0bf-c4400b9b1cf5@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fbcde0d-4fed-4aa6-b0bf-c4400b9b1cf5@app.fastmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 356A1C000B
X-Stat-Signature: nsz6s84irtnnbzxmdojmm5ordddrrimi
X-HE-Tag: 1762534301-765129
X-HE-Meta: U2FsdGVkX1/xg7M1EiCnFiAFfBhxv/zAjS67UPbDPrcQHMsj1JcskdAxJgRRxlqDIZUsf73kWeuW61AJL+qKyycX4qL4O9sc6cSdEGWKK5ht1ltoF/OqqOeJx+HyWqqiuPHitvhxUDngpXdABQcIQ6fwJMOMcZwrKq24DvlXVKGt8c27C4BGffgiWgIJLMkwLtl+G26k2AO1cBdfmPNznOddcs24KLvi4wpjTWlFG8mG+ettFPu7v8EJQ98rlc/sfzOkUA8cu5UxHgbh7Uuh86zLkt/Xzdh9B+mEN318egefiMqkYZecVViqPquZurqfm46ItbH73DGdGkbMO4PSgK68HZ9AgjU6lEZXJ4ZiyPFhkeGWe+HNM64kKOWlM6asOKmL7RHdlJBoIBD2UF1XCd2xYpUYnHM3WbS+UQN/JSTT2EqlikS8MkNJQsAeyBkAW0JxajD25F1u/5hg1CrJZ6ETfVTI8pJO7g7vfg9XWYsdLBh/V6aBnbllFiD9HLzk80bQiIu5KLY5103ef48kBGUnKiNlUd2PVxtKN2VJ6x4SfnkgxSOQrHSO8PuuQ3wg+9yR6ua862U4zB2P0t3j/JcIKZe9rgWxRScJ2UsSQTYlnKDrKnlAOA5X9fehPm3f1KZvkELDhoOQBtQkuD5belXfYLSJOI1XFgOa0vd62Tp+u7wk2buYtF91/qRkroCd4I0WTRDyx4ui2/cuNKFw4Wfo//dE0rBEcbMS4ThJE18P5jnpe4DelfsPDNlQ6hCEpPsCpNKy2ilrgzeqjTYIG2+9BUOpIev82b3BjNf+ZVmJOGQy8zF0JB0xPKT+WvVq+Gz2pvQgJBJKjIG9cmj0c3UnGVoz1bPAzXmVvg7edqcOMzS0I4uM4Bh+dXS0ea5JdL/Wtvqxd22a5MGMucdX+VAAsXA3iG5Q/n3QLJOHnn6xzGGwcA1lGhhPOCdTQlU9XBhEPIDzMXmtp2yVihO
 W8XCYyct
 t81UJ5A0x5x7bR7RTzkYdTtuXLwTbNBWW8zUmgQk0KYVMjthO076c14i4W8oLNgoq6Uro0rZ0uCmNidl5tXj5zL3K0XeWDbc4kKuGCSJoWeilxxZHYQVvOPa8JO9A2ui480s/CfoIhvywWsNIdX7KkR4NZ5YW6AY9h//ualZo92ZhaELPsK2skHOV9IxcDd6ysVcaKasYZTkfoSPh8XZ2omONfKTdLAEILIiP+WiHmoW976pGk2QGv+AuorWr/LZ3YRar5K1liq6x9fRApeiBXPagNHUITTZOoIiuvTDP0U0ar19BRrm+24e1UolE1Dmxk9ASljwpHuEbAMPmP/5eS6xlSzydgN8qOnM3ftCMQKiloJ4zR7RoIghF6y2NfD/5ZoWVagw5KHaGLbwbL4Ja2FKApSRi+P1hw0iR+uqfLVYPeRx1ND4u9ISy3wYvzIdfelZOH/hgC05HH+8Jl1fvee5jlpWhpiFu37zWxnW+uqbUyBHlSNvX5Hj8iL0AXhkM4AU0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc: Mike

On Fri, Nov 07, 2025 at 12:21:38PM +0100, Arnd Bergmann wrote:
> On Fri, Nov 7, 2025, at 10:59, Huacai Chen wrote:
> > __{pgd,p4d,pud,pmd,pte}_alloc_one_*() always allocate pages with GFP
> > flag GFP_PGTABLE_KERNEL/GFP_PGTABLE_USER. These two macros are defined
> > as follows:
> >
> >  #define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO)
> >  #define GFP_PGTABLE_USER	(GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)
> >
> > There is no __GFP_HIGHMEM in them, so we needn't to clear __GFP_HIGHMEM
> > explicitly.
> >
> > Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> > ---
> > Resend because the lines begin with # was eaten by git.
> 
> Thanks for your patch, this is an area I've also started
> looking at, with the intention to reduce the references
> to __GFO_HIGHMEM to the minimum we need for supporting the
> remaining platforms that need to use highmem somewhere.

Yay! Thanks for doing that, I like less highmem :)

> I'm not sure what the reason is for your patch, I assume
> this is meant purely as a cleanup, correct? Are you looking
> at a wider set of related cleanups, or did you just notice
> this one instance?
> 
> Note that for the moment, the 32-bit arm __pte_alloc_one() function
> still passes __GFP_HIGHMEM when CONFIG_HIGHPTE is set, though
> I would like to remove that code path. Unless we remove
> that at the same time, this should probably be explained in your
> patch description.

Skimming the functions, __pte_alloc_one_kernel() doesn't get passed in
a gfp, while __pte_alloc_one() does. IOW I __pte_alloc_one_kernel()
cares about architecture gfp, while the latter does care - so they are
2 very different cases.

Might be helpful to explain, although I don't think it matters much.

I've cc-ed Mike, he might have more useful opinions these functions.

