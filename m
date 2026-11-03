Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C617606A33A
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nTt3daFa
Received: by kanga.kvack.org (Postfix)
	id 8D45D6B05B9; Tue,  3 Nov 2026 11:16:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AC4D6B05BA; Tue,  3 Nov 2026 11:16:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C3156B05BB; Tue,  3 Nov 2026 11:16:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5CF766B05B9
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:16:57 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C84F116042E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:16:56 +0000 (UTC)
X-FDA: 85394311632.06.B48C220
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0AD824000D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:16:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nTt3daFa;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793722615;
	b=u9jKGCUgbKt09kKJV8UtOaD/bWmVxkl0d0ggNtYuxBPWOmTMhcBNN3OscUMqlvAT2Kpm96
	b6Kgfv3pnaJn2Pq2FddY929kMLhTUAUE2dFnsTtiZ+wq6a2azzr62RKJUxodVAVu4CkyVE
	0sSI7Tx6BQM7UMMM6ZJfQ3xqNp4Xzyg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nTt3daFa;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793722615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=FafqJiDV3r+YgBt00+egOT7IUnjaF1ZmJPN/zCmRJDY=;
	b=zlUI4249QMV8X43oJbXPfPEm7vYxHooHuSy5HVfC/7RMqRIzDWRp9LWQhcLSn27qIp6Cwt
	l8T/7wXOYX6K1IDlbK2pUWQ15LuFPA5vtBeQDw1xYHEJvOIU8o6AxRoANmGBRtRje/hm4Z
	/u5A5tJg1Wnvo6vy39yJjJXrCgYvG0U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3482D409E6;
	Tue,  3 Nov 2026 16:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E234A1F00A16;
	Tue,  3 Nov 2026 16:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793722614;
	bh=FafqJiDV3r+YgBt00+egOT7IUnjaF1ZmJPN/zCmRJDY=;
	h=From:Subject:Date:To:Cc;
	b=nTt3daFaes2ppvo5vVGTGF2L5pXi7zT2F65h6quSBaxDm5gsmiGbvoz66Pkz7WktH
	 huoswhp6navHAJMrgawDpBw+GlL+uZNP70EURKIe0YGb1D4wHjnYTqhUzAJH/VNCn6
	 awpkzyu9LWLhUY0f9UYdF0h5+mibfqWvSdJvEZDQYbk6vW/e2B4RBfrS9NYx4j62Rx
	 CdUk7HNb0teIruG/JO7jRqcABwgZsLhfjf9xy+/FId+4/VhGWW3zdatr2kFL7QseeN
	 8sFUAsf/q+f+ZCkT8ne2NvZz6sfppvfA/BqdkOR1ljKiuefZGB/4wdIGP2wAlj38TH
	 D8CJKYs37U0+A==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH v2 0/5] mm, page_alloc: several stable fixes
Date: Tue, 03 Nov 2026 17:16:46 +0100
Message-Id: <20261103-pgalloc-ai-hotfixes-v2-0-e0d2890ab74f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAO4I6moC/32NwQ6CMBBEf4Xs2TVtSQU88R+GQ2lXWCWUtEg0h
 H+34N3jy8ybWSFSYIpwzVYItHBkPyZQpwxsb8aOkF1iUEJdpFAFTp0ZBm/RMPZ+vvObIuqqta4
 scpNrDcmcAh1BEm/Nj+OrfZCd96m90XOcffgct4vce/8fFokCK1s4aawphaT6SWGk4exDB822b
 V9sFSVGyQAAAA==
