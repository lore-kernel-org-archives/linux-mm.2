Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EA71103E2E4
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 22:07:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A49C6B0005; Wed, 11 Mar 2026 18:07:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 386096B0089; Wed, 11 Mar 2026 18:07:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2891A6B008A; Wed, 11 Mar 2026 18:07:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 165DD6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 18:07:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D1D9B1C590
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 22:07:39 +0000 (UTC)
X-FDA: 84535169838.11.2847D27
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf23.hostedemail.com (Postfix) with ESMTP id 53C71140010
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 22:07:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=mfsizaRP;
	spf=none (imf23.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773266858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3pz+oBXHX4ROsA5YC4AIYdLxIsTbPv3WtlHmYYvzFJQ=;
	b=GMiWQklw8P+iqqJZjwdmnQ1J2kbIdbmmZx0zwL/F4o7zsqFmxES5Tm0AbGcp+uGL65/SyR
	2gIqjVZnzDHV2cH9hEjQ7z+zlOggUH9yhZmwZ8Km7KTezC0tKuegFVA5rRkz6g9+w1M97+
	TTy7G4ddoAeQXcXNHbQrvQlkhx4FEes=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773266858; a=rsa-sha256;
	cv=none;
	b=FYh/NPpHffpxFacPLvdbyQJ0G084D3sFGLImzEJopIm4VQMGyqzN+KkSJT81B1TaQmFTd3
	NBTOZcHoB3agoBRsIZkXEAgPwWrp8gw+1zg3l4koTsTSzLDwdCT7mtH1MAWML8lG+E5f+J
	XvgkQnlvjFqWz8KNONHmt4Wzzr7YGIo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=mfsizaRP;
	spf=none (imf23.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=3pz+oBXHX4ROsA5YC4AIYdLxIsTbPv3WtlHmYYvzFJQ=; b=mfsizaRPRhXs+5amb56bl26g5W
	YaxoUOUXpIeafPhcOsHkl64NyTIBsDZUIlwP0/ntc1CfIbwXeYXBN+HoLT7tBPmmxFLti6/uYWrms
	hlmGnxvqInK2XCyGGZ8wwopsERgKYVFKV1lvM0ngcCuXWTMHlljZ0MTGuTXqEzifZy2wYVpr1J2SQ
	WjjMUArT4bINr9QN3u0NLNVZpMSkA7WijRlRIDzF9QkzLqeo1yni6lnEEBWPs1o/jObVUnOMnCKir
	XXqthuqISXMOSS4FCoSF8RK04IVTHnGUNwXRW4ouCPnuz6lyVmJn6vBdJ7yKft75MLTOxQ9ym8p7A
	WsoGd2zA==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w0Rhr-0000000CclT-1mxV;
	Wed, 11 Mar 2026 22:07:07 +0000
Message-ID: <6cad9b7b-f5aa-478f-be23-0baf155b21d2@infradead.org>
Date: Wed, 11 Mar 2026 15:07:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 25/25] meminspect: Add debug kinfo compatible driver
To: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Eugen Hristev <eugen.hristev@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Andrew Morton
 <akpm@linux-foundation.org>, Thomas Gleixner <tglx@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kees Cook <kees@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, Petr Mladek <pmladek@suse.com>,
 John Ogness <john.ogness@linutronix.de>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Bjorn Andersson <andersson@kernel.org>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Konrad Dybcio <konradybcio@kernel.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Saravana Kannan <saravanak@kernel.org>
Cc: workflows@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, linux-arm-msm@vger.kernel.org,
 linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org
References: <20260311-minidump-v2-v2-0-f91cedc6f99e@oss.qualcomm.com>
 <20260311-minidump-v2-v2-25-f91cedc6f99e@oss.qualcomm.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260311-minidump-v2-v2-25-f91cedc6f99e@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 53C71140010
X-Stat-Signature: ms1hjbdho98rrqe1oahqpy1wxfkpmg68
X-HE-Tag: 1773266857-117641
X-HE-Meta: U2FsdGVkX19dDYdAuIfsFfFHTPy0yznqI1czvnymoYfv7Ust9BEIip9rjI8GuJtxuTrbk5+tzH0xLDosAuxJ21IRmfFaj7RUnxrFkwdaim5U/+OxeIFewxGHPpLZDnFHqAZvseYE0AIZ60/9NqGJbxcYGfCANb7uag84Fb6cdRLwU2J90eIC1Z3352dz0YBc8pD01Ah/hHwvj0qaaCQOngKjyFaJiIrgHwvWvNXP//3chFgkWwYU7sswOxRz1x9dxLzeHjLC2g9/jLXv9gLw7SkAJi+s38EOoFeGKbVa4eYhkY+9EXbwPSWx7f5RkL8DieQB5nz119ihSjvtZxECLzkzi+khyvY0tdaIx/LvlbPpr/pSyStkUEGup/0sRALjCVMWBWNMT/0ULp9+8wdH5Ty/v+b7yCARc9CPzokrnKHxtceQ+MpDjsee6jWuelLsucIK4b/kZqqYaK6PhPS8hJGXQ1a9MPm193NrR2EdxUdutsXxoINr8Cigh6h/hWZLg9UGfhcaHdGFnL/vaTuyHrCi242m2B/s5cTI5Vpc2OnjVei82Y3ZCPbdKt8ppMofrLzxyJBekNhmLzr4PmT2ypRP53xFi3OSxgSQpkbH5L/nTV16XC813QGa6YHNWBoGTM5IDNa9VsgPypJDrhWscuLPUy5xnBCg6LCp0JloR+4Fgvm7YLgl7isQQluDKZWmLKaHN6D6rCYmROQlBWwTejmKyKj7IckS6tveJgej42SY5utEoRJYq+phVH2+SmuJ3OG0jTaSV6scH1OHjSvVlSSAclEg+0Tl/faCpOZI21NuRJ+O11NQci1yo5xMz5jrw+mPKDfLr5SXZ9b+1OvzbrryaCpkDXdDhnBS6EYzRSZZn+q/O8Liwggkf1j/JzbyT0h+Np8Yi99HZ6zMp545VwUoeiyeXCNTtLlvd74+yW+3IZF32O4g/eewFowfb73x5+HYZBMxPbFg2G27gO+
 cuhpkl4m
 ves7Os/B9mgLV4YIweqfrfy8wU2F1DaZqSUFdaqsdNv3sOC5L8auqOPxCKYVRDkDULE1yQ8D+KmbPg0aYcFmO3pYkg+SZGbBH0s1OyX2CLIkQkKiNGulRkc4R8rDIPgwZ9YfV9dvvxIXBRE7wk66ICjWoxx6VmQ8G0a3vXxS0M1FDuQs/wemtLLM73MxgBq83RUubbNmBXpDer0hQLzN1Six9CdFkjtCweprzIwX34fsyYoHp37BYzmKwIzc28URGQzc89pJhOphSJP0VglrMOYHhmaKK4hjNucnHLgmpa2lsQLVVvWHzKud51nl8xDKsNBfFEoGcunMvh/yPTp4xp+YykcxRz+UJMd7Ch+Q6OEsZT1o/Yx9ekp2d6jXuObprPPfu7JIe14kVRwpWmSAacWmACg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/10/26 1:16 PM, Mukesh Ojha wrote:
> diff --git a/kernel/meminspect/Kconfig b/kernel/meminspect/Kconfig
> index fa2b5a84b251..396510908e47 100644
> --- a/kernel/meminspect/Kconfig
> +++ b/kernel/meminspect/Kconfig
> @@ -17,3 +17,14 @@ config MEMINSPECT
>  
>  	  Note that modules using this feature must be rebuilt if option
>  	  changes.
> +
> +config MEMINSPECT_KINFO
> +	tristate "Shared memory KInfo compatible driver"
> +	depends on MEMINSPECT
> +	help
> +	  Say y here to enable the Shared memory KInfo compatible driver

Use a period (full stop) ('.') at the end of the sentence above.

> +	  With this driver, the registered regions are copied to a shared
> +	  memory zone at register time.
> +	  The shared memory zone is supplied via OF.
> +	  This driver will select only regions that are of interest,
> +	  and keep only addresses. The format of the list is Kinfo compatible.

-- 
~Randy


