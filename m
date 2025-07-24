Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AAF2C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 14:30:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06BA86B013B; Thu, 24 Jul 2025 10:30:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01C076B013D; Thu, 24 Jul 2025 10:30:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E265C6B013E; Thu, 24 Jul 2025 10:30:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CF8EC6B013B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:30:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F1332140453
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:30:53 +0000 (UTC)
X-FDA: 83699394786.21.9B619F6
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4F0C6C0014
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:30:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QySJgUX7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ucHKu6mr;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QySJgUX7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ucHKu6mr;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753367451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k4Tsq+b880kK49R6CSOyZ9PmBo7u0+b5eMyTxU0Yb8Y=;
	b=oVGfMjmbaLvjjlWED0nMa3VpDlisH3/mPiOmX5zFZlic+MemaOjwknRD7u9Sieuv+qKx2v
	NfH7GH3xdEgj6f6zJMatPKG7B6YjB2dJr5iTxqvR+A5AQofPkvInN61yAYy07Y8bSwNJek
	Eak6tiv6MPcT8N3olUkVJODZU3+3T9Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753367451; a=rsa-sha256;
	cv=none;
	b=qYnqa0rHymlcHqi9o21Ms7hohoF+ZcyIANWEgWvcOd+Ko0qtwj0V/H5OmTOo4uhaXdWhrC
	6Ki/QgbrjsIAwLy1rE30OUNXs/G6PxI2ezpzK3lD5Uip3fAF85L3pevlJAjhNnM19LfMsS
	z9fWgCwbPmIiGLR9tEqQFXrbUETH6rg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QySJgUX7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ucHKu6mr;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QySJgUX7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ucHKu6mr;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ADA651F399;
	Thu, 24 Jul 2025 14:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753367449; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=k4Tsq+b880kK49R6CSOyZ9PmBo7u0+b5eMyTxU0Yb8Y=;
	b=QySJgUX7+KOApssRwOKHV7U6qg2d6ujMNn1BGeFL82Q4/ihFfkiN+Exq8tyOkXu6h1Eq18
	kgKardLPFG371Xdnh/SQxt4rulUQb+V59W8OIf2CGRwH5NmD5iG3pZU6mMSlQsS+gcEAe8
	TSogh0dyrTNbWzoexaiBHnZbFjxyP6M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753367449;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=k4Tsq+b880kK49R6CSOyZ9PmBo7u0+b5eMyTxU0Yb8Y=;
	b=ucHKu6mrc95YXAPNa1GzCLHur1JIrH8blfy44QJsIPvHWNpDMGQeLAs9/6Y/3QmLZP4MAQ
	nq6zNu6eBGz4HPCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753367449; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=k4Tsq+b880kK49R6CSOyZ9PmBo7u0+b5eMyTxU0Yb8Y=;
	b=QySJgUX7+KOApssRwOKHV7U6qg2d6ujMNn1BGeFL82Q4/ihFfkiN+Exq8tyOkXu6h1Eq18
	kgKardLPFG371Xdnh/SQxt4rulUQb+V59W8OIf2CGRwH5NmD5iG3pZU6mMSlQsS+gcEAe8
	TSogh0dyrTNbWzoexaiBHnZbFjxyP6M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753367449;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=k4Tsq+b880kK49R6CSOyZ9PmBo7u0+b5eMyTxU0Yb8Y=;
	b=ucHKu6mrc95YXAPNa1GzCLHur1JIrH8blfy44QJsIPvHWNpDMGQeLAs9/6Y/3QmLZP4MAQ
	nq6zNu6eBGz4HPCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 932F1136DC;
	Thu, 24 Jul 2025 14:30:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GrxqHZlDgmhwMwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 24 Jul 2025 14:30:49 +0000
Message-ID: <9cad7b86-4b77-4881-9cbf-637b6a61695d@suse.cz>
Date: Thu, 24 Jul 2025 16:30:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/14] slab: add sheaf support for batching kfree_rcu()
 operations
Content-Language: en-US
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250723-slub-percpu-caches-v5-2-b792cd830f5d@suse.cz>
 <aIEQQ0MW5e8KMvVL@pc636>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aIEQQ0MW5e8KMvVL@pc636>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gm1prs91k4a4x1irgnhb9wqi1a4cdmb6
