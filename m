Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29CF3606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 05:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZwUzcB70
Received: by kanga.kvack.org (Postfix)
	id 398DB6B05B2; Wed, 18 Nov 2026 00:09:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 349DE6B05B4; Wed, 18 Nov 2026 00:09:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C3AB6B05B5; Wed, 18 Nov 2026 00:09:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D75756B05B2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:09:50 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4FDAF160606
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:09:50 +0000 (UTC)
X-FDA: 85447062540.22.4032959
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id A9A211A0005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:09:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZwUzcB70;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794978588;
	b=QgaLyfRA/jIBr20eJU0HuuSwlhFfPoKywvJoqVsimnCQEHRHEpFE7kPZo7H/GJZVGufz+O
	jB57PMEe1WkaGjr3chOHYJwrVdNS8rY3hJWAj4IlraEaE0/haWB1PhxT1YRi71ixqX0or2
	3gXHDGIAEm36msoTq+znyjf7Xv7nNDU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZwUzcB70;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794978588;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M1t0OG5hPXiCiaFk6hIj2QHLA/2XZTBsU25238l1JRs=;
	b=G2mNQuDLv1+x+1xuN7LV5DtEo8rvwEqg3RvJoUDc9n8lXcUcWqaZcTetWOs2pdrUI2jcQd
	YTGISy243d4l1BIXmLynyT/uxRw2YZ0sVj5HKXz8bTO6rkGFm0QbAbG5QakEh4tkOePbkC
	bm6ftRUx5Wkz9eeuGrOAq/lhmaPXta8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 16A6144896;
	Wed, 18 Nov 2026 05:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8291F000C4;
	Wed, 18 Nov 2026 05:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794978587;
	bh=M1t0OG5hPXiCiaFk6hIj2QHLA/2XZTBsU25238l1JRs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZwUzcB70grBFLs9IGOjbyF70guJqjsxk88ZAUaiytABfn6ddCHSRmOVmLhb7zEaRn
	 HrFxNNyM1NhJLr9E+BEFYYCvbPvnEHixd6OvpfG9xzKUXgIlJWTONC5Rd1Jb1VioOq
	 jhOSfj7leJNVLVPiKqDFqj5Y4n8AZj9pyozGacNzkix2nzC8LVNvDYlNdPSS6YhFUP
	 qCCP0Py9RukHEw2pAJqhIt8ByUG1mNECibnNhlsqhrWSs8PPQ4oSOXLfHczy1EbThH
	 kB1clV3JBRnp0IydGuampvhC6YsMD5LVx6fzvvuOtbOYZuJS2atXiNI/ZL5TIui8XM
	 IRdyK02nsrf2A==
