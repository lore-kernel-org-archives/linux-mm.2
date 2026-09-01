Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98E8AC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 20:14:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B2906B0088; Tue,  1 Sep 2026 16:14:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8638C6B008A; Tue,  1 Sep 2026 16:14:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 752356B0095; Tue,  1 Sep 2026 16:14:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E09D6B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:14:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD3B4802CB
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:14:19 +0000 (UTC)
X-FDA: 85166295438.15.BB300CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1F69F16000D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:14:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QEWxDwuk;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788293658;
	b=f5Olpq/71l2edLu7+KS3RKxsT0mkpFW0mg9DLUztcMmlPeeRbmkiKDHXhjd5Loetjy2j0E
	Hu9bBBpygk6DRX3UHjfNLji6MM/+FsKkg2SjVyCjL6ZQ4k+nU/ZIO0oh+0gAQ+3e0O7Iho
	T4sxOJZw1ftQWEuy6lybb8Q8dchK918=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QEWxDwuk;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788293658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P2Y/7R1nKNC3hVgJ6HVCLjPdj/LqygKXED195b8rx8I=;
	b=5LSTmh6gzdVT55L8bgSYTtcFrMemZtUwRCj6nmqTZR/tPAUUdy+lckaVEg2rdv58yPQ961
	sUpYNhWyWfRrWqDnG8cdH0Fo4zwSwoT8LGPyk89v8H0yb/1cJtGuVBjeW8cOO0rJ6qwlsd
	GNJuujRuSOia0YbXtrLFhAOTzxdPaz8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 15579401E2;
	Tue,  1 Sep 2026 20:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3951F000E9;
	Tue,  1 Sep 2026 20:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788293657;
	bh=P2Y/7R1nKNC3hVgJ6HVCLjPdj/LqygKXED195b8rx8I=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=QEWxDwuklcAT5vpT/GCh8/tGOqL9zu9498j8F1chVU2f3pi31jaf21AraJN58Jaqg
	 StWIeODS93d+9LhmpvfaD8yifmXFmiVhcmg/ozsZbRA8KGF5cx2pdfu1sEFrxVrNlO
	 gv4OI7BfxFm9fkfmogqLl/Mllr/LdKuTAFHQsnDraEP2KJ1IOiVoXO0+IzcvwCuWLH
	 kyTvnG7vAo/5CS2uCCGCKN1FNozw6LV7BkXmCcVBXJypXbHZGwXn6L5xH4Qw0A6JaS
	 dNFnHQQDN7G6QsDXd10aYR9/IoAuU7u2pMRh5GFa8NKfwM9bJyjQIcXmoNAx7NRYYa
	 LIxDGeBk/l7UQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 01/17] kexec: Record allocated CMA pages to fix
 release size mismatch
From: Mike Rapoport <rppt@kernel.org>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
 chenhuacai@kernel.org, kernel@xen0n.name, maddy@linux.ibm.com, 
 mpe@ellerman.id.au, npiggin@gmail.com, chleroy@kernel.org, tglx@kernel.org, 
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
 akpm@linux-foundation.org, baoquan.he@linux.dev, rppt@kernel.org, 
 pasha.tatashin@soleen.com, pratyush@kernel.org, ruirui.yang@linux.dev, 
 kees@kernel.org, thuth@redhat.com, gshan@redhat.com, jic23@kernel.org, 
 james.morse@arm.com, ardb@kernel.org, leitao@debian.org, 
 yeoreum.yun@arm.com, sourabhjain@linux.ibm.com, coxu@redhat.com, 
 tangyouling@kylinos.cn, hbathini@linux.ibm.com, adityag@linux.ibm.com, 
 ionut.nechita@windriver.com, liaoyuanhong@vivo.com, seanjc@google.com, 
 fuqiang.wang@easystack.cn, makb@juniper.net, piliu@redhat.com, 
 ebiggers@kernel.org, jbouron@amazon.com, mclapinski@google.com, 
 me@linux.beauty, graf@amazon.com, bgwin@google.com, robh@kernel.org, 
 takahiro.akashi@linaro.org, palmer@rivosinc.com, x86@kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org
In-Reply-To: <20260826092541.3905933-2-ruanjinjie@huawei.com>
References: <20260826092541.3905933-1-ruanjinjie@huawei.com>
 <20260826092541.3905933-2-ruanjinjie@huawei.com>
