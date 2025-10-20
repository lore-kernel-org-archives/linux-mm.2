Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96070CCD1A5
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 09:13:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6C6B8E0013; Mon, 20 Oct 2025 05:13:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1CFA8E0002; Mon, 20 Oct 2025 05:13:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0C3E8E0013; Mon, 20 Oct 2025 05:13:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 99CFF8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 05:13:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4328BC0749
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:13:43 +0000 (UTC)
X-FDA: 84017929926.05.B163D7B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id BD6EA4000C
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:13:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H2mBd8BG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760951621; a=rsa-sha256;
	cv=none;
	b=MpSOeLk8b/xG/KhLdMzJqb9ZXQ8cfUJ50VjLnRdVNZur/EZAuwHiHkX4rzujPzeZYg7m60
	uneTBZWmG7Lw4++Xr11JRDAAj0Z97XD+bi5y9bzTx0nQYNbPGKuqNTq2DJeUHuD4MKSJ2V
	u5IQ2TsdzjDrfyXZtMh5oiWy3g640zk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H2mBd8BG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760951621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eh0wHwo2LU2FIRX9AhMX9fHbYdP7OvIPgfEQ71tVBzI=;
	b=IE9tTwXgG8jLXd2oidIyf1nqYRNXL2FkkfCrk5fvPFSLZq7dAT6DK3Bij5Z7y3ybZ6mn8m
	Sd1dvfG5katLlTQ5zaC9yk1C5VWwG67OcXWxYIevWpYs8UmW7NnyRU1EhQ0mxR276E0LQ8
	mTHAg/vZeCfbY7HDD8TyN9lgaWLVhdg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760951620;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Eh0wHwo2LU2FIRX9AhMX9fHbYdP7OvIPgfEQ71tVBzI=;
	b=H2mBd8BGI+0Bh+38SCmJ1+oXxzxITNcbL+jg8R3MX0B31keBQU0aVoleJhusWmhb4tCVlI
	Ij55qm7ZKncDLcMh9uMcPXglLsbYT2X9sXDyB2wq00nr1GQxUiGnxUkIP1ifK/fHMj1gI9
	KTlRBm0k8GniLgLKuTijlmHNoP4YZLE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589--QAKsG4DOK6I-QBwOQ3Bjg-1; Mon, 20 Oct 2025 05:13:38 -0400
X-MC-Unique: -QAKsG4DOK6I-QBwOQ3Bjg-1
X-Mimecast-MFC-AGG-ID: -QAKsG4DOK6I-QBwOQ3Bjg_1760951617
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e4cb3e4deso14512555e9.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 02:13:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760951617; x=1761556417;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Eh0wHwo2LU2FIRX9AhMX9fHbYdP7OvIPgfEQ71tVBzI=;
        b=PQHgAdG2GtDlwnRwXaWfYW9QXX6Q9wtGzix7Yqy2be2oiF12Hbs609uIDPdTsPN9+3
         mb57PW+GziTGmi+/i7NSimdDp1lU0eonDrx7R5VqHZ4W4brV4dH8ePrKS3QuHcj8h/ta
         nz7eHfBhQo9nYjZI/xFzwOMs0hfLGC6z3F/eR5HI9ryLTeumPKY3LfMx1D/Vq6/3dXB/
         0b8k0Wy7Ss1EAkyKDmweB8b+mjnaoSBbsr6kHknHeecqd55vLW1uJbACXicez1Qj0Ykj
         uh42Ms6uIn9+Dqgz+DM6F3Kw2TP1jAUkFgT815s26TaVvBcvZai7Ud56lJr649s6nx2k
         2vfQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnjIbSyCFPBWa8H/G4XfqwUO3AoNH/RGXFlQDl+SX+C+u6iH2/iuy+2A3MOtKyBwhsxBzpF/uuOQ==@kvack.org
