Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63103CCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 07:24:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFE3A8E0067; Thu,  9 Oct 2025 03:23:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD58E8E0002; Thu,  9 Oct 2025 03:23:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEBD28E0067; Thu,  9 Oct 2025 03:23:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9CB668E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 03:23:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3E94B4615E
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 07:23:59 +0000 (UTC)
X-FDA: 83977736598.03.C565466
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id D9E3B40014
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 07:23:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GChpJ92O;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759994637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eWNm9RVbxSdHs4WXMVxPHAelQ7JHZVOamF/5YzHwKUw=;
	b=1HGu2BmpYb+gScOAox82I8qtpbIdyJ2V3jKAb6nnl1bjLCjnSfQzI+XCm+7U9vOhxw+4TK
	1LOcRn1qFSJ5A6VysHlrxhvgsGDN2hccDuRJKJXRUz0kKfI1/ce3UeaGjTVAaAhu7dx46y
	7zAyDOZ8p7QkCpibz9/9H6cSmOM4Zkc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GChpJ92O;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759994637; a=rsa-sha256;
	cv=none;
	b=NclH7H79IywRs426LyRsDEV6wE3royh/MOnNDMz0HH/aVSBpZMl6pHfPEp45MKJSeImnZf
	q//9VkXC7+6J/uc00GJolGIIO46leIoiz8a4vWGy8Z7yqTWPtUmlRxrVVjqJbw59vqDc1D
	TmUjqM/lnfEbWOWh3tKD0nUlS+6mh6g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759994636;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eWNm9RVbxSdHs4WXMVxPHAelQ7JHZVOamF/5YzHwKUw=;
	b=GChpJ92Ofsg4efW+PyaPxKNrdSGHiUnQw+mgfZBDCw6BioBjBhMDJkWN8cPnT0xILyIn66
	BMgE2Rn27tWnOzzp0ar8Z069tb/3gUGAMzK+fBn9guUK2xDlXssn8+nrR8xw4cAvu2u1Ma
	QrpsSWSTagZEJLfg2sDm82fyW1FJbc4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-fweLIqBGPv2fazpafJi-YQ-1; Thu, 09 Oct 2025 03:23:54 -0400
X-MC-Unique: fweLIqBGPv2fazpafJi-YQ-1
X-Mimecast-MFC-AGG-ID: fweLIqBGPv2fazpafJi-YQ_1759994633
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3f6b44ab789so382098f8f.3
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 00:23:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759994633; x=1760599433;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eWNm9RVbxSdHs4WXMVxPHAelQ7JHZVOamF/5YzHwKUw=;
        b=FGgZNZFzbGHg/7BBko1zqp0s08+3Bxo1ZB6YG5Bwxf0qzwaD2pmdxk+1cAMJ9pNl9s
         qikDNr2a7XRKPQQ0DOb+3DOo7Ks3mKJspXNy/ks7fttIEPg9wnqT7E99ShmG70GyhQVc
         RW6KwIiGJ6R6xdd4a/ccOQJ/IyYR7kSDdIWUDLZCSFQQ0jzhQAMBWg/nEg8/zZ7P76YS
         KdZ/xIItbJVfqdF4YSVk8l40NpAxKdnQBcN2wSGN8lunqqI3P7jz3ISesgxmkwjd2WFY
         IuSdAv7tuvtVFQXNreq9kvtaWaRVydjVj3BAyTcitbI/IyGa9s8QA5GWIwkjblj9eWsj
         NAng==
X-Forwarded-Encrypted: i=1; AJvYcCXgLivq/6EWi2I2aWmV5tUgbiUniS1R3YOtiUhuus51cyacFAmE52ZwIjduCC5/fe3if3c3rODfHg==@kvack.org
X-Gm-Message-State: AOJu0Yy/nY7j3XyhvuuIve7F+zH9W4JTwKSRw+X5ohXGTujSqRwW/mye
	Apc2mkWfhQAUKSd2F7fRC2qZnDgAO7gr44VEdfG/E2RVnfSuBSamhE0StOnu5H24Nzy83WAW3HM
	ao6NvftrJ7DqMGxKiEQvW3XV0g+Yqwpg4r/e09E3hxXNgIG2+3SVY
