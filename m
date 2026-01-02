Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DFFEFA3728
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 06:51:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 807EC6B0088; Fri,  2 Jan 2026 01:51:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B5566B0089; Fri,  2 Jan 2026 01:51:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C1866B008A; Fri,  2 Jan 2026 01:51:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5823E6B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 01:51:09 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AA1BA8AF25
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 06:51:08 +0000 (UTC)
X-FDA: 84286101816.14.16198E7
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf12.hostedemail.com (Postfix) with ESMTP id AAA1240007
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 06:51:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=cloudlinux.com header.s=google header.b=Dz8XunaY;
	spf=pass (imf12.hostedemail.com: domain of pbutsykin@cloudlinux.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=pbutsykin@cloudlinux.com;
	dmarc=pass (policy=quarantine) header.from=cloudlinux.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767336666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3hpQrTNwm3YyszShrc7DZ0drIuaJ2peMWnPJuSAGlVo=;
	b=61TkXL6Ntsh+x0FZZ+IjrzkIaRkFXwM1ukwk1+Lu7YhJ3ieM1PzW8DQvX/Mylk4+RkcJBb
	DgwTQWEvGjPzr57Wh/FOe3uxVyEOVUgPlN/hVTg6bWjX9NzG184G0sU1W7FCz3HDTHJKY7
	lnJSS5yxgqKU9H+zukxqINAipL0/F8s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=cloudlinux.com header.s=google header.b=Dz8XunaY;
	spf=pass (imf12.hostedemail.com: domain of pbutsykin@cloudlinux.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=pbutsykin@cloudlinux.com;
	dmarc=pass (policy=quarantine) header.from=cloudlinux.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767336666; a=rsa-sha256;
	cv=none;
	b=OuEt4z3vGUGzbayuShL6Aq4xTadc0IJUnhnKkvRhcE4GWoXaBdJ57vhZXAL6qX128s3AOU
	rqXhnbp0OF3HqRdrOWiK5x4lXiq1E29tXDZkWjpZwJv5wQ9lz9vbOiJbe+YNK5mrBlfL67
	auaik5yNws3fXyd0cUNCI4V0yG2nVu4=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4775895d69cso49906135e9.0
        for <linux-mm@kvack.org>; Thu, 01 Jan 2026 22:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudlinux.com; s=google; t=1767336665; x=1767941465; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3hpQrTNwm3YyszShrc7DZ0drIuaJ2peMWnPJuSAGlVo=;
        b=Dz8XunaYqsakJKbsEj+fBUnEbKw1kMTm43tGVt1p4aPAwFvnfDKNdeVm9v7USLQ2HO
         OmdB/aDdiVFyz8eaHoEvth9b+a42cYOOOPPRH95ju6mYbQTYgQi8ciNMUvI93IDZVbDo
         LgA4IjXNAdpBvxl6omUR+NeBScj0rukOOKMbQ+iSmNDcevHZw/MFNEvWFwML3SqnqmAT
         suHk1vK43qVIq2NU8YKZq2Qq4dX08Vd/uK0B3RAal1S9lkv3VkIeCt/YcLI/3uxEjg7j
         SWhK/o4Ngc5hOvhXc+gHzd+etnfuSdmGQ5nv+F7d0zuiOB7mR1/3/Had8PBKQnshV4Wx
         JqVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767336665; x=1767941465;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3hpQrTNwm3YyszShrc7DZ0drIuaJ2peMWnPJuSAGlVo=;
        b=rCFdHiZEIPSnaMUOXSS0+7YcGqFHU0anQEx1OhSFbYWUJpp02oMiCPekXiLTGbEAPr
         rnn6Ck4O/gZhKk3NgpYYAtlfw62afq8Pg5VguMLUN2ZPN8FdEteIolhkznLNnPaaZYUJ
         h8H+btwiSuh0qXDjKuv4PT3sbjHsLjks5WwMeFuFamPNXfYYYyTe+7mfbQpFHsP11/WA
         PnKuFiVdPgtVu7LJ9ZPm+IoXXakiuySFuYHG1DONxNYqLCoYw0K8XF5sF8sA124b0mSe
         VmHcC8OVLLqyAMcoLEE313kicGI3aFBcgt5XZLfjTuf3lqvpwQuaXjKaPDSxbt0qT/kX
         25Dg==
X-Forwarded-Encrypted: i=1; AJvYcCUzu/Ajt02uOZF6/H+UyhJeSuA3p8su9eEQ8DegoRaTJp0UMOeVsO/K9IYVY1mp9sVVNGrBTBo8mw==@kvack.org
X-Gm-Message-State: AOJu0Yyx78eaRlekwMswFjih1tWZVRGr4LtJYmbUiuoaaogAzOigB23i
	KVbAxgaeAjCArpTER+MiaO73mBy1UwyFFzr4KpRJZn9q7IpMnXU9pEMbioUvd67xrVM=
X-Gm-Gg: AY/fxX7+3Tid3NW6pRZu8Tx2k+oqFq7fz1rZFEEsJWtbycFK0HpIHlA9Rj9jtfLFQcb
	rp4oPZs1ZXkvhUoQprXRQ0pAKgEqjG6BdwoQjtvGHL4SGq05d7ltT8v8KgknxZGo16eKby//Oid
	uOHwFTdwiQoO2YDNQwrVi5p+7vsT+zrN6aAMdWwkHx6lb5yMaIAJMMw+R4q1k0aupZFDGl013mJ
	+SVe3q1Inb9m+/o+gG4Q8L4VoBggaqzOq+FVsnMhBajxy5csqkMa7BNS5fMu6h8QeuZWi2kyX0N
	6nNOJXUmnf1yNdTSDafuRJNMMzQ44vOQ4b53pcX2wOJvoJHEp9ujBGcYs709OnJsX29rMjgxnfv
	8shfNUtxTVu7QF9siK3aSfISfA4GjE0e90jzAKmzFc40b1dpK6WQEQrm3kYzBI39GFWcwUXAccj
	25RvgGb8UaZCs6kOznh31jvQ==
X-Google-Smtp-Source: AGHT+IF68v7S6jIe8LbFTO5ivrVeh6lbPhFlQxBojLvMugVBqe3kYYVhpxZgzhYV2iodtfZEG+eZjg==
X-Received: by 2002:a05:600c:4e90:b0:46e:4e6d:79f4 with SMTP id 5b1f17b1804b1-47d19557183mr554474715e9.15.1767336664968;
        Thu, 01 Jan 2026 22:51:04 -0800 (PST)
Received: from [192.168.1.92] ([94.204.137.252])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eaa4749sm84134006f8f.37.2026.01.01.22.51.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jan 2026 22:51:04 -0800 (PST)
Message-ID: <baefc4db-2e2f-4b20-b44c-eeaadfaa1c1e@cloudlinux.com>
Date: Fri, 2 Jan 2026 10:51:01 +0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/zswap: fix error pointer free in
 zswap_cpu_comp_prepare()
To: SeongJae Park <sj@kernel.org>
Cc: hannes@cmpxchg.org, yosry.ahmed@linux.dev, nphamcs@gmail.com,
 chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260101003227.84507-1-sj@kernel.org>
Content-Language: en-US
From: Pavel Butsykin <pbutsykin@cloudlinux.com>
In-Reply-To: <20260101003227.84507-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AAA1240007
X-Stat-Signature: kokrcur1r59gx6aarg79zaxen16b67er
X-Rspam-User: 
X-HE-Tag: 1767336666-903127
X-HE-Meta: U2FsdGVkX1/MjxLYTDHEkjh2mwPeeMWBkmavpQfKe3R09u4idFVbGMhVxXb4CImakWOL1kl8R+cnBGhcq3C18yqaDlUxXvc4fzPxJmxK03VnYrJ7ISTaT/LOXp+JGJISgPYm7uMFkNcsROAyabVEWxJdXUGeChbylziX1r7dBRtkFngLL96PqfA73Hv5jUZI8uDjVaek0R6NIm+TCySjIN6QtwLvVEZWn+Cp3AUFzb82Wb3Ls+nFuHo0yJ2BePnRhuIG8xdU4QumEQ2xOrO+YMtlaRQeboVXkDe0hnJ8FD3LaeUlK1OC6JtFSkUok0NT6wJazTfnPjLwR2MT71i8DJoRb5IBEKwcxDUDFGjzjdVpx2imqMBMvO6i8iMIW8PO2dHR/bhWGVQhvAqNN8F9YENNbWobpwQcewOskisQnP2gXWbxRL7Zur0+DinbNVCP78pyMFTRBRwqz7Rsif3GpZA2FXTXjSKdIHcYxRC3d1dTSxmvsrb/U6AhYC+oW7AHSFBMo0noH/MwUMz+9/gQaPtUa5spi+eoUNBFRWJOk81oaxnAuGlFQpmsuuqRj4bli7+aTtMKBzHjAUkCfKDycvLxbJUiZ9dJ7DXX+uVc/6ui3dnv4tfH2Du1lcuU4A1Oj5E0lrYwhA0TUcRNcgHJQ7Ow+ZIaajZOMIIsDYRje8MlFif1N7AOKmFYfv5WSOaGmBxOvuGfoNibpqBt4l6cJhy7puTpOqsBvrryWXGNLLIkksKxDfYN7Ieqv9ZG0JTnVXbwJAOE5ISQjWLfWo1luiZupdlS7HLTdaWqVh6ZD9/0PSupWiJv4/5uch77J2KC15T/HUkKvPFdClKSDIi/5KxDkwLaV+R6seUTDLatHZvZMecy0K1JU99Ngub5q+FPt11trD6LKEUI3JHm5FUgdThpJba++QPI+u3xE1u12p/qMSqXyKGvGVur+3PeBSbrejxDshszTCID2pWb+5V
 xdw03CEp
 zKPLaraCCzUdcO2dRgXHAz1QiHsPi+90oA0uoiSFDsJ8uH1680GWNkp0X5Ix+QE9u9lPmO+Lel6+6rG+8wlZqECQLJQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/1/26 04:32, SeongJae Park wrote:
> On Wed, 31 Dec 2025 11:46:38 +0400 Pavel Butsykin <pbutsykin@cloudlinux.com> wrote:
> 
>> crypto_alloc_acomp_node() may return ERR_PTR(), but the fail path checks
>> only for NULL and can pass an error pointer to crypto_free_acomp().
>> Use IS_ERR_OR_NULL() to only free valid acomp instances.
>>
>> Fixes: 779b9955f643 ("mm: zswap: move allocations during CPU init outside the lock")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Pavel Butsykin <pbutsykin@cloudlinux.com>
>> ---
>>   mm/zswap.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/zswap.c b/mm/zswap.c
>> index 5d0f8b13a958..ac9b7a60736b 100644
>> --- a/mm/zswap.c
>> +++ b/mm/zswap.c
>> @@ -787,7 +787,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>>   	return 0;
>>   
>>   fail:
>> -	if (acomp)
>> +	if (!IS_ERR_OR_NULL(acomp))
>>   		crypto_free_acomp(acomp);
>>   	kfree(buffer);
>>   	return ret;
> 
> I understand you are keeping NULL case to keep the old behavior.  But, seems
> the case cannot happen to me for following reasons.
> 
> First of all, the old NULL check was only for crypto_alloc_acomp_node()
> failure.  But crypto_alloc_acomp_node() seems not returning NULL, to by breif
> look of the code.  And the failure check of crypto_alloc_acomp_node() is
> actually doing only IS_ERR() check.
> 
> So, it seems IS_ERR() here is enough.  Or, if I missed a case that
> crypto_alloc_acomp_node() returns NULL, the above crypto_alloc_acomp_node()
> failure check should be updated to use IS_ERR_OR_NULL()?
> 

We have 'goto fail;' right before crypto_alloc_acomp_node() for the case 
where kmalloc_node fails to allocate memory. In that case, 'acomp' will 
still be initialized to NULL.


