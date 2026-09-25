Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EAEBC9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 10:24:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 680506B0088; Fri, 25 Sep 2026 06:24:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 657D36B008A; Fri, 25 Sep 2026 06:24:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5466E6B0095; Fri, 25 Sep 2026 06:24:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2CBCE6B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:24:01 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A7A7012025F
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:24:00 +0000 (UTC)
X-FDA: 85251899040.26.AE7DAB6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 41CCC160008
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:23:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fObPrYxJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790331838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nqSQfDrdpDYW051eAGtg8LkmO5WsRJfyGEnYEAE/NaQ=;
	b=aSyLIrtDFmNu6pKZCb0t9oPmlbHu9ry3JOeuGYq7eeZNul5u5gNeHc/BFaY11lQPTfgml4
	fMgnsuER83SLcnxKv5BSL5cGByO1z8E/gL8G/37n/EpHOIMUe+u+wxMGzoWOovmrdu5C7C
	XYWH8uQlCNxbRWp6R2ALPrTsDU1lkd8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fObPrYxJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790331838;
	b=kzBhftWJL9XOflFcU1xQoWGTjlaZVPhMY/87Wcg4LRnU2m6OlXz/HWE9Qjb4yJrx6sEYjT
	+JfIJKBed3HYyElwqCDQC6CfgPl24PN0glL5+BLZeZkkv7pxRsFw0fr9Ec5LVjF3nB4Y83
	IZHxbvy6XvX7nMLmqZ6i889JktNFiZ0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790331837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nqSQfDrdpDYW051eAGtg8LkmO5WsRJfyGEnYEAE/NaQ=;
	b=fObPrYxJ+0WIQLTXTaX/fg0HO5AlpBJJ2bsjD4a1KlQhmqaQn3V11dZDY4od1NiQVnTpZ2
	X2zzKP2beBnt/+ei4136WJcV0EC63mzlcEeirKQPUvJAtcAMoI7vjSBN1n31gPNzsY76Pa
	gbjY0plYyXnUTFHOSGKNN8Or2HvKUII=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-119-xDxgcQ0MNPmsVH8efpNUAw-1; Fri, 25 Sep 2026 06:23:56 -0400
X-MC-Unique: xDxgcQ0MNPmsVH8efpNUAw-1
X-Mimecast-MFC-AGG-ID: xDxgcQ0MNPmsVH8efpNUAw_1790331835
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-3a3546bd99fso3348861fa.2
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 03:23:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790331835; x=1790936635;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nqSQfDrdpDYW051eAGtg8LkmO5WsRJfyGEnYEAE/NaQ=;
        b=ZhP/BkG7JzTcensTI2Iyr6cSd+pAXGOnzaKgfxlazaJwmef1JJ4BXguF4r2pXE6qPQ
         x9kWaXdIvnsSF/y0ojrS0Tdm5pSJ7yw494tsHf/Zb4PxJXfee1eNstjLjbbY25vVZtGA
         L0K8Aj9DjupR3vkyigChCs8KWPpTnsPzsZOBOn/3Eu9MDcVEy+KZuCnuBRPxKBiYYpW2
         +05OXEA2uGTuX39T3dcSu+OOuxdUvqz1Bxf3eHTlM+BPlqcLggwN8507wTKht5dvWiza
         lKGusWCen2x2ABJzKzERpRhut77N+shSYOuTNY+0qhdCQ6k7tDuInhwYBqvQ/btYjQpN
         HtkQ==
X-Gm-Message-State: AFuF++lN+ty9H7E/JMUdpFkSUGH8YhlaED/UWa6vG3K5QgStigQvxc5S
	mIW0uigwWVzPI92och3naI/86R9sVoLFGhZO/2UUq20mBKuZGmDi5MChnM82fANIv+MBHRlejA2
	8hXkqMUZPkdJrblmCL9BC1lPe+alS7r+R/FkSjRpJHSVCg3AQdR0=
X-Gm-Gg: AYBFou0aNPtYHERBTrcCjgUwiw4uWd2ea71NqxtfKp+TTq348XFBKX/95RCOmKJef5B
	mCqFb1a6DZYvrbLpN4vzW8itvvNa1orHlVm6KtdEIr86hCe7lkofK6tjGmPFhcpUowaR0aJz1t3
	AoS7yKcW6UEoQq2UtJ/VNyZgPA1nnT8GjwnU7HSND74gSQRtWQDiCiWXjnwZz1q2EpYNkSFgcP2
	RIsJKirM629FqPKdKrBYo6L8kbvMFLPgebVJhu1+o7Q3VJuxVzQGqQ3ZxLYfS9+VZ8/SmkL7e7r
	qBtEJKEWQmQBKZfXxdOOqMxpopRczXDa+V7fVvSJLG4H7IJhdxFzVXi6mh79EZ1fyKHFGB86GAm
	iQJ58fYJdbJsaX7xZ+0nehf4FNUWPHbE=
X-Received: by 2002:a05:651c:b0a:b0:3a5:dfd3:41b6 with SMTP id 38308e7fff4ca-3a63bdbaf2amr14482561fa.0.1790331835012;
        Fri, 25 Sep 2026 03:23:55 -0700 (PDT)
X-Received: by 2002:a05:651c:b0a:b0:3a5:dfd3:41b6 with SMTP id 38308e7fff4ca-3a63bdbaf2amr14482331fa.0.1790331834509;
        Fri, 25 Sep 2026 03:23:54 -0700 (PDT)
