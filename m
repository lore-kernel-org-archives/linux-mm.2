Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7322CA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 13:39:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 364136B0011; Fri,  5 Sep 2025 09:39:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33C016B0022; Fri,  5 Sep 2025 09:39:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 251866B0023; Fri,  5 Sep 2025 09:39:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 11D776B0011
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:39:50 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 316001DBDA8
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:39:49 +0000 (UTC)
X-FDA: 83855304498.10.15DC84E
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id 28BD940004
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:39:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E79pTzin;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757079587;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vgk2eeEIZzHXEjQEMvfN8nURnzUH0fSlJ4fPZDNKG2k=;
	b=Iulu6al/XGGzE8ZDtRUrHbUf8Zme1m3d/FxqR+E6EFZ2HDmmtY9vii1dBA92cmDnfOhiox
	ieBCCYSmVoLYQwKbe83Le6QYecjz7+nepZshghzJRU0Pm6hvRdYeOq6TqxyID9EWgPnuVH
	iL6mfwmXonnydDal2yrUbBvqcahuLbE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E79pTzin;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757079587; a=rsa-sha256;
	cv=none;
	b=BOtPlUR/GsuLpItg7QWjqJavB5wI4QE4m6VjJF/CF15t7nIO5v9UGjw2u6XM1ioOe6Xs0t
	5T+j+5810/LRQOQrVMjyFTR5SZ7j2k1jVvRWgKtZk1G7o/1nlBluB1Sgi5otSIGG0f5VHS
	5g/2OFaHDU4nQt3MRqMInSHi83441kA=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b042eb09948so391727466b.3
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 06:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757079586; x=1757684386; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vgk2eeEIZzHXEjQEMvfN8nURnzUH0fSlJ4fPZDNKG2k=;
        b=E79pTzinv8juxlIw/5AsX0GJ3l7qZhUGTK3NH2Z4bqhjY1OhcftwtheXBZVRrjvGUF
         h8/wBHloCTD0gYmj4j7g17TRgkL1yp8LxgTqk7a1RKy7XidYZTUMnosrWL3Do1zIv43y
         ABn4GWcx6Ey9u9tjMVNmOMz3L1k89ExsGNzWdJJqTPS2Hq72/X3UTLP00a3MiUbwAKKb
         FVkdNpyew13QnBX4+DHht+/Uc1cq7HyIpY+ijCRA3dMgdAIXtDaN4RQRWq4o3LfUDvtU
         6/dQpdWpjFkV0v98guIbyca158m9KAX+DSBdj00sogx3NoF7qFjlD8d48cMMlhCJbcvN
         F2Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757079586; x=1757684386;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vgk2eeEIZzHXEjQEMvfN8nURnzUH0fSlJ4fPZDNKG2k=;
        b=AQ6NP7o6atht4k0zsgrBtMr45UallDY0qQvTXDFNo4R7tFdQg4JhRkppAFflVnCXr7
         PUnP0h9Smg4gq4hKnD0DDuaRvYIXhVcxUBUZfPHttcGKPECGh/SeYg6G9WsdoK5CchpV
         IO5dioRZBtxFUop6r3yrFGT5rVFbMg8RhUBEUnYUE6VTSptwzYY+P+3jMEtwm85oBhSk
         O2WO3Adtpn5Dc8Y2XvNg/+g/kuZ42uFrQNfqzP6WG++CB/PhL/paasOefF2ei/J48IFM
         dKVijKogZ9Hw7gbIh+W31Ks6MzXJeicafrRp1qkzZOLHgGBMUXi4Xp+xlb01eioCW9iY
         WxuA==
X-Forwarded-Encrypted: i=1; AJvYcCXw0azn0ermColtAekwsWplufwSI5fErU2yRA8cs9Q7TzGCX7vKsrU+sVPfCwU3OihWStiYNQX1Pg==@kvack.org
X-Gm-Message-State: AOJu0YzuFiWR9zi1pH2tM9qMfCmfg9SKxUz//K7edi1vF59QF29tx4sz
	E6V/tH2aNMTBNM4d0k+LePnAK7EWv+WBeE2TdI5ms+qhrwPPLFLOwKip
