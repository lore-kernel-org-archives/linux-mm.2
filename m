Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BED1D606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 02:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IBxQWFNP
Received: by kanga.kvack.org (Postfix)
	id D37176B083D; Wed, 21 Oct 2026 22:18:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0E016B083E; Wed, 21 Oct 2026 22:18:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4AE76B083F; Wed, 21 Oct 2026 22:18:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A282B6B083D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:18:40 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 38CB8160707
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:18:40 +0000 (UTC)
X-FDA: 85348653600.30.3618FBF
Received: from mta1.migadu.com (out-82.mta1.migadu.com [95.215.58.82])
	by imf06.hostedemail.com (Postfix) with ESMTP id 300FF180002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:18:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IBxQWFNP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.82 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792635518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5FdXvp0CpV6t+Cak3H9/hip6PpHzjqeJ2F/KsA5v8Bg=;
	b=enlEleGmVVD9+auEnIS0fmCPG7biSMG01cvKSvRL+mhpCUCc7t72IvDSqXp3hEOiJuNEhI
	aVsHH4kD6ErhgUzDsNyklMJRrJRXSKoThCkHCK25xLpOQoAO5BIwuyCiQhBZumZBE4t6tg
	ltl+TkbyB6JztpAr8i2Pqa1qFs6vISc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IBxQWFNP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.82 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792635518;
	b=nqyWdC0cmn+qYguVfbshPcl3q1jKbpMjPakRU7I/e3cfN3SSwFebF0vqlcqsxSwS21m7ii
	oREloIoflTC+qqwUVt4z3Xg1b2bOTZg7/CoOSC5U1/4CZGuW3+V9TXjOro/GK3fJtwsKxP
	1fVsOizo176K0icdORLjIdXh222y61c=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MPi9YymNFv5TIm/0npc+3JpMtggtpk/tzZ51y3ItgYU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792635514; v=1; x=1793240314;
 b=IBxQWFNPCvnFrgSk8wNrkI7Oi/n4lRyy9RW2H4ACiAxmQo+skmFBWY2sjZuCvAUumhz1cqSC
 D19c9ufAOOOr5StR1gJsNJPR3IXEVxdRLOYYRwKOIasZF9J/E9sLrfcmRQY0jjVEbKCnvaVJ231
 DA0VtRiikZiT5pSlcn2zXRsk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 4b7912ba18c63ef4;
	Thu, 22 Oct 2026 02:18:34 +0000
X-Mizu-Trace-ID: 4b7912ba18c63ef4
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH] mm/page_counter: use WRITE_ONCE() for emin/elow when
 parent is the root
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261021204818.3431099-1-shakeel.butt@linux.dev>
Date: Thu, 22 Oct 2026 10:18:17 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Chris Down <chris@chrisdown.name>,
 Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <DE0BFDD2-1BE5-4FB1-AE66-1D4C7DFACA1F@linux.dev>
