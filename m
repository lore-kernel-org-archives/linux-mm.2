Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17E6ACCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 14:34:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 437838E0009; Fri,  7 Nov 2025 09:34:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40FDA8E0005; Fri,  7 Nov 2025 09:34:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3260F8E0009; Fri,  7 Nov 2025 09:34:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2018F8E0005
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 09:34:11 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CC4C0B836A
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 14:34:09 +0000 (UTC)
X-FDA: 84084055818.16.58CD726
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf13.hostedemail.com (Postfix) with ESMTP id C6A8420010
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 14:34:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Qrkk//vx";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of davidhildenbrandkernel@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=davidhildenbrandkernel@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762526047; a=rsa-sha256;
	cv=none;
	b=WoGmE6llDOzKujU8wfs/sbfn6PBIkYlmSc3Lmjdyc/LamXtUJQA37BjNDoMnG4ZYBsV0L3
	f/uXkNErW9iyIwGM3hV2veZiW2Ig7izgjZbRpKOJBt5KssdJx240MaMX0E5znzoUoOL7dt
	8heNBhn72Dh3zOuIVpvuaj0BUFYq/P4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Qrkk//vx";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of davidhildenbrandkernel@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=davidhildenbrandkernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762526047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U9gy2Et/tdx42KkCuY9tv69YTLaLyxM7iG0J3rCGUz8=;
	b=I+1WKxdI/zNa9fdK+P9nS2BKizH5k38sFK/eWrN+9Ap+sGrrCwCgX066mNGapKQ0AkGT4X
	g0y7Xt7sIZDvcOXiryHa6RID3PPwwIOojb+pB+FhI1XyRgvi7YFTBm7ynfmn8W1DGmgSYM
	CXu/3JNNLdbFgyJa5zTKjtSkh/paKBI=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4298b865f84so418844f8f.3
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 06:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762526046; x=1763130846; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U9gy2Et/tdx42KkCuY9tv69YTLaLyxM7iG0J3rCGUz8=;
        b=Qrkk//vxUIbcrCQO9dQ1bqjiv6koLPdd+XyopZHOyrCnP/SAkIesIoudiZhlY37I3K
         FkEAdI7z4tmSu7YA1Y3pZPYUzuF/nxr/YBN/l3GQK41EBUGxSAS5I5RAUE5yXGMixtqE
         f/DH/gHjYv3WFz7YZ5s8M0ZnrnoJrGXD/liG7CHuh4bLIhX28ESrvc2CX9O93vot4Tnp
         TjtqwpSjtZMONMxUnQYjX8AKOCCxvWozQ6Dq0urpUHUUIOzhCTpjLTuMd5kcGmZxXWAy
         ID0P986YcjtwSkfCY+eUy+ozEPzdh1pvk7zLvDdE1r8ZmhW1y0iCSdnuBnRvXpy9Av3t
         8IcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762526046; x=1763130846;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U9gy2Et/tdx42KkCuY9tv69YTLaLyxM7iG0J3rCGUz8=;
        b=s/CQPlM0EX8aEpKUs7vuoCP/5GYX4JvkdJ6ab2nwcW5MGISsU8foeF9AQffoyNZJfg
         WsIww+4jEnHIIQfmF3x45n3MgflZVZXeTsG/QDtOLxpZ4tysUfdIp8WzHTjnvSNKWoLD
         rCNRfQixTVuxe3Y6epOSOjWglTtmmJvgl075eVahjX00XGkd6O35KM82dZifvR1GABOj
         lIdL7H3UxGtuwVtAwWU9+TIj1Xs9FWgOePEcAWrBDuGuEEIJnKRlOUhIEmCt1zfEUyAf
         7WTW/OkLWVsVMa3KUSMdXTls7Y8lv0didJi310gl7qgKI2quQV8NsX6NsSs/RAxTb11s
         Wwlg==
