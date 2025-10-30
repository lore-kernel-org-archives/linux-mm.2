Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2EB0CCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 15:45:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 372F928000A; Thu, 30 Oct 2025 11:45:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 345E5280003; Thu, 30 Oct 2025 11:45:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25B3E28000A; Thu, 30 Oct 2025 11:45:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1587E280003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:45:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B20A71396C3
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 15:45:56 +0000 (UTC)
X-FDA: 84055206312.18.EE1B5F8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 218C0140023
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 15:45:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TwblnYxs;
	spf=pass (imf09.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761839154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T13UVO1/yPlQk6T2PfurpgHZxHJlbT6OmTkCB8QWscE=;
	b=MZ9mBlKYhDY4dn7eH0TlFs7sXqJwu4uOE8ElFes+XBp64NNBpHedazUf3ZwxRZRbSACTxn
	VsD5KK0w7fdXk0iuNyYl4d5vqCjDtLLCd/cgwG26l2XEG0douB72iLQzJR5bT2B9kjbH5l
	jCjJKbW/c5Otu6D8i8oPB7KJCdr8H9c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TwblnYxs;
	spf=pass (imf09.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761839154; a=rsa-sha256;
	cv=none;
	b=S2mylNEWeZLs3XdmmTbTCrRe1syQ6z+V5xdcuxrUqTwxKrZMbc0WO/HANOVL062XzIx68N
	KRWsbBvgELWTnWjiKDVKLVO4xjh3Mt9gj5/k4YnOqoF+JWunlQZWUlQhGuop/ZjHDviPHH
	pfZo1oOv+D0G5XWH8At+ZCvZ+4wEi18=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761839153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T13UVO1/yPlQk6T2PfurpgHZxHJlbT6OmTkCB8QWscE=;
	b=TwblnYxs17S14Fub6Z21eDwZVwSELZgpcy0h04DjAZHGHYvtfH6c2cCD0z/KcKPzuBP7SU
	9R3SueY7hhNGZAJE4nOOR+53WKfb2oMJ136A08xmSZ3Gg+O0632lisgGbS+IySJm1fLIBa
	EN3BrSGvGw4rx96zmpOjHPCu/O016wA=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-493-Kp8wjWWoN_S7SkcgUBgvBw-1; Thu, 30 Oct 2025 11:45:51 -0400
X-MC-Unique: Kp8wjWWoN_S7SkcgUBgvBw-1
X-Mimecast-MFC-AGG-ID: Kp8wjWWoN_S7SkcgUBgvBw_1761839151
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-89ee646359cso333958485a.1
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 08:45:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761839151; x=1762443951;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T13UVO1/yPlQk6T2PfurpgHZxHJlbT6OmTkCB8QWscE=;
        b=iQqbg3dCpjEsbaj7WM5EBiipLyKICiZr8SqcFNIAPj+chZ33sAefMrCkX7dfTdtW7g
         f4z8XuJoC76REWliXWzSJWpfA+XBBFEguIhmFJDvdYwT1MxwNx0gUAUgXLQHJQ4sjadZ
         m23yAx2voh3JoCXMRyv4hVdWipOAjhFRnHnEEhlmTqOGO29bo63R2vC0oxdKmt/o+NSF
         DE2hScJJVHQ+9AuBhOsIRbS934/JQqzPWc+AdghwroOLyx1Rayf01ClFNGKutzSHf0Iw
         OvAanb1L+uRR90eiYn4kBCmMFbKBirYNvZHu75bD5JC3WpC3ggvIelGILjVx1diRFtsX
         CHRQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZ/WppC6fbIuEnYw1qYConoUcirY1ighIE7FwU4aDCSbdZw6bcXIIbTQTSBqJSLOXhv9OUel62nA==@kvack.org
X-Gm-Message-State: AOJu0Yw/amffdK4pmUEJLgqtqOgjE/tRjZT3rDvUzTKakAP+4mI9rn6E
	XN2AXOfrcDCkMoaF6S74cVlMyOvDF4kwhgK1XujmVwE0eNYgqXA3j+OnBgSAc39gdbdiKEQ6Uh5
	sNnKpZm2qMWZw2rAy//40mZl1JtmuGEyDFZgG+ExjsuPGqFCMS+ue
X-Gm-Gg: ASbGncsUbhYzjjWk7aCnQPrRKW2t5LPTIPErl8I0xBgt443+I5TOUYPml0aFMcksvqP
	J4qTgfb60WzFEAcsBpoNi4QFB+UPmaONSVkwuVrbznoWAuvVAmhsXLmawQYv1JNHkBW2E6zLL83
	4IuX7bqnHKHP83hVJ80fK7oAjHFzAuC7fhvg8zMPB1ba73G3EQeuGTxuytxFIVyD7xFQSNHYfNO
	hkZvieMycAol0MEDF4jMShh8zUQFSV/kIPZAexVcErRc1jzpIRd8Un9akhcswEgpQLXy/t4yVqQ
	CT+OJUNCl7aiLySyQK6S2dQb7AJy5Lu8T3Wy6qLKqn3LwQTVHPQJq0Wo7vKk/tGVXJLlqyz9mCT
	gGQ==
X-Received: by 2002:a05:620a:2a07:b0:8a3:e51d:63c9 with SMTP id af79cd13be357-8aa2c659146mr496985785a.25.1761839151197;
        Thu, 30 Oct 2025 08:45:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEOqRO+7KOnHpcS7rPlmfWuNX0n6FxKFT+Lt8fIFSIFDsOADI0AQRhPYfD/wI22ZJMDrMWM8w==
X-Received: by 2002:a05:620a:2a07:b0:8a3:e51d:63c9 with SMTP id af79cd13be357-8aa2c659146mr496980385a.25.1761839150640;
        Thu, 30 Oct 2025 08:45:50 -0700 (PDT)
Received: from [192.168.2.110] ([70.49.125.126])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89f2421fba6sm1289506585a.4.2025.10.30.08.45.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Oct 2025 08:45:50 -0700 (PDT)
Message-ID: <d491b540-8984-4ffa-9a79-ad6855e9c883@redhat.com>
Date: Thu, 30 Oct 2025 11:45:39 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] s390: Disable ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
To: Heiko Carstens <hca@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>,
 David Hildenbrand <david@redhat.com>, osalvador@suse.de,
 aneesh.kumar@kernel.org, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-s390@vger.kernel.org
References: <20251030145505.2764038-1-hca@linux.ibm.com>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20251030145505.2764038-1-hca@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lB7dSZ489B6Y_0iE5UAxyqKfRJpe0zpfd6mQfqtzKCo_1761839151
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 218C0140023
X-Stat-Signature: h6fgcj4z7ghis71f86s4dzctogngztoo
X-Rspam-User: 
X-HE-Tag: 1761839153-376091
X-HE-Meta: U2FsdGVkX1/jeq3f907Yk+3Q0BRQ6RHJKhioHIuerWxYqm47im2juVZ4ObEnqDEdH1ZfnolwOxB+/6aok8WywoWx1kd7AjNiBJ+I95aPLa7u665UV/uX6EUqrvZvCNrM4bFg6eMIy7GGJZwxnUOtp/zP52/4k/djevxG54ylvblRKvUISuGVqY4lhe9LVtb1az9aPkO0MpizeW2tRQKq80xF+s62lkJ93TycCYXLIZdFJTPK6cYmOarC8oTR4FtKOm1ECuUEp+Awec1d+YllLMiIoMR88PlBE5dmm9B6+355Ol/HYbEUN+zMThBLOVfIBJTpXU2POXrN+1DmykaFRHvKNS2MjVBeeHESMyWBEGf6QMrEJ2jLUheXw/Y8Ajf/6Acrq6a7coo/CYZD7Wxkj93sETZCiPJuKf6mDOKGfDPtlpzVQEfKmRagUgGojWS4MVXN5bwEUELrGiewgJsit1xk6mBWyzWdT/gv4hG0Mj54GiDqDD9Pxa+HgK/rD1rFEsuLxRVwDeCNnmdTP8rwadCVgcstCKcAUIP4uVBLaD2quK29fTU5RjdPqS9/ZgIYgYpHbWaGjw0M8oUcwM15kpoVN87QhCgtTVJ4OsbLtLvBN6xtCc9qHP/Q5zFkspJHDL5rmnvQchGw+fcA+6fBAQbaI33nWdEMVPgE0d6j7ZKzU3jv6JejGcH+CD3cgU5nwOcMnt32RDJpCo3jRs85Oea6l7zNiUDpY+plpeciesfIieg2+3sISkXgjSP9HDyylnXd3YAIj47yDIXMDdjrUeP/QljnprwO+VCANRLIaOT3o4IW4PfExXWM0jq0ytePzHdczRdWkHfYA0u4I8iaZcdjMbFdIXSd0p4z0vFFLjQIVzOPXmaebg49/OC4cBSb45raMoQJOBNHZSXYkxiLqZKoRMom9nAP4VkA3LCalklQZEdg9ewArr/hiRvJi1WFoYSa8flxSOPAc6wcurK
 2TUJ3fDX
 0J+EkB5HGMauR8IxRcNk6JAO7ZGx0YSNM32Dk1GrvSFAHvVbmmeZaGWFa6ahPYmBjQvphSz0WsXtWNtx+T/zw0g5AuWShjNwdNsBD+0VOhIVX1q2YFvDpR8p0egcZe0t5vbetKCz+G//8L2Rgy5sXCsNn5FE2Fn33u7ZoedpzjJC/XHHX06J0O+8B4JBnTyHIlsPMipImXZrefNXXaw5kw5S/hhKfLFnUYcPPpI/lJWjYqR/+3IhTG5mA36rejRS1jK2BuDZpyHsEAPZEb3eswmehuyVP2RkmxKO1C3Z5Z1GWEr6ezik4b7P8/ChHysd3eoba2FcrpojZlJA+S81cOFbI1H7NSXqwqbZoAKYcfrEcKMDaxcggkAGCCva4PglMjY1bAxnr1MOov6Na468/S4P4x7shU9+359m6u4/MgeVoPJGt5WhH8mKQD0ZCNOmzeG90q3IoT5prOU6UUKZQdBw949HurbX5FWB28YSqUKKDR3UPh93jLAGlEHGcqvVE333+6rG0SlazBhwgDogaPvot0sev58Lf5L7+g07J45JHo1SyqyhvPK/7TQvCjeZ2qw5jIBfZuLIauUj8BMZ5XIAIP1JQ2lH/9iE+c7aC8o273DaRtl6WbyARaQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-10-30 10:55, Heiko Carstens wrote:
> As reported by Luiz Capitulino enabling HVO on s390 leads to reproducible
> crashes. The problem is that kernel page tables are modified without
> flushing corresponding TLB entries.
> 
> Even if it looks like the empty flush_tlb_all() implementation on s390 is
> the problem, it is actually a different problem: on s390 it is not allowed
> to replace an active/valid page table entry with another valid page table
> entry without the detour over an invalid entry. A direct replacement may
> lead to random crashes and/or data corruption.
> 
> In order to invalidate an entry special instructions have to be used
> (e.g. ipte or idte). Alternatively there are also special instructions
> available which allow to replace a valid entry with a different valid
> entry (e.g. crdte or cspg).
> 
> Given that the HVO code currently does not provide the hooks to allow for
> an implementation which is compliant with the s390 architecture
> requirements, disable ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP again, which is
> basically a revert of the original patch which enabled it.
> 
> Reported-by: Luiz Capitulino <luizcap@redhat.com>
> Closes: https://lore.kernel.org/all/20251028153930.37107-1-luizcap@redhat.com/
> Fixes: 00a34d5a99c0 ("s390: select ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP")
> Cc: stable@vger.kernel.org
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>

Obvious enough change, but FWIW:

Tested-by: Luiz Capitulino <luizcap@redhat.com>

> ---
>   arch/s390/Kconfig | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index c4145672ca34..df22b10d9141 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -158,7 +158,6 @@ config S390
>   	select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
>   	select ARCH_WANT_KERNEL_PMD_MKWRITE
>   	select ARCH_WANT_LD_ORPHAN_WARN
> -	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
>   	select ARCH_WANTS_THP_SWAP
>   	select BUILDTIME_TABLE_SORT
>   	select CLONE_BACKWARDS2


