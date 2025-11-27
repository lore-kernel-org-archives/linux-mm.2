Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A941DCFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 10:48:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2F386B0012; Thu, 27 Nov 2025 05:48:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDF926B0026; Thu, 27 Nov 2025 05:48:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF50F6B0027; Thu, 27 Nov 2025 05:48:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CEBED6B0012
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:48:44 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6AF088A4A8
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:48:44 +0000 (UTC)
X-FDA: 84156063768.01.D0FA5D3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 225D740006
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:48:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TJyuUhl4;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764240522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=shoZ23Wxd9NZSdlZkREnKRZvM7amjIk2F0ZU45OOzq0=;
	b=I+M+0S5N2bdqBiBmKJOrQA3Ce97J+o/8D95utsV8jQBNtelf+T4vjL7quvdaRrx8P3nsx6
	kjBgVvPh+qPP0i71R/dBX1Awb1GANLMflUCHIAKqNPW2HJRwOsYw4xoqO/S8q5uT2ODHY6
	Txz997kcH8VzDM1q0RI1bNBqlogBgos=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TJyuUhl4;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764240522; a=rsa-sha256;
	cv=none;
	b=r7rXM/elcRBAlpeQDsymwu4jR2J6p0LYQ4mqe3vp+SUl0QZaD83PRoLHYc3KZw4tHOr37G
	pdq0iliz1JbzUppvyl2z0uCGttLg/FM5kXqyHkfNrTGDZfB87HbbV1FtQZ6BC31aHCSSsy
	BJICPwVaJfJr/vrHCR6CI4Mts7DQn5w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764240519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=shoZ23Wxd9NZSdlZkREnKRZvM7amjIk2F0ZU45OOzq0=;
	b=TJyuUhl4MzSZl3Tj7Ik0AX52BIGmUtWgGcsxKntyYDy68bpFHHe2V2X1w874fN9JHrtbwQ
	GncZLC1/1RztsR8qpWiY++J+G6WWBJc1bVXnSHlzU6x8tIjacgXPbW8QAASZD2IWzAqk9G
	UvDQJUOgaaWiGrO0JIcQA0QyGrH8HHE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-363-5AiSjQbEOhiA10wojh9Pcg-1; Thu,
 27 Nov 2025 05:48:38 -0500
X-MC-Unique: 5AiSjQbEOhiA10wojh9Pcg-1
X-Mimecast-MFC-AGG-ID: 5AiSjQbEOhiA10wojh9Pcg_1764240517
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2D2B7180045C;
	Thu, 27 Nov 2025 10:48:36 +0000 (UTC)
Received: from localhost (unknown [10.72.112.107])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6B9AA195608E;
	Thu, 27 Nov 2025 10:48:33 +0000 (UTC)
Date: Thu, 27 Nov 2025 18:48:29 +0800
From: Baoquan He <bhe@redhat.com>
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baohua@kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 1/2] mm/swapfile: fix list iteration when next node is
 removed during discard
Message-ID: <aSgsfUize1LxowEN@MiWiFi-R3L-srv>
References: <20251127100303.783198-1-youngjun.park@lge.com>
 <20251127100303.783198-2-youngjun.park@lge.com>
