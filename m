Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7D55CD040D
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 21:34:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AA7E6B0088; Mon,  5 Jan 2026 16:34:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 480DB6B008A; Mon,  5 Jan 2026 16:34:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AD286B0093; Mon,  5 Jan 2026 16:34:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 292706B0088
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:34:21 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F11458AEB2
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 21:34:20 +0000 (UTC)
X-FDA: 84299213880.25.F8264F7
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf05.hostedemail.com (Postfix) with ESMTP id 161F9100006
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 21:34:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yM1if0dA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=bingjiao@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767648859; a=rsa-sha256;
	cv=none;
	b=ZMPsEQ8gKBZ6OpW/SiIzovawXsu7IY/aDSXYRA2aeUOgixI22XdGmIgNpQWeL+JjYRoL1K
	bgrYlcISMezpoQsOUQ7ZE8R0RYMjSoAc+WrzjFG9IUVsfpC9PKjtQYYYToxgdITYe2GF6B
	8+0pnFf2KqFKiPHFbgYE/oGo7vuxHJo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yM1if0dA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=bingjiao@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767648859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iSWfb6WbMa4GK6t36QHV/UhaSlBkhsogc7OHaBLtTbE=;
	b=3UB70kOZyXMWqQJR3AJLUjLWFhw/Hq0kidqpB9ld+p5zpEhMaP92nxR0gfOQcHuiY9/3Q9
	dnbLA+tP19Fj7RJxH9K+E1Qns4Gr+Ns2jRFMihHcAGrnrQuBTCGga7k1BLAkiywQ0DVH77
	W3JXwF4PvZLUx7TG9PrTWXhJhjAsGZ4=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-29f02651fccso57045ad.0
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 13:34:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767648858; x=1768253658; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iSWfb6WbMa4GK6t36QHV/UhaSlBkhsogc7OHaBLtTbE=;
        b=yM1if0dAbtuxFfjOCBQeYfOrPf4+rE0dlnVqSsEzUPfU8/sqeOGTLsM2bCpczQh+CG
         at8n1oaXL6e8Sfs7ran/MI/FcDp2QY1GqghCXLOk6zBbcylTxhez3kiO4w+sEMYQXpo1
         eUDfe71imCWIia0NMKP2ZfNstpKmoYCalWz17aCeDKBQejbeOhuookRYeKS9vgNcqelm
         WsRyFOUubWs7xZBTz4zYOXIgGec36zOMs2UCVJTKfBgtip1/HlwywkABBOw99oO26mCL
         pRqyilHPGP5sNGrF3tLL/keZT/WkXmVC0dWtrPsCmiZDC5zJl4iLF60i39RQP3i5JXjR
         AUyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767648858; x=1768253658;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iSWfb6WbMa4GK6t36QHV/UhaSlBkhsogc7OHaBLtTbE=;
        b=ieGTWVsUzzmGu2W9keY4s0InAzwEKMfI938QX64V3z+I1MU49+dXaw+5koNMdDZNpE
         3r9j8pIUhwlBwbedtkI2NCKYmf02iBsQXOT18Tbmc3M7oRLUlgJS/MyPoVrrGM/XQyYa
         ktJxLY4WE7m/ezySRhRQs89rsQ8YIjXYXkmE1J2k0hwifT4KMJanRXMOnQ2kyyyxig86
         DmXU4f6CnBpyp/cXKuUeJltCkMh+q4VylCqN7y/bT1Ak4mDo8LuIh0RV4x3ZwNiMgOuQ
         IInhtv7TFyKyTUSAmftOAheMV3g0xudOuXv+SzrChqivcm4VFTOMgeOAU2UVj5812vlH
         uqVA==
X-Gm-Message-State: AOJu0YybXBqREnfyeWl7qghr5We1P3bPBrxjVot68MLh7B53AwOPcWHf
	E6Bw1dUzBCr2rIWw8gVoU/xlstbBQwf3Ejp7WIi2/ZkNL3uE7wmLe06xb31KdDj0vg==
