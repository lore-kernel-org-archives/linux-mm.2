Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D13F4CCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 07:24:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 148C88E00C3; Tue, 14 Oct 2025 03:24:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 120C68E0005; Tue, 14 Oct 2025 03:24:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05D9E8E00C3; Tue, 14 Oct 2025 03:24:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EA0588E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 03:24:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7595CC0782
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:24:21 +0000 (UTC)
X-FDA: 83995881522.13.F2BE196
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3CEF51C0013
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:24:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JqJbmKpN;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760426659; a=rsa-sha256;
	cv=none;
	b=XyLAk4yX5h5BuWw4d3Mep2vfPpVeDaIDITPgPro2zvVi64JW5rLQ10Krvov2llh4gcSsdN
	dlULGdZCc4764/40SpnRh0ESiyyXqWShgYCRu8iuVEUli4Oju32QYU81DCLSVmgrwxJuA4
	n4PmbOUyGmaVulPtOtzsVCg3kDKlXWE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JqJbmKpN;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760426659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DJsuSntfzmyGwBLDCIOK8zsxQdVVbjKkDRasCAUOBFU=;
	b=n1Fjn6ikOYqLfRG9goDgut5RhrIoTZlGcgyr70BIMOxsPc1zzY7dSWiRkXIVlDjSuyxPcj
	bZKYRp2esNxhPgGLDt6IgffohFY7S/afgxw2JdUCuz8lEFXYdUKumWOqh0HZItTs/E8Gp6
	Fzh8O3jjjMP9aiL7JGlDwJ5VFKAM7U0=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-46e2e6a708fso29731655e9.0
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 00:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760426658; x=1761031458; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DJsuSntfzmyGwBLDCIOK8zsxQdVVbjKkDRasCAUOBFU=;
        b=JqJbmKpNXedK0KCRTvb2T3IoNc2r5SLrX+w2juc4bFRg660GQqya4TjDA7mCwv8Mjl
         rz5SLwj/yENg2KbbNgB8hEgz5ZdvLnQB2HZs/QvVC1pIcfXsQqiV/1STNZ2QOHfr3Jf5
         VpSk2mg8pzBfF5QJ5O4lBcciPcduXt99rMp1xazilkd+eTINutQ3zNx4DOq5VL436xfQ
         oA3sr3pYH224avQUl7oL9YjinLm28GhtV08drgfbmyMR94t7AR2gQOp4STSBEwsB3Vls
         4PUWkXpxMCeUHDAmEc8+HuZ5YxJN5kO1AfPMJj+bGGO8jNo7v34BtTJuh3xw4aRprE5Z
         Su0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760426658; x=1761031458;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DJsuSntfzmyGwBLDCIOK8zsxQdVVbjKkDRasCAUOBFU=;
        b=CssVkBo/aTtvgLecS7SAD5yeD4MxFPPwnBDl2EIVm23VLD65miRJtCrS5WCCItbmPR
         2pZQWSpaGxORnq7+aLlAYODk47NWs2WoYHi1r7cDkfvt4q1IFamAB5wc82pToVfkAC41
         09gPeSKT+PlvGgJLu+7URO8FXI/wJE6FWKvjB91YBfgZQZTnj8SaHUlpotsBYc8mjn9R
         rPL31pyOnNoZubHO4Me57OdziZhw/xCttljx6/tHpuJj28YmBjvnEB26vY5NQ5c8sxkp
         Vx238MiCkctz3h9IEd21/utRwdoG6qBL/OdZSD6OAcEsZ0kKwi3hAhb4dfm15qY+NfxS
         z+1Q==
X-Forwarded-Encrypted: i=1; AJvYcCULMB25r87ZOl6eSoOllfDGLuf3FINX3IdrqCaoCgH6GtwRInFZ1+ndhpGJAVjIm6ulSrFoACo2cw==@kvack.org
X-Gm-Message-State: AOJu0Yy1kdYmWloXCLAZJZ2shgXbSkMFmQjz4Rd74Z4wiwGEp66eWbaU
	V4Y5FoYrgJU2MJSoEzivKfs3eWr1wfhwAvjEm99s8OaFokKC0A2plsuCpJTzsiXMcZw=
X-Gm-Gg: ASbGnctobYvXM9HZEAXoLeep1yA8AQLhsnDq8Mo33F3FUfqvDyHZGrQDrQrNlLvgbDz
	t+iLYuTH2nV3gN6/jLzjzSuUWh57GGBKRFgHAvKhP+3+HfVos5q9RnWQonUsJdL/soaf1eSHXVb
	spdhFBKkjXyvQPit7QHK1pgNpK2Xvw2mfregVXoJaRLlgbYq8oL8j/Vx1BTJnsrFKm0JePwRRgA
	L3y3W/jiOlRWJLr1l5fGRqqEzt6yERkx70LCyLFgzwcL5ToC+Ng2Yn6LQSYFFsPrrwBJ/0gfViU
	OQNKxzDTP7WS46Cr1XJQeat43xjkb1PVs4+ewTl0L99AjW/UH5EtFuZqCLieAmyXQruowpSGvyu
	jZfzSACaftALTX6Mk2SFAxLta1oUoR5Y0y9cUur7inETSo75hFz9e1vK7LYBeoAo=
X-Google-Smtp-Source: AGHT+IFRg4GPmLD9q+m6Z1pGRfggv0OTz6EOdiAPNLgTJQcEwNtxGs3WA3GtVkRT34c+YV2Jq9/wAw==
X-Received: by 2002:a05:600c:8b24:b0:46f:b42e:edce with SMTP id 5b1f17b1804b1-46fb42eee44mr106715865e9.39.1760426657567;
        Tue, 14 Oct 2025 00:24:17 -0700 (PDT)
