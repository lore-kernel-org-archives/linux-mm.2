Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A802CCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:48:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DBD9800C4; Mon, 27 Oct 2025 19:48:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78C918009B; Mon, 27 Oct 2025 19:48:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67B76800C4; Mon, 27 Oct 2025 19:48:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 535A78009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:48:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE5841402B0
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:48:11 +0000 (UTC)
X-FDA: 84045535182.08.64D24E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 70F8540002
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:48:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ks2vehgv;
	spf=pass (imf04.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761608890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MizWdXyw6AIzxGIrXCjHoooSwVTTTvYHdU7hOQREXMQ=;
	b=NWp+1c1EcUWBBIrBTafIKYJvBQupNyAD5Xe1Maj9bDflvYSZ8xOhp7UJrgHCSYns3vqSh6
	5iUHtSbyTSH8xqNkil4xsbw4SdOV5CAgZ4wVppnnltKtF4Zm6sQD4HMdrB5Ga87WP15ioM
	VlpFhBmHAOs4qaYNCNRxNXRI/xDBncc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ks2vehgv;
	spf=pass (imf04.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761608890; a=rsa-sha256;
	cv=none;
	b=eUjlKuq2LhmI+TlytwZ51pbXD1aa2Az9fHBtSVKWKIW5NU9a8vccXswo/cwWcEqLgusRo9
	P9z2sfv8Mihz6qDL4xgT7N8ohUoQX0P/RPHB8nZZe7U06jiO1I1/1amWaxjJJ4GaBZVurQ
	Cd/j/M+mB66JCSyY1yc+KZFgpuiAhLU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A41E1602FF;
	Mon, 27 Oct 2025 23:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9E1C4CEF1;
	Mon, 27 Oct 2025 23:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761608889;
	bh=mokQ459eH608y3YAxdf7XicrEDOCujpMlCAdC1dG4dE=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=Ks2vehgvD+K331IgMpd34Fj/yzi7Px2UQNNzLRN9tGjZdamoYzPL+4uNqaRDPGMCs
	 Oca4pwYxqbSp2o9sIenB4x9Y5SkrSp/JTqDjCBjBkR8x7S+x79GtVMByn2AwcsyzX1
	 ag9bLXYgIeu5cDFY0NTsMKNUPv/5gvxvWzpJT9AuJZ52qZ4Z4jJpW/Ve5tYoKPjJPh
	 joUnF8BgVQlznUBrfU/m5pu4LOlPKS8B+nt0A0VvrzCGAVbPjtd3cVng33pjME0gEK
	 OzLATd0saTLE4jssY6XaWMCDvGNuw7y31SaR7tsKahBjzCXqut4fR8Fj27X1EA/eZq
	 TYVyLPpK+KgLg==
Content-Type: multipart/mixed; boundary="===============0101190093044867176=="
MIME-Version: 1.0
Message-Id: <0bb955784824863853d84e4b2fa96c81e3a0dd034b1705bbbbc452f8e4dd27b2@mail.kernel.org>
In-Reply-To: <20251027232206.473085-10-roman.gushchin@linux.dev>
References: <20251027232206.473085-10-roman.gushchin@linux.dev>
Subject: Re: [PATCH v2 20/23] sched: psi: implement bpf_psi struct ops
From: bot+bpf-ci@kernel.org
To: roman.gushchin@linux.dev,akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,ast@kernel.org,surenb@google.com,mhocko@kernel.org,shakeel.butt@linux.dev,hannes@cmpxchg.org,andrii@kernel.org,inwardvessel@gmail.com,linux-mm@kvack.org,cgroups@vger.kernel.org,bpf@vger.kernel.org,martin.lau@kernel.org,song@kernel.org,memxor@gmail.com,tj@kernel.org,roman.gushchin@linux.dev,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Mon, 27 Oct 2025 23:48:07 +0000 (UTC)
X-Stat-Signature: fn1yfxykbpoxge6txuz8wcdapnhihaks
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 70F8540002
X-HE-Tag: 1761608890-501871
X-HE-Meta: U2FsdGVkX19RrVGLCbqjz83w/lrYVXC1Ochq1I28G2IrPXWi7/gEWLWDUCG33/gpj+eMctvsmf5lBtdkL5g7cPZ3UZM5cvYkW1dE9G2gsjw8S/zE5HsXMuMhxLRZuT0mf8g1Gl5ZEY9YQ3lxCK9vBFlzwkJ21bvjJK7AH1+gjpZs3Ts2/1e1Leqz1RSObi7lpUUtsY2P5xfEq8N+N45O4vjQGQg1myf5GNudIbIkd5bvx5+lZf/QZgXx9U1KZdC8uJ0LOls2D8XIjZKnv+z4HIApR+2kPrAD2zUhIgU3z9klDjShzQB01Yvx+kv8PtQ+Jo/JwqZsbDSCxoCZA7CHcv+fpwdlvFggTvcKYDi1lagkdhUw1y8sxBaenk+VJz+lxsGnaZL4Bz35kaCwCJUUMR8SUh5ByUQcKf1lnDqluiLRrFRXuYeGc3d6Ax5sPbZZr4qXOUiEX/o3RSMeOk8hafxM+yKZaz6s2xYKNY3/GiN1bZiI7psvmUw6lf0JZw25xYFmzAv+QksMM0yRmt94RLynfu0vfLi267ba5H4tc2fG1YsMH6F0YUHYqcxLQiX8yM/8a9MfttsurBBch58MFvhpeotnem1uaXY/imODQ/JfkTmzJwgBTFn3ZfEI8w/jOuv1jm0ZKPKwMNuA6DzXZ7LgeLRlcCAKdLRt/1TE6D2Ihdt9MvZu6M075FEyXqmmLv9lThKAtOKlOXTB/k0x9YNU8CBjgz0ab1GGXiEUiUAFRbCT1wV/WJDbK3Dxpt4lzxDdAJRNpQXIwQCbRXXRcEsa0ww72uguUARw7jg4L7HI6nU6NXEcqUKR5iRJwrf4HT6jJWsKF8Ugf9xuP22jRhWFRXgRjpvoug8An2XbUcLHfRzyuY11k69kh8ekVUCH0NbGSStXjZ8d8w0WsehW3nY0VWioArJmFfXS6RDwm/huDh5afE21oUPAmF4du1yNlgDSiZm8JYfTy97FERM
 LljoaNI2
 +Zp1Pg3JaN4hhlSZR7x8bSBpUJ2uCC3uiDaLBPXtAJBS1Fk67IEGW6nj6PXPFLKDaZzT/pDTWaq+Vb+XG0VeBnbv3Z+hgF/xSRq7OdEnOZ61tcuZvjXZZv/okyuwMimCutDxPamI6qoNE9ohjwGrTg8/aeXqp1IyiBxmb9uoK1ebcR3INh8zT6wNVmgKlDrxB5K6/mU6Kfr5IrYLEBcRFGjcWNNsQIAc3U7LdWRlppSOeq853sttq/g9Eb8QZRC1v+lVpmJNjZIngJ8pIOe6rgbBz7HtGHDORNB1SZuSZQepU3syt9J2LoWZuaOXGsGuLlyZl/9G2qWcmK83g3EpzyiwwkooWv7pN7vnEXRE8vy4Nm/LZ+/4pBDcABg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============0101190093044867176==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


```
commit 264db34cd79e7c07b4b1e58e2efae3d632df9cb2
Author: Roman Gushchin <roman.gushchin@linux.dev>

sched: psi: implement bpf_psi struct ops

This patch implements a BPF struct ops-based mechanism to create PSI
triggers, attach them to cgroups or system wide and handle PSI events
in BPF.

> diff --git a/kernel/sched/bpf_psi.c b/kernel/sched/bpf_psi.c
> new file mode 100644
> index 000000000..c383a2011
> --- /dev/null
> +++ b/kernel/sched/bpf_psi.c

[ ... ]

> +void bpf_psi_cgroup_offline(struct cgroup *cgroup)
> +{
> +	struct psi_group *group = cgroup->psi;
> +	u64 cgrp_id = cgroup_id(cgroup);
> +	struct psi_trigger *t, *p;
> +	struct bpf_psi *bpf_psi;
> +	LIST_HEAD(to_destroy);
> +	int idx;
> +
> +	if (!group)
> +		return;
> +
> +	spin_lock(&group->bpf_triggers_lock);
> +	list_for_each_entry_safe(t, p, &group->bpf_triggers, bpf_group_node) {
> +		if (!t->pinned) {
> +			t->pinned = true;
> +			list_move(&t->bpf_group_node, &to_destroy);
> +		}
> +	}
> +	spin_unlock(&group->bpf_triggers_lock);
> +
> +	list_for_each_entry_safe(t, p, &to_destroy, bpf_group_node) {
> +		bpf_psi = READ_ONCE(t->bpf_psi);
> +
> +		idx = srcu_read_lock(&bpf_psi->srcu);
> +		if (bpf_psi->ops->handle_cgroup_offline)
> +			bpf_psi->ops->handle_cgroup_offline(bpf_psi, cgrp_id);
> +		srcu_read_unlock(&bpf_psi->srcu, idx);
> +
> +		spin_lock(&bpf_psi->lock);
> +		list_del(&t->bpf_psi_node);
> +		spin_unlock(&bpf_psi->lock);
> +
> +		WRITE_ONCE(t->bpf_psi, NULL);
> +		flush_workqueue(bpf_psi_wq);
> +		synchronize_srcu(&bpf_psi->srcu);
> +		psi_trigger_destroy(t);
> +	}
> +}

Can bpf_psi_cgroup_offline() race with bpf_psi_ops_unreg() and access
freed memory?

Consider this sequence:

Thread A (bpf_psi_cgroup_offline):
  - Pins triggers under group->bpf_triggers_lock
  - Reads bpf_psi = READ_ONCE(t->bpf_psi) outside any lock

Thread B (bpf_psi_ops_unreg):
  - Iterates bpf_psi->triggers, skips pinned triggers
  - Calls synchronize_srcu(&bpf_psi->srcu)
  - Calls kfree(bpf_psi)

Thread A:
  - Tries srcu_read_lock(&bpf_psi->srcu) on freed memory

The pinning mechanism prevents Thread B from NULLing t->bpf_psi when
Thread A has pinned the trigger. However, Thread B unconditionally
frees the bpf_psi object itself even when it didn't process any
triggers because they were all pinned by Thread A.

After Thread A pins all triggers and releases group->bpf_triggers_lock,
Thread B can complete bpf_psi_ops_unreg(), call synchronize_srcu() (no
readers yet), and free bpf_psi. Then Thread A accesses the freed
bpf_psi via srcu_read_lock() and spin_lock().

> +static void bpf_psi_ops_unreg(void *kdata, struct bpf_link *link)
> +{
> +	struct bpf_psi_ops *ops = kdata;
> +	struct bpf_psi *bpf_psi = ops->bpf_psi;
> +	struct psi_trigger *t, *p;
> +	LIST_HEAD(to_destroy);
> +
> +	spin_lock(&bpf_psi->lock);
> +	list_for_each_entry_safe(t, p, &bpf_psi->triggers, bpf_psi_node) {
> +		spin_lock(&t->group->bpf_triggers_lock);
> +		if (!t->pinned) {
> +			t->pinned = true;
> +			list_move(&t->bpf_group_node, &to_destroy);
> +			list_del(&t->bpf_psi_node);
> +
> +			WRITE_ONCE(t->bpf_psi, NULL);
> +		}
> +		spin_unlock(&t->group->bpf_triggers_lock);
> +	}
> +	spin_unlock(&bpf_psi->lock);
> +
> +	flush_workqueue(bpf_psi_wq);
> +	synchronize_srcu(&bpf_psi->srcu);
> +
> +	list_for_each_entry_safe(t, p, &to_destroy, bpf_group_node)
> +		psi_trigger_destroy(t);
> +
> +	if (!list_empty(&bpf_psi->node)) {
> +		mutex_lock(&bpf_psi_lock);
> +		list_del(&bpf_psi->node);
> +		mutex_unlock(&bpf_psi_lock);
> +		static_branch_dec(&bpf_psi_notify_key);
> +	}
> +
> +	cleanup_srcu_struct(&bpf_psi->srcu);
> +	kfree(bpf_psi);
> +}

When bpf_psi_ops_unreg() skips all triggers because they're pinned
(by bpf_psi_cgroup_offline()), does it still free bpf_psi too early?

The to_destroy list will be empty if all triggers were pinned, but
the function still proceeds to cleanup_srcu_struct() and kfree(bpf_psi)
while bpf_psi_cgroup_offline() may be using that bpf_psi pointer.


```

---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

In-Reply-To-Subject: `sched: psi: implement bpf_psi struct ops`
CI run summary: https://github.com/kernel-patches/bpf/actions/runs/18859027430

--===============0101190093044867176==--

