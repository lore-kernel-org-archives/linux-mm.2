Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA213606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 21:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jpu7isRf
Received: by kanga.kvack.org (Postfix)
	id B90DA6B00EF; Thu, 29 Oct 2026 17:59:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B411F6B05B1; Thu, 29 Oct 2026 17:59:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A56C96B05B2; Thu, 29 Oct 2026 17:59:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F7FA6B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:59:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 129621604B9
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:59:34 +0000 (UTC)
X-FDA: 85377031068.28.F58BFBF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 73DF9C0006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:59:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jpu7isRf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793311172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MG/FCUNnGBB5FvtyeNl3BOQEOtBU2SsDmO/bRipgzyw=;
	b=evYjO2GGXIJGbmNMxXlYdsZHdhcKwCRhGgpsZY7xqpO3I1nU8KYHvHq8zlTsgXj5NiWe1T
	m3Yt9IRrlb50ZDbnXanhHwewIPQ4rKMRRSGC/N4w1KVmQEBqItWXwUXS2S6iLbbgjjBWLZ
	Hz+CA6MlX+T/X3gksKL/1+ANfHRqQis=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jpu7isRf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793311172;
	b=uIQR6BcXE+Rh9yS/8KKA82h85rMMO1XKfClZaAUtFIHDd1LSCGtj4RtQsSHaaDARjeFqEP
	+8fxFhwnUgp2feMkHDC1D92TKhWABa+PtxKyJenUV/pcTkiiOpE/69BL9uYqQkQI2sTcV2
	VRLTsRfh3gxGIb7i3B3v98rp3Hg9bQw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EC608600DA;
	Thu, 29 Oct 2026 21:59:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6167E1F01816;
	Thu, 29 Oct 2026 21:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793311171;
	bh=MG/FCUNnGBB5FvtyeNl3BOQEOtBU2SsDmO/bRipgzyw=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=jpu7isRf7ZVVTs0ZfPyQHpXrh9H10Z+3vtHtyretE6Hwmj9AZp5jnVJ//vNZDDfDS
	 RXi7vjEncBqqtpmOaHLBRgWgm7DihlX8HM8TUqFczy1G18GBVh2Pdq5htjytbflZVr
	 iMhZ5ad6bYL51CtuJm+d89VyJ9dlVnWA8pAE0eJF/fwDkfBtW7mMAPbdolHEQ9DnpP
	 TIrN6ZjXG/sDOjRti9hL7NC6stcBeuen/jynUd5qXdodWyiJ5cwLt4rAKqUaiLhe07
	 EDM9BMSOZUBTurmH4ozrVm4HtsMCqrnwYfWVbXXFBAlXDZQLx9eh9Pw+wHx7H1Fz5Y
	 sDLIU9cIReEOQ==
