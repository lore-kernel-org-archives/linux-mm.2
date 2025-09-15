Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E258CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 17:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06FAA8E0014; Mon, 15 Sep 2025 13:11:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0464C8E0001; Mon, 15 Sep 2025 13:11:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC5B18E0014; Mon, 15 Sep 2025 13:11:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D7B1D8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:11:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8875A1405E5
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 17:11:32 +0000 (UTC)
X-FDA: 83892126024.16.329380B
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1B2141C000F
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 17:11:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=GPspb9vh;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757956290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Tl/RXGMAL1JqyStv0MTAwh9nUwRE5C//Qnl70T6OQM=;
	b=M+nMoNwlQcxY2dGIS3KP7/gnJj3D0AIK0TiQTcyOPjDUkEwBzEsOYyY22W/IS8KkO4fMsi
	8I+yrPFr+/pbIZTKFBo9F56zVZYTo8/2IGi+jAZf68DYStxTuCw5n1WbIg+mnWqlVMN7xP
	/G/ZatD5ntU/MEIHeULEK2lVELd/Qgg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757956290; a=rsa-sha256;
	cv=none;
	b=OWbzrefIQTJlLxKWWj+pgEN5337uE6oJWhCx//iwbV7YupcDNKAudS2vUBbKaUY/AQ8X5C
	KZ3PM98Ta2MgdCCWxEX1GDq0xjedgH6nb0ILqAuClGfxo0QYk4PT1gxbBBImRFPARwGzB+
	WOlralMb+bVQa5NUSTZA4JNgTJA3iM8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=GPspb9vh;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-62f0411577aso4477134a12.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757956288; x=1758561088; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/Tl/RXGMAL1JqyStv0MTAwh9nUwRE5C//Qnl70T6OQM=;
        b=GPspb9vhfzCwRCR/5yelWa4eOPJMuh4beWZXjlhzl8FU7OaJ5iFofanBG50if+nEW6
         TLt7zvzxTLj3UKGYhoqrGoU4WMP3B4nepuYTSbLcObz3dImPxSsIZ/79mgYYlb0hVQlW
         Hs4NDzCRni3cpdxof/TM568/57Z2wvRVsF2RUqrS+erX3Xbl16rhnet2ZjSRh0WNaYzW
         PFVrcX253HfNd44lfiYsxg9+ltpHS5fBC55YNw4/IEFwfKnL4C3ktJ323SQvBiPhg5to
         hsDrPWKGIoNs2nuqJTnaH//AdIUoCkMPTxrYJHbqMSz6Z6y2UZUe9mp2Zg3ELXJNi4tw
         yflw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757956288; x=1758561088;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Tl/RXGMAL1JqyStv0MTAwh9nUwRE5C//Qnl70T6OQM=;
        b=mQu6gsP83Ar/g5lH9qhGpU5db5kHIlUWExU/kH45pv2+bQCyR9A5tHwVT0LHN7SMq3
         aD9UD1t+hLehdmROhHb3vekSD2AaZFoczIQOZwUyIAAkXFqCxud56alfwCrt1Tlm4u7H
         b65HWli0HH0BpjSnA5Q+Ike9e/AMcDbIJv2AVmoIY+3XEneXXIGvX87bBOUUjvMsuz6Q
         2EwBF82sWFaQ9X+1VmigcUHR9XvX9PjxCvi9UmzSrSbjAOiPTdNUKd/e43THttx8vyEY
         1PVg7WKVqosgM2uwXF+um/MqEimAGZMai7YN0dqKhm8XYLrFNqKOPpFyJG/Xv4osaSRq
         6u+A==
X-Gm-Message-State: AOJu0YzKzhQykludREFLdUDBgt04MZ98DredBCbFIL7P8xE3HRIqwAGc
	WTyBh8I9nxwvL20W1RFHh0dSly5UTiPBXj+4JVSsX84GQDnyBLLA2At3gFFLF8BIb4xb21m+XgJ
	UaxmP
X-Gm-Gg: ASbGncv+3cdJyRJT1I8zugOemam9DCY8odYqIeBXNXYOB2w190s05j9CcF3fFVocr7L
	rN1ukMokAOPgbULF645GtQgBqeC3MotOfwoCLrCAgGzC3DvK7rjdLxRNakS5f23kEM491gY01gk
	lJJ7ycwK+oPG67/296lpOXNEhuCzU5YMZK5O3PnLRL+memDs0aPoClv1d4I0RVIaRDslaAczXGn
	4SYnj+/GKmI4LtGEuBWLiNLshQr0K9kXxHdrNZOJIYjZ/p18tqHN/lnFK6p4NVH82ZszUrRBamG
	odKbKNRH7DalTpFxpaxFccxZfOOpRtM9x/jC1PhDKwRqpryVrMilvKrna2451bVvUejNvXOawPy
	TAsGZ/oAjZyQs1RtIJ1tQbAvchnWsvRtTdg==
