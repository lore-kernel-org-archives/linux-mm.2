Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A355EC4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 22:29:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B7836B007B; Tue, 21 Jul 2026 18:29:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 468266B008A; Tue, 21 Jul 2026 18:29:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3577E6B008C; Tue, 21 Jul 2026 18:29:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F3FDE6B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:29:20 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 935F3A0987
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 22:29:20 +0000 (UTC)
X-FDA: 85014226080.20.9FE9EBB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id AC91F180009
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 22:29:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e7fV4X+I;
	spf=pass (imf16.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784672958;
	b=f8LCha4kaF5JDUI/SqkW4KQANZbZlQwVZ7Raz+9IoEnqaiJT7pLo41GHx7e5eqFO6GUWuZ
	A/oiYxkqZ76rbEGe5zM9unW/9LdeAPVIqLvmgD6vfQtKXpO8ougAcsIhG/3h+Njm7AGBEa
	F3qY1NQmFfyzxyz05AGsCEeCnHxbQdQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e7fV4X+I;
	spf=pass (imf16.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784672958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2oMF13mkpXboxWf/OL9zlV7n9G6mE79uD6c/9l03sfc=;
	b=X5MmactJ+Yow0SkHy3DYMwEDBVhdIcBeME5gHf5B6V+emwJRmjw+Qy2go4v0P534ibL2uN
	60kAguWi7xKjdpe8cYvObFmO5nepZDNM9ueRWqyia4+F1VT1e8cCPadlt8kS7zWgAZdgbs
	rHjR+cJHk6L2b/sncDLs1PfvmBo3TeE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E2CF060A78
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 22:29:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BBC51F00ADF
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 22:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784672957;
	bh=2oMF13mkpXboxWf/OL9zlV7n9G6mE79uD6c/9l03sfc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=e7fV4X+IQERegCO70hRUpfCgz5PUZnB0dgb/djnu9ElGem8hRmOSHX2IBO7liWWto
	 x0MWRObMG/ZgeiIP3DfRHA/CXXGHBiRj4thQKK6x85Nj9mRs1AxPKXKxZkMFeYzBpn
	 /p/VsZo4tSYtikLrCcA06kmoXbeZuxfTrlcMHNXcoL2RDVpeFx6Z7H5YCNXbHh4Lg5
	 lzj7281Bd2XNhH3bxbx0pNuZe/HIbMFL0CwL6VcY7ZKeqYJ8PeZtnx40rp/RNPP65a
	 My6zb2vLteA2+EOIoyf2bjzpOWnyUOjrjDMLR3HQNNjei3PbJo67c+OqJxEXlNbPiH
	 TpbUO3xAS5bbA==
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-81ee41aaec1so60186327b3.3
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 15:29:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqJQELU5KXfvSPuKFitnqIXJg5cTklFfrtO4NUehEebtx+00UL85pN0ZWuK7JEysWslHLhFMY25Mg==@kvack.org
X-Gm-Message-State: AOJu0YxokvzmpLo730kTIsAExfH1kujEN9YqlZXJIyjhZWn52TK/1s11
	fsCrTByihaIJA8uQ6SbxXpjFGr73dGpmgT9LJGODFx+3YtuptDWVyz3sHPL3cnTyk9f4SVEl+7d
	8ql5b8UTzntqKmgdjZdYjj1FcWebu1E9ozZN7v4/WYQ==
X-Received: by 2002:a05:690c:4d83:b0:80c:3848:bdf4 with SMTP id
 00721157ae682-81ef2671daamr69194697b3.41.1784672956929; Tue, 21 Jul 2026
 15:29:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260707082614.95030-1-baoquan.he@linux.dev> <CAKEwX=P50av2rfocpsqZoDQowZ=EEhQ-5vj5tBykbNz8vtKTzA@mail.gmail.com>
 <ak-IS61GeP85Jnxg@MiWiFi-R3L-srv> <CAKEwX=PEgnJ4nGFZYUwMryjq+Yp4v8Op_HdZ6_xEJ4n_MrM0Yw@mail.gmail.com>
 <aldtS2S-TXc7ocsH@MiWiFi-R3L-srv> <aleW5xL2gYcU_Rl4@MiWiFi-R3L-srv>
 <CAKEwX=Pm_C6OD1jAo818wzFVVhLwgVFu-4bLdNrmUZ01URpLTQ@mail.gmail.com>
 <CACePvbV62T9LA894vTXzBZQ2PNh6iYZD7eH6=UjeFSWhUW2aDA@mail.gmail.com>
 <CAKEwX=NXJ1LKQOA8Qy_4YOS6v+jGbAJnbD5K0=jNbgC8Da0iKw@mail.gmail.com>
 <CACePvbXAqutPvawTcBXLa47=WVKdLBDHL8unKOSvV+KbrEmmwA@mail.gmail.com> <CAKEwX=MjvpNwLVg6FZRgYw=31D4XwJnn_ty4EQr+KqzQX+Rz6g@mail.gmail.com>
In-Reply-To: <CAKEwX=MjvpNwLVg6FZRgYw=31D4XwJnn_ty4EQr+KqzQX+Rz6g@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 21 Jul 2026 15:29:05 -0700
X-Gmail-Original-Message-ID: <CACePvbVydmgscK6UgnqpHXqvpAaQjz+MZjOa1hmAVp1Va5u-2A@mail.gmail.com>
X-Gm-Features: AUfX_mzqAuNJeRHp4BdDCk65opFAnGacdId38aBy9aqYusQfkWEodpfH96O7B5w
Message-ID: <CACePvbVydmgscK6UgnqpHXqvpAaQjz+MZjOa1hmAVp1Va5u-2A@mail.gmail.com>
Subject: Re: [RFC PATCH 00/10] mm/swap: ghost swapfile with backend switching
 via Redirect entries
To: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, baohua@kernel.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8r7kzodrxy14xini6cw3jbnc51xfpseu
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AC91F180009
X-Rspam-User: 
X-HE-Tag: 1784672958-307411
X-HE-Meta: U2FsdGVkX1/u/cG/SFeYe4JHlUOeHfDReJLs/6FaPk20JLBIpYqN6ixHCfnE4EeopChvX5uUw1yueJlpvySTHxypVhHGlWq+clpQ31PyIHIz83vwE4Lwm/pHQM+ra4UzzkYBA+pIbddubREZ9oFdGlVJ1QQhrYYbAcSDSbtlGf8Tx8bA+uGY4+62/iJmMkji7T1OZNM6VN0jYWMV3dLoLF976zx+t+8qVGGYQyNZzi2AZDItMafgwfEq25ub8QadKr5irwO3iXwzEKml+f8Uyh4EezDtCKSr/T428cDi2bugVcB5aP5AzUQj9Yh4bRxFJzkImtbCFNDR0clTF8qZGc5H9j12iPEkjzru+PKSIjD+KBZ7LFD3qqOQss4Rw11peu2inq95ROJXZBr47887hCInFxbo5eeuqL0QCOyY6B9cveQ97C+WfZCrTSsIHREPp78YUZm9sm29mODxPm1NLxEnUHAxbX32Hw/kZlzGJ+kz6W+TrUY/wtNtxC4Dw0XzdW1RJ2udU4hb6ScpHg40EQyKNGMUULy9e/NkN/IP7L+2L7lqJ3hqUmBouhDjuY/wdjnVrNFxMs0A853E2a0zEh5VpFNez30AVTHppY7KUicIQrCaOjvDF/8y/PNQ/m1mAAoxO7a4vHY3RrBp7kIIbGyjrhU26jV4Fl1e1hc+pGegTeQcedEMMSdwR/z1flLmSc0cAHN48Kyef0AT6LMyHcNyC7hKwr3nq4Z6jCbAHdnKLtZYt0///eQeNsH5LDUWCA3Rocz2+12Dt/1rlVObuL86bv721K4y3wnfEBfdxGxrMkDnNnix7NmTU/sW4TTgBlq53s9bQRTUtK58OmY8dSc6Fp46YNx4Cg4E1uRUsp5nIXDA4ORtFNai8WTeuodpKSX7zG/XbLNDv9IwbwQW48wYUa3HsoONvEkHJs+yq+T3kVT/3BaWD+lNA01g95d7GoiBfQafWojCIzW2ENx
 WcPW6+Qi
 HHvPMTa+r05d92nQeDj0RCZkCcDb9HJUTYgE8oU8Bwi3tBTjMDOBU+dE8M3/sUh4mDInIeIYLiOQsiDGhO+pOTShzC4HL45rnsOgDo0SQsjUoWwPOG5Jyh/hRfRrNJSRZxD+e097LYLBwAYDpNxDFiWGn0JZRnYJiJM3upqv6rFa1GrVGFIsBhjSZLLQbypYH/lrmsup0ZIClyKyAWXl5VacM//cf1p52pKz0PI30/Aol+C0ryz2MvIF/fF3N1zivpkAM4ueBahd5XeEUxAXnZCP46Eg9PCw0sOPRI1l11ZAbYT0AYAhM+uqGjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 11:37=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
> > I hope you are not clinging to that xarray because I want to get rid
> > of that as well.
>
> That's what I meant though. The virtual table replaces it for vswap users=
.

But you still have one xarray for lookup swap entry to cluster right?

I want to get rid of xarray in both zswap and VS. The ultimate
solution is to not have xarray in the zswap/VS lookup of swap entries
at all. I believe achieving that would be a better win. I can already
see that happening by building on top of Baoquan's xswap kvmalloc
growth series.

>
> >
> > > The rest is small stuff here and there that is not O(slot) but rather
> > > O(cluster). For example one struct rcu_head per cluster, xarray
> > > overhead for the dynamicization - note that this xarray manages
> > > cluster, not slot. I think that's all, unless I miss something.
> >
> > I also mean the normal path that accesses the swap table will take an
> > xarray lookup with different locking requirements.
> > I prefer to keep the swap table and cluster info where they are now to
> > avoid that extra complexity in the mental model.
> >
> > It seems allowing the cluster array's virtual entry to grow should
> > mostly answer your VS need?
>
> I don't get it. What do you mean here?

I mean, here is my observation, please correct me if I am wrong,  VS
patche series needs two things from the swap core function:
1) able to allocate more swap entry beyond the current si->max.
Baoqun's kvmalloc grow patches should be able to answer that.
2) able to store private data structures per swap slot. e.g. a zswap
entry pointer, or a redirection pointer or both. We can modify the
swap core to provide this extra context per swap entry for each swap
device. In Baoquan's new purposal that is the vs_table array. We can
use the same kvmalloc grow trick to grow this pointer array as well.

