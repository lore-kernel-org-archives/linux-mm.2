Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 429DBCCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 09:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 783B58002E; Mon, 27 Oct 2025 05:34:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75AE28000A; Mon, 27 Oct 2025 05:34:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 622E38002E; Mon, 27 Oct 2025 05:34:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5183C8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 05:34:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F388212A7AB
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:34:52 +0000 (UTC)
X-FDA: 84043384824.16.F4C3222
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 493121A000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:34:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Yid8InZH;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761557690; a=rsa-sha256;
	cv=none;
	b=6u4yax4LEkicgCMGB+mt1J0qDizEEiMnUd+ZPnbA/XlflwvQUNBvUkQ4Ju2Fwma+D0eion
	0sJEkunv12hr0QJzYTdH8e5eQYPKPvEYNn3GKaoUXSekfD4QczbJmTbJvXqyGHuN7ZcSeN
	4es2kGWr0H6VvmMH+mmwboBCFGYzsxM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Yid8InZH;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761557690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=enI7LZNpEoEgG2kCIqkqYuUnATtEoWBy7Pep0LNgBPY=;
	b=JWPukjimizeg9TjL3Ff2yx+P+3OY72ExtuVn/ZEymIn4ZyWLn4eeoAFQfL3vYwrG2WnVUG
	HUtHwRvj5r7rNXzBs6GS69JOCnz7Bvg3S73j7PKX2eslsY5EHmxlvCKvvEkjCt+b+Qjb/O
	cszRBExImPCJzosOoidiA+Nh5SoGB6I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761557689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=enI7LZNpEoEgG2kCIqkqYuUnATtEoWBy7Pep0LNgBPY=;
	b=Yid8InZHBrQjYFAUOmUdcAQlA8bUaDWZq0dY9harMA5Uyy9tvuwxp5Ic0c4sQIceOz/EY8
	yl2PJpV9LDxo+4aeTyTkgiTDZWzTYC8D2BXanI1LFmGZdyzfe8c2TWRmqwxmpK9Y0eulww
	KuMR5OSFrt//FuV2a+TmfYIR88vWqyE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-_fNf2smON8uZg3JJE-7Kpg-1; Mon, 27 Oct 2025 05:34:48 -0400
X-MC-Unique: _fNf2smON8uZg3JJE-7Kpg-1
X-Mimecast-MFC-AGG-ID: _fNf2smON8uZg3JJE-7Kpg_1761557687
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4721b4f3afbso11790165e9.0
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 02:34:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761557687; x=1762162487;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=enI7LZNpEoEgG2kCIqkqYuUnATtEoWBy7Pep0LNgBPY=;
        b=jvLR7RCwNIitzBuSkNi0etjwF7MuQ/Bb9mfqyYqSQH5xoJ50T3Tl7mLncquuqeZtpI
         QiXJSLOxjDvgGsxUCnSrK82lCLy6ArnOfcUtl1AxRb0HbqBOzaFnPQffTvgc/HkSqeks
         pD52fZZlLf6CfQHcC6VM/z6ue8fsBVmctefxCTHh9yOFJ6Yb/OhGIGaRArKgizvxp2JY
         Rsjb77nxxW1ISTAvQVMfikfk2buEUEYLEickBvaHvdY0s4vbIUBq96vEFWUnh5HvkrXs
         5iJeqQGZYidVTPS5P6WkBcs5ZJ/+mtvCmCsysNJcpGWW2db5QxZ+qPmMhTl+QUnmZMWG
         zvUA==
X-Forwarded-Encrypted: i=1; AJvYcCUfpfc+WEnV4Yy/sIG+lgF8TjeHkofzGoJBE0WVCmqRekWz10XqL4d+7FaPyPEz5BsT2TDYc0vwlw==@kvack.org
X-Gm-Message-State: AOJu0YyZgcRbGa7S4fibgAZd0f95DCOZ4xalajGAKSVTN1Z502jlRaXq
	wjPAdUuWhb46TtZZqvrKQ+VuAPi8jkFKFrcLAaUxcpHAU/OsT1mA8nV2f7pIV8/McCceMaksmRN
	WDsGCMR3mX5Sw9C45+vbB1emWf6IFQmm8n7CKUHUzkCQ9cZQcv27F
