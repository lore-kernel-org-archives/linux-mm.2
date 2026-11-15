Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F6B7606A32F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 21:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FmoMRSyn
Received: by kanga.kvack.org (Postfix)
	id 284916B05B2; Sun, 15 Nov 2026 15:59:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 234BF6B05B6; Sun, 15 Nov 2026 15:59:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FD3A6B05B7; Sun, 15 Nov 2026 15:59:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DFC676B05B2
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:59:58 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 49AF91607F3
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:59:58 +0000 (UTC)
X-FDA: 85438570476.27.14EEE26
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7863140009
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:59:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FmoMRSyn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794776396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2/WlrLv3rx637/xLB2mJR6zPnrKBFs2t8412/Tv2urE=;
	b=T+o3LwKuYoxuSSUjpxiW48sbYROYUvhbpWDs40QhoFKvj29lVkhMRPXHtDkLnJYYlKScHN
	XCc4Kv+0RZ530f4WbVK20KxEQtSsEHi4CM7bl9kv92bCwggsiohZ9LxMQn59MSUMvTuOq3
	CmeMj+J+Lwoa/esM4RUKS0DG1Cdz1EI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794776396;
	b=PjX9FNh//mMxexEV/A2wtJ7YbcouZZA5LPU3nPNuo3zgFnSoIO/URmRc/MArePNlBJEPmA
	a2YL8+oGqnDijPCkaMO3nDRTe7KSnC936moqVoXM8d9VhhTSSSpbJuFXG7pGpqS2CT2QDg
	T1B8s9FkxVdKWXp9wNT/9n8+Untbu10=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FmoMRSyn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CA30A406F2;
	Sun, 15 Nov 2026 20:59:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7751F000CA;
	Sun, 15 Nov 2026 20:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794776395;
	bh=2/WlrLv3rx637/xLB2mJR6zPnrKBFs2t8412/Tv2urE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FmoMRSyn036wQYRqY5I+q4VSwo4/lBASPt41y6c/GBJQUlqh07IoWYwCn9X4nxXI/
	 qTaMQRml85ZoyJcTubYBZfcA0o6XZpkS+dhfd7n6xRfrTdT4C3b6n9PnJYiwpGg3ed
	 gQIwHwnsR+eOlfKO6Isx/4vkrhVZBnwXLiVrttByb/bcev5Q6UewDo/FTJaS9JfoUd
	 gjxC9yC/CUn209JAXsxVPBVb9Eg6mk0ZBptQbm2t8iG3/nPkyu/ThcM6lihl2kHYp4
	 Y0b+1tr7u6WhWEQeedg+HoFehDV1uV7CqM/Ju1qk+q+sXkk9WpkQ8/dMdUAoOKZ4BE
	 1WrBcEWXtH6bA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sun, 15 Nov 2026 20:58:20 +0000
Subject: [PATCH 1/3] mm/memory: remove racy huge PMD assertion from
 walk_to_pmd()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-huge-pfnmap-fault-races-v1-1-537605643f6f@kernel.org>
References: <20261115-huge-pfnmap-fault-races-v1-0-537605643f6f@kernel.org>
In-Reply-To: <20261115-huge-pfnmap-fault-races-v1-0-537605643f6f@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>, 
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>, 
 Roman Kisel <romank@linux.microsoft.com>, 
 Saurabh Sengar <ssengar@linux.microsoft.com>, 
 Naman Jain <namjain@linux.microsoft.com>, 
 Michael Kelley <mhklinux@outlook.com>
