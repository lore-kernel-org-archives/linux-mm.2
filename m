Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C407B606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mXlCAXUS
Received: by kanga.kvack.org (Postfix)
	id 49DC16B00EF; Wed, 11 Nov 2026 17:38:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 475126B05B0; Wed, 11 Nov 2026 17:38:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B58C6B05B1; Wed, 11 Nov 2026 17:38:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 16F0A6B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:38:50 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9CD4E1A04AD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:38:49 +0000 (UTC)
X-FDA: 85424304378.05.B216EA9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id EC61B140004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:38:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mXlCAXUS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794436728;
	b=JI1nO2wgWicuZdF3UA405C8GSA3Os/JbS2tMEJPycw2c3xfYQPsWfYcTahtzW3+/OXWGEn
	f16HKkKCqyJ7gtMrkZnxiJRLSmGIJ3zqR/pTswKwtItWiormsNJ/SJVvZ5UiU+nFJogOve
	HErRaPEwbWi52ZXygee2sodUT+6ehBc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794436728;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y9IYvWkfmR72876yaDDx/YCTA0ooj1qMzOynn8MaMII=;
	b=7fFmD0ZcDB2WArLoRKmnZXZGjAY7Z6IKiylo9+un+bMq1+EOH7DBJlKXRUMsxE6I+347zx
	UDSIn49lJl54sQkmHUultq1WVYD26jiVjBH6VxD548iqM3zEqtV/ZRQuJBgoxo2eORk/4u
	q6G6MIel3RTXyEwd+GCsN12wY81g5oA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mXlCAXUS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6AE27414BC;
	Wed, 11 Nov 2026 22:38:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6727D1F00A05;
	Wed, 11 Nov 2026 22:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794436726;
	bh=Y9IYvWkfmR72876yaDDx/YCTA0ooj1qMzOynn8MaMII=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mXlCAXUSmWm8wdR0L3s/OefB0dZPh3gi5AFcBE3SaZSjN0oyklcKvGOhVib5ihKhp
	 wFIjhslyZx7Jll+sJ7xCVf5d4ccFucONcC+kWW7unTKtrduSoEaTOrCM6WCHWdUT8B
	 BtmeK7h3EKQV77NPGkBAJr0rIVExpZJRG52l0OwmFeL8AfyigXOwmpx7juaAEeJpi3
	 UrwhO1GRmpqIR4+12mB3uGIg8c9/pH1NJPj8FP3nVeYUoRIyJ8UW50I0SlJruC4GIc
	 6ag6YdkVlGtfGIWXVR6mUv6ELUmp1ng1LElv/PjFvXjyAAyE05Wr6r9hUtBF6vtj+Y
	 ajBnaqcnMl8OA==
Message-ID: <sashiko-outbox-209812@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/3] mm/hugetlb_vmemmap: fix lost HWPoison state
 during optimization
Reply-To: sashiko-reviews@lists.linux.dev
To: "Muchun Song" <songmuchun@bytedance.com>, "Oscar Salvador" <osalvador@suse.de>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Miaohe Lin" <linmiaohe@huawei.com>
Cc: "Muchun Song" <muchun.song@linux.dev>, "David Hildenbrand" <david@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Naoya Horiguchi" <nao.horiguchi@gmail.com>, "Joao
 Martins" <joao.m.martins@oracle.com>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Ingo
 Molnar" <mingo@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, linux-mm@kvack.org
In-Reply-To: <20261111093747.50048-2-songmuchun@bytedance.com>
References: <20261111093747.50048-1-songmuchun@bytedance.com>
 <20261111093747.50048-2-songmuchun@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 22:38:42 +0000
