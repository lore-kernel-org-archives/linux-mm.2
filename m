Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97178CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 13:53:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F278E280036; Thu, 18 Sep 2025 09:53:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED7E38E0112; Thu, 18 Sep 2025 09:53:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC6DF280036; Thu, 18 Sep 2025 09:53:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C9E2A8E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:53:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 45A1D160175
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:53:52 +0000 (UTC)
X-FDA: 83902514304.30.3F449B8
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3102B2000E
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:53:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=Il70z3ln;
	spf=pass (imf03.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.218.44 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758203630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j7efdXg49cd0dO4HNsPgED93u6J0FRsteNdyMBWuRc0=;
	b=YSqcb7fsvnmsI/32J420HW/jKy/Qj19+4YpbCrSakR/vSuxP30JLzkkN8euRa61sqOtVdq
	vLcuO8Tc4B3NRNu8xWxE2SjK292EoBcvS005eSR/ZWUVfFJuqrYX6LBNMEK5E2BT11p0GN
	ggebnnwlVj5oZb4idPscvW5rt9YLJ8w=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=Il70z3ln;
	spf=pass (imf03.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.218.44 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758203630; a=rsa-sha256;
	cv=none;
	b=2RQnhgHSpvBSWrealjwKCu9tkbOJ5yv0BvbMAeZ1vSMSkfDqyh79G9PHuekIxUDGwYkolG
	AW7eApkkbhl6YQO1uNX3OUs+1zJS0n4VgVZAKM06zhYeePDODOr93BIyJxAA0K1Byg7MTp
	JsWd//LbwoLQ2pvDGK4NwsdKIcvL/Hg=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b223ec0d5caso83591566b.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 06:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1758203628; x=1758808428; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j7efdXg49cd0dO4HNsPgED93u6J0FRsteNdyMBWuRc0=;
        b=Il70z3lnEi/FbBr53TAUP7uq39IC/ZxGKFvR6R8mRAV0UuxcRxo6ewq1dBU72TKbWZ
         jhkCKJ4o2DrUeIFyf1rlRhxC3JhB2h2Spul7qdzhAAGRkKFwM5X4+mNi75TfLgL3JqMm
         7eVXx3VDhu9Pr8f5JWw68ZfFQ+uiZiS/8LE3MgwqBqaU0J6esoO42/JVvpISs7a4XfkS
         pS/E7gTgVXhg/McYfFy5siY1HiJ3udaYiGdSpW0VMZHbxp55ws37+S1Z7XPt6fmQIruU
         LvbEpOXzu4kwIQOpKE4tzGwnDpshtMFqZHFhNE9gsW9Z5cBb0hybhLyaSlC4KAvRY9wC
         97xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758203628; x=1758808428;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j7efdXg49cd0dO4HNsPgED93u6J0FRsteNdyMBWuRc0=;
        b=rnA79MFVrHZaUErm2ZOjklKdvwr4vbJpRnhfnBfOOGDPGJj0Mr6KXVqyF1GAjCrwxt
         KASQJseqoKUK3tkcNOYinC3TuXjjS9iuE9RzsjXbRFo4sGoKFt1IR0Sz9p3fT0WCOqaR
         8rHkpEo8ikYN02103rJWY4h4pEYaAxkXxJjSiD1CC8fa/R4oIOVq7nVTo09NB/rhv/Cp
         3QiPL51V68S6vGx6gwCYFXeZwpqWAaVyJVZ5TsnZQTgYP2HWtjnPLVhB4U9DKYaZtZ5A
         MPBlnXlxY4vTaXEJ1LqB8X3nAqaIn0e7lmdgNai3GuhN8nSAdzZ6csowEHq9/xUbbwAK
         9PSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWK9q9YwIJlH36HDJQYU/46L0dZ/0tJq+atyNHVmWO2ABn2ihHW5V1A3I3/wb9lHU+DDYvrZfDowQ==@kvack.org
X-Gm-Message-State: AOJu0Ywij0HNMRRQuI6SIwtRhKp0WeZWQulHX/ZYFgw4wAvDFNPGAXI3
	2ykpvl3yjAwCw02y7DWS5BZmJU58OxbH9E0pHZD7A22YZ49jPzUwA8TG4Fxgk8+3JCE=
X-Gm-Gg: ASbGncsAvJ0NGZXpyv8GPj/Hs5/ldbyD1JnLmcIblOco3Ec+e2nfsSU86hiXGa//9dS
	WQFIP2CfbpHStZN/XDcTkd8qBNTs12mQpE3xrhvkB8WYr4sRFySZcAruYWwZmxLXFe5DzWULVtn
	LYC81Osrhg31UbMyjDa+3Wy5pDW9jpvfsm9/ItOQ7BZ+wEpvOI9rp+PDdYkZv2fg8pbt/M7zAhL
	S2gdjxWUJwdKyf4nM9cF4XsA2InPt95dVlORp0kn+LKiBP8K8r0qTpQ1/597M0RFRW+dteniiNI
	r9uRYaW/DCiVSsx10uw6dX3akyLD28wrLozGM74n+4umrgIFNf2LQeRfftwYWAYkZfubNaf7ZH4
	HsMueVV+NkAruCXKB1v1Is9RV6bHxO6EVDJa44tMXuRICZi0ZhvY=
X-Google-Smtp-Source: AGHT+IHnDWpjM1umgSyHsR6OREF3QxVVNfm6x8W+jII5XcXDsJKZeNe+EM7x++buErDbKkF9QmRQfw==
X-Received: by 2002:a17:907:7e93:b0:b02:a093:eac9 with SMTP id a640c23a62f3a-b1bc1169518mr637192866b.53.1758203628349;
        Thu, 18 Sep 2025 06:53:48 -0700 (PDT)
Received: from [172.20.10.3] ([109.166.131.237])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b1fc5f44bbcsm203026466b.5.2025.09.18.06.53.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 06:53:47 -0700 (PDT)
Message-ID: <c3ab4a21-183f-495a-b3b5-cc74b392eebc@linaro.org>
Date: Thu, 18 Sep 2025 16:53:45 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v3 09/16] genirq/irqdesc: Have nr_irqs as non-static
To: Thomas Gleixner <tglx@linutronix.de>, David Hildenbrand
 <david@redhat.com>, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, andersson@kernel.org,
 pmladek@suse.com, rdunlap@infradead.org, corbet@lwn.net, mhocko@suse.com
Cc: tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 jonechou@google.com, rostedt@goodmis.org, linux-doc@vger.kernel.org,
 devicetree@vger.kernel.org
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
 <20250912150855.2901211-10-eugen.hristev@linaro.org> <87cy7q9k8y.ffs@tglx>
 <87a52u9jyl.ffs@tglx> <8df2cf28-c15e-4692-a127-6a5c966a965e@linaro.org>
 <2bd45749-e483-45ea-9c55-74c5ba15b012@redhat.com> <87v7lh891c.ffs@tglx>
 <95ff36c2-284a-46ba-984b-a3286402ebf8@redhat.com>
 <24d6a51d-f5f8-44d7-94cb-58b71ebf473a@linaro.org>
 <7f4aa4c6-7b77-422b-9f7a-d01530c54bff@redhat.com> <87segk9az5.ffs@tglx>
 <f8d3c2d4-8399-4169-8527-3c87922f2ef1@redhat.com> <87jz1w88zq.ffs@tglx>
From: Eugen Hristev <eugen.hristev@linaro.org>
Content-Language: en-US
In-Reply-To: <87jz1w88zq.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3102B2000E
X-Stat-Signature: pef54zorp9do44qupha9xjqtx978tpxx
X-HE-Tag: 1758203629-882298
X-HE-Meta: U2FsdGVkX19qR4gv+p3RYEzWNDnHCK1zJ/WXWDLE/Ahr1dySdeapEkAHCos8choUKFSjNr1tcxsCbhhbWEYOBlSzcsErdWhrNqqffNsnhxxYrlJsVAwHVP3rB4NBR1eMi9oea3PcCA3oO0GxrpU1Zrd7p7/5CoREKHrb2Kxvz3Bb813k/SpQlz8fn0O8Tl4/RNnUvY/c6EEP5Mj6Ym5v9sHZRB/bo+6Crfse6vQGDjLUBhMWVxusapUsGHMgJ2CTYMMT7Ddwm00gHyu/LcdEe8XRX1QF9PTbPLfletI57yr8Q/4/gRq+TmtQbgWQ7VLLcBgppeWp3y6URJNsY7s6MmxK9rzXD/ub6ek2LAQ6/P2mSra+MZSxAJ+Tdu2HI1JJNbsLezJgtAJFG9ZdwB6Xp6mAqMqgLl9QlmbtS5YryOf+iBa7ZXi1NsDK+3I9wil2LMmoXxn8EQyLA8cvtKbLyUi0htIKvUYYHk2TUntc29yG51pqNF9KMvisyJ0AO2jVXUs29/3u2dXN/MUINnQcJBKGtsSxbCWj+QaAykMvKMLykAxAof6WxZq79POCUJb0Z/u7uRATvZCs6QUyQRtifJ9UKHzQARTX3iBZ1/O/AK/r0xkH08S+jyHu24b5tdbI//dJxAk34d/QATlpqVFJ0gcsMUr3w1okUpmFV210jwMwE7Vyl/UZUfhrf8FsGdgXuzPfmQsiaNbSHapUMu3+GOJeHiQSZuwTVDVTtX2OchqkqK7i8tE1Clrw56bgm1HbtAjjYJWzSmapyTshYyRhirZfrbWBBIH64Jt4GlakDc6QowWq0a+huyXDA8zhi9lH6Ucls57ycKVkFn0jGYBfr6VwVr5UKY8HVTlEZX2QmiUcGZA3LN9eaoTWu0dcGkS6jl6G346tslB+ERNKqlC7e7XR7SYYkBGToiFK9580BAVXovLb95GNwT416Nq07UpEyAwESjWJ560LZKM69b/
 tI2Jf3ea
 nlTT521B9pV6fD6mpd84EMFeQsWHN6eCELGkoW5GtMKrOczog0H0Sm0/ztyQzFe8dMpi9gFKTs87jBuRAe6hWkKnZ2hj6VW7m6PSxljAjLyg63s0MUMITO30y9Fzp1Iqjyehz7T332yy05X9EEguv1w2BoGFxMDYKk7yDRdMYM8ZFxpP004bksEFnMHnd1G5+vtHhqCJ9Sb43YU+jDsWgvuTQlgI08RqTdQSiIROEx+T2T6QXsAbnWwereOFHJ653OxsSfpMbRjR3a50IVE1t6Xadu+HBkCqlVu0zgC53NUVsA13CBHVD5wF+RP58qRt/LG1mIUnUwfaQ3AFd2RW4JuNg231VaoF4DIje+t46b8ajZYJUFHXxG1q/TkBczd7rsvqVDn5MmIfRyFDmPyN/+KQI9pD2I5Aakb7W78VS1UKvjO/IvrCg7LOinexS53H/W2+Gmqf5bmmIsApHe8s5IXWDwU7lC1t6wpIb/k8CTXOyktU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/18/25 11:23, Thomas Gleixner wrote:
> On Wed, Sep 17 2025 at 21:03, David Hildenbrand wrote:
>>> As this is specific for the compiled kernel version you can define an
>>> extensible struct format for the table.
>>>
>>> struct inspect_entry {
>>> 	unsigned long	properties;
>>>          unsigned int	type;
>>>          unsigned int	id;
>>>          const char	name[$MAX_NAME_LEN];
>>> 	unsigned long	address;
>>>          unsigned long	length;
>>>          ....
>>> };
>>>
>>> @type
>>>         refers either to a table with type information, which describes
>>>         the struct in some way or just generate a detached compile time
>>>         description.
>>>
>>> @id
>>>         a unique id created at compile time or via registration at
>>>         runtime. Might not be required
>>
>> We discussed that maybe one would want some kind of a "class" 
>> description. For example we might have to register one pgdat area per 
>> node. Giving each one a unique name might be impractical / unreasonable.
>>
>> Still, someone would want to select / filter out all entries of the same 
>> "class".
>>
>> Just a thought.
> 
> Right. As I said this was mostly a insta brain dump to start a
> discussion. Seems it worked :)
> 
>>> @properties:
>>>
>>>          A "bitfield", which allows to mark this entry as (in)valid for a
>>>          particular consumer.
>>>
>>>          That obviously requires to modify these properties when the
>>>          requirements of a consumer change, new consumers arrive or new
>>>          producers are added, but I think it's easier to do that at the
>>>          producer side than maintaining filters on all consumer ends
>>>          forever.
>>
>> Question would be if that is not up to a consumer to decide ("allowlist" 
>> / filter) by class or id, stored elsewhere.
> 
> Yes, I looked at it the wrong way round. We should leave the filtering
> to the consumers. If you use allow lists, then a newly introduced class
> won't be automatically exposed everywhere.
> 
> Thanks,
> 
>         tglx


