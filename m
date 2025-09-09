Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28A0DCAC585
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 06:15:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 820B08E000D; Tue,  9 Sep 2025 02:15:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D15E8E0001; Tue,  9 Sep 2025 02:15:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BFFB8E000D; Tue,  9 Sep 2025 02:15:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 549CC8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:15:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1743458AE2
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:15:57 +0000 (UTC)
X-FDA: 83868701154.30.C531D1B
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0CC91180004
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:15:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="v/0Z4cgL";
	spf=pass (imf24.hostedemail.com: domain of youling.tang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=youling.tang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757398555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h0f43r2+G2MTHogFG4Kd662rlFkqbAoJ3O2gzPVjJRQ=;
	b=a3WaBhbYdJG2KmqAPUyPG6cn+wresIGiV3nSDPCUqZtD2RladS8bH31HjFO02RXI7aOmU4
	wo26iC61YvtQiTIvKanvyl62DtQr0FFwLBfBEm4pYGl0bO3o706K4S+ym3sujKZL43uXL7
	3B0WPvDFRuYFpsXlSYxh9YUp4ciEnwA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="v/0Z4cgL";
	spf=pass (imf24.hostedemail.com: domain of youling.tang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=youling.tang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757398555; a=rsa-sha256;
	cv=none;
	b=DIDqlNQNFDI+ntdO+yee6FArlKXhH0LoWlZI5qMmVY6Z94FRlcrE5FFMwfFgbq3QCj4tl9
	XNBHW9SO6EEnFaZ+hIC3sl39DEPT+biEIeIH+ytPkYjOxQbxwf4QKUD46WQb/IGw51KRMi
	iSMwlC6M6JBKPWtx6qSCxOeLSitIK1A=
Message-ID: <953544be-1be5-4745-a027-e8c0be7b027d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757398552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h0f43r2+G2MTHogFG4Kd662rlFkqbAoJ3O2gzPVjJRQ=;
	b=v/0Z4cgLTAbFBMK9eHbRTNRLDbMjpP60H7zKA6Q57i6tasGunFc/NqIxB/E12TX5vQVQb/
	m/mePYPQKEr7k4wEd/CqZ/q+Iv2Cu2FNCCyaansMscAHTa76fdURJcg9Tw7t22rpe9VojX
	mM6MFetCDy5tJdJFa9u3JU3wDMfFSQw=
Date: Tue, 9 Sep 2025 14:15:12 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/filemap: Align last_index to folio size
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, chizhiling@163.com,
 Youling Tang <tangyouling@kylinos.cn>, Chi Zhiling <chizhiling@kylinos.cn>
References: <20250711055509.91587-1-youling.tang@linux.dev>
 <jk3sbqrkfmtvrzgant74jfm2n3yn6hzd7tefjhjys42yt2trnp@avx5stdnkfsc>
 <afff8170-eed3-4c5c-8cc7-1595ccd32052@linux.dev>
 <20250903155046.bd82ae87ab9d30fe32ace2a6@linux-foundation.org>
 <bv4t7a6boxh4dmjl7zsmhd74wm5hyfpdivypmrqerlpn23betz@tw52mlf4xf3s>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Youling Tang <youling.tang@linux.dev>
In-Reply-To: <bv4t7a6boxh4dmjl7zsmhd74wm5hyfpdivypmrqerlpn23betz@tw52mlf4xf3s>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 0CC91180004
X-Stat-Signature: 3rsk6srnhnt74cfj1zug7phw5f84u5oh
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757398554-94786
X-HE-Meta: U2FsdGVkX1/E4bck51r8IxpgTl40TsmsxYYkLknTdOgzigM9Z+sMteqNFps8RI4vZEKnMR0me5/nM8Xlz+upfHx5kwAUagUTW+J0yJ5aAIe2D9dI86upLKEEC9ivOiNRVshCqtxpIuYf3RhgBkCctOab/0jqw1t68KZszrWN6Xmb+cPvIgkD7fI7hY8PS5F/zChz1Z7PpeEgDuZW9qNPx2VECj/8KuET6Cn/lfVJSNqOSZncR/bDpICAYFvTRNGXFz0QEki0LRKP3aXLd2LC7gD7hWRYu0NKz9z7BqXi6lTpC78H4VceWD8FLou8yp8QH5vtVTwcSGycyZHBnZE2+0bpGluoLQH879geT9Py5M0qCN/uLBmzz4WRZH1YIv3a9zsALlNpJ81dcVqjJ6+AYKAKYTcMTPog0p47CvfYtCxuw42URsORTw0Z5G9zm3IzLTUinnuv4uLMae8aNg96cVuVfL0VJzFYXJMLsBg/BIOpcZ37z4qnCjpOZXlPQsBvp2OQprxHpf1R0QgUSkDv4RTf4CJ7qJLnhhpdAG5fVmVrbOXJnlRzlMpaCC5lPmPdDlDEyy8Fd7pWWWopqZZ5Mwsf3zHQ+/pvarvtWTld/Wp90DM265IoSEnymnIpx8UHqfy3obeaXITsVxiiNYqsO0El80G+0737eGd0251WXqXNDA7Q/CIQ5a2x1Euq/BWIXW/bGAmjIQowsSNsMJFFOBuaDPkNu/G3K8OdFNOV9ZkqYx3lrgfLWZziMv45m/3RBMgGlC60g0YqpkOpx4eE/VQMZvFr4dcBwmuvOODjCqvB1irm5NujB/No6w8aPXXfeVc7Rzruef8vcvXaVd+23xO1QNbYig5bsMJd4r8vDpa75hAUk1OzyaW8vocUJ0uaNDeF9Ps1Sg1NYan2gmOXx+BWQ4pfO0+oxMlaeCFdbbB6HiPHRzV42iIj/1DLrRBQpSSYbCmCd/ZR8LftM+P
 X6HB85PJ
 hYvCO43CKUJobssv4C8h0M0sGdVLsjn7yNRyJvtGnf+YuLq/7RVfDQHOzpbU4Hp0kB+xZ14j/YBwX8oUog7nBicPPDzhvprcdf7yqKq/upsnlMm4nzHqxtxhA34aV3HnHqNdEnOIg/lfxXz/YSfWWRKzSwDWDDL3FFy+Z0SorO6XSsocbmmGFQi+go4ppc5cm028YQZs14iTh9d2sipFJ80CyMv4uaHP6HmY7LzNcVU1gBCKThtbQsE8gnBQHoWMsh4OU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Andrew

I see there are two fix patches for my patch in the mm-unstable
branch, should I send a v2 that incorporates these fixes, or is
it not necessary?
Thanks,
Youling.
On 2025/9/5 20:50, Jan Kara wrote:
> On Wed 03-09-25 15:50:46, Andrew Morton wrote:
>> On Tue, 12 Aug 2025 17:08:53 +0800 Youling Tang <youling.tang@linux.dev> wrote:
>>
>>> Hi, Jan
>>> On 2025/7/14 17:33, Jan Kara wrote:
>>>> On Fri 11-07-25 13:55:09, Youling Tang wrote:
>>>>> From: Youling Tang <tangyouling@kylinos.cn>
>>> ...
>>>
>>>>> --- a/mm/filemap.c
>>>>> +++ b/mm/filemap.c
>>>>> @@ -2584,8 +2584,9 @@ static int filemap_get_pages(struct kiocb *iocb, size_t count,
>>>>>    	unsigned int flags;
>>>>>    	int err = 0;
>>>>>    
>>>>> -	/* "last_index" is the index of the page beyond the end of the read */
>>>>> -	last_index = DIV_ROUND_UP(iocb->ki_pos + count, PAGE_SIZE);
>>>>> +	/* "last_index" is the index of the folio beyond the end of the read */
>>>>> +	last_index = round_up(iocb->ki_pos + count, mapping_min_folio_nrbytes(mapping));
>>>>> +	last_index >>= PAGE_SHIFT;
>>>> I think that filemap_get_pages() shouldn't be really trying to guess what
>>>> readahead code needs and round last_index based on min folio order. After
>>>> all the situation isn't special for LBS filesystems. It can also happen
>>>> that the readahead mark ends up in the middle of large folio for other
>>>> reasons. In fact, we already do have code in page_cache_ra_order() ->
>>>> ra_alloc_folio() that handles rounding of index where mark should be placed
>>>> so your changes essentially try to outsmart that code which is not good. I
>>>> think the solution should really be placed in page_cache_ra_order() +
>>>> ra_alloc_folio() instead.
>>>>
>>>> In fact the problem you are trying to solve was kind of introduced (or at
>>>> least made more visible) by my commit ab4443fe3ca62 ("readahead: avoid
>>>> multiple marked readahead pages"). There I've changed the code to round the
>>>> index down because I've convinced myself it doesn't matter and rounding
>>>> down is easier to handle in that place. But your example shows there are
>>>> cases where rounding down has weird consequences and rounding up would have
>>>> been better. So I think we need to come up with a method how to round up
>>>> the index of marked folio to fix your case without reintroducing problems
>>>> mentioned in commit ab4443fe3ca62.
>>> Yes, I simply replaced round_up() in ra_alloc_folio() with round_down()
>>> to avoid this phenomenon before submitting this patch.
>>>
>>> But at present, I haven't found a suitable way to solve both of these
>>> problems
>>> simultaneously. Do you have a better solution on your side?
>>>
>> fyi, this patch remains stuck in mm.git awaiting resolution.
>>
>> Do we have any information regarding its importance?  Which means do we
>> have any measurement of its effect upon any real-world workload?
> OK, after experimenting with the code some more and with rounding the
> readahead mark index up, I've found out we need something like Youling
> proposed anyway because otherwise it could happen that the whole readahead
> area fits into a single min-order folio and thus with rounding up we
> wouldn't have a folio to place readahead mark on. So with that I'm
> withdrawing my objections and feel free to add:
>
> Reviewed-by: Jan Kara <jack@suse.cz>
>
> to Youling's patch.
>
> 								Honza

