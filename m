Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2DBDCCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 08:04:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 180AF8E0015; Mon, 13 Oct 2025 04:04:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131E28E0002; Mon, 13 Oct 2025 04:04:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3A9B8E0015; Mon, 13 Oct 2025 04:04:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CB1278E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 04:04:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9432CC02CF
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:04:57 +0000 (UTC)
X-FDA: 83992355034.02.B57F463
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 20450140007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:04:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MaLmcWaJ;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760342695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KPU/lVFbgGeX7/1p5cP3aKk/YeGq7lbFJeEGyMzuGJE=;
	b=V89lWkI2bVkWH/pes/6SkyNl7p6PhVcMXAK/z4j84UFaur8c3LpNmhZZfJsqcMSGOoI8Xw
	QOgeQsiBvbtXkB4OiUbwUvffFMiaH1Vp2OnQ1bPu2skmamVoBWkEQSdATZZdjZ5ICPsj5Z
	UbmeL0TOooM4zcmmb95S/tcj/tJZguU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MaLmcWaJ;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760342695; a=rsa-sha256;
	cv=none;
	b=ZRbluT7QdBoOYPrNRNn+uGu0D9l0N8pFJmU2Yq05XvBl5SbKmJE5xpvhHeBRXZtxBPWCcL
	VXczKa9oICQn7HdTfN1J15LShKXrEki0G8hhua5lewsamZJ+6y74TIBEpBWnHYM4Mq0POQ
	5P8LBwoVrgkQFD9zuDs398j3llFavhM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760342694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KPU/lVFbgGeX7/1p5cP3aKk/YeGq7lbFJeEGyMzuGJE=;
	b=MaLmcWaJcTcqDTpDhV2LZXkpbXOpfQWVjeGIXyL4x7xi5cgxnrb67wsmSwxQUrv797g/gj
	yxtUJxIEjCSuqtD2C4dh+4x1XsgdlcGEeKlcjelYgmjUCh6pZmxlBcO6dPIJlG6f4nPQRr
	7BLqoccOmvQdYSFmSbNkgsLRAjrYSvY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-206-HAoEEEoDPA-dZUKMWdEthQ-1; Mon, 13 Oct 2025 04:04:51 -0400
X-MC-Unique: HAoEEEoDPA-dZUKMWdEthQ-1
X-Mimecast-MFC-AGG-ID: HAoEEEoDPA-dZUKMWdEthQ_1760342690
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e3ed6540fso26030645e9.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 01:04:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760342690; x=1760947490;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KPU/lVFbgGeX7/1p5cP3aKk/YeGq7lbFJeEGyMzuGJE=;
        b=PTwMULW3z9qFHa2r3ZAZazw+yFntxVxVBPVK+t5eLZpJhcAgQID0LyO5Uznw1pAwiM
         4y90nXG3E5VO3aRbzXkzq2YyhiSg+mILiwgk4Zk2KLgFwBN84fOGizsWF8lCbGFasz9C
         o6Uk+CLgY9vPtynvVwpPsHrQVW2eEFW+gFsIbjgKc3Hi/BC87ZQ3Br6HlfnC75O3sVrt
         0//1pA74b1OH84EBLnP2ZL/kwTYdV/tymbn9MmFj0MEAATkNNaaK4y2nhRdaAso3YgCb
         BkKgeZrcUGsgJOYTvpPy5+APZ1YxGKE7OPh85mAqsnhQsPd1RxujQCSEdPH9Nn58as1L
         /ywQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDopndjTLp1MP4knPEn9qL0eFoQG9cTNCCDtHqY5Uij/SYGhLh9O+9roaW5I//qnb5WuOobu3X9w==@kvack.org
X-Gm-Message-State: AOJu0YyL9FTIpxycSDOB4+KGmD5zq8yLTaouaJmkwWunYmJJ17ef74Kp
	pxsjRqDgHHZKaeXE8EJBlCHb1+KyMOC65SGrQmrjYHRv5ozJczflWx2r+GhPm4nK+8jGdABW4/7
	dF7J/vF5P4MQKia42trOaORSyjmY0E+fqFlNEAeWnlSZo8NSnLjcz
X-Gm-Gg: ASbGnctUySimh2aiOafPYbBVTZcZYkt99DoTenP/cuLB0dW4GFviphyDgBD49+reMMJ
	x3HGIQI1AheBWxbLgSfy5fujop+wJ5fHyG2nAqNjKhEQgM6k9QcJR4ZnzVJnVbbU3HZUtS3w5+o
	YzkJv+rrqdWF2uapX+ggv3/k2FGMPpZ9Vq3Zq+qHvZ3PAhLqVCV1A7z0fvysm1l1jFU9y/8ECEs
	wvP4L6SZi4YmQaH5d4kyM6UgmnloVgkBd8TTFUfqZVDreYKFYLCfXRHxQtZ4skk+yTBNdX6ZXhZ
	8YW8YEILR/3jC04Gu5F6OlJOvn30bZpasCyQqB7/lDB6ORZUvfceKwqUfnJ3KwVYWHakRNoJpJ7
	esHE=
X-Received: by 2002:a7b:cc06:0:b0:46e:7dbf:6cc2 with SMTP id 5b1f17b1804b1-46fa296e763mr117303385e9.8.1760342690270;
        Mon, 13 Oct 2025 01:04:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEoP8u8SLxmZzCaUWAaNGn2tFhBdnNdRnHKUPJIoKhC3JsfIivu/FjKUfKsW1+RWg4tjbYaxw==
