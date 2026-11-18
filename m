Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5618606A332
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 16:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Aa/n9neT
Received: by kanga.kvack.org (Postfix)
	id D6F1A6B05B8; Wed, 18 Nov 2026 11:17:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD2346B05BA; Wed, 18 Nov 2026 11:17:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9B5A6B05BB; Wed, 18 Nov 2026 11:17:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 732236B05B8
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:17:45 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F2C80160723
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:17:44 +0000 (UTC)
X-FDA: 85448745648.05.43164CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6D8AE100009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:17:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Aa/n9neT";
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795018663;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wdmvDL+6fG1daxzhdpbmTQI8QSWZpyN8n/MnRWQGMgg=;
	b=sjMuDUPs9PQnl1SH7cB4sL3TmbmbO9MCKxMN0smXsj4EaA/DzxSjD/xtQGR7zl7ECTW604
	ubQB/HFbBw4+Y7DClkRpTPWLE7qwCb+bMGL3lCKf/mxf+UbZ676AgexjBdNA34EScKmJAC
	rI4sVXIfMhYSJo/StKoW1L3rhXZ7POY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795018663;
	b=b7BCZUQwueJLJFj8Xzpq9IxPyAf8hWM5ZRlOFR2t7/C4DevqTWPgsxsxNX3dpIYFtQWJXT
	kul6lKY9G7tGJkPUNqC0IXS/AmjlIcfCDUw8Tu7wfk20tMmUX/VRMcNXp1N5A4X+A5C3fz
	ooxJgw4Xjis+PFyzXiF8ue2VVt0LLKk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Aa/n9neT";
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 10BF26283E;
	Wed, 18 Nov 2026 16:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACCE1F000C6;
	Wed, 18 Nov 2026 16:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795018662;
	bh=wdmvDL+6fG1daxzhdpbmTQI8QSWZpyN8n/MnRWQGMgg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Aa/n9neT3l+v5gPMwAxwLSIG5iPoHgzoj97KqcJlyBH6MU/lxVf/u99pjGDi+0qRQ
	 mR4RP2o9GHem8Qv82JFkx+LQsYYJGtDTGZA+Y1UNSQyR/MjPyUeVJxL/kLVKHiUsRe
	 gtc9zNvRW4EW0TQ9+ur/H7oyt1dyzd3kmph6ZHTAHDL82m2fkuAGcxeFJPiNNDExxB
	 X6V7Hi4rVXuWeXcUB2qeqA4jo2Kp+rid9+jv4wTyYequ4+hcmuRMSFnOtRvvG5r8Uh
	 0FDdBOxZ4btt9Xf3y3PiuCTCOHYk8I1fKJAhycKJ3ADAy9qs4tJ1ko9LOAWICujJXG
	 BqsjJYApKQbsw==
