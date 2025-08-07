Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0634C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 11:58:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 499846B009D; Thu,  7 Aug 2025 07:58:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 423256B00CE; Thu,  7 Aug 2025 07:58:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C3866B00CF; Thu,  7 Aug 2025 07:58:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1668B6B009D
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 07:58:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9D4AB1165AC
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 11:58:25 +0000 (UTC)
X-FDA: 83749813770.15.706C298
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id C202BC000B
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 11:58:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VuaNyq4i;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754567903; a=rsa-sha256;
	cv=none;
	b=unjH1z4R1ypdK3rb3xe3t02YcSwUtFMFB/FpQV4YzY6jo1byVjh/QOqmGmf82zWysTO6qc
	CmKZQewmDCIHpovhcRasM6ycEwGUt7Z+nEHMYFTvvp/FVo+AyVGIx1puhkT0o3e2NdAWSY
	1r5Hz6qQ88/4qe65oJo5XK1I3e3faY0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VuaNyq4i;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754567903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oEwamW+fTRz5W2tukoAtJ50nny4AOmxMr4ZAI4xj6H0=;
	b=SV46c+3oB2GNYbTbEBJzXklN8SzBKte/DtsSUMs2jaNUXhtm3El9yaKicGLFJYHUzsLfVl
	oMsrbZ4OwoUOvqwJ94V6rAl6tbohTSIyMd61+L17b+aagGJvlGm4NCpRo0YFYcEYSoTV2u
	ta+JDUAzhxvB7q3ZvAHM23xDbcFk4BM=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-459ddf83023so5565665e9.0
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 04:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1754567902; x=1755172702; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oEwamW+fTRz5W2tukoAtJ50nny4AOmxMr4ZAI4xj6H0=;
        b=VuaNyq4iAtqlHg79Ks8jVSwzunYcU8fLRjaHyLP4ifR1p4KZCT3ySiVxztNhPRPfVy
         l5RR2CHgiQif2eAqBanRBGFa1KYiChEP5tKDiJ/+kG7EzJxOAwQokhdMNasO5jvSktu2
         Pxme3cryp45zEBijhgGJ2jr/kKfR9ckrFA3uWDbFd3VKXbSRDLDP8kBMKYIdOhHql0dv
         uizEzTOtwrgKtHRLCFSWIE/j9seoYasCLnzgiTnP+V4Aqr8rVGqceycCfUheHb37fQXa
         u2tqUsCQEqT6LfNKMFWoZlQQXwo1nNdWFwv54cehfAVr4aMUORWzE5PR37O4XJAuBVtq
         UBkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754567902; x=1755172702;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oEwamW+fTRz5W2tukoAtJ50nny4AOmxMr4ZAI4xj6H0=;
        b=ALTPLf1XNKIe5D6RjYJImueNSI+gepUxqYfMF4V4B5Wv3I9rtWNmCUCyNKppxD3j1z
         wInVtAwHHpwf0maURQdF8fh/vuObDrN48JsYG/E0fO/JtQSJJuyjHgwTuNSMlo6xMwWX
         ue/4MGcY/OnmSV3TAvdJE9tMG1uEX5Rho4PYL+feFMGlv52w2losJEhbiz+6rn5w67Ou
         giIoPrcS23kahlZyinqflEcoKSN4LHBQuA/1ELRRlTMy8v9cgZ32qolZVk4rqyL2iWt0
         xFptjtdpAMcnl5qagQRZx1My/uKKOTy1y+tlOgA18KFF5chYTucdiyoFdATdWJFtUFsG
         0Xmw==
X-Gm-Message-State: AOJu0YxYItqUC7hW7Os5DzpqbOVimTfNGaANqB93gXTZM3hBAw6CRb5o
	39iuDN2czo3IKMvMVZlPWkFZ40POhgwzjzurK5x3UxJrNXCqnPKyf2iYi3EmGp8R2IU=
X-Gm-Gg: ASbGnct0RlrjAwGAz7C40J4KSruq9rqBDrlruRB+EBayOkrC/WzWmY7AZ0nTnhjPXJT
	A3zzYhY6c+ohQBFlz9W2cGeSGhnJztwK6agIB5CGLRdTKyYX/XIv+K/3nOaTYY17YKNWCzmF8Fo
	lDwy42dZOLYOa2kIckVJT5Hw4p2V2b2+RRmT1bDmBnFmbFYQ21ZYcTD3mec/7aCjpl0mKzRKCAW
	UXYIyhOpJ0LoofUFcAFlHJqeFSvgLobro6eo1jTrJsvMRbolt3Y1V/nqI+cRmbLwY2sPWdrF9vQ
	ToUFd9q0JFAXiT9t/2NvvujRA8VFT38/gGdzVil+oEPorWNAlqFIv2i4o1oR6M2DqT4r6oQ/VuY
	iZ/M2nWTFF5aceoYCXk0AnS7FftXTaOofF7o=
