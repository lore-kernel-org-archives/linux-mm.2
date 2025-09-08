Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B161CAC586
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 13:12:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE94A6B000E; Mon,  8 Sep 2025 09:12:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBF776B0011; Mon,  8 Sep 2025 09:12:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAE256B0012; Mon,  8 Sep 2025 09:12:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BAD0E6B000E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:12:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 854031A0164
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:12:24 +0000 (UTC)
X-FDA: 83866121808.22.4EAE51E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 183A7C000D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:12:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JwCsaa3j;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757337142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NVdkFKCmPF7g5530FhEEA3tNftM3aZu7xS4MKSbP0Fs=;
	b=4B6f2VbPo/4+dc/5xiIBQgCMjYCFmILLfKFBPkRS5j589qKJVVZ05rSpt4CtxGInDiKggB
	9KdVzTPvnP2Atd5Rdxn+JXUgJL6rTRL64QSbqXqTtd4EzGWk+h0mqFX19ks1PE8aVhEs6Z
	r+wSF5suu0Nlps8UnAUb0uILeaqqDOY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JwCsaa3j;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757337142; a=rsa-sha256;
	cv=none;
	b=oDiNeh1bDVYNO0tZ3mh2ZgnESKe99Bjy+JWQTx4PirwGs885UY6GdzuNm6JvS7X6WIt0q7
	pXRKyitbct04+RJ0BbCWBFqCEb95Z6wG+YTIfKT5ONokkJgrdfQuPbc9LlJfBbP7LQXKQH
	3Gj+9BuUjb5Z7XMY6XZ4O2oC0nsSzPg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757337141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NVdkFKCmPF7g5530FhEEA3tNftM3aZu7xS4MKSbP0Fs=;
	b=JwCsaa3jyP3qzPN96BZmktbvapjSIzL5OSmRiyyCab8BiZdlZkhXFgVSztIFNIIrssxk56
	QUvSREOqCTQU9SdPJXD0vdJQrtQEH9pYcFnU0XN/rtWIpe555Luwn2IJSfpG1NH5mdEMum
	1FP7FspGUvBua0u6At5coijYZ/xjIXM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-1mhyVlxqOkGtxcz1VsT1OA-1; Mon, 08 Sep 2025 09:12:20 -0400
X-MC-Unique: 1mhyVlxqOkGtxcz1VsT1OA-1
X-Mimecast-MFC-AGG-ID: 1mhyVlxqOkGtxcz1VsT1OA_1757337139
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3df9f185c7cso3247524f8f.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 06:12:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757337139; x=1757941939;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NVdkFKCmPF7g5530FhEEA3tNftM3aZu7xS4MKSbP0Fs=;
        b=IfK/Egc7lp22F8Y7il/b1C7yAmgnXXxdd5M8B1B6f9EJein42ga5KnSeaNWYQCecmo
         kGf4g7PJ6vz7E2efB9+Lu8ULoKZ9ipH2AVWXoSGy1ZlTYMC017alByacrAkgQ7ovlM7b
         zfPcFn4EfW7uHNQeZeVdmsjR2REvBwM0pcy1J4eMmhT9+9OgkzlPs2zliXuNpaJ3URrb
         BRmHHGWkh3KdfaKi9ehSuQu1hdgCxRXyb+tC1ITg6JUMrtqIYTkeiJtNpTMl2mKmzjLW
         JXQC4tJFwPCXK4SrLMjyI3OpMV0qrB13fs4VX23pbgdqedUnQdoIYfChR0N27n0veCPO
         7HrA==
X-Forwarded-Encrypted: i=1; AJvYcCV2BZmy0BJwW+uOuCyp1sYNgwNAZYWkNjD4xmAEfRCxFIQXIfB/WEj2A81Bb3EnSS1sOWuYpyBF+w==@kvack.org
X-Gm-Message-State: AOJu0YzcPO+wrH10Uht3kXarWmHAZltyU2pxV1E2dqqFgKhRHmrz9cfY
	IR810wNt9HP8XEjM/sH9kghRolew0NOxPmx8PoZhsm2zptpnmL7M0iqMMPy43ZBKpbYUBRMF0A2
	KPJmN6SxoUFCfh3lP/lvgFoHdsEIjNN1eGIuStM9wwN5K4DT10C8J
