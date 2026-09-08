Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA89BC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:51:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2CB26B00A3; Tue,  8 Sep 2026 08:51:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDD596B00A4; Tue,  8 Sep 2026 08:51:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA55B6B00A5; Tue,  8 Sep 2026 08:51:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9EF6D6B00A3
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:51:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3B335A4A8B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:30 +0000 (UTC)
X-FDA: 85190581140.21.218FB2D
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4B412180006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="I OaL/uK";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=gxk39QLf;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788871888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2jieyZvu2GUVPRHlo+y50ErCBwJJarJUK+qdeuIZ+mM=;
	b=WAjvIDByClMv3ZXgJabaJsdOaOPAFws0QBLpqdPkw4H34hKtaFaXHi518b5QHaPaVoT14K
	FWTcKvjmK6JUD3U6lxtwa6f/aIgGsX3mVpMUWWyaLmcDETVY2383VcCJgF2VCq1X4dzwHM
	v0CCyidsppCRGCNDiKWvuQeq8y92ex8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788871888;
	b=y1RBI55ndY1pA8l/LrlGCO8o9QbQZzApKFh6mVDyPtReNoBP8TY1cjTgDHtGHIouHLoidm
	QKwd6kKJJXJ3cCJpcHMwqZj2Bi3pj69prKAgQO3TrvRIVRsoN1HkRKGumRNUiSriWzll+M
	+UFnv+47sl1XFL/BetgP/lprwJ169/U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="I OaL/uK";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=gxk39QLf;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id BF9C7EC001E;
	Tue,  8 Sep 2026 08:51:27 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Tue, 08 Sep 2026 08:51:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788871887; x=
	1788958287; bh=2jieyZvu2GUVPRHlo+y50ErCBwJJarJUK+qdeuIZ+mM=; b=I
	OaL/uKQHhb38ND4Bj0fSTpuOj4n2Q8B0stPgpRfDxQwrQZNw+Hlld+YSg/XUgG92
	n4ogJ44fYmmh9c2sjiCQI1a2ohAIKcFEP5IOVYdU3tGSaXGFu3gpVCnTt5BDScL3
	wW6gqasW3eNXu4N1MqQ5f9X2bMaSrHq++zm3ymOnt7AqBGWrPIN93iUG5QQqi6x5
	vyALjW8hKPoAkXTcG+c5MEOPP3p0QLx2wcnwpcITrsqF6PT2qMhSGJOqZwhLioyr
	gYnoAGoVdg/JuDJMKfJHVw2tYZnsTWWiE2OT/U/UoFqwPuQEfFgJ2vbOC1eF32pr
	PcJ7MOZIUyRuLN+G/FL3Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788871887; x=1788958287; bh=2
	jieyZvu2GUVPRHlo+y50ErCBwJJarJUK+qdeuIZ+mM=; b=gxk39QLf6j5cT4DK+
	BmFhseXOltswCp5Bq3WFvGkN6fJsCsjKwPG3335aIpIOSnmgR82ee5NA1Sg2VQuT
	O+5vEt85pNDlyOQCv+OQKG2Fnu66rUQXpIqWKQic04jWYrigcObQ4HC4bPfX0d4l
	kpcqlmc0W7PUjnqC2/wK8f6bvbNXuijuyjLyISGIvlexeYx8CiakmOznszGyrsrk
	EaLmcJr4hQPVkbuyZ0tLvRSmYfrx4Nlr75ppr6YYQ4XFR5449fruWT+CXrqNdvvK
	rvbk5uWtAHTTnGe/pKo9ZybpxO9RDAK6/EFw8CuLv209bn3+Y2GgkGfa6MjK7hMn
	/8Pwg==
X-ME-Sender: <xms:zwSgag-cLD9z7rFO2Dn2GKMYfdp7dTL8hQmH4ORjTfku8O5Ag1imfg>
    <xme:zwSgahGFTETEkN5z8u0E7gXieh5igIAZ-HaT49HlvvQ5Pvuqr4hmsze1r65QYAfoU
    eRblO_-oCFjL7GZFO1zsD_lDsbwXl2iDBk6c3_hQ3vGedfo2W8dGQqG>
