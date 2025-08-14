Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4ED3CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 09:15:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 712D590011D; Thu, 14 Aug 2025 05:15:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EAE1900088; Thu, 14 Aug 2025 05:15:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6004C90011D; Thu, 14 Aug 2025 05:15:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 48589900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 05:15:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 12BCCC0592
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:15:35 +0000 (UTC)
X-FDA: 83774805030.28.BCA8521
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id C24DC100006
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:15:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VlUbxOPf;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755162932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pdq1zJqnP2uAEiZ7qSEJPdjozc60JgkfexDjAUfx3j0=;
	b=upiCdhClO2C+GWtOYXfAS9F6BNxxc61BizfMlYfUB7UDUTAz+PhrglNCM33lA4X37hzLZj
	bl1M/LbA2bfaYcy1WLqmeOoFnlzU7FdP5rKq58hWcJYPVFfCrNVwKTw0Z6CWyWH/6SjBqI
	S+df5ooFh9iMguxI0PcVoaieGDJquqU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VlUbxOPf;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755162932; a=rsa-sha256;
	cv=none;
	b=Fu++aromrieXesUXx6hRhWZoi2X4AXFDdjOZwKSDs0Q/x4GFv8A8qS/brzE30TyuMk3nQl
	z8w82M5QNq+HBjN5kaP7IfhkQ73IOI4BdsR3PRv8JljI7UiOc+cTxsSOt8qKWvrp2CBf02
	N4O/FxzLdxmicOlcezAu+2HubPPKPFg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755162932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pdq1zJqnP2uAEiZ7qSEJPdjozc60JgkfexDjAUfx3j0=;
	b=VlUbxOPf3iefE+5LTRCnko650f4uX/cdWOqS73P1I101Hx3dkVHBqvXbqFbbi7m1IlUdMb
	9fOApkYnfNwQsKDOR5YuMhVpRRfGdFCA/M4G/zoL1FzGFaxyHyEhRId2c+QBpL1h/WmcnM
	ymASOjYwQtG/CSnueacGZAoX1HN9asE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-377-swg5fHw0OEKRCv7bzYv1XQ-1; Thu, 14 Aug 2025 05:15:30 -0400
X-MC-Unique: swg5fHw0OEKRCv7bzYv1XQ-1
X-Mimecast-MFC-AGG-ID: swg5fHw0OEKRCv7bzYv1XQ_1755162929
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b9edf332faso269475f8f.3
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 02:15:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755162929; x=1755767729;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pdq1zJqnP2uAEiZ7qSEJPdjozc60JgkfexDjAUfx3j0=;
        b=R90mwIZbkzpOwcVRCz2Xxssu+6r+hROF1ugU5x3ffkXg9eZHOt2Jexy0Ph776j3gjN
         p8O3H4wJ0JtNLUpoZXv0LCi93V5tcx2X4/F3DtXbvAwvzBs3fkX2vb6g8o5G96UXoLrw
         i0guGXW/rRjh/lAtHMa9pklClOucFGeLxYw6c+udE7OJxL3J3RwsqX2MwIdUXlFwz9C3
         p7nYDsXS7BAUenpNdAgzwkZLvWM2zXTeAxormMoeir7Nsk/QHpiIRF0Z6d8IWkhokBks
         fBPNrCuZNfL6shUgoq2ezpSS2+mh9s+ZpV+he6oK3HKS4mukngXFNdvb8h622DY+Ilfg
         vhPw==
X-Forwarded-Encrypted: i=1; AJvYcCUy0XVQ3jerYnoKXcrv4gddKDhPifRdM+0P7Ql+odXeudsmXbgyIf/TIprTE0AhugU9GCci2crAGg==@kvack.org
X-Gm-Message-State: AOJu0YwJBnLxCFOWCg1+AEFw/E8+ybpDrfFNMBGP6UoQneMvFdrZP4s4
	cfH4UY0WSoS2dHmgdGF93b0if3Ros8X73efmVIa0N+oPUgPvYfSiphb+O49aUQCfbdT5e0PPE8L
	QH2nWedMZ6OgFF7iwu4fa2KTMMZwBvx5aikT2VY+ujqOcgfkWopj3661WWYsF
