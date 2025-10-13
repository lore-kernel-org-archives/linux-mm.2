Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDDF3CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 09:15:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08EC48E0022; Mon, 13 Oct 2025 05:15:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 067218E0002; Mon, 13 Oct 2025 05:15:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE4D48E0022; Mon, 13 Oct 2025 05:15:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DB1598E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 05:15:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13256C02D5
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:15:22 +0000 (UTC)
X-FDA: 83992532484.19.B96520F
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id 359A610000C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:15:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MNQbpMfF;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760346920; a=rsa-sha256;
	cv=none;
	b=28Hl1vQVYBdVgtjhmCncF/tVQuRd5jsfRgh8Vecq0wcULEGMUkirWdrBThOSx37vsv6AS/
	oyft/u6I4FNZosmitooGjlU+r2NwcghguXIwUah2VRAaqn1TC/coH864wa/fLODm02qI65
	5B3GVJMnR2YAKkRM844K6NLQWm5DPZk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MNQbpMfF;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760346920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z3uRU6A1V0MHfLT+ewa3AKJSUpsO5lmxHPh4GX6k0hg=;
	b=xMxtg0wmPVBhRWJEdyIZH7Xo6asJTH6VtHZs15CjJYQLJFBvD4AvGnDhqFc7uHGCffGQeg
	d+y+MqedzpmBMsBbJUmrFqjZYJp7uHKRvyb3jpFuFoUbkVwyRM6iCo9Ni6LUZ+kYemRa0N
	577Ev80hXCek0onl+SLnRfcn11bTvEQ=
Message-ID: <bd374ac3-05a2-41ae-8043-cc3575fb13c0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760346918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z3uRU6A1V0MHfLT+ewa3AKJSUpsO5lmxHPh4GX6k0hg=;
	b=MNQbpMfFLQ2qpDDSdEkaNskbe9MHMp0xnYzedG+FVz6nyRLbQztirK+kx5Ir54ngMxaThf
	WDc8Q/rKrID2o68szkR+UWaJ0QWxIRx9EQGrVza8abnWCj8lKlo3duhrKfY5vZdssNRneh
	dVALp7ix5m0wpB/l+OyGFcibB55Y9ls=
Date: Mon, 13 Oct 2025 17:15:09 +0800
MIME-Version: 1.0
Subject: Re: [PATCH RFC 1/1] mm/ksm: Add recovery mechanism for memory
 failures
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
To: david@redhat.com
Cc: Longlong Xia <xialonglong2025@163.com>, nao.horiguchi@gmail.com,
 akpm@linux-foundation.org, wangkefeng.wang@huawei.com, xu.xin16@zte.com.cn,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Longlong Xia <xialonglong@kylinos.cn>, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, Miaohe Lin <linmiaohe@huawei.com>, qiuxu.zhuo@intel.com
References: <20251009070045.2011920-1-xialonglong2025@163.com>
 <20251009070045.2011920-2-xialonglong2025@163.com>
 <CABzRoyYfx0QPgGG4WYEYmT8-J10ToRCUStd3tWC0CtT_D8ctiQ@mail.gmail.com>
 <CABzRoyYK38imLh6zN2DZKPRyQrJkKyvpswqJAsWzEeECtOxaMA@mail.gmail.com>
 <55370eb6-9798-0f46-2301-d5f66528411b@huawei.com>
 <077882e3-f69f-44f3-aa74-b325721beb42@linux.dev>
 <839b72b8-55dc-4f4e-b1da-6f24ecf9446f@huawei.com>
 <f12dfacb-05dd-4b22-90eb-fcc1a8ed552b@linux.dev>
