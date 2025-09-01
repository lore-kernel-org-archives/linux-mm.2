Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97713CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:32:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F38DE8E000F; Mon,  1 Sep 2025 04:32:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F11058E0002; Mon,  1 Sep 2025 04:32:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E26288E000F; Mon,  1 Sep 2025 04:32:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CFC1A8E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:32:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 70A61C0734
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:32:20 +0000 (UTC)
X-FDA: 83840014440.01.EC757A9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 06CF040017
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:32:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q9Qsezr3;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756715538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b9B2xf90wwGP2Dk53DRRs4uSfHtCfs/QAaO9nORyKHA=;
	b=UkGn+zIpZUUMjFCZsNtYPybznzaP5v6KV49DBOUZaL/IFyGbSRb0olxuDSyF0LYDNRJCZb
	RMaYwI6WWRdHkiLXwxeXqZM4gVMDmUr/eYiV7sCkj7lLgrRFg7dtaIVsR/sKWAi6B1ZH0c
	GZc3UogDXsq+yBZK73ph//pu5blaVEg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756715538; a=rsa-sha256;
	cv=none;
	b=N0jdzpUV7cIgSkVliyjmhy2Qg0ynleN2qJ/Dx3DioRlddQ7BjRxcaPXY0Jm/otgX6kuNej
	+0rPfEjneQdF6oyJGlf4ZliZ2d0yKpb1vOk8fqccwzUfEPciCIBJeXWEQxqbDGcLPFt/7Z
	rRCXCVwDMxo6ub9SN9MsbsXDnaz/OuE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q9Qsezr3;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756715537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=b9B2xf90wwGP2Dk53DRRs4uSfHtCfs/QAaO9nORyKHA=;
	b=Q9Qsezr32ysQofI4oxHAb5zPcVwNhrbnt5pU7lBiNDqEPYutpV4kpcAEulydkubl7qDVJB
	AaSYfdP062U+MY8AWsXqNKukioWEnq9Sfah+jKvoR5snHS+B048TV0H0giKnDTtX1gTZe4
	TtR8TgAU9gO02fCdzpnhtjNUGqZRVWw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-tcZuSWS7OECSEjp5kTzGlA-1; Mon, 01 Sep 2025 04:32:14 -0400
X-MC-Unique: tcZuSWS7OECSEjp5kTzGlA-1
X-Mimecast-MFC-AGG-ID: tcZuSWS7OECSEjp5kTzGlA_1756715533
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3d48b45fad0so791567f8f.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 01:32:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756715533; x=1757320333;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b9B2xf90wwGP2Dk53DRRs4uSfHtCfs/QAaO9nORyKHA=;
        b=Uv/xZC7F3MxR/e8bMUpVeO2luXHSjLBkCkiZN+Z+57/j0yQLradvslYXAZ7UPbfD2i
         HLpxlM9tWMKNBECohl7l8d7ALWKBQqAKyR4HMq0hRFF/GjMsxA+KkJFohUSF89fxahv2
         Xt6P4V9/P+ddHGDRl/WRYd0IYxB3t1xoeCXJ70kbniNv1yWNYA8YofD7OwbOoqjR38rt
         II8S09NrNo3CfbbYFcsP9mt6XE/e9haY4y6CfugiWhpfRyKbNK3Ag2E/4CQPNMzPoerZ
         h4WhHToEZsooYhq9LmoXaCvNUSzYrF/UNGmdpQ+mwnljvKumyR4IOCiP1nhIWKwjhUx7
         kvWw==
X-Forwarded-Encrypted: i=1; AJvYcCXbxmBGnqmbsNMyO53NFyIU1d4FpwePYcOLN4uYfOqr0xkM50sD3l6nSWPoZvtSQc58nrTZVahDVQ==@kvack.org
X-Gm-Message-State: AOJu0Yxxx56iLalBkYbtXZRB3sAG4NyNMD4Wf4jBNjs0jFtfx1F6kUn1
	AvMfe+4kwFk8ALBbGaby3zw9tV3kSjIpyiMmMESyyCt0ypsnaA/W+FuBwq2d1Sa18E3g7HOxPHM
	UKZ/qu72Ujk3vog6BrcdgIHnkPorUAgKDJOT2dDn0/BeMK4gAnalT
