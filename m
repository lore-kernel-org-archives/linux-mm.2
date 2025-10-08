Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8E1ACCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 01:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 242A98E000D; Tue,  7 Oct 2025 21:21:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21A108E0002; Tue,  7 Oct 2025 21:21:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 130C28E000D; Tue,  7 Oct 2025 21:21:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 015D48E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 21:20:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 946A4B6AFF
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 01:20:59 +0000 (UTC)
X-FDA: 83973193038.12.97084FD
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7BC1E140007
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 01:20:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QX8jfQpa;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759886457; a=rsa-sha256;
	cv=none;
	b=S70zEcg1wD03dSgzCoCCyRNGhIGTX7fkYkctl+Y+fooIoSwyiQliuPrgNA4ugVIGrSGM/T
	y46mN/eR1c+Ct/sZJ/ZxrX9vAEnc2pYAteyaomAY7AkGY6NpHt+R2WnxwY0cYEzVHM4TO9
	vtR/DFUL09Pjc1j8NVkiBTzg/bVpLO4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QX8jfQpa;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759886457;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S+Th21zxUhTrB1dp/TUnEm5rQSul2auVB+KioYdMDoQ=;
	b=y6tCObT3uYc/InvyUrdeR2L5BbniBJVcdziu4nEZcRNVZKX3na4LoxlEveJaOcFvTIlrp9
	YlWENaKlFogCPKYK5JK2LInAcaG76J5bjH4eFQSsQ3rONCYT9fX/oo6/U4jeYUHmhlrX+E
	4l+bdM61y0upQepQPzMmgJzysxMEZ3g=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b3e234fcd4bso1137279066b.3
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 18:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759886456; x=1760491256; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S+Th21zxUhTrB1dp/TUnEm5rQSul2auVB+KioYdMDoQ=;
        b=QX8jfQpa5kaupxIj0nRGr0Goz9Gld3VZIgPVaJeuo8m4sanvOYfmAeqWaAGGZIFrCD
         +99qiSXQuukMoTc0B8coaa3obnZwJXtiokaOeQBax2it6KKWxEGB/UDT/gTRw0CS9td1
         RxB6QLgHNKkCHCx7WfQ7ALQRaFU5IaoQZGZc+jjiFt3c2/L8REYmpfC1WKaD4yRPGvsu
         if5l5wPOqLWbF4m9lZl/yRjZeiFGXA6l/xT4zAjPHQywGc1Srjz7B5F20+NCPEy+kW4D
         Dupmv8qSJiji/bmReorBd2/2riiH3INx2ck1rqOdkQC7UOrabwjUrKqax9KvKjigTz5M
         sXtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759886456; x=1760491256;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S+Th21zxUhTrB1dp/TUnEm5rQSul2auVB+KioYdMDoQ=;
        b=P4mYYhWHjFImXMTp6KHJS/FRAGguYz4Ofns4YNAsfNTotn5pgpq6WbEuMRZRtXHJwb
         jLfmUpRiCZBtitOxn7ZdW1XGehIsQLaUVHNwMjZuRc+MY7zd7XRxyxJmaxyx6Dhn60lX
         eFw2t6tnjjlUogPCPmbtPe86jVCb3CFkMa15UAYAT3TyH0E2cPjiYiVLkMTx1NvQOfCA
         xJ4OF9son0/IgyujTsHNakbYPEFF4/q0iZQ/fP+2T0CkhV8jWT7xYxraLk+f2eI2Xzs7
         2gQDh/T8L0WzXgBXeI/jMXV0iDngv1OLXjKCxtdzGVSO5vQrR8eaWdscVm9Bk6r0K0Jt
         BubQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgYLGk9aR7kGO3OtPnw0mKw+K5LmAnxio9C36kml6Q5dgGQqO5y49Isc+f8Dkdg70ttcKRI6jhrg==@kvack.org
X-Gm-Message-State: AOJu0YyLcecae12FB+3dbWXi2JrUmFG33TNpEpXwP56LDi0IKkbRT5bM
	xXk2i5qxMzMnjvywJ1JgOsDvtLZ3aGI04D7ZT9UiJLuqsFX7MOOV2c8L
X-Gm-Gg: ASbGnctiBRPmo7B5Sy6B82qCXCLHdNI1YlKrVOQixcPRuIUWY827dxp+GuFfn9gfca9
	u9eYzTQXFy/6s/Yb2Mmi1J5nHHh8HBpIgdOzq7Vd3uCBJ06bk32Me2oEiZROkJruxeTW8FrFG47
	MuKOsemO3UQQN0LsC8n37LY/agcJGYkC3V8n6MVuiH7DfECWBsUINPnfXlj5xGDo61lRmxoyvFy
	ytXSZFj+OuLZ3U6pQAtu5aMmy9rne9jJ7o5qxx97xde7VtMG891chT9ihieWy5r3yPWnSEjvXXe
	FPczM7KIXnkEYrAThJNDLmVyld2AMc0GiLMLXLj9tKwER/275da7b2EyRREP/NcoKNfUl9NxDHK
	DIOFqaYACtwASpxNyOWP2rEto2VMdBfqgCD+K3aTalshUPS/URA==
