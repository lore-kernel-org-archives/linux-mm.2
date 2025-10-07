Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B91B5CCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 16:14:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0803B8E0005; Tue,  7 Oct 2025 12:14:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 058B68E0003; Tue,  7 Oct 2025 12:14:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB09D8E0005; Tue,  7 Oct 2025 12:14:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D8B128E0003
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:14:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AEA9D13A00C
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 16:14:10 +0000 (UTC)
X-FDA: 83971815060.22.C5D550A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 55DEE12000E
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 16:14:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A1FSZerB;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759853648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=12Che5t0HROHRRsC4sAiXZshTGRWxlbpXt7HNiDEfA4=;
	b=l0n8SKuagzj1yfQUFqcaB3BQykIFpEKUox8GKfUjCI71WVIa56gpJqTVixGArLjbCRQrst
	xSgvfdEc8wQgASUG/XJdVqZ2+wqThxTyqpgnx3KlGd51YWrfsOTEQcLLUgTK1pe989M0Og
	J5Zx8f+UMca/pl3HVp1pvqmQMni13i8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A1FSZerB;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759853648; a=rsa-sha256;
	cv=none;
	b=QqsriNYjE/L28YDsNL6mXBYDYBuL4T9vJkebHJeYahTwLFkByioSbB7sS4fJJuaUFD7nHm
	sitmKyW03pyc42StOuqP7WlvL0FKsYbS0MbuJS/VqOcUe72SIyU0MFJuQL5EoPv/Pap0Fb
	DYsChQA1YwKxNakxCYRAAW6ew9YR1iQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759853647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=12Che5t0HROHRRsC4sAiXZshTGRWxlbpXt7HNiDEfA4=;
	b=A1FSZerBssS8f1J1XBucnyIofyhQW3MCk9PclrA9vsOL0Z2vvd4hx7x8r7KH+oZUJEt/K5
	kIL6FFtMOcZJ2vGwlSxFs8fqYOKo3oM1oKYwxQbtM0ZP+O9MoXvlQ6lYY+np+/5LhNR7nf
	ewFqaxgvZWX3pT9DjptTJxo9C0QIlnI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-_nCnMgtBPm-onDBwjHWbOw-1; Tue, 07 Oct 2025 12:14:06 -0400
X-MC-Unique: _nCnMgtBPm-onDBwjHWbOw-1
X-Mimecast-MFC-AGG-ID: _nCnMgtBPm-onDBwjHWbOw_1759853645
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e377d8c80so23633385e9.3
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 09:14:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759853645; x=1760458445;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=12Che5t0HROHRRsC4sAiXZshTGRWxlbpXt7HNiDEfA4=;
        b=Zg0x+yka3XMD4DT7z8BYYKa86wt70ji5CjWEUY0Yu82RjDWdhr1vKpzukntCCOXRIe
         hJG/MO3R52tfZX2Dhf+dtuQz1EUYfrAUOXiIUj3xivY4/+qv1wMvgLph9AaNynMI6r4E
         XzAkwMWJMIRBY9nU23ypz90D/Z9q5pmxZiQblyWPayNZh4htWpvpCI0Bawn3OQuBtlQm
         dzlwiaT58MHEhbEOG5KDjbIrVbSUCNJdwO4oE6y2EHbd8CD8taU5b3PFBglc4jThofdo
         IXSN3T3hPDN4Fg11e9XJfrIXyR5wKsrVk6JWEsJdZ3IfaLJpoS+TVjyQI/9AUjvdfkLv
         nZmA==
X-Forwarded-Encrypted: i=1; AJvYcCUQGtvOVirvSRZDYkMvb7fPlvZZydsWRJA4L/B9Z33CZZwQH9NrJp/oz2AjJUZXeVRkmfDRg/KxDw==@kvack.org
X-Gm-Message-State: AOJu0YxxvrQN1h+Jqoij4fGRaE6A8OEHRFH/j5Bo/3dVEwZzO41JWaSM
	rGkSm6f5uSz6cCXbdMFyIruzIbyd2A1dGzJVFqRdFK+8kOJVnPyJAW1EZGV+TB7Tjo6Itm+jtHZ
	Ng2M0TRB0opw1KM9vbMaVbYGy7fsqDbKAIrLXweytiYTMvyHHctXg
