Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4B45606A333
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 08:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vXDAfp9l
Received: by kanga.kvack.org (Postfix)
	id 4D42E6B05E2; Fri, 20 Nov 2026 03:36:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ABFD6B05E3; Fri, 20 Nov 2026 03:36:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39C536B05E4; Fri, 20 Nov 2026 03:36:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0BEFD6B05E2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:36:05 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7E58C40D7E
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:36:02 +0000 (UTC)
X-FDA: 85454839764.24.6BD3160
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8C7B9160003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:36:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vXDAfp9l;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795163760;
	b=wB0goUo5Lp/+u1j3WOpGb6CZZ7IZslZ69JW+vLhHJxcTs0gyfmIQmz1bJ5kUc2GuZkdj/6
	CT1sVUQ3P+GLDlJLsjVFcWShsJJXlchIXrU3X4WEyOXwyL2DD5EMB4TVxoLyIICT5QRRwu
	tgA0423DfXW/cH2NgPB61EcHEROjCRA=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795163760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DSuUtXGnjpMqHENNRIfD4nz00o+v1iSCypFww/wg4kA=;
	b=pdaaRkysfwzWhF51IalmwBd5YTQSyLy64RG5QVTs0r5x4NmpnWKCbSER0YkeTBBW5UIyYA
	5+HHmJ3388t9K8EIx7bZd++4u8448a3iipicdqxxExQ0GFErS0898+zAdVfnJRGc7Lz1Pk
	GVZYKJcOUEiHZH1mP7zWd2P2eyJ6dYY=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vXDAfp9l;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6b408f2d936so922886a12.1
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:36:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795163759; cv=none;
        d=google.com; s=arc-20260327;
        b=Q2ZjC03n7x8N8IMr8BqXjyCOaSA/jphjhV7GA+aSdTmNE6tPsgFsfP2dvv0UsE0WFn
         8Mm/7Tzv9Grl16322LGqISfDRmJeQz9mm25DtWlFATobOeBkDD/MV2VezpZ8gQs7cqM8
         6KLwHK5X8vkgtB77vBOyibbp5/pK0WOWQQtrYbG825OVUhvpxiqMxbktvxylx3Vs5jUY
         hEvYXmoCYDY52j6DVAtdo8Pl6MAxta9xbjfD8ujqra23vMZGUzd7Hcg5OuNINHQjzLR2
         GxwNiliOFkHKAWyzc2JysytRNqpZBrrFkvr5NpTpYXdhzrxySKXwucCalfJ3CaeuDSeW
         E+Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DSuUtXGnjpMqHENNRIfD4nz00o+v1iSCypFww/wg4kA=;
        fh=01xpVHe4kda/rS6+PGv7HHxY0OOMMTM3Wu/tKcvhHys=;
        b=hK0kDlgmqYU9yH7CubLNCBjfvS+Ao202bFqmWj0Ad5NN0GnggUW3jT/usah0nA1Xd1
         sHhHTF79NoiEx6NaCNzA+N0odSMNyg0FRjPX2Z7VKb0gF2+rSSeqRGyt07+S0zwDHXz+
         KHLD4o4oFlEQjfWPMDbdEYhddWVQk/7GtLcZVBBm22ZnBmaMYWsho6NWAv0lTJ9KqiGu
         ecODOYB4K6rh7fVE5YVEZg0CiAl2ftqwbwgCCD4+/KlmiDZxJfNdmFsyg5REt1yGmm9L
         G1+n1MoqH6R7oiLBgWHughD3eWAk3iAVxiQ0XjVDlWv5EXGnrZbYrnqakefQp5tE+w9V
         zjPg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795163759; x=1795768559; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DSuUtXGnjpMqHENNRIfD4nz00o+v1iSCypFww/wg4kA=;
        b=vXDAfp9lErpKSp88ZGaVcOTFrU/hyCSerNnqrCYWbhdY16B5e6wIE+8XDyQu3Wrxzq
         mbn9v6zjDqmXMsn5EvWlFDyYFuhDMNzUWlYXPpENkdPqZGfMKkh43T4fzSgz7fheO/yc
         3RoKtEyyzrv08CKS1prUFSkIk4/E3Mm8PZi/OxXep0jtc1Btp3/ZiI5znKeFV1H6i68W
         mF+Q5169A0RAUISxaUHQbJp3xMTlTuHutxA62BSmsQhfsGghQfxMTHSAMshpeEAcsf+Z
         ba71MzpH1b0KjNtcBSiB1HEGaqt1oLGWycY8KB3nLu95kBmLWOXxaoFAD6zeG8z6rcuh
         ng3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795163759; x=1795768559;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DSuUtXGnjpMqHENNRIfD4nz00o+v1iSCypFww/wg4kA=;
        b=Xsfr8n/nXavCEzdV61FnRWA/NoKMalsKe6L7FqybChW8y4iWhZYqGQKcpBiAcg1WkG
         g9aX/UoxaLQ0hgLDUARAjASvVXA63CvWeuRrUMaxjV8Q/FboMT8OEiD5QCL671CWfK1k
         0bwP4Nxnjn4bU6xb8ZvXeQqtKQ2XZQfGy0fI9vAR5ofRJY7yTZSut9kSuMbBnlE0UMIR
         3Rq1cbzbZDhl11zJpSZIHPb/+gUSCF6J7jPTVUfT1yO+16O3wKysuGAwLgsz0m4Y1nxR
         qouRabW4nJSc2w/+LRhRQqpT6HnKKyipZsvMrJa7k/8DwuaXy1e/QUvroqFwVlSqhaKE
         4kKQ==
