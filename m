Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC999CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 12:33:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E65A08E0024; Mon, 13 Oct 2025 08:33:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3D968E000F; Mon, 13 Oct 2025 08:33:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2BF88E0024; Mon, 13 Oct 2025 08:33:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BBF7D8E000F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:33:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 53DEF58C3B
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:33:34 +0000 (UTC)
X-FDA: 83993031948.06.1AAB9A7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id BFDB718000C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:33:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="GjuyoV/r";
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760358812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fApsPT1dPlpmvqc8msb+pA7TEomWXHbI3o8FT9ZOyio=;
	b=RDMueD6I4xH1nrC2LQw0OzfdJ9zr79/M77Oi/LZyH1OIlNVjtXvLnzAvLf/8hTCWsMxCh1
	/ZZhw7QHO/AqU3M+HyJuwcVnJ5BfyiJRQv77WHqZqvNWO9wSjIr2n3bY80KwRDgYFlpQ13
	aDDpXU1ccU4tKejvDZAjv54ITuuMO6w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="GjuyoV/r";
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760358812; a=rsa-sha256;
	cv=none;
	b=cK0Wn73SpkFM4ztctoyczp9/Y7sMlDXtDDoi7O42otOsyo05MdgOo40/cQckGZq4ZVoOpf
	zNJxjxAhMUy3U0qU6hkAwcqrJY8bmh/EZXUBi1xDKdTL8D6765GypgkhCp/xU1LM/7D6UC
	4/GAxIp5fQhFMBUVBogQyUC+Rl7m7Ko=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760358811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fApsPT1dPlpmvqc8msb+pA7TEomWXHbI3o8FT9ZOyio=;
	b=GjuyoV/rS1ztXHG8riq0yMx45bhLEgpSizZiccSLaoUeW2OP5UXzTSIlmynpGONhhGW2wJ
	ufb2JjJxNy1+iuCoA7+USJYks6pBn9gGyYtYa64wDxJybsGPOUCTC+qeQWELgp61hWmcpj
	Cl7/okj236P3UXVXDlaPn+7P5AWYNm4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-455-kwE3mAEpNDGgiXzHLVEOMw-1; Mon, 13 Oct 2025 08:33:30 -0400
X-MC-Unique: kwE3mAEpNDGgiXzHLVEOMw-1
X-Mimecast-MFC-AGG-ID: kwE3mAEpNDGgiXzHLVEOMw_1760358809
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3efe4fcc9ccso3743476f8f.3
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 05:33:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760358809; x=1760963609;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fApsPT1dPlpmvqc8msb+pA7TEomWXHbI3o8FT9ZOyio=;
        b=KyXAmCPM421tk0QARRsbkHArp0CprylDZEFMQfN9RFom7jBTL9QRKleVBbA1vqn7ts
         MWIwOK3fkHn8d/wGeduVe0QHjTd3hP9YnYQACTT+3bOlJba/qqPowlfcbgh/DMUzTW9x
         fkxfyFCHOtfQ77u9NVO1vm6ST7iEHCkIhsYr2ubeHLToPCxGPbPtOBzIniy7byZLo8Wv
         deEJmjWXh6dfQ+Zr68EZIQYMZKY8GADNmyLme58sHUGc0MYoVBaBwUFD+iXBYS6E2z3Q
         MGUnlaXbQSn5tnETyoEJq+rcr2cTfccjP+JMipY5gjpqZeOMJpSRJ3LKyquze0wNKzOq
         4euA==
X-Forwarded-Encrypted: i=1; AJvYcCWZZbqNEmzykem6ReH4D3UY3Bbu5sGVygqN09g4zV3sqmC6mSwDhiQjCmTN44poZCpr7wUZkeDu6g==@kvack.org
X-Gm-Message-State: AOJu0YzJm0a5YOJ/CldO18GTvz/7cuEJ3ErZq0tVe5HrQDQnFJnNJngb
	JoSJGUmxFJbMOhfDRdwKeWnVjpIYEeJf1Y//72ErFPHdR8+IOyq7W/8sKYO83CQYa+8xMkSzLJh
	PQvy925yNx+bJwrGyMPfnhOfxYovWVdq+w+NrAcn+5yAB7lDFS1Bf