X-Gm-Gg: ASbGncv4h2o7mHtXKAWLDoKpj0qx0dHt+BDLdm1KdKArfoqWQKFOmQxR/vI7SoiRdte
	xi9Sj73K2IZM+SSxY4sgv4jFYTH9n4QGi4agFDD8ZqfaYyRSoi8p+pktWHxTkuWYCvrVma0bLyl
	VqrI+bNoLettPKs+hKRkdmKXVBcMbm+qS6BtaM6EpBX1yB6OH8tPaY3U6lUxXP3jv1NjFiyDnBw
	Q7z5SF7hlZAbCwaeCx/+4lCnykGCiYeWWEBqXT4Al79f7YYobwGIt9/12uHmNMtVlRCLqfoClgo
	ADxQ38loL18xsFmOMesnNHAhg8SU+9Fsm8OXixxTmCGfFow4cTpJkfpTlNo4mFIYUZGhaIjMHOU
	fK18RM5HtCNhOL5l256kQlbxv3qak2mXtl7j7w5dzGzycfrLG02r8ARE/m5iSuhE6
X-Received: by 2002:a05:6000:178b:b0:3e3:24c3:6d85 with SMTP id ffacd0b85a97d-3e6428cd370mr5582412f8f.22.1757337138428;
        Mon, 08 Sep 2025 06:12:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFMHzY77T3B4Be+/wcknia2scoADUO2Ag/j0PAcMwAKcnKc9IwA34MqvzbL3j0SNw5l5SMTQg==
X-Received: by 2002:a05:6000:178b:b0:3e3:24c3:6d85 with SMTP id ffacd0b85a97d-3e6428cd370mr5582379f8f.22.1757337137985;
        Mon, 08 Sep 2025 06:12:17 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e74b2e0511sm2643510f8f.62.2025.09.08.06.12.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 06:12:17 -0700 (PDT)
Message-ID: <2100bf81-e9c0-4440-8c19-b04acd3ced31@redhat.com>
Date: Mon, 8 Sep 2025 15:12:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/15] mm, swap: remove contention workaround for swap
 cache
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
 linux-kernel@vger.kernel.org, kernel test robot <oliver.sang@intel.com>
