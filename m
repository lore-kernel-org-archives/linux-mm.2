Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7D41606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 09:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iLFFdz3x
Received: by kanga.kvack.org (Postfix)
	id C9DAD6B0964; Wed, 25 Nov 2026 04:41:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4E876B0966; Wed, 25 Nov 2026 04:41:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B65176B0967; Wed, 25 Nov 2026 04:41:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 964046B0964
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:41:15 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A2C21140AB6
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:41:14 +0000 (UTC)
X-FDA: 85473148068.01.AD7095A
Received: from mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf21.hostedemail.com (Postfix) with ESMTP id C3FB81C0008
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:41:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iLFFdz3x;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795599673;
	b=UkeYtwGTj/YB7QAPvuf9EAS6YayJf8FyvdkxoPvfqYzepvl1/CfwApVHY6jIRhi6TwIktx
	hb//n3NoNxqsSa863ZVsrAuRGgF6BhQ5vYV1s5wlgt3TfucXrwK525+SSOoOM+Jw6UZvP4
	nlfYBogGEZlxexZvbcn71y7HyBZr+4M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795599673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CkuRXwT9l43xKhaobZMyE66cJ9Z0u1SfmIX1lzq2tIs=;
	b=uCpL+Qe+DjREFHQGe0z7RG03NY60R0pKswPvWSF5lao7b9C6x51lNUr1RQd0TtbPAOsunc
	6VJUsJDXi05s82C/QxqGUka27xhLBBGxd+oUrJsGJ7nHfjzhbzAOj/YFgOyz7LPVPDU5eo
	UiMH9S8Pt6Xv5HAz5hQEFot2wpnHYuk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iLFFdz3x;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tJHxmo2JF3ult75TU+wFYxW7CiCDZ7PB5yPrIABBQ60=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795599671; v=1; x=1796204471;
 b=iLFFdz3xFJu0gH9+iNDj3oJYR/16DqRy65HwSTcvVKKKO8SPrNOgGFatHHJTXY6wVnYFSAr4
 vqvyqbHZksgk0cRZOs8Rj2Turz1L12eYLFxMfiD4MHyQ+GLZt2WkNF0iQA7ffpT+SR0xq7ctvgA
 0+WkZKWLcKVtWnY/xyvn1xhc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 80fa0e9f79efb092;
	Wed, 25 Nov 2026 09:41:10 +0000
X-Mizu-Trace-ID: 80fa0e9f79efb092
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Barry Song <baohua@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Yu Zhao <yuzhao@google.com>,
	linux-mm@kvack.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v3 0/2] mm/mglru: deactivate anon folios into the oldest generation