X-Rspamd-Queue-Id: 4F0C6C0014
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753367450-220186
X-HE-Meta: U2FsdGVkX1+T2SAFKL48icyD871IkDzFThR8O1uqcSz22Dd6howG6CZOXqisbDyDFgtlDRDLbGgH0+WY210unRE+gUPky/qMxtBboMI5wY+yJeh9XP5sU/xPFUxWGRUPIgUOf1gbNmG1Zrf8pZ8+qMzzRPLvWFzTpRyyPcN0HTPSj+EapRJ1MWK8AVWSLxe7/sA3C5HEtv3/6vHlfAowbzVA4CfANLdYeDJ1rqHWm7SJFbAsrTk+t1QaXvmc/B0ABFkNrbbfa0vW4sG937IJJN2l+ElQ8711aP22zeqq+ei+YNhNJAjOpNmba6wlpzmSID0M3m9le1QoxLJnZ/KpqMXhwFUvJrRhbXL/ps/KKM5eFLK+2NTatj6lu5gROSkibKAL0RzweKTJ7LJjpw2mS9fPX6Z4dK3uVZzQQgW9weQBFBstlnv5sKpI0HYZZ/VN1Q+rJtwg2wHtyUzi10yaHvGGFhhHwt2pfDALxdjwJ6mrtB8Xn94g3Svirrbe3PLXhD4cYa2VXHkn6ffdy1Z2SSsL0qDtv4zaJx/Uqg70Ys5ppzHUTacR2qjLFRwu1rQN6ie8l83gJePgfyQbewTxwahSXsmDnSEnti+h0G3E9koG+FyZf3NI1GbihLiskoosNl5icaCQi21V174hpcPbRgHmrGkp/bOIRdTpkTDg8Rt/qqrENcjyGSE4iehPWczc+mavlNiy1ve7k5bFeq05MwDA26XjLHF0xm5br6sJ5FHfKcjO2odXxaRTnelWAz3b4Up1QXmMnfvOhjXL2q+N+BDhuoS4Q3FtTR5BaZx7s9mabpCju15CPk78FkPoyGTFV9CnETSCDcEssMPAKA4LiBRf0HgEcjBACvEK05pwQdDX/itOXRuGEXLueUpvpl0GCPid76Qg/0BBFsst8UwlcwSLkd/B97wEjplaMeOdGu8Hw6pfFXOP+7ejP0WO4OO5CJvZQQgNq4YV952nAap
 ZjpPOhBS
 ZHIcyxMQz3zfBDXjD2wY7CuiK4BrSjuvb402TDDaJ00N827rRVvLxSUeql1fBhbo0AXhXpRNkfu0kJnlIZS8i0bKoGRPeUplCz6dQRA8FUSA9Yu8gEbo6EvA0K4OpWuOpGHlvCucsGltQTxhvUL8j3aV5oM71hrcgg1RNETy3CnPG4xonA/CpKAAe7vAVk07J1JAfKcRqq4WqyQXqtxaPpG0cGImxiJJa9TNrYJBY1YXBFL8Jm6Es6on/fLSv1jm+qw/tuXNaL9Ydk3wN/HOnhv+ZG+7NfbFJEjbj1q7pZ7e9DJw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/23/25 18:39, Uladzislau Rezki wrote:
> On Wed, Jul 23, 2025 at 03:34:35PM +0200, Vlastimil Babka wrote:
>>  static bool
>>  need_offload_krc(struct kfree_rcu_cpu *krcp)
>>  {
>> @@ -1952,6 +1973,9 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
>>  	if (!head)
>>  		might_sleep();
>>  
>> +	if (kfree_rcu_sheaf(ptr))
>> +		return;
>> +
>>
> I have a question here. kfree_rcu_sheaf(ptr) tries to revert freeing
> an object over one more newly introduced path. This patch adds infra
> for such purpose whereas we already have a main path over which we
> free memory.
> 
> Why do not we use existing logic? As i see you can do:
> 
>    if (unlikely(!slab_free_hook(s, p[i], init, true))) {
>         p[i] = p[--sheaf->size];
>         continue;
>    }
> 
> in the kfree_rcu_work() function where we process all ready to free objects.

I'm not sure I understand. In kfree_rcu_work() we process individual
objects. There is no sheaf that you reference in the code above?
Or are you suggesting we add e.g. a "channel" of sheaves to process in
addition to the existing channels of objects?

> I mean, for slab objects we can replace kfree_bulk() and scan all pointers
> and free them over slab_free_hook().

The desired outcome after __rcu_free_sheaf_prepare() is to take the whole
sheaf and have it reused, not free individual objects. So we call
slab_free_hook() in __rcu_free_sheaf_prepare() but don't actually free
individual objects as necessary.

> Also we do use a pooled API and other improvements to speed up freeing.

It could be useful to know the details as in Suren's measurements there's
issues with kfree_rcu() using sheaves when lazy rcu is used. Is the
kfree_rcu() infra avoiding being too lazy somehow? We could use the same
techniques for sheaves.

> Thanks!
> 
> --
> Uladzislau Rezki


