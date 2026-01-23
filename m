Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 675F9D72350
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 09:19:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7DA6B0484; Fri, 23 Jan 2026 04:19:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6BF36B0486; Fri, 23 Jan 2026 04:19:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6A2F6B0487; Fri, 23 Jan 2026 04:19:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 95D9B6B0484
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:19:01 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3D3EFD1C0D
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:19:01 +0000 (UTC)
X-FDA: 84362679282.22.4513F78
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id B4A5B40008
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:18:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=o4KhXs3I;
	spf=pass (imf01.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769159939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OETZr2NC1UUrjp+T1vOTILUUr/l1ziip7WrmKK5bNo4=;
	b=aX+y1JlMB4g38uy2iKbglSHWsBFnuG3itBq7ZRdteX3a0V0RA9gTZZP6kRo5Dr+s8h43mr
	9JRZvfjlBYDVg19W4IfmOkY1xLqbQNM1/E3ZQtBzmKeUd/INZ5O5kRH2uDHwLTh9xOBgpT
	VjCrEaVIxm+pFKVkFl2EI8lJX/ybchk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=o4KhXs3I;
	spf=pass (imf01.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769159939; a=rsa-sha256;
	cv=none;
	b=D+CJKJS4oMdZMWyL/dze9i6J/8Sq09WV3pxvg8eSd3AcupetX8RIucyYDb9kp6ytnbziX1
	8CNZWeOzJgPlMc7J9fLdnQHUads3y21sR39ECZr+TZQn+22dg1YwL6MN4vzfdO+LN+JM8c
	UnCa02Er/+U+SEr+SSbXgbBOhcofVto=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2746260054;
	Fri, 23 Jan 2026 09:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00317C4CEF1;
	Fri, 23 Jan 2026 09:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769159938;
	bh=Yj/0342sqfLBIPiqehTF1fNxuPJu6F+hRc2WRAQWcuA=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=o4KhXs3IAcxW1VHcGUecCF0/Sd7ez/fIAyJCNmpzuKqaaLt4qW5en1ElzlA4OJbJE
	 +aAmUlTDGNVZI3jZkb0+DXyxqDTqjDszWBJkqewICLJTj+zHBVzoi9gvNjnAO70BXW
	 1HCZfTQjLTUqc5WZxtjXU7kD8RoGWCHn6oO/Ps6Luo2dj1GLKwuDboFQTpqeRHCVRA
	 BfEt6HkYtr+gh1Qj6OUQR72ELqo3q+KUOkC53xoZBwbwYtGkq87mmerADXL4iK4QJR
	 lT8eojQQ5dLFc8JseAMWYZuwuqcHgi1o1QsY82a6qbTcmTfJfmAmXonS2Oe2VrsA1f
	 crOk4bVvC5+Lw==
Content-Type: multipart/mixed; boundary="===============1550164231886997435=="
MIME-Version: 1.0
Message-Id: <806d3538bf542f23b9b89c35199996f195e82b2cdde50c40ca8478cbbe6af3fb@mail.kernel.org>
In-Reply-To: <db8b80a445a61b437c35c71ec2edb573002656fc.1769157382.git.zhuhui@kylinos.cn>
References: <db8b80a445a61b437c35c71ec2edb573002656fc.1769157382.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH bpf-next v3 11/12] selftests/bpf: Add test for memcg_bpf_ops hierarchies
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
Date: Fri, 23 Jan 2026 09:18:57 +0000 (UTC)
X-Stat-Signature: cqa4hzixzkyue9u544ze85qtz5o6381z
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B4A5B40008
X-HE-Tag: 1769159939-370195
X-HE-Meta: U2FsdGVkX1+X6sxav4D4fsYbCiMlGas2O7djxu/escY4iDw4FgAbpV9Bduu+/PkBEMkB/JnINeNas/JBJaZlBNSvTdhOKV3DYZ9ULhWi6fx3DKG4PBagGwuCVP0CiBgFHwH88j/G063NIXVVD0KKaOjxjC2HpkWyycragUuEG8x87n131Y6mn0KPwVHg3PeUp8koziH/whaTMzFsCycx/+domUbtIWLncK1Ehav85Nvje7qNMc+bpnwxRcKV/Av1+2RRjAHWYV4aq6v35qLdo+QYaGoAKmAvW+1OVGFfX/E4SXLnBfVLOvuP8Yu0otPcHfiabIWx6WuNgHNREfzXdLZjmx9ywmLZuUax4g6xvUmbPHq5iw4pQZcmXEybAR98G3oQ+YkSIVCgDspisLpEwaxBGV8gAeylUXtLES/LRyWrU7YlXIegW5XkL8ZTXAB5ThvjcZYPkJMoIBPpS9w7JJ9ITx1tZXKQVtPRW3o465bDnS0oOG65Nw0YleAqlG1TiJWM6awuzIC1UttTjxg1LwLTWFPzEoenh81+uQLq32lH2FEXfdV5OeQe0+lhZ8CoDHuZJFNw8SFXIBV8K3QOKrGXeWMK0dKNJ2kB9l8iTZYa6dpZqp708T58MAUW6OSz5Oom+7FlV/UKdc51t0EWAu+CReaZ0S/5LONRo8OS4jmlt6/cA3Bv1fusp3Sms9y27lsQ2R6dTtSu0kPfE3XwUUsiZTNGVUEtSC2nWzW0OiWCl5g42rpbjYuf0RVbUSB9DM1Ef0VAECcsYtw4zmIbJ/y1kMG7Cn6NDloG8C4rl9osqdq1ow3/5DJC6tLBwdHUVwsdRSF6EZz0jV+4WJWjCeObVTF9TbnuRCiGPZ0/5EYGeXKQVkFh76pCI4yCNVnafpLB1WnISx1wvxzm8JYR195bjntAcz9w0Iv8VcPIbJSrrc3ny91n3IvXkdQyMcfEEJiz04KRbzyCV9jr4eb
 ppNa0udn
 XukcUNjJf5wIW2vB2osKsJcBtuw/4eQiziT4Qoe9NALxkvJ3kGd7fprXJdbTXfghTddUGXVuhLJnwV7om2TKkP97tIRQLi2xHHc6iJvQ4sTvJItl0sb99ABXAqPSoZkNarYgqHHtEBDbR7VFiBXXnDbv5PxyVZHoF+KXZ94aQ2K3ViXzLgBNADoceIjUMReqUcQULbVNF2290XuXsJrh4rnUSafRyxwNNId4/MAR0H2bAIXtredwJs7hjg5JHhOb1UDySYiKNezbikvC5lorKGzlQG6RG9aaaRku2KiAIPC3gsXr/bg2KkQpBUBR1joV3fy+HtkogmX/m5COFKPIL6AgX7rrbwfYZvDgXSXFsjcCyHD1/PVIpQsq7ARY3A/zIJtQ+NjT0yR3nI0i5pIJ6uyy8LE2gdRlyog1r4+eYFaTp8Kqkm2KY4KAwKSWjwUHjSzmC/6oCJj0poEXvOXlIdaHpqIhb4iYodGKhXKcL7RFOmNqSSuFIn2/sruhbWQwkbmUHvz5sWr4dI1cpKcUG2pBt3rqsUdUTY5zz2aDgSP2/jf5K+AtdbaykA8C9wSciELUd7Mc2Pf498LJZBoIthHjL2Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============1550164231886997435==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_ops.c b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
> index 9a8d16296f2d..bab9f3094f59 100644
> --- a/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
> +++ b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c

[ ... ]

> +void test_memcg_ops_hierarchies(void)
> +{
> +	int ret, first = -1, second = -1, third = -1;
> +	struct memcg_ops *skel;
> +	struct bpf_map *map;
> +	struct bpf_link *link1 = NULL, *link2 = NULL, *link3 = NULL;

[ ... ]

> +	opts.relative_fd = second;
> +	opts.flags = 0;
> +	link2 = bpf_map__attach_struct_ops_opts(map, &opts);
> +	if (!ASSERT_OK_PTR(link2, "bpf_map__attach_struct_ops_opts"))
> +		goto cleanup;
> +
> +	opts.relative_fd = third;
> +	opts.flags = 0;
> +	link2 = bpf_map__attach_struct_ops_opts(map, &opts);
> +	if (!ASSERT_ERR_PTR(link3, "bpf_map__attach_struct_ops_opts"))
                          ^^^^^

The result of the third bpf_map__attach_struct_ops_opts() call is stored in
link2, but the assertion checks link3. Since link3 is initialized to NULL
and never modified, the ASSERT_ERR_PTR check does not validate the actual
return value of the third attachment.

Should this be assigning to link3 instead of link2?

> +		goto cleanup;
> +
> +cleanup:
> +	bpf_link__destroy(link1);
> +	bpf_link__destroy(link2);

If the fix is to use link3 for the third attachment result, should
bpf_link__destroy(link3) be added here as well?

> +	memcg_ops__detach(skel);
> +	close(first);
> +	close(second);
> +	close(third);
> +	cleanup_cgroup_environment();
> +}


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21280790825

--===============1550164231886997435==--

