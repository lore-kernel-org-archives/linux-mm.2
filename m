Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4165D112583A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 14:55:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D1EC6B0089; Wed, 11 Mar 2026 10:55:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17FD66B008A; Wed, 11 Mar 2026 10:55:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 037316B008C; Wed, 11 Mar 2026 10:55:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D4F3F6B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:55:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6EF091A027B
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:55:52 +0000 (UTC)
X-FDA: 84534081744.28.C8A61C8
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8FA4BC0012
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:55:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DjGUgWjS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773240950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=coDqJI1op4oYDtjwGdTFlrXQKPgNyvcAEUeJOHUa6Vo=;
	b=OyW7yEJz+3U8rIjJ2fPEnqj56IXJgNNM0RSYBCLuztvAgnqPW9gyqQc7Y2G+M/dXWF5Doa
	lprf1Ik9kUEXwk8IZGyLg8PzQcvIQrBmpN0UOrev78/DKY6cqLy2Rr32T2GQ2S4JTXm/Jv
	Fzo3lrYAs/htsLZVB2ACZ54Zq9txgSw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DjGUgWjS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773240950; a=rsa-sha256;
	cv=none;
	b=ffHXq2iggBsd4Lc0uoKE2wFKDb/SrazQyNfYddML3wUgtoFKnbnlHNC6PqlGmLoH3Ww78R
	r/cNliCQI8wZ9yLSsb21vzPPTKzEyacKIIj6nc8y+aJa3hm+84Ee41FKvYs42l32mkzzsS
	qAqW8FvrFmrAgvynEcmeoLARMO7j73I=
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7d74d6bcc00so1769a34.2
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773240949; x=1773845749; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=coDqJI1op4oYDtjwGdTFlrXQKPgNyvcAEUeJOHUa6Vo=;
        b=DjGUgWjSvOrJK3thyMsb//SLrmBqlVlTlgEBediQQre1BlezrD6hDT729VoIyMc6eX
         yl/OV3Z4iPZTJu58r+89/Oc66I19fBYR49I99FwUKFSmxAxb6HVcCpfd8mfZHmAKmBuH
         6ldOBERT048eKeTl6Mvb7xXgJuZ0Wl9l1wCNQY2ZSJ8xGhMe0t2QwkvLitm+Jit6YEbV
         WLs8nCL0GUmOSob35We4a9POAFqGVvk6Bk4+3CdYIKyUfWJvL1CVrXY4aI8bXBPAr56h
         47EVr8vBMI/pBiPSEXbye7a2/t40At9GIcTumsnGWTrMzMAaqA/8zQt77k6ALHPqt+sN
         pz8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773240949; x=1773845749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=coDqJI1op4oYDtjwGdTFlrXQKPgNyvcAEUeJOHUa6Vo=;
        b=ZR/WWD0lyzglQIevJnJLJKH19dB5Wr0lD3DjjLKwpnG1hf6l2RbI6BDeynw1LvbJHg
         hxaKKQR3RBSTYASOgJSb6Y+DHqfaJh5J1vbBQHLfGOBbRoSwLMf0FLKioFCtYF8W/JOR
         Ayo5Z2vQcZDOTU6/iFVV9l1T5TddHxIHxgNf93Ymvyalh2AXmymz+abO/yxy5a0lfx0b
         YfVDxsbEUMPSH0ZJXpUW6Zr26Lp/K4e3jZVKMVVh0H/e1QpBrd9IIMXmdmEHMLSRgLfg
         FOsHphPReLGEWU6N3cRx0+8KPjVdqzB8QbFu5Ro+aKOstsanl7fbg5J1yrkAWomFT0WU
         C4Dg==
X-Forwarded-Encrypted: i=1; AJvYcCUUjAKV4xnYdZgDx7edeiXzniXxCaBmZTPzYKawTyw6e9NgwbXNWu+LiffVHnRjPFzqj8OcIsAGKA==@kvack.org
X-Gm-Message-State: AOJu0YzotsyXTsuF0RM2Fz/+wAO/y0rueqHuCcRCCTPyrEG7UTeqDiBX
	A0AcgBy17dpIqoazBKKEQHHbo87QJdgIBKqmXa3YcO09sRRZL12lR2Um
X-Gm-Gg: ATEYQzw6rRUsYQhSeiRQsKdr7Bp/TbyVJip7Q/41s8tabfAGKs5XVgawMd9LhD9qCSN
	Rly1LYupBcZwq/KZ+0N/NiHm1/1mKXZnjfDghzTOSZFfq/9YW7tHLj6LwIjs2JEcaRqvA3cmCMX
	o6VRBEI43qY52h1MIrnFDjTij1WaWuYK0AFev8mbDsI4OlLUOrYXkYDiG/Sb3fC2wORV9TuK009
	jP94/aIH2Xeo/0zkkDaIyTNiHZdPuIylg3gnIwYpc3ntrI/ALUokykSLg1s2ckxWha29fNifSAz
	hxPu6Izj+T91I3eMNd8bny7BgyzmJegi8okY5ZPAZfO2RnMqL/nwAFBhwRIKce+M24SFcVvQXnS
	g7zdMG9kDMBcLyEoDguvMCRxHeXaDbZ8MhUrQxQFrrJBlZTFMsK9L2t6dvd+6kLhbnxMFXWyG6O
	Ez6vGSuUGi+PG/MNpYoZ5Erw==
