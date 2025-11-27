Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 158FDCFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 14:01:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BDB86B0005; Thu, 27 Nov 2025 09:01:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5951D6B000C; Thu, 27 Nov 2025 09:01:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D1FB6B000D; Thu, 27 Nov 2025 09:01:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CF166B0005
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:01:04 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AF379B5E3C
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:01:03 +0000 (UTC)
X-FDA: 84156548406.17.48BDABE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 91F0B100035
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:01:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B9+qCK+M;
	spf=pass (imf05.hostedemail.com: domain of da.gomez@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=da.gomez@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764252061;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tvHnQN2o55uqCDDLDN+Dj84s9HJl0XyY9oTPo9MKvjM=;
	b=n38JVwIx1L1MwAVEPyv6PY7EEl8O7wj6CbsEek+lLj5e8crpIkFyiWnb+dvlmgXo6rDh+u
	AU2xV3KSURymUllzMXp+M+eDvF/WC8cu7W/zXGYmxUozSo1jbt/ykpgVPMdgefgwGy2Ctj
	hqYK3JfmntgCCtGAJL3pEoW7VgmcCg0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764252061; a=rsa-sha256;
	cv=none;
	b=KdyKwsDyB+naZIRSrU0NNL7Y/W1MKknFISADoNj2p7QB2bgEmDPgCQvtARzHewjHxgUscm
	F3wJGkizDOUUFNl2T41Myfi1rpFZAwx5t2oQiRO67z3nqdTeGpAWBqF/5cilWHwrQ9xLox
	vl3bCddm9L/u33Up4Ellyd262ufFtfE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B9+qCK+M;
	spf=pass (imf05.hostedemail.com: domain of da.gomez@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=da.gomez@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BB38160141;
	Thu, 27 Nov 2025 14:01:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5D5C4CEF8;
	Thu, 27 Nov 2025 14:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764252060;
	bh=KGXUj1kvM6a58FkYMQl5WgaFk37luqe5xhEBKypDNK4=;
	h=Date:Reply-To:Subject:To:Cc:References:From:In-Reply-To:From;
	b=B9+qCK+MNe+2KUOE8MINX7ThiGv1jHBXwcjX5cLuQaHUqLohoo/ckM9GucUJ6fnG3
	 Hva2ByD25h2xXX2VXzW1CntAG7HgJI6JzLKpME5iuHOp1Uei6BO8nRo8zgbu+VeYal
	 dQU2fd/HuxTKr+GjMfTWVWSa1NPBBuJAB1Rz29jqt4OhJ1g3H/N/KXmgSYSiTKS4sh
	 n++bva0Xe9JVf7TFDpFpwOZ92RkabxIJA77dZ7f9rQkDSQjkeFDMXejcz6BkgkH8ri
	 SpoPnNduoCjfOiAugW1IytqTnL0q74RBYndotJscMNdgWx/28oqHRkWyQFdGuZDlN3
	 zWbdCwMLa18Sg==
Message-ID: <1c34bf75-0ea3-490d-b412-288c7452904e@kernel.org>
Date: Thu, 27 Nov 2025 15:00:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: Daniel Gomez <da.gomez@kernel.org>
Subject: Re: [PATCH v8 04/23] slab: add sheaf support for batching kfree_rcu()
 operations
To: Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Uladzislau Rezki <urezki@gmail.com>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org, linux-modules@vger.kernel.org,
 bpf@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
 Petr Pavlu <petr.pavlu@suse.com>, Sami Tolvanen <samitolvanen@google.com>,
 Aaron Tomlin <atomlin@atomlin.com>,
 Lucas De Marchi <lucas.demarchi@intel.com>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-4-ca3099d8352c@suse.cz>
 <0406562e-2066-4cf8-9902-b2b0616dd742@kernel.org> <aQge2rmgRvd1JKxc@harry>
 <1bda09da-93be-4737-aef0-d47f8c5c9301@suse.cz>
Content-Language: en-US
From: Daniel Gomez <da.gomez@kernel.org>
Organization: kernel.org
In-Reply-To: <1bda09da-93be-4737-aef0-d47f8c5c9301@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 91F0B100035
X-Stat-Signature: jnrnahqtgtkrphajtmg6tat6bii6gyr3
X-HE-Tag: 1764252061-661627
X-HE-Meta: U2FsdGVkX1/q3ZFIPE8ucawSZbijzawAtUyok++fdT4Rf9kiZ7sAn5tx+omgLGYu9pExo+0kZuUx3kxyE3ejJIDlLxdksc7c6IxHs3x6y8NkyzgvuB+moxiQpRBtC/suctaRcfTPGXcWSEANCeejHGb7pT9SWFhQI2KnoMN2F9Q46KZ1g5+1R+qDQ1U0hBdkvJN1NZz7bkgCyI6pOGYv2fRH6JR4Q3XWiJ4K8G04iavlhyLGgfbbOjnS3kQt82FPWtql75aaSz1OXq7XeLhfDXqSGnZxbkIQEx5s/vZbw5lee+qRKAp+2BDGzihCOI64RnJP+OzivofbRLF61/QAJw9Qw7CIhfs8Tfb9ByvMReChFmhXr3aOIQDmse91vQYfXnt084WBH5Kd39Vj32Xovwb+10REVgTJ3ujCJdMDpXF84g2pwwxiEc1SLPr7cPlxYkBZu5NJrdym8I8J36y/dqMdkOQIibP1hS8xTrgmi/9I5kSJrK/ChNAF8afLA/Q8sYRA7dYACOyLyWw6d0YXd5DMq0FKE34RDrxBGkrce8Md01TJumzOyF0VGqKnPSzx+Z3TI3L7mvN1FD55hs8oQ9cZG3Fwg+OVx917duVrOmdDb0KwBCYeWB7SpzyS3TeK+GtnGLqmCUgKz7qaav1sOXWLz5yiV9MPfCq0g2/JK5TYc7knBc2bzJdSY747OedCvbvB24ORni1JOaTnoQ7RSpfWUbwfewZgLgLPgHZtXLvY4r3BKJR3SkaI8UEutzthNchC1CUVIPzoCF/PTY02fyvfrZtWbI92kgwyr6DvwXgRet/npYm6WVELC1vkYkuQ0hjjY1eXXPi1GDVpzBRCyeKjYUnerQgZKmixJ+hxRXkYBTDbvPPMMbCOuaUSjJY3bkvEiLxaLv14YiiSPCADUw3wn3T0KpNKkTSymhGLHSOBOy/XsnNJoisbF+W9ITbXO/a1tKiImk4fwjG2stG
 Mbu330UY
 vZf8sJ3HMpGTEpmjPuizzE15unHCiHyvm+2trEWz99e2VonPn7r8hqOTT6oAjyn5QOcTriuHiQ+unUow3uuB6JOKiwfFPqHW4OliV1goroYLMPFX12OqlEOqHvx5v/dg7Zs3U+tuWyH51u8Po8BwKcPTYcvwXpBEiACmVnChowl8tP9hrGPfmMHA1+pnOYymf0cpSdN2Fyi+FlvlPw4I0dZcVihDgxzf3s61ptbBNCkLP4onXbQrapdqGpVBdYJLAg67YxWVTosh9hcP9jO8ftiy9EWWEWaAHkgJBKUYlc+3dakc3lsfRi7uii1Fdx9q3Bv2qNU+KPRzApYFOutLjZB9/gVslW8n3q0t36Gu7CxLY95lloB/mIHrh5DNiMr6yQOJTOr3z9WLLXa4DSkmrhxYjNrcPNGCX43fFRaz13f0EX2NPiAOvUkcZag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/11/2025 12.25, Vlastimil Babka wrote:
> On 11/3/25 04:17, Harry Yoo wrote:
>> On Fri, Oct 31, 2025 at 10:32:54PM +0100, Daniel Gomez wrote:
>>>
>>>
>>> On 10/09/2025 10.01, Vlastimil Babka wrote:
>>>> Extend the sheaf infrastructure for more efficient kfree_rcu() handling.
>>>> For caches with sheaves, on each cpu maintain a rcu_free sheaf in
>>>> addition to main and spare sheaves.
>>>>
>>>> kfree_rcu() operations will try to put objects on this sheaf. Once full,
>>>> the sheaf is detached and submitted to call_rcu() with a handler that
>>>> will try to put it in the barn, or flush to slab pages using bulk free,
>>>> when the barn is full. Then a new empty sheaf must be obtained to put
>>>> more objects there.
>>>>
>>>> It's possible that no free sheaves are available to use for a new
>>>> rcu_free sheaf, and the allocation in kfree_rcu() context can only use
>>>> GFP_NOWAIT and thus may fail. In that case, fall back to the existing
>>>> kfree_rcu() implementation.
>>>>
>>>> Expected advantages:
>>>> - batching the kfree_rcu() operations, that could eventually replace the
>>>>   existing batching
>>>> - sheaves can be reused for allocations via barn instead of being
>>>>   flushed to slabs, which is more efficient
>>>>   - this includes cases where only some cpus are allowed to process rcu
>>>>     callbacks (Android)
>>>>
>>>> Possible disadvantage:
>>>> - objects might be waiting for more than their grace period (it is
>>>>   determined by the last object freed into the sheaf), increasing memory
>>>>   usage - but the existing batching does that too.
>>>>
>>>> Only implement this for CONFIG_KVFREE_RCU_BATCHED as the tiny
>>>> implementation favors smaller memory footprint over performance.
>>>>
>>>> Also for now skip the usage of rcu sheaf for CONFIG_PREEMPT_RT as the
>>>> contexts where kfree_rcu() is called might not be compatible with taking
>>>> a barn spinlock or a GFP_NOWAIT allocation of a new sheaf taking a
>>>> spinlock - the current kfree_rcu() implementation avoids doing that.
>>>>
>>>> Teach kvfree_rcu_barrier() to flush all rcu_free sheaves from all caches
>>>> that have them. This is not a cheap operation, but the barrier usage is
>>>> rare - currently kmem_cache_destroy() or on module unload.
>>>>
>>>> Add CONFIG_SLUB_STATS counters free_rcu_sheaf and free_rcu_sheaf_fail to
>>>> count how many kfree_rcu() used the rcu_free sheaf successfully and how
>>>> many had to fall back to the existing implementation.
>>>>
>>>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>>>
>>> Hi Vlastimil,
>>>
>>> This patch increases kmod selftest (stress module loader) runtime by about
>>> ~50-60%, from ~200s to ~300s total execution time. My tested kernel has
>>> CONFIG_KVFREE_RCU_BATCHED enabled. Any idea or suggestions on what might be
>>> causing this, or how to address it?
>>
>> This is likely due to increased kvfree_rcu_barrier() during module unload.
> 
> Hm so there are actually two possible sources of this. One is that the
> module creates some kmem_cache and calls kmem_cache_destroy() on it before
> unloading. That does kvfree_rcu_barrier() which iterates all caches via
> flush_all_rcu_sheaves(), but in this case it shouldn't need to - we could
> have a weaker form of kvfree_rcu_barrier() that only guarantees flushing of
> that single cache.

Thanks for the feedback. And thanks to Jon who has revived this again.

> 
> The other source is codetag_unload_module(), and I'm afraid it's this one as
> it's hooked to evey module unload. Do you have CONFIG_CODE_TAGGING enabled?

Yes, we do have that enabled.

> Disabling it should help in this case, if you don't need memory allocation
> profiling for that stress test. I think there's some space for improvement -
> when compiled in but memalloc profiling never enabled during the uptime,
> this could probably be skipped? Suren?
> 
>> It currently iterates over all CPUs x slab caches (that enabled sheaves,
>> there should be only a few now) pair to make sure rcu sheaf is flushed
>> by the time kvfree_rcu_barrier() returns.
> 
> Yeah, also it's done under slab_mutex. Is the stress test trying to unload
> multiple modules in parallel? That would make things worse, although I'd
> expect there's a lot serialization in this area already.

AFAIK, the kmod stress test does not unload modules in parallel. Module unload
happens one at a time before each test iteration. However, test 0008 and 0009
run 300 total sequential module unloads.

ALL_TESTS="$ALL_TESTS 0008:150:1"
ALL_TESTS="$ALL_TESTS 0009:150:1"

> 
> Unfortunately it will get worse with sheaves extended to all caches. We
> could probably mark caches once they allocate their first rcu_free sheaf
> (should not add visible overhead) and keep skipping those that never did.
>> Just being curious, do you have any serious workload that depends on
>> the performance of module unload?

Can we have a combination of a weaker form of kvfree_rcu_barrier() + tracking?
Happy to test this again if you have a patch or something in mind.

In addition and AFAIK, module unloading is similar to ebpf programs. Ccing bpf
folks in case they have a workload.

But I don't have a particular workload in mind.

