Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B72C1CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 20:13:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DCA28E0007; Thu, 25 Sep 2025 16:13:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B3F88E0001; Thu, 25 Sep 2025 16:13:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A36E8E0007; Thu, 25 Sep 2025 16:13:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB6EC8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:13:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 94944140506
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 20:13:57 +0000 (UTC)
X-FDA: 83928873714.05.D2B565E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 15B0316000A
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 20:13:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EKrLCKJQ;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758831235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jt934pWl+waL11DifZ1ogJABhsR0QZuMWPNAUgnNLvs=;
	b=162+L+smFBrkeyFEt3e4SCDpBgdN5bb0FaE6aU6d3NJaLpucJN5+JE3rzGDKuMi8Vr7WMv
	nuHJ+m+6OSWbZuI/8HclFu+OsxtVWnbDUuOwwxFAWCQ+RRc19Q4v4HGZaiFEeQ93P/frSb
	5gsWZY1LCd8zdtNmVTcSBQrP+QLmgx4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EKrLCKJQ;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758831235; a=rsa-sha256;
	cv=none;
	b=JgOds86zRVeOPr1itktS9N0Ux5l3W5H++fIW6rbrfsHrtANtRXiSwIT63Cz69Y1jxebLPY
	RSFXS999r+KakBh1fLEhuUWhL2a7bkUVTgM1m0y/r4eEcneNYuOwi4rMDuGYfI4FbuWx/4
	eACtFlrLGavpe9Z5KRL8v9elvHE1Rw0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758831234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Jt934pWl+waL11DifZ1ogJABhsR0QZuMWPNAUgnNLvs=;
	b=EKrLCKJQ12cjXaEl/zjPnLr56NfKlt/k/dIUyFWINoUIsJOr8wH8ozHk2SZHA35jsVHxQj
	9y9a6e1ZVKVYtmZgCl+mKgX6K/j5gq4PEwh6zZ5gctQ0FKJQTYE3BwZV1itr39BQupI5NG
	9ag7/LIRC9cWuQg2afPhCgfR0crTGYM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-198-0HRyYFTCP-ey1NRRenKb4w-1; Thu, 25 Sep 2025 16:13:53 -0400
X-MC-Unique: 0HRyYFTCP-ey1NRRenKb4w-1
X-Mimecast-MFC-AGG-ID: 0HRyYFTCP-ey1NRRenKb4w_1758831232
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3f384f10762so772743f8f.3
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:13:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758831232; x=1759436032;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jt934pWl+waL11DifZ1ogJABhsR0QZuMWPNAUgnNLvs=;
        b=P5YzUd3xYCx8ubbS9m5MuVBvgmtejMJeitkl4U0r3LmpdnQzMGaJvBQSoP0iPxdUrx
         KLFGHQ0KmeLBHYNT1nq6z9slBv+DP4BQaDqYbdkgi4o9naOk429nka4yyFE6hWJynOAl
         /QCFmvXaJGK0WG7VADSHCzZGT9S5oNhJVtvejhHvZP4zowPQTZOE9MLvNuwd0EvqaiX8
         PW8v3wDNNwa5BR4pFGLzHkgO1r2T7r5J25YOKvnNItcijA56zVfLhYvky72Qd8u62p0C
         Teo02f03S4I+Wu2ehdXr8wf6bI7MHDpfSzMpgWA1VNL4ZmSwnDE3oOpZsmmTypXUjWDq
         flxA==
X-Forwarded-Encrypted: i=1; AJvYcCWcIFt0DTg9WLbNG9Ah12zbBhPDAKgCGadI9JfFBSVF0b/NRxnDxpdnPH8DGUng0oppit0RL68wAA==@kvack.org
X-Gm-Message-State: AOJu0Yxc9ujcIKAD0yoBdHItpn9OGSpOSYloWjRzZDMSSXvShUwUigiX
	RfPRDN6j0dzlCGKNUvuU/3P/aqDug9sStGg1jrvp5xSNDJ8t2RSZn8RAFlEj9RquzuYO3ZlEZVC
	jzNSvpAB7p6/IXTU7DPD+D4SPaQ4UTK/rAMBdQdRV/bDhl5XBD8Rt
