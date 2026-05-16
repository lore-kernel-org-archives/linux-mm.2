Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08695CD4F21
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 09:36:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A06F6B0088; Sat, 16 May 2026 05:36:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 378166B008A; Sat, 16 May 2026 05:36:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28DC86B008C; Sat, 16 May 2026 05:36:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 179BD6B0088
	for <linux-mm@kvack.org>; Sat, 16 May 2026 05:36:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9CF141202FF
	for <linux-mm@kvack.org>; Sat, 16 May 2026 09:36:20 +0000 (UTC)
X-FDA: 84772777320.01.1E261D2
Received: from outbound.ms.icloud.com (ms-2003g-snip4-2.eps.apple.com [57.103.72.193])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9909780005
	for <linux-mm@kvack.org>; Sat, 16 May 2026 09:36:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=NfuQO4iS;
	spf=pass (imf02.hostedemail.com: domain of cheesecake2960@icloud.com designates 57.103.72.193 as permitted sender) smtp.mailfrom=cheesecake2960@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778924178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pLIOlW+zoMRvn3ZZV36sMbKshXXQyD52jA4AIxLVy1Y=;
	b=FTzu0xwX0ShBNPnejZQ8kh+QLWDAl1MtySKXW99lEBcnFRGCpNwBiSNYt/rIMGQUIcnpg8
	IvG2o0RexX2I5ccFdl/z0QkSPNqL4uDSSymxFKhJeSZoJLBSN3nq+Np8G+jY+j+706Efpi
	dp2kqwOl8pWTLqiWfGfltas2kWBZdGU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=NfuQO4iS;
	spf=pass (imf02.hostedemail.com: domain of cheesecake2960@icloud.com designates 57.103.72.193 as permitted sender) smtp.mailfrom=cheesecake2960@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778924178; a=rsa-sha256;
	cv=none;
	b=VkwOhJyxrO6NVBOZCbBWUOCVZ11aqLvg2V9XCJCdfyvrq0I6tc8Fh1mkY8qAMeAeMKXtab
	scSAAuo9IE6MO3HvF9ttpHlRtItSaaoWG6exFXHno6lS3I3UquO0YxxWYVr35FehHimXwk
	vYWhQq6tewe0Eg1z95tkZYxgxHfmC/4=
Received: from outbound.ms.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-3a-20-percent-2 (Postfix) with ESMTPS id 8234F180010F;
	Sat, 16 May 2026 09:36:15 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgATUQeDx5WFlZNRAJCTQhKBUMDRQBBCFYBWANLVxQEG1sIUhhXE1gTVl8OXQIwUBtfAkIPHBNWFRMLU1ZRGFwdQAhUClkVC0EFXXcCURxWDVdDVARfUEsbDlwBS1oVVRcOAkIfUB9MFldDWhgcGVoUXBhTRVEfVFhDGUVWaUELTx1dGVscQmRYVwkKAlEcVg1XQ1QEX1BUEVdQC1kCQg9IBlwBWwtDDE0BQw9fAkQUSR4OXw5XA1wbUgZSWQtGCThaDlsERxQXG1wACUtGCUkdDgRUB10FXQ==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1778924177; x=1781516177; bh=pLIOlW+zoMRvn3ZZV36sMbKshXXQyD52jA4AIxLVy1Y=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=NfuQO4iSJ+67M3P6Vwvb/37/aM27nrC9cvX4WXfDTNd39A6+0UHAODBI/rcYAzcJkThRuXyJUga0fHS5SRqx5xhetSoQvh/AUGlPBS89ihamDzK/Hi3rOAMEBwRL+bm/idbpbcrckjm0+3Bsk/A8MRdxYPQXDS5ls2olMGec36DlCjbYZeCjZY76BQTUkZorS1LK4K0QOgZfEk+l2PJsOHlxb0ND5pPwogQcYA8+majDfjmmqUIz6a3dNGorXVH8mtWAiZy3KnyRwuxhff9z1xbOFRMPim21URK55jdQVQxTVpN5P0bZ5rsVnL7N/GJVLQYDftZJP4huO6VXJqDm2A==
