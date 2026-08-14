Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DEE6C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 12:01:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F11B6B0699; Fri, 14 Aug 2026 08:01:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A8D86B069A; Fri, 14 Aug 2026 08:01:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B7B36B069B; Fri, 14 Aug 2026 08:01:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A0A76B0699
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:01:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AF1AE1A0462
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 12:01:54 +0000 (UTC)
X-FDA: 85099736148.06.57A840A
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf24.hostedemail.com (Postfix) with ESMTP id DD678180018
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 12:01:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ICOEpCdL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=imv4bel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786708912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o9s8AN57wB7Vi/36kIlm/41aiy/3Kyf8X3cTuSCNC9g=;
	b=RXFYENTsdCU6cfvI+tPTh7+LzhDnB/qH/5YWOVzPbYkMsj8xQTc0puvQT0dmyVKnZgHKn3
	WmA78Sh0208wBOdI2xbPfNsgI6VRuMDUzWS7TYjHlO1t5PBToq+SEot1byHSfu5pH8+0Qg
	Q5XfKKPSSXaSPeKEQaGEYvKfj/UNwFY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ICOEpCdL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=imv4bel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786708912;
	b=dRNTfPIKcu3Ds+OezjFjiLqjqUsopn88k+MuWdKhScm9huRy88U02S1CcQGYdXlyZMMRk7
	1BFyZH1GgzG1GOELBJ3phlvR7vUHntd4fcUnQyeY3aDT6xJ+FwT8V1pdrYkq518lae9frf
	KGStPt+oZFE2imoGbm45edrctsn2B5E=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-84f3ab8750cso621607b3a.0
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 05:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786708912; x=1787313712; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=o9s8AN57wB7Vi/36kIlm/41aiy/3Kyf8X3cTuSCNC9g=;
        b=ICOEpCdL/sE/E2v1mINNLXaLnwYUrI4zdJfIuXYbIfxrt+4h/73Zpfp4WnGcpQzyAE
         AaKSrqxN+A9lZiAyi08nULdbPqMd7BT4LpnYX1X5rz1HIGMCnwmMFFnHvvWYhhrPevrb
         FVXGqEdnOKPjzX+h1VUplf3Kz5OO1olxjWeaIm24I8yDkihwzqJpHSkiGmpLHESQQm/s
         0uQ/yzO6hiSXxtjY0C6ZyPOpQJtl+PdBSJ+NAD4PaJY2QCcW1YeNFDrAEAOIKVFYYJuH
         pL5ESSSQnn3TA9EEGE2sImEPXzE7sXWtPq6y6Tv3MFqajhR6rEsAtQlD1KEjjhT82p1L
         OkoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786708912; x=1787313712;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o9s8AN57wB7Vi/36kIlm/41aiy/3Kyf8X3cTuSCNC9g=;
        b=PS8T41AQDKxN6JiT38VVzFe05mZSpM3sKQ6wtLihdoPj3ZG9CzWaNrvR3WDnJBzmq5
         lUxpNMqz40wixWzWftpWFP6NhMrWAlnUcERe77VvvoktBWlPPSsttzx07jXQfxUHucYq
         XnrfyTORXUk7MRB2q59/XzJqNd41Gpcwifm7QRutmU5uoXYFfw4zvooKt0EhNdvBlyS1
         cL/FDfQTFIdN1Fb4P4E6Wg2lFWuxUtdzJ8DKKYkPqzdYHm8MQLKStgRyfOOGPd+mckRm
         YmqMCqwvKONGylWk4/JJvcq4lzhBhJH2M9kAtwRoXPhA/M11mMq81bB6OVaZkvb9JEYl
         1d7g==
X-Forwarded-Encrypted: i=1; AHgh+RqbpJ9WxBxhCpw9qK9EpFTnofLqUjn9spKf03/Q/nJ8AJvAfRBYOrfTsHM4b9DH+WByI3v0zrRa6A==@kvack.org
X-Gm-Message-State: AOJu0YzhLQQbgG9keTZWAOnR8/40o4UY73WDjuoMyCwKWrDWOABbJaTQ
	tuWZe42hM0oCfVZEc2s+62ZWABdiz2TJr/2F0LmssA3CEYIoEgrpvR/v
