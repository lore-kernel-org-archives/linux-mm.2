Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E92B3CAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 06:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 120B38E000F; Tue,  9 Sep 2025 02:35:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AA9C8E0001; Tue,  9 Sep 2025 02:35:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDB188E000F; Tue,  9 Sep 2025 02:35:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D98058E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:35:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7533C119C7C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:35:07 +0000 (UTC)
X-FDA: 83868749454.11.98D4405
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 93DBCA0004
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:35:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757399705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6SyF6S2z7iSvFsXo6rX1g8H7dTADC4DXpvds+vngRao=;
	b=LI8+4nQlMm95Dfe9zfXwdK4cu1gaFrfLVEHOIQWar86vbBFuPac8nW0CegFR2u8U0Ruu8W
	lwrUSFXCCLVN2s3ZfYTB3M5Siv9fyAWkcg+0NmrilhfYshTYKsg0UZddOTf8KsG7So1wAG
	dlPKWpqVw0yApQKnNHtg4CP3KE6woRE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757399705; a=rsa-sha256;
	cv=none;
	b=roC38eCRsAo9kNE8t/QeNVqoGtXrQDKbMIlwjBAMlU4LoYs9fXjNWtw3vjGL2Da+EkeZ81
	ycEweiFvhVo8o9cDtlvXq5LzRn0NEubXBWCv8YkzMj6goI8sp/CdvHask2Plw7LsFKEkEn
	ik4fvLGzyeDreYt8kTX8UHGxDQ2I0gw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 110D315A1;
	Mon,  8 Sep 2025 23:34:53 -0700 (PDT)
Received: from [10.163.72.34] (unknown [10.163.72.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B33733F66E;
	Mon,  8 Sep 2025 23:34:56 -0700 (PDT)
Message-ID: <ad5f03ab-c543-438e-9b57-1f7f62cf8207@arm.com>
Date: Tue, 9 Sep 2025 12:04:52 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/slub: Refactor note_cmpxchg_failure for better
 readability
To: Ye Liu <ye.liu@linux.dev>, Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>, Harry Yoo <harry.yoo@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250909013307.1093853-1-ye.liu@linux.dev>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20250909013307.1093853-1-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 93DBCA0004
X-Stat-Signature: juden8zrrgjjhj3qhxbbe5nwy1sdnfud
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757399702-160776
X-HE-Meta: U2FsdGVkX1+WRshBbGujDSnwv/MYTtuk+KQyTScW6SAObqIvn4Ag/LBDgLVpc9YXYedSlb7JssSlq5wnnaT0oQ9YaPsZ5T4sRHQhnCrrrEMA8R08Trl3ezK+QoJ9LcbkBZpLKM57coFQYa5ZdisMQAcbp3I9FAInYSam/s76klqEWV1ecYkjFTXtZMnMxmFq+yoSD5WFMjP83HOiLAK8tosWlu/ZwrL7xnE1u1iyM/7OywzUx6ReKHhvkfITL1T/6GUSD8wNRcaGzpNBSgGT+82UNrtrpk2tSZrr3VE9UhHWOD9oN5exTrtJQQQwTQV59FREHTrvmHJC7V5J6SiF7vizRCeqNDjWXJd2WGiRo6cTkJuVHXydY3UkcsgStewwwcuGOQtpLC1w7qjY5RjF80E8+zr9J5ROEDjHG65sV7X+gI13nUri7rTpR4k8T2uoFqil2zLsYq/rM84F3XpHit7erkjSh2tcZKXnkSZu0Zv1+zS3kIBEjq3Dq0GRMz9/t/rhqbbVeVaaN9pYDvYhjASwm9oKcMkwgLpmqQMXlgI5xwwWxa9SZa9YIrjEx4LOJwlImTsQdLL71iVGXz4JYGOyP8F2lDGWCLbX2xK2cAphfzliEgSXeibpvn/1TsoxCLKD02IDIO7B72ULJl8mePk6ohDy/eKxoiI5IPN0cMYNMydFOvegTWZsQLv86SAAXGBJV5+msNHXVhZdSUTKa9tP3aQHtUYWcmlat7d4oHdcN2exNCitxtSU4CYVy24wsWtCfumD+MrRgqQ7RLVB3mB3pIjtona7VfhWoM8xdhWVoYtJOWiJ4DtJPljKVgrbdr1oegoYp01XibT85K+jakteqfhIZWRJiiBesG2nXnp11OHW9Sb27Sjw3ix+HSV6Sh/9puwaV9tFqmnibHtSKgb/5daqDNup7fa/GCDc2bM8+ZWLaB1Nx9TKU0PmBEjmMVkS3s0FPiKbvcN6j+n
 BrsSw4qb
 0nG5jXWxeUuh0rZ+JAZQS4QHkX52Rft0S+sXBaquiupSlohgM0svytHMrf2dO4Ck5LiKtP+HMgfAxbF9kGpowP2N/f1O6TdMReCuZGmyC0JSuekyUY/OG6p3iYitO7WuRs0MTqq07nkivnSwG8bQzUpbZeJXy3EWqxSRBGg6VWPNEqq2HQALw2vUx3TnTKpI/1+QOmOxGE7Zzt5CbATEyJPMPQDLMXdOBFiqoIkVF7rgaYf2pT2df+3ljae18xpg79zuUof6DLj4n3/LZn5aXSDfRraeyR/88peW5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/09/25 7:03 AM, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Use IS_ENABLED() and standard if-else to make the code clearer.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Reviewed-by: Christoph Lameter (Ampere) <cl@gentwo.org>
> 
> ---
> Changes in v3:
> - Add "---" in front of the change log.
> Changes in v2:
> - Insert newline after && as it's more than 80 columns.
> ---
>  mm/slub.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 30003763d224..5711d6d29a3f 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3064,18 +3064,17 @@ static inline void note_cmpxchg_failure(const char *n,
>  
>  	pr_info("%s %s: cmpxchg redo ", n, s->name);
>  
> -#ifdef CONFIG_PREEMPTION
> -	if (tid_to_cpu(tid) != tid_to_cpu(actual_tid))
> +	if (IS_ENABLED(CONFIG_PREEMPTION) &&
> +	    tid_to_cpu(tid) != tid_to_cpu(actual_tid)) {
>  		pr_warn("due to cpu change %d -> %d\n",
>  			tid_to_cpu(tid), tid_to_cpu(actual_tid));
> -	else
> -#endif
> -	if (tid_to_event(tid) != tid_to_event(actual_tid))
> +	} else if (tid_to_event(tid) != tid_to_event(actual_tid)) {
>  		pr_warn("due to cpu running other code. Event %ld->%ld\n",
>  			tid_to_event(tid), tid_to_event(actual_tid));
> -	else
> +	} else {
>  		pr_warn("for unknown reason: actual=%lx was=%lx target=%lx\n",
>  			actual_tid, tid, next_tid(tid));
> +	}
>  #endif
>  	stat(s, CMPXCHG_DOUBLE_CPU_FAIL);
>  }

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

