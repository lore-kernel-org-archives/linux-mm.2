Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87CB360A2600
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cYCVV8A9
Received: by kanga.kvack.org (Postfix)
	id 7FEAB6B05CB; Fri, 20 Nov 2026 05:34:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AF466B05CC; Fri, 20 Nov 2026 05:34:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C51A6B05CD; Fri, 20 Nov 2026 05:34:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B6546B05CB
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:34:56 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D405E140E2F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:34:55 +0000 (UTC)
X-FDA: 85455139350.30.8931EB0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1983A80004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:34:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cYCVV8A9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795170894;
	b=MkBOiTo/hVjap+dWqnKkAAktj4lx8j6irkqLd+XJKLkiyHSADd3YYKpDhqtQzNLvJ8ng9b
	6TGqJp2DL+9z/Z3f9Y7EcFeWQdO0i1JH+8znn0af03wd6vHin46+a8PZTul/MoCFeoF+MZ
	YbklOadUl0GvAEYn/O6H/bJ/fGY5Qj4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795170894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NIf0XC3unLIGycPwy7b+8DZLYvzuuP2h7PHGv9TP1/M=;
	b=vGyQgoW8nr+Ge3n7N/5Hvp46DR9lXjuNH7a541BBzv1QAffDomr8geF+KjhvBJmS/mfbZk
	POYfJYGotQ6vIAzNtwzwHElMazpCSSmvTf/Y53JkFvihH7lW66Q0DIhxaLSCFCCAjEuu3/
	bHDwjvJAZf0Wy2z3HLnEdkpRZQWNwNg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cYCVV8A9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6444B4413A;
	Fri, 20 Nov 2026 10:34:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB861F000C0;
	Fri, 20 Nov 2026 10:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795170892;
	bh=NIf0XC3unLIGycPwy7b+8DZLYvzuuP2h7PHGv9TP1/M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cYCVV8A9+VIzoDC+yu27UtvyOkeEBh/LkrShUKvOzSV6gdELr4bR9zKDjRr7ukwDk
	 aI94LGBto98W4Ux3nZAmQEzNyUf9wDyg/3oTxuSBI+Osh3WMQW3tbpvz5UdgTC9Arq
	 oJuzOiFnuUjACdXUQQm4NWe9KP/lfH4ZWn1G4VSEi1n5m+IJH/Dgu8Xkgr0dDuiz0u
	 /4MNWlevh5cct+TBF7No7uYC1sA0l9cybd8kg/sKuWdDnasl/UZ5wy6hvHf3Y7Y8Fo
	 hgfqc3bXqgAHwLxDliDWViJ3dWFmU5i7OuY250vD/xHHRQF6s1Mnb/bETCiwujMpjc
	 OQFOqzoelLBMA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 20 Nov 2026 11:34:42 +0100
Subject: [PATCH 1/2] mm/balloon: fix NR_BALLOON_PAGES accounting during
 page migration
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-b4-balloon_nr_pages-v1-1-d8944b587819@kernel.org>
References: <20261120-b4-balloon_nr_pages-v1-0-d8944b587819@kernel.org>
In-Reply-To: <20261120-b4-balloon_nr_pages-v1-0-d8944b587819@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Nico Pache <nico.pache@linux.dev>, 
 Jerrin Shaji George <jerrin.shaji-george@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, virtualization@lists.linux.dev, 
 linux-kernel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>, 
 stable@vger.kernel.org, Shao Mingyin <shao.mingyin@zte.com.cn>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1649; i=david@kernel.org;
 h=from:subject:message-id; bh=lfRg64mzDBRbG2+tSqnrBIxz1wpQE4OfxlTPZhj6dXA=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIZlFzvmUVNk3WbFv1t0iJTzl3n73w+veTfqeKlu1sed
 u8Nzrtt1FHKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBEihYwMqzdcSTi0pXW1Q/z
 t4sybDu834vz07JlJb8fVb6/Hv6yLLic4a9AeeHVtYs1dzhde8PR7vzWIIBF8tkb6WnfFnOfFAm
 40MsJAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 1983A80004
