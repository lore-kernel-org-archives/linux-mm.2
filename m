Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 548FECAC586
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 12:24:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60CEA8E000F; Mon,  8 Sep 2025 08:24:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BCFB8E0003; Mon,  8 Sep 2025 08:24:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 484AA8E000F; Mon,  8 Sep 2025 08:24:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 31DA18E0003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:24:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD46F1D3CE1
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:24:06 +0000 (UTC)
X-FDA: 83866000092.28.F9F0F16
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6BC7914000F
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:24:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i5if0fQQ;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757334244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CdqcOVNfhfInUmZEaYcYwLepJjAK+fkXnYq/58G69P4=;
	b=vh/2ocTX08J0exrv6Wjp+qdpPp0A3QzKNvsDO56baGlVwtbomVumA0ZYYwQYx45F6a3hmm
	+bzqwbEIaxcNyGH5xn3sszpne/1BP8BRfVwG4152WYdK5XcWIBYCIqlzyob4+YvglduWJC
	0r9s5XBh2R+LyIWXGKiL5vXZyMbRmW8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i5if0fQQ;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757334244; a=rsa-sha256;
	cv=none;
	b=5buriqTnU/TBsRgnea7WWs7CI7KKXKZOFxe7zxlqgPL1TSMcRbqlsFHO9pQa34xf9i0gGi
	cmWkSbjO72bMo39cstNmCzI9IqNnsn95vAzLmG7hBQ54NHXPCWw9OdddV9fg8W8NBQt7VD
	E0XAqjq3apLqn7hbf+eNvVeqk/ZRkRE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757334243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CdqcOVNfhfInUmZEaYcYwLepJjAK+fkXnYq/58G69P4=;
	b=i5if0fQQorvKNOBlxj1BvcTBSXKVoeuTo75563HH6w9ZIsHwVWvnAAOyh/TBwwj42Da7TP
	mKZJCVaHqUb2WqKeLdOla05NQhbri5FQnCkdSRlcDV9NKw3io+t/j9QwKc95HM3oORnlqN
	B26XN5o1eMEsce11IBtBKmw0fqoxSsY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-rWSsfouQPm-uaesLtatkxg-1; Mon, 08 Sep 2025 08:24:02 -0400
X-MC-Unique: rWSsfouQPm-uaesLtatkxg-1
X-Mimecast-MFC-AGG-ID: rWSsfouQPm-uaesLtatkxg_1757334241
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45de87c778fso3882455e9.3
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 05:24:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757334241; x=1757939041;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CdqcOVNfhfInUmZEaYcYwLepJjAK+fkXnYq/58G69P4=;
        b=q/ot7/MiJYp5DtcNCkHjELy2+InqhcopicN9DUgpGwK+eco0qqmaNySDLXNGanc9YE
         rdIkvb5zEwgBL1bg3KtftYVJt6KvvtbxFQV/HqJ53TndiWQYdHSN5vCsOboVD2h4bR1Z
         nuwetZOBSoLS85m9/pWwRkKpFnRFW+XQd8LR47jmFAY8hlpR+HjTSw2Dca6XLBwT5uHH
         dhvVVKAFuo1scJ2/GJl5bQjRUEtdQ1e33PNWcZ99OhodmZ1O1/KXhSm+JFll6lPD6e/Q
         NYQriCCFlkwcz1mAZSOGw3bvVP/A4yRrTjnuGsAQG2YC5dTKFGUpJCDacHyE6+uqAS9K
         qVAQ==
X-Forwarded-Encrypted: i=1; AJvYcCV4s0UogZ7pPVxw4vOjJWZmxFj9k0/sMJlF8Nx2NxYkolUMS3zyGqorq+CHHY2yrsnBrAk6R/SaGQ==@kvack.org
X-Gm-Message-State: AOJu0YwC2h3UO/i+GMjRQilbj4iSifeolYVzSiFunNef5o+VKVr9nLRR
	yBljnk97xhEADe3rW+B2FmQjc5mmFZZuVgdZxuZSFT7wOeOAmoqs+X2NdjGljt6Sx/2yBNFP8bc
	E3akJXjmFudVs7bv9F/80wbg5DAu0CHxY5s3aVVHA1hEh80z/E+S7
X-Gm-Gg: ASbGncuwu/1hgzd4FORirgan/oSNW87oMsvoGBHMGug/ZFBE2fiMDbRoQr1Sz3HdzeM
	bhpBy6RyQfmSNzJb4spm6IhddbBhqgQBGYJwv6fh7EVjwV3tCDEPD8C74vO+ajenspNiRTMYyAi
	DxbdMycjrlBhjJ6/Ds47sCLw4qYqcdMwmjKOx5VUJdVUYLZ3GUZBgbxLS6u3bBvccjC4MHC/fnl
	LeyCPMrkwBngNVnbVV2mcUDpRViqoXzIvDD0yElQAOhbPteYf7jVr0OEW8/xaIGD2gYJ7U2KMUa
	FRD5QXgfLn7DL3eJuv/vJKG9kliwgosEkbq6C7DvtCN72KSmfDj01nc9rOdwjozNXciixJBTDDK
	wTglvp7ZkMtWage6RtnnN6CKylat9fyw3Nj7bA8HdTp338f+4sUhvNKoIbZrfQ9mY
