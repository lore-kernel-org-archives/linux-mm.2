Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 052FDC79F87
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 11:25:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A6566B0092; Fri,  4 Sep 2026 07:25:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07EF46B0095; Fri,  4 Sep 2026 07:25:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E88696B0096; Fri,  4 Sep 2026 07:25:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C05EB6B0092
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 07:25:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5908A160B8D
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:25:40 +0000 (UTC)
X-FDA: 85175849640.04.A4C850E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id B4C9440008
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:25:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LgNfp/GU";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788521138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QpoDQhn4oJYCK98pQwvN+wQQFe49V1p9PTBk/e/fNZo=;
	b=5jw7NOljTd43ol/svRsy1EFyjvkJKNJRE27HfgCw5b0mLvzq03wvRfU//g/pqHS52Hu2Hj
	HIkngqs7taQQ5DDbVLMbC+kbuoAeM/vxDk+mZtd3ALRqnjbEd1Frmw/vfANvrKyaEEE0Yx
	8se6JQElJg8zyUQwlRiVZQWgYBWce3E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LgNfp/GU";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788521138;
	b=7y6WVa/MiFlBRtKwLxT7FUxxQv7NibhrXxkI2AdMQUKP8m1NAFPbQ8x0jDifD1zazeuqDZ
	gWZadgzoI0g2pFtortoyj9PsW3YkylR9KuIQOcsYFcCEdK1ugkDaPpcJY4CxGY6mAADNgz
	Z0o2bq7wKq4o88t3GaJOLHCUMmO18PY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 613116022B;
	Fri,  4 Sep 2026 11:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8DCF1F00ACA;
	Fri,  4 Sep 2026 11:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788521137;
	bh=QpoDQhn4oJYCK98pQwvN+wQQFe49V1p9PTBk/e/fNZo=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=LgNfp/GUE2ZO/irr52zhlG2SVw5SfbK43MlUscg3rkj4Wzb5NHpVLqSLP4rQag6tg
	 Sr+pe1WnzVeghTRYgCc+aGR/EiRVNJ0eGI/aoVL3ZDSHHXSwWR13oZckCWKKBXm9V/
	 NFeStUzUYIsfXN4ipT1WNlpY7mrASV4HT/Dce0ApldCNu5Td0ad0HJIdZ+KTrv8Za5
	 ovGsgCFEC6U5Ac5wvahy6H68mU9jqxGGn0m7349yCMA+XgjNX4v9b8zcf9gvzkDzpi
	 S79eEr4DiNMdQSUfowAENukyCPnf6ZdD8a+1Nh09/AYwloCxKW1+o1fvgc+/C8ZpjU
	 dxdp+34ZW+Low==
