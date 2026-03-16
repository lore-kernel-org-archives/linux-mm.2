Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95C96F4644B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 10:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD66C6B019B; Mon, 16 Mar 2026 06:55:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB8066B019E; Mon, 16 Mar 2026 06:55:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC48A6B01A0; Mon, 16 Mar 2026 06:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BCC346B019B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:55:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 64C79B6684
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:55:55 +0000 (UTC)
X-FDA: 84551621070.16.B7DE7E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8B95420007
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:55:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CWmLAlUN;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773658553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EOcjVyUODMS/mjcrbQaLeCBcIUGkq4oM3gLbEmarMwE=;
	b=6rnx2bC0IwfyfU5UzsMAheWHegRVNeL26WcLqmIBfZhrkQUlR9gjgyi5XFAbrc+xUfmScT
	MbBHq8oiJPJWV2ntgXRn7aGoQkWIRLIU5QsQ5Wkj/waMQ7Fkvjs7bVwrAJ0/+jzJEyn0RS
	1/djknUvagSvIk80U2H48qseE1JItWs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CWmLAlUN;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773658553; a=rsa-sha256;
	cv=none;
	b=r91UvCjnZJAhE2Eh1+tKLC67pJOfhBz8zRV6xPMhrxiR+aHipCKXaXjObK6x2q+MqOF6L6
	kMOem+0L0NN8qIvBlhUAY9fEOCeylB7CBmW4wJnNx1+JOTgvp0U1LiQiTunWSTlqToz/3A
	i8bBZa6IFtE3CYgqQdbICmcbkhFhSvY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4ED02418D8;
	Mon, 16 Mar 2026 10:55:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C0BC19421;
	Mon, 16 Mar 2026 10:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773658552;
	bh=yb1kqkOBmYZyBUxzt0kHkbIxIm7TwUuWujblsdUz+14=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=CWmLAlUNHBBVT9TCd3mSiD0hoD0s7euT8qchRJn3c4Z+98xVYOSucvQwauYWM4dbS
	 x9m9Tm9ytJ1jT3Bh8DB4hzttJTQgxlw3pD3EL7pJ1Oxy5iJc6zvT7AOCDnOzXBPQic
	 frIrzA0fkIrF44JyraGP5MPHOYVJaMab8/kRCTjLd4rq4IqOiBI93iF89rtkk7q3FQ
	 wShsJxxaG7pj/43y1i/bKqnT29XaOwJEqRNg6MoKUF3RG9oAxbfO+XwcUfkqk0/yjY
	 fncwEN7FF9BllzBe4gr06IzqmB1joyaKOf+Hu/qlqqex+4skYaA57RoKXtND6eG5sf
	 Rudie+7d5SIUg==
Message-ID: <2d3ff0fc-17a2-4425-b949-b5100251f98e@kernel.org>
Date: Mon, 16 Mar 2026 11:55:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [PATCH v2 2/5] Introducing qpw_lock() and per-cpu queue & flush
 work
To: Leonardo Bras <leobras.c@gmail.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>,
 Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>, Hyeonggon Yoo <42.hyeyoo@gmail.com>,
 Thomas Gleixner <tglx@linutronix.de>, Waiman Long <longman@redhat.com>,
 Boqun Feun <boqun.feng@gmail.com>, Frederic Weisbecker <frederic@kernel.org>
References: <20260302154945.143996316@redhat.com>
 <20260302155105.214878062@redhat.com>
 <26662caf-de09-4f13-b374-dc7f879b7829@kernel.org>
 <abbuWGMv4D_1ToKl@WindFlash>
