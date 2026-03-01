Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29FDEFD0047
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 20:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 395326B0095; Sun,  1 Mar 2026 15:26:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 343046B00C2; Sun,  1 Mar 2026 15:26:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 224656B00C3; Sun,  1 Mar 2026 15:26:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0B4036B0095
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 15:26:58 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9FD2F1B89F5
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 20:26:57 +0000 (UTC)
X-FDA: 84498628074.09.D7B7424
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9A305120004
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 20:26:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VH+6tfL5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=A49IE7lw;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VH+6tfL5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=A49IE7lw;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772396816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CExDPqa+dlHIiyZmaDscrvfrm3ntmIRTbpDYzSMYTsw=;
	b=N3i/IkuK0SaPABuL8gT/MhHbCT3De/zo+OulFF6UVqAU1eGvqbkhxyQ2sj5ugkXiaqSGis
	jVUPBxGoF1uBYXzDbxVBTvbwI5hduwStKDdmUoAM81AtSBKc35fSY2YBVCubUu92Lr+KJ1
	4aoBEjorsqBaShk8l1WMcuio0MSB/pk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772396816; a=rsa-sha256;
	cv=none;
	b=M2Fd6vhO2BVA6Yp3nOvxIEZBX5J55Xh12wo7ch2eqSZnuJ277fhvaREPusHotCO2aLV0xp
	YIxnaoND7DP5czsMpgFiF9JccAzvZdYz4lYr5vSP/5eCFfS0Vfdn/+huDdT2+M19cHeLYr
	hfeVQkOYKUjisDH50gjyAXbqFjhTSQE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VH+6tfL5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=A49IE7lw;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VH+6tfL5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=A49IE7lw;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C7AF95BCE2;
	Sun,  1 Mar 2026 20:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772396813; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CExDPqa+dlHIiyZmaDscrvfrm3ntmIRTbpDYzSMYTsw=;
	b=VH+6tfL5LEBrILabK484SUQq2F4GjuQVT9L9AvWHT7q9viX3Fy2khgmJTqJKEBNweNPvR9
	nbkrEFNr7lYmxfHJ9EdfqxbdgrnIK9U8j3JK1tZKLpMCr+/E7kISctyKIO1D7UxvyJa6Uc
	M67azu0xgR0GqsvoTeCYYla/V6FLmDE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772396813;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CExDPqa+dlHIiyZmaDscrvfrm3ntmIRTbpDYzSMYTsw=;
	b=A49IE7lwAq+c9XVlGbHbx8iebjoOxRMaS3yZ2NPuOncBOGttajMJkOMQmR6c1q8mafXbQp
	szpqCfoCcsuU0GAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772396813; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CExDPqa+dlHIiyZmaDscrvfrm3ntmIRTbpDYzSMYTsw=;
	b=VH+6tfL5LEBrILabK484SUQq2F4GjuQVT9L9AvWHT7q9viX3Fy2khgmJTqJKEBNweNPvR9
	nbkrEFNr7lYmxfHJ9EdfqxbdgrnIK9U8j3JK1tZKLpMCr+/E7kISctyKIO1D7UxvyJa6Uc
	M67azu0xgR0GqsvoTeCYYla/V6FLmDE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772396813;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CExDPqa+dlHIiyZmaDscrvfrm3ntmIRTbpDYzSMYTsw=;
	b=A49IE7lwAq+c9XVlGbHbx8iebjoOxRMaS3yZ2NPuOncBOGttajMJkOMQmR6c1q8mafXbQp
	szpqCfoCcsuU0GAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6460E3EA69;
	Sun,  1 Mar 2026 20:26:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zR8lFQyhpGmyfwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Sun, 01 Mar 2026 20:26:52 +0000
