Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 234B0CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 07:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B66466B00F4; Tue, 19 Aug 2025 03:44:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3D926B00F6; Tue, 19 Aug 2025 03:44:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2C2B6B00F9; Tue, 19 Aug 2025 03:44:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 92CFB6B00F4
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 03:44:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1E4151DC538
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:44:09 +0000 (UTC)
X-FDA: 83792718618.30.BB29957
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id B67EF20006
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:44:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GtQlsVsl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755589446; a=rsa-sha256;
	cv=none;
	b=5jqwr/+ITsVjMQ6xWx7SCsKdg1VQ22HDn2WgpcP4jqiFr1GEtGE78onTSBh3m7yPkrd8xG
	ttDqsu32hFPn50w2zLMzj9nJMovrBxEeTexPdVut/bc8Sq116abBsn/+AWW6SGQR2XpuVo
	tsKWzswLliY2Bg0V1/11nlcmcROoqms=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GtQlsVsl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755589446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fIj/g36bZghupXV216+l9nKZNoBOCc3syczxCiD8BLI=;
	b=384qiSLib0+u8WMuVg+emb35KBFTNi3PA5ftSQkDjtpjFQ7obsjTIEJOK7usI6Dy2ERpRc
	4IAm+Y31frVgtS3oTZdwaLKaMQzHOeRCx17xHkyWXbDo7/khoMJ2thOAYq+7/1LAnc9Nz5
	cFuHIDUzTd5asH2euClKY4Oh3Fzupjs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755589446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fIj/g36bZghupXV216+l9nKZNoBOCc3syczxCiD8BLI=;
	b=GtQlsVslDxNIJx6BcVO1ac/kfsnvBgGRCQsGlhnSFi4FuhqJrd+ptA4ggz/AZwvbe0Zm9p
	EjdbO9AGK/wHVeM/PgGrQ2wpZEpE++ZpGcCzur1lJQvMuQyzl6J5Zcvu9U+ytH/5ghI0eg
	45chY6BXVs4QW4MrmMEHvlq6ERJ4FKc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-426-a0VBHpF5OOGubmabJBH_4A-1; Tue, 19 Aug 2025 03:44:04 -0400
X-MC-Unique: a0VBHpF5OOGubmabJBH_4A-1
X-Mimecast-MFC-AGG-ID: a0VBHpF5OOGubmabJBH_4A_1755589443
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b9edf5b346so3664637f8f.3
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:44:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755589443; x=1756194243;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fIj/g36bZghupXV216+l9nKZNoBOCc3syczxCiD8BLI=;
        b=d501hZsIHA22HKwaG8pdUwAVpjHUZSZ7EzfsUzvIN2M7895Umj4Z/kcbMXXmaMr2W3
         ANXRfZs2tKAy7CGI3ktZR67KyDNR62hBY2zFR75ocTkHdEqIDEp6aB8FB+dwk/We/vce
         Wwy9Nxt/sq6gIANXXQL+TbSdvpnOpH2B0JiDPy2nOfRf/jzJEK3NdeAny4Dy2mGLG/j6
         Dk/TBvDEtT0HzA1UWuvKYQN1b4o3e9sioxyigcu8kHcNQuQ87ACsZcdodMaOpAqZdZEp
         3yEfAMpREq8cJrQy/fMQeEdkEHGt0P2yqqTNekqLqK5bYRyCKzjOJLRq2gxacVoAusU9
         QvFw==
X-Forwarded-Encrypted: i=1; AJvYcCVRRZUluhN9d1obzh6URmIZbxoKzaBLbYSgeeBFTYUCvt8+BcWXuM+n4YjNno7bgvcwR0EpB7y4RA==@kvack.org
X-Gm-Message-State: AOJu0YweBAAhhCV+ri5448cQgZDr9dQiHTgvbuwoRjnW6AGlysO5PHls
	R3sAKdBYcBzorbE+zFOU+XVfB2CZJ1I+w9dCtJUgty83eKFl/gJhaKOuRvqRG9UVzFv+PPp24mU
	xFhQYinjC4EDJQZqgFGeTqWFF2sHnrJnfmvWOidchfw28mPglFASQ
X-Gm-Gg: ASbGncunCxaj5xGDTgXbPPh5sKQ7ufBCw6ZSTw29XyrOCde/lcxM4kTrRtn3TAeh3nI
	KIbCAG3kixwrp0b0MnaA3jzWFUUUBplx+1krLiHUpoHfsuxhN1dad/JptdLXWChmDXjBTibNlbz
	sEtAbZASssAsi95SFBUEo6WFCMHvqVfBYtshtgfVI36xAsE3jKKsI0VX9cVYjZarlSfSkaAYw/1
	dZ/QSEe1+NG5j8v/uY8JJTJTUFmoxS+vz9jISaCjlbDlPVwyY70DqqotqeY+BGYHd7F4bgatkp9
	6dS4l17iLx+0cQThKrxbygAQKOGZnCqno4tLRFu9/jyxhVn94wzK+3Yz0IzkrkdT8It4WPE6ST0
	Vv1QLC3CWdU7ldlHZEm4DcF9j9G3ba4GrsFqML/Q7agv2mWBeWBPol/cYubs2eXmQMJc=
X-Received: by 2002:a05:6000:4011:b0:3b7:9c79:3293 with SMTP id ffacd0b85a97d-3c0ecc318e6mr949018f8f.58.1755589443061;
        Tue, 19 Aug 2025 00:44:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGX3aCtmn8Z/3+2rglxcbECtcQWpRCN5o9VXE9VpdiFc9WoRBf+18fJ1/CrjpVetKu7qCsWUA==
