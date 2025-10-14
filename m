Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70655CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 22:57:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A92E98E00C7; Tue, 14 Oct 2025 18:57:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6ADA8E0041; Tue, 14 Oct 2025 18:57:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 980F68E00C7; Tue, 14 Oct 2025 18:57:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 81F668E0041
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 18:57:20 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3A7CB479B7
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 22:57:20 +0000 (UTC)
X-FDA: 83998232640.04.482A462
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6D4164000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 22:57:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LDY5mFre;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760482638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dRhy5pXAiQl4JPAdYHEJpTxKiPwF/nTrHCkBnWAbo/A=;
	b=JsQgQbjgDE+fCF+a3os43FfZQ4n9nssiCvZbwTaCfalVdMwxM/iInjsNsk4InPWFin5G2J
	/Jzuy6MEJvDJE1DcwgK2VGR3XqruvSxKLj2z96QSwng0euj+vJI5BHuVA1jM8QlffvNt3R
	48hnZnTaOq/uGloTgxcEF/m3y9y/DDw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LDY5mFre;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760482638; a=rsa-sha256;
	cv=none;
	b=uO2vsoZ0HPiBjxkxDhu8KBGAIh/UzEQGYWsfF1noyawlhEDViDQcTUaFASAsNuG5QkCgth
	WWkHPm6t7THgeVIQ4VzxF4IPtgttzkUN93qoy2fcU9v0cGXGz9BvKmCN8/D877NhGv9C/k
	TPc4cu8/DtKDfybcRfXzUQTcmjUMiGI=
Date: Tue, 14 Oct 2025 15:57:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760482636;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dRhy5pXAiQl4JPAdYHEJpTxKiPwF/nTrHCkBnWAbo/A=;
	b=LDY5mFre+DitGOhyqu1GnrOHBiIq9UCsNNZUR8Y8e4ORBcMGksT5qu3WyakL62mrgaMKqk
	b3TaGb3B5E3oqIzMyHPha306UJdZSRl5r0VWL7/4p4A6cmwVMvfU+cPu+tEAGPhlItHHtJ
	Xfkijkcc+/6IOOVSchy7JRB8G1A5Zys=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: bpf@vger.kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	martin.lau@kernel.org, vbabka@suse.cz, yepeilin@google.com, harry.yoo@oracle.com, 
	linux-mm@kvack.org
Subject: Re: [PATCH bpf] bpf: Replace bpf_map_kmalloc_node() with
 kmalloc_nolock() to allocate bpf_async_cb structures.
