Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DF78D116E6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 02:16:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F5956B000D; Wed, 26 Nov 2025 21:16:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A6946B000E; Wed, 26 Nov 2025 21:16:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BC346B0010; Wed, 26 Nov 2025 21:16:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 36A076B000D
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:16:06 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A0F038A4AF
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 02:16:05 +0000 (UTC)
X-FDA: 84154771890.22.3D5528D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id BF034C000E
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 02:16:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Iudvg3h4;
	spf=pass (imf10.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764209764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3oNh+9ISvhyvMmEFVM8tJ6FqTCjyDpEVR3GmRuPb+X0=;
	b=xlumA3uemNKF6ZKKJA8Udfjm3Kt911mxGyu8UuGp9Rs/JUcOhm7jOIgyhO2kan7m4gknOS
	/P2K+8+ZblBlIVqNgRAnbEJKnrkliUpoef1158Ybd1/GHxw6pX41HRmKpHQlTtnDHR0orC
	BqabSf+J2dSxgFoxz289veXh5FoIFUI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764209764; a=rsa-sha256;
	cv=none;
	b=BN4RNpCCmyumYKff/y2SdgLc7ODcz9fH/tcgLHsSiE3GmCHPsWoHqLXx56JK2K3YLCBmNa
	ztyI5VymvLS6mY9bw3avgNN5FtW8jfVaSNo4xLy2bywvOu9OxO8B1RzvqFa+qmSCDLOLHH
	HHTFhUeSIoxGwMvjzndv4CIsZYg0+cc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Iudvg3h4;
	spf=pass (imf10.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764209763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3oNh+9ISvhyvMmEFVM8tJ6FqTCjyDpEVR3GmRuPb+X0=;
	b=Iudvg3h4kW/R7lFuRZYcOTnjqbHEV8XZ38AKFUKHqAD8qij7r2YoK+O32veQWwlEE9XMEO
	YHdqh2jDUTrclDcZ/RwnbuNPlAzgPLBc58VyUmiF6CubjU8/yObHEaoljytCWowKOkyrXL
	cSYLkARvGH+XwHynTatqMMyP6PYDzIw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-629-KgXBagIDNCO-RrImF1kVjQ-1; Wed,
 26 Nov 2025 21:15:59 -0500
X-MC-Unique: KgXBagIDNCO-RrImF1kVjQ-1
X-Mimecast-MFC-AGG-ID: KgXBagIDNCO-RrImF1kVjQ_1764209758
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C1563180034F;
	Thu, 27 Nov 2025 02:15:57 +0000 (UTC)
Received: from localhost (unknown [10.72.112.107])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C470C18002A6;
	Thu, 27 Nov 2025 02:15:55 +0000 (UTC)
Date: Thu, 27 Nov 2025 10:15:50 +0800
From: Baoquan He <bhe@redhat.com>
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baohua@kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm/swapfile: fix list iteration in swap_sync_discard
Message-ID: <aSe0VrozSSD0xeGl@MiWiFi-R3L-srv>
References: <20251125163027.4165450-1-youngjun.park@lge.com>
 <20251125163027.4165450-2-youngjun.park@lge.com>
MIME-Version: 1.0
In-Reply-To: <20251125163027.4165450-2-youngjun.park@lge.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SAyMatVBufs7MwnoXEjB1XQ4z0sx7o70XAwJqYgZQ_g_1764209758
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Stat-Signature: gbybtt38gofnzdct7admqizu893zb9r8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BF034C000E
X-HE-Tag: 1764209763-401724
X-HE-Meta: U2FsdGVkX19SfY9eFK4Vk6gamMehoqFipVLI4IGCXxKQf9D7+D/gz/7G6eG3mbEI6ElPpQjimHxn9/KJxzUsuUTkY0ulfv60Cs0DhOMfNbBCYVnUI0ENQeaVXt/8GZBE/epQXh8R7lSb+NiKV1aBw8aFkTXM777inO45GJEDH6B8GxPFLVteQdcYkeTp+faNB74czJ7LI4mbc9qlnS38G0TjERqY7PL2GPfIkmB1FQF4oQGISsLxzRP3as/Wtjzur640oUNaipQZ/LZSXbh77PD6FN1hcnz9iJ2TJYBusxSpWcWDEuqKK4RpZ7i40flGHuIKnjuY/yl62CYy7LdCS5fKClc9+ZW0VCRBrQuQxFOnk+tbpYhA2PFN54BItpR1BUljYAwHgM5munf+Vd29W28MzpJgScUqIaVamDRcE33es7uS87Od1eSSbFc/Qx30Z+sJOR9ZatgmDROeKDYOcZEc4CgHmfjnd+kJ+o6WCZIDMac3FiPBGBQXeLffc1jic77fk77MeBQLV2EZS/CF//XbDqhAOwTVFMOlivQcEdajtCnbBTx+FdI32+5H9kleHt2KV658YNmuPz9154y+wbon6u3ldaO3su5F6AvdTV94DhBbV2fMBI9CD+YhsBQ+eqR+bqYJzrEbZrWJPZNbqB+PlGIGkXg/m7vLEztNXDJX34af69RXzJYxJ7MdiP3qMRJsf9EMWlFpvnesqPRZZcNWeSYN1b6Htq8/RCrjqKM4vc91cLkqtCNaU6Rl/cDbQ10wJIlQJGaUsDWncs1eZr3g70RieXvRS5y5hk9vXvXM63/TpzKTgQr7EXLpmww2jqRuSP3y0qzXQ40SEpiLu2N8kmoRoxd0ijLMJhwVF4ajrXxLoLqnmPagKAfvhHKYNQWEeimO+EMUIU9YZobYPnEVRqOSAKKPVV40BFCJjAx6T7PycCmeTm0ZVGJHW581RB7IZfIWHieq9xxPKP8
 6HFB3iuA
 aAreG4lo18xlYHx5YRHH+tLR1A/xcNzLB02akiOAbwpowl88Z5qAosbDLWdjE6m+BhuDCpBe4w9k6Vd9yBuyEs2Psn7T0oSfLqF+rJsbC/OyKMXaBo5nqpIkbGck22W0u0lvWSQFXkoRwT8c4fABl+xOfkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/26/25 at 01:30am, Youngjun Park wrote:
> swap_sync_discard() has an issue where if the next device becomes full
> and is removed from the plist during iteration, the operation fails
> even when other swap devices with pending discard entries remain
> available.
> 
> Fix by checking plist_node_empty(&next->list) and restarting iteration
> when the next node is removed during discard operations.
> 
> Additionally, switch from swap_avail_lock/swap_avail_head to swap_lock/
> swap_active_head. This means the iteration is only affected by swapoff
> operations rather than frequent availability changes, reducing
> exceptional condition checks and lock contention.
> 
> Fixes: 686ea517f471 ("mm, swap: do not perform synchronous discard during allocation")
> Suggested-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  mm/swapfile.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index d12332423a06..998271aa09c3 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1387,21 +1387,25 @@ static bool swap_sync_discard(void)
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
>  			put_swap_device(si);
>  		}
>  		if (ret)
> -			return true;
> -		spin_lock(&swap_avail_lock);
> +			return ret;
> +
> +		spin_lock(&swap_lock);
> +		if (plist_node_empty(&next->list))
> +			goto start_over;

If there are many si with the same priority, or there are several si
spread in different memcg when swap.tier is available, are we going to
keep looping here to start over and over again possibly? The old code is
supposed to go through the plist to do one round of discarding? Not sure
if I got the code wrong, or the chance it very tiny.

Thanks
Baoquan

>  	}
> -	spin_unlock(&swap_avail_lock);
> +	spin_unlock(&swap_lock);
>  
> -	return false;
> +	return ret;
>  }
>  
>  /**
> -- 
> 2.34.1
> 


