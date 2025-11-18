Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47092CCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 03:33:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 822FF8E0003; Mon, 17 Nov 2025 22:33:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FB168E0002; Mon, 17 Nov 2025 22:33:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 710458E0003; Mon, 17 Nov 2025 22:33:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 58F378E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:33:44 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 08B6A12969F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 03:33:44 +0000 (UTC)
X-FDA: 84122308368.23.96152BD
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0CB171C000A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 03:33:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZWmCFspk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763436822;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fJFjVQtqhjXIrjzxkzO5EFSaN0W8b86YfItCWRyj/Ug=;
	b=PhNgnx2DgOjOIpjGDjF7Pnjj+N8E3ftZTP99KxQKVNiGMQbK0cZY0fQbgceI6rhvfxU2FU
	NmJLgEtYjZVULGZ3meR45QEYPXn1fxCuKhgncCKXjrvGW54pEms5kO7hrA5XBkp4Ym/lgG
	YPtwFpSG+XSnEN4zp5xIQjOjJaelpfc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763436822; a=rsa-sha256;
	cv=none;
	b=H7nUUwJ+5FmOQVRhL9LtvkTmHNGdkJPxrzG9lDE3N+12b27iZXXNkLAG0dlsWpnidsKAtu
	jzJuK86nkSF8wLHb+q1qC2bXJ4R5FAgPmSEdkJgibz48O0stFukTjNwO9bz+odTv8qE0SP
	dJyW+s0GWbCUXvTbZA4bGgnK0UTeAN4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZWmCFspk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-640bd9039fbso8549056a12.2
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 19:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763436820; x=1764041620; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fJFjVQtqhjXIrjzxkzO5EFSaN0W8b86YfItCWRyj/Ug=;
        b=ZWmCFspkfEaC0eq3EJJ3miRdfPyiXXZnmsdtmmt+/xtYz/usjvzyXSkN+k64VjQAxD
         vQI8JI9Js7IpcM7Hqzt5p4GuNb66PNdI/k8qi1lGCiFpVvw4mYyM4/l3eKnkj0HMd+IJ
         irtf3iKXuc69vwdKImJD2Dx3gtUuYhabuzz7Y65lZMzxdj6khnZwPUhehsVL5Ozs59Gg
         YwwSJDO97Dmv4aZhoQgbQZHeZ2CoB9r5KuQ26i2Xlzw6mUyr0bERprZkp0TuZI6Mv3rU
         iWphiUkeT1oUZWl2ZM62mHL29Puv7jPKnymf+Am2L0VgTQDmao+w+O9D9gt76hYzYiq8
         +eRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763436820; x=1764041620;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fJFjVQtqhjXIrjzxkzO5EFSaN0W8b86YfItCWRyj/Ug=;
        b=cvKKYCGm+VKMr17vzczNLC3+su31S58yVhSzWpbFNw6IO7rnTTjaYqxQzwIrCKb+Iw
         q0En0xy6tta4sC6iVhn7OdWLaN8skACrcBOR9x325RNi5MrkL7dGsTe//6/2nKdftpj0
         2gAEJmHFkoScRRcGk5HcMIOO86f/85WYUSjCCRRC6IFRLGAb2iSXv9mh8Re4c+rHwFbM
         LgAMZHBOikBQYWxuR+nu6dBBiMyEHOWJdQutL99wEzTrdUX9/oSfmyqegIZ6Sfi0lXYn
         MBY6kesLOQofkiVxduj/OIsrzsP693zyk7f1f80Jz/l1msSf+EkbtwTpcYkHF6Syk+fr
         Uryg==
X-Forwarded-Encrypted: i=1; AJvYcCWiNCiUFnKHUJUiwdNxPWJO6OBm+8XBg+OetyzdDumb801Y8md7jXfvI21fcKLLkpPZlfffS3CMdQ==@kvack.org
X-Gm-Message-State: AOJu0YwWqcYuyCpr+qX+YWEWmxbpa0Wa8AJp95ZeMPt+UkLZWSLKWK1m
	TffrWt+GkOs6iRATRkVyxxseO1PvdqwbBNURN8+0MzmpiJa2DbSj7okB
X-Gm-Gg: ASbGncvMn62MsZjzyexX+iYsv7PQJzAeo1D9ev4KKM9WyrJjcsQGvzFLKRtoWgCM1Aj
	EE45P2vnyK1CjcpOGv0r2ydES0kMh01wKZv+aYbGYcfIaYjJtBgFpv0NyAJpqj8RBX762QUbi11
	fIbpZKRE1NivumwTq96SWcOw+CfxAPwvy/AH1cRD3/quHPAjvdtf7sJGHpLnk4r9u6lGmhiHWaU
	ctaX9bcFu5oIaRoyjOq6sOXkmSb6KODmXsxMr/+wn4It5kGMdEJfNMGyL+2MCvzFyNhQ3xf2KUe
	5jDnkssaTmVIP7A3XZNDo0/U3OHfeJ/oWSs9nTiuyJGpTN8rKYwIlhNXW5Gp61k9v0CiwocSOkA
	1yp3ZZXNg8CXUQuAqTiUsDSbS2+93rF2vQZbcFWZhucA5Zms2E8q8nP9tND4D/SgtQiKSKhC5WR
	5qtVLMrMAi+P8HM2ckzPo0MWn3
