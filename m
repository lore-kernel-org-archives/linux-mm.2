Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4925BCCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 14:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9039F8E0013; Mon, 20 Oct 2025 10:18:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B2FE8E0002; Mon, 20 Oct 2025 10:18:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77BA98E0013; Mon, 20 Oct 2025 10:18:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 658378E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:18:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1FE601A01A1
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:18:36 +0000 (UTC)
X-FDA: 84018698232.14.0A4C243
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9D84B1C0015
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:18:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X0VyKf3r;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760969913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CbmQBy23LCiuOfKHlXWD6EvZKXrnsYz2+mUVkRTJKTc=;
	b=ijfFWfE918YzP9NBH8WwNwMXT1DbC6vGYSRdvXFR5sc6VPFOOc921Wb+iaxpTMQeU+gUJ1
	OfH7qsxUxndweWQku7a0HB7IKIPYCceJQ3Zn8eEDTdmeuITBbamun8ZhUFaSRGuKS55uR8
	D0CNtagnL6lmnnkzzGtXB0FEP3jHRVQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X0VyKf3r;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760969913; a=rsa-sha256;
	cv=none;
	b=c64uWDo3dFDfduv4UvnB7QZNj5aQMYWFu5IZhuzMl0RlyuDuOsa7BM6ReNeWAHx2/7h3T9
	RDcsF6WlisN8GC/aSSXRaPpulvFnDGXwgGQDiKd2WTXNBzP1Nes4g3nuySmzjRLeEDET8Z
	KBAJ1ZpvFwr4l4SoW3qSGFieoDwoMrk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760969913;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CbmQBy23LCiuOfKHlXWD6EvZKXrnsYz2+mUVkRTJKTc=;
	b=X0VyKf3rRg2VG8vd9aEnEbCDy75e3Z9nxHMQ8pyVkRT3oY6yfWOqTaALdSjr/QeMMOxSI/
	soESww9Dgr8GjnN6oXd78rIz3GHMt4z7puN8myesxLkIuFIWGKBBdQKRU6HJtS+5iusZ3L
	RmrSc/MHRvsnWQY2wsr3rwL5D+/NDN0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-LnEeTraJPDi2WmjcPFDTYg-1; Mon, 20 Oct 2025 10:18:31 -0400
X-MC-Unique: LnEeTraJPDi2WmjcPFDTYg-1
X-Mimecast-MFC-AGG-ID: LnEeTraJPDi2WmjcPFDTYg_1760969910
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e47d14dceso26125615e9.2
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 07:18:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760969910; x=1761574710;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CbmQBy23LCiuOfKHlXWD6EvZKXrnsYz2+mUVkRTJKTc=;
        b=ZJof6+AfnFxVMJcBq6K9kiU68Lsl4KXJ3mV3hbUwLeJXFGHRu8xjNB03iPOMEkMe4U
         jmO8bc+gSPbcRsyx9+wbZN1A7kWkHzqGgby4rgCi9oUeQHaOfbUa/Mf5VucByZN5oM5z
         Ukah74GaJuauywGvp1i7QHd18Bzjw88w+jd5LSrxP2MWIMQeGhCewRmFyIhCZiaqRvnO
         MyHiSJ65/EZu4FawkgUtiG9bAoSvCcpbAvdv5bU46cR6uvK7aPVcXgFIHT4BTbfs7cLZ
         tOsv49BLtKUBDT0WoJ65+FAfl0LfgkNlaN1VtgkhpZPrcaph6BFMQI/qDbfxXxnHZ/+8
         bhUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXVxl9AMQWAamLj9Tl/ZkqdbScLHMrXc3dWpGRmWOx2ZRiPuvyYfq7id0tKeR57Wod6nrOjmYDyA==@kvack.org
X-Gm-Message-State: AOJu0Yw+WYkHG1YON2KTlQ5sNXSpEu1V8yfwtRTbq+ycIP9vcGn5ytC7
	MoSPHDycoUGCAtQOpvCjs7qaUqyKrhJnMUaapTkQCXGM91Hw2EMkZf1CmnpCFd3UPls9jUy+KdO
	MzFW60dErIg0g1K3yLaUtxo0JzKUOcqukM7a38IurWesTErbM2fES
