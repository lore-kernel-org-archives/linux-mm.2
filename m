Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FF32606A88E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VpsKHxX2
Received: by kanga.kvack.org (Postfix)
	id A18566B05D3; Fri, 13 Nov 2026 16:47:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E9296B05D4; Fri, 13 Nov 2026 16:47:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FEC96B05D5; Fri, 13 Nov 2026 16:47:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64D156B05D3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:47:22 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EAB9E80156
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:47:21 +0000 (UTC)
X-FDA: 85431432282.06.8B843FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3E465A000B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:47:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VpsKHxX2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794606440;
	b=3M0T+wPlkkFxvWFScp1/+yoDmVAyEK8tWL44+kguGnrwg0ZQYg8ULG8h7mACCts7lJevbW
	x9zDlsghdx6WldF3+Gf7ia3Ji2xuiI4igvcqcFBIYIxsd3SHmu69d0EeyVNsfP/510uzLJ
	0PYv4GJVYbhOpocL9UJSjX/jPbo5uEg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794606440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E4Aqk3iT1Oi/fEczmw1TcDEWRUX7zaDgOrezCzbiQY8=;
	b=tWYN9EwKJW5GQuQMRwxiPddkR3mTf3VnRg9pVF/Y3o/TxZDROrJ88e04xGb7bP2xsejmO6
	WR7gnKGeOwNXjPxi7AKicbHw3p5H7IYeclUyB0jUIyKAEfAaVdhxO0xkCddfjYqcqJLbiL
	C1kIWPWNx5Bxi5Z808phKIXuB1OM2fg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VpsKHxX2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B10AA63520;
	Fri, 13 Nov 2026 21:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6D51F000C4;
	Fri, 13 Nov 2026 21:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794606439;
	bh=E4Aqk3iT1Oi/fEczmw1TcDEWRUX7zaDgOrezCzbiQY8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VpsKHxX2AU+5/DCbWoy2fUQ+wtOkI+t+IJ/21DZmhIGF/sU3wj9+7HA633/W2O4Eg
	 4JWFxHgH7IpvZuk3bBw3jCWGjJcOoAGtA0ObLmEVLuEAlJ5u4YP8LywYl96wmJuBzS
	 BD2jqHZqtWs+CeaAMQ6uRsruhfKrEyjcegVW2pLVPmZMKhLVEMObs7qmKYBMBJ5Wel
	 SxqnlEo6cGOzPyOIn6/C8hTAXsN8HyVFQuV3WuvRrCaLPZoGqVcrRqk6/8l7DWUznl
	 twTHtxBk0359K6MfoZ4wGUxh1QnBpRIraPTdjSAcHc7Wcqlp4Uwroi4UaoptVEtYjb
	 OW6z3EmId9CRA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 13 Nov 2026 21:45:28 +0000
Subject: [PATCH v2 10/13] mm/migrate_device: refuse to migrate shadow
 stacks
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-mason-migrate-et-al-fixes-v2-10-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
To: David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
 =?utf-8?q?J=C3=A9r=C3=B4me_Glisse?= <jglisse@redhat.com>, 
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
 Chris Mason <mason@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
 Mark Brown <broonie@kernel.org>, 
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1490; i=ljs@kernel.org;
 h=from:subject:message-id; bh=d6aN2vWdVPIYwFHWomh3wqXyU/Zgbbc4Yfcyjsj4FMU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK+t/x0cw362LHnkgK3WJHNnKD9mqxhFxM1X7+Tf/JEx
 HB+1gXNjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEzkegPDP0vepb4v6oID7197
 sujayknrsrn/TViZvJ352LKgHe0nXn9j+CslJV9Xmz2hYEqWa9IagfsL3edmeMnfNmbXP+Zqsyt
 yPhcA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 3E465A000B
