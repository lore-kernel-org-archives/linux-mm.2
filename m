Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72E00CDB466
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 02:16:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2551E6B008A; Mon, 22 Jun 2026 22:16:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22C536B008C; Mon, 22 Jun 2026 22:16:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 142D66B0092; Mon, 22 Jun 2026 22:16:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E67286B008A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:16:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6ECA91A0392
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:16:12 +0000 (UTC)
X-FDA: 84909562584.10.999C796
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 76EDA4000B
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:16:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XP9pTHwD;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782180970;
	b=Ir4RIBXe5UIQ24s7GI0+m+ModWA50lu3f00IWJeFxLWeGMVhhii3qDB5JeuAL8ymb1zj0y
	sfPrGgfTDcFTrGLTzb2mPpp7hD/PWpppyJkzj3ytTzEJy2BDWJOOJe4fC03n59kd8Cig91
	M8DiCoYmAKbVGw7qj1z1qBelseqnF48=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782180970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ORG1110TKZO9YaLb3hwjWsJ78jK9FF5h+lt0diWED9Y=;
	b=T5GWxHD9dRPsJ0IxHl/uG4mQ1DtzHqwMPN8Uph4mHffpWzSLCZnJa/gZF7UumMpAYDzwlv
	RKIu91Bph91sKYZnINGv+Jk6y6fY9tccho599iE/Un2isrt9/THwtXzBCSI6YvVBtBjw7q
	EX6ecovadX6t52KY6yaew+5e44daJF8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XP9pTHwD;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9284044451
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DAB1F00ACF
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782180969;
	bh=ORG1110TKZO9YaLb3hwjWsJ78jK9FF5h+lt0diWED9Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XP9pTHwD5gI1rie9x1qke3VNK/muvum94K8NNGS2ZMK54STe2BUBuLXVUXfRjPH73
	 4Hlj5UP7dXLZf36+X++F/7Y5ao0IedlvQWGMOQzD1OKXrRoDv6UBmohd+pLVhtamhg
	 G/+SUxjqqhvaDubmB7A/u0did3yllQW3yIZ+Nr1Jz6pQYyTxld5U3N6aujTl4UVMHp
	 9ZU7Bq8wouzCdVUUezp/WMhyqRzfS/3g57JUSe71KT/n/tAyokKKJBjslwUFinf+a6
	 jocINOArtkObwpQ6R91w0PLxa0l0Z7D/aWt2RG4oe6BOSa8oLA/4mTm43iWE9/qLdM
	 Z5LuGHy89V1MQ==
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-923220bf1d5so154261485a.0
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 19:16:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+hs7zc66ViyitXrZBp65IGctBCzlSL/mA2gvamOKuVi3JNalNwJZTkUvR7eXu04DzQX6tciWsVXQ==@kvack.org
X-Gm-Message-State: AOJu0YzbDYT3VBeRMNQOnY1tZRqcx+YWkDpmlTdQbJto5MsoP19wEgaY
	DjxxzH6g9E/vhbf5cxMlB0RJO+ZRF74zincqcrHS24/6uKoHYMhM/HaaqgGoTmQAhXYSgZSAbFx
	GT30ATnpyOPQrz6aff5MC4QUQSKHN9r0=
X-Received: by 2002:a05:620a:4455:b0:91f:12a7:beae with SMTP id
 af79cd13be357-920900fa471mr2990686585a.24.1782180968833; Mon, 22 Jun 2026
 19:16:08 -0700 (PDT)
MIME-Version: 1.0
References: <5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn>
 <20260622073703.79258-1-qi.zheng@linux.dev> <CAGsJ_4z34ZRu_RKkaZ7EgTWMOxptUjZ90WJyNoJrXGNjzutxnA@mail.gmail.com>
 <19710ee5-8e1c-4b13-812b-4b03ca34260d@linux.dev>
In-Reply-To: <19710ee5-8e1c-4b13-812b-4b03ca34260d@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Tue, 23 Jun 2026 10:15:57 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zC8jMNk0twWQd+oRWCzZTm523K-KgzDQ6TkjbzPq4MTw@mail.gmail.com>
X-Gm-Features: AVVi8CcgxGHg4osYX-YWIWEqreagag-ELHwB1D_7PjRMnGTDlB9P1uVVdJMh8og
Message-ID: <CAGsJ_4zC8jMNk0twWQd+oRWCzZTm523K-KgzDQ6TkjbzPq4MTw@mail.gmail.com>
Subject: Re: [PATCH] mm: mglru: fix stale batch updates after memcg reparenting
To: Qi Zheng <qi.zheng@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, hannes@cmpxchg.org, harry@kernel.org, 
	muchun.song@linux.dev, peiyang_he@smail.nju.edu.cn, mhocko@kernel.org, 
	roman.gushchin@linux.dev, ljs@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: azxyntbfesd5cj98bcnw553335b33w1s
