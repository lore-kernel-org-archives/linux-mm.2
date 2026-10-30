Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05752606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 23:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=clZEhLLH
Received: by kanga.kvack.org (Postfix)
	id A0D136B00EF; Fri, 30 Oct 2026 19:02:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E2AB6B05B1; Fri, 30 Oct 2026 19:02:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F9006B05B2; Fri, 30 Oct 2026 19:02:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 55B266B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 19:02:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 20F64408E6
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 23:02:46 +0000 (UTC)
X-FDA: 85380819132.12.85310D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 759FAA0003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 23:02:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=clZEhLLH;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793401364;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hzGO9HATSXKPRUeQY3W+HyUl9VCm4oUOm3DYY5spgbs=;
	b=dvRjqOb+mfnJGQRQVhwNnBAOmWSoV3BO1MY5qbh+2w5bDsTSC7HWa+n3vvjoYKmMgHdb78
	xfoYJDAnKJGoqBoRTAtHhtsPBlbouQbVCx07TA84FvOg0RSIcCBtLq/sVi1W2wJhv5D3TG
	n3uYBSFJd/c/nDf+t+t+iGFvJXUscSo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=clZEhLLH;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793401364;
	b=JM/Oo5wMFUWMVLvbTBkZvt2v8cnYtvZ7eoXkRhPe+eIYDbo9LxaNAgHxPTdGlH5uPpXr3Y
	zNsGdaltd78bCa9TdkMcNQS8VHmp11u3c/fWo8h2U7ipASBZCpgiIC8KGk0lTvdioDARYE
	SUbVr90GHpwJgrOoMa8aCW91Z4PJC/8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E81C3601EE;
	Fri, 30 Oct 2026 23:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412201F000C1;
	Fri, 30 Oct 2026 23:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793401363;
	bh=hzGO9HATSXKPRUeQY3W+HyUl9VCm4oUOm3DYY5spgbs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=clZEhLLH2OjXqKkR9L4IFzmqFQNGskbC06ZaIAomCsLjQ8a8eVmKsW+qLUPXtTbvY
	 pvUH6L68NKpL59wmZ/w82scLEdHgprCN6oXKzju3cPC2ZDflfKdXHG0abju/6Epw4f
	 bAR6QYRz7euvc1sjsiLqiiICF6s/swzgDqkUrATMlqqfwqRu99hsPFmnjwp3c2L//F
	 CBuU9XZAGoV8cwHf/Dhnej+Mv+OhkuGm8YJyJQzcUHZBhfTfxfNs7WJnRsZINSH2ci
	 uCFrOGDcEalpWcQNFq+mVcx867AtDctp9bCUkIxk9lNZGlq/0ZgbpXZekjuLrn1FhJ
	 exCDVWe6wyOTA==
