Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 482B7CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 08:44:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 794108E0040; Fri, 17 Oct 2025 04:44:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76C058E0016; Fri, 17 Oct 2025 04:44:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65AA08E0040; Fri, 17 Oct 2025 04:44:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D7568E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 04:44:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 00CA3C0586
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:43:59 +0000 (UTC)
X-FDA: 84006968640.20.3D9C786
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7FC15A0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:43:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g6Pg+pYl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760690637; a=rsa-sha256;
	cv=none;
	b=XPzvcBnocsgrRL2Pr4FBmrP7iwf0U7hc1+dlz04U8jWL1Ollw++rjdTcWDfs4dpIHosV12
	SLc9Ly0UajsrSqwh0Z8UMd0f/TfNtEOiSHm6+xFXIAMCb7W1L4IhaoW0YZp9FHhf2805uo
	hG9oGHhtuOREWqoXyVKZXetkAunAf7I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g6Pg+pYl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760690637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hdjQ4qyzWoJmN2qqSnfHvdTH6aak7xEA6dFVesveV1s=;
	b=VC7fsGrMPmv5g0kGlot0K5IQeglGRImIVLddO69b6MiL/uRIP5RbK4tXgrqor37/Kpl8BY
	c+ybnA0ndG2frqe8Dg3pH5vcnrcQ8NSHLv67UAh8Ot/BGPaOKGg2MYSSZcoYyWc7zz18Qn
	9jYKND1lOBxW6+olCZ6buXeAwKKxEWE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760690636;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hdjQ4qyzWoJmN2qqSnfHvdTH6aak7xEA6dFVesveV1s=;
	b=g6Pg+pYlvFeE4wN50JB6rlAc7d9B6neiFfF0WEJdW2q981ycEMnA1uRYXwlU6K/TGF8C6u
	8b4T1NU/VIZ0rsbmahNMKd7wbUTcNrVd/6bf7E6QI44XtAn9QpES3wMVnNi8c5YK/BFEpL
	EGvX2j2IDaBbJ8ZTwCH9iCMHm5aP8wc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-287-FoKxghlzMbuaYWFmB9--xw-1; Fri, 17 Oct 2025 04:43:55 -0400
X-MC-Unique: FoKxghlzMbuaYWFmB9--xw-1
X-Mimecast-MFC-AGG-ID: FoKxghlzMbuaYWFmB9--xw_1760690634
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4711899ab0aso4600825e9.2
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 01:43:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760690634; x=1761295434;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hdjQ4qyzWoJmN2qqSnfHvdTH6aak7xEA6dFVesveV1s=;
        b=EqOODkathWSayFisjXjlUzE/t6dDtaISXZighowq3PCaXaLxv5oiNOzF3ciytHhPNd
         kUHZ+e7f90vId2u83SGlfQR6vf2jJX4K658hDqoJGDigwjVLfgwK7LpxUQZLUWlOt1uy
         l/UsjAj/iqpD4aDF75ALeiSFlAc+rc2UgmrUoKs3R2CsiiAOYuReERqR+Xt1vRxXpK0E
         iti/9dfIqCuG3JXIHrPZcUGy+RgN6+dVE1PcTs8HkrLWzwXAyflfBV21fvVmpajpntI1
         aHeq1CgwWYlXwdVJEjrwMfCZg/9J1WDRNh+QqyD9LkQTbQzZRs+Q8jk08bUEUb9ZSdtP
         F6Hw==
X-Forwarded-Encrypted: i=1; AJvYcCUimEFnLFxjqP3wZ6Uwl64ArWIguAQ2WSBw8ShThxCQ02wxCHIbvpgFnsmgipB1IY0otYbWIn5b4Q==@kvack.org
X-Gm-Message-State: AOJu0Yxbbo0vYpGm/TTg6EbI85AxA1UszHYHeUGZhNkbSAtNGpF2cuSm
	S/YxfqIam2/gT/Z8EmvWRrd9WbJILAhIm5LEoi6N2WvoGX9Mk8EOphjqRKNWZBhqJKkZrmgHO67
	hhyoVnM0ZEkn0AENQuDQgwAi0nvNojIuLnqzD7SfxJVwd00+sVAo/
