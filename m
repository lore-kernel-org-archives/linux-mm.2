Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE947C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 14:45:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F7CD8E008A; Thu, 24 Jul 2025 10:45:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A6B28E007C; Thu, 24 Jul 2025 10:45:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 196958E008A; Thu, 24 Jul 2025 10:45:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 055408E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:45:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A48C81D9608
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:45:18 +0000 (UTC)
X-FDA: 83699431116.06.00E6230
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2975EC000F
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:45:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eju9qaJv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ISBEXTp9;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eju9qaJv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ISBEXTp9;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753368316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X04DjsKOa5+/UwUJIs6OjpEsdAubLYmuiRKetZmnjHo=;
	b=lOr/QcVkyyOLOZ0+MeMOWczGgNpHnhrJ5CZesVceW65gRAC8sy5xOj4vjZcupyW8TF3WmO
	smIF7q1CEH03UTA3zmiQbLUl6RtJKsUyw5pyz/CMiPYy3sfnL49DgYZbHMxNAcjMAtXDJ8
	fA8xR8wgZl2+jEVGyPfWtBm4RG62q3A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eju9qaJv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ISBEXTp9;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eju9qaJv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ISBEXTp9;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753368316; a=rsa-sha256;
	cv=none;
	b=h/0jIRoAuPX299WVc9xWZYO3D9R8d27YgNpB6ZtBhtFjQ4YnWZ0Fcoad9oIOvEVg9iPFdj
	A/YWHYaX4gwv14FnDL+8/Kl2aEgl9hrnlB/qViF0x4RD7UDW9Yp0FJ9PJASdU8J+9x7qkt
	8Eru+zg47LETvvPvPgFiUMMYYvYNwQQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 731D11F394;
	Thu, 24 Jul 2025 14:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753368314; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=X04DjsKOa5+/UwUJIs6OjpEsdAubLYmuiRKetZmnjHo=;
	b=eju9qaJvgX7uIibKIhPCtq5ayo4xSBNhT2GAehjJbnuTTzkgfG/xTy3d2ltyC9WWkpeIYL
	H/GUtZH5XI7solDcN8E400qS7T6um+1jOP0vgNfa2VwhoBOmfOm6ZWAgy0HswPQ502Ud8f
	WQ06x29MqVb1JkcAvJV1gv7j8AMNimY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753368314;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=X04DjsKOa5+/UwUJIs6OjpEsdAubLYmuiRKetZmnjHo=;
	b=ISBEXTp9nox8/5HWEvGta9VB5cdBBNHfvq9Nq/jqOIil1Pc6b39wbBbOMOHYN/E1nhVj+e
	vSFWHXWat3YbUQCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753368314; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=X04DjsKOa5+/UwUJIs6OjpEsdAubLYmuiRKetZmnjHo=;
	b=eju9qaJvgX7uIibKIhPCtq5ayo4xSBNhT2GAehjJbnuTTzkgfG/xTy3d2ltyC9WWkpeIYL
	H/GUtZH5XI7solDcN8E400qS7T6um+1jOP0vgNfa2VwhoBOmfOm6ZWAgy0HswPQ502Ud8f
	WQ06x29MqVb1JkcAvJV1gv7j8AMNimY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753368314;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=X04DjsKOa5+/UwUJIs6OjpEsdAubLYmuiRKetZmnjHo=;
	b=ISBEXTp9nox8/5HWEvGta9VB5cdBBNHfvq9Nq/jqOIil1Pc6b39wbBbOMOHYN/E1nhVj+e
	vSFWHXWat3YbUQCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5FEC5136DC;
	Thu, 24 Jul 2025 14:45:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id grASF/pGgmgEOAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 24 Jul 2025 14:45:14 +0000
