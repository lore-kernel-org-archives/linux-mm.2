Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B344CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 16:24:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4247A6B00BF; Fri, 22 May 2026 12:24:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F44E6B00C3; Fri, 22 May 2026 12:24:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D1EE6B00C4; Fri, 22 May 2026 12:24:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC4B36B00BF
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:24:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A920DA075F
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:24:41 +0000 (UTC)
X-FDA: 84795579162.11.7D90D5B
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf27.hostedemail.com (Postfix) with ESMTP id E914440003
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:24:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=whYG6bQa;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779467080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J35AS/PULwEysdWQSYhJZ0mNgY8vYVr+6J5F9KzoNSM=;
	b=08zHI9yWfA86kf5dHns38EvOcawnrQ5KEXITg09Xv4E6bbLUKoipVwjxQcmsZgM2lvCgGY
	pf9+oHoXMrtT/FRnZKh1scmtAH09IAmOcVsvT0w7vRTxjveBrXQ2KEjUxAdPH9QGVVnXP2
	rlRdorbkgLaqsBclwTwqE3lAJxWX4Ek=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=whYG6bQa;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779467080; a=rsa-sha256;
	cv=none;
	b=JchBKeUOZTkSJ46IZax9XMj7zclv0gZSgKAYSmGOq3kJu637iJHqDU3I9CFWAklhPpD4LN
	7xlDHtxgr+jJJIOMiJEXRBM4Ki5q96HZ8DyfN8UPd80cywrE7JcmjzKl/CZGR2fqbKkJad
	L/CvkiGYy1oKmiE6/tOPelchfGFdIFA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779467078;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J35AS/PULwEysdWQSYhJZ0mNgY8vYVr+6J5F9KzoNSM=;
	b=whYG6bQaTpfWs6obTGhdUQR1ElLBtgqngR3UbASdTiAFG6Wc2nX87aMPGwETobOsX6f26C
	dexgRB/nobYzJ4JUsS2zdrsKlP+2GVKzSYZh9DwWs5Q2kPahX7eF9yZVdumz7mNxAQj7Nq
	mVVL62IK50Y4O6ziGDjKQYWhV4694iU=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	willy@infradead.org,
	ryan.roberts@arm.com,
	linux-mm@kvack.org
Cc: r@hev.cc, jack@suse.cz,
	Andrew Donnellan <andrew+kernel@donnellan.id.au>, apopple@nvidia.com,
	baohua@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org,
	catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org,
	kevin.brodsky@arm.com, lance.yang@linux.dev,
	Liam R.Howlett <liam@infradead.org>,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
	npache@redhat.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com,
	rppt@kernel.org, surenb@google.com, vbabka@kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>, wilts.infradead.org@kvack.org,
	"linux-fsdevel@vger.kernel.l"@kernel.org, ziy@nvidia.com,
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
	kernel-team@meta.com, Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v5 1/2] mm: bypass mmap_miss heuristic for VM_EXEC readahead
