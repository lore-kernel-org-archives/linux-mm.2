Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B60A8606A33E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 22:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TzyVXU3J
Received: by kanga.kvack.org (Postfix)
	id BB01C6B05B1; Fri, 20 Nov 2026 17:44:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3A806B05B2; Fri, 20 Nov 2026 17:44:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A02C36B05B3; Fri, 20 Nov 2026 17:44:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5CFFB6B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:44:47 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C0A2EA0209
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:44:46 +0000 (UTC)
X-FDA: 85456978572.13.41B60A9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1F1C0C0006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:44:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TzyVXU3J;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795214685;
	b=YJ/ZVxn8j7p7dFD2lpwMLGG4PDzACQYTPkySuTaqaI7gb2nXBKW/lthPtf4CUQ74y0evL0
	66NzN4v66txec0CAiqFX8U4SBcG0ZutQZPxxHAiSMt8NFarbXS4oYwlYSTh3LoMZ2x5ayN
	WMtgNSVawKm2myah+y4QlD92MN1g+zY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795214685;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GDJBVsAd6JtWMDQ/ABjrxTbwcVxlwsrHr9o1YDsX7iE=;
	b=GvuJkNMSYc/9G9khWAZ+iQqGxVAkmqVWlX8KLB09OGuAeRS8n0RMq90AcC+FVnSzgoMv+T
	qpEEyDtT9L6LhcKZwk/0gYcPnbG93mGjOqCqLEKI86L5Gfn71R+pEsHNn/cOJYIEfUbkd7
	UZ7cQJgMgjsCc2zokQWPgNvIln6OsT8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TzyVXU3J;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B6A4F60A51;
	Fri, 20 Nov 2026 22:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0081F000C4;
	Fri, 20 Nov 2026 22:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795214682;
	bh=GDJBVsAd6JtWMDQ/ABjrxTbwcVxlwsrHr9o1YDsX7iE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TzyVXU3JZKz+G6iv26QMl86cOJH4T6cdW67UKDT+sTicT4bpZ6PRxigNNzsBN9Weg
	 dX1wwwNonGIGAN79xQ294YlLIuJT5rNbXi0+x5jRleU4eSxz+RXrhhpS/n4gs/jMaj
	 +E3rHJRAZQb4eS8x/aTfUrPfVUTT4z5RjsRJR+Ocjb8IfGW/gWqmliKG1zXAPCgUiP
	 cgnsUESY+O2XpbIVy7OubMMFC+xjfg6+8+zrG/HWj0uuUkfN03o05o6qTNtxXEw8m6
	 Mt2SaFlA+pIK9rxe3QoyDzdB16Mk/5+nIee49ePPRYUKoepHhzTZ14y968juTU3las
	 bI1nF98MdMgbg==
