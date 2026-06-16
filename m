Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4257FCD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:09:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30CCE6B00E0; Tue, 16 Jun 2026 17:09:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E4AF6B00E2; Tue, 16 Jun 2026 17:09:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FAEB6B00E3; Tue, 16 Jun 2026 17:09:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9F7C6B00E0
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:09:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A64611401E9
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:31:17 +0000 (UTC)
X-FDA: 84886466994.21.509FE5A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id B3762A0012
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:31:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X3w7nHsy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781631075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WVV5qnuazsXM93UQJWpV+Y+mNZmy8LyDox+BmjJrU+s=;
	b=E09srxgwLzAFa74gJ7Srxx7uUBJNUl12xySuHN+95cBahf3CsMWz4D6PPVc5wh+I3T/yi8
	h1OxC1K73EpW+SuNvycZsWFxGwdz9QMH7YRnYKaigGbTyaD58m0SWsUYys/fS3zsTPuAqR
	eyehFq/sikA41ixClYirIHSgZRWZllk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X3w7nHsy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781631075;
	b=R73YqzMCyGvNCn42GkXen1swkSX484XePrxWjF6ptD/+h8F8k5r3hZQasMyIzCCevQXV/q
	+jf/48mY0zAfH/efAGjqZ8up8zE34o/VCipy5IuVyHsA0PsqQf/PEUX1QV5gND0BAAI4b5
	0WWDUg/GDb3KRzgnPlfM8aSN6uf8ksQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3AA1360137
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52151F00A3D
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781631072;
	bh=WVV5qnuazsXM93UQJWpV+Y+mNZmy8LyDox+BmjJrU+s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=X3w7nHsydopsmdHj7nw/UjEnhvA8C3Ys92eDGlhDu56KnfPGiKAbcDzMVjXVqenRa
	 M9+Dykl9JYHalHKhzgcSs1DxvUNs1jHlLudUM7yfd4kBJCM5cQmibGJ1aevI3nefOc
	 BK4CDHfvJt2hSsRez+hKODMSxteaZU4AxKTqdf/Wg2km31eyZLwFjHLITy76tfQGKc
	 VAy6cnS+V4QHSQnQjxghRjHvXhiDwbl+kEhNjGg9Jzi1OgttdCPhQsBXGyggxXMoBh
	 NuhYd+woC/Pgbzax5ckIZxKRnqNnIQz30GP9HzzX6B/x4RR5RBo/cwwRjwZIk3ZCbS
	 jyZ05mURd8GmQ==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-bef1e6423e7so530836566b.1
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 10:31:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/ctLYzTbsatoX/P/woL3MfYZxsti5WqFGSmqg2P6BOFQll8Hye6arJUdgNHmYLkqFCiNh8ZH52TA==@kvack.org
X-Gm-Message-State: AOJu0YxAzonVx3FchbDOat7AsotzXJcSuOfngd0q29bu8ccCSGQ8cSDO
	m0lyOPNjOwkLz8oMiGuj5dULeLnMkqDOjkMFb0vtLJCvz+wtCbYakl/o2/CZBHVbAIBIV2fq+UT
	SDxi+znrJq+yTgbqmRhDFut7p4dGuYU8=
X-Received: by 2002:a17:907:c1a:b0:beb:b53d:4839 with SMTP id
 a640c23a62f3a-c05a6bd7018mr44427666b.33.1781631071598; Tue, 16 Jun 2026
 10:31:11 -0700 (PDT)
MIME-Version: 1.0
References: <aictKA0XWMWbxFdN@linux.dev> <CAO9r8zPvCaCqvoUhPdAN5Oi_Sj0mK-t7DJhOOz3Xf1DT-Wrgcw@mail.gmail.com>
 <aieUQUBHI+E3uNPW@yjaykim-PowerEdge-T330> <airzE7jD9UtyR17J@google.com>
 <aisEWnb3pzmVC4dl@linux.dev> <aiu06fbV7rWqY0Bm@yjaykim-PowerEdge-T330>
 <aiw2p5ANjsQUCIHA@linux.dev> <ai5y923elCSZp41j@yjaykim-PowerEdge-T330>
 <CAO9r8zOVqbJEaBqTHw=r2bYw7Lm1tO0TU9QuG+eH1rfqcTAJJQ@mail.gmail.com>
 <ajCgzNIPLhjTRSXR@yjaykim-PowerEdge-T330> <ajC+FNpkVpI4pbBz@yjaykim-PowerEdge-T330>
In-Reply-To: <ajC+FNpkVpI4pbBz@yjaykim-PowerEdge-T330>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 16 Jun 2026 10:30:59 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMimM8n54BL1viuX3pYzO=wzQU89LhCF1HW0bAv97ZQtg@mail.gmail.com>
X-Gm-Features: AVVi8CfvlTpa8wwRc_d-snmqbqbbbY8sLFpgryNiKy5mHm820TJFiip5SD6Te9E
Message-ID: <CAO9r8zMimM8n54BL1viuX3pYzO=wzQU89LhCF1HW0bAv97ZQtg@mail.gmail.com>
Subject: Re: [swap tier discussion] Re: [PATCH v3 2/4] mm/zswap: Implement
 proactive writeback
To: YoungJun Park <youngjun.park@lge.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Hao Jia <jiahao.kernel@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org, tj@kernel.org, mkoutny@suse.com, 
	roman.gushchin@linux.dev, Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>, chrisl@kernel.org, kasong@tencent.com, 
	baoquan.he@linux.dev, joshua.hahnjy@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B3762A0012
