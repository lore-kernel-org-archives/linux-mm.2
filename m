Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4649BCCFA04
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 08:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89C4C8E0008; Wed,  5 Nov 2025 03:05:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8747F8E0002; Wed,  5 Nov 2025 03:05:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B1268E0008; Wed,  5 Nov 2025 03:05:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6CD598E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 03:05:08 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 09BA81401D2
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:05:08 +0000 (UTC)
X-FDA: 84075817896.01.1AF308F
Received: from mail-ed1-f68.google.com (mail-ed1-f68.google.com [209.85.208.68])
	by imf15.hostedemail.com (Postfix) with ESMTP id E24EBA000D
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:05:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="J0E//7iG";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.68 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762329906; a=rsa-sha256;
	cv=none;
	b=V4FcQTUY6fYdE07n+001MQ5zNM0bCzNkWrA/i+qfIbZa6gCHoASX9wgXuxTJkDXRwxHDpE
	G/jytXLmfrPzKl8MvQ11Zmnt7qqw0yFA5jC1LNDv7I20lrT/nu0mD7S/HIylrasC1A7KLr
	3I3LfPq1gfraWQciMPLheXiUfCh8gYQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="J0E//7iG";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.68 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762329906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=71GwQEmlb5KlvQESKMBE0e5ASzwnr8GNb9nDvu1QaK0=;
	b=N1yAxyPsNseTRa2XdYiVhbbCBTLIJvDofJa7tKLjM5NeF4bynvdLT61mQyzU7ewXew2PwJ
	sT8k7YwJcQi8WIlF2Bq+7WZRCUGjEaDbRhBZOI4lYOB8L7v0WGN71+tsuPXLuVjpDSpLuO
	/fiSfm15L/UbzRPk8OXQCIxOr1uImRk=
Received: by mail-ed1-f68.google.com with SMTP id 4fb4d7f45d1cf-640e9f5951aso1032995a12.1
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 00:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762329904; x=1762934704; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=71GwQEmlb5KlvQESKMBE0e5ASzwnr8GNb9nDvu1QaK0=;
        b=J0E//7iGXsovRM4hQ1KHPqZtvVhzd8j+Om8EBSFUy7lVuvzQ8T/2LqGLteo4XvqCii
         EwkUEyRp5dqABvHz18XOz8kVc+s0vEWu07PBOWXkyjDyIzxDdHeUNjVnlm24LvzUyzD3
         UxDNSEO6ALJg/PVX6A1JfrlEM8wqFYHeiFrIFqR/8O7pSGju9Ec1mM74xu+KPqK+1oS3
         X1c9OHkCO5u35T+r1uYB9DFOsLRuWWr//izk3zCtVTzaYpFWtm3Nk9z9qKTSk/sTR05G
         hOPWUg1IyCtKXJYWbUIo86GvqUdEIK2/YDsmeCxh+bi+C1UoJeWqP7z4373OcaSTwDhf
         VFYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762329904; x=1762934704;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=71GwQEmlb5KlvQESKMBE0e5ASzwnr8GNb9nDvu1QaK0=;
        b=oX8e3SuDSTZx6nOo+wQHIhFP7m2p0V/SP56NvwEMZmU0SvurYxzH5lxds8fsPp2Yy0
         nTj0VqrxZ/A6m8D1D2m122MB1C4nD61Jco9tst4d1E8XuT/zlM8uCN1sdYrHWftSwRex
         dzXoMqJPVPbxh4aHNdD1RKnSLRdFSuBGoRwEcZvGn0RT2tpXc4hnFRWa/980W4eRPwtq
         5Or/4KnV08ruuTonrqnDZj9N9SBk1LATuiIWUUu6qD2uZm+ldCAQFh/yF9chH3l4YVap
         srZDeGyHj42D8EFXjz6VkhvSKkOP5DEYmVpHCAvcE3doFX4m8k50oZ4q8bJFl4hqqNz7
         hCgg==
X-Gm-Message-State: AOJu0YzGagYJZfMTU9E7DW6ug9D7NPP4050Qf/xgtHIrljPk/Ng/uhWF
	UPFrLUThRtYdHAe97d62xg8/CCnFU3Mn123puCkwPDehMdTGLShhl8wENqmeSlE3P5E=
