Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05DDAC87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 16:28:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A3216B027B; Thu, 24 Jul 2025 12:28:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9542F6B027C; Thu, 24 Jul 2025 12:28:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 843706B027D; Thu, 24 Jul 2025 12:28:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 723BF6B027B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 12:28:07 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 25F3316047E
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:28:07 +0000 (UTC)
X-FDA: 83699690214.26.8AACECC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id D03D620015
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:28:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fEE0PcxM;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753374484; a=rsa-sha256;
	cv=none;
	b=zMm1qsqSJ07C0zE8Ge1M2QmKDabO8wKv9jWRFNdQNEiPBO60DAjfliy6fSUHg8xun4oZjK
	eotS4MXHgawfoHDyCbYOSBwZF+OMuITAMjkxTjLwAbuYZhd5VLBWTI6aRO3eNwHOmZkZm/
	hMn6RHR3RL5ppCakxXPhr590J74YtUA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fEE0PcxM;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753374484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=umrR+nMEWzDn4JIrv5L+WQgA1kaMox1fPGyfLKPL2X8=;
	b=0U88O3aFv1KOdtrv0dzMl9bMpAsGYX9Aykj2G0Wml46xqx4SXNC4sIzwqY6t9VBMyHoW54
	CxWF/E0PwOMQ2wyXzbUHboDAtGI74Tz0R/mBq8OdQIQElXyAFfyTs8XIIeMdzF96BlrH4E
	YsdqHyVxZNOlmcYmnJcSsec7X+4BYmk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753374484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=umrR+nMEWzDn4JIrv5L+WQgA1kaMox1fPGyfLKPL2X8=;
	b=fEE0PcxMMA8imLR5Z8RO4BYu1iXLaVTaGxJnaF36ELOpL0hhDDVn5alOHXt9TdT89xSQRE
	vSMbn9bMrl84ObLbimDLkLB1xkutsV7+84WZLTYl1lSxuWabVxpnfVvq7noeMVQtiExrB9
	JDaeMFgKU/XsrH+ljL24i63Bh6IlhJc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-443-Av0nQqY2NLqslvCBTijGfA-1; Thu, 24 Jul 2025 12:28:01 -0400
X-MC-Unique: Av0nQqY2NLqslvCBTijGfA-1
X-Mimecast-MFC-AGG-ID: Av0nQqY2NLqslvCBTijGfA_1753374480
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-451d7de4ae3so7394855e9.2
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:28:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753374480; x=1753979280;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=umrR+nMEWzDn4JIrv5L+WQgA1kaMox1fPGyfLKPL2X8=;
        b=LI994GnHJtJHWVOyrDL8c4WeZqU0qUOR3X0rzXnNj82muQ6l76a695a9DNqU+Ktjj4
         ABqNs1u0yE4vxVpKbwxdGhpvVK8j6m0Ezho2AgBGHlhZCrnf6SY9OOYR+oEZNKao95/Z
         CV0tE72tAr0oasocoPVFRttz2Flt9PXpMAYCfpYT7tI0UxJCPAJnjkioZ/Wqg/wjKnz0
         utmhzFiyec4W4Eu8AKHtFtiqT/bTbUoj8+KD1Kh8vfNRp8bJDDGDbtOxH1KVHu80utwu
         fa0Pi7tbYGauG3RJmW6doTCZpD3F0eetHBIY2CJbQtWMc3Gc4zZRxzkCJtY7knoasCdV
         yt1g==
X-Gm-Message-State: AOJu0YxxmO7mCY4RJYbaXDMqG4nYT0HVUlYsxxhn89Owb9ifC1i8V8xm
	8lTI7FCFSriw36XfKr1HTNGF+jJFMtA66TYlVlqHt1Lx5F7cj2heITLiorK+9+ZZIS/yxiBtnwG
	QRpfSobw0WRHBe5dg0tQSzFkMMwCmhhVSZMbIrzgyjzon2zTOCMpQ
X-Gm-Gg: ASbGnctN2xFDmMCYAHiU5cdnrPnj10CgWZG//dls2Xq15CTiHip23Oqd6m4O8cbXEm1
	SjWw6hCVXW8tKSxOng+gxwCtE+JyjwwIBmZpSkTw3Z9404g5qtfnm7QYWZy1DnR9CVTs9vaohnP
	6XFj6kUIK6fvqzHXD2QAvO4/J3xN75BWmps+VUoxXQYJmVYDtkTu8hrbpifdXP1ZF0sFLDLEQfq
	Hhzs7mluHx3hBfcr4pctpT6D5Lo3vND/Xqt3GKEDvopXupO+1OC6EO/nnsXBYB5Bj/h90gJGjFP
	xRuQXAwfQWN0WIG/lC7ODT4QPU906pVJTEOVD9eIkOcXFee+dLO8vN6KUfpp5Fy7/Y/5dHHpKyr
	n+SbrYFN3e27r4lXMF5ISzRjNi89QbnQTVX0vwUL4Y7nu/TI3xgV8OAqU1rPKXFS5V08=
X-Received: by 2002:a05:600c:1d1d:b0:456:1b6f:c888 with SMTP id 5b1f17b1804b1-4586b8f7675mr53568775e9.23.1753374480128;
        Thu, 24 Jul 2025 09:28:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG4UPJfTE7n+QLrDngDWg06GF6l9Gpu5jd6koUcdS6ReFgiLUqlRRBoxyu5d9Oy8IEk0egW+Q==
