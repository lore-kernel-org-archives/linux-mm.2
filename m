Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C764CCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29B968E0018; Mon, 15 Sep 2025 09:47:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2736A8E0003; Mon, 15 Sep 2025 09:47:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1892A8E0018; Mon, 15 Sep 2025 09:47:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 064D28E0003
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:47:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A18231A0623
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:47:39 +0000 (UTC)
X-FDA: 83891612238.08.A163847
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 260561A0013
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:47:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UDDy05oa;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757944057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qd22CcRHxTz6S9weuM1x7AkdMNNHqOghUEX9jI8G2J4=;
	b=jiyhtPnLEb5HcRYtRCv731B3PmrV3ZqDgAlsosn9LB0DAjC0VVvEhUJ7QlV2hhuG0BdRtr
	Cq7l0I9XdbZWi4uzNRTFdCx2uHfPtgGhcErPIs4UNEX78C1fsn5kEn8u/X2uDRlW/DT+tA
	5+nzgORIrdeT0hMa+lmTGtN8HJ8+A64=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757944057; a=rsa-sha256;
	cv=none;
	b=8HqSKlAvV+RKg/vV6W5wQhvVoP+5nGX6c+76A7FB2bHDjKqIOje2+pMiHD362CxUhuuNAE
	XrrHT9bD++KkdBdU8X0IZfB7bobVeG+zZS7AebCzYOUH64FW9feECag5Cezs4NeHkh6e2W
	V+uy17y+KGZonjwvwOoEAWzoYIbz4zA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UDDy05oa;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757944056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qd22CcRHxTz6S9weuM1x7AkdMNNHqOghUEX9jI8G2J4=;
	b=UDDy05oaH+oESmMed0ol5w1esbudr5gRSytj6aTvX8OkIUyGbCPpgMbrK6LJTFWPBqvxFa
	b9NCCAhTCoTaa/Z64lwmP8KG9FZL+tL1O/sZYqoWUuU5AXsKYNPdJ9rAQZI48tWLVawCmt
	cJXvl3t8RoNrmtYFTOUTh05GBHoGNZY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-2Q7dJaBtPSK4DNc8rM6Wvw-1; Mon, 15 Sep 2025 09:45:50 -0400
X-MC-Unique: 2Q7dJaBtPSK4DNc8rM6Wvw-1
X-Mimecast-MFC-AGG-ID: 2Q7dJaBtPSK4DNc8rM6Wvw_1757943949
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45dd5c1b67dso27140655e9.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:45:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757943949; x=1758548749;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qd22CcRHxTz6S9weuM1x7AkdMNNHqOghUEX9jI8G2J4=;
        b=hM2l8gkMNesgkIb64XqJFfCkUPdrE9E9UxlpxolwTzA++2VvwZdPSOxldwjtoVscWH
         YupD685Zh+4S6J815ZCx5SyoScg4DLcrqmZ4gqaKyMPqz7pwoKNFVUBiAiEQVXu18f7e
         I2IKancJNeQOBPkgJNyuOqE7G/P6bTHZT/FZYApFE3qZWELqTSVdun2+vGacgXkckozR
         qe2tXXR2X6are4wvk4iuxZF99uNOwNBlJCh9SnNb+X/7Pu9lcgLUK2EhOHEoNbSnS96d
         w08TMxEiAxgDLhReLY1y+wPgLgfUm7yAtLu7XuAnHvukNrIRJQ9Dr8i67PNvswP/8d6/
         B51Q==
X-Forwarded-Encrypted: i=1; AJvYcCXvHevxxQeOXmp5BmxDAHWk8PPLoImVhzIzYU3fEPHrE+uWn5vQPEzoZ1ZHIj30xpdKukf2E+3JfQ==@kvack.org
X-Gm-Message-State: AOJu0YzpAN5/VTvfSd9hDSpnTwKjzh8JyHTWcKi01sSMTaxCsTcB4MEe
	U7tgL8eq2gmfatvNV5lnAEK3x/362FkACxjmOvgVJsK+BasmNmWMMWmoRLj3pZTfdtPdfz84lRH
	YXBjik/6vmTIdYC/ubsbsQzOp4RcKAYMeM2JAuBUnynNl+klrrI7r
