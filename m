Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43A77D15DAD
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 18:19:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 783C86B000C; Wed,  3 Dec 2025 13:19:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 734146B0029; Wed,  3 Dec 2025 13:19:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6231D6B002A; Wed,  3 Dec 2025 13:19:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D6966B000C
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 13:19:43 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EE15D12E4C
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 18:19:42 +0000 (UTC)
X-FDA: 84178973004.28.EB76DC5
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf16.hostedemail.com (Postfix) with ESMTP id D904E180009
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 18:19:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=boxBGf6c;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764785981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cvxsSNOGWdrE9akcNg/jRgoHeSCakoDs4XiZtxVygNw=;
	b=aE9w1e93+ct831H9/HPQMMaW4OTMeGJtfQhCzqKmGWH2SAQgINLndZU/G/LKFE+HANTo4i
	NgcbdQ9Az5Qs4/i5XUZexNZRGmUZLg5uEehFQyjGTRjt80hjSHVHYWE3xNfYuwLQnhcBKA
	2XfJq+s84dd5gAH7jiis7oP21wnWOkg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=boxBGf6c;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764785981; a=rsa-sha256;
	cv=none;
	b=M6JNF4LLRZFwvSzJ0Ch7STZff+ZGdiXSJiDZVOh1k3k9YPHLIs84vVAvDEin8Hrcm3gxQ9
	n9SPHN+jUx2AkFktoATvl9irHeuUqKjGlBmonmBF3Pk5IzWhIuQMSwKF4+hLRvnJAypqQg
	mVSgjywjfpfOPij/RtbeDaS9vx7K7ec=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8b2f0f9e4cbso9974785a.0
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 10:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1764785980; x=1765390780; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cvxsSNOGWdrE9akcNg/jRgoHeSCakoDs4XiZtxVygNw=;
        b=boxBGf6c9bYS0l8eQrGmpySbaUyPIAHBomRqvfk5PaOcUSC/FhOKbf1+S8Hk7DN7WS
         uUxY8Hsd5lYYh3NT/RI4OYItmddoRx6hyp+YepWB+K2MxvdqgGNoygHOE62GBm8htb0P
         PAPP530Xmrpl6jMIfZCGAWeipS67IvrI8gVaaRFHcx5Qc0S/eokT+yM5jrDvkyp9FLsh
         zkdiKyONB3scPyPQAeoXTsHuz8ZfhIbYVLttX9Mt7bptXptpBAEFlh+NtsyMHJ9gP6Hh
         kk7wne/Obi35LlDUHMAfQi2KNohtcoCKL+Ure+06BgApJ7UJ7Ngjy+RGuDcxyKbM2U2w
         ia3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764785980; x=1765390780;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cvxsSNOGWdrE9akcNg/jRgoHeSCakoDs4XiZtxVygNw=;
        b=rThaMmNNPByt3XC3shTKACdELgWas1fV/wNCFy5CXW6I5RwnwcrZjkMTbHXy+H2OOW
         qo9ar/gTZ59qaLElkCSwhTu+DpiedlSfoAPQt/FYH7xHv0CCg/sSsGmQJC4JE/wVfITN
         BuQ73zxblI8O3+k7F79/uP7NXtVsxro+vi/1LS1gOjQ3sEDaPdFajqHIuAY2phNhA2Eu
         3jptboIdUjWF8e2LPPboFHQWJtQrI7B/m3t+TyHnveOJcnOjNDEXeRo3eZsHtOTAS7VI
         dS7A5Wjbits5hTOwOwGp86nu1wAgq7nbX/lrSO/Ez7tL/JZhMpqDKQaoOngB6cWijH+w
         Up6w==
X-Gm-Message-State: AOJu0Yx9jS7h4xZutA5RnLGiSJ0nUWjZ6B11karhRfhWp/oc5B8YaOA9
	VLmFW3Moob6Po3se1Zau+oGGZdExMBEr+GkaTOgBbEm45eIp3IE8dJnok10SMF7kSOk=
