Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C54BCC6B39
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 15:16:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4657D6B0088; Thu, 15 Oct 2026 11:16:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43DB76B009D; Thu, 15 Oct 2026 11:16:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32BEE6B009E; Thu, 15 Oct 2026 11:16:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 023B46B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:16:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8FC02120A7F
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:16:01 +0000 (UTC)
X-FDA: 85325210922.12.719D71D
Received: from flow-a5-smtp.messagingengine.com (flow-a5-smtp.messagingengine.com [103.168.172.140])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6673020005
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:15:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=s-joshi.in header.s=fm1 header.b=UFTYFfoG;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=UFYxFynu;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of suhaas@s-joshi.in designates 103.168.172.140 as permitted sender) smtp.mailfrom=suhaas@s-joshi.in
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792077359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rwP/VSpgERuSmU7CAJ/qc9G4ynusNvA0TtZXr7xxgio=;
	b=MJrU2LuM6OtqnUrULofxgBqQU+XXVVri1/frFx8JibsMfP8NMXymz52m72cRDZRJUU4rck
	twDz8kb5N1gFhbcRW0+KaYZeKgcsv0DfrxK686RkXgpULu/l0wBv6VVbUJeN7YjOzGU4VC
	yagW5qTC638T2oGW34IMDPgoAogZB0A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=s-joshi.in header.s=fm1 header.b=UFTYFfoG;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=UFYxFynu;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of suhaas@s-joshi.in designates 103.168.172.140 as permitted sender) smtp.mailfrom=suhaas@s-joshi.in
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792077359;
	b=Yn3e+nCnm3fL3VTraJKEE6c5B0vZgtnaEuWztPlvEOEktGwfwRMa+Mi9stY+dXKz/Aql+d
	vOsKQBgR3hbzzWOrhJy2VLa5AWJBwiymmk1XqMmDMFtbiloH/zcwh5QuY0ZIyjE3bQJdZe
	8rCQFCCj20Rs6B2LjwxCJE1bM0JU9/E=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.phl.internal (Postfix) with ESMTP id C66D013800EA
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:15:58 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Thu, 15 Oct 2026 11:15:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=s-joshi.in; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1792077358; x=1792080958; bh=rwP/VSpgER
	uSmU7CAJ/qc9G4ynusNvA0TtZXr7xxgio=; b=UFTYFfoGhsTq8HiIpIXIpNZPm6
	7iA74E0cc8cA2Oj+QhqNCvF4FgW+iDBAw3s9cicX/vB2wMODmrZoeWBNT1iYzOPA
	WMTDLuw5VncYTEPnlWYi7YHOkuTgVbug+4iPJIQgTKryfSwXd3sTRQomQ8NXqTnF
	WFNKWF6sYeTs3fP72BHvtyHsnJ7dfe9nud2bkSrEsGbj9S8CEAPaNb3h88vivQ3m
	8y/4vE1zUCRBus5Ch+I5kpg6/Z+QE1sGUw3g1z9DB5TDlYI0cAUVCZM9Ukaz25dY
	AK7hMO7pTukGScpL3v/MAP+GnIn5PDpfKzDYY4vuQGFHOh/NbcbMaaN/V2yw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1792077358; x=1792080958; bh=rwP/VSpgERuSmU7CAJ/qc9G4ynusNvA0TtZ
	Xr7xxgio=; b=UFYxFynuS5VFEDgpEddigeyPZgsp3YlH2/EPWt8kF8H+mtJzeMp
	V5bNAl4mDNCk98UOmR+dbTa+UU0BwofacpEXfECrfeWf0DXafZkeeySWmRT1Y/VF
	c7/KUMRJ+rAaFQWI6/S+QVwPGIU1gCjQ/WbwH2ARxfxDuswpOoq28E6fEm0MTaaI
	1cDlUXXVz34/yQ/w8PgGna0uMEgFe/yuP951VvIWiNKS956zCZ++0/c+Ly51R7n6
	m3LbLQVsSU2IYLBl9k9P9h75MG2rXIfBYb+zhDaP7mHPJ9jkl4HTJdpPUf2BS7bv
	ijFINFebCHny/68yn3AHSa3Eo7JRmPNG8Kg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=s-joshi.in a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792077358; d=s-joshi.in;
	mf=PHN1aGFhc0BzLWpvc2hpLmluPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:xuYDA0l7S7dZ5vzEMGmgfKPuVFvW7/Syyp3cZKM7WneB4HL
	IwL8O5kxwm0dUm1PFNpU4p+3LIBP8Khf52OjXJXcsJYzCHx1ar3+zmBjA4VYQBnW
	orfoL4U/s3lu0NAAKY/UpZi30sIQxPi2Y4HhV5eIDuf4/t67th7OaFghOKXYpMEL
	pcDVd6v6lKbPph6Komd3jkrVfUAt3tCFrZMmUbH5R+r87vwN7Fy+ceeC34KC2ppc
	CrRcFZvh9JDRMxps16Cqtu6h+1TwDtgs+axtfVNQcp1eUI4osm/NBgeYgSlh3GwQ
	oTMYUsdnPFw7T0pyQpDYFLkiKC6MM+a7JCE4x7g==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:LevM5tzYYaumburSvV64b0N1TAhZSGBxVKsiouv4ydQ=:dyEcVD1Y3vcGMbvRYZPMcBuG39NEenS/76iBFF46FXI=;
