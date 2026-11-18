Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8218B606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 05:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G+4QWKlM
Received: by kanga.kvack.org (Postfix)
	id 6323D6B05BD; Wed, 18 Nov 2026 00:10:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BB056B05BE; Wed, 18 Nov 2026 00:10:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AA5E6B05BF; Wed, 18 Nov 2026 00:10:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D7336B05BD
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:10:04 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 66F13A0689
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:10:03 +0000 (UTC)
X-FDA: 85447063086.23.63E64ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id B2F4340004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:10:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G+4QWKlM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794978601;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ugu7136n0phHWTp0Xu6U3RBZsZkHHH+GDVqBhVt6IhY=;
	b=KpPHgsVke48biZnFbXwSCPypMr76+i2efIfoWy7+EIPOPIYPf0BLG+Ihcp2Q2gOcrt59/h
	Wask/J8nLJ+1pfz5WqUAxvVkZRZCZdILWneMaiVb8Zb6mqpEpIW8AoxaDa/wmi0K1s6hl3
	mI0zJFvK7ObnXzX9qBeXTGex7/6XbeE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794978601;
	b=R5YoAzUIMxv5maPVRXTxAVHkggP/EIVwg1UNJZyRwlP6wp0aGkuqHGK/GRaYvduLxjUQgT
	+mUtfDN37lpGEQzSJgcyMkt5e4tEiewhR1XPFaypmvbNyAsDK96JNDDwl4eYMWBnWcfkxt
	dVdbEUTC/yH801t8wMkq8wvq6gXJZu4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G+4QWKlM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 07759444CD;
	Wed, 18 Nov 2026 05:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A76A1F000C5;
	Wed, 18 Nov 2026 05:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794978600;
	bh=Ugu7136n0phHWTp0Xu6U3RBZsZkHHH+GDVqBhVt6IhY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G+4QWKlMds11vQEsnyP1gfbzgvENRLjhFBKl7SXGb5q/ME69/SXkT1ZOwToe9hiR7
	 lRkdJI6ZYXv/mMOOCm7yIqpngcRG8rnmXqy1AmO/cW1wR1vBkclUejuVi8wCQbyoE1
	 JHH9pdaOMfVNLEwpXiW+yau1WFak+piEZvKCXUxrQQnw1NNzPBsCBp6EuAUq1oVxeW
	 Da+nVhDnHiKec/QbebIcLsGgK3CfxsLHiTrNdb6mGl8F+Nj5imhG3XhHXZEu6I1KNV
	 jQpw2uo//J5xEvCjJLYx906gXB9IZf4k8QI683MDW+2EeXVhhJFzeBZe/bzQw6NO/l
	 /bnwbM3UeTPNQ==
