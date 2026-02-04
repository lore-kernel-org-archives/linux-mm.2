Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61735E83EF9
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 09:28:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 638A76B00AA; Wed,  4 Feb 2026 04:28:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54F286B00AB; Wed,  4 Feb 2026 04:28:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 366A46B00AC; Wed,  4 Feb 2026 04:28:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 215B36B00AA
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 04:28:42 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DDFAB13B914
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 09:28:41 +0000 (UTC)
X-FDA: 84406249242.20.FAA90AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5CDED1C000C
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 09:28:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=EzqnLDSc;
	spf=pass (imf21.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770197320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FhUlzDgi50xPCQHtX1H9rEJj6mm4j2++QdB8aofsFl4=;
	b=IOdYFN+zJLSYfOE8rOcVArMrphZIHZLb5kropoaFZHp2ePdhpc+sCXpGIKuYq3VBmAJRSJ
	s/y+jkrKC3Y2E5qXurn1Ijoqf0PmteeLnDZZtJ4nW7y85KrlobS6PsYqghwR+FN4lBrLTt
	eegNfuGe6YOYrZJY/Sc2PB2DlHIsn7s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=EzqnLDSc;
	spf=pass (imf21.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770197320; a=rsa-sha256;
	cv=none;
	b=Bs7jVmF90rp9aRqmA08G9qEuST7EqkeWulZaTI8NMfLorZHZUG4WOZro13oqyLipjlC8AB
	EzDyaRBtWfqA5yV+qTiRZP4F0sT18weRHZirTt2jwF0rQ9HiXxIRn11AWuZVQRGPs8DIR6
	MrrRLDGpVCfsyToanBwyVOA9Jch3yc8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7597844478;
	Wed,  4 Feb 2026 09:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D89DC19422;
	Wed,  4 Feb 2026 09:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770197319;
	bh=hGv/7w//6+bCcJo2PoukH/3G/bRcielsG9LBWTo4Xxs=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=EzqnLDScBdg66jVR9qskXzcwt+V6OKIQknHhwE1F13tcaR/J7Wax2gr1CLNouXDeY
	 Sb6Y2Wd9CC6L47/enfwulnvn7vJ76DSUUYDcfYNqojAtqDNRH3F6M+R52DfTrfp6Hi
	 j8lA2Kx2TMmNSnO0NjHOR4kKSpo3zpPTRmUyxbmDkrO6bDRW71CLRtc/mNYr2qFoGv
	 CMHweO7NFbe5TwniqrilV/mIjfwivrGitu9jS6L27Z5DaBDVqmHzd9ZCvz5NXw5F8O
	 2Jhm/egfVtUizGxtKFz66Uk0g2szjonCTRUALOn2xE4gSA1WVM53b8r5C5LoLcHegX
	 7uIDb5+/PYduQ==
Content-Type: multipart/mixed; boundary="===============2395984818963869282=="
MIME-Version: 1.0
Message-Id: <0044b4c0aa82681725d87d242bc1ce63f5ee3cdd330f0262b042a334688f03e5@mail.kernel.org>
In-Reply-To: <ba2cd1640447097cece1560dd7183bc3db39c57a.1770194182.git.zhuhui@kylinos.cn>
References: <ba2cd1640447097cece1560dd7183bc3db39c57a.1770194182.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH bpf-next v6 07/12] libbpf: Support passing user-defined flags for struct_ops
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
Date: Wed,  4 Feb 2026 09:28:38 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Queue-Id: 5CDED1C000C
X-Rspamd-Server: rspam07
X-Stat-Signature: hmhqcmyqcss5ahhnn8tez8wse598uxk1
X-HE-Tag: 1770197320-539080
X-HE-Meta: U2FsdGVkX188rjjGjkOynI41yUpKKc5e6umec56WGeDEsY1s3gfTXR1RtR4iY3gRawkvypnH8BH8oDaWZNTzMeyQWzNqg7YfsNag1wNmvsp8nyHdjorUCU2EEhJOBazWQ3mFWOGVu/xzRkGsOxHi0byUjWOiehfvNCkVk2/AQxpiB7cT66EYquakuMkCSLM9qsi3f6/dZAOilJPrKoEgnzJ10oyNrm5q6tHflxEq7ramj3qZg5fI8rat7qs81v3xjDD0ZIN+FM7T3zJYS4UD+rsgGr4BbYmdO2DX02kjpDRO6qm8Bs/SndhXQw8FDmQvxoZ1wPP0+u4o++ylLAyXoUXTDe/3ZeFEgjeyZ7AdZTp6dHOuaLJVnjXXUFP3LFkk0Ny6+ARCRLG1oXucD+LkPsccN4tpG8dl6nX9xYz5Yz2wNk+iIYkYqjKvZM7ejbqVVcYFlKB9Lj7zJaUBVRWd73TxKSEhFYwG6G7AK00luLUTAEKReG7+stXrQI8xy1MKjWxhBvAJRNTEWEKJXoHBGKToaoPzmXh+U3QoscLnaUcKnO1a3v81u7HG8rbje9AxiqKXR66CtjdBQGGZn/bBZCtOGd8hdsSKfa0UYjnoP9YGjycHf9yPNajqhwu8crPTjZNoBwk/VsznF3OWOHVM2p1CmeeJTn70mVnvKhUMDJoRu3ge1iS8ZoJyIMKHLXvspIwQ6aEEaymb6N0ZgbNZdpFddTyh0h19zdlZKsH4G2OJXrGnigVaR2VjneJs4iZzgd7i1qs6YwyfUcOzZmWAEPV+ADkyJibLGAE/RDR+B4g4wJjts3EEAj1YW1gG/pBvyY3XyiUSjLFi329QKuD+2IEMNTzrXlSoX1ArwH9put74wFh0g02y6xm+05CrY05xWQkJ5hYPubmg0O8FhOU0TSRjOQfttb6sMedodS/8PJXqKEOOmom3ECut8DEIAlh4udRrSL1F26Pe/y7ZbEu
 U1owBxWf
 4N9TgJ/Vbb2JZzHtbt98d9HQvjGcDhm8LU66cHIVCVQ+Uq9ZTi0FawgSTpspwpnj9vvCxI3h4Jq+6vJwIMnhO2K5ioi+UK1tJHv0oPmw+kc3Wx7ms0mZtOkF9tPlpGiT1ipjO/Yji3lABqIS26N/OP4Z//5ZhYBzCdsx/y7QIWjNaJLkmjEls0lExGJFJOzYvNN+5NKHaynP6fUd1dcQHHk4GH6ZDk747lJJ2G1ij+5N6MhqwvnvDNfx7qg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============2395984818963869282==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> The `bpf_struct_ops_opts` struct is extended with a `flags` member,
> which is then passed to the `bpf_link_create` syscall within
> `bpf_map__attach_struct_ops_opts`.

The commit message states the struct is "extended with a `flags` member", but
the flags field already exists in bpf_struct_ops_opts. It was added in commit
a09c73b18 ("libbpf: introduce bpf_map__attach_struct_ops_opts()"):

    struct bpf_struct_ops_opts {
        size_t sz;
        __u32 flags;
        __u32 relative_fd;
        __u64 expected_revision;
        size_t :0;
    };

This patch adds code to USE the existing flags field, not extend the struct.
Would a message like "Pass the existing flags field from bpf_struct_ops_opts
to bpf_link_create" be more accurate?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21665371660

AI-authorship-score: medium
AI-authorship-explanation: The commit message contains a factual inaccuracy about extending the struct when the field already existed, which could indicate AI-generated text that didn't fully analyze the prior commit in the series.
issues-found: 1
issue-severity-score: low
issue-severity-explanation: The only issue is an inaccurate commit message that claims to extend a struct with a field that already exists; this is a documentation issue, not a code bug.

--===============2395984818963869282==--

