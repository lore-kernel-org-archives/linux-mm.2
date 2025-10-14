Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 122E8CCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 14:38:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B7488E0132; Tue, 14 Oct 2025 10:38:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5672D8E010A; Tue, 14 Oct 2025 10:38:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42FE38E0132; Tue, 14 Oct 2025 10:38:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2D0298E010A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:38:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D2DE31A0920
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:38:14 +0000 (UTC)
X-FDA: 83996974908.16.EC69932
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 92B1C140003
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:38:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TigKQdVl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760452692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y2/pl56RibYUoklQ5dQ8O9eQmT//+IdeeagASCrWmlc=;
	b=dGPs2vFcM6uKr8PXyd2EdiEX0tdDzG95iVJji7CTSdzCGIWuga2mbfpezsykBlhz6MHFdj
	pAyT0o73yA7XZ4fBZoek9uY08dkyUaWHtTRwmRIb3oZRItAD3HNOOh2OatFwdQfgL3QNTX
	wV1qIVZ7z+rjthI8pxyy4maN4MSRqQY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760452692; a=rsa-sha256;
	cv=none;
	b=ZuGox4PWUVVJtjXxntL0oXRJpuBYxzeBoVgyLpoFSmW+HZL20UxBunC65pf7IdD45/I+wE
	jZ2ya4WnZC87Rm+7ehtAAokV9iSieM13WpH9xuBhYufDBymTz1XSyfFN3ViuOgG2sfJkWP
	4iTs0P7Kl50YiCGy1q837KXNYqwaM/k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TigKQdVl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760452691;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Y2/pl56RibYUoklQ5dQ8O9eQmT//+IdeeagASCrWmlc=;
	b=TigKQdVljUsmo2NYtNDuR2EG9cDGcCbytnLJZpLYkARNzjucfDDoknq7oqgvsxNVb5xn4y
	ZLJE8LetbkKEYtTpHMwdJEPSYNLHbEvaPT5KSKBLfGazEDyFBqTv9mxdeHPq62UZfyPeZ8
	KCIJyJZfl4U8ziZcdkGAdMn+QFTPdmY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-570-lkiArNBSMHmpBGpZ-oBVUg-1; Tue, 14 Oct 2025 10:38:09 -0400
X-MC-Unique: lkiArNBSMHmpBGpZ-oBVUg-1
X-Mimecast-MFC-AGG-ID: lkiArNBSMHmpBGpZ-oBVUg_1760452688
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e2d845ebeso35882375e9.1
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:38:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760452688; x=1761057488;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y2/pl56RibYUoklQ5dQ8O9eQmT//+IdeeagASCrWmlc=;
        b=aDaP1h7Anp0YK60jHKZ4mafDz0NH0myW1k0E/jylMgNp6Jxx3rl7ioQpYo1RBqvhvZ
         lpmqFu28gzZPX4/jkkD3wk4esbjH0MXWZlD8SIi9efGvl070WbedrUxlC/7Zi9i/Yk9y
         JPudZykdaF6c+AI0acpWWtb8rfCySw9ig/Vy8t/tdjgH5P3tbTPaiWAPs/PBduCbmcNa
         Ilzc+dTc0h6cLpVPQnUdT5lo4Aj4rHjiLEcq+rTmcMW9e0wajq6R3+epCrD1B0zHUQot
         IyVx4MqBrvDMnx3MyhjGq6N/6EYE3Q9pg2pztZdBnUczWDf0O04/0uKDEGZWxhDZF1z4
         8rmQ==
X-Forwarded-Encrypted: i=1; AJvYcCUPg9EvD5P3BZxryLZ8xFu/QGCCxI0ZSDG6pORU6JzQEo8CmPmmBjpQz5+KSoO+1JKldOptlqCc7g==@kvack.org
X-Gm-Message-State: AOJu0YwA9yReUHobLHfaihMA5gtCQWC8UToRDfAd2a6rgd5b4RTZ428N
	vyNL2ZNSzdKKDCmL0MHoRpcVzElxFk97yVaow0hJWj+wP+JpEsieerEiM6umxA9M5P/0b+ai2sQ
	ZvCWSrx91yDU0GlIIbyH+QPCiugMgzcwHZ69d1263CSlkUTfex/wa
X-Gm-Gg: ASbGncu/TatKCqHgGyjnpNcyKroLCv6SqKmRhEOft5fw4L/IIsF/qu4dtZqWwH5X4Vg
	4WsPxlfVyC5hUko+SbiHTMlzEjW6GCT6WwX9jIgeJAeCcFfFUZkMAzyTmzc0bQR7DlzzvaPfLfA
	aoLwBa/eewfJadWyCpYXpjdVveKR4NG/zJ8G4pgBDbGg4sQd7jUzU38eeq5KaG6CVEsIjuq2HWI
	pJinoRlCqyR24RA7hHz+8E6Q+4LMAlQ/ElHDiNlUifoDiBuNym9hIcAEFnm4uPcr5Aa0xgtEWQb
	OU3mAxywnNIHEfv7AkvfADEKC0H806WX3kj94//lVNEdttFtrIO8XQydq3EZRvfyGzm4Nbuy7g=
	=
X-Received: by 2002:a05:600c:c083:b0:46f:b32e:5292 with SMTP id 5b1f17b1804b1-46fb32e5338mr100816245e9.8.1760452687901;
        Tue, 14 Oct 2025 07:38:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH+85bHywL95AGPc4rVVpN4sLObPxyXn+eTRLQq0mKm3kp+YVI++XU9krnHNWQYv6fsnjY3Ng==
