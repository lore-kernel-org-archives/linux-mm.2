Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DCD4EFB7EF
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 03:45:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A92C6B0088; Mon, 23 Feb 2026 22:45:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 053DE6B0089; Mon, 23 Feb 2026 22:45:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED9346B008A; Mon, 23 Feb 2026 22:45:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D96DA6B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:45:09 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7F38313AC32
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 03:45:09 +0000 (UTC)
X-FDA: 84477959538.19.3B4103F
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7C9CA4000A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 03:45:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jskFiFxJ;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771904707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dfADPFZ5b5+KYGLXHfYdl3aSHWOw4Q0Vh6QI/ryWp6Y=;
	b=kwWz75PsrIZwE5u6+69gTTZ3RFTCWLj7NuHN5FzjvHQfWNASU8Z5tJOIiJFvVhorrBXMT0
	ue53VKJFLLg6mLAzbdyr7xhQI7k1sZ1cwosjLRGYdHhWkrHuEDGnWK63TczLt4A6aZrbMv
	7Qlls0SEzo7WAbQSadDkh1yrs3KxXmo=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jskFiFxJ;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771904707; a=rsa-sha256;
	cv=pass;
	b=nCSG1X87yE469AT8z/8AQ/spc0O3/0jfYogfgZYMMI+lU/+bdM844AMVfEaUyvH+L5a5hS
	fxQ962ehfYQ37dapEj8s0jCgUyqoimnVxPa0m1JSkF9TcPTgF2jAgRGlEqSkh33LEtuCWr
	xCaUv2QPhwXDPbloVP7nVlfasRBmxrY=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-65b9d8d6b7dso7150642a12.2
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:45:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771904706; cv=none;
        d=google.com; s=arc-20240605;
        b=Ts8JEWdx7fReBEVe2BHoioauo3I98INfnxyJ1VjhCRlafusmwH6YYsuat18YPRRfLB
         J6czsD/05rwKk3daHdimSECfIDGgZDQBOTGR+uQMlXQtyoGd+J30j3f4V1AiKXLXWYZw
         zo2Fa7YtJeOcw+7LULR4sh+CiSVx/vY/m3kODVmI10hm7KzljxNmgH8Cx/4kqJ5KBwjB
         TTuy6LcreAzz4DNvJH59BSIXXkLIjDx1LYs6Uu9nVcGz9qIxVrMC/PQp/bb4m6hxfrcf
         u76l64+hmTTBFaA1iI2sQJjhaehofFu+qSjLA08wygF1vmFBMzKXO4ginfy9UEHopEjn
         leHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dfADPFZ5b5+KYGLXHfYdl3aSHWOw4Q0Vh6QI/ryWp6Y=;
        fh=ZmrUzbDuu33WWXAQqH31OSLC8lPep5GI2eavOTcKJwM=;
        b=Dnsb1VLx7F0tbDhSwuRHWq96Wu3LS5JLDcmtiKTgjEG78XIQj87shqh+mjzJzMG1Vl
         CJtWLkTfDc9AZsAtYQPIVorUO7ActCeKQfI3bsGKriRivZNitGWCdhYfN/kquAY5bvNg
         2Co7qbxZxqnD6/KqnUO1nGHo/x77/K0SHCWmCZxZyOmMOrkz5A1kT7GFyaQBSWW5xje7
         AxQsIXQAaV1boXXD9TTswzW8tf108DQbZxpfWl/2i4xARjw0kcpf8U4SfyvNiUMOkkGu
         XdkTwjna1Qfior8HMwA6E8QjnBh/pSsgyzs7BrOgbmRyPiH9kiuCI7uOJpJcU8nwFklB
         CU7Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771904706; x=1772509506; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dfADPFZ5b5+KYGLXHfYdl3aSHWOw4Q0Vh6QI/ryWp6Y=;
        b=jskFiFxJdEhp261TtV1//O7A1hW/CSAk6qQGKE3kgVg3IiSnI4TIB69FHyUbJa2Zz8
         +X/cbA6mhLSnr1fvmdRVccgr+XjZqgULxp6F5uf6rQ73tIOlxUaSD7bQ3cLbgiPqK8n3
         jsYYpMteFiBggXLegbmBFIrIjkwn8vPvMjBZ3FoJY5XW+jXvEo0vDip/t2KoXS1vQhRI
         KU+00vgI1/KyjtsmkgFh59parRVG5Do4ish8CouCd/EVMsM6inJTtMbi6CSmRC9gqg6V
         I6t3OHV0+7fdasEVLDuehmToBaj/x8Su6EPKn6BWRBqUNX/fFTIHLDeB6HlFqhehe7mg
         7sow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771904706; x=1772509506;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dfADPFZ5b5+KYGLXHfYdl3aSHWOw4Q0Vh6QI/ryWp6Y=;
        b=NMm9wRz1usgjPIe3QYreJ6HniZkWf6bMWrvFLoSPyfhcn7nsfwAxfrfsHQduMvPVH1
         6qPkKQnKHcLzsLCvyvCiCMiZuDYmocPiBL0uvtDeOLMfYy+3iwKH8eOtbwtIy/Xi6MZ/
         ZIMyMRzLdEDzQM435k5xY3vu7tH2d4yOKBXqHIWYycsh1N58FDE+H7AgWunOxNqgB7E6
         oOAImgSUD00E0LejfjKtPPxnaERUr2jizrghrEh/m+gzKljntC8rmbZJ7eUauBfPTViw
         0lHSJgi4HDme9PWJszY7AarBH4wT91YMnC2vo0IFrC6Qr1+7/86KB3qKlqQwU4sTJTcK
         PeEg==
