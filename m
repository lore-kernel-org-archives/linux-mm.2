Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3105CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 09:28:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 182646B0006; Wed,  3 Sep 2025 05:28:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 133B88E000B; Wed,  3 Sep 2025 05:28:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 049698E0001; Wed,  3 Sep 2025 05:28:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E98756B0006
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 05:28:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8C6731A05A1
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:28:40 +0000 (UTC)
X-FDA: 83847414000.24.48349E9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4F3751C0007
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:28:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gRD29229;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756891718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XagSL380WccLaX3yNvgvVCZJRmkRkG29drasxwyScUk=;
	b=fzxyxj1d21uEV9IqtYaviTUzmZvxrUU+2eDi96Nl0l+rA7e7HCVjSDf/XqN0ZdFRx8mHeQ
	YdPnGRPgrpVhkys6IMqXZPnWDBCRyMd6YF1RGs94zGGLjMZXvf6UMo3FEUr7giHezAx0eq
	RW4VjL03FZbMBRhrvuh0hEH5sFB1l/w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756891718; a=rsa-sha256;
	cv=none;
	b=oB33ei2igCp1bX9u3TVh5zr0k9daAfURUhf6Wcg0spkLSDPG49LfAE1vstGE9m6QVNKC07
	oUlilFo91nPrLh8PGZQUJcJjvyZWyJhb1gtG29k8H/DZIhKPa3XqOuu9YqlbFRPyNvjFXT
	3lO8OXe7eg1OL0dZELx9PEviBocVjnc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gRD29229;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756891717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XagSL380WccLaX3yNvgvVCZJRmkRkG29drasxwyScUk=;
	b=gRD29229umt5B8pdP7aoVquZ9gMsVkM/CGKS3pSbnGNNywICZiPZj7RgdsXek1/GPcfh28
	fPZ3LfZ38ck5Q1QIBS04FzUOCo4/omJjx7255t9S9dSGRaV5XyCS+S/L/g9XJyc3t+1Y2s
	GIPkNSDXZbk5jW63SinWkhSoZmfZ+6s=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-99-2tTqPlq-MQ2MBXohDRzxGA-1; Wed, 03 Sep 2025 05:28:36 -0400
X-MC-Unique: 2tTqPlq-MQ2MBXohDRzxGA-1
X-Mimecast-MFC-AGG-ID: 2tTqPlq-MQ2MBXohDRzxGA_1756891715
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b7d84d8a0so17568175e9.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 02:28:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756891715; x=1757496515;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XagSL380WccLaX3yNvgvVCZJRmkRkG29drasxwyScUk=;
        b=hJLiZM8SydLEeMniSVsKaQ1RYjb/S5QcA0vlIjPPYhk8P6F+Dde7nkLpX3YccCZX1H
         rGE+GlBNmd2Yx5p735P7Xu7gTQEV5m695b93fwUIFuY3vG0ewVQG6pLb6Nf0VlX0AsJo
         Ut7ZTjrJ6rIhwkrEjGpOv9vOXT8LDe1UR91DcpjJK7hw9qLItn8JYyH0hIbs0+P+71/D
         Agfc4fGaUTUnb6UIBMlBEyWDrNNwuwu5ysBdiNEoSTL8+4CkFau7yrkKLWv+WLdWGHc8
         u0WOblLnlAHSEkiRIMNdHyTFxofSgo0AR93nQzOIQkWofPHIN7JNQELIMEZiebYdwIba
         h7sQ==
X-Forwarded-Encrypted: i=1; AJvYcCVL/CRYSxkExSpGmKXTz86rJdyy8c99utPQ8ui9F7Y3AUn8jMTQ0Bc1Z6PtW70nNY/ydmEyl9bdRg==@kvack.org
X-Gm-Message-State: AOJu0YwN0R+W8Rpmk4vV5KPODoVIBYvTqIjsjJLgGqSHJWnHHHRYaIhU
	G6o890DymDQF89HTqI8cFxXKtmUYhCd4bexZ9I1/rdAI0cWkfN25LQbnzlq8B7U196p418/Qwfw
	4cFXzdtdN5evpx+HA8BCOpt8Xf7ddm+urI9g3vJxfh/FaECvrkKYK
