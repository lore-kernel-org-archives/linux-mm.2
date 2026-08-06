Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5EFBC561E6
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:19:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F328B6B007B; Thu,  6 Aug 2026 04:19:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE39F6B0088; Thu,  6 Aug 2026 04:19:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD22A6B008A; Thu,  6 Aug 2026 04:19:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2E886B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:19:04 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C2E0806B0
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:19:04 +0000 (UTC)
X-FDA: 85070144208.15.425932A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8758EA000B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:19:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jxj+XeuI;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786004342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xeNkE8rvXnTrOW6dAnBoOw92sVzbfW8+wp078YwEXLU=;
	b=DNoDIkgra5cnGrS53CpLywcF68AKErwAo7menKeAJb7QJaZhSAaNfdQwk9QPM/F+aaYwWv
	OKdn3KgTrQqhngswVPfQ+ds/xF/wfVT7/7/rAvgr0wlfxibOiAKcvjuG5qB7UYfMyb1Imo
	HO2MjcGxm8bbjlQtCofC3+VajgbfHKQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786004342;
	b=7sVx6Xvfq09P21SrMleTLJJhFiGAulT04sUzWgTwG//OUSaK+U2CMKc7+7C36J0ne44u6a
	LV/+NbC6drq+T4TKXUV/TnUwW08rgqFEiQUl4He5SqbFAXV10iSf7+bKLbxX7Q4in3XdGl
	LTjBKsRkG4wzCEQyeNDzeRznn7DCZkc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jxj+XeuI;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D067260A64;
	Thu,  6 Aug 2026 08:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 404E81F000E9;
	Thu,  6 Aug 2026 08:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786004341;
	bh=xeNkE8rvXnTrOW6dAnBoOw92sVzbfW8+wp078YwEXLU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jxj+XeuID3gJ4D5SOPmz78UkxoOvbSBnifolHDf74H66tZlcT+7ePeDsOCaovs0qY
	 xWMU4VPU5bgOeBcbLgJIWuN8d4pfkDh1F320313bbA2/yiNpruvzobqX3oGYN7B/MX
	 e9G5mAEi2J5u3yq92GhK7KOs06W0Lmv4GMxJ0OcwWGkDxOzgvIHXlUvB3GS3ofjwbV
	 W3+roBpV9T0GPfDHSPMkLuTEPG78s0rqPf2js1l1GIBsX2+PDwM3zt/6JsQeI9pnR/
	 Kc/cbWRv5ySOTxgntd4+Fg1HMcf+7udAb8KcZ3L83warOQi+o3PMPyEnv+6HWdsixP
	 whYKT9DTyviAA==
Message-ID: <f8fc47c2-02a5-44b0-8860-ff8369144b78@kernel.org>
Date: Thu, 6 Aug 2026 10:18:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in khugepaged (3)
Content-Language: en-US
To: paulmck@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot+d2401aeb74cc84adba04@syzkaller.appspotmail.com>,
 hannes@cmpxchg.org, jackmanb@google.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mhocko@suse.com, surenb@google.com,
 syzkaller-bugs@googlegroups.com, ziy@nvidia.com
References: <6a727d6c.9511d2ce.1fc5b9.035e.GAE@google.com>
 <20260805122952.6ae38af69a0457779cb44359@linux-foundation.org>
 <d5771d33-d8f8-4fcf-911b-089e862042e5@paulmck-laptop>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <d5771d33-d8f8-4fcf-911b-089e862042e5@paulmck-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8758EA000B
