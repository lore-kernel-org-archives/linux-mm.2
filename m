Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78071107637E
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 14:05:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5C006B0005; Wed,  1 Apr 2026 10:05:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0CCC6B0088; Wed,  1 Apr 2026 10:05:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FAED6B008A; Wed,  1 Apr 2026 10:05:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E04B6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:05:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9C89814094F
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:05:21 +0000 (UTC)
X-FDA: 84610159242.04.CA2AB4A
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	by imf08.hostedemail.com (Postfix) with ESMTP id 80A87160004
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:05:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EnvTzdn2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775052319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cok0tTO+M9AY7GrL3ZPCAkrKaBzewD/gpEZeNzSpUo4=;
	b=RkyBIsGodvXorifL1VKaZcE3Ni1bLaenntSbPsbCXv2XmOCHVRADZ9M27B9YjXtKN9AhHW
	u7NTOCCeXHfGaKrZuSqXndlMI70JFRyFFfVdn715l7buBv1DN4KFxEU/DT5nJQwroqYNzP
	3ytpdqN8UFbRwmRNjWS0+GkvlQEayYk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775052319; a=rsa-sha256;
	cv=pass;
	b=cAlB5byrMqbnPSRskhKg7IUhCMzccy8kJLeIdjyYSDPjGWlqpZYME6Qkp0RPKIGzfXpH73
	fut7gR5qoUpLkxEKjDelVAYM62YpG0Z7XN/C11ODIpGd5gtrDDU/3IZwViqG8GDWse3/3c
	JnZKOUG7/KLNl53pFlHRTV3gLysUUOo=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EnvTzdn2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-5673804da95so2510779e0c.0
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 07:05:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775052318; cv=none;
        d=google.com; s=arc-20240605;
        b=I6SeUdJfuHdcNaCyRho/4zVDE7Hc/RflhGrAQEbeZalQiOQzdObZdHycswKAZV4KxW
         Ugyx0ZSaGl6MGNs4JiDS1sW9lUZf1g+sK5j6QOeYn8EBkOdxLdSAVFp7E0oip8j5q+ti
         5AMcFjPbMqKD+F9LSVipu+OcSykZkqQcDtcAytKKJPu9zl8xSq5Qetb4an3Mxb+0lgKW
         DeuuhwTC1RnSoRakYQwsg12J4zmcF4WSxXdLC2LDb4zq/et324LErPOJuLQRxWf96A29
         TX4X6THK/iKy4mxRtpBhhM0NQm8IrJ7ZK8gSViEWE2+cmwONXNrpCIzTgzC/DOa8Bgxg
         ZPhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=cok0tTO+M9AY7GrL3ZPCAkrKaBzewD/gpEZeNzSpUo4=;
        fh=7MWHL9VBNLE5q4uUQomR+AbXGwwjTxOcagW7mxZU8Lw=;
        b=ErKFPQk0YXGmHLFu/fBZvAr8ARwhllVR9hcg9Tb3M7c/YigVBBJ5Xb1+0wEj7m1sqC
         7LAJ8JGClsEohMckyQHrE5ZMk3/x2JcbcJgeRpwUg1suyFySAAdjCnzxxPpPcgpEb77C
         4V1SQtn7tFc8+McJNgh9j0/VoFiFtKZbSDO3TPtb+ydCzQ9O8jkMG8u6p4mm/jTziF7v
         KDg+ygjb/JeWhRTfIqfIuIihFj1qdFBdMIMQyxz+xE5usTPnza9uqSIX5L58JiMO5qqS
         kveWaRyClODli+qo8sE81PfmfxQdrEjGIvcQrCKR0fFI0WQUSqbpFIOyxQc83emu+lLD
         s+tg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775052318; x=1775657118; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=cok0tTO+M9AY7GrL3ZPCAkrKaBzewD/gpEZeNzSpUo4=;
        b=EnvTzdn2RGe5mnCDqMEzY7wiSPQS/sw2OrE5Ko9OxmnSeOdmquov8FVANsFa22U82F
         XAZS3JPceZ4Q0OPD6uhEHcGsk9f/hHFwaCcdKbhrH8QpzVFScAnW8M4TEOghJkWtBTYU
         vdPN59NDqpyoqMbUfj8/07joMeuv3I5uFPKg3MQ6N3sWidCv8KX6At5XlO8dql1jE8Ax
         hZRuiNRwiO8mx63KjoKDFaQBm2gwhbRMt3u0eTHUWx8PswlgQUXzo/Tii2hYgbMb3QJj
         QFPyMzhRwTkvxSByOjHVzOpwRrttXjZe0Byf6kpZZci0w2cNU0hkOxrAadfNJSV/LbTu
         VpWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775052318; x=1775657118;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cok0tTO+M9AY7GrL3ZPCAkrKaBzewD/gpEZeNzSpUo4=;
        b=CjzFFeNmLRl+29dY4ih5RN4ZAtutO2txbXIq/Mg9yqYtZ1iV88pMvWXui0/dhtZtYn
         K9CMLMW2LFJAbCW9/N9ftJa8dvp/5Zfq5I5mzQ511DBjmqFOFuxrLTpZa6plNHZa3Iaz
         ppEBpA4DAtSxgwoifB1zVts6kfSU4VNqWGjygMgzUYkE47U/YeKiWYxGpZS78/+ewkNI
         RWMg2qqyK1JnVXQZxBT+okDqrK+iXpHoZ6OrJK6B4w68K6Ysq1ZxCElOk1MAB/O0sJSJ
         4kqQBj+3xA1elq38ru+SVvuXktrP2BwssmCk736m4sueMdh+WcSMAECC/RjuUdmoYKSa
         IQLA==