Date: Tue, 01 Sep 2026 23:14:00 +0300
Message-Id: <178829364020.3691424.12323275610442178748.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Stat-Signature: eqd3yat9ukidec5n1umi8aajx48wcjtp
X-Rspamd-Queue-Id: 1F69F16000D
X-Rspamd-Server: rspam06
X-HE-Tag: 1788293657-647989
X-HE-Meta: U2FsdGVkX19I59m6uYW5YJl0htS4nAmWj8WaS94oyT1oPf7N44+5axowSdAaEN3Qh0nBT6ogCqFxkBy/R2+Dfo8MaeVqDYMpV1PCZPj4YsWO+RtnziFBI64WododnQjYhgnFS4phkByPDgyW9CxE+kkq8avhq3p2JpdY8E9NkRWa9S5u4ZI5Up1zkPMOAXNEgRzhRpbDpy/baK4vcagBhpvPG/EDMCsx6Ac022K/i6PZ/zw17XJQSjRQhOkAGV2AoRhqexMoSYzxGEBc+HqJH7LHuifc0pfX61x3oxImHSHPqrwH5d4wFzYZ7CVq4Js2WMNkhhyTj1GxWYlNpbPmGYikw3xtIlzPRxmJi1LqYJG5fgrV2pzd2bV5Lu/ES0MalSVorlhOSBgsC7eg5LPCzcufF3iKvIJoQxbYeszYjZ+V44KzKeb/q31tYXMHeIA6UzpLB/cTCVgyjrdakEjg7gyrJCtFiAiDMlbbAygkBJC1J8nyoNZgTgItvQX1KlRzTzRTum6/QvtqRBLcEgwgX0vL67jcAPwJNL50utt2gIar9kpdddNtuN4FFwNQWNSd8FhyXwJI0MovgfaYcqxWGwel9I6UNDKwS4FEZufuCtLxwwFgTaQQ47UkAU/b/xAFvm2ymzyLCIgtZLPpBu5JeTOaSo183NV6sDySDa0NVvGRD80ORn1fm6CMJ8Xez43bpgO+QCQ0A7uIEaaJLet8gVQdJwBiR5SunM5cjawrLcbSpr7RPWzN6+XU/9yXVhvMVWeKmV2x5D4Xxyglyk/2tsfyAN9/BulvmemXlQpm9wLEGvOFSbqlwDO+E1W2KXw6Yssg5DltNQZLWARnaDAXDth58pw0nnlUJZHh4T27Tm1w7rCs6gbr26GNFVNfVEJZfQ/D+9LkzwxFOqkNyprq4Qm122SnxNdB3CQvMRPtwHgzMEthdRCh0sJvFYKJ0jFJPS6rOQpUGKae0bs+Cu+
 GR+hb2HA
 JZRNcvjB/HKi3ZvfUgVdaEHcfshVmuEupCsRIJz+f23jyr2UDEPHGKbYMenp0DtX5KQmZJsNIndaS7YnnKT0tvPafvr6ryFTGtoK/IYyn9GR8CPFwuEG7BW8duiTprNzbK7XKG9NMnCBn65JVRTIbAhylUkSWPv/RClOKF6cyewljnfTwoKK7NhAnIXFegZkkyPzrD8QGaf+yYLnjB4pgBku7po8IZ9HdVKt/gJI6yhej7hzBaVU+xpvZUHYeK0ZLLgTBk64sxnU4eKaUjCrPnXqvy0m87wbuA4xPiEBPtx0rNJ22OnJvNHzvJmJOHvXT4neq2cBE46cuJ06e09gBrgSajEhay6PPJfntZZevMjkVd6TpCEDkOpiGZx6FLBsRtvlAlqv0jqWOp1hiqrkSwaZRRAJNvH8nHjhehQAYcVVWDU5K51RTqTBC6FBI7L0gstoSd96OiNatw9MdfdkKBYx34HrqpFABl2DSPk2oCCdZWq4V6G2zX8rJOBBysDwCxKyR+KpzcvjeH728W0moBmxcDVp/e+e7kULEvP2HNiWxtRQSfGoGSytHi1X9Mkj0hlTv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

