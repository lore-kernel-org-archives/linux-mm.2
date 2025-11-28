Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C4EDD116F3
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 11:23:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D33EF6B0022; Fri, 28 Nov 2025 06:23:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE4BD6B0024; Fri, 28 Nov 2025 06:23:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C214E6B0027; Fri, 28 Nov 2025 06:23:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B15AB6B0022
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 06:23:32 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 45B0089B49
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 11:23:32 +0000 (UTC)
X-FDA: 84159780264.26.4857889
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6E2EA80022
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 11:23:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WDPd+YDR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of fushuai.wang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=fushuai.wang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764329010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t4/H51uaWVpHVj7Na1I0I3Iy+BFCyBmc2I+NPnG0fy4=;
	b=PhVj9S+t5A2PVqXFBw5B0ML8Yc+soGeU6lqve/gRc25A1wBkNr7xe4ni6aJ+4I5HJTRliC
	2QqJdKyxxfgGvv71Xp8twEdKdVB71z2dz+BtuaZhGD/X3xyzET1lomzyZkPEANyOqr6EtT
	1+TQHH/eJBrtyFRHVnKNYIC6Asq6qlc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WDPd+YDR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of fushuai.wang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=fushuai.wang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764329010; a=rsa-sha256;
	cv=none;
	b=Za/mCkzeJboVE8nKh+I1YUomF7Qt7/gd+fOlQPq3etmB0rKOsLM4nQVkwJCQjX3Ha0o0jv
	dKoVDzx7ULrPwlHKDTRlp1AZsn5ONoRICLRaSSWkhhUsD8dva9OAQlrnEcabdjzqktssFF
	KCIgB/e8IYBAdMZS1shrW5QIWVOZVuQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764329008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t4/H51uaWVpHVj7Na1I0I3Iy+BFCyBmc2I+NPnG0fy4=;
	b=WDPd+YDRjTd/U1XuFNbZNN2HyyJ8X1LNUPgMkITtTMEaeu4k5Oa66twKQbzSUmJ49uOtiR
	/Lpul22+nJotsALHDa9qYYnKIsfbg+b2iEVB0bt4txbm+q+GyOxw/G1x3yHxVuV1KRqe0U
	UafMHDEADBF0HQIbN3eyT5YMPdVN4mI=
From: Fushuai Wang <fushuai.wang@linux.dev>
To: david@kernel.org
Cc: fushuai.wang@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	wangfushuai@baidu.com
Subject: Re: [PATCH] hugetlb: Add guard support
Date: Fri, 28 Nov 2025 19:23:07 +0800
Message-Id: <20251128112307.80237-1-fushuai.wang@linux.dev>
In-Reply-To: <9cb0a602-69ca-400f-890c-e9dd5b44f53b@kernel.org>
References: <9cb0a602-69ca-400f-890c-e9dd5b44f53b@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E2EA80022
X-Rspamd-Server: rspam11
X-Stat-Signature: h1uq7mu3nqn9o9t8ow8knxipo8qaohap
X-HE-Tag: 1764329010-972540
X-HE-Meta: U2FsdGVkX1+3p4IFLAJ7rqWXqSSKtVeQKwO+xEfeMPOQsmMKxNAKrwYLlZbRlamYgxKQqIxhOpkOEwY2IPL2ooaRoM7iQdPKwlFPIvYPcaOY11KFocDOi/43nQa91J+ZKvpxkzOi9awMF0U0e8D8vdxKv+HP8SVS3tUF0seiF2OvzSQwBO2vp5Snp4kQktIZ9QyTTyMR1Cj2FgVz6zNcqbwL5k2vCeg56y7P7Wtk8rDCsrskL13SV9JWPrFCDfXqZA0RIDBgGibtPYuKNQTFZ8ysApwC0wJiFiRWjXZK663PdiShhCKyk0/YjLxpXv7OhqtrXxe0+yJsZu3yLeVGAA+qL1o/AJpvgBWRubK1JdySdda8onrMlztpg/v1BOIsJ22h5Apm/M9HCWU6SXCzxvauhF6PO0zXSObsZ9T/ESuYqgJm6dl6MB8DCLKuySfQ2jIO6AxrY+t5z0wjlHdH8VOECVnfo1qjrhxPep+BlAIfGeC6O0e6OX491F+u4EdddcINOYz7z3n2Xny2Pb32GS7oq/xx09oXxSmkudgmpvLlkeZSiHR2NrCsQkbwQoGYAsctuYunQA0PVVY/hU68ILCwlsvYjud7DvBHsKc/USKNumGzy4GZCye/K7GCiS1US1g+IHlY5+Q2Vj0Wpb78WNXJ1GZBLVCVJ7dxFopYH6vz9OWGGONvchCBvCm7vfL3VnQEp5grwhFRywMXRouG1jTDueJFzOiyAGZdi9LmThAnXnYeBHc7x5Wd0Cp66kC+OvCfAJaN7e8WV8mhtytiERjwqGKco0N28rdvI9Il8dK4XO2fLYZa84CftXT2FCBYkeUt0pNJI1UwEu2HbjO1iaZC+mMVUYI2uX3ith1ZikN3GfZu4me1DUNnowOXdGJ3WAB7yZjSrjrw9XGx8JkpKNSpaCkVBz5Bdu/C31w1jaPMwDkj/S2ZvfkETsVIyQxnsD1JDlQKDROXC3XmfHg
 8cspMgyH
 +mDc3W2tRb8aczWRhf/jdMhG7L0StC8MsenPZU7rg9p9iPDBwZab3Km6X8x3u8S6YaNUa2v7oZCy8io8KmA+4z8yI8N3TGtIXwNBZyVa1YwcN57C4j/9+xYuTNee6BpA8j1DpkH+D1H5V5Ik8NqcUES3YutGePOYwRJYQvn6z7QK804QFQTC+Wu+XOLwTJClavU901iMuexxa3Z1zEY0cI4eanLwWNPCNoBQZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>   include/linux/hugetlb.h | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>> 
>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>> index 8e63e46b8e1f..f97cb2f123a3 100644
>> --- a/include/linux/hugetlb.h
>> +++ b/include/linux/hugetlb.h
>> @@ -15,6 +15,7 @@
>>   #include <linux/gfp.h>
>>   #include <linux/userfaultfd_k.h>
>>   #include <linux/nodemask.h>
>> +#include <linux/cleanup.h>
>>   
>>   struct ctl_table;
>>   struct user_struct;
>> @@ -468,6 +469,13 @@ static inline void hugetlb_split(struct vm_area_struct *vma, unsigned long addr)
>>   
>>   #endif /* !CONFIG_HUGETLB_PAGE */
>>   
>> +DEFINE_GUARD(hugetlb_vma_read, struct vm_area_struct *,
>> +	     hugetlb_vma_lock_read(_T), hugetlb_vma_unlock_read(_T))
>> +
>> +DEFINE_GUARD(hugetlb_vma_write, struct vm_area_struct *,
>> +	     hugetlb_vma_lock_write(_T), hugetlb_vma_unlock_write(_T))
>> +DEFINE_GUARD_COND(hugetlb_vma_write, _try, hugetlb_vma_trylock_write(_T))
> 
> Do I understand correctly that the code you are introducing does not 
> have any users?

Yes, it is not used now, but it can be used in future development to simplify
the code. If there are complex hugetlb_vma locks in the current code, this can
also be used later to optimize them.

---
Regards,
Wang.

