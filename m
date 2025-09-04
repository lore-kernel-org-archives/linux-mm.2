Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4063CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 12:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17F578E000A; Thu,  4 Sep 2025 08:21:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 156338E0001; Thu,  4 Sep 2025 08:21:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0940F8E000A; Thu,  4 Sep 2025 08:21:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ED81E8E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 08:21:17 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9BDC41A0168
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:21:17 +0000 (UTC)
X-FDA: 83851477794.04.99A4925
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf10.hostedemail.com (Postfix) with ESMTP id B1CEAC0005
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:21:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bgV+ypl0;
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756988475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7KSwu43idPPiYLOiYSWlrLCZRiTpUunvv4fRRNFmcqs=;
	b=GE+khw3Exzt3dyxtXFkzE245NhjJnbhM4sjEibb9ZYJADvTfZbCHzg1P0aHALu/SV1qRd3
	ESYX7YJdGlSd2Ge/LGAmfcS43IDjjmYzNszuuIFWvkhmEfh5T6/js3Xy+gxA6x2/Upi5mT
	mUGnMo9hJ8eFe5kjlDUQR3Po+PzxJSA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bgV+ypl0;
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756988475; a=rsa-sha256;
	cv=none;
	b=3t+ZUnyKjgNB9lEyaGUBP4q3va0uZ3ChHe8P99Tbe53MJM6FSlYrhF6YVHvFg1RI/WT3Uk
	FNVm7g9LBDeKZywlq8HJe5WOCyI4mE1RdqX8iKGlwwGUqD30O3cJfqQrniGgnnhn/gqJUJ
	VkKxjlK3Il5NCEq7Mcq5ryOeqW9D4LA=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45b7c56a987so4600625e9.1
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 05:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756988474; x=1757593274; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7KSwu43idPPiYLOiYSWlrLCZRiTpUunvv4fRRNFmcqs=;
        b=bgV+ypl02muyHjW5ZpKhhwZb6sSTisSEnQ6sktLO9oo7sSjcGVUbW8DhClCprwI04V
         GY/UiOtJmmx8RCJNDLnf+2QBaA2Fzbab2CCUGEw6W6F40jSNgm1p7Q1gbMnH4vWfBCn6
         K+I6JNogRrZwfKAwKHA9qPl7E+sMEdvc6Y3GKVQESj5k22n9LuyYbcqg36jcRxstnlkQ
         ZrGS85txW33qfSQwSoTZDydx3u7u+IqS1UtbLIMxe1hxUPlpG2aEUQvsMQuJFzUxSQ5S
         AM9cjy4FUSlHt1jOG72zZVbV/eMsh7rVNtbvr+faW/MxZJ3mKK/k++MuNSVz24mrvdpF
         sPmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756988474; x=1757593274;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7KSwu43idPPiYLOiYSWlrLCZRiTpUunvv4fRRNFmcqs=;
        b=Bha4srLrde781lz5l5XLkD9vbSdAZVITuSieJrI+tF3Tu4DTLClHOLHuX+DDJqRrZn
         Q9rOv1RVxmGAHugoU1rz09CFLeuwxhw7LvK62j2fkejSefVZoqt6zuaoqCE0NRGMbC5a
         xl+83D0yBh2IutlnwChV1JA74EN1zCjf6nYIYrNuSLBfSMFW1b5yS/rP+gZIta7xJ7YN
         KxDCa4sRQFqQrGaviEYK1mxaDTSELWzvv9NctmIbTVrUWy/I2xbkO31fmmI5XGicMRN7
         TcPxMTgishUAH9m6tzqO2YSOZfEEMCIkxaceITU/7U/a7IPR2nClEhrtQfeDpYClR16a
         hk1g==
