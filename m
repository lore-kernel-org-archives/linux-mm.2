Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CD0BD72350
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:41:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD9BE6B0455; Fri, 23 Jan 2026 03:41:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C87DB6B0456; Fri, 23 Jan 2026 03:41:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B687D6B0457; Fri, 23 Jan 2026 03:41:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A42FB6B0455
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:41:29 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 66F61B8DA1
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:41:29 +0000 (UTC)
X-FDA: 84362584698.10.D03C58B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id DB5381C000A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:41:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DEdNXG9K;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3LfJ5+MJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DEdNXG9K;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3LfJ5+MJ;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769157687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X4hjxHYKZnZJl1qTa1KnlvorwzeceeulWmksqqxxmpw=;
	b=KSGodKFqpejIBPLJANjeTj5N6xJQ9ReLahiewEaGgUY4u9rbZKmF7AT3CKJug4qEh9Pylw
	TOlysVWWOnuc3PWDJRagQyWPZNqGzKaTCqdqWyzj+36IpzRcr2jrsrXwtMcUeX/tCtksu2
	nJN1h6AkDOdv/O0hLK4KkEcXkQZPxOs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DEdNXG9K;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3LfJ5+MJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DEdNXG9K;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3LfJ5+MJ;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769157687; a=rsa-sha256;
	cv=none;
	b=Yyl3ipWmA9rLKLmhoBzO6nYhRs2FO4Ce9nFouzTJ6WYNP3x5Rbmw9yBJA0t2bbKB7SfYiJ
	lPmMbdWv098eJI03lQc3/GQdR+oMynMa+6USfkHI3NuLGt28WRlYZC6BJhboacPvoSJ6Sb
	NFb3OYhRTR6HFg+ao6YHwgphDUIH8a0=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1FA8633793;
	Fri, 23 Jan 2026 08:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769157685; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=X4hjxHYKZnZJl1qTa1KnlvorwzeceeulWmksqqxxmpw=;
	b=DEdNXG9KG/Tty3P6/tl3J6IcKDbG/6qxryDA1sdig+guW74Gx//8cqkB47w3oYJ8bZvWDq
	h+Jr4tDixFt2BGP+pD+8iHMO8sDa4VSo5jtZITFR3ELrT/LjF7g896/AzEUPK1zRtIII99
	1lKlK59N0XsDvkZV7w74QtJrtS3YTSs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769157685;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=X4hjxHYKZnZJl1qTa1KnlvorwzeceeulWmksqqxxmpw=;
	b=3LfJ5+MJPFJcK3Mv9jeqla/qS6s41kZ6t8RVTyQQVvrCT4j2lQ1njbCPDvOJ3Nz4T7R+Mq
	fjWtR67QnuYSvkCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769157685; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=X4hjxHYKZnZJl1qTa1KnlvorwzeceeulWmksqqxxmpw=;
	b=DEdNXG9KG/Tty3P6/tl3J6IcKDbG/6qxryDA1sdig+guW74Gx//8cqkB47w3oYJ8bZvWDq
	h+Jr4tDixFt2BGP+pD+8iHMO8sDa4VSo5jtZITFR3ELrT/LjF7g896/AzEUPK1zRtIII99
	1lKlK59N0XsDvkZV7w74QtJrtS3YTSs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769157685;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=X4hjxHYKZnZJl1qTa1KnlvorwzeceeulWmksqqxxmpw=;
	b=3LfJ5+MJPFJcK3Mv9jeqla/qS6s41kZ6t8RVTyQQVvrCT4j2lQ1njbCPDvOJ3Nz4T7R+Mq
	fjWtR67QnuYSvkCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E2D241395E;
	Fri, 23 Jan 2026 08:41:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id O0kJNzQ0c2nLSQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 23 Jan 2026 08:41:24 +0000
