Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4478CC87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:29:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9BB76B0096; Mon,  4 Aug 2025 08:29:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4BD66B009F; Mon,  4 Aug 2025 08:29:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3A966B00A0; Mon,  4 Aug 2025 08:29:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B22056B0096
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:29:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6BC5556348
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:29:24 +0000 (UTC)
X-FDA: 83739005448.01.C46D213
Received: from mail-ej1-f67.google.com (mail-ej1-f67.google.com [209.85.218.67])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5C3EDC0011
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:29:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=wtKm2ijd;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf10.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.218.67 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754310562; a=rsa-sha256;
	cv=none;
	b=yazIw0GVFewp1bsBBXVN4j1hBEpP9SJzM/q1D0VH2a9jiQ+O2K6tTT3DQ6JLiCWR6/VGsr
	7/LuWFsrecjGd2t4Z8TVW00ELzngtV2sOp3YcdzAKl1ZSp+DeGHggSgjQDniJ5pmkcpU0w
	beGMI4a/86INDDzTFr6iEIX18emz5hg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=wtKm2ijd;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf10.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.218.67 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754310562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bh2VbEr4+GPS+zCP6PyGLcsH4RZmjBkc+JIVLTQNkVU=;
	b=a3dZsXTyDfXSACKSzLLGLGx94Ca7h9qPw/j+6YB5hTsGq2yfM+5/Xjux5ldtTbSCn0aZTv
	MIFEEDVmYoPdF0wvhmOa/MWqAPKnCoE/CHxrfMc3sEmOSeCqogh9MQmTV8OCDg08+5uQbb
	ae9Y7U3kZwIpjQjiAy5XecC8+nTM9Zc=
Received: by mail-ej1-f67.google.com with SMTP id a640c23a62f3a-af66d49daffso557540166b.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 05:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754310561; x=1754915361; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Bh2VbEr4+GPS+zCP6PyGLcsH4RZmjBkc+JIVLTQNkVU=;
        b=wtKm2ijdyiqyFkew7epXzX2dkY9RD7CcdAkM61G0usjYphvLshTl0ETjs3Higk12x6
         yNT4SqfF6Jq/z42juyvls3vNX96HP0nInG61R1JxR+24gGPqDzyVy6zPFjL0eC8xFCxs
         mbv8fGG0botxUGNTLyX3+jOrX381dIqsi3ncOHjzZurrN3nqSVWfS3fvG6dxoRukg90f
         n7MiXaIYWBSWGH6AhZVFp7RLWGZjo4lrQxAwlIzZPsh9R6hbje33xsD/zYptLry+q+x9
         OzBxPdGWG1O/FBsSk6Z0fa3QRNFfhej14BmcTaqhYpWp1pYtOH+ZBLZy6lqgZWwUxrGW
         CxmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754310561; x=1754915361;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bh2VbEr4+GPS+zCP6PyGLcsH4RZmjBkc+JIVLTQNkVU=;
        b=pJFNoj6UkyX3DOiM1o5M7tZ3fYt1henpj9knErKX/qJgbEzp5Aj8jsJQywT+Fe5dIv
         cuVvra7SD+oePj8WiOycdUtp4bZV73o28Y58IyUU+TaxxFVnM2h7JwgOQxasAW/yYmoE
         JVo70PPlUnder4/XvRCFoOqfVwV9rPi3QPX3JoYs/O1Gy60EFvMrfZ5Nw3fJGWV0hvig
         eC6KW5qLtJaoyjywjnzns5hWt0BYYoEByi1z6sVE/5C+arC63pHS8KecHACrSoFRl55/
         mBzNfa+lw7BZht2rKAr9EDQk+SvrQNwYyxn/kpFENXIE5fPROTUcUYq6jeq1/zX9ShHc
         QSuA==
X-Forwarded-Encrypted: i=1; AJvYcCWHDuz3Xbb4YkjXm9NufSXP1OxARt+vSQEIuj8f5BM90GDfAfWxKO0oUqpIUp/GS9yes/2XI6SsdQ==@kvack.org
X-Gm-Message-State: AOJu0Yx9uul9dD5IZmS98UwEcGOtfmLOwP2MHZGk8GH6qndk7Lcr2myO
	w6aPMCtsxzwQGPbnoMpGJBB1bdlnCS/HrkbzgkxEbUAW9ZS+LzdBtE5uXp/68j4suH0=
