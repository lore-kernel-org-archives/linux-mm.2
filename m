Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5623CCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 10:20:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97E068E0007; Tue,  9 Sep 2025 06:20:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 955008E0001; Tue,  9 Sep 2025 06:20:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 843D28E0007; Tue,  9 Sep 2025 06:20:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 725FA8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:20:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2C20D1A047C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:20:43 +0000 (UTC)
X-FDA: 83869317966.18.44FFE12
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id B19911C0006
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:20:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kcwvpzYP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ADnymnd8;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kcwvpzYP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ADnymnd8;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757413241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FofwgkEH/ndJprbxKcQdL9DEqXKQgVqiXCCgr+G4LRU=;
	b=sbt3walW7P+ZhAPLZq8tFdadFm5TFymY6WvIAJO+imozOGzhzd14Yzk54bDbG8VB5UdgXB
	tQjumodd/zPj6T3oDaUf49dv8cNkSSsZJaHm0n/ITXxJnwYYpOSlV+52s4wvllrmUmJIgF
	2NE1KUrSuphJsEqDekYz+6IDz7RSs64=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757413241; a=rsa-sha256;
	cv=none;
	b=UTp2dwNO3Bk46jkXynI9Hf1uibBdtmrjDmzcimq33xP6mVmE0VyZ3iF92W47l0Ar6PJ2/3
	2eMLWnl0fCAqDSlx3ZIvb3OfHH9t37ujzRPczQcaNKRGJkkv3k3ZuTHC3ELNnNSZuOMTtr
	PMap9plWyCODB5QfD9Nu9tkBZ3BTCfY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kcwvpzYP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ADnymnd8;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kcwvpzYP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ADnymnd8;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1AD992988F;
	Tue,  9 Sep 2025 10:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757413237; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FofwgkEH/ndJprbxKcQdL9DEqXKQgVqiXCCgr+G4LRU=;
	b=kcwvpzYPMBRvdYWhs1cy/ENpdvVLW42t7A8KgKKCGhy7AhotgFKfoaNuXzfi7teAv7oG15
	Mmc8g8bI7kDbEneBF7x0tGJhpBhrH1jAUvq9Z92IumUEm2Ad5cxK6je2Zh8I5jJSz2tzTc
	C8y1Pd3Ovm/VagAMIIYn0CP7vn7tik4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757413237;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FofwgkEH/ndJprbxKcQdL9DEqXKQgVqiXCCgr+G4LRU=;
	b=ADnymnd8JYjPpkAG5Ov03tkDGdE5vh4VQARDV4/kTux1JEBkQj1MF9KHkpk28+47Vlubhk
	P+bemwf9CBJFdsAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757413237; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FofwgkEH/ndJprbxKcQdL9DEqXKQgVqiXCCgr+G4LRU=;
	b=kcwvpzYPMBRvdYWhs1cy/ENpdvVLW42t7A8KgKKCGhy7AhotgFKfoaNuXzfi7teAv7oG15
	Mmc8g8bI7kDbEneBF7x0tGJhpBhrH1jAUvq9Z92IumUEm2Ad5cxK6je2Zh8I5jJSz2tzTc
	C8y1Pd3Ovm/VagAMIIYn0CP7vn7tik4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757413237;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FofwgkEH/ndJprbxKcQdL9DEqXKQgVqiXCCgr+G4LRU=;
	b=ADnymnd8JYjPpkAG5Ov03tkDGdE5vh4VQARDV4/kTux1JEBkQj1MF9KHkpk28+47Vlubhk
	P+bemwf9CBJFdsAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F1C1D1388C;
	Tue,  9 Sep 2025 10:20:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id p9sQOXT/v2g6HwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 09 Sep 2025 10:20:36 +0000
Message-ID: <838888f2-7a0f-49f0-9e33-592f13b14ad3@suse.cz>
Date: Tue, 9 Sep 2025 12:20:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 04/21] slab: add sheaf support for batching kfree_rcu()
 operations
Content-Language: en-US
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org
References: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
 <20250903-slub-percpu-caches-v7-4-71c114cdefef@suse.cz>
 <aL7FFpIMmXtzzSL1@pc638.lan> <6f8274da-a010-4bb3-b3d6-690481b5ace0@suse.cz>
 <aL_uhPtztx7Ef0T2@pc636>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aL_uhPtztx7Ef0T2@pc636>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: iejc1o4x77urt8ndbc6chg46atfcomtj
