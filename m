Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8167C4452E
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 13:22:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F5A16B0089; Wed, 21 Jan 2026 08:22:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3992C6B008C; Wed, 21 Jan 2026 08:22:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29BA36B0092; Wed, 21 Jan 2026 08:22:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 19B256B0089
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:22:19 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8028413A0CD
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 13:22:17 +0000 (UTC)
X-FDA: 84356034714.23.FDF15E2
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id DD9B3C000E
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 13:22:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CKZTLDQ1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Xv57NFaS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CKZTLDQ1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Xv57NFaS;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769001735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=shsGpPkdTpgh2O3TvGdc0KosuzZDmGShHqMUn9wd7Ck=;
	b=pjPEAvFWyx2q5npDfJ8EfX/EuvmUtoCQpgSyi5VTGM2n3rwEuKPITE/1rJTr2acmNaN8MM
	Ynv4NH0eogZ+sXeOH7nj0jwDrbiS+Cqg+KSkYX7Fj1n+bcKiaQWoSXzWy7UBcPgA1e+5e4
	6H4w4/6rupc6W8Fhh4hfjM8X0v7sw7g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CKZTLDQ1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Xv57NFaS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CKZTLDQ1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Xv57NFaS;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769001735; a=rsa-sha256;
	cv=none;
	b=2vLwwUpkgvdBtivsRlKOGrvgp2xAzOElapbmSwHLRMfxcDF+6FYxjWQ4oNsU0vz+stm42g
	Xd6dPm13eDsOaQYJg4rTkyscv3i7tmCqWnndaDkKFTAngT72LLekAE6D7b66FAwu3OL3l+
	hcgpxlTl6QRIojz9OqCey69h2AEWPZ8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1A28D336A1;
	Wed, 21 Jan 2026 13:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769001733; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=shsGpPkdTpgh2O3TvGdc0KosuzZDmGShHqMUn9wd7Ck=;
	b=CKZTLDQ1olFsUiLxebYBI7V7mqZzU9LM1uJMj3grHOiSbNV27PM1IIzJ/9uFAsiS8xD+t4
	TczVrUN7LQwilvQNBIwtNFDevjw0tLA0PZkm5n4BJpyoiLGSexPY3EIZ0x4LuXi4qiaf9n
	000iLRd9HHqu58Tr3jHnZycO2FO7gwQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769001733;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=shsGpPkdTpgh2O3TvGdc0KosuzZDmGShHqMUn9wd7Ck=;
	b=Xv57NFaSo4zZ4KWnFbrVkQE7lTQSvPtDV5GDVBA5fzIURjLG0ttHHRW6Xd/npyaNDUx/dn
	mLMsthjhfg8eLvAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769001733; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=shsGpPkdTpgh2O3TvGdc0KosuzZDmGShHqMUn9wd7Ck=;
	b=CKZTLDQ1olFsUiLxebYBI7V7mqZzU9LM1uJMj3grHOiSbNV27PM1IIzJ/9uFAsiS8xD+t4
	TczVrUN7LQwilvQNBIwtNFDevjw0tLA0PZkm5n4BJpyoiLGSexPY3EIZ0x4LuXi4qiaf9n
	000iLRd9HHqu58Tr3jHnZycO2FO7gwQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769001733;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=shsGpPkdTpgh2O3TvGdc0KosuzZDmGShHqMUn9wd7Ck=;
	b=Xv57NFaSo4zZ4KWnFbrVkQE7lTQSvPtDV5GDVBA5fzIURjLG0ttHHRW6Xd/npyaNDUx/dn
	mLMsthjhfg8eLvAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6A6F83EA63;
	Wed, 21 Jan 2026 13:22:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OTCoGQTTcGlWKAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 21 Jan 2026 13:22:12 +0000