X-Gm-Gg: ASbGncvkKx3qcJ7O6I8ZNNUM/npzQwfAyWNqN82FFQ8AFbQJgo7OA80hLktwzgrSJ5h
	8p4cF1gmMz2yBKDmHa0tLCCcnIhbQxHKogfNuLN2QcOZjo8ZFwBn5y7sZfvHwb1RjQJR9H6u/hv
	mHoCa8kfthAjVEgvxLoaKzX9v34pSNYmv+WWstHvSfRCl30q9ym6QPIlG6tCsG2LICV5syHmn1r
	90JBUQmxEnMCOX5iMlwTkt9irua3+6DIeRu2naP2r6jgL2w2nHhYxzr/rWwbgCfqce4M/CzHTfy
	FG5b+dC8CtJEPIpSGlAd2zhH7nj9s7uUDxCWPJ2/lEZbBWnC5eO+8uwz74BRmzmp0UIY3UAgAGs
	0MLwnc5F4os9kkeTvQj81o2DOccUPJlfn31TYfiStvOi7hCyh1gv6qCO2vHpeo67Wv18=
X-Received: by 2002:a05:6000:2884:b0:3b7:99cb:16f6 with SMTP id ffacd0b85a97d-3b9fc35fe36mr1949810f8f.53.1755162929388;
        Thu, 14 Aug 2025 02:15:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEcrX2+PzCY0XZvo29SUS3M4OEb/0+9x7J+b/dmSOc+iPiPpMRSSVKrKAMc+n8yaXSCp4+hKw==
