Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D21F606EEBD
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dtfmw5F4
Received: by kanga.kvack.org (Postfix)
	id 8389A6B05B3; Tue,  3 Nov 2026 11:17:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C2486B05BE; Tue,  3 Nov 2026 11:17:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D86A6B05BF; Tue,  3 Nov 2026 11:17:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4475E6B05B3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:17:16 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CEB55804ED
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:17:10 +0000 (UTC)
X-FDA: 85394312220.07.06DC9E7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1D9EB100004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:17:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dtfmw5F4;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793722629;
	b=whx59XgEtbM+iR+Br0oPRgM7Sl9he2ybNx7unn3Y/CabRaalTN0r6CQG1JNk0upwAlogoe
	jyUAPv/pmGd+p5VUBgpcmCFvY/Imgq5ObZgl8JKQOlVDm4fWHWioKgDiQJlgUhinbDHINf
	dvRAaNabJU0RQ5/jnwJf5kWGTSw+aLc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dtfmw5F4;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793722629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UUj+WYRrtKqRc0bHp5Em9fn4QwszF0JuIC3a+tX6dko=;
	b=w52ebSs7Set2C2IFRr3FNZHUML589nmjFG719uITRMBOlExZqbH9wsRb5vPbEvCUwrYz7Z
	FgoTg+8PCLonOK5yP6gZ4SuLzxNhsPz7kFON62Vk9Zu2DP8evGnM7GUCBBdkX1y4qRrMrp
	I8Pjt9rqyFu5pjrRwj94swqNWpmHW6I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 99BCA60254;
	Tue,  3 Nov 2026 16:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F9D1F000C1;
	Tue,  3 Nov 2026 16:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793722628;
	bh=UUj+WYRrtKqRc0bHp5Em9fn4QwszF0JuIC3a+tX6dko=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Dtfmw5F46EBtVX4RINKR8bLG5H6cahQ8oMuNQSM6n6RgZxHNtjgpgXwIwCGDzi8lL
	 oNkBZ8Xc3XBYqSOT2v6irYHNzeJilJu5T+9fFqJ0aVgFdpwre5eQTzDHfPhV1oPlPE
	 LAMseIWhVNEZeEhE0xEoEn0XBklANMf5GcdG5Kv+8kuOl4ho0lw7BBgvunKtOo/XBj
	 YlUKG/yQfxaot/ENBQxehVQ1eBM/LxcOl6RDwQGKfseS/DGVFmaPlwt9lbx7Uj38RV
	 z54pE8cGD6zP7dEkdwW8YFmdb2Uh7sFo7nCHNGigtAjaoVJhXkxQlbDnOVFE0bh2IV
	 G2nzs9kNqsWsQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 03 Nov 2026 17:16:50 +0100
Subject: [PATCH v2 4/5] mm/memory_hotplug: resize zones under their seqlock
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-pgalloc-ai-hotfixes-v2-4-e0d2890ab74f@kernel.org>
References: <20261103-pgalloc-ai-hotfixes-v2-0-e0d2890ab74f@kernel.org>
In-Reply-To: <20261103-pgalloc-ai-hotfixes-v2-0-e0d2890ab74f@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>, 
 "Gregory Price (Meta)" <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Stat-Signature: qeweipy7yfabhjocn1ywhfrnb6kdx68h
X-Rspamd-Queue-Id: 1D9EB100004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793722628-52997
X-HE-Meta: U2FsdGVkX1//0k64B5bPlBI7AsuaOcxrkdftZ88CTjXvMMrRlzs4c+0Hu8tZ8BBdB0WOGzD7I0+Jr5zc/czCWKwXnnDY3sD3OWrNLygXqlF608lvwphJGCxWq9lVBb+4mL/BJ8js82JGKm5hniKx2Kp4NaS9/Twa9t/TPDBEOK8M4cQtxaAvWPxPBftr9x9Td68PdGAIzTHfyktoT9QRL+c2J5e6OwPL9ivyhnI0s8/z+E7J/Gs7bRo5xlfndt+3z1mZkLzrtqZ0lGZu1Dlg6RinAI6cdZ9gP5xN2CbPWp9xtXCxJLY33YLvSfiMkpAQe83sUqYeZx1ivMRcjDP9J1sVCqqbmoQcei2aRMI1xRsgtdgwZI297ktkLH2q0XKm8jf/8ok+RHtuLqwUIJTIaemLiVld2KgicKnyWS+RQ9XG38+PrbWUba4NPbumNNdjgsmp6KJ/VT/sEPvkvsN9DxfF1yENuCJdcXJXcsglsBKJERKqrADc2AaJU/LFv1Yh1Mtr8+oP146aYslOpCW7vNDHbEuyb6DvrYcyE8iwCkg/Vjv9YbOXAg9X0+yacWYwqeLckEhGhHWFl5Hf3bONhMoJkAxA2UbG005UcDPnv0qmE+mC+8swLtjS5DR7N2jjjK1qMYKjWgZdCAWn9EGf+2z1LXZQ3eXbtICb8Y+c24VYa64O+3wIhmwoGrjyLkAvys014O8sdjdJJe6nBeNG6OcKOxkuhPLJ8sPHl7pAqDqRwncQwczjiILvk0HRyncPmFSer2VVLjDbNwGymlqfA+ahzZLnBREc+7mszhsMNwh9He8WQYHw2LehOilANhyO8NBRIdKFAgPUH8WWmDukG4/HZXph8eboBBdaW981EqfcWJWeQePEuadpOcOMaQNGfI85qxoYzfR3IW4Awo9AWWOtyg4YxfpS1ZeUvgxPfyy+Nbg7dM7XxFqV9RvJKqjR2DMzN0YX/6HulwDYos8
 0wE53xGw
 OQkJloL+fQaCBBeC3+HNgVUlWjRjE3+Yvc5Z9X7YOUJRYt6KukgIT6rgaqKYrVD43xUV5qLRMTfahpwZlfFe+ahV3KDm7al1bPdnp5mtlF21/HG5e0+4hjjZSYwMYqdsqEJ79PEhU+aFBEyZZWmfS1XzmiMHOtajUTYiBSHky5x4aNjD01Qo2DxtegJJJhRUvdUnjTL3djD5G2u7dzx1u+M4hLau5ZXKI4EEUM0bJeV7eCj5HJ7X/DP5Owu0lv45cWv9p6jS0Lgp8UPjFkaLHLtZCZP+wNl1986zn9D9Q27UYxpONGihBTP57+NPMs8tep11pVtlHK9U7bodUFH0m1JPxkTKgwAAmpehb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

