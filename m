Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04746606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 19:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=owrSWS1F
Received: by kanga.kvack.org (Postfix)
	id 232E26B069E; Thu, 19 Nov 2026 14:36:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E3D96B06D0; Thu, 19 Nov 2026 14:36:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F9CE6B06DE; Thu, 19 Nov 2026 14:36:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC7546B069E
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 14:36:57 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 56E081C46A3
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:36:57 +0000 (UTC)
X-FDA: 85452876474.19.4830975
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id A35A4C001A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:36:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=owrSWS1F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795117015;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VNM+7RVYDMfJcBD0bitBmq9dsNdnP+e2PrcUcBzEF7U=;
	b=HC1ZVmPbzMI9BZ6LKcXlRu/3XLvFuhsjGjxJTQ0nX4U7SEWp8bXcqaU+oLhjZXs06va5XR
	7uc6Sum5e57KLfeANlgj6Ivou3jo+787kCHg6h00EbwABKPyXWXfi+hIveGNWlpW3Ki1K5
	x2KSEJxTUZAH1W48lp+MYglDBU04dMc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=owrSWS1F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795117015;
	b=af1Ml4pkh58vd98vPAkj+ZJEeYwUIaza1KabZN7guOsUW3Q+YY0Sy+dSl8Lsm3cWbSjPw2
	cuAa38eqriPYm5yYcO4oubdEloRzpoQIKzauMGZYSghYDrNY00a0vFJ2IVbzBVcbs9n1Lm
	/jY0fmxvpyF+dJakD/YCVTzYPq8eHcg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2CEA445127;
	Thu, 19 Nov 2026 19:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C261F000C4;
	Thu, 19 Nov 2026 19:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795117014;
	bh=VNM+7RVYDMfJcBD0bitBmq9dsNdnP+e2PrcUcBzEF7U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=owrSWS1FsstagbuZ/jERHqlbcvoDtYvMNFddXXZmwRBNjjOa+PdL498x5idmBTC8v
	 yoA7K0aPH6q4N7ZoWFeOCofHW2RDkCjWEj9aQvv4cFbSz61dqNFGcMQmuKQZu4lBq1
	 0q+W5smUlWBitu7XmqR45NoSbC/4g9He7o4Y+q13eL6rxc4ZK5jLVdZaVxNw/XKimS
	 zJiz5y4mpZZ7VZMWU3jyJHn9Hpr3yZTAmwFJ3OP28st9KBK7BDWtOeiGnDeb3S4A34
	 8Ul6+zRWGmczZ9XE0Cc/WVunzqTccCefb9KxG/Szr7pZcXt7Bos9fO3yPglwtaXesR
	 BqIO50JkVd+yQ==
Message-ID: <sashiko-outbox-223947@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 05/13] rootns: Add rootns_wait() system call
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>, "David Howells" <dhowells@redhat.com>
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Andrew Morton" <akpm@linux-foundation.org>, "Andy
 Lutomirski" <luto@amacapital.net>, "Anna-Maria Behnsen" <anna-maria@linutronix.de>, "Ben
 Segall" <bsegall@google.com>, "Christian Brauner" <brauner@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Davidlohr Bueso" <dave@stgolabs.net>, "Dietmar
 Eggemann" <dietmar.eggemann@arm.com>, "Frederic Weisbecker" <frederic@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Jan Kara" <jack@suse.cz>, "John Johansen" <john.johansen@canonical.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Juri Lelli" <juri.lelli@redhat.com>, "Kees Cook" <kees@kernel.org>, "K
 Prateek Nayak" <kprateek.nayak@amd.com>, "Liam R. Howlett" <liam@infradead.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Manfred Spraul" <manfred@colorfullife.com>, "Mel
 Gorman" <mgorman@suse.de>, "Michal Hocko" <mhocko@suse.com>, "Mike Rapoport" <rppt@kernel.org>, "Neal
 Gompa" <neal@gompa.dev>, "Paul Moore" <paul@paul-moore.com>, "Pavel
 Tikhomirov" <ptikhomirov@virtuozzo.com>, "Peter Zijlstra" <peterz@infradead.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Serge Hallyn" <sergeh@kernel.org>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Steven Rostedt" <rostedt@goodmis.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Thomas Gleixner" <tglx@kernel.org>, "Valentin
 Schneider" <vschneid@redhat.com>, "Vincent Guittot" <vincent.guittot@linaro.org>, "Vincenzo
 Frascino" <vincenzo.frascino@arm.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Zygmunt
 Krynicki" <zygmunt.krynicki@canonical.com>
