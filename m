Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0992DC83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 01:49:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F4786B0092; Thu, 24 Jul 2025 21:49:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CCCF6B0093; Thu, 24 Jul 2025 21:49:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 909846B0095; Thu, 24 Jul 2025 21:49:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 819A86B0092
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 21:49:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2582859993
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 01:49:07 +0000 (UTC)
X-FDA: 83701103934.12.6216EF4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 790201A0005
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 01:49:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ljK7JmZQ;
	spf=pass (imf19.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753408145; a=rsa-sha256;
	cv=none;
	b=3w/41Fu1C9VZolL55g08f1H50YQfZHkZyis9BsZ+ONSj7ziHeLjQe6HIWkIbhTFktGzjp1
	S9xAaPBOPdl7RR3tRQKw224d83tgQzoGWxuy3Khpv20SQoQPwCD2TXLoWb1Ht+wydM3nr4
	CAXhL7Gmk5MOlc+mh3aRktrsVmNaMqg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ljK7JmZQ;
	spf=pass (imf19.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753408145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jWx3eKBBgPJlwdaPgHMi88K7XhIW+XvTgVo4Cv9foLM=;
	b=tIBgyQ9tNHfBV/tCKQq3odsn8vcGjDPOW2ybYUr5PewotVue4dhBN+BBonSEDZ8Krvbp98
	A4+HHzTgo1ttCra6RyQuezjUJuc+4n0Jgm/hpb2HG3hKJJh7yMZiBMmJDI9xb2PybJhUXU
	C/aKlfFG9BL46pPPXJQssH7qvUosVgY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DEF6438A7;
	Fri, 25 Jul 2025 01:49:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282F6C4CEF8;
	Fri, 25 Jul 2025 01:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753408144;
	bh=B9lc7fM1jtUNpSTwiyxqs6LzGFpaNCIpPSEYy36++8Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ljK7JmZQNB6d1Y/lUQP5CBvKozqg+TyROpDUceazY6iMAN8OuIt6uHoqKKI1QqhQQ
	 VPS7JDHxK37SG0cOun0Bluuge524GKVNPuV9c1x0SNM9Fm24CkO/aPLHI1Isvl3Nx5
	 Ly3pcKP4ToDd4xBEgAzi9qRYb9uXHGDDKAETosrcvBsC4u6MUdKm8dg0eosxnVcGdF
	 2Djc58PEZKUsOWJqougd3xp2AGJqp160jdWiimNOc/Ni0ejvzqzzvzi8nFN0MVc2L1
	 Ifq1//hazBkRKLIzPfjZWkVa1KwrehqzM/6l1q7j/HQeF+//VaRosSmsswp8lAl275
	 756B6ApoYH2Dg==
Date: Thu, 24 Jul 2025 18:49:02 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Eric Dumazet
 <edumazet@google.com>, Michal =?UTF-8?B?S291dG7DvQ==?= <mkoutny@suse.com>,
 Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>, Neal
 Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, Willem de
 Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, Mat
 Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>, Muchun
 Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuni1840@gmail.com>,
 netdev@vger.kernel.org, mptcp@lists.linux.dev, cgroups@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v1 net-next 13/13] net-memcg: Allow decoupling memcg
 from global protocol memory accounting.
Message-ID: <20250724184902.139eff3c@kernel.org>
In-Reply-To: <CAAVpQUDMj_1p6sVeo=bZ_u34HSX7V3WM6hYG3wHyyCACKrTKmQ@mail.gmail.com>
References: <z7kkbenhkndwyghwenwk6c4egq3ky4zl36qh3gfiflfynzzojv@qpcazlpe3l7b>
	<CANn89iLg-VVWqbWvLg__Zz=HqHpQzk++61dbOyuazSah7kWcDg@mail.gmail.com>
	<jc6z5d7d26zunaf6b4qtwegdoljz665jjcigb4glkb6hdy6ap2@2gn6s52s6vfw>
	<CAAVpQUAJCLaOr7DnOH9op8ySFN_9Ky__easoV-6E=scpRaUiJQ@mail.gmail.com>
	<p4fcser5zrjm4ut6lw4ejdr7gn2gejrlhy2u2btmhajiiheoax@ptacajypnvlw>
	<CAAVpQUAk4F__D7xdWpt0SEE4WEM_-6V1P7DUw9TGaV=pxZ+tgw@mail.gmail.com>
	<xjtbk6g2a3x26sqqrdxbm2vxgxmm3nfaryxlxwipwohsscg7qg@64ueif57zont>
	<CAAVpQUAL09OGKZmf3HkjqqkknaytQ59EXozAVqJuwOZZucLR0Q@mail.gmail.com>
	<jmbszz4m7xkw7fzolpusjesbreaczmr4i64kynbs3zcoehrkpj@lwso5soc4dh3>
	<CAAVpQUCv+CpKkX9Ryxa5ATG3CC0TGGE4EFeGt4Xnu+0kV7TMZg@mail.gmail.com>
	<e6qunyonbd4yxgf3g7gyc4435ueez6ledshde6lfdq7j5nslsh@xl7mcmaczfmk>
	<CAAVpQUDMj_1p6sVeo=bZ_u34HSX7V3WM6hYG3wHyyCACKrTKmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 790201A0005
X-Stat-Signature: 3w3xr7w7ctdmkmf8x4dafn59gd97iw8k
X-HE-Tag: 1753408145-604194
X-HE-Meta: U2FsdGVkX1/Ul6eYFgdZO02DRP2FA9GPaJbFU+nQQ3FUypr3CDwkTUO7hWNVszfiRUDCW2cOnw67eSdu/4USLuqm+XTFq7RAf65jTzfjNWi2S+HVNDtdpqcWHaQ5Xlw4jAK5yHOaqUbXLEXKcD7n7M2LFu2H7RvKwILrOFlQjkuhl2rRORSH+Mh5xamHmbEu/sNhfW2489oxzrJ6WtvzrkVXbPG5TaLphPHzNFaIr69zRo8ljkEzsQA8zDodmJh/1zqQnvSbryvMulfkurAetWD86/otJBx1vsfMV78x5nb2MI6ViVc61tROyQcS4Icppyx2+CUbsXbAVMIV6RZ7tuXIFPaQKUu3yOUhRL+RzSPRy2CkzbjQV8JmcVj0WWUHgyMJWfJmfElYIsRlMltFUTS3V6aQBBMDpYbuiw+B2jgZFzrugzTGbPa/C1YLeuFKVwtrmCtODX+o3fWTJOlJPEVV2pDwElxqKgB7NoLESIBGcTa7pPiH35f0eI65p9wfUVPu2qNOOqkJKDIErjEXut1zvOMLMBK9/8EFki9I9tt1rSWXnrBZiJGurmbq4cEQ8/pqkJWpb8pqI71Z+eTAB7mPUon/NXnKimpmv6mrfLMuvMTsDOxhNsOevNuxEo9tJ4xhIScLDT9SexsyQ2tWimr2P9qTvsEROzZ1TER/bDj/ekC33OY2Z/EZH/Fhyg1+DP/9FYFaYixkFBZ6H2utTOBnK3JhhsYoxulnRY8JnZn47qeRacswo8WXjkKCh1WwajnQPuPkAR6PJxFpNPHpAQr+dVhBAmPkq0q3bRxFCMM00Cwm0VJz/47rz4x4bqHbDlFclyrb1MV2h+CnTtHJUZblmv6MoIrjgoyfkem26noTT2I2MhKZnWii+iwCOyfUCkqPuKG4X8UO1K6ZXZoB3T+rjxvtS1L9hq0JI1HTx3KHRgM2V+6hZEYPw76a2IN8Vc7qpuUhHyVqmGl0Ajh
 fV7oVZ87
 un5EN2K5/8Ppj8XJ+oI7YsK9HgpUDvrj7VTXQoy0BunT5JAZhuiJ+186JGBY5Xm0kSTp9ObQCNmK35rdrjcnUP1Ih5z68ZMiNuRY8XJ1E7yxJV7OLUUgDUyQvpY1uTdQr4Coe0S7oVfJmlgecWUMtP9Bp5W5Kb+NamTsCti7DUhZJcSAp9PjDeeWI7ezyTBjuoccwkR57nXjptcJzv/i6WBbyMHVTWTT/UJmp9LnmEX93vDYfMkbuX5FW3VI7XKQyCa81
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 23 Jul 2025 11:06:14 -0700 Kuniyuki Iwashima wrote:
> > 3. Will there ever be a reasonable use-case where there is non-isolated
> >    sub-tree under an isolated ancestor?  
> 
> I think no, but again, we need to think about the scenario above,
> otherwise, your ideal semantics is just broken.
> 
> Also, "no reasonable scenario" does not always mean "we must
> prevent the scenario".
> 
> If there's nothing harmful, we can just let it be, especially if such
> restriction gives nothing andrather hurts performance with no
> good reason.

Stating the obvious perhaps but it's probably too late in the release
cycle to get enough agreement here to merge the series. So I'll mark
it as Deferred.

While I'm typing, TBH I'm not sure I'm following the arguments about
making the property hierarchical. Since the memory limit gets inherited
I don't understand why the property of being isolated would not.
Either I don't understand the memcg enough, or I don't understand your
intended semantics. Anyway..