X-Forwarded-Encrypted: i=1; AJvYcCWi58vPLwc9HZTdIk+TdRBanEVHlgV4pi5mn+lCwkY4/baymgPbqACl3NaPYIgvOWDpu3fuyuNPLA==@kvack.org
X-Gm-Message-State: AOJu0YwezzT0+Rd32yjvu/1dF0Sn48kUb3iLYVzyTrXCbGpFCpEVIxoU
	uExocEg8/SOv7icWSD+FUZ7hSNlm0m62GDxqNZurxV1hvbNhG9wkGBYy82RBuR0JzHZEX7dt+Fr
	Iw92FsYkJsnFJBwwEqUWXDD9jfCml1ZYCnegU83yE
X-Gm-Gg: ATEYQzyRd7v71Pp+MEotvRykw2vm1HRLL39kQEmPHm3DM6Fz5kNoXSlc9cq4DhHlP4d
	h2HsmBWReFtGToD29zva4sKQVx8bvpb5HGwrdn4uJ/fzmip4CY3imizo3bjqVuTJOs4r+LGYJ9C
	j2AMEYqlTQZrGsPfjBny8OdSw2PDLSZMD/JBUuRBGQtE90EuuMIiuDkWuRy/Obb0pq5ejWHiox1
	gVnA6l4PEpRCIM2pom25WqfsPxgas+4tZNeJy4kBoNbM8n7/W0ta1krnSuT9Xxxwen6COnkDt6E
	G0RrtwNG0vxpCpugXh0ZuF6JZHY4WOXTPj5z2Q==
