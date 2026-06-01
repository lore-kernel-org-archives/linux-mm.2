Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B50EACD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 09:54:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0FE76B0304; Mon,  1 Jun 2026 05:54:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC0C66B0305; Mon,  1 Jun 2026 05:54:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD6D96B0306; Mon,  1 Jun 2026 05:54:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C0C4B6B0304
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:54:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6403540606
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:54:45 +0000 (UTC)
X-FDA: 84830884530.29.BCE28A1
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf22.hostedemail.com (Postfix) with ESMTP id A393CC0007
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:54:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=opmdGdka;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780307683; a=rsa-sha256;
	cv=none;
	b=p6r498Y6hPiy/5r/6/DiEb73vkyqpkPlUPiZ1eHdZwpv7rjl4sKliRzyQxRiX1OAgbaSBg
	5Z6dtUhQw5AwU/vjbXyQ2MV/7vJ7V7Qhr+47jsUgOrvtJHKJ0oVU7mrisfo5sNj6As0amp
	jcP+beTwyaky0mrbOgXwXxtRDshYY1c=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=opmdGdka;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780307683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=okiM+ywmJfzOTYWBfyohEkr7uDVGfpbqCX1aCcdo0W4=;
	b=HRwfl6cKU7ITVNeUBu0uEZt0hNRzVmFwOjpp0f0boNwPLrgbfvW6XLSF+7p6lvvaU6UmlM
	Sn6c69DKQHL0YSBn6ww0of64sXeuMefSJRFxkQUG1ciKBhgKyrW+bzs8LIWOVosIHAS8ZI
	thSfQohJ7zA7kACFHnrK+w8C/FqHnaQ=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780307681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=okiM+ywmJfzOTYWBfyohEkr7uDVGfpbqCX1aCcdo0W4=;
	b=opmdGdka5O+wo3q8pHowq2rDoNiWwEqRQLMSPNt8JoZqoBfPy5UsmGuYotw3P6ts7Wip1b
	lKohENeRj+wfynbsP7USECZcFWlmg6AnJHdv+oVcW2IjMFsOBxZ653TnfS10iDnqBJUG1z
	JXEtE9wYw2lk5TIdUmvN1NnEaJ80wfo=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] mm/list_lru: drain before clearing xarray entry on
 reparent
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260601063408.2879011-1-shakeel.butt@linux.dev>
Date: Mon, 1 Jun 2026 17:54:01 +0800
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
 Chris Mason <clm@fb.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <79CD986A-2130-4FB8-804F-A543AF22342B@linux.dev>
