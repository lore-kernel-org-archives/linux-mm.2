Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99508CAC59F
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 02:57:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF7B38E00A0; Wed, 17 Sep 2025 22:57:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA7738E006B; Wed, 17 Sep 2025 22:57:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C96838E00A0; Wed, 17 Sep 2025 22:57:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B7BCE8E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 22:57:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5ADAD160795
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 02:57:34 +0000 (UTC)
X-FDA: 83900860428.07.CFD282D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8D634140007
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 02:57:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NMP0Q4TF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758164252; a=rsa-sha256;
	cv=none;
	b=IfX1YlMwiFgbsfTe0Azoo+ERmFnPXmhz0qVaPwMm609PBGibVo3Gq73/CjyUslO8dkV3d0
	SJw4rOooHxPD51m2lqII7icJOZRLvatljcXPKE8w4m0CQ7cHvh7V0sUfITCiOYbdsbZqE0
	MTNIVq9TMyAqfm2XmvIdh8W326A3Dy0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NMP0Q4TF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758164252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Q759OacMcRF/860MmGQo6bLHEi1R2UR4+GXvy2W91Y=;
	b=IBWnuNgSM2ECMAt8VpJhCs3HERvNr8GoCzo4EHNrSuaxB+agmrnx68FBm53mhUdmsUxAMc
	Li5s1ghHHUQQXkPR3k2lYPSFqzXTwisBxkiEAoPvGkrWViaQD8orKMpLxW2EpvAOQ1Cenf
	lsG/xSw3fwe0OYyWbL++Is0FzLqfz/c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758164252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5Q759OacMcRF/860MmGQo6bLHEi1R2UR4+GXvy2W91Y=;
	b=NMP0Q4TF1GPgpICxINHOi8g3mf9WjQ2CcmHiccLhlv0vBQZXb04Kizn22PYrFN3mMAYWl1
	AS3AVORJ8rh5fROhuMwGzIKzzpIQJT9OhMtQz1QtjeLqhGfaRMftjuOL9xJWgrGHLOseUK
	7/Q710P3gnBFY97FhUZue/fVzOVLDxs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-491-ya0XvetYMf-oj4j9ylFM-Q-1; Wed,
 17 Sep 2025 22:57:28 -0400
X-MC-Unique: ya0XvetYMf-oj4j9ylFM-Q-1
X-Mimecast-MFC-AGG-ID: ya0XvetYMf-oj4j9ylFM-Q_1758164247
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1AB4F180045C;
	Thu, 18 Sep 2025 02:57:27 +0000 (UTC)
Received: from localhost (unknown [10.72.112.180])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F38A119560B1;
	Thu, 18 Sep 2025 02:57:25 +0000 (UTC)
Date: Thu, 18 Sep 2025 10:57:22 +0800
From: Baoquan He <bhe@redhat.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 04/10] mm/vmalloc: Avoid cond_resched() when blocking
 is not permitted
Message-ID: <aMt1Eo9G8uS2UNwX@MiWiFi-R3L-srv>
References: <20250915134041.151462-1-urezki@gmail.com>
 <20250915134041.151462-5-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915134041.151462-5-urezki@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8D634140007
