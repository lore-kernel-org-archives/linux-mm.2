Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FADBCA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 14:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 453906B00A5; Fri,  2 Oct 2026 10:27:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DCA96B00A6; Fri,  2 Oct 2026 10:27:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A4D56B00A7; Fri,  2 Oct 2026 10:27:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 043CB6B00A5
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:27:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 93463140725
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:27:58 +0000 (UTC)
X-FDA: 85277915436.16.D35C881
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id F070BC0002
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:27:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kbwQogeX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790951277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RhjstUff1FQx1MomJYmzcNhsK5VwvpkAkhhBXa9Kt+s=;
	b=S1+WGJWG9PBk+u6nacESKlYNZO7HY0YP5ZTLYQweYrF36tDBoYiRtEZVbM0Z/AIfyZA0L+
	TCCK05c7e3YLWacKaLAcAvcJ4e0VCGoGazvnxTl4/3EP/Hj4xxjj7P2iUfwVUWS+efvfX6
	4bk2kPoJ2ej8RssEtn+ILG8dejuYqvg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kbwQogeX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790951277;
	b=KL8p+LJXavCUmUchIQ3P60fc9V1s9EUqLhCQ4aDeHTAhfUjeB6w1Wyct7gKCUbBbubqPoO
	lHJ/HQ5+PJbG0aklVHq06jFfNTRQR//OscDAmF5Bh92ybrHZaR0GTJzUd+vqg5SPwtPqut
	aq0ynv0uypptSK3F3KE31q0sa50LJV8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3580C401D5;
	Fri,  2 Oct 2026 14:27:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7621F00893;
	Fri,  2 Oct 2026 14:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790951276;
	bh=RhjstUff1FQx1MomJYmzcNhsK5VwvpkAkhhBXa9Kt+s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kbwQogeXEUUc1/9rzsqwVfs1mx223su97wLf5TSzPTk6lHeXTtQbspfEYX7Rt61Gx
	 K+yiitI0A2wtwc+anr5mnQHDTEdgLJchTd+s88bKBHdzK7W+nSuGaBHtpNvBWywizc
	 HRGlzhzyDw6W3la4qP++/Fzi5v6iZhgYhkS8bcK3ck60ZFhc8KjZ1E7kfdOQQI8ZyN
	 HFaXcChOZa9aN+OkQH6p1YmdoZq3SnN4Haq4KYAlZAHXkMrFcHe3fECvt/g/aa+nDO
	 p9E3ltguhgJfzdfOTkKWz6D8+uUvqWr+ZHdftrtk/LBV7efbUpW3PFLwuHVozRV3FY
	 w3wjKIV57cfbQ==
Date: Fri, 2 Oct 2026 15:27:50 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Pan Deng <pan.deng@intel.com>
Subject: Re: [PATCH v2] mm/vma: don't remove VMA from rmap if pgoff unchanged
Message-ID: <ar-_D5gGYNKl6VVu@gremlin>
References: <20260930-speed-up-inplace-rmap-v2-1-ac1aa19708aa@kernel.org>
 <ar-9z-Ls26elb5JI@pedro-suse.tail5790ac.ts.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ar-9z-Ls26elb5JI@pedro-suse.tail5790ac.ts.net>