X-Gm-Gg: ASbGncvAaXahERhUc2gAAkphcbpvoflBxmSfjTexT9HYcpEztfQ+PjwMFPtEK6+nDgi
	FOnOzu4MSAxXataRb3ZKFZ4qerCCWmNKRcit3TyjCfD7/dBx+wUg0oQG6GB7gFkINC1FNv7INkR
	Su0c4IlX3qPcdsq0BIBlcMsghlDk8KzYPf0Jl0TmV4OSJ1YBxeW4VufiXpDR7IqMF+2z8bIFwnQ
	hykrlhnMKUpE8X6lulCZajRx+c/AS/1xPVlevs9J/wweM6skbzNGOI14V+3EHGfcGCBq9cHzSoL
	ORr/vbge15PXtv/OUVUiyaznNejZqJV0Ail6d6LgGWL3jwuXVAL516MOn7Wxz+5p6PoN/qKEXIR
	5E2LWdiWDy/XfSV5AnfUuqWO7ys9Sxc6E9wOqINa/KbFPEr+smrrfiToqFtaBc0wWoxYzkZChQW
	ZlEvUbdW+BeHkhM11pV9Zt/a8K5Lk=
X-Received: by 2002:a05:600c:548c:b0:468:9e79:bee0 with SMTP id 5b1f17b1804b1-471177bc126mr92534135e9.0.1760969910142;
        Mon, 20 Oct 2025 07:18:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGsUGz0BXOz2SLK8Dd2l9Tdy62O6DxEOlun4H0tXQ0zb/7yzsBhRuSpLJ8u49cmf7DLc1dFkw==
X-Received: by 2002:a05:600c:548c:b0:468:9e79:bee0 with SMTP id 5b1f17b1804b1-471177bc126mr92533795e9.0.1760969909687;
        Mon, 20 Oct 2025 07:18:29 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144b5c91sm232102995e9.11.2025.10.20.07.18.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 07:18:29 -0700 (PDT)
Message-ID: <5dac6df9-2d47-4322-89eb-65a88d237c35@redhat.com>
Date: Mon, 20 Oct 2025 16:18:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] mm: Introduce vm_uffd_ops API
To: Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Nikita Kalyazin <kalyazin@amazon.com>, Vlastimil Babka <vbabka@suse.cz>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 James Houghton <jthoughton@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Hugh Dickins
 <hughd@google.com>, Michal Hocko <mhocko@suse.com>,
 Ujwal Kundur <ujwal.kundur@gmail.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Oscar Salvador <osalvador@suse.de>, Suren Baghdasaryan <surenb@google.com>,
 Andrea Arcangeli <aarcange@redhat.com>
