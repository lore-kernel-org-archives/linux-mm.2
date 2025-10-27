Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24A96CCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82C66800CB; Mon, 27 Oct 2025 19:48:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DB02800C9; Mon, 27 Oct 2025 19:48:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CB33800CB; Mon, 27 Oct 2025 19:48:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 593D3800C9
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:48:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 077E81602B0
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:48:36 +0000 (UTC)
X-FDA: 84045536232.05.A777F7E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 882344000E
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:48:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tPRqOgu4;
	spf=pass (imf04.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761608914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2z5GzmvfqBkg+Yy4CBfp0CnXLe754haiYhMjuxco5fs=;
	b=RykA137fEEORY3b9c2v9lLZvP3Q8L3XBoMkcqSuvtQYdf/9Nnyt6ezSOyqReV9FrTweyQn
	VuHX3GiNmMvkXQsbRnPyjaMzjThgC2y0E7kHfWFpDuDfG1ejmwoheDxgaBowBKQRtQ6nYX
	Di72Y6ldlcAYrXoAA2hIEUav2JwT0bk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tPRqOgu4;
	spf=pass (imf04.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761608914; a=rsa-sha256;
	cv=none;
	b=7vIN3t4OcC9WP1+pKxcbLqz4ZAHWCmL2+u8zOSThJhhQGVOmelDBlyhpW4QJJnjsDvCB/j
	ELQ4A4JSNooXVPdkPUTdSqAaq+1DL1/njwsLrRAf08NuDIE3XP6NmCS6ZUcv2wowEkrgqI
	1EqiUcGLks5gxVhODk1A8Aqq7pGxAi8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E0E861353;
	Mon, 27 Oct 2025 23:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9EDC4CEFB;
	Mon, 27 Oct 2025 23:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761608913;
	bh=MiWeawgOpWW6lFOdqjirFo9YOvPI6E0zLgwWGg50DDU=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=tPRqOgu4RIvS+PCuXstq77PKbJCcZTI5NDGeUb2Ri6lQh9+Zg3OhtXbV36KT4GCDC
	 ZNXIX9KzTgnDmyCGDDRkhZR+HYPVAESYhT3w6XI6XJYTe/V5rmNE/9NV3z7nmICRaQ
	 hd0GVprCC4Jqh2NlnYyueau1DcA9bs5cyaY1JQbrFTBz/AYYlF9vqVue2TxqAG0wSr
	 ahmjwEfUtuwg+BPY+Z78MJJ+DvmKtM1HFGuCVj3whDLBfzvOrk6GGAA/L3EA0s5Ut4
	 +gzR9uDjRpC/PYPl8QhE73UxPDRgzvXLpNP2C1Zvqu3BRF6b3A9N6UgrSMybY/wvpP
	 BToA8bGIghCjg==
Content-Type: multipart/mixed; boundary="===============5262190113094449615=="
MIME-Version: 1.0
Message-Id: <634e7371353c8466b3d0fa0dd7ceeaf17c8c4d7b274f4f7369d3094d22872cd6@mail.kernel.org>
In-Reply-To: <20251027232206.473085-4-roman.gushchin@linux.dev>
References: <20251027232206.473085-4-roman.gushchin@linux.dev>
Subject: Re: [PATCH v2 14/23] mm: allow specifying custom oom constraint for BPF triggers
From: bot+bpf-ci@kernel.org
To: roman.gushchin@linux.dev,akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,ast@kernel.org,surenb@google.com,mhocko@kernel.org,shakeel.butt@linux.dev,hannes@cmpxchg.org,andrii@kernel.org,inwardvessel@gmail.com,linux-mm@kvack.org,cgroups@vger.kernel.org,bpf@vger.kernel.org,martin.lau@kernel.org,song@kernel.org,memxor@gmail.com,tj@kernel.org,roman.gushchin@linux.dev,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Mon, 27 Oct 2025 23:48:32 +0000 (UTC)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 882344000E
X-Stat-Signature: jjnqpx79kijh4onohush9rxiq9jjykwt
X-Rspam-User: 
X-HE-Tag: 1761608914-19589
X-HE-Meta: U2FsdGVkX1+ZS3bGsk0kcITPRlHWs24h5IQsCVWLvq2NP8U6FqLGRTlWNoAVH0mBRolGfDoOHJNh5NbReINlDP2AV8T5/5l/mh/cTjY57T8QsYSH4XVIBKMErejXHH2GlBskFQDBKwBhJ0C5udWBbL7SdotKcC0kJJX3Gxpi9ajhDgbmg5PNq4fbhSHn2dWDdrpkxNSWWnJnAq2ohIBvx8GLefnPUTvtDYey+Vh0+oBDUZPToqhxVae82L5vyI3KROISDTZZJbeti5t5+UUFjTOqbQZjhf6Upns6gqM0igqzR4RRSBI5PdciWO0OvYI/lwVWrYIK+ugCPcHEAzWPJm/+7edwdqY7rMwPI3qLsiRUmdwRRyojy6gHygY0X9yQIqhYuT+iZ5Gn4BC8mhGBH2uhiO3wLqV1e2rPfJQvsxW1DJ/XQpgPeQd1EEM4RX4k8E/mkkpO8PCXqf6vQyuxCFKp4DiLq5pNfD7e6sHtfQo6iTvwsy8CDOLRMlTrxqSIFVf7Xwm0C27XQU2yZcamDYCFDLQOABATcMlupnn/Kk2wx+22c7KUjNZSRB32GCdJwha4Nok6OO+VlzfvWsvzpS3PH2vI2i6pAhV8p4WX+Y/FHau959N2uyKDxxdTCXRpqnUhO0q+L1vr9GGn2sfnHVXbujRXxbfVr982MbyMJD8V4nGjrf/pVcfs+m1Qc1BySL/JjOeVs/F7exsHfD5axBEqOgEiN1daKGRCZCGVXBP16sxdPZ+oohSyceS99e+rpJeRw9M07a0yJLDNEtq5bYSRstdUPnzxt1qm0/IfYjpGJcL1jCClaCDId/FvdB5r8ZUtYksz7TaTVy2uzPXT1BIzrMt7dm7OfnC5a9MQijqQVuGS+7m39NMuPJTeK8Dk5MbnTVJCSbVxFE8qFXsPUwzcn75oXsHsmTXb4XwQVOzQaoU/RaFmAahINu/fCPuREwbW+I4a5cLRm6aMCth
 YrnUkp/L
 8Ley/ITIrOrcOgJqY/jtKgw/JOWoetdEJX5Dq+L6JRZDh8aPS+b28UUUU+d4ONkrhUY2TtMqG5JAzUSP5K0saS3Kb4/xDxmxWA8kTqiJ81wpRaWMJuMMPCPRJzZbQ5Z3SaPm4mI7363mCzMZWLJJ0G3dCl1WfIfFygh/Vze3B5SGpSo+L+UQdrcKltVkB1SuPGzGK7NRAD0zaQ0awtppt///gu7DgrQJRpW3XhfUyKP2pPv3R/CQTqIDD6cI/OY+358t9smbCaf4YoKe9SqmWHzIW3r7K6uHxJxLqvcHSFKZvWflOKNsQMqTYm/H8jYVBfy0/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============5262190113094449615==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


```
commit 5cd8d912032d2c2105c04660338cf4ad47d24697
Author: Roman Gushchin <roman.gushchin@linux.dev>

mm: allow specifying custom oom constraint for BPF triggers

This patch adds a new OOM constraint type CONSTRAINT_BPF and allows
BPF programs to specify a custom constraint name when calling
bpf_out_of_memory().

> diff --git a/include/linux/oom.h b/include/linux/oom.h
> index 3cbdcd013..704fc0e78 100644
> --- a/include/linux/oom.h
> +++ b/include/linux/oom.h
> @@ -19,6 +19,7 @@ enum oom_constraint {
>  	CONSTRAINT_CPUSET,
>  	CONSTRAINT_MEMORY_POLICY,
>  	CONSTRAINT_MEMCG,
> +	CONSTRAINT_BPF,
>  };
>
>  enum bpf_oom_flags {

[ ... ]

> @@ -63,6 +64,9 @@ struct oom_control {
>
>  	/* Policy name */
>  	const char *bpf_policy_name;
> +
> +	/* BPF-specific constraint name */
> +	const char *bpf_constraint;
>  #endif
>  };

[ ... ]

> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index d7fca4bf5..72a346261 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c

[ ... ]

> @@ -267,6 +281,9 @@ static enum oom_constraint constrained_alloc(struct oom_control *oc)
>  	bool cpuset_limited = false;
>  	int nid;
>
> +	if (oc->constraint == CONSTRAINT_BPF)
> +		return CONSTRAINT_BPF;
> +
>  	if (is_memcg_oom(oc)) {
>  		oc->totalpages = mem_cgroup_get_max(oc->memcg) ?: 1;
>  		return CONSTRAINT_MEMCG;

[ ... ]

> @@ -1350,11 +1367,14 @@ __bpf_kfunc int bpf_oom_kill_process(struct oom_control *oc,
>   * Returns a negative value if an error occurred.
>   */
>  __bpf_kfunc int bpf_out_of_memory(struct mem_cgroup *memcg__nullable,
> -				  int order, u64 flags)
> +				  int order, u64 flags,
> +				  const char *constraint_text__nullable)
>  {
>  	struct oom_control oc = {
>  		.memcg = memcg__nullable,
>  		.order = order,
> +		.constraint = CONSTRAINT_BPF,
> +		.bpf_constraint = constraint_text__nullable,
>  	};
>  	int ret;

When CONSTRAINT_BPF is set in bpf_out_of_memory(), the early return in
constrained_alloc() prevents oc->totalpages from being initialized.  This
leaves totalpages at zero (from the designated initializer).

Later in the call chain out_of_memory()->select_bad_process()->
oom_evaluate_task()->oom_badness(), the code performs division by
totalpages at line 237:

    adj *= totalpages / 1000;

Can this cause a division by zero?  The path is reachable when a BPF
program calls bpf_out_of_memory() and either no BPF OOM handler is
registered or the handler fails to free memory, causing execution to fall
through to select_bad_process().


```

---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

In-Reply-To-Subject: `mm: allow specifying custom oom constraint for BPF triggers`
CI run summary: https://github.com/kernel-patches/bpf/actions/runs/18859027430

--===============5262190113094449615==--

