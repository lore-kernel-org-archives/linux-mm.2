Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27C4810A3D81
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 12:37:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65EA96B00AD; Thu, 26 Mar 2026 08:37:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60FF36B00AF; Thu, 26 Mar 2026 08:37:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D69C6B00B1; Thu, 26 Mar 2026 08:37:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 395A86B00AD
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:37:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C2C3913C1C1
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:37:47 +0000 (UTC)
X-FDA: 84588165774.19.D9E6885
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id A6642A0014
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:37:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="B/f5/Kv6";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774528665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M8FW8TOG/ggI/iYIAOkVhhdCPCiS3Oq8BCMwRl36bPo=;
	b=nPOgKgR3Zlsfc2/nnk6hdvupxyxVNwccnzg018TLXNmWxqM8ZuLrYQEkELxldibPUpWWoJ
	LY/cDmm6ZD8u4Hwm2/kbJxjQwuDVDbj+5M1vCAimfrSnDoZrMipBzdFnqbGJI2ls2qEXxA
	VCFQv8kq2cxybK/j64NrmK1QR7RErts=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774528665; a=rsa-sha256;
	cv=pass;
	b=e1HJhSWHqu3PtVccmIdgQV+Vxb63tmTRKy6YqLNqgSiiGpHEDB3Zv+rkLix9ADY/6umAv6
	qMMTcgIUDTjEzhqreLy0Ljy5QYf8iCwcZl01tyuYz/UGsnFKb+1EK/tRO5aAkRhF6oiWqn
	etD1Rh29OOrh58Q94/gGsJeqwaZSBgk=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="B/f5/Kv6";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-66a82351490so1596587a12.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:37:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774528664; cv=none;
        d=google.com; s=arc-20240605;
        b=JT7e1StP7tLPL2b103UL+Uqg+So6QjOpRVll0pB2QpyaZO6nFPqv3d4dWKtVbzl2jH
         aUqrefIOqlsSOvn2eaSfr98OXFk4HVCbFTJLC5zaYk0JXjwfkjUDlCNolD0u8D7W925M
         WYH9rFUF9JJ0urYMycMNZxeSPRKeclC/lVL5/Z9YKiJiK3EIjBnEP+9+vxqgd7WV1f7z
         iXAHj/kY8X6l2Jba8GQ6y3epowpodFcX7JdQHq3ZZS22Fku3Q65cgdrprA+V3TuIjHGG
         rHSwTA1fZvqVvkeLFxFhR7Qcp/dM3I/mIBCGgCxfl0tOXHfFRVJ3ZFEgvuBrljPj04KU
         8xpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=M8FW8TOG/ggI/iYIAOkVhhdCPCiS3Oq8BCMwRl36bPo=;
        fh=oD9klqKpvPdQrnSeqgZWyydPxCTEsm4JmqB10Eu/2wQ=;
        b=DR7CmiJL7gmI1M8jbzzzpB7NV2smABkFNxceOr7E/nFRgd8shE1ZmsFY9PWpXtzJnE
         MvjlLx5iWGFgLYLHwVNWqFFJsgRa1oIFgLCL3Xlyd7rya4gcSFlnLEXUmlZxeIONO4Zu
         acTiJEJ3iRyv3LCbLpeRBaxK7/8fOr4wYCAxj+73Z+r1CPRqj72Ym5f+QXIp2Uc4AUTP
         Lmq5qMBXN7EUwXEF4nbbJYldjX5TpVnM9VBOU7D5rEmCpQUiAo701YdIww1Kj5Qj+Rdl
         ORMSmjVvuYWZLXFxKeIcF4wI/igY8AynQnxcm1srjkXjtsplI41t3QGOZu6CzPYJIkXm
         MeHg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774528664; x=1775133464; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M8FW8TOG/ggI/iYIAOkVhhdCPCiS3Oq8BCMwRl36bPo=;
        b=B/f5/Kv69yCcAlCerHV1cAarLdZwHCaYEe7/hTQsL1aa1wGs6VW8BwSpVxnAU51PKT
         4uFWi7zQN08VniBooVN7KCaECxEcvPLYn+CO/LnLBXQ3BPIgiSFs33VCsl93m2o3uEHw
         YindB//sbPjXa5GWuEj5pHKCL1+QQfKe6Mq4FLJgK+iKJQNXmXNPaErpLk4yTDa0mHal
         lYQFRk5tj24TAln5FITMOdBelOHZm7tzGOm7QOqnFV+ariI6z7WSLEjwg4RGZ0X0xwmz
         xdJ7D1W8y9KXeACRA1CqhpK+UvxaLEGt1mMUTVn+lfxU7z3z/QkPLCFHH4WEVJMeQfUe
         Wzjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774528664; x=1775133464;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M8FW8TOG/ggI/iYIAOkVhhdCPCiS3Oq8BCMwRl36bPo=;
        b=KMWnepLKx7AqK3Yo777bW3FfH7wCOBvuvsfvGOiOk8jkjzow0org/tXLRPlnoJnmwk
         g7VOHHoVXxOp4a697hM339uE1ECJPTkJhxta/fkcuvokNtMQSS+kQIKuyiV/FLijuIOi
         WPqXk/XeBHjZL592MhNZyiQKS9VW39Cdru7i/i+LZ/l3pXqYVzZDaaG4dIuLep1aJzzi
         HyUGd3ciUoHUvJXGSJcCLQwoenGK25vOwM1w30bMThKfeCgpEG/JjMx4h42sxzNjeF66
         3RIuwsVdPo5mEcc1OvuH+Q7mm7EdGcVTgk9kAKmCOER6R2EgAqsVefFAGLQgEVqePeU3
         yH/w==
