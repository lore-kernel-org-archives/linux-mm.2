Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4303ECCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 19:40:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A39C8E0007; Wed,  5 Nov 2025 14:40:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 853AE8E0002; Wed,  5 Nov 2025 14:40:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 741E68E0007; Wed,  5 Nov 2025 14:40:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 611398E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 14:40:02 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1E8CA13B014
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 19:40:02 +0000 (UTC)
X-FDA: 84077569044.09.5CD8A0E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 89EDE40009
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 19:39:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ji2EfKxp;
	spf=pass (imf01.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762371599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7kizs9xJ2GRG/rLXAdsJnM3tvDx/8JZcjC0BTEZZ5WY=;
	b=ACtz2yyVWSAof/Q/BdAglwn1/FIEpZbrq/ES0CuJc8l+bhVQLEOi6DPAJ8+EHJ8qnRTyS7
	BQdL1yz1MlGidibwyPa1+P6VvABQW5Lfd2WYX+ICtrf5BYbuvd17Msl98zpztEQJBAq9M4
	LkJK+2xkb+g62aBrJTQWSgQCkL6Uhyo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ji2EfKxp;
	spf=pass (imf01.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762371599; a=rsa-sha256;
	cv=none;
	b=cKC6U23m1GClh4Zo42ZdFkm4T56T/3QZIt4BaU7SzBQHAFuuBJlCHc73g1EAMHLTLLzTJi
	IW7U0sCCi2AZQ+Gp7xtrIZ4e8zUQEnUuDH1mtHOGjSbCaewfrhMERoW6VFRnteMEgH/0PS
	Xqedywjo5iBE28lMeHU9kYUrmwXR0AY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762371598;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7kizs9xJ2GRG/rLXAdsJnM3tvDx/8JZcjC0BTEZZ5WY=;
	b=Ji2EfKxpkouMdAoEvwjcpOHzHYFZhaM7jucQYDckjDnvfUtx7PFR8xXeqaQLCYHcVYgMka
	LHk966IECzXZey1eZFLuYckMCIxYYB6b5mZ4CC0sHvkI0QKmZfFqQnGsXz43zmQEUdU8YX
	BL0LLF04F1SuySglXbOwLw5JjUQax84=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-135-KwSiDwMoOrivmhYZCCs6HQ-1; Wed, 05 Nov 2025 14:39:57 -0500
X-MC-Unique: KwSiDwMoOrivmhYZCCs6HQ-1
X-Mimecast-MFC-AGG-ID: KwSiDwMoOrivmhYZCCs6HQ_1762371597
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8b22ab98226so67783085a.2
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 11:39:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762371597; x=1762976397;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7kizs9xJ2GRG/rLXAdsJnM3tvDx/8JZcjC0BTEZZ5WY=;
        b=U5AdkJQAjU9UJlCBVcc0bq8jh1Av3pB0nSEyWGcgIK6V7tCncxA92Wu/CZVyhs260A
         BV4VARjIsnal5LJfhqONE78MhCYfURdyNFqQxwMB7O6MXbpXUdNsHC5KrZ7i8Gv2PtHs
         bCjOfE8CFaaWdpPtsLFQCO2lvSUkQWcUfBucWxFDBCXRnQbetLGBNDZfSEPZe6+pNcxi
         K3o+nYppUsemNDAm1GOPlApEFpAd9TBgSMDJMNn9rg8No9Xu4Y+z9woG819j3lJ4ueNQ
         9n1482VWGwrJIHktPTaSk9D2LwyStzkFtZh8F7ZL/BgpVxuywUaRBermDPl12Dl2DDVD
         morQ==
X-Forwarded-Encrypted: i=1; AJvYcCXpKf9TFsKTwx8aWutSFJfDkKDXTGXH6w2F+yKJCRIIZnVyrQh8LmMLYv97pHe2v7fDlGXoC3OH5A==@kvack.org
X-Gm-Message-State: AOJu0YzOZGNuKANAQBUuJ0VhLVnTfa4Rc59gIYjHH1Cxx/aDsjf4NTL4
	t9htVjP8Kn0QI0XjUPwOXOo7pzgps4WLd3QeycxtUBKoNeUOno4rtvvhV1uf3zp++/2mJbHQt1z
	G3IyBllAeh4VkpSV5kDAZecRQ+kgCvrXST0QgITAC9T8KE/v8+W01
X-Gm-Gg: ASbGncuTwdB7/X15tyKuqKXcglxiQI6e1Rw5BuR/M4qu3S4e/F5H1GCNs7p2KIds22h
	cB6qXSkFekd9d5syRxu3Jo+Fh0WOmoInn8/f+5pEGuKKcO+73oTxZoz7oMMpMe9IwAgbR39ho2+
	e6fGZCgjfIewQFnyysVMQLL/CATj77BO8jHnBcRp8mD0H7QPby0Wj4ZSsciACl7pBhGS4DYnxZc
	71VH2Xl6CDB3y+vjnNUiGEVIHvzgBRmXNw+xeaKmlYt4q1i1CKOnv1xoerX9XXWQvvVEr3rUz0w
	S/KT7w8LB9jomCIx+JyQOrdaMn+2mlb4+I3ezPV5ERrd6BcItzyAx1gAKKwE+Y1ku2MBhcVEMy5
	xif0DdZdC89Ut/D1nybBYXUndeKDsPDuZYrvefhxKCFkVBw==
X-Received: by 2002:a05:620a:460f:b0:89f:7109:185f with SMTP id af79cd13be357-8b220af7c8dmr589559785a.31.1762371597220;
        Wed, 05 Nov 2025 11:39:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFd9eT2YzuyaD6xKA1zXzyy0WWTMe4/Y4jwbmI24djGe/tYf+EHmXjHRZnQzj3cSXaGnWo3FQ==
X-Received: by 2002:a05:620a:460f:b0:89f:7109:185f with SMTP id af79cd13be357-8b220af7c8dmr589555485a.31.1762371596761;
        Wed, 05 Nov 2025 11:39:56 -0800 (PST)
Received: from ?IPV6:2601:188:c102:b180:1f8b:71d0:77b1:1f6e? ([2601:188:c102:b180:1f8b:71d0:77b1:1f6e])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2355c2797sm30330485a.10.2025.11.05.11.39.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Nov 2025 11:39:55 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <74c2751a-4de6-49fb-b675-dc3c7f6e0bef@redhat.com>
Date: Wed, 5 Nov 2025 14:39:53 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/33] cpuset: Update HK_TYPE_DOMAIN cpumask from cpuset
To: Frederic Weisbecker <frederic@kernel.org>, Waiman Long <llong@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
 Bjorn Helgaas <bhelgaas@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Danilo Krummrich
 <dakr@kernel.org>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Gabriele Monaco <gmonaco@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>,
 Marco Crivellari <marco.crivellari@suse.com>, Michal Hocko
 <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Paolo Abeni <pabeni@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Phil Auld <pauld@redhat.com>, "Rafael J . Wysocki" <rafael@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Simon Horman <horms@kernel.org>,
 Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 cgroups@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-block@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org,
 netdev@vger.kernel.org
References: <20251013203146.10162-1-frederic@kernel.org>
 <20251013203146.10162-14-frederic@kernel.org>
 <ea2d3e0e-b1ee-4b58-a93a-b9d127258e75@redhat.com>
 <aQtxMYmwzfg2NW1O@localhost.localdomain>
In-Reply-To: <aQtxMYmwzfg2NW1O@localhost.localdomain>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Q0B6tc3iUdBfrrODfww0DZNUgDox3sOAp8wSrtpO32I_1762371597
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 89EDE40009
X-Stat-Signature: 967ojtsoh3ab7mwxc7fk6y1yyfom9oys
X-Rspam-User: 
X-HE-Tag: 1762371599-156956
X-HE-Meta: U2FsdGVkX1/Pg9+Q5Be/4GbIWsKJB1n/rRKivP/YULEz2slsWsI9p/15tgJ4uEEb+NWCH3UoQK2k1cnDoeXUESCpdj9pTZzC37HyhH4To67x66TtbI8e4vhTLMQtbNDdmPzyP0rOTKQDbm2DWx4cWl/Bpt1vH13r88B6kw5wrNWugrYY/RBHb7GZXur114gHJ75OIawGIJwex6V5TCGmjkUTHRnWR/02Tlfe3eN/uO4MH64asECX7LwPl5sJkJeZrH3yCCRjUu07YZMoc2+T0S5z1mSAPEZ5tO8wgxEVuWfZWlFcX0ByJCgP2o5EU4lJi5DSG4aUHTyeuyLSSmdYdxgTRR4eT6+cfv7f8hAeZVK+8+tCCwXnavpwp+5r2Tat6Ww0orPtwjDfX295m3qDqVNmrBsBlmMvehtIq+LeOhXl7IgihOhC4CODPpa5/iW4zHbVi9RMkAYaot76jSjPvckOqXxyoxvWhYJzs93w69mRyuH556ebDecFIxWdLJhrCc9wEMEo6w42JdXXrntN17SVE9QIy1Tuy4X9NlytXKn3guXq2up5cyRcncwyr2us2U78PTrojGGbV1jGsiy0vS8EMDlfVP2uLW4YUGdG7Bb03KTZmJ6bPxoF0WOi5YiVN0pdub5QmyjhL/p5glGTbhFRcLxMM+G2HYi1Hi1W8huwV9qOphkCC9xe/ng8lssBH7jamB47WOGoLWly2+/eCuPa/3Q8uW7N8B3sJ+2+4QmANY5UiBtFdekeqw4vy34oqG/XWtqONUGotGPURiBcVf5XPXU5/kVoSTnAVfzhRCkzP2d0iOGIlO5aX+DZCwZpmWgjEfJcgePLocJxdYBD73FzFhPoYc+7TECORELRMCdjCOeKPJJe2KYVh4/C+Jb0mMIAMy6cvGgYa0WvBVUv5PQc4T6dKA42T1hR80WKt5JlDW794OZ9frHvW3yFsCRnHY2nChDvI2SHSk+FQYy
 OEtgA8R/
 W7iBq0+iCfh8SjdIqzhSyZGklzDvQodUXVsFIkCFbTQQSyqg7G2dgrJ3HAWI0Ov+RElH8G1qbw6Z86Bu83bziGtbearwGgjQ0LqYxZ8wPSaqsUhL8sDIJwUZZylTHc9/r/itBJlD97CwLapzOxpQf4pSCCR/nofJJpReJ/21u7bGvnESMHZ0LuUL2NOgrKGEZTdLle3f82RdpSplTJ7FH08m/SCR6Pbkz4Hu4566Y5lUJqsB2gXror8sOMU5PUDPzNFC17AQKSBtje0kdbK0NCFd748au2NhuGBtmF2h/F6oFosn9njOZZ3I0TsOqFV7dHZ1tm8ivQ1gmHzNFzFbquisaVvv2m6z1sRZtWoEnusLhC6y23rqPCFSHEq4b4OdyzGue/TIte4Yxi6WWLPvLBtMIWjM/ttDv6DoKTAtCgMr0OIi07gyodlohu9t4ai0IYVXan2c1dQueTt2WrtW/Gv2EtBviH0b1CAjcM8LbQT+FEljToYE4WEazmiUyzUktmRFtWq/woTNou444JQT6e/5ZOoa/Wgsf7Bk4fBqcbifknmhJDROyrjbLlyc/cHWWVYBJWP3tiyhFu6nDcn9NdLU7336C1mt5K5JK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/5/25 10:45 AM, Frederic Weisbecker wrote:
>>> +	if (!trial)
>>> +		return -ENOMEM;
>>> +
>>> +	cpumask_andnot(trial, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT), mask);
>>> +	if (!cpumask_intersects(trial, cpu_online_mask)) {
>>> +		kfree(trial);
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	if (!housekeeping.flags)
>>> +		static_branch_enable(&housekeeping_overridden);
>>> +
>>> +	if (!(housekeeping.flags & BIT(type)))
>>> +		old = housekeeping_cpumask_dereference(type);
>>> +	else
>>> +		WRITE_ONCE(housekeeping.flags, housekeeping.flags | BIT(type));
>>> +	rcu_assign_pointer(housekeeping.cpumasks[type], trial);
>>> +
>>> +	synchronize_rcu();
>>> +
>>> +	kfree(old);
>> If "isolcpus" boot command line option is set, old can be a pointer to the
>> boot time memblock area which isn't a pointer that can be handled by the
>> slab allocator AFAIU. I don't know the exact consequence, but it may not be
>> good. One possible solution I can think of is to make HK_TYPE_DOMAIN and
>> HK_TYPE_DOMAIN_ROOT point to the same memblock pointer and don't pass the
>> old HK_TYPE_DOMAIN pointer to kfree() if it matches HK_TYPE_DOMAIN_BOOT one.
>> Alternatively, we can just set the HK_TYPE_DOMAIN_BOOT pointer at boot and
>> make HK_TYPE_DOMAIN falls back to HK_TYPE_DOMAIN_BOOT if not set.
> Have a look at housekeeping_init() which reallocates the memblock
> allocated memory with kmalloc to avoid these troubles.

Ah your previous patch of this series did that. I was thinking about the 
existing kernel code at the time. So you can ignore that comment.

Thanks,
Longman


