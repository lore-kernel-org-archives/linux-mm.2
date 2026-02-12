Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29A46EE368D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 14:28:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DA646B0005; Thu, 12 Feb 2026 09:28:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 387FF6B0089; Thu, 12 Feb 2026 09:28:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23F2B6B008A; Thu, 12 Feb 2026 09:28:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 117726B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:28:24 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BC0DE16019A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:28:23 +0000 (UTC)
X-FDA: 84436034886.28.CCB2694
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 509901C000A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:28:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="x/w9JEih";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iqICmXwg;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="x/w9JEih";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iqICmXwg;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770906501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A4dr7AkIsXIJDxdoxl2rEeAXmPG8R1ssBrm3E8Q+Egk=;
	b=vQ9GZu+KrGW7ww6glZr57ya2R7P8kIGm7McQN8nOPVOAlgSUbVk7KwanlfrDW60x10aIe/
	GRN3waaOf/aEUuX/XyEAgwP+kZQaMQqO7zQ8zZX/w3VEh2xLWXqso25tdviePOPxkr4sZP
	mqhWEE/ggvNzHf4n3CJ8kf5pP8QsEjY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="x/w9JEih";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iqICmXwg;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="x/w9JEih";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iqICmXwg;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770906501; a=rsa-sha256;
	cv=none;
	b=RQBjU4FIOE5BrvN7NbhG49Tvq+mFabW6d7tYXglA6KQLgNgWLkXlqpoNjN2Luqu3+rPOWC
	63CalNt/9gDpFcrkFoEXdyLQ7oCDZWZPZjJuKnX2OosDj/bXksbZ8nVy6S6E6+C4m2STVS
	cD9revyJYU5Gwq3lI14bdInkFr+RPZw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1318B5BDA9;
	Thu, 12 Feb 2026 14:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770906499; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=A4dr7AkIsXIJDxdoxl2rEeAXmPG8R1ssBrm3E8Q+Egk=;
	b=x/w9JEihSdEfqTA3jgcKAcDy/6u/rfAagiAF8TI8KUgKUsVCljWhFPe3YsqKNllwfaoCoh
	luTlSlUuR++t3HMKhKFEEzEqNrfsuGC84kVGBda9uaJZm/YhsRLLIP1AIHsJ1KDumLeO33
	uN6/lWN3pzXzU4soPNCTodcXpV/o5zk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770906499;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=A4dr7AkIsXIJDxdoxl2rEeAXmPG8R1ssBrm3E8Q+Egk=;
	b=iqICmXwgTS8WrXlaUT9dRXk6T6Q4O7Q4kH3+bFjUIQY17cCtSObGDuquRfkZdD1YGbJt8f
	usfYELusj2TkLTBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770906499; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=A4dr7AkIsXIJDxdoxl2rEeAXmPG8R1ssBrm3E8Q+Egk=;
	b=x/w9JEihSdEfqTA3jgcKAcDy/6u/rfAagiAF8TI8KUgKUsVCljWhFPe3YsqKNllwfaoCoh
	luTlSlUuR++t3HMKhKFEEzEqNrfsuGC84kVGBda9uaJZm/YhsRLLIP1AIHsJ1KDumLeO33
	uN6/lWN3pzXzU4soPNCTodcXpV/o5zk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770906499;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=A4dr7AkIsXIJDxdoxl2rEeAXmPG8R1ssBrm3E8Q+Egk=;
	b=iqICmXwgTS8WrXlaUT9dRXk6T6Q4O7Q4kH3+bFjUIQY17cCtSObGDuquRfkZdD1YGbJt8f
	usfYELusj2TkLTBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BFBC33EA62;
	Thu, 12 Feb 2026 14:28:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 03qkLYLjjWmKOwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 12 Feb 2026 14:28:18 +0000
Message-ID: <4808fda0-c663-4a52-a6ee-6c47497793c4@suse.cz>
Date: Thu, 12 Feb 2026 15:28:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/7] k[v]free_rcu() improvements
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Hao Li <hao.li@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Puranjay Mohan <puranjay@kernel.org>,
 Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 "Paul E . McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>,
 Uladzislau Rezki <urezki@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Dave Chinner <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Muchun Song <muchun.song@linux.dev>, rcu@vger.kernel.org,
 linux-mm@kvack.org, bpf@vger.kernel.org
