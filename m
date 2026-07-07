Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF70FC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 18:28:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC8AC6B009D; Tue,  7 Jul 2026 14:28:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7A056B00A0; Tue,  7 Jul 2026 14:28:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8E2A6B00A1; Tue,  7 Jul 2026 14:28:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67CCF6B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:28:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D34D14053D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:28:45 +0000 (UTC)
X-FDA: 84962816610.18.D320E6B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id DB324180005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:28:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NFGJ6LFw;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783448924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0dH8JAh1G57HMXaVWGg//6vzyB5YjbMb2cp9YI+w6Tk=;
	b=IU9KF1DEItZD7LQzyr7KV/tBKvnCzVeTYkFSsH/QiXnNOjxgj/NvmvSEsB5+776vaT+yal
	HuQnJL6D/iq9axbvOGx3Uiigq3AsbRtoU7e0ERAFLN+qlEQ9w9kSIA/K2Ef1IIHrs7+PsM
	1qlkpHviJGLvbmpzp31xVm8MAdvEQL4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NFGJ6LFw;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783448924;
	b=rjk97pYukZXlMWc1P6cF6O0NkbY5tXLdfjQEM59PVan1yHq1XL4cUi8aP1XlM0Y8tcZtlH
	0hJWc2ozRRE9y5YWtS9hZvEN+RShYgKN9LdTMMO0d1v4wtw+EUmcqzbkd5OEOf5mWO1BZ3
	S54IyS7yhI2QBL56O0kS6M+Vu6903Jk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C2CBC43F69
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:28:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC6F1F0155B
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783448922;
	bh=0dH8JAh1G57HMXaVWGg//6vzyB5YjbMb2cp9YI+w6Tk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NFGJ6LFwMM0wniwHQRAFhpZcxkzXXZ+go5O3i2PpdW0RgRJSN8TdzgkZqSUvQQJwF
	 MQmwUJb/vut4/QI97wjiJEf7sZvAQmdV7Rgd4epLjc+1snU2BouoclzM/0do2pntnU
	 h/Am3/IAufzyAMNG73/Fc+iqb18RprupfmBdVicN+byvPY8mt4FOBzdfVWPi1VR3xW
	 1qdaOLfmatCRCbm6rQ9zDIcBCgbA67cemDG4HPpZ6ibwYF0nQ9ybUbg64Rp5BZnf/U
	 SHtdhRBDaiJB7AHMCD6GpTms0Lr9ec78ID/sVzYlYjFaguzd4xG5Cyb6wp4lQfILPt
	 IdZzN2HypcjwA==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6976b0c5adbso8306533a12.2
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 11:28:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rp+cGG/lPgMoUdFqD8lhpkWeS8++K/HcsDyU9dMKeWPtOTP3uan7G/IprJGHkKcMTPrzSk2CpBifw==@kvack.org
X-Gm-Message-State: AOJu0YxVl6AZ4HN9GwJ3nbjPLfFiNn/YmTs1EheZV/3/I2naWftz6Agn
	R5IV3UHjsBYOIQSvc9A5C46Kj0Ciga2KGRv12E2LGi7o1R3xyv2yVAfVJrzzOx8VA1/RMm6LD3U
	PKBLCJadFEpY+GkUG3xvWv2By1I286Dw=
X-Received: by 2002:a17:907:25c5:b0:c12:7f26:a279 with SMTP id
 a640c23a62f3a-c15a680d0bbmr487638466b.23.1783448921599; Tue, 07 Jul 2026
 11:28:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260706081218.3438762-1-richardycc@google.com>
 <akxiZryteM-mwlyz@google.com> <CALC_0q-9JEbSH8dc0ecMzZU34rjVKzqaFYuoqjP2x8cE3UDo7A@mail.gmail.com>
In-Reply-To: <CALC_0q-9JEbSH8dc0ecMzZU34rjVKzqaFYuoqjP2x8cE3UDo7A@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 7 Jul 2026 11:28:29 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOyfXgQoee4c2+G_8whgb6Nq86B_yw0fARwdy=or0uBuQ@mail.gmail.com>
X-Gm-Features: AVVi8CcB1qCEDIvapMeK1t0hPshctDu160D2ocIJ-xaWRXpuClIlmKOhMx9VWwg
Message-ID: <CAO9r8zOyfXgQoee4c2+G_8whgb6Nq86B_yw0fARwdy=or0uBuQ@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: abort proactive reclaim early when freezing
To: Richard Chang <richardycc@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	"T . J . Mercier" <tjmercier@google.com>, Martin Liu <liumartin@google.com>, 
	Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DB324180005
