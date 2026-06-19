Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03329CD98F6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 10:36:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97A396B0088; Fri, 19 Jun 2026 06:36:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92BB36B008A; Fri, 19 Jun 2026 06:36:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CDB66B008C; Fri, 19 Jun 2026 06:36:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4BD2B6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 06:36:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 90C621403A9
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:36:35 +0000 (UTC)
X-FDA: 84896308350.14.882896C
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9F10180009
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:36:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jT1RseEn;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of tabba@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=tabba@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781865393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YuuXVoQ2ecZDLg/Pv4tnmec6MwmZ/WlSis1mzF80Zmw=;
	b=4aO7tiKajR15hflDotJ0yN2Ul4JF1y4S8GoC1+qusaBO5g42HeRnbaWkVBftvsVOQt7haC
	e2kTm9kKp6q9+nqXBQzgjIabOz9vcQ8RVP3v9IxY+BsBnbcd9f9pjOrLOoFtHnhvJeKFR2
	3jj4hvf9R7VDJkatZyocp/jszFw7fxE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781865393;
	b=pKcKOZoeB4KHe07gONZVJ4d1fOC8JZ4uYBdi0wwhQh3lrnBmuMxOWIGtlMJhk3EXRX8Gb1
	X+aaHD45KMESMXPFd8+0u3fUTxXGXTlsDsaDfLG1soRSGAM5J4BcNKMifk/tPEcPQhV/66
	WrK8UliyyXDDrzbAGTNJYmsHiRsXlx0=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jT1RseEn;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of tabba@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=tabba@google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-519ed52bcc6so131071cf.0
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 03:36:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781865393; cv=none;
        d=google.com; s=arc-20260327;
        b=j5oHnfcon0Y56oTIFiwVA2+73Vq+oJtVrI9MmkGyX8DJg3JStEYbbHqxRxtnTx+o3H
         dPpbsaQ0CJDNOLvWR3wC+G7FRDDt8YYTpXi//Ts52bWIE5U59G7qJpRaRV8DSb5CKSWp
         xkKcR0IYlUhw1aeWdHhaVOvXyCvzKoxrXipnFtExDlhGBKRQECp9fRVga6gVGXvsLgf1
         mFT7aRKFy0Afa079BY/FNkA8tcY67lqDEAfPRVb9oyZLTb94kPfuZHI2SUBtfNaM0Bff
         QiFYAenRBjairAUKZiEAbEvy598uXMJQzZEYnygfFqvDdbpRopOquoI+vurN3Z02Z5W7
         fheg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=YuuXVoQ2ecZDLg/Pv4tnmec6MwmZ/WlSis1mzF80Zmw=;
        fh=T2eKNazLyJiUDuIkd13GifZfA5XGYko46dPWJgZNjNE=;
        b=sSx9mFjeQ87zU3EAjzGk5zA2SCTkT5jx6+wa2T05hv715e3oRL0X7+LFGVl9Pkojr3
         HRVTIzHTjtPOm9Sehq1a59P2bqS72BI44KBviRI2qhHW/4goVm9r5ivvdWzlDE0yFNFK
         qMYnMQUILstqSpkniOMggviYP3wyVxvQq8plXjPOI2FIUaXkyj0jYntwMqVtTKF7FK6Z
         oGbhZrk8f0JicXRkcfVtk/gqjLQW/Gfe3AvO5EAyAxJMhhUOf7ORlWPmdFnm/g007Os8
         8SHjo04b4N8i9teiQNOgKx+61APvEBoe4htCGJN9lFUyKSBm8nFp/FoonGbsqLM2ZQFZ
         Fe8Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781865393; x=1782470193; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YuuXVoQ2ecZDLg/Pv4tnmec6MwmZ/WlSis1mzF80Zmw=;
        b=jT1RseEnO3mH5Ng/tOL4A0/r3d5ThZdISLsLHn8PdSYmJp17b+yrwvqMzi4Ht/GOPF
         NGorwZ1c8448ZHIHi/UUMnu/8vsKElhvg150CEJMMpMgXgD5X0YxqAb7s2eYsUvavORG
         msUwrLhfuhZTa6pBlU1dVKCPQhq5Ky9AKtLAAidnzi/YUVtzX02hkKn9JMfTOu+2vYde
         QbzSp2Zsr/Zqz+7gZQUPCiVAfUfaBNF74NVDhRZAhNHkaavIk8xXFLFEOagI9oTonwku
         BcmtOXxh61zR3LoZoeo0PestoJMw0raxUZ/sCQeqhBkROaDu3/SP2ZSsCs3ZJSU66OvK
         I4uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781865393; x=1782470193;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=YuuXVoQ2ecZDLg/Pv4tnmec6MwmZ/WlSis1mzF80Zmw=;
        b=GdXkZHaIuUWUJSqXjeanVMVRDSGJN17YIuciljMjUPsNPyN/940ySrfPK0OxcZs5lA
         HK+AuefxkSFY9tY7PUqTW1UxRB3GfgSHpP83mEPb9bz812Bx8kcQPOE8DwdlsH8CT6d2
         Sa4dpyadYRz1Pf5aL0x09Bxy4+tBmA+2YhiWVn+wLUTgpwaS973WUiNEaGw2iyg6at9q
         UFS8QULSV6z/+XrHZWD5z/ymQFXqNQjjwIXUagdeLrVgiuksNDeBX2KCuKNFPp0JEsHA
         gAKnDUrQ4JK+h2qcjzB8qGyNh7PJKMzpZe+1VsuhSOYv5JwmMqEZd7G7/COM+f1U++yh
         kc/Q==
