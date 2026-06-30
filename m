Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 447B8C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 19:09:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 216296B00AD; Tue, 30 Jun 2026 15:08:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A0666B00AF; Tue, 30 Jun 2026 15:08:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00FC96B00AD; Tue, 30 Jun 2026 15:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C25996B00AD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:08:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4084C1A0284
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:08:58 +0000 (UTC)
X-FDA: 84937516356.28.17A1728
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf14.hostedemail.com (Postfix) with ESMTP id B12EF100003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:08:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=zXRRsBRD;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf14.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782846536;
	b=l2+kWQ49l7Gmg2KUVAksYagUd4TXqkQPxYkhHL1zok4ylQZYusyzJq/Z3j5gAJAyRm4MIu
	QF2FerDmPCubdog/drArtNMErQqAWtf5ZV7aysVdS2KSFDbqYyph/sTF5Z9YHVoiAxUVYn
	WPmFUqk6Ot/G32CJamZvbdwHnpWfZ6k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782846536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IBOME4229qFZg2fNmMXblz8s1CDkVlGlAP+BdA0YuZs=;
	b=yu76gfjijrIYGWEq8YNhpzJuYXAYMN0HzJdZFjRIaSSlvQ/mpeglpbDdm0XkexFI6i21XB
	p2wEbVrdm3lpTlaTtmqa8897cEt0TUtjzGgimnPhFE0UxgrX4GgWFBplKMe/n/op63MzuU
	AJKYfSeypFQXMCLgW+vtzYmjvmILcK8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=zXRRsBRD;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf14.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IBOME4229qFZg2fNmMXblz8s1CDkVlGlAP+BdA0YuZs=; b=zXRRsBRDbqEEnFV4+ht3aD4aro
	CXLpuCOQY6oMtQV6XYY+kIFi4qCIDanXegTxyHW/bWlhUBGDQA/owVLFhNiPMzdBe89KX8J72mIWD
	nAN7v/KAt1VHSCD9tHR2uRKWt4SgScEQppwUS42mpN/tJbcWHaSR1+WBZzZhMPh9x7tbxTdvOCqHk
	O4Nzi97ZMEYbHN76LgKnMByCtw37apL7ze+UNYXNNfBhhITATh5m4PgWf5C2FwOBKkKmRI6fAsKIS
	Xw/M/QeJzCsyI7giaHN+wkEhQ5Ey17i8uDloOwB7ZLM+Z4/OzjapUsF8DYqqC7q5POJQ81vPSEtmX
	GdCSPQKA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wedpH-000000005rL-1zXw;
	Tue, 30 Jun 2026 19:08:55 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH v2 05/19] maple_tree: Drop dead code from mas_extend_spanning_null()
