Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED9D5C87FD2
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 05:55:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70EFE6B00A6; Thu,  7 Aug 2025 01:55:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BE4B6B00AA; Thu,  7 Aug 2025 01:55:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 587356B00B1; Thu,  7 Aug 2025 01:55:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 48CB86B00A6
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:55:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BEC4C1A0801
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 05:55:36 +0000 (UTC)
X-FDA: 83748899472.29.36134A4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5251540006
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 05:55:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h2uFP84d;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754546134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p7T7nHeTlN9HwipzMNJDP8Bfwjs2xG35T+M5i7PC0Cw=;
	b=Pksj6gibuPr4P+9xhFk1TI3fiztzN0k80rYyH4K2mx17xWVFIfnIWstJPs5GVX2przQM/o
	Hw2FPCAJTpEiUWQX4qAr+8ElK/FJgGI+42oBwToUewzYP9tTzcOE/lpLmqR8WsGMOkX0QX
	iVtKcxKczrN6tA0/q+qh8EH5Yvetpbk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754546134; a=rsa-sha256;
	cv=none;
	b=EQ8OpgKVxDcTGuyM8xeEosvprQBZezgBGRHhMVK+053bS8HVx+6AWVxMDDNdoMyO32sm/W
	mJE7ZlpVukyFVm9KPRZkjWpvmOay/CerI7KUDMu0KnjV3yHPUslw0vzkPjQFEtaat2uJPu
	24MAXPXgcYBBnHdGB3Ui/CV+spCMLCc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h2uFP84d;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754546133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=p7T7nHeTlN9HwipzMNJDP8Bfwjs2xG35T+M5i7PC0Cw=;
	b=h2uFP84dl9xSVyEYTkHVkzkDcMdxudigd4MPN86Mlg2FdJyZEzQY+KqXC5uChYZJ07Z6C6
	ij9UPmfgmwYihCM1DD7VRXHoMM6lhXLVQx2Ny2Fw4G59DKlIR+yJLdSF/RI4IuZ2ylATPw
	AjQCiknyEpO+92ItTQmVZU7t47bDnoM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-tuB-hi77NAePXApIU5HyTA-1; Thu, 07 Aug 2025 01:55:31 -0400
X-MC-Unique: tuB-hi77NAePXApIU5HyTA-1
X-Mimecast-MFC-AGG-ID: tuB-hi77NAePXApIU5HyTA_1754546130
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-459d6c83e2eso2998495e9.1
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 22:55:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754546130; x=1755150930;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=p7T7nHeTlN9HwipzMNJDP8Bfwjs2xG35T+M5i7PC0Cw=;
        b=vcAEq0buF2yBnkq4328onud88R7j/NURnul5dyuyz8gsqvfFgp9Sy3lQP5uWSwR5dY
         iUNcp3/qW9vVQMii3Myw4EXZlTNC3dE42T1GiQ/Mh7QhNqC/IIV7S5bChTUPTjbwATfp
         UbdqqO1Z+eto2tXm6/0ReA4friAl7OrhkqfPwNbb/kTDAxCMbe3Ent43ldX/QTtOn28H
         y1H02qZWJH8ejqTA0vJ78aJaFq9lvt58fnM0zwkFz5gC//I54jftPD9cn6q8S3bPvyvi
         F6psJWonkGUQ7C7taYI6TaqMfGUCABJTmImgXDTeJWwVopjUKrKAUC0tmp+J6fQlEq5M
         JItw==
X-Forwarded-Encrypted: i=1; AJvYcCX0FaRCDjf4Ooa+yNGLssAauW3JSAl8rK/UZHECibFDIPDno88Kyqa5IrgLAC8GyoP3T4Zhii3SLg==@kvack.org
X-Gm-Message-State: AOJu0Yye7IjD7/Z/6FKoLUKsymowDcV7d3Ye19g34d/xIrpVa/EF/P/E
	8gGofHb1CLOzzNDgUPa/JAr1Dkpsopegf2UiK7McGDWl64y58S/x8P5mcafe3MR8fYDQyaIMqLj
	GyAJ2gVE6uH/Gr4Qt+PPmtweqIyow93g8doEiKNYrIkc1Gd01pprp
