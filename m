Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B77FCD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 22:33:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56B186B0096; Fri, 22 May 2026 18:33:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5116E6B0099; Fri, 22 May 2026 18:33:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4002E6B009B; Fri, 22 May 2026 18:33:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2FCCA6B0096
	for <linux-mm@kvack.org>; Fri, 22 May 2026 18:33:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6B6B21C06F9
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:33:04 +0000 (UTC)
X-FDA: 84796507488.10.5E9F6E9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id AB72140005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:33:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dkx8nkhm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779489182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VRX6RdQlInnC8iDYrg/+evNFCkJuEZSlotJ8IHNu/Y0=;
	b=c4goTvJdr4RSI98eL1qsf/35nG4h6wYhGL2a5XfaI72MSE3/4MdLhhcdymb7WB2bwh/kmr
	xL+/88SsGyjCUQzSBxnJ9/AvhxqUnQ+cb1juEBE96R5fB7aIJzpQTjJLFF5BOIOoGdN8xL
	azJlU5iEwrHppBNKBFLGTZuaq0AmrV0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dkx8nkhm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779489182; a=rsa-sha256;
	cv=none;
	b=5uyHuTIdCOmWdEcV01FYmBHppmQr11hPlcXtNnU/x1M1HCXMRIqH4mrrENg4MW7jGLGkKD
	OO+UgZuswmFJ0ECBaJ6ICqrCD8oGTo/3VfGdsJOVGTsoliuQgA/26tMHj3R8gjRs85UFTr
	RkwQwB/TDq4ZGL/YVUR024FutyoaW6Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A0BA60103;
	Fri, 22 May 2026 22:33:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306B01F000E9;
	Fri, 22 May 2026 22:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779489181;
	bh=VRX6RdQlInnC8iDYrg/+evNFCkJuEZSlotJ8IHNu/Y0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Dkx8nkhm71/jfiQYcLtXj5OCx+u+h077LFH9Ejt8Sn588F4qJil9eyTGHRRwI0Q/d
	 fHpcbCxFp5UbSV3lR+9duxR/W5vBjEFXF3fJ7rQBy/y521MQK7HcPyXeKfjT3Ud0/+
	 mHzLBFrT8K8crdEq5tv8JmRqoqebcuwktqeCYwPQE9oaNnD779704BCvdsKQLsqZXs
	 s6tr6VoMLrVVgHztbhW1ylZ9tFUO4cuaU/Rit2HF/PpME+S5yiGaopQn1s+7IVQ1Y1
	 T8yZ/XNZJJq027DqDU+YYOXTfGczEkcri/q6YyAQzS7uXDh+k8ETDb3W+uka5TAoSk
	 4Yj2ZbF4s8IKQ==
Message-ID: <610c0702-4e55-429f-befd-445134483563@kernel.org>
Date: Sat, 23 May 2026 00:32:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 3/4] ptrace: add ptracer_access_allowed()
To: "Christian Brauner (Amutable)" <brauner@kernel.org>,
 Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linuxfoundation.org>,
 Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Qualys Security Advisory <qsa@qualys.com>, Kees Cook <kees@kernel.org>,
 Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
 Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>
References: <20260520-work-task_exec_state-v3-0-69f895bc1385@kernel.org>
 <20260520-work-task_exec_state-v3-3-69f895bc1385@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260520-work-task_exec_state-v3-3-69f895bc1385@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AB72140005
