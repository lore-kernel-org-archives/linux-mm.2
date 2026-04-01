Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 092E710F6FDB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 22:46:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 357166B0088; Wed,  1 Apr 2026 18:46:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 307226B0089; Wed,  1 Apr 2026 18:46:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CEDB6B008A; Wed,  1 Apr 2026 18:46:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 09C046B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 18:46:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A945B16021F
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 22:46:47 +0000 (UTC)
X-FDA: 84611473254.12.0CCD327
Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	by imf07.hostedemail.com (Postfix) with ESMTP id B09A640009
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 22:46:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TnuhYX2w;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.44 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775083605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9YPPgluH5dfl2SzGDQZmCOiPT4mFW9I+aoMhSywEtUQ=;
	b=JG6XYTP3vAfTOfpiIKRWBwmXzA45lIitSJTPKH5LfTaRAVBTSa/JdvvbUqfhG+v0AWcRZ5
	5I0nu2C7ptEhnL7m4r13mf77JTsl0erX1+pvw9ynGZTwFl4X8LA2mKyHLQpPtySlvzeX9B
	ct9gsapheEWkuqYTwuW/G4Dm6cQV9k8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775083605; a=rsa-sha256;
	cv=pass;
	b=vEnPtj//XT91OCvAUp11y95hO1oK6wkG+Robp/acoKBrXcAZDujkawDL0VAsmqgPjKqRpP
	9ADSjQ++PEc1J/7nkMPZ04TQska+LJl21HOZnqBWZ+0Dv/F7Fo4v4ZQUTWDBN0LjmSuYt5
	NiJMLMxKK9rYo8n4xA+kupPM4vhPqwI=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TnuhYX2w;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.44 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-94ab69af6c8so980626241.0
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 15:46:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775083605; cv=none;
        d=google.com; s=arc-20240605;
        b=J6RFRPdRHqEGvsSf7eXs76Og7NCH7bqAbL64fgRRqraoCprOgSjSrPV2HrEG1//ZrX
         atfB563kMHGmMKmCjm0J0P14d10xIk+P11gqguJsV4DFi/IttXEl5EjOUvGJBof/OwQO
         LbuwgujK9hSKBZ3Smh8aWAXxYjqdn4TlSck9KcFHzu4o9VA0da/18UwJNNOSBmt9fbQn
         nQaa3ryR+SiFkMw/YV+HrH81ndyOsHUhWQvHCwvhTytuB4jm/aHmg0yC6QJ9dI0Aq8Z4
         RXNCwYKr9tZO+1qYZRWt04qs5gu08Q5ERhB1jatC12T2pwMvgQIuE6IoqERPQIiG2UH3
         niIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=9YPPgluH5dfl2SzGDQZmCOiPT4mFW9I+aoMhSywEtUQ=;
        fh=1EmKva2OU+UasY91fi/VGdZIH73sAADKGoDPRThmklY=;
        b=iVDPz23UjKJu6W1GkEih4lyRAMioqzgkaB6IgAwklMEh8VPrrXWtLS6MmC91ogUDri
         6DVUDRAxssL+8cn9f4rLK3YOm6w6MaIsy7xmow7pZKRHpC1Q+fzF8cd+LB3VScVkQkTo
         7HyPkIwy3PMkziwnQtyg0adm2/pOtv7/UklVyejBYp8wrBRc01C5c3NsnvvKrd2iL5PE
         exA1DzeJgjYydEfKQneSPrO2X01TDAW6EbVxZ6csFwfedoTB6mrDOvNUZHI6DqL2mLAn
         c5UWDa1Rq3NzmsKu4IC78NrKCRdryD3rJRxCs7paQ3Zdyu4J15VZjS7QKrOsWss1wxSs
         WIUw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775083605; x=1775688405; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=9YPPgluH5dfl2SzGDQZmCOiPT4mFW9I+aoMhSywEtUQ=;
        b=TnuhYX2wiW1II/GEZ3oOK94iGdsH2Z1oQcIVjEefr2nsJLVJiuLFDv3zHbjvcqXvyz
         hcynW0xgeJ5QbMYKQj/7nl9XVB/EyYurAKLK58MQldNdIYBB3y5HEY3wGsU1zeUPDwgs
         9nGmbaePR9ETYOmON9Z/yO+TUfaIkFQ2Hyd+LZL3MIccb4NFp6nKEX8NVMrxZDlnjy78
         c3UZUage+x8vtrY+Tzm7E7oXEIHf64sGgN8/fEZg2rX08+QEVDeXJDUyUIzMWkBdlyC6
         J7Ly0koVQldoCWiXhSwE9/NKU0hXvrY7XwLRjPq+/x5LLxYLYuO/i4Aqrqz1KIehFheT
         fHWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775083605; x=1775688405;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9YPPgluH5dfl2SzGDQZmCOiPT4mFW9I+aoMhSywEtUQ=;
        b=iEzBWsExuP/GBkFvwon9Bd8YYwoBItlPXqQB9P+2NtU4/se2sRDsVOT0qAfxBc9wZx
         ObALI3SeQzgtEmVzF8/FKcX6Wj8qePTLLWwHZaD9c/0aGAZmivr7dwtQ1PGuGQ+IAzhf
         W+VGIFECM8etD4mAti/ZcV3iT1EY+IfBiUfGUYqwJGozXT1TlE07+CgPtGwzhqdxNW22
         q+TuTSl//XYXHuGHX9i7jRAWwADyI/fdO7i9Isb1CBEoq9HgpshNUfJsYqhi7q73BM7h
         3JT2/A+i/1PAaxRu1rN02kN8vU3opnKO6hLKV2y/K4c75JxcMWCJ5nhEUIxvhNAHZFZa
         wREA==
