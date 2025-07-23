Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 304C2C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 09:25:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0B9D8E0005; Wed, 23 Jul 2025 05:25:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B94508E0003; Wed, 23 Jul 2025 05:25:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A83B48E0005; Wed, 23 Jul 2025 05:25:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 959318E0003
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 05:25:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5AEC38064A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:25:55 +0000 (UTC)
X-FDA: 83694997470.15.D6024FE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id DE524100005
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:25:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Lha/DSOm";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753262753; a=rsa-sha256;
	cv=none;
	b=oC58pz04ShBmNeg2bLy9st9ABKpwT4pCjnLIi+/Cw15lB8R1vST5PHJAUHZNLja6DVT+s+
	shbMAzBBVOaUIAdLOvQD6WFZNvW3xyHdInzFXRzY2+wO4YCTdoi1JGWDkZhaTw25eFw7QX
	qyg/rVE67Pa6pdTCjHls5tbv51GlT+E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Lha/DSOm";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753262753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sCf8Aj8CqcKCT8W+sN9Cfe8UnmLiHoTES6bbWgE/pKg=;
	b=DqWoiFT5JAAkk6UYsnRM90sAr13jOD4rRvLS6dsYNHtKB0Pl9DxQb8xULwC/RqsfTYNrRj
	4XYEHWxKI9FRr3bOuR0AiOZRc0pgPb1rKcD3G9Be22A/FnDRaZXH3STyP/52AsCOgh3OXF
	joV3DBQNLJSYbEBO3NIj4wlAF+Yj0Zw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753262752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=sCf8Aj8CqcKCT8W+sN9Cfe8UnmLiHoTES6bbWgE/pKg=;
	b=Lha/DSOm+SvJlxNzY5T2IO2IUqLKXg0YAeV3WuGav1wAjk3bA0cxjZuqhYPJers5ieT8fx
	/lyZunfGSsy2xslbQjBVli7o2eWae6zKIutq6nxa4ALjF94jXVGiKMEPzvBKpFYIIryphX
	6XojvBRclbXIXsKVRGCwtSguxe+hbT8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-389-wVZANqmDOki4FZZuH8GMsQ-1; Wed, 23 Jul 2025 05:25:51 -0400
X-MC-Unique: wVZANqmDOki4FZZuH8GMsQ-1
X-Mimecast-MFC-AGG-ID: wVZANqmDOki4FZZuH8GMsQ_1753262750
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b604541741so4707940f8f.3
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 02:25:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753262750; x=1753867550;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sCf8Aj8CqcKCT8W+sN9Cfe8UnmLiHoTES6bbWgE/pKg=;
        b=kYObRpv1Kwv2N+gpyyoB2h6LzdikPJJ3NZx/s+asssN1DNuKGM7ID0PA6gRFkmwO3R
         36vzwdN1Ab8GF47gysXxpEQsy2p6pZyb4JyCg7inqdbvCJaSBl4NeCdxuap/51ciF7cp
         MxMK5hudmj5Q0tROCtYiJOmHRBr9DBvZsGEtXYZsTIhE+dBVBdfvU0qggNBOWOZyrn+i
         y8a6uikPJeUAZ1NZDAH9Xx8oICL0nQ3QjCurpRmZY8vJhKYPvYoifYcDZtZ+hHSzHhW4
         52lW37kHcUHCh7x6+EuQ2MqT6bjSjrUPABDmA0vi1vXQmZwC/H/Ab+DtJTYTsjVXpMKz
         0APA==
X-Forwarded-Encrypted: i=1; AJvYcCUqwME/gC877I7gDh8Rjeb3fmtQ+SiWEFVSDMkt9RiSy9i9dlNf/aW2eG16KxYZ6ov8qgYFGODH4A==@kvack.org
X-Gm-Message-State: AOJu0YwSvr2CrlBykRyzXAqCRbcy+A7AoA92SOf/Avc7f2xOItcz3Iub
	HWfrIgt1idzicEVUIs6M8N294P0AsIsO4tstC0QzYSsazhelVAPVE4hBgx928cJ+1Ry5Hvxp+bk
	QsEDZ2eYTRZZppNTVoYLNdwHRwzyGcF8EgIHdSqeqIfKas5nrDktN
