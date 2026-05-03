Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57C26CD3427
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 18:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EFDA6B008A; Sun,  3 May 2026 14:17:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74D316B0093; Sun,  3 May 2026 14:17:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59F8A6B008C; Sun,  3 May 2026 14:17:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 44F506B008A
	for <linux-mm@kvack.org>; Sun,  3 May 2026 14:17:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AFCA5C28D1
	for <linux-mm@kvack.org>; Sun,  3 May 2026 18:17:39 +0000 (UTC)
X-FDA: 84726916638.20.2E54574
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6949818000B
	for <linux-mm@kvack.org>; Sun,  3 May 2026 18:17:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OoNHn3y4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=q7pHytij;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OoNHn3y4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=q7pHytij;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777832257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AsKSGKv1gbQ1kxj3oO+fSJmap4EgBc+0PTi6YnXpoZE=;
	b=OFO4dM25WHWlkJbBlqCWMOwci/4q+8nZN9LN/S89WBxD6MvfdsBifjQU2THMyfvcgW+7oV
	EI9PywLeGf0IVb2knCBECx/MbYbQieqcu2XhhrDw3RvVhJRdFnV+fvQtmlK7HjCKRjLqNH
	qL5SUL/G2Uwb4QyJWtarMW6+JWoOaVE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777832257; a=rsa-sha256;
	cv=none;
	b=8lPlOE5BV1chcZg2buJEa0wgLbBqNwZrqnj5NNX3WydNWWZ5XxuLIo0Mz4uTedSb0cwkYK
	0LdAQyJbCrj0fig6485zSy+6Ugwke5OpSqUjc3xKczlMheSQmGUGqXIqzhl+32IICTqG0t
	3JP45KUJlPxw2ZDneObFy4cJ48CtTTQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OoNHn3y4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=q7pHytij;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OoNHn3y4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=q7pHytij;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A9BB95C010;
	Sun,  3 May 2026 18:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777832255; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AsKSGKv1gbQ1kxj3oO+fSJmap4EgBc+0PTi6YnXpoZE=;
	b=OoNHn3y4rN894Hek56TAHXPlCqi/IQ1Uo/ALP1kQg3A/6zShv94jQjNfaUtelYYh+YOGMu
	YeRcyoqLNAZBC2BP6OBIZWp0DepiBiJDwjmpOTSysVRWSzDWf2mNm6RtcDBCZaXZCcT03y
	JNuY4E27lqaHD9OEaIdKjcy6iTWHDa0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777832255;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AsKSGKv1gbQ1kxj3oO+fSJmap4EgBc+0PTi6YnXpoZE=;
	b=q7pHytijoJfoB1JUwtZq+JLzu+1pit499ofgLxkX0CU8I3YxZ3scCg1SxCoipgJc/00K6j
	CBR8iE/NRq1ZfJBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777832255; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AsKSGKv1gbQ1kxj3oO+fSJmap4EgBc+0PTi6YnXpoZE=;
	b=OoNHn3y4rN894Hek56TAHXPlCqi/IQ1Uo/ALP1kQg3A/6zShv94jQjNfaUtelYYh+YOGMu
	YeRcyoqLNAZBC2BP6OBIZWp0DepiBiJDwjmpOTSysVRWSzDWf2mNm6RtcDBCZaXZCcT03y
	JNuY4E27lqaHD9OEaIdKjcy6iTWHDa0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777832255;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AsKSGKv1gbQ1kxj3oO+fSJmap4EgBc+0PTi6YnXpoZE=;
	b=q7pHytijoJfoB1JUwtZq+JLzu+1pit499ofgLxkX0CU8I3YxZ3scCg1SxCoipgJc/00K6j
	CBR8iE/NRq1ZfJBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 93C8F593A8;
	Sun,  3 May 2026 18:17:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id a28LJD+R92kuFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Sun, 03 May 2026 18:17:35 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2B30FA078B; Sun, 03 May 2026 15:13:04 +0200 (CEST)
Date: Sun, 3 May 2026 15:13:04 +0200
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <willy@infradead.org>
Cc: Barry Song <baohua@kernel.org>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	jack@suse.cz, pfalcato@suse.de, wanglian@kylinos.cn, chentao@kylinos.cn, 
	lianux.mm@gmail.com, kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, 
	youngjun.park@lge.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
Message-ID: <yezmezj26xntushmylductlmytfgvwsnbnzlhffkfwugfxkt6m@gleq22spziyk>
References: <20260430040427.4672-1-baohua@kernel.org>
 <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org>
 <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <afTpoL3FklpQZNMM@casper.infradead.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6949818000B
