Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D67BD2D8E3
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 10:08:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A73D76B0096; Tue, 27 Jan 2026 05:08:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A14676B0098; Tue, 27 Jan 2026 05:08:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DA9B6B0099; Tue, 27 Jan 2026 05:08:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7EF8C6B0096
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 05:08:38 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 59021160BD9
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:08:38 +0000 (UTC)
X-FDA: 84377319516.26.1B2306D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 984EA10000D
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:08:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=fcYpJ1iW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769508516; a=rsa-sha256;
	cv=none;
	b=iir7Cx9iX7bj1airFFHoeedn+YWzy5PYMVgDHCDLbq19Wol5Ml1ufbI5Wig28PrZD6XZ8O
	uOx+jCBz1jZ3ku+lmN0GQ4soWp10WIdv+I48JvJSt9NDZRu++8ut9DFa+MFT4anqKVNdvs
	VaJmPSQFx+CzjKbZDF0jsCH962LXmJo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=fcYpJ1iW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769508516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jGk6hlk5NTjs63TKjmkM6oTG6CFKbA/qqrOMjr3xYg8=;
	b=MoMlLLbK8v+OvfTa5sguixfvlpilb5GZRU0bE1cskh6ZRs43L+YxablCOv/8FNTxbzvpHD
	4z8of8SoawTsizjQ8zcYjLVmW00PRmyB472pA+g03oqyMRBoWC+g6pVK8I6j4xhFJwHec+
	ZQxuy0aAuqvTMlMwa80hgTwuS/Nq2Q8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 68A7E405A6;
	Tue, 27 Jan 2026 10:08:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFAEC16AAE;
	Tue, 27 Jan 2026 10:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769508515;
	bh=pxcghcGoznBPYSsYWOnMk9AZAKVnZLIBsd7EtsGmQiE=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=fcYpJ1iWIhFQ77RVschYYFWk5OXRaNQW0yy0eCDumbo/Zk3DKGOOjbRYQjX/PF02Y
	 OoTplVx9aQUE1BRdSdhEMcYbZ8jIk+uyj41DJMN2pNoT+wdYjF2YkMjHJPTD+FNQU7
	 jDuZVivjOHWzcjmvjQ7k2KYozA8SOxbZWqktmip3jCMB9ZiCRvrd94ZcbcqP5nffHH
	 SRJFou7vgvpsHMYeF1gY1G448k4m0zLmcGl8XxA+PUzZFaQ/hvh4S1ByLk2MiLJMGh
	 y9VgFxXSi7pYN9mPcYk4R9aNsFni6Ly8v0L+fZOmJuGydhMP7B5DkcY98fiE1XdU3r
	 OuAcVpbRBeryw==
Content-Type: multipart/mixed; boundary="===============5556048094623002563=="
MIME-Version: 1.0
Message-Id: <34fb17bae65a38450661486263eaffebd488c8943bbf9416e72ba2c0e3b31e07@mail.kernel.org>
In-Reply-To: <f02bee79100c0df5d799d0d941666b0bf9700ac9.1769506741.git.zhuhui@kylinos.cn>
References: <f02bee79100c0df5d799d0d941666b0bf9700ac9.1769506741.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH bpf-next v5 09/12] selftests/bpf: Add tests for memcg_bpf_ops
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev, akpm@linux-foundation.org, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, ast@kernel.org, daniel@iogearbox.net,
	andrii@kernel.org, martin.lau@linux.dev, eddyz87@gmail.com,
	song@kernel.org, yonghong.song@linux.dev, john.fastabend@gmail.com,
	kpsingh@kernel.org, sdf@fomichev.me, haoluo@google.com,
	jolsa@kernel.org, shuah@kernel.org, peterz@infradead.org,
	ojeda@kernel.org, nathan@kernel.org, kees@kernel.org, tj@kernel.org,
	jeffxu@chromium.org, mkoutny@suse.com, kernel@jfarr.cc,
	brauner@kernel.org, rdunlap@infradead.org, brgerst@gmail.com,
	masahiroy@kernel.org, davem@davemloft.net, kuba@kernel.org,
	hawk@kernel.org, inwardvessel@gmail.com, willemb@google.com,
	kerneljasonxing@gmail.com, paul.chaignon@gmail.com,
	a.s.protopopov@gmail.com, ameryhung@gmail.com,
	chenridong@huaweicloud.com, lance.yang@linux.dev,
	jiayuan.chen@linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org, bpf@vger.kernel.org,
	netdev@vger.kernel.org, linu@kvack.org, x-kselftest@vger.kernel.org
