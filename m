Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AABB106ACF3
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 23:00:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B33596B0088; Thu, 12 Mar 2026 19:00:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B14566B008A; Thu, 12 Mar 2026 19:00:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A16916B008C; Thu, 12 Mar 2026 19:00:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91A356B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:00:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0FCCC16047E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 23:00:58 +0000 (UTC)
X-FDA: 84538932996.07.16C124F
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf08.hostedemail.com (Postfix) with ESMTP id 33195160003
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 23:00:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Bqw5yFmT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3pkWzaQkKCFMv63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3pkWzaQkKCFMv63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773356456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RahmB0SI0/OXu1AwTitQIvAtW4esW43+GBpFJHtqabU=;
	b=loHrqqu6Szg2xfIKFwVCYOFNpn88drRsjDfxCKTL9W5vPklUl9N5yEBdV4R378jNolFNfV
	GwdYLa1B52STrvt4ka1RBh3JqJ4SkjKrvcATGdhcADeO90K4gHKJlwtui1dnH3Rl/wkqIc
	cFuyiBXk2YrOG+9wy4m3p17DWRnb4Pc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773356456; a=rsa-sha256;
	cv=none;
	b=K7hUWvy6hGpRxESBx9YFh+5pX14qMKLt6HPx4jS7A+TGeGpIaiGkLv2DnVU4k3ct2e8iY4
	8f9N87BTlRNix9qL8e0xA2IW4FRfoWmXkLDb4IT3C77kTlQ3Q4XChg3d5u77cUYmymlBOy
	BmE3zEFgdCQiTk6jnMhmUJEX8isUTDg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Bqw5yFmT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3pkWzaQkKCFMv63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3pkWzaQkKCFMv63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4853ab1cae0so15834375e9.2
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773356454; x=1773961254; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RahmB0SI0/OXu1AwTitQIvAtW4esW43+GBpFJHtqabU=;
        b=Bqw5yFmTYS7q2lWvSuiR3nRb+javHh7B7xCZS9Nnv7GdyCsWlpgbZ56lMu7maCYLM5
         FPT/wZ4TSp11b9r6Z6pUhPo0oLrZiFkfcEygcvYRjR97MxpWulloDGf6zq+xJqSuqCQE
         6694gS0l0/Pqq13ymMT1PTn56Y1r6TJg+G07ltAiIrXKjQGlI3kS4TroU/+RVQsnu7E5
         eMjQ9jxIhvSeOvFN1VTfBtIuvY5y/peRoTzHUfuQMI9580EyZDi0oQmDHWbkEmOy1aYO
         RogSTdXTuq97byfVV3oSOtE7s35ExcGaB/2KE4UU+NXlBvIHwI0ElH4dY8RzayF9qLa2
         9x+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773356454; x=1773961254;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RahmB0SI0/OXu1AwTitQIvAtW4esW43+GBpFJHtqabU=;
        b=Vz0cmdbED+bDRywgkyOoJiayTitGah1TsPX5NjjP50EdgxmSBFFVynFP+UGGDGv/qx
         99tqe4zpkdZP8gaxSswEN+0G00zERVOn6BRn0IIxURYjl9aBn1NQqXIjfTaOK6+6CtgC
         Eyp/m+sjZ+aOlb5c0GMB12JEFGb+qRgt50FzRtAe6GjbGgyw0ZpRs9pjk+EWhwg0gkzD
         Wal+cRbacgrrNaPqa5xyIHrkpJhDu4C5QtXim7WSjUqZ4mg4WURtk7ZsQkv00zWyADx6
         PicqiakmBiuObmlTyG+8CJFw/PSU/8eAaJLBDOquerpEV3/NaHT261menP3CYFcjma/J
         ncQg==
X-Forwarded-Encrypted: i=1; AJvYcCVbKdVCy9NeS8YW7hupN3QnWhjuI0QXXxvz09/FvprNEWQES4bMGqaISjZFRqTY60f9rwOJBYLhWQ==@kvack.org
X-Gm-Message-State: AOJu0YxCh5lwrmYXyhMDhkP11SRQnGw6aCyTC82N2GP6KWPtE7WCVtyc
	3YkigAgHz31Vxlk7BDgH5wx9P0+srCYx78hHqAJyyQ5/ilKiFDj+gm/gPjjp8mcgUvz+kGFZZ8c
	ITmRJzW7GDidVjgmBeg==
