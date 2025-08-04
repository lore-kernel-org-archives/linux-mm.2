Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAE80C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 14:34:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E92D6B00BE; Mon,  4 Aug 2025 10:34:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 499F86B00C0; Mon,  4 Aug 2025 10:34:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 361B66B00D0; Mon,  4 Aug 2025 10:34:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 20FAA6B00BE
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 10:34:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CF75B115351
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 14:34:02 +0000 (UTC)
X-FDA: 83739319524.16.599673D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 292D6100006
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 14:34:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hD91504p;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754318040; a=rsa-sha256;
	cv=none;
	b=HIGfdfiRHWyPJXGQ7alF50Ik+yn8EoPL6trflOih/xI8tp0gghHfFrJNHPD5CR8a5nl3S6
	E+MHGr1NaEtty7P6hY26R5roiDU2FygTen5WhE3a9QvMkWdHEDFOOAqHNi6L/5N6ABguDo
	FOpiNeGMCp9PUeQzURiH1hrrzN9rdQE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hD91504p;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754318040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qnwjgp1X7LASZtDmn58svtbysI3EXnkYQZBZvIKEyhU=;
	b=sSM3e0/gGlJOIjC8E0pDP/7nE1/L1yiQKwEwUqwvoYcyIpsTXTkSpYSjqzrepfSHLRHXiI
	Stpctp8urIfEbNukn0ODeQxTfo6yjfhSqLbMhB5dQp2RKgHReyzTryLaJNGvo5TxVS6mKv
	sKGedVtkGs5voZ0Zn33GR/XsP+qagdo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754318039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qnwjgp1X7LASZtDmn58svtbysI3EXnkYQZBZvIKEyhU=;
	b=hD91504pgw8hBTNEJZB+E25vBlWe6HmDbsVNy5iFsFqiSTP4N7XkyTG/O8ca80ueZZ8K87
	YbhltnEmkygFznjFnSIRxrgxylOWlqPL41sw6nnBR+s+iMMSqjyGFF1odTO+pEQFhdqIPf
	M4iE59vCwEa5iN8+qQbA3oH/eaizWRI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-520-Se4syN4XM92oZBNWtQpBXw-1; Mon, 04 Aug 2025 10:33:57 -0400
X-MC-Unique: Se4syN4XM92oZBNWtQpBXw-1
X-Mimecast-MFC-AGG-ID: Se4syN4XM92oZBNWtQpBXw_1754318035
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-458de4731b1so5750025e9.3
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 07:33:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754318035; x=1754922835;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qnwjgp1X7LASZtDmn58svtbysI3EXnkYQZBZvIKEyhU=;
        b=fqzocDOcipyx+XkF8hId/z+YhNiA+Q2nAinPL5lU6+WI3VFCdwvhnyD9wR3bcMeafs
         E2ADDKJ0rA4zCereVUDDYgujlvOKUiwQggmhcheb54qxLBKfrRTIoTF54d5ylxwOsSCb
         fghScAT4vnyZVu6ns7LIMYMMcOnjqM1sefLrjDFgvBQt3gRQaLf5HnSQ/XCxTNqKy7U9
         DWznF9EMsHn7VgJI6KGbQ5AGsJgjXNvidLxjEaPC2aKOOh42XZGRdnO8gQ/Sr83Ma6xf
         P4tCyDzz2OGo6/AvUG8tjh3H5+dAf3GdqyW4Scyaa0O6OlfwcEXdtAzWkK4NMMNNy9QC
         4LVA==
X-Forwarded-Encrypted: i=1; AJvYcCUDC4dbXP1vM1Tv/L/XkYIsb3H+M46QQj/HzWcLB9m9rqS7kSufyUa8Lj3Lt0dr44LFkzNpQ8uVeA==@kvack.org
X-Gm-Message-State: AOJu0YykoQpAS+6dhuoE23nN5jYmFixCQ0ImzZf1zIKiP4Vpks/DhPQY
	9BC7q56DmSUWqCb6wYipkt50zU0f6hpZi7tH0ifK+fWelcn3iGxn+LSjMxrquR48vyYlXII8770
	Grp3wZxsCr8+peJK54glbeB5jKQyGzj3U9BduKUpWWU8NFfQOJoeS
