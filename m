Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 230DD111227A
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 02:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E2A36B0088; Wed,  1 Apr 2026 22:56:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 394256B0089; Wed,  1 Apr 2026 22:56:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 282556B008A; Wed,  1 Apr 2026 22:56:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 158736B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 22:56:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C49AFB874A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:56:18 +0000 (UTC)
X-FDA: 84612102036.11.44FD02A
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf03.hostedemail.com (Postfix) with ESMTP id E663D20008
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:56:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=biecQxEi;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775098577; a=rsa-sha256;
	cv=none;
	b=Iwfo6zCqNvYIJv8qXkNqnNqXlLE3PS+Cvyl9XlRd2FMQI7K1KYyPHO3DBLwJ6lr7umIZaR
	hmyWyIWClIh8IepxW0VIoJF0UAxWXmJKsuKoINvKsa09HZOhYP+1SG3WMApp+/XHB8ee7H
	omTeimHDgL3XA0qiJZRe2BqtwvCz5Q0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775098577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YxJh7vY7ymqstvenqv7CWmrOnBh2MKIFs8pONvqJB0Q=;
	b=yv5+mCA3muc9aD8xEY1LKu+YO9sf+aFrtZ331h4rKMiVG6a9RXTWPN99I1R6GLumOpmAXe
	mKRCZaY2YeyMHmoq3U2mPcTe8vZUym0eTbII4+GLccnM7Rty9oC/GmYU4OyDtK0TW0kEgf
	kHdovqvVROWr9ScBtO0/J+g6GlG89z4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=biecQxEi;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ab46931cf1so10692355ad.0
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 19:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775098576; x=1775703376; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YxJh7vY7ymqstvenqv7CWmrOnBh2MKIFs8pONvqJB0Q=;
        b=biecQxEi5kmIDADitXDK58ak1kvXIb3uumTznadqzHy881eRpE31L/HXTCz5djbjSU
         ZledT0RSXn26SerB3MKq2QdhI7B4gevdRIWcsI/F3g6sZMb3OD/ldMxrUdwAIZZuyTe1
         mkEN4hyx7k1aVcgcz4VbY9Jdm5L4BP9VL7mYj+dSsrLTeOWQd/+Jl4AosC30TC792CMz
         7l9GUY0CMVZ5RvFT4ioroHKT/8qdR50Lt/qSzLOgj14cmXAalAqNRJMvl7JCTcvrSdaQ
         diXDjFDVX1iPM0l2QeOzBqr3RRDyRufnGuwyQDpOg4aL7dX7Ox2d79gcMb3QTS78u1Bv
         gF2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775098576; x=1775703376;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YxJh7vY7ymqstvenqv7CWmrOnBh2MKIFs8pONvqJB0Q=;
        b=cF6VK2nf+Gw4V83jZBj9Z/lJIFbAr/9xNSNgpVrAVYtZJG3NHKTQd2LNI3rJu+RXWx
         3pGbaCuNxtoN2luQzXxJvoBbYCitKjyR90YY4cf18DRgBj4JDey0I0Hj/a8D/fxhC6mu
         3re/bskcp+Niy1wuA25IyQIxUAiIs93KPPvUuCbC/3G3VBMVyS8fkLPpEbAfO0xMwKwZ
         De9VaovDqilGJjKcEawzw630pb0JdRhQ910IWIrlH66C80qjYckT/L+ndRfTkFDi2N0m
         aJJtoCYvuvWlxRl6C03xBmkSzzv1CMT92g7PbmJwmeBzqSVztOAXjTiKniOdP4X5m3QU
         R/8Q==
X-Forwarded-Encrypted: i=1; AJvYcCV/7GI0yW1QCBGzRrLvndEVDxV+EkiuSUfVMj9iL0LKA46S7xF772gEVgt9woTKUeoof79/WmaC2A==@kvack.org
X-Gm-Message-State: AOJu0Yz9jvZag7h4AToJVGoO7b1oF7K5RPr8CcC2KYJ5joRVKqeA3G+H
	H2hHkaXCFgM32m3hmLiOeVwZIeMhpRNxIl7EzzaXjNnTF9yx2bW3stQX
