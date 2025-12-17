Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80307D68BC2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 22:36:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2E276B0005; Wed, 17 Dec 2025 17:36:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDBE36B0089; Wed, 17 Dec 2025 17:36:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE7FB6B008A; Wed, 17 Dec 2025 17:36:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B96BD6B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:36:34 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 592CF1A0509
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:36:34 +0000 (UTC)
X-FDA: 84230423508.20.2891F21
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 784EF1C0006
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:36:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=cMedgjzG;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766010992; a=rsa-sha256;
	cv=none;
	b=vphw+wa9GyTtj6voYEwTXxvofw1e0fasT8YSmrjlBQtgVhmp/88tLPoH+oNF/6x4c5Trwz
	RMpnl6Eaa7ikNNUtIWPDFLXBAv3rAiTDQ1I/HZFhBnuGkIl6e5hng83hnXxToAehC8VeCv
	DRbmDCKBOK0691RMmo1rbhaRgf8uN20=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=cMedgjzG;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766010992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kR/+xgf6Jhz+E5StwKcRK1JFVZohgr4tToC9Isegfuo=;
	b=XzQPD58J3G+9JJs1tD9XYU6lqf2+AYs816SNmYfSCMhOKqWxkDgjpsC5dJxRY/tvt5zseN
	NsDsfO73cX+4nViegW18TuhoTbqbRwmIYTGgkvsMtJrOzTFstQO2onlk4LEn38dY87/7VK
	gr07fzGJofYxAIjb9MLDVTXmwT1WV5k=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4f1899960f0so64613841cf.1
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:36:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1766010991; x=1766615791; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kR/+xgf6Jhz+E5StwKcRK1JFVZohgr4tToC9Isegfuo=;
        b=cMedgjzGJC2wFr3/GtYCxKpWqcJESVafF/9JSW4MhOF1+PX+CGyWypLgrFpVvhA6Hm
         3SRNhU7iJKuJZtNr9IzvwFpKLO1z0Egga2SBtBOtKxj4FSR7OBiiQrYTfpLVOsiBUwuO
         HeUBKBwYDuZonscaShurz/eB3ILFKsLNFYIzFRDY4R5fmrxjrZsnQBeJv4VyWCgaNzY0
         fjkWBba9bWC7c1DrhOs81xNhbXo8b1WE7Xkhkm/Nv+SWi7fXY66DKmc91nobrwAopwFI
         Rkw3KgTfldEVI6WYYNbWttZGdpXn09pj+EL+x+Keag4HB+eqJEo/okBiJBdmx8EYEMHg
         iS2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766010991; x=1766615791;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kR/+xgf6Jhz+E5StwKcRK1JFVZohgr4tToC9Isegfuo=;
        b=IcmSqoh7rpWBSQuydh02GYCPUCeq4chcA3oB4t4vzLwBl8TCzvGv5xJFSqL1L7g2uw
         Hh8sh8HooQvTzaaDtOP7MFbN9mh7oW/DHcTY987UG8UjR2wYbLGQSDBrD+fFKaa+M4o2
         9mbh++IReCtQZrU+a/Lib1Q7CwLha/vzgsIR2FWUFK+tCPqnwb96CyoLC3pXBEzR49Qi
         SXcp3Zgy6b7JGN6r2DqjC33b+uGmKFzMkjtPNLiQWcXgig0Rw9k5cuYICNC8Bbi9Wv3U
         kNdBQfYH+h1CFt3HCjrrGT2rR4r0pViCZRr4i95QQY28A/OBnapWckLpHbLdq/N3WJCB
         p3kg==
X-Forwarded-Encrypted: i=1; AJvYcCWjLaAY+/6coJQMKftAZYebq2xRSFefYVHGEZR3/725ixV8pWuKV/o/bjIwy90C6e3xcwQlJ8KcEw==@kvack.org
X-Gm-Message-State: AOJu0YwHTdJhbaVIEsp9lRI6eWXMKczaBM8GQKOVBer7D/9ka7EK2FYl
	9/ITiQ1RT1LR661eHL849PKAoZ5HkOkX7gy8l7CtLhxf/tAmfT8NnUV2luQr40h7Eu4=
X-Gm-Gg: AY/fxX43Dj2He6uGPhCAaDvNGTuIDD6whu5WZjoIwNPFlPh20d51GP6PZRgud3byZB4
	KDURFzP/X99tcIZ8GTeBPqjB2FjoTrgb62QTGUlyd7ypEb3KDU0BlnRbzkeyixsXnEWGe895ADF
	GBHJdYrMIuDYEehT5lHnzAVGuh/NVt+1ZUOvR84VIkslRcA3EvysUqVQASCr+GLZ2qq2XqnvL3o
	71agqIV5JK0G5u3eCOZfoh53IGuv6Zzva/yotghBNnXhZSl3/u54WaPYK8g21f2sK6C1nR11YQt
	hBhj0nQiPPAEBitGLZyGjHYqZsNfw4sbzsOO8ZTTv5POj9p5P7orlhf/UyyaRXQ5ZDOvUQvWsky
	FBiis/PY2Sp3TYOqqppRtJPN2+zSl6BjA0Ucx8efBMgnPrSdL6QMa9Nl9N3ofZJNQF1dIapvebd
	XCSjqVIe+BAg==
