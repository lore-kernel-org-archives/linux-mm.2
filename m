Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBCC1C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 12:40:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCB226B0088; Wed,  5 Aug 2026 08:40:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7C006B008A; Wed,  5 Aug 2026 08:40:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B91E26B0092; Wed,  5 Aug 2026 08:40:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BD5E6B0088
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:40:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 27B18160439
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:40:09 +0000 (UTC)
X-FDA: 85067173338.04.B8EC058
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2EB0940014
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:40:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf17.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785933607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BFHIi52G0DLGh2jlHFvMQOsriC8Uz3afVC7wSChQQrE=;
	b=frkRu77HUeTjXkfiaPtZ1dbICE/cBQvZVO2uw2Deb8ZEAB4nreThedOVmOncN2xfHEeI+P
	Aj+BmloM8XMnsgtYMnxJ7pzk0EZfynUQ5XYECXoN8rt9aHrhmeCvPOkBsdPlIE8eZ4nNDG
	nKa8tqzGfqqpbrNPSnH8tcuti3uvoCw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf17.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785933607;
	b=amSngtzwm5BbeiWjtqemrafTkIjKh4j4UieQoNUvCOD9VZUFdZTAz24xYt2K5q9f+pED2M
	qzmIKm1tZoCGjmDcB7uZXseNO27eLqZlySuOp70/usgvzcPcVPx9xgCEdLISSjMZNgY0Qo
	VfjBvXiLqaX0UCHZMGb2rFUG18pQfLQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C7D8F3E26;
	Wed,  5 Aug 2026 12:40:05 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CBBE8779C3;
	Wed,  5 Aug 2026 12:40:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5Z90LiMvc2owfAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 05 Aug 2026 12:40:03 +0000
Date: Wed, 5 Aug 2026 13:40:02 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] mm: add basic PTE const type-safety
Message-ID: <anMrnsN1xf_Psn3w@pedro-suse.lan>
References: <20260803164400.531199-1-pfalcato@suse.de>
 <a5afofuxhzwkeb76jdheottyxt4mms3arg2iucunztczbmd3lf@wiqp7yccjzlt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5afofuxhzwkeb76jdheottyxt4mms3arg2iucunztczbmd3lf@wiqp7yccjzlt>
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2EB0940014
X-Stat-Signature: s4cmod4sb8swpg7gc8srikzt4w16wadn
X-Rspam-User: 
X-HE-Tag: 1785933607-213571
X-HE-Meta: U2FsdGVkX1/m5vYp4KNJbN38knQPEo5rY1jMGM4HlK3e+0v6imaLKqbpi4HLmeIfy4wKw/rXO4BiW7v6c/S+pDu5AS2x0ko2PEWdvgGEv9cv43bYh84J8kZm6ukazov4wfPh4Uk13VBsfv5cZ1/71390DGEM95FWt2i821utZ8tutAnsywAUqh0iQzDtKxkniafYAy0S/LH7IozsqyaRLrlGG63Ew4IvhgNce/dQDvcVLaBmdE4y6OPv+STQXZtEODibLALSI31ZQBkA9fF1T4V2TW91JV0vfGpSjYmRXFreaH213+74cZovi3AJ+XmdSLF4h5g6bxSN9QrWRhn6xZHoGtOWjufe1lxVE0gh+xYA0TbHnVnyde+VgvgeMznYU2f7daSR9kQZdN+/lNqnEqyNVil06Bup7hwxqvcp9Hrcm4eOqldDg1totxMV7UIGuNKS6pSE5VwT4lYN1Lqp5O3QOF9R2rfwXXU/L8dZXLKNdgQTfK3kHy0IKmp33hYhYxWoD8vA3vVEN1AAeEpCOI5NK+9/4FINefU85SwZOfWLBWvLoR53tXKTsk+eiW4snVXp1yBdHNB9a13E53/kA9+j2GQ9xjvtaLoehocqgbERxuqBg0LS5RPhonNCJiVxZAD4mea5IKxVtJtHyYNvtFTjOqzJhr8Eljg30kOEN5Nfk/XXmyftIGQLXZHI2RroO1hPPD9CclujKTrIFoPD86rZ6INBv52wlVZ/Tfbzs1AF/ut0XXudzTXZ2GT74Z9JGc+0BYRG8HplIXFObne/0z3/R3bBVXnCr5hjipcJkU/gjj+q6ZSu2ThEXCS9THF1ebd1FUCWHBH+FaSCATiwonv9sWu6bUOTKfiu2Vem3QPv8DsCDSIr+rG24Nxu9/nsxSeVZNbOASuuq9YqkoOkFQFg3vEDZ2NjHLhi4ZaJmSdUTg9SIFEXW+iO58HLTTZzqMJ4ByYQKk25wTPvS0+
 zKdR2x+a
 8D3KnjprPtinv2X4etGoiS8Vc4Q+mByrxPS3MZVZ56llR53mHx+EXUqLDy/oun0Do7bQ48gBXRkSuCbfTo8l/1zaulbc84ieMeHeDschrARkXYV/RQuF6wpTtw5AyG6Rt6nq/OWCXU1JAWCDB8yDLXoiKhKtiluDeUVMktcF/oAi3qGIBnTUxBDy92Ji+ifzG2n8um8+G3tGpB1Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 04:12:21PM +0530, Anshuman Khandual wrote:
> On Mon, Aug 03, 2026 at 05:43:54PM +0100, Pedro Falcato wrote:
> > Since forever, MM code has thrown pte_t * around with no concern for const
> > safety, or typesafety of any kind. This is confusing. Attempt to address it
> > by:
> > 1) Making sure pte_get*() helpers can cope with const pte_t * arguments
> > 2) Constifying the pte_offset_map_ro_nolock() return type, which by definition
> > already pledges that users will not write to it.
> > 
> > These two simple steps were already able to uncover code smell from
> > khugepaged + do_swap_page().
> > 
> > Separate steps could include introducing pte_offset_map_ro_lock() for more
> > widespread usage of this.
> > 
> > Benefits of this include less confusion and better type-safety. It could also
> > futurely aid in efforts such as [0] which may want semantic annotation of these
> > accesses.
> > 
> > Based on mm-unstable and compile-tested on a handful of architectures.
> > 
> > No functional changes intended.
> 
> Even though the pte accesses should always be type-safe, this series does
> not really address the problem completely and instead changes things only
> for a small set of pte access sites. So just wondering how much beneficial
> this series really is ?

This series is meant to be a small step in the right direction (while
feeling out what the community thinks, which seems to be receptive). The
obvious next steps would be to introduce some sort of

const pte_t *pte_offset_map_ro_lock(struct mm_struct *mm, pmd_t *pmd,
			   unsigned long addr, spinlock_t **ptlp);

and use it in more places. That will obviously involve a bit of churn.


-- 
Pedro

