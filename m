Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F37B2EE6B44
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 17:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CA0F6B0005; Fri,  6 Feb 2026 12:34:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 477D76B0092; Fri,  6 Feb 2026 12:34:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34CB96B0093; Fri,  6 Feb 2026 12:34:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F61E6B0005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 12:34:31 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BF6F81B08A0
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:34:30 +0000 (UTC)
X-FDA: 84414731100.08.68FEB58
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4C62B8000B
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:34:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vm8Fg+FJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HmdQb3ok;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vm8Fg+FJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HmdQb3ok;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770399268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KzcSvBrkCZ6hqwbe0q+3XZbA+hCy0075eIN7Kvu56m8=;
	b=8pfkdXFNXUMwnJ991/gIeXSBVV0TAzNKAGHZCc/EWixP+PLdb/tfiH9KPmBRCYLhWKOc/s
	kWXoIBDhS9t1Wph1dnSKDzDELi774h3a7bB8Q9ar00i9B5tLT9UZAYK47m1OBJdPOCjW/t
	nuy6R1yNHtHFkrtZADnW1NmloWXI5SA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vm8Fg+FJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HmdQb3ok;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vm8Fg+FJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HmdQb3ok;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770399268; a=rsa-sha256;
	cv=none;
	b=SFwp3SsVV525oI/atm7cwbS2sY9ftsjkBqR8p2Cy2Z0eCv3plqBLxQHiRyWB9cWPPSkmSU
	c8JzEiKYo2i+zPAPwguoXG8mCUjnSeEo7FIUSu3iaoosj5za61gazuwwN0PQIBw68W/QV+
	yymu6RXOdmusPuhNkqessjG+BkIrlJY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8095A3E6D6;
	Fri,  6 Feb 2026 17:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770399266; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KzcSvBrkCZ6hqwbe0q+3XZbA+hCy0075eIN7Kvu56m8=;
	b=vm8Fg+FJKNVnpxYR2SRg/827ADrVaCtxQKOmYeJ5HvoFA6lwE34i6k+atXJdyqwyQ7Qjae
	Se5qY5K6IHXO51xqPWogOK3lnsEMD1bcYRnMzpwCr6isFmTxCBJnR4C2thvMnkJ5EE3t8p
	2Zm6DMSexOummQQC8etcAhKIvlKVVk0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770399266;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KzcSvBrkCZ6hqwbe0q+3XZbA+hCy0075eIN7Kvu56m8=;
	b=HmdQb3ok7Aoh2RbgwCIdYe+bfofthbR1PwBmvHZiNV/8k17gHAdfoVZff5pnWAEb/ZmT0x
	vN9ok3hcHtVjYMBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770399266; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KzcSvBrkCZ6hqwbe0q+3XZbA+hCy0075eIN7Kvu56m8=;
	b=vm8Fg+FJKNVnpxYR2SRg/827ADrVaCtxQKOmYeJ5HvoFA6lwE34i6k+atXJdyqwyQ7Qjae
	Se5qY5K6IHXO51xqPWogOK3lnsEMD1bcYRnMzpwCr6isFmTxCBJnR4C2thvMnkJ5EE3t8p
	2Zm6DMSexOummQQC8etcAhKIvlKVVk0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770399266;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KzcSvBrkCZ6hqwbe0q+3XZbA+hCy0075eIN7Kvu56m8=;
	b=HmdQb3ok7Aoh2RbgwCIdYe+bfofthbR1PwBmvHZiNV/8k17gHAdfoVZff5pnWAEb/ZmT0x
	vN9ok3hcHtVjYMBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 47A993EA63;
	Fri,  6 Feb 2026 17:34:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2/slESImhmnNcAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 06 Feb 2026 17:34:26 +0000
