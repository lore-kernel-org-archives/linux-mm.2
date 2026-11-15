Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C88F606A327
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 13:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DRjjD37o
Received: by kanga.kvack.org (Postfix)
	id 560BB6B00EF; Sun, 15 Nov 2026 08:20:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EA876B05B0; Sun, 15 Nov 2026 08:20:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B46F6B05B1; Sun, 15 Nov 2026 08:20:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D2E76B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 08:20:49 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9292880739
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 13:20:48 +0000 (UTC)
X-FDA: 85437413376.26.F7CC492
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id F3FEC20007
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 13:20:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DRjjD37o;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794748847;
	b=2GXqyp4f9P3vm6m/689NECCW887GQLDAcXMmgd1vElelEx/8cdbCOmETcA4e2brwZ5OfS6
	+2DkTi02wV1yIfcc+r3mU2Xh7oi6+IT6a9TTS6Y7tGU9CkEy4MruMGd98O3t9Pwd+Vw329
	c+qasV3rtNAgec1iWa03kWU8Y6VK1EI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DRjjD37o;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794748847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3HSpYZj6YASoJA+imXKaJoXcMOdYb9Ti1RP9kq2Y2hg=;
	b=n7Tld7ENLT6m5GzuWSAaoe6HZg/mhGuDDIEzwwOHRHPkRvK+R6fZ9wtlSVk6FYTfd6igQl
	VL+TrkETJQ1QyKaXkE68zg4O8IiYRuzyAyehjdta+4I1226C/IaoNYFAAtCcstbs9Pis7D
	UrcHsVrIxOAgJc4olt4CaV9rYqHf9qo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 567BB61242;
	Sun, 15 Nov 2026 13:20:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70FA1F000C5;
	Sun, 15 Nov 2026 13:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794748846;
	bh=3HSpYZj6YASoJA+imXKaJoXcMOdYb9Ti1RP9kq2Y2hg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DRjjD37o9epMl9rk++f6bxSbCSOylmn8X7S+JIBOaotMK/yq/ad86XJXU6Tx889av
	 7JFOn/doiAJ1dCfAxgMQoi6QHqXNO3KHdQYaCTvDEwU3QHe67DCPbcHpd01kUOeZAQ
	 2dhgQfZLgdawl5jkYieWz/gj+I3Vg2u7DFBu1mkQ9UU27HcpoJnCJDTM8o67T+4glw
	 G5KqZsTL2Rdkjp17sKIxEHEolEcG6sTtZ66w4TI6zWkMBiVtfK1t0kCaEOtpse0CnB
	 Y20RM1wwrg1TVRpjG16LjHhUHSt8f6X7EaQ5q6W6RiH6Y6QEDGhzY7Ux26AGrwho7X
	 /vBXHf7wO+6kA==
Date: Sun, 15 Nov 2026 13:20:33 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Yu-cheng Yu <yu-cheng.yu@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, Chris Mason <mason@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>, 
	"Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH v2 11/13] percpu: fix contig hints that are too low
Message-ID: <avmpMjM-nrzifxYP@gremlin>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
 <20261113-mason-migrate-et-al-fixes-v2-11-50a2ed382b61@kernel.org>
 <20261114115708.18fff016c293a57b@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261114115708.18fff016c293a57b@chrisdown.name>
X-Stat-Signature: obci1k3xm945tpco7o45n7se8ju7xsoq
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F3FEC20007
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794748846-62278
X-HE-Meta: U2FsdGVkX194aR7X4uknhzi/c+HypRkrYSqDE+LwsngA6bvOhDJgdG8BWQ2h1XJwmvwjl2Z+278dmuQINOr7926z38rY0T7FEy3HW7CXsuFZVz8VWMwrmw1v6WfLfvxvxDOjVQ1W+dDD0TYPxONTcTfBcGFCN3+m7WH3VX9PPhLGhy8TBTjcWBEx6FBOsk5+C8xuT4q74ayg6cBkwU6GKRmrgTBW67r4Yxd14ucQ4TBaOiuCmu1ZxXTY7N7r6yzYkAR81dYxetCFaPqnYDVOvOF1/Mwtuek6Kg6VHEhn2/aFV9FYSo0OfkYCMUWf8yq4CBPcR2bhN1DypPzGvVnlN2smFJnCLUcqSRJRUW3BdQE3AfLShAx1JxRVpk9zR1ZlJdfQ7QJDVnbTtgch1i1ED7zGA/jP/nRNXVd2IF+/rYJNJ/697L3PQ/utbhYKFKscQlRNRPTiBSTmgdBYl/9Gq+8ydmLw6CrUK+Mn4osnuK/JX11MwWP/wsNf1n1ol1PA13rzR4qmwapg9hYmKB0L5kssy5xhl0ZmYy1Ns34UHh50Dv9EtsSCeYVDCT6f53nwwKxkg3+j0b4t32LLmeIQ2aNEtq7hlyuaaScBxrT+vpayDieaW+n3RUG0bRuI4HLzJFdgxDXAInoJlQkiaKUklFjFyg3mA7Dn3r1WrX4tY3U4a+wZjBjAw9jkf6+uRNX6WxRYhe5dPJwKHGldPudfbvKDaR8pHXI1Lv/C1ihAde6WOomB81Y/7S7pWa4qfK+jqsPYng6/UkXye2sY9Rm/iaxcg1utnJbR9UXTHWOlDz6aiW6xhop8H5B3zon5B93qih0mCVBzVO4Vxlkk6DhDqu4LhC3knFPf/EUsAPpLkIQ5Isi4K2rv1GIShTpTzZe4Rc0HQl7gYV76qalYNrnEteQBtocNYUMz8rypjBB+ehtL5eIWp+3sQSxkwiu+C/x7iyK4QM8FRKWhrb5HzhZ
 5xKpGwg+
 aO3ep0O8q00AD2rypEs/SWu15TOvbCIcRITHLdi1+WUOj0VGaYJxxVxy0kHmD4coTZ43P9G5PnZZtz/IM6y9H4i63Ui0uONHsaaLRY0KBOdLcZX0oxH1gTPZCOx7S+SkSG6t7Grxv8OuMiWmqrBKhL0Lz/aD3p4BrP38XfSLgE/qT2xhY+1KiZb2Kng8xCJTONuL4qjl1XdQ478P3FYem3n+pio7Dhftx9ywrzTRq0kTBaBw7Xwr0EIjH7Y0sJnpbQyeqpSrlqDwtcH5eCfm8xnSm4941C+/fqqMAyb5wGkrKK81TB2nZWdIi2Bj1KYoxzpphjp8ujB3P+g3TftXKrfNDrEeTYtGqBiSl2CSrzsCirqJz1ggI5FC+8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Chris - a lot of your replies here seem LLM-generated, and this one in
