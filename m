Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6049CCFA03
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 00:36:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F11B38E00D0; Mon,  3 Nov 2025 19:36:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE8C18E0058; Mon,  3 Nov 2025 19:36:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFE528E00D0; Mon,  3 Nov 2025 19:36:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CD7878E0058
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 19:36:24 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 70C36140352
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 00:36:24 +0000 (UTC)
X-FDA: 84071058288.16.6CBB999
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5CDCD1C0004
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 00:36:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Z2vCX6a8;
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762216582;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rzEoGW6DZWu5zrrQLgXZO5MejLWoxJsp61Y5pY+ws4o=;
	b=M1lfz1PUQQxWOn9/s6Qw+atEAzMKz2bsyvdjrbgBDPKJVkTyx1r9Bf1AAwDhS56j+XD7ug
	NVBD8KHutKEa9KyZRekDH4DVVGNFttZyAePP29F92/Yu0Bjkfbd14ubn/li4yyVGhXO26g
	PStboOVY7ZDY4LFvtMpewBAl8rK06a4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762216582; a=rsa-sha256;
	cv=none;
	b=jEuXPlSVmI029xCwbEWKsHgmXnHPz5ysvk/UdYMJR+EdXi9NbVJcNWAAFGV+ZUJfvFUcNX
	yzuEeSpMII5PwzoF34TuReFHzApbDPZJuLTlpl2eKi/HkfGGerWQKNmPtm2HBbfIkMceHB
	Odk8iyNfpA0qmYXFR08dn8ViLAwQeaw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Z2vCX6a8;
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-63c0c9a408aso7290636a12.3
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 16:36:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762216581; x=1762821381; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rzEoGW6DZWu5zrrQLgXZO5MejLWoxJsp61Y5pY+ws4o=;
        b=Z2vCX6a8WsQRr3KHx84OpI1SyA2Xf41571WnMIm4u7KPgqW8HrT7AcIHgMbhVNKRiw
         /t1fHjVb7yICsTiKsGaVDao6DQzgln4OAjXoG44IeeEUB5h56F94GRdQUWRdYGxIeGwL
         9rH/0u4ZOCfGBNIKTydevhSuw9lytzZtY7PEi91MSDIhcJmAS4li0sAZPuIw1WKvCrif
         Zc7WwUddAteFN2m+0SsndZ53MRVkF3lLoQPDUiT8lc8TQxnlemzhUYxNjXbZfikS5R5c
         4LOBv1EjE1+Xmt3zXrf5tSHZeMS+xNydOAvITr78yHklhjpBXMN+qnFetmTSaw4YREzD
         FKkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762216581; x=1762821381;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rzEoGW6DZWu5zrrQLgXZO5MejLWoxJsp61Y5pY+ws4o=;
        b=qu7OYxL03WzvFbuC6cjbkxUr8fPOTHsLufMmi0GtRP+bHGtXonzi3XEsxreBsowVwA
         NztuIaNpULWlqGJzH4u2raPOMYAbKYTlRrDTumehwQH3mpLCm90zIWm5cpwXaNiJts8I
         6E73zU/XPjR+OwdveA03hFabvKIzApEDB1yUUtM2IgKAOcusolY2sx3X+c8dzKW2CajI
         1mNG1nAK27yL/QTYDyx+uofCRGaRZE+6XqCtKOPmKjpV49a6ebt3GmcBsChxzz80STbb
         mqpDuMpwqsWkT47Dt5Kq6yDaNsZSyhCpXBFXIRwh0vExfQUWYgjS2noPbeAn0vf7uREw
         Ar/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVVQNANZw9xx0vlwhqlsTsrXflsAWGuZW7DQRTtyuocBYcpUjJ8McSRsWnlH9RZB16+nFsbtU+Jcg==@kvack.org
X-Gm-Message-State: AOJu0YxJAuy4pSa+Km8CuWcwGKpAo5y85KYJ8d63zKqCuSgsx61bvbzG
	JZQYzNnMk9REJaO7Oi+TnY1Q24tLKWucSBUqM1fgi4enLbQkQy9qyl4c
