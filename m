Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D537606A32C
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 20:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZTwy6TCa
Received: by kanga.kvack.org (Postfix)
	id 5C3D66B05B3; Sun, 22 Nov 2026 15:28:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52DB76B05B4; Sun, 22 Nov 2026 15:28:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A1296B05B5; Sun, 22 Nov 2026 15:28:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F14296B05B3
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:28:18 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2FBF212072B
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:28:18 +0000 (UTC)
X-FDA: 85463892276.24.9B65E6C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 88B831C0005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:28:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZTwy6TCa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795379296;
	b=F79aTzXsDiLKL22y/eqBp9Q2YfacgnBIdpmHk8LP3tFK4nrkb3M+LKQY5hFD/neiz+XpNB
	W8EwWP0MHihOo3JnK8F1A0Y0hxt2D4PeqiQbrXdleG0O0ZBPh6hYkYgd7RWtswJ1yYdXBZ
	99vrD2+tMyPuyVMMwgF+se0qtwAleCQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795379296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2rwax2wpP896bdTS8rm+H3FuFS+cnVXOxY0nVpujxFo=;
	b=VQGTytXPV8nDNDj4cWsjZnlK85K9bMcUeX59Vi/100K+6Nf+QFTrNwyYQACkAQY/nghx7e
	rWuS3CKqnqW370lSZdM2EAyAmfF4QkqUHO/KN9HpdVHpjwlYd9ghlk7lAQzBIF3pSXS2rO
	JNtuHFP1/p6C6pg+qdhwICG9sWDNWY4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZTwy6TCa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BB53E43B1B;
	Sun, 22 Nov 2026 20:28:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEAD11F01568;
	Sun, 22 Nov 2026 20:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795379295;
	bh=2rwax2wpP896bdTS8rm+H3FuFS+cnVXOxY0nVpujxFo=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=ZTwy6TCa0eRPwX35Jv2r1gWjHUFr+6zJNZuqCB+5gMbCBfHTJOqoFO0JEUJ3n6c3i
	 hvRA4rO6cbOI/xv7KdGe5i45tt+WGyr2G+fc0jVk5lQCOO8SEjpnYjsV7SuhkNlDpv
	 WDE8jeg1ZDRc3EKFBcysidI36X1hR5pVW5gO5lveRLa2Pqnda8eYGj1QzyZaUcCTc/
	 kgiiaWwyupBvbh8ZuG+lkQB9sYKi+kyAJkOYdvKjvEnOiwEpjb3M8DrmykD8Xu5ha0
	 AkNAF5I006DgFO4JQzCTy7wBnGLV5pV24QmD0mCPaVVRuwTIx5F7dyVfKHstZVVU24
	 YnYQInMXwm/bg==
