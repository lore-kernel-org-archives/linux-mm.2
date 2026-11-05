Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CC62606A328
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 01:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JCJnDqsr
Received: by kanga.kvack.org (Postfix)
	id 94D416B05B0; Wed,  4 Nov 2026 20:58:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FCE36B05B1; Wed,  4 Nov 2026 20:58:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CEBC6B05B2; Wed,  4 Nov 2026 20:58:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DA9116B05B0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:58:26 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4E732A0920
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:58:26 +0000 (UTC)
X-FDA: 85399405812.09.976102F
Received: from mta1.migadu.com (out-230.mta1.migadu.com [95.215.58.230])
	by imf29.hostedemail.com (Postfix) with ESMTP id BC730120005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:58:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JCJnDqsr;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.230 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793843904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kkfpYua5cYTgKG0pQiNdMFsj1/CFOQNS4WMIfupofhA=;
	b=VGtznQqBwZg5aEi5Ls3jIHOFvZV/4vNZhDx6OfVoTHK6+4ObtoE6nzKE1zIQYYHTBLax8k
	aSp33CUl2FWGXhAaBJ9xbSBPdEpQN7NmUJNVIjFsJJU+7uL8faqW2GrfZgHrnRIKueScBa
	cLT42GLID7x1Z0dXwoniN5aJvZ9nmtg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JCJnDqsr;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.230 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793843904;
	b=GVs3EVXbBGmYVC0k8uXEq5c2BedHga+je728GE0fxqDRdgyTd592W7Dc1j2fqJuvKnKfxv
	aZoOJwLmOnwLbih6USqWnrv3V/AzwYp/pYEL86/077+ptsaTFu6opHBHP/I653Cthvv5Zj
	sgPhZvrjRF9u+w+osz5eDSofQwIfGXQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=gZlY+lL7fdgfCyQVenuD4E5PVkQaAHWWt10XOZ4LvLg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793843901; v=1; x=1794448701;
 b=JCJnDqsr5gDCg4Ok7Z+jJ84EBXR21P1ESBXhE5mntiy0NMDTOc3tWKQjnPLh7QLvulPSZwQo
 1xuTTuhBlkGiHw/IxWKPXHEbawARxARw/nhRlYonqvxxxoheRGUGyiGjazg6d4OyFKL5SQll0+6
 v1AL4qqFT6e8vZwyRZcoNGuo=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id d8b7aae3e53a8f40;
	Thu, 05 Nov 2026 01:58:20 +0000
X-Mizu-Trace-ID: d8b7aae3e53a8f40
X-Migadu-Flow: FLOW_OUT
Date: Thu, 5 Nov 2026 09:58:10 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Barry Song <baohua@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v7 7/7] mm/mglru: add tracepoint for aging
Message-ID: <auvisj8NeTJ8FunG@MiWiFi-R3L-srv>
References: <20261104130817.849089-1-ridong.chen@linux.dev>
 <20261104130817.849089-8-ridong.chen@linux.dev>
 <CAGsJ_4y_Ay0mYO3ic72oepjtW6KYf2sKRXEHb3Ff8uwKrOJZjQ@mail.gmail.com>
 <4f830c30-f99c-4f75-851b-1a3f6d1342b1@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4f830c30-f99c-4f75-851b-1a3f6d1342b1@linux.dev>
