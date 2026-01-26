Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B39D6C88E42
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 02:01:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 207916B0005; Sun, 25 Jan 2026 21:01:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18B316B0088; Sun, 25 Jan 2026 21:01:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06D626B0089; Sun, 25 Jan 2026 21:01:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E6A876B0005
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 21:01:22 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8550ED378B
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 02:01:22 +0000 (UTC)
X-FDA: 84372462804.14.9D30041
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8A62140008
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 02:01:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C7J7bCL1;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769392880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NzhBh7ZDlZbLrgRg7WaDlOzl2EY7qnwdAh0vEKPKUDE=;
	b=gkmp9mpFubxrSl6uBljyoJ4M9tNWcwxQJczWFxovsWbxq+KqVVCYH2QaX195N1eL6jZGh8
	v74egZhu6h6NusfVyuUzTP6tiOIQS2CEUHp2RQNQtFg5uUSfNnYUi+351HIfmKUxEVdYrG
	+dXDS2FZ9uAD6zlifOwCpX7wvgQinMA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769392880; a=rsa-sha256;
	cv=pass;
	b=43pzH6bIYjQZCCNazy2Wd7tDhMGBvLYyktNOQGPHOGvLOrNUxf4X7jmdQrjadvZU/SVPOR
	Co/982obfpMbDVM9SacZMVfxDglpLYMTWugvD0JhdK4NQqToBty+G0cgGJYWIhFK6mfx8p
	kKNxmdphsZFBPvz6ZoDK/HZf9L343zw=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C7J7bCL1;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8947404b367so51555816d6.3
        for <linux-mm@kvack.org>; Sun, 25 Jan 2026 18:01:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769392879; cv=none;
        d=google.com; s=arc-20240605;
        b=L44qu1ES2s2pF+Pi3OzuJnO5dVdv597i5j9JEb7Fl5BytoIfx3AUm9LV6O2cW0rVg9
         WtDZTKDGtj61IFZpNId6wRoN3rgE5i42MRnKstpkgH7EjoqXTHAq5xnJlF9oXexpfVTF
         +XwMoF9UCMaFInb5oDWIwXOfmFHAriGZvcm2xcq1xjp6kpIA6AKirHK9Qf8KMyRWLubH
         y4GorbNjpR5J/dfnTTMrUUdB6yYbjHIonXgN/YoAxGCjz3u1jfi9l0vS7J7GK+SaggbZ
         aMQuWa2e2h+ry+RyQH+iygNlPgiuXVkXmqsSwdDmJSOA9R9adgdfUM3nFx/38mPn7Jcw
         jxXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NzhBh7ZDlZbLrgRg7WaDlOzl2EY7qnwdAh0vEKPKUDE=;
        fh=6o2gEmZwfB1/0nGKrN+TzUfVsLc7EdI4bSXFcdk3A7s=;
        b=hJsR06XwKbDZ/4H75kb7JqC6QmITy6snF1UvRkUn/DlX6Yl4Je6cHS0UMiO9czGhiQ
         v1MiTvhkNpfrFm8ZdumXTCcD1961ofvGRrTTLmf2XBCjuO5v95S0pIKta/CVXNU4DJG1
         kMXlYrENzn4kK9vK1OZIZkTIGrjOpSwQffsD3zEZ5Bj3oj4hHmm81M5D7Yy9p1JeHMZI
         gc+Im7529LQvqbQfNlYxXeoX+CIJKk96Xc/NAxM7LSzvUpS0HQ3kUIAj0C1RKvBjz+Zo
         6w8IOGYnTkF6XPt+kBsrtEV5RVzunFgWJ+mZgJNWJUNR5u3u5STQJreyOSTJlMCUUoSE
         MOkQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769392879; x=1769997679; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NzhBh7ZDlZbLrgRg7WaDlOzl2EY7qnwdAh0vEKPKUDE=;
        b=C7J7bCL10OJOtj9hbtjEDK1PUqZtp70MynYvCJPSbSlC7vVSJ79+3ddMGKYdQV+IC+
         8XBwL0CcPwcAyr6020oui63twbl1ySz6Z2tlVYzMkKwjtO/+Nt4yg52NDN+vp92ZvIjG
         +ADEcboeTgZOWutDcLkb/cwi0RtSoAorpWUET7swKgmHprag7CcimrtLA8X2NjKc2AO8
         Eiw3+HcUL1CP8bgY5nGH/0zMZZoQptaUSxE6962fgjXagO+pm3SvvEsuyCUJwgD4KWzX
         pO/t7YSWksLwjFWNTkYW00MD25QAxblKBWrAltz4nwI8lvf7CWUL8QGrJJaPvkSSBg7Y
         sK4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769392879; x=1769997679;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NzhBh7ZDlZbLrgRg7WaDlOzl2EY7qnwdAh0vEKPKUDE=;
        b=tbK5vrqeF+H5PZ5VguYo+iMsdxBgnDhB7mYDPHGeynFRY9EWSt2zNgV8Qbz10htol7
         /HPo2xMZnsn5u4/yRR6i2en/MKE1xbJclILbEEphW4vPgvf0EGz6/d0URpgVbUh9s+Wi
         gq1vB3IHW5bqAFITG92xV1ELGfX7QFuHNyH6PqWWQbmCCjw3L5h+BG0Rker/avlsNcKK
         d70ka8JRMSPRVcHA7zUUZRegVhexvWiOkja1Hwxg31V2M50aBuwlSxLpyYhU3tNU5Px9
         vwGDJWq+UA4wlXFXMnl+FoEmSxd+raNiuDV1fT7S8JqrxSyZlbyz9+4g6sJwKqMXmCBX
         Aq0Q==
