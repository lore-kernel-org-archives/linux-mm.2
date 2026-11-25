Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36ADE606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=maQKd9VX
Received: by kanga.kvack.org (Postfix)
	id 466206B0979; Wed, 25 Nov 2026 05:01:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F03B6B097B; Wed, 25 Nov 2026 05:01:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26A616B097C; Wed, 25 Nov 2026 05:01:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC7756B0979
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:01:14 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 173141C3FFF
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:01:14 +0000 (UTC)
X-FDA: 85473198468.16.74620A7
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2CEB4100009
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:01:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=maQKd9VX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795600872;
	b=CRSI5JjQa3M+pqiM6cq5ZojZ45QBqeLObWQ7d7l1dMY0rq9Axd/jwQX/ZqV6EXnQTJyIOr
	2QT8f3SQaIHiFJJPLdh1phkqJE7aKvRAIig4gaING66ncZY9QWl53b2xQV2beIvBN3kcou
	UkKqIW+Exr6oHsXU4jIboWNBGBRa7U4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795600872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gIVwXBqoIbWsBwcLK9XzDcXEsdYI5cY24iYHrBHq0Cc=;
	b=1jY/5h07EnorS66tHMt3DmO9OZ3ffT62lJfcGtspxf9ggyHediXAOoAJkCP3LJobxQXkDY
	MqfsEUBH/3WZq02lfP6s6FumLA0SDe3TvI/4D8hrNHoiy/wdjxawNnv0fFZC6Qfkfo8X/L
	ezQaKMV3vMsObvqwyJEbA93Wf55FBuY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=maQKd9VX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a1fbd52ab6so37629395e9.0
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 02:01:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795600871; x=1796205671; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gIVwXBqoIbWsBwcLK9XzDcXEsdYI5cY24iYHrBHq0Cc=;
        b=maQKd9VX9+FGgKD5pmkOGhMsMS/1QtWfPwkUm51USUQd/0DgOGQcT0/opwKL0XmKmK
         OXZa74fcOq3D/fnfBxfiRruqh23qGgNQCgxa/aLdEJmvO1KpV96l4K/p5DV7HJ4jhKfL
         cPCucvbKbwcxwgJd0e4BXqmjj1Ss89GG8EqJcuueWwLu8TnYfQhFYX43YjTs9ajMaxV5
         fLmy7NSbLHPOwqOqvK0bS09H1tnpVenryf3c/9Oo6fBBH0Fsh5IyPooH8UG7HCTlSaki
         gZtWJIgTkN96dZoWfahT2G2WxvgrHtSkAUd5GNXbjPo81jUHNXidhuk332bK6QZIznfM
         VlFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795600871; x=1796205671;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gIVwXBqoIbWsBwcLK9XzDcXEsdYI5cY24iYHrBHq0Cc=;
        b=RYePoHYz/6oBE+E5J1bKjS6QEn5fistUlQRQ5Ewd6e114JUoSd6RxiSOpkZ4CMDqWb
         dpWhFCPtAx1nJNVG+PdQfiVln3fZNbHFDVQYTOmljXd/kniswM0SWDNfyX9sq9r2XEcU
         ouKeWPCDIEn+8yF7NTzjS5xl5i25HkT/Y5oNLcFllCWfPfu47fOe7jmf4MxOpnhH9ON1
         eWt5gV2oxutlID6OZM6eBgKKwHWulW4WhgDgtGv6TclkmOrCl0Pb/tYyBqlwIkdeb4yg
         UD9Vug75/nmgL3Eoi077qQBalHkDzkSIQ7iSWxF705HcmwJju90VGqXZeWZrCKCqacmD
         AztQ==
X-Forwarded-Encrypted: i=1; AL+hErH6mbgMUTiwjKTW8/3aq8GknWNi+OC+yhLdTITqqTZLL/Wlsfxsex1NUY+YR5LVdUVEE6Cj7qYt/Q==@kvack.org
X-Gm-Message-State: APuU4Z/b1aIJSPwNWINXafczBg3t7Dav5GQxwWf5708lmDh7Wibb+vFO
	IK/yeU3d8Xciwfrrx88CVc2O+ObAS/4dylvFqcrqXg3MJPUPWAV3rRNs