Received: from localhost (109-81-16-57.rct.o2.cz. [109.81.16.57])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-46fb492e6ddsm250256765e9.0.2025.10.14.00.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 00:24:17 -0700 (PDT)
Date: Tue, 14 Oct 2025 09:24:16 +0200
From: Michal Hocko <mhocko@suse.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, Barry Song <21cnbao@gmail.com>,
	netdev@vger.kernel.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Barry Song <v-songbaohua@oppo.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Yunsheng Lin <linyunsheng@huawei.com>,
	Huacai Zhou <zhouhuacai@oppo.com>,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network
 buffer allocation
Message-ID: <aO36oKRR3UliRFR5@tiehlicka>
References: <20251013101636.69220-1-21cnbao@gmail.com>
 <927bcdf7-1283-4ddd-bd5e-d2e399b26f7d@suse.cz>
 <877bwyxvvl.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877bwyxvvl.fsf@linux.dev>
X-Stat-Signature: kpe6xwebzarinat61uzibagxpjxtbjuo
X-Rspamd-Queue-Id: 3CEF51C0013
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760426659-6623
X-HE-Meta: U2FsdGVkX190oj++iwA97xbf7ihExgXGmFdLKZQ+DSrNLoZ8eZmK1XV6Aibwg1Clm/f0eYMEXvxIO+3N97194VB21JL69ujujNQc49KswUOlCNmA9UNg1caoegUXBklrtDTZi2pTA/lAH3mNh4/k9C3DPsSTY89AQnq/AloIMJZfMiQwCTOm2Mbn0NJE3HZvCgll+jGE0pDQwaKALphws66vmpzLMn85elVjjbuncXxIs8AmuxHgBfEapBTvTunXFhxCT5tqXaVXeooA9hmhfeKNjpcJM9LChqs85hVUr59BmZC226yC1G++Pu0yaQ8pt3MrpEomtkRpbaXG8Q7AFqnqJT39O0ULaJBuqnyH3pVVkdvTD6dqmIoa9HYPIzXbbUful/5+5SC5US7oB/wCeOvNF/F4tMXRZzxZtQfngfWN9ttZJa/foveIS5pP8NDo3dQDO+0ae06ZYnFGVwiYHDxEvNivQlwPBfBWtirxIcFpj15eYx/TFe5TDao54/B/UflMz4IIaXQ55tQNjN7CheN07SUd1NNcGKsRVIwR+Dyn3ZfDsZTKZJBEVtFJDtwOFeZPMlkdwTSx1hKAVeLOo4lC/k7WT0qR+jHAzGRxyN0Q+Rz5dOIY0rUaTf2kzRu+qJiTXVNMiS3iLNeQYZM8LkcoI66+L00hsnVwdC+0fjXb7Z+rAtFOIUFu9lyD4hRRwyOW9Qse7ZpWFuqX4ARb9wmAEspzG2MAVgI5QzzkgQZ+ubmgBIDJYhk4KqOZQCbcFdp64ffHi/gsLeWoYJ9kZC9WOfAcD+N8TZvK4qeZDe68H68nJzm/Rf/Smkd9dvx7pDo3i9BeFJnrJf2NMRGf3jkgzCa91uJX1zBdsQdHmsgWF9t8QxrBIctAgzhFqrXdbg6mOCs4K/9skpgKdwEEv40UAS95rmo+hoQ7xuXYVYRRJVU3ePG0fK7E5xnwUc+C5MrO2qeZEKYYudeMlL6
 /lrPE64l
 MMKFr+XZor7OUuKaYApyNlgabh5T83Mc7FIy7Kfw48ock+/vz8wpw4Ni+tuyofy/thMuP/ij861wtyyEmql9J9sXrZJvekBHEOi4rSuL8fH9KQHXHBcvC4phlqGcnYaO1hDiOQpKMn7wUjoRyvpphtJIeCu51kZ6TrKl6KU127AyHEsLpaaVlhcZaHkDsjvjJeTnP080jjuXitgoaoPdtaGOx8VXkAp+zriZebKKdK/YZ8Lj6cswktjL+daUKADMeRLGm7LNOroA6CVN5ml5RSp/2HOek8idMJY57mth3jows8ngl0+zTz7esmoqeR/ImXfO6G7YDAJrgECbqt048yHepJPdYL0jLRp4eyqTLNSSqJIjwuVfsJFVkp6EX067fNTXNYvB5fCcQSTw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 13-10-25 15:46:54, Roman Gushchin wrote:
> Vlastimil Babka <vbabka@suse.cz> writes:
> 
> > On 10/13/25 12:16, Barry Song wrote:
[...]
> >> An alternative approach is to disable kswapd for these frequent
> >> allocations and provide best-effort order-3 service for both TX and RX paths,
> >> while removing the sysctl entirely.
> 
> I'm not sure this is the right path long-term. There are significant
> benefits associated with using larger pages, so making the kernel fall
> back to order-0 pages easier and sooner feels wrong, tbh. Without kswapd
> trying to defragment memory, the only other option is to force tasks
> into the direct compaction and it's known to be problematic.
> 
> I wonder if instead we should look into optimizing kswapd to be less
> power-hungry?

Exactly. If your specific needs prefer low power consumption to higher
order pages availability then we should have more flixible way to say
that than a hardcoded allocation mode. We should be able to tell
kswapd/kcompactd how much to try for those allocations.
-- 
Michal Hocko
SUSE Labs