X-Gm-Gg: AR+sD10y6tyvRYKG7bgmV6g5cVXBi0c8ZiFb8KyDda0v4Yc0AQGrFYXcBm+x/0dRtFS
	B7w4MVuItn/Z7pRFJ/kXPQDQA6AbUoZn0C9/MbBLUiqpB1OQDwZuo7iWzWyxmtmyISi86w7/Q4b
	oF6TVkbVUO9pHyNzpGd0ERt/PbWGCBAsdJ5YvjPg0PT+crpeYtnOCIalJnKVqxZeN12QCmEE+l7
	ZGE8nre7vpQHvsMpzsiDZB2J+VDT6wxHaY1OCL9blTklHkAYdrT5Qj7V7suuW9zKadGQJTRAisT
	7dZqWNSNHlcqMtOZ5pS8/ef6g3GHajXW9DmGfBz64fGeNT+xzSQefPt2ywfQpG9Yl6eMzGcbQ0G
	IWGBf3/UiObgqELpPEPe2eIWuVD/V5yqmiYn3xGovKYTSBe/HKOdzmcHSNlrbmyGK81kQiiTGBc
	JmOatW4OpUBY7GsCZQF84BEWjAI1cDN8eJUXcM0wGvyiaqQdfo74R7L9dNBubRHwbkuYvx/2Ru1
	uRSQFjs
X-Received: by 2002:a05:6a00:9a0:b0:84e:e741:174f with SMTP id d2e1a72fcca58-84fddf87594mr5396442b3a.7.1786708911472;
        Fri, 14 Aug 2026 05:01:51 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8517d01c2e7sm384922b3a.13.2026.08.14.05.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 05:01:50 -0700 (PDT)
Date: Fri, 14 Aug 2026 21:01:47 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: viro@zeniv.linux.org.uk, brauner@kernel.org, tglx@kernel.org,
	ebiederm@xmission.com
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, imv4bel@gmail.com
Subject: Re: [PATCH] posix-cpu-timers: Dequeue per-thread timers before
 exchange_tids()
