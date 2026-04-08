Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F0B010F9972
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 20:32:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F5886B0093; Wed,  8 Apr 2026 16:32:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CD876B0096; Wed,  8 Apr 2026 16:32:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E3906B009B; Wed,  8 Apr 2026 16:32:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 483426B0093
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:32:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EF110B73C7
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:32:46 +0000 (UTC)
X-FDA: 84636537132.28.F005980
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8241740007
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:32:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SKx7QmI2;
	spf=pass (imf17.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775680364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ULRpodXrow7zLF+YDro1qvSbuWG8byri0/OE4j9CLPs=;
	b=lHwu63wtx0MYHJgEmhvyEAK5YriEHuI7riXM2/LeX0M3b7wLuUA8dypH6D423p5OkfeIAt
	TctwFw1UCsH2PbhN9uEWyH2d/89k2MajkRVoogXQ8F3RIVw4wPkOeE+aqbu67MbA8fj4R3
	hs2t2auZc9yspD3hiraBsxIfDl49bpk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775680364; a=rsa-sha256;
	cv=none;
	b=dLEtmjFlJ7pZ4Px7FhQFKtMhzxuf7MIsFe0z72UNRuF7NU/+VdAFLNMdIg0JnOSBnxm7Je
	PTVoEQHS/0oRIQKIoirnAJG/Nkfx93mta0JSKUG/Akp720Xa+8wZ+lOFP/yp/+tAU72TEJ
	PSpgaK0YjtpQ6yo9sl0uDSjifyxRRCk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SKx7QmI2;
	spf=pass (imf17.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775680363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ULRpodXrow7zLF+YDro1qvSbuWG8byri0/OE4j9CLPs=;
	b=SKx7QmI2RGnscn1xlV05aaULZMsx+yVvvdZIN45s8EscHvVJyGnl1g0s6uosLB/aby1d1s
	iJiJTJEDqyurjBjjfWwRc/9NgwPqFXM+nJGBzL+r7q9Rr6y/0U6tc8cBQGdrmKZEm64rIb
	gar7QuRpCU2V8SmkcCrg87iNlfS3M0E=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-TnEr6gDbPpitIvphlbDg8Q-1; Wed, 08 Apr 2026 16:32:43 -0400
X-MC-Unique: TnEr6gDbPpitIvphlbDg8Q-1
X-Mimecast-MFC-AGG-ID: TnEr6gDbPpitIvphlbDg8Q_1775680362
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-8a5f6110c1cso6292146d6.0
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 13:32:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775680362; x=1776285162;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ULRpodXrow7zLF+YDro1qvSbuWG8byri0/OE4j9CLPs=;
        b=nm3KrMNlw1WP+DEuyuqRwc+XPSuXvJu/SgQB0xow48iXR67LWwLvA0KcfzhUtQI/rE
         Hoan3tu25ZrF5FAyh7IZ4c1t5EYO7uITm/euuL3DCwvWeKtuTtcNMxY/eSfTSNBV3+qj
         5ys3IkdWJKMdsq/aaqOcgsyrAKtUIJvj3x8on3EoTUSe8HJXs26HnShspt6h9HtFJDNr
         2tuGw2XNlH6Yc2DEEFPj2IrBoOKhvsf7+7TJUbUju9pi5FT2U7w+vQKEd3DXffkBB2Ew
         CPifLdSa8JNWlvbdSE/4QnTmgScuOe9ZyeGJBZzCee6nY8B7zsayJdD3ZBjIDg+Qqd5V
         GShQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwe6BTnEt1D8sEuvS0OLyHk4aczKD3k4qAGXdXO+x69P5A3ixv155rQvqSFFsBP9W8bdw+n3VZwg==@kvack.org
X-Gm-Message-State: AOJu0YyB94lqEYn8pPZlLWVjgVX8kBWKmeCJBqvL49PEfahLxYv5T3mx
	RrVAup/zD171CFr1grcpnRHfpou9t3SFQqgcxIfZ8Y3CYfjJXVlEvgj5/fLOqr59IKCJO4CSX+5
	eppjz3PuoGqEja+ri0R7yGHGc52t1pNrOyEggog5lFcSw43+4Ky/V
X-Gm-Gg: AeBDiesveef/0UM9qaZQN0CyKzkFsO2fDpow5GnRvePc1Q897x2+h46kuYf1c7cWwC8
	koMnAPilJXlPOJ5Y3sC2xvGxNQ5iuzYH0abOLgOUXLD826dQkzh9vOcEA4A5TLhqF2voGkgK4sz
	vG/Tw5QuHbGU7/wmWij2cM6eOm6Z/Rsf+tcnt95+kWV6AOV4aaeQs67NJkHq7b/aBm2vFlKAE43
	sSpzhv8oT7ebcq89kyrZI1Rw1AoYLcQJrMH0kdqvm7E9I+/0tn79wJJyQGbWnc6MiF/CskvjU9x
	Kdeq8skfYzLVLc3cjDK2MXS8mDotf0FzPFLPbgFR//OonogRiqPWY8V+PfM0JXeYhKSSWKCZ4nQ
	0F7QiwbkDUpH1g85oK8y1RJFf9g==
X-Received: by 2002:a05:6214:5c82:b0:8a0:f8b7:391d with SMTP id 6a1803df08f44-8a7042f27cdmr307415146d6.31.1775680362229;
        Wed, 08 Apr 2026 13:32:42 -0700 (PDT)
X-Received: by 2002:a05:6214:5c82:b0:8a0:f8b7:391d with SMTP id 6a1803df08f44-8a7042f27cdmr307414636d6.31.1775680361799;
        Wed, 08 Apr 2026 13:32:41 -0700 (PDT)
Received: from [192.168.2.110] ([69.159.169.238])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8a5974e8e8esm182785836d6.43.2026.04.08.13.32.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 13:32:41 -0700 (PDT)
Message-ID: <89fb16bc-5075-4102-bf6c-cdaeda07a211@redhat.com>
Date: Wed, 8 Apr 2026 16:32:30 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/11] mm: shmem: drop has_transparent_hugepage() usage
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1770675272.git.luizcap@redhat.com>
 <66846ee3aec32c04d20bc7e0e823ba21d4ef278c.1770675272.git.luizcap@redhat.com>
 <b8ebdf87-2b1c-4359-83af-729688994292@linux.alibaba.com>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <b8ebdf87-2b1c-4359-83af-729688994292@linux.alibaba.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: axiAQ92-ND4snsUELl2OeV3AQWjyq8uxje4Cta3FZP4_1775680362
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8241740007
X-Stat-Signature: cr8th6gstt7hgrn8xnmoox7rrzzknk6c
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775680364-160378
X-HE-Meta: U2FsdGVkX18DAZ9eBDgUzHOrYCiLTnYJJQyj4VloZNK7kdjgDnKmx+5l49H7HDY+Wckc0QCsRQT9y5wW/4HnyYNlMXDwNYIwp9GA33oX9YM3qKl/HjG3adnUKm2y3wZ4Mf57T6RiX8TlsVdKeXCljuWy0FhWjiItiwWNO3NdAdf5ioZRofTZsB8hWkAmiRBNKNu8FqC8WoL+lnTC8rOoMKduDBtPy7NrKqQs+wWBSwiakKG051CjyAz8GYfGCTT1V9WAJMiXW3Wi5vTAvFd+AcXVptorrkKSb2Roi4+IzGbFgfxoBEdPR2S0l81X+/GefACGolalqHzztNsaoQJ2Z0PElxpkUYPvIpnt6xTLD9qi0pT25E0LpcxMFn6MNGyKLz4X8NUJEPz/OJG9xXSrez5AipVLgZZSze9BdlyTN+MUjLFBAzo8D/ElbN6g8cYZfP4L9a5Qf85ghOvEbxygFLJIQ5MWqcyENsU0pDzJnnogrDX3jmr6gsr1tGn5voLzd6KU49xxeMDXYBLk/rS9Wgw3qctUJ4HW74201G23X8is6kxgO2gda47uDwwINsKErcpL1CeFdAAUv868Y24MWLBshYlfvFTsyNg1gfATo01/qAwuetXKpeH+ugX6d2fpoc/VOpSbsZtn3QD+K8SDO/2nOBhOMCslTQ4xJ7vnrxyPahuB2CsxUVEqx8zbLOmsJ0e6FFKV7mZA+HjnA15CvJnP2ElKM2hlrozEa3fZNgTuA0wq32nN7VgP53RMZZwS9BN1DJAANc1WG981GdmgrlD9a6ALwID9jnQCqe/PE7vbu/lPn4HioqBFfTeFxphIM18G6zD4hKkDa5yyB340Y3xsbGZ6Ife6il+HxxhHRrqVs4EBnHXtEDqbRdmnnd9NqUdFGoS/9Ln6Y3GKYfjyy0u5tHLctDqPwT574ovqQdB9yA0YJE4EwazSeTLkwBbiH2gNDqBjTg46W1jAZZx
 cO/5EWg0
 tmZOlmO+CZq+2Pb6GEK0vSFITmRCallNWU1ySgrUHH3isWfwUQybK7Q7yQUBDdqjEy22chmL14YxU6+pQWEqOuE7VKTG5a4ejy60dYCs0q4aF1rOcIshNyXsR+lQztHkJcxuGnWNJ90D4q9G8loFgr4+O4cI429LTN0XaqE8nMUwW2rUhVkphfwsdPoUTJ+JQYmb3wc53L4Vom0mBCs+xU5OS0duNosbyO/wA5u9nDp1Jr/O1YE0F2gmYA6jqcdNvIY5woEpEPcZYZBwlBHJH75jAJMl/QmPaeP9ALb9RF/OPRMdMLE9059dv6ARP1Z2g8L9XiGSO3ggM7gjjf6S80ooI4+RFvsfLpgjFPsvoiZ1O/WkxgqT01pX6VbJoZk/ZmS7gSrAvLr4L0/xC25qnRCVLo+EMRovEO2tLXYjvZ7r5cWfo0U4pizlc0GkbC3p/OMRPhVjErnSBDEFLVYAIq1uS44wsTgJmdLnIxmB5ZUr981wT+45mNYWVR37hCQq7SOxNIMerlt5ZU6Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-10 04:20, Baolin Wang wrote:
> 
> 
> On 2/10/26 6:14 AM, Luiz Capitulino wrote:
>> Shmem performs two kinds of has_transparent_hugepage() usage:
>>
>> 1. shmem_parse_one() and shmem_init(): since the calls to
>>     has_transparent_hugepage() are protected by #ifdef
>>     CONFIG_TRANSPARENT_HUGEPAGE, this actually checks if the CPU supports
>>     PMD-sized pages. This is irrelevant for shmem as it supports mTHP
>>
>> 2. shmem_parse_huge(): This is checking if THP is enabled and on
>>     architectures that implement has_transparent_hugepage(), this also
>>     checks if the CPU supports PMD-sized pages
>>
>> While it's necessary to check if CONFIG_TRANSPARENT_HUGEPAGE is enabled,
>> shmem can determine mTHP size support at folio allocation time.
>> Therefore, drop has_transparent_hugepage() usage while keeping the
>> CONFIG_TRANSPARENT_HUGEPAGE checks.
>>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
> 
> Looks reasonable to me. Thanks.
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Thanks for your review. I didn't add your reviewed-by tag because I
updated the changelog. Also, sorry for the delay in resume my work on
this series.

> 
>>   mm/shmem.c | 7 +++----
>>   1 file changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 79af5f9f8b90..32529586cd78 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -689,7 +689,7 @@ static int shmem_parse_huge(const char *str)
>>       else
>>           return -EINVAL;
>> -    if (!has_transparent_hugepage() &&
>> +    if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>>           huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
>>           return -EINVAL;
>> @@ -4678,8 +4678,7 @@ static int shmem_parse_one(struct fs_context *fc, struct fs_parameter *param)
>>       case Opt_huge:
>>           ctx->huge = result.uint_32;
>>           if (ctx->huge != SHMEM_HUGE_NEVER &&
>> -            !(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>> -              has_transparent_hugepage()))
>> +            !IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
>>               goto unsupported_parameter;
>>           ctx->seen |= SHMEM_SEEN_HUGE;
>>           break;
>> @@ -5463,7 +5462,7 @@ void __init shmem_init(void)
>>   #endif
>>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> -    if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
>> +    if (shmem_huge > SHMEM_HUGE_DENY)
>>           SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
>>       else
>>           shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */
> 