X-Gm-Gg: ASbGnctYkn/Vos1rs9jaw+MJMuRzTPRSUl1cSzloZqkMyRUBzCY59B/8BSbROfB2sYk
	0U/eS5FunQW+V66nxf/gsFJJKj5MmlwqCHo3db60CoqcFEBil3UHCH3e4g4ycRjZYUccx/2z37D
	JlKYyMN2NlsLtmGH4TAl0nlWYslsV3z1ceEqYzSwy/aGpEfQUh3PJVlHcUTAy9NLOubCDGmT+hB
	y0opYtJB7tXL9NA/sKJBnqS/r45NsjLadYimOttJ5KrwhqlFhUiXMjeBx8vLiUiULE18dTJwpvb
	F3TQZ7Xz2IzPUwElfbK5JoRvSiKMMiAENgO6HcBj1Cj7MsP/FL9JC3uCjYPk6tkRLNiu+HnP5Eh
	keMS1Y2VQrmryM2tDsYDJWmoNyqI4aaZomkxRCKUdqyATK/T0oOrkV5nc3Ly+YuKZ890=
X-Received: by 2002:a05:600c:4513:b0:456:1a69:94fa with SMTP id 5b1f17b1804b1-45b8554eb6amr113087285e9.13.1756891715122;
        Wed, 03 Sep 2025 02:28:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH3OIdbpC7eGStYBAaUEmvB6GqC1LGQrt2fa6m2+JUmDdqtUbkPiWQgVRbPGhaX+85Ybhui+g==