X-Stat-Signature: 1jdjyr993zkm4by4wfembx6szixmqsti
X-Rspam-User: 
X-HE-Tag: 1758164252-759561
X-HE-Meta: U2FsdGVkX18JFB+Q/EvfR/iLhA8NvU7JI7tubDn6gFvLQ/d6Saf+iOUl/3bXFHuqHpQXLYPDffNMSSqouGiu/LvYAC+VQj14s5whrKQRwb2X4ybbU2KApCDLu/igOolcaBRF83+yewEVUtrBGh7YTOukS+UKQOPa0q/mPcQATX+zcVlfuXjb3m1A3ywQsnHh+E9LhnUSU9gq7wK3cv5eg3tyX8bka4utstHo9sORp8Gvy/BsozUtZpZ3mjP6z2NVxFWVqAS2EX5p0UgQKY+HiOISR38gUWEnPi58UgYjCQwd4LISBRFIKHCBF4V/hhb5aJ+wL8ybFm7WuDAFhykLcYx8mJ3xmPxdDbJjkRGfANTdFxRp4cp8wO2bD032Nc3hZAO8FE9j3EuY/knuUtHkjvfXJTxzV8irGe4WqEFodtzxra71xOFb9xMSaQizV9BTp+M8UzkZbhdGDkqI6H06z4RReA2HWH3vAJvVEw8SrZGl+6UQ1vH5t8HZi81fNunb9OOhRfHtRe8/IjMZYCZaXdXEW5/uV8x1PPv/yy+l30Zj4hWzhsHP16SpDINwLB7zj7405nTpztlRViyV8j7o10gfEII6s6O8HEhA+uucl/l9LoR6SoTgKKsVAnxnNrDODZ8vAUD2/GTxi+bS3mVUrXnX+L2TM1rA9V6NNKy3jycZHnOTHIiAJha+85fNACG1vRRDYL4uSQauHrUFYXrmPJQdRqr9+eKMDhdQti5m2ih6RCUcuC1wyMa20n5FrZwyVT5ddTbj3e29TgYP+9GXb/5g7NPIR+H1rGEz20nLX8zn5YPWk7SI3+LizurxtK8kvtGk9jC9V7OwaqidB2j544Joc1GKtVhK0f/ulV7iuq9y58Uy9HPgU1VHfvYClNS1fxYjGckmmatAcjbfsNA0tck4soOEZawwgqYcqx1EvALPGrKTur31GyLAcGCz/vrYoLRTaWYIfcOj8dchiez
 rf8x6b7R
 DtCRztJB4oBBFHymNbd22YKuorYgyI/AN9D+JNXmvU4/c74GpuCMz3X3M+azMmHpMb0lgSWxn8VjBhSUunKZpYhIqE4TUBmD4LkayK6AAgTT8GygBkpZRRNvcHMcR59mwtARErqjelVcyW07lWMfv/pgCTm9MuisE/2vifrwedpIMasdfQGlI5P9mn9J8SGLBYJnSwxkJKS1uWpd6IaN1k8dT5kbem9Wu4a3IA9cMnFaUFBrsAJG8iroo//if2p9xhK++NhYxqL2DEvCDrndD6VwgrCvZtPqo70jJfEE5gwVK5TASmA2kK2jMnqesFRU0zDMte9y+qmoUTB2yiA6fLq3G5xW9HbqB4A5pDZxDVIGZu5Ld4FX/H3QCsUdb0nX8Gz6rprUNhrSzpjmAVefR2gHeOqTQ2nG79tYrPxGwG65S0mCSUEh1Esqddj9QpVqdrkxayqarr+gt9NlNViyt2Tq7nZqpTyhyg+43lAbV097Z1EoaSDDuWRa3Mg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/15/25 at 03:40pm, Uladzislau Rezki (Sony) wrote:
> vm_area_alloc_pages() contains the only voluntary reschedule points
> along vmalloc() allocation path. They are needed to ensure forward
> progress on PREEMPT_NONE kernels under contention for vmap metadata
> (e.g. alloc_vmap_area()).
> 
> However, yielding should only be done if the given GFP flags allow
> blocking. This patch avoids calling cond_resched() when allocation
> context is non-blocking(GFP_ATOMIC, GFP_NOWAIT).
> 
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
>  mm/vmalloc.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

Reviewed-by: Baoquan He <bhe@redhat.com>

> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 49a0f81930a8..b77e8be75f10 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3633,7 +3633,9 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  							pages + nr_allocated);
>  
>  			nr_allocated += nr;
> -			cond_resched();
> +
> +			if (gfpflags_allow_blocking(gfp))
> +				cond_resched();
>  
>  			/*
>  			 * If zero or pages were obtained partly,
> @@ -3675,7 +3677,9 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  		for (i = 0; i < (1U << order); i++)
>  			pages[nr_allocated + i] = page + i;
>  
> -		cond_resched();
> +		if (gfpflags_allow_blocking(gfp))
> +			cond_resched();
> +
>  		nr_allocated += 1U << order;
>  	}
>  
> -- 
> 2.47.3
> 


