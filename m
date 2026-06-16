Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24F54CD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:11:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 189D06B008C; Tue, 16 Jun 2026 17:11:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 161BA6B00A5; Tue, 16 Jun 2026 17:11:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09F766B00D1; Tue, 16 Jun 2026 17:11:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D20C76B008C
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:11:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A9CA51C107D
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 19:54:45 +0000 (UTC)
X-FDA: 84886828530.11.11F5BE2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id C03521C0003
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 19:54:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JS1CEPM5;
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781639683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WsFleb3h7HVa9Owq6c5tqmzQO4Gd0VwPEzAt0GlErL0=;
	b=KjbKUI7plZDEW9POSuTx2A31S2Yz1rtiZHX5oCNBQ8SgvwjGuu6FX2rz5//8oNwqsChyfC
	5nAgGUsxzt7BQzvmVDkWdMuyzbdxBloEqJD3jo7eHxSTMrIigirjjUe1m3gfRfU5TRWka8
	/REObcVEkG6pRP/m+iFwDRjwp1a3wX4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JS1CEPM5;
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781639683;
	b=KfrE3xaKLom4koYjgJ+q7su3GRd4TBi9sXvBKR8abcz1gaHQ0lORHOuAj9WBXOV55PlU7S
	gevKxS6CawW9Vzvz53uCqY/1uoQdsjzUd1CV86f/HUpm++7WoNsUop41DfMkc2AtZzZSTO
	RtJ+XoOdIX+w6iULlS8MfDgjECWfH0E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2BDD4600BB
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 19:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFDF91F00ADE
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 19:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781639680;
	bh=WsFleb3h7HVa9Owq6c5tqmzQO4Gd0VwPEzAt0GlErL0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JS1CEPM5WPbmbrvCbVO5+FZn/GYSIreqCzVUD61BQ6ULMLDq1uOCnsnNHvCwNbL0R
	 8dV0ZVasaoT7gugCdF1tw0zurWWRsETsRHwGwdjrFKPk7DSZcoxJi7LS20SgULbVik
	 7jbxw5ep1Ap4UxdmkWdtS56G9hsJpc/wrb1hD0xycdYWapO8MKLGQ9N0GyqXf7Bi+4
	 qLhn9Rj9Szbz21kxW9yuxGAGoYyVaNtKnBtQgcV9nTktt82iO56uOH/XMZiX7zUY5p
	 Cobl3nDdM5kWsVtLNgtPtuAxi816UclkD4TBuZklId4kPpMggu4DWQgMkIxJkmlWqV
	 xmwuiXEcnLmSA==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c029505b389so39177666b.1
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 12:54:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+NYSsWtJYYhmDEpeWVZHVrY+nTTMt/E4e8d6cCLn/JylzJIpXB/+4ZKSC+R4sQ9qMH1+vcKz3y+A==@kvack.org
X-Gm-Message-State: AOJu0YzoRuATuRpLpACWfOv06mihqJ5gS0tTz1hASkTNDKAkkYFyn/jL
	UOPBDpBjjzQPrkiG70Vsf+awdrAfgLGuj3Da1q5jlhxz0mBqCXP0jxfp2UVpwWmuKnIjXNlXRx9
	CzbDJy8vRyq+04Z1zfZ75Gdueq/e39Mo=
X-Received: by 2002:a17:907:704:b0:bec:1632:ece8 with SMTP id
 a640c23a62f3a-c05d75c4721mr7784266b.15.1781639679768; Tue, 16 Jun 2026
 12:54:39 -0700 (PDT)
MIME-Version: 1.0
References: <aictKA0XWMWbxFdN@linux.dev> <CAO9r8zPvCaCqvoUhPdAN5Oi_Sj0mK-t7DJhOOz3Xf1DT-Wrgcw@mail.gmail.com>
 <aieUQUBHI+E3uNPW@yjaykim-PowerEdge-T330> <airzE7jD9UtyR17J@google.com>
 <aisEWnb3pzmVC4dl@linux.dev> <aiu06fbV7rWqY0Bm@yjaykim-PowerEdge-T330>
 <aiw2p5ANjsQUCIHA@linux.dev> <ai5y923elCSZp41j@yjaykim-PowerEdge-T330>
 <CAO9r8zOVqbJEaBqTHw=r2bYw7Lm1tO0TU9QuG+eH1rfqcTAJJQ@mail.gmail.com>
 <ajCgzNIPLhjTRSXR@yjaykim-PowerEdge-T330> <ajC+FNpkVpI4pbBz@yjaykim-PowerEdge-T330>
 <CAO9r8zMimM8n54BL1viuX3pYzO=wzQU89LhCF1HW0bAv97ZQtg@mail.gmail.com> <CAKEwX=Nz9SWcEVQGQjHN8P8OANJY4BG0w+iQOzoNOWuteoVjAg@mail.gmail.com>
In-Reply-To: <CAKEwX=Nz9SWcEVQGQjHN8P8OANJY4BG0w+iQOzoNOWuteoVjAg@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 16 Jun 2026 12:54:28 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOD7XaJ0Uo_LLLDTRKbeTOmAwmM3q8q6rUyH3oS-X3Csw@mail.gmail.com>
X-Gm-Features: AVVi8Cd9nHylszomRw_rh9bJO82Db4NrHN8B87fA6yRA9MBwH5p_UAEEXHvDHNw
Message-ID: <CAO9r8zOD7XaJ0Uo_LLLDTRKbeTOmAwmM3q8q6rUyH3oS-X3Csw@mail.gmail.com>
Subject: Re: [swap tier discussion] Re: [PATCH v3 2/4] mm/zswap: Implement
 proactive writeback
