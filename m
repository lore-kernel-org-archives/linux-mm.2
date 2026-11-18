Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07858606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 23:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OERKgB7F
Received: by kanga.kvack.org (Postfix)
	id 593F76B0622; Wed, 18 Nov 2026 18:15:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F5E36B0633; Wed, 18 Nov 2026 18:15:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E52B6B0623; Wed, 18 Nov 2026 18:15:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F392C6B0633
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:15:15 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7867E1C3C8B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:15:15 +0000 (UTC)
X-FDA: 85449797790.22.B79CCD5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id DA99440006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:15:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OERKgB7F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795043714;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8rRvSXkDiuzji/rN0zB7/tikoYTvj8vrWQExWSK68WA=;
	b=qcsdmjUR81lPGuA7NlOyTqJgLVtoc1oDBXlhK1JbMsTliUdoduwnYCJEQ3X81dbC2JdibN
	LmRJ4Mwy3+O8lgqipwFMrInnkcwTOuV12SVZvW4IGa4qvNsc/EtPKImz+dyMIjj6IP1UXH
	Oi5KJ6Vt+LQaXkAMA3gkkipNv8qZfds=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OERKgB7F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795043714;
	b=3xJL3l7kaltfn1vDOWc0NZXY83U89+N9gtFTT+/CsOEbre4x/9H+jRyBJbM9qE304iPrEh
	ORfY743PfuBdZfuumyJlZGzINAUsAFp3IFVX9NJWAbIAC1Av8NO55iTqZ/gMxq1+IUHHAA
	VJ54uYQiwOrfYsVwvxQLgqhd4IryTgM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E7C2347A23;
	Wed, 18 Nov 2026 23:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261FD1F000C4;
	Wed, 18 Nov 2026 23:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795043712;
	bh=8rRvSXkDiuzji/rN0zB7/tikoYTvj8vrWQExWSK68WA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OERKgB7Fr45GWa7sl3DJZXCGl8q9UbCwtxu55KJwGp4LLVXptuHFJOn1UHDehdivb
	 HsK8CP4BEa69Lfba34u8qA/XJW0HO+vJUiLN92PlBMBKn9sMt+HFQdtVWm9eMCRcw+
	 tlyn3swRLSUZ4LqeYb5WZ6OGJZ3VhnRgZHvNSQklnhAQnPjEMWZRYGZkvKAQcnpPg1
	 D5O4NxplsTSbP950PQmrWQkJ5w3JjkKFahbIY3BgVMuRvbKZ85UcXNwsqBKmxemXb3
	 avkFnSfJgb/u0a0bgyUtUu6NDxTLyuD5pJiDk/KfyOm7qKK+xbDJhICfHHT5McVLkT
	 M/1h0OPTL/QmQ==
Message-ID: <sashiko-outbox-222158@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 04/13] rootns: Add rootns_create() system call
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
In-Reply-To: <20261117231352.3816603-5-jarkko@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
 <20261117231352.3816603-5-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 23:15:10 +0000
X-Stat-Signature: wuhxnnweh8f59xbdktobmhxebhj1hx7s
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DA99440006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795043713-34717
X-HE-Meta: U2FsdGVkX18cl6CClgc/n7WGXNppHm3+BfpC2hkkIMP0yqjKjSzrsssSxGaVHkVd50HOQ0CgyiShlC1I5jAQj5ikmyXDevgb9lhdxyEg2jKCCPjK9WRIrtnyrwWBgCOJVXchtxfijWAp7L26KRZqb56cwimzSLhuacfzsar6Q1QVguCM+Q0yLNu/sjYG8IlPxA1TogGWO4QxGXQJF3ZXAUHdhSRrS/MnUwM6CpYqjxyptPAXuAQ7K9c64A3qmtpdNy2JNawNde24hjB/2xYRTWtDjFNdepvmn9tPLCUNBrN3xo1UgQ4AKJN0Rp8hhA5PIqaZz+OuoeZXN94MS3xTxF86IxHveO7s4W302nLIBtOUTCqm+0oH4Fo6GIoSnxDflqdTdmJZi2yLrJWjhRG79y9XuqVqOCSQncRz2Wx5m0SgBbPT9QzkX00kr4PwHydsDL5G6juaF9oMcxvgfnD7/6ZVROoF45G/eRvx0ejySt7rUohMBRyT8MFKSgraiZU5HhfL/BJTPf/KEPI1ga7hT5s+Uy4aCkgCUzHKfJpi4UpjffbEBAkSYvKhM7931W5C7kJtPvSxkKvW1OB1OaGnbFEPKYGAubg28BWxzYyf+2hToOEymG8X8gG/tglNPYsCDAdS36nyQ+VcvRKyk3/01ZwLh8gxPv5pETWSzrEntbZ+ZZs3BlD7wD3rU80EGfzCK6XjeUiYYmaujXM8Td2F/G5jucRxnxTfX4HGasxjHJGw2Nf4RP7GELi7QlXB54LvHcybcWCLIzMFa4jpqTz26WFmtLsvSEJr48f5XaFOIQDhaiTqMy76u+bMg7pDelNEfNsRea5g5uZkG8w91brlmBCxd725VBzRkXYRc8+f/mT7U5kBJO9C6JHsOSPZK9HHz5lRwnoxDZZx8R0f1D/qs40137vUR6ipdg33TFjJoZ7SDDRDAUEEOF2kSjOQdCOsAxDvxxzJc6dJmyv4nHp
 YD2Qsf9w
 JUISlBkBrdtTKVTlG66OB5P2spU75thUazCw5xQjyYw1q+jexgykyZQvEcPWlxL5A+guebA6lxE0OopRe/RPS5rzJLigPN20qSO9Sf4CsyvSnh0y9T39Y74kPfvT1LMRjfAAWJdt68AS6xx4RD1Wk3NU8+8V6eZVWIFJDWoWsqak2ThhHsbKj9HZuVFRAMVEUqMtkH6e47kZZhbS5RPJyTam4HdlTVIQOn9QRVnXFCyiqC3EHzTOpAoD9OAtUK6L9c4Q71QP/JiTZJDxUd0pcIkHK7N9SFxfg64qL24bphOmbuklLirKPU0bepstQxoqJXOg99WtFFFjCBgws4Z6KnJ6ZO1RHR76LXhlvFit9/fNIvEqsST2Na59R9gGgkvLu+2n5g0KNm6aLYpftLjdKlJ7w6Q3UPs5iNf/0+GWmr2VuLMliBbPUrxaOyjCio7VlOg2t5TVKgcVwr3wi9y+vQwG+Eemu4HCxlKObHwQgRHpfPCuSsm5Gu6Bmo6VoomU6v/l4chlgFVoCGgIs7R/1LRtom+IhPKgU6E6eCHWIa9GcPcQHYaK79waMRehhytmzJL5eUZfwzIBd/KO4cH7TOI9Sx8ZQgAJ8cicWmRjDhiKOcRvjq0qKpW0hBrHvPcS9VR0w3iPJXqDK44A=
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
- [High] rootns: UAF via unreferenced pid_ns->rootns in create_rootns()
- [High] rootns: cred->user mismatch in create_rootns_creds() for
  ROOTNS_USER
