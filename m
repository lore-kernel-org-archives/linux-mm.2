Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60C76C5DF97
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:27:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 438576B00AC; Fri, 21 Aug 2026 15:27:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E9EA6B00AD; Fri, 21 Aug 2026 15:27:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D96B6B00AE; Fri, 21 Aug 2026 15:27:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E6A456B00AC
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:27:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 714218025C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:27:07 +0000 (UTC)
X-FDA: 85126259694.19.7E72534
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf01.hostedemail.com (Postfix) with ESMTP id E560540003
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:27:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=btUYTavh;
	spf=pass (imf01.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787340425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wii7sR2plTGuVvt+wvs8knQaryx0fB5P6mCwLY4qJzU=;
	b=JYWCFB8ewbDI8p2NF1aONyuGQeeHdd8dDPW4lJbBMJu923vvI47upt4IG3jTGwixK5vKEM
	cw7oqvywjYyOm6zUdbIdM5h7PVlV4GbD3BAN++28zzJj8hn+7xibzwMacg06PNTZAYcVzv
	/muQ6soKmXhFKiOiEmWJDnKI67NXqFU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=btUYTavh;
	spf=pass (imf01.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787340425;
	b=FY2VFySLeZ9hlrzBB2ZITk6KIZ2SfnuU28Ogmml/N6YpzA1S8b7X0/J8Vtjlnu5pS/QYLD
	1qzRqHgDPcc7QwX1q5h3YUO+69vpy44zrHIGlu+eeiX+gyVbelgMcm3U4UwgMS/dHEDqKn
	h2nLE1f2qrDBnjmUsSut++iTWHazuKs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Wii7sR2plTGuVvt+wvs8knQaryx0fB5P6mCwLY4qJzU=; b=btUYTavhOcn4GJZM9OGN+NX44q
	gcijcMEjrwA7RU/LAMHx7UFgipxnj/a/w8cRbP68UaWo/wbKIvdwUb00jmMCJX6LalTUc4ihj0C5J
	GUfDjTHV0m51Q7ZoLrcyv4Cz09SsvW8paqd+DbWLOg9gldN+iIJgMAegscP0Td9CRxb4IgXtqxi6v
	IK+vxT/pt7hwMZBCGxa4/UqeEVSnxz2WfdIk/ghg8M/G/sAf9QhTZasvYBbMHN9KiTX8fhKwnh3h+
	Q360dn2SYA6lKOf7KngOtgFoCIb7+Cwz4fZWDFcYKkmj2lnL1Yc3OUEdVjR0JezfCKcBZzw+W7sir
	GjDFjITw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxUtM-0000000E0p8-34rx;
	Fri, 21 Aug 2026 19:27:04 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Rik van Riel <riel@surriel.com>
Subject: [PATCH v3 15/19] maple_tree: Document erase and allocations better
Date: Fri, 21 Aug 2026 15:26:23 -0400
Message-ID: <20260821192627.4085470-16-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821192627.4085470-1-liam@infradead.org>
References: <20260821192627.4085470-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 91gc4ms4zqcuqngabr5gnqdoojxd557d
X-Rspamd-Queue-Id: E560540003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787340425-709559
X-HE-Meta: U2FsdGVkX1/fVMNE5KEu8Ikl7wv0r/BrxRv5Hr3XLWR5Ypck2rH6LSKJavzPZXeHC6DA0Lr7r6um5zvVm56VDuUpirzlTqJWbgiAI+GFEx3vtshNUQiggzceF7OxTFpVVdUfbIxDg2vJACZq8CToI3XZxe6sFmsn2yjKeE2yL+zSkA+8LgwwhPzBCOwiAdirl+iCYo8sRv6EGbro2M/oMSABXVIhx+xYxnRxg0ocbHoc8/2i+jXvl8giS2xn7HWTwdJYYOqsKKsxK8T+bf4AXKHHbWs45eNUVMdayPaQoAcflpxqCxT7og66TAN7kdj0yPCBqtDDByyuutR5+MEkJQrHyf7ebda0s7a+zprIgLwLjzrpvO6/R7cTL2umlkSn+pJu47/KvUmyzvwfLk9b0gw3Qu0VxqBlbAof+HCfGwK96LAJYmeAEOhnNzLk1sH8Ac9xMo03gTqTRRA5Fn2DnF4GCfWHvbNc6l3e9BnUj9DDLJwv4EHD9nTOYhwY23VFXzugHkEof3h/GwQaiN1WDqeGVWSR+6knK86nfmB+9S8RNkYnPmmyLLDqcrGNJoI79tnr3bYpuvkeJe03C/rRTpf2xql11tmwOMPo7+ythkHq3fxWF+tF59IVpWdjWP3WxDReSBHqyd/n+vXDGxx7EE+BSfJeX0HxLSPekCPjmXTFpSqSDrb7JUO1Ly9GG4rh7gt2ZrlnWxXmeefur9EkqeCgW8iDFZFvAzFJu4sCJJ4Cu4Q7C9qcyzheyCzQiHB6E1xdhL71HRtSVXLJxlUv6zMVvyqc94yKbR0zgjKjQMDwCqFDX5I/7rdNzno/Xp5fHMRixPVhtjQi0mPSO/eTyPK93PEoPEPiD3kulhJHwfJjISmIr1DP9ka0lWhyFG3/idL346jYwJUwftcAAG8GIBXX1q4bx3kn06NcI73ozwNlQP8ebw5bDP9UydrdhqewgaYUNY+MY/tz0OzMsgD
 CN/Aj64c
 JE92Mh5XGsr73kD/I49K506ecLQwWtJYZbO3idjGA0duvfFFxbasesrvXLyGqeKgyKiqJ+TOiRsWEzBOHgaGIBMs7JYUfGKHo7EGBu+nw4KxH0MawKzfjUPVztxF+3ncn/4F88rFSv7z/oT/yYl6ZQB+QY3rSytKAwHCAD+hr49chap1ah9Dm36yAYEgrxy7SmLUViegaqH/D21i89KhOlNwH4XFE2UG5txctedOR4v2JPIl/gwIOOaeN4CSdwOL6iByNVz3XtyF1dy8fiKH4kHG3lR7Qn0dFfzHaiwRsVKv+/bo4eGNwX8yo1K/tRXi28A3xEfQMrABc3RbCuTC2tXAfEdeoL0LwwxGqFu5Qzk1Tmfe2MHJnrd7ESSxNMLqNpnPjb2WvmtSNVKcw6PxQDzYKVTHY7fAb78VKhPWFe7BtrWFRLSLGqXy6Cdp0/o2DC4s87tRImw9lxnKmQ/MT5oqD7zUNM8o0q3qnWCOMORcx1Ac=
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
 Documentation/core-api/maple_tree.rst | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/Documentation/core-api/maple_tree.rst b/Documentation/core-api/maple_tree.rst
index 34964ec88d179..9b08a61131e1b 100644
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
@@ -63,7 +73,9 @@ success or an error code otherwise.  mtree_store_range() works in the same way
 but takes a range.  mtree_load() is used to retrieve the entry stored at a
 given index.  You can use mtree_erase() to erase an entire range by only
 knowing one value within that range, or mtree_store() call with an entry of
-NULL may be used to partially erase a range or many ranges at once.
+NULL may be used to partially erase a range or many ranges at once.  Note that
+mtree_erase() may use GFP_KERNEL | __GFP_NOFAIL for allocations and cannot
+fail, but may need to sleep - do not use mtree_erase() from a blocking context.
 
 If you want to only store a new entry to a range (or index) if that range is
 currently ``NULL``, you can use mtree_insert_range() or mtree_insert() which
@@ -163,7 +175,10 @@ You can use mas_erase() to erase an entire range by setting index and
 last of the maple state to the desired range to erase.  This will erase
 the first range that is found in that range, set the maple state index
 and last as the range that was erased and return the entry that existed
-at that location.
+at that location.  Note that mas_erase() may allocate with the GFP_KERNEL
+__GFP_NOFAIL and cannot fail, but may sleep.  If this is not okay, consider
+using mas_store_gfp() and pass it a ``NULL``,
+after setting up the correct range by walking to the entry.
 
 You can walk each entry within a range by using mas_for_each().  If you want
 to walk each element of the tree then ``0`` and ``ULONG_MAX`` may be used as
-- 
2.47.3


