Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41427FCB61B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 15:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7CBC6B0098; Fri,  6 Mar 2026 10:52:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5AF76B0099; Fri,  6 Mar 2026 10:52:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9835E6B009B; Fri,  6 Mar 2026 10:52:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 87FA06B0098
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:52:52 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3DD781C8C7
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:52:52 +0000 (UTC)
X-FDA: 84516081384.15.7AD2A28
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf23.hostedemail.com (Postfix) with ESMTP id 43A13140008
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:52:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OEWdCL99;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772812370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gmR7x9X/+WhBljqVLIwDH2yaruypUaKc2mU2QgggGQw=;
	b=4LAHJgpq1lIMmdhdZe5JkfLbqMswl2r8/H4QasicMp4CwLwhzxo0PLMVL85oJO5kcIHrdf
	gqIX5DMIomVQCH7QHSlUK1c/oKfaqEsYpN4xuZ0QjQt7T3fgb5CPyUjGH3nzaHYoyAnRfQ
	9mTuHR0SAzGd3cXU4rivOrAzHABy3kQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772812370; a=rsa-sha256;
	cv=none;
	b=slt6pZjbu4lHR+1ls2/Acm8XQgPS1XIxiQH/+UQtwHwk6ijZeKSwNM0XzimmB7x3rdWDRs
	jYYZqKte+uVsu+qEs3IrRggaiCoVFC4AQ+ygzFMq4hOD4lzReM4l5cY91W4GuN5D8rjSGx
	TSbqbhRwp2b07qd1zAbkNbtxeLLn+w4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OEWdCL99;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-483703e4b08so91747995e9.1
        for <linux-mm@kvack.org>; Fri, 06 Mar 2026 07:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772812368; x=1773417168; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gmR7x9X/+WhBljqVLIwDH2yaruypUaKc2mU2QgggGQw=;
        b=OEWdCL99ECN/td6yQH48X0oeKJeX+W3SRCtsCjDHNeaShL/OK+4jZ/PgbKHTHjnqF8
         6t6s9i4RtiEt3jab1BzHNAKsXld3OhQsUXHMXXHW8rVe15AYhauZIVkTNfo9ok18F7ZS
         miYDoNIsoxhb20yvTaOIGtCIf70eOqyV0e1nxnhMbjR8aGq2K5Vo7z4IOgYvaFD771lK
         DeAHKieKyQCVk9y7jILj7ZwaCXn7AJZAR67DBqfEsDHudbo+QURsKSM4cuAh9NU9L1fF
         4ViT/5WcmnmbyEV0pK5wVc7N3QmJtn5QAPQG9tOQcJoBXniCD4sYNGarvGdIMQZ+kC/+
         HWPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772812368; x=1773417168;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gmR7x9X/+WhBljqVLIwDH2yaruypUaKc2mU2QgggGQw=;
        b=LTM+lfj5W8oN4uUN2VU0ZhFiJN60RvF29UpM+e6NDbjCcGvcyVBZQxxK40v9mjdafW
         kdlPaBNa0Om8Z6B1oosLDFlNMMQGkjGkzJ/3w/RsuAfJS5yDpWRhDxfWcOiy2CiUztH6
         u3I3zc9zkeo7w34MEhZdgXD+GzWDeq2uNrMxhwCjMesqQTQXlYs2v5Z64o0bm5udru3y
         bU9Ij42vjrKgOrFRW3VJca/OJXrpFsRJVvbuel68kUKbmRqz4z6+Jqxe6W53oZrz8p3q
         tN+OzwX1TwJq3fls71kxunY1ZcaBACUhtA5O996fP912272Oq+HNJ42rEneNFU4tfQgL
         eQ8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWI7FcvrPj52NqQGPpmoUxT8GsiahOSY4SJPmwZvfS/oQY2nIxkEPgnVxQALOYvflgjE4rl5r0pNA==@kvack.org
X-Gm-Message-State: AOJu0YwR1aUro1UnGVGm2IjJcaEWUuGQmxj6X0drxmz/2JQ6F0GQd1h3
	za1IrRoQNKP4CQs2kR4h4syD8qRBdvZgv24f3zghVoFy+qxHBZlLaBp8RWUxsJPMMjA=
X-Gm-Gg: ATEYQzz54samMF32VPBWZkgTz+zL9w39emCISBoC/2HQdAFJ1e2QtvoTYHt5+9MHQBE
	Zaejr7uD57it5+SrSNB9H3cWqOIVO7V+hI+4ridVDt89bGblHu+Xayg+i+WnqY+6Wk/BxRm1g9N
	RpHQXxRHW0g1cXMXZKx+0FTXT1Aktp9Vp4IDkbD2/haUZ5D7oEv8kXisanffKwC7xu7uv3GrjYt
	ERLO/cfDwj2fcPFfpAcbJeWIK22VeIUCobtxcVY1GravOthuohSHkTn1ErqqmwD80DWEOvgumm0
	BtimSnkxjzcGneJ9phK1DJWgB740KjusEmkQUILzW9k6DBCKdE0t5r+RCTBnfxXIPJG3pMULo+n
	JHf+EER7rtwGNCouidHB1ArLsSh353uDn6HZThiKgSd/94kcdAyO0Wj2tukGVGBCroDwgQXKnlB
	A7MopgLg2hqYmi9tcF/Bu+n1ZKkJo+i+lBDw==