X-Forwarded-Encrypted: i=1; AFNElJ/WegtkJ80ma+KX3Zwfe8XF9k3L9RlzqCXyl7fK08jCO1sk4RSM35ip38N6z1MRYebLKY5GqIJ37g==@kvack.org
X-Gm-Message-State: AOJu0Ywx5DzcM3JQz4s7GHK/nYWkTVQP9kCVrEO3pEOFoXpjx/5H4zlW
	DPg025wHmjHM+5E9ngEzPyp5POJ7hmRQdN6O4tpnV9PFlVcd4/d3ljUXO9Vl/fAcIzgJ7bSj1CK
	mzOZ5FZvddNlWNSRMkDyGdjWLcJQL30DsA9tCA9lB
X-Gm-Gg: AfdE7ckxVmhjlc67dfF4zRwtDij36e9RWEl8/Tyg9SOzFk6k8OV0K1pVPKrPY90EsuG
	0wdsJuJqTUHeh1v9SluITIWb5PRX5zqurEHzV1+9Hrmmk0Q0FDtxSTHdPM31J21j8kW8cnCNQC8
	NFxR+aenh/ofyQZ1ulAJN1CA33DayVOS8aYZAl2vn51u9DXiCtZKcwzEsG/odulGOg11RKe6e/j
	p26gtbORxGXCYkYugAowOi7ueiYCZCKlrNCsYTKjDg0ebchB3uRMfvTUamF62MnMT4zm6r2TQ==
X-Received: by 2002:a05:622a:82:b0:50f:ce97:3b84 with SMTP id
 d75a77b69052e-519e48867afmr7169791cf.6.1781865391025; Fri, 19 Jun 2026
 03:36:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-17-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-17-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 19 Jun 2026 11:35:54 +0100