X-Forwarded-Encrypted: i=1; AJvYcCWO5volY1UI4y7kfeWRktpCAdjir0f8a+Z6yj6U2q/4WxHLX5CCz0LiLXNKOdYBMKTAiLxEfBEhkQ==@kvack.org
X-Gm-Message-State: AOJu0YwNMsJEyR7hHNIUyRlNRHsjAlh5sJ0kfs9XutYY6BYIeZDyvgKZ
	wj/RFH6VSGI5TQd9x6+cE0OWfmYvsKplZMQOTlc21poyFslMg3iEmuuKEsFcZpJUlqnmaeJvKlC
	SmIOeOrYfVnrmD7/XvU5eq9tY4pwV0mlRL0SgogSr
X-Gm-Gg: ATEYQzz161LTDPiiA6KD1GnW5Vd6aOZn2oxjPgji74e9GTn2AFD5e2u6lN8EDEBFMds
	YcuczjA7LM0dy1XKmYSxkBuz5zRUNlHQVhwn0Ia32I/UZxHeHfYXi8tMHgx9Bz6biy4dybFNtdp
	3IV1Uvq3Xf0LKZdgUqsJ9f47KTIdBWhjAlvdAYsTQji6bvJMHKAkfJM7T6SjHftyNziSHSnwzWH
	j1NrOen9Y/1HdAz90ft+JfjuZP9wHkdTTS//oU58yTwl+nxj5Hxg4K1F8tkBDt/nuN067KEyIaN
	TgXLmRnhpjv7qORIKWqdXpUnUjmbuPzvpMNZIsb+BdqU6WDDoR2fzxhoa4RfheXiArmcMQ==
X-Received: by 2002:a05:6102:3e19:b0:602:70ca:64ff with SMTP id
 ada2fe7eead31-6058a9eb523mr70227137.20.1775083604142; Wed, 01 Apr 2026
 15:46:44 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 1 Apr 2026 15:46:43 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 1 Apr 2026 15:46:43 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <cqkyz4zxosmev6lnbasa32ed5jjfljrx3gr6plyjfhrtbysuwr@rg5noy6y6ayu>
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
 <20260326-gmem-inplace-conversion-v4-10-e202fe950ffd@google.com> <cqkyz4zxosmev6lnbasa32ed5jjfljrx3gr6plyjfhrtbysuwr@rg5noy6y6ayu>
