Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3DC8606A331
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 08:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=daXaBHZA
Received: by kanga.kvack.org (Postfix)
	id 127E76B05B2; Sun,  8 Nov 2026 03:40:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D8496B05B3; Sun,  8 Nov 2026 03:40:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0C206B05B4; Sun,  8 Nov 2026 03:40:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C93806B05B2
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 03:40:44 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5B664A0449
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:40:44 +0000 (UTC)
X-FDA: 85411306008.24.9521D7F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id AAEADC0002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:40:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=daXaBHZA;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794127242;
	b=nL6+U36dwvXJzEnz3SGPC9QOfTz7ds7ED02bbgaKb5lR5BwK4JTF2paSLhPfkVNnHCBRVl
	aOMaezYoWvJLMVcuEtvwTe0XdxyTf7e8konfSOuMoKtgxrA5jCFym02O3gXfkNin+8RpZs
	O/e4OZmdev+D+Xo1Pj6WoA8H2dJtON8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=daXaBHZA;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794127242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zIOVRWimvi5sL6RvvcGg4xNjH+GTSE/6lJuUuXwnf0M=;
	b=zj1KcgnQ9WW6bxN2+nxtcuzctOLF+EoxpE0H0JxQgkcnl5wLi1SwgMO1VR3uz7gE7bHveY
	uGcYUXL60r/HYuckfZ8UfhWtBL1MyyMQIlk/MuH42fhe425r5qSfuc5STPFfx+kvxckXW/
	C7XPa1ZvqccTd7tqSckEehfaR6+cteM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D610F439D3;
	Sun,  8 Nov 2026 08:40:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED871F0089F;
	Sun,  8 Nov 2026 08:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794127241;
	bh=zIOVRWimvi5sL6RvvcGg4xNjH+GTSE/6lJuUuXwnf0M=;
	h=From:Date:Subject:To:Cc;
	b=daXaBHZALBdtiBs2E2dTVw58NYJWaRWQ4TE1oinT0rExsydmZqpXJhKv17+2WKsIi
	 4b54+A0StZc/5OgM1CUgn3xr6uxI334upHw8FOA4y67pTUh32DjJDARFKY5qN7cVif
	 SPoobMJNmoVRLjWHEcUJgNumK6ikdU+LThlkvPss7CAA4SQ8Dn+hXlgZCMA3aioEmj
	 DZiHJD+tPmHkiIFV4AC0vW8h0/uAOXOEkU7HdDpPuxWPeeYZHCFsvqF9AG7E1h9bj9
	 SC3T+ajpUzpDj6FNfnVfw2Fsv/IPWLY8pZ8+1lcOjqtcd6VaC4avJsimpLU9K4VjRE
	 Y6U4P90xmfruQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 08 Nov 2026 10:40:36 +0200
Subject: [PATCH net-next] ptp: ocp: replace __get_free_page() with
 kmalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261108-b4-ptp-v1-1-71160700886f@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMQQrCMBBFr1JmbbDGGsSriItJMm1HMA0zUQqld
 zfR5fv/8TZQEiaFW7eB0IeVl1ThdOggzJgmMhwrg+2t650djB9MLtlQvDg8X9HhGKHKWWjk9Re
 6Q6JiEq0FHv9H3/5JobROcz0qGS+YwtymRXjidHyhFhLY9y/Kmt8VlAAAAA==
