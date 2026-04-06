Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CD52F46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:18:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96D046B0092; Mon,  6 Apr 2026 10:18:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 944126B0093; Mon,  6 Apr 2026 10:18:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 880AF6B0095; Mon,  6 Apr 2026 10:18:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 76DD06B0092
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:18:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 26804140480
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:18:00 +0000 (UTC)
X-FDA: 84628335120.04.3DB2708
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 83D7A4000F
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:17:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fEpsZlte;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wx2x2JXLBBS2O+yAPtpskFQseB8I8qXGfT1HXmKX5cs=;
	b=aIGRNBKTjnbjnQjLEFUgK4nS0INAyqtQTx6ufQ1m4sKgMvdGSZvegocmK0esIxQFFwMRa+
	ZloBwKmchPcNH9iDGvScehEt+aXNHnLCjbYt0pvdBIVFqw6bDxMmH2+WRNVZrxqmMLvo4+
	Em7v9WSRBXtXwhZXm7MqjiF9vIhMEXM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fEpsZlte;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485078; a=rsa-sha256;
	cv=none;
	b=ni+2RaAFA14vdOd7cz5BDEbirLP7Q2u3ZlW4sDRaqv/rb/dnozocmzkRjWb3V/KDkDQZAR
	suH0ZyyFu9+msnXSled2yaNPi8vvCXBOmOMYOP61v7glfm11RD5zb5Hnr0tZmll/Ypqrss
	NXQkn//PDzMet4VeBigI7PDZu97TXds=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 04B9F60128;
	Mon,  6 Apr 2026 14:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F26C4CEF7;
	Mon,  6 Apr 2026 14:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485077;
	bh=a4vQJGv5oSnYFOAuEaEUtLL2TvNcolXC7zAnBLawpZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fEpsZltem1eqf2vgJDiHXUdg8MFqoj8Y/2ecLrFLGPhbPbGX5Ow5vo+HPlwwFJij6
	 CpuMNgzQJuuZJujPtp7VOQwLZhTNyXOYCMvy6ua10Fmx2vJUf8pk808Y5CV1lgtX7w
	 FvPPhk8IxfI+P5H+Enip053hbmb4PiBcQ4aGqOv95QQepXA9P+eaBE/QGkk/Jwg8s+
	 zXehD+T8JwqNQ26TJTRNOZrxSCG6iOpPCSnEKViBiHXUsLLWJDte7+BNhUi5BmnFxY
	 IH3nI0Je2ybhKam6EMDj5vedW+w8Qg0GduWk/9e1ayp38PL5wAwN5T4fekNfFIRpWS
	 khM9ESJ7g02GQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 02/53] selftests/mm: khugepaged: enable collapse_single_pte_entry_compound for shmem