Message-ID: <651bd1f9-8971-48da-a0c4-328e235c2eab@suse.cz>
Date: Fri, 6 Feb 2026 18:34:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: skip debug_check_no_{obj,locks}_freed with
 FPI_TRYLOCK
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>, Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 stable@vger.kernel.org
References: <20260206165802.17280-1-harry.yoo@oracle.com>
 <7B9B9CF3-29A6-4271-8C3C-87FF3EB9FA4D@nvidia.com> <aYYi3DhceyKbta2Y@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aYYi3DhceyKbta2Y@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: pcw6brz1eqob9eqys1a1x5hazwihh3ig
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C62B8000B
X-HE-Tag: 1770399268-546474
X-HE-Meta: U2FsdGVkX18G+F84WbY+CzZD/uaDa0jilN2wEEQmu3HcY6S9T5QC0xyYT9aMzFCujnrevPIE5aaiyxQSLnKeA0yz7AzAyrGHaPHhTxngoeiqd0hsJUQ6T2FmkPKYqUfqPm9QDDBgdOr0vv/lgwE4UAKft1X7ZULEF5yGlySzkC+g8agpPL07HcRfLYgLw7Jqy6FGcMKms0YRLOumv0NikkJovCbuWTqGGdmvIRLrmXukrSkPlPhUt1KCidDtv8/1wJYIwU9btZUAD1WXEYF4HwMML/Fudw1gr/MA7Lzc9UA19Ev8Bze/AWW9FAqsc/pfeZUkdTkNp+qaCp9xuUA8mSN2RnuDxZX1Tfth28vESyliFF9+qanzYHa89Z2YwvPtMqTI6PERda2AKvkBXWB6ia7OrjWRsAAF3mik+AVmrc7VmPKZ4Gd9hWRxUs6cLULKR8RO9G5+dxSJw7WnlBr2dG7LKlQf48KSGcmU3vAaOVOYoFLE8ydafW7TC91acONCBtaQ9XO68YEeB1xgvVriZx+F1OngFX0MW29HJnJZ+Qw9pVByggmgFIQ9F4PEkB8gOYUlQFdGsjnUJJWoOn/zbwfWtEfnPhWHQsH7uP7tgQwYtc8Cec7/dgSlMUfOaUIo0UwFdsIKn5fXI4gMx/JrruAnbp2W6vqN+HHDyD1BnAtGdJrTc8lf7W3UGZypFtMzwebDSFXOO+somFFm+jGiqUmpUS/YhLhMAgLepSwEpVpH2qkHKtMXT/pTSbDr5c/DLvAapwlURTewXkgemrDkFwo39996f29kjXUgXfdhtsZEo+RbOIEBFfBJz4rIeYo5NGUpeZgHK5bvbnQT2Ci5iPipmjPB9pygHPz89FsYq/75Eq5fXKbb1vjmNuInHMxopbYzEyFn9pft3DoX9FotpVTy4kVFv0mOe9F2Q0kY9eqiTSfkngxJxlfHbV4qwBZDmjtieNfmAvmoHYSlw+N
 ugcnyDZO
 Bsr9ygnDrALiKKVlL+d1y9mIsJ1bOGGda5bHtePBAzqgvynpmlbxbh2xf0s2RI9HHwKKtxnfrHwzZ0cZ359B0/XgUZqf3HJgoon7QWwxGA4TKHGCV5UueNcMxmD9XpCqUAZOcI1n4UlKJ9GR+rYo/ldpDKViP+d9s4sL2YNejHkLIQ3KfqvkvK7iXfGl2pKizRtxApPiEwABnfSrtHVRW0v5B4OQZ9dOoaM3GdS6SnFkgym5Fr1/jpefXGfhl2I1gQAo77Y34WMHtI1XkIvJfIKx2DO+OcPBgmUqJan2O9WPfMptTyl6j7+4AT7eQAzycFsw4nb+NfI0qRnKiCRnqOQo4Ud9te1vZoMWmRhwf4/x3pSMNSF8QSAcSrxFBuTbhNzu7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/6/26 18:20, Harry Yoo wrote:
> On Fri, Feb 06, 2026 at 12:08:04PM -0500, Zi Yan wrote:
>> On 6 Feb 2026, at 11:58, Harry Yoo wrote:
>> 
>> > When CONFIG_DEBUG_OBJECTS_FREE is enabled,
>> > debug_check_no_{obj,locks}_freed() functions are called.
>> >
>> > Since both of them spin on a lock, they are not safe to be called
>> > if the FPI_TRYLOCK flag is specified. This leads to a lockdep splat:
>> >
>> >   ================================
>> >   WARNING: inconsistent lock state
>> >   6.19.0-rc5-slab-for-next+ #326 Tainted: G                 N
>> >   --------------------------------
>> >   inconsistent {INITIAL USE} -> {IN-NMI} usage.
>> >   kunit_try_catch/9046 [HC2[2]:SC0[0]:HE0:SE1] takes:
>> >   ffffffff84ed6bf8 (&obj_hash[i].lock){-.-.}-{2:2}, at: __debug_check_no_obj_freed+0xe0/0x300
>> >   {INITIAL USE} state was registered at:
>> >     lock_acquire+0xd9/0x2f0
>> >     _raw_spin_lock_irqsave+0x4c/0x80
>> >     __debug_object_init+0x9d/0x1f0
>> >     debug_object_init+0x34/0x50
>> >     __init_work+0x28/0x40
>> >     init_cgroup_housekeeping+0x151/0x210
>> >     init_cgroup_root+0x3d/0x140
>> >     cgroup_init_early+0x30/0x240
>> >     start_kernel+0x3e/0xcd0
>> >     x86_64_start_reservations+0x18/0x30
>> >     x86_64_start_kernel+0xf3/0x140
>> >     common_startup_64+0x13e/0x148
>> >   irq event stamp: 2998
>> >   hardirqs last  enabled at (2997): [<ffffffff8298b77a>] exc_nmi+0x11a/0x240
>> >   hardirqs last disabled at (2998): [<ffffffff8298b991>] sysvec_irq_work+0x11/0x110
>> >   softirqs last  enabled at (1416): [<ffffffff813c1f72>] __irq_exit_rcu+0x132/0x1c0
>> >   softirqs last disabled at (1303): [<ffffffff813c1f72>] __irq_exit_rcu+0x132/0x1c0
>> >
>> >   other info that might help us debug this:
>> >    Possible unsafe locking scenario:
>> >
>> >          CPU0
>> >          ----
>> >     lock(&obj_hash[i].lock);
>> >     <Interrupt>
>> >       lock(&obj_hash[i].lock);
>> >
>> >    *** DEADLOCK ***
>> >
>> > Fix this by adding an fpi_t parameter to free_pages_prepare() and
>> > skipping those checks if FPI_TRYLOCK is set. Since mm/compaction.c
>> > calls free_pages_prepare(), move the fpi_t definition to mm/internal.h.
>> >
>> > Fixes: 8c57b687e833 ("mm, bpf: Introduce free_pages_nolock()")
>> > Cc: <stable@vger.kernel.org>
>> > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
>> > ---
>> >  mm/compaction.c |  2 +-
>> >  mm/internal.h   | 35 ++++++++++++++++++++++++++++++++++-
>> >  mm/page_alloc.c | 42 ++++++------------------------------------
>> >  3 files changed, 41 insertions(+), 38 deletions(-)
>> >
>> > diff --git a/mm/compaction.c b/mm/compaction.c
>> > index 1e8f8eca318c..9ffeb7c6d2b0 100644
>> > --- a/mm/compaction.c
>> > +++ b/mm/compaction.c
>> > @@ -1859,7 +1859,7 @@ static void compaction_free(struct folio *dst, unsigned long data)
>> >  	struct page *page = &dst->page;
>> >
>> >  	if (folio_put_testzero(dst)) {
>> > -		free_pages_prepare(page, order);
>> > +		free_pages_prepare(page, order, FPI_NONE);
>> 
>> Is it OK to add something like free_pages_prepare_fpi_none() for this one
>> to avoid the FPI flag move?
> 
> Yeah, moving FPI flag definition isn't great :)
> 
> I'm totally fine with your suggestion,
> as long as page allocator/compaction folks are fine with it!

Maybe even like this?
free_pages_prepare() which calls __free_pages_prepare(FPI_NONE)


