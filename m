Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F18A7CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 21:36:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F9858E0015; Thu, 23 Oct 2025 17:36:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AA178E0002; Thu, 23 Oct 2025 17:36:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 299798E0015; Thu, 23 Oct 2025 17:36:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 148418E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 17:36:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E249140C60
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 21:36:28 +0000 (UTC)
X-FDA: 84030688056.29.03B5ED3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id C980E140007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 21:36:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=D5dLSV7c;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761255386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3fFdeJUZlXDm3+8DEFwlzG6MrGAMPRepgp1+juzRzM8=;
	b=G6PtU4Be+6l5fFNFqZXajK6DAZDsbD7FsBKEDZFZ6tTDdh3q6uyLjsCio3+L5tLX6Csl5Z
	fKlqa2Uy/w9/cdTsacDg5bBc6znXCe2IuMraB5G5Oyggu1jSQtxFyViiwSwvt8txtTLkbr
	uoz582Ph8wGIPAB3zzRH0t3cIdxoZrY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=D5dLSV7c;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761255387; a=rsa-sha256;
	cv=none;
	b=hsiZcuzlG18NuTZ1/4/YH5YosVhma+riR4XiLWn3sTJy5xr8hKMzNEWN5kUghfN7HktsGg
	+ZG1foOTPPDtgF+Jz+RBI8U+/D1WxAZ9wIYzXY4a/SAS01OMpyBhqcEWwcYJu54kmgoumz
	MGxHcb5b+dcJh4H0SZkIGkAo3uU1+f8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BBF7F4169B;
	Thu, 23 Oct 2025 21:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC59C4CEE7;
	Thu, 23 Oct 2025 21:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761255385;
	bh=PeQvjl8tTHsyJLNIyC0D1J39XRcadQROmtv7uZK7IMo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=D5dLSV7cClMTLlP1vvO/xSsofDIiz6K30iXsothe1O5uqNMocMhnArlWU6WugZ4F0
	 3+FNIq71QSLCs4QBTqUENXpZukkHfHAH0AfcMkDFKPnu26S55DMAgZ2SklkCX8+WQN
	 i7Jhbbi2Hu3iBHnpF4AsyZl96QUiJpmL4TBeKlLA=
Date: Thu, 23 Oct 2025 14:36:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@redhat.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, Hugh Dickins <hughd@google.com>,
 Matthew Wilcox <willy@infradead.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, Harry Yoo
 <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt
 <shakeel.butt@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCHv2 1/2] mm/memory: Do not populate page table entries
 beyond i_size
Message-Id: <20251023143624.1732f958020254baff0a4bee@linux-foundation.org>
In-Reply-To: <3ad31422-81c7-47f2-ae3e-e6bc1df402ee@redhat.com>
References: <20251023093251.54146-1-kirill@shutemov.name>
	<20251023093251.54146-2-kirill@shutemov.name>
	<20251023134929.b72ab75a8c132a17ae68a582@linux-foundation.org>
	<3ad31422-81c7-47f2-ae3e-e6bc1df402ee@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C980E140007
X-Stat-Signature: tt3pkktkr3cqahfgx9hn5neyzobc4go9
X-Rspam-User: 
X-HE-Tag: 1761255386-66592
X-HE-Meta: U2FsdGVkX19qy0mVySqshMgXNKS02hgN77icR6uVV3yE0c8elF6raL226tbT+Ttxsa9j5CYfRmOLNGaCUf0VgiAQ4AZEsEbqOghQE6SKQT2MkhErz/NHqg0+HG6N2B6XhIMR/oMeX5vIaPTNHXDC1x7oG/VwZQzKi0dy4Numr8fIDYURqYjA6Z8l7y31Vwdgh+Uw3wo/HgcOkmT5RrJS7w9kUhpMuKJsX7cTn/UWqG2P6aknkKLCFyCnAqHgHJnq6soYjS/0LCcCAWaPfHOD8AgQBJJkAXOm81JRa9BGjpA0DbNpPGaFWx90dodyOHCXfTvGyXyEyM14Px5RjSXKJcZJpCA3E0RhdgTJns/7RH1NPeCweGUu27vJP6L58YySimGCIGs8xmmgJtFhz9vIk1zpOOXdlX78OzRnZZDdVyBWqWZpfEwOHtmcu7F8zq76MYB9J9mIQw54l2kZgIrrjQoibbMawsGBnXgQ6vOsvpU35sGiiiCmtXCdlx+gr4GH0jrpDrTfR4q/plNVNq9H7m/PESixnsiACKHMMwyIuL+CMUYDdJ09LkGSCUJzpm7AU3JT4sUT4m+UC/5J790ARS5Msw9D2TQSFWStb77hA59op1TzkWHEALhRzZoqjgPyNFYU9F9tStYz7evv4EVh8bz3tjjz+sa/QlFv/RQe8twsBrLiK2bdIPRFRTp1XU+KXk2w6yrbzFdGxRozOMuUC1e3n6+FXTwq+QNsVwyQWWw/1wNJGAVS7bGbZext3SpgaRao6zxGzDi1OP9lQ3HSYo7u2rUM0C68I90PSe/QKWHA4vE2JKtfPZ1ckVYQbpw3Z1sYAoTQC0978+hx32drOiuNVNhqy7Sbu1pOizcaeweDJg8IzUSnrLzf2lNM/W1GWpm/ihEcVqNSYjAi1TIG/1y+kKFaNMQOoFcd9rq/qDArKHViY8dlt0GkhRIFB4kCrO9bSEbX48titVV5As6
 CAkzRspY
 MmZgy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Oct 2025 22:54:49 +0200 David Hildenbrand <david@redhat.com> wrote:

> >> Fixes: 19773df031bc ("mm/fault: try to map the entire file folio in finish_fault()")
> > 
> > Sep 28 2025
> > 
> >> Fixes: 357b92761d94 ("mm/filemap: map entire large folio faultaround")
> > 
> > Sep 28 2025
> > 
> >> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> > 
> > Jul 26 2016
> > 
> > eek, what's this one doing here?  Are we asking -stable maintainers
> > to backport this patch into nine years worth of kernels?
> > 
> > I'll remove this Fixes: line for now...
> 
> Ehm, why?

Because the Sep 28 2025 Fixes: totally fooled me and because this
doesn't apply to 6.17, let alone to 6.ancient.

> It sure is a fix for that. We can indicate to which stable 
> versions we want to have ti backported.
> 
> And yes, it might be all stable kernels.

No probs, thanks for clarifying.  I'll restore the

	Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
	Cc; <stable@vger.kernel.org>

and shall let others sort out the backporting issues.

