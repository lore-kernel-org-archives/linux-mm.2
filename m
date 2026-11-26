Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15347606A323
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 00:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IIsSkvRm
Received: by kanga.kvack.org (Postfix)
	id 1C1456B0B3E; Wed, 25 Nov 2026 19:41:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 171FB6B0B3F; Wed, 25 Nov 2026 19:41:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 060D96B0B40; Wed, 25 Nov 2026 19:41:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8DC216B0B3E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 19:41:00 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F1D17400FF
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 00:40:59 +0000 (UTC)
X-FDA: 85475415438.26.A38DEF6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1EC6B8000B
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 00:40:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IIsSkvRm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795653658;
	b=sH5tC2Wkd6Gjy9Nq21ig7wx5VUCZt/FhnK61g8qwf2eExX+9iVUJ5DQVDjrFicWy6d0eEk
	AVmZHhB55dzj/ZaIdT5W2qlmj2wo2xEeY36I9sEQNePr4AdfoDESShvLyVNaueQr9xSOfc
	a7bGs8cpXEZwstYUVhwVoeT/rO5H0lc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795653658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ROqfz97ZpfUHHWsM2JzaOj+b4tvNFO3hHXdoi3R6Bx4=;
	b=RuHNCqiQyA8XbSUJU65bVbswF2OaNp8oaNUBocRN2Drc8rZhtbyO6GYloXyxsCln4G64yk
	ZCdGMPz/KmzwfImx/Pb2uhBbaNN9FrebUrwHWYAWBl70oa45uKFCjgy+u4XsUTT0gxF92f
	6pO3GKWaStAj5Lcxi+Ho8xEdhcP0+6s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IIsSkvRm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 24E43620FF
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 00:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F151F000D3
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 00:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795653656;
	bh=ROqfz97ZpfUHHWsM2JzaOj+b4tvNFO3hHXdoi3R6Bx4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=IIsSkvRmrxVpdt2ZNq7F8YmH1k07rPBBHdA5/CYaWIJydO+J973A1KWLslA0i1DP6
	 599Mgk4greqpc6ghIkzL1gYqthcINWxidXMeQExEnYWGXUC/E8gG3nW2JSL89c/QfX
	 cta3o4lZoFQXL5a9p7W85owYHhIEQxQOmJ4qHMNUqC2mamkDo1zjLccYvzeMKdVtvx
	 qtsYtcHaMX4Ds+6vPOZXLfEuwJC1pEJQDCgmnmySrWpTS+6dh+x+0GWhvjSCZv8YA7
	 NUSm3Yla6h+UqGg6vVPxJnYmzaTEJloHEuZmC7nDrrLG1Ghj7A4Iac5yMU1nj9IgWN
	 0EuiwHOVnDk5w==
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-55b8cd4e2abso66084761cf.1
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:40:56 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErH/RXZX2u6r+nqcHCvY1drH4dZ/sf6FkRcM0gXO4pN2RFTOmjU/JA9wi+s2DwYcBvEp5adGzFajWQ==@kvack.org
X-Gm-Message-State: APuU4Z/KZRq6um35QgeaPKnCuQog3sHhPGPf6GUN5H3Ys9G/wug8sWT4
	Dg8wdbSUTEaVay//wc7LF6xHYEli2fyP99uicePZWihEgmeNNIkYDrJPGJsbXtsswrzHM9aH92f
	Y4zvfEgdURG4zITKJX+RBNlb+FFBLB2w=
X-Received: by 2002:a05:620a:17ab:b0:93f:6e05:22eb with SMTP id
 af79cd13be357-949ba9e1425mr3467128985a.48.1795653656141; Wed, 25 Nov 2026
 16:40:56 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261125-fix-mglru-kswapd-age-v2-1-4cc37437af9b@tencent.com>
 <CAGsJ_4z-UdXQg0LYqymEZdoHALPmAZC7eGcXbGad6f0sdjmkcw@mail.gmail.com> <awarDrT/DT7tQu+U@lima-default>
