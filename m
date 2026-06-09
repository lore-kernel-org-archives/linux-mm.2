Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 264B6CD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 00:00:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C7B96B0005; Mon,  8 Jun 2026 20:00:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 178D66B0088; Mon,  8 Jun 2026 20:00:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 067906B008A; Mon,  8 Jun 2026 20:00:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ECB0F6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:00:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 479501641F5
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:00:19 +0000 (UTC)
X-FDA: 84858416958.18.24CDE3C
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5719018000F
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:00:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o5ydIdvH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of kmanaouil.dev@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=kmanaouil.dev@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780963217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l9tVdw8sLORdh4rSCY9FmPlD1n8SOxhGPHc2KNAE6+o=;
	b=qnJ7Z12EqNq9TQ5XW5hC+IhBAJr99y2d0bX44LnCnhCxZ+zqKIAF+UZEOmBJAoIh00/MRg
	l6W8YcjKqXb/PqLZA21oHFbmLWCzG3OYx0OKdjO+7bgfcoIeL+0UBF+9cLKn1SHoGQIadE
	U1U4WKloZyTOYqB9KFxL+0sfYrBg/po=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o5ydIdvH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of kmanaouil.dev@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=kmanaouil.dev@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780963217;
	b=Ydg9lZAgo9GlHT4UwKrLslykrO6C14GJCfI/SNZUoAowq0k+CYzhqJw3/+tLdMDK3Q0gL/
	GnF737Wcgz5KseWwbjBgBPffLAAh7Ey1ncoMCNBLCiF+4SL4g4yFRWBL5QcF4nAeXwcdS2
	X+yJv5j7WxBBmLDaYwE8/UM2DvxitIg=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490ac357c55so54453925e9.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 17:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780963216; x=1781568016; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l9tVdw8sLORdh4rSCY9FmPlD1n8SOxhGPHc2KNAE6+o=;
        b=o5ydIdvHH5Gxd3VksWwRg1Pm2PxZcbaJxOUBKN5axClOU+KCOiWoSg8lpCUnRMjmU/
         SJtMRKVgYsLUTuI7m7bhiaGvqdIb709X+Z3YwsKrxtZE8qinbeDERQ+49aFjY1poO8QU
         t95aWZvOn01uvCRhGYpYTFPfZsYdkIv4L6e1wg9kOdEWi4Gs54E+N4gJnGMqN0lRdKT0
         +6mQQ0+d4XqxYnq2EVgLBiR9NtV+oVOOJ23uT/3dVKFxXpsjSg9CSyfxOp+s/Dfq4kV9
         10lPZCEevFFJ0eHD8NwmudKy7ce4yoOHRhMeYkoFGn/Jdnd4hyLyvm104VVUWmo0OOZT
         wTJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780963216; x=1781568016;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l9tVdw8sLORdh4rSCY9FmPlD1n8SOxhGPHc2KNAE6+o=;
        b=tKuxurDZLyM2Qz8uZC+qHqMqKL7G1zQ7Q4jEee1Sj19EfwJMh4HbOgyguZfFb2gEso
         QqUQ0T+gTgw7rF5Ek+kPCeNamhGbKKBVsgkFM8vU//U7QfujjS8CFSNHNZ86BysdG6hR
         ipespC0kpLYFq0mZsU1nZPL6Qmb2XxMerV3+R+neXVw8Bu3pUTSx69H2Bd9U4DDugkSn
         VSdOjkRcAthvXplQMZp18Ry5c6KZziKonaA8Y+0rE3UghcMSUBnejZ9n7PEr8p3FlRGj
         jglu8WoRaK1iTCoZlTwv9mWOkTTuI9Qwb189cjlZAqYQIiY/AbgE6gJxZ8G/HV804LnE
         HHTg==
