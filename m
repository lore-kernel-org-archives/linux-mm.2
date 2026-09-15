Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A8E2C88E72
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 02:26:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FCCD6B008C; Mon, 14 Sep 2026 22:26:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D5496B0093; Mon, 14 Sep 2026 22:26:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EC316B0095; Mon, 14 Sep 2026 22:26:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F52A6B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:26:57 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 99BF1402F5
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:26:56 +0000 (UTC)
X-FDA: 85214408832.19.22E9990
Received: from mta0.migadu.com (out-196.mta0.migadu.com [91.218.175.196])
	by imf02.hostedemail.com (Postfix) with ESMTP id 98FF280002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:26:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IDOPJAkx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.196 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IDOPJAkx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.196 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789439214;
	b=0EGfzP7ygE0JxFqFe4EtaJ0riqS6cvSdEcE/DQFbHxSNh+zvGKB9sq4W8GidB6THOU7zDE
	Pzgn7OfEiY7ZNg1rBDNpr59/BKDnJTuLtuJCbmMTyVOt0d5jiB7SY5OZnyPjVZiOAao/m+
	8RnVdX/f9ffDVJJqyhF2XA1pS22b3+0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789439214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ltfUfqHTxeh1EoiHT5yJn23kYx574y80AuIZmC4tMeM=;
	b=c4AO/B6wLMoPPYLrV/p/i2/1f6E8pqGv7P4AlbEMSBfb8RGqGeR8zkP3oIvvztYZrOW3AL
	k3SlyUVhUH18zWNd1ec4IBWXfzCY/FXk/EADZNcjiDZCCKMIrr2FhKsv51ujxn18CV5awF
	W8fBeNtuBdoxSupUQBCc59/YqqlfBqE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=WFAadgQLRx9VGPG7beZ1PrymSk2taGND2sdEQsl8PYY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789439213; v=1; x=1790044013;
 b=IDOPJAkxV1E7AzaSc2U+1EHFnJVe9bFouwDr5qxPJEIvlUEhnz9UTbdjQXiBFhshNck9po96
 KZPR8ThwEs83KO1OgLZAN7lXnTvbROWgTBT/WHePb93AmuV0iOCvi5TpyiahBN36DQpzl/srgVw
 H98PFKLzQYBrGMToLsIP5D7M=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 28292594e66ea37f;
	Tue, 15 Sep 2026 02:26:53 +0000
X-Mizu-Trace-ID: 28292594e66ea37f
X-Migadu-Flow: FLOW_OUT
Message-ID: <7dccfc33-0ab8-4dc5-8886-8ad2b6dc290b@linux.dev>
Date: Tue, 15 Sep 2026 10:26:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm/vmalloc: extract show_busy_info from
 vmalloc_info_show
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ye Liu <liuye@kylinos.cn>
References: <20260914-vmalloc_study-v1-0-526f68559706@linux.dev>
 <20260914-vmalloc_study-v1-3-526f68559706@linux.dev> <aqgqjRJ8qpYmx04v@milan>
