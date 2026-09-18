Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 336ABC982DC
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:55:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F065D6B008A; Fri, 18 Sep 2026 05:55:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDE336B008C; Fri, 18 Sep 2026 05:55:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF9C86B0092; Fri, 18 Sep 2026 05:55:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B82856B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:55:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0DB591605F2
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:55:39 +0000 (UTC)
X-FDA: 85226425998.10.7E58E72
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1668940007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:55:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZdSDUozK;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789725337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tM8T7Uyk81H/R6khmlHeL1LEwtikebuwV9hSCk4cYqc=;
	b=5PYuDYqEZSK0XKwDFmhVnIfMpZ4LKqWR7EFZWEUpJy5flc9QUd9CyMA1/gU0auzf9i1KQ8
	WxomoqFwXeVU8dYG0KkSDSk5GyylQGZBQIkDmI9Hpn7G3kIDlAfdqxEsuvtlmBysFpIbTf
	7z+KZaur4SG6AG5jQDjyXyLmoDHYCwo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789725337;
	b=WM5cAUl3I+3EzhWiOh+5KmPwg3B3F7NaIkEIdk3nr/JHGg4wtdBgOgj055qZzYbY3xun+u
	fgjJtm9dWKb6kaBybKW62DNOqFD3sbhlxdVn59SmGFnPzom4PvGgaH0LVyGavUOm/Y9u9G
	oBF/ihDyPoEKjnDpoqZbAdbmNH2P2CA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZdSDUozK;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1ED2F447B4
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:55:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B611F0089E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789725336;
	bh=tM8T7Uyk81H/R6khmlHeL1LEwtikebuwV9hSCk4cYqc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ZdSDUozKta+pPXlKlVhvq3dQiNghzLZ4+ZRdaXLuBBtLXqzAPSqBD5GRUG42DFO7O
	 D9AyiMSf1X84iCbeSnwhj0rXzeeN4LMOqouMt711EfrZcFu82/uADeIDyfCfxuy6jQ
	 XvBThQeUn6mh6pq9y09Ibr+wEp+qZc3pUajtGvL/cGMkCtLlTO/92pMyS2ZaH6w2Sh
	 46khP8NUtu77vcwCooUEtqaPqR/Zq28K51ARp8PAWuJ+NOI613jhR8cOCg0BK11vN0
	 N59cK/QrMikmx4VoB3/4qE1h6Ti2NcOINzGdSq0Qy40CZDZEu3voXw/5Jl5q0N85jy
	 Zq0hPRP9Yt0DA==
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93a222edc62so61372685a.0
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:55:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByBWulRqwlMqO55OrkWcNvDVh6qTmMuJvNvmPbgAcJFXFUEXXd48jRlLSrreETbny1JTXfYDzQGNQ==@kvack.org
X-Gm-Message-State: AFuF++nKzQPW6LqJ8WnmE6ANxPsIG7K2tqV6tXbBjfklWWjkUa8KXAjB
	dWlZ181UVtLLQXv4Fq0G3kEEl+J3+u5jVADaadeBKmq4Ol/Wss65hn/Y0cjeHqaXHz5gnMTWRhI
	BnUvVg71UA9VkRC5KS25D8ZMdLkJIDlk=
X-Received: by 2002:a05:620a:839b:b0:93b:d79b:9a5c with SMTP id
 af79cd13be357-93bdca885d1mr252021985a.61.1789725334936; Fri, 18 Sep 2026
 02:55:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260911121341.178028-1-alex@ghiti.fr> <20260911121341.178028-2-alex@ghiti.fr>
In-Reply-To: <20260911121341.178028-2-alex@ghiti.fr>
From: Barry Song <baohua@kernel.org>
Date: Fri, 18 Sep 2026 17:55:22 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w1FxNMTWiYDU86=bifr6mWZ=Rs0suUBGtN4qs_pU88Bg@mail.gmail.com>
X-Gm-Features: AcwNN1Wz8bI-Do0Pl_jSvJNgp8ItV3WUx6SNSfLqfj9e_G3JRN0VvgqtJzwJL84
Message-ID: <CAGsJ_4w1FxNMTWiYDU86=bifr6mWZ=Rs0suUBGtN4qs_pU88Bg@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] mm: swap: move LRU insertion out of the swap cache allocator
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kairui Song <ryncsn@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Wei Xu <weixugc@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
	Tal Zussman <tz2294@columbia.edu>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Usama Arif <usama.arif@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pfj15tft75nssbueoxd31gdqootayswm
