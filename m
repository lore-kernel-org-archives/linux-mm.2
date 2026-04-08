Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BE75FD5F8C
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 07:15:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C63456B008C; Wed,  8 Apr 2026 03:15:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C139E6B0092; Wed,  8 Apr 2026 03:15:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B50E96B0093; Wed,  8 Apr 2026 03:15:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A95FE6B008C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 03:15:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4B74CBC5D4
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:15:19 +0000 (UTC)
X-FDA: 84634527558.26.1849C04
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8765240009
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:15:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=A5U8Din0;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775632517; a=rsa-sha256;
	cv=none;
	b=ehjW43LBiP0/OUuTeluh88DAMuJ6CyBE14LI39nkvIW0S8jf6DWIxMr1k2DAm36kdII9/e
	4eo+g1lusNGyh6Pp6hG6xZGNjnGy7elwoINMGyKJclXQaN/NCpIAutdbIHuOSmqkYoEKnz
	37qGrKU/Gr9lzO+3yLvhQwdIIJmKK3Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775632517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xOpUauE2L6VJgtt3jsvcjulRdV8VHL7H5DkVolbS4k8=;
	b=nzCjGWzJh8skAwdMuK9LXD30bJ2ns75VZUxNthqQtYG5qM/Hxwn0iRdL7PF1cFD5s/2kS1
	GIJDcYGyQzrwVzgD8Cshd1lsubDk/Uv9iEbraQcxjBG4Juavxomh6Dp5B/zDNgIfWDv8AK
	BFgp8bgXZfN5yXHnnyhRYcMtx8xap7Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=A5U8Din0;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF65E3594;
	Wed,  8 Apr 2026 00:15:10 -0700 (PDT)
Received: from [10.57.32.84] (unknown [10.57.32.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1F1CB3F641;
	Wed,  8 Apr 2026 00:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775632516; bh=QI2zxAR8L98eyxVZKjXwqx85OyENRBPtMCzaOaSjTdY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=A5U8Din0dHoR9dyDDWxTSu3B/nuzykbKGu4AkV4oHkxqO2Gh1t8RUUdC4Jl4dlIiS
	 ds8GzhzuGE6SiVyZ9dA7c8fn5AiLn3eXXQFIRsGxCMDRD8xMB8IKlNq9Oedqa7vtpB
	 0CjNOP6SsXkauLqkiizN1HV7zBaLJCgdO7lwXxPg=
Message-ID: <fee59f61-cf62-4a60-9d8a-4543a02a9c48@arm.com>
Date: Wed, 8 Apr 2026 09:15:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: proc: document ProtectionKey in smaps
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, Dave Hansen <dave.hansen@intel.com>,
 linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Yury Khrustalev <yury.khrustalev@arm.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260407125133.564182-1-kevin.brodsky@arm.com>
 <98880cc2-09be-4bd8-b8f4-f0f0845f939e@intel.com>
 <2d2aac86-2780-4a29-9eef-116c26485812@arm.com>
 <18e2042c-d414-40fb-8819-5e930d5b1584@infradead.org>
 <8a5e4afd-cd0a-400a-8624-79c1dc9e3ff3@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <8a5e4afd-cd0a-400a-8624-79c1dc9e3ff3@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8765240009
X-Stat-Signature: d5nxqac1nmushqombwadp6zd9rmnwrqr
X-HE-Tag: 1775632517-558890
X-HE-Meta: U2FsdGVkX1+YRP+cbwikrsYW6C3OZtC8FGpJpXh6bAhOBrYfaCq5eFGEsgb14NV0uFXZUWEPz2hpjupvASgdjPUD695YTPkxG5oCU4IC5u2CyCWZNeBlmpK+y/t4mZhklaqHmgoXiQgJqylj5rhmtwRM9rBTbZWjj9IRsW5rt/m/D0vnJRyTCaPgNVwigcc9JmKd74yc3t7iFf+u/xRUgSZdtqPDeLKwwQmAo0LO39mrFfs+840mmdSqk6LMVVbxgVCCyIKCQJtgMOP6OAzhJpVbMwmtc0EtQFvASt2u+WHWSIP/MaLozEsax3PfmocXvsbr7DniqzxbBbx4Iug4E4ZLvnfAnzgrdqlu4iP9lTCMngono5dQl2M1EIsm4pbRDEyne3mKST7/iRS+mUgvJxTF0Op7IuVXI60H5Qp9a17+wbm6K2kXJDEdVOJSdPGTanS+s9qq3o74R6r3F7mE5N4akz5wBgIDSUABLZMaRQr8FWgnZxwn8Sheodgu5uSV6NokS4hVbLl8//aQ+rrz148L1u+qatK6BBqD/bOh6YpWEzY1TdCF+wStjGYmmWuJIKbVJtyUAJ0ApnZoc/qqchkAzAUwJ1LLP3FKBuscmN8SHO1qdvct/P/6SGF8WT4CW6Vmcq3cyaWvsei6zjO1Q3WarlqNmzcCy6tOLiMZZcINE0RTRBcKVVyxWUWSqLsLk6d8JmWQa8FiSmInyt0NwDawQRbu0Fao4Xd19wXQpqIVcnaZ5/v31/c71qDVmVjQVlJ3c3RHZKx6V2nsu3YW4JDKUyGGvls2SREVmaROzHa9+KxgmkB8iozO8+F19bMSNtOWJTJwI1xOODzzZzHA+nWyOgEtb/JHjd9v8cI2+aGNi7xgAQg5pFTqYDB2TSnVQEWY6FDlho+FIR7Gi3j2PAVh3b6y0fLoKwQ4tJLyAuvJvWLqCIul/cZvYRYddw3eZ1Bp9jyu0bBtD2Bhits
 3+iYNa0y
 IkIQZ3HvQyiqifkTL4HdpzyH2KcN7AWi+ukaDuUxblx8yPO5E7CV+Ay1ycUKiivCQluaDP2r5/8GpuWo24O0K8geNZkpI4wuX1e0TPw26t0UVlVomf+Dx2aVxTd+bIu+MdX/W3x8xWVzFcp8lYUecA93P7JlwKskfcW00v02a46c+k+SIs3H0C/72/fUFs04wcEaLiip7r5doYgkRL8kQuwAcllU9ZZHNWQNt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/04/2026 09:05, David Hildenbrand (Arm) wrote:
>>>> To me "system" is a bit ambiguous here but _can_ refer to the whole
>>>> hardware/software system as a whole. To avoid redundancy, I'd say either:
>>>>
>>>> 	If both the kernel and the processor support protection keys...
>>>>
>>>> or
>>>>
>>>> 	If the system supports protection keys...
>>> I see your point. By "system" I essentially mean the hardware (the SoC).
>>> In general I would tend to avoid "processor" because not all CPUs in a
>>> system necessarily have the same features, and some features require
>>> hardware support beyond the CPU itself. Terminology is hard...
>>>
>>> Happy to replace "system" with "hardware" if that's clearer 🙂
>> I think that "system" is too nebulous there, so I would prefer to see
>> "hardware" instead.
> What if you're running in a VM where the feature is hidden ... ?

Of course that's also possible, "hardware" has to be interpreted in the
context of virtualisation... But granted it is possible to hide features
even on the host with the right kernel parameter, on arm64 at least.

"If the kernel supports protection keys (pkeys) and the hardware feature
is detected"? Still vague but a little more accurate.

- Kevin