X-Gm-Gg: ASbGncs/bGw7ShnQS86ge79fBw2SFGyGDilXUTSqIoL0EpaACEknmGIaAV7LwpTPfGT
	P8Oak8IpdLo2yYCb6DuqvBDUHJ1Mixkx8qkOdjaHUa2Yd/bXEEyi45eOuUnr2rRgyPbO5jNVRdX
	asboBnA/AOQbyo1EpkUPdU/YkBg8Z4C+5bnUFoh78bBUHM3JG00OovlHobDPx/lMwJHWmtD54Tg
	eubE1qUmWKFYeFNCn6dG+b/uenZ5TuqkIaIiIpLq+GORY1og3MFUMNtQ2E9j2zhVsEb5GvHeWpm
	8MF6qO9P7KS+Ri3sLuw9thjuuIqA3vdp9CyucvNT3i1UnRJg3NxxcErT02t+F69g+mi0YzvyTuv
	6Ktoi+p0Lt0pxFtKhXOA0uv1D9+9Wbs/za8NNht1bZTpMq+hYCyxfHIWPM7UacG5dIBIAK2zkqz
	s=
X-Google-Smtp-Source: AGHT+IEkR2NLMXKuEZel7fJeh+DHT10gMxObMOeRLrmPNXK14RcVVRWUODjsHg5LmWOnMYpwtvJpCQ==
X-Received: by 2002:a05:6402:5244:b0:63b:dc3e:f01c with SMTP id 4fb4d7f45d1cf-64076fad74amr12175195a12.12.1762216580460;
        Mon, 03 Nov 2025 16:36:20 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-640e67eb64dsm695131a12.5.2025.11.03.16.36.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Nov 2025 16:36:19 -0800 (PST)
Date: Tue, 4 Nov 2025 00:36:18 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] mm/huge_memory: merge uniform_split_supported() and
 non_uniform_split_supported()
Message-ID: <20251104003618.adfztcwwsg26gmvd@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251101021145.3676-1-richard.weiyang@gmail.com>
 <CF5DECC4-7C92-45DB-9931-A1E35CA3C0A5@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CF5DECC4-7C92-45DB-9931-A1E35CA3C0A5@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 5CDCD1C0004
X-Stat-Signature: dkit7a5674bkzke6hizjh5sxerwekmiq
X-HE-Tag: 1762216582-755920
X-HE-Meta: U2FsdGVkX1/ea9jQiUaS3jNromNqZjvAMMFFKaWKzAVVPmXfL3PLbaqLT4IzikmV3p4hgT2jOgWE/y7zztCqYa89ygiUkv9Ki1YF+aGmiIxksIC6rqEU5F3uI3I4AlfHvNSETutwZyW+O5ah8DpB2kuYtKUQIQv2Anys5azYBu/xEpt5+vdmNzMeHbSyFFI5+KWeWaxumix2fqmqqLc3Bu0rf7RQVzRxH8jW7OWi++uERWnWwGnLd1jAkrNtNQd9Z4PQWBMdEVRImbkt38Bgheb+SQSC5YYPLR7EIjGaM0FcvrOKMsH4nJs4H+9IRZghVbrJSZ2PAARyCp2fyIzzJJ+uxjAfLoW5LDhJ1uxlWQVKra3aU73axSwMCPjPXzFt9SRRtdRMMN0aQ1+EJJJBG/YPJiORJ+kAksyD28mB8o/uPnddFnJ7dol7y6CHqc1kfmOuhLusR2AOZfnfNQwPoXA88hetvR3vBACSJFIXtXrQnP5ZvQvyhiplNYtD681bZbI8up+lFvoXBzFi4nUFd8soOCFbqmj0dPHO9kgXgTp0NzafUzh2XnGt43ps6VqQBVu1nAsDowpZOybuQaSjb4aOmE9C6ARx7JKvqvPEUKwVdkwH6Use7ue5k+SC3o18CHBjEDmJYN5LpixKTVEmc+Pxve5nKXF4m3ENrRWUDMdUelLLrgg8cMuvYhnjTvqGApqvE1w/kMwI+DqvKhI/tt8N2AKuGiIIcvRkYVh96WnVt8A3//qoa/9AhepzoptQih0j0sufEbNMF4JoG+JJWud9op5151ixoYpSafrbCxGiFqpqOTwE1zIuF2G4P5+goZEmc2vd2hAKFJRM0dKNBcBJt+gEasuyOBxvgkWlVOdy+vRnfxgtXrR9FtU9M+gSRyB4BqoLYDesEIUajJBgR8YEzfsbov03XuJ0w1LG3VHl1p5aNgqhRDZ1axr9QNCiCo/mxBtqUS2k+JGOFA4
 MlsHdZWf
 ZpWFV3a7p5gYV3l3E/YGn9fGXLQlJZGwS/vaPj0bGI3TVD/Syw9eT7k0M798FJJNHZnWKOEN5MfLxwjhWWPMnyhMiO7IAcKu6VBQ+1O634jGKPqGUd0rGME6dmZ5I+bIdajYQBIibjWaHDhQqPxEOsFzArHBUcx0TQ/jic13F51rrlaYRkEZgqDI5OUFRswIbhRYuTyDOkrWp0JPfbwfRmZBYHRWkCSeRuzt0aNzAkTMgz0kuNGWCMUHyn3/fg/A+08+JHooRlfXG4Pi+af2VXqVtHte0gqeIjAliVUZ2yYLm3bBEaYV6oB9T//YDDQu8Bvd/uYCS4wAH+QS3csgQTPfL36N+lW79VkBYRVfBiDB/3HaudFtW+COfWzfY+2eTLm1FtH4wODmsPb5u7gDzT+EwJnnrkjCiTthRwdrpo/kNzVFSyhr0PqEtiFKBuGZB8qgQeywA9dBTK2rBnXLflkIlF+xBydb4S7yOIgcfLBv2fGuqvSvJZVEJreU6BJJD5pZuSZDCjJ56z40hWyjpLjrGb4TvNI1iC02Vco87ZQwA3mtCCxQIVZRr13Kve+53RmbMAEY5kniMrbIp8wRlUr9M55FMzPPDze6+PY6a5y3XFAsXSkVHa8otwDxHsjigoGS9867mpt6Q41MLwhoGf8dlQb+u/ciDSpYOcT1mWTbP/ncYmtI6cwn1AzV6tfHks0cXST+1d9kxaBXFxcLUESr4xjsBYiqmX9jXdZthZypd2tD41lyWHLe5eERnjsRnFtm+Sgu7Q2KalZ25E4uINMz+DaOS/BRr/gmOLZlhZk6sYxAaGxYseWoOIqTWvpzhin5K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 11:34:47AM -0500, Zi Yan wrote:
>On 31 Oct 2025, at 22:11, Wei Yang wrote:
>
>> The functions uniform_split_supported() and
>> non_uniform_split_supported() share significantly similar logic.
>>
>> The only functional difference is that uniform_split_supported()
>> includes an additional check on the requested @new_order before
>
>Please elaborate on what the check is for.
>
>> proceeding with further validation.

How about this:

The only functional difference is that uniform_split_supported() includes an
additional check on the requested @new_order and split type to confirm support
from file system or swap cache.

>>
>> This commit unifies the logic by introducing a new variable,
>> @need_check, which is conditionally set based on whether a uniform
>> split is requested. This allows us to merge the two functions into
>> a single, combined helper, removing redundant code and simplifying
>> the split support checking mechanism.
>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> ---
>>  include/linux/huge_mm.h |  8 +++---
>>  mm/huge_memory.c        | 55 +++++++++++------------------------------
>>  2 files changed, 18 insertions(+), 45 deletions(-)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index cbb2243f8e56..79343809a7be 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -369,10 +369,8 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
>>  		unsigned int new_order, bool unmapped);
>>  int min_order_for_split(struct folio *folio);
>>  int split_folio_to_list(struct folio *folio, struct list_head *list);
>> -bool uniform_split_supported(struct folio *folio, unsigned int new_order,
>> -		bool warns);
>> -bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
>> -		bool warns);
>> +bool folio_split_supported(struct folio *folio, unsigned int new_order,
>> +		bool uniform_split, bool warns);
>>  int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
>>  		struct list_head *list);
>>
>> @@ -403,7 +401,7 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
>>  static inline int try_folio_split_to_order(struct folio *folio,
>>  		struct page *page, unsigned int new_order)
>>  {
>> -	if (!non_uniform_split_supported(folio, new_order, /* warns= */ false))
>> +	if (!folio_split_supported(folio, new_order, /* uniform_split = */ false, /* warns= */ false))
>>  		return split_huge_page_to_order(&folio->page, new_order);
>>  	return folio_split(folio, new_order, page, NULL);
>>  }
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index d1fa0d2d9b44..f6d2cb2a5ca0 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3673,55 +3673,34 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>>  	return 0;
>>  }
>>
>> -bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
>> -		bool warns)
>> +bool folio_split_supported(struct folio *folio, unsigned int new_order,
>> +		bool uniform_split, bool warns)
>>  {
>> -	if (folio_test_anon(folio)) {
>> -		/* order-1 is not supported for anonymous THP. */
>> -		VM_WARN_ONCE(warns && new_order == 1,
>> -				"Cannot split to order-1 folio");
>> -		return new_order != 1;
>> -	} else if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>> -	    !mapping_large_folio_support(folio->mapping)) {
>> -		/*
>> -		 * No split if the file system does not support large folio.
>> -		 * Note that we might still have THPs in such mappings due to
>> -		 * CONFIG_READ_ONLY_THP_FOR_FS. But in that case, the mapping
>> -		 * does not actually support large folios properly.
>> -		 */
>> -		VM_WARN_ONCE(warns,
>> -			"Cannot split file folio to non-0 order");
>> -		return false;
>> -	}
>> -
>> -	/* Only swapping a whole PMD-mapped folio is supported */
>> -	if (folio_test_swapcache(folio)) {
>> -		VM_WARN_ONCE(warns,
>> -			"Cannot split swapcache folio to non-0 order");
>> -		return false;
>> -	}
>> +	bool need_check = uniform_split ? new_order : true;
>>
>> -	return true;
>> -}
>> -
>> -/* See comments in non_uniform_split_supported() */
>> -bool uniform_split_supported(struct folio *folio, unsigned int new_order,
>> -		bool warns)
>> -{
>>  	if (folio_test_anon(folio)) {
>> +		/* order-1 is not supported for anonymous THP. */
>>  		VM_WARN_ONCE(warns && new_order == 1,
>>  				"Cannot split to order-1 folio");
>>  		return new_order != 1;
>> -	} else  if (new_order) {
>> +	} else if (need_check) {
>>  		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>  		    !mapping_large_folio_support(folio->mapping)) {
>> +			/*
>> +			 * No split if the file system does not support large
>> +			 * folio.  Note that we might still have THPs in such
>> +			 * mappings due to CONFIG_READ_ONLY_THP_FOR_FS. But in
>> +			 * that case, the mapping does not actually support
>> +			 * large folios properly.
>> +			 */
>
>Blindly copying the comment here causes fusion. The checks for
>uniform and non uniform look similar but this comment is specific
>for non uniform split. The “No split” only applies to non uniform
>split, but for uniform split as long as order is 0, the folio
>can be split.
>

Per my understanding, "no split" applies to both uniform/non uniform split
when new_order is not 0.

So the logic here is:

  * uniform split && !new_order: no more check
  * non uniform split: do the check regardless of the new_order

But I am lack of some background knowledge, if it is wrong, please correct me.

>Please rewrite this comment to clarify both uniform and non uniform
>cases.

Not sure this one would be better?

   We can always split a folio down to a single page (new_order == 0) directly.
   
   For any other scenario
      * uniform split targeting a large folio (new_order > 0) 
      * any non-uniform split
   we must confirm that the file system supports large folios.

   Note that we might still have THPs in such mappings due to
   CONFIG_READ_ONLY_THP_FOR_FS. But in that case, the mapping does not actually
   support large folios properly.

>>  			VM_WARN_ONCE(warns,
>>  				"Cannot split file folio to non-0 order");
>>  			return false;
>>  		}
>>  	}
>>
>> -	if (new_order && folio_test_swapcache(folio)) {
>> +	/* Only swapping a whole PMD-mapped folio is supported */
>
>The same issue like the above one. Please rewrite this comment as well.
>

How about this one:

   swapcache folio could only be split to order 0

   For non-uniform split or uniform split targeting a large folio, return
   false.

>> +	if (need_check && folio_test_swapcache(folio)) {
>>  		VM_WARN_ONCE(warns,
>>  			"Cannot split swapcache folio to non-0 order");
>>  		return false;
>> @@ -3779,11 +3758,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>  	if (new_order >= old_order)
>>  		return -EINVAL;
>>
>> -	if (uniform_split && !uniform_split_supported(folio, new_order, true))
>> -		return -EINVAL;
>> -
>> -	if (!uniform_split &&
>> -	    !non_uniform_split_supported(folio, new_order, true))
>> +	if (!folio_split_supported(folio, new_order, uniform_split, /* warn = */ true))
>>  		return -EINVAL;
>>
>>  	is_hzp = is_huge_zero_folio(folio);
>> -- 
>> 2.34.1
>
>
>Best Regards,
>Yan, Zi

-- 
Wei Yang
Help you, Help me

