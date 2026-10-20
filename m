Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF757606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 23:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=V20xcavw
Received: by kanga.kvack.org (Postfix)
	id D8CFA6B0587; Tue, 20 Oct 2026 19:47:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D15FD6B0588; Tue, 20 Oct 2026 19:47:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDF896B0589; Tue, 20 Oct 2026 19:47:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9909D6B0587
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:47:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED7191401B7
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:47:22 +0000 (UTC)
X-FDA: 85344643524.02.C395D78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2D615180003
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:47:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=V20xcavw;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792540041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8A2vMb2kidVxxepbgIC9HX3GXSZalF1YRLxBoNXtIqk=;
	b=yFkxASei0vT7QG6GQDX7Gt3VdHxtZdRGNeVO3jDVe4fLtRMQfwvnaoXF4FaGCYAR7Yg8C2
	nFjcdrbZRPVY8HYYfOWeyBL9LLebzWR6JW2qVpx7EAx3QKORRAypIAcNNMa5uzf/XmsEYD
	jo2DP+innpmm6Lzlwvgp2S0N/xBMfJE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=V20xcavw;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792540041;
	b=j1+0SMKnwirkCmQ8dECU5+H3CfxUG9f3qgRSSFr4FgjXzYcSvyUKu/BF9lWk4c2dvR/g6G
	MaC5WQCoDLwJVILNtfHFGjsUnnyyPl69kowxcB6O2gLTabhJoYU9Sx3j6ElLH36NJE0wDD
	CHkwJU668x1LA5eekmmltT5ieZzGHfQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9032B42A50;
	Tue, 20 Oct 2026 23:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CD91F000C9;
	Tue, 20 Oct 2026 23:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792540039;
	bh=8A2vMb2kidVxxepbgIC9HX3GXSZalF1YRLxBoNXtIqk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=V20xcavwH1fqcK9SSgsVtFQhUNOj+/hnoEuFSVhwaz8OlhyzfzmifNT4ZY38/nxEM
	 akGiNYF2vhnAxVk5ZoMGFWPFLmHE71TO6qLMFb8uJhATBjoEOICMKK+8RF1R8fls66
	 gqmIUHwdtYb+EHT97CHm6YynQAUUyGOksSvAP0Z8=
Date: Tue, 20 Oct 2026 16:47:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Barry Song <baohua@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Johannes
 Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun
 Song <muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, Usama
 Arif <usama.arif@linux.dev>, Lance Yang <lance.yang@linux.dev>, Hugh
 Dickins <hughd@google.com>
Subject: Re: [PATCH v3] mm: unqueue deferred split folios outside the lruvec
 lock
Message-Id: <20261020164718.91017a58befc7940397ecd05@linux-foundation.org>
In-Reply-To: <CAGsJ_4wq8jii0HozMonGej+2O5k90DB4ii07WaBHoOQOKQDokg@mail.gmail.com>
References: <20261019230646.3510790-1-joannelkoong@gmail.com>
	<20261020153648.52636815691868735e9699be@linux-foundation.org>
	<CAGsJ_4wq8jii0HozMonGej+2O5k90DB4ii07WaBHoOQOKQDokg@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2D615180003