X-Forwarded-Encrypted: i=1; AFNElJ82H6CGYS/B8NPKPV9zIt7IMCEqsdIywToumzx0feoI6VFKVmRaQ+Sh4bj6Ztey/PIxKoGrxkzp2A==@kvack.org
X-Gm-Message-State: AOJu0Yz/OOAnJE7t5S6pq8KPzScNrRGco0jWOdq4K80vvVRU/ZPml0Ns
	I9+bXXL0jWg0ACXx6MVWHRFesjEUtzPL9PaRi7qltLOQR+73f1ckK4aa
X-Gm-Gg: Acq92OE3Zx2dSEg7HTmkoR4g+uyuPANDz9oElFHmN90x1fl0Q8aOgqldhlpGKiGFZ5P
	qBz9AXxLXUz3xpldKkstlUZ/ThhnQWXnAMH9C7JNrp4Re/8iB1VpPQU31TljCIRcJR15Lm5ljia
	Qc7F+V5PacvxQ/c9eY+wOo4CnHW0Z+YhqPKB/jOzGDphkogrbzollcz6T3olor4Hh8cmKTeJ64I
	TkvlVTo9M0kTJvuJDpIlJmPvFwtmS8T4NACVfLtlHJ7yH3fMDpKGDsPM0/N2gDV8IN0pHiNnxIQ
	Dn40duozoU42qBiAiD2Gt54V3MlZP1JWyJrQXa+GooVhWEAr0d+630tXXIo9ab+Vt/Hqw1H/3Go
	SLC/tu3KN1p18sYEM9yEwFhwi9LH+7AIsb5efIrrGsBs7wrDSAsCicBpJrgvkhZG3KbRysZWNZc
	KrknlRuKItO6/baAcN+2OLR+umSRftfBjiFkOYHe16CrW01HHzlL7M/Kt40x1FhlxWFy76Miofb
	JlOMN0eOnQzxTG6UhfRJ+FZwiHl4+ga2eA=
X-Received: by 2002:a05:600c:358d:b0:490:958f:2a5e with SMTP id 5b1f17b1804b1-490c25b22d7mr326950165e9.13.1780963215497;
        Mon, 08 Jun 2026 17:00:15 -0700 (PDT)
Received: from localhost (pat-125-253.wlan.net.ed.ac.uk. [192.41.125.253])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2dcae2sm59839645f8f.6.2026.06.08.17.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 17:00:14 -0700 (PDT)
Date: Tue, 9 Jun 2026 01:00:09 +0100
From: Karim Manaouil <kmanaouil.dev@gmail.com>
To: Shivank Garg <shivankg@amd.com>
Cc: akpm@linux-foundation.org, david@kernel.org, kinseyho@google.com,
	weixugc@google.com, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, willy@infradead.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, dave@stgolabs.net, Jonathan.Cameron@huawei.com,
	rkodsara@amd.com, vkoul@kernel.org, bharata@amd.com, sj@kernel.org,
	rientjes@google.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
	dave.hansen@intel.com, hannes@cmpxchg.org, jhubbard@nvidia.com,
	peterx@redhat.com, riel@surriel.com, shakeel.butt@linux.dev,
	stalexan@redhat.com, tj@kernel.org, nifan.cxl@gmail.com,
	jic23@kernel.org, aneesh.kumar@kernel.org, nathan.lynch@amd.com,
	Frank.li@nxp.com, djbw@kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 6/7] drivers/migrate_offload: add DMA batch copy driver
 (dcbm)
