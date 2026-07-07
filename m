Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84971C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 14:57:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EBCA6B00A1; Tue,  7 Jul 2026 10:57:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A2A76B00A4; Tue,  7 Jul 2026 10:57:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D9BB6B00AA; Tue,  7 Jul 2026 10:57:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0CE716B00A1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:57:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7F0E28DAB0
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:57:22 +0000 (UTC)
X-FDA: 84962283924.14.5A7CD35
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id DB780140013
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:57:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SNK7mSok;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783436240;
	b=mA20/nAjWzzH9TNBP7mC/7ju0KHOp4Vq+COBrjoDeir7GQpb/DV7OneeIKCHZAIm4D36TQ
	jsImG/Eb4lEBMIHwpI57w0MwtHAxEthc1eAmrLwTT8ED0nbgBhGGx3Sx1OAIAubQtP3fgx
	M4vX3UlnWPKpsxiLP7U2MWIcM8pWKiY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SNK7mSok;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783436240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P2vjmbjMy3vZ7oRtbv0eCFaCHMRnzEbJjEHjnyLeBK0=;
	b=lN37k+CGno7tCuJaFp07/i1Hk6H+wYQQJgXYk2CPetcaBX5F78zQ3eFtifV7ogsga7NlyW
	sqfTnv2YSlP4cmJn1oKC2oC7AgDCSr8+jm8sGH8qhKAI65PapHzuLjBhFav36RF63qacTK
	VtEqevjgZz1/b1+VFASFpZQyLV/Y0vA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 63E1160018;
	Tue,  7 Jul 2026 14:57:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D671F000E9;
	Tue,  7 Jul 2026 14:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783436240;
	bh=P2vjmbjMy3vZ7oRtbv0eCFaCHMRnzEbJjEHjnyLeBK0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SNK7mSokgCWpqfPi1jZRPTr23XF0hZ4iuApU4oYxv4oyU+taDfXcalL2D7Kgx1WuG
	 q02Pwto8RMmO5VNUNiguJnzKYgGf7itgSBSA3L5zjvZfGCN4AGbdKTEXWVH62mSCxl
	 T7QtZwQEZ9OrfF3t9ySdDTPhHC/HTgKC8A55mlVAFJF4VwrYvFSttPKXjsCB/Td7cS
	 bPBAkUUVHP9+t+0tubSBgj1dsWw0vJ3OJZa4IjbUdVUbQoPcJ7ArKPi/h/14E/3yEm
	 R+MHGGD1Y5WqOuC5XXMdlIOGzrdybpNZNUAeSsqrlY5Y5FKdP85z2hMcOkO+mWfhFe
	 238Q5vkXCWBLg==
Date: Tue, 7 Jul 2026 15:57:05 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Wandun <chenwandun1@gmail.com>
Cc: vbabka@kernel.org, david@kernel.org, rostedt@goodmis.org, 
	mhiramat@kernel.org, Alexander.Krabler@kuka.com, hughd@google.com, fvdl@google.com, 
	bigeasy@linutronix.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, akpm@linux-foundation.org, 
	surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, riel@surriel.com, liam@infradead.org, harry@kernel.org, 
	jannh@google.com, lance.yang@linux.dev, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	pfalcato@suse.de
Subject: Re: [PATCH v2 4/4] mm/mlock: migrate folios out of CMA when mlocking
 a range
Message-ID: <ak0TU506eGq2sYJf@lucifer>
References: <20260707125925.3725177-1-chenwandun1@gmail.com>
 <20260707125925.3725177-5-chenwandun1@gmail.com>
 <bd88f65e-000b-4dde-92f7-28af6a34e977@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd88f65e-000b-4dde-92f7-28af6a34e977@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DB780140013
