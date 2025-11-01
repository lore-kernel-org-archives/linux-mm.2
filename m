Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67873CCF9F0
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 12:14:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6BC48E007E; Sat,  1 Nov 2025 08:14:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A434B8E0068; Sat,  1 Nov 2025 08:14:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 931F78E007E; Sat,  1 Nov 2025 08:14:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7EE348E0068
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 08:14:31 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2BAE9140806
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 12:14:31 +0000 (UTC)
X-FDA: 84061931142.02.A3566B0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9F69040009
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 12:14:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hR6OaIdQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761999268; a=rsa-sha256;
	cv=none;
	b=iUpmDu0wS6CMjO6LjZFxC507x4+9krqNJ8BkiXRknzg7HRWVUElj7+lH2nYtZxoZ9IdGdL
	fdSxS5jhI1BMpFrr4+jD7KJ+AzyGNKrguT8xgD5iurx2agehP/+5+vT8+VVyWbdlt8C7ki
	41jPuu14IdhbKGlnFgbXyOcw02Gwxzk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hR6OaIdQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761999268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o048ati210LDdtQS+FOPO4jSMwtVqN57n5BUaVz6yTU=;
	b=jPXu7vGIEU3rrb0VndbjrsFIQAFUv/jMz0u6r9a4XUSYaw8LcBeSTmOMI3s/I3kLjwGD2s
	LA4fP29Sq0xsQgcqHtYfAVghdw7gf4SyCihhOuNozaRqoqx3GofhR3yVzNTgEYWMATo4fb
	xkOcOj5S7ElgLe0wwL55YoIPndMi32c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761999267;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=o048ati210LDdtQS+FOPO4jSMwtVqN57n5BUaVz6yTU=;
	b=hR6OaIdQ/mskn2JcUFjIcD7cyYV2Uy38kvmgu2Fssn5ZDGGA+jTJWPrICQjJRX90YDApnh
	HcKBLYOiHGS78S3EvQTWgRPDBYYhfZz25B4VIWf2DtjG0RIfPBDAub+CRTO8ei+doJavPU
	onSH+pOIoF8Kt3NRLbAdKKviXA/0yDc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-381-9nXTslA0OIy1moLxE703ew-1; Sat, 01 Nov 2025 08:14:26 -0400
X-MC-Unique: 9nXTslA0OIy1moLxE703ew-1
X-Mimecast-MFC-AGG-ID: 9nXTslA0OIy1moLxE703ew_1761999265
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-42814749a6fso2409576f8f.2
        for <linux-mm@kvack.org>; Sat, 01 Nov 2025 05:14:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761999265; x=1762604065;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o048ati210LDdtQS+FOPO4jSMwtVqN57n5BUaVz6yTU=;
        b=g5GO9atvGRg+GSlg9LHGq3p3E2RjFCDUzJdIw+xToWhuyBg5f0/a8AmoCIK2Fzj83j
         bIRUJ4+JrGADR2GKhrWgKOGOmo4jWMT/R9F9oB+lsZzSk8TWeczA1wMMyVH4RWPjxDCk
         yJK5/1xstgA4aDRmG3isBKHvnQ+Tn7HiQ/Rd0k6FmX/TBz5VobNVtrENW0Ab57gHJjr5
         DeLu8Hh8NWymjv+GL6sCBDUcqXRxqeNzgSWBP47kk6+oaJfFrJntJKVsZ/C5AFoxXguy
         JGtRLW+RnM6v93+Esz8NmXpL0Ukxyh3W28i4EfvqusAZ08x3H7ZkWj2Ldm+CID9DIYBR
         8LoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVO8IPwF7oUcKgvdbuor8zmXIH3FhD/bHvJ6lm5TMzB0OXHz6Zy6ZU3/TE68M4bjBQdzi9m41cwEQ==@kvack.org
X-Gm-Message-State: AOJu0YwhCS/HSiEdHFWNc3DFF5wCpms94uJivWL3/8IdiUrT4azZ7xdB
	FGxNyknmDp8euAObrwuuvVttngF+IB/eamPx6RF7LjTQKFA4GJuQ8kpAY74/xad8okJodezrjDG
	8EsF5YWAaMf6YOpIH5mjSA/rtrd6pR4znfVDo+A97vn+3rMfpbIfj