X-Stat-Signature: 1n5ctbewhwkmnmfqgmzcyap5d4gbbkax
X-Rspam-User: 
X-HE-Tag: 1777832257-906182
X-HE-Meta: U2FsdGVkX1+HuHls4pNBE3XGNYdlnd7/1X+ADoi5GYB7eSR1WmNajkvEFul9+w3hi58Y69r8rEnhlurVqS6m9HNAHUj8dk9ivb1gwhls2rQgK9vypx7L9FJZfxVEA01cBIBmQbPafzZxvIb5vTDWHWHrQSqCDR7tu8NwJFzv/K6h78gZvqzpX6wE+/Qsp9rq7uQxcBFSmo/LIrpr0SeO8lB1G8SkdwXIM/j/WMqm3K9tBNp1jf6zXzKkvqkbSxIBf/jxY9P3OUXGnqqp6iNPdguY8vSf6/7LNWRMe5teHay8DkM2BFrGynfT9g9BsjUp5DCy7zxZRCSoSu5mQDK5/eO4mwjs1RTvCeVOsgNin+LpYDA2qNkH/zG0jmIu4a4aRzwfuaUjYBElNEGPJEDGwUYsp0xiiHd7X16XzNls90egGoKciyQpZQI2JCyfA2LAYYNazEkmViIGK7yVWXwQzch7ZttpZOVLtkmZzDlSxT/p13KzIBxRZM+VI8PdMlPj/ZhOfFrFPv9oH/cAdSgB6+PCv6afI3nsuZRzbGsWZj3eJIwccXyR9Foe67NvYJJyiYYq09nNz3zdBKq9rXrphVEy2+tZMioDX2kzbPqzABWewP5Irt+ZQVNPh1f63ycpl2k4EPkUm7s8Ehvu8/ErmmqoQ6dTl2IgQVXeY0r7c507Dwo4kJvzuqxkDCWDpGMO4FhDxYXuxtGunquSA/kz3NaDlQ7sMx4dNLabLMldiadluLH8Ihcab/E9yWI9FOcuIV/TW7DkBjI0z4FA5Y8AvyicCErVBNR6Sq5EPMoCuDML560Kq9nfgWDDKNQWNHJsd4m902vLNRx4/rV+edBIBwtUt6tdHXDy0PfBiOPq1sJZQb5fRdQORyujz3xh7XGNe9ShaBG090qXs82erFZtC7ejNBTUX04uLIXtxhCLjUflmuRYq2vAtbge9g1UWOYBiYuDPQAIeYYUIF4GD/J
 b4kdbFJI
 wFpS0Nzs4/pukptKDgpgophXsOe5Yr8DaWZFeXet1XV41RWYtYcU7UO/oTWKcoW7rDJWMxilcjOEjNdjTaC5l6jY3hTVAqL0jXWvSu1SaVX977fCWnQRTIyka3HqfzXIMAa5OjQKGqBybVANQN9uZz78+RIxqqr7JxIvaRscIr5kWRkj+2NN55qTtFNSUK5g89UYqYMLsM8CrlQBMOX+oFuViarijQHeyKLHqRD74N57u2D+VtBg3TG7Vr4z7E/gYZAN9C7jgB03PS9NhkOFdfIIwy+3ttGI6DGAQ4qkz2qULYSWVXjssK8g5cpkzwUb0ks4PnzakeyCEQfj0IO8kROL9fv5LmwH3yTFUy2GBwQw56RIl4p23SLFx/u23BRMMZAGWKUYctEK8aIoOS59abQhjh0vyjSHJdwbfGye+FB0GaIASlHucdKEO0bB4P3tVwj5Ff0wawWMc1GVnhEebwkuvuT6P469Q32vdd0GRecKzh2i+IwWKcxIa529q6goxfNz8hLMWvZ0pFVdFkOQvEpwxkrSeguESDVUv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 01-05-26 18:57:52, Matthew Wilcox wrote:
> On Sat, May 02, 2026 at 01:44:34AM +0800, Barry Song wrote:
> > On Fri, May 1, 2026 at 10:57 PM Matthew Wilcox <willy@infradead.org> wrote:
> > >
> > > On Fri, May 01, 2026 at 06:49:58AM +0800, Barry Song wrote:
> > > > 1. There is no deterministic latency for I/O completion. It depends on
> > > > both the hardware and the software stack (bio/request queues and the
> > > > block scheduler). Sometimes the latency is short; at other times it can
> > > > be quite long. In such cases, a high-priority thread performing operations
> > > > such as mprotect, unmap, prctl_set_vma, or madvise may be forced to wait
> > > > for an unpredictable amount of time.
> > >
> > > But does that actually happen?  I find it hard to believe that thread A
> > > unmaps a VMA while thread B is in the middle of taking a page fault in
> > > that same VMA.  mprotect() and madvise() are more likely to happen, but
> > > it still seems really unlikely to me.
> > 
> > It doesn’t have to involve unmapping or applying mprotect to
> > the entire VMA—just a portion of it is sufficient.
> 
> Yes, but that still fails to answer "does this actually happen".  How much
> performance is all this complexity in the page fault handler buying us?
> If you don't answer this question, I'm just going to go in and rip it
> all out.

I fully agree with you we should verify whether the retry code still brings
in real-world advantage today with VMA locks. After all the retry logic has
been introduced in 2010. That being said if there are realistic loads where
one thread needs VMA write lock while another thread is faulting the VMA,
then the latencies can be indeed extreme. For example things like cgroup IO
throttling happen on the IO path and thus can throttle IO of a low-priority
thread for a long time.

BTW I'm not sure I quite understand Barry's priority inversion problem
since I'd expect all threads of a task to generally be treated with the
same priority...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

