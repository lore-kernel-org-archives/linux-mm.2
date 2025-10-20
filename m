Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E097CCD19F
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 17:18:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8450F8E0013; Mon, 20 Oct 2025 13:18:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F5C28E0002; Mon, 20 Oct 2025 13:18:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E3DC8E0013; Mon, 20 Oct 2025 13:18:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D26B8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:18:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E6D4F160234
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 17:18:26 +0000 (UTC)
X-FDA: 84019151412.02.1C27B85
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8778840019
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 17:18:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QpsP617m;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760980704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=evREIIg1Q3eF3TMvX6tXdHcweEVqxuFmPv5AL/GwLz4=;
	b=pavDFDSu3+3GvoRqkXbjTWRGp5jbzoZxlxerzSIE7Jx7bccrSX83YmXCCt5ADDPl9/daeS
	X/9xf87/7XLp64GBjxUHjV7rcadGUu79/WsdqAIQmw2IEFx9MezfDbo/KLLtTV7rB2PAWV
	yutkk7x4GEcjrp6iH5WQ8ADWNaCtsL8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760980704; a=rsa-sha256;
	cv=none;
	b=Ea0mS5oQpA4OS4zAmXNuf1j97nmmM2DGrw2HO5+2Nabes3zAdOkV70j/C6Nrr+vxNakHP8
	AKPnKdkt5Df+UYWjgt2pOGjmqVHF/Eo/7S8IedZnNKD8u0vrngv/9Xl74pUSup0/mkHUnY
	hmbwmMSSfwIRAbxRT7p6BASHB5RH1K8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QpsP617m;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760980703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=evREIIg1Q3eF3TMvX6tXdHcweEVqxuFmPv5AL/GwLz4=;
	b=QpsP617mryEeHjZxpGtiCANjMAyA6dAG9XuajXNjS021aDd+cBvyOOEhtSYjDybn2/fxji
	UDsr6UjmJVh+CUuFNvE+tl0c/pFz/PSVpMcVU6t1cJX4E/mbQTOuDOHSIXKPIqY6wuP/RR
	AG2wMcFATJIL/rcoWBb14cMUBe6VISo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-oyk1mZR0M-CJXAU893q6Hw-1; Mon, 20 Oct 2025 13:18:22 -0400
X-MC-Unique: oyk1mZR0M-CJXAU893q6Hw-1
X-Mimecast-MFC-AGG-ID: oyk1mZR0M-CJXAU893q6Hw_1760980700
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ecdb10a612so5411883f8f.2
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:18:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760980700; x=1761585500;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=evREIIg1Q3eF3TMvX6tXdHcweEVqxuFmPv5AL/GwLz4=;
        b=tKh/RSvkSFYTWfrnw6cu1GK0GrRSXP25TsvsadMvnKemz2LaXQzQpjBfwjoIcmtPp/
         Ljx00cuEBc+L96XgFIkvCP3DwxaFjOHrUyZ7km6JvyUi5W9GBL8L9S9T7Yi6hSSnponA
         WiPcC4NdTp+K4DnKIdit/TbKi8eZm4SUj2Hi2mpV8QNx54Bh01uFqIMNf1SheJ5WXZZE
         jlLSDafGG7b/4Fq8UllXFpiPorDtT5Eeg57vH0fRrrWQdrdko5PAt6BiLauo9gdu6xTa
         Y0caPfWEyKgxHeLOBT1ELJwuUSzcfiKsG+wi78F4wFpzRv5/F4695c1i87ToUtF62pcc
         Kk/A==
X-Forwarded-Encrypted: i=1; AJvYcCVa4+2t3Ob+0aGpVK+U5O/wr+GZIluuvHRbvRlUmp0ffx6AnmNrJ2RvAZgMhme3C+REPu/hOcInxg==@kvack.org
X-Gm-Message-State: AOJu0YwLaLBRqOKixlN0/4/QKo900iILquAQaxi0Slamx0UHXoJyNmfs
	IgPtZzegMDRW3bUJITy8+f8nz+4Q2jTyvImP/CJRiNCF6/HOX991pnTKzv9Ydovlw9THlT3Tjos
	hNVHpYVeAFsTnD+kW1xKuRpxyOzYChkNbaMyttNrP0sm04sbOqd61
X-Gm-Gg: ASbGnctN93mGPrJ3rG1t+ipG1PxSZnrLyaJ3XsK01BtgT/Ov623rvfuOwWYaDdU15yj
	0N6PRQeLxus8/14UaTkqaIk+7ctyg8yomMlpFhk+lRo4TnEBQNVRykA6Otyhgp1duQ12oHtc+Th
	jVrVkXlgm76ySYhiNKVpDCDOc3u0Q3P2v1NK1O5PlE9gAPyj5J5TLfjsSFmuE5KiN70v5PKC9+M
	LqB5aYxp1i3i3UUo/zxSxwo0n9R6K3pprCT0wTZCdOAxLpskee+pMaXiRRdEa3A9jDK9rtPlVLe
	sjApDahluhP43cEJh3/dNGKfEod/a4hxYK9O0gNgQKqx/YyPljh5DMvV16aBeUGAOJT+QCgwY2w
	OyueJUwYsY0ZMMPJyqVyZbAhMgUT4/IZkqZxzGUPBITDHkMChq87Y/dRQQb6sC3+7Ert6e+Q2vX
	/X8suDNd/IQVry/2MYKO7jV6SWU0A=
X-Received: by 2002:a05:6000:2287:b0:3ec:8c8:7b79 with SMTP id ffacd0b85a97d-42704ded0b1mr9923527f8f.61.1760980700419;
        Mon, 20 Oct 2025 10:18:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEsI213zwekDCyhaes1/CGMYO/HLtgUGK3QMQMJUNg5C2J1S7QZqYIh3FWpsycwOeUpv/3Dmg==
