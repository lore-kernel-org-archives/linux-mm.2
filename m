Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 228F5CA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 09:54:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86D0D8E004B; Wed, 20 Aug 2025 05:54:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 844E08E0003; Wed, 20 Aug 2025 05:54:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 759FF8E004B; Wed, 20 Aug 2025 05:54:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 604088E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:54:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1281AB9877
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:54:42 +0000 (UTC)
X-FDA: 83796676404.03.2653301
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8F6EB40009
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:54:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755683680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ehBlk8Qn9EuFTlLGgEIJq6F671GfcXdZ8P8Go/RVf68=;
	b=Yx4c7zZ2Cs7PybKDQgG6MZbYdX2EBpwspS/0L/+7rs3EDY4Udzxb7sW9JACAq5dcrrn504
	WAHlamBE++SNMSG1gFFqt45RIL0tK8xTyajPUN8D8r3Q9V85uMc3TbgUkfTuZpaNbh43ro
	IyEkkOdu3FsM0n0MvkrC9T4+anSO8CM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755683680; a=rsa-sha256;
	cv=none;
	b=p4EIqw7sd/O7fXsaCg3Yy0DpFNqdlO++bhUGqVyTBjoo/kZBrLnRPvXiv+ZF+A7LzGzery
	DNSbF3YuKvLdY4uXitlYePZraCb5lhZTyvlsaL3euatgvJrxiR1MTFXzpiOnW1TT+OgIDv
	n2BSHvjUfZm6gHQ3PcFd3QR6fLpUggE=
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4c6MBG4XsmzPqXb;
	Wed, 20 Aug 2025 17:49:58 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 8271F14011A;
	Wed, 20 Aug 2025 17:54:34 +0800 (CST)
Received: from [10.174.176.250] (10.174.176.250) by
 dggpemf200018.china.huawei.com (7.185.36.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 20 Aug 2025 17:54:33 +0800
Message-ID: <3b5a37a7-af37-4108-a0c5-bc147bb77842@huawei.com>
Date: Wed, 20 Aug 2025 17:54:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH -next 15/16] mm/damon: the byte statistics data type
 in damos_stat uses unsigned long long
To: SeongJae Park <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
References: <20250813171000.6345-1-sj@kernel.org>
From: Quanmin Yan <yanquanmin1@huawei.com>
In-Reply-To: <20250813171000.6345-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.250]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Stat-Signature: w8ihb37jknwii8qdmur51zd4orsz44fa
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F6EB40009
X-Rspamd-Server: rspam05
X-HE-Tag: 1755683678-135543
X-HE-Meta: U2FsdGVkX1+RM3FKXbYSuF6dyW6Q6VfbO2HoUmjV74w/ZoXkFkM6m/FF4vtOYQzLRC5uioiQ9Ea8mKIs1cOcRmrQa/3C7EpvQym1w2JoTUzL0J0tAS0XkU/AOdSJzwXM8RlDpKRYl4is53r9tyYUJE99GrlrKf9tcmx0S32RGtnaGmrsQMW+4T+PmtCcu8Ku8ZIIrsEQfEUBav0Sxyyr+TpgocaNlHvUO0RB0aexZiyZhx0aFLS8MEmPb7YcyteZhGSovC5ioKtojfKiTJmF52euFEQdOiUTWpgRybCOONY/djpNm1ZLol2ElgR4z3F/uCrQJSZs0LBMOMzG7vYtFygjExFtb1v8lUBWI92AFwgAe3ZAll0Z8FLo4K/h2+1OMaJyWsi7H9pjQWbgDT/axdyAEdjrIsPQiDNsnrg4u+KOGkqeDAPB/D47d1Q861/PqdDOQD95UFF9YW+CueiegIVWz3hw0K6iQN5ETiqxcx6HhLNQJqyh7lIFgYxebSKAGWKyP/Ic0qMqRMk4yNfW+D+l3aT+4YcFEUe5aQL6IA5UUnXoIhMjDvd0+61wS7/vfVe/kWa36eERhUh6GBDYTFhS9fiZd/RIXZPWS3V8aCuGo49G+Q4kfzrp9J5FCexACC0b+NGdyCiWHN+CozK9fvCFuayXUa5nBltFDREFqzkaV37Gsr/XNYtJp6BfNuyfEdzeVQspcZqkSnveQIDHfk4iqx4NFKla+yLK9x6q6HZNaKJJUPILEIDtEk6DYSk2XiQzAHehIFt2Bc5QILs5J4YNQMqTonVdMpGpuIUX36hE7/JecYT1+CiC4Ig492boTo/QaM2TQB+6mMIPEa/pNUmZtQHVTXJK4gva4vgkY0hMRyTdTn1nEfgtUiw+zFcd2Ya4x3Ny4HnJcpNGSD3dFalDZbkoqgks9ia0VImMK6HMXFJR2f2Xw9v1CBcMLgpgifD/3Sd26KDBDe8Sh0A
 E/RqUllC
 Y3N8Hczet7HeFW7bN3kLav3Lb4DuW98jcBrWGmMge51/tpgCPZWfik0JxPm98J5zLtkgU1WgWYZPHbt0I3JRjzDawLf2UuOMhcEdxTCNwr7r1AefQUrO4VfrhbCDh8Vmws6DeRzms8SvtGtoprhB8P516lIyZXOOjDD1ByzN9PkTBcSIvKPD0rge7m6ZRanIQ+9L1w3AyWNiL74agnxuTcuv1sRr8EpazClvErQJGDzL7qEK/v22fV+deWiNdx6stTZgQZM5vGBykfocNaVsl2VNFzjMFpN2Ao0s/W02YOWU8ntLz1pvMAPtEiQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

