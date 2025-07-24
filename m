Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2AB8C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 14:46:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84FA98E008B; Thu, 24 Jul 2025 10:46:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 825E98E007C; Thu, 24 Jul 2025 10:46:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 715778E008B; Thu, 24 Jul 2025 10:46:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 638198E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:46:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1A1A9B973C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:46:01 +0000 (UTC)
X-FDA: 83699432922.29.BEA01F9
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf06.hostedemail.com (Postfix) with ESMTP id 31F1C18000B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:45:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oOFxu4GS;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of jannh@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753368359; a=rsa-sha256;
	cv=none;
	b=wl3m6OMmI1p5OOeEgqNyqI83EEQoQg09ejPk2kw1sn+yHLshhjrJK+yedaMdTogU85oOWM
	sgETPJl3Pdf2XXTbeomObVKF4R1qCPOTXTdsNA4Q1rzMO6jIPFDoPaJViG0HbLzzE02/18
	8ztis7uLPdvCfQ8ARz9w2BauQ7VNALo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oOFxu4GS;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of jannh@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753368359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t9HVJHe+iSRcfFZNFsoaQkuhmI2iPruXvW/Fad+gwuo=;
	b=vgwjCLu1GJMcc9zLy8nfDnCrEjiqj6YJdgY74Oj6WTa/LA/Hcjsk7rpd/YdOCE0X1w8Yb7
	3h41v4zzslfbZBSieNMIaMACpBpVt0mH7bju9TZaA+InpjkpCGw/sdSgYRlcY/+3dZgSya
	TZ5Agv7QN+4oalfF/2rfnqmY1aswC0M=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-60b86fc4b47so9272a12.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 07:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753368358; x=1753973158; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t9HVJHe+iSRcfFZNFsoaQkuhmI2iPruXvW/Fad+gwuo=;
        b=oOFxu4GSolt4Rd6wTX9mbYsfVX28EnzRStOna9gQMwbmAFIvGPzGkMm9/yOR0uH6Ck
         kDe2Vr5SbWhZhfs7Uprj+yYDjv2J/6IRZHr/xGjoK4qZcEzmPNwp1LaXcYfX8XXBe875
         t/CUJxnPsCpioH/j1GAx0/4fIAyR6URuaJqfEjYtxEHHK+oNnMB0g8eLzKhezGMLJW9W
         SyRuyWoqHC3oMfaBgFCet67VY/93YaS8j3DGVlxTZXrhbXtxOZkCQMVm4hcX1VPQIauQ
         3yyWiLMKdje0GOySQkhGD0StcSpwZF7AxkEJ2CrP+krKnxq4bdgGwEEPMTucTFINzOwF
         zbUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753368358; x=1753973158;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t9HVJHe+iSRcfFZNFsoaQkuhmI2iPruXvW/Fad+gwuo=;
        b=afaf9LhmuaFswh5tWaDFZ9J9WCJfWtKJDDSTnPDiMuMzp/x4hElDpBBxPzv+AGMXNV
         fVB1FBbVgaT/ULrxKMHhSfmj+9EuN7vtAxvlWtg/PUVp9OiTsje1EQV+5msoqFz8+F1H
         I13lxspg0H2d4dxXTnOoEwapMCc5ujoqZ4e0RZsq+GFR1T15IWOn4BeWMxNMfVFC0L3O
         A44zxqvgcaSo2fdw1SEHwUfX/prCOc7B2FLGxHnTsx5Ns9/tUTutAHrfBSU3SMjPSWIp
         D/hcgZNWuIoOcrXO6L+H4YYAXhXt8iLTE0jUnxKo7t85KLSxYOS3RqHfvZgGQ6C5Ydb0
         RZKA==
