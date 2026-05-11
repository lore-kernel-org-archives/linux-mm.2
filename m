Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF079CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 13:00:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F0966B00AA; Mon, 11 May 2026 09:00:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A1AC6B00AC; Mon, 11 May 2026 09:00:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F210D6B00AD; Mon, 11 May 2026 09:00:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E4B1F6B00AA
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:00:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F2EEA070C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:00:19 +0000 (UTC)
X-FDA: 84755147358.14.3AA9BAE
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf21.hostedemail.com (Postfix) with ESMTP id 321621C0022
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:00:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=PTWSLbEt;
	spf=pass (imf21.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778504417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4+cQok72EendiQ4RsZOuA4dvDrR9/HbVMIOnFjvkKag=;
	b=H5rw2Rl/AZRscFTHpMuH0xTI7JGNuDdt+blZ2jWlg63ltizwkL5jle4xjIcV+RSmxbRxt7
	j9W76egFGHh9aI/H9cyPxm0RA+XwXS8tKgomQtEXcISsGxUOY2rqENke0K0JYY4Wgol038
	Nzxei59+NDgdWUyiLG/OoCJrd6ZDBc4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778504417; a=rsa-sha256;
	cv=none;
	b=sJRRkQhEMVS3FriuPBpHTDQldbC3IL6xQ2FtZZlmDBWfbp0YKXclGcqwmBhmlAblbgY2Yi
	HSv+WFta8FjXBrZ9dwynt0A8CEX088F6wWNEdZ4dBRr5mCVly5LhPvStlXt7zygD3xOuXt
	Xyex6pj55NlSAcU3gUckmKQjXWn978w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=PTWSLbEt;
	spf=pass (imf21.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-48984d29fe3so46135585e9.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 06:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778504415; x=1779109215; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4+cQok72EendiQ4RsZOuA4dvDrR9/HbVMIOnFjvkKag=;
        b=PTWSLbEtFbaQJOMhVhbwKWCjfCVVSfCvzp9c1njUYmLtq9Bf1LP9oRV+cl0tPD2NoE
         0mA1tu12TkF0L2z9R61d3a0qDqa3KjRF664mfmUyRabhVj40TawKE/FMM2cRt+YWx3a5
         Z9J9CFaa1jj6x4masTJ6HJZerOjPXkw3+6YWwCGDJSqPATQA7En3tA46Iw8QJ5/JBLto
         88MwWTFwj9xE9Yfpm8NKj0vaQp0qf1X8JWzigEyR565yeETFllzIvtLyX76lcZL8d6qC
         W6Ixqonr4TRJliaBlkv5lfVx72BoHe85y7C+rO2SuBR4iMhQ62nu/efx2ZGWkv+b8QJG
         OaRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778504415; x=1779109215;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4+cQok72EendiQ4RsZOuA4dvDrR9/HbVMIOnFjvkKag=;
        b=OCU1GjWji3tr/K9zu7/jEFyPoUqHsDnGmxGpKtrsNvtOr3TR63B85J6aeFc/D3L06j
         WQQ3kDhBGODpegTz7/FH58moriTAo04phNAXrc3HMCc5p4Zy4hYg7qmu5mxddR9k7c0m
         hwhxSomR19Tb3de6+L+BtoBebbSswsg7I0gEk1kIMpVkNzBBGtQE+MnUhyJxJp7WhC8a
         Jmq39W44Nn1mkXgYsnhK7TfkGx3sur9+OJcBog4KpE+uQHWPNPBBiCz/LKBZi/U/0LdV
         DKKLuNupHKsQ7VuL1I2m2IkUouZILh3kBAKZ78vKZZ7+8RBfny5WEQmxzTFf7nccaxQK
         fI3w==
X-Forwarded-Encrypted: i=1; AFNElJ9ii3EQo8AnooroPkcMVjbcH90x1YS0MPN82CBeYADLFlfjGaXRARSQzb1kSrj8e/fYm/NDFLnqrg==@kvack.org
X-Gm-Message-State: AOJu0Yy/yZ8FfbnOyxENqoxgpwMy12V8lHfT5lD0kqvEpDFcVEEtHhSx
	uNyt7rM2S4Av14LHZGJU1NWmfszM5OQSd173xr3YmGaa3sGvxaGzHJZX/meYys049Uw=
X-Gm-Gg: Acq92OHjls/nN0wLubNd9uq7rAgbXmdwneG0XtPFLBdL4Z7YRnAjRlTFsFU3nv7jvH5
	7Q5hdObV0InzgMxoG0D1inNhbCE3eTKdQGsoIj50gpQ9UBmf8vhuaBfJuMDHXNd3ofu6qVyOb3s
	GETDwZl5u8zUaXakG21x331csHJAxyiSH6s5z09mYIuJXHzAa6FG7d9V79FrwyzhL1+Rr/M3RVJ
	VYq6/YZSV6tM37RPSg6YqmAHKf/cjUw0ZPEbIsymhgddN3zRv1DBsmfAc93LWXjvDpnk5kWSAB/
	gEvm/YS5MHubzc9LohGO43IjWIOZJQEiV4YREceFuOFCXOs19klDsbrnKTFHITqLvKFumV5TqUp
	MEWs3N67gt4rmRCXoRtFKuDRtr4HY+u6u0ud9gkXRkOBHvPSsPrB+fXbq+gxjI3EaOlbG3XVick
	7c9PS4FHhv8Q8GA9u3PWc5zXtKEJ4uabU3Gl5s
X-Received: by 2002:a05:600c:34cd:b0:48e:707f:cdfd with SMTP id 5b1f17b1804b1-48e707fce07mr163903985e9.2.1778504413543;
        Mon, 11 May 2026 06:00:13 -0700 (PDT)
Received: from localhost (109-81-87-110.rct.o2.cz. [109.81.87.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e6db01122sm87807305e9.6.2026.05.11.06.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 06:00:13 -0700 (PDT)
Date: Mon, 11 May 2026 15:00:11 +0200
From: Michal Hocko <mhocko@suse.com>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	zihan zhou <15645113830zzh@gmail.com>,
	yaowenchao <yaowenchao@jd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: Fix zone reserve update serialization
Message-ID: <agHS2xXSgW4YxJF2@tiehlicka>
References: <agHMhEBAz9sol3TP@tiehlicka>
 <53EC8695-885F-4C47-A9E9-89CCF963F0F3@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53EC8695-885F-4C47-A9E9-89CCF963F0F3@linux.dev>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 321621C0022
X-Stat-Signature: 9bijqt74fop4piupf4hbc893oxrjdn6w
X-Rspam-User: 
X-HE-Tag: 1778504416-295439
X-HE-Meta: U2FsdGVkX18KZ6k5yTuMu81gvXaNZ1LUBTURqw1MaK4RMWhvGgfA45TBHgxUlOOWT1F6RKJ7vL14D04Mn7CmDfZeFtDr7GPHaYFRUSzGuV1Q49rK33oGXsh7sCEC9xyDHtx/u8QiNLTthGtj5iLw0CZ4g/LB/bV8SrRFWaSo+lw/1g41/l7rcMi7t8CgTvJCUTt1CJPGiCzGQBLa8w5m3pWTvSWBW+py2H5UBG2brq0Sbev4vkR1aQqUFyvwSbS1l5FhWH4YDgSwnzs9Td5t+S8aFNUPEvH69QMn9uoRtuwaJdr3/osLcimh6rTKOAxCJo2viPXGCxynFAcPD4Jx07M6AU+IsnCaCKVQMS0n3JBA5NRyCfcr2K6kRxbGyv36o93l/HvTc95UelqCzHpwCuF77PkckwRyESAu18hymd++AyGtkOcgiycZZjv9AGWiI2WGoJxmf6J+a9VIGWYsiMz7FabNGcDyjwO79AUydUbwgTGU8UbCSwoSZSIQVSlc3JVdJRxfemzAzMz8VRL4m95X+By0mp2TuHrC5ITTJXH8x0XGPg9BtlC16JOlqiLAsbeR2tXMUEVam2RKWEtt/NNm7TiX8awdKT+sGRcTB4E1lq8kxy+JoYvJv+q3AFcORWVWMh7dG8SF+k4P1jRkCchrC3HF9akRszygCIN0UTfgCaLb5+NWslmIRvrGm9GEEjZWxU4rlr6nRO5V1Ap3lepV3FHt9hrIzki0v8r33en2f33xz8gcTCy4j2Yt9PzTIhbsW/VOpEHej7PA3sdpjt3V+kg1rn+ObQ2ZO47/bQqTYGGzaUwVSGh8nhw8LxV2dl7w2UmBpCt5RKAgUtEpNY4098r6uKyWEGJkZpcZRWILPcX4J0bqvY/FX15CRoxyCdIpTmWXlqv17iNz2qHAsMBR88oFKtjxnycHZzPY6w7gTPonrKzvqFrn2DyzOTnMV8y4XRKB2MVMCzVOEzY
 HPbY9r/a
 xoogW9qILO4rbZSLdKv2T32ynyovUaSumHsTxw+P6Fc8CM02pvQF4dx3070OpKUeNGMj/b4ooNZF8TKg7gvGtsJszCf3okm7xzDaRYDVFti5vGAhXpCeWaCXvPwL+aE//yZX0SrVcjLrLsYBCFFJCXG68IoUVbEv6bhnSvScL4lSwBHoB9rPs0odWgs3VXk56STrZ8Ck3xtDAC7CYXY573a9o53WuWEs+JGeWVR4ANby+mSECW15m5O4LMZ2kn0RfDu/TApwQMEJb4XT9EZs71AmN/Daq77j9zfEEYLLZLhyky+A7/rOuBkTFePM01ADi8jMu+69RoBakf7aCqBIGKLowCe6dvJsi3npqita8HPnqJ8PwQWvD1qpYFoOiuzP1KoGfttARgwIDm/lpk0B4WgthVfx+aQmfJovCmX7a82XMz1DEJhzdnsUxzE8pffYbgpm+iCQJJCASr+mq2z5FzbaJsObORhxPqASN0JEftR/phb28EeQrk9qTZnQbJBYWgLrSh7fvf5OXdmkjap1+jNkLSiR6aZ6yNYY2TMHYWUNYq8/3YIbU9wMMkiDbjNp1HxDH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 11-05-26 20:53:56, Muchun Song wrote:
> 
> 
> > On May 11, 2026, at 20:33, Michal Hocko <mhocko@suse.com> wrote:
> > 
> > ﻿On Mon 11-05-26 20:04:09, Muchun Song wrote:
> >> Serialize lowmem reserve and watermark updates with the same lock so
> >> calculate_totalreserve_pages() cannot observe partially updated zone
> >> reserve state.
> > 
> > Could you describe the problem you are facing?
> 
> To be more precise, commit 9726891fe753 moved 
> the call to setup_per_zone_lowmem_reserve into 
> adjust_managed_page_count. Since adjust_managed_page_count
> can be executed concurrently across multiple CPUs 
> (especially during memory hotplug or parallel initialization),
> I am concerned that this might lead to inconsistent updates for
> the following counters:
> 
>     zone->lowmem_reserve
>     pgdat->totalreserve_pages
>     The global totalreserve_pages
> 
> If these updates are not atomic or properly synchronized,
> the resulting values could be inaccurate. This inconsistency
> might cause issues for other kernel subsystems that rely on
> these reserve counts for memory allocation and reclamation
> decisions.
> 
> Just to clarify, I noticed this potential issue while reviewing
> the source code; it is not a bug I have encountered in a production
> environment yet.

This is important part that should be part of the changelog. Theoretical
issue observed when reading the code.
While it is really trivial to see that there is a race condition. It is
much less obvious whether the race condition actually matters and worth
fixing by introducing a new lock. So this needs much more explanation.
I am not against the patch but the changelog is quite underdocumented.

-- 
Michal Hocko
SUSE Labs