X-Stat-Signature: rfxkq96xwdtigipfdaj6z9xp8r98143f
X-HE-Tag: 1783448923-353070
X-HE-Meta: U2FsdGVkX19cwZ1Ks1k+ViAZZRD45uAfjPFk4g8xGAZJ0MkJJ0Qt2PXTHIkfNzbVvx6xMWsR1HNK9EQiZZ9UtgLpUP/haOPkimH75hhmmc5UY0FE1cWSqe9L1WKsU7ijnrlNXJm9McbcQM3ozNo4McvrmYvoNvapdT9FEunxK53VeruILk82ymvVpnZ0K9Fo2xGCCwKNOoqBolA01NP2zZn+SQL71oa9S2IZJdAJAt2mEqUy7mmHWJ+lKlMHgjOYe4NtncEVl/71sEkS1OstUHNGXXsmiurXShln6INt3qU1qB8zq8srQD6h7wShvyGMKJtqCoSZ768PqnEHuGZYo64bpOXTItlbkEwn+K2fjI+LvUKTr5SHpzaMvY51fIkEMLdxgEz/uQfs3s2IqxUugdrMS4B/FkP9ly2vC7JhlZiC22zWt7slzrs2P88H+LwKyem9ybDDsdheSgsf8jFhNIC/mahGnF9SVFrGYox2juW0TmMODLlVgGql5/tW953hqOCyFU8pMFEKZQCd9WI/JAaNXyBehBGE8IQi/l7F5KMB7uLDchOTo0NFsAEy1TawZaP1+U3R8BrcfhsX44LCpzGKqUJNDHXrva6DKBze6Wz9mejWH+jUQRkq4DJKeT0Ocw6kvUjW09sMdN8jZg+y+dtXeRof5bkeO1u3LFJHtwrNhwS7EEH4rdgkwBD0XMbxCKyxa8bS17ibZCOcllfepJpxaTwL0du0zEPJUHwtKZzO4elJvzMSq5L2iOul9OO00M8akp17cTKri7GqNkrRhASZcCGNrAP6qPiBRpTluebzSPFkSceEKPeBVHWe0KEJKQI/4/dkl+OBZIXUm23dI3sAXZ2r3VPH7wSeEKrIrKC414Hb0BZ/4Qm27M539z/S6QyVLUQR2C2UP7nMnkpaLaoeFD8I1cSqa3hWPy9rdeHroLAIOZEHh9SeGTYx0Jj02cSyC2Q6Hg7OS2nLeN6
 7mO3YM//
 H3ln9bCeE4sSrTs85WpNFRPZ85sfCHIpWs/t2huSaT8QRLbE8MMTe7027wyoEDRX6Ya3iuheKyGkljDqBnXZFPw3G/pSNpPzLJdpYklHjhemf9897NBUOHw15Npek3bCCYMhWtvA/7ZQI3NOF4A8YMuaAHidIKjbXPr9Rf0IZ1Q5q4Y3Zvs2n1E8GW9xB+a6shU0fxcU/5FxMTUyqEj/9Mea+aXf1IzGr6UkruQNUeBfrgS2jAdtUwVmyUrhGUlEZWiEXk1VYnFVdez4oErxKHk3qyrpTGwIxxtUumiMfPlC8nLlVYRvIplUB7LkffO2tKen9g+7Nu3mDw78=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Tue, Jul 7, 2026 at 10:20=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > On Mon, Jul 06, 2026 at 08:12:18AM +0000, Richard Chang wrote:
> > > Proactive reclaim (via memory.reclaim or node reclaim) checks for pen=
ding
> > > signals in its outer loop in user_proactive_reclaim(). However, the i=
nner
> > > reclaim loops=E2=80=94scanning cgroups in shrink_many() and evicting =
folios in
> > > try_to_shrink_lruvec() can run for a long time before returning to th=
e
> > > outer loop, especially on systems with many cgroups or large memory s=
izes.
> > >
> > > This latency in responding to signals can block the freezer (both cgr=
oup
> > > freezer and system suspend), leading to freezer timeouts. This issue =
was
> > > specifically observed on Android when attempting to freeze background
> > > cgroups while proactive reclaim was active.
> > >
> > > Add a signal_pending() check to should_abort_scan() for proactive rec=
laim
> > > paths. Since should_abort_scan() is called within the inner scanning =
and
> > > eviction loops, this allows proactive reclaim to abort early and retu=
rn to
> > > the outer loop, ensuring the task can enter the refrigerator in a tim=
ely
> > > manner.
> >
> > Do we still need the check in the outer loop?
>
> I believe we still need the outer loop check. Otherwise, we will waste
> CPU cycles entering the inner loop only to bail out.

(Moving your reply after the relevant text, please avoid top-posting:
https://subspace.kernel.org/etiquette.html#do-not-top-post-when-replying).

My question was whether or not it matters in practice, sure we'll
waste some cycles but I don't think it would ultimately matter. That
being said, seems like this change only covers MGLRU, so we still need
the outer check at least for classic LRU.

