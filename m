Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B933606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 01:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FoPYA2G+
Received: by kanga.kvack.org (Postfix)
	id 009D46B05B0; Sun, 22 Nov 2026 20:53:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFCFC6B05B2; Sun, 22 Nov 2026 20:53:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E161D6B05B3; Sun, 22 Nov 2026 20:53:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B87686B05B0
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:53:37 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 43CB3160776
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:53:37 +0000 (UTC)
X-FDA: 85464712074.09.70FF2FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4B817160002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:53:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FoPYA2G+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795398815;
	b=xaowoi6vEeboS1KIpttL3ZiOdPQ+KswZTkCjpiNMXNo5Paa6EdEiMuTmm7f3Ops6h5VFvU
	Emzb2B5uFcC4oyEFd8IdoiMAy130eqFoG7rg5hKVaHeCwrYS4hMxggMh22XnJBjSARRuCQ
	IfrFaevY+QxAoiJn82XbLJLNkfDrU+4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795398815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sPv41HsofzT9QRCIlHB+B+IXmly/SiBKVbRaSebsetU=;
	b=4JQ0uH3MluzqaMkjO1ddBqPl1AIvIVmn8lHOoVhchp0/c/+5gq6807msWd2GNpB/pRi24s
	gA5saBM3yCkdff2YWiKtQA9KDUp1Zuxby0xD0JmjPq6RjLYV3avCY3lwiCOaT9sTe6ru0g
	xJ8mwgpF3fGqybHvHXIg5mV9wp6D5b8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FoPYA2G+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 88C7544F50
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0151F000EF
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795398814;
	bh=sPv41HsofzT9QRCIlHB+B+IXmly/SiBKVbRaSebsetU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FoPYA2G+J+zjXF9qLqIyuvD8xy0Su3rqhmySBnSdTR8Ne3tlX8n+AFiI44Qih0rbp
	 enBI41GL9ezrXnzGOiOWSjFgm1XUwjzlqgi12Z8Z+Ae1st55Qr++vdnyh01TaE4jAW
	 Cx1h0mie6siLYbJTaJPya6Kss7+XJZQUXVEBgEh04GQBpjXWgjBdZRssK5nYL0J4zh
	 ZKIRBcyj2iShj8v9STSc4nrzWJZSKQlQhFIg4wNmHGxDl+jNe/F3+u4DhopnlVgXNj
	 4Kxjy+drvdEis87Bn8WaGmlVpe6Tkdk6XJuHgPPjRDawC2mHOjRt+UJoS1Zauyui6j
	 1SuONatwyRUgg==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-9495d543c42so296647085a.3
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:53:34 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEhvFuHrb2iI5tOh5NzKRRyrmlDCdqXMOcXAtlZlNdAGiRvmsTzgrcNXVuPEyEwD4ZQzYTMKB0i4g==@kvack.org
X-Gm-Message-State: APuU4Z82j14LCiSSCin4Rlh5O64RtXjpu9pBpO4DWWEbHBsYkWH/xpKy
	x1t1zHX5pqmQXrB3exTbaIbUunX9+jV74QmVuWYhPx4KdgTFbBx/YGwGY5aNM1b6CGawRr0H1dl
	e4wUbhP9Vk/l9wGN2NT/m7yQ5ehLTkrU=
X-Received: by 2002:a05:620a:130f:b0:949:7b40:5678 with SMTP id
 af79cd13be357-949ba9e19a8mr1736245285a.53.1795398813620; Sun, 22 Nov 2026
 17:53:33 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116081403.216452-1-max.kellermann@ionos.com> <20261116081403.216452-4-max.kellermann@ionos.com>
