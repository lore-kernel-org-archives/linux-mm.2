Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A63AC61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:29:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59D586B00B2; Tue, 25 Aug 2026 09:29:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54D8A6B00B5; Tue, 25 Aug 2026 09:29:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48AD46B00BB; Tue, 25 Aug 2026 09:29:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 291D26B00B2
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:29:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE26112044C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:29:07 +0000 (UTC)
X-FDA: 85139872734.01.A1FDE3A
Received: from mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf19.hostedemail.com (Postfix) with ESMTP id AE2D21A0007
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:29:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ma4a+wDO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787664546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9dQEhqO38DRHk4XCUejOWasQfvsCZoLTCPV75/KuII0=;
	b=o+NR19Hy6G1mVKFFU6xa80nllJliIc84AHlDkyzQSJhPu40vCq3odiUbbgWJa6RsIIRTGd
	CKNfdaNFgdOPKS13lb6O8fhdo7lO7oAKLmgW1QtUyJyXgPIBQ7TiHbIgEUTf8NCfHfQgcP
	1gcY56uZtWRu3VG8xMEPgTXQV0p+wUo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ma4a+wDO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787664546;
	b=CAPEnUHnBIwlDEGH1D0ollfSoxna73jxqVy6G2Ms515K0gvFL+GDCRayQsHrvSWVkvnwp8
	IT/UM9hgDDzwp0zjJyNYVYVd6ntd92ByPEZm+fFOHeJNDdjBixrerJG0VqU/b6SXUOPOKs
	SuHEh4My2Msb/pO86QtWPhkUBYyFcTI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=mfo3xCBtOpxdGVu2sNydgSqe8WKhZsunZj3l9KvjYH0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787664544; v=1; x=1788269344;
 b=Ma4a+wDOOOpV6bub7yRGrAB4Lm88lnbwQMFnSQln1J93NHwRi99k4t7dePcY4goJMw8K8Dkx
 rQ07ZiBZ2judWhqVFzm0GwITXfju1H7DDM9/SH4hjLVZckb+Ctzvqn5TKhPtgW1UdWdqxYqKsjZ
 GSZTWpgIUQ2VQ8P3EA+H7cvE=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.254.116.35] (101.126.56.83)
	by smtp.migadu.com with ESMTPS id f5151641734efe10;
	Tue, 25 Aug 2026 13:28:54 +0000
X-Mizu-Trace-ID: f5151641734efe10
X-Migadu-Flow: FLOW_OUT
Message-ID: <3e4e6840-e7a4-404b-84b0-5d4bb79d64d0@linux.dev>
Date: Tue, 25 Aug 2026 21:28:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 14/17] mm/hugetlb: remove HUGE_BOOTMEM_HVO
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-15-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260825084608.47437-15-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: AE2D21A0007
X-Rspamd-Server: rspam07
X-Stat-Signature: zxt6b65wkr6gkqyjm1h3gihkmqjkmcu5
X-HE-Tag: 1787664545-574224
X-HE-Meta: U2FsdGVkX1/LmybDb9h8xW70YWaM3U2gs/p3L3lCXG/gUXZRq47trV+IIEE/UaN5MAcDgieZSoyZ+V+1yEu3Z+5bx5R+1LmRueOMAw1AqQBmGmEU7rMqPYmA2ssD3w8ANJir9QpI09x0OQO46zGcxk9mVScQ25Lf7Ew1rYYxcW54/mxvsdw98v6Gfg7E1IZ+KyGe4twsQi3Gxx7w8Giq32L5DzAlcTNsFmufw0Yux4vnG+MLFh4ZNkzS52A8fQZJEfF8anddo8qlg1Kj1Wk0CrMVWyNWkusgxXt8c5T32jGS3XgajVWwY+jsici78uChTq5ZBCNSSsmHW1T5x8Lw/ZwVlvxpcpHyZO2Ad9ChnR1nU+XICbLorYqOW/tDOL8lJNMYfP0iBXGOjy6QT/NvF9kjJ1Jc6ragzWruFUlpY7RpOxkLzxtZjObxDJxhSBAarypuH4pjZPE0lbGdjoU/Xm5Ohcv0vZFGUYVFlrY0SgownAkb7MDtohrKjBatB02JKOWGK5/Rwoo6MPxHi0Fm1ynVx4XXPV37eHmx+WWq/VSOFLuLwqFavEWCgiTGK4EnZBcA7YlkKDhrZHG2NlFbncJIYVUTuzIG0wJ81OvwmecnBXazFm9ImE4EPXu9yinw3xeSd7CAPt8FukeeSkR7oxkRI2ezzrjvExHTdZXOq1mN+SF8M/SwpzAylNUbPXO3SaIiYGxDCxcj9sn6uTijQcGNssaU7QHgjBgDCgeNnoEGH0bPbdzHZdhXmlqtUKMyRPRztZduS3i9vgM/6WLDGNGgM96WihKb+P/5x3XHXqqhJ/pd6fst/svWXGZ8XSWNOBhPvlDL5NsupM5UZz/lhVjJ3kPx+0xvJuIpizU7Ca8KIOQ9EKYcqQQ79j/JCwIhBea+SdlSVZUJdYDHSTgV+s4ZqZASNU3g8X9aU2SVL/vkpP4wMQKKhCD47wBiVZkdpZAkhrFrQltNLZ+qHOh
 6ZSA3WVK
 e64aBqRIeHSjlijkHKey6E9UHcXxpF9UrpBcj8y0xoJOQfYd1xTB4HUMT9sH29xKKfEO9nRkEdC1RYilg9Y6oMKn721lQWQBfVrXBAb4CLPMsGcAh070djJaeAFia7dgNGMyNDztt4N4QmF1k0KRSNbasPQdMPxbtjcLgZ3vAoicBv7lNDpGdsLQgbyemq69OPGQ2bSnGtiob/kCS2BkSySfLVgmdFOqgolTD4m5pbYELAuDjiYYC5mnBGbuaojAUQTm86oFZgQ2jveR1l0ddYXsEsq6zkj3c2EdxQ6U4ROXhBzlgSv42LqwcVGB1iYbbvHSiziLgFOxMAgGnAdxFmtIYahfLATNAA2puIjm7O1TN3tkS+jzF0XWhQTWTsPQVJhF0tvhGeh9WmzL0Ceny/nNccJWoAy9lBhORoJH00YckqKOQ5hMW8OJNW5bXwYVLqjSV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/25/26 4:46 PM, Muchun Song wrote:
> The HUGE_BOOTMEM_HVO flag tracked whether a bootmem huge page had
> already gone through the old early vmemmap optimization path.
> 
> Now that HugeTLB uses section-based vmemmap optimization, that state is
> already reflected in the section order.
> 
> Remove HUGE_BOOTMEM_HVO and its helper, and use the section state
> directly when deciding whether to mark a folio as vmemmap-optimized.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
> v3:
> - Use the order-based helper for the bootmem vmemmap-optimized check
> 
> v2:
> - Collect Acked-by from Mike Rapoport
> ---
>   include/linux/hugetlb.h |  5 ++---
>   mm/hugetlb.c            | 12 +-----------
>   mm/hugetlb_vmemmap.c    |  2 --
>   3 files changed, 3 insertions(+), 16 deletions(-)

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