X-Gm-Gg: ASbGnctMcZ1PfXRTUaTAglr7rm15p/8CNDjZFnJHCvQlQ1m6GuLnTe0CG5Ci/nLcAz6
	KgvAXRUw08t/8aI+kiBEjCRShtYVg1uJwg10KqY9K4rjA0GwSXLzI8V47OYGZYMjLgYikaBgfSm
	SWVCXhlKKEVtE0XjPPSCFZ/VGIW6cIPk5M/htkbthgmLsHmK4oAH8NjRRo5+uXRQPDl1k3IR6Gw
	6lBZGKzbJkqb5Y3QYy+FQG62vkFczY5gONhMbVvuX0HIskZ9B9waZFTvAvUugx1jttBUUOJHMxd
	jHFvMsq1vPRrgnNzrJ8MxMwKZGAsCCSV05CSTjqOwtJelcIO02mN6ocK4vUHNRBAVkPDN6Fn9bI
	dO7SJutVQZP3uHTLom6Qg5Cy4r6P2SQ==
X-Google-Smtp-Source: AGHT+IEosZgeKp1ejcWL+SBts1B/aCmksQ8kDwupILaEdVqhNGaIFVMrjj1IxUFnhsLruybLH3boPw==
X-Received: by 2002:a17:906:298c:b0:af9:68d5:118d with SMTP id a640c23a62f3a-af968d534d9mr304131066b.58.1754310560610;
        Mon, 04 Aug 2025 05:29:20 -0700 (PDT)
Received: from [192.168.0.33] ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a0a38aasm730599066b.37.2025.08.04.05.29.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 05:29:20 -0700 (PDT)
Message-ID: <f43a61b4-d302-4009-96ff-88eea6651e16@linaro.org>
Date: Mon, 4 Aug 2025 15:29:18 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v2 22/29] mm/numa: Register information into Kmemdump
To: David Hildenbrand <david@redhat.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
 andersson@kernel.org, pmladek@suse.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 corbet@lwn.net, mojha@qti.qualcomm.com, rostedt@goodmis.org,
 jonechou@google.com, tudor.ambarus@linaro.org
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
 <20250724135512.518487-23-eugen.hristev@linaro.org>
 <ffc43855-2263-408d-831c-33f518249f96@redhat.com>
 <e66f29c2-9f9f-4b04-b029-23383ed4aed4@linaro.org>
 <751514db-9e03-4cf3-bd3e-124b201bdb94@redhat.com>
 <aJCRgXYIjbJ01RsK@tiehlicka>
 <e2c031e8-43bd-41e5-9074-c8b1f89e04e6@linaro.org>
 <23e7ec80-622e-4d33-a766-312c1213e56b@redhat.com>
