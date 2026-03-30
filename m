Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17B31FF494D
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 06:47:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B7A56B0092; Mon, 30 Mar 2026 02:47:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 567ED6B0095; Mon, 30 Mar 2026 02:47:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47D9C6B0096; Mon, 30 Mar 2026 02:47:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 36FA36B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 02:47:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC59AE0A2D
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:47:36 +0000 (UTC)
X-FDA: 84601798512.30.3A929B5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7CAEF140003
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:47:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AUlkrROs;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774853254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9aCQuTNTsLLe7HPIpWR0T425blkhZIdKfq9OwEnPe7M=;
	b=Z10+l8Jae9/PKBtbQIMwv+Z6KYMNJWMmlDQlwHWgV1Pp156imelm5qmm4OndPb94R14hm1
	dmI7lFLrLC9jOj/FylLHDsglrSxMHB5wPuCLY3HurM6oANv7/IoZs+jNpOqSikWeQkaeiU
	XI07N6QuyBEjtNbIuxIhm4XlFQkEILI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774853254; a=rsa-sha256;
	cv=none;
	b=nPyydEq/ehHKjfX/YARNqJ53P+2d0GXKL3/pvxyt36ZwNfJOF99I21Oa3lpXuNvoqE+o4l
	Ku4Ec/JXRt4KGfDAsJxlVl076CkXF5Lpq0rMr5FwxqDjHg+U5KiWUHrQ0hfT4m7Vnl81sv
	wHYKtYnQCfHij1uByEp2NsoMcUokZzk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AUlkrROs;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774853253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9aCQuTNTsLLe7HPIpWR0T425blkhZIdKfq9OwEnPe7M=;
	b=AUlkrROsKC/qs7a7I+oivUPwUrydRl8Rn+DQ3GHPZgVRHs7K8whrPnNWOvStfd/EHDqLcW
	DICFHvh9s9pixuiE6j+cqMqwcaJAdZ2MBfnhFILyw+w4MsjIT4k6g9FrfO2Yptc9w6PLP4
	ogJC3iyamZUGYwhxvRKW6rE/jfgA/rA=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-474-yPv9MgJSMwiPKFuI3ZRCfg-1; Mon, 30 Mar 2026 02:47:32 -0400
X-MC-Unique: yPv9MgJSMwiPKFuI3ZRCfg-1
X-Mimecast-MFC-AGG-ID: yPv9MgJSMwiPKFuI3ZRCfg_1774853251
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5a2a203916cso3223098e87.3
        for <linux-mm@kvack.org>; Sun, 29 Mar 2026 23:47:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774853251; x=1775458051;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9aCQuTNTsLLe7HPIpWR0T425blkhZIdKfq9OwEnPe7M=;
        b=cLTdoeIwiiqdbUjR6UZmUG/Agxjo9E/yO0mf3NkBNUPTxys9KGPTpv8cTam8ATd6ri
         VtHKKEdblkv5nEP4YLqT/MyiiZLCVk3ba6Sg0D0y8/Zj850fwVQ/Hm5vHyrwiX2Ry2Mz
         It7dURwAcCetbePKf7OWWlrFawp4k/ZCoskP+/qsnjTCIr7Weh5rOGvKqWftmP7z4HhF
         xUbdq2h7FRQSt2fMpBZUUXMACThL6YCnkPwIld/U8qvf1WTxIONeblniwJzO2wkyLLBj
         CpcG7Fc8+QrZdWUDAl6kpwyMvCBk/Is+Q+3bl5r+S0pYLToS3wK8uxQDx57rkQjhOjAR
         tvPA==
X-Gm-Message-State: AOJu0YyU7QbFUsO85ADC2o0DwhofctJ9241Tn4ug0KSsNm+fYxLvcOlv
	Fr+8L7WicqMfDA55yPVW0gour5yyjmlJ5G5LW/K/Oypvo4Jt2CqvTYrKByjAgODD7iw7vQ0dZZN
	jD3hFZ5fkWYN4QVRxlDP7tig7toVices6+SlZzewrr1IHaA+0XD0=
X-Gm-Gg: ATEYQzzdeIYY4c6R4DeZql3/oYYu+1svE1NXGjJy0hXc8TT+2YFGrTr8jjgEjMB+yrY
	eVtPtwTErlXp6q6PgkVvw32mP3aiOe4BR2VFewXkrB3M9k2JQ5CDqpzs1LlRiJhvNMpA+bWT7aK
	4IEnGhNoYmrE7NTQnSG1nodLFX02J854J/CKR2ooxef+9+/P2u+kQDpMKZgEr8hG5euOO+kaXDo
	aaT90uOgF8ozwXTG/Jn5iA3zxbQ1U651WEXbI7pxH1SkeqGS2vMHG2XS9qdb3uwlZRU3Wa/dWLp
	wFvNtnSvLAI7QXabPPe59Jx6kRY5CnHXkqGyQHxtNtw9HnGmY4+nA8rNFfexbzFR81MTRSl1vN3
	KdyY84d31RCvbL2xI69jlczcmegs3CsAGfM60FmxtEr17B6k=
X-Received: by 2002:a05:6512:1296:b0:5a1:58d3:a78e with SMTP id 2adb3069b0e04-5a2ab7fb9d1mr3563114e87.16.1774853250636;
        Sun, 29 Mar 2026 23:47:30 -0700 (PDT)
