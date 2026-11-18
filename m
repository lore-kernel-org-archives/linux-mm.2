Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8532606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 23:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k2EHjrdO
Received: by kanga.kvack.org (Postfix)
	id 9B2E96B0635; Wed, 18 Nov 2026 18:15:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EED66B0636; Wed, 18 Nov 2026 18:15:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DCC06B0637; Wed, 18 Nov 2026 18:15:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 323996B0635
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:15:20 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 949AB1208E0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:15:19 +0000 (UTC)
X-FDA: 85449797958.04.F74B7D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id DD3B716000D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:15:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k2EHjrdO;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795043718;
	b=F6pprRlgBJLviK0KBRwGl/d9ZpMi1/PMEZwBQyjGRxOJCTw01fPL2Zisgzsp0uoEwy4wLt
	q3inY4lL6FKQXKmbth3gcq4aBE9hgrXg6zdpJSWe+OfPBLfii02seWy8030znneNUPejYi
	6FYEGGmCw0wOdxk0vaBYjmvBum+fPGY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795043718;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F+/dq5bMDr1Qk9X1QNnZwwuwwn6jJ4gYLypHwsySwcY=;
	b=gZztYoLDXdznvjK+D8wVq6GAVwacT7+14LV1gRv7I9mS2SRCmErBePRdgE3VCaKUFryxLH
	wA0IA83hQ3F4bW3aUK1/kNljZs+DAJkwgS2ybVArFqJNK6vpkLUvDQ6BLpexflOBk97ihR
	fUAePLsk11S9Hf4VjYpgbPsfQ5HlWjI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k2EHjrdO;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8201D641ED;
	Wed, 18 Nov 2026 23:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835271F000C4;
	Wed, 18 Nov 2026 23:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795043717;
	bh=F+/dq5bMDr1Qk9X1QNnZwwuwwn6jJ4gYLypHwsySwcY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k2EHjrdOFeLkTioyxvuz2DLyPOHOOKRanzAIL1jkKtcYLFVmA4ztYe02aYf5BxWVd
	 VUELinKB45mjXqRpk1/oxju8SVVYJtkqs1B1CqsRA7IMdtDJef2Pvy554AOQxosmQ5
	 8J9nohPw9nyZ6J1xeQ8hvl1bgjt+oHdm/bKo/nSyOtDPMevQLiubzzPCrP98JLWWPH
	 f/8JP/IRwQBlYmyrHa2aop0cua+dbt0avT6trSsyB0UGx3zaCJPFKK89KXPUAlMv7v
	 wm6U6ZN5cQBbJfPuhvDyVY1y6BFRewpm2ThwbxH/7SKixBIb3PAHGUlSDP0rWRYJCd
	 f4ocfHO29OKgA==
Message-ID: <sashiko-outbox-222160@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 06/13] rootns: Add rootns_kill() system call
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
In-Reply-To: <20261117231352.3816603-7-jarkko@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
 <20261117231352.3816603-7-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 23:15:15 +0000
