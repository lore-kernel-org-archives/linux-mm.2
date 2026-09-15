Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72D39C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 13:33:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 300D86B0092; Tue, 15 Sep 2026 09:33:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B2FF6B0093; Tue, 15 Sep 2026 09:33:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A0166B0095; Tue, 15 Sep 2026 09:33:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC7776B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:33:23 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 36A00803FF
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:33:23 +0000 (UTC)
X-FDA: 85216088286.22.AD4E14A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7DB5340016
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:33:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HANA76hn;
	spf=pass (imf12.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789479201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Da33iyX8RrUrhHPC36ssZZP7j4KMf25stiTxEiTRjDU=;
	b=DjN/AdElJLbaXs+1R7ys1yX9SxiqfRtUYpxWt5iPTXA2JuOxi9wLXs7OzsFldNEw14nb++
	Ud9aQcMicrUVySMOOAGehyzFtNH1DU0+O85Em8082IATqu1bg9dlRflox0nlWplmcXzRTy
	yKqHmkK37v7xQc1L6vMfkKQIzCGXvh8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HANA76hn;
	spf=pass (imf12.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789479201;
	b=OloSrhUo+UAwpRZs16dJVDY++ex4VB7yS0wpMyzSv8ySUleoKJHzj85jROaJiE3ugl9+N5
	2LnMSiATz4l0ufw9k695GLROU6C+t4MF9ul/Ff4uOWhVkhnNvSPzLIEfxvAYtNrc8HK8yj
	NwuE/pE/LDkDql/4ZopfDFs8Tt0IBRE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A1BE440DF4;
	Tue, 15 Sep 2026 13:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D391F000FF;
	Tue, 15 Sep 2026 13:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789479200;
	bh=Da33iyX8RrUrhHPC36ssZZP7j4KMf25stiTxEiTRjDU=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=HANA76hn+RCjD4WFujdVFLp+r7nx14r2j+1Nwvbt+QhrcjXcd0R6HRif0YgSlAb0e
	 FpDWKe0S3k8QV5X6Ycl51OskSSp93MiXwn4jRtFI3wwqmSuyQDTzOp7TDDh5gMq6r0
	 vDnAMqq7rK1qd9sKu54VGjSOOIJmxrfyNiV0GAV4hMHZLcFVCZA4wXothga+8gupSp
	 4VUJheuA3sj0cPQJBL+9ZxeSFYNr4M7E5VSIlG3vx4L91yHCkKR/T0qS/LyLRYLMOs
	 45xhbManJxeliLDDEfVEaRQ1AsO9NeYiAXxC6Ey44kCfaN1X6Y0WrRzS4udvCq8FyD
	 Mzhf2wHc8m1ZA==
Content-Type: multipart/mixed; boundary="===============7419760775756817736=="
MIME-Version: 1.0
Message-Id: <89f9e7223c18671a3a7025c9b3492c7e92539d00a289c2d83610918f8c53fe0f@mail.kernel.org>
In-Reply-To: <93289af4317b57caa4e393d73fe6c786b24a4c2a.1789475073.git.zhuhui@kylinos.cn>
References: <93289af4317b57caa4e393d73fe6c786b24a4c2a.1789475073.git.zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next v11 2/2] selftests/bpf: Add memcg async reclaim test
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev,roman.gushchin@linux.dev,inwardvessel@gmail.com,shakeel.butt@linux.dev,akpm@linux-foundation.org,andrii@kernel.org,eddyz87@gmail.com,ihor.solodrai@linux.dev,ast@kernel.org,daniel@iogearbox.net,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,shuah@kernel.org,baohua@kernel.org,geliang@kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,linux-mm@kvack.org,linux-kselftest@vger.kernel.org
Cc: zhuhui@kylinos.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Tue, 15 Sep 2026 13:33:19 +0000 (UTC)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7DB5340016
X-Stat-Signature: 7pfpkuqbwkkbowxkhdh31yer86e9wn4h
X-Rspam-User: 
X-HE-Tag: 1789479201-170832
X-HE-Meta: U2FsdGVkX18JmDoLIcsWzwi0XTnkQ8r8WUGNpu09c44Q164KtLv3xsuDyN2PjhCXr9zTxKotDJBSJxgjV4PpsH9SfH5J7Ogl5lVjiX8zzz+tNhfiJeNfgBg1L+dpbata0UJMqPPV7I6jKKRWOnMvwEgj4BRf7dh2ZH6QVnsU7DNeoxvvR6vZAE9vDrETwEb6Z4YjAeXe0ny5DXr97gKpTTsI1NxgTKwOv8urs540kkkCFCV4uO4oc4LDYdsQEd7UCdknz3/CcHz+8IzNMC58OjGHkAX+ZJotxLs2qLV5ZXxa1KeKiu6HmZwaT6HXGnIO5hQssXOkcGnSONTTRbgd9eQdLxlnr+wnKUOPa70g6LGuGf9dSZ5lgvof9gwja3N5eH5k4o/SAqSEdlcL3yP9zoOlQ29x0Dmwdaiuuck5eAmcQ0na6vbeFtruCz8fc6Ow4jCOjNAQj7hd3TdsWs+bzd3RKUlYENGkqypskLEL/2PW0hDQT/aI6WX2cIMB/a6A+j/ocuw9a0Hmmkjf1+M9eOtfNMWkDbKeSkZrB/OHB5BAAARpZTExKHxgLt2iqZWAzks+vD0wHWR/F25cnDdnki3FUsvNznVOgZTJzv1cZ3oll3rBsggkLhp74oZ3zBkdyGpyuuE2sLfKXuZVx+DL1XtA23AgZT6QJD9NNdxOinMk8/Kq0suIwkktSJ0oOoQFg61Z5BmXlrPk/yYNgHtJmOM02x0/pKTDos1jzK1vmYrPLkfxU9/BJmmic2Ukh+RGxqFq4/aXQjvO/k0bdUT6PqUtEO1DXMsiGhlBzQ443gpzWncBINEex7phs8YRkpZ64hnDE3kG9pdPkJFtNmwrFzOeSHdgYXWptQ4W1uF1gsxivo0cEtKKDveLzjqAxQrkePGJiVT3W3O/Qu0ERJ9MPYzc9SlWcPyeJdX5gIq+kGk55KVlKMI150Sp3aW4mjKLWfsYfgf+dXPv6xugYUi
 jnuzvNAJ
 /oxFVVKKd19i4grab7EPw/bwp2VJ4TrepvtImfhlrzi7JXgl6v44WE/fVdkBO4ej6oMbbeBa6Qp56L4flXRZn+k7aqKGZ4AWM6mSCHwwkqFQWgR8qfUa61inqwg0g6qXfWRQQtXjoo1kIygOfSj/8+xBNlsr97Tzks2Z/qSQsKEXx/OuQP9tOtaeLyE8Jt7lR1IdHkg5fnFMQM95fjxORDgl9qxQJ9TzZ4sjP3MtIwkN0iWIcEYUG1mqeFbbZH2IleEP1tBKrHdhEhu8DMwLRxLhHrslkGB2BjdMgGTCDc8TgyoB+NNEG+8qMlxaGw2+axV4oXnKK0AS0qaE8hzf9eygjcUBVG6rEK3rdGS01NI4mRTAxU077jV7vgSpgXMID/mDcsXivoXS7/VytrBiMy++L/SB8hu7LET9r92LRxUgHLiqRR/exG9+qZ5jh5gGPdqahmW5VrbCAxwTc6Padw7FX/1btf6P+eSZLoccEVFky8FBlGep/UYhuqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============7419760775756817736==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c b/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
> new file mode 100644
> index 000000000000..7c7d299b3b28
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
> @@ -0,0 +1,779 @@

[ ... ]

> +static int real_test_child_work(const char *cgroup_path, char *data_filename,
> +				char *time_filename, int read_times)
> +{
> +	struct timespec start, end;
> +	double elapsed;
> +	FILE *fp;
> +
> +	if (join_parent_cgroup(cgroup_path))
> +		return CHILD_EXIT_JOIN_CGROUP;
> +
> +	clock_gettime(CLOCK_MONOTONIC, &start);
> +
> +	if (write_file(data_filename))
> +		return CHILD_EXIT_WRITE_FILE;
> +
> +	if (read_file(data_filename, read_times))
> +		return CHILD_EXIT_READ_FILE;
> +
> +	clock_gettime(CLOCK_MONOTONIC, &end);
> +
> +	if (!time_filename)
> +		return CHILD_EXIT_OK;
> +
> +	elapsed = (end.tv_sec - start.tv_sec) +
> +		  (end.tv_nsec - start.tv_nsec) / 1000000000.0;
> +
> +	fp = fopen(time_filename, "w");
> +	if (!fp)
> +		return CHILD_EXIT_TIME_FILE;
> +	fprintf(fp, "%.6f", elapsed);
> +	fclose(fp);
> +
> +	return CHILD_EXIT_OK;
> +}
> +
> +static int get_time(char *time_filename, double *time)
> +{
> +	int ret = -1;
> +	FILE *fp;
> +	char buf[64];
> +
> +	fp = fopen(time_filename, "r");
> +	if (!ASSERT_OK_PTR(fp, "fopen"))
> +		goto out;
> +
> +	if (!ASSERT_OK_PTR(fgets(buf, sizeof(buf), fp), "fgets"))
> +		goto cleanup;

Is ASSERT_OK_PTR valid for checking fgets() return values? fgets()
returns NULL at end-of-file without setting errno, so ASSERT_OK_PTR (which
expands to libbpf_get_error()) would read from the ambient errno rather
than detecting the EOF. If the timing file is empty, fgets() returns NULL
with errno still zero from the previous successful fopen(), causing
ASSERT_OK_PTR to pass silently and execution to fall through to
sscanf(buf, "%lf", time) with buf uninitialized.

The empty-file case is reachable: real_test_child_work() does not check
the result of fprintf()/fclose() on the timing file, so a child whose
write failed (ENOSPC on /tmp after writing two 32 MB workload files) still
exits CHILD_EXIT_OK, and run_high_low_workload() then calls get_time() on
a zero-length file.

> +
> +	if (sscanf(buf, "%lf", time) != 1) {
> +		PRINT_FAIL("sscanf %s", buf);
> +		goto cleanup;
> +	}

[ ... ]

> +/*
> + * test_progs hijacks stdout and only prints the captured log when the
> + * test fails, so benchmark numbers go straight to the real stdout to
> + * keep them from drowning in ASSERT output.
> + */
> +static void bench_printf(const char *fmt, ...)
> +{
> +	va_list ap;
> +
> +	va_start(ap, fmt);
> +	vfprintf(env.stdout_saved ?: stdout, fmt, ap);
> +	va_end(ap);
> +}

A subsystem pattern flags this as potentially concerning: bench_printf()
writes benchmark text straight to env.stdout_saved, bypassing the test
framework's stdout hijacking. Outside test_progs.c itself this is the only
writer of env.stdout_saved in the whole selftests/bpf tree - every other
test writes through the hijacked stdout so the framework owns when and
whether the text appears.

The effect is free-form lines interleaved directly into the stream from
which runners and CI parse the per-test pass/fail records, on a path
enabled only by an environment variable, so the same binary produces two
different output shapes. The benchmark timings emitted are informational
(not pass/fail verdicts), the path is gated behind
TEST_MEMCG_ASYNC_RECLAIM_BENCH=1, and prog_tests/ files run under
test_progs rather than kselftest.h. Would dumping benchmark numbers via
the framework's normal stdout keep the output under framework control?

[ ... ]

> +void test_memcg_async_reclaim(void)
> +{
> +	u64 high_cgroup_id, low_cgroup_id;
> +	double high_time = 0.0, low_time = 0.0;
> +	double base_high_time = 0.0, base_low_time = 0.0;
> +	struct memcg_async_reclaim *skel = NULL;
> +	int err, bench;
> +
> +	bench = !!getenv("TEST_MEMCG_ASYNC_RECLAIM_BENCH");
> +
> +	err = setup_high_low_cgroups(&high_cgroup_id, &low_cgroup_id);
> +	if (!ASSERT_OK(err, "setup_high_low_cgroups reclaim"))
> +		return;
> +
> +	/*
> +	 * Optional baseline for the benchmark numbers below: run the
> +	 * same workload once without the BPF program, so the log can
> +	 * report how much async reclaim improved the pressured cgroup.
> +	 */
> +	if (bench) {
> +		err = run_high_low_workload(&base_high_time, &base_low_time,
> +					    READ_TIMES);
> +		if (!ASSERT_OK(err, "run_high_low_workload baseline"))
> +			goto out;
> +	}
> +
> +	err = setup_bpf(high_cgroup_id, low_cgroup_id, &skel);
> +	if (!ASSERT_OK(err, "setup_bpf"))
> +		goto out;
> +
> +	err = run_high_low_workload(&high_time, &low_time, READ_TIMES);
> +	if (!ASSERT_OK(err, "run_high_low_workload reclaim"))
> +		goto out;
> +
> +	/*
> +	 * The timing comparison below alone cannot distinguish a working
> +	 * reclaim from a no-op one, so require that the BPF program
> +	 * actually reclaimed memory from the low cgroup.
> +	 */
> +	if (!ASSERT_GT(skel->bss->reclaim_calls, 0, "reclaim_calls"))
> +		goto out;
> +	if (!ASSERT_GT(skel->bss->reclaimed_bytes, 0, "reclaimed_bytes"))
> +		goto out;
> +
> +	/*
> +	 * The timing comparison is a benchmark and too flaky to fail CI
> +	 * runs, so it only logs the numbers; the counters above already
> +	 * proved that the BPF program reclaimed memory.
> +	 */
> +	if (bench && base_high_time > 0.0) {
> +		double speedup = base_high_time / high_time;
> +
> +		bench_printf("memcg_async_reclaim: baseline high=%f low=%f, "
> +			     "reclaim high=%f low=%f, speedup=%.2fx\n",
> +			     base_high_time, base_low_time,
> +			     high_time, low_time, speedup);
> +	}
> +	else if (high_time >= low_time)
> +		printf("memcg_async_reclaim: high cgroup not improved: high=%f low=%f\n",
> +		       high_time, low_time);

Can this printf() output ever be read? test_progs redirects stdout and
stderr to an in-process memstream, and dump_test_log() only prints that
buffer when the test fails. Both printf() calls added by the patch are
emitted on paths where the test then passes, so their output is discarded.

The same file documents this behaviour and works around it for the
benchmark numbers through bench_printf() and env.stdout_saved. Should
these two informational printf() calls go through bench_printf() as well,
or be dropped?

[ ... ]

> +void test_memcg_async_reclaim_dying(void)
> +{
> +	u64 trigger_cgroup_id, target_cgroup_id;
> +	u64 calls_before, bytes_before;
> +	char data_file[PATH_MAX] = "";
> +	struct reclaim_events_seen seen = {};
> +	struct memcg_async_reclaim *skel = NULL;
> +	struct ring_buffer *rb = NULL;
> +	pid_t reader_pid = -1;
> +	int err, fd, i;
> +
> +	err = setup_dying_cgroups(&trigger_cgroup_id, &target_cgroup_id);
> +	if (!ASSERT_OK(err, "setup_dying_cgroups"))
> +		return;
> +
> +	err = setup_bpf(trigger_cgroup_id, target_cgroup_id, &skel);
> +	if (!ASSERT_OK(err, "setup_bpf"))
> +		goto out;
> +
> +	rb = ring_buffer__new(bpf_map__fd(skel->maps.reclaim_events),
> +			      on_reclaim_event, &seen, NULL);
> +	if (!ASSERT_OK_PTR(rb, "ring_buffer__new"))
> +		goto out;
> +
> +	snprintf(data_file, sizeof(data_file),
> +		 "%s/memcg_async_dying_XXXXXX", workload_files_dir());
> +	fd = mkstemp(data_file);
> +	if (!ASSERT_GE(fd, 0, "mkstemp"))
> +		goto out;
> +	close(fd);
> +
> +	reader_pid = spawn_keepalive_reader(data_file);
> +	if (!ASSERT_GT(reader_pid, 0, "fork keepalive reader"))
> +		goto out;

Could the keepalive reader child's failure modes be diagnosed?
spawn_keepalive_reader() reports its failures through distinct exit codes
(CHILD_EXIT_JOIN_CGROUP, CHILD_EXIT_WRITE_FILE, CHILD_EXIT_READ_FILE),
but the caller only checks that fork() succeeded. At cleanup the status is
discarded:

	kill(reader_pid, SIGKILL);
	(void)waitpid(reader_pid, NULL, 0);

If the child dies immediately - for example join_parent_cgroup() fails, or
write_file() cannot create the 32 MB file - the parent still spends 50 *
100ms in the first poll loop and then fails with ASSERT_GT(seen.called, 0,
"reclaim events"), pointing at the kernel rather than at the child.

The child's own diagnostics do not survive either: test_progs sets stdout
and stderr to a per-process memstream, so log_err() output from
join_parent_cgroup() and the fprintf() in read_file() land in the forked
child's private copy of that buffer and are lost at _exit().

The file already has the machinery to handle this - child_exit_str() and
the WIFEXITED/WEXITSTATUS handling in run_high_low_workload(). Would a
waitpid(reader_pid, &status, WNOHANG) probe before or after the poll loop,
reported through child_exit_str(), make this diagnosable?

> +
> +	/* Wait for reclaim rounds to reach the live target cgroup. */
> +	for (i = 0; i < EVENT_POLL_ROUNDS && !seen.called; i++) {
> +		err = ring_buffer__poll(rb, EVENT_POLL_TIMEOUT_MS);
> +		if (!ASSERT_GE(err, 0, "ring_buffer__poll"))
> +			goto out;
> +	}
> +	if (!ASSERT_GT(seen.called, 0, "reclaim events"))
> +		goto out;
> +
> +	remove_cgroup(CG_DYING_TARGET_DIR);
> +
> +	usleep(DYING_SETTLE_US);
> +	seen = (struct reclaim_events_seen){};
> +
> +	calls_before = skel->bss->reclaim_calls;
> +	bytes_before = skel->bss->reclaimed_bytes;
> +
> +	/* Wait for a reclaim round to report the removed target. */
> +	for (i = 0; i < EVENT_POLL_ROUNDS &&
> +		    !seen.skipped_dying && !seen.target_gone; i++) {
> +		err = ring_buffer__poll(rb, EVENT_POLL_TIMEOUT_MS);
> +		if (!ASSERT_GE(err, 0, "ring_buffer__poll"))
> +			goto out;
> +	}
> +
> +	if (!seen.skipped_dying && !seen.target_gone) {
> +		PRINT_FAIL("no reclaim round hit the removed cgroup within "
> +			   "the poll window");
> +		goto out;
> +	}
> +
> +	if (!ASSERT_EQ(skel->bss->reclaim_calls, calls_before, "reclaim_calls"))
> +		goto out;
> +	if (!ASSERT_EQ(skel->bss->reclaimed_bytes, bytes_before, "reclaimed_bytes"))
> +		goto out;

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/34970614671
--===============7419760775756817736==--

