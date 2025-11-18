Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F1F3CE8D6B
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 02:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A25A78E0009; Mon, 17 Nov 2025 21:10:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D6428E0002; Mon, 17 Nov 2025 21:10:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8771F8E0009; Mon, 17 Nov 2025 21:10:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 728ED8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 21:10:55 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 16BF6B84D6
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:10:55 +0000 (UTC)
X-FDA: 84122099670.03.B2655BC
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3FFFF8000B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:10:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ox5GtodA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763431853; a=rsa-sha256;
	cv=none;
	b=YRHhRXdim5LdthTKr5Mn/jE+6usKxhLjllVkJQlSwFUyH8E7N+v+s5Mlg/tUvsmxYlEMbt
	pLWFnAJdwRMn0HfXIo8Mw0UeeHLM6PWdcxrCb0mUi5fqWC4lStbJD8NVOFmMtQ95vgiuAt
	I93yHo4TbYJD62bwRAH0uiSYVzX5Lm0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ox5GtodA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763431853;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bn27PV1NQyQW5adlr3BFbo8OCqtb0K+HmUmI01lKONg=;
	b=FTRBj0eSxxCIIVIEMjfC7Dw1n+O00QekReTBUVTCVnm3rtzAsp+DATtzOUIJcPPtKA05x2
	nApNckpfCUCoEt8XPpGIlUt+Y6Po7VTAMpgATUOc1jAsAnqUjJRqkaE9te45t2Gb5m/zP+
	GwKFm4Ipe8RterD87FpZxXbMhsYe3LE=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6417313bddaso8076099a12.3
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763431851; x=1764036651; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bn27PV1NQyQW5adlr3BFbo8OCqtb0K+HmUmI01lKONg=;
        b=Ox5GtodA6LhFIjdR0eKyTd0zWjxfWzh8E/WzY7eVfQnLqHQaSu+LLRkkuWEECjbk5I
         LzFa+uvsFRcwBIdL8Q5pfCB5tLP5UWnCjQ9j/pl21XBKuO67wZldS9kzXsyJIVwhoWTe
         wxKebPvXP4vC1kp5Gs50+7UAlKGhbNcSpKu4g8iIU3lPMR9pzYf2htjW+eebMuAGfrS/
         gkEATPmItFPMs2Gxg85GtreT2KOByNeIsJN7qTTC/FTbAQJrDifWPQR/pjvgcFoV+I3V
         FsH5WrDfwiEnAMn4QOfCQFptZr0qZLWDPRCZ6biUeWmZBlcQFPA7UC95TEjOt2jlQm2f
         AcIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763431851; x=1764036651;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bn27PV1NQyQW5adlr3BFbo8OCqtb0K+HmUmI01lKONg=;
        b=cDF2AS58yUlDEHW8lkzBQ8SWbWV5ALqySGO0aOYowUy69LCpKrGS7AWJ6GKSYKmtrR
         KuX4SOQhjVbSad+KW4qejtdXqcMsjQOoVXG5o2PXOXH0F7Zq/X+SZTn+nxp67fFxh/8w
         e1Zo0sn0eydjkjaPRy1xsyan64UIvxenhodDDxaXrHU1LZdgUOvE3Hyg/iXcQiAx7gMV
         E8i4Xen4sFSgz5zEIYQ6QRrXict7bD8Ax2TUq8ygfGs+WEHkHEihDYBCX/f4i3sZjmbQ
         KvoLQZ/cW/2HsZ8pf5BF467M33zZOMAF0RpI1y+6M2mKEGrqJXPDIGs9VeJeE6FlKU2d
         DaQw==
X-Forwarded-Encrypted: i=1; AJvYcCXSsMSR9mYsD+1Kb14Bwtx2x8+bzofgSSarIpLsi/SNT67ABFdXfw0LyaH+IqI6apAE386H7P4IMQ==@kvack.org
X-Gm-Message-State: AOJu0YyS3FUflxryzgvKvbZU9xFHqP3V8oc+9T/QIMQDZYSkgWRD0/0s
	w86qOBfJkw9Ba28hJcwWM+lwSmTDsla45d0leUl7GH2/xHv3M4R3fqajIp7vjg==
X-Gm-Gg: ASbGnctHJDrHvE0mR7YHXVtIxKpabehXZJTYIO8uzxG4QrsSW0lI3h5Oe1Pz0AbteZi
	k3yHnq1GALKFU8wlZNBDYVTGucANiYFtQXQn+N+RFJi+coHXoX+8hQ5c9FZ9kKGGNsNpvXxCilT
	oLZtCn7dj0O8oEl2Vozso2i1UNLtJ6+q7dGsZE5keahodiBlYwuNdAxnPx0rG9Zdefgf6tTxo8P
	tfe+Jm+z0eAhKXTiQkPRoebaPOuTOIiiMOQOvwv6nyEVyLK3vmcU6PbgG49fB52E/8LJrRD+20t
	Wq1GurZfdU0ZtpJYz7iY972aUOwhnBwa4fOECWaLCJKRgLNcxV5qob82VpGOcO5LWHdKSJW19op
	2Oraokv+UKzsJB1iE8EX5bpaOrd+YFnqm3hw+rERkH9uh9b02RPbQAbebPoRKmtjPoEQEkk79Hk
	RdJo0GQOGJS9nm7w==