Message-ID: <ts7ewzhspasn2n3gfpscqpvhhzeod7cv6nml4g457ytzgojbek@gd5vts6hpdjf>
References: <20251014212541.67930-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014212541.67930-1-alexei.starovoitov@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6D4164000D
X-Stat-Signature: twt8a6nee7qx1mzho84rmjngzqo6ax3s
X-Rspam-User: 
X-HE-Tag: 1760482638-647292
X-HE-Meta: U2FsdGVkX19k1kmRM5YXs4OdicX0+du+3DZWKe3iJQk7udyAGM+AlH7a0FWDgxL0J3wE51w3i4nDHEDT6+oiO07lCw6FSsbblpcbJVdmUv1LEez7K6qtCcGOP+L51sdGc+7Kv9LhbQ1Vcew5upwOxLLEc26q5sU9N+8VKsLy9kvbipXbXjRE0gRDnBDoF0D/ZuiyRGgH9c4sAJu6myz8koXOuc8A0Hff6N21YQ4YV9TKza6c8vO5YUlpbv/AWxnYDnNRtqM0WpuOcJlBCrMZiDTIph7Duc0jaJDzP602bIE2m6ngdCuq/4YhemWUzLm8RA0auMzmwAVHxS+lgemQ1P9+QlP+AgIxtoRB30OKvvd0a8LJPct5iKv521s7Nqb2rVLiDtpfW6nIyqc9twv+lHofD5p/8eaoIiiN1K7V8h7HXqdU1sqzCAOtMc2OCN82oLXzXzEtqlIvTbDmvu2CrmWNtfN3xK6KkrMSmm0FJLgQnTL9T0k/cN/zoBpwsldmFFv11mciLMBJKAFJLUnvapOrAFqdaJyrdzwmxjjfGsfPk1yTuRoByKVx+FAlg/ikc7TGAzapnzjEmX6MMbXLDq3qvJovGYDoDYKc3F5JDXDdiMAyVwfNpx46K3j9eldEuFFDyFF1kigyXj7McUeGgWKFb9nsVmZLvXw4CdVNtuEyJ3T6LUTKIKKcyCkbn134w/Pmtg6VZYRyq6X3VpM4clQFOt6F8EP186skbBVPCuc0nWKiWVjNZChudtAUGYjCBYti38zxzeo6BgASzYSLWLQa1KHxZFTrtPlwmeIoD/Konj35epOISa13Lld7yAS+abEjyaphrXmMo0FF38iJ7eFKtileBU1EpIgYKMVVUO1RMkNe6yu4iZwcOAygkzfASWTLWXGKOIy3FiWkuQ17w+1zb4NbQS9Zx/yyamdEhiRU96ul7ixZ/pQo44AnKXuA2AXPMbc9MbWd6mnM9E0
 VXocUxJD
 hNgRcVZPMTube5g+xeMWy+NsWQqMnQuQTFuwp0eBAqEpmnnVGwlDuF0Vnkivno7mRvOkE+yP4PKelyuK2BBUtmZwLOc+sbkGDFFiJ1DlsmKLmrwByPY2RpEYO/mzQedxRv1hGSzUDmcGo1f+GJLfqAHLioH9pXB45cQNSNbBY2OplY7DagQ89TGHivBRERdgTMWJzosFGIhhmnJkAA9qHfUerH+FVTC1RsGi+EYeRMAaT257IsexLESabmNwvhqLVwQFFLASgJtpoV5sADPhGcCrx+VJG/tYMNIzh+Rw5wOKpir/cRBEjXKnSewgiVVr/MQQlj18zzuPC2bCVd9rgQawGJj2PHNM5lpe3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 02:25:41PM -0700, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> The following kmemleak splat:
> [    8.105530] kmemleak: Trying to color unknown object at 0xff11000100e918c0 as Black
> [    8.106521] Call Trace:
> [    8.106521]  <TASK>
> [    8.106521]  dump_stack_lvl+0x4b/0x70
> [    8.106521]  kvfree_call_rcu+0xcb/0x3b0
> [    8.106521]  ? hrtimer_cancel+0x21/0x40
> [    8.106521]  bpf_obj_free_fields+0x193/0x200
> [    8.106521]  htab_map_update_elem+0x29c/0x410
> [    8.106521]  bpf_prog_cfc8cd0f42c04044_overwrite_cb+0x47/0x4b
> [    8.106521]  bpf_prog_8c30cd7c4db2e963_overwrite_timer+0x65/0x86
> [    8.106521]  bpf_prog_test_run_syscall+0xe1/0x2a0
> 
> happens due to the combination of features and fixes, but mainly due to
> commit 6d78b4473cdb ("bpf: Tell memcg to use allow_spinning=false path in bpf_timer_init()")
> It's using __GFP_HIGH, which instructs slub/kmemleak internals to skip
> kmemleak_alloc_recursive() on allocation, so subsequent kfree_rcu()->
> kvfree_call_rcu()->kmemleak_ignore() complains with the above splat.
> 
> To fix this imbalance, replace bpf_map_kmalloc_node() with
> kmalloc_nolock() and kfree_rcu() with call_rcu() + kfree_nolock() to
> make sure that the objects allocated with kmalloc_nolock() are freed
> with kfree_nolock() rather than the implicit kfree() that kfree_rcu()
> uses internally.
> 
> Note, the kmalloc_nolock() happens under bpf_spin_lock_irqsave(), so
> it will always fail in PREEMPT_RT. This is not an issue at the moment,
> since bpf_timers are disabled in PREEMPT_RT. In the future
> bpf_spin_lock will be replaced with state machine similar to
> bpf_task_work.
> 
> Fixes: 6d78b4473cdb ("bpf: Tell memcg to use allow_spinning=false path in bpf_timer_init()")
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