X-Gm-Gg: ASbGnctDRJj4gYL7SIEeiLf/1+BwlGjfYuioGipUUDLNvfmBSagX5WehkQoK0lQ0cmg
	nfyEp5q3PkztqSPcvyJ4sMdiPKbz0qYCpaIQMLPGoOmqaNknk0W0n1xlRCssqxyutYkeJCJRH4H
	cEL6hYnr6HGGYuQxSOxBzrv6wYWNs32VKGyHVz9NYvsyT/i6k+SwW9ydELkcOL/S/Bo5pVUDR70
	wfWur3doHdnWC3LFqfqa3KZ9Aw6SI9+sPpOqjQ/UsXaiHU6KLpNu5WPln9Ih8dlbTM84c8fkPVR
	sX0yL+9F+/AGpJ50fGT9JYFAlIAgwUs6Uqkd6fce8waQo8xxcFM0Lcx5nEIHm9JtcUOev9La7ar
	4A108/VvhIYoYrfIM8Be10sE/Lj7CQnhXBvU/6AguvV3TzWLGZCZW1xmCsgauAAYQfpRG9BdJ0u
	1eq40xQV2prG/nG7yqulpFG3mJP4I=
X-Received: by 2002:a05:6000:4006:b0:429:b1e4:1f79 with SMTP id ffacd0b85a97d-429bd6c1e9emr5632360f8f.58.1761999265079;
        Sat, 01 Nov 2025 05:14:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUnlqEI4i/IitGbkGmSb5mhRBlBddO47B8HgBUkc3NNZF05OsloV2rMzQDwADfEurYYBklUw==
X-Received: by 2002:a05:6000:4006:b0:429:b1e4:1f79 with SMTP id ffacd0b85a97d-429bd6c1e9emr5632339f8f.58.1761999264653;
        Sat, 01 Nov 2025 05:14:24 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429c10ff584sm9569867f8f.2.2025.11.01.05.14.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Nov 2025 05:14:24 -0700 (PDT)
