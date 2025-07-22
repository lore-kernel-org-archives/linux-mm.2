Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 345AAC83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 01:03:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 941D86B0088; Mon, 21 Jul 2025 21:03:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 919CD6B0098; Mon, 21 Jul 2025 21:03:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82FCF6B009A; Mon, 21 Jul 2025 21:03:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72E606B0088
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 21:03:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1BBCF12F293
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:03:37 +0000 (UTC)
X-FDA: 83690102874.19.CD3B774
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf26.hostedemail.com (Postfix) with ESMTP id 75A2F140004
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:03:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753146215; a=rsa-sha256;
	cv=none;
	b=xQ4AkCH8OvMGrXC7VgPXY9tpw8FvXIIHe5mh/QwtIEYfhHNKSTLO0mPYCoc8mdlRQTpL8n
	SXrdV94VF8FYBCxNazieHdXjBCq++RszEMAG/fU6aauocYM+VcUttB49KRcFoaCRCJCGU4
	zCPJwgwTg7UCGCLmqhmDhJSdMjLKJTo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753146215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eKMA+DmJEBDsx5P3EbPUzwqPycdJu1fi/FqkB9aOSUI=;
	b=IhED4+KSA8Hh16dOM5qzl3X4qj1SgaiTY3eEPXoiJtPH6PZehTO7cYU5Jtm4Xe/Wg28TGs
	5vfOC3VnmfLTRiXZjVw2PlMgFln+4DoC7W5PGrtNodhB5DGkErIYNR1Fy8CgK4Q3XnFtL8
	/Z0h7pQSXFFgBHAdaJE0Kwxmoy9BbZA=
X-AuditID: a67dfc5b-681ff7000002311f-88-687ee3638325
Date: Tue, 22 Jul 2025 10:03:26 +0900
From: Byungchul Park <byungchul@sk.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
	davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
	john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
	leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
	andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
	akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, ilias.apalodimas@linaro.org, willy@infradead.org,
	brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
	usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
	almasrymina@google.com, toke@redhat.com, bpf@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH] mm, page_pool: introduce a new page type for page pool
 in page type
