Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 209AB60A260D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aNS4yN8W
Received: by kanga.kvack.org (Postfix)
	id 2C2086B05C3; Fri, 20 Nov 2026 13:42:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 299296B05C4; Fri, 20 Nov 2026 13:42:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AF796B05C5; Fri, 20 Nov 2026 13:42:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DA4E46B05C3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:42:53 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6FEB1A0002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:42:53 +0000 (UTC)
X-FDA: 85456369026.20.64CF92C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id B56CE80009
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:42:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aNS4yN8W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795200171;
	b=UiO9O2P+XCOzD5dPuT4/QmS8MZA/cIzJCkR2wpDZc+rBKwfUT3XVjtgLapVb0gTeJbrS6Y
	dxwwo9ExhEGpAA86uowra7fg3GKr0NgigcfHm1kYnU/ZllK2fcZvz8ysLbPN4A27D5J+4l
	3eb4talLKJET2w2iN4cyRuxY6SXHfjo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795200171;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y9Ozc/vyn7RySaeVKc2C5lg/xFQMgUpBnP9tdHlREPY=;
	b=ridRt/DCs309j0rUYaSb8K/ZJRpNaruTtZNlTeOsm5v6jpmM1jEhYldnwZPp0kuVk4iC4Y
	XEfBDaAatOxxjLncl1wH62GX9vheZK9yld34+gz3ZPOD0DV7rP3zjyF0m2XgwVYexaERak
	KoOAh8k9gLstw7rNj/REMz+BdU8GeCU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aNS4yN8W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0EB11403AB;
	Fri, 20 Nov 2026 18:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225661F000CA;
	Fri, 20 Nov 2026 18:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795200170;
	bh=y9Ozc/vyn7RySaeVKc2C5lg/xFQMgUpBnP9tdHlREPY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aNS4yN8WEpXWTabD3hYouluOLl2waSA6+zhE9QzQ+lvUBa0+6LyNQ00WDLkY3U6Qe
	 +O4fmxQE7oVBgIgsFy7fM7WXho8sew8qw2QuWIaVx+2PkOIzdiInFEYMxpV9b7h6SD
	 N/ZofWLmNj7em5KG46/WtsXQDY23YceB88TmzaLWMFi8Sbm0qxrUivFkOf3oEuvfyK
	 6dLZbAuP9Xym9/gzSzZFt+Yhqw2DCTmQ53Gi/uXHtRJ+Gqhg+uGNt1P8s2PFk70mYr
	 EvYOZHzEreWOK77ywVLdCmu0lC4y+9VthhGlyBZAXA1VTSznZJeVnm1A48UZoqmGpv
	 33zdIDyNGOX1g==
