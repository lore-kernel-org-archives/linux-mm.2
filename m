Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA3F5CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 15:53:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66E3C6B008A; Tue, 19 May 2026 11:53:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6448A6B008C; Tue, 19 May 2026 11:53:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 581D26B0092; Tue, 19 May 2026 11:53:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 486966B008A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:53:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F04F7A061A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:53:36 +0000 (UTC)
X-FDA: 84784614432.03.B6594EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 882C440012
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:53:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aEaiq6JV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779206015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=o+LkVX5yvItsLOG85pbAr4wLlDhVGqjrSr28bMTZLNI=;
	b=Pkl472fxo9wx3droZCs+T3cAY4p6676mG0uCAQN5YC8hug8fltv7dYsy0l5yPHLM415xqT
	cwHRfa10SGNTr46V45pcd7bBsOCqCnwRjeWSJuQIdImK3Jv+CaQVWe4UZom5I0xmMVU9X0
	tL6uyMpxPt7G9YjStBCcuAWv8Pwm9Xk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779206015; a=rsa-sha256;
	cv=none;
	b=ozwXEONJgr5l0OT1fuUF3+pFvy1M1cpl5ICZQc7MgWRFw9XJGRnzNel/t5uwQxKdyJMxqn
	GPeMu0ePhWNSZXL/J/lk/dMgHERixCW/Hp3GGyAd20OgT88QE0CVVbuoxzQZyy9i/Nb//l
	CrJ7/PwAh6DmONvbI42B0sPNLQ4FToA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aEaiq6JV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 01DE46012B;
	Tue, 19 May 2026 15:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FEAEC2BCB3;
	Tue, 19 May 2026 15:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779206014;
	bh=XUKkEq/zBwZCDneFV3d4XY7FRw4qnYbdahDIQGyl9WY=;
	h=From:To:Cc:Subject:Date:From;
	b=aEaiq6JVQa2BIXrRE/R4JjRcdFUTvMo3hoMC1wkCTJ41hnIhmZ0x44zeeaSpsFgbM
	 +sIKrzMbZeZjRP43gButUTH9u0GCcbN7EMJ4GQxYC/iFsodqryxAh6MOWvvNwW4i3Z
	 j9+pOCDGYEvjBGhKwJTe3ut9pbefd4k80TcxjwMG6+XrxfwG0h9cjKmsUsa0yzLQmw
	 hgDGVFaFmM+nORb1gJmby5qI8NnkqDQ5GefonURZKmfkjPmdBa2H5wLkctmrQlU7Wp
	 AfI8o3HCrLLmIWoMaZpyEJx1pU0DKcDnpwdNEsCk4Ph7SLJtzXDuVJ5aWzPUsvWrvr
	 IRQ8+vtYoMiBw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] kho: always print scratch sizes
