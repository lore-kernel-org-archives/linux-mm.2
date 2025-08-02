Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62508C87FCB
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 03:09:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF8B56B0089; Fri,  1 Aug 2025 23:09:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA9C36B008C; Fri,  1 Aug 2025 23:09:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BFA96B0092; Fri,  1 Aug 2025 23:09:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CC786B0089
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 23:09:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1AD8BC0540
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 03:09:39 +0000 (UTC)
X-FDA: 83730337278.04.A07F81C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9905EC000B
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 03:09:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="cTpK/6gG";
	spf=pass (imf10.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754104176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CL4g8u4o13/qjXRMNenpP//2ihYZ7pT9I+G1Zdq2UUI=;
	b=pfgVU18Wf4WhhExtAMhHO/BdESFnpvPIZ4FZTrrAxx3/xzVBmubSJU7EI5wdZKIsuiCuIp
	by0M600HdjU937VFzFSICdySaWPNwhxIANwPNhjY60mWkczJZ/aRFNJAbiHWEmDIip95vi
	rhFZD9RE0S+Fj4tKAIJTC7sosIcG00Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="cTpK/6gG";
	spf=pass (imf10.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754104176; a=rsa-sha256;
	cv=none;
	b=5eR+Dov8hlidrSDntVrY0wMaUTRV/92u4NrZgURxTw4+FC1EhoOKmoJ6O2IA7uCocP6I16
	kjRmiQqFPgHbWOp/LT1BJYVdhBh4sml0cegUFzzLoEIowCWHM94/naxdRFpWmij0PwOCD8
	Nelk4LPx4e7uASbaWckBmpmD3ot08sU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754104175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CL4g8u4o13/qjXRMNenpP//2ihYZ7pT9I+G1Zdq2UUI=;
	b=cTpK/6gGaGX3/OCBfwGp72/JzObXCDFIszg3pbCd7CAQW7afd87pi8cVugV/RgJTEeIpvI
	9JSu6yjkb6Uf491WeazQNRRt9klWeSRR2bGE5uYWVDUX1vg79lQoX7mORZAUW5bOLQ2AdL
	M7dN+YVzt/5CyqztHM/qgl9wJJwB/7w=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-355-UKLYxOdqOemYsb08TKoR2g-1; Fri, 01 Aug 2025 23:09:34 -0400
X-MC-Unique: UKLYxOdqOemYsb08TKoR2g-1
X-Mimecast-MFC-AGG-ID: UKLYxOdqOemYsb08TKoR2g_1754104174
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-7073b4fb53eso44136816d6.0
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 20:09:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754104174; x=1754708974;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CL4g8u4o13/qjXRMNenpP//2ihYZ7pT9I+G1Zdq2UUI=;
        b=OHStOY5x43VpeBOUceCoy6sqPEZeIDnzfb8kq6gnfFDZyH5thV/F5+irSCMPuoD7Uu
         gmHznnZQXzYMEnJiv/UcQY8COp8NAghO6n5wEHpbn0T1vudSpYKr60k2uPUZtqAqRKX3
         CNGKMV2mXLpzYFw+EFHyZpngl0gvD5+J4ovcXpo88sZjDr/77KOdrdZ44T0s3Dtd1OId
         utt5sBvyJIoQONztOi7itZ+6HX+dNSFs7CXZnXcl4ytszShbV4w383Gumz9vXI6ulz0J
         YaXB66NrAJ4WcHfx5jLN1jNAW4jkRa3Z6OI/vLvED8EC33ckTDnaqgRUL0oYV0yq+V2n
         UbQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWEP1Wy60AymLzO8GMo8G1bnslvtNrbQLpv+UcMCWukehymLqGxk7j2bhzTtrgD/0QU34uODa3+qA==@kvack.org
X-Gm-Message-State: AOJu0YwrbaCKH1IcXh79gWUI1knfynUXpx1UQ//hM14JK9450fJ93tHW
	Tt5fCNgefEbPXG8dPbPG93tVmACkIwcOgN4xLSBNmkioM/7XazItqwPa2Ufl4LUU29hnq2db21/
	I7ZQzZCAa2XsZf4ZMj2sS2kWzY2t8WWuuddlCG821ZYxcFXUPtmo8
X-Gm-Gg: ASbGncsOWhuwxx3ycmeh1oYAp6aQOikDGCmeUrQk0YkJT1UBNI34cI99GL7f4VOkUkU
	SERwYyIJKUfeoHhnb1BWFOikx43Zg0nwrYbfEVjkCR5CB6x97t0P6rDpwLMR/EY0d8AIJNRPf8+
	/5xCI9+i6IgvIoiG7k8qX3sw2s0paPAhZL9bRBOhaPHMNnonBAahnWca9e+0dki9u+plmDWjsc+
	awREDrDT3y1jHWIFVYhvkqyVwOSaaD7VxXzh6PBwiQfaBG2xsZG2pUAGOwMq9gWbKQnNuaqJ5dW
	YPMbT7e4tEQH/5KT5ThwlUEaK9XSbUMUT2hswSjO10SdJyy5MOpsEkg1pfIW5dwk/cSaiO9gIV/
	I+WK1IUBeNw==
X-Received: by 2002:ad4:5baa:0:b0:707:7090:5400 with SMTP id 6a1803df08f44-70935f8f7cbmr27351216d6.17.1754104174064;
        Fri, 01 Aug 2025 20:09:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF1puuEw1P293tnjOkDiVKdYXSn6TSnuALZUCmtdCwjli+78ruN24cTnD1KiLalWtE0lBEqfw==
X-Received: by 2002:ad4:5baa:0:b0:707:7090:5400 with SMTP id 6a1803df08f44-70935f8f7cbmr27351016d6.17.1754104173694;
        Fri, 01 Aug 2025 20:09:33 -0700 (PDT)
Received: from ?IPV6:2601:188:c180:4250:ecbe:130d:668d:951d? ([2601:188:c180:4250:ecbe:130d:668d:951d])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077c9d6db9sm28743746d6.14.2025.08.01.20.09.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Aug 2025 20:09:32 -0700 (PDT)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <5ca375cd-4a20-4807-b897-68b289626550@redhat.com>
Date: Fri, 1 Aug 2025 23:09:31 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Fix possible deadlock in console_trylock_spinning
To: Andrew Morton <akpm@linux-foundation.org>, Gu Bowen <gubowen5@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, stable@vger.kernel.org,
 linux-mm@kvack.org, Lu Jialin <lujialin4@huawei.com>,
 Breno Leitao <leitao@debian.org>
References: <20250730094914.566582-1-gubowen5@huawei.com>
 <20250801153303.cee42dcfc94c63fb5026bba0@linux-foundation.org>
In-Reply-To: <20250801153303.cee42dcfc94c63fb5026bba0@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZpszmKbTLh05ieP0iPEARaaJhtQ69bM2ANY_vzarQFQ_1754104174
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7oz46ry1hmw6xhi6uwmidz77xfik9bwa
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9905EC000B
X-Rspam-User: 
X-HE-Tag: 1754104176-975137
X-HE-Meta: U2FsdGVkX1/fwE2m+290frDZ7vMqdNAVHAHjho/cHF7HJDjCAt/RElr3uieHWtUSf8FTNsaCOU0fgjXcIayYDMne+HkAEb29g5dnpZV4u6hF6pgzKxeziHl85D+JxlXzblMl6dyTARfF7gF0vuncIhoHZUYm9cOTeu3zwtoqptRZY52bRCmW4ow/7RThiF9OiEnbzzwlXYB+YLz9pRVdiivtGlrCkZpR8mlKJMkFeWq69AjUksxPUXiMFLDYDa7Z+/XU4F2LkUd6PNeR5pnRj8iA5dGBpwVjIUsTQPe4s1ZVGEIRl1/BqJRBlUJciahIgHSv19Usqev3J2P3rRmv3QxdL8Nq9+sja5TNMEPg0C2YRia44haolZDqTj0F6JhnODs8v3UcjxQld94uQzcTh/G8dhtmI16NZ1CgIjIFO0CA38BaRUluSU4g/BfchIJ5UulUO1S7FKtEfUFfUCasushhC0LfnlR9kN+SjICVSV0+NtUR8rGuT9bn511aVLzE4zBO3HTRjRoW3cNAF1oyOmUIECB6S8pbNeM/RTDrJvDwbqUt8xleIFT1PjmLmg9pyDMKXxJZBNERqPBfDhWy3rh0I96W4p4N/D0d49DMs05cEnD05Z16GSBZJPQ+1elLdEuo5XoqmVGsn0pe6pBBK+xfh1TY90h6VmQTizUnL5fV6Ye2IwHCR1pVfi6I5scPGICRwAYPF0yaHAlUn/3Anwo0SZqTQOLCmngBNaWZ3cv4JqLEPMSC/W9C3arSzejp6MDbwDle3wHTyDU+KdCX34VEI4w1jh2YaaMOtGsHRPcqOsC4wLTqsZLxL6K8wtc6awagYF43D79g1zD4pWgzj2+dMChTn0a8TFtGcgppQgogMLlTKUSMzWavmvIX19UbQA07sjzws+jk3yPLWLa0E2R77YWGxQCqxigeWPswRBIfE/PMPQnW0ZFYu5PnRFQ5v+GhS8bSvdvYIRDyIyl
 Btiz9Bhw
 52F3WHcCLkCebVKEPE79bvMscMnWY4rj7BRR3TFrIbxs2jA9sg7QwYWeymiaang9A1piK50+sYR9C3ST6NA9B0wYL63BlCCPAy/CZZN2A44v63MC8OaZH1wlFgguxGSJdgvA0xe4J7PN0UxPOW087J8Bl1bfBo++JG4FWp9pZAz2Gs6cqqnei4pcNEfsXakK4VRxYu+05PrM6k1Lj9rfQZD47BpPBJoTxux8KMMyxcdh2Gx0sDxRbx3N/Jkv3IAELlN3fhs4UMmqSZvDATu2rqFERFfJou1JIKJKQooUEA2FrRCwFZ7l2YM2+QajHGDeJmBOChuUUuBJyOpwWhEON0fgxv6TGXkgqVLqlEnp62QYcObf4I17tBQcIlnUvgVEawl8BXPfFW+9zfvSaCrCCe/VAgUu7p5DZTYIsIofA8GODje97RJxN+OIuP9rLYBu0envQHm4SyHKh0FdsVgSA8P70XwmO551b5E/GEMm/kvFaU8q9TwxqRt3yPskVsg25tudXqg3Xud7WsU2H5jEZaBP6mA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/1/25 6:33 PM, Andrew Morton wrote:
> On Wed, 30 Jul 2025 17:49:14 +0800 Gu Bowen <gubowen5@huawei.com> wrote:
>
>> kmemleak_scan_thread() invokes scan_block() which may invoke a nomal
>> printk() to print warning message. This can cause a deadlock in the
>> scenario reported below:
>>
>>         CPU0                    CPU1
>>         ----                    ----
>>    lock(kmemleak_lock);
>>                                 lock(&port->lock);
>>                                 lock(kmemleak_lock);
>>    lock(console_owner);
>>
>> To solve this problem, switch to printk_safe mode before printing warning
>> message, this will redirect all printk()-s to a special per-CPU buffer,
>> which will be flushed later from a safe context (irq work), and this
>> deadlock problem can be avoided.
>>
>> Our syztester report the following lockdep error:
>>
>> ...
>>
>> index 4801751cb6b6..d322897a1de1 100644
>> --- a/mm/kmemleak.c
>> +++ b/mm/kmemleak.c
>> @@ -390,9 +390,11 @@ static struct kmemleak_object *lookup_object(unsigned long ptr, int alias)
>>   		else if (object->pointer == ptr || alias)
>>   			return object;
>>   		else {
>> +			__printk_safe_enter();
>>   			kmemleak_warn("Found object by alias at 0x%08lx\n",
>>   				      ptr);
>>   			dump_object_info(object);
>> +			__printk_safe_exit();
>>   			break;
>>   		}
>>   	}
> Thanks.
>
> There have been a few kmemleak locking fixes lately.
>
> I believe this fix is independent from the previous ones:
>
> https://lkml.kernel.org/r/20250731-kmemleak_lock-v1-1-728fd470198f@debian.org
> https://lkml.kernel.org/r/20250728190248.605750-1-longman@redhat.com
>
> But can people please check?

I believe that __printk_safe_enter()/_printk_safe_exit() are for printk 
internal use only. The proper API to use should be 
printk_deferred_enter()/printk_deferred_exit() if we want to deferred 
the printing. Since kmemleak_lock will have been acquired with irq 
disabled, it meets the condition that printk_deferred_*() APIs can be used.

Cheers,
Longman