X-Stat-Signature: tudcrn95nxzfqb5sh83kgzzixxwy9e3b
X-Rspamd-Queue-Id: DD3B716000D
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795043717-138564
X-HE-Meta: U2FsdGVkX18ff60uu2BQk8e20eTD3ut6jzIpQhBFHl5NQ/B7leALx6wETJi2mURBA1r3ObzaFt0uebNM24PfR0cJW3BCrkNgLVrVQ/qskRO6lrgUfa8roy0+ALYPnLGXvaxt0CRPHDnL1hYm1xQmBdbXUpWkNucgAzCYwy0us0Tn9/JWCef5x1el7cMsUnksva4KvnmbKTTd3vECPLS6WFvH4tJWz3g8bhIuK4eI7UuvrasXkNLBhKLI4Cp4E7YWh3LB/bWRe3GE+0r0bbgDEmU7mAPqmE76hjOHg+XtQXxa6FdIZ5keM8jiL+q4fDLLPcFH9j6daEA73VF50rWTGIa5pe73/zS5DaA4nMP/iE0ONlwGeOxPfD+HDCuICAaQkqSqvjCaAPo3VwWMTZkR/piBSTopZD6kXLhaLcku5KJObAnqyGRL/3npVpWwNOGOKk+M48HbbdTr5yoDS5e5cDvqzpzr6JujBj6Dy0AsVJ3J1yQdGCAOTkqRfJlcv07RL44206H0tG5+1Eu0gr4ZHFLKGTWjH2aXZPimQ7Y0cwI+bWJ9w80357qomPFaShJsC4Qjy4LmoHAjJU0Gtn5ggdAjATXWytpkyfv0m4JA9f1xVdlpHmcnBZ4JQLru1rJP3j8tWXM7a64f6jbep2O0cSk8PzHzH/D/NbmAtV9x1IrJLHiJwnluCYeY3jz8rG0c1gDeAZ84AhZASnkCcAcKnHjXPfe0gMxS9bEq/SJEjABRmQwhNmXAsRECoEq+1+81GM4rqlL8aAVVZuXfSIWM1fgaobTmzf7huIht4cMIbPSwAGD1jic8BTbEX44tl2OzuJYE08EcPbUL+X0crqNZWOLaXJiAPnP4YDEfMnV/1gKpctsgj1ynDXKV80oK2c5vlTkE51bUstmdjArRVjCt0MpLV4HbfGzzrJ04VNwxgX/F5a9ioNOUbC8xlzqknKAG6wQtyBvD5T8duLKsSJH
 bKUrsd2C
 Ef+rzQOCOeooGVXtWKy5+Ka6gQTFz9PMMHoUbl2rUmiEEHQA5r360Msh4kbuCGdCplyxjAY8mMzX3AcUzn3zsEsrzg4Ki4stXpAsUdac/crisJJSWt0aEjkkalieFtACDkHhaVuK8EV+fXhIKZeao0dfiGxhRxsAgZTg2pVBo3kt4cOJHjypIaKnyCy0j+yMowO6WUOtgRYB5xzeTm/IL7Skp34GdcaGj+B2dchVVIlHuOmDw5XEiuejIQyGoIbrpz/A1SCQCNAxg/QVuM0d3gN6Wo0+yhf4enOHiOlMwj6Bg1H4Dyqc+Ui1jZCrg6dOcCzEcSWQ5MBt+VKvLnp4INUeR3EIODqYfJ+wZqtGKkR3fVADPH6+XOTxMybVzlcaUrgZM8LWL6kajUXGI9o24ZACqbtFt3GkaipGLhG1ib9dFkNq8FF7tOnjKhimR3elpdJzTN3xY5M71o0+wcJL2azUw+S6Mpop8w0hC/mACmnRNDQD+Yjg8g4avCx7W93nrvDvQWOOV0oj3AMpTcUC9tLYOPC9U4crNSiddfMGUXAB3HNIO1CuhN4+TH9PjJEXS0leSG9RJ0yHrSl4foXtYHeJYR2SvG8uImfWw2i5EhovmNA/qZJF4d6oq3t+d3KkUMgz80LlLBPirELMQjdCHlYNkQscQqoH5GF1iPEIrcKYD4nPUD5/7y3r5A6i8JsC5adlsqWLFzhhrz6uGEF+oJgQjry63jafonXaPr6sarsheNYk5tEnSg2IAIgRAZIf/Q+sodoMouA68cU9B/eKjmmHF3AQKozBSSsjk
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

commit ea67311730397795196206953e1b7e54d487cc13
Author: Jarkko Sakkinen <jarkko@kernel.org>

rootns: Add rootns_kill() system call

This commit adds the rootns_kill() system call to walk a root namespace's
PID namespace IDR and deliver a signal to each member thread group.

