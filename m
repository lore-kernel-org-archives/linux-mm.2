Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C80160A260F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 11:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RjrXchn8
Received: by kanga.kvack.org (Postfix)
	id 386CC6B05B4; Fri,  6 Nov 2026 06:36:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 337CB6B05B5; Fri,  6 Nov 2026 06:36:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24F116B05B6; Fri,  6 Nov 2026 06:36:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F20166B05B4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 06:36:12 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 86ED4140D07
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 11:36:12 +0000 (UTC)
X-FDA: 85404490584.02.408B7A8
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf07.hostedemail.com (Postfix) with ESMTP id 99B4340003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 11:36:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RjrXchn8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of krystianmkaniewski@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=krystianmkaniewski@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793964970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R1fgwrt/J2JYxCxSGOKH3dANX3eXUBpSh/LEwH4Q6no=;
	b=X5NrrFZGtCNMAM6h8UdCvQ7tzRI37OaUwSbr6XUfSQH5IXXK+ymtarxdAaQ12BC13IjgxR
	ja5WzDeJGq/kJi1xAYwFXzL3V6v6DXkKAv6AGlrIIQtTgpQ1I4ffFscJgvW6kt2O7wwrFs
	1T49BCnCzvxob4A9Py4WV9n301QBNo0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RjrXchn8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of krystianmkaniewski@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=krystianmkaniewski@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793964970;
	b=W9tgSA4obDs0xGS9wQwUcIC04a956mzblEwIw4yB9FybiQW4KH20HuJ0T5okce1NNEt2nl
	SrNrXQlWcpz0OqcRJaB4jAaAa53gAWOk5wcG0L17HdOoK9enfC0nTvtW4riusbvNSwOlYD
	2lVlU8tR2SbM7ofXNtkukTQMi/wsaSE=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b5669a5100so651800a12.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 03:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793964969; x=1794569769; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R1fgwrt/J2JYxCxSGOKH3dANX3eXUBpSh/LEwH4Q6no=;
        b=RjrXchn8Y34u7RtBaWPu9KN7U27ge7B404VoatSj2r+4/FAc7d2CMLS/He4fQxbiNc
         gvi3KKoC/LQZHUEPtdtgpIgkCI+plmZnfRUlDe3lPwIpvZBJC+CjWWtkgvEtmi1MlN74
         TXBt4WALO31c4+j3wWz8oTr7kPZwi/gCMdY8FJ2TFhzpUIhSCL2RJR8aGvbKJceu6aV3
         g2uIGd3uYwIv39+1xFgAvE5/PXyvPKnGPJqh8ZKayrnmYABr77p5Cdn/HACMXHRjrobG
         1obwtEXBWX3suUy4rl25D7tzM+3Hiv3Ta/e3HZxil3Tgy4vs2HLjG9YTecSWeNYHITfm
         hFJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793964969; x=1794569769;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R1fgwrt/J2JYxCxSGOKH3dANX3eXUBpSh/LEwH4Q6no=;
        b=U9QbBJ3z26szOK1CL0i4CHXuGuqzc5432oKLKdgGFkVB+tnKaUStltex+omOdCRPms
         O/khOpKWX9MSZNKahZF0C61XsFRzfkkTgGMmxSwpjpVj+hbtGs/rkuBqvjzJE2l+FoPO
         NwgbDWn9IoifEOV1pgUq4A8a6olcdB9UUDw9lVCmmulkGsNxezd642MOK4BWIp4XPe4D
         6O8u1Ad+d/Qk+MtcrUI30foQS8xuIV48BGrd15DRibe4Thbqe6bNKnpnxnyUog+BbPjY
         1dd8xdBD5ge0xf2/zgOkuSVSnVfjwIXDptPnuFg6E7Y2xru9xxhLN88VvnKHSPlMmc8X
         kFYg==
X-Forwarded-Encrypted: i=1; AKwUvBxOVCTux55JmuXhIWvA7OsvF6mKmCk3BDWqM9ImUPjCnUz3PD6GkQulGX9f+ISbrgwZSB4Wd8vwPw==@kvack.org
X-Gm-Message-State: APuU4Z+aCtJeeEYbhYTHFabgHNOnK4gEyAagiyGfS57IGs2J0oXShkGs
	VhicoRWlnsM5sld4l8I8wjfWy41RvXDxy6g6WHfmWi8wAh/qfq1wh1TR