Date: Wed, 25 Nov 2026 17:40:54 +0800
Message-Id: <20261125094056.3973331-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: skxoao1acfko3asige1gidcjfbcf5p75
X-Rspamd-Queue-Id: C3FB81C0008
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795599672-324954
X-HE-Meta: U2FsdGVkX1+E56SfTej52s0NHk8q9tp/+pO6Ioa1XKx26SjKZ0RKnhIPI+0KiBH7yhPIBYHO6QhxQCY7sK2Ekc7MpRDpBfFN+Djj/FuhekfvYN6tLzgG3gA5qqGCWFrKFBKPLpzZq2XsmDaAiRGCqMokIWuWePkXguAGlgnb307LTIGzrkWXwhCGu9Ocir9NtVMCFOrd+J5shhfco+Zb/YZJdsdUp37E8Bs0Nl5PS0/mn4ddiWNgAykkCx8BwoIHNpA/nIprS4ow8h3gahw72jK46Vv9diUmZxCwObrKocBdssSV1y7X4d14KLAZdeTY8TpnNPbsXPQmFqaHwtLZzFEZE04hIBzTKj351aA3P7BgVetpzyqirHX01NDHnQUqpsJJQLCPcOtdHnGUFToj9++DChZG80wVjmZ5duf/fB2yt4lqSsGABuSmK3p5WuHcl0oIuLtn9iLaEU0xXWmHPTAHDaDp0B1w8p9vBc+94CDzR6eAX7kdT27YxAbu7KalhG2wr0wVJawSLhLpyV1QxTJEZT4aTJi+eiHaXiuoEY3y+c5RhP/uB5Iul6LwXyGUZbRLBmDq3rPr7g+L6umm6ZDBDQNj/FcgLu8Mwm8kLQIbyZ7M9Q19CxcjRXd6JW+Pt4mg/teReFh29oXhtAvM8hTyLIdNlUBD54Xv11/nfGOvrb/93/3OA/4keZTudIqBC/Tlikz0S3qrARl+PiMx3varANojB0kzrsjoVg2nlCQTdULNOCBfP/9IW2rWBB264SCb89l78CcClCyzFgZS9K1fd/DkyQZLisoeRvS2r9QzfDrF9zI634Tw9PTbCaWoOywZVZ9/Xcdu6xTgSqNVxU8hqg7iGwkiQbbgHrhHPl7gGt1XfplZYO9sIVezvTykcr+BnJYid3mLP0phJVSZWQEw1N1aLmvHQeU3zjw0iOwrBnS0ik0U6L0k6rCKbau1K4wIY897NfQTJdh95zf
 +WGIhKGo
 2VtGjbPPjX0srMI6GiZbAmUllver3WW7h+zrYsDVnWiaiP0TEhSUD2PKGd3G1104f9V2mTwTlkc8LRn1dT52cZoaJWhkchY5WiMYWWDKIaqe9lnrp4MshtXmFLtB5nICjiNOGr6gKBM8wvFRRQ3KDvosapvCMaI9r6jeXDyIMcYvRM3t52S80Qujx8+XGyccOLQUXCIfYixlr217JqsrmwZHvxzcZQ0jWDsCBeQWxtWl9IZMppTWvzFmZHogw0z1+O3li3fRI+KuP7RH/kZkAdE5t8Vy3O2gb7nUrhlyuzL61qCc901rfecNDgMMqW8dfFCpF0ESOgq6NtEDeMcCm/1TAWlPSjqhfq/YV772NxjEj9t+VZaLa97cIbeKaMvSNw6IaP0Ul5Yd1fWjV1iNBQ6uuD0cvrC00iwIZsAYO9nAsNbi8eiTQOdXVGNnEwUrtNDfZe9W9aiGrbMsmzHue/MS0REXqKVATjQGgkpVN/BTpRUs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ridong Chen <chenridong@xiaomi.com>

With MGLRU, folio_deactivate() puts anon folios that are not in the
swap cache into max_seq - 1, the second youngest generation, so
MADV_COLD and DAMOS_LRU_DEPRIO move them away from eviction instead of
towards it.

Patch 1 lets lru_gen_add_folio() take a [min_seq, max_seq] range for the
target generation and renames "reclaiming" to "tail", as Kairui
suggested. No functional change intended.

Patch 2 uses it in lru_deactivate() to add the folio to the head of the
oldest generation, which matches the classic LRU, as Barry suggested.

Changes in v3:
- Add MIN_SEQ_UNBOUNDED and MAX_SEQ_UNBOUNDED for lru_gen_add_folio()
  instead of open coding -1UL (Barry). They are identity bounds, so the
  "!= -1UL" special cases are dropped.
- Rename lru_gen_add_deactivated_folio() to
  lruvec_add_deactivated_folio() and handle the classic LRU fallback
  inside it, so lru_deactivate() does not need to care (Barry).
- Rebase on the current mm-new, which has the MGLRU-FG series.

Changes in v2:
- Add the folio to the head of the oldest generation instead of its
  tail, so file folios keep their old position and anon folios are not
  put ahead of them (Barry).
- Build on top of the scanned_seq change in mm-new and add a seq range
  to lru_gen_add_folio() instead of open coding the move (Kairui).
- Keep the per-cpu batching in folio_deactivate().

Link to v2:
https://lore.kernel.org/linux-mm/20261119134740.514632-1-ridong.chen@linux.dev/

Link to v1:
https://lore.kernel.org/linux-mm/20261112081928.3014946-1-ridong.chen@linux.dev/

This series was developed with the help of an AI coding assistant
(Claude).

Ridong Chen (2):
  mm/mglru: pass a seq range to lru_gen_add_folio()
  mm/mglru: deactivate anon folios into the oldest generation

 include/linux/mm_inline.h | 55 ++++++++++++++++++---------------------
 mm/folio.c                | 19 +++++++++++++-
 mm/vmscan.c               | 12 ++++-----
 3 files changed, 48 insertions(+), 38 deletions(-)


base-commit: a036649714c3446abfdc36d0ae483046432b16c5
-- 
2.34.1


