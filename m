Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7731CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 01:02:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA6F56B0005; Mon, 25 May 2026 21:02:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E57446B008A; Mon, 25 May 2026 21:02:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D46FB6B008C; Mon, 25 May 2026 21:02:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1BD06B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 21:02:35 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 51A9B8CF32
	for <linux-mm@kvack.org>; Tue, 26 May 2026 01:02:35 +0000 (UTC)
X-FDA: 84807770670.22.80671B4
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3C4C5C000E
	for <linux-mm@kvack.org>; Tue, 26 May 2026 01:02:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lb80pY0F;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779757353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Goh+Dy0G9WIYxe8zzuVvAhnviirVkepAUXk5e293rOs=;
	b=EE5BWCu2CMRtrSyzWuXu0sKPtbTfaDGqmzZ98N4ZLDnU5qNGg2KxJZFUf68eUKkX386DhF
	xUky7CkMG9DJsiUQJE6GkEPQ+iCud41gOotS8oHdnGlQUpFHand6TCr4fHQeNkNoHP994T
	AOuPR3Rvji10Innfemz5Cbv/lZJRB2E=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lb80pY0F;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779757353; a=rsa-sha256;
	cv=pass;
	b=qFUi3aXCbubTXsfpHhEzvTbKG3exjyBxcVlYASfxFY5asL4wf1CZ/aOL3r3v5/3RX9ItpS
	8X0wA0deEwOCKtDkEr8BrRJKSvQDosUQD/+pjzoUoTpwaR0TPaazrLXsEvgXphVI32t7r8
	PrDZ58vJHJxAn97WQxBn88OFku8CsLk=
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-39397d637e6so14147991fa.0
        for <linux-mm@kvack.org>; Mon, 25 May 2026 18:02:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779757351; cv=none;
        d=google.com; s=arc-20240605;
        b=Xdr9c9rh8fRhi8SRiE+wkYJXpnGsozble7Ss2Wpbq3EYQd7ny4xOpBg5MBMfC6uEJA
         nlwvL3EW0JKGb37tsZ9hSbU4fnZnSZM6SzGLb2QluPAOrci6XgsCYj2ak/juLWM+g+fh
         Dp1U9kDsMRi0IS43t4n5YpMX3JS8Xltn2qzqk1eaWUt5f+QIhRJUJTUzqFPLZMuYZ11u
         WYgXuwyekdEmS0VW0UTQjdTpYLtWLr/zttsBeuDTuTtIN5CV7mAb+aB6uvEvxSOHir50
         fQLisAjZI3rlnJywZWigZVgChe0HIr1EJf2O135Ca+ipZy5/axKeiN+6V12QYEwbeIpG
         hBdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Goh+Dy0G9WIYxe8zzuVvAhnviirVkepAUXk5e293rOs=;
        fh=cfQWabahqU0yCkiShUvWpHpUEh6bzO/Sag+Nu9zl21o=;
        b=btLIMQWFoOY2DyNRDUnn02u6V2yUC71GFa944ti4nxWs2+IagZW5rfnrnADyxkq9+Z
         GZB0ggJbTtBlKTURUBPwF+YyvAC2KfFbYFUg9Nl2yG/kiZ9LywsE3jM9+EHk4/ROR94m
         mBk1dOWVeJ2Z/0ItSdYDLou4WgzJWjJAenysJf7XI6PcFTEsYShFRUzQJzu68/QnIzfg
         kwje8iZITCQWYS2GrDFicHYmqYSAFq9cMOUWhAv+EuIkFVXWcmslp/a7sERa6okZWx80
         icQFH8aBeM6uBQafThkT91WHGd7k7Hx63WfiVkkqrPBHpFiInJgLsH/d3dAmW5lw8WNC
         utqQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779757351; x=1780362151; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Goh+Dy0G9WIYxe8zzuVvAhnviirVkepAUXk5e293rOs=;
        b=lb80pY0FOM2bBS/pV0eocgLUnR5V0Lr5zRMNYegXI6dMoSZHmFwscR2u6s+5qVJU9m
         3cTc7o3yaGhJ6k3uwRvGW9EfU+ZbxMNjQs3AHJphy7xI9fgy0ivJ+oYRSWFsI1cvmZuv
         BExvHR6NAnNZFYh63zX5LsaWpjmgrjjJE6EYHNCuAgyru6BuOigQhcPufrpEssMafnMy
         D65Equ5rarVTfsy1vedaRSVKiFN25EeCFmUQtMxagsscZBUDk11R39ZxTc7KpSzUnUgd
         QP9CtizNnL7RiTuk2CNNUJJxt2u3IIJ+vnyIRXmUgH/eM34UyMZU9HLk9xCOH0t+ZnCD
         bj7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779757351; x=1780362151;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Goh+Dy0G9WIYxe8zzuVvAhnviirVkepAUXk5e293rOs=;
        b=U8vr8F/IPqIcwf9vzSCSU2W1qzLXrvryVJ7en3ny7GAeW7YfJn88DWA8WHCAnPZKPT
         WnUQkmkBkoPqvEL730HUJWG3WBnJPVEoM7Uwff0rLGYeyx64Q9gIyonzWY3go7I3xenk
         XserLvSlRuRopllb3S6qsBKc3hE5ofeanM4hwkwX2bldU1A4UMmM5sifZrGhx5UQbYn+
         /Gv7J9/LmYOMNNhqlWPn8RAxgxl7/LYpKWCxmrI/+7qgAUzr68/uzd/YiPy4n85IldSM
         qM5UOP3ni6ZWFKrhnYAsmC+Gn/8qrhp/FwxjsyzL2V13HtNBIy+Wkrp63C58wHq5ZmFP
         XxLg==
