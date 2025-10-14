Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BFB1CCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:13:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB3308E0102; Tue, 14 Oct 2025 08:13:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8A978E000D; Tue, 14 Oct 2025 08:13:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A0548E0102; Tue, 14 Oct 2025 08:13:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 89F678E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:13:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 621F3476DA
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:13:34 +0000 (UTC)
X-FDA: 83996610348.27.91E8FCD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id F2E921C0006
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:13:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ifvdwepL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760444012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kv7+o5qReXLVY8W1yiRGmSjD33EMutsb4wbkPBYYUNM=;
	b=Wc5VAHsy/of0VDm5YVELyUL1sF0k5k9FNMdNyjs275eOecvHxBuMX8MRFwOBb3zq9QPIAn
	jQGZbMdojXKFRROCzbn0tw7sZj9FdsGnGP1LRkRVgHu3iBM+NDTuUPgQoCPztwSEbPLObl
	5GdJ3JnL/SAoUUpnzdG/2iUkrffk4CA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760444012; a=rsa-sha256;
	cv=none;
	b=izk1g3lGaLEku9DtL1hpB3datVm+xj85MWkd4F6cNHEhuM2nOvdJU9ArQ9KSI7dSz/7oxm
	7HebhUt5bVSBDx+oJcaZvlX6u2qYRseC91e3N9prnMpgbF78HquKhronoC5nH2AqAWE20U
	gNU2t9hGlET+9hnV0g3XpthVFGJdaS8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ifvdwepL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760444011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Kv7+o5qReXLVY8W1yiRGmSjD33EMutsb4wbkPBYYUNM=;
	b=ifvdwepLtA+8z4gb3d0dMHG8yevoS+r8xtN0VsE6UyUIbB7wfSE+y0/cX299biJJh8Cgjm
	+0lz94kQF7x7HNSCXukBTu1aFc6Q21mI6IHAYFOEBF2lopJE7cpwyLpJ4ZsQRjO78ofCtJ
	J3ROFKrFFiHuyJfCq6jfl2xSytEYhBA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-266-xFQhdzfeMYC7PT7oeeA4eg-1; Tue, 14 Oct 2025 08:13:29 -0400
X-MC-Unique: xFQhdzfeMYC7PT7oeeA4eg-1
X-Mimecast-MFC-AGG-ID: xFQhdzfeMYC7PT7oeeA4eg_1760444008
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ee12ab7f33so3593795f8f.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 05:13:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760444008; x=1761048808;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Kv7+o5qReXLVY8W1yiRGmSjD33EMutsb4wbkPBYYUNM=;
        b=kR0b60KODUaET+mZfI564Xw5RewqsjGJmcQES7NoWJ67J1MR8Qd/1gYohqqpGAxk6G
         ifTuZOXCq52HQ926qTLxFghHTMDdshLtfGzhxDeg90nia4xTvoIOqqfTflWUoZ6dYpFh
         /uwyhQsP2BtmN9QzrijSudtKhqYAeLDTUsMRz11nlhFuoCNIxwsYSHl9xCqoT1URRjYo
         Pco0dBEYuMXozdlcq/F7iwji07JuP8+rvIH6/UyULrmiixW3doPxeVbTvHnDM8LhzOEd
         UXLAu1x9Fthqc/+ixW7mJPKQPLBe+RQBPCJwuwiGLEYkA3hPB7FbPVg3TNkaXvXQvOdP
         lNkQ==
X-Forwarded-Encrypted: i=1; AJvYcCWuMeBQSBmU0bjN++oVW4q5x0LfShbOJjuTQ1itAPfXR1Lhgmucv1PvENLJ7idwJ0R8S0Iiq4LOOw==@kvack.org
X-Gm-Message-State: AOJu0Yy8AcN1xyylI4YApObTi/BAqCQKeI5YYds20OYRDf+v7w8CMVLR
	rnZJYm2HmrzsOUCYEhW5kmRoHvGwu6X5HORHLLrSjavtYXyOjbBujcZDxEv4N0dNekOfQYw0Pse
	7OxB5PI8rayECklPSw7gQfz/qhUuMbW9EUEngT1zGqdUEynYtj+cp
X-Gm-Gg: ASbGnctxRO4EzcxkGGtD3rVdONSI718gttksrxwNoGrzaoT8Mhg6WKVzxcG4HMVfZnx
	P1SJA5REmU5CSbQreT2s2oh7JZvoAogV1fMsTWofdNhgTa8prU+By+yeVen8iLB9Rg0Osea0ajk
	v+19k+URBERLJvfZhZfNPOTQy6gaW6Ow68Kj0fdkxCtOG56m+Ppc7UGAMXj0jySz2y/T9eLsdCa
	idr3J4IGKw0US+fUBFqeVNqLRxx1IjYECC6xJKUu0cQ+2i/vGRaH1+aq0vAjkqfbtrjvBXEr+CT
	flzGyerkR/2yZrfbTzdfBwlfMiwDSwPJH+SFZjk8Rp5ZZLgw1BBka6FnOyawxqLEylog7wua7A=
	=
X-Received: by 2002:a05:6000:607:b0:425:75ab:cce5 with SMTP id ffacd0b85a97d-42666abb4ffmr18302694f8f.5.1760444008448;
        Tue, 14 Oct 2025 05:13:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHCgHkHtJF/qUmAFACM3slIScJ4NCX5G+zMpyPPqDejRE2RBWmDWJkewLQzKPf5a57UAbh2aw==
