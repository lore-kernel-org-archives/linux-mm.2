Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C60F3CAC5BA
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 19:20:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1227B8E000B; Thu, 25 Sep 2025 15:20:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FA418E0001; Thu, 25 Sep 2025 15:20:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2A448E000B; Thu, 25 Sep 2025 15:20:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1FE68E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 15:20:36 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7713A85781
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 19:20:36 +0000 (UTC)
X-FDA: 83928739272.25.54A9776
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 77FBD160004
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 19:20:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="iGH/+C6O";
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758828034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h9NwUDyMGoW+yRpMBA8+utUcpjFyfg+r5YqhwRloimY=;
	b=MpaZ9yJuZ1LvFUvue/UURKkrKacxEQPnBGIm8JTtZFkzCQxOTvQY63qrKnMdTLsSqv8sOx
	LiI0/rN+n+3oxgqcvqZ13OYU508bnkiTQ2NrtE0RCBnzVQ7I0yw0zX9oaf+QCK+cG+93I7
	2AJdEe7zoai/ClWusFowQ+rhuooI0Uo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="iGH/+C6O";
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758828034; a=rsa-sha256;
	cv=none;
	b=GOoDy+EhyL7r2oEamX1Ln5CatQ1JFP6gIL9cCafdo8lYkuuczy+jqrne+sx63a2YqYOGs4
	XybKkfLyYHwu9oLyS6eXyIbr3QEkmJeLvkOWZBSLiaaxnFsEQfWukZFcfYrROwyCL1ogSi
	L2BeE/rYIvbjUew60Bj3qgB7n43/v/k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758828031;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=h9NwUDyMGoW+yRpMBA8+utUcpjFyfg+r5YqhwRloimY=;
	b=iGH/+C6OQmlwfv7Ec/MTEverOlVr4l95ERKo0yZjwt4uw/nerkonvGRBI/V+X0lL06xxG/
	GMLLPI8vz9VJjoDCI6pE3ebZVH8ReMlbmna0cxcLVh2pKEPAwlSlIsP2dfM686YxCcAKsM
	/CJuJUhEomE7ceN6q9nnIMIbQyhQiqk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-235-jMn4nsmYNYqgiN_T8kOkHQ-1; Thu, 25 Sep 2025 15:20:30 -0400
X-MC-Unique: jMn4nsmYNYqgiN_T8kOkHQ-1
X-Mimecast-MFC-AGG-ID: jMn4nsmYNYqgiN_T8kOkHQ_1758828029
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e19f9d18cso8089515e9.1
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 12:20:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758828029; x=1759432829;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h9NwUDyMGoW+yRpMBA8+utUcpjFyfg+r5YqhwRloimY=;
        b=c20UaOI8eSQeeCAu7VhnKM+SRmRDIQrxXhQ0Wyvm5ywT5fNS4a/wkwhg1EEUFYSIzV
         FiCvZGgvURr+kCxYmPIr4DfG+h0/eU5WOMcKZUSi37/+ZjNgkH7jpf4mAxYidrlmeqSO
         RXNXuFQc78RoLximeeezi+ycJ3sCs9pNz4L96I9Os5lF3Gn6aDF9l95K60g0tq1kt2iX
         M5n2NIvLAg56rEpilUSHU/697y5Rp2m3QQtwrSV3QJIqXVT3aBqJ0Hc0sXtawprKURy9
         v+HsyvtZ+MRA8Wnz/+Nilb9SMRQqaat8SpcnJUu++w1mEIOTLiH3m4tRh8TbPGqYyQl2
         uagg==
X-Forwarded-Encrypted: i=1; AJvYcCX/F8Oc9bFM1TW2XhQ5kEDLr3WpHouUs14x1uzMZuMKP/FJGZWY891Vo9Nyhp/515jkzrXcjrEWrw==@kvack.org
X-Gm-Message-State: AOJu0YxCrKsahCeMo7bBms7bZ2B3sl4iXo59S6vJY9rcKIs6A4nF5hGK
	8IO8yOBqgMDGNxE0DgvXc32JHrdmHeMte0AVzY3SWNnuOaYKtEhcqBBJgkUdv8AKHbwiHUhrSDs
	kdKTcIgVupbgmJX2kWEkqCKfPtCtOtQ1yvHSRUBWxG92vj8gmYBM8
