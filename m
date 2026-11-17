Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C049A606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 14:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a786Rfbu
Received: by kanga.kvack.org (Postfix)
	id D058F6B05B8; Tue, 17 Nov 2026 09:26:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDD226B05B9; Tue, 17 Nov 2026 09:26:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF3846B05BA; Tue, 17 Nov 2026 09:26:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A1E6A6B05B8
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:26:38 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F97C1203C3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:26:38 +0000 (UTC)
X-FDA: 85444836876.02.AF71599
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7DD141C0005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:26:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a786Rfbu;
	spf=pass (imf18.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794925596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rlQlNnIZ/8+czgBS03uRUWP6VlvdPXDkWQ0M5ulQFY4=;
	b=G9cWLGMyxI54Pc/dzif8iSOOEX6Gg3M9Quiq8JTAtdFdg4yqul/dyPOEQaAktl88fqonBZ
	qZMAPaDGazBIFqXqqr4lVA4laCjQrxJuR4yx2KlzY5qLi8dzA7rXfzupCLz5cWd22slvmK
	oOvPwXig+XANHKKFb8RtVKIGNOfKG/I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794925596;
	b=GWypiqgxYdGOVPd0y5xl/eecTfMXYOAYzqP2+bLRfyGA3R++tx0/gzq/a77kqL1bWXSAmV
	xISuekDPdpKB/WVXxfW/zDaGGfmlYE1ju3xOYS0mMOcxKBCWdFfKpjOptyjbmywBhXCTIQ
	cQ0tqjghnRoh3oOFNMpFEUsUu0D4xP4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a786Rfbu;
	spf=pass (imf18.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A38840AF4;
	Tue, 17 Nov 2026 14:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97441F000C4;
	Tue, 17 Nov 2026 14:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794925595;
	bh=rlQlNnIZ/8+czgBS03uRUWP6VlvdPXDkWQ0M5ulQFY4=;
	h=From:To:Cc:Subject:Date;
	b=a786Rfbua0e0KJuPtqYPrAIOolUAlNtoH1SVZATqAvSLv5QCYzTn6e5ZZA3a3CXny
	 cfYU2pdCDUr+8PSpqVQH45cyGXtnH0KcTKXZChHeqW3yCdz2yvjSv3dER9ldKvWinU
	 pRybFcIIIcJ1x1gVcDse8TFcN3hO2F6bLrYBQvCAo6D7TOleOtwQ53V5oGlr7EKEM0
	 kK5eXgT7ULE0fn5gQuNToj51Fn2ORWLRIoFLkaNQ4ZmXOovexDaF5bhF8n25xErblJ
	 uVZYrvqMo9ETwQcBDzyZjuDO+zGRShjt5/qw3N8oqLjMr8+LEV7EHw19Fgm3n0obgH
	 2R7eQdFuYIeTQ==
From: Arnd Bergmann <arnd@kernel.org>
To: David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>
Cc: larips <larips950@gmail.com>,
	stable@vger.kernel.org,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jackie Liu <liuyun01@kylinos.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/mempolicy: fix copy_nodes_to_user() for odd inputs
Date: Tue, 17 Nov 2026 15:25:53 +0100
Message-ID: <20261117142628.3931151-1-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7DD141C0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3jajortfugpmkfnoh1isq7tnkhmjmih8
X-HE-Tag: 1794925596-166012
X-HE-Meta: U2FsdGVkX19E7rFdQRvbrYw65bwsgoaVZoHGHMGtMJTK6oEvgff8DRv0iEbw02vdQL8UCOS391dhHnvfAx4pZ+BY7Oh/elIYP+FtAn8nqjQ8GARV+iOdzohUGf4QQQLT7m1sA0c7zT3YWBRiYZNIkwWRVXlbvvsVfVF4vEiVu3UcjlNnWaFd5Wr+Ry7rgsg1Vrvzfe+94CGlfQ4tdlW/6aYENdajico+NyHFJrwfHmmcnYssyOs7RvI28xCHTG/fzG8ogjBAD6Tmissv8sq/X/TL6G1dC8UFroxDOAEG1yIBU8Nt3x4GQUdMSW70/GZsK/KIkH0PHkpPUgUnJoeDFX40/VO8rXyKcS2j3Gg0wbt49Rvl3BMskWvEONmBk1GAKrroVHoaypRlJ68XJFyAL2itd0bQqpmqn02SL1K5MDVMwRG98aGuiyMWaB9CD8+TO2KASxk/tqpzMedDdgpOuNEgk5yBQYWnljGTy4ebeU0tqu3PcSY6JxACcfV4hxB9SUxfgY2GbHf8ayR9YUWOyLX2+vFMiM4NGhnMyx3ZTk+OmfYIeJmeq6c0mvqZlxBpxASKuyjI+3p4+GoqOkCXNRlyQ3Z9QddyVSiWD9xCObdk217506VjntQ4g3+MUdRJzUb3lXrKgy4FvMrykA8XlXYdLV94ZAcn7F3YcFC/KbNjpkHdyxBIvtmxDzybo812LH5cQvp3N1vv5WWPzg2Lt4MT4SSnF+BeP0UJo2NkqjXXyRNSATWZo6Hku4HNZshyBdbiD4ARPuTGEqEQDk9PjAO5l3KviSiYi5wO5XOK4oEAUW+lSkWJzdI57Ox2n1/aEKj9M1b5mE+jCoIhRNMIOO0x7c1EZkvKTRna/U52Io2qOYriB0tUPuH4QvLP48TFnJpCVaQIUiMJteH89uoJ3h8OalR9A4quG0h5FoGE7SwRjD2MtbUI2YSNACcf1yvQJi3PNkmzdgdBQEWtDEe
 z8GWhq+b
 Ms/xDRP8dHd47pwUuZLG4t6JCJ3EpLbCMR3wR1Y8/2mqi9GUTxCikiCFqTA2YNho80ATQn25AEdJcAkgjPiK2TO/8cmj93Yk+fV8+dbjYAhg9N86b0NQnQi+pWxe3TgZ29IegvFluSx9p+c4cajssqUUHgmCsv6Enjoscl5dQoA+UTEV3tWH+/09AJLtnHQ8hyI3+oYVGy4dTNSvOLZIB3Hndw5g6do1y/IyVrj0nlFmWmmunxjN0rBlPgadA6TV40KAe1b8nb1ix9t+zn9UrjxGotT/Jr5adLufjdeaZ/K6vMv8TCZ+VeCKtWNUckqiAW6NkP9FBPDBTAyXjBaxKHiQzzRmxfWRXy9t0u/y54HOzrzymQzU1x3g/y8e/NHDWIUszh/+b4qQwxrujk0Zv6am+/njxfwIQskDPOIl4h7f6u+uXBG4MpBE0PA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Arnd Bergmann <arnd@arndb.de>

The ALIGN(maxnode-1, 64) check has an off-by-one error that leads to
rounding down too much, and ends up not copying the last word when
userspace asks for one bit over a multiple of 64.

For compat syscalls, the effect is worse, as the actual calculation for
the size does include the extra word, but the check for the input size
does not take it into account and can leak a word of stack data.

In addition, the size calculation rounds up to multiples of 64 bits
instead of multiples of word size as documented in the man page and
expected by numactl.

Fortunately numactl always passes multiples of 64 here, so none of
this affects userspace we care about. Finally, the 'nbytes' calculation
for compat mode makes no sense since that is the size of the kernel's
internal representation, not the userspace side.

Fix the 'copy' calculation to address all of the above. Note that the
off-by-one error has been in there since the beginning, but commit
e130242dc351 ("mm: simplify compat numa syscalls") is where we starting
copying the wrong data.

Reported-by: larips <larips950@gmail.com>
Reported-by: Gregory Price (Meta) <gourry@gourry.net>
Fixes: e130242dc351 ("mm: simplify compat numa syscalls")
Link: https://lore.kernel.org/all/20261117101910.1820066-1-gourry@gourry.net/
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Please double-check the calculation and retest this with the original
reproducer. The off-by-one error does explain all of this, I'm still
worried about getting this version wrong again as everyone including
myself seems to have missed this in the past 25 years and there may
still be additional subtle issues around it. Apparently we had many
instances of the same off-by-one in this file but all (most?) others
got fixed inadvertently by other changes in the past.
---
 mm/mempolicy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 6d662a9a8c74..f318e1155770 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1749,12 +1749,12 @@ static int get_nodes(nodemask_t *nodes, const unsigned long __user *nmask,
 static int copy_nodes_to_user(unsigned long __user *mask, unsigned long maxnode,
 			      nodemask_t *nodes)
 {
-	unsigned long copy = ALIGN(maxnode-1, 64) / 8;
+	unsigned long copy = ALIGN(maxnode, BITS_PER_LONG) / 8;
 	unsigned int nbytes = BITS_TO_LONGS(nr_node_ids) * sizeof(long);
 	bool compat = in_compat_syscall();
 
 	if (compat)
-		nbytes = BITS_TO_COMPAT_LONGS(nr_node_ids) * sizeof(compat_long_t);
+		copy = ALIGN(maxnode, BITS_PER_COMPAT_LONG) / 8;
 
 	if (copy > nbytes) {
 		if (copy > PAGE_SIZE)
-- 
2.53.0


