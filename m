Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 956C3C624DB
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 12:49:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 553126B00AE; Thu,  3 Sep 2026 08:49:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5041C6B00AF; Thu,  3 Sep 2026 08:49:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A5D66B00B0; Thu,  3 Sep 2026 08:49:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C63D6B00AE
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:49:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8E15C1604B1
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:49:31 +0000 (UTC)
X-FDA: 85172432142.29.9046FFB
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id B0B90120006
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:49:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JrsTYyh3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788439769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UXj/TYVdXwaN/k93Aa7dPL0IcomTyKCbxd6CDyPSqJs=;
	b=SmDZaxUPqlL9WjQCkn9tUR4IgQ9QNKR32HGK0kJdfbDlwldDyifiMZdI+7gOh8FptavSi8
	oBpI5iUQkdR7SWKtiMmw3+Ih2XlACHn9TfEawoiZZX/MFvuvq43spsukH8sZfQAJzZsWFP
	GKpLc7X9UQN01nt5OA5opF3O0Z8rqAU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JrsTYyh3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788439769;
	b=Z1MgdybpjtO116iDm6aGpSxDe3l0GwkM+PHS7vqaWZsvAOlIZFX+SVfthcKlRC4fYimqz3
	jzAY7CZKR9OP/7Yyv93focTuC6am3GdymWxwhu/Tpav6Fgd54L4MbEUhPZ2iHL8nJWez4D
	bzeBsNUEJARrA3LAfmKb6FRAMXm7c/A=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cc439aa0078so1132931a12.0
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 05:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788439768; x=1789044568; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UXj/TYVdXwaN/k93Aa7dPL0IcomTyKCbxd6CDyPSqJs=;
        b=JrsTYyh3chR9fDP4l+oAQU4gs0VAQhgYxx4mmPO3RKJA52tYCy2yFQFJ1QVKSVSuQJ
         Mt7qjVRFpNrs9E8WHon/pJOCpGGTwryfrMpu7XlfTpaJTiv+KU/knpL5nKQ5mF0EWjDQ
         HbVoCI8q0Wct4ytGPv7fBcOovFDgG4fNADspD5ffXPGUhIfG24m1pBVkB/BoODRPor8v
         z1ZVqucNqG06iYB5r9YEgo9qa5pqGOdBkBu/Pk2phtDThoWRPIx7+uJKJA02gCiTpK8n
         tosP4BiCCj3/ZtRH8yY1MVnxSaGUh87wXPgBvWCTuTZxt9ZBLSL7lkxAAX9ZXjQ5CdyL
         UrBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788439768; x=1789044568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UXj/TYVdXwaN/k93Aa7dPL0IcomTyKCbxd6CDyPSqJs=;
        b=G9LUFN2dNOAH12w/FuwwJnRSYr0uLeOT7nvE7/+JyH5M/qvJRhGagkgotbWJzD+tS1
         02SCw/nYZOxrQPraMy9eprm7hcqg57nWag9w7YqypaNhHtJVQE6DFsFoJ+nYZ5QdnL3o
         5G8SCva17mJIHJ+inrrxcW1DuM+6LZLEvW2rFN1nLuYG/RHbdBFWgI2cSTwDGCWi+kbV
         FZ64mqWN7c5yBVZoCUXfBKU2Er3klzRRMsVkOwCT1WmGZ/eJomjxZrVLsu6fHfYgltWe
         ipNy6Eb3otWCcMujjshT5rM0QY1M7re6cRfrXXyTnbxt5jlHB13H6IOnTts7hMhT/tte
         jVTg==
X-Forwarded-Encrypted: i=1; AKwUvBwkOR+/YuM1jYWMgkYLqd24iWeEfMed+4fADPuoyATBBLOQ1rM4w422jqZslhkypI2DoK9HjPR0ig==@kvack.org
X-Gm-Message-State: AFuF++laIXCJH1jbLe+hRzMcVe9u+cj/Jf6/J6tPjz1ZHTiabgebcK8l
	eVP9wKN7rxGsyHFQJ4Y8sqdaJQK9pZnk8ktWNUOB+V87lHp8kUxm1dG+
X-Gm-Gg: AYBFou1YlvVTUlLDLxR45JGz3lgPKM3wKUppphopGShf7LbohJyzturCwEt9CDXNf2o
	Jn88t0JCNWMzh3uPgbjwSdtVa5XglT/oS1dBvl4OYuxk+VMAcpmLLa7oCSsnUCxAz0TY9T+0PWh
	x3fISjlQb4zbDrGZVXVMY+/Ht5J85+YPhfObeGpWAAkkC5OxoJGniQ4nDWGFbrZEO5HA5BGZMwn
	INPBgS8Atfsqeh6eEe7kTKcLR56VKcKl2H5cdL+dzkgXBqVcnm/DFLq5wKpH5B26Aqvzj1QqPLe
	wqeA18+av36UvQbLLcCYy64Eb6sdaToezU0ryrkKePVM4PPWOB/HL1QIWqHaMShdGAskwtJcTTj
	bnUsJyeuuoNJ2c9HeBcKb2ViF+DnwtjHwQ+Fn28TZaAxXVMUIRd4XJuffL6OZwewscVDgVifywq
	fisYFAsaLe1IYa2mwqgKWG38wts2lSzfhwjLGrvdAqAJb0DkE8Rt/uB/AFmvk8t05wiE8p9lMTh
	9KdfQ==
X-Received: by 2002:a17:90b:4b89:b0:398:c3ca:1ebc with SMTP id 98e67ed59e1d1-39aee105a46mr17130138a91.18.1788439768292;
        Thu, 03 Sep 2026 05:49:28 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08bcd243sm5431599a91.5.2026.09.03.05.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 05:49:27 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: baohua@kernel.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	david@kernel.org,
	mhocko@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm: vmscan: avoid anon scanning for GFP_NOIO with low swapcache
