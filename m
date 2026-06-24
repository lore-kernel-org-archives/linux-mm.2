Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92C6DCDB47F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 17:46:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C3566B0088; Wed, 24 Jun 2026 13:46:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 575256B008A; Wed, 24 Jun 2026 13:46:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43C446B008C; Wed, 24 Jun 2026 13:46:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 10BAA6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:46:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 943AD166623
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 17:46:34 +0000 (UTC)
X-FDA: 84915535908.07.50BF3A0
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7FCD3180009
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 17:46:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="rL/P56+T";
	spf=pass (imf06.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782323192;
	b=CMCnMkRqvncW7upbtNnM13rSQ0LBYurc84/2x2+BTcMkSY2S8EiuHmc5vvD9988O09dQF8
	Nydt+ZBrNHVxePU7SMAeUAyUGXEzHZRaYKQr7c3QTnmfAdP5PB0oF/MWQLt9AMlnG6V41i
	2pEaxWLdHt9YnfS99iK7Ta/5R0rBb+Y=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782323192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mqx7OyqbEK6iUTPEaB+Dm1Nc+76HebeZ2yhpFRHkMNY=;
	b=N8FwGsnJtGGkovld8dLCqSDwkcr5Mu7Z68fYBFTa5IKwS0f7vyLh5wJzosW9qbSPG1Gcj7
	k/w67P4oPnhMWs+ud0mJnL0fFvMd2yLvDGBB5PYDXvIJWcQLRgIhSRjHrXrm4QXnMps36M
	sWZe87UO4HIG107he8LjRBNA1NLiNzA=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="rL/P56+T";
	spf=pass (imf06.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1397e093f90so3667042c88.1
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:46:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782323191; cv=none;
        d=google.com; s=arc-20240605;
        b=ZUZvjzk1615PS+4L1cb/vuuWASb26hSM0rwlv/PdscBh+JbwUtzz19hrzQRp4FBx87
         Zbh2d/Rj54p5Gd95TrYSLkVMqNuxF7WJqGaCGCUV1sWgJn+K+E9sycwaeJEu2XTA9GMZ
         K6RFW0g41RffXFL41GE9EkkECn8M6CO8hzsLbX9T+KqpuCEh3uezNlLBCy+j7l2DSWnI
         dE8qKqBfhXg9OvcdKy7oyHvGMiQRPtEflh1uV2OXNVX8yhPP0fbzw+tUpD6lpv/q6/yc
         v29L1r0VMMKpqrULoTG/Sgk5IKuJw4USAsEDwXfeYN286M/cqT4RxVEM22TUi1+IGnzm
         j+qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=Mqx7OyqbEK6iUTPEaB+Dm1Nc+76HebeZ2yhpFRHkMNY=;
        fh=lon05JVXsotCqd2QGO52Dw3XjOj6MPnoLgqHUX4cDuE=;
        b=jDYnIjo3GGsts8ZxcE6QpMdTRqzjJ/EUmOAVDlYv0c35tUh8iYxPKWY1Uw1234pXtM
         FgBT38vIhFxA02ct/E/h3cirzMo0zR8VmJREcoTHc8+dml3x53XIbk3lNuI3KjDLi3+d
         M15ll25GZyMHlPFYmZh7A3joSxuI8XW9C6hmBj9Ku9HcrLbj/ZqTaTgkuKHRKWtjV16b
         gDjjatQMLJEItBo6vZbJvsodak/dRqUFGDA6ft9lqPxQ4PN+xHfik5Op0FZsxulCfdx3
         VB7oZjhi7CT59otWRkIONO5AziY4mMm6ZU73Li0Quibya9P3QaerZOCcMsVoDY0Ozer4
         e/nw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782323191; x=1782927991; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Mqx7OyqbEK6iUTPEaB+Dm1Nc+76HebeZ2yhpFRHkMNY=;
        b=rL/P56+TtJmE5mFHcK1fFI+hbsmP1woYJmAJK2wOH+qy3A1iBO2iVrd/DgEgwxFhNl
         rYqrwvZI6rxsKAbRbppIK9XKkIy2TluH6H45Vvs/M4KrgDzbLO7Kfe7CLNf7G08fW802
         2FniFDBsJj14n4DGJRpEz97cuy0U1eDJqsTzFH99kLUewc0yyKEUJ9D/F41sgA+0fkPf
         K0Ss+s2StDN6CJEPyNvQStnu7jf2rjPwStGs5oQL37/ZAswYQDFvWYkEWArnKBWGcfYd
         jYJF3zkh+vhTGrOL5+/bHWVAgoBP/3W61SMqq4VuSCC6YHF1xGciGjcxR8A7zUrkp0uL
         gC/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782323191; x=1782927991;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mqx7OyqbEK6iUTPEaB+Dm1Nc+76HebeZ2yhpFRHkMNY=;
        b=jcG3G6H+BMAPDHR+wuhRZZ08RiyydOmHzkscyUyD853BY3BxQsRlvZ0NiTIz4h/31+
         9PsZPlH2JA6HEUzn+aZtPLz27POmoOovUZdlFaGw9FkH+xFUjvWFkNaUi16wOuCzweCF
         UtloqU+xYWD3/+q2yOyjnumYcAYWxuVNxEX8zT3JtIadU3DVEmbSe2gwFBKQrGPI2efj
         Mz5/NpGSdo4vsYJ+Oecs4ozvBKCnJWPEMD2jEnraH8UdfL73bH7TdmDsFqMtdshxVVGS
         JLV/VULjQNVyljjAnqExwNswDDgnuWervydi/PZ/4NHI2ad7DdhV6EcRvoZBSzCOcDP9
         UF8w==
X-Forwarded-Encrypted: i=1; AFNElJ+WudTsKjurtyk4jiUxVo7yQgeCBDDo+F/xQh5hqH+bYgUK2I0oaAl7FKVPTU9VjxK28gUtV5wLdw==@kvack.org
X-Gm-Message-State: AOJu0Yy73U73l7AHOO8TPQs4hmjuXLDuBfWdI4jXv9zysDaNl6myLCMm
	GbQ45Hmi8LHprAaxGI0U/ybjFW2Q/d8yFy2RaXUheu5a3M6dTINmZHEXL/NZAp8Hk7KIIuzvxdt
	txXFYIrtas0yrkkYRtsMjjrktay329epkTjDCNNgR
X-Gm-Gg: AfdE7cmUToI65T4gJQBB3rOlIY6qSiXR2NUKD3UZ0ccO2JopZsJslMvAOMUkfRFuJPd
	0GBRDQhQJodyRfpKsibSoeb9BL6Z4ulTt7dEx0WRFfv3Xr5uaqssNW2GgMIu3NTY0X5N71cZtxW
	5X54qGXy+aqovdI2U8fcR1l0BVblBtQR1k9A+tYQzZZFS2v6qXl1/zB7gKZMWdBm9MZ2EPh7osT
	ETL20jLM7P+RaxJf4jWjZYUUZ1qAIHhbV4GIaR1AFBF5B5GIfv3l9lNudzMB9LPPAKvY3A2rqhy
	kl1YcXq3xoP2KdC7PlBVten5bZPZHIcVUmJHmYFITewDf6NqB4WZoG178zY=
X-Received: by 2002:a05:7022:ec6:b0:136:c24a:7213 with SMTP id
 a92af1059eb24-139d0c1d9cbmr3442157c88.11.1782323189975; Wed, 24 Jun 2026
 10:46:29 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 24 Jun 2026 10:46:29 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 24 Jun 2026 10:46:28 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ajneQVLriUshjFIO@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-15-9d2959357853@google.com>
 <CA+EHjTx+3U++dnhGEkwh2SO82xMugAvvJ9ee1O__sxZCKL_X5A@mail.gmail.com> <ajneQVLriUshjFIO@google.com>
MIME-Version: 1.0
Date: Wed, 24 Jun 2026 10:46:28 -0700
X-Gm-Features: AVVi8CfZZdJUtw5fyaSnXyT_Umcz85ZtFZhHHk4S7sCQCvBEuiIkAR9ZBXOQWWM
Message-ID: <CAEvNRgGX3GkazCWM=6y9YLgn=YemXuG==Oo+L58cac1Fd86_TQ@mail.gmail.com>
Subject: Re: [PATCH v8 15/46] KVM: guest_memfd: Call arch invalidate hooks on conversion
To: Sean Christopherson <seanjc@google.com>, Fuad Tabba <tabba@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: ctpudnt5r81fwhwfuszy7bgfbnoy1jcm
X-Rspamd-Queue-Id: 7FCD3180009
X-Rspamd-Server: rspam06
X-HE-Tag: 1782323192-562104
X-HE-Meta: U2FsdGVkX1/W7bmXMFmWqTxOLobubzaHiZU40qskvd1s2jGaofkAGElIcbkIR1huArwx8eK/gUOSIEjvYc8onFEocQicBnz2cGBKzsx1uHffuo5lNyqAp/iyfSIuYkbgImh0iPRJRRTTpORJBKiewUImcYKS5oXpAaOotEgGNNuS0+GdO/AUvlgcr4GYuW8ZoG9Tbut2eSQRWUm0NiioKgQIs3Cx8Pv7qdRLy587VE90LftOHcLIu3u/3mYKTvchEoNsTvpDOor1hDY6uwK4k2+3ALC/3oOQy1qtcJ5WHCu5P9isMAAMUD2mdkmg/nIntnqP8S3FhulUHPUkUbkasDK62Qp12Y0khXbH6JFxhmbKAx6NjSF236f3fwhR8VbzUsbeyu7kIhW3kW/ugKC2SvW6czvWO3X4d5NxbVv09UP/J9wpxGRjCa+7TdUXEITLM90aab32A5H73Bos7NW8nPpdU1d3ByuPqt7qp6/lwu/GHjXh6cSHI6buRzdNCLJZhYI12CKlpb0AhX9AXQkZgBdCLR0lrcx0rWVZr5rtrc2FwKUYNa35dEh5UHjJKubRCMR+irLzUUr0t885H+A5j8khFjjL5uNetNYo1w7SvVJFpqhuCAXZZ3hA/yxowAKvjWGxNtbMV8rR9QqqgVpm0xOdvWpQeU3Pz6/+dSQvousO5B1FxGuBWj/UBOUTzQp449UqPLnr7H6t9qTrS9/EL6/mRZ+pR4N4WMh9TaQzd9O0v7fCB+ZAorA8wCD4XNtDhN2iZeF1sdwwWG0Ug1/7U9uGV1A9HH4ezZKFkuMrMNO+3GYS7N4/YUq7+jRHVS9OVaZ3r48ph1LPt+71aTTyDYzfeQPIFgvI8FTbo9iQZkidMB87EJUGBzxj1Nugp47FdViB1sGdIjvr6BlLjTQZBiuYCsFtQdMFaElbq5io4uDmjkkUYfxrhhq4IByx254XCJMD0QThj3YZ7OFM9aw
 8Nvmb5Ha
 YlOxTfulqyD0hrB7JPFXz/ayxFpa8n+8rv7XwaYijKUR+6wqnGJ1dJLff9k7248UXLb7LfBLhVsld6fPQ9oDJ5qhJqMtoRS/VP0IU/oWTLhru/GR+MrjkRItl0FbFjL2bHWehhoFDHDgMICy1e9Qr2zXE8w2XMqU0hrRHCTb0bolQG+jvFxccBmS5bzE1XuDq6JI+tUOLadoKoS3UBKRJDqJnhDjEuqfZHf/dUtXXvwVB1MJ5/9d9s634kxuIcIYPDm1wzbFqiVRlrawDlfqd99oGnjWiyVqIa8vW5i+QC2vybFc9FJ5P1t2Rco7E0ojfchgcTwEWFMfL1KhRqeH4R2xGhWeH5UQ7HaQw9fhLvdOnDwVbt1Mp0MNoA+tsgxorud1Jwrmg01TQXmo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Jun 19, 2026, Fuad Tabba wrote:
>> On Fri, 19 Jun 2026 at 01:31, Ackerley Tng via B4 Relay
>> <devnull+ackerleytng.google.com@kernel.org> wrote:
>> >
>> > From: Ackerley Tng <ackerleytng@google.com>
>> >
>> > When memory in guest_memfd is converted from private to shared, the
>> > platform-specific state associated with the guest-private pages must be
>> > invalidated or cleaned up.
>> >
>> > Iterate over the folios in the affected range and call the
>> > kvm_arch_gmem_invalidate() hook for each PFN range. This allows
>> > architectures to perform necessary teardown, such as updating hardware
>> > metadata or encryption states, before the pages are transitioned to the
>> > shared state.
>> >
>> > Invoke this helper after indicating to KVM's mmu code that an invalidation
>> > is in progress to stop in-flight page faults from succeeding.
>> >
>> > Reviewed-by: Fuad Tabba <tabba@google.com>
>> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>>
>> Coming back to this after working through the arm64/pKVM side. My
>> Reviewed-by here is from the previous round and the patch hasn't
>> changed, but I missed an implication for arm64.
>>
>> kvm_arch_gmem_invalidate() is now called from two paths with the same
>> (start, end) signature: folio teardown (kvm_gmem_free_folio) and
>> private->shared conversion (here). For SNP/TDX that's fine, conversion is
>> destructive anyway. For pKVM the two need opposite content semantics:
>> conversion must preserve the page in place (same physical page, the point
>> of in-place conversion without encryption), while teardown must scrub it
>> before returning it to the host.
>>
>> The hook gets only a pfn range with no indication of which caller it's
>> serving, so arm64 can't give the two paths the behaviour they need. It
>> would help to signal intent on the conversion path: a reason/flag, a
>> separate hook, or not routing non-destructive conversion through the
>> teardown hook.
>>
>> arm64 isn't here yet, so this isn't urgent, but the hook is gaining a
>> second caller now, and it's cheaper to leave room for the distinction
>> than to change a generic contract other arches depend on later.
>
> Crud.  It may not be urgent for arm64, but it's urgent for other reasons that
> I "can't" describe in detail at the moment, and even if that weren't the case, I
> think we should clean things up now.  More below.
>
>> >  virt/kvm/guest_memfd.c | 41 +++++++++++++++++++++++++++++++++++++++++
>> >  1 file changed, 41 insertions(+)
>> >
>> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> > index 433f79047b9d1..3c94442bc8131 100644
>> > --- a/virt/kvm/guest_memfd.c
>> > +++ b/virt/kvm/guest_memfd.c
>> > @@ -607,6 +607,42 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
>> >         return safe;
>> >  }
>> >
>> > +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
>> > +static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end)
>
> Not your fault, but kvm_arch_gmem_invalidate() is badly misnamed.  It's not
> "invalidating" anything, it's much more of a "free" callback, as SNP uses it to
> put physical pages back into a shared state when a maybe-private folio is freed.
>
> As Fuad points out, (ab)using that hook for the private=>shared conversion case
> "works", but not broadly.  And it makes the bad name worse, because it's called
> from code that _is_ doing true invalidations.  For pKVM, it may not even need to
> do anything invalidation-like.
>

