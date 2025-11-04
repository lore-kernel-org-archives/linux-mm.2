Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8E9BCCFA00
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 07:53:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 422108E00F7; Tue,  4 Nov 2025 02:53:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D1BD8E00E7; Tue,  4 Nov 2025 02:53:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29A9E8E00F7; Tue,  4 Nov 2025 02:53:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 13DC18E00E7
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 02:53:32 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BBEA04A7CC
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 07:53:31 +0000 (UTC)
X-FDA: 84072159822.15.A5679E7
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id A8368100006
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 07:53:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="nSjI/05g";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762242809; a=rsa-sha256;
	cv=none;
	b=CwX0PswjS2lEe3e2gRqslpP5pjqXoGiyn5KH9sbLW67MyyRqILX84k/SPgFlBUndpVAl5A
	KUNLwm7O5lNRhC2X0J+IRS8NhQwigWmAS096zGl2d1cj9urwA2MpLRw7rscW9CneX63U/x
	hb/n/cHoJATkQxyl3CIs4rEkTOnrOJE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="nSjI/05g";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762242809;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/c0cWuMNthabQIvP+S2vYuStVi48qVUenefOXdza2xg=;
	b=pmRqrgwTh4jI1sleF0zjn0jHDJ4nedAT8ZxvyUy4gSjtE05KWnTF2V0hygOXUeNwrza35I
	/+8eMT5xEp8yZHM5JwMJsgzPr8KeK+AkQTPJ814ClzcGP+RW/lkYcVAglNoiArFDYwp6tY
	6+mWI6WyI1GCZYHXuB5DkQnSTem9HKw=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b6d3340dc2aso1275387866b.0
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 23:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762242808; x=1762847608; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/c0cWuMNthabQIvP+S2vYuStVi48qVUenefOXdza2xg=;
        b=nSjI/05g3qFWU2WRdZThJ/DB1LNN1NJOwt0dqYjxOPlIWhqtmkj2Yz7RPjTPOK2ZxU
         JJ825R4P9Bd38IxXq3RL5R593SU6jOtweMuBr/ERfcpGhogE7TLv0FyT/U0jQ+b8QOGU
         gviSrn62KHkiooqL62IyDf+sVJLX8dE6HvaE4nFDy1JfxksC5v58p1TCRaR5qScKvQrl
         kq96H/0LetoVRaHvb4bSppQ9V7wDhXOQou/aAthDP4lYSPHhdhxYGsTwxHoMdyusgb9k
         AhT2XG0knuTU5jdj1Oi5fGr+kHYfJf8DGKILem9a9zpT6tJizCb3PtSg3z/eALC2lidt
         nh/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762242808; x=1762847608;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/c0cWuMNthabQIvP+S2vYuStVi48qVUenefOXdza2xg=;
        b=m3I+vol1w0KDUZ1dglcvbkMrYYHx4w1frig3/wp+bsnlTKknq3b0y5GHyfuzUooUYo
         AB9Ls8piAQVPHmB8nhxXV6jVy2VHh2fc3CRFue1JWpKOi3ju67Rk8zVLHwSelcQa9hzo
         dr24Ji2Dqbdde4/iawugduQV43q5Q7udCODqzLQD3z0g6VoB4WfJsYfRP+v2wSym8U26
         PD4DtTNrb1YrpGUUEhwUPtxXVjZzmwd7KzXTajvjIP9MYwvB7mfLdZwetuQYBCheSdEh
         v0CMofAi32lMTxRmFDcQVnmTlHfLUhUM1X6hqENccsu9WqCViEb4Q1xxq4thPx4jEgC/
         tKyg==
X-Forwarded-Encrypted: i=1; AJvYcCX6Hz8EMRB6J6axV8aocG9TnGOcYMAuPvdiM9UlOW1rL0kfSubsVtiuiQ+w/sL7aRQfTF70fb/UpA==@kvack.org
X-Gm-Message-State: AOJu0Yxhsey1PdXkgki9cXJ25UE6+xfHROeNnuA1ZSTrGvYX1zUBi2iR
	7gK9p0zi6AjUWTMpJFNtLESb470cWuxcsGBZCT6q+MXfkPm81t0vaCGU
