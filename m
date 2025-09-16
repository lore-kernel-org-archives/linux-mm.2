Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FE4ACAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 19:06:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42EA78E0002; Tue, 16 Sep 2025 15:06:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 406458E0001; Tue, 16 Sep 2025 15:06:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F4BF8E0002; Tue, 16 Sep 2025 15:06:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1DB5B8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:06:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C5D3013A677
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 19:06:52 +0000 (UTC)
X-FDA: 83896045464.27.289317E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6151D14000C
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 19:06:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BkQ9sVpg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=detH+pTt;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UY5pANxy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qRIxzE++;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758049610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z0CsoB2u/Wp5f+eUwf5QqOHPU7oLQ2P8bvxnpsmIm8k=;
	b=Dz8YQw/32vdIJOA7BER4L6WL3KtSSjdgyUC7GEBraDjtc0GclkNWK0u8PpplU6hwTUhcY5
	NHkza9IUfIPnVpsbOW2q9113T+gP4TjIqnVVkBw6PbcviQQyCxXyX64M+HL6oi3P/xqh20
	iLSsn5RIChOj2ubomHS9Biyzvyic+zM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BkQ9sVpg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=detH+pTt;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UY5pANxy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qRIxzE++;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758049610; a=rsa-sha256;
	cv=none;
	b=kRY5KsVGLWqrRWOVzRIIx2D/faa3kucx3ObF0T2yN8oMNI6Vf7SJFc8Yy+bpXoiYn3GeHi
	BXijJd871KkZq9l6BncbpP9S7qw9KT4jmeywNJGCQ7ZeO/47s654el81MRhUXUeOyYZvdj
	gPIuG9LztNSwbQpMTT9FeZt7ND5EfXU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5F9421F387;
	Tue, 16 Sep 2025 19:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758049608; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=z0CsoB2u/Wp5f+eUwf5QqOHPU7oLQ2P8bvxnpsmIm8k=;
	b=BkQ9sVpgeV3bLJLdRtlEsUcBL6aZT3wErh26JI9Q/bjkpD7iMfxNb0bfXCV+X+xo4J3OSv
	e4i0UPhlctoWyPWd7J5irdketMh7VoKMAryiflGatOhuwheJD7ZAMj95nWG/fuAyl2U+BK
	WSCVe81qi5x/FmbDXlYE0P/+mMyBTPg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758049608;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=z0CsoB2u/Wp5f+eUwf5QqOHPU7oLQ2P8bvxnpsmIm8k=;
	b=detH+pTtSe2oGfL6jEsi7P62IH6bVjUDpoupd87iooWxlse04bezsTwWNmvjG5M08qlH42
	shTrFU7iLwVkhvDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758049607; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=z0CsoB2u/Wp5f+eUwf5QqOHPU7oLQ2P8bvxnpsmIm8k=;
	b=UY5pANxyJy5RTG066fZMkxnVog2AdmzAi2Mnxu4QJJBxUkcfEkH0AZpl5D/ZcON5bQUfBx
	G8NKuVowobEBSQFYl1mwcDwsHArblD23r7Zaq25y5IOU4SvSJtBmy16f30y7n74P7sUp3t
	lm21ylrCPXEVyNGm+xvywowNa/N0WI0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758049607;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=z0CsoB2u/Wp5f+eUwf5QqOHPU7oLQ2P8bvxnpsmIm8k=;
	b=qRIxzE++xd3VrBYky0qq3mWuR0sWnd4tckgx5T2yfL0l1YNhu1IQLQ/4J06CyTlh0IanSk
	swDSLrixlXCVhrBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 43211139CB;
	Tue, 16 Sep 2025 19:06:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bTXCD0e1yWhRJwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 16 Sep 2025 19:06:47 +0000
Message-ID: <c370486e-cb8f-4201-b70e-2bdddab9e642@suse.cz>
Date: Tue, 16 Sep 2025 21:06:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab] slab: Disallow kprobes in ___slab_alloc()
Content-Language: en-US
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, bpf <bpf@vger.kernel.org>,
 linux-mm <linux-mm@kvack.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Michal Hocko <mhocko@suse.com>, Sebastian Sewior <bigeasy@linutronix.de>,
 Andrii Nakryiko <andrii@kernel.org>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>,
 Johannes Weiner <hannes@cmpxchg.org>