X-Forwarded-Encrypted: i=1; AJvYcCV7lNvo0ta0ICcERNobpmk/Vz7JxvvXoToM4hCB1XcvGfTzeLFEavzdel5bDujrdXgbi/EacQF1qg==@kvack.org
X-Gm-Message-State: AOJu0YyBX6A8NxSg161h+tYyehSokbejfYUJuh2IqbfXFGmyGJbb/UcT
	xlz0fjS7ThzI7oN3qSKtMF+GYxMUW13lv1jOIpC7Hic4NDf03fmykb5RGrcfDDh8KIP+sqoUldr
	5l0rhPFYteVYZrZ/Xra3zQYXHqxwJEG8=
X-Gm-Gg: AZuq6aLOq22LEadPzA4RqpsLce+Bn6r1qXeZdZGGQ/NzPfSiYkrj/TKb9zejUHGteZL
	4dluGNzSpFqXqAqRbeRtgsQ04L2uyZv6kIk/76lnOnOPAJaoCIMPkT99zpUHf6zCycE2irYfm65
	21ME3MTlmdP8HoK2zJ2lH4O04jc8PUJXOagb0M8XmJnq6MXdbH/jbyWVPtVFjZ9XjkCZFqub1vp
	Ct60HY3sYZKNTuujOArkWRtMi41YBuZCpCqLW5rvw/hItwKa37a5ridCFmimD2k1PgtKWo7mwFs
	Vhlvoxq3Zk6I+XD/mJmOaes=
X-Received: by 2002:a05:6214:3014:b0:890:591c:c060 with SMTP id
 6a1803df08f44-894b07d4bbamr40946216d6.65.1769392879487; Sun, 25 Jan 2026
 18:01:19 -0800 (PST)
MIME-Version: 1.0
References: <CAC5umyib=XmPkTvRT6eAsMx+WDx0NkSP9djh4xkhLJgwk_v8Mw@mail.gmail.com>
 <20260122183453.2619156-1-joshua.hahnjy@gmail.com>
In-Reply-To: <20260122183453.2619156-1-joshua.hahnjy@gmail.com>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Mon, 26 Jan 2026 11:01:08 +0900
X-Gm-Features: AZwV_QhE-RsBWCuK8PtjAPXjepkNFdC63aiH-aGC-nNqBILX4g3XudoFOH7HJn0
Message-ID: <CAC5umygEq6xvpDFnVnDLYLyqJV7qChEsJ_+W-KCBJ+EXj1948g@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] mm/vmscan: don't demote if there is not enough
 free memory in the lower memory tier
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>, linux-cxl@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	hannes@cmpxchg.org, david@kernel.org, zhengqi.arch@bytedance.com, 
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, ziy@nvidia.com, 
	matthew.brost@intel.com, rakie.kim@sk.com, byungchul@sk.com, 
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	bingjiao@google.com, jonathan.cameron@huawei.com, 
	pratyush.brahma@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8A62140008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 1u43itmiyts17nfdk5kreifdrayezue7
