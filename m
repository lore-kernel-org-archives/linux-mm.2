Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87AAAC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 13:01:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 782E16B008C; Mon, 24 Aug 2026 09:01:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 733766B0092; Mon, 24 Aug 2026 09:01:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FB1C6B0095; Mon, 24 Aug 2026 09:01:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37E4D6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:01:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B9F011C00E0
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:01:01 +0000 (UTC)
X-FDA: 85136173122.12.B13079D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id D7C49140013
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:00:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SPaqJoVX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787576459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q36gRSoP99ff+fMOz6jfXIaZTDy+JL/ht/1iEGaa99g=;
	b=KRrMBx46l32WbLPTHbQMJFmoduW48oQLlizeb2yeiy40l8hX6sqw+zGPOJpKGqDlTD9jUT
	sXNPOQHol2E629I24flXgtFdPaEh8qYUyGIt4nxlJk+0bwyep0r3sJGuxGW75R7U0Oo6Gn
	yyQPwwLAIQpObT9CvkuW5SUsNkW+FJg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SPaqJoVX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787576459;
	b=w/FgviJch3T9XC7PVX7w8/otOnlgOO+wxYYdSnkKnxYAVaMM+c30l/unmK8Xh3JkWRmDkP
	xCdh/Lx0Z0h9PYhQ6FMsLapOJJNM+YZEYBHgK4LMR1+tKfET/F0YGS6FKDZJPt8j0OQm/R
	JQtrDFfpZZQfJNJdsTkDB6T9CpLfNLU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5BAD760120;
	Mon, 24 Aug 2026 13:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D9D1F00A3D;
	Mon, 24 Aug 2026 13:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787576459;
	bh=q36gRSoP99ff+fMOz6jfXIaZTDy+JL/ht/1iEGaa99g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SPaqJoVXqsHFY/xMI1dkbMXlu1/Q7FPUphBkZlD/TSukZg6RpW56PgrwFXhUEqcqg
	 tD7j6Z954yRqGmvT9jzWfXVJuJaHnZYj6t6Qb2/os55Jxdf6IVv39A/6N4w2m5sat1
	 HWgWW7pF70RVTo9H4gqxwi48p1TjbW9OJpSPFyg1YMkMPPVYsm4AE/Lh6QP1vSV/0B
	 myp0lvAM2OzHIQi/nNJiBhGvfJEk1gOxfrIc/u5AiHcMz4rP5KR9cGk6sX1elmNz30
	 Fwg0Q3/UAB0vGaRwA2tpMXmJjmcKy5zZ4DgK+xicCp3KcA97KHLndhx8tf3rkQFzot
	 CyNbwdqpLIZ/Q==
Message-ID: <8a99f753-0713-4194-8eb5-90da0724e647@kernel.org>
Date: Mon, 24 Aug 2026 15:00:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/5] mm: selftests: Add shmem into memory failure test
To: Lisa Wang <wyihan@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
 Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
 Rik van Riel <riel@redhat.com>, Yu Zhang <yu.c.zhang@linux.intel.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com,
 vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com,
 tabba@google.com, dave.hansen@linux.intel.com,
 Isaku Yamahata <isaku.yamahata@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20260823-memory-failure-mf-delayed-fix-v5-0-d97a5703e45a@google.com>
 <20260823-memory-failure-mf-delayed-fix-v5-5-d97a5703e45a@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260823-memory-failure-mf-delayed-fix-v5-5-d97a5703e45a@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D7C49140013
