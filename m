Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AF07CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 09:00:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 626418E000C; Wed,  8 Oct 2025 05:00:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FD728E0002; Wed,  8 Oct 2025 05:00:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EC6A8E000C; Wed,  8 Oct 2025 05:00:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F5BE8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 05:00:22 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BB66BB99BE
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 09:00:21 +0000 (UTC)
X-FDA: 83974350642.10.5268128
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3D2EE8000E
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 09:00:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BwWsZbb8;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759914019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bNb165tATUdzEB7JEIVixwqTS/ioT+20Th0ZR/SpPvM=;
	b=Il+SljhGSqk95jXNaPzgX16Id+Xa/VSNA1EDe6u7EBHNsgxjMXCR9AXB8Pey4MxE4sHoyI
	5dLA6jLYkS9q6so1Aj0M9jURoXH/4UD4akHOmyF4souIAD4wUo/gr8tu8GTIV6n8Q02gjs
	WsylI3RgKrYX3M/sh4N5pKgnsiEC8FU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BwWsZbb8;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759914019; a=rsa-sha256;
	cv=none;
	b=IeQumCV0AndpLvsLfGtNIRBoCWFci/5yWvCALa09c2CW2khyxYRijIJw/1hmZFmcbd9SHb
	cahoGPBMA5QcCtEb+kEd+LGMzjtaYsebj6Q81v+EY90XYe5so+WTVG2RhDG3fk4aV69/uQ
	Ziv2QOPteuVwLNUvP1LUXJh5TZQLU3o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759914018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bNb165tATUdzEB7JEIVixwqTS/ioT+20Th0ZR/SpPvM=;
	b=BwWsZbb8AZFk0ZbUAOC+mh3AlcEfGreD3MYi933HAMa5xNpRRw1V02m1K0SpwZcWbmRgcT
	OkiQSzsWlDMlvDYiATzH3fEChDwXYLI15pzzG5enofsYQ77pqkypVEBPfcwUEGBpd9kpam
	f9D/KTIv7jo/4qAZ7sIdTmO+fMKemYY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-olrpcsyfOPm4fwEZMozXRw-1; Wed, 08 Oct 2025 05:00:17 -0400
X-MC-Unique: olrpcsyfOPm4fwEZMozXRw-1
X-Mimecast-MFC-AGG-ID: olrpcsyfOPm4fwEZMozXRw_1759914016
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e39567579so31335895e9.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 02:00:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759914016; x=1760518816;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bNb165tATUdzEB7JEIVixwqTS/ioT+20Th0ZR/SpPvM=;
        b=TPTFsT7jOy0r8xMI8+FIe9bf1zAN5BJ+Q4Y/44bBD7748UmPGkrXV7QI36dWP7aVdl
         Q41JLlwrNrC1SBdIwi1+YzBCCqMDVnXFBrRHDkx9p+jA0S6vAvmxS5cvBDMT4biRJOqO
         9VV6u7MH+uILHu2r/UNlsWUA16WW+ZM8otSe6WUfbEzLah9Z3sHCXZyPMTamPHEWB43m
         RMkMw0cmrcXUPUpCtpucKHz7pBFl6hOY9fd5yplJyoln0x2sLJzIr/vN+ktoVAVPszw3
         ezesn4LhQFk/ET+HFV1z4gnNNh1WLGL7er9PySoGbPNvCTENYumZTXckuZlXpNEhZpYB
         45Zg==
X-Forwarded-Encrypted: i=1; AJvYcCWIsKNAVVu5KIvuv929UsbXIFCNNBt5wivMxaNeU2P9Zlty+IDrHPBeJe5J6yFbuD0DZfHhPLEuLQ==@kvack.org
X-Gm-Message-State: AOJu0YwyVtlXN1kWNeeIfV+2fGPTYXKU/SpBOHGQXVw46uIQd7z/8IxG
	5rMaQ2G0n7zofeH1KeL1Sy/Eupe/iISQqLP9hlWLzu9zvJqEbo0EEyttZ187i58kmbN/Drt9MW9
	WvH+fIg28oFTLTU/ihDvTEpWgUa8OFoOYFIMdAyicnevLaNrboouU