X-Gm-Gg: ASbGncvyHaEWPk7goKk9j3M9nYF1uKcklzxbCxrvu8SAqoKWxocXPsNlqGCczw36kpS
	WHeyEKgIB49M+h4NlCS+NM98ghI6QkIOBbfTNiUYVXEw/2Fm5mizDbGqq/QiFzs57JHyd8dyEel
	eEJaGMaG06PAdCm7Ed/p3ZNwW2V5/O1lLMPXjlysWcYCvxTR0uVFPhHA03xcGFG/pka3soKjPLz
	9xRphR8X9vgXvXh2VsAemTOxPk75/hoQ6UUGUp5SovCZXAAqQWDf12T1sPI9JiBcC9RokFgTeFO
	JzZHP5MfQUZbQfvajGEZF7K3kUUw4vpui0Nk9mYDk0iFe8KUTWeFnVBLLmmxImxCwFAtJxL/odn
	h6oyt0WZieReviPI6CeT7lVi5R+xdDN18c8FW/iCuAuVcuf+81wUegQYiKgn4zGYMDPU+Lnk7cp
	lYnJzaxJteSw==
X-Google-Smtp-Source: AGHT+IExlNX5MNBC3OYudvJIv4VEFspzEKTWEJsupXZUlcjDYuuJpB+YCUht9jfc5WZuK1q3vHl8NA==
X-Received: by 2002:a05:620a:c4e:b0:8b2:ed3b:e642 with SMTP id af79cd13be357-8b615f82cbcmr63003185a.34.1764785979729;
        Wed, 03 Dec 2025 10:19:39 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b5299a5377sm1334780185a.14.2025.12.03.10.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 10:19:39 -0800 (PST)
Date: Wed, 3 Dec 2025 13:19:34 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, kernel-team@meta.com, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
	kas@kernel.org, dave.hansen@linux.intel.com,
	rick.p.edgecombe@intel.com, muchun.song@linux.dev,
	osalvador@suse.de, david@redhat.com, x86@kernel.org,
	linux-coco@lists.linux.dev, kvm@vger.kernel.org,
	Wei Yang <richard.weiyang@gmail.com>,
	David Rientjes <rientjes@google.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: [PATCH v4] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Message-ID: <20251203181934.GB478168@cmpxchg.org>
References: <20251203063004.185182-1-gourry@gourry.net>
 <20251203173209.GA478168@cmpxchg.org>
 <aTB5CJ0oFfPjavGx@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTB5CJ0oFfPjavGx@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D904E180009
