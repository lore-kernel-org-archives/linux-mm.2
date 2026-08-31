Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B096FC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 11:56:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 697ED6B0088; Mon, 31 Aug 2026 07:56:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 670AA6B008A; Mon, 31 Aug 2026 07:56:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 587106B008C; Mon, 31 Aug 2026 07:56:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A3AF6B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:56:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2E88D1A04B4
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:56:13 +0000 (UTC)
X-FDA: 85161411426.10.16C2C51
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 96D2614000D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:56:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CTmIYMlm;
	spf=pass (imf23.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788177371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iv1g2a/BPCURzyjERuiT2KgQt/5FQjoRURW2yzaMRD8=;
	b=0XyjL4jt56WSmrTTntNy3GMtlReF6GW4u6TYzLY23nEpjp5PV7QwhB2UfIIW6yJydb2BzH
	mgyaihp6JtTecrRsGBuhNegPogqVsAFWBevjG6dEx25CW1EEna99k4TvL+e0bWQFd7Fa35
	amcD5YeLrn0tBZqWKjeyqjbY8WR+BRc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788177371;
	b=bmjZmgc+5zaTyj2qdRXwTznW+RjxW8aBwYaEaEA3ctAjEKcgXG7oQfV++jmm1n/AjZ7D8F
	MCJOO4IUvQsJRc6k3577TRXllS3skPniJMj+zn7hqCIoGtHdZBjBPvI14ihsX18mj/lBv+
	FzThGbE3JQ5HLKKwJzIa9w35wo/XQdQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CTmIYMlm;
	spf=pass (imf23.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6FB7A410A1;
	Mon, 31 Aug 2026 11:56:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6D41F000E9;
	Mon, 31 Aug 2026 11:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788177370;
	bh=iv1g2a/BPCURzyjERuiT2KgQt/5FQjoRURW2yzaMRD8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=CTmIYMlmQx64UQUiggbx3OFP8+JY8gdznfCHr9ZNfQPuETMsNOVLTgFm7Jq16WrDj
	 DS6tT3CRzkghVydbepFuxVWRQNaeDmRRmgvGs/BOtR0M+NCxkHFFiR2MQpwoUUhgQh
	 bOeLWaehWaunefgkTJGCZLQWkky3vGKLovL4SoQTI/pwEUjwh3OG+2v9zhqErIHO0t
	 wRCVvs268uRWOB3cCnfAyS0qCMczKNYWUNoICPis+6CUSFVsSxoAiZKlFix2/SpTBf
	 LxIDHOrmOTNueigvtZBIcB4cmC9lgMHZI+8HqsEajzGYym1s/F54tz1VUKqeevvC7U
	 QG9qwGdIficWw==
From: Thomas Gleixner <tglx@kernel.org>
To: Hyunwoo Kim <imv4bel@gmail.com>, Frederic Weisbecker
 <frederic@kernel.org>, Anna-Maria Behnsen <anna-maria@linutronix.de>, Kees
 Cook <kees@kernel.org>, Christian Brauner <brauner@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
 John Stultz <jstultz@google.com>, Ingo Molnar <mingo@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, "Eric
 W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Hyunwoo Kim
 <imv4bel@gmail.com>
Subject: Re: [PATCH v2] posix-cpu-timers: Dequeue per-thread timers before
 exchange_tids()
In-Reply-To: <ao7Q8miiuLAPVnWv@v4bel>
References: <ao7Q8miiuLAPVnWv@v4bel>
Date: Mon, 31 Aug 2026 13:56:07 +0200
Message-ID: <87bjaicxm0.ffs@fw13>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 96D2614000D
X-Stat-Signature: zyq8e54hgpnz5d6d7ygwm98f8axzcxc5
X-HE-Tag: 1788177371-519547
X-HE-Meta: U2FsdGVkX1/UdurUX7/nztRhzbexSQxOo1zNcj/WT6FWI4saE0k8FpCHexC4ucPTgJm3IyWOOI5P8BhjXcn+89uBqTsvgvbScB9zgFTChSMfaA0WkQxs2GRQ6hG5Rlk6aq1OIhnZzdxRQ+fG3bXsLcRw0msfgQ9+x3luoKxJZ0J6e7VC+HWWQuUN6ddxUr7o7l+vtf3f0hi9ZyNQAbeNUhonksbgV51Ck6vFpOF9kH55WvbhcUwoFIetuyreUSXiTLKqGF/rvNS23QIg00lCM7QbJrlMbTBEUeqo/oy7woVfz/SQ9YpEig/j2+hHwrVoSurm9kwWM1KZ3wXZIvyaI7oQuL48YjZ73ia3ErxBQECyXZQZLKmB65h/xnv0kwSp2LCom2QiFNwKmA0PKfKKKpfjGrQ800igGDjgrT9BQXEJiX7Mulp1vwb2EmhcYOLL2o7iBv3OS4Vpt+cT+h9lNLqx48kKaoquqG1iQFBt/iYlSgIPxaNQdOwVus1ycUfsmV7CMk//lRidLrdxuBBot9XFu27OjixULKTAGVQv/2DRvm5k4XYz6Eeq8utOEoWmJjhyWDUIS1V6rSLh07MlNwdIYxljlpPZPVOgQNzfmQTH/zmHH29sVYFautPKzh9ecstltJD048ZnOjC9RROVRMJSDzUN6FHNXumgTLPuln1ZB6XV4q0GuyyU+HvdmeVynMHHDWQ13ROucAn9gXxkvfytxQ2f4tGEyRTrRk6G35jIt3KdZ59QR1wEN+im9C3gBFXawiUjOI5G9zokQ4uCq6qe14WG+L4kzKwVA18OkAWamkkL1PrYDcCGWP6QfbibwaSYgfQHGgdmbnI3OO88fJZ1sFFq6th3qjnyac1WivkL3tnzejqdKfHIkZ9ATp9PCs9orc2aXpKNr49XimOKjhdXUFrjdzq1QqSWgZkTA0eJr6C8ahiFm/mXGhS5YzFPxOUixFM7Ac6YrkUkPFf
 wAca4ss6
 QVgEmN6gEvS/aV5vTharGUw2TY7GalO/sv8mI8TEYJAuoCRB5EM2JqFerM07OGfM8PLbqFWXWxYhGUiumuX99jTSl52pMKMHmKtWF4aGx0ubXc79tHckDAAJe70sygz5MR9znQer8yHXj5RYDM91rzgHv2f9PzS2kt6k78mxgh/Lr0tkj40zZgf+6CtlcYM6n0mrm75yATT+4YRRLMmOpluk5pdBcao8mreT1NuX6zZsks3WDG4c9pc9zxZbO1o1IdfQFuQGo86l53z0d+S4TfdSVRd15ycceSbpasmTJeObcK2ip7nqpEBqdmc/Fy8uHizM9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26 2026 at 20:41, Hyunwoo Kim wrote:
> diff --git a/fs/exec.c b/fs/exec.c
> index 745f6eb5279e6..9b2d140bd9f2a 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1003,6 +1003,18 @@ static int de_thread(struct task_struct *tsk)
>  		 * the former thread group leader:
>  		 */
>  
> +#ifdef CONFIG_POSIX_TIMERS
> +		/*
> +		 * exchange_tids() hands this thread's PID to the old leader,
> +		 * which is reaped right after. The PID lookup in
> +		 * timer_lock_sighand() then fails while the per thread CPU
> +		 * timers are still queued here, so dequeue them first.
> +		 */
> +		spin_lock(lock);
> +		posix_cpu_timers_exit(tsk);
> +		spin_unlock(lock);
> +#endif
> +
>  		/* Become a process group leader with the old leader's pid.
>  		 * The old leader becomes a thread of the this thread group.
>  		 */

Similar to the other issue vs. POSIX timer signals this really wants to
be solved in exit() independent of non-leader exec(). Let me have a
look.