X-Received: by 2002:a05:6000:2287:b0:3ec:8c8:7b79 with SMTP id ffacd0b85a97d-42704ded0b1mr9923511f8f.61.1760980700018;
        Mon, 20 Oct 2025 10:18:20 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427ea5b3d4csm15832349f8f.19.2025.10.20.10.18.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 10:18:19 -0700 (PDT)
Message-ID: <c81dcb7e-f91c-44e9-b880-0e0188a8ff5b@redhat.com>
Date: Mon, 20 Oct 2025 19:18:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug: Performance regression in 1013af4f585f: mm/hugetlb: fix
 huge_pmd_unshare() vs GUP-fast race
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Jann Horn <jannh@google.com>
Cc: "Uschakow, Stanislav" <suschako@amazon.de>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "trix@redhat.com"
 <trix@redhat.com>, "ndesaulniers@google.com" <ndesaulniers@google.com>,
 "nathan@kernel.org" <nathan@kernel.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "muchun.song@linux.dev" <muchun.song@linux.dev>,
 "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>,
 "liam.howlett@oracle.com" <liam.howlett@oracle.com>,
 "osalvador@suse.de" <osalvador@suse.de>, "vbabka@suse.cz" <vbabka@suse.cz>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <4d3878531c76479d9f8ca9789dc6485d@amazon.de>
 <CAG48ez2yrEtEUnG15nbK+hern0gL9W-9hTy3fVY+rdz8QBkSNA@mail.gmail.com>
 <c7fc5bd8-a738-4ad4-9c79-57e88e080b93@redhat.com>
 <CAG48ez2dqOF9mM2bAQv1uDGBPWndwOswB0VAkKG7LGkrTXzmzQ@mail.gmail.com>
 <81d096fb-f2c2-4b26-ab1b-486001ee2cac@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <81d096fb-f2c2-4b26-ab1b-486001ee2cac@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: W4ir2ztOSOq87k4WgIpdl-7dp0A3vkdp7eg2OZWtel0_1760980700
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: 75duh9gosqds49cmf4jz5tfurzgy7tor
X-Rspam-User: 
X-Rspamd-Queue-Id: 8778840019
X-HE-Tag: 1760980704-877412
X-HE-Meta: U2FsdGVkX19s5VH7ZJ9s/ha27vF+ZlN2sewTu7ASjw7L/BomznR8Aa+Wj0yO8h99zqAORnJoF575OIgxORw78VtYtwL2ay+C+cVvDOeH8Q54wKL874tEb1xIG4y/6xLBrP9jtrBJU9PTi0w4Ww2EhfwTODMZXJjBvnvI3xuCe0Rgr4wbxmfn6gM177zV2e/++tjvDP7uaAOynApFfrmDtdm3Gd/eA0oYxXJj8X3jpUhxC0gwg5TI7pf3yPH4eIb6F+Bzh3TEkc4QNi6vdAnXPjP9KHFVXZTtA+TrMXYRzHFgJSxrnecu38XQOOXk/JomeiG5wgA64OfvYKvIsTnh2Wz9czXdKJ8r3MjRKpbaFznwur6PedHVvwLbD5TSZHMNAxPhpablCGI27CeQsaJd1Q49fDGzDWD0SEcE+jsWIp8qZEIaLqP+xYYMhT+nkLYaMm9oTje1kS71L9SgRq6erM9jNUk86ux+LARLDmnohskPpLb2lPTiAfujoc+y7Yq/WnyK+uI/0brtQN539RuA02F8XGhHAWAyg1fdOlbxfh5yn0cQ/rUhORMYTbVz2pAV+hKxrqJzIcrFmWsh7nU34dIqWgN3SelhNd7AxkVGQqCI2fUcFkkeSPmyxa18rEoguDjKwNTjBY8y3JrlZq31GMfaV7LfjkHD5h+k5+52uR67xtcSbzzR7pFITobnGOy+2VmHGXKh/70PdFbPgXppYBNTj3VuNRtJLR2WTm22rhZf6mi8PiJLVhqUc/dh752r6RktJioEPVxFEGs5Jk0glbt2Rc8rv5YLKWc9hV97ZKvN0BNMWaeZvGeE0lDd09gaiVJ2CG4yk37W5Q8RoGS3WuGH1c0K1bKOpW5i/v6CVhlJUjntcMpOYsaEsVXOb3vD6P5NwDfch0IRDUmmnQwCS7bLMj86rejYLTuKCRNSFcmTFIavnJZREFhUFGWEc6+S/gk6r5QYGgB4JwsTfuR
 kuAKmUCk
 fiODxrHGv/9BOPJ8CmzSd8WAOkCvl5cMUESZmplpfdOT1USSfpgIRUIx0GK2LvRBsCLf2T8G7TvbkdycHL4Z5pkwrmaDkYNQQxPDwLQ3MU4/RPTCynxsc/vZBy8B+DHBnzbMS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>>
>>> So in case the page table got reused in the meantime, we should just
>>> back off and be fine, right?
>>
>> The shared page table is mapped with a PUD entry, and we don't check
>> whether the PUD entry changed here.
> 
> Could we simply put a PUD check in there sensibly?

A PUD check would only work if we are guaranteed that the page table 
will not get freed in the meantime, otherwise we might be walking 
garbage, trying to interpret garbage as PMDs etc.

That would require RCU freeing of page tables, which we are not 
guaranteed to have IIRC.

The easiest approach is probably to simply never reuse shared page tables.

If there is consensus on that I can try to see if I can make it fly easily.

-- 
Cheers

David / dhildenb