MIME-Version: 1.0
In-Reply-To: <20251127100303.783198-2-youngjun.park@lge.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sUfnAnGov96tSZT3m0-vhwHNQV3eCqzV2c_dt17hcNI_1764240517
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 225D740006
X-Rspamd-Server: rspam11
X-Stat-Signature: aq1aywiyt16g7jga9ac1bm98h33wjbnu
X-HE-Tag: 1764240521-148031
X-HE-Meta: U2FsdGVkX19OGElpLGFqyIPaIplYvf38I1KPfM5ZlR82isDWjRw9Qjmz4bb7udBRhZvgxeHKfSegLdQTJs7hYKZNGdfv5bAtd3eTNEWwId62TbTMpL2QWNW6xgNrVdUwOW6sZhDF4u+EQ0Mjys9eygVzuw8Fq5IXC1LUdkyr37GICJRI8GJBNh7FtNYjfnr+BVXTcKYAqOXnPJVfNZSygcNzuz0Rb7KWGa0BCU51jEvQ/irywsTOV+ao848OZ6x5NXQSVmHxbKeI9OPcL/e+drXf364nUh2d2Tzf+4A6jzwlpaiIyTPzneE4bkWARHeAr+iB3OX2Jqnq/SUu/+rFpRjHGRsBtyow71wB6+RdtVtT2bs0DuDLOkqnf4kgpN6fs9OENwHNCKbeWHas0q37AUVp9EOIqgJc6t38d89UWdgSIDJBGzq5AjmIsiIhfqKYUc2b/1+zw4NNlIdj4duhbECCQsallOdibFoR0HNBepFYjRYifJL6ynXqti/kwXj0IDgCEAgIL+bnCgUExqxCO7aHBCof8Gbhc5ndmXEOq9iwVK7wQx1h/NnFbg2XUpJtiywCRENKIy6bRtKA3PuIZ+m2cP0paDEdlJqYQyhKyr07jrOBeJnlr3wGzdY82OrBYOmyesHBXhBW/Z3KMoqhbyGWNbNTOReUbBV2BVKqvwojZmuw1wG1h/QuV3bW+VMnH8/Grz5qF4T0qgLAwUDHmpA+PaYNt4iUGKLEs2G/YqZz4twOLNSggdouG0KJ+lt2ClOHx4yhkVjQRCSyNB2gaXxJKH8uqnf6LTmhHJ/+1uKUo+dNo0wGpKm4aX737XDQhYbmpcBk+CRBYq0lN+sGzhAoR6juBN2u8J2SJnikLwYdhg0z6toXHcuY8uR5vWMmzzd5Zum9BW3Ve8k9REquMDlBGDdIOqVq7CF53Wk8Hd/Wx61jzbf8RttIutHb3jzr9NjB24/rrtsOtT6OPEb
 GtI3qwjE
 jQdXD4s4yYbgHVWzyPYsjgw/w6ae7oHTzJhFW1XGcURjFl+j5MUuuFC9KGnRYHLjNpq551TMD+B8GfCJU0f0i32Nrqw/G2l2cw5AtvpklpenwodVBsFQliN3f+wzXtoi1pUZiH8C28R9GnXmP3AYfwYkzzjPG7PP5xz7HLkyGlbNfE7cungT+yaFEZ2PZi9UCHY1uz/3G8Ks8Lr7ywo+qZnGEqkK9qI874ORVNc9pIe46p58NrtWrsZGkMw7juAAENllYhH1I/UasUBMP6uw5eHI+bOiax2w49oNrr8QTLF85nMhPT7y+LLV/D6aE9+EL3hDev3ZC1oIEEMlGY1PDyrKVixwgpJq+gB/ysJq+Mm8ejJ/WnkSNQS3uL438QVljXOOmj+dE3BYF19a/VQoVNV9QlTJxPeoQRgaPvVsjv/diCJ273NI5JNwvV+oU9I9oGgzIxEQbvnxwnyNzxSVUarE2I3CJZtzZ+0DEz6I62qOmK+rYoe3uIxhyhByALR2U4wN4nTRiyTnjJH8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/27/25 at 07:03pm, Youngjun Park wrote:
> When the next node is removed from the plist (e.g. by swapoff),
> plist_del() makes the node point to itself, causing the iteration to
> loop on the same entry indefinitely.
> 
> Add a plist_node_empty() check to detect this case and restart
> iteration, allowing swap_sync_discard() to continue processing
> remaining swap devices that still have pending discard entries.
> 
> Additionally, switch from swap_avail_lock/swap_avail_head to
> swap_lock/swap_active_head so that iteration is only affected by
> swapoff operations rather than frequent availability changes,
> reducing exceptional condition checks and lock contention.
> 
> Fixes: 686ea517f471 ("mm, swap: do not perform synchronous discard during allocation")
> Suggested-by: Kairui Song <kasong@tencent.com>
> Acked-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  mm/swapfile.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)

Reviewed-by: Baoquan He <bhe@redhat.com>

> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index d12332423a06..8116f36e440b 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1387,9 +1387,10 @@ static bool swap_sync_discard(void)
>  	bool ret = false;
>  	struct swap_info_struct *si, *next;
>  
> -	spin_lock(&swap_avail_lock);
> -	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
> -		spin_unlock(&swap_avail_lock);
> +	spin_lock(&swap_lock);
> +start_over:
> +	plist_for_each_entry_safe(si, next, &swap_active_head, list) {
> +		spin_unlock(&swap_lock);
>  		if (get_swap_device_info(si)) {
>  			if (si->flags & SWP_PAGE_DISCARD)
>  				ret = swap_do_scheduled_discard(si);
> @@ -1397,9 +1398,12 @@ static bool swap_sync_discard(void)
>  		}
>  		if (ret)
>  			return true;
> -		spin_lock(&swap_avail_lock);
> +
> +		spin_lock(&swap_lock);
> +		if (plist_node_empty(&next->list))
> +			goto start_over;
>  	}
> -	spin_unlock(&swap_avail_lock);
> +	spin_unlock(&swap_lock);
>  
>  	return false;
>  }
> -- 
> 2.34.1
> 


