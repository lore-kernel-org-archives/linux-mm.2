Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F301CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 11:11:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 449218E000A; Thu, 23 Oct 2025 07:11:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D1328E0014; Thu, 23 Oct 2025 07:11:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2997E8E0012; Thu, 23 Oct 2025 07:11:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 04E488E0013
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:11:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ABB9E1A0AAA
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:11:01 +0000 (UTC)
X-FDA: 84029111922.22.E157535
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 18EACA0006
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:10:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A0jg3bgH;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761217859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l2IWmYgTn+axyHlrNGOBe1eg6QF+Mro5+LjrFCWT2pI=;
	b=YeWiHcumxIIYLIyQ1SPc9BZX6RMmFTFnl4nn1f6w8Yivb5UOPX51bYDPYnNCIRcN60AvaA
	NJfDd+j56Hni2A03x5ikOCPofzB4itbegroxuVT6FWlXVgLbNp+TdrAnYKQveCe0ZUvSs6
	NITZdr3GKc4Ff/8ceiam4nfLllkmnIY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A0jg3bgH;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761217859; a=rsa-sha256;
	cv=none;
	b=FG3K+Dd3ODrVzLKfyobQGi7FskzY7yv6+s4stt8PoMdf58tkz47Yf3c0ArDo+HUnW3wicb
	7/yJbgg+7T2kBDNp0i55mN4D7wpQr+CTx6DAEG9HfJgM2PJflx3euIyY0UxrRIItzIz6dJ
	jqAL7/Wji8u82K9M6iDZTrqogWJzlsI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761217858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=l2IWmYgTn+axyHlrNGOBe1eg6QF+Mro5+LjrFCWT2pI=;
	b=A0jg3bgHs7yAdsKJ8TDbhWrWMyiWm6kMao8xvtlKp2B+AWILkE4ud2Ky+Jhi2KBcy3LLbA
	4ued469gO2TNPvDoydG9UEKgCiY0g1G0P8hE8OMtyDnGI+8h8j2clGczy89JpQi5nJKWnf
	LcinJoiJxsbubnDUZlB0afKrzuprFIk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-OhPkeF79OS21pScPY-ipVA-1; Thu, 23 Oct 2025 07:10:56 -0400
X-MC-Unique: OhPkeF79OS21pScPY-ipVA-1
X-Mimecast-MFC-AGG-ID: OhPkeF79OS21pScPY-ipVA_1761217856
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47111dc7c35so5442715e9.2
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 04:10:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761217855; x=1761822655;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l2IWmYgTn+axyHlrNGOBe1eg6QF+Mro5+LjrFCWT2pI=;
        b=eID95XmihD8Yd1v1We582EOXvFShmyo/uj6U92Z50ob3+I7YXimSVz1odDU1N48ijN
         PwkYjdReZnbtyPR9JQoNdnTQ2zGnXnE9UErNk0jY1wSb3Z7T0kQpFC86PTIfy2QR3SRN
         i84BeIKk5aM+e+sylumkvCc8lmcL9ulKr2MLm6yjlm6OxqCNozcdfJhfnosYlmEd18tq
         o/L8CFtvbgLAW4P2q4xhvg6rfBbF+g/U0VtYof+MGTnL1JPxU7vH4ma0xzz90QMekUi0
         PD4f+fokcdkAi1yz9yVBigWNYj7D0qKL6A6arjR7utf1I3edwfZ60iyPG0Ze/QUJUQVx
         U3Zg==
X-Forwarded-Encrypted: i=1; AJvYcCWvcIYGNPuuiNe9YpN4z/xF80u2PMC85z2cHKuyUS7BONeZQFhFnQ2ubmMdi5yqNaUiKZ5u5fUJZw==@kvack.org
X-Gm-Message-State: AOJu0Yx2YGH34bZNEVZ7N+I6Kq5hiAKUsoigRBJJD5xMDYuIJ8B+3L6S
	g7YKye0szP72IHUxlw5TuQpti1eCnWeWjv9PN/aWIxGY37UcJV18fWqsUmsXKFgq4hc201MA3e6
	tblBjUZ1rDLL4lC6TZ8ZURf8JcpYF+dh7ITlC5HpyX3oAPXsOAkj2