X-Forwarded-Encrypted: i=1; AJvYcCVF/CZT2RklXz2sBXk69h8N9gYSoCDY935Bkl8B17gvi8oIHOarbj4sFPlp/6XBFMJeMzxZE9JlqQ==@kvack.org
X-Gm-Message-State: AOJu0Yx4DLGdRa1XwiaMwKkeKQUqmS3zO8o6YPP6Xnw7f/X0le1PQZ/V
	p3CW3eo7nD0S1a1VrxbByqll+JXlp83fadQcRLwwhoWWewkJ4qRp2KZAb3w+IOv0/w+sIG8ZYfT
	wtznlS9fozcDqSDw2WIbQ47hdAn6KWas=
X-Gm-Gg: AZuq6aLQaW/gx48+hH0eVyUzdIrc7MfosOSY7yu4BgiKlJeZnuoYGth+gTN8VHYG0g8
	t26rCr654xJm5RQGVxpG3gmbZjcT8DbTLv0HayeyhCYyKJaMipv6qWLwSuibbZzAM0MVMAqMGqB
	eG4ACSr9kQm9TYqBnQTThWENBe0qtOIwbIBJqQcwMgP7wAWpeFNTKN1j0+8Yp9BuWtY9hpSeSkJ
	e2XEgKYkG6Qefz1cvBdrslT0jSU7oiFtk4U5Wh+tVoLMIneAvXjO0rjTPNrovVZgPk3w43dsXbv
	J6mN6704Mb76qCZuKhbRR0Gx5HcD3CaZB2Nbh6oQ
X-Received: by 2002:a17:907:5cd:b0:b86:f999:15ba with SMTP id
 a640c23a62f3a-b90819bf271mr691458466b.18.1771904705511; Mon, 23 Feb 2026
 19:45:05 -0800 (PST)
MIME-Version: 1.0
References: <CAMgjq7CCcsh2twG-Ud2b4U0hZrAMV8zmvLaM=NBDvmoaWziPqg@mail.gmail.com>
 <CAKEwX=O4ishgvhhZ1ssgbDUQewFamkyFT-uCpEWecWfe8SzwGg@mail.gmail.com> <CAO9r8zOZYuQWmEvSPSmBs6gz3HEWi1-MJZ0=xxV2GkQVRpMMkg@mail.gmail.com>
In-Reply-To: <CAO9r8zOZYuQWmEvSPSmBs6gz3HEWi1-MJZ0=xxV2GkQVRpMMkg@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 24 Feb 2026 11:44:29 +0800
X-Gm-Features: AaiRm53OyQqeexQqNlhOlhsm30QWkdsWCwsnTCjllZxDnHQQ5CWm3htGqwsYvFA
Message-ID: <CAMgjq7DtwCkEASOpPxtgehiz1jzQY-vFpNvOpPMuPNt7U1sQng@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Swap status and roadmap discussion
To: Yosry Ahmed <yosry@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, lsf-pc@lists.linux-foundation.org, 
	Chris Li <chrisl@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Barry Song <21cnbao@gmail.com>, Baoquan He <bhe@redhat.com>, linux-mm <linux-mm@kvack.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 7C9CA4000A
