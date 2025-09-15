Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DDAFCAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 11:22:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82F258E0005; Mon, 15 Sep 2025 07:22:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 805C38E0001; Mon, 15 Sep 2025 07:22:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F3C58E0005; Mon, 15 Sep 2025 07:22:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E3788E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:22:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1A419BA255
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:22:16 +0000 (UTC)
X-FDA: 83891245872.08.E643671
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id ADD172000B
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:22:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qarg0R4x;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757935333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6JS9BpphTEQIvKpjiDMgsvluJyslUVzzLKfuwxGpvmo=;
	b=l6YZepAsr5F5Cb+AFfdN6sQwGHdEZoHMaoDnX3SNVMHEx3EDJIf/PQGrNPKcPzFUCYwTOW
	+Mfh9nAfadxoeZMGFLlBbJ1QlcXM2C2n0jA0UWafzWuR+FldMRo77zLdMCqB7YTK19A/BE
	cLvnRBfjC9vtt4mDYLAM97pBxvojyVE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qarg0R4x;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757935333; a=rsa-sha256;
	cv=none;
	b=ALCUIQgaFMAgHLEqlU9n17SiJpayt/sz6jNhBrpefpuUXS5eoiG3yTA06RS0FZgWi16P4y
	xJxAv7lrNa6+GaWFlArTLSCmMfepelRHOuD1qT7I20YnK4IZmEc25fgGqGn6e6J87ImJ9B
	pfWWP2kElC8vpMbxcyaf6nZh59sW2bQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757935333;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6JS9BpphTEQIvKpjiDMgsvluJyslUVzzLKfuwxGpvmo=;
	b=Qarg0R4xEBZQi4dWaGHcWwgcrFNbN/Xu6kSQglOtFbpcP2SwxUF9SuyrgQOKVweXao12sE
	kMOkiFfbslByq2ctviPtzH2dAiWDbZFgwz0m+i4qefvnMX6ZnONU6QJ53CPLFecKWIjR3F
	VbrGzcvSzmcx6R6gcAhb0INHZpO6Pmw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-175-Hw1zWg34NrGIlLMnvOPoUA-1; Mon, 15 Sep 2025 07:22:12 -0400
X-MC-Unique: Hw1zWg34NrGIlLMnvOPoUA-1
X-Mimecast-MFC-AGG-ID: Hw1zWg34NrGIlLMnvOPoUA_1757935331
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45de07b831dso22198545e9.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 04:22:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757935331; x=1758540131;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6JS9BpphTEQIvKpjiDMgsvluJyslUVzzLKfuwxGpvmo=;
        b=BjVoJRs0x34vSWtRUhhwGN0jnbtXr+o1fw5AVNr+YlMwtt90uzUYKZx30TwyUSfWDz
         Fidydn9sIFJuYM2QU/6kl20//OjO5w1po4Z0aJhM00zEb/MGM5f521tK3PFy8xzDGwk2
         neyenFV1UvBTyUn9oz/2dTJlcnI+tDFaoTL5nO4VyngZVsa1FVebpuBik3vqeQ8Z/M+/
         3I6EUXkO6pgK6CqidvXMnrplAB6CTHUDuRL4jFAKzpchbEbeJbjnDbGqPNfw2L/rqvZr
         +85viS1dHO4PYa1qRzmnDlmPMTFbHDlIBw2xXNzUB96nA1NonK6TV8OjZhelCmKcBUJS
         jphw==
X-Forwarded-Encrypted: i=1; AJvYcCVBEMW+UorWUNmsTmuOOHBBFTFh2dMep3PrstROvNZ0YuyNNnNAvRYj39mjyxzdAf3ZbN5VchQvsQ==@kvack.org
X-Gm-Message-State: AOJu0YyRb5iHagjn8YfKeIlMy5KM0f2cuQW1y7u2wN8/LI//3I3FswTj
	yFdT4Gv2zQRQ26qsXXYYFXLzmAvjMOfi36lLpKwDB893qs2fTLKknAEm6m/dZb3EUIiiy66bobB
	f2YGhGNT7hD/SFkz6xyrCsZoJRhEjba2ikbh9E5wm/A/WZQUqW5/o