With CONFIG_DEBUG_VM the page allocator checks that a page which is
freed, split or allocated lies within its zone. The check reads
zone->zone_start_pfn and zone->spanned_pages under zone->span_seqlock, as
memory hotplug can change the two at any time.

Commit 27cacaad16c5 ("mm,memory_hotplug: drop unneeded locking") removed
the write side, since all resizing is serialized by the hotplug lock. That
leaves the reader without protection. When memory below the start of a
zone goes online, the start is lowered first and the size is raised
afterwards. When the lowest memory of a zone goes offline, the size is
reduced first. In between, the zone seems to end before its last pages. If
one of them goes through the allocator at that moment, it is reported as
being outside of the zone triggers VM_BUG_ON_PAGE().

Write the two fields in a write section of the seqlock. Interrupts are
disabled as pages are freed from interrupts, too, and the reader would
wait for the writer which it has interrupted.

Fixes: 27cacaad16c5 ("mm,memory_hotplug: drop unneeded locking")
Cc: <stable@vger.kernel.org>
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/memory_hotplug.c | 44 ++++++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 0ab9a6e09222..b9f02bc6ed0d 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -461,6 +461,22 @@ static unsigned long find_biggest_section_pfn(struct zone *zone,
 	return 0;
 }
 
+/*
+ * The page allocator checks pages against the span of their zone while the
+ * zone is resized, see page_outside_zone_boundaries(). It must not see the
+ * new value of one field together with the old value of the other one.
+ */
+static void zone_set_span(struct zone *zone, unsigned long start_pfn,
+			  unsigned long spanned_pages)
+{
+	unsigned long flags;
+
+	write_seqlock_irqsave(&zone->span_seqlock, flags);
+	zone->zone_start_pfn = start_pfn;
+	zone->spanned_pages = spanned_pages;
+	write_sequnlock_irqrestore(&zone->span_seqlock, flags);
+}
+
 static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
 			     unsigned long end_pfn)
 {
@@ -475,13 +491,10 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
 		 */
 		pfn = find_smallest_section_pfn(zone, end_pfn,
 						zone_end_pfn(zone));
-		if (pfn) {
-			zone->spanned_pages = zone_end_pfn(zone) - pfn;
-			zone->zone_start_pfn = pfn;
-		} else {
-			zone->zone_start_pfn = 0;
-			zone->spanned_pages = 0;
-		}
+		if (pfn)
+			zone_set_span(zone, pfn, zone_end_pfn(zone) - pfn);
+		else
+			zone_set_span(zone, 0, 0);
 	} else if (zone_end_pfn(zone) == end_pfn) {
 		/*
 		 * If the section is biggest section in the zone, it need
@@ -492,11 +505,10 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
 		pfn = find_biggest_section_pfn(zone, zone->zone_start_pfn,
 					       start_pfn);
 		if (pfn)
-			zone->spanned_pages = pfn - zone->zone_start_pfn + 1;
-		else {
-			zone->zone_start_pfn = 0;
-			zone->spanned_pages = 0;
-		}
+			zone_set_span(zone, zone->zone_start_pfn,
+				      pfn - zone->zone_start_pfn + 1);
+		else
+			zone_set_span(zone, 0, 0);
 	}
 }
 
@@ -684,12 +696,12 @@ static void online_pages_range(unsigned long start_pfn, unsigned long nr_pages)
 static void __meminit resize_zone_range(struct zone *zone, unsigned long start_pfn,
 		unsigned long nr_pages)
 {
-	unsigned long old_end_pfn = zone_end_pfn(zone);
+	unsigned long end_pfn = max(start_pfn + nr_pages, zone_end_pfn(zone));
 
-	if (zone_is_empty(zone) || start_pfn < zone->zone_start_pfn)
-		zone->zone_start_pfn = start_pfn;
+	if (!zone_is_empty(zone) && start_pfn > zone->zone_start_pfn)
+		start_pfn = zone->zone_start_pfn;
 
-	zone->spanned_pages = max(start_pfn + nr_pages, old_end_pfn) - zone->zone_start_pfn;
+	zone_set_span(zone, start_pfn, end_pfn - start_pfn);
 }
 
 static void __meminit resize_pgdat_range(struct pglist_data *pgdat, unsigned long start_pfn,

-- 
2.56.0


