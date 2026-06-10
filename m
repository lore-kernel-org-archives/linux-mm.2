Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71563CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 02:51:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4C3D6B0088; Tue,  9 Jun 2026 22:51:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFCBC6B008A; Tue,  9 Jun 2026 22:51:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3A456B008C; Tue,  9 Jun 2026 22:51:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A341F6B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 22:51:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 59AE4C28C3
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 02:51:55 +0000 (UTC)
X-FDA: 84862478190.03.6B88C0C
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7C3571C000A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 02:51:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v252I3RE;
	spf=pass (imf18.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781059913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OoxFGYEssqOqRstCN78Pl7mlRWPVyNKlJqoYPOoR70E=;
	b=w8fBzJ6EXgyppy+lUyTadrvz/ymaTqltvvDB4fPQv1nB8ysPPpXvt0Y+0U6ZCJ7P/qf2zV
	O/nnk01t7a2PpCLgoT5QV7w6L5Jhl8VA57bMaf3XKr2m0J7I7wvsskOr6PO3RSU1VBq+WE
	hKhAIrWZzUra0ALcP3rkUvmewHWLneo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v252I3RE;
	spf=pass (imf18.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781059913;
	b=71KmDHCAydWFSrqzbVAgjjyiuSZbvftghF+lOvvjJ4lObLj6K3SFrBLHLTmgiJlmmOD23P
	Y9EYGgTBRQ1MNcKKPCxUtA9NVSgiqDBI193VgDqjeel7TgnTSJkLNIlVGCTAniadbRJF94
	lZdcyelGUklJmw///jPv1Gc+mCyFIgc=
Date: Wed, 10 Jun 2026 10:51:41 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781059911;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OoxFGYEssqOqRstCN78Pl7mlRWPVyNKlJqoYPOoR70E=;
	b=v252I3REO4kIfAF+k8v+vW/0utKJCfKLitrBW7oWaa1bGP7Se7v4iL2pn2/HKeF+ENVQwX
	5BQHTiXr+Spm35YsdAPZZrx6HHWnwWfzHhgrPMWWKjLAvYUgEHHI6aWVPQQG3GYD9KOVgx
	MBc3JZdNMuGhGLrXKTL3LsxYTp+uPcA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/slub: allocate sheaves on local memory nodes
Message-ID: <aijQsKegPvf-1yF5@fedora>
References: <20260601095706.106551-1-hao.li@linux.dev>
 <33506b25-ab2f-4f31-a380-7c0fe65567a3@kernel.org>
 <ah-naIiz09TTBpXo@fedora>
 <5d8abe93-edd1-4b18-9ea4-7731dc831223@kernel.org>
 <aec090c0-137c-475d-9236-fc581bf1c97b@kernel.org>
 <380dc696-7184-4ce8-8650-e5f49127390c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <380dc696-7184-4ce8-8650-e5f49127390c@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7C3571C000A
X-Stat-Signature: 9tt47zc71rfd4t9dwck3o477sc9juh1y
X-Rspam-User: 
X-HE-Tag: 1781059913-603907
X-HE-Meta: U2FsdGVkX188jPx5LJ+7QjWEEqBc8lIPA41Qrs9Ab0qPV/4Po3TxMZCDHoTQ3GmEjdB6dc+OGAPK7C7z4PGSvTsq+8qN9ovYKW8YjDyi35GP6cpbEbQ4JKcFL0LeJ22PvZYhPmcb59GYr+Jg4sqsSOtwdiVQ6tSi74LD6Mnn2qR/mmnvoPcCkZR/tcFQixiN437DOAtjMN6uujCbcRhwQ4Auw1Rv9WPkTqtmZ8YhxYIzZSrb3O7ZeJomr+vYcboa9tC6oHqnoN+re3NZIcItIUwVrKTzGV+O5nNnHVls+GfTzD0OLAPmD+QwkVFvMS3casuAB70zkKO6G4KvI3qioS8rRhrkGibcDmZ83Lewu8pgy9EHri/LVL5JbqbF44wl4m4lA5ri6lvu5ylNDQegpnP3uzzwbGn7oH0B/qGMy+jeorxEqgWYEEsizKPbagWVi5p2otQ3k6oaUk5yHKH8lsZfDxKyCrgns9bC095TSkrn3nr8tYa2gjoLWbdTbf7pmGcE2WyZUkDA/qniRcJCfgTSzMwjCGTU9dxvctM6vw3yZVvR+Mg8vZrHvsdFLDr2ydi5I3q6aQT5Ev9CSRKb8qXEpMZgEDE/8JGsDT3ZT9GER5hKXlm84+cQjDbiJbN4FN6GMyc2/olaLfIeiMqmWgdfE35YvnRO2Rys2kZSSaU60C/3C0uELaNxyt1ktJPvhxVCi+/vqjWpzEacrcVP0ukEuI5EMwQUkT70AMZy3396cEgIkPdZshYKsoHTFwbxY/lgkOJHykE07oOQdDa9X42RlFAS/kgAuV/EzrWIVS1AINGEcrdXujezG8hdQLdp28lfuaXs0WGpDfvrajd/M/hgx0uBBFe4Z6Wf/AQ2Pk+Gk3Ifqpz1Yn22ZYhDdN4zOFhZguhlnFaPAhUgNJ+jKUF7QP69mclOHESUzM8PfJiPyCZfHoQrLaw7YJmKn63UVYTUK+j/voAqP9z0Bba
 /Au/5pGM
 DlvVi7WWn5+X12Jtgike1fwUbsK96G8JjFlMbzEk/+soE+GIH0/LmeA86ZIOR8fjpC1/3PLWwVIl68BgX1hn44NFSTV7lK0UNcE4jgCdstK+4hFyZKuQ6sFarsVN4d+EoCCsnw33wp3NcbZBIE7tnLkwwCuuKu5doFH9D8OGPKkVT7jqH5JTInygBkAXS4cLt56e/TQkyfj0ltHk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 10:49:26AM +0900, Harry Yoo wrote:
> 
> 
> On 6/9/26 7:14 PM, Vlastimil Babka (SUSE) wrote:
> > On 6/9/26 05:41, Harry Yoo wrote:
> >> On 6/3/26 1:26 PM, Hao Li wrote:
> >>> On Mon, Jun 01, 2026 at 08:28:16PM +0900, Harry Yoo wrote:
> >>>> On 6/1/26 6:56 PM, Hao Li wrote:
> >>>>> Sheaf structs are exchanged through node-local barns. Since barn structs
> >>>>> are already allocated from their local NUMA node, this patch aims to
> >>>>> allocate sheaf structs from their local memory nodes as well.
> >>>>>
> >>>>> To achieve this, the obvious choice would be using cpu_to_mem().
> >>>>> However, init_percpu_sheaves() and bootstrap_cache_sheaves() iterate
> >>>>> through possible CPUs, whereas cpu_to_mem() is only initialized for
> >>>>> online CPUs. Therefore, we cannot use cpu_to_mem() and instead need to
> >>>>> use local_memory_node(cpu_to_node(cpu)), similar to what
> >>>>> __build_all_zonelists() does.
> >>>>>
> >>>>> The primary goal of this patch is to improve NUMA node locality.
> >>>>> Although the actual performance impact is minor, it still yields a ~1%
> >>>>> improvement on a 192-core, 8-NUMA-node system when testing with the
> >>>>> will-it-scale mmap test case.
> >>>>
> >>>> Oh, nice :)
> >>>>
> >>>> I have a question though...
> >>>>
> >>>> I wonder if would be better to handle this by e.g.) not returning empty
> >>>> sheaves back to barn and freeing them if the node id doesn't match and
> >>>> it's not a memoryless node.
> >>>>
> >>>> init_percpu_sheaves() and bootstrap_cache_sheaves() are not the only
> >>>> places that can allocate sheaves from remote nodes; sheaves allocation
> >>>> could fall back to other nodes and then SLUB could keep reusing those
> >>>> sheaves from remote nodes even after memory is reclaimed.
> >>>
> >>> This is a good catch. In addition to the fallback mechanism, task migration
> >>> between CPUs in __pcs_replace_empty_main() and __pcs_replace_full_main() can
> >>> also mix up sheaf structs across different barns. So yeah, changing allocation
> >>> locality is not a silver bullet.
> >>>
> >>>> If this works well, we probably don't need to handle it in
> >>>> init_percpu_sheaves() and bootstrap_cache_sheaves() at all as they will
> >>>> eventually be freed, while covering the other case too?
> >>>
> >>> freeing the empty sheaf if the NUMA node mismatches instead of putting it back
> >>> into the barn is indeed a good idea. I like it. But unfortunately, my testing
> >>> didn't show a clear performance improvement, though there was no noticeable
> >>> degradation either. :-(
> >>
> >> Hmm... the idea still makes sense to me, but yeah, it's not late to fix
> >> it when we have data to back up.
> > 
> > I think if that approach doesn't complicate things unreasonably, it makes
> > sense to do it even if there are no clear wins (as long as there are no
> > regressions).
> 
> I'm fine with that unless it introduces regressions or the
> implementation complicates things too much :)
> 
> What do you say, Hao?
> 

Sure thing, let me test it thoroughly!

-- 
Thanks,
Hao

