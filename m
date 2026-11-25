Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 216EC606A329
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Xo45TTOJ
Received: by kanga.kvack.org (Postfix)
	id 400B46B0985; Wed, 25 Nov 2026 05:07:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B14F6B0987; Wed, 25 Nov 2026 05:07:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29E386B0988; Wed, 25 Nov 2026 05:07:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F15B56B0985
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:07:22 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8868B160DA8
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:07:22 +0000 (UTC)
X-FDA: 85473213924.17.986B555
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id C4FE7A000B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:07:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Xo45TTOJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795601240;
	b=BbQxiLrrcx0v8u+DAcbjzfGoNYoCa2iq4/8EduD2u/jfg1KYAS7+RMyI50Zo3YKM6Lthd2
	kgptaWRLRyIMZW1FOmRRu17bTHp/FcLwIgJ/ExAS9dG7ydy6gSDAA1vWkAZe4eeTtaZhNA
	2JALhGVb4sF9q5fxcUTbl8jRy3YvwgY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795601240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mWx4O9IoqBZXrSxXrPMmLZ9d1NpcNUKfMxyf4VNB2/k=;
	b=1yEQZ6M4bVY+ylZX9Lg3ZkEs9874FKG4g0xdO7xYufYf8E93MNKa9P77z5pQH+L4qDLPL/
	qqyOadkOQiqkEHhScU2PYJ+W16JH2levYtZCj1FjSTCwVY+eCuKFnsTBda2dYDNhG2GFIQ
	m0NoVMRyn4p0ua5Qfr46myKU2sUmcwo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Xo45TTOJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cde0daf3a2aso2375439a12.3
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 02:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795601239; x=1796206039; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mWx4O9IoqBZXrSxXrPMmLZ9d1NpcNUKfMxyf4VNB2/k=;
        b=Xo45TTOJ29quMGhIX6UsneQcD18C33KVA5CiRmRCn9rjwPjFrbtKehkegVvdpEpNqs
         mF7T++e+nBxrB4f/9Fl+bS6FT6Js3xni0AeRRzkZSOxN3/+a8Im3kjQ86QWFJ2Cweco5
         CpMDbtG2lEp6KOHmH7t7c6hCRhAwC+0JCtBGGSVaGuPQ+ad1ZdOPZVCjmC+uSUneXFNN
         X+/d7MhG6RRMWYp1CGcoUEYlmOxJhFPFvJuel4Iw0JblCxFSs9m2xelcJt5mO006nYZ9
         Lk2yRmTt2V2efn6Tyei0fZ0/AiSyprDpUoo1xhxYMhKy0PMWFcMxCUu2iVSVCPl567TP
         a8OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795601239; x=1796206039;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mWx4O9IoqBZXrSxXrPMmLZ9d1NpcNUKfMxyf4VNB2/k=;
        b=w2u3TU2jFbXoJ5afcIAsCJBhr1ZVhqr2gvwkrX2iTbuklLPlpyCbJJz18YJHa68sD4
         5Rf1kyV4ltEri4iizmoDQIDtReEZrnDtTZv3g7gtvDoYdqv3yvmle+BOhnf9ZFjVFZB2
         b5cHf1MPZTkmUIDwi6OvYv7J5HYYEH3f2pB85CjAJLeXhL3M/cvymVjMxMlRa/SekDRH
         Xlfc+8BERHH0iG0zPwdI3rx3sINuofcwD11Fas0zNisykFE6hj/WTbsEZw1IKJ29JWz8
         BonuXRe2jKjoH4Bkp6ZqSkmwG+Hehs/S1GDY37NixKdfBY3NPlIM5Q/tlc7bRgL2ikwh
         zQhQ==
X-Gm-Message-State: APuU4Z+VoHvteL5aRwPP409rsGgtYX5wfrU/WSH2kkGo3WW6xXRvetmf
	TKCjiuIActo5ac8O0k4D0sZCI2c1KnqTazMWh1GUxR8wNLghgMzYpIqa
X-Gm-Gg: AZFdTZfroxDrEI62tzcGmL54unC6M9TE2CjV2Ad4o2m4JYaOF/YGRtjk2K4FhX/qHkO
	VJ3vAszeWPFujjUxsftc7WodORgMcSRpt8nWW6ArWubCmqHh3Ulonj3AI1xLVO2fm/W0UAgWHpE
	7JySmON7PPZJyy1wQpx3i7NRhvtir11YmKp33vhQQ52ah3GJRH3SmSOesXraXOIyZ1r9dznf4U6
	h3KFLN+NlbZoKK2UtS3mc5tS3COjGzDuiqP+B9Z4sTlHbm2fhPjPFnuZAiz6lUPWSjigJyFdQNq
	HQ9hAy8vyWCdUo7cWqvFEWQQz/1rRd8KHGboH7dMSjXC+78BIsnDPWWK+zMgAlM7XD02YrEPu31
	Tt8z0T2iJf0q/NdBNtNUaIbHWaLGfBtaCarQAJq7rMgEgW3z3L0hWCK3yo+FAxt3B64FbnpBAcw
	BgFphpagW+yoE91Gn6XfId6URF36N8uxsumQrc6+Sj8++ayuH0S9cCWpU/9fczJdotCqc6/dXOb
	ZKz+2DKd1KAIG1GtkV9Rr+zoZLlzkj2KZf7VCE45CJ4TqBFsKayX/gnbW/zssgJ+rcMj7S3PDDN
	zkUGrFtF2wouVzSC+c/XqTWavX69oBP70ljv6fT/d8n5