X-Forwarded-Encrypted: i=1; AJvYcCVyijGRA0SKVXZ+mvVNMY0NHKuZ1RdP+6eQEJDSJ5eeQdRFcZPGd2hs92jgdVN5lj977g9gjw+1fw==@kvack.org
X-Gm-Message-State: AOJu0Yzl+v09J9PJOdgO20tSoryE3VMQ9nnU4rWXtmE2nNT2P6xYAi8L
	yGAOGJQPc1c+P+Q1SOSTI7Oiir9/gsnZlYclnHh+Qr905H07hOVq52zG
X-Gm-Gg: ASbGncsLdyoZE6pm0IGz3PEIQpSoBqtHSXWvhrOVFZpNVod1EEcFZmKDVoz47APztN4
	ce9XjmJ9VKx81OCJKNGzMKPp0F8Pnwh4GiK5pBwGr4ZxvymrXRBuTlDYJDqLQjvj62p6aGCWiMu
	SJ7AcwhFUlBSkjP1otLW17oTwQ/N86/+M0U6Rfb1iVglN2iIFOkfG0HI9EelHAM4nTY1MfRWPfz
	yj+OH9GHItVUQQ/RYfSGVSUvY/8nyWiF7ZksMxnDO4+19cWHKCinrwniYRUj75/AnOfzUj1dy2E
	GFOHpI8jAHksgoigNSAX0piwOT2ORet0YsC0jH+lIyR+Qo7Kcrwd2ZPX72ezYlgWl/iNtKPQ66S
	x7kK9zY+s69w70GpPWaaEXaM2HHekjbTnL0pYTK05CUq5lePRnl8KkBNpZatd/CrMgckUKyGI2T
	n4JxXfS334THc4nZlJyLsiGP8v2s3BmY63hhNNguoY0Yc5PD+udeYaHq6g7Ob4rDYGe96nS3GhT
	R2O+rBQXNb13nj+qhCGSW7iYSQa8l4=
X-Google-Smtp-Source: AGHT+IEbeI8C8CzNAXSH/bs89gWIf/ZmK+BLjDzXB4QFwcXH6hASOjwiIfYomA42vxdn493DYIICBw==
X-Received: by 2002:a05:6000:2084:b0:427:e1bf:13bd with SMTP id ffacd0b85a97d-42ae5adfd73mr3148986f8f.52.1762526045768;
        Fri, 07 Nov 2025 06:34:05 -0800 (PST)
