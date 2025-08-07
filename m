Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBE01C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 11:22:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A6A28E0002; Thu,  7 Aug 2025 07:22:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5562B8E0001; Thu,  7 Aug 2025 07:22:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 444D38E0002; Thu,  7 Aug 2025 07:22:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 343AE8E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 07:22:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BEEF811677C
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 11:22:40 +0000 (UTC)
X-FDA: 83749723680.29.20732CB
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf29.hostedemail.com (Postfix) with ESMTP id DE134120004
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 11:22:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=eju2198E;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754565759; a=rsa-sha256;
	cv=none;
	b=xRm34joWMsWKsltm/9EaP+5VoMeaZ2q4f8+RybJQojHRSW8gnMyARV5D9606+u5Sx2oQbY
	N/Frd8I2IoJVDCxNX1PdpZDl7nP2i4F95s1jdbfmJDQBUUGw+Dqba+OGeGBueiwpR2pCyd
	B9CJ7k2JI6J4ZVWEu3gW/u+rwWWQ/gQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=eju2198E;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754565759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ZbKQJ5W6ertupco9EzwscMnQ6iskl29md9zy6imu7Y=;
	b=dQMr324ZdkL+O+R/jbyHRBFIAOKDAJNNw9ZJ6onVDLH9p19AQ3YQUOj0wsR5gFmHUbjA3K
	sg2tn1Tf85z1u/JyZlGvMwNa9zWmqrQncdpUXNVmbz6TiYi65eR5+JUhPKmzC5Z+U8hK5b
	AUmOP3yXIZEXzW6xN5ntngQxOs+jIEY=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3b78d337dd9so516386f8f.3
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 04:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1754565757; x=1755170557; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3ZbKQJ5W6ertupco9EzwscMnQ6iskl29md9zy6imu7Y=;
        b=eju2198EesXGfh8bBhdYMwdQMGYFJegY0mVofCNTaQ9h9z7ubn7q5mAB/aEolzxgM/
         JdpPQv/1a0Vxv1ZmTS6FhMVlS7Rpdc3ET5xH/qWJFdSEe34GLhObolAtufK3P/1wwa4p
         DbwK/J2KIVQMn+i4X4XuyWeBnz+4vExe+ha7Cu3bImdbf2eTOdfcrVWDG6jI2o3Ww+W8
         3CEDZogBBp5PEGwWFIpaw+qiM7e/rqcC0Y7legQsmsWiJGBkFdLF28IV3upc43Xcgey4
         nIyufDrhDScnUGkLSbVqT8uHXdvet1ShwKTjN6RUOH0eXLNMWRzCpr8W6mO/DCCcehuY
         sucQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754565757; x=1755170557;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3ZbKQJ5W6ertupco9EzwscMnQ6iskl29md9zy6imu7Y=;
        b=RSAFizN1VLJO9MCFEttFKl4FK+gtOVoj9bmONIO1fKLTgYcsalRui/+kwSLKW+XwdM
         gpfhmaON94Bh148Wtg7OBxy+riYjn9AQ8rzwtkGk8vazNWpzIUxe+tyexQa8y4Ziwvt/
         m3JHM1AVpMcvoup8P/homPE8DOOHreOlWnqrQhufKpFzvAtei1Ca9IDBlX2Ha/DaNaUA
         XGWaeQ4Y3SzYbq8IrhvEVsov8+wYDK+isx9LWAyVkzZbWOYIFW5QhbAZpuADFKx5HV6Y
         FAO5RHRDuXVD49I3pRBeUW+AfvKDWIxdWD0ds2yyfU0hruvTAqzfb8kmBI//tdB9TdHc
         TbDg==
X-Gm-Message-State: AOJu0YycuEowC0Z6CBKzLR9dLwaCrd/g935mzlGgXVHn9k99wknieoq8
	mvXW9Ca5Wb1g1PUrJIqDOJ7/VzsX3T7YEVfKjx6D3V4Q6jm/09UAF9IajTOIaMKRWtc=
X-Gm-Gg: ASbGncupRnxi5n79Qnt4DAI8xwP5F42KRAFZQVri9XlFn+lQXEu9CHPWCVCh81K/+Lr
	NBjQa24FfQvytRoff5TcsHCWnVYk4PNaJBd/ACvhJ214mNE/lz746LFrKRRFCfWaYGhHV2b1vPh
	jeGC1RpTBDBMvAl/y+csOkFdUXhl6+CAH9goNqy3i3r0wmhdySU5zlVNr16yXZzqh4scS3aWXRk
	m/qIw+3tdX55qPJ0vi6ly41v4Cgf9snY+YK4LAmwdcjJegjoeXa2OFKZ1S9+D/wheQX4P5yowIh
	X/sx9X5FRNI1Xhjede95JC02wnHIo/O82dsjxx73KZGu683pACpfw+MImPg0+d/a1P/uP42/Ndz
	rmEgeddryNJ6UVxx99IHysb8wOzipZPwrY9E5fUz/vCARTg==
X-Google-Smtp-Source: AGHT+IHpcvEuPhORaYXA7n7MCRIWBnQ/M3PrlPL9izMPtoJsoR7KrAC2MiYimpXbbI1MYSV6/obt7w==
X-Received: by 2002:a05:6000:4201:b0:3b8:d15f:45a2 with SMTP id ffacd0b85a97d-3b8f48e2e45mr4360108f8f.14.1754565757391;
        Thu, 07 Aug 2025 04:22:37 -0700 (PDT)
