Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74C30C5518F
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 10:48:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC67E6B0088; Fri, 20 Feb 2026 05:48:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A73FE6B0089; Fri, 20 Feb 2026 05:48:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97FD76B008A; Fri, 20 Feb 2026 05:48:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68C346B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 05:48:06 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EC4F45CA97
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:48:05 +0000 (UTC)
X-FDA: 84464510130.20.F579EDC
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9FB4BA0007
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:48:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="RBb/en0o";
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771584484; a=rsa-sha256;
	cv=none;
	b=Qm3qRrLgGRMG+WfKsY3hQkYP+QiFb8VusCd7MGyrtytPqJduF6vUQA6WgxCymk7q1+KHny
	RCKj/2JfDVg/m3xGYeF+HyERYqxEq1x2uqhlLt8f9bptqeSSeoOx01kACpezLTFMesFz4i
	zZw8VtD9OzjEhJM3y7pbskKRvOKTCuM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="RBb/en0o";
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771584484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aIuh/mqVOC+QEYbxZAPJ2XnAxftipx1GQkPpqjSSnEY=;
	b=YJmhfPofeZ07LiHu+QskiqgcEkw0yPkNC/otGokxZ+q4IL9tsPE+/o7+zixyFEVsV0sdtH
	t6K9/Qm3PaiyXwGFBqel/RRoVA0v+GsYsLoSvSODM1vpn87Rm4yaJdlX+6EmsMTM4FHawP
	DEDdpNv8xmPhFW0PL6xtZP32TcdVmmg=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4830b67aa6bso2587315e9.0
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 02:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771584482; x=1772189282; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aIuh/mqVOC+QEYbxZAPJ2XnAxftipx1GQkPpqjSSnEY=;
        b=RBb/en0oFil/k9UVQgV2iX5Iy1rfmEaPBzgYgbrfjCOMWIgAx0H8RIZx950sx7FqGf
         s9QJsoOjTj8YhH20OoOkBrwW03hXfa0r9WvYXPmfzNeI6ArFsuaUQ3Bh4XO3zmPqpc7K
         odUk04QL++Fgfick9s4cGaMA1pPD6WEBZd4rMvEQdJG4yKTZKOFLgOJu69heiRyMflpj
         hneWMcAoPHMgZM1j87uyQO6PUto7KdEdaoH9q2EjmP5drGftMxQpW93MT7j5vnhKbK5H
         5smF+gcO0IFd/s/ProZAym6xnjfKAl5KCRem/AY5LDkbpU6aF6e5DpuHT+IY+AGWEgaa
         IEWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771584482; x=1772189282;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aIuh/mqVOC+QEYbxZAPJ2XnAxftipx1GQkPpqjSSnEY=;
        b=vwoFnJ9WDurDQDDvX56fmRoIDFjdvQf3jFjuTR0CcQZs4Hd0dutnifjMxO6iocfDkx
         jpjSqlgI3jcUA5TQiiaYOhFRc0aGvW0JfKwsVm+vhu/dzKsnZEuHXfUGFGdrjw05mUBm
         2nRALJ3l9YOLBLLN3ei27r7m2m5r6KbqgYHrFlkZEa9DqVb1tf4irSJC7jYg5qCZIOG6
         Cib5jBCZY/4PeZ6OanWa6cG9TstB2h1v9zzC9GIJlLRSywPdKwRhbnCP7XrJDFQOZgq+
         FJXm2I/pAnLC6CLq+oUclzX1lrbwdRWhA3mNp+kSdZVdnTcgTW24jiy+JmIRR8voVWo5
         kb+g==
X-Forwarded-Encrypted: i=1; AJvYcCUqLJa0yZxLEjWPsgR8CNWhEa9BTIq5WPmTNjIwKL2/mYAz0sJc3pS+LLZGK/rz3w0G1nQetCHAYQ==@kvack.org
X-Gm-Message-State: AOJu0YxVaoOzJI61pW7Fs4KjHvlr+Xxd8yJxRTn4BsZ/Y2qhu60PfYDa
	5yuXuX6kYvQhkr7gx7SZzfGybD+z27IMAP0xisIU1K+FFNWc119d7rw8dujsZeqCPyo=
X-Gm-Gg: AZuq6aI5c0LOFkRaP8LZzvaO2GKYqVvlWCxGn+01qVZbHVHtGLjOa3CLL79FNzisRZL
	qLbss32FuAyWb+hHmEw6QRDdQ0ZGC/PdLK5xZix2Ot7UUKvBbHw1tgwRUnbSSxQMG/KvninutDE
	VQTjBZ/2gWK3Hs7nAZlG+CaPRxBwXGH7P/XCq5s0GZWz+dksLYjfVjpXLnrVqiJ5Xcl0HsatMot
	jly8xDleq9sjFHUqrDMqgPrld6KqnHbatpMAqrmj88zeSUwC90jaQO2dozg6XynWZ9g1+tlAOJ7
	4sJAI55wBDxONzcJxNyKdLbMBMcDV9wP++dMwbTVqlO7gUKPrJR5ap6oT3dkzMDuk3+OiZ4NIC4
	Md3LS48DqgrWz3cYTzJEm5rSZIQsNnmHnLh39fk0Ow/brC9eaLA796kPVeL3hc18IEA3+5uLlXe
	i29mglDqJIRjUNWjZurh6LprUzbLSX
