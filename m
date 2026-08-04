Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39B23C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 01:30:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 069B26B007B; Mon,  3 Aug 2026 21:30:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01AB86B0088; Mon,  3 Aug 2026 21:30:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4C5A6B0093; Mon,  3 Aug 2026 21:30:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B84426B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 21:30:36 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 390671A089A
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 01:30:36 +0000 (UTC)
X-FDA: 85061857272.22.C298459
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 65E801C000A
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 01:30:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Ycu282mQ;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785807034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t/L/MMJR8dfLGR3Oi7GZgsl7WMiqO1bZP6I4xwqMLaE=;
	b=BLpcbTzqxAucHPwzDBuWVEKBd9BCJFzHur0h+Hf7dyLhpVCsvwh8KPsv5vuzmf5ztyZkd5
	Y4oAszipp3cWF8LGop9k3riiIo2R0WOUsjEP2SbJ8Fu3kzc32U9rq8Vht3Hwn50fRDNump
	vxkIYKzAsl2ltd9KO3V7AEUKRrh5Fj8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Ycu282mQ;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785807034;
	b=Jmb4+XuLUS6gOkGz29aLYDJKjzuBmzQvuS2ER9LhInABd1Uthyb8/DoQd32Gip5Hu8nVBd
	+0sFZC3xsy08PnGurZNktfknFXdDAGuoDcmWikjzDyHqVo46WuVu0wAwlTRomR/C6dLwzt
	c5NtkDgzqWTjvW+q86ir+voO4lOVH8Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 78FBD403DF;
	Tue,  4 Aug 2026 01:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F491F000E9;
	Tue,  4 Aug 2026 01:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785807033;
	bh=t/L/MMJR8dfLGR3Oi7GZgsl7WMiqO1bZP6I4xwqMLaE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Ycu282mQQVXVyhwb+s/oovbJewQNWcYI0isihQpIIUDwxDv2mjv8gP8ew2FG8eQo8
	 rqVFTbabsZsx/XbrWPjYKUHCDS9FfXtiuLiYSNtoOSDjElzfR67KRJNF7Og+KpTDwa
	 FO4uOyGGJF1aOI4cO1gyy5NkIH8eqEGvi6Z+JH8s=
Date: Mon, 3 Aug 2026 18:30:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: luto@kernel.org
Cc: linux-mm@kvack.org, luto@amacapital.net, "David Hildenbrand (Red Hat)"
 <david@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, Liam Howlett
 <liam.howlett@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 stable@vger.kernel.org, dfoxfranke@gmail.com
Subject: Re: [PATCH] Fix incorrect flush address in direct page table
 reclaim
Message-Id: <20260803183032.7cc1fb1007d309c2431855ea@linux-foundation.org>
In-Reply-To: <20260804003708.49830-1-luto@kernel.org>
References: <20260804003708.49830-1-luto@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 65E801C000A
X-Stat-Signature: 8xt3g8jgcud111x6z6mwyqua6zgjr7yu
X-Rspam-User: 
X-HE-Tag: 1785807034-587796
X-HE-Meta: U2FsdGVkX1/xPZWLBu/TMOs6A44N0nceAonzUgKiO1kgmHJjt5FdHWjH5Mk4mGIqEwjlceC2pO/TPHxmdlP/4WSfK7O4/311UT9MMuOZsUCjgI1OUydgGiPRbIk5rwQQarjddCL96hG08fiQXlr5A71bnWBwuwCrO1ebtvSi4U+NQ5XLZtE556cFS3i58uu/WgoTX2JVvE+3SfCNbjVPQ5bQ1NcSn1u0Qb0g/WGDOJsC0Amskl4HGQyawf8OCtxI1xwFTNQnqUdCdv0n5hGljemp7Z8QHPWNS9TRUYSgXvNhdr/WYQR5yxKiBHAwsG2jX0jobN5iTZ/Ct4w4e5F3F1OiN2YuZH96Tf4UG8tQ9DmpH6i1UKSHyZsoaNAxU8+qLtaI0ac7u3rU5ReX7EKn+K8+OgHGsvWR/yBTfjeFc22Wb8u8uwMGsKopK2mYoVMl0P8B1RJNthMShDYKaIkQPpQ7b11wmZA1LBPd1R3NcePwyIM5n573jBeBboKVAN9s7pfUDEarO6sofK4qtCMB8nU5QA6jCEJ9ARzczAgeO9n2DqyEm/xnypcdpz/xf2kTw/CjR7jKIU8gzUuQkG11JI621dVVAA61Pw3H1VEGo1IBnEzxzyIK74dlDObjhQpemWDqmru54c58Wrd5guD3jcuhfb+A03a2zR2wJrHScr1DPbk5nuelaAnS7Tm72tpnS/tOUsquMsuzsSxvKEjDRUztr3VbuBq023UCD+8dfv3sZj9f7aly6WgYHr4+jEmpRm4hHnyfmZ//IQ2YsRVQ6MWxMnTUutl3Nruk9qqVM8ZBKwAFUqN9V7q/OtuTZAW/NTcxjGDQs/5Qr2xIHlCEK79CpEXqypTEQdEm/6BKbQEJcTuCFQBcXY9RSPyxYMXTxsiCDeS7OuQyhbZKWnLBBwV69U46lce9KRzK7Ys+wrendAe8I5ide2Yh7A84VxKgbSELwCflHqVD4oMrV4D
 onb7vI7f
 63KBc9d/Sj23sSeaFGDPJ/hsB78ssvOSB1T5YhKr3z4ZUvcw5JNRdB0h5cstl4lMPOFr+lLPcqdyb+VpSGUsDqcvSxbLIPng1zly23RMXI/6/P7HF9Zf9bH5V70NotV7sZgebRqOpNXB5ryIEgx4k90IG4X+O2lBeCvg8Q6gWT0wmO+r9KFyHzHjknUJOijLw0vtlLHDWxg20k7EJx8E8ZS5qFMJTtFbhtN288+0q/xCPAn+2RO98CNCb1juBswdp69PSUDRzPEGeOA1Mfd85NPDDHUgSfbIvG5UJ+TxAzgfkFfX5GL6e2p2L76971CI7XgxNEbaTZOluqn772d5i1fAL7U7h7nvJAfhfBsKSa1AH5CJieb/4sZPgWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  3 Aug 2026 17:37:08 -0700 luto@kernel.org wrote:

> From: Andy Lutomirski <luto@kernel.org>
> 
> When zap_pte_range reclaims a page table, it does:
> 
>     pte_free_tlb(tlb, pmd_pgtable(pmdval), addr);
> 
> and this is unconditionally wrong: if this code executes, addr *always*
> points one past the end of the range covered by the table.  The addr
> parameter is used to flush the TLB (really the paging-structure-cache)
> to drop references to the to-be-freed table, and any architecture that
> cares about the parameter will flush the wrong address.  (But they'll
> still free the correct page).
> 
> I think it's worth contemplating why the kernel works at all.
> 
> If we hit the offending line of code, we will first clear the PMD entry
> (line 1954, zap_empty_pte_table), then we will issue pending flushes if
> force_flush is set (tlb_flush_mmu_tlbonly(tlb)), then we will skip the
> retry on line 1979 (phew!), and then we will do the offending
> pte_free_tlb call.  *Or* we will clear the PMD entry immediately before
> pte_free_tlb (line 1983, zap_pte_table_if_empty).
> 
> If we have any pending flushes (i.e. we actually zapped any last-level
> entries) at the time we clear the PMD entry, then the flush really ought
> to flush all references to the table (Linus certainly seems to think it
> will on all architectures [0]).
> 
> The condition under which we have no accumulated flushes at the time of
> the clear is very complex (the whole zap_pte_range function has absurdly
> complex control flow).  If we do hit the bad case, then we will end up
> clearing the PMD entry after the last time the range is flushed, and any
> CPU is free to cache a reference to the (empty) page table.  If this
> happens due to an ordinary read or write, it would segfault, so it would
> be rare.  But the cache could be speculatively filled as well.  Then
> we'll flush the wrong address and then free and possibly reuse the
> table.
> 
> On x86, even flushing the wrong address works on non-KPTI Intel systems
> because INVLPG flushes *all* paging-structure-caches, not just the ones
> for the target address.  But INVPCID does not, and flush_tlb_one_user
> will use INVPCID if it's available.  And then we're toast.  AMD systems
> are more susceptible: we set the EFER.TCE bit, which makes even INVLPG
> only flush the target address.
> 
> P.S. IMO zap_pte_range is a mess.  The control flow is excessively
> complex.  The direct_reclaim variable itself has a confused meaning --
> for the first part of the function it means, approximately, "we should
> free the table if can_reclaim_pt".  But, later on, it means "we ALREADY
> reclaimed the table".  And the goto retry on line 1979 is IMO just
> asking for trouble if the condition ever changes such that it might
> happen after clearing the PMD.
> 
> I think this might fix an issue in ripgrep reported here:
> https://github.com/BurntSushi/ripgrep/issues/3494

Huh, cool.  Very recently I was scratching my head at Daniel's ripgrep
report.  Upon which he obviously did a ton of work (many thanks).

	https://github.com/dfoxfranke/ripgrep-3494-analysis

Daniel also pointed a finger at 4c640eb4181c ("mm: move pte table
reclaim code to memory.c").

The manifestation is that a tiny race window causes the zero page to
magically appear where an anon page was expected.

Anyway, I see Daniel is testing this patch.  Please let us know the
result.  (I think I found his email address).

I can't find an email address for BurntSushi.



