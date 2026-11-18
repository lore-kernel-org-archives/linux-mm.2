Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68745606A332
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 23:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RlG75yjz
Received: by kanga.kvack.org (Postfix)
	id 482A06B0632; Wed, 18 Nov 2026 18:15:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E5376B0633; Wed, 18 Nov 2026 18:15:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AE716B0634; Wed, 18 Nov 2026 18:15:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DDBCC6B0632
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:15:13 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5807CA08B4
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:15:13 +0000 (UTC)
X-FDA: 85449797706.06.DEC3644
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id B6C544000A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:15:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RlG75yjz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795043711;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=37KQFyYqNaiMVNsMx7OvyN5THAcOSDmWoKkeRI19o0s=;
	b=UaHeNNZPTfQCQ9GZdqmwPhBAsejRUOjzRqKZG11hLFnUlzIRJbNznAs0Box80ZkbQppQA3
	tC45d7wbLG/p3Pt5X+NLUvD56Mx0pWIBNCn9NMlUo9dLtynYyXRyoGxevaEmxPUXzcvgpR
	6vo6aJ/zGmsrbUnmF7xSKBLidNDrJQc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RlG75yjz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795043711;
	b=hdwC0kmUfT48nbY52lWwcIW4TsrOeFdQtQFatDNn9BaHbqoNsW1X1al1VGWn1WyAucInBK
	m/DIrzttZuljQ5boyZ/7OfxdK92caw+4JJJciK5G4wrMdhVphKuFSlt0373N1v7sjXkqET
	AigzzkbeXJuna8cwePoKBlCNEgzKVMM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E7C75641DB;
	Wed, 18 Nov 2026 23:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0BED1F000C5;
	Wed, 18 Nov 2026 23:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795043710;
	bh=37KQFyYqNaiMVNsMx7OvyN5THAcOSDmWoKkeRI19o0s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RlG75yjzShz6nLKZShB7DwOzVWp/unj9UCiEr0KvHCY16Q80QaEg60+IEiCW7p789
	 nsaj4QO3S4EoaPYSM0svgYQ7yl/Q6ghUZfRDBM+Ih7jMnxvFmp7SwpbA8ml3fa3gF6
	 irPSxbX2Rt9W/KJnAbA6K7a7+QX2+P/HzoW4Uy7JUI6l+J/zjUBj5xXamJWcDoujnG
	 NzBvtnPGYHdyIj5JcZ6poO6d8LHZ/c4e8H+tw71KWMsCFv5kZWD4eKhzpyhl3nPWCE
	 fbVEMUYCyAwq/MAshbqgC8qf5Amt6ct6It3pPSHpewiR/KSmUttsDX3ohzLtTzVtgo
	 nh4fFrdeHAVYw==
Message-ID: <sashiko-outbox-222157@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 03/13] rootns: Track init lifecycle via
 copy_process() and pid_namespace
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
In-Reply-To: <20261117231352.3816603-4-jarkko@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
 <20261117231352.3816603-4-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 23:15:08 +0000