X-Rspamd-Server: rspam02
X-Stat-Signature: bmaxe79p5uipugu9nuybq6koazpbhurt
X-HE-Tag: 1771904707-830728
X-HE-Meta: U2FsdGVkX18Tbyl3KFz25sHBe3X6aUt2lR1AztOssT8Aw6Eo0gn4rdoyDDNcAAcGGQp+/TodB0qAAn7bU7i8MXnabg/hC4JXm+foV/dwFthLeR5xFi66gyubbh354oc1KXnnIavSswiJUS22igtmfsXzX0hu/sa+27he6lIB7zqpSRY0BMePMqWuXCfcZ7AKCC5J8GcPuGJXvr40HJRUA6/sx8213cHuyKgehDd7snXH7plmIvv0levKPWeICT75Sk/wG5XrRN29cG7gJfUeIbgYRxbZGS6qQJExA35JOLTaQ9g5kZum5+6gzrueeJWML3eLJ+Bp2Y3fMp97fQ2Fi2bxIumN6uaB+oZJLLdhFyMa9+lIIjTkh7PUU+kfZRI1S6rJ1SWO9JZanDTkRMhzue2swKK5kLJocc4MzZptGvnzLD7aPTQ1UwY6NpKG1M0JdNXcYXYEFqkqTBbQCRiJrslNMtSdY0bkGAlzXUff2Ly1aQCFeLkpFiKH1jN4Lg/etaRxZ9KjtsjvXPmu/Vd0CLX9vPCZhhcJ8itBmV0L3ZgKl27qT70+jurcHqr4pGW5fSkLHbCalWFHwfJythC94CHLqFVX5Tg/sCd/pdZeMN7+B4HUhVVKkNaBZDjYp0oA75mk6bApD7gf/jbZjf8x3J1bg1T/Ttviiy6v3r/dffM1W817BpkAZYAiwOrpFC/6h/EA79wgdRUMxrZsDM8pPQZojeAbEwfjbF1QByjB+kGGPr5c0I2LeSoNQd/aB9tbsnfqh3yC4KWSV2BY3xenY7+s1xjA3wplOKPyRujmNECoJ+axqxiGtQ7PE/8BLgHB27W/9jnnGQoJpLWicBrVS6+6JoI6S5ZBUcPFWBi0aad00w11lN9lUU4jNCHFjBXhIRjKci+4Xg637SINCeJBw93CSYDamkBAdv8cjoyrIFFLAQLa+S0CQr02jnghS1vkAIBT/PKUmYiAYKQrdql
 RM39sRBg
 Uuop/YnRgh1m+4ZvRqdidq0fVmWxG0RxoXYyIZCYX2nQSYpnTb0sFRHMFRBlgWQ7lXoyhKDHNzTWDUy7mQCNgMwC45lC2TmqY09uwwo6JCynY2hb4qcSNCc/ntdukyYvTO0OnNgb3eccFYpg1ZOHCZNoJzTgDgZuuDQD6cllHrhigj6X7flt/GGFTDJUbFdMid/QwUSUQDP/tR6KrtQUlslO32atGDQYxtdZN6NfTVa36cnchUkQd38C+mkN1fXS7ACYUDAGRkh+HITZ12lCFJejSjWPesGMbjm0WGyeCXqR98CUwOIdogilGLw3c6J18qUJH6/siivbPtGN1/QK7HdWTM53hxQDrjFo7tqEXZEdCz913F1zSBzRvVGi/SDeQ6faZ5uDZgaPr8mv6P74AL9uLw+V52VzWYwhPy5LC/p58qq5QCctQ3EolsgojcbG5aooy/W9C+M6qTfnt8AnXJ8nLjjMYtQ6NOGtYRHQ/PI2TychLXgKfrqm3LEFGgzB6x+XT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 2:55=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> > > - Is 64 bits really needed for reverse mapping? For the context, reve=
rse
> > >   mapping here is a swap entry recorded in a lower / physical device
> > >   pointing to the ghost / virtual device.
> >
> > I think you can compact this a bit. Swap space itself is not fully 64
> > bits right?
> >
> > Just not sure if the juice is worth the squeeze to save a couple of
> > bits here and there, especially if the reverse mapping is already
> > dynamic :)
>

Hi, thanks for the comment.

> I think we should actually revisit the need for a reverse mapping to
> begin with. For swapoff, we can probably scan the virtual swap space
> looking for entries that belong to the backend being swapped off. Not
> as efficient as a reverse map, but still better than the status quo of
> scanning page tables. I don't think optimizing for swapoff is worth
> the consistent overhead.

Right, I don't really think swapoff is worth that much effort too. But
there are still ideas like migration and compaction, which could
really make use of a proper reverse map.

>
> The other use cases are probably cluster readahead and swapcache-only
> reclaim, and I think both of these can also be revisited.

Agree, readahead and swap cache reclaim do need some revisit... Not
related to the revert map idea though.

I'm thinking if we can make the swap cache completely lazy and never
reclaim it proactively for non-RAM swap. And for RAM based swap
(zswap / ZRAM), do the opposite, always ensure swap cache is
reclaimed after use.