Received: from ?IPV6:2003:d8:2f30:b00:cea9:dee:d607:41d? (p200300d82f300b00cea90deed607041d.dip0.t-ipconnect.de. [2003:d8:2f30:b00:cea9:dee:d607:41d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac67845ccsm5465086f8f.36.2025.11.07.06.34.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Nov 2025 06:34:05 -0800 (PST)
Message-ID: <c764489e-0626-4a50-87b5-39e15d9db733@gmail.com>
Date: Fri, 7 Nov 2025 15:34:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/12] mm: introduce generic lazy_mmu helpers
To: Ryan Roberts <ryan.roberts@arm.com>, Kevin Brodsky
 <kevin.brodsky@arm.com>, linux-mm@kvack.org
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
 Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-7-kevin.brodsky@arm.com>
 <71418b31-aedb-4600-9558-842515dd6c44@arm.com>
From: "David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com>
Content-Language: en-US
In-Reply-To: <71418b31-aedb-4600-9558-842515dd6c44@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C6A8420010
X-Stat-Signature: wrzzgae4cin5h75turus8swtnjk18ztf
X-Rspam-User: 
X-HE-Tag: 1762526047-198651
X-HE-Meta: U2FsdGVkX1/NdltpxmVhYogCYOux3GOXTK6MuadRya43GA7IXLUZFTmidsim5EklqD2RgNR/nApri5Ztxfk72SANFWivPnAC/jrnh8LmZ3M/OlM6Wj+aOM3OHOWn6mVtLzHzBe8u4H1VY8oEkkfmeSt8muX2Lt1EP3b2DNdnjZlcL9S7E7fwfEpulPd9zx/ObqqZvzwZOfVN3oDGY/HRqbsIOMBgvtp78xGwesp0oNGFGo8v6d85epPu28D2FAVC02nC7Ga1INHNSAmYBodLGPykTHOcPHocX7/RuDHPi9JUtfLTmBdFo9/ap4bxc7au4l7ZZwu9o6lHkMR92qGbQLdfmAh/ZNAl/VnGCxwIiLPNXWu3ZLdxpF/wfQPh9J2hOeY3bAjYvBj/l43esVVnmqs0NqaWPatFk78S5eWb/r9mBJ/I5dL3KsC0laI+hF7U3vs1ousWU77EcybQ+Si0/vSk1PqccQ3aYYytOyeAzb0mLZXgVlmlFsh3JmHrAmrzgNDhb5CvAD++XTbOVVONOfLunHg85Af58vW5/WDjPGB5VhiiD8SPEQ0wHcpO+SRvnQVXXhl9VK/Fg2uRVJTQkmcDxqUsbd2L4koH+xMHlPxE0VlYssB99ZdHss+6mHcKYur3H12r8JqthkfzFrSnvibsW5z0ZYUiJwu1qrfm2wTCbfWmHTVVlVR55zUgv4HI71zm7xJ63Gw1jKtznNdqbVsPMn+oLtbw30GU5cHUvBC7xWgvlp3OiD7iYZcJLofYs+6VHSBSgU5tRFg5pxUNmBxv/z9ry8cHt5UNae7k9Uy20+Z386J7H+C8jFzvoqekEqnNZQGiEm+Rj6JWqIAgi26BBhvL+CTJI2vhuedcBe/42rhIZdMhjELsxsDrGbJ1XqM9OBRHlwQn+cs9s7ymcAIV7tqna1dUiJlXblvKapp+EJmChbHuIt+CZZ0HJTHN09YTKDqyyov0bGH+P6H
 TVt+bglY
 xiF1Zhs2IxmD+Ew1UQM5x+gSfMa0uqtmQceaxaHUUnSmhr/0f6LrDW7xyli0pCYp6TG6RGvnXukFh0+F9//KZW+i3TyfsTZIJYvGzwG5vns5P7/BpdzV12in5sPGQHHX6qqBFrz9q9zm/+GtJfmNFeDV1F2e09rdP9b/NBR6SMSRIIp0TxCtvALVJBRf02YY7deq8dWi72s+C4VkW2F0VHQBREBao9T84Zp8cuBXF6sQQDRy6e1O9dA5udlsrr92dhlBM/kjTgRUjbAyCK3vK5WSNDy30yL7kQQdtfsR3gF/TBmgWi+iHcp0Ym1quYVRXYrQtWVHOVCQwOwOxAD6HCYYnuwMCtPR++vj1BzlUL8nGfT6yeKyoBzEKz20GOGbjan2e5LM8WQ5ebgnYeQuAvZBuXaNDuimHyxU9gma/5eCxz+NcMFV5XKbTF4T+wbuv0H+6lJ8LEF4wulQ8eyoh/hzCGMqNPVMpNnykMcATCPYpISbeXB5Q9fa6163ZGcGUuCSBIHvJe8GjDiMIVOetUx+99Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>   #ifndef pte_batch_hint
>> diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
>> index 5d2a876035d6..c49b029d3593 100644
>> --- a/mm/kasan/shadow.c
>> +++ b/mm/kasan/shadow.c
>> @@ -305,7 +305,7 @@ static int kasan_populate_vmalloc_pte(pte_t *ptep, unsigned long addr,
>>   	pte_t pte;
>>   	int index;
>>   
>> -	arch_leave_lazy_mmu_mode();
>> +	lazy_mmu_mode_pause();
> 
> I wonder if there really are use cases that *require* pause/resume? I think
> these kasan cases could be correctly implemented using a new nest level instead?
> Are there cases where the effects really need to be immediate or do the effects
> just need to be visible when you get to where the resume is?
> 
> If the latter, that could just be turned into a nested disable (e.g. a flush).
> In this case, there is only 1 PTE write so no benefit, but I wonder if other
> cases may have more PTE writes that could then still be batched. It would be
> nice to simplify the API by removing pause/resume if we can?

It has clear semantics, clearer than some nest-disable IMHO.

Maybe you can elaborate how you would change ("simplify") the API in 
that regard? What would the API look like?

