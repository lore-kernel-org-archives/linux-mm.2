Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B50F6CAC58D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 09:24:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EC068E0011; Thu, 11 Sep 2025 05:24:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C3AD8E0001; Thu, 11 Sep 2025 05:24:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF4358E0011; Thu, 11 Sep 2025 05:24:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D713D8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 05:24:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A6D541603A4
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:24:45 +0000 (UTC)
X-FDA: 83876434530.03.8FB6BA1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4D788A0006
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:24:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gv2jRzM6;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757582683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mPk7/S2bDhCXiWGOHhSRKWwJzJG6TH0qkWUBVK/uCX8=;
	b=HdCJnthn+LSDXHvXrne32Bj8FjOLMlnWBUklGCac12r/pCeYJ3Oa+rCeAP0AcW0L+0qE/7
	+IvqAtRs5WkfGPoL1WpC9sdRMK87zqhslL8cid6ucc0YiV37PlWAixhfE2hEpqmDujAcaH
	P6YvN47kvdMm78roqYlKXJKap+7ALsI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gv2jRzM6;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757582683; a=rsa-sha256;
	cv=none;
	b=mg5CVvTzlJ1bPcKcv07SzVVcs8orVBz8R5EvreADs+1peP8E9ei9pcv6BwfFo2HlpdBm70
	K6U6HY5+tO0bGZGNJidI+xJs1fvEACowwIu+ayN4hWqw6bRC9NLmoEQYKMvBcFVvoshkOw
	sdzT7LsbP6fVyhif5Xpqrp9yX3xdOs0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757582682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mPk7/S2bDhCXiWGOHhSRKWwJzJG6TH0qkWUBVK/uCX8=;
	b=gv2jRzM6ATUk3q9QPkQQm/ZwvONPJ6xHXN9N+3hbVrict9vxa/DsdkWpSwwR3yolfBRlff
	yhk6llmj1ziagMnhtVR+8G+BqJAPLms4rnD1omcBsiRXupyR3X2cS0mq/cBwalppDwsReg
	bE1T2g88NW21uPrXvw/7xk6aFljIT/I=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-42-KlB50VVrNpOUcLvnTF055Q-1; Thu, 11 Sep 2025 05:24:41 -0400
X-MC-Unique: KlB50VVrNpOUcLvnTF055Q-1
X-Mimecast-MFC-AGG-ID: KlB50VVrNpOUcLvnTF055Q_1757582680
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3dbf3054ac4so297385f8f.3
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:24:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757582680; x=1758187480;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mPk7/S2bDhCXiWGOHhSRKWwJzJG6TH0qkWUBVK/uCX8=;
        b=YTL7a0r+efWu68Y7KqeAfEUiSZiCl5pnPXUhIc6GHuyXFgvhe/UamdR78dS0CEgvHY
         sIGAWGaABes59GHUZdEOBrVmtt95lKXQKy15BjgmpKBEquyXTtWs3wK1NiwyecrmzeEl
         DNMHJjmcJjrY6nihKoQW/4rhE07yycgDjwQ+p7T2UGXBJLvd0/xQ+ngOgg33Zi8MuJ5k
         HmjF+gId2DxehaM4jZj80ubabxq5NLQeb0YA/GIK9GANKEvpvUNgGaAirGtC2i4SF+jm
         UNoXPMEeSHsZ/W4DQSMKzSyvVBydyhPx+bxyXz+++1+OH31oQkNUsC3z60BjvxfhZB7K
         rjuA==
X-Forwarded-Encrypted: i=1; AJvYcCVkGAdP99xLzR8GHdQdSPMQJl2hm9M9Tv+ayBow5jNWTOL//MgEGTYgKYoSyb2yuTkbAxD7w6jAgg==@kvack.org
X-Gm-Message-State: AOJu0Yxb5OSzKvRaMVnSRenOjRxpJeiZnulUdsoF0M58oScIpTgLT0j4
	CT5R8+AopBUGwICHjbIRV2138RxfivVBaAPb/0tm3JnuSwGECdkiy4coQL4CDT+qrzHAZvSoV+M
	J7/t4j4GMEgsnWlOYldXxIRXY1cWZBiXC/I1O4VgtUmd6+c8FPHv7
X-Gm-Gg: ASbGncs97+W/phdMXD8C+u/LMFtj+XPLs2mbhTp30HvDUSXWPri2y8xPgkx2I7vDn1h
	/7cnKwkxxF5mb/vizpR5ifvikSmcvx+otBsJheVynfU8OyxspKMsLhKy8bxvPWwkgcOosOFXmR1
	/7wATJt5/fkADO15NlAj9F/iXYWNcmXqq6z/ny9gGR0BIHFcQ/l/WRkqSEHCTFZv578C750lKnA
	ADTrapDMxYGzoqQSMSQiETlnO8nvmh0uZPqaajjAGMxB5LfuGbJvpvds09z+CbB25xE0GiSl/bF
	vw8yAybZm3/ZBIdH7jA0VebbQlhGtMlVGBeloKdSzfkwjb48GlfHjZPRWD/TKyzYKxHr4s48ZQz
	fFj1GxoDP5x9rhb8tvhX3G+VXMJQbTp2MBluPvIap7cSkiE66WVUCf6jKHnPTg0rb/B4=
X-Received: by 2002:a5d:64c9:0:b0:3c9:b8b7:ea4e with SMTP id ffacd0b85a97d-3e637370e00mr14669013f8f.19.1757582680163;
        Thu, 11 Sep 2025 02:24:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtiYpUnGkJ/VVNrkyKsw+QSksGppEKMCiyAJAYnJlmmNayclRtWT8dXna7B1i/EoSa143PXA==
