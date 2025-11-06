Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15140CCF9F8
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 01:46:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 574B48E000A; Wed,  5 Nov 2025 20:46:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FDBA8E0002; Wed,  5 Nov 2025 20:46:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EC358E000A; Wed,  5 Nov 2025 20:46:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 29B2E8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 20:46:57 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C13D288D8E
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 01:46:56 +0000 (UTC)
X-FDA: 84078493632.24.B93AE68
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id BA227A0007
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 01:46:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WFtXd5jd;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762393614;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+PtyHAUkAkUIjTGIHF+6nDmZmOJG5U/8sKfOOny4JM0=;
	b=NrmaCxGVaRQ3rx2zXikP0iKrR5JAHx13Lpa9y2GmuVuGcyhGtAwH2ycZxnNnONaRC7x9iu
	lUOoVvvMJb0AZXLyNLGJyNxb2/C/vxIuOGRhzVivJWiAer1o9dqyvHeaASOXZ52MyiX52m
	C1DiMATzvRGcN2WmwdkNjcdcV+fPz8o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WFtXd5jd;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762393614; a=rsa-sha256;
	cv=none;
	b=cC4ZvAQTXbxjcjb7y7SBJnf8ghc+3/qG8nUPqLTfMJhunz0hSu/j2+jDuJ3aqvacYvjgc/
	Zem2GgCFOpZxMxCyoGzgnwO8BgIyYv4Wv0NKymRGWp6XOQxYRi3AG+yYnBrZVM4YQZrAWz
	dfkS5tb9J896A8BREF/mcplgxZRPBjY=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b710601e659so83428066b.1
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 17:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762393613; x=1762998413; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+PtyHAUkAkUIjTGIHF+6nDmZmOJG5U/8sKfOOny4JM0=;
        b=WFtXd5jdk9XAd6lwHSQz9BDkZO8HSwVnq9olOdbugfn3KQEJz5W3pvxScFBQzU3o99
         XWz1mqnYuNznkmJZ8a/4sN6Aaqbt9yJDlxzz+KNHPllx+LlFv2aSrGICGR2Q9ZnmvdWQ
         vMC4rWtFYnGTpYHS1RcNXy3gnL539zVDVlE8SfVGIWsHEuEYs/4WpvksTtZL0I6MfArh
         PIYrp3NCtzfgIaZLHnr7ULvLYnPAv6Owgt49HmQ154U0jEMA3KtQMv2E7Wa8fxyTwMpd
         +R61dI8+COILUtyzv7aJ9kgaeHVPIC4B77pzFuiw5P5KmEWD7l51ZiGFGOg1vjlKm7qw
         bVZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762393613; x=1762998413;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+PtyHAUkAkUIjTGIHF+6nDmZmOJG5U/8sKfOOny4JM0=;
        b=TnUnpSRT0DsYSoXpq52Rv/czcbQfXYFToeOKb1kCqOy4GYUBxgw4e7UoGfpNWC5k2n
         htnZodOjbsH3hAgMDz+RNOf4tmEiV/sa5nOTrS2XH/IVtOT0vlOA8gc4dGWZ8pebp/i+
         MKgWCJyg/uvEDhBusr2lcLnyc/4eEg/4LRR0BwVHfLHNC1jayrhyrPyIf+nB8qZ6CNTP
         tR/Z93WoifOl38aUAWteo+6gK67vu0C8s+hJXjXqlfCiOJoO1vxeRsUjZXqrgbA/GKX4
         CXfUI5Rj2NpLYow4TtXjMQ2tqyrrok6xm8/7YXRMnWMVNjEkEotcMcgNIsBmMXVqANUc
         u+YQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnFLs4G4cHuvtVEkV8Ho3z5KBzK8agc4rSy/FYnxHATUAbPpmmT9TBEM88lOSCPwb9kqYXIo7yng==@kvack.org
X-Gm-Message-State: AOJu0Yw2sJ9qFrGGUe/IAEgo3d8KrJLAVqLNkz5tgJcKwAd3ZJxhxfjl
	poQ7bwIYYdkXqGjXjrrWw6rTsKPkgVvAq8Ogv62MF3NVuIlAZ0M/lDsS