X-Received: by 2002:a05:6000:4011:b0:3b7:9c79:3293 with SMTP id ffacd0b85a97d-3c0ecc318e6mr949000f8f.58.1755589442605;
        Tue, 19 Aug 2025 00:44:02 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f07:8700:71be:5385:87b8:5a98? (p200300d82f07870071be538587b85a98.dip0.t-ipconnect.de. [2003:d8:2f07:8700:71be:5385:87b8:5a98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c074d43c77sm2612291f8f.23.2025.08.19.00.44.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 00:44:02 -0700 (PDT)
Message-ID: <557f34ed-114b-48ff-8c01-ca9c939da08f@redhat.com>
Date: Tue, 19 Aug 2025 09:44:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm/mm_init: use deferred_init_memmap_chunk() in
 deferred_grow_zone()
To: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Bill Wendling <morbo@google.com>, Daniel Jordan
 <daniel.m.jordan@oracle.com>, Justin Stitt <justinstitt@google.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Miguel Ojeda <ojeda@kernel.org>,
 Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev
References: <20250818064615.505641-1-rppt@kernel.org>
 <20250818064615.505641-2-rppt@kernel.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250818064615.505641-2-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jl5QSwSHric8UYnw22vz56EvqGXEIJmqgYQjaWl7gMA_1755589443
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: B67EF20006
X-Stat-Signature: tnprnp951n7888gsouo6k7zqi9pjjyaz
X-HE-Tag: 1755589446-622281
X-HE-Meta: U2FsdGVkX18YsJDWrheoifcfwMHUQhJ/62s+SEY2szWzphAGG01wGgUVcUDKT9psud08iGTW0JEbkzSbTNIbQ6eYVVJJ5MS3PBKD56Gd1Wfm2R1ZehlTh2oO3gLCqj3/3cf2lZDpU6touQVjN2rRv7Y3yc4gUxGyJRRIKd7s+TeJIvIxxza0OeNWQb5w6779f/LwijDQm+vEOaUAEQir9Y6h+YMuounAyaMQkZPhxEe5m7d+hd+WKvijeTzrQf0gNbN7/67xtv3dI9ZGgzrZ3VlGHiaW8roGantKw4ptJeghfGDrQlPhph0zsYk0VDN7CVXYo61r9HGdJoghfaDmmNTpYwIxk4Co9vSoq9VNnoNq8HC1kZoMTQzMjkfq2OTHFV8twN5inOC7dccoK/FJ5WlpKvvcsydMuG9ZZj684aVfqWsnnATB2roCqfjuI4VvaOVLlxz0k9emerg+tdVtyM/5xDR0fDYlZEAp5X0hdt5EdLSU1FhmFln5tLFuF/yGWAmY2oekxvFkBoXLep+Ji17wQE6vErzU3SXk9yGU1xrz3UGL/0EfFDmllNbENycibhlh86XHQYIHbiXDxD7UOfREDIIKjNhFj7IbZcKDY62KIoWM8UM05V1HZnJ1YUs/bPuLdbVPuvySL7HrylYuWTznYqC5zOJKGZGjuq96hD68zKM3I7oZKY5xi5A0mDloFYLuXXDM8UI2P1JJpXucotz/MiyvDGEOrA8GO+JxZKmPUCEVobcI0okjfAjVV118yaN3ztZTgBcyokHlzeRjWFpIwjRAObQQCYP4odPW69JhVcfTBrWw7acVHbPKXiTvGudrrpBLZTg99UA1Vs0AEU4JQMcTorMUhHlTh+dLHQMMFoDxCQD4fn19aEL88Dpv1R9W/3HdBVJkZWnEbLiV+pyIN72LvQfelUs4J5KziiNareSPJs87mM1j2fplqxqEuvOxhSo85iulntKrmJu
 uK1HkOPL
 lFxH57cHn61fflSXP8lXut9gE1k8RQxxCGRl1QEoPWxSlJVVRff60pERB5bJKGx1sateN8ijMqJ7GEp4OvADzXAh8OUK0BWenrmunvy407IeLk/qTmlfJ1hW5/bLQ7JPVnZqjUMpK/jczEuua2nFzBVxUZZjWHPNN9CoGpt70l4CEW45ybED53Ufn5gSkT5ucCQeHHE6DWnlf5nXVLvKfm3WZUg+KuGrjyURJb8vS6Zu7XrnfXmE+ka9duZGujM0dGTFnCUZMq23smdCZK6iMVeFn5KatG0tN2DARrIDyRrdhvmFabwxFXLmHWHi/o5LdjbbPhlRQdlbSvKm8W2I5Sm46i/fc1WDGEvfDhjzBlbWOg4byR83AIKTPfQlyftFAr9cbaTjHV9szU8enKr/Dxw5hgaveafZXcMj/yFSyRLq1U8YFppMiQI9cULPuWEGJ8ei/6wyUbNCdTUaerjGBM26ZLPf3+Ht31IULVcVaCBebLR8sOjGWK6m9dsnJXxcFnT30nQ7ndtIZsjAujF5Qkprb6kZQb4YqQ475jrsCgZgsW3VZmIioVt0ExQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.08.25 08:46, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> deferred_grow_zone() initializes one or more sections in the memory map
> if buddy runs out of initialized struct pages when
> CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled.
> 
> It loops through memblock regions and initializes and frees pages in
> MAX_ORDER_NR_PAGES chunks.
> 
> Essentially the same loop is implemented in deferred_init_memmap_chunk(),
> the only actual difference is that deferred_init_memmap_chunk() does not
> count initialized pages.
> 
> Make deferred_init_memmap_chunk() count the initialized pages and return
> their number, wrap it with deferred_init_memmap_job() for multithreaded
> initialization with padata_do_multithreaded() and replace open-coded
> initialization of struct pages in deferred_grow_zone() with a call to
> deferred_init_memmap_chunk().
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