X-Gm-Gg: ATEYQzydNuHNa9tL6P0Log/j4dFAg2s0sv75JjTSKBW1TADHI1d8tow86xSe4sPqI9A
	MTNaNlzMi2IKk1v/DF7s3RAQoC8x+4prmT3J5lOaSmi1o3eiIsc0PEUa05GymzbewhMBZUqHdN9
	6ewJavYeDEBn9FD5Fv3VCQd8ULQ0zBId91nIoBBMzmjsdtXs8IroXi1LMwSOp4ALBPmNzvqb7m3
	yECdCl0Uc/cuhQ/M+snig7YvbHO1w3ResRDALTRMg23PB44gKLlZGw6L5VOqrXfve33YehMaYwR
	GG+BajuuAivW+YwgmOJtwWgwxdlL52isyD+1N5cs70jRzh+FQP9bSNQGUUyu/d1tKlV3oB7htpv
	+aAY1npUwS31XdkB8up5UVv8zd//2axVCLSLkFBtkIMoLxiXZ0UHV7Se1MI4BxxB1mj8Z1TuA5S
	bdEPGrITvUhiUpAOFPAEQJHcditF+I+RYlRpgDi5KZXocALwnpHi9uRzP3ZmE//gpGcXa9
X-Received: by 2002:a17:902:e84d:b0:2b0:5a4c:726f with SMTP id d9443c01a7336-2b277e3745cmr7657965ad.15.1775098575594;
        Wed, 01 Apr 2026 19:56:15 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27478b84esm10880025ad.32.2026.04.01.19.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 19:56:15 -0700 (PDT)
Date: Thu, 2 Apr 2026 10:56:07 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: Re: [PATCH v2 12/12] mm/vmscan: unify writeback reclaim statistic
 and throttling
Message-ID: <ac3YKAh1Kzmpwhi0@KASONG-MC4>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
 <20260329-mglru-reclaim-v2-12-b53a3678513c@tencent.com>
 <ac3VV7h1fuDuUOJA@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3VV7h1fuDuUOJA@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E663D20008
X-Stat-Signature: 7eufh1n9az4htb9idcpr3c3wieh3ey1m
X-HE-Tag: 1775098576-180193
X-HE-Meta: U2FsdGVkX199n7iNt2AxOBfgXJzb2lak0BwSYZaYcS1ISGbLOicF09/liBKV1gtiTGk8/bj2HraMILqI9rKqJZi4A7hqQkpiVKLwFbZhbV2yEK5itBuD793mq5Ng2/ORvmJykIfahX2gwd4urrroH7k2GS7GGcxj0yXzTIgtSD0L0unHHWpp8SEw/zhqIMKQ5WcO5xOn13Oi49oAm5gjW5TD4JQ4mr8VwHVtp8bLYMf7jst/59aQWMjogQzBXETo0wL5CGxRO76CRsJ8/Vy0fIBUdjku5SYIgPx/rfXKGKgZdMHRnhvFH+FmNGXEo0fCO2m3uWlH/C646fU2ZJb88bFZI5plBCIqSQQLHpcnfn38roBeAXFjhs7z50PbglS++B0iD0ZMH26XGzHtcy1fY1CMHQJEUBVkJKphBaoG6YLO9nA5dAlpBRwPHE7ZdJa+VunNGBbw4itl8M1eMd7n/BJ9nx0rcZ/SYPPOpDdB7X6b7ESF6JIA9euQwhdFUZcBfI0HwIWm4OKvixNWzaOiSvpTXGI6IhOHTzKgGTuhM3075aOSah1MA+caLiIAiCpOiFa15Tm033bewTzcLrJZPhP1qXUphSO93u96jQWPURu1U2txPG4Ag15vnnxHTK9vnQJwV7CVUrqVgEUzqQkbLsjZrFtIez/G/PTgt4x2p8YE5mf8PoYgZaBR4O25itmELRh8kesJ9u9zP9URjJpYYEIMpZX317Rb3X4c2oryOw2qlQPA+6ZbaeLf00hnyIVP4/OTJUZD1b2I71jvLCVfJQRS3rDEAXFtGitvx4JpAh4ELkZcGdeOJ96mUvJynvLjB8UlUzT723tmj6FJAQJ6E9XKhZ9MZtKcsFm3ihDoD+0c+hBExjqPgGCNmuxc8rINPmZ5tEJBenVKWiSAMzk3BIWzQVdEuDxieGE/5wuCKVioucaDPsYayzHXHIIav0MRY99VTjDcmA3X7bAbtSk
 O44dmrNu
 Z6VosL5Dpp4VPpvmxOSv3kxgROzSX6FgFZTocA/ADQRp1lUw4rdbABKdx6kbQbb4NbNSnkGsVMcgwgFBnZuKelIkZGcMQZglnMBW7ERdWWjle8bLT8JM7d3GXE4w0LLCYrAUtRnvIWN2+bqh+kNau3ffgoasoD30M6DL8tCdTlcjf1hSHXigjw+71foBdsZ8MKbsdUntr0lpNcgWKenyEG0QJhkcv8Yi8Y6rMjisEoaq4+UQEcELOKzFDZLOgveUAdy9j74DzPSi8pJdKiTohkO37cgI5gJosp8bWPVgM8SFSWiYc13XmR5u19tm/O2g2KqksMcPTkHixDVSUMeCr7FAttVzd28psy9g8CIRudxIVDuyfwRVnUCu6VVTLeF75uEGDD39fNemmXV+mPajV1yDxdb/ltE7HwVyxkiSL4TKjDUqKlAGXGeL7d1tmEbWF8v6RDIMbnvpA82psYq39Tq4rKUjFCALH2b5Rb29KektlKOixoBQWjijROditm88wRWJ34bgnwgqdc+omqlhbDMxy/FRRWSi7Pfw64PF6AQXCBgQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 07:39:03PM +0800, Shakeel Butt wrote:
> On Sun, Mar 29, 2026 at 03:52:38AM +0800, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> > 
> > Currently MGLRU and non-MGLRU handle the reclaim statistic and
> > writeback handling very differently, especially throttling.
> > Basically MGLRU just ignored the throttling part.
> > 
> > Let's just unify this part, use a helper to deduplicate the code
> > so both setups will share the same behavior. Also remove the
> > folio_clear_reclaim in isolate_folio which was actively invalidating
> > the congestion control. PG_reclaim is now handled by shrink_folio_list,
> > keeping it in isolate_folio is not helpful.
> > 
> > Test using following reproducer using bash:
> > 
> >   echo "Setup a slow device using dm delay"
> >   dd if=/dev/zero of=/var/tmp/backing bs=1M count=2048
> >   LOOP=$(losetup --show -f /var/tmp/backing)
> >   mkfs.ext4 -q $LOOP
> >   echo "0 $(blockdev --getsz $LOOP) delay $LOOP 0 0 $LOOP 0 1000" | \
> >       dmsetup create slow_dev
> >   mkdir -p /mnt/slow && mount /dev/mapper/slow_dev /mnt/slow
> > 
> >   echo "Start writeback pressure"
> >   sync && echo 3 > /proc/sys/vm/drop_caches
> >   mkdir /sys/fs/cgroup/test_wb
> >   echo 128M > /sys/fs/cgroup/test_wb/memory.max
> >   (echo $BASHPID > /sys/fs/cgroup/test_wb/cgroup.procs && \
> >       dd if=/dev/zero of=/mnt/slow/testfile bs=1M count=192)
> > 
> >   echo "Clean up"
> >   echo "0 $(blockdev --getsz $LOOP) error" | dmsetup load slow_dev
> >   dmsetup resume slow_dev
> >   umount -l /mnt/slow && sync
> >   dmsetup remove slow_dev
> > 
> > Before this commit, `dd` will get OOM killed immediately if
> > MGLRU is enabled. Classic LRU is fine.
> > 
> > After this commit, congestion control is now effective and no more
> 
> What do you mean by congestion control here?

This particular case demostrated here is VMSCAN_THROTTLE_CONGESTED so
I described it as "congestion control", may I'll just say throttling to
avoid confusion, it's not limited to that.

> 
> > spin on LRU or premature OOM.
> > 
> > Stress test on other workloads also looking good.
> > 
> > Suggested-by: Chen Ridong <chenridong@huaweicloud.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> 
> There is still differences for global and kswapd reclaim in the shrink_node()
> like kswapd throttling and congestion state management and throttling. Any plan
> to unify them?

Of course. Let fix it step by step, this series is pretty long already.
I originally plan to put this patch in a later series, but as Ridong
pointed out leaving these counter updated but unused looks really
ugly. And this fix is clean and easily to understand I think.

