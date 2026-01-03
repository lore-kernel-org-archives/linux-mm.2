Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDFCDFC6160
	for <linux-mm@archiver.kernel.org>; Sat,  3 Jan 2026 06:37:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3478C6B00A0; Sat,  3 Jan 2026 01:37:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 308346B00A1; Sat,  3 Jan 2026 01:37:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21B0A6B00A2; Sat,  3 Jan 2026 01:37:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0CC896B00A0
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 01:37:56 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9522C1A55E6
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 06:37:55 +0000 (UTC)
X-FDA: 84289697310.12.F7D9B60
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf17.hostedemail.com (Postfix) with ESMTP id 909F24000E
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 06:37:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=xtnUSCQ8;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf17.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.210.169 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767422273; a=rsa-sha256;
	cv=none;
	b=7BjtHsmFJaqSGSXpDvhy6siBJREei7opUX3mGqsnc+6dflb23emg4496Mj6dl8RiT2IJ+M
	68gQqqGpZKKcNPVYkynzhW/sahXXAXxMq6ZCeFTYjg/t+pA0mY35QSqfkINK/hzEpLGTld
	PrEI3StQYQ+UOK3lo4/Pc2wEn6vPJpU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=xtnUSCQ8;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf17.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.210.169 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767422273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ByoD4jWST79BUe/fxqijcSiTeboyFHDF95yg254b5r0=;
	b=Lq5lL3QP2L99z8Es11TjbD2bAi4MDHfzPzV2HBozKQ93FmcqCmiH3DW6wSQh1SU2kYJzP+
	4aN3uuDtEKgzEauxNEwtzSSXP4lauC+h3QZMF9JdhQivMjk/TFl+uMOhUnYoy1MDj6NkrU
	1+BcJe/+vZKz7NRLrOWEOYNCLTqwVFM=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7aae5f2633dso13105257b3a.3
        for <linux-mm@kvack.org>; Fri, 02 Jan 2026 22:37:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767422272; x=1768027072; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ByoD4jWST79BUe/fxqijcSiTeboyFHDF95yg254b5r0=;
        b=xtnUSCQ8f1FqSMkd4wr0Z2N8GuVeQx2n06znqpGNAfAyeZKVygArZ3M6+1AmxYf5xe
         LBqhQfnl8vgtpzynNHV1/lC0t/o9dAqoVpr1V0HCExDaxh5MBFvPYb4NK1okbC5Vmo9D
         4PAcp+OLSoH9aGFfxAwZ6DYDcSZ6oNw9hVbojhKIU00pTXEQI3Nfp37XbGAhFsTlAcwo
         NNcaDJbUTgj4tKmUWhu/uK0UDcgS22Srk9vbPkLAjHIpuCyPQYE3X8GLVmhUqbbSSU6O
         0YDlj/uehEPsfXo4KcqjvZ1dSG4xEwBtqDiUM3VZ3gcv5Ja9dMUtwWwa7vP2CPjunKEi
         93ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767422272; x=1768027072;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ByoD4jWST79BUe/fxqijcSiTeboyFHDF95yg254b5r0=;
        b=b8izYVmPKu984laknVJXX0P8r2nZqlqiWn3Z1B77WjZfrjuaii3lCQ4uNjZj7uLZvE
         X9yUPcThwfH5E79oS/KUM3s3u3Axa1q6DxyvYMpOFFeg8e5E95a9NHmRwvVzNf/XBKwI
         MkmriJ1zRWMF3HCfGR6uAGK58N/lSCLCJ8Rr+EtcqZzvBq7l2dyaUUBsWQJpRWvCNOsr
         Yk58r5KF7RFotixmWy+2FXYbdLvq/moI9NEoLZ3ksa6iIs7RY5nn8YlD/STmCRIjTtDJ
         vsHLP5Y9DUiJIae7a97fbesf18HaViWogSRyUJXCa4AtMU67/y+b0n5jphcupDDLPw37
         nxcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbvT446em/ob99eBZehFy2s9lpEPszTvNvJqXhWNabuHOYd0KXhvfm/PVLieTezCdMp1JOH7YiTw==@kvack.org