X-Gm-Gg: ASbGncsIBlSvDR9v8vEA0vupQyjg8XsGP8pGkX6G93TqhM+wCHvlfuLvhr47aQE1kEt
	n7raD/NijNTfhCDuXD+x1hI3yP8ZQU5iHHBLTyS4TqKsaF7A2DC1lOexJLHPKX3iTTQqenIuJim
	M5xgor6fg3vbuJjGTiq3E6uKNWOeU4zdOjR2/oJTvQfcH/es/VDFpDHA5aZCImyYbU6lVOHLehF
	LrWZ5c/77BvraB2kCZznzb1uEAlUPoU9ysvwek8Et/Q5upZyMmrnLaVxer4j7bf2hQ6xGxB5Ygb
	0OXXiEANlC9Yifh66XmZNXivy7rCXKxyps3mPG2PhRFCpAPd4924rjbBUp63oiqisT3KukPiYDr
	wkJdOkk8a
X-Received: by 2002:a05:600c:474d:b0:459:d451:3364 with SMTP id 5b1f17b1804b1-46fa9af81d5mr18773325e9.24.1759914015784;
        Wed, 08 Oct 2025 02:00:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHj5sfOcndDzAGeB9+llIRFsdMQVfmW8QZxnb1MAChDDnGTI6DfgD3G8B8EpgzHWOlxYFknRA==
X-Received: by 2002:a05:600c:474d:b0:459:d451:3364 with SMTP id 5b1f17b1804b1-46fa9af81d5mr18773025e9.24.1759914015233;
        Wed, 08 Oct 2025 02:00:15 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fa9bf8295sm28492525e9.3.2025.10.08.02.00.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Oct 2025 02:00:14 -0700 (PDT)
Message-ID: <1c2fae79-69ad-45c2-8da7-31b3cd6dcda0@redhat.com>
Date: Wed, 8 Oct 2025 11:00:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
To: Lance Yang <lance.yang@linux.dev>, Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 dev.jain@arm.com, hughd@google.com, ioworker0@gmail.com,
 kirill@shutemov.name, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mpenttil@redhat.com, npache@redhat.com, ryan.roberts@arm.com, ziy@nvidia.com
