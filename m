Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FCBAC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 08:31:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19D0F6B008C; Thu, 10 Sep 2026 04:31:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14E516B0093; Thu, 10 Sep 2026 04:31:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03E946B0095; Thu, 10 Sep 2026 04:31:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D21C26B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:31:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE62540419
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:31:02 +0000 (UTC)
X-FDA: 85197182364.17.D5CAC14
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8C51E140010
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:31:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DWJSh1qt;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789029060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MqiykUoJZh6JjDq4MJq+BR4QK3p6ZlqAmI2a1v4J/gs=;
	b=fSxlx442Wgs3bIecvvYsM+IhAMq0nyVmntmobyE7jhKmV13AIrQvAA+ha9OBxlrIA9x4Wv
	qlnj2LK6kYuPXq1FvisWVlUyAE6NxESzgTYlVm7OG1kaCbDBwwrBr/B17qf6p03A29x6rk
	whIe6yY1b7p01y38/fZVNW8jqY7dKSc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789029060;
	b=TbGRARxpd76kwo3zHgHAhH77X0IiBY6WrqK0yJ+jeQKYxcHtIvgEUjs/k6sAbTtszm+e6s
	DXjceIuhdIw9nZmejeyDndxxbad3KLQWFoAwrS7LoiUqckLAoc4Z50eq3ovuURCVG3xT3G
	DhSXkS3gW/sGs5ugADPryVBJlApwR/0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DWJSh1qt;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D98841570;
	Thu, 10 Sep 2026 01:30:55 -0700 (PDT)
Received: from [10.57.7.224] (unknown [10.57.7.224])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B990F3F7B4;
	Thu, 10 Sep 2026 01:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789029059; bh=YNtmWp0abywy18qRTZCAY47Y6tMmxx0rj25frpxeOnA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DWJSh1qt1lqFX/3Ix9EACo+WwD3ovBUlVqewO0zd7XPHLmF+fuPc2nOZnWep92Kne
	 +iAnObxSHma2MOV52FFZfDMZyIlUVrpEjKyTQ7qwpbd/iDJhjEEY7OnLqAXAemlctC
	 jfDffljyM8YroIEku4ZQbLmrl1jMqSdDUBWvj5HY=
Message-ID: <46a747b8-bc06-4ccc-9265-68aa613bd7c4@arm.com>
Date: Thu, 10 Sep 2026 10:30:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v9 00/25] pkeys-based page table hardening
To: Linu Cherian <linu.cherian@arm.com>
Cc: linux-hardening@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <apbgDNjQPLBdsUe0@a079125.arm.com>
 <43382882-0e7b-4255-9c34-99cec5b0bbbc@arm.com>
 <ap6rvQJbO8DH57v8@a079125.arm.com>
 <ba80aecd-85a2-4036-8d53-009f476f8e61@arm.com>
 <aqAyAymMO5sytqtr@a079125.arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <aqAyAymMO5sytqtr@a079125.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8C51E140010
