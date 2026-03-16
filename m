Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DBC5F53D85
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 18:32:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80C6F6B0345; Mon, 16 Mar 2026 14:32:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B9BB6B0346; Mon, 16 Mar 2026 14:32:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C5376B0347; Mon, 16 Mar 2026 14:32:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 58EDE6B0345
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:32:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0DF07140412
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:32:58 +0000 (UTC)
X-FDA: 84552772836.22.F2E0CD0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 36DE810001B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:32:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UQfzlHP5;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773685976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3csXQmcRsXHoRePE95PZq3TnjnWU0WFxU9dh9/P3nfM=;
	b=CIOKE3RlfRWdu2QVaY8hdz9TW+EITs6UbAxDcmTkOMaihMmhaie99YRLeJ30lkXSaUvgz0
	rmqskLNeFCEmYCrSNSbXSPLWbNXI8kIA6rY85mnIY3F3/CftTJLUiUOojp2cocj9KuHPJT
	HffZLKqZmZ3I1g8seoqN8TnEsDnIiUk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773685976; a=rsa-sha256;
	cv=none;
	b=H7uSvXal9xq1yYmNT3zUike95+ijmjW+1F9Xc/Fd+NacPqo3X/O54dvfh7b69AFVg0G/sF
	rsURYQ/XTcUDJ5QvE9wptQVWtbBKO9DoHhihm9SEe7dS27aCqlrB20FK6jl+5AqrwOgZIe
	ndAJi35c4E0t8IPtEl7xvZLO+6aOWPs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UQfzlHP5;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 43AC943DA8;
	Mon, 16 Mar 2026 18:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB00EC19421;
	Mon, 16 Mar 2026 18:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773685975;
	bh=MK/sWLShD/q5Y5tIlOlIakl0XycOHWa6fuIyYd25R90=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UQfzlHP5Yjxp1sr72ViHEiNMwu7vNxWeOLkjycua4jkqjg43cXkmp4ompwMtp2Buz
	 dkeeth/vN+vzuyju4OHSpwoE0ThtLn9hsTXyNbfg5vPZrBfvZPpiFNfP7NUrxCQa11
	 FJuLK2PUJmV6b7BzpYOqixAJyxgo54eC5NSW+pCM=
Date: Mon, 16 Mar 2026 11:32:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Kees Cook
 <kees@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/23] mm/vma: convert vm_flags_t to vma_flags_t in
 vma code
Message-Id: <20260316113254.ec5402eac815c824894086d4@linux-foundation.org>
In-Reply-To: <d3688526-cd37-42f5-9eea-63ab19f7d446@lucifer.local>
References: <cover.1773665966.git.ljs@kernel.org>
	<20260316091704.24d7f8230ad57e8b7d18e9f8@linux-foundation.org>
	<d3688526-cd37-42f5-9eea-63ab19f7d446@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 36DE810001B
X-Stat-Signature: 6ekp5ajezuxdu5oq7zidwbik8h6osf6s
X-Rspam-User: 
X-HE-Tag: 1773685975-329079
X-HE-Meta: U2FsdGVkX1+AjmaGLw0c5LG4EU8XFWyjGOHpaHnt9ZEOJRDBekEu7yFcNnlDS7gmAZAtOMbYihkF67OcP4qLr2LXUJjcsjMgoxLnTYdLZ0L4/e5BnGc7IgtplPPd4/+TUsZCvHfs5/xdHOrSnB/nY3ngudxjiJQRHiFSyphe3L1ZQm7fNLgkMqJg0AyaTNWh0Pk0hmuFFmQUoSAkf4HVp18HTDdaoyxCKSn/cuU2lbr29cxp+fbimvupLcAcEkytYRDKmddwGeSbheE/kEOlMfaETWqHU2xxdFj1WoneZcsYuL73H6JBEYaABR4mURQ1A0z9S9CSjLBNAFwigoItXnmeeZYrVVKTLjtp+2b/cqMv9ihbKlxd43sCMO3Kr564AyTRdZDe1yZPtGnAmTJia5JVtsZBDc72BeJjSDA/OWOHf7bWjH1AfGdgo/apBQ7GUlrbNWQX0UdOnQNP8P4+d+sUizCDd0ReoMIfKBgItZSYCrrRkySkshelL8J1FibzHR/WZr9Vc3+QzN01ZNDy6gKY9GyhXNRaYDmWYoX8Mpzn0be0QWV0nCLiLoJd45BIOWzYhzHgU8EAxHH4zBU9eGPwEuYsKCoELAXKXNZIZFjuWgZ+UOagb10ceb80sYQxIif98b6L3TCwqJ5vxVisL36AkGVqZrkPo1AdzeWne3VBL/jFycu65Nt3eCO7ffYRcf24Ml6GE0ufurmyBXrpY/lKC/0JFypL+kHrq/InWl0llltI3v6jJaoSDab3BzeWyAgd6mgVc+RxHcg+1hkJAkJlELZCEwYEVl+P9dBjQ+bXAOT3W87v3Oa1vnzxyJfHjD3AokRRNA3ZU0Yw1K767aOUwRKKm+Gd0TP35XzeS94T7BKDoRfoLfVoo6JIs6wTKp+PzSN888TUqsW1cNHIxkScoihA2XIsimhZEk8VP5/IB4xwQ/Q4JAUW1r3MOD30BVnGJWcST+zjMBheyPA
 bcc4nGdw
 H3cJrBUrDPuOrkFp5fxkDfbi988ZJPfy392ngFc88FsAwFlb2Seo89vpoOVDLwj5SPU8Q1r7R4xAI0F56Mb/Pyv6AVieDtmo1SH36fLHxxipMiZbOq9Gb3wDHAwJtmYxX95pv8xCCgwmGWLOW1iKc9+DBqg7qsT6RsqqM3hqp2yRwPgJFzhK5AXM5obfIKqT+UzfkMPJfU2pRlfqoM5rjiXmMlX5RH/OkQ5qmj10OgSzcf2bn7hr2PVOohRJLcFEswg3lOyOCyc8NpeX0SlxeWzlJsBg4qzmXRS1r4Debd+JR8U3MNHIQNDegrkAunOwsoNmT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 16 Mar 2026 17:41:10 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> (trimmed mail list for sanity)
> 
> On Mon, Mar 16, 2026 at 09:17:04AM -0700, Andrew Morton wrote:
> > On Mon, 16 Mar 2026 13:07:49 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
> >
> > > This series converts a lot of the existing use of the legacy vm_flags_t
> > > data type to the new vma_flags_t type which replaces it.
> >
> > This series assumes the non-presence of your series "mm: expand
> > mmap_prepare functionality and usage".  Seems that series is due for a
> > respin so I'll drop v1.
> 
> Are there really that many clashes between the two?

I didn't look very closely - hit one reject and gave up.  Plus I'm not
sure that I kept up with all the -fixlets.

> I am working on a respin now, I can rebase that on this series if it helps.

Yes please.  I just pushed.

