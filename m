Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C660D2D8E4
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 10:08:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1EEF6B0092; Tue, 27 Jan 2026 05:08:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA2316B0093; Tue, 27 Jan 2026 05:08:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA44C6B0095; Tue, 27 Jan 2026 05:08:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A9D886B0092
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 05:08:31 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 528B01B0E7C
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:08:31 +0000 (UTC)
X-FDA: 84377319222.26.FD8D71C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id C155D1C0016
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:08:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=O77Lqwib;
	spf=pass (imf21.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769508509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=os8osd3jvx2xfkK+VO61Vv+HBfrsYJdHZDl+6HTfF2w=;
	b=pzv6XvfQ5LY6UQBDh8+vkNdF4HV3vkGiwWm0Yeup6DYiqyziARk82qLrXt9OzmGuDniUHe
	lCrGJt01eiOV2Mq7GDg2Bb9/s+1SRy6uOPKZGzw1kf+lJq+kz2ouIFxWkolp1nNqwk1iDc
	GQKBAJlAldqoyToKLHZuXctQmYvNsC0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769508509; a=rsa-sha256;
	cv=none;
	b=BsjcNq/Ni/EcjyDvwe4bHkMUrxmMIj+mFVlvYGMP8vVGpzxZyCuQezY/zUgUMkuS2t4QaG
	wBnmIPuPeUTq9mOEqwtByZsbdAE9PAThYlwrcKB6jiMDoBwxL/nWczplTWhQbl9vmrRAG8
	8wrR+mBTTKOPO13aMNFl92k14sXD0H4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=O77Lqwib;
	spf=pass (imf21.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B96E160007;
	Tue, 27 Jan 2026 10:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93118C116C6;
	Tue, 27 Jan 2026 10:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769508508;
	bh=eXH7LTpBzt1Nf5PxVt/Zw5NAmsupLUnjjKZooxxdMvw=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=O77LqwibsgbYXv0sPD4MPA6EMA9pdPtxYNvTmdpyBaPZO3JR9RX/r9DQXxVe/yrQT
	 zlfOBASL3XdUncbooj9HoX4VQ0r4dWQfGK1fJCtOOjH8L6Kbu0EkPeF40wAJK65kKk
	 BrHXV23nDTtyCLnyhC8Ht6V+PquWe3ZQ6ueqZ9eIi91cHkd6HfX3WugtNcxzDAYsQM
	 gbg06EV0f5oa32Z3/1n7eXZnQ9KCxAUzcPlGsIKSpLxX1wmSI3IhWlHv6Gqb4aubrT
	 z2jQS0azW95V10FADHw+ibbhTtxXkWyVFhUn2ShVFrIlY9ulYiRMG1smlKXVmaPZuL
	 HGrjvItPTNinQ==
Content-Type: multipart/mixed; boundary="===============4938179612018120319=="
MIME-Version: 1.0
Message-Id: <12bedb9d4fc0676edf3812bfcc8ff7c761286fc6d2e8ae4ca457a6602ec98dfe@mail.kernel.org>
In-Reply-To: <4a1ad099a2db96b92318cb924d2a7b76ee530209.1769506741.git.zhuhui@kylinos.cn>
References: <4a1ad099a2db96b92318cb924d2a7b76ee530209.1769506741.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH bpf-next v5 10/12] mm/bpf: Add BPF_F_ALLOW_OVERRIDE support for memcg_bpf_ops
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
Date: Tue, 27 Jan 2026 10:08:27 +0000 (UTC)
X-Rspamd-Queue-Id: C155D1C0016
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 7qpozcah4swffnnfnqfoqkcbzeqq56ms
X-HE-Tag: 1769508509-321772
X-HE-Meta: U2FsdGVkX1+501P5VPM7rHUZr5WDdK2WfDVaFPU6vI09qJDCd9xvcvU+veVvczhO0oMyEFFp44aVs7Zz8PAK2OLxzdapUWuMLMKFkkDbroZm9T47epzk2XpC5ieK/LSLgh9HbLCURzvCOX6eZ6cYx2LubHsqXShEBKvsR2q0qzMT9erWjusKjzf5cf3YQ5Z+PJQ7FwLLs9bfgsznCNZwDJFE3ECMul3WZtGeckVZ4NpEYY3xGf+wZefa10Mvnn72ouJwEgQTXZVdCp/yQj75RUkNIFaeU1ZbpQj4HIm5I9vPKWT7bIO4GfIGU2o1VADNhCTEQ36xjdp10sslrxbpb5P1wmfgjQwuGszh7mdyamn8l83X8NUYeiER6HyaXOb1hY49qJqAuUWgJru26a4SaO+ZkoXBvHGqdw3cvt/sb1h44BpA3V9QqrIpjlp6Sngt1HvFipDV0nCk8nnHBVDcuEpW5PyL7r/T6UpDanI94GPX+jPU039Jqd6XF2DU1/ED0/5Hdi3HOb0aOtSfbDbsbQRGyq7sneD0WsDg4IG3+rvkNfgMdmt48Q6OVVyTtBZ5LBeczX931jb4ApoD5mxhokjgyV5LwVrRa79se1HjUQW8lj+y7aLuABKF/MTnuzyUpox3suauQNB5pSL7nf0+yxb2JBbFyPdSdoB0w4mQROwWRKK5PvqMjabmqdM20//4kKGVUQSYcoMzl2e4UvJWLtNIYcuvqu1dEvFsJ29A5sZUV5+m61fV7tp7Xrgl+fC2ZCBP0sU0XLRr2AxWtwIK5JSDrZcXa0be3HPKjGIShNGgViTV3rFlcx+HU4Mer99CCbniVd48QpgBqOynkp7C40dJRqUhEJHKYdBaNpdK5oGDQv7U5Ifrk5CKvlnGgxDS6nJRMpcG3HgaOoNYY/Q8c4NH6zn/NijMm9NBkzXZ/5MfyHZH47b7Ti0qgehDOVndXOLwHG4KQyqr/nVrZ/n
 vCo+oSjI
 P6jACfnz8ltm8xJrFrKgt4Wi9jJI10/4PF+NGQOhjzdQNEuSGCTy7+Qq1490o+nYFrBgTfaq5yUiLuwNR5RZCxJbsxEmV8z220togy9C2NXKNAscSnNhsI+3I63FJ8fvLoqGoOl92+Mp7Eax2+9kfPevf3kj6H1uuRXmayiRc4oAex+A7rSOPItz4w57aahZEE/n8LuUs3pcBUX2jm5H/j51IgyfTlxQWYkyz7h0ODRU3bbrLMYlw4MMDTSn9clTt88aLMxkvGZ9lw2FSMNkc8dloc/rROMVuGcLueJxFt1IneLHYgwHwARdbiQ5ResKeWV9lBAokIPzTFWFuowR9Tts89bfJufmG+koO7pXRX5XuLcPgKjfuGbn8bYwFvHiQBcnHZlN1vbJ8ZqVU+sw7nIXiKqXpf9jR/Oko34STk2SJFPzKflxoA7PL5QzQH5T9cn9pXWbBHEfm/f9NTmyDS442bwBc/LLEmJB6J44BFE9u5C5TXsnMugQo+37kVwh+QyV9VCleTrL3drq5mQP+xwuFc8zkN/vBdty0qRwFqoR61dVGM0OP2epr8A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============4938179612018120319==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index e746eb9cbd56..7cd983e350d7 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c

[ ... ]

> static int bpf_memcg_ops_reg(void *kdata, struct bpf_link *link)
> {
> 	struct bpf_struct_ops_link *ops_link
> 		= container_of(link, struct bpf_struct_ops_link, link);
>-	struct memcg_bpf_ops *ops = kdata;
>+	struct memcg_bpf_ops *ops = kdata, *old_ops;
> 	struct mem_cgroup *memcg, *iter = NULL;
> 	int err = 0;

[ ... ]

>+	/* Check for incompatible bpf_ops in descendants. */
> 	while ((iter = mem_cgroup_iter(memcg, iter, NULL))) {
>-		if (READ_ONCE(iter->bpf_ops)) {
>-			mem_cgroup_iter_break(memcg, iter);
>+		struct memcg_bpf_ops *iter_ops = READ_ONCE(iter->bpf_ops);
>+
>+		if (iter_ops && iter_ops != old_ops) {
>+			/* cannot override existing bpf_ops of sub-cgroup. */
> 			err = -EBUSY;
>-			break;
>+			goto unlock_out;
                        ^^^^

It looks like this error path leaks a CSS reference. The original code
called mem_cgroup_iter_break(memcg, iter) before breaking out of the loop,
which releases the CSS reference held on iter. The new code jumps directly
to unlock_out without releasing this reference.

mem_cgroup_iter() acquires a reference on each returned memcg via
css_tryget() in mm/memcontrol.c. When breaking out of the loop early,
mem_cgroup_iter_break() must be called to release that reference.

Should this be:

    if (iter_ops && iter_ops != old_ops) {
        mem_cgroup_iter_break(memcg, iter);
        err = -EBUSY;
        goto unlock_out;
    }

> 		}
>+	}
>+
>+	while ((iter = mem_cgroup_iter(memcg, iter, NULL))) {
> 		WRITE_ONCE(iter->bpf_ops, ops);
>+		iter->bpf_ops_flags = ops_link->flags;
> 	}
>-	if (err)
>-		clean_memcg_bpf_ops(memcg, ops);
>+
>+unlock_out:
> 	cgroup_unlock();

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21392729810

AI-authorship-score: low
AI-authorship-explanation: The commit follows standard kernel documentation patterns without distinctive AI markers.
issues-found: 1
issue-severity-score: medium
issue-severity-explanation: CSS reference leak in error path leads to memcg lifetime issues but does not cause immediate system instability.

--===============4938179612018120319==--

