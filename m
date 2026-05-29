Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D283DCD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 13:42:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C67C6B0092; Fri, 29 May 2026 09:42:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29FD66B0095; Fri, 29 May 2026 09:42:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18C066B0096; Fri, 29 May 2026 09:42:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 06F646B0092
	for <linux-mm@kvack.org>; Fri, 29 May 2026 09:42:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D028AC04AE
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:42:09 +0000 (UTC)
X-FDA: 84820571178.05.CF5BD0C
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id A7137180011
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:42:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="M/JMRTLy";
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780062128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gpbakxeVUDkW3G1QkEPqtCqf9wGLZXcu/9D8TGYnFkc=;
	b=4RpqMFDGL8nIxBNOA+FgGyNHT3uqSTfY4SYU5DCfJsGCWBglSacQqiv8qMWQLaCiRwoGOs
	/yK0AYZqH1pXLTSV9px3C/zkLg4FgGswB4lGiPpTAHWb0RhWsWwvOEe/GUQ9KxYA8BnVGe
	6Km6dKePwXn7T1DUlYxotKtrO1l6MwM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780062128; a=rsa-sha256;
	cv=none;
	b=GvBiTwgSEv0Dpp5g7fWlANFy1fwHwgyzoLB+66/J+ad9onJxANN0XEEJtMhSf2/V39r/Re
	xezbWD1AEBHpQnloE5q0EiCxFLNsTR+n+7g0vMh7ZbH6OjHEFNGlXESPh/Mo5zhTc2IBOo
	4KjGc0urth5nyLmcP//mLZgLuCo9vLs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="M/JMRTLy";
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-914beab9a08so542422085a.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 06:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1780062127; x=1780666927; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gpbakxeVUDkW3G1QkEPqtCqf9wGLZXcu/9D8TGYnFkc=;
        b=M/JMRTLyPYJ/8HvhMIkeRG+QuVXbyBO8N4K7BsSed9I0N4AjWZbDwUfvNK1bYZS1f6
         OCcrGOXk5KbJsnMtwo2mhi9NKOWsn1KRj3mySKWhk2gxO2WuWz6ZWWvSVjVG7QaSiu4i
         QaQtWFgESZP0n/4DFtFvBU8EsZWAaLJkqd2TGQy5nvdP2js8u8FTBeJoyRoXtJreymli
         i/PPSgxRT7lfWlbOKh0CU+o6vpq7D0LaqB0qdRXIAzsep+am8axqsopkxqSjunyuv1lZ
         fiDsYrlqbpp8/a2uU12esrGQ3jceyZOz6WISwKgVl94/v7Azoz4qcNjlUH8TR4I5+d1L
         7glw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780062127; x=1780666927;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gpbakxeVUDkW3G1QkEPqtCqf9wGLZXcu/9D8TGYnFkc=;
        b=QWtUmlqTKhMKPn8+wonmHYvETNOQlEBJ8+pXrXcj/9oGnxM9ZniPHRy0SPiCCdRLdZ
         YltSpVc2AG/FPzLOEeRq/rLmIkRJsBzrmo1XDPV42l2snINIgvNOXT7ubcZ3H1om1ymi
         /n1n8Dz9402n9F/eET+hhg5khror5ENY4RkLBk+IATr4RSmFGCBktEqWr1HyOH7hl3fg
         vgmKgoeee9l1HCtKZu1H6hOzu/wIYnWH4x30vX5LdBSoK2u1yy/rkI3VJ1Xo3GpepZoY
         xpowj4jAXUqpulbCk1BoD/YRwYo0D5himwyaaQnHxxVdLXiptKWElmyPMgQxTu++BFJS
         jdeQ==
X-Forwarded-Encrypted: i=1; AFNElJ+sNGBDPgsldaoAVNS7UXTS9rX/zKzPl3R7AnnbAotytT/ZQewbJ8QY78Dx39q233pOP4VVPeNEkQ==@kvack.org
X-Gm-Message-State: AOJu0Yw+HclC/fXAXmWpIBVoZmUPp7id2hk5Ih5W/CvvLUpfKCZqJlqQ
	r191uK6dbjYSTugnV2uxfXk/BGa5Y27RBdh53VWASzRMSkiG+7DAXC3lE66IdMs2JGo=
