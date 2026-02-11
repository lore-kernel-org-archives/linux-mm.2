Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 862AFECD6C7
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 16:59:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C00556B0005; Wed, 11 Feb 2026 11:59:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8BF06B0089; Wed, 11 Feb 2026 11:59:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A640E6B008A; Wed, 11 Feb 2026 11:59:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95FE16B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 11:59:18 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4376A58E3B
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:59:18 +0000 (UTC)
X-FDA: 84432786396.15.E145E26
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id A8DF31C0010
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:59:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RG+3rD2J;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JMbHUV5H;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RG+3rD2J;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JMbHUV5H;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770829156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K9A/zWvO7Ca3A+6Rp4L1LgDmPtAV9ih5Be5b7ZXx81Q=;
	b=E2yM98MxGEKrPMFmGHiR6cZPQzheev08Sgs925H6WMitr+CWcoqy+z86i5GrWCTY8Pc7y5
	0+Vc8YFCcVC6k3tKKJ9BveUtIgdYBDv61SdJCXToj4JXmmRvJWNOZo9bV/O+gXWwLN8/l4
	Yi26Ln3zeSwiarbBSwm4PwZLJ/YvQu4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RG+3rD2J;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JMbHUV5H;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RG+3rD2J;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JMbHUV5H;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770829156; a=rsa-sha256;
	cv=none;
	b=506kFsgYdbUNTCzyqvKbGxeeJXEgPdWMq34Rrm42ZklcU1ufCJKXToUfNSMMNmvgiF4+vA
	Oo7zYavpgjRla8LGykKNguMXeloVzHYyWJ1JVyDerh7ZwoPR+igNcySu7hVBBhgXtzynfT
	Ztkt06GVweG4cG1lAC3dBEEA6rNQPvw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B07725BDDC;
	Wed, 11 Feb 2026 16:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770829153; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=K9A/zWvO7Ca3A+6Rp4L1LgDmPtAV9ih5Be5b7ZXx81Q=;
	b=RG+3rD2JmZFOblxH4HoEQuZTshdKV7Gi2Fys5An09Yo3nblQsDLIaZAv5NLWouyKu349sw
	vt5WuRm+1oQX8j6rc07XAuY2ALp/E5TKlgvTg57YsZVLMA6gBhzAydYTtuk/5ZRFNSXkUm
	/HF9raT7k5fdkOiB+uIYNMzNduKiBKY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770829153;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=K9A/zWvO7Ca3A+6Rp4L1LgDmPtAV9ih5Be5b7ZXx81Q=;
	b=JMbHUV5HdetaNeOO6HVO4Rn19fzKF77FDs+WLeKYUx63usUw4P1+Wh7vrvxB5EqsRo/pd4
	NvENfBizJ/0gn0Dg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770829153; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=K9A/zWvO7Ca3A+6Rp4L1LgDmPtAV9ih5Be5b7ZXx81Q=;
	b=RG+3rD2JmZFOblxH4HoEQuZTshdKV7Gi2Fys5An09Yo3nblQsDLIaZAv5NLWouyKu349sw
	vt5WuRm+1oQX8j6rc07XAuY2ALp/E5TKlgvTg57YsZVLMA6gBhzAydYTtuk/5ZRFNSXkUm
	/HF9raT7k5fdkOiB+uIYNMzNduKiBKY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770829153;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=K9A/zWvO7Ca3A+6Rp4L1LgDmPtAV9ih5Be5b7ZXx81Q=;
	b=JMbHUV5HdetaNeOO6HVO4Rn19fzKF77FDs+WLeKYUx63usUw4P1+Wh7vrvxB5EqsRo/pd4
	NvENfBizJ/0gn0Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 826B43EA62;
	Wed, 11 Feb 2026 16:59:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NYLxHmG1jGnoUgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 11 Feb 2026 16:59:13 +0000
Message-ID: <40b42d83-3667-4489-818f-a01e1114d6b0@suse.cz>
Date: Wed, 11 Feb 2026 17:59:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Content-Language: en-US
To: Marcelo Tosatti <mtosatti@redhat.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>,
 Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>, Hyeonggon Yoo <42.hyeyoo@gmail.com>,
 Leonardo Bras <leobras@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
 Frederic Weisbecker <fweisbecker@suse.de>
