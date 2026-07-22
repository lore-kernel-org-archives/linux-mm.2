Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDABEC44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 23:22:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4C4C6B007B; Wed, 22 Jul 2026 19:22:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FDCC6B0088; Wed, 22 Jul 2026 19:22:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EF0C6B008C; Wed, 22 Jul 2026 19:22:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4AF5E6B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:22:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6E7C0C0392
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:22:11 +0000 (UTC)
X-FDA: 85017988062.15.CEE26E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id AC33BC0003
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:22:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Z/I3qCih";
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784762529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fY1Ru2zC/iJcoq3b+FNLhPaZonLcvPq0ZmyTt7fDVBE=;
	b=k8rkY5ajQpucyVsxpCJW6qTB0qFtkr5h7OFrgYMwN0W9JIWMedtBIJif0Xi4pHviSr2Y4c
	rWbi2gM1q54WJKrzrYtTbk263L8wpVUZm+Aeg7HrbxRAsnPSivQnoWT0YuirVSgOY1IIpb
	kLzmRBewgqnHLs1f79SQG7lA+qsjjKk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Z/I3qCih";
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784762529;
	b=y+8cF+DcfEmPS31a9yz2oJWmCPP0OvzTSYVCX8VIk+3kgaht1a+rHj8aR5jb5YNNMbo6KV
	2qen4PNXqeEBGftqKOvBAGvH6Hs3D6YGLIqRj71w/n5+Fe78bylcOJJfbXOiE4XQd1Lq/A
	GqCbMxcBwIl+70goAv009sXFpwIbhTc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7AE4241A8F;
	Wed, 22 Jul 2026 23:22:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83DC1F00A3A;
	Wed, 22 Jul 2026 23:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784762528;
	bh=fY1Ru2zC/iJcoq3b+FNLhPaZonLcvPq0ZmyTt7fDVBE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Z/I3qCih2+SIO1TN3z9hZ/HcIz/TrW4SD33YNXg69bh5XvDTT2/f5sQ9dIlaja9i7
	 8D9B5aCITCzWsQGORFtLN/exM8ElKkeewacV90P4Kl4X/Ppc5lCMemuYT0YIorRhrt
	 a4/svc1oWR4Jhjj3TkOjjmj7wu+Ye1FBfVya3Qsk=
Date: Wed, 22 Jul 2026 16:22:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, Shakeel Butt
 <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH v2 4/4] mm: page_alloc: fix non-movable reclaim storm in
 defrag_mode
Message-Id: <20260722162207.31a2c491ffaf36d1e8948c14@linux-foundation.org>
In-Reply-To: <20260722150006.3848560-5-hannes@cmpxchg.org>
References: <20260722150006.3848560-1-hannes@cmpxchg.org>
	<20260722150006.3848560-5-hannes@cmpxchg.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: AC33BC0003
