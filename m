Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D929CCAC5B0
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 03:53:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BF078E0005; Fri,  3 Oct 2025 23:53:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 070038E0002; Fri,  3 Oct 2025 23:53:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEEEA8E0005; Fri,  3 Oct 2025 23:53:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DD71B8E0002
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 23:53:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7256D1409FF
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 03:53:34 +0000 (UTC)
X-FDA: 83959062348.27.8B87A2D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id BB2B18000D
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 03:53:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WOmscnRu;
	spf=pass (imf02.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759550009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RkIIvUaLniZLbjXm3aa4rhHDrqBDy6A0FmYdyH6k/vQ=;
	b=A79bQgjKd5Gq1pj8XFBVbrqe2v/IJOMLYj1QPIi9sqaomFckMVozk/NFt8QkwiCWuUNzrt
	MBmNZFL9XydS4Q+ZvBw2URtxwR3t963iTk3nh6TYa+5phcemGrL/8crW+6qIjTnfJnTGcy
	yz/zLSw85uiuJ9k0MHC+ynQjC46X9Hg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759550009; a=rsa-sha256;
	cv=none;
	b=p6g2gh8zza13hxdY/iGaMDV2F8fGCUO4qmZa6G+tp5gqs/Zz27eYiGvqJPBuPo7cJM4Y08
	9Z5mBJwvT0PBQ/cK63QR8PF8PhFs8J4DEruvn+btmIZh6Xy676d7rlLM3gON3B4xS0TnZC
	382T37gSm5L8O7HVSOhQlSbL9pYgi6g=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WOmscnRu;
	spf=pass (imf02.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759550007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RkIIvUaLniZLbjXm3aa4rhHDrqBDy6A0FmYdyH6k/vQ=;
	b=WOmscnRuQcSTj3DQbEUTSYXc54Y9Awu82AMAOcsGHuJFNtMxfi7NQ3OxQcz0FlSkI6mPuy
	881zbBQbhfya88uQRcCFDd5bkuoFBBUzpBw09iDqDFdo6CZTRkHAkBwCxyUuClRIdp3HFm
	yinc6aWwZlLYGPYgbrwxckCCsNWqeDo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-681-QF8grObeOseX5QEeRE4MtA-1; Fri,
 03 Oct 2025 23:53:23 -0400
X-MC-Unique: QF8grObeOseX5QEeRE4MtA-1
X-Mimecast-MFC-AGG-ID: QF8grObeOseX5QEeRE4MtA_1759550002
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1FBAC1800451;
	Sat,  4 Oct 2025 03:53:22 +0000 (UTC)
Received: from localhost (unknown [10.72.112.27])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8772819560B1;
	Sat,  4 Oct 2025 03:53:20 +0000 (UTC)
Date: Sat, 4 Oct 2025 11:53:16 +0800
From: Baoquan He <bhe@redhat.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v3 08/10] mm: Skip might_alloc() warnings when
 PF_MEMALLOC is set
Message-ID: <aOCaLNKZcC37w7ok@MiWiFi-R3L-srv>
References: <20251001192647.195204-1-urezki@gmail.com>
 <20251001192647.195204-9-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251001192647.195204-9-urezki@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: BB2B18000D
X-Stat-Signature: n7dw6zm1izno1t196bxgwibtq8sxwbq9
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759550007-271548
X-HE-Meta: U2FsdGVkX1/cPfpyp5nxSlCIhtXNV/RFiG0zxL+EQxFQ9Z1P6e0fF/SrAHaI3szAya1x/tKeMhjSwBOUvfKMMblR5J1Wsb7+maC6vIqdPkW2B0g68Hi2pKEYcvDJrsPeH4deJtdW9D/xw7ytUh8BNaS8TTkQFqXPCJDUtoalitB35an+zxcSC0M8Tg4vHvEf+ht138YmZXQE09VDeI0CAV8E8rdrRVH0P39Z/suNnEhsw/VMZtq0XoXD6Cud8XkshEAaF9dAN+5oKT0bTBv5LO48CbhMPhHZMxiJnS7tcia2aaUEf3XDpgoFECnGVPPTd906yiirOWXAepSLDIAtbkraGSt72MdlgncHZVI6yU3NTGPW4rVPT9A0bX7YMj6+a38qdtoVKBDqvHvNPs8itZjYGspHfoYtHSn5U3yPrqJLenisFUuudfFDw+t+C8wqUjrAf4MFmm0xibzY8PAGYKBh9Uzk3+Wba5GZJyZa+vTWTuAe53On9yL/D/K9tuU/8jmH79duuYZLCBfOJsX7vEj+6LUv3tK72S381Ts0qptt+RjW8DP+CvJXywsXqtfWFgcspFDxEBQMRj2AvHkJMlcTHI2a4xUh5MUFflpmFXttE/kUWVUHLPAqztXtBdKB2n3KHcvc4Hx920vs07fTi1r16vkCdz937kFuzceG1EuZV6G5QClxbx5DJ4w8ihx/S9OJRvnqkD0MGr6UO/bzezCaDpIcml6TsnjolFvy9OBt6THcDU4SIP7qMRZcGG9OWR4sLfK4u3DWn/6Pt3yamJjM3+R40Wmrg3wCodq6iGtA6u9MuxIetC1sKLClQ+535sDQgOM1IrBhlnKy/iuIptiEhsB+9sAY11djtZW5I0WkHkzx2Xjh2UQpvPECQxgzD/czZSJn0k0xrlzjgtYEPjnBPqtdwDPpHEAkrHsdnZLfuCyLsiapmThn3ZioblEpvOe/Y+aZpchBz+8iMfU
 Yg0SeyHq
 bJ39eGyBGpPDqFqcvtHeqM1wHazLoS/6kbMA7oZZhb8sHVmDRAUVkAvHkBj1nCFawz/NpHJFQV9U0VUkvAGfu3fLPOmbHe3wVC+KizXdDqPAE3SqWVo8G1THHqhlHZgzFjU0I6NINX2n2LYzsnDK2qvnQ51t/uf0zU0GNrZ1C8jOBgmXNHy4JsvrHY4Le4pkK7EPXpNSPYpgEtnWKv/KuAU83ZwJLuqcOxcE9SbD15Y7EgXP8n/paKoD9xzdNoY0S44FLSVydNT3xEp2e23Ng8gqnIi2leOvHTMDaTt+fiQuaG0IXycHZFOvL6/Xb7grlUeKT2ee84wUfhoGNuo4Hu0lpZiAWKbtAJaArVlA/NKNw2Z2xfYFhrdzX5az0V445+alDzuJPBtQLs3JNclAI4VB1TE3n4JlC556E4kWnH53txAFCvO0iXNfkWTSUWeLJ10E+7Ev2EFeBM92v0Lq6Fcoww0GWiSUom8euElHb8EnWUNxAfE9XKpizyiyG617kpRCEPSnh6b3eGhgZB6Pc0VkJJ6Ic/7Obx5lSU4YIMzTigE4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/01/25 at 09:26pm, Uladzislau Rezki (Sony) wrote:
> might_alloc() catches invalid blocking allocations in contexts
> where sleeping is not allowed.
> 
> However when PF_MEMALLOC is set, the page allocator already skips
> reclaim and other blocking paths. In such cases, a blocking gfp_mask
> does not actually lead to blocking, so triggering might_alloc() splats
> is misleading.
> 
> Adjust might_alloc() to skip warnings when the current task has
> PF_MEMALLOC set, matching the allocator's actual blocking behaviour.
> 
> Acked-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
>  include/linux/sched/mm.h | 3 +++
>  1 file changed, 3 insertions(+)

Reviewed-by: Baoquan He <bhe@redhat.com>

> 
> diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> index 0232d983b715..a74582aed747 100644
> --- a/include/linux/sched/mm.h
> +++ b/include/linux/sched/mm.h
> @@ -318,6 +318,9 @@ static inline void might_alloc(gfp_t gfp_mask)
>  	fs_reclaim_acquire(gfp_mask);
>  	fs_reclaim_release(gfp_mask);
>  
> +	if (current->flags & PF_MEMALLOC)
> +		return;
> +
>  	might_sleep_if(gfpflags_allow_blocking(gfp_mask));
>  }
>  
> -- 
> 2.47.3
> 


