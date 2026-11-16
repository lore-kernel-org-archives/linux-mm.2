Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDF90606A335
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DcHSkVBt
Received: by kanga.kvack.org (Postfix)
	id BFBE86B05B2; Mon, 16 Nov 2026 06:03:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD39D6B05B3; Mon, 16 Nov 2026 06:03:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0FDD6B05B6; Mon, 16 Nov 2026 06:03:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 888686B05B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:03:45 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 13186120880
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:03:45 +0000 (UTC)
X-FDA: 85440696810.23.5C6B9B3
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf14.hostedemail.com (Postfix) with ESMTP id 50479100008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:03:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=DcHSkVBt;
	spf=pass (imf14.hostedemail.com: domain of nakixii@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=nakixii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827023;
	b=3yIsaGNoCUXdHR3Nb6yENx2vyOcw+/3nIgmhn0JcFd8zxZ1/gr789EytKmA6Ezo4KDW7m+
	zBeH3aB2pkfQSwhl8lRPsDCEBdKqoEOGJPFUzseBYXMIUlm9LLyQen5s2Rfb0olgxNPvum
	jwK6Fxqpb5+RElDzsiy1vj13Pfo7rWY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=DcHSkVBt;
	spf=pass (imf14.hostedemail.com: domain of nakixii@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=nakixii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PH/J5T/Zisv/IuxWjVJ1q31kRUwi5lZVkNYG9k7l4V4=;
	b=GM8KP8E+XbojOP65aIawZmEN8/AdGwYAuXmwqWjl8qH51p06c4uSN4EB4Y15Pxuu8ozvHh
	Ns35aJIU4blZEU/HhXaTT9g2LsDTtD+YMqF1D+O0o5Rc7P2pY0axkH2F0XnK/4wbw6+d9W
	0Fy/WmG/WHePlHS89F+sh5/wo/fZ/10=
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1b3acec6677so4476213c88.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794827022; x=1795431822; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PH/J5T/Zisv/IuxWjVJ1q31kRUwi5lZVkNYG9k7l4V4=;
        b=DcHSkVBtvtgD6XAuKZH1sbsr8+UaTCVfT7fqnm4gj4OM6cOuFk1AZehmWlMfxNfAVe
         P2W4INsLo0pkLYe7G6F8LbASKBdwaoAF70CWZnw/lXKKqYB3w8htYj92GQtQlNjrL3+A
         nKSV1zAbDv/ASdWkvTqzhrF/KseYl+y81t7V7p5aZLG6OLKiBy15rYmPyLQsKMdOCKA8
         hkBwNVg2k76N+Yv7sx8iITesswxto3I2VrCfQ99w8L9lx3PeWlmB8ENnITxv4Mho7YHe
         D2ox1JFcPi9N7L8fYKWXtKYUx+HIQlKQiRgM5ZuWHUNntYwkfqUInrs1j/Hnkpe3m+9g
         SLsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827022; x=1795431822;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PH/J5T/Zisv/IuxWjVJ1q31kRUwi5lZVkNYG9k7l4V4=;
        b=P2tS+CUm1fiLYQ0mW671MOLVOezIRBnp6EmxrrO/NYEdKOSeB3UEtxJsP/uJORZyYJ
         OKNykOg8vi+FORApaLsW4J/wnCa5yw+LlOZ5P8+pQ0GAszRpbJFT7q3bYPCU9N9Eq0LA
         T41pkUT8J2bw2rbYtGzHxf6z/+6bMlkUVjudZ69C0oDNpxmaQDD6RTI095jM2ycO0EzP
         ieS1pzb6Aai/vP1nDWZMxsW+Zok6BjQgk+ppwEF6biuLQAKnzsfXFuKfRixTRoTNLWVX
         fiATCrmYZyYhpVfss20Ayxr1xQJeubo5mKboYiH7JtQPUoYpCevnJZWpz/00dbCoEFhU
         JtAQ==
X-Gm-Message-State: APuU4Z+M78ajvTj7iq5lDZ4r0OJzexPN7sM9xt3mBpyIaTgTOO7Gs24/
	E0DIT9Qho57xK9PjbcW/RoA/j6Te7ozC3KwxP8OUTHTBrdHhGARbZuON4XMSWAxqs/kz3IvB
X-Gm-Gg: AYBFou1IJHAdDD483kUavitUJlSvLm79PD39lGhBw1lucOYyeWLoxtlK2MwguBim1yH
	o1A5a06Hee6y0x26SSe7+WdJfSoexFrXBGac+BdiCi+8Na85qP0jJ8ZqmJRFHZEZTK7QINbnp7X
	a12jboY+m6jVmfUsSZv5xtCixqUMjMMctbBExS2JS/mRp3wOHRScLMg4JH74Dq7bdeup9oMIgNp
	oOcdp9rmpqJ2xyhuNZD6IMKsfgKwy5iu6WOuKH04vyikSUV0ZeNSH7q9GMYQXNR6rRx3x0GNsed
	GK948N73q52aR/8fyu35oM7tnFCnfG30RhILDbh4GSVtolobzYonsz4XRkQoLd49R3LV2P4+iTE
	QNnYYbbdZmqZfY/hy6DqkYoeAV4W/u6tdwC51ba5tWSpJcg4KHmz3JNnI6rvdHdNaKU1WmVXfrT
	A/5LGHE1HUhtuRPkGhlG12s/DFh1WOumj0tcekWCLdEf5g7+dY9n17qaQf0LZZYNszQVBRSSta5
	44B+WYxNJnuKLmATOQwA3DJgJYN1wA0L1TGFHF3nytizEeMVzYf33grCSGtD+eT0N+Z1iZbz+aH
	4s19foOPMSom1OHeCvnYi6vX7Gg9CLaTjAzRshgjB2Ct6fneJPyRPBP3WPY5kq5iY1xa
X-Received: by 2002:a05:701b:271c:b0:1b2:43b0:4794 with SMTP id a92af1059eb24-1b5030d4941mr7826513c88.9.1794827021837;
        Mon, 16 Nov 2026 03:03:41 -0800 (PST)
Received: from naki-PC.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm42999260c88.9.2026.11.16.03.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:03:41 -0800 (PST)
From: nakixii <nakixii@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Barry Song <baohua@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [RFC PATCH 01/16] mm: userfaultfd: check the exclusivity of the page being moved
Date: Mon, 16 Nov 2026 19:01:07 +0800
Message-ID: <20261116110122.309748-2-nakixii@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116110122.309748-1-nakixii@gmail.com>
References: <20261116110122.309748-1-nakixii@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7nbbf85j1764nt6jceahm19131nndyso
X-Rspamd-Queue-Id: 50479100008
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794827023-544010
X-HE-Meta: U2FsdGVkX1+HEXpdzip6dBN+LSobGTbxPHRv64AFVs7Xrdpa34vIUb1wcHukDmniRKd7SKdwksaKI/sI1r2hWGrgQpstPcCP4C4v7EZzX4/zUKchyCZdI6fOkB2EtuSKbNdVdvxUEgV37SrEqdtVHz8J2+5UwQ+OHEu6ULkuibgqIxESbTkFv+PAijL9FRwoJ3aQBEx28c+2/i1tV7ESxlHdhbh3wJX1bAqkvTJWoFL87v71ipU7DFqMYS3+nAcg7IaWt+mPwkGQt156ebk3NCHlzATUg4RjvKocGzWkpG3Dx6Z/5l1JbBi37YHiFCYEgQdVY+4+7o54sm499JhOrUpJ7CVhWA0dgQcCg8Jm3TgOS3Ko8WwiM6V9EM9MPBoeg1VrM/wvWhOEG4pJ5wUQ6/VWRC//Db+O/04x7BPHuZEAqNGwaIAApv2vqBRuYd4fRzLM9c/cAFAVxctonw44s+mCEEnbcOed7+/lgPcy5gGWR+aVZ9et+QTZt3Jbmq3SnUPSEArm4XQE4GsP/mSwbgD6860Du90GrDdG9ukZcNaghbuDQPpc2uYyGfjGdgpUEuKvZIryDftW1A479EmdBb7ox5hbMauFqH/jVk85abzh78xhCjcQxy/r8i1V4y7XSssCs+9/C+Gy381oKAwNrXVWnv87qX4+AOhh3ql3/kSdq4zyAic67AIjijWCe57oxWLfmjEYmKhTIHk4ob7kZxDkJz45r86l3jXed2xUqgHKe1NFyWHKzWme0mAXO6nQhO0Q+AaWFqpA6hokODNv9ZvB/do8GextPRGjZJhZKhPgApiiicDsg66gqfG/2T0xEAzKbPYd5+uFwXW1J4V5XrRkgQnGg/javZksM5lXjjYjBmrMyCju2qh2ooYp8OqTqtuupvGyPHQCFVFnwIZmuqNvbrjtrH7DSfInDhfn0izqicBXL0PxnLG+6eSHmRURfZDOQ1/YuL9hO7T7YF8
 ImtLMIY+
 myockPLZrbhaLiSXKeGT1fjoTyv/G5sjIxB7XZPeH0fiTDoRARIe+7+mPnsKtEMnY4zbl+jJUOVWcWDzyKD9BOD5Rn1uFrUqyauEVM4rAYXUdpcSOLK7LLExmTE2WnJmGWur4yE0o6Q8gnRtM4kGC4oTy0pUB00PmB/T3zmcW0ZgDYinsESCP4wkWPDk4W6lBRsttGLeuKQwQmiL2brNIa6vvsXobAWbxHC6P0T+G0bniE/64pLyu3OJuFehvJguUGUsGNWzYUDMrsSx0LA/qWE8kM1pOuNidQOzOQdIspjVBlrqgxiJXOZ2JlUiy2jFqnxKJcYaxgt8J3/tsJrK2HFz9/cFPsk4BXhEZxhLmRRNBxhxAzUdfhCkttIjDxhHGw1LUbip7+dLiRT2Z+mSOFu/SsAYy+gPmmB/pjoA8DN618qPGT/fDIF8I0ybrGcY3R00kXRsCsE1jzSxbYcliNo321uWLVcQ2qzWT3MBqXOVjynEHuR/IBWuuJpKnXv32RRkLX59ORCCgoEmwPS6Q2FBMDVoyVU9KtrQd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

UFFDIO_MOVE checks PageAnonExclusive on the first page of the source
folio even when the source PTE maps another page of that folio. This can
reject a move whose mapped page is still exclusive.

try_to_unmap_one() can replace earlier pages with swap entries before
folio_try_share_anon_rmap_pte() refuses a later page, for example
because of a concurrent GUP-fast pin. The first page can then lose its
exclusive flag while a later mapped page remains exclusive. Checking the
first page incorrectly returns -EBUSY for a move of that later page.

Look up the page mapped by the source PTE, check that page's exclusive
flag and derive the folio from it. Preserve the existing folio locking,
reference counting and split handling. This applies to ordinary swap
unmapping without requiring an additional page-storage backend.

Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")

Signed-off-by: nakixii <nakixii@gmail.com>
---
 mm/userfaultfd.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 080a00d916f6b696ef326b6e76e205970a94fa8b..d8a699981d097ae393a981a33cede5f5ce6e2725 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1225,6 +1225,7 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 		 */
 		if (!src_folio) {
 			struct folio *folio;
+			struct page *page;
 			bool locked;
 
 			/*
@@ -1238,8 +1239,20 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 				goto out;
 			}
 
-			folio = vm_normal_folio(src_vma, src_addr, orig_src_pte);
-			if (!folio || !PageAnonExclusive(&folio->page)) {
+			/*
+			 * Check the page to be moved, not the first of its
+			 * folio.  try_to_unmap() unshares a large folio page
+			 * by page into swap entries, so while
+			 * reclaim holds it, or after reclaim gave up partway,
+			 * the first page can have lost its exclusive flag
+			 * when this one has not.  While reclaim still holds
+			 * the folio, the trylock below sends a large one back
+			 * with -EAGAIN; once the folio is split they are the
+			 * same.
+			 */
+			page = vm_normal_page(src_vma, src_addr, orig_src_pte);
+			folio = page ? page_folio(page) : NULL;
+			if (!folio || !PageAnonExclusive(page)) {
 				spin_unlock(src_ptl);
 				err = -EBUSY;
 				goto out;

