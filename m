Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70B62C43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:02:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 390A86B00B6; Tue, 30 Jun 2026 12:02:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 346D26B00B8; Tue, 30 Jun 2026 12:02:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 209AA6B00B9; Tue, 30 Jun 2026 12:02:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 983B76B00B6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:02:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 219CA8F36C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:02:55 +0000 (UTC)
X-FDA: 84937047510.15.4612785
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 34146C0011
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:02:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OhbEsiEe;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782835373;
	b=a610Ia4yjZ7Tb07NRkSVujF4S614dRiJfUm9HIuhl1pahHeDWULRduWU4VhsMaYh+R0OO3
	hx619y/jvLkmopciQAkm5o/v4DmBBTSDGJnlrKOamgTZAtxmHDry+dPrPsuabmMX9DRgXr
	3zI3i24vOqbKEGBA7ZytQq+Zpv34H4g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782835373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=umGH+O+Vn9L4EN4GsKIUG29QvvcbPRfahOmTYYjIzwc=;
	b=PfqQSOBP5h4nCCs+aPJXvrQC11A7Xf6+huf6r9E3cAxW6LrN0BcQ/cNYSqBpxQXK2KUn3D
	9MWRBbrmJPjg/lqBt2Kz8/kvIMpzxXrZ+NNITqeka4SQPcytPWb4NhNjsjWlSkQG0x+5iM
	NJVJiBc8M6EcqhlXsQ+mOwYM0cId6yw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OhbEsiEe;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3FECB43F54
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2879F1F00A3F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782835372;
	bh=umGH+O+Vn9L4EN4GsKIUG29QvvcbPRfahOmTYYjIzwc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OhbEsiEeN8zjEmTCpp2wr7xdM+J5lgwbrEncfmNgXxY1Je5TPXo53a1aFjLJJijej
	 Qrk/8zkwVvp82/tCG7kHBv/BWMxGM0xczm4csCBQ9j/wx5jMeUphjNbpkXh42vR4RR
	 Jx03jBDaeOPjhxZp8bzwoUFgmuYI8+Nq0rO7YBQh0CingbU/Mn/wwVAnaCif5yH/iC
	 DmqimBSR5dcE6rvKsQNcNF5oL4YmpRaaoZ7zDXLqZZ9jd4lXtQL633G3p0e6paFv+s
	 qtC5fwm8kFYzgprbRNgtBv47qZTSlcuCEAybwkNqeSYxCYSF4gqvbixs3LKc6t8+wr
	 lu94+tMdgl8TQ==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c1269e4721aso323779866b.0
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:02:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Roldqqx5psCYlED+fo5NsDsX3QB8Qb7ckNrKUCRU5aenf2OLwLP57mH/mqGqvkTUzYXoi5++s2o+Q==@kvack.org
X-Gm-Message-State: AOJu0YwzkSV9OdiVeKHsSTKRlkTaplM6Cj/1xe7OFyAqm9FKlF+IVXoO
	IjcENjx8EwrX2mHUqZO7+wgViMNuCjBl1jwoQJOyM7QfEXrhBC700UxnT0NR5Ut3DFG5xPkR8V9
	rw8bkPZcQSJSSF2QeTUBiQUt/mBc/ppM=
X-Received: by 2002:a17:906:70c8:b0:c12:350b:7c6c with SMTP id
 a640c23a62f3a-c1297c30894mr52377366b.28.1782835370961; Tue, 30 Jun 2026
 09:02:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260629112032.20423-1-jiahao.kernel@gmail.com>
 <20260629112032.20423-2-jiahao.kernel@gmail.com> <CAKEwX=MniM-4-aV17aH3UiDd_Xd2RH743fFZaxEnYX9qvnokeA@mail.gmail.com>
 <fe15eb9f-0b6c-dcaa-d0a7-5f08c3f92bfb@gmail.com>