X-Gm-Gg: ASbGnctmNbry/prYbqIAEY4OprWyAsZ/EQpDgzW8GBVpiyoGsYvZ0RMcmfnVBlRIZw5
	/aN9tJDNUQ3L+DfK0nDcW65IM/k1qo9vSPTCiXt4j3eDkeiasfwJFHFHZruyQWFpQGAwPnBA7lq
	pK+SRw5iKwmUtLsRPsT85/3Xblco7cQwX/uplylzOS/PC6DEnXz1qO1SEBp2pN6jFLUiqwWE/Ku
	ixaC3WuxaBDTanPeQLVlFrfGU9uzEtdNEPElv737zl8KlBgGSnFAolah29JAFb1MmjVvCylrgPB
	CRoe5z4Oo1vHTadaGP1r8SwjN927vZKVBt4fQR+nlirq+j2zNZVhIogruGTghU5BmOD1tUHp36+
	XiOHLiFcK2z2PIMiKmJVabVMm0avhv/1AHJaxMAoz+FttDEuqf1e5GbojHnt+gmZ5F3I=
X-Received: by 2002:a05:600c:45d0:b0:456:1ac8:cac8 with SMTP id 5b1f17b1804b1-458b69ef2damr90293165e9.15.1754318034924;
        Mon, 04 Aug 2025 07:33:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFkojQLTR5ipihpzKt5Dlu57CS4vEd/SulHz0nsTGiqo0H36lZUWBrM02TTnUIZ/b9tx/UK7Q==