X-HE-Tag: 1769392880-240194
X-HE-Meta: U2FsdGVkX1948xwMS8VeJPsVVvJyYkYzYBSJZCAkjH4BkggHM9OzkDnm7eJlw8MLUNN5C8epsClmU+I7vXJXcZWZNrXr94V5WY1Ow0vhNTKJnC+RwaPqPQxtvWvr+rEs+8i/cHyDFzFE6Pk/r4oTOySa/7B+99YJUF7GYfcp01eqNkpd78Z+2Aljd31HZ+jAYuDvOZ0Cw0clg/bthAEk/0o1Oxhu/01rJ7AIC7iDfQbRPcv3+v6VB5cQavi+a+R76hEjWNNGKsupMO0mITiYWjDO83dAshgbxrcVrmSZutu+KilrdWG6dxZ3/x005Lr+B+8s7kF+Rw1CHc7Znr8zxjv7vCukUl3ALQ4pE8f+UqZjQgAXz9ZqS9uaa9q71M8Xotq6zHh2BTal+afh8+aC53J5ntIv4hxFR4BipdzLaLmmI0pi3t1PKkE96W83b2MhJ9buEdJ115E4+uKKspErAt1QAU7eN2UN95Y1cKXaGkLfqCUPa53yc/dG0em0E0bQb5GqP4eTsBHV0E0qD5ZS0qdUaPzZvtvQI1ufwUrbRxtRUOKFTEq82/8v0hcPLdj9awVoBNdDIbaLrmNmNb3RioqFSptVp8O/cDphHF1EY5MA076EpMJskghcUJyh9TSto0CL62kMBFESvs1GiRjDp/dbitDjSAh0dyHCjGgrCEC1g4MMmwXBjn6wwiE5WzF5H9bXZ+1LJl3fi/wl+7Xs34Hlm4bbjwpKC9jmAT7TXcP2YCtrc+a8kxfhNHGPV7w/wEhwffHd5nUehd9cOfyZ5OJUuxw8IbCq/3xbc+Vhzdh8OiOoQxsjEnpCmJm+KVzWO4KV7C1UkF7F7Qi1fg2U6SneL4uhr3HzJ0JmRJ660qxRxrtde222b8CF8DbKFxbtKhyqzg8wbCY6kgElwR+3rV4y1oiD+uOzFzIqOl1VF81vKglAaXEFXTT+BHWxHyaJD93CrmeikcH3gv65rQ8
 VLbBpdKr
 iZWOEW2nm07gI3h41BdljQgkQSSFPb+APu/Qeb2GnK/GEnhyqUuLblp9UvkFNBeVIq6BAO2SYwZIvcWp0uwYr/zjCFdiQ/RGiuEHqY+m1jLikSboj2jJOJ0diT6c1pzfSvtTpmjAKIrOTU2U1c3mGpkF76iXa83yVnZrJQnhCN7okJHC757DykmM4RdUEHLFIMoQAZQXzIuJzn6kMmxGIw7dag7oBj2R+1ZvsbVZk0qfs/ITXUcgSI3HvWRswjMK10joOIhx3t+HSxFnOXTRelVF4mKHMEKQviUcLUML6l++dkgfUX788rdc0OLbt4aXqllUJZWs4RQRyJlou5o+ruf69EROX80imWyxI+ktZRpgKrsuvGwIfZRbXjd7Zk4TyNwzsPCWKNQmLk3sGI+5Oz+s6c0wWzEuBi212PMWH5Jm2WqeYWtZxkwyidczPiTxnmDcLHD6bxrPbmx96ngJgYhVAhbGZGfZqxy7tzEyHz0Ft6j4U8kWXtXWePcvkCZNXOdYLBdrKAA7WsWlg3Ip4lmCK7aZHj4wKcoOc059xzQyZQbXEA3gja8Joyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2026=E5=B9=B41=E6=9C=8823=E6=97=A5(=E9=87=91) 3:34 Joshua Hahn <joshua.hahn=
