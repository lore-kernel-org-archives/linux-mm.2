Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE5D2C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 12:42:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74E316B009F; Wed,  6 Aug 2025 08:42:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7252F6B00A0; Wed,  6 Aug 2025 08:42:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 614A76B00A1; Wed,  6 Aug 2025 08:42:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 50DB56B009F
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:42:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2FD6BB9C17
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:42:26 +0000 (UTC)
X-FDA: 83746295892.02.BBC6956
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id C8222100004
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:42:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Gcnlv58d;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754484143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6fC+wuZRrS98vNZxfDF8dB7BkGXm5HyL/fUXW2U/KHQ=;
	b=hsn9/tAQJefqbXS01r4NKR+RNsb3vf4CnC4rtxhg+9J6kMEkyPS5JmOG/FFt5+mHnafZpl
	YdcdSzQRVfw29MzgfyybaDtTAeO5IHXoeeQxiNmRa06dDXOHBQfDyopwkj6IAGvNTZqNH6
	hc51MUIz5mSW7+lvYdit/nHE3JJD6yA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Gcnlv58d;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754484143; a=rsa-sha256;
	cv=none;
	b=0IrDaFf8YJrxbsGpae6YWM3F+yvVgcwBmp6Z13MdwPphE8dSrTjjncYUZkCGLaSiSG+a3U
	7xHU0a2PtJB1TkBPJBjVgOP8faf3k9B2OhYsXtCXeAzlcwnOy9t6TDTYrl1+AtTcUi/VW3
	/Iy3QMbkun+lO/8p5Cjkx1bqQeBcawo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754484143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6fC+wuZRrS98vNZxfDF8dB7BkGXm5HyL/fUXW2U/KHQ=;
	b=Gcnlv58dhcJzOh5i/SSG6XO4rJynuAKhiPhv+aRiv2RgOAa2xULiNR9sqzRFCb1zRqxVAq
	soGZfp/h+VwMhynHrU1YBuQWj6Fkm1epo6XOGKeUkbqVt4QTU2P1aJ2Qf5eMHERhJN6ARE
	DQx+wpPgmtELoh7bksdLB7hXjtZL0UM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-pqff5GxmPliNe4BpRtlIYQ-1; Wed, 06 Aug 2025 08:42:21 -0400
X-MC-Unique: pqff5GxmPliNe4BpRtlIYQ-1
X-Mimecast-MFC-AGG-ID: pqff5GxmPliNe4BpRtlIYQ_1754484141
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b7812e887aso2035210f8f.2
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 05:42:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754484140; x=1755088940;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6fC+wuZRrS98vNZxfDF8dB7BkGXm5HyL/fUXW2U/KHQ=;
        b=EC5aIykHkGvb+4HBKl5CrWU1oeQ3QvIdyrpHiZE8ayLygiwVnX/k9ls2sFUqDpGI2F
         GCrUo9jeEFXZukMCNyZnsEAbjdvm9fc4KCyDrEKq6CGwP6lTz61iXiId3qI83dSt24hF
         7OviHmEyhnL1SMM2Se72kjwXDJ0eyph9dVSsJEhx2AUe0UHrjpdrIjH9zEBnXjbrFIuU
         f3rD2FpLY8009GqV2emC6QrgJLf69BElxHd68E8n4EIXbd/DuyL01xigRL3pAgGgJoWl
         3Jn+Mooh1+8V0Fa9xlHnNwZBoMxGNKUeYXybNIuJ7yuDZtRpqul7I8AgNfvDNvi9oxm+
         qa4w==
X-Forwarded-Encrypted: i=1; AJvYcCVn2EtTMhs79qXqcrq9//NJ+yf1QY9on4F3M+qxstmLmAx9oE5Q/Qshgi90+6VO1jBDJlNri+N7xg==@kvack.org
X-Gm-Message-State: AOJu0YyqH3m8/fDG88fDNaTOMIP/bQTbSXTqnwBVuj6zKiRDDKd2fa1t
	eLuv5XvBotJtOiPiuWBjy3VuiISrhNL5GFugfWDdi07e6kU0n4XkO68+Td3aL0hI+dv9JcDsgfV
	t/RRZvKs6UKmaiJEbn1VCqKkUBWvJgZ3TwNDEBhqgUGepZhcWNpus
X-Gm-Gg: ASbGncv0wuvk3FzOzo9ZHPYq+YgKuluNN5m2wRStq2v+Y2Fl+GSS5enT/Dw+mJsQ6pb
	gs513GFjsThOleqXqii7NNE7j9HUjiu634t+09Kjd7/eJ1fBaVBVPz89gLnbQ3dkEFjNIz0+UH0
	/jwQ+Qe16MbbK8SwiS0zI9kT53NOsBSWry0NA5Wz6bzFzjiv5YpwEV/ejr0IAsoFp7bOWLXeGRj
	QS2P2rKVq4URC4hE0rPVIAnU8qZhpZOG+b64bOdRXxe0DRPI3Edx9fw2xhA7TkL6XRPKgvtqOwS
	LQF09rWrj+b57k4JxI0X6+FhcE4Pyg3gP2TEg9zgc/X5DTl3/ZXeJE6dFm+us2UvLvvqqqV4Mt7
	d7YiVxeyyiQ87oiqQ4hSXaGWEY2eUHIUBqvVzLmJS/iuQ0WmazgxtZQcxhiuQrZQFKWM=