X-Gm-Gg: Acq92OEhMAWi7WjfoMkt+nIKQ6EWtLorwnPwP/3jjjutOHA7nyu6jKEv8/gV/e8v9FH
	EiEDt6nnajF/pfjk0T3qpjNzXFr0aWzLoTjeMrS5d3D+o6806OnOSe/A/c3tmAy389A15a2lCU9
	61b5dhp15XgvgA9m9MfYlqY1oakuTKfRsFhMnnWC1X1M71+e0IQlQd/CzFWuaqvxhUSpDVH5DHM
	9bX7t1oEEAPt7sP4c4HuS0O8b+t8CZJ88TU8E1BGP4dHNzG0mK/BQh1CyX/hWHlyPDNyffP9aY1
	IA5pqFFJGVFEEMKgTEpMhenhsbLM2/0OtVHBBXsDwoBvpgQpB5XscLgBza6SIyli/BPcKmtcxOo
	3e81+v3N0U0RkiixOuOr9invUtM/T2BGmQqU8XLW48cy+ZwK5faNnQRV8xGzfao/ZMmk540latu
	Mh4B+K2hVuSPBwDVUZKK1IAO6Xm5bV3neX1BV+kCXDkKY=
X-Received: by 2002:a05:620a:6f0d:b0:900:8024:4f9f with SMTP id af79cd13be357-9152ff63cfcmr375008985a.60.1780062126522;
        Fri, 29 May 2026 06:42:06 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9153265d794sm185888785a.47.2026.05.29.06.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 06:42:05 -0700 (PDT)
Date: Fri, 29 May 2026 09:42:02 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Kairui Song <ryncsn@gmail.com>,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 5/9] mm: list_lru: deduplicate lock_list_lru()
Message-ID: <ahmXqjQ0Vz4pb4u1@cmpxchg.org>
References: <20260527204757.2544958-1-hannes@cmpxchg.org>
 <20260527204757.2544958-6-hannes@cmpxchg.org>
 <20260529095628.nagjdy3f24z6qjtk@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529095628.nagjdy3f24z6qjtk@master>
