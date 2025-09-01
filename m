Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 405B4CA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 11:08:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A08EE8E0036; Mon,  1 Sep 2025 07:08:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E0768E000B; Mon,  1 Sep 2025 07:08:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F6488E0036; Mon,  1 Sep 2025 07:08:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E9F28E000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:08:57 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4A1DC1DE953
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:08:57 +0000 (UTC)
X-FDA: 83840409114.09.685A83A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1326A80011
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:08:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qVn5rTNk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=T9nykotc;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qVn5rTNk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=T9nykotc;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756724935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SUqhGh4rTv9B9oitYXxgj0bnq1HlZpXe0FlsUWYvcU4=;
	b=40fVFbcwWL82zoUKqZx572qZDR/pwo7ceEwXDordCr4toLI1pxXiWqWxgNgtpYqeVbRCZa
	zuQnfT+QvcpPN1oL3LWD1FB7s/BnPhQDi6TstdSlw+DPZfQ8iM12Rj5YgUkoqurXZKQMdg
	PWkVkxIfzzlwlhfOsBYiFslTtyuJ038=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qVn5rTNk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=T9nykotc;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qVn5rTNk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=T9nykotc;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756724935; a=rsa-sha256;
	cv=none;
	b=BrCMgfrVTXTKECydXdrvQjZd+O8q2k7TQZ3KplQTrBglOm+LvMAoEKcsv8e/RiNq1Xi2VP
	7ts9+7TMeWbaBGZ8Pbh634NLxpVAnk+RfzJT523efnuaQEsf9PzSJmPjQiyRang/LgQAi7
	Rq9lsI4UsM0XxiMYjKLf6HTJCe3AcTo=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1ED341F387;
	Mon,  1 Sep 2025 11:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756724933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SUqhGh4rTv9B9oitYXxgj0bnq1HlZpXe0FlsUWYvcU4=;
	b=qVn5rTNknZMzGbK67J36RUzRhlsiDWA+viXwVqKrOfKtaTI4zicyHaMAxlgrUQ4uCaxWfa
	Tbb4yNV54DUA4hzpJI/I08NC5DFLzTBnfewN581Pjw/CLKOP0PNyV53H+iez3RDr2jXZVR
	ZRARQzWleXgkhobw/q4He+ndd76vesw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756724933;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SUqhGh4rTv9B9oitYXxgj0bnq1HlZpXe0FlsUWYvcU4=;
	b=T9nykotcgPIf25AlYjhV9Kn46TVsFEW0RtEO+rGJtxgVIz4gsap6jaPtj9ioDJDULv40+z
	Bp1pmk+uCsdhj2Aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756724933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SUqhGh4rTv9B9oitYXxgj0bnq1HlZpXe0FlsUWYvcU4=;
	b=qVn5rTNknZMzGbK67J36RUzRhlsiDWA+viXwVqKrOfKtaTI4zicyHaMAxlgrUQ4uCaxWfa
	Tbb4yNV54DUA4hzpJI/I08NC5DFLzTBnfewN581Pjw/CLKOP0PNyV53H+iez3RDr2jXZVR
	ZRARQzWleXgkhobw/q4He+ndd76vesw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756724933;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SUqhGh4rTv9B9oitYXxgj0bnq1HlZpXe0FlsUWYvcU4=;
	b=T9nykotcgPIf25AlYjhV9Kn46TVsFEW0RtEO+rGJtxgVIz4gsap6jaPtj9ioDJDULv40+z
	Bp1pmk+uCsdhj2Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 04BC01378C;
	Mon,  1 Sep 2025 11:08:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id l4bYAMV+tWjtDgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 01 Sep 2025 11:08:53 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 00/12] maple_tree: slub sheaves conversion
Date: Mon, 01 Sep 2025 13:08:50 +0200
Message-Id: <20250901-maple-sheaves-v1-0-d6a1166b53f2@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMJ+tWgC/x3MQQqAIBBG4avErBO0KLCrRAut3xooCwcikO6et
 PwW72USJIbQUGVKuFn4jAWmrmjeXFyheCmmRjedttqow107lGxwN0T1rbdY5t76EKg0V0Lg5/+
 N0/t+V5n/sF8AAAA=
X-Change-ID: 20250901-maple-sheaves-63b9edc69bff
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Matthew Wilcox <willy@infradead.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, 
 Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org, 
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>, 
 "Liam R. Howlett" <Liam.Howlett@Oracle.com>