X-Received: by 2002:a05:600c:4fcd:b0:456:43c:dcdc with SMTP id 5b1f17b1804b1-45dddee3ae6mr70426845e9.33.1757334241547;
        Mon, 08 Sep 2025 05:24:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHjTYoOJ0FQMtRVKXmzpvinwY+4Y5/zvK6JIFXjMShyLSR0WIJjevW6Zcl9Pes3QYHfnyRMwQ==
X-Received: by 2002:a05:600c:4fcd:b0:456:43c:dcdc with SMTP id 5b1f17b1804b1-45dddee3ae6mr70426445e9.33.1757334241187;
        Mon, 08 Sep 2025 05:24:01 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dd063fc8dsm88565895e9.7.2025.09.08.05.24.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 05:24:00 -0700 (PDT)
Message-ID: <41fd5c4e-d9cd-4906-900e-2a6ae50ef12b@redhat.com>
Date: Mon, 8 Sep 2025 14:23:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/15] mm, swap: cleanup swap cache API and add
 kerneldoc
To: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20250905191357.78298-1-ryncsn@gmail.com>
 <20250905191357.78298-10-ryncsn@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250905191357.78298-10-ryncsn@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Rrne6B68Kz3lDU8GcN-ufk9hB4czSoZA7b_IuXU8UJ4_1757334241
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6BC7914000F
X-Stat-Signature: hjokas5tnn1uk933zr1sewcbeybpsp13
X-Rspam-User: 
X-HE-Tag: 1757334244-631724
X-HE-Meta: U2FsdGVkX19HsPBgYzo2CftOZ8An1zJwx/nb8FUomti4WWSEUU49U9+hR6U+cfR/eVYmPk5w7zfS4RBXXuLOG7uw0rUNat9gpsKnyan27YNmLMf8U2WcpmvxhUH5J8AoE0z6qhuqatVerzfwfVuv8vGx2DzX5uJYEY7EJF+9BnTJ4LjJ9fX7CLSOwq9SMP+uBu5SZPSlg9k8k5cEp0xCTNTg4RbpdOgwJwWLJ8rdwlGnzS1G/x2mrhyYrb7XbjgpN2hVoTKiLYD3+PGHFy53cEqU3ps5j4+lnFYbPWlbgyYj7CV+cStevc1YOETsCxMU5DX4RMqQUIN+o2CgQXPKRQjIbd6d/dKzp3DZnG/CwDU44tSPPP9lFJA26LQm8nBQsjVNsH5Jp+YMnTSyxJ9M3BslBDIjZ527ZzKf7fXfB5iPAn+euDG++sFt5gteqNuTRCA34YEOXTFaW6o1X2Hkj6xmiMdOcJ+0diGDJPbEJ55CkCaTV/i2dB6x+kH1ECVI/q6fjkwinglIzvSpuF5APIpuOijY4Aqr/vGGjQMN4LNt5yfKupl+SivCR/0HFLyjjzkTIIo4H7UTSH1bThs6ETgJkBRqKYDqFKSO3JxYP7jx05ANhmR3YvFY7odPTkDUAQHOFEgrNMcLwhIEETbvBHgsfS27pfcZFusvB0maLPSRHUEuwGgDpSx6QjoeRJ+KVfNFa/K38NmWZa3irf3a8bPcxWgRP6nbvdGF/P4QJtNqPMbMBzkzFLVDObyG0N/bv5wnI50xdAItjavACtZwSu9qVD2m6T5akDYu+l5sLcFaaMviaXzoQr3aDAH9Zqua9qn+5trmKF+2vlVSTGW8PEKjCwWrfGm93U5KiQGms3KLwf+9dTvHQDd4IsySGo3tpBcYZo79JokyijzNP4TKsP4VbJeLrhhMKYJVwhrLKwAGyGB3wQtEIia9eYEStHx0HrdG7yrPtcVMq/D1Z4g
 Fq+NLEf5
 NRroWgZP4oT4dBXnKG1iBZERQmXbNbOcCpznUJbusYB4/0FdLPYSdVU6uVDng1AtBDgJx3g4RgzWcT4a66f3rZvYeZbFXJ+NL+rZ9c2uPVILu7ec9KywIqSLfl/yTFemF6X71/ZS/j6sjOlrQIq59C6MQgPwOxM8FvkCb1ZUnmyGQZwpQZmx0OcKoGbkX/UZq4aVLeckT7GSNpkgar8OQ3qEdoqAT1dBDRgwX2+x0r6FQSa4odU3QaS+07Smmc9wsJ9VEul2UCMP0xki9WBdAADXF7kTeWwTOBAeFzLiG+Z6h2G6viMoLiHB2WBLXYMIPWJh88D/OQJn/2kRcrD8Lb8v7w9ILY7U3JQHHu+zgSWUc3jFp98itV8I4dm6tgPVKl54itYASBwed9bWmptrMlhCNNFKlRJilXuqJyScxVYM+5O3K+Iyg3T9JJUhvkQMwrW83
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.09.25 21:13, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> In preparation for replacing the swap cache backend with the swap table,
> clean up and add proper kernel doc for all swap cache APIs. Now all swap
> cache APIs are well-defined with consistent names.
> 
> No feature change, only renaming and documenting.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