That way, it does not need to have the VS xarray lookup in front of
cluster_info. You just keep growing the cluster info array and
vs_table array as needed.

> > > So if you don't writeback, i.e no physical swapfile, then I think
> > > there is negligible overhead (no rmap and all that jazz).
> > >
> > > Does this sound acceptable to you?
> >
> > Regarding the memory size, yes, if the overhead is less than 1 byte
> > per swap slot compared to the ghost swapfile. The location and lookup
>
> If you see where I miss, point out. Otherwise I'll take that as a yes? ;)

Pending my deeper look into your patch series. I have been bitten by
your patch series' claim about metadata overhead before so I am a bit
more cautious about concluding anything regarding your patch's meta
data usage now :-)

> > path for the swap table and cluster info are not ideal because VS will
> > force a different location and lookup code path. I prefer growing the
> > cluster info array to gain more swap entries and keep the current swap
> > cluster and swap table data structures where they are.
>
> The current swap cluster and swap table data structure are *exactly*
> where they are. In fact my proposal keep it closer to the status quo -

It is not the case in my mind because the swap entry will require an
extra xarray lookup to get to the cluster info. No?
I do  not want that extra xarray lookup. I prefer an array lookup if
possible. With Baoquan's kvmalloc grow, that should be possible.

> once you lock the cluster, swap cache and swap count operations are
> *exactly* the same, whereas Baoquan's approach requires taking swap
> table information and shove it into the struct zswap entry.

Yes, my concern is the xarray lookup for the swap cluster info.

> Can you clarify what you meant here? :)

It still has the xarray lookup in the code path (looking up the swap
entry index to get swap cluster info), that xarray is what I want to
get rid of.

Chris

