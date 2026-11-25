Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AD06606A323
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Remf4O7f
Received: by kanga.kvack.org (Postfix)
	id 145636B0B13; Wed, 25 Nov 2026 17:38:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11D7A6B0B15; Wed, 25 Nov 2026 17:38:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 032E96B0B16; Wed, 25 Nov 2026 17:38:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3A776B0B13
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:38:02 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 44CF0A8B1B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:38:02 +0000 (UTC)
X-FDA: 85475105604.19.97AB151
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7A163C0004
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:38:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Remf4O7f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795646280;
	b=V8V1AhQHQx7IhQ4y3TBKC+duzIo/pW2nECL6rbqjMuyrbvlguHFBDvEL8c4yHO3AZeW/zm
	3ojVFFeNGTvdEef9FouvtSM74gG+NOljqGjKyKBcDuo7eKQX+Iw3iDvFTilGEyLO3UJajO
	3FFHttdZPJo6bLnnbYHeGb64Dmdy2HQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795646280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VjKgL3sFoPldgijp6lCpDuD+mopBcsgB/ttP+1X/jCk=;
	b=iMqNAK2BL3HBIDkzRRpQ2ndWhc7YCHjTUgiCSADm6J8NeFcU4+kqOP7RSy09W/T3vxJHFX
	YMeV7b7+W3ymoA++pkDEdUvQ3+13wFNMTnhMUtyAPCnQIfDmdtJQ+ubHSFTvH/AMlKSMWT
	U9gFAQYR07xCPzdVA+I21HF+NmNrEiU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Remf4O7f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B07143D47;
	Wed, 25 Nov 2026 22:37:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144731F000F2;
	Wed, 25 Nov 2026 22:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795646279;
	bh=VjKgL3sFoPldgijp6lCpDuD+mopBcsgB/ttP+1X/jCk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Remf4O7fx/AFusGUzQGfMeurEwsxkr3JAjv+utPVTBog7uXBrh9k8Olw0S4aBBWhq
	 ZMJr8AK1bKTrctfwD5XRfVhKpDhV7RyCR8E1x1xIwcvB61Ab4cw0rGSZ70ZgC8AdR6
	 6xJLwj2ERSj36Qh6Ucu2sFyMuwQVBG0fqIBxlarS4qmcqQvdGdSDV3X7v/hqXRfNky
	 Vhfpt0qB2IOsztafgaQR2l0+2LyC0G1q9087mysc9AGjAvNdcLk3sYD0lb9D8U1Z6p
	 UrboJ+kOxmYit4FP9EApxwoNXZr+jjkmcoeRU1xVWookI9Wj69k/JrjzwYsFEXGYg5
	 zjG06Bjo1tVbQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 25 Nov 2026 23:33:15 +0100
Subject: [PATCH 17/21] hugetlbfs: seal SHM_HUGETLB files against growth
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-hugetlb_fixes_2-v1-17-db27fd2f71a8@kernel.org>
References: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
In-Reply-To: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Jinmeng Zhou <jinmengzhou22@gmail.com>, Hongfu Li <lihongfu@kylinos.cn>, 
 Andrea Arcangeli <aarcange@redhat.com>, 
 Mike Kravetz <mike.kravetz@oracle.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Dave Airlie <airlied@redhat.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Gerd Hoffmann <kraxel@redhat.com>, Mike Rapoport <rppt@kernel.org>, 
 Mel Gorman <mel@csn.ul.ie>, Dave McCracken <dave.mccracken@oracle.com>, 
 Andy Whitcroft <apw@shadowen.org>, Adam Litke <agl@us.ibm.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, James Houghton <jthoughton@google.com>, 
 Yang Shi <shy828301@gmail.com>, Suren Baghdasaryan <surenb@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Wanpeng Li <liwanp@linux.vnet.ibm.com>, Andi Kleen <ak@linux.intel.com>, 
 Kenneth W Chen <kenneth.w.chen@intel.com>, Hugh Dickins <hugh@veritas.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Joern Engel <joern@logfs.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Michal Hocko <mhocko@suse.cz>, 
 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, 
 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, 
 "Kirill A. Shutemov" <kirill@shutemov.name>, 
 Sasha Levin <sasha.levin@oracle.com>, 
 Guillaume Morin <guillaume@morinfr.org>, Wanpeng Li <liwp.linux@gmail.com>
Cc: linux-mm@kvack.org, Jason Gunthorpe <jgg@ziepe.ca>, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Andrew Morton <akpm@osdl.org>, linux-doc@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2124; i=david@kernel.org;
 h=from:subject:message-id; bh=7MoiVxUj4TNHB3tVg+ZjfIFB8GSvxEg3MaoP8tyv0c4=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLZk1SjvLf+tbVQYWRgEJnlsbPsrAqLUZ7mS+OLfwP/X
 0xm0k3pKGVhEONgkBVTZAkKvm/w8uW62mo3PmaYOaxMIEMYuDgFYCILtBgZVgpIsu3W3CuwUPdH
 zXMxCa+e5KwHG49FdB72aCufc9ayipHhxDV7EeHYao7bdqpWu+INNpR1n3JbvdRCbeoWvSs1i3O
 5AQ==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7A163C0004