Message-ID: <sashiko-outbox-220139@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 04/13] rootns: Add rootns_create() system call
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
In-Reply-To: <20261117050841.3289652-5-jarkko@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
 <20261117050841.3289652-5-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 05:09:44 +0000
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A9A211A0005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 8j9jcjmurmhzzrbk7fdyjihdrhtgskw5
X-Rspam-User: 
X-HE-Tag: 1794978588-172500
X-HE-Meta: U2FsdGVkX1//qiNjaoxwYfaFD2FrlTuhFQa6xjkOIm/v9esFhNtpGvHeLkM0e7pLngNxjDRhhv6JiAP1E7PHcoAZjSBFmRMZyA6hT85aWnfd6owjevH8xmrwYcenq+wJfu7fX9DeBv8vatp+53DsRFQK+UL38PpqmU9mK9rKrHBIjYSHJMsgDGCM/lhXOTDgXI3ilH45rBdR2eR8ivYz/UDkG/E47z2F1nHw5KhWM/ZCuNxYrtbdpCkNzu9LPGjxHwIng9ejVPOmJ14aHKQS/6w8QKQaMtDwgSHHhhbVhmggTJV5yAd/8xgeb4C+3TdHx7DolZmouTxjgP2z2/X/FVN9iWerPuR6rhR2CwTpm0vUWe53IwX/apQYBKamBHFZILkcsNTXMkh+QaDs5UZcmew0cbJvHa0SR9JGXA4WqHoaN2p/8v5Cxqr2WZSPy6OYYhYj/GyFh2lQn6mXyAvpkpSZXer3awYKXuyDJXlZB6zp31tHWiZdVsWaArXCZvz17Jz55KgbbYQCh5QyixdRxfinFp/BaY0fCd6Ot6pUXe7L9LrzYbvNPkunbLsVjlD7YzIeSes5tr2T1GuHpmzvKc1SIr5LrS7XDRt94PMzrOBCTS4FFldig6o8b437NQhjU/IcdvtGSEHzdk3J7Ojrb0zU6rtsXEoKPrfclREovsb2HLzE5pJwRt44GLi8ZDLEKWzlv4bCFmmaTbsj/bXivXd9yGkK3coMl10ewun3XCrlkHeM2A7p8wKdIv5maYAwXjCxTyurM0OfiGmhPLej95w06NtjBu37+4J5UbEj+KUaFJhQOTC9FfgHBimfvajR2AGv34YQMpnrJ+hG/8/5lgHLaG5ZnlZ5Pq6uKbqbL5UvRDseKbPcccngFyhlcb7TGcgqSVRyiR8sHc+1TZ6zQj5F6r5dhTlyLHXq1EyVjB2jG9kpeFqUxiWfEsYryeBp+xVfxWz8Yopjhac2FCx
 iOJTtoxX
 yA7A8jEz3qd4pGH9ny3o8XFK7SUrosS+HrUMehKxHSw1s2xSWJTjuNyymYqw8iw8FdmIhRti/BWowPBOYndzt2oiO6Wy/EdsyGriYb2o2/m8/BOdR+3IpeRQ+Nc75ph1MUJ4vhtJudYkIK4l7GHKMSo6gfxaqf+KZP3hZOQtn2yKuRO96Jmbu1eEpGgIX41hedSYAmzFX3oHFt8zeDyWUmJOY4DNT3sYkvVn/gMaDbiLVgoTjFFFqCvsUhE0VbgqsAxICOBjQ8A5tNTq57xSB/p8LxruJ50K6ACLvbktFIGR9jHRKzO1YHgLqHmrqrTpPw9RuMVminFYzFEgRKYi0Nm8MX304Zn25Jce9/WVb2AX010khdbC0zCezYmPjdJj4py/1VOqKxf8Xy0LMHCt4A+k2olT4E/REPDAEvhMNP+nqFSm1kYFrIoa3s2xqzIlPmLmZmcduyCcLoH1Q55mXQZYY52KS17URrmjfYQujSbib5rQpOlyxYnWyiJX9ROGAsCewYeteTxCndkrKj410OjUK94RYp7bokKQn2sWy2uYH7h34qUWFh2mC0QkXT09uBX5Hzmsb9TQ8muZLnd1yCNZSlfy9hKvAmRPV+BxqIWtyKMBxzMAjQMZG4w/f6mlz9VbAAIpJGbWvNIM=
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
- [High] rootns: cred->user mismatch in create_rootns_creds() when
  ROOTNS_USER is set
- [High] rootns: UAF via unreferenced pid_ns_for_children->rootns in
  create_rootns()
--

commit b0275fb9f88bbbd1444c1c6937b46e36c52e8fe7
Author: Jarkko Sakkinen <jarkko@kernel.org>

rootns: Add rootns_create() system call

This commit adds the rootns_create() system call to allocate a detached
root namespace with dedicated mount and PID namespaces plus optional
namespaces selected by flags, returning a control file descriptor.