X-Gm-Gg: ASbGncuB+Ara18DQFW1n0gwI+PnmDw5mpWgr8fwegjF4/Vq+P8iV/ukDXm+iGHaTSyd
	mXB41xXhM1D8LRDE0tgM7Di5ptph5IZrYCCAyNjED+It8XG7pVjM8SIm4soWDE2+O8dC4wQ7k3h
	Ku3Z5FbdVy1dQqK976kuZ+O0usd4aCYQnScicQI6pUMvjL8Z6XRy/MGa57G31K2DM9WcZtf0Gbn
	lJzYxUkJ1kGH4gjuFWnm8Tdm4gFakgSYepDPRTvm+QC450vo4GoxHjCPzrA27yLmZZGHbdxUR4K
	WcKj4VV/QzfMXIGMH+ZikwBM1Z/gD5U5leODnE1/LqniZCFAxQvCWi2MjF4pTwWd/M568+v3SF3
	4ulh8sY3igfWn6oXY6kG6CTD6pdp0xXEGOIuO
X-Google-Smtp-Source: AGHT+IFI2No3TID5oH/4T0G9aA3arCZ0pnQDj+i2QnHXsj/89Z8bWCZxKfZhcwf4aAg3mb0r1QvbmA==
X-Received: by 2002:a17:907:7245:b0:b04:76ed:3ff5 with SMTP id a640c23a62f3a-b0476ed442bmr906627566b.40.1757079585368;
        Fri, 05 Sep 2025 06:39:45 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b042523ee7bsm1318657066b.109.2025.09.05.06.39.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Sep 2025 06:39:44 -0700 (PDT)
Date: Fri, 5 Sep 2025 13:39:44 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Donet Tom <donettom@linux.ibm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: Re: [PATCH] selftests/mm: refactore split_huge_page_test with
 kselftest_harness
Message-ID: <20250905133944.dxwa6l5acd2w7mgj@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250905032431.22179-1-richard.weiyang@gmail.com>
 <720957f8-c50e-428e-952a-9616e9f610b8@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <720957f8-c50e-428e-952a-9616e9f610b8@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 28BD940004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: dzf9ztczgzitaeawgxzoq8o67zzr3z1i
