Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80339CCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 15:48:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D800C8E0141; Tue, 14 Oct 2025 11:48:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D30A38E0090; Tue, 14 Oct 2025 11:48:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF8868E0141; Tue, 14 Oct 2025 11:48:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ABA748E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:48:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4294C882AF
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:48:12 +0000 (UTC)
X-FDA: 83997151224.08.AED8D2B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id D3B7540012
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:48:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WaG4Qskw;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760456889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Djb4neGqN7bdJt3lIbmkhjCyJV1zYm6kD6UrWD9JbA=;
	b=QpRrFtsjQ7eu9Juh4FPTZ8qaQYnDjPR68t+dBbzm/dhTJCUtrSXRAiIHXfDM1ehscjYZLf
	dQHUD2IaxyAXyWMHhOyozvYx5DnsxEOhEjATefuCbCtea8Ju7YKKFunpfQBEunf2ZmJ29P
	B/q3SpUf+hUJZ7miONsFOdf9MfpTVrM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WaG4Qskw;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760456889; a=rsa-sha256;
	cv=none;
	b=kbyUh7Hz9zDeURVLKQCBWVn5DDm2yDyiu+yBIuEe4/akIxcViveHavAri88kNOR1lNg1/f
	PJsO+zbXh2nrVi3YNHD9Zogfya93zfeM84ijsa61kpfle2V6RsRuWQF2nlRkY8Nguv2nJ3
	Yh7jGHxNuOCZnGHo0O6USQGrX4AOfuQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760456889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+Djb4neGqN7bdJt3lIbmkhjCyJV1zYm6kD6UrWD9JbA=;
	b=WaG4QskwyWZygHTqXpfQP5v10t6AGcZgb7UFxIf3R460WivDuqJgyiSkTqJHk2BB09I6zS
	uBKekfF+R86fj5h1jIoV5W2LzFS1pCV6KlFvFo6QIxraYbV463gquiUjKUXLy0Y4/G6GVG
	d89R98WkCsaU5C6naDfrCsNAv8mEv/w=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-126-9BXUJTZUNd-zsEADdIPDfw-1; Tue, 14 Oct 2025 11:48:07 -0400
X-MC-Unique: 9BXUJTZUNd-zsEADdIPDfw-1
X-Mimecast-MFC-AGG-ID: 9BXUJTZUNd-zsEADdIPDfw_1760456887
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-426ede1d66fso602747f8f.1
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:48:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760456886; x=1761061686;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Djb4neGqN7bdJt3lIbmkhjCyJV1zYm6kD6UrWD9JbA=;
        b=DTDPw93djAZaVO3VbA8XaUcRqvFYWATfotmWMgBJKXZQU0ggALFUTVP86NWmPyYFqh
         sqyKDYGe0HzpBs6xIHQO3UoUA0mYP4GF/eCe6Du2yvYDZGpYIGr9gROHbbLTDV5Hd2Rh
         +nCgER3RoqVeZqjTuP+eb2T9/JzlWVuN2ximxIOhICNUrbBHEB/YMrr/k1TI0nRwM0I/
         IkwUJI1/HsxWrOh+L1x6MVMDQ4s9jAEJaKXepmrhsJB2zoLPF+rA9+PK117lPKXfVvp/
         moCH3JDiPlTL+6Z7qyJ2+pOYZbZeTS1DK5TXHg3poOl7TuRTxdghTLCRen+1B+0orDFa
         0y8g==
X-Forwarded-Encrypted: i=1; AJvYcCXZYgVj72bbovOX3+sUTkcKUgfqcsmq4EPYRnESgD7sWttnZtRCPJlv9gAolltixlMh+KmpaN3c6w==@kvack.org
X-Gm-Message-State: AOJu0YzYJ+nvObMnvrw6+wEHks+LlAt8+kLiDWIkPgkZoLpKKJtTb23K
	HrZx3L9P/6n0u8/tN93DMYbMuUJQt2oEPXdiY/Lm5kGlOVve9eyuph5GvWnsxajZnJ+4jgI4CC8
	/DoHvpCOtrO5gk0F3i8YT/Sc3vRC4LQsbyJy+dgZ9FFff1++2BF0u
X-Gm-Gg: ASbGncuNvmyxBMqKmEzxVlDU4xonAAcNMV25DaGiJmoZS+ktB+FvHf/lf6AzZojPv/e
	UK5hFnOfqiCmaEoCdYzyvi0A2D3rNNqjQV/BVG1iENJRm0RtWWY9T09+s9OBOCjzzufoH9i7Tof
	UsM2NPe/37n7oIUUktIVzCIKxVeeBSh4/BFD1iJH0bB84OD5WeRly5XIAinPMTdFK6uDQGja7Oq
	+ZLAxbdE6PsC91bq8foUIWbt0eLUXH2ubCXNM3OWXj46ae/r/9CJdG1mJdIyE/6FNXeIiPcF72j
	zqwBUBALZAlNQp0+pzveDHXuqjrqD0GUxHEw5Bsm2F8iGCuEG9nVdDKWFVjHw4ETdDaKQ06reg=
	=
X-Received: by 2002:a05:6000:2dc5:b0:425:72cd:8363 with SMTP id ffacd0b85a97d-4266e8e8190mr15447433f8f.57.1760456886664;
        Tue, 14 Oct 2025 08:48:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFlooUl0jhUu6+zOkTx9Jkcb/unTNqnce5dFnPPyX4WIFWplBpxgrTnJwI9DXJb+Jk5kPYErQ==
X-Received: by 2002:a05:6000:2dc5:b0:425:72cd:8363 with SMTP id ffacd0b85a97d-4266e8e8190mr15447401f8f.57.1760456886215;
        Tue, 14 Oct 2025 08:48:06 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5d0061sm24315396f8f.30.2025.10.14.08.48.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 08:48:05 -0700 (PDT)
