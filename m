Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 622BAC5AD58
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 19:02:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AAAA6B0088; Fri, 20 Feb 2026 14:02:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3436B6B0089; Fri, 20 Feb 2026 14:02:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 225266B008A; Fri, 20 Feb 2026 14:02:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0CD0F6B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 14:02:35 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7F92B8B0D8
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 19:02:34 +0000 (UTC)
X-FDA: 84465756228.11.B9BE286
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 52A90100003
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 19:02:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I8TgpaKX;
	spf=pass (imf14.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771614152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9iHzvmcbPtFzdUbEREveeE+6fxU/Z+piAYr2pO9/Skk=;
	b=YMQEFUsZxVd73q21qtyHXHUK3f+mCTgphP7ZtuKlHp6zlLVgyseMfXHVNh6b8G6johRoS7
	gSBy+i72fzi+u7vz2saXUFFwffAeF4ZinBMjG4o5dD6dg00bCsKE5GBWWgOVpqZxOuomkW
	oTwC6qULrxe+vdHQ0dEjbEUu7SINorY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I8TgpaKX;
	spf=pass (imf14.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771614152; a=rsa-sha256;
	cv=none;
	b=nbFnJAuII7njppymK2lIoTOY/A2/THHGghVpLmHJybDJLYsSI4DTQqqUBMb2QwOH5ny544
	95B0gkM0/O4rDq3HKmKNq/hp1qmrodPrXXBMHVlf6OTNAhncC8lD8vWi362HQL7zooN0rj
	BXEyFy/lyjnX3t09wp8ErJo0jscJrKA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771614151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9iHzvmcbPtFzdUbEREveeE+6fxU/Z+piAYr2pO9/Skk=;
	b=I8TgpaKX9UZroJADYLIZwNdyVcqgl7SRgvmdw/KeolTb/ACHNElu/ijIoarD6vYvq2oDxt
	MxFU9Owlyu1vntWtPk+IdaEpyTln39K6TGwKz1OlbB8P+Tl87D2k0NQjWU/U+Jyfyr8LNy
	Nr7lUkGDS5GLi2wMrSaTNB/KgyAB3Z8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-515-I5SMJDneMTSjyoCXVPcCRg-1; Fri,
 20 Feb 2026 14:02:27 -0500
X-MC-Unique: I5SMJDneMTSjyoCXVPcCRg-1
X-Mimecast-MFC-AGG-ID: I5SMJDneMTSjyoCXVPcCRg_1771614145
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 38767180057E;
	Fri, 20 Feb 2026 19:02:24 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.4])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 63DF619560A7;
	Fri, 20 Feb 2026 19:02:22 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id E17AA402E7782; Fri, 20 Feb 2026 16:01:59 -0300 (-03)
Date: Fri, 20 Feb 2026 16:01:59 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Vlastimil Babka <vbabka@suse.com>
Cc: Michal Hocko <mhocko@suse.com>, Leonardo Bras <leobras.c@gmail.com>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Message-ID: <aZivpwJnIGKdAMYE@tpad>
References: <20260206143430.021026873@redhat.com>
 <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad>
 <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash>
 <aZL45yORfkNvS9Rs@tiehlicka>
 <aZcr255pGT3B/eaL@tpad>
 <3f2b985a-2fb0-4d63-9dce-8a9cad8ce464@suse.com>
 <aZibbYH7yrDZlnJh@tpad>
 <a1c11a09-da88-4edd-9571-0f792b59e9c3@suse.com>
