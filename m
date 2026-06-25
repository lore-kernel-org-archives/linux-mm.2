Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C242DCDE000
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 18:20:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E4E76B00C3; Thu, 25 Jun 2026 14:20:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56F0B6B00C4; Thu, 25 Jun 2026 14:20:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 411776B00C5; Thu, 25 Jun 2026 14:20:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 10E7D6B00C3
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:20:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7BE65166CB7
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 18:20:35 +0000 (UTC)
X-FDA: 84919250430.23.7E610FF
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5994B40014
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 18:20:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ExE9HBbd;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782411633;
	b=7yEdP2359fKqQHFpwEx6eSdwY4fXKbcD6IKuyKh5Wfky7FcJNpnEEOa5PfoijWOpF+lPmH
	de2wNCzlx5FWXP1eizxGYTIoQCgknMOx9cKxGfJvbyOaN/8Hc1fXIhXUJLKyI6nrvY/q+i
	XDEf3+rGdvRdMqXR0B0Oa9ptcL7nAkQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782411633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zxjcsz/dsIe56trrVdkQTSG2simPYkWb/FM1GFAid2k=;
	b=T8NdPl8d8GNA9VSObb4MKn/oBsKi/aE55f4jfX1DPak5QWfXPtn1BNSbfvXLY5wwy+kzxk
	QNSLEaI5HafYcJWLkIIj6a+2bKEgYPhvpegLqVtBOTZEke/HSPfQzGm2XCZ/4BCJZ+0R1d
	yjXaNzXl8b4Ej3DMG0h0+92SgdAPkG0=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ExE9HBbd;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=ackerleytng@google.com
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-1384eb94d20so385426c88.1
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:20:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782411632; cv=none;
        d=google.com; s=arc-20260327;
        b=pHpxjn5yCpdvIzBymkeIql30nYzW60ZI0DmVAW/EIClr8wN1YJ+6j1o2Ia5iGUurgL
         l9nwYXpEGKzZme//iPKgHZjVIT8gDVvYVgYhhK1NnVTUUOq5GVmixPbBqUfGTy+h+n8W
         pMXvpAesSQKmu+Rz5GF2fyUz2Rh/pFmg7+m8powvitI/WCJe5EaoYmwHP7YMW4DgtiO2
         uQhLJyASRizWDe8cGTvi8h5YYgOrR+fMO35FOFjd3PKF774LkPwcDG1Qde0th3PB/5hr
         c68rPDpPlpdDMi51SBBK2qA1k/RmskLzMT0B+ep66j5/PzJo60WEJooAQ4EuMz0r08T7
         NfbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=Zxjcsz/dsIe56trrVdkQTSG2simPYkWb/FM1GFAid2k=;
        fh=eNh0e/PKV4sxLNRihHJRBGj1+brEzYcwImr8m7DjUDI=;
        b=adTE0d4Eu1v8Fg9yyM9B3v1VHnMV+1H4CnH0DrFvMUbmSDCJ1Rd+GgL3v74xTxt+SN
         msCS8fdmV2LwweK6xRxZfKttE1NuKynO9AAUgb5vaicpmXxqIZEDQo8a/YUHbHBPcX6o
         /CJuZEmVEUJjOwPPzTamWxOdxWmPbAQ2IHdPtdGSuUrA+braWcH5bF6pvwzM3yxYavxK
         sXfHm8HsHpcDD6PziNrkp7SrhnEShBiQdh4KZIX1zrVvRCUFo0Uz/GD281fSGG08NAsi
         d46BSN5Cb45+vB7tdO6CPFcMoXgT1VgoZ6kLgahYuj96/3WQ3UKrzKcwfmnozIDFABDv
         imFQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782411632; x=1783016432; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Zxjcsz/dsIe56trrVdkQTSG2simPYkWb/FM1GFAid2k=;
        b=ExE9HBbdym5AqY0mPY+a1f8cvIMbeYLA7gwX+hXhwg2xJRrm6jOOwWapEy6aNJMRkd
         SBzX9z7ekqRJX9ixccmUpkqNsd4PHGlvCnaM598VLN+1dQ3XlgZ0ds0Gcv7lr/opxL3m
         RZPfB77KuuneGkx1wK6c9WfWNC6KKLwwFoshLXdTGOPrEm766465oNUS1vZZzWZkBWwP
         55BANADTGYmyoLrfA4CZgvqxX3+o3KUrhtndsXotg+0w2qU1hUQy3+6y2eUEt3cfBKml
         pphRpv5sCumKODcZxAj2AGGBXXbXgVPFDsQkSgFckptb2mKWpllgJod+ws3WK+qjYSxS
         bJGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782411632; x=1783016432;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zxjcsz/dsIe56trrVdkQTSG2simPYkWb/FM1GFAid2k=;
        b=oCIiwiY5WtLqmcF+3Ixvb/KBgMiLRaCy1d/Ob7rHufCn/DYB3HhtqklOcF9XUfLCNQ
         YBpRtVbo4VAdCWZPvRqHVwdauMWp3ubkSgTn1/ZMi0PVMlmcsqGaxZedZIYzwRaVRDhJ
         3eiKnRuX7Cb2Qd7X7Z6OBst0/mt8xU7UML5VAefkMSB4Og0uTcjIximn2jM3q5dEWN26
         AcdIzMd7t3AGcpwBdrquNpKDQsw39Tzgp6HIr1wT0r9EttN9jz+UyJLXbDdGUjiNEJFD
         nkcul0NFgmzkMq+WzWnGaHt2FejOVOPLcqsxz4JW+pAVIteqoTqmT/6POJoIUYGrghLD
         fCyw==
