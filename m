Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2355C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 22:20:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A539D6B007B; Tue,  4 Aug 2026 18:20:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DC666B0088; Tue,  4 Aug 2026 18:20:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87D536B008A; Tue,  4 Aug 2026 18:20:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 59FBE6B007B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:20:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E87BA1602A6
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 22:20:46 +0000 (UTC)
X-FDA: 85065007692.01.48D269D
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf04.hostedemail.com (Postfix) with ESMTP id EF69A40003
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 22:20:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XYuZqvZ9;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785882045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=voJFtdOcDQ3cvv3g0Px6B4YkGP5JAhQ6QCPfp6/emQc=;
	b=zeELlDAammIp5CW5FbfBft6jn+9qFOkmgo89hOjO13lhCSTUIF9D8ockCnxQV2pv23841X
	urVqSqoIky3uWOSobD+2RD1L2RC0hW5UMfQ2+Imu7DN+3ywmhy6ppK90z5iRK044tNsIMU
	W9PRJc+3pROicDebT4S66nLzISoXcgE=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XYuZqvZ9;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785882045;
	b=JypVMNI9pdSs/AmfWehdqBt26wiLqOkOXOE1pcWW4ltJ7tnmyrAmi4eFfbi0XKy//IQAbW
	PrwgAahSI/FsfGx3UHmgm0+/xYhLULg4GCZDoIXcnJ+Z1kN9B+orvtKjWeaO1aCG4fa99+
	8/tzTWAFChGJGZ1tdrQ+uhVocgfrUDY=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3810c5d691bso249545a91.1
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 15:20:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785882044; cv=none;
        d=google.com; s=arc-20260327;
        b=fk2AJ6LXsb/PGzikbrft06tEcmrrqt8zy2YDcLzIQzXBCNmI/HAgea7YOfl1sr2Li9
         gbcGV2uPfgRNz8+NpPuAnUUsoZSpdfzqqQZ7q+J8REhvf300hemom1TFfD/4g10xWjfN
         FHBXTuIUsIAEFwCEPwVDbLTnz41ueZhItbjUA/wzXx6LgyCWR/YjrVs7J5pU6p5J8u+p
         nJzbGwA/TMBQ8rlRdrFT1yqWQBZJV5aN8DkWLCB/hxkf4HTHIexwfXBbVM5truDU2mMN
         r7K2T8BiS5rmRsRl8k3bdB0PO4SyfLMYP2ahXjL+EMFN26znMDOYm5BG3KH5IcgAzPCr
         6s0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=voJFtdOcDQ3cvv3g0Px6B4YkGP5JAhQ6QCPfp6/emQc=;
        fh=4gZyk9QWHTtXi60K6wmScWML4xuRTW3sef/XyML8//o=;
        b=c3Xi8u/pZHlzVKvPX6vx2HA8C3k57Q9Sv4Gbf2Tg2BshU83yjrTzeWijqGMlrpePOp
         ZExKDCs47KOdaTdD2vHxfW7xOqigpHLQJ+MTPeAZuDsjCTOqgrcWRl0JhJ8t4bp6wLCb
         kSP1lnZUP/jMo0quzH4oy6lgQvvUwbUiHvVmf5TiCxWPHoBGrfHPnZ1kiIK4HZ/7nyz0
         Q+uMUYKSj+iqFnS6wMW8QCWBWVlfssgpHlE82XiOL0BoRD228jIM2u7vAQ26DoTTLOK0
         BH/1WcSoMhtcJEmkcISAlX5PhkAmc3i5hnDdTcTRnrJTnj787T1bgE/90Q4OJB3qwfUr
         4+1Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785882044; x=1786486844; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=voJFtdOcDQ3cvv3g0Px6B4YkGP5JAhQ6QCPfp6/emQc=;
        b=XYuZqvZ9ks3L72fRYUgJ9vF6iGcBgekAjnATJxJpj1IwUt5wJljUZOAY7C2hTHR+Bd
         Zx/90be90pk1TWClS6K7Wy1u3l81k5ezHZTuoeGDz9S6Vz5X0Ak+4uUv3yyEdJEfBLLH
         /z9oBwSseEgM6+lQQgl5Eg90IK4GdYlBubPEDHcGyRwNHWtvWLYoRRPtrHxnBnPPhXBh
         Q6EraIqKrJLxHDkJjPMslVlKGsvjwLwjsK1ku7i3hgoZvG4VMlzfny8LCGpqOvkgEC06
         Msp8MvWyTTORnSo7VGXvobxnhLHx7atXr37b3THWEy37PzWz4wshBqByzSE06rgSRalg
         hSXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785882044; x=1786486844;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=voJFtdOcDQ3cvv3g0Px6B4YkGP5JAhQ6QCPfp6/emQc=;
        b=Z9SlvIyRibkYrrIwMBQT9iL7bO9qpzm0GFJfTc5tQy/0BkuDdSfWSw7aL7DbcEqJnG
         FW0IjsliY+adjVaYq6RRma5W8lF21oG/7+WJKSf8IHPk9mRFnsbk9x21NAOmYJUtymKB
         tOTYxH/AgqakNQ5AcB2JwN6tzodwPKPVaqbbfOawqtq3Mb0zmpfQaFsb7sqdJqBmg89o
         SZP/boxsiQixgMcZFydcDthBFkfwzTDXULq24RhOZZNq0MFDlhzgGsdIBS1NJiqCC77X
         RQVpDO7Wlt7XTxZkMill9e9LVU3vB2SKTTD9MfHzN/siOncQ85xW49r8fwPACk8Fnyp6
         sCBg==
