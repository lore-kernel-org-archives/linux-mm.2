Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85653C61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 10:40:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74A186B0088; Sun, 30 Aug 2026 06:40:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FAD96B008A; Sun, 30 Aug 2026 06:40:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EAC66B00A2; Sun, 30 Aug 2026 06:40:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B0966B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:40:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AEB411A02B2
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:40:39 +0000 (UTC)
X-FDA: 85157592198.20.AA9E8FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id C12C6180002
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:40:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZKwTF8Xd;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788086437;
	b=7tKi7tcucDaWQjh39f6ue+ddNj1lzThhGSP8n/XXJwSnC6CPUTbwkwJqA9moNGYa0+lXl/
	TD2lMasRfC9I0FS3+ORbUho3YJAPfWLh2JJYbiwV9gN3H+kNHxvYbvcumysQbkhGj0LCsK
	790DCbuc268NUaNGw5eQslJqkxObOPA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZKwTF8Xd;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788086437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uFsR1+Syprr5J5tje5S4jkkUx1bx6a8Akbh+NdTo87c=;
	b=t76XtI5VvvXngIJBS2OBf9bMs7jghohTSdpIUaUb8nrsrtdpCy8C2wqkdCZX0brx0QgJdp
	kYXIC4YKXI+hfQ7N/w18VR0+1Aacw/YkmRlYfi6CGY58HXGDJdvCKsaBrxCtmsJHLewmFJ
	qqNUHc9xlF9b4HvUEu2bEwXeXIdQkWw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E47E44044
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466FD1F00ADE
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788086435;
	bh=uFsR1+Syprr5J5tje5S4jkkUx1bx6a8Akbh+NdTo87c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ZKwTF8XdyuTnYcKU3cKihII2IaOstkhQwk4UQEpQ6cT6ncHu/P3ABfgk416wQMaHR
	 f9kB4VtezvF4fGBXxVKBw8NZw9KIZehBGrW63xCNaHv8x5Dn3vmtuYj6emZjkUBlpp
	 6dUtGrVlipvgx77PIkg/YwmpAKiib21K0oodlswduGfpHE9HLLgXhwsie5HUst1jYg
	 sL+zBO9LRzC264DOm1bIgZKyvPZTxfhKFAlGb5tLpv/9j4zlSlNC5iDoDjPTINClED
	 fdm11sH5J4S19pcQsY/mz4cu7nryGkI+xlrR2DFAD3TGq7O/MNjI4QX0aUE9SwSYyi
	 usCapY+9/deiQ==
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c08df8513so15799291cf.3
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:40:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpRlDOeSA5lVj32W4D9qEWMhA7/qTQEMJXupxTBZKbvr9J55Tx2dR2v6xaZLtoljNFCnwyq7gPcxw==@kvack.org
X-Gm-Message-State: AFuF++lGHc5eTKRN4UTEIUgFaPHZIabFUMc7VFkc4mipab2D2TIMnros
	4W/QMRXWk1Uo/fUbn4nLVn4iIcxRy0USWnhl/JXsOL+Pqae2ktyzQEJ3p7nOvQZYNDjI4kVr9u1
	kBeisS11RukIwRJdIIqXNDhvZWxwf+2Y=
X-Received: by 2002:a05:620a:a0c8:10b0:938:fdde:34e6 with SMTP id
 af79cd13be357-939138cc83cmr1680232985a.28.1788086434432; Sun, 30 Aug 2026
 03:40:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260828110919.1324028-1-ridong.chen@linux.dev>
 <20260828110919.1324028-3-ridong.chen@linux.dev> <CAGsJ_4ws6edtcToqJQ0azJPTymAYj41nzdGJvBqEM+gROiJtRQ@mail.gmail.com>
 <c0a32c3c-bff8-433c-8552-f0723e3a07b7@linux.dev>
