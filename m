Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A65E5606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 14:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=T9R0fQab
Received: by kanga.kvack.org (Postfix)
	id C83FB6B05B2; Mon, 26 Oct 2026 10:31:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C34206B05B5; Mon, 26 Oct 2026 10:31:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4AF86B05B6; Mon, 26 Oct 2026 10:31:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BD7C6B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:31:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D08616078B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:31:10 +0000 (UTC)
X-FDA: 85365014700.13.1448E3F
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3C9F414001A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:31:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=T9R0fQab;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf23.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.172 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793025068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S2aF/nJPcL1L7k4kule6+RDBiZtzu5J4Md55u9FTmQA=;
	b=CprH+P+/29VsBZ/5iNNVrn9rgmTUTPHNAn0ED4pYjYrn39cCngTN+8p9rv3S++Q0NeoNux
	kK2GQi4C1g66k4Hub4J9W+83l6hlS5ewM6qVDv6EaFIMwCiX8adzbzRinByAOE6sT8FeoU
	mz2coHex/q/qsjHAzdCRDLqtvd9JZ3M=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=T9R0fQab;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf23.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.172 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793025068;
	b=tJvIQwolRUuXGtOwiDFhbIbqyNEkHWxcUArgrnUwwHELPndt4/5pbW6aqiPLt5jzN7wju4
	FPSlUqJgKwRbMDsJTU10lDK9H9CMs1lS+lyrYV8D4lgZ/cvrxmElh9G+LPfgAV9PHC4zNm
	+Urq7PEhCDkpoM2vKmHa3vzqeSaShiI=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2e8fe8e343fso17855495ad.2
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 07:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793025067; x=1793629867; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=S2aF/nJPcL1L7k4kule6+RDBiZtzu5J4Md55u9FTmQA=;
        b=T9R0fQabBrt8POqlFVESWowwS+3CJRdroYF8OHb58IwkUgTz/bdRsIFS6AS/HTmmbl
         J/hYnJ/w4i1N2MNGXx6++B0KGRvAxp307xJrbMc5EZ6cKJ50JRjZFHjCIRxgZ0g+tmAF
         r1sGKjpqmLPVOotk+b7ckNdNNFMUrDyEcue7A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793025067; x=1793629867;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S2aF/nJPcL1L7k4kule6+RDBiZtzu5J4Md55u9FTmQA=;
        b=H0kM+z9Ah3rUoA+LGyuHcHqZ00GRXAv1ZGX6paKSP4x1KHi96ScRje6LmiaWbj13br
         5wQUBja8FlBHFZC+6/l7rJZ2W82LnHdEut0bisNuVRHjBLE+6NsDFC8XC1uhPK5bMFUR
         gR69bi4GqpPUpJTOilGN3mkyyPE5zBVxzgYd+L7KTT5ooVnOn71xl/SLr5wUZRZjE1Cc
         zk7ATtGqMJY3Kd6QEgLSB4jMFuLbt32H5GzsPPxukf2YQNKqDM6R32FxxHr1xAwsE3Qw
         3YqB2pFzywEvP8C0NnXa/XZta6LMjaygQtMQSExyDgg1g7d/5YYvb321Atc6TSfXstp3
         YGZQ==
X-Forwarded-Encrypted: i=1; AKwUvBykHZpYyMs56tRujg60tyu/6TXXUGZ3vU5JM6xylV/hDjt0dwhjRjWTnW5iQp/8ICMI5b0hpkytCQ==@kvack.org
X-Gm-Message-State: AFq9FYITyiT4eRcDKHayvvU9z5Ea7er1KZUhsBbmk9QSAvWB2uHDUims
	qy/06wY0G2AsTISHNbgOKar7DyYD2RkYnK5OsLpk3wpl+xg5qcQdE7MkoAFWNWhG8ME=
X-Gm-Gg: AYBFou0g3JDA71gtqRR4MWophFMIsbgNd1ieoz6hqTZrqURpaRWunGNTP3JfLcacD6z
	NmjGl3UIIdI6RIr6gX/k+WWBcEnj76S7T+gtVK3CJyL8tqaOW9qzZTAFaFjb/VROt5Cgyrdb1j6
	RRxfifl9omCrat/R+0wSI3A6gEV+sgR/oEFh13m8qGvmxqNJsQ5R/KVQTM94pCpczOO+J8T6EKA
	dbVLL8IkkfbWXzToFm0OnlO4BMqvy+UMP7yjcI46KUN7Yjk1TmtO4q71HPhPDvD+kIKsVIFvHBk
	/CfDtdYTYGCYezfBVVtHr7QzkVXsae+KHksASTG3Z9UcyZK674B1qWOpQNGCKR+bgYhJT2iynWU
	1ENWgnDse35xWZtcrV+4ilGM0AFyyS4pBj4/85vuCamcwqEe6rK2SlZBIe6+v+cCQUr1y7ay5y8
	gJvs5wyE/d4hRFZ2Ey6oVcJrQOzC5jAtv9/3iN1Sy64+LNTrLGvcWOT4XC0lDkGWdX7IjE4uunM
	wfY5vx6TLDmHxSl7sEh8U+4tINu00YMZzE54NXpU35Et5jqtvtFSxhdshWvR9TbGpIr18iHGcct
	+hWeH0mIZmLxlBQyQ5o/s8XDWB1Nm3NQ/KrgdikEZV3mN4xo1zX7REH96GTmzzJ2yZ+qOAAZ+Pd
	Hy04quWZOk4D99A6X2hwvgq0=