Content-Type: multipart/mixed; boundary="===============8601708920699295858=="
MIME-Version: 1.0
Message-Id: <b4ccae5dbb03102127798279ea2538c3a749c0e326a861bec03bef916e4457a0@mail.kernel.org>
In-Reply-To: <5ca2a2fca5f551b39158d7dc31f1ee443bf1b98c.1788516769.git.zhuhui@kylinos.cn>
References: <5ca2a2fca5f551b39158d7dc31f1ee443bf1b98c.1788516769.git.zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next v7 2/2] selftests/bpf: Add memcg async reclaim test
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev,roman.gushchin@linux.dev,inwardvessel@gmail.com,shakeel.butt@linux.dev,akpm@linux-foundation.org,andrii@kernel.org,eddyz87@gmail.com,ihor.solodrai@linux.dev,ast@kernel.org,daniel@iogearbox.net,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,shuah@kernel.org,baohua@kernel.org,geliang@kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,linux-mm@kvack.org,linux-kselftest@vger.kernel.org
Cc: zhuhui@kylinos.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Fri,  4 Sep 2026 11:25:35 +0000 (UTC)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B4C9440008
X-Stat-Signature: 4393wf4pzaysnj8r8cr4ubi5sih5k9ts
X-Rspam-User: 
X-HE-Tag: 1788521138-104196
X-HE-Meta: U2FsdGVkX1+ry5xb/PyzEoyl+lSKUTQgrYG2QCv56n9OzoBPmSBuO764vMfn6U0a93jD71c0eVlXNqi3PPIjKFtkgsbOnOHmypz68Z8t9MVNgV89oPVG4dUxqxT6og6HWS6LkLvx8gQGO/eCBcuipUYUlZBHgACOce22iyOgN1OVbLEAj/gAh5+9iDyNwsD0XsUU5/SREPop0vpEKxLCXqiUh5bZArF1Rj0UB0DdcK3J/MFU9w/9qBRXtPkG51ZHNMTltr6H4ugDj7QyJvtDV5bX9HkwBexEzGAM+9taHDXP2S3OmwZLnLYAEL/qzsdENdY0DQjtILi07zUSRjRZSeYJNo9Q+W/SCisJxupbhJjnPkFPsApaeVWgZqzEkrQSBfL97uorQBRgbKpHxtq8VdOadd7mOLN6jIty8mz9t9cR3zlsWNljuhYdUqB+NJkB/AlOR5sKDbs8ZtHt64p0JntYC2VvnsIZ6qrXNd+Ri3N8v0sf4dPoIqucexZJNBSOWCDMlyMgeE5e/KMhpfx0uPmFESmTfEewMe37q+ZJjBK0MMXcrjd547ZKCV0T4B4kIc9Ue2iNC2FqziDuOI5izRXfcJlBp0Us4cuhpkn740s6XcYIt5+DhIyLPUtxU5nKhGewg/gSRDZ2cw6ihxM/Kt5dnM+I8evB7jVcu/Pm9smTRuUWO8Ofq2sDkaLpIqRrzvfXtO/0HKYfGVskNQjg9inYKavSi33ocCAPylJPDlRV8Xmg217PRAWU2JY+6Fu5PxGOrk8jO4tPWcBD3MrguDLiVLT5Ny59HAU/Th7Pb7Ja3X3NCtK9WoqAO6uXEdTpmi2MZp5Y4FtuFZHWJdpW4xdyawXNK6D+0WAluG3IRtoXXwlROd4PLo0N6ya57APnqt/2s+IdDTNZSn3l+unvYbE7nFTKvKPK53bWuLkOJPgk3gJfogTo3d1xpvyuWLXVnLUbnbPAW8P9GWJeF2v
 oX/WYbJN
 vFXkdmqNDrqFV6bBHDZx6fE+XPwYFUXrQpJa3nY6fZwYcQTNVkgsbwtwxEz+H49cYMxzf0RkJA/L/USbqg3I7Kcal5wdXJMLzdCSskyQCMHlBk+2FEymLP41h+MqsJ43o3gv7rg9GgVHpxL3av8b/1t1SAfHlSh6zRznm+HzT4E7sAh26c7aTkMQwd4nZe3O9suHWyFuN81mBFxM1x98GAB0iQbQWGn37L30MOFrW6VSy4GdjyYuASWh6GotPYuevVDiS5Oj62p3Bt/wvDLoaiazcpXLFJ1lAoCzog8HNWujylvXFVe4Wlbf2yYoK8DPfms3LSSLfnL7HURYjNI5A+Z7F6TZxcdzAKugASJm8heEN+9K6iloBEw64qBzFnDpZOre0RFf+XoJBIAyVr1AdbzBqO5ZMeBpPGZ+17hYFgdnkQBea7zOHwJ0pL7BIMyk5GdY9aVq//Zdh0CH/U4wrDYdN1vcc3dH+7B1hpxc2Yddeahf66yDKORreYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============8601708920699295858==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c b/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
> new file mode 100644
> index 0000000000000..65f5006844636
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c

[ ... ]

> +static int write_file(const char *filename)
> +{
> +	int ret = -1;
> +	size_t written = 0;
> +	char *buffer;
> +	FILE *fp;
> +
> +	fp = fopen(filename, "wb");
> +	if (!fp)
> +		goto out;
> +
> +	buffer = malloc(BUFFER_SIZE);
> +	if (!buffer)
> +		goto cleanup_fp;
> +
> +	memset(buffer, 'A', BUFFER_SIZE);
> +
> +	while (written < FILE_SIZE) {
> +		size_t to_write = FILE_SIZE - written < BUFFER_SIZE ?
> +				  FILE_SIZE - written : BUFFER_SIZE;
> +
> +		if (fwrite(buffer, 1, to_write, fp) != to_write)
> +			goto cleanup;
> +		written += to_write;
> +	}
> +
> +	ret = 0;
> +cleanup:
> +	free(buffer);
> +cleanup_fp:
> +	fclose(fp);
> +out:
> +	return ret;
> +}