X-Gm-Gg: ASbGncuKwu1aiIjWL20A32KtBgjpof2NUwx6QZa16C47UHtkDbtR1bVsb9jwtLu/kvZ
	n+iFN460fMHAi1/cjjJRGPsGNiJX8cotTF0y6OlcymGexUnVEg5NzZYNcbzVFitkrI4TuDJVwct
	TybqlCCv2xsnaJglPFgD40HPHaqJvom/bTH9RKex+tcdGaHkrbTH0U0UBrPQRMYMs+R5+q/96PE
	7UGeQcWFH6efuGpAXNGi0HkFa6tLP4V+tX+mQYpr7vm+hcwDyl4XLedrl/Z/1NO2ou+QcMvDUju
	i6WpiHwG021kMpb+Ycdb5bHXGPyxbuuTWx3C+vH0RS5lFZYJjPHs7JjCVfxMyKDRw53udooJ437
	p/Ddi47lzseI91hDSv1ylrRQAZjKcQqVZou9xAuSA3r+Af9fDY3oQ7gyPsn1WEJ04ERw=
X-Received: by 2002:a05:6000:438a:b0:3eb:5ff:cb2e with SMTP id ffacd0b85a97d-3eb05ffcfdbmr1834609f8f.29.1757943948980;
        Mon, 15 Sep 2025 06:45:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFLyX6UvLCuUUA80n4GoWHIr/EyUeUL4oLh9hf7GfvHPwfVKVtA1c+Ma7f+eiXJQjtzYNjOg==
X-Received: by 2002:a05:6000:438a:b0:3eb:5ff:cb2e with SMTP id ffacd0b85a97d-3eb05ffcfdbmr1834581f8f.29.1757943948471;
        Mon, 15 Sep 2025 06:45:48 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e9a066366fsm7321173f8f.44.2025.09.15.06.45.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 06:45:47 -0700 (PDT)
Message-ID: <2b13e434-192a-451c-a09b-69eb92392a3e@redhat.com>
Date: Mon, 15 Sep 2025 15:45:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V12 0/5] riscv: mm: Add soft-dirty and uffd-wp support
To: Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
 linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Deepak Gupta <debug@rivosinc.com>,
 Ved Shanbhogue <ved@rivosinc.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Arnd Bergmann <arnd@arndb.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Chunyan Zhang <zhang.lyra@gmail.com>
