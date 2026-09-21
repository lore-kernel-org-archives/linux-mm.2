Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2C75C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 16:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFE136B00C1; Mon, 21 Sep 2026 12:09:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B87136B00C2; Mon, 21 Sep 2026 12:09:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4F0B6B00C3; Mon, 21 Sep 2026 12:09:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D1216B00C1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:09:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 11101A5327
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:09:04 +0000 (UTC)
X-FDA: 85238253408.09.1549D61
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4D0F52000C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:09:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I6lco+9i;
	spf=pass (imf31.hostedemail.com: domain of "SRS0=kZ6u=HN=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=kZ6u=HN=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790006942;
	b=20dDgnuaYu3glzWXwVn8XS9EH+INH7VKkd5jXYq7hm0GHtHuYd5Pwz08ofb3lYgQ74YRKL
	x2BPGAUz4/AAlzTwgYNwd8AgoPjAiNsqGb+4JSmaAfVzSx4uZbVm+Af8o8R9ryigIKfOhe
	0rUAvLUtl9LgWm1WQmHVogpqixSVHmk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I6lco+9i;
	spf=pass (imf31.hostedemail.com: domain of "SRS0=kZ6u=HN=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=kZ6u=HN=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790006942;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOTV0PHDPjv7T4ZC0QP6/caxtiiGCzPPnekS36QsNyQ=;
	b=imJuKzYP8qvvPDID8A5gWor8LPzxlrX2axneODa5ncO7lK4u6mV34irgXW6UFeuxXpUI7a
	zpJV25/OtCD0cXIuEvoP5FuVgi/2qVCOHA6JRIFp5HTlplYSho9pHDNY0ATpskganMxWGD
	AxJpbuVVUOhOhGIcgw7dKa2GL8ZU898=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 79E8A43C81;
	Mon, 21 Sep 2026 16:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CEF81F000FF;
	Mon, 21 Sep 2026 16:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790006941;
	bh=FOTV0PHDPjv7T4ZC0QP6/caxtiiGCzPPnekS36QsNyQ=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=I6lco+9iUwAqO3zjgvumlLA5C/VhfXUwEk6SUo3gSkM4oTj4GvL0t3U4GwpiU+aFj
	 MuMQAuyChxeRaQp9gYkR2DtCDN4T1OrLkPS/ojp2WE1cPoM0iooDGXYr3uoSn+xBaF
	 1C4QW+Ll5f789AvK2JwPuRCnzDwI7zwh/Z6gxDafAIWJqj29JrwN5sDfbpFTNBIxuQ
	 RI0QQS1cRnfDeaKYL1XiMw7v1/N4mZbcxHYmuzsbK6XXOfv/eU0pbJM+zgoumIdeIW
	 Nle6h3WO6Yslfm1dRJRE7tO9hPI5pG+0mtAOpVKKRdAa4lPpCtQWILF8WzQSn3IXYA
	 79HqW3QApVSLQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 1541ECE086B; Mon, 21 Sep 2026 09:09:01 -0700 (PDT)
Date: Mon, 21 Sep 2026 09:09:01 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
	Ye Liu <liuye@kylinos.cn>, Michal Hocko <mhocko@suse.com>,
	SJ Park <sj@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>, akpm@linux-foundation.org,
	peterz@infradead.org, mingo@redhat.com, rostedt@goodmis.org,
	jpoimboe@kernel.org, mic@digikod.net, tglx@kernel.org,
	david@kernel.org, linmiaohe@huawei.com, nao.horiguchi@gmail.com,
	rafael@kernel.org, gnoack3000@gmail.com, gourry@gourry.net,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org, rcu@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org, rientjes@google.com,
	shakeel.butt@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, will@kernel.org, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, tony.luck@intel.com,
	reinette.chatre@intel.com, x86@kernel.org, paul@paul-moore.com,
	jmorris@namei.org, serge@hallyn.com, pavel@kernel.org,
	lance.yang@linux.dev, mhiramat@kernel.org, pmladek@suse.com,
	longman@redhat.com, mathieu.desnoyers@efficios.com,
	jiangshanlai@gmail.com, qiang.zhang@linux.dev,
	dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, kprateek.nayak@amd.com, mark.rutland@arm.com,
	Dave.Martin@arm.com, james.morse@arm.com, babu.moger@amd.com
Subject: Re: [PATCH v4 09/15] rcu: convert process/thread iterator to
 for_each_process_thread_rculock
Message-ID: <f0c6954c-1e43-4a01-9c9d-11d38edc1e2c@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260921092101.89285-1-ye.liu@linux.dev>
 <20260921092101.89285-10-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921092101.89285-10-ye.liu@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4D0F52000C
X-Stat-Signature: tf5fjeyfgxasuzd1j9yha3u567z6pysh
X-HE-Tag: 1790006942-252366
X-HE-Meta: U2FsdGVkX19sVumTp3ryMmMYboHn4AAGKxa0n80mFjUEZlkhNW1Cd/eSxsP3Zy70m9OPZmMgE9Kg0xxsxW3eBSY4CwBl2U+Eh/epv5z7aGRNZ6w7RIYyqiZqt9L4nKtvKPnluiqdg0JaKh/GxUo/Y6Nc8jmuhk5qXZqad7yC+YSTZNbs7CFIpRE9XkCybFDwLM7d6KGoP2gyyFZILWCoTWOuSSUKlaGgvnFa+KRJAs6DOWXC9RaZcQV9mFzjEOhyW8u4pA1djQiQ96C4W2sUINSC88N8OrpznnWJmI/khOJkO/4KcJE/xfxSpKN0ftoqiNBTD+yz+rlpDsNMkKFrp3fgAAej51GX6KpU+iUdvuOhMOy4rXbH+7Qu0Tz8mVvLyFHbkUPjWNiHy+YHfQMn3pUrpEf6ktU9vUAVQAOa0UdouzgqfxNWVPg1zpgBZlkv8EKuLk5T5bt/yS5mNLokFrcPicwYlivU79q+HIne/s26arXh5hj2N3Cj4S6Si2frXQJsS89LUkcs5pQeMZfDfJ7OCF1xz4H1kI6AiTiwWH2512JCYMxJXYjw1yx9BezNdpuiOfi0NUy014MQEvMbS2yuoYlqcHOmaeAxLcKdGOwJA35rsxZo86VzLxH5aRgDcghdzF034VWeNcmJNYx2NfqcClubJzGyzaskUY+i6+G/bErARQmUiqqcBCOh7qmF8N68YPwuCO+HeoOfeDei7xVJs3xovTTgzR3UM6BeCE+kNSoPeIFZ1BLARyCNJ7ki3AF0uAVHgDZ8puiaC88qJ4m5sg78dG640mQfqsx1bDr5sB/Gm8NcoAEQ4UbeHetOCCuenb8rv6wkeVOjPfDgNlrH4T4PXXU7sv3v9XJcnEW0gTaG9yfxge5nrkUStMK34V7Rdj+hZ3LX4UeUX65NmQ/MTtcqIV2PtybBiD6GSL5cJuf+DeAoYw4aAxKHSyxgaHtBHA2Y86q/s2NtuzH
 fva/Teo7
 NfEAbCTww7czJJzg7dHEu9N2ndynWI0y5j1xcVPz0+xJ1CJDWOvmyYjGucaP2oD5u9c2NU+OgWmDevBXUmQ0AJDemdfw5GEwmzfGWDNaFpVmumIVNC7cs2LF+nngno014NzYcGUQKSY8qJ3yguSS9+xsSu48r1wOJTiTFviS1eJL6DnclxDIHDQQmsh/KcQwrwUOaL2IQfVj55rZKosXDfmf2Z48BiAZeKwR0kuVlqT8YKdL48il0cLtVwIVsMyEAgetdm2cFi2V4CTm6Y4KzQd68C1BBbHzo3O2OLF4Uaxr9B22rgxWhoRcYT/UwUdrwvcbXD80HRZVI1DapFOzloKNrkCqH7xLINdUg9H3DOg8Ku+RsaAJNAQ1O1fHC3kAYAiYDwF3q36DAWvf7taxar/k2FR+IDsQfaffc2450gnRD8Yj9mmac8LXYNub+g0LkFO5oKzhh6HWDinbyQYUvE/5AG5JB8zgKwmdp1H1ERoDu729AsNt6O9ucseJJ+9TucQh0l7BJdKxcB/MF1sT8/SSdzZtx2ehcwcoD/e5Rt78AkykWGI+TiL7Xc0zmDfs9EcYCnD5aAJo4Pa7WX+QLLetynkPa7YIaDcamZcj5D2cijPu0SFxMIpTZk+yYSsYRlAjjAdkeA3Uy+aIrBgcZov55J2Y9d4tT7pihiP7bte8pqVvNPXmr4B5dnmazAE4Q/97maq/pSMSXmxiKD+jvKyXACe+BKrscGKR8PhaCrI52XyTmXGYoCzL6mAR4JMf34XwYusDyYkQ0TD7rsOeftYOUHpPvkkDLc/ZjeZL+MveJJF3q2bPvgdhpMvACc5QbO57nrTrKgWgaqVSulGCtAac4beVXs2R77Y8L16lldK5kbyYw8AkrPUtaZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 05:20:55PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Replace the manual rcu_read_lock()/rcu_read_unlock() pair combined
> with for_each_process_thread() loop in kernel/rcu/update.c with
> for_each_process_thread_rculock(), which scopes the RCU read lock
> to the loop body via scoped_guard(rcu).
> 
> No functional change.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Reviewed-by: SJ Park <sj@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: Paul E. McKenney <paulmck@kernel.org>

> ---
>  kernel/rcu/update.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
> index 2a778b8ab4ad..d8e0b5896db9 100644
> --- a/kernel/rcu/update.c
> +++ b/kernel/rcu/update.c
> @@ -548,15 +548,13 @@ void synchronize_rcu_trivial_preempt(void)
>  	struct task_struct *t;
>  
>  	smp_mb(); // Order prior accesses before grace-period start.
> -	rcu_read_lock(); // Protect task list.
> -	for_each_process_thread(g, t) {
> +	for_each_process_thread_rculock(g, t) {
>  		if (t == current)
>  			continue;  // Don't deadlock on ourselves!
>  		// Order later rcu_read_lock() on other tasks after QS.
>  		while (smp_load_acquire(&t->rcu_trivial_preempt_nesting))
>  			continue;
>  	}
> -	rcu_read_unlock();
>  }
>  EXPORT_SYMBOL_GPL(synchronize_rcu_trivial_preempt);
>  #endif // #if IS_ENABLED(CONFIG_TRIVIAL_PREEMPT_RCU)
> -- 
> 2.25.1
> 