X-Forwarded-Encrypted: i=1; AFNElJ+xFHK2YMAFcq/fy1NgNVBEStTa1NBTCRuHpf5zAl9e7/yDWxkDyJtDnQV8xRxibRdRhy7Kx+6k8Q==@kvack.org
X-Gm-Message-State: AOJu0Yy4oJQt9YHIU2/4/c7rvLmV7gMKnXzHmHdZ3uaRNJ6a+m7GfwLj
	yoCT7+0HgtiX0g+Wl+EM22VC0L9XTrBOcrmmSTVGMNvhJO1hzmmzRHWRUxludViNrhuwf6kxGpd
	j7bxAeH8y9AWRzj3ln01YXzsnNamAlIKkQaP2JSF7
X-Gm-Gg: AfdE7cnZ0nkbBTGPlaUiuUP/PsgIYTowYxjzMRaML4TrKghYNxFEy3jXkUxonKBewLV
	ggh/zHer+1GKkVbDrhk0b76B1waMVrBqkFN+Y/4NdOyA1KymxQW4SPwnCzYY+6m50cOb5smxWjl
	kOUghogRhHmAPctYKIAlni0eExaoAMkpaB3fiWl2hRiE+s+F+o24n7pi/V3Ug3yYDRPbSmaF3y7
	RRGKOxYznoo/erkMV2zGDmiMMixdzu/MJ95Yn14gO3zegXQYhBQ0OgkRm1/Ps3W6QqApUtkv9jr
	P1Zp2a6TAbAx50hgEuTG7QhhwE7ueb4lMxOPzzvkxKx8AIOfH0JGC9f75qE=
X-Received: by 2002:a05:7022:ebc4:b0:139:7bac:db41 with SMTP id
 a92af1059eb24-139dbb49566mr3555362c88.28.1782411631187; Thu, 25 Jun 2026
 11:20:31 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 25 Jun 2026 11:20:30 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 25 Jun 2026 11:20:30 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ajyCn0PnFtQK+Nka@yzhao56-desk.sh.intel.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-24-9d2959357853@google.com>
 <aji/2svhcc84rn5w@yzhao56-desk.sh.intel.com> <CAEvNRgHYTFnHbsLLgMTCSitmnp1_j9Pomikm9qmpGTh1w8YE5Q@mail.gmail.com>
 <ajyCn0PnFtQK+Nka@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Date: Thu, 25 Jun 2026 11:20:30 -0700
