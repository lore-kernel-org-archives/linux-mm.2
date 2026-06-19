Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53A61CD98F8
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 09:25:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9C706B0088; Fri, 19 Jun 2026 05:25:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4D326B008A; Fri, 19 Jun 2026 05:25:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3D336B008C; Fri, 19 Jun 2026 05:25:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 83EFB6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 05:25:56 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C3160402E0
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 09:25:55 +0000 (UTC)
X-FDA: 84896130270.20.8DAC5C2
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf22.hostedemail.com (Postfix) with ESMTP id D8282C0003
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 09:25:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=c9jgqcFG;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of tabba@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781861153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=urVcLx5BPkCCi6p3vFYGwMdjBtbKpYO1ZXkEN7UqG9M=;
	b=IWQ+vk1OebWAwtcUf0DARxX1P8Ryk5XStlrr7oZWILFK0cKDoSLbZrEgVRBfrDHT6Fij7G
	cucHtIzjSn6kNWKdtJeF3zamIk7v5u6LbTkAkyEWig2iaX/x6bCDGebwgKFtzT2nnEF9Mu
	2wwYoEwL89wzMzvAEwOiXzW2/NA3+WQ=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=c9jgqcFG;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of tabba@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781861153;
	b=efkCdUykIQJ2u0rV2+uJt/FUZ0ZKy8ZVJQltPI0q9qj8aUgbcsO1XId+7eR8+mhrrVb8kN
	nbevo+8sJgSVWNu9eg2T3VbFMpMGQJf8LVwI6Q5kcYkCS06266Y/tCcGCQR+gw+I0a/FaE
	hQz2bJPX5cRHgNoPusyn8QmAQGz0N38=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51765531803so213491cf.0
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 02:25:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781861153; cv=none;
        d=google.com; s=arc-20260327;
        b=TOV68vhJJ7LtuFur0R9v5ObYtCkRmEVRykaPrXtpljfXeFRDMl8IYek2Uxp4qzu44q
         SgoaMs/Y8XK1qmFg81hi6jwfMXJaNk7zqTFR2NlApeik2efrWtFGN2ijROglk4Z7gzZA
         W7txrWA8vciQniaytohJCM1JTPIHHkZocH6owL+72vsqLoHaurbKBP3d5ozN/JgsGOxP
         A6hbH/WlK1Ruuvnd0BpJQynitN/XDcypos2uZ4f2EEm3vU/LBKpCFldyMX1ZdIPuQRvY
         kg1+26dGxgUqtx5FkBza6QXLrRxFpcHR9fg6TW+I3qZbkpbS0kEisgv7kv4CQ3c9xMMp
         MLsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=urVcLx5BPkCCi6p3vFYGwMdjBtbKpYO1ZXkEN7UqG9M=;
        fh=Qe7TPqra8BfH5Suq7u/qq/D0ep8GYWeMeGC0MmkhymM=;
        b=SvjHjXXLDxiSr94t92uOj0T1wBwIZfRJwuGKVPwSkoJp6kbtS6qj/WynDavfRv6Kea
         Wi2pjbqRde9bkBdAb7i4TxftPQ2sQ/ufzLnXZtYFIYICS8p3FEcN/qtQDzXQ6BCepKoX
         dghfJEq1ZblOOD+4izTY/S2XE8Ehndgigy3ZbW1dWcSQL9K4FtSzkUM55q6RLiUjZjWh
         z3ZRLsNjJANZHprQHjRhAk0JXqBOq6iHn0+UznYg1zGFW3Rez8KM7O4W5yisjIRUd+su
         6+WgUpYLjpkt1nGyfjizuH+ZmMjGdeEXa+Jnt9inxTAjPVuj1XH9rZ0F5DshB2dm49wy
         OCcw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781861153; x=1782465953; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=urVcLx5BPkCCi6p3vFYGwMdjBtbKpYO1ZXkEN7UqG9M=;
        b=c9jgqcFG9EZrMaaUrnqBuGB2+O6/jIcTzkguf0HInUOYocA1F//5HQLnQ3pei6w5J6
         FM0hvy4Jo4OqLbJEMsrrf5B4BTXAV+ID/SWNKlh8VVhiD6JavwEKtw25iSkiOfeXTlbO
         iPwWV49XcUo2hyv4B9NBo+E20folFkx327O9kMnS7PmZjSDZ/1LNlHrT0PHiIl0umdrW
         Ej9qbPpNmCArEWXHl6j0CXcYaAkYhaFoabz2DVl3enVJyUefzk5tbUTfixeMSysaD3zb
         aIvJSNawrHVXxXPD8TxA4dSXsRzphHAxlirsMxFPuxfbeD3NDdeJoRsGlR1v5Qbf8FJ7
         UZ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781861153; x=1782465953;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=urVcLx5BPkCCi6p3vFYGwMdjBtbKpYO1ZXkEN7UqG9M=;
        b=Ft0UMTlcSz3VSV258CzBKZUsYyCoq2cAvwZUqIPdEHs8WnqQxKj6yhRHXtWcnAxFJJ
         fvoJY1Llgrn8C+uhYX7ckJyjBrExWpwGYVGlV1jpzTgYZgNdqPo7PJya6VGNRzo1wopC
         km+bIQie22XujcMrkeZnuIemZHfjJPQFnQlAeKI3mEAph/J0Xi1vwCYc3QwkGPdNmMi5
         sZ+15AQMa+wOYOQLQ5z8GdIzbG+mY8wETXhJd7lpi+ykQf8MFftR/8o3RSuumvdUvZ5e
         sSLYNFW0ze9/RcPPZqpLjoVjxpBe/bxgFUeqpWxkJEtWnRg6rGrt4pnlgSQDyzMlPtiA
         On9w==
