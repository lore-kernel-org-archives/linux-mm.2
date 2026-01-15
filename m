Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F573D4114B
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:22:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4DF76B00B7; Thu, 15 Jan 2026 04:22:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B22076B00B9; Thu, 15 Jan 2026 04:22:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A17A36B00BA; Thu, 15 Jan 2026 04:22:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 91B746B00B7
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:22:44 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5EEDB160282
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:22:44 +0000 (UTC)
X-FDA: 84333658248.25.67A346C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id A1F44120002
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:22:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O8jYzSQQ;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768468962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vqJdNUKiAh1EO7rwT09LrhzLOCSfFprnsP6lu5Nv5fY=;
	b=MMv6Vl/00PHswhImIn1JVIQ803ysaRpF6Lr9MeH4Ab9qxG3VDLTuEOgfP6mFZr+ai+ByFT
	SjbGKMRFC68p0ZU9vjK2hzL8rEN3tri7k2dRSezT/GED7CvimYyRJNSCYdU9OyPedx1yob
	zEOwQK7zG2IL5d0BCPE9NCxPf8KAH2M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O8jYzSQQ;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768468962; a=rsa-sha256;
	cv=none;
	b=qv5rT05lyhuSq9d3MnFdJ60SLdEl6dYziT5i/NAKbWP+/i473wvdBOvtX9HfPY3Y3OGFGH
	bMrbxE3U3Z9i+rirwh7HUBF1k3R4hNktBZowxnB81oGnrq9oHquaWv5cwfuvFOyeHPy1lZ
	1thZLR6UFRE8ZCY8wClsqKZB8iOJIG0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DC51E40658;
	Thu, 15 Jan 2026 09:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 948EDC116D0;
	Thu, 15 Jan 2026 09:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768468961;
	bh=nMSbJ130FsUcdSsvFUeUBR1YMlPlSjm9XeIRM/kAkzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O8jYzSQQhivp9+oi3e+25bY5iCyiGPyPZY4Q5d6BT6vIFTT2h6LTECelzgIQUwBam
	 xm93YDpR/+tfwHTtSoZFn4io0EPnm7MXDaUCFJBiGSmOzZEsonSTnTAxHsKjgTmePs
	 H1WVZ6Ru1nLs8fYp2MEhnZtBPHrn7pIJQJ4NUvjSZQzddO+dTHGoMvFy05u0Yzgkpg
	 9S7YHWca/kqlFCmPhigeFIAT6icw+tMlOJZGExUL4+q8ikAyOvua74wdBt7xThNHPm
	 pwqoKl6EwJ/Zyx8ks0VFdx3aSfDNXWYRAOTML42Re/Qkt3iA/jsQXyOkuLXfvG+dA4
	 H6XnATH7JX0Lg==
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
Subject: [PATCH v2 20/23] mm/kconfig: make BALLOON_COMPACTION depend on MIGRATION
Date: Thu, 15 Jan 2026 10:20:10 +0100
Message-ID: <20260115092015.3928975-21-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115092015.3928975-1-david@kernel.org>
References: <20260115092015.3928975-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f3ef45477r3jkfyijk4wqi8f5i86unuh
X-Rspam-User: 
X-Rspamd-Queue-Id: A1F44120002
X-Rspamd-Server: rspam08
X-HE-Tag: 1768468962-365486
X-HE-Meta: U2FsdGVkX195ymiZq4pzbGuXZbwbKaVljq9X0MF0m4ItIqzLD5XcFOF9mKQ0ZOdICH28JbsdTfwXt/Zc8+FNupDsXIcnZMC5n/tBeeXl9pZAUHs7jOGQszKRVwxSYW2uTgT576gy5R1yGC3sDjdCm+0lWg7+QLJZRJXOBkEXIOinXRUMjcA77qvunyFccoXtu1xSsUKE/6NeQxJuhWE8m/pRDqvBrVKbCGTsUu+RQkTU8aUD6MP+OSRc0Fw0F92vIpnwQFN8sXGNB3FrlM40BPIuKe+6Vbpdxl+o6mOIqw/G9CioyiJB4N1snhBh0/DCnuTfmgLoo4/QiDAxCwkzEKSlzgTGhmx8gwX6EfJzLAKsFUnLejC9qGJGn0RhVWO3xRN8RNECawu5YLs7almB+lephROGi9YyRQSR02PZ2WYcAXCRPkQlFR4HGZPH83mDCXLpXF9meGDSybWlxQIVJ55CSXLm6/aUDKzRWeIOksg1jPUfY+SpLtGfYt7omEOJoG8l5DY/z9T4oYv9OYgBWC3xSil1VJsaoG9nFkS7NAMITT2+KUM1vNrMvCYnyqe3BhXAuQ/gknsrGvtchGKH2SpGXITzukm0p1OHT3F4RPo/n2ABq2mzXkiU/Z08JUU1Oig1HZIo26fWEkGhlm+8GtU9KKWlBlelXCzwyZ91x7EIGE7O5Nw8JO6xzOXGx4QxA0/w1oQAKz3V7QAuQ82S+h0qpoiSAqrK6kPaaAGwAfLOXyNb+EcOXdDPBQ2+XP/GT0VXVZ+GChM43yYNAh/M13QLoVhIkF+2MTbzUFlgWVTGovNP/820rRmBm5EB6vD2bYfzo3zvMEvVihrt5AL8PImvUPvHYJRGg81Dd4RanQreLpjXIddUo/++imhDk0uxWOn3ih6bGIdpfB3EOaOJ0LxVlyLoHpRzdwJnxqcU+QRjaVQELLz9uhZgas7RAARWFgTrBFoBKWXRP6AksJE
 YYDmcjm+
 dBg0uBkXWTnTb9W+QGj7tFRJBFD077NKoO2phUetG3z56rHfwanHMs/TRBo6zMB0V8Bp0Qzeg1QTL1Xg7mlMHOtxQAfCcSnpOaP7v/4jGgCHYVHGcWSk3aNXE8JamN2jfZGLO8Cr/iPRWT47wpZdvGLq3T9EA1EZQIZW8cQ3Rgfb9TK7Z9PL307CGivSIGLHua9h7YbwrqaEBrtCy3PlN7wV5tgjCuO4L+lIPWFNoZWq9M6+sBC3zMGi9PWP/760wljr27XL+COFoR2/pikibByUUJjYNrA4UkhJ5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Migration support for balloon memory depends on MIGRATION not