X-Change-ID: 20260624-b4-ptp-ed56a38a6afd
To: Vadim Fedorenko <vadim.fedorenko@linux.dev>, 
 Richard Cochran <richardcochran@gmail.com>, 
 Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: bwxnmrrsbcr99rj8znqqx51un43kc44r
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AAEADC0002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794127242-78047
X-HE-Meta: U2FsdGVkX19H8bYfAVr3BV2CYjzN6vT9KGNn6611rkuJCjOQjrKcSfHCPR2Xevpz/A36NPzqNJoD/ZMUiBPsVfa+/NrHEAjpa5940Aoqbuq3qgYBNvTM32DVAH27eBl4CgHhqWEJX+txVedww0Sc05XzSps5p6Ba5NLGINqTbDpw0fM4m98Za6D3bOyz40Zu0ePr9xR6AWWpIIDl8+83B25/Kzhv3HjGL7qGtq3W/XA2gPc5XUZWCDyUPyv2iJ7LFoD+1s87CtNdqHm6NkpN3DPiSeg0WcFHFGht8e3MV3ntvTfBIPfh8uutUTPOX9KCY940BEPgwe9tY0slElpP5z9c/bb4Kgr/wR1Lnt3G/GEY7q/3i7Zf66nJx3ga/AEEjhh/U18p3GYlOHfMXX4NW8k79ARTgquC/B1SjDN7WjkTYHED33Pqd5t2vde4IKm1hlCbZt1qTh/mIeD489USZNwtsZmGCZXKFfQz7vvdA4fWB12/tpUvsCzVV1E1t87jX5TGJyqIoyKgOYtTYwpnovN8ZOh81Na4PDBFlmVXzhWi8QEeS6mZgbIi+FkgJG/ZxBZrASaOK+4Wkf3Lp3dZRCAenvp2vaP08A15LZCyfArURUoBxTBHkXHvRxHULLJTsSNsXCdZAPo7D7shRHTUPdioFGyKoMuBVdynduIp6lgKFuzAYxErekp/zcaS/2JvPExjvmYqbREN85EGa2QFZFAQyatN5PWfbGheTwU0Ctv6CaYxnXfMRs20d4zZUbmQjce3Pg3b/WtNwoGaT0rxiMb6GIz9TMhWbeLI5t+9rjetIAvjJ/O45CKYiqvRuzCX47qV1w0LiRWTTaNpykaKeazuDwDZJD7o3wzFEiDs9xnp+VouS403GSNnqSLJzbH7erZ+sVc7QorOc958sg2V6DBY9sogyh8syvlB1oK96hlfvfnxt5fYXTn0c+vUodFu4Rh5JlXchz+8FgZtOw0
 g8gBytt0
 OIDmX/rl3JzTN/zJAdQHVJYpDovF2b23QQrIrh9aiZW1v5oYaqU7eZMyOgZb4Ha13xV3/VUjLA5D2O0zy1pPIAhhUzK1WGVaMNPeYSpvVN/epHLVeYkgbWz0akc2Sc8NX9EUYVHaQowSMpd8OUlVDCqNwv94bNhP4AdWwWHpUcnOLReF3QyjW6oXBxG34I6f8jb/nUi1aZUx9hRyIysfOnuVg++Ehe10WrZtelkIax6vvbbFoRNUo47hY78chq187jj5EXrIbUIuabxNvnJLAuyJSI+R41ZGw1ocmQj7XhGwKcxusE0kyAHjQ342qMadVWFNTt7+p4asIsABEXCQMMNzge1ZBf+0aLPsOegv6g1SvEK8dZMgCv4fGNWTFXdjBzRt4CKGy1sC2yYVLtIPg/2pfEtqP9WrAw3+rV2heSjlscT4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ptp_ocp_summary_show() allocates a temporary buffer for formatting
PTP OCP device summary information.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_page() with kmalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
This is a (small) part of larger work of replacing page allocator calls
with kmalloc.

Largely, anything that doesn't need struct page (or a memdesc in the
future) should just use kmalloc() or kvmalloc() to allocate memory.
Removing needless calls to page allocator helps with memdesc (aka project
folio) conversion and gives a nicer API without casts.
---
 drivers/ptp/ptp_ocp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 625a85b2dc7e5..decc56892059b 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -18,6 +18,7 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/xilinx_spi.h>
 #include <linux/spi/altera.h>
+#include <linux/slab.h>
 #include <net/devlink.h>
 #include <linux/i2c.h>
 #include <linux/iopoll.h>
@@ -5281,7 +5282,7 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 	bool on, map;
 	int i;
 
-	buf = (char *)__get_free_page(GFP_KERNEL);
+	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
@@ -5497,7 +5498,7 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 			   post_ns - pre_ns);
 	}
 
-	free_page((unsigned long)buf);
+	kfree(buf);
 	return 0;
 }
 DEFINE_SHOW_ATTRIBUTE(ptp_ocp_summary);

---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20260624-b4-ptp-ed56a38a6afd

--
Sincerely yours,
Mike.