Content-Language: en-US
In-Reply-To: <abbuWGMv4D_1ToKl@WindFlash>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8B95420007
X-Rspamd-Server: rspam08
X-Stat-Signature: 9nerrkbwws83rdjhxjfdijnwcxx8168z
X-HE-Tag: 1773658553-650116
X-HE-Meta: U2FsdGVkX19l3Mb3Jg/pNcv3Qo4XJCL6yHk8wOu7J/45IogNspV0Cd112RTejPw6l2UlP4Zrz7fL5qhXddw+umBPpSnK+WfH00f1GGxOjxip1NuNgmqqgYlZLRZQA0s8EkwRPIgIaWamQrDPDruG7a8N/tL8AzAvKtCeN4usrsQJECFkzQ1LyW7jhnSDy+QbTaNKb+oRA3ToT+fAFAuTasRTNr4xCrWNA5lDR06PFkY9TjA+vG6MDEI5XDg/3+oQbjr+p7ldk/yBvlTA7HjOfLqmPI9oUASElan4x+2tCLlI/V8rj2o59cRMV2asVlK8A9995PAQcod25FKiSDEt/bbe8Ep3veGdFeEZJgzeobERmwnNNpeRALw2DxESPAGtMMQxAJgjpAATNCL2fbCsLGoYPIQaQw9DkNLdfT0RA5IwBrhLWdiYt5POWF4Fscrwx24DKPu/vtKpUTEyoJOytZw21hfIIw3r2EUqUgWHWMuFy+RRUlQQPuvOEzLIvvfwjsH0J1aXlMTETDzedq4icnv66Nlda8LaefQtRF1iIv+bhzWZH/kMJzVnkAn9zCWYyPEuQWN7cL3rA7gkqcRSuvSDmSc1woDV6alad8rSeNREIRPWbtVy7eFJIIcGscFQUa1/eQrTlMi2v0onnUU1QTNr8okZ6ovwBXL6yTJp6qFIj7GmNLwRLoHYmpBPaR6guzH+2tOq8oM5msICM1xD0PSghLigz7x9GHKxs494TW6wdA4Eja7asWeC31CVTCKQHNi6di3/v2fzNcOTAB0lrrXqIqxEYtbCP8m1KG4znf3ztqeex/ccfkqu+Gmhf3WvXSeElFBSwo7CzRp+ae/qDHKR0jhY4BhAGj+nb6kn6uoxZybYBROp/+YfWooxdJ2Rrg8+znNHfy6pFUl1jOMleH5t1a8FYSC8LUptHrCTQy/0/rdrkhVv9PfbtVIOWmGj2hIi0Jw+37M/2Opobg4
 7qaDY6LZ
 EqaUQKYZ8am6VjA9OGe1GEPbRBKKvAYK0EKnDq5DPsrQiB4Yx7+tZ8XaB84LXT3ruz9bV9AQeKXL+VLCPKCctTzeZgDV8ClyDo7zyk7gH3LuL4UwnPZZC7N73ZSALe9yAli6oPpBOh50u2ncKTyv1H+QVxXXOd1ebBWLpJ8i+EfBO3pXhtiKfjz95j3zknuIJpW+SR/F3Q2nX88XxiDfVR+1G1HyD8oY1ERqMa7FG4ecBIKu3BlzqFPDgEVgpuSLy9xAlnK1lQ3aYKySfWY5syDm8LFduNhsM3LcO9W6m/1o16GOeLHcdyjyDZ7zSgEMBo9bahlaGwT6esQ6leVzIf6FuRJ3orCniq0E1T/j9KJJ9siEd2e8wz0CpnhNG1booc/Iq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/15/26 18:37, Leonardo Bras wrote:
> On Wed, Mar 11, 2026 at 08:58:05AM +0100, Vlastimil Babka (SUSE) wrote:
>> On 3/2/26 16:49, Marcelo Tosatti wrote:
>> > Index: linux/Documentation/admin-guide/kernel-parameters.txt
>> > ===================================================================
>> > --- linux.orig/Documentation/admin-guide/kernel-parameters.txt
>> > +++ linux/Documentation/admin-guide/kernel-parameters.txt
>> > @@ -2840,6 +2840,16 @@ Kernel parameters
>> >  
>> >  			The format of <cpu-list> is described above.
>> >  
>> > +	qpw=		[KNL,SMP] Select a behavior on per-CPU resource sharing
>> > +			and remote interference mechanism on a kernel built with
>> > +			CONFIG_QPW.
>> > +			Format: { "0" | "1" }
>> > +			0 - local_lock() + queue_work_on(remote_cpu)
>> > +			1 - spin_lock() for both local and remote operations
>> > +
>> > +			Selecting 1 may be interesting for systems that want
>> > +			to avoid interruption & context switches from IPIs.
>> Requiring a new boot option is always a nuissance. The cpu isolation is
>> AFAIK difficult enough to setup already. Could the default be that qpw will
>> auto-enable if there are isolated cpus configured? The option could still be
>> useful for overriding that automatic decision to both 0 and 1 for testing
>> etc, but not requried for the expected usecase?
> 
> 
> I think it's okay, as something like this?
> (should work for nohz_full and isolcpus)
> 
> ######
> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> index 81bc8b329ef17..6c9052c28e3e4 100644
> --- a/kernel/sched/isolation.c
> +++ b/kernel/sched/isolation.c
> @@ -170,20 +170,23 @@ static int __init housekeeping_setup(char *str, unsigned long flags)
>                 for_each_set_bit(type, &iter_flags, HK_TYPE_MAX)
>                         housekeeping_setup_type(type, housekeeping_staging);
>         }
>  
>         if ((flags & HK_FLAG_KERNEL_NOISE) && !(housekeeping.flags & HK_FLAG_KERNEL_NOISE))
>                 tick_nohz_full_setup(non_housekeeping_mask);
>  
>         housekeeping.flags |= flags;
>         err = 1;
>  
> +       if (IS_ENABLED(CONFIG_QPW_DEFAULT))
> +               qpw_setup("1");
> +
>  free_housekeeping_staging:
>         free_bootmem_cpumask_var(housekeeping_staging);
>  free_non_housekeeping_mask:
>         free_bootmem_cpumask_var(non_housekeeping_mask);
>  
>         return err;
>  }
> ######
> 
> We would only have to be sure that this runs before cmdline parses qpw=?, 

I'm not sure it's possible to achieve this ordering with __setup calls,
unless one of them is early, and then it might be too early to do the
necessary action.

> so user could disable qpw if wanted.
> 
> Would that work?

The pattern I'm familiar with is collecting all related params via
early_param() setting some variables, and then an init call (not tied to any
of the param) looks at those variables and does whatever is necessary.

> Thanks!
> Leo
> 
> 
> 