X-Forwarded-Encrypted: i=1; AJvYcCXBU/i206viZdmArw3a7tPkw9Oc/Nkujay5OhWcI18kaChdKYdW9ufLGbQUw81XCKyGfwxEw61h8g==@kvack.org
X-Gm-Message-State: AOJu0YxZw0zJknKt4dmuPpEt4xng/0bDyddMRATslqxVcKwPElmGQnZZ
	jNKnZOWiZYTgP4cwwtSvsUUsNOoAH6SqX3RorIhvh12BnseCpZPR5d8TlvbUyx+PMJo=
X-Gm-Gg: ASbGncsfevy+gnYOm4ysyvvbFT2f1LCLXreT0i/gpGIYcQHx95/vx/5SGkQwBE6qcHb
	V+fVqZDSAMRz8ofDu8rBDB3KOYqVaQGMr6B5NAiGr4K6Df0I5NK3lzFXzfza3mE9hXdyE1QUOaW
	I/CYrwKq726MPw6KZiX9AReh3MWkVRWTHRzf412EvGNJGZLqSnYvED79XOjQeLFdJLt0ZSxs4FS
	q8ZqLDTL/hAjA7NWuX49sXOzssZWNiGUtLN5rVno6bNZukAB7KnzQa1yGhpSW8ySD7QTofvyv7T
	aMIc/4vvRl1w3JnV/+IVS1/oT7HmIQ6ww8uMckGPEI6rqeZTdjCmHGV0DbXOvDXcepewOSiywC0
	uQ3DBR3xgtdXlbkBq/Q6X5JTfQk6xNylQGiJEZeLHKnk=
X-Google-Smtp-Source: AGHT+IEYqo4eMGN9vgrqjAEA3arfMvfky3hDi4FW+528nveIve9E3HgvQcvsr+KoLTBqDUriy20sxQ==
X-Received: by 2002:a05:600c:310b:b0:459:e3f8:92ec with SMTP id 5b1f17b1804b1-45b85532b05mr169657365e9.10.1756988474063;
        Thu, 04 Sep 2025 05:21:14 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b81a9e971sm295031615e9.18.2025.09.04.05.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 05:21:13 -0700 (PDT)
Date: Thu, 4 Sep 2025 14:21:08 +0200
From: Michal Hocko <mhocko@suse.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: zhongjinji <zhongjinji@honor.com>, rientjes@google.com,
	shakeel.butt@linux.dev, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, lorenzo.stoakes@oracle.com, surenb@google.com,
	liulu.liu@honor.com, feng.han@honor.com
Subject: Re: [PATCH v7 2/2] mm/oom_kill: The OOM reaper traverses the VMA
 maple tree in reverse order
Message-ID: <aLmENFH-g9MUQAsE@tiehlicka>
References: <20250903092729.10611-1-zhongjinji@honor.com>
 <20250903092729.10611-3-zhongjinji@honor.com>
 <aLg7ajpko2j1qV4h@tiehlicka>
 <7rvwvuifkav5oz4ftfuziq23wek2bn6ygvrfotpaweypuy7obv@hjuf3eknscii>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7rvwvuifkav5oz4ftfuziq23wek2bn6ygvrfotpaweypuy7obv@hjuf3eknscii>
