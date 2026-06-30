Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FD4BC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 19:09:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B665E6B00B8; Tue, 30 Jun 2026 15:09:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B16E96B00B9; Tue, 30 Jun 2026 15:09:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96A386B00BA; Tue, 30 Jun 2026 15:09:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A4F56B00B8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:09:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF21F1C2F58
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:09:16 +0000 (UTC)
X-FDA: 84937517112.25.574B255
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id 410CA140008
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:09:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=zKzxyqWY;
	spf=pass (imf09.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782846555;
	b=MsR72Gvy7dDG56TCIypb5gftvL+4SW4hEGl3hy5JQYVeY17s9EQ+emL/MLqnKzX3E5JU+e
	vtvUgSyhOlNnHR7xv614kqxZlAe84GknYNz4u5MfQiNljc+BKEs+lZHVNhSbPT91WhVuXn
	60Xi9eXO5MxBh6//+QqJjCx0tovQmPQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782846555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gMCtkKiPXNatIx/oARhOfW9f2EsZZ5KbLO+FulENZEo=;
	b=xgKWZ0b16f/MqJosdy7cUk8awKdeal/Fen94+kXzXXYKU9xGBPvEVe6xZEBxzW24nq76Oa
	mhbHX4hVubEWqX4CEDSYllhJ+qCkdJ6RM/WIzemG6UqhCEpZBj8l7J4Lw6loE7LLDq0DYp
	Dz0nFx+Zcj+Jats56rCybWX0U1luwjY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=zKzxyqWY;
	spf=pass (imf09.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gMCtkKiPXNatIx/oARhOfW9f2EsZZ5KbLO+FulENZEo=; b=zKzxyqWYBsS3HfIuf7wROHE6fg
	scsmf3dL+y97QPgF8cVZXoovQ8rWaR9a2eSJzzzKjB3jBv3z6vhFZ8JLJJM1EgdQToDTKRs5zTj+f
	zWiJumVDYO9LSuX0X0/dwnZser2WwBF1Ai1S1aHpQNbgkum+VFuq1rgLkg+6rZg0QsDdKX2id2wAv
	Qc6S0uiTwIUi7ptlHk5UWvnObh26Ow0WQkY8DbD9PZk7Ot+KtV7mBueWfYzuo8FpGMSdP+slHvQ4N
	JnDFyRGJV1C10oQ00rScimOD/QSOdLO/UV9BA7s9H/Co94hgBsunjLmBzmNUGuUjCk6wyjtv5MXIO
	AcYdtnKg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wedpa-0000000060s-13lK;
	Tue, 30 Jun 2026 19:09:14 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Rik van Riel <riel@surriel.com>
Subject: [PATCH v2 15/19] maple_tree: Document erase and allocations better
Date: Tue, 30 Jun 2026 15:08:39 -0400
Message-ID: <20260630190843.3563858-16-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630190843.3563858-1-liam@infradead.org>
References: <20260630190843.3563858-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: hym7hogdji8d8qodxabj3isypg4jhm7n
X-Rspamd-Queue-Id: 410CA140008
X-Rspamd-Server: rspam06
X-HE-Tag: 1782846555-130318
X-HE-Meta: U2FsdGVkX1/Iib8HbfBbcaurS/ythWZ7EjOMz2Y606ZWFYkKoZXJ/u2J9NUyNuBk4Ba5RAqKtD4DsmEhZXF60JCTSo0+OqD8VYwdfFojfifSGusAzGGlafUM5HOdL06yWJw8s1kKXXVpL5jybXXXQRiuPtihgl7rTkoTRxp184ZiVN3XV6L3z2VgJD88pscD//I5KBwZeUgMxe1a8ZCkkitpU5uP6oXOhJSFakaKB1ngkfqvkwGqOqaqKZZkAFItd4l/yIEHKsk1mNFaBCvjoo7lDYiIV0JelMMOo51B1Zib1cw1bpIjwg7vWHlSBQh9wOkFYia+r/FVXWfuAGzfDMyZDAIoxo8s9bwpa/pMME4NXbMU4XYeUYXAzuN7XPyxsR3JuTUimpMi/cmgIDV+J40e9F09mvG5pOmzn/fbZPm+HgQr2YK3QDGZHtMXl8TAMqMSM7ZN9nW4eWNnPI2Bp37RzLeEFgdVU41kIhwsen1gUUQmaZMItIDr+eiUmHnplQCAoC2yV/u9wH3LhT+2V+UH7wKGGfNNP646NnJ52DTZ+0qES0Cs16M2/xInVrA2GRvvWvWzbzC9WEh51sYNlubC0Ijq+0MHeja5maBZb+HsHWXgb9dMU0vMUtqUYEVDXD+xe87Xh1d0LFUF58viL4nt/FPPNIuHFP7dD+mpdemy4t0UmjAr8OX0O70KLirGsAxD7rzQ9ZaH2utZC6EjOyR3XpQWXo5lTObqh6GPhryMjDxFmCcYzHWWm1W05ldkQjn7qUvOoJOciSCLt/FeJ9X3w0bZ+XbRyjHYiLNyMzqxGArAKjJGM6nkuMX53QaP7cY6KtkV7MUJRij35jPAtbTEhp9hzr0mclUqPmwgO5cVraTzD32AI+HQNWGQBj5St9Rxl2kyaV39WrFK/mum861uMhaAB2yU086D5eNOR4HqvvH8tm7EEtnNPPBB9C9OidgTex29otuRNP8Iy71
 2xQBH4Pm
 oqcGmuolJcX65rxoqssv0eAoaQ7dmWIRYihSEd4TzgWZF4L6XcrwkydCqXLTCqnwWx04mFCi2ng2hu8+oQBHts6LkSfn7lnBIeh1tkXjzuXIpnfw88B+fJ+8iiJvtfV0TGZdp40g0Yy9PJmqbCA56KptQbVWoH7hadPHeSY8cca848lV9ROEiFMNA5YNTnvXocT76FAwrOHHx3gLMlAh+32u0xiuBwcppHB0nhuPEc39NmAjg3dUtPm+ooqkzl59h9JGHmVG6+mu9wMxQ89xY80vF0tculq3Amu+YNinnv50ISLPkLc7lUpxCDF0HeXrAasEj5Tnd1yZngruoz4/vWFZiTIOJm9I/4Pf5n3OSmadwEJj9eKaK/5pAtsbit6Zj/uEXhM7jTJy/nwUDXM1EYJGI7AG7KNWHV6R6uCqqzh43B3aBvj1rGsiPWFziTBsw5ameYmb7o3MnJoZohHPKwe9Sdj5slouPYta9QB7V4j/K5Oc=
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


