Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DB84E83EFB
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 09:28:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE1926B008A; Wed,  4 Feb 2026 04:28:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A65526B00A7; Wed,  4 Feb 2026 04:28:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 963E16B00A9; Wed,  4 Feb 2026 04:28:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 855116B008A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 04:28:38 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2E3B11B23AA
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 09:28:38 +0000 (UTC)
X-FDA: 84406249116.15.40453E0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id A433480002
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 09:28:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=Hjvwfcjm;
	spf=pass (imf30.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770197316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=snHywBlaM/Yq2cKSKVWDiGiB0VeX2dXfahmJbW6u3qE=;
	b=VhSw26VaAMx0UHX6tnzxjOfioKlOGF0TtV/1eDhUqk4h/OZbaJfpIMZRa8+uB6/8A9vb8k
	vTY3IRyBOc0jZ70VCC9PMlS/s1TYRmZU6U1xSzM308AAbX9eEwtFg8kGv3tZnx9aegO66y
	kUvqN3+38xzou4QpCWGNHPPnMnKN3us=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770197316; a=rsa-sha256;
	cv=none;
	b=ky2KIjzDWe6GsT4C3bWbpaSKOcXM2AFqBYQtA6SYqevZ9dbelCgJcIfqJNCxchI+NXMcRl
	RJiF4+KwFRa1wGVvEGRGbfQzNtig+zq54X9iPcMuVFYDfEXQr0M2rptgDRQxmacb6UlLwz
	IpQlyy3Qp5klv2GrOpLsuxa0QoBYkSM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=Hjvwfcjm;
	spf=pass (imf30.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 965FA60127;
	Wed,  4 Feb 2026 09:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5783DC4CEF7;
	Wed,  4 Feb 2026 09:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770197315;
	bh=nXEQW0RD3tHANLDk1Vmj8TZU/wOk6Cxie+cPvOqsozU=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=HjvwfcjmVhIG76TDoBvmEmqdCRSO9SYrE7ujdWcl8T2Fu948Ns/o1vn2b3pXaPCIi
	 dee53azAEIroEXCTp5LwyChJEXamfrSxBWAxW7LkivT44ix3z9LxKngbveUSWozvwu
	 OnxqdeQ7esTgXviLu+0qnEdz8h+VbHb0GgGyhln/T4wugwj333JwlXoFykmGyOm3P1
	 f0cAJsTKdNglQfHGqPi4jsZIkKy8mqXw/sxzKaZrNvJt0/NOI6HHLqw3nr03gpklE2
	 0f9ebGS1YJmrKT7/VCAf19xpU6B+dVs73kUGQX+za0W7ETC/DvKEmwyhn/HorIw0dw
	 kRyO2LnWnGdNA==
Content-Type: multipart/mixed; boundary="===============3576808011636229974=="
MIME-Version: 1.0
Message-Id: <958ccd923342ddd02e9122381d51319cb125ec51d601bb6fcad57531a2f5ef57@mail.kernel.org>
In-Reply-To: <031afcd7c16e97f1f3c0d4a8a526a9eee2ad23fd.1770194182.git.zhuhui@kylinos.cn>
References: <031afcd7c16e97f1f3c0d4a8a526a9eee2ad23fd.1770194182.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH bpf-next v6 11/12] selftests/bpf: Add test for memcg_bpf_ops hierarchies
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
Date: Wed,  4 Feb 2026 09:28:34 +0000 (UTC)
X-Rspamd-Queue-Id: A433480002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 8eghooazoxk34mkfjie1x5p1954f4tii
X-HE-Tag: 1770197316-578683
X-HE-Meta: U2FsdGVkX19k43HxFH9Npknd6iNyre9r4eEpAJSsblUZX6ZRR/P8yeKBEf1GGnYKSqCRq2FO+bW1w+O+wjuymXRJfISuSSU1KV2SUfo3fN/Y7h8ik4kbL1dKkTXdX4t7tUSO0S+x+qpDHn06nhI8S6KAXKUOIvNyzvE7oHkReKM2T+Gxn/vknVBW5+6Mt4F1Gcf9fkcM1MMMowq8BylmZepnFI0fJycQAcKwrLZcbf9sebKQ1H/xYd5EGc25KFxFFsQacJQQYJfb9RXojsNuHx4BqRBjkZDiH0CXke8+b7YCaXdxrnIC9Ong645yNoVxsMi3GBo8lxy2m9Bs+ugFy3X7k23+mZ8CsVbPJSMhAhc9ZcZ7zf/A0h1K/YvAkJqq6JOpcIf8hV/MDNwslHZal8OtbJj1ppOk2SJgF6wmo/jDapjESr1x1pxTt54o4I2UeykeLQBSMANiY3msN4c86VmH3gLe+ya/5S2luVcjnMkcdi5okCF45tJ7R5A95N0wfxmOvu0mxiIXJzVTmOTyqngND9cHvmfYkdLN62w3JYlTd4TOZiX3ODAfC9tRdXx285ULDD5XzXcxksee934UlpJnfzlIM9P3F+aTtM/PGbHCFyrwk/B0aPLuYvwr9n7DGWmIr2EuDAIHy3jpmI69Pfq2+GujC01NVZXC55kszUE6gtAb626HGoq2la/ACzWRcOeY8fzkh8vIr739r0Sl5CF7EeubP0nvcJGW6efyHawYszM4d0ArVIG4p9kvNOI5/Kq/9gsj2oY/QgpL8KtWMZVP0M//bEYFEXsMBYU166TDUaaw/S7ev4kDQgAQTJtLfVIhVHpQB06LgRRjew4iOEaF3GIGgQVkvZLz93Ch13I2pDf+q0YXs25UoaRqYJWBB/lLQxwiqutfGxmd23szSn7T2N3MT8UDDPqMatP6O8MVVHErN724HF4TxPCTHraFoXdG3D10hC2p95T333j
 CrWN4gug
 5XQmec31kOaAmZ5YM2H1YeXgMYblf73Rj5rZ6geJrOW7iIohV5QUQUG7GIjcpqCUkOANMjqNTjKabMr25usUx2AvXcBJkQYB3XbvCBiWINp015qL/WYSLEJ8c0hXX3ZDb6h86I/2zeCElgWbLnCIedMJ5MM503Mi312JeeNVsaRdSKbUHotf+wuZM1SDbQOFMNDR+ybkGCnq7dLJSZlfIKBqCTr9DliqC8pZUcq5D4V3b2NKI3qJ53KIJlQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============3576808011636229974==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_ops.c b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
> index 8c787439f..378ee3b3b 100644
> --- a/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
> +++ b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c

[ ... ]

> +void test_memcg_ops_hierarchies(void)
> +{
> +	int ret, first = -1, second = -1, third = -1;
> +	struct memcg_ops *skel = NULL;

[ ... ]

> +cleanup:
> +	bpf_link__destroy(link1);
> +	bpf_link__destroy(link2);
> +	bpf_link__destroy(link3);
> +	memcg_ops__detach(skel);
> +	memcg_ops__destroy(skel);

Can this crash if skel is NULL? Unlike the other tests in this file
which guard these calls with if (skel), this cleanup path calls
memcg_ops__detach() unconditionally. If any of the earlier goto cleanup
paths are taken before memcg_ops__open_and_load() succeeds, skel remains
NULL.

The generated skeleton __detach() function does not have a NULL check:

    static inline void
    %1$s__detach(struct %1$s *obj)
    {
        bpf_object__detach_skeleton(obj->skeleton);
    }

This would dereference NULL when accessing obj->skeleton.

For comparison, test_memcg_ops_over_high(), test_memcg_ops_below_low_over_high(),
and test_memcg_ops_below_min_over_high() in the same file all use:

    if (skel) {
        memcg_ops__detach(skel);
        memcg_ops__destroy(skel);
    }

> +	close(first);
> +	close(second);
> +	close(third);
> +	cleanup_cgroup_environment();
> +}


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21665371660

AI-authorship-score: low
AI-authorship-explanation: The code follows consistent patterns with other tests in the file and uses standard BPF selftest conventions, suggesting human authorship with good domain knowledge.
issues-found: 1
issue-severity-score: low
issue-severity-explanation: NULL pointer dereference crash in selftest cleanup path when cgroup setup fails, affecting test reliability but not production kernel code.

--===============3576808011636229974==--