X-Gm-Gg: ASbGncvPDLpGxXEV2VfRG08OKUYzx5GtQ1Fx4gjBZjbwF8kG+wizlJEHUvH1vy9bN1H
	uORascb/A+UOe2hSBET5DGaOd83wKynnsPMe3v3lBInEfh2RqU82vIY5nIQy4f8+8D5uGwOngJO
	HYnWgM0j/t/ijjq4iE3RgKt+0ULb9O9LEVapBsB12qbetYvrgUOdx6B/iT2iG5lugLlq+MRPibG
	an5B688GTwyE0picGcNrIcJ2eP1sPLNBecTb2OPW+3lWFFnXih1PBfGE3O4KNlCLLnbFMgBMWsr
	3w7E5FF9YA7kysOTIP2CjJbntT7lWaIJhQar9p41iB0r0zSehCHrfO31K2whbZUQi+DQZQ==
X-Received: by 2002:a05:6000:4308:b0:3b7:99a8:bf6e with SMTP id ffacd0b85a97d-3b8f41d50afmr4804879f8f.51.1754546129970;
        Wed, 06 Aug 2025 22:55:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHrCIxSNpL5yXQYQfvCpzINdTrOpqDRRm3qfN0xJSXs+Wik+zOu53yB4YxDQ7mNhDwLqABUIg==
X-Received: by 2002:a05:6000:4308:b0:3b7:99a8:bf6e with SMTP id ffacd0b85a97d-3b8f41d50afmr4804861f8f.51.1754546129574;
        Wed, 06 Aug 2025 22:55:29 -0700 (PDT)
