Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 658C4606A339
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 09:40:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4712F6B0663; Tue, 27 Oct 2026 05:40:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 423B16B0665; Tue, 27 Oct 2026 05:40:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EB946B0666; Tue, 27 Oct 2026 05:40:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F15C86B0663
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:40:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 880AB80962
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:40:45 +0000 (UTC)
X-FDA: 85367911650.29.0474749
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf13.hostedemail.com (Postfix) with ESMTP id 46DB820005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:40:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793094043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gJJj+e5ghXIk3mLQ0TvxU5VvD3Orm2FE5Srl4dGJX6Y=;
	b=QoPSKS2A4aTKzA8QtCjwnpP4pCegi+kDOx6aaVqvtY9/gx01K/HwVH1Xx5JWZqMMNllWPt
	Z7BTY8XKWwIbuAuzNT5Gf/kPY8JyIzU1mmx9U8CqyPfp2GhPpkhPFTniGRJqp/dwOm0/jm
	xV0BaXtBwR4F7bzruZw0mmnESBtItRE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793094043;
	b=cGmiXZjkEbyeizpXq2jlVruZq1/wTiQmDRSm9eU+x60iC0N2LQUsovdlqanmsrTgFT9/i7
	KOUd7ZffPKI8aVAJM0aCFD3LxANYUunJa/28Zbau81H4NT90Mzon9fDv3IYARIK+H5NwlQ
	igr5NLAsx054mMtmV1CBVB1+mHcoPoc=
X-UUID: 74d5704ad1ea11f19a56ed5b684f684d-20261027
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:c09bac58-4248-4467-862f-47eb338eee00,IP:10,
	URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-15
X-CID-INFO: VERSION:1.3.19,REQID:c09bac58-4248-4467-862f-47eb338eee00,IP:10,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-15
X-CID-META: VersionHash:7db8b62,CLOUDID:c143c288af083e61f6a1f53a63319d3a,BulkI
	D:26102717403633SDZJ33,BulkQuantity:0,SF:17|19|38|66|78|81|82|102|127|136|
	850|865|898,TC:nil,Content:0|15|50|99,EDM:-3|-100,IP:-2,URL:0,File:nil,RT:
	nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:
	0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 74d5704ad1ea11f19a56ed5b684f684d-20261027