X-ME-Received: <xmr:zwSgaoNGkmgo-rYpg4P4BI7O254ElfbxMErtbPS0tNT6JaCzMNYwwxI9tR4>
X-ME-Proxy-Cause: dmFkZTEqhwhdybusskt0pvIfnDHaUnU8VDm23OZYXtTM+3VchiC9Aeb+sVxnsk6fYrSw+D
    ThqYkrS5/6/vxmtuBdFXmhYIhVzzMwKM2h/EuTd0ioKo/SR7JG6qiZdpwqyCgxSw3ap0C4
    BwVCwTZ6/NsCbeDdXy9FE5B58Xto5VjC3MUnB3djmw4ijxWpRXgLZG/TTGkjuz6Wl73hCN
    DLujar0Luemoo2GGzStZ/AivOKYRI2J4riPLZz79qeImA1Ygm/BltYdUhOJX4iOWEiQXMZ
    R5ImdiLN0us354rUC8gTNq0PrK6J11WLhxFnA56Lf/FdfG/G6OPaoDYxKnsgAlbq4sHOkT
    N0G0pi/5suIGZSmi0FemecDHkHN1Yj2podLNX+pqToFRRobanD5oKoy67YFsivieppLWWF
    ydp4XTVRVHbEp7D/Xv9RRxV+x79LmFPU5Q3P3B7hgDmvajcEEeddTBSgE7Fi3VkUINTW1r
    A0qn+d9UTBu7YWa8yRMmKi7b8Pbq6Ak4Y/dfFexRJ8qQ8M50dH3xwEiZ+C5RAHyhyKMelw
    NQosLsX7YYiIKZ5PdbdoL5CUOqO+7pvJLcXXqJRoxKFe2KY4jTK5SERkURY2zOVTzwyLQP
    LlxJKf0BKRJMrLuRmz9toZNlP7vo/mZ7vAlZZCBFcl6kt89kbJHze+qdidAA
X-ME-Proxy: <xmx:zwSgaoTpw32PVbQUIXsNmYkKgaYchWvgJ8blMo064a8E8g-YvXGG8Q>
    <xmx:zwSganRuuJefLqgFyALJH1RvsWTL-L1tHSwN270BPXuAFzSg6FjYCg>
    <xmx:zwSgaqaewvu5IaKA1XDSokjgeeRMPFNdcZ3Ku3tfmonm5WXaU9kW3w>
    <xmx:zwSgarhaYOUqMRJ77skyxfl3Vij-c1WZJZaENheya_cJhfVM9g_ccw>
    <xmx:zwSgaiukljpbt4CykJk34iKjdT0t-vVLT9aEWv-lO82cqhyfoXuLT1_Y>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 08:51:26 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	rppt@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	usama.anjum@arm.com,
	usama.arif@linux.dev,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ziy@nvidia.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	agordeev@linux.ibm.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v5 08/19] selftests/mm: add folio-order check for address ranges
Date: Tue,  8 Sep 2026 13:50:54 +0100
Message-ID: <20260908125105.1510704-9-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908125105.1510704-1-kirill@shutemov.name>
References: <20260908125105.1510704-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4B412180006
X-Stat-Signature: f7x3ey991ay9dhjpdgnss1wmjzm3zjra
X-Rspam-User: 
X-HE-Tag: 1788871888-79341
X-HE-Meta: U2FsdGVkX193E/HIlpFgPlnzqnJpKT/NpQgiUng04GZlMNO+4cnyBN8WtBGSzJRQY9NzqwsYQZd7OeejAfWpVJHuHwa2IO9UVTnO0IKuyliOTszE702nNcDl7zblJ2dQ/5YKKPkLjwp+/l1yL9hWRriEBrB75Cs1MCK6sdxHYLAfQ7ukFhi4aRf3u8r5wiIiWAsdGhD1s/EefG0B7rN4GfRq+YyKm19J+QfQinl/dXPKp/tqpykfIBnb84YAeZoPyZ2A1mXRvzYKlXinSsklofcY2fV9G1j1YBBsjpgXoZ6xRWCQqluJP7Lz5IzObNlqpCSgwNI8N/nhvk7NIsiE39PqlldbZgALCGsr8v1oWJAdYbPVDOntJ5EK6EQQPdZtviRyG0ypAK59pEz5k8AzSHggTrCyx/uL4nZ9OU0GHLhxFETy6L4MXctsPTbf7sQQf1EoWDAnggMkvIb+AeFBKQ98h1lEoFOI4GphAP5PBvlMVWpSpNpwyL7D/xfnWcUo9JzLGhbJIdkdLXBADurMU062C70fe1N6snLTZPnli4+cDVPM5cS7oT1/loqyxAzQvrr3sRLRcuXvWIQZha6Rvg23pzSYepBdWhH48fE58y6nB7pi0gBb5HoqO6BHQfMh99YPAQHi7NhyKjJjn0KJShaCia9mrF1I47Fa+mq2x9zuaA3gRTMIR3Dw/1Yvpab0gpKz6oDbjklTeouBs3RghUmf8Z9dWhxGoc4p9FfBaLu+w8JnOr6auwBFoqyA3ldoetWw80KQtFWpcxL5GSpbkRSJW5yh4H66QJaXl2qcwKWl20eUgFH78yv8UaBl/sTpiuc5ourdVa0QvzG9Ll8SWv95o7/yjuQbjb61rXQySYSR+cQpR9QuxTyknwC8X7X7bkzOMtVSicoYNO2lP5e937QXg4WXK5V5a1ZZetzYr4DLCp1BTPFXcFr9CfR3IyK7OCNZe+qgoAlg2g8OCgH
 9A9ABhsk
 DPiZ1y5HKyY5hdJozYiR2+3UXfOqo2n/JOU+kTqC4OQ1wG2LaLe4Lc2puge2KjUR07m7wcDT/+Huw0FbQAVzjA449MldLBOa4t1dfDiVffpo5mBeJ5N6mizPhenDoQyGoyLdhEEBg3g8KHGbHi6K425tM7VEHm6g8LNaq3zLKRZc733S+xYJtTJ8NJ6qNspxvAR18tDKNBxlOz+WyF7moEcVwKpaAJzILj5+C79ASJW4FFh8Wn3N+MqbSAo+jJqI+O1ivtgkn/zZjwp/aOfIu/86wJL23JA6pMYqeFnMjsAztgyoL/28vRApEfm/6qIp8CVxnmWBYRiVipdwksD2GHTCVurdLN1fmP7EsQG30JoJ0kxg4Ez7F/HRVmCG1oNQP1meu7F6XNLMQOzS7aYc7ckh6t5p/r3By6YV8/DxySjmaAK9GGCs06UgvTMiqRwL+Rs6mTMDngIaptAJbGr7GceN2w3inBewaOPu7ArNedhhhT5+3WTC4dAZG++bToW7YNn7+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

