Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86575606A323
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 02:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=f6zGVErF
Received: by kanga.kvack.org (Postfix)
	id 9421F6B05B2; Sun, 25 Oct 2026 22:56:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F3356B05B3; Sun, 25 Oct 2026 22:56:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 808746B05B4; Sun, 25 Oct 2026 22:56:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 51CBE6B05B2
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 22:56:13 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BDC0B40660
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:56:11 +0000 (UTC)
X-FDA: 85363263342.24.EBF3F25
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf30.hostedemail.com (Postfix) with ESMTP id 552ED80006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:56:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=f6zGVErF;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf30.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792983370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZSHOP9vYCrVIMLOfjskmyREPSPWOTx5gY4tO1jbmCzQ=;
	b=qP/yJkOZnmNAxaId6XcxkRbHTwX6J/kN8QQ5T38CQ6A9oYu3yBpZHZptdWzPLxvx4nwbmS
	/S3UDcTTD+Rt2NDhrYvjGEEtzg/q8lVld54O5Bn5+P0PC1F0mtOas1Vjr491QVxYmw7+bt
	zEUGt8nlDESFuqnvit2ZgdvwEM6ge5w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=f6zGVErF;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf30.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792983370;
	b=X5nORTT1O24YN0XSZRmdcGzv49Uv5swD08PLztKlKXFDz6jfwF6f/I32U1cXE27vxtXgGA
	wuFCLtZLwYYtKVcm/QdBP0mwg0ZwAl7Mi/6kmiEQKxBbkPAmTgxJzfxamEtTkEsgvpfWGW
	comS1Q8tEgDuKX53HohwI2aa0DcFXvU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792983365; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=ZSHOP9vYCrVIMLOfjskmyREPSPWOTx5gY4tO1jbmCzQ=;
	b=f6zGVErF3tueCPLmSuB9XnmuUrNhYB14+NrtATrDVo/Hb1gdRbBWmAbi0NOiG/cduC9gK324ltuKaBwQvE4Wh6bkyXJ9HbK4U4w4/l0HOZzmZQobfi3WOdVjIX0KYebg/x59IswcRxbtkXHoibpa/NixEXTi7rDZPECnwORttTQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R631e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=xiangzao@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XDRaMhh_1792983363;
