Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D606CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 11:17:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FBE98E0002; Thu,  4 Sep 2025 07:17:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D3E58E0001; Thu,  4 Sep 2025 07:17:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C2B98E0002; Thu,  4 Sep 2025 07:17:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 67A9D8E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 07:17:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 137331D8E25
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:17:05 +0000 (UTC)
X-FDA: 83851316010.05.C25B29D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9738540014
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:17:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=deQJKgST;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756984622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s7d3QrGdbJp+/2V2GPguzX/iKX654TAzNMpDtBKIxPw=;
	b=3SiEcJ594H7scPCsfuUFlnpJwL0TTjoDJwZhJyE2+XQrrTUhfJulb+QHAdBvmOKfUt5LZo
	FkeQs2yIz5f2CYGOKh34XtaTWbmRRZ5jZ+N/MPvCFpEumkpvhO++Vz/4uwmQ+mMm6zB75k
	iwNmkKE1uY7mnunv1emffRajVOrLtTk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=deQJKgST;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756984622; a=rsa-sha256;
	cv=none;
	b=YyNph/OQsV5TXSJPS297MMzepx6L+waCVr/Xw0fLKSaDKrEMuVegdceZlsXFZzh5E/j41I
	m95VMINFAwKh6bfXJfuHQOs0P1Ra8RYIHaDg6HX7qvsUpmcPyQJbDw0Lo+F79gXTBLh5WL
	3OjgojdOtdUUNK4byhLJ4YVlcXiBcn8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756984621;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=s7d3QrGdbJp+/2V2GPguzX/iKX654TAzNMpDtBKIxPw=;
	b=deQJKgSTEE4USQdNiNYTN3dqTw9Bm5Pp83uTYsjQJu7cSwC0oawNwFd6vNwJh3ItjoyToi
	L9NYFIh4Egaz6fvD5PQO0GOFU33jvpNaKOSqDJtE8Ncj4eXnFbXzc1oKfNG4T1avL1tnaw
	20GM2NBMxdMNLw8VKog32GLHAWIkt48=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-JdKi5YarPsiTnPOpjGTqeg-1; Thu, 04 Sep 2025 07:17:00 -0400
X-MC-Unique: JdKi5YarPsiTnPOpjGTqeg-1
X-Mimecast-MFC-AGG-ID: JdKi5YarPsiTnPOpjGTqeg_1756984619
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45ceeae0513so4923385e9.0
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 04:17:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756984619; x=1757589419;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s7d3QrGdbJp+/2V2GPguzX/iKX654TAzNMpDtBKIxPw=;
        b=XexRrXq9H57xSmOiydAN/4sWev/tptsytGCOkzpsN1KfqeZSMv/L4+//lbycn2b7A5
         zYBLhJ5CNk7jk0T+KrUnhi02uqvPmqlLjgXMoCLjKG2yeUdkUPKuOx4lOzDeNNmDjXws
         6FwyjMjotY9qpZyo+BrXoLVv7d0ocNa3IanlasoXTEXyOXqiHt3ebQsrlgZ4+L7UL3Ip
         Oy9TcEfgEVpuReX9PheXKuZE0+otF4qjhKxo3LwRgEzM8YU0e83XlJu2xBAJzybeMItj
         3nW/EeyR47hlPGEYqklxDrykLQpPYCasJENfBCnMVoEv6HKs+A75vLm9Bko5iHBQswAV
         mYlw==
X-Forwarded-Encrypted: i=1; AJvYcCUxVU70ELuWLba2u6Y2l5QBza4f261Dsuia0LMXAm0SXI1n01HBydAiV/hQPR7fc9ImchCOSaM4lA==@kvack.org
X-Gm-Message-State: AOJu0YykLg2/iiZOiBIJQu7qDpNH8EpBUUqrqQKv1UQbJ1SYeuzeqTtq
	CvASMNVKnIG1+lnfpN+90d39vvmYgjbtKsbjntnXcP6QMHVHqAsJpMEpyYyJJA6njPrJtq614xl
	VQi9L5BekNIR/WOsKmCwdXyXVawffTfjh8e8AWfHvPoPGQuMFlFNZ