Content-Type: multipart/mixed; boundary="===============4659356257046684705=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <cac1fa0b133e15e7c67629319df17a0d25747093535aa246f44a75cb1073e2ed@mail.kernel.org>
In-Reply-To: <20261122193539.3334213-8-jarkko@kernel.org>
References: <20261122193539.3334213-8-jarkko@kernel.org>
Subject: Re: [RFC PATCH v7 07/26] mount: Support MOVE_MOUNT_CLONE with MOVE_MOUNT_T_MNTNS
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,ebiggers@kernel.org,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 20:28:11 +0000 (UTC)
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 88B831C0005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 7dbaparitxu45ottagwzwxpw1kqo5hue
X-HE-Tag: 1795379296-195629
X-HE-Meta: U2FsdGVkX1/lfWl4JFTqMsHY9UiYpqKH+v2DP1BX3QRYFIH2vQwb35GsSJYQL08BOTQij/l/QsRDQGnMcJK7eZL1LduGCbSfCM5aCKp44PAIVL3er+68GhNCzA3SyL0jcCnwxcCt/vovtisU+9V92+cUg2SkJ97wDl4JXJCGKsMipC97Pn8Lcg0Kv/6OWHyYHZIGVBdqw0psCW03lY8HX/g7O8yLKgaJsVVUqRJn3vo194Gb5AFFXSazj3GR77frA7Ie333wnEDKkGB0fbCdMLuKWCHnAvAc1m13bOjPDWIjB052BEzdWm8go4ChcFemuscS5Lr3IfbKb54Rf2z/YDuNziraI+qYg9RIM17s9+aFrBFO/zzMO6Obc4+oQbFMJvruxzjx1NxPpz3vaasJgBONcwy9O/Ek1Gf4mEGFIOMUNjTH9+w32JeCT7JUKduiKZz7PMq+ZfMVFD2MfsvmSg4/HnmIipMRgnc1vBdHM/gh7aciBFd29mW8g2Pmh5KGcmdz5+etBxP1WsEsf1VhRYAQsCMPNCP+FnNmHqVXipLXvSfN2o503FfTX1/INVVfhtJlJNkLFozq9JVj43EHJgD7ebsc8/Sk6bSzQYyMo8+ft8sU+TRC0THtn2KKikyZhk5GHTUN1Xl4sE9LW7y9XcsZSPor5C3HWpDdLkjhblpgygkwUi2eZffRfq4zlekJQq6AFxpYcjfylnlXfRteICnRPyaMKahWvJ6AWaS5qnOnxMeqRjfYFMuj0Baz7T43CpM3Su56DJznQi3AADNsY7B8CIqny791eE2xwa6JAwx3kkTp7GLjB1MIa7ubgxdggAKMKkL86zm6miPpwlORjYGgZaV6zYggXxurzB0q3Rqw2qZyO+usLvAkVPE7VcErMzM7buFCE4mbAoyv4TUUCkdEC1N7so4Lx5Lezq7B/jByM8MB2g4sGaZcSfzK/oY5ceketjpRMIJisTlF4YB
 cJFyjQDj
 zBY7eiBwupHGFMYxdd5LkLMfEBVgvHdW6992ngnHGp/+j1bvuuQmmvfiRFevoXWStQj/iejN47eTRU/M7EeSdDmh/jMWPfIcVbFCjE4rLUhP4dNlAtskzD/Vbzbu08JvrT66xr9Y9leVgvYFN1YltWtEAA+2kNK62dpCZLkqp8ua1/+YjAFJidLGtMMlHFzfFh0a57IvfVe1FwWxSaHj9y9E+gsxDuEh+4z0JjGYai3REk9lXoS39AyPJAqz+1XPKeAvpm34lqgRBF2w0cghe6jRKt+xFQmnUTQkeUo11Ao0UZNpnV/68PYffRDlDH1HYQ6Hbg4k5Au3fICyK1/FxG7sre1dmU3NKWE6VsBO6LXxNkf41NJhBa7SB8wU7LuiIn24+zeplijcpGtVpF9tCvQwPH1e5wnAMQNSvY0P6exOJtoZSkMexN0vwUHmGmcNvP7IxBnn3npW9goZ4apwercHIUWNoRLzk8Z9imYAjL47GyFQmNEFl/v3CiKijcxaOfiLvBnOWMNYRtXse4xasI4HbW6PPGbimmBEm1xF8Q1Il8WH+uUSVz5juPnd9a60LHjZwjK+uA82L1u9QGzwS/aF4yDG7MO1/+GvrBhJZDi5Q6+YPHXY9Z1Ig5PfahfAedGhJlLqu2j6G/L801IrQGhM/OpoRAtpZEpD+sk+swlQu5WD/QnrBSWzcBsszJekT15GfGL8u0yb5c9giP0mZu9ya7fxdqr5CaNEe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============4659356257046684705==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> mount: Support MOVE_MOUNT_CLONE with MOVE_MOUNT_T_MNTNS

TL;DR: MOVE_MOUNT_CLONE is reported to LSMs as a plain move, so AppArmor may
mediate it as MS_MOVE rather than a bind and could allow or refuse the clone
wrongly; should LSMs be told it is a clone?

> diff --git a/fs/namespace.c b/fs/namespace.c
> --- a/fs/namespace.c
> +++ b/fs/namespace.c

[ ... ]

> @@ -3842,6 +3840,36 @@ static int do_move_mount(const struct path *old_path,
> +		if (flags & MNT_TREE_CLONE) {
> +			unsigned int copy_flags;
> +
> +			if (!check_mnt(old) || old->mnt_ns == target_mnt_ns ||
> +			    (old->mnt.mnt_sb->s_flags & SB_NOUSER))
> +				return -EINVAL;
> +			src_user_ns = old->mnt_ns->user_ns;
> +			copy_flags = (target_mnt_ns->user_ns != src_user_ns) ?
> +				     (CL_SLAVE | CL_COPY_UNBINDABLE) :
> +				     CL_COPY_MNT_NS_FILE;
> +			cloned = __do_loopback(old_path, true, copy_flags);

With MOVE_MOUNT_CLONE this makes a recursive bind of old_path, but the only
LSM hook on this path is still security_move_mount(from_path, to_path) in
vfs_move_mount().  LSMs get no indication that the operation is a clone
rather than a move.

The clone branch requires check_mnt(old), so from_path is always attached
to the caller's namespace.  AppArmor's aa_move_mount() chooses between its
cases on exactly that property:

    if (!our_mnt(from_path->mnt))
        /* moving a mount detached from the namespace */
        from_path = NULL;
    ... match_mnt(profile, to_path, ..., from_path, ..., MS_MOVE, ...)

So AppArmor will evaluate this as an MS_MOVE of an attached mount at
from_path, the same check it makes for a real move.  But nothing is moved
here.  A copy of the source and of everything mounted below it is attached
at to_path, and since path_mounted() is no longer required, any directory
can be the source.

With open_tree(OPEN_TREE_CLONE) followed by move_mount(), AppArmor sees a
detached source (from_path == NULL) and applies its detached-move rules.
Can a profile that allows moving the mount at /src (an MS_MOVE rule with
/src as the source) now also clone /src, or any directory below it, into
another mount namespace?  Conversely, could a profile that only allows
detached moves refuse an operation that is equivalent to open_tree() plus
move_mount()?

Should the clone be reported to LSMs as a bind, for example through a
separate hook, a flag passed to security_move_mount(), or a call to the
bind-mount mediation?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45063222848
--===============4659356257046684705==--

