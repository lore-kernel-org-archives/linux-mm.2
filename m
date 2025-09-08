Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38A0CCAC586
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 12:04:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 763F18E0009; Mon,  8 Sep 2025 08:04:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ED5C8E0005; Mon,  8 Sep 2025 08:04:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B47D8E0009; Mon,  8 Sep 2025 08:04:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 410BF8E0005
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:04:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EFDA016013F
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:04:14 +0000 (UTC)
X-FDA: 83865950028.01.D4FD1E3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7908E1C0004
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:04:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fzUphNzE;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757333052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZQY5mtCsJ6G72X3ReunddNY+XFovjNM7Q+qStzUuS7A=;
	b=0fJ1LEkSKXIaV9T7YaMDXSx5JaClpCfmroZuXSj88RZBzXtATDqYrrgP6qtjCYwrorhGSg
	pXI1e2CH+4R74X52bJKG+hhv+uYqOvU2Je/BZilVjgDBSltjd08apkCelx6Io2V+AF+VVx
	HnUCSa8vPxaLESgtNsH4YCDlFrrUbe4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fzUphNzE;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757333052; a=rsa-sha256;
	cv=none;
	b=ods1pdCGH2S0OZBawSn2JKdsStXt/TfjM2hoRKYIoZAlt9sWRnaZyLPlKb0GRbBcZc7wo+
	ZUTRl/+gOy0TbCuDzQFpGj/q7eYIxLso8FOjajAcJueQ7OrqFE5KY3XkO/tkDfG7vmTrCA
	s8Wzf8hOZQyWP25by/GV/0UebUsZW7A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757333051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZQY5mtCsJ6G72X3ReunddNY+XFovjNM7Q+qStzUuS7A=;
	b=fzUphNzE1GyyIzfRW9GcgJ2azNCcdZUDSF9CKp/9j7OiYPoNwqItU8kOu8/nrunIWJ/STW
	5UsfjHE3IsL5mP+zdBq4wtLK1P3BINdabwLFARSTQr69dJJKik2pyND89w94UhV0X3/dUw
	7pHoTs9P+YLlUt06SHn3iytnzeP5fb8=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-385-rYYFvzGoO0eKUyCplzx0DQ-1; Mon, 08 Sep 2025 08:04:10 -0400
X-MC-Unique: rYYFvzGoO0eKUyCplzx0DQ-1
X-Mimecast-MFC-AGG-ID: rYYFvzGoO0eKUyCplzx0DQ_1757333050
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4b5f4e4fe41so110305251cf.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 05:04:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757333050; x=1757937850;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZQY5mtCsJ6G72X3ReunddNY+XFovjNM7Q+qStzUuS7A=;
        b=mTd2HttOCw/IuXeD547I+1EPM12niQYoiHpvHP67cEQsqKMMifao3j99CePNmN7r8/
         btk00KwkRH40B//uOn45+EE0op/sDPkHVXv+46uHGJLIrThgfcmuIc6MU7GfiuKzlRpi
         AY06Z6iTXTEO8P6Y8lYidj3zrLhkXKpYTfrJd+iYTH/nJwdq4lGpcYS+MIGRyA3UskUa
         fh9VExoPrnaAXaun6olnFhTaTxUt9u62mdrp4SfwF2hArut7B6K6Mn4FKjEJ3kEedwVW
         MokiNNJP8MVK8PhHXwCGIMZehhomNcdAibqTdwPqmdaDQunq++sveVhShAxYT6vUpytD
         f7EQ==
X-Forwarded-Encrypted: i=1; AJvYcCW6mgPUl2RyGENA78IvfzgHZgZABv+79CGbQmYrfUlxAPPyPzJ9vWwSbQ9ClXqFw1fFF4ve4twgkQ==@kvack.org
X-Gm-Message-State: AOJu0YzZnipihpZry1cJczqtFE/N7ZyWDNHpTZm99Fbpd69VbZU4UJoP
	PvfBUdYxlClvLZog8zffu51YU6LUrNF1wpoo48EvYNcjXt4zul0mbNY/xLQQSWoajc4KxgJ+93c
	A/RrO0ZyyQkl3U/VTleaHRQ9cYvb30lRFeAgvF492hvh2CNG54HnH