X-User: wangxuewen@kylinos.cn
Received: from localhost.localdomain [(223.104.42.231)] by mailgw.kylinos.cn
	(envelope-from <wangxuewen@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1101242977; Tue, 27 Oct 2026 17:40:33 +0800
From: Xuewen Wang <wangxuewen@kylinos.cn>
To: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Xuewen Wang <wangxuewen@kylinos.cn>
Subject: [PATCH 1/2] mm/shmem: trace swapin results and order fallbacks
Date: Tue, 27 Oct 2026 17:40:13 +0800
Message-Id: <20261027094014.2432692-2-wangxuewen@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261027094014.2432692-1-wangxuewen@kylinos.cn>
References: <20261027094014.2432692-1-wangxuewen@kylinos.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 46DB820005
X-Rspam-User: 
X-Stat-Signature: 4qrrate513kw6as3di8ibtw5x345oyio
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793094041-169461
X-HE-Meta: U2FsdGVkX1+VzIfvDpU7oFYFBpNtWoi1q27/ckkOKT8inahzIbH1eLiEc9ymggVP4GS9LRXrerMIdzvvtt0xdMhSpjAm8o06aMjHhPhZhWz8i5l+D8TW1Ua7t1W/dZTyZukVDvuVt2DgMPpOlVuRqC46Q1xbFW3uDE9Ng/mOZH3ZpjjKCUBAoCDEyPBjmlIEqWXXCEniCNFjWijjSzPKfTMht8MSp9Ni3j0cBs9/cktA4DVIW572LUjTlOEpEzAk/6oE8XUfULd8rtxyFZH28r1DyLVkOOQ3QKtJrTUOsN7aTGW6uBMiCMsVONtxIbQ/UNysIslhMKG0A/dVTXytjT7Uyx6pifL2hizSrAM6mh4ZyoAtIEgOvD2wi9PvnPdwjh8s0JPiPT+xYLH2RvizAIOUpXNQqlHuy9JhS0Kq8Ts6zFSIyLXNwttDnzg1k5BQFzV/UGcuDSkaLC+YqkGJftTUNlVSFK12m7Z92po4LIenKq3OL/R/UJb4m8JUpgjYSsQWnHdeBnlSzv3/xogELmP3gpnXgNLvR86iEoBJpR0IuRoPijr8/1zB5+e94ELhqf5r024j708Um1EvZzyYsPKKUYjMQvqCJ7aCH7yG9R++UDXGTZd4k1OSw4cUF+bx9V3gWQZINrEOwpTaPcT8DmOgsaoq3ZkOav5mL/qVIaV+pTpBt47kcjj1o0qQzH4fCzaM1tMNa1U9NCjCfRqhaFn1RRiiSXkjtD/QRPbRDRqQ8Hm35BAVuQKQ4jKQ0W0L23hFGeDQgomk97cWAtMz2XnATpFB/myZTmzWHEx6dOneYpjywjNTdSXa3UnxY8g/oZI066BFzw9cmzd7zJFlVw7Q+ob1m1IBORgdOeXtxtrcj1BAnn5QqF1OG55RKgWHcQ3cOns2DUPjKJVQNXmpvQ8+GjGeukJ75Vx0Qxlwa7VRxLHcL2VkG7V5hCu4JFXaRFZGiWLPmhaMPzPKDx+
 TM8y+FQN
 oyrfRpaIUVoq4m1Tcd30rHJ8LaQ5Ecz8dd7XykENJHNTcrrTv4kuwlxBt/btTi+g9l+R9xW/HDW/QPVOx7y8uS9AzMVXAB/N5oTvTSaGkOs0n+A4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

PSWPIN and ZSWPIN describe swap traffic but cannot identify which tmpfs
file caused it. Shmem swapins initiated through read() do not increment
PGMAJFAULT. This makes it difficult to identify which shared-memory file
is being brought back under memory pressure.

Add an event at each return from shmem_swapin_folio(), with the
filesystem device, inode, original caller index and XArray entry, entry
and folio orders, path and return value. Include entry validation
failures and poison markers so failed attempts are visible too.

Record explicit downgrades from a higher order to order 0 when the
faulting VMA has userfaultfd armed or zswap_never_enabled() returns false.
Record both reasons when both restrictions apply. The zswap restriction
follows a static key, not the current enable setting: it persists after
zswap is disabled and also applies with CONFIG_ZSWAP_DEFAULT_ON=y when
booting with zswap.enabled=0. Initial order-0 requests do not set policy
reason bits.

Also record the initial error when a higher-order synchronous attempt
fails and is retried at order 0. Use sync_fail for this case: the swap
layer can reject a range with -EBUSY before allocating memory, and
-ENOMEM can also come from memcg charging. A racing swap-cache insertion
may supply a folio of a different order, so the fallback fields describe
the request, not its outcome.

Existing swpin_fallback and swpin_fallback_charge counters report
failures on the swap allocation path, but lack inode attribution and do
not describe these policy restrictions. Carry the fallback decision and
final result in the same event so users do not need to correlate
separate records.

Document attempt semantics, swap-cache hits and order sentinels. A
successful event represents a folio installed in the file page cache;
it need not involve disk I/O or a major fault. Keep the existing return
and retry behavior.

Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
---
 Documentation/trace/events-shmem.rst | 73 +++++++++++++++++++++++
 Documentation/trace/index.rst        |  1 +
 MAINTAINERS                          |  2 +
 include/trace/events/shmem.h         | 86 ++++++++++++++++++++++++++++
 mm/shmem.c                           | 64 +++++++++++++++------
 5 files changed, 207 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/trace/events-shmem.rst
 create mode 100644 include/trace/events/shmem.h

diff --git a/Documentation/trace/events-shmem.rst b/Documentation/trace/events-shmem.rst
new file mode 100644
index 000000000000..45da82761360
--- /dev/null
+++ b/Documentation/trace/events-shmem.rst
@@ -0,0 +1,73 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Tmpfs and shmem events
+=====================
+
+The events in ``events/shmem/`` attribute swapin and allocation activity to
+``dev`` (the filesystem device) and ``ino`` (the inode number). They also
+cover anonymous shared memory and memfd files. ``index`` is the page offset
+requested by the caller, before any alignment for a large folio.
+
+Swapin
+------
+
+``shmem_swapin_folio`` records each return from ``shmem_swapin_folio()``.
+``error`` is the return value: zero means a folio was installed in the file
+page cache; ``-EEXIST`` normally asks the caller to retry after a race.
+Entry validation failures and poison markers also produce events.
+
+``entry`` contains the original XArray entry's type and offset. For a large
+entry, this is its base swap slot even when ``index`` lies in its middle.
+For ``path=poison``, it encodes a marker, not a real swap slot.
+
+``requested_order`` is the confirmed XArray entry order, or -1 when unknown.
+``actual_order`` is the order of the folio obtained, or -1 if none was
+obtained. A nonnegative actual order does not imply successful insertion:
+always check ``error``. One successful event may cover multiple pages.
+
+``path`` identifies the branch taken: ``lookup`` for entry validation
+failure, ``cache`` for the initial swap cache hit, ``sync`` for synchronous
+swapin, ``readahead`` for the readahead helper, or ``poison`` for a marker.
+The helpers may themselves find a cached folio, so path does not prove I/O
+occurred. Event counts are not disk-I/O or major-fault counts.
+
+``fallback`` is a bitmask recording explicit downgrades from a higher order
+to order 0 in the synchronous helper. An initial order-0 request does not
+set policy reason bits, even when the policy conditions hold. Set reasons
+are printed separated by ``|``:
+
+* ``none``: no explicit downgrade in the synchronous helper.
+* ``userfaultfd``: the VMA has userfaultfd armed.
+* ``zswap``: ``zswap_never_enabled()`` is false, restricting the request
+  to order 0.
+* ``sync_fail``: the initial higher-order synchronous attempt failed.
+
+The zswap restriction follows a static key, not the current enable setting.
+It persists after zswap is disabled and also applies with
+``CONFIG_ZSWAP_DEFAULT_ON=y`` even when booting with ``zswap.enabled=0``.
+The policy reasons can occur together, so both ``userfaultfd`` and ``zswap``
+are recorded when both restrictions apply to a higher-order request.
+``fallback_error`` preserves the initial synchronous error, including
+range conflicts such as ``-EBUSY``; it is zero for policy downgrades and
+when fallback is ``none``. ``-ENOMEM`` can indicate allocation or memcg
+charging failure.
+
+These fields describe a decision to request order 0, not a guarantee about
+the returned folio: a racing swap-cache insertion may provide a different
+order. Swap-cache and readahead paths can also return a smaller folio
+without setting ``fallback``.
+
+For example, after mounting tracefs at ``/sys/kernel/tracing``, use a private
+instance to capture a workload's swapins::
+
+  mkdir /sys/kernel/tracing/instances/shmem
+  cd /sys/kernel/tracing/instances/shmem
+  echo 1 > events/shmem/shmem_swapin_folio/enable
+  # Run the workload, then stop recording before reading the buffer.
+  echo 0 > tracing_on
+  cat trace
+
+Filter or aggregate by both ``dev`` and ``ino``; inode numbers alone are
+not unique across mounts. Trace filters use the numeric values shown by
+the event's ``format`` file. Check ``per_cpu/cpu*/stats`` for dropped events
+before interpreting counts.
diff --git a/Documentation/trace/index.rst b/Documentation/trace/index.rst
index f4058e8e92e3..dbf407744430 100644
--- a/Documentation/trace/index.rst
+++ b/Documentation/trace/index.rst
@@ -51,6 +51,7 @@ applications.
 
    events
    events-kmem
+   events-shmem
    events-power
    events-nmi
    events-msr
diff --git a/MAINTAINERS b/MAINTAINERS
index d2fc3d8364b3..8f6a02dcf9c7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27602,8 +27602,10 @@ M:	Hugh Dickins <hughd@google.com>
 R:	Baolin Wang <baolin.wang@linux.alibaba.com>
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	Documentation/trace/events-shmem.rst
 F:	include/linux/memfd.h
 F:	include/linux/shmem_fs.h
+F:	include/trace/events/shmem.h
 F:	mm/memfd.c
 F:	mm/shmem.c
 F:	mm/shmem_quota.c
diff --git a/include/trace/events/shmem.h b/include/trace/events/shmem.h
new file mode 100644
index 000000000000..7a0050a1686f
--- /dev/null
+++ b/include/trace/events/shmem.h
@@ -0,0 +1,86 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM shmem
+
+#if !defined(_TRACE_SHMEM_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_SHMEM_H
+
+#include <linux/bits.h>
+#include <linux/fs.h>
+#include <linux/kdev_t.h>
+#include <linux/tracepoint.h>
+
+#define SHMEM_SWAPIN_LOOKUP	0
+#define SHMEM_SWAPIN_CACHE	1
+#define SHMEM_SWAPIN_SYNC		2
+#define SHMEM_SWAPIN_READAHEAD	3
+#define SHMEM_SWAPIN_POISON	4
+
+#define SHMEM_SWAPIN_FALLBACK_NONE		0
+#define SHMEM_SWAPIN_FALLBACK_USERFAULTFD	BIT(0)
+#define SHMEM_SWAPIN_FALLBACK_ZSWAP		BIT(1)
+#define SHMEM_SWAPIN_FALLBACK_SYNC		BIT(2)
+
+#define show_shmem_swapin_fallback(flags)			\
+	(flags) ? __print_flags(flags, "|",		\
+	{ SHMEM_SWAPIN_FALLBACK_USERFAULTFD, "userfaultfd" },\
+	{ SHMEM_SWAPIN_FALLBACK_ZSWAP, "zswap" },	\
+	{ SHMEM_SWAPIN_FALLBACK_SYNC, "sync_fail" }) : "none"
+
+TRACE_EVENT(shmem_swapin_folio,
+
+	TP_PROTO(struct inode *inode, pgoff_t index,
+		 unsigned int entry_type, pgoff_t entry_offset,
+		 int requested_order, int actual_order, unsigned int path,
+		 unsigned int fallback, int fallback_error, int error),
+
+	TP_ARGS(inode, index, entry_type, entry_offset, requested_order,
+		actual_order, path, fallback, fallback_error, error),
+
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned long, ino)
+		__field(unsigned long, index)
+		__field(unsigned int, entry_type)
+		__field(unsigned long, entry_offset)
+		__field(int, requested_order)
+		__field(int, actual_order)
+		__field(unsigned int, path)
+		__field(unsigned int, fallback)
+		__field(int, fallback_error)
+		__field(int, error)
+	),
+
+	TP_fast_assign(
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = inode->i_ino;
+		__entry->index = index;
+		__entry->entry_type = entry_type;
+		__entry->entry_offset = entry_offset;
+		__entry->requested_order = requested_order;
+		__entry->actual_order = actual_order;
+		__entry->path = path;
+		__entry->fallback = fallback;
+		__entry->fallback_error = fallback_error;
+		__entry->error = error;
+	),
+
+	TP_printk("dev=%d:%d ino=%lu index=%lu entry=%u:%lu requested_order=%d actual_order=%d path=%s fallback=%s fallback_error=%d error=%d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino, __entry->index,
+		  __entry->entry_type, __entry->entry_offset,
+		  __entry->requested_order, __entry->actual_order,
+		  __print_symbolic(__entry->path,
+				   { SHMEM_SWAPIN_LOOKUP, "lookup" },
+				   { SHMEM_SWAPIN_CACHE, "cache" },
+				   { SHMEM_SWAPIN_SYNC, "sync" },
+				   { SHMEM_SWAPIN_READAHEAD, "readahead" },
+				   { SHMEM_SWAPIN_POISON, "poison" }),
+		  show_shmem_swapin_fallback(__entry->fallback),
+		  __entry->fallback_error, __entry->error)
+);
+
+#endif /* _TRACE_SHMEM_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/mm/shmem.c b/mm/shmem.c
index 9f0965b8b59c..3b910aec5bcf 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -87,6 +87,9 @@ static struct vfsmount *shm_mnt __ro_after_init;
 
 #include "internal.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/shmem.h>