To: Nhat Pham <nphamcs@gmail.com>
Cc: YoungJun Park <youngjun.park@lge.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Hao Jia <jiahao.kernel@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org, 
	tj@kernel.org, mkoutny@suse.com, roman.gushchin@linux.dev, 
	akpm@linux-foundation.org, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>, chrisl@kernel.org, 
	kasong@tencent.com, baoquan.he@linux.dev, joshua.hahnjy@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C03521C0003
X-Stat-Signature: m5hbu7ad1gt9bbxh515dfkzriwygfdny
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781639683-189349
X-HE-Meta: U2FsdGVkX18nnpvPRuEB1PE/ZcAifKQZ1cdnFGMD08ZDemggq+EgFM6avDv2xIMgdkLp1Cz12DtWR9DyNV1zNC1H1gwBuSB5SvMTIJxgOAEIL7GIP5Ag/UAGuuYFxND5hO2Nbmsex0pHEWlhRW+yfZtms5LgC/WO3k7Ck+DRzbsRNxF9l2UXXIRCcUCrATDVoPd2Y7itP8WFj6BrW7rCfXe/UpKR30jx/Qvkr8J6uOOMMReXDd5A1NxX7ShAde9ublCuZGh7Q5NU68bRz8jqFmOcmivHg2xamdGlCYwGYgxB6h/spU2mUFm8eXdg/bMZNkp4qqgpCrUYBiscU2+OWy3t+/s2jmgAg+qVdgXN5xirrkEBDWOG1d/LgBRsyEPhqhQZGoF/H9SLfJDL2t1buDKb2T6BLJY4MSGQgKxQMXWOJkUlV3kmIwQrnPL2iHLbwvCAlPPdOj9CCdjFi+CPVFPcVt2tvA+JAaQfCruL6p5rmzRnwWXIE1n+MglWR1lA5nOCME1xot5t2MNHOFit3KLBz7UR/X5zH4neiw+w8Bc5v1GGqesfoFKY56tqlokgLvyGzEaGOLOElJnWxL72scCH54+Q5cX0f/Aw+uk6zqX8puWFb7/Hzk3qlh0kvktKYLtpiD66dUZa2Gb7MQiPzcbUOhR7/3snlD3tOYhzzuG1MZWOh4xmFkRBnI/tdswFf5cfu6XbhpxaGBhS/0ZE7FICYR70VJFZSuV0Ek4n490vRR6NRHM/BB7el8pErMCA4YANxANvAvmL64+mF8P1SE8Xfe3CgFAJ36h0o6I0FJqToUrQxD/s25loaZImyY7cfIpnCIqVbUeeU2D+K63hFKc38q5J7Zxf4Ylu7Sgp1a3jqsyIBkeiGdjUke/4VD6pfUCyhLsNWIhaQlmmnOgsbTbxgzOGhbUjk4j+kqSHwHtfod9VfC+GxaWZ3Fy/HiXZ2e/uUNphKkHtaD6oUwp
 1SBL2wjS
 qxGjlvCKR6S/SOdhAa+tv1QEyzv6tJVGOTboQCoFHt6Zr+trjBHT630qOG4TsBM9Eid1TDXz96MjCZlxpgHez4sG0sXoKBw5Ztq0Vs5v1MnY6zXGLyRQrJVnZ8D2jVnHFfp/YEr8wltlsPEZ68S602dlQZRhQPb68JN49+w8YXUhfPx6YfUXbXSZbzmhQYrpGxlJ2TTqCxrNwthzoAgJwKGNaZH9+ELs0t7h4yMhzaTHbrxCgSCyZGSzYFJHlHEkl0YIphZxBZjurfQRUlUXj/9R5rLNkpvRyc3LHIEByVQ1E+56wbXhqlMYQDXHgUdmc7XhXrNtMbOElMQ21LXXn/WUkm3oram8hFwmtEwwDOWF6d2qV3DXbEXOMNruHqCtr5NO8xcTcJxTWgHNP8pCLX4LvxMq/RuwsMd0RRbcUPr8PGH6v9zLROCk/IA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 11:33=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Tue, Jun 16, 2026 at 1:31=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > On Mon, Jun 15, 2026 at 8:08=E2=80=AFPM YoungJun Park <youngjun.park@lg=
e.com> wrote:
> > >
> > > ...
> > > > - "zswap tier only": Only zswap is allowed. Fallback to other swap =
is
> > > >   blocked.
> > > > - "zswap writeback disabled": zswap is allowed, but if zswap_store(=
)
> > > >   fails, pages can still fall back to other swap devices.
> > >
> > > Upon double-checking the code, my previous clarification was wrong.
> > > You are right. Sorry for the confusion. "zswap tier only" is indeed
> > > equivalent to "zswap writeback disabled".
> > > (I'm not sure why I read the code that way...)
> > >
> > > As I initially thought, it might be possible to replace the zswap wri=
teback
> > > control with the tiering mechanism.
> > >
> > > If we need to keep the existing interface, we can integrate or share =
the
> > > underlying logic (though the specific details need more thought anywa=
y).
> > >
> > > It can be summarized as follows:
> > >
> > > - "zswap tier only" + "zswap writeback disable" -> meaningless (noop)
> > > - "zswap tier only" + "zswap writeback enable" -> meaningless (no wri=
tabck backend exist)
> > > - "zswap tier with other tiers" + "zswap writeback disable" -> uses o=
nly zswap
> > >   (can be replaced by "zswap tier only". This code could be intergrat=
ed, modified or something.)
> > > - "zswap tier with other tiers" + "zswap writeback enable" -> works a=
s is
>
> TBH, without vswap, we should not allow setting zswap as its own tier.
> It's meaningless. Maybe makes it a no-op, and warn users what they're
> setting is gibberish?

Why? vswap is transparent to the user. Why can't zswap be its own tier?

