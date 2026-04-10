Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0212BE99049
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 07:17:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B7CB6B0005; Fri, 10 Apr 2026 03:17:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 269026B0089; Fri, 10 Apr 2026 03:17:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17ED86B008A; Fri, 10 Apr 2026 03:17:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 083EA6B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 03:17:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9CF9DC1AF8
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 07:17:51 +0000 (UTC)
X-FDA: 84641791542.24.B623173
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1A1DC40003
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 07:17:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="E1VJ/tmS";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775805469; a=rsa-sha256;
	cv=none;
	b=g33oEdVCTvDDoD+u05AUkf4G+k5XhXqMmFRwaKBN+DfBZ/FjuqcgAZBqfgxVuhgWRNmXdH
	qBFZfeBUHFa7ipXm90uE86P55KovntGDBhj35khm5AdK+9YPTrK4ouAsbBIPcr7+XsHTrM
	hjjlj9ZrTwD1NfYKha5WPk7l0PFmHdI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="E1VJ/tmS";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775805469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fWKfH5LNOJyUga0sR6g+VdsEMxO3kMazl+w2D/Y3Rqk=;
	b=dkPx8a8tGYHVnDzVDRd/I4W8hno6CUFs2NvjecLigEksOlXvRo5/NdvbRcnKsDc/J9J2D3
	fl6fZ/mRVhtdMLNfW3X56ww7Dd6HvdO+yiiSGGYG4kEz//HXNfTbhOVURlgONHA0dkyjjo
	R4WYJTNmvw8uoY+RtiDhNWRt5mHfdI4=
Message-ID: <ce4ecefa-976c-458d-8e57-361b10d297a8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775805464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fWKfH5LNOJyUga0sR6g+VdsEMxO3kMazl+w2D/Y3Rqk=;
	b=E1VJ/tmSviqsUJtDxGPUfKi0RzYBX1JFt/7M57jV48fftEn31ROpg2k6hQ66n5T6br4DtQ
	ciWa+ZN5SikxIisQX93J1p5NLbkwL6xrQiATxs44kUQMnIc/+dk1JMER7r94EgjIC6hwzu
	AqmLjU4FyFEs5b+cKh5KRvMDemGRVLs=
Date: Fri, 10 Apr 2026 15:17:18 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] mm/memory-failure: use bool for forcekill state
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: Ye Liu <liuye@kylinos.cn>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>
References: <20260407020715.2269255-1-ye.liu@linux.dev>
 <20260407020715.2269255-3-ye.liu@linux.dev>
 <9d022499-2a77-f8c6-b86d-d9de838fac32@huawei.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <9d022499-2a77-f8c6-b86d-d9de838fac32@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ck349tf5kajwd1spuk9ex86dt19uo7j5
