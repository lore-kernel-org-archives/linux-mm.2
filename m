Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02B5A606EE8C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eMQWjn2H
Received: by kanga.kvack.org (Postfix)
	id 0962F6B05BA; Tue,  3 Nov 2026 11:17:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 047836B05BB; Tue,  3 Nov 2026 11:17:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC7056B05BC; Tue,  3 Nov 2026 11:17:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CC2B76B05BA
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:17:00 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 66D3440446
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:17:00 +0000 (UTC)
X-FDA: 85394311800.20.61D6256
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 75EA218000C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:16:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eMQWjn2H;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793722618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=whRKP2FIGGX9uO7u5NRY0O5dJxVmBW+dlYUy2EeY3q8=;
	b=UjQowtGsQy/6K1T0ucg311SGk0hsMo1zAVoJLP9HkJbMVlaqr3DcgLxpnZz9Lm1nI/Xqa2
	KHb7rkQXIZ//6CHaIFlF6G7iB6FPrRuuyW6DVS6wkJMxhmcZ+bRNxG2PqgwjZoxWKmy4Kj
	j3plZwEe8GyZkgGv/LIbRoC/lEwfxp4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793722618;
	b=FPCezzEEsXV3+O45/vzKeY4VJZPxzGSA+8lXrp5jagzepRMMCNIWA3M4rn4V10Vz0One6B
	brZ+WiOm4RpbqLi0kQIFUTJjJ9V32YfXlcoNH3TyH1H/WLYWsmHrf0B01qQxn9tGm/+tzY
	+sk0+86AZzYbr2M1JAMbjq74wp9jkYY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eMQWjn2H;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 07613601FF;
	Tue,  3 Nov 2026 16:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898111F000C1;
	Tue,  3 Nov 2026 16:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793722617;
	bh=whRKP2FIGGX9uO7u5NRY0O5dJxVmBW+dlYUy2EeY3q8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eMQWjn2HbyxpTB7teUSNvegEuUtHnNd+JtCXX81m2/Ivw32z4Hya1W4geoX9WP+5S
	 Zga728/RneF5FODP6/UVGz78KzTily9N+wqwZWE6YI0IAqFVPAXL+HJg5DNahQMwBp
	 JY3hYQ4Q0NPAGYzi44qYRtbnqVsdKNXLkR3ane9RVlY7CZq65xKxkraiZqV+ToYjey
	 b5e6owRmFxG4+RmiAno4IMIGpdn9ZxOlTtxXkrC+oWDrRmHddZVw43lk7dsJOvVZPv
	 2C+qK4SITdRHhtjeZw/pEWRh7fxEP+fBv0S1FojyIJvZ9Vb/D8MZ2mTaNxc6C9E25p
	 DM2EIV3YMNibQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 03 Nov 2026 17:16:47 +0100
