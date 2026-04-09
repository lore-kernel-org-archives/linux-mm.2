Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A281F364B2
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 18:51:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E607C6B008A; Thu,  9 Apr 2026 14:51:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E37F26B008C; Thu,  9 Apr 2026 14:51:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4E546B0092; Thu,  9 Apr 2026 14:51:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3D5A6B008A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:51:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4A47D883D0
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:51:29 +0000 (UTC)
X-FDA: 84639910698.01.B94E548
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id CB398140004
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:51:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U6R4NrkM;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775760687; a=rsa-sha256;
	cv=none;
	b=wN10sleJZYl4i3rqH/CZ+R1Pae/h+DuR+C8a0tZkO4/O6Mi31CjCL0tShIIg4JH6WaUFoI
	pW5ROWRYPdqC0W6SE21KBO294UUUccZuQZRASeeG8CFdfULRc1YQWEPQwZmVHrlgb18haI
	xNokjFlcJKFsdEcmFngxcqYZEvueLAM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U6R4NrkM;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775760687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zBZJXslpS8fNKyokAvYFuViIcUx7NcJTjrB+1p1g9yM=;
	b=UVkRyn6NJQwOzobvEzglEJFNDPTya3aigfkdc6cVgszivbESrDa/B9DlroKKFiQpnZbgNp
	Sfh3mZ7DPNDvy3tSuLHRqgTBXwVMQ8FwOs04orY598BS5r3MaJ98T+kHG0P46Tw8YOFf+e
	UCX5VgTX3nCgkUOHjmGEmuLoWVPd7OI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775760686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zBZJXslpS8fNKyokAvYFuViIcUx7NcJTjrB+1p1g9yM=;
	b=U6R4NrkMqRtEHWJ0TBBgeBdVLcQHhqIEKWXWqndwsuYV9fndVDVPkRLMESQRBT8l18O/bQ
	ZxvMFXrZm5C1R2VHr4t9RCE1k3AMYnkyiFqDxW2fPDPZWNhR7XKZO2yeIFpdG9Fz7+IGSi
	xWFv4nCIlPZGkJMK6xpNhj+ioFxoj5c=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-zYn6TmlLNbeN-th27wqrtA-1; Thu, 09 Apr 2026 14:51:25 -0400
X-MC-Unique: zYn6TmlLNbeN-th27wqrtA-1
X-Mimecast-MFC-AGG-ID: zYn6TmlLNbeN-th27wqrtA_1775760684
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8d5010ea730so272844185a.0
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 11:51:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775760684; x=1776365484;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zBZJXslpS8fNKyokAvYFuViIcUx7NcJTjrB+1p1g9yM=;
        b=CozdQw4yp7w3JXJHSY7mauGVdJBftYEqIvzxGKaSTV7GcDRzAOr1phO8aNJ14t8WjO
         6Ox4yJA6h2Y4RomM+iFL1Hte3LIEF3BOUW2aeF9D0/67Rs5TTfMNsbSNN5zO9Cw2aidG
         2NKWl9BckeJsi8AYyWHyG5H5OiVksdrvYiH5b03Z315omMzeZ3vx2mpYu3dn+iz/Y4Ve
         S/4dX4ZFpI6WVQcXgMQiJ4cwCr1nuE8xhaJvxLk3YbRCfV6N2bygvjI+sZumhFAHix0B
         raCPjdiC4w23qUNEd7cukkJ65qSlYgCmzfFxYOwPH6Ukef56kGha45YsiU8JhFUEXZYh
         uxEQ==
X-Forwarded-Encrypted: i=1; AJvYcCWzbGwzVlJMnwjMaFKXPXtyaonegtTFzWROkephcz294mKB7Dx/theU8A6qaByPAHNbVyuY61wyQg==@kvack.org
X-Gm-Message-State: AOJu0YyHKiFW178ubyLqA/6BpYy0Yi8euRvacivLkWglclEU9DubXka/
	u2CyShlPsJEpe7VVIcsytCrP5SrvnpjRcn1n07rfbkKFR0/ZWSV/Mb8EpvQ3Fazvw1rygrVFvQV
	4TS1TxbPSVPPhvbuMMOiXsIYytYqanEQQkfyigSLaUHkGhfqZEK5i