jy@gmail.com>:
>
> Hello Akinobu,
>
> I hope you are doing well! First of all, sorry for the late review on the
> series. I have a few questions about the problem itself, and how it is be=
ing
> triggered.
>
> > > > On systems with multiple memory-tiers consisting of DRAM and CXL me=
mory,
> > > > the OOM killer is not invoked properly.
> > > >
> > > > Here's the command to reproduce:
> > > >
> > > > $ sudo swapoff -a
> > > > $ stress-ng --oomable -v --memrate 20 --memrate-bytes 10G \
> > > >     --memrate-rd-mbs 1 --memrate-wr-mbs 1
> > > >
> > > > The memory usage is the number of workers specified with the --memr=
ate
> > > > option multiplied by the buffer size specified with the --memrate-b=
ytes
> > > > option, so please adjust it so that it exceeds the total size of th=
e
> > > > installed DRAM and CXL memory.
> > > >
> > > > If swap is disabled, you can usually expect the OOM killer to termi=
nate
> > > > the stress-ng process when memory usage approaches the installed me=
mory
> > > > size.
> > > >
> > > > However, if multiple memory-tiers exist (multiple
> > > > /sys/devices/virtual/memory_tiering/memory_tier<N> directories exis=
t) and
> > > > /sys/kernel/mm/numa/demotion_enabled is true, the OOM killer will n=
ot be
> > > > invoked and the system will become inoperable, regardless of whethe=
r MGLRU
> > > > is enabled or not.
> > > >
> > > > This issue can be reproduced using NUMA emulation even on systems w=
ith
> > > > only DRAM.  You can create two-fake memory-tiers by booting a singl=
e-node
> > > > system with "numa=3Dfake=3D2 numa_emulation.adistance=3D576,704" ke=
rnel
> > > > parameters.
>
> [...snip...]
>
> > can_demote() is called from four places.
> > I tried modifying the patch to change the behavior only when can_demote=
()
> > is called from shrink_folio_list(), but the problem was not fixed
> > (oom did not occur).
> >
> > Similarly, changing the behavior of can_demote() when called from
> > can_reclaim_anon_pages(), shrink_folio_list(), and can_age_anon_pages()=
,
> > but not when called from get_swappiness(), did not fix the problem eith=
er
> > (oom did not occur).
> >
> > Conversely, changing the behavior only when called from get_swappiness(=
),
> > but not changing the behavior of can_reclaim_anon_pages(),
> > shrink_folio_list(), and can_age_anon_pages(), fixed the problem
> > (oom did occur).
> >
> > Therefore, it appears that the behavior of get_swappiness() is importan=
t
> > in this issue.
>
> This is quite mysterious.
>
> Especially because get_swappiness() is an MGLRU exclusive function, I fin=
d
> it quite strange that the issue you mention above occurs regardless of wh=
ether
> MGLRU is enabled or disabled. With MGLRU disabled, did you see the same h=
angs
> as before? Were these hangs similarly fixed by modifying the callsite in
> get_swappiness?

Good point.
When MGLRU is disabled, changing only the behavior of can_demote()
called by get_swappiness() did not solve the problem.

Instead, the problem was avoided by changing only the behavior of
can_demote() called by can_reclaim_anon_page(), without changing the
behavior of can_demote() called from other places.

> On a separate note, I feel a bit uncomfortable for making this the defaul=
t
> setting, regardless of whether there is swap space or not. Just as it is
> easy to create a degenerate scenario where all memory is unreclaimable
> and the system starts going into (wasteful) reclaim on the lower tiers,
> it is equally easy to create a scenario where all memory is very easily
> reclaimable (say, clean pagecache) and we OOM without making any attempt =
to
> free up memory on the lower tiers.
>
> Reality is likely somewhere in between. And from my perspective, as long =
as
> we have some amount of easily reclaimable memory, I don't think immediate=
ly
> OOMing will be helpful for the system (and even if none of the memory is
> easily reclaimable, we should still try doing something before killing).
>
> > > > The reason for this issue is that memory allocations do not directl=
y
> > > > trigger the oom-killer, assuming that if the target node has an und=
erlying
> > > > memory tier, it can always be reclaimed by demotion.
>
> This patch enforces that the opposite of this assumption is true; that ev=
en
> if a target node has an underlying memory tier, it can never be reclaimed=
 by
> demotion.
>
> Certainly for systems with swap and some compression methods (z{ram, swap=
}),
> this new enforcement could be harmful to the system. What do you think?

Thank you for the detailed explanation.

I understand the concern regarding the current patch, which only
checks the free memory of the demotion target node.
I will explore a solution.

