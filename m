Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F03DCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85D406B0371; Mon,  1 Jun 2026 08:20:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E6BF6B0373; Mon,  1 Jun 2026 08:20:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AED06B0374; Mon,  1 Jun 2026 08:20:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5686B6B0371
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:20:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0C17014067D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:20:59 +0000 (UTC)
X-FDA: 84831253038.07.06C1A6C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9193F80006
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:20:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d8XKg8ry;
	spf=pass (imf02.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780316456; a=rsa-sha256;
	cv=none;
	b=lN19Qx4gX8K3bqxJ1Urv5oTCRUYv67MtazXcCTDFQYROtUYaOQt5Jf3vasn9TcTVbHeObq
	j0krLan9/2BmDxfzSDt3km8lcDazMhpNYWHETd5R62RqKZhfRo69yaViApdJvcmMDAyOKs
	FJfbsq3Yo1kI85OHjE4vM8cxM17cAzs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d8XKg8ry;
	spf=pass (imf02.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780316456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ARkpOMLTcYeGeJR1eIF6OuQ1ndOsQ6TntcYnAK5DjuI=;
	b=bwCKWbAYipAieGbcG00gKBDc2Re6FEZxmV3aULqmoK0PiB0Dpa2o6xD5B0rrpEJFJykDxR
	H43frbT04SZYytWMnmzU1S1DRevKXAY8gYpU5M1cle1qw4zqbxZUMtFDaUomR4m4o8beWQ
	ZpOBmHvP/RvJ6f+kOcCnabjLIq8/s+I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780316456;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ARkpOMLTcYeGeJR1eIF6OuQ1ndOsQ6TntcYnAK5DjuI=;
	b=d8XKg8ryjI//XBiCbhyILL15U9RmAl48aAGerM+dD2rZWTGvhKL+8y0XRy5BCGGesVg6fY
	zPnnVkw83tkBE30IldikkljP1wCv27ck/qKRhgvzqoE04QeaXOqQZMSc8FK/Izo3+gzs+I
	gOjMLgJjnhhik8cBs7awTkBGP9VSVmE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-544-vrjAdNJMPIGF8zT1Yh7wWw-1; Mon, 01 Jun 2026 08:20:55 -0400
X-MC-Unique: vrjAdNJMPIGF8zT1Yh7wWw-1
X-Mimecast-MFC-AGG-ID: vrjAdNJMPIGF8zT1Yh7wWw_1780316454
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8cce1cc8cb2so64794856d6.1
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 05:20:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780316454; x=1780921254;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ARkpOMLTcYeGeJR1eIF6OuQ1ndOsQ6TntcYnAK5DjuI=;
        b=rcDpK6fo1eD/eBZdOSoiMM8Ekg+E5+RsNE3UoTdRd2Rp4Dx4gyibYmiapdoY0XfY65
         wq/J66zjxuyFSO6U9KdRDajkSSH5zx8t7TRGAbudhX3SHLVqUKFCzZYU52Y+errBeqOI
         GGvwHGd709qty+8GpoYLo/F6as2MTK3EMPhrvSBbqnRqKkkIhaqUReVZcp6U58fK2Plk
         YbiyXcMeKgikOmxSbPyF6tBOy9t/xixI+nNf65MCS4mK/wUwU0QKl7tDpKAuA1rr7Aqp
         yg0SJySEZZ/mCjRhB4sAsDRU3+x+xYhkYsAF24AYmjg+ZA19EjRE1qYIok/zCmpLwGzY
         lxCQ==
X-Forwarded-Encrypted: i=1; AFNElJ95fFOEZGY96wALF7peI/Jer8DAJpNI7llCX+y+RetnWbVvBjO6ura0sGONsvzN0WS+cUAfyezMFw==@kvack.org
X-Gm-Message-State: AOJu0YxjtsAQ6hB8nKYlPWLbT+73I5sa7uLJybAOgdan76bk85wym6RK
	TRIHLkV1BPEtDKJSbI7MnCI1OBORN7kNtmyIrl02fhsWnP4FmvcCLeyro06BWmD/sRK7SfLJX5C
	bhmz4WI+QsUcyA8p7hPqlU5GOFoAzd8pg9mMkMyv9D2NOO+ZJPIMD
X-Gm-Gg: Acq92OGUeJw7eHLQD6wdsf9FptIaE4rq5YxaIvGGOegeEoqv3IFHhYsJGRf9McgZ/NG
	SApIhF7XhYdQyG5JOJoFqmcYYfiXvgIDpey1bf4qyW7uCL3TYAIgYZpdphhLwLh/uTUI3EEZP+3
	cDXTzQJDNvG9KwtIMV46tG7yr3iz5OsDT2wyTNJPzJaF3HtmcCgHz9oWgpYJtm4NzyeUH1bqC2g
	Axn4ziRY+tj33+y2yVG63dvx09EmtIZe+w3gTCCeMLF7Cyn/VuBiCZI/3iJHBMkdc2UGBhUhof2
	6NkQjvjvx7SVUnO2Ao+N8+az27Z1DD1/sz+ujdCONEGOu54NHUs6xlC4gO4zwOXFZ5Qp8Qwpt4V
	7gZ5TaAlq5u/6Tke/9SUxpqqZvhvuvR2UpQntdRq1CnwY0WE4qvzMeOgjqMfZ6sBNECBG6Su+2h
	hfz6NB4jm9h64gr9Y1om6Oetc=
X-Received: by 2002:a05:6214:194c:b0:8ca:1eb5:eaa3 with SMTP id 6a1803df08f44-8ccefd85525mr182585766d6.27.1780316454389;
        Mon, 01 Jun 2026 05:20:54 -0700 (PDT)
X-Received: by 2002:a05:6214:194c:b0:8ca:1eb5:eaa3 with SMTP id 6a1803df08f44-8ccefd85525mr182583376d6.27.1780316452680;
        Mon, 01 Jun 2026 05:20:52 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-22-70-53-202-134.dsl.bell.ca. [70.53.202.134])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ccea1c2fd8sm91424496d6.23.2026.06.01.05.20.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2026 05:20:52 -0700 (PDT)
Message-ID: <e4db1872-fbda-4378-b2a6-82915a8b69c9@redhat.com>
Date: Mon, 1 Jun 2026 08:20:50 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/14] mm: shmem: allow THP support determination at
 folio allocation time
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 ziy@nvidia.com, lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, ira.weiny@intel.com, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 ljs@kernel.org
References: <cover.1780066530.git.luizcap@redhat.com>
 <144e7639734a501340bffe5652f8ce32b3657e23.1780066530.git.luizcap@redhat.com>
 <bbf10c67-435a-4a32-97d4-a90fed2fecf8@linux.alibaba.com>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <bbf10c67-435a-4a32-97d4-a90fed2fecf8@linux.alibaba.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BiRZ_pWspBgwzJzErX8jY09k8BLndC-ajAyOwCTCGUE_1780316454
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9193F80006
X-Stat-Signature: fuzf1xx1rqxrjrawtqu7btnuzzru7af3
X-HE-Tag: 1780316456-859391
X-HE-Meta: U2FsdGVkX19pRJWbIfwOBiiFlaSftRk44H7+BMncATFk12CtUXFmjMJH3c1p+rOZp7tLja6inqCx12HuWhNFUxboXMH5tYg18zIp+0tq02pqGa7klnNhdmu22Am5rErRJqzuTjoAjZoRPpKmEXXuwj5KEuYaRHcIk63PmWMkHgIzLtLWqeiCeHNXevogaNiez6pn6eFG7iHqibzyaml0435p+6J4AT12NLYwOBi5ZICDl8+kqOX8Ku0g4g6KX+2LP47+mhnwy7Fkhu6HpjW8Ulw3c6J5/53lxvcbBxMg+0B76d+PRTReZGdpHHvi79jRkREX2jeSLmQstxxxeT2dL1qUSLhOcO4WdSZ99BIgwFkV+/UtnxpW6aUZ0x19Sy2YelEcf3Oxr8bEbTfeJXVHBYIm5SzOe0W9OxgxVX4BMlfxyJppuSmGvQaU+CJmYGU7NbRRpwASnqPE9/fy/ZWRd6+m6qOvjv/fpasDYwQWMSqL7Gk5nEh1Lx/Mv7GsXm8da3Agwks/XnSwDBrgvgt1HMMzKE7bDcawO943JytGHZbKKgbHTjs9kA50zIh/m/7jDLvWtWdD9hYFd1fi/adPO/odyKolF//ZCvphCXbi5i0DZVgUfQrxkkeg0PzQHObb783qBCf6rVbZGPFI/Ggo9EkKSaF/8BHD0a0q6X6uTFE49xkpInwhXvxOB+CylP0ATIpyDdnbfFmbratAqHzNxBcgaYBUQnrLqun3I07i3amkl1Y2e7NKmHC3IT/1I5RO5fCLwYsJnH/uKHo8w++EXsyQs+QeLjq5yvs5Uc+wzprP+2QT0mqTMlwioAlaDaoT7yZu+cB7l1MzHQ4k073+wFQ/CCBkY0Sz+kpe7vjhLjGkACz5zVKi0UyNhN30ji7WIZZHocSOHEVL5JKZO109EX5/KDKpqofeX3GHCy5z1GPOhdXZzPt081PxlGhQcxPrdYNp1PzcvIEbbBitfai
 +DrmPdzB
 dDUwXzn7Z4rK3FgcdB3gIoBLGh9ZZWFLq33xTKSvOwRT572/TXpNRTWwcbxzbg+TNYFrePnRMfcEIaHEeWXb4semOXhtS3a1vGcXDVcHgTHNZPm4iOGLhyCxhj5jH94eOv6RJWUC5yfwQ7CdwuG9Lqf8/QhtW+n19qmIegyPTBHXMMxIjLzeT+lVaSyWMaZ3BAmUdZSx0yeqzUp8dHZanezGWwd9IqbgvmzKHAEitcClBHEoPkuXhg/hj8KpKB2hKYFBpkxDDkkljlTMvKlpETrk/tbGoG/AOkJxRVh6ByvJ2ETBV2qVOCzayQBE4FWxC2nTBrMB8TCkbdKhxoCRaB15Ic/lE8XNm8IA3OidnivsbSWx0c7EMoqPIi10WCN0xVrT06KkTgP6s3O6CQziXzKLffCvNhEiCp4zL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-01 08:09, Baolin Wang wrote:
> 
> 
> On 5/29/26 10:55 PM, Luiz Capitulino wrote:
>> In order to enable THP support in shmem today, besides the user
>> configuration required, the CPU must support PMD-sized pages. This
>> is the case because of the following has_transparent_hugepage()
>> usage:
>>
>> - shmem_parse_one() and shmem_parse_huge(): Check if THP is built-in and
>>    if the CPU supports PMD-sized pages
>>
>> - shmem_init(): Since the CONFIG_TRANSPARENT_HUGEPAGE guard is outside
>>    the code block calling has_transparent_hugepage(), the
>>    has_transparent_hugepage() call is exclusively checking if the CPU
>>    supports PMD-sized pages
>>
>> While it's necessary to check if CONFIG_TRANSPARENT_HUGEPAGE is enabled
>> in all cases, shmem can determine THP size support at folio allocation
>> time. Therefore, drop the has_transparent_hugepage() usage listed above
>> while keeping the CONFIG_TRANSPARENT_HUGEPAGE checks.
>>
>> Additionally, we need to check if PMD size order is supported in
>> shmem_getattr(). Use pgtable_has_pmd_leaves() for that.
>>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
>>   mm/shmem.c | 9 +++++----
>>   1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 88bc0c292f1a..108dc969b92a 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -689,7 +689,7 @@ static int shmem_parse_huge(const char *str)
>>       else
>>           return -EINVAL;
>> -    if (!has_transparent_hugepage() &&
>> +    if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>>           huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
>>           return -EINVAL;
>> @@ -1303,6 +1303,8 @@ static int shmem_getattr(struct mnt_idmap *idmap,
>>       generic_fillattr(idmap, request_mask, inode, stat);
>>       orders = shmem_huge_global_enabled(inode, 0, 0, false, NULL, 0);
>> +    if (!pgtable_has_pmd_leaves())
>> +        orders &= ~BIT(PMD_ORDER);
> 
> Ah, you did in this patch, but this change should belong in patch 14?

If we move it, then this patch will add a temporary issue until patch 14
where shmem_getattr() may report PMD-size for blksize even when the CPU
doesn't support PMD-sized pages.