X-Received: by 2002:a05:6000:607:b0:425:75ab:cce5 with SMTP id ffacd0b85a97d-42666abb4ffmr18302671f8f.5.1760444008032;
        Tue, 14 Oct 2025 05:13:28 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5e81d2sm23701197f8f.49.2025.10.14.05.13.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 05:13:27 -0700 (PDT)
Message-ID: <2d83dda6-b552-4cfe-a092-a2df534c7cc1@redhat.com>
Date: Tue, 14 Oct 2025 14:13:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm: mprotect: avoid unnecessary struct page
 accessing if pte_protnone()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Liam.Howlett@oracle.com, Sidhartha Kumar <sidhartha.kumar@oracle.com>
References: <20251014113349.2618158-1-wangkefeng.wang@huawei.com>
 <20251014113349.2618158-3-wangkefeng.wang@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251014113349.2618158-3-wangkefeng.wang@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IeEq-ZeaBELfXluNnv5PqWrc4NnfnfmxngBGV6arh4M_1760444008
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F2E921C0006
X-Rspamd-Server: rspam02
X-Stat-Signature: xhtmx6cd6fwzugek3q7m1b86bnfy1jsb
X-HE-Tag: 1760444011-714197
X-HE-Meta: U2FsdGVkX18EVg9lybUIr5riJyt7hf13/4ktnzzlyY3dm0NlzaYBI7pVKCpJHxmL/eqas/prNkKTbT27vHmx7aRxetc0R/VFE0zty4WyDIeusaSst3ptf4PAlQ8zHnxva6vdRHzTC7iVxI8q/nj2UOD+OWI6MgAUT4cpFHwpZ0ixexs6B37lKp9LacrAWxGlrC+mm/jISHUYp1a50WR1yk0Nic4nS/N+8dUxk/VOAlEqTlrcoXIcsYyb/22V53N7uVzfEDK+eCE7OWGV57tL7frNX1YRWrE9AnC4v6AYImhEh0ufQiit6FkIHvFEk28qt1/JbZ+AeCaiREgIYkYHyqQPYgCNoyCJwzOm/8OObU1SWJ6zaFERpvh76T6MX0fNoB4hOoJWwlHuEPshVu4XADk0ntdvOCK4r/MDvZB7LyT9HBDMvqP6cqWGusYfdZL087qS3sbCQM0/cAcEwj/1htsJVzisjE76kMAIlr0OYbR3pniB8wIJqG1Aj71V7ksNB4/hthSrMDYebSbdiinE0V1vYYB/thE2S7rmrgIs7C0wunVwFMXfjkC5E9r8gakFICZY5m2rMyTKlUyw8UiirFEWEeE/XB05Tuwa3H8Kjw/mY8z/hU29S/rVdpjTSE1kVYcB5IAPQIm60Vh/OEaK3KHiDhM5zPuFcmMwry2/HjIMKIaRlb8bOJ8f/iqrhxOwtbkmzFXGkrAphTwKrwIHMsDXV0W37ghuoqICWMyaNpv0pRtJ8u9aJLPCuI0zDc262BYo8noIkXTtsTMFDQwaEn9dZAm/jRX05rpBcQ7Fd0wg12tGILGInDUPqsbJ7XmelJsM0zwv4ThPrM4cJaJgVQsB1Nn1S0pDJx9aW2qwjRsU6Qm2cAEqPtit3QA/EUzZ1fcV3JEyqhXTkk4R01LNKLJbF/gAxdNXPR1S8Wk/G/NIW/6sfMTBpU5ZGZ5ceTpgqxRrvm9B4aPy/H/5YUC
 /toVy4FU
 MGimrWRF9Hkjg9um/RqSkXMBqZfg4HFdvVfCb0uwmisY/CBl9G2hHBfjLJwBxqiId+b5nigNkPRIp8kBZeBs5IQYTRJggozqWy+IQ1WrXwUAzwj0j9lhAp36fGRZ3G40mjlGsv/jevq79Fsa5EWEDyZW+x38yvu5KCs5y/RrxWtzVFPh1Hv5msseZ7VpZsQyaymiiYMKgZPUmvmaff/WXOL1x594Zu4r5hFUkGYsKI2eJy/TgCS9PJ8VulKbPI6+4DGXIUQPlFTBYgFnazsl/nvlSPEg2CtD6Lc7qaU51n+OTEfwg/WRMszLG5aC4O/Au5s31jkNYSxV6pNZghl/s3MbaorNBvAXcRaR125cBrdQu7iQ6E9cWCreIiB/52gKsebkkr8suyn5AT5RXWI9rz45PsPO7MmikfEH+EaZTceAH2Fx5xNST5T6BeDSu+N6kCCsQJUqnPaVI7Cr80xhf7NGuNl+hOCGPJgQEu/GG+DtQHXz3WvDvUtRiqHkJTtpKUB1rmdym4UljdNJQ69mLfIRmUQrwuiXZ5efK8OhqJecjx84rQBudO3ZUYdDvm5oOZw9JWyTGbduN9tEPZmDH40dDFk5VYCuYY+IzzAnCUFYkBno5R2UCt52bcgQLRGkxrU4mWvnJMdDOZmwz6Z+y/sAR3Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.10.25 13:33, Kefeng Wang wrote:
> If the pte_protnone() is true, we could avoid unnecessary struct page
> accessing and reduce cache footprint when scanning page tables for prot
> numa, the performance test of pmbench memory accessing benchmark
> should be benifit, see more commit a818f5363a0e ("autonuma: reduce cache
> footprint when scanning page tables").
> 
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