Thanks, I also didn't like the naming of kvm_gmem_invalidate(),
especially when conversions also calls
kvm_gmem_invalidate_{start,end}() and those do different things.

> To avoid a conflict with patches that are going to have priority over this series,
> to set the stage for arm64 support, and to avoid avoid bleeding vendor details
> into guest_memfd, as if they are core guest_memfd behavior (only SNP needs the
> "invalidation" on this specific transition), I think we should add an arch hook
> to do conversions straightaway.
>
> Unless there's a clever option I'm missing, it'll mean adding yet another
> HAVE_KVM_ARCH_GMEM_XXX flag?  Hmm, especially because IIUC, arm64/pKVM doesn't
> need a callback for this case, only the free_folio case.
>
>> > +{
>> > +       struct folio_batch fbatch;
>> > +       pgoff_t next = start;
>> > +       int i;
>> > +
>> > +       folio_batch_init(&fbatch);
>> > +       while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)) {
>> > +               for (i = 0; i < folio_batch_count(&fbatch); ++i) {
>> > +                       struct folio *folio = fbatch.folios[i];
>> > +                       pgoff_t start_index, end_index;
>> > +                       kvm_pfn_t start_pfn, end_pfn;
>> > +
>> > +                       start_index = max(start, folio->index);
>> > +                       end_index = min(end, folio_next_index(folio));
>> > +                       /*
>> > +                        * end_index is either in folio or points to
>> > +                        * the first page of the next folio. Hence,
>> > +                        * all pages in range [start_index, end_index)
>> > +                        * are contiguous.
>> > +                        */
>> > +                       start_pfn = folio_file_pfn(folio, start_index);
>> > +                       end_pfn = start_pfn + end_index - start_index;
>> > +
>> > +                       kvm_arch_gmem_invalidate(start_pfn, end_pfn);
>> > +               }
>> > +
>> > +               folio_batch_release(&fbatch);
>> > +               cond_resched();
>> > +       }
>> > +}
>> > +#else
>> > +static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end) {}
>> > +#endif
>> > +
>> >  static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>> >                                      size_t nr_pages, uint64_t attrs,
>> >                                      pgoff_t *err_index)
>> > @@ -647,7 +683,12 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>> >          */
>> >
>> >         kvm_gmem_invalidate_start(inode, start, end);
>> > +
>> > +       if (!to_private)
>> > +               kvm_gmem_invalidate(inode, start, end);
>
> E.g. instead make this something like this?
>
> 	kvm_gmem_set_pfn_attributes(...)
>
> Hrm, though that wastes folio lookups in the to_private case.  So maybe just this,
> assuming pKVM doesn't need to take additional action on conversions?
>
> 	if (!to_private)
> 		kvm_gmem_make_shared(...)
>
> Actually, if we do that, then we don't need a separate arch hook, just a separate
> config.  It'll still bleed SNP details into guest_memfd, but it'll at least be
> done in a way that's more explicitly arch specific (and it's no different than
> what we already do for PREPARE...).
>

