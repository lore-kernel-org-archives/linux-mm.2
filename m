Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E58ACAC5A0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 15:44:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 992378E004E; Wed, 17 Sep 2025 11:44:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 943358E003B; Wed, 17 Sep 2025 11:44:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 831FA8E004E; Wed, 17 Sep 2025 11:44:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6AA978E003B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:44:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 140871405D7
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:44:40 +0000 (UTC)
X-FDA: 83899164720.22.F0D265A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8754D1A0009
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:44:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cwkk3W7w;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758123877; a=rsa-sha256;
	cv=none;
	b=xtrdpoy1kTrgDJkz4HsRROqfG/6z7GiKi1o4/2f6RXfPpcYWRlDoIpKZHXwGNiwfUPH/V3
	7mnwio5REyeJIe/O0rxswPANzuSmFB9caGcJAQ8ykZVBQ37OyuVl3h1877bUKRFKibgvZ3
	+9k7TPWQkUpRR82YywaXzhGW+lNHO50=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cwkk3W7w;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758123877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NYmqILMx1xlw2m4tQW0RBlUiktKctlRRDbbC0EtpRGc=;
	b=uQdPgu7jzy3/zlR+7BUVWNfX0VngdSSqtSaqufcSaGH50w571sYCNZfMh8j8x07LUutaHa
	5n/HYAVjcHsqeerpXpQi+AV7W6AHMa7Nj8Xkz76wPPjRnrHdHhC87wE6tgsk3exiYQeMio
	gRY06MiEBSb6LlAoPoOOISnbruuOG18=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758123876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NYmqILMx1xlw2m4tQW0RBlUiktKctlRRDbbC0EtpRGc=;
	b=cwkk3W7wqYfsTE3pJwE+zWFsPvzk9U2WG81MTFCDaE9OBSHffX+6aXU3OUY2en6ElvxaYq
	VQpV3ypV/9NamRM+vFhgqIIA8KCicxSPB7MPy+7CYtm7lWBude10nlnVASim+npPYFiVQQ
	CVK+CnaaCG3Pt4jqjamfcelHzzZrPcE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-339-FxeEF4t8P2yOVeJZ4MpR4Q-1; Wed, 17 Sep 2025 11:44:35 -0400
X-MC-Unique: FxeEF4t8P2yOVeJZ4MpR4Q-1
X-Mimecast-MFC-AGG-ID: FxeEF4t8P2yOVeJZ4MpR4Q_1758123874
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45cb604427fso43436995e9.1
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:44:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758123874; x=1758728674;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NYmqILMx1xlw2m4tQW0RBlUiktKctlRRDbbC0EtpRGc=;
        b=HXnCwqzRegBkjFva1X2FLUinKUC9fTrExPZ7CrLlfdT2qUDdQeJny2bMf+Jd7QtZ67
         aQo4Dn/XNYfGZhoInZ9DZm8ANsM7CM/Cy/+/sDCMuy6YEG1iyzdZsHAVIHPvS0emD4SN
         6XEEq3hoL9vB1FAsp9ZMWMgY/8MNoNrKo56P3SMbQkiCQO2857RFzXfKdcigqAXbjBZZ
         1VW+BSLZ8rO0hFPOshFCA51Wce2nFUKrxrkBPqxecNeLbCcgUrHy66Jct8sqi7O4kk8a
         LuWuUETXVRW6Km7OZoRNB5XfwT5aAEPorEtDhOoXAaRP0HQ9rDvURpAGl0JP7ME0RHNk
         71kg==
X-Forwarded-Encrypted: i=1; AJvYcCWM5qVNhIGWS3NHprry/2NJSx910UL/Ft/NlPLCdGdgIMcusBCmUW16kWFUmu9oHUAGPSRdzbAlqA==@kvack.org
X-Gm-Message-State: AOJu0YwczGiDxz3H/vHQtXhU1t0pACPq3nLkh5tUx7LkWsaH+RnNLSFE
	Xo5tB8jAZiejNu7UBrLaLM9MWZUOL0OWBveDPudsABmjdXXBZDHbhTifwKh1GOA66uUqzGS3skm
	NANQ9fc5CDma0dv3qc785oNoW+DFP2SzKUZWBV1mCeU6kyPmOtfSe
