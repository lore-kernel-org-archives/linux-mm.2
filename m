Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1057AC87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 09:30:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3B2E6B009A; Wed, 30 Jul 2025 05:30:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A11586B00A3; Wed, 30 Jul 2025 05:30:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 900396B00A4; Wed, 30 Jul 2025 05:30:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 814076B009A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 05:30:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5C07D1DAA40
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:30:29 +0000 (UTC)
X-FDA: 83720410578.29.3737DA0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id D09AB120004
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:30:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=df2bNVT9;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753867827; a=rsa-sha256;
	cv=none;
	b=Df3dvGIpC0g7rDTYNIkDnEBu/yR/EmMWS+MvSIsZlFC4vEkfn8q7Q/oT59uTJ3OIOKZFqh
	fkNrfHVHhO8z8ZAMndFZNNv1xlNu+vHcNkXIPSo4Pb5VgfNQcspOij0HG2LDCUjOoSj9t+
	cAXpIVzM1NhNAZqoYis6mMA8Yygi60g=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=df2bNVT9;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753867827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sQoSc3uTIHO11Q/Y+3M9cYKzxEMFJgl+ZKCLZTEtcGA=;
	b=petZxQECiz5gX0ETomZnvpF9nXVL/YIlg34vIJLdAyZBw2w5fa0zK8XIkYoorStpyFArFz
	+eitwomGLPQLcTitxJZAgOL6+FT0T2NMzm7T2QsHhITU/pJ0eN1B2WvibTyTGyqiECOcuE
	aoUhc1P4SICQO5RrVyn3JBsQiN3k5YM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753867826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=sQoSc3uTIHO11Q/Y+3M9cYKzxEMFJgl+ZKCLZTEtcGA=;
	b=df2bNVT9m0TVJJkqZ4ujTXjRHkOebSKd2911IwWZe5Y0G9c3PDWJRgbf5R9ALPPxH6VzVp
	kxccsCgjhV/nHv/BhRQKvuJE8W4LeJi44JN6POnZMTn/xNOdH77kTC/Bv1BMM+nW33CBJh
	RDE5FRLSh55nftWJIM+PKPgbfO3KXZg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-sWiAzxkoM6-gse7tmTiJNQ-1; Wed, 30 Jul 2025 05:30:24 -0400
X-MC-Unique: sWiAzxkoM6-gse7tmTiJNQ-1
X-Mimecast-MFC-AGG-ID: sWiAzxkoM6-gse7tmTiJNQ_1753867823
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b78329f007so3840157f8f.1
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 02:30:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753867823; x=1754472623;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sQoSc3uTIHO11Q/Y+3M9cYKzxEMFJgl+ZKCLZTEtcGA=;
        b=Y4h4g552yRsngr2zoZLuam1IqAG+1Z5PsS0zGtL5MDYxG36joNfl2rIyyd6sS58RfB
         F1YAxK5eZhvjF45xfUdlhQKmGrNUJHCwr7P/m7tN9I6h2HMMKKuhoOCWB5CevvRV43pn
         2bJF9Cm5641nHzW4kgztbAFzNOLc1tWl+VapihVL1jqaoZi5Sznlr3vyviErpWaUrv7P
         dHI8nUwPCqEoyzLrS1EFHkhqBQ8PCQ7y41U3vlXTaoSCws6XOmfKKelUIO/VdM/10sQA
         /ZtBfULuWt5bo0mH1+bZr4Y0cKM6wiQbernkJOm7m/nB9BsTBFIOUq8txNuMt+4hFRKf
         uH9g==
X-Forwarded-Encrypted: i=1; AJvYcCVhU2N6TQke1gINt6hngmxUcFemKHeQTF1fZLDgo7UsXNsw4vGS9/7PQ5TxXw0Jmrwi1dOaXjZTxg==@kvack.org
X-Gm-Message-State: AOJu0YzkUfRi5uRPCMGyhp8R/8W0045k82H1EAN0gdOAStzJSztyfn0W
	Wlv2/Jr8E0ExrbpIy9pt+ESAfTWNmUC/1qzX1/cwc9VqVkw2ehQ7YmyavvOI58wwL3JvLd1LuiG
	s9rG72yaFKZfkjvDXbUT66soROI+O13RZLePPpMdDrfdJxPuRUixC
