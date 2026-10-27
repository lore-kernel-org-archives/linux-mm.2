Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07EA8606A322
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 07:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=S8Js5VW7
Received: by kanga.kvack.org (Postfix)
	id 06BC16B05F4; Tue, 27 Oct 2026 03:49:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 041F96B05F6; Tue, 27 Oct 2026 03:49:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC1E06B05F8; Tue, 27 Oct 2026 03:49:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C23296B05F4
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:49:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4728DC048D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:49:26 +0000 (UTC)
X-FDA: 85367631132.13.5F4EAE7
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf08.hostedemail.com (Postfix) with ESMTP id 87711160003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:49:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=S8Js5VW7;
	spf=pass (imf08.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793087364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fDLnPYVqGviQl47QdfOTHMYdbQswzEwGmP8xbiVLODo=;
	b=cFFat4QoVbU5+UZq6jQLTVcUrx6W/IpuiVgfwdbH8kR9gYfdJqxCuMeciNoX9Tn+IiyMYH
	mszsj7ItB3KgDvOsxoRh6HNt0KiCbBLZSDOS1At3rg/tMfQ98QtpPoVUaQUiafkbCE+tcx
	Yc0HizvdUZos+jWlAi0/U2GiZnvsE2I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=S8Js5VW7;
	spf=pass (imf08.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793087364;
	b=EmOcT3weD/84MJCtPTkkwxsPQzhTCbH/NL+aB3JAvLcAV5kNQK8m70w7J6BBmhOdL37N13
	ia6M9guLoU1Hj5S5YaQxxno0t0miW+T++JhDEz7SvKkGMC80406EHi0r+HhRLYTSWtbeTk
	dwd7sAhcg+dqTX4pP/xyE4fNGSychkI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793087359; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=fDLnPYVqGviQl47QdfOTHMYdbQswzEwGmP8xbiVLODo=;
	b=S8Js5VW7OwJ/Ll0kPgr3druyAqqbKBmFBy3QUTqOHmR4l96C9rKIQJ+B6HMstZZX6vtN6RLxtngbQieQtm0p55lMI9TdnyjQRRLqYiFsDizekaSmTLfBex36dKXBoEZ04atkd84Yroty/jRF9dNiy5qZsh5R2/KabvwYkTN6Lwg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=tongweilin@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XDd8d20_1793087349;
Received: from x31l07246.sqa.na131.tbsite.net(mailfrom:tongweilin@linux.alibaba.com fp:SMTPD_---0XDd8d20_1793087349 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 27 Oct 2026 15:49:18 +0800
From: Weilin Tong <tongweilin@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] tools/mm/thpmaps: fix THP statistics and mapping names
Date: Tue, 27 Oct 2026 15:49:01 +0800
Message-ID: <20261027074904.3328878-1-tongweilin@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 87711160003
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: u8fe7hgqdhzaxpkzdi8bjgxnd53ugwja
X-HE-Tag: 1793087363-600708
X-HE-Meta: U2FsdGVkX18KVcxTKMfhRSwGiPdzczpSujlxQSIlo3ICz2U7j1VD3kuu6gKpxw+beQYvjtMc07VOreveNLv72F7I4cSkBpt1mERZH/MtGPTxYS/9nzfHNZFl79VD4c7JRcniiGKmDUy9rCdgCcbrIJqiRO7ks7cOk4tW9U/+AklvBjcvnKcCh+2lzRn/gQnkB4DuMdTt8IGBfD98kZ+Vvkqs+ULyeZ0K6r5XEZqY5YjT/sOTBhWrfEL9vsQlvd8zlVajF1VqvVLWXRv1T6RKJBzfDBBEyEO+h45Zxd+yxWXOFWbDWZ/kVPXTT6+hoi3dF/tdP+76NR3rAwNEPGQPvRZ58xyYLLK9QoNTj4fzYO/HIB1w08v0SEx5YtAJE2awPa7xdGTd0sT0VDC80/TTfZc6UtPjcuZVElkXEYkKkWyGbfVmxLDpURLpyXbR/1jRNZvXNAcHembf4syOikPiZvxpQIjlzfjqRz6BpAnAJGSUYkHq/imFAi/Ue4lvwnOsYuwnBYtVfrbTqqdd6Gk+SuGdSUvqHPTm1/GrVYPwZXVDiyVP06Nq6txGQELaavFTtpxlxRW45BEKTTaLq1Pc/B0FOGbLDIqoDuxAyrH1YX7GYo/tY8yWjxv9EgOQeg+B8ozcm+sdXgvnTpdcYQNZ8PVsuPmaf0novWlQxk6TfC9RGLwCrHzRbfrAz/enKm31bOlfjXt9L5ldIX9Eavf1OB4IsiDdq611mmQdjoXLoLxGAdeeaAf9+l2wz+ZGsBBKkvGXL9iRRpIyFeqAfBYxEh7pL+DKeSUecEKyrS+HCOzMPNi8n6nfI6zPyYWmg2grfbmffgxqBPkeSTeZq0HGbbubBf4pdPhcmOmG6ohlzveAlZ08S2l+/9x73EvYvyJmxbzLDfhBXkGHMfSn5R5pDpC+AiA1RqSA0nd80KrOkb8IvGoblJg6+OAhKGkJUTC6U8S1C6CY/EwFd/KYea4
 mj9VjYO2
 jKgMGcXfEvC9U2RxToNsBe7Jpz43LTRU0R9Hvjhz8gvjQRCtbPBLWRqFtvXTVhis+uTuz3qxuFgiIrQokM3Nw+QMdeaYm2LbwzR+gaouamtUVkzfz9YlLm96Xsz4tdmwNhzpPUD8zYWHpsr8Ygb7xmfoAWE/qmmho8XT7Y+A8sXWl+obDOn+AxaG+FNJsVLQ9zgkfIH5nkdFcdobYtXbSxx+hYzXKsfuDvHv66wzzOcQBWuoLzpgaUNix8Wr+LBqMfQej
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series fixes three issues in thpmaps.

Patch 1 corrects anon/file accounting for trailing partial THPs.
Patch 2 includes order-1 file THPs in the per-size statistics.
Patch 3 preserves mapping names containing whitespace, including
paths with a (deleted) suffix.

The three fixes are independent.

Weilin Tong (3):
  tools/mm/thpmaps: fix partial THP anon/file accounting
  tools/mm/thpmaps: fix missing order-1 file THP statistics
  tools/mm/thpmaps: fix missing mapping names

 tools/mm/thpmaps | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


base-commit: 39274b454e9993cea319f4ac342a8082a9ee1730
-- 
2.43.7


