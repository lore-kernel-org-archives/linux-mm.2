Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19EA0C5AD5A
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 02:37:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A02256B036C; Wed, 12 Aug 2026 22:37:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DA1B6B036D; Wed, 12 Aug 2026 22:37:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 917806B036E; Wed, 12 Aug 2026 22:37:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F7B06B036C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 22:37:13 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EAA39A2B53
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 02:37:12 +0000 (UTC)
X-FDA: 85094684304.09.09BE897
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2C91F80002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 02:37:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=RX2asCNs;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786588631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iAIlYFnXn3LVoMPX9IDRNtgfCfuZ8em86m2CaDU8/H0=;
	b=MJdjxNmmafMXESzf7t1pJkc8Qia+573DFRDYPcr+KdgO0uT6lUIT+iP/ETwtUkMGtG7VvK
	/nZzF/gdmJQ+RPsAIp19UduBLtJT8OCAY5zYGxfrcLFMPjDpndu0RgtefSUR9oDWdVJnRy
	gOKkV4xbGoV5w61jmlAnhbYKhhpkdms=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=RX2asCNs;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786588631;
	b=6GOAS4UP8A5SArGp+9l/Z0GRxuuVNuUjYd9JFjSYkvEbb/ksMeez6iHngahNEmTMz3jG/e
	IF8NxjIgRWKuKZcEHQX4ganDo8qGKrYmWuqERmeJION8Ui7n3khJzHMl3gfFt+T849+LQ9
	X6NS91POuOM4CIU4C8hQn5qwrMmqWmY=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-92ed19f4d60so32249485a.0
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 19:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1786588630; x=1787193430; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iAIlYFnXn3LVoMPX9IDRNtgfCfuZ8em86m2CaDU8/H0=;
        b=RX2asCNsJcDBgegaCdIooiD0NN/h18980CSAyTyLoR1ZygoyU0+YTtJuMkZvrjsTav
         93twlTCF24JpZ/zey/DTFNlkaphXRbFK/DdxkbF6K5h0kYYINv/rQ6Yq43mMO8jLZUgf
         AQYXy5cZAeKE5lqopQ7Bip1ASZiLILKlE731iX1BCsY6XC9NLOBlF3tN+Yvt0Bq6coPR
         p3fr4SfjFbXM1qz4lua5ZAr46LvbtN9VcBWTMNbbjrXKr6JyNNH3nifNnWopZ6SB6w7C
         7LOH3jb0Vj634EjJI/knv+A6mAQKGefcx3soxmKGXRdmWFRAW9Pl5RMMisd+6znX42QT
         wUrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786588630; x=1787193430;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iAIlYFnXn3LVoMPX9IDRNtgfCfuZ8em86m2CaDU8/H0=;
        b=ZCdpPEJlUZz44UrEVDKWDYayndb0RYqhaWylzF/ftAIdRy4DwUYj9G3TAQtNKcw0zW
         uMHdNvyBwdHqHPc94T9bdU3wNdOfigTHadIqxYxPBD75hv7IaqgiyEX5uYcgEdVsdGGX
         VsC813oiex0+7N0ESttmijuEr5RmHAlaP9PUAL2VlPhDlO9MvD12AC2lnOwZ2imUrqjm
         3X6itPvD0YPuYG3UwK1e89J4Bm9wcefl7SQWaqMmORo4UN+X41W6hvLjzmFD5AeXSuOL
         ZZrfL4heTZBWP03TeBkRy+NRMtInQvliQ+9wI0YE5ncxN3/H77+5UzeepSX6WWiCyY/L
         io3A==
X-Forwarded-Encrypted: i=1; AHgh+Ro2PTCY3CQuherIJEUDCOsSIbwivRYO1tmCYmhi22Lna+LFL3YFTEBwC2w7WAl9/qFe1Vk7naljpA==@kvack.org
X-Gm-Message-State: AOJu0Yy3DzqndiE7NYn+FFZazimFfkue8Q8BXw4NdUD8YNxQX7usrT9v
	iACkhWKQVA5nJ7bB+yhlalmmwZryVZ89maod5alU/PPKz9UbSv58sLNm6WyhOHVupFfgRJW/Sz+
	BJmKybUA=
X-Gm-Gg: AR+sD13MqsLyFm4SXtCjmLKYGIV5KSIst7VK+Fa5+xZM0HkMl24MfglbckEAQRp+xOc
	IiZaXRRa2MFKE/TnPdIJz8kNnaAAGMc7ZCkdfl5Rp5ANfyljlODUbfxtBUuFJ+VfeJNZMWXpKWI
	UrK7VFSersImW2rvxgbMzlQpUW39z+d1XJ7CgFNiMYXmUxM0LXurH/JK/mKGVHTh37q7ccUOo7e
	coZlxVmmDv+AcNoQ7vt9f7c4Q5MUarDIShHJrTb1349Tt1qn+SxujOcPel8tSJXImWuWBYoeEna
	rHHtlRCza/K0ndIpN5rd+2VllCavz1MaEbK8IkU3JWcCQPs6zRWFs3mtiv53twLBAtPXfFYwxkv
	xUlurEowx3GzaBCfAAAO9PKyY9/oCeV19iDPFSu/oG9+1Xn16aerQPxcbIktkoYb1jYybQuapXC
	YbNzjM2C409vB/l43s/3Cpf++eORY95hrekPXxFtm7C1+Hiw==
