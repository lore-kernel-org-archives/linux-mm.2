Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13C77CFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 11:34:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C02C6B0006; Sun, 23 Nov 2025 06:34:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3981F6B000C; Sun, 23 Nov 2025 06:34:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28F3D6B00AA; Sun, 23 Nov 2025 06:34:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 157286B0006
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 06:34:46 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A4FA5140BD1
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 11:34:45 +0000 (UTC)
X-FDA: 84141664530.28.F4F80B7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2181E40008
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 11:34:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Qw1GC39C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TnrEKDWH;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Qw1GC39C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TnrEKDWH;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763897683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YITnCYuwLwCCNhdaoferY4pMfSaJBTm9D/HyvBedx3o=;
	b=IB8SrUYAVaS9oskLdLfM2QbCCungo1rt92ERkreHMgG/yO9FP4jatQ+Fm62pOVaEC9us7G
	96E7KYSSOKOUcJmpVkTov/FEy0xLGzTPcY9UcsFNgknF150no92fcTv+oEJYzfICitJbXU
	aTEpTWjJVjVpmq7MBP6YtEdB4SM78Eg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Qw1GC39C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TnrEKDWH;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Qw1GC39C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TnrEKDWH;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763897683; a=rsa-sha256;
	cv=none;
	b=q3Wq/wrgchS7nJriMvU4goDqZPOjCK6a0x/SxQiblgCpgWpxFdb8VT2tROQFpZpG2zZSgZ
	BPLg33UVnAWGBnu/DVdQcPcSAZf2Nm4dNZLhoHZITkzjTZR5dBcoKMtKREMyVzlx8sP332
	d+73axpZuz1QtpK2ye4QxhtM/8kQsvQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0EE6F5BCC8;
	Sun, 23 Nov 2025 11:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763897681; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YITnCYuwLwCCNhdaoferY4pMfSaJBTm9D/HyvBedx3o=;
	b=Qw1GC39CMD0LdqYavoeeHrpnXarQoI+fAIa0QwDQM+N2s40cSsg3afK6cjIEalu3V7JEOh
	jFEGO+7pSaqZmG7tq7aHZ2WsA6y1WK64KuI9C3QmzFUSr7PE1tqPKjzazMVbGP17zequYl
	VIunUJqJwFhLBdmbg4aiE2F7D/+g0cQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763897681;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YITnCYuwLwCCNhdaoferY4pMfSaJBTm9D/HyvBedx3o=;
	b=TnrEKDWHS89Ja5M8wArFdmn17DjsCrb8s8hyuQ7bACnHRR2fg7w5L4a2JbGCJTVt8YtH/N
	CzzF+alf5FmwWeAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763897681; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YITnCYuwLwCCNhdaoferY4pMfSaJBTm9D/HyvBedx3o=;
	b=Qw1GC39CMD0LdqYavoeeHrpnXarQoI+fAIa0QwDQM+N2s40cSsg3afK6cjIEalu3V7JEOh
	jFEGO+7pSaqZmG7tq7aHZ2WsA6y1WK64KuI9C3QmzFUSr7PE1tqPKjzazMVbGP17zequYl
	VIunUJqJwFhLBdmbg4aiE2F7D/+g0cQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763897681;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YITnCYuwLwCCNhdaoferY4pMfSaJBTm9D/HyvBedx3o=;
	b=TnrEKDWHS89Ja5M8wArFdmn17DjsCrb8s8hyuQ7bACnHRR2fg7w5L4a2JbGCJTVt8YtH/N
	CzzF+alf5FmwWeAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E84333EA61;
	Sun, 23 Nov 2025 11:34:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 06lVOFDxImkfPAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Sun, 23 Nov 2025 11:34:40 +0000
Message-ID: <7b1265bc-835e-4c7d-af75-f237c46bc3a7@suse.cz>
Date: Sun, 23 Nov 2025 12:34:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/11] mempool: factor out a mempool_alloc_from_pool
 helper
Content-Language: en-US
To: Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
 Eric Biggers <ebiggers@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251113084022.1255121-1-hch@lst.de>
 <20251113084022.1255121-7-hch@lst.de>
 <a8a2c740-2208-5692-cfc6-f475ae0f7d45@google.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <a8a2c740-2208-5692-cfc6-f475ae0f7d45@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2181E40008