X-Stat-Signature: hdrhdh7obdmr4euyz8kpc8q7fokbypay
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B6C544000A
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795043711-535287
X-HE-Meta: U2FsdGVkX18hDUmnvV/g8cgLfkxjzQ1JmjfHXlynBbsRy8kOe+PQfvPXJaqH9CWdywmVLfKfzLbcWn+GZBT/omwX+Q1oqeTmUVSQvRVhrQ7t75rn0XInUmNZF+2FP/NiLhULD8SfQBtKK4IQ0hzZBZGiwYKCohAV7gTvDiQp10WjuGhwPkF5mu+sqaNF+rtPOAdpIlXXwGIUJNpYzfZpwOvRRqtw9ugSCTY7RrJndbo/z9YOnxt6trj2n/de9HEXgXqNIhFA6h6BWTMqa8uqQi04UskrZ8xZmolt+hlGEg64Jya2s8z/yY5CUcNtmw44ZAF/20oWw7NL695kW6pruZk2Q6PkG91h8sCiTns4WSdmC463R5n7RXFAbybDVOWl8tcUvMi/FrAZKpGY1nD0XkjahWIBvpBcPE+kS4+E+eJA9gyo86wS0NpvqHBu2j3omSG5lBohexS3oBudP8b6bmlzeSILzKCW4A/ovzSUd8OBTVvfeTdtpCdez76+iVEnohoZWygzUFfN8zc/Ntotbfa6K6O+LS6KynVdO+6CgcWRk840bhF7dQw7rryM8f+40dI3fnk3wHS2+iIqtq/NwoOhSzHzJPuMFg0IRZzgDV0jSADWXrfVhacOJNl5FiXgpNpJ/ImTssp25nXt4Kx9Tn4Vhipa/LkKxUnXOItIZmeUuxW6C6GPhVWt5LfLL61X7p7TAfWOOBj4oXS5hzadrO+Zc+BuX4rMjfwNFIhjN1BQfLQO+T9ACo4y00f+RJbVFzD14q7n8ww6Ssp3ITJWiZsTEh0jBwDkdVwlhMjSAEML3nch0kgS0g2XXNmcXEXBZjcYhT/K6CNMebfEUcpLc5H2dSiYE57VcGU1c/N2JdPxsQ0/6A2GwJsPqwpSV+hYoHIrvsBj4mME1A6702USHgMsRjz9yIcx+2qDe1I/MMFcAZ+20w9VY9bFqoDeEa5+h9jLZw/6045rJc32tKJ
 DVZAZvPe
 rX57KrtCCkWDaVMFpZIZVR8IMf0/BWCAfgECmraGpSk1TLoBZm36bdxfuS3IGMRKrlUbIiPilmh/DV4NOCI+EM13PkJKwWaZ0F7O2/O1lzzGqYfkMwKZ0V6RUsTGM6wVTsJmDoxGjWVvWiYB63WxqmWdDU5nDFKwkT8u48NwNdhrr6j+yIxoWTdUnaeYVEgqxW3KKs5YLGHD8UdXXMsu9SaH0+gwt8iqaVH+25GPy+UpJu5GFNH0zRUhTGsCiWaOC0g+aiztQICVJ5Kd1QPfyUk2Rs6s3Dz3R9NB+CSZUtQyLIBexTTm+NCSLxzNGeQaWH8/RRvc9dLFFXhoXhMiSFDX0cg4bARUI+YVfg7mnttVIgCH0CQ3hOOVRX9fKNSfj+o+5dJeRaLo6zAZCaBvEpZ095cwxqQZJyYhfoaavrxGZ1NC+giOjwhzJyeDO9BKjOZIGHdHz8BiCZ1j6OQNU4CbByd4eK2nD58CADLNSuZW/eU1XyceuCIhuaKRoMHNORkIOUgw2Mh1IoarwGm95VN3S59tixhIjHa+EbyNaWMdjzLw/psVFZL/7u2Cn4gHxr8yZ3CX8blyUeHJb26TBKM1rJxtrH3zszG2NJ0vdIKCpja5t5RlGgW1uY9B71jQjfOD+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] rootns: unpaired pid_ns->rootns and refcount in copy_rootns()
  and exit_rootns()
- [Medium] rootns: copy_rootns() publishes init_pid before
  attach_pid(PIDTYPE_PID)
- [Medium] rootns: missing is_child_reaper() and locked state checks in
  copy_rootns()
--

commit ad1de852195b8caa7fd9ea3eac031f0716f9fc81
Author: Jarkko Sakkinen <jarkko@kernel.org>

rootns: Track init lifecycle via copy_process() and pid_namespace

This commit adds copy_rootns() and exit_rootns() hooks to copy_process()
and zap_pid_ns_processes() to record the root namespace's init PID and
capture its exit status and rusage when the PID namespace shuts down.