Message-ID: <fec4ed92-32e1-4618-99d6-0eac77da1ff3@suse.cz>
Date: Wed, 21 Jan 2026 14:22:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/21] slab: add optimized sheaf refill from partial
 list
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-9-5595cb000772@suse.cz>
 <CAJuCfpErRjMi2aCCThHiS1F_LvaXjkVQvX9kJjqrpw8YnXoNBA@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAJuCfpErRjMi2aCCThHiS1F_LvaXjkVQvX9kJjqrpw8YnXoNBA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: iq8xmtaca9zzssz4z7z1qd6o55edqss6
X-Rspamd-Queue-Id: DD9B3C000E
X-Rspamd-Server: rspam05
X-HE-Tag: 1769001734-186114
X-HE-Meta: U2FsdGVkX1/YmuU7+zPgp05CGBfXn5ZN2dS66eZZ7v8rH0w9mvplXxLFj74MY/F/TWRISrvrRMZWphK8et0If3INISCHlDrkh14s+X1FybRdCgXw1WnXPTdgOHANJfMMLvBvkaAYob9uSWwvjqALC+7OcDUtrUJsdaTg53TcPahefHXgF4f6Ez65OF9gf7WnoMilqyXE3pZnuPQ3sq66zc8sKIbFlFMiaJ/6bLzlnGXHi3wDlxKGG7tKs+kKcI9JNt/FEq2DjA3Cg7C+pXt0WWWCjLKKwpa82lo1W1+qVl8zaW5xlFZvkfVRCuZppgZ91ijdw0jMQgmkPI6KVN45vdGI9h+CrphZ6mn7YwNbzDwDhxbOVKpnFZ5pt1bs3z0+RF8Vt+32hPUZjSmgXLywBUbzjbCcNVhl9zkV6jfBVUoP9quZwR4bOsMvKAov1kERRpm3zmrvil0IOPiPn5jAI4HjO4k8e8y6PPBgppRvHbd/jwx8cxlXK6KxNxra2lyBRi8wvxpFF3susMPTy6rYU/11UP4DVWJdksbfjLMd3s7hUlrG4+RlvISNz7OIYfaB7kSlzyOJsnzLBM4iBeKnEXf5U1smIzUG/HX7Wn0guGiahI7p/GglNYtsU3Nf69R/IGkSrudz2vH9JX62rjeUoToTCoHxw0xPpkpyVoYIH9IMsyc773kcqM4ZGlZwfBvL23u0o6uCJKFE0et/33WYO2aLqlnjrNiwYWjNr5ouL+ZcVvQfWYyl75M8nnbK9dJ1NDDrqtXlcoLzyw/l+SAwVr7gIxXsh67k8ES3pCyFejjib9Zd34PWm7gyYrxApVBF4I5ta0phbnlKSol8QuS5dPnQS0P7w7YG0cwVew9AlLDz8OIg1TxDepWriDIr33I9pu0L6V813Wg9pxvnkvPMTIdMNPe7P4pR37Wpul08hG8QDj+SJ3E9BrVjHxBSTcpxkgUXeTaCfq+LegHdf3J
 kHJPxbhi
 E9KPRynJmAhNNkqFM3b0peN+LmE+i4XRgJ8iHqSvkE99iHEcM5VIlR5pmYQU+sj6uVzBePKr7eGJsdVTYPlt2iKalEYQZojOOVuOntc7hsjwYwKNQurn9Fd1Eve7yje1YdfAk844pVtX3gqIYws8ySD2UnclAEdULnPstDqDiJEMKeUY9ylqoaMyyZxy9aWt4tWlgz4TZ0oIge8qn0lQezdxAydctpzD6B0iQGjCT6DcMmKOW/DVa0R/9qAuruTKmpt+xdvVjYK89oLmgyPxZjK/O7c4REi0619G/h+EpNF0RC1IsbnN5wEyhc1/qJSi92upKtYVUoKaq1ZafT4iZe52G5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/20/26 18:19, Suren Baghdasaryan wrote:
> On Fri, Jan 16, 2026 at 2:40 PM Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>> At this point we have sheaves enabled for all caches, but their refill
>> is done via __kmem_cache_alloc_bulk() which relies on cpu (partial)
>> slabs - now a redundant caching layer that we are about to remove.
>>
>> The refill will thus be done from slabs on the node partial list.
>> Introduce new functions that can do that in an optimized way as it's
>> easier than modifying the __kmem_cache_alloc_bulk() call chain.
>>
>> Extend struct partial_context so it can return a list of slabs from the
>> partial list with the sum of free objects in them within the requested
>> min and max.
>>
>> Introduce get_partial_node_bulk() that removes the slabs from freelist
>> and returns them in the list.
>>
>> Introduce get_freelist_nofreeze() which grabs the freelist without
>> freezing the slab.
>>
>> Introduce alloc_from_new_slab() which can allocate multiple objects from
>> a newly allocated slab where we don't need to synchronize with freeing.
>> In some aspects it's similar to alloc_single_from_new_slab() but assumes
>> the cache is a non-debug one so it can avoid some actions.
>>
>> Introduce __refill_objects() that uses the functions above to fill an
>> array of objects. It has to handle the possibility that the slabs will
>> contain more objects that were requested, due to concurrent freeing of
>> objects to those slabs. When no more slabs on partial lists are
>> available, it will allocate new slabs. It is intended to be only used
>> in context where spinning is allowed, so add a WARN_ON_ONCE check there.
>>
>> Finally, switch refill_sheaf() to use __refill_objects(). Sheaves are
>> only refilled from contexts that allow spinning, or even blocking.
>>
> 
> Some nits, but otherwise LGTM.
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks.

> 
> From the above code it seems like you are trying to get at least
> pc->min_objects and as close as possible to the pc->max_objects
> without exceeding it (with a possibility that we will exceed both
> min_objects and max_objects in one step). Is that indeed the intent?
> Because otherwise could could simplify these conditions to stop once
> you crossed pc->min_objects.

Yeah see my reply to Harry, it's for future tuning.
 
>> +       if (slab->freelist) {
> 
> nit: It's a bit subtle that the checks for slab->freelist here and the
> earlier one for ((slab->objects - slab->inuse) > count) are
> effectively equivalent. That's because this is a new slab and objects
> can't be freed into it concurrently. I would feel better if both
> checks were explicitly the same, like having "bool extra_objs =
> (slab->objects - slab->inuse) > count;" and use it for both checks.
> But this is minor, so feel free to ignore.

OK, doing this for your and Hao Li's comment:

diff --git a/mm/slub.c b/mm/slub.c
index d6fde1d60ae9..015bdef11eb6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4505,7 +4505,7 @@ static inline void *get_freelist(struct kmem_cache *s, struct slab *slab)
  * Assumes the slab is isolated from node partial list and not frozen.
  *
  * Assumes this is performed only for caches without debugging so we
- * don't need to worry about adding the slab to the full list
+ * don't need to worry about adding the slab to the full list.
  */
 static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *slab)
 {
@@ -4569,10 +4569,17 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
 {
        unsigned int allocated = 0;
        struct kmem_cache_node *n;
+       bool needs_add_partial;
        unsigned long flags;
        void *object;
 
-       if (!allow_spin && (slab->objects - slab->inuse) > count) {
+       /*
+        * Are we going to put the slab on the partial list?
+        * Note slab->inuse is 0 on a new slab.
+        */
+       needs_add_partial = (slab->objects > count);
+
+       if (!allow_spin && needs_add_partial) {
 
                n = get_node(s, slab_nid(slab));
 
@@ -4594,7 +4601,7 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
        }
        slab->freelist = object;
 
-       if (slab->freelist) {
+       if (needs_add_partial) {
 
                if (allow_spin) {
                        n = get_node(s, slab_nid(slab));


