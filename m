Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38AF6CCFA04
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 02:44:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 977D58E000D; Tue,  4 Nov 2025 21:44:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9500F8E0002; Tue,  4 Nov 2025 21:44:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88D0D8E000D; Tue,  4 Nov 2025 21:44:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7B10F8E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 21:44:07 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 272F91DDF3B
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 02:44:07 +0000 (UTC)
X-FDA: 84075008934.17.63291CC
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf04.hostedemail.com (Postfix) with ESMTP id 312744000C
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 02:44:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nsxD0pbl;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762310645;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7BhSeNW9Sre5WGut4anFf8luecVrBacmwXmBuyT30lQ=;
	b=hfjc++bEqMwp8jvFfSF5jOy4FxcdFYvs5XqaDceYtJJITKsOnm4qHLNTvwK6LIriMf2+AR
	rwijpLxztHMWpn6qk+gjJP2X8S9SUkdCl0PpTdYIIemj8WzonReQQIf2ZmQS7F10peawy/
	D6Sfg099IJOlgcRmQ0Bk3TDOxev54XI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nsxD0pbl;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762310645; a=rsa-sha256;
	cv=none;
	b=rRm+/nLdnVZQlOYh76gUQ0m3zL7ztLd4LM2/zN9oeWIBYBOnbsS3TpVbDxOrQfhuGd3R3s
	coy8bFy7num9p9vEBcGmx2vYA1PI63j80YIoZFpuusaybsBHgPabRY6XmcXEaYL+RUe+K6
	Ce8RI4L3XA73PQEOqCozJ0odQRsLvqo=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6408f9cb1dcso6490640a12.3
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 18:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762310644; x=1762915444; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7BhSeNW9Sre5WGut4anFf8luecVrBacmwXmBuyT30lQ=;
        b=nsxD0pbl0tIoP+Mvoori5zO3k40YpA+Xwwv3kTWDk/4UeF8iFmA5q4+HywkX7j7tQv
         /g/2sOM3d4OrJtEHYE785CicuiWxw14/TbS0er6ZDdXgVh96avgxSHXkSP2eN4DiIBFY
         YNaWjnIDWMAOktUG2/l0w00DzezXzn3bnixIfoSlwPPCo21Lj8VtJ4XfM5KCfmCtSnQZ
         maFJxJpdngrY+yQjPIPKE3bFDp6fJZeyJ22JLYgCCoYOeUcQ4sBScDn8QKAJSwT9xbRP
         jK9NZsWc0vpHRe3b+IRqlL8LWfCl6JceyeLHq1d4fLMPZIWhbz04/e3Y8wYY2DeTtpNm
         Q6rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762310644; x=1762915444;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7BhSeNW9Sre5WGut4anFf8luecVrBacmwXmBuyT30lQ=;
        b=TdOKSV2W7iv7Bc/fjLzyV6ebp7Z/od5BpKYSiBDwIkuCgBX3GxVECigjfErQWfAPis
         NKcp/ZrSRmdjcrbNUWTX6FvnHheTNUREZHnuuCssvW3bgewFDjz+QZ+ZKAXQqO7t/8Ky
         3cvEgTvc6kN3/+nxdPApEEQDRiYVA+TiAbHOPlwoQqS23Ei1CoxzAEMJIQr+PM7BJv+1
         jYMDaagt+ym+XM4VOmOvAXbL7gmawTa4/EkD5DuJKArCJDLFwlOVi5PQ18lKYZOqKhSY
         5fshX3cmHjmSOwCJ3bQY9w1tDbf+EYUrrS9lowJXDHx99sAGnfumo0WV0OR+5l+ds8cG
         h8aw==
X-Forwarded-Encrypted: i=1; AJvYcCUum9wk22ojJREpdgN2Eb0drI1o/zyPMlkGhdTG3/RKtmb97RL7CB4moTv8seAT15+cOUV6gbLqxw==@kvack.org
X-Gm-Message-State: AOJu0Yx3PFVTxkVmi/W/yuidi6Ae0IiBBONAXyTARZMrlD7EAoZLHZSQ
	hS1Ly2BLEhGo5zBf0uEj8Bhq/MVdgavBwHM8aqP/DugTjp9JhTl/qSGB