X-Rspam-User: 
X-Stat-Signature: ex5c3ehztpxayn1mbu7dt5krr7xwuw3a
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F070BC0002
X-HE-Tag: 1790951276-707681
X-HE-Meta: U2FsdGVkX19pBuhIGgt8MIJqEORs4IbnFDMDVHXp+LuEYQ5dnf6usqMrxxMhI+dIaNXce2n+SJg+RBk1qNGcHSdCgVZKT9RMRzfUxKIitvBby47X6yVwig8H+tskyB6jKXrvAiwkPBTJXsAH4NmLW8t1Hd2SXqYoRqex4Vj5Yll8RDoXbQ4Lb/zYbCMdmXY9WOarbLSP2gqP82iYIRRlmEWV8GPaWamFOLJtS+Y6HxfixPkTrcJ2wHL+ydNNjLdWnVkFLZL9WV4wCvRLimdX8D9bQUEv6fBcMsxhOuTwhYyChCm2ocIkoG8a48Yuk38kGeRW9E6QL/F6tFK7kDAenUqhcLuKXcEgZ9WAa0II7g76dM/iq+cBChlvHOepn7zED9r5jze0fjZ3tU8oDFM/acoRjnwoDa2TpPFyW65NbdXMssBmGEXk2RWJMuKg65LQyfeSZgcjf1uRsrWx8iTYZNTcNZkjaSa3lLdj7Cbrg+l9jmWmFNmKVCw7opwAlv6StBNJ6ccgwPU5fm0KHQr4k+C7bQhldrpcNNbEAXk+mt9lv8Y43z0LJX80ikx0JFeu2kBZI6pWlXQiRgPr0rfmrKDNkyKPBl7Y5mcxZ3GQxhYNSBM0Trxp0VoEDbFsqIcsTbVRvA8uSVq+HJQIQcLzgR9lQEcvAj0ZgzJgZ8XXRvl5r8m6gWgFXPYmHOdkzklBjGlEp/jYdgyS4G1CKGvZbrODJReCsvOuOXTM1zuyKActaln2/V/G5DnYcBvoZBrVyFrko66tMcXxXU2mrITWjdPAB/KJ4510ft6FyQuqvzyfOaHmS+k4A3hPXK0450cI3fu5xGvpqWFyIFZAq+cdpR/dJTkJBMxgHLfbaP1bx2xp0ZU5tVWmN8XwB0hgdZLRJ4FKf1bdZJ4NAiwbLZ0N5yA+XUWYlDSZvCV6t69Z9nXJsj9hxOY0fGT5Zo9MRK030kHsZjhrM/MpzsUb6T9
 eBty90wM
 V8gpnoOhnuKkS0D6UCCFoXeFGY+FRPrAi9RQBDDAElko/phQUKyyF0ZXK8H/ELPP4+z8ZKnQfcIf32+v477/KiWRkpXjZueblS4WZ+Z8m1Wr+4BaNrFVte56VxNyb8SWZ+pSahKAmVsObfIRMInc/gn4/CV83igRz7CZMxnsEP5uUGm92TRzYk9KKPE2373baOknxVbKeRIH14sEsAeKX8o/S+W3mFvrrrV4DjzseodSUujHlPVvq5oRMpxP0ueYWKxtzc3URIOazFwOT+r43ujbsR4MkIvYRnBWf1UqUY23XBFKVwdKSnHkcIx6W23LQ4zfQNL2WczDIoiwGV44ebVVfyp69wQgmJVZ/eY2AIP2M+Jw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 03:24:07PM +0100, Pedro Falcato wrote:
> On Wed, Sep 30, 2026 at 06:53:36PM +0100, Lorenzo Stoakes (ARM) wrote:
> > Suggested-by: Pan Deng <pan.deng@intel.com>
> > Reviewed-by: Rik van Riel <riel@surriel.com>
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> Looks great, thanks!
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Thanks!

> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -201,8 +201,15 @@ static void init_multi_vma_prep(struct vma_prepare *vp,
> >  	if (vp->file)
> >  		vp->mapping = vma->vm_file->f_mapping;
> >
> > -	if (vmg && vmg->skip_vma_uprobe)
> > +	if (!vmg)
> > +		return;
> > +
> > +	if (vmg->skip_vma_uprobe)
> >  		vp->skip_vma_uprobe = true;
> > +	if (vma_start_pgoff(vma) == vmg_start_pgoff(vmg))
> > +		vp->file_pgoff_unchanged = true;
> > +	if (vma_start_anon_pgoff(vma) == vmg_start_anon_pgoff(vmg))
> > +		vp->anon_pgoff_unchanged = true;
>
> FWIW I kinda would've liked to abstract this out to rmap code, but a quick look
> shows that it is likely to become a header dependency hell if put in rmap.h. Could
> perhaps have been separated out to a function call.
>
> Anyway, your call :) This version already hides most of the ugly to
> interval tree code.

I'd rather keep it as-is. These case are explicitly setting the state because of
things known at that point, and as you say it's not possible to do it sensibly
due to headers etc.

--
Cheers, Lorenzo