X-Stat-Signature: zbprh1fwkdowp3rcmnq3btyh1irrga76
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-8.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792540040-828912
X-HE-Meta: U2FsdGVkX19UZg2uQKKM0stQ6WsbeAvQljg8QJoDMag9aZhGHHS5gb1oRWat5qdFhVo/fBef8IPmjv5g40/B9wqOGU7G2WEoNFefkVDBHwkN02jYfkMKtuIFQwru4pJCnJVHD4ubo3FEkyyv822qdmh6Ug/UcTC6/7R2VKygAnw/zCcSI42QlZBMQBsqp71G+Lv70GXE9AEwhfaqo7At1Huo1t/J2z9gkUJUVNLkhhMmUJ8hBQEdsowLaF48/c4ZQs5hEOSzTpM9e588sxr1gdHdpi4+CFpMRqspL64EvOQ6eQmYXkToUUsTO4PR1aWd8Tt8klGF1F6NkIAlvrJiYd4xmIXLFzBu7rNOFPiCkhqwvYrqyBxX7lzE0SFXyd+W2GD0iXwEN0sjNUEoNHp41SaoiD8lBkXC5ZRpkHQLD0kb/Vy7eOBCdnYMxqvLoXuDnF7JlF6tNBoZF6Rj6LgLKEGCK/RAZ3GWQGkm23h1UFgT+tOU0tosz3EZvCd9bET5JsnmhtBGoXkApJa+nAlVUVdqW1zysnKK8bEXqjlQsgIboIonKtiyjqYutRHjk0X5/DyB/yUKtOA3PQ7UDqQsO7G7Qs4eOImJCiBM+IT0Z4onZeXK/FVzv+8ymqzMn49PDcLsEEc2p6A5fLYFq/Yb0p9osKjy2x8wJDuXG0a72vDVDg/liOuAJt8pIHCcDLty6JjCU9Eb0dwoCYAZP+5AzGZolEW89JQZryDUIc7tFjUYCQ654f4T0DesnqSwmg2tFePKr3fLxwfEpYZSbZGT5jmKUdzvFdfSomyEjRyUcdiE9z8buCpzKC7gKxD/m6rdKlA+aD//718SgA9/QCu5dZu4sVdkEqBCmch/Qd1DI2nU260g/AgSdduMjJ9UE8PATGM4PR4P/e+TWCwjDQu2F+i7yqBUZohbnCUmvEMX0HBZ26LppYB2PgYSoe8YgXF52IdOHY3ntyJqyBPOBOz
 hI28dDoO
 Kj4twczOgBqz3GAyLJu+nYSVCkXiX3TC3WSUr+c6ZDd/4YHtZPGLu7lX9lU7AUgwIn3mJdXHVFFmpe7sbwWoDR1xfYeEb/Ae/7VxAbFJPp2OPB6CQ9DMRL9f14IBaCdEPASDraDy8N0//xq2qEiqd5jLCXY1LA9xi7cpRWbTD0tOdYOaw7yrXjliMZFA2NuEk4BhzuuxZxJoRwEKnbxQNtcPHcdLEhXbD1Ed2SHkUtLdkb9FiopeAj304WxMl8thAu3PXocLGXah751h4rz3P8yj5GA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 21 Oct 2026 06:40:23 +0800 Barry Song <baohua@kernel.org> wrote:

> > This is a speedup and not a correctness thing, yes?  Let's make it a
> > 7.4-rcX thing, for the 7.5 merge window.
> >
> > I'll park it in the mm-new branch for now.
> >
> > If people think the speedup is sufficiently worthwhile then I can add a
> > cc:stable to it, if clear justification is included in the changelog.
> 
> This isn't even a speedup at the moment, as no users have
> adopted it yet.
> 
> mTHP folios aren't currently added to the deferred split
> queue. Joanne is about to add >=2MB mTHP folios to the
> deferred split queue again, but even then, contention on
> the queue shouldn't be an issue.
> 
> It may become a problem someday when we add smaller large
> folios, such as 16KB folios, to the deferred split queue.
> So this patch is more about future-proofing.

Oh.  This:

: This came out of the discussion on v2 of the mTHP shrinker series [1],
: where queueing small mTHP folios on the deferred split queue was found
: to regress Barry's fault microbenchmark. With [1] applied and
: khugepaged/max_ptes_none=0 so that every folio is queued, perf lock
: contention showed that the extra cost came from waiting on the lruvec
: lock in the free path.

made it sound like an unquantified speedup.

Joanne, please clarify the expected impact (always) in the
changelogging if there are reasons for a v4.

