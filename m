Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9ABDC5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 12:40:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B32566B008C; Tue, 11 Aug 2026 08:40:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE2CC6B0092; Tue, 11 Aug 2026 08:40:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 984886B0093; Tue, 11 Aug 2026 08:40:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6EBF26B008C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:40:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 46245403F7
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:40:16 +0000 (UTC)
X-FDA: 85088946432.28.A71D93A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9D56120011
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:40:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KGt+2tWO;
	spf=pass (imf13.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786452014;
	b=1fqk9BVTCMh+o3c+KQ0Xv/Zu62Su6yQ9XO8YJ50SkYc/DQScdInDzF7gkND7DwNB20zQjE
	daM08mws98GV2D7a8sN+/di5Ti56/sdCfcxRs7KLCq4k4WUFuIyATySDq9Pqo4FNPyIzVw
	Jqll2TK13ZnLxL856fl2A17HAr1jQYE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KGt+2tWO;
	spf=pass (imf13.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786452014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d5KyEGK2gDTZnR9ONWdkjRYGPSDM1pP3aSec7OaL0No=;
	b=eit8mkhfdMChI/gBi6I6xicEGDPiDAqPqaHqydeUnDG6qMxSFIZCICD8NcgFO4H7nsJZkC
	TKRYa7Nr2S9etkQqOnFsCJ3gG+q4YR0ruftM7ZtOt4yNVrYVzYiERTZ2kCm3eLwsySp0Em
	ONThgUM9FvHmCcw0V6sQ+VWKWc5cRyU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2BD36600AF;
	Tue, 11 Aug 2026 12:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F374B1F000E9;
	Tue, 11 Aug 2026 12:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786452013;
	bh=d5KyEGK2gDTZnR9ONWdkjRYGPSDM1pP3aSec7OaL0No=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=KGt+2tWOShDWT53xguh5grN6IERZuI/BcSokJh/qo9xHrDHp71T2lTEV8vQI3kKH8
	 sOujFReeKMeaVoSrS8UVExf60Ru+jd3nZucEoHFqgKlr3oD/x2eFor3QT9EDx/pSSG
	 b7Gp+UNTJ9jd9tURmxMw6E92iQrsfM6GTEOr5vI6JAgRDOz3vUAmAF5UgRQOUY3DQv
	 Eq7LdS74jTomov+Lqtp3eqg9I4dlCIxLq7zHhX+wOvYT7jkRzrvezC23saJp85LF4h
	 il/alnH9MhPAE+csaCRah1/5UqNT05pglcNV7hD/nL/WJz1sSUlW4Z56sJTnG/R0ex
	 UWmi9hh6E70KQ==
Content-Type: multipart/mixed; boundary="===============4081865467468875899=="
MIME-Version: 1.0
Message-Id: <5c189189e30671eaac05435772319bfeec1c1bf5d8a21a4f7e4aa95f0e88910a@mail.kernel.org>
In-Reply-To: <20260811112154.94053-3-tasos.papagiannnis@gmail.com>
References: <20260811112154.94053-3-tasos.papagiannnis@gmail.com>
Subject: Re: [PATCH bpf-next 2/5] bpf: Add user memory access kfuncs for mm_struct
From: bot+bpf-ci@kernel.org
To: tasos.papagiannnis@gmail.com,bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,linux-mm@kvack.org,akpm@linux-foundation.org,david@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,kpsingh@kernel.org,matt@bobrowski.net,song@kernel.org,tasos.papagiannnis@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Tue, 11 Aug 2026 12:40:12 +0000 (UTC)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9D56120011
X-Stat-Signature: jxjtayhjkuj8sc6iairf75mapbipyb9f
X-Rspam-User: 
X-HE-Tag: 1786452014-836282
X-HE-Meta: U2FsdGVkX1+9aTLNHIjXIxaRJQtJah6Eb+eAxbB2nvfLA6bZa2/ifHufjM4wMHvTsRU2Q2ShbLZejo9ycqGcUmwVVLgLzxXAyicEQZRVZMhG2R5S7TtlmR6g0IHook2Fc6DJ4foVSdP4TUQU396mHFrog8afRkiXUgpEBwJ4+g9jbuGR5/ogPTFUDx2mJNtnYYMX5qrJR7rxP37jKRvk1GcdKM0r6mguak3mD2cRo+3Vh7erLtQGf7MjSQhyVMxk2iQPM9xk+PM96A+2cs4NMTMqQ4+4ndTHY3NQOd7adT6Cv2w6CYQCKEmj/Qz0IHoAeDqyirGuejGe5orQeUxx8reyM3QEX0HwH0vv41ukPWU5OdQEl100kgsSDbL3i0tblZWMNVcM35DzR/hWk+w1TdR8M1gAPRXz5BlzLH+hLtchPF3+jKa2nHghTdzOvzxdNTn9HFsoXlDHoOT9AR39ucU/e9ivunhkl5SsXlLEhvE0cukAdud2r9iLO88/enU8lcSOP7PfaboGm9pARTX9GnDInGBpLdgnE6btIrpzvTMDU3VubEUZuKKurj0bI7p2B2hcaqZYPNKPWIFq7QxrR3xNI/cA80EIkYkKmZ6CMqgTmxOJx8NIzxobb0BdlIc3iUo+jvCYy5TwuAo2BxRFX5Ss0oExwyi6ftwfOT3dl+B974Xj+27xviZpITclrQ0PSeiOlDJT33jdB0eSyTvs8ESaF9zz6G5VBV9WDmGbp1Hrk4OI4c/Ffge/bzbPccHw9lVPp13h1nu74e7jDcUjV19o/3x/j2xrr0pEsY0Nozp1WkCPCJetomp0kLs/f81/6YPjgNdIJBwunx9WXCzqa8nkTz2YGqdrFf1vIWfufx/5+R63QMBpLxpRWb7T5TmlqULZEvODMpG1CE0VADRNjkAMKcpqByWgDRmMbx65/jw4tAAx7GOCfbOnI+A+YZfFZY+2WjiyjQRxlHoBsXy
 t9GIJES7
 kNmLJjUQM1FMRL+YNakxqhTvHp1EbJWFGaoHVU7MNCrMdh2/lYAoZ3hwXDeFx8UidIG4LxLZ7CK8f3RBGViGm0z3lQCMJz2vGJTdvG/OUieegy5oHjLO1Mgkf4OkYzn0VgY61aJW7IoysrVxM2b9HHSk1XoldUPtBiBJuSMP5XkbfckMMoOPKOlicANVSSx96rjJx/h/nnKJnmZ3nQbPH+E0fPWDCDw59xR6vnj7qz1ic/nDmvAs1bnJ4FnHgZml8NVFx0FnbdDExbm6zb4nNzere4sI6CY5/HYU+WhhEn3+qCEUEykpckJoSBsQiIG0rdeFGXJvusJW3F90gkRq9S5QtOdlPz3A0312lRcgCb41/Dm6EJO3iVKMFlI6KSNE1fHh/sLBfB4+0cndsUejn45I8J1xf+VxwGtGCaTMmaDlEFuDFwOEWlngdYflE64pxf1CFP+2xsvAFJqnrdEERG51CvSMBvT6/UFwmqC9OyVSmPHPJXJzcllgQOP+vz+6eBtGlSRcL6WkTCc4UgPIrhpnn+l3hnaBnrZ/KjOw3yzBP2C1/k9DGtNoiPgC8rvWpxCuTfhVAAHTEAsI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============4081865467468875899==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> Register both kfuncs with the common BPF_EVENTS kfunc set and mark them

This isn't a bug, but could the changelog be more precise here? The
kfuncs go into common_btf_ids, which is registered for
BPF_PROG_TYPE_UNSPEC, so they are reachable from any sleepable program
rather than from a tracing-specific set.

Relatedly, was gating them on CONFIG_BPF_EVENTS intentional? Nothing in
either function depends on tracing, and the analogous
bpf_copy_from_user_task*() kfuncs in kernel/bpf/helpers.c are available
unconditionally.

> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 6388b6b23e490..9ba3362832cd0 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -4931,6 +4931,8 @@ BTF_ID_FLAGS(func, bpf_iter_kmem_cache_destroy, KF_ITER_DESTROY | KF_SLEEPABLE)
>  BTF_ID_FLAGS(func, bpf_local_irq_save)
>  BTF_ID_FLAGS(func, bpf_local_irq_restore)
>  #ifdef CONFIG_BPF_EVENTS
> +BTF_ID_FLAGS(func, bpf_copy_from_user_mm, KF_SLEEPABLE)
> +BTF_ID_FLAGS(func, bpf_copy_from_user_mm_str, KF_SLEEPABLE)
>  BTF_ID_FLAGS(func, bpf_probe_read_user_dynptr)
>  BTF_ID_FLAGS(func, bpf_probe_read_kernel_dynptr)
>  BTF_ID_FLAGS(func, bpf_probe_read_user_str_dynptr)
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 891897f8a1b35..8931b3b2fc9d7 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -24,6 +24,7 @@
>  #include <linux/key.h>
>  #include <linux/namei.h>
>  #include <linux/file.h>
> +#include <linux/mm.h>
>
>  #include <net/bpf_sk_storage.h>
>

[ ... ]

> +__bpf_kfunc int bpf_copy_from_user_mm(void *dst, u32 dst__sz,
> +				      const void __user *unsafe_ptr__ign,
> +				      struct mm_struct *mm, u64 flags)
> +{
> +	int ret;
> +
> +	if (unlikely(flags))
> +		return -EINVAL;
> +
> +	if (unlikely(!dst__sz))
> +		return 0;
> +
> +	ret = access_remote_vm(mm, (unsigned long)unsafe_ptr__ign,
> +			       dst, dst__sz, 0);
> +	if (ret == dst__sz)
> +		return 0;
> +
> +	memset(dst, 0, dst__sz);
> +	return ret < 0 ? ret : -EFAULT;
> +}

[ ... ]

> +__bpf_kfunc int bpf_copy_from_user_mm_str(void *dst, u32 dst__sz,
> +					  const void __user *unsafe_ptr__ign,
> +					  struct mm_struct *mm, u64 flags)
> +{
> +	int ret;
> +
> +	if (unlikely(flags & ~BPF_F_PAD_ZEROS))
> +		return -EINVAL;
> +
> +	if (unlikely(!dst__sz))
> +		return 0;
> +
> +	ret = copy_remote_mm_str(mm, (unsigned long)unsafe_ptr__ign,
> +				 dst, dst__sz, 0);
> +	if (ret < 0)
> +		goto err;
> +
> +	if (flags & BPF_F_PAD_ZEROS)
> +		memset(dst + ret, 0, dst__sz - ret);
> +
> +	return ret + 1;
> +
> +err:
> +	if (flags & BPF_F_PAD_ZEROS)
> +		memset(dst, 0, dst__sz);
> +	return ret;
> +}

This isn't a bug, but since copy_remote_vm_str() in mm/memory.c is
already just a get_task_mm()/mmput() wrapper around copy_remote_mm_str(),
would it be cleaner to have bpf_copy_from_user_task_str() delegate to the
new mm-based kfunc (or share a static helper) rather than keeping two
near-identical copies of the flag/PAD_ZEROS/return-value logic in
different files?

The new copy also uses a 'goto err' where the existing one inlines the
error path, so the two now diverge in style too.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/31488001112
--===============4081865467468875899==--