Received: from banye.tbsite.net(mailfrom:xiangzao@linux.alibaba.com fp:SMTPD_---0XDRaMhh_1792983363 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 26 Oct 2026 10:56:04 +0800
From: Yuanhe Shu <xiangzao@linux.alibaba.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Kaitao Cheng <kaitao.cheng@linux.dev>,
	vbabka@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	ziy@nvidia.com,
	wangkefeng.wang@huawei.com,
	tujinjiang@huawei.com,
	mgorman@techsingularity.net,
	chengkaitao@kylinos.cn,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	xiangzao@linux.alibaba.com
Subject: [PATCH v2 1/2] mm/compaction: skip folios containing hwpoisoned pages
Date: Mon, 26 Oct 2026 10:55:51 +0800
Message-ID: <20261026025552.1427901-2-xiangzao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261026025552.1427901-1-xiangzao@linux.alibaba.com>
References: <20261026025552.1427901-1-xiangzao@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 552ED80006
X-Stat-Signature: nfw5cnsp8tgrxphpzc6t4xjf87zobwpy
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792983367-423685
X-HE-Meta: U2FsdGVkX1/wfgpJizfV2/FMk15QtBkh8T1UoDiJpgx/t+8zNDsNp/+pQI7A5OqMb/9Hp25mXgYL31d+jebmVFA7TpJaY4jJIVEVR8rB/MYj+HF+ligJl8jCFRR02RpK56Lc41WG/AA3pwyodlo2tD4R9Zn0awdoEm7eEYpPx+S9tQ3DHQju8Zl2Hi1FW0LSSHv2nnDxothOm8L6FGsh34EE/v2khOJUB7bdJa5k2H6dmPZ2UcoTFkdA59heWaADwoXIg5VlShVYw6A6UV2tfAafxile7jRvn6lYHjBWnftWjKTxYtNUfQRGGEpQ4efYKaDjbwVOjx8tOHFWaNW6kYb3gRyv4WpJar7LlAMJus+u2keoRq+dJrSpaHGhjfrSiast9/JK/RkFnWaEQ03spKtpN0VLJfN6fkOp2i0RMINZImECLWPXaooHekOuCgB42k470wtZ7cIbYFAJMJ+UgRRW1b7szZCTHIl+n11Hjb9ss+Ro3hRRLTeeyaUhvZNcOs1JdPgCy4hGE4C4pQ6u/vMywXucytNaOD5JqKoA0pEgeoki37JeT1jgSOvE1HyP2ZVmG8rym1DjeZMLFKa05tEHje1On7ZFXR5dmylINxv3qtIE0T07Blf0dLL56fBv/2nM/HOWXIkvJfTlEyr/UtplgVUbHyac/jchKKC18CoU3Fwx6QHvN6RS977H7v9NQHyBoT8izoEAMItu+OfgVSaeh8T/fhT9uLZr70cf4ZdGa6JNdF35JF54Tb9CzFRf5K1YSbYhgBBQ/KPUmKIXhbx5JPHFXzeecnG97NN+H4sudR7eJtY9Vdxj7KyhMhWh3mv1SVzG9BgAiTtmA03kyEjF63Aatxj1i0n7fRDNm4FD6WKxf4ScIOzYw140YH1TVFHedpkxpurXN6ii2/us2fbz6Mwk2ClaF15Oxlc/0rlobWaBb1VKUaQIAUKLZ9cqZ2lYNs/7DeyO30e0SQN
 PsNpX1W8
 r8SmHmy3JJNkHq52IDh+EgIWo6+YRBiTxbvdmQtEi/vZsSLxIZtdjRwKnND8/Yqqs9upXS5si/rT4NPdKLsnGcXzsNuwTRXOF/nwh1d+PwURoIDsSsYyO9Rge3gPQXUNEOJng3BAywlpUjp9uTfyzqnU1/NArLZILsAEuc5obFZJnH56CxX+mJ/gR60PAl1wlxjzFs2NDACLvhdZmc+2ESfUGK86Njq79g/cx4N8Cnmq86TA7FhI5evemJOAlDMzKLwd41RTYp116TdZWBCAVYRU6XAAG51n1Pszpo7Q46uDwF9rcIJkqdDiJWF1fcOfTVM+XJbKB2LGRlxc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

memory_failure() sets PG_hwpoison on the error page before it manages
to pin the folio via get_hwpoison_page().  Compaction running on
another CPU can isolate that same folio in the meantime, so
HWPoisonHandlable() then fails on !PageLRU(), the retry loop in
get_any_page() exhausts itself and memory_failure() gives up with
MF_IGNORED - while compaction still has the folio on its
migratepages list, flagged PG_hwpoison.

Nothing stops compaction from migrating such a folio afterwards.
The corrupted data is copied into a fresh folio that carries no
poison marker, and no hwpoison PTE entry is installed on the way
back: the userspace mapping is silently redirected to the corrupted
copy and no SIGBUS is ever delivered.

A large folio with a PG_hwpoisoned subpage can also sit on the LRU
without any race at all, via the THP-split-failure path of
memory_failure() (kill_procs_now() + MF_MSG_UNSPLIT_THP); the guard
below catches that case as well.

folio_mc_copy() does not close this hole: it only detects corruption
at copy time and only where ARCH_HAS_COPY_MC is implemented (x86_64
and PPC64; elsewhere copy_mc_highpage() degrades to a plain copy).
Software-injected poison never traps during the copy on any
architecture, and that is what MADV_HWPOISON, the hwpoison-inject
interface and the fuzzers exercise.  An isolation-time check avoids
the migration of a folio that is already flagged, on all
architectures and for both real and simulated poison; a poison
landing after isolation is what patch 2 checks for.
The check itself is two flag tests on the head page (PG_hwpoison
and the folio-level has_hwpoisoned marker), not a walk over
subpages.

Neither page reclaim nor memory hotplug lets such a folio be
copied into a fresh one: reclaim unmaps the poisoned order-0 page,
and skips the hwpoisoned large folios it cannot safely unmap, in
shrink_folio_list()
commit 1b0449544c64 ("mm/vmscan: don't try to reclaim hwpoison folio")
commit 9f1e8cd0b7c4 ("mm/vmscan: fix hwpoisoned large folio handling in shrink_folio_list")
while memory hotplug refuses to migrate them in do_migrate_range()
commit 5f5ee52d4f58 ("mm/hwpoison: introduce folio_contain_hwpoisoned_page() helper").
Skip them in compaction as well, for the same reason reclaim settled
on skipping: the UCE is rare and a race with compaction is rarer
still, so skipping is enough, and a later memory_failure() will
handle the folio if the UCE is triggered again - while a migrated
folio would silently propagate the corruption instead.

Deterministic validation on v7.3-rc4-75-g62f4c998b297: order-4
mTHP folios were brought into the stable "large, on LRU,
PG_hwpoisoned subpage" state by pinning a sibling subpage with
vmsplice and injecting MADV_HWPOISON on another subpage, which
makes memory_failure() take the THP-split-failure path; after
triggering compaction, /proc/kpageflags shows which poisoned
folios moved.  The unpatched kernel migrated 16/16 poisoned
folios and 16/16 clean controls in the same pageblocks; with
this patch, 0/16 poisoned folios were migrated while their
controls still migrated 16/16.

Soft offline is not affected: it only sets the poison marker after
its own migration has succeeded.

Assisted-by: LLM
Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
---
 mm/compaction.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/compaction.c b/mm/compaction.c
index a049415512c6..491adcbc5313 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1093,6 +1093,14 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		if (unlikely(!folio))
 			goto isolate_fail;
 
+		/*
+		 * Migrating would copy the corrupted data into a fresh
+		 * folio with no poison marker; skip, as memory hotplug
+		 * refuses to migrate such folios for the same reason.
+		 */
+		if (folio_contain_hwpoisoned_page(folio))
+			goto isolate_fail_put;
+
 		/*
 		 * Migration will fail if an anonymous page is pinned in memory,
 		 * so avoid taking lru_lock and isolating it unnecessarily in an
-- 
2.43.7