X-Rspam-User:
X-Stat-Signature: tj6hrj87ngoyf931fg1r78kz5eaq7nmd
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795646280-29744
X-HE-Meta: U2FsdGVkX1/TCGZbwv2TA9W/cN2N05g8E9Ap3wWenl7z6fDQfMGI7eu5QOOCo/8sLhwWBCQ8f615tNVjIKz/Js6hDZ5rv2/HgZlNhGu+OMvnrvEFUL1MmfVcJkGnB4cuiESrFaT4TQQnM2AZCkLTp4iGTXrVLGtWkhJc9HE7ePyG3Sxgo84rNwZLsGWaaTFcxR/Zeacflag7ZhybWjjqBkvO7iFzyRF/u6iflzjfKXQMbRHdvkFFwS4daMtyFLIch6MYocDPAfHtDeDR3/MxEvSCo6irRtP6EAT2pBTnVKwiolYj+KNG1nS6BXtSrQQQhLdu3UWl3hc993LYgppIrIMmb8z0NmQEuzL4z+3yIm4hVLnEzGkkwz5EcuFK6p9GgrD0MJbdtMxydSq1TsE2WBdSY1Rby8JIzRzUodha0HFl6YlQNCig3QO9D1ZkhP/RURl7bR+FuRs3IXbdFIL49lJZotAKWWBgv3ffO/x4oryoglsteyB++OlZz+SLPyVQWqbdsni3vp86wnpsaAgbMOcTfLL1ipsIfwz+U3rP42B8BXUYPPqZ5L09H/8rW3JZPl0IooD5aAXMcmvqDbrNvDbRBThKvQB4ZF0/bWcR26eG+n8CqfoNoCEyt59efxNxlUdMmg4/cxvC+O8gVT9LKzzLI2JE6TZsbmDIQc+I3XnUxAI8PUzBWs0GptbGKD42bd9nA/7N0xxXYd7c1ti35b5ws9JqPstlLIWkpdrthZTtfSSuUJ4Zv8AaXmt66G4tgAStUOlrmQzkF/WykPMriq9JTALhpUej0IP8dCBMr0y8XDHckkway0rmO4qmAwL6o6jLwI6WNxAnGjzx8T0WiVsjVkeY5v3PTQZKpUONa3XK6FU70+1+iusub4NlCMgd76J2vr8ld8uc4ryftMMvhStDXsYbl53ARlqMlB+citB2E5UY0RLWtZZ4zRrtmgLxa9eQiao1QQ8Y9lHEhSZ
 sJA9fSnK
 fxBB2un4OflDV1zlguzPOdFeGioFto5zXMeKAhEGW2EW7rfof3XnbXBUzCLfe2lFYHOygObYTtFLDhKH6AD9GxSzfiZ+Elz/4xqbyjBOa5J2fNkowMBg5rlG1zmin5I+Xr4Dm9y9xmFl37opRW10O5TyJYwwtNygBowP1wcHNs54Fi1TdJ2Audq5OR+IJo2uJC0zZJSSBCe61yIXNP3ouWyRIKuaGwLhr14JJ/FeqO98xKAZ3JnUfJKHaHlq5xuIJM9un0b0cvPV1XT7GYQSAznoAYkCRnO6lksPdtBwJeLpr4IgTGQICE41FiAlT/LXU2wIc+SN5MV9rBvMnjbhc9bLnzH8H9vaYlZuQ7r/rxnuz4VDx9xt5dODw/fJW3FgsZrBranHik/AzSNK2fvaqFwqW5GNQdi7Nn0+IZQkjdDMndUryny/sjp0aryKnPZcWKsIUGC7F84PU0YZD/Wd+Kdj5nQF+nqHIxEwIbKGWJImFMHFlnLthNUv2sAZ1gLfUd/JCrGZC3YAI8hSs70d8IDROwqY0Nu8qbzqh0MtL0di1msLwEUQ0g1tz7QNZQEi1OTITIq+vewwn/X5yaEp3C1N3dw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

The size of a SysV shared memory segment is fixed at shmget(), and
do_shmat() relies on that by mapping i_size bytes of the backing file.

However, with SHM_HUGETLB, the hugetlbfs file can be grown through an
fd obtained from /proc/<pid>/map_files with ftruncate() or fallocate().
Also, remap_file_pages() with a pgoff beyond the segment can grow it,
because hugetlbfs_file_mmap() grows the file to the end of a writable
mapping:

    shmget(key, 4M, SHM_HUGETLB)            i_size = 4M
    addr = shmat(id, NULL, 0)
    remap_file_pages(addr, 2M, 0, 6M >> PAGE_SHIFT, 0)
                                            i_size = 8M
    shmat(id, NULL, 0)                      maps 8M

Later calls to shmat() will map the bigger size.

Using /proc/<pid>/map_files requires CAP_CHECKPOINT_RESTORE, but
remap_file_pages() does not require any privileges, so we focus on the
latter.

Let's fix it by setting F_SEAL_GROW on the inode when creating it for a
segment. remap_file_pages() beyond the segment still succeeds, like for
shmem segments, but accessing pages there now correctly results in
SIGBUS.

This has low urgency, and likely nobody ever ran into this in practice.
Let's not CC stable.

Fixes: c8d78c1823f4 ("mm: replace remap_file_pages() syscall with emulation")
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: adjust description ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/hugetlbfs/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 0b96fdc3ad9d8..f1a8208ffc818 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1559,8 +1559,11 @@ struct file *hugetlb_file_setup(const char *name, size_t size,
 				    S_IFREG | S_IRWXUGO, 0);
 	if (!inode)
 		goto out;
-	if (creat_flags == HUGETLB_SHMFS_INODE)
+	if (creat_flags == HUGETLB_SHMFS_INODE) {
 		inode->i_flags |= S_PRIVATE;
+		/* The size of a segment is fixed at shmget(). */
+		HUGETLBFS_I(inode)->seals |= F_SEAL_GROW;
+	}
 
 	inode->i_size = size;
 	clear_nlink(inode);

-- 
2.56.1


