Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BA2DCA5FC7
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 16:38:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CBC56B008A; Wed, 30 Sep 2026 12:38:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77BEA6B008C; Wed, 30 Sep 2026 12:38:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66B656B0092; Wed, 30 Sep 2026 12:38:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 367926B008A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:38:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B9B7E1A010E
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 16:38:23 +0000 (UTC)
X-FDA: 85270986486.15.E9D17F5
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3CCDB140004
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 16:38:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jf28N+bN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="ZndIq80/";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BdyjHtL7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/9RFpaNw";
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790786301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6rNIHEiHeQ4/1te1tCIJYZ0yxtmK/9zf6WGIQWiwdCw=;
	b=IB8jYuSrMGAGeMPH6mGalFWNGbfnhVUbweF/ijDecGuqlBtEhBEPc2Y3/jh7+8ugJ3ftz7
	o/MtPDGQlrfdwXW8WLoh0xa1A50f10+68ll/5A9VYBV9GzzoTWob8lcKgmLZyVFEUBh2Lo
	9G5lg2p1qgJkQB6eZNrD6JqQ/17HrXk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jf28N+bN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="ZndIq80/";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BdyjHtL7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/9RFpaNw";
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790786301;
	b=gsbAs+jZjktkOu+j+keqEMMNnYsP8lxeDB46czsxcctRIpCINcV8DnnjQ/ysrxPXfg1RhH
	YJhqds1nLmzOolIQvsIoGvFQaFM+Vd5p4v3fc4r6fHX8wlVJVM5oWWI2EdJLgYnge04/3D
	p1qhV+P1Tu71pdGFJaKrkwrLMrX6LIo=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 789AC1FAA8;
	Wed, 30 Sep 2026 16:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790786295; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6rNIHEiHeQ4/1te1tCIJYZ0yxtmK/9zf6WGIQWiwdCw=;
	b=jf28N+bNnwtnIgKrWWIkAIQD9VJAwEWkL7b3u1iFyhHGRu2/LOOetS4a5swsS8rxh9e0y2
	nWEMY02sKZW0XZ8bmpICmVDPnzo40gZT2/E5RE+MdSIiIT1EedqCGGsosxpQK3UKXUtYay
	1WbIJ2nKrTo7lx1IsL8NU9paWQlhE8k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790786295;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6rNIHEiHeQ4/1te1tCIJYZ0yxtmK/9zf6WGIQWiwdCw=;
	b=ZndIq80/xJ2Hf6JU626UZC7EwF3opWtR7widKF5HvGvhYajrDb4TeXZCDj5WOjn6jNcyLA
	HFbhBbRG8RkqpxBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790786291; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6rNIHEiHeQ4/1te1tCIJYZ0yxtmK/9zf6WGIQWiwdCw=;
	b=BdyjHtL7JOalyiE0rdgfKaljMauNFEzLxUKq32TPhUCtlUJOqYuAd2t3lBkFMOiHsGFCIt
	ubglxOKbfdoAzUBxp+9lsru+U1iiy6JdJKchqQJlQMuGISkf6NsNqRpE5KoiBVxpXe0/yy
	nj7AmV+RizfR5PVkkg3XRsrjT3qkHyY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790786291;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6rNIHEiHeQ4/1te1tCIJYZ0yxtmK/9zf6WGIQWiwdCw=;
	b=/9RFpaNwp1z1eMUOf/wlQzCfBEvTJWZgpcmBD66RahjIu+N/Jdw3lhXX8KGTAG7KJOxkJO
	tvzj9n691s1INsAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4D3B2136AD;
	Wed, 30 Sep 2026 16:38:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QvjICvM6vWq3BAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 30 Sep 2026 16:38:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id BC9CEA13AD; Wed, 30 Sep 2026 18:38:06 +0200 (CEST)
Date: Wed, 30 Sep 2026 18:38:06 +0200
From: Jan Kara <jack@suse.cz>
To: =?utf-8?B?5aSp54u8?= <rockeet@gmail.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>
Subject: Re: [RFC] madvise: best-effort deferred writeback for shared file
 mappings
