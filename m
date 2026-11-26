Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34A32606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 00:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kd8bwvTP
Received: by kanga.kvack.org (Postfix)
	id 0CD9C6B0B39; Wed, 25 Nov 2026 19:02:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07E346B0B3B; Wed, 25 Nov 2026 19:02:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED7356B0B3C; Wed, 25 Nov 2026 19:02:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD4646B0B39
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 19:02:50 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D6F621C4852
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 00:02:49 +0000 (UTC)
X-FDA: 85475319258.09.E8CF099
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id E173B4000C
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 00:02:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kd8bwvTP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795651368;
	b=SeNzmHia1JLhVNfx9Ny8tGSgiAEpNCxGCPZyZwzlJeEwH4baBQwcvwhLs5YLhCDHbyhYTc
	ONcpTL+7/kL2zCHInNfghMjZj4Zi/mTFzAfy4Qu5mWa049cIiKNM5YqkJhF9JQRRl+/u3c
	NSn3goDfUdbNtlHUxJyxiFiuHBmc4G0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795651368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tcwa7oSwkR6rhVMA7ANLuMhBmg6st+DnbbP3HYnCy/g=;
	b=FwJK/oD6EO+tbb/C2w0qanhNs/Ga7+oCFpa90coswfRcSfyGa8L7EziiwUoTSVMM9v7MvW
	x2dhZyidxCGP1iZ3dB0oE6dWLUBU6esJ6aoFeqETKn22onjDwyOBkuHTobWtD9YgavRzM8
	toDVqwET5EpCBycNe5RmYk1UFwIaipw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kd8bwvTP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 15E634644B
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 00:02:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66E61F000E0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 00:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795651366;
	bh=Tcwa7oSwkR6rhVMA7ANLuMhBmg6st+DnbbP3HYnCy/g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Kd8bwvTPi3hcp+5AsuAjyVt4eqqShElqqUQVGchY8tZss4SlithMSjQ7cHE4GzuPy
	 Rml6sOIbjQye6MKgGmaSpHTIbsDXP9CeSKWM1XUcVcdvtaI6SHUTZsinmHhmTlmv6a
	 47MAJF5FP/lKniAGyr5TSpkT8Ixp1DaEndS6PlyqW2bVazZaTXnrxX/Qc5cyWWpB3e
	 0HuaaqfKx3xV4EVJCoHJM9tgpOIzKbBDeX/e6ikY8nJ74tsZNqJC8U9opsI95buA2R
	 SFgN80EJmv18JjdGFac6y0wduNXt7iJWXiOgqpZ96ZVBe0hFCG7ZGIsw8sflJ1wDZX
	 UkhyCxx2/QYow==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-9495d543c42so646181585a.3
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:02:46 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErE4sxaCUDQMMjsJ3RG6JlW5ZLKz6QdNJeilwrphXm8ouX+14jogLvrzRCwec4GvaQG+1rYvstuvBw==@kvack.org
X-Gm-Message-State: APuU4Z+1XOiuKA1MmVkoLDS7x6CmMeY1KByPv2XF/N5kTghHXDTDrsui
	1E2BHF99rkkWJU8Q5+M8aQGD6JXFqiKtM9Jir95A/7QqZ/fQxposdlbcAQ7k4tJBZtdetpZMckw
	eQjXyyMuLn1UJ4JPUXvnW+fybq46Dicg=
X-Received: by 2002:a05:620a:40c1:b0:949:5708:3cb1 with SMTP id
 af79cd13be357-949ba67d397mr3393956385a.0.1795651366131; Wed, 25 Nov 2026
 16:02:46 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261125094056.3973331-1-ridong.chen@linux.dev> <20261125094056.3973331-3-ridong.chen@linux.dev>