MIME-Version: 1.0
In-Reply-To: <a1c11a09-da88-4edd-9571-0f792b59e9c3@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: y17Q3gR26oTgD9SuVLc1LMSTnlCpOIHSTqj4R5by3sc_1771614145
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 52A90100003
X-Stat-Signature: h4kaxruganuse1jgg5x63cfyzm5bwj7z
X-HE-Tag: 1771614152-102371
X-HE-Meta: U2FsdGVkX1+lE66W8FBRFHZs7iBq2P6vXt9tnBZTYSDPeN9sTLkAEejT+KWGRK/E1sqc4viLqHuXP3YBry1peBpPSVhSnieJ8ptbDTqrvk4JfQAyKBo84OJRVsIgdaW8S9GQNbsb0kaAJmt/yMkGCEEtyaQu7m+McoG/MjDEaRnkT939CRxFaXfb3Mpz9ubnGGonZX7QXUH3WLcdb+nAdp5E079ATECf0H5CxaW4A3q7mHYxNpLYvgofsm7/lNJIliuQTeKS6Y8dtR2ag4OpUyqDu3JrE6tCftbHb31kWpt53sZU6usdEDzV5geaf/5X4v5hkMAzdhr7z1VgKoqAyKSFDQyUVdlgylBSEgzyY2sdE3Hm8tvlWGRTQVNhdW5qcK9WUL3BJQLffDT4njQulLCg7LKBMBoYpW6tKlW2uZ81evGTtoZjGpnCvC58fFe1TOXa4l7qmZKfob2O+hyJFwrxbleBTFfBNYeNhYj6d4EsFK2aftgl1q7SEDpAszU0oUp7Zsi5FQLv7Sjc6c6zhgpq0c5oWtwo+rVzE71laLpudxjhHnncbxROmuK++yoDkyM+ZstiDD3oSs+n7T8OW8irRf/DvHO51IxpLdrn/newaJ7n3b4j23NdkAi4xbkk7KEmsRcuBI7BYUQH3Pvvw5nhZGhWv77oHaxj11DJtYGiBvLnP6HgMx3xJURrTY4iaQD5WXWoi1U5yxYOzOnSVUaguchOyE+Nm04ArvPBsYof7nTMAIyB5/N+7goJaOno42jrsttQrW6zJSaOGZhNDJ5QpAkUC/7YpOfP09hdPpuhpouc6MuU90KEyYBgNjtRWvya0abfOBbduCi5OxSxukyGqhH34kyvznCLLPvb1VhNKlyDzQiL6292nqj1aAV3NXxQVuEgFa6k5nDkuaxJMMVM2LEC5K3g2gKOYj7wj0Df2K5psQiH5wEZ4Cin63d2XveszPvKwPPbhk/wP6m
 wALxJGwv
 qII6Qq7iZ+gL7Y4ImAB6T/umudFg8OZMGHLMVOIL40Cep9CpLx8/oK1B8x/5rDeqJT8xsm5tM8HQNsZoQ8FZABdZ6arUUH83R5PznAEIKTbKf1hf6XODdJW/77rzQO5SYkj+lv/JnUU1ZjvGT4LFZzpk1esNdgk6RaMPsEyZokFPQNUKfCimb+rtDRqwnPQmIx8lGFmkntOuY5xLAR0dlFxPTbv7FuKst6bp2urE1rk4ck1BQpLGl4KE/WprxIV1LANAbY3rzBkMZUgjjB3cs8LKY32T1r+8kDGW4vN/66z2uaD6zR2gqPltmnzgWC60DRSodYCyFzCddir5kbTq/aIGjdhk4olaqvnuhtbN61TPzmyOmsbiiPUKfjGco/Zs+SzZo8leC1IAGINusE48Ip8DIpKPHwII8g7mWWosQL6BJg9DqLIy8x2hDTmOTEtN3OBnbJh80RV7yCnJLuMDUgF/rKPBV2XnEfGfuMvU5DH6wXTX/mhXgxOGzwsP9T8qjeC6El+yhGxSJS+L+CqY/FbjRN3fdO6C1reAtOy77gtmWijgOmCfqC2pNz4hQVz/MDRGU9Xeydg2iwYU5CvXOFIPKSjzFRDeZbEYh7gzKNB02yhroyBoXuOqVefKHqB68HmJ++gZWNTTWj0BCXnGo5lTjfv20+9WvbC1AdSGEW2MYV+d8DuZpci7/mghaGyub+BSU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 06:58:10PM +0100, Vlastimil Babka wrote:
> On 2/20/26 18:35, Marcelo Tosatti wrote:
> > 
> > Only call rcu_free_sheaf_nobarn if pcs->rcu_free is not NULL.
> > 
> > So it seems safe?
> 
> I guess it is.
> 
> >> How would this work with houskeeping on return to userspace approach?
> >> 
> >> - Would we just walk the list of all caches to flush them? could be
> >> expensive. Would we somehow note only those that need it? That would make
> >> the fast paths do something extra?
> >> 
> >> - If some other CPU executed kmem_cache_destroy(), it would have to wait for
> >> the isolated cpu returning to userspace. Do we have the means for
> >> synchronizing on that? Would that risk a deadlock? We used to have a
> >> deferred finishing of the destroy for other reasons but were glad to get rid
> >> of it when it was possible, now it might be necessary to revive it?
> > 
> > I don't think you can expect system calls to return to userspace in 
> > a given amount of time. Could be in kernel mode for long periods of
> > time.
> > 
> >> How would this work with QPW?
> >> 
> >> - probably fast paths more expensive due to spin lock vs local_trylock_t
> >> 
> >> - flush_rcu_sheaves_on_cache() needs to be solved safely (see above)
> >> 
> >> What if we avoid percpu sheaves completely on isolated cpus and instead
> >> allocate/free using the slowpaths?
> >> 
> >> - It could probably be achieved without affecting fastpaths, as we already
> >> handle bootstrap without sheaves, so it's implemented in a way to not affect
> >> fastpaths.
> >> 
> >> - Would it slow the isolcpu workloads down too much when they do a syscall?
> >>   - compared to "houskeeping on return to userspace" flushing, maybe not?
> >> Because in that case the syscall starts with sheaves flushed from previous
> >> return, it has to do something expensive to get the initial sheaf, then
> >> maybe will use only on or few objects, then on return has to flush
> >> everything. Likely the slowpath might be faster, unless it allocates/frees
> >> many objects from the same cache.
> >>   - compared to QPW - it would be slower as QPW would mostly retain sheaves
> >> populated, the need for flushes should be very rare
> >> 
> >> So if we can assume that workloads on isolated cpus make syscalls only
> >> rarely, and when they do they can tolerate them being slower, I think the
> >> "avoid sheaves on isolated cpus" would be the best way here.
> > 
> > I am not sure its safe to assume that. Ask Gemini about isolcpus use
> > cases and:
> 
> I don't think it's answering the question about syscalls. But didn't read
> too closely given the nature of it.

People use isolcpus with all kinds of programs. 

> > For example, AF_XDP bypass uses system calls (and wants isolcpus):
> > 
> > https://www.quantvps.com/blog/kernel-bypass-in-hft?srsltid=AfmBOoryeSxuuZjzTJIC9O-Ag8x4gSwjs-V4Xukm2wQpGmwDJ6t4szuE
> 
> Didn't spot system calls mentioned TBH.

I don't see why you want to reduce performance of applications that 
execute on isolcpus=, if you can avoid that.

Also, won't bypassing the per-CPU caches increase contention on the 
global locks, say kmem_cache_node->list_lock.

But if you prefer disabling the per-CPU caches for isolcpus
(or a separate option other than isolcpus), then see if 
people complain about that... works for me.

Two examples:

1)

https://github.com/xdp-project/bpf-examples/blob/main/AF_XDP-example/README.org

Busy-Poll mode
Busy-poll mode. In this mode both the application and the driver can be run efficiently on the same core. The kernel driver is explicitly invoked by the application by calling either recvmsg() or sendto(). Invoke this by setting the -B option. The -b option can be used to set the batch size that the driver will use. For example:

sudo taskset -c 2 ./xdpsock -i <interface> -q 2 -l -N -B -b 256

2)

https://vstinner.github.io/journey-to-stable-benchmark-system.html

Example of effect of CPU isolation on a microbenchmark
Example with Linux parameters:

isolcpus=2,3,6,7 nohz_full=2,3,6,7
Microbenchmark on an idle system (without CPU isolation):

$ python3 -m timeit 'sum(range(10**7))'
10 loops, best of 3: 229 msec per loop
Result on a busy system using system_load.py 10 and find / commands running in other terminals:

$ python3 -m timeit 'sum(range(10**7))'
10 loops, best of 3: 372 msec per loop
The microbenchmark is 56% slower because of the high system load!

Result on the same busy system but using isolated CPUs. The taskset command allows to pin an application to specific CPUs:

$ taskset -c 1,3 python3 -m timeit 'sum(range(10**7))'
10 loops, best of 3: 230 msec per loop
Just to check, new run without CPU isolation:

$ python3 -m timeit 'sum(range(10**7))'
10 loops, best of 3: 357 msec per loop
The result with CPU isolation on a busy system is the same than the result an idle system! CPU isolation removes most of the noise of the system.