X-Gm-Message-State: AOJu0YwwTU5XFbiLJACXdru7ikmUfOh8PRMDLqJvS9W8+s4PzxgWU/E7
	B+C3Vb5Sq/G3ayhhcRAePH5l62dTalUBQoilf8qUTOqzh9Ffc1Bt8K4LtAULP42qjZSrbxeXg6S
	EbWRoRfGkbBt7ndOt87awUzpUsjNpOJRK7VpMUM6G02s/e8WNGQrbTKBZkrZ/
X-Gm-Gg: ASbGncsgsERKC8B59Y+WI2PI5wGSrga1yYzbX5cFk0zLTJZscOgrfqES/NHtg55ofWc
	F4P/3HeYeERx8LwIxp14s4ufWDDJRl3wb9zaLi2psrBd44tr/zFa0Ms7Sg2+u3/BZ9iYCo+C+5M
	cXTYiREAodLJd0C01K8ahBXkzhix6lS4BFcIWgzYEhMlwlEo1NSb1+ZXQ5XC1rOg6c98ZKWa8N9
	YYFbnHfVhMRl0BUyQ+2sR8R07bBoPIqNfrm2brhZmxoivTm1V3cEhvF6rYCamcqZEVqOcIm4Qwr
	ACNMF5SaP0XN/tod9nwj7VrsjGLAwdYqT90tQAJ2QN28MUCZZb+y8sMD1NbAh3JUcB4N6NOrf+s
	8lyN/Au10Eetz0BTFe+EGLLbJD8kZcKmb9UF11GWz3S8yMBLjGZ3acteXHBkkA2GgvnsGpdg7E4
	YrZ77KHvAyrxLvYJ1XjSp+fdjNn64=
X-Received: by 2002:a05:600c:3b98:b0:46e:6339:79c5 with SMTP id 5b1f17b1804b1-4711724b354mr119191825e9.5.1760951617110;
        Mon, 20 Oct 2025 02:13:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFME1ceOxJyPsxu5kjPbUdJ41bH4P8jCHFCQX4VPWwz7nZ35nqwnC6x0CCerHmtu/XFIG6fA==
X-Received: by 2002:a05:600c:3b98:b0:46e:6339:79c5 with SMTP id 5b1f17b1804b1-4711724b354mr119191525e9.5.1760951616638;
        Mon, 20 Oct 2025 02:13:36 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427ea5b3c56sm14482749f8f.18.2025.10.20.02.13.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 02:13:36 -0700 (PDT)