X-Stat-Signature: 8wk5s9i1rym4n6gyya76hw3tsiiej9ec
X-Rspam-User: 
X-HE-Tag: 1789029060-752246
X-HE-Meta: U2FsdGVkX1+T0tn7ZiDt+mnVy1fgq4etr3TMELNa3T5U7ZvfPQNgyodFWvyNqlimDppxx+K+HqHNyZjSTsZDMzBlBaZIZa1NhyJYel8zjgx2S9hoKibLLOMiagnwNL86y5XCs4S37+HXsoUFLy76UAZ1vaESGwqIVAYvBwBs3aniFKlsc5fZySlZ7FK5Ls3lXjULWR4T6G0qc5xfEF7OxQIY+9pVIjH55AwoPyxrHuYDX04zN5uFODJv7bVPGTV28JLatKR0exd51YCgCzkYwFeJxtB9yyPqtn9QBlwykEUl+bYemdCQQDkkG/OrfrdaLhUZW0hmecMoes7iNZFbjv+0XR03IgT8VYzI7MzPt7dRgxSFrUD5q0nVJfYWEMCjQfnsm0TAkJdblxZTeIAXYz58ix+jF3JzHk4QBTMa0J7BSDTPZT3O9rgpHxaWvgjRmEmd1jf4fDZwBT688E/+Mj1oCbv0URfIQ1XPUPg6SyjtwcsRMUNXCtdm8v/V/xYqEexHR28WQFuOxoQhKoHi1RsoIJEhL0p8DfzIyq8XNqWPLnBf8m+8ek7XRL/W7sAP67JlhnUxuGpn+tRsezA9KjmqGepc4WbqHkKKQb3RA90xTkuFaCOhF2uJD33D27cX8Cul4I3lN4j9C1k20xK7kF270asC+0fp8Rl5OVrpoovjGpcYb2ahex5jnjjYzBlTPDGO90JjNmB4ZA6zW1FBfkmzO25ZxrD9oioahLHjnnDGtljdeBygvP8QiADEA9TSLm/7QpC1cpkG/4ItmfRJU9Uas2FlW2RvBkc26JCpIYyojZKPL5VgtmAWP5AkWj2WVbaokDtDofR8RLRDwJPZOLyNg3ZNW83gEnvGD6jZxvmOswiyldWQuZtoipZ78sFhnpR/MLd9apkGHLRrNxhCAe4nN2Et5beQSuz+7+cN0wF2akRRHVv0zu6erj7dHcnvHW+6CwnYNjAZuPdvH4H
 yTEJvbhg
 Eyil+Xk6J6IYXpo8Vir5sapG6MoX2934n1Vto87sv2u/DEUlNpX2lljV150G3N4tzKraEletymrEcnfilhL33msNX+CHs6/eAtt/hJthhEJPRlUL3fg56wZcHcGTdG5NrJ9dOWUgAFMwf7mXSFgegu5VwXq8hjaFaisa/8ulivO4chPAve9LeE/L2+wRleo3IuYeNEFBfV521DpDO4NPdId32hOyAblLXD3rwp8z8VzI2MKs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/09/2026 18:04, Linu Cherian wrote:
>> [...]
>>
>>>>>> Open questions
>>>>>> ==============
>>>>>>
>>>>>> A few aspects in this RFC that are debatable and/or worth discussing:
>>>>>>
>>>>>> - There is currently no restriction on how kpkeys contexts map to pkeys
>>>>>>   permissions. A typical approach is to allocate one pkey per context and
>>>>>>   make it writable in that context only. As the number of contexts
>>>>> Probably to avoid the assumption, may be we can we have something like
>>>>> below 
>>>>>
>>>>> For a pkey P, we could define
>>>>> PKEY_P_PERM_CTXT_OTHERS	 //permission for pkey p in other contexts
>>>>> PKEY_P_PERM_CTXT_SELF	 //permission for pkey p in self context
>>>>>
>>>>> With the assumption of one pkey mapped for every context,
>>>>> the permission for the default context would look something like,
>>>>>
>>>>> PKEY_DEF_PERM_CTXT_SELF << PKEY_DEF_PKEY_SHIFT |
>>>>> PKEY_CT0_PERM_CTXT_OTHERS << PKEY_CT0_PKEY_SHIFT | 
>>>>> PKEY_CT1_PERM_CTXT_OTHERS << PKEY_CT1_PKEY_SHIFT |
>>>>> ...(for all valid contexts)
>>>>>
>>>>> where,
>>>>> Permission key, PKEY_DEF is associated with context DEFAULT,
>>>>> Permission key, PKEY_CT0 is associated with context CT0,
>>>>> Permission key, PKEY_CT1 is associated with context CT1
>>>> This adds assumptions rather than avoiding them. *Typically* when adding
>>>> a context you'd allocate a pkey that's only writable by this context,
>>>> but it doesn't have to be this way.
>>> Okay agree. Then may be something like
>>>
>>> Define permissions:
>>>
>>> For default context,
>>> KPKEYS_CTX_DEFAULT_PERM_PKEY_DEF
>>> KPKEYS_CTX_DEFAULT_PERM_PKEY_CT0
>>>
>>> For CT0 context,
>>> KPKEYS_CTX_CT0_PERM_PKEY_DEF
>>> KPKEYS_CTX_CT0_PERM_PKEY_CT0
>>>
>>> Define POR_EL1:
>>>
>>> For default context,
>>> KPKEYS_POR_EL1_DEFAULT
>>>
>>> For CT0 context,
>>> KPKEYS_POR_EL1_CT0
>>>
>>> Finally,
>>> #define POR_EL1_INIT KPKEYS_POR_EL1_DEFAULT
>> We cannot do this because POR_EL1 is arm64-specific and its format is
>> not at all the same as x86's PKRS for instance.
>>
>> I think what you're getting at is that the permissions for each pkeys in
>> a given context could be defined at the generic level. This could be
>> done, but I'm not sure this is essential, and we may not need all archs
>> to use exactly the same permissions. There's also the issue that x86
>> only encodes RW permissions directly, not X.
> Really didnt mean to keep these macros generic. Sorry for the confusion. I could
> have replied this on a arm64 specific patch.
>
> The original intention was to suggest the use of macros similar to above in the arm64
> world.

