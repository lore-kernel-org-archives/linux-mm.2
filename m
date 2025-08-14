Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A69BCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 09:41:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94985900122; Thu, 14 Aug 2025 05:41:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 921E1900121; Thu, 14 Aug 2025 05:41:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7261E900122; Thu, 14 Aug 2025 05:41:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5F8C7900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 05:41:36 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DDE3283279
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:41:35 +0000 (UTC)
X-FDA: 83774870550.17.14839CE
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf17.hostedemail.com (Postfix) with ESMTP id C8FAE40006
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:41:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PpsCMjNn;
	spf=pass (imf17.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=asml.silence@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755164493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mfVsnps5PF16eK/6Z6rbqgY0AeNAHzhL7ZogriCupsE=;
	b=re8z5yqPer8lSBbFNW6mCx7YWNJ79naPXww16rd2L7LwdMvb4DVdvHx2BxGda/MhNXEAzd
	/z4PcdHvrthQrJayleVMjZdTXfNfHPh6e/vepA0ExebvI8lgDcBE8+/asSXawhGfR7x7Pc
	0EgjiGNZaCpdZEKq0NIn/Rsd4YpyeUw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PpsCMjNn;
	spf=pass (imf17.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=asml.silence@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755164493; a=rsa-sha256;
	cv=none;
	b=ajjPYlA5QvpUXZqzKGYnQB5ZvmbBlR6xvcWWiBY28W8XbL2WCBTWeXtUDXLZKjpqoAgf7S
	XpeB6JTEIjUQN7B1fhg6d36V6dV+kREzHJ8Mjr4AaEG63Myg7Bje8Xw44pJrGdY6tkBb+9
	1Ug2khmfLBpYBAKM3dkWbAj6ZJlmEK4=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45a1b0bd237so5753945e9.2
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 02:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755164492; x=1755769292; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mfVsnps5PF16eK/6Z6rbqgY0AeNAHzhL7ZogriCupsE=;
        b=PpsCMjNnRXazquYMkd4S8JvFb0ms0HiyuhNbivsAh3FOTWqk8AZVUG4uq6e9YrS0Yw
         orA/ooYWF2oB/jHtIPOmVeDvSvnEaPq3cuOXOqRKX8h1xiGrYOWE744+U2rDYOHXGL8w
         j4bW/yDWhOXDGua4VrjaENvhPdwWm+H84u7YHh5AQm1X8wKMRTYCRNh0orjdRB89J+rX
         s4gfHUZgEy3duy8E3kGTmYIxFd9X7XZrrHNn2MCoQAAbhHiCSVu9YLlgbeXk2wMk8EnC
         ZO+MLlW1bB6z/t0WO8q1ojO+vuZ9T9SlG+yX18NoJ7LWb0Omjvp4B0Dv7Y+LJ4nEccnd
         iElw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755164492; x=1755769292;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mfVsnps5PF16eK/6Z6rbqgY0AeNAHzhL7ZogriCupsE=;
        b=bJsup5/cM/VanstDeWKxPt0l9y1ZbpKkVIzK0yB4PCHox/YO77R6BsNKqy3Txf/e18
         q100/AzAq5olz9eaeWrA0XzxEZ8ebdlPUUKk03rfCjlsPj11wjomY5QnA4Ee+YyuFpKV
         a2bPlQDDU6V/dbGStLUUf+Cll88x638j5hqhxpXI4u7xcIjv5n2pvL5gODt7ChZDCmoX
         CuZGi49NBg7wSkmMNlvxusIjZr7vL9vyugrMFrcKXXA2DQQieYze5LWg/pGYREjqYzuV
         YAWN7Z6Vookt6i01c0hLx0FzxlMNUEE/uCXfWTel0alyT2O94ehY5D78zmpcVY7QvOqt
         LjAQ==
X-Forwarded-Encrypted: i=1; AJvYcCV9iTy0CGDlKaoqhN0A9c4aeSeS/Wtv6UOHJejotcorGszn23R7ijyF/dl3eQcz/sio60sewG8Nrw==@kvack.org
X-Gm-Message-State: AOJu0YzxDD5qlX+XypLv55H3G8hyW+8hZXyj/lQlRtWKey+KAXuhXsx6
	XWuPSrND8XWMDYJ8kLCzXWFBAOGJlUJkksAoFqJnettYKz+HiR/L6itg
X-Gm-Gg: ASbGncvjb7a2EpxiA3aZ+9UCOT78NbLJ76Yu9qrW0pnMqCxU0YUxZAFV3y3VpWc6v7E
	3pCRoYCsh+TEKY+u7FvNFohmZUf2OM481hMJzlDUs6CwFJ/zmo6i/nsFONpzwe4T+4fBvkGKF6Y
	e3m4cEOZuPxbHFMhWFDRjKV5cZDeKKa0c7yLJ8cTIY4j+CjDtNl1RjPo0cVq2CYCYPdHOPmIVra
	gIv2S2J3NCxdak6+QBmC2/SnPg1xXh91XxhbPSZrvmUnjgZMriaTvuk6sih/3rfLyvqjblUt9BJ
	koY2n/e0qyk/auTPFL2mvPtowf0mEi/rYaMS9SIX8QftyXtPVah5a9JaAA6e7GSTd3e5qLsRqHP
	JgL9KaYw0fxUSlGx6SNdisUqNbGSXdqvvj4c3v10xWtvWtw==
X-Google-Smtp-Source: AGHT+IHBe3UbzHGADMZbxm6C1MQMCttafmz3pDCs0fFtOpYQDzgStuK34BlZw62Cf2j8jvkUuST0pA==
X-Received: by 2002:a05:600c:3b93:b0:459:d780:3604 with SMTP id 5b1f17b1804b1-45a1b605845mr18547955e9.3.1755164491690;
        Thu, 14 Aug 2025 02:41:31 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::26f? ([2620:10d:c092:600::1:7acd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1c6be10esm15261205e9.3.2025.08.14.02.41.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Aug 2025 02:41:30 -0700 (PDT)
Message-ID: <e8d33a38-6465-432a-9c28-25f2689e95da@gmail.com>
Date: Thu, 14 Aug 2025 10:42:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH linux-next v3] mm, page_pool: introduce a new page type
 for page pool in page type
To: Jakub Kicinski <kuba@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, kernel_team@skhynix.com, harry.yoo@oracle.com,
 ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
 david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 ilias.apalodimas@linaro.org, willy@infradead.org, brauner@kernel.org,
 kas@kernel.org, yuzhao@google.com, usamaarif642@gmail.com,
 baolin.wang@linux.alibaba.com, almasrymina@google.com, toke@redhat.com,
 bpf@vger.kernel.org, linux-rdma@vger.kernel.org, sfr@canb.auug.org.au,
 linux-mm@kvack.org, netdev@vger.kernel.org
References: <20250729110210.48313-1-byungchul@sk.com>
 <20250813060901.GA9086@system.software.com>
 <6bbf6ca2-0c46-43b7-82d8-b990f01ae5dd@gmail.com>
 <20250813075212.051b5178@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250813075212.051b5178@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C8FAE40006
X-Rspam-User: 
X-Stat-Signature: zsehaoct3ry3auwtx596y18oed9x1mfd
X-Rspamd-Server: rspam09
X-HE-Tag: 1755164493-81993
X-HE-Meta: U2FsdGVkX18rhLuWzzH5kaw8q3kR0fAOp7UdWcw2lQUwGR3sH4LzsMDK1ITh32XTW3rPmmJdSFTBbPk8Hl9FfYlcVU20IqXgfRS/4yq2O7ypWsE4+uzD07RngKJU6t4X5fUqAM0vM/JXoBhbeNKqpsTgwZSJREgZYQtTMOUtqKRIUsYKIlZStcOTaY9rGUOQljFL2Fi0xYkjVuhm772AfhWUNIrWgEwWao6lEMx216/zU6lO5gS4OX2T2EP3TfNJWQjsu7UVVjsvKlpg6EFF+sltZxdGDjmkxTxcAH9fHS4/eETHBUUzQfIhxnSNtatAyHdgkIs/gs26m6tHdOqkD9kn0jOAzsMPKJWWol2lliyiwMPcqH946OaoGy/33bTJQhagpSsO4+qakWhSquMO5BERAy/dObt3Eqa5JwHc8G/U0wkB2OLPzn3EAaDVCAZM4pF7RKr7rNO9KlcaznR+tbq6gygxERABlbK5Xxf92sEwSU4jb9N6sLYSxC9M2w6fzblivnqYOF/GSVbcKsB+nF9u0UYYxC5jSKGTx+QnxINDPDROAKiFulhNEcIxnq1z5UbgxQaF5IywlFgo+kJMg3ryFnh4PYwCUZRLyIv4rJbrDy4shu2p9qXrwg6JEBOqFUdGk9Jc261OVtIau/JEUZezkfkdt674Jbp9dgTYvQMOO9K+5eDStoXDtz0kiHU1Ks473nYyAF6VA3BiLmfnA42Ipl7STL/Wdja16+WgIOvx6EgGAMxpDJR2H9EnCgpbYIg0ZgRlvb7txdQbcOYE12/LNbtwa3omc4eogTFPFRsEElErDXXBrK7b+5EZzXJ4UEkU9zoHng9jkhQ9GMXa2Wv6KuCLQ1t81rSbDXn+NtMLOjJECKRDekDsYrLf4btz5I4QmjMcyD5NyvM+o4CZ26XVgtygVjPxQTOM+UlQ56FgNk0I0TuPGUcsUU75JX9V0arukWFX5NdpQ0JX3DH
 ZZmYGdWH
 Lcd6OcdP9M9ntmJx1vDbHo3hCj65oArpTTbS/qL1H4eQOySaq1NL7ukRZ/W5FRMLq0FKQHtIAQs/nWj5xQKVMlDem9XdhfHP951nDHzNWyhRHBgy24KM6UspELU6LRPCfFrBKp/rqTTYHTbd16sWbo9/qylvB2KxdtMG07f6xlTollHzKenjN1lVIkFJmvFwHJah4vCXytTUs60mGQ1zChC+S9LxHlbj2eTm4KCNgzzW0Q7zCi6FZToXAeU2dlgS3hdV0tO0Es3n7Dtnc0QSC8hsOJ3Wq3QVF49TFJLBq4A6S9klRkTQ1ciFDZfk412Kgbe9Psmd8qwN3QAkWCgvbhcLLC0tWQgqc2zeqi3YeoCtY6cWNzZKGfwwyzSrq8x5DQIc304BHKIWLsx3CO6wsxZo/vFA16+qXeMhREZLjAvY+iujc5x+MRKHjwn27YzvRfLLyKI1S9UGAjxaKFBUOm+JSpm0kHORV0XActXU+0As0RHHt3PiFsRpDo95YoZqIZeLlEbxtcKi4SNvnc8+hYRSgOCt7YVwZkvQDsw4oEIG3emLuQdJIkLNQVwDOsIKPWkrGqK8GisYXnIb3tV/reKxfOA9Zd1DEXMtsW2u1So6Qa+7/3SR4dIwQ10F3Xiu+xDA9TTJF/oDTS1YudLv5YeijwBH2ycJHCKhC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/13/25 15:52, Jakub Kicinski wrote:
> On Wed, 13 Aug 2025 12:18:56 +0100 Pavel Begunkov wrote:
>> It should go to net, there will be enough of conflicts otherwise.
>> mm maintainers, do you like it as a shared branch or can it just
>> go through the net tree?
> 
> Looks like this is 100% in mm, and the work is not urgent at all.

There is a slight dependency in rc1, but we should be able to
massage it to be mm only.

> So I'm happy for Andrew to take this, and dependent patches (if any)
> can come in the next cycle.

Yeah, good option. It'd be a good idea to cut the diff down to
avoid removing the relevant mm page state checks until the next
cycle.
  >> @@ -1379,9 +1376,11 @@ __always_inline bool free_pages_prepare(struct page *page,
>>    		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
>>    		folio->mapping = NULL;
>>    	}
>> -	if (unlikely(page_has_type(page)))
>> +	if (unlikely(page_has_type(page))) {
>> +		WARN_ON_ONCE(PageNet_pp(page));
> 
> I guess my ask to add a comment here got ignored?

It's an old patch attached as a point of reference. Any actual submission
surely will need to follow up on the reviews.

-- 
Pavel Begunkov


