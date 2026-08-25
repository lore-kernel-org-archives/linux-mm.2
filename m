Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7BE2C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 04:22:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8594C6B008C; Tue, 25 Aug 2026 00:22:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 809ED6B0092; Tue, 25 Aug 2026 00:22:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F9096B0095; Tue, 25 Aug 2026 00:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 35C626B008C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 00:22:22 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ADB3640312
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:22:21 +0000 (UTC)
X-FDA: 85138494882.21.27E27BF
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf16.hostedemail.com (Postfix) with ESMTP id B005C180003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:22:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pgeH7PFY;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787631739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ii2UjzWdYQBWun6iRfgoLkq7AXK2AM7SF1lOo7W5lmk=;
	b=uUKfROSn7yvJMmRaMFaYP64B/yrrvz/uXm1flWANwtiHfAZQwYswNhUgdpN4V46Do5AKWW
	8nvrymWDzUipkTuZ+TKjUbb9McqJJ9Jz/7bthZbR5ZHz0fOJcePXHVvRUcwOYruwqIi6kX
	F2VvsUlTQVJjSnw42YvEpBR+4oy9g4s=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pgeH7PFY;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787631739;
	b=Rfq15cdpithrk2/d6dFlytSgFa5JZIoUU5SCRsARdTrN5nLFNu+o2YVqmAE7lwL7u0+uOv
	AfL/MsaddN8w7g8lD1z6kceQnm8oD7HE8/fZ/YWQsE7+9zVwdf6/Sg9H1YBtSEHfbb3YYZ
	e+bEo4UiUXRF5fVI8Fhs2rrr/gAEPjE=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c96c92c0980so2559463a12.3
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 21:22:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787631738; cv=none;
        d=google.com; s=arc-20260327;
        b=GNj0kcGHfiv8WJTn8T+2NnPuCpF2Hm+8o/sGrbHI/bSPh90/LDWWmin0dhIycRYIAR
         YVgMBUvj668697wwtl6/Jj5dFqEZgQk2eNbxsGwk3q5VJfTXW4dN+zp/4vafYP3mUd/t
         2Fv0l9HVCP1CYSseRildcOgLZ2n7uCfVqEvBz4/Zws+6JVujDdIAjLnUHZttBSK2mMtl
         1m0R89a3QG2c9XNMNwBG3xxKgMUpjkE8AMCfyRpChL0dFkb+McoylbZC6kWh9DTlER6G
         Oqk+VkBTYJNJ5c0Fqr3UrRIYftnBPYdqOVaXvJrYemxxoWw60ckoAiScMcp0aqeGYs+O
         jXPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=ii2UjzWdYQBWun6iRfgoLkq7AXK2AM7SF1lOo7W5lmk=;
        fh=XzAoJME5ZnL6IsSddksKufQI9RMrRvDKsTC9Cm+IuGE=;
        b=LZ1aX0dUjODLE7Y1Om+FR4PbYusBeVE4bbdmrT7JSM0JTabKxMwYSU+61L6/pMmPWa
         i5c34NdVBARwCb7LEv+rXGmjgWbFXpGLyGeRjpi2VdYaTEEMI+U1iBrJvD3q/YUdW1HH
         1+BnQGMBK3mw3uh+SALxM1yTiEzJFXs1ht03Xw9/zORUzQJaE/gqm4nhFPGZDrTUAHme
         g2mh4KDWiW6ZIy8G8DFu4Go3X+m47U8cGtl64E+tNhNEtWPI60kdiUp0629i+lmMJ4c6
         jEg+SaaYlAVyyyvpNTdGbYYEqF2yrELk4PQjFxjiLWlk/w3E5Il0bNiFtzeiOptdzIyM
         Kugg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787631738; x=1788236538; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ii2UjzWdYQBWun6iRfgoLkq7AXK2AM7SF1lOo7W5lmk=;
        b=pgeH7PFYPZkPuEMT4xDX2NTXJj3hJA9mSvKw96FXMMz9/K0kRht//6pogwVl7pPKKd
         JHaLRwfVXbQnqvKpKiu2vHrLwF+cK4sykOCR5C3dV6dgV4ocm2fDbrP4FmH2Fq1iTdMU
         WDt95mP8u6AYOIm51ljvKhrg/5qaTSuetqZ2iyud2qYBuLm8KkQYroQQlaH+F3/qeTST
         y6sXeRiZKNcHr6j5uEtiKQypykLvY+DbXipo0RBcOu8bOgKpuU5kb1o1QOl9jpnNMT9w
         KjDQkNIZmq1vrkK4/I8wT2AjbOSReBj9or8WmTFg+dahpn0i+X16PzQ6RwECh9CO/fqh
         UexA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787631738; x=1788236538;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ii2UjzWdYQBWun6iRfgoLkq7AXK2AM7SF1lOo7W5lmk=;
        b=nSsV0pYI9ei/OENkvMVGs8J0rMijBMb3+AD/QXivAu9DI/pXKGfS/VbQk+9mv/+YV/
         aG/0GKRJP5ALZYyPm112fCfsCJIVxr72oMfGg1B+FylLcM0hUbzETF3yF0x4N7MxpiBc
         5PIc2J3LV8BnceLeSAEW8ZFln5QyZYzM77sWB6nrfMs2KUvzx3+knhDK5TE/STOhotEY
         3tOnpD2cBo0nD92IK9gGZp4yeQK84MCdiFwekuQQmxY1RQQcVuny4Rx8106z8ADV86OL
         5yqgWSJXqmvKUZN3wEuA0FOy7MKpI8UKKfqbsotDkPaLNyIztMVL1qwzQudb0L1bQnen
         onqQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro9wsXtudWKVL9NxU9egnzgj0UaRSesGYUWAQDXzq3oK5fx7v+/bzPZzrMJ3FjoxA6zsvuvleNe5g==@kvack.org
