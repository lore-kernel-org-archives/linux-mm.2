Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AD37C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 11:48:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8511B6B008C; Mon, 14 Sep 2026 07:48:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 801306B0092; Mon, 14 Sep 2026 07:48:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C75F6B00A7; Mon, 14 Sep 2026 07:48:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49FAD6B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:48:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D3BBB8035B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:48:02 +0000 (UTC)
X-FDA: 85212194004.14.631390A
Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	by imf03.hostedemail.com (Postfix) with ESMTP id D581120009
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:48:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="l 5MB2Ze";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=rDKaeYhm;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.147 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789386480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nhu7V+ysH98/aFNClZZEmMq7xZMdgb3VIE7Ho88hbAk=;
	b=6NGk+0X3PI0xzSfKPIQYimxYL1ZNWaBFVDS0ksL+Ib/MKOUzpIYx8gYWerrSerxpn9MA4H
	xi+bMrntgkZ6Z2hJF581GQwjwmDYc54kQUm1I66KyqfJOVihWRRdHG7A2spEv8EOB3r/FJ
	Kl4CfKAtTDwvRtmfcZ02QFa6VgsSfjE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="l 5MB2Ze";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=rDKaeYhm;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.147 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789386480;
	b=NiD8QHj7/qNQppZszQ9VdXWBgVcpZhtSqwGJWnm1rm0djaH5noCl3RcHJ4/LX5+AnTaUNX
	I6Lf+VJ9PFQS6G3U08sHvm5MjAtWxbU8Q+TUFA5ef2DOcNcfMdjAPODg0gTjvFg77QqHpK
	uW8sl6WMigCe0j/oh5OZPcsX3lOwiQg=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 5BD41EC05FF;
	Mon, 14 Sep 2026 07:48:00 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 14 Sep 2026 07:48:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789386480; x=
	1789472880; bh=nhu7V+ysH98/aFNClZZEmMq7xZMdgb3VIE7Ho88hbAk=; b=l
	5MB2ZefBlmvesAgmegSkrGLzkzUf2gH3U5D432D1ny0V7nL8YLSkYuZ2D6ATxm22
	avZ/TjBHt/j9LQS6NcNzFeryvg3sRc9+6JslC9ScUOGGcMybxmuVXDS1IzeAcqwe
	BxWxQsQ9LxiPEwg4TtRWRNf2MOIfqVWwfEfAFBcE7+Foy+w3y4N9s3nitkqlnU8k
	95MZggqPBOXjOkUVju6CO3CLKAQ+LAkCZo0os63UhtnQkkv5v4cgN9NBcUMsNbCr
	4ZSo37ulhtbFZoXlVgX5xrD9ywd4rR+8HaPJhJfXlYJRzlTDquL6Ee98q2bZNHgP
	cg6gmjMhv9l/1zrbBmfGw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789386480; x=1789472880; bh=nhu7V+ysH98/aFNClZZEmMq7xZMdgb3VIE7
	Ho88hbAk=; b=rDKaeYhmXC1vA6tII0/v2IWlw45I+CIz5y+PyQJko5qMA88e5Pc
	aDlfHl98tvjK35/OG3hY309WAGZwAiedhf3uJHnttdmWMRAhAlnBo39G8mm+Sf4+
	G+NJgo32lIBOZRgpAlp6j4eV9Q1LJpO34KO14inUbwM5J6QzEmQpLRfHjkTzPtFi
	ZJM+CRK/kuOjftxhvfAR41Zyltqt1LYHwTScalS7rLZqoiAxGGqOp4OCGROcc1iT
	9RBmvbvrWi4CSPDBhrvl+70wRdu3qg1GOo7w3UM/WmSV2a5MZ1nj1ajVSnbqcvki
	boST5mrvwYoZGlekP04PcV1p26cWNgl9DlA==
X-ME-Sender: <xms:796nahitoQWg6_0Bu4nPdqdhLnV-iNvZm4Grd3wXJvdXcCstg7WFMg>
    <xme:796najr-GVfeZqTMBjxctNrIBqVWwmhrnOhgvRFujLVYHMpCzFYWRXg9kepb03Edh
    x_Ecepxo8ysOg1MLkZL2FJsvL-QTe48OiVBjCpkDPZbvsX1Q1-Eznpi>