X-Forwarded-Encrypted: i=1; AHgh+RqGQg5+XVr+bg0bBupNGYn8/7HY065PyH4UoTVSzTujByLXmvQQRgoEJiJLjISWG5xX33mZ4zuJ+w==@kvack.org
X-Gm-Message-State: AOJu0YxP54uuBRfGqflBy3O1u5PycxP7hdwRMI0qIUVdXc7Ufj9NvJXw
	e8Lvm+D/Y48DpEbuiXkshd8hhzMBmVzdQcsRSQKAi9YTgRvWOh2X6zxIQ0ubnjuNVAdsCfkMaIQ
	VmR0Gjwu8q7giYk+99uheoau/E7QuNRHcGJUPDkn0
X-Gm-Gg: AR+sD10ndvMLg3zdOpmXy9YYBZGAV9qSHBkT+WeBq7iFbAPL9ur/VU6aE8zUC9IjomI
	aAmx9u7IQTegSd6IiUzyFsswR0Nu3z3p+jcKXdFWSYKKqQ/urEYO1cXqvkfDkbS+aLDFTrY/RJe
	OgBESZ1OTe14ViBNSXBdBhfF7o77I5+v1ufJ5igwlnVaDSri/WlGoPg0wZJ4+CZ8gB9WwleP6ER
	0A3KYrTKcej4sgeSZmm/uR/FhrFPqPdDRWGuHv3p110Utpa0eU44tYxVH//1EweYX4R/8prlfDR
	4RYtz7LuBd5zXoprAdaFSiu6oFeLOwAdCS/ZN/24E93qhoFtFzUzkC4nSxFBL587+kAY8Dm/7uJ
	DOMY+sAFwz1d6A2Z5hBeQNEknL3x9agOVNHZq0kUKwmtx
X-Received: by 2002:a17:90b:270e:b0:366:3517:1aa2 with SMTP id
 98e67ed59e1d1-3903bb0cf61mr2065807a91.0.1785882042841; Tue, 04 Aug 2026
 15:20:42 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 4 Aug 2026 15:20:41 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 4 Aug 2026 15:20:41 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <de780cc3-8c43-46f8-b8e6-3ddfe93d753d@arm.com>
