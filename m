Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AB5FC624D4
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 00:41:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FF3E6B0088; Thu,  3 Sep 2026 20:41:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B0116B008A; Thu,  3 Sep 2026 20:41:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EE2C6B008C; Thu,  3 Sep 2026 20:41:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E462D6B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 20:41:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 68EA140683
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 00:41:38 +0000 (UTC)
X-FDA: 85174226676.14.7794981
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf08.hostedemail.com (Postfix) with ESMTP id 10C9616000E
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 00:41:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ICElzZeO;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788482496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3YK94SrrP/vItYLu0yuChfSeE7HGX/g9ss7iDjP+W/0=;
	b=hnJEgDyJiQUc7Nnbm+oPO7C7wCj7YKpLgQBz4FIMtCa5RBczTpdzyb9uqaWDiTPA5UqFJ1
	QF7P0kVEOLWRXSwyJ3P41XNejWLsKBY13PLzLcHXpgdrSlTDF7bQvHwjHUFPSzy+z5qMUZ
	HTBwB35ju8568wcFzfdPXZUQGiSa8oY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ICElzZeO;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788482496;
	b=gLh5vSY3Hflt0YD3SOBeqRvyp7gTlQV8Zv1x3UbJjlpexbW0JJoizL5hr3iek3tyuIIdv6
	3yuBYRe2cfTtPkQlC9howIV8SlzE4MgwDKdJ/v3o3MkQl9WvmALS08nXEBnpGZWKlY2Vc0
	wR9znpxLlg44mwDWGmz0US2Qfkt0KaY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3YK94SrrP/vItYLu0yuChfSeE7HGX/g9ss7iDjP+W/0=;
	b=ICElzZeOv+DVZa16XDC103N2kHZ60MA3ETG79mvIQYQqCeUK0/6slyujbQnm37mvwhbaQKUz0
	Z0w5bGkxGfDmetQGKazZ6Icwv4W8F3G/VQGnivrCSa+YU0kGj8vMf7+o1zWQzUQAaJEolgMJ9vh
	kss0kI5ab3y7zhIO1l0/Z9M=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hbcnX2nLjzRhWS;
	Fri,  4 Sep 2026 08:30:40 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 3EF1240579;
	Fri,  4 Sep 2026 08:41:29 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 kwepemk300003.china.huawei.com (7.202.195.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 4 Sep 2026 08:41:27 +0800
Message-ID: <62729d59-198d-4ed2-b1e1-b18384e73b98@huawei.com>
Date: Fri, 4 Sep 2026 08:41:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: fix NOFS state corruption in btree split worker
To: Brian Foster <bfoster@redhat.com>
CC: <brauner@kernel.org>, <djwong@kernel.org>, <cem@kernel.org>,
	<akpm@linux-foundation.org>, <vbabka@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>,
	<ziy@nvidia.com>, <david@kernel.org>, <qi.zheng@linux.dev>,
	<shakeel.butt@linux.dev>, <ljs@kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260902134417.c44503a1d65533f81fb1c391@linux-foundation.org>
 <20260903133756.2006032-1-wangkefeng.wang@huawei.com>
 <apl7hNnt0lR5HFXA@bfoster>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <apl7hNnt0lR5HFXA@bfoster>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Stat-Signature: 6fdnduh4tcbz88xr54ahpes33i8tad4p
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 10C9616000E
X-Rspam-User: 
X-HE-Tag: 1788482494-403583
X-HE-Meta: U2FsdGVkX1/ky/nF85V5tvqoXgnAW53Rv+36gAdaJrO3xTDcCA14XvI+uexQ1nBscq/UdMZr3Ua9VdVsKwkL3vHeGouTFlRCG00SWLye2NAv+XYH1eoVM84eUuieYg69oqxBSVHzOCgOtWyVqZEIdxZ1+8GoKtUYUa5/3IZs0AmL5x1Nruy6At/xvWfAKyrcMd744qnomw7BVwH2Qu3lE2D1NLMlCiHM7Y0QlXPox4l7E03FUkTGru/J17LEQZP9tzLRWG2CUGPsOF7KZi52J1K+Y18zXHIntCC8/KpjK2GfZdOji/DmPbF9Kq5V9H4/Q85tb/8VR04v36ffA4hAuRyulr4ns+24wmGf3Dq7fSlPuw75aTuxTKZlA9nFcwMfqR7D9fHcb1T8enMFZVuYPA8/lcjpqdsoD6jq0RwwMoM6xYn5Qejv/d8xxPMLLi7iqLEwptGdqXhggRxuFFKqCsKIdLpQUO5jN0Xg4wUMheDmZ10Z6C9dzJAbOz2vwI5V9qXUvafUpheFLIo1tYJEWVv88+eqRWA4dqN/hw/XqVlRuNc628038kb2+eMULSEqm1EnwqNdNIkGf8OxL0jmzUO1EpaDB9T6koC5vax0ld1pjuPx1vjSFK6v/FV1MVeBeYGJmCWth6wfFNhnmwPCIV3MbX8uNF86BZCrMpyzxmHDPjtcAqd7RkUoyn06gAH1DVL7Tf2vk1CQsFmhHAQbG0OyX9kIrWFRx3L8CP6coz4tAnJaaA62LeAt5nrzzUSGCN1rtWBpF22DaecN/3ruf33Xv8tUtEl29etB1LdTi9mrOcqRAf0jLjqtnrgZ4cNuv/8TabSJr7j6/SATfZUuukzo/geQe8ESnSxtfqGzntzJOrksTJVf+1BQ1SUpVPljOLD3Ufndk6PNwKSrrQA+8a/QZTI9/I0KqCOecyJ8Jkaog4JHvOpCUwdWUbCl+LJR6ixGnDzU3T6HdMlfwDK
 AYskCkNQ
 iOqUMqcvXG4uUG/ArOcZ+fmVIhjQXRWKExWmQl7S9DBep5gweHfJK1oaq0uffTqXZe2bVRMavamD/63qTWY225Dd+FjSBKXHOBEJT9sI9GZggCHnaEQl81T9i98yVHBvnQE1XHGliIHLA+wSu7EhDFYB6y4qhpiwP6btRav3AlrvYegqe3d4nFwvlGFQMJ+u+lSRhwUfXKIrXzmwx63w+uzbIsIVcDGFmrK7iw36oZsYUjA1dUCxPdMz+qyu5AxyDgczFX7YZVUfg92P/a+x5c2c28bmiDsXImrQfwPx9SZFGbeFHSIOynVLnBiTf8rloR+eN42AGC008zBTAlJPsILHHXsKSS/idC2i2U8Z3IpPZkVRCEUjfOsVHGs4wfsB2O12PYoLh8yW3lTtT5bkX4ke2lQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/3/2026 9:52 PM, Brian Foster wrote:
> On Thu, Sep 03, 2026 at 09:37:56PM +0800, Kefeng Wang wrote:
>> xfs_btree_split_worker() calls xfs_trans_set_context() and
>> xfs_trans_clear_context() on the caller's transaction, overwriting
>> tp->t_pflags with the worker's NOFS state. When the caller already has
>> PF_MEMALLOC_NOFS set (e.g. xfs_end_ioend_write, xfs_dio_write_end_io),
>> the corrupted tp->t_pflags causes xfs_trans_free() to erroneously clear
>> the caller's NOFS protection.
>>
>> Use memalloc_nofs_save/restore with a local variable instead so
>> tp->t_pflags is never touched.
>>
>> Closes: https://sashiko.dev/#/patchset/20260902131653.1338227-1-wangkefeng.wang@huawei.com
>> Fixes: 756b1c343333 ("xfs: use current->journal_info for detecting transaction recursion")
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
> 
> I agree that the Sashiko analysis looks correct. The only thing I wonder
> is whether it might be a bit cleaner to have the set_context() helper
> return the context instead of hardcode the assignment to ->t_pflags so
> it can be used in both places. The reasoning is just that the current
> arrangement kind of makes it easy to repeat this mistake in the future.
> 
> Then again, it's a single line helper so maybe another option could be
> to just remove and open code it. I suppose the pro of keeping the helper
> is that it's a decent spot to document the concern and why it returns a
> value, etc. *shrug* Thoughts?


I personally tend to remove the helper functions, but let's see what 
others think.

> 
> (Please don't change this patch just on my comments alone. Let's see if
> others have input first..).
> 
> Brian
> 
>>   fs/xfs/libxfs/xfs_btree.c | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
>> index 6738d9d1511b..8ae4b94e6995 100644
>> --- a/fs/xfs/libxfs/xfs_btree.c
>> +++ b/fs/xfs/libxfs/xfs_btree.c
>> @@ -3007,12 +3007,18 @@ xfs_btree_split_worker(
>>   {
>>   	struct xfs_btree_split_args	*args = container_of(work,
>>   						struct xfs_btree_split_args, work);
>> -	xfs_trans_set_context(args->cur->bc_tp);
>> +	unsigned int			nofs_flags;
>> +
>> +	/*
>> +	 * Don't use xfs_trans_set_context() here: it would overwrite the
>> +	 * caller's saved NOFS state in tp->t_pflags.  Use a local scope.
>> +	 */
>> +	nofs_flags = memalloc_nofs_save();
>>   
>>   	args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
>>   					 args->key, args->curp, args->stat);
>>   
>> -	xfs_trans_clear_context(args->cur->bc_tp);
>> +	memalloc_nofs_restore(nofs_flags);
>>   
>>   	/*
>>   	 * Do not access args after complete() has run here. We don't own args
>> -- 
>> 2.55.0
>>
>>
> 
> 


