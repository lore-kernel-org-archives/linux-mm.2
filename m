Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6347ECCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:57:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE732800CE; Mon, 27 Oct 2025 19:57:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B97E0800C9; Mon, 27 Oct 2025 19:57:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5FC5800CE; Mon, 27 Oct 2025 19:57:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 91E83800C9
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:57:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3D800878CE
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:57:22 +0000 (UTC)
X-FDA: 84045558324.08.D56B59A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id B0B37180002
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:57:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=el+rZW6Y;
	spf=pass (imf16.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761609440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QeSyBG8kEWKojwYn9wZclbA+jrT3h6R68xCbEmNXUvQ=;
	b=m3yb/CvXcDs6pQiQC9c/patU6CaEQmTvyK3TAh/7nG5mGWpz3RV1GnwefDSF1CFDb/+B37
	9Fn8wbU8gfuQzlH+o6VpYdWJsWpaUyNW9m8d/xdb+jV9MnHYNIr+/CMHQOoZq7KMQsNLP8
	OSZJBd3K9WHKPwQ9Bu9KKST9ISypQ40=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=el+rZW6Y;
	spf=pass (imf16.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761609440; a=rsa-sha256;
	cv=none;
	b=MbOAa1AzgRxpUvWYLlOlkQpzssdfr39UGNmL4/BqQ7PH3dWcpfHdAuylgZWMEWAdeFCTM5
	4Y/wiDg/P3I8zG8hPnx5sduiYdsR+jkfzoWW4fi7ajtr1Rc3hak9v1fvtBgdeV7WzRT4AC
	+yMy23Kx4cAqX/hpbewEahU31UjII4Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 95B1843817;
	Mon, 27 Oct 2025 23:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD325C4CEF1;
	Mon, 27 Oct 2025 23:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761609439;
	bh=hHcSm05XIBBgOwCK09Y1TkRueDxudZm+Q2Tyf5+OBPs=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=el+rZW6YqdjguTckqMm+T3D5I6sRSJ8xSvE0a+JkE+h/lOLW6oWVRVnLsS7RtSsnm
	 pgXzeawehSw76pOhKlUKPjIQyqaw8DYGm9rv+r+3/1OytvT23lHy5GnTLPHh0nr/wV
	 /Oz2t4eG4ujYjfVPTyHllGTs+dGVdTe90QznEkEp6TxttLKf82VjA3A7+oPmOi7qKv
	 ASU7WmwBtdF3fQvraeecaEkD5fTaz1Xtwso6lyOcb4x+JQF31Ic2WAtQmvr7G7DjV5
	 hnKWQIpQUmLHM8yLvJ1fLJBI76a9GoZhX39bwNlBcVnj8YOkwd15Tzp+n6c/h8InHJ
	 d3Chi/NEyYjLA==
Content-Type: multipart/mixed; boundary="===============5183752388224874090=="
MIME-Version: 1.0
Message-Id: <29c2837ee641cb1cb0ce3bbdd3a597d9488c04eb838ffe19902c9461a4d282a2@mail.kernel.org>
In-Reply-To: <20251027231727.472628-7-roman.gushchin@linux.dev>
References: <20251027231727.472628-7-roman.gushchin@linux.dev>
Subject: Re: [PATCH v2 06/23] mm: introduce BPF struct ops for OOM handling
From: bot+bpf-ci@kernel.org
To: roman.gushchin@linux.dev,akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,ast@kernel.org,surenb@google.com,mhocko@kernel.org,shakeel.butt@linux.dev,hannes@cmpxchg.org,andrii@kernel.org,inwardvessel@gmail.com,linux-mm@kvack.org,cgroups@vger.kernel.org,bpf@vger.kernel.org,martin.lau@kernel.org,song@kernel.org,memxor@gmail.com,tj@kernel.org,roman.gushchin@linux.dev,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Mon, 27 Oct 2025 23:57:17 +0000 (UTC)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B0B37180002
X-Stat-Signature: 6npa89eibdajj8gdbsydjp6tjsy5qfgr
X-Rspam-User: 
X-HE-Tag: 1761609440-28978
X-HE-Meta: U2FsdGVkX1+IoJiEb4rsYiBBMRUgLc3kN5H2j3gfmdAHHRHd8ZFCu+jjZ7E4Se3Rx1woKpnzIajjxOM6y1sxKvB2mmFoJFZUg+aLhl7StnX4/a/xmKbLbNSdEf4bwrPzNEmSf1lvSEvtwM6ISToATtaQ/iAZmoCn5u81YDYVWZHjLSEEQdYhHRrtfXkkwrhri22zEPh1kHVHVXn3PWHMsCPlckVPYRYbkhpujNc6l7EzD3BBfiayUr57kRT30V4Mv4BUydebfSVJoutSTvotCEOhPylXkJg82wwzkJH3PJ7/Qgo5/mkEE+UIwo9X5Gb9PXnhoT8LoMZyrlO2DTp3gPjOkojI1faEvj3+w/mIbYjApH4fE+29Ol3iPobLxDdbRoex2USnUAwmPgaoCApctyp75Qg+pZAHXbielwByN6nqL+NGW2Bi/yW1BOnkMRvCW7QGE2ZfW/SRAbygbJLPnuzGBn/Xf2i6mB1Pk0kpb05/66U/FiDDbTDCuXCVtgRFF3nMQW86bq70TMGG+6cAa/5F8zw6vQ5zoyiENfp4ostM6eJIdbbKBcos5m4iGV/IeMJ2hwu7AgF/+zaw1lL5pPnnSJI8wuGWeP6RMHVeFNSH8xQ00yxC5J6uXuRxFgjJWdNf9baRK0mpReneKm4DJ78zFxKlJKP0YKDE8Q0x4BqCkIa6q4mF3ESQJiHKS5jaStnayEzjf1JvkJblcFfqzqjZyEOpm4VYrTZvJPrH4Namd7YG91HcOMqxZySwuGCOnVAXF2XUucRofMhK9MkgTWdVIwcio640x9dVXSTnYpx+p3STJgcr4fgAdGOWBWNQuToEtEWE6sbOQ7BkUCl7r8mSiWAONsAvmfD0CCMmXvnvRsVUKhuLllR4tge+f7r04vbBw4lJTe8uZOpNNL0mzB90/1IOo5U9CUWiEUqGS0hbG+DBtycGTtRaZpu5TisPU5VX1Qi1PMBhWvdnLfJ
 tIxUqhx/
 3YjFrKh3PcSu68+m+3Q3mJZTzwYRnEeIJTxdAcc0lZwJXe7Sl1qoix95azVeMW4hMt/qm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============5183752388224874090==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


```
commit 16c40fd36bbe32c63f44388b5613db55c6b27557
Author: Roman Gushchin <roman.gushchin@linux.dev>

mm: introduce BPF struct ops for OOM handling

This patch introduces a BPF struct ops mechanism for custom OOM handling
policies. It allows attaching bpf_oom_ops system-wide or per-memcg, with
handlers executed before the kernel OOM killer.

> diff --git a/mm/bpf_oom.c b/mm/bpf_oom.c
> new file mode 100644
> index 000000000..c4d09ed9d
> --- /dev/null
> +++ b/mm/bpf_oom.c

[ ... ]

> @@ -0,0 +1,272 @@

[ ... ]

> +static void bpf_oom_ops_unreg(void *kdata, struct bpf_link *link)
> +{
> +	struct bpf_struct_ops_link *ops_link = container_of(link, struct bpf_struct_ops_link, link);
> +	struct bpf_oom_ops **bpf_oom_ops_ptr = NULL;
> +	struct bpf_oom_ops *bpf_oom_ops = kdata;
> +	struct mem_cgroup *memcg = NULL;
> +
> +	if (IS_ENABLED(CONFIG_MEMCG) && ops_link->cgroup_id) {
> +		/* Detach from a memory cgroup? */
> +		memcg = mem_cgroup_get_from_ino(ops_link->cgroup_id);
> +		if (IS_ERR_OR_NULL(memcg))
> +			goto exit;
> +		bpf_oom_ops_ptr = bpf_oom_memcg_ops_ptr(memcg);
> +	} else {
> +		/* System-wide OOM handler */
> +		bpf_oom_ops_ptr = &system_bpf_oom;
> +	}
> +
> +	/* Hide bpf_oom_ops from new callers */
> +	if (!WARN_ON(READ_ONCE(*bpf_oom_ops_ptr) != bpf_oom_ops))
> +		WRITE_ONCE(*bpf_oom_ops_ptr, NULL);
> +
> +	mem_cgroup_put(memcg);
> +
> +exit:
> +	/* Release bpf_oom_ops after a srcu grace period */
> +	synchronize_srcu(&bpf_oom_srcu);
> +}
> +
> +#ifdef CONFIG_MEMCG
> +void bpf_oom_memcg_offline(struct mem_cgroup *memcg)
> +{
> +	struct bpf_oom_ops *bpf_oom_ops;
> +	struct bpf_oom_ctx exec_ctx;
> +	u64 cgrp_id;
> +	int idx;
> +
> +	/* All bpf_oom_ops structures are protected using bpf_oom_srcu */
> +	idx = srcu_read_lock(&bpf_oom_srcu);
> +
> +	bpf_oom_ops = READ_ONCE(memcg->bpf_oom);
> +	WRITE_ONCE(memcg->bpf_oom, NULL);

Can bpf_oom_ops_unreg() race with bpf_oom_memcg_offline()? If userspace
closes the BPF struct ops link FD while or after the cgroup is being
deleted, both functions could run concurrently on the same memcg:

  Thread 1 (unreg):                Thread 2 (offline):
  mem_cgroup_get_from_ino()
  [succeeds, cgroup exists]
                                   srcu_read_lock()
                                   READ_ONCE(memcg->bpf_oom) [gets ops]
                                   WRITE_ONCE(memcg->bpf_oom, NULL)
  READ_ONCE(*bpf_oom_ops_ptr)
  [sees NULL]
  WARN_ON() triggers

The WARN_ON in bpf_oom_ops_unreg() assumes *bpf_oom_ops_ptr matches
bpf_oom_ops, but bpf_oom_memcg_offline() can clear it first during
concurrent execution.

> +
> +	if (bpf_oom_ops && bpf_oom_ops->handle_cgroup_offline) {
> +		cgrp_id = cgroup_id(memcg->css.cgroup);
> +		exec_ctx.cgroup_id = cgrp_id;
> +		bpf_oom_ops->handle_cgroup_offline(&exec_ctx, cgrp_id);
> +	}
> +
> +	srcu_read_unlock(&bpf_oom_srcu, idx);
> +}
> +#endif /* CONFIG_MEMCG */

[ ... ]


```

---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

In-Reply-To-Subject: `mm: introduce BPF struct ops for OOM handling`
CI run summary: https://github.com/kernel-patches/bpf/actions/runs/18859027430

--===============5183752388224874090==--

