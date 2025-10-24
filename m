Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC196CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 15:17:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 002188E00B5; Fri, 24 Oct 2025 11:17:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF4F18E0042; Fri, 24 Oct 2025 11:17:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBC6B8E00B5; Fri, 24 Oct 2025 11:17:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C49598E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:17:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6BCA61A0F02
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:17:06 +0000 (UTC)
X-FDA: 84033360852.10.6D0F6B8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id AC74C40004
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:17:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aClxsJCP;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761319024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GlFP+E/QMyxi4Ffg6P0msiZ7Co3+zXi/ANozyDYceBA=;
	b=K1dzPzIZAeIVzVoxM96ByC/+CPj3LU4m4NYBAug/oS3LflgOK+ZQU9GLaBtbbvdb6iPkzY
	eye1DNfQeBcvZCi2w4kMSjJANCNEfY3MUB5l8pn0Ch4HEDtmirMMbf773BZhCD2CvLm0rc
	VPcKgiKmlyNVyEBizA3i7oBUKPufU/c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761319024; a=rsa-sha256;
	cv=none;
	b=qrmyxsw4XwfULh/mWkmbR6p+gCXTqVNvA325KkQuuLJRUWWHjt+rxZa2b9neCM/9xFDX1w
	sPxLTU+O7JK8PzToXu3hDnCov11YTeOfZn2wsE8YTREq9Q7dYL9txV2vxZWOecsEccgx0o
	lk6ZgEo+QU+rq1x7Vg694ZDwjmdOsE0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aClxsJCP;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761319023;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GlFP+E/QMyxi4Ffg6P0msiZ7Co3+zXi/ANozyDYceBA=;
	b=aClxsJCPZU31iAQ59fXPxEaF6LlHt31qAWjDtSoBjHnBnXkTYErj2st3XjUhEgyLv/rx3w
	z/l4AYeb9yGM7whW82/WyBb59BNRcw7OHa6xVvhqUhDHWPzEOfV+jNF2l4bn1NOPzxo8FP
	DkpCW/AYd4mOYPp8DsJ/LOJO/A5Cl/I=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-49-TVFBDZmXMl-Aztqw2poa4Q-1; Fri, 24 Oct 2025 11:17:01 -0400
X-MC-Unique: TVFBDZmXMl-Aztqw2poa4Q-1
X-Mimecast-MFC-AGG-ID: TVFBDZmXMl-Aztqw2poa4Q_1761319020
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4256fae4b46so1249294f8f.0
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:17:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761319020; x=1761923820;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GlFP+E/QMyxi4Ffg6P0msiZ7Co3+zXi/ANozyDYceBA=;
        b=jPjrbDhR1SXdIsFmtMiRbPhVax4jw3299kXcDrr2Xqn8oNPK/dj5dsTISbTF8kC2gH
         soObUeqIH4i+jPRp/uJFR86hij0uaMhdUufMK5XrGZhWQ/8aZJVBrST4SLSUdPNvkubW
         9HUyNZgd8QLXlWXL294ws0COwUOdl0syeyfHBSxkS6aRk0jDdqslduq5viFtmzkaFXg8
         RuNke20Ce/E8+e4QwlvU4f3nRUdhVc5eEoNPoRK67FLjgulpBSyQs1aVJHxpJubAO+Vx
         EcuLAjcd4O2KAggF+NEc+wcu7R/0X6Bceb73WMek1s4GyOXhRKlFdnOJcsr6KU10ayoS
         vP7g==
X-Forwarded-Encrypted: i=1; AJvYcCWRXArkoYHtfU9Q6+AO1mxTv0GckhIt9CKcxW4/DjA9uTt/mtkaha2lkvSew6uxcciHbbRaLBaeUA==@kvack.org
X-Gm-Message-State: AOJu0YxVxwgEmEjLg7WUF16uPl7QCluiYlHPMiCDzPWfZckk/NpMyGXM
	HKOmUl+DG5BgXSjDzeqOiO6FelBK8mUB6YYGjFLMrLlxZJMAsqi4tWPyHe8JEGKBrkhSYH+Tq/F
	5F3+3bSuFnXqcp/btn1mb6xRrXza6Hq/D0FQmCrCeDu2IEuixDaut
