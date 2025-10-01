Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14A43CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 08:31:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 527C88E0005; Wed,  1 Oct 2025 04:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D8D88E0002; Wed,  1 Oct 2025 04:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C8028E0005; Wed,  1 Oct 2025 04:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2CAA08E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 04:31:16 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ADF5B140926
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 08:31:15 +0000 (UTC)
X-FDA: 83948875710.07.F68CA3E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4951314000B
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 08:31:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Q19+oSU/";
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759307473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fbIlFATZ6UVCcGy9lyO07KqDsSW2SUYrIm+1237ezXk=;
	b=ttiDAqxWICHrBIbxIhwE1ESBperDXYTE2QR9Ficub8Q9QjEUS3ePe5SVcLT44bAegB3H0p
	a6WrVZ/nxBy0abGkW20z1YEGPGyGvvRhZIKHGrRMyir2qQQJPE/MHKYGjnBwT12Zp1xdZA
	8RLS8riC+b+VhZmk2tW5yJmcA4dn7iE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Q19+oSU/";
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759307473; a=rsa-sha256;
	cv=none;
	b=PsQWMrL52kgmDUHlt6xpTUlO59oBAA6nC50+eHyxba1rztDlt19aYjTjNIWbEaY4I2iE8A
	hHB2VQRzTxWieiLiqqb3WSHpEJo6mb7T7QDVcIj4dnJ7IFI8dN0R8OKpS4jC8QSRnzs2pk
	3QkjNqe3e4R/wgxssPPd3OyeFwE2wGA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759307472;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fbIlFATZ6UVCcGy9lyO07KqDsSW2SUYrIm+1237ezXk=;
	b=Q19+oSU/6geY5vkxtJ57ICenJi9CxkGdS79zeex3bpXFKR1j96WRYndmk27kVYyeZnTjjp
	rXgW19qseMf6y8/FmH08ICL8T/ePIYYNToQs5T2k7k9bRW+pcnS77I7bHa8PjEjDVvYUX/
	7qhlUtjk7132r2P+/8h5yOT8eRCSqVE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-WJq8f2qbPPefENEkfC3Yww-1; Wed, 01 Oct 2025 04:31:11 -0400
X-MC-Unique: WJq8f2qbPPefENEkfC3Yww-1
X-Mimecast-MFC-AGG-ID: WJq8f2qbPPefENEkfC3Yww_1759307470
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3f93db57449so3850732f8f.2
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 01:31:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759307470; x=1759912270;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fbIlFATZ6UVCcGy9lyO07KqDsSW2SUYrIm+1237ezXk=;
        b=jlJzUXKx29hB91v2LelRF4lcesPN4novDQLn7ir/B3i6M1uqDizb8jTkKLB35Do36Y
         4IucMGX+EIkj3RUSd1jFrK2kVr0vCCtNmbyQEZnegDg6MV8U/K9IlfbCK+jpW4LP5pLI
         AAXpCBR2yTYlgZCwcxRR3hza8lGYWMf9DX4bD4s7JZsiR+yWAUESN2yA8mAowTtu2aIq
         ouA0FAsvR2nUpoCjTssRQq43cBgoSygJvtdqkUnCKP6lSl2meEP9Mb6NMW+bi5QFltt/
         ZQ4fxjiN+hHYfybXjVp331fpABhohpV+pDyC6pjtu/o84vxofld12Yceuw0rkTdoI2ib
         K8CA==
X-Forwarded-Encrypted: i=1; AJvYcCVIkzR+fo0eHZERq5HLBNgYFMIIwvvQA/em/WWp/o8Vih0+jl+49tzOLz4fGdUhPn1NiXqFaCxhJg==@kvack.org
X-Gm-Message-State: AOJu0YwEmqzRDCKXIuP/VeaaKrqHmj0tX2jTt32ft94kJoAqLH2iTw6+
	pfINT52sldQzdHIONaucdpO9rFGgb1xFj/JR/0aZynUoutsNIlRqPtph92qzD686K9AqV06q4Yt
	EZpvfgwlSA1Mg5qelKMCYhLH9ZKhpMGScxWAFREumc52fGgpNp9lM
X-Gm-Gg: ASbGnctO4WxrAxGLkjFjzA3RBYBtkXVNHSehuV8IDUVVr9tIv5AyvBI4A6l2dDtaccZ
	PbtnRDTYM2JkKtCnK03GtOOgPBGsjSqDCZaJbzPYzdtwioJ3gMZzzqjnoYtLXIrh84f55hDUseP
	78j/sftXuP02IT/WOG4hpy7CP306qYXuJ2SdCybrbr/I9CAbnRkLQtJmfydv5yZngUNg3kWfmGF
	TDktCHqIePqmhMaJhjHiumi3k0PQqRntoVdoOEr9uYZtofcS4qJfB1V1tVq2utLFnV3cU1qJBEx
	qLYATxbaTWvx8vQfMbrAIjIOd0zcF5KOJ+5OOtqxVlFyMVcyfeTnSRF6aOMjgdvbKpotNrwmyRE
	N3LL69g37
X-Received: by 2002:a5d:588a:0:b0:3ec:248f:f86a with SMTP id ffacd0b85a97d-425578183aamr1941034f8f.48.1759307470270;
        Wed, 01 Oct 2025 01:31:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEnDRo/HdWJbr5v9aDJ0k8vKbpUkQ5j+9O/NfoSAui1M83Tp2E1gqTmYLdgDjWsOAfIifq5WA==
