Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 061A2CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 12:13:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C8328E0010; Wed, 17 Sep 2025 08:13:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 478CD8E0001; Wed, 17 Sep 2025 08:13:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3680F8E0010; Wed, 17 Sep 2025 08:13:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1FB7F8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:13:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C2BA011A55F
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:13:15 +0000 (UTC)
X-FDA: 83898631950.20.10C2E1A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id 518FEC000E
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:13:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E+LJY9ZQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Gm65j7Eq;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E+LJY9ZQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Gm65j7Eq;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758111193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zUNCpWliXDaFKTorCoBMTvhXAUu6w9OF/gefz4TsXNI=;
	b=Q9clUktoQlATbuMCtjhtlS5IKClj2D3fkhPHTyQJJ4wYiAcnoZM0Ov2/3LYcNUnWQmIDyf
	5vuLWMJtlcDI/0Z0djsTeKqunLz7aiVSUcVGA8Fj1xPCRQGirWTnfEA2LPnCLtZueJZgYR
	iEb+91DOqElTEnpEd/JibdGVinImqHQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758111193; a=rsa-sha256;
	cv=none;
	b=YskSsK+47hRz5zhyHVytXqcGgAH4odNdEMxSZlKlMxcApJ71AvdoA2RifXK4qaMz6q2Fum
	S5gQnbth/EBxE8n3AjtxysF1g1JUccGDhJpHQgiCZuwI3nNBjTXXEMbD+uY1Rwlf5Fa50o
	bLmgg4prmBDU0FWA5pC4HwMWBVfZmjM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E+LJY9ZQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Gm65j7Eq;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E+LJY9ZQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Gm65j7Eq;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 93D2622087;
	Wed, 17 Sep 2025 12:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758111191; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zUNCpWliXDaFKTorCoBMTvhXAUu6w9OF/gefz4TsXNI=;
	b=E+LJY9ZQzVm2Npg5uWgUSj0W5x5gStycdsI6h3mk6aHLqmcwF182p/lQGemg1qPkKFoAj7
	zLOZAUAvOijq/FPSDTRoJ4D4SlKVPwBczfNjvab7HIC1H/igfVyD7DNRbLr+Jv4eUALPvD
	CDkmjvHXPAQH5GZIJW5xuf5Ay32/Ll0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758111191;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zUNCpWliXDaFKTorCoBMTvhXAUu6w9OF/gefz4TsXNI=;
	b=Gm65j7EqcIvaoGoPzeiffhwMSa52lTkft4BQhG3m5rmm/8prPXvQ/D/kDvwk9RDufAgGUp
	oCYRGNzdA+hiR+CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758111191; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zUNCpWliXDaFKTorCoBMTvhXAUu6w9OF/gefz4TsXNI=;
	b=E+LJY9ZQzVm2Npg5uWgUSj0W5x5gStycdsI6h3mk6aHLqmcwF182p/lQGemg1qPkKFoAj7
	zLOZAUAvOijq/FPSDTRoJ4D4SlKVPwBczfNjvab7HIC1H/igfVyD7DNRbLr+Jv4eUALPvD
	CDkmjvHXPAQH5GZIJW5xuf5Ay32/Ll0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758111191;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zUNCpWliXDaFKTorCoBMTvhXAUu6w9OF/gefz4TsXNI=;
	b=Gm65j7EqcIvaoGoPzeiffhwMSa52lTkft4BQhG3m5rmm/8prPXvQ/D/kDvwk9RDufAgGUp
	oCYRGNzdA+hiR+CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7AA41137C3;
	Wed, 17 Sep 2025 12:13:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5nmbHdelymjhWQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 17 Sep 2025 12:13:11 +0000
Message-ID: <98f10e2a-7a02-42e8-8042-984ed82d5ba7@suse.cz>
Date: Wed, 17 Sep 2025 14:13:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 04/23] slab: add sheaf support for batching kfree_rcu()
 operations
Content-Language: en-US
To: paulmck@kernel.org
Cc: Harry Yoo <harry.yoo@oracle.com>, Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Uladzislau Rezki <urezki@gmail.com>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-4-ca3099d8352c@suse.cz>
 <aMpxnACqmsQl-lp0@hyeyoo> <bbda8c25-b575-4e98-b1ae-b103c6598d38@suse.cz>
 <8e7055a9-f899-4aad-8ed7-6543077c05d1@paulmck-laptop>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <8e7055a9-f899-4aad-8ed7-6543077c05d1@paulmck-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 518FEC000E
