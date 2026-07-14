Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21AEFC44507
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 19:53:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A82B6B00C9; Tue, 14 Jul 2026 15:53:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 158016B00CC; Tue, 14 Jul 2026 15:53:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06E8A6B00CD; Tue, 14 Jul 2026 15:53:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB8FC6B00C9
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:53:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5E8CCC049E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:53:39 +0000 (UTC)
X-FDA: 84988432158.01.25683C9
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id A3BCB40008
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:53:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n3Mw7wBp;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784058817;
	b=afPijVJuiJny0z0tR4zhurKC5X0ajpV6eWZ9QpZ974Y+pMlOn2xGpOGonciWK99t/Io0pQ
	0OHMS51N7DTtTZrr1K8YlrGexN5ZNQumfBEoaM3c9iIs5FkxaITd/1qQ0wX+k+tYcA8HkA
	aoJLaS8gb6WC9irXvqKzsfgVqY/HCHg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n3Mw7wBp;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784058817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tzALV2d53RJaMjFjlVkiVRur0WMV7gOh4zd/yZy2+NI=;
	b=0GIlfRB0f65pJmPCs6K0B0A3sZBynGO+TwSE7GXiMc7cmNxOKbpYfhkZh8U8u4sZekYKAF
	viwUJi55IvwQuJ7gIlaZXhlT40sGq8v/Is33iv6zS3iUJCUNwKhQhPrB8nGixclkcZUmts
	plrQOWlibE56I0PAn0wuBxbbgSd/34U=
Date: Tue, 14 Jul 2026 12:52:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784058816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tzALV2d53RJaMjFjlVkiVRur0WMV7gOh4zd/yZy2+NI=;
	b=n3Mw7wBpML1vKHir0x9lBaLY8AeH32oim58MtgrjP1ALriUDJi2hACH18GAMpSacDzsHvR
	Qfj2fnw0VhK2ogHSCyXuWC0nrdoWo4W5MbgWwIRrfr61OemJmsDycoSza7ko9AMaVkKHBa
	Pexlkt9xv2thRYcb+6ZduLoiu/a1ggg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcontrol: update state_local when flushing NMI
 stats
Message-ID: <alaTdskwkIgNmJS6@linux.dev>
References: <20260713085053.2916813-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713085053.2916813-1-guopeng.zhang@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A3BCB40008
X-Stat-Signature: zpxmmdwyxxddntmj88pa1hqoenixxa78
X-HE-Tag: 1784058817-25673
X-HE-Meta: U2FsdGVkX1+FO3kcW5eh58rNbT/fa7Vmsu4r7S799QLKVyevyTquoHSQ9I3dRld+0XydYoLVjJpr3v+jw5CUfihi3DU04yhWG7knEELcmfI7mAt8kIaFLO5QvMQW0Ubdnf/NbTn+3qF1vb6TWfLfeYMZAtJx0hETWoSyf58JJWfuDyyZyeUCGLjiXiH5DgH51Oz8V8WwQtXORQ2pGz0wPbIDxqgs5mIvm6EU/aOMRNjcaoTP/C/+6P5BJZBm2lF7ikqcPf9AvsJyUNjOkA0zf/+QxsjXRMDqkX5AwAdGKQ+q4UFjlRX5z3TC0GOoI0nVNSb1aJIJb+fiAWiWHVJrWvJG7WgtXMjhlKQTVyWgDUmgUTo5trHepNUPhimV+DTbfW/ya3VhI1V2S+tR51cqALyfzP554ObSFKOGvk+Q6bQHCtFSUA8TghdqAJkIMdSYIZHntS5hSRxhC2acLUyVBWEF4Qolh+el7WGUUB7TDDCMjWlxNL0SZV3EeCc6yvBrw1eTyhGrw2Tq8JkEB37RsWClwJBmJMuOOuYUkZNguxN/XDWSZ650CZQL3ughggTPw8QSvcICDipVYXeWX/y0etdWLgO0QzVm1c0fqSFrZzbcfX3E1MHymWg9Gg784LJ3nX9nVtmW/rfH9HOvmVpwfrSRjyRaumIBk9oWEiJkKa2q534rMR7+qV4CMtZTyY94hKf5fSX/lAl5JFxhcy5HP5MGA81EiKXFUfhK8vZCgMKzQJCWOVHKH4xP2YxeQKroM9H9bMUmm7mwAhu3NZFn5LDJ9aSY40CB3Nt3kpx1i/GC5zqX5qobAhP67yP53ZJJA02HmsTznFx9H864GhsjohV67/iF9uegJNG4eLktP75kUKmO4UYoZlU+5Q1dMB0GWi4dMZgxk1zcLwXkwVnE3/FfDnKccl8MSsnbksqVLRi36iKjM1u3BYFbxpDECzZAg7Zn4h/b8qVMFii8EYp
 hvg2ArDe
 DV0SCGN48AePyDz/e7JruOUOeTvQv0e2/bxHo/AVeCX42E5KNVPeRii/efbRFhA69224XzTkKW6ob8veJ5yjJnnbPw5knuv0JynnFEDPXe+JsocSspHcb+HWYLtmqMM16AdTdXlDAWB7BFs32OkXF4YeH88OrpaBZdpODQbfOkjj/oHFt2zUXyE4YHFpJ75N4LPPQj0fFGbQfvopBIERVHm7Fy3LyUy0UutCyKFIx2CYnN30k+htF/rxO2SzqQ35k9VI/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 04:50:53PM +0800, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> flush_nmi_stats() updates state[] for kmem and slab counters but leaves
> the corresponding state_local[] counters unchanged. Local kmem and
> slab statistics therefore miss updates collected through the NMI-safe
> atomic path.
> 
> Update state_local[] together with state[].
> 
> Fixes: 940b01fc8dc1 ("memcg: nmi safe memcg stats for specific archs")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