X-Gm-Gg: ASbGncuWUi0U6aDWDnWnFZnrFr1+LrshJKBjmZrahe3CTrWjTNvZcm75vX+jwCdnON6
	kitBbBTymGie4puNtgcN7fOq4oRDtaU8Vz9MTXbsv9YcHZFCwGqVsbiVeEdRGIkj+AEMmKIiwXT
	gao5xwuklc/3cJ01JXC9R+5aUiQ+NqqECPRT0jFuOP7B7yYtH2NM/9hGet3EC5UdJRE+jXwDjHk
	1eWWTOhw3UD6lz9aTsH10RcTvfx8oUfHheSPevUGFJzfDH0ExENpqDVnoyhmU/+HU48dpM8Qq4Y
	xXAPzkAWIPpSyx/ZO3IiYO/8K6CafJNnpbamWNNvszxOD87+dRvl1eK0SDMboV2uYx2oNStz7B1
	uov+qM5sF
X-Received: by 2002:a05:600c:4690:b0:46e:3dc2:ebac with SMTP id 5b1f17b1804b1-46fa9afbb62mr1174185e9.27.1759853645118;
        Tue, 07 Oct 2025 09:14:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEcLyTc+70gon3POBYkIbpKqytKcA7VAAQhCz1d2+32GdwV8lu9XuAX5w9JuHa2D4Ly8l9zpA==
X-Received: by 2002:a05:600c:4690:b0:46e:3dc2:ebac with SMTP id 5b1f17b1804b1-46fa9afbb62mr1173975e9.27.1759853644735;
        Tue, 07 Oct 2025 09:14:04 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fa3acf0c1sm18566445e9.9.2025.10.07.09.14.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Oct 2025 09:14:04 -0700 (PDT)
Message-ID: <9089d994-262f-4941-8bed-f3c6ee05a769@redhat.com>
Date: Tue, 7 Oct 2025 18:14:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] mm: Introduce vm_uffd_ops API
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Peter Xu
 <peterx@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Axel Rasmussen <axelrasmussen@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 James Houghton <jthoughton@google.com>, Nikita Kalyazin
 <kalyazin@amazon.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ujwal Kundur <ujwal.kundur@gmail.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andrea Arcangeli <aarcange@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Hugh Dickins <hughd@google.com>, Suren Baghdasaryan <surenb@google.com>
