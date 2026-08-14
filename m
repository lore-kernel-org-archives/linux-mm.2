Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B580C5CFCF
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 05:25:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50B8F6B0617; Fri, 14 Aug 2026 01:25:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C3A76B0619; Fri, 14 Aug 2026 01:25:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B3306B061A; Fri, 14 Aug 2026 01:25:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1260F6B0617
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 01:25:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 094E140334
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 05:25:35 +0000 (UTC)
X-FDA: 85098737430.08.0F3496A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 15508180002
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 05:25:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tg7Y3Bn+;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786685133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aEi20CfO0lLOWd/hYVkbrtdPtbquzEsFzkK6Q2Nujng=;
	b=FvE8YHMWoV0bX3NRKWsGx58svNpXTilUviQAVpNX/8ff5XplU2ZsXlXVIfiJ4u49DuZu67
	dMVDdzurEadmv/ZLi1EFjF+I2ZVUIjtmLY5K7Dv+XUf4lqsQv7zJN3HvBJE2IvndKSFAss
	UmUvd6XrE8/pKR9YI+8d0vqQKhdcPzI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786685133;
	b=sit2Voegnyu5W+dcf+GV/HP+trbyWHA6uqcoB2NIWP8URRQTWoODpHdPBYAxlzpf6F9qH+
	hH8tfpNbohhLpPwcwoOsoz8G/1GVqWKn3mCgBoJWDnCT6c4Ss0P0qvAur4FJCr3KqhqMq0
	jsog5HbvXmnwVEDecOTvSXSroMNT/wA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tg7Y3Bn+;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 23BC94501C
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 05:25:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2A71F01559
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 05:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786685132;
	bh=aEi20CfO0lLOWd/hYVkbrtdPtbquzEsFzkK6Q2Nujng=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Tg7Y3Bn+KKlws+1NmvQ1+3zc2COjtsCO7NGd/e+KV1FikHVcPn8a8UoJ06O7ZBUks
	 U1JrBdVGUVXcJMyfpGQR9cqO5ZWkZWK7iSQWEnwBxNV/AZU8WMbW+vZ0BiKnsL/jXT
	 BLL8SBpCWyOWGd2YJZuV6PFXpIc/O9fZepVfMzqJusxR5TS1KvuP1jnAU7d6bfHMO3
	 2Fv3cAGJ9b5Xlgn29gc1NY/69JpwFScRKFlNxkJQ+BAuKStoln7k4Ngp0aDYHDm2IU
	 WdEjYI0RFjY9Us24hbFLRJyDQZ5ec2KLgUIq6tt0rmFpUByZJiMs17AZLhdz9Wql/G
	 wrs2TrfzlNrGQ==
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-9087fb771d3so3007456d6.0
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 22:25:32 -0700 (PDT)
X-Gm-Message-State: AOJu0YyljpTF512siRf5gAVFsSgfJYJ/OrUjzPnow0VL1rDMzVf1XP7A
	uATb3sFlkzKoon9YgdJPnYJyZiIBIQjR/BKBJBgqRRmsyFUDF+Go1c8ADptSkhNPRxKEW2nn74s
	mG04VDXxQrnqp/dZ1IAYuwwxo8RoQ1LE=
X-Received: by 2002:a05:6214:29c9:b0:908:949c:43a6 with SMTP id
 6a1803df08f44-90a91c69872mr34202666d6.6.1786685130856; Thu, 13 Aug 2026
 22:25:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com> <20260804-mglru-fg-v1-6-4d8dad39dad6@tencent.com>