> diff --git a/kernel/fork.c b/kernel/fork.c
> index 5efceb8d58a78..99e22b3cd213e 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
[ ... ]
> @@ -2565,6 +2566,7 @@ __latent_entropy struct task_struct *copy_process(
>  			attach_pid(p, PIDTYPE_TGID);
>  			attach_pid(p, PIDTYPE_PGID);
>  			attach_pid(p, PIDTYPE_SID);
> +			copy_rootns(p, NULL);
>  			__this_cpu_inc(process_counts);
>  		} else {
>  			current->signal->nr_threads++;

[Severity: Medium]
Does calling copy_rootns() before attach_pid(p, PIDTYPE_PID) allow
__rootns_kill() to miss the new init process?

__rootns_kill() synchronizes only on rootns->lock (not tasklist_lock) and
calls kill_pid(), which looks up pid_task(pid, PIDTYPE_PID):

CPU0                              CPU1
copy_process()
  write_lock_irq(&tasklist_lock)
  attach_pid(p, PIDTYPE_TGID)
  copy_rootns(p, c)
    lock(&c->lock)
    c->init_pid =3D get_task_pid(p, PIDTYPE_TGID)
    c->state =3D ROOTNS_RUNNING
    unlock(&c->lock)
                                  rootns_release()
                                    __rootns_kill(c, SIGKILL, true)
                                      kill_pid(pid, SIGKILL, true)
                                        pid_task(pid, PIDTYPE_PID)
                                          --> NULL, returns -ESRCH
  attach_pid(p, PIDTYPE_PID)

If a ROOTNS_KILL_ON_CLOSE file descriptor is closed during that window,
the SIGKILL is dropped and the container init process escapes termination.

> diff --git a/kernel/rootns.c b/kernel/rootns.c
> index e75d918b93ec5..e3b203322ae23 100644
> --- a/kernel/rootns.c
> +++ b/kernel/rootns.c
[ ... ]
> @@ -105,3 +106,42 @@ bool is_rootns_file(struct file *file)
>  {
>  	return file->f_op =3D=3D &rootns_fops;
>  }
> +
> +void copy_rootns(struct task_struct *tsk, struct rootns *c)
> +{
> +	if (likely(!c || READ_ONCE(c->state) !=3D ROOTNS_FORKING))
> +		return;
> +
> +	scoped_guard(spinlock, &c->lock) {
> +		get_rootns(c);
> +		WRITE_ONCE(c->init_pid, get_task_pid(tsk, PIDTYPE_TGID));
> +		WRITE_ONCE(c->state, ROOTNS_RUNNING);
> +	}
> +	wake_up_all(&c->waitq);
> +}

[Severity: Medium]
Can copy_rootns() record a non-reaper task as c->init_pid or overwrite
ROOTNS_DEAD back to ROOTNS_RUNNING?

If a caller with may_see_all_namespaces() opens the root namespace's PID
namespace via open_by_handle_at(FD_NSFS_ROOT, ...), enters it with
setns(CLONE_NEWPID), and forks PID 1 before bootstrap, c->state stays
ROOTNS_READY.  Because copy_process() calls copy_rootns() for every
thread_group_leader(p) rather than checking is_child_reaper(pid), a later
bootstrap clone spawns PID 2 and commits it as c->init_pid.

In addition, c->state =3D=3D ROOTNS_FORKING is only checked before acquiring
c->lock.  If that external child reaper exits while bootstrap is in
flight, exit_rootns() sets c->state to ROOTNS_DEAD under c->lock, and
copy_rootns() can then overwrite c->state back to ROOTNS_RUNNING.

> +
> +void exit_rootns(struct pid_namespace *pid_ns, struct task_struct *tsk)
> +{
> +	struct rootns *c =3D pid_ns->rootns;
> +	struct task_struct *leader;
> +	struct rusage rusage;
> +	int status;
> +
> +	if (!c)
> +		return;
> +
> +	leader =3D tsk->group_leader;
> +	status =3D (tsk->signal->flags & SIGNAL_GROUP_EXIT) ?
> +		 tsk->signal->group_exit_code : leader->exit_code;
> +	getrusage(leader, RUSAGE_BOTH, &rusage);
> +
> +	scoped_guard(spinlock, &c->lock) {
> +		c->exit_code =3D status;
> +		c->rusage =3D rusage;
> +		WRITE_ONCE(c->state, ROOTNS_DEAD);
> +	}
> +
> +	pid_ns->rootns =3D NULL;
> +	wake_up_poll(&c->waitq, EPOLLHUP);
> +	put_rootns(c);
> +}

[Severity: High]
Can exit_rootns() drop a reference that copy_rootns() never took, or
dereference a freed struct rootns via pid_ns->rootns?

copy_rootns() acquires the reference dropped by exit_rootns(), but it
never sets pid_ns->rootns =3D c.  Even when create_rootns() later sets
ns->pid_ns_for_children->rootns =3D c without taking a reference,
put_rootns() frees c without clearing pid_ns->rootns.

If pid_ns is opened via open_by_handle_at(FD_NSFS_ROOT, ...) and the
rootns file descriptor is closed before bootstrap, c is freed while
pid_ns->rootns still points to it.  Forking and exiting a child reaper in
pid_ns via setns(CLONE_NEWPID) then runs zap_pid_ns_processes() ->
exit_rootns(), causing a use-after-free and double put_rootns(c) (or
dropping the open control file descriptor's own reference if it was not
closed yet).

Setting task_active_pid_ns(tsk)->rootns =3D get_rootns(c) in copy_rootns()
instead of at creation time would keep pid_ns->rootns paired with the
reference dropped in exit_rootns().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117231352.3816=
603-1-jarkko@kernel.org?part=3D3

