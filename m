Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA366EEB577
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 01:22:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 264FA6B0005; Wed, 31 Dec 2025 20:22:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2116E6B0089; Wed, 31 Dec 2025 20:22:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 115456B008A; Wed, 31 Dec 2025 20:22:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F27136B0005
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 20:22:18 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 79EA01A11A6
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 01:22:18 +0000 (UTC)
X-FDA: 84281644356.06.235A941
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id 98210100004
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 01:22:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HsCQUBJw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767230536; a=rsa-sha256;
	cv=none;
	b=tCPBhI8Y4oMtglcKMPN7acC1Dyz6vMJUYx80LkoefQOCv2bNozvka7FtkWBsnn8nM2O9sa
	2Lpc2K63LBkcG7Jjf8bYC+0koFgz2p01axBhYF8+3k/2vBpwG8r6mpFJCn5fVI4scMC7Ee
	ct4ICm8hWN/lN5yKXrxdJjJAORSW6Lo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HsCQUBJw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767230536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RQOdNx1mSguhKTRvTy27tgDNO5v6Rp2RNeV+ObddlJE=;
	b=3BTu72J5faZT2JOH7suWXn1pj8C9qAv6r93l+3nDnQDaaWrZP02K1ibIoe56qp0zWLBdpr
	jj6Yai/50jCoLrLMv47V8BEQnhUlSAt1Z/ng+E8ZhnCj7zdHia5mvg6mjfDkk6+nYYoU1g
	W1btQV+xLfsh5+Fz5I3GpBUg1YKCRC0=
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-644715aad1aso12978508d50.0
        for <linux-mm@kvack.org>; Wed, 31 Dec 2025 17:22:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767230536; x=1767835336; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RQOdNx1mSguhKTRvTy27tgDNO5v6Rp2RNeV+ObddlJE=;
        b=HsCQUBJwcDzzCQhrEpZ5F28vcygw9W/pv3eJL/2RUJxU+XdiIDHmIaIyIF7KtxwuHY
         8gjaXfb4UtzsV4Wtux+QqIb3pVAPzVCltq5/uOR1GpGBgEqvw15YDXnu/2LAqpaq4/8U
         rwuGQiPCXpI9+gpRf65AXpmZH2a2y/2tWheUyEaMApGeqTY+w630vzR+tSM7cVNPnRKU
         kCfsvLm43/LpTnHm8jIyfC6gPor59/xTLRK2G3RfouhnWBcrjZxfqKII1IRlRM7+pOau
         R7ouZLy5QJc9ZXE8r3PBqTmBJpH5/TGNVkV5OxADv0NhBSy2DVtNVbPIhTPEIRXvGyWH
         /HcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767230536; x=1767835336;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RQOdNx1mSguhKTRvTy27tgDNO5v6Rp2RNeV+ObddlJE=;
        b=Y5swCHi9QkHdBxhGQH/KS2i7AwHYcZ2/399Ar+1dhg/3yCLBad3kJk+PupBn0s1oV0
         Q+tmht2Tv3gw3DeIsI9em449ZtgRetp14p0rUgPUkznSDDZqqityGiWw5tngeXtjqBj9
         815NggpVbYqIC/LA9gQuYKv+X7+/lK2SPSbl/hKtI4RuoUH6zXjtd4Pmq9mPNw72ejjt
         dmflrXViChIdMrKMCyYcfaA8ZWtD7CzrRIYSkYOBooefh/FNgxoHm4o9IfHWMMSX8gK8
         OWuxV6X0QdrFkD08nHQBwKuRNzUqRMkMGSroJYeUUoDgOhFrczA3Gn8QF4YVGl/MCDFE
         P2Sg==
X-Forwarded-Encrypted: i=1; AJvYcCWm1hNI+gVlTfi+oOSa2YpOTCSEk7JqUESIuXiHgyEgNHj22+c1CF8e78xteRGkx/ylGuiCTi30Jw==@kvack.org
X-Gm-Message-State: AOJu0YxOwlXFYNc8baYn+rDb0ziiqA7mYyiR20fqpqfACyPSKVEMkznJ
	ai1QAY+9ACOEOhfF1kdWpE2jGICmB3D0rNvBPUI5mDqHzvuhMe0b+Hv7ysOUYoV33TueO63Sbwu
	u5alHo2B2/x8EYcvxeGG2Lk1BRm2aS2I=
