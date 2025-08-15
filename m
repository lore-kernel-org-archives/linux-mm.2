Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 756E2CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 18:32:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 845D68E0208; Fri, 15 Aug 2025 14:32:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81CC18E0001; Fri, 15 Aug 2025 14:32:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7592F8E0208; Fri, 15 Aug 2025 14:32:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 613B78E0001
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 14:32:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D538A14024B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 18:32:33 +0000 (UTC)
X-FDA: 83779837386.14.B9C6AE5
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0656EC0007
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 18:32:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OQHyAjmD;
	spf=pass (imf22.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755282752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RGiW9xodm88LtvD4f0t7A8bHKFkprv0GEx+rqU3fk04=;
	b=dL6XjElGa3C4zoGthQhCUaFrDun+mPp3oXikxSLHSDB0UDFc2pGtHGGeMQO8GyuB171nDo
	NErKtR3qcE7NILWkmtOMx2ZvHUO0s9ymfHY7IbjgBVvlDo/W0rzSB4x27z96dwquUzKbxZ
	VZMmtSbh2KVWaZ8p12vtw5DDzGcd014=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OQHyAjmD;
	spf=pass (imf22.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755282752; a=rsa-sha256;
	cv=none;
	b=0ZHe2qAGS2o5BmZMTci5hGhs7PFV2rCnpqpxajJ9CbWedCsnVpEWrvOF6VcSYRJ5JNWlKl
	U86i07JMqn6AZaeCFJWZlv+gSxsQqJgr4oXBTHhRStSJUsvA+7dq2oE7+yH1j2UxG1pJ9k
	0pzpfOqxvEnoly30ynYSwJP/n//28m0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755282749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RGiW9xodm88LtvD4f0t7A8bHKFkprv0GEx+rqU3fk04=;
	b=OQHyAjmDXZ8JJLOEWYTMJ8xPOE1Y8uO/5Y0m65SNAWzDG1SkK076HwYsRANqvY6PgZRgld
	inpGCtor1197U3a+mQepP5nA2LYhuBueL7jrPc7wikf8OsPveL6o3vSPcQMPBNkvpqOUXi
	w2JqpNZO1OKcQGPZ3kpLgpbx6FvrZkM=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH] mm: readahead: improve mmap_miss heuristic for concurrent faults
Date: Fri, 15 Aug 2025 11:32:24 -0700
Message-ID: <20250815183224.62007-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0656EC0007
X-Stat-Signature: k164iasog4ei641z7fzyzi6ix4wx9z9n
X-Rspam-User: 
X-HE-Tag: 1755282751-268189
X-HE-Meta: U2FsdGVkX19WLOIyTrFseiC8vho/kyG0x6byDIVheooIWAYzxC25+cJAC/zHH2MFZLvnsWphz5GV8RXDgfrvTePNHq2TbpwyIIJ+vAHcr72Wa+Fe+d8nYuyy7RtblRhwgA5LaTeWtsdyW5PE4hpQcXk/1vDCjzYdywbidWFr8gU4R2OpVcrMd/QPlxYVKuqN02w2gMsrisfpn86TyhHPFWaWWKcsYDIxeZaIjXH1bV2XzcRKDVN5Gyhdv3j+dZEXpDF28lfjBvz9jCdhpAX5semRgsgq0gFMIdDZneKyulNDJYUTitdMHTcNfEn0uFuGdmX3X4MeuiBcG06cdFxpn8d67IEWzGPNc7/ScXEWjAYE+L1CrnIZVXI47OiAgQrJTS5aUcaHNalzMv8JTAC1rOlzfjUCMCGEeA2TAENXlMjmxO9OyNz8HT3WqBn4mqQ2Q0MtZZtbU/Cex/qeYgnpzTLQhAja5pnm/N9UUp4TiiZg9S4d8HpUud8LkPvrBEWkDKm/HsVEZA0bqwLWjGjQZ0fPy0VAf8Ov5/EGrrzECgZQ/MlpPDofV7BW5iiOTdbnDo269+uwqMlqX194Fh/vvwGuDRPj6I0+wcII5NPSgqp4UrBEjZoUgbmaxd3oSNPGjuRMrvh8N79YLPyLnjA6uozPxNCU0LAQokbxxlSuOySVjVjyFW9BuYWf5gLx/Tv2wrpiu2ZSGIBtEm28HxNz2hQ9QY7/yzGgQeeGa31RXtqhs/0JfgyAwrvuR5DKhANdeCW28xmU/wj+8px/ls8FEmDOSRxVsgvOHOiNKm+1O0GwBkeqeTtSq9DAVQ+3Oy3HyY3zcTxScpCbYEViKlx/ul8pjKkRq3qaxWpNC+1GS36qOFljiGcAbT/Sf3/Me4c4hTE3E7c0VFR7SJrK8WbmC3TTopDACniPHEwkx3uCEJEHqiEuZNNma2YtmrMwsCxG6ovauJV5luLNJn2AfsT
 AI6ZkX2B
 6CGY2LqDZotRkdpqdbUCCgVZxjpDd/lYHFFcja5PUaF/OlaWHn0nQO0nk4Dqcjd7WzgeC3tU9IFfy3GIL62PEIHwjMq6DPHl2p2Ozx7zGMLccvvaR24yT+hjk44LF3m+M9AzojIfTTqzO9DjSt4NHJXeY8dcbUY6an/meL1g15LamjVoD2aM1PAaLpooGr5w9Js6XzQZPkkLxgoz1OSaeLcDbX74t5wyPNTbL3NuC55tIneXKwhPoWaLXqPpjwZbDK+DWzlrBQGvw4AbRy03NtiyYZVCzrfuxgQ/4yfAJ8LvaxA2/jpnFNzQfDYtpDE6C7yY3hMGaEc2ox+eApPJwYaW9bEv+Qs7AKDOsSosE++P/IMw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If two or more threads of an application faulting on the same folio,
the mmap_miss counter can be decreased multiple times. It breaks the
mmap_miss heuristic and keeps the readahead enabled even under extreme
levels of memory pressure.

It happens often if file folios backing a multi-threaded application
are getting evicted and re-faulted.

Fix it by skipping decreasing mmap_miss if the folio is locked.

This change was evaluated on several hundred thousands hosts in Google's
production over a couple of weeks. The number of containers being
stuck in a vicious reclaim cycle for a long time was reduced several
fold (~10-20x), as well as the overall fleet-wide cpu time spent in
direct memory reclaim was meaningfully reduced. No regressions were
observed.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org
---
 mm/filemap.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index c21e98657e0b..983ba1019674 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3324,9 +3324,17 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
 	if (vmf->vma->vm_flags & VM_RAND_READ || !ra->ra_pages)
 		return fpin;
 
-	mmap_miss = READ_ONCE(ra->mmap_miss);
-	if (mmap_miss)
-		WRITE_ONCE(ra->mmap_miss, --mmap_miss);
+	/*
+	 * If the folio is locked, we're likely racing against another fault.
+	 * Don't touch the mmap_miss counter to avoid decreasing it multiple
+	 * times for a single folio and break the balance with mmap_miss
+	 * increase in do_sync_mmap_readahead().
+	 */
+	if (likely(!folio_test_locked(folio))) {
+		mmap_miss = READ_ONCE(ra->mmap_miss);
+		if (mmap_miss)
+			WRITE_ONCE(ra->mmap_miss, --mmap_miss);
+	}
 
 	if (folio_test_readahead(folio)) {
 		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
-- 
2.50.1


