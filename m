Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9214ACA6019
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 13:18:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65F1C6B008A; Fri,  9 Oct 2026 09:18:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60FA96B008C; Fri,  9 Oct 2026 09:18:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 525C06B0092; Fri,  9 Oct 2026 09:18:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 32D1B6B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 09:18:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 49D9EA0386
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 13:18:02 +0000 (UTC)
X-FDA: 85303140804.22.1211F62
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf18.hostedemail.com (Postfix) with ESMTP id 77DCB1C000E
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 13:17:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791551880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yKhIa2BxIE9CwmVR3h+hBy0tZfLELToBXYzMXQVHbuA=;
	b=SBtYFvxl2Qt8F3O4DJyzx0R0Z7ZsUPRY1nTk0OnGz0fBICshNAd0w6tIE4OwIomgq2XO0S
	xEgSfPZ4eDlBYGvqHArFpRY+E1J+Uj4fbolTtvkVZlpL5G/obYNk8nAKEgd2FPAiY8Tj9P
	sgTrTyJ1Xms8l9IokCElEzTM4SgB9Rw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791551880;
	b=xM3yLJN4fOh6eWdjJpvI+vuSvqP0Frojh4JaQX/jSOXhz17OVmJgOmNcFQnRmtbKxfBnD1
	XN/qpx/cEcZY+S+WjBCurZHnwxgGVjUzp0Li0t+8km2qXw3TZZ6eU0e6OmVnOzZ+wR0983
	AIH+jUP9+QiLoTrWkmnVAfi0/hC6i4M=
X-UUID: d060c5aac3e311f19a56ed5b684f684d-20261009
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_7B, HR_CTT_TXT
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_LANG
	HR_MAILER_MTBG, HR_SJ_EXCLAMATION, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER
	HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS
	HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED
	IP_LOWREP, SRC_LOWREP, SA_TRUSTED, SA_EXISTED, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:ff4cd9fe-8e8d-4a47-ada7-5a8d274110d7,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:ff4cd9fe-8e8d-4a47-ada7-5a8d274110d7,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:a8148f165c59302f2387d8b6976bcccf,BulkI
	D:2610092051192DZE6Y7F,BulkQuantity:2,SF:17|19|64|66|78|80|81|82|83|102|12
	7|841|865|898,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil
	,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BR
	R:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d060c5aac3e311f19a56ed5b684f684d-20261009