In-Reply-To: <20261125094056.3973331-3-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Thu, 26 Nov 2026 08:02:34 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wScDHmPin2H+Va7SFZ1zwa4XcYMghkreMMyO+RK5W4gw@mail.gmail.com>
X-Gm-Features: Aa3M54rjVXBw5jT1q0ibH5p4o-dn5JrDJUoQpWeom5vFVNY4G18YZ2cvYgMlzfc
Message-ID: <CAGsJ_4wScDHmPin2H+Va7SFZ1zwa4XcYMghkreMMyO+RK5W4gw@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] mm/mglru: deactivate anon folios into the oldest generation
To: Ridong Chen <ridong.chen@linux.dev>
Cc: David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Yu Zhao <yuzhao@google.com>, linux-mm@kvack.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E173B4000C
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: j3yygwrbmauqq5g67izt6y58reuscbc9
X-HE-Tag: 1795651367-794682
X-HE-Meta: U2FsdGVkX19b4CUAmvYb9qDKNh3wKhAGMv9EmRNb0SeqwCBPkEUsrFCCtqdxwNhjgZ3/NbN0/93zlJFrYjoCDzItcYmCWbsOfL260KyJOoHWBrGQ1FKy4Vq3ZMH0EbC3KdPOrT+6VmAxrvLnjaVctvwnaGuIk/+gKemKaDc1tQSwG2cOn6RxlPJlmp7mPk8Xlh+4+yln9nDJ8GQajrRovL/37wasduFEmEqOEU8dV9QtvBwfgcltnFozi2SEpx4IRWTpLAmN9jX6m+pTBPXSSsKCuzmWU/eAbBVpso0jU9PQGkFWMEzNB6/vO5bkXp7iG1NAbYiEULatPMG4qi4w55bz9aSOoFQHpkhymXuksTZ/PBLEoMpbpPOUbeZ/ou/pC8qG4qFq+e9AhD5thp8iN2gRTHvZ1/ROnYnYT/R1V9m1sfgFgrfwHiKBENqjxsZGzoEUojlhgp9XqdtTeypulU2/3lLLWheDPiXUc8b7OrJjd9ndc+V5m72DTkzy7Eb7tgIzqrjVfRSlgdZtuNxC+ZaqcU/i/yNLxZQzlAYhOMNuWmimlJKStQC1uExmEz4oZrAtjIc06RwDn78MJz5U2bxPMTpPRUS84NR9wvPbbsM/Q1R648SNwghRJd7AUVA7suhLrNmStuhWAFVO5kvOwKdsyXFxldSYIxmLnoXp03xwKR0gXASl7+cMIohXGDiNnMzj78xEy76NIboLTjynREiP6ku2OC1L7XojVCb/M/d/ONfpemO5KvT7UrBxcDW5rp0ptu1eZIsGfS6mokkKlBack7U4pRgBZXks/nc64KLAAVBVT+sf3Hl2i/ZpGudWj33Mdlk2FHRHe891aendCnCUEuGW/dPtY2tbe2snKDvSz35TJN4EEM5dN55VvWiHY1eNVL+rr15m6J0hpwmqCY7NCXBGtcRj1Qc4UYEV3gFprZ5540iJYsVkyO2IAogyND21KHEVn+zqdJjug8s
 mmvZBxNU
 HprwN8pfsvkS4EHyiJgjUKUDx5enldaerMWGHDjO5hlapCum8KjfyRk/RUwpeu9XxeMfH3tob3nEwqZ0s8PSMKVibuGeTLxxc4jkn6hWJt4Kf+342R+4EAhvcAuOSQCi9fkeIXkFCn/ILzKEXkotgQEJHLLSUi5WLngdhfV9H8EELyO13mFC80sABrNNXNPtj0dCOQ9TDfpsCSlj5zzit6j/feessssnxLeMJVjtevOU+vwgl/UQjHpEpSbRbNCx+Ivb4ACSSPe66y84XALxhxC6TgMSvZzXzmb3gBZDg3Nsu4xq22MJh2sCe0kDGu4iWAwoX/0lacUUKowdHugwYi9hpG3wo/8PZUnb9tElYa11d/5Ka6DuhgYbKVKnw21qk0yO6rw/CMoIeg/W79j6NCy3ZymSbRoFE6HUxUisjRhAJz5jaIElF77wkx6/3NNguJTPqV1sL+8si0jdUfWIeg8ro35MWf1OLZ6F6l3opDzWP0DOFxG0btj6BC3nMqZRNSVdDWVdOw9MdAixnw38My5PLVotJ5Miq57mPB5ijjCl2ETgEC0XuY6VspA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 5:41=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> folio_deactivate() is used by MADV_COLD and DAMOS_LRU_DEPRIO to move a