Message-ID: <sashiko-outbox-220147@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 12/13] selftests/rootns: Add root namespace test
 suite
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
In-Reply-To: <20261117050841.3289652-13-jarkko@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
 <20261117050841.3289652-13-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 05:09:58 +0000
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B2F4340004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	TVD_PH_BODY_ACCOUNTS_PRE autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: dd4qpkniw6mq4icqf6dnp3oe91uogigu
X-Rspam-User: 
X-HE-Tag: 1794978601-342267
X-HE-Meta: U2FsdGVkX1+BpUElMKEleVbhs0WyxBSIC76o0ghtqydpEgoFFdlJHVwtfXc/eMvjicYsEg7131/nAY2abhtXhNAGzOicCl/bCLaMMsN4yhXr7F38hXMfEY7Wp5pKWmDqaGn18fSkofhq/cwML1dtHh/F714XW/sfcVtFNNUpTdRbwxuJnux7ViHQq6AuvJY81l0oKF69eLoObd2QmwJl4muhonGuHimR6Cn1bgrEzSaK2zaK2tmhDr7b+OwMvLb57EfrpL0CGuOQROpB+B/UtADRXLNMd+C4UV9PgYTe1Dm1+9PxAP4hQKhw7OLsPuMcesj7UEuBtkvuAaR4Pzw2DZTrUj0+pBg6boYf6YVj9m9+492s2WNTGFJciOgxJ2kdfA8rk0FsKq9kExjq7oGEN898WQ/l9HzPpmJbfRoTWuUXgYcfvdsJPMuDnIJzxZZaLOIA9KdhpMHhQ3ta5NPqyjC8A4yAAJQK81O5U5mmTtsotGpnB1P4j9T5oYK7Fp6tKOdzqnrtwiUP9f0pgZYQCM4wb/oR2ASJAsHMqzbGhtqtZH1ZCduNEOFYZKrbVZhbob4kARCfnARpTH+0arPidckTDQKC+CCnFxrl9SJm5EHWbEqxwNkwPhrUa4eEVxo6SZ8VtOdTMxmLwGtO5cVeTbURKkve27F/AQeNjgOCahh52/r1ytFR5KX+Tk8BPTm1RkQsjEemhUM7DNQzCsvu3vHBO9UbNVdy2KdWRBIA9Tsb+OA5KwqsJXvhQ3z3eqSpfYIZP6kvLAaIeH96RuP+ujZg53DeRQ+XUICSfeTmgaC2wN5I/LwFEUYmW/EPKh1dYGP8H9XvwWUX/OrhzhFaO5etGxuK5q3zpIRiLyMwwmIF0YqKBSCLcj+3hEL5RzLNynDNUWg/Nukhi5GxRGEUXqOuoazX5CYPzt9otGfd+FZ4kFePDQo/9zyw9YEuN6EUyg83pxD3f8WZQbNBsOu
 hjmwm7yi
 DE2E/9k23VYOQEok5FI6kk8iX+4439fDJnazIszSO0YuF9+o5NRrCSeCepK9KYbn+z1QRtsJ9pv34k/if5eq3HFEcxIK2hwipqKlcSMDK7njOhAoGi4hPkmhIZfc3JDXjrvGfYJtR7A3COQYO5sEcBkE+3LJpdjb7YOWcUmTQjCCBkmu2BKDtNoTlTAFriLYx8ApgTHeZssXkkBb5oCunvsxidbEIAEt6P5fexmfgtymeS71THReKWnhdnWjRBmlG1Bwzbyzt0UV4yEuVHbU96q516D1kgkkqXOCRGgbtYDvJcRy+dkDzzQRRh0hpjkN0V04P6WV2hKTyRjSMLjf3oyOmLkPN+yzPHOB5YcMeF59/RS7lDjaY8yy/tkMbmM+aojPtyOFxVVHYNXauSHbUTSFP1eSyIgsxsPOw7cpD1qogbNq4xh4WQDsBiH/qqhVLAhHzz9ZBiP55NOLhSgo9nIMtvekLSH6O7Qti1FYBglK/M5O0XmQ2ErCs0YAX+PEV/xE5mMOQs7UZx9z0IGJxUaQA8KJxrrJbGDVUa6TIWCJx5RcrrAlxQxSKOBU6OXgfQ/u2Y03utA7Ttm1mXrQXI/UzZg==
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
- [Medium] selftests/rootns: setns tests fail to open /proc/self/ns/mnt
  and hang
- [Medium] selftests/rootns: nested_ns fails with EPERM in unmapped user
  namespace
- [Medium] selftests/rootns: enter_perms fails under PR_SET_NO_NEW_PRIVS
  as owner
- [Medium] selftests/rootns: PID 1 exit race with sibling tasks in
  enter_concurrent
- [Medium] selftests/rootns: missing SKIP() in fixture setup and silent
  child skips
- [Medium] selftests/rootns: enter_unpriv_user_mntns() fails to restore
  dumpability
- [Medium] selftests/rootns: fsconfig test fails with EPERM at
  sys_fsopen() for sysfs
- [Low] selftests/rootns: fallback syscall definitions omit MIPS ABI
  offsets
- [Low] selftests/rootns: fd leak in create_rootns_as_uid() when
  waitpid() fails
--

commit 180af99245923a2ffc15ed3bd6aa532d0e868807
Author: Jarkko Sakkinen <jarkko@kernel.org>

selftests/rootns: Add root namespace test suite

This commit adds a kselftest harness suite under
tools/testing/selftests/rootns to test root namespace creation, lifecycle,
mount configuration, and permission checks.

> diff --git a/tools/testing/selftests/rootns/smoke.c b/tools/testing/selft=
ests/rootns/smoke.c
> new file mode 100644
> index 0000000000000..fdb6a74822204
> --- /dev/null
> +++ b/tools/testing/selftests/rootns/smoke.c
[ ... ]
> +#ifndef __NR_rootns_create
> +#ifdef __alpha__
> +#define __NR_rootns_create 583
> +#define __NR_rootns_wait 584
> +#define __NR_rootns_kill 585
> +#define __NR_rootns_enter 586
> +#else
> +#define __NR_rootns_create 473
> +#define __NR_rootns_wait 474
> +#define __NR_rootns_kill 475
> +#define __NR_rootns_enter 476
> +#endif
> +#endif

