Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D973C5DF9D
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 17:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAF316B009D; Mon, 24 Aug 2026 13:02:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5FE36B009F; Mon, 24 Aug 2026 13:02:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99D8D6B00A0; Mon, 24 Aug 2026 13:02:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B43C6B009D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:02:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 013AB1601E7
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:02:31 +0000 (UTC)
X-FDA: 85136781744.07.D767262
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 59C4C1C000E
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:02:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=atk2v2bo;
	spf=pass (imf21.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787590950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qQ2bQOrbTsaJhvYOE3sPxtUiRh+bM2NAzCmvJRNhg2E=;
	b=T8eVdOP2ziP586zqBRLawdYjA4idpjnw6nzaSzIK3atvG5zA0JopAIv3pQEhK9z8pXXmE5
	bsxmPm0xghE6yGVRaJomMPXXUTr6bY/18AeMTfAX4fES5kNMMmGPCLOZm+eJlaXt69wtGr
	U9ytVf2MIryk/sZeh0Ay6yrGk0w6EmI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=atk2v2bo;
	spf=pass (imf21.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787590950;
	b=2DAOrGQYdA/qWbcxqoYwbTLMtGJL4kV4TKknJjGgSBDRCw149h51Q5L/Rg2BliTSPfbo3B
	6pmOAqKSLLLxp2esZe1Hw8P+2CW4DYDXj2iYznM5zJkQhT5ldj/uaY7DUPKJh1wVLi4omY
	u+6Fvn+9+bBeWH5oFFqEGeosWfKrFEc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EF5F160204;
	Mon, 24 Aug 2026 17:02:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058AF1F00A3A;
	Mon, 24 Aug 2026 17:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787590949;
	bh=qQ2bQOrbTsaJhvYOE3sPxtUiRh+bM2NAzCmvJRNhg2E=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=atk2v2boXCqeIf5Byg0tMupiBW9ZOEYXubMkwsfR5oWtnFfNi8VBZBFcjb3LxBRTI
	 tLvR8JpBo8kdhOFr97hf4IzmfErlZXVx//L6stpp+5fw/wjf5yLnvZ8jlTtbdXiz1k
	 XPmdydCoAIMbuFouXWoj+VatbjK3IOJcUyvh0dgSyL4OIjr3H/AoaXpvjIXsfycxRH
	 TlsPMvt7PhGp8QaLsqkSMVjQfWGqMZisrasmo3Y2BTAtrbT4NPO9hn0g6ywI+s2aiS
	 NkxkcIkKLbxmjdTpV5nhIws4Nyw0DVODWj//a9IE0hfjGntyOdtPBcg/xfcAs0tKMK
	 IXK8pFB2tQa4Q==
Content-Type: multipart/mixed; boundary="===============4786653597931673110=="
MIME-Version: 1.0
Message-Id: <58f6ac1ad1722df4b1b011d30d194e31d7ccc8d86ed5a93a039fe958f7383ca3@mail.kernel.org>
In-Reply-To: <20260824160523.3907021-9-usama.anjum@arm.com>
References: <20260824160523.3907021-9-usama.anjum@arm.com>
Subject: Re: [PATCH 7/7] bpf: Batch TCO handling in string kfuncs
From: bot+bpf-ci@kernel.org
To: usama.anjum@arm.com,catalin.marinas@arm.com,will@kernel.org,mark.rutland@arm.com,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,ihor.solodrai@linux.dev,akpm@linux-foundation.org,david@kernel.org,ljs@kernel.org,liam@infradead.org,vbabka@kernel.org,rppt@kernel.org,surenb@google.com,mhocko@suse.com,linux-arm-kernel@lists.infradead.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,linux-mm@kvack.org
Cc: usama.anjum@arm.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Mon, 24 Aug 2026 17:02:29 +0000 (UTC)
X-Stat-Signature: cxmru3gjxrj7csmbig1xt8ryb69a5kfe
X-Rspamd-Queue-Id: 59C4C1C000E
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787590950-342864
X-HE-Meta: U2FsdGVkX1+scPFn7/WTr3qAGuKyPGYxdBkFExLvLO2FhkgR4w7tS5Q2VXhV3rmhwpkhnTYWGPPOge7kxSWg0qKCqU0G9N6JVmgkMRoUD9PQfGKwbs3o3Ysv7AWrhvD6HonYd8qM5fruESjsqTtU69UKuXk65SYuzWGvN+HqDmMNZDVG5cEcpcKZxIWbPPzUoBi8XwdbkeJh2koJqfOcgSN7yjWCyYh1UkivZfA9Q0rKBwY10siH190DRpWGa/qMR9MBkcbgFz9KhO0rf5g6KhgNHMfV29PCw3CVWDj676GyMnbUlUFVqlEJiexrKV5Yz8vX895JoplO0fTDI+4e2m+FBOR4FQ9f9JsT9m6gCJBGMUiQV647VS65XqQPTokMpTp017zHgVvRM8ScI/TWYSi7uR/Q+ESDniAsHHkKuLqAXrqg4vgoK8JoQzDVRXBv69RZ+slHSB7zpxyEgsD8DgJaq0TjgPHz292LwYi7VKQdoF++sVvnWI9L0SRNoJMdp6UBV+/3NlYLtcQBEP0TRelebbTV+5rRGR29uyIRvohDKAFViWXH7YmkxQR+aPmWC5CxAunoldaCbGi8b/qlbHGGlyiAl9HTRRLPu1r6XC7DpnzwLNtZBcQ749+e74HI66/8ZIFR96GRPuxKADXJlpFoUB1/Myuhjf6tWh6/DHImt+ueRwW/hv+cRNxh52xryfrX4HLiLkRdl5ZuXBTRXo5S1BgTaV+vVAqPSBZ8mCXM6cCB+oDg5f8I446kT9bGjDfMj3LcQK+rI3wCuFxL5hAmsyFe5gFQ/qAx3WfViWkS0982m2OGTptOOzjWvmGJhtBfmekm1nYDnBn6YTt0BF93rC39dACNIbkN7uD+OFlHIBNhXEQNp9hxW+VOwXz1rCSA1hq+Y2qZPu58CeGRQNywnujFEy83aooOqytiXDxFlnWc/H3lityPuYMIuXo7i/rTzeybwHJTsvfPUlO
 PVrBzQOH
 rfUUIcCl1Wz7TcuhsVbW3rJamCV7h4uEtjPhXAKKHW6xpjqt6nMs4X5gBpeyo5pdfm5vpTgyO9hrI0EiLqzMlT9pXdgFa/tA5Sg1GNNo2JmtzhWhj43725DxmYgLtkb7iSjEa0K9HHIEjI3/MR+7EuJ7rYz5gCWM6wr9SRGQ7FQ2aOhBTiUxiJRBA3ICO/xh/5zCKfg4lCZJ8mBVhyr1UlqouPorU063W6ixVOleKdH8fWPyIrO5e4OZSOcIC8xjNaNoEYlgWSpAQrl3w+yMba98BBXZNpj8UZszgf/GTOuwf2xgRjdd5tdEtTHx/fTJIhAQNh9tCIwEu/lP0iSlzQfhCdtxfubGSjPpMaJr23AsjMVjL/m2DdpJLnLJOzZn9fTaijawdcsT941exjg3P5KP4XVNeJ1PAaShim2/oID9FPMu6eE4wtrxa+7+MWZpBNZ0ftyUzoCbVZIFT9g897kq+gy+04dooDnaU6nCQXmsxAD0V5BSO3UI1jAmPFIR0SdXwZk8tsXZQWyM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============4786653597931673110==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> commit 582a0a0c5c8589832f42bc3de95bce3c2fba5778
> Author: Muhammad Usama Anjum <usama.anjum@arm.com>
>
>     bpf: Batch TCO handling in string kfuncs
>
>     BPF string kfuncs cannot rely on NUL termination, so they scan memory with
>     kernel nofault loads. With Hardware Tag-Based KASAN in asynchronous or
>     asymmetric mode, every arm64 load sets and clears PSTATE.TCO.
>
>     Use bare loads and hold one nofault region across each string operation.
>     The scope guard restores TCO before page faults are enabled again on every
>     exit, including an access fault.
>
>     A character comparison performs two nofault loads. For N compared
>     characters, the number of dynamic MSR TCO executions therefore falls from
>     4N to 2.
>
>     Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>

This isn't a bug, but would it be worth scoping the statement to kernel
nofault accesses rather than "every arm64 load"? The TCO set/clear
happens in __get_kernel_nofault()/__put_kernel_nofault() and
load_unaligned_zeropad(), not ordinary loads. Also, the 4N-to-2 figure
applies to the two-load-per-character comparison helpers like
__bpf_strncasecmp and __bpf_strnstr, while six of the eight converted
functions (bpf_strnchr, bpf_strchrnul, bpf_strrchr, bpf_strnlen,
bpf_strspn, bpf_strcspn) perform one load per character and so go from
2N to 2. The sibling patch 022e4f83d5cb spells out its per-shape figures
in a small table.

> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 3574a9a5721e..f8c557161584 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c

[ ... ]

> @@ -4014,12 +4020,13 @@ __bpf_kfunc int bpf_strspn(const char *s__ign, const char *accept__ign)
>  	}
>
>  	guard(pagefault)();
> +	guard(__kernel_nofault_bare)();
>  	for (i = 0; i < XATTR_SIZE_MAX; i++) {
> -		__get_kernel_nofault(&cs, s__ign, char, err_out);
> +		__get_kernel_nofault_bare(&cs, s__ign, char, err_out);
>  		if (cs == '\0')
>  			return i;
>  		for (j = 0; j < XATTR_SIZE_MAX; j++) {
> -			__get_kernel_nofault(&ca, accept__ign + j, char, err_out);
> +			__get_kernel_nofault_bare(&ca, accept__ign + j, char, err_out);
>  			if (cs == ca || ca == '\0')
>  				break;
>  		}
> @@ -4027,7 +4034,7 @@ __bpf_kfunc int bpf_strspn(const char *s__ign, const char *accept__ign)
>  	return -E2BIG;
>
>  err_out:
>  	return -EFAULT;
>  }

A subsystem pattern flags this as potentially concerning: eight
functions in this patch now contain both scope guards (guard(pagefault)()
and the newly added guard(__kernel_nofault_bare)()) and goto-based error
exit to the err_out: label. The __get_kernel_nofault_bare macro expands
to 'goto err_label' on an access fault, so bpf_strspn (shown above),
bpf_strcspn, __bpf_strnstr, and the five single-loop helpers all mix
goto and guard() cleanup in the same function. The subsystem guide
directly flags this combination.

My own reading is that this is probably unavoidable. The err_out: label
is an error-return label, not a cleanup label - its entire body is
'return -EFAULT;'. No resource is released there; both the page-fault
state and the TCO override are released by the guards' destructors,
which run on that return because err_out: sits in the same block as the
guard variables. The goto does not leave the scope, so the cleanups fire
at the return, not at the goto. The goto is imposed by the
__get_kernel_nofault*() API, which is inherently label-based. The same
mixing already existed before this patch (guard(pagefault)() plus
err_out: were introduced earlier in the series), and the sibling
conversion in mm/maccess.c (022e4f83d5cb) uses the identical shape.

Does this concern you, or is the pattern acceptable here given the
constraints of the nofault API?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/32751368606
--===============4786653597931673110==--