X-Gm-Gg: AYBFou2EJ4kqmQidMjjT9NPOdebsx8Jqruurw1JG26Y0Vv0357MdcGwfcKxhNxq+58e
	t8RZMOolLSj+wBX4xf0Ktfo7v3EIv3iT9L9Ps2qmo++nlNd1nhCHesebogHt/h+y7qy8BB/D64U
	DHg/ZoOZ6BNWNIREz/CmoKRfI1rY0Pc8iSVM3VsLtT3efB/teLEoz4xnV/6XebBZvgHaQbr+SJM
	r5mhWeMLEleZZJYTx5CYDWLfneKJU3kE2ByhBUfS4saKYGwOfP1MKNjOhoIct/em4vadF8xn/HB
	Sw+CZf40fHn5p2kvzpkdv2lwXSBEHK9D6mNY4hukFWQPfOMRgfa3OHvyomlsIyOGYsCEf/M6Hk5
	fZMsdNNlji95TathEh2pxiin9B6tXLyGRMJrcDfWqhJqgt1QLdEdPwbPyM5xuDEbHSqLQC1f4MV
	DqrHfxDnJunyZVBceLWZmhIPx9DqRA/Tnst8gpBk1jNr5Klwdw3r1M12U82D6iy2pcrA1/Mq6aG
	9NfsJiPAhDsw+GLKX8gmihNbnljlWoASqbcmFYQVozeYp4GfO+ltyf78AfsMeNT4T557h9Rurqi
	ShWx/NqCjNn7vjndnCkAg33DiH7nfOFAAaYKR9kAkVIl4FYSmh1sQZnE3e6QUfJQt4mcQZhiedN
	gXevMC35jSxHZKQNQ9z/zDAnhVOuSKPFRpIz1jiwcyfwzuOSdX6VZvFhBK8786A3gtnUG4Wa4eO
	5Ip76jeoynwylionAToAJXksJ2HzPBXX/7xbEOYNOwkVQDD+HkSbO2UUh4T4ke7Sk=
X-Received: by 2002:a05:6402:2b91:b0:6b4:602d:f1f7 with SMTP id 4fb4d7f45d1cf-6b597816109mr1452325a12.20.1793964968944;
        Fri, 06 Nov 2026 03:36:08 -0800 (PST)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b664ae5692sm615592a12.17.2026.11.06.03.36.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2026 03:36:08 -0800 (PST)
Message-ID: <4284c2d3-75cb-4e41-aa45-f7311e60ab4a@gmail.com>
Date: Fri, 6 Nov 2026 12:36:05 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/filemap: stop fault-around when the walk steps back
To: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261031-jf-mm-filemap-map-pages-lower-bound-v2-1-21029744e589@linux.dev>
 <aunPI5eOUOAEUa8d@pedro-suse.tail5790ac.ts.net>
 <20261104-jf-filemap-v2-pedro-reply-r2-74c87c6fbcf@linux.dev>
 <auxvLCiljPhy0n_q@pedro-suse.tail5790ac.ts.net> <au0GBdGqu6cv5PMy@linux.dev>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <au0GBdGqu6cv5PMy@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 99B4340003
