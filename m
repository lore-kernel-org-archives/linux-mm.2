Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 746E9C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:04:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CE7E6B008A; Thu, 10 Sep 2026 08:04:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 880096B008C; Thu, 10 Sep 2026 08:04:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BC4D6B00B0; Thu, 10 Sep 2026 08:04:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5E9426B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:04:48 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ACE1DC04BA
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:04:47 +0000 (UTC)
X-FDA: 85197721014.03.EDD8075
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf29.hostedemail.com (Postfix) with ESMTP id 123A812000C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:04:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=VeJ9UFwO;
	spf=pass (imf29.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789041886;
	b=cp+NREcphXCfSkYmU1Av1PkbQCEZcSD6+kwKOnGu7s2p+VFPV+7WOQ6Cki9i8TMqjGQ2L8
	ZKZ6xaXtSOzAXlYfc2poL/iS1UwyS50g0HM++/4ovbl2GLRXbyjXhJrizwnAEo2MZlMuwO
	VdxqJn7LhDAWRuX+koh2XIjCloURKbA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=VeJ9UFwO;
	spf=pass (imf29.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789041886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vLqIaNrwFWSzTOJz0pqPZY4DtgXl7uDimnUh3MjZ1Dc=;
	b=mJHkbS/m6cUqon5/UH5ROA3cEQzi7IxAEA24zAT5elrkEQneDp0JMvu8vg3u87qbzBuK/+
	ImG/Jq+Z6KW6pp2WMy0u+TNbU0BFqBpvBqAOmGUwGr4C+kkpDHdEvqN6rKrovKh7AV9Dnh
	FzOCQyskV2HANiuTrXliOx+5nb3E8QE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vLqIaNrwFWSzTOJz0pqPZY4DtgXl7uDimnUh3MjZ1Dc=; b=VeJ9UFwOyel0F3w4iguQdDOJpU
	3vnj5814ZCkYK4psxL9pPjJvKECquTLhs3ve+EROiRx2Z1Tls6cl8wfRYzx0qwCpw+kqC5EPDD205
	MVSs++dDZGbe9PFAU3jWWrJTTT4QU0oqvLCOo4pPXyYbsG5t1q6GrBW2jD1XcRKhu8oayYs4j08ac
	U5su3hmaEgkHnAJBj4qW8VjD1n/vEeq13DmUm/BsPdGPdh7Q0UpdBBo8yQt8WeQcUYUDxnL0G9hTD
	dNScgEvjhxAXngc2Jrnxwbzwx0o8RuEoCL8rvHBfvFsoYsLRI2UrsyhnS0lwxf4JAFAhqHku86aag
	ceX+2waQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x4dWF-000Ure-1W;
	Thu, 10 Sep 2026 12:04:43 +0000
Date: Thu, 10 Sep 2026 05:04:39 -0700
From: Breno Leitao <leitao@debian.org>
To: Guillaume Morin <guillaume@morinfr.org>
Cc: linux-mm@kvack.org, rppt@kernel.org
Subject: Re: [PATCH v4] selftests/mm: hugetlb_madv_vs_map: add underflow test
Message-ID: <aqKcVgak031LU1Bw@gmail.com>
References: <apsdO-IK6p-IDb-a@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apsdO-IK6p-IDb-a@bender.morinfr.org>
X-Debian-User: leitao
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 123A812000C
X-Stat-Signature: id16m4jkufijq78j13nb19ptxiy5myyg
X-Rspam-User: 
X-HE-Tag: 1789041885-128530
X-HE-Meta: U2FsdGVkX193/g6+4g+HuFNJediHrD/R64hpjC3iclqDYYVekCTxlr8Y3+0TO0pb6it/kRKgMTwY1FSRKDEtZoOUFiihYJ7vFzE5dopzYphHxSuClz0tAtDx6HgRCLDRuOastDYN5St8akWHAZFDRekpmhThOqRM9Q9KMWELqZKDBmul078YMxe+9fmcjxj/311Rl69w4aYnuS/8VGgTy3hprdGjRdRmV/rBBuA1P3uKlKOfJLZLuMsoz0ROQ8aUkYVyQHde1wFYzVAApLUi54NAwa7Lzp3e1n+N0YcM1P+8IeMi32E2JVG9gT04iqwQBZU+c4705KckuJXRYrMh1HCzac0ot/VUaDgtPWmp2XGTmOkarcObm7RrxS2aiPESHXNV6A9CsNdk5QRiXfLJWPKqGPXNxXxkVM5dGXyicRmvsAgB88DJLqEE1uvykUx8v1GsKssMTZgs4/CtyDtXgbf9SR/QH9BEAwaYEVoLU+tFKeY/wv4vq5XufteUeB/5Ll4XQ98kmNzEEzQWU8Nz1/JCbpAwElpyw8L+vQLu0essyTWlIMYEE6PHPlxXgBxLphePjVdTXZIMkxz7cHRJxZNCbT3QRzxFP+c38zv/Jqp6/Dx5xbAOg4TeVK45pRXuGU8LwyulcPUtXErWx0dqR5y0g6vwpIKEBx1byHU/4Asf3Gp/lnHqseNPT3ANYBFTE7pWuw0x4cvZKtapA4D6S/UsxLBmdkNLGQ+HMv8C0wySf9vi5zz8LtTe/pp0s/C3BFIXpWq1W/Cwl33hEGfihsA0Ex/kecBkgojf5JZHKX0pS3E52/KdwTh/gCsIokjpJkESMfjy3GfxT/Zp4jORLOnYoVOMeLFbFqQolP1aG2J7SRFEbQayBF43N+YJJ4BE6nrUgCkdttAZNqfbUpJGni0Hh8P1w+k4dVHWHsPGL3eqOjgd3cfk9x1DxD1LXKW88I2MLMop6pAsvHet6fR
 uRBu/Q7H
 p+6/+B3T7bKlQFbL85wNjPqs1dpK0W/pF9YIbrZihS9aiKXWizJifIWxtYhQSfioDpHttzXsEYECdkqjAoCzoEiZYvWiHWsU5bJBfj5TJRihlN0Xix4ufvfxqgKtfe6nHG+jLrvqijA5gx7V7cLK4g2QqcdGdUBk1ejuhd6DQCQ9jIO7T8983xq9KVV6QRvjj0tQcS9/ZgFNG1/52IFh4mQLITjojmia3NL9kshif1ycmzUNMVNHcReZABIUwRct4gWJze4VjRuzJmgNDmjZnXIOJDQsGs7ZGEqknjPx8NKVpVYWkri4QbThNP7KunsbWkXsMDjiKoIPXT2FaEJEffojlRARHvZtcUi+ArbfBin4fXKEj8/UzSasCJ1Dq0dFEp1miGASeBxPxbH+afJi0TWvMZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 09:34:19PM +0200, Guillaume Morin wrote:
> Add a test that checks for underflows when a parent unmaps the page
> first. Also check that when the child exits the reserve count is
> correct.
> 
> Link: https://lore.kernel.org/all/alEJkwn5VlTTH_ZX@bender.morinfr.org/
> Signed-off-by: Guillaume Morin <guillaume@morinfr.org

it seems you are missing a > at the end of your email.

> Cc: Breno Leitao <leitao@debian.org>
> Cc: Mike Rapoport <rppt@kernel.org>

Reviewed-by: Breno Leitao <leitao@debian.org>

> diff --git a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
> index f94549efcc6f..d89b2c27c2ae 100644
> --- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
> +++ b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
> @@ -3,25 +3,16 @@
>   * A test case that must run on a system with one and only one huge page available.
>   *	# echo 1 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
>   *
> - * During setup, the test allocates the only available page, and starts three threads:
> - *  - thread1:
> - *	* madvise(MADV_DONTNEED) on the allocated huge page
> - *  - thread 2:
> - *	* Write to the allocated huge page
> - *  - thread 3:
> - *	* Try to allocated an extra huge page (which must not available)
> - *
> - *  The test fails if thread3 is able to allocate a page.
> - *
> - *  Touching the first page after thread3's allocation will raise a SIGBUS
> - *
>   *  Author: Breno Leitao <leitao@debian.org>
>   */
> +#include <limits.h>
>  #include <pthread.h>
> +#include <signal.h>

nit: Are limits.h and signal.h ever used by yor new code?