In-Reply-To: <c0a32c3c-bff8-433c-8552-f0723e3a07b7@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Sun, 30 Aug 2026 18:40:23 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wvYNV2UMaFW0a3Fb9U09v6bPfXyg4Rzw4B27xo-NVYbw@mail.gmail.com>
X-Gm-Features: AcwNN1W5OF4FZEbyI9ahVrtlbMzghVUAZzbwgduCOLK4Zm5BUL7Ps1VGygdfhkY
Message-ID: <CAGsJ_4wvYNV2UMaFW0a3Fb9U09v6bPfXyg4Rzw4B27xo-NVYbw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm/mglru: fix ineffective memory protection for
 non-kswapd reclaim
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Chris Down <chris@chrisdown.name>, Tejun Heo <tj@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C12C6180002
X-Stat-Signature: msio6kneprtgekabre3pmafnesawbofz
X-Rspam-User: 
X-HE-Tag: 1788086437-336311
X-HE-Meta: U2FsdGVkX1+962t5t55oLryrRObG+XwP33T+N5G+4RrFHacTQbHxeuT1iyKIgIa1rnUQAVYG/R/4KbGtyEbEDfPNalKakYiw5kzBDue33/TmxMVqLDmP1av3ZcB3tve1Om8vQI5JLz6oM9lFq/yCoe9x3PyM1CID/RI3La2VCVWx4uSr35ygXcVp1Rk0/k2WcsIjPTTItv4yE+iJf4Kwa3odO8XCs3webd4YepbdzjLFekPIRXAvQusiKHd86xfkU+26JnDQAxjpHuJ7DTCjgnym6nUIpkcvndjS2psDGb90/PUFYaJcVqfDQcTwu+JcF+amzkALRVFGPna9PQ8PG2z5ejpANhRAOsFMHLT3Z4HCwgBmSw292fawpDuWurZ0DEOyt5YYN06W9IxXEzSk9fRs/pU9kl3wgLQN+ju6oYqpYC5w6nGuGSaaMz1vxHnRl3DfS+Mm14i+vaEy6oih88t8GetbSmKtww9WecSKJhSqAqB0buuyxtinEEwmlCNipXKsouJn+uB3OFgdfNO/XPUcxZN+Cfs1TCz6Gos18MtD5At17DWj2ly5pF6XmvMhY0vlT+SKZphGfioETQbpah4H4gMyrclTJLa3Kz0DabG7RJSWrHjW8V9b0CjORKp3hGFAUsvbYB5S849ASbvattA/VUW+gLQgEDZIgljdc2eEa5Ua7f6u6gCfO9U2c53+RkM5leUbZTzwTfg1faa9COhYW5TB+3VCi9j8EMRsICgoGyCvMCtgclz1RRFtKTG1Bymcml2Kr9NQWoyQrLcS0yIJAj1XWvn9V/Xa/2NgIBeYutv8n5JcCZdp9YhSCiDbRT9H5W2RMxKYEwMxHZ1jCUjY1oPrpHoFfTSQK9jOMutgo6XRpi/ciHDgl1SCThpyboAMSzOLVbT8E9GzE+49WFW24srZCr5ZowsvKVu/ZggE09XpmcEEhO2EYXB1X0ZnRebGnsnMDfAay3uUShI
 9/TwIerk
 Gdnh5fbJYlgMN87GUel/tYa+gQ5X2lGu8SYF980q//rCN2Y8qiUNn+i3WN6ox75R/P9TZKlXIzY7SePTmxx9OtD3Fpo97GdbQG+Nvk0rGtDmXYIypA6/lRgzyhi6xDyZlK60mJOgtOydTULc/pEEXlWPAB//lHMbzZEfu6Q1S5owUi+W7OSbp42muAEWP1f3jzLVx5snyTqzjx/xsBBU1t10Bv+67DpTQp8h2fVlJB67hitqMX3g87s0iwXD2dBStjiX9Z0sd6CvQfCHlgYMuGg32pq+lJBfXmoNnERqlWRSjUVyyJMnw/cCa8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 30, 2026 at 6:13=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
>
>
> On 8/30/2026 3:53 PM, Barry Song wrote:
> > On Fri, Aug 28, 2026 at 7:10=E2=80=AFPM Ridong Chen <ridong.chen@linux.=
dev> wrote:
> >>
> >> From: Ridong Chen <chenridong@xiaomi.com>
> >>
> >> memory.min/low is silently bypassed for MGLRU during global proactive
> >> reclaim (writing to the root memory.reclaim) and global direct reclaim=
.
> >
> > I guess nobody is silently bypassing anything. It's just that the
> > effective min is stale data. If kswapd has run at least once, should
> > the protection have been updated already?
> > I guess we need to update the changelog a bit?
> >
>
> The children's emin/elow are derived from the parent's min/low settings a=
nd
> children_min_usage, both of which can change over time. As a result, emin=
/elow
> may become stale, even if kswapd has already run once.

right, let's just say this in changelog, we are *not* bypassing we are
just checking
against stable data. The current changelog seems to be misleading.

[...]
> >> +void mem_cgroup_protection_path(struct mem_cgroup *root,
> >> +                               struct mem_cgroup *memcg)
> >
> > Can we rename it to `mem_cgroup_calculate_protection_path()`?
> >
> > BTW, I see that the only caller is in vmscan and it passes NULL as
> > `root`. Do we need to keep the `root` argument if the new helper is
> > only used for global reclaim?
> >
> I'd suggest keeping it as is. This function updates protection along the =
path
> from root to memcg, and could be reused later. Note that
> mem_cgroup_calculate_protection() assumes the caller has already performe=
d the
> top-down walk, each level's calculation depends on its parent being updat=
ed first.
>
> For mem_cgroup_calculate_protection_path(), it can be called in any conte=
xt
> without such a precondition.

I am fine with this -  keeping the root there. but I guess rename is worth =
it.

Best Regards
Barry