X-Google-Smtp-Source: AGHT+IHkj6EB4TheQIsgXjPsOSdAMwVvBUUvVzBRTFz+9EO1TMkeOl6rO09TeVq1Dqf5kEBw9RNIMA==
X-Received: by 2002:a05:600c:4fc4:b0:456:161c:3d77 with SMTP id 5b1f17b1804b1-459e748faeemr70285315e9.16.1754567902154;
        Thu, 07 Aug 2025 04:58:22 -0700 (PDT)
Received: from localhost (109-81-80-221.rct.o2.cz. [109.81.80.221])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-459ebede65asm44807495e9.8.2025.08.07.04.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Aug 2025 04:58:21 -0700 (PDT)
Date: Thu, 7 Aug 2025 13:58:20 +0200
From: Michal Hocko <mhocko@suse.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/8] mm: Drop __GFP_DIRECT_RECLAIM flag if PF_MEMALLOC is
 set
Message-ID: <aJSU3O-pUnTnl_wP@tiehlicka>
References: <20250807075810.358714-1-urezki@gmail.com>
 <20250807075810.358714-9-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807075810.358714-9-urezki@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C202BC000B
X-Stat-Signature: b946oth3srbotubh7hsbigs41tfooi7n
X-Rspam-User: 
X-HE-Tag: 1754567903-110783
X-HE-Meta: U2FsdGVkX1/cf0LLOMl2QrRksElkHvMo4Ksyp+yfOA02+StAlcsTsojj0iINhE+KbXREmYt/9ud1vz0QPvn1AwIBpAv+apygm/Wk9xygqACWEvmR41vEhapiL0gfJ1ksNH3u28TWDzP2I7kgnuV8ZanH7QNBEPHtjfo70lqQT49uh7kxtbniKpFZwaFMCa7iPXfHjshsvJb/8ExMmcpomm8z8+V5UpBG0OcWiBSSiHy0UDVqecuWMvoOxzAI9SbVaxqPAmTx/WGHWY2A1izE2neVTzI512I3IvaAE7fXRsawaSYAHmdtIRRxKdyqApQIT5cC54KAaIQNKxCNNYZuCwOXq1OCDLq+Q3PovB1SvJNC9vDmCS8DcdaiNSe+cqZXBm0j4lWvcVy2sPGkw5mLGbCYJCUbDk3k3SgCjpckxTiu6DIh/8eVmnNYcFoKbt65o8aTdYTfnSq3wBx99HqSDW7yFja8K2UNxAAS6GePmQEdhdXcjHNLkxMhEwacryTmYFWejMp5cXM4mQUZHDqjAfMGSwz9uF7a/bqUJ8Nu0GqOReIYh+CRc2n4hzdmSjFGPGIDwi0CiHjUSVLkTgwEsQZT+6Cj8orZZK/JKR+52OCuM6Lt0hcyE/N//BA1VMXXpOD8cWkmEgRRfJ9RVdaW0o0+4p6qB6AhnqyEpCSnDU8c23oJR52ex/uabaWYFP4ApgbwmZ/tGplppUOx7w+UKFmvG2jZA4YBJx9GNuA441qs5ZxJyAXkkvji+yKvvOVzlacumpNfZum2A5af8A8HywReLcn5IW9RcYv0jd6FuxDN/UOjtgEnqvWbZwteJGnaCP2+YofzDoOsm+DsxNUXQ7GWhVApJjhNZFoFpcApTk6JZGOCVad0fDkrpo47iIXuWPlwCeyWYUEdfKtWavabDdK1NmyLdX1enc8xfk2bHl/25TyMy3HdHtkxxfMo0cp3ulcFBdp6WHEi2hzGd2+
 YZq40ttd
 OI/VWCrurHps5n6jeB6VtEvQRgO95ib8qVKh6EyRbJXuZSD3PIMF7M8ePpeuhZzq962f+tRdkl5aifEOgikupK26jNLbbh+oLh0eRrTJ30Vzau1956eA5EcCKJQVAlEdGVChx9iqa/YsFLL/aZOAQH+shIZnOGXZ9Suj2esJ+is6uGFJwQpUOZX4ce9OlEfGxI35sui+FPsqLS4nsObTaD+/QLlTN68OEdEgRTOXvihc8Tm9H5DDajrhESw7Gjc7jJgrpv9Z9e0JdIpbV/BrMEcMU0mBhcn91ydqXvhXG6re1hZsIO4gTkQWnTe0i05t8lcaVQSXuBticWGp9vTAfmA5TRkJ4GON7lMgd+D1emZUAw5M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 07-08-25 09:58:10, Uladzislau Rezki wrote:
> The memory allocator already avoids reclaim when PF_MEMALLOC is set.
> Clear __GFP_DIRECT_RECLAIM explicitly to suppress might_alloc() warnings
> to make more correct behavior.

Rather than chaning the gfp mask would it make more sense to update
might_alloc instead?

-- 
Michal Hocko
SUSE Labs

