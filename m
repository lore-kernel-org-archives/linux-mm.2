Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FF2FCCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 12:15:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11BD28E0068; Wed, 29 Oct 2025 08:15:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F43D8E0045; Wed, 29 Oct 2025 08:15:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F24A58E0068; Wed, 29 Oct 2025 08:15:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E08F48E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:15:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5114D1A05D0
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 12:15:55 +0000 (UTC)
X-FDA: 84051048270.04.E80A00B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id D13FB2000A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 12:15:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="CHJ/EKKU";
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761740152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A2LLGcK+hTB7diSRVPmDLBi0AA16yQBkapdsK4RLPno=;
	b=g0lO4iW00AazCGFOlDa0Oh0SNkgGzSRjfJbiID+u0p8wiJzDH0pAFElpd6TTG01PaXODg4
	m8eh5KnggJ9owZ6VRl8TXUjTxcgFptmTsKglAojV9F5h+UJf9xXvZNQzxwqbi+XLZzGWWV
	h8PzL+Heq4G2VospcjrJLOOmjyAj3Kw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="CHJ/EKKU";
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761740152; a=rsa-sha256;
	cv=none;
	b=wZKoOAUdOTecMW59A/4sWn6zEB92si/SVMWCC2B1MQERo6Xy6CtewneIRdNt4xAlxGrlzI
	4uB9tH3EttijphIho6/E/vQE/rPOCbw+zWla90T4p3/q+hbizbSpoYJVijc30LU9j6uAwX
	mQnfFXjiCANY432OyeKjnirzFrGoiR0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761740151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=A2LLGcK+hTB7diSRVPmDLBi0AA16yQBkapdsK4RLPno=;
	b=CHJ/EKKUOueG/YiZzP1oxYa0CWFfbBqBZJVKEEqf6poIeknqzwa0rEGZuszf7g6I5Y1ct2
	ebXFOHj5xRJsPCRCBjmZlriNbE8seBOTR1seWFuzU/ar5S8UXaj/LtflrHCHI1nh1zKyF8
	hLzkNAhSynR8RPwsEqsZlNU1QclxgGY=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-J3eCxuQRP_Sr0BJHWDM9VQ-1; Wed, 29 Oct 2025 08:15:49 -0400
X-MC-Unique: J3eCxuQRP_Sr0BJHWDM9VQ-1
X-Mimecast-MFC-AGG-ID: J3eCxuQRP_Sr0BJHWDM9VQ_1761740149
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8a2594fa114so267190285a.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 05:15:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761740149; x=1762344949;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A2LLGcK+hTB7diSRVPmDLBi0AA16yQBkapdsK4RLPno=;
        b=RMAWHBydMzIXXRsepwtq848AuoUX/xURdZklvYpjsufytU4uAvuORGoOtn1NFe1P7s
         mG5qyTPBrnpA8wsdvgRBuNxjNKYKqOjsNI49fzVqQzRZSDasnuF6+8+1vn08I552+rxL
         0g6VZnjwbAU5UlGnmvhmoDLTqs46kT1Ul6FbUry6EbA2ufi8wiuFDLPx2GygbrFs6C6C
         eyrgl62Dp+NEUFcVIdGRKyh+9d1G4cHKcD7VoZvk1yASJcdeGGCfwRqNDQ+bHJcEOT4T
         cIxEn7LJgfDB8GFEVqH4f3l6qUhVut9mKExw/KAxuTjy0eCYjpM7KmqEW47+dyWIx+39
         fgcg==
X-Forwarded-Encrypted: i=1; AJvYcCWZnHiDgM5dp2MpDdcuHZB8eZPXfsiiXC6Wgh0hMKQlkgARJ7Ea8cjCP4ud3CWyI7e4UiIIX7R+pQ==@kvack.org
X-Gm-Message-State: AOJu0YxsqMs4Yyiy6IDIyfyPf6qMYfebjDQeCTaByx9wpgNycJPbqErs
	AdR0atIMp79ZmUpYyWo+16B/h2q7TPi/VX1O3apkh+K4zx85GpgU0CQNtAmvLIqJ+H9t8FoKxu2
	tAKSgb/gPB1rvRHNeRfDYOuxMLdsx3dz4h69GE8sGfQYT7zfAGbay