X-Forwarded-Encrypted: i=1; AJvYcCWRR8cRbrOVMhb2Cm1H3m5mRmPMixKGDdrydw6E6GokzU55enox7nXGy1mDsVdgBBHWlYxsfDEjxQ==@kvack.org
X-Gm-Message-State: AOJu0YwzJ5bByIHeuL01Fpsv1mHJh58J+Ke+B976IqSUJv0gXHe9/0iU
	waAuec/SLhpFMl+oj91VpnzvVu+KgbqRMEbnn98RFqlsqTnlCvLB0Q71Q5UnGfqWnrPqzpPvnGo
	3310xdKulKU8UVdBUQhc/Kt09u/tu8nsQSj3DDZF0
X-Gm-Gg: ASbGnct3KIzdwKU9EPHxmqHwIzsWw3hFf0fWM78/YC8OlbAJvFvWRRkVCbtw1buw5VR
	DTM4+tsU3KESMCTmWMgANe8jrH51+IWjjIxWzTTLf4DUdjRTR6wDvLPjPNUWJrTzHqWJ+4YKn+L
	skA8cqfs5y/U1D0r444yRJObImou3MSD0e5ikqd+T7jQu8BTYtpit7o7Mn62U6VtMA2Q3LUsqkU
	mPFLgnxZKUQXOlGkAf2oDbMmGHJkXSPNQ==
X-Google-Smtp-Source: AGHT+IGSZpicBm0kzdR09OWL7oNmNSbG5umAWNPq12zXspoqnQ5qSZeuAo6ECOy6+JRbcvDpkNP8nSSArqw3TzmkxV0=
X-Received: by 2002:a05:6402:c91:b0:612:ce4f:39c with SMTP id
 4fb4d7f45d1cf-614c452f4f5mr103269a12.0.1753368357273; Thu, 24 Jul 2025
 07:45:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com>
 <16c97e30-19c9-41e8-b73b-c0b3c8eceff3@suse.cz> <CAG48ez1qhjQNHC+3572udqVWHTANFpQ0ngxn_4ZDC9F8NCXsFA@mail.gmail.com>
 <c53b22c3-9f7f-4793-9d10-f4df861a3e32@suse.cz> <CAG48ez2cGX3e5bqgcw0OEnho29+YhwG2eOrHRgNwGAA_Nb65nw@mail.gmail.com>
 <CAJuCfpEcjH+W83At8WSkgzO=JvZmapg6dPaXmuSRS4ufhSha4w@mail.gmail.com>
 <CAJuCfpHk_k5eVhAZTK=jJvES9311Hyo_YXxY-S56EAYSBuRVRQ@mail.gmail.com> <702ab3bb-db4c-49cb-bb77-4e864cae610e@suse.cz>
In-Reply-To: <702ab3bb-db4c-49cb-bb77-4e864cae610e@suse.cz>
From: Jann Horn <jannh@google.com>
Date: Thu, 24 Jul 2025 16:45:21 +0200
X-Gm-Features: Ac12FXycbft8xJk_FMasxwKQonXWoLp0FEIYfH4fnR5HmpGPO9P0XjxatL7Ltgw
Message-ID: <CAG48ez0RrGX-UDhUF+1x5-euJN9z448dsrXMgv4+7-_s=zan_A@mail.gmail.com>
Subject: Re: [BUG] hard-to-hit mm_struct UAF due to insufficiently careful
 vma_refcount_put() wrt SLAB_TYPESAFE_BY_RCU
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Pedro Falcato <pfalcato@suse.de>, Linux-MM <linux-mm@kvack.org>, 
	kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: xq8hrzh3z4gi54fs3az6om6dw1ozafum