X-Rspamd-Queue-Id: B19911C0006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757413240-584142
X-HE-Meta: U2FsdGVkX19XX3yahH1nxqvjlIC6hIV4lQ4IZx38us7cZMHHps5dAue0UWNTIoecE0uTaJJN2zKhoffh8aWHbqmqF+R6fATkuAGf33J6r5McJFh4KBMU2XTnz9Ldv0BkAKLCKnocSmLqyj3uboiFmAevWf+lsslz77srZTU63Dw5IzYXQYr34HLgNt9pvt7oJvQh+k6006O/m6ukdwLI/fSnmmUeUnyXfVIZPcZRIecBH+qK+vY9DQl6tPThN+whhMcbKKVW54FUc8gPkv27+G/a3kKTBf4GeLNgLxUXlW+glF1vOBocC3+kRG6kltlE2HUJmb71w4BfLu1ZOgr/WGb4stlpgVEmSb9CGDZp9z57BZKVt6JUoZGH8OdB3kDQBmBKQ6tlmwbp5llfywkmCP3RYQP4XOhiAHutXmyNc6A56m5pD/crxlhKZ2jkg/03ae0o89zim//z7YXY5q6CSfMDe11oc61OahjJUbUocwC02mi+973nkpgalDYhIMW4CFCGTXeQJVj1DfP6yOTux1jWTgcW3t3Mdi8KnZvLoYcDGoEQio3G3P4Eq49Ylhl5hLCEH57wMDJXY4qXqZR6N1cDr2hGn8axTP1lbQqJdC+cw9goi+WNJDDki0NVuuk3rYjzfGirKjY7IkUCNFnw51dHu7mFTZHFOT2nP6YAepxo0/hJqo8x9Uk1EUn1ETKmhOKCg7WZ9hxN627pst4yiATa+WQs52OVU/nBewqzHKTz6057boA7/Piho4cBLTJIcy0knKGdBE0ATmSLTiJbnBdaOV+N662VijHIuY3/lPkqdq+uxlEf32pwiW39sKej9TwLCwcdvSXBZpA2z6ObQAXZE+cT/CPIGrz8jzZW2eRpfSVr1TFxCc45Jzj2PAgnc0i6WeW3s5hDTqRsFkuI/D1UWq0z6loxPKjC42Mw450I7fiJ1pK9wRZ5NT8XQY7LIt/fkisSgBgEuES0gIY
 lmA8rLwW
 k/RNRQ/QlQoEHf76j+3PzR6BU9jgVI89FnRE4K8WSJA4FO5NywwYCkiJN95eSmfGqbkCKRsrAPZyt9HVOxU5ZAZCwTHk7tiZtSsVrZ43phEKyEFgHSJzgqRl15LnpQXnUWVn7n7KGC2gN98chN1XT4INe2z47kWcRqDDyYzlJxjS/gjiQDKkqlHMo4vKDH9/+sg4jngaSw+N9YHzAnuBOw2pvxkcWaiMgxroyPYwKPY/BvRKeOi+TueJr8CfGHlrbzRR6Havmv3l5ageKIzoVF18xuCfIql6Lmydne8Yo5ISsHZs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/25 11:08, Uladzislau Rezki wrote:
> On Mon, Sep 08, 2025 at 02:45:11PM +0200, Vlastimil Babka wrote:
>> 
>> Hm I could not find where that distinction is in the code, can you give a
>> hint please. In __kfree_rcu_sheaf() I do only have a GFP_NOWAIT attempt.
>> 
> For PREEMPT_RT a regular spin-lock is an rt-mutex which can sleep. We
> made kvfree_rcu() to make it possible to invoke it from non-sleep contexts:

Oh you mean it's not allocating even on !RT so there's no RT-specific code.

> CONFIG_PREEMPT_RT
> 
> preempt_disable() or something similar;
>  kvfree_rcu();
>   GFP_NOWAIT - lock rt-mutex
> 
> If GFP_NOWAIT semantic does not access any spin-locks then we are safe
> or if it uses raw_spin_locks.

It does access spinlocks so it's not safe. Thanks, I didn't realize that
aspect of kfree_rcu(). We'll need to solve this before making sheaves
enabled everywhere. I don't think the vma or maple tree code would
kfree_rcu() vma or maple_node in such a restricted context. But to be safe
I'll just disable the kfree rcu sheaves for PREEMPT_RT for now.
>> > - call_rcu() can be slow, therefore we do not use it in the kvfree_rcu().
>> 
>> If call_rcu() is called once per 32 kfree_rcu() filling up the rcu sheaf, is
>> it still too slow?
>>
> You do not know where in a queue this callback lands, in the beginning,
> in the end, etc. It is part of generic list which is processed one by
> one. It can contain thousands of callbacks.
> 
> If performance is not needed then it is not an issue. But in
> kvfree_rcu() we do not use it, because of we want to offload
> fast.

So IIUC one could call_rcu(obj, some_callback_accessing_obj) and then do a
kfree_rcu(obj) and the latter can be processed first?
> --
> Uladzislau Rezki