X-Gm-Message-State: AFuF++kYE1p8ll5poJVfWPNmX0kTopTwN4J/k8FJDKP3jx4lyjl4+dP3
	V+MGMwtA2cutsqjiriW+sdJcmxP3Oq9F+Vz+gXKNuinPZy47W5PattLilM9fhH0roBVJLtY4TZt
	z3xWvuMXjxsRbG9HOCBbVaeN4DYuxa6cICMuW53wD
X-Gm-Gg: AR+sD12eeSCwqR0bM+5FaIQRKx1p5pH+fZIrE7cQuajPdHJWVqK96ODsfpHQo0VHi2q
	/TcZ+8Xrm0gmUmQ6Lec8tFACD99Mym2dUrVRpeFEj7GTfsWJi8D3eFOWfAtGDh+xwaey1ufMfWB
	2xeE2Abum02sLnsGUvu9ZbjY3W0kx8/j17v51C3ixlNO7bXTx2Hfgc8Askfzlf4Vo2TatJFtBv1
	NMTA3XnIih5M9FZzZmMUXJ0fBtgyMU2qDBoSKY6vbWncJNnDwLlshIgMNC5CfANc2ILzV/hjUjV
	QI5UQoRyW5yT0NhwBFxybfuV1I1KcieJYZhJGTYcq3y3k76zR5kMu9xibXSUbPS9EhCEtpuj6jL
	vtn+Ijc4VVikRnehmc7A+9mrBxqnlFp4=
X-Received: by 2002:a17:90b:37d0:b0:395:4de9:b30 with SMTP id
 98e67ed59e1d1-39646350ad2mr7583961a91.5.1787631737593; Mon, 24 Aug 2026
 21:22:17 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 24 Aug 2026 21:22:15 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 24 Aug 2026 21:22:15 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <54d1bd0e-c27a-4033-ab97-02cd9579a620@intel.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-7-2fc18ee6d3ba@google.com>
 <a410cca6-0776-44af-8353-9b7375e2fd4e@intel.com> <CAEvNRgGvxMus6pp=xuDYOumH3Ge4oi0=YKjTaFykFHwXuzRDwg@mail.gmail.com>
 <54d1bd0e-c27a-4033-ab97-02cd9579a620@intel.com>
MIME-Version: 1.0
Date: Mon, 24 Aug 2026 21:22:15 -0700
X-Gm-Features: AcwNN1WQy8t54bcd0rpO36nvPxS3ceyAlSt6scpIWjMhQZqgzc7w7cgeUX3ASbs
Message-ID: <CAEvNRgFhjbgC9Ng1qviPx4oE=qihUwiBcsYOgJG3yOU-nLG1hQ@mail.gmail.com>
Subject: Re: [PATCH v10 07/41] KVM: guest_memfd: Stub in ability to enable
 in-place shared<=>private conversion
