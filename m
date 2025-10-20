Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A22CDCCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 15:32:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E74B8E0026; Mon, 20 Oct 2025 11:32:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BFB58E0002; Mon, 20 Oct 2025 11:32:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3E3D8E0026; Mon, 20 Oct 2025 11:32:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E52F08E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:32:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 64AB4139A25
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:32:57 +0000 (UTC)
X-FDA: 84018885594.14.31760C5
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6CF2580010
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:32:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h04n5cTz;
	spf=pass (imf30.hostedemail.com: domain of leon.hwang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760974375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WBRDLpDd/ovgwGQlK3jYx7rs+f8otlMFk8pGLq4TlNo=;
	b=RcjPrns2vtrAEASQwMebb96JBk4N7O9r5n+yIB65VEN/rfO8kgNb+93/zrSSS6yPh/+7ak
	K8yGYbj1ttEKYGn/cLHLM3Zkg6kj67RLBR/JkV2GhhTJszHYH/QKMH8zg3OjUTnbDIajYH
	4ACkzeiUk1H1whctqJK9ABLpFpB41f8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h04n5cTz;
	spf=pass (imf30.hostedemail.com: domain of leon.hwang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760974375; a=rsa-sha256;
	cv=none;
	b=uQovbbN0ckyLXj6lO35jejeewuYRGg4m+0hlsHwfZgLev7ODP2hmC7zwLpynjRYxlfSKtL
	fsMKTpp5HivN6012ctY/ISSG7pgAkQe9h8DSTLDuNKQk1WKPcxnP+FYsWeH14CKUkbusSs
	vD6VzZOqq/ESVda3TPXg38VUI8izhoM=
Message-ID: <1a207072-8623-40ef-bf3c-0edc1c6304ea@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760974373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WBRDLpDd/ovgwGQlK3jYx7rs+f8otlMFk8pGLq4TlNo=;
	b=h04n5cTzSMkmrsYA4+eYbtS7m52Z4LUP0T1WtaJnEk7mDMUT/N2V+M6rp/W3CcqDnmAbDa
	lYX5FI5fSi7ZM2MvDN5Gex4O3StnKa94PXNXoqZIZFcBdZ7eYcAq94rFOyFaGr75HWU9Q/
	wNwB0mqfe0s5O8xIfLaYmsLt0mIFn8o=
Date: Mon, 20 Oct 2025 23:32:17 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new 1/1] mm/khugepaged: Factor out common logic in
 [scan,alloc]_sleep_millisecs_store()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251020115350.8175-1-leon.hwang@linux.dev>
 <7d9b4ac6-b0c2-4a0e-bee1-23f7a82eea72@lucifer.local>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Leon Hwang <leon.hwang@linux.dev>
In-Reply-To: <7d9b4ac6-b0c2-4a0e-bee1-23f7a82eea72@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 4744f4qirngepap8keztnke6nmaxx7xg
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6CF2580010
X-HE-Tag: 1760974375-655724
X-HE-Meta: U2FsdGVkX18FvZUvbBSvEw//wQpeuXEGQO8kawNhCfx5Mv6Hu4/c40N4lBwGUdbDtiqmnoThFQk09yVc0DZsxhaCdXv4B8Xu+K/tmFjBxXeEpUfNrAHkYrJsiP7JsoGLvVfIY47iW8dD1kcwns/YbTADuNHBAhsP3duI4neYqAxWSvBtmknq/TurWtuMKwPY/qTotDK8IcsdUSrNdeMnc2S99VgA/4h+B8a2zqKkAcb2S3KM0fQxIfqFiLwGBsNWasMBJwoc1cZIhXE5d/KmjAkCY+lzzuEBxDgJUoH8v2MKX6aQdDbGhKjBi829vikM6RJswLbvFf/YAV7lsgBY5FEnySbNWFKdYzLxC4aDxGl67m3OoOtK6N2/42VaB6ag6BdG9JE5MLbfjMRavyKa4eQweue6G5OV+nZokAtaIdRvfF46faACpdElVPvT2A7500ZfRlCPjWVnGEBIM/PoC6v3PYIuSw14sE87rOS9yaB6Lc9FgGwJGFl138PCffpJr1tfXB2XztGYcAswxdx+d5+GRup46MfxUFNOwmQUeGfmiqphUzXmJj2Q5VDYkfvJzV6ODIx4x/kiXIqzsExRnyxyuF6++DA3+3nB0gcgIjonocS7u/wS9mnfK0bVesee8nfZjpAjDawb9BM7FMbN6p2a20oU6veMmssJnA5rap1cKuOM1QA6o5l+zykPgYgMxWp+OdFEKb2qAeSFWqzglCgOaOF+p11oko+wYeOgqWUzneNqStOztrWmSwOaeEEA1sIaEBliV/yHHuvNN1rluNgZSutXh+h0BPBK4o2PSzBM6kelAyoJvQt9itnfv93vXAqb/dltBfVVu94oRHeKqHHd0bFAVAESdIVMVU+Vra/KxDo7P7FVbrO1FmOrRD7sgiXraJO7PfYhYKpgx2Mi3LI8wtsVICWXPGN4+47s8tLRM2UN0U91c+Ei96d0j8dNitwAR/bzsSXYy1j0M2x
 KEjpI80Z
 ku+2Tdr8IginzSXM3ARH2S35XVany95f/SJN92CuOrZwXeK7fo5iFFd7PGeFaARXRBCUl8nl/f0SsUa6fD99TAWUNzMjdZ2pWuuM3KKzcbgTX1mYbERKhFAo/+EP5tbaeRR9jE8Gv8OuDQQ9WXv2e+0OdM8FE3HZJsO776TtxWrGfLSZKLkAsL4ejiunSZz3N7kQB6Rx5qKTPYh2rILwZ11m4Lus1yYvpUokhweRgrA0R6CCaU103o61JQsXjLSqbavJmXp4pOV96SUi3zZ69Ht7wGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/20 21:53, Lorenzo Stoakes wrote:
> On Mon, Oct 20, 2025 at 07:53:50PM +0800, Leon Hwang wrote:
>> Both scan_sleep_millisecs_store() and alloc_sleep_millisecs_store()
>> perform the same operations: parse the input value, update their
>> respective sleep interval, reset khugepaged_sleep_expire, and wake up
>> the khugepaged thread.
>>
>> Factor out this duplicated logic into a helper function
>> __sleep_millisecs_store(), and simplify both store functions.
>>
>> No functional change intended.
>>
>> Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
> 
> Thanks this is a decent cleanup, with the nit(s0 below addressed LGTM, so:
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 

Thanks for the review, Lorenzo.

>> ---
>>  mm/khugepaged.c | 29 ++++++++++++++---------------
>>  1 file changed, 14 insertions(+), 15 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 0341c3d13e9e..0b7915015e9e 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -129,9 +129,8 @@ static ssize_t scan_sleep_millisecs_show(struct kobject *kobj,
>>  	return sysfs_emit(buf, "%u\n", khugepaged_scan_sleep_millisecs);
>>  }
>>
>> -static ssize_t scan_sleep_millisecs_store(struct kobject *kobj,
>> -					  struct kobj_attribute *attr,
>> -					  const char *buf, size_t count)
>> +static ssize_t __sleep_millisecs_store(const char *buf, size_t count,
>> +				       unsigned int *millisecs)
>>  {
>>  	unsigned int msecs;
>>  	int err;
>> @@ -140,12 +139,21 @@ static ssize_t scan_sleep_millisecs_store(struct kobject *kobj,
>>  	if (err)
>>  		return -EINVAL;
>>
>> -	khugepaged_scan_sleep_millisecs = msecs;
>> +	*millisecs = msecs;
>>  	khugepaged_sleep_expire = 0;
>>  	wake_up_interruptible(&khugepaged_wait);
>>
>>  	return count;
>>  }
>> +
>> +static ssize_t scan_sleep_millisecs_store(struct kobject *kobj,
>> +					  struct kobj_attribute *attr,
>> +					  const char *buf, size_t count)
>> +{
>> +	unsigned int *millisecs = &khugepaged_scan_sleep_millisecs;
>> +
>> +	return __sleep_millisecs_store(buf, count, millisecs);
> 
> I think this'd be much clearer as:
> > return __sleep_millisecs_store(buf, count,
&khugepaged_alloc_scan_millisecs);
> 
>> +}
>>  static struct kobj_attribute scan_sleep_millisecs_attr =
>>  	__ATTR_RW(scan_sleep_millisecs);
>>
>> @@ -160,18 +168,9 @@ static ssize_t alloc_sleep_millisecs_store(struct kobject *kobj,
>>  					   struct kobj_attribute *attr,
>>  					   const char *buf, size_t count)
>>  {
>> -	unsigned int msecs;
>> -	int err;
>> -
>> -	err = kstrtouint(buf, 10, &msecs);
>> -	if (err)
>> -		return -EINVAL;
>> +	unsigned int *millisecs = &khugepaged_alloc_sleep_millisecs;
>>
>> -	khugepaged_alloc_sleep_millisecs = msecs;
>> -	khugepaged_sleep_expire = 0;
>> -	wake_up_interruptible(&khugepaged_wait);
>> -
>> -	return count;
>> +	return __sleep_millisecs_store(buf, count, millisecs);
>>  }
> 
> I think this'd be much clearer as:
> 
> return __sleep_millisecs_store(buf, count, &khugepaged_alloc_sleep_millisecs);
> 

Indeed, your suggestion makes the code clearer.

I'll update both occurrences in the next revision.

Thanks,
Leon

>>  static struct kobj_attribute alloc_sleep_millisecs_attr =
>>  	__ATTR_RW(alloc_sleep_millisecs);
>> --
>> 2.51.0
>>