X-Stat-Signature: 98dfpigdsjbcir695dwpx8aurd1yqdhq
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: BC730120005
X-HE-Tag: 1793843902-335614
X-HE-Meta: U2FsdGVkX1/r99MkP2WOiHn11ZtHYRry3qZjCwh52O1PTKyEju7ihrBKIffVfajkc8898DugUybN8deYvI24Ye9iAJUoT8Babqko0W8TfU/VmEvPhWsIamFX21zUyYRHjBqiQ8DHgRn39SIgXctmH1oLrmEU6yCzWjQcHy4v2MH5redwfe4B1oJ0MrUmQhobhDE6PTQF4TyNm1JosAPfcfWarIOYZgDbT9RKWHilhLiQh91gmY2Yy+Cc/+AQvd5hdL9/bOIkMBDYXUPwdTaHN0ozF90XswLDz/8DMYcmJZ0vWjl1jJQNSp9x7FDIAM76Mro/ZIRf8f9b+NBLfkoriKNQOsH+p/5aJWR8FuSh0qjtNdsBWoyFY+od68Xc/Rk7eP+BWUA1cctn8VAVGtC73w+O9jwC/37iRnz7FzKVbGTFV03q9zj+0ylle3FEC7bT4c4M8/6TZElMd3vpHfBDgRoQMexUCBmW7e5fM63XCN1OBlthnGiLvkxqdXIgljRt0gAemWmGgRuyL+ILZDIXzPGADWReKeU25dm7cmU6qRHQUik00QaUBOY5qPNeotN++drFt8WsETe/rB82QSp6MyyVCabsgb1Qfqaf6lY4E1CUBLC6E0hVWgvbUR56bggMNZY0238a3qQQXWkVaIgvRTp5DW+DBMEegv54tLwJhlP4C9I84iSbEdP9yfoqbr+H/jvYwgaYYPNwJg1PZPGVjMK/zHOhcGVm2LywOFWYslwgqjsrU6RsMnchFN/iV0m1ux2+EPGnFDVpDlDja6nwUkI475aetH8dIpByh6+YUv2KfOw2JVvKsavh3q6OyFXRDKDUwmr/uJQrqKe7GlqOWPJUJyiI9mPGWSpZ27hX2XVOYMcqavMGLqVs66gtKbOLRTMF2z3D+LrX5qUfS/CcQ3rG+thhoWvkrW9xiFgxbPqnUIDq/owS+O8O49cHF+5oqiZ+Msbbm3KOdm9Dgki
 Hh7nW2Aa
 epuFbtWU1SRtfSSAk6J/VH7GQR16akkRKXC80EIDWXKYSCEs4K1jnwLZ6El7PfEt/EqvIkIBcU0Wp03A5rYWVFCKi9HTdhSml7XCjU17KR/NnfLMK/bnLx2Lg/nkwjKjUlM7Oj6mQFBU9stQPoIobL8dQ75LySfnAU0FEW9/1ISUGMbWEYX2B6Ww44OYBjTk+cXMHH+GEr6NDxnRuGbF6KLwkTjILFQSa1TKj+4obiylTt43oe0waPDdM24APHtCp/LNudeXWnd9yViWc5Mll15fWcumOXjyZwar++aKvVHJ/+mulaSyGDNM5K2HMY1TCLPD3e0uXSFh6ZyRGP6Kdn2DAqF4w5jhoEdJ32W6b66MzYHsqNObAQw5+xYk047PBWz1B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/05/26 at 09:48am, Ridong Chen wrote:
> 
> 
> On 11/5/2026 4:56 AM, Barry Song wrote:
> > On Wed, Nov 4, 2026 at 9:10 PM Ridong Chen <ridong.chen@linux.dev> wrote:
> > > 
> > > From: Ridong Chen <chenridong@xiaomi.com>
> > > 
> > > Aging in MGLRU advances max_seq to create a new youngest generation.
> > > It is triggered from try_to_shrink_lruvec() when should_run_aging()
> > > finds that eviction is no longer possible, or that it would be better
> > > to age first at the current priority. There is currently no tracepoint
> > > on this path, so it cannot be observed when and why aging is needed.
> > > 
> > > Add mm_mglru_aging, emitted in try_to_shrink_lruvec() right before
> > > try_to_inc_max_seq(), with the node id, memcg id, sc->priority,
> > > swappiness, max_seq, the anon and file min_seq, and the number of pages
> > > in each generation for both types, as computed by lruvec_gen_size().
> > > 
> > > The reason for aging is not reported explicitly, as the logic in
> > > should_run_aging() may change, e.g. for imbalance-based aging. It can
> > > be derived from the generation window and the per-generation sizes,
> > > which are taken before aging, so the youngest generation is populated
> > > as well.
> > > 
> > > The nr_anon/nr_file arrays are ordered by seq rather than by generation
> > > slot: entry i holds the generation max_seq - MAX_NR_GENS + 1 + i, i.e.
> > > they go from the oldest generation to the newest, the same order as the
> > > debugfs lru_gen file, so the output can be read directly without mapping
> > > slots back to seqs. The arrays are printed with __print_array(), so the
> > > output is hex and its length follows MAX_NR_GENS automatically.
> > > 
> > > Only the lruvec, sc and swappiness are passed in; everything else,
> > > including max_seq, is read in TP_fast_assign(), so try_to_shrink_lruvec()
> > > does no extra work when the event is disabled. Reading max_seq there
> > > rather than using the caller's copy keeps the window consistent with
> > > the per-generation sizes read right after it, should another reclaimer
> > > age the lruvec in between.
> > > 
> > > The event marks the aging decision, not its result: the following
> > > try_to_inc_max_seq() may find that aging is already in progress or
> > > done by another reclaimer, so concurrent reclaimers can each emit it
> > > for the same max_seq. Whether max_seq was advanced can be seen from the
> > > following mm_mglru_scan_folios.
> > > 
> > > Suggested-by: Barry Song <baohua@kernel.org>
> > > Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> > > ---
> > 
> > Much better now:
> > 
> > ~ # echo 1 > /sys/kernel/tracing/events/vmscan/mm_mglru_aging/enable
> > ~ # ./a.out
> > Mapped 400 MB at 0xffff98a00000
> > ^C
> > ~ # cat /sys/kernel/tracing/trace | grep mglru_aging
> >           kswapd0-49      [001] .....   104.277689: mm_mglru_aging:
> > nid=0 memcg_id=1 priority=6 swappiness=60 max_seq=3 anon_min_seq=2
> > file_min_seq=1 nr_anon={0x0,0x0,0xd360,0x0}
> > nr_file={0x0,0x23e2,0x0,0x0}
> >           kswapd0-49      [001] .....   104.536448: mm_mglru_aging:
> > nid=0 memcg_id=1 priority=3 swappiness=60 max_seq=4 anon_min_seq=2
> > file_min_seq=2 nr_anon={0x0,0x20,0xf8bc,0x0}
> > nr_file={0x0,0x91a,0xbd,0x0}
> >             a.out-79      [000] .....   104.689518: mm_mglru_aging:
> > nid=0 memcg_id=1 priority=4 swappiness=60 max_seq=5 anon_min_seq=3
> > file_min_seq=4 nr_anon={0x0,0xf8a0,0x1188,0x0}
> > nr_file={0x0,0x0,0x2,0x7}
> >           kswapd0-49      [001] .....   107.282038: mm_mglru_aging:
> > nid=0 memcg_id=1 priority=2 swappiness=60 max_seq=6 anon_min_seq=4
> > file_min_seq=5 nr_anon={0x0,0x6c50,0xa168,0x605}
> > nr_file={0x0,0x0,0x98,0x18}
> >           kswapd0-49      [001] .....   107.812598: mm_mglru_aging:
> > nid=0 memcg_id=1 priority=1 swappiness=60 max_seq=7 anon_min_seq=5
> > file_min_seq=6 nr_anon={0x0,0xfe10,0x1721,0x54}
> > nr_file={0x0,0x0,0x1a,0x3}
> >             a.out-79      [000] .....   108.936872: mm_mglru_aging:
> > nid=0 memcg_id=1 priority=2 swappiness=60 max_seq=8 anon_min_seq=6
> > file_min_seq=7 nr_anon={0x8,0x7d29,0x8c54,0xc90}
> > nr_file={0x0,0x0,0x4,0x2}
> >           kswapd0-49      [001] .....   108.937115: mm_mglru_aging:
> > nid=0 memcg_id=1 priority=2 swappiness=60 max_seq=8 anon_min_seq=6
> > file_min_seq=7 nr_anon={0x0,0x7d15,0x8c94,0xcac}
> > nr_file={0x0,0x0,0x4,0x2}
> >           kswapd0-49      [001] .....   109.425258: mm_mglru_aging:
> > nid=0 memcg_id=1 priority=1 swappiness=60 max_seq=9 anon_min_seq=7
> > file_min_seq=8 nr_anon={0x0,0xed69,0x24bc,0x488}
> > nr_file={0x0,0x0,0x3,0x3}
> > 
> > One thing that looks a bit weird, though. For example:
> > 
> > max_seq=3 anon_min_seq=2
> > 
> > We have only two generations for anon, but we print four:
> > 
> > nr_anon={0x0,0x0,0xd360,0x0}
> > 
> > The two oldest generations don't actually exist. Ideally,
> > we would print only the two existing generations:
> > 
> > nr_anon={0xd360,0x0}
> > 
> > you should be able to fix it by:
> > 
> > __print_array(__entry->nr_anon, __entry->max_seq -
> > __entry->anon_min_seq + 1 , sizeof(unsigned long)),
> > __print_array(__entry->nr_file, __entry->max_seq -
> > __entry->file_min_seq + 1, sizeof(unsigned long)))
> > 
> > But I guess it's fine, since the two extra entries are both
> > zero.
> > 
> > And, I personally prefer the youngest-to-oldest order,
> > as we usually have:
> > 
> > head ---------- tail
> > 
> > where head is young and tail is old.
> > 
> > Your output uses:
> > 
> > tail ---------- head
> > 
> > But anyway, I guess this is just a matter of whether we
> > read it from left to right or right to left. Personally, I
> > find it more natural to read from youngest to oldest.
> > 
> > If you're not tired of working on this and would like to make
> > a few more improvements, you could address the two issues
> > above. But it is up to you.
> > 
> > For the patch,
> > 
> > Reviewed-by: Barry Song <baohua@kernel.org>
> 
> Hi, Barry,
> 
> Thanks a lot for testing and the Reviewed-by.
> 
> Updating it would be fine with me, but I'd slightly prefer the current
> output, to keep it consistent with the debugfs lru_gen_full file. It
> also prints a fixed window of MAX_NR_GENS generations from the oldest
> to the newest, marking the ones below min_seq with 'x'. The event
> reports anon_min_seq and file_min_seq in place of the 'x', so the
> generations that don't exist can still be told apart, and they always
> read 0. Keeping the same window and order makes it easy to compare the
> event with debugfs, e.g. when looking at both while debugging.
> 
> That said, if others such as Baolin, Baoquan or Kairui also prefer
> printing only the existing generations from the youngest to the
> oldest, I'm happy to send another version with that change.

I like oldest -> youngest a little better because when I am thinking
about MGLRU logic in my mind, I would put min_seq in the left, max_seq
in the right, then wrap around from right to left.