X-Gm-Features: AVVi8Cc3nGhX7fIjy0JPI276GPFCp7STu7qOIMKXGadYwwvPojaXnYff9SHGUmw
Message-ID: <CAEvNRgFfgV0FbQLzP8hhNH5hMGaQao6OFQin4cb3TAmC7SVhfA@mail.gmail.com>
Subject: Re: [PATCH v8 24/46] KVM: guest_memfd: Make in-place conversion the default
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5994B40014
X-Stat-Signature: f4bewux8it8y6t88kzf8s5g19497dxna
X-HE-Tag: 1782411633-525798
X-HE-Meta: U2FsdGVkX1+PmIr8MbTBTvPRN52v3kCAu3LneAaqXzDVHxGs1uHNRlyocCWoto8vbk5b5MGR9l0c/3/Z1Cig7cbi/CInhO3Vh7+fHQWHNPdOVPwBNxFCDmfYLcXVksxlZfg0GD2gGsGlnwvcKluCMn5PGnDTYg+XuZENQ2REY8fEJ1QvFI8swCtL8fxIwt3TO0RqctcOobYxclwX30dnHci7t4GhWv52cEBdDVY/kS/nTV21+yx8l1wdg8ggtbueVyexJG9j3UmEWlwS9C4fgUN/br4LT5eEsBUzKe2EEVssama6y19oH6SIPKcLhKhBTNOpWqOvnkwTpct1a++Y90sKMNOjt5ie2WArScYOVpWMatTE1ksVplYnBOoGZVdvbf6bG2Qwv5eQGYXx125ShCl7YNYe30xofPFomf8noZqdmWG0q80jTSKjjw8Sz7eur+AF4X+Hdy/22zLgxdiumji055j200EEopmpCtPTSbyn0hCnOizJwsGt/csxOb3DH9NLEpa73g6k4s52Ys7RKM/5wZxjc0bj1jc9Bs9zgaMLq+1bf/Jh8N6iwbAkEcyjrcvZz8Ux6GUuuI4pIGEhWT4D1RYpf+oKIpJMb2vNASscPbgh42hwOVmIee3ReAW8uAb6FuZXbYR1J9RgUGsknWi4+D+4l1Y1DI40bs1fTHIu5BvoH+uMMlDqy+7GcCDD8pn8+8+3YaDZv26Isvini2w0AIsWLmErUsvKIy4tCZjRlOMOwn7ciTXa6vjwHm7DvlFVFydQuoq+un4d8xIn5Ywh2gdf8kcFXEpg3ZZ0bqA60cY0Y46dutjupQMdtpoXN+alKOOZGeuxhQSyeCbHRA90paVJiXH8EcFmWtva3MGScCIovTa9Gman/zaKXD/ajP1snvPW0PKv1seQkCresl9f/SQiK8L7MY1Jvs3xpu6sy0EFxaTjM8iZ8E501N+lVBySMW4302OUjopScCt
 JKB2VKVu
 tmzKfg1dRbowIVB+S2qoalIxtniviu8kzWEB51AyYXtAWp18T9h/Kd/rLJLTyDQnw9xW4EOAJISu3XM7HwdappKq9ydvFX6HCSbzjLeRG2/30JG43YXRdOn1fAYfXjZV3auH0g0YN22Fou6d9tQmpLmzLD8p2PQ9EdjqbrDdjFxE/fketT447E4qUgMyhqssTTClAvVNNi8wL/xZzVd3UoJ6vt/hGeWPrs3AlpvQPtABHHGO3Or1IUqIDeKzzUo7zVWMQUiQy3zmkyjQSHW21YPk6xE4MoT0b59RRT24yp5dpE6yjEmw5zyV5TU98ebPCwsQe7GdTuHwKXS9XnYa+KmVkLHPOg/V+JvPxu1oa68LpgY4QW4u14/txMO7pLZ8D7Z+UemV46F9MS+ifO6/pchgFKWrvLtBFWmtE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yan Zhao <yan.y.zhao@intel.com> writes:

> On Wed, Jun 24, 2026 at 05:05:44PM -0700, Ackerley Tng wrote:
>> Yan Zhao <yan.y.zhao@intel.com> writes:
>>
>> >
>> > [...snip...]
>> >
>> >>
>> >>  #ifdef kvm_arch_has_private_mem
>> >> -bool __ro_after_init gmem_in_place_conversion = false;
>> >> +bool __ro_after_init gmem_in_place_conversion = !IS_ENABLED(CONFIG_KVM_VM_MEMORY_ATTRIBUTES);
>> >> +module_param(gmem_in_place_conversion, bool, 0444);
>> >
>> > With gmem_in_place_conversion=true, userspace can create guest_memfd without the
>> > MMAP flag. In such cases, shared memory is allocated from different backends.
>> > This means this module parameter only enables per-gmem memory attribute and does
>> > not guarantee that gmem in-place conversion will actually occur.
>> >
>> > To avoid confusion, could we rename this module parameter to something more
>> > accurate, such as gmem_memory_attribute?
>> >
>>
>> I asked Sean about this after getting some fixes off list. Sean said
>> gmem_in_place_conversion is named for a host admin to use, and something
>> like gmem_memory_attributes is too much implementation details for the
>> admin.
> Thanks for this background.
>
> Some more context on why I'm asking:
>
> Currently, I'm testing TDX huge pages with the following two gmem components:
> 1. The gmem memory attribute in this gmem in-place conversion v8.
> 2. The gmem 2MB from buddy allocator. (for development/testing only).
>
> The gmem 2MB from buddy allocator allocates 2MB folios from buddy for private
> memory, while shared memory is allocated from a different backend.
> (To avoid fragmentation, only private mappings are split during private-to-shared
> conversions. In this approach, the 2MB folios are always retained in the gmem
> inode filemap cache without splitting.)
>
> Since shared memory is not allocated from gmem, there're no in-place conversions.
> The reason I'm using "gmem memory attribute" is that the per-VM attribute is
> being deprecated, as suggested by Sean [1].
>

v8 of conversions series changed that slightly, per-VM attributes is
going to stay around (because of work on RWX attributes, coming up) and
RWX will stay tracked at the VM level.

For v8 and beyond, only tracking of private/shared in per-VM attributes
is being deprecated.

By extension the entire thing about using guest_memfd for private memory
and a different backing memory for shared memory is being deprecated.

> Besides my current usage,

I think you can set up guest_memfd+2M for private memory and shared
memory from some other source, and that's the deprecated usage pattern.

> there may be other scenarios where gmem memory
> attributes is preferred without allocating shared memory from gmem.
> (e.g., PAGE.ADD from a temp extra shared source memory).
>

Is this TDH.MEM.PAGE.ADD, used indirectly from
tdx_gmem_post_populate()? This use case isn't blocked. Even if
gmem_in_place_conversion=true, you can still set src_address to
non-guest_memfd memory and load from anywhere you like.

Please let me know if that is broken! I think I accidentally used that
setup in selftests and it worked. The selftests are now defaulting to
in-place conversion.

> For such use cases, I'm concerns that the admins may find it confusing if they
> enable gmem_in_place_conversion but still observe extra memory consumptions for
> shared memory.
>

Hmm but I guess if someone enables gmem_in_place_conversion but still
allocates from elsewhere, they'd have to figure it out?

> [1] https://lore.kernel.org/kvm/aWmEegVP_A613WIr@google.com/
>
>> Sean, would you reconsider since Yan also asked? If the admin compiled
>> the kernel knowing what CONFIG_KVM_VM_MEMORY_ATTRIBUTES means, then the
>> admin would also be able to use a param like gmem_memory_attributes?
>>
>> There's the additional benefit that the similar naming aids in
>> understanding for both the admin and software engineers.
>>
>> Either way, in the next revision, I'll also add this documentation for
>> this module_param:
>>
>>   Setting the module parameter gmem_in_place_conversion to true will
>>   enable the KVM_SET_MEMORY_ATTRIBUTES2 guest_memfd ioctl and disables
>>   the KVM_SET_MEMORY_ATTRIBUTES VM ioctl. If gmem_in_place_conversion is
>>   true, the private/shared attribute will be tracked per-guest_memfd
>>   instead of per-VM.
>>
>> Let me know what y'all think of the wording!
>>
>> >>
>> >> [...snip...]
>> >>