Ah I see :) The problem is that again, kpkeys is not supposed to take
over the entire POR_EL1, just the pkeys we've allocated for it (0 and 1
for now). What could be done is something like

#define CTX_DEFAULT_PKEY_0_PERMS RW
#define CTX_DEFAULT_PKEY_PGTABLES_PERMS R

#define CTX_PGTABLES_PKEY_0_PERMS RW
#define CTX_PGTABLES_PKEY_PGTABLES_PERMS RW

That seems very heavy to me though. Is there really something wrong with
what por_set_kpkeys_context() does? I'd argue it's at least as readable
as #defining the configuration for each context, especially when the
number of pkeys increases.


>
>>> Probably using something similar would make the idea of kpkeys context 
>>> more evident in the code as well ?
>>>
>>>> The configuration space is more easily understood by considering the
>>>> other use-cases we've investigated (struct cred protection and eBPF
>>>> isolation, linked further down). For instance, for cred protection, we
>>>> had KPKEYS_LVL_UNRESTRICTED with write access to all pkeys, and for eBPF
>>>> isolation, we need a level that is less privileged and therefore does
>>>> *not* have write access to pkey 0.
>>>>
>>>>>>   increases, we may however run out of pkeys, especially on arm64 (just
>>>>>>   8 pkeys with POE). Depending on the use-cases, it may be acceptable to
>>>>>>   use the same pkey for the data associated to multiple contexts.
>>>>> Lets say two contexts A and B, use the same pkey P as their permission matches.
>>>>> But then, when we enter context A, permission for pkey P gets
>>>>> relaxed, then that would relax permission for pages associated with
>>>>> context B as well which is unintended ?
>>>> That may be exactly what is intended, it all depends on the use-case. C1
>>>> may have a private pkey P1, and C2 P2, and then P3 that is shared by C1
>>>> and C2 (writable by both)
>>> Got it. With each context defining permissions for each pkey owned by
>>> kpkeys makes sense. 
>>>
>>> Also do we need to assume that nesting of different contexts is not valid ?
>>> For example,
>>> Default context:
>>> 	enter CTX 0
>>> 		enter CTX 1
>>> 		leave CTX 1
>>> 	leave CTX 0
>>> Default context:
>> That is a good question. The enter/leave logic does support nesting,
>> since leave() restores the pkeys register as it was on enter(), but
>> whether the inner context has sufficient permissions will depend on the
>> situation. Certainly if nesting is expected then it has to be taken into
>> account when defining the permissions for each context.
>>
> Exactly. Also if nesting need to be disallowed for certain contexts,
> then it needs to be taken care as well ?  Feels like would be worth
> covering the aspect of nesting in documentation and cover letter.

I think having logic allowing/denying nesting would be overkill at this
stage, but agreed this should be documented.

- Kevin