X-Rspamd-Queue-Id: EC61B140004
X-Rspamd-Server: rspam12
X-Stat-Signature: r5qs7naryjcceih7cca1rkhuq9e4r9qt
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794436727-405648
X-HE-Meta: U2FsdGVkX18y7wM9IeJHZLH1x8zSrvddPjftriR/p+EIcxoFPnJ4OwEat9vkNFcfrw7c1v64zmyxlyM5B37cnXWzGwkU8BtMDBl0DY3P4vjqD24NDR1uPaBdIl1McL4XATHCdYwKzEMC8sjEtu5BeylS+YY2SyRxJ9kTMAXopjvCFq+ae2HgQSWStzM+Xnu+NjnGa3pLild9PFZULwympHI1rD0ePwM9k+fsEGRu8Uu59U/ncc8oi/KkN1Ux9Ddm645DI1JAu0luhzJ16zS2r3KhRcpTDl11TnvFWWMDNU/zIqpxtXXQFSel/+65xvu/tdK3VyD0IGoQXsrcie4erCazjm5GOjl/BPCnc4v3xf7nyM8ih/YA02bq8HhqTeqNH4KaxJC33P2Z4uoVjVYpwsSEoDwg0tYzMUK1rNa1WQLokc4qYbBz4vAT6SCnFa1AF3xt+oob1icrDjogf4t7IsB7C2q2xp4wU8gf3oUDIYkkmTcFZQKMFxTTeD1gw8MwxLMOAFAlqCDBJOjtUy6lKn3ySMggqLyufgdgvi/L7Bv47Cltx+7WAz1tnyyjYfCGZ6D1LW0xG2i6DYsjzSq8/n3qeE2Ry/4pZDDo023DX5EWoEJBoFVaT0+HoBQngGQHSfBuPyN1x3Qq9Fm3ha8qMORWU58SMzDQ6LpssEL6ss+9JE0ahXtG4HzrKwP6NT4NK+02NpxuAXFZS0OuAgquAy7VqXej/Xg6wuA0K2aozSC/jPmI1sZZ5DGBuoIWQuQu3oIfVmdWFLvUf4whrRhjF32WAWXpwRX31JFsMct3/FML3AW8zqUzpFmpERNYnMFJZk2Zb7UnlUtctiohLsnvBvGyseE8e20lbdtZqIkAvxWan3FgNGuldtmsUxToEDFq937ODAP+usU5xXbCymD8Om6uy0oTYMbIxWrWz6ipSxb24qGoUwgCJ7AgMup4Mtvh2X04fjLSiQcEpcufG+2
 xaOg0DPo
 cLRGHI+d0zpDVJBnAZ6gZas7VfECzTiMdiHSVdvNoYwO4d0WpArclCMo2FC5x9UhG5+lvkiWCMWaVsTZ2WTDc72nfZm2fz1b3OwCMDSWbjMLqS2979WDQjlWHkocv9cxJSqIJ6eJr20S0Roy+rxDDcjBC7SjIq8hL1rwYVanDrlH2NqaJCvDxi5QbolA+0bnd9ccaRJ0zX0kmS1msPyNaMFbDVdQRkEi4SS5sYwzsSC3vi286+sQ6ErPkcMDbo+A4z0PCVir3SdL+vMTm4sChcil6As68w2+EgVYDyVWaM9Y3i7U1uCjrmKXTMn5PTBmT2k/l+XfldH97ghD0LGhuO9H12nUembNGcvGvT++YGrpLPpi1nVGypgDki85WPP611JFMytQZ/PcHMS2VTAXEkd3pOOPm2ndYvzYHWpZ/PUqxNL4GG036tI3kUr7hhchWhzlL2DPYeMB011lDrimhe6kYYbbXz/a2qNieP9/U5OscTpluwKXknTGaibqU5w09pJYIXDEChqz5XV+2GqGSUaW9XBiOMMemjFo2TFjHknWYTXtNewYMdHOI0H0NAyGd9VOOx74ZnAa/GhsKx7sv45cr7xSUH1g9rFnICj8KLN37GhVZPtmvpB//TZ5fcqk+Rzds4dbSImSrUAkjoDTmf/sts39/PDEkFZqB9LjR+YIJc8yU9iO+8ieLT480PyxqGA42BX/OOoJ4dJl5+Q5iBnp9vGd97+llfH32V+diqBsMIAYJ/EBEoVFGxaXrv08DVlrpFBtt5deAfpQiPWqLCwEz4IO0IW7j86DSnXMxPvrmbRHOASH2z1rhNrub6J914dAPRKessUJMg8inEl4dzJsIAT/pfCw5UIUeptcLfCxUa14=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm/memory-failure: unserialized unpoison_memory() races with
  HVO head remap
--

commit c0c1b7e9976626bf636152889fd9f5d88944d78b
Author: Muchun Song <muchun.song@linux.dev>

mm/hugetlb_vmemmap: fix lost HWPoison state during optimization

This commit introduces vmemmap_remap_rwsem to serialize HVO head page
remapping against HWPoison state updates in get_huge_page_for_hwpoison().

> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 78f0a13349cb3..164a02866fd59 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c

[ ... ]

> @@ -2038,6 +2039,7 @@ static int get_huge_page_for_hwpoison(unsigned long=
 pfn, int flags,
>  	bool count_increased =3D false;
>  	int ret, rc;
> =20
> +	guard(vmemmap_remap)();
>  	spin_lock_irq(&hugetlb_lock);
>  	folio =3D page_folio(page);
>  	if (!folio_test_hugetlb(folio)) {

[Severity: Medium]
Does unpoison_memory() also need vmemmap_remap_rwsem when clearing
PG_hwpoison and freeing folio->_hugetlb_hwpoison?

If a newly initialized hugetlb folio is poisoned by a software-simulated
memory failure before HVO acquires vmemmap_remap_rwsem, unpoison_memory()
can race with the head page remap:

CPU0                                CPU1
hugetlb_vmemmap_optimize_folio()
  down_read(&vmemmap_remap_rwsem)
  ...
    vmemmap_optimize_pte()
      vmemmap_dup_page_from_list(old_head, ...)
                                    unpoison_memory()
                                      get_hwpoison_page(..., MF_UNPOISON)
                                      folio_free_raw_hwp(old_head, false)
                                      folio_test_clear_hwpoison(old_head)
      set_pte_at(..., new_head)
      flush_tlb_all()
                                    /* new_head retains PG_hwpoison and
                                     * freed _hugetlb_hwpoison pointer */

In get_hwpoison_hugetlb_folio(), passing unpoison =3D=3D true takes the
folio_try_get(folio) branch even when !folio_test_hugetlb_migratable(folio),
returning 0 on the frozen folio instead of -EBUSY:

mm/hugetlb.c:get_hwpoison_hugetlb_folio() {
    ...
		if (folio_test_hugetlb_freed(folio))
			ret =3D 0;
		else if (folio_test_hugetlb_migratable(folio) || unpoison)
			ret =3D folio_try_get(folio);
		else
			ret =3D -EBUSY;
    ...
}

unpoison_memory() then sees ghp =3D=3D 0 and calls folio_free_raw_hwp(folio,
false), which skips the folio_test_hugetlb_vmemmap_optimized(folio) check
used when move_flag is true and frees the struct raw_hwp_page entries from
old_head.  Once CPU0 installs new_head and flushes the TLB, the folio still
has PG_hwpoison set and folio->_hugetlb_hwpoison pointing to freed memory,
leading to a use-after-free or double free when the list is later walked or
freed.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111093747.5004=
8-1-songmuchun@bytedance.com?part=3D1

