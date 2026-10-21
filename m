Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9C7F606A321
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 23:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M5sHW2cn
Received: by kanga.kvack.org (Postfix)
	id EC4016B026E; Wed, 21 Oct 2026 19:35:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E74986B0271; Wed, 21 Oct 2026 19:35:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D68186B026E; Wed, 21 Oct 2026 19:35:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B2B206B026E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:35:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D28912070A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:35:00 +0000 (UTC)
X-FDA: 85348241160.04.306D820
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 838021C0004
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:34:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M5sHW2cn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of kaloz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kaloz@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792625698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b+mC8VYd4OIdAs5s1Sr2HQYuGE+BUuD12RZl8Figbho=;
	b=sUHIvWVSsOREV5b0/l4Et+opl/9tCqpLcWARKxzXcTUdKhmtpb0poD3Jwjl0iGrIKko1+m
	VgeLLLVD0GV0apdEskndnWyX2Sg0jFdFLunVYVwGGIctX70KuxsAvITNzj+SruWt/qBujy
	uXurLefEDkadoNA26qaAruxrps1C//c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M5sHW2cn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of kaloz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kaloz@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792625698;
	b=4SpLhADqxE1Qarg+Tazj2tqD2nFpsOOFjhqVy3GSGwuCWa07VwgF1fJZ1jtoV7mx07MdnB
	/Cfbx31rdDAm0I0jnccsP7fPB4LtgSMJ5BSsblAbXbE5xMk3hU/FRwnxXB1kqWTSQ1Gx8c
	4sIEUOd0kwlBjITSdnrCj05L6HnxcCk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C0D5B60052;
	Wed, 21 Oct 2026 23:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772431F000C2;
	Wed, 21 Oct 2026 23:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792625697;
	bh=b+mC8VYd4OIdAs5s1Sr2HQYuGE+BUuD12RZl8Figbho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M5sHW2cnzWwkaf3Qjkf0OZTU7gUHdmKDYHdaTqfMhbjdkZjbnRg84RuEDsypeG6lp
	 bOp3H6s/TgsDqqE+JOQA59IpEbc+6OWNPbTQj6AMOLah9E9ht6OLOXdDCHBctcYMH3
	 hTtZmgQSBd3PJgLG5CoLHsRTA9AwVHa01J2AilkqIMHJui8LrU8MPgvTFVvxmJihoA
	 lAFSKomWZsB5yTPqBmcWm0vf6bczeXn5eOyk9SZV1Mnn8jqluU+Mn33sGq90m6NFic
	 CbALjsYjmcaM5tQBzI0Na6qKNsVvwT1QZOgS5g1qOhjQOfjFRqBNyhQ2ro7V8/agdk
	 xDuHDfWUC221A==
From: Imre Kaloz <kaloz@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 1/4] sparc64: skip the trap block in xcall_deliver() when there is no target
Date: Thu, 22 Oct 2026 01:33:37 +0200
Message-ID: <3bf5d270153bf6b8efb1673a9500df826ec28678.1792609488.git.kaloz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1792609488.git.kaloz@kernel.org>
References: <cover.1792609488.git.kaloz@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 838021C0004
X-Stat-Signature: ya539mz1pwzcmj76n5swmpsbtaw5yf3u
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792625698-61313
X-HE-Meta: U2FsdGVkX1/23RIkxg4yKTabdm4qt/7cfqz5LjQOpNPBwgxHcKq+hwHzE4rg3KGE7DypT7aAkg5ddltUIWYnU+euLm5Mhlh4mjh2IFe6i8zf+MfMkLU5oePMQL7KHzAOiARaYx1xmEw5d1hswDTaOLqeoF6nvd5fCwO/Xmn0R1cVs2ZQ17g9qpFc1lHwjO2gx+2RGS0xf6W+Pq92zbdljiKB/IMIGE9Ws1+x2vN4Z0VEyslQCH7/QtmiIQZjjKVdU0DpUP3Jrx80TwxLo5/OsQfFH5ksG1L/k0pfOLZKk/TVjYHuE6DoGHq+wnhxWD8yag5ZgcpDYDRmrKkyyaL0+EJZDtQqsECOGvU9nJP+mrePoRvzRIzIAum0h/Nwz8axr0mtHwCnQCAkrfB+BXj9pwdq9z8iCLUH9Ex1Png2t3BNoLI0dWB1TU5GuMC/SmNnGTLiUz5fLk73+2f/jLm9vQzeq/WNhJQI+5M40q9V9iDI3vBwRqiz2ZiuXiEPFJZkh13hO8XC0ysR0BHKGdUz6PEiO3sSCWFoJRGBJBdcI8AS8fBfw5QT3NZNfed8JaSeipSwnJSar0PXGEjMPD6xE5HKq8JyYJfFLsJFLZJROAIzCwHLuAy5L53e0Zi5TWq2KsB9KMgMAPIlou1rCCWrPPQbToC7qwnBh6EpkoNWJKIYITb+NjrbcfbhycIPiiJGUcd5SAl7k/oSrbK3pH/aHDSR0Nds/zxj2Mihbx3fKsrNwy4g5q5/K7oAud9nbFrxTE6lHqzxF1Rr+fnqRhTkHPdQf3uJuVhj5jvETZhLZ1fjzPYJWgR5fWVChv4nPzORp/pqNtMDMGsW3ff8DHww7kqzNSIC6MU04vzhJrGNsrOoO81SIS7CEZdBvg8ivooE7WBjnzr6WD2krBteADVzGpG4DilL/NsoesCqGsUVYB9NE5fXYDAanwybdUu+eFEfmglpEYPNe68pkiR2lJQ
 BFMUVp/B
 xWdzViA9L3kJD38o5iOr3+OvKN5OTPxzTg4FYD09DngsFbhnuVho5E6o2+HpLKpcZ1wV+leeKcUiFGRPlWXd+usYcvLYLvRTeRM8OHlpnme7uAoYrIGYYs3uKYxQ2cu6x4BCXhA3n5DwiU1vkkNVG9xJKjC486jjVMPTJL8t/Rm/DA1NhFYvxjLtw7nBhGHb09ghKgv1bpAnIDgJBx4fJYRhFcBF0nLnq/FseMJpKVKlyFmn/eCjEvgsIczi/fH2MXF/eTSnnJsAp0C/SAXGHuQVGZElvBdnosoZG2RLkIB02P/SyGcbJMbxxHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

xcall_deliver() writes the mondo data and the target CPU list through
the trap block's physical addresses before it knows whether any CPU is
targeted. These addresses stay zero until init_IRQ() sets them up, so a
cross call made earlier, while only the boot CPU is online, would write
starting at physical address 0.

Return before touching the trap block when no other online CPU is in
the mask.

Signed-off-by: Imre Kaloz <kaloz@kernel.org>
---
 arch/sparc/kernel/smp_64.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 371460e34484..4240c129c5fe 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -801,6 +801,15 @@ static void xcall_deliver(u64 data0, u64 data1, u64 data2, const cpumask_t *mask
 	local_irq_save(flags);
 
 	this_cpu = smp_processor_id();
+
+	/* The mondo block and cpu list are not set up until init_IRQ(),
+	 * so do not touch them unless there is a cpu to send to.
+	 */
+	if (cpumask_any_and_but(mask, cpu_online_mask, this_cpu) >= nr_cpu_ids) {
+		local_irq_restore(flags);
+		return;
+	}
+
 	tb = &trap_block[this_cpu];
 
 	mondo = __va(tb->cpu_mondo_block_pa);
-- 
2.47.3