X-Gm-Gg: ASbGnctUYSxb0TF2DUFuUc7oc2EAB4cJIrQUkLj69eYGI5R0QZVkzD6LBK3YKqLPgPA
	aH5Znjijqpngq4CytV+K6M7yEbQ+YiccNcjl5mnWWW+jYG6OdPSPFN5yYKNecsrdk55VPeQi8Cb
	1mN7AnLEZENslX5VBAHF1dO73/Flmgl0ws9LRQ5oTkktmGzWX37yCntTKenB48HwLyUm0nQ1RaL
	BSgENgC4H45vOe1r9BbVBcUVisN2G6yue3aqkrh28kNEwcybRuVHdZ6vNqCh9nYTIbwlVcDf23T
	bkNjtPcg1+F7x7fpYR2r06k6dJl4E/YwRvSsp7idX9GiswnEPgbQaFo7T/YRuNh5xT57hSektbL
	vktOezDXUElgWVnKwRrc13SdpfSW0c18c3qUSTchmmUtJCZygvEiQfZDzios1yjpN
X-Received: by 2002:a05:622a:256:b0:4b0:907c:918a with SMTP id d75a77b69052e-4b5f83860edmr90178071cf.16.1757333049935;
        Mon, 08 Sep 2025 05:04:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJ0m+xqdk6+V/miczYIvEh+2/fCRGk0GUT37l9KKiOekcHaZPTLhCb/GFJBksR4DqtSb8WDg==
X-Received: by 2002:a05:622a:256:b0:4b0:907c:918a with SMTP id d75a77b69052e-4b5f83860edmr90177261cf.16.1757333049154;
        Mon, 08 Sep 2025 05:04:09 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b48f7a531asm102949671cf.49.2025.09.08.05.04.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 05:04:08 -0700 (PDT)
Message-ID: <f58a472f-4a36-40e7-94d2-229125ae7373@redhat.com>
Date: Mon, 8 Sep 2025 14:04:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm: skip mlocked THPs that are underused early in
 deferred_split_scan()
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 Liam.Howlett@oracle.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 dev.jain@arm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 usamaarif642@gmail.com, ziy@nvidia.com
References: <20250908090741.61519-1-lance.yang@linux.dev>
 <niywtremc5kfhs3lenmfxvbiiizyexnaw3m25twedmzovfoeno@lk2o46tfdklk>
 <9a0c07b9-5bf0-4251-8609-fbaf0ca75bf9@redhat.com>
 <5j6i2o6umqwxabdfncbrdytmvdma4yrraxe6hu4csckcniduya@sm3mlablwbad>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <5j6i2o6umqwxabdfncbrdytmvdma4yrraxe6hu4csckcniduya@sm3mlablwbad>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CRGvUpNhKtm5jdmi_60MANKc0Bj-ifWIk5n2Nc6Xj2k_1757333050
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ggg35in8hh7ue9bi11x5e9f4e8zj691a
X-Rspam-User: 
X-Rspamd-Queue-Id: 7908E1C0004
X-Rspamd-Server: rspam01
X-HE-Tag: 1757333052-709677
X-HE-Meta: U2FsdGVkX19dq92DIGDljQP00yXRq9rrxJRZql3GACbKLtT3pgEXtpivfRhfbW4oz26T+r0aVZNFpWHYcGBxSnSGP829ScDTXI1p4mq/2Bu6Wum/ON0NWosKaTQfrbij8eyc8AOPZoCEYsrlD5Pd/2IBFiuErvJiq847FwLCAOe86NHFqkPIhOdieRPIvxqST7b6Vu964Ax+sl3BdvMVVKtsWhrkhEK7Vtn44FrF3zeMLLpBUmja2w/wCrTW+gHLYe+9o5WFsG/XE862RpfiypbnZR1MX2cJcl77nqyv8LDFtdz17pAw3+LxbZ8Dm+f1z6oVFQmybphCVPwOZxtlYvXaDcP8vyomir+SrDDmmoWGkD6gdV94/FP/HcyyesO8TYWY7CyGZ5vjuK3Aayqt5LiFdmV5sSQiaZbvA2/DDhOQk7+RoKImh01VeKwjoMUQK0jm45vGOG3tjALgmBLvcm9NYFx/EPsBKbzIMJGDvwNLkGlRmenCsl+NeVGuEwyTFbXNdRXCWNv/9zCvsW358afPJ482LeR8V3bthSKOCIV1Q2wPX/mbLpuVBu+sUOJHhPlNR6vWHVKEuKjSf3YD/2EUsC7/V5QhvNcqoUaSEiI+CBAD/uqR9DOoUq8q2wkTNw+ddSv/y1UBd1sTsAzKFWXO8r5cRkwMnRCajTsuxQ8S9BaK5tSJv4X/V1TxHoyz0ZIB+6+v7AdQrFCmO/hgW8H4x3jL9mMAAQLU8kOwAdBacD0QI0p+2MTJWomoXN+lB81AVS+3manncb/Qsf6Bm6osUV8BqKM3gApl3weM4uk05Ql0TPc8Qr4E302gTaal/h/qjKJ6QBJMppr4j0/B5K7HEFhDF1ALmUMouBRcRYebTLe6GeE6aupNP5d2slZVtGF+zx9WHk5E7rrROj/T+rHfT5kaglNxR/C1ReAeaCApmLtxMobwh2XmpRkRlGVJ2hmH6VppDh9AZlwwvze
 ioizRbyD
 pxYFMTN4MSK8n8azqoDKJ5AeArKueypeESIMZqvR3JRlHo9UAm9FrpLdCVoNEhjLnrZ8PjZK7nPRL75yDfMdoSXLzg1SIWjEPc8/HysdpGch6BFeH2XPuXa7vVX9/rWBIj/OIu/54Xs0jCjrpK8caEfUzcCkfA4wZu6N7idiOYKXpCDO9148MNebfiSrpLwfhzT9BwLIGDMwwy6ahWQ6D1nuYJWPyQoaYqfCbwdqk06FeifUGsUxmZ4b2RAWbv1UEziAfwVJBkvIhvYx7dj+xV6uYpLLE/nNDRJxNHcq0HPuRk8JsHtBRn8OxQqsa4JLXp0So5NLp1GdPsuqwk+nMSI6DfXqxkK4AAqkHk7FI4Keh8ierY+mkNmDd4fZUwh1jFBx1FnUjXDtFszZ9ozKYNVAA51hexzL6pBJVrdwatY4/iCUVCFfxycKy6NlDa7Y3JDTSB1u58i4jAkivngy/KZCMIytQ3RFqEyZqTAPy5TBgqWOkOKhOEKdkXBxJEPLlRr3BsLWpVSDKCuf/MovkEDoNFx+cIE4Ld35QCy9Cjb6WlXY9l4dZXZOgmAMs+Gjn2OUR37YX1nA1KlpdJSj/qfVdL7quX0kiw4yN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 13:44, Kiryl Shutsemau wrote:
