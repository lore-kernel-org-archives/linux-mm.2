Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CD65CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 15:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE1C08E0032; Wed, 17 Sep 2025 11:02:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB8FF8E0003; Wed, 17 Sep 2025 11:02:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CF148E0032; Wed, 17 Sep 2025 11:02:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 89C268E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:02:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2C5F1BA391
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:02:38 +0000 (UTC)
X-FDA: 83899058796.29.76BEC7B
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id D16B5C0008
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:02:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=zDcJ0rws;
	spf=pass (imf22.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.218.49 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758121356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lIUjmKGGbQEJsCoFeZig1jDOJNxeqR+9vgxX7Gkos/k=;
	b=xziVcXjYHMa5JBPkBj+yATCimav+XIWCEjNP/EHbkfi20SqzmSWKwUwWvKEo9jTnlD/V0L
	ej5Pn53S+/+PNniO7M/6QkbKfmZx9q/2riftZS25U3I6KyIBu9Z0th7pg0pIDaXhGwQzBk
	hhpw1mUnOnJidjQVj+u6BXb/sp7QrE8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758121356; a=rsa-sha256;
	cv=none;
	b=PMQ88JG9XG22ru336/ZGy4yUrki5gazloyI7E1PAYVJL4cEXOtwCS3owliEvO/wJG+jfAX
	bZTEU0+vg5mro50V3HBtM3q3TRToPiQ3+WS1pNpznO+M5pUeSKbR7s1CoXzSIgtakqFrYt
	UMfMTrZBhKrBfXg93eO3cPj9Q7fXgAo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=zDcJ0rws;
	spf=pass (imf22.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.218.49 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-afcb78ead12so980925766b.1
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1758121354; x=1758726154; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lIUjmKGGbQEJsCoFeZig1jDOJNxeqR+9vgxX7Gkos/k=;
        b=zDcJ0rwspCI4eCmJAKGp9ijOqi24k1iJMwHwGgDW6vXiNxB8bRiNx8dSA9E+KJxwpP
         LMRQvoYM8zX8ii9huFtGpwv7aGwpcYLl0wllm4sYZJ/vOD7p8Un9Ws82+jwJ5shNnhH7
         9xRETPL64McVKEy1Nd+Ue6Dw/nkK1qSOhFb3mFRd/ari4DXvMRq05vAO0eVKrR4phKvB
         +qR/2kz1TqrTrcOws0OLUf/Nplu71wP9o25IAqvJ5nvM0ja4ylk87VZsx+LZue6IbM8g
         8WP6DNGlwYDA4z1BofqFZCIe8Yv5WklHrfJHmaSJAT5pgs9HCs5+9+BZTGKWgJDQqFO4
         AEhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758121354; x=1758726154;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lIUjmKGGbQEJsCoFeZig1jDOJNxeqR+9vgxX7Gkos/k=;
        b=hHRTZSmAEiLjFyoApMegKLwb97UMoATTzh7iSvQMdPVlU0MLjOqrsThM3ZbIep21Lm
         plO93e7pp7Cw6tu6VU6xfRlGBIeo+zKwK8sycI3k/PD4IBeYz1zffd8wiKRSdwd3NFgi
         vIwCWXAJjkpNGbIP/brtoYFpL3dew59WxtJHZsCBFrBjV5QDQvriwNEMygCBv/pK8T9T
         Uh/rfGM0nXYEyUoXx1rzJFQ7Fl7QM5OxYjSGbOiFRsMJzDMB8coTE1eH3LAZin2c156a
         +pVGdierjjznwY2FlF72iK98OjuJcd1fcfYgiqDBaF6amD11Of7vhBw/nwjfEIU1hMR2
         Vg5w==
X-Forwarded-Encrypted: i=1; AJvYcCXO22xUMs3qXOC7BFQ1Ja6nRQMsR0iaLRZHcrSeLvHsI9eRqGSF65y/H4a2SV5nkfDeirtMj/efBA==@kvack.org
X-Gm-Message-State: AOJu0YwVf7x+iyN/nayWERQv0GzNqru5cPLDC9gPT3mnAUJKyMXepnXQ
	vx9dfUlh4RZmeF4G2vD3/Hc0Kx6AFsU0tmyOvcwd+MOdiQRTAuaAxzps8UqPGABzmiY=
X-Gm-Gg: ASbGnctgKvqkF7uwqU0tOoXQIwz+FTJk8/SWGmcb+m6y3FYDF0AeU+0D8VWiyiTMmX+
	nxy4BI7+ZVrqQmyUzbm8jsnxGL6P4vmskoyLF5Ar8oJ7/c6osIuXkB18d2mUN1Q5wriIyQktawF
	L8XYU9BBzi08upyZ/VR/TOcIi6NYUFYXND1skWfOwo1iW3iKOnF0dhbq/jxNNCfxpo6UDjYj2aK
	CmbNK2rXzD264tojrTQH8pceAsHgkqaITFO/Gb2J2jpTx2hn2NuaB8GeVI5K3jPv1SXD1o8x/fF
	NsZvvaE0ki+Cg7urV/NUYOHOsx59fmg+SMB09TCTaeu4I2mA82///v295OXf9m9xGM/i6oNLjNd
	m6I7drsRzlWDEphs7FN3yZsCnBYFZvi2t
X-Google-Smtp-Source: AGHT+IH30uplY82utdrU9T7Dyp89uUZLy9OYpPpZfnqv2x2yCGVqH4bKpd1FnewjvmvV1dBnafhklA==
X-Received: by 2002:a17:907:6ea4:b0:b04:85f2:d272 with SMTP id a640c23a62f3a-b1bb935d70fmr292343066b.49.1758121353549;
        Wed, 17 Sep 2025 08:02:33 -0700 (PDT)
Received: from [172.20.10.3] ([109.166.135.151])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b07b3347b90sm1362672466b.109.2025.09.17.08.02.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 08:02:33 -0700 (PDT)
Message-ID: <24d6a51d-f5f8-44d7-94cb-58b71ebf473a@linaro.org>
Date: Wed, 17 Sep 2025 18:02:30 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v3 09/16] genirq/irqdesc: Have nr_irqs as non-static
To: David Hildenbrand <david@redhat.com>, Thomas Gleixner
 <tglx@linutronix.de>, linux-arm-msm@vger.kernel.org,
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
From: Eugen Hristev <eugen.hristev@linaro.org>
Content-Language: en-US
In-Reply-To: <95ff36c2-284a-46ba-984b-a3286402ebf8@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8o8ouu9qakrhkwqbj9e9myhzu14nsos5
X-Rspam-User: 
X-Rspamd-Queue-Id: D16B5C0008
X-Rspamd-Server: rspam10
X-HE-Tag: 1758121355-262223
X-HE-Meta: U2FsdGVkX19sGGBUBzu36VcYEAI4rKP3rx+kMSd51CdrWaH1JIwtQjlYj3Oyeh8jXGpjyTQPH3Bixe+SibHbd9Q3o+tYT60DELzDwwLJqW1S2vqoZs0wz3bX4INwC7SWayCEOp/PAQmskai2D+PWTaH8rEqADnbcLfxXnkQUP0ECXPkmlUgvrV9ngVumOrcSm0zPqcd4T388vt9+nlbsruLF7oDbvCGumUGcfQu2dLsMlj7unKs2FrF92TMQ4qKr5PRvy2LmAYuchZCzpnZE7oxK83EIUHcqqA9T6xSd2K9aPTuF93lFx97Rr2wHzhx3M2S2COhNXDXmnCuwYwE0pJbRiHdnnvy2Fm5tGT+wAbht4ihNrN/YHphNdPx3jN+Bbe+iYW9BG3ZP4NdM4qab8Thd/IZRFnYBEW9z9b0pcUmPaysHt+ZoOgFAh2tKg2wP0haqNMlGEQyXaYJkmrD7MB4XtepyEjaJ6BXBTrTsDmBBXtOiBcUDvOOrM8w5WepyMscF6C4FywBgnwinwi3IvkaYD7XHFX9qUr+HES0AAJY9byo1CqEn+jOyMHR/qAtRDFxkSRslGnp8T5hJ/CJ0WiJ4rZ0hE5m3ALMOQzJSLB4ACJmnStaOh5pqO7fnIP9JYrOD9ciGJKgusRV9RR4FpGCT9d8yw8ceo2zJlbMbxxPoHB5o8g0+ZXmQudOxvGGKokEveVqkiFhlrwOvjWnGj6bmU3/iK4qrfdgwFicXOvNw703jkaqlQtA3ZBN2PqRD8YZoi2JuMkjxc0UfMwteoBKqhUtMxwN/m16bxYErnNFK+5nW5HSn3rein+TjLFVc7u8S1xkeyPe+YkOmO8h5qafNNmDp2YmO+25+AU3loNZ894gZIIPW2TgyIJS7cz20gAlMkGD6rMT0coVxlx+wckd//B9fWlADOuhtFuEZ+fjl3pNxWQqVFnw5RwqzQs4EmLkHZ+VeJ/NLfCQUxgm
 XX8gbB44
 8iLHUZ/WjP8YKlwTomxbe58VUSu9eLgT2momVo14v3Qdhq2vVSAti3s36vbOWZN5mn5L2fK1KbLeYGKf4ZM4B/cBt4r2b/wy/WTrmPRTJ6EhbNqItbHSy3ov/PIlTxXCj2dGyH7lEBw1+bA+ARb5uSmzpXL3RkioG03E4AJgtP3brAlhs5Fdku3SPQB2+TgT5NClt1tHdcwb9u3onnaS7mPZqD24zVFLk7I5k3xRNgv1QT2efy4oaMD4+3o1hAT32mAsTRqToVAy167vrYwwAF77ktVS4+J7Y9kNuCdAj1JhcifDzaEf+pgw0D6ECi2ZAvS+prrw1jn+XnOwBBalDJQds/Ekc4LBKlYLUN0KjNTe/mLbFFEZXEqy4F6xuhAN9U9UNUsDKKfzHXf2XuNUZ8sH4YadsVUcvWvWaNzUF38i8l3Y0Jg0eKyAC159LdLIcD1TzQQSW0vP7Gg6hHMRPcKwBhA/1rQI9NQ8Yuzl5IHJeH7A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/17/25 17:46, David Hildenbrand wrote:
> On 17.09.25 16:10, Thomas Gleixner wrote:
>> On Wed, Sep 17 2025 at 09:16, David Hildenbrand wrote:
>>> On 17.09.25 07:43, Eugen Hristev wrote:
>>>> On 9/17/25 00:16, Thomas Gleixner wrote:
>>>>> I pointed you to a solution for that and just because David does not
>>>>> like it means that it's acceptable to fiddle in subsystems and expose
>>>>> their carefully localized variables.
>>>
>>> It would have been great if we could have had that discussion in the
>>> previous thread.
>>
>> Sorry. I was busy with other stuff and did not pay attention to that
>> discussion.
> 
> I understand, I'm busy with too much stuff such that sometimes it might 
> be good to interrupt me earlier: "David, nooo, you're all wrong"
> 
>>
>>> Some other subsystem wants to have access to this information. I agree
>>> that exposing these variables as r/w globally is not ideal.
>>
>> It's a nono in this case. We had bugs (long ago) where people fiddled
>> with this stuff (I assume accidentally for my mental sanity sake) and
>> caused really nasty to debug issues. C is a horrible language to
>> encapsulate stuff properly as we all know.
> 
> Yeah, there is this ACCESS_PRIVATE stuff but it only works with structs 
> and relies on sparse IIRC.
> 
>>
>>> I raised the alternative of exposing areas or other information through
>>> simple helper functions that kmemdump can just use to compose whatever
>>> it needs to compose.
>>>
>>> Do we really need that .section thingy?
>>
>> The section thing is simple and straight forward as it just puts the
>> annotated stuff into the section along with size and id and I definitely
>> find that more palatable, than sprinkling random functions all over the
>> place to register stuff.
>>
>> Sure, you can achieve the same thing with an accessor function. In case
>> of nr_irqs there is already one: irq_get_nr_irqs(), but for places which
> 
> Right, the challenge really is that we want the memory range covered by 
> that address, otherwise it would be easy.
> 
>> do not expose the information already for real functional reasons adding
>> such helpers just for this coredump muck is really worse than having a
>> clearly descriptive and obvious annotation which results in the section
>> build.
> 
> Yeah, I'm mostly unhappy about the "#include <linux/kmemdump.h>" stuff.
> 
> Guess it would all feel less "kmemdump" specific if we would just have a 
> generic way to tag/describe certain physical memory areas and kmemdump 
> would simply make use of that.

The idea was to make "kmemdump" exactly this generic way to tag/describe
the memory.
If we would call it differently , simply dump , would it be better ?
e.g. include linux/dump.h
and then DUMP(var, size) ?

could we call it maybe MARK ? or TAG ?
TAG_MEM(area, size)

this would go to a separate section called .tagged_memory.

Then anyone can walk through the section and collect the data.

I am just coming up with ideas here.
Could it be even part of mm.h instead of having a new header perhaps ?
Then we won't need to include one more.

> 
> For example, wondering if it could come in handy to have an ordinary 
> vmcoreinfo header contain this information as well?
> 
> Case in point, right now we do in crash_save_vmcoreinfo_init()
> 
> 	VMCOREINFO_SYMBOL_ARRAY(mem_section);
> 	VMCOREINFO_LENGTH(mem_section, NR_SECTION_ROOTS);
> 	VMCOREINFO_STRUCT_SIZE(mem_section);
> 
> And in kmemdump code we do
> 
> 	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_mem_section,
> 			     (void *)&mem_section, sizeof(mem_section));
> 
> I guess both cases actually describe roughly the same information: An 
> area with a given name.
> 
> Note 1: Wondering if sizeof(mem_section) is actually correct in the 
> kmemdump case
> 
> Note 2: Wondering if kmemdump would also want the struct size, not just 
> the area length.

For kmemdump, right now, debugging without vmlinux symbols is rather
impossible, so we have all that information from vmlinux.
> 
> (memblock alloc wrappers are a separate discussion)
> 
>>
>> The charm of sections is that they don't neither extra code nor stubs or
>> ifdeffery when a certain subsystem is disabled and therefore no
>> information available.
> 
> Extra code is a very good point.
> 
>>
>> I'm not insisting on sections, but having a table of 2k instead of
>> hundred functions, stubs and whatever is definitely a win to me.
> 
> So far it looks like it's not that many, but of course, the question 
> would be how it evolves.
> 


