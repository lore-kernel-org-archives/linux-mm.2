Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8DF0D1A62D
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 13:45:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 192156B0088; Fri,  9 Jan 2026 08:45:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 140096B008A; Fri,  9 Jan 2026 08:45:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0217B6B008C; Fri,  9 Jan 2026 08:45:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E3B3B6B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:45:40 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B0F9013BCDE
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:45:40 +0000 (UTC)
X-FDA: 84312548040.06.B0ACED2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0D25F1C0018
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:45:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="HraFFJ/x";
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767966339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BPDR2GcRczH+jeRjtFUJfvIRZY40nWn+HJCTL8Zj49c=;
	b=rLfj0FeHnyJBm/OL3N2QqbKX/Sb5sBpd+GlxOXjtuYPNrLWk5c4YrK81WkJQTrbNmlqHYf
	cPZg3EcuPyJoqtqDmPmVsv644DflvIKy8Pr7FTDCK7GfyRXSdkrQVupZL6RKeO8rZccduT
	8wK7rA2R8Ig6pI+KCbw6JP4z1XRO2fc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="HraFFJ/x";
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767966339; a=rsa-sha256;
	cv=none;
	b=HJ2W8yaYMPAku3i694/pMbcDHWGtULooH1bdiGpK87ZJpuCSVVA+eXmQKNVr5q6fgy7OG7
	yNY/us1WGa4zkySNOcju4t3SECN3Amg4cwjzk4D5x64zQRqUhxsrozELy6PtmAarSGUoEi
	2RpuUE64sA3doaABhfw+HRw6Fat6IB0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E10B60130;
	Fri,  9 Jan 2026 13:45:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0443EC4CEF1;
	Fri,  9 Jan 2026 13:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767966338;
	bh=u4CAnuyKa22cPZqPczAHTBUsJfWDDiZoz2nyUc91Sg8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HraFFJ/xcLLuJ6o1wjBP6cPlh87ajBGgHxo1MRoTGAy4BNHUr01Z8zde9bUM+tvf7
	 nmnuA30z8KEgrXu6TLPQmXmrbHXNliphc6zgOhjje0A4KOCbtrpro/0IczJ6rcbYwZ
	 bxbIP7Z4nXzoHu/r/8H35agquZuMzRJcj/JCNQaHBQMXnJpw4PFOONMPxad1nyIbbP
	 yf8JMQhBAAcYPxL7FhHOEJQQFwtx7aca0fBm0vDNVDhYnQq4A+fM+zJNKv5hfIFrAH
	 jvLr2s7xwE3QIUY+um05rBfxS+dwZuxbsRqlpNl50OL9Cr/YQa+H0Dqrb56PNtMYpM
	 /nDxFpzqDGXbQ==
Message-ID: <9413a995-9182-493e-a28a-6d2d3a17236b@kernel.org>
Date: Fri, 9 Jan 2026 14:45:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] selftests/mm: add memory failure selftests
To: Miaohe Lin <linmiaohe@huawei.com>, akpm@linux-foundation.org,
 shuah@kernel.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 nao.horiguchi@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20260107093710.3928374-1-linmiaohe@huawei.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260107093710.3928374-1-linmiaohe@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: zmosxmf6ipm84nf6iyg84ej38unbcbqm
