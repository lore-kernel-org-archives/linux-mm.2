Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A874CC5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 18:03:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56A336B0095; Thu, 20 Aug 2026 14:03:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F5096B009B; Thu, 20 Aug 2026 14:03:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BBDC6B009D; Thu, 20 Aug 2026 14:03:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 081EC6B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:03:01 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9C84BA027A
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:02:56 +0000 (UTC)
X-FDA: 85122418752.23.F7F7C06
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0BE25C0014
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:02:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=rTRFHt4F;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787248975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/nTZ7s1goF+GPCz6EL3sBTg9gNDkE+Bk0F4MEDCId3U=;
	b=EpARL8ChSSjk70awautYMU8AIB9doSzgRCtbSBTUpM4GoEf15Cg82qjWHiOKRTp2pZTOia
	99x+mqzxaYkff9FfVxtdx8KYmV5uCvFYR98pyOSKN0zL9e3X7pg51IWgFYrX5Kw9SLiQ4H
	JyTLJ9OLaEhH2f300SP5yVmS+pJiO98=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787248975;
	b=Ej2TOHijpvpJh+lZJOPnS4IPwUEw6tV5DqEswX8MHj5vVS2GekvOTYloT64WHng681gJbW
	YoGBOtY7d9R8p0e5/cYkBdf6IVOIiiEIc8L09RU2wHqOz3ARxGRJXciN01i0C19o+etbMy
	3XiOov+OQelaOkQznVTTGIk9LvA31qg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=rTRFHt4F;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/nTZ7s1goF+GPCz6EL3sBTg9gNDkE+Bk0F4MEDCId3U=; b=rTRFHt4F8LNezy/fzAgoJCTaEn
	Hu0D4RqGfIK9MUZUy7y5Vba3MurgAp9pBMd9z6PEiUlWaCso04QtHq/uQ4n17N1VQ2wPu6RajSIxt
	5VjB0H2feVYd3mqUp5gCxaMbrQOO+i6lj9uOvypef8Qk/ac19GC7w3Hfcyxj83iTd9QOFZIzV0iBp
	/SGM/O64CQwL9ZlzHX0Ox5TCul40K5Mnq+2KwcSaH/1h0KS1/qNKeUME6lYFYtYCfh4F7sNx59RpD
	pLEI6i3LHvbHNk4ESUjf0GkAf6n+DO9ur6QkErSHO05zM44QUpEFH+mMqGSk1hMk5dNHlM0YQq3eB
	Pzxk6gcA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wx6uy-0000000G2y1-3Dxp;
	Thu, 20 Aug 2026 17:51:08 +0000