Message-ID: <sashiko-outbox-191613@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] selftests/mm: handle child status safely in khugepaged
Reply-To: sashiko-reviews@lists.linux.dev
To: "Muhammad Mahdi Amirpour" <ampr.mhd@gmail.com>, akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org
Cc: linux-mm@kvack.org, kas@kernel.org, yeoreum.yun@arm.com, ziy@nvidia.com
In-Reply-To: <20261030215841.229969-1-ampr.mhd@gmail.com>
References: <20261030215841.229969-1-ampr.mhd@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 23:02:42 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 759FAA0003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3jdg4rmjunmjnpf35pb6fiy8i4mijkgu
X-HE-Tag: 1793401364-715957
X-HE-Meta: U2FsdGVkX1/HWWthmLR1Nd+p2QDVQq3Xbx773Cki/fAGF40qvmDDrHUNqPD/T2jw6l7eJJWYB0l7gaayj4rPuPfq2dshAamPEw/LMPRxoNPGmKj0WGu1XBp+h1pK52snm5oI7n6MjpLiuEXgSx+JBfuWs113BTpJp/3qMNiMUdSrTvGa58ky+dF0uWzU0axWZZ8jobOBGKltzQ9XOp0EzXQr83j8UKVZIPOy4BZQk4MIkrlMIxkU07bE7IWWTOJ6wjssqeEyovStR5wsLgsIOgBCNehPXFljXgsySF+nCP+rvQTsIIShrujQIlOcjfQJmfYLbvETyLhk5V1TvtVJT/NCYYzXABWfepJhq1fgIm5uudUhym3Gi2U3TAnY+Qyd73iB/9hEHarZDWAq/vn7vztXP2SrZ/TVQmlj7z4KID4vcnG6JB8QEFJ7LtPYjcJRx431yiFdjNH5gx4J7zj39IA8T9eedhw8HFaUmQPTNfO5oPXsLihd/SaNQCHTXBF9TYzKNUepP+ajqk7aVgHXJPCfZVnfnm56HKB7Zj5qHJXXENa2zxvhQhEwJoRahldaQeYDpiEtG05JXUxNXlxlLyzvv5GJadgkjqRPN8yjJGjRGgBKgQJygw3fdQezhPHqWO7eD0XMiza6B2PhdUTanbpo8LEEDQE6Vrv4nvsLVsJqDZ9H0fKEpoASzbNjtvg5fswu/B8HaMRaaK3rhs54fb8nh1nfyw/1EILp6kqqHTJmhrwi0V/Oejt3ipVVDfhLDZpzKPJ4t0Hp1CASQsQk/nWAygNQU0XX74vCDZdcX74kqP48XteCCq9mOTSu+PByE0bQBM5ESIPC+R2M5S4QrtuG8ekFafRRV/ZUy4bbKjXjMxE4AJ2jihkXsyQgqUMk8WymbjhgStiWt6x4xS2wvAW4zy20Lr6envd4WR0YE+NXRLrXXOG4ElPY6tbBwjuA0s17m94N6aYaNBLHjdf
 klgnM3dn
 NLs6NrUVWtX67ZDiWXkx5Kb8jXuG78St6UjvzbYSJhx3y23M7A+lHripWYGbhXrx0PSXzsn2xj6TaLzzoFvnERxwlkPpo80Ar+8QZyN+ASnDLrLhRbrgHNmm2wsdS3pl4eSm3FJWicLxIT71id6NU11jMi/rmqJIG/FdzX6vIWFVW0Ww8suSppSepwvAFEdzaN9Mn6DeKrVZXac+GRWwQs2GPpnHYhce71QflSOulOCMjiy/EW6M36/GXNVoWTe4hUwwhyHocmEkdhZzYspomY3Q8PTQMcblR/A0vyAi1kjJGyQWvzWyz5EUcDN2SAhv8X4iEFaO0LV85HpmKcyjZAshia7cFoPWRtjqjCsKdeumn7GldjxWrzqxZQrnPFv74LkEx1YUzdR3iZMsqvpvPBLvy30r/zIbn4s/Rl+Q5qicz/kfOUgSXPrNJemJAzLKOSRh4WEwW/0rEEfLodNDlBxvceoJ8zt/WD3yl7qWXyLkcMiLCZf/ffBc74lhBjbW1KVRE2xGkCH2gadlFMtPmciz4tzuxccN8LE7h3obz/JwVmMdTKE0zeD/3yrHaylH45O70DxYFtejP1dQ/ZlnMqtLrRGh833sTazzInyV2q6XMQIOSBUIAdi5dHFEMuCSmNRbOUuWGncjrL4CGi6U7dzjrR7CQqcCu0eKK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] selftests/mm: missing fail() on child signal death corrupts TAP =
output
--

commit bd942a41aed26d067e3b1b9aac04d7c243204d0b
Author: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>

selftests/mm: handle child status safely in khugepaged

This patch updates collapse_fork(), collapse_fork_compound(), and
collapse_max_ptes_shared() in the khugepaged selftest to check fork() and
waitpid() return values and verify WIFEXITED(wstatus) before reading
WEXITSTATUS(wstatus).