X-Stat-Signature: eu7bp7oix55dm1gj1qjkz9ymzjdkojwn
X-Rspam-User: 
X-HE-Tag: 1758111193-761678
X-HE-Meta: U2FsdGVkX1/6ZwKaiG1K+2uZnJ9BPugsfdV5E1fB3v4g9RQ1zZmbOzPGYjrelysGc4E7kw3RRX0B6y2MHSV7MMNKQkzSUXbVLVi8y9ahCWcOJsL9ESiVgZkh8ZwvrMPh+i2RZeCtTfgtzF3RRlT0FF7EcwNKk99Po8dqRod34tw7bY5rwXeVvk7ZTV1kr70Wf+/rucdOnb4xsiw6kqh7uRulHQ8DDG7uoeLzU1g32dK6+s51plQE5eQXPyX82aTmwsYfTtqKrlsM+ebsWtcGglaoCTTw76n+sekyYNg7Z8nLycuinidxrc+AG4rtf3MFQNf4IDd7Sfk6MWsL0DjH2/VfcwMmLnkxLwAr0qzYRb26nQ9bs5sdwSD6vpd0iiZHsStaCl5xsgUhfpRt75u77JLxbKI3V0nxLjpBC4iKSaUywk60Rx+D0KHKwqXb8ji/5dFDI6JSB9CNR+18MPn02M3ojqVbF/Ycxcnrwa07FBJe4HYX23neNDBkRxR+jJu3XWNTpBPSSkrEWmdQgwUV5pb+4PJrqKujRqZ3gv7LlmKt20fGm27ghqYj2+45pn+uZqyAMKYxisu+O3vcCLXKex/QsieIccSoml4AFwBd64pn07qQF4BA7njRhteZi444PGQoZCrTFvs33HB9LDJbalnwm4XuHEyaCShXzL1XbCqzwjQDh9rfyzT/tzdspDBpCTopLS7PRtB1QQKG1jgfRltGTbTSN0cWNnHW9JH2wQBF/cH19YqtiiyjRM069r7FGPE6RdH1BWdr/By01sLH2DY1dB+IPGCEj2A9rZv0N0BkAvZl9tckF5l1ygg57tAwDxddfTTydHul5cJwoO+YE/4p9AD+sjS9Z6uXsGZzmtkw5hq1JwEF53zXhnO9iw5MoWhguFPLpx3jag/b1otaFet/i8VTk1jJIMKmxVIpsYZI9TO9jbeN2d4YMNFXc9b5TPlyLl1on7+VdNxYX/I
 eXTzsTcl
 8cBvaPGtBgfNjk3NUbyK4k4NmC99EAeAvMpuWQXGR4xzkspqtwlsM/kXcsTIJQFzHYiVFqz3qW4aGCjb4CPeFp0/oJaLp24/OFN4O5RANK/+elMEy1kUAUSdWuOlgv17BZ5GBpCiKVEDMHEueZWKRzf0p+d+7PcdF803kRebYDvPkOj7uam35Q53mmMSNU+TGOdanHMiwmSi2mXQnsn1AJU+KRSH+xfjDAwS4xFrVGolOZOdP8LvDo+OcX594WItmcCNDetJGQeKokWmpgxCd+SfzAexlOkbQoEGxPq5basgNIc1ZAcX49dggk7k8j48kl9BAm66dFiTL2cU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/25 13:36, Paul E. McKenney wrote:
> On Wed, Sep 17, 2025 at 11:55:10AM +0200, Vlastimil Babka wrote:
>> On 9/17/25 10:30, Harry Yoo wrote:
>> > On Wed, Sep 10, 2025 at 10:01:06AM +0200, Vlastimil Babka wrote:
>> >> +/* needed for kvfree_rcu_barrier() */
>> >> +void flush_all_rcu_sheaves()
>> >> +{
>> >> +	struct slub_percpu_sheaves *pcs;
>> >> +	struct slub_flush_work *sfw;
>> >> +	struct kmem_cache *s;
>> >> +	bool flushed = false;
>> >> +	unsigned int cpu;
>> >> +
>> >> +	cpus_read_lock();
>> >> +	mutex_lock(&slab_mutex);
>> >> +
>> >> +	list_for_each_entry(s, &slab_caches, list) {
>> >> +		if (!s->cpu_sheaves)
>> >> +			continue;
>> >> +
>> >> +		mutex_lock(&flush_lock);
>> >> +
>> >> +		for_each_online_cpu(cpu) {
>> >> +			sfw = &per_cpu(slub_flush, cpu);
>> >> +			pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
>> >> +
>> >> +			if (!pcs->rcu_free || !pcs->rcu_free->size) {
>> > 
>> > Is the compiler allowed to compile this to read pcs->rcu_free twice?
>> > Something like:
>> > 
>> > flush_all_rcu_sheaves()			__kfree_rcu_sheaf()
>> > 
>> > pcs->rcu_free != NULL
>> > 					pcs->rcu_free = NULL
>> > pcs->rcu_free == NULL
>> > /* NULL-pointer-deref */
>> > pcs->rcu_free->size
>> 
>> Good point, I'll remove the size check and simply pcs->rcu_free non-null
>> means we flush.
>> 
>> >> +				sfw->skip = true;
>> >> +				continue;
>> >> +			}
>> >>
>> >> +			INIT_WORK(&sfw->work, flush_rcu_sheaf);
>> >> +			sfw->skip = false;
>> >> +			sfw->s = s;
>> >> +			queue_work_on(cpu, flushwq, &sfw->work);
>> >> +			flushed = true;
>> >> +		}
>> >> +
>> >> +		for_each_online_cpu(cpu) {
>> >> +			sfw = &per_cpu(slub_flush, cpu);
>> >> +			if (sfw->skip)
>> >> +				continue;
>> >> +			flush_work(&sfw->work);
>> >> +		}
>> >> +
>> >> +		mutex_unlock(&flush_lock);
>> >> +	}
>> >> +
>> >> +	mutex_unlock(&slab_mutex);
>> >> +	cpus_read_unlock();
>> >> +
>> >> +	if (flushed)
>> >> +		rcu_barrier();
>> > 
>> > I think we need to call rcu_barrier() even if flushed == false?
>> > 
>> > Maybe a kvfree_rcu()'d object was already waiting for the rcu callback to
>> > be processed before flush_all_rcu_sheaves() is called, and
>> > in flush_all_rcu_sheaves() we skipped all (cache, cpu) pairs,
>> > so flushed == false but the rcu callback isn't processed yet
>> > by the end of the function?
>> > 
>> > That sounds like a very unlikely to happen in a realistic scenario,
>> > but still possible...
>> 
>> Yes also good point, will flush unconditionally.
>> 
>> Maybe in __kfree_rcu_sheaf() I should also move the call_rcu(...) before
>> local_unlock(). So we don't end up seeing a NULL pcs->rcu_free in
>> flush_all_rcu_sheaves() because __kfree_rcu_sheaf() already set it to NULL,
>> but didn't yet do the call_rcu() as it got preempted after local_unlock().
>> 
>> But then rcu_barrier() itself probably won't mean we make sure such cpus
>> finished the local_locked section, if we didn't queue work on them. So maybe
>> we need synchronize_rcu()?
> 
> Do you need both rcu_barrier() and synchronize_rcu(), maybe along with

We need the local_lock protected sections of __kfree_rcu_sheaf() to be
finished (which might be doing call_rcu(rcu_sheaf) And then the pending
call_rcu(rcu_sheaf) callbacks to be executed.
I think that means both synchronize_rcu() and rcu_barrier(). Possibly a RCU
critical section in __kfree_rcu_sheaf() unless local_lock implies that even
on RT.

> kvfree_rcu_barrier() as well?

This (flush_all_rcu_sheaves()) is for the implementation of
kvfree_rcu_barrier() in a world with rcu_free sheaves. So it's called from
kvfree_rcu_barrier().

> It would not be hard to make such a thing,
> using workqueues or some such.  Not sure what the API should look like,

So there should be no one else calling such an API. There might be new users
of kvfree_rcu_barrier() doing this indirectly in the future.

> especially should people want other RCU flavors to get into the act
> as well.
> 
> 							Thanx, Paul