X-Rspam-User: 
X-Rspamd-Queue-Id: 31F1C18000B
X-Rspamd-Server: rspam02
X-HE-Tag: 1753368358-938069
X-HE-Meta: U2FsdGVkX1/Hui0RpCKrmOI68FVBPV3qEwc8Y2QN1itEm5nY2H2LBfPkxqG4u0OKBlwwJKQ4/4KF6b3HpFWlxMj/3kPWTmUUPL3ilXc29yHOjdw8gQ3HIyb4mVkZKiG7bZmml7S7x8TaKLn8Ijb5we7KRziDkto+zQ7xTCDJ+tUPUFDLk7SHrjmtI+ln6mkAsNymADUab1B1vpVpdY6fZdRyzYsCANaUOXOdV76bBNxt54FZJQ16/4oBdq//eqhdZjBZIA1Gj5qwWOdeXAuKOjfx8Kdib8zjUKzhsRK5DXYDAR+hu+JyADu5V/oJ/y08m5KNBDytSik2iHXC9sfEL2XrHXxjivLEnjXsXIJzBJI7QrcVN9UnANk8mYBWA0If/eM7w9hztNUeMhXPzGrqLpJQhjmKLuaN3dXm4TBBpoYO1KHwD7tOgA+cfe3vCnkZDuLvpHrheMEzjkTDmCWbW3wWvHGF3dyzG6yKlD+glikI0FG8E4yOL7vbawT2Rc56Vyjhnq3ViPMySlvSqW8PkGcCcC54XwpKz2ybU3bfumrP93DpD+C2FQWr9GimIqR9OA15jGgE0LnXwrVQLJZKCTKrA4zULZhbuowJ1Ya8l9/fOlX6UaYYe3J2uxVMQsLuIX0B0U4T/Z9XBEvatRJ5wnIqfibQO9RyAQRSffnwe+F6rPWcWZ8cWQbTT6vnbR//rHUo1mK4LyD+rMNJvoaeArUwNOQUjrt0z3vjNT9mphopB7LlZxA7ibu+CQf6NEldMUCYromzwWQD9X+rx0sX1KpTUJnvzoUeYwJRvfsEb+fmPyKotz3Cz+snTZe/fULb45Wqmxkfk1FEAvwF/yppXVTqoNu/q96JRc7gkXaF6BcehKkfSMkdU3PJJd7mVFBCl2LHXQPFbMXdUOnZNdxj7TLirahMmrYeyeaOVbcdmqoTIxzpAUbZ5qhfaF7zdSYeHOS0d/ZPiN/djeT6LUG
 6X91pFAa
 v0lAyTZLULF5bHS7ATJqIwnURUwhxCSqk6hgyO7adkRPu0BzJxfBB4UBG/Wqhqaj3YKM0H0RRyx+xTqyOGTZzlfh1NTJZ+nC7Gqk6ePf4m+uiC7p8MtgjF/56VKSEQL9YZDWyTQfXNjV1RrYGDlY20BHT3rs3Pi1kCF6AqNvtIAWgGvgS6bWmc1Mxxat5BHw+GWEOavJmjQPVCHemeM5CZF+43J+RKBqKkRSssZwwLExsz7k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 10:38=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> w=
rote:
> On 7/24/25 04:30, Suren Baghdasaryan wrote:
> > So, I think vma_refcount_put() can mmgrab(vma->mm) before calling
> > __refcount_dec_and_test(), to stabilize that mm and then mmdrop()
> > after it calls rcuwait_wake_up(). What do you think about this
> > approach, folks?
>
> Yeah except it would be wasteful to do for all vma_refcount_put(). Should=
 be
> enough to have this version (as Jann suggested) for inval_end_read: part =
of
> lock_vma_under_rcu. I think we need it also for the vma_refcount_put() do=
ne
> in vma_start_read() when we fail the seqcount check? I think in that case
> the same thing can be happening too, just with different race windows?
>
> Also as Jann suggested, maybe it's not great (or even safe) to perform
> __mmdrop() under rcu? And maybe some vma_start_read() users are even more
> restricted? Maybe then we'd need to make __mmdrop_delayed() not RT-only, =
and
> use that.

FWIW, I think I have been mixing things up in my head - mmdrop_async()
exists, but this comment in free_signal_struct() explains that it's
because __mmdrop() is not softirq-safe because x86's pgd_lock spinlock
does not disable IRQs.

/*
* __mmdrop is not safe to call from softirq context on x86 due to
* pgd_dtor so postpone it to the async context
*/

So I guess using mmdrop() here might actually be fine, since we're
just in atomic context, not in softirq.