Content-Language: en-US
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <aqgqjRJ8qpYmx04v@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 98FF280002
X-Stat-Signature: asten4h4tsnhh3omai3x47xge9bd45ki
X-Rspamd-Server: rspam01
X-HE-Tag: 1789439214-799850
X-HE-Meta: U2FsdGVkX19X2Hx0p3fSyoyzXLZlN0BugTTqLi5CZIih9ub3asgJV1cuyxif6Wx2dtrQloSXaiWY98Cbfu1qhdQLRWYLjcksyGPAdHFmdp0wGTiWJ3SwHlHHcHQAQ/icaHrQLNvufkpH0Jba6OVyCoMnfu6C+cErmDDzAxQxWIcVm2hiG/KorpvxOUIgvLqBq1G9+TBH5ilSOdu9y90iiTzhx3oDVDV1qnO/fVF1BF1w0LmNro6oS1HQZm4lpbTo1OMbna/8wZJUQw51ak9+H6vtxBIN93trVO7XbWOBaQZ5LCDsaHpAhA8IiXKqtN4S/8FqprpRt0dkpo51TncbSFVkxSsb+8wL97Mc4Ymfi3rWlFMJdQkbCA/j/dcbjEEOTSyKH962AeP0tcnpABQKtpAJnjjLYm7rwBYrvBG0tyeMVypCJOs8T6jVnWHNApnEWlcg4R+qtob2YyiYwB6+5Gsaux7yA4HGZly4wXojee0yldiGqis0/rkM1GmcB3HBaoI98jaC69vkv2HHUIW45pOkO5CFgLKymrrpXxOLozRyOrM6cVLvxLnt3Gcry+RdFs/M1ecyTCE0/D6YcpEDjQwWUk0VlARgbtsd0NvaHBVYayW9nuXOnSmtMh5JNbCxFYLMrxqj+7cI9RM3nDvACofGhGKUnkYQLyIfsbWemiKjzWZBLBmWuw3dsJKh7AZIYpAsv6KlEZfBPS0LRfO/3OuAYdYwJkVHrJhTjD4JXET+4ggjiddtE9s9LDm5SuyNnmjT7xQbnv6ulz5MSE356/IkYIkbY5qAvni44EPe3l+ftfiQlXMlwjSZd+Llja7hg26z96j1WD36vecQxJfh3JjYDVhFgLq+xN8Bp79t9YiJBNOPzcPyUQEXzxCex4py0HRbmEg7GUrZP86OE/sglaess55pKrfP5A2mBSejr4lPtp3Xnp+Q1DlvSAwo0WmdTFQVThbOG7W7EMZuGSO
 7b+xR+Oh
 JXDPfPCkQVLg980HV9GWqAFyzcKm3/RF+J5CchLjRFfBP0Xak3Uboo01dkC5YHsl5GC894G/YsVM9TW039KzditToaKJ9yWs3JzNcU+YQL4t1qntbfRzRnp8gpBw3ROVz9fL/iT73LvhDzlr3iY6Bi1dLTKadDMDiR+8JWYHmpR6YlQ4ow/LjiEJ/UkD5Y7HK0/BHpA1YVDKXuXvgHpW3vWsnCmwr74ttsncxNHBGntvY+OjY7T5j5vDFPLdPGZQrnPHQKKtlo3eZfI7ul0P8AuI6YGBnZrv7aUX1g9GeQajNj8+HoR9Ja7eg7IdJeteZ0yHoyZnEYMn/tw3b+3Y8GjGdv2R2PTqCpKf0W9DfmIXh76UIL75QZ0wamw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/9/15 01:10, Uladzislau Rezki 写道:
> On Mon, Sep 14, 2026 at 11:34:02AM +0800, Ye Liu wrote:
>> From: Ye Liu <liuye@kylinos.cn>
>>
>> Extract the busy vmap area iteration into show_busy_info, mirroring
>> the existing show_purge_info pattern.
>>
>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>> ---
>>  mm/vmalloc.c | 14 ++++++++++----
>>  1 file changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index 797933ba9451..7638845377f5 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -5345,12 +5345,12 @@ static void show_purge_info(struct seq_file *m)
>>  	}
>>  }
>>  
>> -static int vmalloc_info_show(struct seq_file *m, void *p)
>> +static void show_busy_info(struct seq_file *m)
>>  {
>>  	struct vmap_node *vn;
>>  	struct vmap_area *va;
>>  	struct vm_struct *v;
>> -	unsigned int *counters;
>> +	unsigned int *counters = NULL;
>>
> Is setting counters setting to NULL odd here?
> 
I would remove '= NULL'.
> Other than that, LGTM:
> 
> Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> 
> --
> Uladzislau Rezki

-- 
Thanks,
Ye Liu


