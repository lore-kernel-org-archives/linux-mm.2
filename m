Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 431BD606A329
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 02:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HZ8G9hjc
Received: by kanga.kvack.org (Postfix)
	id 475EA6B05B3; Tue,  3 Nov 2026 21:49:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44E516B05B4; Tue,  3 Nov 2026 21:49:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38AAD6B05B8; Tue,  3 Nov 2026 21:49:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 019106B05B3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:49:26 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6B6C31A0623
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:49:26 +0000 (UTC)
X-FDA: 85395905532.09.CA025DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id D8CC680004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:49:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HZ8G9hjc;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793760564;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=olZhh7KhDNcSAx3uv+MHZHd+XJ6Y2NBJSt9S/teet50=;
	b=GBqlR3bHcNHihCiHwC+AZh+GUkMf1xHIDz+urm7+wtk4QQXm2Cy2yfZCZt+QKJVVbg+sl0
	anOwvLBYO2hmMpc9V2PyyOZqohSdO/96b+UNUejFexPF43nTC2jHBRUvYWQB6oMbJgMoFu
	3Z4kniflwv6pT9v7XO8gE4ETvGw7nVo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793760564;
	b=3XPEp6gaTlHFNvyodIqvdJW2SPt+gdb+viCoKtDLVygjTVskaj4SPk4q+HZCd00skKdi22
	/LdgHALYYa1u8z645atv0oO+vYg67hdPqJmwGXq6H6tmEBXn6xw08CqwQ1yvKZ9JG+KUmp
	56JCqINDjOrhEtSEIKmw94KWSG7YCm8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HZ8G9hjc;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E9DCF601F6;
	Wed,  4 Nov 2026 02:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B808A1F0093A;
	Wed,  4 Nov 2026 02:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793760563;
	bh=olZhh7KhDNcSAx3uv+MHZHd+XJ6Y2NBJSt9S/teet50=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HZ8G9hjcgEzXEhEtYdEVwDvslVTaFOYV5Oq5m8pOGhHflRTfEc2aXUQxJFrBuJAEi
	 Vg0TRUfMJSUm/VENKMD+ntt2lq4xE8rBMYRqNIl7fqIUBKTGZAu4lYGHFt5VTY1WRW
	 6ZLok5vXty+/5BJNnQuWVjIE1XoP1DQIqmkP2j6afJoNsUNLiyyVCe8DLYS+h4MVso
	 S9Mm2OAiQi8ZQuvIGgV44tfmZx8a4+zmdfb9xeldE5qYV/fjx6U708SN6q56zLSatu
	 aRbMJEnIeGkwHcajAbIrbrN6vKQ9JQH4yLF5bzwRMvfgGSUKIBiEkbGV7EOE5uGXzX
	 B+VduoxsiIQ0w==
Message-ID: <sashiko-outbox-196526@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 3/5] timers: Avoid blocking on hrtimer_cpu_base
 lock during Oops or panic
Reply-To: sashiko-reviews@lists.linux.dev
To: "Aaron Tomlin" <atomlin@atomlin.com>, pmladek@suse.com, john.ogness@linutronix.de, rostedt@goodmis.org, senozhatsky@chromium.org, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, akpm@linux-foundation.org, baoquan.he@linux.dev, rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, ruirui.yang@linux.dev, david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, kees@kernel.org, anna-maria@linutronix.de, frederic@kernel.org, tglx@kernel.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, bigeasy@linutronix.de, clrkwllms@kernel.org
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, linux-kernel@vger.kernel.org
In-Reply-To: <20261103024453.922373-4-atomlin@atomlin.com>
References: <20261103024453.922373-1-atomlin@atomlin.com>
 <20261103024453.922373-4-atomlin@atomlin.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 02:49:21 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: ink6etwi87kp7upayzfpi567a3355faz
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D8CC680004
X-Rspam-User: 
X-HE-Tag: 1793760564-383107
X-HE-Meta: U2FsdGVkX190x9jKycTJurDotFj3wk/d491BBrT9uuaHRnR9HTI/ORf3Z8m1i8ce+j8b55fuZ7bt4ZkJTOZXdT4ENOjASnnolYlfrrf3LSTLVqc2kuO8QX4JoO2wMMUh2H6LB28bF0rKh38BaZmrSMgQeM1E+TX/Q0GSyjVIgJ42IARhhbKaMkCD0ynU54jwWwhsoyQl9DcTEeiTsqPFaz9vhh/KS5zLWJ6f8z8NGbmJ0FciUN8rQN5aY0UmWWjMT+txxFaqPa/gUT6lglVDfJIU6+bilJEede0ZLfN7C0ZpE+C7yuUTceUKIgc5JM1oz1lJLNinpGfMGd42jFBQqTuqAAg77Mm0Aobv74w5PO1doMHieVHgw7Jk0n8tPT/mMy1GqfCwd2WErVodydUtkVjv3WVxFo6PZmJT5lmbfpvaAVKR2NR/KAA4d+Qw+E7+JnfumnLdnVlF+1CSX/OaZzpq6unFpV3hX25AxEZdF5tMIESKm1qBu6Dca9r4Be3pZtOyaqlf9wX4HBjlVhSLaDmvBTmVJeeCx9J30zbBcDcNXWVr83RgVzJ7JJYRvwhWUit/9jNVcVZ6dwrICP/WEEHXmYmb8OlTrA0wOiQd4xjIC7esSzvm9s3etl7g2AYH+dTQpLFGd2VBOgsATf2BseXjAjvoAernDj3+WTt4Jb5Uenjx72jv+1MzBUEvaOABEmPYHGqX2F6EQs6ezZXAv6Dz3qzfrqYQ4xGidzlP62qP/gbARK7yjLqG1YRwivIDUYUrosXESw+J2R//4XNiNYsqocM5jcbWNoX5OUpLL7V5NxGinqP1waqxttDse6lOqiqBBCEdgn7w/n+/vqOhrxhVTH2nkI/Bei/kY9OIUL41b/Rt/TjmYqX/j3+DbCZgj7fw4DOHLUNXfCZjE7dy52759MgJ87FWRovQ4zncHiFspFOt5oVdqpguKQJDnMFh+6ufzgOi3bydJSf4aQt
 wwBCeeab
 Vx3ZhHgKLcZQSXdmqNuAFgg+CVOj2lJL8X+GfokDhXHo6XtkEqmqPjXKyav/5Ptev3ZBMxALiQcdmEWMP/dBM+PveC6OWBYyOICmXmp+KLqA/zGtY/vhjlk5x8ef9zO5oYD2ytEii5Czm5jpIay6/TJMhbEZJFCL8gVFUG6W1jLoyZPzU2iItLrcoDtD7yiUg3stGCuHMrT5daXdvvs6d5T1AChfVlP4XDO8++vhV8PHTLlLkZ+2tPObWNEsUvmwbtEU6XMUl0Tb6OchOalwpvfmQu0pecFGQs58XEstHjI/5q+wVlk8H7TX3SjyCmJU6/HbrzIa9XhIy68hgp7FcRXKnH8MmZ84Fj3f549YsWda9gCbTrpCv+otvd6mABwpE80vq+0m5p+mVSn2FCgnneekGGXYEyX9bTiuSPvPLy+Y4yIWA4VbcnqLyGG53XOiMfkawfO/5ZRR7AGe0IIoxN0nGdxDBPGKDW7SKYz4ZxOjAT8MOTFO1m6XXKiT7e9fNOU6tZhF9iUk5iYQHI8UY0mSn9+IqwVEgrh0jLU5qAk/hmMzJfwIPcH0+MQvYZzkiudwnR50A8+VfIc0mLwH1QooD7HZ+FRzbEWw+qNao57EysFn5V5Y8Jui9zoIBkQp/lxeJJWMlOUrh/TD3mDRil3lzvPj7tgVrtHRSmm4hfnxBcShH86HLE376m/Ib/VAL7n02
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
- [High] timers: incomplete !CONFIG_SMP guard in print_active_timers()
--