References: <20250915101343.1449546-1-zhangchunyan@iscas.ac.cn>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250915101343.1449546-1-zhangchunyan@iscas.ac.cn>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tbAzucW6fW7EPfC912BDhcdR22AQtXUh9KDeaDICKQg_1757943949
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 260561A0013
X-Stat-Signature: wsskyox7a1mu91yjsu8d69autcy1hr5r
X-Rspam-User: 
X-HE-Tag: 1757944056-995127
X-HE-Meta: U2FsdGVkX1/X9QJ1gzj4BsEJGB+Oj6zrx2xQH7ADmR6B90IXK9We5ApW9JRrVUy0O44VanM3FSYmF1JK2PQws7Yq5p1JOvhgBEC7Nn2QrSwZhqy6HkZxP2o4ahx56QlUdOP+1yyDjpZZMII3nitWExyL7qG6A1YF8YKaHo7VN/PiFmWRH5uKuuT3OLczVqCehQGSdu+avUmZ/9Vk5b66l0YKNT9K26znwe9orc/kfbD8V5o2i1gATy/vBwzhjw8P7wvwrQyhMvOrKB3/U6Qhj55rg8zgPRj4tvSopmRiR7L4W1Pcex76qo4CUyZNdQPW6iHdVIcQmBSwThvFaBLyC6w1LsFd42dxTxEh4B4pc3k8Xa148kG951/U9GDtG8nPakvVOUtCKRVdsuI5twAYDPQ5aIe7X7YIpUtvUD+L+3nmQPUNrqIjKxvy3Q1XUQLrNSN6VgAJa67PHXeCnARfqI+jHuXzS688eWfuL8OhTmzZckLbOd4RgF0ENlvCl+2iqHC34bSVEzio8+kQ7ZaHU9Pw4ZHc0BV5HauD76V9hvIZcfheiWM6OVFyp5YAbZNjUx1P42t8Nx4AIqUeLiSn1js22Z7g/jvV1j2kDZ+P+WmFqWoc1AlXoil6sXpKJQf5ZM9it7Lo2dH/YAgsC+kGOFHzNetRz95dPYqyGPBGQ8V2dMem9P3a63qw2FYEOkQghjlvjz8XnVoKmpVSp+arepYL9gu9EjksSbOMSy4ZMQhhq89U7O44l3KoAQOi84ZN1mW4oscOk9U3jdb7qHywpBr7lwBqGZSSpktfHvwS2Dg4vys7Pfs77MmusYkhXbPynlH7RZZ1pYWv2W/PbzdEv045mZzpQdaFd6p9Gc4lUYZ37Kri++uO4J5ac93IN1DKG2a0G5z/zTo/dfeQYG4PnI5IzG6g0H8Gj/Qow90y8gG3SLph3V2vqB4u1XuRBTL5S5pnSTllcLBWtmBRg9k
 agH74J9/
 InTNZS5DMhCJehe6aEPUh6SNlePdBoaDYfqz2SDlNqPLeGxSVrlEquFTzdR24GnqUi6I2qQyTvHJWGzZlRMlKv74Hzf04LTCIv5jAfYy/xWYysfMqY+KbWawmhzt0AIQaaaUUex9xWLtCf9UHLp5CDYfPfF+AaZ7c7hDANxZPRaexL4ZBDuA4kBWBf+G3bLemymD9sqS43K5F67yz2tB7/5qcpc1ckIUOPGFUv0jPdRFAl8xu9WhqTQQlOrO0RSXF9LoyQEKO0DQPxHlRcIRNfj7Zz5ZZshP6mz/QtqcGnIJ64mQQvvLrun87is0WNeyBUqQJHHz+utbIzJT0ZIUNbjeQSN2+TmH16lVlNcFvbehGb6c+JYUK31ZVsro/JgZDKK7wLLWXRTeu4TloI+q8vdp6tgkQSQvt8pIftcU6/87aAJA4ke0mU9+2QfaqWCIRdV84KZozVx8Jd/EeK7giirG1igZpgSdRlDsjipjY4g/Lk1zrah5ZK0sgRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.09.25 12:13, Chunyan Zhang wrote:
> This patchset adds support for Svrsw60t59b [1] extension which is ratified now,
> also add soft dirty and userfaultfd write protect tracking for RISC-V.
> 
> The patches 1 and 2 add macros to allow architectures to define their own checks
> if the soft-dirty / uffd_wp PTE bits are available, in other words for RISC-V,
> the Svrsw60t59b extension is supported on which device the kernel is running.
> 
> This patchset has been tested with kselftest mm suite in which soft-dirty,
> madv_populate, test_unmerge_uffd_wp, and uffd-unit-tests run and pass,
> and no regressions are observed in any of the other tests.
> 
> This patchset applies on top of v6.17-rc6.

What are the plans for this series? It fails to apply on top of 
mm-unstable / mm-new, so likely merge conflicts when merging through 
another tree.

Likely best to base this on mm-new and route it through the MM tree?


-- 
Cheers

David / dhildenb


