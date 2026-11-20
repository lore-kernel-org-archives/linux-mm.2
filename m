Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CEFB606A69F
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 22:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X1gDtaRA
Received: by kanga.kvack.org (Postfix)
	id 855C76B05B3; Fri, 20 Nov 2026 17:44:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B82C6B05B4; Fri, 20 Nov 2026 17:44:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 659136B05B5; Fri, 20 Nov 2026 17:44:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 236A76B05B3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:44:51 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A2E6B401D6
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:44:50 +0000 (UTC)
X-FDA: 85456978740.07.F051FE0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 015321C0004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:44:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X1gDtaRA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795214689;
	b=sMQzHddgA0AklXqldRcT+mHDlHakOH7QNEl4dOnAI1UGPfxO8YjmazyCNiamkVdOKD2PzD
	ccgN5Rl84/Ziwm8kMZ8Qg3CsNSV3C6ALh2+ACEDPTkDnEqbgVZoEyK4C5zzln8z7oQUq1d
	oU1WMgFs0mVgWAJYKMIShlzaEcfsFNM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795214689;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bn6mJHSwscuFX7EABuBC1QwU6RYMxp/Gn5afGYR9hiM=;
	b=Pi7CwLujEQs6eFWJps5oi6inBcnmuzv7by2wATxBhFbDBaWBoT2Ut88vow80tU3TjPNM3F
	gQLYcfp/OzWIV2oNfgB8UTcdoloVdv7GMXmDlb20aA7qMf8YCtQra/evI8A6tPV5ijsGum
	XR9eMPYcEn1BMdHjcUUypxUOgcDubxY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X1gDtaRA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7C23C61925;
	Fri, 20 Nov 2026 22:44:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2F31F000D0;
	Fri, 20 Nov 2026 22:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795214687;
	bh=bn6mJHSwscuFX7EABuBC1QwU6RYMxp/Gn5afGYR9hiM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X1gDtaRAKXV2P8w+4EH9cg/ShOrrdn4aIzWA2optS29THkWlmz8GU8h+MWkoxb9ap
	 scUjfx5IeIBaS/vwrOnL2U16+GZlaIdVXmKsblT4P8+swO/x45B45CFMoItVUQ30At
	 X5D7eyaOp/3bt/WkWcRDgXjHq9uR8tASbD38IJXtB7lapOC4uBhQ4MJa4OLtNbnQVo
	 XdFI2s6gNvgxMZxtXX16BY/VNfL3qrXPP0J/iXSfnXC+2R5GGBybJMRfEv4gAM32o8
	 75i2QGX/cz7Cm69LExhTNldhPWYRXk11PAtpiCyjYgV0Y8TB1Oo/LAZhlWEjwtdFO5
	 Fc1FyiDO9oBDQ==
Message-ID: <sashiko-outbox-226300@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v4 08/14] fs: Support FSCONFIG_SET_ROOTNS in
 fsconfig()
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
In-Reply-To: <20261119224312.1037966-9-jarkko@kernel.org>
References: <20261119224312.1037966-1-jarkko@kernel.org>
 <20261119224312.1037966-9-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 22:44:43 +0000