X-Gm-Gg: ASbGncv03IJ75QO+oeC7EfX/aTRN2s4AvnFtAnHLNyxC2cbUuMxBFI3ZolEEZFpOoIT
	4y3dzvblhUdoeTf4LHFciT8Lv7bjYO8XpbV955Yzio9SEtegA/ImnqWGg/1B5BeW7lTLcEeZniW
	CP+G6cK3VOWgdzZ3idLbiyxbYZkVXobciipesU3dxDVhNDJrVGE0J0aOUbTCh+rEPqf3bJE7bNh
	4fqvkyDgDUpfKOdxKQLPSV6heEVPR29WUe4U6JT9bjP7as5YZpMR+cpCbLgX8mkk4wuYgPFnX2H
	CfRhh3gzd9LcpClAPUmuccs81j6CwaHy+f87bd2xJIs1iDXVUH19hkIa1V7UWvJNex6AmtIjsZz
	K6UpLA1KLZuIiXffKmgaqIWVI2+ASzuKhLdYTp7Efy6k2LJ7uQe+muU7N3nRjYLKr2s1o8Ke4C/
	g=
X-Google-Smtp-Source: AGHT+IGGSzUEQC5GNQ0kebc3Soggrn+Djd8JqMx2PWVdoqxVgizEucNoDhfXDBu0nKmUReTNWMzVFA==
X-Received: by 2002:a17:907:60c9:b0:b65:7f88:72d5 with SMTP id a640c23a62f3a-b7216e61f39mr236569966b.28.1762242807566;
        Mon, 03 Nov 2025 23:53:27 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b723f6e3764sm140126266b.48.2025.11.03.23.53.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Nov 2025 23:53:27 -0800 (PST)
Date: Tue, 4 Nov 2025 07:53:26 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] mm/huge_memory: merge uniform_split_supported() and
 non_uniform_split_supported()
Message-ID: <20251104075326.hqktuvois66j3cdk@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251101021145.3676-1-richard.weiyang@gmail.com>
 <CF5DECC4-7C92-45DB-9931-A1E35CA3C0A5@nvidia.com>
 <20251104003618.adfztcwwsg26gmvd@master>
 <016650EF-DBFC-4C7A-A707-8FC6A0F93ABD@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <016650EF-DBFC-4C7A-A707-8FC6A0F93ABD@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A8368100006
X-Stat-Signature: 69qsztzyoafsnjh51qsuywrt1dzepty9
X-Rspam-User: 
X-HE-Tag: 1762242809-819092
X-HE-Meta: U2FsdGVkX1/U33axjMP3F7zYZZd7iloiutubYP+Y0jygFE/7nafhHXxSYm+bGreKG0nS2MjHmieJj8uZuEUpkk/QsblnLKgUgRcYw4z7pDAB/UoMR6JloQWC7WZ8OUCVHnGUIrvh5MRWL1joNXKPWI3l0Uw5kjVTQ8+PA/2rFz7GqSPvBI/h3WpjLm4jUfceRQ78iwDu7JQLfGZ68hsQvSqv19ajOnW2VQM0tIUF1ePIZetxG6Xmt2l9uJsXCRelsApS/fFPZ6RnagL1+AWxf8PZaWB2cGZxLxQF6A2SzNmlimofNjgXrznafPQXYW9xe1xfpqrXIPhQ0m/3JTBFV50vWJ5MNdzCde5D7K0c/6omUW/ytOIv9w2buZ86TisnMilorGa+4LcKJHZZ/pkcctsjFDsWvY7Wm0Cow98X8OJuuBnFMzu47Q3/0LFVCXSBHDXqTLFvSOwtfw9nPAD+dn8iiPHC6Z94/rRs6bK69ueuYTXHZPNrQUOUdect/ZUQgQ3NY4FayK4e9KhA/d/4R7b8+Klgzra6BztTOCavc+xOCyiT72tLTfqbWy0EZ1fRipDMc9R5OQcAXnLzd1UPlrU6kQSPBCq9XHO4ja2MRK45Pt46vQQN2m8nju5NX9uJ0tplEc2jgT8nsgcb5j+MLrKuVCz3PU3ZSlepqQ3oSjQ5iO6QYGHG/H+ivJKCRm8yuX8AGfxVofi/MVsmyOg+qNsAEHZyjg04p88/UhcTitDn674y2eP7zDO9/LC+8oTUSt9fTzUzuSyWRHuCIdlfFgREPI5GjJP5/m8K02hzmXcAkGi/3NpAkgWRcamFVIRGs1oPUAZz1dmA6BAbbXsB0z+N3Un3ica+FR1WGKGP8RkQL+aEoET3JBvvD68HmADoNEim2LU8Uv4/9faSw4oyPdl5Nc0TBfUkg1Q38xxipxmwgdG1JITiVo7YvhDzX+hgMxnZ5LoWEx/2G5V7g+s
 TiZo0yF1
 cc88HljDlyVNUgyOG4tTv8SbnetHcFH4WUQyQWaUuU4hP8SQTijg4yl0W1Q7CKaDRkD4B50IjMTDMnhVzS7e7kY1Bzf0QgqXIaN+sP6WOk7NbT0vgA+igPqnnL1gnuYX7pP0GajYpTE9ZN/hKPHZUFsoDDlJKKA5kRnJW78HVTCadBKF16PVkfLK0XL/ayLEU18zouI/AH7tZfrXpvjTJqphj4dVdLCLgIZG938k0jLtx0/RE9JtFt/yLH1WPDbT9PimU0xRe4Rac1opjk0MShIgdA/NlPk7sXZ+Tx51O23DTK4kRR+wEWSan5lmWf7Hncwj/k9H11Z+CVjODL++rQkreqJWp4Jr2krI12RodnergmKSOs4dVpf2R8VCw+mbvsqwci++b7F7Gpqv92E7DiP7Ky5639EB3RR7elo7st07qJV2GoByL7sstLkDdyJsIMxNsP2qUOHO+mnIoqna62fGvF9P6Clc3pCiFkTpQvbwKuXNy933pYTKjdzMXN7kn4EDmwYyUYN5ApiJC0oSmLcJo1cYYEEy6ob2xTViB0byOyXyBJHLgTnOGdLbsItuecbowKYrDPkhwDZfToG9nUpwX1saNOX+2AZVOHEeHsBvNYqNigb8+ZEZKNXjKrvb+9v8gqBOGBqMBaQ+RV4V4eJgp8RA2wLnD9yDlJ27DoVlCb+ZlEqwWFn4PqJPUm3APRsRcwaVaWBG9VLmplvBoS8gsw+vy5qmZnmOfiY4VW0PBMm6o924sE59n1oq6kBoxH7pPJXq8joGPgE9OzH2RnDl4mxT+kpxbpK5XmnmMs2bR/GJNuMlJ4AigWYi38JpAggNz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 09:30:03PM -0500, Zi Yan wrote:
>On 3 Nov 2025, at 19:36, Wei Yang wrote:
>
>> On Mon, Nov 03, 2025 at 11:34:47AM -0500, Zi Yan wrote:
>>> On 31 Oct 2025, at 22:11, Wei Yang wrote:
>>>
>>>> The functions uniform_split_supported() and
>>>> non_uniform_split_supported() share significantly similar logic.
>>>>
>>>> The only functional difference is that uniform_split_supported()
>>>> includes an additional check on the requested @new_order before
>>>
>>> Please elaborate on what the check is for.
>>>
>>>> proceeding with further validation.
>>
>> How about this:
>>
>> The only functional difference is that uniform_split_supported() includes an
>> additional check on the requested @new_order and split type to confirm support
>> from file system or swap cache.
>
>You are describing what the code does instead of its actual meaning.
>You need to describe:
>1. what is the difference between uniform split and non-uniform split?
>2. what order does what file systems support? Only order-0.
>3. what order does swap cache support? Only order-0.
>4. why can uniform split be used to split large folios from 2 or 3 to
>   order-0?
>5. why can non uniform split not be used to split large folios from 2
>   or 3 to order-0?
>6. The logic similarity between uniform_split_supported() and
>   non_uniform_split_supported() and they can be combined with detailed
>   comment.
>

Here is the updated version:

The only functional difference is that uniform_split_supported() includes an
additional check on the requested @new_order.

The reason for this check comes from the following two aspects:

  * some file system or swap cache just supports order-0 folio
  * the behavioral difference between uniform/non-uniform split

The behavioral difference between uniform split and non-uniform:

  * uniform split splits folio directly to @new_order
  * non-uniform split creates after-split folios with orders from
    folio_order(folio) - 1 to new_order.

This means for non-uniform split or !new_order split we should check the file
system and swap cache respectively.

