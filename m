Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3C6BCD6E55
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 02:38:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1075D6B04B9; Mon,  1 Jun 2026 22:38:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 094BB6B04BD; Mon,  1 Jun 2026 22:38:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC2656B04BF; Mon,  1 Jun 2026 22:38:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D7E2A6B04B9
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 22:38:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6EA081407C9
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 02:38:13 +0000 (UTC)
X-FDA: 84833413266.10.E305EC0
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id 95347140009
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 02:38:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JGiAuZIQ;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780367891;
	b=P3I1Mgueq7/53yglM7buVILGJEu0kf1K5IUCqpE1rRkp0fx25ZqTLvTPysFN6yskiVQaN3
	9b2QnCSzo8T9brfBH2pfqb/gXeH/FEPF4ujKaVR7xHIBv6sX5GIFJFLcbejGFIA4dixRIF
	sN1E6f9hfSmPb8gaVG7rwY6VX2hOEIQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JGiAuZIQ;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780367891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dKmVnwBQTYER22XxHtKgTEyxPcm6+PF1gPWG/CQnepo=;
	b=JTpekJ0wpahopuWHrA55kaQ0P1vYyeVTpXcHPvQtdR8ssmzG2REVfS/qgqfsA28BKCnaEO
	oP6D6j3cLAMCETJlKCnWXJEbi3VQzdT0euveObukylzKfQ6BmFJ+63CgalAlP9w0fI1s0C
	QegxS8tlhS0UT7/kNLhcPAh8NU25Ni0=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780367888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dKmVnwBQTYER22XxHtKgTEyxPcm6+PF1gPWG/CQnepo=;
	b=JGiAuZIQLye/+Tr5WQmbONLcGtvIIS11nHqAEbCgq1kKsxaQCmxnVcxjqgt2N4pMDxeD/+
	mD0m9ZFj7qpHL0VeyNUB9MpN+KanG/aD2i184DUr7pRbGdpJzUoZjyHpNvxzqab7wstkbL
	s+8siCc82RccvASUNGd1HBOD+46UPcQ=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v2] mm/list_lru: drain before clearing xarray entry on
 reparent
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260601161501.1444829-1-shakeel.butt@linux.dev>
Date: Tue, 2 Jun 2026 10:37:25 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Dave Chinner <david@fromorbit.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>,
 Kairui Song <kasong@tencent.com>,
 Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Chris Mason <clm@fb.com>,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <8CD76642-E809-4E81-9F12-DB110A9F958D@linux.dev>
References: <20260601161501.1444829-1-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 95347140009
X-Stat-Signature: go1o8mjrgg6n97ky7d68hnob7m6j9qfh
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780367891-330061
X-HE-Meta: U2FsdGVkX1/Xkks5zpSBhM1XJSTdvrgcCzYeNpW+WB+jNf6DqEZ8bbX9RFo+yrubQpjIPmySoVDIR4lFUlL9JgXQ+QSiEwq7xBf3gNafP2o1r8cSUKkh1f6DES1KKBSnafRET7xIE1b5jIBz9mXOW9KAbQ5PEGwg8TbPt7CPfY+7y9GOYsqt4kpUrv6koooqv1PjdXNACrJljTzAYvajUy1eJA1xS2qSfbw0XCXw1oJa9TVWoqYk9SUo5OOKpJQ8XzXhtfYaXKcwjPH4sp0LFMh0WCqChW2Mcrwx36l/eYMYrn5oCzvOOHwh+64s7TJfSEELR/6cozPLwaYxb+shXNXvbYpQy1bCaIHVuKj/AT8dnM3eQaj90o0r85g8Y9wO3NggBxa9jnOejZDCq0p/MXt6NNcsEdL7n5pGcUZAA3VAtLPy2y/4JHge60I6P8N+7VQh/h6oWCzay7BGivlKik1ih7MSXYBi9TKKas1Ocs0eaI2hOOjq3biCz1Gf3ahIq7qcBYnPt/q2TUymn2CZre9PpjRU8QzJa5WwCLwfc/2sbF6doJFB7uqP7H/H3TVsIAOyFzNaEDXev4BvS6FGxNpJ0aKnbN2aXSJ89KjkMvJ06APuHgLdZuNMFPw/TqTpIUkL2TfffiJXjvz7Hi9l3++1kegYbq9YEi+gb4QO1Za+KQNPv2lL/NIpe+8ilzg7Acq1hhswqirdE6xhYp8CnVZ1d0sd9luiM20zAmMnnHgiTPE6xAsGX90hI4HzNCOxN+Bpx9YQZOHmsJfI9ZXUQvvHHo6U9uPWgTm2/efIYgnRj0gBzNjtZzwuzP5kAlhnKubzhDEmPTQw9AvKReWYEhhdZd8Beult6+Fvq68yIIgQZzShW4WyhacQbLmVGYzmHsNUIpG/mfRUOE8+ImOAziIWZ72NAucxz7JDySpaKQK3xY2iPjjPAqqPGdLlny2ucrOnPTQMX2ZlH5KCZYf
 Pn0WJVsW
 DKbL2HVg5XCOfRsmHF3Ki404fu4ku4NNJMR7s+L+pn8Zalnr9BlJL+SkdVp/UH6fCCmnFqm5PPTZozZK1aO7zvTR9MhJLwRu0aID9J5S0VNaK6O9YvlFgq1IuGmu677WvhH/QjmZduGphqAVSo/ToZxtOgVL+x6LmuA34045DYSkqBGxWsURCzMajreGTXz1vetuIVYzNcGcDwCXfq4sRyCkDMZXsUy3DCVrwNM6MPj6qkw0+i6Orb6P7qrMEYVVRosD/NYs6kP4vVSa64+0G5b3qQ3t3Xdg0Nn8Wd0ItWE5/RzpK9FxL0Mr73BfTIBFHWuRkum+oXjEYLD8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jun 2, 2026, at 00:15, Shakeel Butt <shakeel.butt@linux.dev> wrote:
>=20
> memcg_reparent_list_lrus() clears the dying memcg's xarray entry with
> xas_store(&xas, NULL) before reparenting its per-node lists into the
> parent. This opens a window where a concurrent list_lru_del() arriving
> for the dying memcg sees xa_load() =3D=3D NULL, walks to the parent in
> lock_list_lru_of_memcg(), takes the parent's per-node lock, and calls
> list_del_init() on an item still physically linked on the dying
> memcg's list.
>=20
> If another in-flight thread holds the dying memcg's per-node lock at
> the same moment (another list_lru_del, or a list_lru_walk_one running
> an isolate callback), both threads modify ->next/->prev pointers on =
the
> same physical list under different locks. Adjacent items can corrupt
> each other's links.
>=20
> Fix it by reversing the order: reparent each per-node list and mark =
the
> child's list lru dead and then clear the xarray entry. Any concurrent
> list_lru op that finds the still-set xarray entry either takes the =
dying
> memcg's per-node lock (synchronizing with the drain) or sees LONG_MIN
> and walks to the parent, where the items now live.
>=20
> Fixes: fb56fdf8b9a2 ("mm/list_lru: split the lock to per-cgroup =
scope")
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reported-by: Chris Mason <clm@fb.com>
> Cc: stable@vger.kernel.org
> ---
> Changes since v1:
> - Use xa_erase_irq() instead of xa_erase() (Sashiko & Claude).
> - Added comment on CSS_DYING check in memcg_list_lru_alloc avoiding a =
new mlru
>  allocation.
>=20
> mm/list_lru.c | 21 ++++++++++++---------
> 1 file changed, 12 insertions(+), 9 deletions(-)
>=20
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index dd29bcf8eb5f..d454bce9a78e 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -473,26 +473,29 @@ void memcg_reparent_list_lrus(struct mem_cgroup =
*memcg, struct mem_cgroup *paren
> 	mutex_lock(&list_lrus_mutex);
> 	list_for_each_entry(lru, &memcg_list_lrus, list) {
> 		struct list_lru_memcg *mlru;
> - 		XA_STATE(xas, &lru->xa, memcg->kmemcg_id);
>=20
> 		/*
> -		 * Lock the Xarray to ensure no on going list_lru_memcg
> -		 * allocation and further allocation will see =
css_is_dying().
> +		 * css_is_dying() check in memcg_list_lru_alloc() avoids
> +		 * allocating a new mlru since CSS_DYING is already set =
for this
> +		 * memcg a rcu grace period ago.

I see. xas_lock_irqsave() in memcg_list_lru_alloc() functions as an RCU =
read lock.

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.

> 		 */
> - 		xas_lock_irq(&xas);
> - 		mlru =3D xas_store(&xas, NULL);
> - 		xas_unlock_irq(&xas);
> + 		mlru =3D xa_load(&lru->xa, memcg->kmemcg_id);
> 		if (!mlru)
> 			continue;
>=20
> 		/*
> -		 * With Xarray value set to NULL, holding the lru lock =
below
> -		 * prevents list_lru_{add,del,isolate} from touching the =
lru,
> -		 * safe to reparent.
> +		 * Reparent each per-node list and mark the child dead
> +		 * (LONG_MIN) before clearing xarray entry otherwise a
> +		 * concurrent list_lru_del() may corrupt the list if it =
arrives
> +		 * after xarray clear but before reparenting as
> +		 * lock_list_lru_of_memcg will acquire parent's lock =
while the
> +		 * item is still on child's list.
> */
> 		for_each_node(i)
> 			memcg_reparent_list_lru_one(lru, i, =
&mlru->node[i], parent);
>=20
> + 		xa_erase_irq(&lru->xa, memcg->kmemcg_id);
> +
> 		/*
> 		 * Here all list_lrus corresponding to the cgroup are =
guaranteed
> 		 * to remain empty, we can safely free this lru, any =
further
> --=20
> 2.53.0-Meta
>=20


