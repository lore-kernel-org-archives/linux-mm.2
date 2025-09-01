Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0DEACA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 10:00:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEE058E0015; Mon,  1 Sep 2025 06:00:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9EB06B000C; Mon,  1 Sep 2025 06:00:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8D578E0015; Mon,  1 Sep 2025 06:00:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C4BBB6B0007
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:00:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 73992C074D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:00:42 +0000 (UTC)
X-FDA: 83840237124.17.76050C2
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5F982180011
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:00:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=azKI0tDW;
	spf=pass (imf06.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756720840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cbZ25W8iCAPDZ+e84V/asPNaTiH1EdBFg9Cchs0HHvk=;
	b=vrEeheCUbdBM8to6jOPjk9stCcg3+0Vrudqi+gcDT4oDrGzkhOUo3hJSzDN9bsgepHUeQ6
	+eNuCXL6qj7hbITfQCsg9OgA/g1Xh8+Jzz69X2ojzzVQ0Wy/M7DTWNuqELUu25AvSkENq5
	znKQEBhCjIJYpLzPDeOFwQ1yYEEI/BQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=azKI0tDW;
	spf=pass (imf06.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756720840; a=rsa-sha256;
	cv=none;
	b=OGlE4sJT1qIlWWnk50MZ9MgFuSfkbcjrKWXRZ+cHxm8trS2XL3lyQcJghtv/2Aoh1p7yBG
	PWulM8QpVapYFLPcPHJgOzUH53o0ZHuCOZtl9fTEdnxm++UHowoEQoyS38kTCFw1zmSmYr
	m7o5m5LQtduuO2BISl4AznG1daKGry4=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-55f6f7edf45so1790804e87.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 03:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756720838; x=1757325638; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cbZ25W8iCAPDZ+e84V/asPNaTiH1EdBFg9Cchs0HHvk=;
        b=azKI0tDWDx62ZHVXNgsH1j1VkicbYULWGAKFRZk/rA64DWvR7WZ6U7INaipV4x8vmX
         +GRgzBPSKzMD3rtXtg9qpnUPnm5RfbZPbB0WV+4ODbKox6eYTy7ywqYOUY/H6V40Rm4l
         dVr81itPepNP0lLSkW+dqwUOQUy+IgITmgbmofIoQK3MVIFjllIeps+dyd364nCqYaAe
         BScqgZg0GMXDfTDZJK6PuluQXSfn1QRuVFQlcP5jHcSZ3KmKRaQchzoYt9y9xCNbtOQ0
         wH/tvyjljOMO9o416DUQA1fRvH0F0kk4HFrkqEG8D8fk8TClpXiQczcn5FaIKH/wh1L2
         Ub1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756720838; x=1757325638;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cbZ25W8iCAPDZ+e84V/asPNaTiH1EdBFg9Cchs0HHvk=;
        b=MDtlA3cdhYMRI3OmZfHH4DgJmcZpAfTe4WBSsaabpG+UsLqpQdZyLbOPJ7HXluMZ07
         JeHsDbXoTAKCC6ISW4MfJxpjt5UFs5Co7Odkn500xTjuwG46moiAl7v9Jzi/9q88KMQR
         Pzfmt9F5w/2rGW/3iE1dX5Z3aH5vi/McXHbX2A/doR1QwQELis9KpRzvYtwWZVBjxw9i
         V+K2pPHK6mYKlSlA7N0plUyxfeDLP1xKm1GXh5bAjx1srmrkarD/L702rc4xx4XYfYzc
         yLJ7YDphldSrHiE5lDzy+6Y4z4r1+Oank1Dk+6UOTwzzXxqgGOu0QjTkWEXek3yKtLp0
         9Iow==
X-Forwarded-Encrypted: i=1; AJvYcCWgMnw6LWykAOXY6whqOmDJILYADDJTTUczSfrSDfrAgSpjVJXkfn7GtVlQ194NlOg2/EEzoYzmtw==@kvack.org
X-Gm-Message-State: AOJu0YzIGElVkNBKjYWpPOIU6tnbWFyHxjGw4eqVUPcXzIBua+ICJCdo
	shl90uNjV9ps0IuUTUiHwyyoEE2W8bJgolb7+Da05XXvFlisKiY38RJ+
X-Gm-Gg: ASbGnctTsxXdwz4O7wG+kDzQFTIaXyfV/pgQQSIL7yxJkLETowwKHxAZr3ywN0mhMp9
	HMW3md12dZ5/9UWjGPsFU/uyDP9zUnAUK9MTf/SnTiCooMToUErYNzTNmv8KTqKUW/4hFZGv/W3
	GzX4LKDG5uHY2z8H5XzW9L8h/M8L/Jv1SqeOGA3AwQhatBF2gs/lPkD2BZBZbALJIUnILdKF0ql
	nGGbq9c6awJ3gHXolV7UALBP9WkdYggV+I6UKiQnjEar+gJirR0ElBb4wlG9JwITooeWMAREzU/
	tvbz2xZmgEoI7iE+P/bzM+FfjXBnlxoWDbxlCXfF7+GbESXfqGvPPtN2nsa0g581rrS8+eJtPvm
	Cw3f6EwE7K2g6AIvn0CBpIUJn1ufM
X-Google-Smtp-Source: AGHT+IEkJWQKPGB/V5gDesXHhU7t+HLT3boR3bVvrdNVX0y2aL9Wqfy8sEgiMLTdUoIHPa1mK7qSCQ==
X-Received: by 2002:a05:6512:b97:b0:55f:4e18:c583 with SMTP id 2adb3069b0e04-55f7099a326mr2203573e87.56.1756720838021;
        Mon, 01 Sep 2025 03:00:38 -0700 (PDT)
Received: from pc638.lan ([2001:9b1:d5a0:a500:2d8:61ff:fec9:d743])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55f6ff236efsm1951003e87.1.2025.09.01.03.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 03:00:37 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date: Mon, 1 Sep 2025 12:00:35 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Michal Hocko <mhocko@kernel.org>, Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc, mm/kasan: respect gfp mask in
 kasan_populate_vmalloc()
Message-ID: <aLVuw2UkYUcL_Oi0@pc638.lan>
References: <20250831121058.92971-1-urezki@gmail.com>
 <20250831122410.fa3dcddb4a11757ebb16b376@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250831122410.fa3dcddb4a11757ebb16b376@linux-foundation.org>
X-Stat-Signature: 9q1nc5ttt8q7thx5nqszwnh99hjy6i71
X-Rspam-User: 
X-Rspamd-Queue-Id: 5F982180011
X-Rspamd-Server: rspam05
X-HE-Tag: 1756720840-767035
X-HE-Meta: U2FsdGVkX1+tY5mYtq1O4zE97aowzqqxFX6A43x/pN09NjmV3EY076XvTYKBU1ZEGj83dyMHKtQ0Rimd+adJiTE19/vEbqKCXfDseyQgaxD4aIsp3CvWBEqXZ6GwCOfr0g/sfQkhnk4Qxcm/exPAbCNUlLyoE7UQby3LtfPKp4gjEIs1foNsOg0pjso0f9g2FrXEx5Eag/j9PNQ2p1YQoz3REpgFYDl4iule4XGzSjevEUM+fC4+Hr9cwHXg+beIU+dVUlPRbX3/FJocHy5cilv/AV16hfaKEToYESBMIaVPb+fr7tKnjoXTktNb2NA548e8csRrKJ9P0IhAPSg4D6p2Mu0BG86o6kCesWX5xsXtUHyCh86Ti+UcRNGTuvRgYexVK25eswjkIvAvl450bAbD4CK6/xJckeNWWqPgP0D5LKl5IYoKVT2rttrRcQAy88vkz3R+Qdp0a6Bu9IClJfMNUMyMHouT44lUTJ4V1xHDmtZAaX936h03tbcjvdfRIXM3FOHbwSjV369+8YPgHMTKyGDH8bZwlh38nEij/hKfLmN3fZjchMm1jnD5et8EMbmyj/760Jm3imx47t8gUH7grry62QWzxzP1QTVDXsXoaC6G4RbOP8pdlZt7n4fPxjbE/n50EkIwuz+umJdtZSLyYIoV2CuWvc+erZMi1Pje8AuShuI9zvCjUsCe9ssxiT3JmgBDZh96JFlf6zUEK4fjZB8zvvkhs8C5WH8Ce+GIvlD7lnwkfmuhIzu9BL4EAqmVVCLLZTamAmGo5ZxMxfecb7eBA2giYo4370FzVO1PqHBvEr+Ur0kItfqlDJtYedcdE7eecsHdVjb9iArCWabw0iLgseiuTdUX/lZQ0gBiwxwyiPUtsx3te/A4Ru0un7hcG5iqbQem2l0ox9bL+OetX0pYk7DSWlbatY3JtgQQem9U63L+hjQAShYY7HVkly3fzUhl8PlUEUj9bjI
 XIOlbH8G
 JY9za2YvkyCLr9SwA3CVU6bo3/74QBvE+EID8cBARhSL6uDvbYoDAIElXrHIuuMd9AUWcl50Sp4vjul3h461XZQIsrXqDkXTeikEFzVDkXASHXO+BwwyRjb+5A8+qqDKWjZlLQrhdQ/lT0ybrF2WGs7my0C49eVQJRf2KZOL9+xwsoA9SbWJUQmgNjqJSyGkOP5K/hZR6tD54NXgcdegFjNtoSoBYl6cSo8h727/AmCA096U5xUJfzTfFGw/uwveiRMQLAqO5Cwur2GMAa1JCJzL/RL49zuqh1zdIi6ewmck4Lg+qAExOCj08MkNqa7rxaBeJvKeb0N9FnXo2UzPueQKAQ/DWiQWMwfrHs697A9CiBo36GsnAy6JtJF/YA0ryog5aiBplNQGFFXguDW0ne1/ekVNXeRGSN1P1d16WGJO4kqrul8aNCswMgt16twGMWaQS/2aHrJsKTxT1hupVKKxzqf4JBj/xur22eqN8Yt7wPIz869zOBzVBKQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 31, 2025 at 12:24:10PM -0700, Andrew Morton wrote:
> On Sun, 31 Aug 2025 14:10:58 +0200 "Uladzislau Rezki (Sony)" <urezki@gmail.com> wrote:
> 
> > kasan_populate_vmalloc() and its helpers ignore the caller's gfp_mask
> > and always allocate memory using the hardcoded GFP_KERNEL flag. This
> > makes them inconsistent with vmalloc(), which was recently extended to
> > support GFP_NOFS and GFP_NOIO allocations.
> > 
> > Page table allocations performed during shadow population also ignore
> > the external gfp_mask. To preserve the intended semantics of GFP_NOFS
> > and GFP_NOIO, wrap the apply_to_page_range() calls into the appropriate
> > memalloc scope.
> > 
> > This patch:
> >  - Extends kasan_populate_vmalloc() and helpers to take gfp_mask;
> >  - Passes gfp_mask down to alloc_pages_bulk() and __get_free_page();
> >  - Enforces GFP_NOFS/NOIO semantics with memalloc_*_save()/restore()
> >    around apply_to_page_range();
> >  - Updates vmalloc.c and percpu allocator call sites accordingly.
> > 
> > To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> > Cc: <stable@vger.kernel.org>
> > Fixes: 451769ebb7e7 ("mm/vmalloc: alloc GFP_NO{FS,IO} for vmalloc")
> > Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> 
> Why cc:stable?
> 
> To justify this we'll need a description of the userspace visible
> effects of the bug please.  We should always provide this information
> when fixing something.  Or when adding something.  Basically, all the
> time ;)
> 
Yes, i am not aware about any report. I was thinking more about that
"mm/vmalloc: alloc GFP_NO{FS,IO} for vmalloc" was incomplete and thus
is a good candidate for stable.

We can drop it for the stable until there are some reports from people.
If there are :)

Thanks!

--
Uladzislau Rezki

