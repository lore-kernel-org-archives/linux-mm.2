Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5F5810775E6
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 16:50:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 274CA6B02B6; Wed, 18 Mar 2026 12:50:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24B5A6B02B8; Wed, 18 Mar 2026 12:50:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 161036B02B9; Wed, 18 Mar 2026 12:50:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 05ED46B02B6
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:50:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 90B8916084C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:50:41 +0000 (UTC)
X-FDA: 84559772682.26.4181384
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2C78614000E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:50:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fBfiulsq;
	spf=pass (imf09.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773852639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SYosXReCxKHTRtwKmKXBap08lvT05iVcC20sVq3tMSw=;
	b=rbTKs6xoFwZLW7z0V53HqB8GsH+ctwowx9lLUDDMXmQNgs9EWbzmyTu+DdX+QEQ5tSDln8
	S2nIN+VyPKl9g/j3vAScOtKgLr3GNFtS+vVAKE/zLifHGe1YRyR+DPaR0GQgr/T5riwSUu
	qbjQYh4wdj2zkIv9kQpYtQsNapmLg8g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fBfiulsq;
	spf=pass (imf09.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773852639; a=rsa-sha256;
	cv=none;
	b=6PXZmo9tFOMzBCG5Dlkdhm7N/b9Ll6+CMlZghAoE+iTYZjPLRtPcR8O5bpMcyHALd8pCMA
	7MTEwobxPS4GwMVIDiF3e7qsWiXY/lhU31mzJw3jD22MCeL7jD5TrlXT5O+b6OgptPbT8S
	/pbHpPmwV1QoPrM4HuoC4ZgBtfRir6Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773852638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SYosXReCxKHTRtwKmKXBap08lvT05iVcC20sVq3tMSw=;
	b=fBfiulsqaj4qdVBjzD8SKI13TKF+5GKaH3rnnyelQTf/qtr6hg+Rb/gKWXF+DaoIkqxmCX
	+moVGALHat8e+e6XVqCUgUU9p+PeJNfwxuIqh0TUIrbV/5sng5Mf8NplC51UOcQMfDKjQu
	C4ujeMlG5rYx41vA3b7DFKgm8upzXiU=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-508-yK06XmPYOdmGm3PMjNJ2DQ-1; Wed, 18 Mar 2026 12:50:37 -0400
X-MC-Unique: yK06XmPYOdmGm3PMjNJ2DQ-1
X-Mimecast-MFC-AGG-ID: yK06XmPYOdmGm3PMjNJ2DQ_1773852636
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-50921f7da6dso466391cf.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:50:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773852636; x=1774457436;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SYosXReCxKHTRtwKmKXBap08lvT05iVcC20sVq3tMSw=;
        b=pSa3XmKTHBeBlGveMOI4qxlg5GZ+hNRNm011pVhEORvOzLjtsYppJCKl/XjoDr6Q0i
         ztGxAIxrrz835E8vNUwKXtpZiaItCgYe0kAmQXLPnXmguNqOujHq90aVyTN3zICEX8JC
         vuZXak5KLtzzpArn9qcwthNQ0wx6vDT6WdxFkioHcWiPc2AK+Z9uSFovhVaUmspIXcH2
         MHtz+VG9sTnYAITttwc2Ohmr1+Ao3p4PLYHdAcNf++luiISHxVaqsBqVRlP6qAZYLcDC
         1ceOxmj0gdBCj+G76w01BORnJ1TPGB79KHjFHVYYMMqpQJTzsF9F/wgnOWVJRt85b3A+
         +0yw==
X-Forwarded-Encrypted: i=1; AJvYcCVJmeyHGMCXIXDhOUnR1Rs6JUBxbJrEZ7wNtV05/AgiMvjunYKQ68Qkk0AryYSBlmT1kWJ2ptU6vw==@kvack.org
X-Gm-Message-State: AOJu0Yw5nN0mFbTLYY5X0G2SsetxZGX4vtWqGWJbLosPexkP9PyVGY9p
	xRIje0kRFM3SDjzqu3LAxmLznIlIkMZaNHqMPJviA2CrTZtTsYhibhGl0FcKiHdHOt2xLYZ0ZPk
	N9GvHNeZccdJbJhQNi+OM87STU08mVpQwzAoColtIFSr9pBrcErJI
X-Gm-Gg: ATEYQzw7tPGKmtlqLeX12mCcg2ay58JsBHZYVkyyQjiAoD7SkJEhzaacD7AZQJq00rS
	ASugsuCwJ76IU2yOodOBETgv1sgQeMCQp2L6IF1gzoHCz7gTjRZ/Fb3meveYgr0caWqarRfZ7x4
	8M77aVH6wO0GeJPtAz/PbIee2NNpEZQytMffG5h00x/Nlx/tWh1iw2tBzP16bhxOiKY+DP0YWfP
	5FwZaVwB6tAWxk3yYhFrNP2ML22xtE2VYirdAWt15MGpt1gCcYPX5b9XCNcMoLPN5qwSiT/ljMv
	jUHQKunZNeFR6ghctakPE4FuHWxZkLnZdyVBgsh4RrHZuJxpEukFL1zYG+0rtoH/bXHOLGVBxgx
	WSjj4Pfxw/Eg41eUxj+RZ7f9J9jHo9gq19tgid42s/u0HdI/qz57QNKUIMYDe
X-Received: by 2002:ac8:5d43:0:b0:509:59c:579e with SMTP id d75a77b69052e-50b14793337mr50991181cf.28.1773852636478;
        Wed, 18 Mar 2026 09:50:36 -0700 (PDT)
X-Received: by 2002:ac8:5d43:0:b0:509:59c:579e with SMTP id d75a77b69052e-50b14793337mr50990641cf.28.1773852635662;
        Wed, 18 Mar 2026 09:50:35 -0700 (PDT)
Received: from [192.168.10.111] (c-76-154-99-94.hsd1.co.comcast.net. [76.154.99.94])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b1348a168sm30717451cf.5.2026.03.18.09.50.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 09:50:35 -0700 (PDT)
Message-ID: <7d47a845-8e15-478f-8a4f-a3a04d6b7469@redhat.com>
Date: Wed, 18 Mar 2026 10:50:29 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v3 3/5] mm/khugepaged: define
 KHUGEPAGED_MAX_PTES_LIMIT as HPAGE_PMD_NR - 1
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jackmanb@google.com, jack@suse.cz, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260311211315.450947-1-npache@redhat.com>
 <20260311211315.450947-4-npache@redhat.com>
 <aa7a855c-88b6-44a6-a470-e1ca410057ec@lucifer.local>
From: Nico Pache <npache@redhat.com>
In-Reply-To: <aa7a855c-88b6-44a6-a470-e1ca410057ec@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: i4wb2j0ha8X0ZS1aaWajm0z3r-CbAO2OPJf_eYE2WZ4_1773852636
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-ZM
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2C78614000E
X-Stat-Signature: 3daxtfptr8ec4addx4gc3fw8ercsexpw
X-Rspam-User: 
X-HE-Tag: 1773852638-730693
X-HE-Meta: U2FsdGVkX1/CopOQm5qWjBWtExPPVIK98Sj6hzAHcaGgCDTS+TT/UfiDMXjWoKDOYTZO6aOKTvSoUe3+dsEiM0zELNVMvO7AV55eIATYMJh8zMLk+tmYwo5Hl+E8ZiryFrbiz0VsvoUWpjkQ3yKUK0d/Lr4WALziIqfpFqra7yNVbWzWhrnIKZjsOU+0iIrkwhqTbgrBhgPtDjqpvhADfA7bZc1D6DuI0hC2+vXKK8ksV5A17mUAvSrREia3e4PATug1cwgQOhkNoc9n1m8W3LgMw/9Q10/zwzLtk4JiYvOat45viDQsvq/r6M/1e1wOhENM8nQNcZeCmxLIc1Fc+hYwn1yV3eyKw8luaWuz6awiKeamwsTTyUD61POBrl60L63vqVxjfXHDWedQ7rhHB6Lu08xq7fIzjS5lERZ/1ve9Aj9GWjK5f/uEOdIX8cJnPF1E4ex+CBGROBQR8wEJPfcxDles3G4vyIk5s3mYtTcbHovgh2yhTB9funFUD5BJu+iEptsAQB2kRF1OG6bvev5VqjJTAziqlCVNaZ+y+O5Ede90yLjsROrX/0ToMuEEPSsuy8W78usQnF+u4wme/v0yNr1AibtH+fhfm5V1aZz0qYF74QWtwlByw1x2EWjL+gBtVZGLK4DGlj5MYLb+YVpM0Xc7E+zIMhp6cMahnucIA1CFXH1J8OHd+/WJNIwJ4Is59zOeW7tjeK5DLZ3b23n+wsuqODYi+XQalZC5Ji2Ofk/ee67cSPy/kbJ334gjlEKODmP/0vOvpcXzG8V7jB4+VC6dKuDdTiN93tDJ0/yDiMpJ5v+a2TKgI87GaUGbhMdSSCtdWoADeNjw9ztbAUY2Cag0+z1M8Wd+2tNYhIj4OHiXOndWILpM0ElA4PMhTxVgPxnkLTIEWHejYmueNGZ2ms85nYgXcncAf+/88ToluQCJNLWa7Ti1ctLh7hBpY0uwfHZQwTbsDf/zg+j
 aZtaCz49
 +YeC6ThKQAu8zeR9YutaIRwNsHQ/Gj9XnKPeDk5CJ5qpdOKO0jXbM9Iu1AVWapxbAy2tkXqBcIeFPl2n3anm1J0FNsalujyo9fU/DxtF7X22/VOvTwjLq3D1+z3v1BKD3d6iuajklG7Nlh6dTESPBBgvTHpgt0ErMz77ph/bc0qPdHbkJaWlyPKstwwPMPFbCS4lke116pYYJGQoFWpr4xeHfULLARrjjuPBrZ3J8ES0zxLyEgxRpQfNyK/CjFyJSDqEV6wyAsDPMc+l66uo9SNGslHHvRwXIms1aFDBiJZyXSjafWwuLMpGhoV6lBRNQ0hX+ZoRisQIGBZbDeX6YoQOizggTE4tNilpPLzamoLR6GfZsd/trjjy6nsPiNqlixIV7ssROO7b0kja6gMd9+j67/Lk9a0yQgxirnbFiY2zpjWpbysXc6a3/m9fCbOgxMFenR6sEbBR7IaRT90aPj1ElrGETT8/wX322E4bPNKEziEpkxLfKiOCrl3m3vFeXr4MqgkxWFNGnBLioybJzdZd+hcHInxEKVtCgO9hdW5U8009bA02ss2UgKwaz7ao5zq6gr1TjBBTAArNjQt5BKUKoHBZaIuVfYz3IFl2Io2V2shg3dinLuLIWj7G+kL/P0xI5K0EPn5jb9Dg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/16/26 12:18 PM, Lorenzo Stoakes (Oracle) wrote:
> On Wed, Mar 11, 2026 at 03:13:13PM -0600, Nico Pache wrote:
>> The value (HPAGE_PMD_NR - 1) is used often in the khugepaged code to
>> signify the limit of the max_ptes_* values. Add a define for this to
>> increase code readability and reuse.
>>
>> Acked-by: Pedro Falcato <pfalcato@suse.de>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>> Signed-off-by: Nico Pache <npache@redhat.com>
> 
> Hm didn't I suggest this? Or actually I can't remember :P

I think you suggested most of these patches ;P Ill make sure to add your SB tag
on the followups!

> 
> Anyway LGTM, so:
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Thank you!

> 
>> ---
>>  mm/khugepaged.c | 9 +++++----
>>  1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index d3bdec4ec61b..db77ab5b315e 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -89,6 +89,7 @@ static DECLARE_WAIT_QUEUE_HEAD(khugepaged_wait);
>>   *
>>   * Note that these are only respected if collapse was initiated by khugepaged.
>>   */
>> +#define KHUGEPAGED_MAX_PTES_LIMIT (HPAGE_PMD_NR - 1)
>>  unsigned int khugepaged_max_ptes_none __read_mostly;
>>  static unsigned int khugepaged_max_ptes_swap __read_mostly;
>>  static unsigned int khugepaged_max_ptes_shared __read_mostly;
>> @@ -259,7 +260,7 @@ static ssize_t max_ptes_none_store(struct kobject *kobj,
>>  	unsigned long max_ptes_none;
>>
>>  	err = kstrtoul(buf, 10, &max_ptes_none);
>> -	if (err || max_ptes_none > HPAGE_PMD_NR - 1)
>> +	if (err || max_ptes_none > KHUGEPAGED_MAX_PTES_LIMIT)
>>  		return -EINVAL;
>>
>>  	khugepaged_max_ptes_none = max_ptes_none;
>> @@ -284,7 +285,7 @@ static ssize_t max_ptes_swap_store(struct kobject *kobj,
>>  	unsigned long max_ptes_swap;
>>
>>  	err  = kstrtoul(buf, 10, &max_ptes_swap);
>> -	if (err || max_ptes_swap > HPAGE_PMD_NR - 1)
>> +	if (err || max_ptes_swap > KHUGEPAGED_MAX_PTES_LIMIT)
>>  		return -EINVAL;
>>
>>  	khugepaged_max_ptes_swap = max_ptes_swap;
>> @@ -310,7 +311,7 @@ static ssize_t max_ptes_shared_store(struct kobject *kobj,
>>  	unsigned long max_ptes_shared;
>>
>>  	err  = kstrtoul(buf, 10, &max_ptes_shared);
>> -	if (err || max_ptes_shared > HPAGE_PMD_NR - 1)
>> +	if (err || max_ptes_shared > KHUGEPAGED_MAX_PTES_LIMIT)
>>  		return -EINVAL;
>>
>>  	khugepaged_max_ptes_shared = max_ptes_shared;
>> @@ -382,7 +383,7 @@ int __init khugepaged_init(void)
>>  		return -ENOMEM;
>>
>>  	khugepaged_pages_to_scan = HPAGE_PMD_NR * 8;
>> -	khugepaged_max_ptes_none = HPAGE_PMD_NR - 1;
>> +	khugepaged_max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
>>  	khugepaged_max_ptes_swap = HPAGE_PMD_NR / 8;
>>  	khugepaged_max_ptes_shared = HPAGE_PMD_NR / 2;
>>
>> --
>> 2.53.0
>>
> 