X-Stat-Signature: xptez459yrmuimx98z3cdw554nthcami
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787576459-507073
X-HE-Meta: U2FsdGVkX1+XBnvul+wnMRpu1xyyqL117GXAasU/1HLR1tzCgrD8apVL9jmW0vblDglXgv6enKFrWomr22RRDZtBikmbjOihIs92bN8CAR87mA8KKYP2ytv0YKkYBqOWDJWLXtpapY7UMfYY71pDrYfomqpypwhg766goKyuUIaSJ5ol5iFsbJRHglXQXIwrRGXiGiSaGApQNfs8GYg9H5UVmNzOKCwAPLTaM2GfYV8ds5bP676PRSiWKzSW4qVqYFGqfRFEZR/Va7C1YLCGUzcSXDpaGrchwL2jcDIiEZh4HO7hymBjXDFlqySSSaN7tgH3J5Vb9mg9mKwmU8UnDzjsPP3CGUNMXtOKlsKLSMrHjqXnAUXQY/IiLtiq9ov/pkbIUJ5L/FtgKYn1Sg3513FbIaMpT4BSA706+ce9mlzYNlEvvv1JBFkSzPMgse6FIwRRWKw6rKMl42e13M//RXuEx6+wR2pOYAGyN1xh2PPvPOcPP/GXsnXKyneZk0HZAjLlfjW9csqGZ7t2xxEEAXXtle5veIGARocV6vk0Erj8J+icS6iy+BR/MYr/hJY9Q8GKHKgq5vtrG9f8G+7rIyxPGXjScpE3X+yMp1KRE9c/gzdQPm58qSGNN3xM7PtlAF8IZxUxVz3Tc7+B4GjGc3DlVyMg0l5YwO3fl/BrotrrM8CtfzEsyRH71eLgBG8UMTHtSNMSip6VbuC/73Ba6PmZTpZTJcuSPIWZ5kiqRFEV+GhJDFB410wGUZ0w74RkdCNr+xc+0OgFfGKAbW34aqB352A+hdHKtO+eeK0MYIwdijzh8kAXQ6l7S7Bu7VK8KNsJ8+JgVMIFVolppCT8sVvXHVnXKQqil5nAYpF+VaJdSCyGIH9hnpNovRcTfjkhjZXjPpa0LfqOlQy0dzRD3nQqICldmeQT2fpX7CRMkBPsbpZq3/17/HqakuqLAs6vfscYqcgRkoDPGOSDM/a
 SH5VNIlK
 +NY4xNKbHbCDU2WmV1amUsp5/P45w69lrDBP3aipWu0rJEqpri9weCt962/DAoGem6NzYWAoxOv2OrLryvC/UdF1uiyESHt6rKLF4FWOEeKBrDcRrVK1z2Fkftyq3jrmQcKYbpmPDQKNMykyeDm8yGPdbpYnc/+4sR/rleyYswkB72WVrXyypDEOrU8Nh0jcg72/GpWnMQHD5reK5iShKDW8uelH1Yc1tyuFuGPxN6OsG6EDYx0pOXsjtgLe8UPzorjl7/oSMTsqBKr/xLF8uKMAT0ydBgOLZm9h7oF+j2AOsW1tjx5ZbGxF1RRN89w0XLb2K7RQi4EeztJ6ywC4WWNARgGjr8Yb14jOTDqEWu5PmR5ByCqr8RWWM8LQFLeZFKlR5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/23/26 21:40, Lisa Wang wrote:
> Add a shmem memory failure selftest to test the shmem memory failure is
> correct after modifying shmem return value.
> 
> Specifically, test the expected behavior under various scenarios
> combining page dirtiness (dirty vs clean) and failure types (hard vs
> soft):
> + Dirty + Hard: Trigger a SIGBUS on injection, and trigger another
>   SIGBUS when reading the page again.
> + Dirty + Soft: No SIGBUS is triggered, and the original value can be
>   read successfully.
> + Clean + Hard: No SIGBUS is triggered on injection, but trigger a
>   SIGBUS when trying to read the page again.
> + Clean + Soft: No SIGBUS is triggered, and the page can be read
>   successfully.
> 
> Acked-by: Miaohe Lin <linmiaohe@huawei.com>
> Signed-off-by: Lisa Wang <wyihan@google.com>
> ---
>  tools/testing/selftests/mm/memory-failure.c | 118 +++++++++++++++++++++++++++-
>  1 file changed, 115 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
> index 1a5a32e22cce..5b26f0c44664 100644
> --- a/tools/testing/selftests/mm/memory-failure.c
> +++ b/tools/testing/selftests/mm/memory-failure.c
> @@ -20,6 +20,10 @@
>  
>  #include "vm_util.h"
>  
> +#ifndef fallthrough
> +# define fallthrough __attribute__((__fallthrough__))
> +#endif

This doesn't belong into this test.

rseq/rseq.c selftest already uses it.

I think tools/testing/include/ already provides it.

Maybe

	#include <linux/compiler.h>

does the trick?



-- 
Cheers,

David