X-Forwarded-Encrypted: i=1; AFNElJ+4npD6vT/n+w8GrBKsxBmfgz6WD7G4yDGYY53fnJQCvkVN+sJd4jR5ObMU9DUZpvijfE7yyWMrgg==@kvack.org
X-Gm-Message-State: AOJu0Yy6zJQLYplz6X/5eO5bKvArAeoTXBzqxV5sZLmdoGMDzfY6r5Px
	UDU92JmOYMhN9G0QK9WU4UjXj6qeN9FnHGdlu8U9Oc5am5UqLEq58bfSk3b9Q1+eyo5GI05cdI+
	QvywFtB5fmLrj3+2ImBPYgEuU1UcgUyY=
X-Gm-Gg: Acq92OEExwV1LKMb62aVM22o39j9bBJ9vheVrToVc4O8kfZTEjxwfUhsOXzfs6w0dXj
	2/cz5+mirq+ebTGo+cnaFUm2hHMhObBgQG8Np63GM9EXWMFxIz1oajesdXcWUA+8KgpgxyKTb8N
	7kMT1G0K1racZEXHWHUXAb/KVV6hl1/TTQP0oCCiNi3m5E3GFi1BvEkF9s7OvHVyzY4fRy0HEEw
	pcQEfQGxcHv8/LNGp7aeEb4OlfYFmfCSY1lUiFeNHVSm0Mb7boNP7Lw3GhSRViVXB/noc6dDLI1
	IwlQqcsp/76ZKfgSJ6jEi8rxukwXnA==
X-Received: by 2002:a2e:ab1b:0:b0:393:9d8c:73d2 with SMTP id
 38308e7fff4ca-395d8d103a4mr25286961fa.7.1779757350964; Mon, 25 May 2026
 18:02:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260525071033.1104929-1-zhaoyang.huang@unisoc.com> <20260525131501.f232fd3cfb67442d2c284631@linux-foundation.org>
