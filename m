Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22A69CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:15:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FE496B000C; Fri, 12 Sep 2025 11:15:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D46A6B000D; Fri, 12 Sep 2025 11:15:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E9B06B00A4; Fri, 12 Sep 2025 11:15:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D5A26B000C
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:15:38 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0C83E140888
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:15:38 +0000 (UTC)
X-FDA: 83880947556.04.141B83C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id DFC07A001A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:15:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZQkPnZnU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=o9EJkBgC;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZQkPnZnU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=o9EJkBgC;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757690135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FWdXdLhM1N+CqR/OguV/6Acj3qPcJbiUisZav4LkXGY=;
	b=6e5Y83cBosrP1zerMyTzdmTgLpRvIyNR65GbDtrubxR6Wljv/rLTqWWESfT6h5FZubY/Cr
	+6E6kCmi3l+XPEllYYosCry8C0AtU1JTYRfOjwNyzhyj8JtUIg3leVxHwrnUKefHTmTr+Z
	efPnPMacgdBsmEkcQQo65mY2tNgsWSo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757690135; a=rsa-sha256;
	cv=none;
	b=Eq+S0g1kdIygodYZoQJ5Oj+BYfXG/tOyDpWUAhM2A5yx5SRP+ibQEKajCAsyQ0zm5Hj2fZ
	fQny52VU+MlAuDpx+K0xDdTQOOC6V0s/BGe+J0kGSlUxxJ+22fXTF6fRSCA5vCTg1GRp+0
	ziThvMHblrFqdsWnWDARgfO2pURaj1Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZQkPnZnU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=o9EJkBgC;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZQkPnZnU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=o9EJkBgC;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9819F5F89F;
	Fri, 12 Sep 2025 15:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757690132; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FWdXdLhM1N+CqR/OguV/6Acj3qPcJbiUisZav4LkXGY=;
	b=ZQkPnZnUu0qs3kJEusmuAXceM6Cr2U2hTKszSrPMNpY2THiPZeW/Juuus6RPE2J94Y8IQk
	CEkqZwKLD3dlDwefjM+0IUpZo0a0CnkApYDdt1MtFrVgEfmsQn7PctIVYwdPve20guNUI+
	ZRjYiJbsdYTcQ1gs3ZC/4H+K7PDpU2k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757690132;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FWdXdLhM1N+CqR/OguV/6Acj3qPcJbiUisZav4LkXGY=;
	b=o9EJkBgCdfy9n0AMynRlG7cd+7nwcG2V+Rxk2lHxoLENnKZiD+UnslU7EURZvxnDhezG2O
	10PBsEc2Ijyq+cAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757690132; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FWdXdLhM1N+CqR/OguV/6Acj3qPcJbiUisZav4LkXGY=;
	b=ZQkPnZnUu0qs3kJEusmuAXceM6Cr2U2hTKszSrPMNpY2THiPZeW/Juuus6RPE2J94Y8IQk
	CEkqZwKLD3dlDwefjM+0IUpZo0a0CnkApYDdt1MtFrVgEfmsQn7PctIVYwdPve20guNUI+
	ZRjYiJbsdYTcQ1gs3ZC/4H+K7PDpU2k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757690132;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FWdXdLhM1N+CqR/OguV/6Acj3qPcJbiUisZav4LkXGY=;
	b=o9EJkBgCdfy9n0AMynRlG7cd+7nwcG2V+Rxk2lHxoLENnKZiD+UnslU7EURZvxnDhezG2O
	10PBsEc2Ijyq+cAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C73C713869;
	Fri, 12 Sep 2025 15:15:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fndjLRE5xGi0MwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 12 Sep 2025 15:15:29 +0000
