Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B26CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 08:31:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51E2C8E0023; Mon, 18 Aug 2025 04:31:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CF8E8E001E; Mon, 18 Aug 2025 04:31:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 397038E0023; Mon, 18 Aug 2025 04:31:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 26DB78E001E
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 04:31:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D305C5B855
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:31:20 +0000 (UTC)
X-FDA: 83789208720.07.013B48D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7F68214000D
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:31:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MviD3leT;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755505878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IrBtZYA5Z28bn60ohedxv6GlFgI1zXS/Odi0JqkPxhE=;
	b=vAf5YL8Dd3QPYgh0+YSnPrr3cuBoPalNs5dyiJJVBDzqYRS3DMhgKq3rgZO+JBXoSG4djB
	Uq1JhQtwsUstwd3JhMURKxJHNNvp4/MF2uIPRfy57vsdiCQRywCAZwmmEWVxxcCQjP4KF7
	2ujvtHI+HUZCPNNPgQ5SnbTz6C4T4H4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MviD3leT;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755505878; a=rsa-sha256;
	cv=none;
	b=CM4thkpWzQ7H10YbDKzDp/MXAng5zdqWC5FG5emEeqX7vIOLJ0jjqaHom1dsQ4ffVq99k8
	TjEVidIv5y6PQGHKCau9gFv34tO75mNvWhX7OpnebZfBzO2C1Pkxt2ivjRug68glvXgXd3
	cIt+4zPtG3yFoBDNpzDekZ6i6sqO9TE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755505877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IrBtZYA5Z28bn60ohedxv6GlFgI1zXS/Odi0JqkPxhE=;
	b=MviD3leTV9mFV5GVUcRmCDtj7YbQ2Zrab1eIgTFQ598L7Ze1PxD6VmaTkpucex2lfQiRCn
	RwEbjSUhqGeJj7G052DGLh3E54EgbHMAZeEytCAcA0O6vlQihz0MyanHq1DhpP9Mdye2gr
	GG3ZCcTx3TSw9vmpL8rV1xF5FhAZCFc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-2-StmKRMOneSSxpIDvTI3w-1; Mon, 18 Aug 2025 04:31:16 -0400
X-MC-Unique: 2-StmKRMOneSSxpIDvTI3w-1
X-Mimecast-MFC-AGG-ID: 2-StmKRMOneSSxpIDvTI3w_1755505875
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a1b0098c0so22786875e9.0
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 01:31:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755505875; x=1756110675;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IrBtZYA5Z28bn60ohedxv6GlFgI1zXS/Odi0JqkPxhE=;
        b=MnEtyRnW3Y3UAE026qlWR5B04ajPYMM++ENV2gLMgpZ9OZB//ErK3r+gPMIXiXW6Pl
         UeRfhbas95RIgGVmfgKjknb+vbRaH1rQ8YEXDJww4ghH9YKcAwKJ8S0pyPMOVdtXoOo8
         bKl8Vnd1Gds+u4cgyRy9TS+bxbQHAAt+l89MyawPAXRsczs5KhbMoCFON/vTzWaqg/Ot
         XMhnDNqPRMHNd0KlGTs4CwsIdM3DCZOEGfvW2lpOMwzWPoiyvOZVoxlyGqed2pnRiOJD
         IHSnRZ9iUgafiMwQhGLhN80uytniecoYiB72RVD4LP0xyaZx97mMfCfIyBZ3o9L0kidm
         ridw==
X-Forwarded-Encrypted: i=1; AJvYcCVALr3jOJaGCUJYcO80VCqYFev1px047wvxw6IYqU/xMDULvFFrFDlj6IS6tuSZ/oW0dwA9yZmeRA==@kvack.org
X-Gm-Message-State: AOJu0YxUZkVpZUNzsaUeOeKiCfM7CH63BSLFj2p3FbRGB4az9fnbhWf7
	5UMjfe3TqLUAuaRxQ1sxBPBwv8juwsvJZLLFScvjWI2oLcZk1d1W5Qo1r4wYn7o0ruisLKrhWqb
	bq4KPtaC2Vy+It2sTbosdT/cKqRYsAT2hN9KFU0tJuAJCvmaIugXL
