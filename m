Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A781606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 08:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kagG1h6z
Received: by kanga.kvack.org (Postfix)
	id A04916B05B4; Wed,  4 Nov 2026 03:01:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98F056B05B5; Wed,  4 Nov 2026 03:01:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 855656B05B6; Wed,  4 Nov 2026 03:01:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 549756B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:01:36 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C7B97C067C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:01:35 +0000 (UTC)
X-FDA: 85396692150.01.FEBD395
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id F077A14000E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:01:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kagG1h6z;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793779292;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wa/ewEmctxMMXXGhA3e9lx/vbjeDwynsInRuu9Mp/6c=;
	b=M9MhYhBncFBxrCJFdgOHZijYsEhJLG3FN5xhaivPVqWuby0etFrFaqmrHSavSUOagujXPQ
	faYb9sSaIf3i5OqMa8wGP9XtoRik3HtjKOFJFauNm+OZJQCvKTIz92f1cO17kmEK/nqg6k
	MNWnaHCqLd0nKO8/hMrttvRmAI1Z26I=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kagG1h6z;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793779292;
	b=Y3Yr3qahwVpDCb2Yv7MLPLMJNpsjJqGrDD9XOZVYI7XwHyi8aE8ZzjDEiYNYrTqasN28W+
	Y8BxIZC09ZR2EUUz3Vj2UD92mWLt2j6Mlg0z7r02OiYVIRyQSUBQgV2d/O9wjy2XsjejzJ
	9bCjiJ8oKnP+0fOCSkChv1ob3cy/qOI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A5B960D9F;
	Wed,  4 Nov 2026 08:01:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4DC71F000C1;
	Wed,  4 Nov 2026 08:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793779291;
	bh=Wa/ewEmctxMMXXGhA3e9lx/vbjeDwynsInRuu9Mp/6c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kagG1h6z6tj+6oKwe/08vbku+kP00JrPRr8x2BS4YBc4lA9lCPFPGOn30s4FFlGOd
	 XnsgjFmwKoCQP9pZ5a18Jur3TtRX/+Tpk0so8yE+sLvtoywnphPweaQKmXcWNEx+Mz
	 hB8XEMccTXNnA6dQ/GlHWEP5wwznhW+jGwVMlLJa5X+llaw8NrZh7/RSSWhtqkldEW
	 XT06o104rAQrdhkRmmdwd3iRrdNKOymHz923ruNKSC0184TPQjOgrd7FRjYknCWmoN
	 DYxb5uhDVwHgspyQgBQUQQTxgTzpiRJCWQwYK4l5lVYC53lOVZ5ZirELFuXf4pqjd8
	 MO+3l/6liLaSQ==
Message-ID: <sashiko-outbox-196846@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/6] kthread: Keep unbound kthreads off nohz_full CPUs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Matthew Ruffell" <matthew.ruffell@canonical.com>, "Waiman Long" <longman@redhat.com>, "Frederic
 Weisbecker" <frederic@kernel.org>, "Tejun Heo" <tj@kernel.org>, "Peter
 Zijlstra" <peterz@infradead.org>, "Ingo Molnar" <mingo@redhat.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>
Cc: "Caron Wills" <caron.wills@pulsar.com>, "Ridong Chen" <ridong.chen@linux.dev>, "Johannes
 Weiner" <hannes@cmpxchg.org>, =?utf-8?b?TWljaGFsIEtvdXRuw70=?= <mkoutny@suse.com>, "Juri
 Lelli" <juri.lelli@redhat.com>, "Vincent Guittot" <vincent.guittot@linaro.org>, "Dietmar
 Eggemann" <dietmar.eggemann@arm.com>, "Steven Rostedt" <rostedt@goodmis.org>, "Ben
 Segall" <bsegall@google.com>, "Mel Gorman" <mgorman@suse.de>, "Valentin
 Schneider" <vschneid@redhat.com>, "K Prateek Nayak" <kprateek.nayak@amd.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Jann
 Horn" <jannh@google.com>, "Pedro Falcato" <pfalcato@suse.de>, linux-mm@kvack.org, "Jay
 Vosburgh" <jay.vosburgh@canonical.com>
In-Reply-To: <20261103075940.110308-3-matthew.ruffell@canonical.com>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com>
 <20261103075940.110308-3-matthew.ruffell@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 08:01:29 +0000