X-Forwarded-Encrypted: i=1; AFNElJ/5l5Ir4jcngRXKoVdjSPUPolyJlb7lza9tFuZSna2VtlGvMnok6M3aLiPhHsWgHaTHxAgHlSHtvA==@kvack.org
X-Gm-Message-State: AOJu0YwHVV6x1BgH5SvTcJUILIXY+dmtAxSlXMpO6HRdD7Lq9ypDz2f8
	/IFWfXyDbJgmK6DPf2whNgIu5QYUA024gYQ1irnJ+CMtiJCdHx8p+q1STVQhFHf0IYbklMomAit
	JNe+e7vr1K6Y4cT14lcq2yIHsQiWuhjEOB0DhEUVr
X-Gm-Gg: AfdE7ck45TXIeXoXvMzz9OyVB5T8icNfvE6QcoEbJezAIIUm0PW4NdRelv2MjGIEksD
	/8ET2l0C7HQPPxq452F9dhGtg0yW3ExtvgRSV0kTsYPvq9jtxTcPh5XlaJVc6BjEut1LPRHcsTo
	6PCDm9wkHMmqwUiQR3377ElbqOAkix66spnJ/JdzI5DlTXiqqxMsl+4B+AYctVElahDuZp+SgHv
	IRORlqcLj6d3dxAZO/OsPcT2rXVGFlkvW7ALwWZg7tE2WbEehnaNJpWgqhKS5nqhVyq3fLeUQ==
X-Received: by 2002:a05:622a:4186:b0:516:4f62:85eb with SMTP id
 d75a77b69052e-519e4a74a8emr7841591cf.22.1781861152102; Fri, 19 Jun 2026
 02:25:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-13-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-13-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 19 Jun 2026 10:25:15 +0100