X-Gm-Gg: AZFdTZfB3w1+8Pweonps1Pkk5lM3JJX4c5+YTW/J+Isr1qgDAHiO1Xyyvr8irQP5d32
	RhgNZrWqaphXaqdAqAaLt7cAUmZJkX5Unspnva0P+kazNdsYNVMHioNI0DhKUFwkWD7NQR5+x/S
	ioqDD6UlFnsfcSPIESydLwLDwzx8/QF4Tnt9b6eV5mzF9yCqvYoAoB3GZ0LQDcRRiThBwV18Trf
	Ta1+b9rEdvagIjwG6IYOgFIOY6TCd6lNXjH1TtA16h1KOMHCVNYrjKVbKzRiZTuusXltWFVBxPn
	SIkYL7Mff/rjRg9JWaIWALSfcSOsRBYYpb0NXHz2K5DfGOTV1LTMFTpd5UPxfWdsJk/gczlutgw
	YmW1eieDQA/gLQr/3rFh/Gettv8U7i9Q9kkZtnySYf8iIjkHVKAqO8XEGd13AMej+YyzDgzjxIn
	qUoQMqCxmEuF4A1jdFqo4tfgJguwMWtqkVRT7U55T/izNV8ovOaFp9T7cIocu50tJfkpJlN5/Tx
	4ucmQv1b7BXlYrTgVVrhyMgNeTAfvCsSinaBvAWZeeHUybb/PdHcjZtgiRYqOg3g13phhMyTPss
	rXY1PF2w7w4ziA==
X-Received: by 2002:a05:600c:34d0:b0:4bb:6a5a:7839 with SMTP id 5b1f17b1804b1-4bb889428eamr344330925e9.34.1795600870499;
        Wed, 25 Nov 2026 02:01:10 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853a1e8bsm423898125e9.9.2026.11.25.02.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 02:01:10 -0800 (PST)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	"Zach O'Keefe" <zokeefe@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Rik van Riel <riel@surriel.com>,
	Song Liu <songliubraving@fb.com>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 2/4] mm/memory: don't allocate in finish_fault() with the folio locked
Date: Wed, 25 Nov 2026 10:59:45 +0100
Message-ID: <20261125100058.15200-3-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125100058.15200-1-azpijr@gmail.com>
References: <20261125100058.15200-1-azpijr@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 2CEB4100009
X-Stat-Signature: 1i3d4ec4zyhif3deapmk6u58aryx5d59
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795600872-881009
X-HE-Meta: U2FsdGVkX19D5XRGsU7tr8374Y/GpyDUXjLzebnXerhjM7OxhwP46gu9euWjtCrIRxaMEn2uN41xaXjy8WfCX1DKByFbDOU0f3GgxZvfUq3sM9c3N69D/kPz3jy5ukfNSnpe6gSgLkpsCFJUdoWhwY1i/f7qQFsRz8/VI32xzM20Z8pgJBGxinwh4QTuVPvPsX14k/VsVnur11OtvLH0y/7IG13w8Kspjjn9QObab9AkZnFoUpQa0v2nCYvXac7h12LfzPvM8Z5TAa++pdO1crDzl0C5oIBoNvP+Mfky2Cl2xhF9HIDfRdeG6BB7064MMnOpMlMzmbWo3jCbqhi9fAxWlO2hCmX58lGqlmc7lBscOrAc71qvLjf72aZ+NAhtGOv23j6osSoA0YwJg2C53iXFsZLjOTJc9N0/IwqtSQyJ07C/XKWqfkWdT5JRJ280QoNzMPPIbZgXiFTGyH7JpwKSvzQg1PSc9e3kEOXip7wEZILrv9dzR2pMCpCh00k0hZwjdpG+3lsydqFmeiYNOY/jzfwXA541rIQ5aBgu4L4ZgxS1QKh8McpRFoETrTnaehQKrGCnqsFX5ZdC/1NcilimyHAYtvoNvuxj8oYdYfDShR6AqmoM8WhTZ1jOVASLobQT64FzgEXqAU2DZeU7pBSbJB0RTugw800SyI7Pea48LZx2mYai4nDb9ky7cHq1G9hNgyF5dkSNpXCCSAhA5OeI4xvArxvUPbck+K1VllvLNHXhGq8ggGx9g4ucUV16lBjiI3GH1L96XqZ5lFMZ9QKzqkx1luWK3lq2r1mqOxQLZKD2YsDZzNRA7GDToH6QtMHY2cQwzYS23ZQWznqQXmFTBMsAWn+tjuOp2JsgXR2qGQTERbIgQvWGx0Oi11JlH+EAmkKkw68UJXu4iDi27yeAbzUisLebxuz70Btpz6qRJoFMX/DttUdx8ExTyN9y2W01lokO+5NUs/ZJO8g
 j5O+Okox
 YsNRNdRt//WlBWTx8rv4fbNNrGFWObrzfcnIU7nIOj3zHszYPmJUV1nEATfOvdF6b323AzdBEdF8G43WwJ47mB6fmu3kiS3I2bpMxzE00Mg2Ub4KHdZYjHKImdYy/vQTl9GmK1rr2g90JlE0Ha+qHDYyeM6LupnPi2YS/Myn8JhucqzyjEl3R2kRHcBQuMeSmzUqnrgXqzq7lje+sl5kkOHRa8EjRAMjlAAy8Ipz+4PMe4gHiB5jYRxr6hplMfq2lfK12jo1FVU6w1Jg0cfZXJP2tCPc1/rMYOwRVrjY86XhCztx3ecUDvUNQXtqNiSFa2QhGTwRMPDBPceb8GsRKx3AbqKE87SFCLfgxH223J5ZFZz6gH0x5hkTuDFDdXWzOJqp8NkHX9pY9bQaQEFFUHKubkRrYbturhXdimzpHT9sFYd2fcBpFTV63NW4/zKEIQNcqF7bYfuJ7bVNkVc8G3t0Ooar5wGuTFk8GHFkX+jCKZs3pwKGxvoH+9SsI2pFTuFldONW1g/GassEk/p8YOOosPmgcIeKUKR6F/877S+m3EfDeh3ylCp+DF/Hm5kLqZjhPxRZvIZv987kMnR9MasT52sLE0wdDHCNGEpWgDMa9ytJ2zxwWP4NfgMmVX4FnVYG73pcz4FdnzqTxziclMkko/0/VA1yGy6AC93jTQHfIJqQTIz3EAaQHmYikl8TMhfJlmckX4fnf04I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__do_fault() preallocates a page table only when the PMD is empty, so
