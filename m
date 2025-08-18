Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E91DCA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 07:49:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 312816B00B3; Mon, 18 Aug 2025 03:49:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EA566B00B5; Mon, 18 Aug 2025 03:49:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D9106B00B7; Mon, 18 Aug 2025 03:49:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0A4096B00B3
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 03:49:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99CC2C07FB
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 07:49:03 +0000 (UTC)
X-FDA: 83789102166.18.73DF1D7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 473B8140004
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 07:49:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xs6aYqS2;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755503341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GjrpMMZYmeGBQjqK7bhL6RIFmCyMzvAgb+yhK+WhAXE=;
	b=qbMrZxwvQ2R7/isLt/PKCPo/PSeaaV+18i563js6e3DiPSU7Q5XO9+mZFdpYODNZRHjDT2
	20C7DTkko2bE08kYybBOa2DlErewoGEWI5oOYkgmu0jCS+1J/KYnnSdXoca6dFhnhDh8BV
	pTMVFhZcA070xN//spWnsK6hgSGz1qA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xs6aYqS2;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755503341; a=rsa-sha256;
	cv=none;
	b=YabP0Z2YcxMglLUJHpGtf4KMEZJmWYLNLlV9tKMmdgXDSLmN5E7SvrFj/8RH+FFG0zGlh+
	1OEcx3wyl9ANen0OK7DpLWZ/CuAhHwEg2tkZyKw5jV1x91jb+pX0b9RZ3m2ohnj4hL7em+
	go6YWM9k6mqHyTnt3m99elGcXlH57pY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755503340;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GjrpMMZYmeGBQjqK7bhL6RIFmCyMzvAgb+yhK+WhAXE=;
	b=Xs6aYqS2Ue5RADRUjQdMUNWYThMI7yKDrXN+5H/VVkUQ/wsBrABZvPG7TMCgD2/VA/b9em
	IvWePJpV6wO4nrmrntWNLCEpgyP1R9/vB0Xzq37ou5i/79lGwgW+eFAzmwGxInmaZoEEvl
	gdLa4c/yENPjhUX0xz28GyapG0hOIVM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-Gn0zeR6GN4qUxGPaqq-eMw-1; Mon, 18 Aug 2025 03:48:59 -0400
X-MC-Unique: Gn0zeR6GN4qUxGPaqq-eMw-1
X-Mimecast-MFC-AGG-ID: Gn0zeR6GN4qUxGPaqq-eMw_1755503338
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b9d41bd50aso1896733f8f.0
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 00:48:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755503338; x=1756108138;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GjrpMMZYmeGBQjqK7bhL6RIFmCyMzvAgb+yhK+WhAXE=;
        b=Z7Txqp6kgWyyddcu1d4Z8UVf1S16WntoCIezobA/7EsuxdLPXEbICyPZBzz13O/GUW
         kTPDXAjeH1fptcZZZ5zLA76TTOqRbngXKdOo/IIogBDpJ/EB+sGbOtM4n7TOCLrr4Y8u
         LJjku5A+q+WdlI3mRe/7x55FVUV1WifnVavLj9cJB9PA0CS4HnYpGk1J0iyHWOUT2I7S
         aBx+76z5CoHp9w9WE5bA78ozVuHZzz6aweqZHpvsDhWdx+Ew9kCupd2cegRaaO6TRZze
         cFDY2huLwCLlW/W1Xvf3iOt/hn01hWSgWbvn6xAcgY+rT5bNK6N9LUX+SG1X5CXmiMf8
         F96Q==
X-Forwarded-Encrypted: i=1; AJvYcCUVMg0av/o07SDxd0cPqb9G0sbmaWf9TDyfvxieb1fjBlBuOJhg9Lxww9OVXjC0IjyLgPXXat+GJQ==@kvack.org
X-Gm-Message-State: AOJu0Yw525WqMz4WLW0+MhMpmAoVBknnh5V1I5KXArN4kgXtHU9rC9Aw
	kABp6ffWQ/67mH+KMaxJrBaGTAin6zhVDhyLfyplfjnjicUCfr+NKm1LFw5dKxTokLBMNbUOvyn
	5yLlvqjyoKa29nHqATc2+aIWyOkKQcFBc/EozY7GpFoMofFSeOPsA
X-Gm-Gg: ASbGncsI6LDsZt9bhVX96BaUQeIbGk9b0VJDDmEjm1W4tEYoaqjLrpG+mc3s8itkZxj
	E4ep8H2P0XdZV6xvs8mhudTvtDNqIp87uzamwhljO77OjFvxQR9C9Td/5Hwk6pg+VIXsrxCQ9ki
	ulr15qdLv4jqfS1aPJe3f2rUWmynafCWJuPeLLNYEwtxMeotcQvq7GZ/htq09nP5IpY+tSThKYU
	gfC49E6gXt2ffiVZkqnHRqs07dwfnDFMeDraWIjPMWbIF1+udDps8ZPcrtRVMs2BtsL2Q1bkn2b
	u8fvra2iliSWCcL74kKwNgXWc+Cxzk0cS3jlCfnznrVeiOKfO1EDSe5bvFAHA6JmWD/XIB+xNTU
	ZNmUtKbFwfd6DhY7letuBisMwnAyj+2xQnL6ekbH8irmMgmFtN6PQ2V8KgX0p+P8Z
