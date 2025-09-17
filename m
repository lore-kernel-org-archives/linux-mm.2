Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1926FCAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 18:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 742D228000B; Wed, 17 Sep 2025 14:34:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 718E8280002; Wed, 17 Sep 2025 14:34:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6081128000B; Wed, 17 Sep 2025 14:34:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 50594280002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:34:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DD79913B8B3
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 18:34:58 +0000 (UTC)
X-FDA: 83899593876.11.DCBE193
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 712B2C000E
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 18:34:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=np3j22qn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OYucnUGm;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OP6eUHOO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+oWY1LXJ;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758134096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MFd0G/O72YBJmES7d/dg7RCjBoxZlZ6kvr9UYudRK8E=;
	b=eKpbWsZHnSSZuKI8mxYZc/BFGi9rfWUBsXaafRrgYnceIPFTMe/0Zb76rHDEN1T0vcyuxO
	9y9vvV7M7Yo8rbZ/HVTmuqPDZ8C5uDsth+vyIPGYET7eyS0Zc1ZOEn+H1wvGIwp+imF8sD
	nzuEMQNywUY1rc0KikZ76LeBFOL4YBc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=np3j22qn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OYucnUGm;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OP6eUHOO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+oWY1LXJ;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758134096; a=rsa-sha256;
	cv=none;
	b=awWyyKAiwEv4/7QYg8eePpT6opsn6J6BDe3xu2qpd1j0PdgFyeTD20ghRMdSJD2XUDTCX5
	BuORmWi/rDD0EkgrI658AHSeH5kSz4k4RvDzPnJ7ufVW7KnxnRyoffq8RR2jN/hFzHKPsM
	IRvceFwGHXMtxB3cpMsogqtnxWY4KnM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A0F0B5C1CF;
	Wed, 17 Sep 2025 18:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758134094; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MFd0G/O72YBJmES7d/dg7RCjBoxZlZ6kvr9UYudRK8E=;
	b=np3j22qn6jEGMJDRyxRTwMfixe33NGTySi4oZ6P9g0GbJrezcKAeaNTD4EgTCJjNlllHbQ
	RtMBdOhU0kOi2mej50/k63WJCVnjWGzHVv6CjLJC+N2zM78LTnl0bnXqOkrijOFmUgck+q
	W69gaE0N5uLXRG9LEsfYfLdjq3oMPTw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758134094;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MFd0G/O72YBJmES7d/dg7RCjBoxZlZ6kvr9UYudRK8E=;
	b=OYucnUGmtgz+O0+jlMmY4Tio3M9VgmZaeCxE5WRwrNSUaZ70zBdVaRS1NTummnnsn1tAFa
	u8R6g1FN7dvhn1BQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758134093; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MFd0G/O72YBJmES7d/dg7RCjBoxZlZ6kvr9UYudRK8E=;
	b=OP6eUHOOsX8YumGFnLmUrUBlv3Z7I5heJsFelRn15Ji+9F2nMG+VIoFPdubm3r2NTeoMs4
	42YDU5+mKw+q+989EZihHpNZXVYlJR4nUorgzvY0F2qXZ8XFC80iCMGb0BQFKijyew4ygy
	R03lvJSD9dFoHrd0qFOW/qhnDhjB+C8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758134093;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MFd0G/O72YBJmES7d/dg7RCjBoxZlZ6kvr9UYudRK8E=;
	b=+oWY1LXJdHjev80VASE9kW340mALsx8oj3jtWoky35wDBJT4i20ZzIFLsFg8iKs3WxQJPT
	CCXIn8+AiUYe67Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7E6BD1368D;
	Wed, 17 Sep 2025 18:34:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gOByHU3/ymgPVgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 17 Sep 2025 18:34:53 +0000
Message-ID: <ade5442f-6257-498f-bffd-5fc4b1d5858f@suse.cz>
Date: Wed, 17 Sep 2025 20:34:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab] slab: Disallow kprobes in ___slab_alloc()
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Harry Yoo <harry.yoo@oracle.com>
Cc: bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>,
 Sebastian Sewior <bigeasy@linutronix.de>, Andrii Nakryiko
 <andrii@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>,
 Johannes Weiner <hannes@cmpxchg.org>