Message-ID: <4b0b5a72-d4a0-4e40-8632-d2f9268e9e09@suse.cz>
Date: Fri, 23 Jan 2026 09:41:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v3 04/10] mm/vma: add+use vma lockdep
 acquire/release defines
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
 Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <4703b7320796908b9a0827c3d42d74d11b703714.1769086312.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpG+H=gRSWuhLL=NHQAQzrbF8Jku2qgRHv1moLPRibk5TA@mail.gmail.com>
 <CAJuCfpFVqmHnUVxZZLgeCv7QdPUH3Bv5tM=uOzPWuQgnx2zFvw@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAJuCfpFVqmHnUVxZZLgeCv7QdPUH3Bv5tM=uOzPWuQgnx2zFvw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5iyme88ei3xf63cz1zfidirpcoy51kwi
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DB5381C000A
X-HE-Tag: 1769157686-204354
X-HE-Meta: U2FsdGVkX1+etu0NpSpQ51niCa4AzWAMYWRpHpeXl1JJz/RnoXVfazoeH0ysyWP5wnaZI7ZLaJowT0O9MDopuqDM+Bfssy8V3Z5r6+qWlRbNnh3FWeHP1uYQ2fUcPFzIA3ylul1AkSjbi1DDEryjsSMS2ihRf1zBUt9CNKDPraihcaFbih+snj6MpARWNX8V+T65m6O0qU8G0d/VaoSFTx/Hqh8+APGA1yNPnHU8GeMTnDRFjg5DivL9Pc6sXXEJ/yqZ8KW877xo02wEuu8dO2i100ObGwRQXCRCT2V9+o+hnry/4723YhAvdLgDus/3B5XUvvfZM0eXhszggrH+omyyH6e6KFAPkzZ10LZxehz6gATnxyE9CQGmf2rvjd5w3ybSkOZeVF1dbGPL6Q0kvR2Ev56jatLg4UUNQoovvSYX9t+fYZCNDYEhR4Sn2jujcnXg6b+J5GT925JLGYVl8vRJTIaqMA/yP7e/yFU5RcHkV8ngONt46clA88FugUjc6k8uVDmmwFzWSeKa+Jf+OEmkZXgRi7qwpMLp984moUS4rnLR7HNPvrHGeJLBxS9m+GfxHHrtDMzdaYcs1hXZqxHqqay+RBpnPPuCEmHYzWIUCKjYzrV9HDbMIVDC+NPtRCeYN2Fj2xP/8QCxRuZcEOt46Fstv97dvwxQL1/bA+qGgKL/SKKrPSYdDFrWVhbeMt6jA45S0RqhuMLuJ6te/enS/LfrrenDIBYORoGKmVQJiASa+fZxx+WTjFiXOY60syx/w2klg6iCvp5lNVEWhWtbVNTL6nm6dj4nLYwkNLO1ZayBLWMHDztpImbYF3ikEliaUZM/jFOUwLtduWvaJ4xeFrqv9BGoRv1Q4D0LvE9LvnvNl4sSah+dbSxYppMeJ4PyNw7yTyo3dgjagwO/3LYaX9d3+EhMNuOjKyKf9hljQixKwVcmIZah+laJYrZcpwlAtGNHxO0UoEoInph
 JgTHRIk4
 2bCIs5jdbfahkz6TnZPBs49knj19D25h8j/tTzbWPbo2IrKd3INRXBR36jvFJwFkHYuLq5EgowgheSBYSW5kFSJQpEnSuEMAnqfAMsfwhlOudATwVdWYeMkX14v1Or0LeTkIaGbF1yIFPtrkPNhPLrUMawnRYIOqo/sr6wZxlBnapTDCiEphqm+m6y4I+6elF6Ez/R/QI40kQEyGkYTsmUImm5EEtkFydP3oetyE+JhYRU0ZnqCxEF4HGDWqYtC8soGeSsIOxdSoITUJIpzbsfQukTluMefNrX4NTvs2JzUqSVpu13YHBQKHyBQDhJij8s5vYeaz28eH9vFQZrOysV/EeuxFfoN8O1B8nEyhPUGSJT8Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/22/26 20:41, Suren Baghdasaryan wrote:
>> > +/*
>> > + * VMA locks do not behave like most ordinary locks found in the kernel, so we
>> > + * cannot quite have full lockdep tracking in the way we would ideally prefer.
>> > + *
>> > + * Read locks act as shared locks which exclude an exclusive lock being
>> > + * taken. We therefore mark these accordingly on read lock acquire/release.
>> > + *
>> > + * Write locks are acquired exclusively per-VMA, but released in a shared
>> > + * fashion, that is upon vma_end_write_all(), we update the mmap's seqcount such
>> > + * that write lock is de-acquired.
>> > + *
>> > + * We therefore cannot track write locks per-VMA, nor do we try. Mitigating this
>> > + * is the fact that, of course, we do lockdep-track the mmap lock rwsem.
>> > + *
>> > + * We do, however, want to indicate that during either acquisition of a VMA
>> > + * write lock or detachment of a VMA that we require the lock held be exclusive,
>> > + * so we utilise lockdep to do so.
>> > + */
>> > +#define __vma_lockdep_acquire_read(vma) \
> 
> One question I forgot to ask. Are you adding "__" prefix to indicate
> no other users should be using them or for some other reason?

I'd say it's the case of 'it has to be in a "public" header but not expected
to be used directly" by the end-users of the header'.

