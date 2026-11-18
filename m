Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED99A606A32F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 20:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ip7aDBio
Received: by kanga.kvack.org (Postfix)
	id 019D96B05B1; Wed, 18 Nov 2026 15:29:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE65A6B05B2; Wed, 18 Nov 2026 15:29:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAD7F6B05B3; Wed, 18 Nov 2026 15:29:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2B5D6B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:29:05 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A3F84140897
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 20:29:00 +0000 (UTC)
X-FDA: 85449378840.21.A6BC5A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6B83C180005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 20:28:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ip7aDBio;
	spf=pass (imf06.hostedemail.com: domain of devnull+samridh.modal.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+samridh.modal.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795033738;
	b=586mMW2nYopn94JqkREDuJ2IGDythCRucFKMuypNPYbqRoZITo1YzMhvwh/teW9IEBirXx
	R2CSXdj8C2dL5QJmpLH9Lb4OrF1by2JTlhvEHHJau+ZZRbtKaV4C49OKzK0k6yKVbc80R8
	btcyHrdI65nRsfsmt1F3zN/id8B4QlM=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ip7aDBio;
	spf=pass (imf06.hostedemail.com: domain of devnull+samridh.modal.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+samridh.modal.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795033738;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8sftw5l/DhRq72nNXbEWzstEP0Vk5phUAbJeve/CP2c=;
	b=V7+CImWJAENnU9UUx+gIT3vJdkkDnkex5Tzszufkqt1Y23hSMzE9JwxFNW5BbFmUEtt3ZD
	5yxTDmOz+D0I6acfQVk5LG/8T59uWp7Yz9jR3wD4dl5tguQ1vDF3V236k7xJ5iUHR4tHjr
	IHwymF4PhTtwlJvWCQVtpFBSsaM72SE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A0633465FA;
	Wed, 18 Nov 2026 20:28:57 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795033737;
	b=sUBGmXkpwu5t3RHZ9CxghERqQfYqANNDi4NcOKB7egKzQMXJnX/+mDeaapjBb4X+ZlZc
	 mb4VmL85cV/PQ7nKl9JQPSuGHh1GiX+tKSypm9cb4mvh7md+W+hwCTxtl/2K+8r/myT7o
	 ifARm86YLgBCFGv5Ez4XUmVfC745UKXiJRi2xsjyNS8yIuhoh41gr6SEoTJINydmRmGFD
	 24kfTfQX0KU8X+3C94wNPdUnMvKhz0WMGyqFuXrQyxCmSCbB/cWC7TZt2S4lRFvHxj1OP
	 MhkWDxrRzKSs/kuqOfHh20WGm3TegKqW0h1ztySbDDD2ZZ10Y0IXHCBzzyJmefDYtuA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795033737;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=8sftw5l/DhRq72nNXbEWzstEP0Vk5phUAbJeve/CP2c=;
	b=KxSJ37DOK0kARX7pCiq68lBhoKESJxP1brqXxh+9Njn2vSoE3XxDwA1csYOMDDbuTcI8
	 69zGTLoKqw4qs79jCdCbcbVmuHur7n33EeT/Uy4jnNXLB2B0rIJFTgSSe0Yx5zlmPFAF4
	 8Ymq3YKPBAbDqDu4RNOox51vQSqe9sUEIq7oD1wOqvwes4eIlmoblsz9aTZD/J2YV8iig
	 Xa+ggvnIxJS0aB+xTFYB6QZQ5H+lkHydvRju4WMTwoUG6SQexQHAoJ8M5lvvPjyzD7+Yj
	 1ARzMLCSDDTbvzauSRUjzmjRG8dF5m1pWmWVLobjyZOmYJoqQ+cvuyJiIRXbAKVGCwA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 1A5731F000C4;
	Wed, 18 Nov 2026 20:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795033737;
	bh=8sftw5l/DhRq72nNXbEWzstEP0Vk5phUAbJeve/CP2c=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=ip7aDBioQyVz/tQ2ktPhmvHwcW6EAz/wmE6d77VI7cFU6IoQGfEH1S+gDt/jcZ7Lu
	 mAyyz2UM/s4jxoq39KxeP9fZKQDpFs9QBm5SLC3KkjxHlu3DTzeVVRtzIqKZTSKRL4
	 +u4C2kSx19cZNuMBkv0wDy+oKTY9S1HuFffUuqBA3eFPaT5bgOCVWVBFiHhq6nEdRv
	 EyTYO9Vpbs0ZZv7k3exaLU+WoXDRNYP3dxuEKc1qC1bJEA4I65s8Z+nMgNkvcz5zhO
	 QCO/L0MBsnOeCkzxse/Cxp1w//k/nb4/l2AZRh0JVacBrKYdC1fZqoCzQooUX9L7OL
	 A1gunDRDGv8jw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9F0D64AF6A;
	Wed, 18 Nov 2026 20:28:56 +0000 (UTC)
From: Samridh via B4 Relay <devnull+samridh.modal.com@kernel.org>
Date: Wed, 18 Nov 2026 20:28:49 +0000
Subject: [PATCH v2] mm/shmem: avoid zeroing new folios twice with
 init_on_alloc=1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261118-samridh-shmem-send-v2-1-f2ea01bfc178@modal.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/32NzQrCMBCEX6Xs2YiJ2B9Pvof00HY3ZsU0kq1FK
 Xl303qXOX0wM98CQpFJ4FwsEGlm4TBmMLsCBteNN1KMmcEcTKm1rpR0PjI6Jc6TV0Ijqsaiwdo
 cNdUEefiMZPm9nV7bH8urv9MwrU9rw7FMIX4266zX3l/BrFVOXzeVtafSYHPxAbvHfgge2pTSF
 2SIYJnGAAAA
X-Change-ID: 20261117-samridh-shmem-send-9fd2d8231e8e
To: Hugh Dickins <hughd@google.com>, David Hildenbrand <david@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Samridh <samridh@modal.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795033736; l=2467;
 i=samridh@modal.com; s=20261117; h=from:subject:message-id;
 bh=+TIZt89c6fPFtjTdzvaMfsLmhIUPC+6pbbVMTGgDYV4=;
 b=igkKsRBXifpqSlPGt8MqjeyP+wyHxMr7aac5YwvrqjKI+QWIAvd2E2nkRUZ3pMYuOpGgp0asb
 6X2llXHSRtoAcgb4nlN/NqqYHCfBn/kDjcDnf/E3XZh08nNqJZ3w7cL
X-Developer-Key: i=samridh@modal.com; a=ed25519;
 pk=+V5ZaIpEMOLG1b2MsSHY0Nm20lIADx5ia//FZeuqVgk=
X-Endpoint-Received: by B4 Relay for samridh@modal.com/20261117 with
 auth_id=1554
X-Original-From: Samridh <samridh@modal.com>
Reply-To: samridh@modal.com
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6B83C180005
X-Stat-Signature: czpj4khp5rdekgbombkuqgzqezdrduew
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795033738-912591
X-HE-Meta: U2FsdGVkX19AyTSHHi+Vua/F2iFdlNdjU9IdzB57vATnVl44Ztsx9XQ/vSeWYBlaO2SmxQEm9Jg3ZFztz1LirUuaHHtrRR5NWI1NkQ5pcAYeX829ciSCw31TnGqy3Yr1HiX4rreLCItyCeW9+kP6JR1+um568LirgxTbMp7kQ313znNg8Ql3D02Bxjt+TCRps1MKX5+I8KS4Csc26RF1kiauEjQXoTDUf4x5tabdqtNFVsje3Zs1TRak6HgLZAJ5HJBJV/CCY9C4ZSVEzgnpCUyzu2sp95BX2p2MqPsqWctWi+Zc6TyLO/GhRUSqmCHZjpRlDHIFIT6YPUXJ3zdqWdsHHm9homKf8r/3BHJGKfrPrNpggRTtV4ZYUy0WwuwAeyzL8WlZen5hLuJu2T8XrjGSKT6XHQNXXvxEYUUczyWSrh41Tztud2tPdTrG6UyHap6xoVwJP1xkZ2exQ8IDaLp6Hshr3tnxJhrbSjFmfzLDakRZlujlQvllS96dm7G8BPmdvLCSpg+8PuY6XVmhaB3M8pl/fC756iY8sNrss9HVQT+jnHTfG4ThTBUM/rcWW9gLen5ybH2avO4jb1wplnD8a3u8pQc1Qp0N2RjOirloiGCCk9Ox2yuFg+EkukrLSxu19UlExudMi3Usnti3gJ/S8usaLSU88/0eBVRR7+kZwc9xfc03k1jctlsQpkSbBQQ80r1qBgCJ+foyfLvb1Vy+4008j5Ao134OUM/DbUzDLugXmvbY+wTFYOpvTuBzIQgnvPl7SdaYeRasn122xGIO+5TGBIyoXFmHzh4+nnf7IvYgMeBfhIaRxvjkrKWmw/uVA4GIxwIk9bhSANKVrZvYvjgWGfsk6WvitYme/lrXbxYs4B5klZrMWXrGl2u8bJDDElS3qwPR9MdmsEAkE4uuMsHN/m4Kmns5DlcB4pja7asJDvQtX3lM7iprhakIpEZPQCGCcHHMBsgtaac
 BL6TaCZe
 10lgidrhFY+cSKZ94vLQpQu265DqqapGhiqif6oe4ayAszhJthf8tI92/f0PrLGd4xZZCr5nu3pY7p3+Rw7cCGAQtHf1VhvI2d1Ny0G2JZ+ANkCAgNTbHF68qVKDHfC5VEnEtnAurKoUow+WStRWiGRpp+P2q5ywlYM5R+Ar0FkPs2F2AVXOKbduM8CTYg2HpNJKuKONCj8WC5F1iSeAnvAstHsuqQcN8HnUQoPtlCEi01XDLAHKWaSncNO3w7wqBE/7KII3vP8msgy8t62lN7PpCq9s4JmdfLHGs9OkTX3Ybb9CBM6ybqKUpDkagnD2veyI0pvJBepQJ5TKOfXKenBeFSga94v7B2Gw4zE6Qm9WEOul9ejizI/b/Y0K5KdrNhdO7CIZI9WTsea28oGNX4YIQHdYN876hua/R7n/qQ0f5OktDYQQvL/ATU83aeVAnn4TkGGA4lPfW9AiLN4wbJt6coJ6uPGkVcTZZ7AXZcckPhK85zfQ7BXZIEa3W+TF3q3O69wGS38Sik/yFm8+TNcROtiB69pu8NcEi7WilhFiVLpBVQPNA/3MAba89KlPPZRk2muTPGMafpY0qHnZA0cfQaHEgtaXmnsRZv/JCUKC00Es0pDISPz1FHFdbFdGQXXlA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Samridh <samridh@modal.com>

shmem_get_folio_gfp() clears a new folio before marking it uptodate.
With init_on_alloc=1 the page allocator has already zeroed it, so the
folio ends up being zeroed twice.

Skip the clear for a folio that was just allocated when
user_alloc_needs_zeroing() says it is not needed, like anonymous memory
does. Folios that are already in the page cache but not uptodate, such
as those left by fallocate(), are still cleared, and so is every folio
on CPUs with cache aliasing.

Time to write one byte to each page of a new 4 GiB memfd mapping, with
shmem_enabled=always and init_on_alloc=1 (median of 24 runs on 6.18.55,
x86_64 VMs):

                  before   after
  Xeon 6975P-C    0.625s   0.420s
  EPYC 9R14       0.216s   0.160s

With 4K folios the times change by 3% or less, and init_on_alloc=0 is
not affected. We found this while running gVisor, which keeps sandbox
memory in a memfd.

I wrote this patch with help from an AI coding assistant (Claude Code),
then reviewed and tested it.

Signed-off-by: Samridh <samridh@modal.com>
---
Tested on 6.18.55 with this change backported, on Intel and AMD x86_64
VMs, and build-tested on mm/core for-next. A simple test fills memory
with data, frees it, and then checks that new memfd pages read as zero,
with MADV_HUGEPAGE and MADV_NOHUGEPAGE on the fault and fallocate paths.
It passes on both machines with init_on_alloc=1.
---
Changes in v2:
- Use user_alloc_needs_zeroing() instead of __GFP_ZERO (Baolin).
- Link to v1: https://patch.msgid.link/20261117-samridh-shmem-send-v1-1-1b897ff562d9@modal.com
---
 mm/shmem.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index c769d0bc7df9..1a78d15a768e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2810,8 +2810,11 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	if (sgp != SGP_WRITE && !folio_test_uptodate(folio)) {
 		long i, n = folio_nr_pages(folio);
 
-		for (i = 0; i < n; i++)
-			clear_highpage(folio_page(folio, i));
+		/* init_on_alloc already zeroed a new folio. */
+		if (!alloced || user_alloc_needs_zeroing()) {
+			for (i = 0; i < n; i++)
+				clear_highpage(folio_page(folio, i));
+		}
 		flush_dcache_folio(folio);
 		folio_mark_uptodate(folio);
 	}

---
base-commit: f7d95bf74091373fad7273db4557df9b5a902335
change-id: 20261117-samridh-shmem-send-9fd2d8231e8e

Best regards,
--  
Samridh <samridh@modal.com>



