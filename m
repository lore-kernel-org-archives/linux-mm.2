Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CADEC61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 11:38:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 222266B0092; Thu, 27 Aug 2026 07:37:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15BEB6B0095; Thu, 27 Aug 2026 07:37:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 099256B0096; Thu, 27 Aug 2026 07:37:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E204E6B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:37:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E8A7A3B98
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:37:58 +0000 (UTC)
X-FDA: 85146850236.07.E198AEF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id CAC1BA0004
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:37:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VzNuv0DX;
	spf=pass (imf25.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787830676;
	b=SbrNofv2wlIuXuFosMymd662FW6gIBGiDERSiLom6W8QdQLJrwHtY+G0p/5d06gkkOP5IS
	czBDfCOHJoeqnn4tWNWkiUfKY0w7zyks1IJyqlJZlWfJHA/hksc6jn64S+BFGhoJn09wBU
	H0E/tLywZHA0Zrg8x5P0ZQVqnTp7ovs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VzNuv0DX;
	spf=pass (imf25.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787830676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q3ywZN8bdBnVFQ78mtRW6DYA4krBtKE/BGQc0bJoxdY=;
	b=2elniLQl8fykffRKFcT2UU6tPZu8dQlNXvC4YqHKGR5Q2E3Zuh7kGBY4tJ49V3mH0keKXK
	Cu/QX64fbpzrzeQNDLq/7p/V6RVDolaaTxFiMBUQJ6LZM+Pb6tGiED9P21qRNa6VQ/vbTk
	00Hj3XddiuVmyMMuKzpnLsOcbGArxIs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0598840749;
	Thu, 27 Aug 2026 11:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691341F00A3A;
	Thu, 27 Aug 2026 11:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787830675;
	bh=q3ywZN8bdBnVFQ78mtRW6DYA4krBtKE/BGQc0bJoxdY=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=VzNuv0DXTALl+ro/Z5WmFFyK5GI+zLD63Uv4qBj8ALg/lbrssRK9yB7qQQ6EYpK2b
	 Jjaa+l3a4xC2YZlPP6TWA/uVglqJloVCfL8dgNoit8LZq3Uy1/QHtvqW+JB7b3kD6E
	 zhYQR9JT3RIR5Cs2p1hP4vOljzifxNnliPeo3hfzMG1WkI75mMujwg4AlJGI9AvrdX
	 L1MDopuK20STnHnTi1HOZBFT35x2FnNbekcVRy5UGoAYCED3HsxJEO3hTMwh/0KcV7
	 wraz0R3uHsA5TvtMsdB+lDYYWY1OD+dnEGbHdPKcDDZbiX94T6aD3/Qg6hwCjAQA4k
	 EdWUMFyR9PFuQ==
Content-Type: multipart/mixed; boundary="===============1642768360297098272=="
MIME-Version: 1.0
Message-Id: <32fbad9bf062c3b987defaa53cb5f3bf48bbdb87c35013fe7a0923b1caf3927b@mail.kernel.org>
In-Reply-To: <eec9160b702fd6d65631a34f0945230e0845d12b.1787826402.git.zhuhui@kylinos.cn>
References: <eec9160b702fd6d65631a34f0945230e0845d12b.1787826402.git.zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next v5 2/2] selftests/bpf: Add memcg async reclaim test
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev,roman.gushchin@linux.dev,inwardvessel@gmail.com,shakeel.butt@linux.dev,akpm@linux-foundation.org,andrii@kernel.org,eddyz87@gmail.com,ihor.solodrai@linux.dev,ast@kernel.org,daniel@iogearbox.net,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,shuah@kernel.org,baohua@kernel.org,geliang@kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,linux-mm@kvack.org,linux-kselftest@vger.kernel.org
Cc: zhuhui@kylinos.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Thu, 27 Aug 2026 11:37:55 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CAC1BA0004
X-Stat-Signature: ff684s858r96yg91pirbmwi1bsns73gd
X-HE-Tag: 1787830676-642696
X-HE-Meta: U2FsdGVkX18uXP6Ryz9GW9gdCqHAGBetAzN4Mmzskmz0zoeCPgEsQt2VwCMZNU86a2V44W42KRAFJF8nKohX9xV8wujO/Ah+2sL4JLV/SwKHMIkxEh7AaaeFQ2s7i82zs42jQeDSxR4iazbmZ70Gg175IpULoEZFjmjkDQyoo3AJ0CrBzh4pCMa4Jqj1icgf5cKSkCkv/nMV1ozjtaP4A+v2ZEcFm2/KYeOU+TthtzO6+FX2G24tEGtJQo7ZIxIMG+BsP4uMuwVlLFn5pTbvZEKslx7M0pGCw9Se10nBfgtXF4ahjChoSh+Hz8DX2zEH8kqG8x0UIAbspr2orB95CDc32R9IO6iEhWMe18Lb5P2IDIV/d4WVwF0YhVvSon0US+LbXvz+5+5YO+FHEzClh8gboTrx/9/0X6eIpOQ47LZegDHh+pal4ZZoiKHGBYTYTjysNADXd6g0OD89d+vsjfu1xSb0acUm8ljUSEBqiPSERo8zfmiC8dz720pMVKr+swdOa1XMEMFgccrIlcJ2dk0M/R6YPuiVpBntlJobiOj8duABVJkQHFQYNUKzPGxf98IOVuw6n/j9fl6NhMDSDKOBzETxFC1uI9u3w23xYgkH6gBykCegj8ZMs5YfS8/tEzfz2FtjPDyDldgPDf+KNTVrvodSUDHJDbnmouAtd/4516Ot3PH+6IvW+PiT0G5giSW/CltABic/eobsE2C/f6R4ZaxJt72bQW11fBX8Q9S5ZZmUHtAPti36Rq18lCHv17sVgPTqlVLk9e2ivImgcwt1YvUINvd7FpOKGshLyCBYfcc9N6qrodbk3sFqq9QHEUxsm9xER2bGE5w557XePXwACUfKBiqsBPR6vwnmKpagP0aZXw5BEMxyAnTnEUf0uTJFymWyeIWKwv+ftVIxNSCE79TqPtKFq3G4+Ri1Wgd0qUxaL83zq1mhhLUIsNGLIKKJtMnrkA/PBnij3if
 VRBlzoCE
 JlI+Q4zsKdt+/ythD9G6xeOG8aIImDhyskLePuw5uRmfIORtVwL5cOnKPW6/3wLE8CEm8pxPDT2Fmptgdktls2XI17yaGYVYgapCNqMPqvf2l/B0Q5yxsfW7wMLk+/lL3DxKpNOfNbxTTCAgddq+M2CwTZmFXOHIR/PYKFbQyyP+ATOSUmExiDt6vumG0Du1fU/PbwiBG+qSRthaS9K+WS0GkaMJOU3rF3R3S9m3SiJWw+XvhbHN/bL+yEx4By/+Wju6i8nqeUMRgHvib8fBRzNTcriR6Llk0G6Jf73D2tWEjqd7go9zemxvLrCnO0x5EDgdCjeCskkKNNwOgNB+ys0CuoqYBddrv6li691GU/scrcgYIZLpuGPcR9mSPTDttB7J8oYRitTD1pyjG06vuqQC+H13UxtkuwQI14NQIASZZzArzCn1+bMVl2+r/lHyrmIa3WVUcZn7zT6hLi1gENI9Q5Sb/LzPqBL0AdDUlR530dMgN3xe0KyJ0cA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============1642768360297098272==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c b/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
> new file mode 100644
> index 0000000000000..1270d73c9116e
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c

[ ... ]

> +	wait_ret = waitpid(low_pid, &status, 0);
> +	if (!ASSERT_GT(wait_ret, 0, "low waitpid"))
> +		goto cleanup;
> +	/*
> +	 * The child has been reaped and its PID can already be reused,
> +	 * so mark it to keep cleanup from signaling an unrelated process.
> +	 */
> +	low_pid = -1;
> +	if (!ASSERT_TRUE(WIFEXITED(status), "low exited"))
> +		goto cleanup;
> +	if (WEXITSTATUS(status) != CHILD_EXIT_OK) {
> +		PRINT_FAIL("low child failed at: %s (exit status %d)",
> +			   child_exit_str(WEXITSTATUS(status)),
> +			   WEXITSTATUS(status));
> +		goto cleanup;
> +	}
> +
> +	wait_ret = waitpid(high_pid, &status, 0);
> +	if (!ASSERT_GT(wait_ret, 0, "high waitpid"))
> +		goto cleanup;
> +	/* Same as above: the reaped PID must not be signaled again. */
> +	high_pid = -1;
> +	if (!ASSERT_TRUE(WIFEXITED(status), "high exited"))
> +		goto cleanup;
> +	if (WEXITSTATUS(status) != CHILD_EXIT_OK) {
> +		PRINT_FAIL("high child failed at: %s (exit status %d)",
> +			   child_exit_str(WEXITSTATUS(status)),
> +			   WEXITSTATUS(status));
> +		goto cleanup;
> +	}

The three PRINT_FAIL() calls in run_high_low_workload() omit the trailing
newline, so the failure messages run into whatever is logged next.
PRINT_FAIL() in test_progs.h does not append a newline:

#define PRINT_FAIL(format...)                                                  \
	({                                                                     \
		test__fail();                                                  \
		fprintf(stdout, "%s:FAIL:%d ", __func__, __LINE__);            \
		fprintf(stdout, ##format);                                     \
	})

Since test_progs hijacks stdout into an open_memstream() buffer that is
dumped verbatim, the missing newline concatenates these lines with the
following log output. The dominant convention in prog_tests/ is to
terminate the format string (33 of the ~44 PRINT_FAIL() call sites end
in "\n").

Should these three PRINT_FAIL() calls (the two shown above and the one
after the high_time/low_time comparison) end with "\n"?

> diff --git a/tools/testing/selftests/bpf/progs/memcg_async_reclaim.c b/tools/testing/selftests/bpf/progs/memcg_async_reclaim.c
> new file mode 100644
> index 0000000000000..b2ca5185150fe
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/memcg_async_reclaim.c

[ ... ]

> +static int reclaim_cgroup(u64 cgroup_id)
> +{
> +	struct cgroup_memcg cm;
> +	int i;
> +
> +	if (get_cgroup_memcg_from_id(cgroup_id, &cm))
> +		return 0;
> +
> +	reclaim_calls++;
> +	for (i = 0; i < RECLAIM_MAX_ITER; i++) {
> +		u64 nr = bpf_proactive_reclaim(cm.memcg, RECLAIM_SIZE);
> +
> +		if (!nr)
> +			break;
> +		reclaimed_bytes += nr;
> +	}
> +
> +	put_cgroup_memcg(&cm);
> +
> +	return 0;
> +}

This isn't a bug, but reclaim_cgroup() is declared to return int but
returns 0 on every path, including the lookup-failure path, and its only
caller discards the value:

reclaim_work_fn() {
	...
	if (should_reclaim_cgroup(...)) {
		reclaim_cgroup(wq_low_cgroup_id);
		bpf_wq_start(&elem->work, 0);
	}
	...
}

The failure to obtain the memcg is therefore indistinguishable from
success. The file already uses void where a helper has no result
(put_cgroup_memcg), so would it make sense to make reclaim_cgroup() void,
or to return -1 on the lookup failure and react to it?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/33064477499
--===============1642768360297098272==--