X-Gm-Gg: AY/fxX4KSCeIjYPwRZ6PF3qouMKcWYjWy/rGpvhWbzU9Hepg9WSH1syCEmZN/KZqRjB
	6aY3g4BOT1CL6xBsgYNC1OCSWwkIFysWB5sKuyksJyBEacqEdJdAzCwUWy3p0F7VJcpmsoojyEM
	6ZXKI0TRSW1CJIJEuh3EEqYLS6uhSOg+1Px8SWRX1bPmlP4UsQHVkKONNGAiTe4B9M452NCI/5d
	BJeCrq0byjCPgeLHbqKLOhnBk+o1LFUvIqcVdGZGDLQhZa0kK+JqED9ApKwtdyPAxLcILoS
X-Google-Smtp-Source: AGHT+IF7ZajupyJjQoLfH8qqmN3ySL+FWmQGBP39A4phKP+l1pLEwwJhnDzjVj5FiIaT2KDPsQ+lupx3dsEKY9sSZjE=
X-Received: by 2002:a05:690e:11c6:b0:641:f5bc:692a with SMTP id
 956f58d0204a3-646632c32fbmr34527753d50.35.1767230535662; Wed, 31 Dec 2025
 17:22:15 -0800 (PST)
MIME-Version: 1.0
References: <CAHOvCC6RwVzujJcuosiignDEQoe038eRJHuJVLEtJ4-qP8Ot9w@mail.gmail.com>
 <20251231152931.82221-1-sj@kernel.org>
