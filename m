Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEABC606A88F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 19:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WmtfRbHh
Received: by kanga.kvack.org (Postfix)
	id D924E6B05B4; Tue, 17 Nov 2026 14:32:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6A436B05B5; Tue, 17 Nov 2026 14:32:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C80E26B05B6; Tue, 17 Nov 2026 14:32:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 985016B05B4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:32:38 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 34BEB1C3E58
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:32:33 +0000 (UTC)
X-FDA: 85445607786.26.7539497
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1F8C84000F
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:32:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WmtfRbHh;
	spf=pass (imf17.hostedemail.com: domain of devnull+samridh.modal.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+samridh.modal.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794943951;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1uOJYUkeTceYDTlatxwLRj1jcM58HxwnlPEOaQ6WvXc=;
	b=NgHTqiMVgc+in8/ymwQE+b1a35PiRGWZYd1JJlD2240l3zDq28L1DbNd9V7VLy7vH6MJsU
	dX72AqmYaCzYRU1dSmr4Qqz0wYVyu7U4Ee2sFYibxOLvFUsa4Dr2pnnaj6XAZpRx1Wcd16
	8BR3HR48doU8ncH5fBW+4HAIdoUW/Kk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794943951;
	b=vNBZr+eL4tT02sbL2L1tFcZt9bUbntuceyUjIytsflv1ntw1mpF1mCekSS2GPcL19TjpuM
	3lP/8YFBAQVjSEHj+9ZUJyTbs7R8I7rw/RiCXCvQ5kIIJZWRRFEnpjvx0rxjBkZ8K9GFcV
	fKnDotbScqX6L3yXVb3ad2A4ukzpbHQ=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WmtfRbHh;
	spf=pass (imf17.hostedemail.com: domain of devnull+samridh.modal.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+samridh.modal.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 80BE9613AE;
	Tue, 17 Nov 2026 19:32:30 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794943950;
	b=d7yHcWOU8HASSIN/e8GI4gYACbYrUovxVeMtm8kQrvG3QlAI7UNSd22OAfnf/aZpQH4Y
	 4oZVpzk0fIY9npKkMWuw2rq5Pm1bC1qNf8TzvNw4dG19OzwD7V1fXtudCtGewdFJ8zhx1
	 3NrHT+p+l4IEmzLtYKN+UWxTPQGenpZyjscThBoLAPFN5JkQFy2HuajO3xKk2T0IFevK2
	 RLAHOEqcge6XRdP41kGF1YKRI+si88+qN+fnfKhgDJL4K0whAorambWg2mSbmyjZEqBJW
	 YA+Xy3tkhpsruPI8fwFWDZDIPSBbj4M3DrksW3LqbsRvJJzmcDY7XwnMPOKxXnYwT/w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794943950;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=1uOJYUkeTceYDTlatxwLRj1jcM58HxwnlPEOaQ6WvXc=;
	b=gZwmtiykk9MNcgPM/EDD16j1Ha//DnBWppmpzC/LfZJyHUzAUVWRBqmRJf4kkdXUb7Wr
	 ftGHqU71TMMwt4+XjeJO1LNwFcrFGL6sDJzybzHnak/NwLVwAKWe7oCPkgmvTVc46pC4c
	 Mb1WKkIp+sTualPy4FcxfGXdkw5D7wH77bUzYQr684UTBoziUYkeiZkQ6DLJfCYsNGUJv
	 hVko2ikhA2GbxKAL0ph7LLReF0fllGXOZtyIffreUHFUh73WH0tqGDA9JEYCIAQNH72qZ
	 uvmRQ4GBffqelAJ80Dvvd35CuO3daFwVYwesQegnJW4tXQgrUGMCEWJvWhKR8B7vAtQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 1FC771F000C4;
	Tue, 17 Nov 2026 19:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794943950;
	bh=1uOJYUkeTceYDTlatxwLRj1jcM58HxwnlPEOaQ6WvXc=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=WmtfRbHhICDEN59TbmhoraiQc7RHSWgdlvSWT3spNDvm6Fiyi1xZH+SEbCGWMgpiA
	 xZNeFwAIcIwL6JVKOkbFs+Py3wKILWOAfobT9qL51jhUvMQxl8JX1qKsYTnh0IteWx
	 tR7f34uVJnFGRrtx85gSxYZGMtCTbMICBz61RMCBhN7nxFdrlITsnb6/m9YkfP6xn0
	 sCdY+mxlIWmW/d4grHkq2XAf3tO4h6X2egYZ66Rk7NYLqp3k0OFAYmpzBNsZUuWUTY
	 x4vBHGAz+go4ZvkkLFqPBbfhk1eP484vtl2dJOhz3gUzklhMdQ1WUWUinjptAo3hru
	 mqq9ELfwGLt6A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 8E90D4AA65;
	Tue, 17 Nov 2026 19:32:27 +0000 (UTC)
From: Samridh via B4 Relay <devnull+samridh.modal.com@kernel.org>
Date: Tue, 17 Nov 2026 19:32:26 +0000
Subject: [PATCH] mm/shmem: avoid zeroing new folios twice with
 init_on_alloc=1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261117-samridh-shmem-send-v1-1-1b897ff562d9@modal.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/yXMQQrCQAxG4auUrA2YEWz1KuKiNn87EWaUiYpQe
 nfHdvkt3pvJUQxO52amgo+5PXKF7BoaYp8nsGk1hX04ikjL3qdiGtljQmJHVj6NGrQLB0EHquG
 zYLTvOr1cN/v7dsfw+p9oWX7APPb8dgAAAA==
X-Change-ID: 20261117-samridh-shmem-send-9fd2d8231e8e
To: Hugh Dickins <hughd@google.com>, David Hildenbrand <david@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Samridh <samridh@modal.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794943947; l=3830;
 i=samridh@modal.com; s=20261117; h=from:subject:message-id;
 bh=a7F7GTEWjxL9C0nNEosbwVj6fkOjYCgTqLb1jXjkir0=;
 b=SGNqaUKOMECCXRZi1l9o3gcwAg9U87xEHWyCYMLVkCloKUFF9Ay+mQBIt7txWMP42l2ju4br2
 9H91UYwZTVYDSc8S3KqW5lzYfQHrgUjv3lPtjx9KAtzYUioODSdQRll
X-Developer-Key: i=samridh@modal.com; a=ed25519;
 pk=+V5ZaIpEMOLG1b2MsSHY0Nm20lIADx5ia//FZeuqVgk=
X-Endpoint-Received: by B4 Relay for samridh@modal.com/20261117 with
 auth_id=1554
X-Original-From: Samridh <samridh@modal.com>
Reply-To: samridh@modal.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mmzw47m5yyza8cqhe1medafhtsiu13cj
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F8C84000F
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794943950-962752
X-HE-Meta: U2FsdGVkX1906S2gAOQtCoPpXKWnWd5byOIjlgpDYAXp9KkTVa8PkE2nE4EzIQj3iYBwsnzCK+lDqxZF4OM9EDRZKFtQu9Hxdpa7ZqqDbndBKMlhzjZFSScScwDDfc5JMSsI5NRnq+nQX3w6uP2bpgSFxpE1vhJRS1yoN/iNZK8R1SH0/YK+m/DOK/zLKQLaoLuO1iYTNwNhokaIhZ4LeT70DRg+XG0MPMEhf5JDq/jJVSgtUlF8hbFWDBWaAmms28gcDWeRpVboGR2wCVfmCxHByVA6FLogMPchjSqg3AwCHdoeltfW/Zb33fRuCuLTfKJLRl6nDLE5i1FQ+BbDlzLTXhiulNRYwHVtPygRBiV5xOqSDVEUGX8lzJpk6TD1XZ1KDPKJ/Io6Wsyr0MQo4Fk+qaaQ/+qZl1xEwX2u7a9OOY59rzxdhQrwJwoRqnkwvHzCkmstJMcHoG7QXWwfHvc7WwROdXD5j3JxzdcJ1UDEJk4dXK93jPMN4okbaYY4ZC3gmkOGmD+pc/8ff4OGRoSXztti/V/SbCjMSuaoMGgRk57kdg26iLmVeKK0wdohHztkDDJTNs38wjtK1kvSbtnkVEpN1K/pRSOHYEDbrsAUpOWwlq80ihwTM4Ybpk7ompcYd+/bfpb7CC6bEzGWK4SeM5+qCYdH4o8miX3WYfrJfcSn1qetAuDsD9RODm68ZVOwpC1OUywqiL74Ziihs2oIUdxgk6MJIelTKn3fkV+Mn1C5y7AxDTK3p1OkFULnT0IlHYODGgTjEO/7rI+fReGHfvYWBFlgWyasEo5+TTRdOHu8OeW8WTQIuZGAO5hpARCjY0HkQ1HLeVOI6pXYMBcgNHWolOdgkP5qEzcG3VGnJjphRxLfNe3KoluTDuIHGGNnRwW6T5m3+VNM0nXyhU0DFhwCBJteZKvDENPiATxhVpfEyqLbhLkQfC9kR/obe//v9HQ82JJO/R6P/UE
 JX4hUBOC
 jfUYkIXVZreKIAY9B9tnQB8ZAPcBiAVW2/x/KJDAJbafLrU3aaPtaYdKcgu2rIS10fX8gIusgUJxy4OygiSggblsI6KqMD1a0f6Xup8+SDSx2VjI+6hNuTSE94Xl725X6+VaxlsJaDWPzqEjvzOOVCd9I9jauz54C9nxKLcWp+aqy2g5n3+eef10nRqjJRdNqpgUAfxaHUVDCmgUQgmFKP2JgvPYtKBLqrtuisWUkKkEZOcQag0zgVU70KInZFgwm4UwtTxqoph0YD27jXAdLbsEbU9aAYaL+FFoKGyb5tnZ0jRJ6UDQqBvJF84I12J6k592j9iSkwX6p9nuOZWkG7wCOR+QA1O7CHGDApflFV3vMGZ9vrogttNBIsTLYZt40Bux+oSCYvf1848BJ9HbJnj99draEyYR3pqUbMPt7L68koe/X6G+Epmc91ViWIfXwNRAzxdxeE0cYpXZDWN6V9suimGUxE5TcoWaIIYemRi+nGIVWSXLw7DD7mE6P1Dvy53Asbv7OR5wVgitOslEX1gXkNGwHLn3B3wF2Rgay4kHVhK8nTbXR9symjfmZ0/0HfuTN
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

For SGP_CACHE, the only mode that clears a new folio, ask the page
allocator for a zeroed folio with __GFP_ZERO. Folios that are already in
the page cache but not uptodate, such as those left by fallocate(), are
still cleared. With init_on_alloc=0 the zeroing moves into the
allocator, so a folio is zeroed for nothing when the memcg charge, the
page cache insert or the block accounting fails.

Time to write one byte to each page of a new 4 GiB memfd mapping, with
shmem_enabled=always and init_on_alloc=1 (median of 24 runs on 6.18.55,
x86_64 VMs):

                  before   after
  Xeon 6975P-C    0.620s   0.416s
  EPYC 9R14       0.216s   0.158s

With 4K folios, or with init_on_alloc=0, the times change by 3% or
less. We found this while running gVisor, which keeps sandbox memory in
a memfd.

I wrote this patch with help from an AI coding assistant (Claude Code),
then reviewed and tested it.

Signed-off-by: Samridh <samridh@modal.com>
---
Tested on 6.18.55 with this change backported, on Intel and AMD x86_64
VMs, and build-tested on mm/core for-next. I also wrote a simple test.
It fills memory with data, frees it, and then checks that new memfd
pages read as zero. It covers MADV_HUGEPAGE and MADV_NOHUGEPAGE on the
fault and fallocate paths. It passes on both machines with
init_on_alloc/init_on_free at 1/0, 0/0 and 1/1.

The idea came from David's comment on the __GFP_PREZEROED RFC [1].
One thing I'm not sure about is whether flush_dcache_folio() after the
allocator has zeroed the folio is enough on architectures with cache
aliasing, so a second look there would be welcome.

[1] https://lore.kernel.org/all/b258160c-5287-43dd-b56e-268c403b85ea@kernel.org/
---
 mm/shmem.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 5cb628cc9c6b..d2c6781e86a5 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2692,6 +2692,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	int error;
 	bool alloced;
 	unsigned long orders = 0;
+	gfp_t zero_gfp = sgp == SGP_CACHE ? __GFP_ZERO : 0;
 
 	if (WARN_ON_ONCE(!shmem_mapping(inode->i_mapping)))
 		return -EINVAL;
@@ -2770,7 +2771,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 
 		huge_gfp = vma_thp_gfp_mask(vma);
 		huge_gfp = thp_shmem_limit_gfp_mask(huge_gfp, gfp);
-		folio = shmem_alloc_and_add_folio(vmf, huge_gfp,
+		folio = shmem_alloc_and_add_folio(vmf, huge_gfp | zero_gfp,
 				inode, index, fault_mm, orders);
 		if (!IS_ERR(folio)) {
 			if (folio_test_pmd_mappable(folio))
@@ -2782,7 +2783,8 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 			goto repeat;
 	}
 
-	folio = shmem_alloc_and_add_folio(vmf, gfp, inode, index, fault_mm, 0);
+	folio = shmem_alloc_and_add_folio(vmf, gfp | zero_gfp, inode, index,
+					  fault_mm, 0);
 	if (IS_ERR(folio)) {
 		error = PTR_ERR(folio);
 		if (error == -EEXIST)
@@ -2810,8 +2812,11 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	if (sgp != SGP_WRITE && !folio_test_uptodate(folio)) {
 		long i, n = folio_nr_pages(folio);
 
-		for (i = 0; i < n; i++)
-			clear_highpage(folio_page(folio, i));
+		/* A folio allocated with __GFP_ZERO is already zeroed. */
+		if (!alloced || !zero_gfp) {
+			for (i = 0; i < n; i++)
+				clear_highpage(folio_page(folio, i));
+		}
 		flush_dcache_folio(folio);
 		folio_mark_uptodate(folio);
 	}

---
base-commit: 0c524518413094607a6178c53a65815762bc9c45
change-id: 20261117-samridh-shmem-send-9fd2d8231e8e

Best regards,
--  
Samridh <samridh@modal.com>