Message-ID: <xhrorb6wn2j2j57ydnt226khnu6gv4ut3crrmjwjr4iwj7d6yo@43lugxdthgyi>
References: <CAAE3jtfeKJLSypScqRAEEgvO8En5kJfpbcFn5X+LQ2YL+xz_vA@mail.gmail.com>
 <85aff663-2131-47da-ac04-8f0799a49b91@kernel.org>
 <CAAE3jtcRQ407P9LTbg=JOwhABQRViSaq2XBefnDdNWiD7PxvUg@mail.gmail.com>
 <1ce9cf3a-15dc-4815-ba29-2e22b05206fb@kernel.org>
 <art8EKRKMdwSDCkr@gremlin>
 <CAAE3jtftxMkCfWJ77W-xvV2x7jdAN8C8kyofYC3fEivM-Cq6UQ@mail.gmail.com>
 <arz0auULA33fqoWu@gremlin>
 <arz8Plu6J4YOTi0a@gremlin>
 <CAAE3jtcanTUrV3xfofwrvYGCFe5o=Vn7gS66bDzuxzeGg6c5=Q@mail.gmail.com>
 <CAAE3jtdHi7aSsJ62TpEjkxvwA-3TBLvr5i1ohCNg2aupND+_XQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAE3jtdHi7aSsJ62TpEjkxvwA-3TBLvr5i1ohCNg2aupND+_XQ@mail.gmail.com>
X-Rspamd-Action: no action
X-Stat-Signature: p4a784jj3s494zeke34ozh6gkdrm55go
X-Rspamd-Queue-Id: 3CCDB140004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790786301-877622
X-HE-Meta: U2FsdGVkX1+vcQOjKrtNJ7ox2m5jFXQM/Dm1KhemFNGP8KhvIeS6FraF+S5Mt7HE8Pwi8/QX7pUFm/ptQkGfnf337G270+8gci6UpkI3nORMDqgOvQHdbTfJscIL4WK44GEuTmIXl6YoPVQqcHRzdfsKtDGEihaAGsFQXcH8ALTwK3MIcBXCi9m6b6OvW0HR+ixzY9Q/eC/bIbdL3g4w4w29oaW/hvGNiN83n0uLoNum6fAPOohl5Pg2fE62/mF3mpbQuMwAKlyADKAS4X7DLFtgsn9PN5oreI94A1RtNMvApV1LzrUMkkCGXsymrhaFlPLsgKdQQlqZQjIL8UkSUOgrAlR2apxYL5bwxy1gcv5TZ+zhJC4H6o7BmGcPCw6ffU6VJsxt/9T7uvs2FIFa/Zf+4bGuZLngasiZDqG4efboeMip52ycDnpHUPjbNrp64E0qx9Gjxwxxe1OahaV1y+lm2HXm6Xs9h+/DnaQ6XJNFyXdJQ7T8lkTvd5/LqKvFC4pXsuoCJV3tAugrBuW6oiMMAby/cIvfiWXZz5eA7AS/5BBf/tL5u63jiL8RQPKmYhCZTm4d/RWNTMhDI2uLnq90FMLtzzT26R7Eg0TltBhglIXtCwUKavbcUulun4cURKxEbvZQ7XDQL6GA1NKaB7HHUYhnCXcv6edo5GaheJZI40H4LK9I2Ge1GOc0yLeSPjR3huAloPLlBsa3LYcJ3sckNAa7kEaYpiF78LMW/hLs8cmbKyZQIyLC2Vta2ax6EzjunK2/O4iNIIeEvih9nMWw/md6DVsEoaTSp7agLKNrBQQqXgaOgZziunT6bt1AcXAPYwLHNL9tMK5z5Mh7ExF5z6x2AvTsNZn5hTdravlHxh3c8MM2ZB0/0tnRZDCzFc9eQ33df0bOJ29CJmIFwAftCeFl74j+teFIA+GZUei7vfHEsUzvW4dpEEcTJnc8rBHBk3o4RXyLH0uOnrD
 JZncRAFM
 EAYDf2J3wVH5SpVtt07dPQFTtafc1Kcqyzqw6jkqUno8ADcq1/zVeK2kGHa9YjUkwAgCUmNHZZ5L0zPaTdbnehBsQNNHoV7lXmsDirXJSFEYLgC3nj4+KIwpWQKSGMmXSCKbH9DfKWW/ixdWdRO5xOq7FzmZXfWDc58J0pSDVOcgbfl5Ibdl+0LNNLROmu1HmdP18yKC2qo97ZZsVvpKjclGNCyMyHXtM41Ynemufzq/iWQuq67WKQHsm+nn+bHWH9b/58rE3Aeh1e9NFs138omeHl0vFNoP1no4sxVnfQo5/eXM279cmHbSB/Fy4Cnk6HgpdjPlWVa9mfdiDFdjPblWUf/3v7McRVLews5DhonEhIvE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello!