In-Reply-To: <fe15eb9f-0b6c-dcaa-d0a7-5f08c3f92bfb@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 30 Jun 2026 09:02:39 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPBe9BPwP8NXz7pdH7T+8HLNsRAckL2Vfcnz0c23TH=iw@mail.gmail.com>
X-Gm-Features: AVVi8CcCxY3djerzT5lNld_VLCKVnmzQBQkQgjO1_FN5S20hdx2Xm_guHNHu7_I
Message-ID: <CAO9r8zPBe9BPwP8NXz7pdH7T+8HLNsRAckL2Vfcnz0c23TH=iw@mail.gmail.com>
Subject: Re: [PATCH v5 1/6] mm/zswap: Fix global shrinker when memory cgroup
 is disabled
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: mys34igeopm8p3g3xr8eqoixs3u6csd6
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 34146C0011
X-HE-Tag: 1782835373-982804
X-HE-Meta: U2FsdGVkX19vNCXgLTrGfkkPF961xyUqRkcNxWWg8xEdhtIc6RK5X2Z383GAVz6Zsto7b5RuMmz/1QKoQ1ADKbI6T6gB1JtyJE4cSIgtBhkAhyjkvs2HNd0PH5FSTW+kaD1BEn7Xnd/MOxoehlmoemIBGodZGOT5VRY0h7cBNuJjorATEnvgnd86PR8K5EwQyJe3ETjZezHxLQ81DNgqowCcpKpTyAqM8UTgvv4HWRTZawIMKmBTzBGUdH9gaBfJ0k9YX9PbtIqkpLzh04nQYvgKV94bWA07B/oIZgBpFnWSizjGF59FBGnh4Ie7SCOSKAT1TQx235OYia+/9gDUQm2ajv8gVHkV2fkpybLE/FOW9pKvieTVjsfrHSLEbwsZ01+YZCKgOU+jotMj4i7OQ5Lp4CAveI3aVOWWO9NvK/5pwX+nk1yYtPHWPsplsI72ZVvIMPuwk8B1hp/wvSroSy3It0w8q4pfjoDnxDu2eMIcT0Ial19t/qSLmIBU/PwejLKhyOO+O9F9BntshZLynBhUkRmhJXj0xB+hC4Lik683Ay0wiFTbY4GSXOW9hFkt3vtKee9XweziBPobSweeBOodSv1i+YMEDdLF/eMOV57um/hpvawqRUpOqWXRgZ/xS/+ppRsKgubatOgLnnupss6VuIq6ATUQ0Y8rrE7mP5di+HMwqDYTCyFWv0SkE6OmFYAhU2eiyCwM6HjBfzFcrRvd8U9QaEmTK48Prod+QnPcuDRLtS/t8N2/U4pl0zg91dWxCxGl9Q9OwgUUNDv3jV2NXBv90VLPQKkMkYNni1OPdAqv81tRDASxvBVcJEW1dnqwA83REC4C7F75AmPTjJR1UxWYg67ZkeOBf93ubsHoHpl5hAOF++cm+OpLQ3dNE01cuv0h3bRPNkwgPU8NWf5vSujVg+uaCFl2CUmVvZNCW4vFm7vRcv+nQR7+wvRqGNdSOmEBhDhsNg5AwQi
 CroI+Mdt
 XoLu9KS7sv/2r223McyBA15QzF4eNEwIBwS6lx0W+obY/34a8uMycM17srr4/y1HMAvd+wJdoDTeg93yy4gOF/pNbLkod/ChI1Sth/SYuRKbAUcYbJA72QnOqNa6A2r9646fQGiLcMBfS+Men3cWuscxBMTLdkNsZ48bexaQrQDR+2iDz99FVcUcsRuWx5/ITR94Nb0lRv4UpDxq9Y+Q7rPOhfa4euUkRnMbRIhItz7Ps2i+QJ1Wp71UKyS6my2+Ap/plyY8zZJSXbB/RM1fdkheld5mCZlJr5HTcLYTv8aWWEbC09gYuPRiIdYjzi5HI1ZcZglGJeor8qpIBfPr51dJNuL2O1x57BgkXgGMuQit2m1p0Q+AJYGi0WNqfLho5k6F+eigdVY4tq0xgqVUsDtJji73iskSECx0zgo3pslh8546/2KZ62qI5BEyXEqRYj17ghen6oMJBI8Gf8dHQFNclZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> How about something like this? If there are no objections, I'll fold
> this into the next version.
>
>      mm/zswap: Fix global shrinker when memory cgroup is disabled
>
>      When memory cgroup is disabled, mem_cgroup_iter() always returns NULL.
>      Therefore, the global shrinker shrink_worker() always takes the !memcg
>      branch. After MAX_RECLAIM_RETRIES empty walks, the worker simply
> gives up,
>      so it fails to write back anything.
>
>      Therefore, when memory cgroup is disabled, fall through with the !memcg
>      branch and shrink the root memcg directly.
>
>      With memcg disabled, shrink_memcg() only returns -ENOENT when the root
>      LRU is empty, which means the total pages are already below thr.
> The loop
>      then safely bails out via the zswap_total_pages() <= thr check. For any
>      other return value from shrink_memcg(), the loop is guaranteed to
> terminate,
>      either after MAX_RECLAIM_RETRIES failures or once the threshold is met.
>
>      Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
>      Cc: stable@vger.kernel.org
>      Reported-by: Yosry Ahmed <yosry@kernel.org>
>      Closes:
> https://lore.kernel.org/all/CAO9r8zPVzMKFbCixxD-qgtRrkFxWVrHiZZeLc=eyTPKPVQgX4g@mail.gmail.com
>      Signed-off-by: Hao Jia <jiahao1@lixiang.com>

Feel free to add:

Acked-by: Yosry Ahmed <yosry@kernel.org>

A small nit below.

>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 4b5149173b0e..9d4f19fc440e 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1361,11 +1361,12 @@ static void shrink_worker(struct work_struct *w)
>                  } while (memcg && !mem_cgroup_tryget_online(memcg));
>                  spin_unlock(&zswap_shrink_lock);
>
> -               if (!memcg) {
> -                       /*
> -                        * Continue shrinking without incrementing
> failures if
> -                        * we found candidate memcgs in the last tree walk.
> -                        */
> +               /*
> +                * A NULL memcg ends a full hierarchy pass (except when
> memcg is
> +                * disabled, where it is always NULL: fall through to
> the root LRU).
> +                * Count a failure only if the pass found no candidates.

I think "last pass" is clearer than just "pass" here?

> +                */
> +               if (!memcg && !mem_cgroup_disabled()) {
>                          if (!attempts && ++failures == MAX_RECLAIM_RETRIES)
>                                  break;
>
> Thanks,
> Hao

