Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90CBBC43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 08:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 878016B00A9; Wed,  1 Jul 2026 04:48:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 802086B00AB; Wed,  1 Jul 2026 04:48:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F0F96B00AC; Wed,  1 Jul 2026 04:48:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 43AA36B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:48:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C72BD1C1D25
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:48:24 +0000 (UTC)
X-FDA: 84939581328.09.6C7F33F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id AA4A740005
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:48:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=V+yd3ZVc;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782895703;
	b=R6aE6+3igXm669UhhPM895ibH/fIqex+eIDogZ23pvpAghp1aNlEhQQSNNPVpbUzi3yKgN
	HE7/eZLarEQ9EVfaYA01dK3BA4ftE6wV9xBgUnRQ9RbmRtFX7BCn7mFNqqsJvj2GLP/a9T
	ngqTfMutHeoNuvsBUQ/V5AazhoE/1Xg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782895703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=trF8tW4I5PQhAcDFMCw3oDscEWaHNeW1fxmzup4TZss=;
	b=z7B986xiCdDwrFqLt9cRkxHary1ECcQ7cotDAxrF0nhWoYL0GacUvLJH5aUdzR/WsZM/9V
	hR3WwxtV2f1lfoA8sik9Drgz4v+vBk1wQZC8ytxqgSHt+2GvYSMTeAjYP7Ff8gaK2WmBJS
	snDScorgGfnjLUhX4yogsrdni2PvGfc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=V+yd3ZVc;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 746DC339;
	Wed,  1 Jul 2026 01:48:17 -0700 (PDT)
Received: from [10.57.81.2] (unknown [10.57.81.2])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1A06D3F85F;
	Wed,  1 Jul 2026 01:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782895701; bh=/+UJCdimKchvp4hGnfezxanRfzPGGapIuiYXTA7gshY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V+yd3ZVcRsvvoMX6kDcW9Yk7FWoQf6lFNBopggUuDmFzBrIbEX/ffsQSsH/XF8Gi9
	 /w8d8l+2gU4/wWpktW4xILv7UCLr16UpoGRl1PGXz9e+bSuXUX+pDYSSSkdgdDRxe6
	 l/wHDJm5nZybd4OP1nB0xhQl6zxrtRCknQr+choI=
Message-ID: <d8a1c72d-831e-4880-ac00-5aeac41ceeaa@arm.com>
Date: Wed, 1 Jul 2026 10:48:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/5] selftests/mm: unify pkey sighandler selftest
 assertions and tracing
To: Hongfu Li <lihongfu@kylinos.cn>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, keith.lucas@oracle.com, maddy@linux.ibm.com,
 usama.anjum@collabora.com, yury.khrustalev@arm.com, jhubbard@nvidia.com,
 joey.gouly@arm.com, zwisler@google.com, hongfu.li@linux.dev
References: <20260630073235.3802271-1-lihongfu@kylinos.cn>
 <20260630073235.3802271-3-lihongfu@kylinos.cn>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260630073235.3802271-3-lihongfu@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: gtnk8j19n3m6k6cdsfu8nksh7tcdfmgo
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AA4A740005
X-HE-Tag: 1782895702-672451
X-HE-Meta: U2FsdGVkX1/o/lDef+8UFY79V0z5Bx9lWaYEgaeFHmbSc36m/zVbb3Sbz4tUZfMUgicWtL1AaUnJxir6Qj94XIe1QzUSgOT4qRTTIjCBerqGb1Pe2GslfsJ4183PoI2vVM5fFTSEhCc8Sk5w1kP3s0Gw3UowGj9U2KEEybSoMTM37nVZ3ShKch7CyfR0Wp39dpJfaPuxZQ3j9AnSNesntwFsgD92Wif7CDu+zyoFl/hRkPANU9wTmLcr6vGwVe1i8lfPQJxcj33fKgMKbnqH+pzTfBwC33Ghg2fG0xnYutm1cOi7llAUa4NQNabDNCcP5qrINwd8r0H2P6bRfJ7RfWeBT9NZ8czwhCWpSMD1EzH26PhaE37fWYHA34c1QqtRY0sv0Bz74j8LhTf/Y5bf3LdHfcJy8otICoh5Ot/I/4w09ysXU5Ktux0lV/lQxCe34N4/WrynJzH6YReSaiSSqLXZePY4gLCFz5K6QBxmakhHZ6EdhJKISB+7cnX0dkdSv/ocpkXkZS8KBVVDjFUWv1cr5w1yrPtTJEtX6X3+mH3Mg8bRpFCOw7DOumT1lnaPs4cEBfui/+fCFbIP3z0OQ4lST9O0P5igRP21kecqMgD6W4InHTxFES/9FGQWZKH6suPZZKOU6CQrbswxTk5EugfihZ1kIROumd2zlVx784MPrnGj5fz4XmTo/1jSRWoNvATGAQ8lZ+OW5PkHj/pPUSyMl2hj0OzbjIRL8A9VYg1YbvhH1Ohmj0paD+uqVoECON8DSOOYuaSdqPp31sRTfC2nrLj5Sd2j5WE4EzcrpfogZjKk8XNfRQ5aR07aAGSXrVMMZTF+zmxV+EqNtxlBhFhpBMcDYNBJMaf6HQJYv40odm+kJbhDq9ARFQWKc4RHNJqMkSI6omlOFb4Px+v+HykqfHXh1dje+nYueKgF0rH7yD1BE1nEQBgzP9bNwGH2WmghCGRP+Jcd44Z5NjJ
 M+1Gt0AB
 fBMt8eXwXJhnuZnvmAys7EYvLK9JOr+TjVD+Iiqjy8LcEeMvsgvL+nbSGpepIX8dqCAkVTzH1VlxRlYFgYcc01/bH9RHd+uGmyQFc+RK8c0INPEBZlsCBnlXIDQFVb081lDVz4VSwS/rHeAN7/UTpH9stZ8dHC72SW5+pDvi9/8E8FgG2/m2uyyrpls7MDZjKlSX1JVndYkgp1N/ex8ImOG3R5dENyjMkxAyIbGHGKqr4ACA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30/06/2026 09:32, Hongfu Li wrote:
> Add per-test tracing to the pkey signal-handler selftest and use
> pkey_assert() for error handling. Each test enables tracing at start
> and disables it at end; on failure, pkey_assert() calls abort_hooks()
> to turn tracing off so ftrace is not left enabled.
>
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---
>  .../selftests/mm/pkey_sighandler_tests.c      | 69 ++++++++++---------
>  1 file changed, 36 insertions(+), 33 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
> index 302fef54049c..085e771227fb 100644
> --- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
> +++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
> @@ -19,7 +19,6 @@
>  #include <stdint.h>
>  #include <stdbool.h>
>  #include <signal.h>
> -#include <assert.h>
>  #include <stdlib.h>
>  #include <sys/mman.h>
>  #include <sys/types.h>
> @@ -36,6 +35,10 @@ static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
>  static pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
>  static siginfo_t siginfo = {0};
>  
> +int iteration_nr = 1;
> +int test_nr;
> +int dprint_in_signal;

Might as well define those in pkey_util.c as well (move them in patch 1
too).

> [...]
>  
>  	/* Use clone to avoid newer glibcs using rseq on new threads */
> -	long ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
> +	ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
>  			     CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
>  			     CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
>  			     CLONE_DETACHED,

Align these lines to the opening (.

> [...]
>  
>  	/* Use clone to avoid newer glibcs using rseq on new threads */
> -	long ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
> +	ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
>  			     CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
>  			     CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
>  			     CLONE_DETACHED,

Same here.

- Kevin

