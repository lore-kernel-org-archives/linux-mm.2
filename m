Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54FF3FE51FD
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 10:06:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FE5D6B008A; Fri, 24 Apr 2026 06:06:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D57A6B008C; Fri, 24 Apr 2026 06:06:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EBDF6B0092; Fri, 24 Apr 2026 06:06:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7EB3E6B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 06:06:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1F1CD1607EB
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:06:09 +0000 (UTC)
X-FDA: 84693018858.20.3A6B800
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 56DF8120013
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:06:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=h3Twi9g5;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777025167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mnZM19ykwzsxutuutuir7X+M04yIAZtCvgS60wta4hw=;
	b=paoF5fsZBoVyu+Ud6XW3o+ojE+r6pyjZ9BZv98Vne/x2iu+tdBq99aZcYVb7rNH49GTImJ
	zI8KBdP8u0AKgPFX+dGvU7Kb2Pwab4CFyIileFIpg9p8WU9QHYj+fATPLtRglI2OM128JD
	wE06X6SoFtkHTdan3lmg7ZypXx3bRnI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777025167; a=rsa-sha256;
	cv=none;
	b=NiRzt6ZGaDWtWcImr1tflpu8sLw+JVl5silFcb+doBICS5mYO0o4BPdnDg28TlRSx6n6wT
	9ssyU6Yp9ZER3/CFHIawKBhVUczaIzObrH/ESZ905bu/UTNpjz8ItGVfw5JdviZ779RJyP
	oMSH8aymGlzxkun8RSLIBbySz3J6fNs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=h3Twi9g5;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AA0066001A;
	Fri, 24 Apr 2026 10:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88C7C19425;
	Fri, 24 Apr 2026 10:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777025166;
	bh=5QXbN60HW7CsXZ5gwYFqYgAkYkkEIgU02nf2dVj5W3Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=h3Twi9g569dZT07Ied/Me3zb+JPHA6eAsaQsNpHFXJrsrM4zUZlehSAh2LWT0VN/4
	 qKd3Usi/c2Y7+LBaDAlN7ZMeW3J/2WG2cgGiEo1CkFwqRMSAowxutZvnGNxVteJQA3
	 31c//zfVgdvryiRcUuP4ITuW/prdCVrvtsJdZkf4=
Date: Fri, 24 Apr 2026 03:06:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Wang <li.wang@linux.dev>
Cc: tj@kernel.org, longman@redhat.com, roman.gushchin@linux.dev,
 hannes@cmpxchg.org, yosry@kernel.org, jiayuan.chen@linux.dev,
 nphamcs@gmail.com, chengming.zhou@linux.dev, mkoutny@suse.com,
 shuah@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/8] selftests/cgroup: improve zswap tests robustness
 and support large page sizes
Message-Id: <20260424030605.6d0053c0df14bba325114e1b@linux-foundation.org>
In-Reply-To: <20260424040059.12940-1-li.wang@linux.dev>
References: <20260424040059.12940-1-li.wang@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 56DF8120013
X-Rspamd-Server: rspam07
X-Stat-Signature: 1cgfbqewy5fb88mz1p44fcjnu86qk4q3
X-Rspam-User: 
X-HE-Tag: 1777025167-902473
X-HE-Meta: U2FsdGVkX19UO55OPtGisqvHTJD9lfzmhDlScVNzNKGhRPiP/pjnfcFuwSVxe8C6tWzZ9URyhih8whYQttSPnxShMgamPgUNbbyFSuSNAZh8V3a0BlkfbgMrvXBAwVI3MeDizRKcQlGVvSb8nOc9gRiNzpMrZQB9Cgl0bB9j6izvPzVITKDKsWVWuMDl6CRCkQ6E3c9PzTO1rzwu4207aStSVfdrJJEWjtUEvLDeEqrsJX8SyuszF82bpu3/HMQ4NoqZSLaGkMc8myt2KHUXnWar0S7CEa97EgRLnozrcXtJHtFmUenTcu6mpDQwdeAmcva/X7lVrACoj7f+QbojnUdn2GJc1ABWGWO34hAoocdiRKnLBhdZ64QWlCCM0X73XTAw9b+IaI/DZFqYu0zCZNSIEBv+hw2lXp6nawwbCVAJC1nQG15hFkHpoCxE64hXoLD5SXp5YmjiT9+DSl/HjeVswe0qh8/CXDxOpqMn6CEDy2i/llMs0lOfy5xW2eATgahQm3VJH8j5nuBZruYnDyrFlgMRzNKtGh92F2s5q6eUlo8+2sH3vMo24cP9GPn+Bwsg/VZPHLIpsgt/Dyonfh7yz+uc0kzCIxy2ULRLMkEq4HyFbgq9CmgkjE22I6giSRv4RGsxVkaVgil8z18Fo/HFWEMm1YWWvk1SDn/3o9JJxWgl1+OZaAuHEwfTymkdz1aqEFQYj+mOSEnCExFvzKRh0InSOMykS8ouv9t3VohdqXsNest0exn5trsm6pzvG/gDcH7KaawwYJ3a0gwUtk4BquTD71NNBy8EwaE2QuAxA8ylPw74VRI4MO/leHhxQ9lSiUUmhYaRvldbgTDcWXu1I8lE7yS5dCjo8zIdGx9nSUMtoZP36CESyQm7JQecCxoCCr10HLqeD6qOupImIfjIJK2Iiq1bBZm3ETSbnEPj3s5yBSxsUbfAFK26RHN7gMS8RWDDY9UlwMlNTyX
 GfcCPsLa
 ySp/GeixXdLpwFfvoTZUOalmXy70KcULMIG6KEh4QV6lZXGoptf57lePe0FwSoi9Dr0znujsxIX0CdCkREu1PDXSH0yccB1DNuaQmVZ+lDm+ohkGjhOhSqp92kVNLxZRjzrkajTXaumTKi7wCBZZ8BP+yfHsOdJoJgYhIMz++yESwc6bLzwg00vUFixZb/PkZBGWCUhUkP6nE0FTC6fFRh5U9P0gvBVXpwU7jhT+FUu+k5ZqVvM7jg7hvb1YVysOTMxR0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Apr 2026 12:00:51 +0800 Li Wang <li.wang@linux.dev> wrote:

> This patchset aims to fix various spurious failures and improve the overall
> robustness of the cgroup zswap selftests.

Great, thanks, I'll queue this in mm.git's mm-new branch.  Next week
I'll move it into mm-unstable, where it will receive liunx-next
exposure.

> The primary motivation is to make the tests compatible with architectures
> that use non-4K page sizes (such as 64K on ppc64le and arm64). Currently,
> the tests rely heavily on hardcoded 4K page sizes and fixed memory limits.

Well that's an oops.

> On 64K page size systems, these hardcoded values lead to sub-page granularity
> accesses, incorrect page count calculations, and insufficient memory pressure
> to trigger zswap writeback, ultimately causing the tests to fail.

I assume you've been testing on arm64 or ppc?

> Additionally, this series addresses OOM kills occurring in test_swapin_nozswap
> by dynamically scaling memory limits, and prevents spurious test failures
> when zswap is built into the kernel but globally disabled.