X-Gm-Gg: ASbGncv5rJn10iP1fwCZ9Qj3KkMA2/EZEuWihEIAvIUc+suEJwspxOXiVzcRLy2xvVT
	66v25DHUUBeDyvAsBLA2RCDqWkNjA1CVjnLouk0zWOxsp7TZC3J0u9dFT/sSNEnechWmfhNHuAL
	A+Ert6cCfaHG73nesPI4Awvwv+xsv5Pa7DLIJ5sXt9m2APDqypKd5EvxP53Lx5ACdCPsoQ8KQbL
	CTp7zCE928pJmfXvoh/Wz/is33aZwN3aybW8NZOCyaIYbVq/n+slQmb9y+7CviBzw32DTG2ZsW4
	0f6eRIjjafCNHj+IgeHdI0tokWdCUDpaTVtcVjRYA7mMjiSGLsxftvQjjJQbx+++MU2MQzyvFOk
	6gQc=
X-Received: by 2002:a05:600c:4fc9:b0:46c:7097:6363 with SMTP id 5b1f17b1804b1-46fa9aa4620mr127201425e9.13.1760358808749;
        Mon, 13 Oct 2025 05:33:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH0Cy6D/fWcdLGA3C5eSuXIxdOew7wbjd/FaVN1XfyGX/j8J8IUQpx5X5iCUYz9ws1sa5Xdig==
X-Received: by 2002:a05:600c:4fc9:b0:46c:7097:6363 with SMTP id 5b1f17b1804b1-46fa9aa4620mr127201155e9.13.1760358808341;
        Mon, 13 Oct 2025 05:33:28 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb492e6ddsm204393555e9.0.2025.10.13.05.33.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 05:33:27 -0700 (PDT)
