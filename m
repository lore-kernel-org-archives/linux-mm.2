Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3100CD6E74
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 06:18:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5E6D6B0005; Fri,  5 Jun 2026 02:18:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC10E6B0088; Fri,  5 Jun 2026 02:18:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C61F96B008A; Fri,  5 Jun 2026 02:18:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B245A6B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 02:18:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4540B1C2821
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 06:18:54 +0000 (UTC)
X-FDA: 84844855788.13.4B674E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id B545F18000A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 06:18:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FT3tc2pQ;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780640332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ljlhAD+FthrnWm6kHVmP5LfpGexV5pKH196BR3ZEKv0=;
	b=cfAZDLRs7UZNpwUuTn6f+MKxlwB7zGneTFPSOevllAdhUWpQcsKoTPIxPrQYzD57SN4Nt5
	ijlw9GSJm+odkTb0g4hDUDPORdkrpvJKs70OynG5by9svnkuoIvEvK32ryxo5GOtRpHTSs
	ukMzkcqTuW1WgsBLi653BnqcFvl+uJ0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FT3tc2pQ;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780640332;
	b=XfbCXsWc7EL91A5dLcFK1AtkdvoYtNZAPvTavUf3zhPXQ0fIfcPl4XeCInM6hkqFD7nGL+
	s4PCpwCZ+4NaiCcQQi0xg/+ih1B9kNlr4ZbIVYwWZqSTcPAvHOq40nbm5y/VCYZZgl+eFa
	eid34M5yUrVBzAL6095dRVeL1pk21PA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 21E68600AA;
	Fri,  5 Jun 2026 06:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31EAB1F00893;
	Fri,  5 Jun 2026 06:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780640331;
	bh=ljlhAD+FthrnWm6kHVmP5LfpGexV5pKH196BR3ZEKv0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FT3tc2pQo4qcYECndowkFVcJjTXk8lbUB6+Gp3P9GFOaIyDZWlWQJc83biab9wTGh
	 L/5jo+QNkgrfBNRpWwJe2tc1IVrGgxBBtH0eieuXnUoJF6btMLd6HOG/DHMjxn1ck+
	 rmqcKv5csTs438PnPUtgOTb5xkfZcLGgoP9SH/XG29Q4YxCGAlFoU1HJRGrRMNVwOO
	 /oNXpIzPR8ln/fJrmZ71eDj5vtbWio0gOG1KJs13OgTvHajTTssQXY0jolrHtz8dFL
	 Iy71twMK/4dXkk9qUMXs25m+EUZPHAaxk2t9V6G/eTNWHTy2XHgXYdx1e9D6sncZJW
	 bLwjENrvVhi7A==
Date: Fri, 5 Jun 2026 09:18:44 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/5] selftests/mm: refactor pkey helpers and fix mmap
 error handling
Message-ID: <aiJqRNerYkMIo8kV@kernel.org>
References: <20260602070119.1452308-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602070119.1452308-1-lihongfu@kylinos.cn>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B545F18000A
X-Stat-Signature: kch44a1gab1nz6g467b3m5qfa8gtwj13
X-Rspam-User: 
X-HE-Tag: 1780640332-683586
X-HE-Meta: U2FsdGVkX19jhz8aaGDdU1KRlIr0tDcwnEzPhZ+KAPk7kDCqHHYvhKT6YdYEtQRfV0Oh6HdVykkrSeaQ4xrLNJJiJI12daucdBxfow10VMPHRsfe/tWLAXRN+i+KXOOt6FHmM2dQNNCMDgVqBVS2h3nkIFcK89fi9Oru5YY7DEtTSqAAozYqTrd6v78BXwzu+KBYa0qza1wA5IIyoSDhh3y9E3XZKk2o21xk7Gv15j3wlqWTrDUHSfyF9wd1sqlIveuuYYoaT86wo7g+1R3IaRMbLefub5QCXRxMD+CqKE5TCcXQSK+2Iwj+TWwAIBFPrGifR+spDIotBVSG0Mz7KQSjcEJn5llgPwlXoy91xVIpbIk3B5beNy+Y+OzWMBHPPOAznmZA2xFHw8POTwUEtyrRJe/IhdTU6hgnAwIeQIqZOgA55mC70+Zwa589OaRo0/CZAI+ISsa7AYxrM5mpkGLOmLXjUhh/1jEMOsJFJpMxv6rVpIy6s+hw4sEm1efWd0lvcywGIGVyMCmOWm0cP5nZ2jAoxmKbIs5g8zvyczECyapR2Cgq4ILiEleK3z5gYg0aZCPW9kEieNdU+dDaCQZX6ALue0ndI28ZqTuiHhuQGgSVlFdTXIn9KS1MmeLzP57YCcS7aQ2gYPb4yzLzoM0h/43LjWO5VMuAxg/N6uiBlNXiG9oV4XOSXuRxUZV2t5ee0joISurfG3LUOJBay7RVAAhr0On6JCwvOwUZE/k5V5CrMbEDu0UwIST+LdGnI3/34fF87c+2ZKzdBHYYEcMn2AszasWbNVwD51OCJ1LDFnLvot5/6EC0fcKDXED7icj+uDO4LdLwlPCGy7wc5eBVU19MuKAFRz7YjbAGbc5oonjUD18CxP5CbZVa6b73550Lxol8V08hsMJ3tLkt4y3CVvhkrHFvYFmtSitRfs3TEx7xPFyz1JEsE3OfLxjtAM2ooVDngfKPkWdB4o6
 c4ZUpz+q
 mQEAkKuH9tcvLc5DJ0F/jpan3o+K8Nuzf9T3NbhWfjooHROyhQzhqy4aMlOKBBa8fWBzhTcGJ8etrfJsiBlwxRHVPIFUVuDcf1Q1kLpradB2vnpGlkU3rxKioLpevDQv663WAcVIVR8mk827jWZF6mCB1Bukiz3kBxhiJVHBp4C5jg5nE62DcRMNkxrc77knJahDNmmHDlHZ5UakzD2JD0v9OHknL/uYCUEHcd9tDUr5P99fZVKeiskqn9rT1xfBhDIgb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Tue, Jun 02, 2026 at 03:01:14PM +0800, Hongfu Li wrote:
> The main changes in this series are to refactor shared tracing and assertion
> helpers into a common file, unify both pkey selftests on pkey_assert() and 
> per-test tracing for consistent diagnostics, and add missing mmap() return 
> checks with MAP_FAILED used throughout for readability and consistency.

We are too close to the merge window and this is not an urgent fix.
Please wait until -rc1 and then rebase and resend you patches.

Thanks!
 
> Hongfu Li (5):
>   selftests/mm: move pkey selftest helpers to pkey_util.c
>   selftests/mm: unify pkey sighandler selftest assertions and tracing
>   selftests/mm: use pkey_assert on clone_raw failure in pkey test
>   selftests/mm: add missing mmap() return checks in pkey tests
>   selftests/mm: add missing pthread_create() return checks in pkey tests
> 
>  tools/testing/selftests/mm/pkey-helpers.h     |  4 +-
>  tools/testing/selftests/mm/pkey-powerpc.h     |  2 +-
>  .../selftests/mm/pkey_sighandler_tests.c      | 81 ++++++++--------
>  tools/testing/selftests/mm/pkey_util.c        | 86 +++++++++++++++++
>  tools/testing/selftests/mm/protection_keys.c  | 95 ++-----------------
>  5 files changed, 141 insertions(+), 127 deletions(-)

-- 
Sincerely yours,
Mike.

