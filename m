Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F79E606A330
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 02:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B5JOemNw
Received: by kanga.kvack.org (Postfix)
	id 26D4D6B05B2; Sat, 21 Nov 2026 21:13:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21E156B05B3; Sat, 21 Nov 2026 21:13:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 134756B05B4; Sat, 21 Nov 2026 21:13:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E2CE26B05B2
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:13:40 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2012A0690
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:13:39 +0000 (UTC)
X-FDA: 85461133758.15.13B9657
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 750F580004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:13:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B5JOemNw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795313617;
	b=tYWveWE+O3AIuLQPsy/2TppGYO8FNV+d7W4XW/LGBgnUXJjDBd5peB6rjV/vY4PNKWTlZR
	SYiWGaxoVn83atRyPjDENGPSFM8tWn/fj/jiufhW71GJmscHpzjAB7zVXAcKGHq6ApyJWI
	ixM6OPrrH1ZRKA+SzThReKa3qTvlDh4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795313617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cSdr2cBdqkloDgvS8BMjQJSoyDpO64vjXYle1ikr1YQ=;
	b=W21yu/UpLE1m3LKIE4mF4bGX6wr5tTtjzTMOgN4N1diVx1+QQ0PFp5gByXkZEisp73ji30
	8DDrnmpSpwyrO49J+l2XklrhO/xZpjPssPZsS31p6ehEnv4F1eXiQL+nq+aJU7tGwfGFND
	P+a85p4E4cMZRg8jLWyuGC0zX6ZeAA0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B5JOemNw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AE8CD402CE;
	Sun, 22 Nov 2026 02:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3491F000C0;
	Sun, 22 Nov 2026 02:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795313616;
	bh=cSdr2cBdqkloDgvS8BMjQJSoyDpO64vjXYle1ikr1YQ=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=B5JOemNwzbqZMdKmy8t8vqSrhW01QJnCyEIibiwaUziPQ5Sc5NQavrA2vLyp1LPBp
	 VNQDXSAAD/P1KrEfPW77SO/Pmw9NMoJ93RjyBmmeJMkKa0QJ8aly9oZA5ofCUdn60q
	 LFGpGstl6NI4Akc0S/XxRJINjkl2JCuUhtCX7LP21ZG/3OR7M+J4eSDQWtuBz/wCCw
	 TiqMouXeULkeIph5i3nEqXzCAy3gLKW9e5xLmXYztgXixlP4cGqEfJ2kTvU4M/y2rz
	 djctkzD3/xFfC+61kWTsvVp92OuRRNqHSw6aaSyhd0vkJ042MkVN4cia02bB4g2Isx
	 x3SHdE1JpAy6Q==
Content-Type: multipart/mixed; boundary="===============6118825193041384337=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <5cf1f729e21c52032316bd1351ca28d6bf30e54d9ece35b6f6055c94a61e6883@mail.kernel.org>
In-Reply-To: <20261122011809.2667684-17-jarkko@kernel.org>
References: <20261122011809.2667684-17-jarkko@kernel.org>
Subject: Re: [RFC PATCH v6 16/26] signal: Support userland fds in pidfd_send_signal()
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 02:13:33 +0000 (UTC)
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 750F580004
X-Stat-Signature: hse55fbeooxs4pe3sdqmfkyb53kizt1m
X-HE-Tag: 1795313617-368000
X-HE-Meta: U2FsdGVkX19iTD6tIcH70A58tBcetuww5UhL/QJoNfVc+piHILItYlHfoy5tSwKUjda0lv2AVhIluCH5JtYuI1K+Sw8L3+LBKHwuQVY8Qo3wDoSHwNE+nCusCW8CD9gQMx0424tJQe5w2CzICw8rvucQ56UqQnECp8Pmo/Dd4xw+5iY2lwr/41QsuW7GwzWPCqwaiqIEAyk1q+PgdV3Ajo1fkv8CK9Zngp6U50swbtc818d/7+YZIp5f1E1J/z3IO9zl9mCUOQ2vWW12gOZJXVk39+NUbwT9qZSs9q/JWk0phPsPvPgfrpmn+S3R5w0RkN0jy7YLBt/pR+NR+QBV53kJ7vqYylxO91KfyrJmJ5uNgsuaOB/7HDPjivhabjw1y4+3C5aSkLvREWwDF4DDGWPzBlIfnMpbDQUTKF744ecjcOPRmsS/wVpah1C4C2CXbRszPMaN0481/uWeYpuMCYdbEG/6nLASXwQfCqSdicYn/Xr4bJFL0lL8C+mAUqayAP4eeEuvWIeaHQvewx+YX6OT404B1ibZPvdgz6Um4scWTW2Jg7o/MReh7bbMaxBK0pmF/WRa3FwS0oJQ/4g6AgjKm/wrdxwNiOV9v3DtF1re/l5N+FPcT/ZCRveMKyI9tkxHjTHe1C3cJ70jqQgv6Qdg8vDTf0hi6fAx1A2/GGcCyx7xjAZgelq8Fu4xogxsIDy+REW/ImnDBzHURTXqabCqfwnV4fylbQBkb/G7zfnm5ifeQYVAVimNOVUzffhLIrOe1IPPWiwQJwpmHblv/b/rERcI4sP0fnHqLHOha+Q6dgXlT0MW+5/sM677lC/PTBMNyWggosT/OXNNck6x8lL2r3arsCV7WkbBNdt2CU5Cp4tO1X+ZlIsDHf4gLklL1qLYP819tzYc0Ka3tFX/TA9mjlh4mSS2AI1JPG0IXa5ZwkgGE6NW9NE5jHyxI/qa6b2dYu/0/NYi6AnE7s6
 8sz3UcEW
 t8TrC6kkchWKZ4VotU9BNdE9KFi+wY5l5n+/RzHjdeCWUuFV6H+koF/eg2twf7eD5dQTUZ39NVwo826ao+tlQOI+S7pRpj6pWFtDP77aCvElap917YgQbUkej8tsu/PW3laMYAc0ElT9S0REBq9JuTP1yFS9oSuzl+AVmefUXmpgW02ogJjuZOYTdTseboFdY7gaEFH5Rq2cCf1Kah9VBgrH9jc/iTvo1l8acRwbhLi+FvWZZx3PJ0PjTgc7lG48muv7ti7cn8r0ng5To+6Uy1k1+3XbEGZwxHmywZvfY9QlZle+1zXwaq7SarX4skr9w5blEhiDMk+8nKx4trZQE8q0Cc1VQuUj61vG7r9+7q78tDg9hDdZn6r9kaW7q3immVmTqtpQSMeDwmnKaGfY9/mq9YjtsBHZ0W2aHicXLiG+ncVRdOe4552IbNWu0DnfywLW0Uk/U+4u9cIglXQB4PY2bF2vRgWhZVM0KBQuOfG+2rE2FQu19CIYe5jgRdJMZZrU1/78f376oYh56rBhehIG/ABHQRBHGSjrlrfn5Tq+HMGYogtc9UdPcpjLOpyZ0YQwyNUp2UGEltWXQFm4e1/7CoU/4bNEA7IdjY6uPGPyaPNYPilo8exUpyF7unfRKJ9o6rEExQrnkon52SVZCBaZrRt6bptz8KTA0Z6vot/M+bYDgxPB30uWhA7b6LWiGdc33xM36TKKlQQ4HbkJCRF10z/fDi8QlilIQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============6118825193041384337==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> signal: Support userland fds in pidfd_send_signal()

