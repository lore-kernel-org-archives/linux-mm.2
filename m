Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C670606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 23:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P0RFipSi
Received: by kanga.kvack.org (Postfix)
	id DD2336B05F5; Wed, 18 Nov 2026 18:15:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5BBB6B063C; Wed, 18 Nov 2026 18:15:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD6206B063D; Wed, 18 Nov 2026 18:15:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8F63C6B05F5
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:15:30 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1B103C08DA
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:15:30 +0000 (UTC)
X-FDA: 85449798420.22.E45BD83
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4C32D40009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:15:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P0RFipSi;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795043728;
	b=pL9S9w/7tl4BSp9K05H8NtIzw2vt6p7gP9m9z/kfu/I+RGn79MLK4WPImGGkcTk28eyuLL
	11Q6YPDEHJsuM9AvD1Pnzj2dB27GXvpyWKfZQp/R/qArMYmZlsfY/EoHaKGhWA5CGdAiJx
	iRKiHUDESlM8lnUnArogEB5EDdzxfEk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795043728;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mwmWAQshdigHpIdy3Qcm1XXYqTmHhApKgtFSeME4t04=;
	b=mL0PQK+RJu4PrkDz1tKN7KVmIzmelQ6Rjg8NMoifqDZM0YXDYierpueUHB5H0aNg+XDBDd
	B5haQw4TUBiG2VVJwqmHqKA4r+TgplUxoOzGTKQMh8WEM6aRe3BPpT02Hj0dTeg1oWhzg6
	PYngU0iqrnUgBNKHqRq/91gaWGhhn1M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P0RFipSi;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 931C642B17;
	Wed, 18 Nov 2026 23:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC041F000C4;
	Wed, 18 Nov 2026 23:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795043727;
	bh=mwmWAQshdigHpIdy3Qcm1XXYqTmHhApKgtFSeME4t04=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P0RFipSigDSpZXtTWMqbhT9ydNe9vL3SDc50iA0ZoZOeUNpM1x4J76EEzKQDHx9zE
	 QswuhfZLIvS/0m99MHuIxUyw5SZhGOLfJJQIuT2gnlCaqs+jFl3f+wEj+nKRd3M4/Y
	 z2GAz9PdZDHl5wzwiPGX2Pn9Q4EBNZ28aUO4N8DLM4TfRSfb0Fdfln+3uePk7EFGvO
	 f+nPEZDYExxpqOJR4njY/HqxF7hkwVkWHJKo0fJSBn0INUp7ueGLaZ0XV6zt/MaSCA
	 gVOefCSoqxeJzX8WdZogsxJVfhwLOMAJRyPQ4RNK0xFZ8v7bj0j6lJq6+EjTl95/WY
	 9IdW5+EXTjPPg==
Message-ID: <sashiko-outbox-222166@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 12/13] selftests/rootns: Add root namespace test
 suite
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
In-Reply-To: <20261117231352.3816603-13-jarkko@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
 <20261117231352.3816603-13-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 23:15:25 +0000
