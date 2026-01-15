Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9C49D44C7A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 16:19:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7DA16B0088; Thu, 15 Jan 2026 11:19:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2B546B0089; Thu, 15 Jan 2026 11:19:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE3656B008A; Thu, 15 Jan 2026 11:19:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A89D66B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:19:47 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3F12B8B8A8
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:19:47 +0000 (UTC)
X-FDA: 84334709214.29.1865E42
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id 90A3CC0009
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:19:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LfXVAsXE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=P2p4kMow;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LfXVAsXE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=P2p4kMow;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768493985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HNHUGfV0JfgEO1BXlsU+oqDNQg14UaodAKVimLCwoCI=;
	b=KyLWLTaEkNX8pwAQO6LjcgAb6yAT8jJeB8bBei583hBvFtLMfTV8SS0+y8rlJSpgSi3Q3j
	reHW8L6rxTVze/8nd9WKQ7lj8jtQfZ5YN0oeBoxYOzJQibbr1vqp1VJI+tZnGCyk8YUQNc
	CK9dgYAHMG5SQJnTjydgadKByn4STYU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LfXVAsXE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=P2p4kMow;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LfXVAsXE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=P2p4kMow;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768493985; a=rsa-sha256;
	cv=none;
	b=n625ztVz26pOG66ZH4196MQYKTwL9OhyTgU2WtADtZR1LFUOUqIOAY2S0gMw4CYAp0g4q7
	Vkh3A0V89xTldcdNz+A7CUJROLvnEFFT35BxcfInbjVPzNSQpcGdenKE+7D5noi7UgP8D2
	iMrHwccdIiRThooynbdCGR1Tdhwx+7U=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AFD375BD3F;
	Thu, 15 Jan 2026 16:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768493982; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HNHUGfV0JfgEO1BXlsU+oqDNQg14UaodAKVimLCwoCI=;
	b=LfXVAsXEFFep6YvgP/uTD30FIkAmYjpMZdJnYJ+bKoIE1O69DNxulxaioGk38IdFuzOAia
	zdaeHAHGp48nC9GKatkSfJ0PgehB6EOhuem79VYgoH4BS6RIt7TTfxhHFNKUhmBe1BlAT7
	VVtYWaa91bhhv8Rwsk8MarJBwpbmtA4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768493982;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HNHUGfV0JfgEO1BXlsU+oqDNQg14UaodAKVimLCwoCI=;
	b=P2p4kMowLmoYJu/tLkxwJxNSbr2EhC9GlKHEZgt8AovAXfgUSFd+7dvKTHFOIonSCPkFzz
	MLBJ+u1qlRjxkUCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768493982; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HNHUGfV0JfgEO1BXlsU+oqDNQg14UaodAKVimLCwoCI=;
	b=LfXVAsXEFFep6YvgP/uTD30FIkAmYjpMZdJnYJ+bKoIE1O69DNxulxaioGk38IdFuzOAia
	zdaeHAHGp48nC9GKatkSfJ0PgehB6EOhuem79VYgoH4BS6RIt7TTfxhHFNKUhmBe1BlAT7
	VVtYWaa91bhhv8Rwsk8MarJBwpbmtA4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768493982;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HNHUGfV0JfgEO1BXlsU+oqDNQg14UaodAKVimLCwoCI=;
	b=P2p4kMowLmoYJu/tLkxwJxNSbr2EhC9GlKHEZgt8AovAXfgUSFd+7dvKTHFOIonSCPkFzz
	MLBJ+u1qlRjxkUCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 98B893EA63;
	Thu, 15 Jan 2026 16:19:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bpfsJJ4TaWl/UgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 15 Jan 2026 16:19:42 +0000
Message-ID: <6be60100-e94c-4c06-9542-29ac8bf8f013@suse.cz>
Date: Thu, 15 Jan 2026 17:19:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] slub: keep empty main sheaf as spare in
 __pcs_replace_empty_main()
Content-Language: en-US
To: Zhao Liu <zhao1.liu@intel.com>, Hao Li <haolee.swjtu@gmail.com>
Cc: akpm@linux-foundation.org, harry.yoo@oracle.com, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, tim.c.chen@intel.com, yu.c.chen@intel.com
References: <20251210002629.34448-1-haoli.tcs@gmail.com>
 <a231264a-2da5-4468-a276-777fc0241246@suse.cz> <aWi9nAbIkTfYFoMM@intel.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aWi9nAbIkTfYFoMM@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: bnnmfmxfkcob48y5qjzfqy9rzmcqjxes