X-Gm-Gg: ASbGncv0CYxgKVUPvkoW8PaKLCHSSRZS0ZkA3fvg3N3sj+zV/tfVhZwYU3JTIlOfJfV
	hCFDWZZbDicoppKXDrWbvm67r0BEKmY+/TGqRWqTXubNyrJeghsQ1JouF2AmGLNq8ToHqXMbbCw
	/D7W18hmuhfLQIg9tLG6Izz6KTryjZmnRTIgrp8R+FGXW5sNwrbRDA/C/0OLAX3ndMe80FJmicn
	JgSFwvHnOKjtgqpOo9IrTozxAOJMm38JB85IA26q/DHr6E4xJsPFfjpNdx5GYz4CpesLTxjnoJa
	0nprNxSYKcsUa1aA9tAuaiImaCI+NBxoHS8HZHHf3lVzAZ+Pcz32nnsjFngMuzS19aUsWwCohgO
	u+pLUEaR4wfIh81roROWBTYDyoHn8TgWijMog4LcBDpcHT5fYZtsu7gffXiEm7EAs
X-Received: by 2002:a05:600c:a43:b0:459:a1c7:99ad with SMTP id 5b1f17b1804b1-45a21839edbmr81792915e9.22.1755505875205;
        Mon, 18 Aug 2025 01:31:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFUJ0JHZagWj9XCwRsqfc1oqsDUPxyV3bXjzLuhESOGbYeY8B2myjjJBUZ0Oh+caqJMAY5Uow==