In-Reply-To: <awarDrT/DT7tQu+U@lima-default>
From: Barry Song <baohua@kernel.org>
Date: Thu, 26 Nov 2026 08:40:44 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zf5NabZJanr2_Czr3oVQe6tTTdXmddx+PxowbKBN9M8Q@mail.gmail.com>
X-Gm-Features: Aa3M54qqdItbwgjoEHWn9-crdqoWLQnJV4aNvDHtTbWqBrdWHNaBEhfxmdXesaw
Message-ID: <CAGsJ_4zf5NabZJanr2_Czr3oVQe6tTTdXmddx+PxowbKBN9M8Q@mail.gmail.com>
Subject: Re: [PATCH v2] mm/mglru: skip oom killing for order != 0 allocs in kswapd
To: Bingfang Guo <bfguo@icloud.com>
Cc: bingfangguo@tencent.com, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Yu Zhao <yuzhao@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: x1p1jjb1q6np7r1rd9wkjk6acrcdiqbx
X-Rspamd-Queue-Id: 1EC6B8000B
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795653658-316470
X-HE-Meta: U2FsdGVkX1/5iFX9ghOp/u4rGd64Z4izYQmzyKRr84Rwazy9h9EjEtVrevM4ZSTrfILki3EYmbfVM9kXFaP2cU55jkU54uAwU26iDFKBqeL+fFBhQW7RlFKu6OkiiCN6GtW4wjatf43YL3km+QPlPYLi9Fxebn60y8KLRNvNW7a6l+1O4QPlA+z0bDCuOF6gsMLNlH2A83GUv+q5W1T8ukwaAV6Vm+1bYzYwRxf6w/Wwc/76lWEEcTTil1x8rpRypxfZshc1WqbUMoWT2O7uc9DCv5q2bfcYr+pJh48lWtO07keUdltP99JdGjNAFTBIG4mK3A95/irA8D8oe35/Gbhrp3IFiXareNW77FWAdY6JZuaVao4TYQswPcCe3ruCT5qYSb2vV+qeh0UUjheeUxPbgVxcOeT64NdvDMZ4rX6JDBlXjfE+RfOoBiIpHOrCI9OsFYkAJJilZ5mCXobb9S1jERsXA0EYsqIw7I9BN29B7qf4s12ttIPA99fLlI878cn3zLJ3zsKuNKwswa76pf0Zbeajl9e5Gf/VW9k7F3Mxi/k94ECLkxtCVRGyHa7Nq/4DCMJqPIJXFpEccbo+DXvut1xuDhYaLHASFrgRUAKR67QBE4C/WkzkfkEJ6as+6SeiqVs1RpyZUVqT30e0cE/rutUSHv6FdTSYuYG7Fc3N3UImoInR2lmEme0J1MX2FcByooHKgmqJv7Qpi2A/7Nf2cMbh8hVv7JKDSKdrmlgLfNF+CqMnHcH8nrleNIODTZPl6PLyFjllprmgAjkvjsOmiteelx6od9qNiHdi6PzVd28EQS5OW3MY0sNzTGw8aVYpMENOncSbj6Asu04tyFz3Ep7BUvWN8ZSos7kGZH0+WIdabfRzCK5cxILtNkihKNpJw3nT0/pGcsLhQbzZq5pt32Uc4+Il5hRLCBPabUduhk1259GZMoqPnhbfV6+CjB9bclqYE9V/zBe4Egb
 L+hdTO1/
 sndSxySH7eZ9MIdgliNWFRe1qa2YbawgKATjNzBSLAw4G1WGgDqoejMGW6d6GI495T/Fk846THhhBaHFQ7mT/aOiLAtcLPQyDKGp/AkbZG7QijoFAjVPO+LLUerGG+0NwcMm/YYb8z+5i1ei/2xm+WJE3nUseIArbye1JOqkb0s98Lwv9071ItQal029Q/uN3a+5NQ59g+Rpk63xX+t/1YWl2f6orKlfRf76mEd1r/RQbt+qM1qHd60x83bbB8UTuTV0Hr/jX4HV6vy8D2B0eTjVLp+BsDTxuDCoKHX3Q8xPFM5VhSVM6EBboSGA4SSZu+HqF8oXPI6LtXRmirgH3UZ/cu7pE4x7sSvgYo1jufZGu9R19cQCIeHeFtyVNDJujApUP4HJ6OBk3KU2wJoSAxKuWDH+3GQS5HZQIsBm2OQaUT3xye6R419SSoZLXqnqnwM+M16qYwrWrUSUO2ekzAn5DGSzasqnnzqC+Ut0w7okaoSv1DxDpV7WmiLPvVgjLJYvawfxZCkuj7z3nV3OiCYvZFq6U9pHaFHMKcmTAO2xmcKGAWEfJ8kL6StX44zeKA138Fr48ICJ+vtYyqkm6RHFERar5UmzCLPoQFyfFJ6g9lermChQjO9zqW8a/OZRp1Dq2Zwbc0EBKbnmU85sGDr54Yg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 5:32=E2=80=AFPM Bingfang Guo <bfguo@icloud.com> wro=
te:
[...]
> You are right. Maybe we can start from skipping aging in reclaim path if =
the
> youngest gen is still too young? And maybe for this path, min_ttl can hav=
e a
> default value? Is that a good idea?
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index d891ae46baf49..7f9b14b772d14 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5136,8 +5136,11 @@ static bool should_run_aging(struct lruvec *lruvec=
, unsigned long max_seq,
>                 return false;
>
> +       /* avoid excessive aging for huge allocations */
> +        if (unlikely(sc->order)) {
> +               int gen =3D lru_gen_from_seq(max_seq);
> +               unsigned long birth =3D READ_ONCE(lruvec->lrugen.timestam=
ps[gen]);
> +               return !time_is_before_jiffies(birth + min_ttl);
> +        }

I'm not convinced that we need to couple the aging decision with
min_ttl protection.

This has been a long-standing problem: high-order allocations can
trigger excessive reclaim and still fail to obtain contiguous
memory.

I've tried to address this twice, but haven't found a satisfactory
solution yet:

https://lore.kernel.org/linux-mm/20260422021842.78495-1-baohua@kernel.org/

Johannes shared some thoughts on this here:

https://lore.kernel.org/linux-mm/aejtfpBUu7gNV6Tk@cmpxchg.org/

Do you have any traces showing how many pages kswapd scans and
reclaims while kcompactd makes little progress toward satisfying
order-9 allocations?

Basically, I think we need some form of throttling to prevent
kswapd from freeing more and more memory when there is already
plenty of free memory, yet compaction is making little progress
toward satisfying order-9 allocations.

>
>         /* better to run aging even though eviction is still possible */
>         return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS =3D=
=3D max_seq;
>
> I will give this a test later and share more findings.

Thanks,
Barry

