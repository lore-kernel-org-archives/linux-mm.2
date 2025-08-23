Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51D3CCA0EEB
	for <linux-mm@archiver.kernel.org>; Sat, 23 Aug 2025 01:29:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EC866B00E9; Fri, 22 Aug 2025 21:29:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79C9F6B00EA; Fri, 22 Aug 2025 21:29:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 664E16B010D; Fri, 22 Aug 2025 21:29:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 51C716B00E9
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 21:29:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C9884138C9C
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 01:29:57 +0000 (UTC)
X-FDA: 83806290834.07.DD75755
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf12.hostedemail.com (Postfix) with ESMTP id F036740002
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 01:29:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NYGehTJQ;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755912596;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KN436an4cyg/kh8RbzRxkUUwckCMwEPPW4Ijt1oCsdA=;
	b=kKmHRxdh2rW0rgMouTTmCdvh08LKc3JbOTPzqUddWO5/aQcIgXDCASDHLL5o74qFrXhh5u
	3h7Qj29y9sU13rcwenGTdkBB2lsdrvxxABiUUDEA4a5kvyACRUuQR9iB/fOQNX/QouxenA
	EeXE6T9IOO7UIs9uEwpacDgs1vugeAc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755912596; a=rsa-sha256;
	cv=none;
	b=2iLZzfJd7QyMULh5b2nERAT2znIUVUOW+pEEsdENYF6aoOsx2uu2kHoRnHoRvxdC64hIVB
	CvffpM8Oo2SUBtkxnC6aeXJBEp4I6y1k9EQxXEysdNVlFLfC6wO/hJ4VApiJQ0QApk/wmU
	DE7R/qT/KjjQR+6WxxLbr2k7bLJ6SXg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NYGehTJQ;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-afcb78c66dcso385144966b.1
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 18:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755912594; x=1756517394; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KN436an4cyg/kh8RbzRxkUUwckCMwEPPW4Ijt1oCsdA=;
        b=NYGehTJQiA88fQFYd7pY2Tng1yvCymFT/xGw2OyZcrXjVUngAG0B0KoUM5NkTnJjYh
         rZRot1ju6q8G7+8An+WTVeLPUt5hz7Fz8FfawbzXWxITw69EDScHuzU9tYX0f2jZkPjO
         ueql0JrevZL1lqWFR6upj4YCO4eV7RjRtVedQzeVHJiiryg3OV7QSAvPSWk3G6z416g0
         mopJIYsHi8awfrRWKSk8abAYAsXk9UqBs22gn6/WyZ4i1Cgp3If9KIJd7v9BIfMWS76f
         S+Q+b6WZ2G8ZNmXni+p2BZsWiLLG4bpOABlJEnd8m+zHYtaLSzsy72cPxOctNSJPi1VM
         o+UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755912594; x=1756517394;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KN436an4cyg/kh8RbzRxkUUwckCMwEPPW4Ijt1oCsdA=;
        b=Y+7PX6owPK+TvT44HpScs/skzKnWD/AEfFUCeQP3mMhxafjmi4cF003ZyTDaMpseR8
         3FdoEABqtjjxqm2tfSIBzhQXtIrp187VwZARAwFbc8QvWeHc1+pnN15S3gSlAirOzBBi
         aTf6UEo0HtwtUFDpFSCNBEEkmGr8z8C2k5/jvwplBzpNx7VLLSkw8H/NSvwAjEUijkph
         pS17ke4WQQIGjODvNteuTk3B9CJd2xSHW2Y+Id1Q8KTWIquTAiZLU4736R5D9UurAkM9
         655KEXLOy2LavHVPMyTJpkSPVwmR3yFmk1R/BYEws/i2+AUZyeoLe3sLsI/Ic+zmsFZK
         Lbvg==
X-Forwarded-Encrypted: i=1; AJvYcCUs+BbIQnVIPfp6zwN5X/OAmZkEHn8td38+BQDEsk58WmCydHJJAiNDK0/dMnTBd3Ov9pYrGr6/HA==@kvack.org
X-Gm-Message-State: AOJu0YwM/fMMRJqN7bTTGsLhmf3U3Rn5fbQOKqqi4lN/r2TkjQH67zbu
	/mVKEN+ONdG8qn1APucV2RENds8HAWsjiSO/THRSBNG7kiaRd7G3h9Is
X-Gm-Gg: ASbGncsqDzfTd3ClbqqEBqrk05aK4MD0d9uagu664i14fKXDM1P7WUtezK6htm3cSL7
	aLRRRuGWf0aVe0KIooKb7zujIwBRVgUmd29dJJU1DOlvGcIvXShTdp1098UyLYw/j86Ddts6Kvr
	23Fjqogkn6N50FK8E7gOZYwwhWgcRK+tChPI5d8ezibQ2dxwjJi+KjT7ctqR4NRhd0r1U+NEEt6
	hNreeCU+n+Dzp3dX4WNqyJCtrl+k46R1MnrOj3x6roaXG+AfrzmPCRvlEEkhuEwo67vQ20UDvOj
	slQZRhYrofeiMHvesX+dMtGXm1QvjKOa+Xzs9Fa0R4d7seNdW4XtAArGs6wRsDyUUlnb3YWrFZ+
	vjArKRfeF+wqUU7N91w8297wxNQ==