X-Stat-Signature: sf7a9cyths1hdd1amweccno7fwj8de7r
X-Rspamd-Queue-Id: 4C32D40009
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795043728-512121
X-HE-Meta: U2FsdGVkX18UVFOjexMhhkDHBsLGfkTzIftyAgZAbrAJ4on6YAYhUcKp4ZSL+Gi1vrfRZkpkqRnkUFZulHAX/j7yg+KpErhh5s4U8VqjSvAwXfyU9ogfpFqbY3lrKDHiiXmFAc0oWotdmqbqKeiW9Qxme47KJLGfkHn6SWjPzCaM3rXt6LO+YV78gB9thN70W1DWw02m35EjIpEuDooEP4CCY5hMpTtFuyLOJOjzBzoqsgJK2dLqu9Xddt8quZq+8nmh3z7d8L8qmUazH/r+pDgrUain1ErZjF091NEe6hgTbYxyr095jeQD7iqwYR0mXt0WW+yduFQAZE5ffJM3zvFihid/npgTK/BD92lE3T8aykIDNo3iPvCVADRNALPpMv8Eh+oQYIfX940Cheqr5S30O0mx1Qhifkw8p9/uZj4xKb2xsEZrQOT9K4TY843bdOvG8X+crmeEdlJgNDEynEqQfoBOAGYaIqEFGhUDdWmoOKbjHNOBuLdpmxRWoowg8ElqvDdxRtLPPM8mOiXouiTcX32KyW1hj6F5yhQru0h17+o71+BpVcmDy57v4rqq/eMZkw4yrm0oBxb/2vdWZUXOq/TWxt0bk4+gT+O02aH0cTq4bG/yi2YGR84FiprRvv06FDrLm67ANBLfrrhzWA3dzzqgh6PZqVrePPiggK9nG6lSS7bW0ZNkoxh9+1hCaRD0tFdaTOlhkiJPhx6m6XIVjUUyCDUwmUJW0CxYOaRfSpSkV/L8ypqS08nBtUg7u60BGn92Cl4hWFG+cncKoix0GLGxy6vm8SYyBqI+kGvYwKBmI73GUxRQBuMMx2Buc7WPXpVQTp0tqUhIU7hL87Xs0uffOG1v0Y+syJnNPNEJ43IPy2xf039y90YhQNvBxIMo+Gum09uvixJAbSlAuaUFxPWf8R3aqS+rXS7Rp/AqMJ7qXyODqA4wYVypVqm6K72Qc07TKS3RYO4DKDO
 v4MsiBl5
 Z01OWFlF1ZNbcnz33YoJc0cdpB11RpxwCToclvhn9BE+GoBKjRTxWtPf4bPhVdgm5yinUhC47VSrfvRqz4YFVik2OeCZEtAoOnGVRjhqQwSgK7D1qbNYg7dkuuxNSMAz5YEyOCZAIqZzhNQWSVRQ5NZZgWljkm54V/B7Ww1jpfC6phKHv9+sEejKoTj7NlktUbjyC6BQjOWlFSokddgnQ3URH0eyudhHTQTee67VcltPrUz6x3mM/QOrk/jHIDG1MUF5zDO4Fq0Uvj4TO/GSxVwtQ92JQoaza/LbbGmeQBWLwfxKxMwExVzyuuVAYyXJtfN1xOM4vW2PZdqXTIl9dFZVTbr8NJtRCI/anPGQCDV20YkZ3/PiPiqDX4C7IvL3Hiq4bWtK9z5SI0DU4TrcGNwu/NPLnNRYyaaULU2aM8vbl/uEe3i1lavVNd/bpQkAQue7RCCa/cL784K0gr6ZB281D+Z6V0uhInfENU2G3WPG7mrxJYtbncwv8qw1My+IE+Qlupzc9K7EBtwJwnVlM9JAbBxAhCMpCx9BDRktUZRa+WRZchwtd/wwCAd2AiF+oE83+hVu2ejQ6f5xURuguFLCLr4uj4ngaxDOuVlLMI5bOruPl6fWufVQc6dTvwHs/PI0d9osbEXIGgfQahVYLbFojg0SJmfLUi6uiEGDH4mPUvlghAtMdQ8ys1Tw5qbl9f+sNPnXXKQjp82PslZhEVeLH7caWqbWEYJer9HX/NfZhUak=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 9 potential
issues to consider:
- [Medium] selftests/rootns: enter_unpriv_user_mntns() fails to restore
  dumpability
- [Medium] selftests/rootns: PID 1 exit race with sibling tasks in
  clone_concurrent
- [Medium] selftests/rootns: missing SKIP() in setup and silent skips in
  child tests
- [Medium] selftests/rootns: setns tests fail to open /proc/self/ns/mnt
  and hang
- [Medium] selftests/rootns: nested_ns fails with EPERM in unmapped user
  namespace
- [Medium] selftests/rootns: fsconfig test fails with EPERM at
  sys_fsopen() for sysfs
- [Low] selftests/rootns: stack direction and lifetime hazard in
  clone_with_flags()
- [Low] selftests/rootns: fd leak in create_rootns_as_uid() when
  waitpid() fails
- [Low] selftests/rootns: fallback syscall definitions omit MIPS ABI
  offsets
--

commit 29bf6658ccf4cdfdf8e29f5c0581be3d7fb38e3f
Author: Jarkko Sakkinen <jarkko@kernel.org>

selftests/rootns: Add root namespace test suite

This commit adds a kselftest harness suite under
tools/testing/selftests/rootns to test root namespace creation,
clone3(CLONE_INTO_ROOTNS), mount configuration, and permission checks.

