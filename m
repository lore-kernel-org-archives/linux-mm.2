Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0E72606A325
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 19:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CTP9jal/
Received: by kanga.kvack.org (Postfix)
	id 20CB26B0632; Thu, 19 Nov 2026 14:37:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E4B46B06A4; Thu, 19 Nov 2026 14:37:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FA0B6B06A5; Thu, 19 Nov 2026 14:37:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DC3F96B0632
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 14:37:08 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6857AC0479
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:37:08 +0000 (UTC)
X-FDA: 85452876936.13.37481CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id A3A1CA001B
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:37:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CTP9jal/";
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795117026;
	b=fl8sXE2ryW2LXTVQ+JxRqZ1DRrE6tz/rfFCIKQvkNOIjysg4s4iyOe/Y0FlE9Ix5jULtwh
	fLpOKPqDx+xsPqUB3nPbu0VPX8QLPB4kzNSumMvERm4/H5Kmfr5mJG7+9hisdyVmQg1Wbr
	LvrwcbD8jSXsy3JNWK96wLZSKtA7W+A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CTP9jal/";
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795117026;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j3OHGDRLYJbgj/ErJ8HaxI5UhxRADPxZ13wjmhDTfns=;
	b=fgOMT/VXUr6nVyc5sEWhXnnZ639o7gGdPgWB9CUOUNe2Xr8hpSxlHmmjKNi4vttIOx0HZU
	qexW/EirfbzpghM3G11I9qnKpwfDrlWOSnOmnJYZL6A3kl7tna1puYpbPcdsxga0kCnMRV
	hWpCz7QQW2JyU0CWcyvdB37x8R/MQ2w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 91099467A8;
	Thu, 19 Nov 2026 19:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B811F000C6;
	Thu, 19 Nov 2026 19:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795117025;
	bh=j3OHGDRLYJbgj/ErJ8HaxI5UhxRADPxZ13wjmhDTfns=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CTP9jal//bKnwBy4ySVLUylckhZpJ1oQ3RzkBH+MakR00H55hqpxMiM0UMyr2rTjy
	 TPcuKjGT7gdm0mDNHbhwNfHF5fK6x6y0dizYyHP/0YBUVzz8gnV2m9Kr58qkSN/x5Z
	 FpZbxkZm/2FivINqu78yjPSJbHekGGqs2zZrVjLrrQoUFOcL0WQJKDFCnk2oB5MDUT
	 DELNUYxzCICjI+YJf6QDNm/ZouSn/w2qMx9chXaOiNsliTtgPUu63o2atye1YaUtLJ
	 u7yBUphIJvQ35Mt9hI50jjUWoRFtf7HipHsXUomtppwVTjyTqmURVyTL7pFRQnd3Sr
	 /fi/TVAO7R6ow==
Message-ID: <sashiko-outbox-223954@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 12/13] selftests/rootns: Add root namespace test
 suite
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>, "David Howells" <dhowells@redhat.com>
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Andrew Morton" <akpm@linux-foundation.org>, "Andy
 Lutomirski" <luto@amacapital.net>, "Anna-Maria Behnsen" <anna-maria@linutronix.de>, "Ben
 Segall" <bsegall@google.com>, "Christian Brauner" <brauner@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Davidlohr Bueso" <dave@stgolabs.net>, "Dietmar
 Eggemann" <dietmar.eggemann@arm.com>, "Frederic Weisbecker" <frederic@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Jan Kara" <jack@suse.cz>, "John Johansen" <john.johansen@canonical.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Juri Lelli" <juri.lelli@redhat.com>, "Kees Cook" <kees@kernel.org>, "K
 Prateek Nayak" <kprateek.nayak@amd.com>, "Liam R. Howlett" <liam@infradead.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Manfred Spraul" <manfred@colorfullife.com>, "Mel
 Gorman" <mgorman@suse.de>, "Michal Hocko" <mhocko@suse.com>, "Mike Rapoport" <rppt@kernel.org>, "Neal
 Gompa" <neal@gompa.dev>, "Paul Moore" <paul@paul-moore.com>, "Pavel
 Tikhomirov" <ptikhomirov@virtuozzo.com>, "Peter Zijlstra" <peterz@infradead.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Serge Hallyn" <sergeh@kernel.org>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Steven Rostedt" <rostedt@goodmis.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Thomas Gleixner" <tglx@kernel.org>, "Valentin
 Schneider" <vschneid@redhat.com>, "Vincent Guittot" <vincent.guittot@linaro.org>, "Vincenzo
 Frascino" <vincenzo.frascino@arm.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Zygmunt
 Krynicki" <zygmunt.krynicki@canonical.com>
