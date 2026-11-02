Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31F4F606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 23:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iLmxYpKB
Received: by kanga.kvack.org (Postfix)
	id 596BE6B05B1; Mon,  2 Nov 2026 18:29:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 547D06B05B2; Mon,  2 Nov 2026 18:29:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45EE96B05B3; Mon,  2 Nov 2026 18:29:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2762D6B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 18:29:38 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 89B9F402CB
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:29:37 +0000 (UTC)
X-FDA: 85391773194.10.6014013
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id B3D1A40009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:29:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iLmxYpKB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793662175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YTKi2ZfuXtkzbJQerS/R1oO64J2LCdQqFsgYxGf3I7A=;
	b=1ddLl9zMkErMPukRxKpQfSUhKxWu4PiOLdSjRNZAPVRj/g86uwmiojLLpCfrPBxM1iGgGs
	Z3deNOhHS1Gz5K9RMG3mot2yGNW6tFBZ9KFx5h2gwHwxfZfX//M7ic2uHwQg24zMQGYtPG
	uYnb1gELyqu2Hgc+K0YV5kDghNvsvaI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iLmxYpKB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793662175;
	b=ZeRCSY+pc8zod0SSFlas8mo4irL2olF6oenVxqdt2vqcOrCz8DOsk0Vuc20Te0ENmR3bTE
	RgJIv3QvBkcmn3DXSjfwCYudwbExZTyju7A56QIAiBGUxxsQccpezm3eRW678Ni6wrs5Fl
	dvJfUJY4DppPPfVG7Ta5wcTAb2pEOGI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A40D60120
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02EAA1F00A1A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793662175;
	bh=YTKi2ZfuXtkzbJQerS/R1oO64J2LCdQqFsgYxGf3I7A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=iLmxYpKBtb2Sdv0r01qtXOVlpvgwAWru+Ok8vsOsBX4TUWT/L3zIPpIEZIEWF7vdx
	 t8NntwM9tD/+nK96mxlr/NPIwELo4bF3H2n8XE4d7C30PFnO7jgAaL3NP9oyq9X9S2
	 jt9BkWKOGgp4pkADIcBhBIQoH+shB2mgdM/3dG8K+bbkCvX7qXWQRS1cPGnpTaW9S1
	 C61TAVnooyiRHepDeFGV5dEKolSdlaasXHuN2HJgLpJ9+EhlSck7XqnFX9DcGYVTpp
	 yLdxyMXJ8SIqh9bdjs2XFDFX6j07xSXenmV6L/tkuUrInI1EigN+A9+RaXbiuTHgg7
	 E2GiFdzlDl74g==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b4bd3d98bfso4318838a12.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 15:29:34 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvByWghk+4+ojiz69b5nEw/45WqrGeMQEI+aUqjWkvMOIJhvIJK72ldT8I+p4bn7BZ5NMAv2mwPLSGA==@kvack.org
X-Gm-Message-State: APuU4Z+PY+a+zKNTnTAR7WdjOxcBEIzeCr+UVUjmEo90goMKAvKwjzs3
	EKCZwnAaq7iIo6pV7UBsqD8iMgEGhSqlRGRfCu9Hm5E/ic99MlAYKUGoLXpvmOPeJLsGN7g16SC
	f8R9G/Zf5AcQ54YUIWyNKo0cmTP7JjOk=
X-Received: by 2002:a17:907:6ea6:b0:c2e:378c:8ce3 with SMTP id
 a640c23a62f3a-c4ca7aa72b9mr897146466b.32.1793662173962; Mon, 02 Nov 2026
 15:29:33 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261102225030.2743129-1-joannelkoong@gmail.com> <20261102225030.2743129-3-joannelkoong@gmail.com>
In-Reply-To: <20261102225030.2743129-3-joannelkoong@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 2 Nov 2026 15:29:22 -0800
X-Gmail-Original-Message-ID: <CAO9r8zP87zRuoFqeKFcAJoCrOG8M+7HCtX6hvxwdLzuHUXD0Gw@mail.gmail.com>
X-Gm-Features: AclHuK-4t4jepCmFSgrDiHYFCB2QMcYxAclyDHxOZQ_Fy5-IrgHz_mEoVtmdPJI
Message-ID: <CAO9r8zP87zRuoFqeKFcAJoCrOG8M+7HCtX6hvxwdLzuHUXD0Gw@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] mm: memcg: read root lruvec LRU stats from the
 node counters
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, shakeel.butt@linux.dev, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, sj@kernel.org, david@kernel.org, 
	ljs@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B3D1A40009
