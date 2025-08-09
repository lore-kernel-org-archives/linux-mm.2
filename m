Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DF17C87FCF
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 18:32:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A3C36B0089; Sat,  9 Aug 2025 14:32:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 854906B008C; Sat,  9 Aug 2025 14:32:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76A1E6B009C; Sat,  9 Aug 2025 14:32:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 681366B0089
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 14:32:12 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 115B457D37
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 18:32:12 +0000 (UTC)
X-FDA: 83758063704.04.67CB778
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1D4E94000F
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 18:32:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R3QZt9ZO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754764330; a=rsa-sha256;
	cv=none;
	b=sJxEfn+f4INxM1LLJ6UFsgcmaivFWumZLesnD3F1w8mG690/26doVWCXwBwEfShkCpMdkI
	Fc33zZC7vpH4KsCLPyZReYR8eGQcpDbWxwdaLyVDOzx2lJcU5lHVckcJT3lgLdiNlxFKLm
	aGqc093CqgeNVfwcOcCugXq6Lu1/WXI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R3QZt9ZO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754764330;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9s/fBeEFb/0n5Z77cYt+rcfLlCaa7g5SQq4WcqQ9I+g=;
	b=2WbuyWaeenlSFC0TvTtyUf1hoJ2eBeP3MXRvOiMFeOlHTtT2UPVJv9ZrOdW/lNxfmroXHl
	S+aT0ppOI6w3kaGu4OceRBmPDP0x2RQPcqww/fRRWWfWZkfhDvHdzlby4AgWj7C9H2rrx3
	xM37UH+x4bqqsHWU8bDc69DjAwpwuE0=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-af9611d8ff7so587979766b.1
        for <linux-mm@kvack.org>; Sat, 09 Aug 2025 11:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754764328; x=1755369128; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9s/fBeEFb/0n5Z77cYt+rcfLlCaa7g5SQq4WcqQ9I+g=;
        b=R3QZt9ZO8WXqmvYp3I8gOSO9+mYR+Ex8xoDvNwAHsBQD1AbyoOM6NCd21ipYgA8T+o
         IKnHGI0gTUkck0oEbe84HNYgWHiyklDY6Dtf0supDDLMqmz02zTEZTsMXn3ngMR+oh8c
         YkafIVwkQZ/g3QwNgzH90trEhop1bX3au6F7EezKOJ/toRYY8S/CXefQLzz3tjJFN13R
         LYmgWV0uNHYw7HwFu+ZyjfHkDATx2wkODFLUsYdVUEP9gwJEESdVt4pI1xmIBxkOTIB/
         epbXvsiHyImjVaeVrJp/h8yPaDrBuXdNugCPhz8bQw+u5qjUcsoeIXix0PH0Eo4DQKlf
         Xmnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754764328; x=1755369128;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9s/fBeEFb/0n5Z77cYt+rcfLlCaa7g5SQq4WcqQ9I+g=;
        b=VeepNjJ4L6zg/zH6U+cx7uiHeGdeEWWM1/EqXsDUreK+clujVzda1LJkr8M0GKNhDE
         rwXwbZXjEzbr//qNn5ulBpcdjITF8YoC/jK066Dor2W0tSU0+YXNqIAryjhTR3pnJKkh
         DAo0+1Lmb8aSWVm4gs4dwz3tFqiXtwIL5kCBlDzo5PDF8L9CetZwtaDjWTNOSbjGVc3N
         YfMppYd4WTV8U7xEcVkP5XTVc8Cukx00q39tCvypqAgP6e9NrZbNpr1v1smhgSGn7P+E
         Y2eUB3ZyWce5kaI37RrVMWQUV2x5evlEd3Ih8oIJT7+DjfC5W/2butTLzmJEMSTX9ml/
         DzMg==
X-Forwarded-Encrypted: i=1; AJvYcCUAuxLKJxLdl2cYxNoVwBVmHuLZtzg7dK2WKj6eHRSyyWDbtx7cmGzn+mP6EKgQElthUHmenKgBIg==@kvack.org
X-Gm-Message-State: AOJu0YzlJ6ks+GWY7aBIxG7uFuOvFWA/7hvMAia0IcxxQHLRiPjA1OwD
	YmNOck3tkRBCSrB+qm95CQ/1vw9agI7vqvJo9Dsc031OxmdRKr+cQuq9