References: <20251014231501.2301398-1-peterx@redhat.com>
 <20251014231501.2301398-2-peterx@redhat.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251014231501.2301398-2-peterx@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xEaS2mgPNT6PwNWqj0-w2LBqo1ROPAQZYmgauhFAZlQ_1760969910
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: d4audbgp9f5ymxa57jdxawrytkdrbkdr
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9D84B1C0015
X-HE-Tag: 1760969913-856733
X-HE-Meta: U2FsdGVkX19ugk1e29waH5lQJS844V1HLaWY7WMhQXJzVWxGFw7JFjUYx6yy+9sQ4bGn62+5TR+rCQm3njHsAzl6kP7kIilXiFSiGBEqqZFZ8VU/YxD/rOCkm0drx8vt8WSYJacm9PCdz4gfwhDt8qWD3Sszv6zwJ/fP8XH7FZl4AgEgSXlX7NC7jIb+ZJVeMQkCLIGqS/iiXdaXQefYmDkuQngE170KpbQuJ0QU6CeqrmzH3Q/zscbqOfZqjVlM2OVMHMlBVlOfhIIwYpRetAtAt1Qx1JDkg3vEpNYwN7TiWB4fQ8LqpCi0DHegnSsVValpgS8xqVAHi4ja0lNfadw0GNVDYP+n23doPV8Lat+mE+L1gfnRZ1qxqjVVZJdl57C9e4ZrDofNkJJehI407ayxZL3T6XccefpNQ2H3+jk9DE5qqX1vjHPMzW9EWHXmfklYJ/VwoqqRmtDUNNd1AhPFpAkdxk0IUalvpQPCn+HU90a6poIY/zSwYrjGCYEixmJIKHcWIsEKp/NaJkQHBkVd4R/xOfdRMjC7HtO+9auYmDp+zq/L6DppCpPep5zcPuUr7MwPzCroZp7MKAUhenSqTolIS3OIUDnubOL9GIWgh+gRYWSZKnEJBfBL92Egjr/cTmBshd7eaMIAxRUsf9XnuE1bytaL2Nh8KXFSe9fyqrxsZZkNzVXtqv6VtSeSsNRRdCZs+15rvSQ+LbuKWwJyVMwDM6D8Ha1t0czeevntYSF2OeMLVhYY82qGpJJIbd1Cu9cTCs6mpewxk2I1jQ7fDsh//BInCgEOBXmJAqcjSns9L2qf+4L/f5epLBGnf/xT24hwQIBuG6XbZUsE72VYSdr3ccu3F1VaF4V1OH0oPuLchb+j/9CvyuT1WdhuDszX37ficysrTFTK00bMGICEXmNxbYFjw4gFr2RbHWKenryYWA8je/00HC2DIctHBJgDT0hGUQR0osR+6xr
 g/WvQuIi
 qKnvosGgdFg/l7EsR+sGyLpDZXblKcGhhExknNQ/LEHcNKt6k4Zue/DG32hDbXnpOa/zF6FGh4agxHWdLX4naQzWJEP5iC1q+e9Ogf6zWg8nfqfoUS/TGJkxBvYXNLWhLDmhy+aiMDN6VhoWIcp6wLePQLawNCoJJqju2n6WSZE2mM5bZ6S4TCXkWfeGBQs9eNoKdD/k505pV/INguNeHJ08fkCYrJX2avh/ZchL46fh69jMDw+b7Yz2Z95hKqK54xwzyn2ZCC5RJM2Nw0XHvFqLn1ofQ0t1GfBhuK7U9ohkBfXhiDKtZ2Q6DWEiCurQ+cqhXHkmZ6S1RYC+aSdzjI+d+olX0Zdfcit2FcvFBK0SaFyTJ6RXjnHfrBVXljbilAJZfL+osiFyQX9Zi3ssmIVwwL4N7QYGOxp5ArlvVVqi2KRRt27GiiiJgafXf8wTNwXzO0+skGCgR7uHxZfegUQ63NFoJblQgL/pmWnZGMQhEKo/56DyjXaQfE/SOAqhAEYGWTG07bkvipruWhdFxZNgftj59BuvhesOcMdYHT+7+XCdcms6xZi/Jqg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.10.25 01:14, Peter Xu wrote:
> Currently, most of the userfaultfd features are implemented directly in the
> core mm.  It will invoke VMA specific functions whenever necessary.  So far
> it is fine because it almost only interacts with shmem and hugetlbfs.
> 
> Introduce a generic userfaultfd API extension for vm_operations_struct,
> so that any code that implements vm_operations_struct (including kernel
> modules that can be compiled separately from the kernel core) can support
> userfaults without modifying the core files.
> 
> With this API applied, if a module wants to support userfaultfd, the
> module should only need to properly define vm_uffd_ops and hook it to
> vm_operations_struct, instead of changing anything in core mm.
> 
> This API will not work for anonymous memory. Handling of userfault
> operations for anonymous memory remains unchanged in core mm.
> 
> Due to a security concern while reviewing older versions of this series
> [1], uffd_copy() will be temprorarily removed.  IOW, MISSING-capable memory
> types can only be hard-coded and implemented in mm/.  It would also affect
> UFFDIO_COPY and UFFDIO_ZEROPAGE.  Other functions should still be able to
> be provided from vm_uffd_ops.
> 
> Introduces the API only so that existing userfaultfd users can be moved
> over without breaking them.
> 
> [1] https://lore.kernel.org/all/20250627154655.2085903-1-peterx@redhat.com/
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


