Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D3D9CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 18:12:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5856A6B0252; Fri,  8 May 2026 14:12:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 536C86B0253; Fri,  8 May 2026 14:12:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44C746B0254; Fri,  8 May 2026 14:12:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3362E6B0252
	for <linux-mm@kvack.org>; Fri,  8 May 2026 14:12:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CD2D31C07AA
	for <linux-mm@kvack.org>; Fri,  8 May 2026 18:12:54 +0000 (UTC)
X-FDA: 84745048668.08.CA9F916
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf11.hostedemail.com (Postfix) with ESMTP id 408DC40003
	for <linux-mm@kvack.org>; Fri,  8 May 2026 18:12:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="k3fL/sIz";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3oyf-aQYKCEIjqe2piksskpi.gsqpmry1-qqozego.svk@flex--fmayle.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3oyf-aQYKCEIjqe2piksskpi.gsqpmry1-qqozego.svk@flex--fmayle.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778263973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UyKGCYrU63Aq4NGiL04wV7gIZx0hsmStPfmXdP8BRuQ=;
	b=rCT+W9twaINrkIknt/FuOgP23RAIvRSzsp4gquN0BHylVlBhr/247LTjevb2t0JC3IUSjQ
	yXRPMB298L3bT7noqFah6NRorz85d/6Ze3uV9aqtdp94aYQBTlYdWhFRTzznwh6I2Q8Nrk
	kZBzn7EUiVGe0S2dryrDNDePXxuF/rQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778263973; a=rsa-sha256;
	cv=none;
	b=eYmYeYpk1WBnQj5Y7neDCu1runxUjQLgxbh3C6alGO+f8eSk2pKlTPLVTq/qtgbeVNivPT
	9ptbnUYXo/jOse8VeRhtjnU+BnHOk9hev9eeeremAfmrvk4kElEiQaP2QYcOx5H32VgZTz
	Huryb8RFMdp7kQt72olHhUPS6yXND6o=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="k3fL/sIz";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3oyf-aQYKCEIjqe2piksskpi.gsqpmry1-qqozego.svk@flex--fmayle.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3oyf-aQYKCEIjqe2piksskpi.gsqpmry1-qqozego.svk@flex--fmayle.bounces.google.com
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2f485961555so5409468eec.1
        for <linux-mm@kvack.org>; Fri, 08 May 2026 11:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778263972; x=1778868772; darn=kvack.org;
        h=cc:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UyKGCYrU63Aq4NGiL04wV7gIZx0hsmStPfmXdP8BRuQ=;
        b=k3fL/sIzwesj4UxNT6n8PRmMgys/Nx8X6B74NERvMdUaqeC1yTeZ+EphJktkPBShfh
         ZOVwCY4RX7S5WQNOaUT9HlbCWhlfWmigkj7KrePuxCs8jtUjNwK6L3WWuHU5KpvuJERs
         diHwcYOuPuTGbaDb0j5wKkNg+u7L4fhI2K7+PJ3RSc4ikuOKeYVP6UOBn4qwkbfUU9c4
         VRdStkRexb/zVs0hcOoyybdVbKparU1K/4h51oB8iMECi3qC8wZvRSpFAKE+yuUDvam9
         XN9I17p4JtqPFI9068FUYLicTx+Vy0Nnmz2KzEj4trek3SVcy2FbS0OY6h+aYgiID4yF
         y7OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778263972; x=1778868772;
        h=cc:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UyKGCYrU63Aq4NGiL04wV7gIZx0hsmStPfmXdP8BRuQ=;
        b=Uiss1d3ZCz6UxVa2I4+eO/PBRO9PF58iaYQ4OE5jJi7xNid8bFyvRYaEzGVz+KNQvD
         zbtHo7eew0jlcEaO3UmnBVTikcNmFokefxoMe4YgpvHBSd2lHzofJCZB3UdIVQMVURvh
         G32V1ghE35tjtsboHaIdkIy+djB3nhgliuNjwfOYH4gEJGSBA647qQO8Es2hnrp6ps+x
         y2T2UUIbq4+sWQF2gR78Ff3bqON3c/k6fk7y18eDoqglnaVbjj29mdzhaevXr/7cMVp9
         pyEzPrvXS6z0m2usYYkK/TsXYmVS1icMpPidfczdCVWMdi9PWJ0Vp7FsDOxehv3r8dTi
         pwqg==