X-Mailer: b4 0.14.2
X-Rspamd-Action: no action
X-Stat-Signature: 1o6mhzg3y436qxsc5byu64rbifnfyz1q
X-Rspam-User: 
X-Rspamd-Queue-Id: 1326A80011
X-Rspamd-Server: rspam05
X-HE-Tag: 1756724934-851810
X-HE-Meta: U2FsdGVkX1/Tqm2In1xmmcZqPw2G+b8cz/2Q1Pu4mjYltEyJBASBAEjg/uKHJT7mD9rC/T/k01dtY0Lm5yTPj0HX/gf3a7h07uALzXEOxyFvfJFWLGhcc+Ea0vZZ7ndS82cxkPjf/tLaICxYTpKdfMgnZ7tmVsP4nN8TROp6IddlOql0aEy1VxnycyW2W3P1gD/QGxLqtNtY15QlCJFvfwcnTuS2WRAEla4pIwSw5XuQnb1cASRS9m8l2zzNVjvFoXyT5Hya1AO80FCymcOO2Ect2mtKRC7xVVlG+BYFah90c59vDfqsVt/s6d/5YG0MkgkoD+Q0yZiYphTcMnfvj0eNNTnl+uY9XtUfvxpXLhKLmanMojeOJhqQibo32QNp/QsYNQS/5HlY2eQL4WzAWXZD/GvtbOvfQlXr8Yq5U4NGIvMkzH+x+ivccqgzlc8LDQ8m9sNN2FuEB+hJPMbm9u/eGHew2nRuVXk57BTYRgSUT3gDjtXONpEupPVBYjEPt2NdGdzzN8QZneeLeJ1oemEG5NAu59u5bq2ou+TuGambbzOLD1xJYaUq893mzgZIiLqBrDHHhcJnDFrNA1A19KBUn8iMogCm8ZRxjqhGyuNdeYm5XU7lY+/GyLIIUjCg4yWCJUGwAW8F8BQhnNyINEK8Y5DmxDCLdqXnOPh4BQ5PtXLg6kEOXFcNrK7yMz/YowyPFxMPsFP1CeN0tlLwYXkTTt45XeJ2BFsYLzaK8drWK7IzNDXStRgZJkp0S2PXmaqrNRBk7kPDkxkOy5E2SZ+9zHj1UhKm8n2wZSNcYWpBSvSNGuNXltYX1viv7qU4ULtnb+k/hzee6h9jZ8cxnC+cpBv3YzUT4TfDYCI6qnMJW66waKxJqPDJj/ZAWbSRXdEOp7iKwJaZXwcL18y6lY8mj/fZTyK2SF5TS6zNtYBN7+8Cbakc2NuYxKWNgxkLaLLSuizBQgEGlw5U+Hu
 qOF2fmz5
 023ldtFLjuoc1KdK1Sgx/mfS98dd2oI/4jOiguIfLyuJ7ORFr7P9QBTCtF1eOZbCBtmeEeYjsINehzsl6AXNLbWgBHHmeLP6FuLXxTtoEQ5o4+lbgi66Zv9yAe63W+KhsN3QHNVswi2W6kyaqnmk9RcbH58JqYyPysdJjjmy0zMvvgwxlWIET5P0D9z33kmv4j1MKskeBpdwkxt70lzE9em5dT+xtrMKmfkO3yc3KFZ67R8+itGZSsuD+tZiRpjC8br7dS7yTFcKuI4tyJ9ddJPFQzqWLksokloB8O8O3y39ClTaM+WdHvKErtBFH9K6gfD0CbIdEHbWMe2xuFojjfa5sk1hryAvBpJ84sTqhC8AFlRW29oMnL7RLRdvNxRj8zhdq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The previous version of this work was part of the patchset that
introduces slub sheaves, but for practical purposes was split out in v6
[1] while Liam did some further fixups and cleanups to the maple tree
and associated testing implementation, incorporating also patches from
Pedro [2] and then provided to me his branch [3] to include it. It
relies on [1] in the slab/for-next tree so the intent is to include this
in slab/for-next as well. More precisely speaking, patches 2 and 3 will
replace the last two patches of [1].

[1] https://lore.kernel.org/all/20250827-slub-percpu-caches-v6-0-f0f775a3f73f@suse.cz/
[2] https://lore.kernel.org/all/20250812162124.59417-1-pfalcato@suse.de/
[2] https://git.infradead.org/?p=users/jedix/linux-maple.git;a=shortlog;h=refs/heads/sheaves-v6r2_fixes

git version:
https://git.kernel.org/vbabka/l/maple-sheaves-v1

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
Liam R. Howlett (8):
      maple_tree: Fix check_bulk_rebalance() test locks
      tools: Add testing support for changes to slab for sheaves
      tools/testing/vma: Implement vm_refcnt reset
      testing/radix-tree/maple: Hack around kfree_rcu not existing
      tools: Add sheaf to slab testing
      maple_tree: Sheaf conversion and testing
      maple_tree: Add single node allocation support to maple state
      maple_tree: Convert forking to use the sheaf interface

Pedro Falcato (2):
      maple_tree: Use kfree_rcu in ma_free_rcu
      maple_tree: Replace mt_free_one() with kfree()

Vlastimil Babka (2):
      maple_tree: use percpu sheaves for maple_node_cache
      tools/testing: include maple-shared.h in maple.c

 include/linux/maple_tree.h          |   6 +-
 lib/maple_tree.c                    | 399 +++++++++--------------------
 lib/test_maple_tree.c               |   8 +
 tools/include/linux/slab.h          | 165 +++++++++++-
 tools/testing/radix-tree/maple.c    | 483 +++---------------------------------
 tools/testing/shared/linux.c        | 120 +++++++--
 tools/testing/shared/maple-shared.h |  11 +
 tools/testing/shared/maple-shim.c   |   7 +
 tools/testing/vma/vma_internal.h    |  98 +-------
 9 files changed, 439 insertions(+), 858 deletions(-)
---
base-commit: 2a2cada7250179353220bea9548acd7e7ed96e48
change-id: 20250901-maple-sheaves-63b9edc69bff

Best regards,
-- 
Vlastimil Babka <vbabka@suse.cz>


