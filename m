Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95315D277F1
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 17:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD88C6B0088; Sat, 10 Jan 2026 12:00:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C86BC6B0089; Sat, 10 Jan 2026 12:00:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B92186B008A; Sat, 10 Jan 2026 12:00:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A4E266B0088
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 12:00:24 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 38069B702F
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 17:00:24 +0000 (UTC)
X-FDA: 84316667568.29.14733EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 800B980007
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 17:00:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bDpCNj8k;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768064422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F00Fdss0UcKVhP5HxZTbtV9Abfn61eKwFnOA+LShqp8=;
	b=0uHAgpdrBvPb3D5xKm1eaeR5/dB95azQ6zR7JdU9C3H8FQvgT+du7XvDmmIjRkniP4Wdlc
	MnRhgMa1gYSDs+ueQjCXPcWAy1qSYMR3Fv8S34K6oOZOgYBI2vDteGPbyZxL5LeeE+sKZx
	K1JtXcsFkUeRMl7QcoiGlb76mKrT/BE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bDpCNj8k;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768064422; a=rsa-sha256;
	cv=none;
	b=zSWwXGQf+RH8LH4/QJfBH7imLj2Igq3biCMA6rHq4qEMwkqXOg/bJbld6ncvXRamF8Rs49
	nAEOPtrbQAswfUMAhjJ4AzHzOTkKtK4NRj3AHZGt9QKfl7EnylL8ELqhx7nUHC9Kx5hHyG
	hb36SVJQPmAMnQYcxKZc0cT4EqY5sSY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A63136016A;
	Sat, 10 Jan 2026 17:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325CDC4CEF1;
	Sat, 10 Jan 2026 17:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768064421;
	bh=V2EsbQnIGOXbiEaBQhRAkmCEvxvJGLXrXAm5c9fgeXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bDpCNj8kZgAWpTJOtgR8EHYMVkM9W990TxrbO5nQHj4I1tnCLZlVyNZ5wc6zzj63a
	 7Z1mEc6jfXOZKMY9WjDQBp+dzJX2atByn3604GYQxnFJFfWnDPY7SPAc+GOwzWhB0/
	 IrpXHMGZnhhBSBLHA75fDXqFecv4rAyamIOvaxf7bmsrEkCWPc9vN2KoZ8HM30bwGO
	 QPszjTas/Si9CzyTXrbWTF69Lwlu4/b8Acgt5R1YD/oREOW9IX+Gj5H6riCJ0gmNgy
	 hyWEp76NVfebHSwa0K0dOuz3dlggJZ2z6hjL0b+fHqnz7/XCIB9VPK4ItofIFwRDLR
	 RhquU7OX72eTA==
From: SeongJae Park <sj@kernel.org>
To: sun jian <sun.jian.kdev@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: ksm_tests: skip when not run as root
Date: Sat, 10 Jan 2026 09:00:10 -0800
Message-ID: <20260110170013.88614-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CABFUUZE50X=PXAK0nFC1qhj4GhZ1FQJ2T2Jf8M0APE6s5-mgvA@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3awizgp97suupnzqyex6nneohqohhrx6
X-Rspam-User: 
X-Rspamd-Queue-Id: 800B980007
X-Rspamd-Server: rspam08
X-HE-Tag: 1768064422-792916
X-HE-Meta: U2FsdGVkX1+l2D7v017EobgNFgFmmjngxgDAlxFC8v15xBg8ZZjS2iGhuWagENKQhT8WMJEVWrw+tJ+QoX/izHt36nwtFGuneRVTUHG+gfQj1aYa29FP6u2Xwiu3671Hx65ithwsvrEyuPeg8pdysPgx8lB+mpB/yl1qKMCM/pJe5eqKAcmK93Tsj91m7z/z9xj1zQPD600ETY2Hx1NzatGCCs9xN3aZ+VORx91nKnYUGphJAkDuaFPF0nzALRmM9YyfYuBbmGEbibRV6v46x2nSfps+POuVIdNgYMPEXswG5LTz9vjMQtXNSKO/etUEiy1dYWpwgzkAZZogzgqrfHDfGvIyQg/WPWaFzdWh25EvlREOS8z9zugLl+odkzhmpMzQCUFiPLa5pQwDj1rrVPKQTooat7SQNmM7B5SQfLMFMpRnI1EWeAgaCKzDD0zFtk/n9380426vS9KsU54kCxrwpua0i182ruygEEG6grc/PgY6umaV4tgsbdaohsBgn4bvjpmsArMIe8DRYCPTt4PYdVsHBYS5OnH9S5A1JSzJLO7IEPPteTofmVsIqUceYWtbNOMYHZAbP4y3y9EKKnwCrKxGCrabWMFFy2JLkN3/AKwgpR/pHvmF9YWmuxTZh82NQ4o3kzThmLCUtGwoz1Mkb4M+obSXrVICwZd/uC6oavj118Pky5rFGiGQ9i8iqJcgq8nTfLAd4o2Z4LoOHPx9XN1OAJU+LJWVHOl/vA94LkXotfrvn4ScE4pFQUhA4H1E5xXKmEIIvVYSxh37an2Woq7pzWTD+tVR3OFpb3h0GVQ1O0HItaYUk2MGh+lCqNlDuOEEFKkJJQ3gMiEbEqYMYr/YI67RfOVjDMcBa+7dIn3Sl9rcIWOfr6p0d/Spr2i05DUMXun6hXMG03rqoBT8dmRVr6dW7yGv4K4xGxLhBsFSTvXPduWj784TeK9QhOO+Sry9lvTleO/fZzS
 XgBME7Xc
 fhbpTkqxtGD+13oH8PhkKQscJ0r/FcJoy0SPyS3GzP+AMNrXRVeOEzXlFkaCHhMhyK6ikhaYWP9/5YFKCii2Vvr03SjCU7eQwm+tdgNzIVLeMkNBay76ITbOrnaOHzdPAlEN9aNgxg9urhId/jWbn74n68Cajb0xQ1+E9P5rQ0xyEvBbQNAW90epC4yXQbYusJe+dKVIptwvFVVO6AfVoDBHKtjJ6cS99tKujo2wjbq601jKitX3PW1k01W8jPePsXtYBOKJq58u7S11g8c3yxUQx47e5STuREBXAvUZNw0ndkZkxxLf/LAZZx5QwelGqYzHqp3MiqgG1xfWV0rPFnkhz0S9hwaqcUk9KatZxtDUAQbaqLtpzkEEJvF4kme5JUXzBods9wI88xDTsX3IOxk2+Dw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 10 Jan 2026 20:44:21 +0800 sun jian <sun.jian.kdev@gmail.com> wrote:

> On Sat, Jan 10, 2026 at 9:16 AM SeongJae Park <sj@kernel.org> wrote:
> > What about using ksft_exit_skip() instead, like compaction_test.c does?
> ksm_tests is a legacy selftest binary and doesn't use kselftest harness/TAP
> APIs. It only includes kselftest.h for the KSFT_* exit codes.
> 
> This patch is a minimal prerequisite fix. Returning KSFT_SKIP already
> provides the correct semantic to the runner, without pulling ksm_tests into the
> harness model, which would be a larger refactor.

I agree such refactoring would be unnecessary for this small change.  But you
can use ksft_exit_skip() without such refactoring, isn't it?  The function is
declared in kselftest.h, not kselftest_harness.h.  ksm_functional_tests.c is
also using ksft_exit_skip() without the harness model.


Thanks,
SJ

[...]