that finish_fault() does not have to allocate one with the folio locked.

Since retract_page_tables() no longer takes the mmap and VMA locks, the
page table can be removed while the fault waits in ->fault().
finish_fault() then finds an empty PMD without a preallocated table, and
calls pte_alloc() with the folio locked. On ppc64 with the hash MMU,
do_set_pmd() allocates the page table to deposit in the same case.

Allocating with __GFP_FS while holding a folio lock can deadlock in
reclaim, for example the memcg reclaim deadlock on cgroup v1 described
in commit 63f3655f9501 ("mm, memcg: fix reclaim deadlock with
writeback").

Return VM_FAULT_NOPAGE instead, as we already do when
pte_offset_map_lock() fails. The retried fault preallocates the page
table before locking the folio.

Fixes: 1d65b771bc08 ("mm/khugepaged: retract_page_tables() without mmap or vma lock")
Cc: stable@vger.kernel.org
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
 mm/memory.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 11cc4039b853..b7e53d7cf6e5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5986,16 +5986,21 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 	}
 
 	if (pmd_none(*vmf->pmd)) {
+		/*
+		 * The page table was removed after __do_fault() found it, so
+		 * nothing was preallocated. Allocating with the folio locked
+		 * can deadlock in reclaim, so retry the fault instead.
+		 */
+		if (!vmf->prealloc_pte)
+			return VM_FAULT_NOPAGE;
+
 		if (!needs_fallback && folio_test_pmd_mappable(folio)) {
 			ret = do_set_pmd(vmf, folio, page, /* may_alloc= */ true);
 			if (ret != VM_FAULT_FALLBACK)
 				return ret;
 		}
 
-		if (vmf->prealloc_pte)
-			pmd_install(vma->vm_mm, vmf->pmd, &vmf->prealloc_pte);
-		else if (unlikely(pte_alloc(vma->vm_mm, vmf->pmd)))
-			return VM_FAULT_OOM;
+		pmd_install(vma->vm_mm, vmf->pmd, &vmf->prealloc_pte);
 	}
 
 	nr_pages = folio_nr_pages(folio);
-- 
2.56.1