X-Change-ID: 20261027-pgalloc-ai-hotfixes-59bcd873a355
To: Johannes Weiner <hannes@cmpxchg.org>, 
 "Gregory Price (Meta)" <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Stat-Signature: 635kij1rw731rhniaj8kxqi447g8wg1j
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0AD824000D
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793722614-816419
X-HE-Meta: U2FsdGVkX1+o8FounAKtHstCE5ZcVu+Y1ay2/JSE6L0uvFHJmqDj1mCR1Qi61kvZrdVnbiONonwmtl6ajH7zGNxGdl9MsVn1QKI277OZV+CCzqQ+eRMHc6W8sA/4NZGoNvp3/i7GSOy6OoFyf/n3zrTvRpV9c/G+f8BiW9R/mSB+P7LS6Hu8l4HbWFo7OofiyJeog1a5TkkFqrsuCdkEZ+1C222l+BxxAt6+howA+9ZFPNLnOfMlLaTxpozlyRnwAgGCmRJ0O7+gRevD0Wz8vT58f7ScPffkJ4sk6WdtdHu1roxMDt9SIX4dKsEi19Mblkl+NHtpcsc2Hgn2bSMtULPvPUt8aw2xSJD/aKYfuMq4fOSnkVsmmPcFZ4VFAak6O6IIisKmhaXOs5O5UIhGZJszmMyxaR7GVC/kSDEFbkdwQoKFRc7+1HA30NiFEAf3CPw+L6BitIQ9eh97Riczo5+xBbKcPx0+iHgAXlg5+VjvhnORpoPedAIDguhsBV9Z5zWHUblG3IfuL463UsIfA4RlEoKMKyCWzNV41CHH2Ae2rFGmRoC47R/TsnoLDdKiwkdIkstEMlqlXDcrlw6T7lF04+ML1bSqZZpQWeJiXLuTaLaBKj2fU28b9157OaBf0PwR9NKnvr5idh2DSrK6p4QmVVEwFWQ7HZO4hk+RWkepf6FT9XnVwlt8vJBvjqsuwcKYaBAA216+f8Fzpc9fmkugY3r80njEPl9VzZnRuzX4866O2r6NLo4Te2gT81d0V0DkS76WtkMKvHToVVv8HpoqJKMwwnLW5mfXPiI/z+W4sLQmeO6RbJhRrhMg3muBKgOvv3Xlt1QM0S+motzqQh15U2Jc35kwXEDM0k4hFMxzJfe/JR5U5ZUXWTED39xQ5nhrCjrg6TpLB0Ge9wZhb2b2z74dvOD5GI0H5ZZ0tSpTgYSplr2WjMsRLRh/aZYrkP4+NY2+21MRuUZutNE
 cCVfKqvf
 PeIQb7WMPgOfwA1uxLu1YC99E4pJROyV0LJuJ+DtfO2AHnFyxkLjDA0MqKp+PgNptcpC8npBWdqsVBw09tMsFmQbNy45tGjPlN2V9g3pR7qDO/3DGFdCxDfvThUo5VH5pIX9Z5WGQ0gS4XAtqwLqr9xDcHZOo1jHJ62JYHmotnQCjfRDwOjuqOuKZu+T4HF1IqhQ8JIx6eT15Ws+sum/TiJpvXA0bPqL9NMZiEdk7Q8ebW6l19LQpI+RE7iEAh/F/8uuc62ksbDC7inSuo4DvvNdXUKbWiMFx8cfvoKxi4E9SEi6UvMExd1n0b+6r751cgGfnwTCgk4fHYP9/e2BSeOvRmH/PWczinAUEGw5z4M1bpD5Z2dXaq6rWPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A bunch of fixes from Josef, filtered for page allocator by David.

I have tweaked some commit logs and a comment in one case.

In v2 some were dropped as they were merged already, the last one was
changed to fix things differently. "mm/compaction: trust
zone->contiguous only in the span" was dropped due to lots of sashiko
feedback. compaction (as a pfn scanner) needs much more thought

Based on page_alloc/for-next-fixes, to be applied there as well.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
Changes in v2:
- rebased on page_alloc/for-next-fixes
- dropped 3 patches that were already merged from Gregory
- dropped "mm/compaction: trust zone->contiguous only in the span" as it
  needs more thougt
- in the last patch, remove the VM_BUG_ON_PAGE completely
- Link to v1: https://patch.msgid.link/20261027-pgalloc-ai-hotfixes-v1-0-9c7d1aca801e@kernel.org

---
Josef Bacik (4):
      mm/page_alloc: clear ->private of deferred free pages
      mm: page_frag: refill the cache for large fragments
      mm: page_isolation: do not take slab pages for free
      mm/memory_hotplug: resize zones under their seqlock

Vlastimil Babka (SUSE) (1):
      mm/page_alloc: remove the zone_spans_pfn() check from get_pfnblock_bitmap_bitidx()

 mm/memory_hotplug.c  | 51 +++++++++++++++++++++++++++++++++++----------------
 mm/page_alloc.c      |  3 ++-
 mm/page_frag_cache.c | 21 +++++++++++++--------
 mm/page_isolation.c  |  7 +++++++
 4 files changed, 57 insertions(+), 25 deletions(-)
---
base-commit: 743a99d7e339e81acaf76f3c902b23abb29abc15
change-id: 20261027-pgalloc-ai-hotfixes-59bcd873a355