References: <20250905191357.78298-1-ryncsn@gmail.com>
 <20250905191357.78298-14-ryncsn@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250905191357.78298-14-ryncsn@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -lIbcV_ubT729zvrJSkFYFEidQEWwDKOpT2oT-cyzME_1757337139
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xhryezhqipon94fjku7dpfjeuhhxnkd7
X-Rspam-User: 
X-Rspamd-Queue-Id: 183A7C000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1757337141-561576
X-HE-Meta: U2FsdGVkX184Lrav+o9qqerK2JI6XGYfCFoH5vUusZXr6kCehw2O1sJKyizKpo+Dtz275mugqjTG/RVl/MGdel/YaAgldOFwfNvcDq6Iyx0YCFsWSZ0tjhA1BeH+ANWd+mby9vwOJg61869CJNi5wLe1wNA1I7n8Aipe3lZ52OzwIqnYtWL9gldkExtMtEZWaicR7Ntc7KrCWZ9o80OWAWfiS1suRrDz7zxslZM1+Iu1m/uYEBa2daAfbj6/lKs1b+ZRYpjVcdxEo2gAeTjJJIbYt/a8pOdF/ERhrHTqzB1VxiwVwh3gvMp1hi7H9ww/OcPM0g1TukVkpNNreNPQgQE7jLKMAD5u9W6FDtS2LGVmkMALeBe6ne44o9G2uZON+X9k4L1H9Du6nxuNs0gexPIRMqx7mCyxQLD9bLhMOp2UD6rcjvyIDdYzVzQfDgbU40QCpUqr8wylDAcluSON5gubhVQVAQFVSUS2CavnpIRPg9OwOTpYQy+ueUEH2Gr9vf/5ibRGjCBTlm52Dpw3FMt4PpLcWVqYCYOoBcwrkgUnwZYdmCLEXRIysXh+TEwYqsOtP3jlSRUjqgnIO960Qjl3jQMn0JxzaZbNhohbKHhrS29OPfbUO3s9G+9avkCWcakgHh0rV7ySPkTEX69c3LxcTE1NE+QX1+GDoqKKJ6uwRJJ4T7OH2lg4ADQ5lHwYIspMye+u/cTwsACfz3SwwWRHyUgoCKVRHMddPHqtdrgfBugBJvBmHy98QkHzHNhyDJOeEjfXnuZOutD7Tc/BAF/tHg35PtArYTSlZUSmPO6Fj17WYzPnqP74G1Ma7kO59AgatYM3K5csWy+bctq/JEJYGar5v4tvhCO2gpaao3jsM+a1wGONH8TARKXdMiZKfpjYW0ayYidlr+HLHiIQSJDWP4VLssTiLHW/hSUJUJQDTnB7i/GEYk3wHy740m15cIucWQxyIKclSzTMVYq
 Nku+XLkb
 4z3/Opqa+YszQfaHRjNat2JWkHMzBlgOMFKZDWAVP5mrShZrviwCF6mHQhhLx9w78sScvscVQaVpOEPZtE5ST8/wDfvRZOvz/gITENvQwZpW0AY3BCDdSo7KWUVaZ6qWd3FzwZBN1k00HQW4mrKE16x8NzgeNfa0rrw4+4LxuK6LwgDQ6wHg3y+OBJenhbHJJmb63/aMOJpiG2nQ147VYKL9UBW/8PvrsvvMF3QIziAI+nbqxZMKWZnRXNVTbjcsRIp88JJgBne433JPY/MDdWoPzQGXAUx0ezIwWOcI9L018/qN5IUQVPh1qNAZ/Hi13BNIr4nhGkYdNYWb/0IH6KaW0i2T4o5s+K2suBH4rJL9GI7y86WG4/qGy5+KnxyWoEtgdH8h3lI/IE4qjlbeTEWmJCgXZBFi+yAA7KG5Hvyh+RKep/LAuYZ4L5csuvqc5QLiKErRoUsIXx7W6qlq83ndE78DnNwzhHLvC
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
> Swap cluster setup will try to shuffle the clusters on initialization.
> It was helpful to avoid contention for the swap cache space. The cluster
> size (2M) was much smaller than each swap cache space (64M), so
> shuffling the cluster means the allocator will try to allocate swap
> slots that are in different swap cache spaces for each CPU, reducing the
> chance of two CPUs using the same swap cache space, and hence reducing
> the contention.
> 
> Now, swap cache is managed by swap clusters, this shuffle is pointless.
> Just remove it, and clean up related macros.
> 
> This also improves the HDD swap performance as shuffling IO is a bad
> idea for HDD, and now the shuffling is gone. Test have shown a ~40%
> performance gain for HDD [1]:
> 
> Doing sequential swap in of 8G data using 8 processes with usemem,
> average of 3 test runs:
> 
> Before: 1270.91 KB/s per process
> After:  1849.54 KB/s per process
> 
> Link: https://lore.kernel.org/linux-mm/CAMgjq7AdauQ8=X0zeih2r21QoV=-WWj1hyBxLWRzq74n-C=-Ng@mail.gmail.com/ [1]
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202504241621.f27743ec-lkp@intel.com
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Acked-by: Chris Li <chrisl@kernel.org>
> Reviewed-by: Barry Song <baohua@kernel.org>

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