Content-Type: multipart/mixed; boundary="===============4330953219371756825=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <18976b63cb396cdfaebc5c630c926d88544160ef2a4c034e8a290df2b428806e@mail.kernel.org>
In-Reply-To: <20261029212551.56964-6-jolsa@kernel.org>
References: <20261029212551.56964-6-jolsa@kernel.org>
Subject: Re: [PATCH bpf-next 5/8] selftests/bpf: Test user memory mmap kfuncs
From: bot+bpf-ci@kernel.org
To: jolsa@kernel.org,ast@kernel.org,daniel@iogearbox.net
Cc: bpf@vger.kernel.org,linux-mm@kvack.org,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,ljs@kernel.org,john.fastabend@gmail.com,nierro92@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Thu, 29 Oct 2026 21:59:31 +0000 (UTC)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 73DF9C0006
X-Stat-Signature: idr1haoziywuba1ezmbonafomaeyy68c
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793311172-296351
X-HE-Meta: U2FsdGVkX1/iVCQmMqApnBiA37LreoUTcyyKR9OT1dhyb7z5uPcJEcNcKFBpEdIEe2VOlFROX9EPJSW2t9FCBLJduamcsOSYEpEjPEUHZTG31A8gSiCsVHD7YxPPHrKx6urUGR1AOF1HX2H9UuJG0g9MddGxidhXe75glh1pht8sj3XoLBbPxDOcj7EjhYoaFr7ZVkbvpLeD+PE/ShqXwMkGCx0Em7BH2IBZRYqxG/iKtxxRfuWOd7zuigB7Z1BcaIZdRK7eT9vTOaeNaHhFTYrR70GKGRmQyj3Gn2uzKauSaFwVE9vVnUiiYCD+tSjL9sKFsyxg4dEl0lxOuJADSLWrvOVV1NU48N34lIaoCmkYYSIfsIkZrRJKIDBBz4UedsUC7VlSInXkPJkzA/Z/1KqI74myRg+fLBWVtctRIVlvFt0qlZil5m6BeG+jkpurivgaxx4whxw8JJkJ0CzgJq2w5Hwlup/6g19LROLk5PhjcTmI0J8/FZvEjUPOo3dIXirPNTUVfBNFh/Xgj1kbULpphPvH4w+B4rrJn+WWRV8ayTdnvvishwmzuOZFd5yEcR0nDvPduTlUSHO0tZnZRDRrR17zABlZLkIoBuZk7srHMf+iiajcHTPbcRL+HTsoCUeNUCJuWJMbud082q+Qelf5svBqEDWhf1sSlz5qdlQIgkzDMXB8LIykIJtSb+yt8WXviVE6asTtLmcOb2Sv/sF3Z0lNblT0jGx1uavwL77R9HQjtr6HmNKLJ2tAlLGxmbO90k6ogKT1YIV+SYKEcGGfgZkvU3pDNgJMKSaDiE+t7dLqI5QCm/NP2VfRKMkZp9NURw/dt1F4O1NPwZ86eUjESFGKNyCPM6vPuWdtbMShAjkxaj/jTBGoWVUWoAYnE9A+2UPwDsYs94Wze8VS6nt92WpcgQkH64gyQ0xiL+Miwza+i4ik9luZp3AIoEvm+FzIKtIfsP/FXISbisI
 TQNG67QZ
 6QJ/WQt6t/zBRyoXksZ1Sa6ftaIU3NhmWnBZKEEw50xlGIl9P3DXSGPviAcYpTxDvskfRNcA5AZ0ccTIDHK6og07p3gtdkuF/UUJftQeqslCXm6r02eNx8YOEinwskUtQQDHXWSRRMQYq6v1jCamFWjlk6+uKx4q0gRHJ5oGYC+686m9fAKZkr4r9kSZVnC8tK0yeRzoa6F6IOeBhs0PVlF/R5KIpp5NrP2hyih7/+C4m2NNyP8CPAy48a9DSv66SkbROC+HmG0TsgaS/xKhgXQThBgkkmvrFmnbUUC6aYMN2/FSg/OrcExNEBdvdmN6uWMV+kBwqhN798oPEkXpLoNVIaqJci7MLmhu7y8XMzQqTS3qYoO2b2kQ+8+7WuLuRSxRB0Ep1dTtFTBzkGCoX7WaR3HtXD+LlkL68zLyVlvjq3wTEa3urZyzX2ZQ5jwz+8vm9/AJabDIpfoAeqYuAGLQExAUnolvJ60O4FI7KnokrNSfREo/pFvWfbURuqn4YHzEKKoNue7LPWvk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============4330953219371756825==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> selftests/bpf: Test user memory mmap kfuncs

TL;DR: Nits only: the changelog omits the kfuncs.rst documentation added by
the patch, which may belong in another patch; also an unneeded
<sys/personality.h> include and a never-used NULL perms path in
check_user_mem_vma().

>     selftests/bpf: Test user memory mmap kfuncs
>
>     Add BPF selftests for bpf_user_mmap and bpf_user_munmap from a
>     sleepable uprobe. Check that created mappings have the requested
>     permissions and that unmapped addresses are no longer mapped.
>
>     Assisted-by: Codex:GPT-6
>     Signed-off-by: Jiri Olsa <jolsa@kernel.org>

This isn't a bug, but the changelog only describes the new selftests, while
the patch also adds a "4.4 User memory kfuncs" section to
Documentation/bpf/kfuncs.rst.

That section documents bpf_copy_to_user() as well, which is not exercised by
the tests added here, and it states that seccomp filters do not mediate the
mappings made by these kfuncs.

Could the kfuncs.rst section go into "bpf: Add user memory kfuncs" or a
separate documentation patch, or at least be mentioned in this changelog?

> diff --git a/tools/testing/selftests/bpf/prog_tests/user_mem.c b/tools/testing/selftests/bpf/prog_tests/user_mem.c
> new file mode 100644
> index 000000000000..f301a1843706
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/user_mem.c
> @@ -0,0 +1,112 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <test_progs.h>
> +#include <sys/mman.h>
> +#include <sys/personality.h>
                  ^^^^^^^^^^^^^^^^

This isn't a bug, but is <sys/personality.h> needed here?  Nothing in this
file calls personality() or uses a PER_*, READ_IMPLIES_EXEC or ADDR_*
constant.

> +#include <unistd.h>

[ ... ]

> +static bool check_user_mem_vma(void *addr, unsigned long size, const char *perms)
> +{

[ ... ]

> +	return !perms || ASSERT_STREQ(vma_perms, perms, "vma_perms");
                  ^^^^^^^^

This isn't a bug, but does check_user_mem_vma() need to handle a NULL perms?
test_mapping() passes the literal "rw-p", and the later patches in the series
pass "rw-p" and "r-xp", so the "!perms ||" branch is never taken.

> +}

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/40959191771
--===============4330953219371756825==--