X-ME-Sender: <xms:Lu7QahPSbuoSEa55WNF0bRmYpBOR56OACjbIEWk3JNCTKXr8S0dUHg>
    <xme:Lu7QatTzXWkm548AYtQ7k520gnsMpGDOvcTx_I_QcLOtHaNftYaxBmwakPDW73-u9
    BEyGgAvDIBt2WxZn4iiNtafI9vClk7WhgFP6Bgh1sDyWgIHAaDhUjQj>
X-ME-Received: <xmr:Lu7QangY90ueWEFwxkeM7vD86KwGJvyb3mjSEBJtLDvDuvktgtHGf6KFCg>
X-ME-Proxy-Cause: dmFkZTEV6GHuCH6/QILcFaKhduef3gBBREJE1psiKhqNhihAbWJpVZhLJ+hjcHxwMmFgu1
    1ywxKhp44j4XcoW/5YOxKZnHloAZ6M8EZwTLdraBuWX2IMO5Y6TSrd6AfBpXSCzQKx0D20
    mwzR80Oay3a5lk+she7Gco8OasTS0vQFqoFCydIfg8lChTL3uvKIEoEIPz1LUoznhNFGPi
    euXxgmiGPs/xOF9xmJXkNWGmwuXMXr6Jl1lUTmw1dSQTE0IhQhP4dm2absUAt/BJ8VMv+G
    drJAHy/HDfSKXmi6mvi/gRtLW+8vgafJVm7rABfv1x4e7cGTnMUk/dq+zXc75QDcbOS1Mr
    o3pOAy7W9oVK+dD+zGy9o7hKIHamLw4WlZLV+O9MMoVwW9+QQ0Evih45zy4quxiSBKObu+
    FuXs/cmZyu0fhmOTivf/u6OOA0Q0g/ZkmOhspMMwstiZUcMc29sU9OMnZlKn+l5UkiQaIi
    27bQ6K0rcuO0QbDmGHGDZiGg/iCM96A1d04T5LS9lXXuflz5/V1u3EeVLdyCXR1KxZTgNX
    dJ/2e4O2SFGRnXxfBxagMFtS/9USPCQGXjM22CKQ9IkJakcNVYld+tfBESGTw+b3sPCLyb
    rTnrQD0L6pRndK3SbZnuEGyiA3aRAsIZ7CqPryk2YBmZA4vMrZLXABubd8eQ
X-ME-Proxy: <xmx:Lu7Qau9ZAYYCGJwm5unJr0RsqICmZMM7FkyyszqFnXcKdVGHfSpBWQ>
    <xmx:Lu7QamF7vH0XnEWYj2C3XXfw34gVVfP5ie2vK5e4F8amLVaUxX-56Q>
    <xmx:Lu7QapmyU7qgp08NfXPvci4TUSvinip5aAploGIzhkXltUA9-mVpHA>
    <xmx:Lu7QaiZdaMYjNtNKqYUbs0njf4nW1nVERxBWBaavg-O-4LriBmrdig>
    <xmx:Lu7Qasn1_OxzwpJGarX3m-fKGxT_WOlJ-T9a131aPlVJUMF60VIS7-Mn>
Feedback-ID: ia9504abf:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Oct 2026 11:15:56 -0400 (EDT)
Date: Thu, 15 Oct 2026 20:45:48 +0530
From: Suhaas Joshi <suhaas@s-joshi.in>
To: SJ Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, aethernet65535@gmail.com
Subject: Re: [PATCH v4 0/2] mm/damon/core: Iterate over installed probes
 instead of DAMON_MAX_PROBES
Message-ID: <atDtNpEiy96Lbna7@fedora>
References: <20261015135533.18761-1-suhaas@s-joshi.in>
 <20261015142933.105760-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015142933.105760-1-sj@kernel.org>
