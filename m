Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C474CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 13:47:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64C266B0005; Tue, 19 May 2026 09:47:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6239C6B0088; Tue, 19 May 2026 09:47:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5393D6B0093; Tue, 19 May 2026 09:47:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44C726B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 09:47:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 134DD1C1181
	for <linux-mm@kvack.org>; Tue, 19 May 2026 13:47:57 +0000 (UTC)
X-FDA: 84784297794.22.058A955
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf27.hostedemail.com (Postfix) with ESMTP id 407D940003
	for <linux-mm@kvack.org>; Tue, 19 May 2026 13:47:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=LXZTkNye;
	spf=pass (imf27.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779198475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sOX/BuYnD2WUZPt6d/a906G4y5m10XJ9vS/jNpswwX0=;
	b=MXACbErdujjRg4gp2knBq+Ls+1sKCwLG7hTnqyHiCaZDntDRgHmEgbPv7PUJ7WBLohd1Ux
	8HSYbzNSsE52Dz/Kmb8WvEvuNltP+95/FUo53on29WjSWhnnTfEhbzu8ow279gfcxr9GUP
	6BpkYfpBFnYg4H1y+Jc414VT/W5Do9U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779198475; a=rsa-sha256;
	cv=none;
	b=D4R44iga0LTJLF4/kpaitZXInHlgPLtAH0uNyHy4wVe0wdjLRFr6UNFD2bj3rgAvWWveEU
	Gyr3CJ89GyD1iFHm4N1qQrx7dol9fAtZJXN+tn7NNOK1zBmUO5qpkU2yZwW8TYj6RTA40/
	PrdYG3i3CHKMXwxQv9mVLV5VXFQQcX4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=LXZTkNye;
	spf=pass (imf27.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id B292FD081C;
	Tue, 19 May 2026 13:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1779198473;
	bh=sOX/BuYnD2WUZPt6d/a906G4y5m10XJ9vS/jNpswwX0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LXZTkNyesDxZZU56WZHQh3LeocgVhhsVYale4kHEt0k3MeVw953RuPWeP7O2iZY0s
	 fxLvE54SvEMbnH/9ZYJcdEZZsI/g4bxrQzRQbU6CjZ6LX1JF9POgI4UMtEmHdllXKh
	 FRMeP4sgnp6FslYkWG2DUPr+kqpGcaZK1Wi2gDe0=
Date: Tue, 19 May 2026 13:47:52 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/page_alloc: fix defrag_mode for non-reclaimable
 allocations
Message-ID: <agxqCE2juj14EhyZ@shell.ilvokhin.com>
References: <20260518163736.173910-1-d@ilvokhin.com>
 <20260518132422.8cfec729a4d7e974c87ace72@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518132422.8cfec729a4d7e974c87ace72@linux-foundation.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 407D940003
X-Rspam-User: 
X-Stat-Signature: 6n8jgnq9d9gp9oni8hpabt61zaaa33dp
X-HE-Tag: 1779198475-720881
X-HE-Meta: U2FsdGVkX1+JPHF5pIl5cdf47IdGQ7etmsVWpUEFA3Fn0L/ZBsafKoTPBSEmiGPnykMgBlllRlt6rOrb5LxHTo8WgsFQzbk/C2hZ4ZObTloFdc5sbkOhOBKFpiqtZbB1zYC1wMbjVu5sRsfNBXwg9tp33pa/WlzZZslPGRs8kWQiraZGmsqcYpOqZtEOdrmJzP9NvsNOK9yW7oI1OF2O7cjIzYRIiryK6CU1bZttG0Vwsm+2BpoW9ud/XAFiKrK9N3oPdqjabDuOSe6Q3Al4ieoWxcRckmuBHtCL2r7JgGFndJ7w7JksZL6/Nyg02Q+PDv5IwKdm6yxyA1FCRYVG+1ZCMHvcnQCuRO3JAzLcBMqgqcEm6eIGTNVGItrW895u4ZzxjfVLsH42onBc2k2IUxVfcDxiH5e7tWKBH0J4QYAwLl2DAgfAzP1WgPZZ1tGQQxNK6P7laZMqGTSg8TJT1hh0Knx/Z+SPq7PiBOzLpKr6F8QdhhgR00DZH8DWEnnRAaKJq9sx5PQ765kmr6JFjAySZKm6bvI9yWnekAR28hccilDTPSseUdOaYMdiiFZumeRw6kCUrpLb+ZgLeUHAsjWJ6bVWG4tvcE04rsZTCN+rmglkPDyY/5nyNm9sk9Hv1tB+FXgbEzKZSsfXtXcqVIEkbsZDFjb4FTNCrfpBwJqwSmvw8ZmB87UybqKMo+Puw6hfMeOvGo2yqWA6PPJNncNcYi3khqZ84Igqwxo7l+UkxFcY2TI8l9WoXulswfb6csusesv6gWuLQiH0OTJL4KeJ9PSV6AYe6voyXvA4WunAxCK1ykSC38OXgo4nN2AjzuiijUjdyABVQ8N1PCbp1UBUR6SJgAPvf3phO5EFtoLF8FLbL1NA35TgF1u4pLAOOxODJzCq0AzoFTrrZHTjGi3psKAufy9/la6ZCkUthJbqQXUaGc//Y/ozq8IyaX/sLFSWINYp93OgOsIyz9j
 Q7YIe15J
 5K55jYUrd8Xg3IXdPZF/bbwr3J0M9RvdYS9zE1IJm5U/54+WHFewi/lUwRH3lDXvD2dL1GS4rdGOcwzaurnmMvOkOKwH/gfAuwlvdwcf2JfHt8ssBmZRBBu5GL2EhstXdmeh7Y4KfRUMomv3/TLA4RXLU5f8brjpZK/0SYCmjrXsJKWhsxiG2ybwkf0DHPiTBLVYPoBLwfTvYfc+pkMlfRBXmZKBqsVfkirb+qknVgya0Sl/HFqrtAJ0a4XmLTCIVBOHruAXlRn24epvNZZjt69WmbX1hnZQS071fxApMbrn992az6m+bUQ44QYlhMsrx8/yjoFIMNbNls6XCTT0WoFRE4navpYRtpmvXL5lgUEVgkg57jwU3apYwlY+SKBaovZ63c+1pGRB6Sg2b/rGSqWMvCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 01:24:22PM -0700, Andrew Morton wrote:
> On Mon, 18 May 2026 16:37:36 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> 
> > When defrag_mode is enabled, ALLOC_NOFRAGMENT is enforced to prevent
> > migratetype fallbacks and keep pageblocks clean. The allocator relies on
> > reclaim and compaction to free pages of the correct type before allowing
> > fallback as a last resort.
> > 
> > However, non-reclaimable allocations such as GFP_ATOMIC cannot invoke
> > direct reclaim or compaction. With defrag_mode=1, these allocations hit
> > the !can_direct_reclaim bailout in __alloc_pages_slowpath() with
> > ALLOC_NOFRAGMENT still set, and fail without ever attempting a fallback.
> > 
> > This causes a large number of SLUB allocation failures for
> > skbuff_head_cache under network-heavy workloads, despite free memory
> > being available in other migratetype freelists.
> > 
> > Clear ALLOC_NOFRAGMENT and retry before giving up on allocations that
> > cannot reclaim, following the same pattern used after reclaim/compaction
> > exhaustion later in the slowpath.
> 
> Thanks.  Sashiko asked a couple of things:
> 
> 	https://sashiko.dev/#/patchset/20260518163736.173910-1-d@ilvokhin.com
> 
> I'm not sure what to make of the first one - we aren't holding any locks
> in there which prevent concurrent cpuset or zonelist alterations
> anyway (?).
> 
> But your change might violate the later comment `No "goto retry;" can be
> placed above this check * unless it can execute just once'?

Thanks for taking a look, Andrew.

Goto retry can execute at most once, since ALLOC_NOFRAGMENT is cleared
before the jump, so on the next iteration the condition is false and we
fall through to goto nopage. This is the similar to the existing
can_retry_reserves path.

Just for the sake of keeping everything in one place. Another point
Sashiko raised.

"Will allocations hitting this PF_MEMALLOC check, or the __GFP_NORETRY check
further down in the function, still fail prematurely under defrag_mode=1?
Because these terminal error paths also jump directly to the nopage label,
they skip the normal ALLOC_NOFRAGMENT clearing at the bottom of the slowpath.
Should we also clear ALLOC_NOFRAGMENT and retry for these paths so they are
allowed to fall back rather than failing outright?"

I think by the time we reach the PF_MEMALLOC check, ALLOC_NOFRAGMENT has
already been cleared, since we set only ALLOC_NO_WATERMARKS and
ALLOC_KSWAPD in reserve_flags, when PF_MEMALLOC is set.

For GFP_NORETRY, we can do direct reclaim (compared to GFP_ATOMIC case),
so we either succeed or not, we don't need another round.

