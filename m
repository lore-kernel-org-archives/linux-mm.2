Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD00C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 14:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E785B8E0002; Fri,  1 Aug 2025 10:23:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4FD48E0001; Fri,  1 Aug 2025 10:23:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D660F8E0002; Fri,  1 Aug 2025 10:23:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C8D338E0001
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 10:23:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 710E0140234
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 14:23:45 +0000 (UTC)
X-FDA: 83728407210.16.A4E7F6E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id E565218000B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 14:23:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RSFnGPwq;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754058223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h7mKFgNhjQHVPpLADK17HpuzYY9CFufwiy/n3xns4nY=;
	b=LZLeupEDAbNYgYEqDdjLax3xOHRyFjvhv/GKIJ035h/4vSk7KMGISZ96ZYowCLLL4ZTDOG
	sr4OlRlXpz3dJstHkRMHkMtnUrRaMWdeIswqXFmw8a4lmHYom6g3Vk93RoLCSNGyIBo6Am
	CBZaKOU8o7qY8Ec6LMM5TNId5tXIeI4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754058223; a=rsa-sha256;
	cv=none;
	b=lkOuxFruGQIyUZBcdWr/jezZl/JRpsUQ7jAGEHkBgzCFVnvEUb/lR78Zj+jQIgz22YJLCQ
	wQITYmqh8RxPTVRlYTFW2Azv1GKuWSWRhDXW0xkN4dnGpsqFwzN5PcLcPCM6B2UACX6QMn
	LDlH6ZKxBQxKlxTlAs67B17FelrIItM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RSFnGPwq;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754058222;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=h7mKFgNhjQHVPpLADK17HpuzYY9CFufwiy/n3xns4nY=;
	b=RSFnGPwqOv5TU/VthZrjLYQ1dvB1kY7r6lJX278CO79xCq+ZPfb9XXJjAYtjcieaIvbXKi
	KahccNJK2d+Cpe0pP5A+wtWNmioapOSiOxzELrniKiNAtgKPP79+sy/HhzfMcSmBzqANyv
	BxRrTIpO+lhxqgfxOoLVFXzgJugFm2U=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-LR5NqvBnPIatEt8ebgAF3A-1; Fri, 01 Aug 2025 10:23:35 -0400
X-MC-Unique: LR5NqvBnPIatEt8ebgAF3A-1
X-Mimecast-MFC-AGG-ID: LR5NqvBnPIatEt8ebgAF3A_1754058214
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b7889c8d2bso748481f8f.3
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 07:23:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754058214; x=1754663014;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=h7mKFgNhjQHVPpLADK17HpuzYY9CFufwiy/n3xns4nY=;
        b=wPec9I2jPxeQ34BBF28q1Ag5YOqIJvG5BydtQodM7q0NyCdbsFiOBF6zuOfEpiFkrY
         5i31CZqqbZXS0JvqeG+T2TvP5x3T7H5u6hgmut2ytuZiXhKbmDL78U2e1sSIxvaz4uBo
         nlyvwXXkZbDCasVVLNS7BOp8edTte9A+660qOpOxWLnhAKGum9VafyP9fB2pS1oJwHxG
         9Uigd40+ZwFEoWFNgxacekZ3LFJJU3zpXm+mtL3m6MjJBZVRP6zUy2iRa4nxI63iIz3Y
         31/NRO80yjL/YtmyC0V18lWWhi378POEdUwiUm/TNl2k6EZYKX0dMjvZU8Meg/Fc806W
         JAgA==
X-Forwarded-Encrypted: i=1; AJvYcCVGrV5hwjuzvBM3iX6KIzmaR1z8l1KPQlNWlzmaRf+RPSdmdu4iU82nQ4Wt3Ts7GSP3Vp1wLGeZWg==@kvack.org
X-Gm-Message-State: AOJu0YzmtEBl2YMxg2NYCT9GWfFhTbIJmFs4bXPnYrlHQQOcvca7M7Sj
	Nbx8IekI9YIr/PQZMWwrIwBFcnypGKnEPnuVO8jzbhI5EPMVxBZB22me18YA93YyQj2Q7ZkBtIV
	tXluUSUvoSeKQkLz2TDjUpz/kmHz670Yp8veyqxeuv5s8ani5xDGf
X-Gm-Gg: ASbGnct8xtwGI3euLLGafsteEbJMcf6xYbUHAnRcu6EpDgxV2Oy7C40LYUYN5xMc1kK
	Ippl7FLzo19OynuvafqLMpxfxprjnANNMczoToh+G6RhcjZz5kKbcKnXDuyXB5cju/GnDVQjIkZ
	W7Eu2T9qscnbll6yf3NBZOnqLntVb/mGY7pFlY9uxWOauDLrUgwqAI3H4bNdeDu5dL2lLXRQNUQ
	SV0Ea9c/oe4O+melq4oG0HzXBKhUYH38aNt0KaLyOwvU7pQoRyOBQG9Lw2XeOAn0x955TRIWQIH
	RooERcHakVmmKZSFK53ey7wnunBxREbazmWGcB1ieiCW+JCSKcM2TM7EAVFOCg18hdFLVlX+tN9
	lz3iF4MrkZQUf5gJN+j6/mGnseG5LP7/ld7ti7PEIZjaEnkt52RTZ+fFHmolkycOn
X-Received: by 2002:a05:6000:2906:b0:3b7:8984:5134 with SMTP id ffacd0b85a97d-3b8d34458bamr2706368f8f.16.1754058214240;
        Fri, 01 Aug 2025 07:23:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF9ov4+m3bhMWt6XWUmjAi1j/30ofm7xshGyBWCHDYs1YtYTD1WrZVVUYTZQL6gcOxOSI1+uQ==
