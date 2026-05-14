Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 905BBCD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 11:51:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BECB6B0088; Thu, 14 May 2026 07:51:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86EEB6B008A; Thu, 14 May 2026 07:51:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 737176B008C; Thu, 14 May 2026 07:51:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 62CF36B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:51:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE97C1A0580
	for <linux-mm@kvack.org>; Thu, 14 May 2026 11:51:09 +0000 (UTC)
X-FDA: 84765859458.17.5B3A6B2
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf12.hostedemail.com (Postfix) with ESMTP id F22414000E
	for <linux-mm@kvack.org>; Thu, 14 May 2026 11:51:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=k8vaC9vE;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778759468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3otPrX8ylWiqgm/t2ct4ZpbOY2TynCo6XoPa75Eeyno=;
	b=HflAlSX1vhegBkCJrC77xwcovSbBdY9kPz5gaGgavS3hCanWlGGMrKB6DXjmJJVzZ1iyLy
	PaUiQICg894YB2FTlS3sFT66VN7l0rCsxak05/onfDbOuwaziaJDSa08MiN83sxQqO7H7h
	S6HGO/eGQkiOVT4DYroE+NE2A/5eVSs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=k8vaC9vE;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778759468; a=rsa-sha256;
	cv=none;
	b=EjT2f7nd2E1b3HLs3A56tLQPAaeW5zJ4Je0nNmXzmimVH0iUbjTruZi4yBJUqhRo/WPoyG
	XgOEjtOE2UDPc0uL8Yi4927pYhFTSzk9HmH/iFURhX35mHnuarVJkmc3wp2ZQrFL51UY9m
	0UWFYzMKjl0YWGJ81BBZZF3xzndHFMA=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8b701756684so81371946d6.1
        for <linux-mm@kvack.org>; Thu, 14 May 2026 04:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778759467; x=1779364267; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3otPrX8ylWiqgm/t2ct4ZpbOY2TynCo6XoPa75Eeyno=;
        b=k8vaC9vEjbxWak5OBgmn0FZwJTDM1mvTySY6fjS8JbWoQLtlFWa4p8d7kohNTDUyCD
         fCrsig7QyFY7NvKD9ApYc+eSyy7spUI2Wqai5XppfC5uk0/G0e6zvszI4lwGjob3VTzp
         ZV2DpywmyHye2MAu1XlCgSdxyW7DNYHFKbyPRfh+N+bL26bWx1J8pGgWA8FBMmMn7Hul
         PFloBDvx44+ekrixNYeQ244T1hWPIlNI01so78zW2q0XsAVhWLY10Tk7vBVgMA+EgZsf
         +29iul03ipsJO2TUbjs6RSJBkteox1sfoEchrX1G/YLbBv7360z21hIwtuJ5BqtN9GWZ
         QcQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778759467; x=1779364267;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3otPrX8ylWiqgm/t2ct4ZpbOY2TynCo6XoPa75Eeyno=;
        b=l3grVC9C7UzyuvYlwwzRZcbB/YJowEEyZlO8UDJdaT01koy5pgTQLnCLu7sSJ3AgxD
         cP7efn3NvXYTTsoHRtDCNxhrgVx9hnAlfAT2CSLrhWQosKbXj+p6amZ9Xa+do+mmKf9T
         jHIdUdgykxZk+L9d39sB1qJpAAZP944rAR3POwywvyemkyMv6RgMli4nrUGavFC3VEos
         Mxm4qmjXIclJLuaY/KfEy4rw0kDu8OLn19PV+KYOubtondfOmcQguaPskyJfy2gat/LY
         Drd31P78Gzx0gpZlblwxwBVmmOB/7lsSSUXtSqsEUM4IzXDae1xu5rEGD3Z0J6zSTlNx
         1XFQ==
X-Forwarded-Encrypted: i=1; AFNElJ8WWSI+aRbSNahT/4qItBObflf8JKhiG9vnOb5WJXUs9AeLwJwnvBTyWodtDdvIS74xPEbmhWsqzw==@kvack.org
X-Gm-Message-State: AOJu0YwZocQL35BbjfPa9es162EzVC5St0vFMoXxFGxbYkiOqZL7Ud4v
	PSalpFdUBnOIaOl7F8Nz4O+ds2vCbkktCH7nx80Xm2UfMNaHx9Kzqrbm3Gq7vmAK9To=
X-Gm-Gg: Acq92OGWVwSnfgA53SU7CkZ5ed4q+GZJenBSi+smrsH0fOgK34BRPR97hMPKfcxhJZg
	qthylO1VR740n7nFj9LCZH1K37FvYUGGK64nAgBdZvn68QWT+SKFAeMHamUYZqptO5dpBCMrlqr
	QK9rX5epVwiWIntLaVXWZGjzjLbxp2EGJ0lDxsiE+zSzGu8IT3ngieC3MqThYfhvWukf6jWLdhx
	hKmX7fONr3DgIdZTJVTLGvOF8zhcF8bD22c/d5JprrAyI/CyAIz6cblxdIbnV61U+A/zthq6P/i
	xTyLm97CPvL/zoYomJc7wcPF9lX2Y5elpEikC+Qxut0e13ECnoeAwGw5Bvjm3f8PlIh+UDZgVAu
	Ru3fPyvgZ6MdeKeWdOXVXKd5NQ4LXWZh6Od8c6g0I2fzh5l2xk2GaTFiVzlISwQxA1s5Aaj9h3l
	YpTKaHuLKXLuDCrZvY1b5K9f2rEmUPC/a/hoplmbpFkWLGCU/rhoEszfYhvSjlY99znShznsjFd
	ml9OwMfe2bg+37MV36DvrY=