>>
>>>>
>>>> This commit unifies the logic by introducing a new variable,
>>>> @need_check, which is conditionally set based on whether a uniform
>>>> split is requested. This allows us to merge the two functions into
>>>> a single, combined helper, removing redundant code and simplifying
>>>> the split support checking mechanism.
>>>>
>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>> ---
>>>>  include/linux/huge_mm.h |  8 +++---
>>>>  mm/huge_memory.c        | 55 +++++++++++------------------------------
>>>>  2 files changed, 18 insertions(+), 45 deletions(-)
>>>>
>>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>>> index cbb2243f8e56..79343809a7be 100644
>>>> --- a/include/linux/huge_mm.h
>>>> +++ b/include/linux/huge_mm.h
>>>> @@ -369,10 +369,8 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
>>>>  		unsigned int new_order, bool unmapped);
>>>>  int min_order_for_split(struct folio *folio);
>>>>  int split_folio_to_list(struct folio *folio, struct list_head *list);
>>>> -bool uniform_split_supported(struct folio *folio, unsigned int new_order,
>>>> -		bool warns);
>>>> -bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
>>>> -		bool warns);
>>>> +bool folio_split_supported(struct folio *folio, unsigned int new_order,
>>>> +		bool uniform_split, bool warns);
>>>>  int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
>>>>  		struct list_head *list);
>>>>
>>>> @@ -403,7 +401,7 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
>>>>  static inline int try_folio_split_to_order(struct folio *folio,
>>>>  		struct page *page, unsigned int new_order)
>>>>  {
>>>> -	if (!non_uniform_split_supported(folio, new_order, /* warns= */ false))
>>>> +	if (!folio_split_supported(folio, new_order, /* uniform_split = */ false, /* warns= */ false))
>>>>  		return split_huge_page_to_order(&folio->page, new_order);
>>>>  	return folio_split(folio, new_order, page, NULL);
>>>>  }
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index d1fa0d2d9b44..f6d2cb2a5ca0 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -3673,55 +3673,34 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>>>>  	return 0;
>>>>  }
>>>>
>>>> -bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
>>>> -		bool warns)
>>>> +bool folio_split_supported(struct folio *folio, unsigned int new_order,
>>>> +		bool uniform_split, bool warns)
>>>>  {
>>>> -	if (folio_test_anon(folio)) {
>>>> -		/* order-1 is not supported for anonymous THP. */
>>>> -		VM_WARN_ONCE(warns && new_order == 1,
>>>> -				"Cannot split to order-1 folio");
>>>> -		return new_order != 1;
>>>> -	} else if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>>> -	    !mapping_large_folio_support(folio->mapping)) {
>>>> -		/*
>>>> -		 * No split if the file system does not support large folio.
>>>> -		 * Note that we might still have THPs in such mappings due to
>>>> -		 * CONFIG_READ_ONLY_THP_FOR_FS. But in that case, the mapping
>>>> -		 * does not actually support large folios properly.
>>>> -		 */
>>>> -		VM_WARN_ONCE(warns,
>>>> -			"Cannot split file folio to non-0 order");
>>>> -		return false;
>>>> -	}
>>>> -
>>>> -	/* Only swapping a whole PMD-mapped folio is supported */
>>>> -	if (folio_test_swapcache(folio)) {
>>>> -		VM_WARN_ONCE(warns,
>>>> -			"Cannot split swapcache folio to non-0 order");
>>>> -		return false;
>>>> -	}
>>>> +	bool need_check = uniform_split ? new_order : true;
>>>>
>>>> -	return true;
>>>> -}
>>>> -
>>>> -/* See comments in non_uniform_split_supported() */
>>>> -bool uniform_split_supported(struct folio *folio, unsigned int new_order,
>>>> -		bool warns)
>>>> -{
>>>>  	if (folio_test_anon(folio)) {
>>>> +		/* order-1 is not supported for anonymous THP. */
>>>>  		VM_WARN_ONCE(warns && new_order == 1,
>>>>  				"Cannot split to order-1 folio");
>>>>  		return new_order != 1;
>>>> -	} else  if (new_order) {
>>>> +	} else if (need_check) {
>>>>  		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>>>  		    !mapping_large_folio_support(folio->mapping)) {
>>>> +			/*
>>>> +			 * No split if the file system does not support large
>>>> +			 * folio.  Note that we might still have THPs in such
>>>> +			 * mappings due to CONFIG_READ_ONLY_THP_FOR_FS. But in
>>>> +			 * that case, the mapping does not actually support
>>>> +			 * large folios properly.
>>>> +			 */
>>>
>>> Blindly copying the comment here causes fusion. The checks for
>>> uniform and non uniform look similar but this comment is specific
>>> for non uniform split. The “No split” only applies to non uniform
>>> split, but for uniform split as long as order is 0, the folio
>>> can be split.
>>>
>>
>> Per my understanding, "no split" applies to both uniform/non uniform split
>> when new_order is not 0.
>
>Not exactly. For non uniform split, any new_order value is not allowed.
>
>>
>> So the logic here is:
>>
>>   * uniform split && !new_order: no more check
>>   * non uniform split: do the check regardless of the new_order
>>
>> But I am lack of some background knowledge, if it is wrong, please correct me.
>
>You are changing the code, please do your homework first. Or you can
>ask. After go through the above 6 bullet points, you should get the
>background knowledge.
>
>>
>>> Please rewrite this comment to clarify both uniform and non uniform
>>> cases.
>>
>> Not sure this one would be better?
>>
>>    We can always split a folio down to a single page (new_order == 0) directly.
>
>Not always, the exceptions are listed below.
>

I mean uniform split to order-0, maybe above line misleading to non-uniform
split?

>>
>>    For any other scenario
>>       * uniform split targeting a large folio (new_order > 0)
>>       * any non-uniform split
>>    we must confirm that the file system supports large folios.
>>
>>    Note that we might still have THPs in such mappings due to
>>    CONFIG_READ_ONLY_THP_FOR_FS. But in that case, the mapping does not actually
>>    support large folios properly.
>
>These filesystems do not support large folios except THPs created from khugepaged when CONFIG_READ_ONLY_THP_FOR_FS is enabled.
>

Want to confirm to see whether I understand correctly.

We have two kinds of file system:

  a) support large folio
  b) not support large folio

