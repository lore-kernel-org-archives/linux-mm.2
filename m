Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43246C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 02:40:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 417926B0095; Mon, 24 Aug 2026 22:40:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EFAB6B0099; Mon, 24 Aug 2026 22:40:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 305FA6B009B; Mon, 24 Aug 2026 22:40:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E229E6B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 22:40:56 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 79CBF1C1106
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:40:56 +0000 (UTC)
X-FDA: 85138239312.25.E543D80
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6F6A840006
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:40:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hzGqzCFd;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787625654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cMhE1zLIBEfW8ce0tgca2Z8WQ504QioXQyvOVgDlw9s=;
	b=Cj4HmK6hOaVzLZH09yBp93F2tNRzhiasIbOyFpu5b0SumL7AqeQeJpJhlXm5tJ31oTz85k
	vhVmkPu2nnOFDCbIjNLs9iDB9f5pBVl8Z9IdwEaaOnZ+Xq02RJ9JNugGM/+9ePExHood7C
	BHh+9sFVFRzBSN5Ne4G/H3JcME0qejk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hzGqzCFd;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787625654;
	b=icM/J1QWYRox+2YEvUcgSlsATVmx//PNJQSBImr4S7Tw2kUB+9ZiCxoWw1FjmoutJooJsu
	3oUoho/zCcGEhpCOm8WpW8kQERj0Y00xICRiDbXl1rGA/dQd9dEZGPQte4APqxnsun++17
	XyPn35YXgFuouukoKM7V+KF+wwcc5ao=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cMhE1zLIBEfW8ce0tgca2Z8WQ504QioXQyvOVgDlw9s=; b=hzGqzCFd/Zil7siDD7txgS0PkI
	0btYf2KcGF4Jt5LTpvtm3rcvqgdEJSmZrUdBF9aqMpMYUh9Wx2DIzUj8xdR3ux2f0ydIJjgu6/GP/
	GCGCI2Cu8TlWQosSPGxvlQtgSVvTwAmUUZIpR/2u1oLk4ZJts6jT8AMgHc7WKf4EmDelDxaZNwldB
	bwuBAzBiHPtS2yBO9dgBLMH1854Fm9Yq579Rygv7X8gtmLlRanmAfRNHAJH+8I1bkHkoV2E7aBA/w
	Rmforme87QTE7Bp3x5xKUtL/ppwt4PjCQFG+iz4NzVNJh7Q9S88tpLt+noBixClVZE+hH5oiywcdZ
	NRPAIH+Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wyh57-00000008BRG-20Ss;
	Tue, 25 Aug 2026 02:40:09 +0000