X-Google-Smtp-Source: AGHT+IFEnoIqNTzn/beBrrTTMm5NCOBdf6XqjRvcyNax+rsawQ6zsZEDQLLD5Cw+412x47E2IhWIYQ==
X-Received: by 2002:a05:622a:4d89:b0:4ec:ee2e:1c20 with SMTP id d75a77b69052e-4f1d05a9294mr251307421cf.47.1766010991640;
        Wed, 17 Dec 2025 14:36:31 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88c5dc728afsm4765666d6.12.2025.12.17.14.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 14:36:30 -0800 (PST)
Date: Wed, 17 Dec 2025 17:36:30 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 22/28] mm: workingset: prevent lruvec release in
 workingset_activation()
Message-ID: <aUMwbhEN8WLvSNXb@cmpxchg.org>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <195a8cb47b90e48cd1ec6cb93bc33a8e794847f6.1765956026.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <195a8cb47b90e48cd1ec6cb93bc33a8e794847f6.1765956026.git.zhengqi.arch@bytedance.com>
X-Rspamd-Queue-Id: 784EF1C0006
X-Stat-Signature: 8zh4chogjkscioymgafbo8w7p7iqcqpi
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766010992-741381
X-HE-Meta: U2FsdGVkX1+lZ+Kpa0wF4S9Cs24gCnPbufhMCc1wnaTg1KvR8yuMMay18nJppDO1nW2xlsu+ckbdraLPonTeKJMPRIygi92hlbN2KNYl0r0sXu+O2ThpbRkSHBv4pzex64LGCsUeiQX3tLWX1BdXMZ78b2J/AyjePABjwAHpn0+xFkBKrMlBGIvAJDtOx526U5wcLt4bjS6T6nOEEdfBeVrAV+/tQZ6DVkzAA3vQXvtvCBH0sRqtTLqtMeolHJgbvzVwbka08qN5T6gLeWseX1fiR7qq+nMZI4VQtPNW5SuEDpdruqmBPpDbfL3LpcJAV+unnjZCwW80I/Ksgsgk/Ca7pTHf6JgsJ6XSA7lfAAL/eQiEw+tQNInCPbE2h4xOvwMfwZSehiUH6KGJd/6OHdvW/PrB/ZRqDxSDsx/bFSI7iGzgU17KwBl0IJegidVZ+ka5kxilYriGyA0m3LlLyfak7TQqysf+KZWL7Ak+h1SviTM6f1R0VfH8hh13Mm7L3CvXobSu0ILlwPtLrgJ/q22cPbUx1jJ1TW3PUIhgjsvs9ccpKSSYV84hxin5amyM2wpc981WLPXu9mvxCxps7w74VZH6QtgFQIm20ObVhYXb/bxPTWRiZYZqsan0w/uywdjwMwAALTvcGO4MrUB7cMRMuwc4VMFp08UaiZzrKZvcrRyJO9oVaWKP/gzblKul6ufvf9DoJHMcwC3cQxUr0r1ruf6TrCPswr1xpJjsz0RHHU/JrmsgTP6PDBqiwx2C5J2IdrHZVzBzuIwH0mllT6AVp3NW7vloQACze8NUmWO4FR91QlMZbSMeuND3CY3PfLZjj6p3ceciPALmzsl+8ECsLw/tVtG451cBbxXTRThw9JcgIm+LDtnkYHW4Wu2ATqS20AZYHDyE7LY2PhJVRpHH9KINIz7uaMDidH9XBV3/4Yx94p6480d128LrkEdQXx7PLQVuBxiloL4ZxUT
 rlY3iKxE
 INqEf69TJ0ifFq4mCVArTeVtRB9/dNSel3WgqZrdDkXAWxcGlSagOFwsWQ03iD1LFWkYdAUW5pBElGbDyrOSs7f5DAfQfKlS7IRU917p9DxeTbhY5ZNzG5F3j2h1vWS4EGxvMSpKYzuk2EpCTqHkWtSRgEkP3p0yPeCDrrS2ld/3g6OLgPanGCQZUvyiUV/nPsduO/GBHOdQ4MGTCamXxzb4rog1Jm3O6v35Im8KZMlP1q6Ha1byqN8zjuHoNAy/UeLZHsomlBrPoOhcAyxp/zKqS+aK1DwX4tH0Kipsz9cdRZidMOs7DYuM86W7HqYT4S98LjS+plox9UDhTSUrdYjTgtMtv8fWUFAkqYYVioNAVTdpbKDNxSFQKCGXcAxadrizXKHwiCebHvrHjoY/jnXnfa1Gt5fyNkeBHS27lSdyt4hA4IuFxe/NzcMgV8UFtCnzKJbQjapKtLackuPVcnOSkhzKmNkytq+KzbWhEMvNw55i0sTFGvSLR8hVr4/jjZnn+gs06IkUufM2agGFnC2JLuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:46PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. So an lruvec returned by folio_lruvec() could be
> released without the rcu read lock or a reference to its memory
> cgroup.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the lruvec in workingset_activation().
> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