X-Gm-Gg: ASbGncs0DRUDPg5ZyasKglEbyVapSnv+KdMMfkaEApWSIrXI53VM50xeWxuXtV5D6nP
	C+Bqlo7weNeNkA1i3sycbPxTdpxnmURqV4+bCylL7td3K1ovEAyu2lHlWUQfUJVh8KYcnUXzRsG
	8d0nh8fHJi/Lo9nLi/O87yh0GxMOjkuoiOz4LiIBAwGNagtMlnAMLP4dhFdaJKu3J/kUqAUDzlF
	ZorMCeX6sH7Dry7IcR4lD0fNV+WyKvIsuvG+p+Mfeiz/3oOLEmjSkn7XfSFjofvgU5Ai44qwTTy
	EHICn8cxquFQ16it9r2VQE0uq5VF2lawp7dFdZ8sBkJzMWNuHUdf875kFmCM9s/3UYOegwImG9Z
	xQe5IGv+miYODNwWSswgoO8IMTLt9BYNq8cvcDl+nxeaAGmA3ThDgXXQGHkEYzmGDB/k=
X-Received: by 2002:a05:6000:310b:b0:3c2:95c8:b71a with SMTP id ffacd0b85a97d-3d1af84bc3dmr6311129f8f.5.1756715532953;
        Mon, 01 Sep 2025 01:32:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEdrBvNiH5PR6NpvOde6rWaUaJ2VLDdnRhL58x+5KKINZTciAqBs6qVfgGv6QLhWspy0QcSIA==
X-Received: by 2002:a05:6000:310b:b0:3c2:95c8:b71a with SMTP id ffacd0b85a97d-3d1af84bc3dmr6311091f8f.5.1756715532440;
        Mon, 01 Sep 2025 01:32:12 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f30fe02sm222458785e9.18.2025.09.01.01.32.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 01:32:11 -0700 (PDT)
Message-ID: <620f01b4-8a6c-4dac-bcdd-7c48f5cd87f2@redhat.com>
Date: Mon, 1 Sep 2025 10:32:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: Enable khugepaged to operate on non-writable VMAs
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, kas@kernel.org,
 willy@infradead.org, hughd@google.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250901074817.73012-1-dev.jain@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250901074817.73012-1-dev.jain@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GAYGPheuxfTgvUz-WPasrFS9UyA7YmwcmfUVT-XuouE_1756715533
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 06CF040017
X-Stat-Signature: dm4yntpca3qgb47ga5nqwu5y7jihjzya
X-HE-Tag: 1756715537-319526
X-HE-Meta: U2FsdGVkX1986iQ4dSHMN+1vEhmrcjQvY2nPm2UyCRUUVG4EYLLoFJz7Djh+6PHWjPNr/NdkopJf8BFXlesiRs0RQzoBXiCTF2drzHQA84DpKRVJnlTv8uv9FjNAs0Cz6NAvZ6bQnk0RHmjguCI+Ih/cVRY28Te77gHQAt19xhY+l0qRSniPG2jRxxkqNEY0FwgoGOXlTCmdsFgTomhrJzJWXG8twmMHoUNjYrPXdPDbXbReYyjcauaXhvHattaMyqPFORpYJ+c3zY/e02w/LeBuEPUhYiNPToOXMNhiokiNPU/NkVMiGHhC5UNCwgG4p+4mxkRo/QREcjFOVctWDE6Z7lNMPoG1IJRpjk80BfLHrBH/2pTYfrr6jQhO2Ksd5TpMP6geGfO+fYUwT8MMjl3gFnuwa4oPLclCP+YMPFzh+YopBiJhMm+ntHxpepXSaZZsL+ZAQSHV3qyO4N/gCTHN0YWnPMxJqo5K4/Y1dQKg/6Zu1mfDl8nPAI3F2zXX7eKQ1jrFa5Rf4f7ajigQQfY9h+LZDHEoJiH1jJSqn+vzlHTGErmw8COYZZy0EOdJ4lQm3uXeb5JWFGoJl/SUq3MAEN0n2ywJj82Q5OzlMQIk5xVPFHIR4FPvNM4pNwF2VQT9PIKotknCsrcda+5mqov8hi8nuA+nSb9qaZTaWNdyiWkSFS8cOfQNxkvGgxolyivctj8y3P6xuWwEVf6eOsWWeeggunVzOykH9cEmjSM5prUnweVzcAKZz+6qblVA7pRLVGgM+WRJ1SfgGZul8qolBwbSR7pS0q45o8KhWkRa10Siu+GMf8nQ7g76cyeOUcUnQrAsegiySrZjfXv2X+9+IpAGl/M93vlAN7z+Z8l4sOhNLNRfe2lRYrMYg9cnjv3BiP+vjHRDXzjRm2DLbHvAQRVztpJfr+8yscLM50L98jqoQCEw/MzPt/IS1Mt4hxZcYi+YJP5hAIMPR8F
 PEtgPu8B
 l4kzfprN7+3qcejzgO0idqh3evolmVJpNbpDBxpwz+3hBC+VjbloDnbpAjynANundGmD5DWd9p46Wyhn39HQpVNO46sNNuuGZTuoi/EJfMALwmpuHapHF7kNnbqZN64tlLQnrNsmyXq5K4H0SKSsPo2yd0DjN+sv0es/YVIAr3IWmfByyAfgdlImZ7+TjhbS+OzFgpSXrKAKcbzGZXrAzUkIfZ3mooQ16UwDfv/GVJKRnU6JQdqkQtzZrWB4vPo3jPIRKYymwkOPB8xy9f0W8ggb4o96hUo1dnwUaampe12l6amkNpCic9+rkreMTVzHEutVln5EU9CIfSBBFrmTwLYI/Db5XOBIqtPkYXilfGSmDSo4IXO4wY3nPwLZYKGxTK6bUxXKSCh9S2V+v6xgZuw1vHSfQ1DfH3SC6zmlcKxPhgbXk/l+Fes+5Yi/eKenVAMNmSlqX50Gcao6q7BWQ3rYh2oNJJ2gjz95SD243Bg6RS5mRMD/NxV3tyRwKLoykL2Dqp3qzxhqUZjzkm/eefi30xLr7iYpKsd4aAiis+5HzRV+5XyAvGeoYjw+7W6oZbgE8Fp3/A5B1KrWXbhvRMl/hdFXHfTjCiW1KfDocYdHaoRc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 09:48, Dev Jain wrote:
> Currently khugepaged does not collapse a region which does not have a
> single writable page. This is wasteful since, apart from any non-writable
> memory mapped by the application, there are a lot of non-writable VMAs
> which will benefit from collapsing - the VMAs of the executable, those
> of the glibc, vvar and vdso, which won't be unmapped during the lifetime
> of the process, as opposed to other VMAs which maybe unmapped.

Are these anonymous folios? ("VMAs of the executable"), or is you description
misleading?

> Therefore,
> remove this restriction and allow khugepaged to collapse a VMA with
> arbitrary protections.
> 
> Along with this, currently MADV_COLLAPSE does not perform a collapse on a
> non-writable VMA, and this restriction is nowhere to be found on the
> manpage - the restriction itself sounds wrong to me since the user knows
> the protection of the memory it has mapped, so collapsing read-only
> memory via madvise() should be a choice of the user which shouldn't
> be overriden by the kernel.
> 
> I dug into the history of this and couldn't find any concrete reason of
> the current behaviour - [1] is the v1 of the original khugepaged patch
> which required all ptes to be writable. [2] is the v1 of the patch which
> changed this behaviour to require at least one pte to be writable. The
> closest thing I could find was: in response to [2], Kirill says in [3] -
> "As a side effect it will effectively allow collapse in PROT_READ vmas,
> right? I'm not convinced it's a good idea." (Although Kirill realizes in
> [4] that this was not the intention of the patch).
> 
> I can see performance improvements on mmtests run on an arm64 machine
> comparing with 6.17-rc2. (I) denotes statistically significant improvement,
> (R) denotes statistically significant regression (Please ignore the
> numbers in the middle column):

I once dug into that myself as well as part of

commit 1bafe96e89f056cb6e25d47451fb16aee2c7c4d0
Author: David Hildenbrand <david@redhat.com>
Date:   Wed Apr 24 14:26:30 2024 +0200

     mm/khugepaged: replace page_mapcount() check by folio_likely_mapped_shared()