X-Gm-Gg: ASbGncvsWEfjTzrsC1a4o3cb8F8tkJnlvop7LkJ42IfB0y+qPgcQjknrF3LetWORZmr
	JlgqVW3BMRbdxulg4APqFW9AequylljGB2W8kX7IIwtCdAbCH0gPHi8viv28YO4k2lky2ofKnVn
	Nq0/suBMPnOpaGfihktjkZyON/C13QiYwbzW9CHJxR7gh6tGjuTnzSEmBrHFCfogvpkyH4dZYjR
	//ZiJiNzobeFdL6yMmH+ueT5cmem0Uq1WsJZrVDginIK4i/Hrzp8Rrj7dTWlrPSvczka0WX2cb2
	v7dVQYuGfjU4nliHMNB8Ncdw70wyMnWEXR8Gc+9/ie1CI1k+9TzAQk0jsJYrLs+wvkpf2ZP8PGH
	IEHlx0JqxkfsfuqBjKCKyf+Nuh2Gp0aNPI+6yOLiTMbzvy773Exxznoc2iQx540J9kbQk
X-Received: by 2002:a05:6000:2303:b0:3e0:c28a:abbb with SMTP id ffacd0b85a97d-40e4486c1cbmr4591374f8f.13.1758828029094;
        Thu, 25 Sep 2025 12:20:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEJ+UtY+HbfBva2JwQPg+uM2EuLkaDWOJR6EHo9MAeCOLTp2sMMeqqF95LTWT8dRmlKajEcTg==
X-Received: by 2002:a05:6000:2303:b0:3e0:c28a:abbb with SMTP id ffacd0b85a97d-40e4486c1cbmr4591314f8f.13.1758828028587;
        Thu, 25 Sep 2025 12:20:28 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08? (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc82f2ff6sm3956465f8f.56.2025.09.25.12.20.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 12:20:27 -0700 (PDT)
Message-ID: <c1875a54-0c87-450f-9370-29e7ec4fea3d@redhat.com>
Date: Thu, 25 Sep 2025 21:20:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/12] KVM: guest_memfd: add module param for disabling
 TLB flushing
To: Dave Hansen <dave.hansen@intel.com>, "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "joey.gouly@arm.com" <joey.gouly@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>, "tglx@linutronix.de"
 <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>,
 "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "luto@kernel.org" <luto@kernel.org>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "willy@infradead.org" <willy@infradead.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
 "surenb@google.com" <surenb@google.com>, "mhocko@suse.com"
 <mhocko@suse.com>, "song@kernel.org" <song@kernel.org>,
 "jolsa@kernel.org" <jolsa@kernel.org>, "ast@kernel.org" <ast@kernel.org>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>,
 "andrii@kernel.org" <andrii@kernel.org>,
 "martin.lau@linux.dev" <martin.lau@linux.dev>,
 "eddyz87@gmail.com" <eddyz87@gmail.com>,
 "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
 "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
 "kpsingh@kernel.org" <kpsingh@kernel.org>, "sdf@fomichev.me"
 <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>,
 "jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "peterx@redhat.com" <peterx@redhat.com>, "jannh@google.com"
 <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
 "shuah@kernel.org" <shuah@kernel.org>, "seanjc@google.com"
 <seanjc@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "Cali, Marco" <xmarcalx@amazon.co.uk>,
 "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "Thomson, Jack" <jackabt@amazon.co.uk>,
 "derekmn@amazon.co.uk" <derekmn@amazon.co.uk>,
 "tabba@google.com" <tabba@google.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>