X-Received: by 2002:a17:902:e947:b0:2e9:4f21:91ef with SMTP id d9443c01a7336-2ea9c876333mr51977345ad.36.1793025066909;
        Mon, 26 Oct 2026 07:31:06 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea9af332d9sm17635845ad.11.2026.10.26.07.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 07:31:06 -0700 (PDT)
Date: Mon, 26 Oct 2026 22:31:03 +0800
From: Chris Down <chris@chrisdown.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Vineeth Pillai <vineeth@bitbyteword.org>,
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Ying Huang <huang.ying.caritas@gmail.com>,
	Kelley Nielsen <kelleynnn@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, stable@vger.kernel.org
Subject: [PATCH v2] mm: Make swapoff interruptible when unusing mms/shmem
Message-ID: <at9kJwdGkHPsWwgG@chrisdown.name>
References: <ar2YlFYjYUZ49ZA5@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ar2YlFYjYUZ49ZA5@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Queue-Id: 3C9F414001A
X-Stat-Signature: g666ug6hcqficc6671asknohczsri8dn
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793025068-515669
X-HE-Meta: U2FsdGVkX1+pNU/MU4CFgvX/eIRWL/iVK4dsNlxWCECPnpadw4YssqFGxvcsYPKNIM4524CpHNHr9hdPJkB3ftFA0tXfrczoGUsQDNZDaARM5axnLh51H14xlVp2E3+NOV5r9EEKZy4AcewIUb5wkPOFUGsR7RSBsmxWDVg/Yr2ABoo0I77dSpRnZE8OyckHF6Ud6CppmXKd5ejO9mve4nG719FSi/7A0jW9kFmdOfAYukYJ0D+M89ehpokJii38fMxHYTrX9WsRbGCW4XbASFyzINGGx8OEjyiFwPeVY4T5z1QUHk52bd6ygY8FLAh6FX+51hrYbTRWuquJR+ioeWqDcjQlUe59a70ngKr4aKkUH/r4wr+FJC+KhKQddqaQRUuN+UrfsbOYKdo0+yqJxEbX7P5CPAbOEAITy9jGDsE65m9Dff/bEzQ4GTlRiyX0BZoh4loTQteVz5Gp8Dl11nvIZH61NKGALFpFKRq2kox96+l1jGvf3A446bTmNOuzMk+osvM7daHFBWQ8pHmhAzJ6noEwKWlPutc40Z0QNXTE0BDCe4XDIePuQ0zOuUdwtqRId3+AKKOdbFHPiRRLqCdFCCzjnJPhUPgHmFJZnyuSXmP2LeRILPrlzNmEXkCdL5ELKKghUROypBPQpHZEy7dsY6dmUf2M1ZPKFfw7pdHmFPfs2ki6I9HPA5YLArZTW9JFKTyygYUzSgz0Ul7+GUEPreZA+qsDMm2WeBbl8wB2cqV8Ydv8tks6U6Wzwdr7poq95NWBV5D998IruRx0PaouUWfIeJ9Bu2cCvaysq8FvKxNSRsfi73cLyTPWC3dLx14xtpoIL8m4F0BhT1egYV/5347UKLpxjH623EC79MLEzDwh4dUmwgH4S4zTPXCKkeb+MvGK/i8ZJrBa/MgszK1/ir/c/HatBhkrU3VcjwV1mMaUT+3rc01+WXulpUS2EkOhCj0j2gkGO49VwCn
 HhS4LUk+
 Y1gpKH/+uz/rbUn7H4/JwULilo4vTBdsqWQVfj2Pf/IXbnIKTidgAgGzaqR8h8YH/oWnMNosiAEHo1uhDzGuhJyLwYzjTKOmimUmaxHnq1UYZA8iJZm0H+hCD1KDBd1nQyd2AltrEBvYkPgll8Z+LNwFd7iqh0TpXTt1+S7KGAG3eDRAxAtgwtNXDL/DqsqOB5xEijlPywrJGwe3roNVy/GrOJA8EiZ8jpquaXziXO4nuo8fpXptJFV6Re9yausMo7CpSLoXVX1cNkco6nl7fNG6y94qGRYxv9bUx5uxc6qXBYUT5Ay93WQMK+Mx842k93mLxjDhf0LwQd/iafg2YRhaFe9lUvZGd/ogf4urRefRMmM2B8qG/ZTx57nThD/MrESp6T23SG9kCyzJAAOFQFYvGSnp9DxHOqhuLida8qC4yI7IBJtvcCqMOz8vPBT8x5hA4+I87dskNNUIHUEhi0WRFlqV4mmtFzBGOgRN0P+t5UVDQ5a+4Ew/rE5YjQCzyp2EFUVT+KxHuk719iDVMpgFKDr+hqqbfsMckyIvjIjpJrx51+RZchLOxIt/V5E/evWGURJN1RdV9NtLF2ojA3cjFCpD1Cjhcxu6FbDh876Q1Qj3MwZwedX9U0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

