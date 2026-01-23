Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 203B3D72350
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 09:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D94D6B048C; Fri, 23 Jan 2026 04:19:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F8106B048E; Fri, 23 Jan 2026 04:19:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BF1D6B048F; Fri, 23 Jan 2026 04:19:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB0166B048C
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:19:10 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9C2478B0A2
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:19:10 +0000 (UTC)
X-FDA: 84362679660.27.9795F96
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 27143C0008
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:19:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=CobmJcP0;
	spf=pass (imf28.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769159949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SP+DS/4nr4xDKVlm4i/CE2eCEPOLYcWi6JNoNZc9D6k=;
	b=m5faMLjT02NRha9S2zyYByRHoDk1Ov80Asb8JA3wWZGo6SwAFOxuRY9xGEkXyKh67mWcHq
	C8mtSOanlRWDRDat7gzVnX03Ey0iUzpfF6nrC9+NtWEL/K/CxDzZG80bkMxKV1e9GVhTIL
	LRHdgRS15Io0hgvc9GAhPM+TvdX4JdY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769159949; a=rsa-sha256;
	cv=none;
	b=OuiUU/ncumEo+DrVHMvH4PfIEPHGYbW1029xF+leTvl+f9eRa3+ULvxb+bCfhsT9rpKJJm
	8X7QPRxumlTfBdRCXxY7NsSijNpo1UDOz3peDQycqE/zU+OTA3O/P/8crbfDyFTsQeWEqu
	uIB6cnA2suvsxXXeXW/5j6yEFkqLpLA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=CobmJcP0;
	spf=pass (imf28.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AA6096013B;
	Fri, 23 Jan 2026 09:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6A4C4CEF1;
	Fri, 23 Jan 2026 09:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769159948;
	bh=H12UDh2LI6aLgmcHOsAxDY/SKGsGeNOCjHscsd4qfzU=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=CobmJcP0dYaI8MHKuRjINgU6o4ybjdtD/skBYy1WVINmCZGH/jgqb8ez7lXxcnnfL
	 7b8wmFduH+OQHTuBY4MhX5RGK2quSii5I6twltTi2BT6pdkhtMzjTqHTjnSU3i5hoM
	 Sbu5josCT9Tu7c7hqqpqLAUlwxNoOsvaDKGS2iW2EBUXLh+KbDok7zhwMhrKjQ/y4w
	 YfnCEZji+S6hyOBYcFmCEdW9YwU0xujNVeeKEa7W90jUDNPf/p8otTwdTaBHZMlaV4
	 986B1olKGrlwA6B94ODvJGxHRL1WDbV1VQJh5Kr6Vq92MbNIc0xuy28O4vXwAM5xK1
	 DKG8ru1UP/gkA==
Content-Type: multipart/mixed; boundary="===============3584986258708126564=="
MIME-Version: 1.0
Message-Id: <9ab6aaa78c0dcba8b563eab2807eccb0c24bd14fa02d7417cff4284204de7d2d@mail.kernel.org>
In-Reply-To: <c44accaaaebfc32be13234f82b501a3852ba3f0f.1769157382.git.zhuhui@kylinos.cn>
References: <c44accaaaebfc32be13234f82b501a3852ba3f0f.1769157382.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH bpf-next v3 09/12] selftests/bpf: Add tests for memcg_bpf_ops
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
Date: Fri, 23 Jan 2026 09:19:07 +0000 (UTC)
X-Rspamd-Queue-Id: 27143C0008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: kuquaqgr1fxto3ugwfbrbu1b59hrxns4
X-HE-Tag: 1769159949-38684
X-HE-Meta: U2FsdGVkX1+8OgDwdGXFtGuhvzRiiEEV+zVHWz6QZGLzY35GMz4Z+zVdMh7zObDyukMDth4G+UQUUh66qC676hFiV+FF1Wp4ELZnsphkTXOOcOfBhn93tikjl+0PqLiS3MGNZKFnWSCiMxtu4HLKLpYLwED7LXm8dybClzfoqpOJsjP9InD1uUlqbr06kTmlVXHI5xmQq4Lt+mv1r0zpEKg7b6KXEilhJKMY35HGpJQaZLzIyguaiui1nsnMP9j3KYCMjkaR63tZX347IB6juDA+sT0P9fdcpzXQMuoO435S5wDJIQg98DVhoP+Bu3xQqmUlMKW1A/vLnzy6YyMkkBxLZWRdp+6d76ONGLP5MO5b+LMxee5glG5wu7jAHYu/c0QQA302y+Hdaf+neYs6vtcvLxK/AvObJHJd0MlXBE1v6mO+sDibdv96VhdSu44j/pVmqA2DJBUyRRl8p9jOfRcQ7FBCMpi8xfle9Gn0pzn5bwU1ILls/yso4r7LJVkYRqEYzVwGamVtf+f25Bqc5PFf2MDnTW9dmHSCLjhNCLPaQC35RmFinG0B5R4WFT1QRwZHVdqu5BIMwoMKr9wEqKJ5PnTzSGNGWVvntJmPYPJzVhNWejRZDa/fktkw5N6seHw6XYHsglyY9asNjhQ9il66qYBepF6B95zf8n/qAWoFgGD+i0zbea7qh8j9oku5g21FiBPtXnHCOT73Ejlhr4S8/GqD3A4yETKI2z1l81LfOA3SptSFheCdHyMZ4Xhfu2M6j4ANHpawwaK3mqwUXA9l21QHknqfwgNy10jBL5Yu02b5OTSLYLAUIn11UQsjTObRcBKLNMjR9cSKyhlCSZ1ST+txd42VN0/8F9TYqaqpkjyJP0XOfyM2SBi1KpaSRXaj45prW7cMc/ECbl4Kjb4oBqoX3ax6Gt8hGGSL7OED0HAKsbIMye1BoPYkaHrZce1GkZ3lXPq4LQPqPHf
 PVob4PJ4
 pn4QChm7bcSa95nOetlQdMG2kdroaOMPvoT5UNq0s43SjxKrllufcpMHJNYtA/wshK8b0lGVxv1t9OvNe2JSgIlGhH2j52gr45R1Ek9UCCT1SApe8wnQNwjXL4D8xjOwTuUjTfMqM5qn3i7T1uUJ9xHlCPtIt6q3fc0KekycWvFacu/SAW4AtbJBabNeyh6Ip1+MWqRXoM3bGdot5M76VpguuzsnN33rQ5IWtqNhuy9uBz5WZzcAVxtnjncVV5JHGV7UnE244IkC6GttZ70YzpY4LCbljHLI7M4ylq+/g9InwInOQzgwNzPKt6l+L7xJigBSyyCCohthDKB1kOF8DIzzSVcJia6KFfHsKK3mFF88p218cBBo+Ht+bNyZGhnXqCraY4443MzHhSCtX1ixpffFpVLJ9bF8OF2/ilZgbZ4oQj1b7RahJetG83C93J19q8owmPyExLsnymDs676PC3qstHkp5c0kaVgO3Ute7+/2CLfwjBbkGpPgtU7mp+2fy+P3kk3Vjx5hhLCqdUnz5pdLXWZyjKUfle/Ucfl6a8zC6SGC3FO86caC5XmYxXWnRzT3VRl2/C85M02TJ94gWcNVjOQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============3584986258708126564==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_ops.c b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
> new file mode 100644
> index 000000000000..9a8d16296f2d
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c

[ ... ]

> +static void real_test_memcg_ops(int read_times)
> +{
> +	int ret;
> +	char data_file1[] = "/tmp/test_data_XXXXXX";
> +	char data_file2[] = "/tmp/test_data_XXXXXX";
> +	char time_file1[] = "/tmp/test_time_XXXXXX";
> +	char time_file2[] = "/tmp/test_time_XXXXXX";
> +	pid_t pid1, pid2;
> +	double time1, time2;

[ ... ]

> +	pid1 = fork();
> +	if (!ASSERT_GE(pid1, 0, "fork"))
> +		goto cleanup;
> +	if (pid1 == 0)
> +		real_test_memcg_ops_child_work(CG_LOW_DIR,
> +					       data_file1,
> +					       time_file1,
> +					       read_times);
> +
> +	pid2 = fork();
> +	if (!ASSERT_GE(pid1, 0, "fork"))
                       ^^^^

Should this check pid2 instead of pid1?  After assigning pid2 = fork(),
checking pid1 means a failed second fork() would go undetected if the
first fork() succeeded.

> +		goto cleanup;
> +	if (pid2 == 0)
> +		real_test_memcg_ops_child_work(CG_HIGH_DIR,
> +					       data_file2,
> +					       time_file2,
> +					       read_times);

[ ... ]

> +void test_memcg_ops_over_high(void)
> +{
> +	int err, map_fd;
> +	struct memcg_ops *skel;
              ^^^^^^^^^^^^^^^

The skel variable is not initialized to NULL here.  If setup_cgroup()
fails early and jumps to the out label, memcg_ops__detach(skel) would
be called with an uninitialized pointer.

Also, the cleanup path calls memcg_ops__detach() but never calls
memcg_ops__destroy().  Would this leak the skeleton object and its
associated BPF resources?

> +	struct bpf_map *map;
> +	size_t bss_sz;
> +	struct memcg_ops__bss *bss_data;
> +	__u32 key = 0;
> +	struct bpf_program *prog = NULL;
> +	struct bpf_link *link = NULL, *link2 = NULL;
> +	DECLARE_LIBBPF_OPTS(bpf_struct_ops_opts, opts);
> +	int high_cgroup_id, low_cgroup_fd = -1;
> +
> +	err = setup_cgroup(&high_cgroup_id, &low_cgroup_fd, NULL);
> +	if (!ASSERT_OK(err, "setup_cgroup"))
> +		goto out;
> +
> +	skel = memcg_ops__open_and_load();

[ ... ]

> +out:
> +	bpf_link__destroy(link);
> +	bpf_link__destroy(link2);
> +	memcg_ops__detach(skel);
> +	close(low_cgroup_fd);
> +	cleanup_cgroup_environment();
> +}

[ ... ]

> +void test_memcg_ops_below_low_over_high(void)
> +{
> +	int err, map_fd;
> +	struct memcg_ops *skel;

Same issue here - skel is not initialized to NULL.

[ ... ]

> +out:
> +	bpf_link__destroy(link);
> +	bpf_link__destroy(link_high);
> +	bpf_link__destroy(link_low);
> +	memcg_ops__detach(skel);

[ ... ]

> +void test_memcg_ops_below_min_over_high(void)
> +{
> +	int err, map_fd;
> +	struct memcg_ops *skel;

Same issue here as well - skel is not initialized to NULL.

[ ... ]

> +out:
> +	bpf_link__destroy(link);
> +	bpf_link__destroy(link_high);
> +	bpf_link__destroy(link_low);
> +	memcg_ops__detach(skel);
> +	close(high_cgroup_fd);
> +	close(low_cgroup_fd);
> +	cleanup_cgroup_environment();
> +}


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21280790825

--===============3584986258708126564==--