X-Gm-Gg: ASbGncslgZYPJI4G+e5Yyd+9DiwXArRpGGcQLP5YJintLgjBG9hSg/GQ49fMfbcUhMj
	qr6YXfdzZDFd6ljqbLHM50YJl3LjwxSHCDz8nWWl/WwMypiadfhpRRUkXp1+Wrrp4OUa7EoWW7z
	KQWKl4QMHNz+Yhf9VWipdjOjNvmtR7o8fJMy81QpSmyXESI7WA4+9dvx+VIaDJmsR+0x99SA73Y
	/PYkEgc+XVA8zxJkaj2+vy4995SG5r3+a1IhYdmUYGP9gqdqX1Rd7ZgAiLDuWzJTDJFCA87Ddoe
	lgO+mBDrJQEbQpnmrbzqRHmHcxVwG/b/Vpgcs2RASY/fKrIU7RJreQsc5AcTWNSpdBNJ8wcTPKN
	dpxt06vyHsSIjspQ7fCn8TVZ0zYB4WksHkuXvm/1F+uwF+vBg2pnSzK0mRfCqC7fmyrSRjKo2Jd
	1DVkttSscp33LpogQlRJSd
X-Google-Smtp-Source: AGHT+IEeFxDwWNIVcrZW6Cho6Wk5F5XNryY3iD7qF7EsceIuFqYEUt+jRK6uRbVcpjmsnviXaOIsuQ==
X-Received: by 2002:a17:906:7944:b0:b3f:f822:2d9b with SMTP id a640c23a62f3a-b72651557b5mr606939466b.9.1762393612977;
        Wed, 05 Nov 2025 17:46:52 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b728968208esm91578266b.52.2025.11.05.17.46.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Nov 2025 17:46:51 -0800 (PST)
Date: Thu, 6 Nov 2025 01:46:51 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: Re: [Patch v2] mm/huge_memory: merge uniform_split_supported() and
 non_uniform_split_supported()
Message-ID: <20251106014651.yrijaszlstec3e52@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251105072521.1505-1-richard.weiyang@gmail.com>
 <A4842E31-E15B-4E96-A313-F8C9F6A6B424@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A4842E31-E15B-4E96-A313-F8C9F6A6B424@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BA227A0007
X-Stat-Signature: 3prxrxcgs9nrk9r3t1q9w1zyz8n51jhu
X-Rspam-User: 
X-HE-Tag: 1762393614-923013
X-HE-Meta: U2FsdGVkX1858vytbh2ScGZet6RdLrNgVnyihvWHRK4G1LdsZJiDWkqBfiZhStTgpBGJAtn/TNELL9RXOkkdIBEZI78HN+zW8gRVe4WmH6LrXNOq8a6IsoxIsQGMwpJRSJT4Z1+eEqEuo/yKh6IfUG+vFUr6IQO59377jlLFc8K6HOIXyWM0aKGn1mreF4K0rJn3CLltXBttq/2r7xElkrjF0XWP8LOvShzfzR+/WgMePg9k+kBFjUUCW461WB+pGlZmIB2fUHtswQPjxkVGhXuEXPFdcqK7lGYhRyuNlRr+Nvcd5njPt3VW4yguTEiYjSgbnc8e38tN+JJtmRXB/av2hyAGPnaqLvyoa/zmYCQRJlX8ZRFBeNMyATx/k1/ttzYDVZoHAziR9atrx5YDhkJ15HkH6GnWGzLyar/5nbsFLpdOKOVW96sQqQGZPL0fPcFjpbHZRxM99oSFqQh3DFxZ/ZeMOl98F2mz3hcMjD/ux9lRkVVpIddNVFNBe9DC7Y9jMEWgeziWEqteKPzkZchprnUzVEMZaW9UAN3/RTqeRgPYrwP6htxfy7QvyAJiRaAgrDmHSxoP9aYiOekFgWWJm8MY7fQg/WFwgKPDg0MJzfkwrX68zQzke15CRAYyWSFf6hqv8Deazccu24FuSoooFMoKEhYyqkV562veSicu6NLgx0jRA8LK4pYcePZ/mq2Aebb+d/EQLRBx/rF//CmBLoPJLQd0ZBq/oVHnY+UWHEob/jm5q30NzDk3CFgNGaypsiFVISX0aOzMiDWV+dogPiY9xgixKAS9qJuMhhoq/++zAXvqI6pD+uZrdMsCWYtYEo9lj/9hR1Nwbu6mZg29KWgzohrlznmIuA/E6E8clptNQD/QcB+fz6wOLYp7IqmmG18aYHHF/O+ZdmQWgqCX+LHHoz8I8S8M0PQBh0Ao4j8hLZ1BwgW9RCmUJJ+Kmp3L22U9bTfV0okoaK8
 4XwYrWi7
 ntuzy7KgMZdeDmO/F6vUNf4H+U6oG49G5lytvxXWhnJIMA2s1iQ2FD3lEePIVV2QuAQovdQhSnstlSC2lCsCoI7x0G/kk1BkBxSU1JLkWCsHF54N2zrFK1906zzzmQucwtXCUtGuGivdJXQCdXrKtaqCEtQWVI2P7gZkP6AtTbwyazmsOoR9sx0MfgCrfyEaQhdhVfkiatKkee5/gOqOznaPQivs0FAeYaYpIwNTtJzlcfPJofFrgxrz8LCbCAaIZ5tclEuvbx450L0UbSkawRYO40ttKdha6R+3WYjHm+wKd87gzqc8NUesoqFKtHFnpMjaj2cuoyYx1SXPo7FYkfyZnWBD6WD6GqcFknd24VfwrAe5KSoFfFI4K9QTFVn7ugPkx0cufRyJDjIWKIUQyKQ5MZh++1flVtNydnBKJeCVcKKCFzkFcDcJDYyXvbf4/TrCwMxKvfOoB+WyyE/iwovlDrU1qq+mO+anKrxy0USO4HCVDnm+UOosH3xJbkm+m/vISxlnNFyRjOPyniT7Ac/ZgbF+fPJVgUkENnNVFYLwmKBlu76LedzHWJvt3Rf8RkB/wfpoGktxsTqd2Y4pgVzQqwmG04cRzw8Jkbyam9LkL6BFZrCKVjcBwJ14b+a+PjCfoeO9tvRMxaBHySG0GV4Aorx3cGTPqq87+FWEfzh/ZgmdAPclGLtlSr+jDRffg5Up6VhhJ2AdidJqo1MYLqrzdjqcYCbed/hS7lRdQ0ERnAhx9gNk6wBAhU168pKCMljHB7EK/WoY0nxyzr6jvzIU1YQgv9QNvkguNtdB2lttgjQ7RBlbJ4SYMT+S21b7Ej8Bw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 05, 2025 at 11:41:35AM -0500, Zi Yan wrote:
>On 5 Nov 2025, at 2:25, Wei Yang wrote:
>
>> The functions uniform_split_supported() and
>> non_uniform_split_supported() share significantly similar logic.
>>
>> The only functional difference is that uniform_split_supported()
>> includes an additional check on the requested @new_order.
>>
>> The reason for this check comes from the following two aspects:
>>
>>   * some file system or swap cache just supports order-0 folio
>>   * the behavioral difference between uniform/non-uniform split
>>
>> The behavioral difference between uniform split and non-uniform:
>>
>>   * uniform split splits folio directly to @new_order
>>   * non-uniform split creates after-split folios with orders from
>>     folio_order(folio) - 1 to new_order.
>>
>> This means for non-uniform split or !new_order split we should check the
>> file system and swap cache respectively.
>>
>> This commit unifies the logic and merge the two functions into a single
>> combined helper, removing redundant code and simplifying the split
>> support checking mechanism.
>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>>
>> ---
>> v2:
>>   * remove need_check
>>   * update comment
>>   * add more explanation in change log
>>   * selftests/split_huge_page_test pass
>> ---
>>  include/linux/huge_mm.h |  8 ++---
>>  mm/huge_memory.c        | 70 ++++++++++++++++++-----------------------
>>  2 files changed, 33 insertions(+), 45 deletions(-)
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
>> index 381a49c5ac3f..db442e0e3a46 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3666,55 +3666,49 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>>  	return 0;
>>  }
>>
>> -bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
>> -		bool warns)
>> +bool folio_split_supported(struct folio *folio, unsigned int new_order,
>> +		bool uniform_split, bool warns)
>
>For this one, David suggested to use a enum
>
>enum split_type {
>	SPLIT_TYPE_UNIFORM,
>	SPLIT_TYPE_NON_UNIFORM,
>};
>
>in a separate cleanup patch. It is better to send it along with this
>one, so that:
>
>1. it will be easy for reviewers to keep track of both changes,
>2. it also helps resolve the dependency issue, where the cleanup patch
>   goes after this one.
>
>Thanks.

Sure, will add it.

>
>
>Best Regards,
>Yan, Zi

-- 
Wei Yang
Help you, Help me

