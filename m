Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75E51D778AC
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 18:55:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D43DA6B0540; Fri, 23 Jan 2026 13:55:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF0B76B0542; Fri, 23 Jan 2026 13:55:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF3146B0543; Fri, 23 Jan 2026 13:55:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AE64E6B0540
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 13:55:25 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 460C4160579
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 18:55:25 +0000 (UTC)
X-FDA: 84364131810.22.996EC3A
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 532A44000C
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 18:55:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="c/hGNkCW";
	spf=pass (imf04.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769194523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sEFLsQyzoxdu1YcF2YnABjIcE2WnszBPzD975tlZq2A=;
	b=GHWOt2rvKRHewqEEosTOlE8GP/VTuAV0U5zKNlgyYk6nDzI+JNgi3tgGail1GT/+tOTQZ6
	Tu1vllqvkBt19gT8UlGIP2GoPSNN1wZvmTdraeE/15TxMBXZB4I9bSxe1TRbL5eDocNApl
	Xl79QqFxAR06we7LHXxrDKqDBGS95SU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="c/hGNkCW";
	spf=pass (imf04.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769194523; a=rsa-sha256;
	cv=none;
	b=LQ6FuPtVilF3OffhLM1NpN2xoNMo5TMoNClzB3LoHm85mbkoaEPB9gPIQxHk7d2VJn0lTZ
	RVsfDvH4zq4N+HJOThiKS36JQGwimeldbq3gnqVCGGcuHWofmFdH8s5HEnqoK+JZFWNQFG
	13r7DQ+dgjv6/r0eE30++xygDA4HIOo=
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-59dd9aef51eso2936359e87.2
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:55:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769194521; x=1769799321; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sEFLsQyzoxdu1YcF2YnABjIcE2WnszBPzD975tlZq2A=;
        b=c/hGNkCWhq7qN0R4mPtFJeIxDPV0fqSn7/5aoWJGOZoZG6TsWSjOW7tU3wpkPk4abP
         P+G7e//j2sMUzkUMxyAty+ndsSFhgrjkMWELCaVS16OMyAFO8T6+2UEymeWyHk/0Ts0/
         x0usTIPA+qEEiJe8co9/alFikJbmGDMKZuPrUQd1Voa+rWz9BAPnrRHWEcIdtBO+wz1v
         bb01ITKTF23yi3xOHIm7clWjkLxE0Awa7PwyxOhDa8x4tj5agGoa6HgxP198bjjj8DG4
         vxA0TY3J5wQHO/Sp/bMtTFZTGSG1Vw29HBBmwghJ+9UsJzknxKZFr7bkkPIUzGVVoQHx
         bs9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769194521; x=1769799321;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sEFLsQyzoxdu1YcF2YnABjIcE2WnszBPzD975tlZq2A=;
        b=UlMXwtipo95CWy51MJJAcEommtm3HwHx8BfKXJ7oy0df2BI5iFaIr+2sBTjdu0OXZp
         A5IViDY8pOnbdRfQKDt8DhRWNt7yfB9N3ckeAVSI/JVVvkz0Z4nEWyrtHV7UGRFgIOd1
         T04FVSK4HVAGeBugYN4h/h38ZXjcs0vTAoApjP9p185gsbnbk9NFeSNJQmrzR5gyVNEf
         qMWIKOKXr6q/JpJyiX/3FgFKaHOjDtIZyh5/SnwKh0DJfJiTGiPaEOjSI9NJKLIdn0uI
         NxNU++gZkEkrAJ2NKwbN8XvOh0J48xqvu/54JnSDGKaNwVodA7Qdo2eUAC7pqRMY3XHd
         RmxA==
X-Forwarded-Encrypted: i=1; AJvYcCViSKMG4Balyahl3UGywiXppmOZ7Yitf5iUvhY6104p+2TDubh0bt5H+rkQ6Fw1siNQRoOanlnsdA==@kvack.org
X-Gm-Message-State: AOJu0YzRrd4mqXwgjfR5fssnE+FcX4Gw7Z9PBXB7uBCp+SEj+c4oarHU
	9w7PX+NSqxD41iuIGFWGL1wlmFnrZN4gqHywhQETrCxqUpdEqdmXj4gj
X-Gm-Gg: AZuq6aJCEExa5Xja3dg/WiIhP2Ir2on+XCpXPNQqpqLynjdlZIxRdX/nO+QbSP6fmTo
	5RKaKlzmAlOFhBZCn3uJyEmUqoUlhyHPTDwr309J9LCN1ac4JYeLOMZS212v4wZl547tbCJAOwM
	GcC7wwh0PICKsN+4ACzRMhShj0IOh9qbaNouWKQS8w60H173KaV7KYAvarx/RMRwEgR7hqOtv37
	M2qocbjEi2TocziWqpt/Xp3Q4hnrjIPAwsoa4zCNW/PI0cB9FN4VxwMz1eAGFnYP/X5IKDFScww
	qspZaCG6wAUoHF3biTyXdG5FYxQaEvHFretNXEurEsIY6QRR5TemfkaH4UQa+6NBcIr7bkBQ6/n
	VIC8AELpnZD/iBCLDXuadXdjmiZzHQ5gXl1lN40Q1+s+wj6jMLrha
X-Received: by 2002:a05:6512:2254:b0:59d:e7b0:cfc with SMTP id 2adb3069b0e04-59de7d7309dmr849185e87.15.1769194521113;
        Fri, 23 Jan 2026 10:55:21 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59de48e6023sm848831e87.32.2026.01.23.10.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 10:55:19 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Fri, 23 Jan 2026 19:55:17 +0100
To: "D. Wythe" <alibuda@linux.alibaba.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dust Li <dust.li@linux.alibaba.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org, netdev@vger.kernel.org,
	oliver.yang@linux.alibaba.com
Subject: Re: [PATCH net-next 2/3] mm: vmalloc: export find_vm_area()
Message-ID: <aXPEFdEdtSmd6AzF@milan>
References: <20260123082349.42663-1-alibuda@linux.alibaba.com>
 <20260123082349.42663-3-alibuda@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123082349.42663-3-alibuda@linux.alibaba.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: da6n9zs7upy4h9aqf1mmtopwhfg5dj8r
X-Rspamd-Queue-Id: 532A44000C
X-Rspam-User: 
X-HE-Tag: 1769194523-579896
X-HE-Meta: U2FsdGVkX1/bRWqZH3aNPrmUa2W6s6oy3fD3JHRsAlAuPtdyNm5WgsHwgrfveuS3BHPobSotQi5W4dHLyJDS+PLik6qgoL5oCUrQSDlkOHpBynWdi5ydL1+4qNm+7qO0R6MWGK8xIbL3KUZEi3hfEUduXBDr1zN77pZA9inKmvsTKOaZ8uVfWOybBzTsY8Rpsvbl7Xj+XHY0syHVw+OCzevwswFnBxlVQ5/i4b/KL5kJZpX7zgXjDFCGpP+WFVICskxsXB/CvGuKPj2AeZcYes3z2BdjDhIUSz6Kbr2f4J/VhDzZqqxnJet6H5Oenybfu0y8lllMCsB+pZCAXjR3v3sGC6emXvRd0wMsV8ErfRh6L/Txw7SqcQvueXKwKHT+yj+sFV/tpXZCys+dT8Yric5Hg+m6vmdBv71Ngi1DefiOv6lRk10hG5hysPyW9TkzA+jHdQseRhD4DLZYaUWDGAi+GCAhN6fD/Xgndij19ASskBwCVqvWADzHSF7prDswQ4e3H6/dmfceZqv0GOGjk0/cgAGmFS7LdZy8aU6W/Mw0i2NO2ePY65XPwWQZRBNwbnR20YiRLgoI7A988bBneu/MM1VoK7kFmoiHEwgY7hYIb6HMLro7lCnUiesnZ1ANiOxB7aGePYbuAEuzQeZlPdPOWkwuUM4JvfV33fueXRhRYqqIzIMTq6Te2JKy8cbNwvccWZpc93C5nFp9ewJMg3hDXISpaT0LWv+ORXhJsnq7PaHRtKme7UXVFsUVA9Rh7yuC4d+CJmiLn5Cd5O6n3LfpFUHl0vC4/p1xGrgJdI5FHxYrQX/ehHtDCQ3o8kdJ13RWrR+Z1smooy/OG2tJy73YAUE7sT6KrNyDDHWzXjInFSf/DMdskFobpSunoToc8qXIyF4Awi0cNLi9YWbgrgBcacY3zmjWaMp4cKlSQpS29uz5fLxgU0aAywThDmPp3nmjAqCg2rdiKCztG76
 zMA69/JJ
 KYGJCvC2Eys65T7oDmw05MLRhhF794KUCDnQb+HO7+DkSIb8eTbN/6nS4Vnh1qd39v4xgHYcoPZtNzav7/L4reMX50UBleg+peZn9aOovlsyqy9Hm+ehzXSbKKpISThXvy2rMw0ylJUtGK88bPFAHf5GH9feQLWzvuq/6Fegkx3wR6pCnITVNL5Fzftwez8FI32mDtnxNXHwc4koGaYCxPsrfhs1hhdFsHfk5kodbiI+dhyVfp0CLXkiEU5iGUTLvgC6ADaYqVSdLwIjVCYuBazte5rdPK2C2pXzYyWvcP7AbfGR/rDn7B3VMzQOR7DXJReQP8lwv4/da5GdhPXYnV5VAdygvqENutLFiWaFYR0/py7pdscF0b0FOzh8osFeUOKja4NQFvZYC0oEHAjIJI2LL1QA9aD8EbIo6sPCtbqAmg+Dou45pZF4ScISwnKAaCoTr3vn8KVTzr4EGqnWnaYfSDxpxegz8JYuIsz+7DdIJsFpZOfy3unRAKLwTWXwRjnBekRE+Tnuo3SmJ/Qkl/g2tBSVXQMuL6WFhEqA6uTU//1WnLEHdFXEB3lCXZ1+RR0E0Na4mEjoWUFM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 04:23:48PM +0800, D. Wythe wrote:
> find_vm_area() provides a way to find the vm_struct associated with a
> virtual address. Export this symbol to modules so that modularized
> subsystems can perform lookups on vmalloc addresses.
> 
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> ---
>  mm/vmalloc.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index ecbac900c35f..3eb9fe761c34 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3292,6 +3292,7 @@ struct vm_struct *find_vm_area(const void *addr)
>  
>  	return va->vm;
>  }
> +EXPORT_SYMBOL_GPL(find_vm_area);
>  
This is internal. We can not just export it.

--
Uladzislau Rezki

