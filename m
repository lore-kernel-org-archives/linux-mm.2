Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42BE5606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 21:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H1Tybpwe
Received: by kanga.kvack.org (Postfix)
	id 431F26B05B1; Sat, 31 Oct 2026 17:39:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 407266B05B2; Sat, 31 Oct 2026 17:39:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F6556B05B3; Sat, 31 Oct 2026 17:39:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 007446B05B1
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 17:39:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 66A531C430C
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 21:39:30 +0000 (UTC)
X-FDA: 85384238100.12.8F35422
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id B04D340006
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 21:39:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H1Tybpwe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793482768;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kp18/mHsiF5qBN7v25qcp961nWpYoHUy85dDrDdwpTQ=;
	b=f71Tv6unF567Cu5krb3sOnL8R7uNl2XsiqSUcLoT3iFIkkRhfsfAPGfwj04GMFCWYyYJfd
	gg50ZRhFD4xqwNu20W2fxt+yusi3o4MhoCPxg01RCoGbht8JmzC/bm1OWhk4YwTgWeTlmG
	/0qsRhOsY08ehJEmFpUkjIzmdRPvQ4o=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H1Tybpwe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793482768;
	b=UNpdgtQUjzT8flZh0HTiIv8CrN2kzUiTNFp6s+SGMDdUUedTk1Shj1TWjbDo7HpXG9IBOv
	tetFXv//e05dDALNoo1vFoNWTWgWzKHVW6egADKIy2La8NRaGbfxtOHb9kkAlyGzUTzikP
	frqxJ3g4BElc1nBF/+V2n3KLsI+odsM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8EC6D43616;
	Sat, 31 Oct 2026 21:39:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D6E1F00919;
	Sat, 31 Oct 2026 21:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793482767;
	bh=Kp18/mHsiF5qBN7v25qcp961nWpYoHUy85dDrDdwpTQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H1TybpwewN7DiAlNwiCXT+4lYJb3GFyi5bHe06fVx5lFapn4o/Sb/hTGEcPll3RTz
	 UYi/rxoAI/4EJoriBs+7OY+CcqhjnyqSKSMUHDOdHUM1qmrX9FkLCKrYRH1jKScn47
	 lHY2QE7dAfYgdf2jpXxzlOdvKXz50WzYnYtsMjkOcUJNDWz/XgwClRlSKPKMkda3m1
	 ojl+6QwQttpz1XV+X9aoTziYFOwZb52rEggbZCJFJY4JOy+mUIgSAT/91BXhe7Xu3M
	 qGhH3+/YN+MBnJqQTjmH4UcpfY3tY1bSBZ4QNvankXZu5IukZQVxOnDGoXZvruPYOf
	 AVlS8Bn9mKtyg==
Message-ID: <sashiko-outbox-192181@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 4/6] sched: Extend task command name with
 TASK_COMM_EXT_LEN
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QW5kcsOpIEFsbWVpZGE=?= <andrealmeid@igalia.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Juri Lelli" <juri.lelli@redhat.com>, "Vincent
 Guittot" <vincent.guittot@linaro.org>, "Steven Rostedt" <rostedt@goodmis.org>, "Christian
 Brauner" <brauner@kernel.org>, "Kees Cook" <kees@kernel.org>, "Shuah Khan" <shuah@kernel.org>, willy@infradead.org, mathieu.desnoyers@efficios.com, "David
 Laight" <david.laight.linux@gmail.com>, "Linus Torvalds" <torvalds@linux-foundation.org>, akpm@linux-foundation.org, "Yafang
 Shao" <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com, arnaldo.melo@gmail.com, "Petr
 Mladek" <pmladek@suse.com>
Cc: kernel-dev@igalia.com, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org
In-Reply-To: <20261030-tonyk-long_name-v8-4-c9b030332254@igalia.com>
References: <20261030-tonyk-long_name-v8-0-c9b030332254@igalia.com>
 <20261030-tonyk-long_name-v8-4-c9b030332254@igalia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 31 Oct 2026 21:39:26 +0000