X-Stat-Signature: 9o9wfm831orhhoi5h9qzr6c3685rdm1g
X-HE-Tag: 1783436240-722398
X-HE-Meta: U2FsdGVkX1+RMCtcBprhuBEikFAhSB0XGfgb2fdcd7LV9/113BcWWlzw84RoerZFok8+sGZ37JIAmVs0KOBlu1QZIl3GaVN6vBDi12Dff9of8dASjUCNleQwKzpxtmSsC6Lvgh3YpmW36yJNq5KN2liOueNi6bkL3txC1wiCZdlj+ROiHfq2oyeJ3PI5bW9fTM4WPiST4jXuPTNz5W8/Mh7BktCwI1jvLNGih8XD7EJ06rPVATxCd2Osof0wP9sjwCNpr9eg5E1QmjAqJLaI5dH/PytVub9TJ6AZgDqe0R1QQRghNqniCyKAnhVVSbtiaxmBAGQypN8KVv6AJGtDT0g2nesklk2qGExBhafmE6XxlRBDMw2O/0OwUyq9IMX6Jh9HfD+loPZ0vigWdFpc1InsNs5qTUI0mRRGAgnojJJIFqiE3AX+ovhiMiCrIOsptzQ+8SBkXkJGcOa+MGDPjzv9A4hGZbFxZ/LoBnD22VlcxTnA36UayI+zDIE7niPwi5TM65sdZJcTr5AfYwKMlkvkAywr8HEte8U7YuYfAViLylAtn7Gb2YZ6mQmrarHajC971X3CspgyqBLBMEeHL1PCaPlV6lK6/l6GklBneZM/IqYyP4eJ0MjbgGoc/w5Qs++BcptfaMgDtYzyk1UFhK0fiDeqvb+sRiSMBOfau3vrHOMX0ug4DyzPzHw5UreON94GNq9Ck+tPU6UIIHgUa8riD3kKPkBLtNllPsTO/OyftV6rA2HoMRAd6LyiOEr/Ee8z/K1B1sNv+hs/Su9OziCs0TdhIDjmqF+mCgk3b7Ak1TKNASxRSEqeS0XrF6E/QGv1MT4AxFzHPAxr9Md2qd4d9EzbEacVtXTMxRMH2rF6kvxLjwAhcH+6Q/4z0EVnQS/aSVW5FFGi74jgjJaR2tL0p/PMBlHqTZn5Dm187UB5ud0ZR/N2ETGIy+ZTgj/UFPcQMHakMkdxZurzW4m
 0Hiwz5+a
 Lz8u4m/Gmvb5npV+/5HnXcVzIle5mqX70Hr9VZLvBDrQCTs3Nfl2vJVc74JP9SoseWzsoxCUdTU9BJcUVKd6Mgr3SL6ICNK/FOR8MIFwJg5dX7efmIpRudviGjBObz2EoaQ23aykpfRiH/LatTNV+1nylyqxXAUGz8sIXyAWnFKCh12Yy5SAM67s9Gv2yMPBFMEe/8xmY8vWkvmvPaDcWEC32IESVnZYOv7Lw4HNI+c9oMz984DJOIZouOdsR4JuaWDG7nH52vZ6QGODlrj+9IFewubRHPtt6wP9sV9trdQSCVpiJM4VqkDNhOZbyb2RttRiGiRB1ABJVAl4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 09:36:17PM +0800, Wandun wrote:
<snip>
> > diff --git a/mm/mlock.c b/mm/mlock.c
> > index ac65de40b22b..f56c685533f5 100644
> > --- a/mm/mlock.c
> > +++ b/mm/mlock.c
<snip>
> > +static int mlock_collect_migratable_pte_range(pmd_t *pmd, unsigned long addr,
> > +			unsigned long end, struct mm_walk *walk)
> > +{
> > +	struct vm_area_struct *vma = walk->vma;
> > +	struct list_head *folio_list = walk->private;
> > +	spinlock_t *ptl;
> > +	pte_t *start_pte, *pte;
> > +	pte_t ptent;
> > +	struct folio *folio;
> > +	unsigned int step = 1;
> > +
> > +	if (!(vma->vm_flags & VM_LOCKED))
> > +		return 0;
> > +
> > +	ptl = pmd_trans_huge_lock(pmd, vma);
> > +	if (ptl) {
> > +		if (!pmd_present(*pmd)) {
> > +			if (unlikely(softleaf_is_migration(softleaf_from_pmd(*pmd)))) {
> > +				spin_unlock(ptl);
> > +				pmd_migration_entry_wait(vma->vm_mm, pmd);
> > +				walk->action = ACTION_AGAIN;
> > +				return 0;
> > +			}
> > +			goto out;
> > +		}
> > +		if (is_huge_zero_pmd(*pmd))
> > +			goto out;
> > +		folio = pmd_folio(*pmd);
> > +		if (folio_is_zone_device(folio))
> > +			goto out;
> > +		if (is_migrate_cma_page(&folio->page))
> > +			isolate_folio_to_list(folio, folio_list);
> > +		goto out;
> > +	}
> > +
> > +	start_pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
> > +	if (!start_pte) {
> > +		walk->action = ACTION_AGAIN;
> > +		return 0;
> > +	}
> > +
> > +	for (pte = start_pte; addr != end; pte += step, addr += step * PAGE_SIZE) {
> > +		step = 1;
> > +		ptent = ptep_get(pte);
> > +		if (!pte_present(ptent)) {
> > +			if (unlikely(softleaf_is_migration(softleaf_from_pte(ptent)))) {
> > +				pte_unmap_unlock(start_pte, ptl);
> > +				migration_entry_wait(vma->vm_mm, pmd, addr);
> > +				walk->action = ACTION_AGAIN;
> > +				return 0;
> > +			}
> > +			continue;
> > +		}
> > +		folio = vm_normal_folio(vma, addr, ptent);
> > +		if (!folio || folio_is_zone_device(folio))
> > +			continue;
> > +		step = folio_mlock_step(folio, pte, addr, end);
> > +		if (is_migrate_cma_page(&folio->page))
> Here should be, sorry about this.
> 	if (!is_migrate_cma_page(&folio->page))
> 		continue;

But above you do the:

		if (is_migrate_cma_page(&folio->page))
			isolate_folio_to_list(folio, folio_list);

Pattern :) so these should be consistent. But you're copy/pasting and need to
not do that so it's kind of by the by.

Anyway, yes I assumed you meant this. But see the main review, I am not really a
fan of the implementation, overall.

>
> Best regards
> Wandun

Thanks, Lorenzo