X-Rspamd-Queue-Id: 90A3CC0009
X-Rspamd-Server: rspam04
X-HE-Tag: 1768493984-750272
X-HE-Meta: U2FsdGVkX18NApAbbvLf/t+AR3z6Kp1AMwJeAmcQUUHAwivoEiYbkBMJCR1wO+k9nqUD/awDCyYIl7ire+Fx8rC7RmmtQQalOJW4t4vE/C9xXXcy8zzL4tf84v7dSMDxiZYou/NLXo8aPgBBXmXAH0wk2qzI5MQS5xN9qmLvnxg0yB3iyF7ywfGbo2Ogs582kaGpPgi6b0QOWXdTl5C/LVq2+2kErY44z3frfuT9vRt+7OjB5kzfT6EDo76NdDfa8zq6Kio7yvD8DjRUyeX+BOMtnFWSv5KZ3Ne2nwABCGFbD9YjO2DdvqsMyqCmhUCXsb5/1bTtPR+b1FOtlBr8a0VOFSiPKJYsRh36ziDUNsHH/RgCmmnsv9YQxVatM4ZLQ0q8qFZExSsVG3RruC4uOSfl6GCxTIw1rRxuYFVCEa8tlESBuaG5kgBbud/sAJx3LjOVPE9sDR1hDjOcX/JZBrBozZC7ZgY5g/8e7v6FJf6FXFp7DC3XjAqdP3dF71SO5D+sEt+2qTd4q6VVYte2iaASOt/e6AlMNLolZq27DfsvwwQiE2Z56+kogyLbEjGdwid+wfKACeqwf4/UUdJ+qhi43wqM/GTK0FDLx1UIr6o0/ZtDCY4HCep3fB/cG18A4A0mdR3TZ0wIkLkEwXIX3laMg5D617YYREXNz9zrWrlRlCt9HeybfK+qXmz41oARm4Kykd0ZxGD9Sd7T3cY0hs8m8dszp4NYYOHWuKVph8S4NJgPO7jaqjKKb4C/3KT7+S0IzSDvG07uoMva4xgx6v/jxJo96NkztTtTAvQYOxK3CtRKH9dpG1PbbSrcQDwxFJc48hGMvQCLCKAJabClEhYT+irLbUiV0Wg/hSqOImjLRtAB86byp1h2w/I0+T7/Q18QM01OXMToDZH/ZQsBtRneN1vH2zx3C88QI23vIh5pcC4iA1pBwp7dsU08x0A4qSONSNIFXJ5xoZ5Ru1C
 s8AElYoG
 VJItVWGkAuJUrZDfeKGHP9qaSIj2Y0EuVIOPRNbAF3RcdJQr7jRo6vcuK2eeS973ddRPvGK+IebYYx4IihzpmbYYyFyTPuYpwrpBXqxrDdwZkvj14PYMtTIJzSsBl5BfnjnwMkA2wcoAIN/pvq/i1ouuzWgDIKwFNMpcaCu37BxjfFaA+GM/NFv2PXFxLwit0UyleYwGzaCm1zMGqxGBzbbQYS7Yje/pNf8syw9ZzXIH/20M/Qxm5miUqI1sERX/MfttUyjtfPG4pacv4A5lsejMxYhn1V4ecob1pLn2wcIg2vH9yXVPa5wIVbqI7Cf6CBZl7JLfwPPtlOJa17F9JVtf9/OzLqcxO+XgTuHnpPj4Ocg8Q4WjgxuLNyYP5X8ALXKS9LA0791FwvBj7/+S2r31fCImmzOl8ky5awMqtyL/f1KbPbk9BQiiFw7zBui9JYylw9Ar+H4Jp8PA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 11:12, Zhao Liu wrote:
> Hi Babka & Hao,
> 
>> Thanks, LGTM. We can make it smaller though. Adding to slab/for-next
>> adjusted like this:
>> 
>> diff --git a/mm/slub.c b/mm/slub.c
>> index f21b2f0c6f5a..ad71f01571f0 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -5052,7 +5052,11 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>>          */
>>  
>>         if (pcs->main->size == 0) {
>> -               barn_put_empty_sheaf(barn, pcs->main);
>> +               if (!pcs->spare) {
>> +                       pcs->spare = pcs->main;
>> +               } else {
>> +                       barn_put_empty_sheaf(barn, pcs->main);
>> +               }
>>                 pcs->main = full;
>>                 return pcs;
>>         }
> 
> I noticed the previous lkp regression report and tested this fix:
> 
> * will-it-scale.per_process_ops
> 
> Compared with v6.19-rc4(f0b9d8eb98df), with this fix, I have these
> results:
> 
> nr_tasks   Delta
> 1          + 3.593%
> 8          + 3.094%
> 64         +60.247%
> 128        +49.344%
> 192        +27.500%
> 256        -12.077%
> 
> For the cases (nr_tasks: 1-192), there're the improvements. I think
> this is expected since pre-cached spare sheaf reduces spinlock race:
> reduce barn_put_empty_sheaf() & barn_get_empty_sheaf().
> 
> So (maybe too late),
> 
> Tested-by: Zhao Liu <zhao1.liu@intel.com>

