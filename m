Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E414606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 05:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AJHnCTFZ
Received: by kanga.kvack.org (Postfix)
	id 212B86B05B4; Wed, 18 Nov 2026 00:09:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EA656B05B5; Wed, 18 Nov 2026 00:09:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B2276B05B6; Wed, 18 Nov 2026 00:09:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C96C66B05B4
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:09:52 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0C2DE120664
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:09:52 +0000 (UTC)
X-FDA: 85447062624.12.806139C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5985240003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:09:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AJHnCTFZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794978590;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YTkB6IegYKkCKN9TMyQsZjUMGenXx9DRYi/wt9UPTmg=;
	b=ZNCzTfOvQMtlWR84dhK5kPk7TKCj+UWQyXwwhoA6gLxFb9lh+00mrsk+PWh3iU1+VaIwLH
	DLUrPTaaqK9CkvuV4Dm7Op/QO7dHOluT5i4GVPaSlSM5wIfTbg6N03PzxqvrXljdbDCQp6
	MTYQTL8y/0ugOIs/TZvCIYdxvHnlupo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794978590;
	b=TsqxXwSmOeSju8u3eIittqh/0jNnNeMw6cEXUl0D3Z2XkrOiqNm5/8J7/fZ7bvWVheT3mw
	BGM16PaxU2+EKQhpjpIEyHebDQJ7A5u8L2XJPwefy29vPmBwK6ruPSDXuVKKkFvToTAB/o
	YdkES7gRcMNdA0uFOMjvNAzpAlLigX0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AJHnCTFZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B122D4088E;
	Wed, 18 Nov 2026 05:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F751F000C4;
	Wed, 18 Nov 2026 05:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794978589;
	bh=YTkB6IegYKkCKN9TMyQsZjUMGenXx9DRYi/wt9UPTmg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AJHnCTFZOlT1hBVJ/ns2h3RREYp++TG43Nzlfhh3u26BmU9sAUTT8AOx3CZGOFzSq
	 l0vQ/tQIvCwKAfcAKwEse7RAODQyHQPC1Bhx3a/wp+beqeS0Y95RzBlvrSYt25IZxy
	 NkeRwlwVyJsPik5HkrtdUYn6dML/oB7nn6BxRG/nq2QrqQO1/3QPXAKgaxG64SZw39
	 b1i57klcqPtQoR6zTrdfBlrp2BTGgmuOSyIstpgGbfVBeO+qZBQxh8xKvuoRT/dRw8
	 9G9xhqvr9MI9j6mxByShb79pTTgdw3Iq9MpJvSN4yzcq+hxVkvzsic7XzN2vi47rmn
	 ++sZNGT+a6RdQ==
Message-ID: <sashiko-outbox-220141@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 06/13] rootns: Add rootns_kill() system call
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Andrew Morton" <akpm@linux-foundation.org>, "Ben
 Segall" <bsegall@google.com>, "Christian Brauner" <brauner@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "David Howells" <dhowells@redhat.com>, "Davidlohr
 Bueso" <dave@stgolabs.net>, "Dietmar Eggemann" <dietmar.eggemann@arm.com>, "Ingo
 Molnar" <mingo@redhat.com>, "Jan Kara" <jack@suse.cz>, "Jonathan Corbet" <corbet@lwn.net>, "Juri
 Lelli" <juri.lelli@redhat.com>, "Kees Cook" <kees@kernel.org>, "K Prateek
 Nayak" <kprateek.nayak@amd.com>, "Liam R. Howlett" <liam@infradead.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Manfred Spraul" <manfred@colorfullife.com>, "Mel
 Gorman" <mgorman@suse.de>, "Michal Hocko" <mhocko@suse.com>, "Mike Rapoport" <rppt@kernel.org>, "Neal
 Gompa" <neal@gompa.dev>, "Paul Moore" <paul@paul-moore.com>, "Pavel
 Tikhomirov" <ptikhomirov@virtuozzo.com>, "Peter Zijlstra" <peterz@infradead.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Serge Hallyn" <sergeh@kernel.org>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Steven Rostedt" <rostedt@goodmis.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Valentin Schneider" <vschneid@redhat.com>, "Vincent
 Guittot" <vincent.guittot@linaro.org>, "Vlastimil Babka" <vbabka@kernel.org>
