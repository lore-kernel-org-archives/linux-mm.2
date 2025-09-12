Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9452ACA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 08:58:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D08228E0011; Fri, 12 Sep 2025 04:58:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE7608E0001; Fri, 12 Sep 2025 04:58:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF6108E0011; Fri, 12 Sep 2025 04:58:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD95E8E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 04:58:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 567DE140721
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:58:17 +0000 (UTC)
X-FDA: 83879996634.03.DDD1CA7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0BBAAA000F
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:58:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iNzVHtSV;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757667495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hn7Kr/nh5f2HYa1BLbnhmtwigv0AyRCmg2Cfmamfb7o=;
	b=NJ0cCqMcJCE/1Y+dZWpcrnSkVrHQtZ69VG3du8LTm1H0yhAaT7ZCWT743I2975g0atF3Ty
	09FmSgNzHnU9ZM+GMhHcVs4cNkAzjlrDYo1EZg6qbLWTf3o3sQi0SjCgLww4D2NRaElG+G
	+0bHnfxVQozfw6DpNg7WCtdGJXjyCzw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iNzVHtSV;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757667495; a=rsa-sha256;
	cv=none;
	b=ryp7NNYT7Mmw7umBTOO+tFRX7POIR9Uv2c62dhhJ24EdPr71MxwYsScRs2Vi7DeNtPqrRH
	n9qpfWDVA7dzDD5gJDaVT2n+B/GUxFtQvFzzUwcSgLgIc/GtrbLnkxm8HCHPvJTu3FVhrk
	rYfpp18dbh+uo75Pp+68QTrpfiQBtGM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757667494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Hn7Kr/nh5f2HYa1BLbnhmtwigv0AyRCmg2Cfmamfb7o=;
	b=iNzVHtSVSFiCLIYRuRgytL68TF3KCnMRVrKUfbtVydBU+dZFKbAylAMGJ9BAmW5Fh4RfgB
	33jA18kJIdLCi15EZRuhcQ1aV1/xRbW9fB9SpFs601UWavO8xED/HDw4lgFCEEfeDhyPqV
	d7glTVZse8+sspgKdrRTfrKo6Cl72HI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-437-YGRkzUiiNXCz7ujNMd0hNw-1; Fri, 12 Sep 2025 04:58:13 -0400
X-MC-Unique: YGRkzUiiNXCz7ujNMd0hNw-1
X-Mimecast-MFC-AGG-ID: YGRkzUiiNXCz7ujNMd0hNw_1757667492
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45df609b181so12787745e9.2
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:58:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757667492; x=1758272292;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hn7Kr/nh5f2HYa1BLbnhmtwigv0AyRCmg2Cfmamfb7o=;
        b=pYcWrlroC5CBu/aCvCm0pUIeVUEN4lCZIZPJ3UnK62ydacZRBUPaUC0rz4DLW7hWA8
         XAOnJqSPO140Dqp9OPLZyvWJvct0TRkGI4TUfqS5V9kl2KozpeHpMwPPSPk6dHC/ckPV
         IFAsIyrcVhMUOCik6RSYQPNL1j7nzSVaCH7dKDqA9smVF535zkHmChHqy2rlb7zxKh+i
         xU07H4RqCP+05SAr0EJ+opaRcppYEclVvVDOhs1LLIX8z6jayzbSZ88pKLUmXISDkXC+
         AbXOq5hSD4E5IX+S5AAaZkqYaUUsYq1SXDfbHyW2u0GV8QREEpBymYE0wR2MVAU+mfyu
         CGfA==
X-Forwarded-Encrypted: i=1; AJvYcCXEcaDfBIHrfJrGa+o3H74qKkhMZm/tf92SMOiy0yObolPluUNGJ+X8NCSYHdp9Pl8niZ89V38CRw==@kvack.org
X-Gm-Message-State: AOJu0YwEqyAIkdpPB8pjS1FoGNLVWzcbiw3mqDGui+R4CU93s2y4hvh4
	Ja2PlHVLkuKhIF1xWO+lOLZf9F3uDSP54wrlwCy2DfVjqedBVVLb1l4YvOCiWHCDWWG0JQ9/Plq
	adG19Cy9O8h8aFQFLQ8YFKzI2rIIn4qGGqPdjObxW2d+SL5T0JAy52uCEwHhd
X-Gm-Gg: ASbGncuOZvFHohrqk98HNpVuN8sE1AFTBI93mbbHFUlWDJSwJcSOKlQeYpYIFK41kg6
	hbiBxey/pRnxLXkOu5pr6sK25xmX9fx1GwloaNEV8PC24xhAVEOOWqUz3Cd0iWUP9JshnmydqJd
	J/2Ua4k6ECDHXf4BhwCIh4rZa7E+za+zoLyEI6KiIvOhXtoxMmj0Cclphkng3mpsKOhD1bQVTWN
	L9An5SwQX9eueqJp1F4SU1ZmTAPc0AqygjGM5RvOJ/gvoUcJFlx5KTCcIMRHtIJn8pLSF0rCs3O
	wJs5J9CVBFw5WUkBHsVRlQowKavOJNLi6f8rHJA+MhLN7G8YkKZYkKrlQnrVYr68ZVev38tg53v
	+ES9L4f3gIzDyUeDWntXDRl7p0LIkC55CS94sc/uiWLLDOYCI+WgfE+Mr/A/SrXv5ves=
X-Received: by 2002:a05:600c:3106:b0:45b:8543:c8c9 with SMTP id 5b1f17b1804b1-45f215641e8mr17030395e9.34.1757667491789;
        Fri, 12 Sep 2025 01:58:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGT7asuRlOngUhq+KN7NZHT4WPoEbSxl+ImwcRL2D9SEROwR0FuVSp7gxH9NpE4kTPnmjOTjQ==
