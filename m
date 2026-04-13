Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F224F34C49
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 13:54:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 862C96B0092; Mon, 13 Apr 2026 09:54:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83E606B0093; Mon, 13 Apr 2026 09:54:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 777666B0095; Mon, 13 Apr 2026 09:54:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 698896B0092
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:54:56 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 16849E1F8D
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:54:56 +0000 (UTC)
X-FDA: 84653678592.03.2C4F9E4
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	by imf18.hostedemail.com (Postfix) with ESMTP id 47D9C1C000A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:54:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of pmenzel@molgen.mpg.de designates 141.14.17.11 as permitted sender) smtp.mailfrom=pmenzel@molgen.mpg.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776088493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sbI+QXzK/YtBogBoPqZIH9KKljo2RSxvS0DUKgJkWpc=;
	b=nUGl9gwrxSyWvCbe4lZAtQEh5jRqTh0BJEiJb5o5f3M7KjtR7xnFxqTIeGL8S3YAJd0DBm
	6MepVh2w4L4Y0OPVL4b6jb+B/qpphokIHKa4R6W4HMS0Cc8pxEwbIpyw1qdG9ajdXA4oLH
	0PTtusF2a0Xt3jMksdGguwVcX6KgpZQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776088493; a=rsa-sha256;
	cv=none;
	b=0dK+ZYKi7fKPiygDz2iQ1HFvxr/lW6Iw3mWouBr2oV9h9WB99ofU2x5jdWSn6k5rDN8xm2
	YOUckTiXyLFR+3iffyRYHjRKBhDUwIjpJkIrcNgXu/9YwfIx8kVHiW9nhOw8XzxA+kJMkk
	3RcI1xHVmznfye0dNSMfJvvxNmdsJZ0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of pmenzel@molgen.mpg.de designates 141.14.17.11 as permitted sender) smtp.mailfrom=pmenzel@molgen.mpg.de;
	dmarc=none
Received: from [141.14.220.42] (g42.guest.molgen.mpg.de [141.14.220.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 4FB7F4C2C37D5B;
	Mon, 13 Apr 2026 15:54:37 +0200 (CEST)
Message-ID: <ce76f184-e463-4bfa-afab-0a71f05eb587@molgen.mpg.de>
Date: Mon, 13 Apr 2026 15:54:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kasan: Add abbreviation KASAN to init log
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260413094034.6944-1-pmenzel@molgen.mpg.de>
 <CA+fCnZdA6GzHRifhwKCU4pfZrHxzr-btOeaZqgH7KnNLme2u3A@mail.gmail.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <CA+fCnZdA6GzHRifhwKCU4pfZrHxzr-btOeaZqgH7KnNLme2u3A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: p1gtaq6qpmn6sm15bn9nzr3gpfhw5qn9
X-Rspamd-Queue-Id: 47D9C1C000A
X-Rspam-User: 
X-HE-Tag: 1776088493-657634
X-HE-Meta: U2FsdGVkX1+5ncgDxH+r9/G8El24J0IqIS+6LKyocDTYGmv7ZTSmtq07ITNh+xiA6IH0vx391rF1Y4wU1h/9So0nf2bDGlwaA14bXHW7qYtei6XpJZD/uGNQUDVaFBlq3iwoaq5AjJfZXUTK+Ljn10zYRpbEaQ9CqxLSQCvZDA3MDnxgOTj/y/Nr8ERzOIhJfCZ6DNq0uYu5dmZMZeZAP4B5+gsS9QlFirRlKPG1OQ8s/9S87Pp1boiwXigSu796Q4UmbuQCGC/S1HNnYMf0amNtfkN/ovsNgio1lGn8LabB+M6lK6005Z+q5GmWd2pJ9mVOTZrgKo66BzVfAmf6JJSB+Yh8PoO/8z4AIY012Ez1j+ciEiuux+Vdt44NOXzkNLaNQfNjNNqiJsKzSvEa96SO6tjw3ILDK9S6Zhhc9L3z3xWFBI4ThWx8uMiJxB6OHze6TSPsW+xt0GcsxL4S7H5zvyUtgm7ktQnBccqffLK/ZDg0SI+xWz+6rO8UfbLnw5ISicZwWgW0k4SbTRifmN3P3Cidea7ZptH8e+JqS2ntPdwW1A/q2n+vMs0I6yULa9em7YiEPlH/C2eBZezUQaBqt24MB3KEFa0ZDB7vY96CajqFWLUZGi3thnlhW3WBfm/T9Dv2Du1ni70hIQ63dk+3eDXFFBDWuKBO23OMrhO+cDNp/+tnXqeN6M7aVWgPbMzz6qSneuXXDPDj5psrVKkDmqe/JIbWNMVPbcxTqXrz2eejVm6xsO8D86OqXoEv8IAP3bDNjvvBpPtXHnQ8v/t/7fUa3HkKt+Mrc7SKluOvVBY3Ficg6nLc0XTmMW35j70jdXplG6iHZ+bJ2K2u36o0vV+BFqC79C+1dCH28aQFXFa247gkcc7s7oQy4UywmeAWCSGSni8QpY3H2K6OOrJZrCg4eRF7rxzp8QNWo7kdE0c2lPJZcmt2hNtZVfBaUGaaeeINsXSnpeoqoBa
 Za5IZAa+
 3foDCi5xb+E5O574GjxP7t7lNepRJor/v/qQb3B9hfttABf/37rUkjs3DTJShREzbPvVR0rG3YFoSw/zZeQ2dST+8zdan7yNOkN5JS3xtF4RHykFo6PL2kBWBXaKQbRh2qzbLDaA4vwNpIBZXuZRrC4x/6mYz6S8NadGLpZm8fjxu3oDwQONy4xyOh4bjbpBp+rRR1NoovQ66MXYJ5PLHW9UVzw2FjNhnJcB/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dear Andrey,


Am 13.04.26 um 14:37 schrieb Andrey Konovalov:
> On Mon, Apr 13, 2026 at 11:40 AM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>>
>> `sudo dmesg | grep -i kasan` comes back empty, at least confusing me.
>> So, include the abbreviation in the log line.
>>
>> Before:
>>
>>      KernelAddressSanitizer initialized (generic)
>>
>> After:
>>
>>      KernelAddressSanitizer (KASAN) initialized (generic)
>>
>> Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
>> ---
>>   mm/kasan/generic.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
>> index 2b8e73f5f6a7..1fccf7cc9fce 100644
>> --- a/mm/kasan/generic.c
>> +++ b/mm/kasan/generic.c
>> @@ -44,7 +44,7 @@ void __init kasan_init_generic(void)
>>   {
>>          kasan_enable();
>>
>> -       pr_info("KernelAddressSanitizer initialized (generic)\n");
>> +       pr_info("KernelAddressSanitizer (KASAN) initialized (generic)\n");
> 
> I think a better change would be to add:
> 
> #define pr_fmt(fmt) "kasan: " fmt
> 
> to generic.c.
> 
> Similar to how this is done in sw/hw_tags.c.

Isn’t there only this one log line in `generic.c`, so the generalization 
is not really needed?

> And arguably, we could also drop the "KernelAddressSanitizer" part
> from init messages, to make them look like:
> 
> kasan: initialized (generic)
Some analysis scripts might already depend on KernelAddressSanitizer, so 
I’d keep it.


Kind regards,

Paul