X-Gm-Gg: ASbGncu2T5mgJau5Cpuxhc5vLJOdr6zEdaLUlormhLI/F3OXo+H0G4NY5ZnfrbxKXDv
	7lFY/0iw4Yl/LDcqKYwrgqz+A5fEw9j6eg9y10omo+mz72m3nQ+OgFT5T2A4JqNcP9tJ5upSlYe
	/4B2/cGK0NWr43r/b3wAKuFHBKO/lOWRIxXAyKTKwnzxjEHc97MAvAKgN9/OfiTQfZnlpRNoLCh
	E+sFkybz7BEzbuf+ZG4o1MBLWefxIFzWVfFWoQXwi7gKpZHIJC7n05TwUEYYt942VcA5+WSRMhP
	r3/uZopQfAIiFpnQjkrEt5ev6nYtaXjy1Z6hnsHcBWeOKvQlc/9MoubGLrpOzB1jbATi/bNNNxU
	EnmxpggswK8iAEfPhALH95GqBbA+CjPwcxZP8pCDEEbyQJq11gne0zFUHcb2znjaSPGJD5QHlzZ
	YYZPANWiaTj8G8KGlPKh4GmYGPXOc=
X-Received: by 2002:a05:600c:800f:b0:471:672:3486 with SMTP id 5b1f17b1804b1-475d2e7e9c3mr74954835e9.15.1761557687243;
        Mon, 27 Oct 2025 02:34:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEbYhXBdD/2sb21JkRwYqN4qMp1O+MlBYVpVhQAmAEtPEi4yKtKC4y56wL69hYkHpXzsclqsw==
X-Received: by 2002:a05:600c:800f:b0:471:672:3486 with SMTP id 5b1f17b1804b1-475d2e7e9c3mr74954495e9.15.1761557686886;
        Mon, 27 Oct 2025 02:34:46 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475dcbe5587sm146578635e9.0.2025.10.27.02.34.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 02:34:46 -0700 (PDT)
Message-ID: <0fd86682-0679-48ee-8622-d9d7a977d69c@redhat.com>
Date: Mon, 27 Oct 2025 10:34:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 1/2] mm/memory: Do not populate page table entries
 beyond i_size
To: "Kirill A. Shutemov" <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
 Matthew Wilcox <willy@infradead.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>,
 linux-mm <linux-mm@kvack.org>, linux-fsdevel
 <linux-fsdevel@vger.kernel.org>, linux-kernel@vger.kernel.org,
 Kiryl Shutsemau <kas@kernel.org>