In-Reply-To: <20261117050841.3289652-7-jarkko@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
 <20261117050841.3289652-7-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 05:09:47 +0000
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5985240003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 69t4e3szczktn6aiynbn55mmbcmyumms
X-Rspam-User: 
X-HE-Tag: 1794978590-969629
X-HE-Meta: U2FsdGVkX1+eKVq8LdBrSZ2KdR3MfRD7SVBmM4y7HnSG5tKy354wfr5DOxgCCdyjMSUN2zdYHVielFQu1r4uP5m2EmUfzzrD8d0xj1EJOcBqf+AKcp4y9vA7DqyyhsU4UFyi/9z2AyZepI5DdBFi7QXmF3eQRcGHTSxDMrJIMZ8syI6Aty9zWmWd/XNUSwfw/MtX3zl7pm+MLdPEKTEShf2KPKG4GQ9MoZs0vv4XfsGcJR++WoCHIfHkzF0377CZTrZM+ipTRzYvwPyPm8I+5BAFTjRXvmxjeULDwoCnuHfwTdMAmSUPcv1zaKtuctZaez4S18sO4TTobSb6p1J/iIz6t4iiOAhhjaDzyYNwTmW49hRoVVoM+vzGR3rCj+pbDGPi/XSAdOf5KyRxV9fsypZ5DVXQA12jAC5JQBZvdZvZq8A21AChTpoHDUrpReK8lW3nnsSXmg+CkEcN2vSOlz70IcRuFRe1esyu/sv1pySVtQezlGMB0AVzbiXoyXM+AJlLM/AZem8h4MRsBh/WGsXKodxSrDoZJnKo9qnJoN5TlLWQTVbMCozWEqePO9a5/qOWznXr8mQBcwCaW6hbUwfSDH2Cqz/tx2TuDkSATqRXLrTMH3LE2rL1e0GAf0piRJiGpnJx02PyzZ1E7xOnlzBxr5umLYwkIUszR+lhHO+RI81Wb9/s/BCYfqvr4wTxioIDDYue9xZsmBJLV+sBg8+VPq/5knoKL4nhzrqTNegQNm3m/RrdYz8FTeAfwvDOBwmLsYR0yxPG4KzHDxvGQoaiSFo/ZL+0WFSiRgJm2VbVUf3fT8koar98ppC1hzQMmUAPIotrr7bMbit9lqSX9GC3q0yHTnHMWDtunbTA12MLPjKmQ5CpRU7FqdAY4yqzpGlIU0xi+zrNaMebQ423Xx4xmDmKlWR5kMfNKU/NY3qLXFl6xcha3N6zbFLcZHT8YIp9GIEnX3xSGxqRT7w
 U+lHLc0Z
 UuO+vP5iYetW0JJ0EYuLn6jS01gwDEkshObtOcWkcApnjIV7cWo8T45VJWOhKoMh3ps0qwIWZzTgYb0m7R/Y0F8ZM68zOn4oVd7CGiURhBI6nRVBQAu8E9e2vHTjtjNq82O0+WvvLeLEpI8Sf+OW9f+wtTGbP1smAjrK6s3AH3J0bRwPZR/MmdRTJDMjhGC7hUlMCu4DCAtBtV+qocdHaWasRKGethpHidnXObL4bgdJHF3UXqTzP9uIBbxSU6ZwSjMj3901H0JB+Rario1+6vlMqhliPSDhnDk7wWifUfM4496RpAaFCtpzl9j3ekBz7ecic7KbHrpWDp30FOZVgdyN8MejvH1Y7AoaG0p5K3m0hq3r8FffG/22XBTVfIEcfmLlteR4naJOUFO2tC7MaO5SrLnapQBu13D6hgV35gUem+C/QcVfgqlMwcv6s5zL3Pdj7m62AeOHH4MmaVJXouUmV0+y2zfo/+V1nsuY7E3M6WA9MjgeETq2hcz6xIVYjTD1lmfgewxHMDj3y7BubTAT2EIm9dymPSKdf5I0Cw/MmqGmK+4lhyrHjH3DWGz76XjGTwn2UvHAxb7jYQ+Bs93V7uCT5lggSgPZpa5t8iJmklMJXOsA0EzFAevB49PQz0V46/coYiiP0Aqk=
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
- [High] rootns: fork() race in rootns_kill_members() missing
  tasklist_lock
- [High] rootns: missing PID namespace ancestry check in
  rootns_kill_members()
--