X-Gm-Gg: ASbGncuPKU5x1ME2Lie1e7i4E0ZLt5Os46KNJqySmRZ/LX61EWGCkcDBXL2jStjpoeh
	UTpdruZRxgEdXyFLCf6gQZzItWhlZoDMlAB3PLcgUaXcDAZuEaoCfTWnaidncftosgduIYX+8RC
	0MbB288GgqJo140Ojkf/WLDIHIYcP9lZdHDLlSC1Tu18NBDjdBOx2z3++D5PDsoE1BKT11nwoh8
	9ThSSYQmcQmBlcW/vfJI8UUAIcKiYKE9drdQad5YD6ClpdRlqAK09vVh5c4gmhbeCWV4pqCHF4a
	YjRuWoYriy7yKHfYR3UGhD9KBPEfbnqX0Vmmi+ievw6AfmLqrcP8pKUKvaMxWF4rXphs1CPd1p2
	slprlUrH16qbjyBGEWJSo9kWXmYlEIR/JLX8djRMRASqrx6axDTKFqc5zyz1NugMMPGXcWejaMx
	A=
X-Google-Smtp-Source: AGHT+IEkpG5BOZJtdtlM10DIGuOaPHqJ2gETick/Wf3YYMNOiALID2rVx+AEHW48EulvIomrAU0y6Q==
X-Received: by 2002:a17:907:8692:b0:b6d:8385:2164 with SMTP id a640c23a62f3a-b7265642f03mr142088666b.54.1762310643735;
        Tue, 04 Nov 2025 18:44:03 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b723d3a3867sm373343366b.12.2025.11.04.18.44.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Nov 2025 18:44:03 -0800 (PST)
Date: Wed, 5 Nov 2025 02:44:02 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] mm/huge_memory: merge uniform_split_supported() and
 non_uniform_split_supported()
Message-ID: <20251105024402.ikb5c7ayeq6gmkty@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251101021145.3676-1-richard.weiyang@gmail.com>
 <CF5DECC4-7C92-45DB-9931-A1E35CA3C0A5@nvidia.com>
 <20251104003618.adfztcwwsg26gmvd@master>
 <016650EF-DBFC-4C7A-A707-8FC6A0F93ABD@nvidia.com>
 <20251104075326.hqktuvois66j3cdk@master>
 <E1772F62-C1FC-4B67-A47F-7A1A6581C89D@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1772F62-C1FC-4B67-A47F-7A1A6581C89D@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 312744000C