In-Reply-To: <20261118193539.240065-13-jarkko@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
 <20261118193539.240065-13-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 19:37:03 +0000
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A3A1CA001B
X-Stat-Signature: fw17bzqkkh1oe3eyhr6de9k9xozqas4t
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795117026-946106
X-HE-Meta: U2FsdGVkX1/gY5srxa2V7jozJrwBwzUH/auscYrJlG4suQEWU5t4gEoFZAVsGFwPEF/M2PtaFKmD2Tdoqohua5937GP+7uCRAFFYh4XnF0Lzsbo6bfclIcVLHoN5tuGNtRtBlsX1YAQLBrrfwFZauzeYzuU+Ky7RwUgkSpP5oPL0SPQGa7YOFCUM2IH7A/kRauoEGrGklr33NtzyX9eXTmOro7zSpNB4ECvRlTiTrfoPYGTSY5ZY5/HPJDn8A7hUvTLVIm7AHPlbxlwmpYPH5ayJ100IkXA6mqTor94CzeLeLQskFd7dOk+awnuRVobTLa+kUJnrDXaJKxLnq+G3mf3RzP1+c0AYJo/3SmlWjqSycoZPNZbAsHS7PlGhdoZldwMj1tLNdZqre5KNi8uq8TzxaU8pEIjuJH8Di0ihlZv0Ps9sCVxN4c3p/ByDerIwhthOa72wHNexfS7Wf56B8eKjpEp/7o17hwiV5D99oJNRWJX4tsOsiGONwtOGtBPtHZL9oYmIhTJP8lWK6J3GQZJ3jnnVVJBLyli43vd18oERGePHG1IBt1nFVJDO5aCWXwL2jdx66XpLdMDbV7xifoUpFv3AYjeTn8yFPyeU2juuosgAyAoCKI5JKPiF+OOLkpXsW0xHjqkJx8BCUewZTwg3E7BthA60FprJetmp8s4AtST2fiWMhm5N3rjAq94JnwdzFR6EsYyBqIcT/C4TNDju1mx8/voh7vtBrHGd7w9SmcKuQjFo1dIHiqXcx6PCI1o4d9jahN2ECu64lSBEgJcbRNSTpc1wh8Y6xTdNo5z2RHMDixkZ/SZuBSOMNljfRGP8aQWqeMVDW6LwONa9jQXDtMF2FdokslE5STtXaxhnJ9G/+KYY4wd2V5/+7xo8wVtM36ebj+6c9AjM6FCgyu6FgZWvI1/0NmXBOCXXVDbFngsAxySG9a7nWQAb4GqUnlinaijwUy2SOqRZV7a
 jAaPngdG
 vcS4mJWcGDzlPaQv6VwuCwvVM504MvaieyzqjCQQi1BQa2VQn3OBnRg1qnJi6jwyT9EYHRdQKaGE4cIMSsFDU/6d4LmLrJFO1c/Eaq3mB4hZn0nf6FygfdTSidAsOYapWDYozMl2C9vcY53N0zDObyuTrWCOPLXtrhkoFgN1fkQ2P2mZxJp8l6BrRvuLwrWy++1esbQ/IkhYUa/0e1wqXNh+d+Z30pp/88lJQfo9QS1gLJu9R/AZVJJTJqH8yxYBX42k9gBgNcAF5N6rU7TvoU/e8gNcpO6wRYaZeGlqFyC9KgGJAqDTXZ43jQPznDLvhz0Lqau+4SNZe021Vp4sK6eRDSURYv4K7IKOia6gyOQHs0w4kibtcD3WWHi7AWAg0euT+XdoVNsPRC/VN0plkn5XIorttQPG97j6ZZhFlxy0RL0JcN49JPmCzLXqopMb9HowwehfIg2mVuFiJtYc1KYGSCzZAjrhexD0E3GMT6NIG7sxENLXFF7WTsR4+yzZ6BNRRRHPZniv0pQ7UqAm/rce2ve0oQfFa68iMKp1NR47WDiF+Ue5xKa6k0ZxoyWc0c5msxRifthF9VSH0iRVKlaDE1w==
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
- [Medium] selftests/rootns: shared mount propagation in
  move_mount_existing_mntns()