Message-ID: <a95df2f2-5ecc-4d28-9bcc-1f9b457b04a5@redhat.com>
Date: Mon, 20 Oct 2025 11:13:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: treewide: make get_free_pages() and return void *
To: Jiri Slaby <jirislaby@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Julia Lawall <Julia.Lawall@inria.fr>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251018093002.3660549-1-rppt@kernel.org>
 <aPQxN7-FeFB6vTuv@casper.infradead.org>
 <3e798b9e-4915-404f-9197-ed3c32587141@kernel.org>
 <85707316-3f2b-4e29-b821-a32f9097244e@kernel.org>
 <635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com>
 <3b97b754-890a-46c6-b892-a0324d529a3d@kernel.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <3b97b754-890a-46c6-b892-a0324d529a3d@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nD14GXFbW93FIdmQ0g-NoVW9qfkreiB6MtTa-gSncGs_1760951617
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fednmom5eg5bnphrrpcs4baqz1raqoid
X-Rspamd-Queue-Id: BD6EA4000C
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760951620-989306
X-HE-Meta: U2FsdGVkX1+r5wvXNqNsHTv1SZfJ6EYD20/wWb5y39+4nBb2WeyM8JWGEz/h+fu80tDAKp/UsghXSdTf91imSG77CVdRvxbXC4sf7z8GlPAPHQA5JMyigahJg3g4mljgoiJoPaeBpTHfeE3I1rzEmWOxFNKZjLwyAeSLrl1zstU8L/AP+lsmAMAcc0WeV+NQEWnUuoKWjTpymMFgm7rvG8s/4PtoI2n6IaGPPf1vK7FL8zI+CoChBE338hUP5Ui6LQvsxy4BhCGtilLQ7OxMr5QzQJMpYz6e9hex5ncU6/tTlaq2bZAoKKkpHU3xiRGQqoDASD2pB+TaeWAg0SSyR65SrP+UIIqW9uNJQB7NRN/XFEoXRhBObEE3OjhkXfBOsB1m68IXf5cby6yFQs9ts5w5TES/oTsLOOLZrBmgE8StNj54QS54V396pqkLj6wl4oX5DPNty9wPswvpN7pRlkpqtTCNHNmMUzuhwtguXkw9kyvMgt9S7/Q0VBY737kxMqNS6PZvfc6UjOtvdR7mgGNppg+Yiaac+sm9IqH8KbTObhjEGqF82YWdD4hCyj1VVrjStZszHpp6P2LOP3m4Isu8JPkns591uNMWxpGOBnZuvhtrUb6npbRZEcspQoatnESgNSsVrvv0qaofdSgrcBS85oX0uplK6w16b/TJkijO8HqucIC9Iu3sE11m3meUnGH/UuqUf6X1Cn2E5y6FFbPgOmF7Us07gWCXdRAlflm/44FnSIV6SkCSRrSRtgoNETYdHDQtOZEi796V1d1eYtsBRp1z5w7Kyk4wQNHzaJXBNjAUpwzoDxLzyle+54hYPe/IuN1kW79Qf39dnFuL3SQomDkEK7IBkZjRWrMol56y+hhxAIaUKXSJ9wRO27yehd1uspRyKYC54v6TS4Up41Fhh0STJehSkbm6nltya62XkQA97/P0NWc81W3U353cQyYStY1NaysHjUEQmD7
 06372WFa
 m79JtFUx3bSCvb37mzEzvJm+HOJ0J1K3RQ+1ybF2XlDvfz76vJrHChy+MKc9lSM/khQksZutQvELRj7nhMw6JlcVNl4o/TsYPNMuj0e7XnbtTJl1gn0Nlmy0pcED9ZCQ35N8hQVVKakgq3E3vuMkaAmnb0ePW6MT9cNr9OVU0nUAzdy6cEXPdspfztUibzJ+81iYJ6CM7IzFx+47RGZysrIvpQUpYIXRoAIznugOGPVx5lfE5zF1TjiP25LfZReJ1xc1AEOAt/e8O3nScGtKcznMTLqgTirJZTtBODyDE6BPponbSZ+N+V6zUzfuTvetm62i+ulWyPfSUSLMcCYGHWvRtKxumTKXX0otb2dWYIlUngq/mg2ddXNe6ZzWRj8H1Osnzp/jHqZKNS47ZeEDD3Uah65WMT2igS0o3fct9JrWfl0p5rvQRxgPBvez1rH1fVpDgb6DO0yVkePpSPoGwuAtJyoFzVnoWE5f7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.10.25 11:08, Jiri Slaby wrote:
> On 20. 10. 25, 11:02, David Hildenbrand wrote:
>> Regarding the metadata overhead, in 2015 Linus wrote in that thread:
>>
>> "Long ago, allocating a page using kmalloc() was a bad idea, because
>> there was overhead for it in the allocation and the code.
>>
>> These days, kmalloc() not only doesn't have the allocation overhead,
>> but may actually scale better too, thanks to percpu caches etc."
>>
>> What's that status of that 10 years later?
> 
> AFAI skimmed through the code, for allocations > 2 pages
> (KMALLOC_MAX_CACHE_SIZE) -- if size is a constant -- slub resorts to
> alloc_pages().
> 
> For smaller ones (1 and 2 pages), there is a very little overhead in
> struct slab -- mm people, please correct me if I am wrong.

If it's really only "struct slab", then there is currently no overhead. 
Once it is decoupled from "struct page", there would be some.

IIUC, I'm surprised that larger allocations wouldn't currently end up in 
PageSlab() pages.

-- 
Cheers

David / dhildenb