References: <20260601063408.2879011-1-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A393CC0007
X-Stat-Signature: 1in1f4gwwruyitzprs5hhasoes6tdo3r
X-HE-Tag: 1780307683-415669
X-HE-Meta: U2FsdGVkX18nJPNh2djlGhfB6/HLHwIDykMrWmwDQnb7rIrhzQSSX+1pIfNV4jJLd8Qd3X7MxEAWCRgVctc8f/orCJqhtPNRBmTmOX4jcSRQaGBif/DfHCsOTjDZ4HyLu7cNBx0MseQcauoVMEafbhRNcEBnV/VMACxlceoz/V/s0/YoblfCrMO917QwKJc7vgoOyGJ3KOcEghIeBoF7G7Txwf10nUHNnUq8rRiZjXNWp1wK/3tqRhvl6emoS5kj2Rasiiis1H39yUUifykeWe6aLOk1/pj3aVAL86Z/L89Gtt8lCkj81VnQTDveH0/sHGr4h1NmRTuQmn6rDKsH6HZGJM0U7aEfndarj/gNry9VW8zg4vZMc+bJjCJr2Sm2QPV2d1VFI+fIebJtn/pPTpP9lVb2wr6lkWvUe7S/+cjCXWnvvW3vO5xy3IY6tYWxzKyKSPY0CL6+xBV9152XKn8RisW/1t5fkzHjL9rcX0V0oi5t+OTUxM5tWHo1gCeHuZRgyNuVXJWRXERm+hYLttFP2IT6wp7NRhcEJrcWvGXVxVkCFVVdzsXQm0FX1ousncfCsDWLtcIpEoUb1kEzP/8i1geVvyxB3yxATIbdAhwhRgwVl3rYFeHLOWyarc7ZXvm9wnD4K20bKYCxcwslw7jkxsNPlU0BU1o7Zc6/q5p00SW0PpV26PwUvifjU2ytQIQ6P16y1TVTCYbtcphjbZYarhV14/CgOALTbDx2phgX9OkYS+vnYAUzFMHwBTeKh2qN9KV2F0apOmi6WK+3eOUcc7A8VF4Y9ORqtswN1Z8SnbNjGTUsM5wEqmkMQVn6cXf/1z7Bi2EjkACKP8ELsfOEYbZzKenyWmvbCaAOw00BK/dmZ6hu56TmM7M9fEtsn8qSn98twACUGyehdi5s04PkyGc7iyXee5mgi6sOfsXGg8B8bW7zJPyu59GhDG4tetPcS8w/vzTEUWTWLYh
 DB/5oSNz
 FlnYAL/p/bEKacQbQ2EMoMw3NDpgAT1Z1m0OAT3T0WNqZKw2AQqOB+f9y/JcNMfK5priK485DGRTsxz36SXBly1ivUQVmmVJVljI3YwlhlhssFHr+c92n+XkUonnTKanD01iogHXlMrab/dQbVWIdB41tMS6blbTY5ARt+z0LMxsLbm24gqlKaxzkD2CNbJ2cvuYEAN68ZByVD2ibIKgFzu1Z+6tad3/Zly5AQVsVwNSG1+xwZz86E7sAUKVD2LWLOK8Mn89TdJTl/jToOo9T0mXIxT+FAQg3R/mgOf8kIQ6VepeOYCgt/v9XGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jun 1, 2026, at 14:34, Shakeel Butt <shakeel.butt@linux.dev> wrote:
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
> ---
> mm/list_lru.c | 20 +++++++++-----------
> 1 file changed, 9 insertions(+), 11 deletions(-)
>=20
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index dd29bcf8eb5f..ae55a52307db 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -473,26 +473,24 @@ void memcg_reparent_list_lrus(struct mem_cgroup =
*memcg, struct mem_cgroup *paren
> 	mutex_lock(&list_lrus_mutex);
> 	list_for_each_entry(lru, &memcg_list_lrus, list) {
> 		struct list_lru_memcg *mlru;
> - 		XA_STATE(xas, &lru->xa, memcg->kmemcg_id);
>=20
> - 		/*
> -		 * Lock the Xarray to ensure no on going list_lru_memcg
> -		 * allocation and further allocation will see =
css_is_dying().
> -		 */
> - 		xas_lock_irq(&xas);
> - 		mlru =3D xas_store(&xas, NULL);
> - 		xas_unlock_irq(&xas);
> + 		mlru =3D xa_load(&lru->xa, memcg->kmemcg_id);
> 		if (!mlru)
> 			continue;

Is it possible that concurrent threads running memcg_list_lru_alloc() =
could
allocate a new mlru after this check passes? This could happen because =
the
threads haven't noticed css_is_dying() yet. We would consequently miss =
the
reparent operation for this list. So xas_lock_irq is necessary to =
serialize
CSS_DYING setting here. Right?

Thanks.
Muchun

>=20
> 		/*
> -		 * With Xarray value set to NULL, holding the lru lock =
below
> -		 * prevents list_lru_{add,del,isolate} from touching the =
lru,
> -		 * safe to reparent.
> +		 * Reparent each per-node list and mark the child dead
> +		 * (LONG_MIN) before clearing xarray entry otherwisw a
> +		 * concurrent list_lru_del() may corrupt the list if it =
arrives
> +		 * after xarray clear but before reparenting as
> +		 * lock_list_lru_of_memcg will acquire parent's lock =
while the
> +		 * item is still on child's list.
> 		 */
> 		for_each_node(i)
> 			memcg_reparent_list_lru_one(lru, i, =
&mlru->node[i], parent);
>=20
> + 		xa_erase(&lru->xa, memcg->kmemcg_id);
> +
> 		/*
> 		 * Here all list_lrus corresponding to the cgroup are =
guaranteed
> 		 * to remain empty, we can safely free this lru, any =
further
> --=20
> 2.52.0
>=20