X-Received: by 2002:a05:6000:2906:b0:3b7:8984:5134 with SMTP id ffacd0b85a97d-3b8d34458bamr2706284f8f.16.1754058212333;
        Fri, 01 Aug 2025 07:23:32 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:7500:5f99:9633:990e:138? (p200300d82f2075005f999633990e0138.dip0.t-ipconnect.de. [2003:d8:2f20:7500:5f99:9633:990e:138])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458af8c5a87sm13192285e9.2.2025.08.01.07.23.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Aug 2025 07:23:31 -0700 (PDT)
Message-ID: <85a22428-24b5-4a85-9d75-bd2f742ab471@redhat.com>
Date: Fri, 1 Aug 2025 16:23:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/10] convert the majority of file systems to
 mmap_prepare
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Jason Gunthorpe <jgg@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Amir Goldstein <amir73il@gmail.com>, Kees Cook <kees@kernel.org>,
 Josef Bacik <josef@toxicpanda.com>, Matthew Wilcox <willy@infradead.org>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <cover.1750099179.git.lorenzo.stoakes@oracle.com>
 <20250801140057.GA245321@nvidia.com>
 <3cf76128-390a-4ef2-85a7-e3ee21ba04b5@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <3cf76128-390a-4ef2-85a7-e3ee21ba04b5@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WorkM4Cs5OysMaBHbqqQUn-00fhMXqW1N9om1hqxOyc_1754058214
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E565218000B
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: ut6ico8k4agweh7ofucpfwf5sn8iz1w8
X-HE-Tag: 1754058222-626311
X-HE-Meta: U2FsdGVkX1/xgVX3EH/jzhEtEyKBOX8zcRfHxzp/soUDpfsDkhaatACNvocYkt0UHIQZBzOsAVAh5WDrIFdFEA4YlMOSUdFsrU143y9n5UwG+vhY6s/exumCyzJTJeVkQWH0uKMn+M8zfU2me9EMDOm+zd4yk9pRy+DY6On14088Ay0X4cET2jfXqP0nuxSliFJbLlYv/vNemQQ0DLylNE2cjPyWU62Ji7zUcRf/YbHlOzKwFb329qTpeYIK4Fza9d93NpU7ll/2ItrOWxX3eEtW2AaP3CT1RCIGQUO3EMPmXs4OzzB5t5PyJK1syyobFyw0s+dDht1M3CMeL4pMbEwerWffSxJmZ62qtFRchp0zIpDJoCm359YGgACy2d0zNFw1Gm0CIszwPCTol2ujOOod9Cxjyw9qrHndKms7QGBpdd46VIME3/BQLaHbmSfC+1My7J/QV8JUYSfV29z5IiJbw59dxQFaF7X8/V1/M142nXcZVYK7wNytAqZDlC+YjDA8dXS7S90DUC+OPJHHfgg/m+y3EFeRawWYpebKGVoFJCbc2Oxsdo02ZF2hikaZ9jsNLYfM2oMXD+x95NPTc6lWAN7DyTtUk39NurYvpx5/DnKOA3pirYxDC0KBki+3O8FcuwaMYBaFZ4shbNg1Cw8oqTSPe6BE7mb98xZfUJYCoAGNS7yjrueLQ3trBhWvHw3nQ+vpiXvv0mq4t9NpW25WCdEczm2w8p1OV6LoI0DHZu2UuGabYhc2X8DHGaKVmbIjztP7aU9sI5CiKFFHcmk9PyQz7tqHoUnjEDTIejlaLvV5WTesMz8a8ZpYThiUXONVeUbD/2hYQsOhzesEEGelKW6l8yNcd24lF20XdtlMP2S1KEhF8sMULWkyGSC6AxhAkwedC9w0rKuXxSiFj6+J0tlqD5QMWeHUHx4DYpcp17UnwEyYkgWoP4RvrQt8c1VWygYJnVtY3TkA+HS
 btZxQTf4
 5Da+UlxESFsk939ipeX2dFTrKuHi5qIws4cSuGRihdRbAREdqK0nTCovVGZY8JA7CMMZ/c1kAAZopbVjezp1/XkL50Fd0s5ACg0lDOez6nbN6AH+Ly5XXB09JhwUsqoEmhcNKzyr7HkduQ2pcKcGKVr6KozI+dNsFHTSvGv0bLHsI3p2HBJYXq9ZdgX4Kg8rR11ssHbmkm4UBoRGNE0E29y5vS/2TNJ/XbDHh/ZA/y3pQ/orKWAt5N68qwxO96/0lxVLNb5JnlCPIoO1QSWrJYAqARYIFKseFykgxfVNkK4fkif0Fuex4dnCyKYSIxrNXAwLjlVZ5q3shxIyzWe6yRsjQWq8ldi8Mgb4o2qCkL2NRWXvUqUsft0fvpEwOBlRAzuqHJhzJp5ol9xXyMA/xjO9saA0wcfNjo9xgSMBzohBJ5Qxa0QXPmcwp8gEUTugIoH+w2mKWt2+SrWvEclDKEtNDoDBSOp4tBtvm7UABCbr8XIyusFy8/D7hoanfR/8jOigt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> I would like to suggest we add a vma->prepopulate() callback which is
>> where the remap_pfn should go. Once the VMA is finalized and fully
>> operational the vma_ops have the opportunity to prepopulate any PTEs.
> 
> I assume you mean vma->vm_ops->prepopulate ?
> 
> We also have to think about other places where we prepopulate also, for
> instance the perf mmap call now prepopulates (ahem that was me).
> 
> So I do like this as a generalisation.

Sounds interesting to me.

-- 
Cheers,

David / dhildenb