X-Rspamd-Server: rspam01
X-Stat-Signature: 8sqp959eioapietbarnmo5as38ytg79m
X-HE-Tag: 1784762529-497640
X-HE-Meta: U2FsdGVkX1/mPjeZo19Lkm+OwCx5tBxhySExnSELTLVTyhxZt32A8HlH0rb7q2lUvk55sPvCGQiyOkpX7DYql+7wmAY3AfF22eurA4/w1mrDeASsF6aEiYDVYoEF5VYwj7CQyt5LdpYAPL6jArqkY9NOtYl6LkKZI8wGeQEsqCbrGkN02Bj56c7t3JEd/28FS94n/dcZo9HTo48o6dqviY8t5WqhhDkTZKLEByUoGQE7E+Or9SZWSbB4upY8AlkBmxXjTfj7Nek5omrMITEy1qhXdwQpoM4O8FSf9kVqDWq8lnEmpzTVB+aa5ZMCZVx4lGPaAobC6isNSj30H/lWdKR8qdOsaXhW7yr0TtZyfftRFC1sFHBqTlRPzPy2V1/qwtCe8id6Y39B8fnDz4VpxLf6nq1fyqBJFeGge3Zkeqnw0qLOvW4HhKG9FKPeGb+/bioIeVp6QuVMN7nWsG9NOTTJv2liI7J9JguBNktCpnpaWUfYbDHY1gRKM13PMvl6sWCdYQy5ypN4DddHQqT5mybAjMG06F+RdkPMuZDdIlF3LdZCWQtJ1rXDkDW9f03ITTfD4qSuZEPBcx9l8NXaUbkC67y+BMXmy4adQuhX2AJOfw/h9mEnvycwFcXMaqdLBYE7evf7SblLrhqCPlopHGhCtT4n3f0zHX7lTSLjDPIT71iUeHQdXHkz6yRFOwc3VbJi+BkhGuN5oHG2RF5wdHxO+H0MxBTHCoyOub+r9KkPN+zXTf57j1d32fMA/9ps1yX9FPP3KHCyJtq9zdiDEwQQlZtCo7h8pjJV7dJsALr1EPFM78OSt/eFulFGxhV0w8vXzzgMSQ9gAmqn3WWevNJQj14sBlLnJ1PZPRTAmq8Fo9kbmnE46Yz/Zj3q5OuljTTGwp0LKvBtZDTgFCnQO3j6ToptMeWxRBrckqBHgTDZ4Y8hWc44UoKEYk6+M9kXIz4JstGd0Rtbg3aYcwo
 S6Mpsnxl
 HQVDdl86vAnCBF6a4H6xWcZL0pVOIocaaVrLmn7OetQyhlbqD6qn6FhXEhzsxg7Roe3WuVHPbtsD+M0L3Kfs/N3GGMUDJelPut5EB0B98HEinroz/KO4iN24+iJ8wArxTq30zQ+Q2ZPUMpqWH1mrmxQFk3X6OFXclroOxJTsxWR5OtPFkvLT6qHKNiO8wGOazilzuK5lIsb0N6krtgfZlFKaLIUOpXkfgODnLtmQci7deLSzpmh7FowWtA69/eRuInvNpTsoWpyBzhe3If79a6OjHMbO+ze51TmR4wtniJ5D0N/tzKFpI+1j0/xEZklYaMlzZEnN4C9dZNkj/wHoA6rIuSG9aRqTErGpn3kowhXLRgHpOUb86tljGp83YszjdxCXi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Jul 2026 10:56:47 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> As we deployed defrag_mode into Meta production, pressure spikes and
> excessive swapping were observed on some workloads. Tracing confirmed
> that this is unmovable/reclaimable requests spinning in the allocator
> and direct reclaim, causing excessive amounts of swap.
> 
> The initial plan for defrag_mode was to rely on kswapd/kcompactd to
> produce blocks, and if those are overwhelmed under high pressure, let
> the allocator fall back (__rmqueue_steal()) after its retry loops.
> However, that retrying results in more reclaim on some of these
> workloads than we'd hoped, sometimes excessively so, spurred on by the
> !costly order conditions in should_reclaim_retry().
> 
> The storms are dependent on the request type. Reclaim will inevitably
> make room in existing movable blocks, since that's where the LRU pages
> live. So if movable requests retry on reclaim, they make progress.
> 
> When non-movable requests spin in reclaim that isn't productive. They
> cannot use the individually freed pages, and the process is unlikely
> to accidentally free whole blocks to meet the ALLOC_NOFRAGMENT bar.
> They spin and overreclaim excessively, which tanks performance and
> triggers userspace guards like swap exhaustion or pressure based OOM.
> 
> To fix this, send non-movable requests, regardless of order, into
> pageblock reclaim/compaction. This way, they help move things along to
> meet the ALLOC_NOFRAGMENT bar. After this patch, the reclaim storms
> and excess OOM rates are no longer observed in production.
> 
> The longer-term plan is still to have all requests, including the
> movable ones, help make blocks to spread the cost of defragmenting
> more evenly and fairly; combined with proper watermarking to reduce
> allocation latencies in the common case. However, doing this naively
> unearths scaling and concurrency limitations in compaction that need
> to be addressed first. Promoting just non-movables for now is the
> minimally viable bug fix for the above issue.
> 
> Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

This cc:stable fix doesn't apply to current mainline because the
preceding non-cc:stable patches get in the way.

This means that the -stable maintainers will have to ask you to redo
the fix to make it backportable.  And you'll then be preparing a patch
which hasn't had standalone testing in mainline.  All very cumbersome.

So is it practical to make the fix come first, as a cc:stable hotfix so
we can upstream the other patches in the next merge window?

(An alternative would be to put cc:stable on all four patches.  That's
a bit abusive but we do it rarely).

Either way, I'll get these into mm.git for testing while we await
review on [4/4], thanks.


