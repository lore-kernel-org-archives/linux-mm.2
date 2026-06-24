Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1274CDE000
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 21:10:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F34466B008A; Wed, 24 Jun 2026 17:10:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E95EB6B008C; Wed, 24 Jun 2026 17:10:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D10166B0092; Wed, 24 Jun 2026 17:10:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A99BE6B008A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 17:10:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2BA241204AA
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:10:41 +0000 (UTC)
X-FDA: 84916050282.15.B39A60C
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id 36CA180019
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:10:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=E+gUxmIB;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782335439;
	b=Wug+OGeG1HbDIdwc7Cyg6l2SORx7p8er0y+OHPAxUlKayfxSx2EI6UfZ0SSMQt6qOfYGzb
	Up/yNWL4wz5VsLN9GQExo/k1t9G9Jr0HK/2tpMwoIsC/lcaQvFsPn9WjJnuiIfsB5fGNJQ
	z+A1xZdnBU3hg1hI1pG0AFem3JEW/Ww=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782335439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1qhY5YTt9otpZBdjhswjpjNDeK/pN32eIQWKDjhQOPw=;
	b=Jes1JaFiYV8ojNQWkVr56UpumAsNjMr1VnzgDbjYEJPz7iLBPb1gk7KKhZl3u12BunMFef
	x2uz61Xn0pAZAPv4jXXD+YBbzJ5dWcu3Wip6jy6VDaTb3JqnTkaYQAyUm7A8XOHpWtU8ZP
	NZ1DbKC5c3rbf3uiBnVTcSPRgcCdh3M=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=E+gUxmIB;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=ackerleytng@google.com
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-13809223fd4so1814835c88.1
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:10:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782335438; cv=none;
        d=google.com; s=arc-20240605;
        b=EnJX/osK1i+DoYPzXyQ0P/JIVKF14edpFFGVivV/ZsrmC9H+9hbP1XNirwPqoAa5aA
         v0FApmfFVhs8J63TD5NG11FPT16/AdISJVD73MYfgX0D+to+IHBqVcwFBsGKhtBm/pp9
         ZK0R/vzv5rEYGBNEkhcJ3QKGEF5cjbIVs2yLN10ZmTUg972cBxLahEqxqczl+C96Pr0W
         X26CJ7KQlUU6FXRuQ9ZZPo8sU7ovoxdcUyJY8ZkjRTq7k6Fb+iw75OoXZQ6jGE7Zjg1B
         GELfZcGte/a5VHF6m6W9ER2gEc2W2qCOoch8b186ZuHkatctsbO8L6dHmF0ByoROUJDq
         8yJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=1qhY5YTt9otpZBdjhswjpjNDeK/pN32eIQWKDjhQOPw=;
        fh=dJqiJ1UYlwzzigcQgNt/9GjjqxFwjL8rEyV5eOMGyoc=;
        b=cCbzeqLEs3ZQhT1wU8TFcAk/YP2WIoi5rj0QTaZ4lof7AtF4GFtbPLYyPTEDRCCC+c
         JS2zDcSs8A6WCjwHXbv/GUMAZXgx2saZ7l28KEDtykAcnv74Z4OJ0q0Bd6hpb6EKaMAG
         7b+vRyl2HQ1uidvaP19DbR2a4SCnRCFhr1xnuSPna40r+fZJAEOFtqSTqcAmlJhJ+aL/
         rU2S9lWt3ouDjVHP4TQEzaikKNKaotQPnlYf9LgG/d9cfm8vTcYfvFdl4EyCk2hjYc4M
         9X6b+Pc0GAjvNC/jphI1xfee0mgX+bSZiJFsFAltf95IKKDGgjLTugkI5m0iShd0qUZU
         P+Qw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782335438; x=1782940238; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=1qhY5YTt9otpZBdjhswjpjNDeK/pN32eIQWKDjhQOPw=;
        b=E+gUxmIB5t6wrGHP9ULJzToY6Qkeyjje13ZmTaY83ozrWDf2pfcl4pBSZpBwxTTQTl
         HRyAMc4G5vPYY6Ikhk6RA8sZYU61OFDUpo+8wAs4tYW90TO59MNFavInBdHoCTeiprRK
         zWeq6MAmr5UQ2yhEBPRpXCJEsrNGBjAs2HJVZZdhPwOxsIIMJuWfKUucIduf2w1Xc0Uh
         y7xWzr7heyK4W+4gGqhm7LAi6TFX5ducFlZ86SAfTluC3sMmpEIvhoJukkThlaTLOgN1
         ziYtFFhetFmf2qs23OaYgcA2es6L7EASKGuJgokBk7hrwbh/HqIixtmFOVHME3ooogdI
         MrTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782335438; x=1782940238;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1qhY5YTt9otpZBdjhswjpjNDeK/pN32eIQWKDjhQOPw=;
        b=emlJo9JkYj+xuJAWHjYXrsr9mrQSUZPGzZ/zXc9Pd2ORo/R3UKHbV8qebAEBQESHvH
         KAwUnGNxAxc1BLpF5klWRSJgOaR6wVCYORiKDMzjlzJeSfIo7XjpI00V85abG58Ih1sZ
         bSu3IqDKDL6WfrMy+FeO1imrPqtxFBgBUj5U96LeMcNtCx7Scb8phxXI4U48kNn1v2tD
         88uTGSirbsNKnqFavXDwaXq30A8k7unvxLQ4mWf1WQ8FpDcxNEw7NxytlU5xHi6qzZ3Y
         WAla1D3RkA7RBWpT8ufDrKTSGKOEuPSEz1MaWNutFXG97uOHkRjKkLdXuxsGVgSAw4LB
         WpSw==
