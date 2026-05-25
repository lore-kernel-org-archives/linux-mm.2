Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39298CD4F54
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 02:07:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DBE26B0093; Sun, 24 May 2026 22:07:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B36D6B0095; Sun, 24 May 2026 22:07:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F0676B0096; Sun, 24 May 2026 22:07:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6E3B66B0093
	for <linux-mm@kvack.org>; Sun, 24 May 2026 22:07:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 065F2A0DE8
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:07:37 +0000 (UTC)
X-FDA: 84804305754.06.7AC1C5D
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id 37677140005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:07:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mppLq9cn;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779674855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=deQEhCQNZ+84jqM5CPuDzDgGOHo5t3CpkZDh3OXeVUA=;
	b=79dVBX43qMMNqc8Hl/6M+YPyGUfqEIOxlTWHx7Dy6etuQF/scOvCaDLahp30jAFNj0glKQ
	0Ux5HcOMnOKB03g1wDD0lEyz7i08RK97o3SVZhGGCt4mmxZHk3qt1SISz51GpcSBvR3q9Z
	Ti3dDfMAvjuAJAkkOhRKE2xhpcGJB0I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mppLq9cn;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779674855; a=rsa-sha256;
	cv=none;
	b=BYrAxBaeZQT6j60iuHFBfSnoGXOW4XKf5W1suL4oKlOq+lSb8YgsDnXeZD3G2cdI1+3JsZ
	FwBaruDsosZHS63OMXoxO5kplMJm+/tHDKamwOQkKEEyjJUJ9pXtYW12NFO0Pq7G8H9moa
	D6Uus2RIexvl1Ju8hhfvm7+kjFLVAzg=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-91080895355so1057846185a.3
        for <linux-mm@kvack.org>; Sun, 24 May 2026 19:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1779674854; x=1780279654; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=deQEhCQNZ+84jqM5CPuDzDgGOHo5t3CpkZDh3OXeVUA=;
        b=mppLq9cneG/MdJtSLqS5MHAwjCtUlCUl1tkU18lh5AuLAYlUZK5BP9ahtu2UG1Y/Wy
         DWdqinV/cvYuWg+BRL9tE5cyMvJI3oAbTB3BC/As2dENTfw2Nii2AtZKMb5FqHk1UL4I
         rBRIQ8HlV+G0pNm+4qZjC+WYZicDns1IX+XJv6a+z12uDMU1jLXynR0fpbOt4pwHQ/CA
         MT7KgrL6HHEZwY6s65ACCX1PGkbXsgHxmZigggOLhqZ+qgU/TNkRMdekY+bDf6LtyjeB
         kmq+W5LQdV0sh1jXfDGC1MgtgRNtGJKhpMyF28R9bZvB83Kzrjdf26aaea4UZtIyS/GW
         ULYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779674854; x=1780279654;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=deQEhCQNZ+84jqM5CPuDzDgGOHo5t3CpkZDh3OXeVUA=;
        b=XCXDWw2ePczlY8E5jps/N6Loeeu2lB5fflsJKEQT0btRa4Npml4DDmrHJGMtGbASG+
         hBz1jfB5IKSH8rqFlr/20Med10cznzR/pQqkH9HNb3icfWbrOj3D97lcNDm8T7Rn9MOs
         qK9R5k4tUQQD8buP5+/vjhEydYr6iny+PnKeBvCWy5hR1kyqzrh6mqZ9DhDla7Hzpl0S
         fXdR+D+V5on96PgbZGL7JGgq1W9HmQlb6gI0wSBasf8s45bRkkkLpmeXZtiQwD2VT+WQ
         jlnv6iCE1LIL1NTG/19g5F2UlgZ5VCj7oifZVEkuzI6Qxf7qYfTcKlFuRZJVR/PIxU1g
         LXNw==
X-Forwarded-Encrypted: i=1; AFNElJ9EHT0hNcQvZJjF4VI3JzGvjgKJI2SaeBSijhJ0oJMvCgp+nDZ2vL7YLMnwIOH/BII7AR8ctPv6wg==@kvack.org
X-Gm-Message-State: AOJu0Yz6lW+mzfYqH/B7E9d72sEO/T+ul/hv/5b9OczM957MgN5bWG9x
	+e+YBNU/js4SuAUBQ8HkIbTcSguarjYRotQbcSdKIbsKH8sGubqYsN0E66uYScbz7P0=