Cc: zhuhui@kylinos.cn,geliang@kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Tue, 27 Jan 2026 10:08:34 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 984EA10000D
X-Stat-Signature: qg96pb18xinwhjoah1ibjtkbcjszwzse
X-HE-Tag: 1769508516-652847
X-HE-Meta: U2FsdGVkX18JHp+GyyUbQU7O5dAu8gd+dHTzUbbI/OeW12IiU3fUQQNOH4T01Bl0ZUii9e6uliv8CD8KvL4YqcaHYtREPOCkmawPf6AjKbSymjmghxuMh/+INrelxXWnbuWfzdMDrVKkte4/Qu7NDa1IO7d00mICk3ciXBxgS5psdDmILEdjNbaOOehs61fbJKSZZeOiMSO3G3SZ0RDWy/nYblQKyTIwFx1pShMeAkKuoOwEFr3xugXf4wKiO7Fmvb2G6+03BaXDU9KGSa160XJBgLqmNJDHvRItyvG1ouveWWptgemUnC7EEB2XqpfuOBF4qUjPellhozR+w4Xw1F21e98l4AHgkZ1LFWIc3QrvyDFiWtNqkXWPtTgNjEpGVfr+1Cy9S7+olTG/ZnWKxGUWtRVrGWDP/bdYQw6AG6UuvE5mruY68m1Af77DhfSWmctPSdpScy3iqFmd9bEWU36D1EZfqW97Mz/encvvq2UiMcL0/kwreOlIZoH9G9F9n/KTzz/zlAIj+f152H2Ru8y5ygyYsHGEO/DVfDd3OQqUrcTLaZ5fWzTJPMseh1XTT0X/d8lVqs/WPEe47u70N/mZfV6DFB+uV68fudamvQhNHtjTgrbIG/qxRTC7g+N2JXy5Ffxy7WdhU7kiWM3RGH5vAecNgTF9rALZuqXj/7UF7yRrEOe2EJmMsZBpjEgZGdjU3ZV60skxRSoanRQ/C8mkE3JcqjPU8auDu5L3Fhf3FuTyVgmq0eXBDrt0uALU7yGGhP1baUYm/wTxWXChlpiB6caqLGtHEoTrtL3rgiEVtOdNHzCecOmJRVpJdZxzDbXzuSGEjnQ7GHilHbd8kZLPt6yOMAgIzuMbUTakR63L/5TO7siZfWkSe3bVumD037WO3BH4YMZWvZqwI/BQS4vnCrydGkLl0Qc8lYCQeFbkbg2ikLqrNLImTAwYlv2PCNP/pJd5c0Jpcai2nEF
 Zp+sbQgc
 QSSU+NMyo982fbAy3ok1SqQ49S/1aQFBl5VYUf3XiV5fcq8Xms9gwad/RrEQriJrWgFI0rNAL+cJQDQALnXGS0tWpdzDWJcbNH/yX4N1t/4TSu5Wkk0KkaZWBP0K3+72KhpVMzB0ydTajYpOL6vGsTqn2leZhb8KXderuQOxuUBr7G5RHqzUJbh4gN6MKkHJPjD7koyp9y/MmGNXCXlEGYsgMR2/h+Fzffpu/6kcYjT0h8jhhzBmQT0CwPG+PJMo5OWg3aN2yvGrBhYAQjSbMYagqZbL9i4TBotp27sHKNfdMB9v7nXYZAG6McDtxG7xt0vI9UUM0tGWUyUmPcrEThcJDpYtePiyujvIP+nilpYXx+Q6dNuPpY6d19WNjtZQp+IBKQopoqzMN6qiLXidpUQzCSw1ZOvkgmkUvZkar7cw6Hjwl7+9Gyjmu14T8GxmKAtKJNe/EMUD98vtVZe01NL8jWMrjGv4BGLigXyZvV3W2kYJ8jHjOw9rBgX02ZWlZPnfBuLTTQQnuNu9MoNBcB+SUEOcDQDKgap8+I6dy0u2AU1uF+6c/p0kqkXCe0iwmvEX2R9bpGJiGtgtIrviPYEWZ3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============5556048094623002563==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_ops.c b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
> new file mode 100644
> index 000000000000..a596926ea233
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c

[ ... ]

> +void test_memcg_ops_over_high(void)
> +{
> +	int err, map_fd;
> +	struct memcg_ops *skel = NULL;

[ ... ]

> +	skel = memcg_ops__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "memcg_ops__open_and_load"))
> +		goto out;

[ ... ]

> +out:
> +	bpf_link__destroy(link);
> +	bpf_link__destroy(link2);
> +	memcg_ops__detach(skel);
> +	memcg_ops__destroy(skel);
                  ^^^^

Can this cause a NULL pointer dereference? When memcg_ops__open_and_load()
fails, skel is NULL and the code jumps to out: where memcg_ops__detach(skel)
is called. The generated __detach() function does not check for NULL, unlike
__destroy() which does. Since __destroy() already calls __detach() internally
after checking for NULL, the explicit memcg_ops__detach(skel) call appears
to be unnecessary and would crash when skel is NULL.

The same pattern appears in test_memcg_ops_below_low_over_high() and
test_memcg_ops_below_min_over_high().


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21392729810

AI-authorship-score: medium
AI-authorship-explanation: The commit message uses verbose, explanatory language with markdown formatting that is somewhat atypical for kernel commits, and the repetitive test function structure with the redundant detach call suggests possible AI assistance in code generation.
issues-found: 1
issue-severity-score: low
issue-severity-explanation: The memcg_ops__detach(NULL) call can crash the test if the skeleton fails to load, but this only affects the selftest program and not the kernel itself.

--===============5556048094623002563==--

