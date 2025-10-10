Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A4CDCCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 18:27:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C33758E004C; Fri, 10 Oct 2025 14:27:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE56E8E000A; Fri, 10 Oct 2025 14:27:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD29E8E004C; Fri, 10 Oct 2025 14:27:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 99DEA8E000A
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 14:27:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4719E140460
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 18:27:35 +0000 (UTC)
X-FDA: 83983037670.16.DCFA3AB
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id C563D2000C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 18:27:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UK3qpMe0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=94IGIneb;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UK3qpMe0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=94IGIneb;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760120853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CueUJ6XmXbiW/zHe2/YUqtwlamQZpKhUrxeZQ2bug14=;
	b=6fjy3oBPnXpU6gm8fZM7AxlPyE8DYXQRTngrSt2CMw2D4Mh59kp1dZT2GnoVwOHRhmVIRI
	pMpRqHZ+fGe+1qlnBBxBMx6DL4LLvROWISy6s69931QOFFCMZwrp3fMfh2z6FnQ6PKA23L
	KQrIJIKRGqtrPGDUSLhKWEYL6JIcOps=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760120853; a=rsa-sha256;
	cv=none;
	b=uwYtSlXQJIk+NUsKmsTETxkQAOgxkVCCSMMy2V65D1v+p7TmlKZZLFVTw+ot7CCm1cuStV
	71Nr22bHh/ujwX6hlUJI1VtExKuye8b6dyKPJK/StrF1xekc5kJmPhcoPWlRz4RfQsBDzS
	zDohPCeVIuG5AQl1ZCmVp4u4QkJKpQQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UK3qpMe0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=94IGIneb;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UK3qpMe0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=94IGIneb;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0BA5A2119C;
	Fri, 10 Oct 2025 18:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760120851; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CueUJ6XmXbiW/zHe2/YUqtwlamQZpKhUrxeZQ2bug14=;
	b=UK3qpMe0aAexXWOcL/OYi8peoGsO/EdJSRuU7LpZLz5xI24FVra98yOQoSbRSN/WWfuJiX
	UbItqwHPf+eVDygJ8MHDwDep2tbVuoZt7lNnQJ/zP6ifLZlbSKyEn85kcnHLjsRL2mNN/1
	+54ViubzkDXyQk/JjHitiW8SKHWm65g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760120851;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CueUJ6XmXbiW/zHe2/YUqtwlamQZpKhUrxeZQ2bug14=;
	b=94IGInebxch6UTzrFp69mub6FlTByZkla5PR6MoFFM4VCrzPQV1Jz3Gv85bbz4r2c4JqyC
	I/z7d10X+JofVpCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760120851; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CueUJ6XmXbiW/zHe2/YUqtwlamQZpKhUrxeZQ2bug14=;
	b=UK3qpMe0aAexXWOcL/OYi8peoGsO/EdJSRuU7LpZLz5xI24FVra98yOQoSbRSN/WWfuJiX
	UbItqwHPf+eVDygJ8MHDwDep2tbVuoZt7lNnQJ/zP6ifLZlbSKyEn85kcnHLjsRL2mNN/1
	+54ViubzkDXyQk/JjHitiW8SKHWm65g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760120851;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CueUJ6XmXbiW/zHe2/YUqtwlamQZpKhUrxeZQ2bug14=;
	b=94IGInebxch6UTzrFp69mub6FlTByZkla5PR6MoFFM4VCrzPQV1Jz3Gv85bbz4r2c4JqyC
	I/z7d10X+JofVpCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F07BE1375D;
	Fri, 10 Oct 2025 18:27:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CLxeOhJQ6Wj5dAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 10 Oct 2025 18:27:30 +0000
Message-ID: <e4f2a3e3-649a-423b-9696-6406ef56340f@suse.cz>
Date: Fri, 10 Oct 2025 20:27:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Boot fails with 59faa4da7cd4 and 3accabda4da1
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>,
 Phil Auld <pauld@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>
References: <20251010151116.GA436967@pauld.westford.csb>
 <CAHk-=wg1xK+Br=FJ5QipVhzCvq7uQVPt5Prze6HDhQQ=QD_BcQ@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAHk-=wg1xK+Br=FJ5QipVhzCvq7uQVPt5Prze6HDhQQ=QD_BcQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: gigk1x4suob8y3jarjtgj1fgmkhcykyj