Received: from [192.168.1.86] (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a64c2ea5d2sm4507651fa.18.2026.09.25.03.23.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2026 03:23:53 -0700 (PDT)
Message-ID: <65c5c412-56a7-46a9-b22b-22077a8e9727@redhat.com>
Date: Fri, 25 Sep 2026 13:23:52 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 00/11] migrate on fault for device pages
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260924065313.899730-1-mpenttil@redhat.com>
 <arY5zKsLuf7f_EYw@infradead.org>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <arY5zKsLuf7f_EYw@infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3kdx1WyL5LYlYFnfEAeyzdulpoy9Sgg038I6nlegihc_1790331835
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kdq5u5n3tiqorxiebgj8nj7gki1sd5zo
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 41CCC160008
X-HE-Tag: 1790331838-604324
X-HE-Meta: U2FsdGVkX1+yhRlPHA5e+N+OxeIb3NqmkXwsVTsEug3en+lJIuus0sXzHBu86ZG04W4pjO24hmf4I/T4wOlqcYTMbK/Ofzwm/kRujOv9/4uVcZ2D09l9TaYL1bNzXDjzknT/tVgrPNOhuvh/r1wQHZfbw/DC/gOD8fjuj/xVstASiLv2dShxc5T8J4oKsNQENZQ1sjCuwkD47sYi4eLHCZ9FcjAB5FV58/PLglNYAHyYKnQrOniEORVee9iEzUgk0wW2NimFXv3DZheERSl/gDIvenZ6AA7Ave3gGbQlLbKMO2Rse6mAggqO9JzPjjB9dhO2NzLhHJIPLLM96NInf6XNsVpko5lBBTH+m1DBgvp4d7+eHiNwYEWCUlAUQS1gqrpZv/9UWa49rRHa6zvYnhmalWTSJ62U/Ecviru5MzcNMMRki+ITFtI+mCnIs3AtlbzYLY2VQW1SYhI/fiBkCIC3WWr+tS2Omd4y2iLWrSQi+hyrWtlKCDSc8t6FBAd9UWkLzPp0l+yd10ZEZwMOUE4zvMuDllGlzaOdICyelbCcLjoKmYyo7o829yaUhOX0EF0YjXPa8CJ2ZPWa/jhhPKHYrOSN5w6Lp+rw/MPq+PFok7Cq3D/FBXZ/xXFLpT14ZEpryWaEtOtkQ6Lf2B3N82IQE9+fsFJE/RW+nXlN23r2GwanaOuRuMduYrY10Cz8EKNwg1eac1I4mR/BVqR3ZWWof6s/+BMCq4i8Gq7GX8Ih9ciqeQbFihI8d+LXaf+ndsu/jjrTbtoRFDif+E1YoizYfZhEKUwgMi1mCS1sss57KVmwoCjMKCPdBGUhZkpw+CYCaScSrY7kFU+EfxHzdOdeKuQlf6Zoe/pxpYO6ypvScGp5TwPLQl53Cafv1CnKvShFyISohN7D8iqtJ503zhdgbDWLHoSphJ7HD8ujLnExSwiTZgtCFm8SL/bDiq5QjkOotSA9fz8RpUzQ3S4
 o9hmAv8u
 SFRYvScu4cJEqVHAznBaSHATw87s1ZEwKJB3qPmZvoU4maM/ag55Yu60uPFtNfTNzmN7i+ZFiR6owJWKxNJGhugXxK2YEZerHc767CZEPBjwBSwmqN0LqfWsMB+ve3H7QlrlsJXs2rJ3SyMqRH94pljazEzZ892wa35XBsHFNcKDGQvAzMd6x0mO69HL9bIPv/8LEewf/oHCOuMVcvF59JnY5wOV/1qtjjNhQDrdZ407/lXGCS4Q434NEtgNMJ7HUj9pMZraWGTg768cmZJwarpjl7AnwMrFm4J5Gdjbn8GGjchZcbhwCpjAKKu1SzpAAACv7QKnEihmJXTE44taY8A74TATFl5ojd+8dKJfCqnAK148dw+HCwbV7i+OYKCSoBaz1LGIekWyMpoZevN9mW9WCoekBTQvEAeDKFwwLyg7MNux5Ll7tlxvy0qrZ8iYb4TvzwBGdorvBwR4HEA4vXFAnHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/25/26 12:07, Christoph Hellwig wrote:
> Who is going to use this? The series seems to lack an actual user for it.

Two users:

For one, existing migrate_vma_setup() callers, unchanged. The series
reworks migrate_vma_setup() to collect via hmm_range_fault() internally
(it sets HMM_PFN_REQ_MIGRATE and calls migrate_hmm_range_setup(),
mm/migrate_device.c). So every in-tree migrate_vma consumer — nouveau,
amdgpu/amdkfd, drm/xe via drm_pagemap, lib/test_hmm — runs on the new path.

Second, the point is to fault-in and migrate in a single page-table walk
instead of the 2–3 walks drivers do today . It can be driven by
hmm_range_fault() directly instead of ping-ponging between hmm fault and
migrate_vma interfaces, and lib/test_hmm exercises it. migrate.vma is
also populated now for free on fault path. These are aimed at SVM like
migrate-on-fault, and is motivated by Alistair Popple's experiments
with  current interfaces, where the redundant-walk overhead showed up
clearly in perf traces. The unified page table walker also avoids some
limitations in current collecting interfaces that can crash when raced
with unmap.

So this is a building block for migrate-on-fault but delivers immediate
in-tree effects by unifying, refactoring and more robust collecting.

--Mika