X-Received: by 2002:a5d:5846:0:b0:3b7:930a:bb0d with SMTP id ffacd0b85a97d-3b8f48e929bmr1886364f8f.20.1754484140581;
        Wed, 06 Aug 2025 05:42:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEgk4+ikHQX6105e2puO+JLj1QNXAy0kwvoA7WxfsLLJbZOR8ZghoT2xETRXpsUtY54KVrOYA==
X-Received: by 2002:a5d:5846:0:b0:3b7:930a:bb0d with SMTP id ffacd0b85a97d-3b8f48e929bmr1886329f8f.20.1754484140086;
        Wed, 06 Aug 2025 05:42:20 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f35:8a00:42f7:2657:34cc:a51f? (p200300d82f358a0042f7265734cca51f.dip0.t-ipconnect.de. [2003:d8:2f35:8a00:42f7:2657:34cc:a51f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c453d6esm22995355f8f.37.2025.08.06.05.42.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 05:42:19 -0700 (PDT)
Message-ID: <6a39f79a-d709-43ba-ab28-2b86f2e4c547@redhat.com>
Date: Wed, 6 Aug 2025 14:42:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm/huge_memory: add new_order and offset to
 split_huge_pages*() pr_debug.
To: Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20250806022045.342824-1-ziy@nvidia.com>
 <20250806022045.342824-2-ziy@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250806022045.342824-2-ziy@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0TTkIHT6Mu72fOS1YyfF5-Hy98qwly_MYi9Ei7TiNz8_1754484141
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C8222100004
X-Rspamd-Server: rspam06
X-Stat-Signature: w7k3qaccpiwjutdb9gsnkiyentzjqai4
X-HE-Tag: 1754484143-82904
X-HE-Meta: U2FsdGVkX1+Of+incGqivfDXq6y+PVoRmCwcll9BJ9Kv3hhQaT/LngF0mMTCjMP4l1BKCKl0D4ufBFONWSkZHT0K6DVW3Z33isQSoAGQBv0hn9nFTz2t1GoEOHoa9atDz0HEWQIH4DC4zHl70MnkrocrD/b241xKpDbUlO3MkWeM91ScU/I77kbWlk+5SApwfKr76zMl1bL+az32bl5iCERrLJK/K1FMGo82ha/14RHxacArNYyKbEKBDsBRIXTjaK+P8zk0hKhaNGwNn4IRHSxpFCl8w81pOpMfWzksqK21/f04n72zIH903+3AMnl18kIUAu7YmZX/ZrF6ELWfJAq8UJPOHggH9/pBCFYrHbf7bw4033ZDyro7Y+0Ewclf2U93zfMav7rks9dEmiu+E7Cm4eLLEXIx0CVps9bb6vfvnPA+q8DN3C7WZTauMDEo7z8+4Q9jGLfgEpnv7xu9XTgv36XKXTfH4KXR7v/ud79zoiF8T/rNdCU1StewTH6nv8uDap4eObXtblFFBASYvtDz2S6wfWSHg+BRAY+54O1KjLk1PVJq7jmN21+1gD8qi4rfA1qLmy1qKsPe+Fw7/kol0F3jcKmQdMVKfKL1cx9HJhLoURpzCRhtplwmuGKK0kEU9pz+u63KDJICJaz2zL8s90LGiykHfJbyDvxlXS9EOv2ENPHjniiqOyuQAjYuz868OYXTmZ2Ki7afYudZgxrffssiKX9lJY+m8GOxnAg0Ka0XGXv+ARP2FjlGhAz+D8tV4cMA485ufwsgMvD3GWO9crA9qHSPJmGLSGQ094ku94TTPv2CLX8l4hfEWKeXtIKHM20BT5iUFk7P5tFHZIC++B13KdpAzd5fCfPTar1s3lslA9895nv1xuJYDBiLVG59/eXzwqHvBVda3RbQV1yHyVPKWqKd6nyb41a1XT9GKVHPFvJ6ru2L/HWw27czCGDTJ0uDogMg1XfYJBu
 MxbzSMV/
 1X1PMMRy73/eK0C2TjjEPry/gAfGEHWkxbA1/Y89rhyMdSaZVx24aPlyf24W6rZ8pHfkOQeRgxp0aKq0UD8+Ztmmg2DmT4sn5pPWGAx6+4GGyW48s2O/NsQrAFa8D91Ays6upE0TwwuwI9UO+0Qd7pAf86aRFvynN1sPfVgxXBb8a6HdYCqA52qLN7syqjVF8eRaO1wKPys7lFgKWob6NNeZ6ZOL+A22p7bq4bqKOarZ7hQAv16fI2y5ZG+MpPkwcBQekER/ug43VhSzVTmmJ3Yh72+04k59TIp29qjrnJPzKEWHXestLlPxHJAyx0zSmdezQ189aiPxFUq3vUqwelnKS6i6vzM7UUSkAiMUJ/CA8jK27MaVxmXDQgQFVzMIWKz1DWqbTIX+rQoDUGMFUuZ1W6sOUa88l+BY0VJj9veebOnJwZW6r564evQhHuMbSSjPoog3SBbTcFjsQWCckmJMKi+Fn/qAhiMwpySAuNLQj9Sg6Gal1ez8DH5tdbAOKtgnsrULykNlguw/uFWLNIzo/EGXPP1u3OxiJLksdjfVVWRM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.08.25 04:20, Zi Yan wrote:
> They are useful information for debugging split huge page tests.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