X-Received: by 2002:a05:6000:2884:b0:3b7:99cb:16f6 with SMTP id ffacd0b85a97d-3b9fc35fe36mr1949782f8f.53.1755162928978;
        Thu, 14 Aug 2025 02:15:28 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f44:3e00:9fca:7d89:a265:56f3? (p200300d82f443e009fca7d89a26556f3.dip0.t-ipconnect.de. [2003:d8:2f44:3e00:9fca:7d89:a265:56f3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1c71068csm13649375e9.29.2025.08.14.02.15.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Aug 2025 02:15:28 -0700 (PDT)
Message-ID: <7b8f4380-d74d-4498-9e14-b1302f1dec0b@redhat.com>
Date: Thu, 14 Aug 2025 11:15:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?B?UmU6IFvlpJbpg6jpgq7ku7ZdIFJlOiBbUEFUQ0hdIG1tL2h1Z2V0bGI6?=
 =?UTF-8?Q?_early_exit_from_hugetlb=5Fpages=5Falloc=5Fboot=28=29_when_max=5F?=
 =?UTF-8?Q?huge=5Fpages=3D0?=
To: "Li,Rongqing" <lirongqing@baidu.com>,
 "muchun.song@linux.dev" <muchun.song@linux.dev>,
 "osalvador@suse.de" <osalvador@suse.de>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20250814082950.2888-1-lirongqing@baidu.com>
 <7e88d01a-10bb-4edb-9010-f9c0bca31a46@redhat.com>
 <8db5f7f3b66a40af8abf921290db42ab@baidu.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <8db5f7f3b66a40af8abf921290db42ab@baidu.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kCyaqeLTDuKSIOm9i8PYTYLhbbXijb3eZFHEkaiUP1A_1755162929
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C24DC100006
X-Stat-Signature: ffdwayxoee7i7oe614cqqugrq7puzsnh
X-Rspam-User: 
X-HE-Tag: 1755162932-986047
X-HE-Meta: U2FsdGVkX1/ZDuYHlsbR6QftZaCkIlsscIg4Ko12gI7FBfGLtZahKxcOf5M6FnA0Gm0EImHlX5N5qHibTDpzeJeVJKxZgjQ54yfmv2eCeSOTf5w9a4L34/t0/2sRYp2w9sOnhiAuZ3RIW7ew4if4YVa8LznqeOz8GfJhWPpMWiyWuJoBWHckt/4De5gPX4ktK0B42AzSVWQ004C96D+fCv45ynPgSDdt2ujk5KpLE4S50DSizf5sY5+H2XoevpwAg07tcF8pgOkVJ8Y7QrQsjZkwPQ4YC5tqllcTOqa9tArH4MCAos5Cc7IIe3FbQ0MvmwXDa4RUM4bTc+AzjPmnlFtAxUKBofii1wDoHOL4/n/iDS7ibXclT9rdaDw0eMjDyr69bRKN/LcGPfF8ZaijRd/KXKRD98cqRspSW5RDh1dz46VzIGm8wPS6h33IAmj8MTfjTaF4Oo2HD6QWTIRcZa/fSe98DBQKG50owKyHqmFB3q/3+7lqBtIHa1CO+9osoHe3T2SEejRf4Gd6f0Mi1emHK9R3QKvsMV5+2rgbVZIuoLdD/x/B8pNIBQC2+7YjR0OXWxtVAeuXKvJDjOj7DqW4OcIaArxE/ldapSPZingCxnDFG9Im5TZ1cazyeK02KQoJaEatnbFtBF1YXLe2o+Os8gK6CuwL3PAMXtYhWfgMKIMDYjvYAzaPyYvwYyGhbPNiteEsdKByWdbTL66Y9fSFAimbhJRSHnf2shQIdtv+9+3HLCvNqI8P9mj4uuOiNg9VfsUuDZ5x0Z/J8uzDJRBn9q+cibBu9n9de6FtuwCXamaywwBT5l7bF34U54izS3dhb0JfNFx2YDb9QYKqLFq72zW+mRngIrQ44V1ST4Uj2HGsbHdKhUfhdlecQIVhwthLNR7bhkpT5WO5ESfOz/U5ZGHg8znkmu+i2cX6cm5uI1/RKEpYHcwOWrKedzwsFbxuxCpq2GAQ8zYvhpm
 ewzvlkpG
 DtmCLPYIPlX/vURfBoFV9k09Vu39e4EQ8qwrIUE2fxLqtvWefGAzkYx/Q/Ay+wUfpjTpc5Uxt7HBjYg1/4pkMTODqkgtg/K/LVXpHSeCS3k7Hdi3K3xtlzrq9BBGopEHtySz8sVz9A8K3plNcjW/UOaWr1cr40DUUmo5kSZse4s1i94E/01FqaWPA/WfLSZlmPfa09y9Soj1fNplpteyjTGJjC4ocR6PMxnIiv8NA4Wb11YIWvIaJQipD+86bcfYxC/UiHohfEXdYyifk+yZQZhTCWVWqmdGefWkuGFIVlStBYKjDkt2f3BUo/GLHYxOTrcJCTOoK3XFz870xpKIoEzMwpMHAc+DqDrV96yiNDhboZcQSokxkj0IdQXODikXwv3eKgA4b5hXOV2d6VXz97O+//vC6UQO8wR5tt5DpZSqrBLoyTzV7e4wk5T7Kk3iHel+A3D2+BngdRBe1qD55M/uxRECJJ0jdcidd6UgRAplO2c33Kat/3Q/lbT6IYKvXzTzP09ptle8SOSeinupCVmwTffCa1XopmG+8PJjx4xmFLR96nkiCTZjHx8kV4fdH6EKL5a6kIcfyNM4iD0AX4hDuo+HumsNt5GN3hhHNdojeSzo2s/KGe2NrO0EgzyifVmKi45KKZcVN9lrn0G+8ErQEfaKwDA1aWp80zGfI2Nab+C2EXDJ5dszosw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.08.25 11:12, Li,Rongqing wrote:
>> On 14.08.25 10:29, lirongqing wrote:
>>> From: Li RongQing <lirongqing@baidu.com>
>>>
>>> Optimize hugetlb_pages_alloc_boot() to return immediately when
>>> max_huge_pages is 0, saving cycles when hugepages aren't configured in
>>> the kernel command line.
>>
>> Do we really care?
>>
> 
> I find this when I see the boot log, I think this log is unnecessary if user did not configure hugetlbfs in kernel cmdline
> 
> kernel: HugeTLB: allocation took 0ms with hugepage_allocation_threads=32

That's valuable information to add to the patch description :)

-- 
Cheers

David / dhildenb