Message-ID: <sashiko-outbox-225861@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 54/60] mm/migrate: route explicit NUMA migration to
 private nodes
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?R3JlZ29yeSBQcmljZSAoTWV0YSk=?= <gourry@gourry.net>, "Yury
 Norov" <yury.norov@gmail.com>, "Rasmus Villemoes" <linux@rasmusvillemoes.dk>, "David
 Hildenbrand" <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Michal
 Hocko" <mhocko@suse.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Oscar
 Salvador" <osalvador@suse.de>, "Johannes Weiner" <hannes@cmpxchg.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Zi
 Yan" <ziy@nvidia.com>, "Jonathan Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>, "Danilo Krummrich" <dakr@kernel.org>, "Johan
 Hovold" <johan@kernel.org>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie
 Kim" <rakie.kim@sk.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Matthew
 Brost" <matthew.brost@intel.com>, "Byungchul Park" <byungchul@sk.com>, "Alistair
 Popple" <apopple@nvidia.com>, "SJ Park" <sj@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Juri Lelli" <juri.lelli@redhat.com>, "Vincent
 Guittot" <vincent.guittot@linaro.org>, "Dietmar Eggemann" <dietmar.eggemann@arm.com>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Ben Segall" <bsegall@google.com>, "Mel
 Gorman" <mgorman@suse.de>, "Valentin Schneider" <vschneid@redhat.com>, "K
 Prateek Nayak" <kprateek.nayak@amd.com>, "Kees Cook" <kees@kernel.org>, "Kairui
 Song" <kasong@tencent.com>, "Barry Song" <baohua@kernel.org>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Axel Rasmussen" <axelrasmussen@google.com>, "Yuanchu
 Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Michal Hocko" <mhocko@kernel.org>, "David
 Rientjes" <rientjes@google.com>, "Pavel Machek" <pavel@kernel.org>, "Len
 Brown" <lenb@kernel.org>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Xu Xin" <xu.xin@linux.dev>, "Chengming
 Zhou" <chengming.zhou@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Pedro
 Falcato" <pfalcato@suse.de>, "Jann Horn" <jannh@google.com>, "Chris Li" <chrisl@kernel.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Youngjun
 Park" <youngjun.park@lge.com>, =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNs?=
 =?utf-8?b?ZSk=?= <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Waiman
 Long" <longman@redhat.com>, "Ridong Chen" <ridong.chen@linux.dev>, "Tejun
 Heo" <tj@kernel.org>, =?utf-8?b?TWljaGFsIEtvdXRuw70=?= <mkoutny@suse.com>, "Dan
 Williams" <djbw@kernel.org>, "Vishal Verma" <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, "Alison Schofield" <alison.schofield@intel.com>, "Shuah
 Khan" <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, damon@lists.linux.dev, nvdimm@lists.linux.dev
In-Reply-To: <20261120-private_nodes_v6-v1-54-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-54-74f5f9a115c2@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 18:42:46 +0000
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B56CE80009
X-Rspam-User:
X-Stat-Signature: rmoxnd7qpy6tzqnmksoc4a3my7zyh7zh
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795200171-301456
X-HE-Meta: U2FsdGVkX1+Q/HpjVZ77nu7EKGe0y/WeQY8uMzxDijOJvKEwGjONYyD2rjXOM0PGMKr9QPHKQlAVdzdD6b9SYYY3MzlKl0Ngg/VYc6CF5fLrpQyjrq9tJVKzNS0BebPvOlkFLFbo+lW0/wmbT8B2+K54XXex+iSyOkWR/W9Xyl1NIfSu1yIIFPfV/pQ3m47PPlQxufwuN54t4RPAT1XkHk9wktf4Nk1maamsMcQoKnGcMplsorIS5zAw7VYZ6QXh8hwpe/nN/r6cUphWroK3yY2h1sj4jb4VrdioNXO/7S/tkXG+Cuwk/6WM/PnF2XeOIqSxAIvAsC6p8a0n+bzh/+jCoeMkbo7UcvByhJ6WpFrVscR2yS8RxQxZEktEyVlNAFqUwszdvFO8+COWAzdOTQO9QFi5TfpTV8SzA0B6bX6DWmNZIWfCQop3cMwrlelaL5tqhsFUNwDWLtJIuDrp6U89p+KP+OKlg0+C3OiTFW0Z72dbRfqB9zfVvBN3l75h8mZAiyWyXq+HCs1KxSMCt2pCNe9qpWjo+wpcO013gcXibpjIvCSwun+1WorDl6CW5iyT01NOzKR41tgXk2mQOpw6km8XWHOlkf6ZSUi0xnROhrazs21DYnoaQMbLzXBsMIHBUUHk/eMmgm70+t18GDXTSjcWwZGIp3Z8ok4JYpTcbb+u/sSSoeH5C/7iwZW/2I0fiZ/fYmlEA2/Fr4yYeYZd2GAj3za+vPtMfdXdqNe2BVz9+YN+UkojsAE4F6UUl8vM4qvdo5G9K21abGs+cmLadJtvfK0yaGR2yBUUkhf2SHuDURcZjs9bTZedHwbT+UnNbaqx+I0BHqFE8Xn1FfhCzjv8UlBXkIJVi7XvbmnV2znOAV3y20f8sSwKCYp0F2yW4oqWbpC4D92LPG5a3YULc0c2EBlt+B4HC9czBavpUivDrQyZRz4f/Txi0GzefSM+ohayj5grLep3cYW
 8U3LY2FD
 kg69EJrhqVT9mLepwcKdLzRc08VjP/h4nUmu9Ruk8swhaT5JAeUA0JoM3UwSBxuxktaD3nUnePdhqJJwCBqcnPcjotULhUbbnW4Rtyab6fihsZfJfAA89JWlQNGAINT7EswuWBzrQHBLZ8t9jPkJjuFzpVsyNmJXlGtkKLonL5DuvrLwhmpdM1JhsrdGWO+Ce6iKOAx/xjrYlWjr6SKU3V1ACwAlBnXz2RAwfDB4KbIpVxTne3jVGZ/d3SBOvgQd+rc9bCnjKxe6biE1ZBJf9BxHS3UVDeePh7oJsXa3IZ6eGVD0T0kR8kwLfFuGXke3sa/EGxTU/6GpLyTIQVLEhvgjlJDka9wA/cqMpBtRKPGDg/GbBEFBcc/AI/UKZb+qbYYGFzKzjgXuhVTPtFB+8iVPORAzqohdh5f5g11FyXo9RaBhFYiBCweucqNlO+I5s4XMpuImSVahNUFmsbQrWhquiIuYy+CA+K6mxZGkF/TzDncx2ZHP6mHLQ9jkDcOROAgJdvobRPff+WBwvRkBrckDH9nxsvTn1H9QekUVSrFofoRb4m4ZhFNPymT3fw+GbWh118nfNaLv9dH2yzGAbkBzwMusY55pozZDGw/HjGTXp9tXh3faMVLDhdYDWQi6QPXDoFpMpqNUeImBVOY8Ypgz+8QxiT15LVHo9Y2bRZ80BFqImxU532tAe2BqB6yaLlrzkxx2RKI3z8v7+3rX7WqsGO71oQyCQ74epTkt6RNEd9tmHGMMEGK2X94IspE2OmGpEtneki/m0xElPR2JqxVYxpuOb1RC0Fn1/2zZyVWZxEEWT6v2PIomSU2STBg6Sx96v65/7PbnMrniJcp41CwdDrAJbuBfVjezFTZ8es7JsOd99PWS1VdoknvVMc4ZN8j+qOqxUeE6WTYrl+Gyo8QZ5PfroqiPEvhr9fYKy7+CmRx4=
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
- [High] mm/migrate: call to undeclared __folio_alloc_flags() in
  alloc_migration_target()