> diff --git a/tools/testing/selftests/rootns/smoke.c b/tools/testing/selft=
ests/rootns/smoke.c
> new file mode 100644
> index 0000000000000..350e6e8e25236
> --- /dev/null
> +++ b/tools/testing/selftests/rootns/smoke.c
> @@ -0,0 +1,1381 @@
[ ... ]
> +#ifndef __NR_rootns_create
> +#ifdef __alpha__
> +#define __NR_rootns_create 583
> +#define __NR_rootns_wait 584
> +#define __NR_rootns_kill 585
> +#else
> +#define __NR_rootns_create 473
> +#define __NR_rootns_wait 474
> +#define __NR_rootns_kill 475
> +#endif
> +#endif

[Severity: Low]
Do these fallback syscall numbers need to account for the MIPS ABI base
offsets (4000 for o32, 5000 for n64, and 6000 for n32)?  Without adding
 the _MIPS_SIM offset, a standalone build on MIPS without updated kernel
headers will invoke the wrong syscalls.

[ ... ]

> +static int clone_with_flags(int flags)
> +{
> +	const size_t stack_size =3D 64 * 1024;
> +	void *stack;
> +	pid_t pid;
> +	int status;
> +	int ret;
> +
> +	stack =3D malloc(stack_size);
> +	if (!stack)
> +		return -ENOMEM;
> +
> +	pid =3D clone(clone_exit, (char *)stack + stack_size,
> +		    SIGCHLD | flags, NULL);
> +	if (pid < 0)
> +		ret =3D -errno;
> +	else if (waitpid(pid, &status, 0) < 0)
> +		ret =3D -errno;
> +	else if (!WIFEXITED(status) || WEXITSTATUS(status))
> +		ret =3D -EIO;
> +	else
> +		ret =3D 0;
> +
> +	free(stack);
> +	return ret;
> +}

[Severity: Low]
Does passing (char *)stack + stack_size to clone() write past the end of
stack on upward-growing stack architectures such as PA-RISC?  In addition,
if waitpid() fails (for example on EINTR), free(stack) runs while the
child may still be executing on that stack.  Using sys_clone3() with a
NULL stack avoids both issues.

[ ... ]

> +	if (!err) {
> +		*cfd =3D recv_fd(sv[0]);
> +		if (*cfd < 0)
> +			err =3D errno;
> +	}
> +	close(sv[0]);
> +
> +	if (waitpid(pid, &status, 0) !=3D pid && !err)
> +		err =3D errno;
> +	if (!err && (!WIFEXITED(status) || WEXITSTATUS(status)))
> +		err =3D ECHILD;
> +
> +	return err ? -err : 0;
> +}

[Severity: Low]
Does create_rootns_as_uid() leak *cfd if recv_fd() succeeds but waitpid()
fails or the child exits non-zero?

[ ... ]

> +FIXTURE(rootns) {
> +	int cfd;
> +};
> +
> +FIXTURE_SETUP(rootns) {
> +	self->cfd =3D create_test_rootns(false, ROOTNS_ALL_NAMESPACES |
> +					ROOTNS_KILL_ON_CLOSE |
> +					ROOTNS_CLOSE_ON_EXEC);
> +	ASSERT_GE(self->cfd, 0);
> +}

[Severity: Medium]
Should FIXTURE_SETUP(rootns) call SKIP() when create_test_rootns() fails
with ENOSYS, EPERM, EACCES, or ENOSPC?  Because rootns is added to TARGETS
in tools/testing/selftests/Makefile while CONFIG_ROOTNS defaults to n,
asserting self->cfd >=3D 0 fails all 17 tests instead of skipping them when
CONFIG_ROOTNS is disabled or when the test runs without mount/namespace
privileges.

Similarly, pivot_root and mount_empty_path do not skip on EPERM,
mount_perms omits -ENOSPC from its SKIP() check, and the child processes
in mount_perms, clone_perms, and fsconfig call _exit(0) when prerequisites
are unavailable, reporting silent passes without a skip reason.

[ ... ]

