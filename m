Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 998ECCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 06:47:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 054408E000D; Wed, 10 Sep 2025 02:47:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02B7C8E000C; Wed, 10 Sep 2025 02:47:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E83B08E000D; Wed, 10 Sep 2025 02:47:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D939A8E000C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:47:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A3036140783
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 06:47:24 +0000 (UTC)
X-FDA: 83872409208.15.5B999BA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 42ABB140006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 06:47:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Y/gg6LOd";
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757486842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DclbICh4vt4htwsTue4DjShXgYZNbK2BpNkYpPd7VQs=;
	b=YalGRmE1jvxLhXiFEG+Rj4SLjO1OvJ8DppIDNjOE4e8HTJ0I4qtGo7drJgYAjJRdeEdV7S
	I6bkSAUS+o4dvFUpDwDMKDR+otIuSxQ0mAGvJUNFRMu0AoGwnWhHeZO+S9bEmpr4+H271q
	7BeOcOa6zixjLA5Lawr/A7dGgvH2gwo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Y/gg6LOd";
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757486842; a=rsa-sha256;
	cv=none;
	b=AbFBEf62Y5cAqQoKFnPHQuBdxttRNCDX8v00R9OXhiTE8lcZZfaUWpFg3w0AGRZsJgS5hr
	VAF5bttONkP4+yfDmCGGpRgQlFsMWWd0DNSf7M3yW2Q7MRnMDorYBCRng034fK6tqfiggX
	N+zvO23YLDUFa5K4MZyCwhAKvPDoFzQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757486841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DclbICh4vt4htwsTue4DjShXgYZNbK2BpNkYpPd7VQs=;
	b=Y/gg6LOdjvb45YIFSC4V01/hhOGrtMTxzoMN2T0WbEfIGLJKdczvs1Rxiuq00WCgXEMasi
	sOMmp/SQOw4+6Avdwdptn+yIZVHYY933+zKE1Rg8BUcA8GpUQdLsqnAw4/SdNLnRszZ5jz
	mLbScrz07GFtwEMOzozJnLk384byHfA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-265-2b506GqONUq4Cz208L4OrA-1; Wed, 10 Sep 2025 02:47:19 -0400
X-MC-Unique: 2b506GqONUq4Cz208L4OrA-1
X-Mimecast-MFC-AGG-ID: 2b506GqONUq4Cz208L4OrA_1757486839
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b990eb77cso1850875e9.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 23:47:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757486839; x=1758091639;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DclbICh4vt4htwsTue4DjShXgYZNbK2BpNkYpPd7VQs=;
        b=lgcWPqwQMXCD7v3k9/0cDd5fyYfKuc4bvd862LFPNMQii+ZzvIuLytficof3flAO5H
         bwNSdKdNKURm89KDx9iM+xrfNakplkTLMbUmvqbl2B5qIPsa963+pvcWIDHKTD0tDkL2
         jz43AJ8y6bamcu3v7rS03Lno+ki6w8HSovD9nuGKx1cvhVyjcvVuWIIP87PCFPxzo8Wk
         qAK7SpsgdpJTppTwHaYecgcWSy26KmPo6rFo9SJDpAYgVQuQlgla1n3M3L4sc+U/jLBn
         v4RPMSecOJrJtUUOZnL6+TBA4PikYZlTZfMTpX5jcnNkyZQWkQ7tOLm0sNARhBl8pnx7
         Jhhg==
X-Forwarded-Encrypted: i=1; AJvYcCUEyc5rj0IGMOLb69eJpF1UA+CNePKNdgCH/NgvwDZqihs4mcldo7uPfY3hCWH+4hdDdxA1qzmPKw==@kvack.org
X-Gm-Message-State: AOJu0YxHJeFvHIcRT7EUB9X7WLlD+JprIUeSAjeo6/MpSKBDKqsV2CrW
	IzRomRKkd2hVMgR5VXB33xA5DRkiU34DiVDKuuSx/hZXG8rtajx/r827JgiLubkPEP4dSygdc11
	6JanAkM8U36eOFHh3jKvLOhdnKnnBrnXRZEsRQxEPnzgUmjrvgnf8
X-Gm-Gg: ASbGncuFQ1o8CaKRvOpZ2wSaPt8qM20aDZk6RbHZnZU4E1D23TvcSm6lMftsjvxDLRo
	XtbwAHDQhr9O5PjStGUglzcUw3z2HvBOd7PJnoUGvfDYERBYxjK4wrm+gPKKYxqNFv+qnsPUuIl
	vpe1k9z5ZlhXWuSrU8Vm+aFC33JSeyLYS4wy14zX+0rJjWKVkQqEmdVKp1cNuxcrGmYxI7PI+FY
	8+XvAJkMw9VSpV5Jix84L9i1y1iwInEI6cOu6RhIOuLLRMihN7ikzM1uGlOdKOZgdgqvvvlX1oE
	K9ClQSzBJZJ4Z6iNF0n25IU8kPr2R0sCJBDWRvMIJnFyQXoqrhYd1lLjC/Gsfcgar64eWXOvVTY
	FlpocATqRXS6U87elRkvbiMAIF181Fo2cgC2LBOtiFBlDuy631Rgav+nink4s6ihkY5g=
X-Received: by 2002:a05:600c:3109:b0:45b:910c:adf with SMTP id 5b1f17b1804b1-45dd5b6870emr170579945e9.12.1757486838757;
        Tue, 09 Sep 2025 23:47:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG83J5OJuXJRUwcDtMhsLLb63Ao7OmC+YBUOiY4RlDnVWFPTK7sefin7s19OlLvWaaiTz7/1A==