X-Stat-Signature: 54op386wtp459h4mpe3tiwmbm6ugh5oq
X-Rspam-User: 
X-HE-Tag: 1764785980-875125
X-HE-Meta: U2FsdGVkX1/GDbP1gi36JDcyB/EBqtxkUNo1BEOkkXwpmCelMWuWuulozL1LWD4kqOLXMS+uYP7EqikT5IvwGyCJPUC5aTD/92fNeaZBjJI1gSnPCfNwoyUmsxgQnrondE6TtEGjEFdoBCWxVt/GZlDt92pldWhCTdueBNw5lj7i8DmLAcVsL/M6TgzaODsroQHjhSYY13NFDLr/S+cKeeZZs2+8cXkQrFlmh5sKrB5ghXKE+n9TzeF8o1yCgY8XSriIVp2IVlTIjKKVzW7Hp/wWLr/k/kSacCe/xurX9aw1ina4WK3AMX855sRcuTh82cD8fPB2Kn6LXgBQAQO3N87giJacmmW4ujrTQr4EgxfVmOahnux/7UY5+QGfYxb5KNZIs15Lc/Q36H+mVac7jyCMmDOiYxFQWhLgzwf5Lg0zsJIqVVC4wXY0VXD8OpcFdUj8LE9KyHdX7fp8424inbdLUrvARE+bzkb1F0YEVgyllcTQhZbGIUOFH3aGx9aTtDCrwu63uJ46rUbkPfhgZFzYI12RIl16leCuVpCRWnJxM6Krvr4Q5mUKFk7d71WU9qonvz6pasHIHzcYRFXwYV1FwedgwlzsK7bMnc+OIn/8cbME1A7j4YpvXet0Rmu0M4YdmrMw6ZbnSDrDkIyPxFfCZkkOXnCvR0PPdr7Kp2TF2GPCIhYmlY43YVB/fLOJmLlwAi9+Ws069Ov++UBO1Nh/emnicOXWxOAHM1JibkTp702UN6NENjmMBimrNj0LOGe3+LTA3Ye1Efl4NGYfvQTphKhIWuJrPu9iP1YrR5us6UBPf0uup7UQL3WI6856K6HU4aLSYiaSg0VHssPMoszKAREBwllwhWEs4TEpLOmx0CNDvGd6LCib2CtisZOi6F+Bz0WTh111Qotqc/D1y9TfuIHrmaHQ8J1TY18Notrl/3qXij7PNowGu2em2h5zzPx0HYTqNcMacO9YLRn
 gayCf78j
 qk6N8cjhECtrsfXyVplmkqtGbPDqMsEPFe9PkhXKSCbmLWvA+THTqhf5pvM3pp3qXspLW1AmPa/eKcrLLEkjoVyCPzN+FFuqgkktusmyRaTkUxWDdq5VBgvmuK3lF17sFGuXAsxxSVoLR1eCJvbhCP2+FBCO/PyWWMKVdzDdA6jroNoXLiB6bh+A2FfON6LHUbYQotZp7k8weE4N7CHdmhhn9E0lmo8bBH4U0tRYGOk1u9IXUUxXhsL6lYOVTHwOTbCwXArQLF2N1gFCMj6LEhPe4nzkVXPNpV8y35cP8SWgkua5ZpnZYBbml5/4/ttvVBEJW0XZ01EhTdW75LgWFwpXqE0JC9pWS11uNcgjlnVz9SvX5M4uA3Vyd9E3kqBMkHNhpK20nz6GWZ5LwblhzIjZjSv7L2Z25ORURL4fWCLNiy6CxY9AsjrKd5F+fxplV0y3QNh7fQ2D+61otheKAy0AXBd9q5KaAoxOEFl9YAhpXcrcBL8Ypxdfh40MpKiRD+7yqb8BfCYwpRuIGUjYeN+08kw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 12:53:12PM -0500, Gregory Price wrote:
> On Wed, Dec 03, 2025 at 12:32:09PM -0500, Johannes Weiner wrote:
> > The reason I'm bringing this up is because this function overall looks
> > kind of unnecessary. Page isolation checks all of these conditions
> > already, and arbitrates huge pages on hugepage_migration_supported() -
> > which seems to be the semantics you also desire here.
> > 
> > Would it make sense to just remove pfn_range_valid_contig()?
> 
> This seems like a pretty clear optimization that was added at some point
> to prevent incurring the cost of starting to isolate 512MB of pages and
> then having to go undo it because it ran into a single huge page.
> 
>         for_each_zone_zonelist_nodemask(zone, z, zonelist,
>                                         gfp_zone(gfp_mask), nodemask) {
> 
>                 spin_lock_irqsave(&zone->lock, flags);
>                 pfn = ALIGN(zone->zone_start_pfn, nr_pages);
>                 while (zone_spans_last_pfn(zone, pfn, nr_pages)) {
>                         if (pfn_range_valid_contig(zone, pfn, nr_pages)) {
> 
>                                 spin_unlock_irqrestore(&zone->lock, flags);
>                                 ret = __alloc_contig_pages(pfn, nr_pages,
>                                                         gfp_mask);
>                                 spin_lock_irqsave(&zone->lock, flags);
> 
>                         }
>                         pfn += nr_pages;
>                 }
>                 spin_unlock_irqrestore(&zone->lock, flags);
>         }
> 
> and then
> 
> __alloc_contig_pages
> 	ret = start_isolate_page_range(start, end, mode);
> 
> This is called without pre-checking the range for unmovable pages.
> 
> Seems dangerous to remove without significant data.

Fair enough. It just caught my eye that the page allocator is running
all the same checks as page isolation itself.

I agree that a quick up front check is useful before updating hundreds
of page blocks, then failing and unrolling on the last one. Arguably
that should just be part of the isolation code, though, not a random
callsite. But that move is better done in a separate patch.

