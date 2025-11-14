Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AF3CCE7B12
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 14:30:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A7938E0005; Fri, 14 Nov 2025 09:30:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97ED88E0002; Fri, 14 Nov 2025 09:30:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 895078E0005; Fri, 14 Nov 2025 09:30:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 749908E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:30:20 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0067A4CEF8
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:30:19 +0000 (UTC)
X-FDA: 84109447758.07.272217F
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf02.hostedemail.com (Postfix) with ESMTP id E14AA80009
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:30:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="N/7Z3Ji6";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763130618; a=rsa-sha256;
	cv=none;
	b=GXxNLPKx+pkUYTYWPwWR4GD98Eb0dtXMJ5sXgSW5IhsqnXjx2dP4qv1X0KzWzWq7Ro+kkN
	pGz41Df69KzVBw/Ru2d25x8UWTj+gIcqqeBOLtcBip2+MbW2VLc4+cHHasycy13huUfJ7E
	IwH+KLG+9YA8HCjGVO3vdFJ6x2roLVk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="N/7Z3Ji6";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763130618;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yz+WMFiipaC01O8j9YcIXObvaHmKlfTk+YmXdGTqyks=;
	b=HsGfofdw09IBw+wgIRJioceciHuQAMjv5bbfZj2s2yDjdjmHki2qxF0w8LJuI7INOpCo4C
	575jh20e/dbtNqMMUGEWJ1jQ2w5oaRIm1/E3qWWm4A9zVSirH6f3fowzAYIOglwLwYyOSf
	dpWzqCbQQgOE5iwCr7PwLZya2mTk3O0=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b71397df721so268885066b.1
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 06:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763130616; x=1763735416; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yz+WMFiipaC01O8j9YcIXObvaHmKlfTk+YmXdGTqyks=;
        b=N/7Z3Ji6ierXUtE+qbnk0GSQRR6tuyAjSF5nlX7+iWVYpV3bsFmMNMuMoeAlbXJTF2
         JNa39nNYd9/Q9xLEhRitEgT1ryYFGwqVtHBzcmcs/m1Y7NFnxVnaA9xBj9jvHiSk7pNa
         DGd0/0Lptr8GKhrQW8TYjShQaSAFctVcz2rkJl2qDltZepaA0Ojbv8DL8e6PXDfBhwOt
         0uKMcXJpwmdQHRnvyC70rPUgAfyQGavx+AfUKUukJzADGqjNzvMBFvtDwyh5bKprEZhm
         VtyQdzRrYnGsC/yoXWIgImJXwn1FLdL4dDvDLMPKrL/g8GJ0zIWX4dC7a5fKffBujCRe
         oaHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763130616; x=1763735416;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yz+WMFiipaC01O8j9YcIXObvaHmKlfTk+YmXdGTqyks=;
        b=SCLVgUf4q/+nzxaFnslr6bEP3+HQzAawMkZTCNpbQUWqsPt4himEswWbJfoL7sMxFj
         tq+yIY3hLPUJaryY/NKHWTxHMbPLQ9ecpUs26AYq12VEG4kzJIhomNhdIIs40ydzA5Ti
         xwYi0aWaBUkZHdc6DFnq3G9LIjBrTfnrCPNFdgMphK/tnkmZIfHtcsiaULzF+ZOI2XKq
         GVaLt4ITRPV8tk48q9SSH3UaMd4XucG0iLPaiQVZwD3dLaUDL9j/E0eFQ7CKOmgNfx2J
         dvSStf2oSrxn+5r0vA2ucUM8mC0Uim7EU597+KDNposjMxptBsw6c/N0XrH6IKI5BwZo
         10WA==
X-Forwarded-Encrypted: i=1; AJvYcCVnhBXCtWKhPSZnHXAJ83xwzuaSoebgTG6zhcMls10tlIZ6GeMHvjN6z8Oh5XanhXyAlIIoC3g8GA==@kvack.org
X-Gm-Message-State: AOJu0YwR4o/lj8MLUpWhr/jVklE3VT1kO+rOkDoSYI30xfup1CpE47Dq
	/o6OwoVW+g9Dpxclvq7jSKFdICSZfC/s0IuLLmfDMRLoHoE5DHvZoW5r
