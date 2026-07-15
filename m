Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CB43C4450A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:37:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BA746B0096; Wed, 15 Jul 2026 09:37:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33C1D6B00D2; Wed, 15 Jul 2026 09:37:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1417D6B00A4; Wed, 15 Jul 2026 09:37:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C448A6B0088
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:37:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3E58A0181
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:59:56 +0000 (UTC)
X-FDA: 84991018392.16.AEA4E3F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id CDA80100002
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:59:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TDojiWSB;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784120394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U+/oYZie1wlRVt0EOqLK1nvaTbYvCLc0MdBf4vus2Mg=;
	b=caAv0IVni2+LHd+iCfIsuTNIN6+ZO4w3vBzQeamRMHmEILdlFlwUjQYQD452gfy1nZTtsz
	3bu1N1BDrdAbzIopQK1jg83UlFjrTHALnako9rsR5NML9eI8p3ihFpuaC51S4Apf0qzyTQ
	QLezqaovgnxwNWL+pSo/3IQjeCbWNoI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784120394;
	b=sLktHRGZlzqAIZXSnuuyprkQBQTVP+oqe3QA7BOUmok3IVm/erkxtTQEOgLNA2CRI7bIcJ
	VA+TM3mPKgscsF2brADPw6YMrqJ/3VF/bBhkzW6QScdg2ca9jlLc0yv61OkRQXKdZLuLiw
	WOgmeTqTwjBGMGCfzA54fc7/5KBQnQk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TDojiWSB;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A02B41FC8;
	Wed, 15 Jul 2026 12:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3AB1F000E9;
	Wed, 15 Jul 2026 12:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784120393;
	bh=U+/oYZie1wlRVt0EOqLK1nvaTbYvCLc0MdBf4vus2Mg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=TDojiWSBNJJ6rI5kdkcQGawZH/Lu2ljtrTXZLi+k0l5LTVuEJ/9zJSYOEVSvjCdOm
	 ED70I7IMb3mjoVFolWFueD2Snl+sDaZ+q4RCMAathPncNGWzmoU/GJYhhlU42jsjuU
	 hMNwl9oImdcKVknG51AzxlN2yjIdwULEA8zLalknDJYo0XCCMSxkMYnIp26+JUFgff
	 DsG+2pnLh+khDtBoIB2tD69ZHPyIpIAN6FSycNx2yFm4ZnuvwV6V4yqY2w9X0BZ6tV
	 zvODD0cGQiAdt2/4KM11WWt6nGESNWdqddq2udmTrtZOxYqxmWLbk9xdQJxWLPfh5p
	 tsdT20QzPNDLw==
Message-ID: <70392f94-137a-4220-8ff5-64dd874cf5d9@kernel.org>
Date: Wed, 15 Jul 2026 14:59:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/page_reporting: Add page_reporting_delay sysctl
To: pratmal@google.com, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>
Cc: Greg Thelen <gthelen@google.com>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260714171456.2350037-1-pratmal@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260714171456.2350037-1-pratmal@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CDA80100002
X-Stat-Signature: rsjxh6coxokejkyxfq479xf4461qq7d8
X-HE-Tag: 1784120394-867625
X-HE-Meta: U2FsdGVkX1/hgsTHBxLYklvvy9ZSMCBhQeQ5FQlvCWNDIjpAZlYSlxQpqi4i0k4HzmmeMhqKW2g2yKvRIYY3M6kdWY70erBVA+UpmlrDRrLyw6Tjh1PyngWhaiW1GbtcrbQ10Q6GgJE2qW8kf1YlHr9q7c4coByi8z+VfkZKQFfC0uTrtXUKIpkF8sQpsbnSmK0y7sbvfheocBNqJZJZIhrlWU0dPbwCHvnPl1WBqB9T0u1dST7EcDU6/3edSCKTKY3BzaK05Wca5D53T2W4svBJAXyy7gYQwba02yZ/jQgwROx59NpLHYzTFqDUnbhHKXVt2h54ZyfM0NY4S06SSE3vBdzPPVVflDJGNZCIYaaE7PLafXn15KHDW6iWBrrKcORRv79IcoalL3Gng43bZEdXQqSISEY9AWO94cl0ibGnIslQyUUWbGReqDhB/ChLEarXAXLUQEmGGGMDYkJ/iuXMjh9kvQSLtJfZyS+Fh4SZ3wniXxiNHC1d/3oCv5FwE4redZq2AC4jnizGp1gIOSpEH8yf+xIQa+hzyczt4p6le2glgPAD4eOZnGRp5Fk472SvLSmaQyrHYMVFD2cFkpwDNzf4q8lWx02fXENkD+DyavfNr52ymUs1ikjigmgPhEpNYZfItOuc0J8AtL30mgmSubL6c/DA+a9kui001DPFXQSjIclIDZMKqxgd3fr9nJ0rrgRViWoNmagbk1e7HSUPD0ET38YwE/fHU/+zzHk4ZXMfGnLDtpJilFXyv49EgmlpAppviOmsfBu5Xt67pCp89slFrRL497+mUBFGcMZiVkHqxMxQPFDCqK4tRCkFA765lzMl9FqjKGuNJrzEGN+WZV/arAm7afpAd56y2amv0WKiflsEDs/DkDJzmYqIYWaae1v1HwAfzrBupJNikuktagofFrsJAKjBy5Hj3Dfi/FD+N9a4KPbhHwEPZ0VhEwOaLOLQ5uBvhb1jhbD
 WHpTcMUk
 jpNs5IJDVIgLo47Mxax1X+v59S9tyospmOV1MVvF6oDV2NhyXoloOxOGYFdgZn81Q+x8ELtyacZifjmIeC5DJ9Q2lmdOobN8AGgUG/dPY42kLuda2SwgLGeK9nUIud7A2UwuKmFtlE+N99crTb1XIJryesDMk369YAdXcyYEGa+XeJYwfZMqppa6vr1HrajVpj6uXBlmeivgUEjdJGlmz8qrhndjfoedTmxwoJ4BIdgV+loShDfhPnVbW88k+RxO2RXjlo5HjqL/Nkbif+1ivpsbI2dZilEQ1fw+Kf8/HQggK07ZAu9sV671uRU3n1rieFpgi182jdJwhtQEsIjEMSjfrOdBdlN3z8CKaghMstQJvtxWtASoKXgtoNHGIcfKZ+4lf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/14/26 19:14, pratmal@google.com wrote:
> From: Pratyush Mallick <pratmal@google.com>
> 
> Currently, the free page reporting daemon uses a hardcoded delay of
> (2 HZ) between reporting intervals. While this is a reasonable
> default, it lacks the flexibility to adapt to varying guest workloads.
> 
> A low delay allows aggressive memory reclamation, returning unused
> pages to the hypervisor as quickly as possible. However, during spiky
> allocation/free churn, this immediate reporting can lead to a severe
> performance penalty (nested page faults) as the guest re-allocates memory
> that the hypervisor has just unmapped. In these scenarios, there is benefit
> from increasing the delay to batch free pages over a longer window,
> absorbing the churn without hypercall and re-fault overhead.
> 
> This patch refactors the delay into a dynamically tunable sysctl,
> /proc/sys/vm/page_reporting_delay, measured in milliseconds. The value
> defaults to 2000ms to precisely match the original (2 HZ) behavior.
> If the sysctl is modified across reporting windows, the sysctl handler
> immediately issues a mod_delayed_work() to honor the new configuration
> without waiting for the prior timeout to lapse.
> 
> Signed-off-by: Pratyush Mallick <pratmal@google.com>
> ---
> 
> Sending this as an RFC to get thoughts on exposing this delay as a sysctl. 
>                                                                            
> Benchmark Results:
> We kill a process allocated with 10GB memory within the VM and mesure the
> time it takes to report all the memory to host as well the delay in
> initiating the reporting.
>  
> default(2s delay): https://drive.google.com/file/d/1Ouxm_raj4xPNthc_ryk0Mdbo-c_zXKiP/view?usp=sharing
> Tuned to 0s delay: https://drive.google.com/file/d/1mk58LPiYgIF4Yk6kmX5JHplhrwIw0NbC/view?usp=sharing

[...]

Hi!

>  
>  #include "page_reporting.h"
> @@ -47,15 +48,44 @@ MODULE_PARM_DESC(page_reporting_order, "Set page reporting order");
>   */
>  EXPORT_SYMBOL_GPL(page_reporting_order);
>  
> -#define PAGE_REPORTING_DELAY	(2 * HZ)
> -static struct page_reporting_dev_info __rcu *pr_dev_info __read_mostly;
> -

Why are you moving that?

>  enum {
>  	PAGE_REPORTING_IDLE = 0,
>  	PAGE_REPORTING_REQUESTED,
>  	PAGE_REPORTING_ACTIVE
>  };
>  
> +static unsigned int page_reporting_delay = 2000;

Maybe "2 * MSEC_PER_SEC;"

Would we want to call that page_reporting_delay_ms to make it clearer what we
are dealing with?

> +static struct page_reporting_dev_info __rcu *pr_dev_info __read_mostly;
> +
> +static int page_reporting_delay_sysctl(const struct ctl_table *table, int write,
> +				       void *buffer, size_t *lenp, loff_t *ppos)

We prefer two tabs here in MM land.

> +{
> +	int ret;
> +	struct page_reporting_dev_info *prdev;
> +
> +	ret = proc_dointvec(table, write, buffer, lenp, ppos);
> +	if (ret < 0 || !write)
> +		return ret;

Would we want to cap it at reasonable values?

> +
> +	rcu_read_lock();
> +	prdev = rcu_dereference(pr_dev_info);
> +	if (prdev && atomic_read(&prdev->state) == PAGE_REPORTING_REQUESTED)
> +		mod_delayed_work(system_wq, &prdev->work, msecs_to_jiffies(page_reporting_delay));
> +	rcu_read_unlock();

Is that really required? Seems unnecessary given that we expect something in the
range of a couple of seconds max.

-- 
Cheers,

David

