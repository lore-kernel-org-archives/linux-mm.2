Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81756C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 08:37:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E24226B0118; Thu, 22 Jan 2026 03:37:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFC076B0119; Thu, 22 Jan 2026 03:37:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD3696B011A; Thu, 22 Jan 2026 03:37:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD4CC6B0118
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:37:23 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 69E411401A3
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:37:23 +0000 (UTC)
X-FDA: 84358945566.19.3CEC7CB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0C4618000B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:37:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HsLZt+Gg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FOADQxoz;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HsLZt+Gg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FOADQxoz;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769071041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PhMSCpDyh7+8D4BXCTDHoTCid/2RtwqQ20a7TQiUGAc=;
	b=7ZhlXgb3uAmFm20QTk31LS15pjRS+T61f+7C5x0aa34YMSYPjWCq5L0bQ9Snl8Tc2NHr2B
	RGKwj6ssREF7+A8YoFGW9IscJiOGxPATWCmBzFFEwn5BiLTrb/ETNPqno0nCbtpCsxx/d4
	RlXr5jQH6zf0mPrG/GlJ3PH+9Ltyj68=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HsLZt+Gg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FOADQxoz;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HsLZt+Gg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FOADQxoz;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769071041; a=rsa-sha256;
	cv=none;
	b=kyyCoXjZTuUFuwwCCeCQrwaf1BDEOvOtY9iXa9sF6tK01Qz2P1oEFngMJg2sIDK8aZiC+q
	idVDezzJZ8TU4nrAll7Wko6s9wI9al3700jdqE6c7hZtKQK5F5PbDN+TeexCqQxAtNr32H
	7jWDKn2nGCeLhc2OWJ43QIDMUm3ipVY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 87B805BCC6;
	Thu, 22 Jan 2026 08:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769071039; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PhMSCpDyh7+8D4BXCTDHoTCid/2RtwqQ20a7TQiUGAc=;
	b=HsLZt+GgXlJlpaTUgqKh5++ZLYLWobCRmZ6zPe2WnQbRtc3jbayr/ZV3MZmubi9Wtgv8zv
	teFc0vuYctaFTQV+PQ4qhj0yrxk1CMQpzt7qDzUsVQkaANTspye+sctUjG8bJzabfDATnq
	qZy1hqKaPVZFuAAo/8Th3AmOj61cEbY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769071039;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PhMSCpDyh7+8D4BXCTDHoTCid/2RtwqQ20a7TQiUGAc=;
	b=FOADQxozPRXP/ivHRbt7xagpiryd5ky9lw5TaKydAj4XM+eKjiuYINK2t4Ng0utwHWaCSr
	QS5GQ667d3ismUDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769071039; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PhMSCpDyh7+8D4BXCTDHoTCid/2RtwqQ20a7TQiUGAc=;
	b=HsLZt+GgXlJlpaTUgqKh5++ZLYLWobCRmZ6zPe2WnQbRtc3jbayr/ZV3MZmubi9Wtgv8zv
	teFc0vuYctaFTQV+PQ4qhj0yrxk1CMQpzt7qDzUsVQkaANTspye+sctUjG8bJzabfDATnq
	qZy1hqKaPVZFuAAo/8Th3AmOj61cEbY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769071039;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PhMSCpDyh7+8D4BXCTDHoTCid/2RtwqQ20a7TQiUGAc=;
	b=FOADQxozPRXP/ivHRbt7xagpiryd5ky9lw5TaKydAj4XM+eKjiuYINK2t4Ng0utwHWaCSr
	QS5GQ667d3ismUDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 555613EA63;
	Thu, 22 Jan 2026 08:37:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 46l+FL/hcWm/bQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 22 Jan 2026 08:37:19 +0000
