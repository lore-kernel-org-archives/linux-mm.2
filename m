Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 107FC60A2612
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 18:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eAHiLR06
Received: by kanga.kvack.org (Postfix)
	id C39F96B05B6; Tue, 17 Nov 2026 13:32:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C133E6B05B7; Tue, 17 Nov 2026 13:32:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B27E06B05B8; Tue, 17 Nov 2026 13:32:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7C3416B05B6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:32:02 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 584FA1204C4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:32:01 +0000 (UTC)
X-FDA: 85445455242.24.88E8C4C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9D2138000C
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:31:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eAHiLR06;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794940319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RRbvW+En8y/uPg9IrKAVHkS4LhSJjr7+sUjmz3rl2DI=;
	b=3bImSYSRodKUIRCZ9RJxtMSqhPx5L1tjmmGBoRCCCPPjvaC19qo39rvO8HRgHuFMeKmtqd
	P7gxXdShWjEqI/H67Gb5Iu4cuvA1FZheQRcpKP8JNz2YkR+jiAIa6bTHpAwQOo1IkWqvMX
	3XdTwAoZzsd41/i9NtTN3vfW8gBaHYU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794940319;
	b=uWSolRfhRQ7y+38AwMFjJGQmJVJWbcR/WfetOgXhmZsP8kCIIpsvEhfDYyVn8BNkeQtGuy
	MNhYMLF9FMMLMlttYFltvhZZ2gbOWEyQpop25nvHftuL53oPc8eiwXss9zJSvGvq+TNw+G
	ddIaNrRQtXi+JcBGrhwlrtiyGeKHG5M=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eAHiLR06;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 31BAD60D7D;
	Tue, 17 Nov 2026 18:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D1F1F00936;
	Tue, 17 Nov 2026 18:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794940318;
	bh=RRbvW+En8y/uPg9IrKAVHkS4LhSJjr7+sUjmz3rl2DI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eAHiLR06tgjlgjgfkL4t2wBT3yuUbnJ8sClIljEQQtmABPTri5WuDQ6dIsOSllGR/
	 DX0dqdRvMK5S63Ih4qsevJk8BwsD4ymviM00JiP74qTb7pSLvKBEuzGiYp7+vcN2xr
	 Xdrc/yRk0Cg7E4oPtfrqMtPVwroL2O9swItWtL/VR7W4bDnuHoOecB8sonBLnM/+lV
	 SGwka9t+YU+ESE6bAI4LA331gsHrAMBo9yPOytX7TJSjkufVitjVVkLruVynWZq0r5
	 HS8ydMICLG9G/hQ14WcejdPt/in6OsNsZZMJI66WkdCFPBv5Uv25pc74nYcoQ4ZIM9
	 G3IHQvO6VDVyA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 17 Nov 2026 18:31:33 +0000
Subject: [PATCH v2 2/4] mm/memory: remove racy huge PMD assertion from
 walk_to_pmd()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-huge-pfnmap-fault-races-v2-2-276007e73bcb@kernel.org>
