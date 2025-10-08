Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CA5CCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 09:02:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 919108E000E; Wed,  8 Oct 2025 05:02:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C1978E0002; Wed,  8 Oct 2025 05:02:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7896B8E000E; Wed,  8 Oct 2025 05:02:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 63DEE8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 05:02:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F33A111A2BC
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 09:02:42 +0000 (UTC)
X-FDA: 83974356564.05.003135F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8585440002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 09:02:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KrSNAshS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759914160; a=rsa-sha256;
	cv=none;
	b=NxQPe3j54ZD4MJLElkwvwGQ5ruMTgM8XO5CCrXyoaFXcUNWNWpJUiIfW+9Tm3KIcYJZs7a
	uz8qlRF1PfR7l0QN3dCss+H+yrZ1bIH4l8hg00YZ7nSwIZqtHz7O8NCH6HlzCzqyP0xChq
	28KeW4/zO5DAQi1f2MV8yx2/IIUm1Ss=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KrSNAshS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759914160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=46R1sN9igUgUTPSQIseFwe6Ew94wbjQckrXFCJzXdDs=;
	b=kNWjgVLcDiuL8TexGR8teFRef3SOFsQNNwOiTSy/wof2Sgh1Uj5PnhTrh5soMYRL6rsDse
	42Jnbl/00KyaevOdOOW51XLp+WlyQrb/REVYVhK39ZbUXPlH2EoHjEcoMJwSR7LNFTWv4I
	IcgzyomYnBkfl6ziehazx6hcVJmJaJc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759914159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=46R1sN9igUgUTPSQIseFwe6Ew94wbjQckrXFCJzXdDs=;
	b=KrSNAshSd0CKYcqjORzqx4jRcMuS59p3lVIbZvqvpstsLZeucC+HfsFXrAgtPaXm8Rh/Sn
	vHK8hTh+W9ZC+ZvsN1OUV6Y2nkKX7Mf5cpw12dagnCcQ3KPdUxl/omhvuZLcDYrTcjLmCc
	kw9CoZChqkokpF3fOf4GVdunyFGTz0o=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-108-36c-y7pxPYueilwKPg5Lsw-1; Wed, 08 Oct 2025 05:02:38 -0400
X-MC-Unique: 36c-y7pxPYueilwKPg5Lsw-1
X-Mimecast-MFC-AGG-ID: 36c-y7pxPYueilwKPg5Lsw_1759914157
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-426c4d733c4so132554f8f.3
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 02:02:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759914157; x=1760518957;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=46R1sN9igUgUTPSQIseFwe6Ew94wbjQckrXFCJzXdDs=;
        b=TAhcHJVft/ZO09arosxXEYDnARazVVbq/8WUMMgaEIkyEBq17D8QSudzILSOuJaGWZ
         O84oSJ7a+6jg8yfes5TTWbLcxjTlnYFQt2aq6e7+pYQVpFHSXc3HAF7lm2Sh/LnGfC38
         tSt4yBynh4ETMFkp1AN1nTKufCVbcjxx5rQZlNxwzI5fIIwYSM73S0/1bH6LsRyInvoL
         eT/Prm4LgrjV721MiksCdzcugk7o4SnQKIFoH2Lz9kE1AUgFjEJtAKTkRCY0gLrg4+3K
         WcGBMOG7gdPv4Uvw9gXB+WqK3+JGhhlYkmVTS/HRPua4mY+Wnm564L/e+ClvvT19gWGg
         k1Zw==
X-Gm-Message-State: AOJu0Yys8Mg1lwCYJ6cWSfpLFMxW3bPcVs9NZ3uneNs+ZE6TNepSMnUt
	PpSS/Img624lcWCOduYGmvgHjnG5jlvm1km1c+UHyqWLA52xDYjqWgw6LaD2sueLRfoz30Xtwre
	Me3Ojc4lOKNZzlOvp8Xzoy8IeBzYLyqhdHrT1tXl2JU6B7ur7p8Xe
X-Gm-Gg: ASbGncumls8HDbNtw4aUZ6JOM5s/XnxnWGASD2V8ban+Q7MYP/+fA2tqlUERqMgEzgL
	tI29wBAa2NHrPGJg1vu5Fgtu0JO0VlR252rETMT0shMQsX7Afl2AWAPo548zg0ke0ieUw1EEisZ
	sJT44EmlHuFJhw6PXdrshnjh6cJfjMSRk2tZsDxQT4XiGIVDQgYu2J3gFyZSRD/bKLjUK7oOrxG
	JcgrIUI1R/FLbgFdZTsEYOfj0I2pIw6a/zzEAiJ9MTm696jHUEmYZ/N3NKQgqQ8037+HEctCEPF
	hRCNZW1o1u4Cap+wybcfL2STHqmlI/J40hc583lockWXlz58S4ef9IJy/QqjD364/DmmVrcXUWl
	FhWoqmvUt
X-Received: by 2002:a05:6000:607:b0:3ee:15b4:174c with SMTP id ffacd0b85a97d-42666ac2cbcmr1573568f8f.3.1759914157271;
        Wed, 08 Oct 2025 02:02:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHQrhrRDYxj/7YEx0y++lris7ibeBPqVXd2rLjuE7tAoZ6C3HRHe/JUbaoHFYJ1fdK5oQlE5w==
X-Received: by 2002:a05:6000:607:b0:3ee:15b4:174c with SMTP id ffacd0b85a97d-42666ac2cbcmr1573547f8f.3.1759914156861;
        Wed, 08 Oct 2025 02:02:36 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8e9724sm28761707f8f.28.2025.10.08.02.02.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Oct 2025 02:02:36 -0700 (PDT)