For a), we can split large folio to min_order_for_split(), uniform or
non-uniform.

For b), normally there is no large folio. The large folio is collapsed by
khugepaged when CONFIG_READ_ONLY_THP_FOR_FS is enabled. So we can only split
it to order-0 folio for this case.

Not sure this one would be better?

   We can always split a folio down to a single page (new_order == 0)
   uniformly.

   For any other scenario
      * uniform split targeting a large folio (new_order > 0)
      * any non-uniform split
   we must confirm that the file system supports large folios.

   Note that we might still have THPs in such mappings, which is created from
   khugepaged when CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that case,
   the mapping does not actually support large folios properly.


>>>>  			VM_WARN_ONCE(warns,
>>>>  				"Cannot split file folio to non-0 order");
>>>>  			return false;
>>>>  		}
>>>>  	}
>>>>
>>>> -	if (new_order && folio_test_swapcache(folio)) {
>>>> +	/* Only swapping a whole PMD-mapped folio is supported */
>>>
>>> The same issue like the above one. Please rewrite this comment as well.
>>>
>>
>> How about this one:
>>
>>    swapcache folio could only be split to order 0
>
>This looks good.
>
>>
>>    For non-uniform split or uniform split targeting a large folio, return
>>    false.
>
>You are just describing the code.
>
>non-uniform split creates after-split folios with orders from
>folio_order(folio) - 1 to new_order, making it not suitable for any swapcache
>folio split. Only uniform split to order-0 can be used here.
>

Below is the updated version:

    swapcache folio could only be split to order 0

    non-uniform split creates after-split folios with orders from
    folio_order(folio) - 1 to new_order, making it not suitable for any
    swapcache folio split. Only uniform split to order-0 can be used here.

>>
>>>> +	if (need_check && folio_test_swapcache(folio)) {
>>>>  		VM_WARN_ONCE(warns,
>>>>  			"Cannot split swapcache folio to non-0 order");
>>>>  		return false;
>>>> @@ -3779,11 +3758,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>>  	if (new_order >= old_order)
>>>>  		return -EINVAL;
>>>>
>>>> -	if (uniform_split && !uniform_split_supported(folio, new_order, true))
>>>> -		return -EINVAL;
>>>> -
>>>> -	if (!uniform_split &&
>>>> -	    !non_uniform_split_supported(folio, new_order, true))
>>>> +	if (!folio_split_supported(folio, new_order, uniform_split, /* warn = */ true))
>>>>  		return -EINVAL;
>>>>
>>>>  	is_hzp = is_huge_zero_folio(folio);
>>>> -- 
>>>> 2.34.1
>>>
>>>
>>> Best Regards,
>>> Yan, Zi
>>
>> -- 
>> Wei Yang
>> Help you, Help me
>
>
>Best Regards,
>Yan, Zi

-- 
Wei Yang
Help you, Help me

