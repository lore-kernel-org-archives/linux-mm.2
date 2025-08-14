Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E70CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 17:45:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D1CD9001B7; Thu, 14 Aug 2025 13:45:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A961900172; Thu, 14 Aug 2025 13:45:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 398149001B7; Thu, 14 Aug 2025 13:45:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24A09900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:45:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B77C1606DD
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:45:52 +0000 (UTC)
X-FDA: 83776090944.13.2DEA4F7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 33A704000A
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:45:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MsTCrdeP;
	spf=pass (imf12.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755193550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YLmNK2SIpYyqqZwufDdaR6EabRKEXax8n5yifa2/bJk=;
	b=lbNPOAgn4aDdytw2FbmL5q9x9PRrBq60rglY28YFAZ9b1YuorfkWNDKh3SiIENFR82qV/J
	hcs4r+GQRoMQMKzRfPRz/IX03dnnqtsLA/baXTRcc1I7l05bvwNJBL0laJP4SwJQ0uGzp3
	pGwsxWIuBtNCu/mJLQSNQkXoVEr2jMc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MsTCrdeP;
	spf=pass (imf12.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755193550; a=rsa-sha256;
	cv=none;
	b=cX/Q+ShM2vJacbMWFTQaSSgQLJ/yiPs8OSbz9BI8dDf/52GZbibaj5Mq+yCRvYHjiP4yhv
	IWH+8mpnNJWBGIx5IyfB8vOLRYHyFF8+TZNRERjXtM9OfRGpqJ0tf0kwzQrZgKE9VBqjvr
	LIWt4AisgmvYg67fJhvfzuxDLqxJNzs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755193549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YLmNK2SIpYyqqZwufDdaR6EabRKEXax8n5yifa2/bJk=;
	b=MsTCrdeP9t1VxBdM1XfOJ0hvJHzO8qP2T8rKJQ1irGCcsE0cE2XvqdMvLKuaYIQk0T63Zg
	vkXUxq5xOWM7q8dnmsuB4JNNsF2Chlr1wI9/hiFAbcIZZ8iQGmV2f5K1TMAMOztOHEJnC5
	QV8qPAB5qYi+9JcSa+TVtSjR6ANZtZ4=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-3JZByRO9Mm614OF-AjNCbg-1; Thu, 14 Aug 2025 13:45:48 -0400
X-MC-Unique: 3JZByRO9Mm614OF-AjNCbg-1
X-Mimecast-MFC-AGG-ID: 3JZByRO9Mm614OF-AjNCbg_1755193547
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-55ce527a1e9so807167e87.3
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:45:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755193545; x=1755798345;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YLmNK2SIpYyqqZwufDdaR6EabRKEXax8n5yifa2/bJk=;
        b=PHstYhTaEq/SBVOj1wDgJflL8Cl0KRQdo70Ten97xuGWaquItTZQjl2IGzG0Wpavob
         BwhLG6zlQipmZrqQxXvxTPGLtu2DPZ4G7xo4rpG2YtH98bjAy2j38nHRrOlh0QyRz9j6
         JfkSkv/YRWkLul7IE1+SXOVmnZyr29WzZkWjO9c9c1x08JZJzj/fzhcYmLFpJo4ym4Ao
         4mfLQ8qbjlmW8liHOJVvrx4dZRaM5MulTIduXGptLij8bXNdlVYcoIw+ZmEE+P8my+KY
         W16tkOFUyQqEqpb6PtNZXLhYjLYnG5PIUSwogOB/5NCRRfXe2okgQRTwwjZC+ZfPaIP/
         Bn8A==
X-Gm-Message-State: AOJu0Ywq+yV29/dOEFTuscjCJzKmWJe/T98LeHSVpitSm9tziSp4kwSf
	C0FnHNgDkgnFluZ9jPVncpC1RrzMNAdCFO8QybzaJCT8S+mkEd1V3rib2wxBIEkSqYctELeeozN
	fYZB1osOEQGtHc0AdqHYJryPIP0LIl5vaAQLnHOJ1R7XFdXDtsovn6qQdUOQ=
X-Gm-Gg: ASbGncsAiwPnvoNB0JGWv6l+Fqlg7p8Ywn1ZCrkabPA/c82WyMl0KLmKYCLEdxfpIe7
	cZ6JNcnS23wat68JrcABCkMYGQx3xMXIqZ6jzD0OKcUexh8wTuiMZN9jHIU0MN8XdwalZ9YZVnP
	/4rdDY+UhpMSM7CgaBZy/AK+K9FLLR26NNWTVEYjhv048GH4fH7td6LOrHKw2a7dDDWeYJloOXa
	yc7H/3499GR1IaM9wx+UXYjLXT/LSDcKI7ZG1gTtCOE7XdREuUvh67R2wEIOFixybUJNDYtDbdn
	Oa0R4kw7FSnCokDpb3tEJDElH+Fqys5UmcnP5MX1jmUskcc2iheBr2YVmf3z6r/d1g==
X-Received: by 2002:a05:6512:400d:b0:553:663d:736c with SMTP id 2adb3069b0e04-55ce50419c0mr1337023e87.15.1755193545057;
        Thu, 14 Aug 2025 10:45:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEoGvy/3lqn2+KUjafXY/lDwg1jbWintZjZ67vF2LurnY6HesQlq/ETXwqXt9X0M1k2WOx1GQ==
X-Received: by 2002:a05:6512:400d:b0:553:663d:736c with SMTP id 2adb3069b0e04-55ce50419c0mr1337018e87.15.1755193544623;
        Thu, 14 Aug 2025 10:45:44 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55cecfd842bsm15668e87.36.2025.08.14.10.45.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Aug 2025 10:45:44 -0700 (PDT)
Message-ID: <2982b6f1-7c14-46ef-afb0-7951f7cdc2aa@redhat.com>
Date: Thu, 14 Aug 2025 20:45:43 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/4] mm: use current as mmu notifier's owner
To: Jason Gunthorpe <jgg@nvidia.com>, Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Leon Romanovsky <leonro@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>
References: <20250814072045.3637192-1-mpenttil@redhat.com>
 <20250814072045.3637192-3-mpenttil@redhat.com>
 <20250814124041.GD699432@nvidia.com>
 <2da9464b-3b3d-46bd-a68f-bfef1226bbf6@redhat.com>
 <20250814130403.GF699432@nvidia.com>
 <67b6e041-4bea-485d-a881-cc674d719685@redhat.com>
 <20250814141136.GG802098@nvidia.com>
 <c7bbbbc8-b9fc-40f5-b86f-e43b9a85aaef@redhat.com>
 <20250814172018.GJ802098@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <20250814172018.GJ802098@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3CVYn_jBPY0l9yGbPqdLyU4SNXuYDu_Kj83rsc4_kTE_1755193547
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: eet4mkkf4gxkaz13t83x8rcrz8c6gz1p
X-Rspam-User: 
X-Rspamd-Queue-Id: 33A704000A
X-Rspamd-Server: rspam05
X-HE-Tag: 1755193550-830163
X-HE-Meta: U2FsdGVkX18AavuNeSdrG5Wm0USxqQJ7nUny4zO4e4VII7ZoN8Z0qDjqifAF6U3Bc3nlDCFdhBIQeaalkuBA0W79eupkcAmUx7CVP9CCszHeF0mloMWIzXQ6ql1L4UKEIV99OFQjMWgNz7D1urAvrmGXJTQZyE8i8n0I2Yw8aEqQCkubBWdvAMX4Pu0aheyqXx5PF6LdAkqccWwb+Im1ZHn3SBbzopb81GtXe4gt3qDBMVSusQyWLlQXX3lYb4t3HOLVV8OLosTI8G5PysaMBQyLlEZFH7699YGMNnUGAH4FjVBGWZxclQ9/TCbUoOg6JrpJRJfX7dOJp5o4cbEwzQwhNd01PYBXXNlDj3iuz+3+KJbl1EIteWsa2kyPTLzH28IauFZi9A6Paen0LXNWnv7cvdyIlvij0ggsQ4DgS384+tNpZjlfudr+98qoZOz2v93GQ9Ax0Td7kD1MZrqJGinjSkGjAVrhP4iXfmCNxmqAlGexYNlC1MsrRpRHz6qOPDiMxY7cY62iANMUVl/Vngy/PBBmVJuP4XokPOgHOKW37r8/Wk/SvoZ3lBBLPKS7aRY31MC9ilKi0hlv8XZV4cBNYiim/4merqddVx1xIC575GW3+Kubb19KW//0QhxZHyR1sOiG2LAoCHmvaJjq6fcdJWlsFNGRPi9338/Oe4chXA/5OUpiDS3AJ01ha8wEi99y7b8NVE04sXbt8KWZwpBCFbfXPkj5pGCLvZK581ixTcf4apkpwnW1snuNvfy+fD+bmgNVMBL9NtyiUgxckMWkyQ5VKcFkSfcw9Nr1tI/dlG/7C5D3aIQQInwGimd1Rn1eO3d0wfK62JgJegvXEY6lcDRW60eBKDmy8UWKpBDGZIeg/i9b/Z0fMThEEUdPnliyxx1wPVIYK2uT5eispaTzeHjKyni1V91rbsBkFmfEus7C6VqRdULndjKh2NrBj0PvJS6Csp+zeJZVlOQ
 IcWpZLcx
 iWUzOrPrnb172U5gre2OhZ8Tet8sPZb9oQBkBKDeRsrx+0U/P8G9FAt30ZkJO19++/XkkZJ8bx98iWBxMXyOv/xkh00EAatzyo+WgaL57oED3IhpSoCntCpxS7spghE3zv/mb+Ep+x7jqukzqrsxYIofuFDjA4Xz6gFfi9jUuDj2dbtW2InyOA9iJUitHjdaFmLHu97prTmeA93OHAFQiO/yUWHS11tG/yC7OzXJUy0SSuE7ksnZs2El6pCqVqnRT3OzO5bbkxPf/nzLy6ViVL6pFNsfL0BS8vmjnE4U/wHDeXI4bGVe67acYScYFt2XyRNZ8H3i3sD/vbW2TlXhEPbGkDIIFcNargbgRmH9SkaPiZtI7oN7NSix21Co5qKmKBurESWWhGoV1MzYpOeJr4TPf6vNTBzrAp4M8ah3N6MyiUD5XgJUUNGpVlw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/14/25 20:20, Jason Gunthorpe wrote:

> On Thu, Aug 14, 2025 at 08:00:01PM +0300, Mika Penttilä wrote:
>> as well as hmm test module with :
>>
>>          * Ignore invalidation callbacks for device private pages since
>>          * the invalidation is handled as part of the migration process.
>>          */
>>         if (range->event == MMU_NOTIFY_MIGRATE &&
>>             range->owner == dmirror->mdevice)
>>                 return true;
> If I recall this was about a very specific case where migration does a
> number of invalidations and some of the earlier ones are known to be
> redundant in this specific case. Redundant means it can be ignored
> without causing an inconsistency.
>
> Alistair would know, but I assumed this works OK because the above
> invalidation doesn't actually go on to free any pages but keeps them
> around until a later invalidation?
>
> This is nothing like what your case is talking about.

This one is actually pretty similar, MMU_NOTIFY_CLEAR is also fired in migration process
(split case) and invalidation handled part of the migration process.

But I have already a working version without any of that.

>
> Jason
>
--Mika


