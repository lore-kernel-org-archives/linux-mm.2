Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 737CAC87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 14:04:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E38926B0089; Wed, 30 Jul 2025 10:04:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0FD76B008C; Wed, 30 Jul 2025 10:04:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFE856B0095; Wed, 30 Jul 2025 10:04:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C0D736B0089
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 10:04:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 75F6C160423
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 14:04:27 +0000 (UTC)
X-FDA: 83721100974.20.A8280D2
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6AD0C40014
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 14:04:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=fzFLk5MZ;
	spf=pass (imf27.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.67 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753884265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jk6Gtn926lXsIj4x4Dh1A7mGQexyVuqQFAqQu1Vz/9Y=;
	b=pa6iK+UvRASR4Tkn2Nrm0204wn3CyBqHcKFHRr3jUlTwnVWzaxmmpi3cP603K/Bw1vCarf
	yF1H/UZnNi6r6vqQJgInW0qjg4Wts4XdfLUglkYbUJdn3nqCFqHBS7MeMfGWSXxmmKzhSt
	0rkltsB6kTpWnbg/4TkUjVs38en5eyU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753884265; a=rsa-sha256;
	cv=none;
	b=FjSgaa6fe9AYwX1OKNR/nZ5nWBW1+SlEejZVSE8gTyn5Z0Hp2xSefvppQMcfEv8Gu9NkEf
	rYjcygv9K29trKbSQ6uiQH6b2aqXDv4DWlna+BD4JQ/11oNiTdAuL8NUVYq6KiQdI5elAj
	zFYawkG/gWW1Cvzf9TgBuUfl+Xv+KTQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=fzFLk5MZ;
	spf=pass (imf27.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.67 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-45896cf24ebso5772555e9.1
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 07:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753884264; x=1754489064; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jk6Gtn926lXsIj4x4Dh1A7mGQexyVuqQFAqQu1Vz/9Y=;
        b=fzFLk5MZuQS2YAvAfN6TREiVgGxHZ/2UksppTCNxRgiC01rPaR6D9UFJRpfCIHCuRq
         aHmIRVLXLEefpYUSIH4f77lhM7k/eCi6vMzC6jqC5WFg4qwDuTNN3gi9eq8pUmcFDxuG
         lcBTRiQw2wcMr/PJ6Pig2pffzGA8QHhTDyZh/wdzll6L/FKGIwu6HZ31crJ4+x94b19A
         ih3MeY9BwYWWKzyvLdrA1lRlYphCKGyHgDgKeInOCT2Y+bIymksrP6RoDXOBs2WpsY1Y
         Xxh8V5mF5GFfJ0VmH3ioV4egRvR2etSRf7ZDXXpBaXMPxdDo/CUxA92bgkPX2d9LQeqE
         q7Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753884264; x=1754489064;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jk6Gtn926lXsIj4x4Dh1A7mGQexyVuqQFAqQu1Vz/9Y=;
        b=Wmhjek19mwvf9oKFD2ZJYV8A1hoeRPVxFewWkAkPcPMR06UMQpitsGlPztRlXUHhHn
         vLJvX29KV/Z1cvBMsY5kJjGO3PznEifVWRTkOuGB0f49RNqhMN3k9HIgEZzpMuSc2TtR
         bCw0LoPP1242pT8Tlefq4abD6N126KGWWs1JDafmkAgLzm6b6LrXJCYGemYMg/arR3Ec
         sz9tmfh5IvnUV6iJ7c7mCkKXeT6Fx7vQIREakfjRHoQMIONYXsZiM3c5TOrybaf5yiGZ
         YCwUi/xmtBLH0BEGXO7h9t8njGDVmGHQoT4ZG8Xgo/LvF29QmvVH2zxdMprCDW6hIuzh
         /yYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWkBsxn+WaM/UtIrwi6naXp/ImeqKFavbhLwF82Z3a2f9ADakwKrK9kWOGAFkGUcgtmPdS9KMj9cQ==@kvack.org
X-Gm-Message-State: AOJu0Yy+vwT+9uU3nryRfgJDxHfd8Vt8xGgWBvbr/X0PUUUdLoxABtbt
	Kw5cWCVWT1ldIsDhhlcxnIftehGQr57z0i8nH47HC7zMPF+QdGXqj73AaLqA9saWHlE=
X-Gm-Gg: ASbGnctgAMETDAPxFZAYKkXOB++qysEjy/HsPxMbHR1S47eCwEsGM0Bo7ym4LbADw6G
	LyIgM8wxzqogLpqSczrS2o4K/rqCUI6Ouj0slZCMA+R+AeNhms14Ct4dP3xX/ceDpX10OGCfKxO
	Ux+Pq2XORtAnSFHx/9xX0Psa6BzlkifsCwMca9qmBxbXuC36hqO7CglXetm83nwvNqGPo5uO+5s
	CDXkQtI669g203s2azf1a8R8g5aoIjPFSYPJGlzZzFlH06hK/xGP0sLgx6ORzHK0LTyra416C++
	bF+2AcJhyqr3kdQx+mJNNd53s42RtpTCe6/h0czRHhxEE8AWvxnSHqaJnyqfDG5rPuamMqVOC+t
	vxEoRN+7raDuhvd3GyZ+wDZYaMtuCJenPzVVYBxdX
X-Google-Smtp-Source: AGHT+IHNA6XybUky+XOgMeIdLaBli11kALj6z7ErPNCO0GKInoPJQDHw2ePlzrIieSLuzlwB0GbSLA==
X-Received: by 2002:a05:600c:630f:b0:456:18ca:68fd with SMTP id 5b1f17b1804b1-45898a828a3mr27912095e9.10.1753884263659;
        Wed, 30 Jul 2025 07:04:23 -0700 (PDT)
Received: from [192.168.0.33] ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b788f5f255sm10023729f8f.13.2025.07.30.07.04.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 07:04:23 -0700 (PDT)
Message-ID: <9843578b-2adb-4f6f-b3c1-99dac003e2bf@linaro.org>
Date: Wed, 30 Jul 2025 17:04:22 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v2 16/29] mm/show_mem: Annotate static information
 into Kmemdump
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, tglx@linutronix.de, andersson@kernel.org,
 pmladek@suse.com
Cc: linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 corbet@lwn.net, mojha@qti.qualcomm.com, rostedt@goodmis.org,
 jonechou@google.com, tudor.ambarus@linaro.org
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
 <20250724135512.518487-17-eugen.hristev@linaro.org>
 <7ecaae9e-a088-4c1b-9caf-6a006a756544@redhat.com>
Content-Language: en-US
From: Eugen Hristev <eugen.hristev@linaro.org>
In-Reply-To: <7ecaae9e-a088-4c1b-9caf-6a006a756544@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6AD0C40014
X-Stat-Signature: jdm54c7rcuups77n7erg5toxqner6r97
X-Rspam-User: 
X-HE-Tag: 1753884265-646505
X-HE-Meta: U2FsdGVkX1+fgrYU4P36eJ4rNBZeEhgA4kXaYSklH+5NErCFtjeUKlen6dMl7p194AldSKbnawAu1ngT0HVbMWg4zDNHnotmqzqGdzyyopxKeE7pmF59+Y/rOQ4MkmV4zGxFJUk+5sXDGRjcobR4CtzHTE8kWFuNG3ZEsmvVW6muVBdynQ7X0DLMdyQPHtXje2CLIdt0EM5GaJMabGNmPlmXJZ9lvBrAiqr3G07OlJMZ/89XqiF1H1X4KymQ3RvtIT3+i52KjJQ2oJ294DJBehBzfjpKFWVr/+NVEhMho9rAzH5CZSL7Qd9ibYEgKgCST4lvVVR4r5tomlvGd2Jf2jqMGMuyafpiNXEfsBPiHGN6AMp0tndcsYViIGtzHnHpV8MYdUW/X0PJ7JDljpw+KGP+1Sf2k8PWmSZF5TA0t/d4Sa8qi6oklJKF/LDSM7JvaFgNKbXhKxZKBQj/vD0N6JSTeeKbV9qxBTPyE6E/pSJc3RwdIJXVgcBTl8Egr27jHsGRY1PTTd/ZG/R0xG8RCgyTFyhoF6hvzTp/gDg1f3AZe7HSxQmfkQ1zRQnbPVfp6GTwjFu7t5Xh1+fA5WGKrFpLzHnhPgXKIO25nBw8AimY9PHKpSQKL9jDrGC6um0ndyu9EyuQBjT6LK3tQnZwfzb8MJ0BcVzn9glPOUvSzna2h3bRPuPOehsgCgTjwRngOgHXDxzTOa8i+7r9eL/63uzEyqtC7v7CS9fvCoIfHAscg6iDD9qDfYOLpNwJt7oUd65UiQhFyQ5nrMv2rOyH4ycSyxawtY3A62rzm32lBG1Lzfhewp3cEqJn/I7ZxH8dAw8yjligrrfbnOGUD8eGTp4DWebiiDRiHu8HGJX36sdWRjtelbttjHwrjjIm59qV1dNjVmyn2TlxctpYmoFtFWf5YDf6f++9hFYtO3vAftUWup8oWy873vEKlKKZt4xZZx/lGS8089J8MB9lfql
 QIyR1IDN
 dvd11jqkBM3WvSbodWNpTik+dTm9Ja9pQOFEj7nXL6QHJHnTj632YifgTGcf5A20pbS4KpCwK8OymmkO8kkHobBUQk1pPPtx8KclgIVAiNLins5c3pUYBX3Qks8DBWBUTLkutNZmguLXuI609uxsfyw6Ovhn5udVVPXmnVQR7KpNFxTDfKwPqHsfDUsXe3D+9YX2kZ2MDdwzmirTKimk2PjpK3ZT0mCn44eXzl+PEbALA5ZDpPjsbaNm96Ki9Q45D004xt2TN3h4kkfZAk8Jyvv9sH3yyv6i2vzWZuwTnwC50FrSMRFSDpJzR3Up2Df1NHLZic4CIapiUnXQF0uDYK2JrNpgJchlCkrsh6Pyj/NUZlNAXUFRqUcu7UaYnhQAMkWl8IyDYYlhdtCa1B0Kw4OVhMxyfqEPBRmYawYhNAk6Ks+55Ct3VhV33an31pF+T1/iXhsqYXcCQQycheAYhDh9Qofp9nn+HyPW2d6fX6QhfZsJaFr9VzbTCS7KB/3Cd4gqcBWcNnlgYW39mujf1Tsmg62tamE074hzOYqyDAt46qlYWGI+Iav4RCPbvA7MQbVHD8FscS4EC1tBJ7ZUSc6Pn56UrGbQ4SYYxCpdmi7P4+HJyfcsZgj7u9Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/30/25 16:55, David Hildenbrand wrote:
> On 24.07.25 15:54, Eugen Hristev wrote:
>> Annotate vital static information into kmemdump:
>>   - _totalram_pages
>>
>> Information on these variables is stored into dedicated kmemdump section.
>>
>> Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
>> ---
>>   mm/show_mem.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/mm/show_mem.c b/mm/show_mem.c
>> index 41999e94a56d..93a5dc041ae1 100644
>> --- a/mm/show_mem.c
>> +++ b/mm/show_mem.c
>> @@ -14,12 +14,14 @@
>>   #include <linux/mmzone.h>
>>   #include <linux/swap.h>
>>   #include <linux/vmstat.h>
>> +#include <linux/kmemdump.h>
>>   
>>   #include "internal.h"
>>   #include "swap.h"
>>   
>>   atomic_long_t _totalram_pages __read_mostly;
>>   EXPORT_SYMBOL(_totalram_pages);
>> +KMEMDUMP_VAR_CORE(_totalram_pages, sizeof(_totalram_pages));
> 
> Tagging these variables that way is really rather ... controversial.
> 
> As these are exported globals, isn't there a way to have a list of what 
> to include and what not somewhere else?
> 
> Not sure if any of that would win a beauty price, though.
> 

Annotating the variable was suggested here :

https://lore.kernel.org/lkml/87h61wn2qq.ffs@tglx/

It does not win a beauty prize but it's simple and efficient at least.
Do you think it would be better to gather all the annotations for the
globals in a single place ?

Eugen

