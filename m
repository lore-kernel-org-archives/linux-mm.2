Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82735CCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 14:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD99E8E012F; Tue, 14 Oct 2025 10:32:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8A558E010A; Tue, 14 Oct 2025 10:32:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92B428E012F; Tue, 14 Oct 2025 10:32:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7850E8E010A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:32:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B9F788758
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:32:13 +0000 (UTC)
X-FDA: 83996959746.22.A227AD2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id B06E3160016
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:32:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cB8pmG4s;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760452330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EsuB7d4keB9P93gdg54bs2Rc0IBaRzmgviQMlBJwkiE=;
	b=ZAeJmZAiVXFj1auVHlGlSHhOhPOXjDc1A7THJEimpCtikOflpUanIUabhneKSbh3Zw+97M
	wGBA67BmWXyHv/Zkm/JqIVlA7Rj+VMwoC1h6XvxVUW2BTFe8JusSaw1fUDCqYWo1JhgeIX
	PtbvHNItvxdzcU1O3XYiT72osOBjOJI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760452330; a=rsa-sha256;
	cv=none;
	b=4FpD8uOM/y2vYdgpMzPaochp6lrEX483VrN8GRUgQDc1703HhGPZDSTBjomaBvL7PMBeYE
	PasZZimt6/RBEfGrZsnYGGA3H0oNPT7E+5zmpgHUxdtBlLzG4SH5S5X0zLaZZi3pWFw0CS
	YBK3eJ1O9HnyT10KbKADFDhaGOG9DFQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cB8pmG4s;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760452330;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=EsuB7d4keB9P93gdg54bs2Rc0IBaRzmgviQMlBJwkiE=;
	b=cB8pmG4sKBkphDEvHB2hrUdU6nsH5ZUJnjs9LzBvHJYOv75aBD4ZXsHAflhbw18ArC/RFn
	Ii9kyBvKWRZnnV7IAkD4OSac7ooBLrslZZI7WitWQat1FYc/A91RzB1SAAdwmWitpmrq0q
	nYBAzdBLwJ4vUvYH37prWRZJMpm0Cdg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-361-AzQFU9rbOIqOmMMSnjC4Tw-1; Tue, 14 Oct 2025 10:32:07 -0400
X-MC-Unique: AzQFU9rbOIqOmMMSnjC4Tw-1
X-Mimecast-MFC-AGG-ID: AzQFU9rbOIqOmMMSnjC4Tw_1760452326
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e3a049abaso39075775e9.0
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:32:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760452326; x=1761057126;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EsuB7d4keB9P93gdg54bs2Rc0IBaRzmgviQMlBJwkiE=;
        b=bLsp+YgAZyqm+ysbIqgrAUFSaj6I7mPn0teikfVZh1xo9A0jhmKbQs1TmBnREVz9r6
         jOUE4j5ZbqMV3T9hXBrh+P5ZX3cyar1/55J+opQMFQStwjgfeIQUDEU/LjjJLRbH+Ndm
         E8Qt7QwYdL2e6x8lrhLdwGAo2nSIDbAcueDdYsLDvQT5xu+mali2OzvthP8fc8lsUQB2
         6ObYmZthzz25uel+mQXI0o7lOYvdI2Q7nZktU9/kIvUKNWkoBXKADOIze2JO/mznKfzl
         6NyYFkyI4MbbWJGKNYpbY2zK/iPfnQZfhcc+T0bbCItyXigdipqWwrth2Rz+orhoykhu
         Yxig==
X-Forwarded-Encrypted: i=1; AJvYcCXj/jcX1r7WsZ//P5q/AQ/pEvKo8JEi+orJnToY7txm6amE4P1xYPw8JGoj1y4ELSZcj2xfgM5XAw==@kvack.org
X-Gm-Message-State: AOJu0YyAF/noJWFIvoFzjraFJBtKXNQ5KP8YfG6Wsgmb37nwO6vRqXn2
	HLhgdehIoByoS/wR48TaN44nPStrd2+H/gAf7iZaGTDfp84UJ7Gbq52M+WMIqMOz1cFJ32OaVbb
	cjg0zRvptm2PiU/qJjAY4txxXwFeJaMJVL0pErpIoWyVwC2SocjJ6
X-Gm-Gg: ASbGnct25GszDW9NEP/Z0g8H3m1Kb6C1cp7Y8ixqMc/TI8zzTuv7FDoZSMbRHVTCKxz
	eW0/0PW7aCw6giIbQzH2DRUAHjFi9n63iMOSC2IFSkbhyPI0uRR0aR2IPIsLk/WNkBYcfXVaVGQ
	ndnTQoF3Zok+bmSswiFKh0/zZQ2vhyvznx7vTgITbRgGxdxzPJEUXPyFLxXMgS3++imMs4d4RgE
	NYYAcjakFgnylQmdDGMB5CQN/utHT/ml2vplhNc00M/MISUWfyamtT7r53cIaQbQfvAdOnaH4tt
	meRCbz/PwHwjzfbTIGkL2PIHHJPld8dU4HuT19J6sJCkO2l0ocmrRJg0um40twQ18+F5D5TsSw=
	=
X-Received: by 2002:a05:600c:c162:b0:46e:47cc:a17e with SMTP id 5b1f17b1804b1-46fa9a8f4c8mr168715605e9.1.1760452326372;
        Tue, 14 Oct 2025 07:32:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGrIgLdLfNz2VgFZaLseNZ6VpfJuRiNBSJYOThRdlNG1uVssvmSs1Jcpfz9qzUg6qfgsS6X1w==