X-Received: by 2002:a05:600c:c083:b0:46f:b32e:5292 with SMTP id 5b1f17b1804b1-46fb32e5338mr100815935e9.8.1760452687519;
        Tue, 14 Oct 2025 07:38:07 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb4982b25sm246894965e9.7.2025.10.14.07.38.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 07:38:07 -0700 (PDT)
Message-ID: <2861a35d-4f8e-4ee1-bd11-b915580c9ce3@redhat.com>
Date: Tue, 14 Oct 2025 16:38:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -v2 1/2] mm: add spurious fault fixing support for huge
 pmd
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Huang Ying <ying.huang@linux.alibaba.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Yang Shi <yang@os.amperecomputing.com>,
 "Christoph Lameter (Ampere)" <cl@gentwo.org>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Anshuman Khandual
 <anshuman.khandual@arm.com>, Yicong Yang <yangyicong@hisilicon.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Yin Fengwei <fengwei_yin@linux.alibaba.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20251013092038.6963-1-ying.huang@linux.alibaba.com>
 <20251013092038.6963-2-ying.huang@linux.alibaba.com>
 <4c453dcc-2837-4f1a-905b-3462270f5e31@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <4c453dcc-2837-4f1a-905b-3462270f5e31@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hyHcyFpMyhwSslQ-gsMjnYsRkMo_poinCnVII_LNdg4_1760452688
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 92B1C140003
X-Rspamd-Server: rspam02
X-Stat-Signature: omyaiaht7rh9qunk5675ow3wcgre4pj8
X-HE-Tag: 1760452692-671700
X-HE-Meta: U2FsdGVkX1/DJ57su5e2uCPm1CR3IZasr4hjnuM5Hc5JMl5cmWbBftASRkHbPITo7A793ZDTXiSoNq0/mFOgbkRWDJckEJ3GafoDlEdysutMKSdHX8pZ/gRP+fQ5+31YfWGX1Aj9+TCKGF4hAyCOWD5pHToL0tkHL8ONvZ1pgkyrS2Y/3wtIrqrRlGNPxTBAzPhTJfqH8Ncr2OYif9IzO4bwDc72POKGIFRZecgpqmoeNlvodwNsn8XTpbz0kn8PxHe3Gutkas2V37hgYyLKjD+BXqOINzdjE1QoYaJgjph1+pjEpYXpvMC2Z3kQgguCro16gqvn8Dg/o86e/iDYRR1grtBtTHuA7bFHO2WzC+R/llVVLQgEq0CmFGB4z0wQqgoaw/YgENlY+bVW7lw2hVCqh9ATy0z+Ctg4pwFL/nixqyjhRKuABJXfOdVapBSZ4KxLSTSlmQ9zFxgzpQCg/w8RZY2X86vOQMQYJ8OqZ1THBQuOfb4dig1DEIG2MGAShgoJDjj8Z0l5U0eagFMquhlsc+OZt9pE+8DLtgCxYccR1HW7aOWIaHEg+ZFUezBvpaSTiWV9SNbsgpKtYBD2FM+Z2Z7so5rwBsNEXB6Vsc5G5Z1PfHE3nVjP7y97gKlb/R/ISV2lw6dwe/qZYoYX/lKWI2AFMcT9uCmWHwfhu0G+L65Wo37stTAQDbjZH2iPxCKUfC1CVEUsTP8QH6PI1FDqRvBIVL7AiRjO04vQGt0wuOVec4kapLPtRSbxVCvhnX2GU5Qi96Y5hcWP6zsC0CW78dncQ9ctqcHcPvP418UqlRSgq++OrwagjwjvBohslTqTcId/SwC6bnGjc9YZjGW5kka2y9zLHW5nwqg7qYWnDM8wtQR0EzAJYfddv4t7BKMG7fwsQGM4t0Soy5dEpXaM+BS1JruGGlDHB3MzR91NruXwyr2u+vHkqUlgv/jqAbNzafHESqYstCyowP0
 2S08sl49
 R2AZlbiGyLH2PK+gvkfTyc7RJR5WJUHwHRUd3NF+Jop6tEGGFkAfG0U3CkuRDikoZ729t06FuH1s6gjiEbQP09q8FXpBWGLWrMu57V6c9j4Xr1caGAwzJlNOtTxU4fLCWJBy9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> 
> 		/* Skip spurious TLB flush for retried page fault */
> 		if (vmf->flags & FAULT_FLAG_TRIED)
> 			goto unlock;
> 		/*
> 		 * This is needed only for protection faults but the arch code
> 		 * is not yet telling us if this is a protection fault or not.
> 		 * This still avoids useless tlb flushes for .text page faults
> 		 * with threads.
> 		 */
> 		if (vmf->flags & FAULT_FLAG_WRITE)
> 			flush_tlb_fix_spurious_fault(vmf->vma, vmf->address,
> 						     vmf->pte);
> 
> 
> So I don't see why it's so egregious to have the equivalent here, or actually
> ideally to abstract the code entirely.

Let's definitely not duplicate such comments whereby one instance will 
end up bitrotting.

When talking about spurious faults I assume the educated reader will 
usually find the right comments -- like you easily did :P

However I agree that ...

> 
> In commit b22cc9a9c7ff ("mm/rmap: convert "enum rmap_level" to "enum
> pgtable_level"") David introduced:
> 
> 	enum pgtable_level {
> 		PGTABLE_LEVEL_PTE = 0,
> 		PGTABLE_LEVEL_PMD,
> 		PGTABLE_LEVEL_PUD,
> 		PGTABLE_LEVEL_P4D,
> 		PGTABLE_LEVEL_PGD,
> 	};
> 
> Which allows for sensible abstraction.

... if there is an easier way to just unify the code and have the 
comments at a central place, even better.

-- 
Cheers

David / dhildenb