In-Reply-To: <20260804-mglru-fg-v1-6-4d8dad39dad6@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 14 Aug 2026 13:25:19 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yBJVpHO09HNP7cRyt4NH0AX77Sz0W4ppdQcc9fY1bAZw@mail.gmail.com>
X-Gm-Features: AUfX_mzzMnQvgdbCstK5LkjY-xQ2Fpe4ooBRcNIV_EVsm8U_SmnPBE1-TTPmflA
Message-ID: <CAGsJ_4yBJVpHO09HNP7cRyt4NH0AX77Sz0W4ppdQcc9fY1bAZw@mail.gmail.com>
Subject: Re: [PATCH RFC 06/15] mm/mglru: use explicit tier range in read_ctrl_pos()
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 8zj943msreztyea6bx8oxguwij1r9j1s
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 15508180002
X-HE-Tag: 1786685132-497992
X-HE-Meta: U2FsdGVkX181QHZUBOIs5ZBxd9allyzzQSXxL7kuLbFyascy753gLv6xRZwMAIABW6cO4cQ0T1ShhvR2PzzhXYO1ykSUfZV3TXsSxoynhA3Nn7a1z5jINFRv+cgUtvQXqVg7YSxEmiN1XYFvzDxnK0cMvRNyBCat7w6rKAHUkmWBfkre8SRbCucK8GHvX1/TvcCHZrIZdIBCpxX96eQC8ZuSUbQpeeNCTwaP3j4fl8ThxZOZk227bwrnV8ZN7hQfqjwxAISddTCJlvedxnEpX/geMXZV2oeNclpT8kbIm2xNWYzSPZctEzxQU3IPP/sjSvXC/tqrZtpxNHii7LmLxVbGyyx1DE1BD/K3HyS7F4uOr4/KFH4BXFi/Hz8KwG1t60sQg1Zh89jZZVrDHCh68ckkRIC4FYJ75+uqASNiYXtej7RMhGA7gOSUTzujApILiTgxw4lJIStdNy/VuJBwnpEkfvqgyDhGCTLcyjIR+aVfWPYXlwI+71/8h4uDZSalW3Pxir9Ocv4YiDwli70yzV4GTSqkzraiUpGmj0psdWVxNjh4hXuZ5ZYI0OhWOWGL9DXR/x3SABAMpo9vOUNq4mOCrzAdrqU1kQu7BU57gC86X8EgYeVW72I/m4ZhwEkbShttTNgORLWOBdmNmhbBiFDdGFoaJAY8Zz24dBnf3oue1YhOPu3e4ghMbsmqt94qaONOj5lRrhdNnBhSCQp/GD57QiET628EciGdzwBcyt5NoeRhcrwhNij+2gjP3uQKpKaCWK+eG5CTkWd2JuxARdlKjCEOkuiiNf6oQixiB8VvnqLUu13sKZYBZoC5+ivrdOEJGWotqVX72cjfYI6xNDZePp0GdCP12uxf1niCe18PvmmT2BjZ6bFI1QAZIJ++ZDexfScZzLy3qEN4VHLysZ2X2gc3pJ3JTgkRP5pWKZa5iP0ZcrVc4SZ/tq/CEoUFdtgghCuF6qGn+EhRZZS
 NEFMP8Ka
 cQj0Z7PIHmfTUBb+NHnd6EOyH+LgfPpM4DX+mpn4aD8HZCMo9OTTzrPs+o2k95Gpo5o6KzRfgNYDdCH/ooJdGwiheDpDyL9MIa+oNVrXX1ka387AOCefZ6isqZGDBnOHieeO/E2fqe7TDbYHhHg/70cf24KEZIwaRzjHTBG1/Tuq8V1B4/NVZhNpx25CoXRCk+MxCg+WJnlpCo+f/hhljaAeFO1TsHIqzgNO2AoGfClza+5t94Zrmrkkadv9wIlYQqSPH3+9UOTa+9Zancoz++sgBvM9ajfTTGUlyuUnv9s72XF9H7gOHm3FQfJL03L0By32qCL7E9uWoS1Xggf8RoeIfbtnXyoi0n3hQ3DMH7+yLQBowVxnaBSRbrFSJ077YEMQi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 4, 2026 at 3:47=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> read_ctrl_pos() encodes the tier range in a single "tier" parameter
