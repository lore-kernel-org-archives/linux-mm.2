Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91F37C55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 16:52:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 437766B008A; Thu, 30 Jul 2026 12:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E7A96B008C; Thu, 30 Jul 2026 12:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 289116B0092; Thu, 30 Jul 2026 12:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF4846B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:52:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5BE9F1A01E1
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:52:55 +0000 (UTC)
X-FDA: 85046037510.21.2B386BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 753FE4000B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:52:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LSCYA78S;
	spf=pass (imf11.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785430373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hIPWuoCXtPq/jgTe42IUcZ06BVyrHgB+kF/1iTPh0+E=;
	b=08RHn9YRWoIiExtQQAOBWOs1uJREwIWs/6d6Fmfmd5Yv/2ak+knHGcbqzOZs/DrVrJB16/
	wr6SXrFQfopJh1yTs7TuFvb3v/f42Ggp9fGCkz31d/ZcVIDrVR7lc3UIlEztuMGaWT0RhO
	utH3Kf5FT7Lt/+pU3j9EU/5KrAIK+gI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LSCYA78S;
	spf=pass (imf11.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785430373;
	b=C8ND5ARIvw6b8sgyuSVffLw5NpZyHC5q/Wp/42UPtEFNI8qO3MKrXDU6hk78JTDgkS7GSY
	cAxLiZm/XgrC9nnIl2k/uaJA+JBcgJgGGQcGk1t8AhLWwwP/NVGcIPAvmaLiUL2TyTqeS7
	p/PSuhTk+yRCNbLj2/NtJhuV5eA+OnY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AAB4C4408A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DE61F00A3F
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785430371;
	bh=hIPWuoCXtPq/jgTe42IUcZ06BVyrHgB+kF/1iTPh0+E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LSCYA78SYvAyoOTZjZDkiXV+tGoKEfjO3NVXLGdO45PpHtOjomixkOskw2L4BGb4Z
	 Nf+P83U9ZWy9Jdx/hSPWvkvgBIiRp4AeeshYePlea8N31W6UXxIcHBO5D1kA8ystl7
	 MpvY3t4uTzuqGbp2LfjH7y1xWoQLBaXl1oVZB+n50F8kUnu8qejNTbGMa4q3dAZeV9
	 uS6o74al/w0Ng1884BwL/WaYuK7r9QmdC/49rmBVCUohHY3Y0x0YvIHjuUGMcnOFkI
	 WmbFt2qdpfyairWXpFnfiVJgKkBPmxucp7zYvLyuWmbz/zN3BCn2yonfjZ9a0wOQoM
	 pPtMbHujc67iA==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c1f7666a90bso335658866b.3
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:52:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrTplvGqxSubgn11owoFLPf6MZnuiCJ+JmWxiN7YhJLV3tSfJCP3BgL+SDQTzrY7Hw29oUBwQn6cg==@kvack.org
X-Gm-Message-State: AOJu0YxeqY95cnyqiK04JxT5ln9RsCBtPyrmRaHVDSvyaAdtuFbGGNzp
	ygvYpZwUvhAm9DZmc26rxQlgWP7JikOI6je5/LhGqInvwjCtmDlZVK8cwrr6ANU10XGuQf3cTPn
	MObOYunfmoxvA5CKdBcsaoH0W1eEZE00=
X-Received: by 2002:a17:907:7241:b0:c12:528a:94f4 with SMTP id
 a640c23a62f3a-c1fa56a2780mr173355266b.60.1785430370347; Thu, 30 Jul 2026
 09:52:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260729084206.77793-1-jiahao.kernel@gmail.com>
 <20260729084206.77793-2-jiahao.kernel@gmail.com> <20260729155858.c7aabff48166a9bca4d68ac3@linux-foundation.org>
 <CAO9r8zNhBCghP8T_98z2p==Cfs_=kamcRN_3ROxaj3R8PN2Qvw@mail.gmail.com> <20260729181756.a37e0cc7ea3f6013959d1d25@linux-foundation.org>
In-Reply-To: <20260729181756.a37e0cc7ea3f6013959d1d25@linux-foundation.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 30 Jul 2026 09:52:38 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMPxdn=MOFD9mbrzed+C9HhOB5DpHG4QS0OJzqV_gLvsQ@mail.gmail.com>
X-Gm-Features: AUfX_mx1JShU4xIT5ANEqpzQMh3RRrHaBazoTKh-oN9MrjhE15twPkvX8ce_pog
Message-ID: <CAO9r8zMPxdn=MOFD9mbrzed+C9HhOB5DpHG4QS0OJzqV_gLvsQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mm/zswap: Fix global shrinker when memory cgroup
 is disabled
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 753FE4000B
X-Stat-Signature: 5m73fxh361ye6m5b4zg43dzermrsykw9
X-HE-Tag: 1785430373-557094
X-HE-Meta: U2FsdGVkX1/OEcCf83Es7Q/Yjk10+3X0+w9oAFeO0f1Z0M1Nrs6T4loRcwRI5AYXy+PEu15uo4W9aEuFpCOGxZkI7jX669Scp9eZhztxRp2X+VQrPuz6QKtwS/P1g8Y33TG/142BPbjqjE35j0pZqMNcaW2piEanohQXD89XqwEt4DjjNVyARYr8BXu/ZsnLYLf+uqNRvx0V2eyazhAlx/IEYOxXmkXgmLqmn9WEwXy5EbsD3motAxsM8kG8o3Tsj4WxlOaMQDGM7M1HQczNLBYn5aOIkSqbQPKg+IIxqV8Nm1h6bqWq2oeAh7UaEYJP2xRTOu/ub1HD+gh3qFOU4g757ISAJ0wxD3/dJYUXVKl76j7alp54OaWcjtUga5vwoGA2hJKCdq6/6CjI5C57IkDwrAoFXKrUfMhc8LhCwgawt2ubwK21/RgHlUdUR70oKgO+2iwe0JbOmTlapaD5FLAo+7exekADN4X354druUsDLBjAPpWulk3zkEagzqMzts+jY/saL2hLJjkIssIY8SNbejyen86e3+VqH452yvm6M99w/5y2vxzsrv0ZjVLNRAxsgQ3IPeb6L3ltbUHLA0wkXG7YosHOeVHOZWLNhyE4J1cu50mYbpb1uWXXI1HFT4A0I9i5dTqM8DKO3+nXy7fNOxex7FZp4aFnnfadYe+h24Vh4MhFT3nk7LNPu9cfkYyMf0/jbblfcKCLtMi/7lF2UiykQgvY/Mg8Nkfr7ubbsmmXOPQkjfBZGK70L/q7O5b2RdpyzUDiLwncG2piGv22o6XkgRD/MEWOMqhqGaH22Fjp9neo9xYchKeI34JWVQXgwDg4+373oUDztMiGuhuNUeFGsxcGuCKAu9luDa/LBMkG6bJBtLkaD8Pk/9W6JMhMcPx/WB29HPrjQhOGUpW09LIxtZJ1zdJOiqdShNoi4DKZmwnS/Iigx0XWKMQcb0AIsmZ+wS9tSt5YLCl
 hQGjOlXM
 uJPlC0KgTmIpHsHQ5jGj8CyaCeuDTiNtevM7uI8IdEz5A/4Imq6W25Qu8JaUNOr8JMorx3/lZQ+DH1TnzRBHgb7u5dWyKAkr3pQYLlL3UiErQLBSu9BGPAfF/3vlkubeDXLFAU96vGL8tE77GUNVRtRKUxi65pcvw5WF0iV49fY8OMGc9HZY5QpFU4fC3vpikPdjXsEGuk3w2BiTCnOxM1xuRLwbH7WhG0Lvpu/vMaY9DYtkmiRbw/O1P+m9fSSmsJ29XpMynPbBYyeidKhtYnqQb44nURHmdoRKiWmho2nFawbnhZheh5Z7XowHy9nPIcHvl/cFWzNehLpf3ieOfO4QcQi8M+qql29Ik4rZTHM6nDJTsbTa4MADsHEUEi8t8QoERLVcO8eLVzTW1brrA2Ikm18bnyfHiAeo7llSIda7EObYxStBfPtt6z+8HvOU6nZ7/x8PuYbCrTGbLZMqQ6wtmWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 6:17=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Wed, 29 Jul 2026 17:30:56 -0700 Yosry Ahmed <yosry@kernel.org> wrote:
>
> > On Wed, Jul 29, 2026 at 3:58=E2=80=AFPM Andrew Morton <akpm@linux-found=
ation.org> wrote:
> > >
> > > On Wed, 29 Jul 2026 16:42:05 +0800 Hao Jia <jiahao.kernel@gmail.com> =
wrote:
> > >
> > > > Zswap writeback when the global pool limit is hit fails when memory
> > > > cgroup is disabled. The pool remains full until it is organically
> > > > drained by swapins or memory freeing, leading to zswap store failur=
es
> > > > and pages bypassing getting written directly to the backing swap de=
vice,
> > > > causing LRU inversion (hotter pages with higher fault latency).
> > > >
> > > > This happens because mem_cgroup_iter() always returns NULL when
> > > > memory cgroups are disabled. As a result, the global shrinker
> > > > shrink_worker() repeatedly takes empty walks. After MAX_RECLAIM_RET=
RIES
> > > > failed attempts, the worker gives up without writing back any pages=
.
> > > >
> > > > Therefore, when memory cgroup is disabled, fall through with the !m=
emcg
> > > > branch and shrink the root memcg directly.
> > > >
> > > > With memcg disabled, shrink_memcg() only returns -ENOENT when the r=
oot
> > > > LRU is empty, which means the total pages are already below thr. In=
 the
> > > > absence of heavy concurrent zswap stores, the loop then safely bail=
s out
> > > > via the zswap_total_pages() <=3D thr check; otherwise, it will resu=
me
> > > > shrinking the memcg after processing the reschedule check. For any =
other
> > > > return value from shrink_memcg(), the loop is guaranteed to termina=
te,
> > > > either after MAX_RECLAIM_RETRIES failures or once the threshold is =
met.
> > > >
> > > > Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
> > > > Cc: stable@vger.kernel.org
> > >
> > > How does this affect users?  What behavior do they observe when it
> > > occurs?
> >
> > I think the first paragraph sums it up pretty well, especially the
> > last sentence "hotter pages with higher fault latency".
>
> How do users observe that?
>
> See, what I'm looking for here is an explanation for why we're
> proposing a backport.  How are our users harmed by the current code and
> how does this change benefit them?

It's a potential performance regression when using zswap with memcg
disabled. Sorry I just realized you were looking for a high level
description not detailed symptoms :)