X-HE-Tag: 1757079586-20296
X-HE-Meta: U2FsdGVkX1/Jn6woqnh1Hx/SjCqr4ngBGXB2L4bjOSoVcZ0uUC8d9gpm2s6iCRTvH2Fm9tpmlQveYAedrtsBJxnHFnn307TshJLpMu46sYl57rduoY5gZrnT3nQVH9aIG7zIjIfRk7QvBEe7pVfS558owLe4POw1FdYTWCeZufoS8UG0dir2xR9hKpWLfe/kR9Sp5pW8WWt3bHv/G7KDhOFKW6jXhHlzS67Qd/+gKCEvWxGERaqQoD3HqW1cu3vub/FGzzbi51Ro+li+26BUqqZb0vsjvJ5zH88ziesq3LPJx+2tJr370Q1hU5kcL3dq+4GPUrJwKGbKhVvtyHNduMro0FMvZJh0Ub/jVosjhg4H3ZKIHRV7RDTHFQnRCWk3X5rhScJI3y3tmlaPatvavt+m74vxOCz/JoiMRT550Ugq96HDc/D2eDzaOOBEdqVCwJ0MLUeEx4J4azwItwW+T50ma+iv3S/FZGaraxJg1tIvAgqW/YUt6S1y2fSn6edApDWCdBbs2KY8P3ueMr8JAT/wQZes9iWmXaYeBA2/78ttNvsvAGrPXBAAKWkEav2VM7TwKjPGGMmBIIw4khNar/DcXcGGVvsmygURLc+FBYw7jCCzJIW2DptHpLrYC8EbGNRXZNf8dME4x1q8wMAKoa+3H+fsZDFgQpRlcqf4qBLbJRDixTHkHGk8rhDuWcYYiZRrZb/ncOkttrPa3H5HwhRhxLGqbM/pYeg+oDo9KyXLzGOw2KhZs/XooQSWuaGbhx/cClYlCq4ypClNocUDhYcWApSMjEI+w2CV9ZTzs9EdOCMoqzXreXDkZaOvzRS42TjndMk7Nm1bYO3I/px6slTccFw+vPbQYOt9/XHmR0Kg/gDh69N8BbUWx/nr7IKkmM3N2eah8HOVo6IwKmvgqvh9f81KsdLt7T4KHlRGp36jKGcvop3NGMAfGvOylyc7ghZ/AQ8pQVT+b3nnY/s
 rox6bEbq
 JKJO+sDuAWYNQApkhpaFphtIfxhfjw+e+ovAHcssyzgbPI9wK0JXnK6NWCMG674MBRqfnrqqpfsZlliJrG9Dx6rVx3TJNcR45Vus5PkRo8TezlggD2wHwMiKYsSIYluZ/C7BowQn0MZ4WCu+S5haqeboW4LNuV6Kp4DZ7JR+LfchHHIicaL7I0OBwyY0oaCcF/pA54lQs/Nh3nrlihZLR1rkE5SIJ++PPcIJac9i/nmKrvZD1QKrWNBi+BBOZAPpxauPAyUDzH6EhqpFNzKhrOaUk/q6zWF7H4ZezPiWaUNPh0v8m0ETxpHwh34UvZDlRHDLS+zsI28glldTzHkKSvYbaRkMZrxpAZB3MiJ+dWjgGMgirjgMTRTrWRDir5uavIqF+zk7KOmLYcQISv5KDorm1k2AgqC7nLYp+XVxTOZdMBqqty0rqbFvY0MfIVa/Cqgj/axuElzxB0MFNJmsdkibuymlHtz4libxUP/tYAP36fCEeWXLIuCLJGscaREdWJPAqfECtD+ZiEtYTCMYvOQvGNVJhniE9R7zUvf9BMBqIMI9lIdoakQRprsD2Og+7mK15ouqPWpQ/s/GDYTUjMHoS737TYEQd2ZLirllyZX6PBe6rA3MBfnf124Ifeh4EeGlt4JT2/OeprS4EYFAPCN411SkC/ZGBzi48IaaqfMnV/yRUDV67z7++jvCUubzDgrOuzxvabh/dADv8iLwqRTUWCIPBFBHFkHQwxS4NiDwRS6eXstuCp8WdAH85BykVIIeaIfFwU5eZDb8ItcUeWbqglA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 05:03:26PM +0530, Donet Tom wrote:
[...]
>> +FIXTURE(split_pmd_thp_to_order) {
>> +};
>> +
>> +FIXTURE_VARIANT(split_pmd_thp_to_order) {
>> +	int order;
>> +};
>> +
>> +FIXTURE_SETUP(split_pmd_thp_to_order)
>> +{
>> +	if (variant->order >= pmd_order)
>> +		SKIP(return, "order %d is not supported", variant->order);
>
>
>On a 64 KB page size system, the page order is 5, so the remaining tests
>are getting skipped. On such systems, these tests are effectively invalid.
>Instead of skipping them, would it be better to simply not account those
>tests?
>
> # PASSED: 64 / 64 tests passed.
> # 30 skipped test(s) detected. Consider enabling relevant config options to
>improve coverage.
> # Totals: pass:34 fail:0 xfail:0 xpass:0 skip:30 error:0
>
>
>Here, the 30 skipped tests are invalid, and the total valid tests are 34.
>Would it make sense to exclude the 30 invalid tests entirely for 64KB page
>size systems?
>

Yes, this is a little annoying. But I don't find a way to achieve what you
mentioned with kselftest_harness. :-(


-- 
Wei Yang
Help you, Help me