X-Forwarded-Encrypted: i=1; AFNElJ8VG1jjAsgP/Gcrj1I9qy/712Df2isSNgjjxKh2wn+m6SsMQo3iCT8yIDiBa620GiU55ugKVISYxQ==@kvack.org
X-Gm-Message-State: AOJu0YySl5Jl8inAz8P5rTluT1O6w9XfngunKUa1xk6wdnMPeUB9nX2z
	RlgluxJcPYQdCGlhHDNllA+26yZOE6rCoV3lofnkPM4hUIulhAGXWXRuKLHfCiWk/wOS3hB1Wmu
	BBJ5aa5mIEPXx2VCCJtIUmhEZ6jqMjZyRyRVbMoZ9
X-Gm-Gg: AfdE7cm3VhUAXEZyG+q5l3Ni0Tu1ztY5ouwWQo3/xQB07KEmlQWjNFF4eJDeUM+9S9B
	D1wMep8pnNbFUMrG9glrY8PyiBURy11EbiRZaUNgupQg0Gh7yXHHNnTPr5p2TTUSF362PwRYz47
	oaajRyNhE/0ApHqJ1HKwrOZ0REvCb1053dENPAMvIIz2Vm5RiJDBTNEXibnbznchcO22il0K2zp
	KJH9HbWwTADDfYmUfJaIOiEFXI7XtZ0uG4o/B0IbLNvgbBg9mSduy5P2Ep6rLajeuCCHKjFtAly
	dj8ThajzCdPdDKb99dQz4H88ZYpNExi5AniF5NPtWU/tZwMv64EebOLc0PM=
X-Received: by 2002:a05:7022:ec4:b0:138:4e1:4701 with SMTP id
 a92af1059eb24-139d0bfe4c6mr3377918c88.7.1782335437124; Wed, 24 Jun 2026
 14:10:37 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 24 Jun 2026 14:10:36 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 24 Jun 2026 14:10:36 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ede86ac4-d560-49a6-82d6-b33ac5fc9355@linux.intel.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-13-9d2959357853@google.com> <ede86ac4-d560-49a6-82d6-b33ac5fc9355@linux.intel.com>