Cc: ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Eliav Farber <farbere@amazon.com>, stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1634; i=ljs@kernel.org;
 h=from:subject:message-id; bh=thuYM+ra89Xe+thgF7+RwlppoUyXwhIzMtQWcpO6kLg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJ+yTqJv/r0hfu0/9+HsxgMt5kf+MRadqeo5bl7Ylamz
 yO5JZ+5O0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRLZMZGRrkfHaIz+9aJNFV
 +O9cePA58WabQwH1Xb55J6Uv1l7K+M/I8MNu2xO9BQxCPzIXON19sDigaKbytjf/r+xeUT1ZKyr
 jHQ8A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: npqf8xg83f95oz7i5arx1ukcqcb417mb
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7863140009
X-HE-Tag: 1794776396-917432
X-HE-Meta: U2FsdGVkX1/VJguTLJL9Ea0c3nLjFXgYE/PaS2Cf1QXCl1Tv48LLahS7bq5MTvu4gjzH4Jw/sXA0LWbQ2hf9Rr9G3vn9nQIHsefu6jZ/lycFEd8xYo59xmA6+zzkOHhYHImqt+pN3Z8Dq2EaAOLdmhUmNo1BBPloWbvEQNYC2T7poKjPjmhBCccIAqBI4Z/CjM91A5qjHv/Kz60LxkjXvYF08RRhnycr+bm8AwQsPx6c5sGNSkpoENf7HprrCHjJYUtBxDXgsOw4oY1BsNd0GZfwCg09dF88x8chULMrNfOUiWgWHNPcT/JPzGSlqqv4wi8Il6sEh0UGtYr7frHLyAAHBcsbN734b/NZpWxS6JBPsVWWRIFuTG9Cgu1+CcHuucAg3nYfd3suQAxCDMtOKx8BryVVeZ9DK6sAAT6sP9YdrMsj6F5sguePbCBrSJKh0pttKULqJmfByRM8dZIfnHhT9ikJRYz0/f+RkO/tz42v7BLF/rd3wN2WSxuASjqCqHZQtCTDTa5Cq2SRaiG+aCFYOvvoGRAzwwaXab8n5+ZfbZmuI4RNCu/u9oz3XHZZ3r6Dadu95vUKXbFiYhkXgLHmX+LtZ2GJJ4jZeCalwOwX0EJfel8zsJmq8DKdSSq2w8tdkes4DyPEBAwpDCKWpxFIarArRE1abUT1mo3icdGtLWUIgv01Gfy0/OauXQ/HH9uGunKJ6boaujH1b4kjUlgDYasN6a0BpWMUOPRRCCsEzw/9fUSi5Ik5FCRmKslvVsJxFQZfst7wz7VZp65UaiMeWIqCBPwG5bKVPfT3yCRzZ1biTmIZQccESvkpYxJOaudvyxA32DYaxiMrbGLU8mB+FdjtRq6vl6SZIVkNskviWekUirMr9hKSmc6qLKzNanNVAE9k7l1D1sytRXmsa/Xa4Ea1ykWvsUA79cef9nHle5p/hijSSUsTC/oFKEawC3SRMWRkbB08zeB+1ou
 DE7gpEJU
 afvpHH4JLbJRVG5/vLF5srEZ4DoxL6w5S+S4aPPC0i/5UR0B11iUpMrGy/OnECNUyV0gzdwmcCky58lwYegubKlZxLrLjWp2n/t3kiu7ENy/1+2lOvXSThjlY8MjCJ0wcl//YCIXZIBIsB2zHD/Mo+45MBMA2alKhutAjLqhaU8RaL5DxNHpkqAEFNHk1+w4lDmYXdBkR/61FbcGG44w3KIZWhZDa+7kJ21YwHPdJSCHYqbUuHX7P2bXb16e9psrzC/SCNy3EqAmb+AurugbkukHWkkmIRgaRoWkncfvcWip6qXckZy/dPxVxnKzyM2ub3Ycq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Eliav Farber <farbere@amazon.com>

walk_to_pmd() asserts that the PMD entry it returns is not huge, but does
so without holding the PMD lock, so the assertion is only valid if nothing
can concurrently install a huge PMD entry in the range.

This is not the case for a VMA whose driver implements both ->fault and
->huge_fault and which invokes vmf_insert_pfn() from the former.

The existence of prctl(PR_SET_THP_DISABLE) is problematic here, as it only
takes the mmap write lock and faults taken under the VMA lock are
unaffected by this.

This can result in two concurrent threads faulting the same thing
disagreeing as to whether to attempt a huge fault and thus ->fault and
->huge_fault running at the same time and triggering this assertion.

So just remove the assert.

Target the commit which introduced the first driver able to do this for the
fix - vfio-pci. DAX also mixes fault orders within a VMA, but serialises
them using its own mapping entry lock.

Link: https://lore.kernel.org/all/20261112051440.16140-2-farbere@amazon.com/
Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
Cc: stable@vger.kernel.org
Signed-off-by: Eliav Farber <farbere@amazon.com>
[ ljs: rewrote commit message ]
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/memory.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 3a20d64fd276..e03110906aa8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2384,7 +2384,6 @@ static pmd_t *walk_to_pmd(struct mm_struct *mm, unsigned long addr)
 	if (!pmd)
 		return NULL;
 
-	VM_BUG_ON(pmd_trans_huge(*pmd));
 	return pmd;
 }
 

-- 
2.56.1