X-Received: by 2002:a05:6512:1296:b0:5a1:58d3:a78e with SMTP id 2adb3069b0e04-5a2ab7fb9d1mr3563101e87.16.1774853250013;
        Sun, 29 Mar 2026 23:47:30 -0700 (PDT)
Received: from [192.168.1.86] (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a2b1406a8fsm1456028e87.31.2026.03.29.23.47.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Mar 2026 23:47:29 -0700 (PDT)
Message-ID: <0f3c7ea5-3e55-4e40-a5b0-543efab9adc8@redhat.com>
Date: Mon, 30 Mar 2026 09:47:28 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 6/6] mm:/migrate_device.c: remove
 migrate_vma_collect_*()
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>
References: <20260330043017.251808-1-mpenttil@redhat.com>
 <20260330043017.251808-7-mpenttil@redhat.com>
 <acoWmpfXXCfOOJGJ@infradead.org>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <acoWmpfXXCfOOJGJ@infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eYfKT9gPjr3-9gE4YR0g5fE4fmccDZEAQTXOPmy2PDI_1774853251
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7CAEF140003
X-Stat-Signature: j7ersujjo8xztkx7q4xo3d79ue7n76hk
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774853254-6891
X-HE-Meta: U2FsdGVkX1/Tle76qrbB8LraT9p6721Cms0StXol0onF91/rz33gM3q4OjVAftfh+X6Fv8zpH/705nbckAHNu2SwtYtzgcwoAR16Nptj4lKiU1S9Z+Vp/SbsHuLYs/6DbfId1ik8wLWP8NcPTN5s964/CfzlLr0T4Wz/vGLRMtv1FLJ9xe3278bLe8miPZhnuXVE2HfEJjhQMs+Fqmh4LOqL8YqhSeLUtnObRSA5ND8fWkCqX1Y/4SzSnrcF8Q0eehPYHbq8BZdlPkzVpTBEoarGnWZ9UL7BFZAizIlBefUCK6eweHH4PAS7on7naFzTaXN/CY1CJfG8C7PNXozxv8frEz4YxvmYwPRDi+JB7LLFop7T11u7aNyIN2PAfdOOre6b8Jxqc6Y7QY9EO+tv0AGuLhgfuWdwlPSeGSnig7pWpQIQkSthrEt2ZEDPzM8tNjYzeLD1ZlGMWqWf/vxQ1DTQlxvtmPwYS8UiZo5aQeHbIIBT6ZXPygL29fEsr/dU/f1cLZSc2ylBc0dO6KK9sEmjWvXQGtKumsmxO5s8XKbxkfP8Pwrc4vc+NfdFp0q/jU3k4I9kRgbrq+zHZGP0f0Q8Hv/Abinbl1VEVxwcv0XmdzVXgoz2qD0NbHxtURfo8QhMWrXRZ9++/M4eEAeu68Fk3vDrPq5ZU8TRZw3No68G27VJMbHIwA87fEimhN/Io13+WbR6aJXnW+UnzGY4apEhVR4UZiAo5+gAQEN3dyO6FKnmvyhLZ6xx9KdaGjm09hOQylioE14oekxk7yirFZma6gv28ahuEMGm9x7ZOvjcwc5rqOX4Yx0DoZeqj2VtqTXuG7DxM0GQCoCqk2JHJK/pmWZUe/PvUu44+b3FVOeJQTBNPEdiL1o+C2ui90HITk70GW16oL5OgZCwohIbZjk6Si75S9T3CpFX5Cz9P3RVfKuW5CAlEPfugS0JYUANm52FbZgmNH+ChFaoe36
 yU9cGQYV
 1ZbRp6X53BitS/adQBux14BJ2/Mh9h+VtGioJcIN2hkAQ33Lzwg8xyxvRSQ1PRPDD5jk5Wg2hyAFXNfzJOv+c+mtulne9SVRhN31jnjy5J0ARj37upsd0KoIyG5531wMEhu7BWTGQGM0yfpJxBMKB3OVJLOaSYg5Go2YZw+fP54Y8rPUqv68zI2A19nEMqiGaiWAMDjVPghK1FXI70T2Ta7E3mtM6I1naWI6TCt7Wj+1mN6twiAka+nVYbBnufFx/as+iE4+xbrDWu+eTQe7LIXXqhbenGXqjy9ZQKhESm2xs9rZ4ol/lePFFmeLQdzx0VeOiHECl/sxgPute6LLYzHapFtLJFIGVlwMlFRlghD4ewvAzuimo7l6q3EgDJS+E8TRoz0O/b42OOAraRW7BT0rN4yYcpxbY5xvgDY/u9U+J7hbJi39gKIeZg53VN7PU4L16DeOoBX2WKq8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 3/30/26 09:22, Christoph Hellwig wrote:

> On Mon, Mar 30, 2026 at 07:30:17AM +0300, mpenttil@redhat.com wrote:
>> From: Mika Penttilä <mpenttil@redhat.com>
>>
>> With the unified fault handling and migrate path,
>> the migrate_vma_collect_*() functions are unused,
>> let's remove them.
> This should go into the patch removing the uses.
>
Patch 4 makes the old paths not used anymore, but it is already quite big,
so though it would be better to have the remove on its own.

Thanks,
Mika


