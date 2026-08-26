Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42881C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 18:37:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2204A6B008C; Wed, 26 Aug 2026 14:37:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F8706B0096; Wed, 26 Aug 2026 14:37:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E7316B0098; Wed, 26 Aug 2026 14:37:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C6E906B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 14:37:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 502681A01B0
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 18:37:00 +0000 (UTC)
X-FDA: 85144277400.22.D0C499A
Received: from flow-a7-smtp.messagingengine.com (flow-a7-smtp.messagingengine.com [103.168.172.142])
	by imf31.hostedemail.com (Postfix) with ESMTP id 562072000A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 18:36:58 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=LBQpOxrt;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="P ICJpeq";
	spf=pass (imf31.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787769418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AXIwP4yu3TNgPvU8yf7Hptdh037EP7WEY8ll6DN52k0=;
	b=DOnGHOLYYvoetqt/mAKLbKFNe/IugpEyMAg3q50XyE6WJrLSRLQWoE0L/RJcpxzf50kw12
	D8DBHm6q6+5PcpaFzVCcv6vNnFJ5Tit0yCsAFe7T59DOn4TQxZkSzoMj+4WaRyjOSpofFT
	yup7NFhKybDUCjO+i0V64B4Nnuymmhc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=LBQpOxrt;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="P ICJpeq";
	spf=pass (imf31.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787769418;
	b=2w9+2FqlZrpcYAQru6SbYINOmAbuxzgD+FF+T4/uwGQ/CSGqYd9xxNJrwFSlviNBOxD8Wu
	pnBcC5TzYzQBMp0/HG86IPVz5EmejdcF4iQRs1ExZ43RWp1HpWi16pOeRJnGpsd9olRf+y
	+64uGkd6Cp3BvmfR6Ev1J0bYVeM5VyM=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.phl.internal (Postfix) with ESMTP id AE72513801B4;
	Wed, 26 Aug 2026 14:36:57 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Wed, 26 Aug 2026 14:36:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm2;
	 t=1787769417; x=1787776617; bh=AXIwP4yu3TNgPvU8yf7Hptdh037EP7WE
	Y8ll6DN52k0=; b=LBQpOxrtTh0AHm/+3hpS801ONfmbZP9VZohFOzrmeORrKAyE
	mfWglKIzlVEy4aDkGX4U7Nd2uG61ARVxQ99LCXHLb2f52OcX4q568Do8pMNgX1EB
	JCodDojYQ3oohyoavf5mI9Y7qEDGhyJCBbYYlV3Cv5ka7yeDQcWbCwAVUXvGDEs5
	6ulyYs61+t2saIh0T1yeFIP1+1rdyA9kCs53nUTnV62J68wIv/eDr/0Yzdo85X5f
	ytpEKZIhlWpckETJNDj03trvdRpTO/EAyQYkL4gOmaqphScmw9Og7/BIO7G+S1NY
	0Y+BGlxUup4Pw3TrMY0lgv5fwb+VEj+pvFYM+w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1787769417; x=
	1787776617; bh=AXIwP4yu3TNgPvU8yf7Hptdh037EP7WEY8ll6DN52k0=; b=P
	ICJpeq4O/lZ83UnijZ76oQaOd0AY9+7B63YWSQdHDt8EQiEZKjTqjbcJAe24zkrN
	jgjih3/ny4F1kz9V0gWasKr3YENujNTB99kgXVIThrEm3RvKxFlv9ndGmL2bmdVX
	kuuoNebxCocF1OBBPfy9ZU4AfIU12Cf4fav1tjEF1TTHdWWoZlbxYP9TDg0ame/h
	xIpfFsfeWv2KGS/HlyqCXG/lh0WhN0eU4kzYTAKEeGdSFgtvUbebtZaFT4zU9QAZ
	BfSVMm+3FjOwLOAocQBmTKCujfy5CLOaCqVzDiOvTLlCdn7nUHAAYQE1zm6HtmQN
	yOe2yiTEAVjjS5O45Qogg==
X-ME-Sender: <xms:SDKPapBJp1ltJAcyI_xZxiK78XLWsqgrz-iF1XpLTIi560G_NG1_tQ>
    <xme:SDKPan8qJEj8Kdw4-xB5grKYqzXe8NQmwdtWlLFp7__J4HOlggFZ2V5Y6_VBYoffb
    wWeq_BwN-2jVNWP8jj6bqY2hALdTJmBVngXpkVnyaujqDRlaG0b3A>
X-ME-Received: <xmr:SDKPamDICjFvcSeBnDqbKwk0CFKzWV5NJbgp-l7ZNHVkJkI_2wu0EsHfW2M>
X-ME-Proxy-Cause: dmFkZTELKOeDfHJP+SHbqjYVk9pwKUGicSk1p7GbSsMsayumgkGRXk9mkO2sicvuyEcat5
    L0tWOhfSHJuXVtqqVdF+NmJMI2h+ZOwn+i/DBGVryOfj5Qf49E1quVQOsDdf9ZZ1sJ9xbJ
    poFGDwDqJ51N4cJIM57auo6jEn+a0yODvKmWYzxEJ6fNxbovO9GSlEdv8xp1MFbZ7Gokp5
    0ZsoL7HwOxjOQe3XnPllK3jRr9Ofv4wbQ2A32YyrpJPvYjpNqQkzKyvfjTe1H+XVKzp2bs
    aIU/y7f44kV0XbgBtKHpikGU/conieH5Ql/3SuDnp1P7HO7ccqQ5Tavx6wyrRHArYDQuZJ
    ReEsdYa3AmPew8cuddJjokVkzPRPJmZd3YlR1VJPyTAdqY+NL6xJM4luZPV+8/l6Qx0i9O
    c9WxaMXcW1JUlkaxjDZucSeXgTS/zXknXXvZdVJFUlbsLlDzdcNTONOx03t+BYALB9FoUb
    Po9QhwdvUkdZ9FHEcBUPl8FCsJoZyLrHtuPH+oNiPTl7rCXWhkQ5OWb4qtHqQsjhDcuosz
    W4oad3YDjgmSVNIwJApsoKdvnMi34LkabWs4R+nruTIkDihbTb/EoObomeIcxmI2pB2DqD
    qOFNlmrgXYkJv2fQY2ER4UL8Q+/bttFG5DVaFN9gi9zcXFGljyS+Q/3/ve1g
X-ME-Proxy: <xmx:SDKPajy4yLZEPMicPsIi4xXNZ_gD_9QLorXtAOJgUfsRVB1ilFOXUw>
    <xmx:SDKPatrF2xGnxB3V1_26vacIGFKy3I_TIuM_sv8KI4y08pupxtHgBw>
    <xmx:SDKPauxU2EdL8_UHOWGKWqqwoeKyz1-vF4wS8jvs-EEQvArn1PO42A>
    <xmx:SDKPavNCdt-kJhS7kWSYEbYSl9IkMxdsTmfZ10ubOqiJ16Poy94WbQ>
    <xmx:STKPavZhSWl6PxYOxr7AqrDZzd_-81pOFZSznr5dBkWVsS5jsszOR2Mt>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Aug 2026 14:36:55 -0400 (EDT)
Date: Wed, 26 Aug 2026 19:36:54 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Jann Horn <jannh@google.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
	dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, liam@infradead.org, 
	mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org, 
	surenb@google.com, usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com, 
	usama.anjum@arm.com, agordeev@linux.ibm.com, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, willy@infradead.org, 
	pfalcato@suse.de, rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 19/57] mm/collapse: install a PMD leaf as the
 terminal layer
Message-ID: <ao8okZ-A7cnvoju6@thinkstation>
References: <20260816224609.308019-1-kirill@shutemov.name>
 <20260816224609.308019-20-kirill@shutemov.name>
 <CAG48ez1fiCzTMATN07HHfzvUGFuZ5gELNpZXdXx=ySa7nihxmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez1fiCzTMATN07HHfzvUGFuZ5gELNpZXdXx=ySa7nihxmA@mail.gmail.com>
X-Stat-Signature: 7sj19ddpytmjtdh17t45z718xa1ab784
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 562072000A
X-Rspam-User: 
X-HE-Tag: 1787769418-739680
X-HE-Meta: U2FsdGVkX1/RucK+Z+5cFYrMY9a8PfHRmjeYa25LQqEqhmzdp5EqQcuXka8ijFkTpZIGMwxsgkAWbSyXlqtdNN+4egTQlFC1iE6XKudiosEWTEAFMEd5mivyP/xMIdQtKBLUZw0O33J42717MQ2AiMT0zZJRe166b4L1/l7E9R3T7sECDA+zxsJUIi5UA3vbh/kghO/jnMiwYysYjnFY3EherkbZZHhxshN1GVUXfl/oQEJrjz821qZVjKJKvP+lEocuLR5MZV/JI6s7cZ5WhXVJFTxMhASIKk4SGtiVmKn0ppDv9KIFBJqwHV0rKygD6wDoUQvyag66xO4kjkSbWY1ZNy+L2bar+Zo5RC+dHi+hHBhLudnrit84aeyWjKMCwcY+hu4ZW5A/0UA9RUlrSe299MB+2I3KkOXo6urojuyGgye+vbyo6FpN+94//IEF8U3+NjPy9oWnTvChfkSsukStIA47pNwSQMrRTsBbvWH17TNwOapW2kY3VaVoJO+U3nT0Fk79m36uOWNpHBNfxovGd7P2ggorIXrByi/DDZswCDIF/+Dpz6Jc3bHxvPWxk+Aj9iMQoIzB8H7JxgYON3uQXQW/+7CA8oz1r2vNstyFKUCsU26S1HBtwipzSSXDAFeOAl3GxRVOlgCuWlY087i6em2rPI1LP2klJDtwMKZoOXPK3Q/XhnL3p2bwhxGuq190RZ4FUiL8SYpcf2SY+GARjjn5Tq6ioS4p1T0nl3g4IeRdRTQVlvmYmBY+qBFuP5GhlY2tDNaTUjaNZejYaU5cZLJvIgH2ZP+e5TX4rdLn9vt8ckBk5MRjFtT0FsXMgvQ07fP1sZp4jtVnrr9rFJkiCINiNPYsOfhl+hXmUfOx40uME1A06pTFip7cUbzujAn8rqq6UpOd7ctmQnV6jH2W8V5LPRFKujICPGqoQtp8Js6zzvJZG3Qs4+Zid9FXFtrXSuPI+O1AmscXpE4
 Xc4pbI4r
 SZhtOpg3a6Kr7JyJDwEB4ZZ+g0oaAt9guYSaLbGUAl7uCJS7DMpf41BUmIrGc/2ffV3oMAPhQKmp4im0W5uKJh6wjcSyJ313kGrpqR943Zo8pTrfoYOR6n/Gwf2Fl7NZABr1ncBNgjwSlQuEd86EDjP99EjsFtS1CAdFyrCycLHFxjd76neTwDqCpPB8o+4pNYcxkzrBOXUMxvV/jeYU1TaaSo9KSUpvsPpafBWwAiJDZK8f/RQyL/qzmrmwNvb1cCW3ssHvde8XkKqi9WOZmeJ/X6FS4YBhqepkDScIvglWc2m5Zz0P+X5oOi6Z19cZiUozplf1A1bCIUPjW/AmxbACqFuhH+8Pb1qqV2H45cVTHR2Cmxw0DslHZCGCLgJWXx/a2RQ3h1eONjukJofRlKeCvf9EAAZXJSfZR3P/IyycSThoFYkm3nrmSHy0HSYzYZmG0po+9MUrncrQ8jxSFJ0q5mQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 06:52:17PM +0200, Jann Horn wrote:
> On Mon, Aug 17, 2026 at 12:46 AM Kiryl Shutsemau <kirill@shutemov.name> wrote:
> > Fill in the PMD install.  Under the pmd lock, with the pte ptl nested
> > inside it: verify, detach the table with pmdp_collapse_flush(), deposit a
> > fresh one and map the leaf.
> >
> > That is one atomic section, so no pmd_none() window ever exists: faults
> 
> What do you mean by "atomic" and "no pmd_none() window ever exists"?
> Is that supposed to be with respect to a subset of readers?
> 
> While the PMD table spinlock is held, you clear the PMD entry
> (pmdp_collapse_flush) and set it to a new value
> (map_anon_folio_pmd_nopf). But codepaths that walk page tables don't
> take that spinlock unless they already know they're in a THP case.
> 
> zap_pmd_range() does not lock the PMD table before checking
> pmd_none(), and if that is true, it skips over the PMD. I think this
> means that THP collapse can race with MADV_DONTNEED or zap_vma_range()
> such that the zap wrongly has no effect?

Yes, the race with MADV_DONTNEED you point out is real. Thanks for
flagging this.

The idea I want to explore is installing a pmd_mkinvalid() entry rather
than none in pmdp_collapse_flush(), so walkers have to serialize on the
pmd lock.

But it was a long day, I am not sure if the idea is sane.

> > stay held down at pte level by the migration entries throughout.  It is
> 
> But you don't have a migration entry at the PMD level, right?

Right.

They are all at pte level, in the table being detached. What
keeps a fault out during the install is the pmd lock: pmd_install() takes
it before it can put a table back.

I will fix wording once the pmd_none() question above is settled.

> > what lets PMD collapse run under mmap_read like everything else here.
> >
> > Two things force that nesting, which is the one the tree already uses to
> 
> I'm lost, what is "the tree"?

Upstream.

try_collapse_pte_mapped_thp() and retract_page_tables() nest the pte ptl
inside the pmd lock the same way.

I will update wording here.

> >  - rmap walks on the sources are unreachable, their refcounts frozen and
> >    their folio locks held from freeze to putback;
> 
> To be clear, we can concurrently rmap-walk into the PMD, right?
> Because we might be looking at a different folio which was created in
> the parent process or something like that? And so a
> page_vma_mapped_walk() without PVMW_SYNC might look at stale PTEs?
> (Which may or may not be fine, but would not be what this commit
> message claims.)

Again, wording should be better here.

A walk can reach the range, but it cannot act on a source: that takes the
folio lock, which the round holds from freeze to putback.

> > +       /* The deposit balanced the detached table, so the count is already right */
> > +       if (old_table)
> > +               pte_free_defer(mm, old_table);
> 
> What does old_table contain at this point - migration entries?

Yes.  I will clear it under the ptl before it goes.

Not for the pattern you name, though: a pte_offset_map_rw_nolock() caller
owes a pmd_same() recheck and page_vma_mapped_walk() does it.

The exposure is the plain pte_offset_map() callers -- pagewalk.c,
memory-failure.c, swap_state.c and a dozen more -- none of which
rechecks the pmd.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