在 2025/8/14 1:10, SeongJae Park 写道:
> On Wed, 13 Aug 2025 13:07:05 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
>
>> For 32-bit systems, damos_stat now uses unsigned long long for byte
>> statistics data to avoid integer overflow risks inherent in the
>> previous design.
> I suggested using the core-layer address unit on stat, and ask users to
> multiply the addr_unit value to stat values if they want bytes value.  If we
> agree on it, I think this patch wouldn't really be required.

Thank you for the guidance, I agree with your perspective. However, this patch doesn't actually belong in the addr_unit series, my apologies
for the confusion. It is actually intended to address potential overflow issues
in statistical data on 32-bit systems, and it is not directly related to addr_unit.
This patch has been dropped from the v2 series.

After introducing addr_unit, if it is set to a larger value, it can help mitigate
the overflow issue. However, under the default setting of addr_unit=1, statistical
data may still overflow after a sufficiently long runtime, for example, when sz_tried
exceeds 4GB.

Besides, please allow me to mention one point in advance: if addr is extended for
use in modules(e.g. DAMON_RECLAIM, LRU_SORT) in the future, the term "bytes" in
module_param_named(bytes_##try_name...), although multiplied by addr would yield
the actual byte count, might cause confusion due to its seemingly direct naming.

Overall, this patch isn’t critically important at the moment, nor does it offer a
sufficiently robust solution, but I’d still appreciate hearing your perspective on
the matter — I’m all ears.

Thanks,
Quanmin Yan

>> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
>> ---
>>   include/linux/damon.h     |  6 +++---
>>   mm/damon/modules-common.h |  4 ++--
>>   mm/damon/sysfs-schemes.c  | 12 ++++++------
>>   3 files changed, 11 insertions(+), 11 deletions(-)
>>
>> diff --git a/include/linux/damon.h b/include/linux/damon.h
>> index aa045dcb5b5d..d85850cf06c5 100644
>> --- a/include/linux/damon.h
>> +++ b/include/linux/damon.h
>> @@ -333,10 +333,10 @@ struct damos_watermarks {
>>    */
>>   struct damos_stat {
>>   	unsigned long nr_tried;
>> -	unsigned long sz_tried;
>> +	unsigned long long sz_tried;
>>   	unsigned long nr_applied;
>> -	unsigned long sz_applied;
>> -	unsigned long sz_ops_filter_passed;
>> +	unsigned long long sz_applied;
>> +	unsigned long long sz_ops_filter_passed;
>>   	unsigned long qt_exceeds;
>>   };
>>   
>> diff --git a/mm/damon/modules-common.h b/mm/damon/modules-common.h
>> index c7048a449321..ae45d0eb960e 100644
>> --- a/mm/damon/modules-common.h
>> +++ b/mm/damon/modules-common.h
>> @@ -36,11 +36,11 @@
>>   #define DEFINE_DAMON_MODULES_DAMOS_STATS_PARAMS(stat, try_name,		\
>>   		succ_name, qt_exceed_name)				\
>>   	module_param_named(nr_##try_name, stat.nr_tried, ulong, 0400);	\
>> -	module_param_named(bytes_##try_name, stat.sz_tried, ulong,	\
>> +	module_param_named(bytes_##try_name, stat.sz_tried, ullong,	\
>>   			0400);						\
>>   	module_param_named(nr_##succ_name, stat.nr_applied, ulong,	\
>>   			0400);						\
>> -	module_param_named(bytes_##succ_name, stat.sz_applied, ulong,	\
>> +	module_param_named(bytes_##succ_name, stat.sz_applied, ullong,	\
>>   			0400);						\
>>   	module_param_named(nr_##qt_exceed_name, stat.qt_exceeds, ulong,	\
>>   			0400);
>> diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
>> index 74056bcd6a2c..3c4882549a28 100644
>> --- a/mm/damon/sysfs-schemes.c
>> +++ b/mm/damon/sysfs-schemes.c
>> @@ -199,10 +199,10 @@ static const struct kobj_type damon_sysfs_scheme_regions_ktype = {
>>   struct damon_sysfs_stats {
>>   	struct kobject kobj;
>>   	unsigned long nr_tried;
>> -	unsigned long sz_tried;
>> +	unsigned long long sz_tried;
>>   	unsigned long nr_applied;
>> -	unsigned long sz_applied;
>> -	unsigned long sz_ops_filter_passed;
>> +	unsigned long long sz_applied;
>> +	unsigned long long sz_ops_filter_passed;
>>   	unsigned long qt_exceeds;
>>   };
>>   
>> @@ -226,7 +226,7 @@ static ssize_t sz_tried_show(struct kobject *kobj, struct kobj_attribute *attr,
>>   	struct damon_sysfs_stats *stats = container_of(kobj,
>>   			struct damon_sysfs_stats, kobj);
>>   
>> -	return sysfs_emit(buf, "%lu\n", stats->sz_tried);
>> +	return sysfs_emit(buf, "%llu\n", stats->sz_tried);
>>   }
>>   
>>   static ssize_t nr_applied_show(struct kobject *kobj,
>> @@ -244,7 +244,7 @@ static ssize_t sz_applied_show(struct kobject *kobj,
>>   	struct damon_sysfs_stats *stats = container_of(kobj,
>>   			struct damon_sysfs_stats, kobj);
>>   
>> -	return sysfs_emit(buf, "%lu\n", stats->sz_applied);
>> +	return sysfs_emit(buf, "%llu\n", stats->sz_applied);
>>   }
>>   
>>   static ssize_t sz_ops_filter_passed_show(struct kobject *kobj,
>> @@ -253,7 +253,7 @@ static ssize_t sz_ops_filter_passed_show(struct kobject *kobj,
>>   	struct damon_sysfs_stats *stats = container_of(kobj,
>>   			struct damon_sysfs_stats, kobj);
>>   
>> -	return sysfs_emit(buf, "%lu\n", stats->sz_ops_filter_passed);
>> +	return sysfs_emit(buf, "%llu\n", stats->sz_ops_filter_passed);
>>   }
>>   
>>   static ssize_t qt_exceeds_show(struct kobject *kobj,
>> -- 
>> 2.34.1