> +TEST_F(rootns, nested_ns) {
> +	pid_t pid;
> +	int nsfd;
> +
> +	nsfd =3D open("/proc/self/ns/mnt", O_RDONLY | O_CLOEXEC);
> +	ASSERT_GE(nsfd, 0);
> +
> +	pid =3D clone_into_rootns(self->cfd, 0);
> +	ASSERT_GE(pid, 0);
> +	if (pid =3D=3D 0) {
> +		close(self->cfd);
> +
> +		if (unshare(CLONE_NEWNS))
> +			_exit(1);
> +		if (clone_with_flags(CLONE_NEWNS))
> +			_exit(2);
> +		if (unshare(CLONE_NEWUSER))
> +			_exit(3);
> +		if (clone_with_flags(CLONE_NEWUSER))
> +			_exit(4);

[Severity: Medium]
Won't unshare(CLONE_NEWUSER) and clone_with_flags(CLONE_NEWUSER) here fail
with EPERM?  self->cfd is created with ROOTNS_ALL_NAMESPACES (which
includes ROOTNS_USER), but no uid_map or gid_map is written for its user
namespace, so create_user_ns() rejects creating a child user namespace
because the caller's UID and GID are unmapped in parent_ns.  Even if
self->cfd's user namespace were mapped, unshare(CLONE_NEWUSER) moves the
child into a second unmapped user namespace before
clone_with_flags(CLONE_NEWUSER) runs.

[ ... ]

> +TEST_F(rootns, setns_same) {
> +	ssize_t nwritten;
> +	pid_t pid1;
> +	pid_t pid2;
> +	char ch;
> +	int nsfd;
> +	int sv[2];
> +
> +	ASSERT_EQ(socketpair(AF_UNIX, SOCK_DGRAM | SOCK_CLOEXEC, 0, sv), 0);
> +
> +	pid1 =3D clone_into_rootns(self->cfd, 0);
> +	ASSERT_GE(pid1, 0);
> +	if (pid1 =3D=3D 0) {
> +		int ret;
> +
> +		close(self->cfd);
> +		close(sv[0]);
> +		ret =3D send_unshared_mntns_and_wait(sv[1]);
> +		close(sv[1]);
> +		_exit(ret);
> +	}
> +	close(sv[1]);
> +
> +	nsfd =3D recv_fd(sv[0]);

[Severity: Medium]
Does send_unshared_mntns_and_wait() fail with ENOENT here and leave the
parent hanging in recv_fd(sv[0])?

Both self->cfd (in setns_same) and beta_cfd (in setns_foreign below) are
created with create_test_rootns(false, ...), which mounts an empty tmpfs
at /proc instead of procfs.  When the child calls
send_unshared_mntns_and_wait(), open("/proc/self/ns/mnt", ...) fails with
ENOENT and the child exits without sending a descriptor.  Because sv is a
SOCK_DGRAM socketpair, closing sv[1] does not deliver EOF to sv[0], so
recv_fd(sv[0]) blocks until the test times out.

[ ... ]

> +static int enter_unpriv_user_mntns(uid_t drop_uid)
> +{
> +	char map[32];
> +	uid_t uid;
> +	gid_t gid;
> +	int fd;
> +	int len;
> +
> +	if (geteuid() =3D=3D 0 &&
> +	    (setresgid(drop_uid, drop_uid, drop_uid) < 0 ||
> +	     setresuid(drop_uid, drop_uid, drop_uid) < 0))
> +		return -errno;
> +
> +	uid =3D geteuid();
> +	gid =3D getegid();
> +	if (unshare(CLONE_NEWUSER | CLONE_NEWNS) < 0)
> +		return -errno;
> +
> +	fd =3D open("/proc/self/setgroups", O_WRONLY | O_CLOEXEC);
> +	if (fd >=3D 0) {
> +		(void)write(fd, "deny\n", 5);
> +		close(fd);
> +	}
> +
> +	fd =3D open("/proc/self/uid_map", O_WRONLY | O_CLOEXEC);
> +	if (fd < 0)
> +		return -errno;

[Severity: Medium]
When the test runs as root, does dropping privileges via setresgid() and
setresuid() clear task dumpability and cause open("/proc/self/uid_map",
O_WRONLY | O_CLOEXEC) to fail with EACCES?

Without prctl(PR_SET_DUMPABLE, 1, 0, 0, 0) after setresuid(), files under
/proc/self/ remain owned by global root (0:0), which is unmapped in the
newly unshared user namespace.  enter_unpriv_user_mntns() then returns
-EACCES, and all three callers (mount_perms, clone_perms, and fsconfig)
treat -EACCES as _exit(0), silently skipping their unprivileged permission
checks.

[ ... ]

> +		ucfd =3D sys_rootns_create(ROOTNS_USER | ROOTNS_CLOSE_ON_EXEC);
> +		if (ucfd < 0) {
> +			if (errno =3D=3D EPERM || errno =3D=3D EACCES ||
> +			    errno =3D=3D EINVAL || errno =3D=3D ENOSPC)
> +				_exit(0);
> +			_exit(2);
> +		}
> +
> +		sfd =3D sys_fsopen("sysfs", 0);
> +		if (sfd < 0) {
> +			if (errno =3D=3D ENODEV) {
> +				close(ucfd);
> +				_exit(0);
> +			}
> +			_exit(3);
> +		}
> +
> +		if (sys_fsconfig(sfd, FSCONFIG_SET_ROOTNS, NULL, NULL, ucfd) < 0)
> +			_exit(4);
> +		if (sys_fsconfig(sfd, FSCONFIG_CMD_CREATE, NULL, NULL, 0) !=3D -1 ||
> +		    errno !=3D EPERM)
> +			_exit(5);

[Severity: Medium]
Doesn't sys_fsopen("sysfs", 0) fail with EPERM here before reaching
FSCONFIG_SET_ROOTNS?

enter_unpriv_user_mntns() unshares CLONE_NEWUSER | CLONE_NEWNS but keeps
the parent network namespace, so sysfs_init_fs_context() ->
kobj_ns_current_may_mount(KOBJ_NS_TYPE_NET) rejects sys_fsopen("sysfs", 0)
with EPERM and the child exits with status 3.  Furthermore, even if
CLONE_NEWNET were unshared, sysfs_init_fs_context() sets fc->global =3D true
and binds fc->user_ns to netns->user_ns, so FSCONFIG_CMD_CREATE would
succeed rather than failing with EPERM.

[ ... ]

> +			ent_pid =3D clone_into_rootns(self->cfd, 0);
> +			if (ent_pid < 0)
> +				_exit(1);
> +			if (ent_pid =3D=3D 0) {
> +				unsigned char my_pid =3D (unsigned char)getpid();
> +
> +				if (write(ready_pipe[1], &my_pid, 1) !=3D 1)
> +					_exit(2);
> +				close(ready_pipe[1]);
> +				(void)read(hold_pipe[0], &ch, 1);
> +				close(hold_pipe[0]);
> +				_exit(0);
> +			}
> +
> +			close(ready_pipe[1]);
> +			close(hold_pipe[0]);
> +			close(self->cfd);
> +			_exit(reap_child_exit_code(ent_pid) =3D=3D 0 ? 0 : 3);
> +		}
> +	}
> +
> +	close(start_pipe[0]);
> +	close(ready_pipe[1]);
> +	close(hold_pipe[0]);
> +	close(start_pipe[1]);
> +
> +	for (i =3D 0; i < 4; i++) {
> +		unsigned char pid_byte =3D 0;
> +
> +		ASSERT_EQ(read(ready_pipe[0], &pid_byte, 1), 1);
> +		ASSERT_GE(pid_byte, 1);
> +		ASSERT_LE(pid_byte, 4);
> +		seen_mask |=3D 1U << pid_byte;
> +	}
> +	close(ready_pipe[0]);
> +	close(hold_pipe[1]);
> +
> +	ASSERT_EQ(seen_mask, 0x1eU);
> +
> +	for (i =3D 0; i < 4; i++)
> +		ASSERT_EQ(reap_child_exit_code(workers[i]), 0);

[Severity: Medium]
When close(hold_pipe[1]) wakes all four processes in the rootns PID
namespace at once, can PID 1 exit before PIDs 2..4 and kill them via
zap_pid_ns_processes()?

CPU0 (rootns PID 1)               CPU1 (rootns PID 2)
read(hold_pipe[0]) returns 0
                                  read(hold_pipe[0]) returns 0
_exit(0)
  zap_pid_ns_processes()
    send_sig_info(SIGKILL, p)
                                  terminated by SIGKILL
                                  worker: reap_child_exit_code() -> -2
                                  worker exits with 3  <-- test fails

Because reap_child_exit_code() requires WIFEXITED(status), any non-init
sibling killed by SIGKILL before completing _exit(0) causes its worker to
exit with code 3 and fails the test.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117231352.3816=
603-1-jarkko@kernel.org?part=3D12

