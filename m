Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF0A9C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 02:49:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA4986B00A3; Tue,  7 Jul 2026 22:49:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A27626B00A4; Tue,  7 Jul 2026 22:49:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87A046B00A5; Tue,  7 Jul 2026 22:49:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 544FB6B00A3
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 22:49:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B57831C841C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:49:07 +0000 (UTC)
X-FDA: 84964077534.07.3F7B4DA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2F1DF20002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:49:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UfL+YIcW;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783478946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rYlq3Lp1htxNcYc9q0Uy+3l1xL/3ejGhpOTnhJctTfI=;
	b=a4e7D3rz5wQkQtm9hMVmVWVvjBZDkyEbXbybJPXqfbTxVAKFLEgTbGuo0CAOVT4ZRw0jhb
	sk7AboTvLU0pN+ySmibOmwJJ6YWzcf/44wUzbi2qpcrXXxUPGcZbHmK375H42UDMH0emrs
	duANHBDa+F9kyScs50OCdLVbvO+Ms90=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UfL+YIcW;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783478946;
	b=6BQD1uiuhMNwEwMtsFzTsKg7L6hJR72Ng+Fn7FNcNEWopLKlXWyN+uOegeCqKAXF9v2oyr
	uz8FyLsuIjpdXBSH+7E9G/NeqhyRaXmOByRQ8T2sK2VIuhkV5kTQhlMic2OHaPQBPmWcCE
	ZfgE/9mkIjNu7VhRTIwSdWnn56zkEX8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B88756136B;
	Wed,  8 Jul 2026 02:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46CA71F00AC4;
	Wed,  8 Jul 2026 02:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783478945;
	bh=rYlq3Lp1htxNcYc9q0Uy+3l1xL/3ejGhpOTnhJctTfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UfL+YIcWndxSNHboQ601wL3Fv99hU+twcCWNkYprhfI0RE1bG7BvYOfWpc7RckcqW
	 W+NRmg4n1w+oyR/YPFTK3bCgvgRJYA49Prc7G2+tnXyxw+PDF1Q1EaCMB7Se3fI8Pn
	 /79HCOMd0gehsSmzeZJvClaaTL98cdvhH2OCootY2BqeK3pWObKNaXPRzYhh0b/J65
	 mOHK/HCC6lHcpKRWZHGbyE1gn7ua/M0mfiDP4YhWmK4bmNUk/dNkSiDQd33PZwt66I
	 RwZgZ8bS0eeHTMeeIeVthYoiB+6BPlP9Kkx9pHQyB9r3AzhFoOg3E+MQ0YS83eXyA3
	 O3YKFOVG8gVCA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 5/7] mm/damon/core: s/nr_accesses_for_new_attrs/nr_samples_for_new_attrs/
Date: Tue,  7 Jul 2026 19:48:51 -0700
Message-ID: <20260708024855.116614-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708024855.116614-1-sj@kernel.org>
References: <20260708024855.116614-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2F1DF20002
X-Stat-Signature: jtb4r7so396gj393hxikdfbgrewe17so
X-HE-Tag: 1783478945-369384
X-HE-Meta: U2FsdGVkX1+Ijc+P/rRN4WffQBeoh/42S919Fy08f/iBZw6RhoAkS2LskikW5aT26YKxwzO97hMBI15CVspcYwZYRKmYLO0+PJj/dIL/4Kym4O7K/CsI9SaBClaOPu0LZR8VFbcaXz2aHsvye70EcC2SXGy8yas3b7oGLlrGYEidppESgeZ9KLclh4FZy/TyFh8IsQvobMxCsRjH1/P5j7X47a9qOvbnCAiQx/S70hyc7tnI3ewHULFQTjeZFwqngRdhHcBYIlu0Pka0kRAqltf7Z4EMJEph9TyPCGXfhCYlF8c1OA/+gEfL++1xRglHjiyu12D8j80MhxhsjYYgWNWP88P4/XkRjKDvWCCkikOLq+/RO7/cTBsBUZiHbvWcqhzzHovsxPQgWOHzZQ/DKjU/EcwsTY4QFpk/OMXjBfpNX9DKrRd/DvdLqyBstu8x6G66ENaVRAfrfIh+UQcIHV8XBIbESBYieVGr7L6CNpn8LuwTpew4u3ij/FwdACmQ2PIY1lno8d1JxXBpY9ptJBNRsdR2dOgsTnKdhr+ypPdvzftzI//KLkie5ghAyDmcJvFTbq/s+ILhoeXheGndhntwcx8UcIXKUeUS+LojwK88a4+QqS0JxmpDx1MtDfjrpNwDfdpj5NFS7jqvQ0Vwj09LLiLgZsVZYxpR7hEeD+ezrNAKGrkYPEoeiq6p/Ino507p6fGKDDj+VIQmOBbUQjz7Ko8r/6/xsuq2WN8FgJWm4GpExOG8U7WpjdGI9ASzowUQQLE8bcuJNFIFJBGjQKuC1Kmpu31dSdVtrpgdYj1kO30qGqgEn6ap0hBlSjUfE1iUZdfKKZe0FJ6iFAcQ2cgd+D441yCdCFCAT25U6jb4pBZQDiAU/S3ocYbqhH9TAL+urijvSxPy207ZMOKTqw/+lBjrJ3vpvAJE26wAcvWWzsSiSN5jvnScuy+D4Synf8Ps2aluWb62oZ13kkr
 2JzTvkpr
 y/5wdam4Zdy4wTLlpsEyr+EovKOC6kuQznmkXkWgr1kQEPKa/6SgyEoqVZEdq8VqN0lbPZjIjYb1xHes9OmFFXkzy0fmKFexoawlNNj+lMt5c8ZDK48SG4vso07xpoMmmYZRDMOWRSkvHMOUg9JdDOvtItHb/HusVH5AYAAjRfY53dt1S8GfZnXOvB9ohy8Aa4UI4uPdbC78xu9l0VDkU6DC5/53lAf1UDHYtF7+R3ifqc0aIwlLYHCD/6PiU+XE5SEhCIa8EVx2Np/uwl6sMq/s+gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_nr_accesses_for_new_attrs() can be used for not only nr_accesses
but also any positive sample count, like probe_hits.  Rename to be able
to be used for such general uses without confusion.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 718268df27fa7..800ff6b6d2473 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -890,22 +890,21 @@ static unsigned int damon_sample_count_to_bp(
 	return mult_frac(count, 10000, damon_nr_samples_per_aggr(attrs));
 }
 
-static unsigned int damon_nr_accesses_for_new_attrs(unsigned int nr_accesses,
+static unsigned int damon_nr_samples_for_new_attrs(unsigned int nr,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs)
 {
 	return damon_sample_bp_to_count(
-			damon_sample_count_to_bp(nr_accesses, old_attrs),
-			new_attrs);
+			damon_sample_count_to_bp(nr, old_attrs), new_attrs);
 }
 
 static void damon_update_monitoring_result(struct damon_region *r,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs,
 		bool aggregating)
 {
-	r->last_nr_accesses = damon_nr_accesses_for_new_attrs(
+	r->last_nr_accesses = damon_nr_samples_for_new_attrs(
 			r->last_nr_accesses, old_attrs, new_attrs);
 	if (!aggregating)
-		r->nr_accesses = damon_nr_accesses_for_new_attrs(
+		r->nr_accesses = damon_nr_samples_for_new_attrs(
 				r->nr_accesses, old_attrs, new_attrs);
 	else
 		/*
-- 
2.47.3