X-Received: by 2002:a05:6820:16a3:b0:67b:c7a0:e4fa with SMTP id 006d021491bc7-67bc889733emr1799649eaf.4.1773240949468;
        Wed, 11 Mar 2026 07:55:49 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:72::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67bc9336db1sm1433202eaf.14.2026.03.11.07.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 07:55:49 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: akpm@linux-foundation.org,
	alexghiti@kernel.org,
	kernel-team@meta.com,
	akinobu.mita@gmail.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	gourry@gourry.net,
	apopple@nvidia.com,
	byungchul@sk.com,
	joshua.hahnjy@gmail.com,
	matthew.brost@intel.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mm: Move demotion related functions in memory-tiers.c
Date: Wed, 11 Mar 2026 07:55:47 -0700
Message-ID: <20260311145547.2461611-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260311110314.237315-2-alex@ghiti.fr>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8FA4BC0012
X-Stat-Signature: jqtna649j75jjuzy8e17c8ry8mjbzuye
X-Rspam-User: 
X-HE-Tag: 1773240950-965482
X-HE-Meta: U2FsdGVkX1+Y4shaIh04hT+nFt6oH/ke4M8DEFBb87k9tozXVl0cF2znyEeanVuoGdf3Xqdh/ZfKy8rgt0ejj3UDblJ8sRfGfTU8kRHtjQBebyPrrZrYXFS2aQYzRr6PM5wI/gJSGJvDwTdzkxjmqPrXqaI/+82ywAhU/9wrNWlm4cIZbWZWxpCMSvPtG+wxHL2MmjVtDvMAuVRjGq1BrYz+IOG6ic1TZNm3dWCFb1BZzw7HVFNtP225nCdD2TeJZ5LyCmvnpm/QI2NuTKWTXGbHK/3VWXmuTLsLKynZfF/FqgjrVzqvFZZDWUQ041eDvB08yBk8AxSfT2/ryVWDuXri5czoQxN/2j+RF2cL1VnxxhJllqv8HUKLyzDi9yqygb6im1OCF3leZbieWGOk16NOFQLdP8jj6ZdZJrGnU6M3kVlx3070vnRFm4+B6vrM9tMVagbpFY08T3ndc3G/6KS3ierazwpB5xRk2iqHwG7Ld+cXQE6ZhexMBFhbM3luNFCqYHL2rEVcOkoENryCltUlZ6myCOUYPjWHuBIKWlYw3iHiWF8wzSXuok78WkGRQPaIw7nsXo/yTkn/wNTOZ0KTqZ+GX72ryYrr79cI95SB3g3Ru2DOEWAkBIShefo1VkadT9AcGM7cJ8qNpoK3yKdorA0WzKf3soEsyZrJ8yut2kAoigsm+yXO54ns/fgulqGaGNONr0U3u3m/7mUeOykfR5YGdPFGNf3bQkS6lTNOPavmmOuzR3I5TnlGZq1smELRqr0JX/Pa8v3sHiKIIyyfu0LqBnVAYwXU7k6Hjj9I5S/SloR7nfw1nT79HBbkppIi0AiN4TTKzKz44x49keYhYxio5Kn1ZyGznjiPf8OSy5OdIulBtdKBY5r4IuntyAj3AEBYshcIeD4G2JZPwjotXaWvr1xwvx7F7STWdDrnyP1f0SM0tlI6pjnIDK0C+OvRcXMPNtHudXM7jlg
 R4KnWv85
 jWSwWQoKYRRFxlHucNzSf4aZnvmoA+MAjNVpO2kuzoZ0Viq1rRhrHiGUFkeEvBQ4Tw85K2OUBU9CmzAeQ5NMdmXznCXoGme19Wag5qc71LrCVwcG5paQGG6yrnBPplMDU4CmqfCKcdpat0EQ5Djk791J6ac0aXXV6s7OL09VZ8cpnbDXLC7XvjAAUuhS+GoaHcO0OZlU2im2m+hzElLI/gsjm9aPTbcSyoT2uVGlfFjGPYYGcdkGY0YtcbqgnU5LId//o+MkRrxOPS+rO+QJy9u17Gk04QL0sjWCQHtvxUSN/uLPaSn0bXov0MKzGJutjR2LBVCU4LBP+mZnPB0im5Um9G+1tjtvZUBLB2Mc2paD5l7Zo/0G+eLWvFgc9LbV1Ul5vF7O8F54xYOaJ56RAwUW0OJm1RBr9z+7fhxXsjH69Emcuhq5lqbaAFGGqk2nBeqPhcwcmM37OX8VPOrmyLUbz8MbeqdOGc5Cr7f0/4koljWugfm04Mc6U0TapQ0AHzKxuptUVdMyt8SJVhrznSEgGdn06XpTmfbIexTz8WSajrauCf+ZOWvoc+CBdndnb281/z+xi2CT8+eFltXArCuA+dHNTYkRowpP9+Ui3UpGf/ju9VmoBTtaI/BSlJpoITyai
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Mar 2026 12:02:40 +0100 Alexandre Ghiti <alex@ghiti.fr> wrote:

> Let's have all the demotion functions in this file, no functional
> change intended.

Hi Alexandre,

I hope you are doing well! Thank you for the patch.

Makes sense to move the migration functions together. Just one small
nit, I think the following comment is pretty helpful in understanding
that folios that aren't demoted still remain in @demote_folios. Should
we also move this comment to memory-tiers.c?

[...snip...]

> -/*
> - * Take folios on @demote_folios and attempt to demote them to another node.
> - * Folios which are not demoted are left on @demote_folios.
> - */
> -static unsigned int demote_folio_list(struct list_head *demote_folios,
> -				      struct pglist_data *pgdat,
> -				      struct mem_cgroup *memcg)
> -{
> -	int target_nid;
> -	unsigned int nr_succeeded;
> -	nodemask_t allowed_mask;
> -

[...snip...]

Anyways, the rest looks good to me. Have a great day!
Joshua

