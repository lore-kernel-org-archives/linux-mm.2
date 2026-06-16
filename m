Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3720CD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:33:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56F296B00E3; Tue, 16 Jun 2026 17:33:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5468A6B00E4; Tue, 16 Jun 2026 17:33:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45CD46B00E9; Tue, 16 Jun 2026 17:33:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 18E446B00E3
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:33:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 906301656DB
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:33:55 +0000 (UTC)
X-FDA: 84887078430.24.19317F8
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf23.hostedemail.com (Postfix) with ESMTP id 66EBB140003
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:33:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fA2uVYrA;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781645633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lXf8nL1WjPPTXu/ygIqCbfgbzskizrSAlTvqvC5a74c=;
	b=ujt20q2Tog+q2KRGYMn1mS4Q+r4KYGJalhzbgMCw1kN969xKTXI0V9e4u9OFFOhXWEnkuS
	Ima/Asj4FGneAVfGQjD0uNZmvP7t+G+W1j8zP61vqoVPjrpABw+24lZz35q6ZIMiK9Ohe5
	K9sul3h+zpf6enGGispQwryGPNse9Jw=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fA2uVYrA;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781645633;
	b=kTUd220RNLyMvpjHVmiMFC6woRzCnR9ldOF94VS0Jh0I1c4OI9o/cGfG4gESV1+W4cdW0G
	34HPgWIA6o3TOFIFJVP6CcR4NI3ucypXV1Thyy0sXdINOuoY/VHhy6r5naMNjIiP6100oc
	RcvZEZCwmqGsgWuFJ+Jx5wAMTQLx4gg=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-490cf3000f0so50895805e9.1
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 14:33:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781645632; cv=none;
        d=google.com; s=arc-20240605;
        b=WyzpFuz+8hBk217K/G9l3O3NkbXsUJzYrHeJUFCFBFUFjCJzDfN8EsEggy80rOvm+y
         ekFpHVMLEC8BVbT3Xau6QGlccCnVlcyQypyv0DTNC72+Yhb+8KcQ1yPzwpjR/eXpsd9j
         jUQ+YifUKHj2xxXcHcyMoAoohTUB8MxQ4Es0jIY5vR11c3lkgLUvQWSCXBZea7FAstok
         /B+tIKIe+8r4RXv1oiMu0RVFuvqeMmvDurEmDtXY7rBqg4LaCvJOp1giOofCem4Jpwhe
         I0vUFM3SlKqdnerNKt0jPKTR5Aag54M0qposDhY86//hu9rwInc6B03SmDSBK118kyEN
         Y6BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lXf8nL1WjPPTXu/ygIqCbfgbzskizrSAlTvqvC5a74c=;
        fh=ePpcNDCTrTo/QCg0Al21aiNjmHYactNsks0Iffs7Dmw=;
        b=Rp1tmbQrlrL9J2svKbtiTk1PwGXNN6TsZy7tODejQR0WHL1l/PhzsKViNGAYf1kWKv
         8WENcfdPHnqQ0ghiOZqaexRD6c51PXzmjjzaV6v9PB71NSNnc0wdwyv0P6GO2BFPQSDj
         PKGTehynAbl9hWpAGGMcW4sY30MG8+dw0n0ZY2NMxpJGNP8duT9BGGXY17G4GO5k96B/
         5z59QAwGBj0iRiCEgC1ARAiOmSaPOnWQbJXXpQYlULiWLDsVZD8T0XyMaCcUl+D7eFeX
         Eg0GN7ctUquxsxORxejssbwPNX4PRdeiGjXHuCrwqlLuqjng/LC6n02Un0lOPUc8mN07
         YrSg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781645632; x=1782250432; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lXf8nL1WjPPTXu/ygIqCbfgbzskizrSAlTvqvC5a74c=;
        b=fA2uVYrAdNjPju/WUWr2gtEaO7xxxvIJDKgGIPivZ5yXpfVR56GTB+F8qI5l+fFjnQ
         fK1TespU9s0slPtY2ElAG9ey70Ii/S3Dns7iKrvoDQ2/oqwv3vB7lkJoo73l2fbH71qy
         2ykkSTXVkRGKRBXmjrD/I95tmP/Wf4oZscVJceHfwT1XdPI01es+33L9zfzrsY6iLI4E
         vvkvv7M2OXEQxStMjglu6PDX0aZhq2lAVz5Pij5aGsEV2JXWFIn1RLonumkZkn0Z5VS6
         mZDjMZlcxNIyphvOQj699/Y5Z0/yISBhgyGwm2p47A3EpwZ5S6nD1k7H61HW0jiAbKNU
         OAAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781645632; x=1782250432;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lXf8nL1WjPPTXu/ygIqCbfgbzskizrSAlTvqvC5a74c=;
        b=W7jR1Kwg1lCarqIhVQnPT/OkJFzJOqUOwZ3GO1OWNI8NawwaFPoOQiDYTyhtaRRJZ6
         34K5AsM+0Jd3nEg2pCXJEIe4LmbbF9/i7g3tNTrltxURfaFtvnd2KHdBUEEYP+7MOhMp
         5sRZ9/dR4URms/IVDIlgLNJXaHPQaaqsuLMsmpC5DzoQtkSL8MeAWoSK+PDuXvqN30UQ
         E4cSim2qFr6QmqRKlJxzKevdSMS2hA9GGTFU1mLJ7dsIInx9gG+I0dfVBJhk+vjW3QTB
         gfZ1/xs5xHilK3JrZDlIPFtaQxFCLQFdPaCkQdqXshX0OaqTJRulCYFZFz8HvoSS6bM5
         QpHQ==
