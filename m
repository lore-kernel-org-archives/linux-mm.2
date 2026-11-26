Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71553606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 07:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=bW88z/l+
Received: by kanga.kvack.org (Postfix)
	id 7D54C6B05B3; Thu, 26 Nov 2026 02:17:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AC436B05B4; Thu, 26 Nov 2026 02:17:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69BF66B05B5; Thu, 26 Nov 2026 02:17:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 36BF56B05B3
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:17:55 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BD43A40344
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:17:54 +0000 (UTC)
X-FDA: 85476415668.30.336D684
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8EB9240009
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:17:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="bW88z/l+";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf27.hostedemail.com: domain of nik.borisov@suse.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nik.borisov@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795677472;
	b=XNK/MkAFvPx7dqNPjN1lNNyjYu6QK8qGnkcHLKXPVO1S8reZpgWlbmbxeTSs7JoAb14cpK
	PP3+pRZe4bfQMTctDzZOwnUDgrTMfxYCd8oyNdjwUCpqKMWKFbbjpVcCPdvtN/4n0AMQrA
	glcxNuUSHqU5tk8Y9Rqectq1vFSSuzA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795677472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wiVxz1XhCvSbqHjLx44qyZZxEHDYSWwOkZ0h4qId1n8=;
	b=6bjqoObGCgGDRczA0fAZzi9heSrzZaq0Gc5PaoeR9KvfhBEMDLEeKPtgOrTz/f4oroEyxo
	4cl0Jx74+5yk2nJgJLAYWRboBorYHIRVwQcuC3skMSTCBr32x61OhvzQCVpjuRj6wMwTPN
	KjMvORm+I9dny2cyovKbBfaWRrK5/3o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="bW88z/l+";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf27.hostedemail.com: domain of nik.borisov@suse.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nik.borisov@suse.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-49a92144733so3283796f8f.0
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 23:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795677471; x=1796282271; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=wiVxz1XhCvSbqHjLx44qyZZxEHDYSWwOkZ0h4qId1n8=;
        b=bW88z/l+QgTAdpIXhTg8McxOe5Me4eVmejJRvq8p4HM8LNNfOAZnox0QVRKUjK6otI
         TwPDNblzL6IGCxDpZiRqsWpWxG7qyEQK+mhjJkTOjhn9fuX4W4j8hRCalRpT+P7SW9SK
         RYN25VGGwNwuNLv21SwrptW0J+rmswi7wPFxvFXcLJFJQoUmLg8cjCKclNk+MNI3GN9r
         SyPjOpw6zukFxiWXS1ED6G4dZb09wq+YJChLQ6tctnXc/x+Nto0wImoz9ZRp6R6Z+/fC
         2AvQgyzxzIOw33SldZNzCmm1qbqwG4OzgKWQBke80QpSk1yT9hp/yzphh/0THyRy2t93
         x7gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795677471; x=1796282271;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=wiVxz1XhCvSbqHjLx44qyZZxEHDYSWwOkZ0h4qId1n8=;
        b=vpWSEmqdhJaz5hf0InTYrQ7mMrGjV7mfdaSPvfybv+AqXcFBmxw+uz4SGq1ylcy7yu
         Ba7Mg86A9/G01JyJ8LZIJLhE7vQXq6wr605fW9XXUqtwHmzEaUvHlsSeTNHt2fHUBV+t
         q/d3xCg4Dk+pSCaTtjaNOYGdToUAzYwAFu6966/9SysH4e5gUuDLv4+Z+k0krAJYy8aT
         IAiMv/dI4FQFQHpEErBFD8l93G8TtriAYIwUN0+okyqtulM7uaqTlm1+mXeahDEAqrRG
         pTNZSmfh6D135zXDJPbAs+BGZb6Av0eKBxF6GIEm9FZyg1InIqGYYkzB92lNL+qNm6V4
         WI8w==
X-Forwarded-Encrypted: i=1; AL+hErHw6+rxM+meh/BBL9gzbGTuIwD9komoPb1R7/fz6KUqFAPivllWQsj0UjzfW8n01fzNmTQAdnpbuQ==@kvack.org
X-Gm-Message-State: APuU4Z8VL9g1R3oF7QkMDDXYD/m/a1jSOjxHrO1VBQkVT9i7qaaMGYaK
	vGUhyZm6MZQ4LOoK3xqX8Qjh4hkcxlBzPXoddkQyLMpI9NWYeEyhwbrCJG5UtWHIEH8=