X-Rspam-User: 
X-Rspamd-Queue-Id: A7137180011
X-Stat-Signature: qkbhwh8xx3hrrkr54k54yd78gfqso4yd
X-Rspamd-Server: rspam06
X-HE-Tag: 1780062127-112181
X-HE-Meta: U2FsdGVkX1/ml77dsny5luwSyuXgzMJOsnoh6m7NhkNZYxsuoGRh4Umh04ukMxYd6d8ikeMs01Od6/WO9ewPiYPKLRZTFQw9w64N+sTmmHbqCfdUBDzvKtDHWzSFMO0+oiR0qlYVOs6mmcFZ6nAyQMuPNPndzV6qOEr9cV2cJwaZzFI4naMrs3cV4wN4Tew+YFLMULwV9XKTEYLBTKoX2kxGLtZAIIFH9nidQ89IzClyjwJ9+gEkV0ajPUHjJwMeRvq9aTV6QQa5f4C67I+p9VPepKklvlv9A0MnDhUrEOly9GDbfNuSSD1kY6ZnZaePWdCew3g23PUsBxewI0ml+YokH5JcJK4KGsC6dCf7qYfNxoskmtL4TbNPFEMhUyVic3a6ELeyvf4adsDfsN1u0rQOdeSEyl+oy9O7uO1dRgLF0oq7p0vb/Jiem4CwiZ7aFLu2lQG3MUt6xM0zMJnHvyPKlWzOKOIsWOan4x9rAmE1pAbq06KQMRkMTaPfHhisJ+oWc6CsQwzxZHm5tv8JQJGvmUAvSmJwQ7bSaLXt6+88os4ZNzIU7dQoOz6VnGcP0VFWO91RPj9YEcCph+oVkgQn2Bnns5iDAyfGCHb4pkV+lYI1sY9iCcCd9PpUUSC0V8V4psOTkCfbZO92OZJ57piEYsCiocnLVSAequEq5ZWoi+M0+YX9Bdj4+L/E4jxlS2DIDpELisnkyewRdM9NzeciFoV9PLLj8ENIFWYds/RYKNkio3jYH2gJ1d3DOmMEKm3zcR3lXappt3ZDqHBQWBBIIAvYA07DXEeaiSDGWtnStFQCQUkToN5e/OOq27c4W9IzQcq0elyLfrEcgRTHrvDyidKG6YhVhoCdzoYs25x0r2Amu0d5gRw+mTGviI8i2Khg7o1Fv0zN1gMklVdXU+DlHr7Jsi3PS5gZjIFHZwpF6kFZKt2EE/4laV8k/c4POk8cQe7ptqT3w4SQX69
 QzGxw61z
 CSbW2wLDwSs8F2L0bGKPPVonjWQlXOIbfzi0QTBVEWQpdWG/DNsFh7+xms/B0I8PrBZG51Xj2t8KTcxbSoQEBK5pVtsoVQst+rHqrqnuGrfDNIaAS+8TKgJyyFRCq+OsNy+/pI2stL/oLEMY2xtxU/OLmoGzvlSsq6XQEwB2cuZ7oFPGGOBtKoboTMIlW93jJvSPixkaWOAEQ2e8VlqvoSjtmEpuHbrOAv6rZtInA6mtkLccnLHxKaM11UMQTI/uhHiX4odmIh0lLpS9ZkngSudb5ZEfW/Indmmj/HkC1FpI1G7eqFotsLInX8Iww3BMi3sZHM4YmgNHoPivNfZYMe3TeBdP5LbOiRJMdoFLGHV68riWPOaGuoBXtssFeRHAYC7iWxnTJUQeMOzeVeN8splXegZEXgv7Un+hL/qQhzb8jFaKrTGCzr9/qwW7azaAQJlrDlJ0K3yms1LslLW7AjUsS5kiZlBk2N3bxYprfPKjWiybI8T30qcBbXB2cjoCDQATvY52+iCWPQYqTw9DXjTJFbvHEG2B+8XrsgVIJN9MQ1z6oOwW18Yi6R6qGHo92IDc5KB4tAoBR4umC7L7oYdv5oS7B70UAXisf70/TSfbdUcsH8JkGx7XQMNCmLruUbRYYbwwhli1eawqhlX4hbNzJwWLnR9C0otKhTotE78qKXlgH1mbBLvcuSo8p28PM2QoJwbXTCWKCS1R6rWiQM/XROw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 09:56:28AM +0000, Wei Yang wrote:
> On Wed, May 27, 2026 at 04:45:12PM -0400, Johannes Weiner wrote:
> >The MEMCG and !MEMCG paths have the same pattern. Share the code.
> >
> >Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> >Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> >Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> >Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> >Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
> >---
> > mm/list_lru.c | 21 +++++++++------------
> > 1 file changed, 9 insertions(+), 12 deletions(-)
> >
> >diff --git a/mm/list_lru.c b/mm/list_lru.c
> >index 7d0523e44010..fdb3fe2ea64f 100644
> >--- a/mm/list_lru.c
> >+++ b/mm/list_lru.c
> >@@ -15,6 +15,14 @@
> > #include "slab.h"
> > #include "internal.h"
> 
> Hi, Johannes
> 
> One very tiny nit below.
> 
> > 
> >+static inline void lock_list_lru(struct list_lru_one *l, bool irq)
> 
> Here we use @irq.
> 
> >+{
> >+	if (irq)
> >+		spin_lock_irq(&l->lock);
> >+	else
> >+		spin_lock(&l->lock);
> >+}
> >+
> > static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
> 
> Here we use @irq_off.
> 
> Do you think it would be nicer to unify the parameter name?

Yes, I think it would be nicer.

Note that I inherited this - we had irq on the lock and irq_off on the
unlock before already. I didn't want to mix even more yak shaving prep
patches into this series.

Mind sending a follow-up patch on top of mm-unstable?