Received: from [192.168.3.141] (p57a1aa57.dip0.t-ipconnect.de. [87.161.170.87])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3ac115sm25527853f8f.12.2025.08.06.22.55.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 22:55:28 -0700 (PDT)
Message-ID: <2fa2f288-bb82-4a9b-8dec-3a4c768fb970@redhat.com>
Date: Thu, 7 Aug 2025 07:55:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page
 as-is
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>, SeongJae Park <sj@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Takero Funaki <flintglass@gmail.com>
References: <20250805002954.1496-1-sj@kernel.org>
 <761a2899-6fd9-4bfe-aeaf-23bce0baa0f1@redhat.com>
 <CAKEwX=MVBJ+Okfsob4Z30_5Y4P8c2DWoS1dYN4dF5dgp4+CexA@mail.gmail.com>
 <055a8a69-731d-43b8-887e-54d8718877cb@redhat.com>
 <jn2fzoodgcxmyld5c7k6jifigkmbhmq2gftvxx7k4ei2kz6r72@vlrndnijfgrf>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <jn2fzoodgcxmyld5c7k6jifigkmbhmq2gftvxx7k4ei2kz6r72@vlrndnijfgrf>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: shna7rvvs2In_CkiRwVSKRvNdWJrbCB8coa5WggnuFo_1754546130
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5251540006
X-Stat-Signature: d9ntefmf59rn4ob6pkaa8863mry4q98r
X-Rspam-User: 
X-HE-Tag: 1754546134-82715
X-HE-Meta: U2FsdGVkX1/S45+Ao7z5Bt3babJAlhy7Dz3WZp5MHknd448OOyg7MFEXtvLRy6yuoCOiHer/2J9bN8tExmaFjE/AvE2RzN+S4o7rQ8/qkpweaHqTnx95uDBZPOZvcGnoTXtMhDJSMIqo1ndC+cJ7mvuV3CJit8gmzXp/WjmxaYkuxJvqnbGskYUnxAX0GLiqcQ0pCDRwW1SAaPe8vlNvAMiifSa9RIvTejwr+4W+onDNq1HHFzBbHlR5NDTzaUrv6TkKhKnCy8WykIe8ZCmJPdIf6YzdcsWfBVxuMYI8tRZo1lLIpQytvQ5vllkryPlzQSfO3Z3mg4V2jv3Ja9GmRQ26cBNpDe3aIn3qFGeryet2adKSBY20LReTfzgj1aCuNkmLi/UQnKH9rhfRzYX/UEcL5zntBM70XFUY1Gc0RHg6JyoGE0XeOFCNNQpr1Mxh+faVrWMA1ArznAk3wtvcnA2NsxtOEZxOUmpuanLPpSAznPRl8DxVKch65n+5TOipqC0IKeffbhJzBWkdaQZMwyEE4tP2BxWoSr/8NMIbGmwQ3a7EWDkuFZNrvzCNfuxMBSLWGAIl2+zaYaCS2YiLZOcjKiNrQaNoWcOx7lujoCAQNE/GOPYHALekMRbIC7UB+A9eOWEruL9/4C6hd+agiizdrHvybcY/D+uLAxhKJ7wqw9RcQAqRA9g3B5uJ/UchdFiDiSAZVYO+l8rzT8u3wXLWpQ+YnPw9pn3sW/5ABkr15ltwT9wDqfkqecP9ZnoPIhO1O5fZS0rpRFBjIwMh5cZr5/YSQcLueXHEIauYh5+BMFYFspmtaJrUQKhvU62xriL3riWEiHlAmv1J5OvQm5VKP0NRZX7DyUDoZ+ulbCwi760+NdsNJoE1h1xD9orcUClCmXDiJPaMEpviqWdnt9xzUQ89YS66t8XPd+H2u3WmfZXulz5G1ccAmvtsKSgRvBs1CAXYOTSZdmAXsrm
 1MyCVzVN
 CV68m0MTCNeeWXYr9FK0vxICimEz7a6Ekw62yKUH63awrWYIw13aMTrPom/M+hiozuS7y8eEEKAQovufsjnhO0U6FjTRbKLecMoW331R0iX8IUUK10oAjNgxgQGzDIOR5R4PWUzzmTy1nfk4Kt2kZRT5ZlHpS5x44U/kkG9g5AKLFSySh4txEihntmOP5mioxmLann7xDEQ/QBwg6MG+E+O2pP3Ji8wSczzGXUDwW5eyAFvwsc823kh1VhinsN4mQ2V/M2Bm4qxxAnrroMqGZegaCJVYwNnbwkxd5JXIshFxA6apzOSAzTEDMCwa7DBbOeNMbPhcaBCo2XEHFFIjM/f1mhzvmxih2mWWmt7P+aer9U9oSv9csFqTWeJrGBBZhnkEc6/d4B/jnl45Sqg2NUfE12yys/wj3vHnJBweCqCrlPFCrYbPpx3/RTp6K/MYyIR5eAI0bzbxIqB+leZ/sqH7MkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07.08.25 01:48, Shakeel Butt wrote:
> On Wed, Aug 06, 2025 at 10:14:39PM +0200, David Hildenbrand wrote:
>>
>> But yeah, whether these "as is" pages are movable or not is a good question
>> as well -- in particular when zsmalloc supports page migration and the "as
>> is" pages would not.
> 
> By "as is" page, do you mean the page which the reclaim code is trying
> to reclaim or the page within zsmalloc on which the content of original
> pages are copied as is?

I mean whatever the "dst" is here.

+	if (zswap_save_as_is(comp_ret, dlen, page)) {
+		comp_ret = 0;
+		dlen = PAGE_SIZE;
+		memcpy_from_page(dst, page, 0, dlen);

IIUC SJ correctly, in case of zsmalloc "dst" is just the same page that 
would have stored encrypted data.

If that is the case, nothing should change, really.

Thanks for clarifying, all!

> Most probably you meant the page which the reclaim
> code is trying to reclaim. This page is on its way to get freed after
> [z]swapout is completed and this patch is not changing any behavior for
> that path.

Yeah, that's the "page" in the hunk above I guess.

-- 
Cheers,

David / dhildenb


