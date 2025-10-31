Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D515CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 21:33:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B5D18E0083; Fri, 31 Oct 2025 17:33:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 365E78E0068; Fri, 31 Oct 2025 17:33:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 254C08E0083; Fri, 31 Oct 2025 17:33:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0FF9E8E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 17:33:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 923B91405B8
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 21:33:02 +0000 (UTC)
X-FDA: 84059709804.09.041A668
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id BAC6E1C0004
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 21:33:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="scPetG/8";
	spf=pass (imf18.hostedemail.com: domain of da.gomez@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=da.gomez@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761946380;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VUqR4FMfQwNZpL116cR4kcP/1a5HaHbPMWvdYos7FdI=;
	b=PYxwTsudKCQgCYWiSe8DCruV5q9Z74wEH/yqGAUo5pzTWPZSHEbD+xAksdinWQ+XPu2f2d
	Gm4kbrAmrCc252KU5ee9ynwpPPeLn9ix7HZ0Gw0Yrx7GSniub+vA8OcDZWPmw/b0sTHiHq
	PrharvpG+MvVjj65bUv1TyxYFepIXUg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="scPetG/8";
	spf=pass (imf18.hostedemail.com: domain of da.gomez@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=da.gomez@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761946380; a=rsa-sha256;
	cv=none;
	b=RUlmR9quAwcLnqxFVxgcdMCikT5ECsj4hoS3W+/8tpsORupCjUYcz9RXTV6Q6xt+XbpV9V
	urTUmYYaQ21jytlGShXHsJxngK9GrB6Jm49zK+Uj+Nx9p2/4tC49pR+6kBCERLZ0ap/6lk
	iXB/LC5CI4sSiU2G/kJ1dZXt+C5rTHA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 06B8360371;
	Fri, 31 Oct 2025 21:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE0BC4CEE7;
	Fri, 31 Oct 2025 21:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761946379;
	bh=Q4jsAPOYgiCp2KBXrG94dO+Z5cGNiyamdcVsqHPG6eM=;
	h=Date:Reply-To:Subject:To:Cc:References:From:In-Reply-To:From;
	b=scPetG/8GyxPOp5NeOGZMQrNgPWI6rBtLqVJwmQQNXxtmixSR3lctbzXBP3bSETJ8
	 OnAwpatmqDVSwsZHVga36biummiWSTCJxbHFjyYwYG7pAY5n56+e3Pjn/pN3h8yYtI
	 WvetyPgBQY5r4jDatzGOP2vVqyLwBDghoLO6HkUcEcyxL7LcVQppeGf/rRaghjt9h3
	 yMqziMyZ+vWh+J4B5F7NaP/Qk1AOWN8nmdvBs7UqjgOusnmkNkziqzA0jsSudpR15p
	 rSvl24o0f6k6NRcC5UexL876spmEuDWkRhQFNLqd1RKl3xWRhtTlnjCtuKNbx92PNH
	 wjOO4lNYT4ufg==
Message-ID: <0406562e-2066-4cf8-9902-b2b0616dd742@kernel.org>
Date: Fri, 31 Oct 2025 22:32:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: Daniel Gomez <da.gomez@kernel.org>
Subject: Re: [PATCH v8 04/23] slab: add sheaf support for batching kfree_rcu()
 operations
To: Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org, linux-modules@vger.kernel.org,
 Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
 Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>,
 Lucas De Marchi <lucas.demarchi@intel.com>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-4-ca3099d8352c@suse.cz>
Content-Language: en-US
From: Daniel Gomez <da.gomez@kernel.org>
Organization: kernel.org
In-Reply-To: <20250910-slub-percpu-caches-v8-4-ca3099d8352c@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BAC6E1C0004
X-Stat-Signature: juoy1463woujjbgcnpu4bgay6jqd6drs
X-Rspam-User: 
X-HE-Tag: 1761946380-470298
X-HE-Meta: U2FsdGVkX191h/e6/O9sVUtOQ0CcsVoQ7fNfsgCmScDkhULL2j8W/gAFHLbLnKm5o7FJdz9Xugz1yd2LIqsOxoJkJJ8R3CSI0jEI+h00fn8AU7TC221+u8MzuaTrVrerq1Ddewi2y/fsCcIZ3if38lwdLYvwZzoXHq8tEnqzeoDIXdJv7RspMooXpoi220vMFoN7mVhyqzTgcfhM7fp8RqWsrFNiNDW5wwHIIItWqkTONJBcDC5UtpDNAWuTDgiv8RonRfLO2WEED/r1d0VFMuZ+RckO7B97Co/dDbW/9cYAGcVjetydWjzHVqtW+AqGJ3MqF/auOPXY4drS/mYI4uLrrYgvFVolTLQsOnJIzh+GQP5lUyRHKdIMzkXtKXaGsmkXVSmhpW98a6rqCnJW4J7Ih0wgRrrlkjqXQXFIwOZBnjvSVxxEULjrxMlhx4RswVbp/T58d5fXWOroQhhp1EwLFQpAOZNl+B0SXBE5v7cjELkJEudJq6x6vau1P4nl+Kl/B2lcvkRtL3CJTaZfDW2Ohlx21xSxSq7rfwCUX3hZCLjCqfkrNV+suAMTCg5ZrUHrGsIAZ35G9gGe3vepy2bY86OGJjgQZggV07uQlkM1/uNTzngpuOHffe3dLo0MT4QCePvB5OVk+tcS2WWQ23wWkPn92lua/1wsXNgq3iaxxoC4bvwj6DIx6vJnZqvkBKboTnt/FB8o+AEf46GS4UcIKUoFTXn7IHSheR53jVMsTzUBOLMxqLW/vmvRVTfp1b849ewziz9tF93pte1BgJd7NhqEVQXqVgzWZMVp/X0kWy2DxC099CBFomf1HiO9h/N+7YmxFFuifZSHvMP2CnuAhvtS/0B5vQJowcpBPv/QathGJ9XqVuESFrJoxZA/8xob9ktYYCwAYI50fxzN/3fe9bueOC4k8yOyzf1P0riUyANX8tzWjzk9nuu05LFPRz0xGZn925DIVBvRcHp
 NknrbVue
 whqeiHgrz4wJykHOvQMbJhyU1wTCaBozv3lwM62wC1kq0e+rnuR10ot8mczGEt1aAZkphbGZ+R72x9IWR5QgVhUebSKs+2P1yE3L1yIBVykH1wjmR+IzFnzOqNqzs299EM0bLZT/787+h7zgCB0ZZgSXqo89eAbZOh5XhRhwXC4P6CijBHrKyLxQ4fGNjSHyX3HuPJeK/dNm8Paee0YXzMwGh2SA+WNB7dWi67q1IUWWsXnyEr2yG8FOxx3nCZdNak7i8FVAw+WFkkemYIWESSNG42ErqCOkVft4zs33HrIT7122I6rGsmLZZ0MKyUz7Ie/r4XKg9ngItOf1ypOEylubVOjixn7ywopmVmjflWytxroEHXbWqX/4w5MVhU6RN5QNmkUpNb1yjU1zTAtyw2LBUG6wNw/9ssQ9aoXPVWhGMATr4PqgNzf/wwQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/09/2025 10.01, Vlastimil Babka wrote:
> Extend the sheaf infrastructure for more efficient kfree_rcu() handling.
> For caches with sheaves, on each cpu maintain a rcu_free sheaf in
> addition to main and spare sheaves.
> 
> kfree_rcu() operations will try to put objects on this sheaf. Once full,
> the sheaf is detached and submitted to call_rcu() with a handler that
> will try to put it in the barn, or flush to slab pages using bulk free,
> when the barn is full. Then a new empty sheaf must be obtained to put
> more objects there.
> 
> It's possible that no free sheaves are available to use for a new
> rcu_free sheaf, and the allocation in kfree_rcu() context can only use
> GFP_NOWAIT and thus may fail. In that case, fall back to the existing
> kfree_rcu() implementation.
> 
> Expected advantages:
> - batching the kfree_rcu() operations, that could eventually replace the
>   existing batching
> - sheaves can be reused for allocations via barn instead of being
>   flushed to slabs, which is more efficient
>   - this includes cases where only some cpus are allowed to process rcu
>     callbacks (Android)
> 
> Possible disadvantage:
> - objects might be waiting for more than their grace period (it is
>   determined by the last object freed into the sheaf), increasing memory
>   usage - but the existing batching does that too.
> 
> Only implement this for CONFIG_KVFREE_RCU_BATCHED as the tiny
> implementation favors smaller memory footprint over performance.
> 
> Also for now skip the usage of rcu sheaf for CONFIG_PREEMPT_RT as the
> contexts where kfree_rcu() is called might not be compatible with taking
> a barn spinlock or a GFP_NOWAIT allocation of a new sheaf taking a
> spinlock - the current kfree_rcu() implementation avoids doing that.
> 
> Teach kvfree_rcu_barrier() to flush all rcu_free sheaves from all caches
> that have them. This is not a cheap operation, but the barrier usage is
> rare - currently kmem_cache_destroy() or on module unload.
> 
> Add CONFIG_SLUB_STATS counters free_rcu_sheaf and free_rcu_sheaf_fail to
> count how many kfree_rcu() used the rcu_free sheaf successfully and how
> many had to fall back to the existing implementation.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Hi Vlastimil,

This patch increases kmod selftest (stress module loader) runtime by about
~50-60%, from ~200s to ~300s total execution time. My tested kernel has
CONFIG_KVFREE_RCU_BATCHED enabled. Any idea or suggestions on what might be
causing this, or how to address it?

