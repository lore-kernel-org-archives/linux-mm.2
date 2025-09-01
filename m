Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB3AFCA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 10:23:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44C908E0020; Mon,  1 Sep 2025 06:23:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 424798E000B; Mon,  1 Sep 2025 06:23:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33A3F8E0020; Mon,  1 Sep 2025 06:23:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1C0208E000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:23:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C032211A228
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:23:53 +0000 (UTC)
X-FDA: 83840295546.14.308FD70
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf07.hostedemail.com (Postfix) with ESMTP id D367E40002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:23:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aqqwQww4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756722231; a=rsa-sha256;
	cv=none;
	b=oI6Iz9repTb5Hi0d1tFyfqji7YuuLLGG7H5IGA7GJHo1oalHihWxCkoa4ZMsBiRLJxEefT
	rd/V3LHqmjDZ2y68gizYJRxhAMcMB10xtCK0EXWKUryOhTUHuZnHEg/XNK4y7gmNQIKF8P
	+czrFEHRY3w75gMAjajodTQWByWl80I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aqqwQww4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756722231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ldo4EKNNqbGT+Vepx+lQSI49i4EC2FyKj4EafoocNrY=;
	b=roVav2mb8jUS/6pPEei1weZgzctMwkFE38qQ2WJ0qo84v4isEKRbtB7cIBUZCiKxFKKwwo
	t9u2rP31A77Kss+sjmL49K9h7oYurKQ677atre1FuhaWvkDCKOijvdsH2HbM4kJpDWOGmp
	MFBWqNXbk0RRcd+b65fJ4Cv6sHZjvpY=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-770530175a6so2466382b3a.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 03:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756722231; x=1757327031; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ldo4EKNNqbGT+Vepx+lQSI49i4EC2FyKj4EafoocNrY=;
        b=aqqwQww4V8dWuOAU1gr5NqFpkQ5gajYyaBxnv/omO1GDM6HSHAYPLSXzGJAGNbBcke
         WxEWJKJALpNObNG8Sv+e//K861ok+ieeA01YfMZCmEGSPHrugGEk4UAfn2iorIV0ATzK
         +lHV5ACzkSr/tWYUEjy4QjTXUctIcWcGrtMEalf0hLkTRBxGUKCht0ebEzjwdDyNTi4e
         gifcjVyUX/HSpW+e0K+CaIjSSWQdbT+i6bQOBa0kz/5/D6++IGAN8+C8T3rdTu28QvvO
         Kyr0Gga7FNfcHxmhLilXFn702xYkFP+K+LRr/ZmbA9TSkUqN5fMtvrm9LANyXprd9T0c
         ZY1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756722231; x=1757327031;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ldo4EKNNqbGT+Vepx+lQSI49i4EC2FyKj4EafoocNrY=;
        b=TjMF63RkUABM41DZsJCtv6l5vKra/nsbY90jESSKXn+O75QbbciVS//T08K+Oh1D5O
         lUhXoANl4YPEacLxpjP9GvNR49swUvhFMosRXKPz2igD3gqQQRqf/i+D/mvR9OwDMMkG
         P8B47ioFqDxbbTfyKag0cYHfd7TbdcNlHJz+5fMPyRxf92eq2sq9BSjhQ06U8ZQ9yraq
         gea/uMY5rv3VPFE+qxVxdygDwoTKg+LkhC7x2230mQC4NQPay9vteUTv8OobmHX3B5RL
         GGOQuSwpfFUr3edm+W2em0FPmjnl2kITOpSU9BpMCE3N3u3itP4wXtOffJV0Y88w3ebi
         OPHQ==
X-Forwarded-Encrypted: i=1; AJvYcCW5FG9WKGgo7lrgoDehkXM39Pc2NEAumVkavsb+1mI0v9x42jMbH+mycsMrk6kk5kwSrUVMjfw7dA==@kvack.org
X-Gm-Message-State: AOJu0YwTy/hIaqKIS0S4KBGLgol4TaiLq+FDE1ooe+nPdi9RDRwcvlLg
	PTNCBKNKBSZfhED6idGEi66OZa/GKO4AT0zR2smrhmzEqlWkjt+DdCMY