Message-ID: <de914c89-921e-4e75-abb9-315d3def1cff@redhat.com>
Date: Mon, 13 Oct 2025 14:33:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC RFC PATCH] mm: convert VM flags from macros to enum
From: David Hildenbrand <david@redhat.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Ye Liu <liuye@kylinos.cn>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251011093054.886460-1-ye.liu@linux.dev>
 <809f552d-3282-4746-ba49-066d2bd8d44f@lucifer.local>
 <7ca0960f-9d1a-4ba4-b074-a6502578b82e@redhat.com>
 <d619784b-b967-4795-aad9-6e79d4191b83@lucifer.local>
 <dfc18351-bb77-4099-bcdd-eb2bd4f1bea5@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <dfc18351-bb77-4099-bcdd-eb2bd4f1bea5@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: AGfkxQLGpeFDnZnEEaNhUd_4jBlDSTEkkJaxlxMzWpM_1760358809
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BFDB718000C
X-Stat-Signature: gzxpw89or3pyg93hsejeqm7nzcjqib7x
X-Rspam-User: 
X-HE-Tag: 1760358811-508707
X-HE-Meta: U2FsdGVkX19u835bFgKIHotZ70eepVZKE0GLfDjBZyFKWGmy2pnNtv8x6uJwz9Tz7Qg1TgVd2YIdklllhejwUw5SqY4c7aHrEvkwWfCG/gUPisTnrsxV8ijKumW4JxYqoU7frSmyhqps33bGUZu4Va6jv3lr5sqsRNIxPJj75S11U3AcvejekabkTBusoMdOnSoAhVuu4LzXhT8ivwXPBhCFfVmTjUWqPH7MgOEmTU3zzlN9yZk4xM0ANvtdm3ulybFLo3IbwsJPyseLUG1nMciH9s6xJ7kUJCGCZ1WPLcCo+up0/1De3d7wN4yEde1YyOsCIHT5zpXHkopOWQbNHtq8EVeIwb0T0GLPbrxK2bqez/ehxF708K4RmH0HR3LOom9FO/UP4HKtgvN2DzKPpHxzcrVyume5K5+tNYHA2mY/DgnqqYpcWqK17hpeSQFm+FnTXWa7ULV3/REozWw1DllSIa6aHfBbHNoGB68rG/xQCtmkNEN3hocFRTLIvh05HqcFrEuGgbixAMx7KkhcdGDvyg7DDB0PY5KD3UZjZXJ4iMcT4HfcmPzyuYOWg0wo+pPLNLtSKbUW/wHUy+4uDAfw0+yp02A/V2J0CFWBjmWoryarETKVprdgii4VCwke05gmjOAKxclv39tIwiSe7z1zTZxfehB1QPOGZbkwoDbZ6+bD0mAJnyvqlXQh11ANaNZMxh0fYKcpodHWimvG3CzEIvL81lUQS7zJdCWkQauCV+bxxJNL2spUa2bAD54vN7I7lkybiBCBdEvEw7HtPz/YoY7mnhBQmatwIKz/HtMxqOpvCbW8ffMsAOYkN6r4/Z7JvNJh+JBsFJizomOX8YTfLS1UjHEg7FQpaZzj91S7dgYblCf/iEkM4l9hdLBxuCHm914PHuoRjR2WR2f9Lfmu1tWJnlohCWRu0rrSYMyDxO2Cm7fm24e4q0FTr0KPdFUhNg71w85Lejlbt2k
 EKcFXpFq
 UgPFzmNr0Fmbbped0P8h6XLbKkmDDVQR3Ue73Ufaa27YCN597/mnEiMWySyElqdnpkppLsbaumP8PvI1zDEvoix6WYyLCDd5XWGbClV1s9eXpOEYxqatgqXIo6D6c64f0ZvpFSz6W1dpXtvZg+AXANd+HM5FM3swv2grbNHkhbYF6r7Ec+FKYndSk0nBT0iOhAYT02XNGADL6Knc8HGYxvtfPRixV8rWLAw0xkdCmFBzAAB2Xx0ilsYP8fZr5orSX3RsInu4v7x2cFr67tPDIEwaqGl0rz+gkPT77SlEkoOXWj6bYcuednjQ25LSop4XOhMuH6uZ+UeMIVb9VEcnyew7Fj/Ky5iHaj9fUaaPZIvFmTje2M890f9Sxkl51cVOG27rIWWqyC/GmhzqsU5PtHY5cAljWzrm7vJ413ndJlQiwFyuLobz3e3PRVY06gGeM3Ven3ocSNjn3Ij0D2wMlk6K+63XzQPzEnANN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.10.25 14:31, David Hildenbrand wrote:
> On 13.10.25 13:33, Lorenzo Stoakes wrote:
>> On Mon, Oct 13, 2025 at 01:12:20PM +0200, David Hildenbrand wrote:
>>> On 13.10.25 13:04, Lorenzo Stoakes wrote:
>>>> On Sat, Oct 11, 2025 at 05:30:52PM +0800, Ye Liu wrote:
>>>>> From: Ye Liu <liuye@kylinos.cn>
>>>>>
>>>>> Hello MM maintainers and drgn community,
>>>>>
>>>>> This RFC proposes to convert VM_* flags from #define macros to enum
>>>>> vm_flags. The motivation comes from recent drgn development where we
>>>>> encountered difficulties in implementing VM flag parsing due to the
>>>>> current macro-based approach.
>>>>
>>>> This isn't going to work sorry, it's not valid to have flag values as an enum
>>>
>>> I don't follow, can you elaborate? IIRC, the compiler will use an integer
>>> type to back the enum that will fit all values.
>>
>> switch (flags) {
>> 	case VAL1:
>> 	case VAL2:
>> 	etc.
>> }
>>
>> Is broken (compiler will say you cover all cases when you don't...)
> 
> I assume you mean theoretically, because there is no such code, right?
> 
>>
>> An enum implies independent values that exhaustively describe all state, however
>> these flag values are not that - they're intended to be bit fields.
>>
> 
> Observe how we use an enum for FOLL_* flags, vm_fault_reason, fault_flag
> and probably other things.
> 
> But more importantly,
> 
> enum pageflags { ... :)

Okay, that one is different, because it's the actual bit numbers today.

-- 
Cheers

David / dhildenb