Date: Thu,  3 Sep 2026 20:49:15 +0800
Message-Id: <20260903124915.4099765-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAGsJ_4z+SgetmjVD8bcOFisKNd9CFqe6kNcYcFtVd-PijYJ04Q@mail.gmail.com>
References: <CAGsJ_4z+SgetmjVD8bcOFisKNd9CFqe6kNcYcFtVd-PijYJ04Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: krfkd1ctcycebmbrjscsf7pqamas4qhr
X-Rspamd-Queue-Id: B0B90120006
X-HE-Tag: 1788439769-276305
X-HE-Meta: U2FsdGVkX19+5aKP188iKM1McUEoHEKyxS5hic+8Nqu33fUOjj+L7Zlr/wpRkcobmPmDfwd/fzheXevLXwm01s5uUYKZsHbKwa5CITrKqf2McuMV6/7x9s/ZFm8rpkQ5JLuwY47OqCJMa6NWB2CzCKsvi+sN7wa5rw24GvrYAw/kz7kwD9wqChzQBlrVhyesm7mj2EX0zxOuaSXX34N1nwSznmI17bZc2FsjZEucCzZBEq9IKy+1tQP/Azl5ldw0r7+YE8D7JH5Rtr4dQ6CQoWu7aEh/d3qwm8aVLZ+dwAZcCM9Bj4unG8SlRf1AMq59eoeNOoAB2Ogj2sqPKqPwsu41bCxBavpA0BZf1wtHveN2BDEtUBdLohYoNiXuv+VpkznPKEhyr4gZhZiIDtS5kN68XvhbJLYFDEFL/RvXXRQffhZ/GZTRTvZ8qWjMNOYknHQltXpxOoQcMt4zgU/bylsb6advthZiswqLf5XJFD8rvLISZFfFmBymiy3NXGpvlnqg+Jfp4m1H14QNjHon+EGQgsxxooxFLgFe/h2OF2l/f8P0+BF9CQHPtRF6CdiKgLQkC4iElbamrnPJlP/pqwLJpNR1ALJCLmecjj1kxVemxmVF5QzjnhLp5kvutTVpZqbXIv3a8K69ml3pHiQaVvD0Au19Q+nVlIClScPLX/sLkAiccyBPVZF/FI0JTuQvWxn3iz7IBh1Nv21MTLoDSQjWuLpmrHKMklXnpIcNuyfhDhBUwmtsKuJqHCoQhio85KFRMjK/9H0EBYs7aLOkgPvxQkaYX6sp3jSDkhKiyG5kzOe5Rg601fUPxLayOGZvXmrdfUtuPjm6GIabouvAOvYFPtBx6+qOSx+QghuP693uYTmE8r1AxEsc9VUCGIIlZ37FH0VIMT6Limidea37Q7jhTjjcxE/QYmO2g2oQws2VheXxOccRbbXWHduPD1GAe1Oj07JOPEedQBJoR7M
 QXHHy9G4
 imX8191nzknFp9ooxkB8CIrSLcnfeIpJTo+Xsry9RikNNycmh4CCeJ94TI6AeamgnLggv2caGin7LC4aEK3o/Sh8M6z8C9VONwngFmYMZQa3QWHfCncsuDlE1plEBqITf60QrBxJwX8C/exTL+Vs/cmZFmPKfDgr/WXXUt2XBQIFrIp6MrZJmLySHcQh/DTLbLSFpznvvihOTAARuJYGBzhGT4n43n+ogjOn1K+9oxSqO7paeOhKbt2whd6v4VTMErcnSk9EJ6IKJ4mpFMWa2GARODv0oxDbXeTUBoqowH3pkZB/OupgiiEao4xxsiTcCV0Qg4CZsdQnyCxLqOqxtcH6gqjKtm1V3lmOsHeFSgg9gU7834FL1PzmcWJmUZ13mOPf0obKM10WD3VsknbeJ2vEXxZZA6DAOJQO0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 3, 2026 at 6:35 PM Barry Song <baohua@kernel.org> wrote:
>
> Yes. The coexistence of `GFP_NOIO` and anon rmap scanning seems
> nasty. We might also want to do something like the following, but
> the side effect is that it might keep a folio while preserving its
> PTE young state, indirectly making the folio semantically hotter.
> So this may not be a good option. Skipping anon scanning in the first
> place seems more sensible.
>
> +               /*
> +                * Don't waste time doing rmap and scanning PTE access for
> +                * non-reclaimable folios.
> +                */
> +               if (!do_demote_pass && folio_test_anon(folio) &&
> +                   folio_test_swapbacked(folio) &&
> +                   !folio_test_swapcache(folio)) {
> +                       if (!(sc->gfp_mask & __GFP_IO))
> +                               goto keep_locked;
> +                       if (folio_maybe_dma_pinned(folio))
> +                               goto keep_locked;
> +               }

Agreed. That matches my thinking: doing the rmap/PTE walk first and
then keeping the folio would leave its young state set and make it look
hotter, so skipping anon selection up front avoids that side effect.
I'll keep the check in can_reclaim_anon_pages().

> it seems we could just use mem_cgroup_lruvec() instead:
>
> -       struct lruvec *lruvec = get_lruvec(memcg, nid);
> +       struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
>
> I applied your patch on my PC with the above change. I didn't see any
> panic or run into any problems.

Thanks, and thanks to the sashiko bot for catching this. I've switched
to mem_cgroup_lruvec() in v2, which also lets me drop the get_lruvec()
move entirely. Thanks for testing it on your side.

I'll send v2 shortly.

Thanks,
Bo