X-Rspam-User: 
X-Rspamd-Queue-Id: 1668940007
X-Rspamd-Server: rspam03
X-HE-Tag: 1789725336-216107
X-HE-Meta: U2FsdGVkX19BHcj/H4MR2lJDb1RUssasa7uat4B/ePrkgwnhwNbjT9BEj2ax5ph/hrobNMJn78+vVcdKC6C+JBgBmcsAb/mPHUodUCwPKnGFyRroX3jsjNWr5IPwdCPl5kGAwwnMjiStLppD3NJpiZ066g4EysCbaI9eBLor7vXAzTxbB0caMZYPSHNnndreGTfhH+PEDenFd0yLEt0DettiXOo1l8RXVpAzcqEmdMbr7WqvjcYbvtlhlL/G0HhrLNyAp7w95AmOx+k2no3U9IHkJ3K0EXcXp1+AiXc0l0y+oSfPIFppYfczVEdCAklrJS3+pKfvgJpWlKrR1nTcDdWF3Me+bB9cVLhjYEPc0V6Vzt5qHxjIuCu2O2hap/eXn4wTdkdasNDO49gG9+gE31p8hWAKuGG3pq6013gShxoeXbufaSTZQlltb0nwDOcT12GakoA4+cLX1dhzryg59ZLrpdRkKDPcilt12uXs1t37pqB05WUiTI9GUi7d/mjHiF5lgH/gxR+Ixt8m/hk9B7R9wWA08wEXVbg1HmLPgZkVp0yHr7GgysoLcuPKo6OnqehM4HGGwQ4rQMZFhb/5xrrxBPCzIuwjf2u7bjpSkD/ECin+4ChkVmf4WNtZVYokgJZIgno0Xkivd9I4hI3oZyFnmnGiVjKcqNrZrb5UOWeZMSMt8vz5Udsxs/Q+VSR5zNgvHzT7V31mghb50S1IUbmtA2SC5fEeE8enSCBZ2x41dQPQbd8S9j/yPPUzdAgWHOqzQAtPjfHyIK/cTFXFQOhW9MUYlNfFqfFl+CXWusOHTe0//vzCcRZriiLpONXmwwKJ/S5njrOmR9U1iihk2i63bdwqQVgx21gxq/BVwCLR6gmR0050n7WYQR9ILHPoHVxvTQW+aHA8XJxH+pNXlhpnt++yOH7Lx5+xnQ+9KQWGPCO1YiurCU3ovdpHXAaW2hQtW+B9N1I56mHKwKR
 KAMrxrPf
 qFDKLqCRpjzR1AfTw5mwMeTllE5tyZWUe0lJjmkuumH0ZQGUlmfIMaDqzdf1OwU10jKHwcSq4gTBBActganfGhWE4cFAbSj8NyDFD2NgApkNXMg5lVjIxq/cfuLVe5Kpbnhc6shEBQq3Sy4sGnV+pWap6suikuXCLv5yHMjR3edxSxwVwL9e2naq1GvZkuW2rpwPVUHkFjOGY9NUIHZgJ2WLIqDJn3wLdbsmr2aNkby879DFp4rJOsh27eu6rRDePzTtNEB/9rMJKoJ3UVT9LEZEMYW03akI7zMWULbv+146o6U1zNuAegZw1nbhp/po1tiVGYcBB2yDELVunC4F7DWOpaHXmK1Gko3Tfvukr4VGjTS7PfdEGZaessLckqJwbovohVpKg7VWmy1ECqmNrdw0ugGAZIsYni0vV7V/6NJALdJyODLsIQXuUwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 8:15=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> This is a preparatory patch.
>
> __swap_cache_alloc_folio() adds the new folio to the LRU itself, which
> leaves its callers no way to act on the folio before it becomes visible
> to reclaim.  Two users need exactly that:
>
>  - moving the refault evaluation out of the swap cache folio allocation
>    requires it to happen before folio_add_lru(): that consumes PG_active
>    to file the folio on the inactive or the active list, and under MGLRU
>    it also reads PG_workingset to pick the generation.  Setting either
>    flag afterwards does not move the folio;
>
>  - zswap writeback dropbehind needs the buffer folio to stay off the LRU
>    entirely, as the per-CPU LRU batch would hold a reference on it and
>    keep remove_mapping() from freeing it once writeback completes.
>
> Defer the LRU insertion to the callers of __swap_cache_alloc_folio():
> each of them adds the folio right after the allocation, so there is no
> functional change intended.
>
> Suggested-by: Kairui Song <kasong@tencent.com>
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---

LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>