X-Gm-Gg: Acq92OGxDLosxWblBRqYCqxJbVd21nMzJpZ4GHPy+HAY9wTeCYhLFLgf9oi35oaalzd
	hQqevjrZIoImdyC3lJUtNe9Fauz7rCJ4ZNfqj2GmT2F1YIP6tTDfqe/kj6Ogdj9VdbW4uSCG8xr
	G3XWihWPoEPfj35OWytgG9PiD2M+GycCVToWlBucpJOEgNJk+jb48Pl3M5dP6Cy0QzYmXbPQbrp
	ode7VKg6vk4jJWWmGjn6Gnm/UW4gHH9l6Hdb/0uB0sKalQ468VXoF+bShlJfvT1bYmhmUFeMS43
	v8ShkITU7fTkn+yv66QypbDL4fLIDx0pT6Mr9Qv/t8lAzPyYaSCCPhquSnF+70nJQNdQgCvFZXK
	OOUQj6ZFP1JjOEiX34PNUaSAqqaTCUeZuMHWEHSCiprKkzPlmsSST7QryN0afm4QjosyruBhEYc
	r3xJN5nDcsqAqNZncA+H/K6IiyX3sKVuVl/37QrydXYOC4PKXd7QtWyLia8wpspwdP6ENQch0FW
	ZlEV28zTSbMLSML0qs9mrQ=
X-Received: by 2002:a05:620a:480a:b0:90f:9cde:9781 with SMTP id af79cd13be357-914b4917157mr1887225785a.14.1779674854239;
        Sun, 24 May 2026 19:07:34 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-914bb90bf62sm887705585a.20.2026.05.24.19.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 19:07:33 -0700 (PDT)
Date: Sun, 24 May 2026 22:07:31 -0400
From: Gregory Price <gourry@gourry.net>
To: David Rientjes <rientjes@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>,
	Frank van der Linden <fvdl@google.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Raghavendra K T <rkodsara@amd.com>,
	"Rao, Bharata Bhasker" <bharata@amd.com>,
	SeongJae Park <sj@kernel.org>, Wei Xu <weixugc@google.com>,
	Xuezheng Chu <xuezhengchu@huawei.com>,
	Yiannis Nikolakopoulos <yiannis@zptcorp.com>,
	Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org