X-Rspamd-Queue-Id: B04D340006
X-Stat-Signature: 6iaaymdc9xmqcee1cp6z3hzsg549pjf3
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793482768-222974
X-HE-Meta: U2FsdGVkX1+DcaXCzMVZw6bwVqpbp80W0nxtFQRV+piezbEdloeBgBDIQL9YCDkKXOlJkRdysaG7DAW7mliO+ulHHluqbbtCRhIq/7AdwmVDFNVyg6PsYPNZWtnBl8gIErzVIgUcDssqCsfQaTTXyWNfHVIvfcgjNZjLMY6tNhZwNwDJdQyGZG6sx3TuUTkHtC+bj0gtQdjVbrRFidsM6oHxPFabFlgpZ+c0+Pii0B2upZaW+sU/O77fJEfaBE+hTmex99In4NhpTaxrzhClfJNjRgzK3YNmnMkkbqFQY/J+EG9U4F43erv9jT+eyweJrzc/TZzZzFHZEeirH/0tcCyjwvxnkzHcGpW1HlDcphoVBMc48JF626GIzXII9uocUX/1rHfJTFbohbPeY+rCdvJ4yKfLVhVDq4vgEuFHzWYfh61iF/6K16DMzCPC7NYUGsGYdwMBwv+3XYUV1iPfsqzNQnLqVdJXDVHqy+God8vDDwDw44ECJot8g3yZ3rskJCTV5ipnqlG8EfqY+1u0ex4Lnr7P1r4PgDsDI192lddtt/T8cquMgtfELdTe9JdTig6fVgGaALF/T33aniUg+dQrKBbhNgfvzwOvFW41QE3qDMEionrxoOlGK6S2p+Dpgw1yCwyQxpg8yVAGNX9znWaReprNtDXqE93bD54DBoUVEanK9FHVT+s9J3EQEHTDAXYMz/Vlp8zRvKlg59ssTo1q2C8t6C9bR+sdrG7Iels8vc1nlGl/hKzsrid9/4jDfxJ+ndO/sNNlDVXNelrMITk4B9Ca47txpdRwpwYnmbv7PNZvH9uDNdeUeZkGysP5fMuqJQpLTfxnh+T1p8e9Aq0rCR5W25BH6TAk7KcJfOTAqgNyBPaXaeeQ03+3VmxHUEhUTjoUpFTh7Az0h8hcpZmbYBrnWjviutnyJdm0p+zpwjeYJVPNvkj7hlTyv/LCojSoZjKbAeNzNYnL+Qe
 lw5pQQIr
 9tXv3vS4UuPHsZC6eOi6Tu0MYfhwan7is+0Uh8Yp8HbTxxq5H0mUwMLWo7XM75NR1ypvybedGrUIE93lgzbmIWsbynIkK0L86kJQElK7mm+yrWvVjCn78ESMbaZAqShYakod4Qca/lfe9heFEIca/5Tfys0ztY6Z5VjB+CfFLBkNJDANQaNqzvVhatfsEaVsIDAxYz9Pb1iAyulYN6l/3pjiEKvv1+zElsT2/6/dojwogXlAhZL+bzbAgx00nRNBi6SC39G7ThSgWT41rlX46huexqR7yCSnK/MqbFi1I/smi79BGD0qbQSpgrM9UFTWr/SL2NWk5B8zEXdV/UR/jcMoIRjiXmeVSU9A/L8XfrT5Wd6G5QYH3tdYA4cX4UE1pnCNsITMCNehxXl+AmD95/lzdK1LEH1+dinZfCNmX8ITHSZ0MtrKXiOoGqpBFSTxtnkFLKavGejGXwlnuvRXhitRYiY9SPk1ZrX5j6bt5B5XsW5gx/XE/7NI4AiMk4olFNIeJQvW1uCYLn7XdYkRADHh0g6rpFZT3WvLKyWmScJLhm/yYUU96lfeNKGsRQ9zQUw0W75ROz45n42erEkKLp8cN5PeeIM8sts/LHHeEH+kdSVJcslaKpN9+BJhs2EVmzfW7kBgP0tL+UttJBQwGIDshxHAXPZM41ynYY70JJoIyGcuqgGspi0jCQXyE6ANfabeRJ23MfdqQ9TlmUwb/yptINZbh6DyGX6xiTC4xqMOwXX/m4DzlcWSF/0TQ2WgTPJZdzEeEcl/y5/o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:
- [Medium] drm/tests: drm_test_framebuffer_init() fails due to extended cur=
rent->comm
- [Medium] drm/amdgpu: amdgpu_ras_check_bad_page_unlock() fails for >=3D16-=
char comm
- [Medium] selftests/bpf: verifier negative tests fail with 64-byte task_st=
ruct::comm
- [Medium] drm/nouveau: format truncation in nouveau_channel_ctor() and nou=
veau_drm_open()
- [Medium] tracing: broken comm event filtering in filter_pred_comm() for l=
ong names
- [Medium] lib/string_kunit: string_copy_task_comm() uses TASK_COMM_LEN for=
 TASK_MAX_LEN
- [Low] ipv6: ndisc_warn_deprecated_sysctl() fails to deduplicate long comm=
 names
--

commit de6fdb5089442d5e041310e67345e77eafd17cb9
Author: Andr=C3=A9 Almeida <andrealmeid@igalia.com>

sched: Extend task command name with TASK_COMM_EXT_LEN

This commit introduces TASK_COMM_EXT_LEN (64 bytes) and expands
task_struct::comm to allow longer command names for userspace and kernel
threads while capping existing userspace interfaces to TASK_COMM_LEN.

[ ... ]

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index db529a93525d3..5e02bce749b82 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -323,6 +323,7 @@ struct user_event_mm;
>   */
>  enum {
>  	TASK_COMM_LEN =3D 16,
> +	TASK_COMM_EXT_LEN =3D 64,
>  };
> =20
>  extern void sched_tick(void);
> @@ -1192,7 +1193,7 @@ struct task_struct {
>  	 * - set it with set_task_comm() to ensure it is always
>  	 *   NUL-terminated and zero-padded
>  	 */
> -	char				comm[TASK_COMM_LEN];
> +	char				comm[TASK_COMM_EXT_LEN];

[Severity: Medium]
Does enlarging task_struct::comm to TASK_COMM_EXT_LEN cause the
drm_test_framebuffer_init() KUnit test to fail?

KUnit runs each test case inside a kthread created by kunit_try_catch_run()
in lib/kunit/try-catch.c:

	task_struct =3D kthread_create(kunit_generic_run_threadfn_adapter,
				     try_catch, "kunit_try_catch_thread");

During kthread creation, copy_process() in kernel/fork.c copies args->name
into p->comm:

	if (args->name)
		strscpy_pad(p->comm, args->name, sizeof(p->comm));

With p->comm enlarged to 64 bytes, current->comm now holds the full
22-character "kunit_try_catch_thread" instead of being truncated to
"kunit_try_catch".

However, struct drm_framebuffer still defines comm as char comm[TASK_COMM_L=
EN],
so drm_framebuffer_init() in drivers/gpu/drm/drm_framebuffer.c truncates it
to 15 characters:

	fb->funcs =3D funcs;
	strscpy(fb->comm, current->comm);

When drm_test_framebuffer_init() in
drivers/gpu/drm/tests/drm_framebuffer_test.c checks:

	/* The fb->comm must be set to the current running process */
	KUNIT_EXPECT_STREQ(test, fb1.comm, current->comm);

won't this compare "kunit_try_catch" against "kunit_try_catch_thread" and
fail on every run?

[Severity: Medium]
Can this also cause amdgpu_ras_check_bad_page_unlock() to reject the owning
process with -EACCES when its command name is 16 or more characters long?

In drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c, amdgpu_vram_mgr_new() saves
the allocating task's comm into vres->task.comm (which is sized to
TASK_COMM_LEN):

	vres->task.pid =3D task_pid_nr(current);
	strscpy_pad(vres->task.comm, current->comm);

