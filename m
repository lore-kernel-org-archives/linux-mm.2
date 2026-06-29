Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FD16C43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:43:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9A386B00EE; Mon, 29 Jun 2026 10:42:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D71D06B00EF; Mon, 29 Jun 2026 10:42:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C60D56B00F0; Mon, 29 Jun 2026 10:42:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C5BD6B00EE
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:42:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1B1BB40118
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:59 +0000 (UTC)
X-FDA: 84933217278.27.52EB176
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7E72B2000F
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:57 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=dPpDNp9V;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf31.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744177;
	b=fCU2DPR1Lrl3kK6uUjCDT4kbcIqSI5MGeXdQGaGbaZ2Tn9yxWIfJt03F+/laRhfd7xgV7w
	onSrzywds3m3ypdwMK60E/FHzNqDMaj5De1l94CxxHp5xRWoxbbKFW5WS/fkCQlGg9JvVj
	WJWZzcPQHk9pIzQk2uQCaAilcIfZX8Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gMCtkKiPXNatIx/oARhOfW9f2EsZZ5KbLO+FulENZEo=;
	b=QjBQ6h81AhLLlJx1cTGqCTDQZ2ziyaYpfK4Q8dUXe720uWgBe8YuFnrNUHDrFLsWDXAYIa
	GG6tvkQlqRulP+oU11ddenQWH/NjQ6WHBRDKzBwtlp2m0hc2aHVbTaYZjPPjo2WVO3e8+T
	kJDkYBbGWGiMkR2T/jjj2+lRs+DKkiw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=dPpDNp9V;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf31.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gMCtkKiPXNatIx/oARhOfW9f2EsZZ5KbLO+FulENZEo=; b=dPpDNp9VNlW6ZcBHIKk3lXzljW
	qIlvwhBjhwu0WLudNCfG984ZvTcPCkQV6JGavhNmj845eLBQVYSgozazLYs32DY0JXf3XRy+fNsrZ
	2E3mJaMQ2vSXzhI68T3T0PYBaCd/H7HJ8ejUu31TQrau5oqmp7WFizpsJjmRDkyqhJGF0Lbeo9ncC
	jLNOU/8hjjWMcKy0eHBybp4RFMK4311g9z9N0N6wXpOWtEypB6VIS+S11xeWLoo9NjB1afPIiQCU/
	ffYbq/IwR+ta6p9WS4IvCsdeleVhP4h+sV9YkpodWcqL1ntmQjKs+PMU8UAZ2FXTs92mm+LyOD/Df
	uxorND2Q==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weDCK-0000000Eug0-1zU3;
	Mon, 29 Jun 2026 14:42:56 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Rik van Riel <riel@surriel.com>
Subject: [PATCH 15/18] maple_tree: Document erase and allocations better
Date: Mon, 29 Jun 2026 10:41:42 -0400
Message-ID: <20260629144145.1572283-16-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629144145.1572283-1-liam@infradead.org>
References: <20260629144145.1572283-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7E72B2000F
X-Rspam-User: 
X-Stat-Signature: a4g1ikm7fru6bpb3e7gi4mtizpyq57nd
X-HE-Tag: 1782744177-370992
X-HE-Meta: U2FsdGVkX18HsbyioFPuxDAayLpjsV0AHw5VcohU9xXydLFuI4qqx8M8vebkeyNZMrp3w7ffBAH4syUc7a39D6EhcrrO45+Elqzx93bDVJq6dKVr9JFbmgdUXZFtL+KPfeZrjBI1DpS4A5lR05RqPHCU2WJYq3SrjvOW4yEkre73IVhp9eQbGfFckOJdt+Qs96gRTAJpgKSkobDFHXlR4mdJ6E8FtsI78IBcBdiKFFCoWC+hniV1uuiA8lmzl7WjFsCt0Q8qfEd60YQ/jsRXkAgnn3Orlz5ZJmatxO8dq4ol0xzPrslkKElMYsWflF2QndzHD6QfqnhHe4t6nJqJ5VF7AIHDFSr7++inWHWF5bMeWvUgz1WcLSoejLCgpJYh7CopwAAr/GY5tPk9GzrAJSlb+MACj0pqMeyJs9Csr68NGe6LRJL+aL7McrW4Lk4a0FG0ZYh85wA2ALRP5Ty0FCJ1V9OKtJCdYll9qmVSc8PhgxDtu5i7oXS90I/QkYhkzVqiDYaBxGv1JZw4ybKKBVtSWNlIOjJy6BUcKq6BDPDRvYCUWN+ageRxkwveG94WFRuQ1fK+0C1OXm1DkKoYtYhLvRESR6uSlJ2kukNuulC604GYK1CCdsVULk4WtorC7nh889DdowicuFzOORZJsEyby98s+iFo+ShEZMqD4BrlZcpBp+b7cAFqYlnWeZjXqbuiDdbgLbGJL7ZY4Ui23MgR/xs78iFY3z4Ms/2EjscNqr2VzX7herXu3IFYRwOxhvTufQWptknOgbtLrWJChCUZfHRPAYUxnDeT7TE/7dA4T9IbL/bMTjJsy/sJirDVPeZIyr+JKrOWGWKtv+uG4m+l8UkYsVuNcGLF6nRccc2hcRTuCqXgbqvl8f1lTANoE+r8p1XJTJA2Zvn+poQDFSGpsCeE8R0XhhbxKjkISXTQaN9YQ93xXxa9kLLYB/iYZXzeuVyTP6owCefmUm8
 grZY9S/T
 9gJykxMyNMN5DaY7qW2Mq8hql7oOyVWleX1T2s+B97jX9EyePS9tQAbhj/emfKdRsaSEEoKp3n46OIaDgLEDG2/VbNj8YBXp9reiXx05FsVFf3PaMe72fuKoePohi/zm8AJ+N16mwLdl1/gu1wH25QsgiVtlOQarrt9Kjz79uLWiaY0FNtuWqzyILJU/yjKs+A5vQZLxt0nyg+bEkhlVJjrX1QWQOL5uEklnBdr/ti6WZty9/edLyvJLMDimGHeVk26aBHjsZc0qtbF+Py2Ou1gV7G/oylDxKsbg0DaSfHhthIvqJa94GL5pwphEB0booYOvkXaqQaLEG3dq0ebPN79zDsAvUuTF73ZRH6GAstKblP5+uCNpVxlVvupTEWpGPsoq2GbFbIZNXAOlqeddJrn7koIci2YSvhYh80YpSl9xHGOjvrTKT/5aAvSpyhpZLC0veRg+xgzG0tx/BfqcJ+Li56PdqH4i3VUiMRnFrSccub78=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During a discussion on the maple tree erase process and GFP flags, Jason
