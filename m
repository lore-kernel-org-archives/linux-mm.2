Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC9ACC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 14:39:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0260E6B024B; Tue,  1 Sep 2026 10:39:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F401E6B024C; Tue,  1 Sep 2026 10:39:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7DBA6B0250; Tue,  1 Sep 2026 10:39:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD2366B024B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:39:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 463DB160404
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:39:47 +0000 (UTC)
X-FDA: 85165452414.29.2F42D9B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf26.hostedemail.com (Postfix) with ESMTP id ED501140013
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:39:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="3IxuO/R2";
	spf=pass (imf26.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788273585;
	b=nFN/anh1UWsbXMxQUyBcnXadO/bDJOXOKdhRi4DrDJ9DuiH3zdPzZXOXDi5ZdBS9CZ9tHt
	MHcRcMc92aSYgzLWVssj/RVKMWb+d+rH5nrhhFDXkpLIDfFHC79r+16A7NtxG5QYrIpdGY
	s/N/qIXZfcP+ZQdyLRveScLyJKUwYiU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="3IxuO/R2";
	spf=pass (imf26.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788273585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JbptY317iCIcm32IzYm0oPV/KpXQWcrlQ6Fff3K8MvE=;
	b=UMYj3Www7SnAGRlEyATP99Sv7puOS0jZ6qz265t1nI9eTVMie14NSO5dhIEpJvLpGPzwza
	F2SdwsMnTInIuz/XXesPDp6E65pBqmR5YcHCEDHxbWwhN0qTqG/Po+8vVJF1kOmicq7P2U
	QVRV3i6mo+wluhYE/d/2B6Try6vNPNE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JbptY317iCIcm32IzYm0oPV/KpXQWcrlQ6Fff3K8MvE=; b=3IxuO/R2DAnNuaEFV3p2YTr4qw
	fswV62fbGGX+8PBkni88n6Ln2ftsLB0f6xyblLR2/f6y0QtWJl0PpkF/R4XXEgZvy32d7qZmuayFy
	Mc/ncMEgsCjVdq3cIiMe3c27FglZUuS4YnR6HWfN242upAdgX5te9Q3uMn2YNzW1gPpbhP9ymEFmF
	6pfJdFzJy79VYU7KYvanFsKObObz5V9GCJuqNCsyddGcgKoInKM4Nk6g/xvFtrx5wqBHC+7iHAVD+
	wGGGeGJJI1xQMl5YIjMHbgfzQBU4fFXoerQ3nHFNFpm2DqYsK5LHIYZEdbplCOPr9q8N/eAEW/BzM
	X8DhpbQA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x1PeF-0000000CMXh-1Q7u;
	Tue, 01 Sep 2026 14:39:39 +0000
Date: Tue, 1 Sep 2026 10:39:37 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH] maple_tree: Annotate lockless pivot reads for KCSAN
Message-ID: <ccgj2ukobxzdpypdi45vvapxbot56lsqmqfzzkcyrgnkjetybh@gghifhsc7v4t>
References: <20260826074430.1139325-1-hui.zhu@linux.dev>
 <20260826094147.42e1e71e91a5a537ced30a21@linux-foundation.org>
 <kpzm3pcwxwnzk5kngcsfcybzst5jtyrdcphd3hcpmoc6dbtswq@atn5yddl23qx>
 <f33eaa0c730feb9f598738ff79d98cb25b4b2bcd@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f33eaa0c730feb9f598738ff79d98cb25b4b2bcd@linux.dev>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ED501140013
X-Stat-Signature: e73sqxi1i1atg5s67hi7ikoh5bwea5er
X-Rspam-User: 
X-HE-Tag: 1788273584-366143
X-HE-Meta: U2FsdGVkX1/X1HmDzAgodsWT366rm1NXi682DuM/QIhfFt47ipWTPX1WVKx1IzzMgM2nvU/ChlnTqQpuYZONK9ULJ8vpEY9A6fCMaZygF2Jy0vhPvzA/KFGXCE+w43wCirLmFn6RYgKJbXD5d52SS2851wzKIEIIgc2tD3h9S4NYHnajkGkPRq7mhV/Rh44HmAaNZ56bbgcaQRHlvu7+u//14wdGI3rp+/WJdyP5xbNcenp3HULqFk3oDZ/Kb0RZgQeNgn2ZD7KGcpKsdjc3WQvyt4Ng7THcXUEQmYsBMP365CvHwDf5aRgpmkx2zF6wvD8ah694KJGc0j+PDoTgf82X4FEZHMpY0/wGVAkDFJBpRkFfz0mPu3bOfyTciDyGtP3HQdDdWxl1HehkNlRxLJW0piWGXX5kwIFWbLybph21zTLjej7QkfJ7S3jj6094hETMyKe7Z7YS54K9g/7hFHx5OFuqhDcIKpojlHCTKVXPEJzl07Dxktp7FdMZIqxFvZfHdxetwWsbsXM5IS3iporSntGukjRIxC00xiw2ani/CBUWHbQF3ZZSXCr0VkBWyjD/fyNujZlrhiFIhL9915tK2VA+3dh/weY22U0py+GhUqNApWTi9XeOkhs0KcFQRaghFx3zFU+aGr/uyRDpScBkvdAmKX6mPnnp3hVmovftCzsO0WGJxyulUkgoiQiR7+WkGF9bWFiE7L0sC30XXgIuQcbc/P2aTaVCPhjtb17fykPztUCYTE2yl0JR6cOYEHoKDmrBW35YydqlBX8UbKpGJblkwOO6MuMDgR6GglxWE4tMPotbPuKFM6ZzZqtkvmDYEyHHfiYLh//UuVMxBG1+O/oFycc6RXg9qVA8yogFGoI3de/uZB/mezdhv0jtGxcZVgIxs7b6GYx+PDp5plunYp5rhTtFJclCCWVb0Hi+ISj27vNuJz5YJS1PxVJScKISKNd1wuVVjtEkrS/
 YY5Y63HL
 Bz6pk7b1XyrqtI9Er0ZqkBuRxBKoTVlK+F2gxGdBDatzHwrcuiMQEKLRceRR1splqWG4QQqM6xdRTQ64Wgp1jCYIAFmdtofVctAdlnnQDDOPEvoHroUn44KdtnKP4LdP9PEyW069kJ2SNrcV6st/rhJXeLyWzOSwkGX+BM1llya6kClvGX0SGDM+wHNRbT4uTO+YohM9Bm9eFzir7S1dpnPXDzp/SOPmqO0fKSgS4nGX+lEu32CBl8HnW8owXIHv+AP/JKqvlS6OVfSaYot5i/5iUrvbQpg/3m1zpZZtbGEdSiHQ310G9nI34aVkLN3BHe2KWMtMvKPQLb6rPrX6CLasb4t83WDJVwgNYtXNaFyIQbfnlcglOwHYyOKzMUX516AS4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/08/27 05:35AM, Hui Zhu wrote:
> > 
> > On 26/08/26 09:41AM, Andrew Morton wrote:
> > 
> > > 
> > > On Wed, 26 Aug 2026 15:44:30 +0800 "Hui Zhu" <hui.zhu@linux.dev> wrote:
> > >  
> > >  In RCU mode, replaced maple nodes are marked dead and freed via RCU
> > >  after the new node has been published. Arming the RCU free writes
> > >  node->rcu.next and node->rcu.func, which share storage with
> > >  pivot[0] and pivot[1] (see struct maple_node), while lockless
> > >  readers may still walk the dead node. These stores therefore race
> > >  with the pivot loads performed by the walkers.
> > >  
> > >  This is harmless: the writer marks the node dead with an smp_wmb()
> > >  before arming the rcu_head, and the walkers re-check ma_dead_node()
> > >  after reading the node and restart the walk when the node is dead,
> > >  so any pivot read that raced with the rcu_head stores is discarded.
> > >  KCSAN cannot see this protocol and reports the plain accesses, so
> > >  annotate the lockless pivot reads with data_race() through a new
> > >  ma_pivot_rcu() helper.
> > >  
> > >  Found by fuzzing on a 6.6 kernel; the race still exists on
> > >  mainline. No functional change intended.
> > >  
> > >  
> > >  Thanks. AI review suggests that the patch is correct, but incomplete?
> > >  
> > >  https://sashiko.dev/#/patchset/20260826074430.1139325-1-hui.zhu@linux.dev
> > > 
> > Yes, this is literally every read of numerous pivots on any reader that
> > would need something like this. Most code is shared with the writer
> > side, so we'll have data_race() annotation where it is not needed there.
> > 
> > I don't like the name of the function and I don't agree that it is worth
> > doing, especially half of it. If you notice ma_ functions take a maple
> > node as the first argument, but your new function takes an array pointer
> > in the node.
> > 
> > The from address does not agree with the sign-off on the patch.
> > 
> > I also don't think a benign race needs a Fixes tag?
> > 
> > It might be worth looking at other ways to calm kcsans down such as the
> > type qualifier __data_racy, or maybe the makefile option.
> 
> Hi Liam,
> 
> __data_racy is defined as volatile for KCSAN kernels, so the qualifier
> has to propagate to every access site: ma_pivots() would return a
> volatile pointer, and all the "unsigned long *pivots" locals and helper
> parameters in maple_tree.c (about 25 sites) would need the qualifier
> too.
> It also marks the whole pivot array as racy, while only pivot[0] and
> pivot[1] actually overlap the rcu_head.

Isn't your change already using the data_racy annotation on more than
pivot 0 and 1?  For instance, mas->offset is often passed in and that
is likely not 0 or 1.

Fair point about the code churn, though.  I don't need every function
being changed to accept a volatile.

> 
> The Makefile option (KCSAN_SANITIZE_maple_tree.o := n) is a one-liner,
> but it disables KCSAN for the entire file, so any real data race
> introduced in maple_tree.c later would go unnoticed.

KCSAN has never reported anything real to me and that's why I suggested
turning it off.  After speaking with Paul McKenney on the matter I have
been convinced to not disable it.

I still don't really see a whole lot of value in annotating the code to
say a particular race is not an issue - we will have mostly disabled the
tool by annotation in the end.  And these are most likely going to be
the areas where we have issues if any arise - ie, some special arch
corner case that comes up that didn't exist or wasn't in mind during
annotation.

> 
> Do you think one of these two is still the better choice, or should I
> keep the current approach and fix the patch according to your review
> comments?
> 

I guess respin it and see how it looks with your current path.

Thanks,
Liam