X-Gm-Gg: ASbGncszEhRXFGXaUK3BDo9PkbkrQj3gM4LzMPrFtEaawbMpdO9fQ8012OipPD5iiKf
	uS+4AIqyZG0MRxt99y9F48hLKS+2KEWZCMm0F0cYMXU9aaMLDJYVRSkEUuwXAk9/WEAQckx92ln
	h4PkKn+G2fcqiQABnDowwCqgJRie2YPcjNp+Pk9Z3vvWhNIrEABhhrRx9kX49/MibjiKrogs5mv
	8Z5y19kQlo+4jmq+Fi+91XBM0utOh6oRqn0H+s3jbVLT5zgojXUGx1RwZAVS8bm34OnimY55MOX
	648hY6UpuqAKRNR+xgs4x8XEH7cSMlcvEK17sJUTZKq6ybyyWN6D8cR5fY2nGp3IIFmGwbF9rJP
	PlI+OXwV9P/AewzyBlcTUIaAlRfvcPH278iS7QMawMNtFXykdEDgYMeH45X+Q56tDdPI=
X-Received: by 2002:a5d:5f93:0:b0:3a4:e480:b5df with SMTP id ffacd0b85a97d-3b768f2686bmr1999885f8f.44.1753262749520;
        Wed, 23 Jul 2025 02:25:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFtUubqoA0hMp5my3F0ywmrRe1kGuOJ3bA2qH51pMUGeJqeMcqjO+aQrd067eLUelen0I38dw==