X-Gm-Gg: AeBDievG6REmJhE7z7HiG0kwN87k+6vocwIfJXy9WPZrf7Md7mXcM4HfnJ7II1v05k3
	bZbFILxRbQMwu3JsBMHOaX1kOJtMM5MgNK+OVm4vrzxT4zwDDx7HMOTA8JMd1zVUpmOPP/w+uxG
	vn6EJRM1Hy9FMUbXTM6UNH4tQgWxZNBYoQFk1bcod5ZvJBtD/CP4sbpUEDAkVfhWgMWQsiQdThc
	jbatsKvjFYjU/r7HTu5TEP8nq9+aadDUaFmh6BjUGCu4SzcXfus6LE6URXeR7DH6fqehdz/d0eu
	PNrVx7e9noju17hqguNYVBc/12pRESrScJqnNHzOwg7M2G0YjFAeK/YkuYQVPYLSyl6jBy2FQMy
	m1LuBZU/1jjEUJpmLklQAhuq2vv+bVm6g4DImE0Z316yaGKZfmPHZiPslT7iktDWcaVbmNmtxLx
	eEa3XcE/hdjJG4Ges=
X-Received: by 2002:a05:620a:d86:b0:8cf:cee2:e405 with SMTP id af79cd13be357-8dc4593a9d9mr630689885a.24.1775760684434;
        Thu, 09 Apr 2026 11:51:24 -0700 (PDT)
X-Received: by 2002:a05:620a:d86:b0:8cf:cee2:e405 with SMTP id af79cd13be357-8dc4593a9d9mr630685585a.24.1775760683950;
        Thu, 09 Apr 2026 11:51:23 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-53-69-159-169-238.dsl.bell.ca. [69.159.169.238])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb646dbd3sm28882785a.16.2026.04.09.11.51.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 11:51:23 -0700 (PDT)
Message-ID: <387778d1-6bc7-4546-b7ed-9e6a57e64651@redhat.com>
Date: Thu, 9 Apr 2026 14:51:23 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/10] drivers: nvdimm: use pgtable_has_pmd_leaves()
To: Zi Yan <ziy@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
References: <cover.1775679721.git.luizcap@redhat.com>
 <0309be4a7133ba8d043380f0c3614af764f6e3c9.1775679721.git.luizcap@redhat.com>
 <81879907-E65F-4F46-8A85-4D8780EA8AA2@nvidia.com>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <81879907-E65F-4F46-8A85-4D8780EA8AA2@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CSwf1Sf3Qm1QWK1ajCHOxRrDbw63wP4m61oq82FRMbw_1775760684
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CB398140004
X-Stat-Signature: gzsr1hwer445bxzxm68q57tx5xhguj1k
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775760686-679335
X-HE-Meta: U2FsdGVkX19lfXTJj0Ih4NEDV2TBHbZGfuBGr6xgmGxaPudmCopI5tO+OTaE3qHFgnUXfprgPhqrvbAHbSLFltNYXgFBqzzL8k0myRLpqwv7iBA+zdDDAmVKbI65tWczfZPzeJjHa9CA39K3GrpIkm5wJwysHY+8Lrdr/GQ+91ZCgMtwlgEUoMqXcg6Zj6Rj3pcwdYfLXRZXlJsjEl5BzrXYnyA1GZcOSUXQa+WoK42XMPp/dPpD7UebSmL7+HRZhpwz6x80ITvh8UkPzQlBup44DpTM3kCPC/Mt2UJK/ayFQF0AqXoMr6bb6ExyXXm5c+eCYtauwPp0s1Hrj7PLm5HSg89Rnv/NSaELs3pi3hPg1nXhWg0ua8g2dR7zWw6vE84CZ3KAe4LQzxxVMNYJBnMzkGxlL2DHykingCcjNoixcTMyN2l/rtBFwsmEjlREKWXh+D2IGED94/NRyhrAQIxgFSR1XZ9ps+3OvLT/cepPo3n4puCCz5cEMoMw6cURoGC39qd/3TKxdxmAi5MapatouDSGdFj+GqhMDZZ+N/NIW13RiQ1MYJXx9Q4Z/Sh6gstRbpPdxUNvEfTDowXTeryAfEDYFfJ2gjCHczu+v40cLZQF+8jVCVIm6tfF1JT3rYr/OiR7OJeWYlqLk9ING9OuCiVqYHTpTbM5QP65U4x2c6g+kQRbm0k926UNdf/zH15qngHMlx08y8QoWpnqtuPUEt3mX7D8qEwv+nXczt21fhTF3A3XiIL15IFV34l3BZ/BJfsvOe6VFbU6UO1fkBXChHAVL0DVQ6f/puXMnhEPB2HzqrHtR98DgBw2taqDgLTufFfDZWJ+kmyBUUKUA8uv44M29Xx+EeKhGTDn55nTxSQajY9JsOad57D6tTkj5nl91Yp58fw3HJY9bBzkw0PHXjfXI/8/cjNOnzyNqD3iuoBhbJ9omvZE/7XnoC7llrlKbYmx42O+LvgKKpE
 Rp41Jt19
 5XPxuVQKLonWipVqFzeX15Pqkil8bMboVMhwLxIFoD7maT8evbAaK7+4tbcFnIDgHmAWfODYaT/jP6ks4/Jmi07gteblT1HS61lX+cOETPpE9LSQkm5D6xDSzAoDtQyJvCgI6bgnnwHqSIOzPtQwKnPF4Tl0TI+nNcVsrDMVZRDl4CSynP9+QcUi7JLzAW/BMbjAykccXGQyKCcoGh/ekyw1thbThZqaVLoemwu9F/BP/F9ylg5wUA4e5UE2TAH4EAbCXJP5ES4NI2SbDvvbNCeKgmX5xNOKbXV8CEnrmO2++nwwL/YxY4QtBHtkLyUS5hALX2CJ/8kcyH50qlyrvhmrnLeW1qBCNGxMVK6ofNZDxU9kBWQXxTU6wxl0CX9BjuVTgT6oQOyHELhcJ/DqRBcfl87rSS0n8MCcC91zGMHhlfK7CsRL59Ot1dy9ELJtMO0ikREQV7iRpmBp71XF5mVbGXPCd2Y7F9dI2enLyvFhuQfcBKxh6DS25Nv4QFNUdNPpDUKnMIqemfC4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-09 11:21, Zi Yan wrote:
> On 8 Apr 2026, at 16:22, Luiz Capitulino wrote:
> 
>> nd_pfn_supported_alignments() and nd_pfn_default_alignment() use
>> has_transparent_hugepage() to check if THP is supported with PMD-sized
>> pages. Use pgtable_has_pmd_leaves() instead. Also, check for
>> IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) to preserve the current
>> implementation semantics.
>>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
>>   drivers/nvdimm/pfn_devs.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
>> index 8fa9c16aba7e..457eb54e7ab6 100644
>> --- a/drivers/nvdimm/pfn_devs.c
>> +++ b/drivers/nvdimm/pfn_devs.c
>> @@ -94,7 +94,8 @@ static unsigned long *nd_pfn_supported_alignments(unsigned long *alignments)
>>
>>   	alignments[0] = PAGE_SIZE;
>>
>> -	if (has_transparent_hugepage()) {
>> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>> +	    pgtable_has_pmd_leaves()) {
>>   		alignments[1] = HPAGE_PMD_SIZE;
>>   		if (has_transparent_pud_hugepage())
> 
> Hmm, there is also has_transparent_pud_hugepage(). Should it be converted
> to pgtable_has_pud_leavs() like has_transparent_hugepage()?
> 
> Feel free to defer it to a future patchset.

Yes, I plan to tackle that next once this one is merged.
(Thanks for the reviews, btw).

> 
> Acked-by: Zi Yan <ziy@nvidia.com>
> 
>>   			alignments[2] = HPAGE_PUD_SIZE;
>> @@ -109,7 +110,8 @@ static unsigned long *nd_pfn_supported_alignments(unsigned long *alignments)
>>   static unsigned long nd_pfn_default_alignment(void)
>>   {
>>
>> -	if (has_transparent_hugepage())
>> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>> +	    pgtable_has_pmd_leaves())
>>   		return HPAGE_PMD_SIZE;
>>   	return PAGE_SIZE;
>>   }
>> -- 
>> 2.53.0
> 
> 
> Best Regards,
> Yan, Zi
> 