where I noted:

     Interestingly, khugepaged will only collapse an anonymous THP if at least
     one PTE is writable.  After fork(), that means that something (usually a
     page fault) populated at least a single exclusive anonymous THP in that
     PMD range.
     
The problem I was concerned with (also documented in that patch) should no
longer apply ever since we changed how folio_maybe_mapped_shared() operates.

So yes, I don't see a good reason to fail on R/O PTEs

> 
> +------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+
> | mmtests/hackbench                  | process-pipes-1 (seconds)                                |                 0.145 |                   -0.06% |
> |                                    | process-pipes-4 (seconds)                                |                0.4335 |                   -0.27% |
> |                                    | process-pipes-7 (seconds)                                |                 0.823 |              (I) -12.13% |
> |                                    | process-pipes-12 (seconds)                               |    1.3538333333333334 |               (I) -5.32% |
> |                                    | process-pipes-21 (seconds)                               |    1.8971666666666664 |               (I) -2.87% |
> |                                    | process-pipes-30 (seconds)                               |    2.5023333333333335 |               (I) -3.39% |
> |                                    | process-pipes-48 (seconds)                               |                3.4305 |               (I) -5.65% |
> |                                    | process-pipes-79 (seconds)                               |     4.245833333333334 |               (I) -6.74% |
> |                                    | process-pipes-110 (seconds)                              |     5.114833333333333 |               (I) -6.26% |
> |                                    | process-pipes-141 (seconds)                              |                6.1885 |               (I) -4.99% |
> |                                    | process-pipes-172 (seconds)                              |     7.231833333333334 |               (I) -4.45% |
> |                                    | process-pipes-203 (seconds)                              |     8.393166666666668 |               (I) -3.65% |
> |                                    | process-pipes-234 (seconds)                              |     9.487499999999999 |               (I) -3.45% |
> |                                    | process-pipes-256 (seconds)                              |    10.316166666666666 |               (I) -3.47% |
> |                                    | process-sockets-1 (seconds)                              |                 0.289 |                    2.13% |
> |                                    | process-sockets-4 (seconds)                              |    0.7596666666666666 |                    1.02% |
> |                                    | process-sockets-7 (seconds)                              |    1.1663333333333334 |                   -0.26% |
> |                                    | process-sockets-12 (seconds)                             |    1.8641666666666665 |                   -1.24% |
> |                                    | process-sockets-21 (seconds)                             |    3.0773333333333333 |                    0.01% |
> |                                    | process-sockets-30 (seconds)                             |                4.2405 |                   -0.15% |
> |                                    | process-sockets-48 (seconds)                             |     6.459666666666666 |                    0.15% |
> |                                    | process-sockets-79 (seconds)                             |    10.156833333333333 |                    1.45% |
> |                                    | process-sockets-110 (seconds)                            |    14.317833333333333 |                   -1.64% |
> |                                    | process-sockets-141 (seconds)                            |               20.8735 |               (I) -4.27% |
> |                                    | process-sockets-172 (seconds)                            |    26.205333333333332 |                    0.30% |
> |                                    | process-sockets-203 (seconds)                            |    31.298000000000002 |                   -1.71% |
> |                                    | process-sockets-234 (seconds)                            |    36.104000000000006 |                   -1.94% |
> |                                    | process-sockets-256 (seconds)                            |     39.44016666666667 |                   -0.71% |
> |                                    | thread-pipes-1 (seconds)                                 |   0.17550000000000002 |                    0.66% |
> |                                    | thread-pipes-4 (seconds)                                 |   0.44716666666666666 |                    1.66% |
> |                                    | thread-pipes-7 (seconds)                                 |                0.7345 |                   -0.17% |
> |                                    | thread-pipes-12 (seconds)                                |     1.405833333333333 |               (I) -4.12% |
> |                                    | thread-pipes-21 (seconds)                                |    2.0113333333333334 |               (I) -2.13% |
> |                                    | thread-pipes-30 (seconds)                                |    2.6648333333333336 |               (I) -3.78% |
> |                                    | thread-pipes-48 (seconds)                                |    3.6341666666666668 |               (I) -5.77% |
> |                                    | thread-pipes-79 (seconds)                                |                4.4085 |               (I) -5.31% |
> |                                    | thread-pipes-110 (seconds)                               |     5.374666666666666 |               (I) -6.12% |
> |                                    | thread-pipes-141 (seconds)                               |     6.385666666666666 |               (I) -4.00% |
> |                                    | thread-pipes-172 (seconds)                               |     7.403000000000001 |               (I) -3.01% |
> |                                    | thread-pipes-203 (seconds)                               |     8.570333333333332 |               (I) -2.62% |
> |                                    | thread-pipes-234 (seconds)                               |     9.719166666666666 |               (I) -2.00% |
> |                                    | thread-pipes-256 (seconds)                               |    10.552833333333334 |               (I) -2.30% |
> |                                    | thread-sockets-1 (seconds)                               |                0.3065 |                (R) 2.39% |
> +------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+
> 
> +------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+
> | mmtests/sysbench-mutex             | sysbenchmutex-1 (usec)                                   |    194.38333333333333 |                   -0.02% |
> |                                    | sysbenchmutex-4 (usec)                                   |               200.875 |                   -0.02% |
> |                                    | sysbenchmutex-7 (usec)                                   |    201.23000000000002 |                    0.00% |
> |                                    | sysbenchmutex-12 (usec)                                  |    201.77666666666664 |                    0.12% |
> |                                    | sysbenchmutex-21 (usec)                                  |                203.03 |                   -0.40% |
> |                                    | sysbenchmutex-30 (usec)                                  |               203.285 |                    0.08% |
> |                                    | sysbenchmutex-48 (usec)                                  |    231.30000000000004 |                    2.59% |
> |                                    | sysbenchmutex-79 (usec)                                  |               362.075 |                   -0.80% |
> |                                    | sysbenchmutex-110 (usec)                                 |     516.8233333333334 |                   -3.87% |
> |                                    | sysbenchmutex-128 (usec)                                 |     593.3533333333334 |               (I) -4.46% |
> +------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+
> 
> No regressions were observed with mm-selftests.
> 
> [1] https://lore.kernel.org/all/679861e2e81b32a0ae08.1264054854@v2.random/
> [2] https://lore.kernel.org/all/1421999256-3881-1-git-send-email-ebru.akagunduz@gmail.com/
> [3] https://lore.kernel.org/all/20150123113701.GB5975@node.dhcp.inet.fi/
> [4] https://lore.kernel.org/all/20150123155802.GA7011@node.dhcp.inet.fi/
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
> Based on mm-new.
> 
> Not very sure of the tracing parts which this patch changes. I have kept
> the writable portion for the tracing to maintain backward compat, just
> dropped it as a collapse condition.
> 
>   include/trace/events/huge_memory.h |  2 +-
>   mm/khugepaged.c                    | 11 +++--------
>   2 files changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> index 2305df6cb485..f2472c1c132a 100644
> --- a/include/trace/events/huge_memory.h
> +++ b/include/trace/events/huge_memory.h
> @@ -19,7 +19,7 @@
>   	EM( SCAN_PTE_NON_PRESENT,	"pte_non_present")		\
>   	EM( SCAN_PTE_UFFD_WP,		"pte_uffd_wp")			\
>   	EM( SCAN_PTE_MAPPED_HUGEPAGE,	"pte_mapped_hugepage")		\
> -	EM( SCAN_PAGE_RO,		"no_writable_page")		\
> +	EM( SCAN_PAGE_RO,		"no_writable_page") /* deprecated */	\
>   	EM( SCAN_LACK_REFERENCED_PAGE,	"lack_referenced_page")		\
>   	EM( SCAN_PAGE_NULL,		"page_null")			\
>   	EM( SCAN_SCAN_ABORT,		"scan_aborted")			\
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 4ec324a4c1fe..5ef8482597a9 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -39,7 +39,7 @@ enum scan_result {
>   	SCAN_PTE_NON_PRESENT,
>   	SCAN_PTE_UFFD_WP,
>   	SCAN_PTE_MAPPED_HUGEPAGE,
> -	SCAN_PAGE_RO,
> +	SCAN_PAGE_RO,	/* deprecated */

Why can't we remove that completely.


-- 
Cheers

David / dhildenb


