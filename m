Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFA74606A326
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 23:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mqNqzfKb
Received: by kanga.kvack.org (Postfix)
	id AF2F36B0672; Thu, 19 Nov 2026 18:52:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA27A6B06BF; Thu, 19 Nov 2026 18:52:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9919D6B0700; Thu, 19 Nov 2026 18:52:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 63CF26B0672
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 18:52:47 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D2CDA120CB2
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:52:46 +0000 (UTC)
X-FDA: 85453521132.23.7A2D2EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id E2E92C0006
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:52:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mqNqzfKb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795132365;
	b=FAJ/eq35fLSfpf2FBHyLGxTRAa6Uo/jMEa5cHLx6rMbEFegmH1OXcfjMnQw8MgX4rM2ob0
	RAk3MO8yJLvP9gP9P16uIVbPjMDjJdOtObcx+t4cdDsrCTfrGHo1SpZeczBxr536H4JHcW
	Nt26LhC2ED0PvwGD4o6V4iT8Qqvw+OA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795132365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UJrHYEnQ0yy/ldYky5YEoQN9xI+McH+P9QT2Lj87958=;
	b=POregNPoPz0OTD6saIWD7yeN7a5WPZwAsGt+Ziby9z4WmR84oRm4SgQCkzAdxeozHE7u+6
	1Sh32/Vy/Qk/aRv2KodVTWObFKr5TYNHEl3O0MzyQQaHpEEEox3VuDOYMgJU3h5r7dxBFN
	iRLsHtxME0KXyTnGbctEKiQWKy803P4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mqNqzfKb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5354046CA6
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390F71F000D8
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795132363;
	bh=UJrHYEnQ0yy/ldYky5YEoQN9xI+McH+P9QT2Lj87958=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=mqNqzfKbflUmz9HedM8L8+HrNGeTmPkCdEEhy9s6kuVEubXhjgVo5saokkOi0yDuz
	 GYqpQDHjqzkZ1fsR0mhbyHKNHdTo2qinC7iZC80lBVjo5yTsziyEQtSnIqWP2FWgIe
	 eJy8YsWvCHiMgEmbxQTqB43YhysP1CC+jQ/pyK4APK4XRJb18m8fpysu6EoUPNFvUj
	 nJ42wlqobV2nFSjFw4RWr24j7mM/HAAzidYXE9XLQkBrhZk4hnbJsiz8l2wFQeHDFW
	 LB/ZnDFjjqdAOIF5HvXSNKPQsRZagB4YqHdG/lTfZC03nnvxeBUtAVCkAEbrqBLaog
	 64oD3b0BWY0ag==
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-945e6d9ceeaso32385485a.0
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:52:43 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHs8hC2/jYQz9ry/rwWcvQlcLhMeViO1lOu0Veh8Utfnv0giUYIGpFkUHQXnL6X+tGaInKtmupwoA==@kvack.org
X-Gm-Message-State: APuU4Z+n7+iVhwkpbwG8AMW3yr9gdodqWRXeHqveETq0Mv6EIdDgFgKo
	PZaQEFViz56zGDFrIUUSO6lBxJeTxyZDI6XELeaSrVhfYKK5Nqvdk7zdec8Q3uA6/XgKdee7pC2
	gCWCUlROlZ7fWxwOPX3n/PVhn3LYkwPo=
X-Received: by 2002:a05:620a:17a2:b0:949:6170:b78c with SMTP id
 af79cd13be357-949ba9addbbmr226598885a.39.1795132361936; Thu, 19 Nov 2026
 15:52:41 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119154001.9b9f953136935a09e8a50af6@linux-foundation.org>