In-Reply-To: <20261118193539.240065-6-jarkko@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
 <20261118193539.240065-6-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 19:36:50 +0000
X-Stat-Signature: uhfdw77qntgftb66o1u549q4tthtz3um
X-Rspamd-Queue-Id: A35A4C001A
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795117015-649862
X-HE-Meta: U2FsdGVkX1+Ffvl/dG6z/vFv5TqPmUfm3+aakOOsOsYaMmFGgdIDh9IxlFYJItAf+X+rqyih6njN+5TyIyeDZn5UHd+OSoIK2+J97ZLYpU9aIsa6mwwBZ0VXSOYbCDOt4gXNn+H08FYQItQ93Syo2f/VgVNkY8U+gpvtT2dgovi2enrmiD6yTWptF3+K0x2FX8a7IH1PUZFGlvQbJKgn9/qc14XAJI1wqIaeRZyPSyOUqfd/FBgun2FdoLeCMTTCF3PT/PU2G9krJvTJhyWWXHkAHUMPOa80+x9s7AWB2z1t3qVDLTugTQRzo2p1bMIJ33lkYtJktzh4F1font9Gd16O4/rLqbFtN1Ldtb8VwnaDoZaTKiK4ntXwZmhUH4HLpa2IXHgcq+/LFsQtv4JMejnTDCerGcGqABjAl916mcJruqbZ8TLmMw0yVG87c7i3wCq3WEDiG1feY3uMOR/ccehdpF3HhKi8TxVQJdpkJea8RFzlIJSYVkp7h7IJdogIMsVqz6S6CgagIJRiSNajCYwgM6j7msIx371yojHcPUWyj3GAnyMiCu7rERVPipZ2Xoxjyn3rV5F+hJrjI7LeaSmXb+NMe2R9ranpJN+2sUaR284rTDqjQOW8w510eNrrPZ+/P/E17Q6z7xTXAxlQ4SbFpHy0nX6vBM47Xa18Hhq165/kzxWz53tLNXAVRf4QoP+AavtIGxQIomZIQeEii46BI+esqAvWMtlsOZntFTEgQvwrdGfGDuKCzAPp/o5MJV8+Ou+73jyAL81YIsD4CMvRANcef3tQqtF38CMxeF3MoJtWfU+V6Po4Hpk2cVmBg8xCJdyIX9jA1tNuBULMo2q3/0aBL+9Z6BCU2EWT9VU8xWYwO1hD4mRObD7iY6h6/k98qtjVpuWDsN5HDP6PTSoQv9KyhB+Ta7eWH3sb2O5hoeX/DL8a8e5OCQvP2yNBndDhDw0xpZYqff78bhH
 VfD2yQxs
 Blr/v2XKGce10Pzkbl/vEwzBh4SSPXxyToz6Oyotu8ay1pF58Tt7pFcbddQMJl/69H0CwWVfChPtR/PM2xCURMHI8Xjqd0t41BOeY9itD4JfSTtYxrYQThQU+5ohQNk6xEluGAJcuVWPnESbeU2iTQzPfHCnk708VG7/ZTuJhxWKxO/4zTNlP6G9KoqqOFZcgBWQDO/I0acAy9OnUdcf38ypOcTR5rvIOUHbo31a8JV40eHTHE/SGc127iRW91hAO4KjVM/0++jItcU398EW+8Bx2J2D3oY5Ood71g/FVE5NA1/CC0axDl/kqh+txYC+zSG6fGAxoCIhJ5dT0w6e6RUNFiTSnOmNYMlWwl3D//tMNdreELekE4PNuN1t+B88dswYBORO0H+x4cWUc+vRm2DRRtWrd2anG73MnZl9xMArK18HSKrvwsGih88SgZ3ATfC24rRjD3V5VHgKaWua4gNpV/yIHZ3yyZK4MjZ6KcxiPgFefUUtwcxE/b8gQDRRS8KA8rL1PtVpfJsKcBMGYOzJZUuxN/lGySEuArezsGw8sm52qorNx2eTmxCOlfIaMKLaD+YxHF00WYtcUQfHqzb5JDwVdFD05C0V57JRUCSF2qgbBRX8rvOW/YRsqfkCeDjWDxP3qAqcw16g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] rootns: unreachable init_pid check and missing -ECHILD in
  rootns_wait_common()