To: Xiaoyao Li <xiaoyao.li@intel.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
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
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: B005C180003
X-Stat-Signature: sz47p866s8meuz4y77apg7ac8qutt7pq
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787631739-495619
X-HE-Meta: U2FsdGVkX1+YSr4xDQYrT7bgUeYlRZZ1GXsmUT1mInQ4csg1hrgWMvO+R329ucjHzDjeucBR1EQpe+7GAXEzHMglGDvRN65nKt3bkvZK3K+krRKn9kMdpRDAI9hGr1xPR7JvqUGhgvhNjENJ3tGiBNAcQXAgjfObclCOvSy/rYD5n+uKVX/D+QIvyTC+WX7rXFD3JrMZA92pbuC6l1RxwgkWTPC+mrxaVpECbnrYmXxBaH5772NZPvov/LbM/bbQ7uWMOe0f+6G4Oo1DjqY9biNFHnN219+RaNyHVE5rOT2QEhHdDs23EET4RLUWyRVzj84ZEpNqTQIqDxLkM6eRhI4LsA2IJisgrmycAT4QB1nRR/hSafTQyyn1uvctQT6c6u12PK67/I+QoxhauJYjWSu8NsgPc0DFU384Xk+Fx2iLxTYA4ekpdZXS60bhuWJ/GHddDpp0ghURpQpWjFv9moLuKQpBkIzejB27z3TXE7OIhWxjx1wfNMG8gbBuYJUUqJqRF4QMoPslhip/sOnaoYNXX/ndxnxzETJv7kMd2V6jcS3pDb6MJDWLVO1/S+QzsWaPAZ4XNKG1WmLm0tG/FpQbu5USe/XCNLckbitY2HKCZt67FupKAgXoWpbNDc+EznRGrY//jpf5rDzlfOhZpVBjPM0knUs/PjBmhb38g6txuoAoCdceH0QiRZ56GbVUypxbfQklYSx+7Bd0CCsALQ428UMJgTVbN0mJQ0Eb2RdYoqorNkQWwL4zDiohITXIXzJ4eOgcX5vw9O01IZABUScm+I73AgiD6MLH5pVhwMNzvIwuII7WNYkwHfvV6iG44t541cRXqBpphnivNIUdwNHKiWK7VEqehv1das/AyGKx5PSyL9D2zhmjZhhmj8FzB0vIXAV9qbs3yQ6XtMQJ6NuDJApRWn4aSox3rhHc8TcGn1B8eBNYxYbUW5GWVtNlmQN0VM8+WRX+Q44V1ES
 ERBai/xa
 xvKL6PwreqPS2wUKctMq5r9T4PsV8vcCY6BGPxEFsjGgF3msdZDIgd2IY7iUGWleU4RzjX/Af0qbFCtnjgs3LYhDhQYo25bSz6XJn2MywJu/annpwyhhw9FBm8wFNi+BDUh3UAdMfooYWHizH1fHRrpPd8YVje0x/GdWgpXmB4qygZG/AFRVdqkNP23OSJDcSWBTlPvX9YIxrCSAhNDrD2X+hzXlVsxBoh0FqR+QIbSn8c7LhSn4Nvmmv+7ezf2flg9EV1fPW6w57Oa85esLtn5w5wlq9afISBlrQouevVMT5gYXDbx2W0vp+9GlQeRm4YDhk+G026oI4Fa+mKzPzddDvChuJF5ZgnlGks8xWdVnLr/Xhaa3H8cWMBt5q0wNGWlLQnxWg1WNm3eg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> On 8/24/2026 10:45 PM, Ackerley Tng wrote:
>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>
>>> On 8/8/2026 5:52 AM, Ackerley Tng via B4 Relay wrote:
>>>> From: Sean Christopherson <seanjc@google.com>
>>>>
>>>> Stub in global variable to enable in-place guest_memfd private<=>shared
>>>> memory conversion, which will eventually be exposed to userspace via a
>>>> module param, and wire up the __kvm_mem_is_private() static call to the
>>>> guest_memfd version when in-place conversion is enabled, i.e. when gmem is
>>>> the sole authority on private vs. shared memory.
>>>
>>> I find this patch changes the default memory type for a @gfn.
>>>
>>> - When memory attribute is tracked per-VM, the default memory type is
>>> always shared.
>>>
>>> - when gmem_in_place_conversion is true,
>>>     - if the @gfn has no memslot, or the memslot where the @gfn locates
>>>       doesn't have gmem bound, the default memory type is shared,
>>>     - otherwise, the default memory type is determined by the
>>>       GUEST_MEMFD_FLAG_INIT_SHARED flag.
>>>
>>> I think we should document this change.
>>>
>>
>> In a way it's not really a "change" since gmem_in_place_conversion is
>> set up as false in this patch.
>
> I agree. It is not this patch making the change but the patch allows
> gmem_in_place_conversion to be true.
>
>> When it is enabled in a later patch, another way to see it is that the
>> default remains "shared unless defined as private".
>>
>> Before:
>>
>> + no memslot, or memslot not bound to gmem => shared
>> + memory is shared unless VM ioctl used to make gfn private.
>>
>> After:
>>
>> + no memslot, or memslot not bound to gmem => still shared
>> + otherwise, ask gmem about status, which I think is already captured in
>>    the module param concept.
>>      + The very usage of gmem (without INIT_SHARED) is defining memory as
>>        private, I think that is already documented elsewhere when
>>        INIT_SHARED was introduced, that now the default is private.
>>
>> So in summary, I feel that this has already been documented in various
>> places. I'll also add the following in v11's "KVM: Let userspace disable
>> per-VM mem attributes, enable per-gmem attributes", in
>> Documentation/admin-guide/kernel-parameters.txt:
>>
>> 	kvm.gmem_in_place_conversion=
>> 			[KVM] Controls whether KVM enables in-place conversion
>> 			support for guest_memfd and tracks the private/shared
>> 			state of memory per guest_memfd instead of per VM.
>>
>> 			If enabled (the default), KVM enables the
>
> I think the default is disabled?
>

Ah. I'm thinking of the state in the way that we're deprecating
non-in-place-conversion. I'll drop "(the default)", since the default
depends on the CONFIG flag.

>> 			KVM_SET_MEMORY_ATTRIBUTES2 ioctl on guest_memfd file
>> 			descriptors and disables the legacy VM-scoped
>> 			KVM_SET_MEMORY_ATTRIBUTES ioctl for private memory state
>> 			tracking. Only the KVM_MEMORY_ATTRIBUTE_PRIVATE
>> 			attribute moves to per-guest_memfd tracking; other
>> 			attributes remain per-VM.
>>
>> 			This parameter toggles KVM's in-place conversion
>> 			capability support.
>
> I start to think that the term "in-place conversion" seems to read
> inaccurate. I think it is describing the shared/private conversion of a
> gfn, and in-place means when a gfn is converted between shared/private,
> the backend comes from the same gmem page, thus in-place. But KVM
> doesn't enforce the "in-place".
>
> If "in-place conversion" describes the shared/private conversion of a
> gmem page, then "in-place" is redundant because the conversion a
> specific gmem page is always in-place.
>

Hmm, a few people have raised something related to this
gmem_in_place_conversion module param's naming: Xiaoyao, Yan, David, and
Sean's response is generally that it is confusing, but can't find a
better way out. The main consideration around module param naming is
that it should be named for the benefit of the admin. We want some name
that admins can understand at a high level (for some definition of "high
level") what this does.

Do you have a proposal to resolve your concern, considering naming,
documentation, comments, code, etc?

>>                       Whether a VMM uses separate backends
>> 			or out-of-place memory management is determined by
>> 			userspace VMM design.
>>
>> 			Note, this parameter is only available when
>> 			CONFIG_KVM_VM_MEMORY_ATTRIBUTES=y. When
>> 			CONFIG_KVM_VM_MEMORY_ATTRIBUTES is not set, in-place
>> 			conversion is unconditionally enabled.
>>
>> 			Default is Y (on).
>
> I'm looking at the doc of KVM_SET_USER_MEMORY_REGION2, which reads
>
> # When mapping a gfn into the guest, KVM selects shared vs. private, i.e
> consumes
> # userspace_addr vs. guest_memfd, based on the gfn's
> KVM_MEMORY_ATTRIBUTE_PRIVATE
> # state.  At VM creation time, all memory is shared, i.e. the PRIVATE
> attribute
> # is '0' for all gfns.  Userspace can control whether memory is
> shared/private by
> # toggling KVM_MEMORY_ATTRIBUTE_PRIVATE via KVM_SET_MEMORY_ATTRIBUTES as
> needed.

I'm not sure how this snippet from the documentation connects with what
you'd like changed. Let me know your suggested changes across
naming/docs/comments/code to address your concern :)