X-Received: by 2002:a05:600c:c162:b0:46e:47cc:a17e with SMTP id 5b1f17b1804b1-46fa9a8f4c8mr168715295e9.1.1760452325989;
        Tue, 14 Oct 2025 07:32:05 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce583335sm23444468f8f.18.2025.10.14.07.32.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 07:32:05 -0700 (PDT)
Message-ID: <6f448506-677f-4e0c-aa9c-d5da061e57ee@redhat.com>
Date: Tue, 14 Oct 2025 16:32:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v3 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
To: Lance Yang <lance.yang@linux.dev>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com, hughd@google.com,
 ioworker0@gmail.com, kirill@shutemov.name, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mpenttil@redhat.com, npache@redhat.com,
 ryan.roberts@arm.com, ziy@nvidia.com, richard.weiyang@gmail.com
References: <20251008032657.72406-1-lance.yang@linux.dev>
 <f33735d3-b38d-4b6a-aeba-b415e6b24ea2@lucifer.local>
 <0bfdbccd-9d4a-409f-ae43-b44bb7347d70@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <0bfdbccd-9d4a-409f-ae43-b44bb7347d70@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2N-bUfMbDHAo8aLmCPfNCledXnTzitKrGh2YTEPofdg_1760452326
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: inwudgubenh8rbjy6a9s7sqkoeanichw
X-Rspam-User: 
X-Rspamd-Queue-Id: B06E3160016
X-HE-Tag: 1760452330-116039
X-HE-Meta: U2FsdGVkX19i0GzsAK1LvzAi4N3z3NdoMUhjIbFcApRFETijRppAcV1vVuXNSJIA06JeqXZ1RncL1ZOwL9gh+sRZa2a/oNIv6Irkf8GGoow9/2KxkVBNGpo4qeIlRL67XrU5Md2dizu48oVFwDCixPc2iHD46q7wQVrbi5QMVYuhsfL7JA1NiSgBzq5UuVMlz8bYifqbeJ9vg2JaftK1yet489TDuEba9J4DKWEFsvErWy5wya6/QRlpq4eukWVJhJwdn8bSZdkXhNhufKU4vpqSYhCrIS9tNrmQ0NrYd9k1UCahOCU8pYI1RVACZDCfgH91oqJvvzx2aLTGtN9ac5p0mzNbMuhI7xwnfKO4x6Nn64aPkRe+PmdK/G0DZzNRS1Dql4+YhuFNFqiWb39rsXoob4PTfqIFhTJFohB+4xFNGT3MxL4kFKZG2lYF7BVNndu+FvQPM+ZgRUqIBQEJwxxmL9mjrKn5+VAUAyBYfT5b/argNIVgtMT9wVvIp2A0EiRw4I06MFEZfM2pnRW/B7MbI9SKw5KOxWeFo7Qkgh8+o6b3GV3WWHS9QB0M2Z4ifCOEPitP5cmxLDEfIvqbv/3WWxaODknZlFJZkcesph3N+cZpv3tOrw6tgM4mTuMXIAIZ8dEnbQFmf2snjr9aQPWM0HfZv0+3fwsjEHkeRbf5qIxZKX5KFYIRNhnkunWKZXbsKdXAJ9ukGHF8lDkjKFtanXM1cK9+szED9SEgZeX5ieFh+CVc820IojuiyLuQrgVZEuwh2yBG8/18b81F91gsHPZR/0yfFHmhlZWWySA8piYNnVypVmMHtgmdGGBYmileqdjrGasTuHqz2GxfYyB+91N5O0wtTvxz232uabZE3xwqyH5zXMLsyc4R6Jt3AOMCWF40/TbFe+jJRgCSFl4lfGLWSf4S3ZbSC0YKyymkBf7msqLSh+W7VoudOvTMldSFeMGJki6EE17mDK4
 6OUsXOBe
 PGMMBXl4V/70UuGtVzfRQr0QpC4aiDD/RzmDt2uh0ZgRWb1L+j8ikAQoKbzskAWA6wOod79XsnnyFnaQL7uIhqTTiKK3d+3TzF4BMS+Sc6DJzVvyCvtcUq9nmx65pThzYMDrsuzrcwmAXmlCK0jdDX7TP5LN+W2Wnea/YZPEvVoCL0A3fZPY0VPlMljwl+tYBiaXmZNxsNDqeaiAMdVSTSjvXbbPvCSd/jEHPLVOfDt96aapN7gaFd8j+neVPxtt3Akfz3dImc4MIUP60hUNit0c+3kMDYitzh7rye77m5GlI7+LnHNCG7CVwiUYWNZEaJCyhn0u+jylT0lqO1a57sv8Vjs1mmzvkIWR1R2PWdQ/3iFd5Bl+G+h3W3gX+ZoPPdScGPxQlCZsz/RZ1hLllbDmLn66dvSBnZjH9q1Ke8zPEmKnTG/VJeTuUFOnCFlVwUnLzx5Ut3AcExaADG2C0wrIDncObb/6QrKePa39ZNn4DB020q8Fhbk9K45TvmU2Wau450iTGK+LUqv2uEZJKgQEtfPSElICX8L6s3M9Tx23bOulCnpY8vHpNmEkcfoajBAJ9k+OrbtOfgLOagbc8sKVM/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> static inline int pte_protnone(pte_t pte)
> {
> 	return (pte_flags(pte) & (_PAGE_PROTNONE | _PAGE_PRESENT))
> 		== _PAGE_PROTNONE;
> }
> 
> static inline int pte_present(pte_t a)
> {
> 	return pte_flags(a) & (_PAGE_PRESENT | _PAGE_PROTNONE);
> }
> ```
> 
> On x86, pte_present() returns true for a protnone pte. And I'd assume
> other archs behave similarly ...

Applies to all architecture. prot-none entries must be present, 
otherwise we'd have a lot of other issues :)

-- 
Cheers

David / dhildenb