X-Stat-Signature: 6mi3xe43ht6d7nfddhhzt1znucswg7sd
X-Rspam-User:
X-Rspamd-Queue-Id: 015321C0004
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795214688-150385
X-HE-Meta: U2FsdGVkX1+wvg1HD1qqgWKUPrWaHMPhBBdCH6Kdqrrf17OeA2ooZ/vPFNTAujJCDLbTtxwpD6UnCUJ00ETzuPEkEJ9ukuVvPyFd8LH0R9V+dBG2rhPjoDErVjhCfy6gGovN9+OM9zAdXP/T3ZHLhyNucHu8RYc6Nzlo4mr1C9Z4Qi6GgzjHakoPEaM/b8ZRmHer99x8amILgTIWCzIc7drZKcgww6Kx074JCIXudOwOFvVttxcCTFIHeW1hZt+dT3n735/QN80gjkSnwFvA9yk3ZXm6WnkxAhQWidk1oyDu3u6c60SukfVEOTxErDou4/4LGf2HoCl+bFsX0wJ92pPDwce+lR6IDbg0lAF0ofBNZ/ibFRagEris2A/dJ3hnpbsI5WsIetDwupFcUYXum4sP7WF7nEcZE594bSRwFHsPmlq/zO4cpQGNIvZhcW0TZx9bn+jgYgTt+rII8XkWdXRwW1dv9TLhPjn/h4zKJijgmrVZjGEPwM/UuQSL1wV7n1pv/eB4RyX9d/c+rJ3FIMsbHfdFmp4XILTIG8lc5G9v39YANBxSIvOy/12WTaTUKAc8U+rE3+V1+L+sZ0m96sgzlln2eu++kwRbEsq084pHt/W6zpVm9PFvgonuovsUN3B9NI7GvAdWhzFAe1fN5cIK3cxcgIXzcUfC5yFpSEJu27DxZSopetEpeSPNR0M6xlFdaMwQpVhy/nifcTSrHOVf/TtTvgUMmuIfZ+sM++nHLF+jeosdzRZi7EUPauq3EMpeqWsLPsD6eQDbjoCLwmiS+A6LejFN9ZV2RuM3LN6Gb5IvZr1X4vZLCltADP+NtfxpqMDBjh/zdC/LKGW9SjQd4ms/poc03WuHTX87coiTfec0wFdyW2H2uigUZL7wJlxy2NbssrJbU8HByxKAWR+b401xm+IqbwUL5YGiTz8rbXB1zaoMQv2+YcbS8oOIlDlrQRjumQc57ZxY8yR
 XJFFpOxo
 kPMFKHNVepfyoBxtN2XfWd7m66XeHFGwDmbE7bGjkf7+LFfuQgkIA4vebGijut8SnmUCN6YPcL4wa7yVFgR0jhS7BEc3BUhZTG+Wd9i7W684NdB8EYz/LyfwriKhP+P8sL/9TC0+tmYB/Xg0JH4xhSLfaWgULbb08A224p1Qanw5jpuB5A+IT0QME4P/MlOXk2VYkm2kGdM1DDeFmFOpTmxOmI2gnxRLufHvf8mI/0lAn0dOFjJe0jCtiUTp/0JvjKH9SPHNlpUt/O+CEs3DXWPzKjg/Ew9O9MIS0EC5quWGf4HlTkO1ahjnP/c8OaUTP+CjRmvihC9rZXoyapRDt5jk+QAPAFf7pKZoB8XaBZm/Q9fc9i2EMDibmVor+Xw/RnHifAihD+cc3M+UdoUKHjWZaj/hl2tFPlj6UKqLsI+5+jT81DQCx3TjSBR96mGKtIQ/JV73H/zu9BNT9/e1M5DWJkQAyS7y8Y1Fd6OLfZuIgtQts+xIbn0RWmRuNq17i4hv0Rnt4cVCdqDKa//AUjtDd5WvjXtg8Sb/GFLnc8DAJgYsFUyCDIQox+W9yAYPQSf1x+VGwW4sxIyBUHlGidkXX1yA1RWvXpBjBnokwnR2xQpZLksBgPG1IRIxQLOh+tYGPkEP9EJfCtyVc1X0IRWzTRGCVN8oa+sPswg0QtqB6kZfgs1ni7miPZhgmZPfLgK5w6O3eOw/LVmNP2ie9MZABxKwzT7URf+oTaM0vUPSUUS6Gqdmt4XrbOipkt6ysk7dgn5A1ZvHbCzD72wgWnrEReezB/f47io+abRzyPdVU8MG1UyZk4xL6rJT0vyHO/bTXhix0gVGwiXbfVdc2/gks/IGxC1tjM1hhymd5yViWBM8diWjM9W3LBcJQsDywDq0+ivC9XV1P+bk8q4gtOZV8lYgbDG9Ag0BuoAz2KNDu3E3nHymd7IHuE3vwYVxJYCyfjQ+gVdQSSd7nW01kOhajBo/U
 goFPKPjF
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
- [High] fs: user_ns delegation and init_fs_context() mismatch in
  fsconfig_set_rootns()