COMPACTION. Compaction is simply another user of page migration.

The last dependency on compaction.c was effectively removed with
commit 3d388584d599 ("mm: convert "movable" flag in page->mapping to a
page flag"). Ever since, everything for handling movable_ops page
migration resides in core migration code.

So let's change the dependency and adjust the description +
help text.

We'll rename BALLOON_COMPACTION separately next.

Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 mm/Kconfig | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 24a3ff149a1b0..0d13c1b36e1c1 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -599,17 +599,14 @@ config MEMORY_BALLOON
 #
 # support for memory balloon compaction
 config BALLOON_COMPACTION
-	bool "Allow for balloon memory compaction/migration"
+	bool "Allow for balloon memory migration"
 	default y
-	depends on COMPACTION && MEMORY_BALLOON
-	help
-	  Memory fragmentation introduced by ballooning might reduce
-	  significantly the number of 2MB contiguous memory blocks that can be
-	  used within a guest, thus imposing performance penalties associated
-	  with the reduced number of transparent huge pages that could be used
-	  by the guest workload. Allowing the compaction & migration for memory
-	  pages enlisted as being part of memory balloon devices avoids the
-	  scenario aforementioned and helps improving memory defragmentation.
+	depends on MIGRATION && MEMORY_BALLOON
+	help
+	  Allow for migration of pages inflated in a memory balloon such that
+	  they can be allocated from memory areas only available for movable
+	  allocations (e.g., ZONE_MOVABLE, CMA) and such that they can be
+	  migrated for memory defragmentation purposes by memory compaction.
 
 #
 # support for memory compaction
-- 
2.52.0


