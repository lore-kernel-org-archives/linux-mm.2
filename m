Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A26A60D547D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A9P4FUnI
Received: by kanga.kvack.org (Postfix)
	id 635EC6B0630; Mon,  2 Nov 2026 10:31:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E6536B0632; Mon,  2 Nov 2026 10:31:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D5746B0633; Mon,  2 Nov 2026 10:31:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B6106B0630
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:31:39 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C3648A42AF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:31:38 +0000 (UTC)
X-FDA: 85390568676.27.E8627AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 341E81C000E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:31:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A9P4FUnI;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W3bKDA+quit0g3eGuAHVKjEZpRe39g1X8LJwoIwngJw=;
	b=OdnmO9P6R2XXgjaLKh0x8l54PqifZevd/ZtAPf90n3VPYhv6xVD1uZgMzdWCnExH0gISkQ
	ABGB6he3Vzq7HNo2hchwjI5QooeJGRrAUZ2gUTShZsvU3MpyL9kRnU0wWOx3eK7ymC5tTB
	Vz4hp5pAnXgkP9dw5Q5yM4PHBa1kvRk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633497;
	b=2bl1W/e7qf5wejQ9PvudRWVk5qPJ8pDCYDHMrpuUlVbwvaHMcwX3gaf65BMbJ8jvCUsPoF
	a+TYDzdwzErsp8Vo3kT543FxAFTHmDTV+iTQKwbBGxD+UPQoAPliXOplIFH52vv7Ugjqry
	Q/pfr8SHecIuMn17eJHCCiJu0zbKVMU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A9P4FUnI;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BCA736060E;
	Mon,  2 Nov 2026 15:31:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DC71F00A17;
	Mon,  2 Nov 2026 15:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633496;
	bh=W3bKDA+quit0g3eGuAHVKjEZpRe39g1X8LJwoIwngJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A9P4FUnIMjOoXHquoWExcAmGTi+XPLBRObDc6nz2ViytymE6virICCAEcQD0uBUTV
	 /HSz6HrBc0g1ee/OT8SVVI06OT3yelSfCuueEDHSHdrJHsUYMsagLYGlb6AY4Kr9cq
	 QvRvHoaC1sg/ZXLwTYsAaM6BumfQ/2N+RzJv9T3c3SHgWwZRm51XPTjmmEULJUkCzO
	 ZCNyntvd/c3GEiY9g8uliMuqeSdBQ04an0lVxl7cr+BWCDHqXGELHzhRFSpC42qWc9
	 llX0tK9Lab5YLdNTUUepU63h3PKQuRQq/rOhKi1VMq41uK9/g16ZHAVE7wZwSmgjkj
	 GYqbQbuVNcQCA==
From: "Harry Yoo (Meta)" <harry@kernel.org>
To: linux-mm@kvack.org,
	Puranjay Mohan <puranjay@kernel.org>
Cc: kernel-team@meta.com,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm/slab: Call call_rcu() directly from __kfree_rcu_sheaf() in any context
Date: Mon,  2 Nov 2026 15:31:32 +0000
Message-ID: <179363289502.4042338.4516017907377007645.b4-ty@b4>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261016155340.3304319-1-puranjay@kernel.org>
References: <20261016155340.3304319-1-puranjay@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 341E81C000E
X-Stat-Signature: z41u8pdt664umb75ms8p5nfeq5cppize
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793633497-678508
X-HE-Meta: U2FsdGVkX1/he4YlaAc7aVI1U0q52ZbemjdTEIrwBSBLyeqrFDI+rYMRC++TCHQAcbL9o+OPfAp07oTXVnTm0/cXk6Gr+YQUn+ooC9avlOBqJrcCDCddbRzpwIvL+4Vz5Xajve4N/j6nFrlxw/Dlm34Er0IBu0l2uHgSQWjh6RYTQXCjspTbyx3uh8BGxBXnI8ZGS8U8llc4U5XhezXWuOpObCcdiyTIEFX+eiZtY/XMSgbvDQ6fRWgr/IOQl0slCwmxh7h7HZZzRdjVVFI7imtOtU2+OiQmFA0kmg1J7eDduDAXIEHEmTXy+ryuQa2J+kZychqv9tQln8eI/8rW9Uaj5NEllkpl/VbRQE7ljxpYlnNOKsHUQYua8VLguYowBUMvxmVIQpn7ytOOlGaveif3vYO1PHf+qC6yvv26AAEJ9O82jQPCs1nEWkIUZT7O+ROtNIq7RSz46n9usekoWxJLdrAfrQr61wX6+nt9yX1lQAgth1FBEvxwS6UrMmAU3BOorNHzu4X5dkdRCk/RquTXOgy5nDjM5TSlatwFC144d20mcpvH7wHsBk1U6svx72HlStWE5OGfqqruSqQvfIsxaUQMVuifjpuuJZL02iM/H1gkKX8oDIJd2S+UF15l+X+8FBQq8pxDvB815KqrR6XpbCTFTws3y+5N+4ODXMzXfiHCqCvii+s2oSsypF4YiwuuhkN16d/D7+UXX6I+MJhV3WzAkb/8KYHY+NGjPjC8GeWOjP9uKZvLL2rvpeJHIH0nL3JwhXmeVR9NIVSc3Q1AayB7OTtayiFmesdXrld0hC6/C192Ye3wbi3QP6cXtr8JOqqqYovI/FeYu62/8iPOlTV8fSUhjd8F5gxDDzfT/tSQHNEYe/9bqfhXBBsyHjRsR/3hZIFGk4kXu+6/8w16zYKZDmWjDSt2zbFzFEejJIvJMvTFRiEi5NZEwSrLkS9c4ahj/58anYCvdJl
 nBfQSc2r
 Zjqg1LIUVGCnJUd98z4v6EA7GLaFntXdEx/gFBhyXBB54/tgTSpeVJE2Ra2N86D5EffJ6JfUtscU/UwZm+PTvboKCC1TJRvDdeARYudWgXaKq8HBjCq50E0FMcvzXmrAquP9rjWjcwKcypF21a46FWBasG13j0ZZwYmIuG2NYgtHGBTtbG9nDbdVhZA4mI906fYqFvoLsS0rzioSN337sD06iECbXTiscd9TBAaQ5Cos5aZlzVrBpA374dY1h+n2tERMNVnw4o2wCl0YGOioAHOOEJibl6GYO/W0kYJmAxy0jWaBrgX6GkIxbZJRjhLYnS0Khxkg2gol65yn7yj9wh050BtDQCHITmJOYY2H4KDuSL9x9hyMWlvo2wTbUQN77QdSN1CeJpuDf4ckY6nWjM4VlWuKNYfvMhhD+yj9VUNl+U0Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 16 Oct 2026 08:53:39 -0700, Puranjay Mohan wrote:
> __kfree_rcu_sheaf() can run with allow_spin == false, e.g. from
> kfree_rcu_nolock(), where it may interrupt call_rcu() itself on the same
> CPU. call_rcu() was not reentrant, so commit 69abda97a09b2 ("mm/slab:
> extend deferred free mechanism to handle rcu sheaves") added a fallback:
> when !allow_spin and IRQs are disabled, the full rcu sheaf is put on a
> per-CPU llist and submitted to call_rcu() later from irq_work.
> 
> [...]

Applied to mm/slab.git slab/for-next, thanks!

[1/1] mm/slab: Call call_rcu() directly from __kfree_rcu_sheaf() in any context
      commit: 55130199fc98d6f5177b4624c44ba47ca44f61c7

I adjusted two things:

1. Mentioned the commits that made call_rcu() safe from any context, as they landed
   v7.4-rc1
2. Adjusted a nit sashiko feedback to drop slab_sheaf.llnode field.

range-diff before/after:

1:  81b3beb05dc3 ! 1:  55130199fc98 mm/slab: Call call_rcu() directly from __kfree_rcu_sheaf() in any context
    @@ Commit message
         when !allow_spin and IRQs are disabled, the full rcu sheaf is put on a
         per-CPU llist and submitted to call_rcu() later from irq_work.
     
    -    call_rcu() now handles this itself. When it is called with IRQs disabled
    -    (from NMI, or re-entered from instrumentation), it stages the callback on
    -    a per-CPU list and re-issues it from irq_work. Callers no longer need to
    -    guard against that, so always call call_rcu() directly and remove the
    -    rcu_sheaves llist and its irq_work handling.
    +    Since commit af78eca13b03 ("rcu: Make call_rcu() safe to call from any
    +    context") and commit 0ed912d346fdb2ec ("rcu: Make Tiny call_rcu() safe
    +    to call from any context"), call_rcu() now handles this itself.
    +
    +    When it is called with IRQs disabled (from NMI, or re-entered from
    +    instrumentation), it stages the callback on a per-CPU list and re-issues
    +    it from irq_work. Callers no longer need to guard against that, so
    +    always call call_rcu() directly and remove the rcu_sheaves llist and
    +    its irq_work handling.
     
         Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
    +    Link: https://patch.msgid.link/20261016155340.3304319-1-puranjay@kernel.org
    +    Link: https://sashiko.dev/#/patchset/20261016155340.3304319-1-puranjay%40kernel.org
         Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
    +    [ harry@kernel.org: mention the commits that made call_rcu() safe to
    +      call from any context and remove unused struct slab_sheaf.llnode field
    +      per sashiko feedback ]
    +    Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
     
      ## mm/slub.c ##
    +@@ mm/slub.c: struct slab_sheaf {
    + 	union {
    + 		struct rcu_head rcu_head;
    + 		struct list_head barn_list;
    +-		/* only used to defer call_rcu() in unknown context */
    +-		struct llist_node llnode;
    + 		/* only used for prefilled sheafs */
    + 		struct {
    + 			unsigned int capacity;
     @@ mm/slub.c: static void flush_all(struct kmem_cache *s)
      struct deferred_percpu_work {
      	struct llist_head objects;


-- 
Cheers,
Harry / Hyeonggon