Message-ID: <4560a13c-a5cc-41ad-ae5e-ac40a0396286@suse.cz>
Date: Thu, 22 Jan 2026 09:37:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 17/21] slab: refill sheaves from all nodes
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-17-5595cb000772@suse.cz>
 <aXGrQSOoG_6NdqNT@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aXGrQSOoG_6NdqNT@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Stat-Signature: 643dcb16xy995ij4hx3mkyhpajwuntg3
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C4618000B
X-HE-Tag: 1769071040-185020
X-HE-Meta: U2FsdGVkX19WTfnLXN2zkBTGOT0EsgO/24enqRiOeHwEOSgxxWnce6zGCKs9gzLf0EMaC73HKhIr5b88ZJ8ayJ2t4Y5dL0z4X9LlLe68FuEQtPvFQxFMiHfUlXw3uHGwiQDoFBi3xGy5GuyCFJsrNbVPyl98dKM4A7jGqBKUsB1gpyBb/lx6HnTISdabDLpNZU88KyPI6KjCa2W3Gj+gs7079EsI4Gty4CLyDn5b8sE0PWpAWRTOHSJYYteD/FKXOHELcV4dP58Jyt0591Yoo/SWbTPK1TI1hHUh+BO+aZ9iM3VPHiWDOh6eeQgvdlDtqxQmmh0h2AXQxpIb0j/aFof1NVmsYAL7Oafhu/zH+kGL2IZImoEHRXR0oc5sUv0yRwaqQ1i3sjLRMlvU5xBEMdYejRXw7MgFn67hBnhIGkosKDUtWHz2o9tDL+Ju7SeVWJ4Bq8WdvvRtIGqLtnzPHa2FqtZK3c+bw/NdBoheWwBIs//+PRDgRzPJTjbD5sYohdQN78hVL7+xUGBmfHY4ITV2vWtdr12y0sD8pxk98IYad/iSyL8TvuoGIP6H/0fKIStq/PbMp6mv70HewRFuMAjiRWZIZMuAmuLfryVh+7XuD6GycWpPkSugAsBK2lFSQ81mjeamdogJZvvqCrdyBcpEGl4xrnOQ1MyzxwP0+KRt0F1f9KXvGgRIHAV50ckIP0OQB5pQ51RXgK365SmJDYzbNLFKQN109OAZVbmMljvIBuP8vI59OZOcWdBUtEg8VZ5Gu6/6ZlS5tMWPpFjlqN4T+/uQDYxd5tubowXNOTxXc6wnozoH4aTS+N91tLWuXcd/OVixDsbwT2fH3jmnG21XaO/zY5a2tvsqhI1umpatenKyPXamxTWzY4UXhu2FbUd7wpjnBj+dv/KTW11JZdzwQgBYEJ2X+/9OIqLKMNbIzkohm9EdvcRNlbyLusPTr9vf7D1mMr29JFCqAY5
 +YhzDSGS
 rM6VoZ7PF/Qk1AWx0OlOWJlIqeaElewWid4FpFZkAqmlQ7JWwb0PNvvv5JlfbsJr+Q2KfNTgVFNEq4GAvQhUClgqMNLspneSRBUSJV9ekjdj0DU18vqw0D1U+7anYwCVzAFR0zemkoVDlW5RdPyMVxygxKwZylACA6l1D+qeRZK3l4l47eIliJsWxxW/nfgXSpj3tOjms04Y0Sy6MlgaV1CsB0763xKv5efK9OMl0ykx61LlHjyMtYiapAhnyFRI9tlDD+NVIGFcXnxjJV0H1bL4zcS8mNerwAetm41tclIO6kiFHuPYkTyMVsg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/22/26 05:44, Harry Yoo wrote:
> On Fri, Jan 16, 2026 at 03:40:37PM +0100, Vlastimil Babka wrote:
>> __refill_objects() currently only attempts to get partial slabs from the
>> local node and then allocates new slab(s). Expand it to trying also
>> other nodes while observing the remote node defrag ratio, similarly to
>> get_any_partial().
>> 
>> This will prevent allocating new slabs on a node while other nodes have
>> many free slabs. It does mean sheaves will contain non-local objects in
>> that case. Allocations that care about specific node will still be
>> served appropriately, but might get a slowpath allocation.
>> 
>> Like get_any_partial() we do observe cpuset_zone_allowed(), although we
>> might be refilling a sheaf that will be then used from a different
>> allocation context.
>> 
>> We can also use the resulting refill_objects() in
>> __kmem_cache_alloc_bulk() for non-debug caches. This means
>> kmem_cache_alloc_bulk() will get better performance when sheaves are
>> exhausted. kmem_cache_alloc_bulk() cannot indicate a preferred node so
>> it's compatible with sheaves refill in preferring the local node.
>> Its users also have gfp flags that allow spinning, so document that
>> as a requirement.
>> 
>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
> 
> Could this cause strict_numa to not work as intended when
> the policy is MPOL_BIND?

Hm I guess it could be optimized differently later. I assume people running
strict_numa would also tune remote_node_defrag_ratio accordingly and don't
run into this often.

> alloc_from_pcs() has:
>> #ifdef CONFIG_NUMA
>>         if (static_branch_unlikely(&strict_numa) &&
>>                          node == NUMA_NO_NODE) {
>>
>>                 struct mempolicy *mpol = current->mempolicy;
>>
>>                 if (mpol) {
>>                         /*
>>                          * Special BIND rule support. If the local node
>>                          * is in permitted set then do not redirect
>>                          * to a particular node.
>>                          * Otherwise we apply the memory policy to get
>>                          * the node we need to allocate on.
>>                          */
>>                         if (mpol->mode != MPOL_BIND ||
>>                                         !node_isset(numa_mem_id(), mpol->nodes))
> 
> This assumes the sheaves contain (mostly, although it wasn't strictly
> guaranteed) objects from local node, and this change breaks that
> assumption.
> 
> So... perhaps remove "Special BIND rule support"?

Ideally we would check if the object in sheaf is from the permitted nodes
instead of picking the local one. In a way that doesn't make systems with
strict_numa disabled slower :)

>>
>>                                 node = mempolicy_slab_node(); 
>>                 }
>>         }
>> #endif
> 
> Otherwise LGTM.
> 