X-Stat-Signature: jzf1hgi8fmi7ixkgawcdpc3cerqh8du3
X-Rspam-User: 
X-HE-Tag: 1779489182-407701
X-HE-Meta: U2FsdGVkX1/83caLb6YPAG8a+y8fADJvrwbcJ5N98pSjMK3DQt6fA6yZrtwKzW4GlFsRaWbgQ+SepW+ixS+jieUhHLJonK6hZjZx3zwLEWXTgMqePFlBkZAT2i/kZOcJtTQ7UxLgEvkHb5whD8xJ7QWBtIpU1fn5Qctw86EtW8Nlz9Lu9e+S0ZOb/J0fVIUemKxmCJ9AbKvdDq0+QrTBeM2SpPvUw2M41zvOVfaKu+yjJSZzUlaWbZeS8SuBZMx8oczgANBqalF/Od2SnU8QASxQMP1MV4mRxBB4ujf0Iv+S0hfbuw1oDNkFd0P3+ISrldh4DE1CDjgalY7l1X9TR2Hp9KcFKTUZFbP91u1lR68cBfARWvnXa+4eF9AMVfD14+qID5xr3f9WPDgKztStBf68eKdwgdRZ9v4owvD/0PaAb12WylDrhaZNfu6Bp326LYla3sjj3gFTzdhPvp/5JPYz1lIN5egRUNCz94ZOSLn1n+i/hTnDtExdFU8Z4ygnntbgfvaPm4IgZpAzsGapBG/SlHpG7qcC1jGAMMnh/NrqooJE3qW/LtzHOK6ZPYGTbv8C27WHwqY0PvOZeBysfmLaGTs+rIe1XozJAgG6MuFhwFByF4WL8f8iK/NbAqEdKdxLjx2IfidIIXiso7skIUFOwaSFRtVFgOl+FMS+1mCjXCVYs/Jd/2LzG3Ef8lFhwc6hF50cC6znuWjMDtJ/VVHBmr4ONwOxHSHDmCnLBX2e9+r3vwNVn06oJbddglDQMHDFFQBnl4Vbe8R/vJQAw2do4h/h4iYEaQrMuiWPh14K1Slfp0TdTwLkXp9OIadFZ5OySlfz+QBb6pWDB7CmfN/+xYYtVleA/zDfJCTbJIB2i5RYGBgEyXGDQ21yG78//NMATl6Q5friaHCD142ok4UcukMylnUxm5u8Y2pGNTDiPsepnPXFHpPOhzMyUM8Rbnz4wLTncdr+KHMwrNO
 Jb+zpAKW
 PFwBxq6d5FJgAq6THtvBSKlO/uqODJq8snZdrVg0tch4ePRGyJFE+MfgVAnJHdQ7wncdK2zo5uREcFHfFNNkatVnz9hWQmqGRty4jgLlbxPXGIRWOdRZCbgrAPFEO2UddPInCY4/yN7ueM6F+Pm07rZLfWC9vkhzEe5qqg3JmxHQB6YQY/fIyE/QA3PkOOwRwHTAVio55rW/aIPHU7lriI90zwMW2OgXZzdfE1k9xcgXUHb8ppXCdNBnU8gjwQ0UtCXlCvL9jgKk7aWwKcs0nVRb4Py9b6Ie5CIvsUmCR+ktne5C1ncoCeY9UFAZG2uho8FlUrnRc4PUCGJlP6+IE1J7KTtc4CKGqnsTne2QkcgmN9aWCDMD5fLpiRvK9UAJdOcUF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/20/26 23:48, Christian Brauner (Amutable) wrote:
> Add a helper that encapsulates all of the logic for checking ptrace
> access and remove open-coded versions in follow-up patches.
> 
> Reviewed-by: Jann Horn <jannh@google.com>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  include/linux/ptrace.h |  1 +
>  kernel/ptrace.c        | 27 +++++++++++++++++++++++++++
>  2 files changed, 28 insertions(+)
> 
> diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
> index 90507d4afcd6..ef314f7a9ecc 100644
> --- a/include/linux/ptrace.h
> +++ b/include/linux/ptrace.h
> @@ -17,6 +17,7 @@ struct syscall_info {
>  	struct seccomp_data	data;
>  };
>  
> +bool ptracer_access_allowed(struct task_struct *tsk);
>  extern int ptrace_access_vm(struct task_struct *tsk, unsigned long addr,
>  			    void *buf, int len, unsigned int gup_flags);
>  
> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> index 07398c9c8fe3..0e1f80f73a7f 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -13,6 +13,7 @@
>  #include <linux/sched.h>
>  #include <linux/sched/mm.h>
>  #include <linux/sched/coredump.h>
> +#include <linux/sched/exec_state.h>
>  #include <linux/sched/task.h>
>  #include <linux/errno.h>
>  #include <linux/mm.h>
> @@ -36,6 +37,32 @@
>  
>  #include <asm/syscall.h>	/* for syscall_get_* */
>  
> +/**
> + * ptracer_access_allowed - may current peek/poke @tsk's address space?
> + * @tsk: tracee
> + *
> + * Per-access check used by ptrace_access_vm() and architecture-specific
> + * tag/register accessors.  Returns true iff current is the registered
> + * ptracer of @tsk and either @tsk is owner-dumpable or current holds
> + * CAP_SYS_PTRACE in @tsk's exec namespace.  Lighter than
> + * __ptrace_may_access(): it re-validates only dumpability and
> + * capability on every access, without re-running LSM hooks or
> + * cred_cap_issubset() checks performed at attach time.
> + */
> +bool ptracer_access_allowed(struct task_struct *tsk)
> +{
> +	const struct task_exec_state *es;
> +
> +	if (!tsk->ptrace)
> +		return false;
> +	if (current != tsk->parent)
> +		return false;
> +	guard(rcu)();
> +	es = task_exec_state_rcu(tsk);
> +	return READ_ONCE(es->dumpable) == TASK_DUMPABLE_OWNER ||
> +	       ptracer_capable(tsk, es->user_ns);
> +}
> +
>  /*
>   * Access another process' address space via ptrace.
>   * Source/target buffer must be kernel space,
> 

Besides the new RCU + old MM handling, this matches what we do in
ptrace_access_vm().

Reviewed-by: David Hildenbrand (arm) <david@kernel.org>

-- 
Cheers,

David