X-Gm-Gg: ASbGnctLIpB6ltDjw6dH04XeYaqdtvlfhPEXquE7Je1wt1EuK/7E7oTFOjcp/YxKYo1
	Pytv9CEl/079Qz7MvKAEG4r6y49KYXO2Tv+lnI0XjkafaKcUtBNvmgkkjwBzd9ijUG/4VStMsAp
	OAoDIIuQJTKWRg9Tbd1CwmpATvxIuHjLP1xYoonHLi7o7z6iaMHWaruJdLPHx3Bx5A2inwpGS+w
	xs1gXgMMf5i9QJTJkqEAJa4q+OJNwQPJlSU7d8Ij+od3T34RD6Dqy1baPPCfiFyeYLDAp14jC/k
	9GVTf8Re7OPkdHG/OhMQ3eM79E9ddvrmlkufqMCLge7b3Q4lm8bhKQLs4EEHsAUN7Ca9jlAE2tN
	+f/V6lPw+rQwMiXHv+eNSmy8iNRDJt2xrpGeCL7DudWSyooqhJkmxj+rtDUk0ciORPzK1yhF9AO
	vG13Bl3HZGRMg7n6hMXxLsf7oCqTc=
X-Received: by 2002:a05:6000:2383:b0:3eb:7f7d:aefb with SMTP id ffacd0b85a97d-42704dc3748mr22122808f8f.53.1761319020069;
        Fri, 24 Oct 2025 08:17:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEtnwuBHyt8rK4Gm7hxH2zJL+lCurT6SdXrynTA2FlfcUyPVPmZWy8oSZeIJ0KwzcUvqy9foQ==
X-Received: by 2002:a05:6000:2383:b0:3eb:7f7d:aefb with SMTP id ffacd0b85a97d-42704dc3748mr22122761f8f.53.1761319019571;
        Fri, 24 Oct 2025 08:16:59 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475caf15498sm112647435e9.12.2025.10.24.08.16.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Oct 2025 08:16:59 -0700 (PDT)
Message-ID: <1f81548e-18f2-49bf-82bc-e0dc667b78fd@redhat.com>
Date: Fri, 24 Oct 2025 17:16:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/13] x86/xen: use lazy_mmu_state when
 context-switching