Date: Sun, 1 Mar 2026 20:26:50 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Gladyshev Ilya <gladyshev.ilya1@h-partners.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Matthew Wilcox <willy@infradead.org>, 
	Yu Zhao <yuzhao@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Gorbunov Ivan <gorbunov.ivan@h-partners.com>, 
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kiryl Shutsemau <kirill@shutemov.name>, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/1] mm: improve folio refcount scalability
Message-ID: <m73zmq6jbdzqmxdjgnmfmd5h4w5a2khur7we3e64r357o32hfj@mvwcqgnuhzqh>
References: <cover.1772120327.git.gladyshev.ilya1@h-partners.com>
 <20260228141941.f6fec687aae9d80a161387f4@linux-foundation.org>
 <CAHk-=wgfs7KqS8pD8F9F9yC8jwSgQtmifytbmmXVfz9xXrQzuw@mail.gmail.com>
 <CAHk-=wgOxtAFf5XeYTcoUHSpWfMrgZaXKc_hrmqt6yKBdr=3Zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgOxtAFf5XeYTcoUHSpWfMrgZaXKc_hrmqt6yKBdr=3Zw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9A305120004
X-Stat-Signature: 6orc5rgr7stmfeyqkpqpnbqqkrqp8inf
X-HE-Tag: 1772396815-844729
X-HE-Meta: U2FsdGVkX1/MwhptrT0OmXcS3np9ASpjLBnzLtoniT4z0YIiyj4UufOhGqrzANfPi9q3FETg4+6uhCchASC2pGg+P/iHJO9datMMPP4qLRURn6N1Hyk/cQpG0Q4lOCE8uX+OxjrW09Ntyzjl0a7x+zEM8SlloF1tJBZ52p0bnO+HT48ogrJ+JZnxFWLkFdYy8UkWAVadZsRToacWFdfBdXkwtlqq2JOrrmCakjJ8M66PrGedJ2+Bx8SEG/1J7U0Q01tmagysC9p/u5Kub1FB0GA+XNW9D42eDfANQlbWqKgsVV3C/MdmSnxWJUTh/g+MXDIL8UCnGvuLE+cZwLSVryz50zA/mNYA1Cd/6zP4FOpckT9/vqUK4ovg04IkInmEbMOsqsl/vLcbuceUR8fZdi3H5CD7Bdx2Rv3GZvfbaucMdmEkgtUKSQUcxuz286luFAIVvOwnv9LqHUTHJCM1StkcHHPzyK7jkDXCDegjp+2tJ1c93JlgDzxSlwNTIFCjtNG8WXIdvfqIhtHGqjpITuRDk2fdTcOWF74qQV2p9WmxwuMpor7Je8FG30oPPAb3z7eruTnRmWCxgLZYGZ/xz3WnM7Tu+rl+NwMFyvelb45Gxcf3KABCv2ILftauDm4fzohI5w130tKLcl5bUWj8qFasRzv9szXepCmhaMHhz+S2OnPfR2rHCvulzeMbm+SfSSFAbQrd1dlEeAp3UBDZt9IXGUk1LyN9Es5nTcF2jtTqITK3yfITKH917FYgLN5OEJHZAPi/CyUQsrulkA6cvysx3X6l2c58Fr4luAv9LCf77MlvuXwa3ZcP2AAUyenXDordlUPw7Zds4m5vi25ZBUO2SGf+3uYc/H2ykgKyrJ6lnsrCCurPLQUJhH39w2KpW0cE9W15+03RwrysnwE4TxzzwB/jPzK5qYSYIoA304sukE6lTSlB1h13rFUeSCFLz2trQuFQL8c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 01, 2026 at 10:52:57AM -0800, Linus Torvalds wrote:
> On Sat, 28 Feb 2026 at 19:27, Linus Torvalds
> <torvalds@linuxfoundation.org> wrote:
> >
> > This attached patch is ENTIRELY UNTESTED.
> 
> Here's a slightly cleaned up and further simplified version, which is
> also actually tested, although only in the "it boots for me" sense.
> 
> It generates good code at least with clang:
> 
>   .LBB76_7:
>           movl    $1, %eax
>   .LBB76_8:
>           leal    1(%rax), %ecx
>           lock cmpxchgl   %ecx, 52(%rdi)
>           sete    %cl
>           je      .LBB76_10
>           testl   %eax, %eax
>           jne     .LBB76_8
>   .LBB76_10:
> 
> which actually looks both simple and fairly optimal for that sequence.
> 
> Of course, since this is very much about cacheline access patterns,
> actual performance will depend on random microarchitectural issues
> (and not just the CPU core, but the whole memory subsystem).
> 
> Can somebody with a good - and relevant - benchmark system try this out?
> 
>                Linus

Here are some perhaps interesting numbers from an extremely synthetic
benchmark[1] I wrote just now:

note: xadd_bench is lock addl, cmpxchg is the typical load + lock cmpxchg loop,
and optimistic_cmpxchg_benchmark is similar to what you wrote, where we assume
1 and only later do we do the actual loop. I also don't claim this is
representative of page cache performance, but this is quite a lot simpler
to set up and play around with.

On my zen4 AMD Ryzen 7 PRO 7840U laptop:
------------------------------------------------------------------------------
Benchmark                                    Time             CPU   Iterations
------------------------------------------------------------------------------
xadd_bench/threads:1                      2.76 ns         2.76 ns    250435782
xadd_bench/threads:4                      42.1 ns         42.1 ns     15969296
xadd_bench/threads:8                      84.8 ns         84.8 ns      8920800
xadd_bench/threads:16                      226 ns          211 ns      2446928
cmpxchg_bench/threads:1                   3.12 ns         3.12 ns    220339301
cmpxchg_bench/threads:4                   51.1 ns         51.1 ns     12372808
cmpxchg_bench/threads:8                    112 ns          112 ns      6228056
cmpxchg_bench/threads:16                   679 ns          648 ns       930832
optimistic_cmpxchg_bench/threads:1        2.95 ns         2.95 ns    233704391
optimistic_cmpxchg_bench/threads:4        56.2 ns         56.2 ns     11780588
optimistic_cmpxchg_bench/threads:8         140 ns          140 ns      4606440
optimistic_cmpxchg_bench/threads:16        789 ns          746 ns       806400

Here we can see that the optimistic cmpxchg still can't match the xadd/lock addl
performance in single-thread, and degrades quickly and worse than straight up
cmpxchg under load (perhaps presumably because of the cmpxchg miss).

On our internal large 160-core Intel(R) Xeon(R) CPU E7-8891 v4 (older uarch,
sad) machine:
------------------------------------------------------------------------------
Benchmark                                    Time             CPU   Iterations
------------------------------------------------------------------------------
xadd_bench/threads:1                       13.6 ns         13.6 ns     51445934
xadd_bench/threads:4                       41.4 ns          166 ns      4211940
xadd_bench/threads:8                       30.3 ns          242 ns      2190488
xadd_bench/threads:16                      37.3 ns          596 ns      1162336
xadd_bench/threads:64                      24.9 ns         1376 ns       640000
xadd_bench/threads:128                     27.3 ns         3108 ns      1054592
cmpxchg_bench/threads:1                    17.9 ns         17.9 ns     38992029
cmpxchg_bench/threads:4                    54.8 ns          219 ns      3431076
cmpxchg_bench/threads:8                    39.0 ns          312 ns      1698712
cmpxchg_bench/threads:16                   62.2 ns          994 ns       530672
cmpxchg_bench/threads:64                   28.5 ns         1479 ns       665280
cmpxchg_bench/threads:128                  17.2 ns         1838 ns       517376
optimistic_cmpxchg_bench/threads:1         13.6 ns         13.6 ns     51384286
optimistic_cmpxchg_bench/threads:4         70.2 ns          281 ns      2585092
optimistic_cmpxchg_bench/threads:8         58.1 ns          465 ns      1598592
optimistic_cmpxchg_bench/threads:16         106 ns         1694 ns       420832
optimistic_cmpxchg_bench/threads:64        30.8 ns         1767 ns       499264
optimistic_cmpxchg_bench/threads:128       39.3 ns         4632 ns       447104

Here, optimistic seems to match xadd in single-threaded, but then very quickly
degrades. In general optimistic_cmpxchg seems to degrade worse than cmpxchg,
but there is a lot of variance here (and other users lightly using it) so
results (particularly those with higher thread counts) should be taken with a
grain of salt (for example, lock add scaling dratistically worse than cmpxchg
seems to be a fluke).

TL;DR I don't think the idea quite works, particularly when a folio is under
contention, because if you have traffic on a cacheline then you certainly have
a couple of threads trying to grab a refcount. And doing two cmpxchgs just
increases traffic and pessimises things. Also perhaps worth noting that neither
solution scales in any way.

[1] https://gist.github.com/heatd/2a6e6c778c3cfd4aa6804b2d598c7a4c (excuse my C++)
-- 
Pedro