X-Rspamd-Queue-Id: 76EDA4000B
X-Rspamd-Server: rspam06
X-HE-Tag: 1782180970-417616
X-HE-Meta: U2FsdGVkX18fUOQRWtia6bpqxV659RkKbHvoLmwtVpWphTgbNxy+lNHMi3XZ0DsinS3EdYxBSh4Rdq89ma7KOHcuL8B9LMBBCYpQHuosAVu5yYYiw+oQT4716Y5lxUCwkUCYEEUXbekWXb2WT+/UwO4UQLVPojHjx61tGd9fYwWsKMgrqWJDJLQQHSB/VV9dhX4L2wGOqkl+PiHp8spbVCVOBa7mMBVHkLpNKTCwqzmVWFkUo8FXvm1j5TJL+p9BT/fRzno5Fn8kiuFLJjSSiYFJRTsFxgemUUBqs8jBui63v74htDNo3jD2EoeCQo8AA4DA86bXEU0O8wUxugg460h5W/ohqYBA3Cq7ZsuOo1FNxay3mmJydV/FuNFNWWBIR55zK6ac6A/5oV/TLgXBPtYyzpM+ga3yD94BD0xVj6sOtA0gtxb+v+xf3iJLkNZOIYW94u9ljbHw9DM8FbUmCRT5pTRHBiweLB3SxQi1AbsSbsczkmmcA+V8jjP/BxS1It3vWss6Y0TSigezvSSKNJrrtyQRSa1fF0FdQmfl5FmLlVDKJ2Y11DtBkEKb0HLXBF2JKnfuIcA690+yVaJNIAI5Aa8xTavqmJ7oYenFgxcArmmC0SI9dmmiPHhsQAckUs+ckVPTiOTIdYn4wXFAzdGhq06s+RumA5QRYwU5XiNswqe1xOJoleVQM+Re1q/wKVQwUZgxB7Hykiyp5flEULfBSKclcp1/7jv/RdJNoF7A7D81dspf793aLJF4TFgY3avV07pjZHew63eInMrBMiCIMgyh6wvs0tcEJ9f4P8NCA2E8rHbL+a3mojyXtLs8qdANiBiM3RiBxe4pb0hjLHZss9QGLDlHveN1WPJNCAPOcjC0xQ4Y5cb0h+G2JR5H9lrgblGdKFuxrAf0swmCHNmK4CSJY1rP3rHYAoZ19A6G7WOuje2LupWpOJ3NR/xUs97D4GGRhvuT901SUPE
 mWV7ae8r
 5FPirEd8Q2woyBapU/kFIIGIjFivifUBBLvBLPI/jRssWp8H54/XxNhxpu6ZJqUw0YwRT6jeuLxDi0S+JEFZQrkLf7Qtj5iYBo/QvBuzJAtVyqDrPS9SFa9ZVvmMNXQ9km/9Bbq2O8AhJhnguwoBzgO9voA7coR2pGn9dny1JnkRPH+ilLZ4ZXDu5GTWt6HGqTOq5xa+p6VfQ9XKir0+qIDvpbms/+TZ8/8t8XQVGslvnOWL/abdY3V9iE+o+A/4VaeOZ+sYNJPf1YOj/57+a3UK6QtO8HwoGyWoZCh6DsBDiq7ojZbIh+fvRcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 9:58=E2=80=AFAM Qi Zheng <qi.zheng@linux.dev> wrote=
:
>
> Hi Barry,
>
> On 6/23/26 6:52 AM, Barry Song wrote:
> > On Mon, Jun 22, 2026 at 3:38=E2=80=AFPM Qi Zheng <qi.zheng@linux.dev> w=
rote:
> >>
> >> From: Qi Zheng <zhengqi.arch@bytedance.com>
> >>
> >> The mglru page table walker batches per-generation size deltas in
> >> walk->nr_pages while walking page tables without holding the lruvec lo=
ck.
> >> The reset_batch_size() later folds those deltas into walk->lruvec unde=
r
> >> the lruvec lock.
> >>
> >> The page table walker can run concurrently with the memcg reparenting =
path
> >> as follows:
> >>
> >> CPU0                           CPU1
> >> =3D=3D=3D=3D                           =3D=3D=3D=3D
> >>
> >> walk_mm
> >> --> walk_page_range
> >>      --> update_batch_size
> >>          --> walk->nr_pages +=3D delta
> >>
> >>                                mem_cgroup_css_offline
> >>                                --> memcg_reparent_objcgs
> >>                                    --> lock lruvec
> >>                                        lru_gen_reparent_memcg
> >>                                        --> reparent child folios to pa=
rent
> >>                                        unlock lruvec
> >>
> >>      lock lruvec
> >>      reset_batch_size
> >>      --> child lrugen->nr_pages +=3D delta
> >>
> >> This can trigger the following warning:
> >>
> >> WARNING: mm/vmscan.c:5867 at lru_gen_exit_memcg+0x26f/0x300
> >> RIP: 0010:lru_gen_exit_memcg+0x26f/0x300 mm/vmscan.c:5867
> >
> > I can't find 5867; instead, I can find 5828:
> >
> > VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
> >    sizeof(lruvec->lrugen.nr_pages)));
> >
> > Is this the warning?
>
> Yes, I just copy-pasted the warning log from Peiyang's report.
>
> Maybe the description should be changed to:
>
> This will trigger the following warning in lru_gen_exit_memcg():
>
>         VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
>                                            sizeof(lruvec->lrugen.nr_pages=
)));
>
> >

Yep. Can we update the v2 changelog accordingly?

Best Regards
Barry