X-Received: by 2002:a5d:5f93:0:b0:3a4:e480:b5df with SMTP id ffacd0b85a97d-3b768f2686bmr1999843f8f.44.1753262748961;
        Wed, 23 Jul 2025 02:25:48 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f00:4000:a438:1541:1da1:723a? (p200300d82f004000a43815411da1723a.dip0.t-ipconnect.de. [2003:d8:2f00:4000:a438:1541:1da1:723a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45863cd63f9sm27634505e9.3.2025.07.23.02.25.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 02:25:48 -0700 (PDT)
Message-ID: <11ec00da-56c6-45b9-b04a-7e79467c4300@redhat.com>
Date: Wed, 23 Jul 2025 11:25:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: add stack trace when bad rss-counter state is
 detected
To: Vlastimil Babka <vbabka@suse.cz>, Xuanye Liu <liuqiye2025@163.com>,
 Kees Cook <kees@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250723072350.1742071-1-liuqiye2025@163.com>
 <202507230031.52B5C2B53@keescook>
 <c7a32d87-efbd-47bd-9a18-9eb51e441a7f@163.com>
 <119c3422-0bb1-4806-b81c-ccf1c7aeba4d@redhat.com>
 <8dd1e8f6-f96d-4d36-ac2a-c258ac842f75@redhat.com>
 <5cdd3e44-3e3c-4697-905a-ecc61093f7bc@163.com>
 <fb5426c1-c94b-4e79-b09a-fb6b8b1ce03b@suse.cz>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <fb5426c1-c94b-4e79-b09a-fb6b8b1ce03b@suse.cz>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Xp-Gl1JwaE3v7XdYVCk7ZHWHfKKDqeKj5tN_NFnkfDM_1753262750
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DE524100005
X-Stat-Signature: ea1zh4pkn94gtehxqahys133y89x8wao
X-HE-Tag: 1753262752-974286
X-HE-Meta: U2FsdGVkX19MZJqSvZ02YDBqMjx93Qn8Q+k4LHWth9EXpGFy30+AP8bdjvsCIGqA8Stld7K5sgxYwwlDGVXsWxo3UT7HTwI9NMQOUy70kOOJb/rmhWEY0XzsdtqiPq+zdpMb/MrE66H1SqL3PBzHq0PHubBJiiMaqydcYW8YfWV2SwaWiYABXRo9YKUuGKZSzVXxVwJv68jaO1AB3vwqGZdnX3VPUEi9xIHnmzAtGG569kG9+ATNHi7aAW/yVsPqhD7Ejoulx5ix7zE+lgJIx0kUH3y4wITvo9hicalBQB6IDh2AYkcUAyqf5x0dlLaI9cxKrnN4S27EOR9NkIlOSpvia9/6EmI60+J3z3DqCpXFJvmi5i1sVJva2EtIdlh8vflT4/RL5FQ0aH2abPo8wFf8LQ/zDwYKNJ3s6sp0ye2S6sPdJDHloHUquZ1zN2LNyu7kWojROJGcP+HRsZdkhg7f9lHN3xqiSMJGlPhizaY4xNqjUGw8lRt2PmPzQ5iTVuJoZ3MkcjjoPIm24CFLwxZuB+iDz8Ad0ZjjVzQB5WSVhcO1nZrwIxWZxbgLhZyZzujtX9xa/DJBuKzrG9MlGjtdEGNKA1QcmEn/Wmy9r6xyM5glm8z7V+bKADAML1/WbOvxtUiZdmheIgFOj9sWnkanUkxWSgOh00fIp0pUDXm8uIr8//eTxGUEYsMrOrbRApysoFKQwp2dIGkYkWJdLPp+xSHpYEKBueonsD6DWyw3fdM5+3o8agyYHqIejXKJaDkdvVVtbuvtwllzzyoxgpk0BUB31JPWa9J9WtR1ickLGssxHL6j22nshuvpM1fd+e7QlOKpbiekn9YWYFXR2dx/L3mTbMECXOvFG/5CrVG0cZjSgF0wCjVsKMrPexXIsgWZXEX2OqGJQMVVLu9FS01t2IXrfwIjXs3qSDGKART9Z/WcI4iP/zMHqKRZiOpedKVxW25DwYMT2Iv7byP
 UnlpAXDY
 3JvZ7l8/RnYdSk2LAJl/KFWKb6f2aykkT828mNRfl9x8f6r4Wf9yn/bPrGn4l8sSIM6uo2+c1MbvQBopXZE08aPyTe6xDfEQOUSAEs9LwUPw9Ll36pXgxWdchwnwMO4yxVK+iht4etbdJSAuK9SP1/oseP60cwgfH1XSK0JrsfOqsFwj28fV9tkRZUJ9bDRYiRzekGwmXWobXb5fk+8X6JV7AySBlkslOO+jmzYwRyBeAKpQ5NBtZIYBZSt+JZ93pbgfESVxjlmtgAA5q87ibfryybDC7oezGKpqV/WBi3cmQV1vcr7EB9PgpN6WesVdxwSBDj9K5MCKxz2X2/VK/dfxvM+GMypHmgXr+wWMQMrLq8KbwAyRXDYuXbBq4zDO6BFMW7bXhJKtHA0nAr5k+a/ypBJqV48RmzluEy9jvWMoSTSQna3jmW6FWcsnfe8Yt819aeKx77z18Csk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.07.25 11:17, Vlastimil Babka wrote:
> On 7/23/25 11:10, Xuanye Liu wrote:
>>
>> 在 2025/7/23 16:42, David Hildenbrand 写道:
>>> On 23.07.25 10:05, David Hildenbrand wrote:
>>>> On 23.07.25 09:45, Xuanye Liu wrote:
>>>>>
>>>>> 在 2025/7/23 15:31, Kees Cook 写道:
>>>>>> On Wed, Jul 23, 2025 at 03:23:49PM +0800, Xuanye Liu wrote:
>>>>>>> The check_mm() function verifies the correctness of rss counters in
>>>>>>> struct mm_struct. Currently, it only prints an alert when a bad
>>>>>>> rss-counter state is detected, but lacks sufficient context for
>>>>>>> debugging.
>>>>>>>
>>>>>>> This patch adds a dump_stack() call to provide a stack trace when
>>>>>>> the rss-counter state is invalid. This helps developers identify
>>>>>>> where the corrupted mm_struct is being checked and trace the
>>>>>>> underlying cause of the inconsistency.
>>>>>> Why not just convert the pr_alert to a WARN?
>>>>> Good idea! I'll gather more feedback from others and then update to v2.
>>>>
>>>> Makes sense to me.
>>>
>>> After discussion this with Lorenzo off-list, isn't the stack completely misleading/useless in that case?
>>>
>>> Whatever caused the RSS counter mismatch (e.g., unmapped the wrong pages, missed to unmap pages) quite possibly happened in different context, way way earlier.
>>>
>>> Why would you think the stack trace would be of any value when destroying an MM (__mmdrop)?
>>>
>>> Having that said, I really hate these "pr_*("BUG: ...") with passion. Probably we'd want to invoke the panic_on_warn machinery, because something unexpected happened.
>>>
>> The stack trace dumped here may indeed not reflect the root cause ——
>> the actual error could have occurred much earlier, for example during a
>> failed or missing page map/unmap operation.
>> The current stack (e.g., in __mmdrop() or exit_mmap()) is merely part
>> of the cleanup phase.
>>
>> Given that, how should we go about identifying the root cause when such an issue occurs?
>>
>> Is there any existing way to trace it more effectively, or could we introduce a new mechanism
>> to monitor and detect these inconsistencies earlier?
>>
>> Let’s brainstorm possible solutions together.
> 
> Excellent idea! How about we introduce a function that walks the whole page
> tables and checks the numbers of individual pte types against the rss
> counters. And if we invoke it before and after every single pte update, we
> can pinpoint much sooner the moment it went wrong and the stack that lead to it?
> 

:)

On a more serious note, I ran into that usually after hitting a bunch of 
print_bad_pte() statements: vm_normal_page() would return NULL where it 
shouldn't, making us not adjust the RSS.

In which context would you run into this issue?

Usually it really indicates some fundamental page table handling flaw. 
E.g., page table corruption leading to print_bad_pte() earlier.

-- 
Cheers,

David / dhildenb