X-Forwarded-Encrypted: i=1; AFNElJ/ARj1o0hy7+sFflFfQykWH+amKH49zPTsC3Emxb3whcLk2F80bI62jcGRVzc19zkGmUSz6s/FHXg==@kvack.org
X-Gm-Message-State: AOJu0YzEn9QfYuYaMulcasvGcwaaFAjNpnfAqR5iphPY/OP0EFh2wV28
	PDLOkqWmpEMd3Rhw9GFliTjgH8eNrrU8xYVXkuJomVSwaqG983j8c+6dqG0h7rCV82D0eDqlnS5
	KiLINHi1ngaNmcpMdpurg1JDxKOmUyuxJUYVB
X-Gm-Gg: Acq92OE7tHts3WZB2Z2pC/wQlEEyyU4YL63XmtvDCv5AHHhSyrubckAZQ7evd+ZIQLw
	Or0AX9SDEa6+cy1wEhToykoJ0dCNafhwJPRuf+zXrn2nMhbirNUP7KgkmaAfcu9UGoJSxl0Sb9J
	dEqNEu3w6JQJWfzc/6nI36R6CIB0FKPoXeHiaDnjKGWlpd8vwuTSc8byh9aMe9btu0ONSw7fMEJ
	oM4JGQ1LFtFlAebywI0c5tNMopyFvEhB+rFRQxdeMHOX6wC5vOEXqksgbbYnSO3inVRYff5GZgH
	PerW5zpFg6h1wDpMiaOSw05hA39/GRb+8TlWZzbhqPhjkru2smC1Ivo=
X-Received: by 2002:a05:600c:4e89:b0:492:1e36:bafd with SMTP id
 5b1f17b1804b1-492333df13emr10676665e9.37.1781634788536; Tue, 16 Jun 2026
 11:33:08 -0700 (PDT)