X-Rspamd-Queue-Id: 0D25F1C0018
X-Rspamd-Server: rspam04
X-HE-Tag: 1767966338-842458
X-HE-Meta: U2FsdGVkX1+zdtYDd9pK3DrVRwaOwlwjCV7Dls1CNebbnwTzHRRxO87XXVoZ/VI4Ahm7mPllk4WkK1RbQoKelj3phGKiPwQn+su8rdVVi6RTEcdm5W8QQUwnmoqFpMxjt1OZD2lE2ncRsVfB//HWDAnosTAnMS4MCP1cu2JTwamJ3E39E1aTIx5FvnNcqxxygvF0hTsrHNQP/JN11DYSum4vILvFj9JKmYldl0LioeGMnM8P1E8ufRUJ33eWCGAUsdCXwS+vthRC9/lTw6q16SIsSndQ7O5JRdBqDex/C6TIt7uGxhDeO587l8s7ifMwHxoQ6wSIU9vuOp0o90y5ofvS6yIp2yJCVGbO/ThqhYWMPNZcaKDzDt08Zw/KtLNA0XUsy6V/rIE1StzlDUUeib3HNupEMcqh9/bmJwIf+L8Be+K631NGD7Dt2qRl8UmDu4cW7Ejw70Uw1WqQIeYGXAEqZ6pgi8B13TRdOVr1RVIS7G7rlfzdurXw0N9dRnSD5379JtQ2O9DBoQBQmNlypY4FauFxt1Wa92ESRvT4a9bktQO2m3dwaSfSQsx6ffBj+n8hKgkf2fIOBadkYeFVamlaVNFbakdoGc1il6hHRLLvFcEyB4MMjvM1gJHqilL1M6h9utfvsmWZh4eVi0i4x9fLudLo1nse3WRyFWP7f4Yq8d/rSU6u10KGvviKsMKC3PEMWvrT/HyjSOpkeCnY/3+yuUNprOnQNR0j2VSJftR7n0CtNm9aJ0bgxjG77wFgx9URFsJTpFR6TsOJaQPSesbj/GMU98Z5ae/txKfxJiDWAZWFC3w3Vb69Q2HAmCwp7b/4gc44H5XqyEb3YGL7LmavQ+ofOxk8oZDLttq1OqxSBbo8ESlaeDGIDJKDsx1fNsFBUKRmbdO65qCgA8orq0qwizVcd4Bw9op9Xrb98jqmnFOOwrmYaSCpGLoXKgCWxH3jk8AIrkAQbSI2hcz
 aNGpcOtB
 j2UZdQI/XKLS5tUK9hvTbUmPAqCUQ3cE/Pqy2rnNMet5ONUowkA09wol8uJ/0qf/TGyCZvRHHIHvo4bz0TiS/kWV22lVaz131sSVajzYYIkDP0prYZf1Agkg2levRx/IrOJEKLfk9dE9HAIbYI1QABwWliq3B+XvhE7W+LB7gXm0cYw895N6Abaks8A06qs5f+JTMzBNz6MEFtwMyCNqLYu22E+Q2eoJr+nBU9paqYeoeaPdcoUmTe3Ne0PX3zyT7EypkwSvuta5JetQF5l+ePZMzgqCLwYh/+suoYk6P4PFzbG2j4ztDbwKGIAf8ziLGOanm8TTzoxzylqM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/7/26 10:37, Miaohe Lin wrote:
> Introduce selftests to validate the functionality of memory failure.
> These tests help ensure that memory failure handling for anonymous
> pages, pagecaches pages works correctly, including proper SIGBUS
> delivery to user processes, page isolation, and recovery paths.
> 
> Currently madvise syscall is used to inject memory failures. And only
> anonymous pages and pagecaches are tested. More test scenarios, e.g.
> hugetlb, shmem, thp, will be added. Also more memory failure injecting
> methods will be supported, e.g. APEI Error INJection, if required.

0day reports that these tests fail:

# # ------------------------
# # running ./memory-failure
# # ------------------------
# # TAP version 13
# # 1..6
# # # Starting 6 tests from 2 test cases.
# # #  RUN           memory_failure.madv_hard.anon ...
# # #            OK  memory_failure.madv_hard.anon
# # ok 1 memory_failure.madv_hard.anon
# # #  RUN           memory_failure.madv_hard.clean_pagecache ...
# # # memory-failure.c:166:clean_pagecache:Expected setjmp (1) == 0 (0)
# # # clean_pagecache: Test terminated by assertion
# # #          FAIL  memory_failure.madv_hard.clean_pagecache
# # not ok 2 memory_failure.madv_hard.clean_pagecache
# # #  RUN           memory_failure.madv_hard.dirty_pagecache ...
# # # memory-failure.c:207:dirty_pagecache:Expected unpoison_memory(self->pfn) (-16) == 0 (0)
# # # dirty_pagecache: Test terminated by assertion
# # #          FAIL  memory_failure.madv_hard.dirty_pagecache
# # not ok 3 memory_failure.madv_hard.dirty_pagecache
# # #  RUN           memory_failure.madv_soft.anon ...
# # #            OK  memory_failure.madv_soft.anon
# # ok 4 memory_failure.madv_soft.anon
# # #  RUN           memory_failure.madv_soft.clean_pagecache ...
# # # memory-failure.c:282:clean_pagecache:Expected variant->inject(self, addr) (-1) == 0 (0)
# # # clean_pagecache: Test terminated by assertion
# # #          FAIL  memory_failure.madv_soft.clean_pagecache
# # not ok 5 memory_failure.madv_soft.clean_pagecache
# # #  RUN           memory_failure.madv_soft.dirty_pagecache ...
# # # memory-failure.c:319:dirty_pagecache:Expected variant->inject(self, addr) (-1) == 0 (0)
# # # dirty_pagecache: Test terminated by assertion
# # #          FAIL  memory_failure.madv_soft.dirty_pagecache
# # not ok 6 memory_failure.madv_soft.dirty_pagecache
# # # FAILED: 2 / 6 tests passed.
# # # Totals: pass:2 fail:4 xfail:0 xpass:0 skip:0 error:0
# # [FAIL]
# not ok 71 memory-failure # exit=1


Can the test maybe not deal with running in certain environments (config options etc)?

-- 
Cheers

David