In-Reply-To: <20261116081403.216452-4-max.kellermann@ionos.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 23 Nov 2026 09:53:21 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yZznwxOZmfeB2SpgT1enRbQMyKnN4QjEFdoN-PJi7mkg@mail.gmail.com>
X-Gm-Features: Aa3M54qK4wPWc_XdvESaK_X96UC5ef31iB9G90RGWdgsH-87Oq5vyoTtWFtdPXs
Message-ID: <CAGsJ_4yZznwxOZmfeB2SpgT1enRbQMyKnN4QjEFdoN-PJi7mkg@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] mm/mglru: cache the last memcg node, make tail
 insertion constant time
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ze93q5j33onss7gqbc3bb91gmfqafxb1
X-Rspamd-Queue-Id: 4B817160002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795398815-666251
X-HE-Meta: U2FsdGVkX18OqPx6GPZwAtwaKJc7tAHq97sL9aBXXzDKGwI31D6hh/r8lgTvBomN8n3SxjoCN4WGrWu805b0zhNnlNw+nXB/N/G5Yd5LAvnAdB/NU71A94dCh4jJM9O4zLgE68oYW849S5C8Mol5F9DXBWN5iHBLczucpwBkcilkheADf/AbDGf2iL7YyMKGh7CWPm94LB5g1I9ojydSJUl+WKFNneToDPgVFtq4+Dd7OaYxUQ3yssScgwLwZ37RjVXlPHYf3Rh63IgxvqA1OF/5qh3EmOgtOR8D0cYshLigBYxySao7nEHKmpZcfKZiwJJosNY37AoPMcpHbaPhfC2e9gQgKqIs0K07AHIBBXg1lWqVIT+1W8XLb5SO/+nKkssCvjpOpdxwCGSIJydUvYpTFNSL+R8t+n0kwAT1Cj0Y+ZD2t31SnjJsDU0dep4flITJhjSJisC7m0Z7VnrbbPqVUVB7BpLt9AlSZ1AIkeEhOwVaNCYoJj0XYcv9llrDan/5uFNuOC70pNs8aBeoKojGU+f4hiPU0Xeutv+GvsoIiUH2TQhpAHSWcOs+fD1csTHf6517w7TFsm/uf/W81cz4BYFdJ+7w2WYC8DULwyVXuKu/wfO96VOKMrOt4BHP2rU0m3gUfBpbC7umjJREWb2Y+8NzWZp08w5cEN5Kge1Pm7LQBEHR/DWozO6gzM+YoYmwm/Hb5/N+OBGX6ZWN6twTJHMiL1sWhEK+BLLyvPme2aGcOcZp5CypXKXEEkYz3aCJzn7SBaq07ZLxPg8loHRFhC56Mg10MUOdoTKvenjc6xsxZyazekAZmx9rELPkLYW7bamhozWdLTstrMZjtkclTjEU8W6Ju/kcw6w1v9yFACcK8VIZ6CKwgn5vvlMTw+h/eauaWy66zMAEbt4Jz16jYk4lnO43ETbe7atf+OLrBvsWfHDBFzfCQLQD939GW1LXX+KAcWe1unyFKZg
 nHv90dRS
 5Pf/9LLljfRsVHaVNCUliRyVrgTU8sUpQMomILUG3i1hB+O3PpMbU4Yn8WGbncMvGawF+LghwozTzWDUhehWS0ajKB3t3TpSS1aCJXJ+cJxtwEDsP8mkD3CoFGsvFH1N6tBXt6yOhfNZDRFi4R5ur2QmFHVly9DrJDfm4lMv7nQkIkqbEY9D1ZpQlIXVtR82T49El6RNg00U1P9MRKoM6QdZuiJ5zv6ZeeJhf68f+DUL31Os3bc/AWd7hFjWnQkdeQmj0TkJ212egzS2/f98ipbECkTWro1p8JrfUxtQ1C6rE2hXQKTIBjK6sb6k/8ZGJ25oLWdGtJmJ5gapD3tjLwsLysoA/12a73VG688elpI/h6cBH+L71m+GTShzHC9IY4lRnbJiThUgYxjgp3u4ovDmsprE8hrR+WLpn92tNj9rmC5NympBquxDxAUOstB6poGABKRWcEawlD+JkdXpXzrmAbhSFV76/d46x3TTUmxWvY8GBeGuYgqrTAR5bpRtsMPuZGtPTjFGs7TUGuR3Nfhsmd6EyFm0f8eLsiJ6g+jvbJYM4RY30cPptxONBwGqXZTs+RwAnTiLjIkmCOQGqlHjexw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 4:14=E2=80=AFPM Max Kellermann <max.kellermann@iono=
s.com> wrote:
>
> Rotating or onlining a memcg currently uses hlist_nulls_add_tail_rcu()
> which walks the destination bin to find its tail while holding
> `memcg_lru.lock` with interrupts disabled.  With thousands of cgroups,
> this takes a long time and causes severe lock contention.
>
> Cache a pointer to each bin's last node, making tail insertion O(1).
> This requires remembering the bin number (but the new struct field
> occupies a hole, so it does not grow).
>
> In a micro benchmark that creates 1500 cgroups and repeatedly writes
> `1024M swappiness=3D0` to `memory.reclaim` in 8 threads, the request
> rate increases by a factor of 9.5 and the average duration of each
> write request is reduced by 89%.
>
> All writes return EAGAIN in both runs; the benchmark measures the cost
> of reclaim attempts that cannot meet their requested target, not
> reclaimed throughput.
>
> Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---
>  include/linux/mmzone.h |  4 ++++
>  mm/vmscan.c            | 24 ++++++++++++++++++++++--
>  2 files changed, 26 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index c161d563ce8f..8382fc86cf0d 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -570,6 +570,8 @@ struct lru_gen_folio {
>         u8 gen;
>         /* the list segment this lru_gen_folio belongs to */
>         u8 seg;
> +       /* the memcg bin, protected by memcg_lru.lock */
> +       u8 bin;
>         /* per-node lru_gen_folio list for global reclaim */
>         struct hlist_nulls_node list;
>  };
> @@ -661,6 +663,8 @@ struct lru_gen_memcg {
>         unsigned long nr_memcgs[MEMCG_NR_GENS];
>         /* per-node lru_gen_folio list for global reclaim */
>         struct hlist_nulls_head fifo[MEMCG_NR_GENS][MEMCG_NR_BINS];
> +       /* last entry in each bin, or NULL if empty */
> +       struct hlist_nulls_node *tail[MEMCG_NR_GENS][MEMCG_NR_BINS];
>         /* protects the above */
>         spinlock_t lock;
>  };
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 49ef29a86553..7cfaeca9a605 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4434,18 +4434,36 @@ static void lru_gen_add_memcg(struct lru_gen_memc=
g *memcg_lru,
>                               int gen, int bin)
>  {
>         struct hlist_nulls_head *head =3D &memcg_lru->fifo[gen][bin];
> +       struct hlist_nulls_node *last =3D memcg_lru->tail[gen][bin];
>
>         lockdep_assert_held(&memcg_lru->lock);
>
> -       hlist_nulls_add_tail_rcu(&lrugen->list, head);
> +       lrugen->bin =3D bin;
> +
> +       if (!last)
> +               hlist_nulls_add_head_rcu(&lrugen->list, head);

So this is the case where the list is empty, right? Maybe add a
WARN_ON_ONCE() check before this code to make the assumption explicit
and catch potential violations in the future.

VM_WARN_ON_ONCE(!last !=3D hlist_nulls_empty(head));


The patch itself looks correct to me.

Reviewed-by: Barry Song <baohua@kernel.org>

> +       else
> +               hlist_nulls_add_behind_last_rcu(&lrugen->list, last);
> +
> +       memcg_lru->tail[gen][bin] =3D &lrugen->list;
>  }

Thanks,
Barry