X-User: lienze@kylinos.cn
Received: from [192.168.3.106] [(111.193.136.161)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1412359089; Fri, 09 Oct 2026 21:17:44 +0800
Message-ID: <51f3b5a9-9d1d-4075-8cfe-18ff4a912524@kylinos.cn>
Date: Fri, 9 Oct 2026 21:17:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: drop the empty register_all_nodes() stub on
 !NUMA
To: Muchun Song <muchun.song@linux.dev>
Cc: osalvador@suse.de, david@kernel.org, akpm@linux-foundation.org,
 linux-mm@kvack.org, enze.li@gmx.com, lienze@kylinos.cn
References: <20261009092832.393778-1-lienze@kylinos.cn>
 <286A8A23-C420-4393-ACFB-361CA14BE316@linux.dev>
Content-Language: en-US
From: Enze Li <lienze@kylinos.cn>
In-Reply-To: <286A8A23-C420-4393-ACFB-361CA14BE316@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jy7ssf8dfmmnypmimpq8my4c8o5cwwfb
X-Rspam-User: 
X-Rspamd-Queue-Id: 77DCB1C000E
X-Rspamd-Server: rspam08
X-HE-Tag: 1791551876-708720
X-HE-Meta: U2FsdGVkX1+oIiJoMUMBp6LAeQ0s21iUXw2OzBExW3SPjzfJqtmBkeAhJoQ6jY51ym8S1sJsc1vX10jT5tr/YZ8ZLSYOd6OSGeC04HlKP5wdRcKc7ucQUgtqyYXG1STazR8uVhtIxeByNRa377/PRBzGXQZdTpxqAX2YQYr6AQaZiD1FVy8wiSZVcK0GaEt3mV5nPoJ6Z33WgR1j0VXdqz0hhAWRL641geLjbpB9A01FypnPkWn2J7C2JpC1sJjykKASALS2HAVnAkQxVSazq9VsyKWDbkxICVSYvIimVunjF5gGdc+ZmduKe7Go5hG7JU54u51QuGcQeEczAJWZYJrhvtlAttnsgQi3Ka78vgk78Ro5sI2a2i5atRPI/fXzHlmVJ+lIbFrPzEY1WiJJHWInnGsJ3LKTlnZ081LiMRv3OrYUU9ZbaNMTVD6G6y3hXXxeOPQuvMYCjo4a8VlNbAlj8X5Wkaw1woSCcsPdfFxhN6VzbJA2aD2NsMcbSw7IbF1ol3fpBkguSfIMBf5dHcb14kVa70MDMsYVJ3y+bqe+01StyoCUQOc/l0jRZaoAMKOfcmsnA3r3ai8Vme6cnu536k4qlu6ZGo4XSrGGd0DFcBS+OYI6ucCWVWZkcjyn2WlG2JfPSsxqICJlfM0W446EXsgS2tQqvLAuc+SHSoAGbhRjQoFDO35qzVUvWDQza4oCmSyu/g5INE56XVJJ/efItj22frISMbNkTqp/nIZssDRQe9LjAhCPSPHn9xq/UcVYgfT9v/gzXtEZcYtlO81WrMp2Q+NpD/X05AuHOj8EJmhcNXC4wpdZfVmeOoMzbybIMG4scQkz37tXtNB53Nqj2NaKSwoYMhM357QAtk2BAZwssNVhfUBhDSyE78AqfP7j5ogqYPncwQID8Wxk841N64FmlSMwZLxVD701nF2/mvJ2bxdtbrw6vl2I9x91oEyM5bLT6lTC3FhjPSj
 MRsTPIe+
 2CI43+6+ahdvP5X3oP1ErXnTk63y48L0CN71Rk/JAa7tD0Kc4Q/ofGiq83nmS8iTwt5JXZDctOC8qkIEzamfcP8vBln3/Srkia90kzHOPtEHHqjPUby1nY/jKisy/MGrkUyN+D/ugvRi8oTk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Muchun,

On 2026/10/9 20:50, Muchun Song wrote:
> 
> 
>> On Oct 9, 2026, at 17:28, Enze Li <lienze@kylinos.cn> wrote:
>>
>> The only call site is in hugetlb_sysfs_init() and only matters with NUMA.
>> Drop the empty !NUMA stub and move the call under the CONFIG_NUMA ifdef
>> instead, keeping all NUMA-only setup together.
>>
>> Signed-off-by: Enze Li <lienze@kylinos.cn>
>> ---
>> mm/hugetlb_sysfs.c | 4 +---
>> 1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/mm/hugetlb_sysfs.c b/mm/hugetlb_sysfs.c
>> index 326a54b4d991..de439b3b7f01 100644
>> --- a/mm/hugetlb_sysfs.c
>> +++ b/mm/hugetlb_sysfs.c
>> @@ -475,8 +475,6 @@ static struct hstate *kobj_to_node_hstate(struct kobject *kobj, int *nidp)
>> return NULL;
>> }
>>
>> -static void hugetlb_register_all_nodes(void) { }
>> -
>> #endif
>>
>> void __init hugetlb_sysfs_init(void)
>> @@ -497,6 +495,6 @@ void __init hugetlb_sysfs_init(void)
>>
>> #ifdef CONFIG_NUMA
>> 	hugetlb_sysfs_initialized = true;
>> -#endif
>> 	hugetlb_register_all_nodes();
>> +#endif
> 
> Actually, I'd prefer to keep the stub myself. But that extra
> "#ifdef CONFIG_NUMA" is really annoying. Why can't we move
> "hugetlb_sysfs_initialized = true" into hugetlb_register_all_nodes()?
> Then we could get rid of the "#ifdef CONFIG_NUMA" here.

Okay, will move it into hugetlb_register_all_nodes() and keep the stub
in v2.

Best Regards,
Enze

<...>

