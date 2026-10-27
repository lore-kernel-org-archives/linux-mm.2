Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0786D606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 07:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=feoAmarh
Received: by kanga.kvack.org (Postfix)
	id 880BA6B05F6; Tue, 27 Oct 2026 03:49:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82E556B05F8; Tue, 27 Oct 2026 03:49:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71ED46B05FA; Tue, 27 Oct 2026 03:49:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 431616B05F6
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:49:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 738E91A068C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:49:26 +0000 (UTC)
X-FDA: 85367631132.20.30D2D7E
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf10.hostedemail.com (Postfix) with ESMTP id D4FFBC0004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:49:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=feoAmarh;
	spf=pass (imf10.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793087364;
	b=RYBL0rF9ZhEbIXyWE8DuRkaIK3EIRWSNHzISsBdjqrhW4JHyJJ59ToX3LQ6Vk9qmRynKxh
	nJ/AlVERLxt9PL0ViKohjBgOfFom5hEY/sjrio/kPC1QPYoLX2qxUHAEFi3GGGEZi4eOhk
	qReUlQsi4SulTVNgyae52/y0Mbz1c3g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=feoAmarh;
	spf=pass (imf10.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793087364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BXvgM0ct2zh3WME+RiKVmHD2v16ccD4fuepbOGcZJl8=;
	b=t+r+soS9Db0s1freydIqhdVYOIjSUe/DyRKfjwUZVtIZsTcYWaXhM2sufTqHF32Om4vuaj
	oOdyUySTmfiwHiEiC+I4nqzhLe37ByDH1eBMHR1q3hxED04HnB0CrDgw+e1an/O4eMX3k2
	MNG9cbTpFwmNq+kxuyJHzjnl1gyvBjI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793087359; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=BXvgM0ct2zh3WME+RiKVmHD2v16ccD4fuepbOGcZJl8=;
	b=feoAmarhOPv1XFa4+GR0GcXISwsTFdInNaACgajSG8stEUfbfu7ftXX57yOnOgl/viPGu+RqkDTCW2KPp6s7P3Pp3pFgawTmArQSgRRr10PP0NfSOqmyhyhNvQeHQyXjp2rl9xdnsJEFy2SSV5GSKPfRgjN67OuqD5b6jwCz7oQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R741e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=tongweilin@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XDd8d4h_1793087358;
Received: from x31l07246.sqa.na131.tbsite.net(mailfrom:tongweilin@linux.alibaba.com fp:SMTPD_---0XDd8d4h_1793087358 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 27 Oct 2026 15:49:19 +0800
From: Weilin Tong <tongweilin@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] tools/mm/thpmaps: fix partial THP anon/file accounting
Date: Tue, 27 Oct 2026 15:49:02 +0800
Message-ID: <20261027074904.3328878-2-tongweilin@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261027074904.3328878-1-tongweilin@linux.alibaba.com>
References: <20261027074904.3328878-1-tongweilin@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D4FFBC0004
X-Stat-Signature: k1g1x1786sdxds4998kcanhx3jrjq95z
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793087362-613972
X-HE-Meta: U2FsdGVkX1+B64LJ5PEKAySJ+acuqILuC6//QEbv6KzcP0H1PQAfCAm3XDnAV7s6BstjxmeMvyWXVTG+lzA17e4tUiFq4zkAboKctajBWrZqtHHQB/4ZCq5dTMs3z1W6rND6Ic7gtNJHwGrhyJimln5d/pLRB27OllbNmF4661QS+nAUV1sxrQcFKMATrIUz+U5gXXkXBBXuxWItHNK82mRfY8RO35ISN+9lIOifXgOLvm2QvdBlfT7jFa6gImroD38IdQ5UpMgw3RvBPzjz5anVLY7cx6lRHnWRXfyHClTiKVhgW4+GMUiUjYJGLYwvueAYK88Pi5nIP+MjIH5P/hjpDwwW0jXAr52jxbiBOqsbNmSmD4M8BC/UMh4pLoEjW5WdO6CnA7KG9wSyeg17JlluUSlCFkmjYoOjCBZGHHgbRWoX+9Nj9GFh/0gVE2WlvCDXbOni6FEP+bJPE8CpRTPF8MjZToCU5QBR5EODJmggMZKN8BxeuL0rTPmpwlta8YMepslzW1tMiYtNOviBpR+m7Vt00tPTUQVpRyKRrpJzejLIas06b6Ui8znhe1jIgoJPOBCS7y8o+2naLHs6H7u2Br7IgbLr2HmtA+HkQVNlJxZdztG3pKr9uTJWW6PkcANF3U3+IyN/CA73fCjSCbVNq6Bcw3qjl5B6azwSDg/7G7Ul1diSJdL5zW3flSJ+qgvhHMeEG15OOcrCGcerQ5jrsoegYPHCmb9diOVpV95rg1524uClUsixmWMv38exQ3pTxjOzdXLdUvCFGqWSzaGYDrJzDKSVIcnHYRwNPFWx9zQ4dNR+60UCSTey7wMAlAzUIo9ygzvhGzXhcsxABWDJlpY0tEw8V2+CsckQ6eGbbWsKQA7Es4rxt6o7+VVvTFtvMf1ROoDOGyJS21kfNueNBx5zXKis8C5LekNNH4LwQJtNd/1O1b71rAC1/bKSOKUlFcSLG6dUvxlO/ip
 sqqawjAB
 75RaNkT+1NaKbQHO8BvgSrrpxyeREVm/B+3G1IjFyLNG2vLLkwIO6MxZodT7j6eEH4UhC8J+NNh4Rz5G8uHAguQi4xwRLmwfHdftI8ZenzdobZNzbTus+GlZEu4Io1flz8KfFe1yJGNVhPIy5aqbhnTq9CXSBz1EN2cvqJX3qCXCqzJ7NkrG4BaGYL5uBlZMz7XJxmreqGPfZpC6s1sOFOhp8n3YWfbFcNtypUH14JwY0Lcuw2Q7AseThYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

thp_parse() reduces index_end before looking up the type of the
trailing partially mapped THP. The lookup then uses the preceding
page, or anons[-1] if the THP starts at index zero, so its pages can
be charged to the wrong anon/file counter.

Account the partial THP before reducing index_end.

Fixes: 2444172cfde4 ("tools/mm: add thpmaps script to dump THP usage info")
Assisted-by: LLM
Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
---
 tools/mm/thpmaps | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/mm/thpmaps b/tools/mm/thpmaps
index 803e0318f2fe..d92aace005c1 100644
--- a/tools/mm/thpmaps
+++ b/tools/mm/thpmaps
@@ -263,8 +263,8 @@ def thp_parse(vma, kpageflags, ranges, indexes, vfns, pfns, anons, heads):
             if flags & KPF_COMPOUND_TAIL:
                 nr = index_end - int(folios[-1])
                 folios = folios[:-1]
-                index_end -= nr
                 stats['anon' if anons[index_end - 1] else 'file']['partial'] += nr
+                index_end -= nr
 
         # Account fully mapped THPs in the middle of the range.
         if len(folios):
-- 
2.43.7