MIME-Version: 1.0
Date: Wed, 24 Jun 2026 14:10:36 -0700
X-Gm-Features: AVVi8CebnA3rqvCzlkQD0wA3EY7nvdb5mQUucCUu-AjWUK6m396TQ3uUDm-u_rc
Message-ID: <CAEvNRgGWwfWZbvXxBAKHxc3DYVGzDo8TYtii+8fVnJNtBwvCqg@mail.gmail.com>
Subject: Re: [PATCH v8 13/46] KVM: guest_memfd: Add base support for KVM_SET_MEMORY_ATTRIBUTES2
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: aik@amd.com, andrew.jones@linux.dev, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, liam@infradead.org, 
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 36CA180019
X-Rspam-User: 
X-Stat-Signature: 6ih9cnc7m786g43ohw6ncmdihtpot4h1
X-HE-Tag: 1782335439-248738
X-HE-Meta: U2FsdGVkX1/kXSn3YKJ7gXDlAFZwHyV/yKnVdInFFF+Yuz+po/mUdQ5A9lZPAE0IayWTcUfDMzzOwmGja2TNIoQQqC+o9nfVQbYGqenXGFdUNYiz+HrZxlgmGWG+LvRPbwaefbH3rUKQ/t4/Y28tqOpDzg+uuWCg7VhX7qordrOq/O9gZrloUX32tnTYdFjCDm68vu0iFjS+Ii9uPhVzi2EigXvvXZF/CRdDIqFGFmd1ziyB1W/RqgDQ83HCrZC/jUZeGFICDY8w/4oMtWac8vJAkUNJpkmobY+EQ3FMQhs1pQpOLzhOCWmkqDCI6uFPm9U9Sf3fMO6gVVy+SBvrUk+vACkm+h2RXqi+7o/vzy3ZD3aSdeaIZYMJY8zSQPJgEi6qqexByp8y2oD6Oqa1YKEathx9q3oTjJtfADmeN+ILazZ4EWRLknu9lOQNCAnvpdXTsJC+T9NxU5Uz9oWqm5PavE7CG87BIpa9qw5a3Dd38HiPiaiiGdQs3d52wbCNVDHf4xgE1uRsBvZV4WHtxKkLU3Dox330U1KIqKCgv9PzZ5VvBOJQL2SaVy+vHp36u45tRr53fSwPg9qsOxI/KcRin6Y5FOC61ivnFThqXyldyaBOWEul/wSUlTm2NvDCQBNxGy79Wx1p6blZlo74Mp48Tt5U65pjCGB/b2d8Bp5MSlzrfBiRAtZE1hV0CvdwW4UunTGYuEIFeWejoVFoTjw+nUPLAOal0ePTgdLHALBEdGstXngU+32TelBXIrOelo72UsXUfUWC10qcfgLjaMRMF2QuaVNa6NLKYX1cXlOoQjnI4Czl5E6sPkrhQTCxinGqUJeWcvlMBZt+o152JabeldDPyTeuteFKJ4Skl0i4ed0tyLuIv7ly37okiP95Zr0rqbBzAq4ALGUld0zv+fuABt/RM43R02wJsqw0JmVCyxR6NcwQGm7pRlIXmywZv8oOyKYpHyO9E4433Mf
 YX+v7ErL
 ujxCuuKBG0lQTnNW67pQucbOJIC0///Ro8kbh+ZLPyA9+K4AOjAoRdYV7i/LvBijnipm+QRvOaogWqzPZ41aikc0OKnE/v3iTLt1ZaF6EvbXuXPrYkm4YQS/ozLLsWSjHJgNPEAUuaxnaMSrnpxmSbGLIEpGr10jr+k2gHx7LZSTDYY39J9xejScTTSLv2Jwhigygvk/zUbCpdGaC1xOCtxkWEtX+Z9hqPxN4pRRynp0MqsSMVnorqYP1Y28jiwenrocq88ooBcTLkdqzJ53F7+s+rJImccdYFDtfGZJ/5ZjadTzqAFn2OmUlNtJuCcGFsPyXFj7XDnTi4d/5r3hIqFapoI4Pv+Ev2hkXLdSTdnqkzfFdsvfL5za3hdGqhp2fJrf1+9wp/W/qSYQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Binbin Wu <binbin.wu@linux.intel.com> writes:

> On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
>> From: Ackerley Tng <ackerleytng@google.com>
>>
>> Introduce base support for KVM_SET_MEMORY_ATTRIBUTES2 in guest_memfd, which
>> just updates attributes tracked by guest_memfd.
>>
>> Validate input fields in general. Guard usage of KVM_SET_MEMORY_ATTRIBUTES2
>> by making sure requested attributes are supported for this instance of kvm.
>>
>> A new KVM_SET_MEMORY_ATTRIBUTES2 is defined to support writes (unlike
>> KVM_SET_MEMORY_ATTRIBUTES) in addition to reads so it can provide error
>> details to userspace. This will be used in a later patch.
>>
>> The two ioctls use their corresponding structs with no overlap, but
>> backward compatibility is baked in for future support of
>> KVM_SET_MEMORY_ATTRIBUTES2 and struct kvm_memory_attributes2 in the VM
>> ioctl.
>>
>> The process of setting memory attributes is set up such that the later half
>> will not fail due to allocation. Any necessary checks are performed before
>> the point of no return.
>>
>> Co-developed-by: Vishal Annapurve <vannapurve@google.com>
>> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
>> Co-developed-by: Sean Christoperson <seanjc@google.com>
>> Signed-off-by: Sean Christoperson <seanjc@google.com>
>
> s/Christoperson /Christopherson
>

Thanks!

>> Reviewed-by: Fuad Tabba <tabba@google.com>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> ---
>>  include/uapi/linux/kvm.h |  13 ++++++
>>  virt/kvm/Kconfig         |   1 +
>>  virt/kvm/guest_memfd.c   | 116 +++++++++++++++++++++++++++++++++++++++++++++++
>>  virt/kvm/kvm_main.c      |  12 +++++
>>  4 files changed, 142 insertions(+)
>>
>>
>
> [...]
>
>> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
>> index 297e4399fbd49..cfa2c78ba5fb9 100644
>> --- a/virt/kvm/Kconfig
>> +++ b/virt/kvm/Kconfig
>> @@ -102,6 +102,7 @@ config KVM_MMU_LOCKLESS_AGING
>>
>>  config KVM_GUEST_MEMFD
>>         select XARRAY_MULTI
>> +       select KVM_MEMORY_ATTRIBUTES
>
> What's this?
> This config is gone.
>

I'm surprised this compiles... I'll fix it, thanks!

>>         bool
>>