X-Gm-Gg: AY/fxX5BlhjQ8jeJndKDB2rvalfmwp4U3iXBLSWab852X0LPJjHgOCQSmp3sE9UuHop
	1NoW8VX0/km8iYTf9eBwFxIRc5V7n7NURyVz4FDNPVkBwCEG0GXnJPDkL0hzKX1M/6bUF1I8w7+
	qFc5A/643IupjbBZVWDrWrx64YgL7u7RZIqexpI0zQ+sQYguk/mcI9Euws0T/xb+msynKnncJaJ
	SY8acbe3/7/NL4R+4MK7mekQ/w/i+UDlJGUZsCfzeoicceO3VCGxyniyAXP6LFVy/1U4h8Eqacd
	ZAgbv4b4Jcm6lFpyH9NtTxJgLSZ2g9e4BjD/4hQWBplt7nyySVTk1S5/o2QseEkpDGzChNuQU7X
	1+GyhbNRF6KzoFdGo+3DkGEI7m5PDkKOLCHQoQ7asPRf4tl4pjeWaowg/yNCgk6PzWB1a30/fOJ
	ZKolWW+nD/Kyc7gNCuVAl/cYCpOd5Gu3tev2tvKSGCDz5xiwfDCt2L
X-Google-Smtp-Source: AGHT+IE/9wbqXZpR+eCiNUPQoW/brnPaSVUSFMiUwvWM0JW5+HuqfmdEFWty6+NS58ihX3xiYnJu2A==
X-Received: by 2002:a17:902:d4cd:b0:2a3:ccfa:c41f with SMTP id d9443c01a7336-2a3e42564ecmr148435ad.1.1767648857501;
        Mon, 05 Jan 2026 13:34:17 -0800 (PST)
Received: from google.com (248.132.125.34.bc.googleusercontent.com. [34.125.132.248])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c4cc02ecfaasm300231a12.14.2026.01.05.13.34.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 13:34:16 -0800 (PST)
Date: Mon, 5 Jan 2026 21:34:11 +0000
From: Bing Jiao <bingjiao@google.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, longman@redhat.com, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, tj@kernel.org, mkoutny@suse.com,
	david@kernel.org, zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com, axelrasmussen@google.com,
	chenridong@huaweicloud.com, yuanchu@google.com, weixugc@google.com,
	cgroups@vger.kernel.org
Subject: Re: [PATCH v5] mm/vmscan: fix demotion targets checks in
 reclaim/demotion
Message-ID: <aVwuU2o5bm7K5w_7@google.com>
References: <20260104085439.4076810-1-bingjiao@google.com>
 <20260105050203.328095-1-bingjiao@google.com>
 <aVvenfzgCU9uKJN8@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVvenfzgCU9uKJN8@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Rspamd-Queue-Id: 161F9100006