In-Reply-To: <f12dfacb-05dd-4b22-90eb-fcc1a8ed552b@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: kerpbtqbzuzo8eosqszhstyusw6a4kp9
X-Rspamd-Queue-Id: 359A610000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1760346919-514611
X-HE-Meta: U2FsdGVkX184CvxGghEYmjuIFqKGIuX4OPHAOZoTtSYixT93JXolqYkHvzSmi2jLXiPzj9NtnFWAJoe/j0YtGzRCBo368r/990mErKPIgTfj7q3cF4LIPQH0SLrzMgtNKjoU/bng5FyVvAOLpBPMSLvcrf1W/JbMDbXOVcjPQlvTPee40Dg5RR3pUpeitZlPSDcgADrG6vXB87SgnUct+jbQQh3pfFCgFBBxoLVTYSGTkXMDyPyWXF0j61RSSa9CLOrI3lWvyS/kFg51qDW4PoEvFsGD5W9ng5Gs+tsDuEwMmGxdq8NIkyNhoJHEX9rlFm0aNouEBkMMYqbhaNzPczL5pqUgyAokIpfqDW9Bo+GiG37Bm0C9zq9vavKK9vaMEOSgGOOygnxDr90Td5gueisZGusCRA+FpEeRjmfD/edfH0ZNK9oWkxM0oSscFWBWVlukAORgii0XOCWbFwE5fk0V8XRw4sMluS+QU9PdZ4UUqXcs6VWRmoSWVfHEjLhbDUcftXDokD1Nku5mN7jowpWqVNc07m+In104vBmXJT9eaR6QtFVO4eaptwcBKCgroJwOlri+GcAQI0KZeOFac2jVI2dMU8A31MKCx6jqI+8SdYMTOi84l7U3vuRG7elKGC7BawMqfvBa6I9FmmvM/g2IZeXm3NqXppmGDxOlMgF3vGAP3bqcw6QXzYWjcE7AmQBbwDgKq7EE1JGlMsHUAWhkHpwu9sEf/uZFQPGT5MZHLYw6DPmx488qxBpSivRHxuQhEV8vGJNM/pC1kxsKbuSltrcJj4GWck91rZJVXN26dZDM+LhmkONSrW7UIBGnWNjg3wrcx6X5XPXVIDqH2SsfNbqzYyTFSVfSrqPs2UMgMKLimHmaEAPW5qqLhA05Q8g7NEBJZvqhrqHKYChpVlZIEnexgj28DWM4A5KQsbI4zbRkMNB7BeOw8igFytMmBQML9IM44B2TcMODJH3
 CbReN2di
 IW+XdXGx7dXWATLb8TpICVo2M3Ekxdhoq9S7zHYVZXAZy3+0mp79Cgx4l+lfXhElv+Fsx9BV4AJqSNk6+6pxHSvLJxhh3WuQkDQlQ6FUJFjQCHVg/tu8XlV9RtFvvT/JyQ/lHUsLGp0J4QvIU/8EItZuIIJ/5iYFyqy4FGrfuqgS7rcPZzreX5eDC9q9GBKEgtTu2LoDH5WYoIiBrmpnEtFG7DX9NJeWZyFEi0z7z/7XQV2MgJgKYKUWgHxExKGaEz8ya3mz6feT9h3S1KE9Ow8XPqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

@David

Cc: MM CORE folks

On 2025/10/13 12:42, Lance Yang wrote:
[...]

Cool. Hardware error injection with EINJ was the way to go!

I just ran some tests on the shared zero page (both regular and huge), and
found a tricky behavior:

1) When a hardware error is injected into the zeropage, the process that
attempts to read from a mapping backed by it is correctly killed with a 
SIGBUS.

2) However, even after the error is detected, the kernel continues to 
install
the known-poisoned zeropage for new anonymous mappings ...


For the shared zeropage:
```
[Mon Oct 13 16:29:02 2025] mce: Uncorrected hardware memory error in 
user-access at 29b8cf5000
[Mon Oct 13 16:29:02 2025] Memory failure: 0x29b8cf5: Sending SIGBUS to 
read_zeropage:13767 due to hardware memory corruption
[Mon Oct 13 16:29:02 2025] Memory failure: 0x29b8cf5: recovery action 
for already poisoned page: Failed
```
And for the shared huge zeropage:
```
[Mon Oct 13 16:35:34 2025] mce: Uncorrected hardware memory error in 
user-access at 1e1e00000
[Mon Oct 13 16:35:34 2025] Memory failure: 0x1e1e00: Sending SIGBUS to 
read_huge_zerop:13891 due to hardware memory corruption
[Mon Oct 13 16:35:34 2025] Memory failure: 0x1e1e00: recovery action for 
already poisoned page: Failed
```

Since we've identified an uncorrectable hardware error on such a critical,
singleton page, should we be doing something more?

Thanks,
Lance