Message-ID: <20250722010326.GA45337@system.software.com>
References: <20250721054903.39833-1-byungchul@sk.com>
 <77ee68c4-f265-4e55-9889-43ab08f26efd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77ee68c4-f265-4e55-9889-43ab08f26efd@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRiA+c45O+c4XJ2W1VcWxLoIk25S8HbF/n1/pKAIWlANPbTRvDDT
	tIutNCpLk8rKuWIV6XTCasbczFnO5a0f2bq4tLTsAqGtslzZTNuUqH8Pz/vy8P54eVrukMzh
	tWn7RH2aWqdgpYz0U/T1Jclv8zTLXWeXgclWw4L1Zw5UvnZKwFTtQPB9pIeDcXcLgm/eVhYG
	mocQ3LgWpMH0qICBYdsvGt639HNgtSdBX8UHBhpO1NHQf7aNhaKCEA3ukQAHx5wWCky1Bg46
	HcUSuPDrJg11htccPKk3sdBbMy6BD54iBtqNVQx8KfXS0FecCC3mmRB8OIjAa6ujIHjmCgvP
	yuopOO8zs/C2oA+Br7mfgdLRkyyUHy1GEPoZrgVKvkug/EEvl6gkzYOfaXKn6gVF/I0dFHEZ
	X3HEbM8itRYlKfT7aGKvPsUS+9A5jrx83sCStsshhrjerCYu5zeKFOUHWPL1fTdDPjc+YzdP
	V0nXpYg6bbaoX7Zht1Qz4LMxGf7onCpPt8SAnkQVoigeCytxZXuv5C8/db9kIswIi/ClbusE
	s0Ic9vtH6AjHCPF4oMvDFSIpTwsXOXzC1sBGBtMFFe40uKkIywTAv3/fm/ByQYNdNdfZST8N
	t5e9m4jSghL7xz6G9/kwx+LKMT6io4T12DjcxUV4hrAA33e0UpO3+XncdXrJJM/GTRY/U4IE
	439V439V47+qGdHVSK5Ny05Va3Url2py07Q5S5PTU+0o/E0Vh0d3ONFQ5xYPEnikiJbNN+Rp
	5BJ1dmZuqgdhnlbEyIJ3w0qWos49IOrTd+mzdGKmB8XyjGKWLCG4P0Uu7FHvE/eKYoao/zul
	+Kg5BmTdmeg7057VOvdhq7uowuqojwndOugwGMduK7TlStW9OK9quKMjocX5sTxuLze6cFr1
	+I/V0t6Nt4evhkqimywKe+OtIxaKGGqa8vjBg/NqzT2H1oZKvI+PrXp6PH67ShWr3Zaf/GM0
	STfTsiqgWFyxJmXT1vipSfUZgRtXpvQnKJhMjXqFktZnqv8AAVMpTEkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02SWUwTYRSF889M/xmaNhkr6ghKpEZNQHEJxosI4c2JicTEBxN9kFFG27CI
	rSIYJVVIUEIRFVRKibiwFm1SCZRVLcgixKWIVHZBMQbEhSXs2GKMvn35zj3n6TKkIkviwaij
	z4iaaCFSiaWUNDQwccvxwQTVtiq9AozmEgymqTgo6LdKwFhchmB8uouGxZoGBGP1jRiG634h
	eHBvkgTj6yQKJswzJHxuGKDBZNkPfflDFFQnl5MwcK0Jgz5ploSa6VEaLlsLCTA+0dFQl9Ms
	gTdlaRLImMkjoVzXT0NbpRFDb8miBIZsegqaDUUU/MisJ6EvLQQaclfCZMsIgnpzOQGTqTkY
	2rMqCbhpz8UwmNSHwF43QEHm3BUM2ZfSEMxOOddG08clkP2ilw7x5etGvpN8adEHgnfUviT4
	CkMPzedazvJPCn34FIed5C3FVzFv+XWD5rvfV2O+6c4sxVd8DOArrGMEr08cxfzPz50U/722
	HR9wPyzdEy5GqmNFzdbgMKlq2G6mYhyyuCJbp0SH2txSkBvDsf7cu5puysUUu4G73WlaYsxu
	4hyOadLF7qwvN9xho1OQlCHZWzSXbK7GrmA5e5h7o6shXCxngZuff7rkFayKqyi5j//4ZVxz
	1qelUZL14RwLX533jJM9uYIFxqXd2CDOMNFBu3gFu557VtZIpCO54b+24b+24V87F5HFyF0d
	HRslqCN3+mkjVPHR6ji/46eiLMj5MPkX565b0XjbXhtiGaSUydfpElQKiRCrjY+yIY4hle7y
	ySqnkocL8edFzamjmrORotaGPBlKuUq+75AYpmBPCmfECFGMETV/U4Jx89ChULPorT6xXjYm
	i8pbO9hz2mvXOeOXj8JPeOiNF8JM9wK7WlOfz4VerG/O3PFMef/lC/EQGeip929d9SpmpsG+
	8YPX7sWAIy0ZK0bnPlUftBYEt8tCBoyejy54mTYLGXRHeK39bsAxmRB0/nH/Nx9HozIev+1d
	E/FgtYoaKc3OtikprUrY7kNqtMJvRgCHhywDAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 75A2F140004
