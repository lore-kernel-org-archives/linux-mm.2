Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1825EC79F8C
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 22:26:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C0496B0088; Sun,  6 Sep 2026 18:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84A336B008A; Sun,  6 Sep 2026 18:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 712986B008C; Sun,  6 Sep 2026 18:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2DE946B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 18:26:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 80F8B1605E2
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 22:26:26 +0000 (UTC)
X-FDA: 85184772372.30.746085A
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf03.hostedemail.com (Postfix) with ESMTP id B397120002
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 22:26:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gt7RkFFA;
	spf=pass (imf03.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788733584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7BQEMgxoBllO/xAi8qxIuWvSKZOLcvy0DblUANoSGaY=;
	b=se3L074cusQoi6wWiD3CQ+/1iyXwSC/TKJzDJVJBitA0F2viowqgnJuAz7q++Yvdf8bMG5
	lo0XuIcLP/UNvNevKPZ0ZAioSFWo81ULEqc8ksItAJSKRXO4yk8ZVzTsoPIUkc4E8dEFZ1
	SLPmWBmzx42H+gePU46g1GJdLc9LtGQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788733584;
	b=wlHWmQvw+gJJth0Bx05/YFNflIIp7RajPUHDscsN5ApMVf6odpGreeHuSK0rV+TpY4Yl7A
	qm2cK3knDHNRWT/iuW29cC/gqBJKbnnb+a6L1O6PEv7drIKau9mVEW3qutQkmcMfTA12w+
	lF2SoI7Tjye98LmeBRbGujoPAJuHnk0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gt7RkFFA;
	spf=pass (imf03.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-398e9698a70so2483102a91.0
        for <linux-mm@kvack.org>; Sun, 06 Sep 2026 15:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788733583; x=1789338383; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7BQEMgxoBllO/xAi8qxIuWvSKZOLcvy0DblUANoSGaY=;
        b=gt7RkFFAoP54WtiJy+F5CBElERknLNIEHayrD8+WjW/tgosgem6NpiWgB0a5GP5Esc
         vSqP4qJjsN4loGGQ6sANsQSEoJ0qcV+LslwrucE1NW4vPEmZoD7dP94GHTiV2+vCOfy1
         n54tC7v3j5ZaNXyK5/otZKhJUI1PWusv6ZE6Ex8FGFBgdBL14piWEOGMyBMKm+AymtaA
         sTdxaXHWLTWg3cplPGsgOGU97ufV3mB+K0lg+BsQNIfQDAf3/tNCmNsidLwIk2ZZlg9G
         7Oe6EtwP6LlbjyaG32aekupNRfWhPmgDayoaa81vdF6X4j4/h39hX17IebPo/HW19Uzh
         Z8Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788733583; x=1789338383;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7BQEMgxoBllO/xAi8qxIuWvSKZOLcvy0DblUANoSGaY=;
        b=cUxYSK4vWvLDwZyGAxmeOxyvla57dTbqVvhk4jnccvR+KsZiZkRi8iQwdFHnDZO4hn
         4MuqSGpXvSVNNq5JGngb92xADhfAKIg/4HFffH7gp2gCynkzzavi0tb1J95r0MEvj8sY
         jYjbXV1u39GBw6+Xaysd2qv4+d/CzPRPQVjxvxzZ1E7bv71zJyLzMGhV1OcXblwcvTXs
         dlIYDky/CgyJ4Ddk1xyDHkA3yac2UftgrRsr7+ycApir00lwX2q0bexUkMNnCQpimxsG
         FKJ6tE84H/Hpll0wueb6ecPFyHM77Xb4yGfNUol2/n+JKeoqLY1ccnq2Xan2lVHPtPto
         7KlQ==
X-Forwarded-Encrypted: i=1; AKwUvBwfsbWc5RBvz9kJuUa9//t/PObcNpY6PUF2sgcoVCWQE7Y1nFNpVZN+jdyu9PPx1NeIlkvtGkFZLg==@kvack.org
X-Gm-Message-State: AFuF++mPCMKOw+CCQ58jk3viUFfJHbydCKxXSSl8PQmRUasL5C2igvKM
	l1vrwOqnyWGzvL2h1HH8pOMMzuXwDuLVjiUsRUIn8FfV5AogWzsKUGYS
X-Gm-Gg: AYBFou1SeOYT1lyJCSkJJ9PXrbMmYSoL2zmtwauq3Xn8yQdpxl0Oh2f6eLjNahqkSzf
	X9cRLdyyiZ/cUarhVOAQxDRHBRiBYyw8adMOE7ry8xVXE8ObvLmE7BBCfGL5jm6KHF4B0a7l5HN
	QLtmBvjiha8YvfbeQ2ozxD4QmGaSa3SCy8DBIaWQpOsfs/01JdScRAnk9QBRUsLqHz+/CtFdpYa
	IO/gZ5tYbfG47fnHj/nfiPJKvAwbfv4cKUbXH33SVTt54I0f7JPr0Bop1lwcLBoD33f6B23CV9O
	61wKo3ra0iyAjBVSfq1sbc0gLoqGHFK1n/95PsU70+GilDiQ0ms1N0iCtMrMmThbQCa9eRO2nNO
	1FBgjzKglG9+3uDYVObhdCaX97OS+75NfrX88bf3UDiQHi52c+W+UxDsx91a/Uzx0sOaRABbGV1
	8qG/CVKyh2Japm9o3EeNiBTqK39CnU3cmcaGU7JHiRDHoOdDH0mwQ/Ek0d0GrbrwiFCAunWEv8J
	jd2pRi9bWLgskSU
X-Received: by 2002:a17:90b:3d92:b0:398:bf7e:b267 with SMTP id 98e67ed59e1d1-39b2614df9dmr30677023a91.2.1788733583339;
        Sun, 06 Sep 2026 15:26:23 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:9c5:2de5:8b4e:3f3c:b637:4ca5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39ae8e0b117sm8413777a91.3.2026.09.06.15.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 15:26:22 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2.1] mm/damon/core: fix false positive in damos_quota_is_full() when esz is zero
Date: Mon,  7 Sep 2026 06:25:28 +0800
Message-ID: <20260906222633.4227-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260905161233.81892-1-sj@kernel.org>
References: <20260905161233.81892-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B397120002
X-Stat-Signature: aha7c9jxo8mrhcrq3ebkko5ks9d7qam9
X-HE-Tag: 1788733584-907873
X-HE-Meta: U2FsdGVkX1/fllvNVsNrdkJ040ob8yD8TZ6XSLVG35U9pzVvYu22leijmHXYyefSA34b2kg1waSXw/bzoDq/8T7VjhdIvO6zwkXEUrOtiF0QR6/nOXgYvi9xT3vXVnxS8RCEuwLF/slYcrSlusa7x+oQezHkMEy87DQK2+63ZVIbdxucZnnzs+ClzN+9+WR8ToomIj7LKqFT8xHgUDpC+Tp7fqI94vVEdkzhTNFXqtaIVqJbBmdRU8iq6BYGYQSre6stQ7gP+LuqAQ4t09U3tGbdP45xMTbDuR0CLf3h7qGPXOpJcldNSIc9lrqCbEz20LF4sopwTfR9/2fFpLkZ17Lw94R7DuDZtd574TPgn13TKD5ac/45ZJsC3DUX/7jQ/KXtCzieZGQVniwBX4v+zYf9bcxLRIDQO+k+2ZYWdKt/1hnaTkMes29Nqgcav6f0INC0mc7alkxPdUkWpvnnI4LkUSd7RhhWSYzB1mFEXFdZ1Aj3haakZip0OAgY9ZCwZykLSfFHc4HJdAfOZ7VsUT5yWua4VXMIpWa0FcaqQwl18CBuJoOwFVvFpOkJj6/zY28jFN7NYSoL74XgNJy7gz1cXvlKPemYdG6/Uuouxq8MT55dwX+zpvFhCUAKqdGb3S7AET/EUy3eX81EocYg6AsziFnayOyPuy+XF9VX1wlCCnAvMIbVZbUuQQWoHn/2M9karX0m4SzKHD7THQVL+H4d8xLI+CDrvYK/iRwQWieDOX9OTdaXlrAPB6yM3k7OZajbZqvWWpf5/rBIHVYubmNVjdpC6kowzPxVsn9VqIgEr6y7sN7isqwtNkwdtMH3xeuDEVClVlU+eIxakOmLxvPWXmZagsifBF8ugqP+KEgLMAjAYJTEuXZrJpM6/A7U+ukmWztSYOLiZvddGUiwIB1Q0uiad3KJtEW0REWgzU979WOsl+5Y/qUQZDpB/AverAE7az9L+9Jm/foZ16X
 ma40SQ9t
 cOQG4Vn7EYER4MFb5fwBo48NPEbo7M8tfVQ+aWS2sGmh9gwrYaryXpDLl6l6ufZKMo0DLAmBkVtaTduSAiI7xA0tXamhtSMfwACB736KtpWr+7BCQN1oBqWAh+andeV0J6dcd+iUO4W8Hl/7AU2YEbUUg8WZ8zSHRefeU3jhe72CAHsxkpRmvoZfZSSr08OnpUfrMU/Kr4o2vqztWcSwZinzZq+EZlXV34xEMLIwuUDmfhVikTAspVWoPsbdPcJqGuiK9N4+LC1PDphG2jLWoqqWFxyngIHlmExxPEGL79ZiHL+7v02IsIsz0aLBuN8IEh69/LN6drxqPuYPoWRfI6iWZjWf09HHAQg1dCEY8JAwWOu69Atg4HTzRBQ+TgYo3643ReuId5sZoGgC3IQFiS/qWamQv0OfqY8bnLQptCxiA5tq2Sk8knqyalde0zepMUFTbFYJqp3JQ8xKL4WdVs7eOzjBz7w2BO2UsKkMkFbayWxc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 05 Sep 2026 09:12:33 -0700 SJ Park <sj@kernel.org> wrote:

> On Sat,  5 Sep 2026 18:36:58 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > On Fri, 04 Sep 2026 17:25:34 -0700 SJ Park <sj@kernel.org> wrote:
> > 
> > > On Fri,  4 Sep 2026 23:35:38 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > > 
> > > > That said, it's not important for me to add explanations to the
> > > > document, but may I know why commit [2] changed the behavior which
> > > > introduced by commit [1]?
> > > > 
> > > > Commit [1] Behavior:
> > > > 
> > > >     if (quota->esz && quota->changed_sz >= quota->esz)
> > > >         s->stat.qt_exceeds++;
> > > > 
> > > > Commit [2] Behavior:
> > > > 
> > > >     if (damos_quota_is_full(quota, c->min_region_sz))
> > > >         s->stat.qt_exceeds++;
> > > > 
> > > > Before commit [2], qt_exceeds will only increase when quota->esz is not
> > > > zero, but after commit [2], qt_exceeds also increase even when
> > > > quota->esz is zero.  I'd love to understand the rationale behind this
> > > > change to better grasp the design evolution.
> > > > 
> > > > [1] 6268eac34ca30 ("mm/damon/schemes: account how many times quota limit has exceeded")
> > > >     (Fri Jan 14 14:10:20 2022 -0800)
> > > > [2] c7ec7d5f6b3d1 ("mm/damon/core: handle <min_region_sz remaining quota as empty")
> > > >     (Mon Apr 27 18:33:50 2026 -0700)
> > > 
> > > Seems commit c7ec7d5f6b3d1 didn't make a behavior change that you are
> > > describing.
> > 
> > I actually wanted to point out the behavior difference between commit [1]
> > and [2], but I've understood and agreed with your point.
> > 
> > > 
> > > '''
> > > $ git show c7ec7d5f6b3d1
> > > [...]
> > > @@ -2601,8 +2613,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
> > >         if (!time_in_range_open(jiffies, quota->charged_from,
> > >                                 quota->charged_from +
> > >                                 msecs_to_jiffies(quota->reset_interval))) {
> > > -               if (damos_quota_is_set(quota) &&
> > > -                               quota->charged_sz >= quota->esz)
> > > +               if (damos_quota_is_full(quota, c->min_region_sz))
> > >                         s->stat.qt_exceeds++;
> > >                 quota->total_charged_sz += quota->charged_sz;
> > >                 quota->charged_from = jiffies;
> > > '''
> > > 
> > > And I don't think there was a behavior change.  Hopefully commit 54419bbd0ee3
> > > ("mm/damon/core: allow quota goals set zero effective size quota") will give
> > > you some clues.
> > 
> > Thank you very much for your clarifying :>
> > 
> > Now I completely understand why there is different behavior
> 
> I told you I don't think there was a behavior change.  I still think so.
> 
> > between
> > commit [1] and [2].  Because in commit [1], esz==0 only means quota is
> > unlimited.
> 
> No.  Commit 54419bbd0ee3 says "DAMON core assumes zero effective quota means
> the user has set no quota."
> 
> 
> > After commit 54419bbd0ee3, esz==0 also can means do not have
> > quota at all.
> 
> That's what the commit is describing the before-commit status...
> 
> > But the qt_exceeds should just not increase when quota is
> > unlimited, that's why the current implementation is completely correct.
> 
> There is no unlimited quota.  Hence I don't understand what you are saying
> here.  Please carefully read the commit message again.

Thank you for the detailed explanation, and sorry for my confusing
wording.  Let me confirm my corrected understanding:

Before commit 54419bbd0ee3, esz == 0 appeared only when the quota was
unset, i.e., the user has set no quota.  DAMON core therefore assumed
zero effective quota means the user has set no quota, and the code
checked quota->esz to tell whether a quota is set.  Commit 54419bbd0ee3
decoupled "quota is set" from "esz != 0" by introducing
damos_quota_is_set().  After that, the temporal goal tuner
(af738a6a00c1f) made it possible for a set quota to have esz == 0 as
well, for example once its goal is over-achieved.  In that case the
scheme is intentionally deactivated, and counting qt_exceeds is intended,
not a bug.

Commit c7ec7d5f6b3d1 did not change the behavior I asked about; it only
refactored the check into damos_quota_is_full().

I will send a documentation patch in the near future.  Thank you again
for your patience.

Best regards,
Rui Yan

