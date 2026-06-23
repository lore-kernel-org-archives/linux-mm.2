Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1F72CDB47C
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 21:58:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A4506B0088; Tue, 23 Jun 2026 17:58:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6555A6B008A; Tue, 23 Jun 2026 17:58:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56B436B008C; Tue, 23 Jun 2026 17:58:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D9966B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 17:58:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A61D31C47A0
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 21:58:22 +0000 (UTC)
X-FDA: 84912541644.23.6AB7A93
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 028EA1C0004
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 21:58:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QgXbJUld;
	spf=pass (imf20.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782251901;
	b=cMM+FM/+LgRMf4zvvsMWPGRmehYlKL8NjD+jkYBsXO6O/hutv8U8cmwmL8vGBs5/xn0tGw
	M6oFo4yhlcf4F76e3N7vGUfVUXSOkLG8pEkw1mbmdMEnGsdyeAv3OWHmPvfyCzfIMAK2bL
	lKVgGpbk0p8Yj+xUSiyd1NyZKQuooQU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782251901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1HgdF15n4Z+of2TIKTLD8EBd2z4e9EArUoGmg/pRlaE=;
	b=J2yxcRMUL23j0geTGTCAk8/lzwA4d/apSQ8H95lkn+aTO7eGj/vMsI8pyf0HcDnFQRiHGd
	Cd4/LEa4w6o8HKAdHsGqcRGtZzzMbohBEGWn1z95F5rC9ljcaE76cdnlxKJP3tUSj2MJDk
	Oi6mNVPgOqu9LQbCKv7Xjwz1FVCIStY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QgXbJUld;
	spf=pass (imf20.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EBD3841E51;
	Tue, 23 Jun 2026 21:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A201F000E9;
	Tue, 23 Jun 2026 21:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782251899;
	bh=1HgdF15n4Z+of2TIKTLD8EBd2z4e9EArUoGmg/pRlaE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=QgXbJUldX745itn18F6Yyf7zaz8eGN7HM6q6xRYrSDzS0ZZqQ2cazPACHRQkuVvpn
	 fY0CXR18Eh8V96uEgstEnCzpSREGT8jtturxySdile6FshiamY/B2k6dhqkNMAqzbo
	 u/kgLP5L+K8rgp8mq5DfNTP/+2HQhWabTT3o2lugATJ6OdQYQFCt9r2flUxQ8b6SHK
	 AQhYpsn/qdekcLbR6/WnGEK0agFs5UPFDJBEdh6KEOOsYlCF52Vqbr8dhh1N5eutuu
	 WfFrbhB/yCGIRpOoBxmbAkOHvMDF4Ti9bxzW5t0NPFp7bwBNI+3+7MTfZaqw5pR7kh
	 BSoVf6GUXA9yg==
From: Thomas Gleixner <tglx@kernel.org>
To: Zach O'Keefe <zokeefe@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 David Stevens <stevensd@google.com>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>,
 Will Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave
 Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Andy Lutomirski
 <luto@kernel.org>, Xin Li <xin@zytor.com>, Peter Zijlstra
 <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>, Kees
 Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
In-Reply-To: <CAAa6QmSeq8bbckyJk_5HFagsHfS5SXbG4y6Y-Py66eYLgvjcUg@mail.gmail.com>
References: <20260424191456.2679717-1-stevensd@google.com>
 <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
 <6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com>
 <dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com>
 <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
 <c070c4d6-a570-4eea-aca0-72eed319a198@intel.com> <87pl1md7h0.ffs@fw13>
 <CAAa6QmSHBDeY0G=_N1P4dAAH917J7jerfZrWDfDd8w=8jH8nVw@mail.gmail.com>
 <87qzm2b39k.ffs@fw13>
 <CAAa6QmTO=hhdJQa-ofSZ6wW0geLaEfWZumF6KmksxZqM3i33OA@mail.gmail.com>
 <87mrwon5uw.ffs@fw13>
 <CAAa6QmSeq8bbckyJk_5HFagsHfS5SXbG4y6Y-Py66eYLgvjcUg@mail.gmail.com>
Date: Tue, 23 Jun 2026 23:58:17 +0200
Message-ID: <87cxxgly12.ffs@fw13>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 028EA1C0004
X-Rspam-User: 
X-Stat-Signature: cutzfpom5gnf1nbo8oqh5t1akg35joy1
X-HE-Tag: 1782251900-385551
X-HE-Meta: U2FsdGVkX19DjU8rUFwdNCfrpUYO45vUDOW+F+EqYuM7+57fzlpm5X7/BmWx23AgNHeEv3StZy6frUuedPuFNGOZL54VGiO2KDZIdQT7hY4/oZxXL5Lr4Nwlb77ze6Zgd0NRiFXxS0hpeV7Acb/ZTWL/3AWwV+59gKTsGz7nIK/OI+f1QK1/nVDdyMKkksSzD1/zC9t3VPj9qjBu8kEGyO9AKh5QQdQJj9n5bG8beDtd0VK1r77uAv6Hlk0l1jPIYncmCakxcX/ccs2posopaZNbnwiByrRstIer5yW5ZTZeo0/k0ZCDg3LQzBeLE6Yw/sdzsDwx8GjJ5H0IwpGrd7F3ZlX5ju3u8O41/wamPAVDq1WfSMRJu8/SFZdN0mJsOH2/VNF3u6yNX+ladppV5fUi2oepuVSpCUnstiXf8lcH32z3LVZw45wfmIpkLz3VaOgT13X4FS73PCyhqmrg/53mJXxBV3iE8IN8rpC1f+tjjt9boEe8PU1e4NBucDcAs5/kIURdcf7SvwO0m/LBBdyJO1+BTrbCpS6L9tpOP1CsT2sppszZJCeW/3lyeelK4aI6a5GiQSC4Wai43pKHWoZHWYv8hKV6f87KlHsjmof52iGoYYW9Ub6vuoIyi7xfVQyHjAO9tUbSUqm1eXeJjETFiDkwDUYe8g33ivOUYSkbMixmau6oPsnOi0VY+ci5gR0WrWW9uDhboVR5D36G5NbPwLzC5bJeH2PJEdk+4NNYq5+ZJJzCae0g3YMqZhdmQ92O+2jEz+Ft/kNEaDBcoLgAkxltW2xvVjXrDR7a5aUddYPpemiWdOnhfXWIx6BL/gno928ehTKlAepSmDm+RUKHxmIX8VtS7BhjNNkf4E/e+cYmGIB8bbjWd9ZNfikItK83gQKy07W1lRDMeVVXgJmnvODSXX0LJwtVXM671CxG4rjOd3r8ON1lnZTT+lN2swSsL963IrkqhuF4VRB
 VfxMg1Rl
 FHT0Tu+FO1kZGjYqpzeetreH0Lf5oljn2vFs6PhPOQjr881zwuKrnf/T3DkTca3XC7FCAqP/byphvjNYhcy63HlRTNRX/XJMhQ/V1VYjqCiKWd8gA0uuGrC4c+RrdhYEpkG0+Sy0Ks3yKo4X6HHhFJaCyl/GAKJXGDgrTgnXPdz+e/4lRguh3yCSJgJmHA3gjpblgfTiK8nSI+9+aUEDK1HnTAcM0IWa8AAvkDElGPjBhJvv/G6Diz7Fc6KYJYfSMjwNgDfIvZDwLes+iiQbYIREhtsglBCJ4BeBKHYXkPP89d4xGCgceZ+Oyjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22 2026 at 16:00, Zach O'Keefe wrote:
> On Sat, Jun 20, 2026 at 4:34=E2=80=AFPM Thomas Gleixner <tglx@kernel.org>=
 wrote:
>> That said you really have to describe the scenarios where there is a
>> benefit and I do not buy this "fleet level" argument at all because
>> there is no single fleet which has a uniform workload distribution.
>
> These are good thoughts, thank you. Perhaps I've been too biased by
> our particular environment=E2=80=94apologies for that.
>
> We (mostly) punt this problem to cluster-level scheduling, which
> ironically exploits this non-uniformity of workload dynamics to
> appropriately bin-pack machines and materialize these small savings.

That makes sense.

> In the general case, I guess a lot hinges on that overhead cost -- in
> the best (memory-constrained) case.

Right, we need to look at the wide range of use cases and avoid to
create niche solutions which impose maintenance costs for everyone.

>> Aside of that. If your argument holds that there are only a few
>> scenarios which require a deep stack, then we are better off to identify
>> them and fix them up rather than trying to hack around the occacional
>> insanity of deep stack usage by adding complexity for complexity sake.
>>
>> As you say that you have numbers of your fleet which confirm that the
>> vast majority of the stack depth is below 4k, you can surely figure out
>> the information which call chains are actually exceeding the limit.
>>
>> I prefer to fix such shitty code and downgrade the stacksize in general
>> instead of papering over the underlying issues which probably have been
>> ignored for years if not decades.
>>
>> Have you ever thought about that instead of adding complexity with a
>> dubious value?
>
> Yeah, and that is certainly an alternative path we can explore. I was
> _hoping_ to be able to maximize the savings here, via the >90% case
> where 4KiB is sufficient. If we instead play whack-a-mole with the
> handful of cases requiring > 8KiB, the best case is we can move back
> to 8KiB stacks. Ironically, I was thinking going this route would be
> _more_ of a maintenance burden vs having a generalized solution ;)

It's actually not. The point is that we lazily punted to 16K stacks more
than 10 years ago. If you read the changelog carefully there is an
implicit request to watch out for stack usage and to fix the
offenders. That's obviously not worth the electrons it wasted to commit
it.

Software people are really good in not ignoring such things as long as
they do not explode in their face. :)

So as you already confirmed that the number of offenders is really low,
it'd be definitely a worthwhile effort to fix that for everyone and also
make the compiler people to get their act together :)

Once we got there the complexity of this becomes smaller and we might
have a common goal to get the other 90% solved.

Thanks,

        tglx