References: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
 <20250924152214.7292-1-roypat@amazon.co.uk>
 <20250924152214.7292-3-roypat@amazon.co.uk>
 <e25867b6-ffc0-4c7c-9635-9b3f47b186ca@intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <e25867b6-ffc0-4c7c-9635-9b3f47b186ca@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lo2vHDY2mmnK_vIaWGtygzp5GY1fx3KNfmx3NGCCfG0_1758828029
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 77FBD160004
X-Stat-Signature: omrn6gcn3b7gddn3pcb3uaza4ss4u9oy
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758828032-862379
X-HE-Meta: U2FsdGVkX19o/LGZsoY13tM78CjFMzXB+Mjz1id+Yi9Sl63FUUK2/bHnDmle+1gW+QdO2o2CwSVTnLxoa7R3uj8Fpe1Z9L1p44COqGBtwv4q7mUtmk/yRJxjIq6s1enXevpRYOCvDM2K6JitjL9J7uLkxtoWjxF3XrygPj4UEvHTn9DpPW0z205STUenVEEPJCgeSohPn3tK6Z0UzE8fa5x1oe7JbeGooV9s6s/f7Yp+oRWnHqJFIaUEBmB0moMzjIzCqu8T5pC+kV2QQDNG4z3SDhXvVLdM/Cm1qlK5trHbxScXiaiPEOeFhBFd4aUNGXzq3YaNZ2pVdm2L9DGnVipoj4qbWsL+Tv1UStRE8DkjJA+1jU1UjV1Ua17mZ2x41RSKz0wnhP8gTc/8iMpwCDSLfGBGVXXiLjghhRS/kxvVCLCF5CYusCSn9HwvzVOO2f/PtcUJL67ZlYLrtx7CEPDJH5223KQgeb2+vbf57LwCZc1aay7l9Avf7U02Twgv7+nPCVgYJ1TN4iAkK+Etq1ebi0QsakhEzYjdoXyTCJzoiJA/ZJy3RKOZGapIC6loJyEQhFIvBB6o8lujHngg++FEdX6bUgOHmkVXXtcp0aLkL4zULlCHzJRttiNa5HalJiG1/VDUkI83SYAFXIwO6L1RXMuHGWlgHSyeMAwxYVt8yk9qeZJcWDwmqQQNoJzv97S5xUMqqMxb9MyO93ULTUz3FRVB3x1oaKQ44RMt2/qteuTj4OK5RFhEBCYOo7egSiY0aMgAEeoDb+HPbmuTgHHGBIlYQX/IlRo5+TKCoPj/ZDwY+9C+pVyWWWYmeT/eBm8QUTCfeOLmWfrnF4fzfY54WQBmbttNOvVrUdi4QugCDt8Ju3MNJy3YYCXu2N8ysk3DzhAIxYfUqvVpvmHLyf8wWGZqkcvUl90+uQz1BLkzalX+4ClK4q8NoY/wsxOOyEMmtvpnr1mJ7MxZeqY
 yjzAMAYl
 Bt5rJ7IHU1NVSRkIG5LrBQBWGO9LX41PpBs5byHZ/vTXeiPjT6p3rJ5XAbUagE2e0aZFJUctH5f6EGcNsL3V6bBRd+pdXAl1BPghUTfk5rQlc3B8wku1rA+C/IdaZUK8XwDZ/2qlmc74641NzaLiu28ZO3EYgzrvWeZdagwfgtJ4IkarF3/mHmoJGhZiBxdCByfrM/Ms8QDtTUmNNyDmc5IQGKGFVECko2QHuYOHXQnp5j4IaxrOSX47VL1iaLyBjrQ2WvvI1hSfI6qVdTs1GprjKd6GQIIG4wJyPPViDEgzE5F3elfIMBaaJzvNJgRjU9QDyAVq2jL0ZZE1WM/EkDk61ytLq0Ui+H768mS/hdzR97W/5lzKFwpqpRLgMl+V4pjZkAe7VPutX+aezGYZ01HpT8ATaGNNvxOtASHNC+yOGmy/CO7+Ven+77VkvxgFWLVO+n+iHSUuhubRuY3eHq+FXb2wVvlckWTQDbGnzss/9ex50OaayHT6hde2iboj5MeyU2POM8Tre0hDMK7kej6nFkeT2NzizjM5Jf17M2o2t0HXv1b+YjCgRU6AbbU0vKptNcPwrv9Akpuai2X1nGAR+KQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.09.25 20:27, Dave Hansen wrote:
> On 9/24/25 08:22, Roy, Patrick wrote:
>> Add an option to not perform TLB flushes after direct map manipulations.
> 
> I'd really prefer this be left out for now. It's a massive can of worms.
> Let's agree on something that works and has well-defined behavior before
> we go breaking it on purpose.

May I ask what the big concern here is? Not to challenge your position 
but to understand the involved problems and what would have to be 
documented at some point in a patch.

Essentially we're removing the direct map from some memory we allocated 
through the buddy to reinstall it before we free the memory back to the 
buddy.

So from the buddy POV whether we flush or don't flush the TLB shouldn't 
matter, right?

Where the missing TLB flush would be relevant is to the workload (VM) 
where some (speculative) access through the direct map would be possible 
until the TLB was flushed.

So until flushed, it's not-as-secure-as-you think. A flush after some 
time (batched over multiple page allocations?) could make it deterministic.

Is there something else that's problematic?

-- 
Cheers

David / dhildenb