So, one direction to follow from this discussion is to have the
inspection entry and inspection table for all these entries.
Now, one burning question open for debate, is, should this reside into mm ?
mm/inspect.h would have to define the inspection entry struct, and some
macros to help everyone add an inspection entry.
E.g. INSPECTION_ENTRY(my ptr, my size);
and this would be used all over the kernel wherever folks want to
register something.
Now the second part is, where to keep all the inspection drivers ?
Would it make sense to have mm/inspection/inspection_helpers.h which
would keep the table start/end, some macros to traverse the tables, and
this would be included by the inspection drivers.
inspection drivers would then probe via any mechanism, and tap into the
inspection table.
I am thinking that my model with a single backend can be enhanced by
allowing any inspection driver to access it. And further on, each
inspection driver would register a notifier to be called when an entry
is being created or not. This would mean N possible drivers connected to
the table at the same time. ( if that would make sense...)
Would it make sense for pstore to have an inspection driver that would
be connected here to get different kinds of stuff ?
Would it make sense to have some debugfs driver that would just expose
to user space different regions ? Perhaps something similar with
/proc/kcore but not the whole kernel memory rather only the exposed
inspection entries.
Now, for the dynamic memory, e.g. memblock_alloc and friends ,
would it be interesting to have a flag e.g. MEMBLOCK_INSPECT, that would
be used when calling it, and in the background, this would request an
inspection_entry being created ? Or it makes more sense to call some
function like inspect_register as a different call directly at the
allocation point ?

Feel free to throw your opinion at each of the above.
Thanks for helping out !

