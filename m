Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42D2E606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N857zjfe
Received: by kanga.kvack.org (Postfix)
	id 6663A6B05DE; Wed, 11 Nov 2026 04:58:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6167E6B05E5; Wed, 11 Nov 2026 04:58:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 508A96B05E8; Wed, 11 Nov 2026 04:58:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B3B96B05DE
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:58:09 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A3418A78C3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:58:08 +0000 (UTC)
X-FDA: 85422387456.24.5B8B1B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id B7F2240009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:58:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N857zjfe;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794391086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x8WYaUyHEV3s5p2jssXz770F7CHpaoglZMsT5OswgdQ=;
	b=GxuuKWEXNUJCJE18Ebk67HABKn2d83FHGdxYFU+wf2qHXgzap9DQTsuKnIiT77C3XUn+rb
	7/9ikOmlWSlWQPkbeBFSjX9YFqsEueJyqmZc5fld7xjZrUtp1OMD07kUnHdc3In8cXWAzW
	6A8Xlpslm/q+lQUOlkQbof1dwhfzqJ4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794391086;
	b=1kivaQnZ48WvLe8V+mBI5X2oZbiHrDzDKIQ57rJ07WAuymGh9ef5Evf2jhrxol0hplxCjs
	Sn4nuBnHzEs8ecjSm8v9cKRxNA8hmmg71mcNSV3jDpbWb0VctFEKJKtba+dVPbn4bjDGLg
	TMn81xzFMQyT1hhjfsZgRM5G35Z1OlI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N857zjfe;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E79C545E6F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:58:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5131F00A0B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794391085;
	bh=x8WYaUyHEV3s5p2jssXz770F7CHpaoglZMsT5OswgdQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=N857zjfelwJgxMwZgeMvdviy4yb25FhIkfYq9xYiegrSWPbwNMp0kTtnImQAwnhLx
	 QKigHsKalH2vjAw/nxrSgVxbl8NitojaovS5jx9jR2An9toiCSIXjvbUVXXGo3LXRH
	 x/2WHbp9K0hGTSnSvseQzBQIbwRiZLInhUZS7zbONYGXfBZwBJ6Bm/KzauvYrSPjT2
	 GsA1dHR5bUM8ZsGunn5xNirPgvnmG9DBk1CS3Jq2WZrbl7pSA9AiQRRABBZXxIR24x
	 xg9CYEYdZRbnT4xig27wGxrETP3lprjb5D18kPE1VNECuj/mqmgcVUI1gnkIM3/l8v
	 qNv2GaBfHwwRg==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-93e63ee7b4cso269965685a.2
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:58:05 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFv9ODbQKdIm6dYK+gyzqIHXtdUCeUUVmcBB1ruBuqfjqZWBtNGhO4wIwKB4gzYYMjFZzDt8OJoeg==@kvack.org
X-Gm-Message-State: APuU4Z/j312szu7+Ks2KbzG3C9PPfa5F8pMTeFdVBCkRuPfqN1ffJ7Ql
	ESDAMUzhMwlFhIWMb4v8pBZvCpywbp9tRK0H7OLaY4FRFMT4ecSGmvBL+ovtw6MejcrzdCSY66E
	0dYCALeW3oHEWaB0OfZ2vC7vatSjf8DI=
X-Received: by 2002:a05:620a:2805:b0:93e:e425:229f with SMTP id
 af79cd13be357-947b00ea38amr289814885a.77.1794391085076; Wed, 11 Nov 2026
 01:58:05 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261109-maintainers_mglru-v1-0-c25e6de60bcc@kernel.org>
 <20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org> <20261109104142.c4e01c2e29ee9ead4056f354@linux-foundation.org>
 <CAMgjq7Dd6UQWfBwex4vTLdxAhHKMfpmgTG9DB3MG+4+qig0Eig@mail.gmail.com>
In-Reply-To: <CAMgjq7Dd6UQWfBwex4vTLdxAhHKMfpmgTG9DB3MG+4+qig0Eig@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 11 Nov 2026 17:57:53 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zrBB80iR+R0oi7BaLGNcw0sk_KNEFYns5G1WEsMXCQ2Q@mail.gmail.com>
X-Gm-Features: AclHuK-Ghv2CWsuvoFAiqxBS_I6Udh_YXnqVh2xFzO-4R4-Vf_0ARb-xDyX3CmE
Message-ID: <CAGsJ_4zrBB80iR+R0oi7BaLGNcw0sk_KNEFYns5G1WEsMXCQ2Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] MAINTAINERS: MEMORY MANAGEMENT - MGLRU (MULTI-GEN
 LRU) update