Message-ID: <sashiko-outbox-221459@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 16/17] selftests/rseq: Test affinity changes while a
 task replaces or drops its mm
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, tglx@kernel.org, peterz@infradead.org
Cc: mingo@redhat.com, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, paulmck@kernel.org, boqun@kernel.org, shuah@kernel.org, kees@kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, oleg@redhat.com, bestswngs@gmail.com, xmei5@asu.edu, xujiakai24@mails.ucas.ac.cn, linux-mm@kvack.org
In-Reply-To: <ccc2a6c50429b1ad9c8d5cc45ec8e58c12df7fde.1794932121.git.mathieu.desnoyers@efficios.com>
References: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
 <ccc2a6c50429b1ad9c8d5cc45ec8e58c12df7fde.1794932121.git.mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 16:17:41 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6D8AE100009
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: nr78wd8qreexs7kt19qwxjfe4zaz4abn
X-HE-Tag: 1795018663-113804
X-HE-Meta: U2FsdGVkX18WDxixJVmtwydxi5qLPqGrHTg6tRnRVneR0WizmbRcdY/dn3bZJZcCYp9lvosp/Q3RyMytdzpHIMYrt6dmIyfNBdWaGLV5EI6sIWhJIK12sh94S3AGDMNB/pOQmONK4ZZJClHnpxvluS+sZJKQR1ErHCJSxoVHcDm4MPWALvAMdqt3JAu+8R+wzm9qtZP+QkLGiPZ4QNlxFH9UGgpYbE3ZSwlEqhEjnaIwZJox23RLeybyJasJBYjw2RY/gACVEuAh7XFZ0n3E6OvxJ7DUj30myvhYNaJfL09U6rsT38Oee6Lzqnai1Nwh/Vt/a/l0JlxagrZSeuqitsvJSHTq3C5YYZP+0gAOe6VLZjMoel4ge9X7U+qhPunbmefR/waRFMfDy+eO2rWsl9SIDTqRY0zFeSQ9bWllfMpFX/Y861+i0uUN6RRNbsnZiNbt4Q/CIVELcEhgBTVTN5F76TY7HUomnDtu1LGH6JIf9PggNZn2S6zCPamGDb2CFuxS5itGernl0/h6aB+B0n6tA30QgSdU1lgtX+VepizasjSprQqpUJZUQlpHwY7MGPc1AZjUIsuuFjNDp1RyF6guGt8ReblBz2UFFCmNPlUNxFphbtXBp2xL8p6fs0tyfOzRGPamYC4lOiFc/l5kNC0AouEb2thGB+DRNo6AFilLG8QYLv9ZQUUrzsJn0rmzntcwHec9V6JRROmeubNAebO4U8VYFj0NeuTnWse9CBdvYoYl9OU5Imvfr0QXxjubOK8KwZYbgGXe91zBxr3+CP3QmVCeM0OhULqJYR02DoeOrCIKl98REbeq3vcd2P/M6oDttw4owAbG57HpS8eCXqLRJfgGmGXG2AUPhsHtVk2LcGjzUBsTDhc9Z/51WG9LpHPgAI36oDQIPvCs1oMYQ7owREH50qX0v/uwXSlcZCS75+HGUlRwCj3l7Bo9Ag90vUcdFtBvw/0fzog+VJh
 9PGLCwiZ
 l7zm546KgWii/D4D2zu4/J157Wudb8+xKcm04upnQ8VzD0ph/ZiTi2qzG1UfUxezdy6kiZkvUpi7T6YhiFXBHDXiC7/QcTZyHhD+U0S3K26spWKhyVWGKiewXi6m8oGY5UBzAUgp+1bgEHnq1LCJ38/Hh9K2SCqT0GHwTrkq2gJuRNMWCNXKRu7bVW1u6dpYTayUEnCixyh7JoyBdXgbB4WfqcCk+nRFEky4L5U+rG87AzGVpW1YDdZjEFN1EuMELzURt1hrvG7Er6yBgXWhx5njF76zCd02IMiv4fWcXPfec5yiv3dG181QizPW6FLcB/a+2lu9lyhftHtXyZhS2m4cDz8NH3UoBSFfwPszLMFyIBHvWDCwPU5aVLV5hxoYWeCsPHIYsL9suScuJJgGqcmn743wSnvOMJAZpqUpPY/HoNVKJOH3btdYM+oDUjY2nVM4fVdEHg+4co46qnE8WwnyPHOvUU9FgQ4nxmRIkn8IBWT6w2PQWrbL5EMvm/15LLq6ysOGzi4ZwGTkphrrrbYCjZUQozL8wLH3o6qDrcGmBqUgxfVTsLSxjiXgyeIWYl72CoQo3kdvT6+A3NYGmzv6RVsxOLIRS9PnxoBNzTFCJPzrLU9g8Hr182vFvNQihDqEa7lk0VeWhFNm40WOspgp/TJ5K+dycTvYa3tusHA+/qtsfXh+JA41BIa7fCLqlNpHt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [Low] selftests/rseq: unreset execs count in run_exec_case() weakens
  progress check
- [Low] selftests/rseq: victim deadline before wait_first_exec() in
  run_exec_case()
- [Low] selftests/rseq: unconditional increment of i in setter_main()
  skips mm updates
- [Low] selftests/rseq: missing mm_cid_teardown_test entry in .gitignore
--

commit cb8cf09e0b94fdd16e87974a38605eabab39bcdf
Author: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

selftests/rseq: Test affinity changes while a task replaces or drops its mm

This commit adds the mm_cid_teardown_test selftest to exercise concurrent
sched_setaffinity() calls against tasks replacing their mm via execve() or
dropping their mm on exit.

Link: https://lore.kernel.org/all/20261110183809.3308868-2-bestswngs@gmail.=
com/

> diff --git a/tools/testing/selftests/rseq/Makefile b/tools/testing/selfte=
sts/rseq/Makefile
> index d72502fc76527..2735704f516b8 100644
> --- a/tools/testing/selftests/rseq/Makefile
> +++ b/tools/testing/selftests/rseq/Makefile
> @@ -22,7 +22,7 @@ TEST_GEN_PROGS =3D basic_test basic_percpu_ops_test bas=
ic_percpu_ops_mm_cid_test \
>  		 param_test_benchmark param_test_mm_cid_benchmark \
>  		 mm_cid_execve_test mm_cid_transition_test \
>  		 mm_cid_bound_test mm_cid_exec_affinity_test \
> -		 mm_cid_window_test
> +		 mm_cid_window_test mm_cid_teardown_test

[Severity: Low]
Should mm_cid_teardown_test also be added to
tools/testing/selftests/rseq/.gitignore like the other binaries in
TEST_GEN_PROGS so in-tree builds do not leave an untracked binary behind?