X-Received: by 2002:a05:600c:4513:b0:456:1a69:94fa with SMTP id 5b1f17b1804b1-45b8554eb6amr113087045e9.13.1756891714619;
        Wed, 03 Sep 2025 02:28:34 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f09:9c00:8173:2a94:640d:dd31? (p200300d82f099c0081732a94640ddd31.dip0.t-ipconnect.de. [2003:d8:2f09:9c00:8173:2a94:640d:dd31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9bcda91dsm54688595e9.6.2025.09.03.02.28.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 02:28:34 -0700 (PDT)
Message-ID: <baa1e5f6-d559-4874-a7c1-7daa7f1c3ce2@redhat.com>
Date: Wed, 3 Sep 2025 11:28:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/9] mm, swap: tidy up swap device and cluster info
 helpers
To: Chris Li <chrisl@kernel.org>, Baoquan He <bhe@redhat.com>
Cc: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Barry Song <baohua@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20250822192023.13477-1-ryncsn@gmail.com>
 <20250822192023.13477-5-ryncsn@gmail.com> <aK5/1so7a0i80+dz@MiWiFi-R3L-srv>
 <CACePvbU8pnjWCiWcSXRr4UdpuD_wdtrouLMz_fNB_=KRrdHLmQ@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CACePvbU8pnjWCiWcSXRr4UdpuD_wdtrouLMz_fNB_=KRrdHLmQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FRZw7AZ1diWrmaWDQK89nQap7ueSU3j1UE-928m1VGM_1756891715
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4F3751C0007
X-Stat-Signature: cnb3fnxe6mj1jap6kgozmthp64pnu9r9
X-Rspam-User: 
X-HE-Tag: 1756891718-202537
X-HE-Meta: U2FsdGVkX18XNX3pAb2x/E0clE6rMNW0xXbNn7il8UlmOS0eVBvYrTqe51W9+TlM35Qki9lc+UepiezzbDEeh+bCt8SDdULv4pTEfFW+4sPZ5f4RAHddgJTmw8Qg7s/1oj0izxMORqSFXfJkslYbqI28AjUsRPGeWJN9MwcKLCDoYflXPuyLbFqaVzSvplmwCSvEpFGPXD7M7xMPQ9dh5d7yxsGp5kpQbIfOUOgB8XMhFVHOVQJ3wFhm+Re+cYUDpG159k3Y3CUtrz4np0756rCaOiIDS1Iu/CoaR3O43osrQsxlSGf4NK0e3NxrXxJYr1gD7C9pEMuM+eQ2JEvwLLEW9Z6e6TuJUx9n54TGpOx3IMjLDqQTJX+OC+tZElhyCcTvWnbFnRqg+z9n/SHFFGq8PulqxUH6EnkLLwA2C5LRdMf4On/ZdDxPctU/gGX+vXJClkkk+c5o38mWi1942TcvPhtti68dYyl4cNU9WgAbpXRu5v94GFS8KmhqgfPabKenik4OGcAbNJK59AnuoEe+SikCkKciAqo0wgN8qZl9YwhJ+8FPNMUHZyiOrqCGt64u514JA5EtxB5p5DTa/oCoRm51xwmbwlHQXitvvKHwiOWhRYQfZwVcq6Y75Rbedd3nDQjo3Rxnb/Qp7/pmDmaE4hcXEt6mQ0Z2MnJhPJ45ehLWsFZb0aomWuYTeNusZhMMNf7UljxbUy/7f3hJb28GLIy/qWqOS8EveGpdn8LZSI+TQX2yXmH0E+U1ECRf05Ovd045/6n9CTQ8azPCVDUdW37YyMZHDpbAHM161jeaQo3swfCstz3dElrcqFO3AtbJCuITjSMba6Py0/teZvQXu8F1xmnqnwxgA1af7M1xmQ/lKvd5AgWD4op3FJQPaGCj3UMvmTqM4F0ibB+erIhCy0QTfv8QYAjyiHpx9t9SwtldHCbmrPvrfioAG1ZHF99eIO6UfoIMDD2elsf
 1Yu5k1p/
 GKlt5klvLvEp0sYUDPkIV74ZoYAJERPx7nj6XYyR9fWtXp5kJJeHycp/3sMwVKLLn1jB9WuqVKi97qmCB0jI2G5Rkt8xA58AeZZy+ffMN+Tz7RSNmdxHQ4Yi7jDXGPOBlOVlQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.08.25 19:44, Chris Li wrote:
> On Tue, Aug 26, 2025 at 8:47 PM Baoquan He <bhe@redhat.com> wrote:
>>
>> On 08/23/25 at 03:20am, Kairui Song wrote:
>> ......
>>> diff --git a/mm/swap.h b/mm/swap.h
>>> index 223b40f2d37e..7b3efaa51624 100644
>>> --- a/mm/swap.h
>>> +++ b/mm/swap.h
>>> @@ -15,6 +15,8 @@ extern int page_cluster;
>>>   #define swap_entry_order(order)      0
>>>   #endif
>>>
>>> +extern struct swap_info_struct *swap_info[];
>>> +
>>>   /*
>>>    * We use this to track usage of a cluster. A cluster is a block of swap disk
>>>    * space with SWAPFILE_CLUSTER pages long and naturally aligns in disk. All
>>> @@ -53,9 +55,28 @@ enum swap_cluster_flags {
>>>   #include <linux/swapops.h> /* for swp_offset */
>>>   #include <linux/blk_types.h> /* for bio_end_io_t */
>>>
>>> +/*
>>> + * Callers of all swp_* helpers here must ensure the entry is valid, and
>>> + * pin the swap device by reference or in other ways.
>>> + */
>>> +static inline struct swap_info_struct *swp_type_info(int type)
>>> +{
>>> +     struct swap_info_struct *si;
>>> +
>>> +     si = READ_ONCE(swap_info[type]); /* rcu_dereference() */
>>> +     VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
>>> +     return si;
>>> +}
>>> +
>>> +static inline struct swap_info_struct *swp_info(swp_entry_t entry)
>>> +{
>>> +     return swp_type_info(swp_type(entry));
>>> +}
>>
>> swp_type_info() is only used by swp_info() in the whole series, can we
>> open code it in swp_info()?
> 
> BTW, off topic here. I really don't like the "_info" suffix. Anything
> you can put into a C struct by definition is some kind of information.

I guess we use "info" when we just have to have some metadata and we 
don't really find a better description / abstraction.

So I don't completely hate the "_info" suffix here.

> Same to the _struct. Anything defined by a struct is a struct. Don't
> need to say that.

Yeah, at some point people thought it would be a good idea to do that 
(mm_struct, vm_area_struct).

> The "struct swap_info_struct" gets two of the unnecessary words. It
> should be something like  "struct swap_file" or "struct swap_device".
> Renaming it is too invasive to the code base and it will mess up the
> git annotation history.

I wouldn't be scared about doing something like that that actually 
improves the code.

You'd likely have to find an abstraction for "swap_file" and 
"swap_device", and maybe that was the challenge back then.

swap_info_struct has a comment above it "in-memory structure used to 
track swap areas". So naturally I would just have call this "swap_area".

-- 
Cheers

David / dhildenb