X-Gm-Gg: ASbGncskEccxAzAqJ6CYXVFt+B6CEyqNKXomUGR4fXNAXw3iQ/xXvwrGUETfHR/ffJ5
	ujo3dkufLK9h1sbgYV1SbmVXk7eOF7P4NSmThybYFY42lh4lkURu70g0J3On5RNvkw5Cx7SoGUd
	Hl6LBoNUtv/uUDOQCFLPbgwy2IIFaxyguEk0MOMBJ/oKSgE0WoaNReDgYODUpo5Y+fYXpXAF5Mu
	y1YTxnxVa9yvVxyRQdHa2pIYic0BbyfnNPn3GrUqb1mMGxbcPs40xU62hE6Nua1+w5mOdTUqnME
	p8b56aPGabDTSE/+ulXzWuWqOEtCvCUIAxVnSoGtC52eBN4p/5ZDe57Elmv6g3JTTTg/Y3mUBv3
	X6Qvqveyy
X-Received: by 2002:a5d:584f:0:b0:3fe:d6df:c679 with SMTP id ffacd0b85a97d-4266e8e4563mr3738207f8f.55.1759994633421;
        Thu, 09 Oct 2025 00:23:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFuEcg4bk1Pe3uVgOdw8Gn6sWJObDLQJrWwb68mJVt1z3tdiZp/95/RumQE4BoLLosHPrY5tg==
X-Received: by 2002:a5d:584f:0:b0:3fe:d6df:c679 with SMTP id ffacd0b85a97d-4266e8e4563mr3738187f8f.55.1759994632988;
        Thu, 09 Oct 2025 00:23:52 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8a6daasm33593052f8f.7.2025.10.09.00.23.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 00:23:52 -0700 (PDT)
Message-ID: <8a65e8c1-3028-4f9c-bf1f-c8f1d3956192@redhat.com>
Date: Thu, 9 Oct 2025 09:23:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug: Performance regression in 1013af4f585f: mm/hugetlb: fix
 huge_pmd_unshare() vs GUP-fast race
