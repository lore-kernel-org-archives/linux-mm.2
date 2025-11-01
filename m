Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5EE8CCF9FE
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 00:02:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3354A8E00B7; Fri, 31 Oct 2025 20:02:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30CCB8E0068; Fri, 31 Oct 2025 20:02:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 249F58E00B7; Fri, 31 Oct 2025 20:02:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1602B8E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 20:02:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 91A7CC068F
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 00:02:12 +0000 (UTC)
X-FDA: 84060085704.17.8CFC09F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6F9F640013
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 00:02:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BzbymYIu;
	spf=pass (imf04.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761955330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ij0jvv+GYatlv1DjzftG3lFnT/We0/6ngz62fZ3BUeg=;
	b=5bixg7fgkl5rHLxzvMWF0vM6D6+wOvPTJuHTroDHAjMJNolQixqcyQDDEm891v/rKbktKG
	MosBkuMEQR7MLD9xfC3qbGtWTsmqdPrkwE/SLVVRc1Uu7DdptFEdPC3Lqzbm8ugwPYk5IM
	B24VDoDgnVvoJK9jEQMfmqp9xTx9Xec=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761955330; a=rsa-sha256;
	cv=none;
	b=HDZ2xtRuZPBGWSOh6xXkdWzqFtz3mJ3PwmadoWrWwVsucBHzmmOodN+rKdTqgx0hCPoAIs
	2BqgNYE5Rn9LWb5Lgm9g9sqkgWx/aLGGZy3S6FXYnVoPqGc9Hj0IVWtjYYQd9iDdZkjcpG
	WQpIGJ3BmNEsc+0auc+M0RkhEdvaMkI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BzbymYIu;
	spf=pass (imf04.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761955329;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ij0jvv+GYatlv1DjzftG3lFnT/We0/6ngz62fZ3BUeg=;
	b=BzbymYIufNqOqJ68fNTuhF6VdritfmDUOB1j3KbtGrlbPTlJTSB1R48yGJqT3JlzCVecMF
	JHpP8CZxAjb9LDDT/qaO2qljzZsNAIXalA528Zp8PUL+8QjrKwl8lE1PrbvzxS9g/ZDLKj
	Q6mFkDSrSbyYFkQUcPYumLN+lm7hlhI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-494-zZMhgMQ7MWW2pmpslNkOOg-1; Fri,
 31 Oct 2025 20:02:06 -0400
X-MC-Unique: zZMhgMQ7MWW2pmpslNkOOg-1
X-Mimecast-MFC-AGG-ID: zZMhgMQ7MWW2pmpslNkOOg_1761955324
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 35263195609E;
	Sat,  1 Nov 2025 00:02:04 +0000 (UTC)
Received: from localhost (unknown [10.72.112.3])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 052491800452;
	Sat,  1 Nov 2025 00:02:02 +0000 (UTC)
Date: Sat, 1 Nov 2025 08:01:57 +0800
From: Baoquan He <bhe@redhat.com>
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>
Subject: Re: [PATCH v2 1/5] mm, swap: Fix memory leak in setup_clusters()
 error path
Message-ID: <aQVN9WssAGUUPi7i@MiWiFi-R3L-srv>
References: <20251031065011.40863-1-youngjun.park@lge.com>
 <20251031065011.40863-2-youngjun.park@lge.com>
MIME-Version: 1.0
In-Reply-To: <20251031065011.40863-2-youngjun.park@lge.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8kEBxyI6iCNHMznbjjCPAyldZYIKdXhpT9hvWUCkrr0_1761955324
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam05
X-Stat-Signature: ze9kab6ifq1dmpe7szgwm8sj3f5966bm
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F9F640013
X-HE-Tag: 1761955330-805906
X-HE-Meta: U2FsdGVkX18BuRtK9JdneyzNBMlWR6VShFChO8TVhdpldimwnqofknysc8jFmGzk+KMbrr+4wg9allkT/vYENYwMkAErcNO0HBN01Mz97D5cvpRuzEfAYqZh7p7IawHABqT9euNupnx0a5VL9qlAgxP3p4pmzHHAYuqh29O98gqz9mRhQyj959Q1PjpBzwUX8ffoLes1jRLzuv4zOezuG6ToD03OCAvXQcJagNW4SNs91Ytvgdird8Gn9wQRzfvO1St1YdHpC9HRYfDJOjFE36HKmrufVrM15cVH4pw1HGkamnek8IQc9M0wcIe9p169wdcXraKBIEx3QJYwoLJ67ruJK2RqWCzR2MQuqSQ+VjthF+oVsK5fpRG3QRnbJSO5YTfGKxtsLTezS94ut+nvUDNsRjRYZGvIHoL2j40rCs9fVTEF934iXUXFC6YtpXvqgLSSRf0BSiXvTAcImUR+O3SEVeQH8Npqerd+IiyyKYAhDkXK4X/2B4SEtepWBr91oeoaMpQTjjQ2TOZwC26R5w06D50UjWnnPYlb0IUD/8+2bTZTMPuTexl3NxH9xT4XMnBooB2VhdwNrY70ysTc3XSp3aCG6PEnzadez643WMiHdBS2Ur+6i0x4HK4fUvg/6I2d9i6+IjLQchDtp6H5vYxkVnAHEWUwI1XUAWIeT5G86SVEXLGmhaIWe2p39qJCD2VkCgx5fRtznukkP19OGt+RMf73ZXfglg5H8AS3KktckeWDhGemGNapSbA0ZydFmsnzRMSuWm60X+y92AZan7l6nu+dGpJpbTAxmvyYKsQyPD/osHlb9TGoUThq6Zb+lDInUgBw9xdxkv9BHMgSOYmzYYY1f06iuG6WQoeuG1JDqCawyt9zpTL035iQtS+HfvCuLhGLtbDAaFdNSscEkLb11UJ/QQhZ00tPrq0kU44GhNuutp1lPe7x3tLyy/mTweZANkMIRpZwRhXAv0K
 Q8jmfs0L
 QrMcOD4FiZPqwnoCyIiNvJgPeEyOXL7Ql1ZCT1PUBZFff1fphqSpgEVAntceYchi6GbGazSP43u6l7A8QFpORNK+0qQ+wAmOgdvSniLvF0E8EH8aUo0wGW08F9SHlwavTR2jv2FIOzTso0sh0oyXIaZT7xH5WQ0mtuLBSQXJw1aF3NS9j9u993w1//o0WMcQ43Q9rsmmHpzt+BxRhYNfpaPDNlUw+vadrTDPLNSdxGug076MbOdUKp7fz25dlJf380LSB7R7+jOUYaLBeY4+Q2IMIs+83Dn3ATuGaiMRL/DMLR+aA/Dsblw4Ypu8MaETPWuOMBQFVIajXGzql3OQ3bAx7ah9Ihs4X7i+ZNEFWMcXzqqv+Ot8fy8nvbtELVLYyN7d5udgvclBr3E4C0qLUuIK30Ripx9u3Go28kjouOP60OdnvAtyNKyCYKfPcNwWk4Ba6Lnb3F5d5l0+UMqLrnjynGizYY8WqQ+DbPgFzyIdQGOpjnlToov9Uev2UUIxwObYlFGaUb6z2swISpIRU+YJNneV6OhzsRyK9IV4fcem5In11CTrCI1/7ig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/31/25 at 03:50pm, Youngjun Park wrote:
> The setup_clusters() function could leak 'cluster_info' memory if an
> error occurred on a path that did not jump to the 'err_free' label.
> 
> This patch simplifies the error handling by removing the goto label
> and instead calling free_cluster_info() on all error exit paths.
> 
> The new logic is safe, as free_cluster_info() already handles NULL
> pointer inputs.
> 
> Fixes: 07adc4cf1ecd ("mm, swap: implement dynamic allocation of swap table")
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> Reviewed-by: Kairui Song <kasong@tencent.com>
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index c35bb8593f50..ed2c8e4edb71 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c

LGTM,

Reviewed-by: Baoquan He <bhe@redhat.com>

> @@ -3324,7 +3324,7 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
>  		si->global_cluster = kmalloc(sizeof(*si->global_cluster),
>  				     GFP_KERNEL);
>  		if (!si->global_cluster)
> -			goto err_free;
> +			goto err;
>  		for (i = 0; i < SWAP_NR_ORDERS; i++)
>  			si->global_cluster->next[i] = SWAP_ENTRY_INVALID;
>  		spin_lock_init(&si->global_cluster_lock);
> @@ -3377,9 +3377,8 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
>  	}
>  
>  	return cluster_info;
> -err_free:
> -	free_cluster_info(cluster_info, maxpages);
>  err:
> +	free_cluster_info(cluster_info, maxpages);
>  	return ERR_PTR(err);
>  }
>  
> -- 
> 2.34.1
> 