commit af3e55bb2ee92ebb14699cd9c72b34e3ddb26ffe
Author: Jarkko Sakkinen <jarkko@kernel.org>

rootns: Add rootns_kill() system call

This commit adds the rootns_kill() system call to walk a root namespace's
PID namespace IDR and send a signal to every member thread group.

> diff --git a/kernel/rootns.c b/kernel/rootns.c
> index 8a1254db69df7..f59b2fe9910de 100644
> --- a/kernel/rootns.c
> +++ b/kernel/rootns.c

[ ... ]

> @@ -390,3 +391,67 @@ COMPAT_SYSCALL_DEFINE4(rootns_wait, int, rootnsfd,
>  	return ret;
>  }
>  #endif
> +
> +static int rootns_kill_members(struct rootns *rootns, int sig)
> +{
> +	struct pid_namespace *pid_ns =3D rootns->ns->pid_ns_for_children;

[Severity: High]
Should rootns_kill_members() verify that the caller's active PID namespace
is equal to or an ancestor of pid_ns before delivering signals?

Without an ancestry check, a caller holding rootnsfd in a sibling or
descendant PID namespace can signal processes outside its PID namespace
hierarchy.  Because kill_pid() passes SEND_SIG_NOINFO to
send_signal_locked():

kernel/signal.c:send_signal_locked() {
    ...
	if (info =3D=3D SEND_SIG_NOINFO) {
		/* Force if sent from an ancestor pid namespace */
		force =3D !task_pid_nr_ns(current, task_active_pid_ns(t));
	}
    ...
}

when current has no PID in task_active_pid_ns(t), send_signal_locked()
treats the signal as coming from an ancestor PID namespace and sets
force =3D true, bypassing SIGNAL_UNKILLABLE and allowing SIGKILL or SIGSTOP
to kill or stop the PID namespace init process.

> +	bool any_success =3D false;
> +	bool any_other =3D false;
> +	bool any_perm =3D false;
> +	int other_err =3D 0;
> +	struct pid *pid;
> +	int nr;
> +
> +	if (READ_ONCE(rootns->state) !=3D ROOTNS_RUNNING)
> +		return -ESRCH;
> +
> +	scoped_guard(rcu) {
> +		idr_for_each_entry(&pid_ns->idr, pid, nr) {
> +			int err;
> +
> +			if (!pid_task(pid, PIDTYPE_TGID))
> +				continue;
> +
> +			err =3D kill_pid(pid, sig, 0);

[Severity: High]
Can a concurrent fork() still escape signals sent by rootns_kill_members()?

CPU0                              CPU1
copy_process()
  hlist_add_head(&delayed.node,
    &current->signal->multiprocess)
  ...
  pid =3D alloc_pid(...)
                                  rootns_kill_members()
                                    idr_for_each_entry(&pid_ns->idr, ...)
                                      /* parent: kill_pid() uses
                                       * PIDTYPE_TGID, so delayed.signal
                                       * is not updated */
                                      kill_pid(parent_pid, SIGTERM, 0)
                                      /* child: not attached yet */
                                      !pid_task(child_pid, PIDTYPE_TGID)
                                        -> continue
  write_lock_irq(&tasklist_lock)
  p->signal->shared_pending.signal =3D
    delayed.signal
  attach_pid(p, PIDTYPE_TGID)
  attach_pid(p, PIDTYPE_PID)
  write_unlock_irq(&tasklist_lock)
                                    /* child escapes SIGTERM */

__send_signal_locked() only records signals in t->signal->multiprocess for
in-flight forks when type > PIDTYPE_TGID, whereas kill_pid() passes
PIDTYPE_TGID.  In addition, because pid_ns->idr is walked without holding
read_lock(&tasklist_lock), a parent at a higher IDR entry can fork and
attach a child at a lower, already-scanned IDR entry (via PID wrap-around
or clone3() set_tid) before the scan reaches the parent, allowing the child
to escape even SIGKILL, or rootns_kill_members() can observe
pid_task(pid, PIDTYPE_TGID) before attach_pid(p, PIDTYPE_PID) completes and
get -ESRCH from kill_pid().

Holding read_lock(&tasklist_lock) during the IDR walk and signaling via
group_send_sig_info(sig, SEND_SIG_NOINFO, task, PIDTYPE_MAX), as
zap_pid_ns_processes() and kill(-1, sig) do, would close these races.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117050841.3289=
652-1-jarkko@kernel.org?part=3D6