X-Received: by 2002:a5d:64eb:0:b0:3b7:95dd:e535 with SMTP id ffacd0b85a97d-3bc6aa272a3mr5576797f8f.42.1755503337626;
        Mon, 18 Aug 2025 00:48:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH0ke0nc9qTEDo66odZ0EQpymOQ3CKNEvHMaJr1zCWdVAjts6OlZqdg3tu05ysjljyYRHtYlQ==
X-Received: by 2002:a5d:64eb:0:b0:3b7:95dd:e535 with SMTP id ffacd0b85a97d-3bc6aa272a3mr5576724f8f.42.1755503337011;
        Mon, 18 Aug 2025 00:48:57 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f22:600:53c7:df43:7dc3:ae39? (p200300d82f22060053c7df437dc3ae39.dip0.t-ipconnect.de. [2003:d8:2f22:600:53c7:df43:7dc3:ae39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a2231f7e8sm127205855e9.14.2025.08.18.00.48.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 00:48:56 -0700 (PDT)
Message-ID: <0e613cf3-7ff1-49d9-9fff-fcf824f2df72@redhat.com>
Date: Mon, 18 Aug 2025 09:48:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 mm-hotfixes 2/3] mm: introduce and use
 {pgd,p4d}_populate_kernel()
To: Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 "H . Peter Anvin" <hpa@zyccr.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Juergen Gross
 <jgross@suse.de>, Kevin Brodsky <kevin.brodsky@arm.com>,
 Oscar Salvador <osalvador@suse.de>, Joao Martins
 <joao.m.martins@oracle.com>, Lorenzo Sccakes <lorenzo.stoakes@oracle.com>,
 Jane Chu <jane.chu@oracle.com>, Alistair Popple <apopple@nvidia.com>,
 Mike Rapoport <rppt@kernel.org>, Gwan-gyeong Mun
 <gwan-gyeong.mun@intel.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@linux.ibm.com>, Uladzislau Rezki <urezki@gmail.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Ard Biesheuvel <ardb@kernel.org>, Thomas Huth <thuth@redhat.com>,
 John Hubbard <jhubbard@nvidia.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Peter Xu <peterx@redhat.com>, Dev Jain <dev.jain@arm.com>,
 Bibo Mao <maobibo@loongson.cn>, Anshuman Khandual
 <anshuman.khandual@arm.com>, Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org, Kiryl Shutsemau <kas@kernel.org>
References: <20250818020206.4517-1-harry.yoo@oracle.com>
 <20250818020206.4517-3-harry.yoo@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250818020206.4517-3-harry.yoo@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hRSNofqon12ceV_RMHlB_5ZYt8QP-q6DZjamuIrf0Zo_1755503338
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 473B8140004
X-Stat-Signature: t1nki13py4e9846frnynbdoqwc9ohk7s
X-Rspam-User: 
X-HE-Tag: 1755503341-652372
X-HE-Meta: U2FsdGVkX18LssjK8I+XRdWgE7pvjTArKcMihp7BVPxAvxATCGXitClUL7eCqXbs6q5OXjUS0TEju3f80B5ij9yYUkKxlNWFiY7SIkXYrYlDKcOEcQ9bV6dD7oXUpZ948eu8VljQFYD9dIqJ+OYVVpDyw8YKTD09Opv2V548dDdYfk1B7Qdx269zjXDizI6O0Tr2l9lDKnEHhmAPWqqHCBNn41Toc/wJNy9+sgeUz5vCv2S6TvcPjdiorofjEnAyAM2dUeUCmcMgb7EoKyk+BUhJXT4XBKZETdvK5bm1s2DIHvCngXHXh5PC0/n8Kgqlhv80WTzNZd4h+WIUxZqsHH1N/Y8bmYSV7wPR6f3CQRs8urmPrQVBqouE9e7QEvZMypFP8JpfeiZeGCS2Dqj4Qy3NKio0r/fq8vsLisGHbPcsoQOJMH5eJOgJKK+UZ6fsmDjVs2vqzDPU7gIZ1BCgFMWtXjCSL84OxD+f+syPxhDAWgM5w1Q2WvSaXq1FVSQ49j2y/Fh5s8BrUp76x0Lo0l/cH1YMTS5R0UTM2mQejKYVujERQpyEsYg8sTIzd7iGlXrWl7y5rpqFBrJJjjpe0ySCFs8HjaUQHKuM6DiHkSo6MKWnzK/FD1UTg4IfIsXiLdQII4hpkQILDAeB5iHvaOPULz5bUF9MSUng5Rq0MDqTHNOxwC0aqlBXjigh6NNmtG8BRQF+D+vktRoJ1TRxHcCcw8UGv6nIi/LLQvWO9j9nsa2/fVKJob3UKv6lR1+EAV1tfTzUQOGxbW240KWKl1N9mTCHfbxyBNrClMLoIdeuLXPUwPEn+OoMDNXeXqvemxvKHI0EkLaAvQE83trtoVb9ZziyyrE7i+jXE1JP53LGzmWvTltVZv9Z0a55bU3fpGLzh+HkVacZAAHMjTDtSRzeDPEqsjDueDtBRsJXHuPpTvfZdxqrecRu7cC0rO9YF6M99AaOW4yuSSyTm57
 3O0TWP58
 sij5g9lw+9+6FjK7iXoN5/Ph71nohfrf4TtLVbbhWIqqDjd99uScEoRW1j2pJRl/ta1LLR+KDhFkWDKU9jFg7gJFkfhoFvg3+Bmc34PStfq1eMxuMLFsKzZlUxGCvf/bjPjtSecKnm1/bLIzso/j7Hy95tVUwVHdeTlYW6BTlgES/uuF2i0hSQHF9gqKRX4veHsQ0c8NZKLBA+gyGnGRF8KehFeHedv/QZ+EA8+ftpCJjtN8fC4xgwJ3GBRknSo5T4KeayjKLi16K/Vhwj1ByFfJr6/K7Q/ZEqf8t2cQ7jOjsS/w0JKSrkXHqPHfWuBAYb4LeLP49RuQKJO3dQH1/7pPHWjsPKt/Nu4WMWyBgXU17H8/pcgSQjNHKh8WcZaPwxtkbYau1aROoYVUrZD2US9OL+wm1s6K4sZyaXSz/01iYGbO9m2kbHHDFZJZTGXIXw2+9Des8TXv2LiXtL5YXlx/EYUjwSScyj1Vtq7DZ+ell290ypELHYkg3bhPFqFoLRpj9NdQ39Vihaj6bTcDhRx+3Mh/G2ha9xtHIY6L2jQh00v3M5QtC7ifBVDliNaqqxchyENZdFCGU1aUikans2rx12M7Pfeov7b7t
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.08.25 04:02, Harry Yoo wrote:
> Introduce and use {pgd,p4d}_populate_kernel() in core MM code when
> populating PGD and P4D entries for the kernel address space.
> These helpers ensure proper synchronization of page tables when
> updating the kernel portion of top-level page tables.
> 
> Until now, the kernel has relied on each architecture to handle
> synchronization of top-level page tables in an ad-hoc manner.
> For example, see commit 9b861528a801 ("x86-64, mem: Update all PGDs for
> direct mapping and vmemmap mapping changes").
> 
> However, this approach has proven fragile for following reasons:
> 
>    1) It is easy to forget to perform the necessary page table
>       synchronization when introducing new changes.
>       For instance, commit 4917f55b4ef9 ("mm/sparse-vmemmap: improve memory
>       savings for compound devmaps") overlooked the need to synchronize
>       page tables for the vmemmap area.
> 
>    2) It is also easy to overlook that the vmemmap and direct mapping areas
>       must not be accessed before explicit page table synchronization.
>       For example, commit 8d400913c231 ("x86/vmemmap: handle unpopulated
>       sub-pmd ranges")) caused crashes by accessing the vmemmap area
>       before calling sync_global_pgds().
> 
> To address this, as suggested by Dave Hansen, introduce _kernel() variants
> of the page table population helpers, which invoke architecture-specific
> hooks to properly synchronize page tables. These are introduced in a new
> header file, include/linux/pgalloc.h, so they can be called from common code.
> 
> They reuse existing infrastructure for vmalloc and ioremap.
> Synchronization requirements are determined by ARCH_PAGE_TABLE_SYNC_MASK,
> and the actual synchronization is performed by arch_sync_kernel_mappings().
> 
> This change currently targets only x86_64, so only PGD and P4D level
> helpers are introduced. Currently, these helpers are no-ops since no
> architecture sets PGTBL_{PGD,P4D}_MODIFIED in ARCH_PAGE_TABLE_SYNC_MASK.
> 
> In theory, PUD and PMD level helpers can be added later if needed by
> other architectures. For now, 32-bit architectures (x86-32 and arm) only
> handle PGTBL_PMD_MODIFIED, so p*d_populate_kernel() will never affect
> them unless we introduce a PMD level helper.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 8d400913c231 ("x86/vmemmap: handle unpopulated sub-pmd ranges")
> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> Acked-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---


Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


