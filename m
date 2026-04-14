Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52F67F9D0F1
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 20:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA0D56B0088; Tue, 14 Apr 2026 16:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2AFF6B0089; Tue, 14 Apr 2026 16:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F3466B0092; Tue, 14 Apr 2026 16:22:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8AE906B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:22:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 22B938A956
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:22:57 +0000 (UTC)
X-FDA: 84658285194.24.0162EFA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 86A4A100007
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:22:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KHUIc4gF;
	spf=pass (imf14.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776198175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g0BOTSZw3JUAooz4hns/HXPGYw6HkW/NtZR1lkjpMAQ=;
	b=Buxls0vpQVeDyx5appuYUCMRzinbmRNYFc6AQH4jKsvMuv5paDrYBcJe8hhDYWFP3lVJ9w
	wdgnPr765l3+b+6TWwMPWMzZZ4T9PvrcmAe73QJl9CZb5CWOoO93njaNfuc8yyBJ4KyM1x
	xmPSNws8dvYZ7m1Tc7V1+fDFDJnG+wo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KHUIc4gF;
	spf=pass (imf14.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776198175; a=rsa-sha256;
	cv=none;
	b=6dd+v6qeimrKXLy121JFDpYsodJLR4Ug70+NqQlSPq7BZmHlK18TL1l3JoAtVSlAtCdgR5
	UwbWteZLJYfs7zb2c/nDQnUb4GP0QG+EPDPC9km61nTkH18iKcAWxDa4P3qnetaYAxJFgy
	Efp++Ewfid3lPjc2cxmk8qRYjCwkdrs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EC89060018;
	Tue, 14 Apr 2026 20:22:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BAA2C19425;
	Tue, 14 Apr 2026 20:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776198174;
	bh=cfjU5QisdEAymeM9swyhg5uyXcoLzthAg7VU3GjAQvo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KHUIc4gFg+pCS23EISb63Q1xNtlb0VkasazOG12l6Y/MFCbJ8Bdb4id4lsgSmHsEy
	 inBDFxO2X+xqw4kEUVDfRGKvZ1F6we/nH7E5AoLJzpuwqTjJa+8gyCZ5LMLu0RwQfB
	 U/CHZlqlk8SoXPnQnyiKRB9YtluBmu6BPLWD9ooKrknUSXPMit3YotQqC2z+1QQjpL
	 Q5BqvFUg7RJNzHGyYteiBs4sJQJ1bbQNiCtI1pQ4cXzLr7sxKgzJtJDVRHJ9g/ScEc
	 PDLhiKq7E7WDbGvRgdVsNdUF4NpZnCHZyIuW7J90tyBzNNIrNElPr4z+a2Ih9sgcF5
	 +0G/NkdlQ7Tlg==
Date: Tue, 14 Apr 2026 13:22:53 -0700
From: Minchan Kim <minchan@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, mhocko@suse.com, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [RFC 2/3] mm: process_mrelease: skip LRU movement for exclusive
 file folios
Message-ID: <ad6iHYPA3v87j6ba@google.com>
References: <20260413223948.556351-1-minchan@kernel.org>
 <20260413223948.556351-3-minchan@kernel.org>
 <0c22f74a-ff3d-405b-8d9e-a7222f5b9dfe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c22f74a-ff3d-405b-8d9e-a7222f5b9dfe@kernel.org>
X-Stat-Signature: 8m4qfky3iamyp7p1imio6spj8qgx7ch3
X-Rspamd-Queue-Id: 86A4A100007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1776198175-806232
X-HE-Meta: U2FsdGVkX1+PdB1qvSWcvlrmHYOjIyclmiOmeABmpi7GaMbtDmo2HI7Agd7aN0GrTm/em+TQCNXfjzVLNaaK1a9X1Bslvr8r/ZUwMh4gSc5pcjgY/TkzBOFzY2HER8+M57IGDro3J1Zr4SOA0J9HD6ReW1jD+32f3ktRS+TA72hKR7N0h6qwx7DNtBZ8eK8rA3em4jtXx0iThrr9E6VnnQ4fIR+l3/2H6VH75xE0WXPLpAx8yIB+zNLc292SZzV+T69uwq/QEUAvul53hBatfmpzT8VCXHPN4rQCcGaIHaWU/0KT2WjmFdFlO1qSgyA+aaXMimUzvNrLy7CLCU+IJW6YyrBFpdHgZhmg1IUx9P+dyABqKNDXBtd6zqkjmlEjraVa9FVJ/xYMWZF4kKIG/w8SUFaFQhYgM10j4QmyncxUaDrDWKKlxJEONL0HXmRH4K5i6NesAHp+eHO++ot2wrUwm6eaaIuG4iJx/zPrlhLBV7gm6gB7CBN0tQoa+JAeA+M0iBUxfVCnE+hTiBY0VilztCBzBQGZDsFApbVHiYdeaqCoCocpSIr6GNErGOEzaTQ876uJ4uaCVtmKPur+dO0ogneG3wk93u6u9kbyLLJa2uStI264i2+2gOWpoprUXZ4QhCzTIjlC5GUmr3V3qCOV8WfbkbecfrQuBozZhg8rARkgPjM3y/rQRSG6C5OGQ0Sd5BhZFeTeEqLQ6KjEcnDwJaitL2bMIbe6YRseSPpyWr8mZi0d57/JjSOTdcOdqt7wLX7Vg9BlCvNBfqJSgxbj1muls3GDgPfgoB2n1MSjeqaJHxNY/J3GPZ5E7ie8qIIZomxq1Ovdal/PeVrWkYFBrqP3b9Yq6vgKAD0jBOdACImWzeOYPllcMK1Fm0/+vXl3xmbuUY0jd5P1hWDu5tKIuE/CXdS1mp9B6m3Q2McZTl7AIWhnvu6ganYlkVzyJY2CJwAW1iPfDmGGvKH
 1JsIYcwh
 Ngu2lLm1sTR32kQBDlgxOK325wHCYqtChhqW2s/+OUsGs4KgTjXMvv7sWezwCIv9dETQ2PRMu5qGpfSeMOCu+MSUMqharX3iuMcZaWoYZq1y/YKrE1GD7WeQ9h9iKnhC123s6LEzNIm+zu7RqU30gsgQz1iXTMXGpJKgrdrPlZEhkgfW8eLD2TJ/GSX+4Wtypai1vtscyOyvkxmaA2wDQ+RaS5S1CjSyT/EiXtO73pjY7RanA+eBPVr5uNc3vd8GifXqp/yRUcelnxKw6U5PLD3IQpPOYe+Yji4KjH1kwump6PS+f3/RCV6s+Ue91g00rT8kO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 09:20:25AM +0200, David Hildenbrand (Arm) wrote:
> On 4/14/26 00:39, Minchan Kim wrote:
> > For the process_mrelease reclaim, skip LRU handling for exclusive
> > file-backed folios since they will be freed soon so pointless
> > to move around in the LRU.
> > 
> > This avoids costly LRU movement which accounts for a significant portion
> > of the time during unmap_page_range.
> > 
> > -   91.31%     0.00%  mmap_exit_test   [kernel.kallsyms]  [.] exit_mm
> >      exit_mm
> >      __mmput
> >      exit_mmap
> >      unmap_vmas
> >    - unmap_page_range
> >       - 55.75% folio_mark_accessed
> >          + 48.79% __folio_batch_add_and_move
> >            4.23% workingset_activation
> >       + 12.94% folio_remove_rmap_ptes
> >       + 9.86% page_table_check_clear
> >       + 3.34% tlb_flush_mmu
> >         1.06% __page_table_check_pte_clear
> > 
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > ---
> >  mm/memory.c | 13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 2f815a34d924..25e17893c919 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -1640,6 +1640,8 @@ static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
> >  	bool delay_rmap = false;
> >  
> >  	if (!folio_test_anon(folio)) {
> > +		bool skip_mark_accessed;
> > +
> >  		ptent = get_and_clear_full_ptes(mm, addr, pte, nr, tlb->fullmm);
> >  		if (pte_dirty(ptent)) {
> >  			folio_mark_dirty(folio);
> > @@ -1648,7 +1650,16 @@ static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
> >  				*force_flush = true;
> >  			}
> >  		}
> > -		if (pte_young(ptent) && likely(vma_has_recency(vma)))
> > +
> > +		/*
> > +		 * For the process_mrelease reclaim, skip LRU handling for exclusive
> > +		 * file-backed folios since they will be freed soon so pointless
> > +		 * to move around in the LRU.
> > +		 */
> > +		skip_mark_accessed = mm_flags_test(MMF_UNSTABLE, mm) &&
> > +				     folio_mapcount(folio) < 2;
> 
> folio_mapcount() is most certainly the wrong thing to use if you want to
> handle large folios properly.
> 
> Maybe !folio_likely_mapped_shared() is what you are looking for. Maybe.

Didn't know that. I will use folio_maybe_mapped_shared in next revision.

Thank you!