X-Rspamd-Queue-Id: B1CEAC0005
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: fm9x3u5xndmmmtio3kqru647ki633uy5
X-HE-Tag: 1756988475-86843
X-HE-Meta: U2FsdGVkX188b8Id4PFalrVkYFl8AMEprbIlrYt7bPFIpk+c2Uc7G7VEAIiyknopw5CrW6a8Ws7H034wqPurdg+dBv+HIG1XvlBQhtPHloKBKXgeOfv4sGPyHkeGuXkvZHCzMfXpCT/eGDxSE5lUTHHHBWIa6HJTHMvDRwSjLeidZ/ovA137j6YTrttV8LZYum/EnZJqd0eUjdr1ZPS93M66wRHWEuytCBWeD+goW1ybFuQzmv75KQ0a6FF9WQSdEuIMbEaUMvlbbyVh7zuZnqe5vWegr/T5D2jiJlDrRqe3tIcmssAOGAqWybYJPE99Ne6sm/L3+8qWfuRhCSYJV+DbGo+o7ZHqFRlk8/Q5BYduWbLOX5xKWIRU7S7N0UtJqE8J58NUzS9Of0jQJAVmyP3yiidREoHbe8Bou70X33cPcOtYud7PQ/QBUgKe+J5Bx9fGLziq8laGSjzPGjYT9p0xdEbrqIcK+BIF41/mOLvVEqiki5ev2VszhHplTPSVoYnFHFFvEzTuqQZPtg8/p2v6vZJJFz6/YG2FIV3f0kW4D03wYlKBd/4cm/PdvO7ZOMI5ahu3K7rzdHxBeDIiq2vw51R+BvqrxV28eMqIUQCaIeuqMTe46XrGadKN/jUkAgDiIG3gbqgOzFyCgnfXGUw2ZFpa7yvLwzutOEoOUCPKyeYGGTWDM06EKb+olmFt6YJ6Az8Pigp8c2IB6JjygmcxuNNjDzkqqT4HMM+6eJY7UVmYXqdMbCfrVaa1484udlmziiiZyxBRL83M2oByGq8nKDbaIGEmUEJ3A14kIZ8zQoQhC8qt6itYy9y6miUkjjIsTi0ZBttie/dR5EHEFaBDLhR8BKyA7myt0IMqLTyhQoRf7YEvEXuuzlrACoKF17f5lqwHvFpD8skLnOS9nHOj5Rm5+8i8aGwqQQMvIw6oleIVBbPWRsnByp9Aio6qXxuZloGrOoswEocu8jI
 nDnNsCaB
 +CrjEjaCgo7cnBdIagtOtzW1NEkmVR0UEMw42p2N/I8Sca5MDixqsr+dDUmtnw9qcCju3shTC81+wCh3wGosto1xerg5VXKX2/3UXsj9oLHtqwpja0gVeIp6jSQkVGwekL6UCx3RK+9sauWaergfJeivjvVNNgdQ0FEmTYd1baY0P9uiIcRLrP/Bmjm0IPQQUsS8KZZ2Uk82IENIDnGOQelqQaM08xaErzaupRqcNaXhF3+iE8C2ru9qx+gvsqKg57cN2k9B7Ht6sNsW//jC2cYwpt9O8Ktpsji9wpOsqKDpS7FPYSnzCtlUNf5YWT09daCO2zZvOnBBn293FOMW2d09cF3cwYvyboLjydkw1BTPlXYPujM9aW0y7kmSGI43eo4+jDtQE7wlHEdgS2sjytmPlI9ljHi7CRZGxHCBwQQ+FY61UHIHi4Ave9rQJ/q8qF6l06aFXFfKfzDU4XoS6d77fNfDcAMaydih9BoFOjaOLQXDhLd/aA4Ral1NaBDO4iHU8FOchwOIlON5CgFqxFT8omuzZ0aAt5LSw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 03-09-25 15:02:34, Liam R. Howlett wrote:
> * Michal Hocko <mhocko@suse.com> [250903 08:58]:
> > On Wed 03-09-25 17:27:29, zhongjinji wrote:
[...]
> mmu_notifier_release(mm) is called early in the exit_mmap() path should
> cause the mmu notifiers to be non-blocking (according to the comment in
> v6.0 source of exit_mmap [1].

I am not sure I follow you here. How does this relate to the actual
direction of the address space freeing?

> > > Signed-off-by: zhongjinji <zhongjinji@honor.com>
> > 
> > Anyway, the change on its own makes sense to me
> > Acked-by: Michal Hocko <mhocko@suse.com>
> > 
> > Thanks for working on the changelog improvements.
> 
> [1]. https://elixir.bootlin.com/linux/v6.0.19/source/mm/mmap.c#L3089
> 
> ...
> 
> Thanks,
> Liam

-- 
Michal Hocko
SUSE Labs

