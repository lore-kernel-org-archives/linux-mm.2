Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BF27CF2564
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 00:52:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 799506B002E; Tue, 18 Nov 2025 19:52:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 770C96B0098; Tue, 18 Nov 2025 19:52:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6867C6B0099; Tue, 18 Nov 2025 19:52:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 57EB26B002E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 19:52:53 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E5B50140257
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 00:52:52 +0000 (UTC)
X-FDA: 84125531784.16.D9EFD21
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id DA60C14000A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 00:52:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q3uGqumk;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763513571;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CwmwtJSbklc/3WzpeJ3eDBBYg3SH+2/Nl1+OV3jnscg=;
	b=B/Gpd0suj+Ani5O13EQAxeLV5tSy7PbbZKx2HzXk4qY/YVZEj4+v4MyrP1zZPnB/ORRpQ9
	/k3y5k2UUwIA8tCjv2v4TQuOfH1aqehWbo2mQWMBmSU9YhQIQKJbPMMr0DehKGhkyvpbFo
	nJVL+mbdTQbdUn8wRfsFqAgaBnHvYbo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763513571; a=rsa-sha256;
	cv=none;
	b=v8wcIJKaMpigCzuHByEwnrNgps6fJJ7++O/kSBJv4gvFJLZ4GpyeelM2NGiPDzZWPcIdYu
	rBHC/0LmvoFYw4+kcl0UcZMQYqFwr3n3cYIZrzWRDpmfuWD6uE8FWQYrmNeS9A2FfONFzD
	IUmsUU8dF9rwC228NmCMWI7uEH6hUwI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q3uGqumk;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b735487129fso981398266b.0
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 16:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763513569; x=1764118369; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CwmwtJSbklc/3WzpeJ3eDBBYg3SH+2/Nl1+OV3jnscg=;
        b=Q3uGqumkrZIqwNyzoHW1f5iSg3LD5mRag4ZxxpbKrE6Wz/RLTLL1C1Odny3NSLHEXH
         3tWKqNEcPNS3dypJ+6zoLThn8rKAPssj/xNisRW+ITdqfcGwj78e8SDwiNPARpasizla
         O9PgiQBtg2BvZYtr0ojv7Mnz3jPVo4pvhC4TYoJTDsHTD12Ujy76BGaFzmWE4rLk++29
         sIdAsZESi4GwCDplsBpNKHLRGF+hX8jy+Vybdfr7o4DldgfIwjcBDxJtiA/6zrhRJDYW
         Kj4VDTOSjKN0mrCYus+LO0mLfothu/2sdIckNtyxCodIO+HgKlt+4V02tSIe7EmtNSXl
         7dLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763513569; x=1764118369;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CwmwtJSbklc/3WzpeJ3eDBBYg3SH+2/Nl1+OV3jnscg=;
        b=koXjF7POTFEUna3OWg09gG3YxA9ReUhUZgxaNHtfU1mqua+BXs8vaTsFLPEHhlirFL
         QebG4w2gcSenIKH4v/MGqJ5TaTPuU4pOelRCjw7Q/kGp6qEOrk8qMKv5DPABh2Iqaxyr
         Rgw1vo4/iezeYDn9vFL/bMsRE3hyzKZEHbbqgksKCzBqzT8rQofScDLvq3YS+tthZIOb
         FahZ2aCXtPTYP/ycFKGP4cgluk49YrwVrl/AglBlJf+FgF0gjLTsauCG7XV1t7tgUgLl
         tn1OUKjRoAnXiiLPIscnBpO7sbuZZgcFthKsEpvO8VdWKaKLqd8jZt2/FDCRuet0fP9a
         DpTA==
X-Forwarded-Encrypted: i=1; AJvYcCUooC38GJv1qvj/Gsj29VmQDa0uDSdXE0RppOots4QYqdDjZ9fmb3rWo5JhTwjoPfxXzsfHAHvDhw==@kvack.org
X-Gm-Message-State: AOJu0YyuR9q5J6ujNG/M+gMa89ZGKsnzh4wGuK6ZhkfBmVK2RsTBCoyG
	yZvsfAnnJe5FpphtV6bJUehUIkQfXNQ4F4dkwfv7P+BxHoSz47wscQPQ
