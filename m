Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 445CDCD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 18:36:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A9CF6B00B4; Fri,  5 Jun 2026 14:35:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90A5B6B00B6; Fri,  5 Jun 2026 14:35:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 785B16B00B7; Fri,  5 Jun 2026 14:35:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 61D706B00B4
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:35:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2E4451A0239
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:59 +0000 (UTC)
X-FDA: 84846713238.07.4D4233D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 89FDFC0006
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bUfHWrW5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780684557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Hq29nobeHte/zgkXSzWoaRdOwXra0la1omlEHsUXW0=;
	b=LbxorcrLPM+EnkdYukbmjHDPJhJay9WxSU+JyLVzBwNZzMi0Xt6Zmx9PGdReEAeiWz6HIU
	9eUsEVrTS1FweGLtvgFLTbwygRlJSnrSGMM60EECKI2bAhR+WzfwCKQkBaV77xUthJtcGK
	GOD8jHb8+DdmyD1DBpFnE7dYtMoeW7U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bUfHWrW5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780684557;
	b=PYlcVCemy2ZFvAvgTP0f/hEEAJKzi1t2zmR7BTg+uZhCBwGZ0UKUsltOwOauWtbugvJ85G
	smawOZU5PHt67IUUFaQYf5otvwjLSOOjnxOvsKrZA6kwxaA9GPYtF0QOMCuynj2ZVETGdr
	3eGnpr/hpiubRvK3+wyKICp6BE+QVqw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DBABA4338F;
	Fri,  5 Jun 2026 18:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A913E1F0089C;
	Fri,  5 Jun 2026 18:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780684556;
	bh=1Hq29nobeHte/zgkXSzWoaRdOwXra0la1omlEHsUXW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bUfHWrW5rXMnv2UvKJJvwS1trNmxa2rXAjoYxroYpe1q5lIcs760w3ankAJ6BB1Py
	 g73wErrnH91np/zObpNmIFsHWrAUvhr3VJlJAcj4xTTHk/cvcRExmAy12bklfYEH+w
	 kAaKAZcTcXTI0uCCo5vFlyOqxzHlqa46oLSVDq6qe5fpJTloUX20PBsylCddF9x0z1
	 wSJgYCMJGOGDk0bXCPolKk9SFYRhFNmMU1wQ2M0lk0ybHyOBjtAtQX1FwVJvlUEqUg
	 bVjPGABJTG6H4zot5hDdg1Ua9KeRvqsn0epir31a1xmaTVbNjXDhZhjEnok0JZYRXG
	 YmdbPzofSIHPA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 18/18] kho: exclude hugetlb memory from scratch size calculation
Date: Fri,  5 Jun 2026 20:34:51 +0200
Message-ID: <20260605183501.3884950-19-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
In-Reply-To: <20260605183501.3884950-1-pratyush@kernel.org>
References: <20260605183501.3884950-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 89FDFC0006
X-Stat-Signature: i3zcakumepjq595j9rgrbze7euntubd7
X-Rspam-User: 
X-HE-Tag: 1780684557-758153
X-HE-Meta: U2FsdGVkX1/ZtUBIqJZb5o4YVSZkVIjTaqTlQw48m/WQAkwk/66dC/Jr/tio6f1cxCrNXqk+0PPvc/TENzDym6vt/fqO9ATwQmFHlm6KnlBtQQ/1Z21zgV7N8X4gNJi7JispPS5IckpdaRVEL/NGHVkT6+erlwShi6bMfwyOIUzyxo/YeOCvk1Dudu57Ro7suBGUN7nocFvfNrKsR1DxgTVMMJknRNV490MPq/xVeOvUgInc8Q+A8rsDBp4DUQBcTBMyHtFdpxqThGZC/8OeTxXyMfQ5KVPJRnJnjLVf54zPVoOjxWkmpF1aZT4NxFz7OD3mpox4Z/+aTsK2Nu4NIHNIJBjrlAGD0OL4eRqFJMp/16bUnXZd8lF1LZuiYZZG4CV7J/PkZHNohfSjkl76yvt8cFSml1MhC5a3vHlBnER7diVlGOL4gh6ZQf9NY+1Fb+oBqulihnQO7Z2BOCtxNnNFeHeJIYztTxKh+avy/vA9gh2/MTBKNbttpPWMftt4gsCCgKfoe+PV+jYxY1SKF+BoCapkU729qGTYrftm7NTB7jyZNrqkQJ1bxym+YLplY1y73LXjn+TP63xeh5IHUAK1DbbIAaT8C1jcKEoA5pT6IMId2DeRBLS9Gc0gPj1GFIwJ2v2DPvlfgEPMFrjFSyS4xw4LORAuDRDRcYfl++PkQBCF5vk2WXVpv4FO1wrXJrZ5igizkFLn1UbgAd1guiE8L4T5HcySYcTb08hrfuS5EWU+d4HG/gSb/CJLIEPF0xZlGuW5kAHJLoHvF0gKcriSc1wQFt4ZHXDISyV/TK9xXB5JCkOxzXJL0Ady1z7Mv2x7Ot77t+Kuqc6kFANdPuZvJbB+huqRd1QtLk3CbIjLfIpsfhl+w3MVJiOOzhqVw+MyvSkunrQ/jwjPDQX5NrEjKBOM289L2PcxhSe1Gy9wMkWMdGRRvDze1Aq5OUyOcMVlG7Ki6mq8bvwtoLR
 HNEY+0Ty
 aImNLpAUJRBuTvgo/LCSYc9rFRG3PHDzIY1i2EtB/CK737He/wajhTE4Uqci8ZxphCLg/G8XrzcdOoy6TGn+wolkdDTfTNRsl5H0ZTiXdU7d7gQmvoF+wcQQJ2A4/YE8yo+uCkXwpI7a2hLfl+OcSXBsAtNrAGG9I+LQAKhY2e/oMpGFwREOTXmatCVC5zv7tVIK6o5SLlv/B3AaFsGxXQ9Gu6QHb4k3YT5sfRcXqoQNIC9w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