References: <20251023093251.54146-1-kirill@shutemov.name>
 <20251023093251.54146-2-kirill@shutemov.name>
 <18262e42-9686-43c1-8f5f-0595b5a00de1@redhat.com>
 <ca03ba53-388d-4ac4-abf3-062dcdf6ff00@app.fastmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <ca03ba53-388d-4ac4-abf3-062dcdf6ff00@app.fastmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9mfGa1IXLDe5eWbDa90ckft6YVhpMYCOccEKozoIfKQ_1761557687
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: n3cc684j1pzw4i4yc7aerpzquxc9fizf
X-Rspamd-Queue-Id: 493121A000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761557690-452039
X-HE-Meta: U2FsdGVkX19DrHmhBiR9VeSmw5UOn3UsaYKUuZvJcblUgXg2NgHqy0RxZP3POJ6fqMPBPV6jRzF8dCGWXIRELb08jqbt+Uji0v+dODs1DGvmzo0a2lqwCdE+iLm2HKrXMV5orLWA5G96RkFUwQP6LPyAQiPFqMtbSNBUUIOszOyuoSsqneeFtSTQK8zHHk91RG4V8KW7Gj9pqphYOFs+Gx53hjHhkA49P+Wr1ntj23dS3YzUik1J9cgQ3Duv+YMe3tgkWZDBahDqHkdvWlvpIBbLY+gb68U62q4sDTljoT9HpzFTdAEzLkr9wfTsmwIWaz7VE+EvAZUpI7Y7D5lCxBfEG4LcNMmBC8BVH2oSOp5EPfqK6ppslk3afLdoEnu8WMvWKWLSjvqdHT/qobdb3j/MYoxKVCiMvOLTYlP1kQdmBvO0iXQoJUImBRRTm1UsIQPXZw5toV72kWKHjO1kgdJHvwHe3knj6WzbolvdC4TgrnGT0YG4sqHTO4OeF0hOs/l8/5YaW2lSjxhaqEuk+VJBYl9PR/TtbAdwgGTpwmFZVJhGIEIHkZ4g/BERdJf6d//kv0fi71Ew65f1Drt8Plnn0hS95rjL+vQ7GlyCljLwGzRNByg3TOK0GsugMLkYwx0Y43r2BiagGkwEYep2GUVgXtqjD/NzNXJKYqDc14RJ9iAfP4KZ4BiLuQzyTtJlvZvvZiaxyxVOqlJkeC1/UH+y+7cxWAAGqGylOM2LpUPHcGjwOIP8O1h0GgutHstTxIinSa1bdVvTvX4cdcVpENDu8avkDOQXNxJ+GAUxW9qfI7JKOZecgY46GhvhjDmC/+EqL3koeoPgpIWbCQvh+1O6ANrbwQ1BAOuq4FnWH/fmXbVRshZJSaJZyHQOdnlujbZclCpTcoZk7AiyqiVdcJabkthmCGUr7ImGL0RdwOFaghmh1527is4sNSzFlDaf3RjvK5oiQ26Aj/Zhkeh
 5EaHe6GK
 qWfdFZQNwCFKT3Su0wyiKA34TGuevjhqNLNylsdx3awhFBRGkDLSROtNH95+4+0Q8A0gfCWB7N+r5kQarKd1CGvPVXhqlSmNZ2Qp8U2MDZqZ2jLRlxbw248WEb5WbuG5FkDx3Hc9NxTO5OgM63/MOP2Gy1x+udMov/VAh4wUL91rZHxAusS80jXUNV/H4RuBecRwn76RQHeEcGxcHzwS/n2frbDRdZT+CsDksP46psSncmbQkWJ0SHVcmhKsKdl/0jZG8jhQpaU2hXbyntnJqWEbEB425iGmH3Uzpe//hgGJq5e3i0zKsf03S1itMKcWdGBMQmuV9D9NC+4PxMxTwjMMGQIBdMukrEAHEdTMMV21gBeJ7niLudAhYGej7FgUjk0Vib0hmeySdwIbyZJejk6hLT3rcUYwyZuaOBQLCCURN1O+y1ojlpNX2zmp0cKL1mMsY/0dafPyjbM6z1dE3WwnAV8h1gWt/8Bvj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.10.25 21:32, Kirill A. Shutemov wrote:
> 
> 
> On Fri, Oct 24, 2025, at 16:42, David Hildenbrand wrote:
>> On 23.10.25 11:32, Kiryl Shutsemau wrote:
>>>    	addr0 = addr - start * PAGE_SIZE;
>>>    	if (folio_within_vma(folio, vmf->vma) &&
>>> -	    (addr0 & PMD_MASK) == ((addr0 + folio_size(folio) - 1) & PMD_MASK)) {
>>> +	    (addr0 & PMD_MASK) == ((addr0 + folio_size(folio) - 1) & PMD_MASK) &&
>>
>> Isn't this just testing whether addr0 is aligned to folio_size(folio)?
>> (given that we don't support folios > PMD_SIZE), like
>>
>> 	IS_ALIGNED(addr0, folio_size(folio))
> 
> Actually, no. VMA can be not aligned to folio_size().

Ah, I missed that we can also have folio sizes besides PMD_SIZE here.

So it's all about testing whether the complete folio would be mapped by 
a single page table.

(a helper would be nice, but cannot immediately come up with a good name)

-- 
Cheers

David / dhildenb


