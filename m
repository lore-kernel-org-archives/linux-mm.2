Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEAD3606A337
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 00:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=kuOZ6N65
Received: by kanga.kvack.org (Postfix)
	id D4BF66B05B3; Fri, 13 Nov 2026 19:47:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFC7A6B05B7; Fri, 13 Nov 2026 19:47:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC4FE6B05B8; Fri, 13 Nov 2026 19:47:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 93A096B05B3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:47:02 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 08F2A40324
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 00:47:02 +0000 (UTC)
X-FDA: 85431885084.19.D0C0B62
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9A7304000C
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 00:46:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=kuOZ6N65;
	spf=pass (imf04.hostedemail.com: domain of yebin10@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=yebin10@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794617220;
	b=mvQFly9f4gzY4hVzKpDl84s7FKI3FiGPY0C4AwrV44afZiFReD65nepMgN0VwcUHjT1cgh
	5sIxX1a+VJxOLgLa6LuhjCE4DnSZL6ZYsWIT3+iL1czZetwljbCnqFOtcNiGG4bvm8eeYO
	QyLv+Yz8B3eJPjTdgNVXXA7nHi7pQy0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=kuOZ6N65;
	spf=pass (imf04.hostedemail.com: domain of yebin10@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=yebin10@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794617220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CgzgqbRM4PNYm0gqnmQQASlOWblqzL1nTVpc4p2TSDI=;
	b=2/TtIk+yerGcsY/jQSr0/fgv1jz8vTO03dRomYOZTocgBPMAe3aLqK9vluWoxRtyaoV1wv
	70yxvbvgVfrXDWBZoLUtytfMElxQpoQhaNScgELYK0VrYTF9X3j4WpeBFgzfTZ91QyaM/X
	01lRNehDzvobbG+x3fZBWacneX2uJyg=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=CgzgqbRM4PNYm0gqnmQQASlOWblqzL1nTVpc4p2TSDI=;
	b=kuOZ6N65TvoRPWnGK0dRuXKfCJ2y7Q+QcbSv6GZ1+itykpUfBQ+50YTxXP/fglbzTo1hgp4xi
	6RxW31uhG7ZCYEKkzB8xlHVOi+6IVRcEyn3WpA/TQyxILS25SwUe8GAcnIYP82azR4e4QqB5fUL
	IvwHGFBX+PzF8L46Am3T0ck=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4jRFnG405Rz1prKB;
	Sat, 14 Nov 2026 08:46:42 +0800 (CST)
Received: from kwepemk300010.china.huawei.com (unknown [7.202.195.128])
	by mail.maildlp.com (Postfix) with ESMTPS id D8747203AB;
	Sat, 14 Nov 2026 08:46:52 +0800 (CST)
Received: from [10.174.178.185] (10.174.178.185) by
 kwepemk300010.china.huawei.com (7.202.195.128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sat, 14 Nov 2026 08:46:52 +0800
Subject: Re: [PATCH] mm: page_alloc: add nid to mm_page_alloc tracepoint
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Ye Bin
	<yebin@huaweicloud.com>, <harry@kernel.org>, <hao.li@linux.dev>,
	<cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
	<linux-mm@kvack.org>
References: <20261113062007.95040-1-yebin@huaweicloud.com>
 <ab518ee3-ba4e-4c36-afeb-5943a3192ea7@kernel.org>
From: "yebin (H)" <yebin10@huawei.com>
Message-ID: <6AF7AF7B.8030407@huawei.com>
Date: Sat, 14 Nov 2026 08:46:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ab518ee3-ba4e-4c36-afeb-5943a3192ea7@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemk300010.china.huawei.com (7.202.195.128)
X-Stat-Signature: pmmpxu69act4ebo36werwz5a6tn5djtj
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9A7304000C
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794617218-777498
X-HE-Meta: U2FsdGVkX19bTuI/PpVPKSCXv0M7P34WXqfk7k/UUiq/FGZLDoxIolTCOZuhYsAZk580VsdvsIgssfkOIsqy1IuP3V6hlBXJUMSoB7SJlR3NWj9aW6NTg9ig5m5/RZAXiW6LTZB9O+WI+lTf4HAAUbNxsqI1l091WCqC6rFWDHHxDrJmV0EKcVjRMWVJs/tIVRSJpCbbiZg956h+woGsWh4vVsCi0TmpT+bJiCqIGTvhJoZOCllO2F8ubQSwdqcoeluua5rFFH0m/nguBJW568r4ly/Y17n9ktREQXaCee2rN82op5UhiBzFEh00ZU6r1fk2s2kRJpUrpgVKmuVBOSpH0/93s+x+Y0P/2qDkp1tWyS5kaXZBvZNBRQiGSDvim9SzflQpDZLWRc9XAkXD/kGbwRCo8aR3z6khGUZOFvgWCEBdHmmCXJ2xGxPKw3QmcUYxiN25+3PT5914nJMtS4dWyfL52QsZFLmZbHQQN5TgykvGaZFpTxVJhM9HobDjIkUyST8oxRtEPuSxPt+giemvavOB5afiiOW8RJhNJw0t9aq8YdI/kZku6Z+dBKxoMz9bPmkQynDIvG4JyDGrstA0sAA9nfBn8SjASCXMqXQQdaQhfZ7O36je3gDWxyHPZPVge13O6uoxxl4croeXC6i92f9Cru45qY+xx+pyj77HVnKam3OiOal3osDjErkEcwMrbJ6UyNyFLwzYn3KilTfaSJ9BNNm9idpHQrE3Ys4akPVbOEvonZoFePok1/90bTU/DxXEirwSNYOvk/MTEW++qQ+LAh8EjYlroK3NCY33gauSl/mXVIDSffNWuKGvZ/h3iLS4Tg2gE41gzqmj87xKACZo36uHuNGimTVQLUooFaKZcHTE439KBsI3KzghIUH2iPPHuCmHhkyaiqhc+1nq8mgY5VYKXrgrA+JhZ2ekVEZPiHiqG0usBOqZ1xcsUSIFr9YM32A+6BJL327
 GF5bU/Zq
 ZpP1y2L8yml4Q5Ji/KyvjSgzGb658N17PgNY9cmKdSyQZj/CDguGTtGuyjqC6rZ0Ow00RTeZ7hU9pGEceq9YTvQ5igcc0sqZ+dLVq01yvfdMGfauL/1p/EhIhhom4TfCqAM2noEMNKdBzPhwNFpgnGKQ3IYoPOCQKipu08Pk0fHHD2iCbFoNhBqc2hExA1JcDmlCQWngzihK5jAzCjjlL5AmtIs+jRZJgeJ6Bc545X6abSPyid30Grg4AktbmKfQjvujR13t4RoFCCY199HqkPgNhEOSjtvRBbzEci8eCxvlIgu6fykDw6pT8YwpWycXgfzIq7vkwbFolUs/Yo5vsWmpDpw2cmA5u7ofU7ZiGkNjilpvLD+4H5ji+hoyIHddhaq5nrUlCGRhjh2LFlSrogvKV9qBxE3AMcygC5i/YwRxY/S4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/11/13 16:48, Vlastimil Babka (SUSE) wrote:
> On 11/13/26 07:20, Ye Bin wrote:
>> From: Ye Bin <yebin10@huawei.com>
>>
>> Add the NUMA node id to the mm_page_alloc trace event so that page
>> allocations can be attributed to a specific node directly from the
>> trace, without having to look up the pfn separately.
>
> But is it the right tradeoff? Trace data should be as minimal as possible
> for cpu and memory purposes. Anything extra that can be achieved by
> postprocessing is better done that way. Matching pfn to node using
> /proc/zoneinfo is simple.
>
Hi,

I agree with the general principle that trace data should be kept minimal
and that anything computable in post-processing is better done there. But
I think the "matching pfn to node via /proc/zoneinfo is simple" part
underestimates the actual work involved, and for this particular event
the tradeoff is not as clear as it looks.Although AI can be used to analyze
data now, not all data in every scenario can be exported for post-processing
analysis. Online debugging requires speed.
Trace is a debugging facility to begin with. Enabling it already has a
performance cost by design; that's accepted when you turn it on. Adding one
int to an event that already carries pfn, order, migratetype and gfp_flags
is a marginal increase relative to that, while the benefit — direct,
unambiguous node attribution — is immediate.
So while the extra field does cost some ring buffer space and a small amount
of work in TP_fast_assign(), I think adding nid here is the more practical
tradeoff.

>> The nid is derived from the allocated page, or set to -1 when no page
>> is available (e.g. failed allocations).
>>
>> Signed-off-by: Ye Bin <yebin10@huawei.com>
>> ---
>>   include/trace/events/kmem.h | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
>> index cd7920c81f85..8bf4e992d8bb 100644
>> --- a/include/trace/events/kmem.h
>> +++ b/include/trace/events/kmem.h
>> @@ -189,6 +189,7 @@ TRACE_EVENT(mm_page_alloc,
>>   		__field(	unsigned int,	order		)
>>   		__field(	unsigned long,	gfp_flags	)
>>   		__field(	int,		migratetype	)
>> +		__field(	int,		nid		)
>>   	),
>>
>>   	TP_fast_assign(
>> @@ -196,13 +197,15 @@ TRACE_EVENT(mm_page_alloc,
>>   		__entry->order		= order;
>>   		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
>>   		__entry->migratetype	= migratetype;
>> +		__entry->nid		= page ? page_to_nid(page) : -1;
>>   	),
>>
>> -	TP_printk("page=%p pfn=0x%lx order=%d migratetype=%d gfp_flags=%s",
>> +	TP_printk("page=%p pfn=0x%lx order=%d migratetype=%d nid=%d gfp_flags=%s",
>>   		__entry->pfn != -1UL ? pfn_to_page(__entry->pfn) : NULL,
>>   		__entry->pfn != -1UL ? __entry->pfn : 0,
>>   		__entry->order,
>>   		__entry->migratetype,
>> +		__entry->nid,
>>   		show_gfp_flags(__entry->gfp_flags))
>>   );
>>
>
>
> .
>