Message-ID: <df3566e4-82dd-4e1f-b043-e9de4879b5a0@redhat.com>
Date: Wed, 8 Oct 2025 11:02:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: allow overcommitting gigantic hugepages
To: Usama Arif <usamaarif642@gmail.com>, muchun.song@linux.dev,
 osalvador@suse.de, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, hannes@cmpxchg.org, riel@surriel.com, kas@kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20251006185607.3257340-1-usamaarif642@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251006185607.3257340-1-usamaarif642@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8oYPw0DuLpyfZbCTWIcIU9e7Hfd2uS4La3aex0nfZNE_1759914157
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: arrkwqppsoxa4jr8e5tkge3uof8y16oq
X-Rspamd-Queue-Id: 8585440002
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759914160-585491
X-HE-Meta: U2FsdGVkX1+wHyW5DIAkMQAsivScuCD6sc3hfIDy6xmRsspkThPYu42LJ2kU1IEvKoKxvhXXLI+C3uoBBD4GQE3ZpsGw2AMS2bZf1o0t1sCyCFL0Q0m/vrYWyetckJAGaBWldND5MzdMahFA2BVU7VzTePTf0ZHvKNCkNZyzI9//ZG+ovLxg7D9+R0sRJSJRtT/lZCfwUZCu+9nBajLTezY10rawB0fe36W7z4ENOT5K2mgmEjQyyI6rUa1nr8GaTSbPg/XFdsLdxBvue15yU5fG0d9QKWMhuDTwaEXlRNKxtmb2A+vWb9NlZ0ynPx7oZCInlGexzZaYCf/iOa/V9LaLLp10VyE8iUDslnLjGn/TZcCyvZj9NvWM0eDabfWEaBd6jKcMkskxS8sH0BYQ01O9p0UmXZyeEHha5UN9ZOvpYt2L4mFFEDOKdaoOA/uWWKPkUkokV0+P166iEN3wrW9lvQFycOYOW/uXKIaCN8KLrsNVlTtL39H+qxBotq4m34Enu2zsaDBHbHN1iUVCMRq1ErYsw87ydXdZCxgE2NypOiafEIWNmXBsTZvHFvEB4xN38K5Oy3So2FF51Y+8SZJE+3vz5RGduigzvrqOHA8cqHZpH5/ypnbBKK379OLZM1t26zXj94Ui2ryLVjY+1FISllwBBglf7I4b4WmF/rEQmp+KQPeSACLsFyEzTsR67XADd3rwZHCiq8scEtxHfoCjd5sMfS3EHDYGIkw9TuWmQZqYbecfeW3fWas28IP1VwPyq+kaaUh8+lPhgfTxlQf11tZSw8IrDCOQEyqS6+XO4YJSW2Tpv6mzIOh+d1MMINNBJu5gNqiGNZyO63LCsY6rwW8JOTAKN+ONFbhOp0AELOoqlm18ysUAc23uvDIaqccmcp1metEZpz1Krino1HcBGQAVARBLyuChenlHA0GyaJZhGqoDM++Cwl/ERSs626b4YBltZ6pv+1FOQJh
 9bPGRGaw
 ML0P47DToJnB7CEkOTqAOvOAdKL5fihPAXaYs1lvNIDQXklBVtZnLk6DF3gHdFFrFpfJrOY+DmQr6uxB8tQtHt4A8VLQuXrMJe//FQeFgg4ltiQVsV+qkZoWZh0k5hX69lq4R0Y0sWA4POUDMDFAb1g94nxWLrvgK0KdZSNh9iKgPo6LOHYzvvqPfiEVL7dYor+eeHuLM2h8kjG45xWdNSd+n64foEFKlCzHeXRjSuutmaDli44bT4ojUq6xx0Hap9xAQfcKMBXK4c+Dyb7TsJ5nLK8dimabsd0gzFn9z7JyfTMZhRUDzTp27wvehpYG32GSTEO6NO7Tm+3OOQDDGM6EBdyYoBlCcjgtr282FS6j/kkwuH49R7tm1ttMAd8Xl0TWB/IRwMsE1YketR1CgfLUkA5f8bcuEvvYv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.10.25 20:56, Usama Arif wrote:
> Currently, gigantic hugepages cannot use the overcommit mechanism
> (nr_overcommit_hugepages), forcing users to permanently reserve memory via
> nr_hugepages even when pages might not be actively used.
> 
> Remove this blanket restriction on gigantic hugepage overcommit.
> This will bring the same benefits to gigantic pages as hugepages:
> 
> - Memory is only taken out of regular use when actually needed
> - Unused surplus pages can be returned to the system
> - Better memory utilization, especially with CMA backing which can
>    significantly increase the changes of hugepage allocation
> 
> Without this patch:
> echo 3 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_overcommit_hugepages
> bash: echo: write error: Invalid argument
> 
> With this patch:
> echo 3 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_overcommit_hugepages
> ./mmap_hugetlb_test
> Successfully allocated huge pages at address: 0x7f9d40000000
> 
> cat mmap_hugetlb_test.c
> ...
>      unsigned long ALLOC_SIZE = 3 * (unsigned long) HUGE_PAGE_SIZE;
>      addr = mmap(NULL,
>                  ALLOC_SIZE, // 3GB
>                  PROT_READ | PROT_WRITE,
>                  MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB | MAP_HUGE_1GB,
>                  -1,
>                  0);
> 
>      if (addr == MAP_FAILED) {
>          fprintf(stderr, "mmap failed: %s\n", strerror(errno));
>          return 1;
>      }
>      printf("Successfully allocated huge pages at address: %p\n", addr);
> ...
> 
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> ---

No opinion from my side. I guess it won't harm anybody (but people 
should be aware that "overcommit" with huge pages where we have no 
allocation guarantees is a flawed concept).

-- 
Cheers

David / dhildenb