In-Reply-To: <20260525131501.f232fd3cfb67442d2c284631@linux-foundation.org>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Tue, 26 May 2026 09:02:19 +0800
X-Gm-Features: AVHnY4K90WOLAOANLYWTUTfxAP9kBLzqTCwcR3baTQO5SCZvbP5jxzMqfPtRmyw
Message-ID: <CAGWkznG2bag4fLQp9xgNnyfdC04gHWNHb8AJKMy0zrtjrXvesA@mail.gmail.com>
Subject: Re: [PATCH] mm: free HIGHATOMIC and CMA frozen pages via buddy
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: bs79cixcjwi11nbe1zs675ox4jyurd5f
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3C4C5C000E
X-Rspam-User: 
X-HE-Tag: 1779757352-252772
X-HE-Meta: U2FsdGVkX18z1KyJ3ZWaSZTV/fSq/f3vQ5asGfuTkkdNdQOTgmAQOm48IbbNNx5pH1C+wJya/MfPQNl9V39rwjIKX19kXK53ozMd6regAcSi9UfrQ7V2nYF74vLbCth/EWA4q0g6eI1Eu99VvqfUmKNu9SezjGWLOnS8MCbYbK9Sl/GAPncjlF/Raj3ZTTV1EMBSttwwnObDRdrxEmRB7wP8/TlJvus13a16uPKnTEvl1DaUNHVvWvE1MuqZU5PyggrQS2SIopJ6zk+rZkmnRjo/zHT3B+rGtwYvDmzaJXmVqjhZ8U1Qu85BZnqXYtolRm0WvtZ7+DURiVO7omWzXBp6yxlNmR2OkGrOcWfZkZpE7WZlw3yVHfXZ15TTCDeGbrY/6iNNJTJrMzMwYWF5EQthLiYcLajniLqAGnR0ADS1XOjdDgq1YtCZNwSVmxr89IJpLSMbQalbq2E/5Crruo7ymWYbfkhtBja0G8YRY43yhL/cnf+DdaMlXwlk9P/YasZflb6f6+XdVHBIvPhiU7lDRIbK2k4SO4eC1p/hjZ3QWmlM6//osvRUXAY4WuJ/rTP9QlZW3hoB3vaVI+KGTpuY4f7utk45bs0rGDvg+M+wbXSW5HapxNmjyCeMpiseZM4zG6elsAE2xSHqU2ViIOngFqx1xp7fP22Ca17/EXEJ3Pjn4QUdDqe5//cCvTPLcNlil7rGIebSKERo+z6vL8P/6z3oQBFgI2B+SBQiooV16FlHPpMPo2Zi2g+nEC2ZxucxNrscG+MkTnh9oVeSuFBXMTl/LkvF29CbLAB5PpFg7inpSYvBRGapJScizxhOgk4upDea2MXICK0OLwCnby1bslwqEWAeDFm09s3bG7sdEp+KLgNsrCNGiVUJnE7RzDun5+0asoQ9zuEcZ/VJscBI3st9a0R/yqouQYdNDRWhQAIbhh/cz1MPJc26arHXNeczNufdk/82vEeA43x
 qqCu1VQS
 4VSAEhwA6DNTwzk8kzGISyhX1O4p1wJ/gT3n7a3g/x0CgqpcsxihRaZToiqO70en60UyufNhY7jiUKF/h6bIGNOQ/5QQky4C3QWQlSeinnDaa4GothKaVyijoWn2PktNrz25XrZyjjfS0VLVY7SOweyD/fAoV/aIsqJdpIxsMIW6iwBcyOjzZwi3FXPs/3Tso6SUxk3TF2nhh2kl1q34tmMlIUWArDSuA8JeOJCUXRdWwqYoTA8jxq8bm7YcPmcJiuoLMymYibyWA66u5Uaj92e542nCFuE8bZU/CRA9T58KfxHbY+eTVp8N8XOaURuOaB//yYSpJqqng97XQyytMc67p4Uftlroa+cDrXhJcMNYdGxGXFJEE1A3fSour4Mn0flHPpkx8iI/sGVleeCP4Ts1YY7C4E53WEyF1AhTq+CI7SQ+R7XJTlnFin74eW1zy6NWY9096wr8/v1EyQ3n2BcP6yyGHKm8k2RFsVp5q9pFIitCY7n2qhY18nu98CXlxu+zofyrnvT1JRZRFSZ8hLqwQ9FSN6feMyq/DzkFjkeBnlZ/R/m9avs+eGLvIQ4RLtbWt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 4:15=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Mon, 25 May 2026 15:10:33 +0800 "zhaoyang.huang" <zhaoyang.huang@uniso=
c.com> wrote:
>
> > Pages in pageblocks above MIGRATE_PCPTYPES were remapped to
> > MIGRATE_MOVABLE on the per-CPU lists, so order-9 GFP_ATOMIC
> > allocations could consume CMA physical blocks which may lead to
> > cma_alloc failed.
> > This commit would like to free them through free_one_page() simply.
>
> Can you please describe the userspace-visible effects of this change?
> Before and after.  And include this description within the patch
> changelog.
ok. KVM start up failed occasionally observed in our system which is
supposed to be caused by page migration fail
>
> AI review claims to have found a couple of issues, one of which sounds
> serious:
>         https://sashiko.dev/#/patchset/20260525071033.1104929-1-zhaoyang.=
huang@unisoc.com
yes, that is problem, will fix in v2
>
> Thanks.