> The CMA pages allocated for a kexec segment are released using the
> segment's memsz to calculate the number of pages. However, some
> architecture loaders modify the segment's memsz after allocation
> (e.g. arm64 subtracts text_offset), causing the release function to
> free fewer pages than were originally allocated, leaking the remaining
> CMA pages.
> 
> Add a per-segment `segment_cma_pages` array to store the number of
> pages actually allocated from CMA. Populate it during
> kexec_add_buffer() using the aligned memsz, and use it in
> kimage_free_cma() to accurately release all allocated pages.
> 
> This avoids relying on the potentially modified segment->memsz and
> prevents silent CMA memory leaks.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Baoquan He <baoquan.he@linux.dev>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
> Cc: Pratyush Yadav <pratyush@kernel.org>
> Cc: Brian Mak <makb@juniper.net>
> Cc: Pingfan Liu <piliu@redhat.com>
> Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
> Cc: Justinien Bouron <jbouron@amazon.com>
> Cc: Li Chen <me@linux.beauty>
> Cc: stable@vger.kernel.org
> Link: https://sashiko.dev/#/patchset/20260729031235.2840255-1-ruanjinjie%40huawei.com
> Fixes: 07d24902977e ("kexec: enable CMA based contiguous allocation")
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
>
> diff --git a/include/linux/kexec.h b/include/linux/kexec.h
> index 0af8ae4fdd087..83c296c0eb6cc 100644
> --- a/include/linux/kexec.h
> +++ b/include/linux/kexec.h
> @@ -349,6 +349,7 @@ struct kimage {
>  	unsigned long nr_segments;
>  	struct kexec_segment segment[KEXEC_SEGMENT_MAX];
>  	struct page *segment_cma[KEXEC_SEGMENT_MAX];
> +	unsigned int segment_cma_pages[KEXEC_SEGMENT_MAX];

Can we universally use unsigned long for number of pages?

>  
>  	struct list_head control_pages;
>  	struct list_head dest_pages;
> diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
> index dc770b9a6d053..611b15bb1369e 100644
> --- a/kernel/kexec_core.c
> +++ b/kernel/kexec_core.c
> @@ -560,7 +560,7 @@ static void kimage_free_cma(struct kimage *image)
>  
>  	for (i = 0; i < image->nr_segments; i++) {
>  		struct page *cma = image->segment_cma[i];
> -		u32 nr_pages = image->segment[i].memsz >> PAGE_SHIFT;
> +		unsigned int nr_pages = image->segment_cma_pages[i];
>  
>  		if (!cma)
>  			continue;
> @@ -568,6 +568,7 @@ static void kimage_free_cma(struct kimage *image)
>  		arch_kexec_pre_free_pages(page_address(cma), nr_pages);
>  		dma_release_from_contiguous(NULL, cma, nr_pages);
>  		image->segment_cma[i] = NULL;
> +		image->segment_cma_pages[i] = 0;
>  	}
>  
>  }
> diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
> index 59fb9d71e9d86..bfae3fee7f2f9 100644
> --- a/kernel/kexec_file.c
> +++ b/kernel/kexec_file.c
> @@ -670,7 +670,7 @@ static int kexec_walk_resources(struct kexec_buf *kbuf,
>  
>  static int kexec_alloc_contig(struct kexec_buf *kbuf)
>  {
> -	size_t nr_pages = kbuf->memsz >> PAGE_SHIFT;
> +	size_t nr_pages = PFN_DOWN(kbuf->memsz);
>  	unsigned long mem;
>  	struct page *p;
>  
> @@ -756,6 +756,8 @@ int kexec_locate_mem_hole(struct kexec_buf *kbuf)
>   */
>  int kexec_add_buffer(struct kexec_buf *kbuf)
>  {
> +	unsigned long nr_segments = kbuf->image->nr_segments;
> +	size_t nr_pages;
>  	struct kexec_segment *ksegment;
>  	int ret;
>  
> @@ -763,7 +765,7 @@ int kexec_add_buffer(struct kexec_buf *kbuf)
>  	if (!kbuf->image->file_mode)
>  		return -EINVAL;
>  
> -	if (kbuf->image->nr_segments >= KEXEC_SEGMENT_MAX)
> +	if (nr_segments >= KEXEC_SEGMENT_MAX)
>  		return -EINVAL;
>  
>  	/*
> @@ -789,12 +791,18 @@ int kexec_add_buffer(struct kexec_buf *kbuf)
>  		return ret;
>  
>  	/* Found a suitable memory range */
> -	ksegment = &kbuf->image->segment[kbuf->image->nr_segments];
> +	ksegment = &kbuf->image->segment[nr_segments];
>  	ksegment->kbuf = kbuf->buffer;
>  	ksegment->bufsz = kbuf->bufsz;
>  	ksegment->mem = kbuf->mem;
>  	ksegment->memsz = kbuf->memsz;
> -	kbuf->image->segment_cma[kbuf->image->nr_segments] = kbuf->cma;
> +	kbuf->image->segment_cma[nr_segments] = kbuf->cma;
> +	if (kbuf->cma) {
> +		nr_pages = (unsigned int)(PFN_DOWN(kbuf->memsz));
> +		kbuf->image->segment_cma_pages[nr_segments] = nr_pages;
		kbuf->image->segment_cma_pages[nr_segments] = nr_pages;
> +	} else {
> +		kbuf->image->segment_cma_pages[nr_segments] = 0;
> +	}

I suggest to rename nr_pages to nr_cma_pages, initialize it to 0 at
declaration time and make this

	if (kbuf->cma)
		nr_cma_pages = PFN_DOWN(kbuf->memsz);
	kbuf->image->segment_cma_pages[nr_segments] = nr_cma_pages;

-- 
Sincerely yours,
Mike.