Message-ID: <sashiko-outbox-226299@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v4 07/14] fork: Support CLONE_INTO_ROOTNS in
 clone3()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org, "Albert Ou" <aou@eecs.berkeley.edu>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Alexandre
 Ghiti" <alex@ghiti.fr>, "Andreas Larsson" <andreas@gaisler.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Andy Lutomirski" <luto@amacapital.net>, "Andy
 Lutomirski" <luto@kernel.org>, "Anna-Maria Behnsen" <anna-maria@linutronix.de>, "Arnd
 Bergmann" <arnd@arndb.de>, "Ben Segall" <bsegall@google.com>, "Borislav
 Petkov" <bp@alien8.de>, "Casey Schaufler" <casey@schaufler-ca.com>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Christian
 Brauner" <brauner@kernel.org>, =?utf-8?b?Q2hyaXN0b3BoZSBMZXJveSAoQ1Mg?=
 =?utf-8?b?R1JPVVAp?= <chleroy@kernel.org>, "Chris Zankel" <chris@zankel.net>, "Dave
 Hansen" <dave.hansen@linux.intel.com>, "David Hildenbrand" <david@kernel.org>, "David
 Howells" <dhowells@redhat.com>, "Davidlohr Bueso" <dave@stgolabs.net>, "David
 S. Miller" <davem@davemloft.net>, "Dietmar Eggemann" <dietmar.eggemann@arm.com>, "Frederic
 Weisbecker" <frederic@kernel.org>, "Geert Uytterhoeven" <geert@linux-m68k.org>, "Hallgrimur
 H. Gunnarsson" <halg@google.com>, "Heiko Carstens" <hca@linux.ibm.com>, "Helge
 Deller" <deller@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@redhat.com>, "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Jan Kara" <jack@suse.cz>, "John
 Johansen" <john.johansen@canonical.com>, "John Paul Adrian Glaubitz" <glaubitz@physik.fu-berlin.de>, "Jonathan
 Corbet" <corbet@lwn.net>, "Josef Bacik" <josef@toxicpanda.com>, "Juri Lelli" <juri.lelli@redhat.com>, "Kees
 Cook" <kees@kernel.org>, "K Prateek Nayak" <kprateek.nayak@amd.com>, "Liam
 R. Howlett" <liam@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Madhavan
 Srinivasan" <maddy@linux.ibm.com>, "Magnus Lindholm" <linmag7@gmail.com>, "Manfred
 Spraul" <manfred@colorfullife.com>, "Mark Rutland" <mark.rutland@arm.com>, "Matt
 Turner" <mattst88@gmail.com>, "Max Filippov" <jcmvbkbc@gmail.com>, "Mel
 Gorman" <mgorman@suse.de>, "Michael Ellerman" <mpe@ellerman.id.au>, "Michal
 Hocko" <mhocko@suse.com>, "Michal Simek" <monstr@monstr.eu>, "Mike Rapoport" <rppt@kernel.org>, "Neal
 Gompa" <neal@gompa.dev>, "Nicholas Piggin" <npiggin@gmail.com>, "Palmer
 Dabbelt" <palmer@dabbelt.com>, "Paul Moore" <paul@paul-moore.com>, "Paul
 Walmsley" <pjw@kernel.org>, "Pavel Tikhomirov" <ptikhomirov@virtuozzo.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Richard
 Henderson" <richard.henderson@linaro.org>, "Rich Felker" <dalias@libc.org>,
 =?utf-8?b?Uml0ZXNoIEhhcmphbmkgKElCTSk=?= <ritesh.list@gmail.com>, "Russell
 King" <linux@armlinux.org.uk>, "Serge Hallyn" <sergeh@kernel.org>, "Shrikanth
 Hegde" <sshegde@linux.ibm.com>, "Shuah Khan" <skhan@linuxfoundation.org>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Suren Baghdasaryan" <surenb@google.com>, "Sven
 Schnelle" <svens@linux.ibm.com>, "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>, "Thomas
 Gleixner" <tglx@kernel.org>, "Valentin Schneider" <vschneid@redhat.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Vincent Guittot" <vincent.guittot@linaro.org>, "Vincenzo
 Frascino" <vincenzo.frascino@arm.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Will
 Deacon" <will@kernel.org>, "Yoshinori Sato" <ysato@users.sourceforge.jp>, "Zygmunt
 Krynicki" <zygmunt.krynicki@canonical.com>