particular seems especially so.

I've been working evenings and weekends to help with the workload doing
_human_ passes over already AI-generated fixes, so please have a little
consideration for that + keep replies to technical points and as succinct
as possible, thanks.

On Sat, Nov 14, 2026 at 11:57:08AM -0800, Chris Down wrote:
> Hi Lorenzo,
>
> Lorenzo Stoakes (ARM) writes:
> > Secondly, when a free stays within one block,
> > pcpu_block_update_hint_free() passes the end of the free area to the
> > chunk hints as a block offset rather than a chunk offset, so in any block
> > but the first the chunk hints are not updated at all.
>
> Joonwon Kang sent this part earlier this year as "percpu: Fix wrong chunk
> hints update" [1]. It has Dennis' Reviewed-by, but as far as I can tell it
> was never picked up. The rest of that series goes after the scan_hint
> problems by fixing how pcpu_block_update() maintains scan_hint, rather
> than by dropping the promotion, and Dennis was still reviewing that in
> May [2]. It touches the same code as the first case here, so the two won't
> apply on top of each other. It's probably worth adding Joonwon to Cc and
> working out between you which one goes in first.

I'm sorry this is (AI-generated?) nonsense, that's not at all how kernel
development works.

This is a series that got stalled 6 months ago and does things other than
this fix. That doesn't put an indefinite hold on future work in the area,
nor does it give the submitter a veto or say on future work.

So the submitter is welcome to resend and rebase on the fix.

In general, given that this is a drive-by review, with respect, please try
to stick to technical issues, thanks.

>
> > Thirdly, that free area stops at the block boundary, even if the free
> > bits continue into a neighbouring block.
>
> Wasn't this one deliberate? The comment this patch removes says that
> chunk_md->contig_hint may be off by up to a page, as a tradeoff to avoid
> iterating over the block metadata on every free. I don't mind changing
> that, but it'd be good for the changelog to say so, because any free
> whose area reaches a block boundary now ends up in
> pcpu_chunk_refresh_hint().

'I don't mind' :)) for some reason you (or rather persumably your LLM) has
adopted the tone of a component owner which isn't quite appropriate here,
let's maybe try to avoid that in future thanks.

The changelog already covers this, it states that a contig_hint must never be
smaller than the largest free area, and lists this as the third way in
which that is violated.

That it was done on purpose doesn't make it less of a bug - the hint being
too low is what causes pcpu_find_block_fit() to reject a chunk that fits.

>
> > Fix these by always rescanning when a contig_hint is broken, passing the
> > correct offset, and refreshing the chunk hints whenever a free area
> > reaches a block boundary.
>
> Similarly, da3afdd5bb54 ("percpu: use block scan_hint to only scan
> forward") and d33d9f3dd96b ("percpu: use chunk scan_hint to skip some
> scanning") added the scan_hint promotion to avoid exactly these rescans,
> so do you have any numbers for what always rescanning from first_free
> costs on the allocation path?

Nope, I am reworking AI-generated fix patches and this is currently broken,
it doesn't require perf numbers. It needs to be made right first.

In any case the block rescan is bounded at PCPU_BITMAP_BLOCK_BITS and this
issue only happens if a contig_hint is broken.

>
> The result does look right to me, though. From a quick check with the
> hint code lifted into a userspace harness and random allocations and
> frees thrown at it, contig_hint regularly ends up below the largest free
> area before this patch (for both blocks and the chunk) but is fine after
> this patch is applied.

OK thanks.

>
> [1] https://lore.kernel.org/r/20260513085117.1024175-1-joonwonkang@google.com
> [2] https://lore.kernel.org/r/ahVWu38ymnSeLnv3@palisades.local
>
> Thanks!
>
> Chris

--
Cheers, Lorenzo