In-Reply-To: <20251231152931.82221-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Thu, 1 Jan 2026 10:22:04 +0900
X-Gm-Features: AQt7F2qhPoI7ln7WyMGehJD_RyHX25rNZn4_5PnbevoAL3lkM0FHo51O7_FvLR4
Message-ID: <CAHOvCC6BUnJhu4xpm5xtr2ErHWkzu9BPbMJ_gy0VtCAkFOPvKA@mail.gmail.com>
Subject: Re: [PATCH] mm/damon/core: modified control->repeat loop at the kdamond_call()
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, rgbi3307@nate.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 98210100004
X-Rspamd-Server: rspam03
X-Stat-Signature: qpmkyrw33euaguahrtc97z8o7h4c3yf8
X-Rspam-User: 
X-HE-Tag: 1767230536-822634
X-HE-Meta: U2FsdGVkX1+OevXKipjW/vMaX928kabl/gykW97OLs69JnJfOhh1sfkHHLSbK3sD/uOwmkwreU3/WapimK4CO+CNYCDA4QijL2U47BS4hhMh9ZzJdhXINObskFRYo8SMrgkHr6p2koU09+6n3UZ8FOuNknpfd6vRdElQCsbiUlp8kADKNMHFXcV8GWaRY29cfxBJpf+ENy1UtxOP0FKAZZQvt3YVrQQ2h16/XDc65oWKrvQQktY3V+QyFTU1LkLTnTabFZGsybtQCH2s8D6cKL87qjHzF9alQk3W3/Q8avS8zlaQ3O6HzJhvPbw8S8UDIgcpaOvNskJekxxrkoaiKyVlDXX5f8DcTGVmpb3O5oI62zMvHibGJFW3uahqrQncZEG8VV/Kikxqfi97C5myH4wbnZRt6cVrz5nCaitzbXtf+sfnEugCxByx7CSmiEBQZ1MdK2f5xkgsySLcm+VQml0/5HDIyjcg2qkirVLpiBNBW8ldRX3O6+bSmbN/g4dd0ej+rHP9OGCNshg3iM8moks2Tiqa7R0F8NTiXv0dHmnR0UHBOK5oGyc9KLPGVB4/EA3l7hUHKUlRGsvamgPKgVKAf5U1j/Xy+iVIo4E86QXT84KJasfErwIoMojL2L+Y6iMJprJyuYHSNb7lJcrhay5z6xLsqsi2bsGkmdLN/EQtR7o8PFzwzJso16M5iWS8DIqoFnXwydZbv78W8u3q5F0SZabZesE8qJTUERvPxpMrYpHsj1bRVOq83z+hudKjPiPJpExwYDNmF1IHp5Cqeikhih6fiZJ+bNI0U4m6PKpsQJ5o8Nq2H52u1WMmJuM5u89e4nY4gt+uDqSu+icaQKd0ikzz6VeNxA+De8/4iwVNfXWOrY/8bwSL/Wv04FtyRSAnxrQNYlNGyoHwHMO+YNM0uksNc2IO1WqdBun8Zsv45w22zsuh6UdqKreGH5822dHv2qqW6pi+qu26AaV
 MeWlX1Xs
 +m8KwJciVaIN4p4Sexwzlvf0hd9GQA4kiH0VddAqUuhBYiKnFcdpHOk182QK6QGi9ym+Zum1OmgmH6LTPjMyYGjEcOccioCedoOCUq4X0yEbbBUuwF+YTBZvjgrVMhDCkHG5PBYPiPc4rgjxb6wADNktg1s+Wc0MJCrApAzE7qznYyMYiC1VVI6fkfI88QOhvxqfeZQcAyxyyNuItoGE1Qs18rmjlTVyx9C+kaL99cFr9+kL6QMH4Ifa2nbsRUIyjDZRVeA9RuP+ILdAKQVIzZ+TWA4+hwKW0QmUVP1mrpHnETTFQwOXQCXqyJ47pWG1SZjIfS59ZBbF5NEQ3VARYvvjPprJhm4duIE/T5ocM5oRN5WNH6lbnBFLHAMOUinbJZCmP7qHvoxPWOY9hkE/aTNVbDqgD51AeUfDZ1CvTZ+QKzvQv7OKC5PzUKModt+jfSsek
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 1 Jan 2026 at 00:29, SeongJae Park <sj@kernel.org> wrote:
>
> On Wed, 31 Dec 2025 15:23:49 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
>
> > On Wed, 31 Dec 2025 at 10:28, SeongJae Park <sj@kernel.org> wrote:
> > >
> > > On Mon, 29 Dec 2025 16:57:15 -0800 SeongJae Park <sj@kernel.org> wrote:
> > >
> > > > On Tue, 30 Dec 2025 09:14:37 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > > >
> > > > > I will reflect the above in patch v2.
> > > > > Would you like me to resend patch v2 ?
> > > >
> > > > I just found my fix [1] of the bug that you reported has a race condition.  And
> > > > to fix that, I think kdamond_call() will anyway need to be modified.  I will
> > > > shortly send more details as a reply to the fix [1].  Can you please hold this
> > > > refactoring until all discussions about the bug fix is done?  Sorry for your
> > > > inconvenience.
> > > >
> > > > [1] https://lore.kernel.org/20251228183105.289441-1-sj@kernel.org
> > >
> > > I ended up sending the new version of the fix [1] without changes on
> > > kdamond_call().  Unless you have concerns on the fix, please feel free to
> > > proceed to v2 of this patch.  Thank you for patiently waiting.
> > >
> > > [1] https://lore.kernel.org/20251231012315.75835-1-sj@kernel.org
> >
> > My patch for the kdamond_call() function further improves control->list
> > to behave as a FIFO.  This also improves stability against the control->list
> > collision issue encountered when damon_call() is called.
> > If there are no further objections, I'll send you Patch v2.
>
> If you want to say something about damon_call() uaf issue, let's make a
> conclusion about it first, rather than mixing topics.

I agree.
I hope you first resolve the damon_call() issue, and then move on to v2
for kdamond_call(), which I patched.  That would be clearer and less
confusing.

Thanks,
JaeJoon

>
>
> Thanks,
> SJ
>
> [...]