suggested there be an amendment to the documentation to clarify the
situation on allocations within the tree.

The added text is an attempt to better explain that the tree may
allocate, even when erasing, and provide some guidance on how to work
around such issues.

Link: https://lore.kernel.org/all/20260617180419.GA231643@ziepe.ca/
Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 Documentation/core-api/maple_tree.rst | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/Documentation/core-api/maple_tree.rst b/Documentation/core-api/maple_tree.rst
index 34964ec88d179..1eae24a9c18b4 100644
--- a/Documentation/core-api/maple_tree.rst
+++ b/Documentation/core-api/maple_tree.rst
@@ -17,7 +17,8 @@ supports iterating over a range of entries and going to the previous or next
 entry in a cache-efficient manner.  The tree can also be put into an RCU-safe
 mode of operation which allows reading and writing concurrently.  Writers must
 synchronize on a lock, which can be the default spinlock, or the user can set
-the lock to an external lock of a different type.
+the lock to an external lock of a different type.  Note that external locks may
+interfere with allocations in a low memory situation.
 
 The Maple Tree maintains a small memory footprint and was designed to use
 modern processor cache efficiently.  The majority of the users will be able to
@@ -42,6 +43,15 @@ successful store operation within a given
 code segment when allocating cannot be done.  Allocations of nodes are
 relatively small at around 256 bytes.
 
+Since the maple tree uses internal nodes that are allocated and has rules on
+data density, erasing an entry may cause allocations to occur.  That is,
+erasing an entry may consume memory.  Users must take care to ensure that they
+do not violate the larger system constraints on when and how memory is
+allocated.  Most situations are fine to allocate, but the pre-allocation
+support is provided as a mechanism to avoid trickier situations.  There is also
+the possibility of using special entries and clean up the tree later, in
+extreme circumstances.
+
 .. _maple-tree-normal-api:
 
 Normal API
@@ -63,7 +73,8 @@ success or an error code otherwise.  mtree_store_range() works in the same way
 but takes a range.  mtree_load() is used to retrieve the entry stored at a
 given index.  You can use mtree_erase() to erase an entire range by only
 knowing one value within that range, or mtree_store() call with an entry of
-NULL may be used to partially erase a range or many ranges at once.
+NULL may be used to partially erase a range or many ranges at once.  Note that
+mtree_erase() may use GFP_KERNEL on allocations.
 
 If you want to only store a new entry to a range (or index) if that range is
 currently ``NULL``, you can use mtree_insert_range() or mtree_insert() which
@@ -163,7 +174,9 @@ You can use mas_erase() to erase an entire range by setting index and
 last of the maple state to the desired range to erase.  This will erase
 the first range that is found in that range, set the maple state index
 and last as the range that was erased and return the entry that existed
-at that location.
+at that location.  Note that mas_erase() may allocate with the GFP_KERNEL flag.
+If this is not okay, consider using mas_store_gfp() and pass it a ``NULL``,
+after setting up the correct range by walking to the entry.
 
 You can walk each entry within a range by using mas_for_each().  If you want
 to walk each element of the tree then ``0`` and ``ULONG_MAX`` may be used as
-- 
2.47.3


