Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95136C83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 13:57:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CEAD6B008A; Wed, 30 Jul 2025 09:57:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17FE26B0092; Wed, 30 Jul 2025 09:57:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0473F6B0095; Wed, 30 Jul 2025 09:57:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E6D066B008A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:57:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9BB131DA8A2
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 13:57:25 +0000 (UTC)
X-FDA: 83721083250.30.83D9169
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com [209.85.221.67])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7C56A14000F
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 13:57:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=x7XzsDNP;
	spf=pass (imf23.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.67 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753883843; a=rsa-sha256;
	cv=none;
	b=W2mp93emXAdrTKhrPh46g5qzcM45NV4jZKO+eqhAjsX78NIcdN7N/lZYjM4NLKDwRae4NC
	8A/kM6Hn6GFe5oVCmdeUoVcu1th0LGdxiyzVfaqYsEOxqEJtLsTwRijESuotP5+c+18Hlz
	xVEpvx+wKI0IJXLjzMuBPM60oAsfXmE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=x7XzsDNP;
	spf=pass (imf23.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.67 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753883843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o9x/2NmBAyKmjbcpba0SHjkvYUhTVea6LU5Wnmf6NNM=;
	b=8okAX09p1ZSjUKXrHDFr11D6mPCcvy5zCTOJCSiDczj5aHaEZ7tZkj33Hr7OWZXL60Wjkn
	4V7YfZ27BCU2t2GnpudfCt5sISq/xWZPlmL5lCrxhdlbChuOv8eHhBfXh4QLpU7+yeWeC6
	w0ps0m7OEL3/eM2fu5Ag++JtpLNeMo4=
Received: by mail-wr1-f67.google.com with SMTP id ffacd0b85a97d-3b78d337dd9so1608245f8f.3
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 06:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753883842; x=1754488642; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o9x/2NmBAyKmjbcpba0SHjkvYUhTVea6LU5Wnmf6NNM=;
        b=x7XzsDNP+JQ4nJV/yhNFEcn7FeF1fShg4QmlnULj6s/u1IPFKZcj8qH0hinUpF6BpI
         I3r1ICQ3T4WP4wQBqp5ZWDpNDC8hNF23kFS0PS220Baek8BnL4gIUp1oUDhvoyFzJm4Z
         6jAGHngYs6WdHbdy6MXQM5YS3obo6ph3oOlezY1YIcQUrF9n15V9bJR7D64tnQvIv38z
         yeKxMvRTg3cUI2nR9GLaOOnMb6si2MJozWfMf7nHiODHO/6popuBeYpveaqJw3f0rzte
         QsNwMyTPtwT+CTJ7MvOhDysbxXy0IcGmCPwmJlYS9PviDABdC2UNXdG5DTg8HMaQzKq1
         69tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753883842; x=1754488642;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o9x/2NmBAyKmjbcpba0SHjkvYUhTVea6LU5Wnmf6NNM=;
        b=pyEB9zsrINgyvxNtfOvvYFxpFia8ta43lN7n/vIKe4X6o2DvsMRB3WyAKZvQrLIIII
         D+SINTr+H4RL391hY4jUkrCya+iM9aiVnMrzV17S6M/4KqoythGrd0iwpbcIW+MPDab1
         UpMQcIsQMl1oJZTsoXebLjbzRaI/auyd2eJqNjj/6632Dj148Hc2GRAjoARkEd9iEQJx
         08ujRe75LkMgIMkk86vP5IlDodO+gv343tgAsm3nj0NNog0/WPUyrYwc+SS8xXyYyVqW
         xkIFzrS6QNgWFNGcIsJE38Jk3uWXZkfaqc7BDIW2AAhaokMoW/6H3eQEemFJyR4I7nv3
         kcRQ==
X-Forwarded-Encrypted: i=1; AJvYcCWl+cbfT1oqpc8gfuh9ASgNAI7ceF/knlDih4brmF2/gFrHOtAYt4oiab1kbG5fU2n8yU/cLgXG8A==@kvack.org
X-Gm-Message-State: AOJu0YxvKki5+g4ksvJh0VPVuH8iq9mKvUCB2Bk1kApxKWK+Pb7dcJQq
	XYxf690mBPLqPBMh4mIHjfvlekvoe2xbZugb2HrIGSafaIDioLz36zo0a584Sbj1c1w=
X-Gm-Gg: ASbGnctGdDJag/BOsGxR1DZd+vRdVR07CBD5G/aemsPNvhCKLRQwtWZv3aG7tjyt/Mo
	LNQhOpR2ZDBHftyTQxM3r+SmPaI8LSiEuTCVLtBn6gIRB7ITtij7oJLP9/ZugB55/VHybv6mFUM
	ox9ZC/ewIXgwBM7QRouIHnX2pNIw4gemkcLTI23UTNR9X5jF2nqjvkG6Z9R7DzzsvygNxiBrobs
	Z9Ga1jOZE/zWtcn5thi/liMRX+A6yCKDKRAon0/qF+HFfKKUL+4dSStaxKcHmoAFQaQtyhwgIx5
	Z8tZC1akCsT7eM8Z3Z7PofuaFIutbdV9XPFfYMJH5h5uzSytcpx5WLKSGr8258ERCi/HSSxKCFv
	Inajo+gXTAxfUuMnAO3/QlPWNhgzxEw==
X-Google-Smtp-Source: AGHT+IH3yb9aRgK/Q+bZ6pcZQPnb/X5dHJrsLz/8jaoiHMtgM6iMNWm/RCtsBVpSGygJWiFCkMusNg==
X-Received: by 2002:a05:6000:1886:b0:3b7:9a31:2a10 with SMTP id ffacd0b85a97d-3b79a312c5bmr433785f8f.41.1753883841744;
        Wed, 30 Jul 2025 06:57:21 -0700 (PDT)
Received: from [192.168.0.33] ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b795bf9719sm2807959f8f.63.2025.07.30.06.57.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 06:57:21 -0700 (PDT)
Message-ID: <e66f29c2-9f9f-4b04-b029-23383ed4aed4@linaro.org>
Date: Wed, 30 Jul 2025 16:57:20 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v2 22/29] mm/numa: Register information into Kmemdump
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, tglx@linutronix.de, andersson@kernel.org,
 pmladek@suse.com
Cc: linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 corbet@lwn.net, mojha@qti.qualcomm.com, rostedt@goodmis.org,
 jonechou@google.com, tudor.ambarus@linaro.org
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
 <20250724135512.518487-23-eugen.hristev@linaro.org>
 <ffc43855-2263-408d-831c-33f518249f96@redhat.com>
Content-Language: en-US
From: Eugen Hristev <eugen.hristev@linaro.org>
In-Reply-To: <ffc43855-2263-408d-831c-33f518249f96@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7C56A14000F
X-Stat-Signature: 948f4tn8azuhfq3rqmh5nnqnpu38934z
X-HE-Tag: 1753883843-469867
X-HE-Meta: U2FsdGVkX1+jnE0Jt2hvFzOC1uzUitfnvkgs4qI+JXEL2Xw/Ao4jYpX4IY5HTZ7zk1njQU7jFAAyqoAPlsb2sU8kbAmrzy7s3pjs5MBJZOnuchvvQcwDOhFvoCb99vwe3mAr+s0cjDZVrDlzFLRjtVbYAZ1vdRoKiYeSca6suUqw1fRIoA6hFzFtAUb0TFwg7sOieHbkvoT9fK2vyzwL8c65/uK6nZTL4rBB6mv2Byfb2c1e1+DytqfCiONu2arQHJ5kqwklymiKngspWdR5uMAP3ULPlt+p+7fl+hhjbLQ3mjsc2rBI2mBl74Y8os4cKPiuocLryVaY4bpofNMr8YMBXf2ErFatoohSmTWvyky4ijlNLacASCXpBpOe3wu4D6cJXZ0J0VGKbSt7iIAfMw+SryD/CiZ5w2npxZVFdNAR+EZLeMH1OByYuO9lTxwCklhYciDh/HTuu8G3TucnFRnFID8rZ52vMmYfj/gJTkqQiFoRG+rAczYFwyofkbYeuILY6LTk+JGVIHNPM3RE4musqwvvUWTk1E9g6nRfqcEM8TTa9cYlq5iGuWnmUPEMIwhxancIS9uUOXonr8wHmIc0EC3a2JQijSqhiYeQdWK5H1Ov/cYKAPKgJMRECzedtu+BaVJKbhMmeCVx70uSBJiKUrpsczOqsEUXHqJe+Jcosdj742D5KOwVcBFfCkn+f8zBu4OpWZTyxWDhLcG3/6Jlry8+o6d2nQoF5u378x35VZZdjeZ4J+QBB6D0yi+TJcCq6DPJ/Eau9aN4gVQ1JZrXsxnlbe6WeDhsN0Ct6+9HmDB+la+A4hYE7qdizCNXfrTzXGKey0EM94sX9DVwPrYOBhF8Uw9hbbb3y44pPIvByFvS3vGmqf/8nmGsucZkAS8cY6OrkrHoMLM0aKZnYcutRBs3j6P/ss7Q/yvaGQfgYSS1MPHgJhuCVvB/qTGMDkqyHkw2DwCeF1LqgOl
 uGb3oNhJ
 OxgFCL9PbXg9us0/HE4+hb00Fz8F2HiZVsnG2yhVt0JmjsTyJ33UypslD+n8tbxoZfC73W6XtNF4T5COH8ZXJKwgw3g9WhJQztKUos17kXus+4n4WGvH8JVd4Kd/HuRTO8c95YOjmHjsBvOpRM0oP+dPJhP9Jvm5R0cMdOEA594Hm/ccPo1uOMMJcqI8bHF837BIxJj4r9h6ReUvyN3+LY0ihvjtO7r2B01OcCIq39Xf17QbyI/rxjBa83ddqYmavssUms4AH5bKT+f6S2iRhu+O7bWmkHFpPZAXyAvsIiJiZmElejaT/nDStzTtxlgo0iRqw9AGAHocsBMxaWuDeUqTyaI6JSo/+tBLX8r+xtXWBZAidgmrxieF76OPmoNn8gpfFnPa1nczt3nW675ohCtj7G8Kd6z3nwBqd5cZT5MHADh+vBYtwfSHLATRDGmSLvMBHCMPUFyUMA26VeNIEtIB94bXVuQZdzM973JCj0PGf9qmj0SCN/9q9/TtzPJrNKGzOleBIWQ3rOtYuNnnReovkGsDrg/gkTkP4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On 7/30/25 16:52, David Hildenbrand wrote:
> On 24.07.25 15:55, Eugen Hristev wrote:
>> Annotate vital static information into kmemdump:
>>   - node_data
>>
>> Information on these variables is stored into dedicated kmemdump section.
>>
>> Register dynamic information into kmemdump:
>>   - dynamic node data for each node
>>
>> This information is being allocated for each node, as physical address,
>> so call kmemdump_phys_alloc_size that will allocate an unique kmemdump
>> uid, and register the virtual address.
>>
>> Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
>> ---
>>   mm/numa.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/numa.c b/mm/numa.c
>> index 7d5e06fe5bd4..88cada571171 100644
>> --- a/mm/numa.c
>> +++ b/mm/numa.c
>> @@ -4,9 +4,11 @@
>>   #include <linux/printk.h>
>>   #include <linux/numa.h>
>>   #include <linux/numa_memblks.h>
>> +#include <linux/kmemdump.h>
>>   
>>   struct pglist_data *node_data[MAX_NUMNODES];
>>   EXPORT_SYMBOL(node_data);
>> +KMEMDUMP_VAR_CORE(node_data, MAX_NUMNODES * sizeof(struct pglist_data));
>>   
>>   /* Allocate NODE_DATA for a node on the local memory */
>>   void __init alloc_node_data(int nid)
>> @@ -16,7 +18,8 @@ void __init alloc_node_data(int nid)
>>   	int tnid;
>>   
>>   	/* Allocate node data.  Try node-local memory and then any node. */
>> -	nd_pa = memblock_phys_alloc_try_nid(nd_size, SMP_CACHE_BYTES, nid);
>> +	nd_pa = kmemdump_phys_alloc_size(nd_size, memblock_phys_alloc_try_nid,
>> +					 nd_size, SMP_CACHE_BYTES, nid);
> 
> Do we really want to wrap memblock allocations in such a way? :/
> 
> Gah, no, no no.
> 
> Can't we pass that as some magical flag, or just ... register *after* 
> allocating?
> 

Thanks for looking into my patch.

Yes, registering after is also an option. Initially this is how I
designed the kmemdump API, I also had in mind to add a flag, but, after
discussing with Thomas Gleixner, he came up with the macro wrapper idea
here:
https://lore.kernel.org/lkml/87ikkzpcup.ffs@tglx/
Do you think we can continue that discussion , or maybe start it here ?

Eugen