Message-ID: <5a3ccb7e-9d36-4ac8-9634-c8dec3d6a47c@redhat.com>
Date: Sat, 1 Nov 2025 13:14:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/12] x86/xen: simplify flush_lazy_mmu()
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>,
 David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-3-kevin.brodsky@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251029100909.3381140-3-kevin.brodsky@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OglFlhDm5TdqVOO1H_kd8abV9trEVaN1sDz-bDluEmE_1761999265
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9F69040009
X-Stat-Signature: aa9kpf3ocufhifgygkg8cii5jzo8kwce
X-HE-Tag: 1761999268-930560
X-HE-Meta: U2FsdGVkX19fJ0SXfoTSnyPUhNS8p/flMjYaRp+b2XDbvRwLSEKYJW4ntKI5KKmO2GgVKaptUX/SSeZeUkKTARqSu77rlatBVnWIP3iULEEw+25PUwzl9ouTNkMyPnqiPiw852rVE0YC91UA/eoeMbZCtwXq5dI33au5fTuXH21ZrnH2UkVUSttrl7YiK0sZe7rlHQjz94vJ0aVehIdWdvIP508rapjHGeCmpWF1w/PqOc7bOoMmvkwP1Zd/ncyWgXKxBrCLgSDUTkhNad7UXb8rVyvncRy11kSF8mDFFI/LV1w6KJZQwrCXKcRm13VhlyclMcwPwtzZ0v/UKSSLGxKHQ5mLb3RprlkD7GSJZFEAbonTRpZeAGOitH+AvqLj8IZeJBUe56JGbBd6tQGfVl2e5UzAAryEBY1BF9mRUlX+zhdyQzQSCET+WpFkOtwXvrTNg+P/bOqiJ6LebEAuV9DpkTD1sp1FDF0d5TT6CCuwcxFO2/8ezFNfUk+FlPhrXUwRJZeexl8Fku+XmX0juQr11WQXMMtn994n9xSO3t2DZlHUaobkabNVxBHDhHZi9gmeLo3O+mu5DBLN5N27IhxC1J4d74ei+ATsR1gV6DHcv7fiNtOAP6Gt62f5MPdRcxtIeJD7RVTChDTOTJMfnLxqf3YsmijTndmlAGYyfKZusrROAKTXoUcFvRnaJTqBvwlS66A4dkL9Rmrjiz8ayvAIBCknVrk8IzAbkVvlRs+2Vw0MElOIclAAzXDNl3ZC2veWXl7pRQKgC7ga6FKXjjtm2KkbHOocg3s1PhDBKkltKjsD4nBYfuTQBNQHONnu2xDB3yT8IP5mecv+Dr5+1rAc20yN/QNeCy2p+DzC/Zl7q+tll6a9jX2o5Uz0cfbOr+Wx1qXuM1UIqq7itkXp5OEuL8ZBQvL6sFijP90x6GkTyrGCmqGJbAaN2Txt/Tn200hAbinobByJ41YcL7F
 219OxirQ
 BZTYzve+u+gdx+2j4dK6V8Ie8srkfAad+Vzuwc0rWXFX0UQOWoDgFIy9kg5xng9lQXN4hh2u+KNP7A26Em6mnt63+a4eCpGQddWG1nRFlMzrr1uljgSEQTrDAHyclQnfYNmQ49+Q5/viTsUyF3T5m7AQY+dB7U0j97585MNweV0d2XYGz5yCN9BIBK2/ShHylTN2bKTTmNQQqGX3tChLVYrh7sTaY9NEeDv7ealXTYIZgAoXYLNd8lUuxR0Suh80bJodEtt5wdVwfhA9rNzmsUwZt/4CG9KmDFLpNwPy8iX+ue82bx7gDNQbsigUw7lat5x/By4HC2fX73yu9DXBvx6C25xJYHps6gGWS773T2aRl2me12BfdR9e7OTT4o+YbhwkmYbrVnOHFAyDz7LZSJM9Tdr9nJBGx6KhNDN/1CNjhZd0e/dFs/uqwu+BpRqcbOYK7tEK28XsW9DvIKJrv3EgIynmOe+QSbnxd2JMqke+nOKjFhX2MpTH8czPCoMKSnYoAi9E4/7LfPoTkSjy2YN/mWAa9fCNaX7k89vpy2jD1IqXYwDKIDJW1VxErfmnPfBgaKsSG5odf2aHoT7KowyHasnfGuVqDkk9x0o7d3GkijsN8a59CzE88WvYXNzZi1FcAXsK3Lk5WQ97Z94AGt4k7EcWPzIeQK1MGUsGrMHvrVs4j5UtVkoBBqR/h7r3HPmarGgxiLCRoHTo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.10.25 11:08, Kevin Brodsky wrote:
> arch_flush_lazy_mmu_mode() is called when outstanding batched
> pgtable operations must be completed immediately. There should
> however be no need to leave and re-enter lazy MMU completely. The
> only part of that sequence that we really need is xen_mc_flush();
> call it directly.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>   arch/x86/xen/mmu_pv.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
> index 2a4a8deaf612..7a35c3393df4 100644
> --- a/arch/x86/xen/mmu_pv.c
> +++ b/arch/x86/xen/mmu_pv.c
> @@ -2139,10 +2139,8 @@ static void xen_flush_lazy_mmu(void)
>   {
>   	preempt_disable();
>   
> -	if (xen_get_lazy_mode() == XEN_LAZY_MMU) {
> -		arch_leave_lazy_mmu_mode();
> -		arch_enter_lazy_mmu_mode();
> -	}
> +	if (xen_get_lazy_mode() == XEN_LAZY_MMU)
> +		xen_mc_flush();
>   
>   	preempt_enable();
>   }

Looks like that was moved to XEN code in

commit a4a7644c15096f57f92252dd6e1046bf269c87d8
Author: Juergen Gross <jgross@suse.com>
Date:   Wed Sep 13 13:38:27 2023 +0200

     x86/xen: move paravirt lazy code


And essentially the previous implementation lived in 
arch/x86/kernel/paravirt.c:paravirt_flush_lazy_mmu(void) in an 
implementation-agnostic way:

void paravirt_flush_lazy_mmu(void)
{
        preempt_disable();

        if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU) {
                arch_leave_lazy_mmu_mode();
                arch_enter_lazy_mmu_mode();
        }

        preempt_enable();
}


So indeed, I assume just doing the flush here is sufficient.

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


