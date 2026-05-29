Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61E8FCD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 03:51:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64DE96B0005; Thu, 28 May 2026 23:51:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D7986B0088; Thu, 28 May 2026 23:51:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EEB96B008C; Thu, 28 May 2026 23:51:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3AD266B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 23:51:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD430C43C5
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:51:46 +0000 (UTC)
X-FDA: 84819083412.08.0ECA8E1
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 474C61C0004
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:51:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KKudH0N4;
	spf=pass (imf21.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780026705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Om+9rENfxhYxcbjRM0HRMEqhY91mSkBoqb3WHHhFk5M=;
	b=42byYxAcjVpjZ/PETzX+NLE02k96DVuefx4LfEasaVLY0Jlq/zAMTi7+1FqyM2j8sHpGlU
	szUspLN4xiUqKnXa8DNLrVBPxcTHyfLHFhXvthxOP+InbUu3bq04earhX37JzlI4lvQtGr
	HZXFYvmOdwTl4Y6PkQNLj0pFvxcTH6I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780026705; a=rsa-sha256;
	cv=none;
	b=MJ6HWkNY+PBQ4AJboLwvRtehnXi3IBxMrAxYZIOkWU7x0W9UbUbbpvIT+Qwpd1vYBk/XP9
	uqlXLDx3D0g8UQ90ZkmC8ZEU0o+tgwc9p7np2IPzxJtv4W3fOLJ8VAUxGPljL7d1wFlWdI
	+PgKPJ+eujFm0tlrWjKCrO4agutIYeQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KKudH0N4;
	spf=pass (imf21.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780026701;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Om+9rENfxhYxcbjRM0HRMEqhY91mSkBoqb3WHHhFk5M=;
	b=KKudH0N4UN1XACB2rtOpVcH6cVASD1OJbFI26I+ETm3F157R6v50OPVUSi33rSv7pm+n6K
	bXEqsfRMPUAfxa0NMYMrG/utt8pG7TafNwSZ3+U6OhA86H7Sz8wg3Bkj58OOidR6VP2bYm
	0Rwio8d/fyiRnY8ZM4ZDb/obxb9jHY4=
From: Hao Li <hao.li@linux.dev>
To: vbabka@kernel.org,
	harry@kernel.org,
	akpm@linux-foundation.org
Cc: cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Li <hao.li@linux.dev>
Subject: [PATCH v3 0/2] mm/slub: batch partial slab list operations
Date: Fri, 29 May 2026 11:50:50 +0800
Message-ID: <20260529035120.81304-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 474C61C0004
X-Stat-Signature: pe9m663pdn1ehmdwswt115exeqkdm86c
X-Rspamd-Server: rspam06
X-HE-Tag: 1780026705-120685
X-HE-Meta: U2FsdGVkX18PzrsyNzbYRSgnP5zVIermMaYmWKM1rjKgxRSnw5B+/YxQNGzcLeaXyoxaupF+h+L8RKWCL+/C4OgdRCtINtECH6sr+ubpqew0T8Op2dyO3HE8jlGFQr8qEvdOIugPMYZKAtSeuihZ3i2Vs6LMkZ3r7Z6t58DR01jseIW6EnNGZgh3xYVNMM3MwTquMrMTY7lDfdah8QiUK6x26A0D1oWr+jiJvGg528YqJ/f3cgIQpbbD6V/IF61I5RurGNmA0b0tcwQwXQ+ECY/I+gbGhcnRwJRNnX5OaLouAMY5zEOyDb+s5XlH/frBGKekRAkuB/PbJvCDccBLmqwAc8l4MJDvkAA/6hxfRrb/ZscltjX9kwGXqtCYyKf+/CO8uziAtPou86yqWwRTg8xEsRzoNItPGiTpyQVAsTINdeHFzK4wuy/mzpDfOx3MCn03TJl1f+6eZnoR8sc9Crf7mYKmP6+UmJsTYWoqlzPymbro+CR1bZKd0/ZNYZagQ++GcW1rcjo5L5NU06Yz5MZXZW68X7rHjQiRSRXjI/c/1u2XQtRzrhoQIGZXrWi/0FlpSsyyt8XFUI0LpuxMl8hnsOwV20JsVEeyJeDIgBGn3fE5DZoYSsR1XxVBb/BotWeVzliNgOUvnMTeBgYzNZzwY5e6kh878UYGJRWRfZXHu6GjVYABMFqrIjM6RfOhQ25oesKAGwa3QDBXVG/VKmz7y/oTIcq7X6SUYEA3OPvdeoCGZt8aikjnrIITPpylld36UuYkUATSTV+i/PVmOSk/gwgIt+2tyyiydOJC1buwJJiIKSfft/7IGkn7WJaDQzDxsaaD8oRQHxho13gfXGaYvDWLSerCwzMls1J0cLlWylXUi1pF7AOKlnL9tWUeJTGB/qlkA4fytlxGWIblusZ3h0i7lkDJld4cuOneNDwSoi/KFzfakLcFeUwzUef/A8SbDOhgj7halhkxynK
 m5CeltYa
 hwVIsHuG4h/FHYonguuNg6q0wdf+0qGv5OmmeScC1zBKdiF+Y+ap+6ZMRqk+Mg6s2myVquq04oP/ftkXHCcknC6lIyeJWKgWzte52qta9lqS4RwQnVWHhKLCPm7Hhy3fneIeh0JCC9CgwSvUrC+ZT373EMzvGwbL2PJmhVdL9Ujy84MWlhZGmu8tCzIYHRZT5DNA5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The loops in get_partial_node_bulk() and __refill_objects_node() perform
individual list operations for each slab. This patchset optimize this.

Patch 1 is a cleanup patch that wraps duplicated code into helper
functions.

Patch 2 reduces the number of list operations by processing slabs in
batches, thereby minimizing the time spent inside the critical section.

Changes in v3:
- Reorder the two patches for better logical flow. (Thanks Vlastimil)
- Introduce set_node_partial_state for symmetry. (Thanks Vlastimil)

Changes in v2:
- Patch 1 applies the same optimization to __refill_objects_node. (Thanks
  Harry and Vlastimil)
- Patch 2 introduces a helper to wraps duplicated code. (Thanks Harry)

Hao Li (2):
  mm/slub: introduce helpers for node partial slab state
  mm/slub: detach and reattach partial slabs in batch

 mm/slub.c | 51 +++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 37 insertions(+), 14 deletions(-)

base-commit: 6b41dc6749232c14f3e069f8115084a7bbeee402
-- 
2.54.0