Date: Fri, 22 May 2026 09:23:47 -0700
Message-ID: <20260522162422.3856502-2-usama.arif@linux.dev>
In-Reply-To: <20260522162422.3856502-1-usama.arif@linux.dev>
References: <20260522162422.3856502-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E914440003
X-Stat-Signature: 586y83tg5nbjna5nxij4d9a4npttek54
X-HE-Tag: 1779467079-115258
X-HE-Meta: U2FsdGVkX18sRM6ZSBL2Mtu0h6lZUwp5XLeto3+yuIy/15ZDBICvl+C6mZyxXnA9UlmlLtBAG9KYqsXfjgXMzx5WI2ZdhRjImSAHffNoqi+fCKRVRDkofIbVU0mRq+fK1HvXxr2Z+JBPN4+XfpCx9jh5za9nyQYN6kZwHkIl9Z2Ri/yb9BScB7HuITSMPc4I+8w9dDHxMciQPi1mo4hVrtdWY6XVYHeqFMYDXs+91vhdZH/ygeqVP+JPRWamv4jwIBF1eeYmvFnCFdrA43DPqCcIKQO/w16LXzVIN/rzUC42eQPxI3KTYeWgwLLCwFRrE9hZ3koZrye7NQ7TdzostV9/nnOgd5AmCMCPe5qc/Q+70wp3wwgo5BvzTaKUrU2QcPci0F2oSUYDQ69w6J/DMujqZz51Ni36mLlh7pNK8nAO6riI9cX00E+8kXxZm5auGP34BAtX0aAE22lmLYoG/3q+Rh+BOv/KyQF2wqlfjsdZRM2dmLlWrQqszvj+lxIZ06TqNf1QAgN/Tj7p7uLIzsZbPxWeVi/copENQ6ARbpVEif902JMfv59RqcLGYESA44hAC+MY97Qdx6Bw3nADnhhaB+1867v6OSYCsM+zHPFEOIH5myMT5l+mW6U+bIXnTenUYan9UfFtu/RSMQTvgbRN3+3eas/Zk6rO8YNsEKRTMn10hDq0K+w4DfoulZ2qFVWtwtqgOA7PgKvFevqjtNhM2zlbrBa2KJcyLNEcAQYDkmn0NpNRdWeuF/AEIYHGXf2D/QU4a4AYJ37YT1+9zJE0QiKG0+DmLwrOd91Oky+GR4Q/gowO9CKLRoCBMxWjA9tP5K/rVPKtFpqIi7U0aLxXCxZ8G0miKJLwFVBNUa2y65gdRIAJxS541LMHBTHyBFCzb974pOF1KOIdmfumr0/mP8y6yRn8ZTbvTjUqxStGhxnh1zPmsKNZouy0FddH2DjPGCaeSaAsZguA2lF
 xo8dR+3z
 C2tl8hyhWcWgu7z0A7N/chPRK8RVqzSrZfHxScuWYJWEqD+Kjcb1OgbD83jmFphcllw1d5dQXVSokN8yVSIe+AAb0OfrsoC5xd0lvC5tANLR5/Gi4JdplXeo7leC9ChQyrPO5UdswDr+nzaBZTK7R0AAWME6Mv7DoSmCbeweJNwkWAcgwYZR7y4qOMEAXXiRQ6DaPLs9cMzwNRpolPdNZcT1JO0EVDNof9lxcSj2HLJYo6IfcSorE+YXVjomKXYFpz1fojWvAbbRSrlyVtzDVOLgq65M2efPJ51bQnrfNqZT7+hz9wGytEaLNwhzZVE4W8xHcYB0+LwU6qM2ZgsKknSGD/eAJVS72Z3kkXnS2DcdFZZTJG1d3CM5LLtVEOSPKt3KnQa/mKnc3qZQwzFG1qgjkNMpagIJyT4qh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mmap_miss counter in do_sync_mmap_readahead() tracks whether
readahead is useful for mmap'd file access. It is incremented by 1 on
every page cache miss in do_sync_mmap_readahead(), and decremented in
two places:

  - filemap_map_pages(): decremented by N for each of N pages
    successfully mapped via fault-around (pages found already in cache,
    evidence readahead was useful). Only pages not in the workingset
    count as hits.

  - do_async_mmap_readahead(): decremented by 1 when a page with
    PG_readahead is found in cache.

When the counter exceeds MMAP_LOTSAMISS (100), all readahead is
disabled, including the targeted VM_EXEC readahead [1] that requests
large folio orders for contpte mapping.

On arm64 with 64K base pages, both decrement paths are inactive:

  1. filemap_map_pages() is never called because fault_around_pages
     (65536 >> PAGE_SHIFT = 1) disables should_fault_around(), which
     requires fault_around_pages > 1. With only 1 page in the
     fault-around window, there is nothing "around" to map.

  2. do_async_mmap_readahead() never fires for exec mappings because
     exec readahead sets async_size = 0, so no PG_readahead markers
     are placed.

With no decrements, mmap_miss monotonically increases past
MMAP_LOTSAMISS after 100 page faults, disabling all subsequent
exec readahead.

Fix this by excluding VM_EXEC VMAs from the mmap_miss logic, similar
to how VM_SEQ_READ is already excluded. The exec readahead path is
targeted (one folio at the fault location, async_size=0), not
speculative prefetch, so the mmap_miss heuristic designed to throttle
wasteful speculative readahead should not apply to it.

[1] https://lore.kernel.org/all/20250430145920.3748738-6-ryan.roberts@arm.com/

Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/filemap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 5aaba0d3e81d..f45a1b74870d 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3339,7 +3339,7 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 		}
 	}
 
-	if (!(vm_flags & VM_SEQ_READ)) {
+	if (!(vm_flags & (VM_SEQ_READ | VM_EXEC))) {
 		/* Avoid banging the cache line if not needed */
 		mmap_miss = READ_ONCE(ra->mmap_miss);
 		if (mmap_miss < MMAP_LOTSAMISS * 10)
-- 
2.52.0