References: <20260206093410.160622-1-harry.yoo@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260206093410.160622-1-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 509901C000A
X-Stat-Signature: 1eco3x63uinwgmipzpzepx3jqdaahmgf
X-Rspam-User: 
X-HE-Tag: 1770906501-652548
X-HE-Meta: U2FsdGVkX19So1WgkV0mHdpqejI9kBOgy22+xuMtuMlP7of5WnZlQkGUgPRKtkwJFlkRnum5LnjFEqUZK0mz55kPSD3z8oD3hvgqsgdTFQbft7bPo5gyPn+Pz/j5Lk41QyEXmjKEQy+NyLKoa0U8QBLv30kdYXcFX9XjxEU7MgUHKw9UMOmWy4Ym6i9hzwEwy1+OZ3Ue8yXpbfS34GHum4D8sllgXBcy2LuKYPHdGz3MwFYab21o1HG8GiHlvv5/q/abSkm/HG1s/jVTu52wdxEMYdfVkCp2A8jZBZ8n3slb7HcCtSN6KDu/VreNMrz51G9QE8jTleaa5dJPMiFbzLTjOXqfD/xr7v8ILO+e3IVYs9MMkg2iCtMN/ygcqb6CSMlFvquRzvNR8QItGI6Ko/qioM6hM8n0yYdVG0xUF/mbSx7eO2HLDThO0OrhW6k8mUtYFpkhWKWnQqOghAPkc+ogNYNxxPfLpgzdWCLyNTVjHsuUN/iGF/oSDw3qrUp+s8+DsudIWTHcmOSgieXORmWxwlcoEVKF97ms7fm4t/4hdjVf8M3E7uE2ACnJGxf/1Abu6KfanSXp+nAdrTRtEaqYHBJoDQENV9el6KKz7Z/xZ8DfbNmeOpgZIn9QFBfhGlaEtkKac1eA8MzmgfdcQTMIfJnUap9I5FE8kMzCuBP0lfEBLhJAjepfop8j7n8EOwkedaWUTFptzT5rZ10dE3t2ZM1fdxuTSCxNrVZXwYATs5rPseBUpU64+uOMZClwNhHzzwLyZwZbS3jGY6mRJclWpQTpkP2TAuPR5AjQ4T+W7uG+eibvOAznTsWj4goR0PgrKSKSePlZoFFPGuUaDBytSRNpr9KmHi9RrOupdRQauWm+dES1GtY5ay4VXWE8ErqtKOBT7QoH3rlLEku3SvcLCW3KORygccw4YDL1qWhVVTEvmqP15Ioeu3/XKeFuTSKP5CDBgCFNBDRFfPJ
 f+vf/Hd2
 G8qnRj7nfOBQQ7Jve3OZ9QjPX2rj8+QQok9gue1yHHK6cloL5aaZJoFAPotN/u5ZIXjtogiZvKhSeST+5yEpXQb9kXw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/6/26 10:34, Harry Yoo wrote:
> These are a few improvements for k[v]free_rcu() API, which were suggested
> by Alexei Starovoitov.
> 
> [ To kmemleak folks: I'm going to teach delete_object_full() and
>   paint_ptr() to ignore cases when the object does not exist.
>   Could you please let me know if the way it's done in patch 3
>   looks good? Only part 2 is relevant to you. ]
> 
> Although I've put some effort into providing a decent quality
> implementation, I'd like you to consider this as a proof-of-concept
> and let's discuss how best we could tackle those problems:
> 
>   1) Allow an 8-byte field to be used as an alternative to
>      struct rcu_head (16-byte) for 2-argument kvfree_rcu()
>   2) kmalloc_nolock() -> kfree[_rcu]() support
>   3) Add kfree_rcu_nolock() for NMI context

Since you went bravely into this area, I'd like to suggest some more :)

- teach CONFIG_KVFREE_RCU_BATCHED to handle kfree_rcu sheaves after they
fill, instead of the standard call_rcu() handling

- make kvfree_call_rcu() -> kfree_rcu_sheaf() compatible with PREEMPT_RT

Thanks,
Vlastimil