Subject: [PATCH v2 1/5] mm/page_alloc: clear ->private of deferred free
 pages
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-pgalloc-ai-hotfixes-v2-1-e0d2890ab74f@kernel.org>
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
X-Stat-Signature: mnnqceo8h4rexyy7u13fpcz33hf9urnx
X-Rspamd-Queue-Id: 75EA218000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793722618-874510
X-HE-Meta: U2FsdGVkX1+UO1o1VGOZDS85eedrs+/VXl78Z53fT0zMFLqeIoqcAOFwOWnc31hSchM4qe623lhHC9aj72Slz/mTr4Mb3YL37RTdxCBZBAB5wAijPqSUQ5VDsX7CXiTGhTmQXC9qeuPdGnxTg4wafVGv25pKydvA5XUfQhBIcUDylqQCcZ7T3Uwo8TTfjQ4wyyL4Kuhi2qS110X0gW2vLG/Uez9LR0Kdt+m9Tv17fbYLfxRqFnrMy8bNwklIAJWO5Le7wvNM/+f/9m/3ooYY3L81izVCNMpUlbvUKMSkK2L0Re/OfXFLc4xE35hcr/mj7KQPDxk8iDqqxqiLw7lUBncQsQYyQot0ycuiUfQRapOArv07z51diQqIa/ZU+AbE/qSRkGcowbMAm7KFKDqwkcVRvaq9Jyg36ZJDZyp5igAtF4iHXgaTx1xma7HpAsU348As68mumpjjzqTJM5Hp8NPy9qzwtR/5O95W4RbotLxV66LqR+QDFcgMYsz2fb3vyavCgYirWCY/qMVXXFk4JsrRvWFVwDNoKC4avRMZsFRy9TB5+kHS1IadILfKCmJu58/zsv7ZuC9EEGdH5wfJlH7fckmerIgxGRn1wEkOjt0mskb4C4Jz6ah/tfwipjJepxhL5PyiNBAKr6h3VFxbh9WNP3vQfVAXw+zQq23WeJO63l6ldRQASJEiaRTt0CqJEWdMYXmh5VUWw2jbd+8rSOeNhQ4Uap3C44rNDtyFcj2/JcQjJ4qr3WfZb6I7kBNUyPTVE5YVv6Yg5Npx6XvbqPRQwgkN74ptfVX5ve3oLIx0w6zEpfyPkwyKgwoimOrnP/K2lZsbBwAIFmc6jvRMjyCzwwc9/2mAkGSWQJdZEnUem4DnJRWMA8E48tJbLuBOU7wC9IGiSOS8rU1D/x0OfV0xNVFV5T/3H+ed/krybRI7x/HeNjTuEVZDbeWLfk3VDwJamPoB721EIixyqYl
 URdOLAQC
 d9/rU+65ddtpo9HayQffDqSrM8attXk9g/WLGn4rQQjbQyIMBRkf/9zBQnAX/e7kTDsP3/MIqqWheW12dUnb96tEkjR3ZcIMKSc7QExPtAshqKWSKnS75VT/N+tfPBp7PsFJA8fRXUJsDHci+YPW58/k6+s8OgYelwNlqg0w5tICOqmD/EdRk9wxLV78h4NIQF3zoi6wKFu2c5T5Z752J4ZuYT5NNAzN0WRwpWLqZW4cX54goB4mMC0wiw17T9pjtcCTHAY3PqUhzmeHD+sBmOgxYfKWWV0LbJZ/x9Ktv+lWs2vVkvSZaWylC6ID9CLdQhj7Z7H6LYqluH8qYLKE/lHmjdmYp+op/3LYeGck3S6E2Uk+weHacBkfwkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

free_pages_nolock() and free_frozen_pages_nolock() put the page on
zone->trylock_free_pages if they get neither the pcp lock nor zone->lock.
add_page_to_zone_llist() keeps the order of the page in page->private.
The next free_one_page() which does get zone->lock passes these pages to
split_large_buddy() with ->private still set.

__free_one_page() writes ->private of the head of the resulting free page
only. If the deferred page is merged with its lower buddy, it becomes a
tail of that free page and keeps the order in ->private.

All other free pages which are not the head of a buddy have a ->private
of zero, and since commit 819bfbd47e49 ("mm/page_alloc: remove
set_page_private() in prep_compound_tail()") the allocator relies on it.
When the stale page is allocated again as a tail of a larger page:

 - prep_compound_tail() hits VM_WARN_ON_ONCE(tail->private);
 - with the page checks enabled, __free_pages_prepare() reports
   "BUG: Bad page state", "nonzero private", and leaks the whole page;
 - without them the value is seen by whoever uses that page next, e.g. as
   folio->private of a folio which is split off a large folio.

Only pages of an order above zero are affected. Those can be freed
through _nolock() by the stack depot (order 2) and by SLUB (a new slab
which cannot be added to the partial list by kmalloc_nolock()).

Clear ->private when the page is taken off the list.

Fixes: 8c57b687e833 ("mm, bpf: Introduce free_pages_nolock()")
Cc: <stable@vger.kernel.org>
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/page_alloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 55bd558306f5..41fd80c0c762 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1562,6 +1562,8 @@ static void free_one_page(struct zone *zone, struct page *page,
 		llist_for_each_entry_safe(p, tmp, llnode, pcp_llist) {
 			unsigned int p_order = p->private;
 
+			/* It may end up as a tail of the merged free page. */
+			p->private = 0;
 			split_large_buddy(zone, p, page_to_pfn(p), p_order, fpi_flags);
 			__count_vm_events(PGFREE, 1 << p_order);
 		}

-- 
2.56.0