X-Received: by 2002:a05:6122:ca1:b0:56a:ef89:34fc with SMTP id
 71dfb90a1353d-56d8a81bd48mr1423992e0c.6.1775052317094; Wed, 01 Apr 2026
 07:05:17 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 1 Apr 2026 07:05:16 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 1 Apr 2026 07:05:16 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260326-gmem-inplace-conversion-v4-7-e202fe950ffd@google.com>
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com> <20260326-gmem-inplace-conversion-v4-7-e202fe950ffd@google.com>
MIME-Version: 1.0
Date: Wed, 1 Apr 2026 07:05:16 -0700
X-Gm-Features: AQROBzB8ZjEkM1kRtGYPSYrf1SL2xnDWxbzougnTteAKEFNAbNZQz2YVpzx5v1o
Message-ID: <CAEvNRgF+FjJ1EWSR_rzD1=N040ZitiRrM2O3N0Kj5yN5rT3h+Q@mail.gmail.com>
Subject: Re: [PATCH RFC v4 07/44] KVM: guest_memfd: Only prepare folios for
 private pages
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 80A87160004
X-Stat-Signature: xey9gjwtpyhxugh4ykho4so73nzxhrsq
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775052319-949077
X-HE-Meta: U2FsdGVkX18P6wQ7VEBmdz6iIJHR9ifchvJCFZk2/64KP3Xq0jkcH9EDnaI5pDzG7A3YcMEjmvhTDgyKZwqVBZKIUHwTDHaD/OzaMod9pYsNrtD1b4jjMLxsa5hdXRGrT7QryXqyRGTN42UNVDTw22orhxQ3i/FF9C5gWyFh+Cs6RBrylu/Z1N78q6kFreid2kVlpt4JUNNCndC2jb/H1/2hErla18nnBsPaxnP5zGJfAiPPGKcQ2wMYAhR0nazJdV7Ao1kmyfRRrssiXjc1EGw7JKy4vRQsnYN+czqpHZuHKph0DCfvvHLv6kDxiFK6/cbNH0OyTBJLmBhNkQHV4Fq6dt56RAzlIlAFmLA0Mcb2J//Zxol2zWBreDJ0gCsVrSNKw0PMgPRH+/o48UKE1Fqjli4XfhL7hKticbRmR0subZeRry50jqchtKV62t73+SyB1XtTgPWw1wLarRyVLTjHgnMZ0wcsiQJLhcrRoS70PPdurRRaab/dm421dwBMLESJIFu4u5XM7iNGt/GtZz/cAUiKRj2Cm0JwU7bmaM5eRjmRycwnbdUfUMJ2w0MW8DOhL6jtyYX+s+myT+YMv2QvGa0CuAP4nCpwnHz9Z4ZBKTP/sakDx73T3dzj7gGK2m0DiKlgtWEvKr2WVi8p38XiMpiVEWM3bbPrJR7InLQqgZQBiLrWmU2auSQ09XWgCSMHgEZd80coo9oAUhKyeOkWtPfgsri60ZzauetrT4wYGN/WXCY3GTuW4tq19lwX/0R5jClizrg+VFY5pA50jOvE654q5gg8iKCBOGmhL55ziyquqy62GUfbcdQ5ANg2bucaAqnC5J4sOYiXJqtbT7NQ9rDApTP81RcyYIrhrCraVQG70pQWPGNMZLV2lunRLwr7wOYg4/12ag2cCk521KVBK8HInCe22+QpE2mwEfiQFzldOgKczz8vh7I6CRD/UbsHbsL7O6aLO78U0U1
 v8piMhQS
 +SKqI2oJdga4ArA3BemDh4gv6Zt/T7oHmDR5FGs3DwZ49UCJdHOmhubbRL8RNmOVxoHD20krNLKmMQ8mwRqgi84jNhcm4BId2o+2EE7hyQ33dqmHY6cZg8HVnmo38FQ7pF3vwcszUTLN4EaAK42Qval4/JXxPz4wClxZ6vs/rHbi5PBFezcAoqnSex5JaRg4oLqQ/RebihDVcvClZQf4Vu+buSLF5VdqCIwS+RoDhe/TerDkyBe0UNpAvxkK3z1D+nO7nUaHkPuTf5Y8WfNRNWhgHORw0Z4nBQ7UaRy3+P/V0/7ztN5zf30zwQeoKADbdfC00UcG5Ut3VnJaIoG4WHvZZ5QPipM5kD+1IfpZaXy4w6BOa7y6AE72bHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

> All-shared guest_memfd used to be only supported for non-CoCo VMs where
> preparation doesn't apply. INIT_SHARED is about to be supported for
> non-CoCo VMs in a later patch in this series.
>
> In addition, KVM_SET_MEMORY_ATTRIBUTES2 is about to be supported in
> guest_memfd in a later patch in this series.
>
> This means that the kvm fault handler may now call kvm_gmem_get_pfn() on a
> shared folio for a CoCo VM where preparation applies.
>
> Add a check to make sure that preparation is only performed for private
> folios.
>
> Preparation will be undone on freeing (see kvm_gmem_free_folio()) and on
> conversion to shared.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  virt/kvm/guest_memfd.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index b6ffa8734175d..d414ebfcb4c19 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -900,6 +900,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  		     int *max_order)
>  {
>  	pgoff_t index = kvm_gmem_get_index(slot, gfn);
> +	struct inode *inode;
>  	struct folio *folio;
>  	int r = 0;
>
> @@ -907,7 +908,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	if (!file)
>  		return -EFAULT;
>
> -	filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
> +	inode = file_inode(file);
> +	filemap_invalidate_lock_shared(inode->i_mapping);
>
>  	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
>  	if (IS_ERR(folio)) {
> @@ -920,7 +922,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  		folio_mark_uptodate(folio);
>  	}
>
> -	r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> +	if (kvm_gmem_is_private_mem(inode, index))
> +		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);

Michael, I might have misunderstood you at the last guest_memfd call:
sev_gmem_prepare() doesn't prepare a page for being a shared page,
right? Does this work? That prepare is only called to "make private"?

>
>  	folio_unlock(folio);
>
> @@ -930,7 +933,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  		folio_put(folio);
>
>  out:
> -	filemap_invalidate_unlock_shared(file_inode(file)->i_mapping);
> +	filemap_invalidate_unlock_shared(inode->i_mapping);
>  	return r;
>  }
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
>
> --
> 2.53.0.1018.g2bb0e51243-goog