pKVM needs some arch guest_memfd lifecycle functions that

+ for conversion, doesn't do anything,
+ for teardown, resets page state (IIUC it'll be reset to
  PKVM_PAGE_OWNED (by the host))

So I think we need different functions for those two stages in the
lifecycle of a page with guest_memfd? What if we have

CONFIG_HAVE_KVM_ARCH_GMEM_SET_PFN_ATTRIBUTES, which gates

+ kvm_gmem_should_set_pfn_attributes(attributes) and
  .gmem_should_set_pfn_attributes
+ kvm_gmem_set_pfn_attributes(start_pfn, end_pfn, attributes) and
  .gmem_set_pfn_attributes

CONFIG_HAVE_KVM_ARCH_GMEM_TEARDOWN, which gates

+ kvm_gmem_teardown() and .gmem_teardown

SNP:

+ .gmem_should_set_pfn_attributes = sev_gmem_should_set_pfn_attributes,
  and sev_gmem_should_set_pfn_attributes returns !is_private
+ Rename .gmem_invalidate and sev_gmem_invalidate to *set_pfn_attributes
+ .gmem_teardown = sev_gmem_set_pfn_attributes

TDX:

+ Disable CONFIG_HAVE_KVM_ARCH_GMEM_SET_PFN_ATTRIBUTES
+ Disable CONFIG_HAVE_KVM_ARCH_GMEM_TEARDOWN