Date: Thu, 20 Aug 2026 18:51:08 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>, linux-kernel@vger.kernel.org,
	max.byungchul.park@gmail.com, kernel_team@skhynix.com,
	torvalds@linux-foundation.org, damien.lemoal@opensource.wdc.com,
	linux-ide@vger.kernel.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
	will@kernel.org, tglx@linutronix.de, rostedt@goodmis.org,
	joel@joelfernandes.org, sashal@kernel.org, daniel.vetter@ffwll.ch,
	duyuyang@gmail.com, johannes.berg@intel.com, tj@kernel.org,
	tytso@mit.edu, david@fromorbit.com, amir73il@gmail.com,
	gregkh@linuxfoundation.org, kernel-team@lge.com, linux-mm@kvack.org,
	akpm@linux-foundation.org, mhocko@kernel.org, minchan@kernel.org,
	hannes@cmpxchg.org, vdavydov.dev@gmail.com, sj@kernel.org,
	jglisse@redhat.com, dennis@kernel.org, cl@linux.com,
	penberg@kernel.org, rientjes@google.com, vbabka@suse.cz,
	ngupta@vflare.org, linux-block@vger.kernel.org,
	josef@toxicpanda.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
	jlayton@kernel.org, dan.j.williams@intel.com, hch@infradead.org,
	djwong@kernel.org, dri-devel@lists.freedesktop.org,
	rodrigosiqueiramelo@gmail.com, melissa.srw@gmail.com,
	hamohammed.sa@gmail.com, harry.yoo@oracle.com,
	chris.p.wilson@intel.com, gwan-gyeong.mun@intel.com,
	boqun.feng@gmail.com, longman@redhat.com, yunseong.kim@ericsson.com,
	ysk@kzalloc.com, yeoreum.yun@arm.com, netdev@vger.kernel.org,
	matthew.brost@intel.com, her0gyugyu@gmail.com, corbet@lwn.net,
	catalin.marinas@arm.com, bp@alien8.de, x86@kernel.org,
	hpa@zytor.com, luto@kernel.org, sumit.semwal@linaro.org,
	gustavo@padovan.org, christian.koenig@amd.com,
	andi.shyti@kernel.org, arnd@arndb.de, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com,
	mcgrof@kernel.org, petr.pavlu@suse.com, da.gomez@kernel.org,
	samitolvanen@google.com, paulmck@kernel.org, frederic@kernel.org,
	neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com,
	josh@joshtriplett.org, urezki@gmail.com,
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
	qiang.zhang@linux.dev, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
	chuck.lever@oracle.com, neil@brown.name, okorniev@redhat.com,
	Dai.Ngo@oracle.com, tom@talpey.com, trondmy@kernel.org,
	anna@kernel.org, kees@kernel.org, bigeasy@linutronix.de,
	clrkwllms@kernel.org, mark.rutland@arm.com, ada.coupriediaz@arm.com,
	kristina.martsenko@arm.com, wangkefeng.wang@huawei.com,
	broonie@kernel.org, kevin.brodsky@arm.com, dwmw@amazon.co.uk,
	shakeel.butt@linux.dev, ast@kernel.org, ziy@nvidia.com,
	yuzhao@google.com, baolin.wang@linux.alibaba.com,
	usamaarif642@gmail.com, joel.granados@kernel.org,
	richard.weiyang@gmail.com, geert+renesas@glider.be,
	tim.c.chen@linux.intel.com, linux@treblig.org,
	alexander.shishkin@linux.intel.com, lillian@star-ark.net,
	chenhuacai@kernel.org, francesco@valla.it,
	guoweikang.kernel@gmail.com, link@vivo.com, jpoimboe@kernel.org,
	masahiroy@kernel.org, brauner@kernel.org,
	thomas.weissschuh@linutronix.de, oleg@redhat.com, mjguzik@gmail.com,
	andrii@kernel.org, wangfushuai@baidu.com, linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-i2c@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-modules@vger.kernel.org,
	rcu@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-rt-devel@lists.linux.dev, 2407018371@qq.com, dakr@kernel.org,
	miguel.ojeda.sandonis@gmail.com, neilb@ownmail.net,
	bagasdotme@gmail.com, wsa+renesas@sang-engineering.com,
	dave.hansen@intel.com, geert@linux-m68k.org, ojeda@kernel.org,
	alex.gaynor@gmail.com, gary@garyguo.net, bjorn3_gh@protonmail.com,
	lossin@kernel.org, a.hindborg@kernel.org, aliceryhl@google.com,
	tmgross@umich.edu, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v19 00/40] DEPT(DEPendency Tracker)
Message-ID: <aoc-jJ10op62jXFK@casper.infradead.org>
References: <20260706061928.66713-1-byungchul@sk.com>
 <359ea967-9b97-4584-88e6-bddb4044de2e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <359ea967-9b97-4584-88e6-bddb4044de2e@kernel.org>
X-Rspam-User: 
X-Stat-Signature: p6jooaa5abgbm6obh9d1gk8nmwytbaje
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0BE25C0014
X-HE-Tag: 1787248973-616226
X-HE-Meta: U2FsdGVkX1/vF68CJ0MluivkLzizJ4qAvjkWCUnAxxUj2ajNbtWJTqz6SYO4ftCl61aB1VsbqSCbcWjMXMJbKASmzFdu17inDDa3uT0kkjvMBMVJsLSBo4UmuSrMqtFgLFo0rAY6A+1kvCwUm9i55RDdVuAvtwEVK4fD0jcOtLg2+ETg0eD+Sn6moOOZlR5dWNgNV1ndk0ghkAA2rwjS7m+uGBqsdFQyngIPmMXqWOXcsPoSs+CcLwZtc8BMVE22L5fCq/4N9pDsLcjenpN0RrA3w7P7ZD7dEoC00UyhWfYEE3/wHXsP80m9F6PlDozCYmtAtDHew77A0acIKX+GDm5I5bTz3R03/6nScMv3VgtdKKSklX//p18vkLmRJWkSMyb+NrPsPzZ+7j06aFBAGtqof0FzPABxae/sukfIvtjKcsO0mIDAYP9RMpHP5UpuyYNqrghFK5yxTrRRRKIKZLDhJEKm1hBabC0v2hJb0yVHnZgxuh0H9fgDYpxuAarzlUD/OyqQREL9QD0OW3z8H1ZhyKMzOy25aSr2omXffAFXIs+CyPr24SmyZPtOxz/+V/cyfTdl58MIJ3tBrw/GWdi/vIe3vnD23Eb74oQH+X9kK1jNaglMVO2n+psHZ4H4yFr32VaEx3ii4YfeNk/zqHagXxo+6+WXOOfhl7Z3f8lNbNaKbeeyj2JCO4C6EmMgHYW9NFFChQ3ey53vjSCcw6YJh7Xu5DJUCQSz8oyrzB951WrAeVw8909uD2q7yLM3BJgV1rumVnj1Yo5I5wJM2PQpk4ra5Q1GroxzR42G8HNQtR9Xk/NGgYCAMvmmD7rNwTwbw422NOi8HrZDayeA4BbiG9tsIBAUuxwts/YFs4NzuaTFd8VdRebUCCcNA+NKukTR/xOh9pRTTrI3WrQlLSzXkyzK4YF6eMVsPoTcv5NtaDjEqZDDsoXY5q+AL3CbYumRJ7zUg0GKY06w1ef
 oYbIZ47Z
 w+meRQm9xFcvrGS3XgyitU711ve+3TP/tjpWhQ4WKGqE1B86p+Y7QHXGXEaGoKXlhOSAXLFyJqvOUPScLacZxYpn/+Uve0uE8mTy1eIaUSxNyk32pgvUvwV0/JlsxfcBzs21m7TSLm5aIx3qaclaZbL+jqetaKdCjtwURZsmquh61/qv+npBa6NFJcFSghe4XnDz2EkT5UvU+HHlDuT/kF4jBSjh4/uoMS9WrFA+wfyag1OmoThm/Zh6uGDa8hR6PiY6glcJhYZGeGVdqbsZ113LBQAhxLNKrS/VfB4cMRwALUbE3eRKyrw8YY2j2fm3qTezGvEuOf4bwZgmPoO7OCyyKxKQ4uQy3HXSO6YXahySEMHSLzDLtoDc8bVQxinV++HFO25zBvrEIvSz+f/nTnK2mnHGaipWrY0jITNf03Le54+u46spmpA6Zpqugak922VdKPXqzezUHrEDAKUYbobdA8MGaELlmhmmmWpt2xk4AvLBbVDfnkxI0eaaX+rS6nce0mm7NrsDqFiifs3KODhxGFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 07:16:05PM +0200, David Hildenbrand (Arm) wrote:
