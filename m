Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72C89C624D4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 06:30:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 841606B00BF; Thu,  3 Sep 2026 02:30:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C9596B00C2; Thu,  3 Sep 2026 02:30:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B80B6B00C3; Thu,  3 Sep 2026 02:30:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4611C6B00BF
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:30:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CC0B2140439
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:30:26 +0000 (UTC)
X-FDA: 85171476852.30.E625C31
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id CF7E5180002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:30:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NQEgvfbF;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788417024;
	b=feJMFWitQRHbqlFK6uMMEN2PRlwKPjJLajYB/eYd2RqSQeL5EZprwuTOIFTBOuGeZW4sQ0
	QVD0URf6sXlIG7sxRyHFhPLGzBDXCVE27li/v4xeFp4gBN3qMCg/pPf0TqBgWYi+/uITSF
	sA3y4dPDcRPIKMqbC2goW1a10fi3BWI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788417024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z36InkbgZ5czLNoME51lvPgrfTTVurywTjIuByWup8c=;
	b=K7auvcXrH+HBxkDNMNZaBR1Sxa/d7vB0lSkoC7J0xYi9HqOyBixOu62WiuKnwgvMP1gcKg
	qWFuj7Jq26lL3uRes5fkDsuOWvDWF58fJ5z77NBmwC9GzBBW9WW9h5Z9S+o+suezhffZxF
	/D7J9M7CkTfX3Pqx8EHyHrI3Vpcia7Y=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NQEgvfbF;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A860243EB2
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F86B1F00ACA
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788417023;
	bh=z36InkbgZ5czLNoME51lvPgrfTTVurywTjIuByWup8c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NQEgvfbFEiEVrwFSBb/9E5aGP1yluPqmMKNMROwPv43STzTUF6Nd7VzSo4LqIes+B
	 vS33elFpG3DqJVJp7oXlNn0Qz4hD8DvzMCc6Ht0jI36l0/gOETnGOukv7PX5NkJ1md
	 99z/lxcYVTCKfNPOOqTFJJMa/ChgMj9aL1If6GAvBJdjVlrHD6VnkGGwjX0v0EsM99
	 oQBnuE9Fzx82MuO4xrlTW0e+PZqHg2hT5cxPU4Ecc714jXMIednN6MjlIjyGDgf8o/
	 a0M1NZ9tBvErUImCCyjYSMPOu9PV2DglTKjiGBUaGwzaxISTriJLtM8lTnRyiCGWIW
	 dpnbekKaUUqFg==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-9390a2c8909so165566785a.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 23:30:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwjDrdU47+tiEwhqCwE15oNDf7Z/UjK0PkSZyI72AtLlmqBqcvtIDJPPOyXrjb31xZk2lHVrt6s1g==@kvack.org
X-Gm-Message-State: AFuF++lqFLk0z6BcYAz/BuGrs0bgjlQfRJKbSMhIx+O9KrLhWSLh/+AM
	R4LYXkC15CzaIqFn+1VE3WwjFbebez10MbPqbomF8LB1ZL+ZB+4/PH33RbA/0Cz2nvLeD8BU0V9
	XgKAmAfzOhkS8V+3jgC/Q8mSYP8OPzRc=
X-Received: by 2002:a05:620a:f13:b0:937:2ac8:bbda with SMTP id
 af79cd13be357-93960f52da3mr1075847085a.35.1788417022888; Wed, 02 Sep 2026
 23:30:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260903031952.1120321-1-ridong.chen@linux.dev> <20260903031952.1120321-3-ridong.chen@linux.dev>
