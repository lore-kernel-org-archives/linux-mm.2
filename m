Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD7C5606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 04:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U0I9hRGg
Received: by kanga.kvack.org (Postfix)
	id E86486B0985; Wed, 28 Oct 2026 00:22:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5E1A6B0987; Wed, 28 Oct 2026 00:22:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D25C16B0988; Wed, 28 Oct 2026 00:22:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD0496B0985
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:22:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 434AA1A0002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:22:36 +0000 (UTC)
X-FDA: 85370738712.15.4E319C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7FF8EA0003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:22:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U0I9hRGg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793161354;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vkyQ8vHhkWSt512yuI1HFfvtHuYn2OinQNhM77ow/sg=;
	b=ksiVrkGdgj0K1LlnIo4AXGBVNSrm2J5mOBjGM+BVvwtDgHFPlQEs/U3a9EGBL9ZWsLVhbK
	T8NeSEndxR3Rj3bMDLD2oIIi2ZPmqmpmA/HTisuG6szHtko6UPJWZNnBedePltClxtYlx9
	AsVDKtKubi6o5bGqLtOcnzTS1TbfNTo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U0I9hRGg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793161354;
	b=nAUbsAtDKLEgxaG7VCmrAKnsRI0UIeZOmR8w/TXVqgbDbju4OcrO+XQ66nbbTWHtAnOJIe
	WVXKDOA2z9lF1jZpwBxKMDfols4JbWoHhr6CeX66+CuREdsX93P1chSTLJc2eb3bpiZWOw
	OWCD+2R5HnQ2dRId7qDyuo0dCFbuaRs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CF3A143D0C;
	Wed, 28 Oct 2026 04:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6141F01825;
	Wed, 28 Oct 2026 04:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793161353;
	bh=vkyQ8vHhkWSt512yuI1HFfvtHuYn2OinQNhM77ow/sg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U0I9hRGgBbIvYWK4Y3maDxqSJe8UWuC/jqU3jpE5KHNCyZpc2lTw8E/yB7HZHpgn4
	 ulM6xIxcCByD/EAXHJWGfpoKRsXaiuC+aravlHhYAgtH3EinlFI9sBdCF4fYEG4tPM
	 Z7E+QVHqiwP6fSSJUM/MmPjThC8gGnu8q3XG02RWhyH86TodyLhfkx3mD1sZXgB8nb
	 wsnAi9CpfKxXBholTq4YtSx8j8scXxIpf/WdB100K1/c8QpZbM1caJNS/wQGwPh8I7
	 WyAD3e0703tdgK4zSHBFf3RHA4QxMZeZtY5sBjlbq1aIDE+05s/gZF/aTczBoCzfug
	 zsvlYFHsuxycQ==
Message-ID: <sashiko-outbox-187474@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/6] mm/page_owner: hold off memory offline while a page
 is read
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?R3JlZ29yeSBQcmljZSAoTWV0YSk=?= <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, linmiaohe@huawei.com, nao.horiguchi@gmail.com, david@kernel.org, ljs@kernel.org, liam@infradead.org, rppt@kernel.org, osalvador@suse.de, muchun.song@linux.dev, iamjoonsoo.kim@lge.com, anshuman.khandual@arm.com
In-Reply-To: <20261027042204.3741307-3-gourry@gourry.net>
References: <20261027042204.3741307-1-gourry@gourry.net>
 <20261027042204.3741307-3-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 04:22:32 +0000