X-Gm-Message-State: APuU4Z/bbIvLkLswmjCa+fO8mw7ndN63JN5BHJ1M/2i6LsHepST7F1Ev
	esumxUMnPfVs+2y/bqAO6yT/Qk/tTqXQ7AGZaI/UQnBkxNd6N8z4dg2ssPtNSavGqh63SalJniv
	tKHnqFu7ce7XGBiIve0dzoXdC5hwq9Mk=
X-Gm-Gg: AZFdTZfLCCNVjtJZaXBDtPp9VI+HKKucZOnDAOdEOxBQU2seaU32bh/cJbUt1lMPZEq
	ya1VhJJR9ZZZC9y4KEW2fYJA/jXl2rJ4rM6rSOCvSxUKTxu6Aqrso02u2grsgdVY9MIaf+7oWhF
	vEuAWC0u+oZgsuSGgJwNJu8/pg51+e4awVjI7QbsrmHh7MkpOUXBIQyeNakmbEikemZHvhhrUUO
	FOzGt14zfI+5Rg3Qv9pfC8PEz81pKCAxUgHFh+XVHrAMZibPMB7FIzTneQ6MN58fNCtO3m37yv2
	ApiEjkJs3fczA/COZ+ZDgEPP8b8+HnjHKN8ij7qjPj7265a9xRNBjH6hRlxsZK0yRK7icltg8Jy
	ATgaDDzKYaROXnrrqm4+d4tOStFZ88QDdCfOXIJ5ZL4if79qYo6gPAM5VIORZ1sNCxg==
X-Received: by 2002:a05:6402:454d:b0:6b6:fec8:d0a8 with SMTP id
 4fb4d7f45d1cf-6ba37ece7b4mr1180315a12.43.1795163758738; Fri, 20 Nov 2026
 00:35:58 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-13-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-13-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 16:35:45 +0800