X-Stat-Signature: fsh7mdkd6xo8e6mu1yrq9xwbqntzn9c6
X-Rspam-User: 
X-HE-Tag: 1786004342-700697
X-HE-Meta: U2FsdGVkX1/6htii63TPBFmFn0LMNAr+f/fyqZOmDcMce6PWt+WV4c1yCOSbGOyQ2YLD5C1Gf9noMySS3Q6fAAO7CTnKSQcizhyMWpEB8hGYa1tPYBiqfSF5z3ommvS0WpRvJk+3/AWGve4fcmAtFfIlJGgVSbyJGYw9xfkr7rXDfLnHX7zxztQ1ylE6kh/Q2dXWjXwqi6F5trJwjb0KEJdeAMinnMq50TB3XuIW/OX/TlfAb5MbuUibNebkFokxlBlCuOCkOU/+isHrWs8YPhWmd3/noS1q9sbkiPuG0LVU64DW5efvuuVczbMd9BzeUGJH6YFiGgmOt0ZPYLK7qI2SspXxKqSLQkrRGMwCcrMJtSYugUlOaNvKD9+rR5HoDpSu/DyBizgad8hfKgLO5FbUDB6SEYSTNzH78F1rIQ9zRZ4lpeoGJjWqy3Zy5VHHAAtKQZCK5pr8IlyOng1Ln3ngD2SarO4iuLLq8ItAmfBhtBaaYaXdYZc54CoymttOQErpnw24tUQgQSlAID/rhN1TikXxgIgq+4riF1nXNDIxtSKwuR4r9ZRAochaWhVw5xqehPj8xkkr13z76pxyjeaSRPO5HkPVgkM4FWGmXj0PyR2ANfl+WQ6Ml7C9l1tj9FbfwOUZu8L9qzCZ9TGbgFJA+Q79ko5qIDm3U8Bnc6xq956Y0OkvxJsgxzqqaOCUAb9OFoywh4iHh6fbU5Rzq6a8CyLKhMuoOESRqKbHLIIIAZ361yPMco8zDQiOzkXBB61TiRSftDRw72zV8AJAEkjuEcjBR0zmKxIiLIjl3Pz72GlteAflTLdiDnCga0mgFQ5jxeN+7A3aVJFmwDpCD7lI4T805L173Q4lnrckVkbm/IKPs8mwqCcxQPSm8BtpiJa8bTDNHbS2EQlJnB2t5nA/IkVZ29CZXjJN1zGdZKg10JO8hmOS25qvsM8SpNhM1gIz3NMgQwIYutNoU5R
 Z7C0IzgL
 ZJJlBPlwavZlsSbvKXJsZluGyIX7yZISTFlixWHXZtC0e2N0IfHHr6R8jpDNGsduaWDO0SXqms3EOjXHgYoOffNFSY8e0sFrxmLDn4dodrZ5yJEuj1TaJYqvLw8Dgt1Xy8j6MXgWP0NEHQ34XVlKQvObPqm4QLf4eYlkjhDQ2zhMUiQLtgyt+bh5A41O/PEMiYfc0QpW1admajkBvAlSiTVxRwnIuwdHGHmg8vcQ7a9LFCnEIsr7vGUl2l2/n3Re/Geo6Yp0dJwV5jvb3lfuyAYLii7qXB906ocE5+7UaFpVnRDtah1eTP2wRbBM3xYFdo7x9eKF7Pp05zjAF1by/2PP81WydtIvTz2akv2JYjCvVBd2E7wFdkZWCZtPJsEFlF+a9j32dPn3OnF7dOXiolCWRhm7iSGhrB5lILPKyMbKLbK11VMiglg5oW+WQY39/e9Kdj2/9ZWHU4QbgEpTPxnwT4/vns1MJ6Hc3aa6Cd9qKNYYtZU30P6s3Qr1+S37N5ny4KI2VzCYHK/fi/Yw2bqrN44YMiiQ/PSFQje40ReHLOz+TUHKOSfapRl3Mtj45CrzaK8B7ZpgDjVDBzcAE5+V8W513MgIoMOZA7B7SEmSxKg4h7LnHwavuwAEJXkApwQDurT4MTEhPdhqRnMkpTCWt8WnVB6c1Sk9Gsv9yYIkmBG0lCkJuFjJbkPLgcy0R20b4gslvUo7wTB9Vh/t6LZbu6HVbpOo/76+7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 22:28, Paul E. McKenney wrote:
> On Wed, Aug 05, 2026 at 12:29:52PM -0700, Andrew Morton wrote:
>> On Tue, 04 Aug 2026 17:01:48 -0700 syzbot <syzbot+d2401aeb74cc84adba04@syzkaller.appspotmail.com> wrote:
>> 
>> > Hello,
>> > 
>> > syzbot found the following issue on:
>> > 
>> > HEAD commit:    3708dd948844 Merge tag 'pm-7.2-rc6' of git://git.kernel.or..
>> > git tree:       upstream
>> > console output: https://syzkaller.appspot.com/x/log.txt?x=11ac703e580000
>> > kernel config:  https://syzkaller.appspot.com/x/.config?x=4e38b15c29e6a1d9
>> > dashboard link: https://syzkaller.appspot.com/bug?extid=d2401aeb74cc84adba04
>> > compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
>> > 
>> > Unfortunately, I don't have any reproducer for this issue yet.
>> 
>> Thanks.
>> 
>> Lazy optimists (ahem) paste this gunk into Gemini and ask "what the
>> heck just happened".  The results are often useful, but should be
>> treated with skepticism.  In this case I think it came usably close.
>> 
>> 	https://share.gemini.google/vq4TLhTiLBih
>> 
>> 
>> tl;dr: khugepaged's collapse_scan_file() is taking too long and RCU got
>> starved.  I don't think khugepaged is doing anything wrong here,
>> per-se.  There's a lot of work to do and we're doing it.
>> 
>> An appropriate fix would be to take a break, let RCU do its thing then
>> get back to work.  But I don't think RCU offers interfaces for that?
>> 
>> collapse_scan_file()'s main loop has
>> 
>> 		if (need_resched()) {
>> 			xas_pause(&xas);
>> 			cond_resched_rcu();
>> 		}
>> 
>> but that won't help with the RCU stall detector(?).
>> 
>> I suggest that a suitable fix here would be to add the analogous
>> 
>> 	if (rcu_i_need_to_take_a_break()) {
>> 		rcu_read_unlock();
>> 		rcu_take_a_break())	
>> 		rcu_read_lock();
>> 	}
>> 
>> (iirc rcu_read_unlock() does an rcu run, so rcu_take_a_break() isn't
>> needed here)
>> 
>> Paul, wdyt?
> 
> Let's see...
> 
> The console log says "rcu_preempt detected stalls on CPUs/tasks",
> which means that cond_resched() is a no-op, but it also means that
> the rcu_read_unlock() in cond_resched_rcu() will directly take care of
> informing RCU of the pause.
> 
> But that is clearly not happening.  Why?
> 
> Well, we have this:
> 
> rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P37/1:b..l
> 
> This means that the task whose RCU read-side critical section is blocking
> the current RCU grace period isn't even running, and thus cannot invoke
> cond_resched_rcu(), let alone the rcu_read_unlock() within that function.
> So an RCU CPU stall warning is expected behavior.  Or at least it is not
> in any way ruled out.
> 
> What we need is RCU priority boosting.  Except that the .config file
> does not enable this.  Not only is there no CONFIG_RCU_BOOST=y, there
> is also no CONFIG_RCU_EXPERT=y and no CONFIG_PREEMPT_RT=y.  But there
> is CONFIG_RT_MUTEX=y and CONFIG_RCU_EXPERT=y.

It comes from syzbot so might be likely a randconfig and there's no point in
trying to find any sense in that combination :)

> Because we don't have RCU priority boosting, if the load on the system
> is heavy enough to prevent our poor preempted RCU reader (PID 37) from
> running, the grace period cannot end.
> 
> I am not sure why this task is saving its stack, but maybe that is normal
> for this code path?

That's because page_owner is also enabled so it's saving the freeing stack
for the page it's freeing. That's not a normal production config, only when
debugging.

> My bemusement aside, I recommend running this test either with
> non-preemptible RCU (CONFIG_PREEMPT_LAZY=y these days) or enabling RCU
> priority boosting (CONFIG_RCU_EXPERT=y and CONFIG_RCU_BOOST=y).
> 
> Maybe RCU_BOOST should no longer depend on RCU_EXPERT?  I would of
> course need ot remove the prompt ("Enable RCU priority boosting") to
> avoid annoying Linus.  Maybe as shown below.

The "no longer depend" part alone would make no difference with randconfigs.
Removing the prompt too should help indeed.

Maybe a possible strategy in general would be indeed to unconditionally
select what's the expected config, like you did below, and only make it
possible to override that with RCU_EXPERT. So here with RCU_EXPERT you could
disable RCU_BOOST even if it was automatically enabled - assuming this is
useful for development or internal rcu testing by people who know what they
are doing (not syzbot randconfig) or whatnot.

But then RCU_EXPERT should be excluded from (impossible to be enabled by)
randconfig to indicate it's not valid for this kind of testing.
I don't know if there's any precedent for such a strategy.

Specifically for the proposal below, could the problem still happen with
PREEMPT_RCU without RT_MUTEXES? If yes, it wouldn't be enough?

> Thoughts?
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> diff --git a/kernel/rcu/Kconfig b/kernel/rcu/Kconfig
> index 1a5fb3156c062a..5141ad8d1cd029 100644
> --- a/kernel/rcu/Kconfig
> +++ b/kernel/rcu/Kconfig
> @@ -237,17 +237,16 @@ config RCU_FANOUT_LEAF
>  	  Take the default if unsure.
>  
>  config RCU_BOOST
> -	bool "Enable RCU priority boosting"
> -	depends on (RT_MUTEXES && PREEMPT_RCU && RCU_EXPERT) || PREEMPT_RT
> +	bool
> +	depends on (RT_MUTEXES && PREEMPT_RCU) || PREEMPT_RT
>  	default y if PREEMPT_RT
>  	help
>  	  This option boosts the priority of preempted RCU readers that
>  	  block the current preemptible RCU grace period for too long.
>  	  This option also prevents heavy loads from blocking RCU
> -	  callback invocation.
> +	  callback invocation.  It is now automatically enabled in
> +	  any kernel that can benefit from it and that can support it.
>  
> -	  Say Y here if you are working with real-time apps or heavy loads
> -	  Say N here if you are unsure.
>  
>  config RCU_BOOST_DELAY
>  	int "Milliseconds to delay boosting after RCU grace-period start"


