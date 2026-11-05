Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BE89606A328
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 13:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ghr+oUom
Received: by kanga.kvack.org (Postfix)
	id 024566B05B8; Thu,  5 Nov 2026 08:03:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3EFA6B05B9; Thu,  5 Nov 2026 08:03:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E06B86B05BA; Thu,  5 Nov 2026 08:03:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B5AB96B05B8
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:03:44 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D311C0A09
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:03:44 +0000 (UTC)
X-FDA: 85401082368.04.09B12C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8FEEF4000D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:03:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ghr+oUom;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793883822;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=loGDDyFhxZewKwqoGmuq38grwFtQ0vjKaAg1qgaeLVQ=;
	b=1H1yNKZdpU8FVW93BlKPVoyKiiNVBe8ZbEl3Hrz8aTUK0fM+w/IJjX8pNwpEbeYF0ybzFM
	HokdqWfrnXQ0336r0FtET2NPrmg34P+LlLISlg0x1OSCvS/3ZWdstEQDEEoGiAcHVlZDre
	CL51hF5JWMRLtU54+IPt7LJRplKBKxc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793883822;
	b=MZJ5BfDrmeZwTkSHV+RqmgD7qWxllZCNv6K5Lb8VQ9/1DO2Tn3O/+LN9LJmyz2/Teyui+S
	k+nbui3KV0rSGqia8u+YqEG0XoTNPiGFwPqinPtdtgcolESLJnaYb763aNjfMayckW2EUa
	V0iazq8EX+zS2+POCr/huv+C+9tCDis=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ghr+oUom;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2095E6110B;
	Thu,  5 Nov 2026 13:03:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9841F000C1;
	Thu,  5 Nov 2026 13:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793883821;
	bh=loGDDyFhxZewKwqoGmuq38grwFtQ0vjKaAg1qgaeLVQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ghr+oUomn+R2SXGfH0sHIsGjSwMXeHeRPrQeeZO/6FzPpLxG7lVUYEIuf4c1ZioP9
	 xoiaYhDTcvZg0ef4eVc5c+PgP49eZ0t/wCyhaQv84R+A3mFAiuXbDMG/+RZ9l7sJfO
	 4HsYXuOAVoBWBIITxvjwC+9vbE5LRr0D8RBi3N1n7GUZd+mzSSAY7Vs09w1hRl2ciz
	 2zetTQLYI8E/+FtmxCn1gEdaWLiDLZGuxjxqP2wbpj+/cISemhxfc+6kaKW1jnDjCg
	 nG4kzYv2oX8Lcv4z7j5T0kr1SKdffnB6FWp0hCteIhYqlL5c5r5Tqgk3A6sy1UShtd
	 XlVfRIr908KCQ==
Message-ID: <sashiko-outbox-199101@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 08/18] mm/compaction: free the migrated folios
 that wait for a grace period
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?S2lyeWwgU2h1dHNlbWF1IChNZXRhKQ==?= <kas@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Linus Torvalds" <torvalds@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Matthew Wilcox" <willy@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Jan Kara" <jack@suse.cz>, "Hugh
 Dickins" <hughd@google.com>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Harry Yoo" <harry@kernel.org>
Cc: "Miklos Szeredi" <miklos@szeredi.hu>, "Miaohe Lin" <linmiaohe@huawei.com>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, "Oscar Salvador" <osalvador@suse.de>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi
 Yan" <ziy@nvidia.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Nico
 Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kairui Song" <kasong@tencent.com>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Axel Rasmussen" <axelrasmussen@google.com>, "Yuanchu
 Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Paul
 E. McKenney" <paulmck@kernel.org>, "Pedro Falcato" <pfalcato@suse.de>, "Luis
 Chamberlain" <mcgrof@kernel.org>, "Ilya Gladyshev" <ilya.gladyshev@linux.dev>, "Jaegeuk
 Kim" <jaegeuk@kernel.org>, linux-mm@kvack.org, kernel-team@meta.com