> diff --git a/tools/testing/selftests/rseq/mm_cid_teardown_test.c b/tools/=
testing/selftests/rseq/mm_cid_teardown_test.c
> new file mode 100644
> index 0000000000000..f07a566901f83
> --- /dev/null
> +++ b/tools/testing/selftests/rseq/mm_cid_teardown_test.c
[ ... ]
> +static void setter_main(struct shared *sh, int index, pid_t pid, int cpu,
> +			int a, int b, long long deadline)
> +{
> +	unsigned long long changes =3D 0;
> +	cpu_set_t one, two;
> +	int i =3D 0;
> +
[ ... ]
> +	while (now_us() < deadline) {
> +		const cpu_set_t *mask =3D (i++ & 1) ? &one : &two;
> +		pid_t target =3D pid ? pid : RSEQ_READ_ONCE(sh->target);
> +
> +		if (!target)
> +			continue;
> +		if (!sched_setaffinity(target, sizeof(*mask), mask)) {
> +			changes++;
> +			continue;
> +		}

[Severity: Low]
Does incrementing i before checking target cause the first
sched_setaffinity() call on a newly forked child in run_exit_case() to be
a no-op half the time?

In run_exit_case(), the parent pins itself to CPU a (mask one), so each
new child inherits mask one.  Because setter_main() spins while sh->target
is 0 and does not reset i when sh->target changes, roughly half of new
targets first receive mask one, which returns early in
__set_cpus_allowed_ptr_locked() without updating the mm while still
incrementing changes.  Spinning while target is 0 also advances signed int
i without bound, which can overflow on longer runtimes passed via argv[1].

[ ... ]
> +static void run_exec_case(char *name, int runtime_s, struct shared *sh)
> +{
> +	unsigned long long execs =3D 0, changes =3D 0;
> +	int a =3D cpus[nr_cpus - 2], b =3D cpus[nr_cpus - 1];
> +	pid_t victim, setters[MAX_SETTERS];
> +	int fd, i, nset, status =3D 0;
> +	long long deadline;
> +	pid_t ret;
> +
> +	nset =3D nr_cpus - 2 < MAX_SETTERS ? nr_cpus - 2 : MAX_SETTERS;
> +	fd =3D eventfd(0, EFD_NONBLOCK);
> +	if (fd < 0)
> +		ksft_exit_fail_msg("eventfd: %s\n", strerror(errno));
> +	/* The process under test outlives those that change its affinity. */
> +	victim =3D start_exec_loop(name, a, fd,
> +				 now_us() + (runtime_s + 1) * 1000000LL);
> +	if (victim < 0)
> +		ksft_exit_fail_msg("fork: %s\n", strerror(errno));
> +	if (wait_first_exec(fd, &execs))
> +		ksft_exit_fail_msg("the process under test did not call execve\n");
> +
> +	deadline =3D now_us() + runtime_s * 1000000LL;
> +	for (i =3D 0; i < nset; i++) {
> +		setters[i] =3D fork();
> +		if (!setters[i])
> +			setter_main(sh, i, victim, cpus[i], a, b, deadline);
> +		if (setters[i] < 0)
> +			ksft_exit_fail_msg("fork: %s\n", strerror(errno));
> +	}
> +	for (i =3D 0; i < nset; i++) {
> +		if (wait_status(setters[i]))
> +			ksft_exit_fail_msg("a process that changes the affinity failed\n");
> +		changes +=3D sh->changes[i];
> +	}
> +	if (drain(fd, &execs))
> +		ksft_exit_fail_msg("read the count of the execve calls: %s\n",
> +				   strerror(errno));
> +
> +	/* The process under test must still be in its loop. */
> +	ret =3D waitpid(victim, &status, WNOHANG);
> +	if (ret < 0)
> +		ksft_exit_fail_msg("waitpid: %s\n", strerror(errno));
> +	if (ret) {
> +		ksft_print_msg("the process under test left its loop: 0x%x\n",
> +			       status);
> +		ksft_test_result_fail("%s\n", exec_case);

[Severity: Low]
Can victim reach its end timestamp before the parent reaches waitpid() if
wait_first_exec() and forking/reaping the setters take at least one
second?

victim's end timestamp is computed before wait_first_exec() (which allows
up to 5 seconds) as now_us() + (runtime_s + 1) seconds, whereas the
setters' deadline is computed after wait_first_exec() returns.  On a slow
or KASAN-enabled guest, victim can exit normally with CHILD_PASS in
exec_loop_main() before the setters are reaped, causing waitpid(...,
WNOHANG) here to report a failure.

> +		if (close(fd))
> +			ksft_exit_fail_msg("close: %s\n", strerror(errno));
> +		return;
> +	}
> +	if (kill(victim, SIGKILL))
> +		ksft_exit_fail_msg("kill: %s\n", strerror(errno));
> +	if (waitpid(victim, &status, 0) !=3D victim)
> +		ksft_exit_fail_msg("waitpid: %s\n", strerror(errno));
> +	if (close(fd))
> +		ksft_exit_fail_msg("close: %s\n", strerror(errno));
> +
> +	ksft_print_msg("%llu execve calls, %llu affinity changes\n",
> +		       execs, changes);
> +	ksft_test_result(execs && changes, "%s\n", exec_case);
> +}

[Severity: Low]
Does leaving execs unreset after wait_first_exec() make the execs check in
ksft_test_result() always true?

wait_first_exec() drains the initial eventfd write into execs before any
setter processes are forked, so execs is already at least 1 even if no
further execve() calls complete while the affinity changes are running.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1794932121.gi=
t.mathieu.desnoyers@efficios.com?part=3D16

