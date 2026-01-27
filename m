Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D73D1D25924
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 03:08:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 357AE6B009F; Mon, 26 Jan 2026 22:08:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28C9F6B00A0; Mon, 26 Jan 2026 22:08:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 157916B00A1; Mon, 26 Jan 2026 22:08:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EAD9C6B009F
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 22:08:50 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B4A41160B25
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 03:08:50 +0000 (UTC)
X-FDA: 84376261620.01.86C1FD0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 398BB180006
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 03:08:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nCPou7q1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769483329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IL1ZGPLmnMqRmPPU3FmiglwZ4L6/LzsaRAKry3QsGhA=;
	b=L4UUoBuDbN+d9ltBqfcncmGzwT6oOMinEtDccQiwIEAMnJL/p3B7d1RkaHiXIRUhqocjfq
	IpEdqtW0/Du7romByy1l5V7SsnnFrq3tehxL2H/JOOssIwMGda+Tg9q0Hv7bKjhIookXaQ
	Edy9k8Ma2vzVGJ8iFySfgRu2hzXzyQA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769483329; a=rsa-sha256;
	cv=none;
	b=XXGHtkC24h1Sl4vo2+DdCwI9QjC7Yik5Znqdmb7jw5AaCRO+cPeyypW/xdEb2L50dEXHcK
	2V1pD/7vP+WOZE2Cu+BWE4xf3Ily3tszTAGgZi+Ani6HFd0+fKUcl55s2MZc/rf/Uou014
	QrUJMwzkKSCJ3E6nt6R1P2HvBoR0QRw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nCPou7q1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9EEED60097;
	Tue, 27 Jan 2026 03:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086F5C116C6;
	Tue, 27 Jan 2026 03:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769483328;
	bh=a1b2aQXIN/L4Gpj6LgmmhuqN9Jndua/2+iFvK7cxtm4=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=nCPou7q1yCRL/sE6p9zB2mYkYKoj0vOtiQSCMZUm3fqaSOmbkvzp5MFtEgoPU9DMn
	 F/34Yq/g/vvKQMr+MnjGywNw4OK81VMcC+jDZxiYiQqyayzQvDlqNlk6jONjXq3JjN
	 wztf5vgNBxFy3gDSQIRZO7ub0xIuVKa1mBZcaPbxFBUQdNiYXBptO23EDbnUDW2Eno
	 0AFylcn2M7CkjN3vzwYDjwcs2p0V0aCOETMXaDobluGElrW8KA6VAYeh6Yoy4yf4Al
	 I5aGZFdppBptp6WZ34YJlAuBLuxu7U64EkCGejj8pctl8pf+nCOO53kTZPYr0M1Rms
	 N/4FeGmH2o7iA==
