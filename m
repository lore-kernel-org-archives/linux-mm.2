Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2E76606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 06:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Q2XuuX55
Received: by kanga.kvack.org (Postfix)
	id C71076B00EF; Mon,  2 Nov 2026 01:01:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C219A6B05B1; Mon,  2 Nov 2026 01:01:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B380E6B05B2; Mon,  2 Nov 2026 01:01:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 869386B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 01:01:20 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1B44A0BCE
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:01:19 +0000 (UTC)
X-FDA: 85389131478.09.642CDF7
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id 451ED180005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:01:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Q2XuuX55;
	spf=pass (imf24.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793599278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ou8EB+rPMhnf6RRUAQStNUkip0wMkSd2FjxAyfUCwH4=;
	b=VdYW06q/l06EoQ0Fw6Y5CD+H/UtIx0JMBi9bjLFd9MfitvNWHYHPDxv/I2VrQlAe/T5JaR
	Rrbqa2yiWwqslcrIQKUXBlgbNJpNbP8eJ7oR1MfES2Je0mOrHpsXDulA7MHXWDb1B8aOvA
	dETKQWHfluoo8bBVqIg0yxwLT2AMdSk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Q2XuuX55;
	spf=pass (imf24.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793599278;
	b=CNUnCLrLMtoyitdn3790buF9ipMYxACT3dSFIgLhd2kveypUF2+yHBTE9uV/7b75gKECEO
	ow6AVX/xAwolQHyOMuZTlOGQYEajxgU5+1EtHjXij2bazwkkx+hvwJWZBWtogzi/J3pKFn
	bvUlQVXPPQhzPVHzBBLZFtfezIy4sLM=
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-3514b90bb89so5397985eec.1
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 22:01:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793599277; x=1794204077; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ou8EB+rPMhnf6RRUAQStNUkip0wMkSd2FjxAyfUCwH4=;
        b=Q2XuuX55tYwriU4BVX/TdNF80Yq8bL7zjVGvdqEyqta4YV4X4+b6ZryW5kZduh4pQi
         a1ohDtp/1SpEDo3qwen1x1+3pPakzbqcaYiUttjF3w5AYEMZx2wR5yjap4njo8lIK6wq
         h2uYFWaWSjV1SGj37Qa4ANgILVOU7WbkygtiJta8rSp5fP4sea9CpXW5UJYIdBFLV4Ak
         TZVsFzi1DaEnygAZZ9rmwWrh3pR/fqhZM/hnqIy8330Sm84oGqTo5NhjGks4e7TcVaac
         0Pgy5c8YShSCgKTjh0wv3LaMlWy75546HftMRjD0GRRxPOdGfixknQNK+Ao72tBaQNzR
         1NJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793599277; x=1794204077;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ou8EB+rPMhnf6RRUAQStNUkip0wMkSd2FjxAyfUCwH4=;
        b=QDl91iqCxtGte6G/TloXTZzOvzzPmk9FhQXJB0PFf4zRQKyCnxx6pAl8AV8LaHqPN5
         Lk4HSS8PtclP2NxYlSPeYTmkSJhGT5fRWKF6jCdBYepmNFHwMrzy+S6rMUaEOM6ZMygX
         4IEouYRVNvuimWeOf4klBvsCC85M9azxBe+dbOJEkjRMgJSSNx/pPpSWZ6w5r7J/g3uA
         ArXaE+XTtPs0CjPLoUCI/7JvzYH2Fq3JeGQQHSsn+U55d3TQL8gAqZl3tpfvYG/tcy7m
         76B2W4UaSNcynEPDZ1Txmoy3+UiQqIFerqX3UsMH3XFFWOUAfr0bitrte5yEOJ1rsaDB
         26GQ==
X-Gm-Message-State: AFq9FYLWRHSon2CJehGkrPNv36tasP2RIcM1uPJVE6HDvOvtfjzre6E/
	IyAtMtbtDIhYu1tZKPG22WptGLOvSN7lJa876REpfnqr4qhkSAxNQYOY
X-Gm-Gg: AYBFou0z+woLBe3uTKKcCffj5gwsYAPP+qIZf7EjOEB+lFRxBaBZPYI+WQy4JBgfFou
	cbxiNeGqr4jcznSbnxdnviSQR48DbeBwnakivpHS6mjXOoinBNdip4QfduWkisWwQ/s7xu2QESu
	ELb5B39g0z9Was87GSp+2E/H3Davtl78AJ8xYUgaS4d7x1k6elKMc0rLyzEEPbU42+3g2q/v4TW
	0abg+ELDfHHire/7IhkiY8i9C6bR5bUEkG9j1pKyPMD1QjBYS2EMmkf9t9ddIigPaAdo4Rl7E0X
	n2B1nTjmtN06IZwjtq8opEdQ/+JuGOI10YZwgrZ+UazPpdwrCRAWxuhAy7WsoAEBmRw7DS++t+t
	UehMsnfQcKoNr5zKUv6g8dtPMAvF9OjT4lF1jh0ofE3K5lCnpZCgLuqQMi/IZE395picID3zvun
	RM69xP2AdLAkF0F6OVi5aY1AmrDVyuQTynMOtrxbgSvbG4vtyiCeTHejbmsJVWxrLi6SC1tP5VJ
	4rRMC+JCKQRACxdZTLNMkE3T07hZawJKjt+/CLNrhjDRHMf19fB7E+QOApflWYwoeUJ84BAumWT
	1FkhrIc5IosGvSJsoTDdprAb
X-Received: by 2002:a05:693c:6211:b0:36a:1cbc:1093 with SMTP id 5a478bee46e88-36a42417707mr13155080eec.30.1793599276780;
        Sun, 01 Nov 2026 22:01:16 -0800 (PST)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428af4e6sm28755363eec.4.2026.11.01.22.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 22:01:16 -0800 (PST)
From: Qiliang Yuan <odys.yuan@gmail.com>
Subject: [PATCH v2 0/2] mm/compaction: stop repeating failed async
 compaction on every THP fault
Date: Mon, 02 Nov 2026 01:01:06 -0500
Message-Id: <20261102-bug-mm-thp-async-compact-defer-v2-0-b407e974db54@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACIn6GoC/42NTQ6CMBBGr0Jm7Zj+gKgr72FYtGWASSw0LRIJ4
 e5WTuDyffny3gaJIlOCe7FBpIUTT2MGdSrADWbsCbnNDEqoixRCon336D3OQ0CT1tGhm3wwbsa
 WOopor1pX0nZWVS1kSYjU8ecIPJvMA6d5iuvRW+Rv/Vu9SBQoZF26+qZ0qcWj94Zf5/yCZt/3L
 1k2+CzMAAAA
To: Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 451ED180005
X-Stat-Signature: o9p5j9a591f44zsa95x1wtu5n1da8949
X-Rspam-User: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793599278-548485
X-HE-Meta: U2FsdGVkX1+DaLGjmKSLSGzBGJmdB0VAda/11EatLQY84zQYHPELCWEHBazSw5cVo35CWM7BEYWi/cQv394inbF/CIigI5iV+xFQEONd0QRLIOrqxHmkB5f6Cx1Iv9h3uR206kaIVkfaYz7lz/daaNexsBScMxtgIxNL2EGbMNaqEimsI0kzYTbQYPjBm8+Gjk1Ga2VM/BwU6IuLJ5x7ljg4WP7wK+nn2/FP6r8ipZrMZgKP7E6J9Dv5IVgQDs0Uvp4Llo97cVuRsqwvSZKmqbWwIrhY3fztJR6vSWqDd0UNDnfAr9fYsbvdf7erlyKj7zLbeAnMZBJagD4VnsbD0AnqeocrQV0j84RSH66Sf/T73MfJ+sC8i8B0Cz/hbvUdUBT24s45DWm3HnthsTXs+HzNzsTuxyr6ELNCAy2qMPk8l91bFZIg5LEu4y6e9K+uLurzwmtbJLyCEAG1uamZUFXyCLr7w7J5tr8bPXHwZA2zv681ahkFCvPnhv71CA0eXV06NaQW+3l+MZ5bcArE+pw8M6Uuh1rTf+Alkm2gEZH9iaQ3PRf0ChbSk0KMOxPrZ49WajyxLGGM0ntKz9mgrifay1f/eXQZ3JcD7BEQKDFLs+a/rygkgi/bLVSBQKlphDSI+sfqWsqZ2o9YaGYrANda7YdnPoFhFbl4/3IUEziUA3JOOXLROnW/7cyexz1RiBzrz8bC53J3rreuQhPwWEKAKqlHBsqDa9upN3JDbXlfTBtZ4uBYpza57Yuqlrd5ElR+eMMG651Ab517ONyU1ioVpWtFrl8UU0In2NKTUn/Mh+rEJxzU13XLt8f6GPeKveYKCZpc6k/V9X1IuzTk1Qjosi5h6c12Z5S33rh2gE8azYOO7/nyEneU1z+wlh6eHGw+nFH7FIu24j8YA5GEUBZX5n1Iyyc4+gAYi6H2PgfHA8cBKR1O8drh7V+BbGIdMJPBAyRmUlLFnuaLEe4
 r8xer/Md
 q2Za7cwlInkT9UVHvjK/rlYBfzskiuiHrklVaHQR/J9qj5BF9MixlPRXt9Ej23ND4YvjL726MH9qo6nAEIm/6YNZgdiK9yWjGMMuy53TMiwuZUFlgo/LERfXaQcr086ddJwxwTRIhtgjJmhSVAisyHBn3vxLMLj0X8m9Jjembmxih5jAsx/AmDevqqrznbF6CtHdqYWC+clbrBCBBmUbpVh4FRt3g4VV41dcot87FVOxghVKfyfPloRG7tr/o4q7EM3UtG8elU/1LC1VY9u6+evmnItFoOE0x/b69btPBwmf4VKlr26fgZiHdkOIQvZb70/HZNiF+3p4b3q4CEel5TJNJaN6NqxdEaf0JZ+ea9AgGZ4Hw/DWGlihtu4coRfaWEGDR7atpvU8Tr/QrpLAwym/TA9hyf5sE/NOgDpn9eHSRevEWZmK4XBm925xse73AFD7BfPb/IUSXNnMxi4A0Xxki7C1Rnh+h6oFEeyCEIb/5L3xt2TmSv1bR1WSdhYamoknJpjf0Izyf1L1WaFwS6QPyU3GoTCH6rjFY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Mooncake, the KV cache store used with vLLM and SGLang, backs each
rank's host segment with MADV_HUGEPAGE memory and registers it with
the EFA NIC, which long-term pins it. Its commit c3fa13ecaf10 [1]
reports:

  "under the default local NUMA policy every THP fault on a full node
   runs direct compaction before falling back. With 8 ranks x 190GB
   this made registration take ~38 minutes."

Mooncake now binds the segment MPOL_INTERLEAVE across all allowed
nodes, so that no node fills before the others. That gives up
node-local placement, and a task that sets its own memory policy
still gets the stall.

A THP fault on a MADV_HUGEPAGE VMA tries the local node first, with a
single round of async direct compaction, before falling back to other
nodes. A failed async run is never deferred, so when the free memory
of the local node is scattered between pages that can't be migrated,
such as long-term pins, every 2M fault scans the zone again and fails.
A node that is simply full doesn't pay this: compaction_suitable()
turns compaction away before it scans anything.

Patch 1 splits the deferral state by migration mode. Patch 2 defers
async compaction on its own state after it fails, leaving sync
compaction as it is.

Populating a 4 GiB MADV_HUGEPAGE buffer on a node fragmented by pinned
memory, direct compactions drop from 649-1473 to 9-41 and the time
spent in compaction from 118.6-264.2 ms to 2.6-5.1 ms, with no fewer
THPs on the local node. Details are in patch 2.

[1] https://github.com/kvcache-ai/Mooncake/commit/c3fa13ecaf1038df933dcb784ff8ffe026381100

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
V1 -> V2:
- Describe the Mooncake report in the cover letter
- Emit mm_compaction_defer_reset for both states (Sashiko)
- Reset the pageblock skip hints only from sync compaction (Sashiko)
- Rebase on v7.4-rc1 and rerun the tests

v1: https://lore.kernel.org/r/20261001-bug-mm-thp-async-compact-defer-v1-0-0174c7923430@gmail.com

---
Qiliang Yuan (2):
      mm/compaction: keep compaction deferral state per migration mode
      mm/compaction: defer failed async direct compaction

 include/linux/mmzone.h            |  7 ++--
 include/trace/events/compaction.h | 27 +++++++------
 mm/compaction.c                   | 82 ++++++++++++++++++++++-----------------
 3 files changed, 66 insertions(+), 50 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261001-bug-mm-thp-async-compact-defer-b83351bfb25d

Best regards,
-- 
Qiliang Yuan <odys.yuan@gmail.com>


