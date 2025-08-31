Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 785DECA0FE8
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 20:05:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8B9D8E0005; Sun, 31 Aug 2025 16:05:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B62C48E0001; Sun, 31 Aug 2025 16:05:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA0138E0005; Sun, 31 Aug 2025 16:05:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A91C8E0001
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 16:05:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4E174BA4FE
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 20:05:07 +0000 (UTC)
X-FDA: 83838131454.22.B6244A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4ADA5180012
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 20:05:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K5wgrxi4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756670705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LWRpUSL/GnmdcvyMwvmcVlZ7Yq9l1dg62LV4rSyXoX0=;
	b=37gzPYCvIFnZGbUZpoAB0tM9NokRlrjc4zIaNOY0v5LxITBBho8AVjQhXrRNJ2ZNEaG60k
	MVRS3jocqZZEHvJE/v3y8IOtq8N//wAUZrY4oFhaMGfZwCK3V3Et5RtJkozV3dUJzhuuax
	6ctQIWn+PA2CJ06b3bAMPMgOMC2Up1Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K5wgrxi4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756670705; a=rsa-sha256;
	cv=none;
	b=LKw2V8CbNQHPrLc9t+irJz7vtvQ29dfQaPt5KpM9qoMMjNF7rHcRlW3FBUZulDgluNMtnT
	+KmSzS3Be2belSfdy5ioycP5N2zExgYcNFjsIGy5M3ZAXSBEiDItqIBl+L76E1zPnFkvLo
	5K/jGQiNJ5/pq43R6R0Ol96lei2tC6o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D0AC44DCA
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 20:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 202BFC4CEFC
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 20:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756670704;
	bh=LWRpUSL/GnmdcvyMwvmcVlZ7Yq9l1dg62LV4rSyXoX0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=K5wgrxi4a68oR1olGOtkvYpIi9jQ406zgLUafhAovo24R0AVEctGr4ILQPtQzeVA3
	 PMcfEX/a+yOTgdbALNwjWL6qLlhun3N6W/gOFbaHOR9/6bp3WDSNxae3oNsuvMbWvF
	 lkLKGjpRgB2A/SOPSWE+ZmfgN/c4K0JgDb0Z4M80sBqcdUw3N5064VxM0olTs1N/5V
	 MM458JySQ1ylBWcSS1ekw+MzveUqlflLybVzOPB8/HYuEB2Ao7R1PqOHmZsnE3Mi/i
	 g5DYcEXkNifFkkxwdfjkgeo6LsmE7fp/qQ6g8N9CpftF/wSOkpGHFrV1fDmGYr3dLu
	 Mr5rt1Js9ytOA==
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-e96e5535fcdso4304680276.1
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 13:05:04 -0700 (PDT)
X-Gm-Message-State: AOJu0YyAMKvHHJLwkktRwEKcRNa98L86Xr/1/h/aUYdrCUf92ipvH2Eo
	UErbFp+iA8Nn4xdYM64R51dWgeXceE8RytGuuyeFrPYPY0D9o4MfVpMZQ5+J6Zivt/BCZ6xl82n
	N6YqINydf6VKMz5X30+wVUMREeJx1ayJGTI8wxJC7gg==
X-Google-Smtp-Source: AGHT+IEvrMUALCHiCTbTOeCcpOCPaO1Fu8A9uaO8xl5ArGIFN5AJnhsZL8URqDZn4jBZvXcL+BqUUAZilA4DBK//Zzs=
X-Received: by 2002:a05:690c:b06:b0:71b:f46e:691 with SMTP id
 00721157ae682-72276370c8cmr63246317b3.11.1756670703140; Sun, 31 Aug 2025
 13:05:03 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-8-ryncsn@gmail.com>
 <CACePvbXB-G5vhoEt87BZcjDZ8kZWo3mZtAZ60YbR_gcjnPz29w@mail.gmail.com> <CAMgjq7Aznd7=m6JTNGM4EyFj+6pqHTRBCo2hsQL-cKi0LZggOg@mail.gmail.com>
