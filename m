Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99B58606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 23:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g8VnXoMm
Received: by kanga.kvack.org (Postfix)
	id A4E8E6B0623; Wed, 18 Nov 2026 18:15:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E0716B0633; Wed, 18 Nov 2026 18:15:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8530F6B0634; Wed, 18 Nov 2026 18:15:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4ACF06B0623
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:15:18 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A6C091208C6
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:15:17 +0000 (UTC)
X-FDA: 85449797874.17.330FA7E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 025A82000B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:15:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g8VnXoMm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795043716;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fXSDPFAH4x0QiTPRoLf3VmlQiasjSs0WRYQmJTXqARc=;
	b=YOm5lKYJv8Utk9GARG7ioJNbw9kiZw98GvIu4UDUXzj+hr1r62XzrtaqXcL2PFCpMkVPgk
	Tf2/MgPEfMtb5FJ7L9AH+LYPFDJO6i6zoc1/LR9RlBQ2sAiSgmG3H3ru9lKrZjI05L0c4T
	Zsg92IzZ65NURaRCWkIQgV5qNp2uKWk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g8VnXoMm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795043716;
	b=r0+gwO92huNVyESVn7KKjbAAHsNLRqwSNgr083MOST4Hxfe5WpAzj4Uq3DdU6chCBtGYwH
	s1mRjNZnvGnjQdlthEJ0YeCXrs+E8houm2AgMloD6jfhb+nTfhMyLJzVaAAMjZyS4/+Nl8
	/Vg5WRMrnGumfRWFeOgMcSuEVHdSjaM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 52060641DF;
	Wed, 18 Nov 2026 23:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FCC91F000C4;
	Wed, 18 Nov 2026 23:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795043715;
	bh=fXSDPFAH4x0QiTPRoLf3VmlQiasjSs0WRYQmJTXqARc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g8VnXoMmUpZ7dfVqetpcqXACVQcPx87LNPv04YiG7BqIG14HtJpwuSrXp2wUz2JR3
	 x+TcRSelZr6z/ly9hB8ZWQQR0aIljvHwbkg64wMIc8T2mu9XitffbuSW6MRoI09uiE
	 IeLoqSAoNAxP7lT2pBYHhKkpAppsUJ18DyayMRW5w9AIkJ13RSP3TQPzA0/L0jxHhG
	 Li6q8AaHYwAefBHg++a6Zy9A+1t3tsUcfnkzc+siMPohdjBOq3ifcgrMUvm2pSjMVD
	 jcVrTBs6+Qy1ElrP5oEF2xaXwSJGtBfUjgavDY7orFZCjtJQ3uyXoo4AkJyTDn0Bex
	 8Y4xQXCgywVgQ==
Message-ID: <sashiko-outbox-222159@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 05/13] rootns: Add rootns_wait() system call
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Andrew Morton" <akpm@linux-foundation.org>, "Andy
 Lutomirski" <luto@amacapital.net>, "Ben Segall" <bsegall@google.com>, "Christian
 Brauner" <brauner@kernel.org>, "David Hildenbrand" <david@kernel.org>, "David
 Howells" <dhowells@redhat.com>, "Davidlohr Bueso" <dave@stgolabs.net>, "Dietmar
 Eggemann" <dietmar.eggemann@arm.com>, "Ingo Molnar" <mingo@redhat.com>, "Jan
 Kara" <jack@suse.cz>, "Jonathan Corbet" <corbet@lwn.net>, "John Johansen" <john.johansen@canonical.com>, "Juri
 Lelli" <juri.lelli@redhat.com>, "Kees Cook" <kees@kernel.org>, "K Prateek
 Nayak" <kprateek.nayak@amd.com>, "Liam R. Howlett" <liam@infradead.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Manfred Spraul" <manfred@colorfullife.com>, "Mel
 Gorman" <mgorman@suse.de>, "Michal Hocko" <mhocko@suse.com>, "Mike Rapoport" <rppt@kernel.org>, "Neal
 Gompa" <neal@gompa.dev>, "Paul Moore" <paul@paul-moore.com>, "Pavel
 Tikhomirov" <ptikhomirov@virtuozzo.com>, "Peter Zijlstra" <peterz@infradead.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Serge Hallyn" <sergeh@kernel.org>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Steven Rostedt" <rostedt@goodmis.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Valentin Schneider" <vschneid@redhat.com>, "Vincent
 Guittot" <vincent.guittot@linaro.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Zygmunt
 Krynicki" <zygmunt.krynicki@canonical.com>
In-Reply-To: <20261117231352.3816603-6-jarkko@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
 <20261117231352.3816603-6-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 23:15:12 +0000