References: <20261021204818.3431099-1-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 300FF180002
X-Stat-Signature: g5xfur41xtssk4jm6ark64zmnu3oe3bb
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792635517-692941
X-HE-Meta: U2FsdGVkX183sFz7TY7NSuFQ6ihhhjAp2/CJGQk5kLbChZJjFAasEDjjYeylCQIO+5TyTWWh5uFEyaN/VBE4I/J2XMZHYVDtvmVhF4eyyEy/Hr3k9WZWUeKN5+h7JeeEaDtVOEOHCsFCiwOON4vyNhpk1G9popYi4JKE7Zkh2Y7FYbLxy6nrJoj95V9hDTVj7XYq11qzGcgdtBX+W0WAYqcv3m4bDwHenCdpNhSzYIBOipVnk7XqehzXGsXAHF2UTHnQzRr4y4WZ8yslsTyXhvMvyVvTw9R0dsKNYPyBSH1NEXQb85yPaIW7Y2JABFD48P3RwgG1f6E0w0CNn7V1vk62pR/Rj0HQjL5polROPC/+s5K4ps5sre9oRGtwo2XYdWCMrmeS4ZbRfMAky9MJt1uwmC6qNPjdiYbYzilNWL0unoQr1NaeC/78hEcYPYNGg+/FZwa6XXHr2GQFOxDlSMUEXheWjO6icaDyLdCm33du3m7sWNzPgut/2bPwQbjHDr3VSYufWLeig1IPLbWEsqfMRJqgqwm3x/fBjfvZ0/MjO0JxsPSaveR0MWnjvOgUXyIF2lPds1p9sR08+EW21aS/W5gTWxKv31Egt5+17Dk5WM1xiLw0QhTe2EX4odNbjOQxuFbNuSe9yM7T0U43ieETpqPlA22Tz3RzY+mwXFO8i3yrrrwo+Y4lxLHeBqc3W1YUEUKKTXR6mdBUIoH/PNY8J0f4CDRE9Jq0j0W3kpXQKovmjB5CFF4Ph7p9KxlPZ6aNKKQntfPY4TXmS2r1uU52faGqY1Cfun6g+i0RtVVFYcVEF9Clqrq/XpL/d8ZJU5H3g+UDwhp3+yy1gvu86Hos/a+HkQ9+75S3LSxKkysGtdJkQPnRF2bhZZfjOkbufYvpfR2lY4oLH5nKUWsA/uBOht43wbkZlUS0e2Abg0iH0YBRoXTuVO8XMNRT1QuKmDBWup3f77lWQ3kQzkE
 MANBAUG7
 t3UAil0hAX+kdD6zB9GiYlJz1eZXM9u9wwLtHonF7Zd6oe9qYycyw/etQli6narfBdhz/oj8uJHE3FkRHBLe12iJTCFLrDWzbguM5PdVMIshJQNEloIV4ocj/+12rismAcyc/4kol8244dGJ5/RI0xatgzQPoBNwYXA69BKubxGA2iWJr9W+m9nfag7gf24L314jjAiLC2R6udhauhWLTwP6ZTuXhFlXBOTCyHxOAv7AsQlpvyEaxJLH5amqxaged7kggG2oPhCs5eeN2e9VJebd2YkVXjIdTrWrLtb09Oe87eeCcywc0Mi7PHfGIDFD51Y2OCYiC283GZrt8cIdtRw+DE0UEcJMbHjDo/A6a4PbhFxkDoCounyvdKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 22, 2026, at 04:48, Shakeel Butt <shakeel.butt@linux.dev> =
wrote:
>=20
> page_counter_calculate_protection() runs without locks. Several
> reclaimers can update the same counter's emin and elow at the same
> time, and readers such as mem_cgroup_below_min(), =
mem_cgroup_protection()
> and the dmem eviction code load them with READ_ONCE().
>=20
> Commit b3a7822e5e75 ("mm, memcg: prevent mem_cgroup_protected store
> tearing") made the main path store emin and elow with WRITE_ONCE(), =
but
> it missed the early return for a counter whose parent is the reclaim
> root. Those two stores are the only plain accesses to emin and elow
> left.
>=20
> With CONFIG_KCSAN_STRICT=3Dy, a few tasks writing to the same cgroup's
> memory.reclaim trigger reports like this within seconds:
>=20
>  BUG: KCSAN: data-race in page_counter_calculate_protection / =
shrink_node
>=20
>  read (marked) to 0xff1f91b146d40e40 of 8 bytes by task 163 on cpu 4:
>   shrink_node+0x57a/0x1210
>   do_try_to_free_pages+0x194/0x930
>   try_to_free_mem_cgroup_pages+0x204/0x3f0
>   user_proactive_reclaim+0x28a/0x4d0
>   memory_reclaim+0x35/0x50
>   ...
>=20
>  write to 0xff1f91b146d40e40 of 8 bytes by task 167 on cpu 6:
>   page_counter_calculate_protection+0x1fa/0x360
>   mem_cgroup_calculate_protection+0x4e/0x70
>   shrink_node+0x53e/0x1210
>   ...
>=20
> The default KCSAN config does not report it, because it treats aligned
> word-sized plain writes as atomic.
>=20
> Use WRITE_ONCE() for these two stores as well.
>=20
> There is no functional change. Readers already accept stale values, =
and
> compilers emit a single word-sized store either way: with GCC 14 the
> x86-64 object code is the same before and after this change.
>=20
> Fixes: b3a7822e5e75 ("mm, memcg: prevent mem_cgroup_protected store =
tearing")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


