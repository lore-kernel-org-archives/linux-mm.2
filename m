Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FBA2CA1007
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 00:08:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 459628E0002; Tue,  2 Sep 2025 20:08:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 409C98E0001; Tue,  2 Sep 2025 20:08:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31F778E0002; Tue,  2 Sep 2025 20:08:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1C5D28E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:08:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 98FDB13ACC8
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 00:07:59 +0000 (UTC)
X-FDA: 83846001078.12.5931CD1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 060C4A0008
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 00:07:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bcIji30N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of nathan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nathan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756858078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3jtTMAC2/4/jIncozNNaDFzFVU5ZfO/Xa6gGAi+T3z8=;
	b=lb0wbam2JoQQNwUnhYoX40eh0T+oj0KcTcsZIPJJKU8/D80FcvjTPRJ01TT0cm9QGutxd7
	sc2AnF209MHsXD4duiNYfdf5DovfRI9y/TAHI5zOaj18ZVOU7YSeJ3SAIyONmGKAzK5fej
	aJ505e9I9+fLB1IYFgxRrvCee25g3Wg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bcIji30N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of nathan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nathan@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756858078; a=rsa-sha256;
	cv=none;
	b=WP4s74FV2rNXuC/7igEwMWX7Yx6cGqukaYfFtLKam5UkUnVoSlHyL7Wz10RCB4w3p9R3iY
	uvY+iagdf6ytHFIIwiO/plYTa10GzaoO5HyHrmwFwbxFKJegeNN6M0CpIiG+FoR5rhjGgj
	VxkD93/LnIUsovEQwS8nQ4NuTNyHtq4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 88B42448C5;
	Wed,  3 Sep 2025 00:07:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD23EC4CEED;
	Wed,  3 Sep 2025 00:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756858076;
	bh=1vCILVEyGVSQU/BaNJu/07EPmz9jNtXTnLe2Mcgq1i0=;
	h=Date:From:To:Cc:Subject:From;
	b=bcIji30NQLj4HZqs6v1qTXwNK1BeyyWIfPLIMl45vHHI81ftfOf1Yg2+Jkg1VdcKG
	 cVadxdARo9w0sf1cOuodyN85pJmc6S3Lt9YfwjakVHevGsrdswbHYwiGB25WLarbBD
	 scZ/qKs/DW/eK3qW8LhnqdBm7WgIxdzrl0ff/4Oa5WpLXpX7t+y2K0coTvGGqKmIoA
	 vOYt7/F6iviRB6yoAi9Eop8UXjF+5hl4Z3OR+IY7KVm1blGd0vCloEiSbI+ZYU2jP9
	 SkOZO8ZuMzyrf8xygcYg0+aYukD0j2BstHaU60z1Tem4IoWGSbkEZ2IoWluDuJK8Sp
	 cvZMmb4An4IXg==
Date: Tue, 2 Sep 2025 17:07:52 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
	linux-mm@kvack.org, llvm@lists.linux.dev
Subject: clang-22 -Walloc-size in mm/kfence/kfence_test.c in 6.6 and 6.1
Message-ID: <20250903000752.GA2403288@ax162>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 060C4A0008
X-Stat-Signature: s79jh8myar8znffyfgctdbayqoedb5nc
X-Rspam-User: 
X-HE-Tag: 1756858077-122469
X-HE-Meta: U2FsdGVkX1+ro4t3THR8GJ45TBWBr+jssQoZg+iRolnPQadr3qcorMqq/tfdIe+4QORGaQgExVumcGh7ljm1eIFVg/7oiCKX67ESaPi8blIvI9W13G7zVtGDH5PRx4pHpvlOoumjYjJkc1wWeyE8mAbdnxT4b6WvRguInhFlEkSdd35KAS6C3u3gc8Ox+vUgZUPNC+j0bZqeq+utr829HLVF+xFFPUaSOrz5O6psl0FChwl4AF4wgNM/018VXzDQwGIDRSUMdjauQX6fAa3LMT69jUbk3Kb8nrAWhiuboJftQEC31UIxCGVpnNoXtL4buH8QV3djAzHlQsXhn7ngpNqAoIGW1H1DLBav47SyI0RSEhjB4j+w+JDpGWZp9KM8YDihC7FflIZ6lIku78a81NYFX9jkCBMWODFPLcH4RyGaNxlxAV6IoVF+5noCfDB3lKIfgujYhom5I9RkVF3SefFft6NmhrkK2HljucQ+DDG+5Xq0cWfPpw8DHxRgHdExdXHDYYd9WilGwGYPkzpT4kxuC+ROERuFx4N3AaX9OU2XTbDCXrqgnNyaUuHaFqlhQVoKuUxaTbUWdjACUFAMysuyz0xsKVmjF0JxFw5ltcee3WddtY1spe3IOiq1jEGibkabk3yHHC8z0KqXJFUA9S3/bXDcWLG0T92/Fmw6B5LNesdRoZ3mDc8cx26BUT/ppDOWl9Oh/27U5Qr6iEhD3Gq8Vum2Idno1qkU3uxq8Pyw0pM3TBfMYpDSHwnjJb9yCTkwH+RiS/++UW8NVHk/K5qfKc9h0XNTaXZv5UpVJvEGEPlofxMbHDGQCFbj2f33qlBlCvS8bjPRVieiIoMIJvLPD5QaDvcX9lbkXGNYirlPoeUIE21AVeNVW2XAk4vQFcF0Dl2U1alOStkAOEpkbb+5yGKhhejP7AynAQubbtp1BdgzBOnHOjPSHJIgJLYgyHBEzqW1bqW0blyEIR0
 TEvroymL
 LWYHFZ/tYLb0ELuaZCXVHqQ/aOe1OdK+y7g0S25xrLqBolx80lMexquq0rb/+v0myIElBMNiuBvEg0+UH1tyS4uw5cYlWe6c0MoofuAcgJESZHJ/oNtDuiOlyxoZoiNnaosaHLSe0SEEfKLQy7Ggd/RSjOMq/HINoLLD8Bwx7GwxhuKO9uB8GG6ZwntYEHYQep0+UePIu0nFdRRcw8bCjwWEqgcIiJf0/9mLNndhw7UlT9iDzFfc7omdHowMSqwlaW213hoPj/O5K4O+tSwtaF6PAY95bIfZC8xctuNx5utMQbYxK5xdesTMlp4Hz8F+qfXNy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi kfence folks,

After [1] in clang, I am seeing an instance of this pop up in
mm/kfence/kfence_test.c on linux-6.6.y and linux-6.1.y:

  mm/kfence/kfence_test.c:723:8: error: allocation of insufficient size '0' for type 'char' with size '1' [-Werror,-Walloc-size]
    723 |         buf = krealloc(buf, 0, GFP_KERNEL); /* Free. */
        |               ^

I do not see this in linux-6.12.y or newer but I wonder if that is just
because the memory allocation profiling adds some indirection that makes
it harder for clang to perform this analysis?

Should this warning just be silenced for this translation unit or is
there some other fix that could be done here?

[1]: https://github.com/llvm/llvm-project/commit/6dc188d4eb15cbe9bdece3d940f03d93b926328c

Cheers,
Nathan