References: <20261117-huge-pfnmap-fault-races-v2-0-276007e73bcb@kernel.org>
In-Reply-To: <20261117-huge-pfnmap-fault-races-v2-0-276007e73bcb@kernel.org>
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
 Eliav Farber <farbere@amazon.com>, stable@vger.kernel.org, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1865; i=ljs@kernel.org;
 h=from:subject:message-id; bh=WGAuQKhWD2k/xkBNSx2QPxX6QrPPQa9SF/mJgcd+rzQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLL+zO0OCLj8337z7LMs3MEdH786b/tTuGaB1M4u1glKt
 48el1h8t6OUhUGMi0FWTJHl+Rfx/UEiYfM6L/i7wcxhZQIZwsDFKQATubGG4b/vxYvKF5byHZH9
 VP7qFEdr0OxFr6bO8KvI4LrnNlOl4lcqw//qa/e5IhvTTbomrt6j/LpHJ1T6TU7HnirF2pP2/3f
 83McOAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: 1w44fjqkjn6t737qyshn94mgusyazhfp
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D2138000C
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794940319-63098
X-HE-Meta: U2FsdGVkX18FE7XxvVeobPEaPKPGWCi92vKNT7nRziFSncQAzzpp6/VWXjq6od1jVDRrikMHi0qIyvJ6Ba+wu31dIZzfX5k/mK3Ojk8ubLvAz2J/ieZ+e6P2gDGmVhnMDi5g41hkWsS83SlLK7n58QNUoI4ZyWtthofVtmYefVMUVaeX+LhRXO8uZIQOF2JuC1JW+FwlWERvfVoZ1MP+vfBYz2MpO/fzepZ/gGCyCIytJDxpnzriK0Ri4cbINVkfr3XfpIY5s1//4/JuwNYTrh5n20vIFgWpJbKn7KBu7On7ShdW9fsl0LfsdAfy/Ma3c/yfUeaC1qqWVa+AnfsBaO9AyeWMyKaj/uOLo590gtawp5RSp4jRcX4qr+/HpGxNn6MAXxDDt+pe3h8AtbBw/WYGZpwv0KzXrIAOBMl1ftVYgPvdg0KjAaqDVDGl/XwOnYDWccTrZGpgXCqXuUpEXoGTUqGWmDZ6x0e5lI98egU/qfaL1ZwZCPXcQYbWk40pSikBjkYqCaSZ+PAdcfwyYB4Rl/jeLcc8VsYsMdq3C1+RtenoiQqiC8Q+95Ngi39a2Unogiwc6c+KJ0S1iRHtQtNeeKFV+IDGD91U7bofwDx8r0wj6GXA0/Veh7pUlVdQOj8Kib2faQSjciuf0EgJDdeGXBKwqVmLPkFOa0l/ZuyfKZxE4x7v3e5F++Z/QEYJRRVkOF0ymYVyZCKmEvN1bZh/+xCW5xNkSTSFKR7UIHk6M0V01bURL3RT347WFnPSkDA8lFAULUGq1nGHYIvoGWhSbbNHcGQL3QqWKkGlUTaONCnfSErC8orXjPGEezn9NiDyRRvfjzNronB+KV6eZNesznsW3qaRQeXubAz0RsQlsGxmTwruKj+6wI8vItQXvfjbfuSDJgklKQmlL4MNuEnl2RgOhk000E/5y16tcee0PqFZYcz94lybqAGxfKNfene1sQSo35/FdMP1jhR
 kmc1p0+9
 jLo1mWjx9M5Gw+obYv2HeL5JZ9EwRtdxjxxWZJfAn/ujhszVGzpyrek3Ua+/OkHDRjZHKsu83hFbYSvLqsyGMg5SsUMb9Nj3zTmx6JiacNM2ynAZgR8BnRG6paH+SFtzrpc3wc9XdQp1NXTJ26LQAnjjlkxkmwcX5aeKH1XnyXj/AHfA+Ga/eo8GBl+dDoI/y4bmPXhBa+/i8Z2F5QZtzGcSO4Zmx3Mm/Kq4vDWGwBBzfw4f4vEaAgyox/hg6JxDpl4g1EP3jl1GkBiEzl0zTl5BGAHX3QuiwrgqQaxz+kbvvmNvHNP86nnUDXx7n+/Tg+Rh9pwbN50tGRokd6lDKZCnCuN4SdzREpUEFto8iiMq0uhkDxfBynRhvmAjlT32MBKUQ9ExBiuJkGSOtU2v0N/1l+AQUw+P1RoJg
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
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/memory.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 67ee25215ca5..20b818bcdfbc 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2384,7 +2384,6 @@ static int walk_to_pmd(struct mm_struct *mm, unsigned long addr, pmd_t **pmdp)
 	if (!pmd)
 		return -ENOMEM;
 
-	VM_BUG_ON(pmd_trans_huge(*pmd));
 	*pmdp = pmd;
 	return 0;
 }

-- 
2.56.0