Subject: Re: [Linux Memory Hotness and Promotion] Notes from May 21, 2026
Message-ID: <ahOu49VPzO75KMb9@gourry-fedora-PF4VCD3F>
References: <ee9615c0-41ea-a980-e58b-302e0e64dacc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee9615c0-41ea-a980-e58b-302e0e64dacc@google.com>
X-Stat-Signature: iuhzg4akuis98mpg5636kdj7kk6qx5k6
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 37677140005
X-Rspam-User: 
X-HE-Tag: 1779674855-518745
X-HE-Meta: U2FsdGVkX1/U2qsj5YecsiTxvnFbgusIIDAv2HaIZgygMYk42iJmVfYKKwR1Pxsqwdl7U5aCgqOQ3VjGkU9FiQWXT7m2xLEgd97+g4ldaditqXJxV+Jeql+/89wx5PNLUpZyYHNf4Iz8Q82myz75ZM5J6IVZ9ZV4bJp6SgghiW3jOyhiEOS98bLu+PXhXUX+MCp8EC4ltcUFb9tNAZoTF5+C64Y01cm5yNEEvRQ7ekNj2OWwe/M/t47rJbTEyi7BpH3yfW/DvEI1X8hvO1LEZrcD93tZXnxj3ZxvgT9sxkaJx2JfmPHl8s+v+mJ7jk70JFixb/rrfm1wJfob1w4PRamgZMfZ8rCLuEJCVoRMBfqFsEoiIEocOVIwyZ/RBWm5pbxLshieEF4p8X0suwXHodjAoywN2fGTt82LE2/JR9L+Yprpdd4yZQB3WeO1ojcKbVRP5ePVGfKtLy4FQEeXFzPWeb3AueV4GHLjuNpUJBH6aAWtqi1NYPq2x7JRYhVXIfVGf5gdsRXcVnTGjob/+AzRISuXYE5I9XP7wpNoJ/4NHu89vQn2xxk1MhsFZV+fpk9qF9QSB4owHmMD79mVTX9jDkS2v2L81bFh98XjVePUFWnu24ZKDcC9XjWaCj4q0vz51l4r0ps9CYurU8gSJRNGGMgetV9vHT02sqB53XJetveeeufXfUTSjxsIDbOkTPWrO6/oirWfuapKXunPcv/icE9MRGf/PDCaRH4AnaEPMwj1+mrVH7B+ywIkfMu8VEJefcEUpvTQN6dL9gqUH+cFUphEfFij2SXCXka/N3en8oM5MYki2pPLssgeKaV9K73GNe4y5wzQTEzqdi90CITk8wmX304Z7Wc7mbriwL5pxdsyeU8fs1tBxIBlXoMZ6VuVpGI3LyTb/zJlo9b4USuxjsz2XMJnykyUfEs8BBGKiABtERi9dqq8bA3QYME7vLYu7WTHXEOIOF71Zcy
 Zl1cVTsV
 2QTERkq0yUCkT+b+KXIw2xyE31dtjhCfnQ50pmg6PYVA14F3yJaMrVqdYNVL8FtDnk/qhvFk8asMiqQ+dhIpzu9SosCNEBb6anUYAj7XImVucjdK4pN/vP52fa4XRjoNUucbjKOA9cutKo/zQ+MI91SgYrXxfkzCdwKCwRfFFz06YLZqS6TbVSlciZD91JL1qOiTy8IrHoiqwIj0yfvd5JP9Q2kLbGB1iOB6bScW4vQDr1S7T8kPL10y6pjY49c9AyR8PkKbkuHiPKLxmMzDuskz5Ere5sWc4ndSRVsKFhdfGcvNjwdeu3dqaPOnEIvhb/YfvQWCdfEg+vroD9EequyGpRmpbzyemTDzYN0s6ZnJ4EVZR406aEY6EpKEFydjODPnNyr3O4Ged9XkhiyeI/f6y95kcJtI/fRw40+l7A95O064SsqOXYzGBfLb8Gr/GdDQ5KvSu8HSND3EKBdFkmEWTkKLjsVx3gE11KYZe72PQiCMwEUP++KV8T8MtonF7bEVjNMaaoBOIkTNPcHLAejVlxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 10:21:17PM -0700, David Rientjes wrote:
> Next meeting will be on Thursday, June 4 at 8:30am PDT (UTC-7), everybody
> is welcome: https://meet.google.com/jak-ytdx-hnm
> 
> Topics for the next meeting:
> 
>  - v7 of Bharata's patch series, including new IBS hotness information
>    and NUMBA2 hint faults
>  - v5 of Shivank's series for enlightening migrate_pages() for hardware
>    assists and how this work will be charged to userspace, including for
>    memory compaction, and separating the first patches out into a non-RFC
>    series
>  - v2 of tier-aware memcg limits, including ABI changes to support more
>    than two tiers
>  - update on Yiannis's RFC for non-temporal stores enlightenment in
>    migrate_pages()
>  - first class support for virtualization based memory tier support, how
>    to leverge memory tiers in the guest
>  - discuss generalized subsystem for providing bandwidth information
>    independent of the underlying platform, ideally through resctrl,
>    otherwise utilizing bandwidth information will be challenging
>    + preferably this bandwidth monitoring is not per NUMA node but rather
>      slow and fast
>  - later: testing of tier aware memcg limits with Bharata's changes once
>    tier aware memcg limits is stable and further along
> 
> Please let me know if you'd like to propose additional topics for
> discussion, thank you!

Apologies for being a bit quiet recently, have had a number of
disruptions and have been on parental leave.

I should be back mid-june (so not next meeting, but the following).

I've been investigating LRU inversions in vmscan.c in multi-tier
systems [0] and have been testing why i call "Preclaim" - i.e. direct
reclaimers helping to reclaim memory from lower nodes instead of
swapping directly from higher nodes.

I have a patch set that I think everyone may want to take a look at
but haven't published yet.  It's especially bad when proactive reclaim
is used and lower tier memory is perpetually full.

[0] https://lore.kernel.org/linux-mm/agHnYo_yvyXHBtTJ@gourry-fedora-PF4VCD3F/

~Gregory