TL;DR: userland_send_signal() may miss a child forked by a parent outside the
userland's PID namespace (e.g. after setns()), so a broadcast SIGSTOP/SIGTERM
could skip it; otherwise the commit message needs narrowing.

> diff --git a/kernel/userland.c b/kernel/userland.c
> --- a/kernel/userland.c
> +++ b/kernel/userland.c

[ ... ]

> +int userland_send_signal(struct file *file, int sig,
> +			 struct siginfo __user *info, unsigned int flags)
> +{

[ ... ]

> +	scoped_guard(rcu) {
> +		read_lock(&tasklist_lock);
> +		idr_for_each_entry(&pid_ns->idr, pid, nr) {
> +			struct task_struct *task = pid_task(pid, PIDTYPE_TGID);
> +			int err;
> +
> +			if (!task)
> +				continue;
> +
> +			err = group_send_sig_info(sig, SEND_SIG_NOINFO, task,
> +						  PIDTYPE_MAX);

The commit message says the signal is delivered "once to each thread group
including in-flight forks".  Does that hold when the forking parent is not
a member of the userland's PID namespace?

The delayed multiprocess signal handling only reaches a child if the parent
itself is in pid_ns->idr, so that group_send_sig_info(..., PIDTYPE_MAX)
hits the parent.  A parent outside the userland can still create a member
process, for example by calling setns() on the PID nsfd from
USERLAND_GET_NSFD(CLONE_NEWPID) and then fork().  A later patch in this
series, "fork: Support CLONE_INTO_USERLAND in clone3()", also lets
subsequent callers join the running PID namespace.

In that case:

  parent P (outside pid_ns)          userland_send_signal()
  copy_process()
    alloc_pid() -> idr_replace()
      child pid now in pid_ns->idr
                                     read_lock(&tasklist_lock)
                                     idr walk: pid_task(child, TGID) == NULL
                                       -> continue (skipped)
                                     P is not in pid_ns->idr, so it is
                                       never signalled
                                     read_unlock(&tasklist_lock); return 0
    write_lock_irq(&tasklist_lock)
    fatal_signal_pending(P) == false
    attach_pid(p, PIDTYPE_TGID)
  child runs without the signal

The comment in copy_process() already notes "If current is not in the same
namespace, we can't rely on fatal_signal_pending() below", and only the
zap_pid_ns_processes() case is covered through the PIDNS_ADDING check.

Can a SIGSTOP, SIGTERM or SIGHUP broadcast miss a process that is being
spawned or exec'd into the userland at the same moment?  Should the walk
cover these entrants, or should the commit message and the DOC comment be
narrowed to forks by member processes?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/44972669664
--===============6118825193041384337==--