X-Received: by 2002:a05:600c:4448:b0:47b:d992:601e with SMTP id 5b1f17b1804b1-48370e2b6bemr278598485e9.2.1771584481843;
        Fri, 20 Feb 2026 02:48:01 -0800 (PST)
Received: from ?IPV6:2001:1a48:8:903::e14? ([2001:1a48:8:903::e14])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796abe3b3sm62652000f8f.18.2026.02.20.02.48.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Feb 2026 02:48:01 -0800 (PST)
Message-ID: <3f2b985a-2fb0-4d63-9dce-8a9cad8ce464@suse.com>
Date: Fri, 20 Feb 2026 11:48:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
To: Marcelo Tosatti <mtosatti@redhat.com>, Michal Hocko <mhocko@suse.com>
Cc: Leonardo Bras <leobras.c@gmail.com>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org,
 Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>,
 Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>,
 Hyeonggon Yoo <42.hyeyoo@gmail.com>, Leonardo Bras <leobras@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Waiman Long <longman@redhat.com>,
 Boqun Feng <boqun.feng@gmail.com>, Frederic Weisbecker <fweisbecker@suse.de>
References: <20260206143430.021026873@redhat.com> <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad> <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash> <aZL45yORfkNvS9Rs@tiehlicka>
 <aZcr255pGT3B/eaL@tpad>
From: Vlastimil Babka <vbabka@suse.com>
Content-Language: en-US
In-Reply-To: <aZcr255pGT3B/eaL@tpad>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9FB4BA0007
X-Stat-Signature: gqneruqiz8yhimuknoot8bs9xtmfcnfj
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771584483-882425
X-HE-Meta: U2FsdGVkX1/kHjnbOBT68mtZpNs4yHLcDJcsZ/01xMo8U+ohbKvzbmxmgTZmTBERynMeMHn1xQ0k7aDa54Ynt6bQOCqBMUUoQj69YvT20PbbXlowwwHT/CxDXDLqFh/z421SpRgr1rCXrTcj6HoM8WczP3aQNjKA7rjgjZOZxaukBAn/zx1vVcNe2vxSEzWX3Mw5rMmLdCvACf2IW0ob164bR5R9uapVBIYCLhc52zhWQNOoWXviPTOOC8dZTHYJbF78jMXDhroe7HwDGgKUaocz0TPvV+J3EvRL1oa/hfsmCvf6iVfW8I0UX5Zec6gLJXBZ3oT8V1i77SqQe8mGHYhTS/+2Wj6jdxiS3liPIjkDpK+gYvRPWkx6fRzgs9F6cZosS8bEg6Ti5x7h8Gyij/2ALKuhCTf+BWfTv2V3/qWZSCg/CWm0C+oYvfR7tHjuS8G5z8J5aLZL7YYMvA42nFz55xzP8hAlhUbHzxgOP8EFI/QuNdjVA2dbB6e34x/z/wH67FU+ENUr2tjsZOiu9eW+Yd1rExpFJku4nmLv6Mh8nbs0zUA6QGYaExccFshrjYoYH4YVByE4oG9PBLDhnpsB+Rlma56oh9I5kZ/10kDcnuV6Oxx2WbSpsqfz54lT5Pc/JLwx1cjmcPmZCwFziYkKrD4Z3YQf13RGx/nHfr911GA+1ejdlwRaPIxGZsWoqoKTlvLgfnnRw/0ApSORCVGkbZjc9uaUsZbtJ6t9Ojv94M+ZE50OH4NyZa5ACx92IrusW1nTD1vClKA+acde1Sf1RIB5lseere2VAtnRfaKjhrF6ARGwBpxBifRNuqlggLzdLUFk46/2xL0tXbV5n/t/L+5Wxl4dLtmJla3Q6s2stxBR8BhvozIlh+VLPfwfIIni+UpU4fws55Jjc/FnfT9FxaHSU3tPQGeCB+apBJM3423GkL3OVd/XELIgynk1R1jXpyrElnTvDMvKBQx
 5XNH0Npf
 7PPAEnos/XccXXfee0cYRgz8J48QJEMlFLC+FA1SWLFGJD2RxvC+Vm43m+qhcPkzJqQn1MaYW0BcHKU0pOAEBDJz5F9p5AhEAcFU1TVQHZYVHFaui7Mm+810b1z2yDkC8dGLzz84QUY8Am76rqwVsST9wm+PYlU3vyymAECd4TPU4wl1IfeIMT2q1X4FTgSx6qI3FZ58oU6BvpRDSq5gRNEC728Apvzfo/76U9xJ96c4jOgMfAg7jy8E+dS8g1Z7dHb8yotGs+Kf0Zxr4VgmKnpYkEM/RMgkt+fCZwk/fhdHNCpb+KolehMSLxLoImvDPVLyC4NagwZ0o/0I3l2gyxxwCc8OlGIftKihGMNOlvbX4V3bm5w3LmkLFiz665ceXMqmcEux7xm8gnTBWmeCpHxjJ/vELI7IJpfQANsEPn4sNpc0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/19/26 16:27, Marcelo Tosatti wrote:
> On Mon, Feb 16, 2026 at 12:00:55PM +0100, Michal Hocko wrote:
> 
> Michal,
> 
> Again, i don't see how moving operations to happen at return to 
> kernel would help (assuming you are talking about 
> "context_tracking,x86: Defer some IPIs until a user->kernel transition").
> 
> The IPIs in the patchset above can be deferred until user->kernel
> transition because they are TLB flushes, for addresses which do not
> exist on the address space mapping in userspace.
> 
> What are the per-CPU objects in SLUB ?
> 
> struct slab_sheaf {
>         union {
>                 struct rcu_head rcu_head;
>                 struct list_head barn_list;
>                 /* only used for prefilled sheafs */
>                 struct {
>                         unsigned int capacity;
>                         bool pfmemalloc;
>                 };
>         };
>         struct kmem_cache *cache;
>         unsigned int size;
>         int node; /* only used for rcu_sheaf */
>         void *objects[];
> };
> 
> struct slub_percpu_sheaves {
>         local_trylock_t lock;
>         struct slab_sheaf *main; /* never NULL when unlocked */
>         struct slab_sheaf *spare; /* empty or full, may be NULL */
>         struct slab_sheaf *rcu_free; /* for batching kfree_rcu() */
> };
> 
> Examples of local CPU operation that manipulates the data structures:
> 1) kmalloc, allocates an object from local per CPU list.
> 2) kfree, returns an object to local per CPU list.
> 
> Examples of an operation that would perform changes on the per-CPU lists 
> remotely:
> kmem_cache_shrink (cache shutdown), kmem_cache_shrink.
> 
> You can't delay either kmalloc (removal of object from per-CPU freelist), 
> or kfree (return of object from per-CPU freelist), or kmem_cache_shrink 
> or kmem_cache_shrink to return to userspace.
> 
> What i missing something here? (or do you have something on your mind
> which i can't see).

Let's try and analyze when we need to do the flushing in SLUB

- memory offline - would anyone do that with isolcpus? if yes, they probably
deserve the disruption

- cache shrinking (mainly from sysfs handler) - not necessary for
correctness, can probably skip cpu if needed, also kinda shooting your own
foot on isolcpu systems

- kmem_cache is being destroyed (__kmem_cache_shutdown()) - this is
important for correctness. destroying caches should be rare, but can't rule
it out

- kvfree_rcu_barrier() - a very tricky one; currently has only a debugging
caller, but that can change

(BTW, see the note in flush_rcu_sheaves_on_cache() and how it relies on the
flush actually happening on the cpu. Won't QPW violate that?)

How would this work with houskeeping on return to userspace approach?

- Would we just walk the list of all caches to flush them? could be
expensive. Would we somehow note only those that need it? That would make
the fast paths do something extra?

- If some other CPU executed kmem_cache_destroy(), it would have to wait for
the isolated cpu returning to userspace. Do we have the means for
synchronizing on that? Would that risk a deadlock? We used to have a
deferred finishing of the destroy for other reasons but were glad to get rid
of it when it was possible, now it might be necessary to revive it?

How would this work with QPW?

- probably fast paths more expensive due to spin lock vs local_trylock_t

- flush_rcu_sheaves_on_cache() needs to be solved safely (see above)

What if we avoid percpu sheaves completely on isolated cpus and instead
allocate/free using the slowpaths?

- It could probably be achieved without affecting fastpaths, as we already
handle bootstrap without sheaves, so it's implemented in a way to not affect
fastpaths.

- Would it slow the isolcpu workloads down too much when they do a syscall?
  - compared to "houskeeping on return to userspace" flushing, maybe not?
Because in that case the syscall starts with sheaves flushed from previous
return, it has to do something expensive to get the initial sheaf, then
maybe will use only on or few objects, then on return has to flush
everything. Likely the slowpath might be faster, unless it allocates/frees
many objects from the same cache.
  - compared to QPW - it would be slower as QPW would mostly retain sheaves
populated, the need for flushes should be very rare

So if we can assume that workloads on isolated cpus make syscalls only
rarely, and when they do they can tolerate them being slower, I think the
"avoid sheaves on isolated cpus" would be the best way here.