X-Stat-Signature: xa4bezfpefgtgdon3zwbosbecret8tym
X-Rspam-User: 
X-HE-Tag: 1753146214-619472
X-HE-Meta: U2FsdGVkX1+G1+EF8bd1EOVfpmz01MDvEtRXNkZaPpWw1AjQnzPYBYp40dABSgvGH3rjkbFYL+n/+6xHsWTbcbnhcqcYUQbKahzjBaJuhl1C3VATNX2d/uror8brXEr7BSGvk3F8gU7uxL0zbC4K+weSdmWhmFPzjxIxaqZ0ku8mvHG1JQXRwwV7eFBNGqG5tZpzs7LnEEoH5Gg7XBAnGN3+aRGWqhf4sf+KQJnaKGinvwDpaIxBJkwerLE+X1fVBMrdNC3xVojw5Nv0NR8Ep+yYsRyHdRpVg22LaBB2LPyD1TuuUoxIuwFT9VqZiWPV4IJ4sRTn4uFCGVUbMM9/A0lkmjhWBm+SyXRS1+mgmqhOKW5QjIwShQuxYGrqOlzbROegTs2DmI6ROyj2CAsv/ZS0Pd/EQA48SdPEGcIEJUuSdBVEH1n2ibD0vDxcZsZB593+rXWjv9DiIx5DdhrztZi+0CrIF5n3sN5kYzjJ7kg2LumDW/b/pYnHS+dAt5HlYwupEqpmNpqBDZiyPw4SL+SzbXD1g/QBlqeSZWr3sY9PwPP4idy3IUHd40FYXBHbjdSH/ICFSmsCSLHi7LqnnxH2y48lFLJzAqFnRwZNI99ApZtcDNgPjdJ8qQl5+OPf8MYOq+vXYH7x7cNb8JyFJPvA8Mkjolylc+7zTPfmPkRmol8vX3vQl1fspyEGc2IPtY6esK8HuhfpeuSPDQC/cKodTunWUm63PYTA2iAvbp1hiOtmvPG2qIpzgYneo5KgghRm/Pjp/yVxKjTwxp4E0obcASJjVhgVny7nKpD9jLbXnEK9/+6hORric6ctlxcQpe3VTLKYwKYeOmkc0+TO9m1aS18L+51QiqGV65xqoSnPsxfBEtftjqs8CoDwMnb3W1JbJaP7inBHrzH6UPlLNMYADMU4sfX1+5vnDNf0Xnzhk45l6EyxhbUvlSAEJI5V/6+fIytP8bnjF5QHD8t
 gAi96WJn
 fHsjPHhXbRbfCN+DDdB47DSTKTt7AySoUw+hsbpjkaR4aDW5FkHFdKj0Cmix6VqNEYA3S8y9KYzpQzcDrnJk9+OvgjV0PDvA8g8CZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 21, 2025 at 12:12:39PM +0100, Pavel Begunkov wrote:
> On 7/21/25 06:49, Byungchul Park wrote:
> > Hi,
> > 
> > I focused on converting the existing APIs accessing ->pp_magic field to
> > page type APIs.  However, yes.  Additional works would better be
> > considered on top like:
> > 
> >     1. Adjust how to store and retrieve dma index.  Maybe network guys
> >        can work better on top.
> > 
> >     2. Move the sanity check for page pool in mm/page_alloc.c to on free.
> 
> Don't be in a hurry, I've got a branch, but as mentioned before,
> it'll be for-6.18. And there will also be more time for testing.

I'm not.  I listed the two items above wishing someone to work on it on
top of this patch in the future.

> > This work was inspired by the following link by Pavel:
> 
> The idea came from David, let's add
> 
> Suggested-by: David Hildenbrand <david@redhat.com>

Okay.  I will replace the current one with this.

> ...> -
> >   static inline bool netmem_is_pp(netmem_ref netmem)
> >   {
> > -     return (netmem_get_pp_magic(netmem) & PP_MAGIC_MASK) == PP_SIGNATURE;
> > +     if (netmem_is_net_iov(netmem))
> 
> This needs to return false for tx niovs. Seems like all callers are
> gated on ->pp_recycle, so maybe it's fine, but we can at least
> check pp. Mina, you've been checking tx doesn't mix with rx, any
> opinion on that?

I will wait for the answer of this before going ahead.

> Question to net maintainers, can a ->pp_recycle marked skb contain
> not page pool originated pages or a mix?

This too.

	Byungchul

> --
> Pavel Begunkov