In-Reply-To: <20261104130118.2507513-9-kas@kernel.org>
References: <20261104130118.2507513-1-kas@kernel.org>
 <20261104130118.2507513-9-kas@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 13:03:39 +0000
X-Stat-Signature: 7xfe33sprwfxg3nzsaw3jodn4gkf6jq6
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8FEEF4000D
X-HE-Tag: 1793883822-467306
X-HE-Meta: U2FsdGVkX1+sepwuEvVvJF5YpD2YP/1om2OQLNJ1bCvDuYCN0OZxa3GiMUB6TOm5vCr56ACjuKZxOTvGT+L+sz79eJFoi0kiDFEXABHQx4rJUi4BSaRYtsxJwVfOQB7dtkqlwXwDSW06P2+HrzByzwLd1rvzCgnnVZ16KQgz01uhNAsMMpD/YlhgBGWKdfmorgDGbXRjx0jGQAeJvoNOam1SO3MEl7XgXZY2I4alkPG73vBAu9ZOn+htwyzeurCTfMlrmJNmz6gWPlxMvTnX3hYw7cDxKcvoF/nHnnel0Sj1sq+SipCE361+E4fq2MVWYujbzRA2G3VLg3kaMquLPNX5c9x1ULEyiLt4yIZ0UB5cFe4ZV9P5r6LpIChv0IPVXlnDRD1LgJ9peEg1+CqVHEWuA9O3BcvVPD0hYFDngKNFpV2ti2Kniq/Qku2KSSMdWC8QYC+KcCeag8smQBX/vPre48UAWgUN5nkys2uy9e8LaDoqPO/ccSk9FWWw6NYKj3eCOOKqrbi3Hs6RfFo4TdIBj5Qp3HqzlARrVVbkw5VunGzxTEMa19M/e4QL+Nmb4IxQhWMZJFrhF+LuWfVhGjQ2qJK9zCE3xXyfqOgK5qHZpWS0S/SiEKHgBGAVw85+OSn7clLoidDAaQFBLb6GPHKM24N74jX0Kugmmrg9vX2OCYt1XAruClsInrZYwL77VsTta8ixW2pQIidqvJYSekUtqhR9ES3cIwOOMdT2KAJM0MNZhA0F4hiQHwrPNKC9ylEkQ4rmieaIoGtqTrEJlInDg8H3KSiCrEqOV7nip8Xw9enprzttoTB6GZPE1g1/u/RVnHhmuZe3dsXvJjyFmPyqO9kVXfcJyfTI+liB9FVGqvTOjYUKcpJByNpuJrT8tlLTp4y8RhEg01FzQ18uhZqMY23zeaH79JUMYW9v1KwKXpvVHDq3Kw9cHNH5sgPHJ6FmTItis8LZMHrc0pv
 NDTgxk4C
 65CENu9aosRq7aksZjPu4sxuI2Q0B64P0fYZD1XZ7EB3VxZA5d0jdDxPzGQrB4sBg3QjaWAGv1qCBzrtKeg6UV6QKLqkVNwc50j8bx8Oo9ejN260UQ5ia6tJSENbQa6tnq8aAyKpEYrvx0u/xbPA4d4uLhAa/vPYlTfacxugRtNVxyjxb7JZ7tuSFbNA6Y0WWTlvq25CbZdzJyg8uB0lEEw3IbDzV3Un+WiMDb0vi+52Ggq1AvZ+OgS8kBu0w3/Iy0YZZ34XlOsMnYdiR8xQieDx7R7SY7n/QJ/m97GT62Pv6Y3v3c4eiRH+QYgB7iDSAJH1ZXea+fD+jcXh785sRnYroFndtbf8VZn2oF3G1K6gyN1cgO2GPLlCvxFQxvQ9bS5o+0hyO6oZuM+ypRlFl+P9jZFPNXloZ3SMVnsN28YBk7BpNP/uu3jyeAIEHpXDgkbYqJ2bEzwOcirpP4Mz7T2Ge2/T4hFT8ji8MviX2ryKO+rC2pBeoVcdY13IV5wuwI5ESh8Jqo6S24LmyCX0msaFoE76wL5qGlJRjS/LmVSv3yP9I1zmpjgHTjW3vYleobucIdWCRh7+UhPl95JUnkZujZ5xdNkUC7sTGIzsW7zsDlMUoIjfyq6rIQO/UpSe+/8lRQ7KQJj3lUWAWY3Xsjz77TrIf58m3CfIcUrl7pYYvtqL8P+VpcBtP3PHK53M5ZrQ/zxqn0D01BSY=
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
- [Medium] mm/compaction: compact_zone() misses pages captured in rcu_free_=
drain()
--