X-Forwarded-Encrypted: i=1; AJvYcCX7O174k+EmwHTUt7NDcosIx1WQn0SVU1OSF867oPnktzplVYS6BXY3QwEbCUBllDXKM9GWZGXvJQ==@kvack.org
X-Gm-Message-State: AOJu0YyJZHwyaKWFx5UCrTUgFcPgG42oKuXDC+/HqP/+WSocmUnYFBXg
	746L6p3A5oDhSEqzOn8Ivjk2/eCa0uiqVKQWbUxEtNw1lDeSq7Avuq55xGVWX9LYNzpzOaSGZMT
	2EtLmwPXp82xGfAMK3M8cMUM4RHJe4N4=
X-Gm-Gg: ATEYQzw+IoJ3xJH/8O0mcxcoI3xZAcDl2IcRYnjS258bfTCpy2kUl7cqL3NPEjsVOHN
	yMPcwXJ5CQFwYYEABElZ2gRgeMmG6aBGCA/5EGhBsGuEJoOJyxUntd8OAUPVi6WbJTOH8AHceK+
	zfn5IVlpI6WKMy2fVnob9BZSL0LfyU4ltebPdLocL+cQmNZXAXjTSw0jGGYIpcIbU8GPem/wS8N
	hzyEr2/QPcJRQdP8VZ6IQxHeAYX4fR+RfK4MzBXGsnOtKAh/tyFg50g15iwwEP48FsYiJM8hWdk
	dX1pkqBY73eCjUaQEulxLGuZXW5+MsJJnZ1GpgFL
X-Received: by 2002:a05:6402:52cf:b0:667:90c1:844 with SMTP id
 4fb4d7f45d1cf-66b07ee03ffmr1012084a12.10.1774528663980; Thu, 26 Mar 2026
 05:37:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <20260325190547.abb7309fb63473b57b7a90a0@linux-foundation.org>
 <acTaRgusrxfCoKqe@tiehlicka> <ac05d923-7871-4691-8d26-eff41b3a3db0@lucifer.local>
In-Reply-To: <ac05d923-7871-4691-8d26-eff41b3a3db0@lucifer.local>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 26 Mar 2026 20:37:06 +0800
X-Gm-Features: AQROBzDDhAwWy50_0AvWQXh7pN5XimsTxdhJS695rjfTsFhXBLoLPjM3epTli8o
Message-ID: <CAMgjq7B_twv3xhd5VmMJxngAknf9YaLAiwGYpdi6H2n1cXD3-A@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim (reclaim_ext)
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, lsf-pc@lists.linux-foundation.org, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Alexei Starovoitov <ast@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Matthew Wilcox <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>, 
	Gregory Price <gourry@gourry.net>, Barry Song <21cnbao@gmail.com>, 
	David Stevens <stevensd@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	David Rientjes <rientjes@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	wangzicheng <wangzicheng@honor.com>, "T . J . Mercier" <tjmercier@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Suren Baghdasaryan <surenb@google.com>, 
	Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A6642A0014