This truncates names of 16 or more characters to 15 characters and places a
NUL byte at index 15.

Later, amdgpu_ras_check_bad_page_unlock() in
drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c verifies the caller against the
stored task info:

	if ((flags =3D=3D BYPASS_ALLOCATED_ADDRESS) &&
	    ((blk_info.task.pid !=3D task_pid_nr(current)) ||
		strncmp(blk_info.task.comm, current->comm, TASK_COMM_LEN))) {
		ret =3D -EACCES;
		goto out;
	}

When current->comm has 16 or more characters (for example from execve() via
begin_new_exec() -> __set_task_comm()), current->comm[15] is non-NUL while
blk_info.task.comm[15] is NUL, causing strncmp(..., TASK_COMM_LEN) to misma=
tch
at index 15. Should that comparison use TASK_COMM_LEN - 1?

[Severity: Medium]
Will changing task_struct::comm to 64 bytes in vmlinux BTF break the BPF
verifier negative selftests that test out-of-bounds accesses against
task->comm?

In tools/testing/selftests/bpf/progs/task_kfunc_failure.c, task_access_comm1
and task_access_comm2 expect a 17-byte access to exceed task->comm:

	SEC("tp_btf/task_newtask")
	__failure __msg("access beyond the end of member comm")
	int BPF_PROG(task_access_comm1, struct task_struct *task, u64 clone_flags)
	{
		bpf_strncmp(task->comm, 17, "foo");
		return 0;
	}

	SEC("tp_btf/task_newtask")
	__failure __msg("access beyond the end of member comm")
	int BPF_PROG(task_access_comm2, struct task_struct *task, u64 clone_flags)
	{
		bpf_strncmp(task->comm + 1, 16, "foo");
		return 0;
	}

And in tools/testing/selftests/bpf/progs/verifier_btf_array_access.c,
kernel_btf_array_out_of_bounds expects offsets in [0, 31] to run past the
end of task->comm:

	/* task->comm[i], i in [0, 31]: max offset runs past comm. */
	SEC("syscall")
	__failure
	__msg("invalid variable offset access into struct task_struct")
	int kernel_btf_array_out_of_bounds(void *ctx)

With task_struct::comm enlarged to 64 bytes, the verifier accepts all three
programs instead of rejecting them. Should these selftests be updated to ma=
tch
TASK_COMM_EXT_LEN?

[Severity: Medium]
Could enlarging current->comm to 64 bytes trigger -Wformat-truncation build
warnings under W=3D1 and truncate the PID suffix in Nouveau?

Similar to the i915 places updated in this patch, nouveau_channel_ctor() in
drivers/gpu/drm/nouveau/nouveau_chan.c formats current->comm and the PID in=
to
a 32-byte buffer:

	DEFINE_RAW_FLEX(struct nvif_chan_v0, args, name, TASK_COMM_LEN + 16);
	...
	snprintf(args->name, __member_size(args->name), "%s[%d]",
		 current->comm, task_pid_nr(current));

And nouveau_drm_open() in drivers/gpu/drm/nouveau/nouveau_drm.c does the sa=
me
into a 32-byte stack buffer:

	char name[32];
	...
	rcu_read_lock();
	snprintf(name, sizeof(name), "%s[%d]",
		 current->comm, pid_nr(rcu_dereference(fpriv->pid)));
	rcu_read_unlock();

Should these two callers also be updated so W=3D1 builds do not fail with
-Wformat-truncation and long command names do not drop the "[%d]" suffix?

[Severity: Medium]
How does ftrace event filtering on comm behave when current->comm is longer
than 15 characters?

In kernel/trace/trace_events_filter.c, filter_pred_comm() passes TASK_COMM_=
LEN
(16) as the buffer length of current->comm:

	static int filter_pred_comm(struct filter_pred *pred, void *event)
	{
		int cmp;

		cmp =3D pred->regex->match(current->comm, pred->regex,
					TASK_COMM_LEN);
		return cmp ^ pred->not;
	}