X-Gm-Gg: ASbGncuiEkCiSrofwh4nNv3DHCIiAtrsfdpbiMaOnTl22X0jUkg4+9YmEwC1MA5GDeE
	/CYUxJaOjXwaY0GY4Tl6nzopsVs1s7kGREJG77fQolDxrTjat+XYgmXRcGLlXV8ieGTw408K/jg
	FZidG36E05Eal7c+RqPnsk/DDdtT8LAwSyVNrXNNanryVeUt3BzWkO5CCK2lNv3H2eOq+H9MXAf
	NQRUY/i4h9ZMGtalsBkMr0rvOpVbkFc5F3Dif60B1Rjsneilfht+2rUrRpAbcx3CoN6q1y4iGK2
	HnPdguZshKFYC4ylSEXoUQjMUYGTqswQGk6o3icplYigtGNmYvcFMgM1a3JbN7GA/aLPF23TtQB
	jCtWvMA66OMfZH2ztQBmvvQ==
X-Received: by 2002:a05:620a:4629:b0:892:6e93:e029 with SMTP id af79cd13be357-8a7276580a1mr862370685a.30.1761740149092;
        Wed, 29 Oct 2025 05:15:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHyumHWc8S9UaG4uGmnoGLKBMBA0S/1xJaGK1g8R1NYRMtc9AQHCDzfiJJ6iyUcmiHht4va/g==
X-Received: by 2002:a05:620a:4629:b0:892:6e93:e029 with SMTP id af79cd13be357-8a7276580a1mr862364885a.30.1761740148609;
        Wed, 29 Oct 2025 05:15:48 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8a8025fc8cesm328725385a.23.2025.10.29.05.15.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Oct 2025 05:15:48 -0700 (PDT)
Message-ID: <9a8254b9-92f8-4530-88e8-fca3b7465908@redhat.com>
Date: Wed, 29 Oct 2025 13:15:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] s390: fix HugeTLB vmemmap optimization crash
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Luiz Capitulino <luizcap@redhat.com>, borntraeger@linux.ibm.com,
 joao.m.martins@oracle.com, mike.kravetz@oracle.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org, gor@linux.ibm.com,
 gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com, osalvador@suse.de,
 akpm@linux-foundation.org, aneesh.kumar@kernel.org