From: Eugen Hristev <eugen.hristev@linaro.org>
Content-Language: en-US
In-Reply-To: <23e7ec80-622e-4d33-a766-312c1213e56b@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5C3EDC0011
X-Stat-Signature: cj3p9nbri6ysghgsibiptq1q1jtprp6d
X-HE-Tag: 1754310562-913956
X-HE-Meta: U2FsdGVkX1+WpxgWiC7jKazEv7ds/e5mfOIhchGKpLYE/I02ABpwrRhdtgyoB+O01Xvl219NP/AUe+BW9D0h0DWrJ1Ta3ZuueyJp7TvDW+XAwkAq//WRa+ijLlECSbL9cZ+eX7exj6j8J3Al6aLUwhKUFGVMijA7/+WMxOMbydpfqL0RSBsmEYpJZgzNx9V8rJLR1jkLvGGCcQpPze4ZQR7WL+6EJT3db5Y3QlrYFYjk3Z21s35qnKAX5rwOT+4k+vzZOuXJlkdNHFv056RhvHreXDl/laWPrYxUaR+bbu/MiAiJ6A7ircxK9pu9jS7L5OSZlUaaMuOaYCwBzKUgSvREKxC/OnYOyikQ/+FHJnliZZi9XOfp7pQm35NtPanugxnlbGUZJDcOKdKNuj6isH7xAFS21Ek6sDQdybvSe9T2/u2VHfovPDOXRMXpQa7RI1/wSFBce2MCS0V46WtlWKXjAOcGbYb5r5nDnku6wJNDw2tP0eQWVgyKUCg4qCWAVRtxBxRy2SIZRHEaBTud6/Sm6lYRQvOoDOZUhj/njtWaoNmrWNu2b9CIppaLTx3DySDVqcg4oeHKqa+JwW97gww0ckAginGr1smP/KHcTSONKYJ4fj0fpbITrGLZKNKnNO+XdSV/VHcfWWTYhxamPNXI+Yqd+YXoZs/0MIWTerwWmJdal21v+pXsitz3xRsHGlgGAV9+UEoOCrF7uJAVAFGNRv+ubCeOSdyVZ7XkiuXoFVsFzZMsr3Os9keNy2HtuufHQyJMie/3Rs8o7FpfiomFFUulqtM59TiNMHpOsSxxkdI+Rn6cRMd4x0uxIK+Z93A5ZF7YZKfzrJK9lTIYcYlNdE09pO8z7Fa3Hfl3DBXKcB6c/cJWSeRZ2XyHm+aewJLAkkRXwSBNx30j1ZKAV28T65BbmxB3wzBMJm9wmfiYQS2ELN2zOK56Kpb1nvHVb5uLWK8D4icZdA5ghfZ
 sfP6j9Ln
 NQU4njkC4ohlbJDzpR82fGlytqia6VgpQ4jVlrbLWWyYQYHmfkYoz5UdbMFr0onWq8EAZ8VBYtLR3OTw2/Ru9LULoT9NJsHTEhXeR4m7y7Xqz7LkLx6M0GsUVNHtKsDo5OQ3O96AnG8hiFRGKMBFijR6Ur6CPs4/BOngHeOwcEy728eV/W3RYq+5pHv6gHJ1tNp849Of7UMBJxRxc96DCJt8A38QL+LAco8vIEzgN6Q+ZHXYapeRlIAJuKVkcuoAGzK/N8te1iS3Zd1CKH41KZbBV1jm3jCSTUJ9dncHZlrZqHzT07bDG29nfDxe2cgadoRPuTVkE/wCBDxTt+IjoYEjtT+zjDK90nvrI3VNM8Uq+lhAX6vxOWBXDt3V4EFfxymBK4rX/bpnDanqdIiyVWEaokqTcpAGDpPLuoEeQVRe/R1t9+obUWjy1bsjXGVoTG7jh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/4/25 15:18, David Hildenbrand wrote:
> On 04.08.25 13:06, Eugen Hristev wrote:
>>
>>
>> On 8/4/25 13:54, Michal Hocko wrote:
>>> On Wed 30-07-25 16:04:28, David Hildenbrand wrote:
>>>> On 30.07.25 15:57, Eugen Hristev wrote:
>>> [...]
>>>>> Yes, registering after is also an option. Initially this is how I
>>>>> designed the kmemdump API, I also had in mind to add a flag, but, after
>>>>> discussing with Thomas Gleixner, he came up with the macro wrapper idea
>>>>> here:
>>>>> https://lore.kernel.org/lkml/87ikkzpcup.ffs@tglx/
>>>>> Do you think we can continue that discussion , or maybe start it here ?
>>>>
>>>> Yeah, I don't like that, but I can see how we ended up here.
>>>>
>>>> I also don't quite like the idea that we must encode here what to include in
>>>> a dump and what not ...
>>>>
>>>> For the vmcore we construct it at runtime in crash_save_vmcoreinfo_init(),
>>>> where we e.g., have
>>>>
>>>> VMCOREINFO_STRUCT_SIZE(pglist_data);
>>>>
>>>> Could we similar have some place where we construct what to dump similarly,
>>>> just not using the current values, but the memory ranges?
>>>
>>> All those symbols are part of kallsyms, right? Can we just use kallsyms
>>> infrastructure and a list of symbols to get what we need from there?
>>>
>>> In other words the list of symbols to be completely external to the code
>>> that is defining them?
>>
>> Some static symbols are indeed part of kallsyms. But some symbols are
>> not exported, for example patch 20/29, where printk related symbols are
>> not to be exported. Another example is with static variables, like in
>> patch 17/29 , not exported as symbols, but required for the dump.
>> Dynamic memory regions are not have to also be considered, have a look
>> for example at patch 23/29 , where dynamically allocated memory needs to
>> be registered.
>>
>> Do you think that I should move all kallsyms related symbols annotation
>> into a separate place and keep it for the static/dynamic regions in place ?
> 
> If you want to use a symbol from kmemdump, then make that symbol 
> available to kmemdump.

That's what I am doing, registering symbols with kmemdump.
Maybe I do not understand what you mean, do you have any suggestion for
the static variables case (symbols not exported) ?

> 
> IOW, if we were to rip out kmemdump tomorrow, we wouldn't have to touch 
> any non-kmemdump-specific files.
> 