Content-Type: multipart/mixed; boundary="===============7709352325939003635=="
MIME-Version: 1.0
Message-Id: <51757d82f7eb33e5988562b54a6c0ae11ae6a4275b2b3150189cdeed2bd96c29@mail.kernel.org>
In-Reply-To: <20260127024421.494929-3-roman.gushchin@linux.dev>
References: <20260127024421.494929-3-roman.gushchin@linux.dev>
Subject: Re: [PATCH bpf-next v3 02/17] bpf: allow attaching struct_ops to cgroups
From: bot+bpf-ci@kernel.org
To: roman.gushchin@linux.dev,bpf@vger.kernel.org
Cc: mhocko@suse.com,ast@kernel.org,mattbobrowski@google.com,shakeel.butt@linux.dev,inwardvessel@gmail.com,linux-kernel@vger.kernel.org,linux-mm@kvack.org,surenb@google.com,hannes@cmpxchg.org,akpm@linux-foundation.org,roman.gushchin@linux.dev,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Tue, 27 Jan 2026 03:08:48 +0000 (UTC)
X-Rspamd-Queue-Id: 398BB180006
X-Stat-Signature: 3jqb3tz6jfwxpkg5xes1wraccyoxcmew
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769483329-598305
X-HE-Meta: U2FsdGVkX1/dquYvjQyTZMnaZT67qpUs6q364DkMaxIuiHwxt303AzHYzSsal6ZSNvr6Ph4GENdeUOffw2Na3Yw25EEnzRjnpkNbl1VUtl86TcKAff/QT1xtuikdvWVpq5x45gv3tEwWzhHCbfJG1C6+dGlq9NdQ48juGsSskIalVr1Oeo59NaVXk9Acf/utnkim4Rgh0FDn1NlH37p9Xi8c4gimud42aw4Yw+ri40dsS2LfF+8Uf2VCi/VF/yUQ37vJHmynqkO6qTBDszzFJSZkFf4+MI0iVDLcXg/doSK1LoyY4FAR3aYgqxZtC6iHoJ6P9LdNm2lAQnQJJ8K16ZmDe8Nnv0Kp5ERqvvMixS9WregL4lV5HQHN4YqxMeZa5xvBIEBdYC9ER5ofgzxjFruUyQKhbPNX6gmvuvKi6SNMynu5vw96d4/nkhzS6BQs32iscHDz3bXb0UbxxboFvdvCgTRce4/XqRoQRK2gpz9sCY56MrNTeiAP4Bz93zv1O5J/za5Yk6OvyBXF1UzcUIyv6wOvSGLhvCUwPZ/8EqfTHg+rlmqoTlHd/km7yC8xp7eqPuuu0TzRdzMJ2GrAmxIJUKbsNjCDYMr964+Y493y1Q/8wcVPYpRWEKuHlUIiNhJ+mHGHwXAqnIW1DmWi6Gmkdamty2zz6dH0Ti0jN1RSshQWSyzFlduBZ4snY85ItsqcT9hzyS1zdkxxiYakIgUl+o3NqTr+D0Fh5KvKKq2gY4UmexeufU7kAoHvPW3kzpaU+hcRZTdJPCTHuH6gxfB9HAIJ1qFGTbFN2fonB9SmwWElEvz6fSq/xX0gdfOkHpDRG6zTskFOBLZtVMqi3EjGUPCrBiRgRmrKzQznbjrRjU0mC9QDnjO0ONnaNMLDaX1po43Y9I/E764zadprO/1BfSwVnVPtOLw5MiGGtbDiCUmSkcae/nKSqvhzdj7wEKlkncvXIzO77KxgCSI
 iELh9JSQ
 tHuJwpGZe1mavZ6w0TchXxFk26V7YJutycYX4U8H16RDqkzN/mAm6EHtRb4m4w+8lovf5Vr+oGN+sSmOMH8hFELTvWR5KY62TlYzRXU1fUlgM2zoCXJ+vGzqgxacAV3Ciecfyn1A7VwzhbQmmISkqlIQJC1vYqOhsBVmp1SrLsoMzgJYYUw9OPx4KJVAk5GAMII3jO3fY4akzRpaL0cpKvGX8vj0TV8qsAr5hQXvv0Wv5t05lX+NTU+xdwh1CRrE4YHwn+etbwjw20JCzaNw+FRLbLv29pHksHG8MkGlqe+9PGbPDmd7UKMNNNc5YVcFuP+6fVqrQq2IB9zn0F+lKcbPfbm7gHUGvzWbh7D88zdJdstO9YgaGN2Dber/w4BtDBSjpRIXwy6YTsOBfIlqUvF1oW1Yevu4ceJOy7dV3NxDGhT0PUUMZQ5O8v0+LEuNW7ET4Yr+pe/gZ+25U2f9ifFjz5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============7709352325939003635==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 69988af44b37..7b1903be6f69 100644

[ ... ]

> @@ -307,12 +308,23 @@ static void cgroup_bpf_release(struct work_struct *work)
>  					       bpf.release_work);
>  	struct bpf_prog_array *old_array;
>  	struct list_head *storages = &cgrp->bpf.storages;
> +	struct bpf_struct_ops_link *st_link, *st_tmp;
>  	struct bpf_cgroup_storage *storage, *stmp;
> +	LIST_HEAD(st_links);
>
>  	unsigned int atype;
>
>  	cgroup_lock();
>
> +	list_splice_init(&cgrp->bpf.struct_ops_links, &st_links);
> +	list_for_each_entry_safe(st_link, st_tmp, &st_links, list) {
> +		st_link->cgroup = NULL;
> +		st_link->cgroup_removed = true;
> +		cgroup_put(cgrp);
> +		if (IS_ERR(bpf_link_inc_not_zero(&st_link->link)))
> +			list_del(&st_link->list);
> +	}

Can this code access st_link after it has been freed?

Once st_link->cgroup is set to NULL, if another CPU concurrently closes
the link FD, bpf_struct_ops_map_link_dealloc() will see st_link->cgroup
as NULL, skip the cgroup_bpf_detach_struct_ops() call, and proceed to
kfree(st_link). Then the bpf_link_inc_not_zero() call here would access
freed memory.

The race window is between setting st_link->cgroup = NULL and calling
bpf_link_inc_not_zero(). During this window:

  CPU 0 (cgroup_bpf_release)     CPU 1 (close link FD)
  ---------------------------    ---------------------
  st_link->cgroup = NULL
                                 bpf_link_put_direct()
                                   bpf_link_free()
                                     bpf_struct_ops_map_link_dealloc()
                                       if (st_link->cgroup) // false
                                       kfree(st_link) // freed!
  bpf_link_inc_not_zero() // use-after-free

Would it be safer to call bpf_link_inc_not_zero() before modifying
st_link fields? That way, if the link is already at refcount zero,
the loop would skip it; otherwise, the held reference would prevent
the concurrent free.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21382620878

AI-authorship-score: low
AI-authorship-explanation: The commit is authored by a known kernel maintainer with a consistent, human-like technical writing style and appropriate kernel development patterns.
issues-found: 1
issue-severity-score: medium
issue-severity-explanation: Use-after-free race condition in cgroup_bpf_release() that can cause kernel crash when link FD is closed concurrently with cgroup deletion.

--===============7709352325939003635==--

