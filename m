Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25CE2606A32D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 08:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=boqD8Jr5
Received: by kanga.kvack.org (Postfix)
	id 4F3A76B063F; Tue, 24 Nov 2026 03:27:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47C686B0641; Tue, 24 Nov 2026 03:27:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36B886B0642; Tue, 24 Nov 2026 03:27:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 137DB6B063F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:27:18 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A47611C45E2
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:27:17 +0000 (UTC)
X-FDA: 85469332914.15.1B02755
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 13E622000A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:27:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=boqD8Jr5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795508836;
	b=1TyEWxU9138ukWa5/nlVrVrrB1LemQii0whHaf80b6D4RX1SHM5Pa5Hbbs5KQpBSzE1PYc
	j8MntrjbSTqSja9WZg3760eULJwgRPdbQn2Jxsy1J0o3/6paH3+clWo8Q0204W43+9JPKb
	Jd/fks5+fLtZCTJzpypj03hjfo14UJQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795508836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hQcy+J0Q27okHFSIG61ZS/kukvTSiukLlG4lterpEAo=;
	b=JAZOk9Pdx5BrKyR4WFGijmmlBxZAVqvzFeskVScWDqT0lq3yttpB/AjQcgJZYHCFrEC6Xr
	eJ8M+fhLypnOVVHHve6oF7uUgRhAvqnuMDa9s11gva2uW4N+nMavH57FOVdbb4P04SB6r5
	b6fgWz+BFP4O7aFdzUC1rk0NtnPKjos=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=boqD8Jr5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 740C560A55;
	Tue, 24 Nov 2026 08:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13DAC1F000C4;
	Tue, 24 Nov 2026 08:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795508835;
	bh=hQcy+J0Q27okHFSIG61ZS/kukvTSiukLlG4lterpEAo=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=boqD8Jr5nch2TD31AiMaSKkiNroCZ7mGESH2QHNH1pMQIBTB7IjBLEY0KHG5M1pxB
	 eU6QsNYc8kyUeB5Txid6WdGM9bfbY7YrwX1vOsQ4mg4OQGzL7qgcMiVrW1ngX8kCSV
	 leaVcrqdGsQg659aCaZeKyEtIpztAqu1sTbUTNUo8gR8mfYPcLVv+J+UluoHqUe0eP
	 duvXvnyVzMsIoGa3zV+fYRHXjii9S1nF+xAJ9lInKZxuAqBk1u0jxP9TjEK0pIkCqS
	 nJZbIHMb6ROINwVN6glswsVpjyH6Osi6shRQYbpggQFa/8xTljk9JhGIqh/aT9/CZj
	 VVhUksjBT1e9g==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com, 
 byungchul@sk.com, david@kernel.org, gourry@gourry.net, jannh@google.com, 
 joshua.hahnjy@gmail.com, liam@infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
 matthew.brost@intel.com, mhocko@suse.com, pfalcato@suse.de, rppt@kernel.org, 
 surenb@google.com, vbabka@kernel.org, ying.huang@linux.alibaba.com, 
 ziy@nvidia.com, kas@kernel.org, hannes@cmpxchg.org, riel@surriel.com, 
 shakeel.butt@linux.dev, kernel-team@meta.com, baolin.wang@linux.alibaba.com, 
 Nico Pache <nico.pache@linux.dev>, ryan.roberts@arm.com, dev.jain@arm.com, 
 baohua@kernel.org, lance.yang@linux.dev, Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20261123163301.1568240-1-usama.arif@linux.dev>
References: <20261123163301.1568240-1-usama.arif@linux.dev>
Subject: Re: (subset) [PATCH v3 0/5] mm: fixes for THP migration, swap-in
 and device-private smaps