X-Google-Smtp-Source: AGHT+IGwiQlMtlwhYU6c6Jpd6fvq0eyeiYuF/MNEi+zrWiwOkFs9MPE6qPvzRUsvh7G0hZYVa8USog==
X-Received: by 2002:a17:906:c115:b0:af9:d300:c60f with SMTP id a640c23a62f3a-afe28f161c6mr411116666b.18.1755912594089;
        Fri, 22 Aug 2025 18:29:54 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe4937a15asm71906166b.115.2025.08.22.18.29.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Aug 2025 18:29:53 -0700 (PDT)
Date: Sat, 23 Aug 2025 01:29:53 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, baohua@kernel.org, linux-mm@kvack.org,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: fix the address passed to notifier on
 testing young
Message-ID: <20250823012953.cw2n3j7nuqfsle2j@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250822063318.11644-1-richard.weiyang@gmail.com>
 <55735a20-1048-4c04-bcd4-45eff0079f61@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55735a20-1048-4c04-bcd4-45eff0079f61@arm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F036740002
X-Stat-Signature: 3it8ne87qczy3mmutpomdz3cnb3m43rx
X-Rspam-User: 
X-HE-Tag: 1755912595-350944
X-HE-Meta: U2FsdGVkX181WlkoFy+Mo9umpgEmT0tRq7Fh0anBc3BZHGacVeCbniLso7Co9kQDHIU53Ma8rFLczYi0y2NSViuYacqr6AFN4P72oE0uyJPzmVmBEr2I8j5zDn34VGO/exeS1aYWsBXGufCcR5ak4YfagdqM3Qn2SAcsfgw3STmwc2k7SSOA/xIbSTgGzP2oqVGgeO6/YGEvZRVXVfEgTRVLsVCq7Zg7AHlcgxSvqNDGBbdJ+gW73anwuAz0NfiKRtbvtCp2a22IXUQg6ZtVoztNaKPWE/Vq2Qq2ZhFIBE5UjEFky4m99jIJtMKOQBSBvNNsMcLqtBA1jPbVw8/xuOtGElFx6QXu7BDAvBZrhRX6X02qlpkU+/kx1O69UHmkN+KDRMrbPt0YzJ+Y3ScvvFiOh8k0WYGGpmrikwCkUTI4GFW8wTlHttNdjTjifk96YDY3SvaPseGuuq5jHqsxCA902jJPyyziAk21oX//lGw8AXnjIjYVJYYCZvCQxRBzSb6resiekzD4WJU5gHndiTDgVi6hAbZu1/58bkcx8x2zD9N4f02ct1wA37FNTDpUFmJ8GvKEx+lVaaMEhWV+K2ycypCHZU1UxfUu+t5v8M4NTX4QoSjQ3FCa1AvzH+B1/EZOEr9DDL+Hym6b0n9hADk33MlyMxpzv4Sy32pTzZhU33QoU1ToeGYQQ4bdTdJBTB0fh3jYkBbRaPCb3oXVzdSBn/IaWB2nffq+lT/GuuoBJV5whDn9jfZq2B8Hpw6ww1Zlfo64SnZ8KD0AsKkCCnWThMiYpMOovAPyhxYCOJioFj4jJQRtReCBue7X5dbwfkwrhZHAYdmptsuXhwFGhoqPy9qNHaeSi7DzVQf/DyRmCWqYpE6/Q7XSO1/VnycyVCJXEAQF+P0lz6WzlNH+MSNWTljaJIcgh9sIgbkGM4fBbnram6pA3toP7wg4BD8gDs315Y8qQ9P53Xl+eb/
 0FyA9iQw
 O/dKGt8Q3mqYt7bOm9X8rb6FEfL5w0897mmf1FTngE62yPVmhDICCmv3ZO2IYL6ZVBr0GFfYwGnJrry0tKCGxhuX29Vu7DkovHz+ueDUdUovqWuKYNyIzeGZ7vNQcxrTnFdP0TEZFqAt9KU8kKHq9zmD/7K+df0r4nK9FWuGENHqVbTTEteHSyVKCUenTkD6kHXmw79YYUjJW114T4kP8XyEw3DmENjPtaqdgBhQ7XYsfKQ6hL1lt4ExQQ72rw5/8pHdenA+/C4c6emM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 01:08:57PM +0530, Dev Jain wrote:
>
>On 22/08/25 12:03 pm, Wei Yang wrote:
>> Commit 8ee53820edfd ("thp: mmu_notifier_test_young") introduced
>> mmu_notifier_test_young(), but we should pass the address need to test.
>> In xxx_scan_pmd(), the actual iteration address is "_address" not
>> "address". We seem to misuse the variable on the very beginning.
>> 
>> Change it to the right one.
>> 
>> Fixes: 8ee53820edfd ("thp: mmu_notifier_test_young")
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
>> Cc: Nico Pache <npache@redhat.com>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: Barry Song <baohua@kernel.org>
>> CC: <stable@vger.kernel.org>
>> 
>> ---
>
>I hope you must have rebased since your previous patch got pulled, and
>the difference of time between these two events is less than 1.5 hours :)
>

Thanks

I took a look at the latest mm-new, this one applies.


-- 
Wei Yang
Help you, Help me

