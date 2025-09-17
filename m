Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 436CACAC599
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 05:43:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 817908E0002; Wed, 17 Sep 2025 01:43:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C8558E0001; Wed, 17 Sep 2025 01:43:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6C88E0002; Wed, 17 Sep 2025 01:43:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 59B888E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 01:43:52 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0226C1603F6
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 05:43:51 +0000 (UTC)
X-FDA: 83897650704.11.EEB6906
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf25.hostedemail.com (Postfix) with ESMTP id E457DA000A
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 05:43:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=rcA5J38U;
	spf=pass (imf25.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.218.54 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758087830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CW6YRUB7XWZg6Z0QvIr5Jdp9CvsPmVtxl4KHm6Wzt7g=;
	b=YcYvijki+LbFlFdtSB2LbUo1ElIsrXvbm02ELt0ql2B8yarp8Kpcx3BG7p0XzqDhwaQs7R
	YuD5a8owAxtOuSmiPIzNiJ+Q5XRnLL2RXQtKQLDSXxCd3Aql4ny/zi6ldksuAnvw8FIRtY
	Te+VsSz6MsbnWWRusma5u1xVhKGEc/E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=rcA5J38U;
	spf=pass (imf25.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.218.54 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758087830; a=rsa-sha256;
	cv=none;
	b=VCCCGeU04vwlOcTq5AY/dh07SpZ4RZMMEXR4XelfVtVSQ8KNyVIxtukTxSbgP/3TSznWxE
	4DWbZqO/C/4Q+nJC34lTH4+kbCjLcm4pckfVSup1rTsB/60h9qdp9nOzzpXt/nGIaIReZt
	E4gujsRfXxdhOeVGZUNN1GW5JvIMfgA=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b07883a5feeso1074084166b.1
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1758087828; x=1758692628; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CW6YRUB7XWZg6Z0QvIr5Jdp9CvsPmVtxl4KHm6Wzt7g=;
        b=rcA5J38UEQ95U4r6gPFZRCVvtx9jM8F1P4xmLSZNOfVZg07hqr2Fkq8EGdJmEyrnnr
         WlttDwqKVpfusASvgYz/a0rlEk/VauAU73ZzMKv6Rxiz8NRlN52Z7ApDn0Ya4R12yq/c
         G0MEyumUYHitFksFl4gHyeyWR5L9LTGqFGwUOLmD6O4KDskj4kPezz+2hf1jOEtHHqf5
         V/zp7BYI9ue1WislQBpzWtcW3KzStn02GBqGAgYpDQMIxDl8RvwzqYR8XbHhbhnXlnSP
         4Kr3rJF+KMMmiARmahQKfDxaWsa6wQ0e+tP6mlyYDp1Otr0G787NyyJGZQIl9tQ3krx7
         LZjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758087828; x=1758692628;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CW6YRUB7XWZg6Z0QvIr5Jdp9CvsPmVtxl4KHm6Wzt7g=;
        b=WTlOrROhgSEAKDZB7in34wlgnDj4ve7VMIpaPfEuwTXCDNcd2kqPistHWk6qlkj9FY
         MY+O3Q5BqiV4UEFSqhmDKa1Yc2RyAQDxoTJHMjj5hd1Fy+TQPG4wDQdfRJJh74pvVzXC
         cbNY0bh14LQI6T795FUnyqEd8PJcoM5qcTX+oE9QfaOEUlT/nSMWmoYbhtL1JXNSZEH3
         wQbSI8TgYLOwOztCCQBzGtFVoHTqtaOxPLDSNcJACpHztLfg3xPu2z7lu77ErNES01fJ
         294vZX6szloIWeWB07l9D67mp6vlT/pu8rD/609tAjF+F8glqK9sCyVLY7Hdmj4xepaH
         XV0A==
X-Forwarded-Encrypted: i=1; AJvYcCWuXo6EL6KaQooD8oxjq0I5952IY2FZgOzBxHNSz01P1d492+C/2GXPR/3Ut//PJSzl4iFguAxvEg==@kvack.org
X-Gm-Message-State: AOJu0Yz9ksBcTmomAmBKvk7SvYBB1zZGpHc1cIuF94Uo0mputxv/IdLO
	20QtGlC5ipKbNYLIUgJ43c12l3hgJuFWWzVg254nKZF7u79JvqRVusUs0sMKw0RB5Bw=
X-Gm-Gg: ASbGncvXgu6FYKhe2IMfJBvArJIRLo6/VFlKlQdtpBqBZni7KEJJISFcUqxtCEENizv
	NMOtj3D9kGx4VB+s6PBkqn9hjvvidt0QGe9QROSL5BBumdoAn+7ahEf2JVmz8BDSUU/KCzwj4x/
	MY05mmqPQNfhoVgiL1/ylewWcecFb101gdiuyIiq4F7xaFPsnOERhgfTJzlwhusZXlfffUChI3o
	QvmT84kwNbrGVFFPd2M9XJurNtSCVmbmfl19KKWL1y7qSvr/3hg82btg3dvq6iJBDVLJcCLWQ03
	9wlbrDKDMntroXnGfRlRYF2qALuk4arHkBd0UCBh4cYbYwA276Bu1nSkvWz54gpLewWhdpcneIX
	15n72eYHUxbt0dXDBeTEs/SXi1n2vwQ==
X-Google-Smtp-Source: AGHT+IEwTeAqrWw3yRYXMNv2Kyom1bFBunp2rNawKurYFNJfFiYeBaBgK7tfvL+8o/YQVxm7ewmS1g==
X-Received: by 2002:a17:907:3f0a:b0:b08:85d0:3d8b with SMTP id a640c23a62f3a-b1bb73a69abmr108132766b.21.1758087828294;
        Tue, 16 Sep 2025 22:43:48 -0700 (PDT)
Received: from [192.168.0.24] ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b07c6110c27sm1088029366b.66.2025.09.16.22.43.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Sep 2025 22:43:47 -0700 (PDT)
Message-ID: <8df2cf28-c15e-4692-a127-6a5c966a965e@linaro.org>
Date: Wed, 17 Sep 2025 08:43:46 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v3 09/16] genirq/irqdesc: Have nr_irqs as non-static
To: Thomas Gleixner <tglx@linutronix.de>, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, andersson@kernel.org,
 pmladek@suse.com, rdunlap@infradead.org, corbet@lwn.net, david@redhat.com,
 mhocko@suse.com
Cc: tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 jonechou@google.com, rostedt@goodmis.org, linux-doc@vger.kernel.org,
 devicetree@vger.kernel.org
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
 <20250912150855.2901211-10-eugen.hristev@linaro.org> <87cy7q9k8y.ffs@tglx>
 <87a52u9jyl.ffs@tglx>
Content-Language: en-US
From: Eugen Hristev <eugen.hristev@linaro.org>
In-Reply-To: <87a52u9jyl.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E457DA000A
X-Stat-Signature: inw6xuo7qst4xnk6nfjg5ccrti4s4sb5
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758087829-714020
X-HE-Meta: U2FsdGVkX194T0Ik9Uf5yWn/SNPQCcK+zgIhO1e4BQurHhVfUZkJvIQloPnE+cq3x3SimUxunm+4JHJoIrVgSz59Xl7LNiluzPevgYG5oJzShMMTu2YAu7pIvQ1zWAytoWNWbGa9OVmhBw2kVXZPjVfzRgdiRv8bxrQ1FkXRUbMvXTtlW+ouYhF5dbd7nRbwscSB84EYc8/C+4ZsZ6SgWSzhWlC/0hVrIf+cCiTLG92//NHk3qsqV54d5XqrtPfcfBi8gw86bpcpqOhIcowLxz1e0CbVjh5qSamoHUdP9lwdaXRxqtKWdq+sUFXjscxhtTZowf0e2QTYAL5mx0UCFEKcIBmcQQLYvmNbhqyAVsNv5cbP+a4jWQYvhN6V/L7BQ0aSCAXMUzGit1Crz2xoerdb4b9733QrN8mnDJ5EWSf/x4buzUWmFzoJVZ6+4KtXZXToGpDtwAlrr3DhgS8bQR/9r0sIbWP1CZNJBSslMmOXYai8pHpbvJanoYRSYzYQcnjts5yaeU66oz5yhCJ82Pgx7sr4vAigTfvI8cDznqJegrSoQeugD9FynHn40fl8iaxCjt9KWh5gQVksCCxjj5laUhWsVB7LHwPHm5DjeGugCHOH8/Mqp+OvT5Upa7hHU7rGIMKVkcod3ifKaxLo1iTd2dxTxw4AWXQ45GJE9HWMjF4FFnyhpnAeUkj2x/QaWz4QkQ0Q1ygRfWogqHUgFGYLSZQlREo2b9XJbyfSCt0vk9KlVMFWUf67uzL/fCO30BMO6OlOVTjk+hhalPyEwzWin4g06Jmn0JU3k65oNJ1wCwPXHOOg4n3jUTgN4XDJhRVDtRJDErW0C8a3JgGrZpQxkPS48Phj13AqGx90SGsRJG7cQ8VjzB6ucPNTSHWEiGm2RnqCIKeDDS4DiokdHNHm7WXXYkkvyKboMhNLXZFD3NHhmW0xHOtaVbc2PvHwAMiUS2WQkjpHIJtCxdI
 im5tukrD
 mCFlVjzko0zS5dm8pA8v5VRLnjcBEUoIxwdIpnxYIYWL8dXsV2ziBi7dtkDFm62l7KvghIh5rU89lga64vBriGUJBBc/XWHJO771esefBythCX6sEH6pXrlMTsvu6MpiqKDpIqKKHDB+yvlXEvFD2KDwkV3BVaNESyeC9kvD6Jjy5vtLC0HL3+W8xtGNXL1dP7XrC1pqeZOih1o2VIRdj8WbHBkAdpGkA3Rvx86OKqcFqYdZCL/+Igu78uTLhsl+mkGNHOuDPEQJILI8JOGYwSNwpYyR40vFgYL/KEwPQS0DSNNvipKz+ol6sCYcpRGeiALit9D7mKDTbW+b6Fz0HijCsrsGtRAM21Jx07Qmlcsly140LOjscBm2iOS7108v64zBGbTuYqIKnL0ZrCHVxiFBpzPD++sDOQIUTZ+bR9lOcUyXbJDna2AMaiomxnWKXsW10aZCb1w2faP4S8gHLECAJOOPlMzjGEElSTHLJOXOCqUg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/17/25 00:16, Thomas Gleixner wrote:
> On Tue, Sep 16 2025 at 23:10, Thomas Gleixner wrote:
>> On Fri, Sep 12 2025 at 18:08, Eugen Hristev wrote:
>>> nr_irqs is required for debugging the kernel, and needs to be
>>> accessible for kmemdump into vmcoreinfo.
>>
>> That's a patently bad idea.
>>
>> Care to grep how many instances of 'nr_irqs' variables are in the
>> kernel?
>>
>> That name is way too generic to be made global.
> 
> Aside of that there is _ZERO_ justification to expose variables globaly,
> which have been made file local with a lot of effort in the past.
> 
> I pointed you to a solution for that and just because David does not
> like it means that it's acceptable to fiddle in subsystems and expose
> their carefully localized variables.
> 

I agree. I explained the solution to David. He wanted to un-static
everything. I disagreed.
I implemented your idea in the v2 of the patch series.
Did you have a look on how it turned out ?
Perhaps I can improve on that and make it more acceptable.

Eugen

> Thanks
> 
>         tglx