X-Forwarded-Encrypted: i=1; AFNElJ+bDg1Dr0D3TtImd2JxZXDl8JR7mc1g/Zk37ibynyLXWlDAWtZLBjnS8YKb6uzyI7L2+g5pkVN4Fg==@kvack.org
X-Gm-Message-State: AOJu0YzKK9zj1QhBC2Cd1ycdUDCRlbVQaALrZByO0Se+1dwPAxQNkqII
	DyQmkJyaSMpVjl9ae/xg79vWiWrDk7napxH6yiEeIeLuBi3khp+c9nyskrIpC9cbAIfz9gs6m06
	yYEIOtg==
X-Received: from dlbcj32.prod.google.com ([2002:a05:7022:69a0:b0:12c:b3eb:b31e])
 (user=fmayle job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:1e10:b0:12b:ec67:3523
 with SMTP id a92af1059eb24-1317d89653emr7226915c88.9.1778263971653; Fri, 08
 May 2026 11:12:51 -0700 (PDT)
Date: Fri,  8 May 2026 11:12:31 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260508181237.670645-1-fmayle@google.com>
Subject: [PATCH] mm/readahead: no PG_readahead on EOF
From: Frederick Mayle <fmayle@google.com>
Cc: android-mm@google.com, kernel-team@android.com, 
	Frederick Mayle <fmayle@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 408DC40003
X-Stat-Signature: uotozd1dhaxkq4nhit17po9cfchr3pkt
X-Rspam-User: 
X-HE-Tag: 1778263973-713545
X-HE-Meta: U2FsdGVkX1/h9a59gsivmOTQRA7hx9wpu8/MyqIBP1rY6JQgix3LGE3pGUklCH3WSng7tz0iUVQnU9nqNZ5lZUmC/trYITQWoXeiTFFIV80lnhixEigUJvR2zIWSGl2bScOH2P4E3XzgMZZR9PsGRBhw2NaYkVrc/0AwKefsCctQZSwqFYBlRbQA8LO+qmJ276cmx4QT2lFUUhWRZyC70pi2HK+A663axPvWz/G6Fwp/mt6YctREBrHs/v30+ZFx7m5KJGOgM41l4ELCfQSgxRUgcG9yMzUaUBTb4HBTp+bfaDWIZydke81czZBLytf/coLwIaOa1vMCycH5s833zpRdwOUn0XZZ3UQ1zXwO3jnzy30ZuGpwShLfWDntyrDd5SALBfwsc7W+m+T5HC0G3/xmlwom2vxo+ksxhNUgJeVWX9FkEMWWgYs6b2t1KiMMkENrJwQhV+UkRA3d+mVwGd3mmDT5ug+sx0WVrVriyQHGFJ3cg7LxIqfUc7LT1fvh3H6wtepS9yMMmBPHBLAO+07ZYEchS4DIX6A+j0lpMlf64tsMyTbbt3fIvkPTvdlhFhArsYXC4kA8wxoEhOEH9zIZpRf9GUVOqMT1H3pWAPNTrU0t9iueWm2nLkHe+ML5FJ1YZVP6uhSVWvYMVlwZFDtt4ActqiB8u79jZno8S2ZhU9I43OpAzXoOgz/3P9yD2T/ZjmKf/d29EZQL/J/oiBRkQd1ICSzHhtnUPa4qyMRIjh1nlzcq/bY7eU5ShlaO1AJQhooYKo5T+UFokFPDCWPl9LmDcf2BqgqCv3HIrp1qrAeRhzWevqEE67xA8IV4lZv0vhrtMKC0VPSvx0CSTbQzi9JnzIgElndHJ4wzLmkLivJHBV7cJpwkCjMjK4EzHNKOivscv2hEzZw37tU+Vvug9zsACtTrkBvPXMN26Jd+4rZ2E3Brtu+pgAquhlSu/DsyyQQCX5tMK35M+Xo
 uobjVHrJ
 tqQ7hzjIv471Do6VMiyYglFM2ECqtVSj2u6LBOZ3Uoa4spmVSIAgmdYCMgbfhz3J0H1czAYXZKv9geEG74S3BS2F/9DzH/QLIvIK55HViJFiYF5VTbb8MFV8SFEAVuWckqQxBHv2Xg49FOkodBB0/xZhtcCd5lc47wCqg9TCCeg8QCAarmAZDelz1Eal4k694C52kfdF23vpgv/PEJj3PfEl0A5HC2Whs7SFtcq4wzNPw+kG1pTaBy4ANeB+oUrxDt7ZA6ATXD7rnBwvCMcccVASKd0YrHip2T6ZWMVAbI/lNw40wRfwn+ZVLOLuyIyaHJlV/ZqVhhc4Iu4rNvM2FNeucGGhM5YSAECb4gIK7/dkUKvr7Lk3LSb3p0+qsi+QZEV45fiYE9nBxLNqswKT0TP8JWVklTfvBFqLONXBwvuqNKJGJ+jgDSDsCyQygLC8ckQzEl6xxZaFzTUIhXwzC6qJYjsQbzDDIPsSckhdqvwJPKWPhbCrP0SXO0RJtHM/82EMRazqTY+5gv+zAImsx6M5oRwVS1TFd+seHcLUq2S3zG3vzpPuh4bnA5NIr/QK/VEXD6gHN7Ta5mzUUf7Lgai4Ina2cKKEUWJOhRy/Qx43lnERM3k93g5uLqDTSBS2TfnBCidrKcwXq7Ha+g2eIwomWJEbpf0VxS91A8OgVhlgtC6tYh9I1UILSps1CTLqHf3UOfTEu28h3jLttjQOLY6DjClYELT2dpsaJJQUmPF9ImwusDj9E26UdzlNVAKYJ8iLYR0pyo+92Gq/UEqLCstR5tocU8OzMGVaz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When readahead pulls in all the remaining pages for a file, setting the
readahead bit is counter productive. The async readahead it would
trigger would almost certainly be a no-op. Additionally, for mmap'd file
IO, the readahead bit limits the fault around [0], causing an extra
minor fault when the page is accessed.

This was discovered when looking at /sys/kernel/tracing/events/readahead
traces for a simple program. With the patch applied, fewer
page_cache_ra_unbounded calls are observed.

[1] do_fault_around calls filemap_map_pages, which finds eligible pages
    by calling next_uptodate_folio [2]. next_uptodate_folio skips pages
    with PG_readahead set [3].

Link: https://github.com/torvalds/linux/blob/v7.0/mm/filemap.c#L3921-L3939 [2]
Link: https://github.com/torvalds/linux/blob/v7.0/mm/filemap.c#L3721-L3722 [3]
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Frederick Mayle <fmayle@google.com>
---
 mm/readahead.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 8c12b63ccd4a..784a3bde82be 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -329,8 +329,11 @@ static void do_page_cache_ra(struct readahead_control *ractl,
 	if (index > end_index)
 		return;
 	/* Don't read past the page containing the last byte of the file */
-	if (nr_to_read > end_index - index)
+	if (nr_to_read > end_index - index) {
 		nr_to_read = end_index - index + 1;
+		/* We've reached the end, so don't set a readahead marker. */
+		lookahead_size = 0;
+	}
 
 	filemap_invalidate_lock_shared(mapping);
 	page_cache_ra_unbounded(ractl, nr_to_read, lookahead_size);
@@ -474,7 +477,7 @@ void page_cache_ra_order(struct readahead_control *ractl,
 	pgoff_t index = start;
 	unsigned int min_order = mapping_min_folio_order(mapping);
 	pgoff_t limit;
-	pgoff_t mark = index + ra->size - ra->async_size;
+	pgoff_t mark;
 	unsigned int nofs;
 	int err = 0;
 	gfp_t gfp = readahead_gfp_mask(mapping);
@@ -488,7 +491,13 @@ void page_cache_ra_order(struct readahead_control *ractl,
 
 	limit = (i_size_read(mapping->host) - 1) >> PAGE_SHIFT;
 	limit = min(limit, ractl->_max_index);
-	limit = min(limit, index + ra->size - 1);
+	if (limit > index + ra->size - 1) {
+		limit = index + ra->size - 1;
+		mark = index + ra->size - ra->async_size;
+	} else {
+		/* We've reached the end, so don't set a readahead marker. */
+		mark = ULONG_MAX;
+	}
 
 	new_order = min(mapping_max_folio_order(mapping), new_order);
 	new_order = min_t(unsigned int, new_order, ilog2(ra->size));

base-commit: 2d565cbaafd43b10b75da56e43e5db9852a56afd
-- 
2.54.0.563.g4f69b47b94-goog


