Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F04FEC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:48:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E3956B0117; Wed, 29 Jul 2026 10:47:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96BC06B0118; Wed, 29 Jul 2026 10:47:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5556B0119; Wed, 29 Jul 2026 10:47:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 20B9F6B0117
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:47:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3896FA0682
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:11:53 +0000 (UTC)
X-FDA: 85041549306.25.9F50640
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf30.hostedemail.com (Postfix) with ESMTP id 834F180004
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:11:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=lS1SiLOM;
	spf=pass (imf30.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785323511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=n9RxULfIB529s6BAgXo/FHZeN8z2+6YWnKjKsUubeUU=;
	b=r7XYncReOUd9i6T2EB78DNd5oQPu1xRqAXsradkpTUpQ5LqSkkCA+ulqgwoikbJneYE/6w
	xVpS46pfaAgOiVt0Y/2YvSPpgtfBwSZcyD41SQeohBeo1FiE7c1WFB7n3Hi1f4848oSllR
	/u+XXQr+YsBICtO0kHhbiC2Eaez2cB0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785323511;
	b=yCNToKhmVFh90XqthOAEsXHd6FIYJJP6mG8GGHeyKOQ5/Vui0cZSRddkfuOmzzGb/Ktc9m
	BfFO5XdQzZ4VcldQ9+btqD4LyKviTI7KrLToiHxcV6NBNJAo+9VKUq7Zk2NwSvy+pgw25w
	CMf3ZudFQ/1xeIOIqr8OU72YQ9iBl60=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=lS1SiLOM;
	spf=pass (imf30.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
	Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To;
	bh=n9RxULfIB529s6BAgXo/FHZeN8z2+6YWnKjKsUubeUU=; b=lS1SiLOM4VgohPxGU1ZYKuJYza
	Ehb2kESRj7tHBJvMe6nvRMIT9BtOqT890S7Yc2cKAiStMu+iicgXyzpXfeFvGcKRDGU071cVWRgdi
	QG51980yTzf4hbXiV+pD1MNvgsQ1RPE9DqoFpuppaHdLnWO7YMoaCXhKVuFx/jAd3dEROGiBlF7E/
	rIQBlGha+WIVeY+nDyvNesyomD+DRPQ+EVZtrZklNhX+N+2A5PcEQnB0FVM+L5K9G0jeuLOOBuw9Q
	+/Cfl7WFY7a1QINg6WWsxEyBbbJaPLmD4mmtkOnZk/c2wT56OS3MXHVpkvB+DYyW10omE0r+B30Co
	jqVs2ChQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wp2CM-00000005hpz-1aoZ;
	Wed, 29 Jul 2026 11:11:42 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 0)
	id B2C4F300E8B; Wed, 29 Jul 2026 13:11:40 +0200 (CEST)
Message-ID: <20260729111119.375614011@infradead.org>
User-Agent: quilt/0.68
Date: Wed, 29 Jul 2026 13:08:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
 peterz@infradead.org,
 Andy Lutomirski <luto@kernel.org>,
 Borislav Petkov <bp@alien8.de>,
 David Hildenbrand <david@kernel.org>,
 Ingo Molnar <mingo@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Juergen Gross <jgross@suse.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Kiryl Shutsemau <kas@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Lu Baolu <baolu.lu@linux.intel.com>,
 Mike Rapoport <rppt@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>,
 Thomas Gleixner <tglx@kernel.org>,
 Toshi Kani <toshi.kani@hpe.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>,
 linux-mm@kvack.org,
 x86@kernel.org
Subject: [PATCH 1/3] x86/mm: Use guard() in cpa_collapse_large_pages()
References: <20260729110807.797920433@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: 834F180004
X-Stat-Signature: 3gu68eqzqm1ohzk7tchzrbw1gstmncj8
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785323510-581660
X-HE-Meta: U2FsdGVkX19L6nzeM7/eZACUxLcZS6rXS9Nb6YxHpkFQuUhvCt98Wv34tJ3vJlITToY4+IlIyJDJyw5G+ARqDH7azWdjrOz8CfoO5negw0hiMEqyqKfitxPmLhVrZpXRC/F7vdTjvsR4gBAApjpIFNDlO9Q1NBKvpwSLIwlqaHnWFeaYZ1uSyNwaeap1c8tE334GeBKnsvvscE1B93RMgUT0MeHRzj1y2dJsTmmc8DEHpsmIwAh8b4PibEGzuRy+VmcCB+VLQ3atsQELW1Ej6Mm6QZsc34qgsHDS3WRUTsxA1ISyzSXmv2agCaLdfzndCBOxjpwcbn/J+biFWUZs8omFRh/kNmROGcJHT2jxwZc/8kP9onWiMNDn5WQhPoZKNXCHoZ+cHKy3+YsF56Obtv4N1GA8v1vMfDezqkiYnD++98NYnSMUY/I0D8rU1NaDFbhqshPYtjbQ1l8av0nD1y5x9fE1Qgam9kyvBmzN5KO/BAlvKvJmNh9NVIBqUqkbjp5fIQgZLWOdWSTgVW/8TRnvG4l7RItWOtO9WIDyAAyleNSvSQwAGfO/kOTlssZmV2AOsZqCC6baiBX185AGtBidRbpg5AB3Zv5zrVAulD0Vw12oY73k80Y9leDwnt00gjp/2Dm/B0L5fOAIf0ua1wcQZsN34i6gLD77xk6V3S7WMEFCs7nWbbjIeM1v+XYGjXfceS7DQABs2jxVlZgeJqqq3vnT7VOuKr8OWy1pPrcsTNqd+0b4yMl+5LIPxmOz9dTFzC9BgGea9qCVKLrjpsdz4KGo9rKXwSXNh7fFWHDAC2IKZRsDVlDmgFQzWXYYE+nbOP/iuDnB5e6v0IqH2i0VF3cxUmMOtHLtkoesQxZBu4fcnJr/pKUhFfzEl1+3IsNsGFZJZoFuuREYGXJ/uyUYwCOOp0Pwew5x9Kt9qDhzOPB1eRPsS8bjMh2BPj4dDX3HOYzPFqnUGgBWZxY
 qvbSfMxG
 KukcON7mY1DjS6DVPrd5sR5VyDrEyXW1umlrqNQmtPkibaks0qutNeNRZKz0KZ8ZRFV9KLNT1KfKlovFVfaKfLrYvQn0f5phKSvrXU5DEyclHFC3J5+TC56kRrjSF5IWAWjePrSqQWtTjBStQZuYrxuQV1vMMw3KzS8uIDN6avsqKMhe6/x5JVIZmyPpbbhLL6l0tq6YoUdo9in+FKZgnnxT3vdLOEvgMgQ+T5d2yjbBMTw1DvOuoI55qQLTaDfYz6HJM13oovi7ESE23UryPnLbZo8dEbWZG0Ldt2jVZjdvdmLaqJi5GHWHL+1CiYVL5TIV0BMi8KXHqQI6LsO3mfOfMVtyVAU38csGFZoAl+l0gJFc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/mm/pat/set_memory.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -417,7 +417,7 @@ static void cpa_collapse_large_pages(str
 	int collapsed = 0;
 	int i;
 
-	spin_lock(&cpa_lock);
+	guard(spinlock)(&cpa_lock);
 
 	if (cpa->flags & (CPA_PAGES_ARRAY | CPA_ARRAY)) {
 		for (i = 0; i < cpa->numpages; i++)
@@ -432,10 +432,8 @@ static void cpa_collapse_large_pages(str
 			collapsed += collapse_large_pages(addr, &pgtables);
 	}
 
-	if (!collapsed) {
-		spin_unlock(&cpa_lock);
+	if (!collapsed)
 		return;
-	}
 
 	flush_tlb_all();
 
@@ -443,8 +441,6 @@ static void cpa_collapse_large_pages(str
 		list_del(&ptdesc->pt_list);
 		pagetable_free(ptdesc);
 	}
-
-	spin_unlock(&cpa_lock);
 }
 
 static void cpa_flush(struct cpa_data *cpa, int cache)