Thanks!

> But I find there are two more questions that might need consideration?
> 
> # Question 1: Regression for 256 tasks
> 
> For the above test - the case with nr_tasks: 256, there's a "slight"
> regression. I did more testing:
> 
> (This is a single-round test; the 256-tasks data has jitter.)
> 
> nr_tasks   Delta
> 244	     0.308%
> 248	   - 0.805%
> 252	    12.070%
> 256	   -11.441%
> 258	     2.070%
> 260	     1.252%
> 264	     2.369%
> 268	   -11.479%
> 272	     2.130%
> 292	     8.714%
> 296	    10.905%
> 298	    17.196%
> 300	    11.783%
> 302	     6.620%
> 304	     3.112%
> 308	   - 5.924%
> 
> It can be seen that most cases show improvement, though a few may
> experience slight regression.
> 
> Based on the configuration of my machine:
> 
>     GNR - 2 sockets with the following NUMA topology:
> 
>     NUMA:
>       NUMA node(s):              4
>       NUMA node0 CPU(s):         0-42,172-214
>       NUMA node1 CPU(s):         43-85,215-257
>       NUMA node2 CPU(s):         86-128,258-300
>       NUMA node3 CPU(s):         129-171,301-343
> 
> Since I set the CPU affinity on the core, 256 cases is roughly
> equivalent to the moment when Node 0 and Node 1 are filled.
> 
> The following is the perf data comparing 2 tests w/o fix & with this fix:
> 
> # Baseline  Delta Abs  Shared Object            Symbol
> # ........  .........  .......................  ....................................
> #
>     61.76%     +4.78%  [kernel.vmlinux]         [k] native_queued_spin_lock_slowpath
>      0.93%     -0.32%  [kernel.vmlinux]         [k] __slab_free
>      0.39%     -0.31%  [kernel.vmlinux]         [k] barn_get_empty_sheaf
>      1.35%     -0.30%  [kernel.vmlinux]         [k] mas_leaf_max_gap
>      3.22%     -0.30%  [kernel.vmlinux]         [k] __kmem_cache_alloc_bulk
>      1.73%     -0.20%  [kernel.vmlinux]         [k] __cond_resched
>      0.52%     -0.19%  [kernel.vmlinux]         [k] _raw_spin_lock_irqsave
>      0.92%     +0.18%  [kernel.vmlinux]         [k] _raw_spin_lock
>      1.91%     -0.15%  [kernel.vmlinux]         [k] zap_pmd_range.isra.0
>      1.37%     -0.13%  [kernel.vmlinux]         [k] mas_wr_node_store
>      1.29%     -0.12%  [kernel.vmlinux]         [k] free_pud_range
>      0.92%     -0.11%  [kernel.vmlinux]         [k] __mmap_region
>      0.12%     -0.11%  [kernel.vmlinux]         [k] barn_put_empty_sheaf
>      0.20%     -0.09%  [kernel.vmlinux]         [k] barn_replace_empty_sheaf
>      0.31%     +0.09%  [kernel.vmlinux]         [k] get_partial_node
>      0.29%     -0.07%  [kernel.vmlinux]         [k] __rcu_free_sheaf_prepare
>      0.12%     -0.07%  [kernel.vmlinux]         [k] intel_idle_xstate
>      0.21%     -0.07%  [kernel.vmlinux]         [k] __kfree_rcu_sheaf
>      0.26%     -0.07%  [kernel.vmlinux]         [k] down_write
>      0.53%     -0.06%  libc.so.6                [.] __mmap
>      0.66%     -0.06%  [kernel.vmlinux]         [k] mas_walk
>      0.48%     -0.06%  [kernel.vmlinux]         [k] mas_prev_slot
>      0.45%     -0.06%  [kernel.vmlinux]         [k] mas_find
>      0.38%     -0.06%  [kernel.vmlinux]         [k] mas_wr_store_type
>      0.23%     -0.06%  [kernel.vmlinux]         [k] do_vmi_align_munmap
>      0.21%     -0.05%  [kernel.vmlinux]         [k] perf_event_mmap_event
>      0.32%     -0.05%  [kernel.vmlinux]         [k] entry_SYSRETQ_unsafe_stack
>      0.19%     -0.05%  [kernel.vmlinux]         [k] downgrade_write
>      0.59%     -0.05%  [kernel.vmlinux]         [k] mas_next_slot
>      0.31%     -0.05%  [kernel.vmlinux]         [k] __mmap_new_vma
>      0.44%     -0.05%  [kernel.vmlinux]         [k] kmem_cache_alloc_noprof
>      0.28%     -0.05%  [kernel.vmlinux]         [k] __vma_enter_locked
>      0.41%     -0.05%  [kernel.vmlinux]         [k] memcpy
>      0.48%     -0.04%  [kernel.vmlinux]         [k] mas_store_gfp
>      0.14%     +0.04%  [kernel.vmlinux]         [k] __put_partials
>      0.19%     -0.04%  [kernel.vmlinux]         [k] mas_empty_area_rev
>      0.30%     -0.04%  [kernel.vmlinux]         [k] do_syscall_64
>      0.25%     -0.04%  [kernel.vmlinux]         [k] mas_preallocate
>      0.15%     -0.04%  [kernel.vmlinux]         [k] rcu_free_sheaf
>      0.22%     -0.04%  [kernel.vmlinux]         [k] entry_SYSCALL_64
>      0.49%     -0.04%  libc.so.6                [.] __munmap
>      0.91%     -0.04%  [kernel.vmlinux]         [k] rcu_all_qs
>      0.21%     -0.04%  [kernel.vmlinux]         [k] __vm_munmap
>      0.24%     -0.04%  [kernel.vmlinux]         [k] mas_store_prealloc
>      0.19%     -0.04%  [kernel.vmlinux]         [k] __kmalloc_cache_noprof
>      0.34%     -0.04%  [kernel.vmlinux]         [k] build_detached_freelist
>      0.19%     -0.03%  [kernel.vmlinux]         [k] vms_complete_munmap_vmas
>      0.36%     -0.03%  [kernel.vmlinux]         [k] mas_rev_awalk
>      0.05%     -0.03%  [kernel.vmlinux]         [k] shuffle_freelist
>      0.19%     -0.03%  [kernel.vmlinux]         [k] down_write_killable
>      0.19%     -0.03%  [kernel.vmlinux]         [k] kmem_cache_free
>      0.27%     -0.03%  [kernel.vmlinux]         [k] up_write
>      0.13%     -0.03%  [kernel.vmlinux]         [k] vm_area_alloc
>      0.18%     -0.03%  [kernel.vmlinux]         [k] arch_get_unmapped_area_topdown
>      0.08%     -0.03%  [kernel.vmlinux]         [k] userfaultfd_unmap_complete
>      0.10%     -0.03%  [kernel.vmlinux]         [k] tlb_gather_mmu
>      0.30%     -0.02%  [kernel.vmlinux]         [k] ___slab_alloc
> 
> I think the insteresting item is "get_partial_node". It seems this fix
> makes "get_partial_node" slightly more frequent. HMM, however, I still
> can't figure out why this is happening. Do you have any thoughts on it?