X-Gm-Gg: ASbGncv9qNVL2WLncGckCfiFxxUfuwj4iuR778BYbBgrgxiG3MfpkjKfyZ7JT/8rGSL
	MsTn5HgY9ViN3ti8ySybTR+AKvO42oNaX7SJh6mGZt1o0FaLUDwjUKL8ow37sp0wQW5ldwylwsm
	i6gOwt707uoG2lB3mnQ3NBQWbFoylGyIgUJVBU4OWBJh+9Opb3Xavb8NRq5PoxD1leRcnsngbAY
	MSLU7Du4kiZ1kVcb6IRtYsMLhesrjJIorz+24imJHDnmZyMYJLG/DFEMZrbg5I7+jMCtzokZc12
	GZG7jl8UmwxTJatqgoc50gngdVwrIx0Twd4X96YZVOk2WCip546/BJ9f9N4i3kagvbg+wb6P6H7
	j9B7SG5AoCtne2VWyG+it8Q==
X-Google-Smtp-Source: AGHT+IHbu6+/jA8LdZVqHL1WWQcHp/s9Y+pab9NC8J94dNGk70WHYDDncBcYtCWmCpOWWCCNlU7Qbg==
X-Received: by 2002:a17:907:7213:b0:af9:9e50:470 with SMTP id a640c23a62f3a-af9c705a837mr672476866b.28.1754764328248;
        Sat, 09 Aug 2025 11:32:08 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af99148eab9sm752111466b.77.2025.08.09.11.32.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 09 Aug 2025 11:32:07 -0700 (PDT)
