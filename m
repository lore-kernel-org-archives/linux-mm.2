Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F218CAC5B9
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 12:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 763278E000D; Fri, 26 Sep 2025 08:27:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7139B8E0001; Fri, 26 Sep 2025 08:27:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 629238E000D; Fri, 26 Sep 2025 08:27:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 52A008E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 08:27:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EB162C0693
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 12:27:58 +0000 (UTC)
X-FDA: 83931328236.04.39F7DD5
Received: from smtp232.sjtu.edu.cn (smtp232.sjtu.edu.cn [202.120.2.232])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2C33440012
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 12:27:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of zhr1502@sjtu.edu.cn designates 202.120.2.232 as permitted sender) smtp.mailfrom=zhr1502@sjtu.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758889677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sbyhiI0JrW4vjFyQ/wlshJhratpquAgd2j/gXw9N3Kc=;
	b=aCNFqAktGFrSsOW2POJZ7bCoXt6cQ4sURjVUiweLiy2MANpM2bwREwPEutUHXfiQTwxYNE
	ETHJfkGeKkNWR6IzB8MEDVa6Dnr/whcllPUKCzoKUzXK7/0gU9Avvx9xXhANSFji4Rb2+S
	lsB7vhu7Iy+wem6bXNb3G8KJgyXR/rg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758889677; a=rsa-sha256;
	cv=none;
	b=7/QJTUZLDvDNnIQtgELyqIVPOU/90e8qGWKhnU5/FRdOUKnmwDPZ9H6bZLy8qkyWhxYq6X
	/v/HZ6O9Svip6qV1be1of8lMi7J7tVwe0iwEgZOedkuxi3XrTf0sszZcWK8/40JHorlNj5
	vwDpnHmpd1DZn90z8HPU6Yb5TNY+s+o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of zhr1502@sjtu.edu.cn designates 202.120.2.232 as permitted sender) smtp.mailfrom=zhr1502@sjtu.edu.cn;
	dmarc=none
Received: from proxy188.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
	by smtp232.sjtu.edu.cn (Postfix) with ESMTPS id 1A016124B5B6D;
	Fri, 26 Sep 2025 20:27:51 +0800 (CST)
Received: from localhost.localdomain (unknown [10.181.220.127])
	by proxy188.sjtu.edu.cn (Postfix) with ESMTPSA id 05C2B37C999;
	Fri, 26 Sep 2025 20:27:50 +0800 (CST)
From: Zhu Haoran <zhr1502@sjtu.edu.cn>
To: ying.huang@linux.alibaba.com
Cc: linux-mm@kvack.org,
	zhr1502@sjtu.edu.cn,
	dev.jain@arm.com
Subject: Re: [Question] About memory.c: process_huge_page
Date: Fri, 26 Sep 2025 20:27:35 +0800
Message-ID: <20250926122735.25478-1-zhr1502@sjtu.edu.cn>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <87y0q3e2ph.fsf@DESKTOP-5N7EMDA>
References: <87y0q3e2ph.fsf@DESKTOP-5N7EMDA>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rfkztkmqb8otmgjfws1frkfon4ijdif9
X-Rspamd-Queue-Id: 2C33440012
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758889675-735066
X-HE-Meta: U2FsdGVkX1+YhOARWH/gvF+76lWgANo7zn65eTILQvtIjx7YZNEXiosFwC6aytC3l61/ZVUEcWtbvPgPNh5/kV1xXRO7/lAZUZRs6Q5/uwdUkakHQJYJiYbA2ZpS0cINSJ/89MNHQM5OCshZxAVEU6IFr8rNfKxcW9t9WFD8Ymm1mIlXryQmg7T7r9ZtOoYvYLuf3LaaqS2AZTYZXXmGnMXmYV64J2GK/zIk1JbUJ+fNrI7jtlsXIgji+HCQcDVzE42FAH3Yi3P4SvM/KjmNWOkbPIudCCJONaihmk8pTij2joh3S4DGncuX7diwS1K2DU+m/v80WEsrn6M57Kgw+OYMxEQRPKAW5lZe4qX4uadJPw/yQiyH5CJvFrE7hAKut7lI52kZfS4L+Zr9QSDDyv1U0jqblwPi462r4YOBR6cFmN6RfVF0AUAMdeaTuW+NHLSNiF398aD7gYeQZbwgI/k3VcC/3tCXtF1VY7ijrjJ5A1ht0T3x4li4WwEmaYkMDR6BEHb2lzxbgkEScJC/wzDe3QJOCcQac4bcGP0HTVAe+gqP6ewrD11dWHJljUeiP+ORoiQpD88pNSCd1+5ruOkpzNDf0qWoIeOXKOrSJym5lkPzd5XnUK+Xe0nDdRWplsIRcxD201SDxiAYh3BH921CuT1EVP5WFLJ5V/EO3ZP5TbGu8g4WXrw970Em7AKOBJuOTFYFttqWBpPEcXqQCdCPbw76UwYvY81gmdhCujeJDb1jfCOvdfVbxaEVn37fkEYpqN0huQ2DG19rquaktZOFDWquvzx3HrCP8YhsGWm4c0JPMHDNKrRyNs68rFD9QQ9H2sP7ux04zCrqVRt91S2IwyjkqKRzeUgDbSHLRKlyCxtW4a2H569YM1Wtco11+1M7TRFNxzQmGJuBXilHx45Jv/mQ7o3ASIFDWcVTLGkQcYNNfbORdKGtsxgpXCmmQOQSbCZzn9MmgqolEKC
 98wl6LJn
 t1gxzjoODlreBR8ldO6h3zDeXDV8hju8cQUvwwckdIluKQjo6+N9xdjA/JpinIMxVNaJbogdgifn/QZOxjtTjQjBfvY/c0eiP9Y9bCUu82Kkx44v8FeTFLiCItWYJrYL2EJlMtrPN9uunOhuT0sUUYxgPcUNasRLol2csDENir7mPdtjSAxWq4A9b+bQKw3TCfm7Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Huang, Ying" <ying.huang@linux.alibaba.com> writes:
>Hi, Haoran,
>
>Zhu Haoran <zhr1502@sjtu.edu.cn> writes:
>
>> Hi!
>>
>> I recently noticed the process_huge_page function in memory.c, which was
>> intended to keep the cache hotness of target page after processing. I compared
>> the vm-scalability anon-cow-seq-hugetlb microbench using the default
>> process_huge_page and sequential processing (code posted below).
>>
>> I ran test on epyc-7T83 with 36vCPUs and 64GB memory. Using default
>> process_huge_page, the avg bandwidth is 1148 mb/s. However sequential
>> processing yielded a better bandwidth of about 1255 mb/s and only
>> one-third cache-miss rate compared with default one.
>>
>> The same test was run on epyc-9654 with 36vCPU and 64GB mem. The
>> bandwidth result was similar but the difference was smaller: 1170mb/s
>> for default and 1230 mb/s for sequential. Although we did find the cache
>> miss rate here did the reverse, since the sequential processing seen 3
>> times miss more than the default.
>>
>> These result seem really inconsitent with the what described in your
>> patchset [1]. What factors might explain these behaviors?
>
>One possible difference is cache topology.  Can you try to bind the test
>process to the CPUs in one CCX (that is, share one LLC).  This make it
>possible to hit the local cache.

Thank you for the suggestion.

I reduced the test to 16 vCPUs and bound them to one CCX on the epyc-9654. The
rerun results are:

                     sequential    process_huge_page
BW (MB/s)                523.88               531.60   ( + 1.47%)
user cachemiss           0.318%               0.446%   ( +40.25%)
kernel cachemiss         1.405%              18.406%   ( + 1310%)
usertime                  26.72                18.76   ( -29.79%)
systime                   35.97                42.64   ( +18.54%)

I was able to reproduce the much lower user time, but the bw gap is still not
that significant as in your patch. It was bottlenecked by kernel cache-misses
and execution time. One possible explanation is that AMD has less aggressive
cache prefetcher, which fails to predict the access pattern of current
process_huge_page in kernel. To verify that I ran a microbench that iterates
through 4K pages in sequential/reverse order and access each page in seq/rev
order (4 combinations in total).

cachemiss rate
                  seq-seq  seq-rev  rev-seq  rev-rev
epyc-9654           0.08%    1.71%    1.98%    0.09%
epyc-7T83           1.07%   13.64%    6.23%    1.12%
i5-13500H          27.08%   28.87%   29.57%   25.35%

I also ran the anon-cow-seq on my laptop i5-13500H and all metrics aligned well
with your patch. So I guess this could be the root cause why AMD won't benefit
from the patch?

>> Thanks for your time.
>>
>> [1] https://lkml.org/lkml/2018/5/23/1072
>>
>> ---
>> Sincere,
>> Zhu Haoran
>>
>> ---
>>
>> static int process_huge_page(
>>         unsigned long addr_hint, unsigned int nr_pages,
>>         int (*process_subpage)(unsigned long addr, int idx, void *arg),
>>         void *arg)
>> {
>>     int i, ret;
>>     unsigned long addr = addr_hint &
>>         ~(((unsigned long)nr_pages << PAGE_SHIFT) - 1);
>>
>>     might_sleep();
>>     for (i = 0; i < nr_pages; i++) {
>>             cond_resched();
>>             ret = process_subpage(addr + i * PAGE_SIZE, i, arg);
>>             if (ret)
>>                     return ret;
>>     }
>>
>>     return 0;
>> }
>
>---
>Best Regards,
>Huang, Ying

---
Sincere,
Zhu Haoran

