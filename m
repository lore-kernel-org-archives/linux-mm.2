Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1514BCE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 19:15:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76B538E0009; Mon, 17 Nov 2025 14:15:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 742BB8E0002; Mon, 17 Nov 2025 14:15:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 631E38E0009; Mon, 17 Nov 2025 14:15:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 512118E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:15:50 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 050EB12DA6A
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 19:15:50 +0000 (UTC)
X-FDA: 84121053660.08.A5005D0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 90BCE40009
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 19:15:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KFnY8QGn;
	spf=pass (imf07.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763406947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VgXj9j8UIpfH8qRYNNbd8ocQ5iSZL8eoT+nYWqQuZVE=;
	b=Ggu10AEhrSjndiPeAgv5XNsfgKyKMYtWOVF3iiHOcENhHC6jFaMQfbz8s7un375Hij3YJM
	Rt5KcZB8kYb0uHS5Lndzn38/pLJ7d7hxOpmYVuk/LC/4vRbALNZkCLTbpaO91vpbEb48dd
	Qj6+5mrsMWIe7VyTDIMF4Ges4/t1EvQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KFnY8QGn;
	spf=pass (imf07.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763406947; a=rsa-sha256;
	cv=none;
	b=AqAPot76TK5M32LJ3oIGD8BwAOSNvBQfYpIAA+OdeNgvVtV6lzxhQ1bfzDbknRSn2uJlqn
	LallHqiHoGxGeklEGNq7sBFeKvURNgUDWTL7ArXi+p/KXCoGzIIK9rKQrilsJgoVFFuvLa
	ATtVjhtGUlRRsdpWpv1h7qReefxVouY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763406947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VgXj9j8UIpfH8qRYNNbd8ocQ5iSZL8eoT+nYWqQuZVE=;
	b=KFnY8QGnZKY5GpBYCAh4C/QoOLLZELrjGQoAyKAJecnNlkFW9RzFgWNFx5llyJXZYNE1Sa
	80I8I0sCq2Be7Bbrm/3UOGyW+qN6kq2Crmzhiuk2J0VfrsYCn0kAoYGAHez54rA0DuNdwN
	hUoFL3TUy4c8VHYFkgfyagFhQWS041M=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-gBlUe94QOTajJnQpyirvaQ-1; Mon, 17 Nov 2025 14:15:45 -0500
X-MC-Unique: gBlUe94QOTajJnQpyirvaQ-1
X-Mimecast-MFC-AGG-ID: gBlUe94QOTajJnQpyirvaQ_1763406945
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8b2d2c91215so798520985a.1
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:15:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763406945; x=1764011745;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VgXj9j8UIpfH8qRYNNbd8ocQ5iSZL8eoT+nYWqQuZVE=;
        b=AW7Uco1RneaCQWd0+wwz30yoFxsb9BxOPJtVzSZiDnLWE2/P9Gi3iyUms1fC2y8uRb
         4yRln0cbjES91eJTADpAVlPVVlAPeMvqWnfrR1GHXkGAaq3vHCNx8guUpTcVESzvwQD0
         ANJCyR0M8MDLFCgDy1iNbrpRxxXo7G8uXnKkC8MzxOuAhSSjs3LImO1oPAAzCJxlUPH/
         Kj3BGQ8VXodwYK7Ix3Bk/eCoKqq6jzfvWIvunHun7uvG4ToyXNWE4aHrLWXyRG4Cy8vx
         z7eKt2vp2zeIhkRHTvDBI7heKzvAUMXjJYEhI+STuqfc0H/Qvj7xZfwsTJCUGr6IAjJ3
         bhRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjeRE7W/QkCz51JuNgClGHFma4q+QZX2IaQk9rVh5OTmZozJCNc4fycYv423zle6S+FtzyUZyPAA==@kvack.org
X-Gm-Message-State: AOJu0YxcLaYEq22mT1vbqk2yxr3LFuq/jsVPEnQ5Gs8Nvn8xxgRGtRz9
	yGV3+nyy4q/coPoKFOCS1ZP4MNPPyH9+FJlRM/O7Pev7oSJHdhK6IhnJZoqsusIjON+CVGjIA2c
	vWCDxYphE3wAjuHEDRplE+LHFv4u4oMnPOgZ9W2W9q3uooTDA6TQK
X-Gm-Gg: ASbGncvMkR+SIfraqHGdRzejbbm1QP+wZiR3jESw8eD2deWCGUZcwetKm+uRYgAalZO
	oQibjHmRrxUXC/dWx8y2Nojwws36VimvY3mCQaEtmxsC6Mh+H7li5HNiG1OAazYu0OBk5KKT3s7
	kyct+53ruqb5ZTYapFKEedp81u/Z4iCliSpzcwJRbK8okARUokGtbxFZR/qXKUTO4hm8IOGaaox
	d2DwG+ayhEJ20H44blUBT1z3fBvzRiP37CmcrJrgIj8Ioar2VmzwrG/75A6yOBCMbRsqVGhyUbA
	5UPSlTMXZAVJKQkiNpFDe6t+aILBJ9SSNOzaXR0ZlITHSCxStmq8GKUSZfmR8x/EtPxx6AmxNQu
	gnEZlcyHFWs8=
X-Received: by 2002:a05:620a:4708:b0:8b2:f31f:ae18 with SMTP id af79cd13be357-8b2f31fb082mr429792085a.34.1763406945095;
        Mon, 17 Nov 2025 11:15:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEqsiIgJU6/qZqFx0ELIF8xrwp5k3EMVSYp5628XWNgHz3g2dIiOlJwNHDX+EKM6sNAUe91Lg==
X-Received: by 2002:a05:620a:4708:b0:8b2:f31f:ae18 with SMTP id af79cd13be357-8b2f31fb082mr429786685a.34.1763406944538;
        Mon, 17 Nov 2025 11:15:44 -0800 (PST)
Received: from [192.168.2.110] ([76.65.77.217])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2e519bb84sm476682585a.34.2025.11.17.11.15.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Nov 2025 11:15:44 -0800 (PST)
Message-ID: <fe0ced4d-170b-4144-84f9-88fcb4722936@redhat.com>
Date: Mon, 17 Nov 2025 14:15:41 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 10/10] mm: thp: x86: cleanup PSE feature bit usage
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1762464515.git.luizcap@redhat.com>
 <8dc0695aa1c1073ec475be18e300ec1046344e84.1762464515.git.luizcap@redhat.com>
 <58caeb32-f50a-4056-828a-476d958955ad@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <58caeb32-f50a-4056-828a-476d958955ad@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KNZvfXyDeefDMGUD-lIvIjndkyNhehI5sODFpoJNYKU_1763406945
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 90BCE40009
X-Stat-Signature: ptwhduoqg83bmjq3fnymmj6kfqyztwuk
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763406947-12204
X-HE-Meta: U2FsdGVkX1+7GK+2d9X/RUgPx7Lfebvw3+7OihnfAgF1QXhRTjsO4yARzO3tJgw6+w3nbLB/nHBYXGugTR5WkcPqP97ETQ6p70pGf07YXn51LsacGwNB6jP/2bDPKWpibUQJXS0FvPkKD1OT9KfpWVVgPL1T0yixiDWkiZZ1jC2jpq0Ff8cCpMq5SdCf3XbHaOXLwmDQYBsqGFrwo3PdW140pwrCMPMzcMoLzVlOJ24yLzQHhpQ4YOP6I6lX5Dds5x0Te4MzWAC0pILChxiQeW+WYkw277prfnAfEB2HVz91HT//UW9zH0n0i8i+ep9e57yLN/zrHb0nR3UvkioU5UBKceqr7Bwh/y56/muF5zAGm7t2KA2RhrpAEDdCJupXfZoiYq9gzG+0Mz0NtiE7PcraJEb8uoC2axfgl2M0TyCQcOvasniHyxxUKp9gBObUGgAO2QmzkeyymNcjfmzqfUPRs1ynz+jVTvskQcxSsINj372YBwBVE/nSiDWTtw2RES0MPqDhS2t07D8RTGdug746gn5xAwA1vwFHvi5H8oecOOu4vfiw5uwQiBPlH9pfKQfEK6nXfdNArKog3vQjbsRchqdXysPNSO9j/iEMqGTQU0VF2KJpJ+JyVT/4lxPpaCy5xLNiHiryZP6LGZH9zdUqPIeBqdYno0SmSTz5PB54Ssit7JddzSYHVFd6dzbU6pyi4xVqachven0y8KBnuptnnwsSG9P57E/TmR74xkRkfNohdxa2GB2jqaSK3Wpmjr9/f8V5aLdV9uXyeDlW1mURXuYtT/oVgHlxw9RR8yh6Rh2xU9cFfdgKI3zEKomKbgA92VygiqnrkfwAr1GXJ+mrjmDbSLzQeGiMTiIquXq0gBcWOHTHMY91+bxKXsUywmQb8DlxisbOZ/2FGjJlypCoalv2M9Ycdt9PZCQr7EN2K9hSSfqeq2aJNcYfgf513+dVXFHu8NJmKHG28cR
 VLkEoBvb
 Eot5EkSk5VyH8LSI83p+9Pbpa6fvAwjf83ljJhAD6D50MkqBQugYYNcM7YbkYeFlyBH69P0czj9uCoIjCAZpezclwsAitcSmkeC8e7Owc4oazSWFara6H881nVcKvgtuneS9dOaWPuuhzbTaQCcdbmsPPNpCDVDP/dMZQYcLSjJ0hLuMqgDCRC077Entb4GIebqbuqPdlkjwC/6YK+yVJLrkv21wClv3rECOEZtnu6Md93R+d6PPu9f0fOO5OB/cTbFpmm4TRYX6AiCAqORyAr2JowsB8vWqS40A8aIzLUpNsf0+C8I1mPsSTgyId11fd+lROTHQJP5AOqAcZmCdR+ytW6qL+TIBiKX+r8cgyqXZgjmrrK3RJUn//RJ75YM/NjP6Cn+C5T7bt23f/4MADxoyq7ZucPZZMcxyYWzR97acAdCjCEeb2WI61kpAD6HT5zMiqprzAwnEZBW/7tX8lGGgcjxYktVl/n5/6kUAZNbygreHsrxK2np+Qmw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-17 12:49, David Hildenbrand (Red Hat) wrote:
> On 06.11.25 22:28, Luiz Capitulino wrote:
>> Historically, THP support on x86 checked the PSE feature bit to enable
>> THP. On 64-bit, this check is redundant since PSE is always enabled by
>> default for compatibility. On 32-bit, PSE enables 4MB page support and
> 
> Or 2MB support with 4byte PTEs I guess?
> 
>> must be checked. To clean this up, this commit:
>>
> 
> Likely the subject should start with: "x86/mm:"

You're right on both points. I'll fix the changelog for the next
version.

> 
> 
>> 1. Drops arch_has_pmd_leaves() from common x86 code. For 64-bit,
>>     we assume PMD-sized pages are always supported
>>
>> 2. Checks for PSE only on 32-bit, using arch_has_pmd_leaves()
>>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
>>   arch/x86/include/asm/pgtable.h    | 6 ------
>>   arch/x86/include/asm/pgtable_32.h | 6 ++++++
>>   2 files changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
>> index 08d109280e36..55b88de5178f 100644
>> --- a/arch/x86/include/asm/pgtable.h
>> +++ b/arch/x86/include/asm/pgtable.h
>> @@ -313,12 +313,6 @@ static inline int pud_trans_huge(pud_t pud)
>>   }
>>   #endif
>> -#define arch_has_pmd_leaves arch_has_pmd_leaves
>> -static inline int arch_has_pmd_leaves(void)
>> -{
>> -    return boot_cpu_has(X86_FEATURE_PSE);
>> -}
>> -
>>   #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
>>   static inline bool pmd_special(pmd_t pmd)
>>   {
>> diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
>> index b612cc57a4d3..3bd51cfa431e 100644
>> --- a/arch/x86/include/asm/pgtable_32.h
>> +++ b/arch/x86/include/asm/pgtable_32.h
>> @@ -45,6 +45,12 @@ do {                        \
>>       flush_tlb_one_kernel((vaddr));        \
>>   } while (0)
>> +#define arch_has_pmd_leaves arch_has_pmd_leaves
>> +static inline int arch_has_pmd_leaves(void)
>> +{
>> +    return boot_cpu_has(X86_FEATURE_PSE);
>> +}
>> +
>>   #endif /* !__ASSEMBLER__ */
>>   /*
> 
> Right, IIUC 64bit should neve rrequire this check.
> 