Message-ID: <89d1f871-54e3-4c66-bd93-e8a08ff640d3@redhat.com>
Date: Tue, 14 Oct 2025 17:48:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v3 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 Liam.Howlett@oracle.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 dev.jain@arm.com, hughd@google.com, ioworker0@gmail.com,
 kirill@shutemov.name, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mpenttil@redhat.com, npache@redhat.com, ryan.roberts@arm.com,
 ziy@nvidia.com, richard.weiyang@gmail.com
References: <20251008032657.72406-1-lance.yang@linux.dev>
 <f33735d3-b38d-4b6a-aeba-b415e6b24ea2@lucifer.local>
 <0bfdbccd-9d4a-409f-ae43-b44bb7347d70@linux.dev>
 <f7392f43-b8f1-4e6a-b9c8-25ad8a47f82c@lucifer.local>
 <d2e5b099-94bd-444d-9946-182807443539@linux.dev>
 <c44e198d-7d46-491e-adc1-86cc306c27db@redhat.com>
 <b35b649d-5566-4467-8222-e358439b4f84@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <b35b649d-5566-4467-8222-e358439b4f84@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UHvSLQF96d4AQgaWnQu871-rrWokw2eflX_nIZcCK7M_1760456887
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D3B7540012
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 13besauojfb1ia3a33zqtnwn4p6khntu
X-HE-Tag: 1760456889-607535
X-HE-Meta: U2FsdGVkX1+rZ4fsyuMm1EViBDvd1X/5/cY7h3xyT5FRk5palRLbt3GDknxk2CqJhMxd4xwkAW2wj4r/0XJME/q4TixbPNqjZi3PO7LaMLCzvTkRVgVt6uKQCrwwxZQWPi3Tk1fYam6adFhT4QRrUhz4yg3pQBP9lvMajJ+AgnnJ/w6BCK/pppaw8kVbsHxflgdAbjeTdsqMFOuEBNcXQf413HTr1Lp6446IAZ77MakXM2T7LtIaheDwss53qqKOge7dw1qRN70b9aBKOt+vyI2qWjVw9uHhVfStw7yxwRu04OjVwcfwiv7DQHpHgk9h6x/kvrvtaHPHc8LCLE7E0g/e9k7nZw/ytOP5G5L/F3B598rOWZ8p6OcDgRAnT+OrlCuLbJdobCVvTGODzhkB2YFsQqW9snPYwRRdp9YksFkEFSQeAqQfqCx8HX9RKMaNQibLM5GMQHp6jqjt079It5yxmrSUOeg80bPJZ21r5VxJfFujQhx48SN8pe9uDxg/RuMnk7pQ853pAITEzMWV9gfJwHYUxZCQFUmA5OrZJgmWmP4XadGLL9JyGwNDluYVl/CukIYY1ZZPTMK9B5OkFiyJ0qCEHv1RSgh4b9cKBK8kDOUeXXonmaG8zfwfrrpeOY3uMojWC396MXuzNba+Be+AyJMp/mEeWglJLx06Hy66ffMM2aDRNO4vRVoHuwPQ9s9Uvi0W3ALDTTgrdUxq5Io7StcBwI4k22v7p8VRZNOTJkpWmepeTdwrgUefXfFCBywGbTAobtHbnvM8fWCndrcdahIObhJkS4mkYNvGlRwsrKORitM97bBgKctzDpdFQ5aXnmCdEYtbkrHUHuffNZj5rP7qHFeG16FSgtkEDzlRgQcOSLkWV7i84r3cCATIqkkscccvVOtCwVj4tpdxWwRMsFAP0J0nAg5hn0mfNXNxfbzhdK2aMA/UXj/7qfzuaoDNkTlewumRMMsanY5
 JQrAqfMS
 e251ijwp1eps0NfbKNRs43NflKw+ChkdctP62j02Kxfh/WJqc1x463cH7ueFq1TL11zyWn9sm7gqfJl5chtPm5cei151adglV3pnwok8Xk0OIGMeNCv2QC3JnIjRZWIE1y/bZJOBN7XbBd7DRtVvgTPFr27aCpwovUx8WtT8RYr25yhqY4yKnTeVMt6J+Io6xRcyWKmiWup+zsuqa8G08Dg5m/xkXGUYomLpJ/41PHXnJs0RTYp+3IMnxUxmnEgy/TB95aYG4LLjyDuHFKLPgofENKCPvipG4vD45D+z5y0mokSt+dcgoDVFnYCruT6l9/23T+YQqznvbo5a6XMYgB6Q8QoHxB9rJLiPrE17IiyE9WyfvvB3sbeU29KtoMeFjLturvSqeADaV6EMSMGBFf463pfQNJFZlgvuMMAp9buHaz0bfgYilcLLs68FA+vdWTGwkYwStIljjXEZ+YA5FTPBw26WhwYpbx2mFr2qWsmlGFclKxmNJQA9daw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.10.25 17:41, Lorenzo Stoakes wrote:
> On Tue, Oct 14, 2025 at 05:12:18PM +0200, David Hildenbrand wrote:
>> Can we please take a step back and make sure we are not starting to do stuff
>> differently than elswehere in the kernel, please?
> 
> The code already had the is_swap_pte() check in it, so this is not changing
> anything, it's just avoiding confusion.

Well, in hpage_collapse_scan_pmd(), in __collapse_huge_page_isolate() no :)

And then it's called SCAN_PTE_NON_PRESENT and it all starts being a mess 
TBH.

But as raised offline, I don't have the time+energy for that today, so I 
don't care enough.

-- 
Cheers

David / dhildenb