To: David Woodhouse <dwmw2@infradead.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
 <20251015082727.2395128-12-kevin.brodsky@arm.com>
 <f0067f35-1048-4788-8401-f71d297f56f3@redhat.com>
 <348e5f1c5a90e4ab0f14b4d997baf7169745bf04.camel@infradead.org>
 <70723f4a-f42b-4d94-9344-5824e48bfad1@redhat.com>
 <cbe0d305cce6d76e00b64e7209f15b4645c15033.camel@infradead.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <cbe0d305cce6d76e00b64e7209f15b4645c15033.camel@infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: heFLt5ZfF6bB1wkXgZt5gopQm6q8VrXIyP-7nxBGltQ_1761319020
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: 39uek51npykuwhc1ux9h6rys3yddewf7
X-Rspam-User: 
X-Rspamd-Queue-Id: AC74C40004
X-HE-Tag: 1761319023-558689
X-HE-Meta: U2FsdGVkX19N05j/gD8G/yET+T4qqh6UJSHCYMUtJ7ZuYVrrf4U/bTe9Ott3mV9dJ+85C1jaqQysnGSaDhUu3SPTnTm7sd4NL/UA/Jx/VSs4vBGYdymiQ4LDZYXk4VdS3mn71rtVyXu4NSskuA6QV+FYGwLW6S4IS2vz6SAgDMSTMjazm14+76c8TLtAkhoYp5DsJOpoHFPjpAfeJKbZNyLvuBTJ86VuK5Cg/sqJCiWwpfhSub6cXKsiNfsKruWbfGct3ibfsiacr8LrfXZx1ji0jE/yikHeE1jPToDmn6Z46+kN9S193B60p+0l7OODbADU1XwP87ddQl4ObgA2MyQhgmQdzYFWL+1m5vRxpfnS+avENUqaarY0eJpMt4xgHgi/KLbTNQZG1LKfWkfi2SGao1d2yVviDsK4qG/uU+5cI8qrHV4xczCZP1CwAn2oNuDVGApqE4mXp/9RATLeKInpv5fT7EKMNrjB42q2lP3oZuQ5PvJ5QuJYE+V/o5CkhDiS5zWwA1l+zDwFTDfvn0zE85Mbq4/33e6oYt7aQ/6MxJZdCrI3P7085SvNruVaz3WaXsVNgS/tO2r5mPqDQ1vOpg5rT4uuAJrT8uY5e88QNA3A6fFy8VLY0Nb5roAEpQqqis5TmKprUnYJIGhab4rC/k7Tgl7HGrFStwaF/b887jxS/76pCj92GQEbggeQO8HCy0ALXgLhUaymaD3q/2UixO8EyR7yGGPxJNVjF2qiNsxmkQPQf82PoxRaaRmVEAaOAfnEnNocjMCUNcsP+poeB7RnAUOxV67Dq9wnmJHXTqpKeeAL/W91tMUUK68lVBVDVmxjUXYS0Blr4/nAnhlnDX14Nq/xA2kvIs4vIIzGOffMbR8sPvj8tNXp1vVRkAMqrxYWiiZwQyuFweP9jqH8/K/wKVbenWc89uxJngYk1bZaD4+231f3duap/ho/2aGdjtcc/m8LuSnY37U
 r0mFLRVl
 d0yPBacsZkbghJXnygYZiwnix2kZzKMP/iolhjjBeyAOPdnpupepfCMsMIly24nJyvKqrMtV2jC38znGPIA36Y7CmMtfjls+j95lYmskudsBHgxLjUxCjSRdRMkzJf+VMXsBxFpiCmAN+uarzWJGGBmeUWL5waeYf1lT4I4TvixGY6dbtia8eaI7hCaKRkN/acL+WidTGxU6A7bb1fJXnZ0NU4r+HY5jrWVUk3Ac8Udt12s86IEwHbL1pbF92cjAQni8IjrgklBtcODEKMnZE400XIncTuv10VdzjxRl6O/qaHrnn3T+mt6m944ur0FLVMt02UXvth2F2Phi9Fkn0VDV72oU2+lkEPVhOPseuBBDNmrWqhxvtqRxXgwN3zOQzIggP/KAHrZUHLmpDo9zxqEd3Ud/Azk+9cJ1fS4CHqmP7xCmn7jdtDtAwJCJm2K8nkRWk9/Mk6Hunq9RUKDOL/fg2bQVCIjgc0w7Haeoiw7G9MV+d1BJ2Jbim4CB7pi21/xE8kc5uHTt4rAPdfs+h7nL4MA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.10.25 17:13, David Woodhouse wrote:
> On Fri, 2025-10-24 at 16:51 +0200, David Hildenbrand wrote:
>> On 24.10.25 16:47, David Woodhouse wrote:
>>> On Thu, 2025-10-23 at 22:06 +0200, David Hildenbrand wrote:
>>>> On 15.10.25 10:27, Kevin Brodsky wrote:
>>>>> We currently set a TIF flag when scheduling out a task that is in
>>>>> lazy MMU mode, in order to restore it when the task is scheduled
>>>>> again.
>>>>>
>>>>> The generic lazy_mmu layer now tracks whether a task is in lazy MMU
>>>>> mode in task_struct::lazy_mmu_state. We can therefore check that
>>>>> state when switching to the new task, instead of using a separate
>>>>> TIF flag.
>>>>>
>>>>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>>>>> ---
>>>>
>>>>
>>>> Looks ok to me, but I hope we get some confirmation from x86 / xen
>>>> folks.
>>>
>>>
>>> I know tglx has shouted at me in the past for precisely this reminder,
>>> but you know you can test Xen guests under QEMU/KVM now and don't need
>>> to actually run Xen? Has this been boot tested?
>>
>> And after that, boot-testing sparc as well? :D
> 
> Also not that hard in QEMU, I believe. Although I do have some SPARC
> boxes in the shed...

Yeah, I once went through the pain of getting a sparc64 system booting 
in QEMU with a distro (was it debian?) that was 7 years old or so.

Fantastic experience.

Only took me 2 days IIRC. Absolutely worth it to not break upstream 
kernels on a museum piece.

-- 
Cheers

David / dhildenb