X-Gm-Gg: AZFdTZdaisLW0AwixB1MqPv8Iu/HQBrLVR8MwKWgr3NIbwfgb7WRHnHUDeZyHeF64zl
	0hgK2ShGJb28He/h3KOLqzuzT6q9/xrtebiqbNy4jqAvMABKnm348y5aXE83G/l/xw1Q/j5S+q3
	YC7NJICLgmaOMHs5Yy1QV/DiAeg2m2ox6sa0a1QzcF+5Q8LNxwOp+P43nkGF28kr0xGDomlBe6W
	ZZAoldMBT5g2DIaC3spe7l4zQN2OCE0t18brqD5wZj0pYYygTIyvEsXVkQiZlOkvXta0xVUqCya
	9lOhu+wjaR0FR5IpbZXpd+kuq6O+O2naPY89gOHhVb5vtTdCxNCe48vrFsfODsWTQJ5wGpANg1v
	bfzPZTgwP5BFwHO37HVtmWzgFg1PFUkKKkTQi4VnXJkZdXKPpw3F2cFGDEF2vcsNPSLipy/N2M5
	WLmfU06IlLVB5O8mU2HXAWShPr7NjJ54pwR3JzjwVRD79tBg3/zDEAMTzj5tWOoQNhF4X7Lpo50
	RYWtFEGYZfXF/df0feMa74crPEYAzGQlU6bhMdICdB6I5Q3CppVqztijUnkTCkOV6iLju3SCzeV
	TbFKlnlJmaRS3sUa45odWlEfnNlAu1lp
X-Received: by 2002:a05:6000:3106:b0:48d:ff0d:cfa5 with SMTP id ffacd0b85a97d-4abb7787bc0mr41436090f8f.47.1795677471097;
        Wed, 25 Nov 2026 23:17:51 -0800 (PST)
Received: from [192.168.0.20] ([212.21.133.162])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab69bf685asm39014813f8f.20.2026.11.25.23.17.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 23:17:50 -0800 (PST)
Message-ID: <d642f950-6423-420d-927c-991cbb5c2669@suse.com>
Date: Thu, 26 Nov 2026 09:17:49 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH] x86/devmem: Drop /dev/mem access for confidential
 guests
To: Naveen N Rao <naveen@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Dave Hansen <dave.hansen@intel.com>,
 x86@kernel.org, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kees Cook <kees@kernel.org>,
 Ingo Molnar <mingo@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Kirill Shutemov <kas@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "Liam R. Howlett" <liam@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>
References: <20261124160025.738362-2-nik.borisov@suse.com>
 <0dc6759e-ada2-461c-85de-809c170abd6a@intel.com>
 <awXBtrPSHfs51Y2f@pedro-suse.tail5790ac.ts.net>
 <8500860b-d2ff-45c1-8604-28a2b3d66382@suse.com>
 <awcMnXKDWjTvxumG@blrnaveerao1>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <awcMnXKDWjTvxumG@blrnaveerao1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8EB9240009
