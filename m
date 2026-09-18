Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0147C88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 08:07:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 034BF6B0093; Fri, 18 Sep 2026 04:07:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00C896B0098; Fri, 18 Sep 2026 04:07:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3E896B0099; Fri, 18 Sep 2026 04:07:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B360F6B0093
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:07:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 20941A5F81
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:07:22 +0000 (UTC)
X-FDA: 85226153124.29.247C631
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7DCFBC0005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:07:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EzLAjqFr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789718840;
	b=eOHIQ+ZqDdlbEj2Yax82y1hn+cXW62vwZ32bsDHhnkf7tFyoFWHXH3bb9O5R15v4wSIWnv
	PAhEOTt9E9kIf2gqz+SxrXqEk+oLNO3XSBNP9Vx206w3ewwI5BOd4AMewxDsX2LAcFmTpP
	iLO0qYTDH3mkbXbDpVg8GYX/qpoTu98=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EzLAjqFr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789718840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CN62GKBYW4Gh6bEa4wTsqXz2IMYSV3OeaKs617jAh5o=;
	b=AAJiCbpskHNcOaPuedActN6ZPdGWTF3IYWUY6jc3jTEsVlJgSx8PZGsViBt2rNlhsedXlW
	v8sUyR2vj57Hv70or3Urur2AFjNMvKSw04qKzBl9E3NBEzllw5yVYz+d4hEmTaEn9a5bjp
	45HkxVtlAM3RhUCMBH5u6cR/s2ePoak=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 001D540264;
	Fri, 18 Sep 2026 08:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C4A1F000FF;
	Fri, 18 Sep 2026 08:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789718838;
	bh=CN62GKBYW4Gh6bEa4wTsqXz2IMYSV3OeaKs617jAh5o=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=EzLAjqFrG/HO3b+fLf1D9Lt53vKdK0OdUUVjk5YI3Lwzhadh+82qXHwYpuhwmQUCg
	 eOXEM2M6FedgnfOSuonmYdMRy/5J7ClJ9gSZ2Lp+u74Me/uicrhxCgdBsWv9BwPwxu
	 +YUYFNW3gjP3X5DMztp0Vuw3IIcTjj+viPvQKZz/HI1g2XQffgnEtZ08EbcVYBroRM
	 uTDk0CsvRTpR+4zqn1AayHLHNSCjYPp3t9HH0kLoFBC578e7ZNcTnxZ/O8qqJxv3wT
	 dTW1t1os0gil5fq9pnx5Q7gHqKbtNbp1WhYcclPslLeedj6HMicDWAf2A2p7UXOG57
	 PMonpcJTaZ/Uw==
