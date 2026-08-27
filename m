Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9CDEC61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 08:37:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D0B56B0095; Thu, 27 Aug 2026 04:37:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 981966B0096; Thu, 27 Aug 2026 04:37:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 870B46B009D; Thu, 27 Aug 2026 04:37:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5672C6B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:37:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C1ECF1C1496
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:37:00 +0000 (UTC)
X-FDA: 85146394200.16.67415C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1CF07100005
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:36:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LOWJ40ZD;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787819819;
	b=g4WCZYLF9iQ0i3khNXRKvh8FS4QVIM7QbumhMTvJev8QqNSNY73GTLd4b+XacFUR66r37G
	+s/anzZHAqeZqNYtbHBQuhHBaZYP+c9xls5xLbid9ndD/pWLRkpo1xy/D9jJPg5nsMY45g
	PqY9+BzaiGkEwLpZpj1l6FWgTRFpJ3o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LOWJ40ZD;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787819819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rkzdP2S548RxnrFBhwG8u6sLOgpp1gNeiux6b/1cAoM=;
	b=wreaq00WiBoQonhLmiWyT+K3jFZbvGLaGadljJmFci3U9pTvIkxVsIqZNMhkxjLrlfQBMN
	JoPZayYNLp4ibco3trFk4Z2TjM5/KzALarFv5QMow+7mIVsAvKRa+v/bde3nEcG3Sxqrht
	CevTEp5l5bahSe+a1HeW6rrjx05chPI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DE98E43046;
	Thu, 27 Aug 2026 08:36:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE571F000E9;
	Thu, 27 Aug 2026 08:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787819817;
	bh=rkzdP2S548RxnrFBhwG8u6sLOgpp1gNeiux6b/1cAoM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LOWJ40ZDmi5YS420LN9xd2O1jW1tratjVPqUYSVCBSg8n3KTiSQy3pxU0RsuiaiP8
	 6abWQINXVjomSW7EwwZ3ydvqAxdzRPEsBTJuKurEXKbFBc+i2SSSFYywxbAVHfB41R
	 rBfjDPoAVfrAkSZv9tQPxXwAfjmluaRgD7s0FMLLQIA/r+Eo+3vToKJoTjuYxZS/B8
	 LcbNples+T4+Hwqo+ajKrfDO6K5no/1myIhZi1dA2czKmK21v7byTR2DWTrjsdBtY0
	 uZ+5TtaTHFRdb7pmsK0zoaFAJeM6oAQnqZS02DNGu5SGMnyDWka15cPq9n4toxZ+I4
	 4XKQo09+wjilQ==
Date: Thu, 27 Aug 2026 09:36:52 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Li Xinhai <lixinhai.lxh@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+f12658786a4153df5113@syzkaller.appspotmail.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm/mremap: reset unfaulted VMA page offset for
 MREMAP_DONTUNMAP
Message-ID: <ao_25iegD62xA2u3@gremlin>
References: <20260825-fix-mremap-dontunmap-pgoff-v1-1-39a40b2c98b3@kernel.org>
 <34fa1a4d-e5fb-4e27-a53b-b57b96be3f8c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34fa1a4d-e5fb-4e27-a53b-b57b96be3f8c@kernel.org>