To: Prakash Sangappa <prakash.sangappa@oracle.com>
Cc: Jann Horn <jannh@google.com>, "Uschakow, Stanislav" <suschako@amazon.de>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "trix@redhat.com"
 <trix@redhat.com>, "ndesaulniers@google.com" <ndesaulniers@google.com>,
 "nathan@kernel.org" <nathan@kernel.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "muchun.song@linux.dev" <muchun.song@linux.dev>,
 "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Liam Howlett <liam.howlett@oracle.com>, "osalvador@suse.de"
 <osalvador@suse.de>, "vbabka@suse.cz" <vbabka@suse.cz>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <4d3878531c76479d9f8ca9789dc6485d@amazon.de>
 <CAG48ez2yrEtEUnG15nbK+hern0gL9W-9hTy3fVY+rdz8QBkSNA@mail.gmail.com>
 <2dcf12d0-e29c-4c9b-aeac-a0b803d2c2fd@redhat.com>
 <805DB7B5-23C2-437F-BB94-2188E310FD75@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <805DB7B5-23C2-437F-BB94-2188E310FD75@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xrKGDU6DD0pIWZ7i6P1zAjYz2jEWUK3HTMpNIwoMRqU_1759994633
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4mmxcwuffafmzn5qh9c38s4qtywifye9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D9E3B40014
X-HE-Tag: 1759994636-808817
X-HE-Meta: U2FsdGVkX1+pvGZzYozvUGSua1e+/+r6AGC8aPinvLpbg5JLlpxQ7wZsVTkBwkh00e3XWKbiHFuy52IH7fsEe0NOGHwy+B+VyP3Ww7UUxPWi9snBSdXaugZWbwQ29pQWxM5Vmoaxb9MUbxkufzUu9zoThSys4WokECsNgG5Z2VFExsAeuVvoqXoTe2BA3uNz8Cc20u+bLuXldhedsCIgtQYxBZvk8/beSAwkc4pk+bHHyKzZc3ebgCGtVbNo8mcrdG06Jx4QAEKbnznwqTkiEyxLGQAq9APUMaalq4Thcr4cHvjAcirhNXLKrsKr9BEOpn3jyCBTuVPud1uDVbaBtuEXhxsogsDvE05cg6JE6J0vRgyoIUA8MFIAmcvGm/iX/JJ2smuca5fxZqKtv7KW/XO9ja7vI0yTRfHivmx0BqznFsb1EuZxt8ttOWLYHuJZiN8mkMM6WmNVekZDhy0YRqNJYKF8IvTmJl9sx79kQ1LzN3VtceRNkATLEb82QxVRScv+wt5FufAqvMr2YlIUsJc+9ShuwpFS+FG9yiWbX8QwgSoZM7Sq/znk/ong3GPFP+6zihvjRazUx0dEBuhX0NlN1PjNjlL93QqF1hksoHvjBL9sWkpWo95Yu2KYdQlYE5uWT1gaWyX75arn+hqjS/mne+AyOLTyALA4umTltCU0vIveqZs/KGZETMdvFVqf8iVqfpUA94Los36mJfWl5DvtBxBb3KSNphY3rEDfOt4v1XTdi1da8S4LL+y+W8ymyMNIcg2/Eu7kHyTvyQYg8vQHtd5nko2uRh0uAF8VtTbmRRpj5LjCLDXAE/K5oA4suLqbbWGke0VPgr2REfIa7DcOWh0vPXZLTnBGDN1bc3VqxYk6WHwcFbMz2377+yT5NUepUMm83qxFgWlBUY8kPJD5pUiFnNtZNGLK0qGsxtAEH/gU+pcBv2+TfrysVdhuPBDNaERge6+qVborHEy
 HbvL7voS
 uErJoG+xmSaY7uyyOgkgA5ahRtDubtCeHXQeYmAjKuLdhybWdadLvMQstMipOGO4wsVoO77/E2KRS9N5X8x+84OIG/WFYHr8p+XGuDv7dyvpMXbs9hDudSlSBtPM4aMbbSxCItgHMS3mjzhQRSXMkVKDebDnoawkzYBiPvKCIfd0lp7wQTzfja1NPJq8wQqAlYxAJrH5dQTqNus+xj2IJcMA4F5RutKkdB1qE3JxPwCsTjqKHIwSsXXgAjj9vRBBB9wGycEeA6gI/YVEcx9feEnViZqvLYpe4ZmkJ7CSmbcV5+65SN2dIaAvcVnBOBjJzN2tL41ZcCN/FM6nkmvdp3LaAAEPEIRb0RjRyjUlagU6aceab3j5ksEH6BE3Xb5sKOeX76cuj7agERbQokDp5T9yNyIDfHSYvchiUn0ETHOqvfyQtGf8V9pDci0EQ71U27DWfzBab+12JLR9qBONSvvfeJTSlk8vbsz2axOOR8duWWZShpmXeOfRfdUMUi7GS3wh7qJvJSGphx+ACIUOYNPc6mIHALpFoesnJithqMyJrxmGTMIuGoAemkPgIO94JhaBwV6h+BvJ/wy2E30u0GsgAsFEP8imuNOC3MbzlcqBksIeEyiqHqkYiFDWI4QZzdgbTeNUafgSC4SQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.10.25 00:54, Prakash Sangappa wrote:
> 
> 
>> On Sep 1, 2025, at 4:26 AM, David Hildenbrand <david@redhat.com> wrote:
>>
>> On 01.09.25 12:58, Jann Horn wrote:
>>> Hi!
>>> On Fri, Aug 29, 2025 at 4:30 PM Uschakow, Stanislav <suschako@amazon.de> wrote:
>>>> We have observed a huge latency increase using `fork()` after ingesting the CVE-2025-38085 fix which leads to the commit `1013af4f585f: mm/hugetlb: fix huge_pmd_unshare() vs GUP-fast race`. On large machines with 1.5TB of memory with 196 cores, we identified mmapping of 1.2TB of shared memory and forking itself dozens or hundreds of times we see a increase of execution times of a factor of 4. The reproducer is at the end of the email.
>>> Yeah, every 1G virtual address range you unshare on unmap will do an
>>> extra synchronous IPI broadcast to all CPU cores, so it's not very
>>> surprising that doing this would be a bit slow on a machine with 196
>>> cores.
>>
>> What is the use case for this extreme usage of fork() in that context? Is it just something people noticed and it's suboptimal, or is this a real problem for some use cases?
> 
> Our DB team is reporting performance issues due to this change. While running TPCC,  Database
> timeouts & shuts down(crashes). This is seen when there are a large number of
> processes(thousands) involved. It is not so prominent when there are lesser number of
> processes.
> 
> Backing out this change addresses the problem.

I suspect the timeouts are due to fork() taking longer, and there is no 
kernel crash etc, right?

-- 
Cheers

David / dhildenb