X-Rspamd-Server: rspam10
X-Stat-Signature: 5kkj9uwoiywud7yh938huznrnb8ohk6d
X-HE-Tag: 1767648858-980481
X-HE-Meta: U2FsdGVkX1+SB8stt9mIEjXi9lTKYSks/ZDSc2MqnaV+k+DB9xV38AzBXobaSpTbH5g3q2A5frjd3mifdkSjPOsZetQelynQW1ssTumA0vPPQlVk0FfV0/3TtgBWteKioObkxhUDmcGlt5qoGIn2Dwb3O9Jg8BOz6xSWkgcvcS+JI/HgVF8eMwG7vtDUe7Wy95EgaVZcx5hlw/sxD1/OA+XC3V5wLiy/xeOJsfcCblCLoL0qJ5/AmJadzJji9+FDkg9O+UmstrMQyrxggySaWmwcOJJz3k7jxy/n1wdep9ktjHzj0wQam5qIGfEU2TkInTb4D65n0300jjpeMaPbOuWhGHGGP61QDpth2nMH0dfh9E7xJNy+dHA9vTD2CEnkU/XNEqx7n7BwkQkDhbSw5XR0g6dXNqZE+OsrqwnRA1uyrE98npFxn5DFJTdGW1pWGUVDUrWhdvYAlDSxPZBcoWPdyo6vymY+l536+vXHeiKolNfFdDii1a/DtknwCWdDSH6kkY0pJ3DB60Dz9XYhws/kBo/GFHYreQSzqrEZCslmN5QjKJrtVzg5qbd7r31z051MWwSpSHd/KaCCBluo18s2ZRlbWOx1It+Q4TMA/L4j/S6T6FLKMIEm2fO8xdNFKE6jvvY1em+0QeRA2qUSfl8GmRO2yop4F3HEog0RyKbK385YH9jGeO6nc4TeRDRHO8s3pNeYZP8/k8xIYxxKKIe3Bc0rKK7VioRkiTrHusD/K3vg/PBM10vfHftSArbqDWj6NsSBnenDBjxK9Ryp5P0KZxkcBnbyVOMFGdNJh4UkgSzpCpNIox9yuzfOjQW2kU9YHMOipXg0ByAam4H5SKhXhALjbKDijm06h+YFUz/3RMdAgIsfyoa0vRBXOl5c5ScPcWgewAE0omxjx88zY0M5tgMDxt9Zr9pzRWQbksexTsGUoshBxbJ6ex/4MQOGcy6fg5znrXj8yScbUNM
 Ey5y9M9F
 b2ZF6WiZHJIiBxLcYIq+SRS8d8RMu3T/ZglQKDKmXeiJ31QdPLHxQzaVj4FK8wO+c6LaFaMJp2GIUP1xkk2dPIcQq6E9xCToedT81h4StpdqQxmUlU4cHDLNHLiRhpSBvkB0PXmpylgbMLSuciytzElJZnwPRVcp75d8egYjn1tAZEgL8Czr+hwODuT4an/teTVmdvMlXJXpUSKFY3O/IFmJLgqy8VAuQeKoqB+cclLWABVcazc/wzPQAe6oDBAsHuG/R4RfV/LXQNolh2M8X5t6rvHLihVfvoF9h1ylOTv8M4Ab3sqLVcBLhjYvi+QCE9eRpoE5ZRxiiSrte/fjj8gbalNR8YpkaB0ELcuFzgpd1tHQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 10:54:05AM -0500, Gregory Price wrote:
> On Mon, Jan 05, 2026 at 05:01:52AM +0000, Bing Jiao wrote:
> ... snip ...
> > +/**
> > + * cpuset_nodes_allowed - return mems_allowed mask from a cgroup cpuset.
> > + * @cgroup: pointer to struct cgroup.
> > + * @mask: pointer to struct nodemask_t to be returned.
> > + *
> > + * Returns mems_allowed mask from a cgroup cpuset if it is cgroup v2 and
> > + * has cpuset subsys. Otherwise, returns node_states[N_MEMORY].
> > + *
> > + * Returned @mask may be empty, and nodes in @mask are not guaranteed
> > + * to be online.
> > + **/
> > +void cpuset_nodes_allowed(struct cgroup *cgroup, nodemask_t *mask)
> > +void cpuset_nodes_allowed(struct cgroup *cgroup, nodemask_t *mask)
> >  {
> ... snip ...
> >  	/*
> >  	 * Normally, accessing effective_mems would require the cpuset_mutex
> > -	 * or callback_lock - but node_isset is atomic and the reference
> > +	 * or callback_lock - but not doing so is acceptable and the reference
>
>
> "node_isset is atomic" is an argument that not taking cpuset_mutex is
> acceptable since it's a singular operation against a nodemask (one bit
> it checked) - and therefore for a moment in time the node is either
> allowed or not (and we make no absolute guarantee of corrected when this
> race occurs, we just note that we're corrected).
>
> nodes_copy is not atomic, and in fact this can result in returning an
> empty nodemask if cs->effective_mems is being recalculated at the time
> this copy occurs.
>
> Rather than just saying "not doing so is acceptable" - can you please
> change this comment to explain the implications of not acquiring the
> mutex a little more clearly?
>
> Example:
> ```
> We do not acquire cpuset_mutex during this check because the correctness
> of this information is stale immediately after the query anyway - this
> saves lock contention in exchange for racing against mems_allowed rebinds.
>
> As a result, @mask may be empty because cs->effective_mems can be rebound
> during this call.  Callers must check the mask for validity on return.
> ```
>
> The rest of the comments in the function explains a about this, but I
> think with this update the comments need a little more rework.
>
> ~Gregory

Thanks for the suggestions. I will reword the comment in V6.

Best,
Bing

