Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6658C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 19:07:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9185B6B00A6; Tue, 30 Jun 2026 15:07:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C87B6B00A8; Tue, 30 Jun 2026 15:07:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 792C46B00A9; Tue, 30 Jun 2026 15:07:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4910C6B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:07:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B3EF7A05B4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:07:19 +0000 (UTC)
X-FDA: 84937512198.14.8A62A04
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id 748A640011
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:07:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=aUagBS41;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782846438;
	b=Pm8jhMHgprzPvdu/dBZy+4qJkYLuQwwgI6qnDa/IIMRVfzL66REXmc5TfoZf10TSsQ18Gg
	AIPPQwwGdEzAfESzG0Bp7I8+qfbpKQ5WdWbiqETXYqPTPjgA4BfEMVl4uhKCyv5UUS9hIK
	Ra5iLNcsRpJYk6q4YE+kcUFK8/jGmlg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782846438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WgB1yffYfNl1d6ertecsZ4ql1VDBY3O455vaUMG9kNw=;
	b=oDM3tiBnINz/mnMqbT4/3CnuGCz6Z/hsD9HzqSgPTfzJT+bSmbFUP+YJ4R/iuM+Ft1BbFm
	NSPjDZ4WRCYUzF4jv02vkK6Si84dzyEb/D820AlZXNVi9FvDIJQ+4v48npfvh9fjgBw57M
	0VHhbWeGWPWKNFeDKDEg5Eiz1POQS70=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=aUagBS41;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WgB1yffYfNl1d6ertecsZ4ql1VDBY3O455vaUMG9kNw=; b=aUagBS412TD6HJktcSRg0Wms9N
	/ghAUcW+e5l5gmPcUTvSKU+xFAvfkl4Lneckv78Nw5T4lz70Bn5NQVSmJ7KwcSI90Is9/aoXEsD+b
	Whe2fkzz9gNleY4w9rr3ThBBM15aahfiEnkgGFPcM9e+fm+SPb4cUC46IOULMcXHiS81SDcNFOp1L
	vge5f6oh5OXZnCKqA5wvu4JU9x3yLW9w8JDfcEH1EtOPV95wvtGsJ7RJ1VDWpgCXGFKacIE3eXOEf
	8ybOa90zX9mt61V7CsFAtD74Sf8pXToD36A9sOaFL4z53MCoTtbGj7VHqhxCYVGgftvA2SwxyuKLb
	cIZ8/4Pg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wednd-00000005PXP-00Z1;
	Tue, 30 Jun 2026 19:07:13 +0000
Date: Tue, 30 Jun 2026 20:07:12 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Gregg Leventhal <gleventhal@janestreet.com>,
	"To: Alexander Viro" <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Cc: Jan Kara" <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Song Liu <song@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Eric Hagberg <ehagberg@janestreet.com>
Subject: Re: Subject: [BUG/RFC] write-open file THP cache purge can discard
 dirty page cache
Message-ID: <akQT4G4RpxPPMb2Q@casper.infradead.org>
References: <CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com>
 <akQMy54dxVTVkMJ6@casper.infradead.org>
 <DJMM9V4Z58QP.2DXAKKZ4YE6HA@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DJMM9V4Z58QP.2DXAKKZ4YE6HA@nvidia.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 748A640011
X-Rspam-User: 
X-Stat-Signature: rkuspk99xwxdh1tcrnugyj8onzan5hts
X-HE-Tag: 1782846437-43771
X-HE-Meta: U2FsdGVkX19bQBFN1fxqDanqVlUC3QVfrlTHC27hNk3M4Qvflfsp6nh3UcjtdlEDoTvn1+61R21VTkYe7NU4aaku4YeC1hbD6BBgkxOVwjbeI52qXAMwssPv9rexWadPWm0W8bHrrf54B826ZPZk5tpjluoPUzLC6DXWLa1j8Lfr+y1vzYxJGpa04nfPjFRk74T4lgxG8S9jxmIG7O9yl9dn8Xh4wHCSBUtBwveCV+AQMBIpeqIzvYRePVu1WgyE7uHrULzkugLSAagQhiTrFnTAUPR2adWUOPQdbzb5BUE9yFO8nBGqCFG8HMGYjsNpjYxRXvhiSrvAzLe5BjzMx4XnTdQT5I1yXalMsWMq7AQdS4rc25zPIN61zvr16gZ8wJ43zmMolL+lbSu38G1kpivnd62cllSM7B3JuyxX0ovjYEj90e1U80lpPx+r1lnkgFTcKJT3dAY4TNCMN0jBL5XTPP1k+XYwI8xbC/6S9UZFvfjLcYlRGrJ8MnOtyIh0ZCjgo2yWu3uTLGPrINjmv1oIqhAuj01FGKAE7bJkAZN4eHwLKkpjcIpi8BjwVj4b6qpVpZAyRinLYjGQGEN0L1nJrR0shuDOwty2nmifFsh20wu+2aJWgudTLyr0/HuJBZR0E4YGPo3znnzjboeHxgtfzdx6gCK8pc9QUEl1jphRKbjYxn52yD/Fi0onZugj16oHdO8Se9ay4cexfUeyPfoSFjp/cHHwtdPKDd4csxrFyAfN5g2Rz+DvllCe14zF/tTnNJAuLsEYV5bNRmU8XoKxPH4SujRk/mS6BumwWjcRkWS1pP1wvSY9slNKfGHu3LZdffDiOqZk3IrMms8ndtiCuAJK07Zsp7AoXycU1TCs5FGh9qNRX9iOcpr3mFjnpu90POVBU0uzOqBgHpoBm3IaehbJ+Gdwd9aHqjvOs/5V5HgTKBzVcMYYNp8EjZDAibmXuvfDVQ+LN+Vex+l
 PV+BXRcn
 sQ4TrT1dEJD7MLiwkCoXi+Gn5ycESpemTIJ1NeBOJe2wbex+5J/eldzH7kgPo6d8mjP5ZoP1HbxJ0uIJ6URtYZaw3Xh7bvuuJ+1UTswR78lIRfThk4vtgbU4DlL9NnftcXUEZnXsHLLEv/Po2VilJq2aNDoZLtBDxRiKHPFWg9iP7b0nVATUKB+A8s5boSm6atcGOINw1Nj3c3dpalA3DzivJvS8faXHd9qJtvAjdyCzRj+9r9G9NnldnNPLerFnMv9oXZ137WMVCuUjZtvTAykVA8IRKMZEk4ekXOXc7QYymIJ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 03:05:16PM -0400, Zi Yan wrote:
> On Tue Jun 30, 2026 at 2:36 PM EDT, Matthew Wilcox wrote:
> > On Tue, Jun 30, 2026 at 01:01:53PM -0400, Gregg Leventhal wrote:
> >> On an affected 6.12 kernel with CONFIG_READ_ONLY_THP_FOR_FS=y, a file can
> >> contain read-only file THPs installed by khugepaged / MADV_COLLAPSE. When that
> >> same file is later opened for write, do_dentry_open() notices
> >> filemap_nr_thps() and drops the page cache:
> > [...]
> >> 
> >> This is unsafe if the mapping also contains dirty folios.
> >
> > But there shouldn't be any.  It should not be possible to have
> > dirty folios and THPs in the same file unless the filesystem
> > supports large folios natively.
> >
> > If the file is open for writing, the attempt to create THPs should fail.
> 
> Maybe he means order-0 dirty folios?

Even then.  They're all supposed to be gone.  I don't want to guarantee
that the filesystem will properly skip over clean folios during
writeback.