X-Stat-Signature: jt3bcf6bxoy7883aywt179itnaydpsoe
X-Rspam-User: 
X-HE-Tag: 1781631075-21835
X-HE-Meta: U2FsdGVkX1/6yO1y6BUVDQWjQnJth2c09SD4SCEnsFK4PgrQII9L3hMDWevlZBi9mrLeBAqcWDYsxTkquoCIbBU5maYPzwamcRQHe/2GJkdyyUZOmtG5453Rem3mbr5LH4fiy8EbpDSAOV2bdYJCcVGYsOwVWggoZKDWvREe/H9BQN97vLiYp7BwQUnEMgKsDFiic0SzanOd2GjMVp7yQV2CT7L/X7kDw4VFW4V2MJW3bcskyJIr+MX++JjAtXj1ncfmGIY62Dt2W/gRJw/ijDpOcP5GuSl4LYvNcdS96NjmsBp5NxJL0EiRAhUw41xLqy9hfQDHaXqA0EWwow975aSaVK/A/5jwwCftyNA1IVdzGoRcJyIS1SFxW/SV1z2E0mmBUgPaJF40BigE99RHWptyJOQfD95bq14PpDo8N1YmSH0OBQuSivZU3pMx7GidrB+fmJ0ZFgULc97wof+7JOp2pOBMwTIN2WLB7gRtLs+rNueninPyHzz8a17+9BACHXz+3JpAvbQlIuB18MTvO3lo9iSadbZqJlfuzNKbyOwl3AAdNzoQ/khBbtIF0iyMllD9rpMlt9bBUAL33hrvo+pwvI5a8mSiU8nHIYNGt3RmAYBTA+N8z1UsX8Z0S+5rpBMLQedfcXdWZZ1Dj81zZGH8y66VuA26qZKnpgZw8X5/Zrdcr8WQ8axK2ezqJZcDDbZluaZoohU6ct4o8Y9re07b9ARvSTt4FGVWDBhSiSRaZ35U7gIxOebAwBwtsmXMZIQtwoRcHr5BYzWdr0dzQ5YAajr2zfVMSn4HOaUa9pePKO0T5l8iUq5dmtv4iSBFd/TQFCUX0MSSLI3nPuGYejTjJAvgrTw2/XWKIiP0cK7LOZHckdliZcnEZ7EhCrF/E9Tspj1E4Oe/7Biwlm3KA8GdVuLqYWlTIWsXB5Xjb/dLuLGpqrdYB0QWRUrS5dC65qofUuyI0VHDg842J/M
 3kaUvvP/
 SxQJj6xGoGBO/qS0crNDhFJgwjtzpJdOIKTWZaDjHLGIf+hfhMYmZz8RWKptbx1yY24yEaZdeIegXXz+fruXeCRcHVZccMMTUsH9kd+KtCByuUe3veo5llneQs5x3RZ+zoQZO1Vajf1UVwBp4u6ldmyWuyH7wKwSBG9LzzcrOKMsPgOm1NJnX+o73aEJ0SlPI3Cv8zWfXcYmIi8QK3GCJvgT+t66dUQmTs+qeeZcWWXMgUTa9Yj5GwhHHJueUwcKdwUEhHt9u3NYnggZUUXhgcw5DvWCgUkW/5ZCi9aA88b15QL6aIvraelSi2EqAZrkzY8N/mJxPehrkP7AjxIRHWGkfFzG6I0vDVm4evxLMrHWEevdidzeVPFJL+oecPXiVxj9b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 15, 2026 at 8:08=E2=80=AFPM YoungJun Park <youngjun.park@lge.co=
m> wrote:
>
> ...
> > - "zswap tier only": Only zswap is allowed. Fallback to other swap is
> >   blocked.
> > - "zswap writeback disabled": zswap is allowed, but if zswap_store()
> >   fails, pages can still fall back to other swap devices.
>
> Upon double-checking the code, my previous clarification was wrong.
> You are right. Sorry for the confusion. "zswap tier only" is indeed
> equivalent to "zswap writeback disabled".
> (I'm not sure why I read the code that way...)
>
> As I initially thought, it might be possible to replace the zswap writeba=
ck
> control with the tiering mechanism.
>
> If we need to keep the existing interface, we can integrate or share the
> underlying logic (though the specific details need more thought anyway).
>
> It can be summarized as follows:
>
> - "zswap tier only" + "zswap writeback disable" -> meaningless (noop)
> - "zswap tier only" + "zswap writeback enable" -> meaningless (no writabc=
k backend exist)
> - "zswap tier with other tiers" + "zswap writeback disable" -> uses only =
zswap
>   (can be replaced by "zswap tier only". This code could be intergrated, =
modified or something.)
> - "zswap tier with other tiers" + "zswap writeback enable" -> works as is

Hmm we might want to somehow disable memory.zswap.writeback if tiering
is enabled, to avoid having to deal with this. But I am not sure how
possible this is.

If swap tiering is behind a config option, maybe we can disable
memory.zswap.writeback under that config option? But then if distros
start enabling the config option it might break some users. Not sure
what's the right way to do this, but having both interfaces active at
the same time is annoying.

>
> As mentioned in the previous email, the zswap tier on/off control comes a=
s a
> bonus (though, as you pointed out, we may need to discuss if it's actuall=
y
> needed).
>
> BR,
> Youngjun