X-Received: by 2002:a05:600c:3106:b0:45b:8543:c8c9 with SMTP id 5b1f17b1804b1-45f215641e8mr17030215e9.34.1757667491411;
        Fri, 12 Sep 2025 01:58:11 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e016b5cbcsm57770435e9.11.2025.09.12.01.58.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 01:58:10 -0700 (PDT)
Message-ID: <86672d4e-b04f-4fc8-b7e8-a7461bdb934f@redhat.com>
Date: Fri, 12 Sep 2025 10:58:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm: vmscan: simplify the folio refcount check in
 pageout()
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 hannes@cmpxchg.org
Cc: mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 lorenzo.stoakes@oracle.com, hughd@google.com, willy@infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1757648598.git.baolin.wang@linux.alibaba.com>
 <e475c5ddbb94763b12d396122ade8ee3c711a967.1757648598.git.baolin.wang@linux.alibaba.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <e475c5ddbb94763b12d396122ade8ee3c711a967.1757648598.git.baolin.wang@linux.alibaba.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Qg9SgNHvxgYy1pTE_94OPDZAkrPN5PGMDUbd-c-uwEQ_1757667492
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0BBAAA000F
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: h5ix3mqnkar5rxnhniqrhrht6rkwew5h
X-HE-Tag: 1757667494-105961
X-HE-Meta: U2FsdGVkX1/TxTCth9R1WnzIm2Lj4iTX9vVYb/KcNMxTqfxTboxHjt0GRCltJHu4OFVd1xVD5gtdymZufsKyseu16xvAd2GupUaoXCo1wZ/6fRKdhbIgjE3gYX7wX+7Q5fNVjq+5Zuoa50/IJKDci6pr1RQkplbUrKxsGpjYdVDk8akXcHVkRbzX7bZwdsszFIQo8gEcearTJpxPC8xBwewlg/5zx6ljEZ0Axv72hjmG1Wk7mGNBeURv2AU7OLzhrpqbDxftLVCwD1wKds5pTI+lXkL5b5MTTv1ToFEPCHsNuY34jcWrmitmcmqORH7JZPn7EO0IespHsLERyfNF1+mbb99Y/RK+9iZIaHSBK61HVUqOEVPBKIuUbBsIX1lzZAZMlfKoh3zhDnOBwG7s6vIA4i9jlKNZS0kkMih8PHf488+AJlFaKw2b2G/8D7ah07LXESGosQebH4dZOFKwKtwY+V9mj8LhiOMsPE81niW6PzTx7BK+04ai37LRCLqBdI5sge3Vohkfq6SmL0NyrHv/IdtNs9edj0lDektgzPQn4SwjsObgDwRbURg8JZ2/Kgcgmzhuzu+MNcGwmmDpOXfa/jr+hbBtor++CnFyyLw71dyKo7YCprScPsBXk/8bQ5clasi2x63dH4iri6BjqmJIOaXSVkhrC4kKo9Qy0i9neAuC/8Uin9gV1P2OLVq3uNDTKGMQrfbNW2ozGq4rdMHhrvuOy+ElMWwaSn2sOLPnNoeuNPv/PT6kbGPYwioV+yUeKLpQd/R9oxZoTsi42A8HfsxJF7HECVnTNTaaHzV3CObhc1t4Y33zGWgAbiyJ7hDODYQSIkLLFwwIpbjXpqa9nT0t6zmjKX4NLoAbLfLNvRKeTNaQWF5py+64kBcoqo8idGEF5ycYOkNbB+kRltNCUXQYefvXnrG5euWAfpaa93w/4u2cx4oqSdAZTCMzhZLMCGsnxALu/JtX9pp
 NTRPTmex
 mZ1DEedpkNrqHJXN3FDQ+o0Q+Y4FogHERvwrS7jFp4SdZzoyR/zouUyfgrex16EoA+8PSVXkB1lcjM0ZLPwt/yYysxDoPs4ePG6G9gEA+8GoUYFigZAB9/vsEUpNaexKdGlmv1C+g0qEDyqlltob+u6Lsautkl6Bus387O8mAUwi9562++idzQURcTNswYyRT/thos/VMYPxfn3hS4mU+Dgj/8FnfSBrkQsiL7bqQSxR1NSZEsZdrQzAbaWZdIc64rkaE0CVWFhnlrK4yQJh15Rr+BKWTtyaBvU4owyHf+hye/lu7c9bXvPLfTkGSKMaZzFNXO9ADR0v3gDMJcvu0doLW0LfWRg/Uhi6sPBN7CbB9QTG4hrhN11jI5RvuWcIupEdc5jfULYac4xX5bqkwp2O3josw/k1Agils0m6cKMg+ATbKKteK0CtdSOoalyisOIDNUcEqC9iJz7b2IjpTNLnYCsC9JpOLIeBPYp2xYnHBYEHDb0cg1WqJIM7XXtAMydelQA5jmpqc1iI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.09.25 05:45, Baolin Wang wrote:
> Since we no longer attempt to write back filesystem folios in pageout(),
> and only tmpfs/shmem folios and anonymous swapcache folios can be written
> back, we can remove the redundant folio_test_private() when checking the
> folio's refcount, as tmpfs/shmem and swapcache folios do not use the
> PG_private flag.
> 
> While we're at it, we can open-code the folio refcount check instead of
> adding a simple helper that has only one user.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---

Nice!

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


