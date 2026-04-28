Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41214FF8867
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 03:33:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D7996B0088; Mon, 27 Apr 2026 23:33:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 788956B008A; Mon, 27 Apr 2026 23:33:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69EAE6B008C; Mon, 27 Apr 2026 23:33:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 59BA86B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 23:33:13 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DD01F1B91D7
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:33:12 +0000 (UTC)
X-FDA: 84706543824.09.61FF458
Received: from mail-m82107.xmail.ntesmail.com (mail-m82107.xmail.ntesmail.com [156.224.82.107])
	by imf13.hostedemail.com (Postfix) with ESMTP id 92A1B2000F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:33:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf13.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.107 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777347191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YE7kSrpy77fetDHEUUJoOm72XJeeq7v9u5lN3aVuKE4=;
	b=fMuIbket5kfkv0QXWBAA+L8T27+il5Eaajf8Ts2E+uXHXZRVji9QnxekiZXpSZ5LYT8tOE
	LHtF832KpuxZJC2aoAthOJs9Rsp02Tg2nPgNFfVgxeZXKA1VT+dFXCQF+tpsZPzQarcRAw
	uDu1sQM0Bt1sJs6GXTY5xODrD/QUBcc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf13.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.107 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777347191; a=rsa-sha256;
	cv=none;
	b=7kYQAxLnJIq5a7igf21iOja+Mw7EqrAtJAfsJNecT9DaqEfY0dMV76kRTcdUNkus6lSjmk
	WnKPnneqmFX5KtK1VPuKjpj0gBRGqAsKakGe0atYfmQX5hqL6Kp4M3z7AkGLY+e4/ZPUcx
	LC63m3lUpKyVDVcE+b9Wg+fKDFrHQ0c=
Received: from [192.168.0.18] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 19787b34a;
	Tue, 28 Apr 2026 11:33:02 +0800 (GMT+08:00)
Message-ID: <7944d24f-f29a-43b3-918b-ce25e7bae520@easystack.cn>
Date: Tue, 28 Apr 2026 11:33:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm/page_owner: add filter infrastructure
To: Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260419155540.376847-1-zhen.ni@easystack.cn>
 <20260419155540.376847-2-zhen.ni@easystack.cn>
 <12259EA6-2095-4F79-A7C4-E89DAFE9E8D6@nvidia.com>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <12259EA6-2095-4F79-A7C4-E89DAFE9E8D6@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9dd225c0b30229kunmff442fff147b25
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZSBofVhofGR8dGRkaSRpLSFYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Stat-Signature: j3tniqnchjrtb8gxh59p31pp7qsj3rda
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 92A1B2000F
X-Rspam-User: 
X-HE-Tag: 1777347189-903820
X-HE-Meta: U2FsdGVkX183VnimcslGyPLjuf/HisMhaBASu8X92nB/KllNYIuYJEggTSobaKUOScqdCwaBOvkjkjdQX9/AgSGuHnQtPgb3HYjqhGRqkRFsuwWgEZT3XdI/31oa6NUTMuJp5vza3/NlYbKludaEs9eiBeQRX2fb4gnZBTlfF4C2gMQc2OsFIHh1Po9QE68hGr12Z5r9MwSjykIU8G9Y1sDRDaCbTzk+3PPJcJJBqGzaB72U20MsHIXkKO/SGvGXJvkGV4G71fYTk6ywkMOWsvwad862y7inOBnEHfaQIcw88TzG9mmcO5Nf/UcNPf65ZxqOynXkoU8HWA0SPzDnH3i5fNjgqZNAwt6xbKcVeaeG2qPr5RB27YD2+3d/229MXYMAPoeQa/3vJck/BwHJjCFv91WvBfzW1hyy7vHiC1jtuzH4t3c5qXCXpvRixQS+SaEQ+jOPg9JJvZoDcF31ixwuXrclGJO12YuYMR873znLQJNd3MMuerwn6EOqdUfRLfAYQPllcVev48/YhGIwYNx4PSWenIk1mleaQC/AwrTMJ5PmtzAsPJYv82agjVaOh5pvsjIagC75KTHEOAwcmsA9J8Sn5StI/cOXctOQTEpCVX+xaDdD5NrUXWPqTFq6jmNDIU820In1fmLX+TzyVYFPvw3/Shm0nq1rVzqmUFd18ftT9TdArclBE58u0Q8+EYLzehQh9MvKbR/Y0TpNF0ULWr9pfhmcEE+qa00mP78ey0w6yNsfQK1cBhUYm1FqKL92s3LiUVT8V8ix53W6ophc66XAG+ahyUysSAlMDTutEn2ZXrDcV4K2ML+q3eBlnwhc3/8RLXWbmdvMKULF/a6oFSCt5cFFsK/ZOHRfwmuGeoHr7ekTH8uI8onJxyrVrREa5cDiniRGFETQwasupraHCLzKR8oU0i1qM553g9lv+E1fMz75MXYYVVsdi201i9yDPLUaxerIhj9D9+a
 KZWTsDlH
 3Nz5uTGACltqK8XlX1inZXqlFP/b3sdB0rE8/HfUaedzHrHm9Z5zM+RT/CWwJz+X19/60aiSTclKOdvOXJWUWA5ul2rKp7ol7JQL79OOjEVd8a0jY4ez8m7ZUWLQm8KvpgbBAzK8cNlC4VuKkoEz+YT2rqivExCIKSIpCYrhGrhCDt17tEVBzQhCrm20c1+Eywp+Aj8Vn93VfQ4qtxzCw5930ycL4UKl6GvuEkOnCcUtdMASSmHxLKtWSBPJgGQYLp8wtCVkxRoeZORA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/4/27 23:35, Zi Yan 写道:
> On 19 Apr 2026, at 11:55, Zhen Ni wrote:
> 
>> Add data structure for page_owner filtering functionality and create
>> debugfs directory for filter controls.
>>
>> This adds:
>> - enum page_owner_print_mode with values for full_stack and stack_handle
>> - struct page_owner_filter with print_mode and nid_mask fields
>> - Static owner_filter instance initialized with default values
>> - page_owner_filter debugfs directory
>>
>> The filter infrastructure will be used to add print_mode and NUMA node
>> filtering capabilities in subsequent commits.
>>
>> Link: https://lore.kernel.org/linux-mm/20260417154638.22370-2-zhen.ni@easystack.cn/
>> Suggested-by: Zi Yan <ziy@nvidia.com>
>> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
>> ---
>>
>> Changes in v2:
>> - Use enum page_owner_print_mode instead of bool 'compact' for better clarity
>> - Use nodemask_t instead of int 'nid' to support multi-node filtering
>> ---
>>   mm/page_owner.c | 20 +++++++++++++++++++-
>>   1 file changed, 19 insertions(+), 1 deletion(-)
> 
> The patch can be folded into Patch 2. Otherwise, these new types are not
> used and page_owner_filter folder is just empty.
> 


Thanks for your review and suggestion.

I kept the 3-patch structure mainly for clear functional separation,
which also makes review easier. Patch 1 adds the infrastructure,
patch 2 adds print_mode filter, and patch 3 adds NUMA filter.

I discussed this with Andrew and he has already accepted the
current 3-patch structure into mm-new for testing. Since he's okay
with it and mentioned that bisection holes are acceptable in this
case, I'll keep the current structure in v3.

>>
>> diff --git a/mm/page_owner.c b/mm/page_owner.c
>> index 8178e0be557f..5884d883837e 100644
>> --- a/mm/page_owner.c
>> +++ b/mm/page_owner.c
>> @@ -54,6 +54,21 @@ struct stack_print_ctx {
>>   	u8 flags;
>>   };
>>
>> +enum page_owner_print_mode {
>> +	PAGE_OWNER_PRINT_FULL_STACK,
>> +	PAGE_OWNER_PRINT_STACK_HANDLE,
>> +};
>> +
>> +struct page_owner_filter {
>> +	enum page_owner_print_mode print_mode;
>> +	nodemask_t nid_mask;
>> +};
>> +
>> +static struct page_owner_filter owner_filter = {
>> +	.print_mode = PAGE_OWNER_PRINT_FULL_STACK,
>> +	.nid_mask = NODE_MASK_NONE,
>> +};
>> +
>>   static bool page_owner_enabled __initdata;
>>   DEFINE_STATIC_KEY_FALSE(page_owner_inited);
>>
>> @@ -973,7 +988,7 @@ DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
>>
>>   static int __init pageowner_init(void)
>>   {
>> -	struct dentry *dir;
>> +	struct dentry *dir, *filter_dir;
>>
>>   	if (!static_branch_unlikely(&page_owner_inited)) {
>>   		pr_info("page_owner is disabled\n");
>> @@ -981,6 +996,9 @@ static int __init pageowner_init(void)
>>   	}
>>
>>   	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_fops);
>> +
>> +	filter_dir = debugfs_create_dir("page_owner_filter", NULL);
>> +
>>   	dir = debugfs_create_dir("page_owner_stacks", NULL);
>>   	debugfs_create_file("show_stacks", 0400, dir,
>>   			    (void *)(STACK_PRINT_FLAG_STACK |
>> -- 
>> 2.20.1
> 
> 
> Best Regards,
> Yan, Zi
> 
> 
Best regards,
Zhen