X-Received: by 2002:a05:620a:2727:b0:92b:3203:ea70 with SMTP id af79cd13be357-936c0b68fa2mr178922485a.12.1786588630298;
        Wed, 12 Aug 2026 19:37:10 -0700 (PDT)
Received: from fedora ([2601:19e:8500:d3c0::28fe])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-936c199108csm48835385a.19.2026.08.12.19.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 19:37:09 -0700 (PDT)
Date: Wed, 12 Aug 2026 22:37:06 -0400
From: Gregory Price <gourry@gourry.net>
To: Rakie Kim <rakie.kim@sk.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, apopple@nvidia.com, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	dave@stgolabs.net, jic23@kernel.org, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, harry@kernel.org, kernel_team@skhynix.com,
	honggyu.kim@sk.com, yunjeong.mun@sk.com
Subject: Re: [PATCH 0/4] mm/mempolicy: introduce package-aware weighted
 interleave
Message-ID: <an0t0mP9JB8f4ILK@fedora>
References: <20260806080936.421-1-rakie.kim@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806080936.421-1-rakie.kim@sk.com>
X-Stat-Signature: 5aa1damzgrxwjdy9z5dyt7zi6p7gxi3w
X-Rspamd-Queue-Id: 2C91F80002
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786588631-944528
X-HE-Meta: U2FsdGVkX19AYTjYolbeVrk3CYmqDMzhMIuJ6MkuKSpiJxNxTuFdVO3FkgmRj5mk7s/S9wUo+5ZQCvAeDzmb3RFKhYThi+Cj6JH5JhegP4FmApTvR/3TyjnucGwBFYGQflF1PhUhjRSB7uAbsKWMyLswVd02zsmh3SSJ8CsM11oBhM0yYSlCCi6u4uxQ3nQ+U6o093VRkCo8sC9hfoyzPMQ9TrAUXoQl/ndav5Ohlfy5cH9xVr+6G7bFM6Xu9OSiOthzRrIj1heyKB0qOABZYSuDzNl+90ioQIPmA5ujz7qjecacBAwUnqTHq2gXbPuZgU+D+49enCEuHsrzqETtp+Tt2529QtnrsNH0nlmRag+RhFHyQfeMQn+BwXtYbEB9SXFJyIMVluRQbpa9X73DuIVh6iJvsHvOslaW+Drj+lYvPn0AcLZKn98cEFad/Er/O00DQiNg6PZdHjDasnkPyUg2GBY1lrw/TQ3ABoC8xpUplZw5PA4eS+hOtAmg9bPZoE45THA6ZDxlmm+n4CMnr+Mp0QONCeFSwwfIw3ple6scrMFFlipu/GI5oejvzUsLT3JjSIuZ3Nv1mtIJwEzrHpLVwT0C3toIq1PSmu3kD99fMxDyY8nmtM0qAvy8sqv6FpKmAZkaS/Vi6LKdKcbAxZzT+LnGdRm6OA1fhN/0/YvfquMFPC6OsgeFElhTmjtXzkFSeELzZCheQbIhCi8xm8IX42AgiEa6aRDQajMpN3hoe+McftWnQa+3HBZYKN91IT0QAwY0Tv1WApcbNYs7gg3ETNkKe8qd3qe6x8o92PmlVAxdPXVCy1B1tIDZw41ZRLZfTl0ZEDHbTDFpwArPpx24UcJIOFUH9TUBVXM82oHZORfKz3CVZN9HKGPZvIBRudKeCf8rynTTl9pJOmMTufBILiz6scjF/HoUH7WxDW25MmX7DVkgnD/6qXwfUrItjhtJ2QG67ED0Gnub8df
 YGRqQJf0
 d8EZQXVs92+c/rmZInDglMc9Nz0PCYEqGqWIs3pUh8uZMgJt+a5dbJpA8gD1u59DpHon73hLTi6zKjVMAabb8vI0De/ErRf1fnk4kgaJ9drZ1d7uffgF1xlLZ5OYP71Mmcvcmp9uoA128CfE5kq1aadrKB5nrktF4R0mRT1NUh6DyiwlpuSvzPog1aCW1ld68DvTsLuQBa/jo+RKRdSPg2pWcqMwbjeTXdUL3D5mIxKJWYxiiCru4suSG/UVSc7JBIAkUqmzwP0M94+m1DdTN+f1nCAB9MYcO1ez9agXe1KH0nH0cMma0BDI5bAxSVxQ0CGMmfmHK3X/8aKp1SrlWANR6rBLV5J9izQhG6lRMwoxMjb7XbuFy4NdevWIK4kw8s8W3EngWTAXG6h8W1Qi/Cl/5iA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 05:09:31PM +0900, Rakie Kim wrote:
> Package-aware weighted interleave places a task's weighted-interleave
> pages on the NUMA nodes of its local package, so that interleave traffic
> does not have to cross the interconnect to another package. This keeps
> each node's weight aligned with the bandwidth the task actually gets
> from it, so effective bandwidth holds up on a system that has more than
> one package. (A package is a CPU socket together with the memory
> attached to it.)
>

The only major question I have before I dig into the actual patches is
whether you actually need this on a *per-task* basis, rather than simply
a *per-process* basis - because that's all this really buys you.

You can already do what is described here by simply using a combination
of cpuset and mempolicy

cpuset.mems = 0,2
mempolicy = weighted interleave --all

If this is actually required on a per-task basis, then I agree this
concept is reasonable.  I just want to make we're grounded on a real
use case before we go adding this complexity.

~Gregory