In-Reply-To: <20261119224312.1037966-8-jarkko@kernel.org>
References: <20261119224312.1037966-1-jarkko@kernel.org>
 <20261119224312.1037966-8-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 22:44:37 +0000
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1F1C0C0006
X-Stat-Signature: xinj8bwui61saktcoh143qypn3xiqoh3
X-Rspam-User:
X-HE-Tag: 1795214684-50464
X-HE-Meta: U2FsdGVkX19AwcOY4IXd8hjU5L/JB3QagEEEFk7x5llIq8cttaj3kYUKze+5BN3TZUio8QD4ZzQywQDSIAgBbakOWzDX/KHIrzv1IxV5jvIeE02690VmsTd5C3/B6iTmyQifuD/lAkRm7mQ9DujO9MzMi6Ykv7NMEoZSur/3IQPJNSivZOZuZxwgsoY4rkjcc8bcgyjKmOCBEi3LO4byTiDVcB6pxqAJNxoLuCo/sBZj991ayboA5uBIUaklArGc5PpPOu1zx3dccPXceHhfoyYCC3KmbO93XJJrWmWoD+XO1yHYzdzpicu6F0z/oQk7Gv5ie1qQSEoyh5Ba3LS4flDSoml8WVHOkzCTy+E1XJY3/pqzL43puVLB44Pz4jL25llNrM+tmkMl9T3YJajxiyM6Ddt6qRaFH7kbx/ip1zLEK4vMss8bgFnOxEUeYFKcREa9z3Jb8exQDVoQVcmGFXs33aeyA5HiGyMPb7kqNGGTx6mzlkNk63wDgnAqP73PV1XiynIr6C02FeWD4XWgwqf5MhsyAYILtcOHF85J08RX99D4NR3W2flnyVtKTRWvYWNPWkVKpmzuBb6yzh9djmKfkGzomYoOYymsYWM89+NfewO8nLdWwOhTJ82ux/m1XbkuSwifxM5tp0CQWuA7zIVIRnjzOCfrXCm9UrgwgW2oRh00JRfwjoVVtWdWXB1BODGal5tI0IXxGITDVlcx7ejttOp2enZ92qBIM+VZIR3EWesTQGiY0eWab5BIs5vBalFaOJtnQ2TAoXxCGv8YDrDXikZi/q31makdHAEbZ3zDa+IbBkZuCAm55nlR83ZjG+W22QTt3tUtMkU1u73nTYszM8Q7yslekJ/I2IOf3v741JgouxYHkOeSar37UrBnO531gMsI4xzvk+BnKvFcPnlcpd1lIhQsvujw+Htvp3n6ZTa1ke/lijidW3xhya34ugPcM1D9H3OcKQkTDcj
 rtfU/sfV
 UINQGMabDVSWPOG7c6RPqZFEpYmdOrn9UNGp1v7RvXZ7moC2r3vDgv/RlvLd6qYgeexTFetZM6A8LKSFxt5nfnQ/smhxCKbvwcwp5c0nXyX032uUW4JAAV/RfmOXx7wFyVe7brUi8k/pjZvHAkTwFepOHbLBrbU9nBaUDopvQORHX51D6dKNpvb6ZYPfxEr1Ty03tzUACK/bLeXEHp0A9IfOzsoAHvUIXEfeBsw7bNkSpuOisuKy8XhUN3vVL54E2uxBSDIPPzqxguyhZ6ZvCKPBpAVYzWAnTKrgMf01e4dcGwlCsspXLCvqH/mEPvBOMSnByAi63haxIwMZOY/NEhHedI1IbwyRNAlQK5BNdfQXiU17kYe0Q2LcpzKT8P8Hurm/Dvp81WNhY4L8log2o9b4cakw+LUCWwZ3c8MYgI1GmWjyRhXFWb7zYWeM/6kveavQ2hQfSoPtSmMEj/Ll9zKmK1aGuTnhcnbtqenU535MDoZltN3aHSJEGCuegGrW9sWq/4jhOFBi9UtdmfLRBsmvpIV+Yu3yEo6Fv69j0X3WyHO/wio0FgeAChmIGxDH2LM1sn7lJYkbs0c2wFmzdULFeZ5yUN9yYbug9ceVW9EE/X5wTRM85utozU5o/c4M4cdFZL6aivxVA0oKaOygGykx6XTSf7IlYEj+xX+ydYWs5I21O1HJNEPxC7YD1BXgPC/TReBzcHpF3404kQJO7bbReDkDW+HOWTuhMivutnXA8HWn8OhOdz6w32xeeIuLecZB8vYYl9PkJ28tXBOX2co76u/7Zh2M8LH0TROpkZZjNn95WqYYli4tRcOX+ijY/1DF0Afuep3Hwh8oHZJ/Tk3XXmjGryYD6JZ4OrPYQkFpOlhrQZPCZyX0lO9zY/aKqhpoINHkgFXgi3Rt75AiheSdQXQV3OibVNddc1ah7yaspwzVSEn4zgfDUEYbzB6KYS8E202OBGApX9u/0d1VVr9rbZ5t8
 NXnOsgxk
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
- [Medium] rootns: rootns_finish_fork() rewrites copy_process() -EINVAL
  to -EBUSY
- [Low] rootns: unreachable PIDNS_ADDING check in rootns_prepare_fork()
--

