Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78138606A323
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 15:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=F4BGsX4w
Received: by kanga.kvack.org (Postfix)
	id 8371B6B05B4; Thu, 26 Nov 2026 10:27:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E8726B05B5; Thu, 26 Nov 2026 10:27:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D59B6B05B6; Thu, 26 Nov 2026 10:27:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 515496B05B4
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 10:27:11 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D404C1A048C
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 15:27:10 +0000 (UTC)
X-FDA: 85477648620.25.0CB8597
Received: from mta0.migadu.com (out-22.mta0.migadu.com [91.218.175.22])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5CF4920002
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 15:27:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F4BGsX4w;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.22 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795706829;
	b=x1V0CcqOq0VHS/jvxXx83JnFPd5rfn0UgkLcPECLYMgBoxu9jlFJHqpzEQ21wngRvPilc9
	TOl6znICdwliGIAXRyis9iA0n3hcLtVBGBmvPtkmZ1xyldKaPf0Mf+HIlEjA3M7iTucxnK
	iXXYzcztcuSnX90nKjs0jigEeOmuSOo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795706829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yuJqy0NseoGTjiNdlXcAFKErbfQ+Md0iYPLbsmzKFlE=;
	b=i98UpQBcXvzkI3Oo8KxRKf1UPl5jlo1lFOcMI8QTqq313D/pjoESFg509ltajMsEkVBQAg
	mFK7xAFsfoEO+XCmBR4Vk1UA7qe/z7bRVo2oNNPjh5VUb4d9Fk3XgAWB1M+azOM3SGvCBf
	ktjPff133UKPRJucILoa03mWI7Lro4Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F4BGsX4w;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.22 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=KbVedbyeDFEeAK/XvGiJ+Oc2ogwQltzRQPHWkSa26XU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795706825; v=1; x=1796311625;
 b=F4BGsX4wltLX19n0RQ8e8Lt6Xa7f1+aUnz+D6fm9t8CzdvEHQAYwU+IaId0QNmsBQAtY6/2P
 u0mi9Zje/Mxd2bT8bJP8x4XrSBVRCtPhYixoPR9WsY19bI+h7mhdfQbTumZkt06dDUk+TSDh4Ge
 Y9/YgJmw2wdECDMDiCLOEwX0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a9864cef7e22ac7f;
	Thu, 26 Nov 2026 15:27:05 +0000
X-Mizu-Trace-ID: a9864cef7e22ac7f
X-Migadu-Flow: FLOW_OUT
Date: Thu, 26 Nov 2026 07:26:59 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/memcontrol: expose anon and file reclaim statistics
 in memory.stat
Message-ID: <20261126152615.GC738059@shakeel.butt@linux.dev>
References: <20261124-memcg-reclain-stat-v1-1-c6cb14b0d917@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124-memcg-reclain-stat-v1-1-c6cb14b0d917@gmail.com>
X-Stat-Signature: cfbsgqosz7ma6oqf3apy3d997aq3qmfe
X-Rspamd-Queue-Id: 5CF4920002
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MSGID_MULTIPLE_AT,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795706827-623175
X-HE-Meta: U2FsdGVkX1+fZhgHUSxmnTuQCdVVlPjbpYR661KEXhVCoZkwKfKYQtivY2sGayrWCPoAqlH9alqlLDWYn7l0e5vcV/XCAm0Dmyrn6oEd3tRahm/Aux+Nq0TrZyfukmp3pwejGBBt2A9N030MX+kimE/rZV3sYOy89/E3FvCX7qRXqxW+kF3pNNaZ8Hxcy5lA9BPFjGgGQojELNKtLcYcESY8W9RWIC+9Y9JJ1bL/ErtBCYyR7/+VORTcMNGFVOFbjI+6UtojHkMc97D03yk47wmlKQ7kcn+lk2MJqueT6BjPLHJNdbQrLcyH+bGAvcVhVE+AYt43VfNRXD+YnvuqUd6boovg+6jp2tbnmA+zxuVFM7mCVCPESJUVbBz7G09H9BTlDHYLIEGyFR4ay0KRpQ32xUFzs9wtnbPeKbnjHnLcw6q49IetAP2MxkfpDOQAIrGHLfydb9VlEqiYpFzy95J5LgCiGCw1QabpFlK5SYZIKiobO3iv7H/Ev9wcnJvy3UhnbeJOP1HKPXPOTFMTp+Je9P9iPkYN6nxN/sgnnTBNZZH6QkjZxGxr1z11WfL+5RTEXALwDFJJdF1JtYJk5Cp5yOtcFHMl6J0ejhEuFxykanS1PTbZA7muuV6axO9KQBSjtTItyPDy85Wmo6qfF0I8sxhpv7XqsHGyYezmjFzM6Uqfl117ugC1+rFnVFcUbpqEAOlSXS9mH2BKsz6h0nlzaKzQxr0XdxgPY+k+0qNwEUkhklpAtiTRJ41SGcpWhDLRjFDsO2NJzYKHulHxiaK7G6tNALLxwkduKtSQMT18I5uKIzbuhJYlBFx4pE8669DdG38XSnNtmmL6VF00ijHpJNMhVUm4L/FQRw+NxsNXwwwxsE8EvvuE9aHwBdzkowOrzQXHi1j7cKf47khYiapRd3Jm1lRF5OmOlUMyUoXUNEMzoVgyr61ifw0702PAQAXRSDlTk3UHcMXFUGw
 WaOztQZ5
 eWWcAtYFKFo4YGqiYuLa5AS9KtmbBYQiMWaLwuVVVs1WWJN54so4dnyJaDkhCd8w96Nz8xv5H2RXt4rm68ke75OB9OWGALcM2/nG/qXj26Kfdg9kd8wBG7cQazI0qruLblk40mh37/qmtyWTHvVZ6PP7SAWkQq+Qael9WcudG+JG86wRFKOxyjumTjniwc1Q2r6aCTerPaYj0TdjXyQrNCpEvyjvwm7DQmDGEnBCNAq9GJHG/vqfpDvByPKvIbQfAmIIIpXYsST9eVkvbY1ynIezjiosskYdEoO/V8SosONSZdQt2ayLqPwDdano6X54XSK05YEUU6MEXlRHMf7cda6YCaErIuRAHFcUXEtYRa3n2FLAJNfte0G7k237QperyABKr3K9I/HqBePPhTmTUVTNpP1/Lzh8xcKPBrRu2FwveSAe5DA6ODio6pzukG/wZ1lOh0X8/GXNWbcz7YBa1IW8/vWsnr1k+bV0wmvTMHUreqonHNz0N7gkaEwuftWB/gefWFAeApCU8dIuampWRkDTDNyCPKt88jpZOwLvNjjfpTtwYwX6ZjPeQgdd7sZef73FZyuHhONw93a8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 03:51:27PM +0800, Xueyuan Chen wrote:
> The aggregate reclaim counters in memory.stat do not show how reclaim
> is split between the anonymous and file LRUs of a cgroup.
> 
> Expose the existing per-memcg scan and steal counters by LRU type so
> userspace can measure reclaim balance and efficiency when evaluating
> reclaim policy. Report the same counters per node in memory.numa_stat.
> Both files report the counters in base pages.
> 
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