Message-ID: <an8Dq_XUMobC395V@v4bel>
References: <anfgrsPlUdwBhdrp@v4bel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anfgrsPlUdwBhdrp@v4bel>
X-Stat-Signature: ckseqnewormusyidkzpk3yxt8krmpk41
X-Rspamd-Queue-Id: DD678180018
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786708912-297690
X-HE-Meta: U2FsdGVkX1+ii/XGrk/sYnM3H/gM9KvLMKRWMOiWE/xapB4eCEc8ldzBD/PXvMMN/s9WeDyP/A0amGxFfksZVN0GhzsZtkw8DWaH7GCGjRBclr7jB8yuDDAYI+HgmNqcUwoPXOheDL2LIcw2Uoh8OEceGQg2NqJXh1Z1j5rz/k4hoUSaS/GODY8wkeymkkMhvDw9Vq6kLItqVN2pD8boumW8/QByKV7bb1C52Cudr4qrIl3ePFer9pFc0F7Q+fARFMQja1u6qNfKDkkgOPM6eaf+ow04T61um44iDeUujGTg1avhUQAoxynn/6t4PHZEyXhGUwgrTtdZ2tVl7vXtgtZmwV9+QML6i/f3fIgOHRz89lxzW1utBNYhtP/LfGnaW4xYbWuWIZzQZrwqdhi07n1KmfMiuAjskNVgs77LYFLaccE8bPrCqyNAg/z1iA7CXlGce4310New9EjAd8ovjcFJ4/oTRpEZ+DJkXP14RGx5tI2MHYZay8XkFLBqc4xHajY4MtNKedO9+gIaK+HXgMeKlEeIj/o2AhCNu2w9TrXggj4u1PPUDwk4pR0bemEHUyC7QpI9b0kCG4Wfm9DO5lDgCNYVK4z+NAAEXSjhUBfclfIer3+cQh0g7aJTbm/WmyyJHzw+jlM3Ee6KUkfefcUYUUb8MF//fWWJXn/VsAe2HBRWorrMVNRpdox8DAQnabNQoCUXFnTkCI50dHjQl9zEwbgCEE4jeiqoa93m1pmEQh/5uUBEAQT98lW0SRof3LFKj/mO47xz0zlZw0V3azUdc+NlApOWUamuuQqGzdX9+MHnGjdZdAhgQBVAbNZsOxP+11egDoQJaJuHkmPFjBbiElypsFzGKKNleIM3vbI8VgzduWzbVKLr5hHTaO4mG5KfU0AXJvm+r/xhJrwYb8uu/tBwu266UwTfLIjya7+xdI/6JEo97sHzKv0IA3aQMxtINQ6KC4AyI+ksA9d
 BlfdFvQ3
 YMVCnYpQRzTAiVbnzCVmYdAFxgpH+56gn7mrxTzjcHKrXJQXZzvKqxIXpDd6Yi/CLOVXTTfQDohPIF0BalzaCRY9Rl+wxa9dZVDyrhwgqINbHc9bKFX6HJU+++NlB78SgU4iJKdPbkbcL4em9lFFltqq/24EqI+kaTjKTXXsAu3n0fQpVjanQG4z+alX3eOmpnCQR63ZhqAmt2RasODz4ILYN4mzKc6lMOKNNfdW1J6FJHNtBm7ESPlEcmqCqicVSLjq9Bf/C6CWXGhRowtOTEfs5hixEC4fr7REzFtII2igxU9GT9jZaQ6gc29jvDl7uABdLhHwjjQrVm26gcQp7AalyQnFPLClLCYK7dYliK+NoDV/GTRyprt7sEDPbllNCfneHH2P0HBE6W4vyFqD/EGoMLaL3UJEM6mNGorAOpJJ1FQPYLmiMBJ7yk7rBgniPLgI6bCi5E2nqZPk1/wIfNnggAKmfdLsSLsDl8na+KkUGR5yFxodBnoEKEe46ZaY/ca08i30DqKGD/9C2wGmqBC3qnr1SwJRDjxQbx9/3chsa1sw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 09, 2026 at 11:06:38AM +0900, Hyunwoo Kim wrote:
> A per-thread CPU timer holds a reference to the PID of the thread it is
> attached to and, while it is armed, its node is queued in that thread's
> posix_cputimers. The task is looked up by that PID.
> 
> When a non-leader thread exec()s, de_thread() changes which task owns
> that PID:
> 
>   de_thread(tsk)
>     exchange_tids(tsk, leader);		// tsk's PID now belongs to leader
>     ...
>     release_task(leader)
>       __exit_signal(leader)
>         posix_cpu_timers_exit(leader);	// cleans leader's queue, not tsk's
>         __unhash_process(leader)	// that PID has no task anymore
> 
> pid_task(timer->it.cpu.pid, PIDTYPE_PID) then returns NULL, but the node
> is still queued on tsk, which is alive. timer_lock_sighand() takes a
> failed lookup to mean that the node is already dequeued, so it has
> nothing to undo.
> 
> begin_new_exec() calls posix_cpu_timers_exit(me) right after
> exec_task_namespaces() and that removes the leftover node, so the state
> normally stays invisible. But bprm->point_of_no_return is set before
> de_thread(), so if unshare_files(), set_mm_exe_file(), exec_mmap() or
> exec_task_namespaces() fails, the task dies before it gets there.
> exit_itimers() then frees the k_itimer while its node is still queued,
> and reaping tsk later erases that freed node from the rbtree.
> 
> Dequeue the per-thread CPU timers of tsk before the PID changes hands, so
> that a failed lookup again implies a dequeued node. Process-wide timers
> are looked up with PIDTYPE_TGID and transfer_pid() moves that link to
> tsk, so they are left alone.
> 
> Fixes: 55e8c8eb2c7b ("posix-cpu-timers: Store a reference to a pid not a task")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> ---
>  fs/exec.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index c7b8f2d6366c44..f80f70e1c26de4 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1000,6 +1000,18 @@ static int de_thread(struct task_struct *tsk)
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
> -- 
> 2.43.0
> 

Gentle ping. Any feedback on this patch would be appreciated.


Best regards,
Hyunwoo Kim