> diff --git a/kernel/rootns.c b/kernel/rootns.c
> index 83ab759a31ecd..90a070dbf4a82 100644
> --- a/kernel/rootns.c
> +++ b/kernel/rootns.c
[ ... ]
> @@ -389,3 +390,67 @@ COMPAT_SYSCALL_DEFINE4(rootns_wait, int, rootnsfd,
>  	return ret;
>  }
>  #endif
> +
> +static int rootns_kill_members(struct rootns *rootns, int sig)
> +{
> +	struct pid_namespace *pid_ns =3D rootns->ns->pid_ns_for_children;

[Severity: High]
Does rootns_kill_members() need to check that the caller's active PID
namespace is an ancestor of pid_ns before delivering signals?

kill_pid(pid, sig, 0) passes SEND_SIG_NOINFO to send_signal_locked():

kernel/signal.c:send_signal_locked() {
    ...
	if (info =3D=3D SEND_SIG_NOINFO) {
		/* Force if sent from an ancestor pid namespace */
		force =3D !task_pid_nr_ns(current, task_active_pid_ns(t));
	}
    ...
}

Without a PID namespace ancestry check (like access_pidfd_pidns() in
sys_pidfd_send_signal()), a holder of rootnsfd in a sibling or disjoint
PID namespace has task_pid_nr_ns(current, task_active_pid_ns(t)) =3D=3D 0.
That sets force =3D true and bypasses SIGNAL_UNKILLABLE in
sig_task_ignored(), allowing a non-ancestor process to kill or stop the
PID namespace init with SIGKILL or SIGSTOP.  A caller in a descendant PID
namespace created inside the rootns can also signal tasks upward in its
ancestor pid_ns, while a caller inside pid_ns itself has force =3D false so
SIGKILL and SIGSTOP are ignored on the rootns init process.

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
Can a concurrent fork() still escape signal delivery in
rootns_kill_members()?

CPU0                              CPU1
copy_process()
  /* queues delayed.node on
   * current->signal->multiprocess
   */
  alloc_pid()
    /* inserts child pid into
     * pid_ns->idr (tasks[] empty)
     */
                                  rootns_kill_members()
                                    idr_for_each_entry(&pid_ns->idr, ...)
                                      /* child pid: pid_task(..., PIDTYPE_T=
GID)
                                       * is NULL -> skipped
                                       */
                                      /* parent pid: kill_pid() passes
                                       * PIDTYPE_TGID
                                       */
                                        __send_signal_locked()
                                          /* type > PIDTYPE_TGID is false;
                                           * delayed.signal not updated
                                           */
  write_lock_irq(&tasklist_lock)
  p->signal->shared_pending.signal =3D
    delayed.signal;
  attach_pid(p, PIDTYPE_TGID)
  attach_pid(p, PIDTYPE_PID)
  write_unlock_irq(&tasklist_lock)
                                  /* child never receives sig */

__send_signal_locked() only records signals into t->signal->multiprocess
for in-flight forks when type > PIDTYPE_TGID, whereas kill_pid() uses
PIDTYPE_TGID.  For any signal that does not make fatal_signal_pending()
true on the parent (such as SIGSTOP, SIGHUP, SIGINT, or a caught or
blocked SIGTERM), the child finishes copy_process() without receiving the
signal.

Because pid_ns->idr is walked without read_lock(&tasklist_lock), a parent
at a higher IDR index can also allocate a lower, already-visited IDR index
for its child (after PID wrap-around or via clone3() set_tid) and finish
attaching the child before the scan reaches the parent, escaping even
SIGKILL.  In addition, copy_process() calls attach_pid(p, PIDTYPE_TGID)
before attach_pid(p, PIDTYPE_PID) under tasklist_lock, so unlocked readers
can see pid_task(pid, PIDTYPE_TGID) !=3D NULL while kill_pid() still sees
pid_task(pid, PIDTYPE_PID) =3D=3D NULL and returns -ESRCH.

Holding read_lock(&tasklist_lock) and signaling via group_send_sig_info()
with PIDTYPE_MAX (as zap_pid_ns_processes() and kill_something_info() do)
would serialize against copy_process() and populate delayed.signal for
ongoing forks.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117231352.3816=
603-1-jarkko@kernel.org?part=3D6