Received: from localhost.localdomain (unknown [17.57.154.37])
	by p00-icloudmta-asmtp-us-west-3a-20-percent-2 (Postfix) with ESMTPSA id 7A85E1800106;
	Sat, 16 May 2026 09:36:11 +0000 (UTC)
From: Cheesecake <cheesecake2960@icloud.com>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Cheesecake <cheesecake2960@icloud.com>
Subject: [PATCH] docs: fix typos in design.rst
Date: Sat, 16 May 2026 18:35:37 +0900
Message-ID: <20260516093552.8404-1-cheesecake2960@icloud.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE2MDA5MyBTYWx0ZWRfX7ZnDZ7huTtVu
 KfCCErq43Td9krDJDecIzjVvJp5O1F/91Y2cn/A61mjwTfJIAW2lMBtKL+MDgwYGFL5b2kU09kZ
 87/0HfoVj/S9grnd/hDTlEafHCuLMdUbGqgDuZ4cG7RB6h3BwUso1GKjvn4h/cQy6cymcoYE2Gr
 N7V3Ir/Mp0l8QI+Zf7EpyHICj9hHCoh7/IcvORwZh8MW/8NGLUqWP0FO1ndOrNjdwg44Fohv7D1
 btRQYFBLzYTzNEV50ZRdzgwRS1CaDjMcgAlKAS+KVL3nSrzWrNCikl/LuMy7PQDGqcjA4YWGWiQ
 eWq+bc68auZRpoqEtrBw20Z4hpNUyILtLDgYuwDplW3MDDndGf7ZOn3sVi7kec=
X-Authority-Info-Out: v=2.4 cv=O4c0fR9W c=1 sm=1 tr=0 ts=6a083a90
 cx=c_apl:c_pps:t_out a=qkKslKyYc0ctBTeLUVfTFg==:117 a=NGcC8JguVDcA:10
 a=x7bEGLp0ZPQA:10 a=sIGCgqHK338A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=v3ZZPjhaAAAA:8 a=_08Xcmskz7rbIMj_RqsA:9