References: <f409cbe7-7865-45ab-af9a-6d5108bc5ad4@redhat.com>
 <aNw_GrZsql_M04T0@x1.local> <43d78ba7-8829-4a19-bdf3-d192a62cdac4@redhat.com>
 <aN08NxRLz7Wx0Qh4@x1.local> <ad124fb6-a712-4cf5-8a7e-2abacbc2e4be@redhat.com>
 <aN_XZbQjuYx-OnFr@x1.local>
 <cq3zcvnajs55zr7cplf5oxxjoh54fb7tvo23hehd5dmh4atvum@6274mneik6hu>
 <aOQuZy_Hpu1yyu29@x1.local>
 <akld3v2mtnjdqvs5dgwr4gnffdqf5dojwhmfylq3mkfzakjj7j@5oqqxsymkcbp>
 <aOUa8C8bhWvo5TbV@x1.local>
 <frnos5jtmlqvzpcrredcoummuzvllweku5dgp5ii5in6epwnw5@anu4dqsz6shy>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <frnos5jtmlqvzpcrredcoummuzvllweku5dgp5ii5in6epwnw5@anu4dqsz6shy>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CMRkD_MtkhbX6VfC_JcLwSJNK37fqmy-dILaYL0VLBk_1759853645
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 55DEE12000E
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 4wjrhcf5j9hrkifp3zz83s63m3ufgaaf
X-HE-Tag: 1759853648-538739
X-HE-Meta: U2FsdGVkX1/yATFmc3vcWlUPbnrLSt11+PU8HxHPcWR67rR5xwUxYmoo/Qi5XSYoaBFaf0ha+URng8XNtT6X0Icc2JhCMeu4e4i/7+oSxiCoaopf6OiHUx5eeweVbsT5zbVrCAv6TmVP/C6KphpLcfPLkDaGUyV3p53F01cjaWtT9jEuLdRc5Jk1mMeLLNqIwiX6sBM+WCxTpZ0JZYO/segtZ4rNQkiSfZS4ZFG6MtYCDucsbfeKQrA0sc7WUdqWI+U7bQbPCf6U1Z1QSuDk6C/YFFu0lNJDVK57Mnk+zIa3xJn1UT70v06EgKCxatUnOhcSejJFXKdmtzWdh+zqKHgg9pRDfDVkXS2e6Njdi8G4uQKKR/Wo6aGGHgSn/9Wp6hETUDB/pHTsxo7L4H6zs9Pfi5GWfFYYHm4yWOxDHsE71GPZqqX0/6Id1b+0Hhdug6B5mZCUENrP4wL5Flfp0LqTJDzYDCW79nWY8HDcDfYYbfMFx0+bNyuwtGASl9aYr4UiEnAlsgVmv2TaOCT1F7tBPQKy9kCKC3eGIH7yH3OhVQsLT4OerENpvK8O84L0JQHWE3zUJZwdeQkmE7Vi2JgVasMjE5CRvsn0Racu3y2FTeUY4HaSQWuFMksMVVBT9CA2QrSPy/4ZjgNRmR2Pxnf68t+6AcNVue6q71n3trGXyPb4UKHhUgmRza3lUR5D9tZbxxPABNA4gJAbLbT2N+Qp9GGnh7bOHSki3RTxLxHd0yOOLaBdnFcglU4LOxxng1Qva7/AwEhZ+ucBYi0P92fTq44FVCDV5xTNL2XrrcBz/DrGb6s1ewcvY/uV8RrK10vFWTtzzRL/1qwhcLOzwgUmTgyvwRG22wM40utkiDIbiFVpN8jgwJgnnBvMVT7zfMcbNHmtgLC7XES0TyY/mLmHAN/2+FXXyjCYd30Ig9VKyicg2QPHMopVl4Dfk4s2DBJMYgx/r4IULlyxD/9
 Ho1FD5r9
 1QumryInlFViYyDTiIKVJrQTQlpDTqt6xE5hfXysdKbEUKrIqNQdNNwwezuN5S8fEPZ5/uAAxebMDjGsfeHEA8dWUGggTQ6d/4mhcyZWM7akMd/FSqG9f8Avb6PKoG7qxbbLlY446PNK8XvlKxHS2e3BXYXk2aAdzhn00PlFRKTeUmKZmbh+QJCpR045soCDzq0TeVTB/7iyOvpS8rY8eHqg36RuTtknCF9EnLE7Ow4R8D/EA/MrI+phKwahXfnu+w+ndrDw/hkQvQo3SpBIzntseBFjBkd/grHn3vRzWOihrv9IURceeA1g0JhZ+WazR/fQ66a95to1ADxwR6/UcCDZcbH5tviQRE/jlgkEMN+YvvKiISZeVcFQO/bnfVti0lZEK+WgOJwJ+pycCYxIa91rv4Ox48W8GfnvlIUq9ia3umdum5TFLec3bHMGSotD0f1dInpFIUUCc9/A3JlPAazeUPdbPfmNFyVwAt3BEW88hhdGbWqddICi/+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> If so, I'd prefer that rather than introducing feature-backend flags,
>> because I want to avoid introducing another different feature set to uffd.
>>
> 
> I was talking about uffd_features.  I thought it was being renamed to
> flags, not modes_supported.  It was pretty late when I responded.
> 
> FWIU, David was saying we don't need both of modes and ioctl listed in
> the uffd_ops?

Right, I would have abstracted the features to clean it up and avoid 
using VM_ flags in this interface.

> 
> I was thinking that we could just put the features directly as function
> pointers in the uffd_ops and check if they are NULL or not for
> 'support'.
> 
> ie:
> 
> struct vm_uffd_ops hugetlb_uffd_ops = {
>          .missing = hugetlb_handle_userfault,
>          .write_protect = mwriteprotect_range,
>          .minor = hugetlb_handle_userfault_minor,
> 
>          .mfill_atomic = hugetlb_mfill_atomic_pte,
>          .mfill_atomic_continue = ...
>          .mfill_zeropage = ...
>          .mfill_poison = ...
>          .mfill_copy = NULL, /* For example */
> };
> 
> Then mfill_atomic_copy() becomes:
> {
>          /*
>           * Maybe some setup, used for all mfill operations from
>           * mfill_atomic()
>           */
> 
>           ...
> 
>          dst_vma = uffd_mfill_lock()
>          uffd_ops = vma_get_uffd_ops(vma);
>          if (!uffd_ops)
>                  return false;
> 
>          if (!uffd_ops->mfill_copy) /* unlikely? */
>                  return false;
> 
>          return uffd_ops->mfill_copy(dst_vma,..);
> }
> 
> This way is_vm_hugetlb_page() never really needs to be used because the
> function pointer already makes that distinction.
> 
> Right now, we have checks for hugetlb through other functions that "pass
> off to appropriate routine", and we end up translating the
> ioctl_supports into the function call eventually, anyways.

Right, it would be great to get rid of that. I recall I asked for such a 
cleanup in RFC (or was it v1).

-- 
Cheers

David / dhildenb