X-Received: by 2002:a05:600c:45d0:b0:456:1ac8:cac8 with SMTP id 5b1f17b1804b1-458b69ef2damr90292755e9.15.1754318034458;
        Mon, 04 Aug 2025 07:33:54 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9? (p200300d82f0e2c00d6bb8859fbbcb8a9.dip0.t-ipconnect.de. [2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3bf956sm16049440f8f.24.2025.08.04.07.33.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 07:33:53 -0700 (PDT)
Message-ID: <65660d5f-a856-4244-8a81-1359a03f16be@redhat.com>
Date: Mon, 4 Aug 2025 16:33:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/7] mm/selftests: Fix split_huge_page_test failure on
 systems with 64KB page size
To: Wei Yang <richard.weiyang@gmail.com>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com,
 lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, donettom@linux.ibm.com, ritesh.list@gmail.com
References: <20250729053403.1071807-1-aboorvad@linux.ibm.com>
 <20250729053403.1071807-5-aboorvad@linux.ibm.com>
 <20250804090410.of5xwrlker665bdp@master>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZgEEwEIAEICGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAhkBFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAmgsLPQFCRvGjuMACgkQTd4Q
 9wD/g1o0bxAAqYC7gTyGj5rZwvy1VesF6YoQncH0yI79lvXUYOX+Nngko4v4dTlOQvrd/vhb
 02e9FtpA1CxgwdgIPFKIuXvdSyXAp0xXuIuRPQYbgNriQFkaBlHe9mSf8O09J3SCVa/5ezKM
 OLW/OONSV/Fr2VI1wxAYj3/Rb+U6rpzqIQ3Uh/5Rjmla6pTl7Z9/o1zKlVOX1SxVGSrlXhqt
 kwdbjdj/csSzoAbUF/duDuhyEl11/xStm/lBMzVuf3ZhV5SSgLAflLBo4l6mR5RolpPv5wad
 GpYS/hm7HsmEA0PBAPNb5DvZQ7vNaX23FlgylSXyv72UVsObHsu6pT4sfoxvJ5nJxvzGi69U
 s1uryvlAfS6E+D5ULrV35taTwSpcBAh0/RqRbV0mTc57vvAoXofBDcs3Z30IReFS34QSpjvl
 Hxbe7itHGuuhEVM1qmq2U72ezOQ7MzADbwCtn+yGeISQqeFn9QMAZVAkXsc9Wp0SW/WQKb76
 FkSRalBZcc2vXM0VqhFVzTb6iNqYXqVKyuPKwhBunhTt6XnIfhpRgqveCPNIasSX05VQR6/a
 OBHZX3seTikp7A1z9iZIsdtJxB88dGkpeMj6qJ5RLzUsPUVPodEcz1B5aTEbYK6428H8MeLq
 NFPwmknOlDzQNC6RND8Ez7YEhzqvw7263MojcmmPcLelYbfOwU0EVcufkQEQAOfX3n0g0fZz
 Bgm/S2zF/kxQKCEKP8ID+Vz8sy2GpDvveBq4H2Y34XWsT1zLJdvqPI4af4ZSMxuerWjXbVWb
 T6d4odQIG0fKx4F8NccDqbgHeZRNajXeeJ3R7gAzvWvQNLz4piHrO/B4tf8svmRBL0ZB5P5A
 2uhdwLU3NZuK22zpNn4is87BPWF8HhY0L5fafgDMOqnf4guJVJPYNPhUFzXUbPqOKOkL8ojk
 CXxkOFHAbjstSK5Ca3fKquY3rdX3DNo+EL7FvAiw1mUtS+5GeYE+RMnDCsVFm/C7kY8c2d0G
 NWkB9pJM5+mnIoFNxy7YBcldYATVeOHoY4LyaUWNnAvFYWp08dHWfZo9WCiJMuTfgtH9tc75
 7QanMVdPt6fDK8UUXIBLQ2TWr/sQKE9xtFuEmoQGlE1l6bGaDnnMLcYu+Asp3kDT0w4zYGsx
 5r6XQVRH4+5N6eHZiaeYtFOujp5n+pjBaQK7wUUjDilPQ5QMzIuCL4YjVoylWiBNknvQWBXS
 lQCWmavOT9sttGQXdPCC5ynI+1ymZC1ORZKANLnRAb0NH/UCzcsstw2TAkFnMEbo9Zu9w7Kv
 AxBQXWeXhJI9XQssfrf4Gusdqx8nPEpfOqCtbbwJMATbHyqLt7/oz/5deGuwxgb65pWIzufa
 N7eop7uh+6bezi+rugUI+w6DABEBAAHCwXwEGAEIACYCGwwWIQQb2cqtc1xMOkYN/MpN3hD3
 AP+DWgUCaCwtJQUJG8aPFAAKCRBN3hD3AP+DWlDnD/4k2TW+HyOOOePVm23F5HOhNNd7nNv3
 Vq2cLcW1DteHUdxMO0X+zqrKDHI5hgnE/E2QH9jyV8mB8l/ndElobciaJcbl1cM43vVzPIWn
 01vW62oxUNtEvzLLxGLPTrnMxWdZgxr7ACCWKUnMGE2E8eca0cT2pnIJoQRz242xqe/nYxBB
 /BAK+dsxHIfcQzl88G83oaO7vb7s/cWMYRKOg+WIgp0MJ8DO2IU5JmUtyJB+V3YzzM4cMic3
 bNn8nHjTWw/9+QQ5vg3TXHZ5XMu9mtfw2La3bHJ6AybL0DvEkdGxk6YHqJVEukciLMWDWqQQ
 RtbBhqcprgUxipNvdn9KwNpGciM+hNtM9kf9gt0fjv79l/FiSw6KbCPX9b636GzgNy0Ev2UV
 m00EtcpRXXMlEpbP4V947ufWVK2Mz7RFUfU4+ETDd1scMQDHzrXItryHLZWhopPI4Z+ps0rB
 CQHfSpl+wG4XbJJu1D8/Ww3FsO42TMFrNr2/cmqwuUZ0a0uxrpkNYrsGjkEu7a+9MheyTzcm
 vyU2knz5/stkTN2LKz5REqOe24oRnypjpAfaoxRYXs+F8wml519InWlwCra49IUSxD1hXPxO
 WBe5lqcozu9LpNDH/brVSzHCSb7vjNGvvSVESDuoiHK8gNlf0v+epy5WYd7CGAgODPvDShGN
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250804090410.of5xwrlker665bdp@master>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ulknEFkPVdPogCWLCpoe_TARrWC7uKMFZSfjXUp6LSM_1754318035
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 292D6100006
X-Stat-Signature: cohmo91zdyu9anjkxj4ntxnorewb5epf
X-HE-Tag: 1754318040-625327
X-HE-Meta: U2FsdGVkX19ouo8oeBfmq8sUG1lArizStu6WZvJ6Ha2MFMBn6mHiWzb0Czi7NfWZIGCdcGHYds+GjBzrNXa0BAd6OdKMZgxOjPVdjJMdFkTNL1RMmu37scpGyS7NZpDJV6jsLG/Bsp7y6HVW1cv6IVjaSiQFNSR3YfKUOVEX7UcCCtzkZSC7/YlPxeE6XgIvOy/fmWI2eVxlGdYn95E/0AtVdHGNtyzNvoE7BX30FQueBy0eMJHssaEuWPR1d3FThYHwWhSMyo67Q0DfOrGtpdA5OmoJpDpUAiQ1qPMRNV7q9VIhtSHY4V+IPF4kbwE700vVXkZh23WavKpwYqLaGeqcre4bSb+vRXWiB4dm8XKCIFVfLFzqJ6ipBdXG7V8b9h5DPRBKLIdWgebcmD4jZ1WN9ajZw4IMLyaI1QeuH01nj42rY2pVBCI+OAq/Tai+Ztoapygbsx0Be17Hd2X7RvvEmFI7jvy3UCW4lDJ2u8tJ2qbsAG/MrO07ObTsPzwUZb/21IBlg9FBi+ag4AzX9/+o3KSfMUo4daoOfBhAMZvg2c2jp41bCJdw2M67FUVJRPa65pZw4P5tIQDGS3ugXspFI26Sk9rMRuvEl5kmUfmr1LpWRZ9X+M5zLDTvu7YoHWye/eJ2MvFW5zC94ohPHPaB35XLNzrlgEIr1v8DTJR+uDP7QDEGKwOhPFRHBVvRo07nbqsFaX+m1xeT7VOfuOIlSyr2Y7x8H97Sc4fhIFj5AYMskryO59+YbjL8Plo5JLtxrxnskfsr5WvF1WeXs5GG8Hql5WKiMZRtnBhhsR5uqjfE0CT+4G2vuKkcHSnI1TuZpJD9xfN7UM2Ms1Pk4H6VwK1abrQ5qOGVw2lTgwjPQSB/0ZV4IQoUm3CMo+IskqBee6uVw4qHYagJSwOLObuDjr6Xgd5qUhRASPdzo3k/wfDQTMWpaE92W4Si6od6sdAece7akhi8FzO9Avg
 YCmWiMyQ
 Xx6SEi9F0GyygP4OFlzN/wA4C4i++C8jPmfMfPDPgiAsuFUIP1Rx4xcsURNoaaRMAdorBQaKTgmIQMIdAwTg9jyxDb2E8TRPT1Q7gAoc0Rd7u02J089vPLdEoBZLVCoyCc5REGyyhTg2G5Bkh2mFN373/DYvVVX4DzjkNHyU3LPWLcNFS2iypJSJ+yPOhh13EhpIY4EmjalenqIXrjQUauhjvV8KXEnvDDsFeeRgZGdQgyScKFSKkHsT90JHTVVuu8NbQPFOoGfU0IJPDrgwwnYxaMP9TE0V63qUgZiUjDfVlEBGwAr7bibFZave4jaqjE9DqDTAFzaBUKlFUyuXKOiBIGDFewWnWQo9cHf49VKexMADJ+YuH4e5H0s7p+HKjFuJpXEbz3zg+dX3cPKXBOx48zczI/Bc89p09UFEaRF3rEl1NKuuOjq6yIKER2fyHWA/rX7TR9sEtukkltin95wadplNeZR0QrqYNG4zKA2zwFhu2qQcrfI8ZddhDPdWkgtML6cyIJDvC4Cm95uOWlW7EwJxtmibnPV+2rErHdUwCLh9msdXHh/Ivy5FPZAEkGkzCBaGRawJbNo+ZYR2xHqX0zYGJ9qZTKZAIlck1Dizfi/3cOKHwkvFcHWvsYRflOdhuSd9tKK65SsfRhqjRyvhcMPBCYERgniKd6KTdRIwcIrYrC5wiZr8kKg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.08.25 11:04, Wei Yang wrote:
> On Tue, Jul 29, 2025 at 11:04:00AM +0530, Aboorva Devarajan wrote:
>> From: Donet Tom <donettom@linux.ibm.com>
>>
>> The split_huge_page_test fails on systems with a 64KB base page size.
>> This is because the order of a 2MB huge page is different:
>>
>> On 64KB systems, the order is 5.
>>
>> On 4KB systems, it's 9.
>>
>> The test currently assumes a maximum huge page order of 9, which is only
>> valid for 4KB base page systems. On systems with 64KB pages, attempting
>> to split huge pages beyond their actual order (5) causes the test to fail.
>>
>> In this patch, we calculate the huge page order based on the system's base
>> page size. With this change, the tests now run successfully on both 64KB
>> and 4KB page size systems.
>>
>> Fixes: fa6c02315f745 ("mm: huge_memory: a new debugfs interface for splitting THP tests")
>> Reviewed-by: Dev Jain <dev.jain@arm.com>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>> Co-developed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
>> Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
>> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>> ---
>> .../selftests/mm/split_huge_page_test.c       | 23 ++++++++++++-------
>> 1 file changed, 15 insertions(+), 8 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
>> index 05de1fc0005b..718daceb5282 100644
>> --- a/tools/testing/selftests/mm/split_huge_page_test.c
>> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
>> @@ -36,6 +36,7 @@ uint64_t pmd_pagesize;
>>
>> #define PFN_MASK     ((1UL<<55)-1)
>> #define KPF_THP      (1UL<<22)
>> +#define GET_ORDER(nr_pages)    (31 - __builtin_clz(nr_pages))
>>
>> int is_backed_by_thp(char *vaddr, int pagemap_file, int kpageflags_file)
>> {
>> @@ -522,6 +523,9 @@ int main(int argc, char **argv)
>> 	const char *fs_loc;
>> 	bool created_tmp;
>> 	int offset;
>> +	unsigned int max_order;
>> +	unsigned int nr_pages;
>> +	unsigned int tests;
>>
>> 	ksft_print_header();
>>
>> @@ -533,35 +537,38 @@ int main(int argc, char **argv)
>> 	if (argc > 1)
>> 		optional_xfs_path = argv[1];
>>
>> -	ksft_set_plan(1+8+1+9+9+8*4+2);
>> -
>> 	pagesize = getpagesize();
>> 	pageshift = ffs(pagesize) - 1;
>> 	pmd_pagesize = read_pmd_pagesize();
>> 	if (!pmd_pagesize)
>> 		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
>>
>> +	nr_pages = pmd_pagesize / pagesize;
>> +	max_order = GET_ORDER(nr_pages);
> 
> There is a sz2ord() in cow.c and uffd-wp-mremap.c.
> 
> Maybe we can factor it into vm_util.h and use it here.

That sounds reasonable to me.

-- 
Cheers,

David / dhildenb