X-Gm-Message-State: AOJu0YwTaxfXGniMlohXM9GXk/dTI50i+V04p19lZPZeUQKYWVbiYRB7
	g0ih1j7DF8CD3j3pOTTTrMJioKF9MrwIp4GMwFQnAy/k7Vb2Hrbc/iZpYWDQoBuD9w4=
X-Gm-Gg: AY/fxX6Xl86mdWOiLN0jUaJ/MGzS2Ct36QjIFQ+S44uhzZ8GXAVLu0d4bh1H/x3RYWk
	L5ID2sEoqekLSu3AACvXNd0n+dfnAxOi6+1mz5wTnsl55d8KlCzdzfmQeNqCsLOgMz4EJg6xpjC
	sGCk6NJhXfpDGiAh61d8gqGzrFxooCZYtNjFjo0tug1v3Q3rbiaX4qOiZZfYm2RwqduE6zUbl9a
	5F5YmZZJu5QBrKn46tDTjBnnY5yJAtsCJDcscLtkwVFkKHGIPrU1gkh+c7Rn8aBhQ9uG2IgFwS4
	OAZGUUSyhS0Lv7/0/6AkEykJOInL7qLt40qyJwdwXP/j3ag5wMivjJ3B1yQyb7b/svpNAB0un7I
	UPGcsJ2ToqUBqGF8BnkPBhLaG3cAF0GbzsdtqlnIi+o+u8KZBqT/nF9gGdh80xqrCxYy5h0R4VU
	1wjcgVtCn0dzjaWwcskOB76RJUUTkQiwS4vdQqWMVlyj7lNsNA5r5AHtoRoPhahCCq
X-Google-Smtp-Source: AGHT+IHOn/shxgu6O9AbZYxbJun3BCH+nZYMReTx1ZUY3Ku/Rcc6T4HDI4a+cvUWlCqKmwFxIHrgIA==
X-Received: by 2002:a05:6a20:12c6:b0:366:14ac:e205 with SMTP id adf61e73a8af0-376aa8ffdb4mr41042704637.67.1767422272279;
        Fri, 02 Jan 2026 22:37:52 -0800 (PST)
Received: from ?IPV6:2405:6e00:642:d187:9f0f:f4ff:8fd1:e7bf? ([2405:6e00:642:d187:9f0f:f4ff:8fd1:e7bf])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e7961c130sm36229897a12.3.2026.01.02.22.37.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jan 2026 22:37:51 -0800 (PST)
Message-ID: <8c7fcd35-3b29-4621-b4e1-df0c88a00cba@linaro.org>
Date: Sat, 3 Jan 2026 08:37:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 19/26] mm/numa: Register information into meminspect
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, tglx@linutronix.de, andersson@kernel.org,
 pmladek@suse.com, rdunlap@infradead.org, corbet@lwn.net, david@redhat.com,
 mhocko@suse.com, tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 jonechou@google.com, rostedt@goodmis.org, linux-doc@vger.kernel.org,
 devicetree@vger.kernel.org, linux-remoteproc@vger.kernel.org,
 linux-arch@vger.kernel.org, tony.luck@intel.com, kees@kernel.org
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
 <20251119154427.1033475-20-eugen.hristev@linaro.org>
 <aVImhhgEsHInebeh@kernel.org>
