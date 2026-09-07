Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A243C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:31:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CE046B00A2; Mon,  7 Sep 2026 04:31:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A5636B00A3; Mon,  7 Sep 2026 04:31:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E2EC6B00A4; Mon,  7 Sep 2026 04:31:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED4D06B00A2
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:31:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5C91F16070F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:31:03 +0000 (UTC)
X-FDA: 85186296006.20.E86CA7D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id A18C814000C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:31:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CDdbDc9x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788769861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C3Qj5aYZdoYUGz5K6Ve4x0QUot1tBZloGgZLRhBtw34=;
	b=xIpiYP+YsMAa+a51uEznIZvoiswh/dVCtsX5QBb2WmAvrzbOu7BXgHw8WFqTLZznyc/Sxe
	OVCTKBIQZk2HGLOHbGlO+nESYcEmEXzvXhblmu5nZOgqSwBsxxBYrYeLhTph7y8neRJyRv
	G6zpeZgQ+VtK4ZUAtYXoRpKv3tcKQjw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CDdbDc9x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788769861;
	b=Ks537B2PVCXcBemhjPkU7pQ2yVQ5gVVOTo8E69rD9shEpNVRz45CZ1ADi7tW4L9/B+jXJk
	5PIewtt+T3pQIP324MOrGt/h/FNEaoc/07N6mmaDpua1EBkRSCawi1wz3A5C8Oa9szTt/Z
	ym4U1WSjwcnCD/A+VRsfzsu080YAshk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E40960052;
	Mon,  7 Sep 2026 08:31:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98A01F00A3A;
	Mon,  7 Sep 2026 08:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788769860;
	bh=C3Qj5aYZdoYUGz5K6Ve4x0QUot1tBZloGgZLRhBtw34=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CDdbDc9xHCMS30v5MjFDnxUKCRYcq4sLDVR7heIyRnV3dVUWiz3jSR21p2tC8tLY0
	 a5ppuV7Oq3pqn1sm26nImkiVnwzWnY4nIQpm5AtJmpDSLfdRBixMkHYcZYNNP+KKIb
	 V+8S6YT+pI9Ac75JoyFDjT5kVsmPyq3bHmp0UAu48vzyqptOu/DDxVdfhBdKPZMXxt
	 LiYaNk1vnoX3Zi8LMh3SGY/hQ7VNY8eF5BGTFWspXDc9TtjKf6v0/YhUdmqpfrdnNY
	 bLDNFrftjN8cE6OpOzzSLk//d9oDXTHlaIIWcd08zyic+FHuWNK9TPoDFmcRsKANU2
	 WIu8oYXSV7NUA==
Date: Mon, 7 Sep 2026 09:30:44 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Oleg Nesterov <oleg@redhat.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Marco Elver <elver@google.com>, Ye Liu <liuye@kylinos.cn>, 
	Tejun Heo <tj@kernel.org>, Christian Brauner <brauner@kernel.org>, 
	Bart Van Assche <bvanassche@acm.org>, Yi Tao <escape@linux.alibaba.com>, 
	Michal Hocko <mhocko@suse.com>, paulmck@kernel.org, mingo@redhat.com, rostedt@goodmis.org, 
	jpoimboe@kernel.org, mic@digikod.net, tglx@kernel.org, akpm@linux-foundation.org, 
	david@kernel.org, linmiaohe@huawei.com, nao.horiguchi@gmail.com, rafael@kernel.org, 
	gnoack3000@gmail.com, sj@kernel.org, rientjes@google.com, shakeel.butt@linux.dev, 
	xu.xin16@zte.com.cn, chengming.zhou@linux.dev, will@kernel.org, boqun@kernel.org, 
	frederic@kernel.org, neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com, 
	josh@joshtriplett.org, urezki@gmail.com, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, tony.luck@intel.com, reinette.chatre@intel.com, x86@kernel.org, 
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, pavel@kernel.org, 
	lance.yang@linux.dev, mhiramat@kernel.org, pmladek@suse.com, longman@redhat.com, 
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com, qiang.zhang@linux.dev, 
	dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, 
	kprateek.nayak@amd.com, mark.rutland@arm.com, Dave.Martin@arm.com, james.morse@arm.com, 
	babu.moger@amd.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-pm@vger.kernel.org, rcu@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 1/8] sched: introduce for_each_process_rculock and
 for_each_thread_rculock
Message-ID: <ap51Mj0cqvAYb31k@gremlin>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
 <20260907081334.1152889-2-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907081334.1152889-2-ye.liu@linux.dev>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A18C814000C
