Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32CC5D778B1
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 00:55:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F32E6B056C; Fri, 23 Jan 2026 19:55:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CB466B056E; Fri, 23 Jan 2026 19:55:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CA326B056F; Fri, 23 Jan 2026 19:55:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5992D6B056C
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 19:55:57 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BCE1C85538
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 22:28:46 +0000 (UTC)
X-FDA: 84364669452.03.1237EC8
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf15.hostedemail.com (Postfix) with ESMTP id D214BA0006
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 22:28:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jtryQf8n;
	spf=pass (imf15.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769207324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6q7jSvteo768fX3RDKijF3HLXLbv8PUQY59d7KtxMqQ=;
	b=loENSGP3FfYFj57nBwvQV8pEF6gfroDh4tj9WsKrhesh9JKnLJpldzMSzutWNJKwl176Lg
	rJ9siBGjSGszP0nAlKa6l63ANO8gqMrqOx7xwor7M/jLBkm1ZEcOWaF6nyB8LbpWZlGf5K
	ap6NTOUYD956gnJKlTJ2Yydy1anigNw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jtryQf8n;
	spf=pass (imf15.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769207324; a=rsa-sha256;
	cv=none;
	b=axALCxiJ+NzoWyhFk1w7zdahGe68TWxh85ovTJyH2eYaYb/Zf4E7bzjFDC/GdbLUbczUBn
	JXJxk29QzOPWERUF95qFtN1355N2W7Y1rMYjbf/Lz2qh+g23qUHhQKdsWlM3fqtzZLsZ1y
	GW9y2trceWU+ojM5maTCVhdhiywXFUw=
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-12332910300so3535073c88.0
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 14:28:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769207324; x=1769812124; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6q7jSvteo768fX3RDKijF3HLXLbv8PUQY59d7KtxMqQ=;
        b=jtryQf8nRrVmhKH3QY5z3uDd8/edqfKEmfwjX9KnMEk+6OCefbikGWC+TiIW3dvkzZ
         L1FlcFG0BfmDCv2LBaZmOSUpZ388H7QXFh3HRjDcdI4OulDpWYXDjb4uG0ltpjgtxSGa
         lnzZtWUAZDjiQSSZvEijGTrXuz5lOY4hXcVUW1tI1RNE9i3SOXeCBTDCt8YUxnY9VrW4
         188HNTw3DT7XjnROuRNugZAp2KPD1/j26fbcTmckDxn/P4nvCpSpKjQksW3NQ5vdriDc
         H8TSJyg0vkjX80zgcS4uHMqp6wCpNUc00jGoDoT60hza4JyenFB/T71QGR8N0MBnnYVy
         N09A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769207324; x=1769812124;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6q7jSvteo768fX3RDKijF3HLXLbv8PUQY59d7KtxMqQ=;
        b=KSvYYvZREQEDPGazMMKu9tm2J/bpf+Z9IKe92nodX3vsRXoO6KNtPTzEAyRsJKVyEA
         CMJthJSphL7OIEO7ovOlxDtsIZbQR3xKMF9tjpNRUhzQGSL79wOgak/weLK06DIKq1zo
         1MW5jobxlQP36CEYmIbUjSjMa0ddDl5QznGQzSOW/+ELH5vluhvCnDW+qT0PFQgxHYcX
         oDRty9WQn/ymnSgyI/sGKG/uspctczTQ2z99o/iEw0wCkALiFTVk9gmFkdudpD7VfaWi
         DWRfweq6acPtZgGQPkg/IOINxafk/+fC2kWKqTMD7fZmVX7vXOMq0CTFUWBYeHgWZ5Wp
         SHBw==
X-Forwarded-Encrypted: i=1; AJvYcCUbWTXIPHbk2MN22UxTbFrlZFYfXb6hxuAet//Q87r4Wdw7fmttgFWo7kynsLyVfXX5Awf3UJMRQg==@kvack.org
X-Gm-Message-State: AOJu0Yz0sq1D9CF3ii9skacCLnJKLE8pp3pWNbkl38NG1U1EAodgLCpj
	+T8aCY4WGbFbqEeGmmN9VrlhLQ6T14Atw35GoK2zovy1QPg4QyHtby95gYUvwQ==
X-Gm-Gg: AZuq6aJ5Mm4ih5k1ojCW8Ipu+tmLzxDXztmbea4lT8Y1d5Yc5ACYJ/+J1I6tczz6L/Y
	/T7EJzLm1yk64YHGi364lo6BIwGH0U9KBq06O8a8jnUAODBfpbwRMdo/rHhsIstaOIKv4roCmW9
	yiNd9etNFzVbI5LThTYOF3IUpl6u02sC/r8/f/Z7UiwONr9mHydKCbLXgotkmh4G6LvnRiPEpON
	hM2ZCNCOKdhh5WYaClW8NsD7deh0+NNixwqFgkBbW5BqU8IdH6gr8J5VTOqn90V3yeW0YKeN+xo
	pIXL0PGLwcjYmpKVfWe7YP+4OvjasTunEKjkMtJ1DDhwl5MzOTBvJZaeYsajraS3NVWu6hG6Lko
	4x1q4jJPirq043lF6CA/1duyvuc0I60T4MkQ5jeff5sIGPi6ENNTzhOHDQoYIJAsm7V1627HUu3
	qJptP7qSET5PDe6eowqk38
X-Received: by 2002:a05:7300:230a:b0:2af:674e:bc73 with SMTP id 5a478bee46e88-2b74274cff4mr1359399eec.7.1769201226027;
        Fri, 23 Jan 2026 12:47:06 -0800 (PST)
Received: from [192.168.4.196] ([73.222.117.172])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b73a691b1esm4476320eec.3.2026.01.23.12.47.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jan 2026 12:47:05 -0800 (PST)
Message-ID: <b90069a3-86b4-4fba-9ff3-fe5f6c4e425d@gmail.com>
Date: Fri, 23 Jan 2026 12:47:02 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH bpf-next v3 09/12] selftests/bpf: Add tests for
 memcg_bpf_ops
To: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau
 <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>,
 Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>,
 John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>,
 Stanislav Fomichev <sdf@fomichev.me>, Hao Luo <haoluo@google.com>,
 Jiri Olsa <jolsa@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Miguel Ojeda <ojeda@kernel.org>,
 Nathan Chancellor <nathan@kernel.org>, Kees Cook <kees@kernel.org>,
 Tejun Heo <tj@kernel.org>, Jeff Xu <jeffxu@chromium.org>, mkoutny@suse.com,
 Jan Hendrik Farr <kernel@jfarr.cc>, Christian Brauner <brauner@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, Brian Gerst <brgerst@gmail.com>,
 Masahiro Yamada <masahiroy@kernel.org>, davem@davemloft.net,
 Jakub Kicinski <kuba@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>,
 Willem de Bruijn <willemb@google.com>, Jason Xing
 <kerneljasonxing@gmail.com>, Paul Chaignon <paul.chaignon@gmail.com>,
 Anton Protopopov <a.s.protopopov@gmail.com>, Amery Hung
 <ameryhung@gmail.com>, Chen Ridong <chenridong@huaweicloud.com>,
 Lance Yang <lance.yang@linux.dev>, Jiayuan Chen <jiayuan.chen@linux.dev>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
 bpf@vger.kernel.org, netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>, Geliang Tang <geliang@kernel.org>
References: <cover.1769157382.git.zhuhui@kylinos.cn>
 <c44accaaaebfc32be13234f82b501a3852ba3f0f.1769157382.git.zhuhui@kylinos.cn>
Content-Language: en-US
From: JP Kobryn <inwardvessel@gmail.com>
In-Reply-To: <c44accaaaebfc32be13234f82b501a3852ba3f0f.1769157382.git.zhuhui@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D214BA0006
X-Rspamd-Server: rspam07
X-Stat-Signature: ibpmegbzgp9okp5bd38kj4cs8d9fm6is
X-HE-Tag: 1769207324-388100
X-HE-Meta: U2FsdGVkX193yZnU95Ue9vMR2caMIBLWTpsr0f5qkHiiGk8u7ebrpYV6ICAYtXNr5QQTccnqwzPQRkQxsbcLwhngxvED6FUSHh7ApIYGJwgbPmv1ePMj/9T1S7duLRqfPbcvU1fUxUPjd213icphsi+W3FNy53sD+HjvEyA/7ALb9pRhCqFbVTFBFiL3KJp8jrhx6570/zKif5KTquGkaGvMPwNxQr/dr1ZG+kZQ9Uz7I43dztFGmCqph0EyVjeJF5nvxMLKfT72c7oWn8OtwRC/8j678S/OZH81dqJIHUMrnCfCvc7L5C4uQbVrCe5VodCYDeSFdiij53o37Aa/U47jBbpDLrViT5ZCk3jscW7hFHj25I4SwnGJHO0gkXvCFCh58EQK50RLSZzvJ6L+aQTl5nkyyzRg8qjv/AUOi1i1xxsuuayTEzB/C1YS1KclRlRHc9e2/SzeQsmnw6rpRNQSmpqzUTsdFUgp6Xzt8vgHMiF4wlZ5M9gMN6Wt+lBYfmJVEPhHkOGeUdVLP4fJUU9hGOzbHBlYjDC407IeQhht1TYAULdqEV2dSC+9Z8cekCGcchQDf6xOnPPyA/t4A0dvQEGsGlcyOxqofolshd1Jd69OKXQBOPEebh96yBJqSfl7ryzEZ/5m+R+evCRriRTHeVO8zUCK6VcnYaqhgJM8RqrfeJ8TXXwh71EOMc1YKL3kaNekhy2yjq6m2RNKTQmI4voXTVx4fMk4Hjyg8TnImgMFNSOsxt5xZnjXfo8o7SC4epFCH6n/1pXDjWSn9qEYSkxYFauGc/U47UsUyk6mWdQD+c94C+9Hkh55uUKxNTwYpuqZRlZfPg9te8kDqExEOS41DMeW2yKp/XcAsOn1jEFqSqE/5hoF3nzBrWrMGI+RWUwP6t2WTWPwrj5HTwfV3bqwIFKV47JR/+aRJ3TBYs3ZWGrgKGCZyMNUTYKSagAf84w6/uNhFmJADio
 KVA3ecD5
 AmtRKi5qpkC1hXsBYxpmJ80Mo0pS923Gux186zOktZ2KiCa8SxOjN6Jq8nD7OcFyQ6dG35/eLzJVNO9YIcjYybH+HbF7Ecj+qMRRnn276SKKWij70JYQuuxFexoC7gbfn4ffkwe3VnSmuarYwApq3jhGnT4gY0RlzxRDVAHlH9QIU5oiHD/QuUnyuRBF1UYsNeNW44BnPDTRnKY3aKgPDcmZ/3s/Bzx/yu4RCi7XLL1aCW7JDK1v9q9c+ZeZC7PaJQc2jgJSIT2hGOU/Z/7kag4ZlGFJdO7OEOn5FBGhtwdKwpOrgfZN0B5frrMHRz2j+dMTYbgGYeXasyWmMD2DhVYXTdOZjgSvksF3eLyCJH2WhCGv0syHtJIES0BchBOq/+07lxXkdStg9BDmYqdatwZH6R0gxsHUr9hegFMJdunLGCJqcrOgQNcxUHP1IcFuzouruiyG5MzG5PcbGMOIfaUoVHLWhyARdC6s0H2Bjyub0H0IagYwXSjIgyqzMSFtjmwUXaJBGn+meXkJndDWCFPYaf0Buc+IjFHaptuot4bOR6fPpY+bs/xSze9Ig2cyevLAo5n018HckYLo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Hui,

On 1/23/26 1:00 AM, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> Add a comprehensive selftest suite for the `memcg_bpf_ops`
> functionality. These tests validate that BPF programs can correctly
> influence memory cgroup throttling behavior by implementing the new
> hooks.
> 
> The test suite is added in `prog_tests/memcg_ops.c` and covers
> several key scenarios:
> 
> 1. `test_memcg_ops_over_high`:
>     Verifies that a BPF program can trigger throttling on a low-priority
>     cgroup by returning a delay from the `get_high_delay_ms` hook when a
>     high-priority cgroup is under pressure.
> 
> 2. `test_memcg_ops_below_low_over_high`:
>     Tests the combination of the `below_low` and `get_high_delay_ms`
>     hooks, ensuring they work together as expected.
> 
> 3. `test_memcg_ops_below_min_over_high`:
>     Validates the interaction between the `below_min` and
>     `get_high_delay_ms` hooks.
> 
> The test framework sets up a cgroup hierarchy with high and low
> priority groups, attaches BPF programs, runs memory-intensive
> workloads, and asserts that the observed throttling (measured by
> workload execution time) matches expectations.
> 
> The BPF program (`progs/memcg_ops.c`) uses a tracepoint on
> `memcg:count_memcg_events` (specifically PGFAULT) to detect memory
> pressure and trigger the appropriate hooks in response. This test
> suite provides essential validation for the new memory control
> mechanisms.
> 
> Signed-off-by: Geliang Tang <geliang@kernel.org>
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
[..]
> diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_ops.c b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
> new file mode 100644
> index 000000000000..9a8d16296f2d
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
> @@ -0,0 +1,537 @@
[..]
> +
> +static void
> +real_test_memcg_ops_child_work(const char *cgroup_path,
> +			       char *data_filename,
> +			       char *time_filename,
> +			       int read_times)
> +{
> +	struct timeval start, end;
> +	double elapsed;
> +	FILE *fp;
> +
> +	if (!ASSERT_OK(join_parent_cgroup(cgroup_path), "join_parent_cgroup"))
> +		goto out;
> +
> +	if (env.verbosity >= VERBOSE_NORMAL)
> +		printf("%s %d begin\n", __func__, getpid());
> +
> +	gettimeofday(&start, NULL);
> +
> +	if (!ASSERT_OK(write_file(data_filename), "write_file"))
> +		goto out;
> +
> +	if (env.verbosity >= VERBOSE_NORMAL)
> +		printf("%s %d write_file done\n", __func__, getpid());
> +
> +	if (!ASSERT_OK(read_file(data_filename, read_times), "read_file"))
> +		goto out;
> +
> +	gettimeofday(&end, NULL);
> +
> +	elapsed = (end.tv_sec - start.tv_sec) +
> +		  (end.tv_usec - start.tv_usec) / 1000000.0;
> +
> +	if (env.verbosity >= VERBOSE_NORMAL)
> +		printf("%s %d end %.6f\n", __func__, getpid(), elapsed);
> +
> +	fp = fopen(time_filename, "w");
> +	if (!ASSERT_OK_PTR(fp, "fopen"))
> +		goto out;
> +	fprintf(fp, "%.6f", elapsed);
> +	fclose(fp);
> +
> +out:
> +	exit(0);
> +}
> +

[..]

> +static void real_test_memcg_ops(int read_times)
> +{
> +	int ret;
> +	char data_file1[] = "/tmp/test_data_XXXXXX";
> +	char data_file2[] = "/tmp/test_data_XXXXXX";
> +	char time_file1[] = "/tmp/test_time_XXXXXX";
> +	char time_file2[] = "/tmp/test_time_XXXXXX";
> +	pid_t pid1, pid2;
> +	double time1, time2;
> +
> +	ret = mkstemp(data_file1);
> +	if (!ASSERT_GT(ret, 0, "mkstemp"))
> +		return;
> +	close(ret);
> +	ret = mkstemp(data_file2);
> +	if (!ASSERT_GT(ret, 0, "mkstemp"))
> +		goto cleanup_data_file1;
> +	close(ret);
> +	ret = mkstemp(time_file1);
> +	if (!ASSERT_GT(ret, 0, "mkstemp"))
> +		goto cleanup_data_file2;
> +	close(ret);
> +	ret = mkstemp(time_file2);
> +	if (!ASSERT_GT(ret, 0, "mkstemp"))
> +		goto cleanup_time_file1;
> +	close(ret);
> +
> +	pid1 = fork();
> +	if (!ASSERT_GE(pid1, 0, "fork"))
> +		goto cleanup;
> +	if (pid1 == 0)
> +		real_test_memcg_ops_child_work(CG_LOW_DIR,
> +					       data_file1,
> +					       time_file1,
> +					       read_times);

Would it be better to call exit() after real_test_memcg_ops_child_work()
instead of within it? This way the fork/exit/wait logic is contained in
the same scope making the lifetimes easier to track. I had to go back
and search for the call to exit() since at a glance this function
appears to proceed to call fork() and waitpid() from within both parent
and child procs (though it really does not).