X-Stat-Signature: zmdmkscqngw8c44efnd15t7huy8eb1es
X-Rspam-User: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793964970-23257
X-HE-Meta: U2FsdGVkX1/r7gjhRfDI1RCSETHCmTKjJhcteOid2ZZFMvWpQWJPxRmme4npDtz6OPupfohbeWoqRzEtt9+09V6gqgPzquYGYB4wEu1WXupBZuTvabtBkWEVU/ckxGd1Q6xQug+CtQzmnvJdaIwbqwcKWwYzuxoCO03DxokbcZULs4kRsOZuUO8G7DDuY0fXhEpXFsvMNhO4PmFl31J8+avSlLlOqLBuW36PjDX2HKF6FuuBYiTcClu1j6RVDH3KaR9tmDOl81zsaQhSV/DHVJqoKJ5qRMIV82tl3Gj73xq9OFi40oxjhp636rM1m04yDK2klaHo3QghRrBxqM+X0xBqwGjhHEdZR+2i1FX0JTWolHRMvYqnWKVg0jdGFc8V0Nr9Zsxxo4wR4oIffCUQCociomv6z6BygkhDzC95edrjstjUqOn6QX9S1PXflkMFUmPvD2cIFU4fr2l5FxLF6SL31SSUxgYGU5fMH7MJoO0ZRfPIyTumoh42ETPJ7+DOg47+nDIFEkZcqQFO8abzpQWq4Gpv0tpv+J3Smh5xeyg11bVO0OXdFGrXapPDruq1jJ1eLWD8kzzNHzkTfFz/rdH1z8TSp0j1wcGFY1px8HnDsxmGvgeJFHi7ZOpOw2T5xP4WF8sjWD+vIkRSVDWp7qbj/gRy47U9yZT1EQWwxsQd2iHAMb6If3JN61Uz+8BrLpqbBTn1s7JTPNqu8ESLF3lo3vFuTbAhELKziLWsjnHp6cuwacesxGoO30QiOEiKremXmoi6K2Lb5OeCA0pVU4RElmTYFwZeops7cdZdgmBl4OhaXITr7HvzzE2gCIo1NLB4FDJd18A/cuvzIOcrKxwPkczuLMuF7s6mIXwe8UiAw6txjguDlpANKV1y7Es+tdFRjDBOQlHYBvto5MoiDLglETIcS6Y4RzBVIABYEeJltITwSafxmadelOuO0Wr1dFJfNIfVOVrFQP+lgWa
 SfOAQn4e
 GstrOTlVx5MlDLSuTaoSdNyl2qQarGbxIeCuTvNflhA1aO6siTpDECZKeHnfCZx3xK33p5qcKpt05kIp2A/Uf2/uM/KJqDI1vyzNLIdX74mbDQ9jBPJIvagQJFaiPwFtKvCKQ6mm87rNF2JAyl2eBRP45ZQiT7lnGofKxss6Z8opWKJjioDBA8iB6B2TVaeH2h40+NWnxEHE7mEpNLCVcAsvo1EoS22wmcnTuzhqcAVWL1bbCWTaPeMOsb0K4BoeS0Lb+qKdPXGRGIXcbzKm8OcE/2SUzq34m6WddZJDaDQvx3ZwIDn/OWxNtJaVJo6oDbAgXEAHbPW6rqNDcUzyvuTWsdzsksAMobL7ECFEBnG6DmWqRcfmdjfCSxoG/1cfGtQSuQP7zRjdxALYSY0Xzolw7c5DJb1916GAIOm85h3lxCXh9veq69ZkHh9wsQkg2SNZZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 23:43, Jose Fernandez (Anthropic) wrote:
> On Thu, 5 Nov 2026 12:19:13 +0000, Pedro Falcato wrote:
>> Thank you. So, if I'm not mistaken, this is the race:
>> First, you map/see this:
>> 	[folio pgoff 4, length 4]
>> Then, at some point in time, someone punches the hole:
>> 	[no folios here]
>> Then, at some point in time, someone faults another folio in the range:
>> 	[folio pgoff 0, length 8]
>> so you step backwards. Is this correct? Or am I misunderstanding this?
> 
> Not quite. In my test a large folio goes away and a small one comes back
> below where the walk started. If that happens during the walk's first
> lookup, the walk can step back. Krystian's fix doesn't cover that
> lookup.
> 
Right. My patch only covers the case where the walk has already
returned an entry. The first lookup, and every lookup after xas_retry(),
starts in the XAS_RESTART branch. My patch does not change that branch.

There, xas_load() can read the sibling slot of the start index before
a concurrent erase, and the canonical slot after it. In that case it
returns NULL, but xa_offset still points to the canonical slot.
xas_find() then moves on to the slot after the canonical slot. That
slot can be below the start index.

I tested this in the userspace XArray harness. I wrote that state into
a node and called xas_find() from XAS_RESTART. It returned an index
below the start, with and without my patch.

Andrew, Jose's Tested-by for the xarray patch is on the filemap patch
in mm-hotfixes-unstable.
-- 
Krystian Kaniewski