X-Gm-Gg: ASbGncuVe9osp0GPjkBU+OpLkw58lBCYqSbcPPwEZj/AMJtvzEqBtT6fNg3G0plQ1vI
	5pUXDJTJsq39h16QOFPCFDOa0vaAL/OhwRmdYsnhCMsUmn4eRyCO+pAOVET0tRpY8XldaXwqpSe
	vmzSD9hvl1jz5vPWgOP2jtf+6+uESwdW+0XJSXjzzlmWirY5bfqWSsFTdBL1ePboPen0p8te+Kk
	fA4HwtkR6AMm+jTAKt4ujJ7JZ5lPrUjvnmoqpduBu5s3bQd98ziDbnQJ0QOt5BNiQrtVsNn8P75
	pyPd4U7VTGP3NqDk5P+84rrDXoTW2/oA8ovbY0R7LvBQyA0YSkzy8yYT02feO8HusVF7MsK6Ey8
	mGuJPpj9Q0Zbo0fKXP5dVmEg2LT6lmqTV5gIVm49fQ8UG9uiWkFFZ+gEBNNRVoPD52Tw=
X-Received: by 2002:a05:600c:4446:b0:45d:f7e4:bf61 with SMTP id 5b1f17b1804b1-45f27ceb2f2mr68690465e9.4.1757935330614;
        Mon, 15 Sep 2025 04:22:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHbzlCmUlfFh3pRrb1LTU/GY0YGAbYOxUMXj2cLY+VIMiWhAEy48i5aLRY2rCGTwJQhgLvVKg==
X-Received: by 2002:a05:600c:4446:b0:45d:f7e4:bf61 with SMTP id 5b1f17b1804b1-45f27ceb2f2mr68689975e9.4.1757935330079;
        Mon, 15 Sep 2025 04:22:10 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7ff9f77c4sm11234210f8f.27.2025.09.15.04.22.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 04:22:09 -0700 (PDT)