X-Rspam-User: 
X-Stat-Signature: f6byfoi85jgk9bnxsnby8tky48owc7mw
X-Rspamd-Queue-Id: 1CF07100005
X-Rspamd-Server: rspam06
X-HE-Tag: 1787819818-700000
X-HE-Meta: U2FsdGVkX19tMJPoS1S6S1TKijUK27B+QUzJYZgkU3X+X2mdJAueWCBGFIoWiHMikRZ7rwej7FxcYheree4lY9fFSeupfWwpYQWBzTXiUWgTQgktnRHFFlAR2Hsndgy3lwZTCSjKowoMgiVqRuxtMDDlsAIt0yg3FQ/TtcSb+1Sh7sZsnMCSxkHpvCTwGkeKVcPHxS6GUZBh0NmBythPqY/eG6HZkeVYsBQiy9rxNTM3zStBzI47QIA7d6jSn3yf0/zIp3yAkjTcX82N1ldYdBFMYfFWAL1xQgDX3x/XpljXO2AjL/wApy7fbnpc83tkTwSMYWwjKOUMqItfB2ZT/Oqvx+OgLHJUXaCx/wWkV+Mmm0kdL+NLyU5xaFFV1HSiY+QVBWQVhrIAlrDlSat1VywFhdWhxN/yL+QLwand1rCcFXKAe1eUkux/sb49kkIAktK/3f7s5kxE+f1LmdAzlfBwNGxO6rtKJF7tgf0ftkI7sOIMTUViur7l3bL8LxxQA1bEJQtzrHlx1fstnEm4xebl0KeOEYkz+VTpC1qtmtQzcgeT0B+y7YY5tw9JCDoF7scthrWRhd0kHYFoeTZhk3QRgwNfh3JwxVzKzdLEufd/BTaxJt33kQW+I57xsW5hMCGjlS7/NMrUdFRgD/iv2qehUj1g8En4ssczax3KZfLT91eHb6gYfmlG0dXGcFs+leuLCtRnHnhUFuvXko3OLVh7bccMfrvEBhbvpslueX103c5CdaiZpTjxLy7bk4WxPhDhjl2e7jnOXVzgulyJ2o5+Gy4/pdif/Vii7hPonH8/6iXdt1RrpAr45CwmgWdOEspN2yPFZWXLSbLPlgMaVXxe8iSNEaFJ6sPYl3z1U+oix0fBJmROyXImLjaE4mtENFwXT1ZHQgqeq4CtsaqRknJkH7PMz6gsGYS1ZDrwTAfM0zu2ckODkLAr4GHZic7RmolOg5W8dgMimgzm0oi
 WaLnoHum
 nQNYwvLW41QYp9Mkld9lYaCDlVQ6F6mlW8squkQlIhvexQSICELQe8gU+8WDh/cAhHctcvdClZnj4/JIkyA7lTpp+4UJe3S+FRmmwaErQO2GCixJYzduAGRu8zfFQWTl2GVZkeU9f45qrQJF34JyqffXGTpb2bZu9foGnd0E/pvW0RMt8DGSGrMhOOalDa3NwF5WzOeO+rxRrBu8KiBUuMo/tOLfTrLdxf8Bk7CJfZyV4LHGcylGhbJTSFTaYgEFJsxJld0tMRMvf6sUhFqQ0zEyHg71FB01si+vxRwBEUqJU6IhiGnY9GeFmtlrD/0zhjOdCVrTyS6VLUW6EIpShWX4XQ2amSD4JBOo2rZZSNyp6eIKXcwQ/8sBTbVTQUccp0CkUqQUEN1WtALctwZcPhyaySJJCJBAN5uXy7GgXDX5fXG9sIyQ5nlGTpDQhpm0l99EQ2zE+pKe6p3fXCW9McUn8mgj+flQNAHXudreMhG+F1xbdysl5pmpWOM11rcdyYesSjdfWgu2Z400fZK0zMRx5BF27bCQYV8p8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 10:32:15AM +0200, Vlastimil Babka (SUSE) wrote:
> On 8/25/26 9:55 AM, Lorenzo Stoakes (ARM) wrote:
> > Uniquely an mremap() invocation using the MREMAP_DONTUNMAP flag can reset
> > a faulted VMA into an unfaulted one.
> >
> > It does so after the page tables have been moved to the copied VMA with
> > MREMAP_DONTUNMAP leaving the old VMA in place which is naturally unfaulted
> > as the page tables it had are no longer present.
> >
> > However, in doing so, it violates the invariant that the anonymous page
> > offset of an unfaulted VMA is vma->vm_start >> PAGE_SHIFT.
> >
> > This is because a VMA may have been faulted in, mremap()'d (causing a delta
> > between its page offset and vma->vm_start >> PAGE_SHIFT), and then
> > mremap()'d again with MREMAP_DONTUNMAP resulting in the unfaulting.
> >
> > This condition is a violation of a fundamental assumption in mm, but now
> > also triggers an assert in assert_sane_pgoff() which explicitly checks for
> > this condition.
>
> Oof. So what's the worst thing that could happen before the assert was
> added? We'd use the "unfaulted" state to allow a merge, but the wrong
> pgoff could mess up the result of the merge somehow?

