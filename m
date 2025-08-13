Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 971F8C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 14:52:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CD5990009B; Wed, 13 Aug 2025 10:52:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13157900088; Wed, 13 Aug 2025 10:52:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F13F890009B; Wed, 13 Aug 2025 10:52:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D6116900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:52:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 85970829D0
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:52:17 +0000 (UTC)
X-FDA: 83772024714.09.FEA476B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 004D14000C
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:52:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HXSRoY4F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of kuba@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kuba@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755096736; a=rsa-sha256;
	cv=none;
	b=DzdVTPyKU3EZ7Lo9eSkUaoAauyX+1SybuJLokAMd2GSnQqQr0S+OOWcPdFArwop2QZzn0H
	ixsfGDRyIPdX4J5AohUhXqp8mlx2pmYwSPERs0LIHGhzwBkHIpnx0ttVBBHT69TSIaZKML
	aC0Tz6sz4gs4Oka/6vr4HrvVEjW9P1s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HXSRoY4F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of kuba@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kuba@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755096736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6wpMcnJZf4dP4zTrQRxN2TvFNKFBXWRlxzAryJbb7m4=;
	b=VF6JghARu6GB3vvvbmoh+ripB86qayNNJUjm0cI8fj2y9r3hh2fk3v1ne1VcOtvg/Amem/
	T++LKivK0LjG0kXp/ErlFoMjjGm5F5ovfWkgVWWDfRKMcdOm5gK5fE0hMNiVRtxgg0Vw2+
	A2WuSJVYKDsGO0kiWujuPyiZy5k2Vy4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0101B601F6;
	Wed, 13 Aug 2025 14:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4F7C4CEF1;
	Wed, 13 Aug 2025 14:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755096734;
	bh=yF8iCt4IcxBj81Mp1kvQhhC5dKj1tFO3WDbfBuoASjQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HXSRoY4FX97/bGSoskS9rX3kbLNHbhMECHrpExOw3SjAhO+sutt0wNIt+hXguYqFz
	 acOrnwIq662t2uH/Pkk+7zDE8qZpdbkHmHHAOfqQwBcKJJyCXYPBsuQso8zFZkC8wc
	 erGdkydwLPI2kjby/RJhn2Ues8nq7SX9WGDBoI3FpERRf1p1vq/7Gg6L9vYkY8r3yv
	 /UTzDE2v+NTni4xTqnaSIoDLmtE+MWUd4MJgORxpfzwpU05jPd/97lVDP2xRhtyicu
	 kd6cGBBqNP8JClWYuCW6Zn6N1Kg15PCa2VQb8UCi/ux4QHe6NCO7XLvlVcwo0EiNp3
	 Pe3CylL1s7ueg==
Date: Wed, 13 Aug 2025 07:52:12 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
 sdf@fomichev.me, saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 mbloch@nvidia.com, andrew+netdev@lunn.ch, edumazet@google.com,
 pabeni@redhat.com, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, horms@kernel.org, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, ilias.apalodimas@linaro.org,
 willy@infradead.org, brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
 usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
 almasrymina@google.com, toke@redhat.com, bpf@vger.kernel.org,
 linux-rdma@vger.kernel.org, sfr@canb.auug.org.au, linux-mm@kvack.org,
 netdev@vger.kernel.org
Subject: Re: [PATCH linux-next v3] mm, page_pool: introduce a new page type
 for page pool in page type
Message-ID: <20250813075212.051b5178@kernel.org>
In-Reply-To: <6bbf6ca2-0c46-43b7-82d8-b990f01ae5dd@gmail.com>
References: <20250729110210.48313-1-byungchul@sk.com>
	<20250813060901.GA9086@system.software.com>
	<6bbf6ca2-0c46-43b7-82d8-b990f01ae5dd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bncgwa44ekst5hf81pb8ygy5e6is9h3s