When a task has a command name of 16 or more characters in current->comm,
current->comm[15] is non-NUL. In regex_match_full():

	if (len < r->len)
		return 0;

	return strncmp(str, r->pattern, len) =3D=3D 0;

filtering by the 15-character truncated name (r->len =3D=3D 15) compares 16=
 bytes
and fails because str[15] is non-NUL while r->pattern[15] is NUL, whereas
filtering by a full name longer than 16 characters is rejected by len < r->=
len.
Likewise, regex_match_end() computes strlen =3D len - 1 (15) and checks for=
 the
suffix at offset 15 - r->len rather than the end of current->comm:

	static int regex_match_end(char *str, struct regex *r, int len)
	{
		int strlen =3D len - 1;

		if (strlen >=3D r->len &&
		    memcmp(str + strlen - r->len, r->pattern, r->len) =3D=3D 0)

Should filter_pred_comm() and the regex match helpers be updated to handle
TASK_COMM_EXT_LEN?

[Severity: Low]
In net/ipv6/ndisc.c, does ndisc_warn_deprecated_sysctl() fail to deduplicate
warnings when current->comm is 16 or more characters long?

	static char warncomm[TASK_COMM_LEN];
	static int warned;
	if (strcmp(warncomm, current->comm) && warned < 5) {
		strscpy(warncomm, current->comm);

Because warncomm is sized to TASK_COMM_LEN, strscpy() truncates current->co=
mm
to 15 characters, so subsequent calls from the same process (such as
systemd-networkd) will see strcmp(warncomm, current->comm) !=3D 0 and repeat
the warning up to 5 times. Should warncomm use TASK_COMM_EXT_LEN (or compare
with strncmp(warncomm, current->comm, TASK_COMM_LEN - 1))?

> =20
>  	struct nameidata		*nameidata;
> =20
> @@ -2048,7 +2049,7 @@ extern void __set_task_comm(struct task_struct *tsk=
, const char *from, bool exec
>  static __always_inline void copy_task_comm(char *dst, struct task_struct=
 *tsk, size_t len)
>  {
>  	const char *_src =3D tsk->comm;
> -	size_t _len =3D min(len, TASK_COMM_LEN);
> +	size_t _len =3D min(len, TASK_COMM_EXT_LEN);
> =20
>  	if (!_len)
>  		return;

[Severity: Medium]
In lib/tests/string_kunit.c, should string_copy_task_comm() also be updated
from TASK_COMM_LEN to TASK_COMM_EXT_LEN?

Currently, string_copy_task_comm() defines:

	#define TASK_MAX_LEN TASK_COMM_LEN
	#define SMALLER_LEN (TASK_NAME_LEN - 3)
	#define BIGGER_LEN (TASK_MAX_LEN + 3)

	static void string_copy_task_comm(struct kunit *test)
	{
		...
		/* copy to a bigger dst buffer */
		copy_task_comm(bigger_buf, tsk, sizeof(bigger_buf));
		KUNIT_ASSERT_TRUE(test, !strncmp(str, bigger_buf, TASK_NAME_LEN));
		for (i =3D TASK_NAME_LEN; i < BIGGER_LEN; i++)
			KUNIT_ASSERT_EQ(test, bigger_buf[i], '\0');

Because TASK_MAX_LEN is still TASK_COMM_LEN (16), BIGGER_LEN is 19, which is
smaller than sizeof(tsk->comm) (64), so the test no longer exercises copying
into a destination buffer larger than tsk->comm. Additionally, if TASK_MAX_=
LEN
is updated to TASK_COMM_EXT_LEN, copy_task_comm() only writes _len (64) byt=
es
and does not zero-pad dst[_len .. len - 1], which would leave the trailing
bytes of bigger_buf uninitialized when the test asserts they are '\0'.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030-tonyk-long=
_name-v8-0-c9b030332254@igalia.com?part=3D4