X-Gm-Features: AVVi8CcjKXQn8ypCrAeWLOhyWs6z3Z6iNQ-s7Ah4piPeXrrDDhzORiMG-WJ9jpU
Message-ID: <CA+EHjTzZ0GO9fspPaTzruj8331+ShEZmg2PF2AczcwJ94VvgvQ@mail.gmail.com>
Subject: Re: [PATCH v8 17/46] KVM: guest_memfd: Advertise KVM_SET_MEMORY_ATTRIBUTES2
 ioctl
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
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
X-Rspamd-Queue-Id: 9F10180009
X-Stat-Signature: ycr5749utuh8scao3u3mcqskz16usrhi
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1781865393-393978
X-HE-Meta: U2FsdGVkX1/Bxsqk/AUHVz4dNKhwS7NfHEDOGQbWDuzLMUL1T/+tq9TrkzUFsv74VpfDuTiJ+6mUTdEzdritTTWKTJMUVJFo0izx+Qa2YVQBudb2WMLXxd4ysxmLjP6IBz2mW96efKwezCDFJjE99fFwStBZbi0nvJStJQhx8rrwXWUYjtFZfY/fdriWDY9sMqs7Jcb+Q5lnYqXrCmNXAHgzqf4wWvr97dORMJ3h+TWo4NkmNWEahOYvfw32DXKfOBVFsOBcGTxDvyX+TF+mwiCjo65Ir76Glkyb+q0Y8j6H1fG6KI+ZuDhl/WapViJ0DzZcUnUniJoG4fQzVfyWvhnf2zVwj3kby5T/eDJztOpqS4JtfFsq4u2QxbwjelLLWqGo0SjDgHD/JmLL+IQRBn9gygUJzoXO2WbV4vLlJtnrhX9EFqEcTkms9jZmCbVvPTWNXxgUBnzIGx0oOr4IdS7iuNmexfgjp8L7vlwAr4GWkdvZITv1GofdQRxo0xVdZJkWldYl1LoCwfm5D+mPvTCqbAdNHwkRAessu2y7+7GEZzx/5rd/tYs3s09jvpaVNU3AFnaMFKH8bn6NAgcqZCZO7YqI14A4ErA0j09peR3uFkcl+P4A4A5dZNcFt8rxrUtwMXx60/79prgMSLenl2HdY1+GfExlYDnN1+kfaMqCRJVf0tavlalAB/z/J1hnVGpZjR0XcRhSIiPiY3SMHm0l4HutSxhKUtnfOdYC9swXfLGJ8tYohssMYxqie2bjNlq8TZO2BTi4MtjH/q6PjIJn8KSlOmqlc0vB//1whmt0PFeiJ5/8IByJkE9V4fAxsb7CSWkOVwfeIVg0eoDukd4/b/7nG3PQCYRBfOf8y8GTvQUCh8toSgJ0xh7uO5yH73ge1bqRWqMgXifw7fBDt/N0gD7oiiRLxmeRdN8J6zyB6qehqCGnlIo/IPVnGfe7qNIl4SrQMnyisyTktHn
 QI4qM8+P
 M5AXFEg1T3tf9EkkGVUhihk35j8UFCZAGJ8qRjAzs1m1YkpWceJyDDoBw0kMqaAJZK09c9ll/Uvf3gp32MUSiZszzkWLad5vb9IOodKhtR4xMJa6Q3VE3Vvb5PvPIdj/jFV+2wnG/zW+F31jjecEU0+KHb7qz0VmGEYpTLeaAUJWXhhN5vDI7kVH1v4GWM0vimhoAfDnsr7dyO5qAD2rAX49uOZWaGNPRXQw+H+/sdDZhYV4K89OaZxGYk9AriwGidmN0LwQs32afPlfCz+Ko2RsKKur1tCO2eGzwizqk+6Ul4rcAvX0MbTZ6ugJU21gDg/63ARyx9r3lwlMZFKvZUffina62s94y7C20
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Jun 2026 at 01:31, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> Introduce KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES to advertise the
> availability of the KVM_SET_MEMORY_ATTRIBUTES2 ioctl.
>
> KVM_SET_MEMORY_ATTRIBUTES2 is a guest_memfd-scoped version of the existing
> KVM_SET_MEMORY_ATTRIBUTES VM ioctl. It allows userspace to manage memory
> attributes, such as KVM_MEMORY_ATTRIBUTE_PRIVATE, directly on a guest_memfd
> file descriptor.
>
> This new version uses struct kvm_memory_attributes2, which adds an
> error_offset field to the output. This allows KVM to return the specific
> offset that triggered an error, which is especially useful for handling
> EAGAIN results caused by transient page reference counts during attribute
> conversions.
>
> Update the KVM API documentation to define the new ioctl and its behavior,
> and add the necessary UAPI definitions and capability checks.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Suggested-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad
> ---
>  Documentation/virt/kvm/api.rst | 78 +++++++++++++++++++++++++++++++++++++++++-
>  include/uapi/linux/kvm.h       |  2 ++
>  virt/kvm/kvm_main.c            | 23 +++++++++----
>  3 files changed, 95 insertions(+), 8 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index a833d90845b95..73878f34f6d2e 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -117,7 +117,7 @@ description:
>        x86 includes both i386 and x86_64.
>
>    Type:
> -      system, vm, or vcpu.
> +      system, vm, vcpu or guest_memfd.
>
>    Parameters:
>        what parameters are accepted by the ioctl.
> @@ -6373,6 +6373,8 @@ S390:
>  Returns -EINVAL if the VM has the KVM_VM_S390_UCONTROL flag set.
>  Returns -EINVAL if called on a protected VM.
>
> +.. _KVM_SET_MEMORY_ATTRIBUTES:
> +
>  4.141 KVM_SET_MEMORY_ATTRIBUTES
>  -------------------------------
>
> @@ -6566,6 +6568,80 @@ KVM_S390_KEYOP_SSKE
>    Sets the storage key for the guest address ``guest_addr`` to the key
>    specified in ``key``, returning the previous value in ``key``.
>
> +4.145 KVM_SET_MEMORY_ATTRIBUTES2
> +---------------------------------
> +
> +:Capability: KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES
> +:Architectures: all
> +:Type: guest_memfd ioctl
> +:Parameters: struct kvm_memory_attributes2 (in/out)
> +:Returns: 0 on success, <0 on error
> +
> +Errors:
> +
> +  ========== ===============================================================
> +  EINVAL     The specified `offset` or `size` were invalid (e.g. not
> +             page aligned, causes an overflow, or size is zero).
> +  EFAULT     The parameter address was invalid.
> +  EAGAIN     Some page within requested range had unexpected refcounts. The
> +             offset of the page will be returned in `error_offset`.
> +  ENOMEM     Ran out of memory trying to track private/shared state
> +  ========== ===============================================================
> +
> +KVM_SET_MEMORY_ATTRIBUTES2 is an extension to
> +KVM_SET_MEMORY_ATTRIBUTES that supports returning (writing) values to
> +userspace.  The original (pre-extension) fields are shared with
> +KVM_SET_MEMORY_ATTRIBUTES identically.
> +
> +Attribute values are shared with KVM_SET_MEMORY_ATTRIBUTES.
> +
> +::
> +
> +  struct kvm_memory_attributes2 {
> +       /* in */
> +       union {
> +               __u64 address;
> +               __u64 offset;
> +       };
> +       __u64 size;
> +       __u64 attributes;
> +       __u64 flags;
> +       /* out */
> +       __u64 error_offset;
> +       __u64 reserved[11];
> +  };
> +
> +  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
> +
> +Set attributes for a range of offsets within a guest_memfd to
> +KVM_MEMORY_ATTRIBUTE_PRIVATE to limit the specified guest_memfd backed
> +memory range for guest_use. Even if KVM_CAP_GUEST_MEMFD_MMAP is
> +supported, after a successful call to set
> +KVM_MEMORY_ATTRIBUTE_PRIVATE, the requested range will not be mappable
> +into host userspace and will only be mappable by the guest.
> +
> +To allow the range to be mappable into host userspace again, call
> +KVM_SET_MEMORY_ATTRIBUTES2 on the guest_memfd again with
> +KVM_MEMORY_ATTRIBUTE_PRIVATE unset.
> +
> +KVM does not directly manipulate the memory contents of pages during
> +attribute updates. However, the process of setting these attributes,
> +which includes operations such as unmapping pages from the host or
> +stage-2 page tables, may result in side effects on memory contents
> +that vary across different trusted firmware implementations.
> +
> +If this ioctl returns -EAGAIN, the offset of the page with unexpected
> +refcounts will be returned in `error_offset`. This can occur if there
> +are transient refcounts on the pages, taken by other parts of the
> +kernel.
> +
> +Userspace is expected to figure out how to remove all known refcounts
> +on the shared pages, such as refcounts taken by get_user_pages(), and
> +try the ioctl again. A possible source of these long term refcounts is
> +if the guest_memfd memory was pinned in IOMMU page tables.
> +
> +See also: :ref: `KVM_SET_MEMORY_ATTRIBUTES`.
> +
>  .. _kvm_run:
>
>  5. The kvm_run structure
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 876c0429f9d4e..129d6f6303251 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -997,6 +997,7 @@ struct kvm_enable_cap {
>  #define KVM_CAP_S390_KEYOP 247
>  #define KVM_CAP_S390_VSIE_ESAMODE 248
>  #define KVM_CAP_S390_HPAGE_2G 249
> +#define KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES 250
>
>  struct kvm_irq_routing_irqchip {
>         __u32 irqchip;
> @@ -1649,6 +1650,7 @@ struct kvm_memory_attributes {
>         __u64 flags;
>  };
>
> +/* Available with KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES */
>  #define KVM_SET_MEMORY_ATTRIBUTES2              _IOWR(KVMIO,  0xd2, struct kvm_memory_attributes2)
>
>  struct kvm_memory_attributes2 {
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a08b518cdb175..044486f128c37 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2434,18 +2434,22 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
>  }
>  #endif /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
>
> +#ifdef kvm_arch_has_private_mem
> +static u64 kvm_supports_private_mem(struct kvm *kvm)
> +{
> +       return !kvm || kvm_arch_has_private_mem(kvm);
> +}
> +#else
> +#define kvm_supports_private_mem(kvm) false
> +#endif
> +
>  #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>  static u64 kvm_supported_vm_mem_attributes(struct kvm *kvm)
>  {
> -#ifdef kvm_arch_has_private_mem
> -       if (gmem_in_place_conversion)
> +       if (gmem_in_place_conversion || !kvm_supports_private_mem(kvm))
>                 return 0;
>
> -       if (!kvm || kvm_arch_has_private_mem(kvm))
> -               return KVM_MEMORY_ATTRIBUTE_PRIVATE;
> -#endif
> -
> -       return 0;
> +       return KVM_MEMORY_ATTRIBUTE_PRIVATE;
>  }
>
>  /*
> @@ -4969,6 +4973,11 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>                 return 1;
>         case KVM_CAP_GUEST_MEMFD_FLAGS:
>                 return kvm_gmem_get_supported_flags(kvm);
> +       case KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES:
> +               if (!gmem_in_place_conversion || !kvm_supports_private_mem(kvm))
> +                       return 0;
> +
> +               return KVM_MEMORY_ATTRIBUTE_PRIVATE;
>  #endif
>         default:
>                 break;
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