- [Medium] selftests/rootns: missing SKIP() on ENOSYS and silent skips
  in child helpers
- [Low] selftests/rootns: stack direction and lifetime hazard in
  clone_with_flags()
--

commit 101069d69b43912a16a7832bfad97b5398c581ce
Author: Jarkko Sakkinen <jarkko@kernel.org>

selftests/rootns: Add root namespace test suite

This commit adds a kselftest harness suite under
tools/testing/selftests/rootns to verify the root namespace and mount
namespace configuration uAPI and security invariants.

> diff --git a/tools/testing/selftests/rootns/smoke.c b/tools/testing/selft=
ests/rootns/smoke.c
> new file mode 100644
> index 0000000000000..f0e3158ea4bec
> --- /dev/null
> +++ b/tools/testing/selftests/rootns/smoke.c
> @@ -0,0 +1,1934 @@

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
Can passing (char *)stack + stack_size to clone() write past the end of the
heap buffer on architectures where the stack grows upward, such as PA-RISC?
Also, if waitpid() fails (for example on EINTR), free(stack) runs while the
child may still be executing on that stack.  Using sys_clone3() with stack =
=3D 0
and stack_size =3D 0 would avoid manual stack allocation and work regardles=
s of
stack growth direction.

[ ... ]

> +FIXTURE_SETUP(rootns) {
> +	self->cfd =3D create_test_rootns(false, ROOTNS_KILL_ON_CLOSE |
> +				       ROOTNS_CLOSE_ON_EXEC);
> +	if (self->cfd < 0 && geteuid() !=3D 0 &&
> +	    (errno =3D=3D EPERM || errno =3D=3D EACCES || errno =3D=3D EINVAL ||
> +	     errno =3D=3D ENOSPC || errno =3D=3D EOVERFLOW))
> +		SKIP(return, "pre-idmap submount setup requires mapped userns");
> +	ASSERT_GE(self->cfd, 0);
> +}

[Severity: Medium]
Will this fail instead of skipping when CONFIG_ROOTNS is disabled (errno =
=3D=3D
ENOSYS) or when geteuid() =3D=3D 0 hits EPERM, EACCES, or ENOSPC?  Because =
rootns
is added unconditionally to TARGETS in tools/testing/selftests/Makefile whi=
le
CONFIG_ROOTNS defaults to n, running make run_tests on a kernel without
CONFIG_ROOTNS will fail all tests in this binary instead of skipping them.

The same issue applies to TEST(get_nsfd), while TEST_F(rootns, mount_perms)
omits -ENOSPC when checking the return value of create_rootns_as_uid().  In
addition, the forked child helpers in mount_perms, clone_perms, fsconfig, a=
nd
unpriv_no_userns call _exit(0) when unprivileged namespace creation fails
with EPERM, EACCES, EINVAL, or ENOSPC, causing the parent to report a silent
pass instead of a skip with a reason string (and unpriv_no_userns fails with
exit status 4 on ENOSYS).

[ ... ]