try_to_unuse() only checks for a pending signal between mms, and
shmem_unuse() doesn't check at all. That means that once swapoff gets to
a process or a shmem file with a lot swapped out, nothing can interrupt
it until every last page of it has been read back in.

Just as one example of where this can concretely show up, freezing tasks
for suspend or hibernation has to wait for swapoff to notice the
freezer's fake signal, and gives up after freeze_timeout_msecs (20
seconds by default).

Here's a facetious example where one swaps out 2GiB of one process to a
swap file on ext4, starts swapoff, and half a second later tries to
freeze with pm_test=freezer. Writing to /sys/power/state then fails with
EBUSY and this in dmesg:

    Freezing user space processes failed after 20.003 seconds (1 tasks refusing to freeze, wq_busy=0):
    task:swapoff         state:D stack:0     pid:3175  tgid:3175  ppid:2955   task_flags:0x400100 flags:0x00000419
    Call trace:
     [...]
     io_schedule+0x44/0x70
     folio_wait_bit_common+0x1ec/0x3d0
     __folio_lock+0x24/0x40
     unuse_pte_range+0x2d0/0x348
     unuse_vma+0x158/0x248
     unuse_mm+0xfc/0x150
     try_to_unuse+0x104/0x3f8
     __do_sys_swapoff+0x220/0x5d8
     [...]

The same goes for anything else that wants swapoff to stop, like an
admin hitting ^C in a panic, of course.

Prior to commit b56a2d8af914 ("mm: rid swapoff of quadratic complexity")
try_to_unuse() was driven by find_next_to_unuse() which checks for a
signal before every entry, so let's restore that behaviour.

Just as an example of the improvements, here's how long freezing takes
in the same test while swapoff is happening on my computer:

                      before                  after
    400MiB anon       8.925s                  0.028s
    400MiB shmem      1.639s                  0.003s
    2GiB anon         failed after 20.003s    0.011s

Fixes: b56a2d8af914 ("mm: rid swapoff of quadratic complexity")
Cc: stable@vger.kernel.org
Acked-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
Signed-off-by: Chris Down <chris@chrisdown.name>
---
Changes in v2:
- Return -ERESTARTSYS at both new signal checks and at the existing
  try_to_unuse() signal exit (Baolin).
- Request stable backporting with Cc: stable@vger.kernel.org (Andrew).

 mm/shmem.c    | 4 ++++
 mm/swapfile.c | 4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index fadf23f9e21e..13e0786436cd 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1742,6 +1742,10 @@ static int shmem_unuse_inode(struct inode *inode, unsigned int type)
 		if (ret < 0)
 			break;
 
+		if (signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			break;
+		}
 		start = indices[folio_batch_count(&fbatch) - 1];
 	} while (true);
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 254ce86fa923..0f72a5b23a3a 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2689,6 +2689,8 @@ static inline int unuse_pmd_range(struct vm_area_struct *vma, pud_t *pud,
 	pmd = pmd_offset(pud, addr);
 	do {
 		cond_resched();
+		if (signal_pending(current))
+			return -ERESTARTSYS;
 		next = pmd_addr_end(addr, end);
 		ret = unuse_pte_range(vma, pmd, addr, next, type);
 		if (ret)
@@ -2922,7 +2924,7 @@ static int try_to_unuse(unsigned int type)
 	if (swap_usage_in_pages(si)) {
 		if (!signal_pending(current))
 			goto retry;
-		return -EINTR;
+		return -ERESTARTSYS;
 	}
 
 success:

base-commit: 0c06cb3fccd831787a8e46c929d6c5bf6ea22652
-- 
2.54.0