Message-ID: <d5d7cf04-784b-447c-9d63-8322ac97be29@redhat.com>
Date: Mon, 15 Sep 2025 13:22:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v5 07/15] mm/memory/fault: add THP fault handling for zone
 device private pages
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: damon@lists.linux.dev, dri-devel@lists.freedesktop.org,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250908000448.180088-1-balbirs@nvidia.com>
 <20250908000448.180088-8-balbirs@nvidia.com>
 <d4ae7f61-f2f9-45dc-91db-4de7f3127744@redhat.com>
 <37196a41-77ae-4579-97a2-2c7a1eb65bae@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <37196a41-77ae-4579-97a2-2c7a1eb65bae@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: D01TghdrGCEgbuUT2jsDNpHg90mnW5tPyYgW4UDOm1c_1757935331
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ADD172000B
X-Stat-Signature: c4t3wfqrmyn6xwbnth1x7a5gpmo787dd
X-HE-Tag: 1757935333-991038
X-HE-Meta: U2FsdGVkX1/0PGMd3Ez+OWEcUFZZR0XqiQjP0nZ8stbebyCMSPGXhxkusQHo07x6KhkSq/i16Lnt2YvNyM1AF1rZqr4MRaZLgYzF8SXs9v7l/E3z7n659NMASQZqeGOLY1u7rNGdkpdQPJLqk/RMuBUErzhrB/yJyorATOpjxHuXTYI38ikqWQ6lYpR+rrtwMijPLJNG8oxl3N/ERQqQ/U7dBaFOssTSKFHlzq5tXkp7UWQAcw+ULrWivhLB42R7KVFa0YMhFnpdwslkn3t8u632+o1qQcofu+DUT93iYoK9DkmhBM7WAnUDTs8kZYGH+BcSIJu36Gxz0wwz+XmYruOX5tk+8yNQ9+55IdUt8jfadRYayuWkXXHnp2ZqvV/yBbM9oJFZMCQr2FkZIoGLjCMsXIPkTV58auaT6vvLI6ylFLkgZzHmJAcICbsUweA+6wSDIMApG+X3l1hz5nMx7fFI/XRCduMSgNXgXG77z5BtFBFIo8vgdiGIzafHoTBlNHfnsOyuskQqpUTnRC/CG7WK+FH9J39gYtxDKnHFBtbLfs9AKlNUSZKiqFU3GFaiOu+6F3pc4iPbhA5uB2VFL9HdbaG99SSfXucy420Xa0XgOKfulKHjOge74JUSgtzIqWHQhbv5cyVjn93jSdv9IuAMsQvGwjkpEkSYRNJy08VBKHQlnNNevLZQ5E+qOvyzliNPMNtwDtSsHYH9QPkThxBRY1aFq0smm2VnzvFRT/zt4vqFm1NbO/HttuU2Z7OAd/Pyxg/o54QB27qRVg5EsWdqwT75yvxGV/bKFpmgRXqt3EjbrT5g7rUsFivJlCotpthARq5RAKu+bpRuZbJ4xfo7QAwdyTfgIMDhoF6G3XbtS3VIWhf02JLCNFh2ImbRzZzMd6q+lwaJSaQuuT9RwXoTw+CZirx/NU/vBvTj53LHdvj9eM/EPP+1Ug0tY0TWX5bVzfiIIkMuyGKnbev
 p8cas0uu
 hy+gD7x/dM4upFFDOIvbp+47w8f2Q//W45TbB//gtzlqhsWuBJxAUgZbqkNYf84DfJR/L3e5rE4I9x5IkQGfQAlfpGBBpLfaW192HF09nQPkgKhr7zHfA++zpcmxv+KWtZujqZrAB5PuKukw6GnC+CsM98JxT7VFnmDlod7jsNyodm/8TKxAQ416xksEsniRixhJm7hWsaL1TEq14lLeuT+Ik0wLj+Lx55R4/56t1A1chOrliYYUYcQeAwoDFOajy8F7CjaGN+onysit8n5hIVzQU2qkkrjtyUEnbRCzqJMLUlfrfB+7hlUFcrovq8oH2ZvqUZttIv3sEdygDSiAq4iTj0hY5MczSO3vC/6rtW1dK0rXARQ0lnkBKSWbUEgnabmjEs81U6okVbFndHjWsLnhdlyxVforOj7kH3dNEKtjl45d+BE2cUi8KMUpr2ik0i1Tp7RTeEIiB+VM7ukss6l0/jh2QH3CsHPc15jomr4NsxyA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>>    /*
>>>     * always: directly stall for all thp allocations
>>>     * defer: wake kswapd and fail if not immediately available
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index d9de6c056179..860665f4b692 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -6298,8 +6298,10 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
>>>            vmf.orig_pmd = pmdp_get_lockless(vmf.pmd);
>>>              if (unlikely(is_swap_pmd(vmf.orig_pmd))) {
>>> -            VM_BUG_ON(thp_migration_supported() &&
>>> -                      !is_pmd_migration_entry(vmf.orig_pmd));
>>> +            if (is_device_private_entry(
>>> +                    pmd_to_swp_entry(vmf.orig_pmd)))
>>
>> Single line please.
> 
> Ack
> 
>>
>> But didn't we have a pmd helper for that?
>>
> 
> This is a single if that handles is_swap_pmd() and then is_device_private_entry() and is_pmd_migration_entry()
> under that

I meant using

	if (is_pmd_device_private_entry(vmf.orig_pmd)))

just like below we use

	if (is_pmd_migration_entry(vmf.orig_pmd))


-- 
Cheers

David / dhildenb


