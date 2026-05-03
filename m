Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72A33FF886F
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 17:23:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 945956B0005; Sun,  3 May 2026 13:23:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F6656B008A; Sun,  3 May 2026 13:23:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80CBB6B008C; Sun,  3 May 2026 13:23:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6CAC96B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 13:23:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0C6F61406ED
	for <linux-mm@kvack.org>; Sun,  3 May 2026 17:23:33 +0000 (UTC)
X-FDA: 84726780306.15.B2F471B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4B9FD2000F
	for <linux-mm@kvack.org>; Sun,  3 May 2026 17:23:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a0Va3qU7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777829011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ha+3dTcY9XY6fDCPf0Zumb9AyU4+N4AQ3+cS1YPWzhs=;
	b=q43H3UkKHchoDTbHKoEHF9A/7YQonB3RxHa0LrsAqRV+oHDncCF1gS5mDh0ufkuVP/HW6L
	LdDavHOBhownWbXU9qnAJ715hnU4dyVqYbycu9j6cTWIasTvsY6+bEyFKNcL5CYjk2JjZP
	faJmM29Y3/EYNHwjQ+j4DhXqAZ0DV6o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777829011; a=rsa-sha256;
	cv=none;
	b=qgX+bQ8FfshFpjdhA1YRgObEg2Cwqus6oJi4Nkx0k1SlI7ZMgn+Wd10U6Enjo6qo11j7Je
	beoqiehnCcVFYoA5ivH8GqkJqROiQWtfRR0EEA7kQEN0ZNUkxCjsyg4wWwoddDO0GybUiA
	GdSGDoTBjOjk26+YTOaG1r1IbhhxClU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a0Va3qU7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DB01441C0;
	Sun,  3 May 2026 17:23:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6890EC2BCB4;
	Sun,  3 May 2026 17:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777829010;
	bh=MAX1WLXMN+1GNFQMEzikaKWBNYQVg3O6ltYlnFE7FsA=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=a0Va3qU7k0KT2KpuPOfeQKseLEbqBUjzORSfVBhgmDQOObUBkkCdxvDoHLjpd43F1
	 4h5E8P8OrIs5Z0UILb+AOKF+7NCz7YXpKCyj9Yrm7i/7DQN7Py2Q8AaguvE2ct80tm
	 d+wSUyyFPwtOAtNKc4KXOoPjSXJ1b/vVLlu8uJT6+MCJS/T6HrPlm14plfWF9Qx3bJ
	 UevK+enFcqpLdvPcaERjr8HF9MWDcVbVW62RtlPF7gxfDqB37rwvPQq7rdAkhJPipZ
	 MRt8QpthU5PmyJRppz6aMhFBNwH+8Yz3X+DuoJRCmFErqNvlaQc6z+OiLcpznurp04
	 E7ix8cgHvBKcA==
Content-Type: multipart/mixed; boundary="===============1060358541369016392=="
MIME-Version: 1.0
Message-Id: <91c02dbb561c7a4d760ff3314c99fed77870e0d7665848b5832f6719d21feb17@mail.kernel.org>
In-Reply-To: <20260503165024.1526680-3-vernon2gm@gmail.com>
References: <20260503165024.1526680-3-vernon2gm@gmail.com>
Subject: Re: [PATCH 2/4] bpf: add bpf_cgroup_{flush_stats,stall} function
From: bot+bpf-ci@kernel.org
To: vernon2gm@gmail.com,akpm@linux-foundation.org,david@kernel.org,ljs@kernel.org,roman.gushchin@linux.dev,inwardvessel@gmail.com,shakeel.butt@linux.dev,ast@kernel.org,daniel@iogearbox.net,surenb@google.com
Cc: linux-kernel@vger.kernel.org,linux-mm@kvack.org,bpf@vger.kernel.org,baohua@kernel.org,lance.yang@linux.dev,dev.jain@arm.com,yanglincheng@kylinos.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Sun,  3 May 2026 17:23:28 +0000 (UTC)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4B9FD2000F
X-Stat-Signature: x1856o9krc17m63zxf5nzanqyeey9or8
X-Rspam-User: 
X-HE-Tag: 1777829011-350826
X-HE-Meta: U2FsdGVkX18b82DCXBwWe0an0hcwO30BPYM5QmoGuauCEK99EeKLTgend9MkQiPUcuufta1Jvse2PkJ5Dnx+UX8CQfs7WP8e+uiUn4eD1KymLPS/yeGOIt3zT+vwL3C857xqhGcYj+YV+KdnFwyHcnaqLVcdoag+9BNuI2BtWtNKhwn2bDl905C4geGDJoD5bP2xVPBJ7vpD3+vKP06ljkl28zLOgFIqMXPNYVQFf1VxQKnjJPisJkqd7c6K1//8od1hmtsJdtPV6YqcmqWja0S45re7HYXwtjc6R+WiOp3VRuV5SiBUjyaogloR8Vb2dQjI8lTMcANEuRQ7LnAgWPbv8C5/Aql6LZIhh4wIlfHkNMmju/LvLH8cix0i/+WvoLRKB59R5K91NzLVpUAjaJYvgKXGtWFisqEX3LUbmcC2E1K8zrAZGso3ewFxfIs+eFNXAsCJg7JAIz8blB6rCP65pYHcjFT1EgH7yZ+fEWp1kUCTgzhNnJPJDncFGNBXmEQ67NwsMg++TeQngUsSOFdjVTT4zjGaN36J2B9aTqOuequ19rIAN5mCsA/jkWHwXv1JOWO2gYLvC7IV9zSFCN9XfevYLGMZut/HfKDxEpyX7CyiBUbi/P5BxKNe8AD1A0FoKuOK46mV/6em1G9jRfoJ6zD3N1lrKO77AkFanAapL/S96DjSt+wOkKtPwBOCqmSHhEAT6l01pllyC1enybxmVQeMvWX3klrVdiCvt5gDcnPnQZ2hs7SSyPYY0Y2tawd0B/+37nOmx39VjosdOEZgHMZqw4Y7hFhaM8m6XXPLglZwuo3Cr55SnoISYX3X1LbsJfdo0mjh41ne+yNX3gE9FPZNOFoPE/u6yurE5ep4Augu/vgPl/7Fo81r9dDCcGsDtlzwqrBXUgjc769swq+z0UE8EvS9EDBZ5HadUG7nLzC9rQXoI0WsjNZrunOmf/mCvHb2tFpEbxx7/cs
 wGPNmkee
 w07wOa6qhrf6ZMHZIhZfVmqR0OOlcFFKPRsNVjEy/BLVDkeSo3JWfHBKAw+amV0haxBFKdM1OcKgTShaI2uDG3ij8QQIzDCdbNKno7yx212rPHQm8rsqCg2s617nxeRNACXV9enJGcrOyzBDdlhH8o0qeGrWV+NLaCliHIFRakqtkCpExxCgoRMSnYTsgRPm3WTxsSPVoGYjlqDu8gTJjlemBdOrn5LwYiUieOXbGkqdhtRKZyHPfyXFXol/+qjOo6mKdTxy14i6M9jXVYslrKKO0plCO+LjwvzuUIlvuXz7vaO8+lCYJV7LmNJ8IW4QGOVsdagvEAmqZfC+1Pej5iFM7sjeqGhIgPDknh9MsGzT1jK9V6KL636Vx1GrEky8cgoxaNs2CpywQdjBE6ZIpKdwkj3Y+Lhnsda8aCcv+TuuFy1dFf2Fieu2Uew6OoJS1QzfiqnJpgaXDgmu85jdUjho0bQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============1060358541369016392==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index baa12b24bb64..d7b04f1fc9f1 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c