Does write_file() report buffered flush failures? It sets ret = 0
before fclose() and then discards fclose()'s return value, so if the
final flush fails (for example, ENOSPC when writing the 32 MiB file
into /tmp), the function still returns 0.

The truncated file is caught later by read_file()'s st_size check, but
the child exits with CHILD_EXIT_READ_FILE instead of
CHILD_EXIT_WRITE_FILE, so child_exit_str() reports "read data file"
for what was really a write failure. The per-step exit codes added by
this patch exist precisely to pin down which step failed.

[ ... ]

> +/*
> + * Remove the reclaim target while the BPF program keeps running and
> + * verify that reclaim stops on the dying/removed cgroup instead of
> + * reclaiming from it.
> + *
> + * The target stays empty; the workload lives in the trigger cgroup and
> + * only keeps refaults flowing so that reclaim rounds keep starting,
> + * both before and after the target is removed. reclaim_calls growing
> + * while the target is alive proves that rounds really run (the kfunc
> + * returns 0 on the empty target, but the call is still counted), and
> + * after the removal the skip counters must grow while reclaim_calls
> + * and reclaimed_bytes stay frozen.
> + */
> +void test_memcg_async_reclaim_dying(void)
> +{
> +	u64 trigger_cgroup_id, target_cgroup_id;
> +	u64 calls_before, bytes_before;
> +	char data_file[PATH_MAX] = "";
> +	struct memcg_async_reclaim *skel = NULL;
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

[ ... ]

> +	/* Wait for reclaim rounds to reach the live target cgroup. */
> +	for (i = 0; i < DYING_POLL_ITERS; i++) {
> +		if (skel->bss->reclaim_calls > 0)
> +			break;
> +		usleep(DYING_POLL_INTERVAL_US);
> +	}
> +	if (!ASSERT_GT(skel->bss->reclaim_calls, 0, "reclaim_calls"))
> +		goto out;
> +
> +	remove_cgroup(CG_DYING_TARGET_DIR);
> +
> +	/* Let reclaim passes that were already in flight drain. */
> +	usleep(DYING_SETTLE_US);
> +
> +	calls_before = skel->bss->reclaim_calls;
> +	bytes_before = skel->bss->reclaimed_bytes;
> +
> +	/* Wait for reclaim rounds to hit the removed cgroup. */
> +	for (i = 0; i < DYING_POLL_ITERS; i++) {
> +		if (skel->bss->reclaim_target_gone ||
> +		    skel->bss->reclaim_skipped_dying)
> +			break;
> +		usleep(DYING_POLL_INTERVAL_US);
> +	}
> +
> +	if (!skel->bss->reclaim_target_gone &&
> +	    !skel->bss->reclaim_skipped_dying) {
> +		PRINT_FAIL("no reclaim round hit the removed cgroup (gone=%llu, dying=%llu)",
> +			   (unsigned long long)skel->bss->reclaim_target_gone,
> +			   (unsigned long long)skel->bss->reclaim_skipped_dying);
> +		goto out;
> +	}
> +
> +	/*
> +	 * reclaim_skipped_dying shows that the CSS_DYING/CSS_ONLINE check
> +	 * caught the cgroup mid-teardown. Whether it is hit is timing
> +	 * dependent, because the cgroup may already be fully released, so
> +	 * only the combined skip count above is asserted.
> +	 */
> +	printf("memcg_async_reclaim_dying: skips on removed cgroup: gone=%llu, dying=%llu\n",
> +	       (unsigned long long)skel->bss->reclaim_target_gone,
> +	       (unsigned long long)skel->bss->reclaim_skipped_dying);
> +
> +	/* Nothing may have been reclaimed from the removed target. */
> +	if (!ASSERT_EQ(skel->bss->reclaim_calls, calls_before, "reclaim_calls"))
> +		goto out;
> +	if (!ASSERT_EQ(skel->bss->reclaimed_bytes, bytes_before,
> +		       "reclaimed_bytes"))
> +		goto out;

Can this test distinguish a BPF program that implements the
CSS_DYING/CSS_ONLINE check from one that does not?

The commit message says "Looking the target up by id is not enough:
bpf_cgroup_from_id() keeps handing back a cgroup until its last
reference is dropped, so the program checks the css flags and skips
reclaim once the target is offlined or dying", and the comment above
this test says it "verifies that reclaim stops on the removed target
instead of reclaiming from it".

But bpf_cgroup_from_id() does not keep handing back the cgroup after
rmdir. The lookup sequence is:

  bpf_cgroup_from_id()
    -> cgroup_get_from_id()
      -> __cgroup_get_from_id() in kernel/cgroup/cgroup.c
        -> kernfs_find_and_get_node_by_id()

kernfs_find_and_get_node_by_id() in fs/kernfs/dir.c fails on an
inactive node:

    if (unlikely(!__kernfs_active(kn) || !atomic_inc_not_zero(&kn->count)))
        goto err_unlock;

cgroup_destroy_locked() runs synchronously inside the rmdir syscall and
calls kernfs_remove(cgrp->kn) before it returns. By the time
remove_cgroup(CG_DYING_TARGET_DIR) at line 635 returns, every subsequent
reclaim round takes the get_cgroup_memcg_from_id() failure path in
progs/memcg_async_reclaim.c:132, bumping reclaim_target_gone and leaving
reclaim_calls / reclaimed_bytes frozen.

That happens whether or not cgroup_is_dying() exists in the program.
reclaim_skipped_dying is only reachable through a sub-microsecond race
in reclaim_cgroup() where the reference is acquired before rmdir but the
flags are read after, and the deliberate usleep(DYING_SETTLE_US) = 200
ms at line 638, placed before the calls_before/bytes_before snapshot,
makes even that window essentially unobservable.

So the break condition at lines 645-647 and all three assertions (lines
651-657, 670, 672) are satisfied by the lookup-failure path alone.
Deleting cgroup_is_dying() from the BPF program would not make this test
fail.

To actually exercise the dying window the test would have to keep the
target cgroup pinned so that bpf_cgroup_from_id() still resolves it
while it is offline (for example, hold a cgroup fd or a task in it, or
drive the removal concurrently with reclaim without the 200 ms settle)
and then assert on reclaim_skipped_dying specifically rather than on the
OR of the two counters.

> diff --git a/tools/testing/selftests/bpf/progs/memcg_async_reclaim.c b/tools/testing/selftests/bpf/progs/memcg_async_reclaim.c
> new file mode 100644
> index 0000000000000..e6839ade472bb
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/memcg_async_reclaim.c

[ ... ]

> +/*
> + * One reclaim round targets RECLAIM_MAX_ITER batches of RECLAIM_SIZE
> + * each. Each bpf_wq callback reclaims a single batch and requeues the
> + * same work item for the next one, so no callback runs longer than one
> + * bounded reclaim pass.
> + */
> +#define RECLAIM_SIZE		(32 * PAGE_SIZE)
> +#define RECLAIM_MAX_ITER	32

[ ... ]

> +/*
> + * A cgroup is dying once it has been offlined (CSS_ONLINE cleared) or
> + * CSS_DYING has been raised, mirroring cgroup_is_dead()/css_is_dying()
> + * in include/linux/cgroup.h. bpf_cgroup_from_id() can still hand back
> + * such a cgroup, because it only fails once the last reference has been
> + * dropped, so reclaim has to check these flags instead of relying on
> + * the lookup failing.
> + *
> + * CSS_ONLINE and CSS_DYING come from vmlinux.h: the kernel defines them
> + * in an anonymous enum, so bpf_core_enum_value() has no enum type to
> + * bind to, and redeclaring them locally would clash with the vmlinux.h
> + * enumerators. vmlinux.h is generated from the running kernel's BTF, so
> + * the values already match the target kernel.
> + */
> +static bool cgroup_is_dying(struct cgroup *cgrp)
> +{
> +	unsigned int flags = cgrp->self.flags;
> +
> +	return (flags & CSS_DYING) || !(flags & CSS_ONLINE);
> +}

Does the (flags & CSS_DYING) term ever fire?

CSS_DYING is never set on cgrp->self. The only assignment in the tree is
css->flags |= CSS_DYING in kill_css_sync() at kernel/cgroup/cgroup.c:6147.
kill_css_sync() has exactly two callers, and both pass a subsystem css,
never the cgroup's own self css:

  - cgroup_destroy_locked() calls it under for_each_css(css, ssid, cgrp),
    and that macro only ever yields cgrp->subsys[ssid].
  - cgroup_apply_control_disable() calls it with css = cgroup_css(dsct, ss)
    where ss comes from for_each_subsys(), so again dsct->subsys[ss->id].

kill_css_sync() also unconditionally dereferences css->ss->css_killed,
which would NULL-deref for &cgrp->self whose ss is NULL. So cgrp->self.flags
& CSS_DYING is always 0 and cgroup_is_dying() reduces to cgroup_is_dead().

Also, the comment above the helper claims bpf_cgroup_from_id() keeps
handing back the cgroup until the last reference is dropped. That is not
what the lookup does. bpf_cgroup_from_id() -> cgroup_get_from_id() ->
__cgroup_get_from_id() is kernfs_find_and_get_node_by_id() followed by
cgroup_tryget(). It starts failing as soon as cgroup_destroy_locked()
reaches kernfs_remove(cgrp->kn) or percpu_ref_kill(&cgrp->self.refcnt),
both long before the last reference is dropped. The window in which the
surviving !CSS_ONLINE check can still observe a cgroup is between
cgrp->self.flags &= ~CSS_ONLINE and kernfs_remove() a few statements
later, all under cgroup_mutex.

The comment at line 112 also states "vmlinux.h is generated from the
running kernel's BTF". tools/testing/selftests/bpf/vmlinux.h is generated
at build time from $(VMLINUX_BTF), which for a cross-built or packaged
selftest is not necessarily the kernel the test runs on.

[ ... ]

> +static int reclaim_work_fn(void *map, int *key, void *value)
> +{
> +	struct wq_elem *elem = value;
> +	u64 nr, size;
> +
> +	if (!elem->remaining) {
> +		/*
> +		 * Timer-triggered entry: start a new round only when the
> +		 * high cgroup refaults enough. Requeued entries skip this
> +		 * check and only look at remaining, so the refault delta
> +		 * is consumed once per round.
> +		 */
> +		if (!should_reclaim_cgroup(wq_high_cgroup_id, &elem->prev_event,
> +			elem->event_delta_threshold))
> +			return 0;
> +		elem->remaining = RECLAIM_MAX_ITER * RECLAIM_SIZE;
> +	}
> +
> +	/* One bounded reclaim pass per callback */
> +	size = elem->remaining < RECLAIM_SIZE ? elem->remaining : RECLAIM_SIZE;
> +	nr = reclaim_cgroup(wq_low_cgroup_id, size);
> +	if (!nr) {
> +		elem->remaining = 0;
> +		return 0;
> +	}
> +
> +	/* try_to_free_mem_cgroup_pages() may reclaim more than requested */
> +	if (nr >= elem->remaining)
> +		elem->remaining = 0;
> +	else
> +		elem->remaining -= nr;
> +
> +	/* Requeue the same work item for the next batch */
> +	if (elem->remaining)
> +		bpf_wq_start(&elem->work, 0);
> +
> +	return 0;
> +}

Does RECLAIM_MAX_ITER actually bound an iteration count?

The macro is only ever used as a byte multiplier:

  elem->remaining = RECLAIM_MAX_ITER * RECLAIM_SIZE = 32 * 128 KiB = 4 MiB

and the requeue loop is bounded by bytes actually reclaimed, not by
callback count. bpf_proactive_reclaim() returns the bytes that
try_to_free_mem_cgroup_pages() actually freed, which is frequently less
than the requested 128 KiB. A single page (4 KiB) is enough to keep the
round alive, so a round in which each pass frees one page needs 4 MiB /
4 KiB = 1024 callbacks, i.e. 32x more than the name and the file header
comment suggest.

Total work per round is still bounded at 4 MiB and each individual
callback is still one bounded pass, so there is no runaway. The defect
is that the documented iteration bound does not exist, which makes the
requeue budget hard to reason about.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/33864052510
--===============8601708920699295858==--

