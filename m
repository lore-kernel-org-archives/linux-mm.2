Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9882C606A68A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 22:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qup3hZLM
Received: by kanga.kvack.org (Postfix)
	id 744046B00EF; Fri, 20 Nov 2026 17:44:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CE536B05B0; Fri, 20 Nov 2026 17:44:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 595CD6B05B1; Fri, 20 Nov 2026 17:44:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27F1D6B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:44:41 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A28C1801FC
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:44:40 +0000 (UTC)
X-FDA: 85456978320.16.625F8F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id E4E88A000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:44:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qup3hZLM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795214679;
	b=f+fDwsoXBaMN0WqmMT/UsfWI1cLSOOOP7FDzTJeKehL0iAmN2JtIZXJ2Ky2m/v8/tQQ8+d
	wGXbm2zagQ1lT0c1vs21m0mzhBSIMYOmJavAEbsuek7S77QG+JAAeZzO/zzBGCpPfvGJae
	P6Z+38T+U/KB91Si6QLL/9nIh1X5CUM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795214679;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pSzNYLdaadW2jyufCcL13Oj3VYC0HwF6Ept2g9RqzPg=;
	b=r/dalfAdpOrlf96/FnWf5BPHaNgblCqQs5F4AtiWlnDSDOrCF+AkTNHpGhXfk9vm7M6/B8
	D/x1VXCCK5PP9F0AUX+z+kyOeD7zCSkQKx8f66oqG5i5fy/2cQUivjiPLohMJKzc2E/6pW
	SUDJxBNdDQFRntExdAkiGT7/mBBYoPs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qup3hZLM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B6B1D43B7E;
	Fri, 20 Nov 2026 22:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C860C1F000C6;
	Fri, 20 Nov 2026 22:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795214677;
	bh=pSzNYLdaadW2jyufCcL13Oj3VYC0HwF6Ept2g9RqzPg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Qup3hZLMjJGy5Lby+02cC0Ks/w7DT7TF3QjQNKtLYIrpYBfrZFUyGinpDBZuHfkAi
	 goJrpXp+gmkyCkj2JGhkb1jpnlX++Ja7j/A0y3YyPT1+NmGWQHVbUctnH/DTeGipYr
	 cGfwI4AoENAdwdU0aF5VIdJLrOXZ8+3U76DRE12JxoCHMAbfJD27kbX9glPmUmwoVv
	 x4pgmw3sdleN3TVxBg/sktHSOTGoErQgtvQ/2hZ+V6tNnxeys73mlAdroPHMmL/o2s
	 CKQbuo4r4FV4JwF2Idjbka4Xb0uMahKxADIfW4RwvlkUYkwS2MkHZ17TDxpTswtEwA
	 +ubPXlAFfK0LQ==
Message-ID: <sashiko-outbox-226297@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v4 05/14] rootns: Add ROOTNS_WAIT ioctl
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
In-Reply-To: <20261119224312.1037966-6-jarkko@kernel.org>
References: <20261119224312.1037966-1-jarkko@kernel.org>
 <20261119224312.1037966-6-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 22:44:33 +0000
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E4E88A000A
X-Rspam-User:
X-Stat-Signature: 4mnfkpdoy3oxgb7qwep95n9w68hkuqec
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795214678-67669
X-HE-Meta: U2FsdGVkX1/Kz2l3mx8jd9SAhCzgTzvGljhf57NB88L1VcagXLOAufaP4f/cSypUTEFuG+ECxkpowJ1T3tdZNUyfpp/mQgC4ZzL+sl/uxOAwOz6ZGz1FGPqNRi7DpyS0/m8DZ6/ouQF/mocm5XCRqBSe1bRnH6j66aJgmmh9IUhT1FAKknpQ822AdCA/6tuOe/QwwkIDH+6mWOpkuqnSREFndq86nwRBA3rYb8dlhGkp1a7TDNKxyWPMnOnuIu0hX5zfkz75o35mFS5I4KbM+pZUI23f2cF+N3dtIw8N+N062Ol2BK2El3ct99HiehQY6glhy9QnW3HgSQa/Wx/bydvtoncd18TGIDOqHDYdRsPt1FxRcYiEFpzqQSfU/fE7jiiuzjuIeyGkiO6OUMy+eDHW1u6h6EoW7GYHUUu+0Wr0yhn2A1Xbxhrbu7f3tOPa2qPcaFec2k7YLbcyUusin+bpfvUUSAxVjEWgcH+C2EuYgLyXANOXHjcQIGWeHoefgymH2n9gzehjB1+qx5LZU+KuF4xAWH6l+TKmHJvIh3f7kvt9CmOdxoy/gVHSLFkUQZOKZg5MSNo88v1cASbcog4rsdwUK50yK6Sc7uvT9yMJmCWpQspOVrBctJLK97XSz1ZfeS6BQdiFIDSHrCmY+GxhKsufEIAkPUmNGt1HgukXrfQEpnT9r8eD6SZdmpEH1h9zPxIcFqUhcxIPQA/A+mdx8pgQHjoG0z3H2ElWylWOlAScUzmOJqTo2mmWI1qjluDPDGDgAReiNmja0DO6POorBx1jqqoc3e+DI8nwJ++uG9DXou11SnO4EOCW+3OrL0Ayx4mTrpDAeA5eSOlkqeNSw4mysHAOAl+tu2G2LVMI4SGhQghn2HupuiuaV0paYJiqvd143YfwC4ifBvwj9nuDKQUAgMl/jG3OPRntUN4mkCxU2FP/zlvKo0ZhqgMPMhVVPFOLkg+zjY4h+vp
 m1EzYjXw
 wB6RNTSbuj4krUfN3SSZnDga44+3D4BQV1jwxASmF+Vq4nSGDVrchu9r6Ixn1Y9ZnMM53ejdBP1UrdB0kPWSzLixumDCvTd3H7tIros1wPkeKDGXmrAORUgMleJc61HD+tOat5rNNDkbC5q3is3W9yKW+6negVdYGOTGsxqEwYKfNKhMPuxF85vcmcFSS2+YsesILOZ2Txam/9K9WK6KQcf4Emj5hVzNoPdAelotVGKimix3OseWrfTk5zkZwXxXAoemyAtSQ2MWf3cShOu1Ik6/1jRKN4/66QygpFKB39NXiV78G+g/qo0dtjz8u2XKpsjbNQbUPAdziMinjkUTHQRXhldlaTvMxh1H1iVdJ/1phSYATpitxIjCV+U4bvPG/I9h1b/k4E8gDHDbmE7HKsw/aJaoIxdzzZEk2mbHi+/MUPeXuevS7jfhmY1vMmtAmQVwAfA6VsqOyZZeBSnhrK42yBYlRZDGuXO4gyVlDASSKAnKnRayvwEIXW3AzeiJcucOSH8zNQn8hvKZMsE/BF3d+uW4Wfwsrisbz7yFemymkbHmc5PvzK94YY85A6EiNQ7BvTSt/t2ulm+HX1I7BlUt3dJenpfNT3NEGya96Kfxm3pRt8Oi2Dggnba8sWeFNUi9u1OTjd4sEHrCffems19sh78BEvnBotm1HFCTJlJqBJ8zOkYDwfp4Uj95fBvfm8i3it92M7J73zXgJHrpAAd89cNyF+2mLQY2pIOsm1rBkE8D8XnAEZz3sbf15LTlBRVRyu4KEoubzPhb20VD120HYpl6Zh2dU4HIj3FIitQtQ8mRiNVebZ/es6Bn/QY536k1Nf8ZomKcfkMvLlbmhDBMGFEZbXBklelxPPAUbwaTlZirvNWBOEwZBdEsp81QDzDaXAyM6jNNfzIjC7Dgj/eEWZ0vec07JVF3r8WMQ8ht/MmyBVSct1e0YbRLQFaUMXl+FOwMt1xkWRe8qaNlsk5J4AbGN
 oOM7TLqD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] rootns: delayed PID namespace visibility check in
  rootns_wait()