- [High] fs: condition anon mnt_ns user_ns and seq_origin on
  rootns_bound in fsmount()
- [Medium] proc: allow pidns option to overwrite rootns binding in
  proc_parse_param()
--

commit 08909a29107ff970d2d4b5a71eaa424398baf6f2
Author: Jarkko Sakkinen <jarkko@kernel.org>

fs: Support FSCONFIG_SET_ROOTNS in fsconfig()

This commit adds the FSCONFIG_SET_ROOTNS command to fsconfig() so callers
holding CAP_SYS_ADMIN in a target rootns user namespace can bind a newly
opened fs_context to that rootns before configuring parameters and mounting.

> diff --git a/fs/fsopen.c b/fs/fsopen.c
> index 70024870fefa2..85b31af68a4d6 100644
> --- a/fs/fsopen.c
> +++ b/fs/fsopen.c
[ ... ]
> +static int fsconfig_set_rootns(struct fs_context *fc, struct fs_paramete=
r *param)
> +{
[ ... ]
> +	put_net(fc->net_ns);
> +	fc->net_ns =3D get_net(c->ns->net_ns);
> +	put_user_ns(fc->user_ns);
> +	if ((fc->fs_type->fs_flags & (FS_USERNS_MOUNT | FS_USERNS_DELEGATABLE))=
 &&
> +	    ((kuid_has_mapping(user_ns, fc->cred->fsuid) &&
> +	      kgid_has_mapping(user_ns, fc->cred->fsgid)) ||
> +	     !ns_capable(fc->cred->user_ns, CAP_SYS_ADMIN)))
> +		fc->user_ns =3D get_user_ns(user_ns);
> +	else
> +		fc->user_ns =3D get_user_ns(fc->cred->user_ns);
> +
> +	fc->rootns_bound =3D true;
> +	fc->rootns_mnt_id =3D c->ns->mnt_ns->ns.ns_id;
> +
> +	ret =3D fc->fs_type->init_fs_context(fc);

[Severity: High]
Can fsconfig_set_rootns() leave fc->user_ns pointing to a user namespace
other than c->user_ns while still marking fc->rootns_bound =3D true and
fc->rootns_mnt_id =3D c->ns->mnt_ns->ns.ns_id?

First, fsopen() sets priv from may_mount() (CAP_SYS_ADMIN in
current->nsproxy->mnt_ns->user_ns), whereas the fallback here tests
!ns_capable(fc->cred->user_ns, CAP_SYS_ADMIN).  If a task calls
unshare(CLONE_NEWUSER) without CLONE_NEWNS (so priv is false in
init_mnt_ns, but the caller has CAP_SYS_ADMIN in its new cred->user_ns U1)
and binds to a child rootns (U2) before writing uid_map/gid_map,
fc->user_ns falls back to U1 while fc->rootns_bound is true.  Subsequent
FSCONFIG_CMD_CREATE and fsmount() calls then authorize against U1 despite
!may_mount(), and fsmount() allocates an anonymous mount namespace in U1
with ns->seq_origin set to U2's mount namespace ID.

Second, a nested container manager with CAP_SYS_ADMIN in U1 that binds a
context to a child rootns U2 before U2's uid_map/gid_map are written (or
when U2 maps subordinate IDs excluding fc->cred->fsuid/fsgid) also hits
the else branch, leaving the superblock in U1 instead of delegating it to
U2.

Third, calling fc->fs_type->init_fs_context(fc) after setting fc->user_ns
allows filesystems without a ->set_rootns() hook to overwrite fc->user_ns
from current->nsproxy (for example, cgroup_init_fs_context() resets
fc->user_ns to current->nsproxy->cgroup_ns->user_ns).

> diff --git a/fs/namespace.c b/fs/namespace.c
> index 781380945d784..dfe0ee9ecdcd0 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
[ ... ]
> @@ -4658,6 +4661,15 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int,=
 flags,