Date: Mon,  6 Apr 2026 17:16:44 +0300
Message-ID: <20260406141735.2179309-3-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: inyuebqeirwg4sx7br7b9qii8rmjpthg
X-Rspamd-Queue-Id: 83D7A4000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1775485078-582408
X-HE-Meta: U2FsdGVkX18ejH960OxYy6N838D94339VMn1YT/j5MuEgquUeg2GHS1tu0pKD46mEbjX/IrIPUvrOD0XuQKhm1+GFqU/tSkT5AnGc98YVAmaW4Oq/sC4cZp76rPfhF/44LOgxncM2GzCTgSo/tCXIOpr2yG9TaLAEccHl0ZEef7HUM9Ur1/Vsx2S/TQcTYD359jnenEB55cow5z6EGDIDueb4V4X4OnozEU5weSahxLFGtzqVYBagyC/ZRwnLE+G43qNBvw63jvIXrwLxeTItQTuQc3eBWRmKUQhd+/HaRxwnXaE3c2/BqD7K8DWmHp76v8ptNnVPaEb36DINxuFbw2bFAebq/2LDFl8yw/5/B9Iw0eslflW5tyDp2aFfrI3dpa2ekvomjQ4zk0SoDvSxnnXBbvVwnuMgIKVXaVCNTscpuUFHbLXQhDdXyoylnGkXJSQ6Biii330uG77mOeOdHUZYIiH8K5SpmY8P2fa49ttsfiborPmJetX0bX/mtMQ6HGhR4UkuUhdtMsePyCoAxO8ho7DmNGdhgc2lEEdPbB/9O3WcWj6fUUcdVJbg0lWhV4zAxBI+yGcUMkGjkhw8wWaNtw9rGoOJc4w0neSgRftj3/rHSxkQqEBA9dvbL59n7NWGWeARJRh5bJYZtU7drObriOJkS2hHT3qeELl/a8SbjA3z1E9M8GW7g1cs6CIpsq+gWTd+ouHLFfzmjxdPYfYKOPjIaQRTovmkeJ3LQq3aVB0GE1OoReh7cVUtpXPt00XSeVok5FL3L+UDMsQqR5QThmCXXIoUGlMavdwivbt82Bz2jiilJ9M1FOAIu1g3C9EiPU8A37y+HLWVLNNxO2WBHEaN+VjeSF8CSfcPFGmhUBJIWqRt5XzBouDCs/odoApptfVrXz4c17bW6Ai3nXB4Dr/632Zmi2yNGgf1I+TgBT0d855wNldSwjKZT/kD1+Eed0ZNiTAV7Pc79h
 8FRycdtZ
 h8vFaHyQTUYTF/CdyIRNm73vUZst+3GYtIM+c/1wte7EtAYmQKC38qG92UWVfX3z7NhD8cC51ZzJGxJRQJXzGJufJqA4Dkcxnwk4BNVxGbH7kyVBuXXmirCpiiCA4xjoq6sVAeSrRUEFsmOevmbFfFcaQxF22SP8fJCpKq0DbT9vd+eWJXoQJtwC3YEsAeKBYWi8Zhmzfkxz+Ar4/yNC+PW6V96IaEqYMC1L1WQfnSiZs6OB/94wmoHN3aSUIDtf5DbiOxw6S+chCqXm949IslSTUSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

A comment in collapse_single_pte_entry_compound() says it can't run on
shmem because "MADV_DONTNEED can't evict tmpfs pages".
But MADV_REMOVE can!

Use MADV_REMOVE for tmpfs to evict pages and enable
collapse_single_pte_entry_compound() test for shmem.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 3fe7ef04ac62..e6fb01ca44ed 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -783,20 +783,17 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
 
 static void collapse_single_pte_entry_compound(struct collapse_context *c, struct mem_ops *ops)
 {
+	int advise = MADV_DONTNEED;
 	void *p;
 
 	p = alloc_hpage(ops);
 
-	if (is_tmpfs(ops)) {
-		/* MADV_DONTNEED won't evict tmpfs pages */
-		printf("tmpfs...");
-		skip("Skip");
-		goto skip;
-	}
+	if (is_tmpfs(ops))
+		advise = MADV_REMOVE;
 
 	madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
 	printf("Split huge page leaving single PTE mapping compound page...");
-	madvise(p + page_size, hpage_pmd_size - page_size, MADV_DONTNEED);
+	madvise(p + page_size, hpage_pmd_size - page_size, advise);
 	if (ops->check_huge(p, 0))
 		success("OK");
 	else
@@ -805,7 +802,6 @@ static void collapse_single_pte_entry_compound(struct collapse_context *c, struc
 	c->collapse("Collapse PTE table with single PTE mapping compound page",
 		    p, 1, ops, true);
 	validate_memory(p, 0, page_size);
-skip:
 	ops->cleanup_area(p, hpage_pmd_size);
 }
 
@@ -1251,8 +1247,10 @@ int main(int argc, char **argv)
 
 	TEST(collapse_single_pte_entry_compound, khugepaged_context, anon_ops);
 	TEST(collapse_single_pte_entry_compound, khugepaged_context, file_ops);
+	TEST(collapse_single_pte_entry_compound, khugepaged_context, shmem_ops);
 	TEST(collapse_single_pte_entry_compound, madvise_context, anon_ops);
 	TEST(collapse_single_pte_entry_compound, madvise_context, file_ops);
+	TEST(collapse_single_pte_entry_compound, madvise_context, shmem_ops);
 
 	TEST(collapse_full_of_compound, khugepaged_context, anon_ops);
 	TEST(collapse_full_of_compound, khugepaged_context, file_ops);
-- 
2.53.0