> > Consider this real deadlock pattern that lockdep cannot detect:
> > 
> >    context X              context Y              context Z
> > 
> >                           mutex_lock A
> >    folio_lock B
> >                           folio_lock B <- DEADLOCK
> >                                                  mutex_lock A <- DEADLOCK
> >                                                  folio_unlock B
> >                           folio_unlock B
> >                           mutex_unlock A
> >                                                  mutex_unlock A
> 
> But that really just boils down to folio lock being implemented as a PG_lock +
> some advanced wait mechanism. And we must do that because of lack of bits in
> struct page.
> 
> Willy mentioned in a previous version [1]: "I don't think it makes sense to
> track lock state in the page (nor folio).  Partly because there's just so many
> of them, but also because the locking rules don't really apply to individual
> folios so much as they do to the mappings (or anon_vmas) that contain folios."
> 
> Given that lockdep is a debug feature, and we will at some point allocate struct
> folio separately, I assume we could just squeeze a "struct lockdep_map" in there
> in such debug configs and the world would not collapse.
> 
> Doing that today (one "struct lockdep_map" in each "struct page") wouldn't work
> as mm_zero_struct_page() would not expect such large "struct page". But
> conceptually, for a debug kernel with a special CONFIG_LOCKDEP_PAGE_LOCK, maybe
> that would already be ok and we could just do that (and optimize it as we
> allocate folios separately).
> 
> Not that it's ideal, but for a debug feature to at least check PG_lock, probably
> an easier way to achieve it than some completely new infrastructure.
> 
> Now, Willy said "locking rules don't really apply to individual folios", I
> wonder if that could just help to also let lockdep check PG_lock with less
> metadata? (didn't fully wrap my head around the implications)
> 
> [1]
> https://lore.kernel.org/all/aR3WHf9QZ_dizNun@casper.infradead.org/?utm_source=chatgpt.com

There are a few things going on that make PG_lock special.  Let me try
to explain again, only better this time.

1. The current lifetime of a struct page is the lifetime of the system.
But the semantics of its PG_lock bit change each time it is freed and
allocated.

2. The position of PG_lock in the locking hierarchy only depend on
what the folio is currently being used for.  That is, all folios in
a given xfs inode behave exactly the same from a locking perspective.
There's no need to build up state about how each PG_lock is used;
they can all share.  Arguably all xfs file inodes are the same as
each other (directory inodes might be different from file inodes),
so we might want to go further than telling DEPT that "this folio
belongs to this inode" and go to "this folio belongs to this xfs file
inode".

3. PG_lock can be taken in task context then released in interrupt
context.  For full points, we need to mark the exact point at which
we submit the folio for read.  Otherwise we can get into the situation
alluded to by f2c817bed58d and better discussed at
https://lore.kernel.org/linux-mm/20200127150024.GN1183@dhcp22.suse.cz/
where we have the folio locked but haven't yet submitted it for I/O
so it doesn't matter how long we wait, it will never come unlocked.