X-Received: by 2002:a5d:588a:0:b0:3ec:248f:f86a with SMTP id ffacd0b85a97d-425578183aamr1941007f8f.48.1759307469775;
        Wed, 01 Oct 2025 01:31:09 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e61a029a0sm27915195e9.13.2025.10.01.01.31.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 01:31:09 -0700 (PDT)
Message-ID: <f07edfc2-0952-486f-ae47-5e3bbd77e4c0@redhat.com>
Date: Wed, 1 Oct 2025 10:31:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com, hughd@google.com,
 ioworker0@gmail.com, kirill@shutemov.name, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mpenttil@redhat.com, npache@redhat.com,
 ryan.roberts@arm.com, ziy@nvidia.com, richard.weiyang@gmail.com
References: <20251001032251.85888-1-lance.yang@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251001032251.85888-1-lance.yang@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3DiMMjIRkSeHo7luwfjo2gCDuc9ZEzbA2s-3sAGB_88_1759307470
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4951314000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: j5zp7qei3amdnbq9chd5wcgw58tf99pc
X-HE-Tag: 1759307473-508852
X-HE-Meta: U2FsdGVkX1+pDIF6u8ZR97EqMsgCVaxEWd1smHk13WNy91ae+NQLIg7l3QPp7ZFt6iWmOzK/TeVjIJHhycSGlTjfURC1iUWUQYzkRoIfvDwBWa0onk9/uRglFRxhXo4aQ/+UuFOQehSh5YRUF/HErTIlvDUBxLOIChEFDbpKFXG+wM0kFVIUVsvrAJD5kyN3EtGJdKbQcnNM8ffRn9ilWVr4gSyAJjuvFsYE5TRVo6dF1qOeIGm6u868DsDJzECbhxmDrNc6JC88pm8YOGUVUtdGDsH+v6yjOGlLS2GmsuIVyOr7gRnsFB4RbvvoPtDc1WRTShVEBeJD+M3IMdDGf022V1gmbb5Qu6duAW5FgS0JyFuKEoRKx88oCmHaxT5U56Q0tX/wJFLHDMNtHJ7QYMbV10IUZUxfBOJXv9gZbPHeUkZTJnS2zmaiGEqoJWEFT0PoW05Hoo8odIswnM6YGeyR3eks2zyWWX6uOMgvPHIZc6vA5uY/1nYWqfi1YurSyHk0gagffKzs3L+8NJfA0NP+fV5W7zgl0n7G9KRquqEv3Flxmd+qqWdyJxoJDDGSxHqWTNLh2XYKRw+m1Z8sTo8FKWlp/0Tdo7WdW8T3V4ClYXeG0QxlfJX9V45IhhE2W7k9ea85ap6ohv0CatjIKtwz5WRENVTMxTA5YNinMMXs1do4/vHBL1Q8ybwg9eCYoKBKxZ1v2kpgCMjOpPtycvhzxYqEDNavEOqWP9oM9h8zqdOnHknPcEk+XhVYeXXprQg1OnmCJ8FpveBI/Vh3wwlEsicpBYY74a5hDym+cNg1K/zFifB5+WgBEkN4uhSC1c59voDz3lortbY8e9KCGmcax8iP6zQxH8siYFISLUXGmnfEs9PLUoDe7cqlx1nRkmZo/A2OJWAB32YZuEekbcF5FIUU60epRAiJrWvO6s9exx1N8L8jx1DysQxMEXkaU+EglcLTGcuERcqEYfM
 QxBUZHJh
 5JW2jJtx7UGV79BKPLmdzZmj1AQM+qGzaao7DCBupxxx2XY76iFf2b7ULlqy+QRke1dJqXEJuIwMLrvkhr6BGGf7kCTOw7SHCPF8X0O19KTLivo6p9ESO7Jb2xtFgGFuM8l2p2Lpv/pJX6qT+QmNsyL8cVetrUoW2dlzDOEG8YZY7uqXXiGPZe1aPFStlSuK8Vb6ZlIyDfbWbfS4I91j2OSphlYSEVGT9c9Irpw9FJPv9f96ZqNe51m6VMfwHPbf63Al9VR5G8fsQqB762BFJm99M92KQKe+p/xjNU0QHHe8hazZ6A1/gR0sD0fKcAJff3bkR6Yo7B6oHtypxGY3QIf2izCkK9Vzx8Bi0qno5SDjoGbjAtc2MDhSJ5tgj7RvrC15Xrn0jCnuUOfTgV3n5OZkw+51Kjm/DhWCnSnIWb5hnILzNKYJMCzhiUW2G56wv4xaYFS303zJz/x2n/X6Qx+kEwMK5NoI5bwZSjgxvm2xh7SDrOBfp4hu1dDmd3UPie157R7g/us1k4v/NkK8QfaVtfg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.10.25 05:22, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> Currently, special non-swap entries (like migration, hwpoison, or PTE
> markers) are not caught early in hpage_collapse_scan_pmd(), leading to
> failures deep in the swap-in logic.
> 
> hpage_collapse_scan_pmd()
>   `- collapse_huge_page()
>       `- __collapse_huge_page_swapin() -> fails!
> 
> As David suggested[1], this patch skips any such non-swap entries
> early. If any one is found, the scan is aborted immediately with the
> SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
> work.
> 
> [1] https://lore.kernel.org/linux-mm/7840f68e-7580-42cb-a7c8-1ba64fd6df69@redhat.com
> [2] https://lore.kernel.org/linux-mm/7df49fe7-c6b7-426a-8680-dcd55219c8bd@lucifer.local
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---

Could have mentioned you adjust the flow of code to resemble what we 
have in __collapse_huge_page_isolate().

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