X-Received: by 2002:a17:90b:2ecb:b0:3b0:e2a9:3466 with SMTP id 98e67ed59e1d1-3b41c98a1d1mr14557905a91.16.1795601239179;
        Wed, 25 Nov 2026 02:07:19 -0800 (PST)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad0b2c4sm26804572a91.4.2026.11.25.02.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 02:07:18 -0800 (PST)
Date: Wed, 25 Nov 2026 18:07:00 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Hugh Dickins <hughd@google.com>, SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
	Yu Zhao <yuzhao@google.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
	Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org, Tianyi Chen <hi@tychen.cc>, 
	Ridong Chen <ridong.chen@linux.dev>
Subject: Re: [PATCH v6 06/18] mm/mglru: skip the flags cmpxchg when nothing
 changes
Message-ID: <627ebddc-87b8-468b-b0c3-0503494f357d@gmail.com>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-6-8ffea39934a6@tencent.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124-mglru-fg-v6-6-8ffea39934a6@tencent.com>
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: cih4o9cezqs6tnbkzndfxeqhsudz3jez
X-Rspamd-Queue-Id: C4FE7A000B
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795601240-701696
X-HE-Meta: U2FsdGVkX1/3YDRmQqCbMopLH6U+GFizvk8oVDYIqQszElUMlKMWVS9bgWECEUt+eqZxPkFax/vXptdT5/hSpAv4kuvLOa6NMrwr0MpRblDzVpqFDiNlQDFuy/syiblBzcGz7c9c0tDt0MuTN5tgLf/1CJW1bho08swgoEGCpt9ZyrwSX+OY+X3dIg6ws9w+21ZK3uuwW9sqM2/3eAm4hv9/wAAjIi83b4x9WRqTSu4Zkzi0ZZWlqYSDNX/912suxK5ndVGuEHj5+dmNEPP/8bQ1EgY/jP1r+jfGRPFLW64f2g3TjOKLbhvjZU9cXQVEeeQaA4lZxHlIe7OZdh9F8fdGyKayfqA0AC5Bo3akhSAFRqR3mXZvInBSB0OqVEfOA88C2IOv2GQEBLsdCCBnjwbBaEeI1gA+1Isv3ierthRzpQvCdMiOn4oyMXYbHcE/F3gtQ5JEqFgxVTn+q+8LfgAHOJdvDo0kZlPSjRi0qhFa41/7fdJTwpqXwoez7zri5BefTEKKlbp7oc9MMN0S81Yk6KoyPX41wqp3BFOjkEVyzbHIOrWQs1EGyEmKI+Z1IDwmIxsAfm8jYleV1B6BP7lW1rgdToT6dxK3Mk6bn5Y6AxABjpB8POl/b7pHAZJpdmZLQovruqdA6ZE5kuZgq7W8u9OfJhsNgKPYD7aKnqWCoIqMHMYGKnnqkzLBST/KCi1El3ptsGz+OmVCY3xoM8UeZx4uwxdyFdb/75a25GKqIA/ekzKshenve1t3Iz5x5quLdSywwF5uLe18xLqt+HFLN9CFrvuliC2fA1FR2yenVi6P5RecXUSO2CfbdYlVHhxcTNp+Eh/YcpEtoYoNmOW576uFz5hpLw7lGXxbHgOwzx5mPY7VbNhNn1BLpIdDwExKIlBEVXZ4EMVMQEEu5blsLa4ol1Y7f94W5hG4akInvz18llPWcIJQuON1jt3d9K7jSupuyEJ8u90aQey
 QgfyC5K6
 nUypFxnHjfjnfJvRbotGQCEd7JTRBEsFu/e9afOJlX1xxGI8KemsDGmSnNEz4iyaxzFLxCPS7GrrJvy5wnht6bmZDDr6GbIPc1mJKfq539jQtfoiB5aPo03IYqvltGrq+SpoVP3N/YZTF9tPhbE+dgcRNG0JTerR9UeZx6spK1dHCekOCxfh9in8F6fcNM4OAZkfxylPY2vpiwOV6bylBowdBfa5m5rQjodIm9U8uBja/0u3flCivpacPSTz4ucCM2tfg3WsqadM6mc1fqwlYWToFOyOR1Gj7mQI9kYaOdbK50KzXUU+yC0X+Sm85ICsZ/Jwf/rZptQnummtOIH0znspD3rgHEzPxlmBLYQLXj29IhIBEKWXb9iuiE2eIjRqaFiimgK0hfixfrEfz0Mb4WFsjs/+YM/VPbfMfRUvseciXkaM48utSLUuBjVmF9Fo4kQ6Iipa2vlw1xUZx/HRqTTx/mwJwB6nK9bCteFfdB0YdBOsjrB0clCgRMOk2Q5PvMKO7gpsZk+yFH8o2MYR9LUTwOa7VNo6Jly2bcRnCAzTwx2au5QfqmeuF5pPDpQ8HKTzmomve5l00PyoNFszlSsm9EQRh2tawtjTTDRkKXQ7XplMDd74eY4lrFvQEOV4YRAYXoPWRvbHoTJOQZy51drEXZpPnBpMsd+mM+TFRfGQnIDwLt/V751sjN3ypoEHlDJE+6zcnfDPG7ny6Y1KFdqv3BHmQFC4HQV49qx7yfeAgOacBFYib1aJuYq/T20EE7cFPkW3X1CXX07f9kWdgVBfEokEPU3MeLXPXepvUKqciUxWmmEjGP55a9EvTBYLTAtJkdt0TyAMeR6fRz7DCZO1GdsxV01TaQ5+LANgar6aU6gI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 02:52:58AM +0800, Kairui Song via B4 Relay wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
