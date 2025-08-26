Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6F33CA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 08:53:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 146388E00BD; Tue, 26 Aug 2025 04:53:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11E368E00A8; Tue, 26 Aug 2025 04:53:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00C6B8E00BD; Tue, 26 Aug 2025 04:53:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DB45B8E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:53:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8D6D51606A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:53:54 +0000 (UTC)
X-FDA: 83818295988.23.AC06FBE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2FDD2100005
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:53:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CRHSOYFN;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756198432; a=rsa-sha256;
	cv=none;
	b=KSJKVQUm8Ddn1IDrVguccs75Mz4TdU9gzAGYa9ZzzJdjDIhbFkItTqZbv3hn7+3N/D5WxC
	CAYGY/m7k78gh9IrBTke1UFhJUOAKlUTKwX38HNC+joV0T9VBYOk1AL+HvkhxnoOCWeVkX
	o00xh7j1QODf96DQFgib5Hrnskmkb58=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CRHSOYFN;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756198432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=APZznLybhVD19xT3RfskgWTFRpI96KkL2CP6iOiZhOc=;
	b=0cZIC8PWeNxENGJpG4XjJ2qycQeUHtw+ABosGRgtpS09S36nQhn2Pjvj4LUNhSTu66GhZE
	mvre55jUfUipPFPUEfJzNDLmnUqmQVxLiPrM5m/9fcvpKdzgmZaqIOeMsbi91J90yL9U9d
	QQnknW7BlrT/c9IyzP32LO2EfIvpYGk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756198431;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=APZznLybhVD19xT3RfskgWTFRpI96KkL2CP6iOiZhOc=;
	b=CRHSOYFN94MXYxx7TNN4mrt/bXXnMmc5RAUfDdvdJyoyA/Ebvka6A5D6Nc0k64xHuPx+za
	4L3ivCRDxZcxqexh1fPC9qq7VvfaQekScQJK8IqYwvlF7mrC6ZUq1m2CV3bPFRvqMscn0H
	zEwDv14/Rwzc3jTLScPh2aG++LQC+4I=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-440-mTFiZiiCOUaPm8UrBY5UOg-1; Tue, 26 Aug 2025 04:53:49 -0400
X-MC-Unique: mTFiZiiCOUaPm8UrBY5UOg-1
X-Mimecast-MFC-AGG-ID: mTFiZiiCOUaPm8UrBY5UOg_1756198428
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-afcb7a3771bso443618666b.2
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 01:53:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756198428; x=1756803228;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=APZznLybhVD19xT3RfskgWTFRpI96KkL2CP6iOiZhOc=;
        b=hxQKWsq7f70gdYiVqciRZ+e2e1lEIEJ5CK7TL9FIKpfp8Y2/4zSHaK4XC4eO0PjXMF
         aDoT/50y4oLaF6UqgKokZXx6RubfksZBgGGEBYFBUc9DW5HGkbYkMmctPJsRiiNStEp1
         eJKbKdRpeOh8hQkQdQibBVZSZS8gtdmwzk1K91BrzPqZB+5LUZFpS1fxhVFfohhQzlTs
         ggQOFaGAL2XfTaj+FGd2KJ19w/AmlOHS1w3rkpdeC5EUJUGnzp3l+7FerwzyvdlfyIag
         787VDa0hJ61gmfhPoA8aPg5FCaTwkgos4OTuwHMT8gAQcifCeOElmaAGWKphRDe/hWQe
         7f+Q==
X-Gm-Message-State: AOJu0YxgTUJrw1hQ4d/b6Tt8H/fjUU3ykaEIlZDDiQtvNOdZXc6vU5sJ
	/4OEJcBhCnO1qLDddmS2enSanropCoEji4FwsqKwH85rWHfRX0aWOkHvu7qDkpR9pMq/w5dgZBx
	5D+1wHW5mTOG/uSXDfxQQc/i88NkQV8NqLXpMxyo0fojP2amxI+rd
X-Gm-Gg: ASbGncvQDgkDbPVXwe+ifynfhA6H4ZKv6VA8v87wQ+kSnkWzyul5qq/jbZCnM4y6gw7
	eV7MYgQ+iOmgAnoi79NTkgCpgqV2W2qScyj1ZP50MOhgBOpfr8AmVDzoqFQa8ysi/W3J98MGL7t
	pKlsaSe5whFBJsuIuLWnTowVHArGevdVvyjwl0Twv9KThQrCv+4THMbMDIXifSTuBtIytgLorQs
	ZDbRfEXBuKtAybdLogPT9HOwU5rlsrqLBPbTVC5hSvS2njAs33/47OMW/fvB9zVwsybfVu5a/wR
	K/OUveu/GCCh8nqMYBwGwwg5/wcmPYTDO6+SiFwP+BCcHRtkU481e8bZBgmT03/psWI5iqHN1Q=
	=
X-Received: by 2002:a17:906:6a16:b0:afe:8bc8:d7bf with SMTP id a640c23a62f3a-afe8bc8d966mr450782066b.26.1756198428303;
        Tue, 26 Aug 2025 01:53:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFpl/o4mt0UnJPVGPS05+bdnJXcqQoJaT1Czt0kEXYHRDnKIHrYNNuzvosXE032ZUm5rLbSMg==