X-Rspamd-Server: rspam12
X-Stat-Signature: q6xn9psifxja7ydm3ra3tos4sqnz4i15
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794606440-835743
X-HE-Meta: U2FsdGVkX18cgTtWLlSZB5ghbwaegALQ+bqZjCUo/GZSQWUPWmAGDMtkJBYb53fpmaJoX4+qLvg7k/8lhexhYEdyVSqekkAO1n5kFQg0mfKZhfq5zhjrCss3jB4cD/xJadHg8pzWngdFc8WO8METqMcj75oMRab4foIDwNNdx2IL6YlEZn93BNGv3gFDglOTSUyzkDVhmQ9CghHRmkS7xm1MhXzXWv48n4tS22t4ZqQLM9I059yHfRheA5IelDq3YMT9hJ+kp/BSHwL9piyBPPOO9hqoPuWeyz7WTtE7q0vL8s2tWVZzL2Hbrgtr3oPHwSZsxZhX8LnRCsIRtlbZ6muwp6YYxHDdZSpdNsza+qRhK00HxSWhY163k+Fq6Myq24UKF/lioB9ZVd0G9aSmSMgfSI9o1l0LlSdDtWHWhhyycSy7QD5PEizKPpKN7Hptfx0j5yulV3Oj4MEhq7Nbd9I2U+CGzo7SCgqDrrQyf2389Ufu596UrW/bn71icYredAcZPu4G507P4yan8t8BkYTzTrWXFq1n4bsQVh+T4e04a1Px8BSpdyj8XfRhhA8wt3M/OZY4N+p/qDGBCiG6h8BffMFZPRimaQ+WLu1CEkNbQ+PUrsvbQm32NX4ie3K4Ltt6szDmpBKg5gQtJr1LL5witvmG4FEOkMBtsSj0IWCqsTSBLaNyfsGp1308bjZN8RXD+3CP6S1uIKysd0VN8QoAaQUHld7yxu9WnBh15/BZqDYYhrRO4d/uApWFPzV2YLuPUBo/B7DWQcQhvrV7vwwWz4hvchnS+fQCk9kIAJ5k9iTElW1rCWbg/yi0UwieKHSbP1RjLltsjLo2vwSYUCOJ3zqzc69Z5pd2IrJavz/XQ+PaeIF1ZzkVDVais3cpwd2ymExdbuntCDBt+UYqnOisiVaXanGvNiw0igcylDZlGR5CrsXvKBnoiepaKtX+WDgSoCeaVCL4R1WlB1R
 52fFq5lr
 tHOPj8klQMkUbn5283dVTOeE1fWq2ekLGMfVLW4cesLXPdRNNRwARnq0f1zuLQ+Sp5hsPnTxuG7z7IefonDS/9XcCVV7iDMbtg0qANHxQc+LnM3oaEFGC+MYH+uUZJRqKq1IpeCEDbqN/FdNvRbsZF5tEZhlJt4rqy2lP2xvo3BhXawanOL1XG98FSIlnNndAlX2fhqUg4/OANHKKGZohXfKgt0y3T+bNNRgPkW8TKpolOjUglCIVLMYug8u7ZH2vmz0RzvU2wqvHqFgyYIWkLUQkBwXsl5AQ+ygQuJ7/Xe/rPiorsIwajIRWGtrhfsf4OkFS6iCick9BQtN2QQRMvw8PrFV1kXDRU5ZDtzdrUfUvvMqy3FxDCD7J9c1zkF3sl6HPCm6m3fAPlY66+0P8brPPqF4DULUmDE9yMkOwQYfnCR38x4/s4jOnEyy/Jfw9wPNbflg2udQb130KkgmYlr6JBvrzECKBlxBkq0ThTKEOlFQA2f0ZxTkPvaZsy3HmheS+NEUcvQSTgpYFwF8cvfWHZCeWLjgqI2g9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

The kernel blocks ordinary writes to a shadow stack. But pte_write() is
true for a shadow stack entry, and migrate_vma_setup() sets
MIGRATE_PFN_WRITE for each page where pte_write() is true.

Notably, the nouveau GPU driver takes that flag as permission to map its
copy of the page writable for the GPU, meaning that the next CPU access
migrates the page back into the shadow stack, and the page then holds what
the GPU wrote.

Be consistent and disallow this for migration.

Fixes: 54007f818206 ("mm: Introduce VM_SHADOW_STACK for shadow stack memory")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[ ljs: removed unnecessary comment, refined commit msg ]
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/migrate_device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index b4660eeb975a..e0bf6afe0768 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -759,6 +759,8 @@ int migrate_vma_setup(struct migrate_vma *args)
 	/* The migrate_vma page walk has no hugetlb support. */
 	if (!vma_is_mm_backed(vma) || vma_is_hugetlb(vma) || vma_is_dax(vma))
 		return -EINVAL;
+	if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
+		return -EINVAL;
 	if (nr_pages <= 0)
 		return -EINVAL;
 	if (args->start < vma->vm_start || args->start >= vma->vm_end)

-- 
2.56.0