I'm not sure if it's statistically significant or just noise, +0.09% could
be noise?

> # Question 2: sheaf capacity
> 
> Back the original commit which triggerred lkp regression. I did more
> testing to check if this fix could totally fill the regression gap.
> 
> The base line is commit 3accabda4 ("mm, vma: use percpu sheaves for
> vm_area_struct cache") and its next commit 59faa4da7cd4 ("maple_tree:
> use percpu sheaves for maple_node_cache") has the regression.
> 
> I compared v6.19-rc4(f0b9d8eb98df) w/o fix & with fix aginst the base
> line:
> 
> nr_tasks	w/o fix         with fix
> 1		- 3.643%	- 0.181%
> 8		-12.523%	- 9.816%
> 64		-50.378%	-20.482%
> 128		-36.736%	- 5.518%
> 192		-22.963%	- 1.777%
> 256		-32.926%	- 41.026%
> 
> It appears that under extreme conditions, regression remains significate.
> I remembered your suggestion about larger capacity and did the following
> testing:
> 
> 	59faa4da7cd4	59faa4da7cd4	59faa4da7cd4	59faa4da7cd4	59faa4da7cd4
> 			(with this fix)	(cap: 32->64)	(cap: 32->128)	(cap: 32->256)
> 1	-8.789%		-8.805%		-8.185%		-9.912%		-8.673%
> 8	-12.256%	-9.219%		-10.460%	-10.070%	-8.819%
> 64	-38.915%	-8.172%		-4.700%		4.571%		8.793%
> 128	-8.032%		11.377%		23.232%		26.940%		30.573%
> 192	-1.220%		9.758%		20.573%		22.645%		25.768%
> 256	-6.570%		9.967%		21.663%		30.103%		33.876%
> 
> Comparing with base line (3accabda4), larger capacity could
> significatly improve the Sheaf's scalability.
> 
> So, I'd like to know if you think dynamically or adaptively adjusting
> capacity is a worthwhile idea.

In the followup series, there will be automatically determined capacity to
roughly match the current capacity of cpu partial slabs:

https://lore.kernel.org/all/20260112-sheaves-for-all-v2-4-98225cfb50cf@suse.cz/

We can use that as starting point for further tuning. But I suspect making
it adjust dynamically would be complicated.

> Thanks for your patience.
> 
> Regards,
> Zhao
> 