An mTHP collapse test needs to know that a range is backed by folios of the
target order, and that they sit where a collapse would put them.  Nothing
answers that today: is_backed_by_folio() classifies the folio behind a
single page, and check_huge_anon() reads smaps AnonHugePages, which only
accounts PMD mappings.

Add is_range_backed_by_order().  It requires every folio-sized, folio-
aligned part of the range to map one folio of that order, head to tail,
with the head at the start of the part.

A part backed by two smaller folios fails, and so does a folio mapped off
its natural alignment.  The mTHP cases need both to tell a collapsed range
from the one beside it.

Assisted-by: LLM
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/vm_util.c | 47 ++++++++++++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h |  2 ++
 2 files changed, 49 insertions(+)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 3ea42a7a2a3e..4947612e8b3d 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -552,6 +552,53 @@ bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
 	return false;
 }
 
+/**
+ * is_range_backed_by_order() - check that a range is backed by @order folios
+ * @start: start of the range, a multiple of the folio size
+ * @len: length of the range in bytes, a multiple of the folio size
+ * @order: the folio order to check for
+ * @pagemap_fd: open /proc/<pid>/pagemap of the range's owner
+ * @kpageflags_fd: open /proc/kpageflags
+ *
+ * Every folio-sized, folio-aligned part of the range must map one folio of
+ * @order, head to tail, with the head at the start of the part.  A part
+ * backed by several smaller folios fails, and so does a folio mapped off
+ * its natural alignment.
+ *
+ * Returns: true if the whole range is backed that way, false otherwise.
+ */
+bool is_range_backed_by_order(char *start, size_t len, int order,
+			      int pagemap_fd, int kpageflags_fd)
+{
+	const unsigned long nr_pages = 1UL << order;
+	const size_t folio_size = nr_pages * psize();
+	char *vaddr;
+
+	if ((uintptr_t)start % folio_size || len % folio_size)
+		return false;
+
+	for (vaddr = start; vaddr < start + len; vaddr += folio_size) {
+		const unsigned long pfn = pagemap_get_pfn(pagemap_fd, vaddr);
+		unsigned long i;
+
+		/* Not present, or a tail page */
+		if (pfn == -1UL || pfn % nr_pages)
+			return false;
+
+		for (i = 1; i < nr_pages; i++) {
+			char *page = vaddr + i * psize();
+
+			if (pagemap_get_pfn(pagemap_fd, page) != pfn + i)
+				return false;
+		}
+
+		if (!is_backed_by_folio(vaddr, order, pagemap_fd, kpageflags_fd))
+			return false;
+	}
+
+	return true;
+}
+
 /* If `ioctls' non-NULL, the allowed ioctls will be returned into the var */
 int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
 			      bool miss, bool wp, bool minor, uint64_t *ioctls)
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 56a28ce7d029..e509fc4012a5 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -99,6 +99,8 @@ int gather_folio_orders(char *vaddr_start, size_t len,
 		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders);
 bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
 			int kpageflags_fd);
+bool is_range_backed_by_order(char *start, size_t len, int order,
+			      int pagemap_fd, int kpageflags_fd);
 
 int uffd_register(int uffd, void *addr, uint64_t len,
 		  bool miss, bool wp, bool minor);
-- 
2.54.0