Message-ID: <3be82198-a992-4917-b5ac-b93bb0474ad1@suse.cz>
Date: Thu, 24 Jul 2025 16:45:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] hard-to-hit mm_struct UAF due to insufficiently careful
 vma_refcount_put() wrt SLAB_TYPESAFE_BY_RCU
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Pedro Falcato
 <pfalcato@suse.de>, Linux-MM <linux-mm@kvack.org>,
 kernel list <linux-kernel@vger.kernel.org>
References: <CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com>
 <16c97e30-19c9-41e8-b73b-c0b3c8eceff3@suse.cz>
 <CAG48ez1qhjQNHC+3572udqVWHTANFpQ0ngxn_4ZDC9F8NCXsFA@mail.gmail.com>
 <c53b22c3-9f7f-4793-9d10-f4df861a3e32@suse.cz>
 <CAG48ez2cGX3e5bqgcw0OEnho29+YhwG2eOrHRgNwGAA_Nb65nw@mail.gmail.com>
 <CAJuCfpEcjH+W83At8WSkgzO=JvZmapg6dPaXmuSRS4ufhSha4w@mail.gmail.com>
 <CAJuCfpHk_k5eVhAZTK=jJvES9311Hyo_YXxY-S56EAYSBuRVRQ@mail.gmail.com>
 <702ab3bb-db4c-49cb-bb77-4e864cae610e@suse.cz>
 <dbc20783-0ff5-4902-bd73-e9282bfd87ba@lucifer.local>
 <CAJuCfpEVrpHACx2G2=Gq7YadxkA-DnFpFmbUij=Xr1=w7yrLbg@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAJuCfpEVrpHACx2G2=Gq7YadxkA-DnFpFmbUij=Xr1=w7yrLbg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Stat-Signature: 1tbczsc11k8paxc54n9x9iaq3k1rfye1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2975EC000F
X-Rspam-User: 
X-HE-Tag: 1753368315-473549
X-HE-Meta: U2FsdGVkX19lLjJZHgzNUltjN/JX8TbohchqMCogEZ9xOLCz133TUdu2gfTjQ1TtPEe9Ut+u45D7t+j/eFdU3ubUmrK91lIa/hhq0wl/GZBbZE/XM/05g31BOzKNU3ANlluXONnDjTJs8HvpBNZdz78ST/USNj7HL5bxMk63fErpwR8tSGXB47KKqgaKaYoWCme8kCBTkRgJVV/ll1b+pRXH9lgJdnnwh1RVIHK8SAa4dKt7Am9oBh2nFwXIfKxe2kflrJiPOialmtYYrfXN2sz9N+xt9SHWSBKrG9ADG7571nIHGgbWC3SFUXgn0FRn5UnlAqbzD12AS4TOFV4auuGhJvKFJwmg4mw6iW4r99N3TIKXOt0KFdMGBdjrSAT333GvEamoobr3P4L1E5w6OzWVd008mybRPbJNVqr7bdGDF5hZwE4TxcfzzSERhn3Qqh8maKnow6HkXz8US3dU2FWgRgF6MqdM3iwey8d3XuMIYM183oHXpCo6ZZp/bY5Tx6WtAab0Jr40eF6Fy6a8EpTXu42Cxl2YLxKYkOGnp3G2tvQokM38aSbU1g367/MjXhMQIRqecBa01qPwtoBTXm6jZzQT2Q9SVc4lazcorz4WqVZxNiq9n477eZp4X1tkQyPC+672HXX+HtbHOgNyok5bw8+rFLL31AO3I8IqJdeZ4kEuaMaF9uPEzylsbDOC+zknsikMkDSzHy1ME3/kfsjTa0aMry3jJgm43Vi/o0l4gFCABs+qiRK9guFcnSHqjAppaGhcOPdfkYJrDsOf1++AXTeVx++KJJFlwm11V3Ug3PZdWKvs9lb7xQd/6Us9mPQIolmBzInUK2NP/oUr3bbzwXWX4d6C8gjE0uVocFnR765SmECz/Ak8ddQrP4A/+W10bTSLksN92ZnffG5wfBGNinjFSkIntlSltlhuamen/Ff2hrO9lKvBZ17b1wbGQ9MXN1By5aw/ppv9vdZ
 CYAQtd19
 DrHRFocLSY4AuZIn5OeArBwAGufIgecRjMdk0Kx5ZBDNgF9K4F6Qd2lBEzrtQIRjrnbWlDrTGB46O2tDUA9vD9cF67uWk0EYbJx/9DsKtIuY6rltcwrjJrd0qbUdE8aTFZE3/J2y1+ldoOjRIZwKTFb893gjVH+qR9rmD+SBPw3dOOzrzHUofozabQlA6VYTuFW22Tl3YJKUliddVBd1vnbeI0COeohU0xVMOOFR8SJY8sSc3WWWq3wwJhk6YD78jbhFUOCBdXMjCigpc4CuAW4AZy+3msR4SNvAtGbgbbE8lYIFUdfTrdRgcI1dcQDDu1meuw7p4XzypmjGY1JDzMomraJ/g8EdHBLOsYjrJbFqPfY0axy4l2jOUxHhA1+fO1VWl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/24/25 16:29, Suren Baghdasaryan wrote:
> On Thu, Jul 24, 2025 at 3:53 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
>>
>> On Thu, Jul 24, 2025 at 10:38:06AM +0200, Vlastimil Babka wrote:
>> > On 7/24/25 04:30, Suren Baghdasaryan wrote:
>> > > So, I think vma_refcount_put() can mmgrab(vma->mm) before calling
>> > > __refcount_dec_and_test(), to stabilize that mm and then mmdrop()
>> > > after it calls rcuwait_wake_up(). What do you think about this
>> > > approach, folks?
>> >
>> > Yeah except it would be wasteful to do for all vma_refcount_put(). Should be
>> > enough to have this version (as Jann suggested) for inval_end_read: part of
>> > lock_vma_under_rcu.
> 
> Yes, definitely.
> 
>> > I think we need it also for the vma_refcount_put() done
>> > in vma_start_read() when we fail the seqcount check? I think in that case
>> > the same thing can be happening too, just with different race windows?
> 
> Yes.
> 
>> >
>> > Also as Jann suggested, maybe it's not great (or even safe) to perform
>> > __mmdrop() under rcu? And maybe some vma_start_read() users are even more
>> > restricted? Maybe then we'd need to make __mmdrop_delayed() not RT-only, and
>> > use that.
>>
>> Agreed that doing this under RCU seems unwise.
>>
>> I know PTL relies on this as well as zap PTE page table reclaim, likely these
>> wouldn't interact with an mm going away (you'd hope!) but it seems unwise to
>> play around with assumptions here.
> 
> __mmdrop_delayed() is a viable option but I would hate adding
> mm->delayed_drop for !CONFIG_PREEMPT_RT just for this one case.
> Alternatively, we don't need to be in the rcu read section when we
> call vma_end_read() inside lock_vma_under_rcu(). We refcounted the
> vma, so it's locked and stable, no need for RCU at that point. We can
> move rcu_read_unlock() before vma_end_read(). However that's not the

Seems correct.

> case with the vma_refcount_put() inside vma_start_read(). We could
> change vma_start_read() semantics so that it drops rcu_read_lock
> before it returns.

Looks like there's no other users of vma_start_read() than
lock_vma_under_rcu() itself that we need to care about, so seems fine.

> That way we could do vma_refcount_put() after
> rcu_read_unlock() in both places.  The retry case in
> lock_vma_under_rcu() would have to reacquire rcu_read_lock() but that
> retry is not the usual path, so should not affect overall locking
> performance. What do you think about this alternative?

Sounds feasible.

I guess at that point it would be cleaner to combine vma_start_read() with
mas_walk() into a new function that does both and starts with
rcu_read_lock() itself so we don't have the ugly scheme of entering under
rcu lock and returning without it?