X-Rspam-User: 
X-Rspamd-Queue-Id: C563D2000C
X-HE-Tag: 1760120852-880697
X-HE-Meta: U2FsdGVkX1+SCqHrIj12cX/qGMwLtukmVKqZT0M6l0YidUiZI39AcAcqvFOp8LTJWPCe+kKB6LHGG5SvdqAhKDjZBalybrzTl6z8E/KJKRB3Z+vX+oh4TgbjtxEHO1lZjcwbZ2XkrubW1PsZ8ESwyXoquux15+2sRlNiM40eav4/LnVpR32FPhYiy1hfOSJkjPRe8CvZq9y8sdbBNp3PWT6Imu6077JrkznGKun67FeacQYE98CL0D3nu5N0k4TBQC5KHMQYwsN4iP7wansx2jyWiRpv7Gbc2Uqq3buux20ACQe7XbPFaVfC/5pSVuYKU9Qx/QUFASSh3+6KOsJWp1/d1G+YfCw8KZcRennTlkS5BxPXhVKWEipx0bq9EcnVDXqjKw+3EEc9JmFvnPqVlyzvE3yraZs4D55Rh0n4clT0//Qwtaol+TCSlYRolQ09o/suPKN6+zjwb4IVsEZJcxtHarEiE5AiHoCCE6eiQs4aLzgLBQzz1bXhiEdsNmw0rS7EiVGw2QI+zqKpkr2bRfOcASOwmLSDshedmaWIOQjLb8WJtoY301ZiQsYbQvF8oa5RysucbOcLDKVHxQQjHcEE9EeWXFLVEKEKOprld/5MhwZ0GiMW+5DWTDC42ftzclz+Z+rZ9F6j3jmh2uUnHnA6Nyht31yDSv7A98X1Hy1oMhvorlfRaJbTvR9z7NluU7ca0Y2sgUqROcUVtKhvm9Y+LxTLilYHMg+mm0W9UUl6FSM343L2NglhWhfZEJcv6Qq0gykuUKqZu9Hn3CuqZTWa4NA9ey4QhT60hRcV3qdyyz6OMJLYKVcaU/wvCfrDnJdyrirp/Arr1+Edi3W9TnnL15TpaPii/OLsHqCPosKT10UzJVde0ThLo3ZA5E0FNIaF9ImI+eVPgkXd3PUJiuYurbdm+eng2ahVaVcDgoslmvUlExEFTqHxq8Mo2tNa0d8VQasNWkkLwvNMm4J
 hBYTvZWh
 56k6E4W3GcIgJbYhtwuf5i0MnTnEzNyjHmkXGLJoGgY5Yiqi93yRj3N+BPBUEZw0IP0In5bacCPmlp85UNz2AbmBgGmdp4nzQ4sfqGVTSR3agnBJ1hfLOS3isS8r20sGYMXz026RCGT6lvPtKHojDWbKeP53anKaedCy17ug8eKLSQFJ3pWiR+lY/nZTa8+BUoPlxV6lnukdf1Z2Qby5XmZjaQpGvz64FOwhJ/lQFSTdprWjk2QWaEWKd/TKA9YUm+iIcI/6TFBJieXZ41DjEdcIz5W8h6Ug0raDoCmI8gqs3ze5v4FB8b8yEEQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/10/25 20:19, Linus Torvalds wrote:
> On Fri, 10 Oct 2025 at 08:11, Phil Auld <pauld@redhat.com> wrote:
>>
>> After several days of failed boots I've gotten it down to these two
>> commits.
>>
>> 59faa4da7cd4 maple_tree: use percpu sheaves for maple_node_cache
>> 3accabda4da1 mm, vma: use percpu sheaves for vm_area_struct cache
>>
>> The first is such an early failure it's silent. With just 3acca I
>> get :
>>
>> [    9.341152] BUG: kernel NULL pointer dereference, address: 0000000000000040
>> [    9.348115] #PF: supervisor read access in kernel mode
>> [    9.353264] #PF: error_code(0x0000) - not-present page
>> [    9.358413] PGD 0 P4D 0
>> [    9.360959] Oops: Oops: 0000 [#1] SMP NOPTI
>> [    9.365154] CPU: 21 UID: 0 PID: 818 Comm: kworker/u398:0 Not tainted 6.17.0-rc3.slab+ #5 PREEMPT(voluntary)
>> [    9.374982] Hardware name: Dell Inc. PowerEdge R7425/02MJ3T, BIOS 1.26.0 07/30/2025
>> [    9.382641] RIP: 0010:__pcs_replace_empty_main+0x44/0x1d0
>> [    9.388048] Code: ec 08 48 8b 46 10 48 8b 76 08 48 85 c0 74 0b 8b 48 18 85 c9 0f 85 e5 00 00 00 65 48 63 05 e4 ee 50 02 49 8b 84 c6 e0 00 00 00 <4c> 8b 68 40 4c 89 ef e8 b0 81 ff ff 48 89 c5 48 85 c0 74 1d 48 89
> 
> That decodes to
> 
>    0:           mov    0x10(%rsi),%rax
>    4:           mov    0x8(%rsi),%rsi
>    8:           test   %rax,%rax
>    b:           je     0x18
>    d:           mov    0x18(%rax),%ecx
>   10:           test   %ecx,%ecx
>   12:           jne    0xfd
>   18:           movslq %gs:0x250eee4(%rip),%rax
>   20:           mov    0xe0(%r14,%rax,8),%rax
>   28:*          mov    0x40(%rax),%r13          <-- trapping instruction
>   2c:           mov    %r13,%rdi
>   2f:           call   0xffffffffffff81e4
>   34:           mov    %rax,%rbp
>   37:           test   %rax,%rax
>   3a:           je     0x59
> 
> which is the code around that barn_replace_empty_sheaf() call.
> 
> In particular, the trapping instruction is from get_barn(), it's the "->barn" in
> 
>         return get_node(s, numa_mem_id())->barn;
> 
> so it looks like 'get_node()' is returning NULL here:
> 
>         return s->node[node];
> 
> That 0x250eee4(%rip) is from "get_node()" becoming
> 
>   18:           movslq  %gs:numa_node(%rip), %rax  # node
>   20:           mov    0xe0(%r14,%rax,8),%rax # ->node[node]
> 
> instruction, and then that ->barn dereference is the trapping
> instruction that tries to read node->barn:
> 
>   28:*          mov    0x40(%rax),%r13   # node->barn
> 
> but I did *not* look into why s->node[node] would be NULL.
> 
> Over to you Vlastimil,

Thanks, yeah will look ASAP. I suspect the "nodes with zero memory" is
something that might not be handled well in general on x86. I know powerpc
used to do these kind of setups first and they have some special handling,
so numa_mem_id() would give you the closest node with memory in there and I
suspect it's not happening here. CPU 21 is node 6 so it's one of those
without memory. I'll see if I can simulate this with QEMU and what's the
most sensible fix

>             Linus


