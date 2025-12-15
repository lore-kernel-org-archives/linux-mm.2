Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 069B5D5B84C
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 16:33:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60E686B0005; Mon, 15 Dec 2025 11:33:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E6636B0006; Mon, 15 Dec 2025 11:33:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FC026B0007; Mon, 15 Dec 2025 11:33:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3FB566B0005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:33:49 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CC71DB824C
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:33:48 +0000 (UTC)
X-FDA: 84222251736.06.C605879
Received: from mail-oi1-f195.google.com (mail-oi1-f195.google.com [209.85.167.195])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7D397160023
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:33:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=0pafP8yr;
	spf=pass (imf08.hostedemail.com: domain of axboe@kernel.dk designates 209.85.167.195 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765816426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aOeEbLkJ4NhNzPDHOpRcyVg6rwLKPErmDWJiIVC5mM4=;
	b=mZqSoKzv25fut8zSP6PHQ9zf2TArlUicii6k2zVYaNXO43kPVlHuu9bhg4/AdhDtk9VbyN
	URfddkJ2Qm39RgMS1o/M7h8YWzJb067tO3dMaB0uqX+a33RpjbUlxsy0Wc2doYolkrd2oK
	dIZzXN/PqUJqBzIKEdUYcTXVzijMoL0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=0pafP8yr;
	spf=pass (imf08.hostedemail.com: domain of axboe@kernel.dk designates 209.85.167.195 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765816426; a=rsa-sha256;
	cv=none;
	b=GqFNbUK2lhETKjxAtutD0ow0LNkGonpUwkrwAU5wLI1TAFMjr6i550NYmhscM8hL+Tp9sy
	8D5zFDc5VI8YQuUmAvB8804nS0QXnIQYdhfXdgBdUPv+FElhIS/IeAanUr1BWEnV4SOJ4E
	PDVe/SF52oAnLAd2s12XtxbdExcSHCE=
Received: by mail-oi1-f195.google.com with SMTP id 5614622812f47-450063be247so1644585b6e.2
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 08:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1765816425; x=1766421225; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aOeEbLkJ4NhNzPDHOpRcyVg6rwLKPErmDWJiIVC5mM4=;
        b=0pafP8yrJYX0zMhpjznqaN4aqBygvONdOl1FJwPAyRL/+BCYNDdpWm+JrtJL26uqS8
         lFSv/JAqTSu+4OQ0fZw9IpvBAjdXGuwM/Ix6uyD7HjjsI8akUbZcRF+9TX0v60EYuOYb
         MLArMi+vlgsOAiRe1508ufvHMKw5gLGPUm/4v0LBEftV6N/7ZHWZ/WmjGn2ryZwDEkLz
         +lGAjekdcO7rLFvadl+kZPs1+ViKmRILlIMUE2sNORT8y9f70ZIWsUQx4QqpHAU2pJ0I
         W/DR8SzjpRhKDUSb7l25xSRFvI5DOaGhsnf7cLgQnaqSZvcUi99BbDmSmZUiGYEMdd3S
         o7Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765816425; x=1766421225;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aOeEbLkJ4NhNzPDHOpRcyVg6rwLKPErmDWJiIVC5mM4=;
        b=cvDVXSJjEc3nbBuNik2h6XI3q9whxsUb72Qp88MPQw7hGEUMzNt2LLEiAm+Xo0y7I2
         /0VQ0q4/FemwN6/WB0I67tZpChzDooDeCVtw2Vim3S7gKusisf+ROjtOB1rwS4+zCCsg
         sDnUERvLaOo3Rxi+e86V7IFWYxWdBY0/561uwpf9Ns31Us4Bs2+kylqyHqVFxPS4Pceg
         y9b5KMvdFtGOqEHYi1RzypNUjtmRyNJMiwj9Id+9hrr+ldJ9ohAFCtFcc8KBm0HVBIsV
         Ay1PS51UBgi0n35O2RfmWBMgRaXUIcKoFHWHUcrbW9SsS/8EgdClBuUBAuMg+BzccPW5
         FbaA==
X-Forwarded-Encrypted: i=1; AJvYcCVwo+5l1ewC++EIoACIL9Gk6PFKI0Q69z87igkDLl+Da5v9VjmXo4LJdmMCzQxP/PfUXmMF+Flpvw==@kvack.org
X-Gm-Message-State: AOJu0YwiUnMyrKVCKZYWijsZZpG6Tgg2fCmNaWfyvNgZWhCsOyBKfl5u
	mUTAB8yYMDNRYi2kqcAyDChqoHNog+KEKoqEgw9zJIqhjZebLOPOlcppJAHQn0Xife0=
X-Gm-Gg: AY/fxX5vQAgB1w+Gcfvc70a196MJi5chEaZ6qyrD6kcGqxpqq10GXJKA0btqhdBiiVV
	3dOee2AUz1FLmpSp1DnyB72x2aajsCrspGN3KrpsuZEShaczbybxNg2EldckUN0PV8SN9NoEIy3
	finlO4kMkFSocvPBOQ3n1X1bXFbxaVPV/v9fkZ/8jleMF3yXg3t6sUJmw+ZH//7BjQJ+57Na2Rp
	XmJR+Dh2RIV/0ndAX88mcTRdrclYn0ZX8upn0srjtYLdGXSrjQ5GUWvv1jorpucp9gL1TXif0Jm
	8tl7k8ETBEY7aXAZeZzbG958K0OmT7r381PAD0bh1pPb/5O7e4OtQUsUadzQNAJemsd5ShGMYhR
	n938YyM8M20516Jq94z4zxH7k8TysD8nkMw0T2ndFwWafu0Vt/5QhTSoWPBC19uldESIKF9JnYR
	V8dh7HbNI=
X-Google-Smtp-Source: AGHT+IGCrHrQigzG5irmY6fvZHnILsW9Av+YdHaRrG3TJtP7ymKohcpyueiYU6zKEA/9ee1hWHdqcA==
X-Received: by 2002:a05:6808:bc3:b0:450:730e:d109 with SMTP id 5614622812f47-455ac989e89mr4518931b6e.48.1765816425269;
        Mon, 15 Dec 2025 08:33:45 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45598cf4858sm6448712b6e.11.2025.12.15.08.33.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Dec 2025 08:33:44 -0800 (PST)
Message-ID: <2ed0737c-2b2c-4f99-858f-2a4bc4a477ae@kernel.dk>
Date: Mon, 15 Dec 2025 09:33:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: retiring laptop_mode? was Re: [PATCH] mm: vmscan: always allow
 writeback during memcg reclaim
To: Christoph Hellwig <hch@infradead.org>,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
References: <20251213083639.364539-1-kartikey406@gmail.com>
 <20251215041200.GB905277@cmpxchg.org> <aT-xv1BNYabnZB_n@infradead.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aT-xv1BNYabnZB_n@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9krf5ad4ny65gc4cwsbskanbr4z6z4eh
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7D397160023
X-HE-Tag: 1765816426-291296
X-HE-Meta: U2FsdGVkX1/Uugv6QlnBKMc9oWaYX/uPbUrvvtHn7lNupMlywiQkfDa8s7LYYYlUVQeCnyGYM8Ud96su/fgscyGllv9Bc6teMURUuM8A+cUfN4C8BiMy7w7L6spOMTs38zCsRQhbsCsOPNjtW8WRSdXur91SLkXpjoseRfRd8AX2qYcrTSsVzOLPXwdhrb9Nd0ZzAzB6ZuoceMFt6mDQ4LRVFlAx5BeTjkJe1JaoZ6xqhfoHhTVOkRf+OxNqQU+aSve+b9fwTuMHQpfSq4qmNr17ijCIyl5OgaV5Dv68TPxJAVkf5ueHuhSjlluu3OsQ2H4dfWh/e94dnVgpA0fkv/vgcyUJEmh7sKL9Ce2Yhts6sMoEFing7fCGExFb1TtC1Anf39bm20Zw3NnRc1a2CjNa8ewziDsY1XLJIWkNa/dTEMpumRHfQvOeBCfnkzOdTAoZ/fmMvdNY9zED+BbUTgI403jAltfHf2vXAn15pKUZfDtVkonPzBSVfBnicoL8jqADYzs8a/GZEhFik94ddAztJUaNJtpGsqiVlCozv68S0V2RwkgrC90HxUOwTxcRrkz/hwA2dCzrc+L/vKwucll1j+hvmbcK4PjmnJDGISMwzMWiJJrxfjg2xlpmKqHHZnx9t9cgyuHsziccs+PRb0UVZN91VqI3HVLHVIa5rKn50vRd/7kxSZoo5F5Y2zYJqT1gpG05jvrCJ7127eSWBY+A3dleXWmdtKaa+H353K3mijlRVKsrwe/joC8B4zpGcYxg2ZFGx/edIiYQmqwU4duMzZzNDIP9XKjvbsGfG5awqpnOtiivprZuzrgFZlwKt3SuQ8EMz4gVorNt23J/+Sxm7uohwBPr/8AH147V6UYrcF4e7pm39+Pdm2oAqaQeByJI+YQ0iGXKjbYBMhCW/5O5Y9SMINl/ZkHTCU86LdR627oeC6avJNvpLLCF3eLM2tWpRDpT6lEZUKXy6Wj
 cpbg0ufn
 zPNXF5lwx6lUSo3FKdleq8x7Q1Y/enNKXYra/F9Jq87cfpXTcLOINYQt6n9vaIg0Fv/C4etqYxGtrVIx9gz9WYDWAXZej2pBGtSopKgtHwHgk/UXuDNbCbjbm8SEKeR0EM6X3wncVA5KqoY3lGLGyfNni7mtFQULcIc+QdM1Yk//QfHfegVJinEZekwi927+622gBQ7dYgbRwHWhKLNzLsdRrLrCEPr94w/OIOq0W/PoM/iOZTr+aap/oMVOOHG05vvT0CdcnX/8tNBuv0I5z/9uZAXe+mwGF1+t0Amm2dPz7YOARrYaSbI9LUA3lIS+5QsIxdJw0hKitCStCTWtiR5kMUl4aEfwNdeIMvPht7UFp/tFFzMVhW5nuWjiyJf86Z7DRg90Gv2DKrnjfCTBrxcLqmk9X2KSS1goZs4X7EzFBMyhgmqGxON7eQ1wR6XazctZ4C97Wo/5WuFwF2c55CP6+fb06WaZqzbfpuiYcwEeFjmAeSP+WsTeR8PvvZ1kdRid4LklA61Z5O376DKWwHkOmDNe6JON5YR7imQYk0dDRLO86TeHPbEC42mWF7/sxKc1K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000035, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/14/25 11:59 PM, Christoph Hellwig wrote:
> On Sun, Dec 14, 2025 at 11:12:00PM -0500, Johannes Weiner wrote:
>> That reasoning doesn't make sense to me. Reclaim is always in response
>> to an allocation need. The laptop_mode idea applies to cgroup reclaim
>> as much as any other reclaim.
>>
>> Now obviously all of this is pretty dated. Reclaim doesn't do
>> filesystem writes anymore, and I'm not sure there are a whole lot of
>> laptops with rotational drives left, either. Also I doubt anybody is
>> still using zone_reclaim_mode (which is where the may_unmap is from).
> 
> Yeah.  I wonder if we should retire laptop_mode.  It was a cute hack
> back then, but it has it's ugly fingers in way to many places and
> should be mostly obsolete by how writeback works these days.

I'd be all for that.

-- 
Jens Axboe