Content-Type: multipart/mixed; boundary="===============2924590592151832210=="
MIME-Version: 1.0
Message-Id: <a96829b3ce33af67ccab9e1307714102daf95118dea89d95796ed440562acd12@mail.kernel.org>
In-Reply-To: <44f7fcfafd5f33072dd2b9abc31aa9bf5eacd9bb.1789714023.git.zhuhui@kylinos.cn>
References: <44f7fcfafd5f33072dd2b9abc31aa9bf5eacd9bb.1789714023.git.zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next v12 2/2] selftests/bpf: Add memcg async reclaim test
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev,roman.gushchin@linux.dev,inwardvessel@gmail.com,shakeel.butt@linux.dev,akpm@linux-foundation.org,andrii@kernel.org,eddyz87@gmail.com,ihor.solodrai@linux.dev,ast@kernel.org,daniel@iogearbox.net,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,shuah@kernel.org,david@kernel.org,baohua@kernel.org,geliang@kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,linux-mm@kvack.org,linux-kselftest@vger.kernel.org
Cc: zhuhui@kylinos.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Fri, 18 Sep 2026 08:07:17 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7DCFBC0005
X-Stat-Signature: cxnc7ajmtcg93313szcrcydxm9erejk7
X-HE-Tag: 1789718840-385246
X-HE-Meta: U2FsdGVkX19/NJKT+Zv1/C8ibEGSj++Q/wJ2vwGwI45XPBYjLM1pDaPRSTbhB0U/MuU60XIaH7RUiUKpnXMAIIK2v/QQBzu5RV4die5mJ4eKiyWPFdb4u94UtwNoV9oEyIGlxJi/xylO6np/1g6LqD75fYTWepYqGRfMX9WKjsg/Nckzdh6dHrZSeSQwEiMvP6l0+rwj3OyxzfXfoRI0QKeNohdzsWnf4ovQ4KdxudWIYwq32rJ2HVonjPaab48Q/1uqzK2sf/3f+1UJqs4MOeSLfPfHnfsjvN40OlBeMbi2Tj89HN7rY2Sb5SqxAC6AEpw7wN8vwto4jWadkocBstdsYe/9GIn6daPIyx1SGUI+7OJmHDRsdTEg5K5wE7nHY24a5ZnEUIprcH9FeAVe7N1f/hcT4M5LfF6a4p1UC1JsNzWfPo7fmgPfmSSSVPfAHDij7aOAmO21opyCxEmpuckNQinmdhZbxc0TMcs/p2IEO0kemz7M1viPD4hs3IyfIQWr9pHywwlpJ0uToWj7ZAyff8rd6UNw9g/L37y6XxZd+9fAaVF3Cyk3HYWMToGV7HQINEgFlDRJ6UESUwg7FXxzc5G/Y40eeRCvgyeyUWyUH9bSR9YixuObL+dFUGL8QpokAYJ2Kt9mbHY6BNoZ6e1KH/PxpJHQkHkLXfv9/wfSm+wTA2VUWp0cZyOxBKwv8kc+vl8L1SZTX4MTk0e+2FfhH0DbpkE1tw8fqdHA3t8NJai9CE2Pjto4uaOnaQM76ybYEbrHnKe91SOEkrfdPokDOwli2QZv1l/NptcJYYtV/CKBIaI/4C+7RKRllPVcMU+tvVBAQsI7eajGIMLnBFeqWmnvmzYpeEwsAVU0pHQgGGIm4/R6eJKmg099Sq2tBzpuUd/JmvqT2FZu7ybo6n/beNY+Yg7ayUv7XTQvojtxIEWBrvFZ9GQBail91zjrPwZ/SotxSuBl3DmhPc1
 HO1u9atg
 GR3l1vannxyMjliBc+zaPrw2j/ai0iF6A5HaGNnbOJfrcfODPlGMO/ocnY26t1xEcahGz/+Xg363FamNzASVwLNFUuVEgm0JrRqHqNJdhEUmDx8qYnSRXe9NYqFFPQhv/26Zw+Pswf0Uin1vZlfndiE3+YQ41Xmq1lGlAD7M+GxD4DwAnnECrHsFkypnobvs23WuBajnKU7NQnZfiarKaoice3M6RFv5Y5cpYtWphI6fEEC0pfTnVkr0Ywp2oZh9I3ymOFMdRq5UkVe7uPIG9W+I+pNt4qHpoWMnBrHPeclBqBakqcnOAmOXp7CoGOb3jiQfMjYx+oI0Y2y+koml7ivVvgVjiJwpuVfECsDESwpqzthdxTKxH2vTjOf7AHwRU0WhrAof6Ngfrw+ti4ZhTMhXEOhO9Y11DOaL3VeHPFKH1boynnq+W6EwONk4z334vaewy67XQBHek7Y2RDbn5mpuSmdNczEFnEVr7UuZBRb8+k04q3yifxRWbdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============2924590592151832210==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c b/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
> new file mode 100644
> index 0000000000000..179b64fb6de84
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c

[ ... ]