X-Google-Smtp-Source: AGHT+IEyyPrGUTLMBcK8SiNahoyB+Uxp7MiYTSoMTdq8Yb+GvaLMIXZWRQ6Z+uMITOPjpK0wDkmZAA==
X-Received: by 2002:a05:6402:2355:b0:643:4e9c:d164 with SMTP id 4fb4d7f45d1cf-64350e050eamr13474944a12.2.1763431851465;
        Mon, 17 Nov 2025 18:10:51 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-644f13ff4d4sm2163701a12.12.2025.11.17.18.10.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 17 Nov 2025 18:10:50 -0800 (PST)
Date: Tue, 18 Nov 2025 02:10:47 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v3 2/2] mm/huge_memory: merge uniform_split_supported()
 and non_uniform_split_supported()
Message-ID: <20251118021047.uyldr7aay6fb5evt@master>
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
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3FFFF8000B
X-Stat-Signature: m15oh1pqpikyeoo3hk77autuce8jm645
X-HE-Tag: 1763431853-819710
X-HE-Meta: U2FsdGVkX19vMp5h4XJR91P7MhpSR0MN01nFtcdomMS6Ho+3ZhG3HL4l5WhFAxI/ymF+iyxqq925Gtuylylxu+wa5HGvLGBwyjbnlFEkISkY8A0VD7cHMCPsZSfYXdox/pcmmCMjYOFVKk2GoiZEeVWDY3fITOMQ1OlXXt433vAKre2K/kaxfecMRvD7k0owcIdyE9XKwYzSEXBEvRerMwfVMXoMhUT6KRAFiTaRwMcyhzYNRUDHSHThCnm95kc+HcfYWAMK97BsOMTlGrEpvOwVKWfChX/47kYFUoujtD6mzKRNM5DgVR35t7nhSyAMx6w/aDolutO6B9uJQzq5HptcZvRQnHexqia7QMiNaxq9g7UWyVsyXtQcaGDFAT9dRUn21wWJXwgu4dOSb5hjGmy8X1mHBVHRDu4UrQSBBxmxdgo1Eo/izvTY14RXTWBcOOJ82LPMWXvGn6kp/EUk5b0HWHpSRBHdYWaixvkAiqo8Vs/d7v2679neW8YbZMPPUXxC4aRwfOymYhYC27N1f5sxvZ2Y/THcjsxo9sX1dridNrbNRTgpqkiaDVZ/AhibbojkuV64PZ1jkLoeS0ZqyTOZDXyG3H8CfdPZl1nhYjf0e46d9AyAXVjjNzwM0TT8YdLvSxg0bY5/0/DicXVJy/vsmpswuRjQnYNWwyuJM1oFLTLK2WIE/ofSQBI0iNoO6ar4DP/96/xolkGV4d7FoLAqzJC3Mq3ROvPT2D1VibEy2fOXhxmjHRTOE3Gbq+F+rQk2Xdo6nsjHnWMtnABTSP6C1J3+PihtatwIZ4b2/5Xy4KdYY9/fajZK+uNIPDo8TxRWsA+Hrh+GiN1ad/PWA780itBPLJhv8ih/4HqpIKhFkfvBBBnJdDw0+HHm2VPXOGo9LQpXQFDQzULLLjoBHqGqJrAbyjH/9Yvwi+JPWgKQER+94B/LOkaMB/ckWghQ52Mow8Dd1hENKRjil89
 Zp2BwOmx
 6ECmsCIBlZlazBTOWBrkGcyRAS/ovcrcHdXIx3DCNoNvdDwRr5JsjqmNVpNZITJhnghWK0RUXUw/vBzXHpxlySfS0RYdERFi25PghX4hs8ADKra0HXQ5+PuUgl9ZMahN0MwhwgGz3HiXFQMSAdBC9pBPHrlrODUnXwTPSIgU3NJVJWKxoWhTmwpeS5AAD23mOavFqoNDEIvuKcTWLxwf49JngvqjeQy+qSzM9fMw2TuDrN7QFlwqeWcMFpKm9zSCnVGBsx5TcA6BSUvHd4TQ/pWiFo5od+LVH2u6YTA4YvEvA3xffTeqTPuv7Iw72w1aSPS8w
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

Thanks, I will check which one introduced this issue.

@Andrew,

I will prepare a stand-alone fix for this issue and rebase this patch set on
top of it.

-- 
Wei Yang
Help you, Help me