X-Gm-Features: AVVi8Cepq97zo_gQa9J80U8EU69NTSVdwN_TrW1pA3rg2sfSJVKhF_cpG6CcVaU
Message-ID: <CA+EHjTx2xKjheiW5VzHw_TdWFUqdJqfgu=dOPa=_yaYBMY8uyw@mail.gmail.com>
Subject: Re: [PATCH v8 13/46] KVM: guest_memfd: Add base support for KVM_SET_MEMORY_ATTRIBUTES2
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
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D8282C0003
X-Stat-Signature: 8mt3ib6ob4ffxo4388gazwqetsedjyk8
X-Rspam-User: 
X-HE-Tag: 1781861153-996773
X-HE-Meta: U2FsdGVkX19HjVQzp2ewu6eJcqMEnlCbwdkcsTLq/EI8K5g9GmKjyx6SPBdvCohds8vr/wJ4ZfCRUE8zZKr0iA+s27oyfIuqLPiHzkYHE6isK/Zz0NoanfaMm+z3gVDejV7w/viXmRR5CMS0uWX3vSrUfZBK61XmGcpS8IiTfBWpqBgQFbDWy6zFgbbwwu03754BnP4lvSmhc3w7gO047aFITrqIcW94mDzRuUTxvRazgncnzxP15rEUb5am8R3GKEBLNYftZ1B+Bp0vwd0KWHj/kOF5UTaezKskADOsy7KXlvZfvpx+aZugV2CCt5qd1rNZoe1TDnI2TgRX7d4uSAB50qItEFZHUn8WEnBkaeftY6GXccOmyitM0dZNcs3+qTMuF4G6YMvpvv/6wur/NnYTs0vVJIxK8cwPcvdAgYGcwwX+qzxRN5DJIX0bwjrD0Oq8AgcZ1V8wYQ1XhJFShBUlOvXbfVe1DM/i+4qnMoJT0yx1wzJsnxJYxxViK2LHAgVn5200iy8SFhtPUbcx2tM0v9vkH9v2RpjhISYvFELMuUg5T4CM/PufLC2qyEJKne5qgpz8cVuu6qxcMcpEsDcM3XcVb5QnR45fqMdbn3QRaKOdl89OEBBYHm3kNPp28jHIb0iHiyojB/nRV2rWZldzmVarM+cHOGcdwW6FkjMvJz9Pp609InYp0kBJ8snLYDFiMkVz/VUhugBYiWHXixIJhqsBcU4TwC44ZtndZvpvCxUCdUKKFURktL/olFgXLcINDJPRlG4Y+ToXE9gsKFicm2itk/S8FzP8t0WqbplKhaL5OWtuJUEU2aaxBfVcnHKY1k/34Jm4fHUPOHhz452dsj5A0FlrenzdUFVKvU0zVSRJ4uJhLASZ59v0nOAXykXcZZIlSfy2jx00Wxk0+mf0wnDryfo8AaoTz51SFItVcTQjVIAeX022VQpZyUCIxM33KAWHHo7RiVf3+9s
 7sBkMpea
 J6k3/MuYEbuKJ7nYc9DJyX/kTryIdzZ3OArrk2ZBX+XcK4F8T8jyVv8gnkS8SzRhKavpBuBL3f+cugsusONBykHWjLjDVilT0TDOaBhylg3mqwBMxAj3WXJJMwr/hFHW5rqO+/AgDlXAtdGDCyDUmbNiZPtXRm8tWfsDjSs9k5LhU/1Au2U82rO7+aKmUmqmYcVbPC8kwCDmJUJSwPdLKdSgeUM5xZ5FB/ZgvtiuGraw1JowVYVFRcGCWM66plhqh3RgLoenXWYdtaIHYOPAfYVvjJixUIPpTYluPnQ4faUzy53D2ocs5Yzet7C/zLheGm5UCOLn6M4fAkmbwd6FOn2OwXGK10lDKPy3QGmVLhb/H4h/US72VMUI1WmisRAMu6q1SgOdFaOI8ixMRk4wfCF4L6XBFwNMJIYq9
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
> Introduce base support for KVM_SET_MEMORY_ATTRIBUTES2 in guest_memfd, which
> just updates attributes tracked by guest_memfd.
>
> Validate input fields in general. Guard usage of KVM_SET_MEMORY_ATTRIBUTES2
> by making sure requested attributes are supported for this instance of kvm.
>
> A new KVM_SET_MEMORY_ATTRIBUTES2 is defined to support writes (unlike
> KVM_SET_MEMORY_ATTRIBUTES) in addition to reads so it can provide error
> details to userspace. This will be used in a later patch.
>
> The two ioctls use their corresponding structs with no overlap, but
> backward compatibility is baked in for future support of
> KVM_SET_MEMORY_ATTRIBUTES2 and struct kvm_memory_attributes2 in the VM
> ioctl.
>
> The process of setting memory attributes is set up such that the later half
> will not fail due to allocation. Any necessary checks are performed before
> the point of no return.
>
> Co-developed-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> Co-developed-by: Sean Christoperson <seanjc@google.com>
> Signed-off-by: Sean Christoperson <seanjc@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Note sure if it's user error on my part, if I'm applying this to the
wrong base, but I found a build break here on patch 13:
kvm_gmem_invalidate_start() doesn't exist in the base tree. The
function is kvm_gmem_invalidate_begin() here. The rename
(190cc5370a8b6) landed via a different merge path and isn't an
ancestor of the stated base.

