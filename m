Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EE72606A330
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 23:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oOtIbFcu
Received: by kanga.kvack.org (Postfix)
	id 166996B05D5; Wed, 18 Nov 2026 18:49:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1180C6B05F0; Wed, 18 Nov 2026 18:49:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F21546B0656; Wed, 18 Nov 2026 18:49:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C60AD6B05D5
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:49:02 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3B2D314091E
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:49:02 +0000 (UTC)
X-FDA: 85449882924.07.826CF3F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6033416000C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:49:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oOtIbFcu;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795045740;
	b=L/F4BZWo68kji6Uten5ia2unRiews2LgBDBGavRXK93Op6qyZKaFPsbDBT0Z06gWUqKuEh
	Eezc3nGFwpHkHAsG1iQ8wK6e68Gnx6izAlxgoVrUcEsWjgb8vvuph6nnaqzJ/rAJwVLsep
	+ecOaTEZLG997Qlqg12ccutvMhf/Dvw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795045740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JokRczt5mVEgHxRUZJg6jCnvGvoAs9YtaIgcq2+6nkw=;
	b=OIkXt70dfaoKzcMnj9D72Ac4Ja0aDEL8+peYmReE8/JPzFioJHM3gFlnnL0A+grimbyNNj
	JUzZUfKTMyyP6Zx1UB3GJPGYS07U0fBlZK3yyWV2kvk51s3+JjFDmS8mCaA5iaUCMgvDzk
	EMlfWeEPgAXOqSpCZxmC1mlnqNLYtto=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oOtIbFcu;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8EA02478EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F3B1F000CC
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795045739;
	bh=JokRczt5mVEgHxRUZJg6jCnvGvoAs9YtaIgcq2+6nkw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=oOtIbFcuKGbYPJjGa5ZVRGgeaHzVpkuzTXPOHw3vnuvhUPE0HTqYt0h0Uu8QqgGoQ
	 lHisu5eSwPTqn+hazJGGckQw7QYoOw74bD+Q7J0bQa3ZjO33n1LrifNjwALxz0sKO/
	 ZiKWXd3uPAP25HAeA50GCqokAX30GY1Ls5njzH47WPY8ZOWYehCS967DqOuug9xhTk
	 4XB4RjRd3GNXjADRae5CqMbtxeWGpJQypzhX8TLu5u60aiH7mygtuVQ/ZTqR82/NJ8
	 wAWsKgPDoZC7QUVNCJni4vteyzyqcsmVvk1u0aMF6Z/iEaHvmy0u+5fIXLnaoPEx9G
	 4HZAtrraj0hcQ==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-9496473b511so49569785a.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:48:59 -0800 (PST)
X-Gm-Message-State: APuU4Z+tpRnPjbhY+gaXZwiStVK6g2uholoVrC7Y4vpfIan0VjbmsYX9
	/90m9ylUaS1J/oLSj0sjFmSULbZNbsjO5n3URGkVeZ+sW4WGoHFrLPIQV+RZbs+WIFkFAKIx5lU
	2n63IL01KviZ0dsWfzuIyjO3JR49iu7s=
X-Received: by 2002:a05:620a:260a:b0:949:6b5e:33ee with SMTP id
 af79cd13be357-949ad938bc0mr22211185a.31.1795045738801; Wed, 18 Nov 2026
 15:48:58 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-1-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-1-9eee2fe97a2d@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 19 Nov 2026 07:48:47 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yUH9EG=kPWkkp_jm2Fy7e1D20f+uod1_9fUypW1G5sgg@mail.gmail.com>
X-Gm-Features: AclHuK8u8pAmVqW9yFgv9yKvnlXrt2QgHUMeTnuokLmXwaR9lnc-LtRTxLtZGq8
Message-ID: <CAGsJ_4yUH9EG=kPWkkp_jm2Fy7e1D20f+uod1_9fUypW1G5sgg@mail.gmail.com>
Subject: Re: [PATCH v5 01/17] mm/mglru: rename the generation offset in lru_gen_folio_seq()
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
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
	Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ep7tx4jpm5gk3jfq3m69jpuiyzxdobjg