>
> folio_update_gen() and folio_set_lru_refs() always end with a
> try_cmpxchg() on folio->flags, even when the new value equals the old
> one. The locked instruction still takes the struct page cacheline in
> exclusive state.
>
> That is common in practice: a folio mapped by many processes is visited
> once per mm during a page table walk, and after the first visit it is
> already in the youngest generation with refs cleared and PG_workingset
> set. isolate_folio() and the eviction paths also call
> folio_set_lru_refs(folio, 0) on folios whose refs are already zero.
>
> Break out of the loop when the flags would not change. The update is
> complete at the point of that read: the flags already hold the target
> value, and a concurrent change to them is ordered after it. When the
> cmpxchg would have succeeded, the value written is the same, so no new
> state becomes reachable.
>
> What the patch drops is the retry. A retry re-reads the flags and
> recomputes new_flags from the newer value, so it overwrites a concurrent
> update with what this CPU wanted. For folio_update_gen(), a walker that
> read an older max_seq can lose the cmpxchg against a promotion done by
> another CPU, and then write its older generation back on the retry.
> folio_set_lru_refs() can likewise clear a refs increment that raced with
> it. Breaking out keeps the newer state.
>
> No caller relies on the full barrier that the locked instruction
> implied on the skipped path: the eviction and isolation callers run
> under the LRU lock, and the others (page table walks,
> folio_mark_accessed(), lru_gen_clear_refs()) only care about the
> resulting flags value, which is already in place. Note that
> lru_gen_inc_refs() already returns without any atomic when refs is at
> LRU_REFS_MAX and the folio is in the workingset.
>
> Tested on an i7-13700HX with turbo disabled and the performance
> governor. N processes map the same 2GiB tmpfs file (huge=never) and
> read every page, then one aging pass is triggered on their memcg
> through /sys/kernel/debug/lru_gen ("+ <memcg_id> 0 <max_seq> 200 1").
> Time per aging pass in ms, median of 5 runs of 10 passes each, averaged
> over 2 boots of each kernel:
>
>   processes    base   patched
>           1    32.9      31.7   -3.5%
>           8   195.1     160.2  -17.9%
>          32   755.8     592.2  -21.7%
>          64  1597.2    1260.6  -21.1%
>
> With one process, every visit changes the generation, so there is
> nothing to skip. Before the patch, perf annotate attributes 53-58% of
> the walk_update_folio() samples to the lock cmpxchg in the inlined
> folio_update_gen() in this test.
>
> Reviewed-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> [kasong: adapted and rebased for the series]
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h | 2 ++
>  mm/vmscan.c               | 2 ++
>  2 files changed, 4 insertions(+)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 46beded51c7d..2571b3f01226 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -233,6 +233,8 @@ static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
>  	do {
>  		new_flags = old_flags;
>  		lru_set_refs_flags(&new_flags, refs);
> +		if (new_flags == old_flags)
> +			break;
>  	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
>  }
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 202e0f874b23..15df5618a3cf 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3274,6 +3274,8 @@ static int folio_update_gen(struct folio *folio, int new_gen, int *type,
>  		lru_set_gen_flags(&new_flags, new_gen);
>  		lru_set_refs_flags(&new_flags, 0);
>  		new_flags |= BIT(PG_workingset);
> +		if (new_flags == old_flags)
> +			break;
>  	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
>
>  	*type = folio_flags_is_file_lru(&old_flags);
>
> --
> 2.56.1
>
>
>

I have done similar tests before, simply skipping the identical old/new
flags, and was able to get very good results.

Makes sense to me.

Reviewed-by: Vernon Yang <vernon2gm@gmail.com>

--
Cheers,
Vernon