MIME-Version: 1.0
Date: Wed, 1 Apr 2026 15:46:43 -0700
X-Gm-Features: AQROBzDDCz2wIjIVmNQ0-ajdRi4I1p90A0stJRrbKBWGRj169blHjivIVN8AGHc
Message-ID: <CAEvNRgFgOJj1_WKGrmFfXe8Kg9BrrX7Shmu_cjsEfiq2RP79zQ@mail.gmail.com>
Subject: Re: [PATCH RFC v4 10/44] KVM: guest_memfd: Add support for KVM_SET_MEMORY_ATTRIBUTES2
To: Michael Roth <michael.roth@amd.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: B09A640009
X-Stat-Signature: bo3byujeaqa8jt5hhpbkozssu6zcefck
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775083605-74917
X-HE-Meta: U2FsdGVkX1+6dtS3Ek90ozzuQowdbWFqONCt938QoACNLoNHjfVdls5wPaZ1OM1rqFYHfO3r5sr1/IghLB2FmCpFMPaKek3oI87nhDs8YyWeq8nyAjrXoqYgerrlmMsT+BexEPp7eqPRuyBxjkgDxRur7GU+Pec28+5YCtxlFSi0b0+sgs+vPX12szQ+1KL3rgctq9CMXLqPS4KIhGTVAXZGYKDW+DdvBx47nZbX6qdLZ3y66LT5EEmSPe0lAaUULQtR6Yy20pGyDoB8XvvzueKS604vgjPSmcLZP9i14S0oTv2+jn3cj7vvR4k1S9VX7F0s9cE2sSo9MAGCDLhEXsVc8RWr1ywl8Htoia5QG5V4GGAFlr6RJj+3h+4t3lPnVHCXq53duL0EGipiotfVrjmWMCVuTketIGkEPcvZQm+JwUBQYq5eOd+8eC8TdhUYBgwv4WRVv2Ru6+C0IQNJKA3UCvzWovnLXIgvW6sx7LH/RNvCc73ojk8krHyEXqC1xzXotoOCZhmnlx1+zv/JY+uw9h3df93+vRc4RaTPn3IiW3oT6w9e3MeHGYRKTJpwXMDYxUI21krUmF3rqAAEG+YLxz/EWtZSJ+C8DltbSjBvx78tmnvZ9WmpJMpu1upN/1UB0KoNp1WAD97p5Tfbt9NjhwdFSL5Phqikju5EXmwPQa2nqHPoG9M+6DG+fo/nPQtZQvt2CnN2ZjnJC4BJk+YAAR/9vbpsZBnO3XeEqVBkMFPMQFR9a+WNzEzHoFb55zo6/xL/2Oj8xb8aFhonfCnn5R66se9gY4K9ao+GCAm0hxt7p8G0eMIWLNWay2KcARTNKKCBLkgph+FhFgGUYaNoeGaEbMSfFrtC1GXNYyP284dH5AmZjcDKp2O9MctQM/QZMH08WYAqzI1aAs99pPgHPutwgJW50yH1OvZ/9zgXDA2lBR6NFYgqqxjit+r1QMxb2zT+Wc0cl+npY3y
 i2Tifj2r
 EwKSpANxZcbAlHYwnkU/C5AArIuGY+C5YavlD/LyyrK5A6R3668GSAFHGFp8x5xeATWVdGHb82RA2/7OTAXGaZecW6mNbMfC7h7iYs4h71j1fd0TwU28eYiCY3K1PRQKRBgunaes/yAioiosFi6yCM00MGrJ9a8IlIypHcRTVC7s7ReWCmakUGJNBNVYAXdgN3MqiTa7swc1K3adRHhPj7DFyvjwQzdsaUrO4G0gh5OKHbgukMt4PRa6SlgUYLgMYDbgW3t2nYyH5xriF+V7ITVTiWeOVp2mDorEvmGl1qp1lw3pgh3sUTJHlhNpGHWEC0LCkHOz+iCgHe+9WCVMke7e3MEcWUPXfCewzsk6vfscoFIXy7EGAKOtvtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Michael Roth <michael.roth@amd.com> writes:

> On Thu, Mar 26, 2026 at 03:24:19PM -0700, Ackerley Tng wrote:
>> For shared to private conversions, if refcounts on any of the folios
>> within the range are elevated, fail the conversion with -EAGAIN.
>>
>> At the point of shared to private conversion, all folios in range are
>> also unmapped. The filemap_invalidate_lock() is held, so no faulting
>> can occur. Hence, from that point on, only transient refcounts can be
>> taken on the folios associated with that guest_memfd.
>>
>> Hence, it is safe to do the conversion from shared to private.
>>
>> After conversion is complete, refcounts may become elevated, but that
>> is fine since users of transient refcounts don't actually access
>> memory.
>>
>> For private to shared conversions, there are no refcount checks, since
>> the guest is the only user of private pages, and guest_memfd will be the
>> only holder of refcounts on private pages.
>
> I think KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES deserves some mention in
> the commit log.
>

Will update this in the next revision. Thanks!

>>
>>
>> [...snip...]
>>
>>
>> +Set attributes for a range of offsets within a guest_memfd to
>> +KVM_MEMORY_ATTRIBUTE_PRIVATE to limit the specified guest_memfd backed
>> +memory range for guest_use. Even if KVM_CAP_GUEST_MEMFD_MMAP is
>> +supported, after a successful call to set
>> +KVM_MEMORY_ATTRIBUTE_PRIVATE, the requested range will not be mappable
>> +into host userspace and will only be mappable by the guest.
>> +
>> +To allow the range to be mappable into host userspace again, call
>> +KVM_SET_MEMORY_ATTRIBUTES2 on the guest_memfd again with
>> +KVM_MEMORY_ATTRIBUTE_PRIVATE unset.
>> +
>> +If this ioctl returns -EAGAIN, the offset of the page with unexpected
>> +refcounts will be returned in `error_offset`. This can occur if there
>> +are transient refcounts on the pages, taken by other parts of the
>> +kernel.
>
> That's only true for the guest_memfd ioctl, for KVM ioctl these new
> fields and r/w behavior are basically ignored. So you might need to be
> clearer on which fields/behavior are specific to guest_memfd like in
> the preceeding paragraphs..
>

Yes, will update in the next revision, thanks!

> ..or maybe it's better to do the opposite and just have a blanket 'for
> now, all newly-described behavior pertains only to usage via a
> guest_memfd ioctl, and for KVM ioctls only the fields/behaviors common
> with KVM_SET_MEMORY_ATTRIBUTES are applicable.', since it doesn't seem
> like vm_memory_attributes=1 is long for this world and that's the only
> case where KVM memory attribute ioctls seem relevant.
>
> But then it makes me wonder, if we adopt the semantics I mentioned
> earlier and have KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES advertise both
> the gmem ioctl support as well as the struct kvm_memory_attributes2
> support, if we should even advertise KVM_CAP_MEMORY_ATTRIBUTES2 at all
> as part of this series.
>

Read your other email as well, thanks for reviewing!

It makes sense, hope this captures what you suggested. In v5,

If vm_memory_attributes == 1:
    (KVM_CAP_MEMORY_ATTRIBUTES2 will be removed (will return 0))

If vm_memory_attributes == 0 aka attributes are tracked by guest_memfd:
    KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES2 will return valid attributes
    (KVM_CAP_MEMORY_ATTRIBUTES2 will be removed (will return 0))

So yup, KVM_CAP_MEMORY_ATTRIBUTES2 will not even be #defined at all.

>> +
>> +Userspace is expected to figure out how to remove all known refcounts
>> +on the shared pages, such as refcounts taken by get_user_pages(), and
>> +try the ioctl again. A possible source of these long term refcounts is
>> +if the guest_memfd memory was pinned in IOMMU page tables.
>
> One might read this to mean error_offset is used purely for the EAGAIN
> case, so it might be worth touching on the other cases as well.
>

Will update this in the next revision.

> -Mike
>
>>
>> [...snip...]
>>

