Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2042C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 01:57:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70D216B00B1; Wed,  5 Aug 2026 21:57:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BD116B00B2; Wed,  5 Aug 2026 21:57:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D69A6B00B4; Wed,  5 Aug 2026 21:57:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EFB336B00B1
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:57:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EDB5F1405ED
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:57:09 +0000 (UTC)
X-FDA: 85069181778.09.0417FBF
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3278A40003
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:57:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w8CAbadW;
	spf=pass (imf27.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785981428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/uTk3ewe/q6kLl+PWZH8/PgG1RIzcV92a/qRN4m/y+4=;
	b=r2Iiy/uD0LoyTx2sziZb2mwnXVBEPuSFDL7/biE2NHnbGfhNAVf6/cqGUHJRUPToAOGHWi
	jKnBhPwo+v+cFlnfYiFCJB5XybgpgjzV8XLLmJqh8aGMhEPt2omJTX89nDNZqZcxx9k9a/
	1BG2cxiyqtxQrvT9LZYUtQIIGDzpKps=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785981428;
	b=YpFC96UbI/whwZ6/WDl3A1KMMEauw7+7AejctqE19w6op4OZC10odtgsm5pGLrjizdw7G/
	dZb8n24j1TtjnPATernYqF7W/pWyGYiQC0us80Z30b9VE0wb51Ot57Q3o9ah3IPnWL0m28
	Am9YX5lBf6AlZRFCQkBGpX6/10uomYE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w8CAbadW;
	spf=pass (imf27.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <6ae9914b-7254-4a1e-8345-597d3c2d7ea2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785981423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/uTk3ewe/q6kLl+PWZH8/PgG1RIzcV92a/qRN4m/y+4=;
	b=w8CAbadWhcJtP+yNTReH6cOmkJMpjx8nUv9oVdDiYmkKg8C8fqcKCzjxpUtT4ZwTvxSO72
	gVSl3htpqPI82+PWrYwQceMg97OpIgcrL5B6rUlnBrbgObBgzB3ZYQ56uD+Kt2cl184ZUu
	LoY/jnLCbbeFgBwhXrGeovi7IWrPmKo=
Date: Thu, 6 Aug 2026 09:56:22 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm: debug_page_alloc: fix NULL buf in
 debug_guardpage_minorder_setup
To: John Hubbard <jhubbard@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260806004556.2633049-1-ye.liu@linux.dev>
 <0159349a-41f2-467c-b91a-3775e56a660f@nvidia.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <0159349a-41f2-467c-b91a-3775e56a660f@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: qb871ix3mrfr5sehoh6kwuezb15mmhbc
X-Rspamd-Queue-Id: 3278A40003
X-HE-Tag: 1785981427-90762
X-HE-Meta: U2FsdGVkX1+ndhPywu55RvEFRnCszdfOr8oEmqPQ0ONnMu+l/8+LxUgc91dMnQP3zuSpOeRWW31fDpaZHB0NwmgFylfND1dD4nqXYZ90E7tYnXF+5UNtsci9zdRh9NNqyD4MuHHfUx5w2ov8dF6xp1cokNIZzoguQHJFa2MvTA0IX+2F40h8C3gC86U9NgyZm5ZpLQQLKecBOkY1EOoJAcyFuD9MuDwbx3EkSwb4ZHLTzYd+tzXZXRGkXO6N88son86hlO03mIPKtb7ilvvlrFqQ22Bs8F0dt1M5gfOmAQJlCdvQXTPvLo3g6YR48NJXxMbTxjCbh+EN0gT4ISdeVJ6DX5toF069ihbTkMd4p4z4FPqp0yLIvbM6ww6uRFpr9SzUvWY8A2zxot5DcZ2UUMvctzYC+gCBs9yTvRCXxYD+w7glSf4kusiG76rNhkdn6VpAfDzj/wTCxKb2KvSZz8908aoFGQ2lADBnEdYPPsOkUefnLANHjfk7Sd1mJm6FmZ0JOCucMO63ZQROp6hw+tiBTUvTFmproTmTFHydQDPTF2FX6h7HcvGRwhAjOMbVveH872pPhQXoBYIvvk//ODY9GIQiTyfDs2zNjC5xtVx7PWsKQVZSc50+rTsYty1/3DF0yuclXVqq01fAJX1Yk79syFyyLrOlBQsqs8NX/jd9uocVGIdmBVBLD2ehntk6kH8iS+jbcD05oMlfXHv7Ch568jUYxGDl/eIsJ/eMKxwYdF3nNX3mFtCw66McZe9erfRNlLCQYa8ScLoKfZ7LSlXI3CFiSROvYXuBZzVJKNJ1li+C9zQRKCxoPckYd7Poup60qkwOshy0iXOt7VKL4DFf2yz7WRN0rsaSeoW+qJUZTIvU5CQmwIkbflsNUMLmlLc3PTAO5L50fN+hAWLYY8jtOdTyf1s9MlQOp/e68Bki5FlBjFANEyoYK8RUe3IUs4XgG9x3+yvwuqRA0x8
 mzCCoB73
 iu+KkU9Po/mW7DazZ/hveDw3ytf7SjzzXSF0hAgFbICzPPUl5+a12Fc0goFGi3g4mhrR/2IN1mxUiefyKOTUfbuDZNBk0U0AhvaWAUcENweT4SLGASBCNAZQgRfw7dtIPZGGXCHfUW2aMGCX+zXtpXRjN0hqwi5IpoOyb2TUx39Jle8i/92r1Jf9VN9Bq53dN816YCbxjr0UICLyZ7c1dRDGStqDFhsJriwF1pYQfATA9qHS0ZlGnSZro/fDAhh294Vub5lDoOT3hK1OnY0Ohpme4kA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/8/6 09:08, John Hubbard 写道:
> On 8/5/26 5:45 PM, Ye Liu wrote:
>> From: Ye Liu <liuye@kylinos.cn>
>>
>> If the kernel command line includes "debug_guardpage_minorder" without
>> an equals sign (i.e., no value is provided), the early parameter
>> parser passes a NULL buf pointer to the setup function.
>>
>> kstrtouint() does not perform a NULL check on its input and calls
>> directly into kstrtoull() which dereferences s[0] unconditionally,
>> leading to a NULL pointer dereference and early boot crash.
>>
>> Additionally, the error path's pr_err("%s", buf) would also crash with
>> a NULL format argument.
>>
> 
> Maybe a "Fixes:" tag is called for?
> 

Add the following Fixes. Thanks.

Fixes: c0a32fc5a2e4 ("mm: more intensive memory corruption debugging")

> 
>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>> ---
>>  mm/debug_page_alloc.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/debug_page_alloc.c b/mm/debug_page_alloc.c
>> index 41e3d1f1ad96..fd2664c3c86a 100644
>> --- a/mm/debug_page_alloc.c
>> +++ b/mm/debug_page_alloc.c
>> @@ -22,8 +22,8 @@ static int __init debug_guardpage_minorder_setup(char *buf)
>>  {
>>  	unsigned int res;
>>  
>> -	if (kstrtouint(buf, 10, &res) < 0 ||  res > MAX_PAGE_ORDER / 2) {
>> -		pr_err("Bad debug_guardpage_minorder value: %s\n", buf);
>> +	if (!buf || kstrtouint(buf, 10, &res) < 0 || res > MAX_PAGE_ORDER / 2) {
>> +		pr_err("Bad debug_guardpage_minorder value: %s\n", buf ?: "(missing)");
>>  		return 0;
>>  	}
>>  	_debug_guardpage_minorder = res;
> 
> thanks,

-- 
Thanks,
Ye Liu