X-Rspamd-Queue-Id: 1A1DC40003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775805467-348065
X-HE-Meta: U2FsdGVkX18sg6pd+u5bOahEe2EM28udCVUEdWv4YGN9ndUijfrIOzMbdGYGAlzpGvsFGlwAjjcRrHI7tELNKqx2yP7sa+BXaFceg51zq6WSGDA/GB2Nj3uioX67AgvwzIlzmBJof/XYrwftTvv887LT8RRxLVNp3kt+Rv9z3dJLkgjqXfiuGNb5Dz5kOJTVzYzun+lulO9mc6fZsjHCkHHZPGMet0XQIz2W4NhHWqSl4HCZo5honsEj1V8bL4qTo1fSmkOt5dW2zw2xdy3QCYncrIO5atKGaILfDNhyfm22Q66WSl0KToRI7PKzLZ8/4bhrSn4xG3wdeuOhnMDiaBTQkRgcDXYoITwERTdcCzQ5FedJDZ6DF2hB6Af6nHPwcD2xTDtinxYKERNgpogIz6hgPEamcDQR3AX+y8HyGwX0zzIwOf3oPYyjoa/LC8LkbrxSyVKJsuZ+avI39/1aOpiYWrN9yDdJeWlMZK/H8v9lHU5nY3g/gSS4zW2Zi2SwiHYZexeZTRehSFbjfsN05nUimNiRehPwJi2iv73r/vQD9+MrxAJWYnPTmw+pwQGKdJpn3BscaM+5QTRz0iXpTW8aEKm3wqpP/KLg4be1QdlNJHjx8jFsKL02D9wbIZEdaWl6k+fpg3dEhtDu0KUpVDfXXawK16wZEb/yJcsa1yqCrpgRmCfLT1UOQVRthDKlpUnk/ublfNh5eBd9kZBtHPuyfMnljANX2VZ57+lkErC5w+pNBO1ePym9dp7hP+brdhbRQoLTywhu0KBSHhBKO1vIpwZNthBW3vAff1T8w6qQ74QInilQcFUfdV3iB6HFRs+aU2sVqh0rpaT8XoUeeN3HalEkuwcXfUnjm/cV1m6wTuWqRlwFBhu1THFI23px2TT5cOhBssNndkmiOLfGP1jFECjc7nsY9tSFB1c375Q7pDxkpTYrG3UAk5L6Bb/77Fr4iNTyI1hg/ImYzIs
 gUK4KM9+
 bMRV43IXIetfw0t4FcPhaZZh/JG/7g/5GQshRKOiddhpMhwlhYAeVZAofGrq5QMJlJd1ywhCBkLBRR1IonYkrIYXIlAB/8JcM+lRmPn65Xm7fAaGwo54dwMHbTmkdxuJQEj8knPd2HkKQYaUMEc4nXrAkk1z6GtKkLolTsSBEbXY8Q1EjA/TQPUtCW2UWlG07RJUwyOweMSyHlHJEE9UtTVylRjYLl9eQdNU0217Z9vCCmw6zg0QY9tHmxNByJYbHMK3x3BqlPftEQMEOudOBEfE4e5Rzr+ttGf+BAlujpy4gJnE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/4/10 14:45, Miaohe Lin 写道:
> On 2026/4/7 10:07, Ye Liu wrote:
>> From: Ye Liu <liuye@kylinos.cn>
>>
>> 'forcekill' is used as a boolean flag to control whether
>> processes should be forcibly killed. It is only assigned
>> from boolean expressions and never used in arithmetic or
>> bitmask operations.
>>
>> Convert it from int to bool.
>>
>> No functional change intended.
>>
>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>> ---
>>  mm/memory-failure.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>> index d25adb390c3e..f355642bc2b6 100644
>> --- a/mm/memory-failure.c
>> +++ b/mm/memory-failure.c
>> @@ -459,7 +459,7 @@ void add_to_kill_ksm(struct task_struct *tsk, const struct page *p,
>>   * Only do anything when FORCEKILL is set, otherwise just free the
>>   * list (this is used for clean pages which do not need killing)
>>   */
>> -static void kill_procs(struct list_head *to_kill, int forcekill,
>> +static void kill_procs(struct list_head *to_kill, bool forcekill,
>>  		unsigned long pfn, int flags)
>>  {
>>  	struct to_kill *tk, *next;
>> @@ -1582,7 +1582,7 @@ static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
>>  {
>>  	LIST_HEAD(tokill);
>>  	bool unmap_success;
>> -	int forcekill;
>> +	bool forcekill;
>>  	bool mlocked = folio_test_mlocked(folio);
> 
> There is one caller in unmap_and_kill():
> 	kill_procs(to_kill, flags & MF_MUST_KILL, pfn, flags);
> 
> It seems flags & MF_MUST_KILL does not return bool. So maybe we should change it
> to clear semantic conversion?
> 

Thanks, that's a good point.                                                                   
                                                                                               
While the current call relies on the implicit scalar-to-bool conversion,                       
making it explicit at the call site better reflects the intent of this bool conversion cleanup.
                                                                                               
I'll switch it to `!!(flags & MF_MUST_KILL)` in v2 for clarity.                                
                                                                                               
Appreciate the review.                                                                         

> Thanks.
> .

-- 
Thanks,
Ye Liu