References: <20250916022140.60269-1-alexei.starovoitov@gmail.com>
 <47aca3ca-a65b-4c0b-aaff-3a7bb6e484fe@suse.cz> <aMlZ8Au2MBikJgta@hyeyoo>
 <e7d1c20c-7164-4319-ac7e-9df0072a12ad@suse.cz>
 <CAADnVQLNm+0ZwX2MN_JK3ookGxpOGxEdwaaroQk+rGB401E8Jg@mail.gmail.com>
 <0beac436-1905-4542-aebe-92074aaea54f@suse.cz>
 <CAADnVQJbj3OqS9x6MOmnmHa=69ACVEKa=QX-KVAncyocjCn1AQ@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAADnVQJbj3OqS9x6MOmnmHa=69ACVEKa=QX-KVAncyocjCn1AQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6151D14000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: xa471w7xokdpziapwe45wwnknkmszqey
X-HE-Tag: 1758049610-55046
X-HE-Meta: U2FsdGVkX1/vCMiQ0G8L+QlrRshUcy9PLqjmPIa/csEt7NuitdQFvnVU17LK8UvjRTCq3qaTKIxIH9qu7KukRjB5qBkhXrwQvMZpU77CQwVxkqtX6qwf5WBmnjGE4LevBVqeXnoTVizWy/QyJ6XQSDvSYXoQLZaL+cBvUUDyEBlMXMgXt2Pjs2G549bEsgGPJ475XjkVPorhqEAZeHZzUY+oHlIcIIQkTqqsT5aIMQItffGMElZ9afMws5EDPzuRKlnK+++/vu2McrK4BDlZISxOj/zlRlKIT1o8CY/QdCmoesxhpPAq4KScNOST43/zKEOwwQt0i85s3g6lXModnA7HDYhMwluhC0kcyN/5pYqOR/kf9YPvN+xAjBaRk1AaKtK9BXfymsjwdRTqiQQgqy5nq26rvsgf7A8WGYA9w6i9iQhYi+ymFHPBwIWvg2GNC9AbkTghD/aV0Hk2Ag6QRNu4r2CE0+VLXKWgLfV0UH3VJgeky5C1+SC6s9+8DddREUW8M5mpjugOpebJKJ+DYwCIV0UBP44RH/esg+mCCZeyirBQ/hf5KtAG2gbXaqxBCkS3OR0/5a2Mk96EkjV54IK1+KNsSZipaZXBuJ+lyJU9Pv1EKB2mklhEx179CQt4+sMRvgfR8lvHaZXaAcdlvQugWDUaMjcZICRCa9XgNygB/Vdur87IKM39UqKtcWeH1YpTRXd1KxIZpB5uFFV/gZbs+rdQ4AIkovh3mxA36zBcpvrYL7aEz5i3yItgfRgMShvng8JzDMwitYFwGGqa60Rca0mrvTXtJjysJ1/MJuBRf7Bi+8iM6akKz3SbuYLhnlt5wg6edNfyVmqnpRH5hGHptgyQdfhvWk9bnRt4BchjdLKhTRT+HtOJULGs3xxBeBffBF0bH+pY4zXOq7UnMpcl8gEeyXRyjcgOADWLxWhpLey+x5lsfd6LYqbFceoF485wripGv+f3BxepaC6
 6hsUK2wQ
 +TIn0/w+V0BrGJtfwtwsrdj8CPZz0He2jYG4kFemOrfydOMJXAlwueH6HMdRd83fKjjDDvKgnoS1BMy39nIPwYxT/IwAOL/R4o/hDi1QYjavG8wFGqd0/hPS+gSGTpgTn+b3FfLYRg4p9edOov3hVqBYj5dG8Rpfc1sdEvESIreZwIaMYjRd6H/U/A07RbS23XEZJhnQRWzB3s55JN/S938G84EwJPWSzsRpC7HE/+ujdhcQILWOJ+AfgYaTKb64rchieJMT/0CqH3/oWn9X7KfSfkOS9lwgnX9Ev/kVfxiLb/GK0YII4j5+TdtlGQf17PHK+D9WLFXN4HYtfbDxEKhFtskkLhA21c+A1LNFGgTmtRvIZd+TPDvfpUhloWxNHjphdS+WWhKDsw3IqAL06eX0hXgPm8XDivkx3cUEH5oEHnokQRA+RSv5ZcTx2w0Pn22FLoNj1M7RONrg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/25 20:46, Alexei Starovoitov wrote:
> On Tue, Sep 16, 2025 at 11:12 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>> On 9/16/25 18:18, Alexei Starovoitov wrote:
>> > On Tue, Sep 16, 2025 at 6:13 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>> >>
>> >> On 9/16/25 14:58, Harry Yoo wrote:
>> >> > On Tue, Sep 16, 2025 at 12:40:12PM +0200, Vlastimil Babka wrote:
>> >> >> On 9/16/25 04:21, Alexei Starovoitov wrote:
>> >> >> > From: Alexei Starovoitov <ast@kernel.org>
>> >> >> >
>> >> >> > Disallow kprobes in ___slab_alloc() to prevent reentrance:
>> >> >> > kmalloc() -> ___slab_alloc() -> local_lock_irqsave() ->
>> >> >> > kprobe -> bpf -> kmalloc_nolock().
>> >> >> >
>> >> >> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>> >> >>
>> >> >> I wanted to fold this in "slab: Introduce kmalloc_nolock() and kfree_nolock()."
>> >> >> and update comments to explain the NOKPROBE_SYMBOL(___slab_alloc);
>> >> >>
>> >> >> But now I'm not sure if we still need to invent the lockdep classes for PREEMPT_RT anymore:
>> >> >>
>> >> >> > /*
>> >> >> >  * ___slab_alloc()'s caller is supposed to check if kmem_cache::kmem_cache_cpu::lock
>> >> >> >  * can be acquired without a deadlock before invoking the function.
>> >> >> >  *
>> >> >> >  * Without LOCKDEP we trust the code to be correct. kmalloc_nolock() is
>> >> >> >  * using local_lock_is_locked() properly before calling local_lock_cpu_slab(),
>> >> >> >  * and kmalloc() is not used in an unsupported context.
>> >> >> >  *
>> >> >> >  * With LOCKDEP, on PREEMPT_RT lockdep does its checking in local_lock_irqsave().
>> >> >> >  * On !PREEMPT_RT we use trylock to avoid false positives in NMI, but
>> >> >> >  * lockdep_assert() will catch a bug in case:
>> >> >> >  * #1
>> >> >> >  * kmalloc() -> ___slab_alloc() -> irqsave -> NMI -> bpf -> kmalloc_nolock()
>> >> >> >  * or
>> >> >> >  * #2
>> >> >> >  * kmalloc() -> ___slab_alloc() -> irqsave -> tracepoint/kprobe -> bpf -> kmalloc_nolock()
>> >> >>
>> >> >> AFAICS see we now eliminated this possibility.
>> >> >
>> >> > Right.
>> >> >
>> >> >> >  * On PREEMPT_RT an invocation is not possible from IRQ-off or preempt
>> >> >> >  * disabled context. The lock will always be acquired and if needed it
>> >> >> >  * block and sleep until the lock is available.
>> >> >> >  * #1 is possible in !PREEMPT_RT only.
>> >> >>
>> >> >> Yes because this in kmalloc_nolock_noprof()
>> >> >>
>> >> >>         if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
>> >> >>                 /* kmalloc_nolock() in PREEMPT_RT is not supported from irq */
>> >> >>                 return NULL;
>> >> >>
>> >> >>
>> >> >> >  * #2 is possible in both with a twist that irqsave is replaced with rt_spinlock:
>> >> >> >  * kmalloc() -> ___slab_alloc() -> rt_spin_lock(kmem_cache_A) ->
>> >> >> >  *    tracepoint/kprobe -> bpf -> kmalloc_nolock() -> rt_spin_lock(kmem_cache_B)
>> >> >> And this is no longer possible, so can we just remove these comments and drop
>> >> >> "slab: Make slub local_(try)lock more precise for LOCKDEP" now?
>> >> >
>> >> > Makes sense and sounds good to me.
>> >> >
>> >> > Also in the commit mesage should be adjusted too:
>> >> >> kmalloc_nolock() can be called from any context and can re-enter
>> >> >> into ___slab_alloc():
>> >> >>  kmalloc() -> ___slab_alloc(cache_A) -> irqsave -> NMI -> bpf ->
>> >> >>     kmalloc_nolock() -> ___slab_alloc(cache_B)
>> >> >> or
>> >> >>  kmalloc() -> ___slab_alloc(cache_A) -> irqsave -> tracepoint/kprobe -> bpf ->
>> >> >>    kmalloc_nolock() -> ___slab_alloc(cache_B)
>> >> >
>> >> > The lattter path is not possible anymore,
>> >> >
>> >> >> Similarly, in PREEMPT_RT local_lock_is_locked() returns true when per-cpu
>> >> >> rt_spin_lock is locked by current _task_. In this case re-entrance into
>> >> >> the same kmalloc bucket is unsafe, and kmalloc_nolock() tries a different
>> >> >> bucket that is most likely is not locked by the current task.
>> >> >> Though it may be locked by a different task it's safe to rt_spin_lock() and
>> >> >> sleep on it.
>> >> >
>> >> > and this paragraph is no longer valid either?
>> >>
>> >> Thanks for confirming! Let's see if Alexei agrees or we both missed
>> >> something.
>> >
>> > Not quite.
>> > This patch prevents
>> > kmalloc() -> ___slab_alloc() -> local_lock_irqsave() ->
>> >     kprobe -> bpf
>> >
>> > to make sure kprobe cannot be inserted in the _middle_ of
>> > freelist operations.
>> > kprobe/tracepoint outside of freelist is not a concern,
>> > and
>> > malloc() -> ___slab_alloc() -> local_lock_irqsave() ->
>> >    tracepoint -> bpf
>> >
>> > is still possible. Especially on RT.
>>
>> Hm I see. I wrongly reasoned as if NOKPROBE_SYMBOL(___slab_alloc) covers the
>> whole scope of ___slab_alloc() but that's not the case. Thanks for clearin
>> that up.
> 
> hmm. NOKPROBE_SYMBOL(___slab_alloc) covers the whole function.
> It disallows kprobes anywhere within the body,
> but it doesn't make it 'notrace', so tracing the first nop5
> is still ok.