--

commit 68c6e4532ee164e48940d00824536de847b1c5d0
Author: Jarkko Sakkinen <jarkko@kernel.org>

rootns: Add ROOTNS_WAIT ioctl

This commit adds the ROOTNS_WAIT ioctl to wait for a root namespace's init
thread group to exit and retrieve its wait status and TGID.

> diff --git a/kernel/rootns.c b/kernel/rootns.c
> index d9ef68d603a24..5f03b6ba4a543 100644
> --- a/kernel/rootns.c
> +++ b/kernel/rootns.c
> @@ -115,6 +115,45 @@ static long rootns_get_nsfd(struct rootns *rootns, u=
nsigned long nstype)
>  	return nsproxy_open_namespace(rootns->ns, rootns->user_ns, nstype);
>  }
> =20
> +static long rootns_wait(struct rootns *rootns, void __user *uarg)
> +{
> +	struct pid_namespace *pid_ns =3D task_active_pid_ns(current);
> +	struct rootns_wait_args args;
> +	long ret;
> +
> +	if (!uarg)
> +		return -EINVAL;
> +	if (copy_from_user(&args, uarg, sizeof(args)))
> +		return -EFAULT;
> +	if (args.flags & ~WNOHANG)
> +		return -EINVAL;
> +	if (READ_ONCE(rootns->state) =3D=3D ROOTNS_INIT)
> +		return -ECHILD;
> +
> +	if (!(args.flags & WNOHANG)) {
> +		ret =3D wait_event_freezable(rootns->waitq,
> +					   READ_ONCE(rootns->state) =3D=3D ROOTNS_DEAD ||
> +					   READ_ONCE(rootns->state) =3D=3D ROOTNS_INIT);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	scoped_guard(spinlock, &rootns->lock) {
> +		if (rootns->state =3D=3D ROOTNS_INIT)
> +			return -ECHILD;
> +		if (rootns->state !=3D ROOTNS_DEAD)
> +			return 0;
> +		ret =3D pid_nr_ns(rootns->init_pid, pid_ns);
> +		if (ret <=3D 0)
> +			return -ECHILD;

[Severity: Medium]
Should rootns_wait() check whether the rootns PID namespace is visible in
pid_ns before waiting or returning 0 for WNOHANG?

Because pid_nr_ns() is only checked after rootns->state reaches
ROOTNS_DEAD, a caller in a non-ancestor PID namespace gets 0 instead of
-ECHILD when calling ROOTNS_WAIT with WNOHANG on a running rootns, and a
blocking call sleeps in wait_event_freezable() until init exits before
failing with -ECHILD.  Checking
pidns_is_ancestor(rootns->ns->pid_ns_for_children, pid_ns) upfront (as in
rootns_get_nsfd()) would reject invisible targets immediately.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119224312.1037=
966-1-jarkko@kernel.org?part=3D5