X-Gm-Gg: ASbGncuLEfv1iT9DwVP4yUHviGQZuS4wiWt2caCqGSEMP7wQ/ivGIPZFZCdHyIRBuPg
	iAt9Hx1WwRft6JCPEUlN2UAPscCZNtMua8D7jb92kZ5cas9ZyL2rqgc5NL6NCyFnI+dVxjJwCMB
	aGwg96Yk9JgFvY71VjuvktZxlqHMMxAVVbDLl3y6+GnEPO6pJ4a2mNjv3qbd1Xjg9r4LLFgVafp
	aa/M7vfw/yN13EkiuKJdgubxaU1FyYLC6v08ljI9Gbfyf9l/MSupwSQ/qalcP8syNhvQzQG6lin
	G/IIkS9V9oYgavyEeZmEYHRuUhnbi282sFQ/qF/Zc6Xd6z76cKCMW8gSmI1pDyfjGvoe4CjD3vX
	XEKmtk8sCVr5UzDL3nLflg0sJp7emAFM7ywgHpA0TMR2GddM03sYoNf5m2mYFZUjl
X-Received: by 2002:a05:600c:548f:b0:45f:2c7c:c1ed with SMTP id 5b1f17b1804b1-46201f8b0f7mr24718635e9.2.1758123874118;
        Wed, 17 Sep 2025 08:44:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH8g1ZaRN7oJUXl7N8nfBOuCnjfDBEtxRyVeyDn4nu6ScGXDtKea6BR0IkCAuJ/wYcffRSBqQ==