X-Gm-Gg: ASbGncvZRQ5xftg66VpML1E9+HLioou8Fk970jaQHkNOfRVMvoMW7Q7SmopWsSuZYYT
	wf+VIo5rHiR9nVngc4KfIucT38JRn5JHKzhMHlKVqejM4rMUaBhu/PDhweM8mRamXw+AYeb4c38
	QvJoAvNRH8zUIOAGL0WFWiXIIH2/RCduGbFbtnx+zMHvg6Q3/Hm2awdBMfbvxv2hezkrXrmfKdM
	GfB/+gFMC8UzER7n3BJ5typbRegtgH49v78ESPAVomYtmxGruyA5nvf+74aEACYHTXbO5M0GnE6
	Bvb/51o43LOycHVk1fIomzXGX3Chf+BhxsfBqycY/nFPGBuNGYmYM2HLB7XR3NMxmHD+1KMmpq7
	sRnd4pt5nS7paAEQUbLCDPR7fT4ehUNWA7xcOV5k6ib1qXdLJyuqjG/wVydsCv1klJz75juUrwI
	rhaoe2QrGD4NsORA==
X-Google-Smtp-Source: AGHT+IEEhXzhq37oJRywdcOqIGp9D58/uMJRA+rB+PyKP5jFsBdtBNEW3+7DMl7vYIujFgzLDarlTQ==
X-Received: by 2002:a17:907:6d0e:b0:b70:6e13:66cb with SMTP id a640c23a62f3a-b7215bce9f6mr665713866b.10.1762329904337;
        Wed, 05 Nov 2025 00:05:04 -0800 (PST)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b723fb057e5sm410190966b.57.2025.11.05.00.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 00:05:04 -0800 (PST)
Date: Wed, 5 Nov 2025 09:05:02 +0100
From: Michal Hocko <mhocko@suse.com>
To: libaokun@huaweicloud.com
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, vbabka@suse.cz,
	surenb@google.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, willy@infradead.org, shakeel.butt@linux.dev,
	jack@suse.cz, yi.zhang@huawei.com, yangerkun@huawei.com,
	libaokun1@huawei.com
Subject: Re: [PATCH] mm/page_alloc: don't warn about large allocations with
 __GFP_NOFAIL
Message-ID: <aQsFLn6VDFOXuvxv@tiehlicka>
References: <20251105074106.3508870-1-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251105074106.3508870-1-libaokun@huaweicloud.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E24EBA000D
X-Stat-Signature: wu1zg6w1u6q1frstfw4k5xga3784igd6
X-HE-Tag: 1762329905-229487
X-HE-Meta: U2FsdGVkX19wPyOEEE7mFMox2cUfppf39LdZfmcmMGXQg+UtyKGLDEU3linwkOPAg78uNoNABvDJ2bHhLNgJgGW5IhhYBALR+qO0Ep4WiBsEW8Sn1ACAaLZGP8z7qNVikEl1vPps/svP1EHUfSaZdm2nA2ehh2y9AhYg2BHKjmXnSTII39cw5eGNGoD+MgZXh+YV7R0knanbMRHuBv8EiLcXi9QcVE8+wd+iqIvZIlDhzEaq2HlgZ+ZXTEiaiqSvx3qvu/jJ5GexIrcV591r+C6g4nCs3A4/8b50ZBhQtLOuhZILAvp+wOV6TizZUweewalxHaJli25ZTbdjY8/FTaGLaid8P/RA+ttcm1aZv5GY1PISp1XVeO/9SBjshzQkJpZztu/4yyTq6g2wHUCajWIbDpAXW6/dpKBdmvEGzvls4jfyNKGLY+aR79XaorHpyVOUOCLQFeTQcPone2jG40SV99MxQiYDPsC3zZIR+xIifTDc1u9bjgCqdajSTgBYKPehf4F5QwQXySW/Xz3jlM4dHfKkWFt1IYkVZJ+xXnWRIGR2xKi+iNZRtYCV32tagPhcweQiAIVV9YgaH0EgjVUlV/l4hSY+NUHBMja5KIqAp/HFpEt3srP0E+ZUAyej5C6yCFuk2CkR3mwkEtzyhoeR7/AB4h7FLNqMgBbchpV/2I0sM01aJFd2aHp2vPTAnfdwca96xSsVEU7hawGKDu9AnlwhfRxmi7kz1TEdFQY/UGhHWBcME6OSRmRrsMuHZy9rwxrfH2jsTXPKQTb34ODSLzRGWD7mzi0g/nwPE7/5gTqILqJ5sw2ZmsgIXxAly82ushd+U5QtFgque1s+7Fkm88+cET8F2Lw8QHO+gzBbrJZyuaLptnMc4nEAnK5CTmODj59g2BYI+XsXwKnybeMkeERA0g9ZRiL/6UDjn52vBsPwmovdoeruuGxhG08eo51HibdqhWKkBv83uCD
 qdRig0rW
 j7qCbsnjqTlRjaaoV5KQAblLkek41NF8ClsTJPYAmc3COOiHTQVsf5qZcTkcKb5ZcSweajFQ1hmJdIdqdobFDQJ7JNPjU7pB7GH3VxDjLWghdLWWin+sasISV0TIc9AnUMsN9TvZAmldYd7SQdhbsfkYmUt8bumzF/S0YBJHgRCPqd16h/+FnHJ67nGd5GxzoaQXLi8ZP8AyZLaXIuouPY804I/YKIhiiUB5Zdx2r4uRIhahE3VliUf66PTYcz9RN2b280ZUGln2vMPSDfL8W5MGql3ynpUIV+hbV7flZLbz2x3s74pcVYyivZP8C+9iXOv0x6TEkLNMxvsierI12o0ZfNimPnEMCppsjHVYbHvuNHNFLY8l3nd/lurfjisEGlajaqPtQj3XOaVWJPnhsuO89ubRueVTzEt7tJi+1T4c5Sm7GMKPB1e465n6FCwuPenq/ePe9pcpufIiCI4DsrDDuM9QqQQiKug359F3g6koafsNJSS5YjQWqTBCNxi1UJnYfDWm+UBiyQ0y+ZG9N/XLz68SsfE+6s9y+dl25fDk70EuG9zQ1Xmd6nUWeN7GZd5DMR3vcaKiuY6CKKJ1LE8ky2fc/kmeQdWuyDRWkC9TShVruwQhObNdZx6qs7v4bjVKhD4iW1TJv6kx4hHfpPmeSMJra7vPhzaifEpcWBEz9rG0U5vT7wh0xZYdE+eQ8zc+aCvRXjrCQj40=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 05-11-25 15:41:06, libaokun@huaweicloud.com wrote:
> From: Baokun Li <libaokun1@huawei.com>
> 
> Filesystems use __GFP_NOFAIL to allocate block-sized folios for metadata
> reads at critical points, since they cannot afford to go read-only,
> shut down, or enter an inconsistent state due to memory pressure.
> 
> Currently, attempting to allocate page units greater than order-1 with
> the __GFP_NOFAIL flag triggers a WARN_ON() in __alloc_pages_slowpath().
> However, filesystems supporting large block sizes (blocksize > PAGE_SIZE)
> can easily require allocations larger than order-1.
> 
> As Matthew Wilcox noted, if we have a filesystem with 64KiB sectors, there
> will be many clean folios in the page cache that are 64KiB or larger.
> 
> With gfp flags and order already included in the OOM report, both
> Vlastimil Babka and Michal Hocko suggested that we can take the risk of
> removing this warning first and then observe whether a large number of
> related OOM reports appear.
> 
> If that happens, we can consider adding special handling in other places.
> 
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Link: https://lore.kernel.org/all/aQPX1-XWQjKaMTZB@casper.infradead.org
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Link: https://lore.kernel.org/all/188a95ba-6384-4319-bb74-c0d9ec6c4079@suse.cz
> Suggested-by: Michal Hocko <mhocko@suse.com>
> Link: https://lore.kernel.org/all/aQotQBjnDDeL_wHx@tiehlicka
> Signed-off-by: Baokun Li <libaokun1@huawei.com>

Thanks for referencing above links which are providing a useful insight
for future reference. I would just add a link to Matthew explanation why
kvmalloc is not an option
Link: https://lore.kernel.org/all/aQTHMI3t5mNXp0M1@casper.infradead.org/T/#u
Acked-by: Michal Hocko <mhocko@suse.com>

> ---
> 
> RFC: https://lore.kernel.org/all/20251031061350.2052509-1-libaokun@huaweicloud.com
> 
>  mm/page_alloc.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index fb91c566327c..e4efda1158b2 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4683,11 +4683,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	int reserve_flags;
>  
>  	if (unlikely(nofail)) {
> -		/*
> -		 * We most definitely don't want callers attempting to
> -		 * allocate greater than order-1 page units with __GFP_NOFAIL.
> -		 */
> -		WARN_ON_ONCE(order > 1);
>  		/*
>  		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
>  		 * otherwise, we may result in lockup.
> -- 
> 2.46.1

-- 
Michal Hocko
SUSE Labs