MIME-Version: 1.0
References: <aictKA0XWMWbxFdN@linux.dev> <CAO9r8zPvCaCqvoUhPdAN5Oi_Sj0mK-t7DJhOOz3Xf1DT-Wrgcw@mail.gmail.com>
 <aieUQUBHI+E3uNPW@yjaykim-PowerEdge-T330> <airzE7jD9UtyR17J@google.com>
 <aisEWnb3pzmVC4dl@linux.dev> <aiu06fbV7rWqY0Bm@yjaykim-PowerEdge-T330>
 <aiw2p5ANjsQUCIHA@linux.dev> <ai5y923elCSZp41j@yjaykim-PowerEdge-T330>
 <CAO9r8zOVqbJEaBqTHw=r2bYw7Lm1tO0TU9QuG+eH1rfqcTAJJQ@mail.gmail.com>
 <ajCgzNIPLhjTRSXR@yjaykim-PowerEdge-T330> <ajC+FNpkVpI4pbBz@yjaykim-PowerEdge-T330>
 <CAO9r8zMimM8n54BL1viuX3pYzO=wzQU89LhCF1HW0bAv97ZQtg@mail.gmail.com>
In-Reply-To: <CAO9r8zMimM8n54BL1viuX3pYzO=wzQU89LhCF1HW0bAv97ZQtg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 16 Jun 2026 14:32:56 -0400
X-Gm-Features: AVVi8Cfr8CEOZKUUld5jFV5E_U7IZnrXsKXwb_Qx9BDKSv9h1SLfYRc_8OLu6YY
Message-ID: <CAKEwX=Nz9SWcEVQGQjHN8P8OANJY4BG0w+iQOzoNOWuteoVjAg@mail.gmail.com>
Subject: Re: [swap tier discussion] Re: [PATCH v3 2/4] mm/zswap: Implement
 proactive writeback
To: Yosry Ahmed <yosry@kernel.org>
Cc: YoungJun Park <youngjun.park@lge.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Hao Jia <jiahao.kernel@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org, 
	tj@kernel.org, mkoutny@suse.com, roman.gushchin@linux.dev, 
	akpm@linux-foundation.org, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>, chrisl@kernel.org, 
	kasong@tencent.com, baoquan.he@linux.dev, joshua.hahnjy@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 66EBB140003