X-Gm-Gg: ASbGncsXfXac6znO/tZsw+RuvkXh73fhdBQj6+LLf7haIg/a4AvFD+U3dyvacX3X0nl
	8F9LPMRa6rKLXUNR/uEYncUivufhx2xUw3OuKAA0b62x8nAFSv6OA6mN7+0hrQ32i0Q8wCgBRyO
	WJ9bnqMLropmlsuGfTNQje2YdpiyffMUUh6/SDhNUMltVWDM0wlznOh84gaSR1ESu3fxpR0FCem
	yneQU8nJ8qnSZwLYeNYNkKT4RJLiSvOPWBDNWVEezd+n0W3Q9xhkWuLz57bqKspuNzBmkNxp1OH
	ND3ifRcOyHXzHHXooLsZVpkv5xEc+i7q+3hZWoNWOFR953X8zdd/YsdTNqaVW9EeqkIBibNoBGb
	h+6eQwcZpG0VC09+1rO3buaMt3NQ4Z1qw3GfRjRpQhmLd/yM10IrwB44OGD9oqxUztRVbvbpENq
	O/z/KnQSw0SnOv2Q==
X-Google-Smtp-Source: AGHT+IHVT7TjyFyalWITY6Irop5/6tUXXB3lE+vd5yC0vxZhssZPJDilIvLxcp9BzXAmL2NOMsjfkA==
X-Received: by 2002:a17:907:1b0a:b0:b1d:285c:e0ef with SMTP id a640c23a62f3a-b7367829bc2mr2096146266b.26.1763513568951;
        Tue, 18 Nov 2025 16:52:48 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fa81172sm1467846466b.15.2025.11.18.16.52.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 18 Nov 2025 16:52:48 -0800 (PST)
Date: Wed, 19 Nov 2025 00:52:48 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Wei Yang <richard.weiyang@gmail.com>,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v3 2/2] mm/huge_memory: merge uniform_split_supported()
 and non_uniform_split_supported()
Message-ID: <20251119005248.ddlbhokgjdmlkhkr@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251106034155.21398-1-richard.weiyang@gmail.com>
 <20251106034155.21398-3-richard.weiyang@gmail.com>
 <20251117012239.lqm33uu4vl4y5zqc@master>
 <337CD281-F5B3-47FE-82C3-ECB236450F60@nvidia.com>
 <20251118033339.7rukw7vvjvlbj5jb@master>
 <51358ABE-B0BE-48E1-95E3-C778D1F44622@nvidia.com>
 <20251118103220.bd90932096d4e36f754de21b@linux-foundation.org>
 <2AD36673-231C-41B9-905D-35BAB4CF63D2@nvidia.com>
 <20251118140658.9078de6aab719b2308996387@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251118140658.9078de6aab719b2308996387@linux-foundation.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: DA60C14000A