X-Gm-Gg: ASbGncsjfwa+Z3e20fx83m7HlMyZS6JGlXIO8I73bxllr0/NdjgL+M397PBdMvnWcyP
	xvu5eYLPheaVIFMyv+9LbbhnUkufBiuOC4kTCfekoYKG6XZXw8CC9Vz3TtgyXAVIdX6XaziMJve
	ExHZXbVsVbFz/Er3u5xmCr1BxeWPF3wNU275Q26ToSdJZoRkw5dYdYnk6OZDiFv7ziS6cAU5Ild
	N/ac8bOsnPLlVjOZDWVB1jQ7a2v/P/QtNo6HGB6NVkEGL4r5ud5RxlRk+4J54ELf3V5yqf3UUa3
	tIt7XnWPW1A/xPXYW1B8j1HzDVQ88ZBLCwkVwGfAVCv+1lToEVEs+ubYVqSBwA==
X-Received: by 2002:a05:6000:2508:b0:3b7:8b20:6fd6 with SMTP id ffacd0b85a97d-3b794fc2b6bmr2170421f8f.10.1753867822732;
        Wed, 30 Jul 2025 02:30:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH1zXQsSsy4uimTG4SYCl268lNUyozGT87L3/S/XA4SGUEUoAEnG1n695zgsFbOoxviY57dtQ==
X-Received: by 2002:a05:6000:2508:b0:3b7:8b20:6fd6 with SMTP id ffacd0b85a97d-3b794fc2b6bmr2170372f8f.10.1753867822248;
        Wed, 30 Jul 2025 02:30:22 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b78ba267e3sm7317566f8f.59.2025.07.30.02.30.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 02:30:21 -0700 (PDT)
Message-ID: <0a689e9f-082b-497d-a32b-afc3feddcdb8@redhat.com>
Date: Wed, 30 Jul 2025 11:30:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: shmem: fix the strategy for the tmpfs 'huge='
 options
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 hughd@google.com
Cc: willy@infradead.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <701271092af74c2d969b195321c2c22e15e3c694.1753863013.git.baolin.wang@linux.alibaba.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <701271092af74c2d969b195321c2c22e15e3c694.1753863013.git.baolin.wang@linux.alibaba.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: h6Ux49k_2iKIpnRbKWkoA0ZT_ABTxdLkoUlqYw257hg_1753867823
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D09AB120004
X-Stat-Signature: 1p7pth6z1n8zbwme8f8p7bxc46o6e9co
X-HE-Tag: 1753867826-433440
X-HE-Meta: U2FsdGVkX1+ZQbiJnHin3L+/IkyFcZTYAYjaEB7yjDw1180fS4xMfVtfI5enzAFhuKVRzJQBULrp+PJAUbSox6CcqgVCz8hn+/s95WsdmiEoQRT/7pvh1fc5FV7zuve8i+CWzZm9ITx5cl3gIev6v13vVPKXlJTw2V3mVYH+Nrw8F7Q1FWAIwb94KVXpIeQwi09Caq9qtazgzncAGis9ai6Gt+xLj7eYLrf6Vu6xl4PIqA1aruZEMiNOPVki+0TFNWeaAVX2CBPjfNOGFoz3pH5pV3fEsZlXVDgpgtgq4qLOBaQ7DrLRqGYeI328E2BLb26O23IV/DJ664loxemfFDYUlY7+yqh4ZO694kgw+uV5ZuUusOJCiTrmpPDEhoqn8fd1BZn+NBjySjnund5SAxxwa94+Pl9yxR3ixo1tqjK8ni+IKszLdAj6CntRCGyP3Jg4brKm4ffw8TBbacu+BFl+pIgyx1F5TRYgp9LR8//6+WyGuvaWPLs8XZINOE/5vPuJEe4MVkiMAxUpaZBUhs35OdDJWNm3m7eHRRjAxhr9xdyIyHMzSuEYBx3Ld5/JPc5Le2tDfsuD2LCR7Fnd1/uH6McSn922/cWFt6SieQ6v6cPUEPUcvkKMGzpGRU2N/SfPd9d1smUMWBjpcFpKCchIcY3luk/aqcoWYi4piBskR+wNdSZONwY2IpCJLBZCUX30TW+1aTtiVtKUayVWVbE09JQqXo3mHQAra0eW93upc1HbvBbhkkMTSPJVT/vPQ04qJgQDg/v/bQY4mq6/m9d+88cPl2pdvRVuD4Mvz8x+Q0LFQ0GkOHiYQtF20uZd1uU9arbxzKFjjhBgCygR0Xdi+YKWtdRZKIyc5ve9L6QzYYfbiCXfS/BxNCnN5wAm1U0hfFmItaHsMmtCtdyfkI6kPek3NDnWSLqxy70jflXYLC0KDtEfc3/n0AEiynujpxfs0k8047ti1VtAFjf
 VwfRuVe2
 wxwKxnR3o2nspDvQ99UqOsj2lDjbWsAD7X2BmIq6kklue8jjkkMVQSWfq1xtf2ig/ERpdMrCwQ8rPcWPzZIoYtspYZAb7fcYaZFz1FrhjKzE3EnOmZkfIQm569q1E7ohIQ7bdvGVzkm7Rkx76xxE2FMd2vax82k66Fbxgh+lg7eGMLwTi62+I2ho59P/0siMWtQLjYZhf3kOLcKw9lXmBpjp2Nv2cMYo2yzAQjkIFFFhtgh18kFDiKLbL2yWB/sNuJNUBnh3cadbyWolKQYdub5dm1h1isyvblovgN+iyLxWMdclO/2ipymQ1NWgr+ef4cTkow4E1Rt434Qwt6hOte0T0oBp0Qe77oTNJctXevxp9uDWNKqkCug3LoIUBUjfj8OS96dFom+gAKKrO+wfJjFHVCrMhwav9+XSRwmN+TSyfFLI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30.07.25 10:14, Baolin Wang wrote:
> After commit acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs"),
> we have extended tmpfs to allow any sized large folios, rather than just
> PMD-sized large folios.
> 
> The strategy discussed previously was:
> 
> "
> Considering that tmpfs already has the 'huge=' option to control the
> PMD-sized large folios allocation, we can extend the 'huge=' option to
> allow any sized large folios.  The semantics of the 'huge=' mount option
> are:
> 
>      huge=never: no any sized large folios
>      huge=always: any sized large folios
>      huge=within_size: like 'always' but respect the i_size
>      huge=advise: like 'always' if requested with madvise()
> 
> Note: for tmpfs mmap() faults, due to the lack of a write size hint, still
> allocate the PMD-sized huge folios if huge=always/within_size/advise is
> set.
> 
> Moreover, the 'deny' and 'force' testing options controlled by
> '/sys/kernel/mm/transparent_hugepage/shmem_enabled', still retain the same
> semantics.  The 'deny' can disable any sized large folios for tmpfs, while
> the 'force' can enable PMD sized large folios for tmpfs.
> "
> 
> This means that when tmpfs is mounted with 'huge=always' or 'huge=within_size',
> tmpfs will allow getting a highest order hint based on the size of write() and
> fallocate() paths. It will then try each allowable large order, rather than
> continually attempting to allocate PMD-sized large folios as before.
> 
> However, this might break some user scenarios for those who want to use
> PMD-sized large folios, such as the i915 driver which did not supply a write
> size hint when allocating shmem [1].
> 
> Moreover, Hugh also complained that this will cause a regression in userspace
> with 'huge=always' or 'huge=within_size'.
> 
> So, let's revisit the strategy for tmpfs large page allocation. A simple fix
> would be to always try PMD-sized large folios first, and if that fails, fall
> back to smaller large folios. However, this approach differs from the strategy
> for large folio allocation used by other file systems. Is this acceptable?

My opinion so far has been that anon and shmem are different than 
ordinary FS'es ... primarily because 
allocation(readahead)+reclaim(writeback) behave differently.

There were opinions in the past that tmpfs should just behave like any 
other fs, and I think that's what we tried to satisfy here: use the 
write size as an indication.

I assume there will be workloads where either approach will be 
beneficial. I also assume that workloads that use ordinary fs'es could 
benefit from the same strategy (start with PMD), while others will 
clearly not.

So no real opinion, it all doesn't feel ideal ... at least with his 
approach here we would stick more to the old tmpfs behavior.

-- 
Cheers,

David / dhildenb