In-Reply-To: <20260903031952.1120321-3-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Thu, 3 Sep 2026 14:30:11 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wKaboESQfUJPi8y4BNJuxpEWG2Prjb44NvFKDV_aeVhw@mail.gmail.com>
X-Gm-Features: AcwNN1Xa9LjF9LvOPJz6jmGmZsvCdU3Ed2O2AMgXfYG7RHIlGiW-5e7M8Zr3wao
Message-ID: <CAGsJ_4wKaboESQfUJPi8y4BNJuxpEWG2Prjb44NvFKDV_aeVhw@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] mm/mglru: fix ineffective memory protection for
 non-kswapd reclaim
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Chris Down <chris@chrisdown.name>, Tejun Heo <tj@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CF7E5180002
X-Stat-Signature: nfpiippggtnkg7mbz4azdwazq15cpsi7
X-HE-Tag: 1788417024-282264
X-HE-Meta: U2FsdGVkX18b1OwdnmN6qPU/IQMrqOUlbWaumBREwp6ybyKhFDpXdDXb1Ps9jirH/sBnYNIBQvokdmKtlAnsQJLx2YDzhgPz8dWCg/QjON0SdyXjwM+68gaHqXezCdUURt6YhrCR9oyvIokgXhphJY6pB5GKB0rJnOdgsiyVN40N0oCrTfopyKJlrsuz48bYL7ZeKJ/UI9frRatNe++4Bzjunqp1SISSUXzTrtryS1MoKzBquigOb/dOA8pB0n+8FMQRUjk3U2MUqaId8evdSJ0ZLDL0A8T4GK22TsfecMUy3bGW23dHlOkspXjruXEYarjvZMIP4p4aUgNZ9S/SbNn34zQ6Y78NTtzBQcivWvcPIZP550QOtqo5NIs04R4ScJuDydfgJBqZWv9LvdEQZVWqNA9im0I/v7egNWa8YeWJP1rpf+3B1FEvdmEizqqKmZr0tfA8H/EOoLzENO/w294x2dEbUFHC/Z77PxEhfMB2wg3smteY0lyL8QHPvyz2vizJZiIUvJdv6xN7zt0jdcAGhCox6Vowx37Fr4i+3byvicHKv5eUObeQioxtD3Y4jV2qFIZkTthMFxvxjZwiRQt6oMu0j14dvAss6tsVJd21y4QZ+/WV5fKPHCrJ9Qz2mpP8LxDNWuC3hyhVZnCjMIHIxaDWo+lsZ8uup//PSKCjXadnnNMHwLbUSAmQSgM6uUjXk6vy4qgA7n+tuRD3pRLsxn7NxA7+lIdm7O2Rol1XraW3fRCUUS4HQ8De6BzfcKGsVlwZX6+nn4s47/hnbs7rz+7luaEr7Hpu4JBoJNz7OUiB/e0LJuYqrOKSzFvA8Rp4aT30FnLjt1AIj4L954ALmB3WOTX1SI7iCqOcxnmIEgu8i658uifjXNEsLpvc8quUpGWxIF66KeQ7BuF8X/YV7B/996e1pk7E8DG1+LzVk9JHgkamUnirPAKHG4EnuIcD16eZZawMR6mjTi9
 p11qld3f
 jE+Uc9nO8Kq+xmGN3axptLReplUJOL3/sutwTMT5HjqLXaueCdT84xP9De56MjA2gCP/ysK4ZqCIP/YuiyciA4coeH+3WMlgjx/qy7ACOHTBrbj/mNUEchZDnthVaHfrP5Bt/bqK66wYyIfCeJBwjAtsLYQ60x741AH9ALHlN8y82sxPgTeP+lFM48eL+7DLjtK784V9Zx665W3ZBS6Zg9gEEqwb1i5cCbvBTY7R8qw3OyvX8FzpF9+LCR7qNjkd/eXtmNV0SnDq23en9M/Eb+AT2LuHd/pD57hbvzmqH/WQLT0NM0TOZ/YsIEGq23PhD2iYz/F4UYUW/pSI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 3, 2026 at 11:20=E2=80=AFAM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> For MGLRU, memory.min/low is not honored during global proactive reclaim
> (writing to the root memory.reclaim) and global direct reclaim, because
> these paths shrink memcgs using stale or effective protection (emin/elow)=
.

Are you sure it should be =E2=80=9Cstale or effective=E2=80=9D?
My gut feeling is that we don't need the =E2=80=9Cor=E2=80=9D here.

[...]
>
> Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---

With a few nits:

Reviewed-by: Barry Song <baohua@kernel.org>

[...]
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index b4c9b8f3dfe9..500cc2051d13 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5111,7 +5111,13 @@ static int shrink_one(struct lruvec *lruvec, struc=
t scan_control *sc)
>         struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
>         struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
>
> -       /* lru_gen_age_node() called mem_cgroup_calculate_protection() */
> +       /*
> +        * For kswapd, lru_gen_age_node() has already called
> +        * mem_cgroup_calculate_protection()
> +        */

Could be clearer:

/*
 * For kswapd, mem_cgroup_calculate_protection() has already
 * been called during the top-down cgroup traversal.
 */

> +       if (!current_is_kswapd())
> +               mem_cgroup_calculate_protection_path(NULL, memcg);

Best Regards
Barry