References: <4460e252-b6de-4df3-bea8-0368a9d0f4ff@kernel.org>
 <CAEvNRgEUQSju2tW_1zMk2=QmveZNtmkjjCZdqVBgBD2JPh0k4Q@mail.gmail.com>
 <a823e3d2-8acf-49d9-a812-ac1bb2136d7f@kernel.org> <edc3566b-370c-41a0-a71d-2e4a0e1a94f7@kernel.org>
 <CAEvNRgEas_9BEV-cNxXu4_wQx8sR2M4_OaW6DEd4=fszALMV0w@mail.gmail.com>
 <60552bee-3326-4917-b00f-5fb7ba3b8adb@kernel.org> <be77c2cb-6e41-4382-9d2f-cd299f634196@kernel.org>
 <anCtzQrUkFSSq8De@google.com> <99037993-ee13-4160-8c87-b6642faea554@kernel.org>
 <CAEvNRgHYhKACDfx9ZZy4a-TTS4yWzEJt=Jc92=eXxS15LPnTYg@mail.gmail.com>
 <anJbMf5GBe0Pxh_x@google.com> <de780cc3-8c43-46f8-b8e6-3ddfe93d753d@arm.com>
MIME-Version: 1.0
Date: Tue, 4 Aug 2026 15:20:41 -0700
X-Gm-Features: AUfX_mzkFKRHTDQOiQvLQ1e0yQheZQmYXCL22A9YUJawwpQUjT54D9_OoZJNsuw
Message-ID: <CAEvNRgEOE5oeFVRYYucsCGJaFAQYS1oNRXAwGKzRAyqmoHT9OQ@mail.gmail.com>
Subject: Re: [PATCH v9 14/41] mm: swap: Introduce lru_add_drain_progressive()
To: Suzuki K Poulose <suzuki.poulose@arm.com>, Sean Christopherson <seanjc@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Vlastimil Babka <vbabka@kernel.org>, "hughd@google.com" <hughd@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EF69A40003
X-Stat-Signature: bhc69g1yp9hfbjf4yypd9jdmqiug8xd5
X-HE-Tag: 1785882044-953047
X-HE-Meta: U2FsdGVkX18ID0QISoI3I3c7VspjKexljqvKEcwaHCgY/MdEokw8pdXd8ydPgTtw8bzX926fmVVU0h8dGPxGcZHMw6HSdr9V5GM2jMe2j+gFyjaBpla6ZKQavqljwBmuHk3H/07w8c3CoMKvt1XHvaK6V7+vMHRKkx85QudUXAK49XorFDonJIW4P0owLvBM9c2DtWbaSO98M2wBlQJVTv1XXq1Kc5irpSf+OfRl0cjmRVCfKjD0rGrf0eFtSnEe3AaOg1HWp/0KiNFwCb8ZDh/oUG/GZp8O5nfHE9xFTn/+RUY5icnRLcvjMZQUAyrUQ9AtxvogLQaRLar41fFvKTxkOlhuy603IvkZ94RlNU2PmsjDYB2OxI05KX+W/XzALYyoCwvLTca1gWikHgivVPaBwUbWDYx0fzQ3S0DQlXgLpbyjmNfbbGykBj/PDEPuA5P9TANJ+GSUuvSO+upM77Yxm0lnmZ2YqBpmO+rU3c6WuJ5MF5pLo6DvrbaDt5BDFhf1ZVVgbnWDW3q8fslt3LSbmSZpJDPR0JZe2pJqbDo/V5+A0Yl5HmEvbS0qYEaqk7bD+34ZCdrvP8d5WIaMf+oHsoZnQsynNY1q5yxL93Hthic/tbTkf7Aoe3by7CXUOOKgqQfn3JPetElCTfE1da4WJIDLbDo3FmEs2fKuFvNG2TE/dtmOxhUIn18seNKBrZ1Q09xaliqRYA30+ZVNMqIQF68gbDaOIdFaF4qRbXhhMOE4cIsgblAz+hj+6NPoQSvfy++efQ6z4X3o6zrgvIVzJHEcxvrHFFluPjT3iXiGK4Z5p7aoPcIyaO3IUwZnYOcpKoKYaom5ZLZU9F5XJAzRxRFOEg/UNJsVm0+A7bHKK7fpMD97zTkpkg6MWZLG4lqhTHF+t8oVbCS/P/08Sl005MSlxeiQBrD18zFepuQAswL3o2GeztrILllstQM37JwAONIZlrzljYIFseo
 XPU2oiW1
 JPuwbaNeLcZyAA/IbR0PWp+ETpkw/pKksTERt8LjU8DCARTTpbypV5Vi3som8OVcvkR4z7n/w46HsbzYKVF6X2SF1VGJZFW0qGtS63oin/KJezYiogK9gD2nLfRVsHwFTIxCnDSheVwJXC9+D7yRMsiS/82pSXqM3uYgGvjShdpqgzedxsvorGxnVMKHrCmJAclKMa3fC47s89NtLARhSJprY15ie5YIAk+TBVpsM/IrBuZ4mpRZJAUbo4NvG+QKmcQD/6H/l3/oa0kmtfLObE7bRtHXacJ9ff0ziCgxJf3naXw6WFiml3d2EZZelmgnPNY8a1iJKcg00Bi6MAmI2cszrdjonlGuabUiKX7diCe3HBb/almh9p27ZJO41Y1FYr2BYb4Dapy/noSA5fi6eiTVx46CyHU9bDDgim2+QtbCKEag59tzWXVXtwLz4S9juntOxKTn6sEVZZy8J6rZcfMPQb2YmvXMLujTXKwnAa6v2ZS7D2Ts+VoXl1uIgNO+mHNEU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Suzuki K Poulose <suzuki.poulose@arm.com> writes:

> On 04/08/2026 22:35, Sean Christopherson wrote:
>> On Tue, Aug 04, 2026, Ackerley Tng wrote:
>>> "David Hildenbrand (Arm)" <david@kernel.org> writes:
>>>> Andrew wants to give it some more time in -next, so I'm expecting it to
>>>> land for 7.3.
>>>>
>>>>> 7.2 or 7.3, then I would strongly prefer to base v10 on linux-next (where
>>>>> the fix will presumably land soonish), and target 7.4 for in-place
>>>>> conversion. Then v10 can be applied against an early 7.3-rcN and we don't
>>>>> need to juggle branches (assuming Andrew is ok taking the proposed patch
>>>>> through the KVM tree).
>>>>
>>>> Agreed. We'd also have to get the actual preparation patch into 7.3. I can
>>>> send it out and coordinate with Andrew.
>>>>
>>>
>>> Thank you!
>>>
>>> When we were discussing this earlier at guest_memfd biweekly, before
>>> deciding to refactor out a function like lru_cache_drain_for_folio(), we
>>> did say that the likelihood of actually draining in practice is low,
>>> especially on a machine with heavy load making allocations all the time.
>>>
>>> I think the threads with Xiaoyao have resolved, I can put v10 out
>>> tomorrow. Would it be okay to go with the following from v8, and then
>>> clean up later when lru_cache_drain_for_folio() is available?
>>
>> No.
>>
>>> I'm hoping not to push this back by a full cycle to 7.4,
>>
>> Sorry, but we've missed 7.3, irrespective of the lru_cache_drain_for_folio() fix.
>> Even if v10 is perfect, applying tomorrow means it will get ~3 business days in
>> linux-next before I send pull requests to Paolo.  That's just not enough soak
>> time for land a 40+ patch series, even if half of those patches are selftests.
>>
>>> and also hold back other series dependent on this one.
>>
>> Eh, I don't think there will be meaningful impact in practice.  If v10 is good
>> to go, I'll get it applied on 7.3-r1, and will also get an early pull request
>> over to Paolo (probably around 7.3-rc4).  I.e. folks can start posting against
>> the landed series shortly after rc1, and I'll have a set-in-stone base on which
>> to apply more stuff around rc4/rc5.
>
> For the record, Arm CCA KVM support depends on this series and that
> being a big series (around 40+ patches), it is an inconvenience for the
> Maintainers to make an effort to review the series.  That said,  we are
> happy with the way this is progressing and next cycle merge for this
> series would be perfect for us.
>

I saw the exchange on v16 of the ARM CCA series.

I'm going to make every effort for the conversions series to get into
7.3-rc1!!

Sean, for the two attachments you left, did you intend 0001 to be the
first patch in the conversions series, or separately handled? and 0002
will replace these 2 patches (in-place, in terms of order), right?

+ "KVM: guest_memfd: Introduce function to check GFN private/shared
  status"
+ "KVM: guest_memfd: Wire up core private/shared attribute interfaces"

>
>>
>> And if v10 has issues, then *not* rushing it into 7.3 will likely be the fastest
>> path forward.
>
> Absolutely !Like any work, if it is not ready to merge, it is not.
>
> Cheers
> Suzuki