X-Rspam-User: 
X-Rspamd-Queue-Id: 004D14000C
X-Rspamd-Server: rspam02
X-HE-Tag: 1755096735-641013
X-HE-Meta: U2FsdGVkX1/F5bOtV5ymFloBLgmxxhzkjkzRiI8N5zo2tBvxzjs58mSDcaoBMiKOGvjZAvQqFaHQYz4iBYHNh7IeCASNqUa+7X/T7UvVkrlTuUzP5mVw/t42OM6koJoXM9v2BRaElkbSzbbl+jV9kGOBMvIp4/F5Dtqn05sL19GcXuA0HpVKLIVA7Ta4WXps+1rF+yAx8sKkaxkCE1I0Ys8STAUxV4xin8FXbgLdWQBOCFtfzo60HKx6REDUjnoUTnd9tr8iqte2MmNh0eEMku1HKtPGP6vKtttMU7uz8QJK4joOuaB7Sa1L6LlnhAMz2z15bcjLjrOnTlD8AQDp+AME1QUhbg7pEzLJorM2K+azy7dswP87tEi5FL8G/aHfsKwOk1VdCKm3zsBeAhuqh+bTHcZkM4MHA1lJRWLxAARvFAFg4GRE7TcmV/TYmWFqDhp69G/5y7Iz82Mp7VMdXHnrxJgEb+JSFCdIF79CNkF8vJ7c6uzB5gFhAbu/4h/YcEbJVE0nXTav8419mZdN06iYgyrwtoX68+yByhLwIGAtRQPnPDkvC3A8rcRhzcvOCON3Ng6TtEVKxJIjC0sFfxY84zGP++CFNDIxx0SbsKzNs4QsLHska57Q0dw0FKpYKdspn39VkwDKeDaCKE4FPKCCgAfb78chk0TTbpsjAs27SCngXY8FGThayk/cBKfuLalTLbg3CgBGTglM9/6DEB10gWiKZJI9ZXW9/stL/BIJiloyKg+Wl603bjpK4oTuSF/z6WdzFIKE83x7CL0tkJVAwruVprD+RCKrt5EpdgcF3of0qjtT2I9ujg0gPLTV++LacYvmDmx6/Dqq6lktLRgvXte/nhbK5Rwg3DrghpI0fbPKxI497hynywYC1AfSeFijW4wtcGd2UsSflouEq9glFUYf8ZwEoDkWyWuobIF3YsQbX15DpW6/5fsNCU9fKT3YORCPS5w0EqbKQc9
 DsujXKYQ
 J7ZZ6W/Wdg7h7+oON6JMggMOYXuVoHadpEpmWWe0P7ng/rHpirC1g8KRxuS1bKLBoAJ0lrDHryIYtsMkdpra38O7teoZZ2qnS95ZG8M4zIM2mEB26WgMSFjybGo8psjIQ1dHCKNP6AQ30dmk+xiMM0Zhvzi/EsPW3z73+J45M15hXpIYWc35lBm/SEj1WPF6Kr3BzD61n2vKhp5kB5kjjLbxj09YlydBeFlm69ELWFAsqi/4YzaDDNQKoJMDyoF8rvdUbHl7OdJQO7VbIB5pAecHCh2vHCGUTitHwb5Kd2Db9YdLoc6DfEP9XsbuJF9QlRpk2CF6VzVI34ptRGpvkHvVPMwOcCS6d43PTXDoTq+h42OHjvqJ33OvDNxWscQ4O30TEl2itYJVWuVHHtM8ctrmMt6qRBB1Be0K6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 Aug 2025 12:18:56 +0100 Pavel Begunkov wrote:
> It should go to net, there will be enough of conflicts otherwise.
> mm maintainers, do you like it as a shared branch or can it just
> go through the net tree?

Looks like this is 100% in mm, and the work is not urgent at all.
So I'm happy for Andrew to take this, and dependent patches (if any)
can come in the next cycle.

> @@ -1379,9 +1376,11 @@ __always_inline bool free_pages_prepare(struct page *page,
>   		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
>   		folio->mapping = NULL;
>   	}
> -	if (unlikely(page_has_type(page)))
> +	if (unlikely(page_has_type(page))) {
> +		WARN_ON_ONCE(PageNet_pp(page));

I guess my ask to add a comment here got ignored?

>   		/* Reset the page_type (which overlays _mapcount) */
>   		page->page_type = UINT_MAX;