X-Received: by 2002:a05:620a:448a:b0:8d6:d217:96a0 with SMTP id af79cd13be357-910abf49b96mr451245385a.0.1778759466839;
        Thu, 14 May 2026 04:51:06 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bd620fbcsm229997985a.42.2026.05.14.04.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 04:51:06 -0700 (PDT)
Date: Thu, 14 May 2026 07:51:03 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v7 02/31] mm: page_alloc: propagate PageReported flag
 across buddy splits
Message-ID: <agW3JyLAwVsCZ2qR@gourry-fedora-PF4VCD3F>
References: <cover.1778616612.git.mst@redhat.com>
 <feab82b370b3e66b58b9cfbc1efaf26fe6061d2f.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <feab82b370b3e66b58b9cfbc1efaf26fe6061d2f.1778616612.git.mst@redhat.com>
X-Stat-Signature: s5tz84q6m5y1wb9ui4mrguaxoba118i1
X-Rspamd-Queue-Id: F22414000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778759467-458073
X-HE-Meta: U2FsdGVkX19gsFK4SC+7gHXMnVhw44Y7PCgpog7KM23m5mSxiue8cH9kQcDz3pYp8IOIwaCW705eNErhCcP7b4unMWmykXpMSqAvSEMBwSaV+EE3BQUwZYXKTRoxt3O0Rjlwn2x5sm/+Guur9d2NB9tXCGooGmq7iDExx/aFmEpEIfkozNov1uP3zuhxLVNBCIRs7h/iLhg9yGPVzaSCRcT7D8uUwX1OAaju/zXpHcFm13sOq26ztYRD+aEjZi+jWwRNchGPZn6j3ouA5URTmnBONtvgLlpzNeuN/vYxFQV2Tmfb9GKLszdO0vK7jIX/8uMmAL45jbd7q/SbMnvvnalvObqg87oSMdA9FG2Bhbu8zqyWIWoUaxj6J7XGzbvQ/TJ3dU9gvRJF8PCBQVnVJnDRzeF+vOfHH5vl7rd7/udgTwLy7aX+lxyLGlWy1OmvscpPYMz5oW9odAkYaZq8t2PYJiBOVTxGsb5xunru7Ja1ER6Jh0C6uEjH8o/RmLAJP8/ndfrf/OUFhyiOXd9N5vVu3CY6fyT4clV/HvC9WnYFJOIWRM7RuTk2iAAsxMULpNZOikp0402JQkwN17o6UWMGd8bIIhD9hZQFZq84XP2ueyLpdmB3J5IatsQhuAJoQOaZWMrbYvHIAE9n1kTZzM9Trz6uvQoSJBqhyTQ6OxK8PgcleU2QQTh06tm+DMNcO3P9As+1DdOcvz28yENSK64ZAqMe6CcPNVm/mqmUH5miVxzQ/yq5Tv1UGoPItpM8ZLrufs2C2aS0PwDSoUXVLYcKMTFoY1pKJIecgYkCPY9d2e0vqOTTaM+V/edEUrnALyl1nS0y6csnEnDK+7ijvoQDPeF4ApqjeHVcQEvCGlNTVMc7cl5Zs+9S9eF+AouWmEdEP7qprhi0Qui5m45sAPLqg0lTw4r0rPrAoaJFLh3SqhbZXh2I1l5KxUHG3jLx3tfMF8DKLK9/W5xTyo8
 bCwwZxf3
 +MRObjONXq9zU4VWZErKii10CF/fslMXyiOUxiV6uGvFefDMhmSPmI2zbg70C0JMYKz60PPBrajCdfsu//10KJHJlB0o1lyzpg1CATRrsGD2unk9V+bPszzZEFP3g5/691/kt8OL0RZHxBEXbQ3e7vITfaX4yYhvnm0rfhkKOXosII6zkw7pbNxbuVTwAxlPrJ+mjv3HK/KFdHagUJT8L6GK4UJTfXW+c5SgBARCfGWy6dzfBev45CnlK1+rXuowl/ZRlgtNGc5USAiV/viEmTTY4TGGvrZTEz00EwY6GofDJBddCxPTqTL5gkQS6vi5fsqqmgt3b91m278b4QZRZxh8idZ0Hz5tDRcexstd5x98m4fwnijM74wj3w64/PCmREi2ENymrJ1vDrZqNvAHvqrtec5xKvbUCPPKIt5desd/9WdB8WubR1KvYQ9sYmWBdy3yfRn2ynjs3dVnZuBcksDwPdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 05:05:16PM -0400, Michael S. Tsirkin wrote:
> When a reported free page is split via expand() to satisfy a
> smaller allocation, the sub-pages placed back on the free lists
> lose the PageReported flag.  This means they will be unnecessarily
> re-reported to the hypervisor in the next reporting cycle, wasting
> work.
> 
> While I was unable to quantify the performance difference, it is
> an obvious waste, even if small.
> 
> Propagate the PageReported flag to sub-pages during expand(),
> both in page_del_and_expand() and try_to_claim_block(), so
> that they are recognized as already-reported.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6
... snip ...
> @@ -1731,9 +1740,10 @@ static __always_inline void page_del_and_expand(struct zone *zone,
>  						int high, int migratetype)
>  {
>  	int nr_pages = 1 << high;
> +	bool was_reported = page_reported(page);
>  
>  	__del_page_from_free_list(page, zone, high, migratetype);
> -	nr_pages -= expand(zone, page, low, high, migratetype);
> +	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
>  	account_freepages(zone, -nr_pages, migratetype);
>  }
>  

Maybe mildly out of scope but worth asking:  Are there other flags that
should be retained/propogated on a split?  If so, rather than pass
was_reported, should we just take a temporary copy of the page flags and
pass them all in?

~Gregory