X-Stat-Signature: 5nztr84paqpfcrir6ywmi5bprete3grq
X-Rspam-User: 
X-HE-Tag: 1762310644-584476
X-HE-Meta: U2FsdGVkX19pYG+CYwU6xAG96WPKpWDQ8IObLJPXpBCt9vhmuBPC+tmPLkQf+MKg1rnUcnKP0wGP2RzqxfMwf4Srj5iV+BBzYCeo8RJrCWe1jG9YNCnX0/rjkEEgIsulpTrgwQYdTylDevPRZP7WEuexEmdyctnPAtBjppdZmBuoN8A2bKLDWkqaFzUj5UPOYhuigROTb6Pq115plh5zHTBQEBSpzewV4xDpDN8gCIezvfwmztHM1MhjqhCHSfGXXJHJz/1df065GMlBhdPBUL5TOPeMYQA2DCa0j2s055SgLxZ4NZ3A7oyTQeTEkhXC3gejReuWrLuTsoTZO9dogGoT7RNH99PBAyhBCqnPF+cG4cOPifZTT13G9qaY8gGzBGDBvx3ESpDAltpDWTU5vLlM1SGXTGT5ibO0qhvxcylxdVxCqZDuN2+XEAhq3W10b7HJca494tn+W/jpfgxBRElScXsE66SPuZ21nZeqYyJIF1tGyRqdrjxClVQIL5teA5AFVLeU612MfFcZ9nC85dvIPLHD+7iUHdapVS33z5xc8geRmnfikipQETuzeXu2cd9wj71vGsKM7PU2hHmezhzZL66dWwJoQYoVyN6eUA+eRn5ewnjxiinfgDnuyr/ufO48EBcjOHRB6CJ0CJCxbLRjpY2kBFN18/DALeMR2+0LjkS2DFNlPfXgPoKmf/uc/oVvgGwvUmjvlL1ZCuSJuXfSK8Y6NSoqdIdQB2H14CDOfMo2AzktcscBROXFLuNnvZRnxQDLsMudVu4F0IJs4KDGwPgH4iRFAeiwGILKLEcv4iBtfsbur6+cd/sg/J6wFs8sq+1x4UnNzCfjPPUqoYvVU6lFUV2OiwCt5ReoADRldZlC4SE7cgj6eY8bY3a8TVFQMwwPkyC4mEKXkWnvHnwMTyUnarL+bkaURvJtfiAOgJmg+hiibVo2HDccPXIQpwfRnDiVpUykiWU2/Fb
 uiQYuLZF
 iZHLjjJuh9rbSByTrr2DLL5Fm0Lih50B1coiVA1IWwo/X5CMni3qvNYBH21awmYR9LYbElVPKBPeRZ2dcOdRZG6sYMl8U4zuExdqhHCuId23leMx16SlIBOsi5gfZe1n0La+covHCXFjoXQ6cjTrENjzZAIKNIdLRVWpKg4CHa+jrvJrTwoKyjVhmDRJ2FKND81dDVJRkeSNNsO6vH63R/1oOulK9hS0bYwzOSa2Eh+r53DFHUCRqe604MHNVvJV0XyBX8+ruNAlHDxglVyWboGA1K7kLeq54pJBGHoqczRKlsG2/139Y66EWwKkcXoHsDPIUmuJ3N8oqH7ukLoWvsbWFWMETdOwf9s8JNQYXc2646ypskQeWWIo0OniB/+t5Ku0aIcRwNENfDQw2t0sNAsP53GEeZUfwB5+ZczzXbXzHxkRQXWQV2ihusti6Kn06JcpYCyi1tzSfcMEoAgFrBP6GVfpRvzgN+tKpnlcYQlhBNGvlTlxB6CUnkB656sK4CTjp1eihoKQ3+bArknq6y3ZHhnCxfyz6tGe3V+ScFI3ZTE0YZDCEtEHLlXnhpzbLQs40EI7Gy1oEgGZitZG3/uvQmf0o6z18Wy27AjiYAeL3vvDGZ434EGiH4+qAYW4yEuTKwyW62gMNkUDmEZS82cFQECP10/wXPcAQVcQFlUAdpqkx4tatMlHbj4tEY0k2K8ZjrzErO+FnJ4YpgqFM/PiUjojV1YN2u/ommxButwLoPKy2vaRz2T+Ttofyaz7EyCvr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 04, 2025 at 09:14:31PM -0500, Zi Yan wrote:
>On 4 Nov 2025, at 2:53, Wei Yang wrote:
[...]
>>>>>
>>>>
>>>> How about this one:
>>>>
>>>>    swapcache folio could only be split to order 0
>>>
>>> This looks good.
>>>
>>>>
>>>>    For non-uniform split or uniform split targeting a large folio, return
>>>>    false.
>>>
>>> You are just describing the code.
>>>
>>> non-uniform split creates after-split folios with orders from
>>> folio_order(folio) - 1 to new_order, making it not suitable for any swapcache
>>> folio split. Only uniform split to order-0 can be used here.
>>>
>>
>> Below is the updated version:
>>
>>     swapcache folio could only be split to order 0
>>
>>     non-uniform split creates after-split folios with orders from
>>     folio_order(folio) - 1 to new_order, making it not suitable for any
>>     swapcache folio split. Only uniform split to order-0 can be used here.
>
>LGTM.
>
>Thank you for updating the comments. Looking forward to your updated patch.

Thanks for you time and patience, will prepare a new version.

-- 
Wei Yang
Help you, Help me

