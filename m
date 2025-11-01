Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91984CCF9FE
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 00:03:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED18E8E00EB; Fri, 31 Oct 2025 20:03:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E81798E0068; Fri, 31 Oct 2025 20:03:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D706B8E00EB; Fri, 31 Oct 2025 20:03:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C15668E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 20:03:23 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8532588D15
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 00:03:23 +0000 (UTC)
X-FDA: 84060088686.24.BF3506C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 68A8EA000C
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 00:03:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MKnPWi4t;
	spf=pass (imf15.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761955401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nJhoM7LMaT631kLjGdMn+Bh54QFLW/iuLBM6xWFjdYA=;
	b=z0TjyzhajBvbVb6hIGf8JyTOssxEq86HHSms6AvIVJlK6CkyvV3CsSwv90wAavP+MCnMya
	6vkeKabGPAM13jdvcdcK281+NzqrP5vHTh3aSsh3SHNd/oY2dJlvyadfkS33SJzAOTkuYF
	T8gEKai5vN7G+64zgYY2nse+hi/l1x8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MKnPWi4t;
	spf=pass (imf15.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761955401; a=rsa-sha256;
	cv=none;
	b=FN/yzrkcj5ghd8Q5wkkF1tn49IK9wBbJGQsE27zImIZfW0dG+d1cM4qHwtQB6ew2/3jyvR
	qZRpwznQ8kiHxZoW50eHLV0+qlnPj1hvKALN4YesWPy6H3ct42/hZem31mkk/cdU0xd9sO
	G2Z/PKZ32JYOxlps6e/Sr8Fnnsi8Dr8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761955400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nJhoM7LMaT631kLjGdMn+Bh54QFLW/iuLBM6xWFjdYA=;
	b=MKnPWi4toxoHP+8zsWdsmfT1qeQjZZcF7wXDPeGuGb0RYd+7b/uz0XBpkY3wEnwKd3fDnl
	C8xOeQmA2CJqzDIrELEJPjgXMKh8KxI7z8Zkhm0B1BFdW1Vaw900AEE2QCWeEg+DdZYqgx
	faX0YotFV1WBfiI3SY+9PeYKGVFronI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-37-Huur_y-hP_CGIELFrK_39Q-1; Fri,
 31 Oct 2025 20:03:17 -0400
X-MC-Unique: Huur_y-hP_CGIELFrK_39Q-1
X-Mimecast-MFC-AGG-ID: Huur_y-hP_CGIELFrK_39Q_1761955395
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4E4CC19560AA;
	Sat,  1 Nov 2025 00:03:15 +0000 (UTC)
Received: from localhost (unknown [10.72.112.3])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C404018004D8;
	Sat,  1 Nov 2025 00:03:13 +0000 (UTC)
Date: Sat, 1 Nov 2025 08:03:08 +0800
From: Baoquan He <bhe@redhat.com>
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>
Subject: Re: [PATCH v2 4/5] mm: swap: change swap_alloc_slow() to void
Message-ID: <aQVOPHtwKlEM+uBM@MiWiFi-R3L-srv>
References: <20251031065011.40863-1-youngjun.park@lge.com>
 <20251031065011.40863-5-youngjun.park@lge.com>
MIME-Version: 1.0
In-Reply-To: <20251031065011.40863-5-youngjun.park@lge.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: a_zKpV5Gl3Frsy2zNwvwnljT6L14g7b12fjPL8GeKAM_1761955395
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: he1gc71c671551ab33kgzxcmbc7kdntc
X-Rspamd-Queue-Id: 68A8EA000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761955401-616395
X-HE-Meta: U2FsdGVkX19zx25M4KoYDpeupEhA8qWd2qhH08KTCWwic5+rUfUb9zWSAvIG3Ebb1FzAO4wSWeCQHqHFNJlVYNK8MilNFO9E9qXmsYby4u0X0JoXkt14FagfdlGILJG5axFnIl6eBrAXVlRGjtzu6uKrcA5seJY909BFRY5W/K3YjpPrW10xBWmIRQNd+Pr4VFq20/bO828QRiBkJ0G69yp4yU+9p6e+S1Doa+MbGhTsvRemWD/V4nBRNpJNhyGMwQq7jE105BobgU8RPGrQaJkOdKKnNvtGUIRFvPLayh5HyqL3WpnOrXFzzyKkrrEmmNyJ+3Cmz8vxhIbxdR67Z9s0K8bg/+vpqg7VqevaXURaCx1oWHey/nJd7h4OnIPM2F4l5F5FFDO3HuQaDdMfYJ19zd2ifoNzypovgYaXpTt2grfYm8xygcQ9I3SekIjmsYvYtd1tK5s6UW8z1Of5ER6+XmmpCKnhVklGV6vQIFtncSL89m4B3UpjubnHjhaQfGbXP3o6KvCb5kokppWIDd9Jbbx4b+Waiezy9GjR7CHa02CWF50VuELZ0mZAvg0/Y7SKMKU9OItI51uk2BQ8WJWv66GaRUpMW3NsEAezINalRwXBl/9JAbALhvevp0zYkMu8HX+NBMKmSHtF6GJv1g7AvewMXGIn4qIPrKl69RlPfzz7XwwL6AwFz1+Nrh1BdRqZBvt6u8gnRoXpV9MRrM3iNcgwUgSBFUKqknwreIML99h+BDanzfn0+U4O8SGPqkItUtyFCg5soU4QIjMIswsng9ifPGRND1PfJJ+bTzLXBlclpnWsKhEJrPOiNAxYC4eyHHXlilfXUole9rttXmae/93nIDPzjWMBnNSLWIzwmNQ8QgqbWz2/n3AprWud/KIHZU1/PDGhSmCkKEnsqpN8H9jK4/pIF1Lbq2FvsZ0wx5G/daumFeT+BwgSLiDRAYxy2KPypb0vrPArmeN
 2oCTvxSM
 q8UkP6FJyilj4jEg+D4/dNdCVxPVQQCpWAWdm/RmzRF7xjgb7YDi05TOMzx9xg/xtWzZSeyMqtZkkqGcw0OIQqGYbUQjQMJ46//yVxJo9arCaf+BjWfAgYVZXqF4M0XYN+/DqPOaMd3mviCqlAiCgVJZ/89Pv0lchohPLHEy/xn9TAVue8U2q3AX2AZoAeKRFfmZbbRvQRqksZINVj5/rlfwxbhryOPt81sOH7DVwUbLN7FDGbzHI0XUnLNxey+OTFrRK0GCFX86ucImlFMvsoXR0usBjKAkpvSfwpztP4cPCz1L8VGU/fHMVQnvXhX5siMeUdIeb3T60bH7BVJ8nRzDvH1zQINX3FnfcUquz1lcnudqclYCv5fb1HOU9oEtvV0GZWk86bcf7ILWKb6ve86HF9NyPFBA9dq6H+NwUfIC9kw0l3NtpbErKB8YmPL8rc9uRZc9AVJ5DfqawcmDnTBjeZqtvz9suGgGTikkVfGCqLo793Klwl2NtA2gbUDU9kW3kTIp1Uegx2iyAMeP76Q0tubOSARJSwUT4ljmEjZw5y/HC6EMURtVqNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/31/25 at 03:50pm, Youngjun Park wrote:
> swap_alloc_slow() does not need to return a bool, as all callers
> handle allocation results via the entry parameter. Update the
> function signature and remove return statements accordingly.
> 
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> Reviewed-by: Kairui Song <kasong@tencent.com>
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index b7cde8ef6742..4f8a1843262e 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1339,7 +1339,7 @@ static bool swap_alloc_fast(swp_entry_t *entry,

Reviewed-by: Baoquan He <bhe@redhat.com>

>  }
>  
>  /* Rotate the device and switch to a new cluster */
> -static bool swap_alloc_slow(swp_entry_t *entry,
> +static void swap_alloc_slow(swp_entry_t *entry,
>  			    int order)
>  {
>  	unsigned long offset;
> @@ -1356,10 +1356,10 @@ static bool swap_alloc_slow(swp_entry_t *entry,
>  			put_swap_device(si);
>  			if (offset) {
>  				*entry = swp_entry(si->type, offset);
> -				return true;
> +				return;
>  			}
>  			if (order)
> -				return false;
> +				return;
>  		}
>  
>  		spin_lock(&swap_avail_lock);
> @@ -1378,7 +1378,6 @@ static bool swap_alloc_slow(swp_entry_t *entry,
>  			goto start_over;
>  	}
>  	spin_unlock(&swap_avail_lock);
> -	return false;
>  }
>  
>  /*
> -- 
> 2.34.1
> 