X-Gm-Gg: ASbGnctgHOzQRtSAReGI/h5eQUat3EU4BMWYQQl8VtACpaFITXB/fDrcnkv/ix0PAUq
	c/qkCleyFv1pourJmPC+fnKxkYYKf3LSw5AiYMJL0zPOD281oVHnnWxGBM/FbJM/EZW3yiKC6Be
	5NRzgtJBFeevVY6IOd1LmcuSi8osXMIPL9qNP2JW11ktqKSGOkbvLZWYNbbrwfxyQ/GR9mhmUAQ
	qR8PQ3o9ydDpMI/yJm+VEowpgHAwdj/S13sOYtMNWvHsE7PVEZcNvbBYCA2w6YkeaOTDE8WSLJf
	E0/e6oC1sBg10CWMX7rO7CrgusWNEceiSbbJQtMzcf9iiNZhJb+jAVLquNP3fJ1+jnxmXcx+7K/
	TS2gq7Sa0G3ehs2C2Tp8ItpwKlaA2h93tMd79fWZAcD48HaiOT/ZvNqRtinJ4bF6RrbYo
X-Received: by 2002:a05:6000:2304:b0:3ea:bed8:7040 with SMTP id ffacd0b85a97d-40e46ad00b9mr4712230f8f.25.1758831231688;
        Thu, 25 Sep 2025 13:13:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGFVVNLdXy4p/tTQ+NT/ePAfr5Q0kgcDHv5gQvTT3sYR20nows4MCsqZEQWfZcFoJRiSMKYvg==
X-Received: by 2002:a05:6000:2304:b0:3ea:bed8:7040 with SMTP id ffacd0b85a97d-40e46ad00b9mr4712175f8f.25.1758831231212;
        Thu, 25 Sep 2025 13:13:51 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08? (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc82f2ff6sm4094888f8f.56.2025.09.25.13.13.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 13:13:50 -0700 (PDT)
Message-ID: <c79173d8-6f18-40fa-9621-e691990501e4@redhat.com>
Date: Thu, 25 Sep 2025 22:13:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/12] KVM: guest_memfd: add module param for disabling
 TLB flushing
To: Dave Hansen <dave.hansen@intel.com>, "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "joey.gouly@arm.com" <joey.gouly@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>, "tglx@linutronix.de"
 <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>,
 "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "luto@kernel.org" <luto@kernel.org>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "willy@infradead.org" <willy@infradead.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
 "surenb@google.com" <surenb@google.com>, "mhocko@suse.com"
 <mhocko@suse.com>, "song@kernel.org" <song@kernel.org>,
 "jolsa@kernel.org" <jolsa@kernel.org>, "ast@kernel.org" <ast@kernel.org>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>,
 "andrii@kernel.org" <andrii@kernel.org>,
 "martin.lau@linux.dev" <martin.lau@linux.dev>,
 "eddyz87@gmail.com" <eddyz87@gmail.com>,
 "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
 "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
 "kpsingh@kernel.org" <kpsingh@kernel.org>, "sdf@fomichev.me"
 <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>,
 "jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "peterx@redhat.com" <peterx@redhat.com>, "jannh@google.com"
 <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
 "shuah@kernel.org" <shuah@kernel.org>, "seanjc@google.com"
 <seanjc@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "Cali, Marco" <xmarcalx@amazon.co.uk>,
 "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "Thomson, Jack" <jackabt@amazon.co.uk>,
 "derekmn@amazon.co.uk" <derekmn@amazon.co.uk>,
 "tabba@google.com" <tabba@google.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>