X-Gm-Gg: ASbGncsQCZaD2hnBfcs+XFBQHR8zHK6110mLG0Q7/20DRHkTgi/sqdJtREvQS1xIM+p
	K2FtBpezd1JNJbCTMD5n30fEM1OvvmoG4aLCcp8V7QSTp/68HxSAt6dH1+3I7w3Np0A4RCaHdzT
	eUvlHzraLUF3MFSPxCK0DuW9MFvh1TiHtnPEc0DVipfFZ9JvScE74QskovOunizKwdw/LD2rFXp
	JH3nzljY2Dhf+Mo8YIab7DcHxGDRxLajminerbBxX9IGTbzQyUoLJrTRD9MVv+QKjuFX+vlelEO
	zXWpRyeQ+KpXppDc1wfR6JKGApk4yyecf2WRRd2Dh1Aa5AdSg1RH1XdgXuUADvHgAzLQC2rioav
	H43ikioUF1yjaWiz84uSsP6L03cwXw+pXIC2sZ3aEag/G67hUf0L9y1WJImKTsNz/
X-Received: by 2002:a05:600c:46c8:b0:45b:7e6b:c235 with SMTP id 5b1f17b1804b1-45b85533095mr162326255e9.9.1756984619196;
        Thu, 04 Sep 2025 04:16:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFx751BiMLQs/FNMfN6KJoTuC8FPL2UJjSm5CNJuLuA/Pa37blHAWbSxjxwgfN/PV3xa30Lsg==
X-Received: by 2002:a05:600c:46c8:b0:45b:7e6b:c235 with SMTP id 5b1f17b1804b1-45b85533095mr162325995e9.9.1756984618777;
        Thu, 04 Sep 2025 04:16:58 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:1e00:ce4c:be3:97b3:6587? (p200300d82f251e00ce4c0be397b36587.dip0.t-ipconnect.de. [2003:d8:2f25:1e00:ce4c:be3:97b3:6587])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d21a32dbc5sm24550519f8f.11.2025.09.04.04.16.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Sep 2025 04:16:58 -0700 (PDT)
Message-ID: <c6780d87-1d0c-4075-b351-40f3c8f6e4b1@redhat.com>
Date: Thu, 4 Sep 2025 13:16:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fork: simplify overcomplicated if conditions
To: Joey Pabalinas <joeypabalinas@gmail.com>,
 Kiryl Shutsemau <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Kees Cook <kees@kernel.org>