References: <20250916022140.60269-1-alexei.starovoitov@gmail.com>
 <47aca3ca-a65b-4c0b-aaff-3a7bb6e484fe@suse.cz> <aMlZ8Au2MBikJgta@hyeyoo>
 <e7d1c20c-7164-4319-ac7e-9df0072a12ad@suse.cz>
 <CAADnVQLNm+0ZwX2MN_JK3ookGxpOGxEdwaaroQk+rGB401E8Jg@mail.gmail.com>
 <0beac436-1905-4542-aebe-92074aaea54f@suse.cz>
 <CAADnVQJbj3OqS9x6MOmnmHa=69ACVEKa=QX-KVAncyocjCn1AQ@mail.gmail.com>
 <c370486e-cb8f-4201-b70e-2bdddab9e642@suse.cz>
 <CAADnVQL6xGz8=NTDs=3wPfaEqxUjfQE98h5Q2ex-iyRs4yemiw@mail.gmail.com>
 <aMpdAVKZBLltOElH@hyeyoo> <aMpeADsz1Znaz8AU@hyeyoo>
 <CAADnVQ+sKKV+-Ee61Bxma+=MN4unGLRypAnfqHuLOtHM6T=HEA@mail.gmail.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAADnVQ+sKKV+-Ee61Bxma+=MN4unGLRypAnfqHuLOtHM6T=HEA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 712B2C000E
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ikmhmdxjfc5sj9o3r3y6aetut6kbrm6b
X-HE-Tag: 1758134096-909838
X-HE-Meta: U2FsdGVkX18XAv+jQH9FxWBIcyOYCXclRvBJbbAxBjj6maDzKWYoz5VoJsNFZfkbTJuuOmCtQyWq4rVDskc6jAKUheEo9UGNrOFdU8F4iRgcetORB60aTABV4gMVMSHMVD1kCSe5UQIubaliYHyQoLm1iOXLFxe8o9zhQUvrWohBgMdHZyG14HMF52ANZJoSUDneq/DoAlwqCE/DzMLABz+561ZtnUCZxsNjKDnkAZJzUYPuruYbTu01SK+O5OmZVFYJt8uQoMBrFLN5lMvsL98VlSf/D8/w3km2Ervl3194IbMinnAAgpX75GZ7bByCStCYFjHs9HGEcfZcgi6mdNDVLQeKxjJ1BW4i47UKaxkLmkRtZgmXAnu9rTPnW1YKWhHSkuzCnLUw8FvRVkHOpWfS85oIiKfJvpf/UedjLJNi/D7Y00m0/2nDXYpYrqFPpHwavkh3baH4vPEgj1aXwS5V0ARYZviB3cBsUi4cNNVaxAGh+bLs5v7GnqTno5QSEZL91dLP7a7gKHccCj8qgaz3viDM3V8UgmwdUwczdvYEWlSyP3374/HNMX6D8a2IJjmmOz6f4bPFX1oriM96Ln9GKX0wtyLrLo3FF2XEKXf1+XB9yD8mfjdKcajj1AbNb0WkUZYTearJgxwRc/waLu5OLuIukk95IvsT/Lb2zHPjVM5DCsJVoZJFIy4O7arCYgFtewjq1xT7ukSbr+5ARYdHobKT7un4UzuiuiwjaRn3yvJWpxGUZYr+yo/DFeim7ENmq+yVT6/oRPWONUINTVe1ctmKzOn4wY+2hAMy1V0pRQjP5Wei+82eAdRxpD5dWp8TwZRBxYkEyBxNuCr8kyTRh5OYxutFh/Ahb1Is1gesyvFnNhLBfJlwVXBjCocrsPT3ZZfCDcUcyc70KdhTTb1nz5Q1w89BG4cNPquQZ/EIK0d2CUOMD1Rws8B9fZHjErB4z+ovR8BP7S5xkK0
 A9irk+Oh
 d86NV7ywSFbOA4ou+X+GbPlrTyaMcFt0zEN6iIR+rN5kGUUG8okq2fo7Z3SJkUQxpOHPAgG83V1yKzyLZU7tnmy8u04XhGcFW17DWP76p7jHGfQYju5IdtaKRi9mGnq90Xhg2TM31Qwc88mOSGWcUPGca9guLItGZrdiFrGbmTPCux21JSfA4mcNo9Mv5QbRtEyjUJlaHtEPITehpG2iGsV4NVwMYzCTSPYDO/k8i3ZEQASjDQkadD5Q5uqNEA+RGB4pWcWTDFoQqiXRDRrAs0guEVfHEsV5KpQVJZQdklqBy2OZkAhVaPiFw81vLOngby1WaQpLCr+88fRAe034Q3xVEfwub3Cm2/fCcKY4C/MVd0G6qggqTtzKB2dA+wfYo3dThSzvHKR0JD2xqsae00058U8ekWmR+Y1yt4vNegW5A5XUg5J+2aupk07rSdwC6TOy8VuQRVlFz8UU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/25 20:26, Alexei Starovoitov wrote:
> On Wed, Sep 17, 2025 at 12:06 AM Harry Yoo <harry.yoo@oracle.com> wrote:
>>
>> On Wed, Sep 17, 2025 at 04:02:25PM +0900, Harry Yoo wrote:
>> > On Tue, Sep 16, 2025 at 01:26:53PM -0700, Alexei Starovoitov wrote:
>> > > On Tue, Sep 16, 2025 at 12:06 PM Vlastimil Babka <vbabka@suse.cz> wrote:
>> > > > > It's ok to call __update_cpu_freelist_fast(). It won't break anything.
>> > > > > Because only nmi can make this cpu to be in the middle of freelist update.
>> > > >
>> > > > You're right, freeing uses the "slowpath" (local_lock protected instead of
>> > > > cmpxchg16b) c->freelist manipulation only on RT. So we can't preempt it with
>> > > > a kprobe on !RT because it doesn't exist there at all.
>> >
>> > Right.
>> >
>> > > > The only one is in ___slab_alloc() and that's covered.
>> >
>> > Right.
>> >
>> > and this is a question not relevant to reentrant kmalloc:
>> >
>> > On PREEMPT_RT, disabling fastpath in the alloc path makes sense because
>> > both paths updates c->freelist, but in the free path, by disabling the
>> > lockless fastpath, what are we protecting against?
>> >
>> > the free fastpath updates c->freelist but not slab->freelist, and
>> > the free slowpath updates slab->freelist but not c->freelist?
>> >
>> > I failed to imagine how things can go wrong if we enable the lockless
>> > fastpath in the free path.
>>
>> Oops, sorry. it slipped my mind. Things can go wrong if the free fastpath
>> is executed while the alloc slowpath is executing and gets preempted.
> 
> Agree. All that is very tricky. Probably worth adding a comment.

Ah right, I did add one based on your commit log and this conversation:

+/*
+ * We disallow kprobes in ___slab_alloc() to prevent reentrance
+ *
+ * kmalloc() -> ___slab_alloc() -> local_lock_cpu_slab() protected part of
+ * ___slab_alloc() manipulating c->freelist -> kprobe -> bpf ->
+ * kmalloc_nolock() or kfree_nolock() -> __update_cpu_freelist_fast()
+ * manipulating c->freelist without lock.
+ *
+ * This does not prevent kprobe in functions called from ___slab_alloc() such as
+ * local_lock_irqsave() itself, and that is fine, we only need to protect the
+ * c->freelist manipulation in ___slab_alloc() itself.
+ */
+NOKPROBE_SYMBOL(___slab_alloc);

> Long term though I think RT folks needs to reconsider the lack of
> fastpath. My gut feel is that overall kernel performance is poor on RT
> due to this. sheaves might help though.

Oh they definitely should, thanks for the selling point :)