X-Stat-Signature: kibcsxte9kq8qa1b44p5d7uu4rk1a3ph
X-HE-Tag: 1763513570-270942
X-HE-Meta: U2FsdGVkX19h3uh5It2GwhzSNjW5eXabgKpWbOOGwqZWWRYatGpJa/qauI6PRS4wLx70CVc+Q6csl6LyTMMV8ycEd9vjv5ZnEwFGwNwgHfo2yPWkXHCnAPN9BXu1G18C0M58xPgUhmcZlTnS7YNc/zjK8biWP25Al7nBZbWB96rQVoF20eTUa4qHF10+ga7BC/8oI4GU5KT/dAL+78o5PYcGrR9dN+iqN6Phh3/RNKpvJcYuLjqnuv/z3gALUpF44LqkFO6Qh10lNNan+RTCImS+4AJ1d4W5rkY+jZVyJ1tt8/staA1JJqlVQ0mfCS0kCJEwyKQXWc1xVHQd50mkWYZS6ex1j0U/ZApEYhm3P1B97KNt1zDmOO1aeiHBAqswkkpN/E9U7vrJ/VkttyAjuhkHfWIu5KydaMw1BJQcETyTUgz0xWI19SBBQSH6fRyvvftt5XVEllsnjdoT9y/26BGL0uz3iksOBb065aPb8I7jnfg74T2QzdOvt9pa4nzQQsTGJnTl1D9UjZAvKrxI8jLrCU7jilu+to2qnkh3jSMriy4hKNDpGs9F1Ld8HM9y2QiBBSBb+O2JXcliCni9ndBg7+VO387EI9UmQPgu/yiZa+rACvLUZ5J96H3MxIIng+TMy0MjoNbf7bHPvL9OupiTDAt+UHXtmgaL+8jhSbQCLq21i45uAAnZ0LMOA2Z5X3U1IjiyFi29eDacyFT7M2m02v8fNzT+WyPU0n4vIHSZ9G3yOT7Ye1WOTEJqGKx2GK6J83slyPpK+7IYVBPfETK8wk24gJC0wlNdQACvXQSW4cC5WossLSaw6UoB7BTqLTPz5drsKm0Iv3T0cyfe0Amm622LszTOFpxAuy3CVJTudJBNNuzdWa1oUAZOIHi/55AtCUXoQLbdRg/op9Tvd4aPbkUSvc+DW2IwYSa7xh6abkKopqbe3AHQKuKGLu242gkRd1YgVPPI0x2lN+b
 5vNW7cPJ
 mHhl6w4F9xFQD/jFzGm0EKxbJnkhutoFzSu0dqsK4jzShHNOrhY6Nn9JzbdL9J++MKtky7a7KqgD3HuWBEjFCxeT4b9+8DcmEymDZaUjSd4Wr8lLhWsRwWhkOTNILvVIu1zFZ0+LSLVDiE5LzmBCNjHSTqJZZrpk9YZsymTI1cB9htqRBsj9QLkKEMZhIVNoxVMFN0AhWcE17fAeIPSZqPSH8G7gfDWPlFbr7WCq944itDcawhgInPIeAAMdwAUAJFqpKYdJK/u+tKm3oluKfblRZ9SdxhW9vgT622UqN52gMdzntfHfdyHdquLPltiC590mKUJoej5Q4qAmsnDXLiky1ZL4F7DlgGQR00D5eKLplyJPO1kJqVzQv9zC8yd/fJ5TW5OhTusZ9ST+XDB1SVuEvvh3yejTKRoRghoTk4g/wxQBWNK0m2cJv7VjMhBMBb9LrkzcP4694O+2F5irGVuqMu/a4Sz12GdtABamWxOW4C7BT/GoHUx644oNk0drLt/6JLsY5XPXRWY+CSNDk7F0LId+UmtjCr4+wvwOa1zG5tgEawnkUW8vCPdLo7VCXtlGJwh89dtbPypPUdIwFCwu91x3rWad7ReLoaaqZWmGTP3gpmrTrzgwiCdxBJLbNOr/IecdE/jyeURvyXb1ICNxFQVP5B2I7Q2EJHVqNAdqkirmuP4R0pcjItYoUMmudbPeDvNbtXM6HNVU6Ss/B6MhObVw8npbokTw+ejM2W8LbeRhwd1mG5jFlsNhppkRRgqP5ySyWWbq0aKE/Iouv57POpGG9MkZDv1PGmj3LqodWlm4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 02:06:58PM -0800, Andrew Morton wrote:
>On Tue, 18 Nov 2025 13:55:15 -0500 Zi Yan <ziy@nvidia.com> wrote:
>
>> >>> And do we need cc stable?
>> >>
>> >> Yes, please.
>> >
>> > I added:
>> >
>> > Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
>> > Cc: <stable@vger.kernel.org>
>> 
>> Hi Andrew,
>> 
>> This patch does not fix the NULL dereferencing issue yet. Wei is going to
>> 1. send a patch to fix the bug on top of mm-stable,
>> 2. resend this patchset on top of the fix in 1.
>> 
>> This might be easier for back porting the fix. Maybe you can drop this series
>> for now.
>> 
>> Wei, do you agree?
>
>Dropping this series messes up later patches.  I could of course redo
>things but would prefer a fixed up version of this patchset asap, please.

Ok, i will prepare a fixed on top of this.


-- 
Wei Yang
Help you, Help me