X-Gm-Features: AclHuK-_GFG5PkAWFBgYarA_ZH8s5VuYTvaSRhCd3qxcRhatbnu155-OV8JZlEE
Message-ID: <CAN_Opa9WKYNXyuJDixgbCzW-yWYXuoBTujSA_SWeQLzQzp_26w@mail.gmail.com>
Subject: Re: [PATCH v5 13/17] mm/madvise: adapt for LRU refs based operations
 for MGLRU
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspam-User:
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8C7B9160003
X-Stat-Signature: sdykf9wkwpmd9j44rm6ueetbxcs7rerf
X-HE-Tag: 1795163760-531441
X-HE-Meta: U2FsdGVkX18YxFtvZ6/KZ0UPVzqNDiIxEx9Vu4cWiCgdVekcLkt1AosbXnw/f8VdUcB8rHO8/TYqaFrkHSaE0Gxft5SpzlbY+N6WQq/YB0UeGrlFb7YUWgxPZFQ+tcOgp7ggN2hj2jvveLOTBuRjcVXHiXUgtarFieXFmVOIwOWS6DrdgDlZlUjUdhk8kXRRNxAg4U9Jgeh+f7i1YXfdAwd+c+H6T4KfM3pWFGZPuGxGYqWkCi1W2LoiRKSHFA+ph02E/LeH1623AlU74Bh//pvnr/BFbMJQgWsA4ZMcCFiC2ivfCFEU379OhZudE9cxomviEWiLQq5wWK+f3zSz2dxjjLf+Vj70gloa0W3K4eYPS4PKCBRjKkUZJfI/CJIiDYeWIB4pa/vj8hZ9dMmyMOzrNmhD7l4xiGq+Oaui+BHhWhL8in9GgFW+ZcDByTW7MNcTQ6MRztSa9JgS5EU2jmdqii6XBRr5yY+m0erqbLSjA6jX7iOEO5Gpslop6lw6qem/la/IdgBW9etUtMexIKLItiYe2n/84+29iIKlRRgNeMPOG10mtQT7CVPbZ0iL5UQXODBWQjZD8DLEQYDHlLIgngYJbO3vqfxv13YcAb9ipwvDyxICP8n+yD0s8J+m/RJAQNAxdTX64LyFt15SbqOqetBD0mLujn06+ijUxltjGi0/drEs8KRQrFvborFovKbi1vdkqjL80e89yYekUOxRz/z0iU9Zeylbegcj2FD9e6eicxknUeddZzI0VhqMPvUh7kHmLvTdJ5ZURZjpFo7xMsGIUR3Xf5zK+oigPym1dLv+cf7SDtlqIuS+0RAcfegp4zjEyt/CTbzG079AKTLXzmSGgG7P4szJCKGxxctKepdWUBbbcpnL3fHO3+CdpYmr6Seu/7UVlgWGLNJzU+evYXkuDQ5qPzWmQS3tTpeMqP9jZy8gTN5JpmKJ2efClohn/W/J8mpDbUSpQVQ
 BoAkTlBd
 aOwFmIiKdfL59efSvoly0zUMuSj35FI9VIcIY3X9Vw99oTqdxiLEvLMe5qTrNEHqS1UeI+BG7ICJyqCdpC80lnPKjWe0xB+B0PO+zK8Lpyj72SCjENvh2HHp/SYI7B4R3bymY1qqY8Km70zzdBxFFIf/1fBgk3gShKQWqClGcCt1HU6P/XDcoQCPmJd4hoD50UfIk6fDvQI6NjqyopwjZ9v1F8ABaLneO9Ap30I5GOd1/agp9QegHpJ/Ay0ICL/9WFo2Qz3szfIYe7yoPMIteG/srNXVU+AU1ykTEJFqTSE8Ws8jGkesHouzLw9bOmBfQUlPotazpZ6gznX4iZ9SSvXbZbx+UOmHCpfJE7RTnxhhhbUL2FNFbxdwJTjXSx2IY7MMl5j178cOtRew0gwKlrwm5at+Ti0mf7eE6dt2++QK6BFyQwtInKkMITFM8YDLtENp5GWFBsUYC7JHLmGNps3Ji1Yfz1PbahDP9+H/l+OCeQ9+s55EWVp0H1djlbxTgqQf6PEOrVNj3j/Uz6MHZlwjDTO0301LqL0qV/GrvD+92Vaf9b1sRyH8aiDuOU9y8fA4FYYlLunryNEl14kJSP+ktVv5/5D6OodrzHlJp7x5UDNbkut1zB3fo3J9c/TxGJakICtY+cyiRTpyiUQBKOyEP7oU4/dOcggP2QPESS/BWjTwaszKO+KepDRFjOx6xrEnRuX5XkaOz2PNOp7aveaovwrsEW8RXWp+FDX3KlG3RFPU2bLbrqgNnB2xAbPtIqAjn4X4MVxoTdy0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 5:03=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> For the active/inactive LRU, madvise clears PG_referenced so that one mor=