On Wed 30-09-26 23:29:09, 天狼 wrote:
> The distinction behind this request is between surviving a process crash
> and surviving a power failure. After a process crash, the kernel and page
> cache remain alive. A shared file mapping therefore retains the writes
> already made by the process, even if they have not been written to disk.
> 
> ToplingDB has file-mmap MemTables whose data structures survive a process
> crash. Its crash-safe recovery reuses those MemTables instead of rebuilding
> them by replaying the entire WAL. A published sequence number aligns the
> MemTable's per-KV crash-safe boundary with the database's WriteBatch
> atomicity, so recovery can reuse the published data and replay only the
> remaining WAL tail.
> 
> These MemTables also support cheap, millisecond-level ConvertToSST
> (wrap-up and sync, i.e. LSM flush). The file-mmap path renames the existing
> file and appends metadata, preserving the data structure already built in
> it. This avoids copying the contents into a separately constructed SST.
> Moving construction into shmem would add a transfer to the regular file
> that this path currently avoids.

So I think I understand your design and the issues you're facing. After all
I've seen very similar issues with Berkley DB which was also using
MAP_SHARED memory for the DB and under some circumstances the workload
performance was suffering from too frequent writeback.

Now what I miss from your problem description is why "a transfer to the
regular file" from shmem would matter to you. What is the problem with
that? Because a lot of databases do it like that and it works for them. If
you use AIO + direct IO (or io_uring) your performance is going to be even
somewhat superior (or at least on par) to current writeback workers in the
kernel. In terms of data integrity guarantees you are again as good as or
better than using in-kernel writeback because you are in full control when
you write and what you write. So the only reason I can come up with is that
you want to avoid the complexity of your writeback process in your DB. But
in the same spirit we as kernel people want to keep the complexity out of
the kernel :) and if we'd add a feature like this we'd have to maintain it
practically forever so we are very cautious with that.

> Avoiding full WAL replay makes much larger MemTables practical. While a
> large MemTable is being populated, random updates can repeatedly dirty
> pages that background writeback has already written out. Those writes of
> intermediate states consume disk bandwidth without being necessary for
> process-crash recovery. Deferring them is a performance optimization;
> correctness does not depend on the kernel honoring the hint.
> 
> This is a general problem, not something specific to ToplingDB. ToplingDB
> explicitly distinguishes process crashes from power failures and has
> invested heavily in optimizing recovery from process crashes. By contrast,
> LMDB faces the same problem but does not explicitly distinguish process
> crashes from power failures. If sync is skipped when using LMDB, the
> remaining writeback problem is the same as in ToplingDB.
> 
> The global setting and kernel module described in my previous email let us
> work around this locally. The remaining problem is making the optimization
> available to users of a database library. We cannot reasonably require
> every deployment to change a system-wide setting or install and maintain
> an out-of-tree kernel module. The module gets us from no solution to a
> local solution, but it does not provide a broadly deployable interface.
> 
> That is why I am asking for kernel support: a supported, best-effort hint
> that applications can use directly, while leaving the kernel free to write
> back when necessary. madvise is not the only option, deferring writeback
> for the entire file would also be acceptable.
> Per-file deferred writeback would require minimal kernel changes and pose
> a very low risk, while offering enormous benefits.

The problem I see with your per-inode hint is that its semantics is very
vague (and practically tied to the implementation). And this practically
always backfires because people start to make assumptions about the
behavior, then something changes, people's expectations break and people
complain. Or they come with 100 and 1 ways how to tweak the vague behavior
to fit their special usecase and it quickly becomes a mess of conflicting
needs. We've been there many times :-|.

What I could imagine both technically and semantically feasible (but
haven't decided whether it would be used enough to be worth the hassle) is
to implement some say fcntl() / ioctl() with which an owner of the inode
could set / clear a file hint that the inode should be extempt from
periodic writeback - i.e., the writeback that runs once per 5s and flushes
inodes that were dirtied longer than 30s ago (by default). I.e., we will
writeback the inode whenever we see fit but we won't do it just because of
the file's age.

But again similarly as David or Lorenzo I think that implementing your own
writeback worker would be a superior solution for your DB.


								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

