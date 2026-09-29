Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 840D3CA5FAB
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 00:08:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CBD06B0088; Mon, 28 Sep 2026 20:08:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07CE26B008A; Mon, 28 Sep 2026 20:08:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED54D6B008C; Mon, 28 Sep 2026 20:08:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B9B176B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 20:08:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 179E81C22E8
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:08:00 +0000 (UTC)
X-FDA: 85264861920.09.52D3FD8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4208140006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:07:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PyUCF8EE;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790640478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cEX/KBI5mqa7AB9vbAyIek82RanrGly6hIG8hnXtuYA=;
	b=e0umG7n7zru7UQHvbvF0Rebc32k8iklOKDlP7eO4Yvrlhh6dj8inPvTDQNlcun9p41ReoI
	9qZ+iESTFE+RAV2dK2XKfZ3OjX7JA3c3eQIO+bU/BtkuVu5bWLbinVek/CFzaaZsqQrxCR
	bnRfakozL91tnysP226N0NS4TKyZoEM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PyUCF8EE;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790640478;
	b=Fiat4EsYEsi54KNCuPe59fZrGSP0h++pBHpGypbHbPKUKOi415zs1BxJJozwBWGw2J+5HR
	I8gDAT/U+1BvAJP0fT3fdvG7aGsVitEjNcatI1gteRBrhxgI4RhiYVkWT+o6sSiGcYdJZ2
	I3329YxMjA0gBQwi7O6p/mHQS3hSxMc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B303601F9;
	Tue, 29 Sep 2026 00:07:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF191F000FF;
	Tue, 29 Sep 2026 00:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790640477;
	bh=cEX/KBI5mqa7AB9vbAyIek82RanrGly6hIG8hnXtuYA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=PyUCF8EEyukVtUALzM0yIlwsef4UgHuhYMNqi4kCXcaFq6WpB6hkYabHA0RFk16cb
	 TsbqgKfVBcMa5yDWcNr3C1Tmw6oCaJZnahnJI5PSgSot3N+go34EB7/nNddpqKwHh5
	 S6mPn3L5XXPJYtF+vpoKTyokhAexH0Xwx/LntqXQ=
Date: Mon, 28 Sep 2026 17:07:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Baoquan He <baoquan.he@linux.dev>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org, hch@lst.de,
 harry@kernel.org
Subject: Re: [PATCH 00/13] Don't use GFP_DMA when calling dma_alloc_coherent
Message-Id: <20260928170756.815406182a70947276446122@linux-foundation.org>
In-Reply-To: <aroZD9TBlOKoprQm@MiWiFi-R3L-srv>
References: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
	<aroZD9TBlOKoprQm@MiWiFi-R3L-srv>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4208140006
X-Stat-Signature: 9kgaxsaqdnm3jbeaug5pptca38o8om97
X-Rspam-User: 
X-HE-Tag: 1790640478-740329
X-HE-Meta: U2FsdGVkX1/Nr46Mkhf7qb3QvfBaaqzYXqLPLLN5s9D789E4eV4kntklD2iAYOJFT0JPiK4zBTJU3XTqcuFQNF9GJ0mKXo0QT2ku2yZNUYQfrFwVOtMhDsSle5IitG6xzbHeiBJ0wakk8A+uUHv8iIT3Mi8URXhSKT1FwgUvH4oP9RJTSSNasylGD7HwCWxbclRJ2HCPQ318PxJycXVjZmJBwS8x43363nnmwG0QqXIqqTHId/hwlER3oa4k4Hg7UmpzBHK1iUkZO21bxH9zNRHPsKZkRtAGDrWYc/mDJg+8UEaXg7u3MTWjLDv9AK13JD/kC34NvaP6dMhdZcE2O2jpYPHW8ugmQ0raBMy8Lp45sxLkZwKLXA2kIXqE571++KhSXfw8Qo8tAy/l4sO1P6wCG97219/FdmGEAdCyVWriTHZTkP9OciOMUoAOva1kx6CA5ZEYc/xABDS+xiLRxi5yt6FN/o5zAzR7BxO9Ay3V3pwT9WwFAM0HxNVDWXvdzXMx4+16Vni2ibqwUkA3jsODPl+umsFfvKzBo95tK7Xe5NVLEYaBzAk1kNpI/ID4p0Gh0PKnhSliuWtMkXu8ZFit9Y0PB0MIIqPnXfjPqrQMsGGxlFvqNabqkUh8R/lPAiSt4sDAqc1JE8wz1nf7x5T/kiMiR5aZqAW0/85uNVL5SPj9sOmYPYd0F0QARIQKo8X1b1hYZx+aVYOARHghIKIkdJE1xNLSJJ4C70y15BwF4HQQhdPFTicFHCQOHoMM+S/tGI74vQazv/igNoYSAGZ/d/dlfk+hNiqI1jeE0oVGWnxOWYvKQlc362pyXPZQxfQlqqXcTdNYidXaXMB1NC115OaaP6sa8A0D8nGjDCJgHOYzG4i8m8Z7grNopXFB9boEswvvftCKYPdmktFAWjYll/toq9YiSMe31KfpnwxIzTdIrFF8CarOvtIAF9NUsC9X9PzSfoPctmPMQTE
 Gs0NmR0Q
 72Y5dp2uZBRCqMYbFJOTG4bkkVaViyNIqVTtgG5hujh+vGelqNHManTYyFMSpblV4e3g2BlFUfk9/jaZ8vRFytpG3WOhqjePq6cRt3DiPGpDidWxW2Ef0ZKP+BCrjv3j2xLEt+1cDn1gEq82VNSq27XB4rc9VV2wMa0ofCCMd6fwMA9ykWBUbczHV9BvHeES5EWg9eqAVXahMpXfrQWNWAzT0E8Ccv9fGbH26Hn44bMQpF8fNsMqUYu4kyzwAhOuXPBkRlRQIo0P0TqIFDzQiPh5UkTuvRwqKuDOyWphaxwlWv+8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 28 Sep 2026 15:36:47 +0800 Baoquan He <baoquan.he@linux.dev> wrote:

> On 09/03/26 at 07:18pm, Baoquan He wrote:
> > This series picks up the first part of an earlier cleanup series [1] that
> > was prepared back in the year of 2022, but for various reasons never made
> > it merged and has been sitting in a local tree since then. This subset
> > only touches the call sites where GFP_DMA is passed to dma_alloc_coherent()
> > (and its dma_alloc_wc()/dmam_alloc_coherent() variants), which is the most
> > self-contained and least risky slice of that work.
> > 
> > That GFP_DMA is simply redundant here: the DMA API derives the allocation
> > zone from the device's coherent_dma_mask (together with bus_dma_limit) and
> > ignores the GFP_DMA flag passed by the caller. 
> > 
> > Removing the redundant GFP_DMA won't harm anything, while keeps it from
> > being blindly copied into new code.
> 
> Gentle ping!
> 
> Wondering if Andrew can help take this, or anyone else I can add this to
> ask for help.

oof, mm.git is overflowing and I'm trying to stem the flood.

But this series is so modest so what the heck.

I actually kinda prefer that this sort of thing be done in a single
"treewide: " patch.  It reduces the patch count and reduces the chance
that a driver maintainer will cherrypick a random patch from mid-series
instead of saying "ack".  But many disagree with me!