--

commit 58de372391f170ac432dcc21ea8238b956c72a12
Author: Jarkko Sakkinen <jarkko@kernel.org>

rootns: Add rootns_create() system call

This commit adds the rootns_create() system call to allocate a detached
root namespace with dedicated mount and PID namespaces, optional extra
namespaces, and credentials, returning a control file descriptor.

> diff --git a/kernel/rootns.c b/kernel/rootns.c
> index e3b203322ae23..caa810b65d0da 100644
> --- a/kernel/rootns.c
> +++ b/kernel/rootns.c
> @@ -145,3 +145,142 @@ void exit_rootns(struct pid_namespace *pid_ns, stru=
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
> +	if (ret < 0)
> +		goto err;
> +	return new;

[Severity: High]
Does overwriting new->uid with new->euid without updating new->user leave
cred->user out of sync when the caller's real and effective UIDs differ?

prepare_creds() clones new->user from current->cred->user (the caller's
real UID).  If a process with real UID 0 switches its effective UID via
seteuid() before calling rootns_create(ROOTNS_USER), new->uid and
new->ucounts are set to the unprivileged effective UID, while new->user
remains INIT_USER.  Tasks entering the rootns then bypass the RLIMIT_NPROC
check in copy_process() (which skips enforcement when
p->real_cred->user =3D=3D INIT_USER) and charge per-user_struct resources to
the wrong user_struct.

Allocating the matching user_struct with alloc_uid(new->uid) and releasing
the old one with free_uid(new->user), as set_user() does in kernel/sys.c,
would keep cred->user consistent with cred->uid.

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
> +	ns->pid_ns_for_children->rootns =3D c;
> +	nsproxy_ns_active_get(ns);

[Severity: High]
Can storing an uncounted pointer in ns->pid_ns_for_children->rootns lead
to a use-after-free in exit_rootns()?

create_new_namespaces() adds ns->pid_ns_for_children to the namespace
tree, and nsproxy_ns_active_get() marks it active before any init task is
forked into the rootns.  However, the reference on c that pairs with
exit_rootns() is only taken in copy_rootns() when c->state is
ROOTNS_FORKING, and put_rootns() does not clear
c->ns->pid_ns_for_children->rootns:

kernel/rootns.c:copy_rootns() {
	if (likely(!c || READ_ONCE(c->state) !=3D ROOTNS_FORKING))
		return;

	scoped_guard(spinlock, &c->lock) {
		get_rootns(c);
...
}

If a process with CAP_SYS_ADMIN in init_user_ns opens the active PID
namespace via open_by_handle_at(FD_NSFS_ROOT, ...), enters it with
setns(), and forks a child while c->state is still ROOTNS_EMPTY, that
child becomes the PID namespace's child_reaper without copy_rootns()
taking a reference on c.  When the child exits, zap_pid_ns_processes()
calls exit_rootns(), which dereferences the dangling pid_ns->rootns
pointer if the rootns fd was already closed, or drops the control fd's
sole reference on c while the fd is still open.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117231352.3816=
603-1-jarkko@kernel.org?part=3D4