X-Received: by 2002:a7b:cc06:0:b0:46e:7dbf:6cc2 with SMTP id 5b1f17b1804b1-46fa296e763mr117303205e9.8.1760342689900;
        Mon, 13 Oct 2025 01:04:49 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce50d70esm17163687f8f.0.2025.10.13.01.04.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 01:04:49 -0700 (PDT)
Message-ID: <d1094948-a646-46a1-b11f-2cc4ec53d180@redhat.com>
Date: Mon, 13 Oct 2025 10:04:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/hugetlb: create hstate_is_gigantic_no_runtime
 helper
To: Usama Arif <usamaarif642@gmail.com>, muchun.song@linux.dev,
 osalvador@suse.de, Andrew Morton <akpm@linux-foundation.org>
Cc: shakeel.butt@linux.dev, linux-mm@kvack.org, hannes@cmpxchg.org,
 riel@surriel.com, kas@kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
References: <20251009172433.4158118-1-usamaarif642@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251009172433.4158118-1-usamaarif642@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: m4uuM4zRx38swTcyIILOBpc-lfJJ8jYYpqX8ZPCGnjA_1760342690
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 867p5o9ucf15m3m9j9dh7gwx94ioif77
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 20450140007
X-HE-Tag: 1760342694-97441
X-HE-Meta: U2FsdGVkX1+HOmj5lcFloV9x5PpawqUxM9fYk+V628YHmiru6onpbUtJH28zbLdLbMAhAYTXZVoPU/M5o0P2v/TDjBHOo1iBLvW/r/4DJadGtKT8KwPCSen2uIuNwh0wRezrj+qC1rMChSvXaBPA1CNQPxeXuFMuhEuExZKXtJvlsw2xSOyrCV3pGrVB7HbwISe+i5dkqtB/b6wX6RJjL8UBOV1mZE0SG0rf9p+D0cpSBiL8OwlHSvs9AN21sW0IKzDH/OBqjemzLBHRYoCijLwoe+a+Qrc41o/fkNjWDfbiJjADPL/E7xZSruE7TDUgrhQoau4nRQLGRIir09k5HtIeXHomlIODRPpimSP1owdeQLeLUUFzH2oK23Z3fp1wMGHqnlE3UstbyN7VP5w98xgYSyCj7vCVjaKAchh2ENhaRAVxjRKoKB9LlAqkUaKP+mKaoIG7YqmAg90muA7N3rxHWkdh6WqKR+V/0UUudlECZeCZB9EJwkwbrAmfgKx198SV9LhCHLSjjQdmfK4gybCP8Xc9hqlt0e28L9nTPa7jYcyQR+dxVazH0nhnRNCLHrJHI1EovetPDpgXnGDetBnG2CC7KUj947VgF5WhhgcBE8Mg0Yh7GuF2zy1BwS5bQVYoXELx0uw9GLk/CsrU2e6+FyOHN9V2J3t8pvXRKb3Y5aD8ekpqP2ucumDzq+BrIerygX2Zbf8SFM1xkOkCSKLhsvkRB/R/4vMHyt04CGNqAag1VJ88uEHFudq/rOq9l6hp0yUiJ47TTCVqy4pqjAsRSwZ7+q3goS2m5NKpNk7TlPaGfsm6OycjuxqkjXSg9SZNqXTV36Uk4eaWHViLJ85vthS/QR6FXerO7V5n4QmJLqJICJIcCVdqtgboh0ajD/D6hmFICZpnHMhBlfgfMAz74r4l2FoLVXhA6wOL19AwRFI7eJR+AzcpFDwquV5uuqDD3bLvRHkpzMZp+NP
 PEwSxTw4
 ObkxSYFn9ONCzAcWk0F4NCWFE8ncNlfVdEn72/FudkUZbnqnbwCEoQgQZqgMCisJ0pGDFcmW3ULxfwq0e3O0pOeK//585kpQijnDLzNhAp6lv6Tux3VcRumhPO3E1lFBkPltEdWa/7E+oWLJ5p66WSDsxccWImSCVHOkLZIywphnRc4EiHDDiCNlPHBzRQacWyNGdI6SQ2cAQKTSs8dRheFtGHTX5mbHPde5NfSyPIQ/w832Bw/5dW4On3ET5fPS3rksvuv+nvJVED90oF4EVcCFy4UtXsq+2ELnJw8PbyLla0Q5V/ljF8+92KfQwqa3hKPm1CWtt0duZjjzECW5DjO1ovLgSK04sJbsm21100BU+T+5+KtYusw8JeqsKigfn/UEvGQOHsI/JPQ/N1y/bTVeZaJGu8CktRGvdzqjfKqtYacIQ+MT1DDZux8EU9pTb2QD/UoJy/J3mIKY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.10.25 19:24, Usama Arif wrote:
> This is a common condition used to skip operations that cannot
> be performed on gigantic pages when runtime support is disabled.
> This helper is introduced as the condition will exist even more
> when allowing "overcommit" of gigantic hugepages.
> No functional change intended with this patch.
> 

Wondering, would "static" describe that we don't have the dynamic 
runtime behavior?

hstate_is_static_gigantic()

hstate_is_gigantic_static()


Whatever you prefer

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