+
 #define VM_ACCT(size)    (PAGE_ALIGN(size) >> PAGE_SHIFT)
 
 /* Pretend that each entry is of this size in directory's i_size */
@@ -2249,16 +2252,22 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
 
 static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 		struct vm_fault *vmf, pgoff_t index,
-		swp_entry_t entry, int order, gfp_t gfp)
+		swp_entry_t entry, int order, gfp_t gfp,
+		unsigned int *fallback, int *fallback_error)
 {
 	pgoff_t ilx;
 	struct folio *folio;
 	struct mempolicy *mpol;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 
-	if ((vmf && unlikely(userfaultfd_armed(vmf->vma))) ||
-	     !zswap_never_enabled())
-		order = 0;
+	if (order) {
+		if (vmf && unlikely(userfaultfd_armed(vmf->vma)))
+			*fallback |= SHMEM_SWAPIN_FALLBACK_USERFAULTFD;
+		if (!zswap_never_enabled())
+			*fallback |= SHMEM_SWAPIN_FALLBACK_ZSWAP;
+		if (*fallback)
+			order = 0;
+	}
 
 again:
 	mpol = shmem_get_pgoff_policy(info, index, order, &ilx);
@@ -2269,6 +2278,8 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 		return folio;
 
 	if (order) {
+		*fallback |= SHMEM_SWAPIN_FALLBACK_SYNC;
+		*fallback_error = PTR_ERR(folio);
 		order = 0;
 		goto again;
 	}
@@ -2471,7 +2482,12 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	softleaf_t index_entry;
 	struct swap_info_struct *si;
 	struct folio *folio = NULL;
-	int error, nr_pages, order;
+	int error, nr_pages, order = -1;
+	int actual_order = -1;
+	unsigned int path = SHMEM_SWAPIN_LOOKUP;
+	unsigned int fallback = SHMEM_SWAPIN_FALLBACK_NONE;
+	int fallback_error = 0;
+	pgoff_t orig_index = index;
 	pgoff_t offset;
 
 	VM_BUG_ON(!*foliop || !xa_is_value(*foliop));
@@ -2479,20 +2495,21 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	swap = index_entry;
 	*foliop = NULL;
 
-	if (softleaf_is_poison_marker(index_entry))
-		return -EIO;
+	if (softleaf_is_poison_marker(index_entry)) {
+		path = SHMEM_SWAPIN_POISON;
+		error = -EIO;
+		goto out;
+	}
 
 	si = get_swap_device(index_entry);
 	order = shmem_confirm_swap(mapping, index, index_entry);
 	if (IS_ERR_OR_NULL(si)) {
-		if (order < 0)
-			return -EEXIST;
-		else
-			return -EINVAL;
+		error = order < 0 ? -EEXIST : -EINVAL;
+		goto out;
 	}
 	if (unlikely(order < 0)) {
-		put_swap_device(si);
-		return -EEXIST;
+		error = -EEXIST;
+		goto put_swap;
 	}
 
 	/* index may point to the middle of a large entry, get the sub entry */
@@ -2506,10 +2523,13 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	if (!folio) {
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
 			/* Direct swapin skipping swap cache & readahead */
+			path = SHMEM_SWAPIN_SYNC;
 			folio = shmem_swap_alloc_folio(inode, vmf, index,
-						       swap, order, gfp);
+						       swap, order, gfp, &fallback,
+						       &fallback_error);
 		} else {
 			/* Cached swapin only supports order 0 folio */
+			path = SHMEM_SWAPIN_READAHEAD;
 			folio = shmem_swapin_cluster(swap, gfp, info, index);
 		}
 		if (IS_ERR_OR_NULL(folio)) {
@@ -2526,6 +2546,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 			count_memcg_event_mm(fault_mm, PGMAJFAULT);
 		}
 	} else {
+		path = SHMEM_SWAPIN_CACHE;
 		swap_update_readahead(folio, NULL, 0);
 	}
 
@@ -2603,10 +2624,9 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	folio_put_swap(folio, NULL);
 	swap_cache_del_folio(folio);
 	folio_mark_dirty(folio);
-	put_swap_device(si);
-
+	actual_order = folio_order(folio);
 	*foliop = folio;
-	return 0;
+	goto put_swap;
 failed:
 	if (shmem_confirm_swap(mapping, index, swap) < 0)
 		error = -EEXIST;
@@ -2616,10 +2636,16 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	if (folio)
 		folio_unlock(folio);
 failed_nolock:
-	if (folio)
+	if (folio) {
+		actual_order = folio_order(folio);
 		folio_put(folio);
+	}
+put_swap:
 	put_swap_device(si);
-
+out:
+	trace_shmem_swapin_folio(inode, orig_index, swp_type(index_entry),
+				 swp_offset(index_entry), order, actual_order,
+				 path, fallback, fallback_error, error);
 	return error;
 }
 
-- 
2.25.1


