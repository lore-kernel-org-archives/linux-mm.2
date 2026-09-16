Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D995FC982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 16:27:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1D2D6B008C; Wed, 16 Sep 2026 12:27:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF2D96B0092; Wed, 16 Sep 2026 12:27:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C095C6B0093; Wed, 16 Sep 2026 12:27:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BD6A6B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:27:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3B3EE1C1D6E
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 16:27:57 +0000 (UTC)
X-FDA: 85220156994.28.37A3321
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9B120C000F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 16:27:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MYoC32Ma;
	spf=pass (imf10.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789576075;
	b=Av3KUevreI4L1Hjjza6pX1XpGSpdNkckIri0RmoC7E6TBdpQcvCyoTmQIHQGaVQ/gl+3FD
	QKe5pY6ozLtD66cQU0wTanT4l8QHHBrXRtZABGDaD11XJCukilFIvbPTOvEzM+zXmIV5la
	szt17QVQ5D6NkbZeVxJ0a26YZbRrWwg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MYoC32Ma;
	spf=pass (imf10.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789576075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XeMuHz9L3o84HRGeotYyUHn6FZauhqILbGmQBe2dDms=;
	b=c/pM0q7Phbws0aFeSPWYNnrajk4UyqLVNsWramBgB1Pwa1q7d99iVDZPs3Xix8H2NNJP1N
	XOGFArUvTUosnfauz+IFKnrXa8Kt5Mm6m1AbXa6GwPB73PkPGrn5YVw+BftRCIUAvseN5D
	N3cRNFTgt69cGUA7OdL73aDoB1Rg6KQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XeMuHz9L3o84HRGeotYyUHn6FZauhqILbGmQBe2dDms=; b=MYoC32Mabv+JwyI5UU+dcCFhDU
	1KhbGSiCxO2o+794mXo5pj31oJzpuTSaDCRUz++LppEHEYuSFp3rJF38uRQhDqybWIAZpBj9RsrPQ
	fNeKt9eGgjasvXYESP550Qj6JCqYGVVqNKFF4g054Kv5NESOoK01pVOtJGqA1cFFRJU/u16osc4iv
	98dIBU38gw25pwifsotx6OVfUatuMOMePjcXGj6Orb0E2oVLRRzDJBniHETHJMq52ygYLUUgZIYX/
	mSm+WDHueQYoRFUJ+a2UAZnaq9hZdqZ6n4R54r8c4C+WvXIEfcfrxXDnlOtKWGNGZWmqahUBALfmF
	g9fQcz7A==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6sU2-00000005LUz-1s9o;
	Wed, 16 Sep 2026 16:27:42 +0000
Date: Wed, 16 Sep 2026 17:27:42 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: akpm@linux-foundation.org, David Hildenbrand <david@kernel.org>,
	Boris Burkov <boris@bur.io>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Jann Horn <jannh@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Usama Arif <usama.arif@linux.dev>,
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [RFC PATCH 0/5] mm: sub-folio dirty tracking for PTE-mapped mmap
 writes
Message-ID: <aqrDfoFFr8o0Mf0G@casper.infradead.org>
References: <20260903182943.662461-1-kirill@shutemov.name>
 <ap6LFvuOuWf_BkGi@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap6LFvuOuWf_BkGi@thinkstation>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9B120C000F
X-Stat-Signature: bqw8krr9uhgffr6ef6uenp1kha1w3hs5
X-HE-Tag: 1789576074-153725
X-HE-Meta: U2FsdGVkX1/Xw0G1/O7jI2MpOdcfNJjR265KsKLAsw/6YHXMztjArKeDx3cyh24li37Q+2WtunKyDrm3kE0+uAbZzmWMH7ZjTYJc7z2fmBIAij2krBGGWQmUbeOpB2P6E/u50RdBysgpqChqJzhYH0Kduz1v7RFepTqwEY+HVyT6K1no7+DaekTzKhx/+bATG+/HM+Qm+m5OtesVf9Uc+9l0zsrKQ8sd+XEDSjIA1O5Qu0XTfFiTszy76uFt6dkJRt0FRzBN9VyVVQV2DtEx2650377Anub1+gediFZmjfT39wZpVtfUMCY1ETM16IJrdJGMKtGSPd4p+rRpqhjyADUEQPXtsSjzU4noeJd7UfRgmb25idHrMoU+z0MPo2iac6WD1Tzk6gBXj04n/KZG5E0ClouKeO2Zu3wOqMI+4bZGd2bTDkVIZQaQVc/IUpRPpFCY1lRFC0SFGgWGZWf89XkuLEPK2EAkJXPg+4duXpPiZOtX+lz25MeYEz6dIGxGxzTIbMpGkuAYjAo40B9zSBPL06yTepgIY9mLg31yBB+txyRc3eIrwBmnpzjNLR2x1XxtrkqRbhKpajN3wymlmWkSiAGA2/L6WoKUpEqkbJbtjRDvFLn5TJ0+XNnZtwYlyh8E8FAVgudKB2wOyLQyGtMESDuKj3rd7A8OIxccr7mRLPcMJFvsVoXJbKZWTMWpLqMVlXRji/XKJhvEQC3oOdQ5ZZJTSvuVz5PW0dOiCtkeASVnfo2TSJUnYohvtOuK7tLoERlF7UiB6AR/GC4f9zJkTqGEfZNRb0Q0zmfktf+wXYVCUSKoClfuOA/8FtQ9pTjghMD0DYaLC6A0FaD0SqfDAvh45+YyAG0X3T45XieG/v4Ss52RJeSlCVoQo0E/URdPEndFglat43aw6UR2VMjP1JMAfkI/wTQhLgxO1vytRIdFWbPl7xGlHSJCzQjf7WIxg1ls/KKJYSz+Veu
 W8WLXSAj
 PVRjvUq97Q1C35XgUB3RbB6MzwFHOHkz2abPupSg/EBuRxPt3a0mJk+cvjuKv6f6pnKDe7Hb/sSWqjMJO9SHW5nWIqB1yu4Okl8dnp2xa761i4qY6GnJC4bZOYzLy2wj1YOaSUZGTu/9vL0GIZywEtUORslupLhJtG7gMpYDbAJhkSfnNAcM1U0f3KHh0p7TxkKPlfO+B6GvEabgMrJPNFgSUbC/dqOviKGhRaJwtplEyd6lQoSh19nYSwwsh7FHsqqnf11jrMTDPnFMTgoO+PmONr825RxENRjKPCUgLB5W9kM+bOffQQfM0p26bJKuNF+5Y/iEIx6fb5dUh4F2h910gZRWTpylN3hEX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 11:15:15AM +0100, Kiryl Shutsemau wrote:
> Boris pointed me to Matthew's proposal to remove ->dirty_folio:
> 
> https://lore.kernel.org/all/aoyWln-Gt-yvZQkE@casper.infradead.org

Thanks, Boris ;-)

> I agree that the current ->dirty_folio() makes little sense and that
> dirtying the folio can be bundled into ->page_mkwrite(), as they are
> matched 1-to-1.
> 
> My proposal makes the distinction between making the folio writable and
> making it dirty meaningful. ->page_mkwrite() allocates whatever is needed
> on the filesystem side to track dirty state and drive writeback for the
> *folio*, while ->dirty_folio_range() marks part of the folio dirty.

Why do you think that's a meaningful distinction?  We create a writable
PTE because we've taken a page fault for write.  There's probably a few
naoseconds where the PTE is writable+clean before it becomes
writable+dirty, but even then sometimes we do both pte_mkwrite() and
pte_mkdirty() as an optimisation in the write fault path.

> We can still drop ->dirty_folio(). A filesystem can provide
> ->dirty_folio_range() if it wants fine-grained (sub-folio) dirty
> tracking.
> 
> A separate question is whether we want to avoid installing a writable PMD
> entry for filesystems that want fine-grained dirty tracking. I have a
> patch for this, but it deserves a separate discussion once we agree that we
> want this for PTE-mapped folios first.
> 
> Any feedback?

It's very odd to be optimising for shared-writable-mmap.  This is a
horrid model for I/O.  https://cs.brown.edu/people/acrotty/pubs/p13-crotty.pdf


