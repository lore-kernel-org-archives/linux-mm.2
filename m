Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80D06FDEE27
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 16:43:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E88496B008A; Thu, 23 Apr 2026 12:43:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5F7D6B008C; Thu, 23 Apr 2026 12:43:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9F3C6B0092; Thu, 23 Apr 2026 12:43:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C83BA6B008A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:43:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6EE601C01B7
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:43:11 +0000 (UTC)
X-FDA: 84690390582.06.1F107B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9F93920005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:43:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y48yIR67;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776962589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rg4/rbO3ZGDWi1Az/qcfROL4icB/3e+FtvHi40Si5UQ=;
	b=CaOdQUcjSCAJY7n3QHlVs07C8a3v4RE3V3ZPFKy5/K1RWK2TR1l4Ta8MDnqqOnw7sw96pk
	f6jLo6NbLojnxpcg0r6ANjC57Xq4pKPVQT6OyC1TfLKfS4EXIEgQ/Ls5AlhT23aNKYzjrQ
	3lwmzD65qIBYuPv0M9MwiZNXhmv2zuY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y48yIR67;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776962589; a=rsa-sha256;
	cv=none;
	b=8YnXRS1JbzjJwhpzBD2EdCFa0QEelj45ywJzkaS+xvlo4Z7fEEvUx6hYvggJdAmtgcmmQC
	aiDJHbVrGVBj4XDsGqN2GTWR3IYtp92wiNAEfx0AAOyFKWt7fsoXNOUfYUz/YTrQ5W/NbJ
	wdDfykI1TN28R4zVo7cOafzK30j6cTU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 91BCE44062;
	Thu, 23 Apr 2026 16:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03F6C2BCAF;
	Thu, 23 Apr 2026 16:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776962588;
	bh=PbPs/W4+n3I7+0udzca9mgH75HU493tf2uasPDZI9eA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Y48yIR677BPTn8wzenQY15Cy8LxN5kt7WPJJXzr1lKd9Lk1jv2GwGPBAThNIpO2Ye
	 AdtpFceEHKJru/iCf+mZUf62f5m8sE6Y4JKBj5eS3GALtSND+fkQXahsZBb6xKnKp6
	 Mf3saSepeov0+zKGvO6pUHcZmP1mK4lyuRrkVjbxBuitOqyOV7i7W8XfgQ5ZzFZMKl
	 PANBDADHEJkHKi47hf8hrKMD4jFW8+WMBHuLluRYZQxdVIb4uyyqYy+UzCTnnfNnnH
	 Kf20oN9hYLO3vKWFOKHqAIr3Bb86x6Ek+VaZKTQ9VMCqiU2+2aVVsxFHOLDXkDJ2Ow
	 scZoKtxrgyrlA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Michal Clapinski <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Mike Rapoport <rppt@kernel.org>,  Pratyush
 Yadav <pratyush@kernel.org>,  Alexander Graf <graf@amazon.com>,  Samiullah
 Khawaja <skhawaja@google.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  Andrew Morton
 <akpm@linux-foundation.org>,  Vlastimil Babka <vbabka@kernel.org>,  Suren
 Baghdasaryan <surenb@google.com>,  Michal Hocko <mhocko@suse.com>,
  Brendan Jackman <jackmanb@google.com>,  Johannes Weiner
 <hannes@cmpxchg.org>,  Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v9 1/3] kho: fix deferred initialization of scratch areas
In-Reply-To: <20260423122538.140993-2-mclapinski@google.com> (Michal
	Clapinski's message of "Thu, 23 Apr 2026 14:25:36 +0200")
References: <20260423122538.140993-1-mclapinski@google.com>
	<20260423122538.140993-2-mclapinski@google.com>
Date: Thu, 23 Apr 2026 18:43:04 +0200
Message-ID: <2vxzmryt631j.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: kmmuyc5phbumj41mz964px3c3ikhsxsk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9F93920005
X-HE-Tag: 1776962589-433439
X-HE-Meta: U2FsdGVkX1+DZojKks3s0/koZ4XPL6Y/AbXvBzQzt/fcIwic7rBO+YlP/wi45VidvvXlIyXpU7JM/IkowIVmipw9FT4SV0IHP5GkYmEUYnfIv0zUszMEpUzNLpzS9f8Ci0v54QLngcEI7SETgfP0NHcgzPXSDW3RK71xIMm5MZXx1nOLIEdFzMUHIo48hHEzQSgsqOVDv9zL/U8kWcZ2CkDVqU6iuhYGrvAmqfnB44dgovep+JQijOZ2W5EFvTw9P/rT3YsTxzE4BYgDdbUaF1bM/oFOf/gztI9wzsPTkNrE+cHUSGxM9LSY+lMG9QvCE6s84drooFUFoypRuqmT2Kgf/caq0y6fzTqx1tMS7uWyWk/ftrFZ+j/bsqKDQmkdtkVtxhcB1iAUlKb+QQvfsvxhMu02x7B8uldfzhES4nHjJmgIB25zazAcETkJkbGpFdFFuDUJIQzHgdWU6Es3FM+fMqQpMyVyH+rp4Vs7xGONmL90h/JhBDuHXbLU+beug6E8A1x6fXgEngnjsTfkRkg3AMukhJVg0I8Sw0SFbAIyhlBlCWUElw0w6K7SO9E+D0m0Gr3pt6qLjzQHR9LfRr7DTmQbOrS1g3bKahFZtS+iwh3wd+316Jguu0MlzFj9cfjl41OgkGx7ZspsFbxvA3oup/KAxBWhBqpy/nuvDbxYJqQ4kF87m/t5VCRG3ScmhC28W13S56SojzY2sMU4Z/QMDrGzCcNgDd0BIYcmnC8WzJGLXtUJz6ZYp4kUCSTTVC7boO7bCBFfpOa9m7wpcr0lA64tCk7Ls/ZgopKbT6NEjPlCCxBQeG9RuOiVbyGbV+lNVuaqzyze6ipngHwVdq7JRhk0YjZRfukS1joKnWyt3BUIRZOAAfJMbqVKXQFshWKnRyEaXJOiXrjM61qDTP2H4xkEzrQ46zz152fxGLxHp2v85ShtBtYgOO9ctU2Eq8XOn9EGeiIIDYqceTc
 X83rjJFk
 Rc5jP8d+1cwIvcjmcKSCGDOXsTVZ3CIXBuP8BKjo5Z78UyekQctJ16Qe0/HrTEotkT90QEGKdHVyRLKoZ/TbRtNo7qGvsmzCfbeYGhgrhzsFQYCwDZ8KsXs2K4KuoAVn7U8kyoepyeVQk8lXibsFZfkKKE+gmkkmBI7H8DBUWGCwlf0/DdByQ1vwQLCqwZPMZcV5b/NTv2JBa3y5rgEVmxRwI9M1pF4w1vh+3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23 2026, Michal Clapinski wrote:

> Currently, if CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled,
> kho_release_scratch() will initialize the struct pages and set migratetype
> of KHO scratch. Unless the whole scratch fits below first_deferred_pfn,
> some of that will be overwritten either by deferred_init_pages() or
> memmap_init_reserved_range().
>
> To fix it, make memmap_init_range(), deferred_init_memmap_chunk() and
> __init_page_from_nid() recognize KHO scratch regions and set
> migratetype of pageblocks in those regions to MIGRATE_CMA.
>
> Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Michal Clapinski <mclapinski@google.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