Message-ID: <20260609000009.dvh7gfbmiz76eliu@wrangler>
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-14-shivankg@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428155043.39251-14-shivankg@amd.com>
X-Rspamd-Queue-Id: 5719018000F
X-Rspam-User: 
X-Stat-Signature: wthj7huzdht8h4ecr9fh6uafhrwzy3jb
X-Rspamd-Server: rspam09
X-HE-Tag: 1780963217-514412
X-HE-Meta: U2FsdGVkX197Q6FaYOjlFBbKAxlgFETVomYrCIt/wQJ2YLgizZm6hlqGJKd5jqXgzZv919aJ3IYNHXlD3HDVZIrZeQVssINy80h2W/52QqNpcD7SyO6i3Of9u5oZKVivw2eTE9Emuv3Wlj4nMp/TVaABVUlFi7BGk3uCqq6G+oIJO0PTwIATXcV2L9SKkFwPhS3Zjcd0lTXWum0qbNxlSNDjvpYkGkQ0flaAt3eyVly8lDLbDcFHQV95Zi9NPY5+le7yhHfwqmSMEXs2ozPWkQmda+kMFcSxAM4EkALuRB6vfLYeDvswRU3fPkIikiajrX2KJ6dY8xGSCPcwQ4uKjFdW3/vKGNX3kdU7qosdtQ/5WOUXU0Axlb07LHa8BtpztDVnrfvBM/Kr6BwYUNKigVIGMzRl8OEqK4WAPXNh4sGG3UQNsHL6KSykkD+XwvHOGfnvgGbRw3F5nw8cqMRn8cKP5FKJE1KZ6J66MjtGxKlq5apdOXmzLTweheMpFTLiyvl0E4UWcVVU9/TEdSaOhNilCXXPYqwpDOEtT1XBQstEwnHa/HAA8J2l+k91MRCzHGvyoaH6B7n+Cf/GqLvzLgrDtuGQbGMrM+5xNZ6Z1buHMBD2/e3x6P2TmJYtK2LluxbkmDavQSJCdfzUHdpx7jVvNI6jB5+Vc5OvydYNj97V7yvZStUfiRx6yIT2OBn4PIziVt/43K6Oqxu9pQvmF0u3PXt+LoC6H4MYFH1xLc9ePKjxL63gWPVZT0E3Y/Px/sz/eKFfaBJ/qShDynX3L+1y711fmMaGPBseaAUrk+TtcM+rF5mBz2c4EySmrgF6Unyp2HMKb6DtYCAQ9PK7BM1vijZTIaVF4Fio8cDj14snsZqIJF5NJKofhUHQyvTW7PNaFiNvdZInhm74/Izp0B3Db40uyw0WFygkDcCTpqhKdXsvyqQRUyUdhvX+9w7TS+Xp7jBad44GSn3D2Rt
 frW2eVRl
 TUGeGF2vusEEW6ITa02ILMpBs6teOeqnHNgSRlnlSJkL5qgSkLwxHkjsrMxTfU0hpDkSTY7NbD0ybc/K5kVEuZ41DuqXOa9quLF2ZTXocgUGK9Q0xJ6hvSi0rFxHihThC6lbRS/pQlgBhTxVR6n1m+9Pt0PQADF85j0hSvhvs1Suj+L5A9lnbMrxk8z1arPeW4ijbWPf1gE+ZjqVL1y8EPvWFeYNH69EC+wQ5V3eJaoWwBCt2DdEWeMpi5sZWJ4AeRT9WTwyqiq46UvFHBcxpu21X1eUq6819mBIktqZExMgxjQ7nXFo2dQknyXR+OAHrv9AJhU8MRKTMV7v7MPh9mulfjV2ECSutR1t5773IyN09S1fLPQb2BviBa8fTWoJDAfYeS1SHaPCo66xSfPkCwa6bD646yCvYZn/7pv3h2fCXJ/WqZB1bLwT0oOal+JcwNIEp+Iuv+929zepPvwkL9d2lGLaMl+l7J5865mg9AG91JRpkVi4YPB6Pe0QrEXO3/RCVyzGhsyrUYxaBEl1YudH7hlpMu194ZG7A6pjCgku/qhvF/Gg83NOkvkLm3Dpz5zvRgYsSgRQj8sHFOmBtZChGZgurczNLl+PLDZPx3R83lijqsMvkclgBkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In my opinion the driver should be at drivers/dma/dcbm, other DMA drivers
in the same directory like idxd and sdxi can just export a struct
dma_migrator. It makes it easy to have everything in the driver's own
directory. For example, idxd has some internals headers as well as an
already existing dmaengine implementation in drivers/dma/idxd.

PS. I am writing an implementation of this based on idxd. I'll try to
post it soon with numbers.

You can add
Reviewed-by: Karim Manaouil <kmanaouil.dev@gmail.com>

-- 
~karim