X-Rspamd-Queue-Id: 025A82000B
X-Stat-Signature: gkoggbqu47to8m3itghy8ypiy9d4cxju
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795043715-21768
X-HE-Meta: U2FsdGVkX1+hTyd8Oitz9/4/LaPmn+NgCb3Mi/RRJs7H3JSE8edQ6pE2hrEFS4OD3Olgs4qmoiFxPWP9FaZgnH9/Pn1SrwK2llkX0klOerWbyyFmfAUmxuKdWxf7G/ll1u4Lkl25VLPWcNWG7PNfOcyNv0ILc0I+s5u0UNrabU0yTkxKFPeO+U8ntIQvhxyZYpuR/41vg8fUVmKmdowQrMZtJCmCFvLUXMf8QqvK40R0y104QHkww1s5K1nnyB2Ucuk9N8pBQ+Zj4SYBZpMkYGs4SuQ50l+gxC8gqmPYhB5hOBwflxuBWNyL0ZZCwatr/l/zhv2TZRohBn3T3cMlxl8ghAvzlAqRcTXYzSVPfhi5vJqs0mrGz9xf5fI5EPW4dE7LUxVdjkWKX13I/1dATRfraaNayzo9SO9pFeT0ocHbPtovxxEm1CV5XWKzXyyNVwkA+OCQQ6NPWSlw3PEjS0LdGQyxO9nbZAmP4gNKIhhpcXQ9ul/3bxGuzgBf+q4jEJq7Xy2FTGUvjxPAib4341zUv+8BGWS5RZQE7P6yLkJFhmKvqRoGOsLnu+N5jHvdg02MhEbrIiVIgMuULKSYcy2P2IVeorJ/NiGyL7/ACSJIFMTOeWGFHp4IdFPev7rz4MnKiZEF/sDt8Ro4Dd/Kpgunbcjy7/CG2XmxL50at8v/+cCTxwGboX5S2hq2EV5d20+LlCSlfXg4NyOCpia1WEwr1btKJS9GARgy4UjTl519KWeMafgRRXtJUrPgPXFIcc3NJcxvGwYeX2Qeiw86Pg3nTlSMBBsPL83vOwWuQZFINGVUHMoMv4nhGyxAig4SaYvfGU3GiUPqUeYqainbmvapl6MhLPQ8XQc0E7FA6Os0/gi64j+W6Z5yt143MVDEVkX3w0rsXwslRLVOGFvFNjetyg0CxKHZLXfjh7CmPCl0nZiCqYNQXyAEdouLRPWez+qSXASqSmLHFy/RmlG
 kbHDUHn+
 Bdu4QjFdGUCmT+s5kXW/gAiqoXBbp6XtH0kO78yC/DGMy6sazprqds2Vfgy0wLopc7NzP0kiWM2P4gX2YIZp5A3Sqoh2hOCS5uG9qM18q7mE6a/6p/r7pW1GhFGV4sMu9n/vrhGpRBZ/hk66cqxQWibXAqyM9kwqLCookAVW008eXkFXIOrj/1zcQWrRMGzcv88DSnE5C+BaRY1z5wlSthScrU0GZsdFKnjJGnUCP9nZ6MQitJ8Kh5YEA/B1yZxBsAT15/Ox8xdTfvcPqrtdvvPthgZacoy7vD9IuSpP3o8WMk2cqvC4As425uHFUVKDYMTR7vSKBr4czO9ZM9FJmCmN73ffRRhxZcJzXQKSr5IxEgyf9CFSwcaQQCtqDTKENmnNgLCFTdger1rEDcO7eem+qxpQyfTW2ilUVSfM8xNYEmMQPPzZyJY3mkUM6DrkslD5ijSj5KMu7XrUu1EjDV+DiU4BU1hhW/hRTgDQ8bQaarPm08ylfb9AQwg/1C27itQzDivI7OzrqlDTPLZnvvid11ORuzuebeRknHiAcHFeETEtBp8qihpsKOqAmlRK7yDZWxCZKAE/JPhIS/YOqe/zWK8b4Pxf+GTfDPlyD/4BvPXpAP4fMsoz70eaZ3zx8pWIG
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
- [Medium] rootns: unreachable init_pid check in rootns_wait_common()
- [Medium] rootns: non-freezable TASK_KILLABLE sleep in
  rootns_wait_common()
--

commit ee16ae2e42910ad7c6f6428120bfc66d7f286658
Author: Jarkko Sakkinen <jarkko@kernel.org>

rootns: Add rootns_wait() system call

This commit adds the rootns_wait() system call and its compat entry point to
wait on a rootns file descriptor until its init thread group exits and
report its wait status and resource usage.

> diff --git a/kernel/rootns.c b/kernel/rootns.c
> index caa810b65d0da..83ab759a31ecd 100644
> --- a/kernel/rootns.c
> +++ b/kernel/rootns.c
[ ... ]
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
Should rootns_wait_common() use wait_event_freezable() instead of
wait_event_killable() here?

Waiters blocked in TASK_KILLABLE for the lifetime of a container are neither
marked TASK_FREEZABLE nor woken by signal_wake_up(), unlike do_wait() which
sleeps in TASK_INTERRUPTIBLE | TASK_FREEZABLE.  While any task is blocked in
rootns_wait(), system suspend and hibernation fail after the PM freezer
timeout, cgroup v2 freezing of the waiter's cgroup hangs, non-fatal signals
and job control cannot interrupt the wait, and each idle waiter inflates the
system load average.

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
Can the !rootns->init_pid check ever be reached when init was never started?

The kernel-doc for sys_rootns_wait() states that it returns -ECHILD if init
was never started, but rootns->state only reaches ROOTNS_DEAD in
exit_rootns() after copy_rootns() has already set rootns->init_pid and
transitioned the state to ROOTNS_RUNNING.  When rootns_wait() is called on a
rootns in ROOTNS_EMPTY or ROOTNS_READY before init is forked, a WNOHANG call
returns 0 at the rootns->state !=3D ROOTNS_DEAD check above, and a blocking
call sleeps indefinitely in wait_event_killable().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117231352.3816=
603-1-jarkko@kernel.org?part=3D5