X-Proofpoint-ORIG-GUID: ajntKu6TFwtbcfSmFXvV-7uUv9Erb4R6
X-Proofpoint-GUID: ajntKu6TFwtbcfSmFXvV-7uUv9Erb4R6
X-Apple-Category-Label: MjE0Nzk4NjU5NzY6JGNhdGVnb3J5JF9QZXJzb25hbCw=
X-Stat-Signature: c6xautushh9joeyhir4hurtfp18byp3j
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9909780005
X-Rspam-User: 
X-HE-Tag: 1778924178-978193
X-HE-Meta: U2FsdGVkX1+QlLJEgwEBSyUdoVhluM3lohlGYX38STPu2ZF7Fz2qLf+EgSTJxZLviTkhBPHPiWeHrVhz9XijHLZTsYvg9oJrc5jWfLZNkmSUrZIVKiceYA7jQqBCvtqUDHEqhPFcsiyknF8eRLDLMLIYHFj0fMFjWFpccTZKt1Hha20V5lyBRpj4XE69Mcmtz/5AohwB7uZbpEjaN22lBLSKzyYrqbNLUSTvZQidVsWVuSF+UYGIQ2SJYimsgdLS6B24B0+2qIld1oVJYbVqqFktAYf0I/Mzd8R1Dx1fzPVat37wlXuCVbCFx0xZ8BstFinVppxq7OZvCrXpA7glyuFS6ztlfofKBz5iIMamvNt3hYbJ8GuGQ230ztG9NCvQccjvsR8BrvsMFX3FxXgiBLMaffN6wXMhmrUZbNwGHVZUZJPGbRWaBAdIsZQWqW+XODHu3Z0z1iPkg+tLBIRhNfsIaAzG/X/12wlhUYYIi7a5pBIqdBGRYVjt93amXGe8HjgsT+9l8t5NPH2Vb6pP6KxtVHb4ZMHutJkgHjD3WgzzUzJlXRuF2c9G9WTqsRlHAJ/Pw21FBBrB96NC9sdmoBXgUEvdVqXj1+YDAbrwweaTlCrVniIfolMweOKvqFWANfdyBJPB5Y+Yqtgg3XonJCg7f2opYAaPhf9+XvYI7/3sQ1gDxR73zbwa5VZPM5qq+fS6pnIZfpTbxd91XN8lVYYHbAJwYNAUj6FOwk0mAGWFUJF7c2ptyFj0y7/5HI3caRJftPNvlT2hGH+rZGsGyqdLIIaXFLzGfo6nUIJMz+VIKEzs1VQmYeyZC3t7KBqvlACYjRhlysEsNwa1/Ei9di2bGKfYLuJPmaG0LWcpAZ0dWdmiMCYKTrOdh9vFkW5IJwhPtrLF65OrNS8wlXTSoS54HOXR+TNnVMHIM3FtPGBOr3POsWCT1OlqgPORFV2rAdauwuu0y6uZNpHQUpv
 GfhjiC5P
 urS+MuMOeFph72qUs6rK0jrQ1plTKNd+6RmEwuZRah6o8fuKeWzRIXBNpJZcLv6Sc456SRNQzw9KVUfl4EQqzBPsQx+y4FLgMVSujIb4TLFzAa686NSvmc0Qn+8QFFb4LpxeIsg5fI0DJTb1YjRk4hAMu1jgDZejcZkL5K9quk6JlgXNgr660MrefVMDVKifs9NmnfiGxiJyT6riQBpIEH7oo5JXwCVS5gKHVgewhqC8FOkcp8gbZsbjbMxelJoHnf9NK/1fqSACDajcjawt/ZJ1egsj9ocOg0CG8BrPMCQfiBRo9mXYKKjW6lt0oOdlZJbueB9+q32AmM7UN21Xji5jiy50CjDcwCc2kmGD+A58LXyzk+KtujaxMRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

L140: "unsinged" -> "unsigned"
L371: "sampleing" -> "sampling"
L387: "multipled" -> "multiplied"

Signed-off-by: Cheesecake <cheesecake2960@icloud.com>
---
 Documentation/mm/damon/design.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index afc7d52bd..9cc70a296 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -140,7 +140,7 @@ as Idle page tracking does.
 Address Unit
 ------------
 
-DAMON core layer uses ``unsinged long`` type for monitoring target address
+DAMON core layer uses ``unsigned long`` type for monitoring target address
 ranges.  In some cases, the address space for a given operations set could be
 too large to be handled with the type.  ARM (32-bit) with large physical
 address extension is an example.  For such cases, a per-operations set
@@ -371,7 +371,7 @@ with theoretical maximum ``nr_accesses``, which can be calculated as
 ``aggregation interval / sampling interval``.
 
 The mechanism calculates the ratio of access events for ``aggrs`` aggregations,
-and increases or decrease the ``sampleing interval`` and ``aggregation
+and increases or decrease the ``sampling interval`` and ``aggregation
 interval`` in same ratio, if the observed access ratio is lower or higher than
 the target, respectively.  The ratio of the intervals change is decided in
 proportion to the distance between current samples ratio and the target ratio.
@@ -387,7 +387,7 @@ The tuning is turned off by default, and need to be set explicitly by the user.
 As a rule of thumbs and the Parreto principle, 4% access samples ratio target
 is recommended.  Note that Parreto principle (80/20 rule) has applied twice.
 That is, assumes 4% (20% of 20%) DAMON-observed access events ratio (source)
-to capture 64% (80% multipled by 80%) real access events (outcomes).
+to capture 64% (80% multiplied by 80%) real access events (outcomes).
 
 To know how user-space can use this feature via :ref:`DAMON sysfs interface
 <sysfs_interface>`, refer to :ref:`intervals_goal
-- 
2.54.0