X-Stat-Signature: nah6rgmz9wdk5x9yoq1boizfb1ib1st9
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795677472-949010
X-HE-Meta: U2FsdGVkX1/3TppKs8KkGd7bYDoNrjimV15xw4ELsqj1EOKTWg9W/NY4Kwi4zLhPtLBBuTVcIM0j1HDPKWdhwDEthkP3Z7XJhtK1nUl6QXqzgB6uPUNjqUdlcINQMqlM7FQDZS9XQ1NydBqv54o+LJu/Riq/R3aWO6g02KyXx22Lm3gOjgYYYynZUJzIBW92Usig8JmYqqZOfirzKWGHtnbqoKHTsO/Vq3mxGDnhxH/shSqRBM4Kv7/RcyvsBnbQ36T8GHbsW7HFQBRgNQTgZLlX4VJOara01ZmX9O6d3aGHdVKGWFUcUf6CX/CIvDDK8K6xYGpoOOA9QBv0JL+ihwf7YI+gLnJ+/Il78lpbE8oplkEB3ZFfEZkSl/Ielr58eN3s511VqygXAKrse6mM958S20pRXu9wDzM7gvFX02+oHl3deAnTM+gKGoDJXjVJQgWIOU3u0QDa3VpwDnz9S2JLMYuU6vNGdT/bs4ONLo1u0D0Yz1Y9tuFG1dSZMUFU3a1tcQ8zOvNU2YNFH7WF9Kt/n+5wlgHdSUWvJXqTl5rcVqDphr1zXtjhD1wYUnL5qWi49HTR+IldbMxur5xZsgcnd5mwqCKhJx2TYoV24fQfrACzIpjMckgfFK1v+Va2jfJ5To/XLESzwYUPc91FFweCXo13OwWCEw60c5R8QxeCwsMRArMHcJfSqR7EQBlFtKMMeSRrdBUz5s1Gx64NzoYHKj6v2jcryxkJQ/VtnaKpFiDysmiuEivYDLSOC6eUOz5VN8N9WtWS6gugY9KfnjrTjjHoK80HLBLzKUOyQ4fUCjc2vn4UBuJPeFGpPAlbU8KUeZCAsS/x+c6B2MlDHKbcC+ulIsuxF40V6biLo4ZMABgouyyV/4Ke3KznxCMr484NxHeS8GMZg2tz/xoQF1dlMmOEkNiibURLm3b2xZA/w5vGH4mjofi8+geiHFr4tflnKIkGV0EN4OixUNb
 JTOfYIdU
 WdmS+0ZEis/SjG/ySNtaniz1meApjMD40GrCo12n1da99pM10A/l9hpo7Yj9QwGlGpjEMl7/TmpdPkoUTyUWHt7kBWX+BlUQj6DnKUGlZNpMYlKRoVZSgUwG6j7VpMlcDzJmHa5DSN/UNzOUg8sxORDHh8cFyib84gjM4xU4EXkD5tM8PsOad6B0wkNrt5ZNQjZhssOnGpcaag9tnj+nXMSHtwusCY4+WRljwNLXQbdLBETj/UtI6o0J4lRUh1rIMfpyg5xZDi36fEfFTaqet5nrHdDLJa/ZRT6Rk/5DPHIf/vcA1tyEn2AORsnHg0utztDu+1gkwY68mxCwPDGoJq3M0Rs6XIOM9tWmR3s7u+d1pD6mKSzR+cFXgIaMmh+pQWRGZ1nJdNDVhi2AOBJZvj0cCv18X0Q/6gtiIxcDXEpKywGX8CGy/+rQdAzQuiO7oz/C4UHL6as4omEO1VVs3WoyVZjjuEtv/I/eo3eUQFFA8C0wTiU7iDMswVEUdJrNVFYgLuszZH9mHpPCUCRavFcAbV5GVxBknHS7FgMnCCsoVyUA9JiRew98zhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 25.11.26 г. 18:51 ч., Naveen N Rao wrote:
> On Tue, Nov 24, 2026 at 07:57:05PM +0200, Nikolay Borisov wrote:
>> On 24.11.26 г. 19:10 ч., Pedro Falcato wrote:
>>> On Tue, Nov 24, 2026 at 08:36:45AM -0800, Dave Hansen wrote:
>>>> On 11/24/26 08:00, Nikolay Borisov wrote:
>>
>>> 2) open-codes random CC checks in mm, which is kind-of regrettable
>>>
>>> OTOH, it's unclear to me why that CC check is needed. If configs select
>>> STRICT_DEVMEM and IO_STRICT_DEVMEM, shouldn't it Just Do The Right thing?
>>> in iomem_is_exclusive, etc. If not, could the CC awareness sit there
>>> instead?
>>
>> Well, you are right that if we retain just the select
>> STRICT_DEVMEM/IO_STRICT_DEVMEM it might fix the immediate issue. I don't
>> know why eventually Dan decided to also add this check, I guess it's an
>> instance of "fail fast".
> 
> Actually no? On x86, devmem_is_allowed() allows access to the first 1 MB
> area, so STRICT_DEVMEM alone isn't sufficient.

For the first megabyte of memory (BIOS) is return 2, meaning "Just 
return 0, rather than trying to access the address range".
> 
> 
> - Naveen
> 