> via "tier % MAX_NR_TIERS" as the start and "min(tier, MAX_NR_TIERS-1)"
> as the end.  This is hard to follow or maintain or extend. Tier
> values 0..3 select a single tier, while tier =3D=3D MAX_NR_TIERS selects
> the full range.
>
> Replace it with explicit (tier_min, tier_max) parameters using a
> half-open [tier_min, tier_max) interval, which is the conventional C
> idiom.  The call sites become self-documenting:
>
>   - get_tier_idx:   (0, 1) for tier 0, (tier, tier+1) for each tier
>   - get_type_to_scan: (0, MAX_NR_TIERS) for the full range

I agree, this is a nice cleanup. The existing code is really hard to
read. The magic is in i =3D tier % MAX_NR_TIERS, but I've been bitten
by this magic a couple of times.

But could we make the range inclusive? Right now, it still feels a bit
difficult to follow.

Since tier_min and tier_max are tier indices rather than a typical
array range, would an inclusive [tier_min, tier_max] range be easier
to read here? In particular, tier, tier + 1 at the call sites still
requires the reader to know that tier_max is exclusive.

>
> No functional change.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/vmscan.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c2ea92c2b69e..a359d5a1ff41 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3192,8 +3192,8 @@ struct ctrl_pos {
>         int gain;
>  };
>
> -static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int=
 gain,
> -                         struct ctrl_pos *pos)
> +static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier_min,
> +                         int tier_max, int gain, struct ctrl_pos *pos)
>  {
>         int i;
>         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> @@ -3202,7 +3202,7 @@ static void read_ctrl_pos(struct lruvec *lruvec, in=
t type, int tier, int gain,
>         pos->gain =3D gain;
>         pos->refaulted =3D pos->total =3D 0;
>
> -       for (i =3D tier % MAX_NR_TIERS; i <=3D min(tier, MAX_NR_TIERS - 1=
); i++) {
> +       for (i =3D tier_min; i < tier_max; i++) {
>                 pos->refaulted +=3D lrugen->avg_refaulted[type][i] +
>                                   atomic_long_read(&lrugen->refaulted[his=
t][type][i]);
>                 pos->total +=3D lrugen->avg_total[type][i] +
> @@ -4805,9 +4805,9 @@ static int get_tier_idx(struct lruvec *lruvec, int =
type)
>          * This value is chosen because any other tier would have at leas=
t twice
>          * as many refaults as the first tier.
>          */
> -       read_ctrl_pos(lruvec, type, 0, 2, &sp);
> +       read_ctrl_pos(lruvec, type, 0, 1, 2, &sp);

It's still a bit of a headache when three integers are put together.
Could we somehow make the 0 more self-explanatory, such as using
TIER_MIN or a named constant?

>         for (tier =3D 1; tier < MAX_NR_TIERS; tier++) {
> -               read_ctrl_pos(lruvec, type, tier, 3, &pv);
> +               read_ctrl_pos(lruvec, type, tier, tier + 1, 3, &pv);
>                 if (!positive_ctrl_err(&sp, &pv))
>                         break;
>         }
> @@ -4828,8 +4828,8 @@ static int get_type_to_scan(struct lruvec *lruvec, =
int swappiness)
>          * Compare the sum of all tiers of anon with that of file to dete=
rmine
>          * which type to scan.
>          */
> -       read_ctrl_pos(lruvec, LRU_GEN_ANON, MAX_NR_TIERS, swappiness, &sp=
);
> -       read_ctrl_pos(lruvec, LRU_GEN_FILE, MAX_NR_TIERS, MAX_SWAPPINESS =
- swappiness, &pv);
> +       read_ctrl_pos(lruvec, LRU_GEN_ANON, 0, MAX_NR_TIERS, swappiness, =
&sp);
> +       read_ctrl_pos(lruvec, LRU_GEN_FILE, 0, MAX_NR_TIERS, MAX_SWAPPINE=
SS - swappiness, &pv);
>

Maybe we could introduce macros such as TIER_MIN and TIER_MAX to
make the intent clearer?

#define TIER_MIN 0
#define TIER_MAX (MAX_NR_TIERS - 1)

Best Regards
Barry