> On Mon, Sep 08, 2025 at 01:32:05PM +0200, David Hildenbrand wrote:
>> On 08.09.25 12:38, Kiryl Shutsemau wrote:
>>> On Mon, Sep 08, 2025 at 05:07:41PM +0800, Lance Yang wrote:
>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>
>>>> When we stumble over a fully-mapped mlocked THP in the deferred shrinker,
>>>> it does not make sense to try to detect whether it is underused, because
>>>> try_to_map_unused_to_zeropage(), called while splitting the folio, will not
>>>> actually replace any zeroed pages by the shared zeropage.
>>>
>>> It makes me think, does KSM follows the same logic as
>>> try_to_map_unused_to_zeropage()?
>>>
>>> I cannot immediately find what prevents KSM from replacing zeroed mlocked
>>> folio with ZERO_PAGE().
>>>
>>> Hm?
>>
>> I assume if you're using mlock and at the same time enable KSM for a
>> process/VMA, you're doing something wrong.
>>
>> In contrast, THP is supposed to be transparent (yeah, I know ...).
> 
> Yeah, I guess it is user error.
> 
> Maybe we should make ksm_compatible() return false for VM_LOCKED?
> KSM breaks mlock() contract.

I was thinking the same and falsely remembered that we would already be 
checking for that.

> 
> But it can be risky if someone already relies on this broken behaviour.

Could be.

Staring at QEMU, we have the following parameters:

	mem-merge=on|off

     	Enables or disables memory merge support. This feature, when 	
         supported by the host, de-duplicates identical memory pages
         among VMs instances (enabled by default).

And

	-overcommit mem-lock=on|off|on-fault

	"Run qemu with hints about host resource overcommit. The default
	 is to assume that host overcommits all resources."


Now, I would assume that anybody who sets "-overcommit mem-lock=on" either

(a) Has KSM disabled on that machine.

(b) Sets mem-merge=off

as well. But QEMU would allow for configuring it.


Interestingly, mm_populate()->populate_vma_page_range() wants to break 
COW. [*]

But if the app later calls fork(), we still allow for cow-sharing pages 
with the child. (another case of "don't do it", like KSM I guess)


[*] it doesn't do it for mappings that start out R/O. I think we might 
end up with sharedzero pages in that case, but not sure if worth fixing.

-- 
Cheers

David / dhildenb