commit 1820863b7d5dcd4fd4778d2d64f24adcb966cc47
Author: Jarkko Sakkinen <jarkko@kernel.org>

fork: Support CLONE_INTO_ROOTNS in clone3()

This commit adds CLONE_INTO_ROOTNS and struct clone_args.rootns to spawn a
child process directly into a target root namespace via clone3().

> diff --git a/kernel/rootns.c b/kernel/rootns.c
> index ce012a07e9828..865689eed69cb 100644
> --- a/kernel/rootns.c
> +++ b/kernel/rootns.c
> @@ -423,3 +424,138 @@ SYSCALL_DEFINE1(rootns, unsigned int, flags)
>  	return fd;
>  }

[ ... ]

> +int rootns_prepare_fork(struct kernel_clone_args *args)
> +{

[ ... ]

> +	for (;;) {
> +		bool wait =3D false;
> +
> +		scoped_guard(spinlock, &rootns->lock) {
> +			switch (rootns->state) {
> +			case ROOTNS_INIT:
> +				if (READ_ONCE(pid_ns->child_reaper))
> +					return -EBUSY;
> +				if (!(READ_ONCE(pid_ns->pid_allocated) & PIDNS_ADDING))
> +					return -ESRCH;

[Severity: Low]
Can the PIDNS_ADDING check under ROOTNS_INIT ever be reached?

PIDNS_ADDING is only cleared by disable_pid_allocation() in
zap_pid_ns_processes() when the PID namespace's init process exits, and
pid_ns->child_reaper is never reset to NULL afterwards.  Because
pid_ns->child_reaper is non-NULL whenever PIDNS_ADDING is cleared, testing
child_reaper first always returns -EBUSY here instead of -ESRCH.

> +				WRITE_ONCE(rootns->state, ROOTNS_FORKING);
> +				bootstrapping =3D true;
> +				break;

[ ... ]

> +int rootns_finish_fork(struct kernel_clone_args *args, struct task_struc=
t *p)
> +{
> +	struct file *file __free(fput) =3D args->rootns_file;
> +	struct rootns *rootns =3D args->rootns;
> +	struct pid_namespace *pid_ns =3D rootns->ns->pid_ns_for_children;
> +	int ret;
> +
> +	args->rootns_file =3D NULL;
> +	args->rootns =3D NULL;
> +	if (!IS_ERR(p)) {
> +		if (current->nsproxy->time_ns !=3D rootns->ns->time_ns)
> +			timens_commit(p, rootns->ns->time_ns);
> +		return 0;
> +	}
> +
> +	ret =3D PTR_ERR(p);
> +	if (args->rootns_bootstrapping) {
> +		scoped_guard(spinlock, &rootns->lock) {
> +			if (rootns->state =3D=3D ROOTNS_FORKING)
> +				WRITE_ONCE(rootns->state, ROOTNS_INIT);
> +		}
> +		wake_up_all(&rootns->waitq);
> +		if (ret =3D=3D -EINVAL && !args->set_tid_size)
> +			ret =3D -EBUSY;
> +	}

[Severity: Medium]
Does this rewrite argument validation failures in copy_process() from
-EINVAL to -EBUSY during bootstrap?

rootns_prepare_fork() runs before copy_process(), where companion flags
allowed by CLONE_INTO_ROOTNS_FLAGS (such as CLONE_PIDFD_AUTOKILL without
CLONE_PIDFD, or CLONE_AUTOREAP with a non-zero exit_signal) and
copy_thread() are validated:

kernel/fork.c:copy_process() {
    ...
	if (clone_flags & CLONE_AUTOREAP) {
		if (clone_flags & CLONE_THREAD)
			return ERR_PTR(-EINVAL);
		if (clone_flags & CLONE_PARENT)
			return ERR_PTR(-EINVAL);
		if (args->exit_signal)
			return ERR_PTR(-EINVAL);
	}
    ...
}

When the initial bootstrap clone3(CLONE_INTO_ROOTNS) call with
set_tid_size =3D=3D 0 fails one of those checks with -EINVAL,
rootns_finish_fork() treats it as an alloc_pid() collision and returns
-EBUSY to userspace instead of -EINVAL.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119224312.1037=
966-1-jarkko@kernel.org?part=3D7

