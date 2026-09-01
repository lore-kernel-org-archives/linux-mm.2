Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49FB9C61DFD
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 00:10:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22CA56B008C; Mon, 31 Aug 2026 20:10:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DE6B6B0092; Mon, 31 Aug 2026 20:10:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F3F06B0095; Mon, 31 Aug 2026 20:10:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E04186B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:10:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6BCFEA3E23
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:10:34 +0000 (UTC)
X-FDA: 85163261988.03.719272F
Received: from mta0.migadu.com (out-205.mta0.migadu.com [91.218.175.205])
	by imf02.hostedemail.com (Postfix) with ESMTP id 43A8E80002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:10:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ITunBtkK;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.205 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788221432;
	b=8O4VQvY6/rIrT5oQnzX0odXKRSyjaQK+Sk09mNzQu6oURomadYCFlyt1bpK8CnvUP/LFLP
	uP5ZIeQYO4quNLaF7pMtyJotdxNXAouqjnIeVTpr9/iUATm3GoMpSo8Scv0sCoMW7qnjRO
	MYSVefs5SjymoPfifuqcb26404S+F7c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ITunBtkK;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.205 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788221432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EjG81uEZIPJFDH4SvLWj57xdYuN9tqC6Foe976Y8yCI=;
	b=uhfJVjGEgmkCxDg4W0CQAVtWOuLNJPB3tmAoThy7NPjwe6MB/PWpkxAl4K1uqzP6L8mC3e
	xXFog1PtEyhHZCfCS3ogRG+Q0Ppeu5CqI791ht1Xc3EvivYj7i+3KQlkB52VUGsHSzQG5C
	9NTAxqeded+CUIHy6q/zh8IQsg3lmOw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VQbX7qhToOCvYZznvKl5y3u5IYIy1k7DJaMvEMrWF3o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788221429; v=1; x=1788826229;
 b=ITunBtkK/NT4jO42SRKAOOg2g1BDKBBRYyfAggpnSAGCw5SRTUOdqd03HR8hCJAxAxv9Od09
 5o157Oil5G7xJX5PHf3K/UdC6hDNSo4dQvP6GEAY3ze9Ovk2xJPODjOPbaU4GJkixnCUCLEAT3B
 U3Ear1tIICST8W6BcbfOQ7Ao=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 69816a8805fc6742;
	Tue, 01 Sep 2026 00:10:29 +0000
X-Mizu-Trace-ID: 69816a8805fc6742
X-Migadu-Flow: FLOW_OUT
Date: Mon, 31 Aug 2026 17:10:24 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: Don't call schedule_work when no spinning is
 allowed
Message-ID: <apYXCL_GJs9Ovu0v@linux.dev>
References: <20260831234339.280376-1-stevensd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831234339.280376-1-stevensd@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 43A8E80002
X-Stat-Signature: ybscwsceuga9mri8bb9qenm5imber9iw
X-Rspam-User: 
X-HE-Tag: 1788221431-506522
X-HE-Meta: U2FsdGVkX1/hLeSJ9KqMyZ4nMDGSWBaji/mdKmr4Ksk/kH/N6Suh8KKelMsij8B45jhnmU5SQnOh2t8DOjS6J+P+epiT08IlDO3VF9eAZ1SsOhmHGTDr8p3bUDuiV02yxGC+QR/fQWEOch7QwM1VpqnF1H4sb7H6jtHcU7FLajDlh+Q3OQSvdLz2Lxmk3hTAEI+OvbLo0Ug5NZwQpCSRsUsIZQb7BrD0vqUc+NiiPAZ/T+4ezvxjzOMwIzn4/bzgW2BoJWUyBPtdJXSMTZWVtuFycfF4cOfb/X3ydJtmwua0Za8bGf8AZu/vsIBd3VtHkwdUx50ERl6qYoGnUdlubD3/nS5vFfDqwyaFTTnU0yAM9RDMdW7Bwu4r7ilVxl8yaycPq3ocKsR46fVlKS3w0TRk6VPyc/PUo/Zfyjgy/xJfcybBIjY1zVMGjInMpAVfpWmm2IWw8Eq3q/3Gh518HPVNP82Bb1r/eNE9fb2a4eIfr2Kk4izijloaNukCLXh1TwIoYsjeCEEyb8BCk4DfN8LIBWZaVtTC9XDnwmOlNTKjUYgHD2+ndObpZwi7nZ4SO1ashwrfn+OrKFx2YVX265IKDMiKPQXqR3XtPljG/sgLu4uVwJdEgSm9V5t6q5Ga2Vo0epc9BLgblH7XVVWT/2EZHGQ78uzOp6OFSjVQhgrzF294/AlvokNaBmW7g3NCzSE15W2yBoyuwBj8Kbu0rYbZT6J4pPtY/TDNbt93glS0HO35QZRjhcRbcf1C5xy2mMdP25yu/+LLn8MoDILJzZX7VzoT6WT0RULch71m30GYGF5qg9UB/PbShv7XA4BGhhyy8xuWxtJ4Gw57P26wxhFyNhwy0pf6OVpUcPnJkkQBIwamQGeGT1CMG9z2DQmw4QXK77RtD8W+VcDT0RuiYtsiAIcNPpWNjZhZNiln8ATFdd5fn1PlraewtfBfKzatTQvj7ledaXbQMO9Iopu
 IRedqOu4
 1kYhEir4X4k+mUw5gZr7yuw5HLxFrtJMLhR6+0hsuzYWwa9yYXAe/TDe1+KQyqLNbdOjTqPvIccFW0xDMrsQ1tZipB/X1X5W4yE2QfPE96mdnPOyRMggodh/PMlODtpnBbfWR/yZ/H22lhxf4V+UMDnSYv23tMzdwIdEEP0ZIwQgYHJwK163A6muxkGr/ERK9zf7vX8UxLKTa4BJJ3IsRE0dGZ3RFyGdszQk5pSl7t2DX98PxpRD30mBMRuGRVJAql92J+5T/rIRLvg7iE2OGy2En+WDtb19d+94VSXpKOl4dWkd98nmhAAiSoQK5nTpZz4PATYh/of3v65oIubGNHlwWeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 04:43:39PM -0700, David Stevens wrote:
> Memcg charging can be done from any context, but calling schedule_work()
> isn't safe from an NMI. If memory.high is breached from a context where
> spinning isn't allowed, use irq_work to schedule the reclaim work.
> 
> Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")
> Signed-off-by: David Stevens <stevensd@google.com>

Did you hit this issue or just code inspection? I assume this is the
done_restock code path.

> ---
>  include/linux/memcontrol.h |  1 +
>  mm/memcontrol.c            | 12 +++++++++++-
>  2 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 8170bb8066a2..036d973ceca6 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -219,6 +219,7 @@ struct mem_cgroup {
>  	spinlock_t	 peaks_lock;
>  
>  	/* Range enforcement for interrupt charges */
> +	struct irq_work high_irq_work;

Instead of adding more complexity, let's just return if we can not spin on
done_restock path.