X-Gm-Gg: ASbGnctmhP79bBdxvBjVtnTPI/FR0grADp0lrRVD2QcAzIln7uRLTo09IeG6hIe/tkG
	on9AJfNLTX/ff7WfWIvL3WqNSg3vIW+zxrZ+YSefFSNwxCrWYddvBxXVUhAeg3iJnkmmGcyNIX/
	RyzeuZKmYfa82B7tFiU6AFb/sNPSmyD202jDSBlzMbZp/v9DvIT/FtdeYt6fsaPnACRi04yXTYC
	lgTEQHOg8SFmZoCflMj/u333PPpxjDMW8jg1ieRgyW0l33y0APY4VwOi0vKjd8hrAU8jls0F3Eh
	KZUmigCsOsn2c558X1xY/dYpWkDU+PmrGSnrtf/oUx29Kzd4XmlSIi6f2+k75VMLKOM32riRVZu
	7ePcdE/xcOf89RPg/yEybWw6y4A==
X-Google-Smtp-Source: AGHT+IFFwZhB9y+TlZG7OlVbwdnGHByUNBZiARL4xPw+3fhoQc5acmxkQW/2JBcaU/HDkzW4M82tDw==
X-Received: by 2002:a17:903:2383:b0:242:9bc5:31a0 with SMTP id d9443c01a7336-24944b15ef5mr97480325ad.56.1756722230481;
        Mon, 01 Sep 2025 03:23:50 -0700 (PDT)
Received: from [127.0.0.1] ([2a12:a305:4::3008])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24903705b91sm101030495ad.12.2025.09.01.03.23.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 03:23:49 -0700 (PDT)
Message-ID: <284d5eef-447f-4e12-a121-3742d708c96f@gmail.com>
Date: Mon, 1 Sep 2025 18:23:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 02/13] x86/HWBP: Add arch_reinstall_hw_breakpoint()
 for atomic updates
Content-Language: en-US
To: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: akpm@linux-foundation.org, naveen@kernel.org, davem@davemloft.net,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20250818122720.434981-1-wangjinchao600@gmail.com>
 <20250818122720.434981-2-wangjinchao600@gmail.com>
 <20250818122720.434981-3-wangjinchao600@gmail.com>
 <20250901160602.e25f0107e7b0ef4af1078fb7@kernel.org>
From: Jinchao Wang <wangjinchao600@gmail.com>
In-Reply-To: <20250901160602.e25f0107e7b0ef4af1078fb7@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D367E40002
X-Stat-Signature: 48xie8i7n4zj43rcfujf4a4de345icti
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756722231-973107
X-HE-Meta: U2FsdGVkX19GdzBVDrNevjXAJCTSJG0XMc9UdODrx4r+OSbQWfaGyMSfv2+DgXgI0iWyCVWXivJuMSXZreONLW31nUrvT3Ijykhjt0eVORNnwWvn1YZInZ13MWZXRAWe3B1DZSdF4uUGyxoCkcEmN8N9FzQ3bsflWyyyNTjWkr+nwtxEFfLBDl3XshlinP9RMsQooDj3seWTUT4m92GiCDQymcl57WgQ4KCLt+hj8vYfG9n/kJgM6D3LqAwhTWl9HOsdGD29UX2lGwq/NwVrCwiXMux7sAXF7cGlAmNeQL1PIhM1cUOM477/eDYZndJQQ4r6Tw/SfcD4vC0WJg65ec+4uF9NbQSeb/Or6OlwsBMr8eC/GlrawHvWKllQiR2JK4msmlEzHUyEirRSrSvRFgGDrTDwZcC00YmLmwmKIb2RnAGe9tx0oeW4PfqLFMgBs2+HXPOzJBpEm4oC2PhfFoedtvj/L7w9ajFdNNXHZHl7SwdM5LiwlK/WKm054YS6ePsFlP6VfhXJNhznQSKsE+kVGeQMthCqL70YJ6Omc0mGsMYNaXS2wY8J1A6Ylw0ylMjE/H5dsr6k0UyENM1SrgwazAA0qJIc97J9mLVPd4rCxZpvX+/HwqjuA16v9/dV5cfWK/4hiOVylKqClKgWSzJ0K/5Tk5LI8sIQZ6ufTo8j/6uGJTzKv7/edsyIecrttL+1nAr7PXz7hN5vg3BMZPt4N+WtoX/TTDVekhKU34MGB2ZR4JE3X5UZgweB8ZFWUDrLtHaNhEy/CtyPP1syhWPx7aefYzo11OCBdXRmTSqY7iLiZk0KF5JO8NHuNZx8RbNzVhbkZWJYcOUBtUM1n1l5EWPwrIcpt7uJejvPaOX/BzLSFS9KpTjTDTSYPbKJugyrZeYn8M5UBq6/E8XfQuQdik6RWJTqlVeITkZcPq/JYBQNkDxGbp9pr9nYlqFWsHJ757MbyboGpscfSsE
 p1jq4XX6
 GfbdgjRdL/5sTB+kZacZkGCIIYfYmPwLXHpzaN6rKL0EuKravV+M2ThHD5uv6kdhdaHbxQKpkLaYplvr0XcQUAWekiiDb0ybyV/oRIkK+oD1a32XMoTwsk/gE4WaWuL9azrg+xSgHRS3yzP5MO1iOGDpO5AMTZlVcVbepvDXo+AnTp/ICIkaBagr4gkxtc+bI7lTpCNI9D2RhHnem7gA0LKDIhLro0Whvj1eJ0QQLULWWSPd9YxXyFs8evf1gFD0KoyPQuIgnQRwgIy55B5pAKN3QCaQwujNvqO2yJHJBvKNA3DSf+0fCbW8G25NYigGYOcUJdZR1O2rAM6hvH+32BGqydFecuyxk0V9XXNPHXxU/jkcxlv46m6jZIz89V+gGgsNFGWDJYzcqeP8KNEurXw8D4GPiiWvYZcFZrPPip3b5TKo6UkmcuFuOC4rGbhuFUB+jnl264KgH/TkMknUlBVTcfGCxKcFvFokjV3lJ8UNuIqPFLo/mDhkY76MYDo1ha0DRf5fgTRZZ1Y1XD4hkkwzeIXULmvCIoVESQ16ExwPJgRuP42iIzMBGSyE8OKMdTBw3J/i31ktjIDjdb2vjFbSCV6gtiKOHgWaAgYIzwXP3Mn4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/1/25 15:06, Masami Hiramatsu (Google) wrote:
> Hi Jinchao,
> 
Hi Masami,

> On Mon, 18 Aug 2025 20:26:07 +0800
> Jinchao Wang <wangjinchao600@gmail.com> wrote:
> 
>> Add arch_reinstall_hw_breakpoint() to enable atomic context modification
>> of hardware breakpoint parameters without deallocating and reallocating
>> the breakpoint slot.
>>
>> The existing arch_install_hw_breakpoint() allocates a new debug register
>> slot, while arch_uninstall_hw_breakpoint() deallocates it. However, some
>> use cases require modifying breakpoint parameters (address, length, type)
>> atomically without losing the allocated slot, particularly when operating
>> in atomic contexts where allocation might fail or be unavailable.
>>
>> This is particularly useful for debugging tools like kstackwatch that
>> need to dynamically update breakpoint targets in atomic contexts while
>> maintaining consistent hardware state.
>>
> 
> I'm also trying to find this interface for my wprobe. So the idea is good.
> But this looks hacky and only for x86. I think the interface should be
> more generic and do not use this arch internal function directly.
>

I agree with your point about the architectural dependency. I have been
considering this problem not only for the hardware breakpoint 
reinstallation,
but also for other related parts of the series, such as canary finding and
stack address resolving. These parts also rely on arch-specific code.


> It seems that the slot is allocated by "type", thus, if this reinstall
> hwbp without deallocate/allocate slot, it must NOT change the type.
> See __modify_bp_slot. Also, provide CONFIG_HAVE_... option for checking
> whether the architecture support that interface.
> 
Regarding the slot allocation, I would like to clarify my point. I 
believe the
event->attr.type should not be changed when reinstalling a hardware
breakpoint, as this defines the fundamental nature of the event. The type
must always be PERF_TYPE_BREAKPOINT.

The event->attr.bp_type, however, can be changed. For example, from a
HW_BREAKPOINT_W to a HW_BREAKPOINT_RW without needing to deallocate and
reallocate the slot. This is useful for future applications, even though the
current use case for KStackWatch only requires HW_BREAKPOINT_W.

By the way, I have sent an updated series.
https://lore.kernel.org/all/20250828073311.1116593-1-wangjinchao600@gmail.com/

Thank you again for your valuable review.
-- 
Best regards,
Jinchao

