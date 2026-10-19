Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A07DCCCF2DA
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 07:24:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6BE36B00C1; Mon, 19 Oct 2026 03:24:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1D456B0162; Mon, 19 Oct 2026 03:24:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A334D6B0164; Mon, 19 Oct 2026 03:24:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 81D0B6B00C1
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 03:24:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 896E840617
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:24:27 +0000 (UTC)
X-FDA: 85338537774.07.3A6393C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 11CCE1C0005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:24:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ggHitl0r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792394666;
	b=YQewBkFbzVwfpkycHRYB5TLTYRNssm8/s5fLXoMLN0MDsgRCxF13P8uYZJ9vXmp4LIlT1D
	Y7GjWqdvUZl7uKwTsXDuX1XW80cJBMeWX1b8NFgQ8Cco1RyD04QHyXBUj2Z3ezLNcOBPbJ
	i0VwJj7v/UkBtaHB7cvuji8HVPmiI8Y=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ggHitl0r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792394666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kq41aEXGRIjZiDj+Lf2TBzLa687IIXYS/7guQvFIns4=;
	b=WmL6CPUaFAdS/rFCaPDlzjurEihiCUnb5QH38gJEykN7FpvTiegICk7k6znMq9c4O9CQwL
	Z3hF/Je4lxYr894WIOZR7XeNze7Kz/nhmUKRyiu7AYBT7ueyBb0gptCuvsX5nt4aRYRa7B
	Iw9tF3izFwBCE89vQMeHp0QslI7kYgA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 81BA7601DB;
	Mon, 19 Oct 2026 07:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8571F000C4;
	Mon, 19 Oct 2026 07:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792394665;
	bh=kq41aEXGRIjZiDj+Lf2TBzLa687IIXYS/7guQvFIns4=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=ggHitl0rXZyzCQCjN2UknQ40BhlbBcTxZG09AcCzpp5wAsA5ho/FiflIfIJ4mEK1y
	 6VS8S7ervff50xPjQk0fgrN1ptCCJzqUQb4SZ4i1g906kHxhuHIKQ40rN8IeTQzjwf
	 MVsTmyF8Y2vfLeUwNqOkpOBkRcpRdwDzG2bgEIZLscXgMxX/uh0/ewXONSUWspaa1t
	 Y259/Soj7mZdinOjIz1my6RleMtKjL0AXnVhlFaUJOBxiJtF8sqhvu+sXCqx2KT7xt
	 8scp6w5vFlgHfAXGfA+HaNLEHeqMJJhjwO+euGG3MNxBR7C2+seS6e2BmGsvdZMBe/
	 fLyvPT46WqT0Q==