X-Stat-Signature: m3tt9crtxghenedm1j65zmm7k659urf5
X-Rspam-User: 
X-Rspamd-Queue-Id: 6673020005
X-Rspamd-Server: rspam08
X-HE-Tag: 1792077359-81439
X-HE-Meta: U2FsdGVkX1+zehtQSB5wpTRdo7mOxT5kVdadAr2WhFr3KXSY1icd5Vs6I4v8EsvdZzAybY65yHoFplXABO28wHgT2v29+C/qogvv898B1WdGpqbfc06Rc/S+RjHy01H+XgEEpcopbuQa6sxz9m0GnJ7SEtzEySS84XY/LBWJ3S497o9DHtlZIpp8chNEuhilWaxoce2gD7T/Hb9v5UunSEA8mKeXYWfB5Sg/9kw5snv+2xfQmXPBZU8VpG3K2oY5yDVZjkoT+yhC0+DCB66/YyzPVWVeafHm19aWBvXrlRZ/YE95DdS+dQI0Rrn2nulgDGnUrRPLajjBa+TWL8Lv+xWB3yLoIBqThXQTpIOi222V3Mew6aZqVrtlwdjORjvVn9InlMFYC1guX3fyIhwK0Lojf8Knn9AFPQB+3btIPzaGcTmppSzOqATi7z6VpTbQ6K4ld27W8BlxKzcflopYbhlmGF1Una/ETLARc2OrZ5d8P/DPl5Rary/aG1YVjc2A+xPfK6u7KOwaAqoVgsU9HDqbyFEQVoInaTUSsoxh5tmrONCHcwKL+jt758ei884xpMWTalUjiyEDW6ABJZhzgSWJrvmTgieFE6mfaIp9J55iZwkuXEnr2dEnci5fToF0ssU9/UZk9h3a9z7OaVfFhSQCOn+Yd6tdwGn8Ld+72b5PSWRLIFGVOMgVqoVE3m4X5SEtSxuRDXwgqmFWDh2FPAUsk1OuZakmYL8e5tD47unGeUoNU7ptvdTsHBJRdRizVwF42qZQbyF0i9FByrAqmTksAs+d9NHFLKKY/b/m8iWKYqJI+hrQRktEvc2978+oZDr+iH7c+niNCRV78lI68eoZF1YcI33rJv66Ftf0spEPR5xDM5037Y/stce6S0PBo4DnGJo1STzHzpNs1QEVK5Agh2/UrDNZLJ7A+mXW1vzgvQkqxBmTMEFKvqoev89bySFztJU8rdcTt6MFLdy
 Dr4i8xzK
 QB3AGfrZ2xnV3pM9YGL/iCHMETitHt7HDmguRgyZYygn9QojWS3yf9K7R6bO6VmDyi0r55trFqTjzf6zobS3CffJFbCtwmrqE1q9/8yoBSnYHRLcnw4zqasNyFykaCXQjchwFrdRZReMAA+ovV/OC8cPwyvrRh1PwgolpsLydEKCj2zyZcRxJ5emoN7E8SUr26gDrR3Fhrl4zUYqKE1GjcDWoDClKqNIdIvnS/vr/8ftRo2OrZ7VCnRI3cm5jC6SAjuVhSzu3/8W2kxweAwYN7a4V8Pebm8hPFJSrFnzmnhz2ZPJHclzQW/tHoBP8KYm5cRBY00p8pK+0RIR/iAQ5HQpJhL2uynfGTRp+CJdjqKJYY3L/7IPfn9xzdhAcJ7L06bEulFLKjAkYrLzhp9DAjebHm+VZrRxT9t986lwNmpbK1y/o8Irt3EEM7OYrOOU4CXKfBANPttxp6hKVDguW9iUt10cPhANXZ0tmtvIILvsVJZnHzZGlv1+Cqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 07:29:32AM -0700, SJ Park wrote:
> On Thu, 15 Oct 2026 19:25:23 +0530 Suhaas Joshi <suhaas@s-joshi.in> wrote:
> 
> > Hello,
> > 
> > This is v4 of a series I sent earlier. Please find changelog below.
> > 
> > There were two "todo: " items of the same nature in mm/damon/core.c. Both
> > of these suggested that we should iterate over only installed probes while
> > updating (last_)probe_hits[] during merging/splitting regions, instead of
> > iterating over the entire array, which may have empty/unused indices.
> > 
> > So this patch series does exactly that. It replaces the for-loop over
> > [0, DAMON_MAX_PROBES) with a damon_for_each_probe() over the probe list of
> > the context.
> 
> Looks good to me, thank you.
> 
> I applied  this series to damon/next [1] tree.  We are now quite close to next
> merge window.  It may better to focus on making mm.git more stabilized and
> therefore ready for the next merge window, rather than adding more changes that
> are not really urgent.  I understand this series is not really urgent.  Hence,
> Andrew might not add this patch until next -rc1 release.  In the case, I will
> request adding this to mm.git after next -rc1 release.  So, no action from your
> side is needed for now.  Let me know if you think this is really  urgent.

No, its not urgent at all. We can wait until after -rc1 indeed.

Thanks a lot to you and Liew for the reviews! :)

Regards
Suhaas
> 
> [1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees
> 
> 
> Thanks,
> SJ
> 
> [...]