X-Google-Smtp-Source: AGHT+IEU141ppPHC0f43WV7Mu6b53qnsOKX1PToxTJqKeIfoSyv68wG7aiLv2qvPkXtSZcUgUGL70A==
X-Received: by 2002:a05:6402:2714:b0:62f:50ff:b675 with SMTP id 4fb4d7f45d1cf-62f50ffb8a6mr1585266a12.33.1757956288538;
        Mon, 15 Sep 2025 10:11:28 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-62f11390075sm5158227a12.40.2025.09.15.10.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 10:11:28 -0700 (PDT)
Date: Mon, 15 Sep 2025 19:11:27 +0200
From: Michal Hocko <mhocko@suse.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 04/10] mm/vmalloc: Avoid cond_resched() when blocking
 is not permitted
Message-ID: <aMhIv3HfRMyjlSec@tiehlicka>
References: <20250915134041.151462-1-urezki@gmail.com>
 <20250915134041.151462-5-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915134041.151462-5-urezki@gmail.com>
X-Stat-Signature: rgn3s98zgpxoxwdgpbjf8nzoeo67185k
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B2141C000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1757956289-266767
X-HE-Meta: U2FsdGVkX18h619CsVlqCiauEYG7YHENbDgSrVmAXH9rF/aZ2V3+8eDyz0mCTRDsEHYibdX/QbNW8HFq2rEfhyL1I/XAQanZQfeceA9oxlacos7ojOcbm9spTBsVLssShZ8nqVJAOXULyiMIkzzvItkFwh/VlhOcS9OgmQYwolQMueMy/WB61KrrKxtlUYGmdNJ9gtGUDWJ21oPQZ8kt0wNHA0aMPcxlcqaGoe/zx4LQ8g2L6FgUq0Nv7AoOvG9e3IpKNjC/EfNJhfprcUHI4lPcQOVSIBUnD8fF1oAOkLM60PbEz3LGd3eyxOis/mle6QxMMHM/OIA7rPS+Ru6L1CmZdIpmq7WcC92U88sfCYU1To+4ATncgxKyPikGQxAFQSZb6cqQ1cjO+OxIcOZmB3QJjRPOkhkLp1gfqi+xEwoH9T74MUJg0EQ7sJyPF6a1D790IFjl2yrJXQAtfMC6HM6Jti9deQxqd1Il79uSTBY7IoPZWrb199qv1+PekZWHNgoyxQ9ZklOXjyYOKQw4OLa+fY58dSfA9x/PzfG4GHL2Z31MTqHcMkNdB+3Q+MDk/Iit//qFWTQOuiAOgRvdPFE6KUJo4XgP8+MbdejHJjd7grWGcwcA1LFw7i2w1lyZE7twixuhrDfr7zK0++1GIWoMJtvudspVdPgGMRh40CGEIQk5pxoH7MeamoabA+lcK2ivqsOytiX53XVCveenaxUt6EJJrhQQVp0OydA7L/vbS5MtXxftrrI/djRtmtDcH82u9KZoT50MPo6wae1zPrqTnfQP3yD+tO+76J0t2Yn+DpI6Pqhj9iiwbfuuE9f7JP3VjAjVVQTtrp3UryZ6l1AfEXdIA6VCCtCwsOEABJaZlOXnVWNSx10/vAairQfBpxjwoo2vIgmWN+sIW9ZBzqtJCfQHDU+7L51IVN3fs5sy2FC1p/EwfX7LnRpb3qtZi83tuB+g60xq7Q0Ki8v
 V24X+4vy
 u0xk6Y2zib/2Z9ZaoLb+qy5N1kpoBIWIuCkmCku+p6iUDkLBB0De8odM9W2aTrZ6PaXRobqguy6/v7Yv5aHfUViAfpVQDUBQGBrzsbBN5hIPl0KEOGEYX3OSjb59npgFSfMHLYdbwQGi2UwI48WiE0jVDj4iiwUGM6+xIbDeuWtvm4sUYmK84WiLdJBDe12oCfC7Qx88k2bMPgvKokZobmPZDdkdcEP+KdeONdL3nhx1ioP5eSMKJS368+2ndN2xTJkVK0LzQ0RgVXCxswl6KfvvtyjH1THqUD+41C0zyCZzI7H3rqvM2kwV+51p4yjScnrQijokrq9mxFy1eW2gApA9sJSPVQK4pLq3FoUJ4D5BLdgQw1MNtcefJRZdCELB/hirf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 15-09-25 15:40:34, Uladzislau Rezki wrote:
> vm_area_alloc_pages() contains the only voluntary reschedule points
> along vmalloc() allocation path. They are needed to ensure forward
> progress on PREEMPT_NONE kernels under contention for vmap metadata
> (e.g. alloc_vmap_area()).
> 
> However, yielding should only be done if the given GFP flags allow
> blocking. This patch avoids calling cond_resched() when allocation
> context is non-blocking(GFP_ATOMIC, GFP_NOWAIT).

We do have cond_resched in the page allocator path, right?
So unless I am missing something we can safely drope these. I thought we
have discused this already.

> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
>  mm/vmalloc.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
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

-- 
Michal Hocko
SUSE Labs