X-Google-Smtp-Source: AGHT+IHLTEIF8Qpj3yRJ3nj4gjzuwalbtmFLyIveo0tESeJCyhilwcWe7hVQQcCIaaLiA7kueCPcfg==
X-Received: by 2002:a17:907:26c8:b0:b43:3dcf:b6c3 with SMTP id a640c23a62f3a-b50ac7ee211mr173982066b.49.1759886455588;
        Tue, 07 Oct 2025 18:20:55 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b48652a9e66sm1491182566b.14.2025.10.07.18.20.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 Oct 2025 18:20:55 -0700 (PDT)
Date: Wed, 8 Oct 2025 01:20:54 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
	Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
	Usama Arif <usamaarif642@gmail.com>, baolin.wang@linux.alibaba.com,
	Matthew Wilcox <willy@infradead.org>, david@redhat.com,
	lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, npache@redhat.com,
	baohua@kernel.org, Liam.Howlett@oracle.com,
	akpm@linux-foundation.org, Wei Yang <richard.weiyang@gmail.com>
Subject: Re: [Patch v2] mm/khugepaged: unify pmd folio installation with
 map_anon_folio_pmd()
Message-ID: <20251008012054.llwoempizf5poi4g@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251007005022.24413-1-richard.weiyang@gmail.com>
 <ed17533d-912c-46a1-8407-29fd989f22b3@arm.com>
 <6253b463-bdbf-4c79-b1a7-65860b76beb4@arm.com>
 <e0566f96-09f7-406a-8c7f-da6dc476cd60@linux.dev>
 <b2a474e3-58a0-45f1-8015-46b30c2d0660@arm.com>
 <69B96963-AA57-4042-B00E-59260CB2514F@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <69B96963-AA57-4042-B00E-59260CB2514F@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Stat-Signature: 5t5k495fhariyuk78xoso7xk9kyae4ji
X-Rspamd-Queue-Id: 7BC1E140007
X-Rspamd-Server: rspam09
X-HE-Tag: 1759886457-485488
X-HE-Meta: U2FsdGVkX1/nUbUJvmcEOz27CYlNpWWmSQ1w/XI9uA65DzIGIifyEO3iqgsrzGplZGnrOHkjDY9rObP7aaU+gWwYEjwTxDaCEodDCFKXpmy6iH5sJK0hIOKBTldV11JyB4hBWZ3FuQeXGt/x9IsmhfYvaaN9N0/KLBesbU28Q/n5K/uGYupbv163OAzVJzTVmfMNGU20BI+qzxng8xiWQixKaGTZNddGrupRb8BjnetNQ4jnTfg9hOtp0ItPB/b/WcLnte+0fqaVw7ZuJ270vft9lrR2/oPX7Gq1J9OjL3wQRHpViUtDrKOeXtGnFbPQqApDkJkXd+dVRTOfc+hcLYd4YobqxWcarkD1/XJtyMvIDg7ndV75qL/czf4+XKZTqVZPoLznWC+J5DXK3WRuulc/4NFLhsLoUCRtQ9U02gjZntQO53jU/+WLN/ZgPzjfZ7WFlpLgJuFvXoe8clzKjUsr4rqffwN39okqM4fdzu1o050M3o5G5D3E453Q9siBfKtRtJqWDQ/+IuqoKUwWFGj5P+xyTWh28Z8/jYWzO5uzNqSm2FBZ71pK1FwGQX0grKHWlspmogA4MLXsl6yfOD+cFaxlcX25TBAQv8btA6OXEj9NF0Pu0tJUcHoSDCyaQPk2cts5mUgL/dXoRwHZKaG+oE5Vo+1y4SXmV6jk9P0P4oZVRXtxRQuaI0wD3kimYElOzQFFoOxlnQPoxI6ZC95ITttL3KSR/b/55V2gcnkK9nUWU+dFZAoJ6PV/L7Tpz6t+zhkcJ2vgqecgnDVNMzS9h5lUGQGMCWGN8xual8+dCnKWQ4zO/R8kdHpRUbEqcyyqiUctBYNdmgTaetqydIAWK1ugr8R05AJCyKG3jKKP5bMrPinyQnLayOEdAfFcKWsAf2DbMMc6R5uAmjj8Kck/Sa0xGb0n2bSTppgtNYz5TTku436CTwRBl/lgASwi1gVey0a30y714wqkEv2
 ah0zOQXR
 HnNebIJM+WfUKYwsdAmk04rjHAaHIcEr92lAw7RX2RvIsKBmHnDaSvmfOW5GOfHaZPFY9/3PAIWn4z9L+CIoe/VwhW2HSXMOBxmE6YasGmRv2GncG6nKhuAjl8WM9du+8MlgmE4VhzEMXEWlXDfozGpr8C60K8g3xSGXFqtOTSAzdnoM9tVG9q8Igd+JtJPSn1OGMyc8WUAXdUtyA9U+psyDF+kf/jWkGNWe6VLCgnap2suplt3XPcS9lym7hw0OpqvpCDgr2CIb9IFxlSu+JHaQhA9qL61p+wuSPNN+aAKPDwTezMMFFO7WJ+1v5IfHzxAKhfnGY+6xiitYN1OjBB9nHQXFox59lwjSaCRiC4OxEcytx48ZgQHFIQuiTVsRFYsjg3IwCr6cEGSaZfpSb/wEk5ibpfoyXnQDmDGQU82huxSssNq2yOauH8mOA+Cn6NqhrwJrDE8WRwu27N16UeX87nMJi+gCs/9/YUCOU1ILBNaqfbPhtXTMdFNeqpZp1svM6otiwA8NWiDj8kH58n6KUv6Zh4H5cCzoPcH63kWCaRxKY4+3hhKPL0SeEue1H8t+82zdyD5ncgkiKnT4XWyFWPjrgyWir04k9eYzOlRBiuP/tl566UnwTc9FttPqqq+H1dVa+1kyUx9TdFmTjRJhBphHQ27R5QaQ5zAhdAu9vTJUs4lE8MuSmgG+eiV1ZslmG1mceDzlhk/R/gt70E1aXNvkz3ezIJ71rh9bnDCplQQxnfIXQq8teAnKUVRRG33/OVhV6yV7CtWuExIpfswVcqSV89pVkszINGXMmRaIg0FK2bLmYY8NMknPjvk9RIgUMB4ztNKKK19K+DRg83wp8rSi9P0DXwON9JDZriHMNsN+OjJ1n5BE5Ebmlje3xFhSoBCj8vMQBRP1hIYLnbQXAfxmkOvcHF1uvx++rUSIGZvtuWPdCevJXgF5yljWqz2IfoP4JncoMEupiWr57yTPeOoPZ
 IkuTRzUw
 +NDiIu+HaXQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 07, 2025 at 10:59:33AM -0400, Zi Yan wrote:
>On 7 Oct 2025, at 9:11, Dev Jain wrote:
>
>> On 07/10/25 5:54 pm, Lance Yang wrote:
>>>
>>>
>>> On 2025/10/7 17:54, Dev Jain wrote:
>>>>
>>>> On 07/10/25 9:36 am, Anshuman Khandual wrote:
>>>>>
>>>>> On 07/10/25 6:20 AM, Wei Yang wrote:
>>>>>> Currently we install pmd folio with map_anon_folio_pmd() in
>>>>>> __do_huge_pmd_anonymous_page() and do_huge_zero_wp_pmd(). While in
>>>>>> collapse_huge_page(), it is done with identical code except statistics
>>>>>> adjustment.
>>>>>>
>>>>>> Unify the process with map_anon_folio_pmd() to install pmd folio. Split
>>>>>> it to map_anon_folio_pmd_pf() and map_anon_folio_pmd_nopf() to be used
>>>>>> in page fault or not respectively.
>>>>>>
>>>>>> No functional change is intended.
>>>>>>
>>>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>>> Cc: Lance Yang <lance.yang@linux.dev>
>>>>>> Cc: Dev Jain <dev.jain@arm.com>
>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>> Cc: Usama Arif <usamaarif642@gmail.com>
>>>>>> Cc: Matthew Wilcox <willy@infradead.org>
>>>>>>
>>>>>> ---
>>>>>> v2:
>>>>>>    * split to map_anon_folio_pmd_[no]pf() suggested by Matthew
>>>>> On which branch this patch applies against ?
>>>>
>>>> +1, does not apply on mm-new for me. There have been multiple patches
>>>> changing the same file so it will be beneficial to say what commit
>>>> it applies against.
>>>
>>> I think this patch applies on top of the patch[1], which is based on mm-new.
>>>
>>> [1] https://lore.kernel.org/linux-mm/20251002013825.20448-1-richard.weiyang@gmail.com
>>
>> Thanks, but this is not yet in mm-new. There are some unaddressed comments there.
>>
>> Wei, please resend this patch based on mm-new. I would urge you to hold off sending
>>
>> multiple patches all of which change the same file and have close dependency, till the
>>
>> first one gets merged.

Sorry for the unconvenience.

>
>Or just send both patches in a series to show the dependency. That makes
>reviewers’ lives much easier.
>

Thanks, this is a good suggestion. Will resend them together.

>Best Regards,
>Yan, Zi

-- 
Wei Yang
Help you, Help me