X-Gm-Gg: ASbGncv7f4LO9ZG9yrqAV8/uDyVntFd+dPevDg3xQrPfo/fFLLSwDGmTCUeIqJYjaXt
	R1V50oLTbuf1wsSLY9sMkyw/J/rScsyk9ip2UrDtMwpq2EBeGcoSttNDzEY8cRZSV0eo8AD58Pg
	wnZDcvKD3Uy/w+mi26P9ja+IQY2AdtEnJ8kM1LA0XiRspcQH2jdrewI4YrWZFA4RYM6y3AHWbqv
	B2mEw/L2UJL7bIt7fPCLqLBpnJpGIb1WTrJMZUrw96/XQQ+noXX7QXzEfzFUApmD4YSOZxufnN9
	IyUSLLATQhZPp/cZqBzAn5Esy43OLoA2AlFRP8Z9+KSHcXnyu3nL28L7Hz1hImP+qXgOmbNjcz8
	idTp5K9fQgz+GAXh6GMJ6KqYcQvddGc06jWpkTdvEtSLALqC3/vDv2yCbAWMf6o4gSzvaeUyi8a
	qV4glTFjMqqwE0zl9Kd5vEXFW77uk=
X-Received: by 2002:a05:600c:3b8d:b0:46e:35a0:3587 with SMTP id 5b1f17b1804b1-471179174cfmr180135075e9.27.1761217855570;
        Thu, 23 Oct 2025 04:10:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEV7ydI7xyOszLDErCC9LpAr/vyTCsbXL1MuG3tRXSBfXfhqfoS0SRo1a/LWhqon2FVwTNCGA==
X-Received: by 2002:a05:600c:3b8d:b0:46e:35a0:3587 with SMTP id 5b1f17b1804b1-471179174cfmr180134835e9.27.1761217855132;
        Thu, 23 Oct 2025 04:10:55 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c43900e1sm106702345e9.17.2025.10.23.04.10.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 04:10:54 -0700 (PDT)
Message-ID: <56d9f1d9-fc20-4be8-b64a-07beac3c64d0@redhat.com>
Date: Thu, 23 Oct 2025 13:10:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
From: David Hildenbrand <david@redhat.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251017141536.577466-1-kirill@shutemov.name>
 <dcdfb58c-5ba7-4015-9446-09d98449f022@redhat.com>
 <hb54gc3iezwzpe2j6ssgqtwcnba4pnnffzlh3eb46preujhnoa@272dqbjakaiy>
 <06333766-fb79-4deb-9b53-5d1230b9d88d@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <06333766-fb79-4deb-9b53-5d1230b9d88d@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NHOUAHYklUMstEB3yqDlwdHKWWpYb_oWAsyJhlHkK4U_1761217856
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gox1f5cgbcih3syzp33igej7uksh8ch7
X-Rspamd-Queue-Id: 18EACA0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761217858-870131
X-HE-Meta: U2FsdGVkX19bPJ7r6Eauhx1BQQnwYg9P40TC5UiEH06sznChnuVmjMqLGlAGa0odkukQIyUv/ZC9Vk8SaoP8wohHlx/JSCVNnGyT2xtSXLZzjcyukNseHJEnq4BweKY56j/kgjAxX5gY43Bl5Jn8cR6BGoIkNkDMcbgZ36HrQW3ltRvyyPzCX04T5PAosA298SoddYpnN+xqnthgqBpkSm5irl2EAWi7xRTBq5dwPKMls/bhK+1X6j0iCgMXRR9GeEM3GNbJ0RL0i8x0ApkWtu88721jMaSqDaRm33DUU0I6PWEzr6jcWKKbgMX3FgNDGcszGrGBaptxN5LlFhaMUrgM8ZyVWe5mXFMKmJkA+fQU1gEny67lS2Ns05/kdR9FE0Kyo+o+Fu5v0f/KK5xa8pMN8/SrnNORPgNCLfchKkVOXsnfd8XfKAVTLDslmuJUHQOLc5DvJ30VIy7teFWFxZi3nvBEXNxofQ0oIdrjUnMwdbQ6LExershgN2QRelwCvW9JbPSkySJ+AWfAlW+aFrffALEEcOdpGs2Zu1yYDLjTqi9GOkR4PRggQGUM1Aqpum5g1Pe8YreLEbfi1agYO1nZrYXh9Cxpf286UJ79+6Tzze6o8x22iwQxJ65j+geVOQYTai4Zg4zZ8OdgebXQ7fnRjbov+TOMBKfGQyrgLcGTLEFtjEXRFn0dOQETTKhidKolo76LDxleAju9KcaLsSRMWRd1BHNHKPOEW6CaqH16st5bNpMlv/13u2zWOURQIdFMQcOBZNqyDr211LMLGpqC38TfrdvWodX4dDAkLXOmdJMpdI6Ccj2l3zNyhJfmPcB4iH5xHC66imH8E0BAgnaZUhMW2QJQWPTOu/zAT1iUFVU6zMHJpZXnwHmHVJZRajzCAh/I9hJeIvPWWpuuT/tz0aZYSHF4wIh1RFqP879wPthDpZL03uATczR4d4+vA5vbYiMwpYCuVISqIic
 L7aEzpWJ
 aqdDu8w3LELHNK0bBvfSc6K67Tqw44QChRVrZpaNVHsp++oLJsrHlgvu0Ra1zEoCqp62MBY1CnGtcXOSwp/b6CJaq2qM2XJPqtKMO9dw2Z3TGHWILeaRJEh/zixXueWG203qstlCRGgCYLPX7Ie9G1pmakYnK3i9US9aELPPr7kDzke2I+SqxW2opBfMjCEKgSwnhnMpxsBtv0FG1cOU93G4hWzaxkPh0Q8OTG0AWqBqqQZLMcX3Vy3fKLKYwLnYCoSkiLqSeWIYg/7AmkQUEnGA+2Nl48BZ6dF8Wv+a/3BwwXd5iaK339CDATCioRJtzUGU6QgUhkzgPn+OWcZb5Ju5FoA7Cr+BsigMWcDbHxFOC/CuFy44c2twmCT5/xUWWVySA10OAJ4PdMuB1nIAQXXQrZZybX2xWQtYQzWd6NiOElp7o+Vuaj7u4n2ThpPQUEXJWWC/5sReNvXRMvlx0yfnwCcWjg+Gtms2tE4Gzcb4DzPtBiTJC0OpyDT7WGyp+iuT4aT8czjoKpSs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.10.25 12:54, David Hildenbrand wrote:
> On 23.10.25 12:31, Kiryl Shutsemau wrote:
>> On Wed, Oct 22, 2025 at 07:28:27PM +0200, David Hildenbrand wrote:
>>> "garbage" as in pointing at something without a direct map, something that's
>>> protected differently (MTE? weird CoCo protection?) or even worse MMIO with
>>> undesired read-effects.
>>
>> Pedro already points to the problem with missing direct mapping.
>> _nofault() copy should help with this.
> 
> Yeah, we do something similar when reading the kcore for that reason.
> 
>>
>> Can direct mapping ever be converted to MMIO? It can be converted to DMA
>> buffer (which is fine), but MMIO? I have not seen it even in virtualized
>> environments.
> 
> I recall discussions in the context of PAT and the adjustment of caching
> attributes of the direct map for MMIO purposes: so I suspect there are
> ways that can happen, but I am not 100% sure.
> 
> 
> Thinking about it, in VMs we have the direct map set on balloon inflated
> pages that should not be touched, not even read, otherwise your
> hypervisor might get very angry. That case we could likely handle by
> checking whether the source page actually exists and doesn't have
> PageOffline() set, before accessing it. A bit nasty.
> 
> A more obscure cases would probably be reading a page that was poisoned
> by hardware and is not expected to be used anymore. Could also be
> checked by checking the page.
> 
> Essentially all cases where we try to avoid reading ordinary memory
> already when creating memory dumps that might have a direct map.
> 
> 
> Regarding MTE and load_unaligned_zeropad(): I don't know unfortunately.

Looking into this, I'd assume the exception handler will take care of it.

load_unaligned_zeropad() is interesting if there is a direct map but the 
memory should not be touched (especially regarding PageOffline and 
memory errors).

I read drivers/firmware/efi/unaccepted_memory.c where we there is a 
lengthy discussion about guard pages and how that works for unaccepted 
memory.

While it works for unaccepted memory, it wouldn't work for other random 
accesses as I suspect we could produce in this patch.

-- 
Cheers

David / dhildenb