HugeTLB pages can be preserved memory. So they are never allocated from
scratch. Instead, they are allocated from the memory blocks with no
preserved memory. These areas are detected at runtime on each boot.

But since they are allocated via memblock, they show up as RSRV_KERN,
and blow up the scratch size when scratch scale is in use.

All hugetlb pages are marked RSRV_HUGETLB. Subtract their size from
RSRV_KERN when calculating scratch sizes.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index b3c33f150e85..0d106c9197d9 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -744,7 +744,8 @@ static void __init scratch_size_update(void)
 {
 	/*
 	 * If fixed sizes are not provided via command line, calculate them
-	 * now.
+	 * now. Use RSRV_KERN to count allocated memory, but remove HugeTLB
+	 * allocations from it because they never get allocated from scratch.
 	 */
 	if (scratch_scale) {
 		phys_addr_t size;
@@ -752,12 +753,19 @@ static void __init scratch_size_update(void)
 		size = memblock_reserved_size_flags(ARCH_LOW_ADDRESS_LIMIT,
 						    NUMA_NO_NODE,
 						    MEMBLOCK_RSRV_KERN);
+		size -= memblock_reserved_size_flags(ARCH_LOW_ADDRESS_LIMIT,
+						     NUMA_NO_NODE,
+						     MEMBLOCK_RSRV_HUGETLB);
+
 		size = size * scratch_scale / 100;
 		scratch_size_lowmem = size;
 
 		size = memblock_reserved_size_flags(MEMBLOCK_ALLOC_ANYWHERE,
 						    NUMA_NO_NODE,
 						    MEMBLOCK_RSRV_KERN);
+		size -= memblock_reserved_size_flags(MEMBLOCK_ALLOC_ANYWHERE,
+						     NUMA_NO_NODE,
+						     MEMBLOCK_RSRV_HUGETLB);
 		size = size * scratch_scale / 100 - scratch_size_lowmem;
 		scratch_size_global = size;
 	}
@@ -777,6 +785,9 @@ static phys_addr_t __init scratch_size_node(int nid)
 	if (scratch_scale) {
 		size = memblock_reserved_size_flags(MEMBLOCK_ALLOC_ANYWHERE,
 						    nid, MEMBLOCK_RSRV_KERN);
+		/* Do not count HugeTLB pages. */
+		size -= memblock_reserved_size_flags(MEMBLOCK_ALLOC_ANYWHERE,
+						     nid, MEMBLOCK_RSRV_HUGETLB);
 		size = size * scratch_scale / 100;
 	} else {
 		size = scratch_size_pernode;
-- 
2.54.0.1032.g2f8565e1d1-goog