--

commit ca3cf1708bab40e7c2c443ad00cbc882e2163cee
Author: Gregory Price (Meta) <gourry@gourry.net>

mm/migrate: route explicit NUMA migration to private nodes

This commit routes move_pages(2) and migrate_pages(2) allocations for
N_MEMORY_MEMPOLICY private destination nodes through the node's private
zonelist by passing ALLOC_ZONELIST_PRIVATE via migration_target_control.

> diff --git a/mm/migrate.c b/mm/migrate.c
> index 6791834f14fe1..eda961d43df0e 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -2250,6 +2250,9 @@ struct folio *alloc_migration_target(struct folio *=
src, unsigned long private)
>  	if (is_highmem_idx(zidx) || zidx =3D=3D ZONE_MOVABLE)
>  		gfp_mask |=3D __GFP_HIGHMEM;
> =20
> +	if (mtc->alloc_flags)
> +		return __folio_alloc_flags(gfp_mask, order, nid, mtc->nmask,
> +					   mtc->alloc_flags);
>  	return __folio_alloc(gfp_mask, order, nid, mtc->nmask);
>  }

[Severity: High]
Where is __folio_alloc_flags() declared?  Neither include/linux/gfp.h nor
mm/page_alloc.c defines __folio_alloc_flags() or
__folio_alloc_flags_noprof(), so building mm/migrate.c with
CONFIG_MIGRATION=3Dy fails with an implicit function declaration error.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120-private_no=
des_v6-v1-0-74f5f9a115c2@gourry.net?part=3D54