X-Received: by 2002:a05:600c:3109:b0:45b:910c:adf with SMTP id 5b1f17b1804b1-45dd5b6870emr170579765e9.12.1757486838384;
        Tue, 09 Sep 2025 23:47:18 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f17:9c00:d650:ab5f:74c2:2175? (p200300d82f179c00d650ab5f74c22175.dip0.t-ipconnect.de. [2003:d8:2f17:9c00:d650:ab5f:74c2:2175])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e75223898csm5855416f8f.39.2025.09.09.23.47.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 23:47:17 -0700 (PDT)
Message-ID: <837a56d1-38ef-453d-9b94-b151765d5b84@redhat.com>
Date: Wed, 10 Sep 2025 08:47:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: remove PROT_EXEC req from file-collapse
 tests
To: Zach O'Keefe <zokeefe@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250909190534.512801-1-zokeefe@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250909190534.512801-1-zokeefe@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: V6AsSKtEImpyrAbugePMu80YjAfIBesiI4uvKwi2atY_1757486839
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 42ABB140006
X-Stat-Signature: krsegsm9kihn839xmizq6errn81p13dw
X-HE-Tag: 1757486842-798142
X-HE-Meta: U2FsdGVkX18KJOgzum3IVdG4y32diKQ+6MSfQ0bAwtGK2cFZkjMB/63o/MiEvSzoHS3qsyXcr42mSmMz8IsG3n3KyVHdzGKWoI8YvwY2qNz5JIXKhHnoiNS/KfAqUTPpPaKeUk0W8GdNHEECyn4DWkPs4oEr31AWmJfCiAJYYBP6eG8yJtDhaUV6QlnW6uDiR6sJYjfXEZw+T3M1fiXNgLmpON2KesXBMQuGMSa81UR+zmpIvJNNxaL3qwMKZ4hkXdUGqFU0aqlZaWrcfsKNccvfimuSw84I2p5T7X7pACbTMw2Xohbvmfia20UvTWIg/2Ir5f48URGT1YAQ9SnfkLw0xmmPhV79p9tUlief9WX0cBRNCe0XBf/hUqpkSHRX3+ZUpKr7S4tgATAiUxn1UZVKyx1kQElPxDobXmRD0GR8U7XExBRfHCIzBNqX3zfFK80KZ6l5wF++HGHg5mRTA75Lw/qB7AOgCBPRKzAZXzTPLenVZR9hYfaWcjddBkSdhVl0BACEk4T7n9l/kebazqea5enzIusPKaxNwuGYyfiRTmjsJQis6q+G7z3iLLBPcqJmXkJ6LFJHsANOU+a2D0iPNUlEJkWdSAe49BcDopkNawMbeaKOAmARl6MHjgjxU3aYa75j3FGvutKYxRN8t8PEd/3ZV5gl13dS177K23PPnaonQZrre4mtm+EWLn0gHuT1FQyX274TnPOyUcebrMMCeOed4Q2Ikpi6ZJi67tzBjipDwl8pOXGU/oUNFBlIPjMw4shbO7QiVtDSvJ1riXOSEXBpFjsM9opDyxfvzY7/YnjvpEQ5j1v0fdshrg/LXgYKZFrHI92UriAhDEiiU1Pb+WdlPThy1JeSmXl016b8mAzUqYgYcPWGha4NDVNj/QyOt+fBgXHEGY5zIUzXTTIpfvUWdXGbyGieXzrytcswuNFYxT/NBfsdypjWZE53GAR0DBe03AgT74sl/Dd
 2ANsJ3JG
 E8WTSUeQrE+EOqmz7+UqqE6+SSi2k6pv5YhkvY1Nj/L6wMW17pPTacO7zSloZl0cSA3LqlSS6gJ+pKlwJk80M2IxTAVXjUQS8YZ6ayK0Tv3nP+BGKfmR6VbjtH/lIp/2GwShBZx681WIakLt/mhIBMYBhm/7JZwoiAZVN5xUecWQk+66MF1emobJ4HTYOTKV7x1Fq2Qixd47gAPufmhiAwqSNFz1pPUWS1im4WrHG0QhJK4OqcgaBAW+FXwcZnPbpDjR5lFIXOHf9xpDExEOdqEmAkBinkMCDFfgCEWzm6sAlNHDI55iQV3J8kjr81AHsZM+gG/F1ctiTPQVTUZdDRp7LdbZEpJ3ExQSGWDMl8pMSmcm0ofpYoqPuQ8EsFbVyInKlNqCAr/PVA3aKz+yoLXBUwuYIY0d4x72/CtOvvEe5ORUKJwpMXq9hdq8qhVUr180yRN3/g6FisPDnV3umxnqXTRO+Qv0oKNm7taM9Jo34V5E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.09.25 21:05, Zach O'Keefe wrote:
> As of v6.8 commit 7fbb5e188248 ("mm: remove VM_EXEC requirement for THP eligibility")
> thp collapse no longer requires file-backed mappings be created with
> PROT_EXEC.
> 
> Remove the overly-strict dependency from thp collapse tests so we test
> the least-strict requirement for success.
> 
> Signed-off-by: Zach O'Keefe <zokeefe@google.com>
> ---
>   tools/testing/selftests/mm/khugepaged.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index a18c50d51141..3fe7ef04ac62 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -394,7 +394,7 @@ static void *file_setup_area(int nr_hpages)
>   		perror("open()");
>   		exit(EXIT_FAILURE);
>   	}
> -	p = mmap(BASE_ADDR, size, PROT_READ | PROT_EXEC,
> +	p = mmap(BASE_ADDR, size, PROT_READ,
>   		 MAP_PRIVATE, finfo.fd, 0);
>   	if (p == MAP_FAILED || p != BASE_ADDR) {
>   		perror("mmap()");

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