> +	/*
> +	 * Optional baseline for the benchmark numbers below: run the
> +	 * same workload once without the BPF program, so the log can
> +	 * report how much async reclaim improved the pressured cgroup.
> +	 */
> +	if (bench) {
> +		err = run_high_low_workload(dir, &base_high_time,
> +					    &base_low_time, READ_TIMES);
> +		if (!ASSERT_OK(err, "run_high_low_workload baseline"))
> +			goto out;
> +
> +		/*
> +		 * The baseline left up to CG_LIMIT of page cache charged to the
> +		 * high and low cgroups, and memcg charges outlive the workload
> +		 * processes. Recreate the cgroups so that the instrumented run
> +		 * below starts from the same cold state the baseline did;
> +		 * otherwise the reported speedup compares a cold run against a
> +		 * warm one.
> +		 */
> +		cleanup_cgroup_environment();

Does this comment accurately describe why the cgroups are recreated?

Looking at run_high_low_workload(), its cleanup block closes all four file
descriptors and then unlinks all four temp files after both children have
been reaped. With link count zero and no remaining open descriptors or
mappings, the inodes are evicted, their page cache is truncated, and the
memcg charges are released - so memory.current for the high and low
cgroups is already back to near zero when control returns here.

What actually survives the baseline is memory.stat, particularly the
WORKINGSET_REFAULT_FILE counter that the BPF program samples via
should_reclaim_cgroup(). Without recreating the cgroups, wq_prog_init()
would start elem->prev_event at 0 while the counter is already large from
the baseline, so the very first timer tick would see a huge delta and kick
off a reclaim round unconditionally. Recreating the cgroups zeroes those
counters.

Could the comment be updated to describe that the recreation clears the
WORKINGSET_REFAULT_FILE counters in memory.stat rather than page cache
charges, which are already released when the files are unlinked?

[ ... ]

> +	reader_pid = spawn_keepalive_reader(data_fd);
> +	if (!ASSERT_GT(reader_pid, 0, "fork keepalive reader"))
> +		goto out;
> +
> +	/* Wait for reclaim rounds to reach the live target cgroup. */
> +	for (i = 0; i < EVENT_POLL_ROUNDS && !seen.called; i++) {
> +		n = ring_buffer__poll(rb, EVENT_POLL_TIMEOUT_MS);
> +		if (!ASSERT_GE(n, 0, "ring_buffer__poll"))
> +			goto out;
> +
> +		/*
> +		 * The reader loops until killed, so finding it already gone
> +		 * means the refaults the BPF program waits for never started.
> +		 * Report its exit code rather than letting the assert below
> +		 * blame the kernel for the full poll window.
> +		 */
> +		if (waitpid(reader_pid, &status, WNOHANG) == reader_pid) {
> +			/* Reaped, so cleanup must not signal a reused PID. */
> +			reader_pid = -1;
> +			if (WIFEXITED(status))
> +				PRINT_FAIL("keepalive reader exited early: %s",
> +					   child_exit_str(WEXITSTATUS(status)));
> +			else
> +				PRINT_FAIL("keepalive reader died, status 0x%x",
> +					   status);
> +			goto out;
> +		}
> +	}
> +	if (!ASSERT_GT(seen.called, 0, "reclaim events")) {
> +		report_timer_failures(skel);
> +		goto out;
> +	}
> +
> +	remove_cgroup(CG_DYING_TARGET_DIR);
> +
> +	/* Let reclaim passes that were already in flight drain. */
> +	usleep(DYING_SETTLE_US);
> +
> +	calls_before = skel->bss->reclaim_calls;
> +
> +	/*
> +	 * Wait for a reclaim round to hit the removed cgroup. Only TARGET_GONE
> +	 * ends the wait: an attempt that lands inside the rmdir window reports
> +	 * SKIPPED_DYING first, and stopping there would miss the events that
> +	 * follow it.
> +	 */
> +	for (i = 0; i < EVENT_POLL_ROUNDS && !seen.target_gone; i++) {
> +		n = ring_buffer__poll(rb, EVENT_POLL_TIMEOUT_MS);
> +		if (!ASSERT_GE(n, 0, "ring_buffer__poll"))
> +			goto out;
> +	}

The second poll loop here drops the keepalive-reader liveness check that
the first loop performs, although both loops depend on the reader equally.

TARGET_GONE is only emitted when a reclaim round actually starts, and a
round only starts when should_reclaim_cgroup() sees a fresh
WORKINGSET_REFAULT_FILE delta - which only happens while the reader keeps
refaulting. If the reader dies during this second window, refaults stop, no
TARGET_GONE ever arrives, and the test reports "no reclaim round hit the
removed cgroup (gone=0, dying=0)", blaming the kernel for a dead child.

That is exactly the misattribution the first loop added a waitpid(WNOHANG)
check to avoid. The reader's exit code is still available here, since a
reader that dies during the second loop is left unreaped until the out:
label. Should the second loop include the same liveness check to avoid
misattributing a dead reader as a kernel issue?

> +	/*
> +	 * TARGET_GONE is what the test can rely on: by the time rmdir has
> +	 * returned, bpf_cgroup_from_id() has stopped resolving the target.
> +	 * SKIPPED_DYING only happens if an attempt lands inside the rmdir
> +	 * window, so it is reported here rather than asserted.
> +	 */
> +	if (!seen.target_gone) {
> +		report_timer_failures(skel);
> +		PRINT_FAIL("no reclaim round hit the removed cgroup (gone=%d, dying=%d)",
> +			   seen.target_gone, seen.skipped_dying);
> +		goto out;
> +	}
> +
> +	/*
> +	 * Reclaim must have stopped with the target. Both counters stay put for
> +	 * the same reason: once rmdir has returned, bpf_cgroup_from_id() fails,
> +	 * so every attempt takes the TARGET_GONE path before it can reach
> +	 * reclaim_calls++. This therefore checks that reclaim really stops, not
> +	 * that cgroup_is_dying() works -- see that function in the BPF program
> +	 * for why the dying window cannot be hit reliably from userspace.
> +	 *
> +	 * reclaimed_bytes is compared against 0 rather than against its
> +	 * pre-removal value: the target is empty for the whole test, so
> +	 * bpf_proactive_reclaim() has nothing to reclaim and must have returned
> +	 * 0 on every call, before and after the removal alike. An "unchanged"
> +	 * comparison would be 0 == 0 and could never fail.
> +	 */

Does the reclaimed_bytes explanation make sense? The comment argues that
comparing reclaimed_bytes against a pre-removal snapshot "would be 0 == 0
and could never fail", but by its own premise that snapshot is 0, so the
snapshot comparison is literally the assertion that was written:
ASSERT_EQ(skel->bss->reclaimed_bytes, 0ULL). Both forms read
reclaimed_bytes after the removal window and both fail exactly when a
post-removal reclaim adds bytes; neither is vacuous and neither is stronger
than the other.

As written the comment tells a reader that one of two identical checks
cannot fail, which is misleading. Could it just state that
bpf_proactive_reclaim() returns 0 on the empty target throughout the test,
without the comparison that makes them sound different?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/35318390791
--===============2924590592151832210==--