> diff --git a/kernel/rootns.c b/kernel/rootns.c
> index e3b203322ae23..904d75ce9d909 100644
> --- a/kernel/rootns.c
> +++ b/kernel/rootns.c
> @@ -145,3 +145,143 @@ void exit_rootns(struct pid_namespace *pid_ns, stru=
ct task_struct *tsk)
>  	wake_up_poll(&c->waitq, EPOLLHUP);
>  	put_rootns(c);
>  }
> +
> +/*
> + * Create credentials for a rootns. Drop keyrings from the new credentia=
l to
> + * avoid unnecessary pinning.
> + */
> +static const struct cred *create_rootns_creds(unsigned int flags)
> +{
> +	struct cred *new;
> +	int ret;
> +
> +	new =3D prepare_creds();
> +	if (!new)
> +		return ERR_PTR(-ENOMEM);
> +
> +#ifdef CONFIG_KEYS
> +	key_put(new->thread_keyring);
> +	new->thread_keyring =3D NULL;
> +	key_put(new->process_keyring);
> +	new->process_keyring =3D NULL;
> +	key_put(new->session_keyring);
> +	new->session_keyring =3D NULL;
> +	key_put(new->request_key_auth);
> +	new->request_key_auth =3D NULL;
> +#endif
> +	if (!(flags & ROOTNS_USER))
> +		return new;
> +
> +	ret =3D create_user_ns(new);
> +	if (ret < 0)
> +		goto err;
> +	new->euid =3D new->user_ns->owner;
> +	new->egid =3D new->user_ns->group;
> +
> +	new->uid =3D new->euid;
> +	new->suid =3D new->euid;
> +	new->fsuid =3D new->euid;
> +	new->gid =3D new->egid;
> +	new->sgid =3D new->egid;
> +	new->fsgid =3D new->egid;
> +	ret =3D set_cred_ucounts(new);

[Severity: High]
Does updating new->uid to new->euid without updating new->user leave
new->user pointing to the caller's old real UID user_struct?

prepare_creds() clones new->user from current->cred->user.  When the
caller's real UID differs from its effective UID (for example, a manager
process with real UID 0 that switched its effective UID via seteuid()
before calling rootns_create(ROOTNS_USER)), tasks entering the rootns
inherit new->user =3D=3D INIT_USER while running as the unprivileged UID,
bypassing RLIMIT_NPROC checks in copy_process() and misattributing
per-user_struct resource accounting.

Updating new->user via alloc_uid(new->uid) and freeing the old reference
with free_uid(), as set_user() does in kernel/sys.c, would keep new->user
consistent with new->uid.

> +	if (ret < 0)
> +		goto err;
> +	return new;
> +
> +err:
> +	abort_creds(new);
> +	return ERR_PTR(ret);
> +}
> +
> +/*
> + * Create a new rootns.
> + */
> +static struct rootns *create_rootns(unsigned int flags)
> +{

[ ... ]

> +	ns =3D create_new_namespaces(clone_flags, current->nsproxy, cred->user_=
ns,
> +				   NULL);
> +	if (IS_ERR(ns)) {
> +		ret =3D PTR_ERR(ns);
> +		goto err_put;
> +	}
> +
> +	c->ns =3D ns;
> +	ns->rootns =3D c;
> +	ns->pid_ns_for_children->rootns =3D c;
> +	nsproxy_ns_active_get(ns);

[Severity: High]
Can storing an uncounted pointer in ns->pid_ns_for_children->rootns before
copy_rootns() runs lead to a use-after-free in exit_rootns()?

create_new_namespaces() adds ns->pid_ns_for_children to the namespace tree
and nsproxy_ns_active_get() marks it active, while the reference on c that
pairs with exit_rootns() -> put_rootns(c) is only taken later in
copy_rootns() when c->state is ROOTNS_FORKING:

kernel/rootns.c:copy_rootns() {
    ...
	scoped_guard(spinlock, &c->lock) {
		get_rootns(c);
		WRITE_ONCE(c->init_pid, get_task_pid(tsk, PIDTYPE_TGID));
		WRITE_ONCE(c->state, ROOTNS_RUNNING);
	}
}

A process with CAP_SYS_ADMIN in init_user_ns and init_pid_ns can open the
active PID namespace via open_by_handle_at(FD_NSFS_ROOT, ...), enter it
with setns(), and fork a child that becomes child_reaper without going
through ROOTNS_FORKING.  If the rootns fd was already closed, put_rootns()
frees c without clearing pid_ns->rootns, and when that child exits,
zap_pid_ns_processes() -> exit_rootns() dereferences and frees c a second
time.  If the rootns fd is still open when the child exits, exit_rootns()
drops the control fd's sole reference on c, freeing it while the fd still
references it.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117050841.3289=
652-1-jarkko@kernel.org?part=3D4