To: Kairui Song <ryncsn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Lance Yang <lance.yang@linux.dev>, Ridong Chen <ridong.chen@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 8c7hpiemnn6iopo9f9z6313ox6bqgajs
X-Rspamd-Queue-Id: B7F2240009
X-Rspam-User: 
X-HE-Tag: 1794391086-826057
X-HE-Meta: U2FsdGVkX1/QLsAj6o0ZolyJPNq/W4JN/jpj5LNlkMW1wPswkyycvg1FebOu29xfo+cEdUc3BZ4yIjR8tjELSG2FBP/m8h0P0oV1VHEJrQpKN3gfBsTfhYLskz9i4qlJ9U2IsRy5mcinoRQEjxyWnPaqsKWLP/dCfQ+f+1zfERAAUdEadrJZPbORX9LfKedo6PD3uyiTbRepQnUgf9Di7rfjREjPqOimY4SxXf2V4AbDXZZT/P8VvNq8OKcZrQ4B+gsixzGisa5JQLtNMbT07RMt5X5lmvvMN3BXmVfcwf3yvuV9hU8kMqAmwFdL40W9K0QXtP9qhIUau3RMKcze6JAy/HSnKnTEUpLlXoIOHCjA/t5cOelEGWZXwIU9WbEKAHpioycNsEdP/bHkZhCjXK14g2Jp7ZkR5MPTc23hmpoFqDuxf574+ZktrdugyUNGsA+2pfYPVaihSDqFBPitkJLB/r/5aCxDgabbsTMAvy8P7tZGbxmFu1SJ5dYnmPL6aQYAQiulYW+yboQKWK+oIxwTYlA8Vp5SgATK8K8jb43AAzm9NOKtSQNFrGUEtDakd8NZ8PCKxVZMuY5L6UZknftuhpqBdJdVyb39OM3QXReVfLBd7MP303EILxpxtMyEIKQExwhOw3H8JttOkuvaskGgPs3nbrZstlDEWF8sAM+0taEjnBuMVIwu7hGOPCMumDbf2xr9aWhPZ5g03D0f5yTJQfg1SWRtZGmaHq9FAqy23QsdAxCa2Zx/Fq3SwRacAMRjvlyTWW+QjVNNAksvKp9GTJhjaHTLWA7qU6/XN6mX+kgxu7MvAkzlzjduxi/7JTWfQ4Ptp8mEfaQNds9F7n6WroYmiAyNjS6/LWyksTxNToEsWsP0TLhpz/QdCv+GMwazpc8Hb9pW8wPxZXhN8xhPnX5RtETwzezyyY0WEuZJoLGgBPAdhMTSDICwqg4ueAX0+fyh5jbKEuZEb13
 GjeUKcHl
 /ipE84NkyKPUeFTtLntmzy+izpociQ0ZOD6GSxvaofcRjw5UPyaHRi2Pz3WTTqHR/VLu1Mtw/BJlnmJEgeANYDRLRXC6YhCkOE/eFiBe14RpsJ1AD9FJyNkcvoPEaCXafeYScenNg5vHdr2DPxU1R5tQdt6VyibdVWNmJAWEL2N3EzijP3OyZnAjjlxi+wcOxZOcjOsF201nMg4gFUA9LOPLSe1IYJ87wuv2oeHwkicpnEFctvm74yJyKb0018wFR27kMVb8KxHWOP0tCtSkt42TtnJbvPBCAoQCEZKlJuPJs9R6dcHj1akrzmDVPIoYZv/2OT98XA2fSHN38CmFaMyClNfUtcstGCpwhtTzsdoVGP4bfCA5uCC9oqAhQ1X6WRMwPYLrZlwtoKqI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 2:16=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Tue, Nov 10, 2026 at 2:55=E2=80=AFAM Andrew Morton <akpm@linux-foundat=
ion.org> wrote:
> >
> > On Mon, 09 Nov 2026 19:31:53 +0100 "David Hildenbrand (Arm)" <david@ker=
nel.org> wrote:
> >
> > > MGLRU is currently the only MM component without a dedicated componen=
t
> > > maintainer. Fortunately, Kairui and Barry have been actively
> > > contributing to MGLRU and have volunteered to take on more responsibi=
lity
> > > by officially taking care of it.
> > >
> > > Given that Kairui is already an established MM component maintainer i=
n
> > > a related MM component (SWAP), add him as an MGLRU maintainer right a=
way.
> > >
> > > For Barry, the idea is to transition him towards a component maintain=
er
> > > role over the coming months, starting by moving him to the top of the
> > > reviewer list.
> > >
> >
> > Yay, thanks guys.  It's been wonderful to see the rebirth of MGLRU over
> > the past ~year.
> >
> > When do we get to remove the legacy LRU???
>
> That's on my radar :), though it will take some time and it's always
> hard to give an exact timeline...
>
> Items I'm aware of to sort out besides the FG series, maybe we can try
> to make MGLRU the default at some point during this process:
> - Refault distance, otherwise we still have a major regression in
> heavily overcommitted cases, also protects cross-memcg workingset
> thrashing. I also have an idea to remove memcg id and node id field
> from the shadow so it will have enough space to hold both the gen
> number and distance, will post that in a few weeks hopefully.
> - Memcg LRU vs. iterator (Ridong once tried to unify that, and it's
> good to see there have been optimizations for memcg LRU itself
> recently from Max).
>   I also noticed recently that the Memcg's LRU reclaim balance is
> somehow a bit broken, I'm not exactly sure why, nor a very major
> problem, I will look into it later.
> - Isolation protection (from Hui, not a very high priority, but still
> on the list, we don't want premature OOM).
> - IO cost & swappiness (Barry and I are still looking into this, with
> an series posted).
> - Page flags usage issue (FG cuts it down by 1, though it's still tight).
>
> We also have aging optimizations and async aging planned. I'm not sure
> if we are missing anything else, but we are getting close and with a
> sane todo list.

Thanks very much, Kairui. Besides the items above, I am also
thinking about a few more:

- Cross-memcg aging / look-around folio promotion (folios with
large mapcounts across multiple memcgs still easily fall back to
rmap walks today)
- mmap_lock contention during aging (perhaps switching to VMA
locks, as mmap_lock contention can cause jank in Android
foreground UI)
- Baoquan's PUD filter
- Making MGLRU more friendly to Android foreground/background
workloads

Thanks,
Barry