References: <20260206143430.021026873@redhat.com> <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad> <aYywl1hdBQP2_slo@tiehlicka> <aYyzZbh/YRMDcviS@tpad>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aYyzZbh/YRMDcviS@tpad>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: qsz98k9sh6dfwh3oqp1697jbywkfa84p
X-Rspam-User: 
X-Rspamd-Queue-Id: A8DF31C0010
X-HE-Tag: 1770829155-116013
X-HE-Meta: U2FsdGVkX1/bql1+EXKMc6JtEKsEK7MqexBKqKnEwpBMewbfgkeW4bI1qkUoDvW0W/K7QZsXY07tCvsuhM+qVJom2lijkwJOadweM3BzFlELGYGXaTq8rQwpKrU2DvjSYdFlPmwLW31QplNnMucT+eEQOBk+XQHHtsapc6989p+K+Z0rhNad9tvAt+aFgrHlkt6EBUh6JHCJL/LBNMd8GbEKU4dQKAiK4lUgFSnMMlSOXwSkNzFOokSl2vrsqg3P1eYwCbaL0TlZfVRMACM7GmlV8e2OgzA+D8dQrFP9HdLw9oE5sjXgQP1m873XPsf+4BFbIce5WZexGH/8rwF1XB2My96x9fiL7QhP/zQJdS+nmVUlEXhM2CPET9SAwSUg8ii4g96+GksNiS/ACaAQkWyVLTgUyLwQodYUB3yjwQtwtsMyg3DJnjwPeq2SSWu6Zzewck9ajOJo2yi8NMp7/hJMjPSBM5VSvP3dVXv/T/ftKySjkfzXGxg7UwyHemR1Bif/744q3om1yn+1mKtEC9cQwpQIKr0Trv8IO1/8diHGykIsoqH8tu1JNn9QrApEIRtd2Vvewip0funAQit7rVP18cnrJzF7Z1vtc5MeSXuROIRt61wyLc9S9sLKZTvAgnEBqEdqeEeVxDfEF3S/+aMHqPfI6MGmozTL90uJAUpGAXHNPB0lKnw3rTXUwINvjfz2fss3maJ6w0b26QpyzJLKqi98Rx79Ul8RrJMP5iU83LYjsDLbtQEMpHa5eD+cV9civTlabMtXpHMQmdts6ByhjnSkiXDOAkvTVNrrK+m34BYULQO99ZnWVH9VT8FtfXxd1yXTZmmVyNz7Xq45ph6vZ4n/ke9Wez2wddYJqaJRrTbUQuwdzASOlfm8w2ZytqZ6YKEatrl0KgIIIh9TzPvIcX/uAl3t30gSBG3pBVh/wBWwEaDD0lhLxk6VbfEV6sGD4J3jE1fxyjIndrU
 Bffxu/sa
 sm64CZF4gHTXlA8DuPyoVqjnyImSJU1gJfaZo+4TOXMezTImlNIqHnRpgQmzG5yQeDl+lKwJ/59/8h37nTKnf8IM58k1XgOt5xA77H6cJQEgK4RlqO5JqDJApSntZl9WwaPC3N5v8Tzl2BF9CVe/pLr1mNwDwDF/nYrltBBhM0GE0Zee5++pThg2YFCI3rIgcSOGPypSPzGTH3QbipFv9apivJwUWz4K46yXJ0QXb56oZfb362ptziZMtrCSUwySzvFJAWmMOqcKzndO1h4oA1XQ5iJ3qhdvoVyfHjbZhLbq5Pc2+QyFdQGCKZ0tCZNgI8FVFXEwroHbZKt6f8nu8jmzep45dyx9fnsgIWSsMzOmhyYcLGn2CRZYhvJ7lPH1pEmatWFUyqDDaIIwabJ5UYSuzzA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 17:50, Marcelo Tosatti wrote:
> On Wed, Feb 11, 2026 at 05:38:47PM +0100, Michal Hocko wrote:
>> On Wed 11-02-26 09:01:12, Marcelo Tosatti wrote:
>> > On Tue, Feb 10, 2026 at 03:01:10PM +0100, Michal Hocko wrote:
>> [...]
>> > > What about !PREEMPT_RT? We have people running isolated workloads and
>> > > these sorts of pcp disruptions are really unwelcome as well. They do not
>> > > have requirements as strong as RT workloads but the underlying
>> > > fundamental problem is the same. Frederic (now CCed) is working on
>> > > moving those pcp book keeping activities to be executed to the return to
>> > > the userspace which should be taking care of both RT and non-RT
>> > > configurations AFAICS.
>> > 
>> > Michal,
>> > 
>> > For !PREEMPT_RT, _if_ you select CONFIG_QPW=y, then there is a kernel
>> > boot option qpw=y/n, which controls whether the behaviour will be
>> > similar (the spinlock is taken on local_lock, similar to PREEMPT_RT).
>> 
>> My bad. I've misread the config space of this.
> 
> My bad, actually. Its only CONFIG_QPW on the current patchset.
> 
>> > If CONFIG_QPW=n, or kernel boot option qpw=n, then only local_lock 
>> > (and remote work via work_queue) is used.
>> > 
>> > What "pcp book keeping activities" you refer to ? I don't see how
>> > moving certain activities that happen under SLUB or LRU spinlocks
>> > to happen before return to userspace changes things related 
>> > to avoidance of CPU interruption ?
>> 
>> Essentially delayed operations like pcp state flushing happens on return
>> to the userspace on isolated CPUs. No locking changes are required as
>> the work is still per-cpu.
>> 
>> In other words the approach Frederic is working on is to not change the
>> locking of pcp delayed work but instead move that work into well defined
>> place - i.e. return to the userspace.
>> 
>> Btw. have you measure the impact of preempt_disbale -> spinlock on hot
>> paths like SLUB sheeves?
> 
> Nope, i have not. What is/are the standard benchmarks for SLUB/SLAB
> allocation ?

Those mentioned here, and I would say also netperf.
https://lore.kernel.org/all/20250913000935.1021068-1-sudarsanm@google.com/