> folio towards eviction. lru_deactivate() does that by deleting the folio
> from its LRU list, clearing PG_active and PG_referenced, and adding it
> back with lruvec_add_folio().
>
> With MGLRU, lru_gen_folio_seq() places a swap-backed folio that is not
> in the swap cache, i.e. an anon or shmem folio, into max_seq - 1,
> regardless of its refs. So a folio that has aged into an older
> generation, e.g. min_seq + 1, is moved to a younger generation instead,
> while PGDEACTIVATE is still counted. Other folios are placed into the
> oldest generation with their refs cleared, except the ones that have
> PG_reclaim set and are dirty or under writeback, which also go to
> max_seq - 1.
>
> As a result, MADV_COLD can make anon memory less likely to be reclaimed.
> It can be reproduced with a single process in a memcg with swap enabled:
>
>   1) map two 64MB anon regions A and B, and fault in A;
>   2) age the memcg once through /sys/kernel/debug/lru_gen, then fault
>      in B, so that B is one generation younger than A;
>   3) apply MADV_COLD to B only, A is the control;
>   4) reclaim the size of one region from anon only:
>      echo "64M swappiness=3Dmax" > memory.reclaim;
>   5) count the swapped out pages of A and B from /proc/self/pagemap.
>
> B is expected to be swapped out instead of A. Before this patch, B stays
> in its generation after MADV_COLD, and after it, B is moved to min_seq.
> Three runs on mm-new:
>
>                      A swapped out        B (MADV_COLD) swapped out
>   before             16384 pages          63 ~ 150 pages
>   after              58 ~ 78 pages        16384 pages
>
> Cap the generation to min_seq[type] for MGLRU, so that the folio is
> added to the head of the oldest generation. This matches the classic
> LRU, which adds a deactivated folio to the head of the inactive list,
> and is where most file folios already go. Folios that have PG_reclaim
> set and are dirty or under writeback are now placed there too, as the
> classic LRU puts them on the inactive list. min_seq only advances under
> the LRU lock, which is held here.
>
> Fixes: 081488051d28 ("mm/mglru: fix underprotected page cache")
> Suggested-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>

With a few minor nits.

Reviewed-by: Barry Song <baohua@kernel.org>

> ---
>  mm/folio.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
>
> diff --git a/mm/folio.c b/mm/folio.c
> index 7521680874c5..0220419612ff 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -525,6 +525,23 @@ static void lru_deactivate_file(struct lruvec *lruve=
c, struct folio *folio)
>         }
>  }
>
> +#ifdef CONFIG_LRU_GEN
> +/* with MGLRU, add the folio to the head of the oldest generation */
> +static void lruvec_add_deactivated_folio(struct lruvec *lruvec, struct f=
olio *folio)
> +{
> +       int type =3D folio_is_file_lru(folio);
> +       unsigned long seq =3D lruvec->lrugen.min_seq[type];
> +
> +       if (!lru_gen_add_folio(lruvec, folio, MIN_SEQ_UNBOUNDED, seq, fal=
se))
> +               lruvec_add_folio(lruvec, folio);
> +}
> +#else
> +static void lruvec_add_deactivated_folio(struct lruvec *lruvec, struct f=
olio *folio)
> +{
> +       lruvec_add_folio(lruvec, folio);
> +}
> +#endif

I'm not sure whether compilers will inline them, but explicitly
marking them as inline should be fine?

> +

