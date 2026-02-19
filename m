Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24706E9A05E
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 19:31:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76B866B0005; Thu, 19 Feb 2026 14:31:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 715FE6B0089; Thu, 19 Feb 2026 14:31:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 638DE6B008A; Thu, 19 Feb 2026 14:31:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 508A86B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 14:31:25 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EB39A1C955
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 19:31:24 +0000 (UTC)
X-FDA: 84462200088.24.261F07A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8BEDE140003
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 19:31:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KiNeusGu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ov66jaO2;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KiNeusGu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ov66jaO2;
	spf=pass (imf26.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771529482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ja5Og09RxlX392w1rloNMZKpr6OKwMO+Kmc48XCYcw8=;
	b=S6omNSp5SHZJpZK8iaero0f/O842smn8HtZ4BgnFXn/ipz6RscsjS9HP673jcMm7assf68
	BfPAvJjGDwmJD2PTrfnvWrZNKmvm16g6CnWG6W/JPZvqNgKsRXU7l+6NEL104/1B0a7gzY
	tQ/YI4d+8CDRWw/YpMJYFEYViNnfxhk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KiNeusGu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ov66jaO2;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KiNeusGu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ov66jaO2;
	spf=pass (imf26.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771529482; a=rsa-sha256;
	cv=none;
	b=X3Oz39R8cwLo9s3Dj6M+ppjwYyZoK58F+2+eAR/fvERDgjEV5kptIectsAnszzxI2KWZJz
	/JEUXlIRlaXT6e1Sm7RHuJE05HgNeyfEyjLS3kLtpyqm80sOA7Zu6avy+ABINOYSiDzC6b
	6uA376Adyhq5330uA1JIklDcgN5B36I=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 738285BD0F;
	Thu, 19 Feb 2026 19:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771529480; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ja5Og09RxlX392w1rloNMZKpr6OKwMO+Kmc48XCYcw8=;
	b=KiNeusGuasTv0sJZmgkscIt52pZNtHyvB0xuONAe3xNM/58Yh68v4BNU2zmrH9EPsg8Vaw
	dhFYaOU7FI1G7wdhNgJtKYKdPcCDnGQK2gH+cV/AT7uLbcKprEB2jUl2OX9Dd2YHhjJG8g
	vQfSpCztGpNMtWwbt7VMwf0+CE83jtY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771529480;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ja5Og09RxlX392w1rloNMZKpr6OKwMO+Kmc48XCYcw8=;
	b=ov66jaO2qZD4bvDabAzEc36QnGv3CRyuA4SnGQnDmUUJlcre5Pw+X3+FqptiWu2ZpRQTNA
	MBQQSy7QNnPCDQDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771529480; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ja5Og09RxlX392w1rloNMZKpr6OKwMO+Kmc48XCYcw8=;
	b=KiNeusGuasTv0sJZmgkscIt52pZNtHyvB0xuONAe3xNM/58Yh68v4BNU2zmrH9EPsg8Vaw
	dhFYaOU7FI1G7wdhNgJtKYKdPcCDnGQK2gH+cV/AT7uLbcKprEB2jUl2OX9Dd2YHhjJG8g
	vQfSpCztGpNMtWwbt7VMwf0+CE83jtY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771529480;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ja5Og09RxlX392w1rloNMZKpr6OKwMO+Kmc48XCYcw8=;
	b=ov66jaO2qZD4bvDabAzEc36QnGv3CRyuA4SnGQnDmUUJlcre5Pw+X3+FqptiWu2ZpRQTNA
	MBQQSy7QNnPCDQDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 467023EA65;
	Thu, 19 Feb 2026 19:31:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JSTMDQdll2ktKwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 19 Feb 2026 19:31:19 +0000
Date: Thu, 19 Feb 2026 19:31:17 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, lsf-pc@lists.linux-foundation.org, 
	linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <65lbqd2zfawnbzbonblf2br46p44sjas5m6dnp55ekm2ljn7rk@onqdty3be5lo>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <l5lnb7fvqk2fndlvejibcrxru7i5xwdchl2hcnlk6dzttdfkyc@vtuqkied3mtt>
 <aZcuvbTTXn1MD5KK@thinkstation>
 <0e2621c6-8829-46d1-9f29-81aebf365ba3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e2621c6-8829-46d1-9f29-81aebf365ba3@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8BEDE140003
X-Stat-Signature: jh8hrkaicbwh5m8b9dftiqqgzyijmuem
X-Rspam-User: 
X-HE-Tag: 1771529482-316413
X-HE-Meta: U2FsdGVkX1+uOB5seGxoWK5jqwNV6Mi4LSKP/tSjnkl06e81lHJQKKrBurzI95Yafx99hNjZtC+ZgHhHe7s/NtZ4u9LDxG9bEfj82j51t6LQhns3GdmVvadzw9VaknLgN7r+5YDCcfp3aVu2T0Y+opz35rQEGIwHsTqYpiEc60vejj9Uw2ARUgsTIGYcqQ3hJ5bhuOr8ZI+jSZrglysAWPlbOyurjem9r9ooaZk7nSbZ7KKh50rJMk8I1UKNq6MKRHjk+BRg14AGXNQdo87o+SUvGVdFYj/LPvfy985h0wOx3LRVCnvCKTyxn4hA94MmtyPOWG9MKKSdSGYIv01k3wYOceQJcXOchh6I7Q2UXS7mdZW9CLLtlamtLqjcB/O3G3WxhRfQVg62QyrFSv+r1GWigrdqwoTRR5L1K3ntvN1Gtu0NHbXpIuRYVb5iEvurK5Z2vVoyTJov3uH4MhiPXzbfdxmccBDiy1dv5f3qkMVedkmqpHgD6hp1ezTF2k1kvAxHmqRqdwkuKj7zqzupeNvqZHrJW/dEoof8ySZQSs7b8y/x8chQUXHtPHXuZ1moBvGjLo/gfuF71PSUBmwSpFIRIUugUA9XVDcmuM6pLozdz0RIck47BCV3jy8lB85zc/Do8h+qNAxSoEnPK/nQQUFne8oVCI0qP6/V4uJ64tpG0LRDMBfwUkD0UVV4MfTKzwtmNb+eoITayaNcZ4VvwtDqZ6wAExyixAufQZ4DPXe2AN78ad3mpfafiFHCVWnd5x/p7dM0OXvRG77F1VXFEKuYtWM6vi2AS5oNNcEf4BW6IvUyO5KUvvbgPAV5XA7lMLOggWoHaCwqzUSH6grx4vgwm+U0A3STRGpTHdJywcpZfgAf553GDYlcU2HMlE/3db/LiaE84q7CS5K7Q2fr1E54K7sxqRGlbwY8xUU0i7AsO/O6S0yw3QT51FjU5HyrI5rQM49M7ZN9C0Kai3f
 YsI7kXj2
 uAJM0ysBDyjkw9mG+H/nTTcTpszyh5JalXZUvciq1hKILqbS1ZbR294HfiFOyAuNTm2PMtXhIAXVtk2c/LOh2HBW2RmsCzrZ5MJ5QnqXPyxwmE3BzlSbw5K3eIi4TE+sKIhMzz8CJKXGvXyXjEbf7/kZW5FH9PZ3OuMZ5U60TKo0LgkRxJduWpbm/yVVBbEJlmNJgFpddRsK9jqOl+rudobNwyP3aoEZZOtZBmgFcwj1PD4taDxybbKInDUbhxqwvcmkOktgDAODr6EbDB1Km4Dx1BY0NC7T/EpVdxsSuwwJgoSc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 04:53:10PM +0100, David Hildenbrand (Arm) wrote:
> On 2/19/26 16:50, Kiryl Shutsemau wrote:
> > On Thu, Feb 19, 2026 at 03:33:47PM +0000, Pedro Falcato wrote:
> > > On Thu, Feb 19, 2026 at 03:08:51PM +0000, Kiryl Shutsemau wrote:
> > > > No, there's no new hardware (that I know of). I want to explore what page size
> > > > means.
> > > > 
> > > > The kernel uses the same value - PAGE_SIZE - for two things:
> > > > 
> > > >    - the order-0 buddy allocation size;
> > > > 
> > > >    - the granularity of virtual address space mapping;
> > > > 
> > > > I think we can benefit from separating these two meanings and allowing
> > > > order-0 allocations to be larger than the virtual address space covered by a
> > > > PTE entry.
> > > > 
> > > 
> > > Doesn't this idea make less sense these days, with mTHP? Simply by toggling one
> > > of the entries in /sys/kernel/mm/transparent_hugepage.
> > 
> > mTHP is still best effort. This is way you don't need to care about
> > fragmentation, you will get your 64k page as long as you have free
> > memory.
> > 
> > > > The main motivation is scalability. Managing memory on multi-terabyte
> > > > machines in 4k is suboptimal, to say the least.
> > > > 
> > > > Potential benefits of the approach (assuming 64k pages):
> > > > 
> > > >    - The order-0 page size cuts struct page overhead by a factor of 16. From
> > > >      ~1.6% of RAM to ~0.1%;
> > > > 
> > > >    - TLB wins on machines with TLB coalescing as long as mapping is naturally
> > > >      aligned;
> > > > 
> > > >    - Order-5 allocation is 2M, resulting in less pressure on the zone lock;
> > > > 
> > > >    - 1G pages are within possibility for the buddy allocator - order-14
> > > >      allocation. It can open the road to 1G THPs.
> > > > 
> > > >    - As with THP, fewer pages - less pressure on the LRU lock;
> > > 
> > > We could perhaps add a way to enforce a min_order globally on the page cache,
> > > as a way to address it.
> > 
> > Raising min_order is not free. I puts more pressure on page allocator.
> > 
> > > There are some points there which aren't addressed by mTHP work in any way
> > > (1G THPs for one), others which are being addressed separately (memdesc work
> > > trying to cut down on struct page overhead).
> > > 
> > > (I also don't understand your point about order-5 allocation, AFAIK pcp will
> > > cache up to COSTLY_ORDER (3) and PMD order, but I'm probably not seeing the
> > > full picture)
> > 
> > With higher base page size, page allocator doesn't need to do as much
> > work to merge/split buddy pages. So serving the same 2M as order-5 is
> > cheaper than order-9.
> 
> I think the idea is that if most of your allocations (anon + pagecache) are
> 64k instead of 4k, on average, you'll just naturally do less merging
> splitting.

Yep. That plus slab_min_order would hopefully yield a system where 90%+
(depending on how your filesystem's buffer cache works) allocations are 64K.

-- 
Pedro