References: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
 <20250924152214.7292-1-roypat@amazon.co.uk>
 <20250924152214.7292-3-roypat@amazon.co.uk>
 <e25867b6-ffc0-4c7c-9635-9b3f47b186ca@intel.com>
 <c1875a54-0c87-450f-9370-29e7ec4fea3d@redhat.com>
 <82bff1c4-987f-46cb-833c-bd99eaa46e7a@intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <82bff1c4-987f-46cb-833c-bd99eaa46e7a@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1OFyMJ0QzLYI0C0aOujPOeuIEel2as9ITaHoIc04XVc_1758831232
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 15B0316000A
X-Rspamd-Server: rspam05
X-Stat-Signature: qqwtjnmigbhpjcgfsssftwjoyyb7z683
X-Rspam-User: 
X-HE-Tag: 1758831234-295297
X-HE-Meta: U2FsdGVkX18MP9twkkKWcl/0TJYBfDGFKMaVbzaUApJlWSDfRw5DTs5BaJEB0qLLUS0d3OFUmvQhK/vWuS554L3zQAHHsbqIjry1HZb4NE8Aaj1v0ymNe7pYYFmHo7BnPyjHsYGXx1jdCgVWlZZoo2F8S0cylC8HIn5lYeEqUxKXpOYYygTTLod5gq0Jktz8vx4UiT+vFA+ZLyMAhtIs2r/gPXBtnvy1r4ryuwg52P0fdKDAUM0zVOBVvfc1Bd03LOius/DjKtrSFMeSkxqLM5o7FlgRqi/HOc5nELaaV99Fh7xHY7q+xEWB4kCs668Alq3SZC1dGk0J6zIYi2LJk3RoF5R/NsoYijuSGELVyRPgEIzpZb7FvtzFgLhvgiZwcAgQAa0Aj9s6zRM86GnPDWh2qi4vQx2aAuXw5kce/UcBxt12LZIpbAQ9UHhnQQTNr5elGfvKoqzu7rlug2qOFz/cB8W/tHpjJ3b90eG048gvA5IFo/3EKAvJyKIbfCPubO9wTt2+BmPCxvNXHmz5HJiMmF4OgwD3QjimlWtkDHqWPxENGZLGYAjp6qxeyIaUdy+m0sfy8RO/r/5HvZGO/Z+FuA1CHoyxVJV4uotLtKu36pqplbR0zvIU1KTeFrEpFPoi4UqecOVCCYos3O6fDydfgRYb2sXHsp/VJ9zX/0ba/6m0hZeluwjzorrfLQ8FoylcyOvBaJy4FonqKKLBQZ4hnYGL+wPzrv8dipqArCanrLgnPGPnmwTPksVICZsLH0LGKUja2KzilICj5447SJJczhZ6UV7WSznAQxv8m70C1Ztv9pia45/foCZXZ8lUr4V/PwxZ+EicBC9EQkywv2F7OVMCu6NpL02T67upEE9qt29C0VKRohYsqk756ihlD+VoEX8aLYjVrPgnDkgbfDHItaWX8zHDQTp5cn3YK4SHnj1m//TmJv5q5g2xHRwX2fKDpYzg4/uoaUt7C1z
 AIUhADd2
 8fGgThmb8VyOff3ll0wsosvSxvUfm2WM+HIeBPwlqs8UeNXd44xJv0qz0/EBu34SwmoaoudydutfT2+RvYzJPR3diJ8FBr+uG7FddDgaoo1ySbyntqkZpSXcwOftSiD+kbSxYLWPfJ4fxWEoSOoWBYw3ATr3LJFLyV2iQSAzcsOMGfLWTpwx5L1U9AXGZ2fikNu+Wc8PJaODMLDCdXGwE5RBxUW4tdIZ5zCZYfT2O0kWTXzSj/6hc7yvH2WSP6oEJzutk+RP+vo26Sdy7bYQzWpLXjzDnvW4dR+Wg7zPYmO7eyq/t7KznGE0dzA5dodn9l5s3eB5m02VdiDZcUsOV3NnbH86oPvmlcSVD4Z4aYWPfCFyjkqm3F5rjKVQHNyBvOnZHFfYjio2Cjdgmm0BKQ9HmCVBRgAgseOcNTu0Dv/I+Fb+jFncePTn2HzWJA5R6oYdJ4f+fomyaHkd3CVXS/n0+XNE5WfB4bVgZ7oV6DTmcnDsxMiAYmlYiwFxS4EIq2VEFaA0I/qsEY0gtAmYckzuBUUTwKT99/hBEq8ANusiRYudFjYfdeJ9v6dbxKErdxlUrcuGeTqdGB0tvJ5LWB/Qmbg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.09.25 21:59, Dave Hansen wrote:
> On 9/25/25 12:20, David Hildenbrand wrote:
>> On 25.09.25 20:27, Dave Hansen wrote:
>>> On 9/24/25 08:22, Roy, Patrick wrote:
>>>> Add an option to not perform TLB flushes after direct map manipulations.
>>>
>>> I'd really prefer this be left out for now. It's a massive can of worms.
>>> Let's agree on something that works and has well-defined behavior before
>>> we go breaking it on purpose.
>>
>> May I ask what the big concern here is?
> 
> It's not a _big_ concern. 

Oh, I read "can of worms" and thought there is something seriously 
problematic :)

> I just think we want to start on something
> like this as simple, secure, and deterministic as possible.

Yes, I agree. And it should be the default. Less secure would have to be 
opt-in and documented thoroughly.

> 
> Let's say that with all the unmaps that load_unaligned_zeropad() faults
> start to bite us. It'll take longer to find them if the TLB isn't flushed.
> 
> Basically, it'll make the bad things happen sooner rather than later.

Agreed.

-- 
Cheers

David / dhildenb