In-Reply-To: <20261119154001.9b9f953136935a09e8a50af6@linux-foundation.org>
From: Barry Song <baohua@kernel.org>
Date: Fri, 20 Nov 2026 07:52:30 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x1bm9AoB3PJ_CM9LxiHx-f85O3qYTvomROYcmYJ-ysPw@mail.gmail.com>
X-Gm-Features: AclHuK8MXJccupEkZyLKK4OZivmndEmD7ggxoROqdAHZoRi8ilS2fyKXpz1qOWc
Message-ID: <CAGsJ_4x1bm9AoB3PJ_CM9LxiHx-f85O3qYTvomROYcmYJ-ysPw@mail.gmail.com>
Subject: Re: [PATCH v5 00/17] mm/mglru: frequency guided promotion (MGLRU-FG)
 and flag cleanup
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Queue-Id: E2E92C0006
X-Stat-Signature: oo9ibyqf1zuuss7xfcrsbkzd3b35ewh7
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795132364-469224
X-HE-Meta: U2FsdGVkX1/YNF6t5Z7n1+JKnklgmIIWXaXflOrh5oOLN/WuXiOPXNsGD/Ls9BwrOklHu/jE9xP1nJhttk35l3OrVy1xntstdKJ30ga2cnO8sinTBQzPQCO7AjOrHqv01L3iuXwh9LKKkAsGWTzdrOPhKEMrdNVKmcA+ZKwM1rfOWEOPkyh6gRGz28XERDYKocykz20izDR9fkL1SoL0M2DAu3rLuRqk7XsTr9yOGrtZJShVh8uYedRzKxhZ+gbulHuSc1to6sMFZ2xNoXowubydW+QMGOvfkBhnN+4SA72QTP1dLGNG97+fW+gjUJaKXoS8BhtXVZD7leUx8BV5Dvxgc4X+h3WKwdT+i0bWjp4Tzo1hodVVONzW+tWmxTxO6rjGye39kouFCE6uWI9pxs7RtLj+sDQrSlJ7A35S4TF4Dhw/f6zAcLFKtOG1xHVF2iUui9SE4zQ57PGsvz6becT+f/sl9V03Q+WyThjDDZPqSB2riQHsFjTghJA47v+HXqcB4lx5XuJz5sivxpqo+9EKQBpU2OKum7+ZtpvCI6yqo2PvkRSpPXf4wRwKXe5jgvyccsSRmbd7wbVMxjGdjgV+XCMxBDa0P50I7kufrGki6tO9dSJIUSv/zxTl+iNv83C1jS55z3h4Fw/w/iaN/mvkLZ9reQgRRhp1J/yO7j/3lCwcDr50kYet1jQlSeeJa0leB+29wtEzsPxx6OwoX93d4MXjSo6AitZQpftBj1XdIA2TfCLO4jGI8BfeF0YdlkPKDOgZZMxbr6CUadp1bvupCf+sHz0UfODzLCjxXfF48ztsl5DisClOKEw0nJOHbHRtcbq/aQzzBCgDZE9ZcvU6CLbGvRRzrMqnXd9lZeH7GpVQCkcGagh6OImHvYwNTf2whKhK6sjvp48N2A5URmPx3y48mAPk+OC3RacR7P4GGSx6mNua+W8UpjhtHBSlBip2Lb4JnHtlTxC/RIp
 wYXv1P5A
 ERZO231BFxkfSWCW3v/wL2+xE+ycZshOl0LUqHuLHoqkNPGvMZgEEP4o47PBw3wrKurvoca9mHx8MOO70yrVKcAqB7XOkBCGGK4IHhDHHl4supBYH2W3i6ut4Itic2xYRLQr8IpaDgR5D9933DClPC07njCs0MRqu1+WaZXrwnDa8wVtx47LQ7JwoWAVBX1vPT81Bgzx7aS/b4A4KIPlqy8xOMJNZQhWmpLS5Bx1pgOoLHz2g0A3cV851iFzXJs+Ou19nHzA5Z832ZR5JGlo1q7bReOdXkJwDA0voGY6CjjvtHtBev6BF27DtEBUi1nlxQadfY9Wt07P20bYt2P4FOmS1nBUwsTO/gwLLJCG+N8leXnB6UiKaMsuRDb2pfkvrOGHBsp//F7qNCUn2avwmde6FhYYtYZaIGObrg08HCZFDSJovY05OWiLKqYOzKBbGCuutQIsQnlR4PWWwalZ5KwVQivLOBfn0UsFSU2Yqj0GEDLbN326RgnKoUgt8wtkHFtvHgdIklBDgnp1D+/yPRquUWTWoTNKNr8AsZqeh5Zt5hnoqgzRwDRP80Dp0C8CsfloVH0pEdoM56Fa2abZbyTGFisPXt0o8rZTfpwI6ySl04tvFmL6ESAZtOvNC9z/6j4MtGm1+HP0O/RmU4mu2M3XbXDwpTbS18aNs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 7:40=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Thu, 19 Nov 2026 05:03:32 +0800 Kairui Song <kasong@tencent.com> wrote=
:
>
> > This series implements MGLRU-FG following the idea proposed at LSF/MM/B=
PF
> > this year [1], based on current mm-new. Depending on the workload, it
> > improves the performance or reduces IO by roughly 10% to over 50%,
> > fixes multiple long-standing issues with MGLRU metrics, and drops one
> > page flag.
>
> This is looking really good - great stuff.
>
> Review is thin, so I'll remain in wait-and-see mode for now.  What do
> people think?

I'd prefer to see this go in together with the swappiness fixes,
as the two patchsets complement each other.

I've been rather stretched lately, but I'm doing my best to
find time to review this. Hopefully, I can finish the review
next week.

Thanks,
Barry