X-Received: by 2002:a05:600c:548f:b0:45f:2c7c:c1ed with SMTP id 5b1f17b1804b1-46201f8b0f7mr24718205e9.2.1758123873544;
        Wed, 17 Sep 2025 08:44:33 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f27:6d00:7b96:afc9:83d0:5bd? (p200300d82f276d007b96afc983d005bd.dip0.t-ipconnect.de. [2003:d8:2f27:6d00:7b96:afc9:83d0:5bd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-462c17c9347sm10474045e9.0.2025.09.17.08.44.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 08:44:32 -0700 (PDT)
Message-ID: <b532ab38-37a3-46d0-8a14-d7395421130d@redhat.com>
Date: Wed, 17 Sep 2025 17:44:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v3 09/16] genirq/irqdesc: Have nr_irqs as non-static
To: Eugen Hristev <eugen.hristev@linaro.org>,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-msm@vger.kernel.org,
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
 <7f4aa4c6-7b77-422b-9f7a-d01530c54bff@redhat.com>
 <10540b3e-09ca-403d-bc20-b9412a7fe28a@linaro.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <10540b3e-09ca-403d-bc20-b9412a7fe28a@linaro.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: acYVw7IHNsT7Cn3jclIOT73Fu6jlJOAgYSdsAcUZXqc_1758123874
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8754D1A0009
X-Stat-Signature: wwam5ky8pj1yr7r8jc5zkd3sds9eaab5
X-Rspam-User: 
X-HE-Tag: 1758123877-848586
X-HE-Meta: U2FsdGVkX1+M2VBW8WjKa9qW6/HB5rY8vfqFGPQw2JNbVV/dlGSwEYMLNQSPXM8RkYf46v2ofUIit9xPU5Xi/dCgi45lgmh4R9YZhOI9aj3x14ZI9LY0b928z1QXV6tU9cm8DD0tjyYKnuDzm5/g1DrcNba+3CAYhe4YnfCELEKBqt/4NJpR2kBE+lHP877Z8pXqYKKgKK+95NVNI+Vx7Dc74RWFoyiAedb/vf3KBb4hBYHTOOFlHT5mKXGv0C1YN6+0IFK0F5R4015pVUtkaswWXpERufB6nbGn1fvnelM8DzkvzQDEj1Q0uuWM9hwO2ldoVuXNMkl+vQd6PXocMuxdom6FT9g5An0bsXWn5hTQjtvjYbRNDd41aLP1fMH6P+7X1uN+LiiHLRqAeqHlrgDu5+Dq06Nn1Z6lagg6zBAILnJ+Zt/yWL0+bnLP9QBFjK7Lc5v457LRjpCSNxh1CVVx7KM4k4tjnonlN5+EzdQGT2tnBjmA6fUekB/qOZqCSDqSWCnJY7F5TtpOAtaZiMEcEFJ6M1iZgDsBAjK0ihioEl6Ypk9ot++TC7MY1fZMhOqJEA4Ibq1AdSqPlM+ORVpkA43FW+ieLEnz22J4soL5yGhoYqrKkYn9AgXtr2wlPbsWPFn8eDke3BHE7gU76HBa+pm+WFKPwUn+8Ttlh4gzY3apMZoXjHdVBhX+EGwReeGiMuTyAse8ywe+5fSYQ409vINxrIFr4cn1zqYFkwXBy9BQUfrnI51USYJkThRrdLdD/Ktqg5OM4hRMOF4TY7a//u6MrqM8g2CSaK1o8AjH4aVqWrZv4U8F+fOc5QRGRg0XKCGl51HG8e/wClf/RwF01pTAeXfBdKmkwy9fXdq7o9i4saPKCxkzhi9pE6QDjF10xNuXs2wBjcRGOZCTdtTznqsHz9Y1x5FTISgKFUqzFszL5U/FrIJNZwqDqI0OU34BhPd8O5+iTHI24RY
 36GKGvii
 g6r9iOEh4LvM8yC92SFhitDB/Pcn6+8JyHw7IJRtcWSs3SnW236+rNHo4m+VyUErOlPWwjHu+Udx09/x8R9DRkxuSa7upx8VgXlm6K+79LW1ZEOOWNc/H6v65nQ3ZwDQuIo3C3TDOV8XfXkjoyEV+dd0kcy9fPY9lpDaX1NDgEoZlFZIFXeSLuEFjeUCJc7uC76bzdPp2uOPLS8YbXAMyM/feofyIms9wT+jGcmdLRoq89fuj8lrK4a7ksLN4H5Nu6E9TAZx5a18PJINFCFqP3/cleBDwgWJy8p4fdUumlGNWAt/V6XcnSqpYbmpY+vJd1hZGOP225GJ2c6/IA4/25L/i5whtjR5rUxab1A3whzsb7gfBJs/0WvuWnlzvs6mEkwti7BvIkTSP9H4Pdo0NBzNVE05ul9XWJTHv0wn5sputmdX8Fxuievby4m4r22DVVxTzK3W0wqd0QxVLPuP4IS4HyVN81A4pQKR4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.09.25 17:32, Eugen Hristev wrote:
> 
> 
> On 9/17/25 18:18, David Hildenbrand wrote:
>> On 17.09.25 17:02, Eugen Hristev wrote:
>>>
>>>
>>> On 9/17/25 17:46, David Hildenbrand wrote:
>>>> On 17.09.25 16:10, Thomas Gleixner wrote:
>>>>> On Wed, Sep 17 2025 at 09:16, David Hildenbrand wrote:
>>>>>> On 17.09.25 07:43, Eugen Hristev wrote:
>>>>>>> On 9/17/25 00:16, Thomas Gleixner wrote:
>>>>>>>> I pointed you to a solution for that and just because David does not
>>>>>>>> like it means that it's acceptable to fiddle in subsystems and expose
>>>>>>>> their carefully localized variables.
>>>>>>
>>>>>> It would have been great if we could have had that discussion in the
>>>>>> previous thread.
>>>>>
>>>>> Sorry. I was busy with other stuff and did not pay attention to that
>>>>> discussion.
>>>>
>>>> I understand, I'm busy with too much stuff such that sometimes it might
>>>> be good to interrupt me earlier: "David, nooo, you're all wrong"
>>>>
>>>>>
>>>>>> Some other subsystem wants to have access to this information. I agree
>>>>>> that exposing these variables as r/w globally is not ideal.
>>>>>
>>>>> It's a nono in this case. We had bugs (long ago) where people fiddled
>>>>> with this stuff (I assume accidentally for my mental sanity sake) and
>>>>> caused really nasty to debug issues. C is a horrible language to
>>>>> encapsulate stuff properly as we all know.
>>>>
>>>> Yeah, there is this ACCESS_PRIVATE stuff but it only works with structs
>>>> and relies on sparse IIRC.
>>>>
>>>>>
>>>>>> I raised the alternative of exposing areas or other information through
>>>>>> simple helper functions that kmemdump can just use to compose whatever
>>>>>> it needs to compose.
>>>>>>
>>>>>> Do we really need that .section thingy?
>>>>>
>>>>> The section thing is simple and straight forward as it just puts the
>>>>> annotated stuff into the section along with size and id and I definitely
>>>>> find that more palatable, than sprinkling random functions all over the
>>>>> place to register stuff.
>>>>>
>>>>> Sure, you can achieve the same thing with an accessor function. In case
>>>>> of nr_irqs there is already one: irq_get_nr_irqs(), but for places which
>>>>
>>>> Right, the challenge really is that we want the memory range covered by
>>>> that address, otherwise it would be easy.
>>>>
>>>>> do not expose the information already for real functional reasons adding
>>>>> such helpers just for this coredump muck is really worse than having a
>>>>> clearly descriptive and obvious annotation which results in the section
>>>>> build.
>>>>
>>>> Yeah, I'm mostly unhappy about the "#include <linux/kmemdump.h>" stuff.
>>>>
>>>> Guess it would all feel less "kmemdump" specific if we would just have a
>>>> generic way to tag/describe certain physical memory areas and kmemdump
>>>> would simply make use of that.
>>>
>>> The idea was to make "kmemdump" exactly this generic way to tag/describe
>>> the memory.
>>
>> That's probably where I got lost, after reading the cover letter
>> assuming that this is primarily to program kmemdump backends, which I
>> understood to just special hw/firmware areas, whereby kinfo acts as a
>> filter.
> 
> If there is a mechanism to tag all this memory, or regions, into a
> specific section, what we would do with it next ?
> It would have a purpose to be parsed and reused by different drivers,
> that would be able to actually use it.
> So there has a to be some kind of middleman, that holds onto this list
> of regions, manages it (unique id, add/remove), and allows certain
> drivers to use it.

Right, just someone that maintains the list and possibly allows 
traversing the list and possibly getting notifications on add/remove.

> Now it would be interesting to have different kind of drivers connect to
> it (or backends how I called them).
> One of these programs an internal table for the firmware to use.
> Another , writes information into a dedicated reserved-memory for the
> bootloader to use on the next soft reboot (memory preserved).
> I called this middleman kmemdump. But it can be named differently, and
> it can reside in different places in the kernel.
> But what I would like to avoid is to just tag all this memory and have
> any kind of driver connect to the table. That works, but it's quite
> loose on having control over the table. E.g. no kmemdump, tag all the
> memory to sections, and have specific drivers (that would reside where?)
> walk it.

Yeah, you want just some simple "registry" with traversal+notification.

> 
>>
>>> If we would call it differently , simply dump , would it be better ?
>>> e.g. include linux/dump.h
>>> and then DUMP(var, size) ?
>>>
>>> could we call it maybe MARK ? or TAG ?
>>> TAG_MEM(area, size)

Just because I thought about it again, "named memory" could be an 
alternative to "tagged memory".

-- 
Cheers

David / dhildenb