Date: Fri, 12 Sep 2025 16:15:23 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Kiryl Shutsemau <kas@kernel.org>, 
	Nico Pache <npache@redhat.com>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, 
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, 
	baohua@kernel.org, willy@infradead.org, peterx@redhat.com, 
	wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com, 
	vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, 
	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com, 
	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com, 
	jack@suse.cz, cl@gentwo.org, jglisse@google.com, surenb@google.com, 
	zokeefe@google.com, rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, 
	hughd@google.com, richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz, 
	rppt@kernel.org, jannh@google.com
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
Message-ID: <hcpxpo3xpqcppxlxhmyxkqkqnu4syohhkt5oeyh7qse7kvuwiw@qbhiubf2ubtm>
References: <20250912032810.197475-1-npache@redhat.com>
 <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <d0e81c75-ad63-4e37-9948-3ae89bc94334@redhat.com>
 <20250912133701.GA802874@cmpxchg.org>
 <da251159-b39f-467b-a4e3-676aa761c0e8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da251159-b39f-467b-a4e3-676aa761c0e8@redhat.com>
X-Rspamd-Action: no action
X-Stat-Signature: 6hciz1orj4ofg4dhi1oqbfuuj1wpkbxc
X-Rspam-User: 
X-Rspamd-Queue-Id: DFC07A001A
X-Rspamd-Server: rspam10
X-HE-Tag: 1757690134-95637
X-HE-Meta: U2FsdGVkX1/sodxvrQnPwTPXiWWeJj2H1WomZ9OpzODMTMY/ZbcGGvsd8M225s9t2RIMZWJQIf95zchHijC+lEfqfaXhm9QIZDfJcHBoF740VIXEeZtm6vadN0fqn3HUiBGc1F8fHS/9/ePQ4ZjlVAemRnoYPBeGQ1vUHkmaGWnA8rkoZO5Uh7tsJ5grknLzYKn4ttmA8cPwWyycl37SPZOaOP1kTMdUYJgRRL+e0SUozunjVabR/7qeg88KNhO4Kez1Lv3DWEdZrL1YrzJ2LgCd7tHYaSd2+8oISriG6TbNuuXANLEJsAAR32RdcJAVSvi/QPgcFCj4utASpcBpMExIS3bv+BKJHomKLZzzdQlIbbcSruBEyrh6suT3UUFPg2MkUb0rW2zUUdeZS8EV+IJZlJochpa4EuELQ28iqGXZgNt5UDcVBIBtgMNCqcIE/m3nID/vvMtsZzfZusto2vinIt57oP/0BHi9Tm4xa08j2+cp/6Q2KGHS7uuh3nLbDHkxUax7Af3+adX1jctGvcRMoekgoq8zaSqfevuTr7YNMFPOs2xZ2FYnunSvI1snBkPQQ0/cNEYQvzaNrHhFZ6jFSaBiK9mjuxpANtHbilbB2G4+rqjAZ72R4NDl+92AL8p5fgnCNcwGTEYDkOyzGymNbk/c+OoCmIijjGExt6Y9barIe64NHOKioTugPuVVzhD4sGxPNGNypnsA1bOV9hsDON3TJFmGUnw+fe/Xvlc/bIyypYR3iaGunSDWJvMih/FvnY7hPsZnNMSheRQ78cXunbCr4KfdwDoVYcAAyqyEcEy4F3QSzJoucpjf5Cd1dfH23MZ7qnPTubWk7zhQdJQg0UOxjWUzVtCZ61oMoAT3Pu01O/ojR2ucnOuhgjfzg9yFJM0EON8aY1GDMVn/t6qTuWbedROB6/RSfxmKtrhCDRyLT1FPSZjcCs/8b2wCHsyLHMjgZtlCI1bBA3z
 LrI6iEOA
 Zb5ffY8vc5f/m+/cdJkk+yFLt9eKkv96Y+eDVLK8soMBLzw74WafKDIQFcHTvdYj/UwQQib01iVU5Fjcl5kAWuDN5R0auokSkWsW4KIq0a9QIHmiFdF1whw1ltjDrcWq3FgDBVssSq8lvUjMy7jCIx9UpB7bT1oQT7HzamIyUWYz3HaO4wUyOrzjfMaFouPaGx007RehXPvTih9vAIXRjn0hSEPAOGmuFy2ErtY0xv+oyBZjHrrXJTwC2HXFks51n74996vupysetZci4C/WptzHkeBW0EXIvUxlEvCbjTl9Aoh67tczDmlBWCZScukrfqFmItDA8yamPAonXkKS1C+ZmhNEFJU8W11nSXnXM74FR7t2X30Z0xmS9hQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 03:46:36PM +0200, David Hildenbrand wrote:
> On 12.09.25 15:37, Johannes Weiner wrote:
> > On Fri, Sep 12, 2025 at 02:25:31PM +0200, David Hildenbrand wrote:
> > > On 12.09.25 14:19, Kiryl Shutsemau wrote:
> > > > On Thu, Sep 11, 2025 at 09:27:55PM -0600, Nico Pache wrote:
> > > > > The following series provides khugepaged with the capability to collapse
> > > > > anonymous memory regions to mTHPs.
> > > > > 
> > > > > To achieve this we generalize the khugepaged functions to no longer depend
> > > > > on PMD_ORDER. Then during the PMD scan, we use a bitmap to track individual
> > > > > pages that are occupied (!none/zero). After the PMD scan is done, we do
> > > > > binary recursion on the bitmap to find the optimal mTHP sizes for the PMD
> > > > > range. The restriction on max_ptes_none is removed during the scan, to make
> > > > > sure we account for the whole PMD range. When no mTHP size is enabled, the
> > > > > legacy behavior of khugepaged is maintained. max_ptes_none will be scaled
> > > > > by the attempted collapse order to determine how full a mTHP must be to be
> > > > > eligible for the collapse to occur. If a mTHP collapse is attempted, but
> > > > > contains swapped out, or shared pages, we don't perform the collapse. It is
> > > > > now also possible to collapse to mTHPs without requiring the PMD THP size
> > > > > to be enabled.
> > > > > 
> > > > > When enabling (m)THP sizes, if max_ptes_none >= HPAGE_PMD_NR/2 (255 on
> > > > > 4K page size), it will be automatically capped to HPAGE_PMD_NR/2 - 1 for
> > > > > mTHP collapses to prevent collapse "creep" behavior. This prevents
> > > > > constantly promoting mTHPs to the next available size, which would occur
> > > > > because a collapse introduces more non-zero pages that would satisfy the
> > > > > promotion condition on subsequent scans.
> > > > 
> > > > Hm. Maybe instead of capping at HPAGE_PMD_NR/2 - 1 we can count
> > > > all-zeros 4k as none_or_zero? It mirrors the logic of shrinker.
> > > > 
> > > 
> > > I am all for not adding any more ugliness on top of all the ugliness we
> > > added in the past.
> > > 
> > > I will soon propose deprecating that parameter in favor of something
> > > that makes a bit more sense.
> > > 
> > > In essence, we'll likely have an "eagerness" parameter that ranges from
> > > 0 to 10. 10 is essentially "always collapse" and 0 "never collapse if
> > > not all is populated".
> > > 
> > > In between we will have more flexibility on how to set these values.
> > > 
> > > Likely 9 will be around 50% to not even motivate the user to set
> > > something that does not make sense (creep).
> > 
> > One observation we've had from production experiments is that the
> > optimal number here isn't static. If you have plenty of memory, then
> > even very sparse THPs are beneficial.
> 
> Exactly.
> 
> And willy suggested something like "eagerness" similar to "swapinness" that
> gives us more flexibility when implementing it, including dynamically
> adjusting the values in the future.
>

Ideally we would be able to also apply this to the page faulting paths.
In many cases, there's no good reason to create a THP on the first fault...

> > 
> > An extreme example: if all your THPs have 2/512 pages populated,
> > that's still cutting TLB pressure in half!
> 
> IIRC, you create more pressure on the huge entries, where you might have
> less TLB entries :) But yes, there can be cases where it is beneficial, if
> there is absolutely no memory pressure.
>

Correct, but it depends on the microarchitecture. For modern x86_64 AMD, it
happens that the L1 TLB entries are shared between 4K/2M/1G. This was not
(is not?) the case for Intel, where e.g back on kabylake, you had separate
entries for 4K/2MB/1GB.

Maybe in the Great Glorious Future (how many of those do we have?!) it would
be a good idea to take this kinds of things into account. Just because we can
map a THP, doesn't mean we should.

Shower thought: it might be in these cases especially where the FreeBSD
reservation system comes in handy - best effort allocating a THP, but not
actually mapping it as such until you really _know_ it is hot - and until
then, memory reclaim can just break your THP down if it really needs to.

-- 
Pedro