Date: Tue, 25 Aug 2026 03:40:09 +0100
From: Matthew Wilcox <willy@infradead.org>
To: NeilBrown <neil@brown.name>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Byungchul Park <byungchul@sk.com>, linux-kernel@vger.kernel.org,
	max.byungchul.park@gmail.com, kernel_team@skhynix.com,
	torvalds@linux-foundation.org, linux-ide@vger.kernel.org,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	mingo@redhat.com, peterz@infradead.org, will@kernel.org,
	tglx@linutronix.de, rostedt@goodmis.org, joel@joelfernandes.org,
	sashal@kernel.org, daniel.vetter@ffwll.ch, duyuyang@gmail.com,
	johannes.berg@intel.com, tj@kernel.org, tytso@mit.edu,
	david@fromorbit.com, amir73il@gmail.com, gregkh@linuxfoundation.org,
	kernel-team@lge.com, linux-mm@kvack.org, akpm@linux-foundation.org,
	mhocko@kernel.org, minchan@kernel.org, hannes@cmpxchg.org,
	vdavydov.dev@gmail.com, sj@kernel.org, jglisse@redhat.com,
	dennis@kernel.org, cl@linux.com, penberg@kernel.org,
	rientjes@google.com, vbabka@suse.cz, ngupta@vflare.org,
	linux-block@vger.kernel.org, josef@toxicpanda.com,
	linux-fsdevel@vger.kernel.org, jack@suse.cz, jlayton@kernel.org,
	hch@infradead.org, djwong@kernel.org,
	dri-devel@lists.freedesktop.org, rodrigosiqueiramelo@gmail.com,
	melissa.srw@gmail.com, hamohammed.sa@gmail.com,
	harry.yoo@oracle.com, chris.p.wilson@intel.com,
	gwan-gyeong.mun@intel.com, boqun.feng@gmail.com, longman@redhat.com,
	yunseong.kim@ericsson.com, ysk@kzalloc.com, yeoreum.yun@arm.com,
	netdev@vger.kernel.org, matthew.brost@intel.com,
	her0gyugyu@gmail.com, corbet@lwn.net, catalin.marinas@arm.com,
	bp@alien8.de, x86@kernel.org, hpa@zytor.com, luto@kernel.org,
	sumit.semwal@linaro.org, gustavo@padovan.org,
	christian.koenig@amd.com, andi.shyti@kernel.org, arnd@arndb.de,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, surenb@google.com, mcgrof@kernel.org,
	petr.pavlu@suse.com, da.gomez@kernel.org, samitolvanen@google.com,
	paulmck@kernel.org, frederic@kernel.org, neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com, josh@joshtriplett.org, urezki@gmail.com,
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
	qiang.zhang@linux.dev, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
	chuck.lever@oracle.com, okorniev@redhat.com, Dai.Ngo@oracle.com,
	tom@talpey.com, trondmy@kernel.org, anna@kernel.org,
	kees@kernel.org, bigeasy@linutronix.de, clrkwllms@kernel.org,
	mark.rutland@arm.com, ada.coupriediaz@arm.com,
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
	miguel.ojeda.sandonis@gmail.com, bagasdotme@gmail.com,
	wsa+renesas@sang-engineering.com, dave.hansen@intel.com,
	geert@linux-m68k.org, ojeda@kernel.org, alex.gaynor@gmail.com,
	gary@garyguo.net, bjorn3_gh@protonmail.com, lossin@kernel.org,
	a.hindborg@kernel.org, aliceryhl@google.com, tmgross@umich.edu,
	rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v19 00/40] DEPT(DEPendency Tracker)
Message-ID: <ao0AieB7zg5FKD39@casper.infradead.org>
References: <20260706061928.66713-1-byungchul@sk.com>
 <359ea967-9b97-4584-88e6-bddb4044de2e@kernel.org>
 <20260821042143.GA40890@system.software.com>
 <825134a8-ceae-430c-b2fc-d1d0c7240f39@kernel.org>
 <178730572084.2852630.7732425311008244683@noble.neil.brown.name>
 <3d58eb3c-7a9d-4183-907b-46172664631c@kernel.org>
 <178761465493.3510150.12380729360578969391@noble.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178761465493.3510150.12380729360578969391@noble.neil.brown.name>
