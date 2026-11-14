Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E58CD606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 14:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=OdH3nXq0
Received: by kanga.kvack.org (Postfix)
	id 092B56B00EF; Sat, 14 Nov 2026 09:56:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 043D86B05CF; Sat, 14 Nov 2026 09:56:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9BDA6B05D1; Sat, 14 Nov 2026 09:56:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C39E16B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 09:56:28 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4FDDA16041E
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:56:28 +0000 (UTC)
X-FDA: 85434025656.06.9F33860
Received: from mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf02.hostedemail.com (Postfix) with ESMTP id 561B180003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:56:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OdH3nXq0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794668186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wMJMVWej1L6FCi5Hz4CBSwtruLOk1VwtvbQEDP6Nv7Q=;
	b=CjJsVM4noW4pLDD6fb4dFFOOCCaxnCKcMFmuAEUztH8ROwQrMaafWTG4DxObWxrHSAiMWO
	tdtMrWdcL96whVsXxni7DIwCbv8Vg1Xb+Y2vTLPTKW89mOODj2KgJtj6MZOGH3EsJSpv5e
	p9ZEtnlwJrURf+QCHFX66NdjuU3Eb7s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OdH3nXq0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794668186;
	b=KxDCBd233B7jnwHNJAYGrlRGVD4jEaABOxup8V79qF9q8omm4kqVdLTothLamVymGk5Ovv
	RbOZ8imMaIJoLM2IfmHyCYdYtbEebZ46lBGZNN/shKeAwHyTToWzb6As5+TMC+PS4lC6qj
	l4K4MZYzv1OMVYowTUtfVSQP13XDuj0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JebJ2KYviHzA7GxQlWkyQuYehYQ7NUFLaQJh1nE/Hmg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794668183; v=1; x=1795272983;
 b=OdH3nXq0emCtGNNnPX/+VFIGdil7rs+/GTA1OQqIsWnEq01L5OMKQjsa+S0dHUKh4nEb9S6y
 ZjoB4EtzZmwINmpT6QRMOKLRu8GEpVW0Y974yYn9JYegQf6ea1Wpvk+cR6RlwElXKTnY9iHw5ki
 W897c6kRKipLs02ORDTx4ynw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 12765da31f07e8bd;
	Sat, 14 Nov 2026 14:56:22 +0000
X-Mizu-Trace-ID: 12765da31f07e8bd
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: ljs@kernel.org
Cc: chengming.zhou@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	xu.xin@linux.dev
Subject: Re: [PATCH 2/2] mm/ksm: add initialization helpers for scan_get_next_rmap_item()
Date: Sat, 14 Nov 2026 22:56:16 +0800
Message-Id: <20261114145616.646190-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <avcZQNlZ7cisQAeG@gremlin>
References: <avcZQNlZ7cisQAeG@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 561B180003
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: bnd7pnbicm1jhyrhixq4j9h4b3w9yidq
X-HE-Tag: 1794668186-125104
X-HE-Meta: U2FsdGVkX1977gypTHxReI5wXVxxMMKP2/QLY++arsa/65emmTHhyF+4mPokDrGduhKY9lhaKfjj+yk0MRFngWPavs/Q6jNiOZAp34T3ZrJg59QAEt69qb0hIVYgIFxKWoqs4JRrxGfQFS7ibWjjarZZFGveosMTUZHMJrUBjdF6VfkNV8UmQawPD/3/NOMkx+Q0efC7O2wCy1MQkiCaeOZ+yDQEZiAujtM8VSAGskoLp590MnJs2tt48YgkYIE2wS/xRurRvjixeVJP0LZqMAEZophR4Mj9vtQgcRBRZvvDWNN+SM74KlX/wJDt6n7Fl5liflHvch66yNfA/GfRlWXWgdn+ASqp6q9SqWg2dQPbGZ6EzEJjVbSgKJRzhgxacIOwa2aq3zkjodVpJcGx5m+ACn6sRlfYV6QYZ8VyNX/v5729od66MvXmVwvVE+ihXnG3iSs662cJZHdwI3xHzGD9ky28/ZgxrxJmiSs3XxtMN0i7StCCRvJZivNxxJ/Rh/6Kb5fO6nB1+T4ZSFsz+oTPgFflK9nliRd8inFm9+v9he1KNyxjLwz/m/de2NUCj5hezOnDvk5Tzy+Y8riGd358ecO55WCZ8TkUnGHPVmTFTO9hRxuT0RWCyqm2EXsg91A2YPdRunnVV+I5s7HYvHwMFS5zuyunMLWYdR46fbgLfRzDl8I8fF5p0pp5lRQn+HOcg9QuYsjS9Zt1osp7e/4jortEABmdcyEWpvl8/FGsrYYNuBqX3tWzjkxQfGQxbbE7kT/FcG0sBVe1oQunGlW1Jyl3l95FdmCtjKJJKQ50raS9eMArJs2/G6PSZkA5ReXQWXWHjynNpE1ggkg/5oI2vLC4p9cVFKplrA84rIPASXHjT7lOAEGSoSEEnchyzS41GcbxyVYCHrjES9+yrqWZY6bn1gFZrucQqsidMxfFcv93NU4Mwe/kcoyj0es9br6NG10OkR9hVd1xAIq
 tCGcjRO5
 luX3uVE7X0n2g07iqeycp47Z5OnzUj3jnt3JebHJ7z8DyrqW/8DBbEvj/32NYA/oiYN/gVNUhShR+JWjnTs7eai6iDsveBRKuvroId91s82g2iW+nEPXLFztZuJNw2W1hlWTOEOdMdV89rjxp5XYFPABjmR82TVNrcDwr0z12EFGcWccF6tHBnve65D5S0gQPM16hRnyTdCVeladXwI/RJ6NRoyY3SbbgidDqYD9QcG1bkw4y4GtaZY0HXph7jp0H0Ht9yaUonJz9d3MCUlg6BwLXKL81hACsSGhxuPqW5lebhSQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> On Thu, Nov 12, 2026 at 08:59:59PM +0800, Xu Xin (vivo) wrote:
> > Extract the new scan cycle detection (including draining per-CPU LRU
> > caches) and advancing the scan cursor to the first mm_slot into
> > scan_begin_new_cycle() and scan_get_first_mm().
> >
> > This keeps the exact execution order intact while making
> > scan_get_next_rmap_item() cleaner and easier to follow.
> >
> > No functional change intended.
> >
> > Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
> 
> Again, thanks for doing this! LGTM and:
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Thanks.

>
> > +static struct ksm_mm_slot *scan_get_first_mm(void)
> > +{
> > +	struct ksm_mm_slot *mm_slot = ksm_scan.mm_slot;
> > +	struct mm_slot *slot;
> > +
> > +	spin_lock(&ksm_mmlist_lock);
> > +
> > +	slot = list_entry(mm_slot->slot.mm_node.next, struct mm_slot, mm_node);
> > +	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
> > +	ksm_scan.mm_slot = mm_slot;
> > +
> > +	spin_unlock(&ksm_mmlist_lock);
> 
> NIT: optional, but this could be:
> 
> 	scoped_guard(mutex, &ksm_mmlist_lock) {
> 		slot = list_entry(mm_slot->slot.mm_node.next, struct mm_slot, mm_node);
> 		mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
> 		ksm_scan.mm_slot = mm_slot;
> 	}
> 
> 

Good idea, I will switch to scoped_guard.