X-Stat-Signature: 8tfbgxz5my9mf64dzqzanj676xiwbx7d
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: F077A14000E
X-HE-Tag: 1793779291-830833
X-HE-Meta: U2FsdGVkX19Vrbs+qWdmplpigf68JIxc1blEWBJSmOgXen5dj0yAzR0lD5C5UO2Nm5yaDvSBX3jWXf7uUmpLAYFoHveK9Nh5LQTvcqtEJ4FoB4y+hbf6rBqtb57AgvdLG8U0DJAy/cMKS3JUTZSq9Le54DS2PkcMT99BfnQEnWg3QbJqdEOl7By/fnvnnKIeJ3+LS87i5T2ST0zfEysNe7XucDS8t/SwXREWHEQkHbYPVsmZa2jpZnef8KB7QhmUcEvtTrVgDjMLzadZNzkwgCMy1Wk5S5fLUjVH9YJeUl5ovf/KAJyzZzb3rXZIS7q2u1jN9eugCSFcXx5HWeaBcP3Zu9MPwrFLKJ5CTlWRjXYNLPPtSxHnrJitdY0/CljEQXfu4/7P0JD893ZRH2zY2WVxJb9IPob1XIVvlLAg4GnNcewgoir774GlN8koMMSDKvlLj6sbdcfpdBdt78P4a0I02CguOJ+oDVkTX1KRfrLoXoRhYevt15e/1v7BWNMcGauAp5qQFIMFvEc8/KJNnhfxyv+iBzs2VDfl/v1kbZywOkWeVLesYBgGU8VZVrJN95X9YVAQs7t3uZ6I152pBKLc7c/JXMMHuXddUCsq0Xnm4i1W84NmxQaWIrPf+GwjAiwgdGoLJ4La36S3EQCmOFgp8fIHu+6i/f9FlS9cXKmBUgaLljz0ykVuGyp/JVRQsg+5zebOo7kdND1USJKRpegv2O/BcEsxsI2LbvphhY2rjXWoTUk4qCVW8pl5uGuKdDJM1wwVipL9zS093OnGPQ3cUzw2tiCtdt733qNBRrmS5R+NyKPF6r65A11RgFxaOtU6Z0ZfpEEGL2dSAOtZpulVMNNphnVCCkfnmk33ydD7IsL6WTtD1frMiW6IQshRQ1ZuDWf76Lf2J4+xlMcXbQIUqvirbP36dLS9QE/h3NDNSdZ8oW2sG7u3/8bGvu6oSvlQ0qJLK3w7Ra6+/Vk
 U7Z2X1JY
 ttk58BEr4z7l/Wr8qF0rT5Dk8hvkssp/KPh4q7qvxCtlV3tqnFQjYs6VUB4eAdYZoWkqAWv4LkOrLTKJT3tbYhhXu/WSU8zvmxVw1ZKBAy+vOuqsiRRCOHjtPW5h3N2Y0e6ofOD0vVNinmkbiYVz1oggFmZ8tOXnZT/0qobE1YqIub6jpqrmBDVpA8+LLcQfMBgtrMgcRXFYZ5x5CVNNeLVO5qL4PcO6DZ/KLXPiH7Sl8yg7EEKO2p0Z8yRyCLrgeKoipTn14E410APN7jJLpg15hIou2Evl3alg/R8yWRGycbnMz6IbLU3aqM84kPCq8jRhh/Ri7V63hmGQUfvDtZIIjMUSc7zM6WMzRzNnaQK6PF3FDEWynYMlhK2SMRiK4kEL8C8BVVH+zE+YhsqzeEMe4b7iXsG9zfjoViD+APGGcYQ2jbTbqqfeQOTSFbYyviPOB/Cq2OhFtcQLdbr3OBABdiW0ziSdinMfC+k22kz7QkLCqw8ECbtiBB/qViVK+1w6d/ShkaJykHlItAtwkWx3T5HJtY21/5juKCxyAYWaqT7pssQsUnZv7gh8R8X/mSNgZ+493W4z3yQdQvM5RPFf+QnRxPIi9lsR2w/nOiu4f17i3VCkDfLqxQUiNOMT0aowoFK9snlZWOcyafFmxYgFISEMOyCkS8K0gqj0GyOYkAz8iAtHxUr28U5kRgZQXro98LB+O2FTQlvmZX7nyoQJ1rGgofWGyPc/2ZT9v1fz7mq2P5eVrpQ5n9dB/BtBUuhoB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] kthread: offline preferred CPUs bypass hk_kthread in kthread_fetch=
_affinity()
--

commit e454a827bc8a9ce4259c7edb902592efbf81ab53
Author: Caron Wills <caron.wills@pulsar.com>

kthread: Keep unbound kthreads off nohz_full CPUs

This commit intersects unbound kthread affinity with both HK_TYPE_DOMAIN and
HK_TYPE_KERNEL_NOISE in kthread_fetch_affinity() so that unbound kthreads a=
re
kept off nohz_full CPUs even when those CPUs remain in scheduler domains.