In-Reply-To: <CAMgjq7Aznd7=m6JTNGM4EyFj+6pqHTRBCo2hsQL-cKi0LZggOg@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 31 Aug 2025 13:04:50 -0700
X-Gmail-Original-Message-ID: <CACePvbUt+=+5mZ2E6L_EhUYLTWst_STab=LjPiBfvZuX8jenMA@mail.gmail.com>
X-Gm-Features: Ac12FXz-89GEcBe6LbFCY4BPOk3iEpBAci6KuW0YkObl510MGiMrV1R0KFjr83Q
Message-ID: <CACePvbUt+=+5mZ2E6L_EhUYLTWst_STab=LjPiBfvZuX8jenMA@mail.gmail.com>
Subject: Re: [PATCH 7/9] mm, swap: remove contention workaround for swap cache
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4ADA5180012
X-Stat-Signature: w55ojsdfrz48d76zcy4mc1mmeeok4c77
X-Rspam-User: 
X-HE-Tag: 1756670705-881163
X-HE-Meta: U2FsdGVkX18asKe/Lk39xJ0T0GyiyrJonAj3zscjqu2UnbSvnX2+o4juIYMv0PxarRYo+3/ob+P5ZaiO9k0jI5LxdeniFbveVX5o1JsNlLJE4DKMckkMNnF7Zrz2sGoz1flOUc84XdrXaEqY+/LmTzW2uPBMGC/GC/24Lng5tKTRTpV+EPMuB2tsvw4WsJxYn35Ng5uLGuDOx2sDmlNUIU617k+ENMgwBaUTUtBrD3Xp6KrFq/5vWAMkqvwa562wokqqelYiYlhPHMxEGboaNkf+LDXx5CezcdGTsw9jFHtwSQM74yfJdUVfRG2wz/KVUoHEXwWiQFocSKbg2/HZ/XBt0sj1Z4Fw+k2rbREGQ0upRYibLRhaAXMal8ZUs7w7Ort2xi+XzORUL3fr/uJQ9TPmC4QQ2KdiS234aYuxPwTYQQvvz6VWWxtuOmShhcPuFXZSz3pRORCQVVKDmfH30y+eeOKPp6HP0x+7FPt58Hamg7BpRicvz6B7q4b1edcolJDK3Jaaltp+SKJ5X+KUGRjYhazy2aD3jtZ3DI4qR2+fUQA6qgGf4Bpfarp0Cazk8iAiD6nJ8/LOC3zGE7o/zmoiBcD57ykH/NwEoCBkivvS+hg5lsLFR14fh0ncDnAhvhTY0pdLoeRGAG28BYa9jL3As/t9pDO3l+V5QICiLGpScJ0LGDSGFkqjwojEncUpsvBoEg2zHxjAREanCBVwyQXgh1KSIwKqmEou1Ah5V4pPg/sPwE4NnBNaxH+HQJTqTnC5h2HOnoMB3i3GDrtO5uKpb7wKUbXjFdX+10FU20yBVtbKzdad97/cFsx6uFfUglgKAH8dFVRq9dQ2VZbQbixwSjnSlCMKu0oJ5BN/MkqDaP8/0Jl9k9MQPKVtugqW36U/E3Xx8/9Uy+wByeC7FD/xrLSmH4xv9lnFpE8zqgYUOs0ugvi7K3KsfzqHNKqrtwcTMysdoio+Qdu/81+
 RlPvZMeR
 WFaUiWh4flxHr5ziVzcYpAvJwU+nKPQJKj5VVmhPPf95x/s1K/8LsM2nEVgPOUKc/XBBA79NGAwghstq7pk8Ob55Cpa3J6LBc0IvVpA0saZZJBxE3Tc606zf6Yrky/gMAMsTfejHekihWeneCdQT1Oarexh149B1zRXixgkWcBz25wV8wf9I0/yDTjbaORNM6eSdg1VIhyZn0QCPrEfxR0Bv20yE1sbJ4LO6GfewClflK86Uip+qETDrfmeGrgvMFy1YLsplaL9QgCDHKx3DszeRf4faaukCImIYKfpyFHctyCiTys6Q54ZWCAhgGW0nKrpjy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 30, 2025 at 8:25=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Sat, Aug 30, 2025 at 1:03=E2=80=AFPM Chris Li <chrisl@kernel.org> wrot=
e:
> >
> > Hi Kairui,
> >
> > It feels so good to remove that 64M swap cache space. Thank you for
> > making it happen.
> >
> > Some nitpick follows. I am fine as is as well.
> >
> > Acked-by: Chris Li <chrisl@kernel.org>
>
> Thanks.
>
> >
> > Chris
> >
> > On Fri, Aug 22, 2025 at 12:21=E2=80=AFPM Kairui Song <ryncsn@gmail.com>=
 wrote:
> > >
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > Swap cluster setup will try to shuffle the clusters on initialization=
.
> > > It was helpful to avoid contention for the swap cache space. The clus=
ter
> > > size (2M) was much smaller than each swap cache space (64M), so shuff=
ling
> > > the cluster means the allocator will try to allocate swap slots that =
are
> > > in different swap cache spaces for each CPU, reducing the chance of t=
wo
> > > CPUs using the same swap cache space, and hence reducing the contenti=
on.
> > >
> > > Now, swap cache is managed by swap clusters, this shuffle is pointles=
s.
> > > Just remove it, and clean up related macros.
> > >
> > > This should also improve the HDD swap performance as shuffling IO is =
a
> > > bad idea for HDD, and now the shuffling is gone.
> >
> > Did you have any numbers to prove that :-). Last time the swap
> > allocator stress testing has already destroyed two of my SAS drives
> > dedicated for testing. So I am not very keen on running the HDD swap
> > stress test. The HDD swap stress test are super slow to run, it takes
> > ages.
>
> I did some test months before, removing the cluster shuffle did help.
> I didn't test it again this time, only did some stress test. Doing
> performance test on HDD is really not a good experience as my HDD
> drives are too old so a long running test kills them easily.
>
> And I couldn't find any other factor that is causing a serial HDD IO
> regression, maybe the bot can help verify. If this doesn't help, we'll
> think of something else. But I don't think HDD based SWAP will ever
> have a practical good performance as they are terrible at rand read...
>
> Anyway, let me try again with HDD today, maybe I'll get some useful data.

I am pulling your leg about the HDD number :-) I know that thing is
hard to get and I'm counting on you having a dead HDD on the way to
get it. Evil Chris that is.

I think we don't have to make claims like that HDD is faster. Just say
HDD might or might not swap faster, because we haven't really test it.
People who are about HDD swap can test themself and report back to the
mailing list.
I think we should use SSD to simulate HDD, testing the HDD code works
in the simulated mode, no crash, no data corruption that is good
enough.

HDD swap is so slow that most people don't really care. I asked in the
LPC a while back, nobody there is using HDD swap seriously. At most,
just in case my SSD swap overflows, allow it to overflow to HDD.

Chris