[Severity: Low]
On mips, syscall numbers in syscall_*.tbl are offset by the ABI base (4000
for o32, 5000 for n64, and 6000 for n32).  Should the fallback definitions
account for _MIPS_SIM so builds without updated system headers do not invoke
unrelated syscalls?

[ ... ]

> +static int create_rootns_as_uid(uid_t uid, unsigned int flags, int *cfd)
> +{
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
Does create_rootns_as_uid() leak *cfd if recv_fd() succeeds and waitpid() or
the child exit status check then sets err?

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
Does FIXTURE_SETUP(rootns) fail all 16 tests instead of skipping when
CONFIG_ROOTNS is disabled (ENOSYS) or when the test runs without root
privileges (EPERM from sys_fsopen("tmpfs", 0) in mount_root())?

Because rootns is added unconditionally to TARGETS in
tools/testing/selftests/Makefile while CONFIG_ROOTNS defaults to n, missing
kernel support or privileges should call SKIP(return, ...) with a reason
string.  Conversely, the child helpers in mount_perms and fsconfig call
_exit(0) when unprivileged user namespaces or sysfs are unavailable, which
reports a silent pass instead of a skip with a reason.

[ ... ]

> +TEST_F(rootns, nested_ns) {
> +	pid_t pid;
> +	int nsfd;
> +
> +	nsfd =3D open("/proc/self/ns/mnt", O_RDONLY | O_CLOEXEC);
> +	ASSERT_GE(nsfd, 0);
> +
> +	pid =3D sys_rootns_enter(self->cfd);
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
> +		if (setns(nsfd, CLONE_NEWNS) !=3D -1 || errno !=3D EPERM)
> +			_exit(5);
> +
> +		close(nsfd);
> +		_exit(0);
> +	}
> +
> +	close(nsfd);
> +	ASSERT_EQ(reap_child_exit_code(pid), 0);
> +}

[Severity: Medium]
Will unshare(CLONE_NEWUSER) and clone_with_flags(CLONE_NEWUSER) always fail
with EPERM here?

FIXTURE_SETUP(rootns) creates self->cfd with ROOTNS_ALL_NAMESPACES (which
includes ROOTNS_USER), allocating a new user namespace with no UID or GID
mappings.  When the child enters self->cfd and calls unshare(CLONE_NEWUSER),
create_user_ns() checks kuid_has_mapping() and kgid_has_mapping() in the
parent user namespace (self->cfd->cred->user_ns) and returns -EPERM, causing
the child to exit with status 3.  In addition, unshare(CLONE_NEWUSER) places
the child into another unmapped user namespace before
clone_with_flags(CLONE_NEWUSER) runs, so the second user namespace creation
also fails with EPERM unless UID and GID mappings are written first.

> +
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
> +	pid1 =3D sys_rootns_enter(self->cfd);
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
> +	ASSERT_GE(nsfd, 0);

[Severity: Medium]
Does recv_fd(sv[0]) hang in both setns_same and setns_foreign after
send_unshared_mntns_and_wait() fails with ENOENT?

Both self->cfd (in FIXTURE_SETUP) and beta_cfd (in setns_foreign) are
created via create_test_rootns(false, ...), which mounts an empty tmpfs at
/proc instead of procfs:

tools/testing/selftests/rootns/smoke.c:mount_proc() {
	const char *fstype =3D need_proc ? "proc" : "tmpfs";
}

When pid1 (or beta_pid) enters the rootns and runs
send_unshared_mntns_and_wait(), open("/proc/self/ns/mnt", ...) fails with
ENOENT and the child exits without calling send_fd().  Because sv is an
AF_UNIX SOCK_DGRAM socketpair, closing sv[1] on child exit does not wake a
blocking recvmsg() on sv[0], so the parent blocks in recv_fd(sv[0]) until
the test harness times out.

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
When the test runs as root, does enter_unpriv_user_mntns() always fail with
-EACCES when opening /proc/self/uid_map?

Dropping privileges with setresgid() and setresuid() clears task dumpability
in commit_creds(), which makes /proc/self/uid_map owned by GLOBAL_ROOT_UID.
After unshare(CLONE_NEWUSER), GLOBAL_ROOT_UID is unmapped in the new user
namespace, so open("/proc/self/uid_map", O_WRONLY | O_CLOEXEC) fails with
EACCES unless prctl(PR_SET_DUMPABLE, 1, 0, 0, 0) is called after
setresuid().  Because both mount_perms and fsconfig treat -EACCES from
enter_unpriv_user_mntns() as _exit(0), both tests silently skip their
unprivileged checks when run as root.

[ ... ]