From: Eugen Hristev <eugen.hristev@linaro.org>
Content-Language: en-US
In-Reply-To: <aVImhhgEsHInebeh@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 909F24000E
X-Rspamd-Server: rspam10
X-Stat-Signature: ymkscgqt6uzrri3iz49d8u9t1nugy5cj
X-HE-Tag: 1767422273-656734
X-HE-Meta: U2FsdGVkX1+u2V7BTx1vQWyoTSNE4QzI4f/cGkjUYJHpnpl4Q91Ueh/q5zBRo4b1hdfN+Phm/QcS9UFEfrLhJYWE8Di4FFdJpdi+NMW4v2B+tnUSWLDGm0cY8LgFgN2gWcJvlNpYtbApfbkg3Y5FZyL6gtEo2bMyalANaJM5tCu48xCW1bWSAlUFAQ7otdkJgHm0yZ6JJVIAf2kcFPaTSdp894R5PTm8m+PMzIy/wk0qYgq0ZLU39Fb7nP0RH+Pc7hOUmL343oWlwFg8uODKiNMJ0zFdZ/QnOc0DWMsbvEKtAgh0QpKD3f3jhw8dNyYJzWXH0mDNdP8uC64/BqYTl48GNd2Y4tP2PR0NAyclILU9OQZ61fKM/WgsfyeZqhTarw41S7mgFfRPqJXdg/GThkPa1yiBqdcPT6+NNZXQXBXHz694zdStpNhlOqjQAl48Hdhs5Ygko5KOJForrbXjn9406G65Lr7io6RQxc+i3UDWd2exPkG6dIGOsc9a2hGhdxQWaDXqPS9Z9xyh5raIO1pKYryu06EJIfzB9NaEAhYP+5RtGEmNho9u11jjKw//AH9kKkGFNREEF+bF9ay2cZtoTX8O8v9fKilCPbTzpjxQjnGhMqSAg4v1NA8qy2lBp5uq80PBFETHGbnanXW4B4xsjw8fszJ7AyJDtLK4h0nSUKAyYlUxpiYHry5bQdeBJT7HbUwBW15fii3HJ2j0Ys0BtCUf2RQD9NdOilw0Gg+MLYP0TAbV5LTLM0zQqI7dEh6FXUt6a3RIzIfNjO2wHNsIq4W4qymoxXMyQdNtAbDJQnkrwzFWPUcxjobqDBW+a8mI0VmJP1OYg6Bta1DCAvThm57vB7hxFvXmSMGit5DHSiBvBCYJYCAapvG6GGTCuqofPGPd0ojNthCyzgD0l2wIqAYqRUTAYglKs11JzKjA66GXM3+8Ak9+ufDBTe9UEu17T6ORe5lwz+JugAr
 fNY77kBX
 K978cScjb0lPncKX83ajpgZr6SrIEvw4GLVwlPRUiCsWSCgsU1hlpEJrFMOYlhvZ6gcWQ0DueQSl9bA/1iWPecyB5z8JUHdknkk1SV3/5IZNFK8OSFDyFGBrVUmZOhz7tJxFVvVvNErj/BVNuCN0HA9UXdrihXhp6oWcWF2N18ckVkSRtSHTFu4t19BHPRdVdQCtM3YieEEVtuG4UhLax88JeJ9pJdXXObsnini6hcOD3lNUP6XNTc0YqwfkVWBIhrY9wlIsmi4UD61EeNkIlHYAGETmwrZYCkhs6BBhK4hSaejwarXKQQLvLANmiRg4dqDSBqQM0SHGPNPzotNOh/vUg2PFIhhDQguDqdKWhMMGuLSXbxrEeLRTDPZsyYx3SJRMCxuK0Bd0DP39fPHGnx8nEo4dd2oMV64CFiMKqjBfnseY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/29/25 08:58, Mike Rapoport wrote:
> Hi Eugen,
> 
> On Wed, Nov 19, 2025 at 05:44:20PM +0200, Eugen Hristev wrote:
>> Register dynamic information into meminspect:
>>  - dynamic node data for each node
>>
>> This information is being allocated for each node, as physical address,
>> so call memblock_mark_inspect that will mark the block accordingly.
>>
>> Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
>> ---
>>  mm/numa.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/mm/numa.c b/mm/numa.c
>> index 7d5e06fe5bd4..379065dd633e 100644
>> --- a/mm/numa.c
>> +++ b/mm/numa.c
>> @@ -4,6 +4,7 @@
>>  #include <linux/printk.h>
>>  #include <linux/numa.h>
>>  #include <linux/numa_memblks.h>
>> +#include <linux/meminspect.h>
>>  
>>  struct pglist_data *node_data[MAX_NUMNODES];
>>  EXPORT_SYMBOL(node_data);
>> @@ -20,6 +21,7 @@ void __init alloc_node_data(int nid)
>>  	if (!nd_pa)
>>  		panic("Cannot allocate %zu bytes for node %d data\n",
>>  		      nd_size, nid);
>> +	memblock_mark_inspect(nd_pa, nd_size);
> 
> Won't plain meminspect_register_pa() work here?

Yes it would work, but as explained in the other email, it would not go
through memblock API.
We can continue the discussion there

> 
>>  	/* report and initialize */
>>  	pr_info("NODE_DATA(%d) allocated [mem %#010Lx-%#010Lx]\n", nid,
>> -- 
>> 2.43.0
>>
> 


