Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C851C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 20:44:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 554446B0088; Fri, 11 Sep 2026 16:44:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 504456B008C; Fri, 11 Sep 2026 16:44:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F2A26B0092; Fri, 11 Sep 2026 16:44:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0BA1E6B0088
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:44:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4BBAE160362
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 20:44:19 +0000 (UTC)
X-FDA: 85202659038.02.9F0D587
Received: from mail-qk2-f11.google.com (mail-qk2-f11.google.com [74.125.230.203])
	by imf11.hostedemail.com (Postfix) with ESMTP id 30B014000C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 20:44:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=g8N5nwxT;
	spf=pass (imf11.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.203 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789159457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FDi78tn+rNyw2f5XP4H8xqn6L7v0YajTpN+MIEXmNi8=;
	b=RyrES8GO9ipgl/KmbdN1TfGtGZ3SKPNd4pUOgtDX5SWmnklxKAZ2g2yKudNbi2u7K1u657
	NlAJtkKSNYnFzc/mIO8Q2DPQVs771qsShn9ceaqdDKiEbAG87SyxVb73x1+k1BIUomNyX9
	0R++XxRXZhut7v7BN19j+q8HdUnxsdk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789159457;
	b=Gr/kWhrJ9chSTlTCj6ZYPl2J3rhYUGXjMHvlx2o/iNszoHwMz6HFJtn/5DMDQsj9YnZ2kA
	jAlsXutNOTWG3F9r5tp5+wuJ9ZxQXhUpxE39jOc23aSK2Ybkm7lOOq4cySQBbSem7hS4yn
	4N+Hm/CxXKMo7lvHOLm5qawwPTg+ZR4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=g8N5nwxT;
	spf=pass (imf11.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.203 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk2-f11.google.com with SMTP id d75a77b69052e-530cedd4e6eso1825971cf.1
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1789159456; x=1789764256; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FDi78tn+rNyw2f5XP4H8xqn6L7v0YajTpN+MIEXmNi8=;
        b=g8N5nwxTr7YMvOitFx1xmPyrzI3n9pRn3ydnXHjZcfH71TzhcvqOO8nQ63Otz46mMM
         ZTFXhtaFvEEdZKBG0Tw618mduTxjNBaTNZ87+70KTECOFh+nAc/T99uQ/UhKAMSXhhlA
         E4STJSLlBbg1vaVt2NVOYtcRjovf6mgghmLAejWTrPFUnzSEF7LbXFm9nQ49ODIwI3lF
         jNqi4tqlE0574+uYS1jX4KdBXxpIjyA456moCbTCErKDMkzzrypNC34ucJIMCjesHLW2
         HQJmJcOGjMEEMdSjRjCk66Y+U9hyQIYOtN5QCGQ1dcwE/XcO1pXiP7LZxEib+vOS0iLG
         /KMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789159456; x=1789764256;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FDi78tn+rNyw2f5XP4H8xqn6L7v0YajTpN+MIEXmNi8=;
        b=eIAtWruJPeilgI7f2Flcc/gfdlUj0gVQijNvCHkvUK3kf+HboATXkaHwpD+7x7hMXt
         K9mBBE8MoI8tjOLqwUVTKl5dTN/uAgyV0p8OLvI6Wj7HF/SIJrLFy3eoYqHpuWFCApeE
         2HTBet71WmxTe/LVeUQtkIuotc6XZw4iCrm+6hkuhAJc+ysDNOyw0EHmdwPQ6HmdHvJa
         9b9dwLzJ9OnlwKk1AfCVca+Zr3ced88hFuE6D1eWsx8D3cBnjwrOlhV8+aXb/H0gZx1Z
         rkfhLaM2OIuvjfvbUbXvf2BkeDT+wHt6//8L2CNz7cwhzmAirvMADCfOmJoHT3ciZtZS
         j/Lw==
X-Forwarded-Encrypted: i=1; AKwUvBzFqVQ7koht7HHIQSYGx4nwb1YR1xa1XE0X/gOcBE9XW2P1rK5tEA3Sr3n+f7CxVns3eXjIf+Lk1Q==@kvack.org
X-Gm-Message-State: AFuF++mIlhTGuSvxsLg6ZkUAEJBSHAuckbT49KQh3jZU6JX1J0CqXFc2
	mfHNolZJsBuWMc+9MxMkaiZSmDXDQ1D16FtoQab5uvbqdZz20ytFcwpeNk8iS//InvQ=
X-Gm-Gg: AYBFou0mgd7e0pntf13hG8xdoZhyBniAcFSXta1Lb3lcElPCbAu9g+gIE35OROVNc9f
	Wyf2kto/bAJSEg8M8gzmMkPjWllFihLPXoofmI/Zb+XVk1RQQasIBdJBxOzBnQ+3k9gtAmLwVjI
	VzfOB6xhz4S3YLIC5WqYzjDrN1TGhg7r+jKmEyeIALzVbOUiAIZquaIhCFWASoCEYN5iaxPAl3L
	dQzRWuZcYjOimctSzM7e6L6VIAcumXIE5sl5NFqyxMQ8s0RMOur+3UTDAauDsVgLOdmOtQ8TazX
	y/0Abzqh/7EQANRbrvxuBuveUPTtTwSDdYoxSGf2aHrop4km6q8ZAAcwh28wHXvl9wSKjFO4+U8
	4zPS5nMQcjchRj1Z9VSvxzGXfsOgSXRRZsjFjEMXuvIZggYWp62mEjR3laTiWQ0V/ot7zyDMgtW
	/eu0ZiMzAYtZBoPbwX2G/DOKYJNFrT9tQgBOZ0E8rpvq+sRcHIlnawbWq33zSh0h46RGL91A==
X-Received: by 2002:ac8:5e52:0:b0:530:dc5e:27b8 with SMTP id d75a77b69052e-530dc5e2fb1mr37003331cf.27.1789159456019;
        Fri, 11 Sep 2026 13:44:16 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530ca511ff0sm28939081cf.31.2026.09.11.13.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 13:44:15 -0700 (PDT)
Date: Fri, 11 Sep 2026 16:44:14 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, abuehaze@amazon.com,
	akpm@linux-foundation.org, alisaidi@amazon.com, blakgeof@amazon.com,
	brauner@kernel.org, dgc@kernel.org, dipietro.salvatore@gmail.com,
	djwong@kernel.org, jackmanb@google.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
	rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
	vbabka@kernel.org, willy@infradead.org, ziy@nvidia.com,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Brendan Jackman <brendan.jackman@linux.dev>
Subject: Re: [PATCH v5] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-ID: <aqRoHr8XGzzDUjBk@cmpxchg.org>
References: <20260911142102.2294202-1-dipiets@amazon.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911142102.2294202-1-dipiets@amazon.it>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: eqzt5n73emkim68sqie65j1mfogxuoem
X-Rspamd-Queue-Id: 30B014000C
X-HE-Tag: 1789159457-602155
X-HE-Meta: U2FsdGVkX19sZaRnX6AXPlMcB5FB1klBpLzShB0aOQdoh1SPvW3gnkZn8diQnr0tKFUtpUjE5+4KXGZgeOijwajtSrrTBt6X5K35XQwcppIv/wrYCUB364YvLXk9WMkv6AF/MpwBv+wvTueIhVUbmNzrJDxfZYYB1KIAn5F4aaPoAH2/S/CcbAFv+h4nQhbG859feo9w924W/fHsAATRF3lPDDLWxTQGhmhFuyg0nnG1T9VZ9kXepvC+v/Alvex+71l5ojhpGo5da0/65od64zbJtpD+mCOSzdCgKlWbxQGinBYniKolHgz8gx1Oy0AXVw39+YZOxZ4OkuLwBgcQz6J0WwQcCoa4nD5oodxd5vCCLwPbSbuJ9zHYFTHgJZ+NWEe7/0sZvU0BkPn8+c7hhSki2LcRdTTPlEs3UXW9pp5d8J41zLtJks5TXxB4es5zG13ZhVWWJBVdVoz5H/mK+VGyZKT/0Vp3s506BV623T0Hxv9BXa6dx8xyRXSQgddX2DBeNz4ur/b4nQT2DMUXwLBy09OBlj+5AF/hLyWDdfiTAzWualBaAxYTrHKqrOQqOeyNp7Dq5TTgkGfITzVfkO+4xtla3yUpz0MhviGGDVSPHyDTZ2MOLcMn9CT6GDr9MukJ1v6cyWpV/BREsuh/wK+mzcEGl6hxVP4wHeepH2lIOLpm546AYWt7WXXSI2SzlKh5MFuhznhpOCUYiQikZZOr3HrtuCefjuFDapXMsSOvUW0fQ9Ih89bDQrv4KWMeWDfQNmIRSHwbCDefANBuoKR8p/sQkBqbJm/WY8uVt9qeL5dWHt1LpSZtGOa/mJ+1oVe0qYNFdIdinJZv9UKM8BZHhO64pBBbJTWpsevG/rKX7rvx2FztxHhQa1nD0/P3olnWMSdm+HEBvmDeVClWZ38ZHF+yoMKscfpSOdL5EXTKuHv71yZ0/1gheX0rbUq25Kzkcl3ZFuGwVszOj88
 iwOtNVNl
 ha0fiN5nbO31WpIyDi5biGJQceZclGMV5P1XxPLhTCxXPjKj2b0nPTKKlNR4yKX8HczSA3GM1Ngq2PMFVQ0ONeilasABeoxuIeEVVnJSf4m/QskONAnNoW2tX8nHCNqJz3eetmwoJe56zZsoHGF5hSJbpzsCK1q4FC2bgKWqfNAmJILD7osL55TzkuvwqIIWetr23d/85+m6iCjfkOqSRswUoWJwnr7NLE424Fu5H8o0s5l7zl/QSut9jFJFaVtZ1Xvb7Ah0OUKu4wWh+wfT+oG4wNQZvUVNXG0v1A2qhOzLJM8Wi20PM/cQFqIow9MHFuVieXVBOMyOLdOQXg+yIRRaMTqsDZDlTIpS26Mf80LrUftP+X1tmt5eUTBTXOljuEiBMmhEqD1om2qSIDFMfWS3y5ZOsbkJZvn5nabt0QqGAoJZJR6I1GUDt3noQ0BwCvvpEAuOd+e1ISRExzfyRAag4Bpm0jqeHgpDNth3fQCrHAUMXbQC1NB7QyNZacNLH/69mo4RUUyE9ZcXxVAAGvd/9FwEVroKAyiY8dmDGdzAM5+/yVTK6r5wMoxAeVjGur1iuaNk2+sPeCHwgwc1GZtnncNj2llTJv0G+6WnoJIUvpjh9u0K7JEm1gFpdXBP7GlUO31Nk6mZUkkx46yMt+wIax34DvenYSgTCNtPmCs1TXIONI2lQ9CvDNZPB4Cl+MUUrcnWJve6rTqpx3+g6ec9TA+GSe2VFV64AdzkbxZweMXI+871wPcCF7NUXbjyp2TGF4RpHAI4xDMO9dS0jxsE6qMFv4KcmZ0n73UA+WQwinJETigwb1RgwXDKO7SErx+3heAK242y0H66PbJbXVqIbpOby5pKyMjpml39l7EQOHwMIlYgFsZr9+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 02:21:02PM +0000, Salvatore Dipietro wrote:
> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> introduced high-order folio allocations in the iomap buffered write
> path.  When memory is fragmented, each failed costly-order allocation
> enters __alloc_pages_slowpath() which runs direct compaction and
> drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL
> pgbench (simple-update) with 1024 clients on a 96-vCPU arm64 system.
> 
> The root issue is that direct compaction is too expensive for hot
> allocation paths that have fallbacks to smaller allocations.
> __filemap_get_folio_mpol() already marks higher-order allocations with
> __GFP_NORETRY | __GFP_NOWARN, signalling that the caller can handle
> failure.  However, the page allocator still attempts full direct
> compaction for costly orders with __GFP_NORETRY, which is unnecessarily
> aggressive when the caller will simply retry at a lower order.
> 
> For costly-order allocations with __GFP_NORETRY, suppress direct reclaim
> for the whole slowpath by computing can_direct_reclaim (and hence
> can_compact) as false.  The !can_direct_reclaim check near the top of
> the slowpath then short-circuits to nopage: no direct reclaim, no direct
> compaction and no drain_all_pages() IPI across every CPU.  kswapd (and
> in turn kcompactd) is still woken further down for background
> defragmentation, so compaction keeps working for long-term system health
> while being removed from the latency-critical direct allocation path.
> 
> Allocations that also request __GFP_THISNODE are exempted.  That flag
> pairing identifies the local-node-first THP attempt issued by
> alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
> form transparent huge pages.  __GFP_NOFAIL is exempted as well, so a
> must-not-fail allocation is never made to fail.
> 
> Test environment:
>   Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
>              12x 1TB IO2 32000 IOPS RAID0 XFS
>   OS:        AL2023
>   Kernel:    v7.3-rc1
>   Database:  PostgreSQL 18.4
>   Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s
> 
> Results (average of 3 runs, TPS):
>   Config                                       Avg TPS   % vs baseline
>   AL2023 stock 6.1 kernel (pre-5d8edfb900d5)   136,942           n/a
>   v7.3-rc1 baseline (no patch)                  59,408             -
>   v7.3-rc1 + this patch                        161,994       +172.7%
> 
> The patch fully recovers the pre-5d8edfb900d5 performance, bringing
> throughput back above the pre-regression level and well clear of the
> ~59k baseline.  The AL2023 6.1 row runs a kernel that predates commit
> 5d8edfb900d5 ("iomap: Copy larger chunks from userspace"), so it is not
> directly comparable, but it shows the pre-regression level and confirms
> that the ~59k baseline is the anomaly and not the norm.
> 
> 
> Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
> Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
> Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/T/#u [v3]
> Link: https://lore.kernel.org/all/20260904115629.3993331-1-dipiets@amazon.it/T/#u [v4]
> Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> Cc: stable@vger.kernel.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Dave Chinner <dgc@kernel.org>
> Cc: Ritesh Harjani <ritesh.list@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: linux-mm@kvack.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-xfs@vger.kernel.org
> Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
> ---
> v5: Derive the decision into a local flag instead of mutating gfp_mask

I commented on the v5 variant here:

https://lore.kernel.org/all/aqQlUr-1h07G8JWM@cmpxchg.org/

I think v4 was better.