X-Received: by 2002:a17:906:6a16:b0:afe:8bc8:d7bf with SMTP id a640c23a62f3a-afe8bc8d966mr450780166b.26.1756198427826;
        Tue, 26 Aug 2025 01:53:47 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61c310ab189sm6875327a12.8.2025.08.26.01.53.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 01:53:47 -0700 (PDT)
Message-ID: <0a2004c2-76e7-43ea-be47-b6c957e0fc14@redhat.com>
Date: Tue, 26 Aug 2025 10:53:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: fix the address passed to notifier on
 testing young
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org
Cc: linux-mm@kvack.org, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 stable@vger.kernel.org
References: <20250822063318.11644-1-richard.weiyang@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250822063318.11644-1-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TTyVf8J1x5OzjptGpTSqzDCbe1OWYamSCPiCnpQYtIo_1756198428
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2FDD2100005
X-Stat-Signature: a5yd5gbwk996x7embpm3jrdphzf7idn6
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756198432-380857
X-HE-Meta: U2FsdGVkX18urUSTGlJFoHpv+e6m5TRpP3Cq1NuCZK1XeMQYU05AHmM1UA5ixIWeGQ/Ypl4uLl1sNpP0Z9DvsU/UxsuI2H7Fs83mGUinxgrMMfSDVg46psC694TNnEJX871h+BUIZh2Fy/i5qnqLGWwIOGTAYwtFm7A5qBSd+LzKCEfjc9yK/A0tw7wtKPve1rm2u7wNGIxDK8RlfxkuCW4bYBiJj1jWKFKQxBlmwT981ptmth3HEnrDm32EhC7q0CAedyUp3v/2mvPqAHqmh5P+gVzLu8G4kK8IF5uPFNbRJwieyMYUK/E6iCCu8oDam0rmzuRyy6oKaTlT5Ly6XHpu5rCeTUmJUGRor0PBwYXuf+FYcFc0T3J+v9aTrB4hkjVwgVnQmPAZIBpOuBuUm6tvALtC+Or/6/zPxZmrhORkcm3WnWs51VdH5KXlECEmuYmyI3dT8czZqvJ5Sa6xY3BiU6mIyt7JDxbLYXyilYPnOCVbivW6i+reSCj35rH0YLEG4UDrhkikbP+3neeWHGtU8UVQP5eA5ycmQz0dldyj/g/pkRzX9Hxxh8TbYleKwk4jSooIuhXw4K9RiicfeMmgqI9SSw+FXm5bdg2UVJJ8x4d3EZiQu20OkeVT94dw3lSR0iSLPbJ7lxM0jWSPKIOWDOb9UNpnc/QyZ2aPtbVtiFfZ4LdxibZnpOkPCwchi9jMXrJ/LfQGUBplScN0xw1C3MZzoYgiQ8NkttzHMAMxdO82FsBgYK/5T+2zTwCkPF8XSHu7twaBU9YMnZQufWPn47TUCulkNcuRPIavpeG97Wd4xp5OLi2SbmJx14Jz52jdJiOG+EY7L9S5XKEPw0NPsWLsnyEYWSFKXIyowoTm66ydfErYn3JY2lajcG+ywat3FdKA0Z10TygdMD8OOjGPF8kINJluOHUHSdjaB91Ay6Wpj+KiC4ave4TSpRUJFSnZU47Wg+/n7le1SoA
 +njHxLbd
 6OvrZBLBPGoK3+fUgyklCvevZlyJIxZq/Isr6MxKsvh0Cvl8u1KLJ66CZw5/zx9w6CHXJBQwSFr0b1JKJWCGxeRUVhmENs+NHMkasvK5wz5VPV7Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.08.25 08:33, Wei Yang wrote:
> Commit 8ee53820edfd ("thp: mmu_notifier_test_young") introduced
> mmu_notifier_test_young(), but we should pass the address need to test.

... "but we are passing the wrong address".

> In xxx_scan_pmd(), the actual iteration address is "_address" not
> "address". We seem to misuse the variable on the very beginning.
> 
> Change it to the right one.
> 
> Fixes: 8ee53820edfd ("thp: mmu_notifier_test_young")
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> CC: <stable@vger.kernel.org>
> 
> ---
> The original commit 8ee53820edfd is at 2011.
> Then the code is moved to khugepaged.c in commit b46e756f5e470 ("thp:
> extract khugepaged from mm/huge_memory.c") in 2022.
> ---
>   mm/khugepaged.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 24e18a7f8a93..b000942250d1 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1418,7 +1418,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>   		if (cc->is_khugepaged &&
>   		    (pte_young(pteval) || folio_test_young(folio) ||
>   		     folio_test_referenced(folio) || mmu_notifier_test_young(vma->vm_mm,
> -								     address)))
> +								     _address)))

Please just put that into a single line, that's a perfectly reasonable 
case to exceed 80 chars.


Acked-by: David Hildenbrand <david@redhat.com>

>   			referenced++;
>   	}
>   	if (!writable) {

Maybe, just maybe, it's because of *horrible* variable naming.

Can someone please send a cleanup to rename address -> pmd_addr and
_address -> pte_addr or sth like that?

pretty much any naming is better than this.

-- 
Cheers

David / dhildenb