X-Stat-Signature: tykr974k5bkqau7zayd56q81hrtn1y1y
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793662175-596621
X-HE-Meta: U2FsdGVkX18AILyuXaviagFt3F5QMTc+CBxVvsOAaq8BxD+RDwBTjUijyGcKrYk+4cNAj0tnlUD+uzoJYuZbHoX3sY1Ecv/pKCUAUDFb0C13n6JvZ9DKXuRAUw6Lpdj9scr42Co5k/tHMQMCfLeEjsrmzHkYLmbUQA1sZCU8z61tlOkHcWCrlfe0BRYPTAZ9AG13V+I9xJAomT+LtqYUVlOhhcUo5+vaqGQL/alETvhWREo+pI2TvqDTBqD844leD5v6iavQ8dcPs9QiyZ/AyPJLdmxxck8TZLWj5Dbj0Q2wCMvwa7WwvUgvTqh38wyB+bsajVrtpeKIO0mEtirm5lpLMkocRzhOCGNg1hsQwY3OxNWeYHCxaP8XK9EN6nRSmBPCMOQgmQGEU+gwWp2YMVDxrBHK88iqeGZ1Vya/cE6EgaYfDckOjrMlXkCuD8g4vmD3kXOyZ/qjZULMk63ntWIag9JMJb5PJVVDmmo/Dyh/K1RpYhSdWt+5KDhZyHbUdnm1e8ZgeI0xCLYKvTQS8WfmtXU0mVybialeAZhyA2L0ggsL/jtMqrPoOyqykGF2WtLK30TfHVLLMcEDfpeCgHrMLNtiKr9mGVGxYEyvldWWE72oLxVmyp7djrxL56D87s1nXCjlZxUbtIwEuqEu7Lc7BcWWnaKBRbpV5SUngf0yGkX6DYHfh1kDesjLSD4HUsvugRgv/4ZBwYEpOo5TI9tGyPVA5BrpYROeTx2w+1r6OFIwLwMwJ1/Ia3w8fsrvLHmeGDJ6RhKdHCGMPLHVFSpK8zHxcyaxZxaLxf+hFdyxMTT6hbBWlGSDS2rhjl9hMAl/TOVKUWBAkmUhGAEZc5DRGgUllN5uh94zlW0Y9rE34xZjsER3XbK+uCzJFaAY/0IoimUlnWl+kH6w+5qZSDYxqxAHyIwADK9msRvd6kx5z5Syie/9YzSP0nokiGYKSZJRzPlbimU4YhkgbKm
 bRJEVKdJ
 eEQQJwkkeq+vQRoCBhFtWjZbDfBygfhLcuUlb0u2t0AhxvwGO/NWi7amKoel9GhZTeu/bhj9EybLfODKlodNiDBFJz4kmvNEC7OH6DLT8AXYIQ8a/pYSGE+YdiuYg+LOvlInWLOsjdw+sPPpposZT6qVJQlLIlw9nvjoI0B6qWYxs635MmeIgmcoRPd4Pc9O9PQj0iyD1vPYo0r628XxMEEkvWsNp4SPagv29oNtqvIFzPYx7IdjRR9n4TtqemBu2ekMRN1UaRl4RLzdA2P/M/VCEUyXWvZMqyDyz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ac6c43ea8c5a..938843346571 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -587,6 +587,50 @@ unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
>         return x;
>  }
>
> +static bool lruvec_is_root(const struct lruvec *lruvec)
> +{
> +       return !mem_cgroup_disabled() && mem_cgroup_is_root(lruvec_memcg(lruvec));
> +}
> +
> +/**
> + * lruvec_lru_page_state - read an LRU stat of an lruvec
> + * @lruvec: the LRU vector to read from
> + * @idx: the node_stat_item to read
> + *
> + * Like lruvec_page_state(), but for the root memcg the node counter is read
> + * instead. For stats that only track memory charged to a memcg (LRU sizes,
> + * workingset, rotation and reclaim writeback counts), the root memcg's
> + * hierarchical value equals the node counter. The root memcg can just read the
> + * node counter directly instead of going through rstat, which requires
> + * flushing. Flushing the root memcg flushes every cgroup in the system.
> + *
> + * Use lruvec_page_state() for other stats (eg slab).
> + */
> +unsigned long lruvec_lru_page_state(const struct lruvec *lruvec,
> +                                   enum node_stat_item idx)
> +{
> +       if (lruvec_is_root(lruvec))
> +               return node_page_state(lruvec_pgdat(lruvec), idx);
> +
> +       return lruvec_page_state(lruvec, idx);
> +}
> +
> +/**
> + * lruvec_lru_page_state_monotonic - lruvec_lru_page_state() for delta sampling
> + * @lruvec: the LRU vector to read from
> + * @idx: the node_stat_item to read
> + *
> + * See lruvec_page_state_monotonic() and lruvec_lru_page_state().
> + */
> +unsigned long lruvec_lru_page_state_monotonic(const struct lruvec *lruvec,
> +                                             enum node_stat_item idx)
> +{
> +       if (lruvec_is_root(lruvec))
> +               return node_page_state_monotonic(lruvec_pgdat(lruvec), idx);
> +
> +       return lruvec_page_state_monotonic(lruvec, idx);
> +}

Why not do this directly in lruvec_page_state() and
lruvec_page_state_monotonic()? They already fallback to node stats if
memcg is disabled, why not do the same for the root? Are there cases
where the node stats are not the right thing to do?