X-Received: by 2002:a5d:64c9:0:b0:3c9:b8b7:ea4e with SMTP id ffacd0b85a97d-3e637370e00mr14668996f8f.19.1757582679746;
        Thu, 11 Sep 2025 02:24:39 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f42:b000:db8b:7655:f60f:812b? (p200300d82f42b000db8b7655f60f812b.dip0.t-ipconnect.de. [2003:d8:2f42:b000:db8b:7655:f60f:812b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607e40a5sm1677749f8f.60.2025.09.11.02.24.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 02:24:39 -0700 (PDT)
Message-ID: <11f35ae6-2891-44cd-a670-92ef2151b885@redhat.com>
Date: Thu, 11 Sep 2025 11:24:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 4/9] mm/memory: Add tree limit to free_pgtables()
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 Charan Teja Kalla <quic_charante@quicinc.com>, shikemeng@huaweicloud.com,
 kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org,
 chrisl@kernel.org, Matthew Wilcox <willy@infradead.org>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
 <20250909190945.1030905-5-Liam.Howlett@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250909190945.1030905-5-Liam.Howlett@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 036kPLo3m9ErCMDygJwMSLpFP4sAEBs5mTbz83ereU4_1757582680
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4D788A0006
X-Stat-Signature: wjs1majkcf76n4ay73p6jpm7i8kautpt
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757582683-775673
X-HE-Meta: U2FsdGVkX18biv/QEeH+tuxZrPShBEzENlgo/Uh8cn3osmPn4Kwrv4ncbmDueqF54l7Gb8VrQM5k7JX6gKhU5azITzvE2o7hX2f1r/m0TCk8zgNLzvN+KSqboZwxqgeG9+C/ISW1XTxyIqW7crI3iy8TeQc2ZOXI/GaMjQnKfJWTJ8VDAnw2KPBzUvS33ZLfDz2AW7rGwWp9GVez+4eLvCm8Fyq3JU9leWTYL29d8A0T1p4OPJIdd845rmIQILqnkJFfcsfDclqtDQ+KcapP2XTlD24gNU+6Sb8SpqCAJOaFkSWxx+kxCllAkiQtZLycs/hheL4odmhV7w4cFHfJK13tLYC8iOuaYwOgMv/MD8hDC5eBc66vOmQUdrd4W4RWMophDBawb1J5YzvdsnQxKnyf2Fw7Ifregt33h7s+dUuVJwXodg1mVEcQ3AzlsjEzmaImIHMY0wPD4HChbMMK3hMEt+utYeHORIAmsnknlQ7BgEWM2+Nx1D34BIb50dN2TMbPX01rNo6qkHuaTpgoLrK02dHMXcUfLmvLbgKJ8y1QcTBcVAu0pYIsNEbIsEjWu5IIX7nATgzgsXd6OnfTrUzYVctyDxZ66u3GIADbCQdDGZxfp+B4VsfTN3ljUHMjzbFGJd0CBJmr3oiL+Ee7YSRGoRih7DkjmDRHs6NeoeL2QOzZZtZGQ6+G3hQXmASpESW+COtZ5VoTFrbSi3PNoZxbh4tNI2INCjArOqn0bspb6U54CAezpA69XgnqJT85IglrHCDiAn36FBAb/DmYShx2U9iPz/SJlJP8C+ASlLvT/5jN8UARKIf4bAH3S5YfO9pzqezpcEoBj/q7fUmHtHOINgMQ3TLl0v4OacP1+t5RpFYNiiErO5T1LzK/3vwZLcDmtDibhlWxqsWwIMycvxMaiYXFos5KwR2uE4srpIj0k3khWfeuYnZPDjdZytlNQmMs9MGsjPqDuj6vksx
 LX+a2irn
 0OSeSpCoaohqaxXnaOtlr0UOwT0mbNIE6NcH9eeXfSCHW1DP2RuYB81gCSVVe7Npf/GsOPgQr2rnVJMwvaCf3oeoQYOWHuhD0N14AkAbYWePldsJdgb1P9cWvQGR0+BQDCdHpkH8TQa/8/o8fE+USjFrn8CBSx+WOEt6Cux8LQtjnP7JCfIhM+rJRV0TxJUk9jRfTPqmhjNCfTjG7vmYE4AZGST8Ea/cC8FdAyf5Pj9osrSfwdrXIwCxutbo1jDgH0bSWPJcGn7vTpxn7o3OQU9FlytvuphjCs+qWsnh5wfKqy3NpE7dVJVuG9SFV1VziHg5gKamu8REF46GbsxA0Rj1tR7S68J92m/Hv+Ntpjv+A7ckueVxH6g/WE/UaSAYNf0toGMAyBJQpd7m6nP3alPriB1XpTXzhTpyB7C/2ibBlKqQg3ce7RwgnlBjyO2DkkJ96E/VheyjjIOGzJ++m7Y+jpL5o19Vr+S2PSNr1fNfrLxnHgkzqNkSF9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +/*
> + * free_pgtables() - Free a range of page tables
> + * @tlb: The mmu gather
> + * @mas: The maple state
> + * @vma: The first vma
> + * @floor: The lowest page table address
> + * @ceiling: The highest page table address
> + * @tree_max: The highest tree search address
> + * @mm_wr_locked: boolean indicating if the mm is write locked

I'm sure there is a good reason why we don't call this stuff here

floor -> start
ceiling -> end
tree_max -> tree_end


-- 
Cheers

David / dhildenb