X-Stat-Signature: ch8on67nx1xxkjutj8hafh9qs49rjihf
X-Rspam-User: 
X-HE-Tag: 1781645633-603649
X-HE-Meta: U2FsdGVkX18Z/fzwagWehQGzoDnDPmQuqVCkYO1a0eLBCBnUQO81nSt/9YqXgjwoltM27MstJnJmOVFm3IiJFs/ojXWsA0qOxxtk4K5ovqd9EWJiiIIANCaSxn5/vsH8CPmo8/Y1dSovzUHrhO+kycDbUoFVzbZ6u19dPF7U3OFPNQAZOpWZvOnXxmI1IQQ3NmCf/jyYV7zHN6VtIi7omb9yynRkqDonit1tgTkkiQ3oD9xzI7oGjlD92+bDBs/18hgeGadjAEEoClLigwtTBPoOvD+QKNjCtjOX7PbJ+8OQm52FVXWQjQuYsuASVx57RA2XFznYjYJX5w47p7UhvMIkjlz6EUlaw2c4C4ivNAET+NEbEvFFEmBaIiC+LI6k/HanJQCQxasPQaipaXNbX66A2J5XbxNaDaZq16gIN+so5dDli5fm3ixC5BktL8nShllz2sianc637rNBoUbpyA0iDI3EkjxAmGcfpPo04NPND3Yp5ztrvfjSuVyIDitUHytd1rV3uC4uZnTI7oaZL20iIHHa0Boielat2ptDuP6Xh9n1X1vcx8oYI4Y/MgBrLtSrFuIQVxO+XK0xVuod/9Mt8avFe0eyQNDJlnWH2Xl0T9oE60/FLDalbHAszl0bBDofIBj8LOuFfgw4YmlJvLHXdZ6L764yrxTBtMnuC66AP8eurVi6czs6gI78i5OG0NoblXjg11+R+o5gmgXFoVBgN9JloqxnxklqynbGM1Lp6dTuBEhZbIYQ5nOkjrqlU2IqcMYBUCk8tHo5IgB3Ul5vqw99Tvi5WaxAVsOcEYiKD+NDfX6XYQXhprDdLM/IKazYqR5Arx24XvqMAlJ4J3M9BHyy5xx/7AhtUpd8ZN7rY1uCsiOqY89BvVGFmdhxSAUB//2Nfzt5nGrQCZKIdMDjot/1Fmd6bdH2OhMfW6WPWdBFBq5i1j6EguCOfOfrNwc6MKtnAs51E8QIvD1
 EvJV7OFE
 yO25DjX/XJtIYeNoF/5htBRRx9nU5ugFaYDV/ucdYtY0rXO1zm/wF0AhyyCICQKGf53l5+cKo/wW5+zNXS6a8BGJpBCaeOG7qUKtITZ8V1RDyaYnvCi+oL0TjtE5Vk/Kh7s4h1kUKVFbrpLtRQJfFzCNXeCA/TtHShJIDAoRbOJ6GUsAcf05paUBVRCdu16cWzTBy8vZExtZeCHHVlFgtEtr1LEu2JRIsMZ5kEnVR9HZ0aCmfvBWuMgTypPb9rAvHC32XYhK52iOKgx6G+lCBhKVd6SRMB7U12sdDzed2h1wT/rFxgCxPril77V5GmvG5f80auebeNjcbTJdfeufpE4oAssuHKeoaYRmh1luUP4oH1jh/4A9wfGFRlUy5dSsQPg0tl/ayJg197OsEVCSfqP48dYsg1dcfZLcKHcp+0iZIRvgQLA0slRcUKzq/vhJcxP5ZcnEY6DpIlxSdBmv5hf1uUcLXD44U3XjX4pXtEYZSvzDyCC208pleHah17SalqojHq445gddyXfw0AfhPODS7wA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 1:31=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Mon, Jun 15, 2026 at 8:08=E2=80=AFPM YoungJun Park <youngjun.park@lge.=
com> wrote:
> >
> > ...
> > > - "zswap tier only": Only zswap is allowed. Fallback to other swap is
> > >   blocked.
> > > - "zswap writeback disabled": zswap is allowed, but if zswap_store()
> > >   fails, pages can still fall back to other swap devices.
> >
> > Upon double-checking the code, my previous clarification was wrong.
> > You are right. Sorry for the confusion. "zswap tier only" is indeed
> > equivalent to "zswap writeback disabled".
> > (I'm not sure why I read the code that way...)
> >
> > As I initially thought, it might be possible to replace the zswap write=
back
> > control with the tiering mechanism.
> >
> > If we need to keep the existing interface, we can integrate or share th=
e
> > underlying logic (though the specific details need more thought anyway)=
.
> >
> > It can be summarized as follows:
> >
> > - "zswap tier only" + "zswap writeback disable" -> meaningless (noop)
> > - "zswap tier only" + "zswap writeback enable" -> meaningless (no writa=
bck backend exist)
> > - "zswap tier with other tiers" + "zswap writeback disable" -> uses onl=
y zswap
> >   (can be replaced by "zswap tier only". This code could be intergrated=
, modified or something.)
> > - "zswap tier with other tiers" + "zswap writeback enable" -> works as =
is

TBH, without vswap, we should not allow setting zswap as its own tier.
It's meaningless. Maybe makes it a no-op, and warn users what they're
setting is gibberish?


>
> Hmm we might want to somehow disable memory.zswap.writeback if tiering
> is enabled, to avoid having to deal with this. But I am not sure how
> possible this is.

With tiering and without vswap, you still need an interface to
prescribe that a cgroup can:

1. Allocate slots from a certain swap device.

2. Use zswap, backed by those slots.

3. But no IO is allowed to those slots (no writeback or fallback on
zswap failure).

So we still need memory.zswap.writeback, until we get rid of non-vswap
case for zswap.