Yep you'd just get merging not working. It's a bit of a unique set of
circumstances so it's not a huge impact, but it's an edge case that'd break
scalable CoW assumptions that I want to use to avoid having to track remaps
so it's a good one to find :)

Definitely incorrect however even if low impact in the past.

>
> > Correct it by resetting the VMA's page offset at the point of completing
> > the MREMAP_DONTUNMAP operation.
> >
> > Reported-by: syzbot+f12658786a4153df5113@syzkaller.appspotmail.com
> > Closes: https://lore.kernel.org/all/6a87853b.ae6ddae5.3da009.0023.GAE@google.com/
> > Fixes: 1583aa278f5f ("mm: mremap: unlink anon_vmas when mremap with MREMAP_DONTUNMAP success")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!

>
> > ---
> >  mm/mremap.c | 22 +++++++++++++++++-----
> >  1 file changed, 17 insertions(+), 5 deletions(-)
> >
> > diff --git a/mm/mremap.c b/mm/mremap.c
> > index e8df5cdb0ac9..2b4b523a86b8 100644
> > --- a/mm/mremap.c
> > +++ b/mm/mremap.c
> > @@ -1331,18 +1331,30 @@ static void dontunmap_complete(struct vma_remap_struct *vrm,
> >  {
> >  	unsigned long start = vrm->addr;
> >  	unsigned long end = vrm->addr + vrm->old_len;
> > -	unsigned long old_start = vrm->vma->vm_start;
> > -	unsigned long old_end = vrm->vma->vm_end;
> > +	struct vm_area_struct *vma = vrm->vma;
> > +	unsigned long old_start = vma->vm_start;
> > +	unsigned long old_end = vma->vm_end;
> >
> >  	/* We always clear VMA_LOCKED[ONFAULT]_BIT on the old VMA. */
> > -	vma_clear_flags_mask(vrm->vma, VMA_LOCKED_MASK);
> > +	vma_clear_flags_mask(vma, VMA_LOCKED_MASK);
> >
> >  	/*
> >  	 * anon_vma links of the old vma is no longer needed after its page
> >  	 * table has been moved.
> >  	 */
> > -	if (new_vma != vrm->vma && start == old_start && end == old_end)
> > -		unlink_anon_vmas(vrm->vma);
> > +	if (new_vma != vma && start == old_start && end == old_end) {
> > +		const pgoff_t pgoff_unfaulted = vma->vm_start >> PAGE_SHIFT;
> > +
> > +		unlink_anon_vmas(vma);
> > +		/*
> > +		 * The VMA is now unfaulted and it is an invariant that
> > +		 * unfaulted anonymous VMAs have page offset equal to
> > +		 * vma->vm_start >> PAGE_SHIFT.
> > +		 */
> > +		vma_set_anon_pgoff(vma, pgoff_unfaulted);
> > +		if (vma_is_anonymous(vma) && !vma->vm_file)
> > +			vma_set_pgoff(vma, pgoff_unfaulted);
> > +	}
> >
> >  	/* Because we won't unmap we don't need to touch locked_vm. */
> >  }
> >
> > ---
> > base-commit: efecab401cb15fd3bb9bc05990609acb6b267ff2
> > change-id: 20260824-fix-mremap-dontunmap-pgoff-a687134e995e
> >
> > Best regards,
>

--
Cheers, Lorenzo