X-Rspamd-Queue-Id: 6F6A840006
X-Stat-Signature: uon65bmxfzgiozy75xw46apnxp4js83u
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787625654-819426
X-HE-Meta: U2FsdGVkX1906yZKA2qQWmE4TiZZXF5H4BPpmpf2HRMdwsVvsYzGF+tK4Ta15WMbk3S9yt3QV7eqQyfhSMfOnv15IXmyEXxSGDL1eg/UFoigs3ViO+CcK6KbBjfXJLDSF/RKqZ4m/4ybCi73ZF7G+hrlPYxz/qTjcLcXIEjv0h2ljytAluqZXfMh5NTz4GoabL0ga9oQjgM/5oVE2v/lrsg/O8Z/xN9n4NPogW1c+Ef7YeQGexlcFUyojEhTFw9HwqByTNoCZJIwH1eeoKhwNUDGuy48XxC1YleAOlQnj2aqqN/x987J6MKGP7qiQXyRpzhyXUY3FfrOy7Q2A4KXakBmWvawgsvk2irkiijn1Hu/X72gClp9bWwHIkkuVANMw5B8XaxkUNy9W1MXB0wWTMbLGi6iLGQtfJYU6jy2zY0SglPnCsHaBdIPmtccpcVl4Fk8OZ8liev3hmLWzV3HRRix7h90kTGwKUnE0Pf4ExeN/EYZnmchLUYxquI79vwgo9K8PFhO/+R9jQN0H8cocMVkpN+6Ah26oLsTngWpdXFJc4U5Y2DIL3qO1D9h8PM+/Gjyk1tt/pPbZ0zB6Lu5gFzUTD3yyDFsycbjMV6zGj8X0mjuM1H64aOKmXiLNkdCJuTIiUL6n0XKW94IssnTzEt111ZsLJbYQG7uctGrtycT/Q3Q9V0Ip1/Gh2pidFY/Di+YoYPjaJvYfVlDsC1xR+NOdVzwEKujC4UMYT999D6IPGrry961F7/DRTavqpoxvgVdUrtSV6nKcH3ktumxpaRtegL3w6ir7kwS7rPGewB0AobX/zU5jr+stql3LOQDihVhlbsNG3/E9Xo5/kHQzQQrndulMH5zPqu8DHxX2of/WfhsVvRr953RT5BfDu8hKQ0fhjnpe5dJ7QzzaPYPFX5Sf1IUlhbd9zOTTSTXyFUndUb8UtR7HOpB3q6oYtURrGSVwhaAdElF0JuWnVn
 BfqWnB5c
 3XYXIibr/UEG8O1qeaURRYerUV6DQeFQNsznDNb7xtUvLJHzoZNXkkDF3JijzRfIb0Vocj2mzrLttkdsuvG1HmxeMyz1Y6jScnAvEeRArdyRenre0Ngx/qEYJSum/I79/RohNil+ETTI/S2bS88WBrEuQ8TFxgmalWSueUrNb6qvVE7jtlNhauyG7ZxAGlvJjOe2fqeJZqO67pfjRdrmSCBv2hnrz+FBQ8dTLhpn5dRhVo2ixbb1coOKQKbil/ajVVAhZCJJNSF7V97hdn0hF9poXXV/QpV7+sazV4KM5zswxkZDj7UMQYfJqnnkMTcbWb10+nX4/gt8ORgiJLT5bGOVqLPi7rRmhY9wpQ6hT/ljb9FoM7Fi4BNgruigmHZGRAGBLQN4sJgwLpVUcuIhttLfPeaqUs7A6rDNviWPoCl/eVBQbKXG60vGNYwQyf4Q8qE8uF826NFuUwy2tIu6ISA2WUh5ekzlbsVCKcbCA6JCitCI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 09:37:34AM +1000, NeilBrown wrote:
> > For readahead, I think that queues / lru are not involved. We submit the I/O,
> > and once the I/O is done, we unlock the folio from interrupt context.
> 
> "submit the I/O" means "attach the page to a "struct bio" (or similar)
> and attach the struct bio to a transmit queue for the device (or
> similar).  So there really is a queue.
> 
> > 
> > end_buffer_async_read() / iomap_finish_folio_read() end up calling
> > folio_end_read(), where we do the magic
> > 
> > 	folio_wake_bit(folio, PG_locked);
> 
> Exactly where the lock ownership should be reclaimed is not immediately
> clear to me.  bio_endio() might be early enough but there are probably
> better points.
> 
> A small difficulty here is that a bio has multiple folios and they are
> all locked.  I cannot see that lockdep has a concept of holding an
> arbitrarily large set of related locks.
> We could just tell lockdep 
>   "I have some folios locked" 
> or maybe enhance lockdep to allow
>   "I have N folios locked"
> or even
>   "I have N folios in address-space A with the highest offset being O".
> 
> This would allow lockdep to check the validity of locking another folio
> - only allowed if the address space is the same and the offset is larger
> than the previous largest.

It's more complex than that; see my other emails on the subject.

I think we need the ability for lockdep to call a function which says "I
hold this lock, is that lock OK to acquire".  But the devil is in the
details.

> > 
> > It's interesting, that for writeback we never unlock the folio on the I/O path,
> > but instead have the dedicated page flag to tell us when writeback is complete.
> 
> PG_locked and PG_writeback are two different lock-bits with two
> different meanings.
> When a folio is PG_locked the content is invalid and shouldn't be accessed.
> When a folio is in PG_writeback its data is not safe even though
> PG_dirty has been cleared (if I remember correctly).
> 
> So these are two separate, though related, lock bits that would both
> need to be tracked.  lockdep would detect how they are related.

Some history ... before we had PG_writeback, we held PG_locked
throughout the writeback process.  People argued convincingly that it
was fine to map a page into a process's address space (which requires
PG_locked) while it was being written back.  And so PG_locked was
split.  Now we take PG_locked at the beginning of the writeback process
and downgrade to PG_writeback at some point.