X-Google-Smtp-Source: AGHT+IHTUk4Vv9LNvUCEo/GqD81e0xL9Eb+a13B3sQ+ehWlvAbMcWg6aMmudlfcM1N/HyFcja8gL1w==
X-Received: by 2002:a17:907:6d22:b0:b04:32ff:5d3a with SMTP id a640c23a62f3a-b73674d2391mr1400688866b.0.1763436820172;
        Mon, 17 Nov 2025 19:33:40 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fdac68dsm1238323166b.62.2025.11.17.19.33.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 17 Nov 2025 19:33:39 -0800 (PST)
Date: Tue, 18 Nov 2025 03:33:39 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v3 2/2] mm/huge_memory: merge uniform_split_supported()
 and non_uniform_split_supported()
Message-ID: <20251118033339.7rukw7vvjvlbj5jb@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251106034155.21398-1-richard.weiyang@gmail.com>
 <20251106034155.21398-3-richard.weiyang@gmail.com>
 <20251117012239.lqm33uu4vl4y5zqc@master>
 <337CD281-F5B3-47FE-82C3-ECB236450F60@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <337CD281-F5B3-47FE-82C3-ECB236450F60@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: iu5coikw1yrkwsrrfk1b1ymeyc695t3z
X-Rspam-User: 
X-Rspamd-Queue-Id: 0CB171C000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1763436821-651649
X-HE-Meta: U2FsdGVkX18nJ6mBEfBnKBkNFkH3gJ5pqm5Sx19KPtvPexY2IjVW7PbEu9DbrUGv8ncbeDE1vZVK+JqwPm8pebGPfmGfyO84oycADvhSHz4McddrNU8faN2QBjsQfvZ3ZtRpQwn53bM8jZxhx4JO6g9392F6Sh6j2uKzaHJAlEFQsiJy1wVEVEgkMq0VcsNqWA7IYD0iRoTo8Alpr6K0SRViz8In2RIlVuTDiG/HstQc9QdQq5/AxmESvZoYMtd4XiLCkseo1Gtld3/XuB2mrZ56lC07Lc1nhKc95rgAxHl9xaBzfveXS/V2tHmpUCLLnQ3YvZpt2rhs/a0YN8riC7fmCegOpLQI5myLDZ2hM5+NlIRLzG4zFQsW/HmDoTyydM1Jdbv25KO4A15oT0OnTpZOcuXN7jV6wmYfEwLh7Pji9krxjUI/qUxtm/uVocXyCGkW6hdJ757PHWfPmRlgXKFra94qHAlajJBtlqYf5e07fRi2WGhA7Ovx57uKycqhcvigFIUBXSf4NCKprDEG9GytFCmm/oeFj7lWO0d+LAERvZXzjMmXe566Gk/oz7t6rMyecFsFlcJVXIblZ7hSIAqclRNYIQK2lsQPvISuf+gLqFVJqWScSScXP1MlODZNJ9ve+5VZjO8F8nRSoKLfwitxMbpSpelNZQLnsxc28LewARuGbJptbBgEaGBlgI6fLyyU7PRpwDT1Cqv4ltlCz5Z/ypGzcCatbzT3cLFe7iSnRwGMylEcf2iBLwhMRNyOLbqAff/JseEiOBmeTHmzgZmRMtBGRkYTyaH8yibIYsydEv/i15AhZfAlravO9Kx2l9zjXs058pilzUjSYMY2nBbvIYdqDHY+q0IWjlATFbadugq79TzJYKmIc0GGIDNPRYzxT23BcpwCvMfCCk9zaOOytB6YdnEHTWwUsQd0SH7C+8kW643lYegDIcq1Azud35v8Lgjh8zmpQadEQTu
 9GUQmlnc
 Uh9i3A8/iMyFXg9CjTTRWsDgHAYzk10wbJ9WuyNKxXWxTjsknTCplCQY3lU3oAROu+QRA6/aPVbAjPCGXNaU/umwf9TG1r/PA1fcKgq5MUL6hU4nMtFkoMxt2Q2ipfJoMEZWRnRu7aMOATCVFz8gnW8DRGFskScJSthxvkwgk2ZCyyyvOXoTtfPuj7xa0F3dZ26Ok3ejQ7C/rIk1la+XADWBDSXv4psOfMspcPgaAnsj3ZfIcgIj91K0ILCkdtz75unWMIqVLHg6fP4itWT0JmxyUXxVN0zxBNTIxsHcRTU5mAomzst2D1wRnTzKRheC7SQ1yGy/SFgh/z4PFU9VOwYqhL9p319UVQyg4RszhVxd4DFCxbnWJBjdVr6H2+q6w0urlXaE+jG3WL0qSqkErOQWnv71TSpw2IE32aAJBid0nZbbQxuCDblF7XqhQx0CDckM5s8kxl22GSQUS9anRQrll8cbIbV/U3eTNtb12Ttocb+aPcRXIq6+1Jgukerp+MwW5cPG/M2f/T/cFCMYprHPp4KEK3PO26W5KPZupcyQunAyPYZjTBHvnhEVmZxXnXVSdN7z9OPRrsKKTC8GDFu9iS1YARv/HdnNd5yrkwmsjtPp9JaG70ksY4Et7yD1kzX7gd9ZNhE7hDL+dkQgmPgjX2PKf0qbd6BMCoHJcYOjlPA0f1c1P6UdFzkYLG7TPxfOZUa1CVGi48GQW/wwE9wNL6c3e9iIN3j02OdY3e9scC81Gql3A6+VaRpted0F/GK3HSKgCuFf/pld9O8NnHmUTqOHBjGXFoB9923tFCms3NaMNMG6WNtv1FrzEX3v7JR0MoSl1FgT5pHyHOmjF3kb2aqOJplZ+bq1QGnxlBzTvC5KEx+yP7BMvDukJO6/GJUy77MroqhVNy3BkOYoIsqEUTwOA2IcTDHBPC0TvuCXXp7PehiM7uT+FRI7QunwgV0kRbDbTFCrAtYfHsbvfdMXDAQUp
 WF4UWqP4
 3v5MwKWJZmuXwvLLd7Xt/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 10:56:39AM -0500, Zi Yan wrote:
>On 16 Nov 2025, at 20:22, Wei Yang wrote:
>
>> On Thu, Nov 06, 2025 at 03:41:55AM +0000, Wei Yang wrote:
>>> The functions uniform_split_supported() and
>>> non_uniform_split_supported() share significantly similar logic.
>>>
>>> The only functional difference is that uniform_split_supported()
>>> includes an additional check on the requested @new_order.
>>>
>>> The reason for this check comes from the following two aspects:
>>>
>>>  * some file system or swap cache just supports order-0 folio
>>>  * the behavioral difference between uniform/non-uniform split
>>>
>>> The behavioral difference between uniform split and non-uniform:
>>>
>>>  * uniform split splits folio directly to @new_order
>>>  * non-uniform split creates after-split folios with orders from
>>>    folio_order(folio) - 1 to new_order.
>>>
>>> This means for non-uniform split or !new_order split we should check the
>>> file system and swap cache respectively.
>>>
>>> This commit unifies the logic and merge the two functions into a single
>>> combined helper, removing redundant code and simplifying the split
>>> support checking mechanism.
>>>
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>>>
>> [...]
>>> -/* See comments in non_uniform_split_supported() */
>>> -bool uniform_split_supported(struct folio *folio, unsigned int new_order,
>>> -		bool warns)
>>> -{
>>> -	if (folio_test_anon(folio)) {
>>> -		VM_WARN_ONCE(warns && new_order == 1,
>>> -				"Cannot split to order-1 folio");
>>> -		if (new_order == 1)
>>> -			return false;
>>> -	} else  if (new_order) {
>>> +	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
>>> 		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>> 		    !mapping_large_folio_support(folio->mapping)) {
>>
>> After re-scan the code, I found we may have a NULL pointer dereference here.
>>
>> We bail out if folio->mapping == NULL in __folio_split(), which means it is
>> possible to be NULL. But we access mapping->flags here.
>>
>> Looks there is no bug report yet, so I am not sure it worth a separate fix to
>> original code.
>
>Probably because the race is small, but a fix is still needed.
>Likely commit 6a50c9b512f7 ("mm: huge_memory: fix misused
>mapping_large_folio_support() for anon folios") introduced it, but please
>double check.
>

After searching the history, it has four related commits.

I listed here in timeline.

[1] commit c010d47f107f609b9f4d6a103b6dfc53889049e9
    Author: Zi Yan <ziy@nvidia.com>
    Date:   Mon Feb 26 15:55:33 2024 -0500
    
        mm: thp: split huge page to any lower order pages
    
[2] commit 6a50c9b512f7734bc356f4bd47885a6f7c98491a (HEAD -> tmp)
    Author: Ran Xiaokai <ran.xiaokai@zte.com.cn>
    Date:   Fri Jun 7 17:40:48 2024 +0800
    
        mm: huge_memory: fix misused mapping_large_folio_support() for anon folios
    
[3] commit 9b2f764933eb5e3ac9ebba26e3341529219c4401 (refs/bisect/bad)
    Author: Zi Yan <ziy@nvidia.com>
    Date:   Wed Jan 22 11:19:27 2025 -0500
    
        mm/huge_memory: allow split shmem large folio to any lower order

[4] commit 58729c04cf1092b87aeef0bf0998c9e2e4771133 (HEAD -> tmp)
    Author: Zi Yan <ziy@nvidia.com>
    Date:   Fri Mar 7 12:39:57 2025 -0500
    
        mm/huge_memory: add buddy allocator like (non-uniform) folio_split()

So I think the fix tag should be [1], right?

And do we need cc stable?

-- 
Wei Yang
Help you, Help me