X-Received: by 2002:a05:600c:1d1d:b0:456:1b6f:c888 with SMTP id 5b1f17b1804b1-4586b8f7675mr53568545e9.23.1753374479669;
        Thu, 24 Jul 2025 09:27:59 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f01:5500:ba83:3fd7:6836:62f6? (p200300d82f015500ba833fd7683662f6.dip0.t-ipconnect.de. [2003:d8:2f01:5500:ba83:3fd7:6836:62f6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45870553c78sm25219875e9.15.2025.07.24.09.27.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 09:27:59 -0700 (PDT)
Message-ID: <6771d9f1-c0dc-4ca4-99f2-1fffecb99938@redhat.com>
Date: Thu, 24 Jul 2025 18:27:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] fs/proc/task_mmu: hold PTL in
 pagemap_hugetlb_range and gather_hugetlb_stats
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
 dev.jain@arm.com, catalin.marinas@arm.com, lorenzo.stoakes@oracle.com,
 thiago.bauermann@linaro.org, superman.xpt@gmail.com,
 christophe.leroy@csgroup.eu, brahmajit.xyz@gmail.com, andrii@kernel.org,
 avagin@gmail.com, baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 hughd@google.com, rientjes@google.com, mhocko@suse.com, joern@logfs.org
Cc: linux-mm@kvack.org, wangkefeng.wang@huawei.com
References: <20250724090958.455887-1-tujinjiang@huawei.com>
 <20250724090958.455887-3-tujinjiang@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250724090958.455887-3-tujinjiang@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xJ6Y3cKHTmfmcUocShrZaIMR3N123WB8Y5ohf9VFyx8_1753374480
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nz5bkdrxms1fi6pd5iw78trtmkft94jj
X-Rspam-User: 
X-Rspamd-Queue-Id: D03D620015
X-Rspamd-Server: rspam02
X-HE-Tag: 1753374484-998624
X-HE-Meta: U2FsdGVkX1/bKfDoHHTKH5KMZlScUP4J0uWnrMI3HJXT/PEBEjX7H/BQDFvVCCRnXNAHaan9DdkPfGePKuYx9h0FXh45fXhnK6PFtqz5A1CoUSawEMQZ49EJDA5RcqWAUKc9cB/MMg1HU2j3K73EE3AwdJnz1mo6kE26cLwzUO6HBuxQIL3Pi2it8R6kDdgygLvVasjSSjBCW4S6HT0expg62hlgW50hy3IX8U7Qwel0VQxwZ0SRGfVRi59wUmYNeEGhS/7JkMQnM33BchYcdNZDOgY9VMzJfc3wshCOjykTk7MwVQTHdLgAuauQOMv0jOCyCkfgE6udzc90vu2SjV19BwHrfvSeSBVjDV52Lnv+7EVuI9TyjzudUQnrS9OZIJBKEIfH7YVyCNNu9hVI7ZzHU6nmOPPGeTkCw9h/D1ipRIMqz7zUAIkFKCfk+aywfkEKTAr6kd6NOcF/2D5bXf1Co9k3/0qhVBgrDkj9qY+PYNMDrg0Wqsk/8p2vWukII5pvwTdh3NMUsI6ov6WIWatCeNuoyzJQZPxe5GK0ipZeJWT2sarXQ4GoxZCC7+ju4f203a+6VZoRqwtMwufjzfxjMaFI/03VjwbTo5uEIzlQU8jurplepJBzh39xg5+QLUc4jD0509SucgX+q01/L/1GqQq2vN14VBZeJ1pdWV8VAvGJJwZAmLy3CB+OwVBuTp8nqPm+0E5YaTYklQTAlvIQ7R26AziPi0gsUuWwGdBicnlLsuepW4IX2tIAqxC8XbxeI0BrhJbp1Wk/v13OB5fDQcnEC4uZTY7IiTQPFJo2peVrlkYcctnJc52HS3P9kftHRZZL5xR3246/qDBDN54gIPRWB1oSb9KTBe9wKSpOGWJnN5pcgxqdZET0ICIs0L/ilE/29FxASS8sU+DP8c8BKNH7LKvuQ/YORxY9j+nIXnU1akmBvKf4Y271AII44bBmrPp5zCeoKhP8s6t
 gbku4IEl
 dNhpwEQ2e38Ka/QzfduETIb/coePNgayLqsTRn15bZ06Lubaa25XAarJX74BV/4B725i1gxixYEx6YSfLYioZWEH769a01Z5W+jb8ma0HrgAihKXaBSnwLFo9DjVriEalMEroAytLz7ISKA4E+bkZifR3rVnmOxP04QjoEsx36g7SrXNsIviYPjv4QLMVHhm91tf1qTLWqtTJL9C+MuiNoom38Lbrc/U3kOR9xWzYRoGYOe3VXpqKpiJBtLrW8YEEG2wpPMPotkrjIK4QT7eYIYKDIPa0Ft7R4y6dAssp02qhv1brduzhvtM4phxGqXhqd5/yICEb85JK+8g5bjAy+vThyQtWorDw5T78dVxHG1nAsi07nKyrHXLDRn/gfTkZf+U8sAPJD2708eiZecbVCzdn1K//ZhYz96Mw8XzhaOb6H0oXcAH0WulP2lUSG2E3irwyyn3767vj9DsHZp5mhd52nS7jz2TqCtA4SJbBGhZ1S3hibpxrrNIXKBp7pUArLYvjBgBkHsdfqPmKAZsJffdJsge9i2HkJFoZ8GQcR7rSJNz07CDSykoDiytOJLtWxUth11vIvoK3QQA+B9o6RgmY3/9xkbhY/7wHyWHAgD4CLd+ndMVfoiqjCXgQG9l+UxGCLMkLvPnevKk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.07.25 11:09, Jinjiang Tu wrote:
> Hold PTL in pagemap_hugetlb_range() and gather_hugetlb_stats() to avoid
> operating on stale page, as pagemap_pmd_range() and gather_pte_stats() have
> done.
> 
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