References: <20251001032251.85888-1-lance.yang@linux.dev>
 <20251001085425.5iq2mgfom6sqkbbx@master>
 <1d09acbf-ccc9-4f06-9392-669c98e34661@linux.dev>
 <20251005010511.ysek2nqojebqngf3@master>
 <31c3f774-edb7-420a-a6a8-3e21f2abd776@linux.dev>
 <09eaca7b-9988-41c7-8d6e-4802055b3f1e@redhat.com>
 <29742109-13c2-4fa6-a3a1-d12b14641404@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <29742109-13c2-4fa6-a3a1-d12b14641404@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8pIvXA_TkgvXBkudgdopyNmoxlG-umIsZF8wPxur_MA_1759914016
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3D2EE8000E
X-Stat-Signature: 7cmnc4dq7weymfcoirsrs134z9wqxgjx
X-Rspam-User: 
X-HE-Tag: 1759914019-405105
X-HE-Meta: U2FsdGVkX18up9lIQHG3eUaIYEmOCc/y5wGojQ7bNI9UAAyDZlWrvdcrZlLvClaHcJirMDPYpoq1jTPLL/nmhKGkhKtXpMT0ywa/m4Bm5jxpgTZMtUSdV7iUFHr6+ncc3MO35v70DwXk38vkF+dfrOAB++I6eK326riPjgXaptjPtLZ/NnefD7JRqkn2ABre0exUKVWvRvUpQXY95AWM3nHnlNHzfoR+Qdv3s9wPgQ2yzMYtwjZV/ugtVz9RPEAP/+cWTWGUhcPxJof7h+CXLHSLDurlE7HsAwyeivHU0705I98Fysv8ohnG6lHPTX5YHKbUNQUykd7cAnk45iYNpCdS31kZjwylHW1gQz4PCDFCvPD0ZVTwHojjKIfMelaN+nFLQsRpm8GfTFePliujH9h6B3ewnfP+0u6vyMap4juewKb2ggA6ZNTsRjYt/9nUDEmc5zew2kowr1cIqphMHGBbMZjNdakZRS7KzqHID80POKnGxokFzwJZyi8Bpg0e0um3g7fkUbvPYaB6tu4lVZKyU1PHP9PIzOfXjH8aWsVLsza4PtAfbbbfRSNwB3hTUTQW7U4vzN2eWq3qjMwVHq/C7BUQlbNSHY66B0/UDcmTp22QSJyVj10+OZ5mNz7ARcBw3ICeSYd0q6Gg0JP+WvHG4u0tR0mH14dPlt2ZB7pHoiqUCc2R4AigEGJGzMo+Ac4XdKyXSVTqyhRYHR1eNO/0EVpuXXNBXYaW2vwx46UvShykvPdukiTmZi22tgUhg7v7kQ4JPe2tRB4nUKuwKHrXqhbAyttGEkzB4rcJsyXFXu+m9Y7Sfado9CRCGc4Ek31Yz7gZdGWkFXHo4tArgAWyS0s62jK8kA228DTB/UpyZrlEiLNPj2pzfTSwCNQsj8fD82IXtGv8YxArx8TtV+0CAufwqRz1sfKaQRp+H+pqg1C+YXnQMvAw9s+Vso6ZELUglzuWkzdWbkIX2tc
 1BsGHNzY
 G2BxF5397MGGKkrjjzqlG6eJlO+PyrLUiyDKW3paMRXJTqj6FhzaT2IpG47TG2cSuAABOA8vx2EW0fJQ7b7zAWP/vhfR5DHkhHedUfo4gx4ZfkmYaiBGqRRF5hfdqpVKHlXBQN4KcAY+19zU0xVHeuGFwqEl0Gt5jtfGy4oggPBnw+LPDENrAf1Yl3lhRVeDgmOHDCMdTWkpbmS3FVhERbYENJ4nD8h/gIxqh0XsTP29Ti/BVvHen06Qy7HvGKfOHtw1r+DvTUCbd8BPjzIG4PGerdUSGACQ16xEGsqhAQZkqwruMQzJkVDbp0YnqCA6/zrmmKw0yn1r3+COfQ08iE6lGx7+6CLV5+WuSFCu2GSe2SAMV/Cu5U5l8PSVfUFGOCUqEWYSO5YKTKiuYEjDHsO5VCm03MPj3Io/K07ykn8DulhBo2G6dJbJsL5qqMHq/1bIwXUv6EiND2c/tBeuamCN9fJPF1NeaO6RpOc9v+eStPC4/tmSSEgQifsAjg/DHNjsE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Second, as Wei pointed out[3], we may have a chance to get a non-swap
> entry, since we will drop and re-acquire the mmap lock before
> __collapse_huge_page_swapin(). To handle this, we also add a
> non_swap_entry() check there.
> 
> Note that we can unlock later what we really need, and not account it
> towards max_swap_ptes.
> 
> [1]
> https://lore.kernel.org/linux-mm/09eaca7b-9988-41c7-8d6e-4802055b3f1e@redhat.com
> [2]
> https://lore.kernel.org/linux-mm/7df49fe7-c6b7-426a-8680-dcd55219c8bd@lucifer.local
> [3] https://lore.kernel.org/linux-mm/20251005010511.ysek2nqojebqngf3@master
> ```
> 

I replied to the new version.

> I also think it makes sense to fold the change that adds the
> non_swap_entry() check in __collapse_huge_page_swapin() into
> this patch, rather than creating a new patch just for that :)
> 
> Hmmm... one thing I'm not sure about: regarding the uffd-wp
> race you mentioned, is the pte_swp_uffd_wp() check needed
> after non_swap_entry()? It seems like it might not be ...
> 

If we check non_swap_entry(), there is no need to check for other 
markers, agreed.

-- 
Cheers

David / dhildenb