X-Stat-Signature: fdxej7cyhzhiqxp111fugoi1rnb5bqq3
X-Rspam-User: 
X-HE-Tag: 1763897682-885196
X-HE-Meta: U2FsdGVkX1/YymEG3gwpFZR3We50IxGHTIZTiBxHiNjbL/rY4hF6ekOhMGW2biPIIEsTak0h6jVUakOsO+oB5MOpzb5BT/mt+HtllLgS4CoWM7zxxxpZgd4NYhbBHiG40MN3IRFfCo7nANBgA2INNFO9DSz/ry1P9W/k0RaZXclI3C0tfnygz+UXKqStlvNTojjaAqsSRSkFKDsFeRob8m5CSLZPMnwVz8Jg8nZDY67cspa3ZFBKMyUUvlAsCktY+qWJmLI70oEsPLesTBIfBqgAKitpLOBeVnYAwaO5XUIXL9y1Ub6eKPIn47pjPyjLyNuGO9zCsv60wcQoNVCDoRMnHDXq6L9sVxjpNjhw+Rka1mAd6Tb3MTscvUX32ZoHoVe4JlTqNin6MWuPDIuwJsOrdXAq4dN9GHhbDqCCca/h4chuKSm57Qh9sW6v/ocASm9VvqzG4wWrZKZQF8erbz+s+Ujo9CD3ktovaYQmsPNpsrRuQxKaBDZwSnV1GzOVXFgujHaTxj0Zhj8PR1jB07txyOuTxGWyj6ErfU+5f+AbIH8/HeSY8uXJ8WbErf4l1ZcwEqVkl+2kzONsC0+hBBlkG70juzc6JkLJUBkkMpD08GMd28+TvFUcLFQje6YtA1CDoAtGtN/Te+Cda9nNP0Ab+CIugSAO1H4l+mkC0rMLmMgZrdJIbZLstmmbQAD6+b1HE2X3wXgw5ZOw3jsOrOWTINObgdFASg1supVKUq3VLsL9791cUcfnbl8YlROJXf0S1fh2+Z69FgOhaZGmk8kjXtqxmGZXrCtw4n9TDbwJURpgvmSOTfCd7rbLY4YEZSbxSqpgU4lvPO0toEGHBgPeyQEgTpCX4KgLCT7V3MUMbB3EzVo2D8uHzvFzkhgJ+d5KLlsTHaKaBfC/VTmMqGG/7kX24HCE0SA8I32XsB559fIHRe2Wy1bsFiS5SYI7QuEEG9+fd8jWWiToUiX
 Vy9g1w3z
 1/kN3BTA+V4UsInuW+5Kc8jHJIzSk7EoFkacm1O97525xI5ZBErpD5dat/A911EnZlgyWAV0eC0D5UTPGmPAJq1a/+p/pd9g5D0NUmXYcpXiaIJETGskRrTs1otq7g4LOwd7x4nRxKOlv3YuXqyy/WgfdxUC/wVbivnCMIbEHc/zh4u/57kZIptjl9g/53A2Zrse6shg5s2rXJJaQj/oJRoYOMRuSkMQMrscHvFgJKKW+I809MUkRaNuidWngbL1qPmNpjnvbKTJs+FuT9SPFjZefPNgmr2qQVr+skgFkR7OPkd3eu2/tclYcz3nODUUqi9gT4WIyT+iYOCE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/23/25 04:42, Hugh Dickins wrote:
> On Thu, 13 Nov 2025, Christoph Hellwig wrote:
> 
>> Add a helper for the mempool_alloc slowpath to better separate it from the
>> fast path, and also use it to implement mempool_alloc_preallocated which
>> shares the same logic.
>> 
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> ---
> ...
>> @@ -413,8 +457,6 @@ void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
>>  {
>>  	gfp_t gfp_temp = mempool_adjust_gfp(&gfp_mask);
>>  	void *element;
>> -	unsigned long flags;
>> -	wait_queue_entry_t wait;
>>  
>>  	VM_WARN_ON_ONCE(gfp_mask & __GFP_ZERO);
>>  	might_alloc(gfp_mask);
>> @@ -428,53 +470,22 @@ void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
>>  		element = pool->alloc(gfp_temp, pool->pool_data);
>>  	}
>>  
>> -	if (likely(element))
>> -		return element;
>> -
>> -	spin_lock_irqsave(&pool->lock, flags);
>> -	if (likely(pool->curr_nr)) {
>> -		element = remove_element(pool);
>> -		spin_unlock_irqrestore(&pool->lock, flags);
>> -		/* paired with rmb in mempool_free(), read comment there */
>> -		smp_wmb();
>> +	if (unlikely(!element)) {
>>  		/*
>> -		 * Update the allocation stack trace as this is more useful
>> -		 * for debugging.
>> +		 * Try to allocate an element from the pool.
>> +		 *
>> +		 * The first pass won't have __GFP_DIRECT_RECLAIM and won't
>> +		 * sleep in mempool_alloc_from_pool.  Retry the allocation
>> +		 * with all flags set in that case.
>>  		 */
>> -		kmemleak_update_trace(element);
>> -		return element;
>> -	}
>> -
>> -	/*
>> -	 * We use gfp mask w/o direct reclaim or IO for the first round.  If
>> -	 * alloc failed with that and @pool was empty, retry immediately.
>> -	 */
>> -	if (gfp_temp != gfp_mask) {
>> -		spin_unlock_irqrestore(&pool->lock, flags);
>> -		gfp_temp = gfp_mask;
>> -		goto repeat_alloc;
>> -	}
>> -
>> -	/* We must not sleep if !__GFP_DIRECT_RECLAIM */
>> -	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
>> -		spin_unlock_irqrestore(&pool->lock, flags);
>> -		return NULL;
>> +		element = mempool_alloc_from_pool(pool, gfp_mask);
>> +		if (!element && gfp_temp != gfp_mask) {
> 
> No, that is wrong, it breaks the mempool promise: linux-next oopses
> in swap_writepage_bdev_async(), which relies on bio_alloc(,,,GFP_NOIO)
> to return a good bio.
> 
> The refactoring makes it hard to see, but the old version always used
> to go back to repeat_alloc at the end, if __GFP_DIRECT_RECLAIM,
> whereas here it only does so the first time, when gfp_temp != gfp_mask.
> 
> After bisecting to here, I changed that "gfp_temp != gfp_mask" to
> "(gfp & __GFP_DIRECT_RECLAIM)", and it worked again.  But other patches
> have come in on top, so below is a patch to the final mm/mempool.c...

Thanks a lot Hugh and sorry for the trouble.

Looking closer I noticed we're also not doing as the comment says about
passing the limited flags to mempool_alloc_from_pool() on the first attempt.

I would also rather keep distinguishing the "retry with full flags" and
"retry because we can sleep" for now, in case there are callers that can't
sleep, but can benefit from memalloc context. It's hypothetical and I haven't
made an audit, but we can clean that up deliberately later and not as part
of a refactor patch.

So I'd amend this patch with:

diff --git a/mm/mempool.c b/mm/mempool.c
index c28087a3b8a9..224a4dead239 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -478,10 +478,15 @@ void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
                 * sleep in mempool_alloc_from_pool.  Retry the allocation
                 * with all flags set in that case.
                 */
-               element = mempool_alloc_from_pool(pool, gfp_mask);
-               if (!element && gfp_temp != gfp_mask) {
-                       gfp_temp = gfp_mask;
-                       goto repeat_alloc;
+               element = mempool_alloc_from_pool(pool, gfp_temp);
+               if (!element) {
+                       if (gfp_temp != gfp_mask) {
+                               gfp_temp = gfp_mask;
+                               goto repeat_alloc;
+                       }
+                       if (gfp_mask & __GFP_DIRECT_RECLAIM) {
+                               goto repeat_alloc;
+                       }
                }
        }


With the followup commit fixed up during rebase, the diff of the whole
branch before/after is:

diff --git a/mm/mempool.c b/mm/mempool.c
index 5953fe801395..bb596cac57ff 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -555,10 +555,14 @@ void *mempool_alloc_noprof(struct mempool *pool, gfp_t gfp_mask)
                 * sleep in mempool_alloc_from_pool.  Retry the allocation
                 * with all flags set in that case.
                 */
-               if (!mempool_alloc_from_pool(pool, &element, 1, 0, gfp_mask) &&
-                   gfp_temp != gfp_mask) {
-                       gfp_temp = gfp_mask;
-                       goto repeat_alloc;
+               if (!mempool_alloc_from_pool(pool, &element, 1, 0, gfp_temp)) {
+                       if (gfp_temp != gfp_mask) {
+                               gfp_temp = gfp_mask;
+                               goto repeat_alloc;
+                       }
+                       if (gfp_mask & __GFP_DIRECT_RECLAIM) {
+                               goto repeat_alloc;
+                       }
                }
        }