References: <357638f71edc7f1d9814b1851a64e09a8895bffc.1756968204.git.joeypabalinas@gmail.com>
 <tzjq757k4tt7k2mkcapttjuax6zgzr3nl7ivusuvxfmok5kvb4@vub2gw7vp7vu>
 <ka3dhrfkc42ydbiiqa4ygr545ndydcpekjco36sdwf2nypuy33@vpsgevacmzjv>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <ka3dhrfkc42ydbiiqa4ygr545ndydcpekjco36sdwf2nypuy33@vpsgevacmzjv>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cetDT3GEnm6eZwVD2E6UBP9toQtqu3PY6fBcVr2KIOM_1756984619
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9738540014
X-Stat-Signature: 9m4u63kxx9umocbak1qmd7czpd4re6do
X-Rspam-User: 
X-HE-Tag: 1756984622-555172
X-HE-Meta: U2FsdGVkX1+0zEeapkDaa1t9ZfjFMcwU3y0TXn8D4Eg59Hur9yvlP9RE1Jl4Mbvm1VTaJrPBPU7VkfVYDn3LJqsHsYknv/hU0jLRGWbJBuGViJFgAkDZidlX+k3qLKIPYJRJ07rMZKvSXSOmGLKj/hY1Sc9cPOeJAMbaSpIvieihbeaSfofBJqbg6waNvMzL6W6gEa18C5B8HkQDGfK4Js5mM1QmoP2aqvMAqGGXhxWYVpNVG0QCph8OLgCLyr+N2NyJoCut5l6IxD2lsc5RAxHMIPQGOqAKU0DhVA0J8jryHWczEFUkYfBgr4ocDSSo4QirjLWepkMBVY3JzpqiVPfB2bbyl9CzsawVXaBJKZUeA3s9Fz/d7qdzbdoA7lp7a3W5N6Lp5SKRmfmIg2RR/lVSpvgwIqU1IyIW+FdiTxZwkVnnmvq+Ab1z8CJQudz/d+aETYU+cqiuX5vcmZvL5DQjakrNQSJ/A6YOtnKDqyWo65C+wE9BFlzxO1+FRzp3U+10al5eaE8QE1V7pYLCsENVsedfpR37kZaIKv2SLbKezpiPAPK1ZsPCraOGQ8bHIbh//VWbxiSFwbWL7ixZ7KBxTjkbXCYAUpYC8H1I+Q6oZRWfF3WvH3GHzliD7lZV516fXf8TZfVIkdw9FhTXXU0yO1xcH53BzffnO0buY73wazPmTCKHaxD0/Us/36XqAsXT+4nQn2JrwS60AopL1NPReQUULrq3uzf4ZNASlgDtGTXeqCG7N3Udrm4w/iRXejYaJn3lyknvTghdmvUqbbXUp0lGkWWI/z6GLIuX11heIeu1HAE252Nmu77ohGgjMOf5ieGsTd+dU0OggKhAxOpb03j8qqxvmSrAuSMqRwaXUHahCMhTwfG/tSeewGI1c8psLTr5915xt6VEiHdKW9dPowzUfEWDCZW+8RHtsZVEypyGUv60VQK5GWQ5Kih9u5Va8DSSxfH+MSYPMe9
 zK32GKSY
 jNz12TpOUWPHSBVv8kZcwYFrc0SEuOOrGhL8X4hLfGj6aWR3IGFVYVNJygcd1H3uph250IzVaob4GBdsvhHVtrxE3C4vtNx8amIGfGnwJuU9Gk6qxIp9DGjVfrbRdLh7aq7BVBmC6mahA/1fQM6JZFGdVP+Tzez+KrPhMzPcOHdsAF5V9VoJ+AFi+beiGJqS23x9f0Atxow19hOqtkc8djaP1SwOruMSWO5i1h+3dcMjPLTpTpL2KqK41zEjVwdX9xeW21veDAhD37Ta10jFOOy3gw1Pxz2gXs+VnQl5BGMR/l1RcSXoeM1IAMBQwkt//9ywPYiRqJ6+5UjcK4v0pioKqWZCNBFzeI9jGyNrBunzQAeBTmLVol3GfH1i1Es8TXevbltQKLW+gIm4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.09.25 12:04, Joey Pabalinas wrote:
> On Thu, Sep 04, 2025 at 10:56:44AM +0100, Kiryl Shutsemau wrote:
>> On Wed, Sep 03, 2025 at 08:46:29PM -1000, Joey Pabalinas wrote:
>>> Since `((a & (b|c)) == (b|c))` is the same thing as `(a & (b|c))`, use
>>> the second version which is simpler.
>>
>> Huh? No it is not the same thing.
>>
>> a = 1;
>> b = 1;
>> c = 2;
>>
>> (a & (b|c)) is 1 which is true.
>> ((a & (b|c)) == (b|c)) is false.
> 
> Ah, you are right. My mistake.

I suspect you didn't even test that patch?

Please do us all a favor and don't send any more such patches.

-- 
Cheers

David / dhildenb