Date: Tue, 19 May 2026 17:53:21 +0200
Message-ID: <20260519155324.2692594-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 882C440012
X-Stat-Signature: cwzjrksstjedeqn4gazzd47gaymnwsqn
X-Rspam-User: 
X-HE-Tag: 1779206015-415514
X-HE-Meta: U2FsdGVkX1+c8urEgQHxyrYY6t2ualVdHL2QOXUHtqRkzN7xCilqNEz0bH/VfiW0lDWWSYa1LnS72VrPYDAkS7w/AmG5kizUFRo3CBBYcRl4Y0P/4vXnlv5ox8YvzjtezgfvDSickXCGxVdXuq6ZER3Upk2b2bMwJONzsUdYU/WTrcK2DQn4ZX8oxwwZUj8stYVc0aSJf8GX8fhh2Zvu46zMWLd7pNXWdD0BtMZpe6apONYT972u8RZmcXfFN1RQQPGTXGJk2pzZhKWfoLDE4O8gE0lSspQbchgCsAcdr9nHWg/pGBcnGAC9k1C8KPh3Mq5xY3c7m9zW+OIw7AG8dOo8Ub5bXZ5cNKRLgfY2hV3KzrOGivFDvGTKxw7Q+UZnw6oo+lqhtcdQ2esSF2ccd+9qDB4L7mElJmkvFKCCNj53KWg5kSxYffyGu38ny7UXtNN7fGv6swLl8zzP8QIx+yTte+x7aT/XCU4/ejaoNwN95Vw0DdEuP6JDg056d3C4FgGpEt0RTj6gWvxZE1CcWC0t8Hth20sJHzS9N2Ru7iPrPJZomXjxj6tnte8xtZ9NmZ3aPkgV52f2dbcKqSio+MVJKWXv8qDTINcJmvuyOOGGEoz8WCSwfdG2DcMsqz/M0gC7DSyGr8ywRNV+1mx3cjR/6qM6yGW8M3q9tHpKx4XDEB9uZhrc+qCSpCU+liaoTQ/Xas6PGmTvj6nBvZvCXKOT49v7tkzyi66MFMXpqDxJv+s0W1pF8UiPkTWLxtL1ZUoYaudgfxfrzP6QSD4PuL9MPNTSVCf5aMU6tPphuXNvd6NyNTw/qnQnFrJhCl8jnxysaqhJ0REe5rPLcy4qJp0KPKqxQ8tZ2PhgIBEXtZrzeNZG/FOroACMXizc2hvFVE1Okz5eLNcbE4la/QdyjF0mIU1dOQfpioOvKe+SSbuZyhNGTir7PKJvrfWoNMGoUxLvPLlpec7RDRM1u80
 TthfSxB6
 +2LejoirASo0UIKteavVi/6fZTKay+PNs4girGrwdvdtAuxdL+WZaMIX+ivOGVT0nWYxGoMQ2AhHHWv3tsOJWGKE4EE/eqRykqfDkTj7rqVKecLUysGdYi++Fu8q5/HMkD5g16XoQtOczIGQgaZ1ZLx9BJDQI5bB+yHnlKCEKjL5VUF7VTmBYCMZHvTFBKCVLk+ry
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Currently, KHO only prints scratch sizes when the size is specified
by the command line. It prints nothing when the size is calculated
at runtime by counting RSRV_KERN.

These prints are completely useless. When the user specified the size on
the command line, they already know how large the scratch areas are. And
that information is readily available by looking at the command line. It
is a lot more useful to know the sizes that are calculated at runtime
since they can vary by kernel version. Plus, if KHO fails to allocate
the scratch areas, the calculated scratch sizes are not available via
debugfs.

Print the scratch sizes in kho_reserve_scratch(). Do it before making
the allocations. The size can provide hints for the failure reason.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 33fcf848ef95..b030f53f2235 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -621,11 +621,6 @@ static int __init kho_parse_scratch_size(char *p)
 	scratch_size_pernode = sizes[2];
 	scratch_scale = 0;
 
-	pr_notice("scratch areas: lowmem: %lluMiB global: %lluMiB pernode: %lldMiB\n",
-		  (u64)(scratch_size_lowmem >> 20),
-		  (u64)(scratch_size_global >> 20),
-		  (u64)(scratch_size_pernode >> 20));
-
 	return 0;
 }
 early_param("kho_scratch", kho_parse_scratch_size);
@@ -691,6 +686,10 @@ static void __init kho_reserve_scratch(void)
 		goto err_disable_kho;
 	}
 
+	pr_notice("scratch areas: lowmem: %lluMiB global: %lluMiB\n",
+		  (u64)(scratch_size_lowmem >> 20),
+		  (u64)(scratch_size_global >> 20));
+
 	/*
 	 * reserve scratch area in low memory for lowmem allocations in the
 	 * next kernel
@@ -725,6 +724,9 @@ static void __init kho_reserve_scratch(void)
 	 */
 	for_each_node_state(nid, N_MEMORY) {
 		size = scratch_size_node(nid);
+
+		pr_notice("scratch_areas: nid %d: %lluMiB\n", nid, size >> 20);
+
 		addr = memblock_alloc_range_nid(size, CMA_MIN_ALIGNMENT_BYTES,
 						0, MEMBLOCK_ALLOC_ACCESSIBLE,
 						nid, true);

base-commit: 34e8f02817e31826e76bb2ded48bf28fe921f20b
-- 
2.54.0.563.g4f69b47b94-goog


