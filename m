Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57396FF8867
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 01:11:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F58F6B0088; Mon, 27 Apr 2026 21:11:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CD5C6B008A; Mon, 27 Apr 2026 21:11:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50BB66B008C; Mon, 27 Apr 2026 21:11:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D88C6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:11:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B445D403B3
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:11:32 +0000 (UTC)
X-FDA: 84706186824.30.9523C77
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1FC2E1A000C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:11:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nx9cBZLN;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777338691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VYSoSKymAO3SSGJ8r7Giy/A3clf5qUlR8ykg0323Mfw=;
	b=hT9R6N7W2/fBeQ6PSArIiUzrxdGPTVo04hfGQDY+mWxHaDKtbIoqMNLlgMeSjd19eBPB19
	amVW4OoKD21Putrlu6edeVOWCER7sVJ4GebEGLuzyy3mOOJMYLX29thbbzo8U+7d0LGSyq
	qcf/kqm0RqnGqN2xk9QFYo75kQXBM2k=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nx9cBZLN;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777338691; a=rsa-sha256;
	cv=none;
	b=UtE1Sj1N2UwPA8gFsU4Oq2hXsc8QjgNF54BYqae2BcBfOTwLui6Ez1OfRoR/ygINLqPjky
	X6sYSvyIPu70YktEqrZqsgIgEofN0Dsbjicnu14FL3RBrFLSlzVDCO1ZQJKyDjFvvCNWBV
	0IQjSqNj8Ok0ln6reK7IxbJDfvI5KFc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0172760121;
	Tue, 28 Apr 2026 01:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F56C19425;
	Tue, 28 Apr 2026 01:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777338689;
	bh=0chybH7wDbE+Yxx7fnZNf/D9EykYuOuLrNTgRV+W8is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nx9cBZLNU6RhYrZt7DSdNNRGo+eHDDen6vRfRUrjaDxGmSgWrkduggNJxgtpIIplu
	 fx0fovQZzL6DiM2k+cAiBcH0xCHq4DskyH5bQ/nBG2aqD/HFgGKJMTkEVNZDpH7Gge
	 OSkjdb70B0n6yWErKWNmS/3ng4MLp2bDgknxaSCN2M27nJmi4uCU1zagGb9dtJU4Rd
	 L8hu4jswqM2SOqvI6kv58dp/UEQ6/q2ECDcw4QehFRkgXDmqN0oTQVqUu0mPDRyg+m
	 N47Wlqs7hBkKtA3ORURRcEC/mGIInrNjmtuoVGHcdhYZW10V5eRDTi4lyr+54TcmvO
	 6PLA2yEMWAkig==
From: SeongJae Park <sj@kernel.org>
To: fujunjie <fujunjie1@qq.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2] mm/madvise: reject invalid process_madvise() advice for zero-length vectors
Date: Mon, 27 Apr 2026 18:11:18 -0700
Message-ID: <20260428011119.113840-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <tencent_BB588C2CDED859A873093DAF28B2CC1F7B0A@qq.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wwmektio3u9kb6mk3zmatz4r1ehayo13
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1FC2E1A000C
X-Rspam-User: 
X-HE-Tag: 1777338690-558046
X-HE-Meta: U2FsdGVkX18Nw6VoF2Fa2MGe4rfjWrLJz7UbBOHV77OmjyaJ4k8+oGeo8AM8DIsej5drMdBmSuCIBWvuVR9WyPCqIjVDAs2KYm6Dwtf7+xeolKgHBhEjxthZgA4dk0CoeU5yQr+fZsBVm35onHjntYnYDi/3hTKSTYQCLJmuHYE+eIpQgh38UmKIR7eurnWpQaIBcEopXSg+O0gKv2j7EDITT0O1dqTznDkKPDyjY42STA0d3FM4LmnTJJwipsq2EdYxLl4MRVvVztXk0U30gd4wlTnixIisYC4NFw99G/uJ/bhZXyUbhwuUxeeC9BGBUWuuchp7TZtYGcpiV+TLc0tGIZtcJ2cWfPHeUnGObsytoWVMULvB5UtPlERFfMOkiDW73qapo8wMZudv+UmTEjEoKuGoDsfrflMc11CoUcTbfdKN2sk+RlwuVuw6xGCY6X2jhJE9DlvhXzOC2/TTWyP/zhGH3+j+v8kkejP0U4RyIP2CHffSDG1pxRLdzCQYOCDbw1lDyWTMKaegKnh/eQUArMC2zlQUz3vnYrDYJ+4J2dEu+6+UnAXTDj48nTtstaH+3N1/veythiGvYJlY83TiDIRdImAGM2xe9QcZbwgaA+PedZUSmzJlUP+qagtef0qpcVMYeKDcFhpmSg69xKrgWrlV4Qo+dMshijtxZTrlcqsPfvWRv1W/stOLgylTXxJ5BibDIM4U+TSXrmP3pkeB+KbFcogbe3SV8gcnCm9qRqJ7HjPiqh6KZpdkvCumP7zEzNHgm9b7yEavzz0JZ9vOeLgKBtWDpm91oZnW2V7bnlng/PpYjXrMmm9ppq7XYGC/dvnMk25b5LrPXsjCdINWWPqPaeEaOORNvqjAYYL9RzRPvfyhQbgMwVfOj+JEU7sgP7tf7sO4OkJRrHKI/fD9VY6HH7gutJfZUvi0HTKSrmFfx7yntvVKakMlV8JRv+HaSXTSMhLVKS2ajdj
 BD7upTBr
 kZf2V65GUhak0ZMBnIX+SYFH8kSpTIpDr9g5xUyNpGCVhc9wjxelIFMcv835okSGQdihxuRueY8kHT0eiaBgowq1jdziEChDE73EPkfP9hIDS83vFIfK+9lSyts5gsdeXkFofMubyP6RvTtYzJQBEKVF32woxjUTfaJtqwhS1iZN/VZ4W5LYMRrbVAS6fOFyytXQSqPy2iNLIoFccYt2FzXQPesJ3LYSp3Sgq3XwgEyAD3UhtScYDHhZgy3DlAptiRSPma34gPyRdgbop8Vvh4k7FvFDpdjwA2jADmLzSslcsPOo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Apr 2026 09:43:30 +0000 fujunjie <fujunjie1@qq.com> wrote:

> process_madvise() used to validate the advice while walking each
> imported iovec. If the vector has zero total length, vector_madvise()
> does not enter the loop and can return success without checking whether
> the advice value is valid.
> 
> For a local mm, such as process_madvise(PIDFD_SELF, ...), the remote-only
> process_madvise_remote_valid() check is skipped. As a result, an invalid
> advice can be reported as success when the vector has zero total length.
> This differs from madvise(), which rejects an invalid advice before
> returning success for a zero-length range.
> 
> Validate the generic madvise behavior at the syscall-facing entry points
> before any vector walk. In process_madvise(), do this before the
> remote-only advice restriction so unsupported advice is rejected with the
> same priority for local and remote mm. Then keep the per-range helper
> focused on address/length validation, avoiding repeated behavior checks
> for every iovec.
> 
> Valid zero-length requests remain no-ops and continue to return 0. Add a
> selftest that covers invalid advice with a zero-length iovec and an empty
> vector, while also checking that a valid zero-length request still
> succeeds.
> 
> Fixes: 021781b01275 ("mm/madvise: unrestrict process_madvise() for current process")
> Signed-off-by: fujunjie <fujunjie1@qq.com>

Looks good to me.  I have trivial comments below, though.  Because those are
really trivial, please feel free to add

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
[...]
>   *
> - * If the specified behaviour is invalid or nothing would occur, we skip the
> - * operation.  This function returns true in the cases, otherwise false.  In
> - * the former case we store an error on @err.
> + * If the specified range is invalid or nothing would occur, we skip the
> + * operation.  This function returns true in these cases, otherwise false.  In
> + * the former case we store an error in @err.

Maybe we can keep the second and the third lines of the above comment
unchanged?

[...]
> +/*
> + * Test that invalid advice is rejected even when the iovec has zero total
> + * length. A zero-length advice is a no-op for valid advice, but invalid
> + * advice should still fail with EINVAL.
> + */
> +TEST_F(process_madvise, invalid_advice_zero_length)
> +{
> +	struct iovec vec = {
> +		.iov_base = NULL,
> +		.iov_len = 0,
> +	};
> +	int pidfd = self->pidfd;
> +	ssize_t ret;
> +
> +	errno = 0;
> +	ret = sys_process_madvise(pidfd, &vec, 1, -1, 0);
> +	ASSERT_EQ(ret, -1);
> +	ASSERT_EQ(errno, EINVAL);
> +
> +	errno = 0;
> +	ret = sys_process_madvise(pidfd, &vec, 1, MADV_DONTNEED, 0);
> +	ASSERT_EQ(ret, 0);
> +
> +	errno = 0;

The previous sys_process_madvise() is expected to not set errno, correct?
Maybe the above 'errno' reassignment is unnecessary?

> +	ret = sys_process_madvise(pidfd, NULL, 0, -1, 0);
> +	ASSERT_EQ(ret, -1);
> +	ASSERT_EQ(errno, EINVAL);
> +}


Thanks,
SJ

[...]

