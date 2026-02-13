Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3765FEF48DC
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 07:57:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75E166B0089; Fri, 13 Feb 2026 02:57:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E6876B008A; Fri, 13 Feb 2026 02:57:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6119C6B008C; Fri, 13 Feb 2026 02:57:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 554746B0089
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 02:57:00 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F6E713AB76
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 07:57:00 +0000 (UTC)
X-FDA: 84438677400.19.E86DC72
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 84B4C100005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 07:56:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dj0ruJXc;
	spf=pass (imf05.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770969418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nFoa0JQjFRKW3Tj1P1/E+hkKjS17g/yLuJjgvZkA6Ys=;
	b=6YBCXRQVDxnItKIkU0rtmYs3WcuMqZi0gHqUeBHk0QRhA2vNuoO77ESLF68hLk8Le0nbGr
	QxVCye83y5MqTekW63+ExH3EdCxnyg4CjRVoA47lvXePKUt6WFHqCnyxpZiPpc5uVjz/bS
	iy50wVC5Mrq9bLM5wwKBd4pAVbDhMkQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770969418; a=rsa-sha256;
	cv=none;
	b=KlnUI6/VPGFrrLhHXIHOxC7iOCMcpmul76y6iYLCX9+RaBWTK0utz3cW2+GlXrfeaDb49O
	DDAghe1KbqY0h07VcCE6ompa5DLFiOHKyUkhLPBONsbByNMKtK4hAmX2QkKTdJu7wi2sp1
	vrZSRKx5+QBd/hV+CyQKrRXfkMeg9eA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dj0ruJXc;
	spf=pass (imf05.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 76CCB61331;
	Fri, 13 Feb 2026 07:56:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6798C2BC86;
	Fri, 13 Feb 2026 07:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770969417;
	bh=PpQWvYCrQta7omtcLnAeHaRE+LVjwufS1aP9UvbTMQA=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=Dj0ruJXcAKlcq/8kwv/FD7QRg5vxmqV7VF3eF8+UgOpcVkQXVZU57zwM9H6nqivEG
	 fUeDyj6+Fi5MrsHqR5qNpy+eK6N2XXvaNTp2DyP3FUl4ewGkX6+2lHwKHzUqR89e0s
	 bYWQ3DfnyzZstdvVar2Tf8feoi7ySq8bnEQKBUzT8Gj4l2ahDFpyUf1Lm3QLQyfsIu
	 XGKvpRxaHH3qzh2W7I7NjjQN4AcAezIGkmyh0PF/FXP/U/S8QEKZtOutvZzsXwBaEp
	 ZYtioZHBCvbOisz0mgJvGwsu6IR/5zWN4L700WmT58qzu9fDkkbkbyu8DqFQcDxnQG
	 IyFyvuDLLQPvQ==
Content-Type: multipart/mixed; boundary="===============6972505930256429267=="
MIME-Version: 1.0
Message-Id: <1d048c48e087e02590e6943bdfed93db4202f3c600155483cc38cea21e565f8b@mail.kernel.org>
In-Reply-To: <ba61b77c71b6285eefa022a84bf80c5913b313de.1770965805.git.zhuhui@kylinos.cn>
References: <ba61b77c71b6285eefa022a84bf80c5913b313de.1770965805.git.zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next v2 2/3] selftests/bpf: Check bpf_mem_cgroup_page_state return value
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev,hannes@cmpxchg.org,mhocko@kernel.org,roman.gushchin@linux.dev,shakeel.butt@linux.dev,muchun.song@linux.dev,akpm@linux-foundation.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,martin.lau@linux.dev,eddyz87@gmail.com,song@kernel.org,yonghong.song@linux.dev,john.fastabend@gmail.com,kpsingh@kernel.org,sdf@fomichev.me,haoluo@google.com,jolsa@kernel.org,shuah@kernel.org,zhuhui@kylinos.cn,inwardvessel@gmail.com,cgroups@vger.kernel.org,linux-mm@kvack.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,linux-kselftest@vger.kernel.org
Cc: ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Fri, 13 Feb 2026 07:56:56 +0000 (UTC)
X-Rspamd-Queue-Id: 84B4C100005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ikxi4d9ufyp1gpzpcixcs49swm667xk9
X-HE-Tag: 1770969418-22906
X-HE-Meta: U2FsdGVkX1/kWRDMA5DajB7yyWugHSq9MFGVUxLRzFiJpQcYiDbY/ohxkTfoCGKrOCSAxYw4ohOm3A3royr06duhkb4WNaf00GwXq3GzhtJH7bhrMWFu4j8/CCCEI39JmM5wSkvGjpH0uawhXcMc6De9ErMZldGKkfgpcpddiyjgYrmOHNF1UBKsQLWu2+2Huuz3Q0xoQ78EUvqWFQtUfTBF2sWVkOhUmSmWjhklJ+4kCys2+CQoR1JuNNNZQh4qHHBxBO9R4/nvgGcKas59c8myCMUqrJX3LGvMlnUe+21lmk8pOcIXJPcGsC+GvNLbYN/OLDKy2xuiZN67l9fjOSNlB9cldhNMkmGc4wlBUBdNMceVOSZ5nX97Mp5YKHVhrDV6j4cotgZjqjem+7tzRTRGZcsjb2wHy7/J529pnAy2A1LFEl7qdrzUIqBMMf2DvEQc89PCFyzgtWNwKxoRjTYPsCNC2/uPvy+t1qPM7gQH/ksQI20sjK5qpfnGdaBNsLCRhueI/Rcowp39nwg4sOCH0JcukrBaYBZvp+L5Wbu+q0fvzXOIB514ZoOrxEIj8o/hM5sZxjFDiq7zbsVmoMYwVP9/kg1d1vkFVf80jUkeH/zE076TuDhMLH4Bw7L1au2mWZyNok3scukwU/3z4q2d8wM2PezmORx4LCfzM26ndgqAN0UPgJkgLIvsxjIHcEJgoHlxwMzcaAq2VIBwcsFdn6wCZJoshAiGesicxMCanlhc7HoMI70C45GPJKP1XEIgM8RaAhTTjIDVUU9o+RJ5hibYfswqKGNhtzuPDq9oKhw4KYi2InYf6ITHpun+BfRahODxiM7msTgLP4Ft+gHW+Irq7OEvxG62gxmTYstBijC4WaF7IsUAX4yRAQAxzNZ7nF4jS89Kxpo2E4Bdhwg78ZBLDvK5ttyFhPBJAyWdZgLb7usrwbBZUNnQNllZZ3RPYVzRtXP9D3ISAia
 IJEYMIZa
 cps3yNwP2ciPg+tQ2qubsBT9e+qN8L77HfGE15yz3+wnOEJNIDIb2mCHoNcffXhMLSnN1GoBYns9bThuWvGvr7wqbz3KXq+0nwb/bjX412M79qHnHOyLBhfcU2jMlgvCJeBTaiUHJADXq3Tvw7wjfd+pEJt9nhnbl6HT+VjIQvxCNoMc/0yquZpx6xxRoC4AZPcu2A0wAjAUDNH648FEBOU9u/Y57UemRHIBdgCi+j0pdoG9JucQO4x3xDPXyNPfrGm/AKcfuhD55Nn3ky1SPj6O0msZkMhYo/3bQvZcFgxAgzi11Qxbb2WBS0IW+et7p+uvnr6Q1D+TLDIgLBOSE3aZgC61/lv657tFzo3O1BBQOgd99TOAS6S5aC3iuBkDnzIOeIjrzuoLqj6h+LGuyD10fTaCqmqoeaAUGz39MUwhbbDuBdOlcFrHZrxQCt+TsdELbWuk90IyszXLnsuLt1eTNYEjZyW2JE7Tf61xarfIykcfPHf8vjetR5m3DttD+vdEzoRsl6LLR1kBcR6GeMCR4hYx3XzkAqtna
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============6972505930256429267==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
> --- a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
> +++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c

[ ... ]

> @@ -143,6 +151,8 @@ static void test_kmem(struct bpf_link *link, struct memcg_query *memcg_query)
>  	if (!ASSERT_OK(read_stats(link), "read stats"))
>  		goto cleanup;
>
> +	ASSERT_NEQ(memcg_query->memcg_kmem, (unsigned long)-1,
> +		  "bpf_mem_cgroup_vm_events MEMCG_KMEM");

Should this assertion string say "bpf_mem_cgroup_page_state MEMCG_KMEM"
instead?  The BPF program in progs/cgroup_iter_memcg.c populates
memcg_kmem using bpf_mem_cgroup_page_state(), not
bpf_mem_cgroup_vm_events():

    idx = bpf_core_enum_value(enum memcg_stat_item, MEMCG_KMEM);
    ...
    memcg_query.memcg_kmem = bpf_mem_cgroup_page_state(memcg, idx);

> @@ -170,6 +180,8 @@ static void test_pgfault(struct bpf_link *link, struct memcg_query *memcg_query)
>  	if (!ASSERT_OK(read_stats(link), "read stats"))
>  		goto cleanup;
>
> +	ASSERT_NEQ(memcg_query->pgfault, (unsigned long)-1,
> +		  "bpf_mem_cgroup_page_state PGFAULT");

Similarly, should this say "bpf_mem_cgroup_vm_events PGFAULT"?  The BPF
program retrieves pgfault using bpf_mem_cgroup_vm_events():

    idx = bpf_core_enum_value(enum vm_event_item, PGFAULT);
    ...
    memcg_query.pgfault = bpf_mem_cgroup_vm_events(memcg, idx);

It looks like the two assertion description strings for test_kmem and
test_pgfault were swapped.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21978734425

AI-authorship-score: low
AI-authorship-explanation: The commit describes a specific back-porting scenario, and the copy-paste error in swapped assertion strings is characteristic of human authorship.
issues-found: 2
issue-severity-score: low
issue-severity-explanation: Two assertion description strings are swapped between test_kmem and test_pgfault, producing misleading diagnostics on test failure but not affecting test correctness or system stability.

--===============6972505930256429267==--