Received: from localhost (109-81-80-221.rct.o2.cz. [109.81.80.221])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c3b9c7dsm26206779f8f.26.2025.08.07.04.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Aug 2025 04:22:37 -0700 (PDT)
Date: Thu, 7 Aug 2025 13:22:36 +0200
From: Michal Hocko <mhocko@suse.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/8] mm/vmalloc: Remove cond_resched() in
 vm_area_alloc_pages()
Message-ID: <aJSMfJhBOltRiSUh@tiehlicka>
References: <20250807075810.358714-1-urezki@gmail.com>
 <20250807075810.358714-5-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807075810.358714-5-urezki@gmail.com>
X-Stat-Signature: neknt7afrjuo7fbk47gos831tnuhbaag
X-Rspam-User: 
X-Rspamd-Queue-Id: DE134120004
X-Rspamd-Server: rspam02
X-HE-Tag: 1754565758-573087
X-HE-Meta: U2FsdGVkX1+tZoP4YH8XPAP7Zrn/Bu5RUyVuAU1iua5heYoqVOR2pSHJEo6xF69xUgJa4Y7eVW+rUWiSfWIMs5zkAdO8K3jAQOH+8GYxHI9iXukCOaNvUVXIoV7vB3eDP8rVoSDfpJ8vHwmD7hWmU1e3j9gkA2YoUSlauniwdK5Euc2MYiJ4fbFY6d3+nGkPXu3PnIfZuUz3/TmPznDyHPn9beLTvlRwIXXCW6s5uSXgtkvWVg92lGL1eQzrB/pHuf3oIR2owYv9SwmY9tLVVQ0cVzes7qoxmBYyPvTqupY9gVSLnj8qRf6AO3mhdfvVsTUVo/XxREYOSAzstR092h1HG2rAwOQX0Smq5DR2Fk5dK+nDehm5ExuReqYOi4tr+LVuw6kLBqBDEFeSOOXcgFPtkLaPEb6oKMhECwFL/SKOAECjwlmqbOeZLDEOdAGhH2dCn7cnEEBxDLR7+c7Jy14FDgOWFHj61WYrU/zTyu1E4sbmPBASQOXDb6UDGUG0RGcV7AFA92uTwxHrWZ5ZfDrnuAwUh1vOVQms1T1lw5IVP8ZesQcNw0LBVy2l1VEcukN5x4xQn24QlckKEvetS4XmUkbjmJuIA9cY5s1UgavwsPEj7PqoUlaJQi+MbyEslAm963na5VGYtpnj5iwNQt7B7V3hQ4ecgfxFP5biVJBdqchMOOWWfbwHUtmk6YEnJm9yVcvI8/nTH+rfZZM8qMGl83yGkF/wHrp3GEpkw2j04XZ1RS+sbuHJZgh8QCbSx07KIHFoGQN3QOJCgfNameBrusUuF28JMYDwk/ZQo+BIE4cKfkrK5A3pyIeMXUqeB6uPD5IsjdbDNOYnjBby6xeaXSGReb2BY/0hSJe5VXUxs4vkauMVaeCcammDqUmsQH6ahB3zgdLNeqGg+U4DGEWN+QilcbGhmn+rXSe9+RvX7UE509eBDW7lwEP2JxghWRTV54Qwk9UWJWnXKYg
 Ct5PITZv
 rDbnyzg0EzqQQScZ4imrSfH4B3p7CIDPUYAIDrQR322IM7ibPzatHx+RAH7pGmc0/Lyws4CBUeEn/A76uu7e8JBAA2P+Bfct2y4QswD0609DII+m8+3mriU9lFknTzrsUbiOhM6JQWIIrBlmrVTywDcQw73clROAahykKWkDiESZQc1ASsEPNJ3iXTeAf9qQrzXXo001bzWr5R8MgIeWt+az5uKXpKcHPVqgY/NvMtqVRN/nwYepFMdCQ4RRtsNLAKmAvXH5rShTTBt54kts/Ze9uzhPD1ZTJk/PeBXx7vuO3zc/Uz4U/E/BlhUxS1Q4x5GiHVH5slOP7YO8RRtvLKtnrQhWIXwlyKEufvJL7Hsv6VE7eXP+oqvdqL3haiuovf3yQtfZe9ktwRx0a9SwiRQRZ2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 07-08-25 09:58:06, Uladzislau Rezki wrote:
> The vm_area_alloc_pages() function uses cond_resched() to yield the
> CPU during potentially long-running loops. However, these loops are
> not considered long-running under normal conditions.

To be more precise they can take long if they dive into the page
allocator but that already involves cond_rescheds where appropriate so
these are not needed in fact.

> In non-blocking
> contexts, calling cond_resched() is inappropriate also.
> 
> Remove these calls to ensure correctness for blocking/non-blocking
> contexts. This also simplifies the code path. In fact, a slow path
> of page allocator already includes reschedule points to mitigate
> latency.
> 
> This patch was tested for !CONFIG_PREEMPT kernel and with large
> allocation chunks(~1GB), without triggering any "BUG: soft lockup"
> warnings.
> 
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!
> ---
>  mm/vmalloc.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 81b6d3bde719..b0255e0c74b3 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3633,7 +3633,6 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  							pages + nr_allocated);
>  
>  			nr_allocated += nr;
> -			cond_resched();
>  
>  			/*
>  			 * If zero or pages were obtained partly,
> @@ -3675,7 +3674,6 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  		for (i = 0; i < (1U << order); i++)
>  			pages[nr_allocated + i] = page + i;
>  
> -		cond_resched();
>  		nr_allocated += 1U << order;
>  	}
>  
> -- 
> 2.39.5
> 

-- 
Michal Hocko
SUSE Labs