X-ME-Received: <xmr:796naofsKemcZu_CAW9HAOOV3eqUWUrXyee77KTxNrsiIArkK0tUeQH7HAI>
X-ME-Proxy-Cause: dmFkZTFYcUDJMowE9JN8nz4OFx+gVOBEBH+t8GLwIW5cVX5aQlsigM3WocSdwL8FChn2PE
    lm1yyhomAKAJMsKZ0vvOqI09MOV52VgTbuJ2eXgyibnylHJIBIL41ORpFpFRHfz6VdI8Kr
    ViGFqPZEuxqogt0cVWqO5e3fxEXI/CNRXfQ15Mf4uMTo2wwuFNQlHQ4gOggsEb0117tCyF
    zUoiwPml+9T/CyB9dpoVPqfZv4uaL+ABItxp0DoeXXWIbjrFI4Iq+8/t4v4Bz311MZgpQV
    I7ssRm+d+zUxAOgskWGBnF1dhbKa8MKw7VBGpWOsHDCxNJd2YafXAVeIGPFBy3duUVW5fF
    HPh7v++Vv7JUwSdVperfS+M7kvVowFLBOvvFJlH/bI2I/ou9RQvV4BO8kM8aFY+NMzf3IW
    /6saKp/FzRF5O5qfv9I2rZLSvlcLyUi42irbeRCBzChi1NM8DzeN61fKNtpfGro1EEFaqz
    KSo9NbleERAQ7LXogIoLaK0dCmjibUiLv1CrgN+v2tQX+pCyACUgXPeX8L7fPy59WOd0tC
    +OB8xVe3L0PCXcwfZgJ1oz7BxBu67aZS1PKe444p9swprWoir/EpwI1bN645lL0isBZCA4
    DhuD6XPWZoqTqHNTo8CRWH6SaxTAfq/u/QxDNY292I031PqUzEVNpJNzT9Iw
X-ME-Proxy: <xmx:796naufL9uE9Mj5woEUD2SmDXmm_rvJZL-mGpPSlUG1e4WVOMVro1w>
    <xmx:796namcTIkaiyydLJyIfWlIJ7MFQmJmo7D25jhffxVpg2jLX-jlGUw>
    <xmx:796naspNdJKdirZ481GEzlfiNQ-UnkB0SANiszav3T1jnWx7uFq4Kw>
    <xmx:796nauzlfsZtMmoYj_a1k0l1GPPCArGSFTkcohmTtdmmTuJKmwwnlA>
    <xmx:8N6naqmDAzD2Xx4pKOtBKOkHD9AxLr8fnjsJmL0rcXRXoAZrVLx4Nc6V>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Sep 2026 07:47:59 -0400 (EDT)
Date: Mon, 14 Sep 2026 12:47:58 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH v2 09/12] mm/collapse: open-code collapse_single_pmd() in
 its two callers
Message-ID: <aqfeuAPx3lCKSXtd@thinkstation>
References: <20260910120238.2529819-1-kirill@shutemov.name>
 <20260910120238.2529819-10-kirill@shutemov.name>
 <DLCTWPIN1HRO.2HK4RPZ43F301@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DLCTWPIN1HRO.2HK4RPZ43F301@nvidia.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D581120009
X-Stat-Signature: burd6dc4e3mxwipwboc9wb44dq5ys9uu
X-Rspam-User: 
X-HE-Tag: 1789386480-295086
X-HE-Meta: U2FsdGVkX19U0YuqF7T4c3PgyKobQBVsT/G/H50VsMjT/eeIe+DRDpkpS1DnYlZZNEhyICswlv03TJ7o/CoNXvcMDjWINXZ7gMyqGSL9jt0NcFf2j0ybc+kKFRPPq9xbKOVbyrFFGHXco35ePLrGCvsF/gGEh/ftFSuwLXEKwQPx1ummYxKZ+ViM1gBd/m/+D9hAaLNDr3n+dU+KH/AWvYtGR46BsU/1oJpZrk1aAjXGZZkr7CRm/cNXvKdGqpDlsS4VphxIVGhAvdhdYhBIsJX4Vn1vEpK6XRc2Xp+lIL9Zgr/hyxTURs9ZCwspW5+z+H8lGYAAbF4T28b+MghNuRW6DHtztvR4yeETAiFgJNsHcbwuZBOKvBUrnSB7NGhxu53b5KX00ifZoPIdpWsW1h+oMvI7mcQleCV5m3BOoBLqHAaLvd9OxnMzlxUcOKgZ/AQFqVGm/BK3t8EUlkB3pw4ZuleU+gdkDPdW/n79bgxs6v0t/bhhdbIWt4ECJ+Eevua/KkSCIr5Zw2fo+82xlTihIoW7Ge5AvC6AtoNUaQUjUqcdRBWtM6fYc9IH7xyvaeFhv1S3GHvxNiUg2jqNhaY+vHUDEv5DU5f/RqMKLu5NUXCO0pewEB8BNYERcC0K2inZYIcd3IhFp+qlrQCzcnx3YPd4Rw5YmXZ/bEY9BoW+ZgZo4H+PyEL8ABaP4Hb0Wnb7ZvE0IB9Eejrvya/AyAUIsyhD2zDFxmPvNcOU5uphrwrRM/Co1/QTExoHa0uM/4QyeMV6IijSP3BXTQUIu8SuJTdeKlUsmm1tUjN5VO6PoOnuWFBuaeLY7Rp22N1KdAuupKjhl/o3RPaJj9XhFgNNhjJBR9UBROwGEKcTOrEssYAE0btjkJrD1HUK80ROEtdij5d8tYjNF2aFrdOoFOZ3yq30yS9+i2WIYHEyV0md5Y6gDvhBnsSo8T3Xn1lm93LMqTurzRBfYVSzbhz
 LiEv57Qk
 7svrnL9mlnZEgsLT0/GGuRO7s6MeGrMzRZli/PbTFP6hmki3Rdp0ywsFWcqpKtD57XOinbGyhVMQJ/+f2cAV1kamFN5vxf9GBBFMKeiGMj3AYF7xRfvviDDI0tr+mhMxaYJ+o4epkwrAg+UqIdzyycI8PE5nBtmUrQWWF4usPo9LQpNwq1Nr75F35W8LFNPoda+0ijEUt0Sdm/wRnk+u2++TyK30SgmWNEtSs2vJw/Nt9QTEaEifgDBjvxPdFUtPUlYJNRA4VsDqoG3jhdi7rk+Ob+Z80BxiLl7aTel7r48nr1mtfySQh6CVejx3Eq7fWnrlYB5BKzshWuoY3y9qdMDOXD/k01TrQjOk2wv9g99qfgv5XRBWqvY97uvdEBLOGTfweqGB8pCreJ8FHNPnrr3EyeiCcIvORHGSrUYp7I5svv3PMaBcl6YRz+T7ziStANh32Ytqt4Wg2u86DWOZMSdUucciwCuc5HXeLSDPrMKfTuctROv6LHe2F7ddeZGCzSuJOHRKkzHUKWN8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 06:09:32PM -0400, Zi Yan wrote:
> On Thu Sep 10, 2026 at 8:02 AM EDT, Kiryl Shutsemau wrote:
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> >
> > collapse_scan_pmd() and collapse_run_pmd() each have a clear locking
> > contract.  The scan is called with mmap_lock held for reading and returns
> > with it still held.  The collapse is called without it.
> >
> > collapse_single_pmd() kept that boundary inside itself.  It dropped the
> > lock on some paths and not others, and reported which by way of a bool its
> > callers had to carry along and then act on.
> >
> > Open-code it in the two callers.  Each scans under the lock it already
> > holds and, on SCAN_SUCCEED, gives the lock up before running the collapse.
> > khugepaged's lock_dropped and madvise_collapse()'s mmap_unlocked both go:
> > the code dropping the lock is now the code that wanted to know.
> >
> > khugepaged's walk carries on to the next table while the scan keeps
> > refusing, and ends once a collapse has taken the lock from under it.
> > madvise_collapse() re-finds its VMA after a collapse, which it did before,
> > and now uses a NULL vma to say that it has to.  It still reports the drop
> > to its own caller, from the line that does it.
> >
> > The lock is given up and taken again at the same points as before.  No
> > functional change.
> >
> > Assisted-by: LLM
> > Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > ---
> >  mm/khugepaged.c | 102 +++++++++++++++++++++++-------------------------
> >  1 file changed, 49 insertions(+), 53 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index c26907300c23..9bdf12128357 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -2857,28 +2857,6 @@ static enum scan_result collapse_run_pmd(struct mm_struct *mm,
> >  	return result;
> >  }
> >  
> > -/*
> > - * Try to collapse a single PMD starting at a PMD aligned addr, and return
> > - * the results.
> > - */
> > -static enum scan_result collapse_single_pmd(unsigned long addr,
> > -		struct vm_area_struct *vma, bool *lock_dropped,
> > -		struct collapse_control *cc)
> > -{
> > -	struct mm_struct *mm = vma->vm_mm;
> > -	enum scan_result result;
> > -
> > -	result = collapse_scan_pmd(vma, addr, cc);
> > -	if (result != SCAN_SUCCEED)
> > -		return result;
> > -
> > -	/* The collapse takes its own locks, so give this up */
> > -	mmap_read_unlock(mm);
> > -	*lock_dropped = true;
> > -
> > -	return collapse_run_pmd(mm, addr, cc);
> > -}
> > -
> 
> Sorry for walking back on this. I think collapse_single_pmd() can be
> kept and still get patch 10 to 12 applied. The reason is that by looking at the
> code after patch 11 is applied, the collapse_scan_pmd() +
> collapse_run_pmd() patterns in madvise_collapse() and
> collapse_scan_mm_slot() look very similar. And it can make
> collapse_scan_pmd() and collapse_run_pmd() internal with only
> collapse_single_pmd() exported.

I gave more motivation in my reply to David:

https://lore.kernel.org/all/aqQf9hSy0iNjnL6t@thinkstation/

Short version: scan and run have different locking expectations, and
the split puts the boundary where the lock is. It is also what makes
moving the scan to per-VMA locking trivial, since the caller owns the
lock and the engine never touches it.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

