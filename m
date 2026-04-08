Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 308BCFD5F92
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 08:04:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7547F6B0088; Wed,  8 Apr 2026 04:04:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72CF66B0089; Wed,  8 Apr 2026 04:04:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 642886B008A; Wed,  8 Apr 2026 04:04:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 53AB46B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 04:04:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 09D7B8C477
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:04:22 +0000 (UTC)
X-FDA: 84634651164.04.5C5F0EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4A7B9C0003
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:04:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LefS1e7B;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775635460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M6wpVWWuC2Epg0Q3WSq84dRADzihXLXbPd1ZMp9INbQ=;
	b=VGrOesbwbC1N1COSR+2Kv0lyABQ+2oqrq1eJfZIBUTKaLdc3gahpiVHIqKAuu5XwIEnmcJ
	74Orl8hgyS6MWLbvbwbuOhvgpkjj8E4k/nYeGJIf0LJYvFFaaKtbZxaSLVGVHsPdxTM6Ay
	P1D+noHxPVBT0pFjB7L+/XbRVgOp9NQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LefS1e7B;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775635460; a=rsa-sha256;
	cv=none;
	b=QzZkLlEwY0HFrUPzSVrl+SEml6JuYkFblAwHfvZUgPfg+hbpEPStV/57pq8N/6jZtwiBsd
	Ju56PALw1JivofJp9TznGlze9pN7a3U//JwCiXj1CFAmoLAWeAZttXXOmibNCXChy+LksL
	x/CjX2C+3e+qXYXIkwcTlCaR1CF/DVA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2BF904188B;
	Wed,  8 Apr 2026 08:04:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986F1C19424;
	Wed,  8 Apr 2026 08:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775635459;
	bh=h5rAiy5LZD3BGfM1luhCCAOhwqe8NJSlD8HNpfGSDfs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LefS1e7BVT4V2S99fm1ARndgEmYgmtzniSohtrv5Ge/1x3p3ZuxSFocv6y3w1XgmV
	 HVEZiKVjPQ6yyRwDGdXIfOLeFw9twxGkLSwUhVfEQfy5H62ZAB+BoD1tjMvuvGOxg4
	 Mk4UPhFYEc6ZExHy4JyPhL/JIIV0YBbJQFKNEuerVobI7sdIN1vTU7Zh3a5FS0Z7dC
	 Ljmu9SD56hKkNkYFrRtRAACtJ083gk+TUIj1JIWiS6QEP2CA+T5u7Go6ektjBuFW0y
	 rZZTsa60yykGojcboXHDxb2FaHoaSD9CPU4+kkkXtFUPvm0VxI+V71r4nOgZOUefaV
	 UDUYqbVggwMdQ==
Message-ID: <8988c17a-77e7-4ec1-a5e6-a983f2203d56@kernel.org>
Date: Wed, 8 Apr 2026 10:04:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mempolicy: Fix weighted interleave auto sysfs name
To: Joshua Hahn <joshua.hahnjy@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jackie Liu <liu.yun@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260407141415.3080960-1-joshua.hahnjy@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260407141415.3080960-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4A7B9C0003
X-Stat-Signature: ad59ri1kgrj9xft41f7fqfcs7rwoytka
X-Rspam-User: 
X-HE-Tag: 1775635460-635983
X-HE-Meta: U2FsdGVkX19ztkdFaRlHNVfkdLnNYkfmqqZju24KyhjqKyIsJIy2yVktFlQXHE6scuD84gCLIbVlMyzTethlFoen1XSpxcSu8oUa46k22KHBCJ+gFOMhtwpHSf+dw8xx+QMwGuCpvqXTo0ymiJ/Vzj8N3xdFiLhF+OQUJmVLl0JZluaNaEmBqyots5kG5y5h1u9sumvq3vLWwZTzyOTwf+3V/v+7T9zJ/CEwgAssEBE6fSM4fi5vR4+eYcLfeUwGrAU1kaEchubCMJ5Yk1+JClqf0A3I03tAdH+J/wmfp5vszGaDo9IZE2oX9N3L1UmwFATPY6ciIYWFLCpPe3uYS1RxHzZjjMOMtveSm8G4eBddvZfK0Yj2ecPOyebUZAciyAk/k//NQnyiQ1BkArvtO9hV0kpeqsqw3RBgQJSJM8iA2uQGB82a4X63ESW0QUXC5tz7R1Ff82+Sy0rOGw9WY2a86cotVaWACdgdxC3bufZDaiGxgw3q3WWyJkc8xj+JX+d7IPeCKoaztaYDr1zyF7mcoJVzqCl64gTJ22xTMYSDy8K8BQTheywNyHgPB3/zg+g4C2kqWplum+E8kNX8+lFrSSbQexBeYb6R5PHtvLgxIRCLqC26Rpu8y+bNwTu6ohzzUgwYOk7RI07DX3AujWh736xi+5k5hKw5kGuJZwI4OIqwrXs5bDvLyeYAp6/YdaN2gLEVA9pWFp9rUAV38qmT+dCCZZVE7KVZEJ1MFD8zYhNosOizceyVoYCdJLUGiGH2dQ4pH9PN1P/x/aXrjiyX1xqh2NbAEkmsW5DFj4aUar8h5mufG1KVoSaIGXSmEj5YcaBJom3hHR6qHkUe7pxrtiytpL2kyObvUNLUdGtbsMvSriWL9Hmtw2YUhzeV6rq2hYj1M5AVLBayvo1RduBAP4+eU5fqmwcXqY5tQQ3wqv+vOK9G5Xsx16kkmCvMhAYpuR4x+hYnxVCaFiV
 IznXX3I3
 QWVvSx56d5NOVLpwmPZQORohR47EwLg4+u4jU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/7/26 16:14, Joshua Hahn wrote:
> The __ATTR macro is a utility that makes defining kobj_attributes easier
> by stringfying the name, verifying the mode, and setting the show/store
> fields in a single initializer. It takes a raw token as the first value,
> rather than a string, so that __ATTR family macros like __ATTR_RW can
> token-paste it for inferring the _show / _store function names.
> 
> Commit e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
> used the __ATTR macro to define the "auto" sysfs for weighted
> interleave. A few months later, commit 2fb6915fa22d ("compiler_types.h:
> add "auto" as a macro for "__auto_type"") introduced a #define macro
> which expanded auto into __auto_type.
> 
> This led to the "auto" token passed into __ATTR to be expanded out into
> __auto_type, and the sysfs entry to be displayed as __auto_type as well.
> 
> Expand out the __ATTR macro and directly pass a string "auto" instead of
> the raw token 'auto' to prevent it from being expanded out. Also bypass
> the VERIFY_OCTAL_PERMISSIONS check by triple checking that 0664 is
> indeed the intended permissions for this sysfs file.
> 
> Before:
> $ ls /sys/kernel/mm/mempolicy/weighted_interleave
> __auto_type  node0
> 
> After:
> $ ls /sys/kernel/mm/mempolicy/weighted_interleave/
> auto  node0
> 
> Based on latest mm-new: 96881c429af1
> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