X-Gm-Gg: ASbGncuPuYnv20VfiWv6SBDHbTm6G3KVKW3uyihiCyakOpSxRtPtLeHO8esTFrgFtSP
	KH1X30xBOnL6DeY+aclpWInpHw6FX4VzSutQIJf5eAQBRQGMljUyOPxGum5aZiBmGQ+jDXrBYFl
	HIh+KX0IqvZD3i0AMhB9nIlejlxfpZPvOMPPPa4yEUIIVwC0zV7f8llTiLoXcrRgTRuuKLCAnjX
	urqYwnCwh1ZNmfJuNE+O2zIeSkY12NQNidX163FtMSsJYmxwOAS+si43IL6smjMXTdemmzJq1rQ
	mK1xeBxwlTyGVxhL+mQFkffeSMSgPaxxmjszohiwG6qSFLRIUQLCVhL5/9b8qumGvwrOqbflEzD
	XxsPWOZePqdxllxqtgyJtYFX8VhtAnopylnCpFva+EisdBFszX1buYrXLJIRonZvChQ5/VSWXN6
	1V5N2wt7qzTdnKMip7reR9dkOxziQ=
X-Received: by 2002:a05:6000:26d1:b0:425:75c6:7125 with SMTP id ffacd0b85a97d-42704d5219emr2173319f8f.16.1760690634345;
        Fri, 17 Oct 2025 01:43:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEWpf5r9YWNP2HCmN5FwKsBoth7gpS6CovBTFafFM53yr6iZIzCOSgetIwZnTDLGS7ar2cFYg==
X-Received: by 2002:a05:6000:26d1:b0:425:75c6:7125 with SMTP id ffacd0b85a97d-42704d5219emr2173295f8f.16.1760690633874;
        Fri, 17 Oct 2025 01:43:53 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42708bcea1bsm1267844f8f.14.2025.10.17.01.43.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 01:43:53 -0700 (PDT)
Message-ID: <4a7a7fbb-e33e-4033-91e7-efce7915cf7f@redhat.com>
Date: Fri, 17 Oct 2025 10:43:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new 1/1] mm/khugepaged: guard is_zero_pfn() calls with
 pte_present()
To: Lance Yang <lance.yang@linux.dev>, Wei Yang <richard.weiyang@gmail.com>,
 Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, ioworker0@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251016033643.10848-1-lance.yang@linux.dev>
 <17c4c5f9-6ac8-4914-838f-f511dfbf948f@arm.com>
 <20251017012724.4bo5oj2g6tdmp2fv@master>
 <1674efca-6d4e-4247-8b1c-b6816360d8bb@redhat.com>
 <ab918a83-edb2-4a19-821d-a96de9e097eb@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <ab918a83-edb2-4a19-821d-a96de9e097eb@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: obcmU1DsunbhdAPNbX6V4DegQLzNsN6YT6NbSb6Zu8w_1760690634
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mqhr9cmbjjtoeyrgownfr1r7r5n3r4wk
X-Rspamd-Queue-Id: 7FC15A0006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760690637-276416
X-HE-Meta: U2FsdGVkX19KRDO3oWv3Jml8DaQHCI5BzQwap4a9dEVpdjKlmr+r5sr88h7IHuc3HPT8EDnOvI/L3FhLEYqC33/e5cwiTemgnLiOaaApe72SQeSKzhqjf+gp/GumVRCGzFPGLFbkDIhRyDA5rirgZnpWNsBBczGx96kCpMVHhNEs9q0/wwdQqswfZZQxgKILi71GP5217B2faLVzKJqvRIjs7+o1Z4c10RXc65pYaoCxS0nzw/U1FRmJ0abtsW07MIodYTZ1Mmku6jDS8ktAsa7LeTeQkzEodRxbBPtu+r+GN9Tph+363vTAoAE8/sdCzan1Lf0GZtkF3THvdQzEQehJDMzTTY5vNsc2DiuCni+vSyASahLQPj2ePOEfyXkTsAkFUTCAy3N7sKY1Tw0O7Z9DdNBBgWY+Y/krFEQeIuSPUGlDixS0GOoIYbry6cIi3IzK6z+7FF4mED5YdT96WnOjYPInY5RIIuRk+iitvelpTYkPo8pc4eLQ529HGElhnXwRQMU/fBzBCyOnB/7E+dpQoh4+bTY71Kj2dUsma/Z0J2RrO18aU8kVvt4wn0aJCEY0E8OplDqTRQobEZXyALVBQZStTKUjNl9MwKfENNqntvIc8ckBOHcxkqvVF/h2Mp/oh4lBFc4Ove9sT9GcKyB7693IWjaj3gZRYLL9hK0Md5TPpUITcCrDeCgjysSUP7PYejdgpdyS8x2zo9Qf3VXUkAB+7brzSN85dCdH4u4CH4reqpcXgnUiFtfJ3uZoS68S1vjO0sgsIs52srnr9Pz2SRnHWxG0HGoP79gqNsNx+mbHSmwS2Ncu8hjAMKNNAYnsa9QUFksQLNBDMgnohb3FrILPChI5XbGHW6ekMn6+doCYcm1L8BeYwGdX9h9wcvmu55mnFtIC1zv5kbp763mEUCOydlF/qPAMNlIV2AkpyfrvtzQ9Tj8ONabpnbn8uS83V/TKtJXqu6FybFq
 49ZaJiFE
 b/fqX7Q/cM8F266Z4jXOCwxwKWx8KUxg08MkpajbCL/9CWKThXPkUTS9D3Z0u34cW3MpqI3QBOtSgXkJ9C6+sxOqlNMGCIMgfyXH5pRzHEiN8ZfP7jVse+E3NYOmd0dS7j7UJ8gqq2QfGdsAOfcVmzqVKQ9OnPXHnZ5rjCFb2fFo6gAO4rKZo5/7eZMobOQ9fvJbcE4YSW0oOHtA29v32+z+DFM+D1YUk0PdGGtF9+dzIyO6HctYVVcdb2eA8ycLZCRoKcFnBb6aHx4ZbZ8avJ+6dsuRCVT/mXkhFNBLpHLok46i1q9x1roY48wk91sta4uPzJPctNCHDXyXqtunrAjQIJO0Pe+Hc+YMX4TeZ5Vqc9iz4xf3ykGY78brKkzXTMV7xbXYA4V9s2ugAspocWl7Ft/kUOs5nVY4PzO2kc+M+QTyf7u+aNjXss/R1ZFi8A7s5z7/Txu0U9DnwdBiVHnbRDRkDFNCG/BQdWEGRuuxzMAgcUcnIt+GnOTUQKXAyO7IXTzyScCd6oaHV1OcNek64c9B1ACz7UaaqYn5P+GamzrBq/yT0Wvz/qpZWlH7REDlqDPAGNxLgejZbFi5Zwng1rA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.10.25 10:37, Lance Yang wrote:
> 
> 
> On 2025/10/17 16:11, David Hildenbrand wrote:
>> On 17.10.25 03:27, Wei Yang wrote:
>>> On Thu, Oct 16, 2025 at 11:47:06AM +0530, Dev Jain wrote:
>>>>
>>>> On 16/10/25 9:06 am, Lance Yang wrote:
>>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>>
>>>>> A non-present entry, like a swap PTE, contains completely different
>>>>> data
>>>>> (swap type and offset). pte_pfn() doesn't know this, so if we feed it a
>>>>> non-present entry, it will spit out a junk PFN.
>>>>>
>>>>> What if that junk PFN happens to match the zeropage's PFN by sheer
>>>>> chance? While really unlikely, this would be really bad if it did.
>>>>>
>>>>> So, let's fix this potential bug by ensuring all calls to is_zero_pfn()
>>>>> in khugepaged.c are properly guarded by a pte_present() check.
>>>>>
>>>>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>>>> ---
>>>>>     mm/khugepaged.c | 13 ++++++++-----
>>>>>     1 file changed, 8 insertions(+), 5 deletions(-)
>>>>>
>>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>>> index d635d821f611..0341c3d13e9e 100644
>>>>> --- a/mm/khugepaged.c
>>>>> +++ b/mm/khugepaged.c
>>>>> @@ -516,7 +516,7 @@ static void release_pte_pages(pte_t *pte, pte_t
>>>>> *_pte,
>>>>>             pte_t pteval = ptep_get(_pte);
>>>>>             unsigned long pfn;
>>>>> -        if (pte_none(pteval))
>>>>> +        if (!pte_present(pteval))
>>>>>                 continue;
>>>>>             pfn = pte_pfn(pteval);
>>>>>             if (is_zero_pfn(pfn))
>>>>> @@ -690,9 +690,10 @@ static void
>>>>> __collapse_huge_page_copy_succeeded(pte_t *pte,
>>>>>              address += nr_ptes * PAGE_SIZE) {
>>>>>             nr_ptes = 1;
>>>>>             pteval = ptep_get(_pte);
>>>>> -        if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>>>>> +        if (pte_none(pteval) ||
>>>>> +            (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
>>>>>                 add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
>>>>> -            if (is_zero_pfn(pte_pfn(pteval))) {
>>>>> +            if (!pte_none(pteval)) {
>>>>
>>>> Could save a level of indentation by saying
>>>> if (pte_none(pteval))
>>>>      continue;
>>>>
>>>
>>> Vote for this :-)
>>
>> I suspect there will be a v2, correct?
> 
> I was hoping a v2 wouldn't be necessary for this ;p
> 
> Of course, if we'd prefer a v2, I'm happy to send one out.

I lost track of what the result will be, so a v2 would be nice at least 
for me :)

-- 
Cheers

David / dhildenb