Patches 19 and 20 have the same mismatch. Fix for all three is
s/kvm_gmem_invalidate_start/kvm_gmem_invalidate_begin/.

Cheers,
/fuad

> ---
>  include/uapi/linux/kvm.h |  13 ++++++
>  virt/kvm/Kconfig         |   1 +
>  virt/kvm/guest_memfd.c   | 116 +++++++++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c      |  12 +++++
>  4 files changed, 142 insertions(+)
>
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 419011097fa8e..956877a6aab05 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1649,6 +1649,19 @@ struct kvm_memory_attributes {
>         __u64 flags;
>  };
>
> +#define KVM_SET_MEMORY_ATTRIBUTES2              _IOWR(KVMIO,  0xd2, struct kvm_memory_attributes2)
> +
> +struct kvm_memory_attributes2 {
> +       union {
> +               __u64 address;
> +               __u64 offset;
> +       };
> +       __u64 size;
> +       __u64 attributes;
> +       __u64 flags;
> +       __u64 reserved[12];
> +};
> +
>  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
>
>  #define KVM_CREATE_GUEST_MEMFD _IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 297e4399fbd49..cfa2c78ba5fb9 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -102,6 +102,7 @@ config KVM_MMU_LOCKLESS_AGING
>
>  config KVM_GUEST_MEMFD
>         select XARRAY_MULTI
> +       select KVM_MEMORY_ATTRIBUTES
>         bool
>
>  config HAVE_KVM_ARCH_GMEM_PREPARE
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 65ce795c090d9..0d14548c1ed22 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -541,11 +541,127 @@ bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn)
>  }
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_is_private);
>
> +/*
> + * Preallocate memory for attributes to be stored on a maple tree, pointed to
> + * by mas.  Adjacent ranges with attributes identical to the new attributes
> + * will be merged.  Also sets mas's bounds up for storing attributes.
> + *
> + * This maintains the invariant that ranges with the same attributes will
> + * always be merged.
> + */
> +static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
> +                                   pgoff_t start, size_t nr_pages)
> +{
> +       pgoff_t end = start + nr_pages;
> +       pgoff_t last = end - 1;
> +       void *entry;
> +
> +       /* Try extending range. entry is NULL on overflow/wrap-around. */
> +       mas_set(mas, end);
> +       entry = mas_find(mas, end);
> +       if (entry && xa_to_value(entry) == attributes)
> +               last = mas->last;
> +
> +       if (start > 0) {
> +               mas_set(mas, start - 1);
> +               entry = mas_find(mas, start - 1);
> +               if (entry && xa_to_value(entry) == attributes)
> +                       start = mas->index;
> +       }
> +
> +       mas_set_range(mas, start, last);
> +       return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
> +}
> +
> +static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> +                                    size_t nr_pages, uint64_t attrs)
> +{
> +       struct address_space *mapping = inode->i_mapping;
> +       struct gmem_inode *gi = GMEM_I(inode);
> +       pgoff_t end = start + nr_pages;
> +       struct maple_tree *mt;
> +       struct ma_state mas;
> +       int r;
> +
> +       mt = &gi->attributes;
> +
> +       filemap_invalidate_lock(mapping);
> +
> +       mas_init(&mas, mt, start);
> +       r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
> +       if (r)
> +               goto out;
> +
> +       /*
> +        * From this point on guest_memfd has performed necessary
> +        * checks and can proceed to do guest-breaking changes.
> +        */
> +
> +       kvm_gmem_invalidate_start(inode, start, end);
> +       mas_store_prealloc(&mas, xa_mk_value(attrs));
> +       kvm_gmem_invalidate_end(inode, start, end);
> +out:
> +       filemap_invalidate_unlock(mapping);
> +       return r;
> +}
> +
> +static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
> +{
> +       struct gmem_file *f = file->private_data;
> +       struct inode *inode = file_inode(file);
> +       struct kvm_memory_attributes2 attrs;
> +       size_t nr_pages;
> +       pgoff_t index;
> +       int i;
> +
> +       if (copy_from_user(&attrs, argp, sizeof(attrs)))
> +               return -EFAULT;
> +
> +       if (attrs.flags)
> +               return -EINVAL;
> +       for (i = 0; i < ARRAY_SIZE(attrs.reserved); i++) {
> +               if (attrs.reserved[i])
> +                       return -EINVAL;
> +       }
> +       if (!kvm_arch_has_private_mem(f->kvm))
> +               return -EINVAL;
> +       if (attrs.attributes & ~KVM_MEMORY_ATTRIBUTE_PRIVATE)
> +               return -EINVAL;
> +       if (attrs.size == 0 || attrs.offset + attrs.size < attrs.offset)
> +               return -EINVAL;
> +       if (!PAGE_ALIGNED(attrs.offset) || !PAGE_ALIGNED(attrs.size))
> +               return -EINVAL;
> +
> +       if (attrs.offset >= i_size_read(inode) ||
> +           attrs.offset + attrs.size > i_size_read(inode))
> +               return -EINVAL;
> +
> +       nr_pages = attrs.size >> PAGE_SHIFT;
> +       index = attrs.offset >> PAGE_SHIFT;
> +       return __kvm_gmem_set_attributes(inode, index, nr_pages,
> +                                        attrs.attributes);
> +}
> +
> +static long kvm_gmem_ioctl(struct file *file, unsigned int ioctl,
> +                          unsigned long arg)
> +{
> +       switch (ioctl) {
> +       case KVM_SET_MEMORY_ATTRIBUTES2:
> +               if (!gmem_in_place_conversion)
> +                       return -ENOTTY;
> +
> +               return kvm_gmem_set_attributes(file, (void __user *)arg);
> +       default:
> +               return -ENOTTY;
> +       }
> +}
> +
>  static struct file_operations kvm_gmem_fops = {
>         .mmap           = kvm_gmem_mmap,
>         .open           = generic_file_open,
>         .release        = kvm_gmem_release,
>         .fallocate      = kvm_gmem_fallocate,
> +       .unlocked_ioctl = kvm_gmem_ioctl,
>  };
>
>  static int kvm_gmem_migrate_folio(struct address_space *mapping,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 01761f6e25d25..a08b518cdb175 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -105,6 +105,18 @@ module_param(allow_unsafe_mappings, bool, 0444);
>  bool __ro_after_init gmem_in_place_conversion = false;
>  #endif
>
> +#define MEMORY_ATTRIBUTES_MATCH(one, two)                              \
> +       static_assert(offsetof(struct kvm_memory_attributes, one) ==    \
> +                     offsetof(struct kvm_memory_attributes2, two));    \
> +       static_assert(sizeof_field(struct kvm_memory_attributes, one) ==\
> +                     sizeof_field(struct kvm_memory_attributes2, two))
> +
> +/* Ensure the common parts of the two structs are identical. */
> +MEMORY_ATTRIBUTES_MATCH(address, address);
> +MEMORY_ATTRIBUTES_MATCH(size, size);
> +MEMORY_ATTRIBUTES_MATCH(attributes, attributes);
> +MEMORY_ATTRIBUTES_MATCH(flags, flags);
> +
>  /*
>   * Ordering of locks:
>   *
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

