Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D01E7D3C523
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 03:17:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CC236B0006; Tue,  9 Dec 2025 22:17:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17CA76B0007; Tue,  9 Dec 2025 22:17:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 092956B0008; Tue,  9 Dec 2025 22:17:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E74E46B0006
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 22:17:14 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8600F13426A
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 03:17:14 +0000 (UTC)
X-FDA: 84202100388.16.164C371
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id D08A340007
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 03:17:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ghvhOZpb;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765336632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hwl39gP5LhIGds8/fRsoevIbwLpblZNJ9LaYDJmQ4cw=;
	b=6R6f4CJyrngBHUqi8hQjt8ErovvDjgphl0anUPMWlMHi411P0aU/agM6GuasbZnZEcF/aa
	vy2sG/zefDtKvrccpyP6Ij5BkSQMYvzv3JnwbxcLZxKX0IYa/gtlfzvVrVULNLpBPf+M1C
	SdbcUNOdze+8foBxtSMejXGVSijt+5g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765336632; a=rsa-sha256;
	cv=none;
	b=E2PYWIDQ11DJyfT60AQ3mVb4S8DSUU57aZ/sg5AyhgdUjJXN5XnflyhhrNZlT32DxgHXw3
	9uSGP3hi1BXzWA0BDLhWQ5X9m0aPfXQoG2t1p6oSbURBI7tNjXt/7uFpk6fzhmMxvPzPjn
	tBaZHT0E52/Z5h9IpeiH1iPLITOq9Tg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ghvhOZpb;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B37A04331B;
	Wed, 10 Dec 2025 03:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5C1C4CEF5;
	Wed, 10 Dec 2025 03:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765336631;
	bh=oFC4rlmw4f40JFnC2sGvQ14dxbnmpRBz+l7wNNAnfCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ghvhOZpbfaO3XJMZJoEiOyMK+VS0mH2S6ExjUyZJZ+O5QZR9c0JqxnUi7bxNVcTax
	 mjAvz+PwY63OWx/Cwrla7czaCywQesDjbdkaCk6k2mQ3WlfnFIiisO49cYwYYVTiIW
	 RglGDhD0ZbijUDunL8QJT4wgoFDfno7H0WYqDCZ4MJ2I2nk5jzzx3Clt6cgtLBeUIH
	 IUXIbb8f8jrc5Ao0dmJi3lYb6RC3i2HuTQI6zybW6e/N/W9UEnXjC8YW6LdN6/d1ZL
	 x6J1KmleD2LYU/+EedVlp6ZruLXH7pUXbKmFZnAkHZE0r7SX/XPi5QZogHvJ1p0vZU
	 bOhzYovmw6NoQ==
From: SeongJae Park <sj@kernel.org>
To: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2] tools/mm/slabinfo: Fix --partial long option mapping
Date: Tue,  9 Dec 2025 19:17:07 -0800
Message-ID: <20251210031708.53876-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208105240.2719773-1-kaushlendra.kumar@intel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D08A340007
X-Stat-Signature: 79tcqezxxz85hzj3ehb1bi866rmpgjd9
X-Rspam-User: 
X-HE-Tag: 1765336632-815790
X-HE-Meta: U2FsdGVkX18NQQeXfvj6r3+p6R8CRDvp0sRgNr0/hDxKYKfSZCsCjGDN1/LVdp/i6QTquOpcnuHRq1jJzHArKKB4thwCETs2hp/TEnjG3fPg3OG2PAgIZuO341hzNzFwmYBoX/ZYofkl9skkVwHa6RSCt6z/Pz3Hg8Z1eAqPS9o/jDCfUKgNuNaZ6i9TGP6iKCiMgff+ML7L78xGJd41ien3Sjb3/AhqF2/r3NjlGTDaSNzHNtrhR1bgOnKjmoNm4H0tEmo0qZOK8eGcRyZ2ORsFk5m/+k4L23jnTDgObxAovXcLlPKI7QOGPJkHwtqJqW00l/56J32TPUZGxJE6a3P2Vy5MEvlErEmA+jXULY61ooXDouMd5DcCe8ZV3jPctRodYzd5YbnwTEJjN5CUNTdW9bJDLfLjj3hTAdNAY9rCDfKvDtvqhZC9wYr4Ns7+UnqjEyaaMwhAQaPQy5D/IOL4pkJwb6u/3mVzF/PKxqCsX4GJ45da/TbJrk64Yf15WPHKJyquU9QKtUAHghKcUw9BG+pRYBj/7A6wQ9lakWrTBM9E2pFAZ23GF4ltoeKuwL+Rn79gcmypAeBaxq9sK9fVt3SytYtlirzNEJS5Mc4kZs3Tp1EjViBmm+shTdPvlMTTEHcHR1v5FSuY4qWxMwZU1w+ZhzC6eQMr1n0bwcePeUAlgxODmpUbiGzmMOUfqOPDPLQq1W++Pb09cuFs0AaysfHSBr5diGO1SBAXOdut/9qY8yGMqTYEFd2Y6Yx3ommTXFbik7DWzrryLcRa7QV0DxRXxFqv0mhVFqVDgRMFaVXqx08Ht6PfsfmQqOakKeLG02os+xqOb37E144vzOPKThv/IY7Mre46N2dB3aTQN/WUBuhJ9bnuukR9DV/9H8m1Ho+DxoeFudCtWEu3nOLP3Fe6WArqJwPd0IqY+mja7hYcqhCIoUEvZBDJv0bC3bViXxVZ8aS/HqPaK9e
 1pLqCYw4
 E6cHzPNeagvGohBEwfWPWKaFfmuGm0hmgOqfQxLhbFotnrUfnGkQzz8bVJhDlgZaunHBER3oRgAYpNPglq8bDyx2SLzEwAZVk0ZpjWAuril5IH0O7+kc+vf9YlOMmQwVIxKIqLhtAB2lce3oxMYIFcPIhqWjNqv1RofQdXj/KD0ZD5SlIR2Yj06sUW3a5GNMmbzOnHBI3sUbeEptnDlXKS5nWsYry1tVKu3h2GG14t4Pb4YxdZVFNuit60TNvv3dujXp8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  8 Dec 2025 16:22:40 +0530 Kaushlendra Kumar <kaushlendra.kumar@intel.com> wrote:

> The long option "--partial" was incorrectly mapped to lowercase 'p' in
> the opts[] array, but the getopt string and switch case handle uppercase
> 'P'. This mismatch caused --partial to be rejected.
> 
> Fix the long_options mapping to use 'P' so --partial works correctly
> alongside the existing -P short option.

Looks nice finding and fix to me!  I also confirmed the issue exists, and this
patch fixes it.

> 
> Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

Reviewed-by: SeongJae Park <sj@kernel.org>
Tested-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