Yeah by "scope" I meant also whatever that function calls, i.e. the spinlock
operations you mentioned (local_lock_irqsave()). That's not part of the
___slab_alloc() body so you're right we have not eliminated it.

>>
>> But with nmi that's variant of #1 of that comment.
>>
>> Like for ___slab_alloc() we need to prevent #2 with no nmi?
>> example on !RT:
>>
>> kmalloc() -> ___slab_alloc() -> irqsave -> tracepoint/kprobe -> bpf ->
>> kfree_nolock() -> do_slab_free()
>>
>> in_nmi() || !USE_LOCKLESS_FAST_PATH()
>> false || false, we proceed, no checking of local_lock_is_locked()
>>
>> if (USE_LOCKLESS_FAST_PATH()) { - true (!RT)
>> -> __update_cpu_freelist_fast()
>>
>> Am I missing something?
> 
> It's ok to call __update_cpu_freelist_fast(). It won't break anything.
> Because only nmi can make this cpu to be in the middle of freelist update.

You're right, freeing uses the "slowpath" (local_lock protected instead of
cmpxchg16b) c->freelist manipulation only on RT. So we can't preempt it with
a kprobe on !RT because it doesn't exist there at all. The only one is in
___slab_alloc() and that's covered.

I do really hope we'll get to the point where sheaves will be able to
replace the other percpu slab caching completely... it should be much simpler.