- [Medium] rootns: non-freezable TASK_KILLABLE sleep in
  rootns_wait_common()
--

commit 8a805a3f4fb79d05bf397b0ae4fb7738f0017723
Author: Jarkko Sakkinen <jarkko@kernel.org>

rootns: Add rootns_wait() system call

This commit adds the rootns_wait() system call and its compat entry point to
wait for a root namespace init process to terminate and collect its exit
status and resource usage.

> diff --git a/kernel/rootns.c b/kernel/rootns.c
> index c420e36af603f..5582ff010ca53 100644
> --- a/kernel/rootns.c
> +++ b/kernel/rootns.c
> @@ -305,3 +305,106 @@ SYSCALL_DEFINE1(rootns_create, unsigned int, flags)
> =20
>  	return fd;
>  }
> +
> +/*
> + * Wait for rootns init to exit and report results for the caller.
> + *
> + * Returns caller-visible init TGID on success, 0 for WNOHANG when still
> + * running, and -ECHILD when init pid is not visible in caller pidns.
> + */
> +static long rootns_wait_common(int rootnsfd, unsigned int options,
> +			       int *status, struct rusage *ru)
> +{
> +	CLASS(fd, f)(rootnsfd);
> +	struct pid_namespace *pid_ns =3D task_active_pid_ns(current);
> +	struct rootns *rootns;
> +	long ret;
> +
> +	if (fd_empty(f))
> +		return -EBADF;
> +	if (!is_rootns_file(fd_file(f)) || (options & ~WNOHANG))
> +		return -EINVAL;
> +
> +	rootns =3D fd_file(f)->private_data;
> +	if (!(options & WNOHANG)) {
> +		ret =3D wait_event_killable(rootns->waitq,
> +					  READ_ONCE(rootns->state) =3D=3D ROOTNS_DEAD);

[Severity: Medium]
Should rootns_wait_common() use a freezable and interruptible wait such as
wait_event_freezable() instead of wait_event_killable()?

Sleeping in TASK_KILLABLE for the lifetime of a running root namespace
prevents the PM and cgroup v2 freezers from freezing the waiting task (which
causes system suspend or hibernation to time out and fail), blocks non-fatal
signals and job control, and counts every blocked waiter toward the system
load average.

> +		if (ret)
> +			return ret;
> +	}
> +
> +	scoped_guard(spinlock, &rootns->lock) {
> +		if (rootns->state !=3D ROOTNS_DEAD)
> +			return 0;
> +		if (!rootns->init_pid)
> +			return -ECHILD;

[Severity: Medium]
Can the !rootns->init_pid check here ever be reached, and what happens when
rootns_wait() is called before an init process has been started?

The kernel-doc for sys_rootns_wait() states that -ECHILD is returned if init
was never started.  However, rootns->state only reaches ROOTNS_DEAD in
exit_rootns() after copy_rootns() has already populated rootns->init_pid.
When init has not been started (rootns->state =3D=3D ROOTNS_INIT), a call w=
ith
WNOHANG hits the rootns->state !=3D ROOTNS_DEAD check first and returns 0,
while a call without WNOHANG sleeps in wait_event_killable() instead of
returning -ECHILD.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118193539.2400=
65-1-jarkko@kernel.org?part=3D5