Date: Tue, 30 Jun 2026 15:08:29 -0400
Message-ID: <20260630190843.3563858-6-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630190843.3563858-1-liam@infradead.org>
References: <20260630190843.3563858-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B12EF100003
X-Rspam-User: 
X-Stat-Signature: 156pbq3dowum1afowaf5mgpicdb9moom
X-HE-Tag: 1782846536-551682
X-HE-Meta: U2FsdGVkX1+SrXcCfSIqf2i5GndzEOckcatIB7zs3cRaJ1oV1GmHxCr9JmWKwtiscZG8NZOs+XZNOBWAIeq2sfRJxNkG/hasloyNNIi6P2rsrNNc8JCqRN8mRzwb6aChSe2Hpq8iCvKiiI+0ObyoKh233Zkbn4mRMvtEtkgJSbQqVoEDKUTLqtEoTlUGx19w0DcighFtyhrjUIkP76DWfCBMFAFXkashpRIM6e55WAvR/CiALa/p7A2f+gINYsxNjTHbfGwtTQolqOv88430nsepv/FhJSfdN1n5mu3DvMoirdfWOmC6pA/1+BHQDj+hUXKStEDsrjbGb3mA5bHEn8LyKUuCoSa9VmWOXEEio8UTqoZA0uC7zIxaOzqoX41lm9nu6b6QHh4gcU4feG+b7I7qrYtWaydNSH8LP+VskdWETSx5YV3FjDSCEyQCBS03OLp2RFkslQSC252iK4X7lUa+CVhkhi+HESqDO6QCcW9AoxII4QjQA5xMtm5daJX0qMX2Z+hUMLFryD2YH8M9W6L8u2TgxYEkZ9j+dhViqkyo8wAUsSlwC4aQwQlUGn4s5J9zXCXnzQUvJ2YV7fyaKlCPTZEl32iw+84ZxgKmfjN2oaVlp7bSFHHxWixYDC6tzsV1BWH5zijY4YFMCWnUaM0+ko6vdbt1c+7EC6oIld9ksiDiqEylg5YcjWQiT9hLZBOHutsVeMF1/gDFsqZk7iBAW5OF3mM4gPy161U69AeAEH0zAdwn72y/e3g89Vw0VHr/ZcnyA+Opo6RcDd9x/DoukohZ5ktIU00LIruEc8CvoCyk9ZtLkw+LvO+UMQlDoDr9hTgDWI1fsskFRMfQlLln17lKOm90nHJKZtAfnc/R7I7T34/fgbZSW/5nwJ+RryzDaPYnuVjxG8R4eT7NYiJ7ZgCpGGcCcBbKrDFBpibpmI9XwjKj3FyChIU1XXARx2Tr+bJJc4CJ8ZBqui4
 OUJ0403B
 ExhOUHHOsg/TSW7QbGdBTu2ELj/FQ4gi9ScXgipz+FyBOuHXJX20hyHNN1UUJhofxt482rDIYyCxhAodEUXeeGlPgRmRCqNPXFz3ezLd7M8kZ/4vVA1Sl5nrZXxJGkT9EIV2RhcqBCJfBMZvduJ3zLG9gLqvBe9GDxtvgiOevjzM5Bw5XjgM/VHuKr4QzH2yO7UK4dqQEo6Uq7xw5EEIUHzOW8feW6PQXFRrQ3FD1c8GSB3+qPYFvXWQQEFaHXJ1lJfDTnDPwkQmVD6PFPGoLS9n7tFisrA6W67zUTojXXLEitUioRjZgAZkPIMvXfv4mZ8y8I/jT1LtOh/NtuRNegUhLqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mas_extend_spanning_null() had a clause if the end of the range being
written (mas->last) is the same as the end of the existing range it is
overwriting (wr_mas->r_max), action will be taken.

This code path is not possible because the only calling function
increments mas->last (unless it's ULONG_MAX) to walk to one beyond the
write and then resets the value back to the initial value.

In the case of mas->last == ULONG_MAX, then the second part of the
statement will always be false - mas->last cannot be less than the node
max.

This code never executed and is flawed anyways (the arguments are
incorrectly ordered), so removing it is the safest action.  Since the
code never executes, it is not fixing any issue so Fixes tag is not
given.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index e2f7474572319..97849db132e7a 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2996,13 +2996,6 @@ static inline void mas_extend_spanning_null(struct ma_wr_state *l_wr_mas,
 		if (r_mas->last < r_wr_mas->r_max)
 			r_mas->last = r_wr_mas->r_max;
 		r_mas->offset++;
-	} else if ((r_mas->last == r_wr_mas->r_max) &&
-	    (r_mas->last < r_mas->max) &&
-	    !mas_slot_locked(r_mas, r_wr_mas->slots, r_mas->offset + 1)) {
-		r_mas->last = mas_safe_pivot(r_mas, r_wr_mas->pivots,
-					     r_wr_mas->type, r_mas->offset + 1);
-		r_mas->offset++;
-		r_wr_mas->r_max = r_mas->last;
 	}
 }
 
-- 
2.47.3