>  	if (ret)
>  		return ret;
> =20
> +	if (fc->rootns_bound) {
> +		if (flags & FSMOUNT_NAMESPACE)
> +			return -EINVAL;
> +		if (!ns_capable(fc->user_ns, CAP_SYS_ADMIN))
> +			return -EPERM;
> +	} else if (!(flags & FSMOUNT_NAMESPACE) && !priv) {
> +		return -EPERM;
> +	}
> +
>  	/* There must be a valid superblock or we can't mount it */
>  	ret =3D -EINVAL;
>  	if (!fc->root)
> @@ -4699,9 +4711,12 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int,=
 flags,
>  		return FD_ADD((flags & FSMOUNT_CLOEXEC) ? O_CLOEXEC : 0,
>  			      open_new_namespace(&new_path, MOUNT_COPY_NEW));
> =20
> -	ns =3D alloc_mnt_ns(current->nsproxy->mnt_ns->user_ns, true);
> +	ns =3D alloc_mnt_ns(priv ? current->nsproxy->mnt_ns->user_ns :
> +			  fc->user_ns, true);
>  	if (IS_ERR(ns))
>  		return PTR_ERR(ns);
> +	if (!priv)
> +		ns->seq_origin =3D fc->rootns_mnt_id;

[Severity: High]
Should alloc_mnt_ns() and ns->seq_origin be conditioned on fc->rootns_bound
rather than priv?

When a manager process already has CAP_SYS_ADMIN in its own mount
namespace (priv =3D=3D true) and uses FSCONFIG_SET_ROOTNS to prepare a mount
for a target rootns, testing priv allocates the anonymous mount namespace
in current->nsproxy->mnt_ns->user_ns instead of fc->user_ns (causing
attach_recursive_mnt() to lock the mount with MNT_LOCKED when moved into
the target rootns) and leaves ns->seq_origin at 0 instead of restricting
the detached mount to fc->rootns_mnt_id.

> diff --git a/fs/proc/root.c b/fs/proc/root.c
> index 7fbbe92bf73a7..323296b030892 100644
> --- a/fs/proc/root.c
> +++ b/fs/proc/root.c
[ ... ]
> @@ -323,6 +325,21 @@ static int proc_get_tree(struct fs_context *fc)
>  	return get_tree_nodev(fc, proc_fill_super);
>  }
> =20
> +static int proc_set_rootns(struct fs_context *fc, struct rootns *rootns)
> +{
> +	struct proc_fs_context *ctx =3D fc->fs_private;
> +	struct pid_namespace *target =3D rootns->ns->pid_ns_for_children;
> +
> +	if (!pidns_is_ancestor(target, task_active_pid_ns(current)))
> +		return invalfc(fc, "cannot set pidns to non-descendant pidns");
> +
> +	put_pid_ns(ctx->pid_ns);
> +	ctx->pid_ns =3D get_pid_ns(target);
> +	put_user_ns(fc->user_ns);
> +	fc->user_ns =3D get_user_ns(ctx->pid_ns->user_ns);
> +	return 0;
> +}

[Severity: Medium]
After proc_set_rootns() binds a context to a rootns, can a subsequent
"pidns" mount option overwrite ctx->pid_ns and fc->user_ns?

fs/proc/root.c:proc_parse_param() {
	...
	case Opt_pidns:
		if (fc->purpose =3D=3D FS_CONTEXT_FOR_RECONFIGURE) {
			errorfc(fc, "cannot reconfigure pidns for existing procfs");
			return -EBUSY;
		}
		err =3D proc_parse_pidns_param(fc, param, &result);
	...
}

proc_parse_pidns_param() replaces ctx->pid_ns and sets fc->user_ns to the
new PID namespace's user_ns while fc->rootns_bound remains true and
fc->rootns_mnt_id retains the original rootns mount namespace ID.
fsmount() then checks CAP_SYS_ADMIN and allocates the anonymous mount
namespace against the overwritten fc->user_ns while pairing it with
ns->seq_origin =3D fc->rootns_mnt_id from the original rootns.  Should
Opt_pidns also be rejected when fc->rootns_bound is set?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119224312.1037=
966-1-jarkko@kernel.org?part=3D8