X-Stat-Signature: y93srs1mwabo59cxh4g9mohhy9hn585p
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795170893-594244
X-HE-Meta: U2FsdGVkX1+/63YAn27DmNSeTdHFdfHfezY+n8HIR+bYvmytEUGYh3ChYbX8AkoqtC24D+7YrznrUWkUpGXJmNKwmmkFgHWYl06Oi5Xd0M//cmkYavsPM6PP7mrh8zpU8ckNer+NmT5vrE6gW4dT+jtBJSJlpq6BgFFPd6gy2pk+GIPJBdUhFu6Lj7s2tgnhYZ0vD+DabqKiHVx8wDTPoVvVMXQQ53RXq6p4mvjuYGtnCDN0NVFqbyXV5kQYpQwwoTaUgAGUH0W0NXWN3PO93mwkE7G86sU5jxT5i1WatObWf9AQji7E5jSX//gEEzuxlzVUbTbYYpUI8iB7y49CTjYsuVFacKDz939A2MyPSrVEsFaot1Ymoy9xicQ23AOPFmy8vK5LVkx1KKb6mqkeyvf4vasVuK+9yGZ5f0gFd6DVRDvgZZS+QaGSx3oZDHkwkyHxDj2ecZi7+XWaahh3bvOta0kB9x4EGpdUlDDWBhhLAc2NtuGCiOSm6KW/wwJ1bT8TrR/BFfGtcNtnWTcwjuLKAUH2EsmtNuBmH0KfR/n96tLtvnEvKdSH4S5Lmr3ykV/Jm6U7p0fGSNVT5kiezMH94D14GfOOaqDPcmZvT4nWlPfchizyCRIiAENPN0MSD9cAAE5m/bEjcZINU4tc9mJFlogAG9mcFFJWYjSlBiqYM2WeQ43Fjw7IWkXroXKMQk9+PSPrBUKUWSHMqvWgP5e6SqAwajOBXRKUwKQ4MTlqJo3vffIFChOB0ujvGQDLhb6k2c3o3r9kGlOIAHybIX94GiR1Vu3TH+ntfKWe1uI1UtxSL+oRtiGe25ze/4T8/zb3144LqB9cTGldQs2P9/LB2cZ/9Ntnww2LTLKxmhb+UNQHjFkiMmGE1D4R4LX6yNlaY1SPIA0hU4Q+cp3XncNY46mdPvicPdTY4QW78w6Pe2TNnPkTIg8EHcDKcOdPb231y/JPa5AAu/lqFZm
 yG4wVb56
 G1u2ciLP6RKIxFbZ4AfXbbKr3xWZKhdsHoPwMlqSKsSJuxv+y74wrxCEA3/W6X/nlf7Ik1boDOvlRKNmBix0dC1N5X50+njeY63R5KXnJEkhcZm735/LJIMclIlaj6W7L+K5tt4bQOoMCytI/wUdfEBsOnJ6saECoL7SDSeec2MDK/gor3KGpNQk69I2D6j+plCZH+sWnnTT+qWUPO0UGKCvtJ5zZr8un9R7s5+FscWyNT7F9NRA+lQdz5pSekdtmIukorEunE8Kv4OGUcCOrly9kpe2HB5kt7Q88ei55PWEo0006bjgDLCCjMRVwyLGu3Wr3moPs+7cglRK5CvYraK644fqd7QbUyMC0GXNSsY0LlcnHnDmI3JH878n96n4RPv0x+XRRSK4EUzQUcQAcPXWrEh67656uOfawM235n19meUyFuOXB6+VVeWJ1Yb7UhExssbLyfusaOl3CPUUziANxM035ZB488Bx1Uo28uOZAeuCV3+xthD8RmKjLN9m2xbrCX+IUPm9LW0PDbAl2lalq6U1vC7Utt8dTG4wD05K23blBu02XjlFAnQGFTtoFMQGhVIrU6jXfJaQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

balloon_page_migrate() doesn't update NR_BALLOON_PAGES in two scenarios:

 (1) If the new page is on a different node than the old page.

 (2) If the old page was deflated but the new page could not be
     inflated, effectively deflating the balloon.

Consequently the "Balloon" values in /proc/meminfo, the per-node meminfo
etc. will be wrong.

Fix it by adjusting the "Balloon" counters accordingly just after
conditionally adjusting the manage page counts.

This has low urgency.

Fixes: 4d689474e1b2 ("balloon_compaction: update the NR_BALLOON_PAGES state")
Cc: stable@vger.kernel.org
Reported-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Closes: https://lore.kernel.org/r/20261115004708909xx05JgB9nXnOCG0zL7h_K@zte.com.cn
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/balloon.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/balloon.c b/mm/balloon.c
index 96a8f1e20bc66..b31543dd4d4d2 100644
--- a/mm/balloon.c
+++ b/mm/balloon.c
@@ -310,12 +310,17 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
 			adjust_managed_page_count(page, 1);
 			adjust_managed_page_count(newpage, -1);
 		}
+		if (page_pgdat(page) != page_pgdat(newpage)) {
+			dec_node_page_state(page, NR_BALLOON_PAGES);
+			inc_node_page_state(newpage, NR_BALLOON_PAGES);
+		}
 	} else {
 		/* Old page was deflated but new page not inflated. */
 		__count_vm_event(BALLOON_DEFLATE);
 
 		if (b_dev_info->adjust_managed_page_count)
 			adjust_managed_page_count(page, 1);
+		dec_node_page_state(page, NR_BALLOON_PAGES);
 	}
 
 	b_dev_info->isolated_pages--;

-- 
2.56.1