X-Received: by 2002:a05:600c:3e10:b0:480:4a90:1afd with SMTP id 5b1f17b1804b1-485264e7588mr42095305e9.0.1772812368602;
        Fri, 06 Mar 2026 07:52:48 -0800 (PST)
Received: from localhost (109-81-88-63.rct.o2.cz. [109.81.88.63])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dae4b860sm5074257f8f.36.2026.03.06.07.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 07:52:48 -0800 (PST)
Date: Fri, 6 Mar 2026 16:52:47 +0100
From: Michal Hocko <mhocko@suse.com>
To: Benjamin Lee McQueen <mcq@disroot.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3] mm/vmpressure: scale window size based on machine
 memory
Message-ID: <aar4T90zjolmTGFa@tiehlicka>
References: <beab70d3-470d-46ad-a890-76fabe49272e@lucifer.local>
 <20260305043038.2176-1-mcq@disroot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305043038.2176-1-mcq@disroot.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 43A13140008
X-Stat-Signature: t3y1ue4tbjafexjt65pjykpoy4umubap
X-HE-Tag: 1772812370-564544
X-HE-Meta: U2FsdGVkX188/iCqBtEG5dehJioZnj25PPo58lKQW6bqeX4N4nT/h6elssMi6vh6oqUnHIg0MnEYnMFGWm9nGnCOJilDw+FunCSmlKYpwLqXpn4Qbs4ddjZnv3nbSnLF00ypOCLRf6TljCKEEmWmuiJuChKVds+FGnKNXpCJmhlvZzFD7ryaKYSgKUeHoqjA8ZRsrVbJHCIxyI0E5aH6zPjBotIwhPqa8YpPN+bMFzjvK4p8WKHLfCPLmLe+CTdRYfmNZB7YlbMx6XrwhOJI0JpElxKNo8Swo0WoqZJXlgObkysGAYLyQgoJ0zGRMpAXoi+dHpBWl2ChvFsv+2brkklU6cOTziCzlYSwhFVZkd2k9DCRmXFs0d8ic01M6GohmEtGSdvzPNPCqCJ6T+vZ8rulPVUurU+1EicARKH4ahYvNhVU4mkEdW+ToICeW2V9JtFAjE91JilSrygU9DKo+adkMPoPu7E0vbNoPDNrj9ENau0J2kbs7idXH4j6YSlYR4XalIW5F9z8E7d/xprSGb2fgF+jt2ayl/DjB2Jvdm7iWB3KFOn3UMggOuS3byWlPm4CjjURdQvhsPK5835Ss8XCgeBjbHAoqfhmYBflRrQcwivgB/MeoeYhaLz8dsXL0/3f0kAx7OIvKl3tlWpxO/aK72PQtDk8cIphcel1Kp2vnvAy2MKBSEW0fHfSjz1wqv3ajLLkFbQlUIOYGlhW+Evh5jvOvWq7MDjfxGq498rLKZd2nqqsd69W3Z37jIVFYr9pR+wQPNMTdRvIeWrXg77/R0pkQtK2UgUiPGDqIaV4Np+vWeQpdTgCVnb+L+TXrXW6sBLF/i6UN3X1H5dJNjT14G7X+ri3669ld4lGb6Dj5NUVsL5dvxFNOR6ari95S0tgM6evElJPuvJ+7f3sO42Om8CQB8w9s6rVGYaiEUc9hfqh3UX2eNcgvHjOPLU2T8gmbbThy9uWA/W8NKb
 tpKh+Uxi
 B9/gzB5toijDpBT2QywA60lQFdHzNVrJjpfO0K7ovmRLljXGgiMYxpZ/NuB/EKIAw233TTZPHPUBx4aY03wPQoAjXGedMTlAn6+ezsI0i7ulKP29ILyqzmuPl2FPMhEGvN9R/kk3Ij6TzDT5eobmrB/h32EdZ+nPXsLALWRQIKpvSPlD9oYuU0DL92trfW8mQdW3riwf5sUcJzF/7nOUsVDvi/oFrf1xeh+8EPvZ0HWDUb0hp8VtXVOCeSbbd2/FwcdAJv4irDze2BvBtjaqe05/3URLS4Iyh+wPYl9FuXPr+E3m/vyg78B77JKAwBoiLGuA5LsdH7sVKAkCWbxygMMH0AHWDYd2TnVPk8Mdh/EdxSuU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 04-03-26 22:30:38, Benjamin Lee McQueen wrote:
> the vmpressure window size has been fixed at 512 pages
> (SWAP_CLUSTER_MAX * 16), ever since the file's inception. a TODO in
> the file notes that the vmpressure window size should be scaled
> similarly to vmstat's scaling, via machine size.
> 
> the problem with fixed window size on large memory systems:

Thank you for this much more detail insight into your thinking. This is
a good start. I am still missing an overall motivation though. Are you
trying to address a theoretical concern (the said TODO) or do you have
any practical workload that generates bogus vmpressure events. Also
please note that vmpressure is a legacy notification interface only
available in cgroup v1. PSI (via memory.pressure or global
/proc/pressure/) is a new/preferred method to measure memory pressure.
See more Documentation/accounting/psi.rst
-- 
Michal Hocko
SUSE Labs