commit 8e788faa0cf2d16ee117d7196f09432346eeda90
Author: Aaron Tomlin <atomlin@atomlin.com>

timers: Avoid blocking on hrtimer_cpu_base lock during Oops or panic

This commit switches sysrq_timer_list_show() to use ktime_get_mono_fast_ns()
and updates print_active_timers() to use raw_spin_trylock_irqsave() on
base->cpu_base->lock when in NMI, Oops, or panic contexts so that dumping
timer state does not deadlock if a CPU is holding a timekeeping or hrtimer
base lock.

> diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
> index 0406bf4488e9f..4973650c4ae5a 100644
> --- a/kernel/time/timer_list.c
> +++ b/kernel/time/timer_list.c
> @@ -68,7 +68,15 @@ static void print_active_timers(struct seq_file *m, st=
ruct hrtimer_clock_base *b
> =20
>  	touch_nmi_watchdog();
> =20
> -	raw_spin_lock_irqsave(&base->cpu_base->lock, flags);
> +	if (in_nmi() || oops_in_progress || panic_in_progress()) {
> +		if ((!IS_ENABLED(CONFIG_SMP) && in_nmi()) ||
> +		    !raw_spin_trylock_irqsave(&base->cpu_base->lock, flags)) {
> +			SEQ_printf(m, "  [cpu_base lock contended]\n");
> +			return;
> +		}
> +	} else {
> +		raw_spin_lock_irqsave(&base->cpu_base->lock, flags);
> +	}

[Severity: High]
In print_active_timers(), the outer check enters this branch when in_nmi(),
oops_in_progress, or panic_in_progress() is true, but the inner !CONFIG_SMP
check only tests in_nmi(). What happens on a !CONFIG_SMP build if an Oops or
panic occurs in non-NMI context while the CPU already holds
base->cpu_base->lock (for example, inside enqueue_hrtimer() or
__remove_hrtimer())?

When CONFIG_SMP=3Dn and CONFIG_DEBUG_SPINLOCK=3Dn, _raw_spin_trylock_irqsav=
e()
unconditionally returns 1:

include/linux/spinlock_api_up.h:_raw_spin_trylock_irqsave() {
	__LOCK_IRQSAVE(lock, *(flags));
	return 1;
}

Wouldn't that allow print_active_timers() to re-enter the critical section
and walk base->active while the timerqueue is in a partially modified state?

And when CONFIG_SMP=3Dn and CONFIG_DEBUG_SPINLOCK=3Dy, since vpanic() invok=
es
sys_info() before debug_locks_off():

kernel/panic.c:vpanic() {
	...
	sys_info(panic_print);

	kmsg_dump_desc(KMSG_DUMP_PANIC, buf);

	if (_crash_kexec_post_notifiers)
		__crash_kexec(NULL);

	console_unblank();

	debug_locks_off();
	...
}

wouldn't do_raw_spin_trylock() hit SPIN_BUG_ON(!ret, lock, "trylock failure
on UP") when base->cpu_base->lock is already held?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103024453.9223=
73-1-atomlin@atomlin.com?part=3D3