e
> access is not enough to reactivate a folio, and keeps PG_workingset on a
> folio demoted out of the active list so its refault is still accounted as
> a workingset refault (PSI).
>
> MGLRU keeps that history in the folio's refs count instead, which now
> lives in PG_referenced, PG_workingset and LRU_REFS_MASK, so writing to
> those bits directly corrupts the count. The two hints want different
> things:
>
> - MADV_COLD resets the count in folio_deactivate(), which also requests
>   deactivation.
> - MADV_PAGEOUT clears non-workingset refs and caps the rest at
>   LRU_REFS_WORKINGSET after isolation, before handing the folio to
>   reclaim_pages(). The hint marks the folio as cold, so the
>   eviction shadow records the capped count and does not inflate the
>   eviction/refault counters of the hot tiers that drive aging, while
>   folios at or above the workingset threshold keep their PSI
>   classification.
>
> PG_young is cleared for both LRUs as before, so the referenced walk does
> not count stale history as a recent access.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/madvise.c | 54 ++++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 40 insertions(+), 14 deletions(-)
>
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 2d54cb9863ea..7486c492f437 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -360,6 +360,42 @@ static inline int madvise_folio_pte_batch(unsigned l=
ong addr, unsigned long end,
>                                      FPB_MERGE_YOUNG_DIRTY);
>  }
>
> +static void madvise_cold_prep_folio(struct folio *folio)
> +{
> +       /*
> +        * VM couldn't reclaim the folio unless we clear PG_young.
> +        * As a side effect, idle-page tracking loses recent referenced h=
istory.
> +        */
> +       folio_test_clear_young(folio);
> +
> +       /*
> +        * For the active/inactive LRU, a folio demoted out of the active
> +        * list should have PG_workingset so its refault is still account=
ed
> +        * as a workingset refault, and the referenced bit always needs t=
o
> +        * be cleared even for inactive folios. For MGLRU, MADV_COLD clea=
rs
> +        * refs in folio_deactivate(); MADV_PAGEOUT handles refs after is=
olation.
> +        */
> +       if (!lru_gen_enabled()) {
> +               folio_clear_referenced(folio);
> +               if (folio_test_active(folio))
> +                       folio_set_workingset(folio);
> +       }
> +}
> +
> +static void madvise_pageout_prep_folio(struct folio *folio)
> +{
> +       unsigned int refs =3D folio_lru_refs(folio);
> +
> +       /*
> +        * For MGLRU, clear refs below LRU_REFS_WORKINGSET and cap
> +        * the rest at it: MADV suggests the folio is cold, so the evicti=
on shadow
> +        * should not record its hotness in the high tier counters, but
> +        * the workingset classification is preserved for PSI.
> +        */
> +       if (lru_gen_enabled())
> +               folio_set_lru_refs(folio, refs >=3D LRU_REFS_WORKINGSET ?=
 LRU_REFS_WORKINGSET : 0);
> +}
> +
>  static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
>                                 unsigned long addr, unsigned long end,
>                                 struct mm_walk *walk)
> @@ -434,12 +470,10 @@ static int madvise_cold_or_pageout_pte_range(pmd_t =
*pmd,
>                         tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
>                 }
>
> -               folio_clear_referenced(folio);
> -               folio_test_clear_young(folio);
> -               if (folio_test_active(folio))
> -                       folio_set_workingset(folio);
> +               madvise_cold_prep_folio(folio);
>                 if (pageout) {
>                         if (folio_isolate_lru(folio)) {
> +                               madvise_pageout_prep_folio(folio);
>                                 if (folio_test_unevictable(folio))
>                                         folio_putback_lru(folio);
>                                 else
> @@ -544,18 +578,10 @@ static int madvise_cold_or_pageout_pte_range(pmd_t =
*pmd,
>                         tlb_remove_tlb_entries(tlb, pte, nr, addr);
>                 }
>
> -               /*
> -                * We are deactivating a folio for accelerating reclaimin=
g.
> -                * VM couldn't reclaim the folio unless we clear PG_young=
.
> -                * As a side effect, it makes confuse idle-page tracking
> -                * because they will miss recent referenced history.
> -                */
> -               folio_clear_referenced(folio);
> -               folio_test_clear_young(folio);
> -               if (folio_test_active(folio))
> -                       folio_set_workingset(folio);
> +               madvise_cold_prep_folio(folio);
>                 if (pageout) {
>                         if (folio_isolate_lru(folio)) {
> +                               madvise_pageout_prep_folio(folio);
>                                 if (folio_test_unevictable(folio))
>                                         folio_putback_lru(folio);
>                                 else
>
> --
> 2.56.1
>
>

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