X-Rspamd-Queue-Id: 6033416000C
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795045740-765446
X-HE-Meta: U2FsdGVkX19RIdSdYpykey3djrCgD0eH3JefnIsF3ODfC32MWF8Er+r/FI3AxjF5ArOXrYigjJ+z6PEwC3uqO3nUtAS+iY2YCK4iNJ3BBR+kUcp5tkfGZP2s84yCFu1kYc3wYOK1fy5HRTdxQh6IXzhCyxuMdroyLn3LODD0HEnUXZCBzCqLGWs0uqnqm9B1TmQ2ZryMlL/GctlfvwpJ5dd6adB5teoE6ocyP9lHUfZ3KcEoQlqfuoiUkY3jeWHag3d8ktRnzSuQ7myHpV2QZnj77EhFiCDC5tWpYk5rvGTxsrBiK390CQgph77Wu8FiN3qQaFElC/YQta5VOOtJAHoHebfeA33JmE9Q5tHQDa8gvsd5hKY964AaFXNNBsj+AI3kDo1elsyEyLqQXLRGJbCUl6YyFXOmVwYgYvzXyFQt1+KMnRMhnIkuOxf17TXRME0eJZPnlH6UKVLV847Jbj1xoSGN5lDYpSeCYjnEFDYnacs0yQKc9rDrwhGD6j2UJTF3J0eSrX9BefmZ6664raF3xV/GI4s5fMRktn8Ar3du6aHZ7cfN+bBb121TeonBg/cJRXJBMQRh2j3YpiB1HAUUC45hXLHNOn3uNF7Z4f+30izGgJ2CJSnSpAe7mU75RZJ1FSkH0iADSyOoiHsIScQFHbmxSCjFfyZ0lI30s8cNMj+Ze68jjw3l2zKBZ7M08PHZqGihpbwJPbd+i3TQuzaN4ZwAVo2Jiqko3gWV9SVo1hR9H24Xv0dDn9b0iNA+OlSqE6PQaRhWrDj45MLDXjPGN1qZlMLjDGSq+y2slhfq/4syB0QSGTjcqHcKOdiY5uEPDxjRqNSZz0LFYvPwERMx8iGxzb2u9VqPIEtL1Vp31rL7miplWjHpQIHxf1CE/h/Yypr5t9AzP6tYvQRxU3RQdgTg03Sruvz/wloCn35Rnsvh7vuZt0H8de0+FBzXEk+I15lokGd6gPhnCjY
 aD9Tx4D1
 yyFU2ef4Cjk5+s3UzFxwdtpDxbkgDnoEwjwVYjPg0IQWTo6tedvE9NrUiInb/FRaagZ6FVmoS/Z8q8vjnXKkDMDTvDaWF7FLTAgP10g+5Hg3ru8JES5fR5Y35gzWXBbXLPM8MQCRkFi5UzaA5ks25X1OZ+U1lbHGi3MD1sHFoVOGezujN2yYCA3mqYVMuvGu+NFoIs7MYtHJP2q89sJNT7gQSOHP6tF1JPh8mbVNUvtLxPLRj3QDxyIRbbkPz4AE5KLwJ0mstOcDz9RniH6gkC5+kbynEt0MjWaUz4lq85hhHu+Y2FrrhNqkw5cqNgzRdrWIWO0epnlRajd4H0Nt5kYcr6tz3NZk1CHYfEZvEpdZ5cVRfSjn0T8Lh0C5tHSNrTJxo06mEaSgy6YcNjQ69l8Ist+AR7MwVI/LGU64pTM5PxiaSMo/X3WHPV0G53TwSdULVQ1dsMeQvZn1DMNh3UUDn6Ri8S4MfRGZr6YppSfn1lupBIArzNNolwNp1DimOA2GU5RP7hehyGKsQ1/iFFZ9PXSQZgmnjgnQ6z0NyBRRf/q/22PGsrku5kSwry33WcBJ0IHxiw8pilFW91fE2dYGNjyQfXXvni3q53tnHxc8DMACPeVkKPp4xGw==
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
> From: Ridong Chen <chenridong@xiaomi.com>
>
> lru_gen_folio_seq() computes how many generations below max_seq a folio
> should be added to, but stores it in a variable named "gen". Elsewhere in
> MGLRU "gen" means an index into lrugen->folios[], i.e. seq % MAX_NR_GENS,
> so reusing the name for a relative offset is confusing.
>
> Rename it to "age", which matches what the value means: the newest
> generation is age 1, and a larger age is an older generation.
>
> No functional change.
>
> [kasong: dropped the comment table part, the series rewrites it]
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

LGTM,
Reviewed-by: Barry Song <baohua@kernel.org>