Date: Sat, 9 Aug 2025 18:32:07 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Donet Tom <donettom@linux.ibm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	akpm@linux-foundation.org, Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	ritesh.list@gmail.com
Subject: Re: [PATCH v3 3/7] selftest/mm: Fix ksm_funtional_test failures
Message-ID: <20250809183207.yx3eetkmr7bd3356@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250729053403.1071807-1-aboorvad@linux.ibm.com>
 <20250729053403.1071807-4-aboorvad@linux.ibm.com>
 <20250804091141.ifwryfmgjepwrog4@master>
 <20fb853c-7d79-4d26-9c8a-f6ce9367d424@linux.ibm.com>
 <20250805170353.6vlbyg6qn5hv4yzz@master>
 <e9079694-1e30-46b6-97e7-b79be01c65a6@linux.ibm.com>
 <20250806145432.nygrslkiyvzulujn@master>
 <111d2351-3fb7-4011-af07-78b40874d956@linux.ibm.com>
 <20250808025804.b7cv47gcq2yscka7@master>
 <c237c703-3ed6-4d7d-aaff-bd6291f9220f@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c237c703-3ed6-4d7d-aaff-bd6291f9220f@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: wreyp5e6pyjdj7nm7uk1gmei5jgpsd5c
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D4E94000F
X-Rspamd-Server: rspam02
X-HE-Tag: 1754764329-105320
X-HE-Meta: U2FsdGVkX1+EOvWN4BvGqQVmKHRSwNALJSHbAtc/VUd1jRSsW6u3XnoJOPfO/265k2nVIbxlXY5gkV91bFPwsScWfz1NewCSBIVZivNxHDdVkWmZS8iwuPpFx1qUlK14gxX2kY1l5CrHRClmO9wUKvC9DindaSCcWMCRrM+wz9nsvXsJQepAYmA81tPGy5Dhj+VU1PEV0QCxwDQYsdz27GQy/PCbSGa2/FCanIPfj/jRFJnIXcP9tQ1trrZBFAliU4auir8DK6sPW3n2fhw3SAA2tm2rqBDWe5O5s2QyUP5nNWqvpxD9kndyxHIo0WZpHDaAaJv6terWEGQ1nqLxzofJ1+uKYfN0aHlr0vS/1tx3GO+Re/Ptg8bDXzTZ6fT89mQRYw6LChNmFnq9PXehlzWRJgZgmNw7M9vId+TYjiQcGVicF1A5Rl31WJmpA6NGkV08SMvQG71chlt8V+9vvX/9FK3IuEaRTi6JFfZ2QS+n9vhvmRP/TEbm9vSnmPjfG0iMKqiuZEA9H/L24Imy1TdG6nXbjdNjahkhglbfb363XkvD8NIzXHwcB275/7lTmDrfuxeMlU5mjz0an4b6YPeNTN0H/mvzBJ0XE12PyKoGfOtjQ36UAShKEw221z1ajKS7PN1euhHJjtXEBba8SwohyY9VwqtyCDQdGlk8blcjgsosvBjSojy+UjEMHvT8fxC/DKfm7tXE01wqtSaUwOmtmQuORTPtlmSF+XXThDr0uIWUe93PwJH//LugKa2M/g9Ytzos90ki5c+/wUGfOBkUcF/XKtguzGJ5Dl9/a6WLyOkLweDTcibe8KVYh3T2pl4HcdpTcjfo2gGBdHNycWM6+SwWbvvX0WNfIKA8MLbdkXj2YlQrM0wMwFrsT9QpTocXI/6cWJjwaLa/G61ouBfdd3zpFWiFThLSnB7d2mtEcFHrpFpLXUwUmh2AS0CRpLu908w/lszL4WsThsq
 9zeXcwiC
 dmOAYqFLO8vlWd/jPy/eSn/ODByFY0ZzE9pkQ8ka4wl4Ctg8FIyez77gVk+zuA4cX4zg6cmFBz44mfw2FxxFutqoT6Cy8yBUkfIMbNK0M0Kx+FyPssrO11LKqQOvJQhmve+SBXw7PFoTF8Mb812cLO/mWLLo24rYH1nNL95HXMxOsnIidSSe/qLEbd1ikZFlJCuRozk+lqFU/2M0t4i2PiHDkMlv+BhjSc0xqHaCjPA33UnVeUj1Ke3SL13eegguKPh4jAkC4HQfJjHo13MLFCH+ibBtWkn7SOn5KeXFZ9Eu2SL690J7/ns553DcGInfzqLz7wkWm53Hd9FyBaJRWAt0d8ZPTYF9QsVoQOfXNu2RmufJNe6Y2ZFyW2r3C3M0/4Y8wqgIuR3w2rJD3nTyllHXg13JD0EWAwcv0iajXWeg9YHqFkOl8OM7WScKSi1RxD8n5FDtYBbgNRD6Myk4obNWH+84uV1XpQhuEHmncfTZmRIqHXkWw1BCgZ1PaVjfkkWwrkQdx9fPgICRU2q2N08CnAsWZq2PPsH4nC3rD0hByqpYmDCoLDcO5S72JYVzf1siodxew6Wj3zKSQKPfOsj2zrJWqrS3/wr0S2uNXVQW+s9azr1izSugcs8IJF+VDnl/QGufi7Tsj/zY4dtqZrKUZMhmUtqx+DKEj3P6pfvk/s4mvEpxTwuEqPouWTsrdEnTuqIFnQQKvFJyXGxu3/IcwpsTIdVCBYIMO26adAQGwzO6EEQ/quukEs/fQryjDXTMk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 08, 2025 at 07:55:37PM +0530, Donet Tom wrote:
[...]
>> Thanks for the detailed analysis.
>> 
>> So the key is child has no ksm_rmap_item which will not clear ksm_merging_page
>> on ksm_unmerge().
>> 
>> > So, only processes that performed KSM merging will have their counters
>> > updated during ksm_unmerge(). The child process, having not initiated any
>> > merging, retains the inherited counter value without any update.
>> > 
>> > So from a testing point of view, I think it is better to reset the
>> > counters as part of the cleanup code to ensure that the next tests do
>> > not get incorrect values.
>> > 
>> Hmm... I agree from the test point of view based on current situation.
>> 
>> While maybe this is also a check point for later version.
>
>Are you okay to proceed with the current patch in this series?
>

Sure.


-- 
Wei Yang
Help you, Help me