X-Gm-Gg: ASbGncsQjO7WKJ6JPxtAb7oMhvcGBG8b0PjLpPR4XHIwdlnmyk0yxslm6ipShG5MA9b
	zybjKDA5ss7kskdBnmgTu841O0qgWs9aI23Fi3Zm9fjjZH3/RsTZJG0CT0A97Qfh5axr3eQrtDk
	48l4/RgYtpbDbWcEGzeY0Eg+TVvK4hV4wEyNAVDUsUhVbZ9+BRdmL6Y7AQx17GReD9YgCCBeid7
	FSpjMCe9z2hd1Ezz/EahBCxw0/DfcjX2UEkDtDhkEx18sC2qezSDkJ1S4Df5aYXPS+MsOvfB6QT
	wkucRb2zeOIGvFCAQpgAFcaqV+0klUQe/jhxdiPNGDxwhvnp+vvlWFg2SpTXFQOeqOb6aMX5m3G
	88QUVQJhyl2loQL6HHPaC+ExAx3FBFMdbO8PiIt2FAk5b/7kB891X5xDUBSjRBI+9OiiVwLYCn5
	RdpJGJyN8flE4T+w==
X-Google-Smtp-Source: AGHT+IGT/RfUNWsmHcB+r3CpNno/n/LlNeIgAZSoXZJT6aGDOVeKyT4BXR9FJnFcsKJHu+C8w1pVdg==
X-Received: by 2002:a17:907:849:b0:b72:598:2f32 with SMTP id a640c23a62f3a-b73678ed1d0mr308312666b.42.1763130616034;
        Fri, 14 Nov 2025 06:30:16 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fd809fasm399704366b.45.2025.11.14.06.30.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 14 Nov 2025 06:30:15 -0800 (PST)
Date: Fri, 14 Nov 2025 14:30:15 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>, willy@infradead.org,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm/huge_memory: consolidate order-related checks into
 folio_split_supported()
Message-ID: <20251114143015.k46icn247a4azp7s@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251114075703.10434-1-richard.weiyang@gmail.com>
 <827fd8d8-c327-4867-9693-ec06cded55a9@kernel.org>
 <01FABE3A-AD4E-4A09-B971-C89503A848DF@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01FABE3A-AD4E-4A09-B971-C89503A848DF@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E14AA80009