pKVM:

+ Disable CONFIG_HAVE_KVM_ARCH_GMEM_SET_PFN_ATTRIBUTES
+ .gmem_teardown = pkvm_gmem_set_pfn_attributes

Suzuki, does this work for ARM CCA?

This way,

+ The if (is_private) check doesn't leak SNP details into guest_memfd
+ .gmem_make_shared doesn't stick out without a .gmem_make_private
+ .gmem_set_pfn_attributes, .gmem_prepare and .gmem_teardown are aligned
  conceptually as lifecycle hooks

+ I think the private/shared check for prepare can also be folded into
  preparation.
    + Preparation perhaps doesn't need a should_prepare equivalent since
      there's no iteration and getting the gfn is just doing some math?
    + In another patch series?

> E.g. this?  There will still be a looming rename conflict, but that's easy enough
> to handle.
>
> diff --git virt/kvm/guest_memfd.c virt/kvm/guest_memfd.c
> index 9ce5be7843f2..8aead0abd788 100644
> --- virt/kvm/guest_memfd.c
> +++ virt/kvm/guest_memfd.c
> @@ -648,8 +648,8 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
>         return safe;
>  }
>
> -#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
> -static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end)
> +#ifdef CONFIG_KVM_ARCH_GMEM_FREE_ON_SHARED_CONVERSION
> +static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end)
>  {
>         struct folio_batch fbatch;
>         pgoff_t next = start;
> @@ -681,7 +681,7 @@ static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end)
>         }
>  }
>  #else
> -static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end) {}
> +static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end) { }
>  #endif
>
>  static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> @@ -729,7 +729,7 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>         kvm_gmem_invalidate_start(inode, start, end);
>
>         if (!to_private)
> -               kvm_gmem_invalidate(inode, start, end);
> +               kvm_gmem_make_shared(inode, start, end);
>
>         mas_store_prealloc(&mas, xa_mk_value(attrs));