References: <20251028211533.47694-1-luizcap@redhat.com>
 <6bbdf4ce-10e3-429b-89fc-ef000f118fec@redhat.com>
 <20251029104457.8393B96-hca@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251029104457.8393B96-hca@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1EPL7HVeodZjxYKOXo_1AU-NWP2mvPYSHAI7VLjZxKE_1761740149
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: t1nxp8tnqzukw1hz17bf7rmr41irs6sy
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D13FB2000A
X-HE-Tag: 1761740151-966252
X-HE-Meta: U2FsdGVkX1/u3gib/DTuTzike93PaeRglERXYAnVCAeO2MBeRqGRsZnex+n1zPvyS2EmKqwbXrQYdECJ+e+Ygh519yzRZnnM4vVAv2ytRBDN4v2R6U1qMwpQvN7o+OIgTcqJrbCd/1Z1Vxg6zVgNkRvjvtfJSvHIpiBXw5dsDqaYqoZ8OX1iGUlxe+pGV51CXjE3r1XUBkIOrRUYth50pIDzy/7GOfuLbagPbHtkiWNSrazWW9OJZkfN7qeVC+KabIxiY/SGymqicoN/RIbF7gejfE60hNb58JWMxGvRg2DEzSGQWPPnZ17+XGyXT6rwCyWwHTP5dgnHbCeAJd47U6Ggg6Bvek2l7/3vsAXAxTO2KnM23fO+GCq0UbNkqg1ZHkYWOpc44GFyGufQB5sdvlwOUd8Jx6hnEA+2l3n2QaekL+2X0r7e8i8FssOqPXUGutFqwIwzBOMAekrMFlaipNizpp8gWphOqBQwP2NMOTj7uNJ1SPBV7BAZQ+rQjGZ6KnmGjXBzrVBTCDb+Vscr/cGN8ejgj3QFkPUIbqmyU8OPWQh3gRDDIaG/XohWULTevLY45r9pusThX2SG2m6CnnSIg3M83OapGWE50P4spzJx3VnyTPpGpmDXt1TKckx4EJxM9ux6GwZuNw008cGVaMmz5xTWJk/DvcsRKjhVtVGoeWBURNyEINp2HF5mAgSnd9Os1GWAqkvnfL9fI33uY60ds9uOoy4xMucwnI4caRBvExC19T9vc55VIg8KhJvF4lWPH4nD6srsnpygAyflaGCphdUrkkCPYJqSM8pxU4inL9yjad02c1rVKkQMpHQJh8MXKLPRU8L/PgJ2XTK1UpxUDFL8gflcizMFzM1tySrOM+efYVpOhNb32ySF4cYWxgS0iUK0FVl5eHG20YeNxqNwRu4/NKMfcmRmbgsxligswmM8gNSNu0MZeSot7wHv+dbExyyM91DyAJAg8RN
 exlefszh
 FRxhopCmKHLtyyqwLxj0vTMsrG1DrRnxM437LsInYGhlS4zxUo6RjNUdkl52K8i9Dd/RwKLS/r1Yy+T2uu90B6ApaPv03+0nBCSejCtZSoSCCzXKru9gh7cmGqmFac5ccG0KpidXvxc6IR9k045yXscXKEUo9ib63tIfwdvQ/4bvKF032zhmRHY6OKZJa8LCcCFbChl+pV5aChUhX2+uCw2uz8oDIZoYgsbiVOiLJ8ioennI2ojkWiwt6uE6OX2eZxcIuwlxAgrELD/7d4uXigoSOUzmdmVWaRBIaVy4+qT58BzeMKl8TFhCTWFuDPwF4fiIg5qwVenc9IxKBGIlkWgpFzizxyM3HdWpIoFy+oCEEYumr50COVpyB7w+BanDEv7QQjJT5KDl+hu2S4XwOZk49FxJdD9tNj/1OJHhPF1fRiotN1Yr5FTCl5QG0kwMggx+GM3BPjzLJZ4yeFH5BSd26YYgUtJ3siWgtW+WeesszXRj3HE2vMjDOSPFmQNV5OX23
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.10.25 11:44, Heiko Carstens wrote:
> On Wed, Oct 29, 2025 at 10:57:15AM +0100, David Hildenbrand wrote:
>> On 28.10.25 22:15, Luiz Capitulino wrote:
>>> A reproducible crash occurs when enabling HugeTLB vmemmap optimization (HVO)
>>> on s390. The crash and the proposed fix were worked on an s390 KVM guest
>>> running on an older hypervisor, as I don't have access to an LPAR. However,
>>> the same issue should occur on bare-metal.
> ...
>>> This commit fixes this by implementing flush_tlb_all() on s390 as an
>>> alias to __tlb_flush_global(). This should cause a flush on all TLB
>>> entries on all CPUs as expected by the flush_tlb_all() semantics.
>>>
>>> Fixes: f13b83fdd996 ("hugetlb: batch TLB flushes when freeing vmemmap")
>>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>>> ---
>>
>> Nice finding!
>>
>> Makes me wonder whether the default flush_tlb_all() should actually map to a
>> BUILD_BUG(), such that we don't silently not-flush on archs that don't
>> implement it.
> 
> Which default flush_tlb_all()? :)

What I meant is: all such functions that an architecture doesn't expect 
to be called because they are effectively unimplemented.

Taking a look at flush_tlb_all(), there is really only a dummy 
implementation on s390x and on riscv without MMU.

So yeah, there is no "default" fallback one :)

BTW, I'm staring at s390x's flush_tlb() function and wonder why that one 
is defined. I'm sure there is a good reason ;)

> 
> There was a no-op implementation for s390, and besides drivers/xen/balloon.c
> there is only mm/hugetlb_vmemmap.c in common code which makes use of this. To
> me it looks like both call sites only need to flush TLB entries of the kernel
> address space. So I'd rather prefer if flush_tlb_all() would die instead.

I'd assume that we only modify the kernel virtual address space, so I agree.

> 
> But I'm also wondering about the correctness of the whole thing even with this
> patch. If I'm not mistaken then vmemmap_split_pmd() changes an active pmd
> entry of the kernel mapping. That is: an active leaf entry (aka large page) is
> changed to an active entry pointing to a page table.

That's my understanding as well.

> 
> Changing active entries without the detour over an invalid entry or using
> proper instructions like crdte or cspg is not allowed on s390. This was solved
> for other parts that change active entries of the kernel mapping in an
> architecture compliant way for s390 (see arch/s390/mm/pageattr.c).

Good point. I recall ARM64 has similar break-before-make requirements 
because they cannot tolerate two different TLB entries (small vs. large) 
for the same virtual address.

And if I rememebr correctly, that's the reason why arm64 does not enable 
ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP just yet.

-- 
Cheers

David / dhildenb