X-Rspamd-Queue-Id: 7FF8EA0003
X-Stat-Signature: pwubznac9drtj4egex9s5d8fwox1ipzf
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793161354-43661
X-HE-Meta: U2FsdGVkX197FnuZ5zoVipzhI7ej6c7G3Jsp8CBfogaP2Ga9q/k3G74AlMlf7Jr/QKlRquhboUfyaLmqCWaTw3zABvcecwTs1pbvp/XwUFyrjBb3Jgvzr5oEOXO3he1A8/yN5GgRt8K02jPB7nZQStnPsumh3e6BpLuBP6pQcPzTE9zrR5q3b1EGZ4m6UOSGtD1YUGaG+fGX9oVYWer9hx13U2Me/exoO1hpS7BZL3X9wjImG12gNzA4R/zcuRsZBfms1ntJjWWo5p3FnoPiWVfQ7KoVCGF71fXJ3aAUS07MG+7Y/l0roqpb11iKnBZ2ebAQjDzkzIblLkMMU0TxycviTGWE5vNS9I59UY9vX1JeljYTxkWp527IyyETOjN3ud8Ur9UmuA7qMOETZniya3YjjzwFjYlSe70d4snWhkJkGWREBW2zFdYc4VdV1t6oVV77YXaNSVWZbXTycO5FErSrBJh4r5BEeWg0W7NWjUjfy/1FDf42MZcR5j47oPx8PANik75xOvQsL3V+s4PDaDYAsk6reiH9gR23ApnGcao+MYAONIxMBaT9kx1MDJZmaMSXJB/RQEFSL81oCicx79RDc8F8BxDiXczRq7fKgZ8TrLR2m0Lt5xH2Iekuf1UEiznuFsr+Kd+3YD8e92OCrvWsTVba7TnLzbgytre9IwwzPcqMInp9wxinQHH0+UWxNNydYNM0nGz8JdLEofwM6mqTgL1bud84bAurNEV02Ho8z92VPh2CHAI9s6Ot4YkX8JFwiXwxBHk8ipWZ5E1zdt/i7NMW0p2s4+g50j2y3Ti/Ts0TxxE7gwkVO+ani7Xm/+h7+qS+UdJ514pRS302IgS9TZ+EVFtxDG4eC43TZ/6oJpUv1++yi4k+5+vPEQBQywris5+7PK6M9LOdtYCACS6SvB4b/Kj372jOBNIL5PQuO1Bobc+ROvsMZStRv4BXfVTWn88xRrYmHA3yxaZ
 E9JQhfOK
 MQWI5ChPoA9lFJVVR4lFWjE4dhr4RP79LDU/zndHcfVJ044k4fmU5SgbS1CPGlFr1S6FzWveQAS1KUZVRo7MF4w1YhCwnJFi9G/084f2wFJ7zAQa49BvNgiSYVX8WEepBuu0hVb3i2gTD5WxQbZPtU+mlDGHXuD7G3WXDptHvusR4mkDwX9rW6Iz/9Hs1BogKVmtmrG4mv7uplIzqe6LMsFacg8FNzIvtL1dDSXBX+L0Ukq0+xEZfNuPK/0O1rZ3P+s/db44D9ZcGMCQJ6Jx2ETHXjz4VoKjL8OXIgPkQe5+DFz165NyPAR996jCkVZCgnKoBOGeYNiVjh/HlqXU1bnxzDR4z/pFRjD+4MEx29acXkpMdRSlg1pxpeMRIhT0IOTVgEMSlJYIe2JcUBjaRF6JyXMwEvuot1HVgnt8Eo2JZwaoSfNL7rmEkA+FKAMMHsyVP/FJJywyjf7MBt45wmCkyRYQdT5Yv5Gdf/oSkSyaZqF/DrjvPxyQp/hn2yVid2qDwiUtvdIGY9KaMpqyzAUS9hR3sTW32/xjpH+OQAbSHa0q49FONqeRXsvrXe5oWKnhiq8loHaZhuLWesl7DSijs0q18YiJcUoeQw8EReYifSvjj9RTWDKnvmpnuPpBaHx/JK85Q0/bvAoW5lpT4jd3GjmX+fZzr9/6ASpmsRdBiQ7n4cqAEbuwb0K9fcAnlCZ5Vu/cpeDFfeZoTmlBZaA6uOFSLbNkTIdYZPiZgyIo60Od4DB+MQaWuOOXLzhYcsNqn9izTbI3lexYmufpkw3f8Xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm/page_owner: read_page_owner() mixes guard(pfn_walk) with goto=
 cleanup
--

commit b2d3acd01e2d83565fff990fcda39fb4ee08ffa7
Author: Gregory Price (Meta) <gourry@gourry.net>

mm/page_owner: hold off memory offline while a page is read

This commit prevents page faults during concurrent memory offlining or remo=
val
when reading /sys/kernel/debug/page_owner by checking PFNs with
pfn_to_online_page() inside a pfn_walk read section and moving kmalloc() and
copy_to_user() outside that section.

> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index cfc31c92d7657..d2c0b831fcd3b 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c

[ ... ]

> @@ -766,7 +760,12 @@ read_page_owner(struct file *file, char __user *buf,=
 size_t count, loff_t *ppos)
>  			continue;
>  		}
> =20
> -		page =3D pfn_to_page(pfn);
> +		/* Offline waits for us before it poisons the memmap */
> +		guard(pfn_walk)();
> +		page =3D pfn_to_online_page(pfn);
> +		if (!page)
> +			continue;
> +
>  		if (skip_buddy_pages(&pfn, page))
>  			continue;
> =20
> @@ -825,14 +824,18 @@ read_page_owner(struct file *file, char __user *buf=
, size_t count, loff_t *ppos)
> =20
>  		page_owner_tmp =3D *page_owner;
>  		page_ext_put(page_ext);
> -		return print_page_owner(buf, count, pfn, page,
> +		ret =3D print_page_owner(kbuf, count, pfn, page,
>  				&page_owner_tmp, handle, state);
> +		break;
>  ext_put_continue:
>  		page_ext_put(page_ext);
>  		cond_resched();
>  	}

[Severity: Medium]
In read_page_owner(), guard(pfn_walk)() is declared inside the for-loop bod=
y,
so its scope extends to the closing brace of the loop after cond_resched().

When a PFN is skipped via goto ext_put_continue (for example on an unalloca=
ted
page, tail page, missing handle, or filtered node ID):

mm/page_owner.c:read_page_owner() {
    for (; pfn < max_pfn; pfn++) {
        ...
        guard(pfn_walk)();
        ...
        if (!test_bit(PAGE_EXT_OWNER, &page_ext->flags))
            goto ext_put_continue;
        ...
ext_put_continue:
        page_ext_put(page_ext);
        cond_resched();
    }
}

First, include/linux/cleanup.h notes that goto-based cleanup and scope-based
cleanup helpers should not be mixed in the same function.

Second, because the guard(pfn_walk) scope only ends at the closing brace of
the loop, cond_resched() is called while the pfn_walk SRCU read lock is sti=
ll
held, even though all accesses to struct page and page_ext for that PFN have
already completed. If the task is scheduled out in cond_resched(), concurre=
nt
memory offlining in offline_pages() -> remove_pfn_range_from_zone() ->
pfn_walk_synchronize() has to wait for the reader to be scheduled back in
while holding the memory hotplug locks.

Should the pfn_walk guard and page_ext cleanup be scoped so that the pfn_wa=
lk
read section ends before cond_resched(), and without mixing guard() with
goto-based cleanup?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027042204.3741=
307-1-gourry@gourry.net?part=3D2

