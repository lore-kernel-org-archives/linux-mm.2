Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAF94CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 08:26:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 208F58E0006; Wed,  3 Sep 2025 04:26:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E0418E0001; Wed,  3 Sep 2025 04:26:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F6828E0006; Wed,  3 Sep 2025 04:26:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EF7918E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 04:26:16 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C1F691A0553
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:26:16 +0000 (UTC)
X-FDA: 83847256752.22.D1F30D8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7BE3C100013
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:26:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="RhXs/FjG";
	spf=pass (imf05.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756887974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RiF4X17MAgeDzab0iosntA9Q/n0cbzxTmlw2m/AGEGE=;
	b=OAu/Qj+12fynak8pgNPFmLrt6arsyGgKulXSWODrU0QgUs+Cyl3ezvNO0PDtKqNmbekCfF
	gpu8oMZeGHMQ8hdxPPPi1psTzGmeiTXUxweWwu9ZbBIqmvmd8N9SI8W0PioFzU3i2gPVw4
	KyL0TVw0cIfLOh7yc6jeX2BIIDYGGxY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="RhXs/FjG";
	spf=pass (imf05.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756887974; a=rsa-sha256;
	cv=none;
	b=Kf/SBCIIByyJ9NwSFHWbJLQP/uItR36z9Vl8sThkcZHtz2+xkjCOHSW05+2wXoarE0uniT
	211PcS1lA3w25HTLRnvbXv6lj0lVDw8hHRsGj2GV4etXTOCeBClcbThj5bS4jB0yk8FQXG
	Ra7aMekAWrUCXpAcY4X9oA3rmAHkqQ0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756887973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RiF4X17MAgeDzab0iosntA9Q/n0cbzxTmlw2m/AGEGE=;
	b=RhXs/FjGzCq4vQ5tiYj2Kn+D9BIk/ovbNBJRBGjQqqOLZfE+AX7HgUk/P1faeOSzhb4Y+8
	rMJB0jssbVUIYqnCUFrjtaiF6ynpWpdj4JokJpQuZv0SEfi0o1FD8aLGWbexYg7aAuDKjs
	I+n5IqeuKh3rYMgFurqESvS5/It2XZw=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-xCxTd0KtMGaL1ZE5PTIFTw-1; Wed, 03 Sep 2025 04:26:11 -0400
X-MC-Unique: xCxTd0KtMGaL1ZE5PTIFTw-1
X-Mimecast-MFC-AGG-ID: xCxTd0KtMGaL1ZE5PTIFTw_1756887970
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-55f70884e18so1389779e87.2
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 01:26:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756887970; x=1757492770;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RiF4X17MAgeDzab0iosntA9Q/n0cbzxTmlw2m/AGEGE=;
        b=CW0M0hrug00jqACnXk5uVW/SDVoyGLBwapSk+NgVMmmClSuVigbHBuIg00nC8vGFra
         ffVor4RKLVfXCrmpZR+0mIxLWB1HywwvR3N7LY1BRe53UQVR5+nE3UcLoCzhizYXlUeV
         cLwRBgEQsbC7UXMWOcdjrWnIaIjaBg6Se6C0ZT98LGRkiBHwzslqqliEienvZcTGpjdH
         4utvrlSiX92YG6CcflVUhHTA6S5HfFLHCYL6eoFRT7kgFbLy2Gcuma947scSnioTKkLi
         oX1LjZJF+dZRr33qzq3kccvRzqSmj8CDNix3zcPGqWzcZnCcHGiVwifeoTCFaNV0t612
         wvqg==
X-Forwarded-Encrypted: i=1; AJvYcCUSNce6eqwMCib1l/ReS5hWlttLRueGC6GWKBeRyYD+5HhuiSngq9IEBtCyO+mKF11NL360FAxcnQ==@kvack.org
X-Gm-Message-State: AOJu0YzU4qrWUJga4lER0sI/mvJdn5mfQdQIeyIUmTysKM6ofkvOjVfK
	jRHwAjDoNxTZ0YmN3xbKfajZoSG/YeW/O3p4XV/1Ad8Bh1ToOkgii4S3eeTclxOQV0/32lp01XW
	iw6blg1OTDsh0+8EvBusbquj0vdKmI+t5EzYTqbL2xAhMgVGpM2I=
X-Gm-Gg: ASbGncs1F+dmBtHhRvdAJRUaSnOu9WGsb9cuef3mUWE+Zm8GdUQaf4qvg5MI6BAVxGC
	8dY71DYYpyH+AUniy/lChnuVodk+NoJjuN4zpluQtDSX9heuWO6Ic4aqQcrKy9T38A1DLYdeiwH
	PLSN7U2bxvyoi5t85k+yB0Ts4d8CtqxdVHO/H1Gwugc3bmFtVeLvNFTUlqCur2pMxamOFvbkq9K
	2gFbeMc/E2tQS/2dmitktOiXyJDOp0nJn7rMOUW4sma5D60/GFuMZVD3h/sZt5ykySuPNk8+CPJ
	H6eqARoDoz1Zh2VZvX5DWPcXH14m/UYLw6fkf5HLUGIrLsGXyNLOys4/67F399/JsQ==
X-Received: by 2002:a05:6512:6401:b0:55f:4faa:b630 with SMTP id 2adb3069b0e04-55f708b9a35mr3755395e87.24.1756887970184;
        Wed, 03 Sep 2025 01:26:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFo/J8D+PycrrERqH27xh2tlYz9vfDI8vGXXWnNGFn0lTfvQ0eYEz+wc2QoktugLroVCaVR9Q==
X-Received: by 2002:a05:6512:6401:b0:55f:4faa:b630 with SMTP id 2adb3069b0e04-55f708b9a35mr3755384e87.24.1756887969707;
        Wed, 03 Sep 2025 01:26:09 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5608ad525d1sm352909e87.139.2025.09.03.01.26.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 01:26:08 -0700 (PDT)
Message-ID: <ffac73b3-3c2f-402a-beb3-a98ba92c5335@redhat.com>
Date: Wed, 3 Sep 2025 11:26:08 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v4 05/15] mm/migrate_device: handle partially mapped folios
 during collection
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: damon@lists.linux.dev, dri-devel@lists.freedesktop.org,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250903011900.3657435-1-balbirs@nvidia.com>
 <20250903011900.3657435-6-balbirs@nvidia.com>
 <ea6caec5-fd20-444c-b937-6cab61198c46@redhat.com>
 <6a178e78-9ccd-4845-b4ca-1e84f7d31b91@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <6a178e78-9ccd-4845-b4ca-1e84f7d31b91@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cpMFVzdXOOr1v9xlX8S3xA3Uk_TdB6JYMVyUvEMEwIo_1756887970
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j1js971ehr589q69j47ucb9scd6yz8og
X-Rspam-User: 
X-Rspamd-Queue-Id: 7BE3C100013
X-Rspamd-Server: rspam05
X-HE-Tag: 1756887974-707010
X-HE-Meta: U2FsdGVkX18HKWMvsNHs45bGeQSFCPPIFAOddZUFPPDZaqV/ZoSAXlH2Y6/sccqcU747pH0A9sPotEblsBVDmF83+MdArB7Kq9hYv7F0AjFXChJOVDX6Vc/KXwIYvO9b68kz/SiPgbewc4YtxpK9ptYapi/zDeou9VEV8+DoSPKDjuN2uPwpvkeVEhE8ABQg47uJEnDrfkPVlu0G7vMTUJ6M3KIabIQStcOHRM0vOKtKdjlXeQhxpr4/4BDLXhWVgRKH6856u/4pR63VEoGJDvkba+hUxJTHDCmM77kpwkgA2V/s0U7AyNB7TYQoEMNXOzvdMCNQ4EIi5ErLGWRk43TVJ8QXV5TVOzDdaY9wOh6DpcR0Fs2LuG1hCOPqUDnDNBa8o+Ri7j7Q76bsihgCrT4ZlVNjPk1W8hQanql//79vsmRk1sFlIh8SznUGENmMytjt/81AhMDKU+Q6i19Usx3aw3jlghfvEZosuBaZbilIzZnXjmltmYSpXpwhrOIgQb3IOyG2uGey3hcTHunMSVWftvR8+/IAtSqC7LDwhLZxfU6uE4e2EHqKakKn05xFYk21lqEtFOdljl6sFB88nQcKRhqlEnY3WtSJWaDT7TVhEOnRp7K8d+TDsMoMCixCjRppLW3DsRq2MotESWAnRStPR9HbQZWmHl6+amB1voPMcARRLKf0MoJpPVBtN5JQuOyucSAM5fjF+vlXFVMzkcGmLRk/bmICK4CjfvGI3EwPpZYe8ICAIMsKsre86yeHJbfvJ6+199+Pg3IFDLHnxbO9PjC+xqQCIoXMeBXjEIG1o0BN9AxwavkyXhxfGrfPToaNX3Wr8mdzza65sBfYUEJxi9A8ujSWpeO5FmmjHO+LkBL54DnfuqtTnqo3wX9viBTyj4hlOZM+g5ZkL+xi5bNcN5XoYTxltA5OYM0SoM+EbhD/QmQAAZJ6+k/+nQxpeWzRCzSOfAkinDuIQbf
 9WkkaE3c
 li0Zm4Em+sTMw1WnHULuyDZm6qGDL9SRCRvS6EyuPjtxC0gS9CkIv0uNg7onF8ZCYh5BYDHgGv54KHPq0Ii3b1rGn/iuXzP0J/uc4C2KNrhh5KG3BKeuhG1eOx3yMcVHkMmfbOyKiyXq2keHoIF6Vo2DNpxpc8EBP68Adk1wgoHYdvNkwd1Zsd9Tio9Qno5Gfik3FuowtaCHZ5iaz1Y9Llzn07lz0cOU2T9bO8MLBpnmsrKhVaEcJXcWc9TIZoGBrEk39fhc2bt/GiI9LwQykixXJlVo6sps085AqNVSYSR4/lTu6su9JRTxCt44xWSUc89ZDMNFqFICZzlPBzK3iu4vul58ehPv0uk+WvNcn7fAv6Qg5YaRDAjPDNbXPaDaci0fn1pWdS+eSqAk9r2fXAbl3fDHgp5f6kzmmvsjAOrLqo3eIZsDQl93LdJJ39eHly1cT8ALkfhv54h6yb5xBdhJjt4aO+QkYeCdRxMTDNm+PZhirx1NYbNmqheBW87/K2eConsGSv0oImYA0xOELsdhko2CVRVZ7y/8Fs0t7JZu7xNQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/3/25 09:05, Balbir Singh wrote:

> On 9/3/25 14:40, Mika Penttilä wrote:
>> Hi,
>>
>> On 9/3/25 04:18, Balbir Singh wrote:
>>
>>> Extend migrate_vma_collect_pmd() to handle partially mapped large
>>> folios that require splitting before migration can proceed.
>>>
>>> During PTE walk in the collection phase, if a large folio is only
>>> partially mapped in the migration range, it must be split to ensure
>>> the folio is correctly migrated.
>>>
> <snip>
>
>>> +
>>> +				/*
>>> +				 * The reason for finding pmd present with a
>>> +				 * large folio for the pte is partial unmaps.
>>> +				 * Split the folio now for the migration to be
>>> +				 * handled correctly
>>> +				 */
>> There are other reasons like vma splits for various reasons.
>>
> Yes, David had pointed that out as well, I meant to cleanup the comment change
> "The" to "One", I missed addressing it in the refactor, but easy to do

And of course now you split all mTHPs as well, which is different what we do today
(ignoring). Splitting might be the right thing to do, but maybe worth mentioning.

> Thanks,
> Balbir Singh
>
--Mika