X-Received: from wmoo20.prod.google.com ([2002:a05:600d:114:b0:483:a1ee:5eb8])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:698e:b0:483:1403:c47f with SMTP id 5b1f17b1804b1-485566ca5cdmr17223985e9.6.1773356454305;
 Thu, 12 Mar 2026 16:00:54 -0700 (PDT)
Date: Thu, 12 Mar 2026 23:00:53 +0000
In-Reply-To: <b6327414-237a-4262-bf07-c506908fa263@gmail.com>
Mime-Version: 1.0
References: <20260312184054.23481-1-objecting@objecting.org>
 <20260312134531.49c1f9171b4b0bc8352e678d@linux-foundation.org> <b6327414-237a-4262-bf07-c506908fa263@gmail.com>
Message-ID: <abNFpSjrhJYr2e_n@google.com>
Subject: Re: [PATCH 1/3] lib/maple_tree: fix potential NULL dereference in mas_pop_node()
From: Alice Ryhl <aliceryhl@google.com>
To: Josh Law <hlcj1234567@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, Josh Law <objecting@objecting.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 33195160003
X-Stat-Signature: an1n5aupht7efrudycis8jugic3pjr4a
X-Rspam-User: 
X-HE-Tag: 1773356455-391463
X-HE-Meta: U2FsdGVkX1/m0uZjkzFZnkZsRR+1+N+hoaP6XooaFmHV3ftClFy8c05Q47zCWhzhypte8FkhNZ4slypgT5EKuSN1Vb+0Zr+jS//tQiNKntG6cvCHmTILHXaBoSvuFH0oqJpdBbU6aA26yfBzd9biofZLqNlq1ET9ElVsikLn5kNXUxMbGv/0odUEzWzvW9kAQnMDAdTx8/pg/NyN+kSCRodrczw58dVX310NY2bgo6FYfuPRQzRKvz4LuSgMBWDFxuRAcpSscU5ANhFpnieGQu0cYfDhNL7zkIxZxYn22jqaOfxKAhvleMU+syjV6ZGpi00n7gQVLzbWQv8etuuzbkoyxsBObqj5XEJzG4bsC2iFCkhKqvGZNtV1t+MOvxgeLi4WKFh3/jATLAZrIM/X5KZ9YWXYVFRpsj92Q5D26KfhCgjWVmZHlIovPbhnjoB3CZ2EvNTtG7mHQZcZF7fKjRPfXOcoovadFrUQYMMfrRprmXX3t5X9Y9fhgbYLER/rA6LMwDyXEay3nvJhWd4e98CS6ltw95xjuNHY1e38DQaSziv2Cwk2tei7wx+JF3NM9XNYjFSnY2/hMum2IR/6Tx2RVGldWn4Tn1/f8LjOKZG02Wrogp+fQeTeQrQZZJsF/DkPs0NLhy6YdmExvGuZ4Vj06jgZ4Cpo8mAYBSPb98/jKGQQo1nmgv6D2A54vvk3LO9Z4o57h0dRrioo8/X4/R/Aga2nLOkYUJOFx4JzogX4DCSQOJBKcoRqCyPYur7u185luLkur9Gaqh1LdIRnuUNPNUMuL4GJhH/ALoWQdVHndBY3aDkxukYfuzxubv2Hi9uEkmC3Vll5QeQF8DVAQPi6hZVD5VTAcmu07aJBTdVKPiAfbJP4EZSr/xblTPrxUtoWg9dyvlksIP69Vis9vNQUjVOHXQPfMSLYl4ywxFeJk+lDQQBmzvFpduxFOnxBWGu+pO3P/krbe+Chv02
 I8c9uVty
 O08rIsa0ahtyNmgKU+8rW8vG+Uyh2amcQdYDO+sBy+MrOMEfgAz085ixhwd4e0Nc+GDVsD8DaZI6S6uwRns65O9s5JAeampAz5qbNQhX/XSLgQvAF5jHdioRXWOvl9VjhSjtpwjyRhTYxvt2n5rsMVuIfngHpJr5aLPAUx+/k+whwH367mvl8WFjbR9xiFgQz7raEweCmfUPc+sNTx/fE/gFl9ZOMJKJ4qLDN6teTp8+2etOJCUvzxmPwLxecdgzG4DK95RUMB06b+r+OPpLscxaTwNythfK16tJGHroQ8DOM6jS90ZsoZEbWle+DHduM3q5Mn5Elb2mSB6fge/uB9CPXbTbrWEfyYYUsrZRWuJDEB4KHr+p7s36aIe7qqywJa5OAkiJMCe43LbeSZi+cd3wwU4UoKeG5vNTPs9iJmezOQxEiFPkyLG5LF5oXubsKYE33wioxHJYlKoINBIc7qjX0BTuWKH6HdmQHAbzkS26Na/dT9xDoPbHKOb4Z4RsmSoC0rnBl0dH5jplz95MB4qPlWszaFixdGGzZvxiM7/Za+Th5SWxOE+49a+gFZtfOdNGutfKOMnOBuiG0Od6jzMuD2t/q1gz0T4rs11oIU5vGR4RZu04FbbTmJpAODnWsmo/uZeRkb1zps+LcLb7XlGo7/R81TZZTtVMpHCk6Of9lsd9IdGFVOW/jT+3RXYaEpGXYQQ7tn7sonXj+6Z3qV8bZyfM4lRibSmMZ475wym2xmaa/O5ebXSE/Xu1xCKOlzMSir4lZ6GtwN+PMD/H0jGClXusjjWyoroKVm97VGfnOGuU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 08:49:20PM +0000, Josh Law wrote:
> 12 Mar 2026 20:45:32 Andrew Morton <akpm@linux-foundation.org>:
>=20
> > On Thu, 12 Mar 2026 18:40:53 +0000 Josh Law <hlcj1234567@gmail.com> wro=
te:
> >
> >> If kmem_cache_alloc_from_sheaf() returns NULL (possible under
> >> GFP_NOWAIT pressure), mas_pop_node() falls through to the out label
> >> and dereferences the NULL pointer in memset(ret, 0, sizeof(*ret)).
> >
> > This is such a glaring bug that I wonder if we're missing something.
> >
> >> Add a WARN_ON_ONCE NULL check after the sheaf allocation to bail out
> >> early, matching the existing pattern for the !mas->sheaf case above.
> >>
> >> Signed-off-by: Josh Law <objecting@objecting.org>
> >> ---
> >> lib/maple_tree.c | 2 ++
> >> 1 file changed, 2 insertions(+)
> >>
> >> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> >> index 739918e859e5..87a2ba6468ca 100644
> >> --- a/lib/maple_tree.c
> >> +++ b/lib/maple_tree.c
> >> @@ -1063,6 +1063,8 @@ static __always_inline struct maple_node *mas_po=
p_node(struct ma_state *mas)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return NULL;
> >>
> >> =C2=A0=C2=A0=C2=A0 ret =3D kmem_cache_alloc_from_sheaf(maple_node_cach=
e, GFP_NOWAIT, mas->sheaf);
> >> +=C2=A0=C2=A0 if (WARN_ON_ONCE(!ret))
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return NULL;
> >
> > If we're going to do this then we may as well restore !__GFP_NOWARN,
> > get more relevant information.
> >
> > But a GFP_NOWAIT allocation attempt can fail relatively easily so
> > callers must be equipped to handle it - perhaps no need for any
> > warning.
>=20
> Well, fair enough, but WARN_ON is equivalent to a "oops! Something
> went wrong! We will continue anyway", NOWARN is quite bad for logging
> that that went wrong, usually it's BUG_ON that causes said kernel
> panics and that, which is a bit overkill, that's why I didn't add it,
> and it warns once, then bails, that's why I'm a bit on the iffy side
> about adding NOWARN, what's your opinion on this, do you think a
> NOWARN is better then warn on once?

The WARN_ON option must only be used for conditions that indicate a
kernel bug. Memory pressure is not a kernel bug, so WARN_ON is wrong
here. In fact, depending on kernel configuration, WARN_ON_ONCE may crash
the kernel.

Alice

