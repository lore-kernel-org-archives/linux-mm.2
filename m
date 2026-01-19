Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62F6AD2ECF6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 23:02:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA8826B0310; Mon, 19 Jan 2026 18:02:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5D036B0312; Mon, 19 Jan 2026 18:02:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6C4A6B0313; Mon, 19 Jan 2026 18:02:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A33966B0310
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:02:12 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 412221A02F5
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:02:12 +0000 (UTC)
X-FDA: 84350238504.27.C8BC7BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 91DB3C000D
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:02:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kLe0Khr6;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768863730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OGlr4CR3HE26RPwTICbiLHyl58bRcW9pkYQf743lRCQ=;
	b=4MZG2FewP2DZGsIJiA9WdVcMVIvfZbp3lZl+keUtaAOC9kbsYhsAUwiIxtRgNrqEw9krc9
	VwxkYChhnS2NJP3lzZxc6UPkure3z4Xfd3kSnURy9c+52bCmUIdALdKLnPR1/eYxYS6HTf
	r6cSVO/u98ZCjHTZ8pV7jiB0VlnnDYk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kLe0Khr6;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768863730; a=rsa-sha256;
	cv=none;
	b=2LfLiOr8MdMTv7kiZOcrp6jOSWuRG7a1K7kNdH8Ijue/3Snvr/x4Wey+pZNaq8O72C+jtw
	ggUBzO5GrU07q6Ox02uRWlZuMM9f9s8uSC/IvRPOK0YEsyQ8pi8aQ1eGuMqujzvImriR5e
	BwwQFc3cyDNTJGAv7c1XUbSesW4LQa8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BAE984441F;
	Mon, 19 Jan 2026 23:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DCECC19424;
	Mon, 19 Jan 2026 23:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768863729;
	bh=9pFWzYgZbt+YY9kTe1GTcdn6HTneXxM/S/odovyu19w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLe0Khr6DuCvasNoS6kxGtkTGY8Zw9brt5gCInhq8gLS+Ma4hsIx1369nWwQX1Tvf
	 IB2XumFvNDI5jcl58bu1+Pu0ZrCudk7hz7m2H9Ax2cKzotO5pTZnVWOjCHvr53Owh9
	 wWCd3vv1ICESWBRIUrkH/QL8obmlOab1LlCb5uNL/xCEid0Q/hukDlzNIqcI0jUX7I
	 MXYVPdAj/l45N6hoQMjhpukfeniE2KS3T4aRad/4Kfdv+ujJfbonv7OhpZdUpJlZdD
	 v88zh6Y7ixYKz5JxWdDwhau0K/zyUQfHaZMYxvUzxiNBuApA2jLrvXlMoViRemVpHh
	 F+IVwVmTXgxow==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v3 04/24] mm/balloon_compaction: improve comments for WARN_ON_ONCE(!b_dev_info)
Date: Tue, 20 Jan 2026 00:01:12 +0100
Message-ID: <20260119230133.3551867-5-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119230133.3551867-1-david@kernel.org>
References: <20260119230133.3551867-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 91DB3C000D
X-Stat-Signature: up8cq8si8a81prsc7ap96fpmdrd7ieot
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768863730-526738
X-HE-Meta: U2FsdGVkX1/sR6OVetEWga8dl1KBqjWEBD3zXjw9c9vTi5+u/hmhpJlNWAtcu611sug0BW6kHFIua9NbP62GKLuIC0le73TLFjxHDC8C1NKRaCmMjsHQEsQS9+gC730xeeBiKijlLkOOQxXjd9x3Kcuo0qEfvYvA3rejeSDXr3Zo36HH0UW46YU+PMDpmee1e1AC1SPOs9LHH6ufL1/V0KZvQNKS7QKT9i+jMZHG+jCX1CrknHfuEqBBCbBch93k5llZwOXHRRJZt0kMvEZnfk/FmJkjG6EpXYd6MeLVk8pJUnK/NKGmFqBABQyv6aMoYTF2KsnUDcNjdp7pN5NRLHDQruaWmvyk4jlBJLKin8ZgcNCavJAvm94PVYFARdkCyCYaBw2SN03Ee0YTdrxiNgkYCZEzXxbEqarvgCLjV+D9RjfhtlrkRLMyCBts/5tJJGSLqQ6LIRCc76IFZFDsmTIkrMOk/pDv8kL4y84cw85rteygPM/VfcLixP4EpqCmA4a0C40PPjOhFO3JEfz8L1BEZ/rpZQRi2m9fUgOtIoneoe0I6ryPM15JdHTqN0JpdG9TyKM+ZAyjrKVvXH6WhuRg9SST+JfaiYiKwYPmyLf0p4w45lU7+9ReFuBxHHfy1lhHe5sgkIqLwFvbQwnzNqyt7JRjVNMmHUOSw8sIhyxYMQ05TvF3rFsHlPQ5eQet8qPA9vFaltmMe2r04JdfyBwb0yYYR+301cb+M0jl5UfEbt7aZhe8oXEpxFwOxrrWcQzcKokOFYe2zYNC8jF3fw8SUfctnE74wQwpLBLSVBuK8xIqRR06ezku5CXwG4pQJRQ9rgWZ2MIs9yTqXDyL5ig6ro8jv8BDoIZzENh7zM0GYAOlhjLF+UTdbKklIAaZquaIhVTkmY49m+9sXWXrBptlQOrhS0hbBTC0+Ql4KT9M/5cbTB5fZzBgK4U+b7FnG/U1ujR/DuOFe1DS6j4
 AkJeUjpp
 YF+9bBSwKM7QfhK/7M+h3GSlAHa+iFHco3m8udCGn56oNY1F4ovR+v7HGSoc5ZCxBbwqdcbcj3zzsK2ou2RPdz8wXO0ZepB4mmm46j8NH69uIBGSXTmWxVMi9XfS4/QKjm+CsU4Nayw6eDiHokhC0aFCfBHxDD2a8tSmBMDJxiD9K0tUm+i6/12bZt43y4UcgouK8VTSepG6UFDEO5U9H+yv8yI+x+ZOI7YCJ4M0qqPlycTBwC2eUI5dccXWUUDYQaxKRsxaQkCJvv4tQYQalC03bipk4vxRRgplj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's clarify a bit by extending the comments.

Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 mm/balloon_compaction.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index 03c5dbabb1565..85eea88cea083 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -222,7 +222,11 @@ static void balloon_page_putback(struct page *page)
 	struct balloon_dev_info *b_dev_info = balloon_page_device(page);
 	unsigned long flags;
 
-	/* Isolated balloon pages cannot get deflated. */
+	/*
+	 * When we isolated the page, the page was still inflated in a balloon
+	 * device. As isolated balloon pages cannot get deflated, we still have
+	 * a balloon device here.
+	 */
 	if (WARN_ON_ONCE(!b_dev_info))
 		return;
 
@@ -241,7 +245,11 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
 
-	/* Isolated balloon pages cannot get deflated. */
+	/*
+	 * When we isolated the page, the page was still inflated in a balloon
+	 * device. As isolated balloon pages cannot get deflated, we still have
+	 * a balloon device here.
+	 */
 	if (WARN_ON_ONCE(!balloon))
 		return -EAGAIN;
 
-- 
2.52.0