Link: https://bugs.launchpad.net/bugs/2165410

> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index fdb8fb07f40bd..b9d8dfe1b6cad 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -327,24 +327,46 @@ void __noreturn kthread_complete_and_exit(struct co=
mpletion *comp, long code)
>  }
>  EXPORT_SYMBOL(kthread_complete_and_exit);
> =20
> +/*
> + * Unbound kthreads must run neither on domain isolated CPUs (isolcpus=
=3Ddomain,
> + * cpuset isolated partitions) nor on CPUs isolated from kernel noise
> + * (nohz_full=3D, isolcpus=3Dnohz). The two sets usually coincide, but t=
he kernel
> + * accepts nohz_full CPUs that remain in the scheduler domains, so both
> + * housekeeping types have to be honoured.
> + */
>  static void kthread_fetch_affinity(struct kthread *kthread, struct cpuma=
sk *cpumask)
>  {
> -	const struct cpumask *pref;
> +	const struct cpumask *pref, *hk_domain, *hk_kthread;
> =20
>  	guard(rcu)();
> =20
> +	hk_domain =3D housekeeping_cpumask(HK_TYPE_DOMAIN);
> +	/*
> +	 * Deliberately not HK_TYPE_KTHREAD: since v7.1 that is an alias of
> +	 * HK_TYPE_DOMAIN (commit 8f78b749f3da), which is the very assumption
> +	 * being corrected here.
> +	 */
> +	hk_kthread =3D housekeeping_cpumask(HK_TYPE_KERNEL_NOISE);
> +
>  	if (kthread->preferred_affinity) {
>  		pref =3D kthread->preferred_affinity;
>  	} else {
>  		if (kthread->node =3D=3D NUMA_NO_NODE)
> -			pref =3D housekeeping_cpumask(HK_TYPE_DOMAIN);
> +			pref =3D hk_domain;
>  		else
>  			pref =3D cpumask_of_node(kthread->node);
>  	}
> =20
> -	cpumask_and(cpumask, pref, housekeeping_cpumask(HK_TYPE_DOMAIN));
> +	cpumask_and(cpumask, pref, hk_domain);
> +	cpumask_and(cpumask, cpumask, hk_kthread);
> +	if (cpumask_empty(cpumask))
> +		cpumask_and(cpumask, hk_domain, hk_kthread);
> +	/*
> +	 * Both the boot parameters and cpuset guarantee that at least one
> +	 * CPU stays housekeeping for every type, but don't rely on it.
> +	 */
>  	if (!cpumask_intersects(cpumask, cpu_online_mask))
> -		cpumask_copy(cpumask, housekeeping_cpumask(HK_TYPE_DOMAIN));
> +		cpumask_copy(cpumask, hk_domain);

[Severity: High]
What happens in kthread_fetch_affinity() when the intersection of pref,
hk_domain, and hk_kthread is non-empty, but contains only offline CPUs?

Commit 78ff77ded78f ("kthread: Fall back when no preferred housekeeping CPU
is online") replaced cpumask_empty(cpumask) with
!cpumask_intersects(cpumask, cpu_online_mask) because preferred_affinity can
contain possible CPUs that are offline. For example, rcu_thread_affine_rnp()
populates preferred_affinity with all possible CPUs of the leaf rcu_node:

kernel/rcu/tree.c:rcu_thread_affine_rnp() {
	...
	for_each_leaf_node_possible_cpu(rnp, cpu)
		cpumask_set_cpu(cpu, affinity);

	kthread_affine_preferred(t, affinity);
	...
}

If a leaf rcu_node has online CPUs that are all in nohz_full, plus offline
possible CPUs that were not listed in nohz_full=3D, or if the preferred
housekeeping CPUs are later hot-unplugged, then pref & hk_domain & hk_kthre=
ad
will contain only those offline CPUs.

In that case:
1. cpumask_empty(cpumask) is false, so the fallback to
   cpumask_and(cpumask, hk_domain, hk_kthread) is skipped.
2. !cpumask_intersects(cpumask, cpu_online_mask) is true, so cpumask is
   overwritten with hk_domain.

On systems where nohz_full CPUs remain in HK_TYPE_DOMAIN, wouldn't this
bypass hk_kthread and allow the kthread to be affined to nohz_full CPUs even
when online CPUs in hk_domain & hk_kthread exist elsewhere on the system?

Should the first fallback check !cpumask_intersects(cpumask, cpu_online_mas=
k)
instead of cpumask_empty(cpumask)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103075940.1103=
08-1-matthew.ruffell@canonical.com?part=3D2

