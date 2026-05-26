Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93480CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:11:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D203E6B00E0; Tue, 26 May 2026 09:11:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF7F66B00E1; Tue, 26 May 2026 09:11:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C34A26B00E2; Tue, 26 May 2026 09:11:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B2E8F6B00E0
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:11:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 54AE1161664
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:11:16 +0000 (UTC)
X-FDA: 84809606952.03.F8D7F6E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id BD4AD140011
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:11:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f11GtvcZ;
	spf=pass (imf26.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779801074; a=rsa-sha256;
	cv=none;
	b=dS233l/ze8/1+h74FPSjNct0/qdRj0Hno5dDAiAvtp2ly9gkXq0JvjnW3f7q7pGPLtnC7z
	9sph33UYZBaYSXcE+VkFHwH4b5Ird0mD74rvtxxPOEydssFnE3DhpE1H1BonlA0r5Hdrch
	MLchv+DXLVIS70EZo3ZTOxyvu5hKIs0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f11GtvcZ;
	spf=pass (imf26.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779801074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NLRxZs5V+Xs9xqYGiEg8hW6pN2SYk32SRlLoQ0q4z48=;
	b=QJ7gHuqiuqAIAFXjdhLi6ahwwTaVt1TD743oIZOOcB/8sAWeRV6UsNgNIj+Dlnmjnm4E3u
	cG2sk0nOcTf7Htni5jTMWjHn/hygdvcx48vGT1liHADZj5kO9HOsOQQRLV1IF47/NPM4o5
	nYzKj9rSwW3hqo2pw1kzkpharOTNBwY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D6D260236;
	Tue, 26 May 2026 13:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB1B1F000E9;
	Tue, 26 May 2026 13:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779801074;
	bh=NLRxZs5V+Xs9xqYGiEg8hW6pN2SYk32SRlLoQ0q4z48=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f11GtvcZxkf03mTF0kMhig0MOy+SLr4+uLQnFm3aMunR1kizOq/vSLNl0quYjWDYP
	 jneHF/5xyTIH+DCM8AqXkxvlnYdixmvb9DIXneSc53uw+3UoTQnaVrJmOyA5Y1PVey
	 G8yGtmd2UeTthx19hW8bkKGOWtuvnrE9tJ2jvFGtSqzuwugZVc+SCkfpPnscLpJ6V6
	 GPDyGyhvYBPyAaU/kv+VePggfepTr9Xkc3JJ4f5Nskg8xy171w3psMX73pvWa01fJQ
	 DwvilQDlg64atNguzsAV8G++XdKGr/LPObLmau77BGZdbhX1hH5R9Viz6rh9QrZWq3
	 xwPkXKCXNG2yA==
Date: Tue, 26 May 2026 15:11:07 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Frank van der Linden <fvdl@google.com>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	muchun.song@linux.dev
Subject: Re: [PATCH v2] mm/cma: fix reserved page leak on activation failure
Message-ID: <ahWb68NflaCtQ3mr@localhost.localdomain>
References: <20260523060123.2207992-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260523060123.2207992-1-songmuchun@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BD4AD140011
X-Stat-Signature: nu91jr6p4bce1po7m18ektjwnn3n7aok
X-HE-Tag: 1779801074-534361
X-HE-Meta: U2FsdGVkX1/RCXBi6q8V9/16m0IhK94myJZGhufBaSDRfirVEdC1lcE0Py33r5R2ejuSrPty3I7hEntsx1Bmcjto3KPzSAcx1W67kgLDqLa+nWsdUZuOtDrxH54ixOCO0bwJK78BbTPoMmWiK0Dgrh4i8RUSoDMJBZm7TPmCRZ1nZLT5BFkjmdfIaIL3q8+ZNdh22LmEcgMkN9MIHr7gmCH180ruiuoyagm9N8+5R7JsNEGW++QKZQ49SVUNF4jSYjRa0V70AV+8V47LKRyFtMRWffAdhjhrItN39XEvarXi8YY07b0VM6OtPJmgA5RJ39zrGoWGWlGRlihJFaLpAgDTbClN4PiEJ2I+QeNfRhDpf42GdTPnMqjOG4Xdq6NRfrlbawDNC5yld6Q/DJoZqcYtTYnR9XNcvrBdG9P3cti7v1ggLwbekEChvAWIOGV4ZU80tTlIRltvxJ20Vd9j/iVF6kpP7KRIggrFwwb07tLT8Y1ne6Y3UKYT2wugq3592alqUPsKT/rQ/yFTJHbrZy2YXBiZT/7sebLqDofuKu8wlHVqe3PnsfcriZeWOKu4LCiwM1nLGU0VFBUtciIO38PNAyrFoeNAZsIGr/N/bUe0uCbr0YDtQR1KjQRjzTY8RyIP6kXY2Oxo97Naai+At5PZ73zP6FY18W7gz6NLaYGrOUFqO9mHs3wNoNFE45OfNL1/UQGlDT7Yfa/IEeVHmQauC9quS1euhKEPpMqFxQtAeLIer2ZFtH5on7RGPLUeBypZxyPhMiiYgFwg297085gqrIRQ4Qjj1xkisY+/kaZPO3lh6chOxgSswo8W4KWzWfJ3u0GYZJ1Qq7IO4aNvDeuAnPrDiMuKgdsS0qnuSuAj6k9dr8WNbvCQtgD3aHhI/JVBZa3WDp4ieyrwc3V0L4NZamDpIerzhTBjgBahd6F05isUOoFnkHYFGhNSq/124XIO7e214oZrPbU0V3q
 tIH41+Q+
 Kbw8VmqIK3myTWmzBHNMvqe4UGFhKn4LQGXhXCblHnuR3a/aIOqs7D5dpqb6YIFSpBxkpYEAAqX2UI4hsLwiff5cnTFagrrV7zl0rDHk7mVhhD7BwYuni5IuqoyCkZshemQQ8qmmJea8iWxn0sn4ub3hZR4Db7ULAsc4vjr05PURXg/Fo9uyLzBQDyMOWSUnRD5h4kYen6wtmU7qwZcVyp9OGOK828naTd8j3+Zpqh3pAagCTa0gh09cs0Cf+AxxKqAGg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 23, 2026 at 02:01:23PM +0800, Muchun Song wrote:
> If cma_activate_area() fails after allocating only part of the range
> bitmaps, the cleanup path still has to release the reserved pages when
> CMA_RESERVE_PAGES_ON_ERROR is clear.
> 
> That is still worth doing even in this __init path. A bitmap_zalloc()
> failure does not necessarily mean the system cannot make further progress:
> freeing the reserved CMA pages can return a substantial amount of memory
> to the buddy allocator and may relieve the temporary memory shortage that
> caused the allocation failure in the first place.
> 
> However, the cleanup path currently uses the bitmap-freeing bound for page
> release as well. That is only correct for ranges whose bitmap allocation
> already succeeded. The failed range and all later ranges still keep their
> reserved pages, so a partial bitmap allocation failure can permanently
> leak them.
> 
> Fix this by releasing reserved pages for all ranges. Use the saved
> early_pfn[] value for ranges whose bitmap allocation already succeeded and
> for the failed range, and use cmr->early_pfn for later ranges whose bitmap
> allocation was never attempted.
> 
> Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