X-Received: by 2002:a05:600c:a43:b0:459:a1c7:99ad with SMTP id 5b1f17b1804b1-45a21839edbmr81792535e9.22.1755505874765;
        Mon, 18 Aug 2025 01:31:14 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f22:600:53c7:df43:7dc3:ae39? (p200300d82f22060053c7df437dc3ae39.dip0.t-ipconnect.de. [2003:d8:2f22:600:53c7:df43:7dc3:ae39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb64a40c3asm12015938f8f.14.2025.08.18.01.31.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 01:31:14 -0700 (PDT)
Message-ID: <63082884-1fe2-4740-8e6a-e1d06aa5e239@redhat.com>
Date: Mon, 18 Aug 2025 10:31:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/numa: Rename memory_add_physaddr_to_nid to
 memory_get_phys_to_nid
To: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, "Rafael J. Wysocki"
 <rafael@kernel.org>, Len Brown <lenb@kernel.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Danilo Krummrich <dakr@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Alison Schofield <alison.schofield@intel.com>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Pankaj Gupta
 <pankaj.gupta.linux@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-acpi@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-mm@kvack.org, linux-cxl@vger.kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 xen-devel@lists.xenproject.org
References: <20250818-numa_memblks-v1-1-9eb29ade560a@oss.qualcomm.com>
 <d7cdb65d-c241-478c-aa01-bc1a5f188e4f@redhat.com>
 <CALzOmR0C8BFY+-u-_aprVeAhq4uPOQa+f2L5m+yZH+=XZ2cv_w@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CALzOmR0C8BFY+-u-_aprVeAhq4uPOQa+f2L5m+yZH+=XZ2cv_w@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Hq3eFaoTP5uNsHXuVAJ5yo1IKcL_dMpBhu394EIScwY_1755505875
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oxs3qntmpsordwsipfm97teezceuoead
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F68214000D
X-Rspamd-Server: rspam05
X-HE-Tag: 1755505878-587975
X-HE-Meta: U2FsdGVkX1/pqaZrc5EORg7biTUjmH2ndJ7M+4/dzFcAI9m+iPNcLp8S6uw1qPleyKyt8QjnECCfWpRzSIJFFI0QFTNWH3sc96CuVE1npOD9NkIn+dUAcmzYnmlGSWl3EOP0tcxLqllrr8O6VMQKTXLkeJjvvZ9vVzzRaE67po1LD6sq61ocQSXGXm9KHQs28/Unpdi03radZLN81TPoHvS32ut4B/+ucXDsi+pHQxJtm7X54/yf0vGxyKbpyVyBR5BuF8Ye6DRr7CakhzON01BB7+WrWV2XPzrz8Lo/Ga58IHWoEiRaS01EdY2A8wTf/Ush3skhmg6eDicQMGyGCwiCXaeTkjSfOGcqds3vQ7+3d0+M/QSCeVcoCKbj/bhWzoOWBHxiyBDr5e+AjihwSXBOlK8bBvwB5ykI59wuV6fx7HO5K5IdivSlL8m5MOuG2VsAVPz+Fjz6zOoUJkE4/Q0XkeE02ymd8XWMNQ4B3JId1ACXfnpqqj3kd2LAQtc5FQvLSmb/t79yth1P7rKyEblzRfC0xj6vKzJEuX17++Ob8LD32WCaSlwC+avZhyjPB9hhFL3hlMSv//Ahaie9zxQ2q4botjCA7IhCifthmjTV0I4hOgw5jhx55GL7cIHQbmjccp0zAAuT546Yjfufk3TKCiYqd0KUjtv3pqo//0pA9H4VJ1NgbOS0Abr8abQoAPZRitqu5liS3xDVgI/6YjjcBuTnZJIeu03KRvqiNgzD6W+ZNoYqEhrdkWSHQGU4EEGawKJ6VoCSXROYXHZzxlpmD9eB2+MyjzxLVfEvFcupXKTe/cqNdcqN+9GyYFp6sXbFTLThY20hzyg6raSlqNMHZtiZ3kXKrr75l5xP79CS61XWNi6U/PgA2UkyST7jEKx803yaTme9kKOK2yCMcpDVC/nt/8cswbk7XuD1G2V1nTRduz63DIqZMV5O0ZBAev/YCUVMwND0sAYd0zk
 aBEXnVVC
 lMH81/lRidMB4rLAHy7fEWJOnE7RDKdLKEYZ9yMq57YDgvhxS2zscVdl7nVzykdWiMwmnePThcEfxu7CNe/U9DJi3bH0KaX1j9OTorW8iRegOmi172HiiUDVUH7pn1T4v6ju1cLIKNaFaMQspQAjFOj0w62SuHYrxqZHyBLA1pmplfaq5UOpi7rKcuZ+qHbT1f5ZxKdlexHNXGJVd5ny3S+QDGBkUxdW3BgakcD3+7R7oWfrffGUaGf3ZbGXsvlgmj53juGuo+Z5Kx7YW9zgVr+MsPCdVkeWkeeP1xm+yAcHIOa8qulwFmyPNrL4fs6LgAMA9ox1hYUNFLkM9st1wONhMU2wag04cZoHzeC55f1iRYi2id6PHJIDlZXfUc3/5hq7MEesrjHsKYgTmGNC6dG4KkifTFU+6FrX6xvuoiPMJpDwk+7VlVpjVFO0ejwIt0uj4bnvDyQoWaPgGpeDUgfumREkTw5dQ8fLe9b3xV4F9KnhLYOYApC37Nm44BvPQzak5p3gWCtryP42v2LvGRFQV4DLt7xfhuU13DGTMqw205SOCD0oU8+n0eMkVSeF/g+6UT/Dz81M6pqXi5EXkBxjq625Z+FP0mQMEvObIW8E6VPvG2qa8nmGHKB+WUKNVpoXbK98XDuUesz6nnoa2O2dCO6xI9O+BX8rsuD6YXHD5tJ7hQkXnL7b/jyhRmLGMdbu7TIyA/g4nt38=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.08.25 10:27, Pratyush Brahma wrote:
> On Mon, Aug 18, 2025 at 12:29 PM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 18.08.25 08:41, pratyush.brahma@oss.qualcomm.com wrote:
>>> From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
>>>
>>> The function `memory_add_physaddr_to_nid` seems a misnomer.
>>> It does not to "add" a physical address to a NID mapping,
>>> but rather it gets the NID associated with a given physical address.
>>
>> You probably misunderstood what the function is used for: memory hotplug
>> aka "memory_add".
> Thanks for your feedback. I get the part about memory hotplug here but
> using memory_add still seems a little odd as it doesn't truly reflect
> what this api is doing.
> However, I agree that my current suggestion
> may not be the perfect choice for the name, so I'm open to suggestions.
> 
> Perhaps, something like "memory_add_get_nid_by_phys" may work here?

I don't think this name is really any better and worth the churn :(

-- 
Cheers

David / dhildenb