X-Stat-Signature: zat6h7x5em4x6oz9dfha453g1fhxnf91
X-Rspam-User: 
X-HE-Tag: 1763130617-243083
X-HE-Meta: U2FsdGVkX192E/cERwTVsAxD1XucTsZMrydhIuR4D4nyTZRAEgBN96iJm+ff1UeZK/WkF93dNWEDhnbngPvZrhvUu4lTZAdU4uqA2ovMIf4lKfcCy7X3RAhJ4ek8QB/F/KtMNgMnBfeGj7N6kMo3hYg0dr/vJzdhfTGMzIyKYBafbQ3k/zQ7UfCELhrj3JJ/Ih+VYPDkAvOvjrZANFeGJcs3nlF3eQs1sJHIrgy2yCWTxIhd6u5BdwemSUZ2QnkLOZdbA9DJyo+4FdLgBfu4HE8q66R814XWDqX85bFusNpZF+BBncUJTQg72XMGEKeXTY2NJ8N5zl6flbneXDdOV0wYLMw2l015tNqUh4ed5OWMl6LWLKyZnmdfjOJFn1lFXx+HJ+gI7/nUsbBBOX0qDtvw3W8ehl0JS4yk9imJKmkPK+ZU+jww9AfUOCC49wgbF91NlDK61Al/qUrfNoEE7XLG1kf0IBt4+RR18S8voPQ2flqgbca7fAEp/sG4UQ/0arKvtA5G6hj9zBITe0U5VeRlaJvbAE2HbJcCp5SXhqsfVaOEtwT4Qv/EweweEj/DqWEHlSUikz9cFFpAnKYgT8y5nP50UMwpWnffBC34v22z8uzIe88/w5gFCQVuUcjdHM+d4u0mhEQWbWprT4hRE/KCSfyOSDmwDYF3D27UI5gDhiQIOKjl/7zxks82qTgnxg9svlC8kuAFssoxDl/HXeNXUL9CZTqwkeWXcCCplDkcedcBHa2/SVoVXaE9yqGuI1UW3gq+x/W4Yq58ZBF92q/V4mQB54xuf22mOmunb7JLFJJt2rBhew3ql9UMM5KuzV7X1NVGm+m4zZ43OSR//XUhCRJT20YhjhR1bFOa7k5M5BbpEtiARpCc86WCDyoHJSi3mMbr8G/qyLFrS93QDPK5uwgwNNfrErSmYOG8Tc3KUivFApQxmDOJSsShBn9aiha1ad0UvRidSbGPTiv
 CRcgSYtu
 Uz2aTa43GwfNLs6ZNgm038uR5wSJGSGn1ws9bLnzuD2dNx3II1ZKfsL9EMhHgJSUPiESV1Odaw4IulD9ROszj3qC1qJhDqCjIhRilVJdyRkBvaPL97WAQEAavr7QhMVrYeLmI6nQx+XQzcvIOWuag9kd67/eNlQOixnnochoayB5yUgbwg1+3iLaSy0XqQUZIa/JrTwVX/uY0cscaLAA+ZA0OwEuZJS+psQA31tk+YewwhYht889eHQUooXzjVEnLREGFzrsAlRNmE7Qvl9lk0YMLe1NJrOC8cMNvmCoPIFQ27vnEiVBbeC1JEZvZDDhjBP85LtLCn0oNYhAJ5aGZQtewLZolZA7YG58QuW2RCAVw9OEUnUSp74/yRI6T+PLMgNH2YjWJNDX42NOr3c3sNOYrUZNn3/nhM9h1qECY4Z3xlmxe9+B6XDri6PYt4pU9HqA0tcih8LT3e4OkIZR1dmE119o6EWAQvpctMSx88dii3nf7qiXpobV3VnpvNprD2tVj17S5OtVkmol6AvP0ztpGJ6TeiwjEuLWcE8SJHnxvDlcGbJbErFIcVRzOTsCOTOdX4ljTIf75/QSVrORxmQlA7HsE8jTXnVXfLvS5QXB7BjQkFN5XpClvURLFYuyLDehLAaaJ2xGhYV8MHmyU53PMH3IJPU0Cdr0htSxQk6IOmhYm2nypIiuuTPiDg9OeisSJGOYGEyyAK9C0sK+021f6h1v3kVncBIapUPZ62cOC3ZXRF97XXRpv0o7Aqo4uDywv+Rsg9V8871E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 07:43:38AM -0500, Zi Yan wrote:
>On 14 Nov 2025, at 3:49, David Hildenbrand (Red Hat) wrote:
>
[...]
>>> +
>>> +	if (new_order >= old_order)
>>> +		return -EINVAL;
>>> +
>>>   	if (folio_test_anon(folio)) {
>>>   		/* order-1 is not supported for anonymous THP. */
>>>   		VM_WARN_ONCE(warns && new_order == 1,
>>>   				"Cannot split to order-1 folio");
>>>   		if (new_order == 1)
>>>   			return false;
>>> -	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
>>> -		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>> -		    !mapping_large_folio_support(folio->mapping)) {
>>> -			/*
>>> -			 * We can always split a folio down to a single page
>>> -			 * (new_order == 0) uniformly.
>>> -			 *
>>> -			 * For any other scenario
>>> -			 *   a) uniform split targeting a large folio
>>> -			 *      (new_order > 0)
>>> -			 *   b) any non-uniform split
>>> -			 * we must confirm that the file system supports large
>>> -			 * folios.
>>> -			 *
>>> -			 * Note that we might still have THPs in such
>>> -			 * mappings, which is created from khugepaged when
>>> -			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
>>> -			 * case, the mapping does not actually support large
>>> -			 * folios properly.
>>> -			 */
>>> +	} else {
>>> +		const struct address_space *mapping = NULL;
>>> +
>>> +		mapping = folio->mapping;
>>
>> const struct address_space *mapping = folio->mapping;
>>
>>> +
>>> +		/* Truncated ? */
>>> +		/*
>>> +		 * TODO: add support for large shmem folio in swap cache.
>>> +		 * When shmem is in swap cache, mapping is NULL and
>>> +		 * folio_test_swapcache() is true.
>>> +		 */
>>> +		if (!mapping)
>>> +			return false;
>>> +
>>> +		/*
>>> +		 * We have two types of split:
>>> +		 *
>>> +		 *   a) uniform split: split folio directly to new_order.
>>> +		 *   b) non-uniform split: create after-split folios with
>>> +		 *      orders from (old_order - 1) to new_order.
>>> +		 *
>>> +		 * For file system, we encodes it supported folio order in
>>> +		 * mapping->flags, which could be checked by
>>> +		 * mapping_folio_order_supported().
>>> +		 *
>>> +		 * With these knowledge, we can know whether folio support
>>> +		 * split to new_order by:
>>> +		 *
>>> +		 *   1. check new_order is supported first
>>> +		 *   2. check (old_order - 1) is supported if
>>> +		 *      SPLIT_TYPE_NON_UNIFORM
>>> +		 */
>>> +		if (!mapping_folio_order_supported(mapping, new_order)) {
>>> +			VM_WARN_ONCE(warns,
>>> +				"Cannot split file folio to unsupported order: %d", new_order);
>>
>> Is that really worth a VM_WARN_ONCE? We didn't have that previously IIUC, we would only return
>> -EINVAL.
>

Sorry for introducing this unpleasant affair.

Hope I can explain what I have done.

>No, and it causes undesired warning when LBS folio is enabled. I explicitly
>removed this warning one month ago in the LBS related patch[1].
>

Yes, I see you removal of a warning in [1].

While in the discussion in [2], you mentioned:

  Then, you might want to add a helper function mapping_folio_order_supported()
  instead and change the warning message below to "Cannot split file folio to
  unsupported order [%d, %d]", min_order, max_order (showing min/max order
  is optional since it kinda defeat the purpose of having the helper function).
  Of course, the comment needs to be changed.

I thought you agree to print a warning message here. So I am confused.

>It is so frustrating to see this part of patch. Wei has RB in the aforementioned
>patch and still add this warning blindly. I am not sure if Wei understands
>what he is doing, since he threw the idea to me and I told him to just
>move the code without changing the logic, but he insisted doing it in his
>own way and failed[2]. This retry is still wrong.
>

I think we are still discussing the problem and a patch maybe more convenient
to proceed. I didn't insist anything and actually I am looking forward your
option and always respect your insight. Never thought to offend you.

In discussion [2], you pointed out two concerns:

  1) new_order < min_order is meaning less if min_order is 0
  2) how to do the check if new_order is 0 for non-uniform split

For 1), you suggested to add mapping_folio_order_supported().
For 2), I come up an idea to check (old_order - 1) <= max_order. Originally,
we just check !max_order. I think this could cover it.

So I gather them together here to see whether it is suitable.

If I missed some part, hope you could let me know.

>Wei, please make sure you understand the code before sending any patch.
>
>[1] https://lore.kernel.org/linux-mm/20251017013630.139907-1-ziy@nvidia.com/
>[2] https://lore.kernel.org/linux-mm/20251114030301.hkestzrk534ik7q4@master/
>
>Best Regards,
>Yan, Zi

-- 
Wei Yang
Help you, Help me