> +TEST_F(rootns, enter_perms) {
> +	pid_t pid;
> +	int cfd;
> +
> +	cfd =3D sys_rootns_create(ROOTNS_ALL_NAMESPACES |
> +			    ROOTNS_KILL_ON_CLOSE |
> +			    ROOTNS_CLOSE_ON_EXEC);
> +	ASSERT_GE(cfd, 0);
> +
> +	ASSERT_EQ(sys_rootns_enter(cfd), -1);
> +	ASSERT_EQ(errno, ENOENT);
> +
> +	ASSERT_EQ(mount_root(cfd), 0);
> +
> +	pid =3D fork();
> +	ASSERT_GE(pid, 0);
> +	if (pid =3D=3D 0) {
> +		if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0) < 0)
> +			_exit(1);
> +		if (sys_rootns_enter(cfd) !=3D -1 || errno !=3D EPERM)
> +			_exit(2);
> +		close(cfd);
> +		_exit(0);
> +	}
> +
> +	ASSERT_EQ(reap_child_exit_code(pid), 0);
> +	close(cfd);
> +}

[Severity: Medium]
Does sys_rootns_enter(cfd) succeed here instead of failing with EPERM?

The child inherits the same credentials that created cfd, so in
may_enter_rootns_creds(old, target), cred_cap_issubset(old, target),
uid_eq(old->euid, target->euid), and gid_eq(old->egid, target->egid) all
hold (as old->user_ns =3D=3D target->user_ns->parent and old->euid =3D=3D
target->user_ns->owner).  may_enter_rootns_creds() returns true before
checking task_no_new_privs(current), causing the child to fork into the
rootns and exit with status 2.

> +
> +TEST_F(rootns, fsconfig) {
[ ... ]
> +	pid =3D fork();
> +	ASSERT_GE(pid, 0);
> +	if (pid =3D=3D 0) {
> +		int ucfd;
> +		int ret;
> +		int sfd;
> +
> +		ret =3D enter_unpriv_user_mntns(1000);
> +		if (ret =3D=3D -EPERM || ret =3D=3D -EACCES || ret =3D=3D -EINVAL ||
> +		    ret =3D=3D -ENOSPC)
> +			_exit(0);
> +		if (ret < 0)
> +			_exit(1);
> +
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
When enter_unpriv_user_mntns() succeeds, doesn't sys_fsopen("sysfs", 0) fail
with EPERM and exit with code 3 before reaching sys_fsconfig()?

enter_unpriv_user_mntns() unshares CLONE_NEWUSER | CLONE_NEWNS without
CLONE_NEWNET, so current->nsproxy->net_ns still belongs to the parent user
namespace.  sysfs_init_fs_context() checks
kobj_ns_current_may_mount(KOBJ_NS_TYPE_NET), which requires CAP_SYS_ADMIN in
net_ns->user_ns and fails during fsopen("sysfs", 0) with EPERM.

> +
> +		close(sfd);
> +		close(ucfd);
> +		_exit(0);
> +	}
> +
> +	ASSERT_EQ(reap_child_exit_code(pid), 0);
> +}
> +
> +TEST_F(rootns, enter_concurrent) {
[ ... ]
> +			ent_pid =3D sys_rootns_enter(self->cfd);
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
[ ... ]
> +	close(ready_pipe[0]);
> +	close(hold_pipe[1]);
> +
> +	ASSERT_EQ(seen_mask, 0x1eU);
> +
> +	for (i =3D 0; i < 4; i++)
> +		ASSERT_EQ(reap_child_exit_code(workers[i]), 0);

[Severity: Medium]
Can PID 1 inside the rootns exit before PIDs 2..4 when hold_pipe[1] is
closed, killing its siblings with SIGKILL and failing the test?

CPU0 (rootns PID 1)               CPU1 (rootns PID 2 / worker)
read(hold_pipe[0]) -> EOF
_exit(0)
  zap_pid_ns_processes()
    group_send_sig_info(SIGKILL)
                                  killed by SIGKILL
                                  reap_child_exit_code(ent_pid)
                                    !WIFEXITED(status) -> returns -2
                                    worker calls _exit(3)  <-- test fails

Closing hold_pipe[1] wakes PID 1 and PIDs 2..4 at the same time, and PID 1
was queued first on hold_pipe[0].  If PID 1 reaches zap_pid_ns_processes()
before a sibling finishes _exit(0), the sibling is terminated by SIGKILL and
reap_child_exit_code() fails because !WIFEXITED(status).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117050841.3289=
652-1-jarkko@kernel.org?part=3D12

