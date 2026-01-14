Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADFAED38FFF
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 17:49:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 237D36B0088; Wed, 14 Jan 2026 12:49:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FECE6B0089; Wed, 14 Jan 2026 12:49:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1017D6B008A; Wed, 14 Jan 2026 12:49:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01F746B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:49:52 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8817E59770
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:49:52 +0000 (UTC)
X-FDA: 84331307424.27.03DC668
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id B17FE40013
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:49:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=F5AoALFr;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768412990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rnSGVRURKZAVPD5jw0dyr/F1254P0uVRvVrsDhTaqXI=;
	b=BP4BVNm/z402QBDAZ+dmCggfORFW3++wZBla7aZ7XcektT8gsylqd4mKpitgldQZIDvEj4
	QAaFs84AoyqXzDrIDYtvoBkEkB2tkGd5dUlwAJyzrsXw5dWVrJHmIR9OmNVoTiSxOZDIyX
	jVKcB6DtMHzFV+zJiqYm9ibOz5DuQmA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=F5AoALFr;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768412990; a=rsa-sha256;
	cv=none;
	b=dKQllKwSwi4CW8q8n6OLT3NqpJ9qX1xBenNG4JiMg4KF5RigRPynA0t35NqZKIMeM1oj9k
	j4bH8p0yZihn0+mrYCY1LgVPZ6L47SdQ/onbdrhpNN3DruUYCibNqscXsn8sgARbqivH7Z
	TIZ+4SHmEiwqd/SWyEf3bT/FcZzP3CE=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-501488a12cbso345821cf.3
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:49:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768412990; x=1769017790; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rnSGVRURKZAVPD5jw0dyr/F1254P0uVRvVrsDhTaqXI=;
        b=F5AoALFr/VCFxmq7FdwrfqqR5BSV4fwCBTRNd9ToS7NPw5mEech4FLQaVrG3wEB8sR
         womev1gKYTdgISL8ajfVWjtku3iWpx3qi7fZ4IaiqE0cvKekM4v1nAptceaobOlHogRx
         Sr+gPJ1O49eIJQ9dFEqWinJXVUyyOkDrC2acRA2WRChizh3JPIVVH56kCgs1XFSrpzvr
         /nDIbQiCSgeRP0ZwJLuP3hLSi1sa/cCGIVNCWF4rZRa3CEKny3tNd3d2sXN/PxRdKNQ/
         Nyu8Oqqeh9LFgxdzgGZK7ciqpsq8NOKKCZKEs2i2EqFS03zecSog73zUEFDcH4cNnDtj
         YIhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768412990; x=1769017790;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rnSGVRURKZAVPD5jw0dyr/F1254P0uVRvVrsDhTaqXI=;
        b=FXr1NY7AbNyQ17t2Ic6DLuLXxffpjyyxqXOYgPFEoc+4h6V3MYri3bn5/hIDYWeN8P
         IEQ457Hq+Lu8J0FLmPNRqgmNpmzSVhA/1mmCMpNDMYpQ2Yp8SyTkFatJ0PPZKqfY3PG9
         fh6INwlhfURnb/sd17R1RgJi4v4k2IxGV/WLmrhxc6eH+/fXjh9++dYTM2jEW07Zhgw9
         5trMB+jwtO2Vb+S7iEgX1gtD8k+uAFDTPw9Pwo3n6wJlMWEMXugeevww1VzBHhJwsELL
         UDcCqv9jCWeCVr8YsT/pif7HB3k+Tw64rhTU1ajIUozW4QaHpeTkEsKck+rHAqKEl16w
         0gFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXmjTcUvTA5hSlQaH0E14Ek1UwExjNEBKlmJ6c1LQUYxaT7qW9zUEo+W6XB16JHIQwVhLoz/ISiAQ==@kvack.org
X-Gm-Message-State: AOJu0Yw2XyS8HQtovpmnQtOUn11owpZBINl7yOmk1FNlNJZUVs15XzZ0
	QhjMsq1MvKRm56/N65oJx1iic2UoQ4XQpLi9qHObSqakqooBv1eVtWa6qmdLhVvfQwY=
X-Gm-Gg: AY/fxX4MBxm27SZsSQdQkN14HMXtCngX0PpQBy8r1ugS1gk6mqXpex/q5RyVBz+ah7j
	1OlvWiKydyUkMNJXJ7UA6F1a8AOArC0bfoGHnRmi1tHKm6vHW8bsrP/qDJwztdZJdvw2LngS+i+
	d678+ikE55Zgkcpj8S0VzTKQdBJFBIU1lhwT6Qr9rNYWDevJh8codCrqff9iVh/fCBy00SddnC6
	XP6175LKD0kLtyTv431j/cRBro/hcHY217m1JwHJipwDObCfrwp32F3TgGYPtXf7W/fP07xobO4
	hGgDxLoOLG/bsDz2rGiVibAaZNnWOm/dL6+uR36S0xDW2PqdkaTAGllrhhq0MaJqS+EKqyv0um4
	jGIiL6iNSdQx7OCmzCf3uccCSItZQSggL5uFSwuXzQUs4JAIb2K3/GdwsnvH3GYrQAdECE9SWLP
	19D94kZ3uDK79ozEuLUfi9Qyz8tsURPUv5O4GAa+uZyJBDB9k3qmMi0HnAN1YLnac9cVMqOg==
X-Received: by 2002:ac8:5312:0:b0:501:4b10:aa9e with SMTP id d75a77b69052e-5014b10ad9emr26844851cf.13.1768412989843;
        Wed, 14 Jan 2026 09:49:49 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770e4262sm177915266d6.20.2026.01.14.09.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 09:49:49 -0800 (PST)