>     selftests/mm: handle child status safely in khugepaged
>    =20
>     The khugepaged selftest reports child exit status through a shared
>     variable without checking that the child actually ran to completion.
>     When fork() fails or the child is killed by a signal, the status is
>     undefined and the test can report a false pass.
>    =20
>     Capture the waitpid() result and distinguish normal exit, signal
>     death, and fork failure before interpreting the status. Report the
>     child's actual termination cause in the TAP output so failures are
>     visible rather than silently masked.
>    =20
>     Signed-off-by: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>

> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/self=
tests/mm/khugepaged.c
> index c81e0a6c6c54e..8de9b1746e632 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -1009,6 +1009,7 @@ static void collapse_compound_extreme(struct collap=
se_context *c, struct mem_ops
>  static void collapse_fork(struct collapse_context *c, struct mem_ops *op=
s)
>  {
>  	int wstatus;
> +	pid_t pid;
>  	void *p;
> =20
>  	p =3D ops->setup_area(1);
> @@ -1021,7 +1022,8 @@ static void collapse_fork(struct collapse_context *=
c, struct mem_ops *ops)
>  		fail("Fail");
> =20
>  	ksft_print_msg("Share small page over fork()...");
> -	if (!fork()) {
> +	pid =3D fork();
> +	if (pid =3D=3D 0) {
>  		/* Do not touch settings on child exit */
>  		if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
>  			success("OK");
> @@ -1036,9 +1038,20 @@ static void collapse_fork(struct collapse_context =
*c, struct mem_ops *ops)
>  		ops->cleanup_area(p, hpage_pmd_size);
>  		_exit(exit_status);
>  	}
> +	if (pid < 0) {
> +		fail("fork() failed");
> +		goto out;
> +	}
> +
> +	while (waitpid(pid, &wstatus, 0) =3D=3D -1) {
> +		if (errno =3D=3D EINTR)
> +			continue;
> =20
> -	wait(&wstatus);
> -	exit_status =3D WEXITSTATUS(wstatus);
> +		fail("waitpid() failed");
> +		goto out;
> +	}
> +
> +	exit_status =3D WIFEXITED(wstatus) ? WEXITSTATUS(wstatus) : KSFT_FAIL;
>  	if (exit_status =3D=3D KSFT_FAIL)
>  		goto out;

[Severity: Medium]
In tools/testing/selftests/mm/khugepaged.c, stdout is unbuffered and
ksft_print_msg() prints a comment prefix and message without a trailing
newline, relying on a subsequent success(), fail(), or skip() call to
terminate the line.

In collapse_fork() (and identically in collapse_fork_compound() and
collapse_max_ptes_shared()), when fork() or waitpid() fails, the parent cal=
ls
fail() before jumping to out, which closes the open ksft_print_msg() line.

However, if the child is killed by a signal (!WIFEXITED(wstatus)) before
completing its open ksft_print_msg() step, setting exit_status =3D KSFT_FAI=
L and
jumping straight to out without calling fail() leaves that comment line
unterminated. When ksft_test_result_report() then runs at out:

    # Share small page over fork()...not ok 22 collapse_fork

Doesn't this append the test result line directly onto the unfinished comme=
nt
line in the output, causing parsers to treat the result as a comment?

Also, the commit message mentions that the patch distinguishes signal death
and reports the child's actual termination cause in the output (and states
that child exit status was previously reported through a shared variable
rather than wait(&wstatus)), but the code does not check WIFSIGNALED(wstatu=
s)
or log the signal termination cause. Could a shared helper be used for the
fork/waitpid status check across collapse_fork(), collapse_fork_compound(),
and collapse_max_ptes_shared() that calls fail() when the child terminates
abnormally?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030215841.2299=
69-1-ampr.mhd@gmail.com?part=3D1

