Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00D58EA4E04
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 14:52:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 506DC6B0088; Mon,  2 Mar 2026 09:52:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48A8C6B0092; Mon,  2 Mar 2026 09:52:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 396326B0093; Mon,  2 Mar 2026 09:52:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2AF806B0088
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:52:29 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C02391C0C9
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:52:28 +0000 (UTC)
X-FDA: 84501413976.05.EC11A55
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id A34D280011
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:52:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772463147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SS/kRfQ7kW2MkpjnDipx3LDWzyHFuVWmpTzhfkaXHmA=;
	b=5PIVbWKoxCugkw/69CqO2EcA8LeNssFuUq6BXPuTGZVKf5N7kyjF119IXNOJkN2wkVsIQb
	jjxF7tlGbo95lYyw6hbVVCMopvYvMRTtOb1UqOT8KAewubomXqOewO6svGOVawsTee/nsm
	0ZtG68aVOFzAjpNRmdLzSMrWnqAoFq4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772463147; a=rsa-sha256;
	cv=none;
	b=mrKSgKX5rOeP+s0EexQ+XIqn+O3ahzSUkCEJy/XA67Nu+lvOx7hY5C7MGqPBwaUtrutqwX
	DVRnoV9R4F6UgrG5uJA8WZ/ViTW6WNhU5XxWAnOL98FSwpY0QyrIwjqeTEkqAnu0JiCS81
	Mbta2di0JUqlbYAky0ecElpJN80x3VU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 345B31477;
	Mon,  2 Mar 2026 06:52:19 -0800 (PST)
Received: from [10.164.19.52] (unknown [10.164.19.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 10A103F694;
	Mon,  2 Mar 2026 06:52:22 -0800 (PST)
Message-ID: <6fa7dda0-55e9-46b6-b483-a6dd82f34d35@arm.com>
Date: Mon, 2 Mar 2026 20:22:19 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmalloc: Fix incorrect size reporting on allocation
 failure
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, Mikulas Patocka <mpatocka@redhat.com>,
 Vishal Moola <vishal.moola@gmail.com>, Baoquan He <bhe@redhat.com>,
 LKML <linux-kernel@vger.kernel.org>
References: <20260302114740.2668450-1-urezki@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260302114740.2668450-1-urezki@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A34D280011
X-Stat-Signature: 8tjc1shwsotmzi6wcnw1e8bqutzz7tp7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772463146-669908
X-HE-Meta: U2FsdGVkX1+pj1MTgESBVCj5Yl4reb0JdBIIvUl5D/ewrOMTEUpDlu3CQq6RdMscTaFDx5Mw4TfP1MaSnvIMs1fr75HdpqrXmosPXIYWplIWUpCsXLZqZAGoYUq1rFslMSeEFrqjgRdPh/bELMLY3NOB1Zqrug505e8rpBbcNSjLK+bY1/U7hfvpv6b282ixjoni+HbT5OiWBvusjBqpyaUGKGdJDfd2aHgSFeoZA5afUOD75nDdW8VaaFg0omml6QZ/3CAsnhXNeEALASJLieKD9K50QwVp+BkCQ7YutOHeJvtH87fbqNDQ7ML1u0AXMYBsMlvyYIZ31wTffHnfk2dLt7IyHeEAdvhtA9sCejUCO00AGNd9CHnU2BpeS/Mm226xAQXzUSeNMaOPwo4vpPlrsuEgULALc+asrjcQPCjLzM7E3zrrer+W65lnnf9NpiWYSifKxcq3bmRK67kIXcseqnVZM0pNdd5ihDdhOE3066IL3vf0pSZRLsUhjNPOLXk3A3tYfZLrE1+xl6KLb061Vmh4BnjpHR4kPlyShK+Xf8Xg6U+cfXTlTzlkPB9CxgEpQ3xlBRFhk3s/6djwvIOphsbi1jclegA0whrUME/yLWxjNdnLWgmmiVdW8A0Ne1NfmPKPAEvhte1Wc0BtgAyOA+9P86rzyYoKzgZf9pjqND7Qi7t3ND/UjS86hMmlN6ckUhtU1heIcwCTSbUVDBjgV3SfGlEOYalEXIsP4H/yMxFDW4x7m31NAS3XoFeGmuCzP6Khb28u4YkstR2CYLX5NzqfS0NInrfVx4v5HDXcUJBbHVPm5Lkt9INN90h3VDefCleItJ1pZCEpt6Et2Mzef+ClbUABNvEf8DR1glsKG1NYBbuPpktfZqWvBPq4zsWoxh7kwv3C2CnjvfnkkpoSGs4XciK5zXZMCXRXhy01HrBJV/Jrpgibqnq9WJNkWDnHDnUnXr/IYeRyS1U
 efeRtoJQ
 reCBvfmWuXWk7Acbhx674A9eRZK1V1HJvbIMe7kG2aBrkU3mo/MoWd8nMxFS/K3jffgSlYtM/piFopMyLYQrkamCkhtkdTYubCHOqqT0ynWlmFpVvVHMUmGEql11qlGBVTbpT5u5PZTSf+9AbrV8nGl7LhLEsYDdem0IGp87LfX9XGVlVNAgf4ko1Rh23c7Jpm82KYgBuWfjKfoPc8LJveCrb/eTUnHGa4tcI8e8kSL92/PJJEGURJ+1efeVCcNntG4KK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/03/26 5:17 pm, Uladzislau Rezki (Sony) wrote:
> When __vmalloc_area_node() fails to allocate pages, the failure
> message may report an incorrect allocation size, for example:
> 
>   vmalloc error: size 0, failed to allocate pages, ...
> 
> This happens because the warning prints area->nr_pages * PAGE_SIZE.
> At this point, area->nr_pages may be zero or partly populated thus
> it is not valid.
> 
> Report the originally requested allocation size instead by using
> nr_small_pages * PAGE_SIZE, which reflects the actual number of
> pages being requested by user.
> 
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

LGTM

Reviewed-by: Dev Jain <dev.jain@arm.com>


> ---
>  mm/vmalloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 61caa55a4402..a06f4b3ea367 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3901,7 +3901,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  		if (!fatal_signal_pending(current) && page_order == 0)
>  			warn_alloc(gfp_mask, NULL,
>  				"vmalloc error: size %lu, failed to allocate pages",
> -				area->nr_pages * PAGE_SIZE);
> +				nr_small_pages * PAGE_SIZE);
>  		goto fail;
>  	}
>  