commit 0e470d35ade0bceb30271d7e57f7ca44bff99bf7
Author: Kiryl Shutsemau (Meta) <kas@kernel.org>

mm/compaction: free the migrated folios that wait for a grace period

This commit drains deferred RCU-freed folios in compact_zone() when non-asy=
nc
compaction moves past a block it migrated from and the zone has pages waiti=
ng
for a grace period.

> diff --git a/mm/compaction.c b/mm/compaction.c
> index a049415512c67..2acb87a3446df 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -2760,6 +2760,14 @@ compact_zone(struct compact_control *cc, struct ca=
pture_control *capc)
>  				block_start_pfn(cc->migrate_pfn, cc->order);
> =20
>  			if (last_migrated_pfn < current_block_start) {
> +				/*
> +				 * Folios migrated away from lockless readers
> +				 * are freed after a grace period.  Async
> +				 * compaction does not wait for it.
> +				 */
> +				if (cc->mode !=3D MIGRATE_ASYNC &&
> +				    zone_rcu_free_waiting(cc->zone))
> +					rcu_free_drain();
>  				lru_add_drain_cpu_zone(cc->zone);
>  				/* No more flushing until we migrate again */
>  				last_migrated_pfn =3D 0;

[Severity: Medium]
Can compact_zone() miss a page that gets captured into capc->page during
rcu_free_drain() or lru_add_drain_cpu_zone()?

During direct compaction, current->capture_control points to capc. When a
migrated block contains a folio with PG_rcu_free set, migrate_folio_done() =
->
folio_put() -> __free_pages_prepare() defers freeing it via rcu_free_defer(=
).
Because the block has not coalesced yet, capc->page is still NULL when
compact_zone() checks it before the check_drain label:

mm/compaction.c:compact_zone() {
	...
		/* Stop if a page has been captured */
		if (capc && capc->page) {
			ret =3D COMPACT_SUCCESS;
			break;
		}
check_drain:
	...
}

When check_drain then runs rcu_free_drain() and lru_add_drain_cpu_zone(), t=
he
deferred pages are freed in current's context through __free_one_page(). On=
ce
the block coalesces to capc->order, compaction_capture() stores the page in
capc->page and __free_one_page() returns early without adding the page to
zone->free_area[order]:

mm/page_alloc.c:__free_one_page() {
	...
		if (compaction_capture(capc, page, order, migratetype)) {
			account_freepages(zone, -(1 << order), migratetype);
			return;
		}
	...
}

After check_drain finishes, the while loop condition calls
compact_finished() -> __compact_finished(), which only checks whether
cc->zone->free_area[order] is non-empty and does not check capc->page. Since
the captured page was not placed on the free list, compact_finished() retur=
ns
COMPACT_CONTINUE and compact_zone() proceeds to isolate and migrate another
block even though the allocation has already been captured.

Should compact_zone() recheck capc && capc->page after draining (or check it
in __compact_finished())?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104130118.2507=
513-1-kas@kernel.org?part=3D8