Date: Wed, 14 Jan 2026 12:49:16 -0500
From: Gregory Price <gourry@gourry.net>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	akpm@linux-foundation.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
	david@kernel.org, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, apopple@nvidia.com,
	bingjiao@google.com, jonathan.cameron@huawei.com,
	pratyush.brahma@oss.qualcomm.com
Subject: Re: [PATCH v4 3/3] mm/vmscan: don't demote if there is not enough
 free memory in the lower memory tier
Message-ID: <aWfXHKDzoQBsHxAp@gourry-fedora-PF4VCD3F>
References: <20260113081453.8293-1-akinobu.mita@gmail.com>
 <20260113081453.8293-4-akinobu.mita@gmail.com>
 <aWZLZzo5Hb1aFZ0j@tiehlicka>
 <CAC5umyib=XmPkTvRT6eAsMx+WDx0NkSP9djh4xkhLJgwk_v8Mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC5umyib=XmPkTvRT6eAsMx+WDx0NkSP9djh4xkhLJgwk_v8Mw@mail.gmail.com>
X-Stat-Signature: t7114aw4dnqcne9d997seqtsdd3i3j7z
X-Rspam-User: 
X-Rspamd-Queue-Id: B17FE40013
X-Rspamd-Server: rspam08
X-HE-Tag: 1768412990-448989
X-HE-Meta: U2FsdGVkX1+G7BgIHsttRu1iBrK47k837dHvJk2Blar05SbJvoxhwXJnTYTdRCTQg1S4nOhf3zJk01L7lJYSpD5iEVsJhHiAv7kTfkf0b6+m3ib5+Z41rN4vM+93GJvjPfqk/stweXKETHkxaDBm/53avScunwwKog5YhPTXn8NCr6D2COIGzPcYPO4T79ipVdGYx+etKMwndi2P6dp4NhmrY438gcsg3yHQWLZU5d+EEC68eSrRdWCORyBOmDjC+V/NpW1oBHKiL+T8TKDgqCXd8ulDLgW9rOBDTSBrys2FxMs1Xw1DgHUjtp3G331RCXAzOXWOVQEtsatnd23rlamdvt+wZtA609aft6d5fCyqaQhvIWkk8uhZELUjIomH2wlqcAkOL5oCH0WiOliJzXzV6mCxmKCvHfnr0WT1JnT5gZP+jc52fXSVfJPDtm1zBs6a7w5sY8DRFFuX1koETPiZRGG0TM6QMNu834fovXoewFgK0sHff4KjQ4KMB1k+E6BuAIarLWyjsYCBSz+7TYu9BX0d3PkEMZdaRgL9PDNI3psLvl1QdfQ4wkxVtFFv7YDhP8PIzBuKnwt9ZyVEZ/BWwxUf4F/u4omRkK9F93ug0bAsqgKCc6tw70TmJOmOnxjUNXxLII+fweuzQHgeod75bIVXgUQkyIcYnVFiV2CQqYTM6Pfwel50TDzqYkppKjOEIL0x5H56eRQgnIjUV/q1dK3zab99SCJSp9xP15I5OWJ7BPxKGRLczeVYjyDD9whq930Df5ALWG65xN2P7uPjwM1IfyFko9xtOp5XFKz8iTRFrPCPYd+mdPDavJn2JGXCyMmZHGhOiCycNbyCEFCEBOWH0gU5gUrBX29+6BIfBxTEH2OmgE7MUf//n/lJkZ2+rGKJ4W6hXTj4oslqNktSwzU+nhjL498JaJML0gnzXohALvPGD0Xctu2YmaRHpELY4SAHro+gsy7+BWx
 z+CMq4RB
 bRaydx6OtF16jzozvwlLLQzjo4BeBnMIfmLA6vO2SspM6iz5NCAGbd+d9b1QMV/FTDOAimQCj6u4QG9e1XTNlsOtiYbRh3oqE2H6aPWy86bhwsJCXLwSfdS1GufSowArDZhAN9HXRsO7i3Hyc1J8YLzteNhQtAqoFePVBvgi8n/1aqpzs2XvycNKZTIQg1wJVzoly14rZMd3fN9z7rkz7NMv7p6vr0mO1pCmD7CHtyBNBvrc50iYwl1BCvzJ/fdObkz0fd88z49za/Fwx6Hznez6x3qYTVVVf5P1ZVpbPqWIti1SUqT3x03TocXvoML/WF7dyyd4eJnRRESMSi4Z5xAHNOUyOsJtXnjEDcN1+GXvCm5jXafsPjyivur3vn0fR0LeuDyCGcQ0Izx/Q55y0FgrATzHV8BM/OmTWOfh9HUJHlKiB/8BAhWGYbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 09:51:28PM +0900, Akinobu Mita wrote:
> can_demote() is called from four places.
> I tried modifying the patch to change the behavior only when can_demote()
> is called from shrink_folio_list(), but the problem was not fixed
> (oom did not occur).
> 
> Similarly, changing the behavior of can_demote() when called from
> can_reclaim_anon_pages(), shrink_folio_list(), and can_age_anon_pages(),
> but not when called from get_swappiness(), did not fix the problem either
> (oom did not occur).
> 
> Conversely, changing the behavior only when called from get_swappiness(),
> but not changing the behavior of can_reclaim_anon_pages(),
> shrink_folio_list(), and can_age_anon_pages(), fixed the problem
> (oom did occur).
> 
> Therefore, it appears that the behavior of get_swappiness() is important
> in this issue.

"It appears that..." and the process of twiddling bits and observing
behavior does not strike confidence in this solution.

Can you take another go at trying to define the bad interaction more
explicitly? I worry that we're modifying vmscan.c behavior to induce an
OOM for a corner case - but it will also cause another regression.

(I am guilty of doing this)

~Gregory