X-Stat-Signature: snebziwskzu6iics6y5txwfak1eodekk
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774528665-120610
X-HE-Meta: U2FsdGVkX1+B3s/jNbNtD1BKDAZkg/bsmicEn0QSBy+0HIoOgWR+f2Rj5EBvdPL9DntFoDI3W4d+WpxI81XP8EUR3RNFpenJgS13Eo7daB8daiX89PDgNomSDj6Rbclr4RjM3mBIy3LNgEhJ9A30ILEhSM1FGAGNgQZXt0HkevJIfjThMHAhrVWDB5C4WBDbc0KkDF1K5l8SyVhUz5Q9wxYWFtCaneSrNVaqRTJOejNz8pPJm5HtlOTHfsLMvZHZs2IYBGm3mbh25vxH6frAmT9kS3OE3phTTdfvcKOx94Jkwj08OgKDwY6n7C43jjmuAC/ASThADov7CDLs1W449JqbzOLHMYBvBccOJVspVN7yFt6frze10NyEh3ZtC/uHT9yxWkgjUUPk22ZtyVMVlaQajhMhsAxWOa2jYgveauf9E7aQheRHnq1cw8d6YcttEGoZQouil/qo92ewwQZ6lE84sZHuWYUt5Jk/vz5ZUBRymVzMFlDABKJoHsHULQbojc5AHd7RN76RHd2rb/mzEfVuVFNivatG/sy+Uead9dR2sIejihZrR1YSe3lhvS7rt4+pOXgVi9Lbfd0+anJilzfWbAOiKIYe+SN86wL+lKc6VrwxL7GYGjkyBEFrpef8qzxnFvLL8wHTzH0AfQP+sIXwEKJ5cGeCLCgMYLT9tySrB9Uw31Qob/9g+JlhJE3y2v0bYFS62aa+AVyo3ShurINuyPRKMyZ41y7lFdZbfvC6yiTT3retnZDe9+ixn1YLW/IxGcI6TO434dhwJW5CbH9OZM0NzljebDoKrkqdWODsI/mCQuwCdDBj88WUO5cBH7m1Cd88Dki59Eb8Dae07wMydbJGGvhgPc2WhIX6uKcYH4GjLg0X270oArZSlAbv6MZdO0I+JONMyGhDfJBo4uJPT4xI4bOfaL2l82QqCv97N3Gei7SJ+L0S9QXrFhhWlhQ4cagOpY9Xjo4oiI5
 U6IKUSRf
 k5zbzdwbYt48XB8ZEVUJrDARAULLNVL3SrIK39Gl0L7ibxJdl/NHkbvDbO3EXEMJPU1vu/4V+uxMWqL7UYg2nZkt433YEa/xVoz673D1RDc2M2hjEfHBBESPdjGagWO3mhRRkW5k1FNdwr9hcWxTSq1fo6UeWZJDzkhM8+nmaFK52yWC4Sci6o7ZRW10/R5UxcRMtaqyie3XZzL3fE4nTsLdWT5FV3WFBUlr2uVgeFJdxOv+Zd42gtrczlsBn8SkuCCFED/lVhjuJcJAAbXeIIEEHDgHifrT0Fvw7dEkBz94CoTvbdwgO3qXEXXdg9UjR5Bd4srqmSD5q8mZRlvpjKdKCB6gQqTWjEZEtVJvIAH5BSoVpV8ZdUlSVsMMPMgGR1tDkTZCxvcAB92GrxXCPPjd8VRfE10NP+AxnS6igv2/e6m9kapv7K7WvCAEXZPnUzV9rxKwZg+YlSayZZPL7DZ3XD7xLgW9/pVafFE2dOYqJL5kYFrPAXQJoYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 4:02=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> On Thu, Mar 26, 2026 at 08:03:34AM +0100, Michal Hocko wrote:
> > On Wed 25-03-26 19:05:47, Andrew Morton wrote:
> > > On Wed, 25 Mar 2026 14:06:37 -0700 Shakeel Butt <shakeel.butt@linux.d=
ev> wrote:
> > >
> > > > We should unify both algorithms into a single code path.
> > >
> > > I'm here to ask the questions which others fear will sound dumb.
> >
> > Not dumb at all and recently discussed here https://lore.kernel.org/all=
/CAMgjq7AkYOtUL2HuZjBu5dJw=3DRTL7W2L1+zVv=3DSCOyHKYwc3AA@mail.gmail.com/T/#=
u
> >
> > > Is it indeed the plan to maintain both implementations?  I thought th=
e
> > > long-term ambition was to knock MGLRU into shape and to drop the lega=
cy LRU?
> >
> > Yes, but MGLRU is not there yet and with development pace last year or
> > so we are not much closer than at the time MGLRU has been merged
> > unfortunatelly.
>
> I'm quite concerned about maintainership, as it seems the MGLRU maintaine=
rs have
> not been all that active, and the MGLRU to me at least is currently a bla=
ck box.
>
> I'm not the only one who's raised this (see [0]).
>
> That'd very much have to be resolved and the community reassured that MGL=
RU is
> _actively_ maintained before we could even contemplate it replacing the
> 'classic' reclaim approach IMO.
>
> I hope that Kairu, Barry, Zicheng and others who are interested int it re=
solve
> this, however!

Hi everyone,

Right, I think we are starting to make good progress on improving
MGLRU recently. For the last few years we already have some commits
stashed downstream to enable that on our fleet, most of my effort in
upstream is spent on other parts like SWAP, really looking forward to
making MGLRU better upstreamly.

Yesterday I was still discussing with CachyOS folks about their usage
while working on that series for MGLRU cleanup and dirty flush
optimization, and got some nice feedback later from their chat server
that MGLRU's TTL resolved their thrashing issue very well. With
classic LRU they needed a le9 patch downtreamly.

For many other typical workloads under stress, MGLRU performs
significantly better too (e.g. database, build kernel could be more
than twice as fast), it would be a huge loss to leave it unmaintained.

Barry also provided some really helpful ideas about MGLRU like
readahead handling. We are also seeing other vendors and people
contributing to MGLRU like Leno and Baolin recently. Things are
looking promising.