[ ... ]

> @@ -2819,6 +2820,32 @@ __bpf_kfunc struct cgroup *bpf_cgroup_from_id(u64 cgid)
>  	return cgrp;
>  }
>
> +/**
> + * bpf_cgroup_stall - acquire the total stall time of cgroup
> + * @cgrp: cgroup struct
> + * @states: psi states
> + *
> + * Return the total stall time.
> + */
> +__bpf_kfunc unsigned long bpf_cgroup_stall(struct cgroup *cgrp,
> +					   enum psi_states states)
> +{
> +	struct psi_group *group = cgroup_psi(cgrp);
> +
> +	return div_u64(group->total[PSI_AVGS][states], NSEC_PER_MSEC);
> +}

Can cgroup_psi() return NULL here? Looking at include/linux/psi.h, cgroup_psi()
returns cgrp->psi for non-root cgroups, which is allocated in
psi_cgroup_alloc() only when the psi_cgroups_enabled static branch is true.

When the kernel boots with cgroup_disable=pressure or psi=0, cgrp->psi remains
NULL for all non-root cgroups. The sysfs *.pressure files are gated by
cgroup_psi_enabled() so they never hit this case, but these new kfuncs are
directly callable from BPF programs without such gating.

A BPF program could obtain a valid non-root cgroup (e.g., via
bpf_cgroup_from_id) and call bpf_cgroup_stall on it. If PSI is disabled for
cgroups, this would dereference NULL at group->total[...].

Similarly for bpf_cgroup_flush_stats below, passing NULL to
psi_group_flush_stats would eventually reach __psi_group_flush_stats which
does mutex_lock(&NULL->avgs_lock).

Should these functions check for NULL after calling cgroup_psi()?

A subsystem pattern also flags this as potentially concerning: the `states`
parameter is used directly as an array index without bounds checking. The
backing array is declared as u64 total[NR_PSI_AGGREGATORS][NR_PSI_STATES - 1]
(see include/linux/psi_types.h, struct psi_group), while enum psi_states has
the range 0..NR_PSI_STATES-1 (PSI_NONIDLE is the last member).

The BPF verifier only checks that the register is SCALAR_VALUE and does not
validate enum ranges. Because the parameter is not marked __const, a BPF
program can pass any scalar, including values derived from map lookups or
arithmetic.

Passing PSI_NONIDLE (a valid enum value) reads one element past the inner
array; passing a negative value (legal because enum is signed int in C) reads
memory before the array. This would leak adjacent memory contents to the BPF
program.

Existing BPF cgroup-stat kfuncs guard against this pattern:

bpf_mem_cgroup_page_state (mm/bpf_memcontrol.c):
	if (unlikely(!memcg_stat_item_valid(idx)))
		return (unsigned long)-1;

bpf_mem_cgroup_memory_events (mm/bpf_memcontrol.c):
	if (unlikely(event >= MEMCG_NR_MEMORY_EVENTS))
		return (unsigned long)-1;

Should this function add a similar check, such as:
	if ((unsigned int)states >= NR_PSI_STATES - 1)
		return -1;

> +
> +/**
> + * bpf_cgroup_flush_stats - Flush cgroup's statistics
> + * @cgrp: cgroup struct
> + */
> +__bpf_kfunc void bpf_cgroup_flush_stats(struct cgroup *cgrp)
> +{
> +	struct psi_group *group = cgroup_psi(cgrp);
> +
> +	psi_group_flush_stats(group);
> +}

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/25285279315
--===============1060358541369016392==--