Content-Type: multipart/mixed; boundary="===============4963888778798225134=="
MIME-Version: 1.0
Message-Id: <737a8f07246a2cd31950ffcdb2a98b9ee81824c27a362dd17e0ba94e2281b00e@mail.kernel.org>
In-Reply-To: <20261019064157.29885-5-laoar.shao@gmail.com>
References: <20261019064157.29885-5-laoar.shao@gmail.com>
Subject: Re: [RFC PATCH v3 bpf-next 4/5] sched: add BPF-based per-cgroup NUMA balancing mode selection
From: bot+bpf-ci@kernel.org
To: laoar.shao@gmail.com,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,mingo@redhat.com,peterz@infradead.org,juri.lelli@redhat.com,vincent.guittot@linaro.org,akpm@linux-foundation.org,david@kernel.org,gourry@gourry.net,tj@kernel.org,hannes@cmpxchg.org,mkoutny@suse.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,yu.c.chen@intel.com,zhao1.liu@intel.com,tim.c.chen@linux.intel.com,lizhe.67@bytedance.com
Cc: bpf@vger.kernel.org,linux-mm@kvack.org,cgroups@vger.kernel.org,linux-kernel@vger.kernel.org,laoar.shao@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Mon, 19 Oct 2026 07:24:24 +0000 (UTC)
X-Rspamd-Queue-Id: 11CCE1C0005
X-Stat-Signature: 3cighbuhdgt8dupjod559uhqtzzw5f9d
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1792394665-194236
X-HE-Meta: U2FsdGVkX193S0PyV2DbcJksTxuafmrcEqhnH9RpjkXkBG4oLc0YOmY5Uv3Q3+ywdgnYBXFfvixCCSK1MQQzCOQaggeHPVB0gDRtY0xeSQTf73T2E4wm7S3I5u4mwVXkRr4os6vXI6vhIx8/wMoLk73Pr8MKLms4pSjnNossWWBfECFjLLUYwRN/1217LYHxAq7+AeD3qf8TOThXF9Xx1W4qTKrxt4F5Ip+WjqYGscQPkrPTlg0Y/xXwQh/suurGCoJ7/b1b99/ti/3JQfBZO+nWfg/iRGgiVKpfaOQknR6sWgAVkhaw4DjPtvxThhO43bFDgfFDEZn2zb5KyWwuqCcw7Ta1xAAr7ziyZIBxLDox/z8AngwwfDmOEAlfjab/CdPjqxqxePF65e8FAI853OvU7n38Q8MAnD/yvsN8Qi/uvj8NeWeULhWygboaLb57iFm08YEH0+kFkrTDhkkQMTf2OT91ug/w9oWZnTPz6dsiXODILjHqHwPDjF/zk7rHlU4xeY8TOHNDW1bRZO/RN2OBUH+QjQftilHy67Spjs0EuQAQ37pAfLDzJ1qOYdqFmu6ZoXBbf+rg4Ro+mee9OMOTik3IStaHeor+Zrj5IlTlXMlqjNoD26KD34zxIebiqYr3OG8AquLi3D/6OpYOKU0Riq9tMWgXWGxHBvTveA9HVtd0OchY5GaKq4aK3bYMYykbvvM/USU718ji9lhr9sKLiIGlueZMoDOYfW5/ZxEWuEjgKYuyDJfngXAno6JL01ph5AlPQvWffPe9emNLozTQQpiosLnVOIZD74p5zWuPdiQ3T/PMj1VmQsAAlN+BkF+YSY8eO4QJd4j1SdzCuUm6/ztzGqqln11hsXUFmkuoiBZi4D08qyJjRsp4sxqDt/cfOnV68Lzt3b72Eklyy6M5g30wcmoD2eg0fGnRozCCz43Q4+Rkcdq7iTOXJ1GtARa6l9FpXkEXwmjinyb
 bQppmAlH
 HBSVgg4U8qsMd8BGNsIg7WqD6Xneovw5JQxfl10CZvuiSHZ9I5eBTPGYPZj9z2PrPm4YXep4xxSho0qrSjnN2w6vX2wgUvJPLns3Y/jFcBWk7ltEbiklRM82om60RrSyFR1F2zkG4+nMqUhihjrRX6uohOH3UBMcNH//8BqgNXGxEhFMfpAvcbzULgb7TF/PPmTW5B1QzgVNuyU3yRcuRfU7056akONT5uqkfSHyl8ksd+bKnbXZwf2gvsJF9MTJwwpjZZI1TGducOkbNs1tKJHfbURLGDD8twNpdr9XkITnG0v/KkxeyPWIN7NLISIjo1AG/PyJiYhH+OkrAHsCK2D+PcDBMdN1ymVJ9PK5iOuv+QBXV+IQlbt6u3OVyzd/0DLszRwRja+VIc5Jk2dx6IL9ls1yXTMpeiCW42iWIqYYGTjKb3c3u/H4YDHoGEJvNIxMqFcIxgDqzptgzQoLq6IU7sjrpfB+8xfIYfzh5hUSpmpnxrU8cuDJifQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============4963888778798225134==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> sched: add BPF-based per-cgroup NUMA balancing mode selection

TL;DR: Comment only: the comment on task_numab_in_tiering_mode() may describe
the return value backwards, since task_numa_fault() skips non-top-tier
statistics when it returns true.

> diff --git a/include/linux/sched/numa_balancing.h b/include/linux/sched/numa_balancing.h
> index 36de57f7fb06..d63891a8be01 100644
> --- a/include/linux/sched/numa_balancing.h
> +++ b/include/linux/sched/numa_balancing.h

[ ... ]

> @@ -53,6 +95,68 @@ static inline bool numab_in_normal_mode(void)
>  {
>  	return sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL;
>  }
> +
> +/*
> + * Whether @p runs in tiering mode, i.e. whether faults on non-top-tier
> + * memory still feed its NUMA statistics. The requests of the task's
> + * cgroup and of every ancestor are combined; an opt-out wins, otherwise
> + * the bits are read independently, as the sysctl reads them. Without
> + * any request, the global sysctl decides.
> + */
> +static inline bool task_numab_in_tiering_mode(struct task_struct *p)
> +{
> +#ifdef CONFIG_BPF_NUMAB
> +	if (static_branch_unlikely(&numab_cgroup_mode_set)) {
> +		int mode = task_numab_mode(p);
> +
> +		if (mode != NUMAB_FOLLOW_SYSTEM)
> +			return mode & NUMA_BALANCING_MEMORY_TIERING;
> +	}
> +#endif
> +	return numab_in_tiering_mode();
> +}

The comment above task_numab_in_tiering_mode() says it reports "whether
faults on non-top-tier memory still feed its NUMA statistics".  Is that
the right way around?

The only caller, task_numa_fault() in kernel/sched/fair.c, uses it like
this:

	if (!node_is_toptier(mem_node) &&
	    (task_numab_in_tiering_mode(p) || !cpupid_valid(last_cpupid)))
		return;

so a true return makes task_numa_fault() bail out before recording any
statistics for non-top-tier memory.  Should the comment say that faults on
non-top-tier memory are kept out of the task's NUMA statistics instead?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/39213018427
--===============4963888778798225134==--