X-Stat-Signature: hwcjsfpy5jxuy66q1u6fyi67rdiazhbh
X-Rspam-User: 
X-HE-Tag: 1788769861-842141
X-HE-Meta: U2FsdGVkX19DRqgBATLWqS+hnkUBaFGPujqGaF4+1l5Lsj1aTC7Uoy5Ou+w9Rw9VN6AqcqlD4lerhDA0nhZ36cflHFz8eaq8ds2s3oViNzOm+8VF4hFiTIWQIdHZ4mHRCti/UcJSEVDenAxrCYb1krbsep/nAHvngEydPczSG3S/fz06Z5Ke6yx/wdQd69oH9v40rzpgJ4KwLNZgZYl1ju6x9CxQ+m/nWn4o0RNi4QznhVH/P3nDYAnRugD9e+OzAaMj0SEL4HHa8xnSL/R5sHkZUt3z+bAS5z0RlF0+cbW1q06qrpK/kB57NzBAFY2EIF9V+j3QKV3ILDSUyJHb4ujjs6IHFOXLdA1EPEAxfkKi+kKsmiM6nbz4KA2age49G+LUpgOEUAAPkYmNIZIUu4v0VYpI2zG5oXFcfqaZ1PfCbJkHWtrdc1Nfaiu7rozqwHvbyCgDBTfkKsYluDN2vmKGh4lQInQ+F18zs5VYF6eeEZwXhcb70FW35WJ2nAdKbAWTYCzQdIjtgt5zgjND43ygiYCQ1w5FAIgWbRNlnWVh9kjo7mehiEyNcVZKEp4W5fJ3bWV56qLCARy6Sl4GCgdpD/Gi8MfA0w9mOlJtrrRQ/OkL3geMwYutPeFiSsc+SfP72j9eh1keaWGSL2koGL2vdE6Zxd98IEl8xz2HhQcyt0b59XYrXRIh2fl+JKtaWilpWk9Iw1x6MnUtuwAA5QSFpsatn27q2nMMWktIKLxYOVnD2C/Yv3DP0csxpo+NCEld0oZn3x8SbS1z3gwad27IqegFqWyIsVN6hKDzSvTk7cTCutqGllPvh8rl4NzyOs938FoI2rio1c5m1OUjOCueU74jBbFi9vFAx3RvUQAdEWVIbx6kM4/J+QkbBzZNnyL1Ild39wICWhU4UX+B9cirUhJlnj/E9UIA4DF7lFKBT6v8BljyB+bHDXbsJSiksuX1k61t5Oaq2t6mCX7
 jJwaiSPj
 Yha0DU+rgazLw247nDXv54/Pq02uk7mXAecsWZaw8iHjwb/0PlNfZHgPpRxnIUNTN+B9etH18AM3SPfNpW3nTQzvrJL2edv8D9F+IYXKPJja5Ngk9ETN1y7mfIjKNuf27+SJcKXeJgg9AKxTA9OoAw/psy7B1BCBRWR1YnzpIPIvB8heSZCW4M1FI2c5ZXcm4YHKa9D92Fcl9+Hr3iA/PNdZ+NAlkUA8TTd4VHxyz/CmCR5WNsFcuaMTDJpv15IhM6WMIkHSS1DS9LXmD2SZ5hTe5FF77+r07RqZd23nCJSEEacx2X8TRieU+WQYwVcCkio8VHjHRKeTCQRIrFGeCgL6bXCxylQh7fVC5emknqeNXk+nGSUTcfJGhqbFg00HB8BVr6gBTlIuq30x99Cwp3zppjjfC9H7kbcXItC6tO5prsME8tPq6cxcjHB6CC+xM4ohFXUOibazX23U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 04:13:27PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
>
> Introduce for_each_process_rculock(), for_each_thread_rculock() and
> for_each_process_thread_rculock() macros that acquire the RCU read
> lock before the iteration starts and release it when the loop is left,
> so that the RCU read-side critical section is scoped to the loop body
> instead of an externally managed rcu_read_lock()/rcu_read_unlock()
> pair.
>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Acked-by: Michal Hocko <mhocko@suse.com>

Some nits below, with those addressed, LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> Changes in v2:
>   - Rename macros from *_rcu to *_rculock (Steven Rostedt, Thomas Gleixner)
>   - Improve comment on for_each_process_thread_rculock() double loop
>   - Change prefix from mm: to sched: (Michal Hocko)
>  include/linux/sched/signal.h | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>
> diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
> index 584ae88b435e..110ea9f131f3 100644
> --- a/include/linux/sched/signal.h
> +++ b/include/linux/sched/signal.h
> @@ -2,6 +2,7 @@
>  #ifndef _LINUX_SCHED_SIGNAL_H
>  #define _LINUX_SCHED_SIGNAL_H
>
> +#include <linux/cleanup.h>
>  #include <linux/rculist.h>
>  #include <linux/signal.h>
>  #include <linux/sched.h>
> @@ -663,6 +664,30 @@ extern bool current_is_single_threaded(void);
>  #define for_each_process_thread(p, t)	\
>  	for_each_process(p) for_each_thread(p, t)
>
> +/*
> + * Variants of for_each_process(), for_each_thread() and
> + * for_each_process_thread() that automatically acquire and release the
> + * RCU read lock via scoped_guard(rcu).  The lock is held for the
> + * duration of the loop and released on exit, including via break,
> + * goto, or return.
> + */
> +#define for_each_process_rculock(p) \
> +	scoped_guard(rcu) \
> +	for (p = &init_task ; (p = next_task(p)) != &init_task ; )

NIT: Can you indent the for loop by a tab? Since the for is in
scoped_guard() scope and that's not made clear.

> +
> +#define for_each_thread_rculock(p, t) \
> +	scoped_guard(rcu) \
> +	__for_each_thread((p)->signal, t)

Same comment as above.

> +
> +/*
> + * Double loop: 'break' only exits the inner for_each_thread() loop.
> + * Use 'goto' to exit both loops; the RCU read lock is released
> + * automatically when the scoped_guard scope is left.
> + */
> +#define for_each_process_thread_rculock(p, t) \
> +	scoped_guard(rcu) \
> +	for_each_process(p) for_each_thread(p, t)

Yeah this is even worse for clarity :) I know the existing defines do itg
this way but it's kinda confusing.

I know it's a bit fugly, but it's MUCH clearer as:

	#define for_each_process_thread_rculock(p, t) \
		scoped_guard(rcu) \
			for_each_process(p) \
				for_each_thread(p, t)

> +
>  typedef int (*proc_visitor)(struct task_struct *p, void *data);
>  void walk_process_tree(struct task_struct *top, proc_visitor, void *);
>
> --
> 2.25.1
>

--
Cheers, Lorenzo