> +TEST_F(rootns, move_mount_existing_mntns) {
> +	int ready_pipe[2];
> +	int hold_pipe[2];
> +	char path[64];
> +	int marker_fd;
> +	int mntns_fd;
> +	char ch;
> +	pid_t pid;
> +	int fsfd;
> +	int mfd;
> +
> +	ASSERT_EQ(pipe2(ready_pipe, O_CLOEXEC), 0);
> +	ASSERT_EQ(pipe2(hold_pipe, O_CLOEXEC), 0);
> +
> +	pid =3D fork();
> +	ASSERT_GE(pid, 0);
> +	if (pid =3D=3D 0) {
> +		struct statfs st;
> +
> +		close(self->cfd);
> +		close(ready_pipe[0]);
> +		close(hold_pipe[1]);
> +
> +		if (unshare(CLONE_NEWNS) < 0)
> +			_exit(1);
> +		if (write(ready_pipe[1], "r", 1) !=3D 1)
> +			_exit(2);
> +		close(ready_pipe[1]);
> +
> +		if (read(hold_pipe[0], &ch, 1) !=3D 1)
> +			_exit(3);
> +		close(hold_pipe[0]);
> +
> +		if (statfs("/tmp", &st) < 0)
> +			_exit(4);
> +		if ((unsigned long)st.f_type !=3D (unsigned long)TMPFS_MAGIC)
> +			_exit(5);
> +		if (access("/tmp/hot_mounted", F_OK) < 0)
> +			_exit(6);
> +		_exit(0);
> +	}
> +	close(ready_pipe[1]);
> +	close(hold_pipe[0]);
> +
> +	ASSERT_EQ(read(ready_pipe[0], &ch, 1), 1);
> +	close(ready_pipe[0]);
> +
> +	snprintf(path, sizeof(path), "/proc/%d/ns/mnt", (int)pid);
> +	mntns_fd =3D open(path, O_RDONLY | O_CLOEXEC);
> +	ASSERT_GE(mntns_fd, 0);
> +
> +	fsfd =3D sys_fsopen("tmpfs", 0);
> +	ASSERT_GE(fsfd, 0);
> +	ASSERT_EQ(sys_fsconfig(fsfd, FSCONFIG_CMD_CREATE, NULL, NULL, 0), 0);
> +	mfd =3D sys_fsmount(fsfd, 0, 0);
> +	close(fsfd);
> +	ASSERT_GE(mfd, 0);
> +
> +	marker_fd =3D openat(mfd, "hot_mounted",
> +			   O_CREAT | O_WRONLY | O_CLOEXEC, 0644);
> +	ASSERT_GE(marker_fd, 0);
> +	close(marker_fd);
> +
> +	/* Existing mnt_ns already has "/", so "/" must fail with EBUSY. */
> +	ASSERT_EQ(sys_move_mount(mfd, "", mntns_fd, "/",
> +				 MOVE_MOUNT_F_EMPTY_PATH |
> +				 MOVE_MOUNT_T_MNTNS), -1);
> +	ASSERT_EQ(errno, EBUSY);
> +
> +	/* Hot-mounting onto a relative path inside the live mnt_ns succeeds. */
> +	ASSERT_EQ(sys_move_mount(mfd, "", mntns_fd, "tmp",
> +				 MOVE_MOUNT_F_EMPTY_PATH |
> +				 MOVE_MOUNT_T_MNTNS), 0);

[Severity: Medium]
Does sys_move_mount() here propagate the new tmpfs mount onto /tmp in the
host mount namespace?

Because the child calls unshare(CLONE_NEWNS) without unsharing a user
namespace or remounting "/" with MS_REC | MS_PRIVATE, its mounts stay in the
same shared peer group as the host mount namespace when "/" or "/tmp" is
mounted MS_SHARED (the default on systemd hosts).  Attaching mfd onto "tmp"
in mntns_fd then propagates a peer tmpfs mount onto the host's /tmp that
remains mounted after the child and mntns_fd exit, hiding the host's /tmp
contents.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118193539.2400=
65-1-jarkko@kernel.org?part=3D12