Message-Id: <179550882470.7632.15364862356979603217.b4-ty@b4>
Date: Tue, 24 Nov 2026 09:27:04 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Stat-Signature: db8ysui13x7cuoo1d3f5suw4wiswafwq
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 13E622000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1795508835-940429
X-HE-Meta: U2FsdGVkX1/IiMChdNEsSdKZoCeWLQSURWYONm/W/hpHq0iq32RtENhVhxJ45tMcLBWj/TZnyt3OQYWLFGEAtRzscz5RtRus94Xm99n3TkwEg3Wkp8ywI3JHiAKXS4HF/+yBed6v7cyxLKXz+73oiRYCziVa7q5ae0AJ1rxiGBPOVOwUR2Q/qMRla6NZmOtDCzZaY5SRO3J+n/lZldBOuUaIO2A9T+ei3QCSW9QmU/6GKToTLX21jrdxnAvH48fWUMYvUE1XPRUWd7qSWZzKB6irIxwbZZRtRKlfhP/w1oUfvogH/l9PpfElIvj94ndaJCIiKUuUXleIgf4g2pIwRzeq02RNZaVLGMx3skb52E9n8T47gB5albp77kTWoSrlIU9wS5OcYCE/ZKFspwVAjbs1C8eWaN6gYhmejT5KtYyi280+52kVRPapfY/RqDbvtHm4uJraJHVjSbTnAwPGp3A2qI5x/Eya8sgoprkQ7KRDfoj5heTyApwqvybIwD8pLBETnGCFwVuBqnrxuzDed45LF/VYXUeJo4rdQ4HUD7NbGnykkbBTwwoUYrS75qjiMNSYFcw8TJ7/w29y8Avfmv4XTvJNm3Ry8fA/5l/UTCKNRnwB07yHx4BI33IsAED4BvD77ftoeOYKkrIs73KReIBztHb0MoSzAeCnZLIZ/sh8UfQWzyO5OJFlGFKQKUIeVSaSA57H2kl2DJNfHS4Z7cF3hnGG4TxTP7ZGjZwT88gSljqmlVQ/j88HLKV2esMUW+j9oZ2qdriEnITiO0jAT35AIcy5PSMEVS1QHhWnKznLeh1rRZZ0YxxsR6GUd+Cy2vL5BPuJ+Ff7itsoIZQPJt5qi+CDF6ODqhMkhJls286UlFpvqbEoBRW+6nBHLn3m5Efcupev9RNMlPzCfYd9FfgMJ9Ex1ISgSV0LqIYBxkcc92axgklOIHTNnAPzpmVel2BWu+9/67mAVApTZss
 9ITIHtqe
 x4z7N53Do6jgNR2ht4CxrYsc7nnRYnrE4qJfr95+yFLiQe3RMiK7oSi8FwFMukjNcFDMbiYKeuq3R2rWlHt8B38TOgD0ruzXIWtSEZCVfT+3yHGc/osjdPCu62FhwA1uWP1/X9TB9LcxUvlyQJej0bbrlLiw2ThenaRhAn0EuIaf5DvN4K3hf6jybrOTuIHi6k6CjeMijrgG0o+jNca/A9tM+1t4mIvzFSUHdQZgpFRAALSiprJF787j7llPVSe5Fp/RrcoNglz1fBud3jNMKijEs/Pu7fHAWTXaGbEJTJ+p/bjontlJR7SfoFNQRZq+D0HsE3zs1ZVvLaTW0oUoVukVjK9hf3bCKt3ikPaTROpLC4EqglNIg/eU1OYRSLvg2k3kHAGoNI+oesFc3PO8JRi1FRCpVty3TrdmQ3O6ub+rHTJ6WyGBAtFMHOREpCDDJAgi1KZbMCPNGRxH/D7WaO4c84PqE9dvqm1da6LXn1cETgjGCmKOOagU7+CNmR0oKnVFlPkKTElHyIn3LYpGV+FdBbTlxT1NNPL/Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 23 Nov 2026 08:32:06 -0800, Usama Arif wrote:
> This series contains four fixes for existing THP migration, PTE swap-in
> and smaps paths, plus one cleanup. They were extracted from the work on
> PMD swap entries for anonymous THPs [1] and can be merged independently.
> 
> 1. Avoid a folio reference leak when concurrent MADV_DONTNEED clears
>    or splits a migration PMD before the device migration split helper
>    acquires the PMD lock.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: core-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[2/5] mm: don't PTE-batch a swap-in of a folio with a hardware-poisoned page
      https://git.kernel.org/mm/core/c/37d4eb7d

-- 
Cheers,

David


